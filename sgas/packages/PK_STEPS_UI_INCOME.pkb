CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_income
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
   )
   IS
   BEGIN
      SELECT ss.stud_hei_bursary_consent AS stud_hei_bursary_consent,
             scy.parent_contrib_exempt AS parent_contrib_exempt,
             scy.pay_ysb AS pay_ysb, scy.pay_isb AS pay_isb,
             ss.care_leaver AS care_leaver,
             ss.net_income AS net_income,
             ss.pension_income AS pension_income,
             ss.trust_income AS trust_income,
             ss.working_tax_credit AS working_tax_credit,
             ss.employment_support_allowance AS emp_supp_allowance,
             ss.incapacity_benefit AS incapacity_benefit,
             ss.income_support AS income_support,
             ss.invalidity_benefit AS invalidity_benefit,
             ss.jobseekers_allowance AS job_seekers_allowance
        INTO stud_hei_bursary_consent,
             parent_contrib_exempt,
             pay_ysb, pay_isb,
             care_leaver,
             net_income,
             pension_income,
             trust_income,
             working_tax_credit,
             emp_supp_allowance,
             incapacity_benefit,
             income_support,
             invalidity_benefit,
             job_seekers_allowance
        FROM stud_session ss, stud_crse_year scy
       WHERE scy.stud_session_id = ss.stud_session_id
         AND scy.latest_crse_ind = 'Y'
         AND ss.stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getincome;

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
   )
   IS
   BEGIN
      UPDATE stud_crse_year scy
         SET scy.parent_contrib_exempt = UPPER (parent_cont_in),
             scy.pay_ysb = UPPER (pay_ysb_in),
             scy.pay_isb = UPPER (pay_isb_in),
             scy.last_updated_by = UPPER (user_in),
             scy.last_updated_on = SYSDATE
       WHERE scy.stud_session_id = stud_session_id_in;

      UPDATE stud_session ss
         SET ss.stud_hei_bursary_consent = UPPER (stud_hei_bursary_consent_in),
             ss.care_leaver = UPPER (care_leaver_in),
             ss.net_income = net_income_in,
             ss.pension_income = pension_inc_in,
             ss.trust_income = trust_inc_in,
             ss.working_tax_credit = work_tax_credit_in,
             ss.employment_support_allowance = UPPER (emp_supp_allow_in),
             ss.incapacity_benefit = UPPER (incap_benefit_in),
             ss.income_support = UPPER (income_support_in),
             ss.invalidity_benefit = UPPER (invalid_benefit_in),
             ss.jobseekers_allowance = UPPER (job_seek_allow_in),
             ss.last_updated_by = UPPER (user_in),
             ss.last_updated_on = SYSDATE
       WHERE ss.stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setincome;

   PROCEDURE getstudhasbenefactors (
      stud_session_id_in   IN       VARCHAR2,
      benefactorone        OUT      VARCHAR2,
      benefactortwo        OUT      VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   )
   IS
   BEGIN
      SELECT 'true', 'true'
        INTO benefactorone, benefactortwo
        FROM stud_session sts
       WHERE sts.stud_session_id = stud_session_id_in
         AND sts.ben1_rel_id IS NOT NULL
         AND sts.ben2_rel_id IS NOT NULL
      UNION
      SELECT 'true', 'false'
        FROM stud_session sts
       WHERE sts.stud_session_id = stud_session_id_in
         AND sts.ben1_rel_id IS NOT NULL
         AND sts.ben2_rel_id IS NULL
      UNION
      SELECT 'false', 'false'
        FROM stud_session sts
       WHERE sts.stud_session_id = stud_session_id_in
         AND sts.ben1_rel_id IS NULL
         AND sts.ben2_rel_id IS NULL;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstudhasbenefactors;
END pk_steps_ui_income;
/