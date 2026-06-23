CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_income
AS
/******************************************************************************
   NAME:       pk_steps_ui_INCOME
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008      PADDY GRACE Created this package.
   1.1        20/04/2009      ABIRAMI CHIDAMBARAM   Code Population
   1.2        24/08/2010      Paddy Grace           Updated code
******************************************************************************/
   PROCEDURE getincome (
      stud_session_id_in         IN              VARCHAR2,
      stud_hei_bursary_consent   OUT NOCOPY      VARCHAR2,
      parent_contrib_exempt      OUT NOCOPY      VARCHAR2,
      pay_ysb                    OUT NOCOPY      VARCHAR2,
      net_income                 OUT NOCOPY      VARCHAR2,
      pension_income             OUT NOCOPY      VARCHAR2,
      trust_income               OUT NOCOPY      VARCHAR2,
      working_tax_credit         OUT NOCOPY      VARCHAR2,
      emp_supp_allowance         OUT NOCOPY      VARCHAR2,
      incapacity_benefit         OUT NOCOPY      VARCHAR2,
      income_support             OUT NOCOPY      VARCHAR2,
      invalidity_benefit         OUT NOCOPY      VARCHAR2,
      job_seekers_allowance      OUT NOCOPY      VARCHAR2,
      error_boolean              OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                 OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setincome (
      stud_session_id_in            IN       VARCHAR2,
      stud_hei_bursary_consent_in   IN       VARCHAR2,
      parent_cont_in                IN       VARCHAR2,
      pay_ysb_in                    IN       VARCHAR2,
      net_income_in                 IN       VARCHAR2,
      pension_inc_in                IN       VARCHAR2,
      trust_inc_in                  IN       VARCHAR2,
      work_tax_credit_in            IN       VARCHAR2,
      emp_supp_allow_in             IN       VARCHAR2,
      incap_benefit_in              IN       VARCHAR2,
      income_support_in             IN       VARCHAR2,
      invalid_benefit_in            IN       VARCHAR2,
      job_seek_allow_in             IN       VARCHAR2,
      user_in                       IN       VARCHAR2,
      error_boolean                 OUT      VARCHAR2,
      ERROR_TEXT                    OUT      VARCHAR2
   );

   PROCEDURE getbenefactorincome (
      ben_id_in                 IN              VARCHAR2,
      session_code_in           IN              VARCHAR2,
      paye_income               OUT NOCOPY      VARCHAR2,
      p60_req                   OUT NOCOPY      VARCHAR2,
      self_employment           OUT NOCOPY      VARCHAR2,
      sched_d_req               OUT NOCOPY      VARCHAR2,
      pension                   OUT NOCOPY      VARCHAR2,
      pension_cb                OUT NOCOPY      VARCHAR2,
      benefit                   OUT NOCOPY      VARCHAR2,
      benefit_cb                OUT NOCOPY      VARCHAR2,
      nat_savings_income        OUT NOCOPY      VARCHAR2,
      bank_interest             OUT NOCOPY      VARCHAR2,
      dividend                  OUT NOCOPY      VARCHAR2,
      other_income              OUT NOCOPY      VARCHAR2,
      other_deduct              OUT NOCOPY      VARCHAR2,
      unemployed                OUT NOCOPY      VARCHAR2,
      retired                   OUT NOCOPY      VARCHAR2,
      qa_received               OUT NOCOPY      VARCHAR2,
      suppress_reminder         OUT NOCOPY      VARCHAR2,
      income_status             OUT NOCOPY      VARCHAR2,
      req_sent_date             OUT NOCOPY      DATE,
      income_type               OUT NOCOPY      VARCHAR2,
      property                  OUT NOCOPY      VARCHAR2,
      sched_a_req               OUT NOCOPY      VARCHAR2,
      other_deducts_cb          OUT NOCOPY      VARCHAR2,
      working_tax_credit        OUT NOCOPY      VARCHAR2,
      ben_hei_bursary_consent   OUT NOCOPY      VARCHAR2,
      emp_supp_allowance        OUT NOCOPY      VARCHAR2,
      incapacity_benefit        OUT NOCOPY      VARCHAR2,
      income_support            OUT NOCOPY      VARCHAR2,
      invalidity_benefit        OUT NOCOPY      VARCHAR2,
      job_seekers_allowance     OUT NOCOPY      VARCHAR2,
      error_boolean             OUT             VARCHAR2,
      ERROR_TEXT                OUT             VARCHAR2
   );

   PROCEDURE setbenefactorincome (
      ben_id_in                    IN       VARCHAR2,
      session_code_in              IN       VARCHAR2,
      paye_income_in               IN       VARCHAR2,
      p60_req_in                   IN       VARCHAR2,
      self_employment_in           IN       VARCHAR2,
      sched_d_req_in               IN       VARCHAR2,
      pension_in                   IN       VARCHAR2,
      pension_cb_in                IN       VARCHAR2,
      benefit_in                   IN       VARCHAR2,
      benefit_cb_in                IN       VARCHAR2,
      nat_savings_income_in        IN       VARCHAR2,
      bank_interest_in             IN       VARCHAR2,
      dividend_in                  IN       VARCHAR2,
      other_income_in              IN       VARCHAR2,
      other_deduct_in              IN       VARCHAR2,
      unemployed_in                IN       VARCHAR2,
      retired_in                   IN       VARCHAR2,
      qa_received_in               IN       VARCHAR2,
      suppress_reminder_in         IN       VARCHAR2,
      income_status_in             IN       VARCHAR2,
      req_sent_date_in             IN       DATE,
      income_type_in               IN       VARCHAR2,
      property_in                  IN       VARCHAR2,
      sched_a_req_in               IN       VARCHAR2,
      other_deducts_cb_in          IN       VARCHAR2,
      working_tax_credit_in        IN       VARCHAR2,
      ben_hei_bursary_consent_in   IN       VARCHAR2,
      emp_supp_allowance_in        IN       VARCHAR2,
      incapacity_benefit_in        IN       VARCHAR2,
      income_support_in            IN       VARCHAR2,
      invalidity_benefit_in        IN       VARCHAR2,
      job_seekers_allowance_in     IN       VARCHAR2,
      user_in                      IN       VARCHAR2,
      error_boolean                OUT      VARCHAR2,
      ERROR_TEXT                   OUT      VARCHAR2
   );

   PROCEDURE insertbenefactorincome (
      ben_id_in                    IN       VARCHAR2,
      session_code_in              IN       VARCHAR2,
      income_type_in               IN       VARCHAR2,
      income_status_in             IN       VARCHAR2,
      retired_in                   IN       VARCHAR2,
      unemployed_in                IN       VARCHAR2,
      bank_interest_in             IN       VARCHAR2,
      benefit_in                   IN       VARCHAR2,
      other_income_in              IN       VARCHAR2,
      nat_saving_interest_in       IN       VARCHAR2,
      paye_income_in               IN       VARCHAR2,
      pension_in                   IN       VARCHAR2,
      self_employment_in           IN       VARCHAR2,
      property_in                  IN       VARCHAR2,
      sched_a_req_in               IN       VARCHAR2,
      dividend_in                  IN       VARCHAR2,
      other_deduct_in              IN       VARCHAR2,
      p60_req_in                   IN       VARCHAR2,
      sched_d_req_in               IN       VARCHAR2,
      supp_reminder_in             IN       VARCHAR2,
      req_sent_date_in             IN       VARCHAR2,
      pension_cb_in                IN       VARCHAR2,
      benefit_cb_in                IN       VARCHAR2,
      oth_deducts_cb_in            IN       VARCHAR2,
      qa_received_in               IN       VARCHAR2,
      ben_hei_bursary_consent_in   IN       VARCHAR2,
      working_tax_credit_in        IN       VARCHAR2,
      emp_supp_allowance_in        IN       VARCHAR2,
      incapacity_benefit_in        IN       VARCHAR2,
      income_support_in            IN       VARCHAR2,
      invalidity_benefit_in        IN       VARCHAR2,
      jobseekers_allowance_in      IN       VARCHAR2,
      user_in                      IN       VARCHAR2,
      error_boolean                OUT      VARCHAR2,
      ERROR_TEXT                   OUT      VARCHAR2
   );
 PROCEDURE studHasBenefactors (      
      stud_session_id_in           IN       VARCHAR2,
      benefactorOne                OUT      VARCHAR2,
      benefactorTwo                OUT      VARCHAR2,
      error_boolean                OUT      VARCHAR2,
      ERROR_TEXT                   OUT      VARCHAR2
   );   
END pk_steps_ui_income;
/
