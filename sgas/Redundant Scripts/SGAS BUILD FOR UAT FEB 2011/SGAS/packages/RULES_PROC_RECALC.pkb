CREATE OR REPLACE PACKAGE BODY SGAS.rules_proc_recalc
AS
/******************************************************************************
   NAME:       RULES_PROC 
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description 
   ---------  ----------  ---------------  ------------------------------------
   1.0        01/07/2010    Paul Hughes     Created Package
   1.1        20/07/2010    Clark Bolan     overpayment added to calculate awards procedure
   1.2        21/09/2010    Clark Bolan     removed TODATE from day1term1 etc. 
******************************************************************************/

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

            

/*
FUNCTION getOverPayAward (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_award_type IN CHAR) RETURN CHAR
IS

    l_count NUMBER;
    l_result CHAR;
    

BEGIN

        select count(*) 
        INTO l_count
        from award
        where stud_ref_no = p_stud_ref_no
        and session_code = p_session_code
        and stud_award_type IN(select stud_award_type from stud_award_type sat
                        where sat.type = p_award_type)                        
        and overpayment_amount > 0;
        
         IF l_count > 0
        THEN l_result := 'Y';
        ELSE l_result := 'N';
        END IF;
        
        RETURN l_result;
        
END getOverPayAward;        
        
*/      
        

FUNCTION maxAwardExceeded (p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS

    l_count NUMBER;
    l_result    CHAR;

BEGIN

        SELECT COUNT(NET_AMOUNT) 
        INTO l_count
        FROM AWARD
        WHERE STUD_CRSE_YEAR_ID = p_stud_crse_year_id
        AND NET_AMOUNT > MAX_AWARD;
        
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
     AND b.payment_status IN('S','P');

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
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-08',l_session),'DD-MM-YYYY')
                        THEN l_fee_cut_off_date := TO_DATE(CONCAT('01-12',l_session),'DD-MM-YYYY');
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-01',l_session),'DD-MM-YYYY')
                        THEN l_fee_cut_off_date := TO_DATE(CONCAT('01-03',l_session),'DD-MM-YYYY');
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-04',l_session+1),'DD-MM-YYYY')
                        THEN l_fee_cut_off_date := TO_DATE(CONCAT('01-06',l_session+1),'DD-MM-YYYY');
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-07',l_session+1),'DD-MM-YYYY')
                        THEN l_fee_cut_off_date := TO_DATE(CONCAT('01-12',l_session+2),'DD-MM-YYYY');
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
        AND payment_status IN('S','P');
        
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
    l_result            CHAR(1) := 'N';
    
BEGIN

   SELECT SUM(b.amount)
     INTO l_records_paid
     FROM award a, award_instalment b
    WHERE a.award_id = b.award_id
      AND a.award_src = 'T'
      AND b.payment_status IN('S', 'P')
      AND a.stud_crse_year_id = p_stud_crse_year_id;
      
       
        CASE 
            WHEN l_records_paid > 0 
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
                                FROM inst_term@grass a, stud_crse_year b
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
                        FROM inst_term@grass a, stud_crse_year b
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
                                FROM crse_term@grass a, stud_crse_year b
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
                        FROM crse_term@grass a, stud_crse_year b
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
    FROM sgas.stud_crse_year a, crse_year@grass b, crse_session@grass c
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
     FROM crse_term@grass a, stud_crse_year b
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
     FROM inst_term@grass a, stud_crse_year b
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
     FROM crse_year@grass cy, stud_crse_year scy
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
        FROM crse_term@grass a, stud_crse_year b
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
                           FROM inst_term@grass a, stud_crse_year b
                          WHERE TRUNC(b.withdraw_date) BETWEEN TRUNC (a.start_date)
                                                           AND TRUNC (a.end_date)
                            AND b.inst_code = a.inst_code
                            AND a.session_code = b.session_code
                            AND b.stud_crse_year_id = p_stud_crse_year_id;

                    ELSE
                    
                         SELECT a.term_no
                           INTO l_withdrawterm_no
                           FROM crse_term@grass a, stud_crse_year b
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
                           FROM inst_term@grass a, stud_crse_year b
                          WHERE TRUNC(b.start_date) BETWEEN TRUNC (a.start_date)
                                                           AND TRUNC (a.end_date)
                            AND b.inst_code = a.inst_code
                            AND a.session_code = b.session_code
                            AND b.stud_crse_year_id = p_stud_crse_year_id;

                    ELSE
                    
                         SELECT a.term_no
                           INTO l_studystartterm
                           FROM crse_term@grass a, stud_crse_year b
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
                           FROM inst_term@grass a, stud_crse_year b
                          WHERE TRUNC(l_study_end_date) BETWEEN TRUNC (a.start_date)
                                                           AND TRUNC (a.end_date)
                            AND b.inst_code = a.inst_code
                            AND a.session_code = b.session_code
                            AND b.stud_crse_year_id = p_stud_crse_year_id;

                    ELSE
                    
                         SELECT a.term_no
                           INTO l_studyendterm
                           FROM crse_term@grass a, stud_crse_year b
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
      AND scy.stud_crse_year_id = p_stud_crse_year_id
      AND bd.dependant_type = 'C';

   SELECT COUNT (ss.stud_ref_no)
     INTO l_dep2count
     FROM benefactor_dependant bd, stud_session ss, stud_crse_year scy
    WHERE bd.ben_id = ss.ben2_id
      AND ss.stud_session_id = scy.stud_session_id
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
         AND scy.stud_crse_year_id = p_stud_crse_year_id;

   CURSOR c_ben2_income
   IS
      SELECT bi.bank_interest, bi.benefit, bi.other_income,
             bi.nat_saving_interest, bi.paye_income, bi.pension,
             bi.self_employment, bi.property, bi.dividend, bi.other_deduct, BI.WORKING_TAX_CREDIT
        FROM stud_session ss, benefactor_income bi, stud_crse_year scy
       WHERE bi.ben_id = ss.ben2_id
         AND ss.stud_session_id = scy.stud_session_id
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
  

FUNCTION prev_session_bursary (p_stud_crse_year_id    IN   NUMBER)RETURN CHAR

IS

    l_session_code  NUMBER;
    l_commenceYear  NUMBER;
    l_prevBen1_rel  NUMBER;
    l_prev_exempt   CHAR;
    l_result        CHAR;

   
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
          --  WHEN --(l_commenceYear <> l_session_code) AND (l_ben1Exists = 'Y') ---IN THIS SCENARIO WE SET PREV BURSARY BASED ON BEN1_REL_TYPE
                --THEN
                --    SELECT ben1_rel_id
                --    INTO l_ben1_rel_id
                --    FROM STUD_SESSION ss, STUD_CRSE_YEAR scy
                --    WHERE ss.STUD_SESSION_ID = SCY.STUD_SESSION_ID
                --    AND scy.stud_crse_year_id = p_stud_crse_year_id;
                    
                --        IF
                --            l_ben1_rel_id = 28
                --            THEN l_result := 'N';
                --        ELSE l_result := 'Y';
                        
               --         END IF;
            
             WHEN (l_commenceYear <> l_session_code) --AND l_ben1Exists = 'N'  ---- WE NEED TO LOOK AT PREVIOUS SESSION YEAR VALUE FOR PAY_YSB
                    THEN
                       IF l_commenceYear < STEPS_RELEASE_YEAR ----WE NEED TO LOOK UP THE GRASS DATABASE
                       THEN
                       
                            SELECT NVL(scyg.PAY_YSB,'M')   --NVL WITH M to signal a NULL value
                            INTO l_result
                            FROM STUD_CRSE_YEAR@GRASS scyg, stud_crse_year scy
                            WHERE scyg.stud_ref_no = scy.stud_ref_no
                            AND scy.stud_crse_year_id = p_stud_crse_year_id
                            AND scyg.session_code = l_commenceYear;
                            
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
                                    
                            
                       
                       ELSE --- WE LOOK UP STEPS DATABASE
                    
                            SELECT NVL(scyg.PAY_YSB,'M') --NVL WITH M to signal a NULL value
                            INTO l_result
                            FROM STUD_CRSE_YEAR scyg, stud_crse_year scy
                            WHERE scyg.stud_ref_no = scy.stud_ref_no
                            AND scy.stud_crse_year_id = p_stud_crse_year_id
                            AND scyg.session_code = l_commenceYear;
                            
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
        AND stud_crse_year_id < p_stud_crse_year_id;
        
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
                                                                   FROM inst_term@grass inst, stud_crse_year scy
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
                                                                   FROM crse_term@grass a, stud_crse_year b
                                                                  WHERE a.crse_year_id = b.crse_year_id
                                                                    AND a.term_no = 1
                                                                    AND b.stud_crse_year_id = p_stud_crse_year_id)
                                                 --     AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                 --                           where a.payment_status IN('S','P')  -- NEW
                                                 --                           and b.stud_crse_year_id = p_stud_crse_year_id)   
                                                         AND payment_date <= l_study_end_date
                                                    UNION
                                                    SELECT   a.start_date AS payment_date  -- WE ALSO WANT TO GIVE A PAYMENT ON TEH DAY THE COURSE STARTS
                                                        FROM crse_term@grass a, stud_crse_year b
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
                                                                   FROM inst_term@grass inst, stud_crse_year scy
                                                                  WHERE scy.inst_code = inst.inst_code
                                                                    AND inst.session_code = scy.session_code
                                                                    AND inst.term_no = 1
                                                                    AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                                    AND payment_date <= l_study_end_date) --- AND LESS THAN OR EQUAL TOO EITHER COURSE_END_DATE OR WITHDRAW OR COURSE CHANGE.
                                                        AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
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
                                                                   FROM crse_term@grass a, stud_crse_year b
                                                                  WHERE a.crse_year_id = b.crse_year_id
                                                                    AND a.term_no = 1
                                                                    AND b.stud_crse_year_id = p_stud_crse_year_id)
                                                        AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
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
           FROM inst_term@grass a, stud_crse_year b
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
           FROM crse_term@grass a, stud_crse_year b
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
           FROM inst_term@grass a, stud_crse_year b
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
            FROM crse_term@grass a, stud_crse_year b
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
           FROM inst_term@grass a, stud_crse_year b
          WHERE a.inst_code = b.inst_code
            AND a.session_code = b.session_code
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.start_date <= endDate
            order by start_date;
            
            
   
   ELSIF DT = 'N' AND ST = 'N' AND ED = 'Y'THEN
            OPEN startdates_cursor FOR
            
            SELECT distinct a.start_date
            FROM crse_term@grass a, stud_crse_year b
            WHERE a.crse_year_id = b.crse_year_id
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.start_date <= endDate
            order by start_date;
            
 
   ELSIF DT = 'Y' AND ST = 'N' AND ED = 'N'THEN
            OPEN startdates_cursor FOR
            
           SELECT a.start_date
           FROM inst_term@grass a, stud_crse_year b
          WHERE a.inst_code = b.inst_code
            AND a.session_code = b.session_code
            AND b.stud_crse_year_id = p_stud_crse_year_id
            order by start_date;
   
   ELSIF DT = 'N' AND ST = 'N' AND ED = 'N'THEN
            OPEN startdates_cursor FOR
            
           SELECT a.start_date
           FROM crse_term@grass a, stud_crse_year b
          WHERE a.crse_year_id = b.crse_year_id
            AND b.stud_crse_year_id = p_stud_crse_year_id
            order by start_date;
   
   END IF;
  
   RETURN startdates_cursor;
END get_startdates;  
        

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
           FROM inst_term@grass a, stud_crse_year b
          WHERE a.inst_code = b.inst_code
            AND a.session_code = b.session_code
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.term_no <= l_max_term_default;
   ELSE
   
      l_max_term_no := get_max_term_no (p_stud_crse_year_id);

      OPEN termdays_cursor FOR
         SELECT a.days
           FROM crse_term@grass a, stud_crse_year b
          WHERE a.crse_year_id = b.crse_year_id
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.term_no <= l_max_term_no;
   END IF;

   RETURN termdays_cursor;
END get_termdays;

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
                                                                   FROM inst_term@grass inst, stud_crse_year scy
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
                                                                   FROM crse_term@grass a, stud_crse_year b
                                                                  WHERE a.crse_year_id = b.crse_year_id
                                                                    AND a.term_no = 1
                                                                    AND b.stud_crse_year_id = p_stud_crse_year_id)
                                                 --     AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                 --                           where a.payment_status IN('S','P')  -- NEW
                                                 --                           and b.stud_crse_year_id = p_stud_crse_year_id)   
                                                         AND payment_date <= l_study_end_date
                                                    UNION
                                                    SELECT   a.start_date AS payment_date  -- WE ALSO WANT TO GIVE A PAYMENT ON TEH DAY THE COURSE STARTS
                                                        FROM crse_term@grass a, stud_crse_year b
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
                                                                   FROM inst_term@grass inst, stud_crse_year scy
                                                                  WHERE scy.inst_code = inst.inst_code
                                                                    AND inst.session_code = scy.session_code
                                                                    AND inst.term_no = 1
                                                                    AND scy.stud_crse_year_id = p_stud_crse_year_id
                                                                    AND payment_date <= l_study_end_date) --- AND LESS THAN OR EQUAL TOO EITHER COURSE_END_DATE OR WITHDRAW OR COURSE CHANGE.
                                                        AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
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
                                                                   FROM crse_term@grass a, stud_crse_year b
                                                                  WHERE a.crse_year_id = b.crse_year_id
                                                                    AND a.term_no = 1
                                                                    AND b.stud_crse_year_id = p_stud_crse_year_id)
                                                        AND payment_date > (select MAX(a.payment_due_date) from award_instalment a, award b  -- NEW PH
                                                                            where a.payment_status IN('S','P')  -- NEW
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
                   FROM inst_term@grass inst, stud_crse_year scy
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
                   FROM crse_term@grass a, stud_crse_year b
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
BEGIN
   SELECT NVL (SUM (b.net_amount), 0)
     INTO l_fees_paid_amount
     FROM award a, award_instalment b
    WHERE a.award_id = b.award_id
      AND a.award_src = 'T'
      AND b.payment_status IN('S', 'P')
      AND a.stud_crse_year_id = p_stud_crse_year_id;

   RETURN l_fees_paid_amount;
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
  
  
--THIS FUNCTION RETURNS THE YEAR IN WHICH THEY STARTED THIS PARTICULAR COURSE - THIS IS NOT THE YEAR IN WHICH THEY STARTED STUDYING.
/*
FUNCTION get_start_year (p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS

    l_startYear         NUMBER := 0;
    l_crse_id          CHAR(8) := 'x';
    l_session_code      NUMBER := 0;
   
    BEGIN

        SELECT crse_id, session_code
        INTO l_crse_id, l_session_code
        FROM stud_crse_year
        WHERE stud_crse_year_id = p_stud_crse_year_id;
    
    SELECT   MIN(iv1.session_code) AS MINSESSION 
                 INTO l_startYear
             FROM (SELECT NVL (TO_NUMBER (y.session_code), l_session_code) session_code
                     FROM stud_crse_year@grass y
                    WHERE y.crse_year_id = l_crse_id
                      UNION
                   SELECT NVL (TO_NUMBER (y.session_code), l_session_code) session_code
                     FROM sgas.stud_crse_year y
                    WHERE y.crse_year_id = l_crse_id
                   UNION
                   SELECT l_session_code
                     FROM DUAL) iv1;
        
        RETURN l_startYear;
    
    END get_start_year;

*/          
    
PROCEDURE stud_type_doc (
   p_stud_crse_year_id      IN       NUMBER,
   p_stud_type              IN OUT   stud_type_cursor)
IS
BEGIN
   OPEN p_stud_type FOR
      SELECT a.location_ind, c.commence_session,
             DECODE(b.pgce, NULL, 'N', B.PGCE) AS pgce,
             d.scheme_type
        FROM inst@grass a, sgas.stud_crse_year b, sgas.stud c, crse@grass d, crse_year@grass e, crse_session@grass f
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
                ELSE sgas.rules_proc_recalc.prev_session_bursary(p_stud_crse_year_id)
            END prev_bursary,      
--      NVL (prev_session_bursary (p_stud_crse_year_id), 0) AS prev_bursary,
             DECODE (scy.pay_ysb, NULL, 'N', scy.pay_ysb) pay_ysb,
             CASE
                WHEN (scy.paid_sandwich = 'Y')
                 OR (crs.pams_course = 'Y')
                 OR (    scy.parent_contrib_exempt = 'N'
                     AND scy.calc_bursary = 'Y'
                     AND ss.ben1_rel_id IS NULL
                    )
                   THEN 'N'
                WHEN get_missingben1data (p_stud_crse_year_id) = 'Y' OR get_missingben2data (p_stud_crse_year_id) = 'Y'
                   THEN 'N'
                WHEN scy.award IN('C', 'D') 
                   THEN 'N'
                ELSE (scy.calc_bursary)
             END calculatebursary,
             getstudystartterm (p_stud_crse_year_id) AS studystartterm,
             scy.parent_contrib_exempt AS exemptfromcont, SS.BURSARY_DEDUCTION
        FROM stud_crse_year scy,
             stud_session ss,
             crse@grass crs,
             crse_session@grass crss,
             crse_year@grass cy
       WHERE scy.stud_crse_year_id = p_stud_crse_year_id
         AND ss.stud_session_id = scy.stud_session_id
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
      SELECT ss.net_income, ss.trust_income, ss.pension_income,
             NVL (ss.ja_stud_type, '') AS ja_stud_type,
            scy.parent_contrib_exempt,
             NVL (ss.ja_case, 'N') AS ja_case,
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
             daysinattendance (p_stud_crse_year_id) AS daysinattendance, NVL(SS.WORKING_TAX_CREDIT,0)
        FROM stud_session ss, stud st, ja_case ja, stud_crse_year scy
       WHERE scy.stud_crse_year_id = p_stud_crse_year_id
         AND ss.stud_ref_no = st.stud_ref_no
         AND scy.stud_session_id = ss.stud_session_id
         AND st.stud_ref_no = ss.stud_ref_no
         AND ja.ja_case_id(+) = ss.ja_case_id;
END income_assessment_doc;  



/* Formatted on 2010/07/08 15:23 (Formatter Plus v4.8.8) */
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
                ELSE sta.location_ind
                
                --CASE 
                  --      WHEN sta.location_ind IN('H','O') AND STA.END_DATE IS NULL
                  --      THEN 'H'
                  --      WHEN sta.location_ind IN('E','W') AND STA.END_DATE IS NULL
                  --      THEN 'E'
                  --      ELSE 'L'
                  --    END
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
                   sta.location_ind
                       -- CASE 
                         --       WHEN sta.location_ind IN('H','O') AND STA.END_DATE IS NULL
                          --      THEN 'H'
                           --     WHEN sta.location_ind IN('E','W') AND STA.END_DATE IS NULL
                            --    THEN 'E'
                            --    ELSE 'L'
                            --  END
                ELSE 
                        CASE
                        WHEN scy.study_abroad = 'Y'
                        THEN c.new_category
                        ELSE 
                        sta.location_ind
                        END
             END home_location_type,
             get_abroad_days_in_term (p_stud_crse_year_id)
                                                         AS term_days_abroad
        FROM stud_crse_year scy,
             stud_session ss,
             country@grass c,
             stud_term_addr sta,
             crse@grass crs,
             crse_session@grass cs,
             crse_year@grass cy
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
             END attendfeecutoff
        FROM stud_crse_year scy,
             stud_session ss,
             crse@grass c,
             crse_session@grass cs,
             crse_year@grass cy,
             inst@grass i
       WHERE scy.stud_crse_year_id = p_stud_crse_year_id
         AND c.crse_id = cs.crse_id
         AND cy.crse_session_id = cs.crse_session_id
         AND scy.crse_year_id = cy.crse_year_id
         AND scy.inst_code = i.inst_code
         AND ss.stud_session_id = scy.stud_session_id;
         
END fees_doc;


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
         AND sd.stud_ref_no = scy.stud_ref_no
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
             scy.award, 
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
           --  MIN(SCY.WITHDRAW_DATE,SCY.CRSE_CHG) AS WITHDRAW_DATE, 
             ST.OVERPAYMENT, 
             NVL(sgas.rules_proc_recalc.getPrevSessionProvisionalFlag(scy.stud_ref_no, scy.session_code),'N') AS prevProv,
             SCY.parent_contrib_exempt, ss.ben1_id, ss.ben2_id,
             sgas.rules_proc_recalc.getStartDateTerm(scy.stud_crse_year_id,1) AS courseStartDate,
             sgas.rules_proc_recalc.get_ja_studs_reg(p_stud_crse_year_id) AS ja_studs_reg,
                CASE
                WHEN (scy.paid_sandwich = 'Y')
                 OR (crs.pams_course = 'Y')
                 OR (    scy.parent_contrib_exempt = 'N'
                     AND scy.calc_bursary = 'Y'
                     AND ss.ben1_rel_id IS NULL
                    )
                   THEN 'N'
                WHEN get_missingben1data (p_stud_crse_year_id) = 'Y' OR get_missingben2data (p_stud_crse_year_id) = 'Y'
                   THEN 'N'
                WHEN scy.award = 'C'
                   THEN 'N'
                ELSE (scy.calc_bursary)
             END calc_bursary, SCY.CALC_FEE, SCY.CALC_LOAN, SCY.ASSESS_LOAN, SCY.CALC_DEP_GRANT,       
             SCY.CALC_LPCG, SCY.CALC_LPG, SCY.CALC_SMA, SCY.CALC_SPA, SCY.LATEST_CRSE_IND, tft.tuition_fee_type_code, 
             ss.lpcg_paid_amount AS LPCGRequested,
             ss.max_lpcg_paid AS LPCGMax --sgas.rules_proc_recalc.getfeespaidamount(scy.stud_crse_year_id) as feesAmountPaid,
             /*
             CASE
                WHEN sgas.rules_proc_recalc.more_studcrse_year_record(scy.stud_crse_year_id) = 'N'
                    THEN 'N'
                    ELSE sgas.rules_proc_recalc.getOverPayAward(scy.stud_ref_no, scy.session_code, 'BURS')
             END overPayBursary,
                          CASE
                WHEN sgas.rules_proc_recalc.more_studcrse_year_record(scy.stud_crse_year_id) = 'N'
                    THEN 'N'
                    ELSE sgas.rules_proc_recalc.getOverPayAward(scy.stud_ref_no, scy.session_code, 'DEPG')
             END overPayDG,
             CASE
                WHEN sgas.rules_proc_recalc.more_studcrse_year_record(scy.stud_crse_year_id) = 'N'
                    THEN 'N'
                    ELSE sgas.rules_proc_recalc.getOverPayAward(scy.stud_ref_no, scy.session_code, 'LPG')
             END overPayLPG,
                          CASE
                WHEN sgas.rules_proc_recalc.more_studcrse_year_record(scy.stud_crse_year_id) = 'N'
                    THEN 'N'
                    ELSE sgas.rules_proc_recalc.getOverPayAward(scy.stud_ref_no, scy.session_code, 'LPCG')
             END overPayLPCG,
                          CASE
                WHEN sgas.rules_proc_recalc.more_studcrse_year_record(scy.stud_crse_year_id) = 'N'
                    THEN 'N'
                    ELSE sgas.rules_proc_recalc.getOverPayAward(scy.stud_ref_no, scy.session_code, 'SMA')
             END overPayUGSMAH  
             */
        FROM stud_crse_year scy,
             stud_session ss,
             crse_session@grass cs,
             crse_year@grass cy,
             tuition_fee_type@grass tft,
             crse@grass crs,
             stud st,
             inst@grass inst,
             stud_term_addr sta,
             campus@grass cam
       WHERE scy.stud_crse_year_id = p_stud_crse_year_id
         AND cs.crse_session_id = cy.crse_session_id
         AND sta.stud_ref_no = st.stud_ref_no
         AND scy.stud_session_id = ss.stud_session_id
         AND crs.crse_id = cs.crse_id
         AND inst.inst_code = crs.inst_code
         AND cy.crse_year_id = scy.crse_year_id
         AND st.stud_ref_no = scy.stud_ref_no
         AND inst.inst_code = SCY.INST_CODE
         AND crs.fees_campus = cam.campus_id
         AND tft.tuition_fee_type_code(+) = cs.tuition_fee_type_code;

   p_term_days := get_termdays (p_stud_crse_year_id);
 
END calculateawarddoc;

PROCEDURE awardInstalments( p_stud_crse_year_id IN NUMBER, p_awardInstalment_type    IN OUT awardInstalments_cursor,
                           -- p_start_dates_cursor         IN OUT   start_dates_cursor_type,
                            p_start_dates           IN OUT   startdates_cursor_type,
                            p_payment_dates         IN OUT   all_payment_cursor_type)
IS

l_default_term CHAR(1);
e_exceeded_award    EXCEPTION;

BEGIN

        IF sgas.rules_proc_recalc.maxAwardExceeded (p_stud_crse_year_id) = 'Y'
            THEN RAISE e_exceeded_award;
        ELSE
        


    OPEN p_awardInstalment_type FOR
    
select a.award_id, a.stud_crse_year_id, a.stud_award_type, a.amount, a.recovered_amount, a.contrib_amount, a.net_amount, a.unclaimed_fee_loan,s.payment_method,
    CASE
        WHEN a.award_src = 'T'
            THEN 'I'
        ELSE 'S'
    END payee, 
    CASE 
        WHEN sat.loan_non_loan_fee = 'fee'
            THEN sgas.rules_proc_recalc.getCampusID(c.crse_id,'F')
        ELSE sgas.rules_proc_recalc.getCampusID(c.crse_id,'A')
    END campus_id,   -- MAINTENANCE CAMPUS - RE-VISIT AFTER SPEAKING TO PAUL D
    scy.start_date, 
    CASE 
        WHEN i.location_ind = 1 AND a.award_src = 'A'
            THEN 'M'
        WHEN i.location_ind <> 1 AND a.award_src = 'A'
            THEN 'T'
            ELSE 'F'
        END apportionment_method, 
        sgas.rules_proc_recalc.getpaidfees(scy.stud_crse_year_id) as prePaidFees,
        sgas.rules_proc_recalc.count_payment_dates(scy.stud_crse_year_id) as numberOfPayments,
        a.assessment_date,  
        CASE WHEN sgas.rules_proc_recalc.triplepayment_flag(scy.stud_crse_year_id) = 'Y' AND scy.start_date IS NULL
             THEN 3
             WHEN scy.start_date IS NOT NULL
             THEN 1 
             ELSE 2
        END triplepaymentflag, 
        sgas.rules_proc_recalc.daysinattendance (scy.stud_crse_year_id) as daysInAttendance,
    ca.payment_method AS feesPaymentMethod, 
  --  ca.campus_id as feescampus, --- REVISIT AFTER SPEAKING WITH PAUL D
    cy.cutoff_date as fee_payment_date, 
    CASE
        WHEN a.stud_award_type IN('UGOA','UGDA','LPCG','PSOA','PSDA')  
            THEN 'Y'  --IF AWARD TYPE IS DG, LPG OR LPCG TYPE
            ELSE 'N'
    END termlygrant,
    CASE
        WHEN scy.start_date IS NULL AND scy.withdraw_date IS NULL AND scy.crse_chg IS NULL
            THEN 'Y'
            ELSE 'N'
    END termly365periodFlag, 
    scy.session_code, 
    sgas.rules_proc_recalc.getdaysinattendanceinterm(scy.stud_crse_year_id,1) as daysInTerm1,
    sgas.rules_proc_recalc.getdaysinattendanceinterm(scy.stud_crse_year_id,2) as daysInTerm2,
    sgas.rules_proc_recalc.getdaysinattendanceinterm(scy.stud_crse_year_id,3) as daysInTerm3,
    sgas.rules_proc_recalc.getdaysinattendanceinterm(scy.stud_crse_year_id,4) as daysInTerm4,
    sgas.rules_proc_recalc.getStartDateTerm(scy.stud_crse_year_id,1) AS term1startDate, 
    sgas.rules_proc_recalc.getStartDateTerm(scy.stud_crse_year_id,2) AS term2startDate, 
    sgas.rules_proc_recalc.getStartDateTerm(scy.stud_crse_year_id,3) AS term3startDate,
    sgas.rules_proc_recalc.getStartDateTerm(scy.stud_crse_year_id,4) AS term4startDate,
    sgas.rules_proc_recalc.number_of_terms(scy.stud_crse_year_id) AS maxterms,
    scy.withdraw_date,
    scy.crse_chg,
    scy.scheme_type AS schemeType,
    CASE
       WHEN (s.payment_method = 'C')
       THEN 'H'                                                 
       WHEN (s.payment_method = 'B' AND s.nominee = 'N'         )
       THEN 'B'                                              
       ELSE 'N'
       END payment_addr,
    CASE
        WHEN sat.stud_award_type = 'TFEL'
            THEN 'Y'
        ELSE 'N'
        END feeLoanInstalment,
    CASE 
        WHEN scy.scheme_type = 'P'
             THEN SGAS.RULES_PROC_RECALC.FEE_CUT_OFF_DATE(scy.stud_crse_year_id)
        ELSE NULL
        END feeCutOffDate, s.stud_ref_no AS studRefNo, sgas.rules_proc_recalc.getstudystartterm(scy.stud_crse_year_id) studyStartTerm,
        sgas.rules_proc_recalc.getstudyendterm (scy.stud_crse_year_id)
from award a, stud s, stud_crse_year scy, crse_year cy, crse_session cs, crse c, inst i, campus ca, stud_award_type sat
where a.stud_crse_year_id = scy.stud_crse_year_id
and scy.stud_ref_no = s.stud_ref_no
and scy.crse_year_id = cy.crse_year_id
and cy.crse_session_id = cs.crse_session_id
and sat.stud_award_type = a.stud_award_type
and sat.loan_non_loan_fee <> 'Loan'  
and sat.type NOT IN('DSA','TRAV','MAN')
and sat.type <> 'NMSB'
and cs.crse_id = c.crse_id
and scy.scheme_type <> 'B'
and c.inst_code = i.inst_code
and c.fees_campus = ca.campus_id
--and c.maint_campus = ca.campus_id
and scy.stud_crse_year_id = p_stud_crse_year_id;

p_payment_dates := get_payment_dates (p_stud_crse_year_id);
p_start_dates := get_startdates (p_stud_crse_year_id);

    END IF;

EXCEPTION
      WHEN e_exceeded_award
      THEN
         raise_application_error
               (-20001,
                   'Award amount has exceeded the maximum allowed - please contact BSU '
               );
                   

END awardInstalments;


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


END rules_proc_recalc;
/
