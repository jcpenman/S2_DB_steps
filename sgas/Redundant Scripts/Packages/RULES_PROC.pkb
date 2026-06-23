CREATE OR REPLACE PACKAGE BODY SGAS.rules_proc
AS
/******************************************************************************
   NAME:       RULES_PROC 
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description 
   ---------  ----------  ---------------  ------------------------------------
   3.1          14/06/2010  Paul Hughes     Changed payee_addr = 'H' when payment method is 'C' (Cheque)
   3.0          23/03/2010  Clark Bolan     Added Start_date and Withdrawal_date to calculateawarddoc
   2.9          17/03/2010  Paul Hughes     FUNCTION prev_session_bursary amended to add condition where prev rel_id = 28 also l_pay_ysb = N
   2.8          17/03/2010  Clark Bolan     Added bursary deduction to the bursary procedure
   2.7          24/02/2010  Paul Hughes     Added Function get_ja_studs_reg to return the number of JA_CASES
   2.6          09/02/2010  Paul Hughes     New FUNCTION get_abroad_days_in_term.
   2.5          05/02/2010  Paul Hughes     home_location_type added to Loans_doc
   2.4          27/01/2010  Clark Bolan     SCY.PSAS_PT added to the fees PROC
   2.3          21/01/2010  Paul Hughes     WORKING TAX CREDIT NVL to 0
   2.2          15/01/2009  Paul Hughes     UPDATED STUD_TYPE_DOC PROCEDURE BY REMOVING PARTIME and ADDING STUD_CRSE_YEAR.PGCE value
   2.1          14/12/2009  Clark Bolan     FEE_LOAN_CHARGED added to the Fees Procedure.
   2.0          21/10/2009  Paul Hughes     Updated PROCEDURE stud_type_doc joins to use crse_year and crse_session tables in GRASS
   1.9          09/09/2009  Clark Bolan     PROCEDURE travelElement added, get_stud_age X added
   1.8          25/08/2009  Clark Bolan     Ammended function get_payment_dates, get_payment_count end date to use >=
   1.7          24/08/2009  Paul Hughes     Final year calculation was using get_max_term_no.  New Function added/created get_max_year_no
   1.6          10/08/2009  Paul Hughes     Added scy.ASSESS_LOAN to be returned from PROCEDURE loans_doc required for RULES engine.
   1.5          07/07/2009  Paul Hughes     Amended PROCEDURE income_assessment_doc by taking out dob and AcademicYearDate and 
                                            replacing with scy.parent_contrib_exempt in order to match rules engine.
   1.4          23/04/2009  Paul Hughes     BursaryDoc updated to include exemptfromcont
   1.3          16/01/2009  Paul Hughes     Removed instances where stud_session table was used in excess to stud_crse_year table present
   1.2          02/08/2007  Paul Hughes     CHANGE CALCULATE_BURSARY = N WHEN STUD_CRSE_YEAR.AWARD = 'C'
   1.1          24.07.2008  Paul Hughes     Fix to installments bug.
   1.0          27/03/2008  Angel Anchev    Created this package body.
******************************************************************************/


/* Formatted on 2010/02/24 12:49 (Formatter Plus v4.8.8) */
FUNCTION get_ja_studs_reg (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN NUMBER
IS
   l_ja_case_id             NUMBER := 0;
   l_no_non_saas_children   NUMBER := 0;
   l_count_ja_case_id       NUMBER := 0;
   l_ja_studs_reg           NUMBER := 0;
BEGIN
   SELECT NVL (ja_case_id, 0)
     INTO l_ja_case_id
     FROM stud_session
    WHERE stud_ref_no = p_stud_ref_no AND session_code = p_session_code;

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


FUNCTION get_abroad_days_in_term (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
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

    l_max_terms := number_of_terms (p_stud_ref_no, p_session_code);
    l_default_term := check_default_terms (p_stud_ref_no , p_session_code);   
    
         SELECT NVL(A.END_DATE_ABROAD,TO_DATE ('01-JAN-1900','DD-MM-YYYY')), NVL(A.START_DATE_ABROAD, TO_DATE('01-JAN-1900','DD-MM-YYYY'))
         INTO l_end_date_abroad, l_start_date_abroad
         FROM STUD_CRSE_YEAR A
         WHERE a.session_code = p_session_code
         AND a.stud_ref_no = p_stud_ref_no
         AND a.latest_crse_ind = 'Y';
                         
                        WHILE  l_max_terms > 0 AND l_default_term = 'Y' AND l_end_date_abroad <> TO_DATE('01-JAN-1900','DD-MM-YYYY') AND l_start_date_abroad <> TO_DATE('01-JAN-1900','DD-MM-YYYY')
                        LOOP
                        
                                SELECT a.start_date, a.end_date
                                INTO l_term_start_date, l_term_end_date
                                FROM inst_term@grass a, stud_crse_year b
                                WHERE a.inst_code = b.inst_code
                                AND a.session_code = b.session_code
                                AND a.session_code = p_session_code
                                AND b.stud_ref_no = p_stud_ref_no
                                AND a.term_no = l_max_terms
                                AND b.latest_crse_ind = 'Y';
                                
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
                        AND a.session_code = p_session_code
                        AND b.stud_ref_no = p_stud_ref_no
                        AND a.term_no = l_max_terms
                        AND b.latest_crse_ind = 'Y';

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
                                AND b.session_code = p_session_code
                                AND b.stud_ref_no = p_stud_ref_no
                                AND b.latest_crse_ind = 'Y'
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
                        AND b.session_code = p_session_code
                        AND b.stud_ref_no = p_stud_ref_no
                        AND a.term_no = l_max_terms
                        AND b.latest_crse_ind = 'Y';
                        
                         IF l_abroad_days1 <= 0
                              THEN l_abroad_days1 := 0;
                           ELSE l_abroad_days1 := l_abroad_days1;
                        END IF;
                        
                        l_total_abroad_days := l_abroad_days1 + l_total_abroad_days;
                        
                        l_max_terms := l_max_terms - 1;
                        
                        END LOOP;
                             
        RETURN l_total_abroad_days;

END get_abroad_days_in_term;       
 
       


FUNCTION get_max_year_no (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
    RETURN NUMBER
IS
    l_max_year_no NUMBER := 0;
BEGIN

    SELECT c.max_duration
    INTO l_max_year_no
    FROM sgas.stud_crse_year a, crse_year@grass b, crse_session@grass c
    WHERE a.crse_year_id = b.crse_year_id
    AND c.crse_session_id = b.crse_session_id
    AND a.stud_ref_no = p_stud_ref_no
    AND a.session_code = p_session_code
    AND a.latest_crse_ind = 'Y';

    RETURN l_max_year_no;
    
END get_max_year_no;




/* Formatted on 2009/01/20 10:27 (Formatter Plus v4.8.8) */
FUNCTION get_max_term_no (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN NUMBER
IS
   l_max_term_no   NUMBER := 0;
BEGIN
   -- Get the last term date for the session
   SELECT MAX (term_no)
     INTO l_max_term_no
     FROM crse_term@grass a, stud_crse_year b
    WHERE a.crse_year_id = b.crse_year_id
      AND b.session_code = p_session_code
      AND b.stud_ref_no = p_stud_ref_no
      AND b.latest_crse_ind = 'Y';

   RETURN l_max_term_no;
END get_max_term_no;
    
/* Formatted on 2009/01/20 10:27 (Formatter Plus v4.8.8) */
FUNCTION get_max_term_default (
   p_stud_ref_no    IN   NUMBER,
   p_session_code   IN   NUMBER
)
   RETURN NUMBER
IS
   l_max_term_default   NUMBER := 0;
BEGIN
   -- Get the last term date for the session
   SELECT MAX (term_no)
     INTO l_max_term_default
     FROM inst_term@grass a, stud_crse_year b
    WHERE b.inst_code = a.inst_code
      AND b.session_code = p_session_code
      AND b.stud_ref_no = p_stud_ref_no
      AND b.latest_crse_ind = 'Y';

   RETURN l_max_term_default;
END get_max_term_default;
    
/* Formatted on 2009/01/20 10:27 (Formatter Plus v4.8.8) */
FUNCTION check_default_terms (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN CHAR
IS
   l_default_term   CHAR (1) := '';
BEGIN
   SELECT cy.default_terms
     INTO l_default_term
     FROM crse_year@grass cy, stud_crse_year scy
    WHERE cy.crse_year_id = scy.crse_year_id
      AND scy.stud_ref_no = p_stud_ref_no
      AND scy.session_code = p_session_code
      AND scy.latest_crse_ind = 'Y';

   RETURN l_default_term;
END check_default_terms;

/* Formatted on 2009/01/20 10:27 (Formatter Plus v4.8.8) */
FUNCTION number_of_terms (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN NUMBER
IS
   l_default_term      CHAR (1)   := '';
   l_number_of_terms   NUMBER := 0;
   
BEGIN
   l_default_term := check_default_terms (p_stud_ref_no, p_session_code);

   IF l_default_term = 'Y'
   THEN
      l_number_of_terms :=
                         get_max_term_default (p_stud_ref_no, p_session_code);                                                                    
   ELSE
      l_number_of_terms := get_max_term_no (p_stud_ref_no, p_session_code);

   END IF;

   RETURN l_number_of_terms;
END number_of_terms;
      
/* Formatted on 2009/01/20 10:43 (Formatter Plus v4.8.8) */
FUNCTION final_year_check (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN CHAR
IS
   l_max_year_no        NUMBER   := 0;
   l_crse_year_no       NUMBER   := 0;              
   l_final_year         CHAR (1) := '';
                                  
BEGIN

 l_max_year_no := get_max_year_no (p_stud_ref_no, p_session_code);

      SELECT crse_year_no
        INTO l_crse_year_no
        FROM stud_crse_year
       WHERE latest_crse_ind = 'Y'
         AND session_code = p_session_code
         AND stud_ref_no = p_stud_ref_no;

      IF l_crse_year_no = l_max_year_no
      THEN
         l_final_year := 'Y';
      ELSE
         l_final_year := 'N';
      END IF;
 
   RETURN l_final_year;
END final_year_check;

/* Formatted on 2009/01/20 10:55 (Formatter Plus v4.8.8) */
FUNCTION get_courselength (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN NUMBER
IS
   l_max_term_no        NUMBER  := NULL;
   l_max_term_default   NUMBER  := NULL;
   l_default_term       CHAR (1)   := '';
   l_courselength       NUMBER;
BEGIN
   l_default_term := check_default_terms (p_stud_ref_no, p_session_code);

   IF l_default_term = 'Y'
   THEN
      SELECT SUM (days)
        INTO l_courselength
        FROM inst_term@grass a, stud_crse_year b
       WHERE b.inst_code = a.inst_code
         AND a.session_code = b.session_code
         AND b.session_code = p_session_code
         AND b.stud_ref_no = p_stud_ref_no
         AND b.latest_crse_ind = 'Y';
   ELSE
      SELECT SUM (days)
        INTO l_courselength
        FROM crse_term@grass a, stud_crse_year b
       WHERE a.crse_year_id = b.crse_year_id
         AND b.session_code = p_session_code
         AND b.stud_ref_no = p_stud_ref_no
         AND b.latest_crse_ind = 'Y';
   END IF;

   RETURN l_courselength;
END get_courselength;

/* Formatted on 2009/01/22 14:28 (Formatter Plus v4.8.8) */

FUNCTION daysinattendance (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN NUMBER
IS
   l_start_date         DATE;
   l_cystart_date       DATE;
   l_withdraw_date      DATE;
   l_term_no            NUMBER ;
   l_term_no2           NUMBER ;
   l_daysbetween        NUMBER ;
   l_daysbetween2       NUMBER ;
   l_end_date           DATE;
   l_remainingdays      NUMBER ;
   l_default_term       CHAR (1)   := '';
   l_courselength       NUMBER;
   l_daysinattendance   NUMBER;
BEGIN
   SELECT NVL (start_date, TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')),
          NVL (scy.withdraw_date, TO_DATE ('01-JAN-1900', 'DD-MM-YYYY'))
     INTO l_cystart_date,
          l_withdraw_date
     FROM stud_crse_year scy
    WHERE scy.stud_ref_no = p_stud_ref_no
      AND scy.session_code = p_session_code
      AND scy.latest_crse_ind = 'Y';

   l_default_term := check_default_terms (p_stud_ref_no, p_session_code)                                                                    ;
   l_courselength := get_courselength (p_stud_ref_no, p_session_code)                                                                ;

   IF l_default_term = 'Y'
   THEN
      --ONLY THE WITHDRAW DATE EXISTS
      IF     l_cystart_date = TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
         AND l_withdraw_date <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
      THEN
         SELECT a.term_no, a.start_date
           INTO l_term_no, l_start_date
           FROM inst_term@grass a, stud_crse_year b
          WHERE TRUNC ((l_withdraw_date)) BETWEEN TRUNC (a.start_date)
                                              AND TRUNC (a.end_date)
            AND b.inst_code = a.inst_code
            AND a.session_code = b.session_code
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y';

         --WORK OUT DAYS B
         SELECT   TO_DATE (l_withdraw_date, 'DD/MM/YYYY')
                - TO_DATE (l_start_date, 'DD/MM/YYYY')
                + 1
           INTO l_daysbetween
           FROM DUAL;

         SELECT NVL (SUM (a.days), 0)
           INTO l_remainingdays
           FROM inst_term@grass a, stud_crse_year b
          WHERE b.inst_code = a.inst_code
            AND a.session_code = b.session_code
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND a.term_no < l_term_no
            AND b.latest_crse_ind = 'Y';

         l_daysinattendance := l_remainingdays + l_daysbetween;
      --ONLY THE START_DATE EXISTS
      ELSIF     l_cystart_date <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
            AND l_withdraw_date = TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
      THEN
         SELECT a.term_no, a.end_date
           INTO l_term_no, l_end_date
           FROM inst_term@grass a, stud_crse_year b
          WHERE TRUNC ((l_cystart_date)) BETWEEN TRUNC (a.start_date)
                                             AND TRUNC (a.end_date)
            AND b.inst_code = a.inst_code
            AND a.session_code = b.session_code
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y';

         SELECT   TO_DATE (l_end_date, 'DD/MM/YYYY')
                - TO_DATE (l_cystart_date, 'DD/MM/YYYY')
                + 1
           INTO l_daysbetween
           FROM DUAL;

         SELECT NVL (SUM (a.days), 0)   --- FIXED NOT NVL
           INTO l_remainingdays
           FROM inst_term@grass a, stud_crse_year b
          WHERE b.inst_code = a.inst_code
            AND a.session_code = b.session_code
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND a.term_no > l_term_no
            AND b.latest_crse_ind = 'Y';

         l_daysinattendance := l_remainingdays + l_daysbetween;
      --BOTH START DATE AND WITHDRAW DATE EXIST
      ELSIF     l_cystart_date <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
            AND l_withdraw_date <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
      THEN
         SELECT a.term_no, a.end_date
           INTO l_term_no, l_end_date
           FROM inst_term@grass a, stud_crse_year b
          WHERE TRUNC ((l_cystart_date)) BETWEEN TRUNC (a.start_date)
                                             AND TRUNC (a.end_date)
            -- l_term_no = 1 AND l_end_date = '15/10/2008'
            AND b.inst_code = a.inst_code
            AND a.session_code = b.session_code
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y';

         SELECT a.term_no, a.start_date
           INTO l_term_no2, l_start_date
           FROM inst_term@grass a, stud_crse_year b
          WHERE TRUNC ((l_withdraw_date)) BETWEEN TRUNC (a.start_date)
                                              AND TRUNC (a.end_date)
            AND b.inst_code = a.inst_code
            -- l_term_no = 1 AND l_start_date = '01-10-2008'
            AND a.session_code = b.session_code
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y';

         IF l_term_no = l_term_no2
         THEN
            SELECT   TO_DATE (l_withdraw_date, 'DD/MM/YYYY')
                   - TO_DATE (l_cystart_date, 'DD/MM/YYYY')
                   + 1
              INTO l_daysbetween
              FROM DUAL;

            l_daysinattendance := l_daysbetween;
         ELSE
            SELECT   TO_DATE (l_end_date, 'DD/MM/YYYY')
                   - TO_DATE (l_cystart_date, 'DD/MM/YYYY')
                   + 1
              INTO l_daysbetween
              FROM DUAL;

            SELECT   TO_DATE (l_withdraw_date, 'DD/MM/YYYY')
                   - TO_DATE (l_start_date, 'DD/MM/YYYY')
                   + 1
              INTO l_daysbetween2
              FROM DUAL;

            SELECT NVL (SUM (a.days), 0)
              INTO l_remainingdays
              FROM inst_term@grass a, stud_crse_year b
             WHERE b.inst_code = a.inst_code
               AND a.session_code = b.session_code
               AND b.session_code = p_session_code
               AND b.stud_ref_no = p_stud_ref_no
               AND a.term_no > l_term_no
               AND a.term_no < l_term_no2
               AND b.latest_crse_ind = 'Y';

            l_daysinattendance :=
                              l_remainingdays + l_daysbetween + l_daysbetween2;
         END IF;
      --BOTH VALUES ARE NOT PRESENT USE l_courselength
      ELSE
         l_daysinattendance := l_courselength;
      END IF;
   ELSE
      IF     l_cystart_date = TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
         AND l_withdraw_date <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
      THEN
         SELECT a.term_no, a.start_date
           INTO l_term_no, l_start_date
           FROM crse_term@grass a, stud_crse_year b
          WHERE TRUNC ((l_withdraw_date)) BETWEEN TRUNC (a.start_date)
                                              AND TRUNC (a.end_date)
            AND a.crse_year_id = b.crse_year_id
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y';

         --WORK OUT DAYS B
         SELECT   TO_DATE (l_withdraw_date, 'DD/MM/YYYY')
                - TO_DATE (l_start_date, 'DD/MM/YYYY')
                + 1
           INTO l_daysbetween
           FROM DUAL;

         SELECT NVL (SUM (a.days), 0)
           INTO l_remainingdays
           FROM crse_term@grass a, stud_crse_year b
          WHERE a.crse_year_id = b.crse_year_id
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y'
            AND a.term_no < l_term_no;

         l_daysinattendance := l_remainingdays + l_daysbetween;
      --ONLY THE START_DATE EXISTS
      ELSIF     l_cystart_date <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
            AND l_withdraw_date = TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
      THEN
         SELECT a.term_no, a.end_date
           INTO l_term_no, l_end_date
           FROM crse_term@grass a, stud_crse_year b
          WHERE TRUNC ((l_cystart_date)) BETWEEN TRUNC (a.start_date)
                                             AND TRUNC (a.end_date)
            AND a.crse_year_id = b.crse_year_id
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y';

            SELECT  TO_DATE (l_end_date, 'DD/MM/YYYY')              --- UPDATED so greater date 
                    - TO_DATE (l_cystart_date, 'DD/MM/YYYY')
                    + 1
           INTO l_daysbetween
           FROM DUAL;

         SELECT NVL(SUM (a.days),0)
           INTO l_remainingdays
           FROM crse_term@grass a, stud_crse_year b
          WHERE a.term_no > l_term_no
            AND a.crse_year_id = b.crse_year_id
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y';

         l_daysinattendance := l_remainingdays + l_daysbetween;
      --BOTH START DATE AND WITHDRAW DATE EXIST
      ELSIF     l_cystart_date <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
            AND l_withdraw_date <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
      THEN
         SELECT a.term_no, a.end_date
           INTO l_term_no, l_end_date
           FROM crse_term@grass a, stud_crse_year b
          WHERE TRUNC ((l_cystart_date)) BETWEEN TRUNC (a.start_date)
                                             AND TRUNC (a.end_date)
            -- l_term_no = 1 AND l_end_date = '15/10/2008'
            AND a.crse_year_id = b.crse_year_id
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y';

         SELECT a.term_no, a.start_date
           INTO l_term_no2, l_start_date
           FROM crse_term@grass a, stud_crse_year b
          WHERE TRUNC ((l_withdraw_date)) BETWEEN TRUNC (a.start_date)
                                              AND TRUNC (a.end_date)
            AND a.crse_year_id = b.crse_year_id
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y';

         IF l_term_no = l_term_no2
         THEN
            SELECT   TO_DATE (l_withdraw_date, 'DD/MM/YYYY')
                   - TO_DATE (l_cystart_date, 'DD/MM/YYYY')
                   + 1
              INTO l_daysbetween
              FROM DUAL;

            l_daysinattendance := l_daysbetween;
         ELSE
            SELECT   TO_DATE (l_end_date, 'DD/MM/YYYY')
                   - TO_DATE (l_cystart_date, 'DD/MM/YYYY')
                   + 1
              INTO l_daysbetween
              FROM DUAL;

            SELECT   TO_DATE (l_withdraw_date, 'DD/MM/YYYY')
                   - TO_DATE (l_start_date, 'DD/MM/YYYY')
                   + 1
              INTO l_daysbetween2
              FROM DUAL;

            SELECT NVL (SUM (a.days), 0)
              INTO l_remainingdays
              FROM crse_term@grass a, stud_crse_year b
             WHERE a.crse_year_id = b.crse_year_id
               AND b.session_code = p_session_code
               AND b.stud_ref_no = p_stud_ref_no
               AND a.term_no < l_term_no2
               AND b.latest_crse_ind = 'Y';

            l_daysinattendance :=
                              l_remainingdays + l_daysbetween + l_daysbetween2;
         END IF;
      --BOTH VALUES ARE NOT PRESENT USE l_courselength
      ELSE
         l_daysinattendance := l_courselength;
      END IF;
   END IF;

   RETURN l_daysinattendance;
END daysinattendance;
     
/* Formatted on 2009/01/22 14:31 (Formatter Plus v4.8.8) */
FUNCTION getwithdrawelterm (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN NUMBER
IS
   l_withdraw_d        DATE;
   l_withdrawterm_no   NUMBER;
   l_default_term      CHAR (1)   := 'N';
BEGIN
   SELECT NVL (scy.withdraw_date, TO_DATE ('01-JAN-1900', 'DD-MM-YYYY'))
     INTO l_withdraw_d
     FROM stud_crse_year scy
    WHERE scy.stud_ref_no = p_stud_ref_no
      AND scy.session_code = p_session_code
      AND scy.latest_crse_ind = 'Y';

   l_default_term := check_default_terms (p_stud_ref_no, p_session_code);

   IF l_default_term = 'Y'
   THEN
      IF l_withdraw_d <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
      THEN
         SELECT a.term_no
           INTO l_withdrawterm_no
           FROM inst_term@grass a, stud_crse_year b
          WHERE TRUNC ((l_withdraw_d)) BETWEEN TRUNC (a.start_date)
                                           AND TRUNC (a.end_date)
            AND b.inst_code = a.inst_code
            AND a.session_code = b.session_code
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y';
      ELSE
         l_withdrawterm_no := NULL;
      END IF;
   ELSE
      IF l_withdraw_d <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
      THEN
         SELECT a.term_no
           INTO l_withdrawterm_no
           FROM crse_term@grass a, stud_crse_year b
          WHERE TRUNC ((l_withdraw_d)) BETWEEN TRUNC (a.start_date)
                                           AND TRUNC (a.end_date)
            AND a.crse_year_id = b.crse_year_id
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y';
      ELSE
         l_withdrawterm_no := NULL;
      END IF;
   END IF;

   RETURN l_withdrawterm_no;
END getwithdrawelterm;

  
FUNCTION getstudystartterm (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN NUMBER
IS
   l_studystart       DATE;
   l_studystartterm   NUMBER;
   l_default_term     CHAR (1)   := '';
BEGIN
   SELECT NVL (scy.start_date, TO_DATE ('01-JAN-1900', 'DD-MM-YYYY'))
     INTO l_studystart
     FROM stud_crse_year scy
    WHERE scy.stud_ref_no = p_stud_ref_no
      AND scy.session_code = p_session_code
      AND scy.latest_crse_ind = 'Y';

   l_default_term := check_default_terms (p_stud_ref_no, p_session_code);

   IF l_default_term = 'Y'
   THEN
      IF l_studystart <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
      THEN
         SELECT a.term_no
           INTO l_studystartterm
           FROM inst_term@grass a, stud_crse_year b
          WHERE TRUNC ((l_studystart)) BETWEEN TRUNC (a.start_date - 1)
                                           AND TRUNC (a.end_date + 1)
            AND b.inst_code = a.inst_code
            AND a.session_code = b.session_code
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y';
      ELSE
         l_studystartterm := NULL;
      END IF;
   ELSE
      IF l_studystart <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
      THEN
         SELECT a.term_no
           INTO l_studystartterm
           FROM crse_term@grass a, stud_crse_year b
          WHERE TRUNC ((l_studystart)) BETWEEN TRUNC (a.start_date - 1)
                                           AND TRUNC (a.end_date + 1)
            AND a.crse_year_id = b.crse_year_id
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y';
      ELSE
         l_studystartterm := NULL;
      END IF;
   END IF;

   RETURN l_studystartterm;
END getstudystartterm;



/* Formatted on 2009/01/22 14:33 (Formatter Plus v4.8.8) */
FUNCTION check_ben1_exists (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN CHAR
IS
   CURSOR ben_exists
   IS
      SELECT 'Y'
        FROM stud_session ss
       WHERE ss.stud_ref_no = p_stud_ref_no
         AND ss.session_code = p_session_code
         AND ss.ben1_id IS NOT NULL;

   l_result   CHAR (1) := 'N';
BEGIN
   OPEN ben_exists;

   FETCH ben_exists
    INTO l_result;

   CLOSE ben_exists;

   RETURN l_result;
END check_ben1_exists;
   
/* Formatted on 2009/01/22 14:33 (Formatter Plus v4.8.8) */
FUNCTION check_ben2_exists (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN CHAR
IS
   CURSOR ben_exists
   IS
      SELECT 'Y'
        FROM stud_session ss
       WHERE ss.stud_ref_no = p_stud_ref_no
         AND ss.session_code = p_session_code
         AND ss.ben2_id IS NOT NULL;

   l_result   CHAR (1) := 'N';
BEGIN
   OPEN ben_exists;

   FETCH ben_exists
    INTO l_result;

   CLOSE ben_exists;

   RETURN l_result;
END check_ben2_exists;
   
/* Formatted on 2009/01/20 10:25 (Formatter Plus v4.8.8) */
   -- 1.1 - Paul Hughes. 23.07.08 - Add Brackets to the Address restictions

/* Formatted on 2009/01/22 14:34 (Formatter Plus v4.8.8) */
FUNCTION get_missingben1data (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN CHAR
IS
   CURSOR ben1missingdata
   IS
      SELECT 'Y'
        FROM benefactor a, stud_session b
       WHERE b.ben1_id = a.ben_id
         AND b.stud_ref_no = p_stud_ref_no
         AND b.session_code = p_session_code
         AND (   a.house_no_name = 'X'
              OR a.addr_l1 = 'X'
              OR a.title = 'X'
              OR a.post_code = 'X'
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
    
/* Formatted on 2009/01/22 14:34 (Formatter Plus v4.8.8) */
FUNCTION get_missingben2data (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN CHAR
IS
   -- 1.1 - Paul Hughes. 23.07.08 - Add Brackets to the Address restictions
   CURSOR ben2missingdata
   IS
      SELECT 'Y'
        FROM benefactor a, stud_session b
       WHERE b.ben2_id = a.ben_id
         AND b.stud_ref_no = p_stud_ref_no
         AND b.session_code = p_session_code
         AND (   a.house_no_name = 'X'
              OR a.addr_l1 = 'X'
              OR a.title = 'X'
              OR a.post_code = 'X'
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

/* Formatted on 2009/01/20 10:26 (Formatter Plus v4.8.8) */
FUNCTION no_of_dependant_children (
   p_stud_ref_no    IN   NUMBER,
   p_session_code   IN   NUMBER
)
   RETURN CHAR
IS
   l_dep1count   NUMBER := 0;
   l_dep2count   NUMBER := 0;
   l_totaldeps   NUMBER := 0;

BEGIN
   SELECT COUNT (ss.stud_ref_no)
     INTO l_dep1count
     FROM benefactor_dependant bd, stud_session ss
    WHERE bd.ben_id = ss.ben1_id
      AND ss.stud_ref_no = p_stud_ref_no
      AND ss.session_code = p_session_code
      AND bd.dependant_type = 'C';

   SELECT COUNT (ss.stud_ref_no)
     INTO l_dep2count
     FROM benefactor_dependant bd, stud_session ss
    WHERE bd.ben_id = ss.ben2_id
      AND ss.stud_ref_no = p_stud_ref_no
      AND ss.session_code = p_session_code
      AND bd.dependant_type = 'C';

   l_totaldeps := l_dep1count + l_dep2count;
   RETURN l_totaldeps;
END no_of_dependant_children;
    
/* Formatted on 2009/01/20 10:25 (Formatter Plus v4.8.8) */
FUNCTION get_ben_income (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN NUMBER
IS
   CURSOR c_ben1_income
   IS
      SELECT bi.bank_interest, bi.benefit, bi.other_income,
             bi.nat_saving_interest, bi.paye_income, bi.pension,
             bi.self_employment, bi.property, bi.dividend, bi.other_deduct, BI.WORKING_TAX_CREDIT
        FROM stud_session ss, benefactor_income bi
       WHERE bi.ben_id = ss.ben1_id
         AND ss.stud_ref_no = p_stud_ref_no
         AND ss.session_code = p_session_code;

   CURSOR c_ben2_income
   IS
      SELECT bi.bank_interest, bi.benefit, bi.other_income,
             bi.nat_saving_interest, bi.paye_income, bi.pension,
             bi.self_employment, bi.property, bi.dividend, bi.other_deduct, BI.WORKING_TAX_CREDIT
        FROM stud_session ss, benefactor_income bi
       WHERE bi.ben_id = ss.ben2_id
         AND ss.stud_ref_no = p_stud_ref_no
         AND ss.session_code = p_session_code;

   l_ben1_exists       CHAR (1);
   l_ben2_exists       CHAR (1);
   l_ben1_has_income   BOOLEAN                 := FALSE;
   l_ben2_has_income   BOOLEAN                 := FALSE;
   l_ben1_income_rec   c_ben1_income%ROWTYPE;
   l_ben2_income_rec   c_ben2_income%ROWTYPE;
   l_ben1_income       NUMBER                  := 0;
   l_ben2_income       NUMBER                  := 0;
BEGIN
   l_ben1_exists := check_ben1_exists (p_stud_ref_no, p_session_code);
   l_ben2_exists := check_ben2_exists (p_stud_ref_no, p_session_code);

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
  

/* Formatted on 2009/01/16 14:50 (Formatter Plus v4.8.8) */
FUNCTION prev_session_bursary (
   p_stud_ref_no    IN   NUMBER,
   p_session_code   IN   NUMBER
)

--Prev_session_bursary is set to 'Y' where student was entitled to any bursary award at the start of there most recent period of study.
   RETURN CHAR
IS
   CURSOR c_pay_ysb_steps (c_commence_session IN NUMBER)
   IS
      SELECT NVL (scy.pay_ysb, 'N')
        FROM stud_crse_year scy
       WHERE scy.stud_ref_no = p_stud_ref_no
         AND scy.session_code = c_commence_session
         AND scy.latest_crse_ind = 'Y';

   CURSOR c_pay_ysb_grass (c_commence_session IN NUMBER)
   IS
      SELECT NVL (scy.pay_ysb, 'N')
        FROM stud_crse_year@grass scy
       WHERE scy.stud_ref_no = p_stud_ref_no
         AND scy.session_code = c_commence_session
         AND scy.latest_crse_ind = 'Y';

   CURSOR c_commence_session
   IS
      SELECT MAX (st.commence_session)
        FROM stud st
       WHERE st.stud_ref_no = p_stud_ref_no;

   CURSOR c_grass_ben1_rel_id (c_commence_session IN NUMBER)
   IS
      SELECT NVL (ssg.ben1_rel_id, 0)
        FROM stud_session@grass ssg
       WHERE ssg.stud_ref_no = p_stud_ref_no
         AND ssg.session_code = c_commence_session;

   CURSOR c_steps_ben1_rel_id (c_commence_session IN NUMBER)
   IS
      SELECT NVL (ssg.ben1_rel_id, 0)
        FROM stud_session ssg
       WHERE ssg.stud_ref_no = p_stud_ref_no
         AND ssg.session_code = c_commence_session;

   --
   l_pay_ysb            CHAR;
   l_has_ben1           CHAR;
   l_grass_ben1_relid   NUMBER;
   l_commence_year      NUMBER;
   l_psb                CHAR   := 'N';
   v_psb                CHAR   := 'N';
BEGIN
   -- If the student is new, there is no previous session bursary
   OPEN c_commence_session;

   FETCH c_commence_session
    INTO l_commence_year;

   CLOSE c_commence_session;

   IF l_commence_year IS NOT NULL AND l_commence_year = p_session_code
   THEN
      RETURN l_psb;
   END IF;

   IF l_commence_year < steps_release_year 
   THEN
      --
      -- If there is first benefactor get its rel type from GRASS
      OPEN c_grass_ben1_rel_id (l_commence_year);

      FETCH c_grass_ben1_rel_id
       INTO l_grass_ben1_relid;

      CLOSE c_grass_ben1_rel_id;
   ELSE
      OPEN c_steps_ben1_rel_id (l_commence_year);

      FETCH c_steps_ben1_rel_id
       INTO l_grass_ben1_relid;

      CLOSE c_steps_ben1_rel_id;
   END IF;

   CASE
      WHEN l_grass_ben1_relid = 0
      THEN
         --
         -- Check pay_ysb from stud_crse_year
         IF l_commence_year < steps_release_year
         THEN
            OPEN c_pay_ysb_grass (l_commence_year);

            FETCH c_pay_ysb_grass
             INTO l_pay_ysb;

            CLOSE c_pay_ysb_grass;
         ELSE
            OPEN c_pay_ysb_steps (l_commence_year);

            FETCH c_pay_ysb_steps
             INTO l_pay_ysb;

            CLOSE c_pay_ysb_steps;

            CASE
               WHEN l_pay_ysb = 'Y'
               THEN
                  l_psb := 'Y';
               WHEN l_pay_ysb = 'N'
               THEN
                  l_psb := 'N';
                  RETURN l_psb;
            END CASE;
         END IF;
      WHEN l_grass_ben1_relid = 28 AND l_pay_ysb = 'N'
      THEN
         l_psb := 'N';
      ELSE
         l_psb := 'Y';
   END CASE;

   RETURN l_psb;
END prev_session_bursary;  
   
 /* Formatted on 2009/01/16 14:50 (Formatter Plus v4.8.8) */
FUNCTION get_payment_dates (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN all_payment_cursor_type
IS
   l_max_term_no        NUMBER                  := NULL;
   l_max_term_default   NUMBER                  := NULL;
   l_session_code       NUMBER;
   l_stud_ref_no        NUMBER;
   l_default_term       CHAR (1)                := '';
   dates_cursor         all_payment_cursor_type;
BEGIN
   l_default_term := check_default_terms (p_stud_ref_no, p_session_code);

   IF l_default_term = 'Y'
   THEN
      l_max_term_default :=
                         get_max_term_default (p_stud_ref_no, p_session_code);

      OPEN dates_cursor FOR
         SELECT   payment_date
             FROM payment_dates@grass
            WHERE payment_date >=
                     (SELECT inst.start_date
                        FROM inst_term@grass inst, stud_crse_year scy
                       WHERE scy.inst_code = inst.inst_code
                         AND inst.session_code = p_session_code
                         AND inst.term_no = 1
                         AND scy.latest_crse_ind = 'Y'
                         AND scy.stud_ref_no = p_stud_ref_no)
              AND payment_date <=
                     (SELECT inst.end_date
                        FROM inst_term@grass inst, stud_crse_year scy
                       WHERE scy.inst_code = inst.inst_code
                         AND inst.session_code = p_session_code
                         AND inst.term_no = l_max_term_default
                         AND scy.latest_crse_ind = 'Y'
                         AND scy.stud_ref_no = p_stud_ref_no)
         ORDER BY payment_date;
   ELSE
      l_max_term_no := get_max_term_no (p_stud_ref_no, p_session_code);

      -- Get the payment dates for relevant student session dates
      OPEN dates_cursor FOR
         SELECT   payment_date
             FROM payment_dates@grass
            WHERE payment_date >=
                     (SELECT a.start_date
                        FROM crse_term@grass a, stud_crse_year b
                       WHERE a.crse_year_id = b.crse_year_id
                         AND a.term_no = 1
                         AND b.session_code = p_session_code
                         AND b.stud_ref_no = p_stud_ref_no
                         AND b.latest_crse_ind = 'Y')
              AND payment_date <=
                     (SELECT a.end_date
                        FROM crse_term@grass a, stud_crse_year b
                       WHERE a.crse_year_id = b.crse_year_id
                         AND b.session_code = p_session_code
                         AND b.stud_ref_no = p_stud_ref_no
                         AND a.term_no = l_max_term_no
                         AND b.latest_crse_ind = 'Y')
         ORDER BY payment_date;
   END IF;

   RETURN dates_cursor;
END get_payment_dates;
    
/* Formatted on 2009/01/16 14:50 (Formatter Plus v4.8.8) */
FUNCTION get_startdates (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN startdates_cursor_type
IS
   l_max_term_no        NUMBER                 := NULL;
   l_max_term_default   NUMBER                 := NULL;
   l_session_code       NUMBER;
   l_stud_ref_no        NUMBER;
   l_default_term       CHAR (1)               := '';
   startdates_cursor    startdates_cursor_type;
BEGIN
   l_default_term := check_default_terms (p_stud_ref_no, p_session_code);

   IF l_default_term = 'Y'
   THEN
      l_max_term_default :=
                         get_max_term_default (p_stud_ref_no, p_session_code);

      OPEN startdates_cursor FOR
         SELECT a.start_date
           FROM inst_term@grass a, stud_crse_year b
          WHERE a.inst_code = b.inst_code
            AND a.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y'
            AND a.term_no <= l_max_term_default;
   ELSE
      l_max_term_no := get_max_term_no (p_stud_ref_no, p_session_code);

      OPEN startdates_cursor FOR
         SELECT a.start_date
           FROM crse_term@grass a, stud_crse_year b
          WHERE a.crse_year_id = b.crse_year_id
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y'
            AND a.term_no <= l_max_term_no;
   END IF;

   RETURN startdates_cursor;
END get_startdates;
    
/* Formatted on 2009/01/16 14:50 (Formatter Plus v4.8.8) */
FUNCTION get_termdays (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN termdays_cursor_type
IS
   l_max_term_no        NUMBER               := NULL;
   l_max_term_default   NUMBER               := NULL;
   l_session_code       NUMBER;
   l_stud_ref_no        NUMBER;
   l_default_term       CHAR (1)             := '';
   termdays_cursor      termdays_cursor_type;
BEGIN
   l_default_term := check_default_terms (p_stud_ref_no, p_session_code);

   IF l_default_term = 'Y'
   THEN
      l_max_term_default :=
                         get_max_term_default (p_stud_ref_no, p_session_code);

      OPEN termdays_cursor FOR
         SELECT a.days
           FROM inst_term@grass a, stud_crse_year b
          WHERE a.inst_code = b.inst_code
            AND a.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y'
            AND a.term_no <= l_max_term_default;
   ELSE
      l_max_term_no := get_max_term_no (p_stud_ref_no, p_session_code);

      OPEN termdays_cursor FOR
         SELECT a.days
           FROM crse_term@grass a, stud_crse_year b
          WHERE a.crse_year_id = b.crse_year_id
            AND b.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y'
            AND a.term_no <= l_max_term_no;
   END IF;

   RETURN termdays_cursor;
END get_termdays;
    
/* Formatted on 2009/01/16 14:50 (Formatter Plus v4.8.8) */
FUNCTION count_payment_dates (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN NUMBER
IS
   l_max_term_no          NUMBER   := NULL;
   l_max_term_default     NUMBER   := 0;
   l_payment_date_count   NUMBER   := NULL;
   l_default_term         CHAR (1) := '';
BEGIN
   l_default_term := check_default_terms (p_stud_ref_no, p_session_code);

   IF l_default_term = 'Y'
   THEN
      l_max_term_default :=
                         get_max_term_default (p_stud_ref_no, p_session_code);

      SELECT COUNT (payment_date)
        INTO l_payment_date_count
        FROM payment_dates@grass
       WHERE payment_date >=
                (SELECT a.start_date
                   FROM inst_term@grass a, stud_crse_year b
                  WHERE a.session_code = b.session_code
                    AND b.stud_ref_no = p_stud_ref_no
                    AND b.inst_code = a.inst_code
                    AND b.latest_crse_ind = 'Y'
                    AND a.term_no = 1)
         AND payment_date <=
                (SELECT a.end_date
                   FROM inst_term@grass a, stud_crse_year b
                  WHERE a.session_code = b.session_code
                    AND b.stud_ref_no = p_stud_ref_no
                    AND b.inst_code = a.inst_code
                    AND b.latest_crse_ind = 'Y'
                    AND a.term_no = l_max_term_default);

      RETURN l_payment_date_count;
   ELSE
      l_max_term_no := get_max_term_no (p_stud_ref_no, p_session_code);

      SELECT COUNT (payment_date)
        INTO l_payment_date_count
        FROM payment_dates@grass
       WHERE payment_date >=
                (SELECT a.start_date
                   FROM crse_term@grass a, stud_crse_year b
                  WHERE a.crse_year_id = b.crse_year_id
                    AND a.term_no = 1
                    AND b.session_code = p_session_code
                    AND b.stud_ref_no = p_stud_ref_no
                    AND b.latest_crse_ind = 'Y')
         AND payment_date <=
                (SELECT a.end_date
                   FROM crse_term@grass a, stud_crse_year b
                  WHERE a.crse_year_id = b.crse_year_id
                    AND b.session_code = p_session_code
                    AND b.stud_ref_no = p_stud_ref_no
                    AND a.term_no = l_max_term_no
                    AND b.latest_crse_ind = 'Y');

      RETURN l_payment_date_count;
   END IF;
END count_payment_dates;
    
   
/* Formatted on 2009/01/16 14:50 (Formatter Plus v4.8.8) */
FUNCTION triplepayment_flag (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN NUMBER
IS
   l_max_term_no          NUMBER   := NULL;
   l_max_term_default     NUMBER   := NULL;
   l_session_code         NUMBER;
   l_stud_ref_no          NUMBER;
   l_default_term         CHAR (1) := '';
   l_triplepayment_flag   NUMBER   := NULL;
BEGIN
   l_default_term := check_default_terms (p_stud_ref_no, p_session_code);

   IF l_default_term = 'Y'
   THEN
      l_max_term_default :=
                         get_max_term_default (p_stud_ref_no, p_session_code);

      SELECT COUNT (payment_date)
        INTO l_triplepayment_flag
        FROM payment_dates@grass
       WHERE payment_date =
                (SELECT inst.start_date
                   FROM inst_term@grass inst, stud_crse_year scy
                  WHERE scy.inst_code = inst.inst_code
                    AND inst.session_code = p_session_code
                    AND inst.term_no = 1
                    AND scy.latest_crse_ind = 'Y'
                    AND scy.stud_ref_no = p_stud_ref_no);
   ELSE
      l_max_term_no := get_max_term_no (p_stud_ref_no, p_session_code);

      SELECT COUNT (payment_date)
        INTO l_triplepayment_flag
        FROM payment_dates@grass
       WHERE payment_date =
                (SELECT a.start_date
                   FROM crse_term@grass a, stud_crse_year b
                  WHERE a.crse_year_id = b.crse_year_id
                    AND a.term_no = 1
                    AND b.session_code = p_session_code
                    AND b.stud_ref_no = p_stud_ref_no
                    AND b.latest_crse_ind = 'Y');
   END IF;

   RETURN l_triplepayment_flag;
END;
    
/* Formatted on 2009/01/16 14:50 (Formatter Plus v4.8.8) */
FUNCTION count_awards (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN NUMBER
IS
   l_total_awards   NUMBER := NULL;
BEGIN
   SELECT COUNT (award_id)
     INTO l_total_awards
     FROM award
    WHERE stud_ref_no = p_stud_ref_no AND session_code = p_session_code;

   RETURN l_total_awards;
END count_awards; 
    
/* Formatted on 2009/01/16 14:51 (Formatter Plus v4.8.8) */
FUNCTION getfeespaidamount (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN NUMBER
IS
   l_fees_paid_amount   NUMBER := 0;
BEGIN
   SELECT NVL (SUM (b.net_amount), 0)
     INTO l_fees_paid_amount
     FROM award a, award_instalment b
    WHERE a.award_id = b.award_id
      AND a.award_src = 'T'
      AND b.payment_status IS NULL
      AND a.session_code = p_session_code
      AND a.stud_ref_no = p_stud_ref_no;

   RETURN l_fees_paid_amount;
END getfeespaidamount;
     
/* Formatted on 2009/01/16 14:51 (Formatter Plus v4.8.8) */
FUNCTION getattendfeecutoffdate (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN CHAR
IS
   l_attendfeecutoff   CHAR (1) := '';
   l_start             DATE;
   l_withdraw          DATE;
   l_cutoff            DATE;
BEGIN
   SELECT NVL (scy.start_date, TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')),
          NVL (scy.withdraw_date, TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')),
          NVL (cy.cutoff_date, TO_DATE ('01-JAN-1900', 'DD-MM-YYYY'))
     INTO l_start,
          l_withdraw,
          l_cutoff
     FROM stud_crse_year scy, crse_year cy
    WHERE scy.crse_year_id = cy.crse_year_id
      AND scy.stud_ref_no = p_stud_ref_no
      AND scy.session_code = p_session_code
      AND scy.latest_crse_ind = 'Y';

   IF     l_start = TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
      AND l_withdraw <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
      AND l_cutoff <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
   THEN
      IF l_withdraw >= l_cutoff
      THEN
         l_attendfeecutoff := 'Y';
      ELSE
         l_attendfeecutoff := 'N';
      END IF;
   ELSIF     l_start <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
         AND l_withdraw = TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
         AND l_cutoff <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
   THEN
      IF l_start > l_cutoff
      THEN
         l_attendfeecutoff := 'N';
      ELSE
         l_attendfeecutoff := 'Y';
      END IF;
   ELSIF     l_start <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
         AND l_withdraw <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
         AND l_cutoff = TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
   THEN
      l_attendfeecutoff := 'N';
   ELSIF     l_start <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
         AND l_withdraw <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
         AND l_cutoff <> TO_DATE ('01-JAN-1900', 'DD-MM-YYYY')
   THEN
      IF l_start < l_cutoff AND l_withdraw < l_cutoff
      THEN
         l_attendfeecutoff := 'N';
      ELSIF l_start < l_cutoff AND l_withdraw >= l_cutoff
      THEN
         l_attendfeecutoff := 'Y';
      ELSIF l_start > l_cutoff AND l_withdraw > l_cutoff
      THEN
         l_attendfeecutoff := 'N';
      ELSIF l_start = l_cutoff AND l_withdraw > l_cutoff
      THEN
         l_attendfeecutoff := 'Y';
      END IF;
   END IF;

   RETURN l_attendfeecutoff;
END getattendfeecutoffdate;

FUNCTION get_stud_age (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER
IS

    l_studAge   NUMBER := 0;
    l_startYear NUMBER := 0;
    
    BEGIN
    
    l_startYear := get_start_year (p_stud_ref_no, p_session_code);
    
    SELECT( 
            SELECT FLOOR( (MONTHS_BETWEEN (TO_DATE (CONCAT ('01-AUG-',l_startYear),'DD/MM/YYYY'),a.dob)/ 12))
                  FROM DUAL) AS DOB
                  INTO l_studAge
                  FROM STUD a
             WHERE a.stud_ref_no = p_stud_ref_no;              
             RETURN l_studAge;
   END get_stud_age;
  
   

FUNCTION get_start_year (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER
IS

    l_startYear     NUMBER := 0;
    l_crse_code     CHAR(8) := 'x';
    l_inst_code     CHAR(8) := 'x';
    
    BEGIN
    

        SELECT inst_code, crse_code INTO l_crse_code, l_inst_code
        FROM stud_crse_year
        WHERE stud_ref_no = p_stud_ref_no
        AND session_code = p_session_code
        AND latest_crse_ind = 'Y';
    
    SELECT   MIN(iv1.session_code) AS MINSESSION 
                 INTO l_startYear
             FROM (SELECT NVL (TO_NUMBER (y.session_code), p_session_code) session_code
                     FROM stud_crse_year@grass y
                    WHERE y.stud_ref_no = p_stud_ref_no
                      AND y.latest_crse_ind = 'Y'
                      AND y.inst_code = l_inst_code
                      AND y.crse_code = l_crse_code
                      UNION
                   SELECT NVL (TO_NUMBER (y.session_code), p_session_code) session_code
                     FROM sgas.stud_crse_year y
                    WHERE y.stud_ref_no = p_stud_ref_no
                      AND y.latest_crse_ind = 'Y'
                      AND y.inst_code = l_inst_code
                      AND y.crse_code = l_crse_code
                   UNION
                   SELECT p_session_code
                     FROM DUAL) iv1;
        
        RETURN l_startYear;
    
    
    END get_start_year;





          
PROCEDURE stud_type_doc (
   p_stud_ref_no    IN       NUMBER,
   p_session_code   IN       NUMBER,
   p_stud_type      IN OUT   stud_type_cursor
)
IS
BEGIN
   OPEN p_stud_type FOR
      SELECT a.location_ind, c.commence_session,
            -- DECODE (d.crse_code, 'PART', 'Y', 'N') AS partime,
             DECODE(b.pgce, NULL, 'N', B.PGCE) AS pgce,
             d.scheme_type
        FROM inst@grass a, sgas.stud_crse_year b, sgas.stud c, crse@grass d, crse_year@grass e, crse_session@grass f
         WHERE c.stud_ref_no = b.stud_ref_no
         AND b.crse_year_id = e.crse_year_id
         AND e.crse_session_id = f.crse_session_id
         AND f.crse_id = d.crse_id
         AND d.inst_code = a.inst_code
         AND b.stud_ref_no = p_stud_ref_no
         AND b.latest_crse_ind = 'Y'
         AND b.session_code = p_session_code;
END stud_type_doc;
   
   
/* Formatted on 2008/03/28 10:39 (Formatter Plus v4.8.8) */
/* Formatted on 2009/01/16 14:51 (Formatter Plus v4.8.8) */
PROCEDURE bursary_doc (
   p_stud_ref_no    IN       NUMBER,
   p_session_code   IN       NUMBER,
   p_bursary_type   IN OUT   bursary_type_cursor
)
IS
   l_ben_income       NUMBER;
   l_prev_bursary     CHAR (1);
   l_ben1missing      CHAR (1);
   l_ben2missing      CHAR (1);
   l_studystartterm   NUMBER;
BEGIN
   l_ben_income := NVL (get_ben_income (p_stud_ref_no, p_session_code), 0);
   l_prev_bursary :=
                NVL (prev_session_bursary (p_stud_ref_no, p_session_code), 0);
   l_ben1missing := get_missingben1data (p_stud_ref_no, p_session_code);
   l_ben2missing := get_missingben2data (p_stud_ref_no, p_session_code);
   --l_studystartterm := sgas.rules_proc_recalc.getstudystartterm (p_stud_ref_no, p_session_code);

   OPEN p_bursary_type FOR
      SELECT l_ben_income AS netbenefactorincome,
             l_prev_bursary AS prev_bursary,
             DECODE (scy.pay_ysb, NULL, 'N', scy.pay_ysb) pay_ysb,
             ss.ben1_rel_id,
             CASE
                WHEN (scy.paid_sandwich = 'Y')
                 OR (crs.pams_course = 'Y')
                 OR (    scy.parent_contrib_exempt = 'N'
                     AND scy.calc_bursary = 'Y'
                     AND ss.ben1_rel_id IS NULL
                    )
                   THEN 'N'
                WHEN l_ben1missing = 'Y' OR l_ben2missing = 'Y'
                   THEN 'N'
                WHEN scy.award = 'C'
                   THEN 'N'
                ELSE (scy.calc_bursary)
             END calculatebursary,
             sgas.rules_proc_recalc.getstudystartterm(scy.stud_crse_year_id) AS studystartterm,
             scy.parent_contrib_exempt AS exemptfromcont, SS.BURSARY_DEDUCTION
        FROM stud_crse_year scy,
             stud_session ss,
             crse@grass crs,
             crse_session@grass crss,
             crse_year@grass cy
       WHERE ss.session_code = p_session_code
         AND ss.stud_ref_no = p_stud_ref_no
         AND ss.stud_session_id = scy.stud_session_id
         AND crss.crse_id = crs.crse_id
         AND scy.latest_crse_ind = 'Y'
         AND cy.crse_session_id = crss.crse_session_id
         AND scy.crse_year_id = cy.crse_year_id;
END bursary_doc;

/* Formatted on 2008/03/28 10:38 (Formatter Plus v4.8.8) */

/* Formatted on 2009/01/16 14:51 (Formatter Plus v4.8.8) */
PROCEDURE income_assessment_doc (
   p_stud_ref_no              IN       NUMBER,
   p_session_code             IN       NUMBER,
   p_income_assessment_type   IN OUT   income_assessment_cursor
)
IS
   l_totaldeps          NUMBER;
   l_total_income       NUMBER;
   l_courselength       NUMBER;
 --  l_daysinattendance   NUMBER;
BEGIN
   l_total_income := get_ben_income (p_stud_ref_no, p_session_code);
   l_totaldeps := no_of_dependant_children (p_stud_ref_no, p_session_code);
   l_courselength := get_courselength (p_stud_ref_no, p_session_code);
  -- l_daysinattendance := sgas.rules_proc_recalc.daysinattendance (p_stud_ref_no, p_session_code);

   OPEN p_income_assessment_type FOR
      SELECT ss.net_income, ss.trust_income, ss.pension_income,
             NVL (ss.ja_stud_type, '') AS ja_stud_type,
            -- TO_CHAR (st.dob, 'DD-MON-YYYY') AS dob,
            scy.parent_contrib_exempt,
             NVL (ss.ja_case, 'N') AS ja_case,
           --  CONCAT ('01-AUG-', ss.session_code) academicyear,
             l_totaldeps AS nodependantchildren, ss.ben1_rel_id,
             l_total_income AS netbenefactorincome,
             DECODE (l_totaldeps, 0, 'N', 'Y') AS anydependantchildren,
               NVL (ja.no_non_saas_children, 0)
             + NVL (ja.no_non_saas_parents, 0)
             + NVL (ja.no_saas_students, 0) noofsharingstudents,
             scy.loan_given,
             DECODE (scy.withdraw_date, NULL, 'N', 'Y') AS withdrawalyn,
             l_courselength AS daysincourse,
             DECODE (scy.start_date, NULL, 'N', 'Y') AS studystartyn,
             scy.withdraw_date, scy.start_date,
             SGAS.RULES_PROC_RECALC.daysinattendance(scy.stud_crse_year_id) AS daysinattendance, NVL(SS.WORKING_TAX_CREDIT,0)
        FROM stud_session ss, stud st, ja_case ja, stud_crse_year scy
       WHERE ss.stud_ref_no = p_stud_ref_no
         AND ss.session_code = p_session_code
         AND ss.stud_ref_no = st.stud_ref_no
         AND scy.stud_session_id = ss.stud_session_id
         AND scy.latest_crse_ind = 'Y'
         AND st.stud_ref_no = ss.stud_ref_no
         AND ja.ja_case_id(+) = ss.ja_case_id;
END income_assessment_doc;  
  
/* Formatted on 2009/01/16 14:51 (Formatter Plus v4.8.8) */
PROCEDURE loans_doc (
   p_stud_ref_no    IN       NUMBER,
   p_session_code   IN       NUMBER,
   p_loans_type     IN OUT   loans_cursor
)
IS
   l_final_year     CHAR (1);
   l_courselength   NUMBER;
   l_age            NUMBER;
   l_ben1missing    CHAR (1);
   l_ben2missing    CHAR (1);
   l_abroad_days_in_term NUMBER;
   
   
BEGIN
   l_final_year := final_year_check (p_stud_ref_no, p_session_code);
   l_courselength := get_courselength (p_stud_ref_no, p_session_code);
   l_ben1missing := get_missingben1data (p_stud_ref_no, p_session_code);
   l_ben2missing := get_missingben2data (p_stud_ref_no, p_session_code);
   l_abroad_days_in_term := get_abroad_days_in_term (p_stud_ref_no, p_session_code); 

   OPEN p_loans_type FOR
      SELECT CASE
                WHEN scy.award IN ('A', 'C', 'D')
                   THEN 'Y'
                WHEN l_ben1missing = 'Y' OR l_ben2missing = 'Y'
                   THEN 'Y'
                ELSE 'N'
             END nmtonly,
             ss.loan_request, ss.max_loan_requested,
             DECODE (scy.study_abroad,
                     'Y', c.new_category,
                     sta.location_ind
                    ) locationtype,
             DECODE (scy.paid_sandwich,
                     NULL, 'N',
                     scy.paid_sandwich
                    ) paidplacement,
             scy.calc_loan AS calcloan, crs.pams_course AS ahpstud,
             l_final_year AS finalyear, l_courselength AS courselength,
             scy.assess_loan, SCY.CALC_SMA,
             CASE
                WHEN DECODE(scy.study_abroad,'Y', c.new_category,sta.location_ind) IN ('1','2','3')
                    THEN STA.LOCATION_IND
                    ELSE
                    DECODE(scy.study_abroad,'Y', c.new_category,sta.location_ind)
                END home_location_type, l_abroad_days_in_term AS term_days_abroad, l_courselength AS abroad_course_length
        FROM stud_crse_year scy,
             stud_session ss,
             country@grass c,
             stud_term_addr sta,
             crse@grass crs,
             crse_session@grass cs,
             crse_year@grass cy
       WHERE ss.stud_session_id = scy.stud_session_id
         AND ss.stud_ref_no = p_stud_ref_no
         AND ss.session_code = p_session_code
         AND c.country_code(+) = scy.study_country
         AND crs.crse_id = cs.crse_id
         AND cy.crse_session_id = cs.crse_session_id
         AND scy.crse_year_id = cy.crse_year_id
         AND scy.latest_crse_ind = 'Y'
         AND sta.stud_ref_no = ss.stud_ref_no;
END loans_doc;
   
/* Formatted on 2009/01/16 14:51 (Formatter Plus v4.8.8) */
PROCEDURE fees_doc (
   p_stud_ref_no    IN       NUMBER,
   p_session_code   IN       NUMBER,
   p_fees_type      IN OUT   fees_cursor
)
IS
   l_withdrawterm_no    NUMBER;
   l_fees_paid_amount   NUMBER;
   l_attendfeecutoff    CHAR;
BEGIN
   l_withdrawterm_no := getwithdrawelterm (p_stud_ref_no, p_session_code);
   l_fees_paid_amount := getfeespaidamount (p_stud_ref_no, p_session_code);
   l_attendfeecutoff :=
                       getattendfeecutoffdate (p_stud_ref_no, p_session_code);

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
             ss.max_fee_loan_requested, l_withdrawterm_no AS withdrawelterm,
             l_fees_paid_amount AS fees_paid_amount, SS.FEE_LOAN_CHARGED, SCY.PSAS_PT,
             CASE
                WHEN scy.start_date IS NULL
                AND scy.withdraw_date IS NULL
                AND cy.cutoff_date IS NULL
                   THEN 'Y'
                WHEN scy.start_date IS NULL
                AND scy.withdraw_date IS NULL
                AND cy.cutoff_date IS NOT NULL
                   THEN 'Y'
                WHEN scy.start_date IS NULL
                AND scy.withdraw_date IS NOT NULL
                AND cy.cutoff_date IS NULL
                   THEN 'N'
                WHEN scy.start_date IS NOT NULL
                AND scy.withdraw_date IS NULL
                AND cy.cutoff_date IS NULL
                   THEN 'N'
                ELSE l_attendfeecutoff
             END attendfeecutoff
        FROM stud_crse_year scy,
             stud_session ss,
             crse@grass c,
             crse_session@grass cs,
             crse_year@grass cy,
             inst@grass i
       WHERE scy.stud_ref_no = p_stud_ref_no
         AND scy.session_code = p_session_code
         AND c.crse_id = cs.crse_id
         AND cy.crse_session_id = cs.crse_session_id
         AND scy.crse_year_id = cy.crse_year_id
         AND scy.inst_code = i.inst_code
         AND scy.latest_crse_ind = 'Y'
         AND ss.stud_session_id = scy.stud_session_id;
END fees_doc;
   
/* Formatted on 2009/01/16 14:52 (Formatter Plus v4.8.8) */
PROCEDURE supps_doc (
   p_stud_ref_no    IN       NUMBER,
   p_session_code   IN       NUMBER,
   p_supps_type     IN OUT   supps_cursor
)
IS
BEGIN

   OPEN p_supps_type FOR
      SELECT scy.calc_dep_grant, scy.calc_lpg, scy.calc_lpcg,
             NVL (sd.income, 0) AS dependantincome,
             NVL (ss.lpcg_paid_amount, 0) AS lpcg_paid_amount,
             ss.max_lpcg_paid, sd.relation_id
        FROM stud_crse_year scy, stud_dependant sd, stud_session ss
       WHERE scy.stud_ref_no = p_stud_ref_no
         AND scy.session_code = p_session_code
         AND sd.stud_ref_no(+) = scy.stud_ref_no
         AND ss.stud_session_id = scy.stud_session_id
         AND scy.latest_crse_ind = 'Y';
END supps_doc;
   
/* Formatted on 2009/01/16 14:52 (Formatter Plus v4.8.8) */
PROCEDURE calculateawarddoc (
   p_stud_ref_no           IN       NUMBER,
   p_session_code          IN       NUMBER,
   p_calculateaward_type   IN OUT   calculateaward_cursor,
   p_payment_dates         IN OUT   all_payment_cursor_type,
   p_start_dates           IN OUT   startdates_cursor_type,
   p_term_days             IN OUT   termdays_cursor_type,
   p_awards_cursor         IN OUT   all_award_cursor_type
)
IS
   l_number_of_terms       NUMBER := 0;
   l_triplepayment_flag    NUMBER := 0;
   l_count_payment_dates   NUMBER := 0;
   l_count_awards          NUMBER := 0;
   l_ja_studs_reg          NUMBER := 0;
BEGIN
   OPEN p_awards_cursor FOR
      SELECT a.award_id AS award_id,
             DECODE (a.stud_award_type,
                     NULL, TO_CHAR (a.tuition_fee_type_code),
                     a.stud_award_type
                    ) AS stud_award_type
        FROM award a, stud_crse_year cy
       WHERE a.stud_ref_no = p_stud_ref_no
         AND a.session_code = p_session_code
         AND cy.stud_crse_year_id = a.stud_crse_year_id
         AND cy.latest_crse_ind = 'Y';

   l_number_of_terms := number_of_terms (p_stud_ref_no, p_session_code);
   l_triplepayment_flag := triplepayment_flag (p_stud_ref_no, p_session_code);
   l_count_payment_dates :=
                           count_payment_dates (p_stud_ref_no, p_session_code);
   l_count_awards := count_awards (p_stud_ref_no, p_session_code);
   l_ja_studs_reg := get_ja_studs_reg (p_stud_ref_no, p_session_code);

   OPEN p_calculateaward_type FOR
      SELECT scy.stud_crse_year_id, scy.session_code, scy.stud_ref_no,
             scy.crse_id, cs.tuition_fee_type_code, tft.descript,
             scy.crse_year_no, cy.cutoff_date, crs.fees_campus,
             l_number_of_terms AS numberofterms,
             l_triplepayment_flag AS triplepaymentflag,
             l_count_payment_dates AS paymentdatecount, cam.payment_method, --inst.payment_method,    ---THIS MAYBE CHANGED TO USE CAMPUS TABLE.
             scy.award, st.payment_method AS stud_method, cy.semester,
             CASE
                WHEN (l_count_awards > 0)
                   THEN 'D'
                ELSE 'I'
             END assess_reason_code,
             CASE
                WHEN (st.nominee = 'N')
                   THEN 'S'
                ELSE 'N'
             END payee,
             CASE
                WHEN (crs.scheme_type = 'U' AND sta.location_ind = 'H'
                     )
                   THEN 'M'
                ELSE 'T'
             END apportionment_method,  
             CASE
                WHEN (st.payment_method = 'C')
                   THEN 'H'                                                  ----SHOULD CHEQUES BE SENT TO CAMPUS?  OR HOME ADDRESS?  FIRST INSTALMENTS QUESTION
                WHEN (st.payment_method = 'B' AND st.nominee = 'N'        --NOMINEE - THIS MAYBE GETTING CHANGED
                     )
                   THEN 'B'                                                 ----THIS IS STILL TO BE CONFIRMED
                ELSE 'N'
             END payee_addr,
             CASE
                WHEN (scy.dearing = 'G')
                   THEN 'Y'
                ELSE 'N'
             END fee_loan_installment,
             sd.start_date AS stud_dependantstartdate,
             sd.end_date stud_dependantenddate, l_ja_studs_reg AS ja_studs_reg,
             SCY.START_DATE, SCY.WITHDRAW_DATE
        FROM stud_crse_year scy,
             crse_session@grass cs,
             crse_year@grass cy,
             tuition_fee_type@grass tft,
             crse@grass crs,
             stud st,
             inst@grass inst,
             stud_term_addr sta,
             campus@grass cam,
             stud_dependant sd
       WHERE scy.stud_ref_no = p_stud_ref_no
         AND scy.session_code = p_session_code
         AND cs.crse_session_id = cy.crse_session_id
         AND sta.stud_ref_no = st.stud_ref_no
         AND crs.crse_id = cs.crse_id
         AND inst.inst_code = crs.inst_code
         AND cy.crse_year_id = scy.crse_year_id
         AND st.stud_ref_no = scy.stud_ref_no
         AND inst.inst_code = SCY.INST_CODE
         AND crs.fees_campus = cam.campus_id
         AND tft.tuition_fee_type_code(+) = cs.tuition_fee_type_code
         AND sd.stud_session_id(+) = scy.stud_session_id
         AND scy.latest_crse_ind = 'Y';

   p_payment_dates := get_payment_dates (p_stud_ref_no, p_session_code);
   p_start_dates := get_startdates (p_stud_ref_no, p_session_code);
   p_term_days := get_termdays (p_stud_ref_no, p_session_code);
END calculateawarddoc;

/* Formatted on 2009/09/08 16:09 (Formatter Plus v4.8.8) */


PROCEDURE travelElement (
   p_stud_ref_no    IN       NUMBER,
   p_session_code   IN       NUMBER,
   p_travel_type IN OUT   travelElement_cursor
)
IS

l_course_length NUMBER := 0;
l_studAge NUMBER := 0;

BEGIN

    l_course_length :=  get_courselength (p_stud_ref_no , p_session_code);
    l_studAge := get_stud_age (p_stud_ref_no,p_session_code);

   OPEN p_travel_type FOR
      SELECT cy.eu_flag, scy.DEARING, c.PAMS_COURSE, c.QUAL_TYPE, l_course_length AS crseLength, l_studAge AS studAge, c.qual_type
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
         AND scy.latest_crse_ind = 'Y'
         AND scy.stud_ref_no = p_stud_ref_no
         AND scy.session_code = p_session_code;
END travelElement;

 

END rules_proc;
/
