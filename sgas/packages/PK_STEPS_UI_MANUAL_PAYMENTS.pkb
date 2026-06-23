CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_manual_payments
AS
/******************************************************************************
   NAME:       pk_steps_ui_MANUAL_PAYMENTS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        04/10/2010      PADDY GRACE           Created this package.
   1.1        25/02/2013    paddy Grace             added ADHOC_TYPE field to getawardinstalments, updateawardinstalments, insertawardinstalments
   1.2        29/10/2019  James Baird     Removed the @GRASS for course and institution tables.
******************************************************************************/
   PROCEDURE getcontribanddebt (
      stud_crse_year_id_in       IN       VARCHAR2,
      overpayment                OUT      VARCHAR2,
      outstanding_contribution   OUT      VARCHAR2,
      error_boolean              OUT      VARCHAR2,
      ERROR_TEXT                 OUT      VARCHAR2
   )
   IS
      temp_scheme   VARCHAR2 (1);
   BEGIN
      ERROR_TEXT := 'Getting scheme type';

      -- getting scheme type for the passed stud_crse_year_id
      SELECT scy.scheme_type
        INTO temp_scheme
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      ERROR_TEXT := 'Getting appropriate amounts';

      --if nursing student, get SNB debt
      --if not, get debt
      IF temp_scheme = 'B'
      THEN
         ERROR_TEXT := 'Getting SNB Overpayment and Parental Contribution';

         SELECT s.snb_overpayment, scy.resid_par_cont
           INTO overpayment, outstanding_contribution
           FROM stud_crse_year scy, stud s
          WHERE scy.stud_crse_year_id = stud_crse_year_id_in
            AND scy.stud_ref_no = s.stud_ref_no;
      ELSE
         ERROR_TEXT := 'Getting Overpayment and Parental Contribution';

         SELECT s.overpayment, scy.resid_par_cont
           INTO overpayment, outstanding_contribution
           FROM stud_crse_year scy, stud s
          WHERE scy.stud_crse_year_id = stud_crse_year_id_in
            AND scy.stud_ref_no = s.stud_ref_no;
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || ' - '
            || 'ERROR : PL SQL Procedure : getcontribanddebt : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getcontribanddebt;

   PROCEDURE getawardinstalments (
      award_id_in     IN       VARCHAR2,
      io_cursor       IN OUT   i_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      instalment_cursor   i_cursor;
   BEGIN
      -- select award instalment info from AWARD and AWARD_INSTALMENT
      OPEN instalment_cursor FOR
         SELECT   ai.award_instalment_id, ai.payment_due_date, ai.amount,
                  ai.contrib_amount, ai.recovered_amount, ai.net_amount,
                  ai.payment_status, ai.payee_reference, ai.returned,
                  ai.chaps, a.stud_award_type, ai.install_type,
                  ai.adhoc_type
             FROM award_instalment ai, award a
            WHERE ai.award_id = award_id_in AND a.award_id = award_id_in
         ORDER BY ai.payment_due_date;

      io_cursor := instalment_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || ' - '
            || 'ERROR : PL SQL Procedure : getawardinstalments : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getawardinstalments;

   PROCEDURE updateawardinstalment (
      award_instalment_id_in   IN       VARCHAR2,
      pay_due_date_in          IN       DATE,
      amount_in                IN       VARCHAR2,
      recovered_amount_in      IN       VARCHAR2,
      contrib_amount_in        IN       VARCHAR2,
      net_amount_in            IN       VARCHAR2,
      returned_in              IN       VARCHAR2,
      employee_in              IN       VARCHAR2,
      payee_reference_in       IN       VARCHAR2,
      adhoc_type_in            IN       VARCHAR2,
      error_boolean            OUT      VARCHAR2,
      ERROR_TEXT               OUT      VARCHAR2
   )
   IS
      v_award_id                    NUMBER;
      v_amount_original             NUMBER;
      v_recovered_amount_original   NUMBER;
      v_contrib_amount_original     NUMBER;
      v_scheme_type                 VARCHAR2 (1);
      v_snb_op                      NUMBER;
      v_op                          NUMBER;
   BEGIN
      --Get the scheme type associated with the AWARD_INSTALMENT record
      SELECT scy.scheme_type
        INTO v_scheme_type
        FROM stud_crse_year scy, award a, award_instalment ai
       WHERE scy.stud_crse_year_id = a.stud_crse_year_id
         AND a.award_id = ai.award_id
         AND ai.award_instalment_id = award_instalment_id_in;

      --Get the AWARD info associated with the AWARD_INSTALMENT record
      SELECT a.award_id, ai.amount, ai.recovered_amount,
             ai.contrib_amount
        INTO v_award_id, v_amount_original, v_recovered_amount_original,
             v_contrib_amount_original
        FROM award_instalment ai, award a
       WHERE ai.award_instalment_id = award_instalment_id_in
         AND a.award_id = ai.award_id;

      --Update the AWARD_INSTALMENT record with the passed data
      UPDATE award_instalment ai
         SET ai.payment_due_date = pay_due_date_in,
             ai.install_type = 'MN',
             ai.assessment_date = SYSDATE,
             ai.amount = amount_in,
             ai.recovered_amount = recovered_amount_in,
             ai.contrib_amount = contrib_amount_in,
             ai.net_amount = net_amount_in,
             ai.last_updated_by = employee_in,
             ai.last_updated_on = SYSDATE,
             ai.returned = returned_in,
             ai.payee_reference = payee_reference_in,
             ai.adhoc_type = UPPER (adhoc_type_in)
       WHERE ai.award_instalment_id = award_instalment_id_in;

      --Check the scheme type associated with the AWARD_INSTALMENT record
      --if nursing, adjust the SNB debt with passed data
      --if not, update the debt with passed data
      IF v_scheme_type = 'B'
      THEN
         v_snb_op := v_recovered_amount_original - recovered_amount_in;
         v_op := 0;
      ELSE
         v_snb_op := 0;
         v_op := v_recovered_amount_original - recovered_amount_in;
      END IF;

      updateothers (v_award_id,
                    v_op,
                    v_snb_op,
                    (v_contrib_amount_original - contrib_amount_in),
                    employee_in,
                    error_boolean,
                    ERROR_TEXT
                   );

      IF error_boolean = 'true'
      THEN
         ERROR_TEXT := 'Error updating supporting tables : ' || ERROR_TEXT;
         ROLLBACK;
      ELSE
         error_boolean := 'false';
         ERROR_TEXT := 'none';
         COMMIT;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || ' - '
            || 'ERROR : PL SQL Procedure : updateawardinstalment : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END updateawardinstalment;

   PROCEDURE insertawardinstalment (
      award_id_in           IN       VARCHAR2,
      payment_due_date_in   IN       DATE,
      amount_in             IN       VARCHAR2,
      recovered_amount_in   IN       VARCHAR2,
      contrib_amount_in     IN       VARCHAR2,
      net_amount_in         IN       VARCHAR2,
      chaps_in              IN       VARCHAR2,
      adhoc_type_in         IN       VARCHAR2,
      employee_in           IN       VARCHAR2,
      error_boolean         OUT      VARCHAR2,
      ERROR_TEXT            OUT      VARCHAR2
   )
   IS
      v_payment_method   stud.payment_method%TYPE;
      v_payment_addr     VARCHAR2 (1);
      v_payment_status   VARCHAR2 (1);
      v_campus_id        NUMBER;
      v_scheme_type      VARCHAR2 (1);
      v_snb_op           NUMBER;
      v_op               NUMBER;
   BEGIN
      ERROR_TEXT := 'Getting payment method ';

      --Get the payment methof and scheme type associated with the AWARD record
      SELECT s.payment_method, scy.scheme_type
        INTO v_payment_method, v_scheme_type
        FROM stud s, stud_crse_year scy, award a
       WHERE s.stud_ref_no = scy.stud_ref_no
         AND scy.stud_crse_year_id = a.stud_crse_year_id
         AND a.award_id = award_id_in;

      ERROR_TEXT := 'Determining Campus ';

      --If cheque payment, set the payment address to Home
      --and get the CAMPUS_ID associated with the AWARD record
      --if not, set the payment address to Bank and set the CAMPUS_ID to NULL
      IF v_payment_method = 'C'
      THEN
         v_payment_addr := 'H';

         SELECT c.fees_campus
           INTO v_campus_id
           FROM stud_crse_year scy, award a, crse_year cy, crse c
          WHERE a.stud_crse_year_id = scy.stud_crse_year_id
            AND a.award_id = award_id_in
            AND scy.crse_year_id = cy.crse_year_id
            AND cy.crse_id = c.crse_id;
      ELSE
         v_payment_addr := 'B';
         v_campus_id := NULL;
      END IF;

      ERROR_TEXT := 'Setting payment status ';

      --if a CHAPS payment, set the PAYMENT_STATUS to SUCCESS(CHAPS is processed outside StEPS)
      --if not, set the PAYMENT_STATUS to Unpaid
      IF chaps_in = 'N'
      THEN
         v_payment_status := 'U';
      ELSE
         v_payment_status := 'S';
      END IF;

      ERROR_TEXT := 'Creating award instalment ';

      --Insert the data into the AWARD_INSTALMENT table
      INSERT INTO award_instalment
                  (award_id, payment_due_date, install_type, assessment_date,
                   amount, recovered_amount, contrib_amount,
                   net_amount, method, payee, payment_addr,
                   campus_id, payment_status, returned, reissue,
                   debt_returned, recalc, chaps, adhoc_type, last_updated_by,
                   last_updated_on
                  )
           VALUES (award_id_in, payment_due_date_in, 'MN', SYSDATE,
                   amount_in, recovered_amount_in, contrib_amount_in,
                   net_amount_in, v_payment_method, 'S', v_payment_addr,
                   v_campus_id, v_payment_status, 'N', 'N',
                   'N', 'N', chaps_in, UPPER (adhoc_type_in), employee_in,
                   SYSDATE
                  );

      --Check the scheme type associated with the AWARD_INSTALMENT record
      --if nursing, adjust the SNB debt with passed data
      --if not, update the debt with passed data
      IF v_scheme_type = 'B'
      THEN
         v_snb_op := recovered_amount_in;
         v_op := 0;
      ELSE
         v_snb_op := 0;
         v_op := recovered_amount_in;
      END IF;

      updateothers (award_id_in,
                    (0 - v_op),
                    (0 - v_snb_op),
                    (0 - contrib_amount_in),
                    employee_in,
                    error_boolean,
                    ERROR_TEXT
                   );

      IF error_boolean = 'true'
      THEN
         ERROR_TEXT := 'Error updating supporting tables : ' || ERROR_TEXT;
         ROLLBACK;
      ELSE
         error_boolean := 'false';
         ERROR_TEXT := 'none';
         COMMIT;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || ' - '
            || 'ERROR : PL SQL Procedure : insertawardinstalment : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END insertawardinstalment;

   PROCEDURE updateothers (
      award_id_in               IN       VARCHAR2,
      overpayment_diff_in       IN       VARCHAR2,
      snb_overpayment_diff_in   IN       VARCHAR2,
      resid_par_cont_diff_in    IN       VARCHAR2,
      employee_in               IN       VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2
   )
   IS
      v_stud_crse_year_id              NUMBER;
      v_stud_ref_no                    NUMBER;
      v_award_amount_total             NUMBER;
      v_award_recovered_total          NUMBER;
      v_award_contrib_total            NUMBER;
      v_award_net_amount_total         NUMBER;
      v_award_net_total                NUMBER;
      v_award_overpaid_contrib_total   NUMBER;
      v_sal_sent_flag                  VARCHAR2 (6);
      v_pre_sal_sent_flag              VARCHAR2 (6);
   BEGIN
      ERROR_TEXT := 'Getting supporting info - ';

      --Get supporting info from the STUD_CRSE_YEAR, STUD and AWARD tables
      SELECT scy.sal_sent, scy.stud_crse_year_id, s.stud_ref_no,
             b.type,
             NVL (a.overpaid_contrib, 0) AS overpaid_contrib
        INTO v_pre_sal_sent_flag, v_stud_crse_year_id, v_stud_ref_no,
             v_sal_sent_flag,
             v_award_overpaid_contrib_total
        FROM stud_crse_year scy, stud s, award a, stud_award_type b
       WHERE s.stud_ref_no = scy.stud_ref_no
         AND scy.stud_crse_year_id = a.stud_crse_year_id
         AND a.award_id = award_id_in
         AND a.stud_award_type = b.stud_award_type;

      --Check if a manual payment award type
      --if so, set the SAL_SENT_FLAG to its previous value(only issue an award notice if one was due to be produced)
      --if not, set SAL_SENT_FLAG to N (generate award notice)
      
      IF v_sal_sent_flag NOT IN ('BURS', 'DEPG', 'FEE', 'LOAN', 'LPCG', 'LPG','SMA')
      THEN
         v_sal_sent_flag := v_pre_sal_sent_flag;
      ELSE
         v_sal_sent_flag := 'N';
      END IF;

      ERROR_TEXT := 'Getting award info - ';

      --Sum the info of the AWARD_INSTALMENTS for the passed AWARD record
      SELECT SUM (ai.amount), SUM (ai.recovered_amount),
             SUM (ai.contrib_amount), SUM (ai.net_amount)
        INTO v_award_amount_total, v_award_recovered_total,
             v_award_contrib_total, v_award_net_amount_total
        FROM award_instalment ai
       WHERE ai.award_id = award_id_in;

      --Calculate the correct net amount
      SELECT   v_award_amount_total
             - v_award_contrib_total
             - v_award_recovered_total
             - v_award_overpaid_contrib_total
        INTO v_award_net_total
        FROM DUAL;

      ERROR_TEXT := 'Updating award - ';

      --Update the AWARD table with the amended details
      UPDATE award a
         SET a.assessment_date = SYSDATE,
             a.assess_reason_code = 'M',
             a.amount = v_award_amount_total,
             a.recovered_amount = v_award_recovered_total,
             a.contrib_amount = v_award_contrib_total,
             a.net_amount = v_award_net_total,
             a.last_updated_by = employee_in,
             a.last_updated_on = SYSDATE
       WHERE a.award_id = award_id_in;

      ERROR_TEXT := 'Updating overpayments - ';

      --Update the overpayment details for the student resulting
      --from any change to the students awards
      UPDATE stud s
         SET s.overpayment = (s.overpayment + overpayment_diff_in),
             s.snb_overpayment =
                                (s.snb_overpayment + snb_overpayment_diff_in
                                ),
             s.last_updated_by = employee_in,
             s.last_updated_on = SYSDATE
       WHERE s.stud_ref_no = v_stud_ref_no;

      ERROR_TEXT := 'Updating contribution - ';

      UPDATE stud_crse_year scy
         SET scy.resid_par_cont =
                                (scy.resid_par_cont + resid_par_cont_diff_in
                                ),
             scy.sal_sent = v_sal_sent_flag,
             scy.last_updated_by = employee_in,
             scy.last_updated_on = SYSDATE
       WHERE scy.stud_crse_year_id = v_stud_crse_year_id;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || ' - '
            || 'ERROR : PL SQL Procedure : updateothers : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END updateothers;

   PROCEDURE addaward (
      stud_crse_year_id_in   IN       VARCHAR2,
      amount_in              IN       VARCHAR2,
      contrib_in             IN       VARCHAR2,
      recovered_amount_in    IN       VARCHAR2,
      employee_in            IN       VARCHAR2,
      award_id_out           OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   IS
      v_award_type_description   VARCHAR2 (50);
      v_stud_ref_no              NUMBER;
      v_inst_code                VARCHAR2 (10);
      v_crse_id                  NUMBER;
      v_session_code             NUMBER;
      v_crse_year_no             NUMBER;
   BEGIN
      --get the next AWARD_ID from sequence
      SELECT aw_award_id_seq.NEXTVAL
        INTO award_id_out
        FROM DUAL;

      --Get the correct Award Type Description
      SELECT sat.award_type_descript
        INTO v_award_type_description
        FROM stud_award_type sat
       WHERE sat.stud_award_type = 'ADHOC';

      --Get supporting info for the AWARD record
      SELECT scy.stud_ref_no, scy.inst_code, scy.crse_id, scy.session_code,
             scy.crse_year_no
        INTO v_stud_ref_no, v_inst_code, v_crse_id, v_session_code,
             v_crse_year_no
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      --Insert the data into the AWARD table
      INSERT INTO award
                  (award_id, stud_crse_year_id, inst_code,
                   crse_id, award_src, stud_award_type, award_type_descript,
                   stud_ref_no, session_code, crse_year_no, assessment_date,
                   assess_reason_code, amount,
                   net_amount,
                   contrib_amount, recovered_amount, overpayment_amount,
                   hold, last_updated_by, last_updated_on
                  )
           VALUES (award_id_out, stud_crse_year_id_in, v_inst_code,
                   v_crse_id, 'A', 'ADHOC', v_award_type_description,
                   v_stud_ref_no, v_session_code, v_crse_year_no, SYSDATE,
                   'M', amount_in,
                   (amount_in - (contrib_in + recovered_amount_in)
                   ),
                   contrib_in, recovered_amount_in, 0,
                   'N', employee_in, SYSDATE
                  );

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || ' - '
            || 'ERROR : PL SQL Procedure : updateothers : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END addaward;

   PROCEDURE getawarddetails (
      stud_crse_year_id_in     IN       VARCHAR2,
      stud_award_type_in       IN       VARCHAR2,
      award_id_out             OUT      VARCHAR2,
      amount_out               OUT      VARCHAR2,
      net_amount_out           OUT      VARCHAR2,
      contrib_amount_out       OUT      VARCHAR2,
      recovered_amount_out     OUT      VARCHAR2,
      overpayment_amount_out   OUT      VARCHAR2,
      session_code_out         OUT      VARCHAR2,
      error_boolean            OUT      VARCHAR2,
      ERROR_TEXT               OUT      VARCHAR2
   )
   IS
      v_award_count   NUMBER;
   BEGIN
      --Get a count of the number of awards against the passed STUD_CRSE_YEAR_ID
      --for the passed STUD_AWARD_TYPE
      SELECT COUNT (*)
        INTO v_award_count
        FROM award a
       WHERE a.stud_crse_year_id = stud_crse_year_id_in
         AND a.stud_award_type = stud_award_type_in;

      --If there are awards for the STUD_AWARD_TYPE
      --retreive the current information from the AWARD table
      --If not, update output variables with zero values
      IF v_award_count > 0
      THEN
         SELECT a.award_id, a.amount, a.net_amount,
                a.contrib_amount, a.recovered_amount,
                a.overpayment_amount, a.session_code
           INTO award_id_out, amount_out, net_amount_out,
                contrib_amount_out, recovered_amount_out,
                overpayment_amount_out, session_code_out
           FROM award a
          WHERE a.stud_crse_year_id = stud_crse_year_id_in
            AND a.stud_award_type = stud_award_type_in;
      ELSE
         award_id_out := NULL;
         amount_out := 0;
         net_amount_out := 0;
         contrib_amount_out := 0;
         recovered_amount_out := 0;
         overpayment_amount_out := 0;

         SELECT scy.session_code
           INTO session_code_out
           FROM stud_crse_year scy
          WHERE scy.stud_crse_year_id = stud_crse_year_id_in;
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || ' - '
            || 'ERROR : PL SQL Procedure : getawarddetails : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getawarddetails;

   PROCEDURE updateadhocaward (
      award_id_in               IN       VARCHAR2,
      old_amount_in             IN       VARCHAR2,
      old_contrib_in            IN       VARCHAR2,
      old_recovered_amount_in   IN       VARCHAR2,
      new_amount_in             IN       VARCHAR2,
      new_contrib_in            IN       VARCHAR2,
      new_recovered_amount_in   IN       VARCHAR2,
      employee_in               IN       VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2
   )
   IS
      v_amount       NUMBER;
      v_net_amount   NUMBER;
      v_contrib      NUMBER;
      v_recovered    NUMBER;
   BEGIN
      v_amount := old_amount_in + new_amount_in;
      v_contrib := old_contrib_in + new_contrib_in;
      v_recovered := old_recovered_amount_in + new_recovered_amount_in;
      v_net_amount := v_amount - (v_contrib + v_recovered);

      UPDATE award a
         SET a.amount = v_amount,
             a.contrib_amount = v_contrib,
             a.recovered_amount = v_recovered,
             a.net_amount = v_net_amount,
             a.last_updated_by = UPPER (employee_in),
             a.last_updated_on = SYSDATE
       WHERE a.award_id = award_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || ' - '
            || 'ERROR : PL SQL Procedure : updateaddddhocaward : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END updateadhocaward;

   PROCEDURE getawardtype (
      stud_award_type_in        IN       VARCHAR2,
      stud_award_type_id_out    OUT      VARCHAR2,
      stud_award_type_out       OUT      VARCHAR2,
      scheme_out                OUT      VARCHAR2,
      award_type_descript_out   OUT      VARCHAR2,
      saas_make_payment_out     OUT      VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2
   )
   IS
   BEGIN
      --Get the award type information from the STUD_AWARD_TYPE table
      SELECT sat.stud_award_type_id, sat.stud_award_type, sat.scheme,
             sat.award_type_descript, sat.saas_make_payment
        INTO stud_award_type_id_out, stud_award_type_out, scheme_out,
             award_type_descript_out, saas_make_payment_out
        FROM stud_award_type sat
       WHERE sat.stud_award_type = UPPER (stud_award_type_in);

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || ' - '
            || 'ERROR : PL SQL Procedure : updateaddddhocaward : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getawardtype;
END pk_steps_ui_manual_payments;
/