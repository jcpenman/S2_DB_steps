CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_instalments
AS
/******************************************************************************
   NAME:       pk_steps_ui_INSTALMENTS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008      PADDY GRACE Created this package.
   1.1        18/11/2008      MIKE TOLMIE Code Population.
   1.2        07/03/2013      JOHN WYNNE  Updated getInstalments to return adhoc type
******************************************************************************/
   PROCEDURE getawards (
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   award_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   IS
      a_cursor   award_cursor;
   BEGIN
      OPEN a_cursor FOR
         SELECT   a.award_id, sat.stud_award_type, a.award_type_descript, a.amount, a.net_amount,
                  a.contrib_amount, a.recovered_amount, a.overpayment_amount,
                  a.unclaimed_fee_loan
             FROM award a, stud_award_type sat
            WHERE a.stud_crse_year_id = stud_crse_year_id_in
              AND sat.stud_award_type = a.stud_award_type
              AND sat.loan_non_loan_fee != 'Loan'
         ORDER BY a.award_src DESC, a.award_type_descript;

      io_cursor := a_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getAwards : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getawards;

   PROCEDURE getinstalments (
      award_id_in     IN       VARCHAR2,
      io_cursor       IN OUT   instalment_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      i_cursor   instalment_cursor;
   BEGIN
      OPEN i_cursor FOR
         SELECT   ai.award_instalment_id, ai.adhoc_type,
                  TO_CHAR (ai.payment_due_date, 'DD/MM/yyyy'), ai.amount,
                  ai.net_amount, ai.contrib_amount, ai.recovered_amount,
                  ai.method, ai.payment_status, ai.returned,
                  ai.unclaimed_fee_loan
             FROM award_instalment ai
            WHERE ai.award_id = award_id_in
         ORDER BY ai.payment_due_date ASC;

      io_cursor := i_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getInstalments : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getinstalments;

   PROCEDURE getloanawarddetails (
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   loan_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   AS
      l_cursor   loan_cursor;
   BEGIN
      OPEN l_cursor FOR
         SELECT a.award_type_descript, a.amount, a.contrib_amount,
                a.unclaimed_loan, a.net_amount
           FROM award a
          WHERE a.stud_crse_year_id = stud_crse_year_id_in
            AND a.stud_award_type IN (
                                   SELECT sat.stud_award_type
                                     FROM stud_award_type sat
                                    WHERE UPPER (sat.loan_non_loan_fee) =
                                                                        'LOAN');

      io_cursor := l_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : instalments : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getloanawarddetails;

   PROCEDURE getloanawardtotals (
      stud_crse_year_id_in   IN       VARCHAR2,
      description_out        OUT      VARCHAR2,
      amount_out             OUT      VARCHAR2,
      contrib_amount_out     OUT      VARCHAR2,
      unclaimed_loan_out     OUT      VARCHAR2,
      net_amount_out         OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   IS
   BEGIN
      SELECT 'Total', SUM (a.amount), SUM (a.contrib_amount),
             SUM (a.unclaimed_loan), SUM (a.net_amount)
        INTO description_out, amount_out, contrib_amount_out,
             unclaimed_loan_out, net_amount_out
        FROM award a
       WHERE a.stud_crse_year_id = stud_crse_year_id_in
         AND a.stud_award_type IN (
                                   SELECT sat.stud_award_type
                                     FROM stud_award_type sat
                                    WHERE UPPER (sat.loan_non_loan_fee) =
                                                                        'LOAN');

      error_boolean := 'False';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getloanawardtotals : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getloanawardtotals;
END pk_steps_ui_instalments;
/
