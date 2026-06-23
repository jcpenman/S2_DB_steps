CREATE OR REPLACE PACKAGE SGAS.PK_AWARD_CALCULATION
AS
   /******************************************************************************
      NAME:       RULES_PROC
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        16/08/2012   Paul Hughes     Created Package for 2013
   ******************************************************************************/
   --
   -- CURSOR DEFINITIONS
   TYPE dependants_cursor IS REF CURSOR;

   TYPE lpg_cursor IS REF CURSOR;

   TYPE calculateAward_cursor IS REF CURSOR;

   TYPE startdates_cursor_type IS REF CURSOR;

   TYPE ALL_AWARD_CURSOR_TYPE IS REF CURSOR;

   TYPE awardscreen_type_cursor IS REF CURSOR;

   TYPE rules_type_cursor IS REF CURSOR;
   


   FUNCTION RelativeDays (p_stud_crse_year_id IN NUMBER)
      RETURN NUMBER;

   FUNCTION IS_LEAP_YEAR (nYr IN NUMBER)
      RETURN CHAR;

   FUNCTION getHouseHoldIncome (p_stud_crse_year_id IN NUMBER)
      RETURN NUMBER;

   FUNCTION set_ruk_fee_cap (p_stud_crse_year_id IN NUMBER)
      RETURN NUMBER;

   FUNCTION getDependantDays (p_stud_crse_year_id IN NUMBER)
      RETURN NUMBER;
   FUNCTION getDependantDays_2022(p_stud_crse_year_id IN NUMBER) 
      RETURN NUMBER;

   FUNCTION getDependantMaxDates (p_stud_crse_year_id IN NUMBER)
      RETURN DATE;

   FUNCTION getDependantMinDates (p_stud_crse_year_id IN NUMBER)
      RETURN DATE;

   FUNCTION getLPGDays (p_stud_crse_year_id IN NUMBER)
      RETURN NUMBER;
      
   FUNCTION getLPGDays_2022 (p_stud_crse_year_id IN NUMBER) 
       RETURN NUMBER;      

   FUNCTION getRelevantStartDate (p_stud_crse_year_id IN NUMBER)
      RETURN DATE;

   FUNCTION getRelevantEndDate (p_stud_crse_year_id IN NUMBER)
      RETURN DATE;

   FUNCTION award_status (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR;

   FUNCTION over_25_with_benfactors (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR;

   FUNCTION get_fee_factor (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR;

   FUNCTION getPartYearAbroad (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR;
      
   FUNCTION get_eu_residency(p_birth_country_code IN VARCHAR2,
                       p_nation_country_code IN VARCHAR2,
                       p_residence_county_code IN VARCHAR2,
                       p_ord_res_scotland_web IN VARCHAR2,
                       p_inscot_year IN VARCHAR2,
                       p_ord_res_uk_web IN VARCHAR2)
  RETURN VARCHAR2;

   PROCEDURE dependants_doc (p_stud_crse_year_id   IN     NUMBER,
                             p_dependants_type     IN OUT dependants_cursor);
                             
    PROCEDURE eu_residency (p_birth_country_code IN VARCHAR2,
                       p_nation_country_code IN VARCHAR2,
                       p_residence_county_code IN VARCHAR2,
                       p_ord_res_scotland_web IN VARCHAR2,
                       p_inscot_year IN VARCHAR2,
                       p_ord_res_uk_web IN VARCHAR2,
                       l_eu_residency OUT VARCHAR2
                       );

   PROCEDURE lpg_doc (p_stud_crse_year_id   IN     NUMBER,
                      p_lpg_type            IN OUT lpg_cursor);

   PROCEDURE getRules_doc (p_stud_crse_year_id   IN     NUMBER,
                           p_rules_type          IN OUT rules_type_cursor);

   PROCEDURE calculateAwardDoc (
      p_stud_crse_year_id     IN     NUMBER,
      p_calculateAward_type   IN OUT calculateAward_cursor,
      p_awards_cursor         IN OUT all_award_cursor_type);

   PROCEDURE updateawardstatusNMSBAwardCalc (
      stud_crse_year_id_in      IN     VARCHAR2,
      nmsb_fees_in                IN       VARCHAR2,
      nmsbbursary_in            IN     VARCHAR2,
      nmsb_dep_allow_in         IN     VARCHAR2,
      nmsb_sp_allow_in          IN     VARCHAR2,
      nmsb_childcare_allow_in   IN     VARCHAR2,
      user_id_in                IN     VARCHAR2,
      error_boolean             IN OUT VARCHAR2,
      ERROR_TEXT                IN OUT VARCHAR2);

   PROCEDURE updateawardstatusAwardCalc (
      stud_crse_year_id_in   		IN     VARCHAR2,
      fees_in                		IN     VARCHAR2,
      loan_in                		IN     VARCHAR2,
      lp_grant_in            		IN     VARCHAR2,
      bursary_in             		IN     VARCHAR2,
      dep_grant_in           		IN     VARCHAR2,
      care_exp_bursary_in    		IN     VARCHAR2,
      pg_ed_psych_fees_in    		IN     VARCHAR2,
      pg_ed_psych_qeps_in    		IN     VARCHAR2,
      pg_ed_psych_grant_in   		IN     VARCHAR2,  
      pg_ed_psych_fees_phd_in    	IN     VARCHAR2,
      pg_ed_psych_grant_phd_in   	IN     VARCHAR2,	  
      user_id_in             		IN     VARCHAR2,
      error_boolean          		IN OUT VARCHAR2,
      ERROR_TEXT             		IN OUT VARCHAR2);

   -- CONSTANTS DEFINITIONS
   STEPS_RELEASE_YEAR   CONSTANT NUMBER := 2011;
END PK_AWARD_CALCULATION;
/
