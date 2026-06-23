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
   )
   IS
   BEGIN
      SELECT ss.stud_hei_bursary_consent AS stud_hei_bursary_consent,
             scy.parent_contrib_exempt AS parent_contrib_exempt,
             scy.pay_ysb AS pay_ysb, ss.net_income AS net_income,
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
             pay_ysb, net_income,
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
             scy.last_updated_by = UPPER (user_in),
             scy.last_updated_on = SYSDATE
       WHERE scy.stud_session_id = stud_session_id_in;

      UPDATE stud_session ss
         SET ss.stud_hei_bursary_consent = stud_hei_bursary_consent_in,
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
   )
   IS
   BEGIN
      SELECT bi.paye_income, bi.p60_req, bi.self_employment, bi.sched_d_req,
             bi.pension, bi.pension_cb, bi.benefit, bi.benefit_cb,
             bi.nat_saving_interest, bi.bank_interest, bi.dividend,
             bi.other_income, bi.other_deduct, bi.unemployed, bi.retired,
             bi.qa_received, bi.suppress_reminder, bi.income_status,
             bi.reminder_date, bi.income_type, bi.property, bi.sched_a_req,
             bi.oth_deducts_cb, bi.working_tax_credit,
             bi.ben_hei_bursary_consent, bi.employment_support_allowance,
             bi.incapacity_benefit, bi.income_support,
             bi.invalidity_benefit, bi.jobseekers_allowance
        INTO paye_income, p60_req, self_employment, sched_d_req,
             pension, pension_cb, benefit, benefit_cb,
             nat_savings_income, bank_interest, dividend,
             other_income, other_deduct, unemployed, retired,
             qa_received, suppress_reminder, income_status,
             req_sent_date, income_type, property, sched_a_req,
             other_deducts_cb, working_tax_credit,
             ben_hei_bursary_consent, emp_supp_allowance,
             incapacity_benefit, income_support,
             invalidity_benefit, job_seekers_allowance
        FROM benefactor_income bi
       WHERE bi.ben_id = ben_id_in AND bi.session_code = session_code_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getbenefactorincome;

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
   )
   IS
   BEGIN
      UPDATE benefactor_income bi
         SET bi.paye_income = paye_income_in,
             bi.p60_req = UPPER (p60_req_in),
             bi.self_employment = self_employment_in,
             bi.sched_d_req = UPPER (sched_d_req_in),
             bi.pension = pension_in,
             bi.pension_cb = UPPER (pension_cb_in),
             bi.benefit = benefit_in,
             bi.benefit_cb = UPPER (benefit_cb_in),
             bi.nat_saving_interest = nat_savings_income_in,
             bi.bank_interest = bank_interest_in,
             bi.dividend = dividend_in,
             bi.other_income = other_income_in,
             bi.other_deduct = other_deduct_in,
             bi.unemployed = UPPER (unemployed_in),
             bi.retired = UPPER (retired_in),
             bi.qa_received = UPPER (qa_received_in),
             bi.suppress_reminder = UPPER (suppress_reminder_in),
             bi.income_status = UPPER (income_status_in),
             bi.income_type = UPPER (income_type_in),
             bi.property = property_in,
             bi.oth_deducts_cb = UPPER (other_deducts_cb_in),
             bi.working_tax_credit = working_tax_credit_in,
             bi.ben_hei_bursary_consent = UPPER (ben_hei_bursary_consent_in),
             bi.employment_support_allowance = UPPER (emp_supp_allowance_in),
             bi.incapacity_benefit = UPPER (incapacity_benefit_in),
             bi.income_support = UPPER (income_support_in),
             bi.invalidity_benefit = UPPER (invalidity_benefit_in),
             bi.jobseekers_allowance = UPPER (job_seekers_allowance_in),
             bi.last_updated_by = UPPER (user_in)
       WHERE bi.ben_id = ben_id_in AND bi.session_code = session_code_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setbenefactorincome;

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
   )
   IS
   BEGIN
      INSERT INTO benefactor_income bi
                  (bi.ben_id, bi.session_code, bi.income_type,
                   bi.income_status, bi.retired,
                   bi.unemployed, bi.bank_interest, bi.benefit,
                   bi.other_income, bi.nat_saving_interest, bi.paye_income,
                   bi.pension, bi.self_employment, bi.property,
                   bi.sched_a_req, bi.dividend, bi.other_deduct,
                   bi.p60_req, bi.sched_d_req,
                   bi.suppress_reminder, bi.pension_cb,
                   bi.benefit_cb, bi.oth_deducts_cb,
                   bi.qa_received,
                   bi.ben_hei_bursary_consent,
                   bi.working_tax_credit, bi.employment_support_allowance,
                   bi.incapacity_benefit, bi.income_support,
                   bi.invalidity_benefit,
                   bi.jobseekers_allowance, bi.last_updated_by,
                   bi.last_updated_on
                  )
           VALUES (ben_id_in, session_code_in, UPPER (income_type_in),
                   UPPER (income_status_in), UPPER (retired_in),
                   UPPER (unemployed_in), bank_interest_in, benefit_in,
                   other_income_in, nat_saving_interest_in, paye_income_in,
                   pension_in, self_employment_in, property_in,
                   sched_a_req_in, dividend_in, other_deduct_in,
                   UPPER (p60_req_in), UPPER (sched_d_req_in),
                   UPPER (supp_reminder_in), UPPER (pension_cb_in),
                   UPPER (benefit_cb_in), UPPER (oth_deducts_cb_in),
                   UPPER (qa_received_in),
                   UPPER (ben_hei_bursary_consent_in),
                   working_tax_credit_in, UPPER (emp_supp_allowance_in),
                   UPPER (incapacity_benefit_in), UPPER (income_support_in),
                   UPPER (invalidity_benefit_in),
                   UPPER (jobseekers_allowance_in), UPPER (user_in),
                   SYSDATE
                  );

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertbenefactorincome;
   PROCEDURE studHasBenefactors (      
      stud_session_id_in           IN       VARCHAR2,
      benefactorOne                OUT      VARCHAR2,
      benefactorTwo                OUT      VARCHAR2,
      error_boolean                OUT      VARCHAR2,
      ERROR_TEXT                   OUT      VARCHAR2
   )
   IS
   BEGIN
       SELECT 'true', 'true'
       INTO benefactorOne, benefactorTwo
       FROM stud_session sts
       WHERE STS.STUD_SESSION_ID = stud_session_id_in
       AND STS.BEN1_REL_ID IS NOT NULL
       AND STS.BEN2_REL_ID IS NOT NULL
       UNION
       SELECT 'true', 'false' 
       FROM stud_session sts
       WHERE STS.STUD_SESSION_ID = stud_session_id_in
       AND STS.BEN1_REL_ID IS NOT NULL
       AND STS.BEN2_REL_ID IS NULL    
       UNION
       SELECT 'false', 'false' 
       FROM stud_session sts
       WHERE STS.STUD_SESSION_ID = stud_session_id_in
       AND STS.BEN1_REL_ID IS NULL
       AND STS.BEN2_REL_ID IS NULL;           
       
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END studHasBenefactors;   
END pk_steps_ui_income;
/
