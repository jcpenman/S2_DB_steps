CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_stud_pay_returns
AS
   /******************************************************************************
      NAME:       pk_steps_ui_stud_pay_returns
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        03/03/2014  Suresh Sharada   1. Created this package body.
      1.1        09/04/2014  John Wynne       Changed getstudentpaymentsreturns to return
                                              the payments as newest first
   ******************************************************************************/
   PROCEDURE getstudentpaymentsreturns (
      stud_ref_no_in   IN            VARCHAR2,
      io_cursor        IN OUT        stud_pay_returns_cursor,
      error_boolean       OUT NOCOPY VARCHAR2,
      ERROR_TEXT          OUT NOCOPY VARCHAR2)
   IS
      sp_cursor   stud_pay_returns_cursor;
   BEGIN
      OPEN sp_cursor FOR
            SELECT DISTINCT
                   NULL parent_payment_id,
                   (pp.payee_payment_id) AS payee_payment_id,
                   TO_CHAR (pp.payment_date, 'DD/MM/yyyy') AS pay_returns_date,
                   pp.payment_date,
                   pp.payee_payment_id AS Payment_Ref,
                   NULL AS Receipt_Ref,
                   pp.batch_ref,
                   pp.payee_ref_id,
                   pp.account_name,
                   pp.account_no,
                   pp.sort_code,
                   pm.descript,
                   TO_CHAR (pp.net_amount_due, '99999.99') AS Payment_Amount,
                   pp.net_amount_due AS payment_amount_sort,
                   NULL AS Receipt_Amount,
                   NULL AS receipt_amount_sort,
                      MAX (
                         ss.session_code)
                      OVER (
                         PARTITION BY pp.payee_payment_id, pp.payment_date, pp.batch_ref)
                   || CASE
                         WHEN 1 <
                                 COUNT (
                                    DISTINCT ss.session_code)
                                 OVER (
                                    PARTITION BY pp.payee_payment_id,
                                                 pp.payment_date,
                                                 pp.batch_ref)
                         THEN
                            '*'
                         ELSE
                            ''
                      END
                      Session_Code,
                   NULL multi_session_Code,
                   NULL payment_instalment_id
              FROM payee_payment pp,
                   payment_instalment pi,
                   payee p,
                   stud_crse_year scy,
                   stud_session ss,
                   payment_method pm
             WHERE     pi.payee_payment_id = pp.payee_payment_id
                   AND p.payee_id = pi.payee_id
                   AND p.payee_type != 'I'
                   AND pi.stud_crse_year_id = scy.stud_crse_year_id
                   AND scy.stud_session_id = ss.stud_session_id
                   AND pp.payment_method = pm.legacy_code
                   AND pi.stud_ref_no = stud_ref_no_in
            UNION
            SELECT *
              FROM (SELECT DISTINCT
                           pp.payee_payment_id parent_payment_id,
                           (pp.payee_payment_id) AS payee_payment_id,
                           TO_CHAR (pp.payment_date, 'DD/MM/yyyy') AS pay_returns_date,
                           pp.payment_date,
                           pp.payee_payment_id AS Payment_Ref,
                           NULL AS Receipt_Ref,
                           pp.batch_ref,
                           pp.payee_ref_id,
                           pp.account_name,
                           pp.account_no,
                           pp.sort_code,
                           pm.descript,
                           TO_CHAR (pi.payment_amount, '99999.99') AS Payment_Amount,
                           pp.net_amount_due AS payment_amount_sort,
                           NULL AS Receipt_Amount,
                           NULL AS receipt_amount_sort,
                           TO_CHAR (ss.session_code) Session_Code,
                           CASE
                              WHEN 1 <
                                      COUNT (
                                         DISTINCT ss.session_code)
                                      OVER (
                                         PARTITION BY pp.payee_payment_id,
                                                      pp.payment_date,
                                                      pp.batch_ref)
                              THEN
                                 'YES'
                              ELSE
                                 ''
                           END
                              multi_Session_Code,
                           PI.PAYMENT_INSTALMENT_ID
                      FROM payee_payment pp,
                           payment_instalment pi,
                           payee p,
                           stud_crse_year scy,
                           stud_session ss,
                           payment_method pm
                     WHERE     pi.payee_payment_id = pp.payee_payment_id
                           AND p.payee_id = pi.payee_id
                           AND p.payee_type != 'I'
                           AND pi.stud_crse_year_id = scy.stud_crse_year_id
                           AND scy.stud_session_id = ss.stud_session_id
                           AND pp.payment_method = pm.legacy_code
                           AND pi.stud_ref_no = stud_ref_no_in) x
             WHERE x.multi_Session_Code = 'YES'
            UNION
            SELECT DISTINCT NULL parent_payment_id,
                            (pr.payment_returns_load_id) AS payment_returns_id,
                            TO_CHAR (pr.returns_date, 'DD/MM/yyyy') AS pay_returns_Date,
                            pr.returns_date,
                            pr.payee_payment_id,
                            pr.payment_returns_load_id,
                            pr.returns_batch_ref,
                            NULL,
                            prl.name,
                            NULL,
                            NULL,
                            prt.description,
                            NULL,
                            NULL,
                            TO_CHAR (prl.returns_amount, '99999.99'),
                            prl.returns_amount,
                            TO_CHAR (ss.session_code),
                            NULL multi_Session_Code,
                            NULL PAYMENT_INSTALMENT_ID
              FROM payment_returns pr,
                   payment_instalment pi,
                   stud_crse_year scy,
                   stud_session ss,
                   payment_return_type prt,
                   payment_returns_load prl
             WHERE     pr.payment_instalment_id = pi.payment_instalment_id
                   AND prl.payment_returns_load_id = pr.payment_returns_load_id
                   AND pi.stud_crse_year_id = scy.stud_crse_year_id
                   AND scy.stud_session_id = ss.stud_session_id
                   AND prt.payment_return_type_id = prl.receipt_type_id
                   AND pr.stud_ref_no = stud_ref_no_in
            UNION
            SELECT DISTINCT NULL parent_payment_id,
                            (pr.payment_returns_id) AS payment_returns_id,
                            TO_CHAR (pr.returns_date, 'DD/MM/yyyy') AS pay_returns_Date,
                            pr.returns_date,
                            NULL,
                            pr.payment_returns_id,
                            pr.returns_batch_ref,
                            NULL,
                            prl.name,
                            NULL,
                            NULL,
                            CONCAT ('RECEIPT - ', prm.descript),
                            NULL,
                            NULL,
                            TO_CHAR (pr.returns_amount, '99999.99'),
                            pr.returns_amount,
                            NULL,
                            NULL multi_Session_Code,
                            NULL PAYMENT_INSTALMENT_ID
              FROM payment_returns pr,
                   payment_returns_method prm,
                   payment_returns_load prl
             WHERE     pr.receipt_type_id = '4'
                   AND pr.payment_method = prm.method_code
                   AND pr.payment_returns_load_id = prl.payment_returns_load_id
                   AND pr.stud_ref_no = stud_ref_no_in
            ORDER BY 4 DESC, parent_payment_id NULLS FIRST, 17 desc;

      io_cursor := sp_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstudentpaymentsreturns;
END pk_steps_ui_stud_pay_returns;
/