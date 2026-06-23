CREATE OR REPLACE PACKAGE SGAS.TRANSFORM_SINGLE_SRN
AS
/******************************************************************************
   NAME:       TRANSFORM
   PURPOSE:    Pre-Synchronisegle srn version 

   REVISIONS: 
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        29/06/2020  M.Tolmie         Single SRN verison of transform for 
                                           upgrade project
   
******************************************************************************/

   FUNCTION application_data_copy_steps (
      p_stud_ref_no   IN     complete_web_applications.stud_ref_no@web%TYPE)
      RETURN VARCHAR2;

   FUNCTION application_data_copy_genric (
      stud_rec          IN complete_web_applications@web%ROWTYPE,
      which_db_to_use   IN VARCHAR2)
      RETURN VARCHAR2;
      
FUNCTION copy_dep_app_data (
      STUD_REC_DEP      IN complete_web_app_dep@web%ROWTYPE,
      which_db_to_use   IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_eistream_record (
      p_stud_ref_no   IN     STUD.stud_ref_no@web%TYPE,
      p_object_id     IN     complete_web_applications.object_id@web%TYPE,
      p_batch_id      IN OUT VARCHAR2,
      p_envelope_id   IN OUT VARCHAR2,
      p_err_mess      IN OUT VARCHAR2)
      RETURN BOOLEAN;

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


 
END TRANSFORM_SINGLE_SRN;
/