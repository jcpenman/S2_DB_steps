CREATE OR REPLACE PACKAGE SGAS.NMSB_RULES_PROC_RECALC AS
/******************************************************************************
   NAME:       NMSB_RULES_PROC_RECALC
   PURPOSE:    This package is used in order to supply the Rules service with values in which to calculate the NMSB Student Award

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        01.07.2010   Paul Hughes     Created this package body
                                          
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
     TYPE awardInstalmentsNMSB_cursor IS REF CURSOR;
    
 
    FUNCTION SNCAP_SPEC_RECORD_EXIST(p_stud_crse_year_id IN NUMBER, p_award_id IN NUMBER) RETURN CHAR; 
    FUNCTION NON_SNCAP_SPEC_RECORD_EXIST(p_stud_crse_year_id IN NUMBER, p_award_id IN NUMBER) RETURN CHAR;
    FUNCTION numberOfTermsIncludingStartEnd(p_stud_crse_year_id IN NUMBER, p_award_id IN NUMBER) RETURN NUMBER;
    FUNCTION NMSBSPECARRRecordExist (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
    FUNCTION NMSBDAYSINTERM (p_stud_crse_year_id IN NUMBER, p_term_no IN NUMBER) RETURN FLOAT;
    FUNCTION SNCAPNMSBDAYSINTERM (p_stud_crse_year_id IN NUMBER, p_term_no IN NUMBER) RETURN FLOAT;
    FUNCTION getTermEndDate (p_stud_crse_year_id IN NUMBER, p_term_no IN NUMBER) RETURN DATE;
    FUNCTION doublePayment (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
    FUNCTION getMINWithdrawCrseChange (p_stud_crse_year_id IN NUMBER) RETURN DATE;
    FUNCTION overlaptermdates (p_stud_crse_year_id IN NUMBER, p_award_id IN NUMBER) RETURN CHAR;
    FUNCTION getMINEndDateTerm (p_stud_crse_year_id IN NUMBER, p_term_no IN NUMBER) RETURN DATE;
    FUNCTION get_prev_single_rate (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
    FUNCTION get_ageOnStartCourse (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
    FUNCTION get_StartDateofFirstYear (p_stud_crse_year_id NUMBER) RETURN DATE;
    FUNCTION check_default_StartCourse (p_stud_crse_year_id NUMBER, l_start_year NUMBER) RETURN CHAR;
  --  FUNCTION get_StartYearFirstYear (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
    FUNCTION get_dependants (p_stud_crse_year_id IN NUMBER)RETURN NUMBER;   
    FUNCTION getEndDateTerm (p_stud_crse_year_id IN NUMBER, p_term_no NUMBER) RETURN DATE; 
    FUNCTION oldestChild (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
    FUNCTION getMAXStartDateTerm (p_stud_crse_year_id IN NUMBER, p_term_no IN NUMBER) RETURN DATE;
    
    
  PROCEDURE AssessBursary_doc (p_stud_crse_year_id IN NUMBER, p_bursary_type IN OUT bursary_cursor,ERROR_TEXT OUT NOCOPY VARCHAR2);
  PROCEDURE CalculateDependants (p_stud_crse_year_id IN NUMBER, p_dependants_type IN OUT dependants_cursor,ERROR_TEXT OUT NOCOPY VARCHAR2);
  PROCEDURE calculateSupps (p_stud_crse_year_id IN NUMBER, p_supps_type IN OUT supps_cursor,ERROR_TEXT OUT NOCOPY VARCHAR2);
  PROCEDURE disregardDependants (p_stud_crse_year_id IN NUMBER, p_disregardDeps_type IN OUT disregardDeps_cursor,ERROR_TEXT OUT NOCOPY VARCHAR2);
  PROCEDURE studTypeNMSB (p_stud_crse_year_id IN NUMBER, p_studTypeNMSB_type IN OUT studTypeNMSB_cursor,ERROR_TEXT OUT NOCOPY VARCHAR2);
  PROCEDURE CalcAwardInput (p_stud_crse_year_id IN NUMBER, p_CalcAwardInput_type IN OUT CalcAwardInput_cursor,
                                p_awards_cursor IN OUT all_award_cursor_type,
                                ERROR_TEXT OUT NOCOPY VARCHAR2);

  PROCEDURE awardInstalmentsNMSB ( p_stud_crse_year_id IN NUMBER, p_awardInstalmentNMSB_type    IN OUT awardInstalmentsNMSB_cursor, p_start_dates IN OUT startdates_cursor_type);
  PROCEDURE updateAwardInstalments( p_stud_crse_year_id IN NUMBER);
  PROCEDURE RemainderInstalments(p_award_id IN NUMBER);

  -- CONSTANTS DEFINITIONS
  STEPS_RELEASE_YEAR        CONSTANT NUMBER := 2010;

END NMSB_RULES_PROC_RECALC;
/
