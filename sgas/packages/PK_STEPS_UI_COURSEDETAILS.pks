CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_coursedetails
AS
/******************************************************************************
   NAME:       pk_steps_ui_COURSEDETAILS
   PURPOSE:    This package is used to retreive and alter information for the
               portlet project STEPS_UI_CourseDetails

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        20/11/2011  PADDY GRACE      Created this package.
   1.1        11/11/2015  E Watson         Removed getsupplementarystatus & supp_id 

******************************************************************************/
   TYPE termdates_cursor IS REF CURSOR;

   TYPE default_termdates_cursor IS REF CURSOR;
   
   TYPE supp_status_cursor IS REF CURSOR;
   
  
   PROCEDURE getdefaulttermdates (
      inst_code_in      IN              VARCHAR2,
      session_code_in   IN              VARCHAR2,
      io_cursor         IN OUT          default_termdates_cursor,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   );
   
   PROCEDURE getprovcaseflag (
    stud_crse_year_id_in    IN          VARCHAR2,
    provisional_case        OUT NOCOPY  VARCHAR2,
    error_boolean           OUT NOCOPY  VARCHAR2,
    ERROR_TEXT              OUT NOCOPY  VARCHAR2
);
   
    PROCEDURE updateprovisionalcase (
      stud_session_id_in  IN       VARCHAR2,
      provisional_in      IN       VARCHAR2,
      error_boolean       OUT      VARCHAR2,
      ERROR_TEXT          OUT      VARCHAR2
   );
   
   PROCEDURE gettermdates (
      stud_crse_year_id_in   IN              VARCHAR2,
      default_terms_out      OUT NOCOPY      VARCHAR2,
      io_cursor              IN OUT          termdates_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getmenuvariables (
      stud_crse_year_id_in   IN              VARCHAR2,
      scheme_type_out        OUT NOCOPY      VARCHAR2,
      session_code_out       OUT NOCOPY      VARCHAR2,
      inst_code_out          OUT NOCOPY      VARCHAR2,
      app_status_out         OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getcoursedetails (
      stud_crse_year_id_in             IN              VARCHAR2,
      study_commencement_session_out   OUT NOCOPY      VARCHAR2,
      session_code_out                 OUT NOCOPY      VARCHAR2,
      student_type_out                 OUT NOCOPY      VARCHAR2,
      scheme_type_out                  OUT NOCOPY      VARCHAR2,
      application_status_out           OUT NOCOPY      VARCHAR2,
      institution_code_out             OUT NOCOPY      VARCHAR2,
      course_code_out                  OUT NOCOPY      VARCHAR2,
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
      award_end_reason_out             OUT NOCOPY      NUMBER,
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
      attend_required_out              OUT NOCOPY      VARCHAR2,
      hei_payment_route_out            OUT NOCOPY      VARCHAR2,
      sds_data_consent_out             OUT NOCOPY      VARCHAR2,
      stud_hei_consent_out             OUT NOCOPY      VARCHAR2,
      is_currentlycalculated           OUT NOCOPY      VARCHAR2,
      is_pgcertdip                     OUT NOCOPY      VARCHAR2,
      is_erasmus                       OUT NOCOPY      VARCHAR2,
      is_latestscy                     OUT NOCOPY      VARCHAR2,
      is_psasnonloanfee                OUT NOCOPY      VARCHAR2,
      fee_override_amt_out             OUT NOCOPY      VARCHAR2,
      no_trace_out                     OUT NOCOPY      VARCHAR2,
      comp_jour_out                    OUT NOCOPY      VARCHAR2,
      is_nmsb_absence_out              OUT NOCOPY      VARCHAR2,
      nmsb_absence_return_date_out     OUT NOCOPY      DATE,
      is_covid_extension               OUT NOCOPY      VARCHAR2,
      is_dsa_only_out                  OUT NOCOPY      VARCHAR2,      
      error_boolean                    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                       OUT NOCOPY      VARCHAR2
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
      study_start_date_in             IN              VARCHAR2,
      psas_pt_in                      IN              VARCHAR2,
      sandwich_paid_in                IN              VARCHAR2,
      sandwich_unpaid_in              IN              VARCHAR2,
      course_change_date_in           IN              VARCHAR2,
      repeat_in                       IN              VARCHAR2,
      withdraw_date_in                IN              VARCHAR2,
      award_end_reason_in             IN              VARCHAR2,
      self_funding_in                 IN              VARCHAR2,
      missing_information_in          IN              VARCHAR2,
      non_attendance_actioned_in      IN              VARCHAR2,
      non_attendance_date_in          IN              VARCHAR2,
      z_refusal_status_in             IN              VARCHAR2,
      z_refusal_date_in               IN              VARCHAR2,
      z_refusal_cancelled_date_in     IN              VARCHAR2,
      bursary_deductions_in           IN              VARCHAR2,
      ispgce_in                       IN              VARCHAR2,
      crse_suspend_in                 IN              VARCHAR2,
      hei_payment_route_in            IN              VARCHAR2,
      sds_data_consent_in             IN              VARCHAR2,
      stud_hei_consent_in             IN              VARCHAR2,      
      is_psas_non_fee_loan_in         IN              VARCHAR2,
      variable_fee_override_amt_in    IN              VARCHAR2,
      no_trace_in                     IN              VARCHAR2,
      comp_jour_in                    IN              VARCHAR2,
      employee_in                     IN              VARCHAR2,
      is_nmsb_absence_in              IN              VARCHAR2,
      nmsb_absence_return_date_in     IN              VARCHAR2,
      is_covid_extension_in           IN              VARCHAR2,
      is_dsa_only_in                  IN              VARCHAR2,
      error_boolean                   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                      OUT NOCOPY      VARCHAR2
   );
   

END pk_steps_ui_coursedetails;
/
