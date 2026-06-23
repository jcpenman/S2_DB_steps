CREATE OR REPLACE PACKAGE BODY SGAS.NMSB_rules_proc
AS
/******************************************************************************
   NAME:       NMSB_RULES_PROC
   PURPOSE:    This package is used in order to supply the Rules service with values in which to calculate the NMSB Student Award

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03.11.2008   Paul Hughes     Created this package body
   1.1        16.01.2009   Paul Hughes     Removed instances of Stud_session table were not required
   1.2        07.04.2009   Paul Hughes     Tidy of Code
   1.3        09.06.2009   Paul Hughes     Added code to calculate age on start of 1st year of course
   1.4        10.06.2009    Paul Hughes     Added code to fix default terms returning wrong number of terms.
   1.5        14.07.2009   Paul Hughes      Amended Function getStartDateofFirstYear to use crse_year_id from either steps/grass database which was returned via 
                                            new function get_firstyear_crse_id, or use the inst_code from the first year of study.  Previously it was failing when using the current
                                            record held in steps for crse_year_id or inst_code which it is required to take these values from GRASSS database.
                                            This involved creating new functions "check_default_StartCourse" and "get_firstInstCode"  and "get_firstyear_crse_id".  Exception code added
   1.6        17.11.2009    Clark Bolan     Added calcNMSB to AssessBursary Procedure        
   1.7        02.12.2009    Paul Hughes     Changed age at start of course so that it takes into account false starts - so counts back number of years of course includes addition
                                            FUNCTION get_StartYearFirstYear           
   1.8        03.12.2009    Paul Hughes     Added new Function get_courselength.    
   1.9        03.12.2009    Clark Bolan     Changed the NVL value for SNB_Single_Rate if no record exixts for sessionCode - 1 to "Y"    
   2.0        04.12.2009    Paul Hughes     Removed FUNCTION get_firstyear_crse_id    
   2.1        06.12.2009    Paul Hughes     Formatted code and general tidy of comments.  Removed redundant FUNCTION get_day1term1_start_date    
   2.2        07.12.2009    Paul Hughes     Added Cursor and Exception handling for no data found to FUNCTION check_default_startcourse      
   2.3        02/02/2010    Paul Hughes     Ammended DaysToBeFunded to return the course length if the recommencement date is added to the database. 
   2.4        24/06/2010    Paul Hughes     Added new Function getNMSB_Maternity
                                          
******************************************************************************/

FUNCTION getEndDateTermNMSBSpec (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
RETURN NUMBER
IS
    l_term      NUMBER := 0;
    l_default_term CHAR(1) := 'N';
    l_end_date  DATE := TO_DATE('01/01/1900','DD/MM/YYYY');
    
 BEGIN
    
        SELECT END_DATE
        INTO l_end_date
        FROM NMSB_SPEC_ARR
        WHERE STUD_REF_NO = p_stud_ref_no
        AND SESSION_CODE = p_session_code;
        
     l_default_term := check_default_terms (p_stud_ref_no, p_session_code);
                               --Check to see if default terms should be used                           

   IF l_default_term = 'Y'
   THEN
      --Look up inst_term table as default terms used.
      SELECT a.term_no
        INTO l_term
        FROM inst_term@grass a, stud_crse_year b
       WHERE b.inst_code = a.inst_code
         AND a.session_code = p_session_code
         AND b.session_code = p_session_code
         AND b.stud_ref_no = p_stud_ref_no
         AND b.latest_crse_ind = 'Y'
         AND TRUNC(a.START_DATE) <= TRUNC(l_end_date)
         AND TRUNC(a.END_DATE) >= TRUNC(l_end_date);
   ELSE
      --Course details set-up so use crse_term table
      
      SELECT a.term_no
        INTO l_term
        FROM crse_term@grass a, stud_crse_year b
       WHERE a.crse_year_id = b.crse_year_id
         AND b.session_code = p_session_code
         AND b.stud_ref_no = p_stud_ref_no
         AND b.latest_crse_ind = 'Y'
         AND TRUNC(a.START_DATE) <= TRUNC(l_end_date)
         AND TRUNC(a.END_DATE) >= TRUNC(l_end_date);
         
   END IF;
    
 RETURN l_term;
 
 END getEndDateTermNMSBSpec;
   


/* Formatted on 2010/06/24 17:07 (Formatter Plus v4.8.8) */
FUNCTION getnmsbpaymentdate (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN DATE
IS
   l_paymentduedate     DATE          := TO_DATE ('01/01/1900', 'DD/MM/YYYY');
   l_end_date           DATE          := TO_DATE ('01/01/1900', 'DD/MM/YYYY');

   CURSOR c_payment_due_date
   IS
   
      SELECT DISTINCT ai.payment_due_date
                 FROM award_instalment ai, award a
                WHERE ai.award_id = a.award_id
                  AND a.stud_ref_no = p_stud_ref_no
                  AND a.session_code = p_session_code
             ORDER BY ai.payment_due_date DESC;

   v_payment_due_date   c_payment_due_date%ROWTYPE;
   
BEGIN

   SELECT end_date
     INTO l_end_date
     FROM nmsb_spec_arr
    WHERE stud_ref_no = p_stud_ref_no AND session_code = p_session_code;

   OPEN c_payment_due_date;

   LOOP
      FETCH c_payment_due_date
       INTO v_payment_due_date;

      IF TRUNC(l_end_date) >= TRUNC(v_payment_due_date.payment_due_date)
      THEN
         l_paymentduedate := v_payment_due_date.payment_due_date;
      END IF;

      EXIT WHEN TRUNC (l_end_date) >= TRUNC (v_payment_due_date.payment_due_date)
                                                            ;
   END LOOP;

   CLOSE c_payment_due_date;

   RETURN l_paymentduedate;
END getnmsbpaymentdate;



FUNCTION getMaternityNumberOfDays  (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER
IS

    l_payment_date DATE := TO_DATE ('01/01/1900', 'DD/MM/YYYY');
    l_end_date     NUMBER := 0;

    BEGIN

     l_payment_date := getnmsbpaymentdate (p_stud_ref_no, p_session_code);
     
     SELECT (a.end_date + 1) - l_payment_date
     INTO l_end_date
     FROM nmsb_spec_arr a
    WHERE stud_ref_no = p_stud_ref_no AND session_code = p_session_code;
    
    
     RETURN l_end_date;
     
     END getMaternityNumberOfDays;
     

/* Formatted on 2009/01/16 14:29 (Formatter Plus v4.8.8) */
--This service determines the stud dependants age which is determined between 01-AUG-SessionYear - Stud_dependants Date of Birth
FUNCTION get_dep_age (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER
IS
    
    l_depage   NUMBER := 0;

    BEGIN
    
    SELECT 
        CASE
            WHEN (age < 1)
            THEN 1    --IF STUDENT IS LESS THAN ONE YEAR OLD WE WANT TO RETURN 1 AS MINIMUM VALUE
            ELSE TRUNC (age)
        END age2
    INTO l_depage
    FROM (SELECT MONTHS_BETWEEN (TO_DATE (CONCAT ('01-AUG-',
                                                     a.session_code),
                                             'DD/MM/YYYY'
                                            ),
                                    a.dob
                                   )
                  / 12 age
             FROM stud_dependant a
             WHERE a.stud_ref_no = p_stud_ref_no
             AND a.session_code = p_session_code);

   RETURN l_depage;
   
   EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001, 'Student with reference number, session code combination ' || p_stud_ref_no || ',' || p_session_code  || ' does not exist in the StEPS database!');
            
   END get_dep_age;
    
/* Formatted on 2009/12/06 11:23 (Formatter Plus v4.8.8) */
--This service is used in order to return the maximum term number for a particular student course and if the course exists.  If course does not exist FUNCTION get_max_term_default should
--be used. 
FUNCTION get_max_term_no (p_stud_ref_no NUMBER, p_session_code NUMBER)
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
   
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error
               (-20001,
                   'Student with reference number, session code combination '
                || p_stud_ref_no
                || ','
                || p_session_code
                || ' does not exist in the StEPS database!'
               );
END get_max_term_no;
    
/* Formatted on 2009/12/06 11:27 (Formatter Plus v4.8.8) */
--This service is used to determine the maximum term number for a student were the course details are not set up and default term dates should be used.

FUNCTION get_max_term_default (p_stud_ref_no NUMBER, p_session_code NUMBER)
   RETURN NUMBER
IS
   l_max_term_default   NUMBER := 0;
BEGIN
   -- Get the last term date for the session
   SELECT MAX (term_no)
     INTO l_max_term_default
     FROM inst_term@grass a, stud_crse_year b
    WHERE b.inst_code =
             a.inst_code
                      ---INSTITUTION CODE IS USED TO DETERMINE MAX_TERM VALUE.
      AND a.session_code = b.session_code
      AND b.session_code = p_session_code
      AND b.stud_ref_no = p_stud_ref_no
      AND b.latest_crse_ind = 'Y';

   RETURN l_max_term_default;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error
               (-20001,
                   'Student with reference number, session code combination '
                || p_stud_ref_no
                || ','
                || p_session_code
                || ' does not exist in the StEPS database!'
               );
END get_max_term_default;
    
/* Formatted on 2009/12/06 11:30 (Formatter Plus v4.8.8) */
--This Function is used to determine if the current student should use default terms using inst_term table or if details are set-up crse_term table
--The function will return 'Y' if default terms should be used, else will return 'N'

FUNCTION check_default_terms (p_stud_ref_no NUMBER, p_session_code NUMBER)
   RETURN CHAR
IS
   l_default_term   CHAR (1) := 'Y';
BEGIN
   SELECT cy.default_terms
     INTO l_default_term
     FROM crse_year@grass cy, stud_crse_year scy
    WHERE cy.crse_year_id = scy.crse_year_id
      AND scy.stud_ref_no = p_stud_ref_no
      AND scy.session_code = p_session_code
      AND scy.latest_crse_ind = 'Y';

   RETURN l_default_term;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error
               (-20001,
                   'Student with reference number, session code combination '
                || p_stud_ref_no
                || ','
                || p_session_code
                || ' does not exist in the StEPS database!'
               );
END check_default_terms;
    

/* Formatted on 2009/12/06 11:32 (Formatter Plus v4.8.8) */
--This service will return the number of days the course lasts in a particular session.

FUNCTION get_courselength (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN NUMBER
IS
   l_max_term_no        NUMBER   := NULL;
   l_max_term_default   NUMBER   := NULL;
   l_default_term       CHAR (1) := '';
   l_courselength       NUMBER;
BEGIN
   l_default_term := check_default_terms (p_stud_ref_no, p_session_code);
                               --Check to see if default terms should be used

   IF l_default_term = 'Y'
   THEN
      --Look up inst_term table as default terms used.
      SELECT SUM (days)
        INTO l_courselength
        FROM inst_term@grass a, stud_crse_year b
       WHERE b.inst_code = a.inst_code
         AND a.session_code = b.session_code
         AND b.session_code = p_session_code
         AND b.stud_ref_no = p_stud_ref_no
         AND b.latest_crse_ind = 'Y';
   ELSE
      --Course details set-up so use crse_term table
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
    
/* Formatted on 2009/12/06 11:36 (Formatter Plus v4.8.8) */
--This function requires student Reference Number, SesssionCode and the l_start_year which is the year the student started there course.  Tje service determines if 
--the course is set-up or if default term dates should be used.  The Function will return 'Y' if default terms and 'N' if course set-up.

FUNCTION check_default_startcourse (
   p_stud_ref_no    NUMBER,
   p_session_code   NUMBER,
   l_start_year     NUMBER
)
   RETURN CHAR
IS
   l_default_start   CHAR (1) := 'X';

    CURSOR c1
    IS
   SELECT a.default_terms
     FROM crse_year@grass a,
          stud_crse_year b,
          crse_session@grass c,
          crse d
    WHERE a.inst_code = b.inst_code
      AND b.crse_year_no = a.crse_year_no
      AND c.crse_session_id = a.crse_session_id
      AND d.crse_id = c.crse_id
      AND d.crse_code = b.crse_code
      AND c.session_code =
             l_start_year
                --The year the student started their course (input to service)
      AND b.stud_ref_no = p_stud_ref_no
      AND b.latest_crse_ind = 'Y'
      AND b.session_code = p_session_code;
    BEGIN
        OPEN c1;
        FETCH c1 INTO  l_default_start;
        CLOSE c1;
        
   RETURN l_default_start;
EXCEPTION
   WHEN NO_DATA_FOUND --MAY OCCUR IF COURSE IS NOT SET UP - X will be returned which is handled in other Function to use default date of 1 AUGUST
   THEN l_default_start := 'X';

END check_default_startcourse;

/* Formatted on 2009/12/06 11:38 (Formatter Plus v4.8.8) */
--This service returns a list of start dates for each term in the required session year       

FUNCTION get_startdates (p_stud_ref_no NUMBER, p_session_code NUMBER)
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
                                                --Check if default terms used

   IF l_default_term = 'Y'
   THEN
      l_max_term_default :=
                         get_max_term_default (p_stud_ref_no, p_session_code);
                                           -- Returns the maximum term number

      --Default Term dates used
      OPEN startdates_cursor FOR
         SELECT a.start_date
           FROM inst_term@grass a, stud_crse_year b
          WHERE a.inst_code = b.inst_code
            AND a.session_code = b.session_code
            AND a.session_code = p_session_code
            AND b.stud_ref_no = p_stud_ref_no
            AND b.latest_crse_ind = 'Y'
            AND a.term_no <= l_max_term_default;
   ELSE
      l_max_term_no := get_max_term_no (p_stud_ref_no, p_session_code);

      --Course details are set-up
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
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error
               (-20001,
                   'Student with reference number, session code combination '
                || p_stud_ref_no
                || ','
                || p_session_code
                || ' does not exist in the StEPS database!'
               );
END get_startdates;
    

/* Formatted on 2009/12/06 11:40 (Formatter Plus v4.8.8) */
---THIS FUNCTION RETURNS THE STUDENTS AGE WHEN THEY STARTED THIER COURSE.  The service uses the start_date from course in first year and dob to work this value out.
FUNCTION get_ageonstartcourse (p_stud_ref_no NUMBER, p_session_code NUMBER)
   RETURN NUMBER
IS
   l_default_term       CHAR (1) := '';
   l_ageonstartcourse   NUMBER;
   l_startfirstday      DATE;
BEGIN
   l_startfirstday :=
                     get_startdateoffirstyear (p_stud_ref_no, p_session_code);
                            --Returns start date of course in the first year.

   SELECT MONTHS_BETWEEN (l_startfirstday, a.dob) / 12 age
     INTO l_ageonstartcourse
     FROM stud a
    WHERE a.stud_ref_no = p_stud_ref_no;

   RETURN l_ageonstartcourse;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error
               (-20001,
                   'Student with reference number, session code combination '
                || p_stud_ref_no
                || ','
                || p_session_code
                || ' does not exist in the StEPS database!'
               );
END get_ageonstartcourse;

/* Formatted on 2009/12/06 11:42 (Formatter Plus v4.8.8) */
--This function is used in order to determine the start year for a particular student.  This differs from commence session. 

FUNCTION get_startyearfirstyear (p_stud_ref_no NUMBER, p_session_code NUMBER)
   RETURN NUMBER
IS
   l_crse_year_no   NUMBER := 0;
   l_yearlessone    NUMBER := 0;
   l_startyear      NUMBER := 0;
BEGIN
   SELECT crse_year_no
     INTO l_crse_year_no
     FROM stud_crse_year
    WHERE stud_ref_no = p_stud_ref_no
      AND session_code = p_session_code
      AND latest_crse_ind = 'Y';

   l_startyear := p_session_code - (l_crse_year_no - 1);
--Year 4 Student Example:    StartYear = 2009 (current Session) - (4 (courseYear) - 1)
   --                          StartYear = 2009 - 3 = 2006
   RETURN l_startyear;
END get_startyearfirstyear;
    
    --THIS FUNCTION RETURNS THE START DATE IN WHICH THE STUDENT STARTED THEIR COURSE.
    /* Formatted on 2009/12/02 13:55 (Formatter Plus v4.8.8) */
FUNCTION get_startdateoffirstyear (p_stud_ref_no NUMBER, p_session_code NUMBER)
   RETURN DATE
IS
   l_startfirstday   DATE;
   l_default_start   CHAR (1)   := 'Y';
   l_start_year     NUMBER     := 0;
BEGIN

    ---CHECK WHICH YEAR THERE COURSE STARTED
      l_start_year := get_startyearfirstyear (p_stud_ref_no, p_session_code);
   --CHECK TO SEE IF DEFAULT TERM DATES ARE USED WHEN THE STUDENT STARTED THERE COURSE
   l_default_start :=
                    check_default_startcourse (p_stud_ref_no, p_session_code, l_start_year);

    CASE 
    WHEN l_default_start = 'Y'
        THEN 
            --DEFAULT TERMS ARE USED SO CHECK INST_TERM TABLE FOR THE YEAR IN WHICH THEY STARTED THERE COURSE
            SELECT a.start_date
        INTO l_startfirstday
        FROM inst_term@grass a, stud_crse_year b
       WHERE a.inst_code = b.inst_code
         AND a.session_code = l_start_year
         AND b.stud_ref_no = p_stud_ref_no
         AND b.latest_crse_ind = 'Y'
         AND a.term_no = 1;
   WHEN l_default_start = 'N'
      THEN
        --DEFAULT TERMS ARE NOT USED THEREFORE WE NEED TO LOOK UP THE CRSE_YEAR_ID FROM THERE FIRST YEAR
      SELECT a.start_date
      INTO l_startfirstday
      FROM crse_term@grass a, crse_year@grass b, stud_crse_year c, crse_session@grass d, crse@grass e
      WHERE a.crse_year_id = b.crse_year_id
      AND b.crse_session_id = d.crse_session_id
      AND d.crse_id = e.crse_id
      AND b.inst_code = c.inst_code  --- INSTITUTION CODE FROM STEPS
      AND b.crse_year_no = c.crse_year_no -- COURSE YEAR NUMBER FROM STEPS
      AND c.crse_code = e.crse_code  --CRSECODE FROM STEPS
      AND c.session_code = p_session_code -- USING THE CURRENT SESSION RECORD IN STEPS
      AND c.stud_ref_no = p_stud_ref_no  -- USING THE CURRENT STUDENT REFERENCE NUMBER FROM STEPS
      AND d.session_code = l_start_year --  INPUTED FROM OTHER SERVICE AND IS YEAR STUDENT STARTED STUDY
      AND c.latest_crse_ind = 'Y' -- USE THE LATEST COURSE IN STEPS
      AND a.term_no = 1;
   ELSE l_startfirstday := TO_DATE(CONCAT('01/08/',l_start_year),'DD/MM/YYYY'); 

   
   
   
   END CASE;

   RETURN l_startfirstday;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error
               (-20001,
                   'Student with reference number, session code combination '
                || p_stud_ref_no
                || ','
                || p_session_code
                || ' does not exist in the StEPS database!'
               );
END get_startdateoffirstyear;
            
/* Formatted on 2009/12/06 11:44 (Formatter Plus v4.8.8) */
--THIS FUNCTION RETURNS THE NUMBER OF TERMS FOR THE CURRENT SESSION
FUNCTION number_of_terms (p_stud_ref_no NUMBER, p_session_code NUMBER)
   RETURN NUMBER
IS
   l_default_term      CHAR (1) := '';
   l_number_of_terms   NUMBER   := 0;
BEGIN
   l_default_term := check_default_terms (p_stud_ref_no, p_session_code);

   IF l_default_term = 'Y'
   THEN
      l_number_of_terms :=
                         get_max_term_default (p_stud_ref_no, p_session_code);
      RETURN l_number_of_terms;
   ELSE
      l_number_of_terms := get_max_term_no (p_stud_ref_no, p_session_code);
      RETURN l_number_of_terms;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error
               (-20001,
                   'Student with reference number, session code combination '
                || p_stud_ref_no
                || ','
                || p_session_code
                || ' does not exist in the StEPS database!'
               );
END number_of_terms;
       
/* Formatted on 2009/12/06 11:45 (Formatter Plus v4.8.8) */
--    This looks up previous years snb_rate, if this does not exist we return a 'Y' (new student)
--    Otherwise if previous year record exists we return previous record.  N = N, Y = Y, Null = Y 

FUNCTION get_prev_single_rate (
   p_stud_ref_no    IN   NUMBER,
   p_session_code   IN   NUMBER
)
   RETURN CHAR
IS
   l_single_rate   CHAR (1) := 'Y';
BEGIN
   SELECT iv1.snb_rate
     INTO l_single_rate
     FROM (SELECT NVL (a.snb_single_rate, 'Y') snb_rate
             FROM stud_crse_year@grass a
            WHERE a.stud_ref_no = p_stud_ref_no
              AND a.session_code = (p_session_code - 1)
              AND a.latest_crse_ind = 'Y'
           UNION
           SELECT 'Y'                                   -- no data, return 'Y'
             FROM DUAL) iv1
    WHERE ROWNUM < 2;

   RETURN l_single_rate;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error
               (-20001,
                   'Student with reference number, session code combination '
                || p_stud_ref_no
                || ','
                || p_session_code
                || ' does not exist in the StEPS database!'
               );
END get_prev_single_rate;
        
        
/* Formatted on 2009/12/06 11:45 (Formatter Plus v4.8.8) */
---THIS FUNCTION RETURNS THE NUMBER OF AWARDS PER STUDENT PER SESSION.    

FUNCTION count_awards (p_stud_ref_no NUMBER, p_session_code NUMBER)
   RETURN NUMBER
IS
   l_total_awards   NUMBER := NULL;
BEGIN
   SELECT COUNT (award_id)
     INTO l_total_awards
     FROM award
    WHERE stud_ref_no = p_stud_ref_no AND session_code = p_session_code;

   RETURN l_total_awards;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error
               (-20001,
                   'Student with reference number, session code combination '
                || p_stud_ref_no
                || ','
                || p_session_code
                || ' does not exist in the StEPS database!'
               );
END count_awards;   
        
--This function return  the end date of the students final year of their course.       
/* Formatted on 2009/12/06 11:46 (Formatter Plus v4.8.8) */
FUNCTION get_final_course_end_date (
   p_stud_ref_no    IN   NUMBER,
   p_session_code   IN   NUMBER
)
   RETURN DATE
IS
   l_end_date   DATE;
BEGIN
   SELECT MAX (a.end_date)
     INTO l_end_date
     FROM crse_term a, stud_crse_year b, crse_year c, crse_session d
    WHERE b.crse_year_id = c.crse_year_id
      AND a.crse_year_id = c.crse_year_id
      AND d.crse_session_id = c.crse_session_id
      AND d.session_code = p_session_code
      AND b.latest_crse_ind = 'Y'
      AND b.stud_ref_no = p_stud_ref_no;

   RETURN l_end_date;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error
               (-20001,
                   'Student with reference number, session code combination '
                || p_stud_ref_no
                || ','
                || p_session_code
                || ' does not exist in the StEPS database!'
               );
END get_final_course_end_date;
   
/* Formatted on 2009/12/06 11:47 (Formatter Plus v4.8.8) */
--This Function return  the numbet of student dependants    

FUNCTION get_dependants (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN NUMBER
IS
   l_dependant   NUMBER := 0;
BEGIN
   SELECT COUNT (std_id)
     INTO l_dependant
     FROM stud_dependant
    WHERE stud_ref_no = p_stud_ref_no AND session_code = p_session_code;

   RETURN l_dependant;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error
               (-20001,
                   'Student with reference number, session code combination '
                || p_stud_ref_no
                || ','
                || p_session_code
                || ' does not exist in the StEPS database!'
               );
END get_dependants;
               
/* Formatted on 2009/12/06 11:51 (Formatter Plus v4.8.8) */
--This function works out the SNB Overpayment Amount     

FUNCTION get_snb_overpayment (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
   RETURN NUMBER
IS
   l_recovered_amount         NUMBER := 0;
   l_snb_overpaymentinitial   NUMBER := 0;
   l_snb_overpayment          NUMBER := 0;
BEGIN
   SELECT NVL (SUM (a.recovered_amount), 0)
     INTO l_recovered_amount
     FROM award_instalment a, award b
    WHERE b.stud_ref_no = p_stud_ref_no
      AND b.award_id = a.award_id
      AND b.session_code = p_session_code
      AND a.payment_status = 'U';

   SELECT NVL (a.snb_overpayment, 0)
     INTO l_snb_overpaymentinitial
     FROM stud a
    WHERE stud_ref_no = p_stud_ref_no;

   l_snb_overpayment := l_recovered_amount + l_snb_overpaymentinitial;
   RETURN l_snb_overpayment;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error
               (-20001,
                   'Student with reference number, session code combination '
                || p_stud_ref_no
                || ','
                || p_session_code
                || ' does not exist in the StEPS database!'
               );
END get_snb_overpayment;
           
/* Formatted on 2009/12/06 11:51 (Formatter Plus v4.8.8) */
--This service return  the number of terms days in a particular sesssion year      

FUNCTION get_termdays (p_stud_ref_no NUMBER, p_session_code NUMBER)
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
            AND a.session_code = b.session_code
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
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error
               (-20001,
                   'Student with reference number, session code combination '
                || p_stud_ref_no
                || ','
                || p_session_code
                || ' does not exist in the StEPS database!'
               );
END get_termdays;
    
        
    PROCEDURE AssessBursary_doc (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_bursary_type IN OUT bursary_cursor, ERROR_TEXT OUT NOCOPY VARCHAR2)
   IS
   
      l_end_date            DATE;
      l_start_date          DATE;
      l_snb_overpayment     NUMBER;
      l_get_courselength    NUMBER;
      
    BEGIN
    
      l_end_date := get_final_course_end_date(p_stud_ref_no, p_session_code);
      l_snb_overpayment := get_SNB_Overpayment(p_stud_ref_no, p_session_code);
      l_get_courselength := get_courselength(p_stud_ref_no, p_session_code);
   
        OPEN p_bursary_type FOR        
        
            SELECT a.crse_year_no YearOfStudy, b.start_date BursaryStartDate, b.end_date BursaryEndDate, NVL(a.nmsb_part_time,'N') AS PartTime, NVL(a.NMSB_INIT_EXPENSES,'N') AS InitialExpenses, A.CALC_NMSB,
            
             CASE
                WHEN b.recommence_date IS NOT NULL
                    THEN l_get_courselength
                WHEN (b.start_date IS NOT NULL) AND (b.end_date IS NOT NULL) AND (b.recommence_date IS NULL)
                    THEN (b.end_date - b.start_date)+1
                WHEN (b.start_date IS NULL) AND (b.end_date IS NULL) AND (b.recommence_date IS NULL)
                    THEN 0
                WHEN (b.start_date IS NOT NULL) and (b.end_date IS NULL) AND (b.recommence_date IS NULL)
                    THEN (l_end_date - b.start_date)+1 
                ELSE (b.end_date - l_start_date)+1
                END DaysToBeFunded, l_snb_overpayment AS SNB_overpayment,l_get_courselength AS courseLength,
                CASE
                    WHEN (b.start_date IS NOT NULL) OR (b.end_date IS NOT NULL) AND ((b.NMSB_SPEC_ARR_TYPE = 'M') OR (b.NMSB_SPEC_ARR_TYPE = 'C'))   -- Special arrangement 'M' types not to be scalled down so use daysToBeFunded as 365
                    THEN 'Y'
                    ELSE 'N'
                    END SpecialArrangementBursary    
            FROM stud_crse_year a, nmsb_spec_arr b,stud d       
            WHERE a.session_code = p_session_code
            AND a.stud_ref_no = p_stud_ref_no
            AND a.stud_ref_no = b.stud_ref_no(+)
            AND a.stud_ref_no = d.stud_ref_no
            AND latest_crse_ind = 'Y';
            
      EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
           
   END AssessBursary_doc;
   
    PROCEDURE CalculateDependants (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_dependants_type IN OUT dependants_cursor, ERROR_TEXT OUT NOCOPY VARCHAR2)
    IS
 
      l_dependant NUMBER :=0; 

       BEGIN
       
              l_dependant := get_dependants (p_stud_ref_no, p_session_code); 
    
        OPEN p_dependants_type FOR
        
        select CASE
        WHEN a.relation_id = 48
        THEN 'Y'
        ELSE 'N'
        END AnySpouseDep,NVL(a.income,0) SpouseDepIncome, 
        CASE
        WHEN  l_dependant = 0
        THEN 'N'
        ELSE  b.CALC_DEP_GRANT
        END CalculateDG
        FROM stud_dependant a, stud_crse_year b
        WHERE b.stud_ref_no = p_stud_ref_no
        AND b.session_code = p_session_code
        AND a.relation_id(+) = 48
        AND b.stud_ref_no = a.stud_ref_no(+)
        AND b.session_code = a.session_code(+)
        AND b.latest_crse_ind = 'Y'; 
        
    EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;    
           
    END CalculateDependants;
    
    PROCEDURE calculateSupps (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_supps_type IN OUT supps_cursor, ERROR_TEXT OUT NOCOPY VARCHAR2)
    IS
    BEGIN
    
        OPEN p_supps_type FOR
        
        SELECT a.calc_lpcg CalculateCAP, b.lpcg_paid_amount CAPRequested, b.max_lpcg_paid CAPMAX,a.Calc_SPA CalculateSPA
        FROM stud_crse_year a, stud_session b
        WHERE b.stud_ref_no = p_stud_ref_no
        AND b.session_code = p_session_code
        AND a.stud_ref_no = b.stud_ref_no
        AND a.latest_crse_ind = 'Y';
        
    EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
        
    END calculateSupps;
    
    PROCEDURE disregardDependants (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_disregardDeps_type IN OUT disregardDeps_cursor, ERROR_TEXT OUT NOCOPY VARCHAR2)
    IS 
        
      l_dependant NUMBER :=0; 

       BEGIN
       
              l_dependant := get_dependants (p_stud_ref_no, p_session_code);   
        
        OPEN p_disregardDeps_type FOR
    
    
        SELECT CASE
          WHEN ((SELECT   MONTHS_BETWEEN (TO_DATE (CONCAT ('01-AUG-',
                                                           a.session_code
                                                          ),
                                                   'DD/MM/YYYY'
                                                  ),
                                          c.dob
                                         )
                        / 12
                   FROM DUAL) < 1
               )
             THEN 1
          ELSE TRUNC
                  ((SELECT   MONTHS_BETWEEN (TO_DATE (CONCAT ('01-AUG-',
                                                              a.session_code
                                                             ),
                                                      'DD/MM/YYYY'
                                                     ),
                                             c.dob
                                            )
                           / 12
                      FROM DUAL)
                  )
       END depage,
       CASE
       WHEN l_dependant = 0
       THEN 'N'
       ELSE a.calc_dep_grant
       END  calculatedg, NVL (c.income, 0) depincome,
       c.relation_id, std_id
  FROM stud_crse_year a, stud_dependant c
 WHERE a.stud_ref_no = p_stud_ref_no
   AND a.session_code = p_session_code
   AND a.stud_ref_no = c.stud_ref_no(+)
   AND a.session_code = c.session_code(+)
   ORDER BY depage desc;
   
    EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   
    
    END disregardDependants;

    
    PROCEDURE studTypeNMSB (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_studTypeNMSB_type IN OUT studTypeNMSB_cursor, ERROR_TEXT OUT NOCOPY VARCHAR2)
        IS
     
    l_singlerate     CHAR(1) :='Y';
    l_ageOnStartCourse NUMBER := 0;
    
    BEGIN
 

    l_singlerate := get_prev_single_rate (p_stud_ref_no, p_session_code);
    l_ageOnStartCourse := get_ageOnStartCourse (p_stud_ref_no,p_session_code);
          
        OPEN p_studTypeNMSB_type FOR
        
         SELECT ROUND(l_ageOnStartCourse,1) AS AgeOnStartCourse, l_singlerate AS SingleRate,
                    CASE 
                    WHEN b.snb_grad IS NULL 
                    THEN 'N' ELSE b.snb_grad 
                    END snb_grad
        FROM STUD a, stud_crse_year b
        WHERE a.stud_ref_no = p_stud_ref_no
        AND b.session_code = p_session_code
        AND a.stud_ref_no = b.stud_ref_no;
        
    EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
        
    END studTypeNMSB;

    PROCEDURE CalcAwardInput (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_CalcAwardInput_type IN OUT CalcAwardInput_cursor, p_start_dates IN OUT startdates_cursor_type,
                 p_term_days IN OUT termdays_cursor_type, p_awards_cursor IN OUT all_award_cursor_type, ERROR_TEXT OUT NOCOPY VARCHAR2)
    IS
    
      l_count_awards          NUMBER :=0;
      l_number_of_terms       NUMBER :=0;
    
    
    BEGIN  
    
          OPEN p_awards_cursor FOR
        SELECT a.award_id AS Award_id, 
               a.stud_award_type AS stud_award_type
          FROM award a, stud_crse_year cy
         WHERE a.stud_ref_no  = p_stud_ref_no
           AND a.session_code = p_session_code
           AND cy.stud_crse_year_id = a.stud_crse_year_id
           AND cy.latest_crse_ind = 'Y'; 
    
    
    
    
     l_count_awards := count_awards(p_stud_ref_no,p_session_code);
     l_number_of_terms:= number_of_terms (p_stud_ref_no, p_session_code);
    
      OPEN p_CalcAwardInput_type FOR
        
        SELECT a.stud_crse_year_id, a.inst_code, a.crse_id, a.crse_year_no, a.stud_ref_no, a.session_code,  
                CASE
                WHEN (l_count_awards > 0)
                THEN 'D'
                ELSE 'I'
                END assess_reason_code, l_number_of_terms AS no_terms, e.payment_method AS stud_method, 
                CASE
                WHEN (e.nominee = 'N')
                THEN 'S'
                ELSE 'N'
                END payee, e.nominee
        FROM stud_crse_year a, crse_year c, crse_session d, stud e
        WHERE a.stud_ref_no = p_stud_ref_no
        AND c.crse_year_id = a.crse_year_id
        AND a.stud_ref_no = e.stud_ref_no
        AND c.crse_session_id = d.crse_session_id
        AND a.session_code = p_session_code
        AND a.latest_crse_ind = 'Y';
        
        p_start_dates := get_startdates (p_stud_ref_no, p_session_code);
        p_term_days := get_termdays (p_stud_ref_no, p_session_code);
        
      EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
              
     END CalcAwardInput;
     
     
        PROCEDURE getNMSBSpecialArrangement (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_specialArr_type IN OUT specialArrNMSB_cursor, ERROR_TEXT OUT NOCOPY VARCHAR2)
        IS
     
    BEGIN
    
        
        OPEN p_specialArr_type FOR
        
        SELECT a.payment_due_date, a.award_id, a.amount, getMaternityNumberOfDays(p_stud_ref_no, p_session_code) as Days, B.STUD_AWARD_TYPE, 
        getEndDateTermNMSBSpec(p_stud_ref_no, p_session_code) as EndDateTerm, a.award_instalment_id
        FROM award_instalment a, award b
        WHERE a.award_id = b.award_id
        AND b.stud_ref_no = p_stud_ref_no
        AND b.session_code = p_session_code
        AND TRUNC(a.payment_due_date) = TRUNC(getnmsbpaymentdate (p_stud_ref_no, p_session_code));
        
        
      EXCEPTION
      WHEN OTHERS
      THEN
      ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
      
      END getNMSBSpecialArrangement;
        

  END NMSB_rules_proc;
/
