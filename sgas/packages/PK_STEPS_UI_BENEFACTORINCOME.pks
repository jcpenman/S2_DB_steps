CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_benefactorincome
AS
/******************************************************************************
   NAME:       pk_steps_ui_benefactorincome
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        11/12/2012   PADDY GRACE           Created this package, populated code.
   1.1        24/07/2015   E Watson              Added procedure updateallprovflags Steps Defects 192
   1.2        11/11/2015   E Watson              Added reason_no_ben_income_id & other_income_details

******************************************************************************/
   PROCEDURE getbenefactorincome (
      ben_id_in                 IN              VARCHAR2,
      session_code_in           IN              VARCHAR2,
      paye_income               OUT NOCOPY      VARCHAR2,
      self_employment           OUT NOCOPY      VARCHAR2,
      pension                   OUT NOCOPY      VARCHAR2,
      benefit                   OUT NOCOPY      VARCHAR2,
      nat_savings_income        OUT NOCOPY      VARCHAR2,
      bank_interest             OUT NOCOPY      VARCHAR2,
      dividend                  OUT NOCOPY      VARCHAR2,
      property                  OUT NOCOPY      VARCHAR2,
      working_tax_credit        OUT NOCOPY      VARCHAR2,
      other_income              OUT NOCOPY      VARCHAR2,
      other_deduct              OUT NOCOPY      VARCHAR2,
      p60_req                   OUT NOCOPY      VARCHAR2,
      sched_d_req               OUT NOCOPY      VARCHAR2,
      pension_cb                OUT NOCOPY      VARCHAR2,
      benefit_cb                OUT NOCOPY      VARCHAR2,
      working_tax_credit_cb     OUT NOCOPY      VARCHAR2,
      sched_a_req               OUT NOCOPY      VARCHAR2,
      other_deducts_cb          OUT NOCOPY      VARCHAR2,
      ben_hei_bursary_consent   OUT NOCOPY      VARCHAR2,
      emp_supp_allowance        OUT NOCOPY      VARCHAR2,
      incapacity_benefit        OUT NOCOPY      VARCHAR2,
      income_support            OUT NOCOPY      VARCHAR2,
      invalidity_benefit        OUT NOCOPY      VARCHAR2,
      job_seekers_allowance     OUT NOCOPY      VARCHAR2,
      maintenance_payment       OUT NOCOPY      VARCHAR2,
      unemployed                OUT NOCOPY      VARCHAR2,
      retired                   OUT NOCOPY      VARCHAR2,
      qa_received               OUT NOCOPY      VARCHAR2,
      suppress_reminder         OUT NOCOPY      VARCHAR2,
      income_status             OUT NOCOPY      VARCHAR2,
      income_type               OUT NOCOPY      VARCHAR2,
      reason_no_income          OUT NOCOPY      VARCHAR2,
      reason_no_ben_income_id   OUT NOCOPY      VARCHAR2,
      other_income_details      OUT NOCOPY      VARCHAR2,
      req_sent_date             OUT NOCOPY      DATE,
      error_boolean             OUT             VARCHAR2,
      ERROR_TEXT                OUT             VARCHAR2
   );

   PROCEDURE setbenefactorincome (
      ben_id_in                    IN       VARCHAR2,
      session_code_in              IN       VARCHAR2,
      paye_income_in               IN       VARCHAR2,
      self_employment_in           IN       VARCHAR2,
      pension_in                   IN       VARCHAR2,
      benefit_in                   IN       VARCHAR2,
      nat_savings_income_in        IN       VARCHAR2,
      bank_interest_in             IN       VARCHAR2,
      dividend_in                  IN       VARCHAR2,
      property_in                  IN       VARCHAR2,
      working_tax_credit_in        IN       VARCHAR2,
      other_income_in              IN       VARCHAR2,
      other_deduct_in              IN       VARCHAR2,
      p60_req_in                   IN       VARCHAR2,
      sched_d_req_in               IN       VARCHAR2,
      pension_cb_in                IN       VARCHAR2,
      benefit_cb_in                IN       VARCHAR2,
      working_tax_credit_cb_in     IN       VARCHAR2,
      sched_a_req_in               IN       VARCHAR2,
      other_deducts_cb_in          IN       VARCHAR2,
      ben_hei_bursary_consent_in   IN       VARCHAR2,
      emp_supp_allowance_in        IN       VARCHAR2,
      incapacity_benefit_in        IN       VARCHAR2,
      income_support_in            IN       VARCHAR2,
      invalidity_benefit_in        IN       VARCHAR2,
      job_seekers_allowance_in     IN       VARCHAR2,
      maintenance_payment_in       IN       VARCHAR2,
      unemployed_in                IN       VARCHAR2,
      retired_in                   IN       VARCHAR2,
      qa_received_in               IN       VARCHAR2,
      suppress_reminder_in         IN       VARCHAR2,
      income_status_in             IN       VARCHAR2,
      income_type_in               IN       VARCHAR2,
      reason_no_income_in          IN       VARCHAR2,
      reason_no_ben_income_id_in   IN       VARCHAR2,
      other_income_details_in      IN       VARCHAR2,
      req_sent_date_in             IN       DATE,
      user_in                      IN       VARCHAR2,
      error_boolean                OUT      VARCHAR2,
      ERROR_TEXT                   OUT      VARCHAR2
   );

   PROCEDURE insertbenefactorincome (
      ben_id_in                    IN       VARCHAR2,
      session_code_in              IN       VARCHAR2,
      paye_income_in               IN       VARCHAR2,
      self_employment_in           IN       VARCHAR2,
      pension_in                   IN       VARCHAR2,
      benefit_in                   IN       VARCHAR2,
      nat_saving_interest_in       IN       VARCHAR2,
      bank_interest_in             IN       VARCHAR2,
      dividend_in                  IN       VARCHAR2,
      property_in                  IN       VARCHAR2,
      working_tax_credit_in        IN       VARCHAR2,
      other_income_in              IN       VARCHAR2,
      other_deduct_in              IN       VARCHAR2,
      p60_req_in                   IN       VARCHAR2,
      sched_d_req_in               IN       VARCHAR2,
      pension_cb_in                IN       VARCHAR2,
      benefit_cb_in                IN       VARCHAR2,
      working_tax_credit_cb_in     IN       VARCHAR2,
      sched_a_req_in               IN       VARCHAR2,
      oth_deducts_cb_in            IN       VARCHAR2,
      ben_hei_bursary_consent_in   IN       VARCHAR2,
      emp_supp_allowance_in        IN       VARCHAR2,
      incapacity_benefit_in        IN       VARCHAR2,
      income_support_in            IN       VARCHAR2,
      invalidity_benefit_in        IN       VARCHAR2,
      jobseekers_allowance_in      IN       VARCHAR2,
      maintenance_payment_in       IN       VARCHAR2,
      unemployed_in                IN       VARCHAR2,
      retired_in                   IN       VARCHAR2,
      qa_received_in               IN       VARCHAR2,
      supp_reminder_in             IN       VARCHAR2,
      income_status_in             IN       VARCHAR2,
      income_type_in               IN       VARCHAR2,
      reason_no_income_in          IN       VARCHAR2,
      reason_no_ben_income_id_in   IN       VARCHAR2,
      other_income_details_in      IN       VARCHAR2,
      req_sent_date_in             IN       VARCHAR2,
      user_in                      IN       VARCHAR2,
      error_boolean                OUT      VARCHAR2,
      ERROR_TEXT                   OUT      VARCHAR2
   );

   PROCEDURE getsummaryofincome (
      stud_session_id_in   IN       VARCHAR2,
      stud_income_out      OUT      VARCHAR2,
      ben1_income_out      OUT      VARCHAR2,
      ben2_income_out      OUT      VARCHAR2,
      total_out            OUT      VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   );
   
      PROCEDURE updateallprovflags (ben_id_in         IN     VARCHAR2,
                                    session_code_in   IN     VARCHAR2,
                                    error_boolean     OUT    VARCHAR2,
                                    ERROR_TEXT        OUT    VARCHAR2);
END pk_steps_ui_benefactorincome;
/