/* Formatted on 2012/03/21 12:26 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY sgas.pk_steps_ui_nmsb_placement_exp
AS
/******************************************************************************
   NAME:       PK_STEPS_UI_NMSB_PLACEMENT_EXP
   PURPOSE:

   REVISIONS:
   Ver        Date          Author                  Description
   ---------  ----------    ---------------         ------------------------------------
   1.0        28/01/2010    Abirami Chidambaram     1. Created and populated this package body.
******************************************************************************/
/*
 * Retreive NMSB Placement Expenses records
 */
   PROCEDURE getnmsbplacementexp (
      stud_crse_year_id_in   IN              NUMBER,
      io_cursor              IN OUT          placementexp_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      pe_cursor   placementexp_cursor;
   BEGIN
      OPEN pe_cursor FOR
         SELECT ai.award_instalment_id,
                ai.payment_due_date AS payment_due_date, ai.amount AS amount,
                ai.recovered_amount AS recovered_amount,
                ai.net_amount AS net_amount,
                ai.payee_reference AS payee_reference,
                ai.payment_status AS payment_status
           FROM award_instalment ai
          WHERE ai.award_id IN (
                   SELECT a.award_id
                     FROM award a
                    WHERE a.stud_award_type = 'SNPE'
                      AND a.stud_crse_year_id = stud_crse_year_id_in);

      io_cursor := pe_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getnmsbplacementexp;

   /*
    * Create NMSB Placement Expenses records
    */
   PROCEDURE addnmsbplacementexp (
      stud_ref_no_in         IN       NUMBER,
      stud_session_id_in     IN       NUMBER,
      stud_crse_year_id_in   IN       NUMBER,
      payment_due_date_in    IN       DATE,
      amount_in              IN       NUMBER,
      debt_recovered_in      IN       NUMBER,
      payee_ref_in           IN       VARCHAR2,
      user_in                IN       VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2,
      row_count              OUT      VARCHAR2
   )
   AS
      temp_inst_code           VARCHAR2 (10);
      temp_crse_id             NUMBER (9);
      temp_crse_year_no        NUMBER (2);
      temp_session_code        NUMBER (4);
      temp_payment_method      VARCHAR2 (1);
      temp_nominee             VARCHAR2 (1);
      temp_payee               VARCHAR2 (1);
      temp_payment_addr        VARCHAR2 (1);
      temp_campus_id           NUMBER (9);
   BEGIN
      ERROR_TEXT := 'Getting supporting info - Stud Crse Year details ';

      /*
       * Retreive Student Course details
       */
      SELECT scy.inst_code, scy.crse_id,
             scy.crse_year_no
        INTO temp_inst_code, temp_crse_id,
             temp_crse_year_no
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      ERROR_TEXT := 'Getting supporting info - Session Code ';

      /*
       * Retreive Current Session value for the student
       */
      SELECT ss.session_code
        INTO temp_session_code
        FROM stud_session ss
       WHERE ss.stud_session_id = stud_session_id_in;

      ERROR_TEXT := 'Inserting into Award ';

      /*
       * Create AWARD record
       */
      INSERT INTO award
                  (award_id, stud_crse_year_id, award_src,
                   tuition_fee_type_code, stud_award_type,
                   award_type_descript, inst_code, crse_id,
                   stud_ref_no, session_code, crse_year_no,
                   assessment_date, assess_reason_code, amount, net_amount,
                   contrib_amount, recovered_amount, overpayment_amount,
                   auto_travel_amount, trav_amount, hold, overpaid_contrib,
                   zero_da, unclaimed_loan, online_award_payment_hold_flag,
                   paid_as_claimed_fg, travel_award_type, unclaimed_fee_loan,
                   last_updated_by, last_updated_on, dsa_allowance_id,
                   non_tuition_fee_id
                  )
           VALUES (aw_award_id_seq.NEXTVAL, stud_crse_year_id_in, 'A',
                   NULL, 'SNPE',
                   'STUDENT NURSES PLACEMENT', temp_inst_code, temp_crse_id,
                   stud_ref_no_in, temp_session_code, temp_crse_year_no,
                   SYSDATE, 'M', amount_in, (amount_in - debt_recovered_in),
                   0, debt_recovered_in, 0,
                   NULL, NULL, 'N', NULL,
                   NULL, NULL, NULL,
                   NULL, NULL, NULL,
                   UPPER (user_in), SYSDATE, NULL,
                   NULL
                  );

      ERROR_TEXT := 'Getting payment method ';

      /*
       * Retreive Payment and Nominee details for the student
       */
      SELECT s.payment_method, s.nominee
        INTO temp_payment_method, temp_nominee
        FROM stud s
       WHERE s.stud_ref_no = stud_ref_no_in;

      IF temp_nominee = 'N'
      THEN
         temp_payee := 'S';
      END IF;

      IF temp_nominee = 'Y'
      THEN
         temp_payee := 'N';
      END IF;

      IF temp_payment_method = 'B'
      THEN
         temp_payment_addr := 'B';
      END IF;

      IF temp_payment_method <> 'B' AND temp_nominee = 'N'
      THEN
         temp_payment_addr := 'H';
      END IF;

      IF temp_payment_method <> 'B' AND temp_nominee = 'Y'
      THEN
         temp_payment_addr := 'N';
      END IF;

      IF temp_payment_method = 'C'
      THEN
         SELECT fees_campus
           INTO temp_campus_id
           FROM crse
          WHERE crse_id = temp_crse_id;
      END IF;

      IF temp_payment_method <> 'C'
      THEN
         temp_campus_id := NULL;
      END IF;

      ERROR_TEXT := 'Inserting Award Instalment ';

      /*
       * Create AWARD INSTALMENT record
       */
      INSERT INTO award_instalment
                  (award_instalment_id, award_id,
                   payment_due_date, install_type, assessment_date, amount,
                   recovered_amount, contrib_amount, net_amount,
                   method, payee, payment_addr,
                   campus_id, payment_status, batch_ref, trav_amount,
                   net_paid_contrib, payment_id, returned, recalc, reissue,
                   debt_returned, prev_returned, prev_reissue,
                   unclaimed_loan, debt_paid_contrib, dsa_fee_instalment,
                   fee_loan_instalment, unclaimed_fee_loan,
                   fee_loan_transaction_created, payee_reference, invoice_no,
                   invoice_date, receipts_received, last_updated_by,
                   last_updated_on
                  )
           VALUES (award_instalment_id_seq.NEXTVAL, aw_award_id_seq.CURRVAL,
                   payment_due_date_in, 'MN', SYSDATE, amount_in,
                   debt_recovered_in, 0, (amount_in - debt_recovered_in),
                   temp_payment_method, temp_payee, temp_payment_addr,
                   temp_campus_id, 'U', NULL, NULL,
                   NULL, NULL, 'N', 'N', 'N',
                   'N', NULL, NULL,
                   NULL, NULL, NULL,
                   NULL, NULL,
                   NULL, payee_ref_in, NULL,
                   NULL, NULL, UPPER (user_in),
                   SYSDATE
                  );

      ERROR_TEXT := 'Amending overpayment amount';

      IF debt_recovered_in > 0
      THEN
         UPDATE stud s
            SET s.snb_overpayment = s.snb_overpayment - debt_recovered_in
          WHERE s.stud_ref_no = stud_ref_no_in;
      END IF;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT :=
            ERROR_TEXT || ' SQLCODE=' || SQLCODE || ' SQL ERROR = '
            || SQLERRM;
   END addnmsbplacementexp;

   PROCEDURE removeplacementexpense (
      award_instalment_id_in   IN              VARCHAR2,
      error_boolean            OUT NOCOPY      VARCHAR2,
      ERROR_TEXT               OUT NOCOPY      VARCHAR2
   )
   IS
      v_award_id           NUMBER;
      v_recovered_amount   NUMBER;
      v_stud_ref_no        NUMBER;
   BEGIN
      ERROR_TEXT := 'Getting supporting info ';

      SELECT ai.award_id, ai.recovered_amount, scy.stud_ref_no
        INTO v_award_id, v_recovered_amount, v_stud_ref_no
        FROM award_instalment ai, stud_crse_year scy, award a
       WHERE ai.award_instalment_id = award_instalment_id_in
         AND a.award_id = ai.award_id
         AND a.stud_crse_year_id = scy.stud_crse_year_id;

      ERROR_TEXT := 'Deleting Award Instalment ';

      DELETE FROM award_instalment ai
            WHERE ai.award_instalment_id = award_instalment_id_in;

      ERROR_TEXT := 'Deleting Award ';

      DELETE FROM award a
            WHERE a.award_id = v_award_id;

      ERROR_TEXT := 'Updating Overpayment ';

      UPDATE stud s
         SET s.snb_overpayment = s.snb_overpayment + v_recovered_amount
       WHERE s.stud_ref_no = v_stud_ref_no;

      COMMIT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END removeplacementexpense;
END pk_steps_ui_nmsb_placement_exp;
/