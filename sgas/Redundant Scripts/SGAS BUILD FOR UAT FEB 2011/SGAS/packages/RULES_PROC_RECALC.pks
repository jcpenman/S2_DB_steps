CREATE OR REPLACE PACKAGE SGAS.RULES_PROC_RECALC AS
/******************************************************************************
   NAME:       RULES_PROC
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        01/07/2010    P Hughes        Created Package 
******************************************************************************/
  --
  -- CURSOR DEFINITIONS
  TYPE stud_type_cursor         IS REF CURSOR;
  TYPE bursary_type_cursor      IS REF CURSOR;
  TYPE income_assessment_cursor IS REF CURSOR;
  TYPE loans_cursor             IS REF CURSOR;
  TYPE fees_cursor              IS REF CURSOR;
  TYPE supps_cursor             IS REF CURSOR;
  TYPE calculateAward_cursor    IS REF CURSOR;
  TYPE all_payment_cursor_type  IS ref CURSOR return payment_dates@grass%rowtype;
  TYPE startdates_cursor_type   IS REF CURSOR;
  TYPE termdays_cursor_type     IS REF CURSOR;
  TYPE ALL_AWARD_CURSOR_TYPE    IS REF CURSOR;
  TYPE awardInstalments_cursor  IS REF CURSOR;
  TYPE travelElement_cursor     IS REF CURSOR;
  TYPE start_dates_cursor_type  IS REF CURSOR;
  
  FUNCTION getCampusID (p_crse_id IN NUMBER, p_type IN CHAR) RETURN NUMBER;
  FUNCTION maxAwardExceeded (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION getPrevSessionProvisionalFlag (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)RETURN CHAR;
  FUNCTION prevFees (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION getStartDateTerm (p_stud_crse_year_id IN NUMBER, p_term_no NUMBER) RETURN DATE;
  FUNCTION more_studcrse_year_record (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
    FUNCTION getstudystartterm (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION checkWithdrawOrCrseChng (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION fee_cut_off_date (p_stud_crse_year_id IN NUMBER) RETURN DATE;
  FUNCTION get_courselength (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION getstudyendterm (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
--  FUNCTION getOverPayAward (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER, p_award_type IN CHAR) RETURN CHAR;
--  FUNCTION no_of_dependant_children (p_stud_ref_no    IN   NUMBER,p_session_code   IN   NUMBER) RETURN CHAR;
  FUNCTION get_ben_income (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION get_startdates (p_stud_crse_year_id IN NUMBER) RETURN startdates_cursor_type;
  FUNCTION number_of_terms (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION check_default_terms (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION get_stud_age (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION get_max_term_no (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
--  FUNCTION get_start_year (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION get_ja_studs_reg (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION count_awards (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION count_payment_dates (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION triplepayment_flag (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION getwithdrawelterm (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;  
  FUNCTION getfeespaidamount (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION getattendfeecutoffdate (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION getpaidfees (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION final_year_check (p_stud_crse_year_id IN NUMBER)RETURN CHAR;
  FUNCTION get_termdays (p_stud_crse_year_id IN NUMBER) RETURN termdays_cursor_type;
  FUNCTION get_missingben1data (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION get_missingben2data (p_stud_crse_year_id IN NUMBER)RETURN CHAR;
  FUNCTION get_max_term_default (p_stud_crse_year_id   IN   NUMBER)RETURN NUMBER;
  FUNCTION prev_session_bursary (p_stud_crse_year_id    IN   NUMBER)RETURN CHAR;
--  FUNCTION getstudystartterm (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
  FUNCTION get_abroad_days_in_term (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION get_max_year_no (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION check_ben1_exists (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION check_ben2_exists (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION no_of_dependant_children (p_stud_crse_year_id IN   NUMBER) RETURN CHAR;
  FUNCTION daysinattendance (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION getpaidrecords (p_award_id IN NUMBER) RETURN CHAR;
  FUNCTION getStudyEnddate (p_stud_crse_year_id IN NUMBER)RETURN DATE;
  FUNCTION checkStartDate (p_stud_crse_year_id IN NUMBER)RETURN CHAR;
  FUNCTION getdaysinattendanceinterm(p_stud_crse_year_id IN NUMBER,   p_term_no IN NUMBER) RETURN NUMBER;

  
  
  PROCEDURE stud_type_doc (p_stud_crse_year_id IN NUMBER, p_stud_type IN OUT stud_type_cursor);  
  PROCEDURE bursary_doc (p_stud_crse_year_id IN NUMBER, p_bursary_type IN OUT bursary_type_cursor);  
  PROCEDURE income_assessment_doc (p_stud_crse_year_id IN NUMBER, p_income_assessment_type IN OUT income_assessment_cursor);
  PROCEDURE loans_doc (p_stud_crse_year_id IN NUMBER, p_loans_type IN OUT loans_cursor);
  PROCEDURE supps_doc (p_stud_crse_year_id IN NUMBER, p_supps_type IN OUT supps_cursor);
  PROCEDURE fees_doc (p_stud_crse_year_id IN NUMBER, p_fees_type IN OUT fees_cursor);
  PROCEDURE calculateAwardDoc (p_stud_crse_year_id IN NUMBER, p_calculateAward_type IN OUT calculateAward_cursor, 
                             --  p_payment_dates IN OUT all_payment_cursor_type, 
                             --  p_start_dates IN OUT startdates_cursor_type,
                               p_term_days IN OUT termdays_cursor_type, p_awards_cursor IN OUT all_award_cursor_type);
  PROCEDURE awardInstalments( p_stud_crse_year_id IN NUMBER, p_awardInstalment_type IN OUT awardInstalments_cursor,
                            --  p_start_dates_cursor         IN OUT   start_dates_cursor_type,
                              p_start_dates           IN OUT   startdates_cursor_type,
                                p_payment_dates IN OUT all_payment_cursor_type);
  PROCEDURE travelElement (p_stud_crse_year_id IN NUMBER, p_travel_type IN OUT travelElement_cursor);
  --
  -- CONSTANTS DEFINITIONS
  STEPS_RELEASE_YEAR        CONSTANT NUMBER := 2010;
  MAX_AWARD                 CONSTANT NUMBER := 10000;
  
END RULES_PROC_RECALC;
/
