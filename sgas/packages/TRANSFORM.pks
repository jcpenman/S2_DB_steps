CREATE OR REPLACE PACKAGE SGAS.TRANSFORM
AS
/******************************************************************************
   NAME:       TRANSFORM
   PURPOSE:    Pre-Synchronise 

   REVISIONS: 
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        22/10/2015    C.bolan        Moved to STEPS database as part of 
                                           OLS2016
   
******************************************************************************/

   FUNCTION application_data_copy_steps
      RETURN VARCHAR2;

   FUNCTION application_data_copy_genric (
      stud_rec          IN complete_web_applications@web%ROWTYPE,
      which_db_to_use   IN VARCHAR2)
      RETURN VARCHAR2;
      
FUNCTION copy_dep_app_data (
      STUD_REC_DEP      IN complete_web_app_dep@web%ROWTYPE,
      which_db_to_use   IN VARCHAR2)
      RETURN VARCHAR2;

  /* FUNCTION get_eistream_record (
      p_stud_ref_no   IN     STUD.stud_ref_no@web%TYPE,
      p_object_id     IN     complete_web_applications.object_id@web%TYPE,
      p_batch_id      IN OUT VARCHAR2,
      p_envelope_id   IN OUT VARCHAR2,
      p_err_mess      IN OUT VARCHAR2)
      RETURN BOOLEAN;*/

   FUNCTION get_raw_data_id (p_stud_ref_no        IN     STUD.stud_ref_no@web%TYPE,
                             p_raw_data_id        IN OUT VARCHAR2,
                             p_err_mess           IN OUT VARCHAR2,
                             p_which_db_to_use    IN     VARCHAR2,
                             p_application_Type   IN     VARCHAR2)
      RETURN BOOLEAN;


   FUNCTION create_edm_complete (
      p_stud_rec        IN OUT complete_web_applications@web%ROWTYPE,
      p_raw_data_id     IN OUT VARCHAR2,
      p_batch_id        IN OUT VARCHAR2,
      p_envelope_id     IN OUT VARCHAR2,
      p_err_mess        IN OUT VARCHAR2,
      which_db_to_use   IN     VARCHAR2)
      RETURN BOOLEAN;                                                    -- JM

   FUNCTION create_edm_temp (
      p_stud_rec        IN OUT complete_web_applications@web%ROWTYPE,
      p_err_mess        IN OUT VARCHAR2,
      which_db_to_use   IN     VARCHAR2)
      RETURN BOOLEAN;                                                    -- JM

   --
   --PROCEDURE null_dependant_rec (p_dep_rec IN OUT dep_rec);

   --
   FUNCTION format_currency_rec (
      p_currency_rec IN complete_web_applications.ben2_paye@web%TYPE)
      RETURN VARCHAR2;

   --
   FUNCTION format_currency_rec1 (
      p_currency_rec IN complete_web_applications.ben2_paye@web%TYPE)
      RETURN VARCHAR2;

   --
   FUNCTION reformat_date_for_rawdata (
      p_date_in    IN OUT complete_web_applications.dob@web%TYPE,
      p_date       IN OUT VARCHAR2,
      p_err_mess   IN OUT VARCHAR2)
      RETURN BOOLEAN;
      
  FUNCTION set_complex_residency(
            p_birth_country_code IN COMPLETE_WEB_APPLICATIONS.BIRTH_COUNTRY_CODE@web%TYPE,
            p_nation_country_code IN COMPLETE_WEB_APPLICATIONS.NATION_COUNTRY_CODE@web%TYPE,
            p_residence_country_code IN COMPLETE_WEB_APPLICATIONS.RESIDENCE_COUNTRY_CODE@web%TYPE,
            p_ord_res_uk IN COMPLETE_WEB_APPLICATIONS.ord_res_uk@web%TYPE,
            p_home_post_code IN COMPLETE_WEB_APPLICATIONS.HOME_POST_CODE@web%TYPE,
            p_inscot_year IN COMPLETE_WEB_APPLICATIONS.inscot_year@web%TYPE,
            p_ord_res_scotland IN COMPLETE_WEB_APPLICATIONS.ord_res_scotland@web%TYPE,
            p_eu_student IN COMPLETE_WEB_APPLICATIONS.EU_STUDENT@web%TYPE,
            p_stud_ref_no IN COMPLETE_WEB_APPLICATIONS.STUD_REF_NO@web%TYPE,
			p_eu_residence_type IN COMPLETE_WEB_APPLICATIONS.EU_RESIDENCE_TYPE@web%TYPE
            )
            RETURN VARCHAR2;
            
  FUNCTION  decode_title(
            p_title  IN  COMPLETE_WEB_APPLICATIONS.TITLE  @web%TYPE
            )
            RETURN NUMBER;  
  FUNCTION transform_ptfg_income_evid  (p_income NUMBER)                           
            RETURN VARCHAR2;                   
            
  FUNCTION sum_ptfg_income(p_PT_EMP_INCOME IN COMPLETE_WEB_APPLICATIONS.PT_EMP_INCOME@web%TYPE,
                           p_PT_SELF_EMP_INCOME IN COMPLETE_WEB_APPLICATIONS.PT_SELF_EMP_INCOME@web%TYPE,
                           p_PT_PENSIONS_INCOME IN COMPLETE_WEB_APPLICATIONS.PT_PENSIONS_INCOME@web%TYPE,
                           p_PT_BENEFITS_INCOME IN COMPLETE_WEB_APPLICATIONS.PT_BENEFITS_INCOME@web%TYPE
                           )
            RETURN NUMBER; 
PROCEDURE update_web_user_id(stud_rec          IN complete_web_applications@web%ROWTYPE);                  
                                                                  
END Transform;
/
