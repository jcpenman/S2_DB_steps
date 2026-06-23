CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_UI_GRASS_INSTALMENTS AS
/******************************************************************************
   NAME:       PK_STEPS_UI_GRASS_INSTALMENTS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                Description
   ---------  ----------  ---------------       ------------------------------------
   1.0        25/02/2010  ABIRAMI CHIDAMBARAM   1. Created and populated code.
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
         SELECT   a.award_type_descript, ai.payment_due_date, ai.amount, ai.contrib_amount,
                  ai.recovered_amount, ai.unclaimed_loan, ai.net_amount, a.overpayment_amount, 
                  DECODE (ai.payment_addr, 'C', 'CAMPUS', 'N', 'STUDENT NOMINEE', 'H', 'STUDENT HOME ADDRESS', 'T', 'STUDENT TERM TIME ADDRESS')                 
             FROM award@GRASS a, award_instalment@GRASS ai
            WHERE a.stud_crse_year_id = stud_crse_year_id_in
              AND a.stud_ref_no = reference_id_in
              AND a.award_id = ai.award_id;
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
           FROM award@GRASS a
          WHERE a.stud_crse_year_id = stud_crse_year_id_in
            AND a.stud_award_type IN (
                                 SELECT stud_award_type
                                   FROM stud_rates@GRASS
                                  WHERE TO_CHAR(start_date, 'yyyy') = (SELECT session_code FROM STUD_CRSE_YEAR@GRASS where stud_crse_year_id = stud_crse_year_id_in));

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
   
END PK_STEPS_UI_GRASS_INSTALMENTS;
/
