CREATE OR REPLACE PACKAGE SGAS.RULES_PROC_RECALC AS
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
  --
  -- CURSOR DEFINITIONS
  TYPE stud_type_cursor         IS REF CURSOR;
  TYPE bursary_type_cursor      IS REF CURSOR;
  TYPE income_assessment_cursor IS REF CURSOR;
  TYPE loans_cursor             IS REF CURSOR;
  TYPE fees_cursor              IS REF CURSOR;
  TYPE fees_cursor_2012         IS REF CURSOR;
  TYPE supps_cursor             IS REF CURSOR;
  TYPE calculateAward_cursor    IS REF CURSOR;
  TYPE all_payment_cursor_type  IS REF CURSOR return payment_dates@grass%rowtype;
  TYPE all_top_payment_cursor_type  IS REF CURSOR return payment_dates@grass%rowtype;
  TYPE startdates_cursor_type   IS REF CURSOR;
  TYPE startdates_cursor_type2022 IS REF CURSOR;
  TYPE termdays_cursor_type     IS REF CURSOR;
  TYPE ALL_AWARD_CURSOR_TYPE    IS REF CURSOR;
  TYPE awardInstalments_cursor  IS REF CURSOR;
  TYPE travelElement_cursor     IS REF CURSOR;
  TYPE start_dates_cursor_type  IS REF CURSOR;
  TYPE terms_cursor             IS REF CURSOR;
  TYPE term_dates_cursor        IS REF CURSOR;
  TYPE awardscreen_type_cursor  IS REF CURSOR;


  
  FUNCTION getLocationIndicator(p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION getCampusID (p_crse_id IN NUMBER, p_type IN CHAR) RETURN NUMBER;
  FUNCTION getNumberOfJACaseStudents (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
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
  FUNCTION get_ben_income (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION get_ben1_income (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION get_ben2_income (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION get_startdates (p_stud_crse_year_id IN NUMBER) RETURN startdates_cursor_type;
  FUNCTION get_startdates2022 (p_stud_crse_year_id IN NUMBER)RETURN startdates_cursor_type2022;
  FUNCTION number_of_terms (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION check_default_terms (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION get_stud_age (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION get_max_term_no (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION get_ja_studs_reg (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION count_awards (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION count_payment_dates (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION count_payment_dates_2022 (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION count_top_payment_dates (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION getTopStudyEnddate_2022 (p_stud_crse_year_id IN NUMBER) RETURN DATE;
  FUNCTION count_top_payment_dates_2022 (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION triplepayment_flag (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION triplepayment_flag_2022 (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION getwithdrawelterm (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;  
  FUNCTION daysInAttendanceNoWithdrawal (P_STUD_CRSE_YEAR_ID IN NUMBER) RETURN NUMBER;
  FUNCTION getDaysInAttendanceInTermWithoutWithdrawal(p_stud_crse_year_id IN NUMBER,
                                                     p_term_no IN NUMBER) RETURN NUMBER;
  FUNCTION getfeespaidamount (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION getattendfeecutoffdate (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION getpaidfees (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION final_year_check (p_stud_crse_year_id IN NUMBER)RETURN CHAR;
  FUNCTION get_termdays (p_stud_crse_year_id IN NUMBER) RETURN termdays_cursor_type;
  FUNCTION get_missingben1data (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION get_missingben2data (p_stud_crse_year_id IN NUMBER)RETURN CHAR;
  FUNCTION get_max_term_default (p_stud_crse_year_id   IN   NUMBER)RETURN NUMBER;
  FUNCTION prev_session_bursary (p_stud_crse_year_id    IN   NUMBER)RETURN CHAR;
  FUNCTION get_abroad_days_in_term (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION get_max_year_no (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION check_ben1_exists (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION check_ben2_exists (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION no_of_dependant_children (p_stud_crse_year_id IN   NUMBER) RETURN CHAR;
  FUNCTION daysinattendance (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION getpaidrecords (p_award_id IN NUMBER) RETURN CHAR;
  FUNCTION getStudyEnddate (p_stud_crse_year_id IN NUMBER)RETURN DATE;
  FUNCTION getStudyEnddate_2022 (p_stud_crse_year_id IN NUMBER)RETURN DATE;
  FUNCTION getTopStudyEnddate (p_stud_crse_year_id IN NUMBER)RETURN DATE;    
  FUNCTION checkStartDate (p_stud_crse_year_id IN NUMBER)RETURN CHAR;
  FUNCTION getdaysinattendanceinterm(p_stud_crse_year_id IN NUMBER,   p_term_no IN NUMBER) RETURN NUMBER;
  FUNCTION getBenIncome(p_ben_id IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
  FUNCTION getJACASEParentIncomeBen1(p_ja_case_id IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
  FUNCTION getJACASEParentIncomeBen2(p_ja_case_id IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
  FUNCTION getNoSharingChildren(p_ja_case_id IN NUMBER) RETURN NUMBER;
  FUNCTION get_paid_SUM_net_Instalment(p_award_id IN NUMBER)RETURN NUMBER;
  FUNCTION getPartYearAbroad (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION getStudyStartDate (p_stud_crse_year_id IN NUMBER) RETURN DATE;
  FUNCTION get_prev_bursary  (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION get_calc_bursary (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION award_status(p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION set_ruk_fee_cap(p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION does_stud_dep_exist (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION is_there_a_spouse (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION benefactor_with_income (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION lpcg_mandatory_fields (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION does_spouse_have_child (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION NMT_only (p_stud_crse_year_id IN NUMBER)RETURN CHAR; 
  FUNCTION countPrevAwardPayments(p_stud_crse_year_id IN NUMBER)RETURN NUMBER;
  FUNCTION getCorrectBenIncome(p_ja_case_id IN NUMBER) RETURN CHAR;
  FUNCTION getEndDateTerm (p_stud_crse_year_id IN NUMBER, p_term_no IN NUMBER) RETURN DATE;
  FUNCTION abroad_startdate_between_terms (p_stud_crse_year_id IN NUMBER) RETURN DATE;
  FUNCTION abroad_enddate_between_terms (p_stud_crse_year_id IN NUMBER) RETURN DATE;
  FUNCTION abroad_days_in_term_overlaps (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION days_of_study (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  FUNCTION get_payment_dates (p_stud_crse_year_id IN NUMBER) RETURN all_payment_cursor_type;
  FUNCTION get_top_payment_dates (p_stud_crse_year_id IN NUMBER) RETURN all_top_payment_cursor_type;
  FUNCTION adult_i_act_as_carer_for (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION has_child_and_adult_dep (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  FUNCTION get_payment_dates_2022 (p_stud_crse_year_id IN NUMBER) RETURN all_payment_cursor_type;
  FUNCTION get_top_payment_dates_2022 (p_stud_crse_year_id IN NUMBER) RETURN all_top_payment_cursor_type;
  FUNCTION is_there_multiple_scy(p_stud_crse_year_id IN NUMBER)RETURN NUMBER;
  FUNCTION sag_award_on_earlier_scy(p_stud_crse_year_id IN NUMBER) RETURN VARCHAR2;
  

  PROCEDURE stud_type_doc (p_stud_crse_year_id IN NUMBER, p_stud_type IN OUT stud_type_cursor);  
  PROCEDURE bursary_doc (p_stud_crse_year_id IN NUMBER, p_bursary_type IN OUT bursary_type_cursor);  
  PROCEDURE income_assessment_doc (p_stud_crse_year_id IN NUMBER, p_income_assessment_type IN OUT income_assessment_cursor);
  PROCEDURE loans_doc (p_stud_crse_year_id IN NUMBER, p_loans_type IN OUT loans_cursor);
  PROCEDURE supps_doc (p_stud_crse_year_id IN NUMBER, p_supps_type IN OUT supps_cursor);
  PROCEDURE fees_doc (p_stud_crse_year_id IN NUMBER, p_fees_type IN OUT fees_cursor);
  PROCEDURE fees_doc_2012 (p_stud_crse_year_id IN NUMBER, p_fees_type_2012 IN OUT fees_cursor_2012);
  PROCEDURE calculateAwardDoc (p_stud_crse_year_id IN NUMBER, p_calculateAward_type IN OUT calculateAward_cursor, 
                               p_term_days IN OUT termdays_cursor_type, p_awards_cursor IN OUT all_award_cursor_type);
  PROCEDURE awardInstalments( p_stud_crse_year_id IN NUMBER, p_awardInstalment_type IN OUT awardInstalments_cursor,
                              p_start_dates  IN OUT   startdates_cursor_type,
                              p_payment_dates IN OUT all_payment_cursor_type,
                              p_top_payment_dates IN OUT all_top_payment_cursor_type);  
  PROCEDURE awardinstalments2022 (
   p_stud_crse_year_id      IN       NUMBER,
   --p_amount                 IN       NUMBER,
   --p_stud_award_type        IN       VARCHAR2,
   p_awardinstalment_type   IN OUT   awardinstalments_cursor,
   p_start_dates            IN OUT   startdates_cursor_type2022,
   p_payment_dates          IN OUT   all_payment_cursor_type,
   p_top_payment_dates      IN OUT   all_top_payment_cursor_type);                                                   
  PROCEDURE travelElement (p_stud_crse_year_id IN NUMBER, p_travel_type IN OUT travelElement_cursor);
  PROCEDURE update_award_recovered_ug (p_stud_crse_year_id IN NUMBER);
  PROCEDURE gettermdates (p_stud_crse_year_id IN NUMBER, p_terms_type IN OUT terms_cursor, 
                          p_term_dates IN OUT term_dates_cursor);
  PROCEDURE updateawardinstalments (p_stud_crse_year_id IN NUMBER);
  PROCEDURE update_attendance_ongoing(p_stud_crse_year_id IN NUMBER);
  PROCEDURE awardscreenvalues_doc (p_stud_crse_year_id   IN       NUMBER,
            p_awardscreen_type    IN OUT   awardscreen_type_cursor);
  PROCEDURE tidy_up_instalments(p_stud_crse_year_id IN NUMBER);      

  --
  -- CONSTANTS DEFINITIONS
  STEPS_RELEASE_YEAR        CONSTANT NUMBER := 2011;
  MAX_AWARD                 CONSTANT NUMBER := 15000;
  
END RULES_PROC_RECALC;
/