CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_grass_student_det
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
   )
   IS
   BEGIN
   
      SELECT std.ni_no, std.title, std.initials, std.forenames, std.surname,
             std.birth_forenames, std.birth_surname, to_char(std.dob,'dd/MM/yyyy'), std.sex, std.marital_status,
             to_char(std.marriage_date, 'dd/MM/yyyy'), std.birth_country_code, std.residence_country_code,
             std.nation_country_code, std.district_birth_cert_issued, std.email_addr,
             sha.tele_no, std.mobile_tel_no, std.sort_code, std.account_no
      INTO ni_no_out,title_out, initials_out, forenames_out, surname_out,
            birth_forenames_out, birth_surname_out, dob_out, sex_out, marital_status_out,
            marriage_date_out, birth_country_code_out, residence_country_code_out,
            nation_country_code_out, district_birth_cert_out, email_addr_out,
            tele_no_out, mobile_tel_no_out, sort_code_out, account_no_out
      FROM  stud @ grass std, stud_home_addr @ grass sha
      WHERE std.stud_ref_no = sha.stud_ref_no
      AND sha.end_date is null
      AND std.stud_ref_no = stud_ref_no_in;
   
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getpersonaldetails;
END pk_steps_ui_grass_student_det;
/
