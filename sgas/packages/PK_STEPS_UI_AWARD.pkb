CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_award
AS
   /******************************************************************************
      NAME:       PK_STEPS_UI_AWARD
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        17/11/2008      PADDY GRACE  Created this package.
      1.1        21/02/2013  Paddy Grace      Added new field to getawardgeneralinfo
      1.2        30/01/2020  Clark Bolan      added new setdmstask procedure
      1.3        06/07/2021  Clark Bolan      new debt only feature
      1.4        09/12/2021  Ranj Benning     Timing of Payments
   ******************************************************************************/
   PROCEDURE getawarded (stud_crse_year_id_in   IN            VARCHAR2,
                         calc_fee                  	OUT NOCOPY VARCHAR2,
                         assess_loan               	OUT NOCOPY VARCHAR2,
                         calc_loan                 	OUT NOCOPY VARCHAR2,
                         calc_bursary              	OUT NOCOPY VARCHAR2,
                         calc_sma                  	OUT NOCOPY VARCHAR2,
                         calc_dep_grant            	OUT NOCOPY VARCHAR2,
                         calc_lpg                  	OUT NOCOPY VARCHAR2,
                         calc_lpcg                 	OUT NOCOPY VARCHAR2,
                         nmsb_init_expenses        	OUT NOCOPY VARCHAR2,
                         calc_nmsb                 	OUT NOCOPY VARCHAR2,
                         calc_spa                  	OUT NOCOPY VARCHAR2,
                         calc_cesb                 	OUT NOCOPY VARCHAR2,
                         calc_pgedpsych_grant      	OUT NOCOPY VARCHAR2,
                         calc_pgedpsych_fees       	OUT NOCOPY VARCHAR2,
                         calc_pgedpsych_qeps       	OUT NOCOPY VARCHAR2,
                         calc_sag                  	OUT NOCOPY VARCHAR2,
						 calc_pgedpsych_grant_phd  	OUT NOCOPY VARCHAR2,
						 calc_pgedpsych_fees_phd	OUT NOCOPY VARCHAR2,							 
                         error_boolean             	OUT NOCOPY VARCHAR2,
                         ERROR_TEXT                	OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT scy.calc_fee,
             scy.assess_loan,
             scy.calc_loan,
             scy.calc_bursary,
             scy.calc_sma,
             scy.calc_dep_grant,
             scy.calc_lpg,
             scy.calc_lpcg,
             scy.nmsb_init_expenses,
             scy.calc_nmsb,
             scy.calc_spa,
             scy.calc_cesb,
             scy.calc_pg_ed_psych_grant,
             scy.calc_pg_ed_psych_fees,
             scy.calc_pg_ed_psych_qeps,
             scy.calc_sag,
             scy.calc_pg_ed_psych_grant_phd,
             scy.calc_pg_ed_psych_fees_phd
        INTO calc_fee,
             assess_loan,
             calc_loan,
             calc_bursary,
             calc_sma,
             calc_dep_grant,
             calc_lpg,
             calc_lpcg,
             nmsb_init_expenses,
             calc_nmsb,
             calc_spa,
             calc_cesb,
             calc_pgedpsych_grant,
             calc_pgedpsych_fees,
             calc_pgedpsych_qeps,
             calc_sag,
             calc_pgedpsych_grant_phd,
             calc_pgedpsych_fees_phd
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

   PROCEDURE setawarded (stud_crse_year_id_in      		IN            VARCHAR2,
                         calc_fee_in               		IN            VARCHAR2,
                         assess_loan_in            		IN            VARCHAR2,
                         calc_loan_in              		IN            VARCHAR2,
                         calc_bursary_in           		IN            VARCHAR2,
                         calc_sma_in               		IN            VARCHAR2,
                         calc_dep_grant_in         		IN            VARCHAR2,
                         calc_lpg_in               		IN            VARCHAR2,
                         calc_lpcg_in              		IN            VARCHAR2,
                         nmsb_init_expenses_in     		IN            VARCHAR2,
						 calc_nmsb_in              		IN            VARCHAR2,
                         calc_spa_in               		IN            VARCHAR2,
                         calc_cesb_in              		IN            VARCHAR2,
                         calc_pgedpsych_grant_in   		IN            VARCHAR2,
                         calc_pgedpsych_fees_in    		IN            VARCHAR2,
                         calc_pgedpsych_qeps_in    		IN            VARCHAR2,
                         calc_sag_in               		IN            VARCHAR2,
						 calc_pgedpsych_grant_phd_in 	IN            VARCHAR2,
						 calc_pgedpsych_fees_phd_in		IN            VARCHAR2,							 
                         error_boolean                	OUT NOCOPY VARCHAR2,
                         ERROR_TEXT                   	OUT NOCOPY VARCHAR2)
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
             scy.calc_spa = calc_spa_in,
             scy.calc_cesb = calc_cesb_in,
             scy.calc_pg_ed_psych_grant = calc_pgedpsych_grant_in,
             scy.calc_pg_ed_psych_fees = calc_pgedpsych_fees_in,
             scy.calc_pg_ed_psych_qeps = calc_pgedpsych_qeps_in,
             scy.calc_sag = calc_sag_in,
             scy.calc_pg_ed_psych_grant_phd = calc_pgedpsych_grant_phd_in,
             scy.calc_pg_ed_psych_fees_phd = calc_pgedpsych_fees_phd_in
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getawardinformation : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END setawarded;

   PROCEDURE getdebtinformation (stud_ref_no_in    IN     VARCHAR2,
                                 debt_amount          OUT VARCHAR2,
                                 deferred_amount      OUT VARCHAR2,
                                 debt_status          OUT VARCHAR2,
                                 error_boolean        OUT VARCHAR2,
                                 ERROR_TEXT           OUT VARCHAR2)
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

   PROCEDURE setdebtinformation (stud_ref_no_in    IN     VARCHAR2,
                                 deferred_amount   IN     VARCHAR2,
                                 debt_status       IN     VARCHAR2,
                                 debt_amount       IN     VARCHAR2,
                                 row_count            OUT VARCHAR2,
                                 error_boolean        OUT VARCHAR2,
                                 ERROR_TEXT           OUT VARCHAR2)
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
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : setdebtinformation : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END setdebtinformation;

   PROCEDURE getawardgeneralinfo (stud_crse_year_id_in   IN     VARCHAR2,
                                  stud_session_id_in     IN     VARCHAR2,
                                  date_app_rcvd             OUT VARCHAR2,
                                  date_web_app_sub          OUT VARCHAR2,
                                  orig_proc_date            OUT VARCHAR2,
                                  last_employee             OUT VARCHAR2,
                                  original_employee         OUT VARCHAR2,
                                  last_calc_date            OUT DATE,
                                  last_letter_date          OUT VARCHAR2,
                                  no_award_ltrs_issued      OUT VARCHAR2,
                                  award_given               OUT VARCHAR2,
                                  sal_destination           OUT VARCHAR2,
                                  remark                    OUT VARCHAR2,
                                  session_code_out          OUT VARCHAR2,
                                  student_status_out        OUT VARCHAR2,
                                  error_boolean             OUT VARCHAR2,
                                  ERROR_TEXT                OUT VARCHAR2)
   IS
      latest_session   VARCHAR2 (10);
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT date_applic_received, emp_login_name
        INTO date_app_rcvd, last_employee
        FROM stud_session
       WHERE stud_session_id = stud_session_id_in;

      SELECT web_submitted,
             first_calc_date,
             first_emp,
             auto_calc_date,
             sal_sent_date,
             award_letter_no,
             award,
             DECODE (sal_dest,  '1', 'false',  'S', 'true',  NULL),
             remark,
             session_code,
             student_status
        INTO date_web_app_sub,
             orig_proc_date,
             original_employee,
             last_calc_date,
             last_letter_date,
             no_award_ltrs_issued,
             award_given,
             sal_destination,
             remark,
             session_code_out,
             student_status_out
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

   PROCEDURE setawardgeneralinfo (stud_crse_year_id_in   IN     VARCHAR2,
                                  sal_destination        IN     VARCHAR2,
                                  remark_in              IN     VARCHAR2,
                                  employee_in            IN     VARCHAR2,
                                  error_boolean             OUT VARCHAR2,
                                  ERROR_TEXT                OUT VARCHAR2)
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
         SET scy.sal_dest = temp_sal_dest,
             scy.remark = UPPER (remark_in),
             scy.last_updated_by = employee_in,
             scy.last_updated_on = SYSDATE
       WHERE stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : setawardinformation : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END setawardgeneralinfo;

   PROCEDURE validateawardnotice (stud_crse_year_id_in   IN     VARCHAR2,
                                  is_valid                  OUT VARCHAR2,
                                  error_boolean             OUT VARCHAR2,
                                  ERROR_TEXT                OUT VARCHAR2)
   IS
      temp_sal_sent     VARCHAR2 (1);
      temp_app_status   VARCHAR2 (1);
   BEGIN
      SELECT stud_crse_year.sal_sent, stud_crse_year.application_status
        INTO temp_sal_sent, temp_app_status
        FROM stud_crse_year
       WHERE stud_crse_year.stud_crse_year_id = stud_crse_year_id_in;

      IF (temp_sal_sent = 'Y' AND temp_app_status = 'C')
      THEN
         is_valid := 'true';
         error_boolean := 'false';
         ERROR_TEXT := 'None';
      ELSIF temp_app_status = 'N'
      THEN
         is_valid := 'false';
         error_boolean := 'true';
         ERROR_TEXT :=
            'An award must have been calculated before a duplicate award notice can be generated.';
      ELSIF (temp_sal_sent = 'N' AND temp_app_status = 'C')
      THEN
         is_valid := 'false';
         error_boolean := 'true';
         ERROR_TEXT :=
            'An award notice has still to be sent and a duplicate can not be generated until the original has been sent.';
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : validateAwardNotice : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END validateawardnotice;

   PROCEDURE checkprevincomeprov (stud_ref_no_in    IN     VARCHAR2,
                                  session_code_in   IN     VARCHAR2,
                                  prov_flag            OUT VARCHAR2,
                                  error_boolean        OUT VARCHAR2,
                                  ERROR_TEXT           OUT VARCHAR2)
   IS
   BEGIN
      prov_flag :=
         sgas.rules_proc_recalc.getprevsessionprovisionalflag (
            stud_ref_no_in,
            session_code_in);
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

   PROCEDURE settotaldebt (stud_ref_no_in       IN     VARCHAR2,
                           def_overpayment_in   IN     VARCHAR2,
                           overpayment_in       IN     VARCHAR2,
                           debt_status          IN     VARCHAR2,
                           system_user          IN     VARCHAR2,
                           error_boolean           OUT VARCHAR2,
                           ERROR_TEXT              OUT VARCHAR2)
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      UPDATE stud s
         SET s.overpayment = overpayment_in,
             s.def_overpayment = def_overpayment_in,
             s.overpay_stat = debt_status,
             s.last_updated_by = UPPER (system_user),
             s.last_updated_on = SYSDATE
       WHERE stud_ref_no = stud_ref_no_in;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : settotaldebt : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END settotaldebt;

   PROCEDURE settotalnmsbdebt (stud_ref_no_in           IN     VARCHAR2,
                               snb_def_overpayment_in   IN     VARCHAR2,
                               snb_overpayment_in       IN     VARCHAR2,
                               debt_status              IN     VARCHAR2,
                               system_user              IN     VARCHAR2,
                               error_boolean               OUT VARCHAR2,
                               ERROR_TEXT                  OUT VARCHAR2)
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      UPDATE stud s
         SET s.snb_overpayment = snb_overpayment_in,
             s.snb_def_overpayment = snb_def_overpayment_in,
             s.overpay_stat = debt_status,
             s.last_updated_by = UPPER (system_user),
             s.last_updated_on = SYSDATE
       WHERE stud_ref_no = stud_ref_no_in;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure :  settotalnmsbdebt : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END settotalnmsbdebt;

   PROCEDURE getnmsbdebtinformation (stud_ref_no_in        IN     VARCHAR2,
                                     snb_debt_amount          OUT VARCHAR2,
                                     snb_deferred_amount      OUT VARCHAR2,
                                     debt_status              OUT VARCHAR2,
                                     error_boolean            OUT VARCHAR2,
                                     ERROR_TEXT               OUT VARCHAR2)
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT snb_overpayment, snb_def_overpayment, overpay_stat
        INTO snb_debt_amount, snb_deferred_amount, debt_status
        FROM stud
       WHERE stud_ref_no = stud_ref_no_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getnmsbdebtinformation : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getnmsbdebtinformation;

   PROCEDURE getpaymenttypecount (stud_ref_no_in        IN     VARCHAR2,
                                  session_code_in       IN     VARCHAR2,
                                  installment_type_in   IN     VARCHAR2,
                                  payment_count_out        OUT VARCHAR2,
                                  error_boolean            OUT VARCHAR2,
                                  ERROR_TEXT               OUT VARCHAR2)
   IS
   BEGIN
      SELECT COUNT (*)
        INTO payment_count_out
        FROM award_instalment ai, award a, stud_crse_year scy
       WHERE     a.award_id = ai.award_id
             AND a.stud_crse_year_id = scy.stud_crse_year_id
             AND ai.install_type = installment_type_in
             AND a.stud_ref_no = stud_ref_no_in
             AND scy.session_code = session_code_in
             AND a.stud_award_type IN (SELECT sat.stud_award_type
                                         FROM stud_award_type sat
                                        WHERE sat.TYPE IN ('LPG',
                                                           'DEPG',
                                                           'SMA',
                                                           'BURS',
                                                           'LPCG',
                                                           'CESB'));

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getpaymenttypecount : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getpaymenttypecount;

   /*
      PROCEDURE setdmstask (
       stud_ref_no_in        IN       NUMBER,
       created_by_in         IN       VARCHAR2,
       details_in            IN       VARCHAR2,
       error_boolean         OUT      VARCHAR2,
       ERROR_TEXT            OUT      VARCHAR2
      )
      IS
      BEGIN

      error_boolean := 'false';
      ERROR_TEXT := 'none';

      INSERT INTO dms_task dms (task_id, stud_ref_no, created_by, details)
      VALUES(dms_task_seq.nextval, stud_ref_no_in, UPPER(created_by_in), details_in);


      EXCEPTION
         WHEN OTHERS
         THEN
            error_boolean := 'true';
            ERROR_TEXT :=
                  'ERROR : plsql procedure : setdmstask : @ '
               || SYSDATE
               || ': '
               || SQLCODE
               || ' '
               || SQLERRM;


      END setdmstask;
   */

   PROCEDURE getDebtOnly (stud_crse_year_id_in   IN     NUMBER,
                          debt_only_out             OUT VARCHAR2,
                          error_boolean             OUT VARCHAR2,
                          ERROR_TEXT                OUT VARCHAR2)
   IS
      l_stud_session_id   NUMBER;
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';


      SELECT stud_session_id
        INTO l_stud_session_id
        FROM stud_crse_year
       WHERE stud_crse_year_id = stud_crse_year_id_in;

      SELECT debt_only
        INTO debt_only_out
        FROM stud_session
       WHERE stud_session_id = l_stud_session_id;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getDebtOnly : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getDebtOnly;


   PROCEDURE setDebtOnly (stud_crse_year_id_in   IN     NUMBER,
                          debt_only_in           IN     VARCHAR2,
                          system_user_in         IN     VARCHAR2,
                          error_boolean             OUT VARCHAR2,
                          ERROR_TEXT                OUT VARCHAR2)
   IS
      l_stud_session_id   NUMBER;
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';


      SELECT stud_session_id
        INTO l_stud_session_id
        FROM stud_crse_year
       WHERE stud_crse_year_id = stud_crse_year_id_in;

      UPDATE stud_session
         SET debt_only = debt_only_in,
             last_updated_on = SYSDATE,
             last_updated_by = UPPER (system_user_in)
       WHERE stud_session_id = l_stud_session_id;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : setDebtOnly : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END setDebtOnly;


   PROCEDURE gettimingofpayments (stud_session_id_in   IN     VARCHAR2,
                                  top_option_out          OUT VARCHAR2,
                                  top_changed_out         OUT VARCHAR2,
                                  error_boolean           OUT VARCHAR2,
                                  ERROR_TEXT              OUT VARCHAR2)
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT top_option, TO_CHAR (top_changed, 'DD/MM/YYYY')
        INTO top_option_out, top_changed_out
        FROM stud_session
       WHERE stud_session_id = stud_session_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : gettimingofpayments : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END gettimingofpayments;


   PROCEDURE settimingofpayments (stud_session_id_in   IN     VARCHAR2,
                                  top_option_in        IN     VARCHAR2,
                                  top_changed_out         OUT VARCHAR2,                                  
                                  error_boolean           OUT VARCHAR2,
                                  ERROR_TEXT              OUT VARCHAR2)
   IS
      temp_top_option   VARCHAR2 (1);
      temp_top_changed    DATE;
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT top_option, TO_CHAR(top_changed, 'DD/MM/YYYY')
        INTO temp_top_option, top_changed_out
        FROM stud_session
       WHERE stud_session_id = stud_session_id_in;

      UPDATE stud_session
         SET top_option = top_option_in
       WHERE stud_session_id = stud_session_id_in;

      IF temp_top_option IN ('N', 'Y') AND temp_top_option != top_option_in
      THEN
         temp_top_changed := SYSDATE;
                  
         UPDATE stud_session
            SET top_changed = temp_top_changed
          WHERE stud_session_id = stud_session_id_in;
          
         top_changed_out := TO_CHAR (temp_top_changed, 'DD/MM/YYYY');
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : settimingofpayments : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END settimingofpayments;
END pk_steps_ui_award;
/
