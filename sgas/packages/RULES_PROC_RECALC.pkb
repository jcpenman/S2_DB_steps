CREATE OR REPLACE PACKAGE BODY SGAS.rules_proc_recalc
AS
/******************************************************************************
   NAME:       RULES_PROC 
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description 
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/12/2012   Paul Hughes     Baselined for 2013
   1.1        09/09/2013   Paul Hughes     New 2013 Pay Loans updated.
   1.2        12/12/2013   Clark Bolan     Removal of pay Loans code 2014 change of session variable 
   1.3        01/11/2016   Clark Bolan     awardscreenvalues_doc updated to handle CESB students    
   1.4        29/10/2019   James Baird     Removed the @GRASS for course and institution tables.      
   1.5          27/01/2022   Ranj Benning       Updates for Timing of Payments
******************************************************************************/

FUNCTION getCorrectBenIncome(p_ja_case_id IN NUMBER) RETURN CHAR
IS 

    v_result CHAR;
    v_temp   NUMBER;
    
BEGIN    

select count(*) 
INTO v_temp
from sgas.stud_session
where ja_case_id IN(
select ja_case_id from sgas.stud_session
group by ja_case_id
having count(*) > 1)
and (ja_stud_type = 'C'
or ja_stud_type = 'P')
and ben1_rel_id = 28
and ben1_id IN(select ben2_id from sgas.stud_session
                where ja_case_id IN(
                select ja_case_id from sgas.stud_session
                group by ja_case_id
                having count(*) > 1)
                and (ja_stud_type = 'C'
                or ja_stud_type = 'P')
                and ben1_rel_id <> 28)
and ja_case_id = p_ja_case_id;

    CASE 
        WHEN v_temp > 0
        THEN v_result := 'Y';
        ELSE v_result := 'N';
    END CASE;
    
    RETURN v_result;
    
END getCorrectBenIncome;


----THIS WILL RETURN THE COURSE START DATE UNLESS THE STUDENT STARTED LATER AND HAS A STUDY START DATE PRESENT.
FUNCTION getStudyStartDate (p_stud_crse_year_id IN NUMBER) RETURN DATE
IS

    v_result DATE;
    v_temp  CHAR;
    
BEGIN

        SELECT sgas.rules_proc_recalc.checkStartDate(p_stud_crse_year_id)
        INTO v_temp
        FROM DUAL;
        
        IF v_temp = 'Y' --- STUDY START DATE EXISTS
            THEN 
                SELECT start_date
                INTO v_result
                FROM STUD_CRSE_YEAR
                WHERE stud_crse_year_id = p_stud_crse_year_id;
                
        ELSE 
        
                SELECT SGAS.RULES_PROC_RECALC.GETSTARTDATETERM(p_stud_crse_year_id,1)
                INTO v_result
                FROM DUAL;
                
       END IF;
       
       
       RETURN v_result;
       
       
END getStudyStartDate;


    

FUNCTION getPartYearAbroad (p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS

    v_result CHAR;
    v_number NUMBER;
    
BEGIN

        SELECT NVL(sgas.rules_proc_recalc.get_courselength(p_stud_crse_year_id),0) - NVL(SGAS.RULES_PROC_RECALC.GET_ABROAD_DAYS_IN_TERM(p_stud_crse_year_id),0)
        INTO v_number
        FROM DUAL;
       
        IF
            v_number >= 70
        THEN v_result := 'Y';
        ELSE v_result := 'N';
        END IF;

      
   RETURN v_result;
   
   END getPartYearAbroad;
        
----OLD getLocationIndicator Replaced as follows
      
FUNCTION getLocationIndicator(p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS

    v_result     CHAR;
    l_count      NUMBER;

BEGIN


        SELECT COUNT(*) 
        INTO l_count        
        FROM STUD_TERM_ADDR a, STUD_CRSE_YEAR b
        WHERE a.stud_ref_no = b.stud_ref_no
        AND b.stud_crse_year_id = p_stud_crse_year_id;
        
        IF l_count = 1
            THEN 
            
                SELECT location_ind
                INTO v_result
                        FROM STUD_TERM_ADDR a, STUD_CRSE_YEAR b
                        WHERE a.stud_ref_no = b.stud_ref_no
                        AND b.stud_crse_year_id = p_stud_crse_year_id;
                        
                        
        ELSE

      
                    SELECT LOCATION_IND
                    INTO v_result
                    FROM(
                    SELECT LOCATION_IND
                    FROM( 
                        SELECT  CASE
                        WHEN a.LOCATION_IND = 'W'
                        THEN 'E'
                        WHEN a.LOCATION_IND = 'O'
                        THEN 'H'
                        ELSE a.LOCATION_IND
                    END LOCATION_IND
                        FROM STUD_TERM_ADDR a, STUD_CRSE_YEAR b
                        WHERE a.stud_ref_no = b.stud_ref_no
                        AND b.stud_crse_year_id = p_stud_crse_year_id
                        AND TRUNC(a.start_date) <= TRUNC(sgas.rules_proc_recalc.getstudyenddate(p_stud_crse_year_id))
                        AND TRUNC(a.end_date) >= TRUNC(sgas.rules_proc_recalc.getstudystartdate(p_stud_crse_year_id))
                        UNION
                        SELECT  CASE
                        WHEN a.LOCATION_IND = 'W'
                        THEN 'E'
                        WHEN a.LOCATION_IND = 'O'
                        THEN 'H'
                        ELSE a.LOCATION_IND
                        END LOCATION_IND
                        FROM STUD_TERM_ADDR a, STUD_CRSE_YEAR b
                        WHERE a.stud_ref_no = b.stud_ref_no
                        AND b.stud_crse_year_id = p_stud_crse_year_id
                        AND TRUNC(a.start_date) <= TRUNC(sgas.rules_proc_recalc.getstudyenddate(p_stud_crse_year_id))
                        AND a.end_date IS NULL)
                        ORDER BY
                            (CASE
                                WHEN LOCATION_IND = 'L' THEN 0
                                WHEN LOCATION_IND = 'E' THEN 1
                                WHEN LOCATION_IND = 'H' THEN 2 END))     
                    WHERE ROWNUM < 2;    
                    
     END IF;

    RETURN v_result;

END getLocationIndicator;




----THIS FUNCTION SHOULD ONLY BE INVOKED FOR JA_CASES ONLY - DO NOT INVOKE IF THE STUDENT IS NOT A JA_CASE.  THIS SERVICE RETURNS THE NUMBER OF JA STUDENTS IN STEPS DB.
FUNCTION getNumberOfJACaseStudents (p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS

    l_result            NUMBER;
    l_temp              NUMBER;
    l_session           NUMBER;
    l_none_saas_stud    NUMBER;
    
BEGIN
     
    SELECT a.JA_CASE_ID, a.session_code
    INTO l_temp, l_session    
    FROM STUD_SESSION a, STUD_CRSE_YEAR b
    WHERE a.stud_session_id = b.stud_session_id
    AND b.stud_crse_year_id = p_stud_crse_year_id
    AND a.ja_case = 'Y';
 
    --Get none saas students so you can add that on to the result
    SELECT a.NO_NON_SAAS_CHILDREN
    INTO l_none_saas_stud
    FROM ja_case a
    WHERE JA_CASE_ID = l_temp;
   
    SELECT COUNT(*)
    INTO l_result
    FROM STUD_SESSION
    WHERE JA_CASE_ID = l_temp
    AND session_code = l_session;
    
    IF l_none_saas_stud > 0
    THEN
    
    l_result:= l_result + l_none_saas_stud;
   
    
    END IF;
    

    RETURN l_result;

END getNumberOfJACaseStudents;        
    
    
   

FUNCTION getCampusID (p_crse_id IN NUMBER, p_type IN CHAR) RETURN NUMBER
IS

    l_result    NUMBER;
    
BEGIN

            IF p_type = 'F'
        
        THEN 
            SELECT ca.campus_id
            INTO l_result
            FROM campus ca, crse c
            WHERE c.fees_campus = ca.campus_id
            AND c.crse_id = p_crse_id;
    ELSE
            SELECT ca.campus_id
            INTO l_result
            FROM campus ca, crse c
            WHERE c.maint_campus = ca.campus_id
            AND c.crse_id = p_crse_id;
            
     END IF;
   
RETURN l_result;

END getCampusID;
  

FUNCTION maxAwardExceeded (p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS

    l_count NUMBER;
    l_result    CHAR;

BEGIN

        SELECT COUNT(NET_AMOUNT) 
        INTO l_count
        FROM AWARD a, STUD_AWARD_TYPE b
        WHERE a.STUD_CRSE_YEAR_ID = p_stud_crse_year_id
        AND a.stud_award_type = b.stud_award_type
        AND b.type NOT IN('DSA','MAN','TRAV')
        AND a.NET_AMOUNT > MAX_AWARD;
        
        IF l_count > 0
        THEN l_result := 'Y';
        ELSE l_result := 'N';
        END IF;
        
        RETURN l_result;
        
END maxAwardExceeded;
       


FUNCTION countPrevAwardPayments (p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS

    l_count         NUMBER;
    l_session       NUMBER;
    l_stud_ref_no   NUMBER;
    
BEGIN

     SELECT SESSION_CODE, STUD_REF_NO
     INTO l_session, l_stud_ref_no
     FROM STUD_CRSE_YEAR
     WHERE stud_crse_year_id = p_stud_crse_year_id;
     
     SELECT COUNT(*)
     INTO l_count
     FROM AWARD a, AWARD_INSTALMENT b
     WHERE a.award_id = b.award_id
     AND a.stud_crse_year_id < p_stud_crse_year_id
     AND a.stud_ref_no = l_stud_ref_no
     AND a.session_code = l_session
     AND a.award_src = 'A'
     AND b.payment_status IN('S','P')
     AND b.returned IN('N','A','T');

    RETURN l_count;
    
END countPrevAwardPayments;

FUNCTION prevFees (p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS

    l_stud_ref_no   NUMBER;
    l_session_code  NUMBER;
    fees            NUMBER;
    l_result        CHAR;
    
BEGIN
    
    SELECT stud_ref_no, session_code
    INTO l_stud_ref_no, l_session_code
    FROM stud_crse_year
    WHERE stud_crse_year_id = p_stud_crse_year_id;
    
    
    SELECT count(*)
    INTO fees 
    FROM AWARD
    WHERE stud_crse_year_id < p_stud_crse_year_id
    AND session_code = l_session_code
    AND stud_ref_no = l_stud_ref_no
    AND award_src = 'T'
    AND net_amount > 0;
    
    IF fees > 0
    THEN l_result := 'Y';
    ELSE l_result := 'N';
    END IF;
    
 RETURN l_result;
 
 END prevFees;


--RETURNS THE FEE_CUT_OFF_DATE FOR ALL STUDENTS

FUNCTION fee_cut_off_date (p_stud_crse_year_id IN NUMBER) RETURN DATE
IS

    l_fee_cut_off_date  DATE;
    l_crse_start_date   DATE;
    l_session           NUMBER;
    l_scheme            CHAR(2);
    
BEGIN
    

        

     
     SELECT SESSION_CODE, SCHEME_TYPE
     INTO l_session, l_scheme
     FROM STUD_CRSE_YEAR
     WHERE stud_crse_year_id = p_stud_crse_year_id;
     
    
     
     IF l_scheme <> 'P'
            THEN 
                    SELECT cy.cutoff_date
                    INTO l_fee_cut_off_date
                    FROM STUD_CRSE_YEAR scy, CRSE_YEAR cy
                    WHERE scy.crse_year_id = cy.crse_year_id
                    AND scy.stud_crse_year_id = p_stud_crse_year_id;
                    
     ELSE
     
     
     
                 l_crse_start_date  := getStartDateTerm( p_stud_crse_year_id, 1);
                    
                 CASE
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-08',l_session),'DD-MM-YYYY') AND l_crse_start_date < TO_DATE(CONCAT('01-01',l_session+1),'DD-MM-YYYY')
                        THEN l_fee_cut_off_date := TO_DATE(CONCAT('01-12',l_session),'DD-MM-YYYY');
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-01',l_session+1),'DD-MM-YYYY') AND l_crse_start_date < TO_DATE(CONCAT('01-04',l_session+1),'DD-MM-YYYY')
                        THEN l_fee_cut_off_date := TO_DATE(CONCAT('01-03',l_session+1),'DD-MM-YYYY');
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-04',l_session+1),'DD-MM-YYYY') AND l_crse_start_date < TO_DATE(CONCAT('01-07',l_session+1),'DD-MM-YYYY')
                        THEN l_fee_cut_off_date := TO_DATE(CONCAT('01-06',l_session+1),'DD-MM-YYYY');
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-07',l_session+1),'DD-MM-YYYY') AND l_crse_start_date <= TO_DATE(CONCAT('31-12',l_session+1),'DD-MM-YYYY')
                        THEN l_fee_cut_off_date := TO_DATE(CONCAT('01-12',l_session+1),'DD-MM-YYYY');
                   ELSE NULL;
                 END CASE;
              
     
        
     END IF;
     
     RETURN l_fee_cut_off_date;
     
END fee_cut_off_date;

FUNCTION getattendfeecutoffdate (p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS

    l_fee_cut_off_date      DATE;
    l_min_start_date        DATE;
    l_max_end_date          DATE;
    l_crse_start_date       DATE;
    l_result                CHAR(1);
    l_check_date            CHAR(1);
    
BEGIN    

    l_crse_start_date  := getStartDateTerm( p_stud_crse_year_id, 1);
    l_check_date       := checkStartDate (p_stud_crse_year_id);
    l_max_end_date     := getStudyEndDate (p_stud_crse_year_id);
    l_fee_cut_off_date := fee_cut_off_date (p_stud_crse_year_id);
    

    
    
        IF l_check_date = 'N'
            THEN l_min_start_date := l_crse_start_date;
            
        ELSE 
            SELECT start_date
            INTO l_min_start_date
            FROM stud_crse_year scy
            WHERE scy.stud_crse_year_id = p_stud_crse_year_id;
            
        END IF;
    
        
        IF l_max_end_date < l_fee_cut_off_date
            THEN l_result := 'N';
            
        ELSIF l_min_start_date > l_fee_cut_off_date
            THEN l_result := 'N';
        ELSE l_result := 'Y';
        
        END IF;
        
     RETURN l_result;
     
  END getattendfeecutoffdate;


--RETURNS THE EARLIEST DATE BETWEEN THE COURSE END DATE, WITHDRAW_DATE OR CRSE_CHANGE_DATE

FUNCTION getStartDateTerm (p_stud_crse_year_id IN NUMBER, p_term_no NUMBER)
RETURN DATE

IS 

    l_start_date DATE;
    l_default_term CHAR(1);
    l_max_term CHAR(2);
    
BEGIN

        l_default_term := check_default_terms (p_stud_crse_year_id);
        l_max_term     := number_of_terms (p_stud_crse_year_id);
        
      IF p_term_no <= l_max_term
      
        THEN  
      
        IF l_default_term = 'Y'
        
        THEN
            
                SELECT it.start_date
                INTO l_start_date
                FROM inst_term it, stud_crse_year scy
                WHERE scy.inst_code = it.inst_code
                AND scy.session_code = it.session_code
                AND it.term_no = p_term_no
                AND scy.stud_crse_year_id = p_stud_crse_year_id;
              
            ELSE 
            
                SELECT NVL(ct.start_date,TO_DATE('01/01/9999','DD/MM/YYYY'))
                INTO l_start_date 
                from crse_term ct, stud_crse_year scy
                WHERE scy.crse_year_id = ct.crse_year_id
                AND ct.term_no = p_term_no
                AND scy.stud_crse_year_id = p_stud_crse_year_id;
                
           END IF;
                
       ELSE l_start_date := null;
       
       END IF;
       
       RETURN l_start_date;
       
 END getStartDateTerm;
       
       
--THIS FUNCTION WILL RETURN 'Y' only if Previous Session Years provisional flag was set to 'Y'.  Otherwise it will be set to 'N' even if no prev session exists.    
FUNCTION getPrevSessionProvisionalFlag (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
RETURN CHAR
IS

    l_prevSessionFlag   CHAR(1) := 'N';
    l_prev_session      NUMBER(4);
    
BEGIN

        l_prev_session := p_session_code - 1;
        
        IF l_prev_session < steps_release_year  --WE NEED TO CHECK GRASS
        
            THEN select a.provisional_case
                 INTO l_prevSessionFlag
                 FROM stud_crse_year@grass a
                 WHERE a.stud_ref_no = p_stud_ref_no
                 AND a.session_code = l_prev_session
                 AND a.latest_crse_ind = 'Y';
                 
        ELSE    select a.provisional_case
                 INTO l_prevSessionFlag
                 FROM stud_crse_year a
                 WHERE a.stud_ref_no = p_stud_ref_no
                 AND a.session_code = l_prev_session
                 AND a.latest_crse_ind = 'Y'; 
                 
         END IF;
         
         
         RETURN l_prevSessionFlag;
         
END getPrevSessionProvisionalFlag;


FUNCTION getStudyEnddate (p_stud_crse_year_id IN NUMBER)
    RETURN DATE
IS
    l_crse_change_date      DATE;
    l_crse_end_date         DATE;
    l_withdraw_date         DATE;
    l_default_term          CHAR(1);
    l_max_term              NUMBER;
    l_studyEnddate          DATE;

    
BEGIN

        SELECT NVL(scy.crse_chg,TO_DATE ('01-JAN-9999','DD-MM-YYYY')), NVL(scy.withdraw_date,TO_DATE ('01-JAN-9999','DD-MM-YYYY'))
        INTO l_crse_change_date, l_withdraw_date
        FROM stud_crse_year scy
        WHERE stud_crse_year_id = p_stud_crse_year_id;
        
        
        
        l_default_term := check_default_terms (p_stud_crse_year_id); 
        l_max_term     := number_of_terms (p_stud_crse_year_id);
        
        IF l_default_term = 'Y'
        
            THEN
            
                SELECT it.end_date
                INTO l_crse_end_date 
                FROM inst_term it, stud_crse_year scy
                WHERE scy.inst_code = it.inst_code
                AND scy.session_code = it.session_code
                AND it.term_no = l_max_term
                AND scy.stud_crse_year_id = p_stud_crse_year_id;
              
            ELSE 
            
                SELECT ct.end_date
                INTO l_crse_end_date 
                from crse_term ct, stud_crse_year scy
                WHERE scy.crse_year_id = ct.crse_year_id
                AND ct.term_no = l_max_term
                AND scy.stud_crse_year_id = p_stud_crse_year_id;
            

            END IF;
            
            ---FROM THE VALUES SET ABOVE FIND THE MINIMUM DATE BETWEEN THE 3 OF THESE AND RETURN THIS.
        
            CASE
                WHEN l_crse_end_date <= l_crse_change_date AND l_crse_end_date <= l_withdraw_date
                    THEN l_studyEnddate := l_crse_end_date;
                WHEN l_crse_change_date <= l_crse_end_date AND l_crse_change_date <= l_withdraw_date
                    THEN l_studyEnddate := l_crse_change_date;
                WHEN l_withdraw_date <= l_crse_end_date AND l_withdraw_date <= l_crse_change_date
                    THEN l_studyEnddate := l_withdraw_date;
           END CASE;
           
           RETURN l_studyEnddate;
        
   END getStudyEnddate;
   
FUNCTION getStudyEnddate_2022 (p_stud_crse_year_id IN NUMBER)
    RETURN DATE
    
    --OVERPAYEMTS CHANGE 2022 don't look at withdrawal date when calculating 
    --numberOfPaymentdates
IS
    --l_crse_change_date      DATE;
    l_crse_end_date         DATE;
    l_default_term          CHAR(1);
    l_max_term              NUMBER;
    l_studyEnddate          DATE;

    
BEGIN

       /*
        SELECT NVL(scy.crse_chg,TO_DATE ('01-JAN-9999','DD-MM-YYYY'))
        INTO l_crse_change_date
        FROM stud_crse_year scy
        WHERE stud_crse_year_id = p_stud_crse_year_id;
        */
        
        
        l_default_term := check_default_terms (p_stud_crse_year_id); 
        l_max_term     := number_of_terms (p_stud_crse_year_id);
        
        IF l_default_term = 'Y'
        
            THEN
            
                SELECT it.end_date
                INTO l_crse_end_date 
                FROM inst_term it, stud_crse_year scy
                WHERE scy.inst_code = it.inst_code
                AND scy.session_code = it.session_code
                AND it.term_no = l_max_term
                AND scy.stud_crse_year_id = p_stud_crse_year_id;
              
            ELSE 
            
                SELECT ct.end_date
                INTO l_crse_end_date 
                from crse_term ct, stud_crse_year scy
                WHERE scy.crse_year_id = ct.crse_year_id
                AND ct.term_no = l_max_term
                AND scy.stud_crse_year_id = p_stud_crse_year_id;
            

            END IF;
            
            ---FROM THE VALUES SET ABOVE FIND THE MINIMUM DATE.
        /*
            CASE
                WHEN l_crse_end_date <= l_crse_change_date 
                    THEN l_studyEnddate := l_crse_end_date;
                WHEN l_crse_change_date <= l_crse_end_date 
                    THEN l_studyEnddate := l_crse_change_date;
           END CASE;
           */
           l_studyEnddate := l_crse_end_date;
           
           RETURN l_studyEnddate;
        
   END getStudyEnddate_2022;

FUNCTION getTopStudyEnddate (p_stud_crse_year_id IN NUMBER)
   RETURN DATE
IS
   l_crse_change_date   DATE;
   l_crse_end_date      DATE;
   l_withdraw_date      DATE;
   l_default_term       CHAR (1);
   l_max_term           NUMBER;
   l_studyEnddate       DATE;

   l_crse_start_date    DATE;
BEGIN
   SELECT NVL (scy.crse_chg, TO_DATE ('01-JAN-9999', 'DD-MM-YYYY')),
          NVL (scy.withdraw_date, TO_DATE ('01-JAN-9999', 'DD-MM-YYYY'))
     INTO l_crse_change_date, l_withdraw_date
     FROM stud_crse_year scy
    WHERE stud_crse_year_id = p_stud_crse_year_id;

   l_default_term := check_default_terms (p_stud_crse_year_id);
   l_max_term := number_of_terms (p_stud_crse_year_id);

   IF l_default_term = 'Y'
   THEN
      SELECT it.start_date
        INTO l_crse_start_date
        FROM inst_term it, stud_crse_year scy
       WHERE     it.inst_code = scy.inst_code
             AND it.session_code = scy.session_code
             AND scy.stud_crse_year_id = p_stud_crse_year_id
             AND it.term_no = 1;

      SELECT TO_DATE (LAST_DAY (ADD_MONTHS (l_crse_start_date, 11)),
                      'DD/MM/YY')
        INTO l_crse_end_date
        FROM DUAL;
   ELSE
      SELECT ct.start_date
        INTO l_crse_start_date
        FROM crse_term ct, stud_crse_year scy
       WHERE     scy.crse_year_id = ct.crse_year_id
             AND ct.term_no = 1
             AND scy.stud_crse_year_id = p_stud_crse_year_id;

      SELECT TO_DATE (LAST_DAY (ADD_MONTHS (l_crse_start_date, 11)),
                      'DD/MM/YY')
        INTO l_crse_end_date
        FROM DUAL;
   END IF;
   
   CASE
      WHEN     l_crse_end_date <= l_crse_change_date
           AND l_crse_end_date <= l_withdraw_date
      THEN
         l_studyEnddate := l_crse_end_date;
      WHEN     l_crse_change_date <= l_crse_end_date
           AND l_crse_change_date <= l_withdraw_date
      THEN
         l_studyEnddate := l_crse_change_date;
      WHEN     l_withdraw_date <= l_crse_end_date
           AND l_withdraw_date <= l_crse_change_date
      THEN
         l_studyEnddate := l_withdraw_date;
   END CASE;

   RETURN l_studyEnddate;
END getTopStudyEnddate;
   

FUNCTION getTopStudyEnddate_2022 (p_stud_crse_year_id IN NUMBER)
   RETURN DATE
IS
   l_crse_change_date   DATE;
   l_crse_end_date      DATE;
   l_withdraw_date      DATE;
   l_default_term       CHAR (1);
   l_max_term           NUMBER;
   l_studyEnddate       DATE;

   l_crse_start_date    DATE;
BEGIN
   SELECT NVL (scy.crse_chg, TO_DATE ('01-JAN-9999', 'DD-MM-YYYY'))--,
          --NVL (scy.withdraw_date, TO_DATE ('01-JAN-9999', 'DD-MM-YYYY'))
     INTO l_crse_change_date--, l_withdraw_date
     FROM stud_crse_year scy
    WHERE stud_crse_year_id = p_stud_crse_year_id;

   l_default_term := check_default_terms (p_stud_crse_year_id);
   l_max_term := number_of_terms (p_stud_crse_year_id);

   IF l_default_term = 'Y'
   THEN
      SELECT it.start_date
        INTO l_crse_start_date
        FROM inst_term it, stud_crse_year scy
       WHERE     it.inst_code = scy.inst_code
             AND it.session_code = scy.session_code
             AND scy.stud_crse_year_id = p_stud_crse_year_id
             AND it.term_no = 1;

      SELECT TO_DATE (LAST_DAY (ADD_MONTHS (l_crse_start_date, 11)),
                      'DD/MM/YY')
        INTO l_crse_end_date
        FROM DUAL;
   ELSE
      SELECT ct.start_date
        INTO l_crse_start_date
        FROM crse_term ct, stud_crse_year scy
       WHERE     scy.crse_year_id = ct.crse_year_id
             AND ct.term_no = 1
             AND scy.stud_crse_year_id = p_stud_crse_year_id;

      SELECT TO_DATE (LAST_DAY (ADD_MONTHS (l_crse_start_date, 11)),
                      'DD/MM/YY')
        INTO l_crse_end_date
        FROM DUAL;
   END IF;
   
   CASE
      WHEN     l_crse_end_date <= l_crse_change_date
          -- AND l_crse_end_date <= l_withdraw_date
      THEN
         l_studyEnddate := l_crse_end_date;
      WHEN     l_crse_change_date <= l_crse_end_date
          -- AND l_crse_change_date <= l_withdraw_date
      THEN
         l_studyEnddate := l_crse_change_date;
     -- WHEN     l_withdraw_date <= l_crse_end_date
       --    AND l_withdraw_date <= l_crse_change_date
      --THEN
         l_studyEnddate := l_crse_end_date;
   END CASE;

   RETURN l_studyEnddate;
END getTopStudyEnddate_2022;
   
   
---THIS SERVICE SIMPLY DISPLAYS 'Y' if start_date is present, and 'N' if start date is NOT present   
FUNCTION checkStartDate (p_stud_crse_year_id IN NUMBER)
RETURN CHAR
IS
        l_result        CHAR(1);
        l_start_date    DATE;
        
BEGIN

    SELECT start_date
    INTO l_start_date
    FROM stud_crse_year
    WHERE stud_crse_year_id = p_stud_crse_year_id;
    
    CASE 
        WHEN l_start_date IS null
        THEN l_result := 'N';
        ELSE l_result := 'Y';
    END CASE;
    
        RETURN l_result;
        
END checkStartDate;

---THIS SERVICE SIMPLY DISPLAYS 'Y' if withdraw date is present, and 'N' if withdraw date is NOT present   
FUNCTION checkWithdrawtDate (p_stud_crse_year_id IN NUMBER)
RETURN CHAR
IS
        l_result            CHAR(1);
        l_withdraw_date    DATE;
        
BEGIN

    SELECT withdraw_date
    INTO l_withdraw_date
    FROM stud_crse_year
    WHERE stud_crse_year_id = p_stud_crse_year_id;
    
    CASE 
        WHEN l_withdraw_date IS null
        THEN l_result := 'N';
        ELSE l_result := 'Y';
    END CASE;
    
        RETURN l_result;
        
END checkWithdrawtDate;
   

FUNCTION checkWithdrawOrCrseChng (p_stud_crse_year_id IN NUMBER)
RETURN CHAR
IS
        l_result            CHAR(1);
        l_withdraw_date    DATE;
        l_crse_chg         DATE;
        
BEGIN

    SELECT a.withdraw_date, crse_chg
    INTO l_withdraw_date, l_crse_chg
    FROM stud_crse_year a
    WHERE stud_crse_year_id = p_stud_crse_year_id;
    
    CASE 
        WHEN l_withdraw_date IS null AND l_crse_chg IS null
        THEN l_result := 'N';
        ELSE l_result := 'Y';
    END CASE;
    
        RETURN l_result;
        
END checkWithdrawOrCrseChng;
   


FUNCTION getpaidrecords (p_award_id IN NUMBER)
    RETURN CHAR
IS
    l_records_paid      NUMBER := 0;
    l_result            CHAR(1) := 'N';
    
BEGIN
        SELECT COUNT(*)
        INTO  l_records_paid
        FROM AWARD_INSTALMENT
        WHERE AWARD_ID = p_award_id
        AND payment_status IN('S','P')
        AND returned IN('N','A','T');
        
        CASE 
            WHEN l_records_paid = 0
            THEN l_result := 'N';
            ELSE l_result := 'Y';
        END CASE;
        
        RETURN l_result;
        
   END getpaidrecords;
   
FUNCTION getpaidfees (p_stud_crse_year_id IN NUMBER)
    RETURN CHAR
IS
    l_records_paid      NUMBER := 0;
    l_total_records     NUMBER := 0;
    l_records_feeloan   NUMBER := 0;
    l_result            CHAR(1):= 'N';
    
BEGIN
      /*CHANGED TO NET AMOUNT 29/04/2014 CB*/ 
   SELECT NVL(SUM(b.net_amount),0)
     INTO l_records_paid
     FROM award a, award_instalment b
    WHERE a.award_id = b.award_id
      AND a.award_src = 'T'
      AND b.payment_status IN('S', 'P')
      AND returned IN('N','A','T')
      AND a.stud_crse_year_id = p_stud_crse_year_id;
      
     /*CHANGED TO NET AMOUNT 29/04/2014 CB*/ 
     SELECT NVL(SUM(b.net_amount),0)
     INTO l_records_feeloan
     FROM award a, award_instalment b
    WHERE a.award_id = b.award_id
      AND a.award_src = 'T'
      AND b.payment_status = 'U'
      AND b.FEE_LOAN_TRANSACTION_CREATED = 'Y'  
      AND a.stud_crse_year_id = p_stud_crse_year_id;
      
      l_total_records := (l_records_paid + l_records_feeloan);    
     
      
       CASE 
            WHEN l_total_records > 0 
                 THEN l_result := 'Y';
            ELSE l_result := 'N';
        END CASE;
        
        RETURN l_result;
        
   END getpaidfees;
   

FUNCTION get_ja_studs_reg (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
IS
   l_ja_case_id             NUMBER := 0;
   l_no_non_saas_children   NUMBER := 0;
   l_count_ja_case_id       NUMBER := 0;
   l_ja_studs_reg           NUMBER := 0;
BEGIN
   SELECT NVL (ja_case_id, 0)
     INTO l_ja_case_id
     FROM stud_session a, stud_crse_year b
     WHERE a.stud_session_id = b.stud_session_id
     AND b.stud_crse_year_id = p_stud_crse_year_id;
     

   IF l_ja_case_id = 0
   THEN
      l_ja_studs_reg := 0;
   ELSE
      SELECT COUNT (ja_case_id)
        INTO l_count_ja_case_id
        FROM stud_session
       WHERE ja_case_id = l_ja_case_id;

      SELECT NVL (a.no_non_saas_children, 0)
        INTO l_no_non_saas_children
        FROM ja_case a
       WHERE ja_case_id = l_ja_case_id;

      l_ja_studs_reg := l_count_ja_case_id + l_no_non_saas_children;
   END IF;

   RETURN l_ja_studs_reg;
END get_ja_studs_reg;



FUNCTION getEndDateTerm (p_stud_crse_year_id IN NUMBER, p_term_no IN NUMBER)
    RETURN DATE
IS

    l_term_end_date         DATE;
    l_default_term          CHAR(1);
    l_studyEnddate          DATE;

    
BEGIN   
        
        l_default_term := check_default_terms (p_stud_crse_year_id); 
        
        IF l_default_term = 'Y'
        
            THEN
            
                SELECT it.end_date
                INTO l_term_end_date
                FROM inst_term it, stud_crse_year scy
                WHERE scy.inst_code = it.inst_code
                AND scy.session_code = it.session_code
                AND it.term_no = p_term_no
                AND scy.stud_crse_year_id = p_stud_crse_year_id;
              
            ELSE 
            
                SELECT ct.end_date
                INTO l_term_end_date
                from crse_term ct, stud_crse_year scy
                WHERE scy.crse_year_id = ct.crse_year_id
                AND ct.term_no = p_term_no
                AND scy.stud_crse_year_id = p_stud_crse_year_id;
            

            END IF;
            
RETURN  l_term_end_date;

END  getEndDateTerm;

/*The Function below will take in the stud_crse_year_id and will
query the abroad_start_date and check if it is inbetween a term it will then 
bump the date forward to the start date of the next term*/
FUNCTION abroad_startdate_between_terms (p_stud_crse_year_id IN NUMBER)
RETURN DATE
IS

    l_abroad_start_date DATE;
    l_term1_ed  DATE;
    l_term2_sd  DATE;
    l_term2_ed  DATE;
    l_term3_sd  DATE;
    l_term3_ed  DATE;
    l_term4_sd  DATE;

    
BEGIN

    SELECT NVL(A.START_DATE_ABROAD,TO_DATE ('01-JAN-1900','DD-MM-YYYY'))
    INTO l_abroad_start_date
    FROM STUD_CRSE_YEAR A
    WHERE a.stud_crse_year_id = p_stud_crse_year_id;

    l_term1_ed := SGAS.rules_proc_recalc.getEndDateTerm (p_stud_crse_year_id, 1);
    l_term2_sd := SGAS.rules_proc_recalc.getStartDateTerm (p_stud_crse_year_id, 2);
    l_term2_ed := SGAS.rules_proc_recalc.getEndDateTerm (p_stud_crse_year_id, 2);
    l_term3_sd := SGAS.rules_proc_recalc.getStartDateTerm (p_stud_crse_year_id, 3);
    l_term3_ed := SGAS.rules_proc_recalc.getEndDateTerm (p_stud_crse_year_id, 3);
    l_term4_sd := SGAS.rules_proc_recalc.getStartDateTerm (p_stud_crse_year_id, 4);
   
    
    IF ((l_abroad_start_date > l_term1_ed) AND (l_abroad_start_date < l_term2_sd)) THEN
            l_abroad_start_date :=  l_term2_sd;       
    
    ELSIF ((l_abroad_start_date > l_term2_ed) AND (l_abroad_start_date < l_term3_sd)) THEN
            l_abroad_start_date := l_term3_sd;
    
    ELSIF ((l_abroad_start_date > l_term3_ed) AND (l_abroad_start_date <  l_term4_sd)) THEN
            l_abroad_start_date := l_term4_sd; 
    END IF;
    
RETURN l_abroad_start_date;
    
END abroad_startdate_between_terms;

/*The Function below will take in the stud_crse_year_id and will
query the abroad_end_date and check if it is inbetween a term it will then 
bump the date back to the end date of the previous term*/
FUNCTION abroad_enddate_between_terms (p_stud_crse_year_id IN NUMBER)
RETURN DATE
IS

    l_abroad_end_date DATE;
    l_term1_ed  DATE;
    l_term2_sd  DATE;
    l_term2_ed  DATE;
    l_term3_sd  DATE;
    l_term3_ed  DATE;
    l_term4_sd  DATE;

    
BEGIN

    SELECT NVL(A.END_DATE_ABROAD,TO_DATE ('01-JAN-1900','DD-MM-YYYY'))
    INTO l_abroad_end_date
    FROM STUD_CRSE_YEAR A
    WHERE a.stud_crse_year_id = p_stud_crse_year_id;

    l_term1_ed := SGAS.rules_proc_recalc.getEndDateTerm (p_stud_crse_year_id, 1);
    l_term2_sd := SGAS.rules_proc_recalc.getStartDateTerm (p_stud_crse_year_id, 2);
    l_term2_ed := SGAS.rules_proc_recalc.getEndDateTerm (p_stud_crse_year_id, 2);
    l_term3_sd := SGAS.rules_proc_recalc.getStartDateTerm (p_stud_crse_year_id, 3);
    l_term3_ed := SGAS.rules_proc_recalc.getEndDateTerm (p_stud_crse_year_id, 3);
    l_term4_sd := SGAS.rules_proc_recalc.getStartDateTerm (p_stud_crse_year_id, 4);
   
    
    IF ((l_abroad_end_date > l_term1_ed) AND (l_abroad_end_date < l_term2_sd)) THEN
            l_abroad_end_date :=  l_term2_sd;       
    
    ELSIF ((l_abroad_end_date > l_term2_ed) AND (l_abroad_end_date < l_term3_sd)) THEN
            l_abroad_end_date := l_term3_sd;
    
    ELSIF ((l_abroad_end_date > l_term3_ed) AND (l_abroad_end_date <  l_term4_sd)) THEN
            l_abroad_end_date := l_term4_sd; 
    END IF;
    
RETURN l_abroad_end_date;
    
END abroad_Enddate_between_terms;

FUNCTION days_of_study (p_stud_crse_year_id IN NUMBER)
RETURN NUMBER
IS 

    l_get_abroad_days_in_term         NUMBER;
    l_days_of_study                   NUMBER;
    l_abroad_days_in_term_overlaps    NUMBER;
    l_temp                            NUMBER;

BEGIN

    l_temp := get_courselength (p_stud_crse_year_id);
    l_abroad_days_in_term_overlaps := abroad_days_in_term_overlaps (p_stud_crse_year_id);
    l_get_abroad_days_in_term := get_abroad_days_in_term (p_stud_crse_year_id);
    
    IF l_abroad_days_in_term_overlaps > l_get_abroad_days_in_term
    THEN
        l_days_of_study := l_temp + (l_abroad_days_in_term_overlaps - l_get_abroad_days_in_term);
    ELSE
        l_days_of_study := l_temp;
    END IF;
    
RETURN l_days_of_study;

END days_of_study;


FUNCTION abroad_days_in_term_overlaps (p_stud_crse_year_id IN NUMBER)
RETURN NUMBER
IS

    l_abroad_days                 NUMBER;
    l_abroad_days_with_overlaps   NUMBER :=0;
    l_start_date_abroad           DATE;
    l_end_date_abroad             DATE;
    l_term1_start_date            DATE;
    l_max_term_end_date           DATE;
    l_default_term                CHAR;
    l_max_terms                   NUMBER;
    l_temp_days                   NUMBER;
    l_start_portion               NUMBER :=0;
    l_end_portion                 NUMBER :=0;

BEGIN

    l_abroad_days := SGAS.rules_proc_recalc.get_abroad_days_in_term(p_stud_crse_year_id);
    l_default_term := check_default_terms (p_stud_crse_year_id); 
    l_max_terms := number_of_terms (p_stud_crse_year_id);
    
         SELECT NVL(A.END_DATE_ABROAD,TO_DATE ('01-JAN-1900','DD-MM-YYYY')), NVL(A.START_DATE_ABROAD, TO_DATE('01-JAN-1900','DD-MM-YYYY'))
         INTO l_end_date_abroad, l_start_date_abroad
         FROM STUD_CRSE_YEAR A
         WHERE a.stud_crse_year_id = p_stud_crse_year_id;
         
        IF l_default_term = 'Y'
        THEN
             SELECT a.start_date
             INTO l_term1_start_date
             FROM inst_term a, stud_crse_year b
             WHERE a.inst_code = b.inst_code
             AND a.session_code = b.session_code
             AND b.stud_crse_year_id = p_stud_crse_year_id
             AND a.term_no = 1;
             
             SELECT a.end_date
             INTO l_max_term_end_date
             FROM inst_term a, stud_crse_year b
             WHERE a.inst_code = b.inst_code
             AND a.session_code = b.session_code
             AND b.stud_crse_year_id = p_stud_crse_year_id
             AND a.term_no = l_max_terms;
         ELSE 
             SELECT a.start_date
             INTO l_term1_start_date
             FROM crse_term a, stud_crse_year b
             WHERE a.crse_year_id = b.crse_year_id
             AND b.stud_crse_year_id = p_stud_crse_year_id
             AND a.term_no = 1;
            
             SELECT a.end_date
             INTO l_max_term_end_date
             FROM crse_term a, stud_crse_year b
             WHERE a.crse_year_id = b.crse_year_id
             AND b.stud_crse_year_id = p_stud_crse_year_id
             AND a.term_no = l_max_terms;
             
         END IF;
         
         CASE 
            WHEN l_start_date_abroad < l_term1_start_date AND l_end_date_abroad > l_term1_start_date AND l_end_date_abroad < l_max_term_end_date  THEN
                 l_abroad_days_with_overlaps := (l_term1_start_date - l_start_date_abroad) + l_abroad_days;
            WHEN l_start_date_abroad < l_term1_start_date AND l_end_date_abroad < l_term1_start_date THEN
                 l_abroad_days_with_overlaps := (l_end_date_abroad +1 - l_start_date_abroad);
            WHEN l_start_date_abroad > l_term1_start_date AND l_end_date_abroad < l_max_term_end_date THEN
                 l_abroad_days_with_overlaps := l_abroad_days;
            WHEN l_start_date_abroad > l_term1_start_date AND l_end_date_abroad > l_max_term_end_date THEN
                 l_abroad_days_with_overlaps := (l_end_date_abroad  - l_max_term_end_date) + l_abroad_days ;
            WHEN l_start_date_abroad < l_term1_start_date AND l_end_date_abroad > l_max_term_end_date AND l_end_date_abroad > l_max_term_end_date THEN
                 l_start_portion :=  (l_term1_start_date - l_start_date_abroad);
                 l_end_portion := (l_end_date_abroad - l_max_term_end_date);     
                 l_abroad_days_with_overlaps := l_start_portion + l_end_portion + l_abroad_days + 1;
            WHEN l_start_date_abroad > l_max_term_end_date AND l_end_date_abroad > l_max_term_end_date THEN
                 l_abroad_days_with_overlaps := (l_end_date_abroad - l_start_date_abroad);
            WHEN l_start_date_abroad = l_term1_start_date AND l_end_date_abroad = l_max_term_end_date THEN
                 l_abroad_days_with_overlaps := l_abroad_days;
            WHEN l_start_date_abroad > l_term1_start_date AND l_end_date_abroad = l_max_term_end_date THEN
                 l_abroad_days_with_overlaps := l_abroad_days;
            WHEN l_start_date_abroad = l_term1_start_date AND l_end_date_abroad > l_max_term_end_date THEN
                 l_abroad_days_with_overlaps := (l_end_date_abroad - l_max_term_end_date) + l_abroad_days ;
            WHEN l_start_date_abroad < l_term1_start_date AND l_end_date_abroad = l_max_term_end_date THEN
                 l_abroad_days_with_overlaps := (l_term1_start_date  - l_start_date_abroad) + l_abroad_days;
            ELSE l_abroad_days_with_overlaps := l_abroad_days;
            END CASE;          
        
        RETURN l_abroad_days_with_overlaps;
              

END abroad_days_in_term_overlaps;

FUNCTION get_abroad_days_in_term (p_stud_crse_year_id IN NUMBER)
RETURN NUMBER
IS

    l_abroad_days1 NUMBER := 0;
    l_max_terms    NUMBER := 0;
    l_total_abroad_days NUMBER := 0;
    l_default_term CHAR(1) := 'N';
    l_end_date_abroad  DATE;
    l_start_date_abroad DATE;
    l_term_start_date DATE;
    l_term_end_date DATE;
    l_start DATE;
    l_end DATE;

      
BEGIN

    l_max_terms := number_of_terms (p_stud_crse_year_id);
    l_default_term := check_default_terms (p_stud_crse_year_id);   
    
         SELECT NVL(A.END_DATE_ABROAD,TO_DATE ('01-JAN-1900','DD-MM-YYYY')), NVL(A.START_DATE_ABROAD, TO_DATE('01-JAN-1900','DD-MM-YYYY'))
         INTO l_end_date_abroad, l_start_date_abroad
         FROM STUD_CRSE_YEAR A
         WHERE a.stud_crse_year_id = p_stud_crse_year_id;
                         
                        WHILE  l_max_terms > 0 AND l_default_term = 'Y' AND l_end_date_abroad <> TO_DATE('01-JAN-1900','DD-MM-YYYY') AND l_start_date_abroad <> TO_DATE('01-JAN-1900','DD-MM-YYYY')
                        LOOP
                        
                                SELECT a.start_date, a.end_date
                                INTO l_term_start_date, l_term_end_date
                                FROM inst_term a, stud_crse_year b
                                WHERE a.inst_code = b.inst_code
                                AND a.session_code = b.session_code
                                AND b.stud_crse_year_id = p_stud_crse_year_id
                                AND a.term_no = l_max_terms;
                                
                                IF l_term_end_date < l_end_date_abroad    ---WE NEED THE MIMIMUM OF THESE DATES
                                   THEN l_end := l_term_end_date;
                                   ELSE l_end := l_end_date_abroad;
                                END IF;
                                
                                IF l_term_start_date < l_start_date_abroad   --WE NEED THE MAXIMUM OF THESE DATES
                                    THEN l_start := l_start_date_abroad;
                                    ELSE l_start := l_term_start_date;
                                END IF; 
                        
                        SELECT NVL(TO_DATE(l_end, 'DD-MM-YYYY')+1 - TO_DATE(l_start,'DD-MM-YYYY'),0) 
                        INTO l_abroad_days1
                        FROM inst_term a, stud_crse_year b
                        WHERE a.inst_code = b.inst_code
                        AND a.session_code = b.session_code
                        AND b.stud_crse_year_id = p_stud_crse_year_id
                        AND a.term_no = l_max_terms;

                        IF l_abroad_days1 <= 0
                                THEN l_abroad_days1 := 0;
                           ELSE l_abroad_days1 := l_abroad_days1;
                        END IF;
                        
                        l_total_abroad_days := l_abroad_days1 + l_total_abroad_days;
                        
                        l_max_terms := l_max_terms - 1;
                        
                      END LOOP;

                        
                  WHILE (l_max_terms > 0 AND l_default_term = 'N' AND l_end_date_abroad <> TO_DATE('01-JAN-1900','DD-MM-YYYY') AND l_start_date_abroad <> TO_DATE('01-JAN-1900','DD-MM-YYYY'))
                  
                        LOOP
                        
                                SELECT a.start_date, a.end_date
                                INTO l_term_start_date, l_term_end_date
                                FROM crse_term a, stud_crse_year b
                                WHERE a.crse_year_id = b.crse_year_id
                                AND b.stud_crse_year_id = p_stud_crse_year_id
                                AND a.term_no = l_max_terms;
                        
                                 IF l_term_end_date < l_end_date_abroad    ---WE NEED THE MIMIMUM OF THESE DATES
                                   THEN l_end := l_term_end_date;
                                   ELSE l_end := l_end_date_abroad;
                                END IF;
                                
                                IF l_term_start_date < l_start_date_abroad   --WE NEED THE MAXIMUM OF THESE DATES
                                    THEN l_start := l_start_date_abroad;
                                    ELSE l_start := l_term_start_date;
                                END IF;
                        
                        SELECT NVL(TO_DATE(l_end, 'DD-MM-YYYY')+1 - TO_DATE(l_start,'DD-MM-YYYY'),0) 
                        INTO l_abroad_days1
                        FROM crse_term a, stud_crse_year b
                        WHERE a.crse_year_id = b.crse_year_id
                        AND b.stud_crse_year_id = p_stud_crse_year_id
                        AND a.term_no = l_max_terms;
                        
                         IF l_abroad_days1 <= 0
                              THEN l_abroad_days1 := 0;
                           ELSE l_abroad_days1 := l_abroad_days1;
                        END IF;
                        
                        l_total_abroad_days := l_abroad_days1 + l_total_abroad_days;
                        
                        l_max_terms := l_max_terms - 1;
                        
                        END LOOP;
                             
        RETURN l_total_abroad_days;

END get_abroad_days_in_term;       
 
       


FUNCTION get_max_year_no (p_stud_crse_year_id IN NUMBER)
    RETURN NUMBER
IS
    l_max_year_no NUMBER := 0;
BEGIN

    SELECT c.max_duration
    INTO l_max_year_no
    FROM sgas.stud_crse_year a, crse_year b, crse_session c
    WHERE a.crse_year_id = b.crse_year_id
    AND c.crse_session_id = b.crse_session_id
    AND a.stud_crse_year_id = p_stud_crse_year_id;

    RETURN l_max_year_no;
    
END get_max_year_no;


--THIS FUNCTION RETURNS THE MAXIMUM TERM NUMBER FOR A COURSE WHICH IS SET UP AND DOES NOT USE DEFAULT TERMS
FUNCTION get_max_term_no (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
   
IS

   l_max_term_no   NUMBER := 0;
   
BEGIN
   -- Get the last term date for the session
   SELECT MAX (term_no)
     INTO l_max_term_no
     FROM crse_term a, stud_crse_year b
    WHERE a.crse_year_id = b.crse_year_id
    AND   b.stud_crse_year_id = p_stud_crse_year_id;

   RETURN l_max_term_no;
   
END get_max_term_no;
    



--THIS FUNCTION RETURNS THE LAST TERM DATA FOR THE SESSION.
FUNCTION get_max_term_default (p_stud_crse_year_id   IN   NUMBER)
   RETURN NUMBER
   
IS

   l_max_term_default   NUMBER := 0;
   
BEGIN

   -- Get the last term date for the session
   SELECT MAX (term_no)
     INTO l_max_term_default
     FROM inst_term a, stud_crse_year b
    WHERE b.inst_code = a.inst_code
      AND b.session_code = a.session_code
      AND b.stud_crse_year_id = p_stud_crse_year_id;

   RETURN l_max_term_default;
   
END get_max_term_default;
    

FUNCTION check_default_terms (p_stud_crse_year_id IN NUMBER)
   RETURN CHAR
IS
   l_default_term   CHAR (1) := 'N';
   
BEGIN

   SELECT cy.default_terms
     INTO l_default_term
     FROM crse_year cy, stud_crse_year scy
    WHERE cy.crse_year_id = scy.crse_year_id
      AND scy.stud_crse_year_id = p_stud_crse_year_id;

   RETURN l_default_term;
   
END check_default_terms;


FUNCTION number_of_terms (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
IS
   l_default_term      CHAR (1)   := '';
   l_number_of_terms   NUMBER := 0;
   
BEGIN
   l_default_term := check_default_terms (p_stud_crse_year_id);

   IF l_default_term = 'Y'
   THEN
      l_number_of_terms :=
                         get_max_term_default (p_stud_crse_year_id);                                                                    
   ELSE
      l_number_of_terms := get_max_term_no (p_stud_crse_year_id);

   END IF;

   RETURN l_number_of_terms;
END number_of_terms;



FUNCTION final_year_check (p_stud_crse_year_id IN NUMBER)
   RETURN CHAR
IS
   l_max_year_no        NUMBER   := 0;
   l_crse_year_no       NUMBER   := 0;              
   l_final_year         CHAR (1) := '';
                                  
BEGIN

 l_max_year_no := get_max_year_no (p_stud_crse_year_id);

      SELECT crse_year_no
        INTO l_crse_year_no
        FROM stud_crse_year
         WHERE stud_crse_year_id = p_stud_crse_year_id;

      IF l_crse_year_no = l_max_year_no
      THEN
         l_final_year := 'Y';
      ELSE
         l_final_year := 'N';
      END IF;
 
   RETURN l_final_year;
END final_year_check;


--THIS FUNCTION IS USED TO DETERMINE THE TOTAL NUMBER OF DAYS THE COURSE A STUDENT IS STUDYING IS
FUNCTION get_courselength (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
IS
  
   l_default_term       CHAR (1)   := 'N';
   l_courselength       NUMBER;
   
BEGIN

   l_default_term := check_default_terms (p_stud_crse_year_id);

   IF l_default_term = 'Y'
   THEN
   
       SELECT SUM(days) 
       INTO l_courselength
       from inst_term a, stud_crse_year b
       where a.inst_code = b.inst_code
       AND a.session_code = b.session_code
       AND b.stud_crse_year_id = p_stud_crse_year_id;

   ELSE
   
      SELECT SUM (days)
        INTO l_courselength
        FROM crse_term a, stud_crse_year b
       WHERE a.crse_year_id = b.crse_year_id
         AND b.stud_crse_year_id = p_stud_crse_year_id;

   END IF;

   RETURN l_courselength;
END get_courselength;

FUNCTION getDaysInAttendanceInTerm(p_stud_crse_year_id IN NUMBER,   p_term_no IN NUMBER) RETURN NUMBER IS

    l_default_term CHAR(1);
    l_scystart  DATE;
    l_crsestart DATE;
    l_crseend   DATE;
    l_withdraw  DATE;
    l_crse_chg  DATE;
    l_days      NUMBER(4);
    l_start     DATE;
    l_end       DATE;

BEGIN

    l_default_term := check_default_terms (p_stud_crse_year_id);
    
    IF l_default_term = 'Y'
    
    THEN
    
                SELECT NVL(scy.start_date,TO_DATE('01/01/1800','DD/MM/YYYY')), NVL(scy.withdraw_date,TO_DATE('01/01/3000','DD/MM/YYYY')), 
                NVL(scy.crse_chg,TO_DATE('01/01/3000','DD/MM/YYYY')), it.start_date, it.end_date
                INTO l_scystart, l_withdraw, l_crse_chg, l_crsestart, l_crseend
                FROM stud_crse_year scy, inst_term it
                WHERE scy.stud_crse_year_id = p_stud_crse_year_id
                AND scy.inst_code = it.inst_code
                AND scy.session_code = it.session_code
                AND it.term_no = p_term_no;
                
    ELSE
    
                SELECT NVL(scy.start_date,TO_DATE('01/01/1800','DD/MM/YYYY')), NVL(scy.withdraw_date,TO_DATE('01/01/3000','DD/MM/YYYY')), 
                NVL(scy.crse_chg,TO_DATE('01/01/3000','DD/MM/YYYY')), ct.start_date, ct.end_date
                INTO l_scystart, l_withdraw, l_crse_chg, l_crsestart, l_crseend
                FROM stud_crse_year scy, crse_term ct
                WHERE scy.stud_crse_year_id = p_stud_crse_year_id
                AND scy.crse_year_id = ct.crse_year_id
                AND ct.term_no = p_term_no;

    END IF;
    
            ---WE NEED TO FIND THE MAX DATE BETWEEN SCY.START_DATE AND COURSE_START_DATE FOR TERM
            
                CASE
                    WHEN l_scystart >= l_crsestart
                     THEN l_start := l_scystart;
                    ELSE  l_start := l_crsestart;
                END CASE;
                
             -- WE NEED TO FIND THE MIN DATE BETWEEN SCY.WITHDRAW_DATE, SCY.CRSE_CHG AND COURSE END DATE FOR TERM       
             
               CASE
                WHEN l_withdraw <= l_crse_chg AND l_withdraw <= l_crseend
                    THEN l_end := l_withdraw;
                WHEN l_crse_chg <= l_withdraw AND l_crse_chg <= l_crseend
                    THEN l_end := l_crse_chg;
                WHEN l_crseend <= l_withdraw AND l_crseend <= l_crse_chg
                    THEN l_end := l_crseend;
                END CASE;
                
                
                IF l_start > l_end
                    THEN l_days := 0;
                    
                ELSE l_days := (l_end - l_start)+1;
                
                END IF;
    
                RETURN l_days;
    
    END getDaysInAttendanceInTerm;
    
 FUNCTION daysinattendance(P_STUD_CRSE_YEAR_ID in NUMBER) RETURN NUMBER IS
   daysInAttendance NUMBER := 0;
   l_no_terms NUMBER := 0;
  BEGIN
  
   -- get number of terms
   l_no_terms := number_of_terms(p_stud_crse_year_id);
   
   for idx in 1..l_no_terms loop
   
    daysInAttendance := daysInAttendance + getdaysinattendanceinterm(p_stud_crse_year_id, idx);
   
   end loop; 
   
    
    RETURN daysInAttendance;
  END daysinattendance;
  
FUNCTION daysInAttendanceNoWithdrawal (P_STUD_CRSE_YEAR_ID IN NUMBER)
   RETURN NUMBER
IS
   daysInAttendanceNoWithdrawal   NUMBER := 0;
   l_no_terms                     NUMBER := 0;
BEGIN
   -- get number of terms
   l_no_terms := number_of_terms (p_stud_crse_year_id);

   FOR idx IN 1 .. l_no_terms
   LOOP
      daysInAttendanceNoWithdrawal :=
           daysInAttendanceNoWithdrawal
         + getDaysInAttendanceInTermWithoutWithdrawal (p_stud_crse_year_id, idx);
   END LOOP;

   RETURN daysInAttendanceNoWithdrawal ;
END daysInAttendanceNoWithdrawal;

FUNCTION getDaysInAttendanceInTermWithoutWithdrawal(p_stud_crse_year_id IN NUMBER, p_term_no IN NUMBER) RETURN NUMBER IS

    l_default_term CHAR(1);
    l_crseend   DATE;
    l_days      NUMBER(4);
    l_start     DATE;
    l_end       DATE;

BEGIN

    l_default_term := check_default_terms (p_stud_crse_year_id);
    
    IF l_default_term = 'Y'
    
    THEN
    
                SELECT  
                it.start_date, it.end_date
                INTO l_start,  l_crseend
                FROM stud_crse_year scy, inst_term it
                WHERE scy.stud_crse_year_id = p_stud_crse_year_id
                AND scy.inst_code = it.inst_code
                AND scy.session_code = it.session_code
                AND it.term_no = p_term_no;
                
    ELSE
    
                SELECT  
                ct.start_date, ct.end_date
                INTO l_start, l_crseend
                FROM stud_crse_year scy, crse_term ct
                WHERE scy.stud_crse_year_id = p_stud_crse_year_id
                AND scy.crse_year_id = ct.crse_year_id
                AND ct.term_no = p_term_no;

    END IF;
    
                              
               --always set end date to course end date 
               l_end := l_crseend;
                
                IF l_start > l_end
                    THEN l_days := 0;
                    
                ELSE l_days := (l_end - l_start)+1;
                
                END IF;
    
                RETURN l_days ;
    
    END getDaysInAttendanceInTermWithoutWithdrawal;

FUNCTION getwithdrawelterm (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
   
IS

   l_withdrawterm_no   NUMBER;
   l_default_term      CHAR (1);
   l_withdraw_exist    CHAR(1);
   
BEGIN

        l_withdraw_exist := checkWithdrawtDate(p_stud_crse_year_id);
   
        IF l_withdraw_exist = 'Y'
        
            THEN
      
                    l_default_term := check_default_terms (p_stud_crse_year_id); 
                    
                   IF l_default_term = 'Y'
                   
                        THEN
                    
                         SELECT a.term_no
                           INTO l_withdrawterm_no
                           FROM inst_term a, stud_crse_year b
                          WHERE TRUNC(b.withdraw_date) BETWEEN TRUNC (a.start_date)
                                                           AND TRUNC (a.end_date)
                            AND b.inst_code = a.inst_code
                            AND a.session_code = b.session_code
                            AND b.stud_crse_year_id = p_stud_crse_year_id;

                    ELSE
                    
                         SELECT a.term_no
                           INTO l_withdrawterm_no
                           FROM crse_term a, stud_crse_year b
                          WHERE TRUNC (b.withdraw_date) BETWEEN TRUNC (a.start_date)
                                                           AND TRUNC (a.end_date)
                            AND a.crse_year_id = b.crse_year_id
                            AND b.stud_crse_year_id = p_stud_crse_year_id; 
                            
                     END IF;
                     
            ELSE l_withdrawterm_no := NULL;
            
        END IF;

   RETURN l_withdrawterm_no;
END getwithdrawelterm;
 

---THIS FUNCTION GETS THE TERM NUMBER IN WHICH THE STUDENT STARTED THERE COURSE
FUNCTION getstudystartterm (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
IS

   l_studystartterm   NUMBER;
   l_default_term     CHAR (1);
   l_start_date_exist   CHAR(1);
   
BEGIN

   l_start_date_exist := checkStartDate(p_stud_crse_year_id);
   
        IF l_start_date_exist = 'Y'
        
            THEN
      
                    l_default_term := check_default_terms (p_stud_crse_year_id); 
                    
                   IF l_default_term = 'Y'
                   
                        THEN
                    
                         SELECT a.term_no
                           INTO l_studystartterm
                           FROM inst_term a, stud_crse_year b
                          WHERE TRUNC(b.start_date) BETWEEN TRUNC (a.start_date)
                                                           AND TRUNC (a.end_date)
                            AND b.inst_code = a.inst_code
                            AND a.session_code = b.session_code
                            AND b.stud_crse_year_id = p_stud_crse_year_id;

                    ELSE
                    
                         SELECT a.term_no
                           INTO l_studystartterm
                           FROM crse_term a, stud_crse_year b
                          WHERE TRUNC (b.start_date) BETWEEN TRUNC (a.start_date)
                                                           AND TRUNC (a.end_date)
                            AND a.crse_year_id = b.crse_year_id
                            AND b.stud_crse_year_id = p_stud_crse_year_id; 
                            
                     END IF;
                     
            ELSE l_studystartterm := 1;
            
        END IF;
   

   RETURN l_studystartterm;
END getstudystartterm;


FUNCTION getstudyendterm (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
IS

   l_studyendterm   NUMBER;
   l_default_term     CHAR (1);
   l_study_end_date   DATE;
   
BEGIN

            l_study_end_date := getStudyEnddate (p_stud_crse_year_id);
            
      
             l_default_term := check_default_terms (p_stud_crse_year_id); 
                    
                   IF l_default_term = 'Y'
                   
                        THEN
                    
                         SELECT a.term_no
                           INTO l_studyendterm
                           FROM inst_term a, stud_crse_year b
                          WHERE TRUNC(l_study_end_date) BETWEEN TRUNC (a.start_date)
                                                           AND TRUNC (a.end_date)
                            AND b.inst_code = a.inst_code
                            AND a.session_code = b.session_code
                            AND b.stud_crse_year_id = p_stud_crse_year_id;

                    ELSE
                    
                         SELECT a.term_no
                           INTO l_studyendterm
                           FROM crse_term a, stud_crse_year b
                          WHERE TRUNC (l_study_end_date) BETWEEN TRUNC (a.start_date)
                                                           AND TRUNC (a.end_date)
                            AND a.crse_year_id = b.crse_year_id
                            AND b.stud_crse_year_id = p_stud_crse_year_id; 
                            
                     END IF;

   RETURN l_studyendterm;
   
END getstudyendterm;


FUNCTION check_ben1_exists (p_stud_crse_year_id IN NUMBER)
   RETURN CHAR
IS
   CURSOR ben_exists
   IS
      SELECT 'Y'
        FROM stud_session ss, stud_crse_year scy
       WHERE ss.stud_session_id = scy.stud_session_id
         AND scy.stud_crse_year_id = p_stud_crse_year_id
         AND ss.ben1_id IS NOT NULL;

   l_result   CHAR (1) := 'N';
BEGIN
   OPEN ben_exists;

   FETCH ben_exists
    INTO l_result;

   CLOSE ben_exists;

   RETURN l_result;
END check_ben1_exists;
   

FUNCTION check_ben2_exists (p_stud_crse_year_id IN NUMBER)
   RETURN CHAR
IS
   CURSOR ben_exists
   IS
      SELECT 'Y'
        FROM stud_session ss, stud_crse_year scy
       WHERE ss.stud_session_id = scy.stud_session_id
         AND scy.stud_crse_year_id = p_stud_crse_year_id
         AND ss.ben2_id IS NOT NULL;

   l_result   CHAR (1) := 'N';
BEGIN
   OPEN ben_exists;

   FETCH ben_exists
    INTO l_result;

   CLOSE ben_exists;

   RETURN l_result;
END check_ben2_exists;
   
FUNCTION get_missingben1data (p_stud_crse_year_id IN NUMBER)
   RETURN CHAR
IS
   CURSOR ben1missingdata
   IS
      SELECT 'Y'
        FROM benefactor a, stud_session b, stud_crse_year c
       WHERE b.ben1_id = a.ben_id
         AND b.stud_session_id = c.stud_session_id
         AND c.stud_crse_year_id = p_stud_crse_year_id
         AND (   a.house_no_name = 'X'
              OR a.addr_l1 = 'X'
              OR a.title = 'X'
              OR a.surname = 'X'
              OR b.ben1_rel_id = 999
             );

   l_ben1missing   CHAR (1) := 'N';
   
BEGIN
   OPEN ben1missingdata;

   FETCH ben1missingdata
    INTO l_ben1missing;

   CLOSE ben1missingdata;

   RETURN l_ben1missing;
END get_missingben1data;
    

FUNCTION get_missingben2data (p_stud_crse_year_id IN NUMBER)
   RETURN CHAR
IS
   -- 1.1 - Paul Hughes. 23.07.08 - Add Brackets to the Address restictions
   CURSOR ben2missingdata
   IS
      SELECT 'Y'
        FROM benefactor a, stud_session b, stud_crse_year c
       WHERE b.ben2_id = a.ben_id
         AND b.stud_session_id = c.stud_session_id
         AND c.stud_crse_year_id = p_stud_crse_year_id
         AND (   a.house_no_name = 'X'
              OR a.addr_l1 = 'X'
              OR a.title = 'X'
              OR a.surname = 'X'
              OR b.ben2_rel_id = 999
             );

   l_ben2missing   CHAR (1) := 'N';
BEGIN
   OPEN ben2missingdata;

   FETCH ben2missingdata
    INTO l_ben2missing;

   CLOSE ben2missingdata;

   RETURN l_ben2missing;
END get_missingben2data;


FUNCTION no_of_dependant_children (p_stud_crse_year_id IN   NUMBER)
   RETURN CHAR
IS
   l_dep1count   NUMBER := 0;
   l_dep2count   NUMBER := 0;
   l_totaldeps   NUMBER := 0;

BEGIN
   SELECT COUNT (ss.stud_ref_no)
     INTO l_dep1count
     FROM benefactor_dependant bd, stud_session ss, stud_crse_year scy
    WHERE bd.ben_id = ss.ben1_id
      AND ss.stud_session_id = scy.stud_session_id
      AND ss.session_code = bd.session_code
      AND scy.stud_crse_year_id = p_stud_crse_year_id
      AND bd.dependant_type = 'C';

   SELECT COUNT (ss.stud_ref_no)
     INTO l_dep2count
     FROM benefactor_dependant bd, stud_session ss, stud_crse_year scy
    WHERE bd.ben_id = ss.ben2_id
      AND ss.stud_session_id = scy.stud_session_id
      AND ss.session_code = bd.session_code
      AND scy.stud_crse_year_id = p_stud_crse_year_id
      AND bd.dependant_type = 'C';

   l_totaldeps := l_dep1count + l_dep2count;
   RETURN l_totaldeps;
END no_of_dependant_children;
    
FUNCTION get_ben_income (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
IS
   CURSOR c_ben1_income
   IS
      SELECT bi.bank_interest, bi.benefit, bi.other_income,
             bi.nat_saving_interest, bi.paye_income, bi.pension,
             bi.self_employment, bi.property, bi.dividend, bi.other_deduct, BI.WORKING_TAX_CREDIT
        FROM stud_session ss, benefactor_income bi, stud_crse_year scy
       WHERE bi.ben_id = ss.ben1_id
         AND ss.stud_session_id = scy.stud_session_id
         AND scy.session_code = bi.session_code
         AND scy.stud_crse_year_id = p_stud_crse_year_id;

   CURSOR c_ben2_income
   IS
      SELECT bi.bank_interest, bi.benefit, bi.other_income,
             bi.nat_saving_interest, bi.paye_income, bi.pension,
             bi.self_employment, bi.property, bi.dividend, bi.other_deduct, BI.WORKING_TAX_CREDIT
        FROM stud_session ss, benefactor_income bi, stud_crse_year scy
       WHERE bi.ben_id = ss.ben2_id
         AND ss.stud_session_id = scy.stud_session_id
         AND scy.session_code = bi.session_code
         AND scy.stud_crse_year_id = p_stud_crse_year_id;

   l_ben1_exists       CHAR (1);
   l_ben2_exists       CHAR (1);
   l_ben1_has_income   BOOLEAN                 := FALSE;
   l_ben2_has_income   BOOLEAN                 := FALSE;
   l_ben1_income_rec   c_ben1_income%ROWTYPE;
   l_ben2_income_rec   c_ben2_income%ROWTYPE;
   l_ben1_income       NUMBER                  := 0;
   l_ben2_income       NUMBER                  := 0;
BEGIN
   l_ben1_exists := check_ben1_exists (p_stud_crse_year_id);
   l_ben2_exists := check_ben2_exists (p_stud_crse_year_id);

   --
   -- If there is first benefactor calculate his income
   IF l_ben1_exists IS NOT NULL AND l_ben1_exists = 'Y'
   THEN
      --
      -- Get the benefactor1 income details
      OPEN c_ben1_income;

      FETCH c_ben1_income
       INTO l_ben1_income_rec;

      l_ben1_has_income := (c_ben1_income%ROWCOUNT > 0);

      CLOSE c_ben1_income;

      --
      -- Calculate the value of total net benefactor1 income
      IF l_ben1_has_income
      THEN
         l_ben1_income :=
              (  NVL (l_ben1_income_rec.bank_interest, 0)
               + NVL (l_ben1_income_rec.benefit, 0)
               + NVL (l_ben1_income_rec.other_income, 0)
               + NVL (l_ben1_income_rec.nat_saving_interest, 0)
               + NVL (l_ben1_income_rec.paye_income, 0)
               + NVL (l_ben1_income_rec.pension, 0)
               + NVL (l_ben1_income_rec.self_employment, 0)
               + NVL (l_ben1_income_rec.property, 0)
               + NVL (l_ben1_income_rec.dividend, 0)
               + NVL (l_ben1_income_rec.working_tax_credit, 0)
              )
            - NVL (l_ben1_income_rec.other_deduct, 0);
      END IF;
   END IF;

   --
   -- If there is second benefactor calculate his income
   IF l_ben1_exists IS NOT NULL AND l_ben1_exists = 'Y'
   THEN
      OPEN c_ben2_income;

      FETCH c_ben2_income
       INTO l_ben2_income_rec;

      l_ben2_has_income := (c_ben2_income%ROWCOUNT > 0);

      CLOSE c_ben2_income;

      --
      -- Calculate the value of total net benefactor2 income
      IF l_ben2_has_income
      THEN
         l_ben2_income :=
              (  NVL (l_ben2_income_rec.bank_interest, 0)
               + NVL (l_ben2_income_rec.benefit, 0)
               + NVL (l_ben2_income_rec.other_income, 0)
               + NVL (l_ben2_income_rec.nat_saving_interest, 0)
               + NVL (l_ben2_income_rec.paye_income, 0)
               + NVL (l_ben2_income_rec.pension, 0)
               + NVL (l_ben2_income_rec.self_employment, 0)
               + NVL (l_ben2_income_rec.property, 0)
               + NVL (l_ben2_income_rec.dividend, 0)
               + NVL (l_ben2_income_rec.working_tax_credit, 0)
              )
            - NVL (l_ben2_income_rec.other_deduct, 0);
      END IF;
   END IF;

   --
   -- Return the total benefactors income
   RETURN l_ben1_income + l_ben2_income;
END get_ben_income;

FUNCTION get_ben1_income (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
IS
   CURSOR c_ben1_income
   IS
      SELECT bi.bank_interest, bi.benefit, bi.other_income,
             bi.nat_saving_interest, bi.paye_income, bi.pension,
             bi.self_employment, bi.property, bi.dividend, bi.other_deduct, BI.WORKING_TAX_CREDIT
        FROM stud_session ss, benefactor_income bi, stud_crse_year scy
       WHERE bi.ben_id = ss.ben1_id
         AND ss.session_code = bi.session_code
         AND ss.stud_session_id = scy.stud_session_id
         AND scy.stud_crse_year_id = p_stud_crse_year_id;

   l_ben1_exists       CHAR (1);
   l_ben1_has_income   BOOLEAN                 := FALSE;
   l_ben1_income_rec   c_ben1_income%ROWTYPE;
   l_ben1_income       NUMBER                  := 0;
BEGIN
   l_ben1_exists := check_ben1_exists (p_stud_crse_year_id);

   --
   -- If there is first benefactor calculate his income
   IF l_ben1_exists IS NOT NULL AND l_ben1_exists = 'Y'
   THEN
      --
      -- Get the benefactor1 income details
      OPEN c_ben1_income;

      FETCH c_ben1_income
       INTO l_ben1_income_rec;

      l_ben1_has_income := (c_ben1_income%ROWCOUNT > 0);

      CLOSE c_ben1_income;

      --
      -- Calculate the value of total net benefactor1 income
      IF l_ben1_has_income
      THEN
         l_ben1_income :=
              (  NVL (l_ben1_income_rec.bank_interest, 0)
               + NVL (l_ben1_income_rec.benefit, 0)
               + NVL (l_ben1_income_rec.other_income, 0)
               + NVL (l_ben1_income_rec.nat_saving_interest, 0)
               + NVL (l_ben1_income_rec.paye_income, 0)
               + NVL (l_ben1_income_rec.pension, 0)
               + NVL (l_ben1_income_rec.self_employment, 0)
               + NVL (l_ben1_income_rec.property, 0)
               + NVL (l_ben1_income_rec.dividend, 0)
               + NVL (l_ben1_income_rec.working_tax_credit, 0)
              )
            - NVL (l_ben1_income_rec.other_deduct, 0);
      END IF;
   END IF;

   --
   
   -- Return the total benefactor income
   RETURN l_ben1_income;
END get_ben1_income;


FUNCTION get_ben2_income (p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS
   CURSOR c_ben2_income
   IS
      SELECT bi.bank_interest, bi.benefit, bi.other_income,
             bi.nat_saving_interest, bi.paye_income, bi.pension,
             bi.self_employment, bi.property, bi.dividend, bi.other_deduct, BI.WORKING_TAX_CREDIT
        FROM stud_session ss, benefactor_income bi, stud_crse_year scy
       WHERE bi.ben_id = ss.ben2_id
         AND ss.session_code = bi.session_code
         AND ss.stud_session_id = scy.stud_session_id
         AND scy.stud_crse_year_id = p_stud_crse_year_id;

   l_ben2_exists       CHAR (1);
   l_ben2_has_income   BOOLEAN                 := FALSE;
   l_ben2_income_rec   c_ben2_income%ROWTYPE;
   l_ben2_income       NUMBER                  := 0;
BEGIN
   l_ben2_exists := check_ben2_exists (p_stud_crse_year_id);

   --
   -- If there is second benefactor calculate his income
   IF l_ben2_exists = 'Y'
   THEN
      OPEN c_ben2_income;

      FETCH c_ben2_income
       INTO l_ben2_income_rec;

      l_ben2_has_income := (c_ben2_income%ROWCOUNT > 0);

      CLOSE c_ben2_income;

      --
      -- Calculate the value of total net benefactor2 income
      IF l_ben2_has_income
      THEN
         l_ben2_income :=
              (  NVL (l_ben2_income_rec.bank_interest, 0)
               + NVL (l_ben2_income_rec.benefit, 0)
               + NVL (l_ben2_income_rec.other_income, 0)
               + NVL (l_ben2_income_rec.nat_saving_interest, 0)
               + NVL (l_ben2_income_rec.paye_income, 0)
               + NVL (l_ben2_income_rec.pension, 0)
               + NVL (l_ben2_income_rec.self_employment, 0)
               + NVL (l_ben2_income_rec.property, 0)
               + NVL (l_ben2_income_rec.dividend, 0)
               + NVL (l_ben2_income_rec.working_tax_credit, 0)
              )
            - NVL (l_ben2_income_rec.other_deduct, 0);
      END IF;
   END IF;

   --
   -- Return the total benefactors income
   RETURN l_ben2_income;
END get_ben2_income;


FUNCTION prev_session_bursary (p_stud_crse_year_id    IN   NUMBER)RETURN CHAR

IS

    l_session_code  NUMBER;
    l_commenceYear  NUMBER;
    l_prevBen1_rel  NUMBER;
    l_prev_exempt   CHAR;
    l_result        CHAR;
    l_countgrass1    NUMBER;
    l_countgrass2   NUMBER;
    l_countsteps    NUMBER;

   
BEGIN

        ---WE ONLY HAVE STUD_CRSE_YEAR_ID AS INPUT BUT WE NEED TO FIND OUT COMMENCE YEAR AND SESSION CODE
        SELECT s.commence_session, SCY.SESSION_CODE
        INTO l_commenceYear, l_session_code
        FROM STUD s, STUD_CRSE_YEAR scy
        WHERE s.stud_ref_no = scy.stud_ref_no
        AND scy.stud_crse_year_id = p_stud_crse_year_id;
        
        
        ---DOES A BENEFACTOR EXIST?
   --     l_ben1Exists := sgas.rules_proc_recalc.check_ben1_exists(p_stud_crse_year_id);
        
        CASE
            WHEN (l_commenceYear = l_session_code)        ---IF THIS IS THE STUDENTS FIRST YEAR THEN SIMPLY SET TO 'N'
            THEN l_result := 'N';
             WHEN (l_commenceYear <> l_session_code) --AND l_ben1Exists = 'N'  ---- WE NEED TO LOOK AT PREVIOUS SESSION YEAR VALUE FOR PAY_YSB
                    THEN
                       IF l_commenceYear < STEPS_RELEASE_YEAR ----WE NEED TO LOOK UP THE GRASS DATABASE
                       THEN
                            
                            SELECT COUNT(DISTINCT scyg.pay_ysb)
                            INTO l_countgrass1
                            FROM STUD_CRSE_YEAR@GRASS scyg, stud_crse_year scy
                            WHERE scyg.stud_ref_no = scy.stud_ref_no
                            AND scy.stud_crse_year_id = p_stud_crse_year_id
                            AND scyg.session_code = l_commenceYear
                            AND scyg.pay_ysb = 'Y';
                            
                            SELECT COUNT(DISTINCT scyg.pay_ysb)
                            INTO l_countgrass2
                            FROM STUD_CRSE_YEAR@GRASS scyg, stud_crse_year scy
                            WHERE scyg.stud_ref_no = scy.stud_ref_no
                            AND scy.stud_crse_year_id = p_stud_crse_year_id
                            AND scyg.session_code = l_commenceYear
                            AND scyg.pay_ysb = 'N';
                             
                            
                                IF l_countgrass1 = 1 AND l_countgrass2 = 0
                                    THEN l_result := 'Y';
                                ELSIF l_countgrass2 = 1
                                    THEN l_result := 'N';
                                ELSE
                       
                       
                       
                       
                                SELECT NVL(scyg.PAY_YSB,'M')   --NVL WITH M to signal a NULL value
                                INTO l_result
                                FROM STUD_CRSE_YEAR@GRASS scyg, stud_crse_year scy
                                WHERE scyg.stud_ref_no = scy.stud_ref_no
                                AND scy.stud_crse_year_id = p_stud_crse_year_id
                                AND scyg.session_code = l_commenceYear
                                AND scyg.latest_crse_ind = 'Y';
                            
                                    ---IF WE FIND A NULL VALUE IN COMMENCE YEAR WE NEED TO DO SOME FURTHER CHECKING TO SEE IF THEY HAD PARENTAL BENEFACTORS AND NOT BENEXEMPT
                                    IF l_result = 'M'
                                        THEN
    
                                        select NVL(ss.ben1_rel_id,10) ,NVL(scy.parent_contrib_exempt,'N')
                                        INTO l_prevBen1_rel, l_prev_exempt
                                        from stud_session@grass ss, stud_crse_year@grass scy, stud_crse_year scys
                                        where ss.stud_session_id = scy.stud_session_id
                                        and ss.stud_ref_no = scys.stud_ref_no     ---we need this to get the stud_ref_no
                                        and ss.session_code = l_commenceYear  ---commence_year
                                        and scys.stud_crse_year_id = p_stud_crse_year_id
                                        and scy.latest_crse_ind = 'Y';

                                                IF l_prevBen1_rel NOT IN(28,10) AND l_prev_exempt = 'N'
                                                THEN l_result := 'Y';
                                                ELSE l_result := 'N';
                                                END IF;
                                        
                                    END IF;
                                    
                            END IF;
                       
                       ELSE --- WE LOOK UP STEPS DATABASE
                       
                            SELECT COUNT(DISTINCT scyg.pay_ysb)
                            INTO l_countgrass1
                            FROM STUD_CRSE_YEAR scyg, stud_crse_year scy
                            WHERE scyg.stud_ref_no = scy.stud_ref_no
                            AND scy.stud_crse_year_id = p_stud_crse_year_id
                            AND scyg.session_code = l_commenceYear
                            AND scyg.pay_ysb = 'Y';
                            
                            SELECT COUNT(DISTINCT scyg.pay_ysb)
                            INTO l_countgrass2
                            FROM STUD_CRSE_YEAR scyg, stud_crse_year scy
                            WHERE scyg.stud_ref_no = scy.stud_ref_no
                            AND scy.stud_crse_year_id = p_stud_crse_year_id
                            AND scyg.session_code = l_commenceYear
                            AND scyg.pay_ysb = 'N';
                             
                            
                                IF l_countgrass1 = 1 AND l_countgrass2 = 0
                                    THEN l_result := 'Y';
                                ELSIF l_countgrass2 = 1
                                    THEN l_result := 'N';
                                ELSE
                        
                    
                                        SELECT NVL(scyg.PAY_YSB,'M') --NVL WITH M to signal a NULL value
                                        INTO l_result
                                        FROM STUD_CRSE_YEAR scyg, stud_crse_year scy
                                        WHERE scyg.stud_ref_no = scy.stud_ref_no
                                        AND scy.stud_crse_year_id = p_stud_crse_year_id
                                        AND scyg.session_code = l_commenceYear
                                        AND scyg.latest_crse_ind = 'Y';
                            
                                    ---IF WE FIND A NULL VALUE IN COMMENCE YEAR WE NEED TO DO SOME FURTHER CHECKING TO SEE IF THEY HAD PARENTAL BENEFACTORS AND NOT BENEXEMPT
                                    IF l_result = 'M'
                                        THEN
                                        
                                        select NVL(ss.ben1_rel_id,10) ,NVL(scy.parent_contrib_exempt,'N')
                                        INTO l_prevBen1_rel, l_prev_exempt
                                        from stud_session ss, stud_crse_year scy
                                        where ss.stud_session_id = scy.stud_session_id
                                        and ss.stud_ref_no = scy.stud_ref_no     ---we need this to get the stud_ref_no
                                        and ss.session_code = l_commenceYear  ---commence_year
                                        and scy.stud_crse_year_id = p_stud_crse_year_id
                                        and scy.latest_crse_ind = 'Y';

                                                IF l_prevBen1_rel NOT IN(28,10) AND l_prev_exempt = 'N'
                                                THEN l_result := 'Y';
                                                ELSE l_result := 'N';
                                                END IF;
                                                
                                    END IF;
                            
                                END IF;
                            
                         END IF;
                         
             ELSE l_result := 'N';
              
             END CASE; 
             
                            

   RETURN l_result;
   
END prev_session_bursary;  

FUNCTION more_studcrse_year_record (p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS
        l_result CHAR(1);
        l_temp      NUMBER(10);
        l_studRef   NUMBER(10);
        l_session   NUMBER(4);
        
BEGIN

        SELECT STUD_REF_NO, SESSION_CODE
        INTO l_studRef, l_session
        FROM stud_crse_year
        WHERE stud_crse_year_id = p_stud_crse_year_id;
        
        SELECT COUNT(*)
        INTO l_temp
        FROM STUD_CRSE_YEAR
        WHERE stud_ref_no = l_studRef
        AND session_code = l_session
        AND stud_crse_year_id < p_stud_crse_year_id
        AND scheme_type <> 'B';
        
        IF l_temp > 0
            THEN l_result := 'Y';
        ELSE l_result := 'N';
        END IF;
        
        RETURN l_result;
        
        
        
END more_studcrse_year_record;

    
   
/* Formatted on 2010/08/10 16:58 (Formatter Plus v4.8.8) */
--RETURNS THE PAYMENT DATES USED BY AWARD CALCULATION

FUNCTION get_payment_dates (p_stud_crse_year_id IN NUMBER)
   RETURN all_payment_cursor_type
IS
   l_max_term_no        NUMBER;
   l_max_term_default   NUMBER;
   l_study_end_date     DATE;
   l_start_exists       CHAR;
   l_default_term       CHAR (1);
   l_moreRecords        CHAR(1);
   l_stud_ref_no        NUMBER(8);
   l_session_code       NUMBER(4);
   l_countpayment       NUMBER(10);
   l_reduce_pay         CHAR(1);
   dates_cursor         all_payment_cursor_type;
BEGIN
   l_default_term := check_default_terms (p_stud_crse_year_id);
   l_study_end_date := getstudyenddate (p_stud_crse_year_id);
   l_start_exists := checkstartdate (p_stud_crse_year_id);
   l_moreRecords := more_studcrse_year_record (p_stud_crse_year_id);
   l_countpayment := countPrevAwardPayments(p_stud_crse_year_id);
   
   IF l_moreRecords = 'Y' AND l_countpayment > 0
        THEN l_reduce_pay := 'Y';
        ELSE l_reduce_pay := 'N';
   END IF;
   
   IF l_reduce_pay = 'N'     ---- THERE IS NOT MORE THAN 1 STUD_CRSE_YEAR RECORD SO WE DO NOT HAVE TO AMEND DATES WITH PREVIOUSLY PAID INSTALMENTS.
        THEN
   

                                           IF l_start_exists = 'N'
                                           THEN  -- DEFAULT TERMS USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
                                              IF l_default_term = 'Y'
                                              THEN
                                                 l_max_term_default := get_max_term_default (p_stud_crse_year_id);

                                                 OPEN dates_cursor FOR
                                                    SELECT   DISTINCT payment_date  
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >  --WE WANT TO RETURN ALL PAYMENT DATES FROM payment_dates table which are greater than inst_term.start_date
                                                                (SELECT inst.start_date
                                                                   FROM inst_term inst, stud_crse_year scy
                                                                  WHERE scy.inst_code = inst.inst_code
                                                                    AND inst.session_code = scy.session_code
                                                                    AND inst.term_no = 1
                                                                    AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                                    AND payment_date <= l_study_end_date) --- AND LESS THAN OR EQUAL TOO EITHER COURSE_END_DATE OR WITHDRAW OR COURSE CHANGE.
                                                     --   AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                       --                     where a.payment_status IN('S','P')  -- NEW
                                                         --                   and b.stud_crse_year_id = p_stud_crse_year_id)            
                                                    UNION
                                                    SELECT   it.start_date AS payment_date ---- WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                                                        FROM inst_term it, stud_crse_year scy
                                                       WHERE it.inst_code = scy.inst_code
                                                         AND it.session_code = scy.session_code
                                                         AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                         AND it.term_no = 1
                                                    ORDER BY payment_date ASC;
                                                    
                                              ELSE
                                                 l_max_term_no := get_max_term_no (p_stud_crse_year_id);

                                                 -- DEFAULT TERMS NOT USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
                                                 OPEN dates_cursor FOR
                                                    SELECT   DISTINCT payment_date
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >
                                                                (SELECT a.start_date
                                                                   FROM crse_term a, stud_crse_year b
                                                                  WHERE a.crse_year_id = b.crse_year_id
                                                                    AND a.term_no = 1
                                                                    AND b.stud_crse_year_id = p_stud_crse_year_id)
                                                 --     AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                 --                           where a.payment_status IN('S','P')  -- NEW
                                                 --                           and b.stud_crse_year_id = p_stud_crse_year_id)   
                                                         AND payment_date <= l_study_end_date
                                                    UNION
                                                    SELECT   a.start_date AS payment_date  -- WE ALSO WANT TO GIVE A PAYMENT ON TEH DAY THE COURSE STARTS
                                                        FROM crse_term a, stud_crse_year b
                                                       WHERE a.crse_year_id = b.crse_year_id
                                                         AND a.term_no = 1
                                                         AND b.stud_crse_year_id = p_stud_crse_year_id
                                                    ORDER BY payment_date;
                                              END IF;
                                              
                                           ELSE        ---STUDY START DATE EXISTS BUT ONLY ONE STUD_CRSE_YEAR RECORD
                                                                                
                                              IF l_default_term = 'Y'
                                              THEN
                                                 l_max_term_default := get_max_term_default (p_stud_crse_year_id);

                                                 OPEN dates_cursor FOR
                                                    SELECT   DISTINCT payment_date  --- WE SELECT DISTINCT DUE TO UNION AS WE DO NOT WANT TO SELECT 2 PAYMENT DATES THE SAME.
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >
                                                                     (SELECT start_date
                                                                        FROM stud_crse_year
                                                                       WHERE stud_crse_year_id = p_stud_crse_year_id)
                                                     --                AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                       --                     where a.payment_status IN('S','P')  -- NEW
                                                         --                   and b.stud_crse_year_id = p_stud_crse_year_id)  
                                                         AND payment_date <= l_study_end_date
                                                    UNION 
                                                    SELECT start_date
                                                    FROM stud_crse_year
                                                    WHERE stud_crse_year_id = p_stud_crse_year_id
                                                    ORDER BY payment_date;
                                              ELSE
                                              
                                                 l_max_term_no := get_max_term_no (p_stud_crse_year_id);

                                                 -- Get the payment dates for relevant student session dates
                                                 OPEN dates_cursor FOR
                                                 
                                                    SELECT   DISTINCT payment_date  
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >
                                                                     (SELECT start_date
                                                                        FROM stud_crse_year
                                                                       WHERE stud_crse_year_id = p_stud_crse_year_id)
                                                        --              AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                        --                    where a.payment_status IN('S','P')  -- NEW
                                                        --                    and b.stud_crse_year_id = p_stud_crse_year_id)  
                                                         AND payment_date <= l_study_end_date
                                                    UNION 
                                                    SELECT start_date
                                                    FROM stud_crse_year
                                                    WHERE stud_crse_year_id = p_stud_crse_year_id
                                                    ORDER BY payment_date;
                                              END IF;
                                           END IF;
                                           
    ELSE           ------ MORE THAN ONE STUD_CRSE_YEAR RECORD EXISTS
    
        SELECT STUD_REF_NO, SESSION_CODE
        INTO l_stud_ref_no, l_session_code
        FROM STUD_CRSE_YEAR
        WHERE STUD_CRSE_YEAR_ID = p_stud_crse_year_id;                         ----- WE DO NOT WANT TO BRING BACK THE START_DATE
    
    
                                            IF l_start_exists = 'N'
                                           THEN  -- DEFAULT TERMS USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
                                              IF l_default_term = 'Y'
                                              THEN
                                                 l_max_term_default := get_max_term_default (p_stud_crse_year_id);

                                                 OPEN dates_cursor FOR
                                                    SELECT   DISTINCT payment_date  
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >  --WE WANT TO RETURN ALL PAYMENT DATES FROM payment_dates table which are greater than inst_term.start_date
                                                                (SELECT inst.start_date
                                                                   FROM inst_term inst, stud_crse_year scy
                                                                  WHERE scy.inst_code = inst.inst_code
                                                                    AND inst.session_code = scy.session_code
                                                                    AND inst.term_no = 1
                                                                    AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                                    AND payment_date <= l_study_end_date) --- AND LESS THAN OR EQUAL TOO EITHER COURSE_END_DATE OR WITHDRAW OR COURSE CHANGE.
                                                        AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
                                                                            and a.returned IN ('N','A','T')
                                                                            and a.award_id = b.award_id
                                                                            and b.award_src = 'A'
                                                                            and b.stud_ref_no = l_stud_ref_no
                                                                            and b.session_code = l_session_code
                                                                            and b.stud_crse_year_id < p_stud_crse_year_id) 
                                                        ORDER BY payment_date ASC;          

                                                    
                                              ELSE
                                                 l_max_term_no := get_max_term_no (p_stud_crse_year_id);

                                                 -- DEFAULT TERMS NOT USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
                                                 OPEN dates_cursor FOR
                                                    SELECT   DISTINCT payment_date
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >
                                                                (SELECT a.start_date
                                                                   FROM crse_term a, stud_crse_year b
                                                                  WHERE a.crse_year_id = b.crse_year_id
                                                                    AND a.term_no = 1
                                                                    AND b.stud_crse_year_id = p_stud_crse_year_id)
                                                        AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
                                                                            and a.returned IN('N','A','T')
                                                                            and a.award_id = b.award_id
                                                                            and b.award_src = 'A'
                                                                            and b.stud_ref_no = l_stud_ref_no
                                                                            and b.session_code = l_session_code
                                                                            and b.stud_crse_year_id < p_stud_crse_year_id) 
                                                    ORDER BY payment_date;
                                              END IF;
                                              
                                           ELSE        ---STUDY START DATE EXISTS
                                                                                
                                              IF l_default_term = 'Y'
                                              THEN
                                                 l_max_term_default := get_max_term_default (p_stud_crse_year_id);

                                                 OPEN dates_cursor FOR
                                                    SELECT   DISTINCT payment_date  --- WE SELECT DISTINCT DUE TO UNION AS WE DO NOT WANT TO SELECT 2 PAYMENT DATES THE SAME.
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >
                                                                     (SELECT start_date
                                                                        FROM stud_crse_year
                                                                       WHERE stud_crse_year_id = p_stud_crse_year_id)
                                                        AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
                                                                            and a.returned IN('N','A','T')
                                                                            and a.award_id = b.award_id
                                                                            and b.award_src = 'A'
                                                                            and b.stud_ref_no = l_stud_ref_no
                                                                            and b.session_code = l_session_code
                                                                            and b.stud_crse_year_id < p_stud_crse_year_id) 
                                                         AND payment_date <= l_study_end_date
                                                    UNION 
                                                    SELECT start_date
                                                    FROM stud_crse_year
                                                    WHERE stud_crse_year_id = p_stud_crse_year_id
                                                    AND start_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
                                                                            and a.returned IN('N','A','T')
                                                                            and a.award_id = b.award_id
                                                                            and b.award_src = 'A'
                                                                            and b.stud_ref_no = l_stud_ref_no
                                                                            and b.session_code = l_session_code
                                                                            and b.stud_crse_year_id < p_stud_crse_year_id) 
                                                    ORDER BY payment_date;
                                                    
                                                   
                                              ELSE
                                              
                                                 l_max_term_no := get_max_term_no (p_stud_crse_year_id);

                                                 -- Get the payment dates for relevant student session dates
                                                 OPEN dates_cursor FOR
                                                 
                                                    SELECT   DISTINCT payment_date  
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >
                                                                     (SELECT start_date
                                                                        FROM stud_crse_year
                                                                       WHERE stud_crse_year_id = p_stud_crse_year_id)
                                                                         AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
                                                                            and a.returned IN('N','A','T')
                                                                            and a.award_id = b.award_id
                                                                            and b.award_src = 'A'
                                                                            and b.stud_ref_no = l_stud_ref_no
                                                                            and b.session_code = l_session_code
                                                                            and b.stud_crse_year_id < p_stud_crse_year_id) 
                                                         AND payment_date <= l_study_end_date
                                                    UNION 
                                                    SELECT start_date
                                                    FROM stud_crse_year
                                                    WHERE stud_crse_year_id = p_stud_crse_year_id
                                                    AND start_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
                                                                            and a.returned IN('N','A','T')
                                                                            and a.award_id = b.award_id
                                                                            and b.award_src = 'A'
                                                                            and b.stud_ref_no = l_stud_ref_no
                                                                            and b.session_code = l_session_code
                                                                            and b.stud_crse_year_id < p_stud_crse_year_id) 
                                                    ORDER BY payment_date;
                                                    
                                              END IF;
                                           END IF;
   END IF;
    
   RETURN dates_cursor;
END get_payment_dates;

FUNCTION get_payment_dates_2022 (p_stud_crse_year_id IN NUMBER)
   RETURN all_payment_cursor_type
IS
   l_max_term_no        NUMBER;
   l_study_end_date     DATE;
   l_default_term       CHAR (1);
   l_moreRecords        CHAR(1);
   l_countpayment       NUMBER(10);
   l_reduce_pay         CHAR(1);
   dates_cursor         all_payment_cursor_type;
BEGIN
   l_default_term := check_default_terms (p_stud_crse_year_id);
   l_study_end_date := getstudyenddate_2022 (p_stud_crse_year_id);
   l_moreRecords := more_studcrse_year_record (p_stud_crse_year_id);
   l_countpayment := countPrevAwardPayments(p_stud_crse_year_id);
   
   IF l_moreRecords = 'Y' AND l_countpayment > 0
        THEN l_reduce_pay := 'Y';
        ELSE l_reduce_pay := 'N';
   END IF;
   
                               IF l_reduce_pay = 'N'     ---- THERE IS NOT MORE THAN 1 STUD_CRSE_YEAR RECORD SO WE DO NOT HAVE TO AMEND DATES WITH PREVIOUSLY PAID INSTALMENTS.
                               THEN
   

                                           
                                             -- DEFAULT TERMS USED 
                                                  IF l_default_term = 'Y'
                                                  THEN

                                                     OPEN dates_cursor FOR
                                                        SELECT   DISTINCT payment_date  
                                                            FROM payment_dates@grass
                                                           WHERE payment_date >  --WE WANT TO RETURN ALL PAYMENT DATES FROM payment_dates table which are greater than inst_term.start_date
                                                                    (SELECT inst.start_date
                                                                       FROM inst_term inst, stud_crse_year scy
                                                                      WHERE scy.inst_code = inst.inst_code
                                                                        AND inst.session_code = scy.session_code
                                                                        AND inst.term_no = 1
                                                                        AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                                        AND payment_date <= l_study_end_date) --- AND LESS THAN OR EQUAL TOO EITHER COURSE_END_DATE OR WITHDRAW OR COURSE CHANGE.           
                                                        UNION
                                                        SELECT   it.start_date AS payment_date ---- WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                                                            FROM inst_term it, stud_crse_year scy
                                                           WHERE it.inst_code = scy.inst_code
                                                             AND it.session_code = scy.session_code
                                                             AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                             AND it.term_no = 1
                                                             ORDER BY payment_date;
                                                        
                                                    
                                                        ELSE
                                                         l_max_term_no := get_max_term_no (p_stud_crse_year_id);

                                                    -- DEFAULT TERMS NOT USED
                                                    OPEN dates_cursor FOR
                                                    SELECT   DISTINCT payment_date
                                                                FROM payment_dates@grass
                                                               WHERE payment_date >
                                                                        (SELECT a.start_date
                                                                           FROM crse_term a, stud_crse_year b
                                                                          WHERE a.crse_year_id = b.crse_year_id
                                                                            AND a.term_no = 1
                                                                            AND b.stud_crse_year_id = p_stud_crse_year_id) 
                                                                 AND payment_date <= l_study_end_date
                                                            UNION
                                                            SELECT   a.start_date AS payment_date  -- WE ALSO WANT TO GIVE A PAYMENT ON TEH DAY THE COURSE STARTS
                                                                FROM crse_term a, stud_crse_year b
                                                               WHERE a.crse_year_id = b.crse_year_id
                                                                 AND a.term_no = 1
                                                                 AND b.stud_crse_year_id = p_stud_crse_year_id
                                                            ORDER BY payment_date;
                                                    END IF;
                                              
                                           
                                           
                                           
                                    ELSE        ------ MORE THAN ONE STUD_CRSE_YEAR RECORD EXISTS
                                           
                                              IF l_default_term = 'Y'
                                              THEN

                                                 OPEN dates_cursor FOR
                                                    SELECT   DISTINCT payment_date  
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >  
                                                                (SELECT inst.start_date
                                                                   FROM inst_term inst, stud_crse_year scy
                                                                  WHERE scy.inst_code = inst.inst_code
                                                                    AND inst.session_code = scy.session_code
                                                                    AND inst.term_no = 1
                                                                    AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                                    AND payment_date <= l_study_end_date) 
                                                       UNION
                                                    SELECT it.start_date AS payment_date -- WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                                                      FROM inst_term it, stud_crse_year scy
                                                     WHERE     it.inst_code = scy.inst_code
                                                           AND it.session_code = scy.session_code
                                                           AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                           AND it.term_no = 1
                                                    ORDER BY payment_date ASC;           
                                                    
                                              ELSE

                                                 -- DEFAULT TERMS NOT USED
                                                 OPEN dates_cursor FOR
                                                    SELECT   DISTINCT payment_date  
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >
                                                                     (SELECT a.start_date
                                                                           FROM crse_term a, stud_crse_year b
                                                                          WHERE a.crse_year_id = b.crse_year_id
                                                                            AND a.term_no = 1
                                                                            AND b.stud_crse_year_id = p_stud_crse_year_id)
                                                         AND payment_date <= l_study_end_date     
                                                            UNION
                                                            SELECT   a.start_date AS payment_date  -- WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                                                                FROM crse_term a, stud_crse_year b
                                                               WHERE a.crse_year_id = b.crse_year_id
                                                                 AND a.term_no = 1
                                                                 AND b.stud_crse_year_id = p_stud_crse_year_id
                                                            ORDER BY payment_date;
                                                  
                                              END IF;
                                                    
                            END IF;
                                                      
    
   RETURN dates_cursor;
END get_payment_dates_2022;

FUNCTION get_top_payment_dates (p_stud_crse_year_id IN NUMBER)
   RETURN all_top_payment_cursor_type
IS
   l_max_term_no                    NUMBER;
   l_max_term_default               NUMBER;
   l_study_end_date                 DATE;
   l_start_exists                   CHAR;
   l_default_term                   CHAR (1);
   l_moreRecords                    CHAR (1);
   l_stud_ref_no                    NUMBER (8);
   l_session_code                   NUMBER (4);
   l_countpayment                   NUMBER (10);
   l_reduce_pay                     CHAR (1);
   dates_cursor                     all_top_payment_cursor_type;
   l_top_payment_date_range_start   DATE;
   
BEGIN
   l_default_term := check_default_terms (p_stud_crse_year_id);
   l_study_end_date := getTopStudyEnddate (p_stud_crse_year_id);
   l_start_exists := checkstartdate (p_stud_crse_year_id);
   l_moreRecords := more_studcrse_year_record (p_stud_crse_year_id);
   l_countpayment := countPrevAwardPayments (p_stud_crse_year_id);

   IF l_moreRecords = 'Y' AND l_countpayment > 0
   THEN
      l_reduce_pay := 'Y';
   ELSE
      l_reduce_pay := 'N';
   END IF;

   IF l_reduce_pay = 'N' -- THERE IS NOT MORE THAN 1 STUD_CRSE_YEAR RECORD SO WE DO NOT HAVE TO AMEND DATES WITH PREVIOUSLY PAID INSTALMENTS.
   THEN
      IF l_start_exists = 'N'
      THEN       -- DEFAULT TERMS USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
         IF l_default_term = 'Y'
         THEN
            l_max_term_default := get_max_term_default (p_stud_crse_year_id);

            SELECT inst.start_date
              INTO l_top_payment_date_range_start
              FROM inst_term inst, stud_crse_year scy
             WHERE     scy.inst_code = inst.inst_code
                   AND inst.session_code = scy.session_code
                   AND inst.term_no = 1
                   AND scy.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            OPEN dates_cursor FOR
               SELECT DISTINCT payment_date
                 FROM payment_dates@grass
                WHERE     payment_date > --RETURN PAYMENT DATES FROM payment_dates table
                                        l_top_payment_date_range_start
                      AND payment_date <= l_study_end_date
               UNION
               SELECT it.start_date AS payment_date --WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                 FROM inst_term it, stud_crse_year scy
                WHERE     it.inst_code = scy.inst_code
                      AND it.session_code = scy.session_code
                      AND scy.stud_crse_year_id = p_stud_crse_year_id
                      AND it.term_no = 1
               ORDER BY payment_date ASC;
         ELSE
            l_max_term_no := get_max_term_no (p_stud_crse_year_id);

            SELECT a.start_date
              INTO l_top_payment_date_range_start
              FROM crse_term a, stud_crse_year b
             WHERE     a.crse_year_id = b.crse_year_id
                   AND a.term_no = 1
                   AND b.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            -- DEFAULT TERMS NOT USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
            OPEN dates_cursor FOR
               SELECT DISTINCT payment_date
                 FROM payment_dates@grass
                WHERE     payment_date > l_top_payment_date_range_start
                      AND payment_date <= l_study_end_date
               UNION
               SELECT a.start_date AS payment_date --WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                 FROM crse_term a, stud_crse_year b
                WHERE     a.crse_year_id = b.crse_year_id
                      AND a.term_no = 1
                      AND b.stud_crse_year_id = p_stud_crse_year_id
               ORDER BY payment_date;
         END IF;
      ELSE       --STUDY START DATE EXISTS BUT ONLY ONE STUD_CRSE_YEAR RECORD
         IF l_default_term = 'Y'
         THEN
            l_max_term_default := get_max_term_default (p_stud_crse_year_id);

            SELECT start_date
              INTO l_top_payment_date_range_start
              FROM stud_crse_year
             WHERE stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            OPEN dates_cursor FOR
               SELECT DISTINCT payment_date -- WE SELECT DISTINCT DUE TO UNION AS WE DO NOT WANT TO SELECT 2 PAYMENT DATES THE SAME.
                 FROM payment_dates@grass
                WHERE     payment_date > l_top_payment_date_range_start
                      AND payment_date <= l_study_end_date
               UNION
               SELECT start_date
                 FROM stud_crse_year
                WHERE stud_crse_year_id = p_stud_crse_year_id
               ORDER BY payment_date;
         ELSE
            l_max_term_no := get_max_term_no (p_stud_crse_year_id);

            SELECT start_date
              INTO l_top_payment_date_range_start
              FROM stud_crse_year
             WHERE stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            -- Get the payment dates for relevant student session dates
            OPEN dates_cursor FOR
               SELECT DISTINCT payment_date
                 FROM payment_dates@grass
                WHERE     payment_date > l_top_payment_date_range_start
                      AND payment_date <= l_study_end_date
               UNION
               SELECT start_date
                 FROM stud_crse_year
                WHERE stud_crse_year_id = p_stud_crse_year_id
               ORDER BY payment_date;
         END IF;
      END IF;
   ELSE                      -- MORE THAN ONE STUD_CRSE_YEAR RECORD EXISTS
      SELECT STUD_REF_NO, SESSION_CODE
        INTO l_stud_ref_no, l_session_code
        FROM STUD_CRSE_YEAR
       WHERE STUD_CRSE_YEAR_ID = p_stud_crse_year_id; -- WE DO NOT WANT TO BRING BACK THE START_DATE

      IF l_start_exists = 'N'
      THEN       -- DEFAULT TERMS USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
         IF l_default_term = 'Y'
         THEN
            l_max_term_default := get_max_term_default (p_stud_crse_year_id);

            SELECT inst.start_date
              INTO l_top_payment_date_range_start
              FROM inst_term inst, stud_crse_year scy
             WHERE     scy.inst_code = inst.inst_code
                   AND inst.session_code = scy.session_code
                   AND inst.term_no = 1
                   AND scy.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            OPEN dates_cursor FOR
                 SELECT DISTINCT payment_date
                   FROM payment_dates@grass
                  WHERE     payment_date > --WE WANT TO RETURN ALL PAYMENT DATES FROM payment_dates table which are greater than inst_term.start_date
                                          l_top_payment_date_range_start
                        AND payment_date <= l_study_end_date
                        AND payment_date >
                               (SELECT MAX (a.payment_due_date)
                                  FROM award_instalment a, award b
                                 WHERE     a.payment_status IN ('S', 'P')
                                       AND a.returned IN ('N', 'A', 'T')
                                       AND a.award_id = b.award_id
                                       AND b.award_src = 'A'
                                       AND b.stud_ref_no = l_stud_ref_no
                                       AND b.session_code = l_session_code
                                       AND b.stud_crse_year_id <
                                              p_stud_crse_year_id)
               ORDER BY payment_date ASC;
         ELSE
            l_max_term_no := get_max_term_no (p_stud_crse_year_id);

            SELECT a.start_date
              INTO l_top_payment_date_range_start
              FROM crse_term a, stud_crse_year b
             WHERE     a.crse_year_id = b.crse_year_id
                   AND a.term_no = 1
                   AND b.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            -- DEFAULT TERMS NOT USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
            OPEN dates_cursor FOR
                 SELECT DISTINCT payment_date
                   FROM payment_dates@grass
                  WHERE     payment_date > l_top_payment_date_range_start
                        AND payment_date >
                               (SELECT MAX (a.payment_due_date)
                                  FROM award_instalment a, award b
                                 WHERE     a.payment_status IN ('S', 'P')
                                       AND a.returned IN ('N', 'A', 'T')
                                       AND a.award_id = b.award_id
                                       AND b.award_src = 'A'
                                       AND b.stud_ref_no = l_stud_ref_no
                                       AND b.session_code = l_session_code
                                       AND b.stud_crse_year_id <
                                              p_stud_crse_year_id)
               ORDER BY payment_date;
         END IF;
      ELSE                    --STUDY START DATE EXISTS
         IF l_default_term = 'Y'
         THEN
            l_max_term_default := get_max_term_default (p_stud_crse_year_id);

            SELECT start_date
              INTO l_top_payment_date_range_start
              FROM stud_crse_year
             WHERE stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            OPEN dates_cursor FOR
               SELECT DISTINCT payment_date -- WE SELECT DISTINCT DUE TO UNION AS WE DO NOT WANT TO SELECT 2 PAYMENT DATES THE SAME.
                 FROM payment_dates@grass
                WHERE     payment_date > l_top_payment_date_range_start
                      AND payment_date >
                             (SELECT MAX (a.payment_due_date)
                                FROM award_instalment a, award b
                               WHERE     a.payment_status IN ('S', 'P')
                                     AND a.returned IN ('N', 'A', 'T')
                                     AND a.award_id = b.award_id
                                     AND b.award_src = 'A'
                                     AND b.stud_ref_no = l_stud_ref_no
                                     AND b.session_code = l_session_code
                                     AND b.stud_crse_year_id <
                                            p_stud_crse_year_id)
                      AND payment_date <= l_study_end_date
               UNION
               SELECT start_date
                 FROM stud_crse_year
                WHERE     stud_crse_year_id = p_stud_crse_year_id
                      AND start_date >
                             (SELECT MAX (a.payment_due_date)
                                FROM award_instalment a, award b
                               WHERE     a.payment_status IN ('S', 'P')
                                     AND a.returned IN ('N', 'A', 'T')
                                     AND a.award_id = b.award_id
                                     AND b.award_src = 'A'
                                     AND b.stud_ref_no = l_stud_ref_no
                                     AND b.session_code = l_session_code
                                     AND b.stud_crse_year_id <
                                            p_stud_crse_year_id)
               ORDER BY payment_date;
         ELSE
            l_max_term_no := get_max_term_no (p_stud_crse_year_id);

            SELECT start_date
              INTO l_top_payment_date_range_start
              FROM stud_crse_year
             WHERE stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            -- Get the payment dates for relevant student session dates
            OPEN dates_cursor FOR
               SELECT DISTINCT payment_date
                 FROM payment_dates@grass
                WHERE     payment_date > l_top_payment_date_range_start
                      AND payment_date >
                             (SELECT MAX (a.payment_due_date)
                                FROM award_instalment a, award b
                               WHERE     a.payment_status IN ('S', 'P')
                                     AND a.returned IN ('N', 'A', 'T')
                                     AND a.award_id = b.award_id
                                     AND b.award_src = 'A'
                                     AND b.stud_ref_no = l_stud_ref_no
                                     AND b.session_code = l_session_code
                                     AND b.stud_crse_year_id <
                                            p_stud_crse_year_id)
                      AND payment_date <= l_study_end_date
               UNION
               SELECT start_date
                 FROM stud_crse_year
                WHERE     stud_crse_year_id = p_stud_crse_year_id
                      AND start_date >
                             (SELECT MAX (a.payment_due_date)
                                FROM award_instalment a, award b
                               WHERE     a.payment_status IN ('S', 'P')
                                     AND a.returned IN ('N', 'A', 'T')
                                     AND a.award_id = b.award_id
                                     AND b.award_src = 'A'
                                     AND b.stud_ref_no = l_stud_ref_no
                                     AND b.session_code = l_session_code
                                     AND b.stud_crse_year_id <
                                            p_stud_crse_year_id)
               ORDER BY payment_date;
         END IF;
      END IF;
   END IF;

   RETURN dates_cursor;
END get_top_payment_dates;

FUNCTION get_top_payment_dates_2022 (p_stud_crse_year_id IN NUMBER)
   RETURN all_top_payment_cursor_type
IS

   l_study_end_date                 DATE;
   l_default_term                   CHAR (1);
   l_moreRecords                    CHAR (1);
   l_countpayment                   NUMBER (10);
   l_reduce_pay                     CHAR (1);
   dates_cursor                     all_top_payment_cursor_type;
   l_top_payment_date_range_start   DATE;
   
BEGIN
   l_default_term := check_default_terms (p_stud_crse_year_id);
   l_study_end_date := getTopStudyEnddate_2022 (p_stud_crse_year_id);
   l_moreRecords := more_studcrse_year_record (p_stud_crse_year_id);
   l_countpayment := countPrevAwardPayments (p_stud_crse_year_id);

   IF l_moreRecords = 'Y' AND l_countpayment > 0
   THEN
      l_reduce_pay := 'Y';
   ELSE
      l_reduce_pay := 'N';
   END IF;

   IF l_reduce_pay = 'N' -- THERE IS NOT MORE THAN 1 STUD_CRSE_YEAR RECORD SO WE DO NOT HAVE TO AMEND DATES WITH PREVIOUSLY PAID INSTALMENTS.
   THEN
         -- DEFAULT TERMS USED 
         IF l_default_term = 'Y'
         THEN

            SELECT inst.start_date
              INTO l_top_payment_date_range_start
              FROM inst_term inst, stud_crse_year scy
             WHERE     scy.inst_code = inst.inst_code
                   AND inst.session_code = scy.session_code
                   AND inst.term_no = 1
                   AND scy.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            OPEN dates_cursor FOR
               SELECT DISTINCT payment_date
                 FROM payment_dates@grass
                WHERE     payment_date > --RETURN PAYMENT DATES FROM payment_dates table
                                        l_top_payment_date_range_start
                      AND payment_date <= l_study_end_date
               UNION
               SELECT it.start_date AS payment_date --WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                 FROM inst_term it, stud_crse_year scy
                WHERE     it.inst_code = scy.inst_code
                      AND it.session_code = scy.session_code
                      AND scy.stud_crse_year_id = p_stud_crse_year_id
                      AND it.term_no = 1
               ORDER BY payment_date ASC;
         ELSE

            SELECT a.start_date
              INTO l_top_payment_date_range_start
              FROM crse_term a, stud_crse_year b
             WHERE     a.crse_year_id = b.crse_year_id
                   AND a.term_no = 1
                   AND b.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            -- DEFAULT TERMS NOT USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
            OPEN dates_cursor FOR
               SELECT DISTINCT payment_date
                 FROM payment_dates@grass
                WHERE     payment_date > l_top_payment_date_range_start
                      AND payment_date <= l_study_end_date
               UNION
               SELECT a.start_date AS payment_date --WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                 FROM crse_term a, stud_crse_year b
                WHERE     a.crse_year_id = b.crse_year_id
                      AND a.term_no = 1
                      AND b.stud_crse_year_id = p_stud_crse_year_id
               ORDER BY payment_date;
         END IF;
      
      
   ELSE              -- MORE THAN ONE STUD_CRSE_YEAR RECORD EXISTS
         --DEFAULT TERMS
         IF l_default_term = 'Y'
         THEN

            SELECT inst.start_date
              INTO l_top_payment_date_range_start
              FROM inst_term inst, stud_crse_year scy
             WHERE     scy.inst_code = inst.inst_code
                   AND inst.session_code = scy.session_code
                   AND inst.term_no = 1
                   AND scy.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            OPEN dates_cursor FOR
                 SELECT DISTINCT payment_date
                   FROM payment_dates@grass
                  WHERE     payment_date > 
                                          l_top_payment_date_range_start
                        AND payment_date <= l_study_end_date
                    UNION
                    SELECT it.start_date AS payment_date -- WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                      FROM inst_term it, stud_crse_year scy
                     WHERE     it.inst_code = scy.inst_code
                           AND it.session_code = scy.session_code
                           AND scy.stud_crse_year_id = p_stud_crse_year_id
                           AND it.term_no = 1
                    ORDER BY payment_date ASC; 
         ELSE

            SELECT a.start_date
              INTO l_top_payment_date_range_start
              FROM crse_term a, stud_crse_year b
             WHERE     a.crse_year_id = b.crse_year_id
                   AND a.term_no = 1
                   AND b.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            -- DEFAULT TERMS NOT USED 
            OPEN dates_cursor FOR
                 SELECT DISTINCT payment_date
                   FROM payment_dates@grass
                  WHERE     payment_date > l_top_payment_date_range_start
                  AND payment_date <= l_study_end_date
                   UNION
                    SELECT a.start_date AS payment_date -- WE ALSO WANT TO GIVE A PAYMENT ON TEH DAY THE COURSE STARTS
                      FROM crse_term a, stud_crse_year b
                     WHERE     a.crse_year_id = b.crse_year_id
                           AND a.term_no = 1
                           AND b.stud_crse_year_id = p_stud_crse_year_id
                    ORDER BY payment_date;
         END IF;
      END IF;
      


   RETURN dates_cursor;
END get_top_payment_dates_2022;

    
--THIS FUNCTION RETURNS ALL OF THE START DATES FOR THE PARTICULAR STUDENT
FUNCTION get_startdates (p_stud_crse_year_id IN NUMBER)
   RETURN startdates_cursor_type
IS

   DT           CHAR (1);   
   ST           CHAR (1);
   ED           CHAR (1);
   endDate           DATE;
   
   startdates_cursor    startdates_cursor_type;
   
BEGIN

   DT := check_default_terms (p_stud_crse_year_id);
   
   ST := checkStartDate (p_stud_crse_year_id);
   
   ED := checkWithdrawOrCrseChng (p_stud_crse_year_id);
   
   endDate    := getStudyEnddate (p_stud_crse_year_id);
   
   IF    DT = 'Y' AND ST = 'Y' AND ED = 'Y' THEN   
            OPEN startdates_cursor FOR
            
           SELECT distinct a.start_date
           FROM inst_term a, stud_crse_year b
           WHERE a.inst_code = b.inst_code
           AND a.session_code = b.session_code
           AND b.stud_crse_year_id = p_stud_crse_year_id
           AND a.start_date > b.start_date
           AND a.start_date <= endDate
           UNION
           SELECT a.start_date
           FROM stud_crse_year a
           WHERE a.stud_crse_year_id = p_stud_crse_year_id
           order by start_date;
            
            
        
   ELSIF DT = 'N' AND ST = 'Y' AND ED = 'Y'THEN
            OPEN startdates_cursor FOR
            
           SELECT distinct a.start_date
           FROM crse_term a, stud_crse_year b
          WHERE a.crse_year_id = b.crse_year_id
          AND b.stud_crse_year_id = p_stud_crse_year_id
          AND a.start_date > b.start_date
          AND a.start_date <= endDate
           UNION
           SELECT a.start_date
           FROM stud_crse_year a
           WHERE a.stud_crse_year_id = p_stud_crse_year_id
           order by start_date;
            
   
   ELSIF DT = 'Y' AND ST = 'Y' AND ED = 'N'THEN 
            OPEN startdates_cursor FOR
            
           SELECT distinct a.start_date
           FROM inst_term a, stud_crse_year b
          WHERE a.inst_code = b.inst_code
            AND a.session_code = b.session_code
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.start_date > b.start_date
           UNION
           SELECT a.start_date
           FROM stud_crse_year a
           WHERE a.stud_crse_year_id = p_stud_crse_year_id
           order by start_date;
   
   ELSIF DT = 'N' AND ST = 'Y' AND ED = 'N'THEN  
            OPEN startdates_cursor FOR
            
            SELECT distinct a.start_date
            FROM crse_term a, stud_crse_year b
            WHERE a.crse_year_id = b.crse_year_id
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.start_date > b.start_date
           UNION
           SELECT a.start_date
           FROM stud_crse_year a
           WHERE a.stud_crse_year_id = p_stud_crse_year_id
           order by start_date;
   
   ELSIF DT = 'Y' AND ST = 'N' AND ED = 'Y'THEN
            OPEN startdates_cursor FOR
            
            SELECT distinct a.start_date
           FROM inst_term a, stud_crse_year b
          WHERE a.inst_code = b.inst_code
            AND a.session_code = b.session_code
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.start_date <= endDate
            order by start_date;
            
            
   
   ELSIF DT = 'N' AND ST = 'N' AND ED = 'Y'THEN
            OPEN startdates_cursor FOR
            
            SELECT distinct a.start_date
            FROM crse_term a, stud_crse_year b
            WHERE a.crse_year_id = b.crse_year_id
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.start_date <= endDate
            order by start_date;
            
 
   ELSIF DT = 'Y' AND ST = 'N' AND ED = 'N'THEN
            OPEN startdates_cursor FOR
            
           SELECT a.start_date
           FROM inst_term a, stud_crse_year b
          WHERE a.inst_code = b.inst_code
            AND a.session_code = b.session_code
            AND b.stud_crse_year_id = p_stud_crse_year_id
            order by start_date;
   
   ELSIF DT = 'N' AND ST = 'N' AND ED = 'N'THEN
            OPEN startdates_cursor FOR
            
           SELECT a.start_date
           FROM crse_term a, stud_crse_year b
          WHERE a.crse_year_id = b.crse_year_id
            AND b.stud_crse_year_id = p_stud_crse_year_id
            order by start_date;
   
   END IF;
  
   RETURN startdates_cursor;
END get_startdates;  

--THIS FUNCTION RETURNS ALL OF THE START DATES FOR THE PARTICULAR STUDENT
FUNCTION get_startdates2022 (p_stud_crse_year_id IN NUMBER)
   RETURN startdates_cursor_type2022
IS

    DT           CHAR (1);  
    ED           CHAR(1);
    endDate      DATE; 
    
    
    startdates_cursor2022 startdates_cursor_type2022;
   
   
   
BEGIN

   DT := check_default_terms (p_stud_crse_year_id); 
   ED := checkWithdrawOrCrseChng (p_stud_crse_year_id);
   endDate    := getStudyEnddate_2022 (p_stud_crse_year_id);
   
   IF  DT = 'Y' AND ED = 'Y'THEN
            
            OPEN startdates_cursor2022 FOR
            SELECT distinct a.start_date
           FROM inst_term a, stud_crse_year b
          WHERE a.inst_code = b.inst_code
            AND a.session_code = b.session_code
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.start_date <= endDate
            --AND A.TERM_NO = 1
            order by start_date;
            
            
   
   ELSIF DT = 'N' AND ED = 'Y'THEN
            
            OPEN startdates_cursor2022 FOR
            SELECT distinct a.start_date
            FROM crse_term a, stud_crse_year b
            WHERE a.crse_year_id = b.crse_year_id
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.start_date <= endDate
            --AND A.TERM_NO = 1
            order by start_date;
            
 
   ELSIF DT = 'Y' AND ED = 'N'THEN
            
           OPEN startdates_cursor2022 FOR
           SELECT a.start_date
           FROM inst_term a, stud_crse_year b
          WHERE a.inst_code = b.inst_code
            AND a.session_code = b.session_code
            AND b.stud_crse_year_id = p_stud_crse_year_id
            --AND A.TERM_NO = 1
            order by start_date;
   
   ELSIF DT = 'N' AND ED = 'N'THEN
            
           OPEN startdates_cursor2022 FOR 
           SELECT a.start_date
           FROM crse_term a, stud_crse_year b
          WHERE a.crse_year_id = b.crse_year_id
            AND b.stud_crse_year_id = p_stud_crse_year_id
            --AND A.TERM_NO = 1
            order by start_date;
   
   END IF;
  
   RETURN startdates_cursor2022;
END get_startdates2022;  
        

FUNCTION get_termdays (p_stud_crse_year_id IN NUMBER)
   RETURN termdays_cursor_type
IS
   l_max_term_no        NUMBER               := NULL;
   l_max_term_default   NUMBER               := NULL;
   l_session_code       NUMBER;
   l_stud_ref_no        NUMBER;
   l_default_term       CHAR (1)             := '';
   termdays_cursor      termdays_cursor_type;
BEGIN
   l_default_term := check_default_terms (p_stud_crse_year_id);

   IF l_default_term = 'Y'
   
   THEN
      l_max_term_default :=
                         get_max_term_default (p_stud_crse_year_id);

      OPEN termdays_cursor FOR
         SELECT a.days
           FROM inst_term a, stud_crse_year b
          WHERE a.inst_code = b.inst_code
            AND a.session_code = b.session_code
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.term_no <= l_max_term_default;
   ELSE
   
      l_max_term_no := get_max_term_no (p_stud_crse_year_id);

      OPEN termdays_cursor FOR
         SELECT a.days
           FROM crse_term a, stud_crse_year b
          WHERE a.crse_year_id = b.crse_year_id
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.term_no <= l_max_term_no;
   END IF;

   RETURN termdays_cursor;
END get_termdays;

   FUNCTION get_paid_SUM_net_Instalment(p_award_id IN NUMBER)
   RETURN NUMBER
   IS
   
   l_amount NUMBER;
   l_count  NUMBER;
   
   BEGIN
   
            SELECT COUNT(*)
            INTO l_count
            FROM AWARD_INSTALMENT
            WHERE AWARD_ID = p_award_id
            AND payment_status = 'S'
            AND returned IN('N','A','T');
            
            IF l_count > 0
            
                THEN 
        
                        SELECT SUM(NET_AMOUNT)
                        INTO l_amount
                        FROM AWARD_INSTALMENT
                        WHERE AWARD_ID = p_award_id
                        AND payment_status = 'S'
                        AND returned IN('N','A','T');
                        
            ELSE l_amount := 0;
            
            END IF;
            
      RETURN l_amount;
      
END get_paid_SUM_net_Instalment;

FUNCTION count_payment_dates (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
IS
   l_max_term_no        NUMBER;                 
   l_max_term_default   NUMBER;                
   l_payment_date_count   NUMBER;
   l_study_end_date     DATE;
   l_start_exists       CHAR;
   l_default_term       CHAR (1);
   l_moreRecords        CHAR(1); 
   l_countpayment       NUMBER(10);
   l_reduce_pay         CHAR(1);
   l_stud_ref_no        NUMBER(8);
   l_session_code       NUMBER(4);
 --  dates_cursor         all_payment_cursor_type;
   
BEGIN

   l_default_term := check_default_terms (p_stud_crse_year_id);
   
   l_study_end_date := getStudyEnddate (p_stud_crse_year_id);
   
   l_start_exists := checkStartDate (p_stud_crse_year_id);
   
   l_moreRecords := more_studcrse_year_record (p_stud_crse_year_id);
   
   l_countpayment := countPrevAwardPayments(p_stud_crse_year_id);
   
   IF l_moreRecords = 'Y' AND l_countpayment > 0
        THEN l_reduce_pay := 'Y';
        ELSE l_reduce_pay := 'N';
   END IF;
   
   IF l_reduce_pay = 'N'     ---- THERE IS NOT MORE THAN 1 STUD_CRSE_YEAR RECORD SO WE DO NOT HAVE TO AMEND DATES WITH PREVIOUSLY PAID INSTALMENTS.
        THEN
   

                                           IF l_start_exists = 'N'
                                           THEN  -- DEFAULT TERMS USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
                                              IF l_default_term = 'Y'
                                              THEN
                                                 l_max_term_default := get_max_term_default (p_stud_crse_year_id);


                                                    SELECT   COUNT(*)
                                                        INTO l_payment_date_count
                                                        FROM (SELECT payment_date
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >  --WE WANT TO RETURN ALL PAYMENT DATES FROM payment_dates table which are greater than inst_term.start_date
                                                                (SELECT inst.start_date
                                                                   FROM inst_term inst, stud_crse_year scy
                                                                  WHERE scy.inst_code = inst.inst_code
                                                                    AND inst.session_code = scy.session_code
                                                                    AND inst.term_no = 1
                                                                    AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                                    AND payment_date <= l_study_end_date) --- AND LESS THAN OR EQUAL TOO EITHER COURSE_END_DATE OR WITHDRAW OR COURSE CHANGE.
                                                     --   AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                       --                     where a.payment_status IN('S','P')  -- NEW
                                                         --                   and b.stud_crse_year_id = p_stud_crse_year_id)            
                                                    UNION
                                                    SELECT   it.start_date AS payment_date ---- WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                                                        FROM inst_term it, stud_crse_year scy
                                                       WHERE it.inst_code = scy.inst_code
                                                         AND it.session_code = scy.session_code
                                                         AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                         AND it.term_no = 1
                                                    ORDER BY payment_date ASC);
                                                    
                                              ELSE
                                                 l_max_term_no := get_max_term_no (p_stud_crse_year_id);

                                                 -- DEFAULT TERMS NOT USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
                                                   SELECT   COUNT(*)
                                                        INTO l_payment_date_count
                                                        FROM (SELECT payment_date 
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >
                                                                (SELECT a.start_date
                                                                   FROM crse_term a, stud_crse_year b
                                                                  WHERE a.crse_year_id = b.crse_year_id
                                                                    AND a.term_no = 1
                                                                    AND b.stud_crse_year_id = p_stud_crse_year_id)
                                                 --     AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                 --                           where a.payment_status IN('S','P')  -- NEW
                                                 --                           and b.stud_crse_year_id = p_stud_crse_year_id)   
                                                         AND payment_date <= l_study_end_date
                                                    UNION
                                                    SELECT   a.start_date AS payment_date  -- WE ALSO WANT TO GIVE A PAYMENT ON TEH DAY THE COURSE STARTS
                                                        FROM crse_term a, stud_crse_year b
                                                       WHERE a.crse_year_id = b.crse_year_id
                                                         AND a.term_no = 1
                                                         AND b.stud_crse_year_id = p_stud_crse_year_id
                                                    ORDER BY payment_date);
                                              END IF;
                                              
                                           ELSE        ---STUDY START DATE EXISTS BUT ONLY ONE STUD_CRSE_YEAR RECORD
                                                                                
                                              IF l_default_term = 'Y'
                                              THEN
                                                 l_max_term_default := get_max_term_default (p_stud_crse_year_id);

                                                   SELECT   COUNT(*)
                                                        INTO l_payment_date_count
                                                        FROM (SELECT payment_date
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >
                                                                     (SELECT start_date
                                                                        FROM stud_crse_year
                                                                       WHERE stud_crse_year_id = p_stud_crse_year_id)
                                                     --                AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                       --                     where a.payment_status IN('S','P')  -- NEW
                                                         --                   and b.stud_crse_year_id = p_stud_crse_year_id)  
                                                         AND payment_date <= l_study_end_date
                                                    UNION 
                                                    SELECT start_date
                                                    FROM stud_crse_year
                                                    WHERE stud_crse_year_id = p_stud_crse_year_id
                                                    ORDER BY payment_date);
                                              ELSE
                                              
                                                 l_max_term_no := get_max_term_no (p_stud_crse_year_id);

                                                 -- Get the payment dates for relevant student session dates
                                                   SELECT   COUNT(*)
                                                        INTO l_payment_date_count
                                                        FROM (SELECT payment_date
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >
                                                                     (SELECT start_date
                                                                        FROM stud_crse_year
                                                                       WHERE stud_crse_year_id = p_stud_crse_year_id)
                                                        --              AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                        --                    where a.payment_status IN('S','P')  -- NEW
                                                        --                    and b.stud_crse_year_id = p_stud_crse_year_id)  
                                                         AND payment_date <= l_study_end_date
                                                    UNION 
                                                    SELECT start_date
                                                    FROM stud_crse_year
                                                    WHERE stud_crse_year_id = p_stud_crse_year_id
                                                    ORDER BY payment_date);
                                              END IF;
                                           END IF;
                                           
    ELSE           ------ MORE THAN ONE STUD_CRSE_YEAR RECORD EXISTS
    
        SELECT STUD_REF_NO, SESSION_CODE
        INTO l_stud_ref_no, l_session_code
        FROM STUD_CRSE_YEAR
        WHERE STUD_CRSE_YEAR_ID = p_stud_crse_year_id;                         ----- WE DO NOT WANT TO BRING BACK THE START_DATE
    
    
                                            IF l_start_exists = 'N'
                                           THEN  -- DEFAULT TERMS USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
                                              IF l_default_term = 'Y'
                                              THEN
                                                 l_max_term_default := get_max_term_default (p_stud_crse_year_id);

                                                   SELECT   COUNT(*)
                                                        INTO l_payment_date_count
                                                        FROM (SELECT payment_date
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >  --WE WANT TO RETURN ALL PAYMENT DATES FROM payment_dates table which are greater than inst_term.start_date
                                                                (SELECT inst.start_date
                                                                   FROM inst_term inst, stud_crse_year scy
                                                                  WHERE scy.inst_code = inst.inst_code
                                                                    AND inst.session_code = scy.session_code
                                                                    AND inst.term_no = 1
                                                                    AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                                    AND payment_date <= l_study_end_date) --- AND LESS THAN OR EQUAL TOO EITHER COURSE_END_DATE OR WITHDRAW OR COURSE CHANGE.
                                                        AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
                                                                            and a.returned IN('N','A','T')
                                                                            and a.award_id = b.award_id
                                                                            and b.award_src = 'A'
                                                                            and b.stud_ref_no = l_stud_ref_no
                                                                            and b.session_code = l_session_code
                                                                            and b.stud_crse_year_id < p_stud_crse_year_id) 
                                                        ORDER BY payment_date ASC);          

                                                    
                                              ELSE
                                                 l_max_term_no := get_max_term_no (p_stud_crse_year_id);

                                                   SELECT   COUNT(*)
                                                        INTO l_payment_date_count
                                                        FROM (SELECT payment_date
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >
                                                                (SELECT a.start_date
                                                                   FROM crse_term a, stud_crse_year b
                                                                  WHERE a.crse_year_id = b.crse_year_id
                                                                    AND a.term_no = 1
                                                                    AND b.stud_crse_year_id = p_stud_crse_year_id)
                                                        AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
                                                                            and a.returned IN('N','A','T')
                                                                            and a.award_id = b.award_id
                                                                            and b.award_src = 'A'
                                                                            and b.stud_ref_no = l_stud_ref_no
                                                                            and b.session_code = l_session_code
                                                                            and b.stud_crse_year_id < p_stud_crse_year_id) 
                                                    ORDER BY payment_date);
                                              END IF;
                                              
                                           ELSE        ---STUDY START DATE EXISTS
                                                                                
                                              IF l_default_term = 'Y'
                                              THEN
                                                 l_max_term_default := get_max_term_default (p_stud_crse_year_id);

                                                    SELECT   COUNT(*)
                                                        INTO l_payment_date_count
                                                        FROM (SELECT payment_date
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >
                                                                     (SELECT start_date
                                                                        FROM stud_crse_year
                                                                       WHERE stud_crse_year_id = p_stud_crse_year_id)
                                                        AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
                                                                            and a.returned IN('N','A','T')                                                                      
                                                                            and a.award_id = b.award_id
                                                                            and b.award_src = 'A'
                                                                            and b.stud_ref_no = l_stud_ref_no
                                                                            and b.session_code = l_session_code
                                                                            and b.stud_crse_year_id < p_stud_crse_year_id) 
                                                         AND payment_date <= l_study_end_date
                                                    UNION 
                                                    SELECT start_date
                                                    FROM stud_crse_year
                                                    WHERE stud_crse_year_id = p_stud_crse_year_id
                                                    AND start_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
                                                                            and a.returned IN('N','A','T')
                                                                            and a.award_id = b.award_id
                                                                            and b.award_src = 'A'
                                                                            and b.stud_ref_no = l_stud_ref_no
                                                                            and b.session_code = l_session_code
                                                                            and b.stud_crse_year_id < p_stud_crse_year_id) 
                                                    ORDER BY payment_date);
                                                    
                                                   
                                              ELSE
                                              
                                                 l_max_term_no := get_max_term_no (p_stud_crse_year_id);

                                                 -- Get the payment dates for relevant student session dates
                                                    SELECT   COUNT(*)
                                                        INTO l_payment_date_count
                                                        FROM (SELECT payment_date
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >
                                                                     (SELECT start_date
                                                                        FROM stud_crse_year
                                                                       WHERE stud_crse_year_id = p_stud_crse_year_id)
                                                                         AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
                                                                            and returned IN('N','A','T')
                                                                            and a.award_id = b.award_id
                                                                            and b.award_src = 'A'
                                                                            and b.stud_ref_no = l_stud_ref_no
                                                                            and b.session_code = l_session_code
                                                                            and b.stud_crse_year_id < p_stud_crse_year_id) 
                                                         AND payment_date <= l_study_end_date
                                                    UNION 
                                                    SELECT start_date
                                                    FROM stud_crse_year
                                                    WHERE stud_crse_year_id = p_stud_crse_year_id
                                                    AND start_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
                                                                            and a.returned IN('N','A','T')
                                                                            and a.award_id = b.award_id
                                                                            and b.award_src = 'A'
                                                                            and b.stud_ref_no = l_stud_ref_no
                                                                            and b.session_code = l_session_code
                                                                            and b.stud_crse_year_id < p_stud_crse_year_id) 
                                                    ORDER BY payment_date);
                                                    
                                              END IF;
                                           END IF;
                                           
   END IF;
   
   RETURN l_payment_date_count;
   
END count_payment_dates;

FUNCTION count_payment_dates_2022 (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
   
   /*This function is called to spoof the award instalments
   for the changes to the overpayment calculation */
IS
   l_max_term_no        NUMBER;                 
   l_max_term_default   NUMBER;                
   l_payment_date_count   NUMBER;
   l_study_end_date     DATE;
   l_default_term       CHAR (1);
   l_moreRecords        CHAR(1); 
   l_countpayment       NUMBER(10);
   l_reduce_pay         CHAR(1);
   l_stud_ref_no        NUMBER(8);
   l_session_code       NUMBER(4);

   
BEGIN

   l_default_term := check_default_terms (p_stud_crse_year_id);
   
   l_study_end_date := getStudyEnddate_2022 (p_stud_crse_year_id);
   
   l_moreRecords := more_studcrse_year_record (p_stud_crse_year_id);
   
   l_countpayment := countPrevAwardPayments(p_stud_crse_year_id);
   
   IF l_moreRecords = 'Y' AND l_countpayment > 0
        THEN l_reduce_pay := 'Y';
        ELSE l_reduce_pay := 'N';
   END IF;
   
   IF l_reduce_pay = 'N'     ---- THERE IS NOT MORE THAN 1 STUD_CRSE_YEAR RECORD 
        THEN
   
                                            -- DEFAULT TERMS USED AND 
                                              IF l_default_term = 'Y'
                                              THEN
                                                 l_max_term_default := get_max_term_default (p_stud_crse_year_id);


                                                    SELECT   COUNT(*)
                                                        INTO l_payment_date_count
                                                        FROM (SELECT payment_date
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >  
                                                                (SELECT inst.start_date
                                                                   FROM inst_term inst, stud_crse_year scy
                                                                  WHERE scy.inst_code = inst.inst_code
                                                                    AND inst.session_code = scy.session_code
                                                                    AND inst.term_no = 1
                                                                    AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                                    AND payment_date <= l_study_end_date)          
                                                    UNION
                                                    SELECT   it.start_date AS payment_date ---- WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                                                        FROM inst_term it, stud_crse_year scy
                                                       WHERE it.inst_code = scy.inst_code
                                                         AND it.session_code = scy.session_code
                                                         AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                         AND it.term_no = 1
                                                    ORDER BY payment_date ASC);
                                                    
                                              ELSE
                                                 l_max_term_no := get_max_term_no (p_stud_crse_year_id);

                                                 -- DEFAULT TERMS 
                                                   SELECT   COUNT(*)
                                                        INTO l_payment_date_count
                                                        FROM (SELECT payment_date 
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >
                                                                (SELECT a.start_date
                                                                   FROM crse_term a, stud_crse_year b
                                                                  WHERE a.crse_year_id = b.crse_year_id
                                                                    AND a.term_no = 1
                                                                    AND b.stud_crse_year_id = p_stud_crse_year_id)   
                                                         AND payment_date <= l_study_end_date
                                                    UNION
                                                    SELECT   a.start_date AS payment_date  -- WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                                                        FROM crse_term a, stud_crse_year b
                                                       WHERE a.crse_year_id = b.crse_year_id
                                                         AND a.term_no = 1
                                                         AND b.stud_crse_year_id = p_stud_crse_year_id
                                                    ORDER BY payment_date);
                                              END IF;                                          
                                           
                                           
                                           
    ELSE           ------ MORE THAN ONE STUD_CRSE_YEAR RECORD EXISTS  
                                         
                                           -- DEFAULT TERMS USED 
                                              IF l_default_term = 'Y'
                                              THEN

                                                   SELECT   COUNT(*)
                                                        INTO l_payment_date_count
                                                        FROM (SELECT payment_date
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >  
                                                                (SELECT inst.start_date
                                                                   FROM inst_term inst, stud_crse_year scy
                                                                  WHERE scy.inst_code = inst.inst_code
                                                                    AND inst.session_code = scy.session_code
                                                                    AND inst.term_no = 1
                                                                    AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                                    AND payment_date <= l_study_end_date) 
                                                           UNION
                                                    SELECT   it.start_date AS payment_date ---- WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                                                        FROM inst_term it, stud_crse_year scy
                                                       WHERE it.inst_code = scy.inst_code
                                                         AND it.session_code = scy.session_code
                                                         AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                         AND it.term_no = 1                  
                                                        ORDER BY payment_date ASC);          

                                                    
                                              ELSE

                                                   SELECT   COUNT(*)
                                                        INTO l_payment_date_count
                                                        FROM (SELECT payment_date
                                                        FROM payment_dates@grass
                                                       WHERE payment_date >
                                                                (SELECT a.start_date
                                                                   FROM crse_term a, stud_crse_year b
                                                                  WHERE a.crse_year_id = b.crse_year_id
                                                                    AND a.term_no = 1
                                                                    AND b.stud_crse_year_id = p_stud_crse_year_id)
                                                        AND payment_date  <= l_study_end_date
                                                     UNION
                                                    SELECT   a.start_date AS payment_date  -- WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                                                        FROM crse_term a, stud_crse_year b
                                                       WHERE a.crse_year_id = b.crse_year_id
                                                         AND a.term_no = 1
                                                         AND b.stud_crse_year_id = p_stud_crse_year_id
                                                    ORDER BY payment_date);
                                              END IF;
                                              
                                           
                                           
                                           
   END IF;
   
   RETURN l_payment_date_count;
   
END count_payment_dates_2022;

FUNCTION count_top_payment_dates (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
IS
   l_max_term_no                    NUMBER;
   l_max_term_default               NUMBER;
   l_payment_date_count             NUMBER;
   l_study_end_date                 DATE;
   l_start_exists                   CHAR;
   l_default_term                   CHAR (1);
   l_moreRecords                    CHAR (1);
   l_countpayment                   NUMBER (10);
   l_reduce_pay                     CHAR (1);
   l_stud_ref_no                    NUMBER (8);
   l_session_code                   NUMBER (4);
   l_top_payment_date_range_start   DATE;
   
BEGIN
   l_default_term := check_default_terms (p_stud_crse_year_id);

   l_study_end_date := getTopStudyEnddate (p_stud_crse_year_id);

   l_start_exists := checkStartDate (p_stud_crse_year_id);

   l_moreRecords := more_studcrse_year_record (p_stud_crse_year_id);

   l_countpayment := countPrevAwardPayments (p_stud_crse_year_id);

   IF l_moreRecords = 'Y' AND l_countpayment > 0
   THEN
      l_reduce_pay := 'Y';
   ELSE
      l_reduce_pay := 'N';
   END IF;

   IF l_reduce_pay = 'N' -- THERE IS NOT MORE THAN 1 STUD_CRSE_YEAR RECORD SO WE DO NOT HAVE TO AMEND DATES WITH PREVIOUSLY PAID INSTALMENTS.
   THEN
      IF l_start_exists = 'N'
      THEN       -- DEFAULT TERMS USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
         IF l_default_term = 'Y'
         THEN
            l_max_term_default := get_max_term_default (p_stud_crse_year_id);

            SELECT inst.start_date
              INTO l_top_payment_date_range_start
              FROM inst_term inst, stud_crse_year scy
             WHERE     scy.inst_code = inst.inst_code
                   AND inst.session_code = scy.session_code
                   AND inst.term_no = 1
                   AND scy.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            SELECT COUNT (*)
              INTO l_payment_date_count
              FROM (SELECT payment_date
                      FROM payment_dates@grass
                     WHERE     payment_date > --WE WANT TO RETURN ALL PAYMENT DATES FROM payment_dates table which are greater than inst_term.start_date
                                             l_top_payment_date_range_start
                           AND payment_date <= l_study_end_date
                    UNION
                    SELECT it.start_date AS payment_date -- WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                      FROM inst_term it, stud_crse_year scy
                     WHERE     it.inst_code = scy.inst_code
                           AND it.session_code = scy.session_code
                           AND scy.stud_crse_year_id = p_stud_crse_year_id
                           AND it.term_no = 1
                    ORDER BY payment_date ASC);
         ELSE
            l_max_term_no := get_max_term_no (p_stud_crse_year_id);

            SELECT a.start_date
              INTO l_top_payment_date_range_start
              FROM crse_term a, stud_crse_year b
             WHERE     a.crse_year_id = b.crse_year_id
                   AND a.term_no = 1
                   AND b.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            -- DEFAULT TERMS NOT USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
            SELECT COUNT (*)
              INTO l_payment_date_count
              FROM (SELECT payment_date
                      FROM payment_dates@grass
                     WHERE     payment_date > l_top_payment_date_range_start
                           AND payment_date <= l_study_end_date
                    UNION
                    SELECT a.start_date AS payment_date -- WE ALSO WANT TO GIVE A PAYMENT ON TEH DAY THE COURSE STARTS
                      FROM crse_term a, stud_crse_year b
                     WHERE     a.crse_year_id = b.crse_year_id
                           AND a.term_no = 1
                           AND b.stud_crse_year_id = p_stud_crse_year_id
                    ORDER BY payment_date);
         END IF;
      ELSE       --STUDY START DATE EXISTS BUT ONLY ONE STUD_CRSE_YEAR RECORD
         IF l_default_term = 'Y'
         THEN
            l_max_term_default := get_max_term_default (p_stud_crse_year_id);

            SELECT start_date
              INTO l_top_payment_date_range_start
              FROM stud_crse_year
             WHERE stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            SELECT COUNT (*)
              INTO l_payment_date_count
              FROM (SELECT payment_date
                      FROM payment_dates@grass
                     WHERE     payment_date > l_top_payment_date_range_start
                           AND payment_date <= l_study_end_date
                    UNION
                    SELECT start_date
                      FROM stud_crse_year
                     WHERE stud_crse_year_id = p_stud_crse_year_id
                    ORDER BY payment_date);
         ELSE
            l_max_term_no := get_max_term_no (p_stud_crse_year_id);

            SELECT start_date
              INTO l_top_payment_date_range_start
              FROM stud_crse_year
             WHERE stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            -- Get the payment dates for relevant student session dates
            SELECT COUNT (*)
              INTO l_payment_date_count
              FROM (SELECT payment_date
                      FROM payment_dates@grass
                     WHERE     payment_date > l_top_payment_date_range_start
                           AND payment_date <= l_study_end_date
                    UNION
                    SELECT start_date
                      FROM stud_crse_year
                     WHERE stud_crse_year_id = p_stud_crse_year_id
                    ORDER BY payment_date);
         END IF;
      END IF;
   ELSE                      -- MORE THAN ONE STUD_CRSE_YEAR RECORD EXISTS
      SELECT STUD_REF_NO, SESSION_CODE
        INTO l_stud_ref_no, l_session_code
        FROM STUD_CRSE_YEAR
       WHERE STUD_CRSE_YEAR_ID = p_stud_crse_year_id; -- WE DO NOT WANT TO BRING BACK THE START_DATE

      IF l_start_exists = 'N'
      THEN       -- DEFAULT TERMS USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
         IF l_default_term = 'Y'
         THEN
            l_max_term_default := get_max_term_default (p_stud_crse_year_id);

            SELECT inst.start_date
              INTO l_top_payment_date_range_start
              FROM inst_term inst, stud_crse_year scy
             WHERE     scy.inst_code = inst.inst_code
                   AND inst.session_code = scy.session_code
                   AND inst.term_no = 1
                   AND scy.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            SELECT COUNT (*)
              INTO l_payment_date_count
              FROM (  SELECT payment_date
                        FROM payment_dates@grass
                       WHERE     payment_date > --WE WANT TO RETURN ALL PAYMENT DATES FROM payment_dates table which are greater than inst_term.start_date
                                               l_top_payment_date_range_start
                             AND payment_date <= l_study_end_date
                             AND payment_date >
                                    (SELECT MAX (a.payment_due_date)
                                       FROM award_instalment a, award b
                                      WHERE     a.payment_status IN ('S', 'P')
                                            AND a.returned IN ('N', 'A', 'T')
                                            AND a.award_id = b.award_id
                                            AND b.award_src = 'A'
                                            AND b.stud_ref_no = l_stud_ref_no
                                            AND b.session_code = l_session_code
                                            AND b.stud_crse_year_id <
                                                   p_stud_crse_year_id)
                    ORDER BY payment_date ASC);
         ELSE
            l_max_term_no := get_max_term_no (p_stud_crse_year_id);

            SELECT a.start_date
              INTO l_top_payment_date_range_start
              FROM crse_term a, stud_crse_year b
             WHERE     a.crse_year_id = b.crse_year_id
                   AND a.term_no = 1
                   AND b.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            SELECT COUNT (*)
              INTO l_payment_date_count
              FROM (  SELECT payment_date
                        FROM payment_dates@grass
                       WHERE     payment_date > l_top_payment_date_range_start
                             AND payment_date >
                                    (SELECT MAX (a.payment_due_date)
                                       FROM award_instalment a, award b
                                      WHERE     a.payment_status IN ('S', 'P')
                                            AND a.returned IN ('N', 'A', 'T')
                                            AND a.award_id = b.award_id
                                            AND b.award_src = 'A'
                                            AND b.stud_ref_no = l_stud_ref_no
                                            AND b.session_code = l_session_code
                                            AND b.stud_crse_year_id <
                                                   p_stud_crse_year_id)
                    ORDER BY payment_date);
         END IF;
      ELSE                                          --STUDY START DATE EXISTS
         IF l_default_term = 'Y'
         THEN
            l_max_term_default := get_max_term_default (p_stud_crse_year_id);

            SELECT start_date
              INTO l_top_payment_date_range_start
              FROM stud_crse_year
             WHERE stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            SELECT COUNT (*)
              INTO l_payment_date_count
              FROM (SELECT payment_date
                      FROM payment_dates@grass
                     WHERE     payment_date > l_top_payment_date_range_start
                           AND payment_date >
                                  (SELECT MAX (a.payment_due_date)
                                     FROM award_instalment a, award b
                                    WHERE     a.payment_status IN ('S', 'P')
                                          AND a.returned IN ('N', 'A', 'T')
                                          AND a.award_id = b.award_id
                                          AND b.award_src = 'A'
                                          AND b.stud_ref_no = l_stud_ref_no
                                          AND b.session_code = l_session_code
                                          AND b.stud_crse_year_id <
                                                 p_stud_crse_year_id)
                           AND payment_date <= l_study_end_date
                    UNION
                    SELECT start_date
                      FROM stud_crse_year
                     WHERE     stud_crse_year_id = p_stud_crse_year_id
                           AND start_date >
                                  (SELECT MAX (a.payment_due_date)
                                     FROM award_instalment a, award b
                                    WHERE     a.payment_status IN ('S', 'P')
                                          AND a.returned IN ('N', 'A', 'T')
                                          AND a.award_id = b.award_id
                                          AND b.award_src = 'A'
                                          AND b.stud_ref_no = l_stud_ref_no
                                          AND b.session_code = l_session_code
                                          AND b.stud_crse_year_id <
                                                 p_stud_crse_year_id)
                    ORDER BY payment_date);
         ELSE
            l_max_term_no := get_max_term_no (p_stud_crse_year_id);

            SELECT start_date
              INTO l_top_payment_date_range_start
              FROM stud_crse_year
             WHERE stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            -- Get the payment dates for relevant student session dates
            SELECT COUNT (*)
              INTO l_payment_date_count
              FROM (SELECT payment_date
                      FROM payment_dates@grass
                     WHERE     payment_date > l_top_payment_date_range_start
                           AND payment_date >
                                  (SELECT MAX (a.payment_due_date)
                                     FROM award_instalment a, award b
                                    WHERE     a.payment_status IN ('S', 'P')
                                          AND returned IN ('N', 'A', 'T')
                                          AND a.award_id = b.award_id
                                          AND b.award_src = 'A'
                                          AND b.stud_ref_no = l_stud_ref_no
                                          AND b.session_code = l_session_code
                                          AND b.stud_crse_year_id <
                                                 p_stud_crse_year_id)
                           AND payment_date <= l_study_end_date
                    UNION
                    SELECT start_date
                      FROM stud_crse_year
                     WHERE     stud_crse_year_id = p_stud_crse_year_id
                           AND start_date >
                                  (SELECT MAX (a.payment_due_date)
                                     FROM award_instalment a, award b
                                    WHERE     a.payment_status IN ('S', 'P')
                                          AND a.returned IN ('N', 'A', 'T')
                                          AND a.award_id = b.award_id
                                          AND b.award_src = 'A'
                                          AND b.stud_ref_no = l_stud_ref_no
                                          AND b.session_code = l_session_code
                                          AND b.stud_crse_year_id <
                                                 p_stud_crse_year_id)
                    ORDER BY payment_date);
         END IF;
      END IF;
   END IF;

   RETURN l_payment_date_count;
END count_top_payment_dates;


FUNCTION count_top_payment_dates_2022 (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
IS

   l_payment_date_count             NUMBER;
   l_study_end_date                 DATE;
   l_default_term                   CHAR (1);
   l_moreRecords                    CHAR (1);
   l_countpayment                   NUMBER (10);
   l_reduce_pay                     CHAR (1);
   l_top_payment_date_range_start   DATE;
   
BEGIN
   l_default_term := check_default_terms (p_stud_crse_year_id);

   l_study_end_date := getTopStudyEnddate_2022 (p_stud_crse_year_id);

   l_moreRecords := more_studcrse_year_record (p_stud_crse_year_id);

   l_countpayment := countPrevAwardPayments (p_stud_crse_year_id);

   IF l_moreRecords = 'Y' AND l_countpayment > 0
   THEN
      l_reduce_pay := 'Y';
   ELSE
      l_reduce_pay := 'N';
   END IF;

   IF l_reduce_pay = 'N' -- THERE IS NOT MORE THAN 1 STUD_CRSE_YEAR RECORD SO WE DO NOT HAVE TO AMEND DATES WITH PREVIOUSLY PAID INSTALMENTS.
   THEN
        -- DEFAULT TERMS USED 
         IF l_default_term = 'Y'
         THEN


            SELECT inst.start_date
              INTO l_top_payment_date_range_start
              FROM inst_term inst, stud_crse_year scy
             WHERE     scy.inst_code = inst.inst_code
                   AND inst.session_code = scy.session_code
                   AND inst.term_no = 1
                   AND scy.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            SELECT COUNT (*)
              INTO l_payment_date_count
              FROM (SELECT payment_date
                      FROM payment_dates@grass
                     WHERE     payment_date > 
                                             l_top_payment_date_range_start
                           AND payment_date <= l_study_end_date
                    UNION
                    SELECT it.start_date AS payment_date -- WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                      FROM inst_term it, stud_crse_year scy
                     WHERE     it.inst_code = scy.inst_code
                           AND it.session_code = scy.session_code
                           AND scy.stud_crse_year_id = p_stud_crse_year_id
                           AND it.term_no = 1
                    ORDER BY payment_date ASC);
         ELSE

            SELECT a.start_date
              INTO l_top_payment_date_range_start
              FROM crse_term a, stud_crse_year b
             WHERE     a.crse_year_id = b.crse_year_id
                   AND a.term_no = 1
                   AND b.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            -- DEFAULT TERMS NOT USED AND NO STUD_CRSE_YEAR.START_DATE EXISTS
            SELECT COUNT (*)
              INTO l_payment_date_count
              FROM (SELECT payment_date
                      FROM payment_dates@grass
                     WHERE     payment_date > l_top_payment_date_range_start
                           AND payment_date <= l_study_end_date
                    UNION
                    SELECT a.start_date AS payment_date -- WE ALSO WANT TO GIVE A PAYMENT ON TEH DAY THE COURSE STARTS
                      FROM crse_term a, stud_crse_year b
                     WHERE     a.crse_year_id = b.crse_year_id
                           AND a.term_no = 1
                           AND b.stud_crse_year_id = p_stud_crse_year_id
                    ORDER BY payment_date);
         END IF;
      
   ELSE  -- MORE THAN ONE STUD_CRSE_YEAR RECORD EXISTS
        -- DEFAULT TERMS USED
         IF l_default_term = 'Y'
         THEN


            SELECT inst.start_date
              INTO l_top_payment_date_range_start
              FROM inst_term inst, stud_crse_year scy
             WHERE     scy.inst_code = inst.inst_code
                   AND inst.session_code = scy.session_code
                   AND inst.term_no = 1
                   AND scy.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            SELECT COUNT (*)
              INTO l_payment_date_count
              FROM (SELECT payment_date
                      FROM payment_dates@grass
                     WHERE     payment_date > 
                                             l_top_payment_date_range_start
                           AND payment_date <= l_study_end_date
                    UNION
                    SELECT it.start_date AS payment_date -- WE ALSO WANT TO GIVE A PAYMENT ON THE DAY THE COURSE STARTS
                      FROM inst_term it, stud_crse_year scy
                     WHERE     it.inst_code = scy.inst_code
                           AND it.session_code = scy.session_code
                           AND scy.stud_crse_year_id = p_stud_crse_year_id
                           AND it.term_no = 1
                    ORDER BY payment_date ASC);
         ELSE

            SELECT a.start_date
              INTO l_top_payment_date_range_start
              FROM crse_term a, stud_crse_year b
             WHERE     a.crse_year_id = b.crse_year_id
                   AND a.term_no = 1
                   AND b.stud_crse_year_id = p_stud_crse_year_id;

            l_top_payment_date_range_start :=
               LAST_DAY (l_top_payment_date_range_start);

            SELECT COUNT (*)
              INTO l_payment_date_count
              FROM (SELECT payment_date
                      FROM payment_dates@grass
                     WHERE     payment_date > l_top_payment_date_range_start
                           AND payment_date <= l_study_end_date
                    UNION
                    SELECT a.start_date AS payment_date -- WE ALSO WANT TO GIVE A PAYMENT ON TEH DAY THE COURSE STARTS
                      FROM crse_term a, stud_crse_year b
                     WHERE     a.crse_year_id = b.crse_year_id
                           AND a.term_no = 1
                           AND b.stud_crse_year_id = p_stud_crse_year_id
                    ORDER BY payment_date);
         END IF;
      
         
          
         END IF;


   RETURN l_payment_date_count;
END count_top_payment_dates_2022; 
   
FUNCTION triplepayment_flag (p_stud_crse_year_id IN NUMBER)
   RETURN CHAR
IS

   l_default_term         CHAR (1);
   l_triplepayment_flag   CHAR(1);
   l_triple               NUMBER;
BEGIN
   l_default_term := check_default_terms (p_stud_crse_year_id);

   IF l_default_term = 'Y'
   THEN


      SELECT COUNT (payment_date)
        INTO l_triple
        FROM payment_dates@grass
       WHERE payment_date =
                (SELECT CASE
                        WHEN scy.start_date IS NULL
                        THEN inst.start_date
                        ELSE scy.start_date
                        END CASE
                   FROM inst_term inst, stud_crse_year scy
                  WHERE scy.inst_code = inst.inst_code
                    AND inst.session_code = scy.session_code
                    AND inst.term_no = 1
                    AND scy.stud_crse_year_id = p_stud_crse_year_id);
   ELSE
   

      SELECT COUNT (payment_date)
        INTO l_triple
        FROM payment_dates@grass
       WHERE payment_date =
                (SELECT CASE
                        WHEN b.start_date IS NULL
                        THEN a.start_date 
                        ELSE b.start_date
                        END CASE
                   FROM crse_term a, stud_crse_year b
                  WHERE a.crse_year_id = b.crse_year_id
                    AND a.term_no = 1
                    AND b.session_code = b.session_code
                    AND b.stud_crse_year_id = p_stud_crse_year_id);
   END IF;
   
           CASE
            WHEN l_triple = 0
            THEN l_triplepayment_flag := 'N';
            ELSE l_triplepayment_flag := 'Y';
            END CASE;

   RETURN l_triplepayment_flag;
END;

FUNCTION triplepayment_flag_2022 (p_stud_crse_year_id IN NUMBER)
   RETURN CHAR
IS

   l_default_term         CHAR (1);
   l_triplepayment_flag   CHAR(1);
   l_triple               NUMBER;
BEGIN
   l_default_term := check_default_terms (p_stud_crse_year_id);

   IF l_default_term = 'Y'
   THEN


      SELECT COUNT (payment_date)
        INTO l_triple
        FROM payment_dates@grass
       WHERE payment_date =(SELECT inst.start_date
                   FROM inst_term inst, stud_crse_year scy
                  WHERE scy.inst_code = inst.inst_code
                    AND inst.session_code = scy.session_code
                    AND inst.term_no = 1
                    AND scy.stud_crse_year_id = p_stud_crse_year_id);
   ELSE
   

      SELECT COUNT (payment_date)
        INTO l_triple
        FROM payment_dates@grass
       WHERE payment_date =(SELECT a.start_date 
                   FROM crse_term a, stud_crse_year b
                  WHERE a.crse_year_id = b.crse_year_id
                    AND a.term_no = 1
                    AND b.session_code = b.session_code
                    AND b.stud_crse_year_id = p_stud_crse_year_id);
   END IF;
   
           CASE
            WHEN l_triple = 0
            THEN l_triplepayment_flag := 'N';
            ELSE l_triplepayment_flag := 'Y';
            END CASE;

   RETURN l_triplepayment_flag;
END;
    

FUNCTION count_awards (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
IS
   l_total_awards   NUMBER := NULL;
BEGIN
   SELECT COUNT (award_id)
     INTO l_total_awards
     FROM award
    WHERE stud_crse_year_id = p_stud_crse_year_id;

   RETURN l_total_awards;
END count_awards; 
    

FUNCTION getfeespaidamount (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
IS
   l_fees_paid_amount   NUMBER := 0;
   l_fees_trans_created NUMBER := 0;
   l_total              NUMBER := 0;
   
   
   
BEGIN
   SELECT NVL (SUM (b.net_amount), 0)
     INTO l_fees_paid_amount
     FROM award a, award_instalment b
    WHERE a.award_id = b.award_id
      AND a.award_src = 'T'
      AND b.payment_status IN('S', 'P')
      AND b.returned IN('N','A','T')
      AND a.stud_crse_year_id = p_stud_crse_year_id;
      
      
      SELECT NVL (SUM (b.net_amount), 0)
     INTO l_fees_trans_created
     FROM award a, award_instalment b
    WHERE a.award_id = b.award_id
      AND a.award_src = 'T'
      AND b.payment_status IN('U')
      AND B.FEE_LOAN_TRANSACTION_CREATED = 'Y'
      AND a.stud_crse_year_id = p_stud_crse_year_id;
      
      l_total := l_fees_paid_amount + l_fees_trans_created;
      
      
      

   RETURN l_total;
   
END getfeespaidamount;


--THIS FUNCTION RETURNS THE STUDENTS AGE WHEN THEY START COURSE BASED ON 01-AUGUST/SESSION
FUNCTION get_stud_age (p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS

    l_studAge   NUMBER := 0;
    l_startYear NUMBER := 0;
    
    BEGIN
    
    SELECT s.commence_session
    INTO l_startYear
    FROM STUD s, stud_crse_year b
    WHERE s.stud_ref_no = b.stud_ref_no
    AND b.stud_crse_year_id = p_stud_crse_year_id; 
    
    --get_start_year (p_stud_crse_year_id);
    
    SELECT( 
            SELECT FLOOR( (MONTHS_BETWEEN (TO_DATE (CONCAT ('01-AUG-',l_startYear),'DD/MM/YYYY'),a.dob)/ 12))
                  FROM DUAL) AS DOB
                  INTO l_studAge
                  FROM STUD a, STUD_CRSE_YEAR b
             WHERE a.stud_ref_no = b.stud_ref_no
             AND b.stud_crse_year_id = p_stud_crse_year_id;     
                      
             RETURN l_studAge;
             
END get_stud_age;
        

-----THIS FUNCTION IS ONLY CALLED IF JA_CASE AND THE JA_STUD_TYPE IS PARENT.  It finds the benefactor 1 income for the joint child and return this value.
FUNCTION getJACASEParentIncomeBen1(p_ja_case_id IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER
IS

    l_result    NUMBER;
    v_ben_id    NUMBER;
    v_count     NUMBER;
    
    BEGIN
    
    SELECT COUNT(BEN1_ID)
    INTO v_count
    FROM STUD_SESSION
    WHERE JA_CASE_ID = p_ja_case_id
    AND ben1_rel_id <> 28;
    
    IF v_count > 0
    
        THEN
    
            SELECT DISTINCT BEN1_ID
            INTO v_ben_id
            FROM STUD_SESSION
            WHERE JA_CASE_ID = p_ja_case_id
            AND ben1_rel_id <> 28;
    
    
                l_result :=  sgas.rules_proc_recalc.getBenIncome(v_ben_id, p_session_code);
        
    ELSE
        
        l_result := 0;
        
    END IF;
    
    
    RETURN l_result;
    
    
END getJACASEParentIncomeBen1;

-----THIS FUNCTION IS ONLY CALLED IF JA_CASE AND THE JA_STUD_TYPE IS PARENT.  It finds the benefactor 1 income for the joint child and return this value.
FUNCTION getJACASEParentIncomeBen2(p_ja_case_id IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER
IS

    l_result    NUMBER;
    v_ben_id    NUMBER;
    v_count     NUMBER;
    
    BEGIN
    
    SELECT COUNT(BEN2_ID)
    INTO v_count
    FROM STUD_SESSION
    WHERE JA_CASE_ID = p_ja_case_id
    AND ben1_rel_id <> 28;
    
    IF v_count > 0
    
        THEN
    
            SELECT DISTINCT BEN2_ID
            INTO v_ben_id
            FROM STUD_SESSION
            WHERE JA_CASE_ID = p_ja_case_id
            AND ben1_rel_id <> 28;
    
    
                l_result :=  sgas.rules_proc_recalc.getBenIncome(v_ben_id, p_session_code);
        
    ELSE
        
        l_result := 0;
        
    END IF;
    
    
    RETURN l_result;
    
    
END getJACASEParentIncomeBen2;
    
        
        
        
        
FUNCTION getBenIncome(p_ben_id IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER
IS

    l_result    NUMBER;
    
    BEGIN
    
    SELECT SUM(NVL(bank_interest, 0)
               + NVL (benefit, 0)
               + NVL (other_income, 0)
               + NVL (nat_saving_interest, 0)
               + NVL (paye_income, 0)
               + NVL (pension, 0)
               + NVL (self_employment, 0)
               + NVL (property, 0)
               + NVL (dividend, 0)
               + NVL (working_tax_credit, 0)
            - NVL (other_deduct, 0))
    INTO l_result
    FROM BENEFACTOR_INCOME
    WHERE ben_id = p_ben_id
    AND session_code = p_session_code;
    
    RETURN l_result;
    
END getBenIncome;
    
FUNCTION getNoSharingChildren(p_ja_case_id IN NUMBER) RETURN NUMBER
IS

    l_result    NUMBER;
    l_result2   NUMBER;
    l_result3   NUMBER;
    
    BEGIN
    
    SELECT COUNT(*)
    INTO l_result
    FROM STUD_SESSION a
    WHERE a.ja_case_id = p_ja_case_id
    AND a.ja_stud_type = 'C';
    
    
    SELECT NVL(NO_NON_SAAS_CHILDREN,0) 
    INTO l_result2
    FROM JA_CASE
    WHERE ja_case_id = p_ja_case_id;
    
    
    l_result3 := l_result + l_result2;
    
    RETURN l_result3;
    
END getNoSharingChildren;

FUNCTION get_prev_bursary (p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS
    l_result        CHAR;

    
    BEGIN
    
          SELECT   
            CASE
                WHEN sgas.rules_proc_recalc.prev_session_bursary(p_stud_crse_year_id) = 'Y' AND sgas.rules_proc_recalc.get_stud_age(p_stud_crse_year_id) > 25
                THEN 'N'
                ELSE sgas.rules_proc_recalc.prev_session_bursary(p_stud_crse_year_id)
            END 
            INTO  l_result
            FROM dual;
            
    RETURN l_result;

    
    END get_prev_bursary;
    
FUNCTION get_calc_bursary (p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS
    l_result                CHAR;
    l_calc_bursary          CHAR;
    l_award                 CHAR;
    l_paid_sandwich         CHAR;
    l_parent_contrib_exempt CHAR;
    l_ben1_rel_id           NUMBER;
    l_pams_crse             CHAR;

 BEGIN
 
        SELECT  c.PAMS_COURSE 
        INTO l_pams_crse
        FROM stud_crse_year scy,
             crse_year cy,
             crse_session cs,
             crse c,
             inst i
       WHERE scy.crse_year_id = cy.crse_year_id
         AND cy.crse_session_id = cs.crse_session_id
         AND cy.crse_id = cs.crse_id
         AND cs.crse_id = c.crse_id
         AND c.inst_code = i.inst_code
         AND scy.stud_crse_year_id = p_stud_crse_year_id;
    
    SELECT ben1_rel_id
    INTO l_ben1_rel_id
    FROM stud_crse_year a, stud_session b
    WHERE a.stud_session_id = B.STUD_SESSION_ID
    AND a.stud_crse_year_id = p_stud_crse_year_id;
    
    SELECT calc_bursary, award, paid_sandwich, parent_contrib_exempt
    INTO l_calc_bursary, l_award, l_paid_sandwich, l_parent_contrib_exempt 
    FROM stud_crse_year
    WHERE stud_crse_year_id = p_stud_crse_year_id;

    
            SELECT  
                CASE
                WHEN (l_paid_sandwich = 'Y') OR (l_pams_crse = 'Y') OR (l_parent_contrib_exempt = 'N' AND l_calc_bursary = 'Y' AND l_ben1_rel_id IS NULL
                    )
                   THEN 'N'
                WHEN get_missingben1data (p_stud_crse_year_id) = 'Y' OR get_missingben2data (p_stud_crse_year_id) = 'Y'
                   THEN 'N'
                WHEN sgas.rules_proc_recalc.award_status(p_stud_crse_year_id) IN('C', 'D') 
                   THEN 'N'
                ELSE l_calc_bursary
                END
                INTO l_result
                FROM dual;
                
    RETURN l_result;            
    
    END get_calc_bursary;
    
FUNCTION award_status(p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS

    l_result        CHAR;
    
    BEGIN
        SELECT
        CASE 
            WHEN scy.award IN('B','D')
            THEN SCY.AWARD
            WHEN NVL(sgas.rules_proc_recalc.getPrevSessionProvisionalFlag(scy.stud_ref_no, scy.session_code),'N') = 'Y' 
            THEN 'C'
        ELSE
            CASE
            WHEN  SCY.PARENT_CONTRIB_EXEMPT = 'N' AND 
                SS.BEN1_ID IS NULL AND 
                SS.BEN2_ID IS NULL
            THEN 'A'
            ELSE 'E'
            END 
        END award_given
        INTO l_result
        FROM stud_crse_year scy, stud_session ss
        WHERE scy.stud_session_id = SS.STUD_SESSION_ID
        AND scy.stud_crse_year_id = p_stud_crse_year_id;
        
    RETURN l_result;    
    
    END award_status;
    
FUNCTION set_ruk_fee_cap(p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS
    ruk_fee_cap                     NUMBER;
    fee_override_amount             NUMBER;
    paid_sandwich                   CHAR;
    unpaid_sandwich                 CHAR;
    var_sandwich_tuition_fee_amnt   NUMBER;
    var_tuition_fee_amnt            NUMBER;
    dearing                         CHAR;
    abroad                          CHAR;
    NON_ERASMUS_EXCHANGE            CHAR;
    
    BEGIN
       SELECT nvl(SCY.VARIABLE_FEE_OVERRIDE_AMOUNT,0), SCY.UNPAID_SANDWICH, SCY.PAID_SANDWICH, cy.VAR_TUITION_FEE_AMNT, cy.VAR_SANDWICH_TUITION_FEE_AMNT, scy.dearing, scy.study_abroad, scy.NON_ERASMUS_EXCHANGE
       INTO fee_override_amount, unpaid_sandwich, paid_sandwich, var_tuition_fee_amnt, var_sandwich_tuition_fee_amnt, dearing, abroad, NON_ERASMUS_EXCHANGE
       FROM stud_crse_year scy,
             stud_session ss,
             crse c,
             crse_session cs,
             crse_year cy,
             inst i
       WHERE scy.stud_crse_year_id = p_stud_crse_year_id
         AND c.crse_id = cs.crse_id
         AND cy.crse_session_id = cs.crse_session_id
         AND scy.crse_year_id = cy.crse_year_id
         AND scy.inst_code = i.inst_code
         AND ss.stud_session_id = scy.stud_session_id;
         
         IF (fee_override_amount > 0 AND dearing ='G')
         THEN
                ruk_fee_cap := fee_override_amount;
         ELSIF ((fee_override_amount = 0) AND (paid_sandwich = 'Y' OR unpaid_sandwich = 'Y') AND dearing ='G')
         THEN
                ruk_fee_cap := var_sandwich_tuition_fee_amnt;
         ELSIF (fee_override_amount = 0 AND (paid_sandwich = 'N' OR unpaid_sandwich = 'N') AND dearing ='G' AND abroad = 'N')
         THEN
                ruk_fee_cap := var_tuition_fee_amnt;
         ELSIF ((paid_sandwich = 'N' AND unpaid_sandwich = 'N') AND abroad = 'Y' AND dearing ='G' AND fee_override_amount = 0 AND sgas.rules_proc_recalc.getPartYearAbroad(p_stud_crse_year_id) = 'N' AND NON_ERASMUS_EXCHANGE = 'Y')
         THEN
               ruk_fee_cap := var_tuition_fee_amnt;
         ELSIF ((paid_sandwich = 'N' AND unpaid_sandwich = 'N') AND abroad = 'Y' AND dearing ='G' AND fee_override_amount = 0 AND sgas.rules_proc_recalc.getPartYearAbroad(p_stud_crse_year_id) = 'N') 
         THEN
                ruk_fee_cap := var_sandwich_tuition_fee_amnt;

         ELSIF sgas.rules_proc_recalc.getPartYearAbroad(p_stud_crse_year_id) = 'Y'
         THEN   ruk_fee_cap := var_tuition_fee_amnt;
         END IF;
                
    RETURN ruk_fee_cap;

END set_ruk_fee_cap;

FUNCTION does_stud_dep_exist (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR
   IS
      l_count    NUMBER;
      l_result   CHAR;
   BEGIN
      SELECT COUNT (*)
        INTO l_count
        FROM stud_dependant a, stud_crse_year b
       WHERE a.stud_session_id = b.stud_session_id
         AND b.stud_crse_year_id = p_stud_crse_year_id;

      IF l_count > 0
      THEN
         l_result := 'Y';
      ELSE
         l_result := 'N';
      END IF;

      RETURN l_result;
   END does_stud_dep_exist;

   FUNCTION is_there_a_spouse (p_stud_crse_year_id IN NUMBER) --this determines whether you have a dependant adult in the STUD_DEPENDANT table EXCLUDING 'Adult_I_Act_as_carer_for
      RETURN CHAR
   IS
      l_dep_count   NUMBER;
      l_result      CHAR;
     -- l_scheme      CHAR;
   BEGIN

                SELECT COUNT (a.std_id)
                INTO l_dep_count
                FROM stud_dependant a, stud_crse_year b
               WHERE a.stud_session_id = b.stud_session_id
                 AND b.stud_crse_year_id = p_stud_crse_year_id
                 AND a.relation_id IN (35,36,37,38,39,40,41,42,43,48,49,508,509,650);  
     

      IF l_dep_count > 0
      THEN
         l_result := 'Y';
      ELSE
         l_result := 'N';
      END IF;

      RETURN l_result;
   END is_there_a_spouse;
   
   FUNCTION does_spouse_have_child (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR
   IS
      l_result      CHAR;
      l_dep         CHAR;
      l_dep_count   NUMBER;
   BEGIN
   
   l_dep := SGAS.rules_proc_recalc.IS_THERE_A_SPOUSE(p_stud_crse_year_id);
   
   SELECT COUNT (a.std_id)
        INTO l_dep_count
        FROM stud_dependant a, stud_crse_year b
       WHERE a.stud_session_id = b.stud_session_id
         AND b.stud_crse_year_id = p_stud_crse_year_id
         AND a.relation_id IN (46, 47, 510, 511, 600, 601, 602, 603);
         
         IF (l_dep = 'Y' AND l_dep_count > 0)
         THEN
            l_result := 'Y';
         ELSE
            l_result := 'N';
         END IF;
         
         RETURN l_result;
         
   
   END does_spouse_have_child;  
   
   FUNCTION adult_i_act_as_carer_for (p_stud_crse_year_id IN NUMBER)
        RETURN CHAR
   IS
     l_dep_count   NUMBER;
     l_result   CHAR;
   
   BEGIN
   
   SELECT COUNT (a.std_id)
        INTO l_dep_count
        FROM stud_dependant a, stud_crse_year b
       WHERE a.stud_session_id = b.stud_session_id
         AND b.stud_crse_year_id = p_stud_crse_year_id
         AND a.relation_id = '34';
         
   IF l_dep_count > 0
      THEN
         l_result := 'Y';
      ELSE
         l_result := 'N';
      END IF;

      RETURN l_result;
      
   END  adult_i_act_as_carer_for;   
   
   FUNCTION has_child_and_adult_dep (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR
   IS
      l_result      CHAR;
      l_dep         CHAR;
      l_dep_count   NUMBER;
   BEGIN
   
   l_dep := SGAS.rules_proc_recalc.adult_i_act_as_carer_for(p_stud_crse_year_id);
   
   SELECT COUNT (a.std_id)
        INTO l_dep_count
        FROM stud_dependant a, stud_crse_year b
       WHERE a.stud_session_id = b.stud_session_id
         AND b.stud_crse_year_id = p_stud_crse_year_id
         AND a.relation_id IN (46, 47, 510, 511, 600, 601, 602, 603);
         
         IF (l_dep = 'Y' AND l_dep_count > 0)
         THEN
            l_result := 'Y';
         ELSE
            l_result := 'N';
         END IF;
         
         RETURN l_result;
         
   
   END has_child_and_adult_dep;

   FUNCTION benefactor_with_income (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR
   IS
      l_ben1_id           NUMBER;
      l_ben2_id           NUMBER;
      l_stud_session_id   NUMBER;
      l_income            NUMBER;
      l_result            CHAR;
   BEGIN
      SELECT stud_session_id
        INTO l_stud_session_id
        FROM stud_crse_year
       WHERE stud_crse_year_id = p_stud_crse_year_id;

      SELECT ben1_id, ben2_id
        INTO l_ben1_id, l_ben2_id
        FROM stud_session
       WHERE stud_session_id = l_stud_session_id;

      l_income := sgas.rules_proc_recalc.get_ben_income (p_stud_crse_year_id);

      IF (l_ben1_id IS NOT NULL OR l_ben2_id IS NOT NULL) AND l_income >= 0
      THEN
         l_result := 'Y';
      ELSE
         l_result := 'N';
      END IF;

      RETURN l_result;
   END benefactor_with_income;
 
--the function below return a Y if all mandatory fields are present for LPCG to be calculated, this enables the checkbox on the award screen, otherwise return  N 
   FUNCTION lpcg_mandatory_fields (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR
   IS
      l_max_lpcg        CHAR;
      l_lpcg_req        NUMBER;
      l_childcare_num   VARCHAR2(100);
      l_childcare_name  VARCHAR2(600);
      l_result          CHAR;
   BEGIN
   
      SELECT NVL(a.CHILD_CARE_NAME, '0'), NVL(a.child_care_no, '0'), NVL(a.lpcg_paid_amount, '0'), NVL(a.max_lpcg_paid, 'N')
      INTO  l_childcare_name, l_childcare_num, l_lpcg_req, l_max_lpcg
      FROM stud_session a, stud_crse_year b 
      WHERE a.stud_session_id = B.STUD_SESSION_ID
      AND B.STUD_CRSE_YEAR_ID = p_stud_crse_year_id;
      
      CASE
      WHEN (l_max_lpcg = 'N' AND l_lpcg_req = '0')
      THEN l_result := 'N';
      WHEN ((l_max_lpcg <> 'N' OR l_lpcg_req <> '0') AND (l_childcare_name = '0' AND l_childcare_num = '0'))
      THEN l_result := 'N';
      WHEN ((l_max_lpcg <> 'N' OR l_lpcg_req <> '0') AND (l_childcare_name <> '0' AND l_childcare_num = '0'))
      THEN l_result := 'N';
      WHEN ((l_max_lpcg <> 'N' OR l_lpcg_req <> '0') AND (l_childcare_name = '0' AND l_childcare_num <> '0'))
      THEN l_result := 'N';
      WHEN ((l_max_lpcg <> 'N' OR l_lpcg_req <> '0') AND (l_childcare_name <> '0' AND l_childcare_num <> '0'))
      THEN l_result := 'Y';  
      END CASE;
      
     
      RETURN l_result;
   END lpcg_mandatory_fields;
      
    FUNCTION NMT_only (p_stud_crse_year_id IN NUMBER)
        RETURN CHAR
    IS
        l_result            CHAR;
        l_ben1_id           NUMBER;
        l_ben2_id           NUMBER;
        l_stud_session_id   NUMBER;
        l_award             CHAR;
        l_exempt            CHAR;
        
    BEGIN
    
        SELECT stud_session_id, parent_contrib_exempt, award
        INTO l_stud_session_id, l_exempt, l_award
        FROM stud_crse_year
       WHERE stud_crse_year_id = p_stud_crse_year_id;

      SELECT ben1_id, ben2_id
        INTO l_ben1_id, l_ben2_id
        FROM stud_session
       WHERE stud_session_id = l_stud_session_id;
       
       IF ((l_ben1_id IS NULL and l_ben2_id IS NULL and l_exempt = 'N') or (l_award = 'C' or l_award = 'D'))
       THEN
            l_result := 'Y';
       ELSE
            l_result := 'N';
       END IF;
       
       RETURN l_result;
       
   END NMT_only;
   
   FUNCTION is_there_multiple_scy(p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
   
   IS
   
   l_session_code   NUMBER;
   l_number_of_scy  NUMBER := 0;
   l_stud_ref_no    NUMBER;
   
   BEGIN
   
        SELECT  scy.session_code, SCY.STUD_REF_NO
        INTO l_session_code, l_stud_ref_no
        FROM stud_crse_year scy
        WHERE stud_crse_year_id = p_stud_crse_year_id;
        
        SELECT COUNT (SCY.STUD_CRSE_YEAR_ID)
        INTO l_number_of_scy
        FROM stud_crse_year scy
        WHERE session_code = l_session_code
        AND SCY.STUD_REF_NO = l_stud_ref_no
        AND SCY.STUD_CRSE_YEAR_ID < p_stud_crse_year_id;
        
        RETURN l_number_of_scy;
   
   END is_there_multiple_scy;
   
  FUNCTION sag_award_on_earlier_scy(p_stud_crse_year_id IN NUMBER)
   RETURN VARCHAR2
        IS
           l_session_code   NUMBER;
           l_stud_ref_no    NUMBER;
           l_stud_crse_year_id NUMBER;
           l_sag_awarded    VARCHAR2(1);
        BEGIN
           SELECT scy.session_code, SCY.STUD_REF_NO
           INTO l_session_code, l_stud_ref_no
           FROM stud_crse_year scy
           WHERE stud_crse_year_id = p_stud_crse_year_id;

           BEGIN
              SELECT a.stud_crse_year_id
              INTO l_stud_crse_year_id
              FROM AWARD a
              WHERE A.STUD_AWARD_TYPE = 'SAG'
                    AND a.stud_crse_year_id < p_stud_crse_year_id
                    AND session_code = l_session_code
                    AND A.STUD_REF_NO = l_stud_ref_no;

              l_sag_awarded := 'Y';  -- If the record is found, mark as 'Y'
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 l_sag_awarded := 'N';  -- If no record is found, mark as 'N'
           END;

           RETURN l_sag_awarded;
END sag_award_on_earlier_scy;
   
   
    
    
PROCEDURE stud_type_doc (
   p_stud_crse_year_id      IN       NUMBER,
   p_stud_type              IN OUT   stud_type_cursor)
IS
BEGIN
   OPEN p_stud_type FOR
      SELECT a.location_ind, c.commence_session,
             DECODE(b.pgce, NULL, 'N', B.PGCE) AS pgce,
             d.scheme_type
        FROM inst a, sgas.stud_crse_year b, sgas.stud c, crse d, crse_year e, crse_session f
         WHERE c.stud_ref_no = b.stud_ref_no
         AND b.crse_year_id = e.crse_year_id
         AND e.crse_session_id = f.crse_session_id
         AND f.crse_id = d.crse_id
         AND d.inst_code = a.inst_code
         AND b.stud_crse_year_id = p_stud_crse_year_id;
END stud_type_doc;
PROCEDURE bursary_doc (
   p_stud_crse_year_id   IN       NUMBER,
   p_bursary_type   IN OUT   bursary_type_cursor
)
IS

BEGIN

   OPEN p_bursary_type FOR
      SELECT   
            CASE
                WHEN sgas.rules_proc_recalc.prev_session_bursary(p_stud_crse_year_id) = 'Y' AND sgas.rules_proc_recalc.get_stud_age(p_stud_crse_year_id) > 25
                THEN 'N'
                ELSE NVL (sgas.rules_proc_recalc.prev_session_bursary(p_stud_crse_year_id), 0)
            END prev_bursary,      
--      NVL (prev_session_bursary (p_stud_crse_year_id), 0) AS prev_bursary,
             DECODE (scy.pay_ysb, NULL, 'N', scy.pay_ysb) pay_ysb,
             CASE
                WHEN (scy.paid_sandwich = 'Y') OR (crs.pams_course = 'Y') OR (    scy.parent_contrib_exempt = 'N' AND scy.calc_bursary = 'Y' AND ss.ben1_rel_id IS NULL
                    )
                   THEN 'N'
                WHEN get_missingben1data (p_stud_crse_year_id) = 'Y' OR get_missingben2data (p_stud_crse_year_id) = 'Y'
                   THEN 'N'
                WHEN scy.award IN('C', 'D') 
                   THEN 'N'
                ELSE (scy.calc_bursary)
             END calculatebursary,
             getstudystartterm (p_stud_crse_year_id) AS studystartterm,
             scy.parent_contrib_exempt AS exemptfromcont, NVL(SS.BURSARY_DEDUCTION,0), 
            CASE
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_YSB,'N') = 'Y' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind = 1)
                THEN 'YSB'
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_YSB,'N') = 'N' AND NVL(SCY.PAY_ISB,'N') = 'N' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind = 1 AND S.COMMENCE_SESSION >= 2001 AND SS.BEN1_REL_ID = 28 AND get_prev_bursary(p_stud_crse_year_id) = 'Y')
                THEN 'YSB'
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_YSB,'N') = 'N' AND NVL(SCY.PAY_ISB,'N') = 'N' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind = 1 AND S.COMMENCE_SESSION >= 2001 AND SS.BEN1_REL_ID IS NULL AND get_prev_bursary(p_stud_crse_year_id) = 'Y')
                THEN 'YSB'
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_YSB,'N') = 'N' AND NVL(SCY.PAY_ISB,'N') = 'N' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind = 1 AND S.COMMENCE_SESSION >= 2001 AND SS.BEN1_REL_ID IN(30,31,32,99))
                THEN 'YSB'
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_YSB,'N') = 'N' AND NVL(SCY.PAY_ISB,'N') = 'Y' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind = 1)
                THEN 'ISB'  
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_YSB,'N') = 'N' AND NVL(SCY.PAY_ISB,'N') = 'N' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind = 1 AND S.COMMENCE_SESSION > 2001 AND SS.BEN1_REL_ID = 28 AND get_prev_bursary(p_stud_crse_year_id) = 'N')
                THEN 'ISB'  
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_YSB,'N') = 'N' AND NVL(SCY.PAY_ISB,'N') = 'N' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind = 1 AND S.COMMENCE_SESSION > 2001 AND SS.BEN1_REL_ID IS NULL AND get_prev_bursary(p_stud_crse_year_id) = 'N')
                THEN 'ISB'
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_ISB,'N') = 'Y' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind <> 1 AND S.COMMENCE_SESSION >= 2006)
                THEN 'SOSB'       
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_YSB,'N') = 'N' AND NVL(SCY.PAY_ISB,'N') = 'N' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind <> 1 AND S.COMMENCE_SESSION >= 2006 AND SS.BEN1_REL_ID = 28 AND get_prev_bursary(p_stud_crse_year_id) = 'Y')
                THEN 'SOSB'
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_YSB,'N') = 'N' AND NVL(SCY.PAY_ISB,'N') = 'N' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind <> 1 AND S.COMMENCE_SESSION >= 2006 AND SS.BEN1_REL_ID IS NULL AND get_prev_bursary(p_stud_crse_year_id) = 'Y')
                THEN 'SOSB'
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_YSB,'N') = 'N' AND NVL(SCY.PAY_ISB,'N') = 'N' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind <> 1 AND (S.COMMENCE_SESSION >= 2001 AND S.COMMENCE_SESSION < 2006) AND SS.BEN1_REL_ID = 28 AND get_prev_bursary(p_stud_crse_year_id) = 'Y')
                THEN 'SOSB'
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_YSB,'N') = 'N' AND NVL(SCY.PAY_ISB,'N') = 'N' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind <> 1 AND (S.COMMENCE_SESSION >= 2001 AND S.COMMENCE_SESSION < 2006) AND SS.BEN1_REL_ID IS NULL AND get_prev_bursary(p_stud_crse_year_id) = 'Y')
                THEN 'SOSB'
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_YSB,'N') = 'N' AND NVL(SCY.PAY_ISB,'N') = 'N' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind <> 1 AND S.COMMENCE_SESSION >= 2006 AND SS.BEN1_REL_ID = 28 AND get_prev_bursary(p_stud_crse_year_id) = 'N')
                THEN 'SOSB'
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_YSB,'N') = 'N' AND NVL(SCY.PAY_ISB,'N') = 'N' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind <> 1 AND S.COMMENCE_SESSION >= 2006 AND SS.BEN1_REL_ID IS NULL AND get_prev_bursary(p_stud_crse_year_id) = 'N')
                THEN 'SOSB'
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_YSB,'N') = 'N' AND NVL(SCY.PAY_ISB,'N') = 'N' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind <> 1 AND S.COMMENCE_SESSION >= 2006 AND SS.BEN1_REL_ID IN(30,31,32,99))
                THEN 'SOSB'
                WHEN (SCY.SCHEME_TYPE = 'U' AND 
                     NVL(SCY.PAY_YSB,'N') = 'N' AND 
                     sgas.rules_proc_recalc.get_calc_bursary (p_stud_crse_year_id) = 'Y' AND 
                     i.location_ind <> 1 AND
                    (S.COMMENCE_SESSION > 2001 AND S.COMMENCE_SESSION < 2006) AND 
                    SS.BEN1_REL_ID IN(30,31,32,99))
                THEN 'YSO'
                WHEN (SCY.SCHEME_TYPE = 'U' AND NVL(SCY.PAY_YSB,'N') = 'N' AND NVL(SCY.PAY_ISB,'N') = 'N' AND get_calc_bursary (p_stud_crse_year_id) = 'Y' AND i.location_ind = 1 AND (S.COMMENCE_SESSION > 2001 AND S.COMMENCE_SESSION < 2006) AND SS.BEN1_REL_ID IN(30,31,32,99))
                THEN 'YSO'
                ELSE 'ZERO'                
                END bursary_type
        FROM stud_crse_year scy,
             stud_session ss,
             crse crs,
             crse_session crss,
             crse_year cy,
             stud s,
             inst i
       WHERE scy.stud_crse_year_id = p_stud_crse_year_id
         AND ss.stud_session_id = scy.stud_session_id
         AND scy.stud_ref_no = s.stud_ref_no
         AND crs.inst_code = i.inst_code
         AND crss.crse_id = crs.crse_id
         AND cy.crse_session_id = crss.crse_session_id
         AND scy.crse_year_id = cy.crse_year_id;
END bursary_doc;
PROCEDURE income_assessment_doc (
   p_stud_crse_year_id              IN       NUMBER,
   p_income_assessment_type         IN OUT   income_assessment_cursor
)
IS

BEGIN

   OPEN p_income_assessment_type FOR
      SELECT NVL(ss.net_income,0), NVL(ss.trust_income,0), NVL(ss.pension_income,0),
             NVL (ss.ja_stud_type, '') AS ja_stud_type,
            scy.parent_contrib_exempt,
             CASE
                WHEN ss.ja_case = 'Y' AND sgas.rules_proc_recalc.getNumberOfJACaseStudents(p_stud_crse_year_id) > 1   ----GREATER THAN 1 to IGNORE THE STUDENT HIMSELF.
                    THEN 'Y'
                ELSE 'N'
                END ja_case,
             no_of_dependant_children (p_stud_crse_year_id) AS nodependantchildren, ss.ben1_rel_id,
             NVL (get_ben_income (p_stud_crse_year_id), 0) AS netbenefactorincome,
             DECODE (no_of_dependant_children (p_stud_crse_year_id), 0, 'N', 'Y') AS anydependantchildren,
               NVL (ja.no_non_saas_children, 0)
             + NVL (ja.no_non_saas_parents, 0)
             + NVL (ja.no_saas_students, 0) noofsharingstudents,
             scy.loan_given,
             CASE
                WHEN scy.withdraw_date IS NULL AND scy.crse_chg IS NULL
                THEN 'N'
                ELSE 'Y'
                END withdrawalyn,
             --DECODE (MIN(scy.withdraw_date,scy.crse_chg), NULL, 'N', 'Y') AS withdrawalyn, 
             get_courselength (p_stud_crse_year_id) AS daysincourse,
             DECODE (scy.start_date, NULL, 'N', 'Y') AS studystartyn,
             daysinattendance (p_stud_crse_year_id) AS daysinattendance, NVL(SS.WORKING_TAX_CREDIT,0),
             CASE
                WHEN ja.ja_case_id IS NOT NULL AND ss.ja_stud_type = 'P'
                    THEN NVL(sgas.rules_proc_recalc.getJACASEParentIncomeBen1(ja.ja_case_id, ss.session_code),0)
                    ELSE 0
                END ja_ben1_income,
             CASE
                WHEN ja.ja_case_id IS NOT NULL AND ss.ja_stud_type = 'P'
                    THEN NVL(sgas.rules_proc_recalc.getJACASEParentIncomeBen2(ja.ja_case_id, ss.session_code),0)
                    ELSE 0
                END ja_ben2_income,
                CASE
                WHEN ss.ben1_id IS NOT NULL AND sgas.rules_proc_recalc.getCorrectBenIncome(ja.ja_case_id) = 'Y'
                    THEN NVL(sgas.rules_proc_recalc.getbenincome(ss.ben2_id, ss.session_code),0)
                    WHEN ss.ben1_id IS NOT NULL AND sgas.rules_proc_recalc.getCorrectBenIncome(ja.ja_case_id) = 'N'
                    THEN NVL(sgas.rules_proc_recalc.getbenincome(ss.ben1_id, ss.session_code),0)
                    ELSE 0
                END childben1income,
             CASE
                WHEN ss.ben2_id IS NOT NULL AND sgas.rules_proc_recalc.getCorrectBenIncome(ja.ja_case_id) = 'Y'
                    THEN sgas.rules_proc_recalc.getbenincome(ss.ben1_id, ss.session_code)
                    WHEN ss.ben2_id IS NOT NULL AND sgas.rules_proc_recalc.getCorrectBenIncome(ja.ja_case_id) = 'N'
                    THEN NVL(sgas.rules_proc_recalc.getbenincome(ss.ben2_id, ss.session_code),0)
                    ELSE 0
                END childben2income,
             CASE
                WHEN ja.ja_case_id IS NOT NULL
                    THEN sgas.rules_proc_recalc.getNoSharingChildren(ja.ja_case_id)
                ELSE 0
                END numSharingChildren
        FROM stud_session ss, stud st, ja_case ja, stud_crse_year scy
       WHERE scy.stud_crse_year_id = p_stud_crse_year_id
         AND ss.stud_ref_no = st.stud_ref_no
         AND scy.stud_session_id = ss.stud_session_id
         AND st.stud_ref_no = ss.stud_ref_no
         AND ja.ja_case_id(+) = ss.ja_case_id;
END income_assessment_doc;  
PROCEDURE loans_doc (
   p_stud_crse_year_id   IN       NUMBER,
   p_loans_type          IN OUT   loans_cursor
)
IS
BEGIN
   OPEN p_loans_type FOR
      SELECT CASE
                WHEN scy.award IN ('A', 'C', 'D')
                   THEN 'Y'
                WHEN get_missingben1data (p_stud_crse_year_id) = 'Y'
                 OR get_missingben2data (p_stud_crse_year_id) = 'Y'
                   THEN 'Y'
                ELSE 'N'
             END nmtonly,
             ss.loan_request, ss.max_loan_requested,
             CASE
                WHEN scy.study_abroad = 'Y'
                THEN c.new_category
                ELSE NVL(rules_proc_recalc.getLocationIndicator(scy.stud_crse_year_id),'H')  --decode(sta.location_ind,'W','E','O','H',sta.location_ind)
              END locationtype,             
             DECODE (scy.paid_sandwich,
                     NULL, 'N',
                     scy.paid_sandwich
                    ) paidplacement,
             crs.pams_course AS ahpstud,
             final_year_check (p_stud_crse_year_id) AS finalyear,
             CASE
                WHEN DECODE (scy.study_abroad,
                             'Y', c.new_category,
                             sta.location_ind
                            ) IN ('1', '2', '3')
                   THEN 
                   decode(sta.location_ind,'W','E','O','H',sta.location_ind)
                ELSE 
                        CASE
                        WHEN scy.study_abroad = 'Y'
                        THEN c.new_category
                        ELSE 
                        decode(sta.location_ind,'W','E','O','H',sta.location_ind)
                        END
             END home_location_type,
             get_abroad_days_in_term (p_stud_crse_year_id)
                                                         AS term_days_abroad,
             abroad_days_in_term_overlaps (p_stud_crse_year_id),
             days_of_study (p_stud_crse_year_id)
        FROM stud_crse_year scy,
             stud_session ss,
             country@grass c,
             stud_term_addr sta,
             crse crs,
             crse_session cs,
             crse_year cy
       WHERE ss.stud_session_id = scy.stud_session_id
         AND scy.stud_crse_year_id = p_stud_crse_year_id
         AND c.country_code(+) = scy.study_country
         AND crs.crse_id = cs.crse_id
         AND sta.end_date IS NULL
         AND cy.crse_session_id = cs.crse_session_id
         AND scy.crse_year_id = cy.crse_year_id
         AND sta.stud_ref_no = ss.stud_ref_no;
END loans_doc;
PROCEDURE fees_doc (
   p_stud_crse_year_id   IN       NUMBER,
   p_fees_type      IN OUT   fees_cursor
)
IS

BEGIN

   OPEN p_fees_type FOR
      SELECT scy.study_abroad,
             DECODE (scy.paid_sandwich,
                     'Y', 'Y',
                     DECODE (scy.unpaid_sandwich, 'Y', 'Y', 'N')
                    ) placementyear,
             scy.inst_code, ss.fee_loan_request_amount,
             NVL (scy.self_funding, 'N') AS self_funding, scy.erasmus,
             scy.calc_fee, c.qual_type, cy.var_sandwich_tuition_fee_amnt,
             i.non_public_fund, cy.var_tuition_fee_amnt,
             ss.max_fee_loan_requested, getwithdrawelterm (p_stud_crse_year_id) AS withdrawelterm,
             getfeespaidamount (p_stud_crse_year_id) AS fees_paid_amount, SS.FEE_LOAN_CHARGED, SCY.PSAS_PT AS partTimePG,
             CASE
                WHEN scy.calc_fee = 'Y' AND sgas.RULES_PROC_RECALC.getattendfeecutoffdate(scy.stud_crse_year_id) = 'Y' AND sgas.RULES_PROC_RECALC.prevFees(scy.stud_crse_year_id) = 'N'
                    THEN 'Y'
                ELSE 'N' 
             END attendfeecutoff,
             CASE
                WHEN scy.study_abroad = 'Y' AND scy.non_erasmus_exchange = 'N' AND scy.erasmus = 'Y' and i.location_ind <> 1
                    THEN 0   --ZERO FEE
                WHEN scy.study_abroad = 'Y' AND scy.non_erasmus_exchange = 'N' AND scy.erasmus = 'N' AND sgas.rules_proc_recalc.getPartYearAbroad(p_stud_crse_year_id) = 'N'
                    THEN 0.5 --HALF FEES
                ELSE 1
             END Abroad_fee_factor  
        FROM stud_crse_year scy,
             stud_session ss,
             crse c,
             crse_session cs,
             crse_year cy,
             inst i
       WHERE scy.stud_crse_year_id = p_stud_crse_year_id
         AND c.crse_id = cs.crse_id
         AND cy.crse_session_id = cs.crse_session_id
         AND scy.crse_year_id = cy.crse_year_id
         AND scy.inst_code = i.inst_code
         AND ss.stud_session_id = scy.stud_session_id;
         
END fees_doc;
PROCEDURE fees_doc_2012 (
   p_stud_crse_year_id   IN       NUMBER,
   p_fees_type_2012      IN OUT   fees_cursor_2012
)
IS

BEGIN

   OPEN p_fees_type_2012 FOR
      SELECT 
             scy.study_abroad,
             DECODE (scy.paid_sandwich,
                     'Y', 'Y',
                     DECODE (scy.unpaid_sandwich, 'Y', 'Y', 'N')
                    ) placementyear,
             scy.inst_code, ss.fee_loan_request_amount,
             NVL (scy.self_funding, 'N') AS self_funding, scy.erasmus,
             scy.calc_fee, c.qual_type,
             i.non_public_fund,
             ss.max_fee_loan_requested, getwithdrawelterm (p_stud_crse_year_id) AS withdrawelterm,
             getfeespaidamount (p_stud_crse_year_id) AS fees_paid_amount, SCY.PSAS_PT AS partTimePG,
             CASE
                WHEN scy.calc_fee = 'Y' AND sgas.RULES_PROC_RECALC.getattendfeecutoffdate(scy.stud_crse_year_id) = 'Y' AND sgas.RULES_PROC_RECALC.prevFees(scy.stud_crse_year_id) = 'N'
                    THEN 'Y'
                ELSE 'N' 
             END attendfeecutoff,
             CASE
                WHEN scy.study_abroad = 'Y' AND scy.non_erasmus_exchange = 'N' AND scy.erasmus = 'Y' and i.location_ind <> 1
                    THEN 0   --ZERO FEE
                WHEN scy.study_abroad = 'Y' AND scy.non_erasmus_exchange = 'N' AND scy.erasmus = 'N' AND sgas.rules_proc_recalc.getPartYearAbroad(p_stud_crse_year_id) = 'N'
                    THEN 0.5 --HALF FEES
                ELSE 1
             END Abroad_fee_factor,
             sgas.RULES_PROC_RECALC.set_ruk_fee_cap(p_stud_crse_year_id ) AS ruk_fee_cap,
             nvl(SCY.VARIABLE_FEE_OVERRIDE_AMOUNT,0),
             SCY.PSAS_NON_FEE_LOAN, cy.var_tuition_fee_amnt as courseFeeCap
        FROM stud_crse_year scy,
             stud_session ss,
             crse c,
             crse_session cs,
             crse_year cy,
             inst i
       WHERE scy.stud_crse_year_id = p_stud_crse_year_id
         AND c.crse_id = cs.crse_id
         AND cy.crse_session_id = cs.crse_session_id
         AND scy.crse_year_id = cy.crse_year_id
         AND scy.inst_code = i.inst_code
         AND ss.stud_session_id = scy.stud_session_id;
         
END fees_doc_2012;
PROCEDURE supps_doc (
   p_stud_crse_year_id      IN       NUMBER,
   p_supps_type             IN OUT   supps_cursor
)
IS
BEGIN

   OPEN p_supps_type FOR
      SELECT NVL (sd.income, 0) AS dependantincome,
             sd.relation_id,
             sd.start_date AS studdependantstartdate,
             sd.end_date AS studdependantenddate
        FROM stud_crse_year scy, stud_dependant sd
       WHERE scy.stud_crse_year_id = p_stud_crse_year_id
         AND sd.stud_session_id = scy.stud_session_id
         AND sd.relation_id IN(34,35,36,37,38,39,40,41,42,43,48,49,508,509,650);
END supps_doc;

PROCEDURE calculateawarddoc (
        p_stud_crse_year_id           IN       NUMBER,
        p_calculateaward_type   IN OUT   calculateaward_cursor,
        p_term_days             IN OUT   termdays_cursor_type,
        p_awards_cursor         IN OUT   all_award_cursor_type
)
IS

BEGIN
   OPEN p_awards_cursor FOR
      SELECT a.award_id, c.stud_award_type, 
      CASE
        WHEN C.LOAN_NON_LOAN_FEE = 'Loan'
            THEN 'Y'
        ELSE 'N'
        END isLoan,
        CASE WHEN upper(c.award_type_descript) LIKE '%NON%' AND c.loan_non_loan_fee = 'Loan'
            THEN 'N'
            WHEN  c.loan_non_loan_fee = 'Loan'and upper(c.award_type_descript) NOT LIKE '%NON%' AND c.loan_non_loan_fee = 'Loan'and c.stud_award_type NOT LIKE '%X%'
            THEN 'M'
            WHEN c.stud_award_type LIKE '%X%'
            THEN 'X'
            ELSE null
            END loan_type
  FROM award a, stud_crse_year cy, stud_award_type c
 WHERE cy.stud_crse_year_id = p_stud_crse_year_id
   AND a.stud_crse_year_id = cy.stud_crse_year_id
   AND c.stud_award_type = a.stud_award_type;


   OPEN p_calculateaward_type FOR
      SELECT scy.stud_crse_year_id, scy.session_code, scy.stud_ref_no,
             scy.crse_id, scy.crse_year_no,
             number_of_terms (p_stud_crse_year_id) AS numberofterms, 
             sgas.rules_proc_recalc.award_status(p_stud_crse_year_id) AS award, 
             CASE
                WHEN SCY.FIRST_CALC_DATE IS NOT NULL AND SCY.WITHDRAW_DATE IS NULL AND SCY.CRSE_CHG IS NULL
                   THEN 'D'    
                WHEN SCY.FIRST_CALC_DATE IS NOT NULL AND SCY.WITHDRAW_DATE IS NOT NULL AND SCY.CRSE_CHG IS NULL
                   THEN 'W'
                WHEN SCY.FIRST_CALC_DATE IS NOT NULL AND SCY.WITHDRAW_DATE IS NULL AND SCY.CRSE_CHG IS NOT NULL
                   THEN 'C'
                ELSE 'I'
             END assess_reason_code,       
             SCY.START_DATE, 
             CASE
                WHEN SCY.WITHDRAW_DATE IS NULL AND CRSE_CHG IS NULL
                    THEN SCY.WITHDRAW_DATE
                WHEN SCY.WITHDRAW_DATE IS NULL AND CRSE_CHG IS NOT NULL
                    THEN SCY.CRSE_CHG
                WHEN SCY.WITHDRAW_DATE IS NOT NULL AND CRSE_CHG IS NULL
                    THEN SCY.WITHDRAW_DATE
                WHEN SCY.WITHDRAW_DATE <= SCY.CRSE_CHG
                    THEN SCY.WITHDRAW_DATE
                ELSE SCY.CRSE_CHG
             END WITHDRAW_DATE,
             ST.OVERPAYMENT, 
             NVL(sgas.rules_proc_recalc.getPrevSessionProvisionalFlag(scy.stud_ref_no, scy.session_code),'N') AS prevProv,
             SCY.parent_contrib_exempt, ss.ben1_id, ss.ben2_id,
             sgas.rules_proc_recalc.getStartDateTerm(scy.stud_crse_year_id,1) AS courseStartDate,
             sgas.rules_proc_recalc.get_ja_studs_reg(p_stud_crse_year_id) AS ja_studs_reg,
             sgas.rules_proc_recalc.get_calc_bursary(p_stud_crse_year_id) AS calc_bursary,
            SCY.CALC_FEE, SCY.CALC_LOAN, SCY.ASSESS_LOAN, SCY.CALC_DEP_GRANT,       
             SCY.CALC_LPCG, SCY.CALC_LPG, SCY.CALC_SMA, SCY.CALC_SPA, SCY.LATEST_CRSE_IND, tft.tuition_fee_type_code, 
             ss.lpcg_paid_amount AS LPCGRequested,
             ss.max_lpcg_paid AS LPCGMax, SCY.NON_ATT_ACTIONED, SCY.NON_ATT_ACTIONED_DATE, SD.START_DATE, SD.END_DATE,
              CASE
                    WHEN scy.withdraw_date IS NOT NULL
                        THEN 'W'
                    WHEN scy.non_att_actioned = 'Y' AND scy.non_att_actioned_date IS NOT NULL
                    THEN 'A'
                    ELSE 'C'
                END app_status
        FROM stud_crse_year scy,
             stud_session ss,
             crse_session cs,
             crse_year cy,
             tuition_fee_type@grass tft,
             crse crs,
             stud st,
             inst inst,
             campus cam,
             stud_dependant sd
       WHERE scy.stud_crse_year_id = p_stud_crse_year_id
         AND cs.crse_session_id = cy.crse_session_id
         AND scy.stud_session_id = ss.stud_session_id
         AND crs.crse_id = cs.crse_id
         AND inst.inst_code = crs.inst_code
         AND cy.crse_year_id = scy.crse_year_id
         AND st.stud_ref_no = scy.stud_ref_no
         AND inst.inst_code = SCY.INST_CODE
         AND crs.fees_campus = cam.campus_id
         AND SD.STUD_SESSION_ID(+) = SCY.STUD_SESSION_ID
         AND tft.tuition_fee_type_code(+) = cs.tuition_fee_type_code;

   p_term_days := get_termdays (p_stud_crse_year_id);
 
END calculateawarddoc;

/* Formatted on 2012/06/15 13:07 (Formatter Plus v4.8.8) */
PROCEDURE awardinstalments (
   p_stud_crse_year_id      IN       NUMBER,
   p_awardinstalment_type   IN OUT   awardinstalments_cursor,
   p_start_dates            IN OUT   startdates_cursor_type,
   p_payment_dates          IN OUT   all_payment_cursor_type,
   p_top_payment_dates      IN OUT   all_top_payment_cursor_type
)
IS
   l_default_term               CHAR (1);
   e_exceeded_award             EXCEPTION;
   
   
BEGIN
   IF sgas.rules_proc_recalc.maxawardexceeded (p_stud_crse_year_id) = 'Y'
   THEN
      RAISE e_exceeded_award;
   ELSE
   


   
   
      OPEN p_awardinstalment_type FOR
         SELECT a.award_id, a.stud_crse_year_id, a.stud_award_type,
                (a.amount + a.overpaid_contrib) AS amount_contrib,
                a.amount AS amount, a.recovered_amount, a.contrib_amount,
                a.net_amount, a.unclaimed_fee_loan, s.payment_method,
                CASE
                   WHEN a.award_src = 'T'
                      THEN 'I'
                   ELSE 'S'
                END payee,
                CASE
                   WHEN sat.loan_non_loan_fee = 'fee'
                      THEN sgas.rules_proc_recalc.getcampusid
                                                        (c.crse_id,
                                                         'F'
                                                        )
                   ELSE sgas.rules_proc_recalc.getcampusid (c.crse_id, 'A')
                END campus_id,
                    -- MAINTENANCE CAMPUS - RE-VISIT AFTER SPEAKING TO PAUL D
                scy.start_date,
                CASE
                   WHEN ss.top_option = 'Y' AND a.award_src = 'A' AND scy.scheme_type = 'U'
                      THEN 'TOP' --code for 12 monthly payments across the year
                   WHEN i.location_ind = 1 AND a.award_src = 'A'
                      THEN 'M' --code for standard monthly payments within term time
                   WHEN i.location_ind <> 1 AND a.award_src = 'A'
                      THEN 'T' --code for termly payments (usually RUK)
                   ELSE 'F' --code for fees
                END apportionment_method,
                sgas.rules_proc_recalc.getpaidfees
                                        (scy.stud_crse_year_id)
                                                              AS prepaidfees,
                sgas.rules_proc_recalc.count_payment_dates
                                   (scy.stud_crse_year_id)
                                                         AS numberofpayments,
                sgas.rules_proc_recalc.count_top_payment_dates
                                   (scy.stud_crse_year_id)
                                                         AS numberoftoppayments,                                                         
                a.assessment_date,
                CASE
                   WHEN sgas.rules_proc_recalc.triplepayment_flag
                                     (scy.stud_crse_year_id) =
                                                        'Y'
                   AND scy.start_date IS NULL
                      THEN 3
                   WHEN scy.start_date IS NOT NULL
                      THEN 1
                   ELSE 2
                END triplepaymentflag,
                sgas.rules_proc_recalc.daysinattendance
                                   (scy.stud_crse_year_id)
                                                         AS daysinattendance,
                ca.payment_method AS feespaymentmethod,
                
                --  ca.campus_id as feescampus, --- REVISIT AFTER SPEAKING WITH PAUL D
                cy.cutoff_date AS fee_payment_date,
                CASE
                   WHEN a.stud_award_type IN
                          ('UGOA', 'UGDA', 'LPCG', 'PSOA',
                           'PSDA')
                      THEN 'Y'
                          --IF AWARD TYPE IS DG, LPG OR LPCG TYPE
                   ELSE 'N'
                END termlygrant,
                CASE
                   WHEN scy.start_date IS NULL
                   AND scy.withdraw_date IS NULL
                   AND scy.crse_chg IS NULL
                      THEN 'Y'
                   ELSE 'N'
                END termly365periodflag,
                scy.session_code,
                sgas.rules_proc_recalc.getdaysinattendanceinterm
                                       (scy.stud_crse_year_id,
                                        1
                                       ) AS daysinterm1,
                sgas.rules_proc_recalc.getdaysinattendanceinterm
                                       (scy.stud_crse_year_id,
                                        2
                                       ) AS daysinterm2,
                sgas.rules_proc_recalc.getdaysinattendanceinterm
                                       (scy.stud_crse_year_id,
                                        3
                                       ) AS daysinterm3,
                sgas.rules_proc_recalc.getdaysinattendanceinterm
                                       (scy.stud_crse_year_id,
                                        4
                                       ) AS daysinterm4,
                sgas.rules_proc_recalc.getstartdateterm
                                    (scy.stud_crse_year_id,
                                     1
                                    ) AS term1startdate,
                sgas.rules_proc_recalc.getstartdateterm
                                    (scy.stud_crse_year_id,
                                     2
                                    ) AS term2startdate,
                sgas.rules_proc_recalc.getstartdateterm
                                    (scy.stud_crse_year_id,
                                     3
                                    ) AS term3startdate,
                sgas.rules_proc_recalc.getstartdateterm
                                    (scy.stud_crse_year_id,
                                     4
                                    ) AS term4startdate,
                sgas.rules_proc_recalc.number_of_terms
                                           (scy.stud_crse_year_id)
                                                                 AS maxterms,
                scy.withdraw_date, scy.crse_chg,
                scy.scheme_type AS schemetype,
                CASE
                   WHEN (s.payment_method = 'C')
                      THEN 'H'
                   WHEN (s.payment_method = 'B' AND s.nominee = 'N'
                        )
                      THEN 'B'
                   ELSE 'N'
                END payment_addr,
                CASE
                   WHEN sat.stud_award_type = 'TFEL'
                      THEN 'Y'
                   ELSE 'N'
                END feeloaninstalment,
                CASE
                   WHEN scy.scheme_type = 'P'
                      THEN sgas.rules_proc_recalc.fee_cut_off_date
                                         (scy.stud_crse_year_id)
                   ELSE NULL
                END feecutoffdate,
                s.stud_ref_no AS studrefno,
                sgas.rules_proc_recalc.getstudystartterm
                                        (scy.stud_crse_year_id)
                                                              studystartterm,
                sgas.rules_proc_recalc.getstudyendterm (scy.stud_crse_year_id),
                NVL (a.overpaid_contrib, 0) AS overpaid_contrib
           FROM award a,
                stud s,
                stud_crse_year scy,
                stud_session ss,
                crse_year cy,
                crse_session cs,
                crse c,
                inst i,
                campus ca,
                stud_award_type sat
          WHERE a.stud_crse_year_id = scy.stud_crse_year_id
            AND scy.stud_ref_no = s.stud_ref_no
            AND scy.crse_year_id = cy.crse_year_id
            AND ss.stud_session_id = scy.stud_session_id
            AND cy.crse_session_id = cs.crse_session_id
            AND sat.stud_award_type = a.stud_award_type
            AND sat.loan_non_loan_fee <> 'Loan'       
            AND sat.TYPE NOT IN ('DSA', 'TRAV', 'MAN')
            AND sat.TYPE <> 'NMSB'
            AND cs.crse_id = c.crse_id
            AND scy.scheme_type <> 'B'
            AND c.inst_code = i.inst_code
            AND c.fees_campus = ca.campus_id
            AND scy.stud_crse_year_id = p_stud_crse_year_id;


      p_payment_dates := get_payment_dates (p_stud_crse_year_id);
      p_top_payment_dates := get_top_payment_dates(p_stud_crse_year_id);      
      p_start_dates := get_startdates (p_stud_crse_year_id);
      
      END IF;
      

  
EXCEPTION
   WHEN e_exceeded_award
   THEN
      raise_application_error
         (-20001,
          'Award amount has exceeded the maximum allowed - please contact BSU '
         );
END awardinstalments;

PROCEDURE awardinstalments2022 (
   p_stud_crse_year_id      IN       NUMBER,
   p_awardinstalment_type   IN OUT   awardinstalments_cursor,
   p_start_dates            IN OUT   startdates_cursor_type2022,
   p_payment_dates          IN OUT   all_payment_cursor_type,
   p_top_payment_dates      IN OUT   all_top_payment_cursor_type
)
IS
   l_default_term               CHAR (1);
   e_exceeded_award             EXCEPTION;
   
   
BEGIN
   IF sgas.rules_proc_recalc.maxawardexceeded (p_stud_crse_year_id) = 'Y'
   THEN
      RAISE e_exceeded_award;
   ELSE
   
      OPEN p_awardinstalment_type FOR
          SELECT 
                scy.start_date,
                sgas.rules_proc_recalc.get_startdates2022 (scy.stud_crse_year_id) AS start_date_of_term,
                sgas.rules_proc_recalc.count_payment_dates_2022
                                   (scy.stud_crse_year_id)
                                                         AS numberofpayments,
                sgas.rules_proc_recalc.count_top_payment_dates_2022
                                   (scy.stud_crse_year_id)
                                                         AS numberoftoppayments,
                CASE
                   WHEN sgas.rules_proc_recalc.triplepayment_flag_2022
                                     (scy.stud_crse_year_id) =
                                                        'Y'
                      THEN 3
                   ELSE 2
                END triplepaymentflag,
                sgas.rules_proc_recalc.number_of_terms
                                           (scy.stud_crse_year_id)
                                                                 AS maxterms,
                scy.withdraw_date, 
                scy.crse_chg,
                                sgas.rules_proc_recalc.getstudystartterm
                                        (scy.stud_crse_year_id)
                                                              studystartterm,
                sgas.rules_proc_recalc.getstudyendterm (scy.stud_crse_year_id),
                CASE
                   WHEN ss.top_option = 'Y' AND scy.scheme_type = 'U'
                      THEN 'TOP' --code for 12 monthly payments across the year
                   WHEN i.location_ind = 1 
                      THEN 'M' --code for standard monthly payments within term time
                   WHEN i.location_ind <> 1
                      THEN 'T' --code for termly payments (usually RUK)
                   ELSE 'F' --code for fees
                END apportionment_method,
                sgas.rules_proc_recalc.getDaysInAttendanceInTermWithoutWithdrawal
                                       (scy.stud_crse_year_id,
                                        1
                                       ) AS daysinterm1,
                sgas.rules_proc_recalc.getDaysInAttendanceInTermWithoutWithdrawal
                                       (scy.stud_crse_year_id,
                                        2
                                       ) AS daysinterm2,
                sgas.rules_proc_recalc.getDaysInAttendanceInTermWithoutWithdrawal
                                       (scy.stud_crse_year_id,
                                        3
                                       ) AS daysinterm3,
                sgas.rules_proc_recalc.getDaysInAttendanceInTermWithoutWithdrawal
                                       (scy.stud_crse_year_id,
                                        4
                                       ) AS daysinterm4,                                      
                scy.session_code,
                sgas.rules_proc_recalc.getenddateterm
                                    (scy.stud_crse_year_id,
                                     1
                                    ) AS term1enddate,
                sgas.rules_proc_recalc.getenddateterm
                                    (scy.stud_crse_year_id,
                                     2
                                    ) AS term2enddate,
                sgas.rules_proc_recalc.getenddateterm
                                    (scy.stud_crse_year_id,
                                     3
                                    ) AS term3enddate,
                sgas.rules_proc_recalc.getenddateterm
                                    (scy.stud_crse_year_id,
                                     4
                                    ) AS term4endate,
                sgas.rules_proc_recalc.is_there_multiple_scy
                                    (p_stud_crse_year_id),
                  sgas.rules_proc_recalc.getstartdateterm
                                    (scy.stud_crse_year_id,
                                     1
                                    ) AS term1startdate,
                sgas.rules_proc_recalc.getstartdateterm
                                    (scy.stud_crse_year_id,
                                     2
                                    ) AS term2startdate,
                sgas.rules_proc_recalc.getstartdateterm
                                    (scy.stud_crse_year_id,
                                     3
                                    ) AS term3startdate,
                sgas.rules_proc_recalc.getstartdateterm
                                    (scy.stud_crse_year_id,
                                     4
                                    ) AS term4startdate                                    
           FROM stud s,
                stud_crse_year scy,
                stud_session ss,
                crse_year cy,
                crse_session cs,
                crse c,
                inst i,
                campus ca
          WHERE scy.stud_ref_no = s.stud_ref_no
            AND scy.crse_year_id = cy.crse_year_id
            AND ss.stud_session_id = scy.stud_session_id
            AND cy.crse_session_id = cs.crse_session_id
            AND cs.crse_id = c.crse_id
            AND scy.scheme_type <> 'B'
            AND c.inst_code = i.inst_code
            AND c.fees_campus = ca.campus_id
            AND scy.stud_crse_year_id = p_stud_crse_year_id;


      p_payment_dates := get_payment_dates_2022 (p_stud_crse_year_id);
      p_top_payment_dates := get_top_payment_dates_2022(p_stud_crse_year_id);      
      p_start_dates := get_startdates2022 (p_stud_crse_year_id);
      
      END IF;
      

  
EXCEPTION
   WHEN e_exceeded_award
   THEN
      raise_application_error
         (-20001,
          'Award amount has exceeded the maximum allowed - please contact BSU '
         );
END awardinstalments2022;



PROCEDURE travelElement (
   p_stud_crse_year_id      IN       NUMBER,
   p_travel_type            IN OUT   travelElement_cursor
)
IS

BEGIN

   OPEN p_travel_type FOR
   
      SELECT    cy.eu_flag, 
                scy.DEARING, 
                c.PAMS_COURSE, 
                c.QUAL_TYPE, 
                get_courselength(p_stud_crse_year_id) AS crseLength, 
                get_stud_age(p_stud_crse_year_id) AS studAge,
                c.qual_type
        FROM stud_crse_year scy,
             crse_year cy,
             crse_session cs,
             crse c,
             inst i
       WHERE scy.crse_year_id = cy.crse_year_id
         AND cy.crse_session_id = cs.crse_session_id
         AND cy.crse_id = cs.crse_id
         AND cs.crse_id = c.crse_id
         AND c.inst_code = i.inst_code
         AND scy.stud_crse_year_id = p_stud_crse_year_id;

END travelElement;


PROCEDURE gettermdates (
   p_stud_crse_year_id      IN       NUMBER,
   p_terms_type            IN OUT   terms_cursor,
   p_term_dates            IN OUT   term_dates_cursor
)

IS

    l_default_term CHAR(1);
    

BEGIN

        l_default_term := check_default_terms (p_stud_crse_year_id);

        OPEN p_terms_type FOR
   
      SELECT    sgas.rules_proc_recalc.number_of_terms(p_stud_crse_year_id)
                FROM DUAL;
                
                
     IF l_default_term = 'Y'
            
            THEN   
            
     OPEN p_term_dates FOR
     
                SELECT it.term_no, it.start_date, it.end_date
                FROM inst_term it, stud_crse_year scy
                WHERE scy.inst_code = it.inst_code
                AND scy.session_code = it.session_code
                AND scy.stud_crse_year_id = p_stud_crse_year_id;     
                
      ELSE   
                
   OPEN p_term_dates FOR
   
      SELECT a.term_no, a.start_date, a.end_date 
      FROM CRSE_TERM a, STUD_CRSE_YEAR b
      WHERE a.CRSE_YEAR_ID = B.CRSE_YEAR_ID
      AND b.stud_crse_year_id = p_stud_crse_year_id;
      
      END IF;
      
END gettermdates;


PROCEDURE update_award_recovered_ug (p_stud_crse_year_id IN NUMBER)
   IS
   
   l_debt   NUMBER;
   
     CURSOR c_award_id
      IS

         SELECT stud_award_type, award_id, recovered_amount, net_amount, sgas.rules_proc_recalc.get_paid_SUM_net_Instalment(award_id) as netpaid FROM(
         select a.stud_award_type, a.award_id, a.recovered_amount as recovered_amount, SUM(b.net_amount) AS net_amount
         from award a, award_instalment b, stud_award_type c
         where a.award_id = b.award_id
         and c.stud_award_type = a.stud_award_type
         and c.type NOT IN('MAN','DSA','TRAV', 'LOAN')
         and a.stud_crse_year_id = p_stud_crse_year_id    
         and B.PAYMENT_STATUS = 'U'
         AND A.AWARD_SRC = 'A'
         group by a.stud_award_type, a.award_id, a.recovered_amount)
       order by (CASE WHEN stud_award_type = 'UGSMAH' THEN 0
                        WHEN stud_award_type = 'SOSB' THEN 1
                        WHEN stud_award_type = 'YSO'  THEN 2
                        WHEN stud_award_type = 'ISB'  THEN 3
                        WHEN stud_award_type = 'CESB' THEN 4
                        WHEN stud_award_type = 'YSB'  THEN 5
                        WHEN stud_award_type = 'UGDA' THEN 6
                        WHEN stud_award_type = 'UGOA' THEN 7 END);
                        
                        
                        

                        
         
        
      v_award_id        c_award_id%ROWTYPE;
      
BEGIN

    ----GET OVERPAYMENT AMOUNT
    
    l_debt := SGAS.NMSB_RULES_PROC_RECALC.get_debt_amount(p_stud_crse_year_id);
    
    IF l_debt > 0  
    
            THEN --------MAIN LOGIC HERE TO LOOP OVER AWARDS AND REMOVE SOME DEBT IF WE CAN
            
            OPEN c_award_id;

         LOOP
            FETCH c_award_id
             INTO v_award_id;

            EXIT WHEN c_award_id%NOTFOUND;
            
            IF l_debt > 0 AND v_award_id.net_amount > 0
            
                    THEN
                    
            
                            IF l_debt > (v_award_id.net_amount)
                            
                                THEN 
                                
                                        
                                /*
                                
                                        UPDATE AWARD a
                                            SET a.RECOVERED_AMOUNT = a.RECOVERED_AMOUNT + v_award_id.net_amount, 
                                            A.NET_AMOUNT = 0 +  v_award_id.netpaid
                                            WHERE a.award_id = v_award_id.award_id;
                                            
                                        l_debt := l_debt -  (v_award_id.net_amount - v_award_id.recovered_amount);
                                        
                                  */ 
                                
                                    
                                      
                                        UPDATE AWARD
                                            SET recovered_amount = (recovered_amount + v_award_id.net_amount), 
                                                net_amount = v_award_id.netpaid
                                                WHERE award_id = v_award_id.award_id;
                                                
                                        l_debt := l_debt - v_award_id.net_amount;
                                                
                                      
                                        
                                        
                                        
                                        
                            ELSE 
                            
                                UPDATE AWARD a
                                            SET a.RECOVERED_AMOUNT = a.RECOVERED_AMOUNT + l_debt,
                                            A.NET_AMOUNT = A.NET_AMOUNT - l_debt                                       
                                            WHERE a.award_id = v_award_id.award_id;
                                            
                                            l_debt := 0;
                                            
                            END IF;
            
            ELSE l_debt := l_debt;
            
            END IF;
            


         END LOOP;

         CLOSE c_award_id;
         

         
         UPDATE stud
         SET overpayment = l_debt
         WHERE stud_ref_no IN(select stud_ref_no from stud_crse_year
                                where stud_crse_year_id = p_stud_crse_year_id);         
            
            
    ELSE l_debt := l_debt;
    
    END IF;     
      
      
      
      ----CALL EXISTING PROCEDURE TO DISH OUT REMAINING FUNDS

      
      
   END update_award_recovered_ug;
   
   
   ------------------CLARK CAN YOU WORK OUT WHY THIS CURSOR IS INVALID - PROBABLY SOMETHING OBVIOUS BUT CAN'T SPOT IT TODAY
   
   PROCEDURE updateawardinstalments (p_stud_crse_year_id IN NUMBER)
   IS
   
    l_newRecovered  NUMBER;   ----THIS HODLS THE VALUE BETWEEN DIFFERENCE BETWEEN AWARD.RECOVERED - SUM(
    l_unpaidAmount  NUMBER;
   
   ---FIRST WE CHECK IF THE AWARD.RECOVERD_AMOUNT = SUM(RECOVERED_AMOUNT)
   ---IF THIS IS THE SAME THIS SERVICE DOES NOT NEED TO DO ANYTHING
   
   
   --THE FOLLOWING SQL WILL RETURN THE AWARD_RECOVERED AND SUM(AWARD_INSTALMENT_RECOVERED) FOR EACH AWARD_ID
   

   CURSOR c_awards
      IS
     
   SELECT a.AWARD_RECOVERED, a.AWARD_ID, b.AI_RECOVERED 
   FROM(
   SELECT RECOVERED_AMOUNT AS AWARD_RECOVERED, award_id
   FROM AWARD
   WHERE STUD_CRSE_YEAR_ID  = p_stud_crse_year_id) a ,    (SELECT SUM(a.RECOVERED_AMOUNT) AS AI_RECOVERED, b.award_id
                                                       FROM AWARD_INSTALMENT a, AWARD b
                                                       WHERE a.award_id = b.award_id
                                                       AND b.STUD_CRSE_YEAR_ID  = p_stud_crse_year_id
                                                       AND a.payment_status IN('S','U')
                                                       AND a.returned IN('N','A','T')
                                                       GROUP by b.award_id) b
   WHERE a.AWARD_ID = B.AWARD_ID;
   
   v_awards        c_awards%ROWTYPE;

   
   

   
BEGIN

    OPEN c_awards;


          LOOP
          
         FETCH c_awards
          INTO v_awards;

         EXIT WHEN c_awards%NOTFOUND;
         
                                
                        IF v_awards.AWARD_RECOVERED <> v_awards.AI_RECOVERED  ---THIS MEANS WE NEED TO UPDATE AWARD INSTALMENTS.
                        
                        THEN
                        
                                l_newRecovered := v_awards.AWARD_RECOVERED - v_awards.AI_RECOVERED;
 


                        /*
                       
                            ---THIS SQL WILL GIVE THE AMOUNT EXTRA TO BE RECOVERED FROM THE REMAINING UNPAID AWARD INSTALMENTS
                            SELECT a.RECOVERED_AMOUNT - NVL(b.RECOVERED_AMOUNT,0)
                            INTO l_newRecovered
                            FROM(SELECT RECOVERED_AMOUNT
                            FROM AWARD
                            WHERE AWARD_ID = v_awards.award_id) a, (SELECT SUM(RECOVERED_AMOUNT) AS RECOVERED_AMOUNT           
                                                            FROM AWARD_INSTALMENT
                                                            WHERE AWARD_ID = v_awards.AWARD_ID
                                                            AND PAYMENT_STATUS = 'S'
                                                            AND RETURNED IN('N','T','A')) b;
                                                            
                        */
                        
                               
                            
                            ---THIS WILL GIVE US THE TOTAL AMOUNT OF UNPAID INSTALMENTS FOR THIS AWARD SO WE CAN DISTRIBUTE IT PROPORTIONALLY
                            SELECT SUM(amount)
                            INTO l_unpaidAmount
                            FROM AWARD_INSTALMENT
                            WHERE AWARD_ID = v_awards.AWARD_ID
                            AND PAYMENT_STATUS = 'U';

                            ----NOW WE HAVE WHAT WE NEED TO UPDATE THE AWARD INSTALMENT FIGURES
                            
                            
                           ---LETS FIRST UPDATE THE AWARD INSTALMENT RECOVERED_AMOUNTS SO THEY ARE CORRECT
                           
                           UPDATE AWARD_INSTALMENT ai
                           SET ai.RECOVERED_AMOUNT = RECOVERED_AMOUNT + FLOOR((ai.amount / l_unpaidAmount) * l_newRecovered)
                          -- SET ai.RECOVERED_AMOUNT = FLOOR((ai.amount / l_unpaidAmount) * l_newRecovered)
                           WHERE ai.award_id = v_awards.AWARD_ID
                           AND PAYMENT_STATUS = 'U';
                           
                           UPDATE AWARD_INSTALMENT ai
                           SET ai.NET_AMOUNT = ai.amount - ai.recovered_amount - ai.contrib_amount
                           WHERE ai.award_id = v_awards.AWARD_ID
                           AND PAYMENT_STATUS = 'U';
                           
                           sgas.nmsb_rules_proc_recalc.remainderinstalments(v_awards.award_id);

                            
                        END IF; 
                         
         
            END LOOP;
            
      CLOSE c_awards;
      
      
       
END updateawardinstalments;

PROCEDURE awardscreenvalues_doc (
      p_stud_crse_year_id   IN       NUMBER,
      p_awardscreen_type    IN OUT   awardscreen_type_cursor
   )
   IS
   BEGIN
      OPEN p_awardscreen_type FOR
         SELECT scy.inst_code, scy.inst_name, scy.crse_code, scy.crse_name,
                scy.crse_year_no, scy.crse_year_id, scy.crse_id,
                scy.scheme_type, scy.dearing, scy.fee_loan_given,
                scy.loan_given, crs.pams_course, cy.eu_flag,
                ss.lpcg_paid_amount, ss.max_lpcg_paid,
                SGAS.rules_proc_recalc.does_stud_dep_exist
                                           (p_stud_crse_year_id)
                                                               AS dep_exists,
                SGAS.rules_proc_recalc.is_there_a_spouse
                                      (p_stud_crse_year_id)
                                                          AS is_dep_a_spouse,
                scy.paid_sandwich, scy.pay_ysb,
                SGAS.rules_proc_recalc.benefactor_with_income
                                (p_stud_crse_year_id)
                                                    AS is_there_a_benefactor,
                scy.parent_contrib_exempt, scy.award, inst.location_ind,
                SGAS.rules_proc_recalc.lpcg_mandatory_fields (p_stud_crse_year_id)
                                                    AS lpcg_mandatory_fields,
                SGAS.rules_proc_recalc.does_spouse_have_child (p_stud_crse_year_id)
                                                    AS spouse_with_child,
                SGAS.rules_proc_recalc.NMT_only(p_stud_crse_year_id) AS NMT_only,
                scy.session_code,
                scy.psas_non_fee_loan,
                st.district_birth_cert_issued,
                SGAS.rules_proc_recalc.adult_i_act_as_carer_for(p_stud_crse_year_id)
                                            AS adult_i_act_as_carer_for,
                SGAS.RULES_PROC_RECALC.has_child_and_adult_dep(p_stud_crse_year_id)
                                            AS has_child_and_adult_dep,
                SS.care_leaver,
                SGAS.PK_STEPS_PG_ED_PSYCH.checkIfPgEdPsychCourse(scy.inst_code, scy.crse_code) AS isPgEdPsychCourse,
                SCY.GA_STUDENT,
                SS.EU_RESIDENCE_TYPE,
                ST.CARE_EXP_EVIDENCE_RECVD,
                SS.ACCOMMODATION_FORMAL,
                SS.ACCOMMODATION_INFORMAL,
                SGAS.RULES_PROC_RECALC.sag_award_on_earlier_scy(p_stud_crse_year_id) as sag_award_on_earlier_scy
           FROM stud_crse_year scy,
                stud_session ss,
                stud st,
                crse crs,
                crse_session crss,
                crse_year cy,
                inst inst
          WHERE st.stud_ref_no = scy.stud_ref_no
            AND scy.crse_year_id = cy.crse_year_id
            AND cy.crse_session_id = crss.crse_session_id
            AND crss.crse_id = crs.crse_id
            AND crs.inst_code = inst.inst_code
            AND scy.stud_crse_year_id = p_stud_crse_year_id
            AND ss.stud_session_id = scy.stud_session_id
            AND crss.crse_id = crs.crse_id
            AND cy.crse_session_id = crss.crse_session_id
            AND scy.crse_year_id = cy.crse_year_id;
   END awardscreenvalues_doc;
   
   
   
   PROCEDURE update_attendance_ongoing(p_stud_crse_year_id IN NUMBER)
    IS
    
       l_valid_date               DATE;
       l_no_days_ongoing_attend   NUMBER;
       l_ongoing_required         CHAR;


BEGIN
        
        SELECT ONGOING_REQUIRED
        INTO l_ongoing_required
        FROM ATTENDANCE_DATA
        WHERE STUD_CRSE_YEAR_ID = p_stud_crse_year_id;
        
        IF l_ongoing_required = 'N'
            THEN
            
                            ---THIS SELECTS THE NUMBER OF DAYS
                  SELECT nval
                    INTO l_no_days_ongoing_attend
                    FROM config_data
                          WHERE item_name = 'NO_DAYS_ONGOING_ATTEND';
            
            
            
            
        END IF;

            ---FUNCTION CALLED TO GET THE START DATE OF THE COURSE.  THIS HAS TO BE NVLd as some courses maybe not be set up.  
          SELECT NVL(sgas.rules_proc_recalc.getstartdateterm(p_stud_crse_year_id,1),TO_DATE ('01/01/9999', 'DD/MM/YYYY'))
          INTO l_valid_date
          FROM DUAL;

                        ----FIRST CONDITION WE NEED TO SET ONGOING REQUIRED = 'Y'
                     IF l_valid_date <= (SYSDATE - l_no_days_ongoing_attend)
                     THEN
                     
                        UPDATE attendance_data
                            SET chngd_since_last_report = 'Y', ongoing_required = 'Y'
                            WHERE ongoing_required = 'N'
                            AND stud_crse_year_id = p_stud_crse_year_id;

                     END IF;

    END update_attendance_ongoing;
    
    PROCEDURE tidy_up_instalments(p_stud_crse_year_id IN NUMBER)
     IS
     
     l_unpaid_instalments   NUMBER;
     l_unpaid               NUMBER;
     l_1_pound_count        NUMBER;
     l_recovered_sum        NUMBER;
     l_amount_sum           NUMBER;
     
     CURSOR c_awards
     IS
     SELECT distinct(a.award_id)
     FROM award a, award_instalment b, stud_award_type c
     WHERE A.AWARD_ID = B.AWARD_ID
     AND A.STUD_AWARD_TYPE = C.STUD_AWARD_TYPE
     AND a.stud_crse_year_id = p_stud_crse_year_id
     AND C.TYPE IN('LPG','DEPG','SMA','BURS','LPCG', 'CESB')
     AND B.PAYMENT_STATUS = 'U'   
     AND b.net_amount = 1;    
   
     v_awards        c_awards%ROWTYPE;    
     
     
     
     BEGIN
     
     OPEN c_awards;
     
     LOOP
     
     FETCH c_awards
     INTO v_awards;
     
     EXIT WHEN c_awards%NOTFOUND;
     
        SELECT COUNT (ai.award_instalment_id)
                INTO l_unpaid_instalments
                FROM award_instalment ai, award a 
               WHERE AI.AWARD_ID = A.AWARD_ID
                 AND A.STUD_CRSE_YEAR_ID = p_stud_crse_year_id
                 AND ai.payment_status = 'U'
                 AND ai.net_amount > 1
                 AND A.AWARD_SRC <> 'T'
            ORDER BY ai.award_instalment_id;
                                   
            IF l_unpaid_instalments > 0
            THEN
                SELECT COUNT (award_instalment_id), SUM(ai.recovered_amount), SUM(ai.amount)
                INTO l_1_pound_count, l_recovered_sum, l_amount_sum
                FROM award_instalment ai, award a 
                WHERE AI.AWARD_ID = A.AWARD_ID
                AND A.STUD_CRSE_YEAR_ID = p_stud_crse_year_id
                AND A.AWARD_ID = v_awards.AWARD_ID
                AND ai.net_amount = 1
                AND payment_status = 'U';
                

                    DELETE award_instalment
                    WHERE net_amount = 1
                    AND award_id = v_awards.AWARD_ID
                    AND payment_status = 'U';
                    
                    UPDATE award_instalment
                    SET net_amount = (net_amount + l_1_pound_count), amount = (amount + l_amount_sum) , recovered_amount = (recovered_amount + l_recovered_sum)
                    WHERE payment_status = 'U'
                    AND payment_due_date = (select MIN(payment_due_date) from award_instalment where award_id = v_awards.AWARD_ID and payment_status = 'U')
                    AND award_id = v_awards.AWARD_ID;
            
            END IF;
                
     END LOOP;  
     
     CLOSE c_awards;
     
     END tidy_up_instalments;

   
END rules_proc_recalc;
/