CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_finance
AS
/******************************************************************************
   NAME:       PK_STEPS_UI_FINANCE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        01/10/2012   John Wynne      Created this package.
   1.1        14/02/2013   John Wynne      Added Get award types
   1.2        17/04/2013   John Wynne      Corrected defect in findtotalstudentspayment
******************************************************************************/
   PROCEDURE getmethod (
      io_cursor       IN OUT          methods_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   AS
      m_cursor   methods_cursor;
   BEGIN
      OPEN m_cursor FOR
         SELECT pm.descript AS description, pm.legacy_code AS VALUE
           FROM payment_method pm;

      io_cursor := m_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getMethod : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getmethod;

   PROCEDURE getstatuses (
      io_cursor       IN OUT          statuses_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   AS
      s_cursor   statuses_cursor;
   BEGIN
      OPEN s_cursor FOR
         SELECT ps.description AS description, ps.TYPE AS VALUE
           FROM payment_status ps;

      io_cursor := s_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getStatuses : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getstatuses;

   PROCEDURE getpayeetype (
      io_cursor       IN OUT          payee_type_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   AS
      pt_cursor   payee_type_cursor;
   BEGIN
      OPEN pt_cursor FOR
         SELECT pt.description AS description, pt.TYPE AS VALUE
           FROM payee_type pt;

      io_cursor := pt_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getPayeeType : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getpayeetype;

   PROCEDURE findstudent (
      stud_ref_in       IN              VARCHAR2,
      stud_exists_out   OUT             VARCHAR2,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   )
   AS
      studcount   NUMBER (3);
   BEGIN
      SELECT COUNT (*)
        INTO studcount
        FROM stud s
       WHERE s.stud_ref_no = stud_ref_in;

      IF studcount = 1
      THEN
         stud_exists_out := 'true';
      ELSIF studcount = 0
      THEN
         stud_exists_out := 'false';
      ELSE
         error_boolean := 'true';
         ERROR_TEXT := 'Several records exist for that student';
         stud_exists_out := 'false';
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : findStudent : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END findstudent;

   PROCEDURE checkpaymentreturned (
      payee_payment_id_in   IN              VARCHAR2,
      payment_exists_out    OUT             VARCHAR2,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )
   AS
      paymentcount   NUMBER (4);
   BEGIN
      SELECT COUNT (*)
        INTO paymentcount
        FROM payment_returns pr
       WHERE pr.payee_payment_id = payee_payment_id_in;

      IF paymentcount > 0
      THEN
         payment_exists_out := 'true';
      ELSE
         payment_exists_out := 'false';
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : checkPaymentReturned : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END checkpaymentreturned;

   PROCEDURE getstudentsawardtypepayments (
      io_cursor         IN OUT          sat_awardtype_cursor,
      payee_ref_id_in   IN              VARCHAR2,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   )
   AS
      sat_cursor   sat_awardtype_cursor;
   BEGIN
      OPEN sat_cursor FOR
         SELECT   sat.stud_award_type AS awardtype,
                  sat.award_type_descript AS awardtypedescription,
                  SUM (pp.net_amount_due) AS payment
             FROM payee_payment pp,
                  stud_award_type sat,
                  award a,
                  award_instalment ai,
                  payment_instalment pi
            WHERE pi.payee_payment_id = pp.payee_payment_id
              AND pi.award_instalment_id = ai.award_instalment_id
              AND ai.award_id = a.award_id
              AND a.stud_award_type = sat.stud_award_type
              AND pp.payee_ref_id = payee_ref_id_in
              AND pp.payment_status = 'S'
         GROUP BY sat.stud_award_type, sat.award_type_descript;

      io_cursor := sat_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getStudentsAwardTypePayments : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getstudentsawardtypepayments;

   PROCEDURE findtotalstudentspayment (
      payee_ref_id_in     IN              VARCHAR2,
      award_type_in       IN              VARCHAR2,
      total_payment_out   OUT             NUMBER,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   )
   AS
      sat_cursor   sat_awardtype_cursor;
   BEGIN
      SELECT SUM (pi.payment_amount)
        INTO total_payment_out
        FROM payee_payment pp,
             stud_award_type sat,
             award a,
             award_instalment ai,
             payment_instalment pi
       WHERE pi.payee_payment_id = pp.payee_payment_id
         AND pi.award_instalment_id = ai.award_instalment_id
         AND ai.award_id = a.award_id
         AND a.stud_award_type = sat.stud_award_type
         AND a.stud_award_type = award_type_in
         AND pp.payee_ref_id = payee_ref_id_in
         AND pi.payment_status = 'S'
         AND pp.payment_status = 'S';

      IF total_payment_out IS NULL
      THEN
         total_payment_out := 0;
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         total_payment_out := 0;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : findTotalStudentsPayment : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END findtotalstudentspayment;

   PROCEDURE getawardtypes (
      io_cursor         IN OUT   dd_cursor_awardtype,
      payee_ref_id_in   IN       VARCHAR2,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   )
   AS
      dd_cursor   dd_cursor_awardtype;
   BEGIN
      OPEN dd_cursor FOR
         SELECT DISTINCT (sat.award_type_descript) AS label, sat.TYPE AS KEY
                    FROM payee_payment pp,
                         stud_award_type sat,
                         award a,
                         award_instalment ai,
                         payment_instalment pi
                   WHERE pi.payee_payment_id = pp.payee_payment_id
                     AND pi.award_instalment_id = ai.award_instalment_id
                     AND ai.award_id = a.award_id
                     AND a.stud_award_type = sat.stud_award_type
                     AND pp.payee_ref_id = payee_ref_id_in
                     AND pp.payment_status = 'S'
                     AND sat.TYPE NOT IN ('LOAN', 'TRAV', 'FEE', 'PAY');

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getAwardTypes : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getawardtypes;

   PROCEDURE insertreturnedpayment (
      batch_date           IN              VARCHAR2,
      amount               IN              VARCHAR2,
      receipt_type_value   IN              VARCHAR2,
      payment_date         IN              VARCHAR2,
      payer_payment_id     IN              VARCHAR2,
      payer_ref            IN              VARCHAR2,
      payer_name           IN              VARCHAR2,
      award_type_value     IN              VARCHAR2,
      user_in              IN              VARCHAR2,
      method_value         IN              VARCHAR2,
      batch_reference      IN              VARCHAR2,
      ret_status           IN              VARCHAR2,
      override_in          IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   AS
      ret_date   DATE;
      pay_date   DATE;
   BEGIN
      SELECT TO_DATE (batch_date, 'dd/MM/yyyy'),
             TO_DATE (payment_date, 'dd/MM/yyyy')
        INTO ret_date,
             pay_date
        FROM DUAL;

      INSERT INTO payment_returns_load
                  (returns_date, returns_amount, receipt_type_id,
                   process_date, payee_payment_id, stud_ref_no, NAME,
                   stud_award_type, last_updated_by, last_updated_on,
                   payment_method, returns_batch, returns_status, override
                  )
           VALUES (ret_date, amount, receipt_type_value,
                   pay_date, payer_payment_id, payer_ref, payer_name,
                   award_type_value, user_in, SYSDATE,
                   method_value, batch_reference, ret_status, override_in
                  );

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : insertReturnedPayment : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END insertreturnedpayment;

   PROCEDURE getstudawardtypes (
      io_cursor        IN OUT          stud_awards_cursor,
      stud_ref_no_in   IN              VARCHAR2,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   AS
      award_cursor   stud_awards_cursor;
   BEGIN
      OPEN award_cursor FOR
         SELECT DISTINCT (a.stud_award_type) AS VALUE,
                         a.award_type_descript AS label
                    FROM payee_payment pp,
                         award a,
                         award_instalment ai,
                         payment_instalment pi
                   WHERE pi.payee_payment_id = pp.payee_payment_id
                     AND pi.award_instalment_id = ai.award_instalment_id
                     AND ai.award_id = a.award_id
                     AND pp.payee_ref_id = stud_ref_no_in
                     AND pi.payment_status = 'S'
                     AND pp.payment_status = 'S';

      io_cursor := award_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getStudAwardTypes : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getstudawardtypes;

   PROCEDURE getstudname (
      payee_ref_no_in   IN              VARCHAR2,
      payee_type_in     IN              VARCHAR2,
      student_name      OUT             VARCHAR2,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   )
   AS
      stud_exists   NUMBER (3);
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'None';
      student_name := 'Not found';

      SELECT COUNT (*)
        INTO stud_exists
        FROM payee_payment pp, payee p
       WHERE pp.payee_id = p.payee_id
         AND pp.payee_ref_id = payee_ref_no_in
         AND p.payee_type = payee_type_in
         AND pp.payment_status = 'S';

      IF stud_exists = 0
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'No payments have been made to that Payer Reference';
      ELSE
        SELECT account_name
          INTO student_name
          FROM (  SELECT pp.account_name
                    FROM payee_payment pp, payee p
                   WHERE     pp.payee_id = p.payee_id
                         AND pp.payee_ref_id = payee_ref_no_in
                         AND p.payee_type = payee_type_in
                         AND pp.payment_status = 'S'
                ORDER BY pp.last_updated_on DESC)
         WHERE ROWNUM <= 1;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getStudName : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getstudname;

   PROCEDURE getstudawardpayments (
      payee_ref_no_in   IN              VARCHAR2,
      payee_type_in     IN              VARCHAR2,
      io_cursor         IN OUT          stud_payment_awards_cursor,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   )
   AS
      pay_award_cursor   stud_payment_awards_cursor;   
   BEGIN
        OPEN pay_award_cursor FOR 
          SELECT pi.payment_instalment_id, pi.payment_amount 
            FROM payee_payment pp,
                 stud_award_type sat,
                 award a,
                 award_instalment ai,
                 payment_instalment pi
           WHERE pi.payee_payment_id = pp.payee_payment_id
             AND pi.award_instalment_id = ai.award_instalment_id
             AND ai.award_id = a.award_id
             AND a.stud_award_type = sat.stud_award_type
             AND a.stud_award_type = payee_type_in
             AND pp.payee_ref_id = payee_ref_no_in
             AND pi.payment_status = 'S'
             AND pp.payment_status = 'S';               
   
      io_cursor := pay_award_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';   
   
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getStudAwardPayments : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;   
   END getstudawardpayments;      
END pk_steps_ui_finance;
/