CREATE OR REPLACE PACKAGE SGAS.NMSB_RULES_PROC AS
/******************************************************************************
   NAME:       NMSB_RULES_PROC
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03.11.2008   Paul Hughes      Created this package body
   1.1        16.01.2009   Paul Hughes      Removed instances of Stud_session table were not required
   1.2        07.04.2009   Paul Hughes      Tidy of Code
   1.3        09.06.2009    Paul Hughes     Added code to calculate age on start of 1st year of course
   1.4        14.07.2009    Paul Hughes     Updated to add STEPS_RELEASE_YEAR constant definition and reference to 2 new FUNCTIONS get_firstyear_crse_id,get_firstInstCode 
                                            Added EXCEPTION OUTPUT TO PROCEDURES.
   1.5        02.12.2009    Paul Hughes     Added new Function get_StartYearFirstYear
   1.6        03.12.2009    Paul Hughes     Added new Function get_courselength
   1.7        04.12.2009    Paul Hughes     Removed FUNCTION get_firstyear_crse_id
   1.8        06.12.2009    Paul Hughes     Removed redundant FUNCTION get_day1term1_start_date 
******************************************************************************/

 --  CURSOR DEFINITIONS
     TYPE bursary_cursor             IS REF CURSOR;
     TYPE dependants_cursor          IS REF CURSOR;
     TYPE supps_cursor               IS REF CURSOR;
     TYPE disregardDeps_cursor       IS REF CURSOR;
     TYPE studTypeNMSB_cursor        IS REF CURSOR;
     TYPE CalcAwardInput_cursor      IS REF CURSOR;
     TYPE startdates_cursor_type     IS REF CURSOR;
     TYPE termdays_cursor_type       IS REF CURSOR;
     TYPE all_award_cursor_type      IS REF CURSOR;
     TYPE specialArrNMSB_cursor      IS REF CURSOR;
     
       

    FUNCTION get_dep_age (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
    FUNCTION get_prev_single_rate (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN CHAR;
    FUNCTION get_final_course_end_date (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN DATE;
    FUNCTION get_SNB_Overpayment (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
    FUNCTION get_ageOnStartCourse (p_stud_ref_no NUMBER, p_session_code NUMBER) RETURN NUMBER;
    FUNCTION get_StartDateofFirstYear (p_stud_ref_no NUMBER, p_session_code NUMBER) RETURN DATE;
    FUNCTION check_default_terms (p_stud_ref_no NUMBER, p_session_code NUMBER) RETURN CHAR;
    FUNCTION check_default_StartCourse (p_stud_ref_no NUMBER, p_session_code NUMBER, l_start_year NUMBER) RETURN CHAR;
    FUNCTION get_StartYearFirstYear (p_stud_ref_no NUMBER, p_session_code NUMBER ) RETURN NUMBER;
    FUNCTION get_courselength (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
    FUNCTION getNMSBPaymentDate (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN DATE;
    FUNCTION getMaternityNumberOfDays  (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
    FUNCTION getEndDateTermNMSBSpec (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
    
    
    
  
  PROCEDURE AssessBursary_doc (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_bursary_type IN OUT bursary_cursor,ERROR_TEXT OUT NOCOPY VARCHAR2);
  PROCEDURE CalculateDependants (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_dependants_type IN OUT dependants_cursor,ERROR_TEXT OUT NOCOPY VARCHAR2);
  PROCEDURE calculateSupps (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_supps_type IN OUT supps_cursor,ERROR_TEXT OUT NOCOPY VARCHAR2);
  PROCEDURE disregardDependants (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_disregardDeps_type IN OUT disregardDeps_cursor,ERROR_TEXT OUT NOCOPY VARCHAR2);
  PROCEDURE studTypeNMSB (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_studTypeNMSB_type IN OUT studTypeNMSB_cursor,ERROR_TEXT OUT NOCOPY VARCHAR2);
  PROCEDURE CalcAwardInput (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_CalcAwardInput_type IN OUT CalcAwardInput_cursor, p_start_dates IN OUT startdates_cursor_type,
                                p_term_days IN OUT termdays_cursor_type, p_awards_cursor IN OUT all_award_cursor_type,ERROR_TEXT OUT NOCOPY VARCHAR2);
  PROCEDURE getNMSBSpecialArrangement (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_specialArr_type IN OUT specialArrNMSB_cursor, ERROR_TEXT OUT NOCOPY VARCHAR2);

  -- CONSTANTS DEFINITIONS
  STEPS_RELEASE_YEAR        CONSTANT NUMBER := 2010;

END NMSB_RULES_PROC;
/
