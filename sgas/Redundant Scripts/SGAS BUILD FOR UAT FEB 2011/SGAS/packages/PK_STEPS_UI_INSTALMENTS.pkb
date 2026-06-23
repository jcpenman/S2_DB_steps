/* Formatted on 2010/02/03 18:14 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY sgas.pk_steps_ui_instalments
AS
/******************************************************************************
   NAME:       pk_steps_ui_INSTALMENTS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008      PADDY GRACE Created this package.
******************************************************************************/
   PROCEDURE instalments (
      reference_id_in        IN       VARCHAR2,
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   instalment_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   IS
      inst_cursor      instalment_cursor;
      steps            VARCHAR2 (1);
      grass            VARCHAR2 (1);
      latest_session   VARCHAR2 (10);
      latest_scy       VARCHAR2 (10);
   BEGIN
      OPEN inst_cursor FOR
         SELECT   a.award_type_descript || ' detail' award_type,
                  ai.payment_due_date due_date, ai.amount, ai.contrib_amount,
                  ai.recovered_amount, ai.unclaimed_loan, ai.net_amount,
                  ai.method, DECODE (ai.batch_ref, '', '', 'Paid') paid
             FROM award a, award_instalment ai
            WHERE a.stud_crse_year_id = stud_crse_year_id_in
              AND a.stud_ref_no = reference_id_in
              AND a.award_id = ai.award_id
         UNION ALL
         SELECT   a.award_type_descript || ' total' award_type, NULL,
                  SUM (ai.amount), SUM (ai.contrib_amount),
                  SUM (ai.recovered_amount), SUM (ai.unclaimed_loan),
                  SUM (ai.net_amount), '', ''
             FROM award a, award_instalment ai
            WHERE a.stud_crse_year_id = stud_crse_year_id_in
              AND a.stud_ref_no = reference_id_in
              AND a.award_id = ai.award_id
         GROUP BY award_type_descript
         ORDER BY 1 ASC, 2 ASC;

      io_cursor := inst_cursor;
      error_boolean := 'false';
      error_text := 'none';
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
   END instalments;

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
      error_text := 'none';
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
END pk_steps_ui_instalments;
/