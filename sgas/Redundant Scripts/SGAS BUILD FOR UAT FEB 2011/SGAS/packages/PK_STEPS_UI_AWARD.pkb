/* Formatted on 2010/12/14 14:24 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY sgas.pk_steps_ui_award
AS
/******************************************************************************
   NAME:       PK_STEPS_UI_AWARD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008      PADDY GRACE Created this package.
******************************************************************************/
   PROCEDURE getawarded (
      stud_crse_year_id_in   IN              VARCHAR2,
      calc_fee               OUT NOCOPY      VARCHAR2,
      assess_loan            OUT NOCOPY      VARCHAR2,
      calc_loan              OUT NOCOPY      VARCHAR2,
      calc_bursary           OUT NOCOPY      VARCHAR2,
      calc_sma               OUT NOCOPY      VARCHAR2,
      calc_dep_grant         OUT NOCOPY      VARCHAR2,
      calc_lpg               OUT NOCOPY      VARCHAR2,
      calc_lpcg              OUT NOCOPY      VARCHAR2,
      nmsb_init_expenses     OUT NOCOPY      VARCHAR2,
      calc_nmsb              OUT NOCOPY      VARCHAR2,
      calc_spa               OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT scy.calc_fee, scy.assess_loan, scy.calc_loan, scy.calc_bursary,
             scy.calc_sma, scy.calc_dep_grant, scy.calc_lpg, scy.calc_lpcg,
             scy.nmsb_init_expenses, scy.calc_nmsb, scy.calc_spa
        INTO calc_fee, assess_loan, calc_loan, calc_bursary,
             calc_sma, calc_dep_grant, calc_lpg, calc_lpcg,
             nmsb_init_expenses, calc_nmsb, calc_spa
        FROM stud_crse_year scy
       WHERE stud_crse_year_id = stud_crse_year_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getawardinformation : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getawarded;

   PROCEDURE setawarded (
      stud_crse_year_id_in    IN              VARCHAR2,
      calc_fee_in             IN              VARCHAR2,
      assess_loan_in          IN              VARCHAR2,
      calc_loan_in            IN              VARCHAR2,
      calc_bursary_in         IN              VARCHAR2,
      calc_sma_in             IN              VARCHAR2,
      calc_dep_grant_in       IN              VARCHAR2,
      calc_lpg_in             IN              VARCHAR2,
      calc_lpcg_in            IN              VARCHAR2,
      nmsb_init_expenses_in   IN              VARCHAR2,
      calc_nmsb_in            IN              VARCHAR2,
      calc_spa_in             IN              VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      UPDATE stud_crse_year scy
         SET scy.calc_fee = calc_fee_in,
             scy.assess_loan = assess_loan_in,
             scy.calc_loan = calc_loan_in,
             scy.calc_bursary = calc_bursary_in,
             scy.calc_sma = calc_sma_in,
             scy.calc_dep_grant = calc_dep_grant_in,
             scy.calc_lpg = calc_lpg_in,
             scy.calc_lpcg = calc_lpcg_in,
             scy.nmsb_init_expenses = nmsb_init_expenses_in,
             scy.calc_nmsb = calc_nmsb_in,
             scy.calc_spa = calc_spa_in
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getawardinformation : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END setawarded;

   PROCEDURE getdebtinformation (
      stud_ref_no_in    IN       VARCHAR2,
      debt_amount       OUT      VARCHAR2,
      deferred_amount   OUT      VARCHAR2,
      debt_status       OUT      VARCHAR2,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT overpayment, def_overpayment, overpay_stat
        INTO debt_amount, deferred_amount, debt_status
        FROM stud
       WHERE stud_ref_no = stud_ref_no_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getdebtinformation : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getdebtinformation;

   PROCEDURE setdebtinformation (
      stud_ref_no_in    IN       VARCHAR2,
      deferred_amount   IN       VARCHAR2,
      debt_status       IN       VARCHAR2,
      debt_amount       IN       VARCHAR2,
      row_count         OUT      VARCHAR2,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      UPDATE stud s
         SET s.overpayment = debt_amount,
             s.def_overpayment = deferred_amount,
             s.overpay_stat = debt_status
       WHERE stud_ref_no = stud_ref_no_in;

      row_count := SQL%ROWCOUNT;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : setdebtinformation : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END setdebtinformation;

   PROCEDURE getawardgeneralinfo (
      stud_crse_year_id_in   IN       VARCHAR2,
      stud_session_id_in     IN       VARCHAR2,
      date_app_rcvd          OUT      VARCHAR2,
      date_web_app_sub       OUT      VARCHAR2,
      orig_proc_date         OUT      VARCHAR2,
      last_employee          OUT      VARCHAR2,
      original_employee      OUT      VARCHAR2,
      last_calc_date         OUT      DATE,
      last_letter_date       OUT      VARCHAR2,
      no_award_ltrs_issued   OUT      VARCHAR2,
      award_given            OUT      VARCHAR2,
      sal_destination        OUT      VARCHAR2,
      remark                 OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   IS
      latest_session   VARCHAR2 (10);
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT date_applic_received, emp_login_name
        INTO date_app_rcvd, last_employee
        FROM stud_session
       WHERE stud_session_id = stud_session_id_in;

      SELECT web_submitted, first_calc_date, first_emp,
             auto_calc_date, sal_sent_date, award_letter_no,
             award, DECODE (sal_dest, '1', 'false', 'S', 'true', NULL), remark
        INTO date_web_app_sub, orig_proc_date, original_employee,
             last_calc_date, last_letter_date, no_award_ltrs_issued,
             award_given, sal_destination, remark
        FROM stud_crse_year
       WHERE stud_crse_year_id = stud_crse_year_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getawardinformation : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getawardgeneralinfo;

   PROCEDURE setawardgeneralinfo (
      stud_crse_year_id_in   IN       VARCHAR2,
      award_given_in         IN       VARCHAR2,
      sal_destination        IN       VARCHAR2,
      remark_in              IN       VARCHAR2,
      employee_in            IN       VARCHAR2,
      row_count              OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   IS
      temp_sal_dest   VARCHAR2 (1);
   BEGIN
      IF sal_destination = 'true'
      THEN
         temp_sal_dest := 'S';
      ELSE
         temp_sal_dest := '1';
      END IF;

      UPDATE stud_crse_year scy
         SET scy.award = award_given_in,
             scy.sal_dest = temp_sal_dest,
             scy.remark = UPPER (remark_in),
             scy.last_updated_by = employee_in,
             scy.last_updated_on = SYSDATE
       WHERE stud_crse_year_id = stud_crse_year_id_in;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : setawardinformation : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END setawardgeneralinfo;

   PROCEDURE checkprevincomeprov (
      stud_ref_no_in    IN       VARCHAR2,
      session_code_in   IN       VARCHAR2,
      prov_flag         OUT      VARCHAR2,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   )
   IS
   BEGIN
      prov_flag :=
         sgas.rules_proc_recalc.getprevsessionprovisionalflag
                                                             (stud_ref_no_in,
                                                              session_code_in
                                                             );
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         prov_flag := 'N';
         error_boolean := 'false';
         ERROR_TEXT := 'None';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : setawardinformation : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END checkprevincomeprov;
END pk_steps_ui_award;
/