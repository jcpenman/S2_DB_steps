CREATE OR REPLACE PACKAGE SGAS.pk_steps_award_report
AS
/******************************************************************************
   NAME:       pk_poc_award_report
   PURPOSE:

   REVISIONS:
   Ver        Date        Author            Description
   ---------  ----------  ---------------   ------------------------------------
   1.0        27/10/2011  A.Bowman          Created this package.
******************************************************************************/
   TYPE assessed_awards_cursor IS REF CURSOR;
   TYPE assessed_instalments_cursor IS REF CURSOR;
   TYPE assessed_instls_tots_cursor IS REF CURSOR;

   PROCEDURE get_header_info (
      stud_crse_year_id_in          IN              VARCHAR2,
      date_out                      OUT NOCOPY      VARCHAR2,
      session_out                   OUT NOCOPY      VARCHAR2,
      student_out                   OUT NOCOPY      VARCHAR2,
      name_out                      OUT NOCOPY      VARCHAR2,
      inst_code_out                 OUT NOCOPY      VARCHAR2,
      inst_name_out                 OUT NOCOPY      VARCHAR2,
      course_code_out               OUT NOCOPY      VARCHAR2,
      course_name_out               OUT NOCOPY      VARCHAR2,
      course_year_out               OUT NOCOPY      VARCHAR2,
      scheme_out                    OUT NOCOPY      VARCHAR2,
      student_type_out              OUT NOCOPY      VARCHAR2,
      loan_given_out                OUT NOCOPY      VARCHAR2,
      fee_loan_given_out            OUT NOCOPY      VARCHAR2,
      max_loan_requested_out        OUT NOCOPY      VARCHAR2,
      loan_request_out              OUT NOCOPY      VARCHAR2,
      max_fee_loan_requested_out    OUT NOCOPY      VARCHAR2,
      fee_loan_request_amount_out   OUT NOCOPY      VARCHAR2,
      student_contribution_out      OUT NOCOPY      VARCHAR2,
      parental_contribution_out     OUT NOCOPY      VARCHAR2,
      spouse_contribution_out       OUT NOCOPY      VARCHAR2,
      total_used_contribution_out   OUT NOCOPY      VARCHAR2,
      residual_contribution_out     OUT NOCOPY      VARCHAR2,
      fee_entitlement_out           OUT NOCOPY      VARCHAR2,
      fee_type_out                  OUT NOCOPY      VARCHAR2,
      total_student_debt_out        OUT NOCOPY      VARCHAR2,
      active_student_debt_out       OUT NOCOPY      VARCHAR2,
      deferred_student_debt_out     OUT NOCOPY      VARCHAR2,
      total_nmsb_debt_out           OUT NOCOPY      VARCHAR2,
      active_nmsb_debt_out          OUT NOCOPY      VARCHAR2,
      deferred_nmsb_debt_out        OUT NOCOPY      VARCHAR2,
      error_boolean                 OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                    OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_assessed_awards (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          assessed_awards_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

 PROCEDURE get_assessed_instalments (
      award_id_in                IN              VARCHAR2,
      io_cursor                  IN OUT          assessed_instalments_cursor,
      error_boolean              OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                 OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_assessed_instalment_totals (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          assessed_instls_tots_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );
END pk_steps_award_report;
/
