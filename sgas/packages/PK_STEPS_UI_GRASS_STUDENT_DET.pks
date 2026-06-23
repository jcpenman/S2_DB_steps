CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_grass_student_det
AS
/******************************************************************************
   NAME:       PK_STEPS_UI_GRASS_STUDENT_DET
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        24/02/2012    John Wynne     Created this package.
******************************************************************************/
   PROCEDURE getpersonaldetails (
      stud_ref_no_in               IN              VARCHAR2,
      ni_no_out                    OUT             VARCHAR2,
      title_out                    OUT             VARCHAR2,
      initials_out                 OUT             VARCHAR2,
      forenames_out                OUT             VARCHAR2,
      surname_out                  OUT             VARCHAR2,
      birth_forenames_out          OUT             VARCHAR2,
      birth_surname_out            OUT             VARCHAR2,
      dob_out                      OUT             VARCHAR2,
      sex_out                      OUT             VARCHAR2,
      marital_status_out           OUT             VARCHAR2,
      marriage_date_out            OUT             VARCHAR2,
      birth_country_code_out       OUT             VARCHAR2,
      residence_country_code_out   OUT             VARCHAR2,
      nation_country_code_out      OUT             VARCHAR2,
      district_birth_cert_out      OUT             VARCHAR2,
      email_addr_out               OUT             VARCHAR2,
      tele_no_out                  OUT             VARCHAR2,
      mobile_tel_no_out            OUT             VARCHAR2,
      sort_code_out                OUT             VARCHAR2,
      account_no_out               OUT             VARCHAR2,
      error_boolean                OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                   OUT NOCOPY      VARCHAR2
   );
END pk_steps_ui_grass_student_det;
/
