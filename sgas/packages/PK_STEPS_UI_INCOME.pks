CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_income
AS
/******************************************************************************
   NAME:       pk_steps_ui_INCOME
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        17/11/2008      PADDY GRACE           Created this package.
   1.1        20/04/2009      ABIRAMI CHIDAMBARAM   Code Population
   1.2        24/08/2010      Paddy Grace           Updated code
   1.3        11/12/2012      Paddy Grace           Moved benefactor income procedures to PK_STEPS_UI_BENEFACTORINCOME
******************************************************************************/
   PROCEDURE getincome (
      stud_session_id_in         IN              VARCHAR2,
      stud_hei_bursary_consent   OUT NOCOPY      VARCHAR2,
      parent_contrib_exempt      OUT NOCOPY      VARCHAR2,
      pay_ysb                    OUT NOCOPY      VARCHAR2,
      pay_isb                    OUT NOCOPY      VARCHAR2,
      care_leaver                OUT NOCOPY      VARCHAR2,
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
      pay_isb_in                    IN       VARCHAR2,
      care_leaver_in                IN       VARCHAR2,
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

   PROCEDURE getstudhasbenefactors (
      stud_session_id_in   IN       VARCHAR2,
      benefactorone        OUT      VARCHAR2,
      benefactortwo        OUT      VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   );
END pk_steps_ui_income;
/