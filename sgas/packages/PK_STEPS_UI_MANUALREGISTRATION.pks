/* Formatted on 2011/09/07 16:15 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_ui_manualregistration
AS
/******************************************************************************
   NAME:       PK_STEPS_UI_ManualRegistration
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        29/08/2011  Paddy Grace      Created this package.
******************************************************************************/
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
      birth_country       OUT      VARCHAR2,
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
      is_existing         OUT      VARCHAR2
   );

   PROCEDURE createstudentrecords (
      stud_ref_no_in         IN       VARCHAR2,
      debt_only_in           IN       VARCHAR2,
      nino_in                IN       VARCHAR2,
      title_in               IN       VARCHAR2,
      forename_in            IN       VARCHAR2,
      surname_in             IN       VARCHAR2,
      dob_in                 IN       DATE,
      sex_in                 IN       VARCHAR2,
      marital_status_in      IN       VARCHAR2,
      birth_district_in      IN       VARCHAR2,
      birth_country_in       IN       VARCHAR2,
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
      scheme_type_in         IN       VARCHAR2,
      session_in             IN       VARCHAR2,
      inst_code_in           IN       VARCHAR2,
      crse_code_in           IN       VARCHAR2,
      crse_yr_no_in          IN       VARCHAR2,
      employee_in            IN       VARCHAR2,
      stud_ref_no_out        OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   FUNCTION checkstudentssessionduplicate (
      stud_ref_no_in    IN   VARCHAR2,
      session_code_in   IN   VARCHAR2
   )
      RETURN NUMBER;
END pk_steps_ui_manualregistration;
/