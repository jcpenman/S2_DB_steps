CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_benefactorincome
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
   FUNCTION get_benefactor_total (
      p_ben_id         IN   VARCHAR2,
      p_session_code        VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_paye               VARCHAR2 (10);
      v_self_emp           VARCHAR2 (10);
      v_prop               VARCHAR2 (10);
      v_pension            VARCHAR2 (10);
      v_benefit            VARCHAR2 (10);
      v_nat_sav            VARCHAR2 (10);
      v_bank_int           VARCHAR2 (10);
      v_dividend           VARCHAR2 (10);
      v_other_inc          VARCHAR2 (10);
      v_work_tax           VARCHAR2 (10);
      v_other_ded          VARCHAR2 (10);
      v_benefactor_total   VARCHAR2 (10);
      v_income_count       VARCHAR (10);
   BEGIN
      IF p_ben_id IS NOT NULL
      THEN
         SELECT COUNT (*)
           INTO v_income_count
           FROM benefactor_income bi
          WHERE bi.ben_id = p_ben_id AND bi.session_code = p_session_code;

         IF v_income_count > 0
         THEN
            SELECT NVL (bi.paye_income, 0), NVL (bi.self_employment, 0),
                   NVL (bi.property, 0), NVL (bi.pension, 0),
                   NVL (bi.benefit, 0), NVL (bi.nat_saving_interest, 0),
                   NVL (bi.bank_interest, 0), NVL (bi.dividend, 0),
                   NVL (bi.other_income, 0), NVL (bi.working_tax_credit, 0),
                   NVL (bi.other_deduct, 0)
              INTO v_paye, v_self_emp,
                   v_prop, v_pension,
                   v_benefit, v_nat_sav,
                   v_bank_int, v_dividend,
                   v_other_inc, v_work_tax,
                   v_other_ded
              FROM benefactor_income bi
             WHERE bi.ben_id = p_ben_id AND bi.session_code = p_session_code;

            v_benefactor_total :=
                 v_paye
               + v_self_emp
               + v_prop
               + v_pension
               + v_benefit
               + v_nat_sav
               + v_bank_int
               + v_dividend
               + v_other_inc
               + v_work_tax
               - v_other_ded;
         ELSE
            v_benefactor_total := 0;
         END IF;
      ELSE
         v_benefactor_total := 0;
      END IF;

      RETURN v_benefactor_total;
   END get_benefactor_total;

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
   )
   IS
   BEGIN
      SELECT bi.paye_income, bi.self_employment, bi.pension, bi.benefit,
             bi.nat_saving_interest, bi.bank_interest, bi.dividend,
             bi.property, bi.working_tax_credit, bi.other_income,
             bi.other_deduct, NVL (bi.p60_req, 'N'),
             NVL (bi.sched_d_req, 'N'), NVL (bi.pension_cb, 'N'),
             NVL (bi.benefit_cb, 'N'), NVL (bi.wtc_cb, 'N'),
             NVL (bi.sched_a_req, 'N'), NVL (bi.oth_deducts_cb, 'N'),
             NVL (bi.ben_hei_bursary_consent, 'N'),
             NVL (bi.employment_support_allowance, 'N'),
             NVL (bi.incapacity_benefit, 'N'), NVL (bi.income_support, 'N'),
             NVL (bi.invalidity_benefit, 'N'),
             NVL (bi.jobseekers_allowance, 'N'),
             NVL (bi.maintenance_payment, 'N'), NVL (bi.unemployed, 'N'),
             NVL (bi.retired, 'N'), NVL (bi.qa_received, 'N'),
             NVL (bi.suppress_reminder, 'N'), bi.income_status,
             bi.income_type, bi.reason_no_income, bi.reminder_date,
             bi.reason_no_ben_income_id, bi.other_income_details
        INTO paye_income, self_employment, pension, benefit,
             nat_savings_income, bank_interest, dividend,
             property, working_tax_credit, other_income,
             other_deduct, p60_req,
             sched_d_req, pension_cb,
             benefit_cb, working_tax_credit_cb,
             sched_a_req, other_deducts_cb,
             ben_hei_bursary_consent,
             emp_supp_allowance,
             incapacity_benefit, income_support,
             invalidity_benefit,
             job_seekers_allowance,
             maintenance_payment, unemployed,
             retired, qa_received,
             suppress_reminder, income_status,
             income_type, reason_no_income, req_sent_date, 
             reason_no_ben_income_id, other_income_details
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
   )
   IS
   BEGIN
      UPDATE benefactor_income bi
         SET bi.paye_income = paye_income_in,
             bi.self_employment = self_employment_in,
             bi.pension = pension_in,
             bi.benefit = benefit_in,
             bi.nat_saving_interest = nat_savings_income_in,
             bi.bank_interest = bank_interest_in,
             bi.dividend = dividend_in,
             bi.property = property_in,
             bi.working_tax_credit = working_tax_credit_in,
             bi.other_income = other_income_in,
             bi.other_deduct = other_deduct_in,
             bi.p60_req = UPPER (p60_req_in),
             bi.sched_d_req = UPPER (sched_d_req_in),
             bi.pension_cb = UPPER (pension_cb_in),
             bi.benefit_cb = UPPER (benefit_cb_in),
             bi.wtc_cb = UPPER (working_tax_credit_cb_in),
             bi.sched_a_req = UPPER (sched_a_req_in),
             bi.oth_deducts_cb = UPPER (other_deducts_cb_in),
             bi.ben_hei_bursary_consent = UPPER (ben_hei_bursary_consent_in),
             bi.employment_support_allowance = UPPER (emp_supp_allowance_in),
             bi.incapacity_benefit = UPPER (incapacity_benefit_in),
             bi.income_support = UPPER (income_support_in),
             bi.invalidity_benefit = UPPER (invalidity_benefit_in),
             bi.jobseekers_allowance = UPPER (job_seekers_allowance_in),
             bi.maintenance_payment = UPPER (maintenance_payment_in),
             bi.unemployed = UPPER (unemployed_in),
             bi.retired = UPPER (retired_in),
             bi.qa_received = UPPER (qa_received_in),
             bi.suppress_reminder = UPPER (suppress_reminder_in),
             bi.income_status = UPPER (income_status_in),
             bi.income_type = UPPER (income_type_in),
             bi.reason_no_income = UPPER (reason_no_income_in),
             bi.reason_no_ben_income_id = reason_no_ben_income_id_in,
             bi.other_income_details = other_income_details_in,
             bi.last_updated_by = UPPER (user_in),
             bi.last_updated_on = SYSDATE
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
   )
   IS
   BEGIN
      INSERT INTO benefactor_income bi
                  (bi.ben_id, bi.session_code, bi.paye_income,
                   bi.self_employment, bi.pension, bi.benefit,
                   bi.nat_saving_interest, bi.bank_interest, bi.dividend,
                   bi.property, bi.working_tax_credit, bi.other_income,
                   bi.other_deduct, bi.p60_req,
                   bi.sched_d_req, bi.pension_cb,
                   bi.benefit_cb, bi.wtc_cb,
                   bi.sched_a_req, bi.oth_deducts_cb,
                   bi.ben_hei_bursary_consent,
                   bi.employment_support_allowance,
                   bi.incapacity_benefit, bi.income_support,
                   bi.invalidity_benefit,
                   bi.jobseekers_allowance,
                   bi.maintenance_payment, bi.unemployed,
                   bi.retired, bi.qa_received,
                   bi.suppress_reminder, bi.income_type,
                   bi.income_status, bi.reason_no_income,
                   bi.reason_no_ben_income_id,
                   bi.other_income_details,
                   bi.last_updated_by, bi.last_updated_on
                  )
           VALUES (ben_id_in, session_code_in, paye_income_in,
                   self_employment_in, pension_in, benefit_in,
                   nat_saving_interest_in, bank_interest_in, dividend_in,
                   property_in, working_tax_credit_in, other_income_in,
                   other_deduct_in, UPPER (p60_req_in),
                   UPPER (sched_d_req_in), UPPER (pension_cb_in),
                   UPPER (benefit_cb_in), UPPER (working_tax_credit_cb_in),
                   UPPER (sched_a_req_in), UPPER (oth_deducts_cb_in),
                   UPPER (ben_hei_bursary_consent_in),
                   UPPER (emp_supp_allowance_in),
                   UPPER (incapacity_benefit_in), UPPER (income_support_in),
                   UPPER (invalidity_benefit_in),
                   UPPER (jobseekers_allowance_in),
                   UPPER (maintenance_payment_in), UPPER (unemployed_in),
                   UPPER (retired_in), UPPER (qa_received_in),
                   UPPER (supp_reminder_in), UPPER (income_type_in),
                   UPPER (income_status_in), UPPER (reason_no_income_in),
                   reason_no_ben_income_id_in, other_income_details_in,
                   UPPER (user_in), SYSDATE
                  );

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertbenefactorincome;

   PROCEDURE getsummaryofincome (
      stud_session_id_in   IN       VARCHAR2,
      stud_income_out      OUT      VARCHAR2,
      ben1_income_out      OUT      VARCHAR2,
      ben2_income_out      OUT      VARCHAR2,
      total_out            OUT      VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   )
   AS
      v_ben1_id             VARCHAR2 (10);
      v_ben2_id             VARCHAR2 (10);
      v_session_code        VARCHAR2 (10);
      v_stud_income_count   VARCHAR (10);
   BEGIN
      ERROR_TEXT := 'Checking Benefactors present';

      SELECT ss.ben1_id, ss.ben2_id, ss.session_code
        INTO v_ben1_id, v_ben2_id, v_session_code
        FROM stud_session ss
       WHERE ss.stud_session_id = stud_session_id_in;

      ERROR_TEXT := 'Getting Benefactor One income';
      ben1_income_out := get_benefactor_total (v_ben1_id, v_session_code);
      ERROR_TEXT := 'Getting Benefactor Two income';
      ben2_income_out := get_benefactor_total (v_ben2_id, v_session_code);
      ERROR_TEXT := 'Checking for student income';

      SELECT COUNT (*)
        INTO v_stud_income_count
        FROM stud_income si
       WHERE si.stud_session_id = stud_session_id_in;

      ERROR_TEXT := 'Applying student income';

      IF v_stud_income_count > 0
      THEN
         SELECT SUM (si.amount)
           INTO stud_income_out
           FROM stud_income si
          WHERE si.stud_session_id = stud_session_id_in;
      ELSE
         stud_income_out := 0;
      END IF;

      ERROR_TEXT := 'Determining total';
      total_out := ben1_income_out + ben2_income_out + stud_income_out;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || ' : '
            || 'SQLCODE='
            || SQLCODE
            || ' SQL ERROR = '
            || SQLERRM;
   END getsummaryofincome;
   
    PROCEDURE updateallprovflags (ben_id_in         IN     VARCHAR2,
                                 session_code_in   IN     VARCHAR2,
                                 error_boolean        OUT VARCHAR2,
                                 ERROR_TEXT           OUT VARCHAR2)
   IS
   BEGIN
      -- Get all session_id's for this benefactor
      FOR rec
         IN (SELECT DISTINCT ss.stud_session_id
               FROM STUD s,
                    STUD_CRSE_YEAR scy,
                    STUD_SESSION ss,
                    BENEFACTOR b
              WHERE     ss.session_code = scy.session_code
                    AND s.stud_ref_no = ss.stud_ref_no
                    AND ss.stud_session_id = scy.stud_session_id
                    AND scy.latest_crse_ind = 'Y'
                    AND (ss.ben1_id = b.ben_id OR ss.ben2_id = b.ben_id)
                    AND b.ben_id = ben_id_in
                    AND ss.session_code = session_code_in)
      LOOP
         SGAS.pk_steps_ui_shared.checkprovisionalincome (rec.stud_session_id,
                                                         error_boolean,
                                                         ERROR_TEXT);
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateallprovflags;
END pk_steps_ui_benefactorincome;
/