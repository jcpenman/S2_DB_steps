/* Formatted on 2010/11/03 16:47 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_ui_course_dets
AS
/******************************************************************************
   NAME:       pk_steps_ui_COURSE_DETS
   PURPOSE:    This package is used to retreive and alter information for the
               portlet project STEPS_UI_CourseDetails

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008      PADDY GRACE Created this package.
   1.1        11/08/2009  Paddy Grace      Added NMSB procedures
******************************************************************************/
   TYPE termdates_cursor IS REF CURSOR;

   TYPE default_termdates_cursor IS REF CURSOR;

   PROCEDURE getcoursedetails (
      stud_crse_year_id_in             IN              VARCHAR2,
      study_commencement_session_out   OUT NOCOPY      VARCHAR2,
      student_type_out                 OUT NOCOPY      VARCHAR2,
      scheme_type_out                  OUT NOCOPY      VARCHAR2,
      application_status_out           OUT NOCOPY      VARCHAR2,
      institution_code_out             OUT NOCOPY      VARCHAR2,
      institution_name_out             OUT NOCOPY      VARCHAR2,
      course_code_out                  OUT NOCOPY      VARCHAR2,
      course_name_out                  OUT NOCOPY      VARCHAR2,
      crse_id_out                      OUT NOCOPY      VARCHAR2,
      education_level_out              OUT NOCOPY      VARCHAR2,
      subject_out                      OUT NOCOPY      VARCHAR2,
      course_year_out                  OUT NOCOPY      VARCHAR2,
      graduation_year_out              OUT NOCOPY      VARCHAR2,
      study_start_date_out             OUT NOCOPY      DATE,
      psas_pt_out                      OUT NOCOPY      VARCHAR2,
      sandwich_paid_out                OUT NOCOPY      VARCHAR2,
      sandwich_unpaid_out              OUT NOCOPY      VARCHAR2,
      repeat_out                       OUT NOCOPY      VARCHAR2,
      course_change_date_out           OUT NOCOPY      DATE,
      withdraw_date_out                OUT NOCOPY      DATE,
      self_funding_out                 OUT NOCOPY      VARCHAR2,
      missing_information_out          OUT NOCOPY      VARCHAR2,
      student_in_attendance_out        OUT NOCOPY      VARCHAR2,
      coa_date_out                     OUT NOCOPY      DATE,
      non_attendance_actioned_out      OUT NOCOPY      VARCHAR2,
      non_attendance_date_out          OUT NOCOPY      DATE,
      z_refusal_status_out             OUT NOCOPY      VARCHAR2,
      z_refusal_date_out               OUT NOCOPY      DATE,
      z_refusal_cancelled_date_out     OUT NOCOPY      DATE,
      bursary_deductions_out           OUT NOCOPY      VARCHAR2,
      ispgce_out                       OUT NOCOPY      VARCHAR2,
      crse_suspend_out                 OUT NOCOPY      VARCHAR2,
      error_boolean                    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE gettermdates (
      stud_crse_year_id_in   IN              VARCHAR2,
      default_terms_out      OUT NOCOPY      VARCHAR2,
      io_cursor              IN OUT          termdates_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getdefaulttermdates (
      inst_code_in      IN              VARCHAR2,
      session_code_in   IN              VARCHAR2,
      io_cursor         IN OUT          default_termdates_cursor,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getmenuvariables (
      stud_crse_year_id_in   IN              VARCHAR2,
      scheme_type_out        OUT NOCOPY      VARCHAR2,
      session_code_out       OUT NOCOPY      VARCHAR2,
      inst_code_out          OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setcoursedetails (
      stud_crse_year_id_in            IN              VARCHAR2,
      study_commencement_session_in   IN              VARCHAR2,
      application_status_in           IN              VARCHAR2,
      institution_code_in             IN              VARCHAR2,
      course_code_in                  IN              VARCHAR2,
      education_level_in              IN              VARCHAR2,
      subject_in                      IN              VARCHAR2,
      course_year_in                  IN              VARCHAR2,
      study_start_date_in             IN              DATE,
      psas_pt_in                      IN              VARCHAR2,
      sandwich_paid_in                IN              VARCHAR2,
      sandwich_unpaid_in              IN              VARCHAR2,
      course_change_date_in           IN              VARCHAR2,
      repeat_in                       IN              VARCHAR2,
      withdraw_date_in                IN              VARCHAR2,
      self_funding_in                 IN              VARCHAR2,
      missing_information_in          IN              VARCHAR2,
      non_attendance_actioned_in      IN              VARCHAR2,
      non_attendance_date_in          IN              DATE,
      z_refusal_status_in             IN              VARCHAR2,
      z_refusal_date_in               IN              DATE,
      z_refusal_cancelled_date_out    IN              DATE,
      bursary_deductions_in           IN              VARCHAR2,
      ispgce_in                       IN              VARCHAR2,
      crse_suspend_in                 IN              VARCHAR2,
      employee_in                     IN              VARCHAR2,
      error_boolean                   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE ispgcertdip (
      crse_id_in        IN              VARCHAR2,
      ispgcertdip_out   OUT             VARCHAR,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   );

   PROCEDURE iserasmus (
      stud_crse_year_id_in   IN              VARCHAR2,
      iserasmus_out          OUT             VARCHAR,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE islatestscy (
      stud_crse_year_id_in   IN              VARCHAR2,
      islatestscy_out        OUT             VARCHAR,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getnmsb (
      stud_crse_year_id_in     IN              VARCHAR2,
      nmsb_spec_arr_id_out     OUT NOCOPY      VARCHAR2,
      nmsb_spec_arr_type_out   OUT NOCOPY      VARCHAR2,
      start_date_out           OUT NOCOPY      VARCHAR2,
      end_date_out             OUT NOCOPY      VARCHAR2,
      recommence_date_out      OUT NOCOPY      VARCHAR2,
      length_of_spec_arr_out   OUT NOCOPY      VARCHAR2,
      reason_code_out          OUT NOCOPY      VARCHAR2,
      error_boolean            OUT NOCOPY      VARCHAR2,
      ERROR_TEXT               OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setnmsb (
      nmsb_spec_arr_id_in     IN              VARCHAR2,
      nmsb_spec_arr_type_in   IN              VARCHAR2,
      start_date_in           IN              DATE,
      end_date_in             IN              DATE,
      recommence_date_in      IN              DATE,
      reason_code_in          IN              VARCHAR2,
      employee_in             IN              VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   );

   PROCEDURE insertnmsb (
      stud_crse_year_id_in    IN              VARCHAR2,
      nmsb_spec_arr_type_in   IN              VARCHAR2,
      start_date_in           IN              DATE,
      end_date_in             IN              DATE,
      recommence_date_in      IN              DATE,
      reason_code_in          IN              VARCHAR2,
      employee_in             IN              VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   );

   PROCEDURE iscurrentlycalculated (
      stud_crse_year_id_in   IN              VARCHAR2,
      iscalculated           OUT             VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );
END pk_steps_ui_course_dets;
/