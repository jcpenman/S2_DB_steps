CREATE OR REPLACE VIEW VU_PROVIDER_BALANCES
(PROVIDER_ID, OUTSTANDING_AMOUNT, BALANCE_DATE, SEQ)
AS 
(SELECT provider_id, NVL (outstanding_amount, 0) outstanding_amount,
           balance_date, seq
      FROM (SELECT provider_id, outstanding_amount, SYSDATE balance_date, 1 seq
              FROM provider
            UNION
            SELECT TO_NUMBER (primary_key), TO_NUMBER (NEW),
                   aud_date balance_date, 2 seq
              FROM provider_aud
             WHERE column_name = 'OUTSTANDING_AMOUNT' AND action = 'U'
            UNION
            SELECT TO_NUMBER (primary_key), TO_NUMBER (OLD),
                   aud_date balance_date, 3 seq
              FROM provider_aud
             WHERE column_name = 'OUTSTANDING_AMOUNT' AND action = 'U'
            UNION
            SELECT TO_NUMBER (primary_key), TO_NUMBER (NEW),
                   aud_date balance_date, 4 seq
              FROM provider_aud
             WHERE column_name = 'OUTSTANDING_AMOUNT' AND action = 'I'
            UNION
            SELECT   app.provider_id,
                       SUM
                          (DECODE (lpy.transaction_type_id,
                                   iv_trans_type.debit, -1 * lpy.amount,
                                   lpy.amount
                                  )
                          )
                     + pk_payments.provider_balance (provider_id)
                                                           outstanding_amount,
                     ctp.batch_run_date balance_date, 0 seq
                FROM learner_application app,
                     course_type ctp,
                     learner_payment lpy,
                     (SELECT transaction_type_id debit
                        FROM transaction_type
                       WHERE description = 'DEBIT') iv_trans_type,
                     (SELECT application_status_id calculated
                        FROM application_status
                       WHERE status IN
                                ('CALCULATED', 'WITHDRAWN', 'NON_ATTENDANCE')) iv_status,
                     (SELECT payment_status_id unpaid
                        FROM payment_status
                       WHERE payment_desc = 'UNPAID') iv_pay_status,
                     (SELECT bacs_run_id run_id
                        FROM bacs_run
                       WHERE bacs_run_date >= TRUNC (SYSDATE)) iv_bacs_run
               WHERE lpy.learner_application_id = app.learner_application_id
                 AND app.application_status_id = iv_status.calculated
                 AND app.course_type_id = ctp.course_type_id
                 AND app.course_start_date BETWEEN ctp.fee_period_start
                                               AND ctp.fee_period_end
                 AND ctp.batch_run_date >= TRUNC (SYSDATE)
                 AND lpy.provider_payment_id IS NULL
                 AND lpy.payment_status_id = iv_pay_status.unpaid
            GROUP BY app.provider_id, ctp.batch_run_date))
/