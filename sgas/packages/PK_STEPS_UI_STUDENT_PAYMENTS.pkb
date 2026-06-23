CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_student_payments
AS
/******************************************************************************
   NAME:       pk_steps_ui_STUDENT_PAYMENTS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/12/2011  PADDY GRACE       Created this package.
******************************************************************************/
   PROCEDURE getstudentpayments (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          student_payments_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2 
   )
   IS
      sp_cursor   student_payments_cursor;
   BEGIN
      OPEN sp_cursor FOR
         SELECT DISTINCT (pp.payee_payment_id) as payee_payment_id, pp.batch_ref, pp.payee_ref_id,
                pp.account_name, pp.account_no, pp.sort_code,
                pp.payment_method,
                TO_CHAR (pp.payment_run_date,
                         'DD/MM/yyyy'
                        ) AS payment_run_date,
                pp.net_amount_due,
                TO_CHAR (pp.payment_date, 'DD/MM/yyyy') AS payment_date,
                TO_CHAR (pp.returned_date, 'DD/MM/yyyy') AS returned_date,
                pp.payment_status
           FROM payee_payment pp, payment_instalment pi, payee p
          WHERE pi.payee_payment_id = pp.payee_payment_id
            AND p.payee_id = pi.payee_id
            AND p.payee_type != 'I'
            AND pi.stud_ref_no = stud_ref_no_in;

      io_cursor := sp_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstudentpayments;


END pk_steps_ui_student_payments;
/