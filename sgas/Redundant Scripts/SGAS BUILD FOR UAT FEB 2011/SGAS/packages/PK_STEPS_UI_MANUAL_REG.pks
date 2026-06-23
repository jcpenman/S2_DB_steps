CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_manual_reg
AS
/******************************************************************************
   NAME:       pk_steps_ui_MANUAL_REG
   PURPOSE:

   REVISIONS:
   Ver        Date          Author                  Description
   ---------  ----------    ---------------         ------------------------------------
   1.0        17/11/2008    PADDY GRACE             Created this package.
   1.1        02/12/2009    ABIRAMI CHIDAMBARAM     Code changes
******************************************************************************/
   TYPE dup_cursor IS REF CURSOR;

  PROCEDURE getstudentprepopdata (
      stud_ref_no_in      IN       VARCHAR2,
      session_code_in     IN       VARCHAR2,
      nino                OUT      VARCHAR2,
      title               OUT      VARCHAR2,
      forename            OUT      VARCHAR2,
      surname             OUT      VARCHAR2,
      dob                 OUT      VARCHAR2,
      sex                 OUT      VARCHAR2,
      marital_status      OUT      VARCHAR2,
      birth_district      OUT      VARCHAR2,
      nationality         OUT      VARCHAR2,
      residence_country   OUT      VARCHAR2,
      home_post_code      OUT      VARCHAR2,
      home_house_no       OUT      VARCHAR2,
      home_addr_l1        OUT      VARCHAR2,
      home_addr_l2        OUT      VARCHAR2,
      home_addr_l3        OUT      VARCHAR2,
      home_addr_l4        OUT      VARCHAR2,
      location_ind        OUT      VARCHAR2,
      term_post_code      OUT      VARCHAR2,
      term_house_no       OUT      VARCHAR2,
      term_addr_l1        OUT      VARCHAR2,
      term_addr_l2        OUT      VARCHAR2,
      term_addr_l3        OUT      VARCHAR2,
      term_addr_l4        OUT      VARCHAR2,
      scheme_type         OUT      VARCHAR2,
      inst_code           OUT      VARCHAR2,
      course_code         OUT      VARCHAR2,
      error_boolean       OUT      VARCHAR2,
      ERROR_TEXT          OUT      VARCHAR2,
      not_found_boolean   OUT      VARCHAR2            
   );

   PROCEDURE checkforduplicate (
      forename_in     IN       VARCHAR2,
      surname_in      IN       VARCHAR2,
      dob_in          IN       DATE,
      io_cursor       IN OUT   dup_cursor,
      is_duplicate    OUT      VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE checkdupsrn (
      srn_in          IN       NUMBER,
      is_duplicate    OUT      VARCHAR2,
      dbase           OUT      VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE checksrnandsession (
      stud_ref_no_in       IN       VARCHAR2,
      session_in           IN       VARCHAR2,
      is_valid_srn         OUT      VARCHAR2,
      has_session_record   OUT      VARCHAR2,
      dbase_flag           OUT      VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   );

   PROCEDURE createstudentrecords (
      stud_ref_no_in         IN       VARCHAR2,
      inst_code_in           IN       VARCHAR2,
      inst_name_in           IN       VARCHAR2,
      crse_code_in           IN       VARCHAR2,
      crse_yr_no_in          IN       VARCHAR2,
      crse_name_in           IN       VARCHAR2,
      scheme_type_in         IN       VARCHAR2,
      session_in             IN       VARCHAR2,
      nino_in                IN       VARCHAR2,
      title_in               IN       VARCHAR2,
      forename_in            IN       VARCHAR2,
      surname_in             IN       VARCHAR2,
      dob_in                 IN       DATE,
      sex_in                 IN       VARCHAR2,
      marital_status_in      IN       VARCHAR2,
      birth_district_in      IN       VARCHAR2,
      nationality_in         IN       VARCHAR2,
      residence_country_in   IN       VARCHAR2,
      home_house_no_in       IN       VARCHAR2,
      home_addr_l1_in        IN       VARCHAR2,
      home_addr_l2_in        IN       VARCHAR2,
      home_addr_l3_in        IN       VARCHAR2,
      home_addr_l4_in        IN       VARCHAR2,
      home_post_code_in      IN       VARCHAR2,
      home_mailsort_in       IN       VARCHAR2,
      term_location_in       IN       VARCHAR2,
      term_house_no_in       IN       VARCHAR2,
      term_addr_l1_in        IN       VARCHAR2,
      term_addr_l2_in        IN       VARCHAR2,
      term_addr_l3_in        IN       VARCHAR2,
      term_addr_l4_in        IN       VARCHAR2,
      term_post_code_in      IN       VARCHAR2,
      term_mailsort_in       IN       VARCHAR2,
      last_updated_by        IN       VARCHAR2,
      stud_ref_no_out        OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   FUNCTION checkstudentssessionduplicate (
      stud_ref_no_in    IN   VARCHAR2,
      session_code_in   IN   VARCHAR2
   )
      RETURN NUMBER;
END pk_steps_ui_manual_reg;
/
