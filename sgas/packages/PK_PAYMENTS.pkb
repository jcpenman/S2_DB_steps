CREATE OR REPLACE PACKAGE BODY SGAS.pk_payments
AS
   /******************************************************************************
      NAME:       SELECT_FEE_INSTALMENTS
      PURPOSE:    Picks up data required for FEE Payments

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        10/02/2010 Paul Hughes    1. Created
      1.1        20/05/2010 John Penman    2. Modified select statement for new
                                              mappings and remove old columns for
                                              mappings
      1.2        27/05/2010 John Penman    3. Created checkBatchExists function
      1.3        22/06/2010 Paul Hughes    4.  cursor SCOAP_PAYMENTS REF3 changed to use payee_payment_id
      1.4        11/11/2010 Paul Hughes    5.  Aggregate Procedure is updated to handle debt.
      1.5        17/03/2011 Paul Hughes    6.  Fix with AccountName being too large for PAYEE on SCOAP_PAYMENTS table Fixed
      1.6        18/03/2011 Paul Hughes    7.  tidy of redundant code with added error handling for procedures
      1.7        21/03/2011 Paul Hughes    8.  Fix to ADI_JOURNAL CURSOR FOR AWARDS.
      1.8        22/03/2011 Paul Hughes    9.  Fix for FEES when over 1000 in batch and new batch number created creating multiple rows
      1.9        25/03/2011 Paul Hughes    10. Fix so ADI_JOURNAL is only created if the payee_payment.net_amount
      2.0        28/03/2011 Paul Hughes    11. Marked as final version for live.
      2.1        15/04/2011 Paul Hughes    12. When no payments running payment error record inserted in error - added Fee_type = 'A' for select AWARDS.
      2.2        27/04/2011 Paul Hughes    13.  PAYMENT_METHOD amended to pick this up from Nominee table instead of STUD table if the payee is Nominee.
      2.3        13/07/2011 Paul Hughes    14.  Attendance Data changes
      2.4        13/08/2011 Paul Hughes    15.  Added in Release Payments date for attendance validation service.
      2.5        08/10/2011 Paul Hughes    16.  Added in Returns Process Procedure.  Fix to SCOAP_BATCHES PAYEE_REF.
      2.6        15/08/2012 Paul Hughes    17.  Nominee Payments for BACS Only Functional Specification changes for PAYEE_PAYMENT cursor
      2.7        09/11/2016 Clark Bolan    18. Added CESB to ensure they get the attendance check
      2.8        28/02/2019 Clark Bolan    19. Added getCostCentre for CR514
                 28/02/2019 John Penman    20. Added getAccountName for CR514
                 28/02/2019 John Penman    21. Added getProgramme for CR514
                 23/03/2020 Paul Hughes    22. Added New AdhocType for COVID-19 Manual Payments Emergency Release

   ******************************************************************************/


   ----IF THE PAYEE_ID SUPPLIED IS FOR FEES, THIS FUNCTION WILL RETURN THE CORRESPONDING PAYEE_ID FOR THE LOAN RECORD AND VICE VERSA.
   FUNCTION getCorrespondingPayeeID (p_payee_id IN NUMBER)
      RETURN NUMBER
   IS
      v_ref_id   NUMBER;
      v_type     CHAR;
      v_result   NUMBER;
   BEGIN
      SELECT PAYEE_REF_ID, PAYMENT_TYPE
        INTO v_ref_id, v_type
        FROM PAYEE
       WHERE payee_id = p_payee_id;

      IF v_type = 'F'
      THEN
         SELECT payee_id
           INTO v_result
           FROM payee
          WHERE payee_ref_id = v_ref_id AND payment_type = 'L';
      ELSE
         SELECT payee_id
           INTO v_result
           FROM payee
          WHERE payee_ref_id = v_ref_id AND payment_type = 'F';
      END IF;

      RETURN v_result;
   END getCorrespondingPayeeID;

   FUNCTION doesCorrespondingPayeeIDExist (p_payee_id           IN NUMBER,
                                           p_payment_run_date   IN CHAR)
      RETURN CHAR
   IS
      v_temp       NUMBER;
      v_payee_id   NUMBER;
      l_result     CHAR;
      v_temp2      NUMBER;
   BEGIN
      SELECT COUNT (pk_payments.getcorrespondingPayeeID (p_payee_id))
        INTO v_temp
        FROM DUAL;

      IF v_temp = 0
      THEN
         l_result := 'N';
      ELSE ---DOES CORRESPONDING RESULT EXIST IN THE CURRENT PAYMENT RUN SO WE CAN COPY RESULTS
         SELECT pk_payments.getcorrespondingPayeeID (p_payee_id)
           INTO v_payee_id
           FROM DUAL;

         SELECT COUNT (*)
           INTO v_temp2
           FROM PAYEE_PAYMENT
          WHERE     payee_id = v_payee_id
                AND PAYMENT_STATUS = 'I'
                AND TRUNC (PAYMENT_RUN_DATE) =
                       TO_DATE (p_payment_run_date, 'DD/MM/YYYY');

         IF v_temp2 = 0
         THEN
            l_result := 'N';
         ELSE
            l_result := 'Y';
         END IF;
      END IF;

      RETURN l_result;
   END doesCorrespondingPayeeIDExist;


   ---THIS FUNCTION IS USED IN ORDER TO CHECK AND SEE IF EITHER FEE OR LOAN TYPE OF PAYEE_PAYMENT RECORD EXISTS.  IT IS USED LATER TO DETERMINE IF A DUMMY COREESPONDING RECORD
   ---NEEDS TO BE CREATED.


   FUNCTION doesPayeePaymentPayeeIDExist (p_payee_id           IN NUMBER,
                                          p_payment_run_date   IN CHAR)
      RETURN CHAR
   IS
      v_temp     NUMBER;
      v_result   CHAR (1);
   BEGIN
      SELECT COUNT (*)
        INTO v_temp
        FROM payee_payment
       WHERE     TRUNC (PAYMENT_RUN_DATE) =
                    TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
             AND payment_status = 'I'
             AND payee_id = p_payee_id;

      IF v_temp > 0
      THEN
         v_result := 'Y';
      ELSE
         v_result := 'N';
      END IF;

      RETURN v_result;
   END doesPayeePaymentPayeeIDExist;


   FUNCTION getNetAmountDueFee (p_campus_id IN NUMBER)
      RETURN NUMBER
   IS
      v_amount   NUMBER (9);
      v_temp     NUMBER (9);
   BEGIN
      SELECT COUNT (*)
        INTO v_temp
        FROM PAYEE_PAYMENT a, PAYEE b
       WHERE     a.PAYEE_ID = b.PAYEE_ID
             AND a.payment_status = 'I'
             AND b.payment_type = 'F'
             AND a.payee_ref_id = p_campus_id;

      IF v_temp = 0
      THEN
         v_amount := 0;
      ELSE
         SELECT SUM (a.NET_AMOUNT_DUE)
           INTO v_amount
           FROM PAYEE_PAYMENT a, PAYEE b
          WHERE     a.PAYEE_ID = b.PAYEE_ID
                AND a.payment_status = 'I'
                AND b.payment_type = 'F'
                AND a.payee_ref_id = p_campus_id;
      END IF;


      RETURN v_amount;
   END getNetAmountDueFee;

   FUNCTION getNetAmountDueLoan (p_campus_id IN NUMBER)
      RETURN NUMBER
   IS
      v_amount   NUMBER (9);
      v_temp     NUMBER (9);
   BEGIN
      SELECT COUNT (*)
        INTO v_temp
        FROM PAYEE_PAYMENT a, PAYEE b
       WHERE     a.PAYEE_ID = b.PAYEE_ID
             AND b.payment_type = 'L'
             AND a.payment_status = 'I'
             AND a.payee_ref_id = p_campus_id;

      IF v_temp = 0
      THEN
         v_amount := 0;
      ELSE
         SELECT SUM (a.NET_AMOUNT_DUE)
           INTO v_amount
           FROM PAYEE_PAYMENT a, PAYEE b
          WHERE     a.PAYEE_ID = b.PAYEE_ID
                AND a.payment_status = 'I'
                AND b.payment_type = 'L'
                AND a.payee_ref_id = p_campus_id;
      END IF;


      RETURN v_amount;
   END getNetAmountDueLoan;



   FUNCTION getSuspenseDebtToCreditAccount (p_payment_run_date IN CHAR)
      RETURN NUMBER
   IS
      l_result   NUMBER (9);
   BEGIN
      SELECT SUM (prev_outstanding_amount)
        INTO l_result
        FROM PAYEE
       WHERE     PAYEE_REF_ID IN
                    (SELECT PAYEE_REF_ID
                       FROM PAYEE_PAYMENT
                      WHERE     PAYMENT_STATUS = 'I'
                            AND TRUNC (PAYMENT_RUN_DATE) =
                                   TO_DATE (p_payment_run_date, 'DD/MM/YYYY'))
             AND payment_type IN ('F', 'L');

      RETURN l_result;
   END getSuspenseDebtToCreditAccount;


   FUNCTION GETPAYEECREDITS (p_payment_run_date IN CHAR, p_type IN CHAR)
      RETURN NUMBER
   IS
      l_result   NUMBER (9);
   BEGIN
      SELECT SUM (prev_outstanding_amount)
        INTO l_result
        FROM PAYEE
       WHERE     PAYEE_REF_ID IN
                    (SELECT PAYEE_REF_ID
                       FROM PAYEE_PAYMENT
                      WHERE     PAYMENT_STATUS = 'I'
                            AND TRUNC (PAYMENT_RUN_DATE) =
                                   TO_DATE (p_payment_run_date, 'DD/MM/YYYY'))
             AND payment_type = p_type;

      RETURN l_result;
   END GETPAYEECREDITS;


   FUNCTION countvariationAwards (p_days_ahead_bacs     IN NUMBER,
                                  p_days_ahead_cheque   IN NUMBER)
      RETURN NUMBER
   IS
      variationAwards   NUMBER (9);
   BEGIN
      SELECT COUNT (DISTINCT ai.payment_due_date || ai.method) + 1 --||ai.payee)
        INTO variationAwards
        FROM award_instalment ai,
             award a,
             stud_crse_year scy,
             stud s,
             stud_award_type sat,
             stud_session st,
             dsa_payment dsa,
             nominee n
       WHERE     ai.award_id = a.award_id
             AND ai.award_instalment_id = dsa.award_instalment_id(+)
             AND dsa.payee_id = n.nominee_id(+)
             AND a.stud_award_type = sat.stud_award_type
             AND st.stud_session_id = scy.stud_session_id
             AND a.stud_crse_year_id = scy.stud_crse_year_id
             AND scy.stud_ref_no = s.stud_ref_no
             AND a.award_src = 'A'
             AND ai.payment_status = 'U'
             AND ai.net_amount > 0
             AND s.suspend_payment = 'N'
             AND s.stud_suspend = 'N'
             AND st.session_suspend = 'N'
             AND scy.crse_suspend = 'N' ----WE REQUIRE JOIN TO DSA TABLE TO IMPLEMENT DSA PAYMENT STOP CODE HERE
             AND (   (    TRUNC (ai.payment_due_date) <=
                             TRUNC (SYSDATE + p_days_ahead_bacs)
                      --CONFIG NUMBER OF DAYS AHEAD FOR BACS PAYMENTS
                      AND ai.method = 'B'
                      AND ai.payment_due_date >=
                               SYSDATE
                             + (SELECT nval
                                  FROM config_data
                                 WHERE item_name = 'BACS_PROCESS_DAYS'))
                  OR (    TRUNC (ai.payment_due_date) <=
                             TRUNC (SYSDATE + p_days_ahead_cheque)
                      --CONFIG NUMBER OF DAYS AHEAD FOR CHEQUE PAYMENTS
                      AND ai.method = 'C'
                      AND ai.payment_due_date >=
                               SYSDATE
                             + (SELECT nval
                                  FROM config_data
                                 WHERE item_name = 'CHEQUE_PROCESS_DAYS')));

      RETURN variationAwards;
   END countvariationAwards;


   ---VARIATION IN FEES IS ALWAYS ONE AS THEY ARE ALL SAME PAYMENT DATE AND SAME BATCH
   FUNCTION countvariationFees (p_pay_due_days_ahead IN NUMBER)
      RETURN NUMBER
   IS
      variationfees   NUMBER (9);
   BEGIN
      SELECT COUNT (DISTINCT ai.payment_due_date || ai.method)
        INTO variationfees
        FROM award_instalment ai,
             award a,
             stud_crse_year scy,
             campus d,
             stud_award_type sat,
             stud_session st,
             stud s
       WHERE     ai.award_id = a.award_id
             AND s.stud_ref_no = st.stud_ref_no
             AND a.stud_award_type = sat.stud_award_type
             AND a.stud_crse_year_id = scy.stud_crse_year_id
             AND scy.stud_session_id = st.stud_session_id
             AND ai.campus_id = d.campus_id(+)
             AND a.award_src = 'T'
             AND s.suspend_payment = 'N'
             AND s.stud_suspend = 'N'
             AND st.session_suspend = 'N'
             AND scy.crse_suspend = 'N'
             AND TRUNC (ai.payment_due_date) <=
                    TRUNC (SYSDATE + p_pay_due_days_ahead)
             --CONFIG NUMBER OF DAYS HERE FOR BACS TAKEN FROM CONFIG_DATA VALUE
             AND ai.payment_status = 'U';

      RETURN variationFees;
   END countvariationFees;

   FUNCTION countFeePayments (p_pay_due_days_ahead IN NUMBER)
      RETURN NUMBER
   IS
      totalFees   NUMBER (9);
   BEGIN
      SELECT COUNT (*)
        INTO totalFees
        FROM award_instalment ai,
             award a,
             stud_crse_year scy,
             campus d,
             stud_award_type sat,
             stud_session st,
             stud s
       WHERE     ai.award_id = a.award_id
             AND s.stud_ref_no = st.stud_ref_no
             AND a.stud_award_type = sat.stud_award_type
             AND a.stud_crse_year_id = scy.stud_crse_year_id
             AND scy.stud_session_id = st.stud_session_id
             AND ai.campus_id = d.campus_id(+)
             AND a.award_src = 'T'
             AND s.suspend_payment = 'N'
             AND s.stud_suspend = 'N'
             AND st.session_suspend = 'N'
             AND scy.crse_suspend = 'N'
             AND TRUNC (ai.payment_due_date) <=
                    TRUNC (SYSDATE + p_pay_due_days_ahead)
             --CONFIG NUMBER OF DAYS HERE FOR BACS TAKEN FROM CONFIG_DATA VALUE
             AND ai.payment_status = 'U';

      RETURN totalFees;
   END countFeePayments;



   FUNCTION countAwardPayments (p_days_ahead_bacs     IN NUMBER,
                                p_days_ahead_cheque   IN NUMBER)
      RETURN NUMBER
   IS
      totalAwards   NUMBER (9);
   BEGIN
      SELECT COUNT (*)
        INTO totalAwards
        FROM award_instalment ai,
             award a,
             stud_crse_year scy,
             stud s,
             stud_award_type sat,
             stud_session st,
             dsa_payment dsa,
             nominee n
       WHERE     ai.award_id = a.award_id
             AND ai.award_instalment_id = dsa.award_instalment_id(+)
             AND dsa.payee_id = n.nominee_id(+)
             AND a.stud_award_type = sat.stud_award_type
             AND st.stud_session_id = scy.stud_session_id
             AND a.stud_crse_year_id = scy.stud_crse_year_id
             AND scy.stud_ref_no = s.stud_ref_no
             AND a.award_src = 'A'
             AND ai.payment_status = 'U'
             AND ai.net_amount > 0
             AND s.suspend_payment = 'N'
             AND s.stud_suspend = 'N'
             AND st.session_suspend = 'N'
             AND scy.crse_suspend = 'N' ----WE REQUIRE JOIN TO DSA TABLE TO IMPLEMENT DSA PAYMENT STOP CODE HERE
             AND (   (    TRUNC (ai.payment_due_date) <=
                             TRUNC (SYSDATE + p_days_ahead_bacs)
                      --CONFIG NUMBER OF DAYS AHEAD FOR BACS PAYMENTS
                      AND ai.method = 'B')
                  OR (    TRUNC (ai.payment_due_date) <=
                             TRUNC (SYSDATE + p_days_ahead_cheque)
                      --CONFIG NUMBER OF DAYS AHEAD FOR CHEQUE PAYMENTS
                      AND ai.method = 'C'));

      RETURN totalAwards;
   END countAwardPayments;

   FUNCTION getPaymentNumber (p_award_instalment_id   IN NUMBER,
                              p_stud_ref_no           IN NUMBER,
                              p_session_code          IN NUMBER)
      RETURN NUMBER
   IS
      x                     NUMBER (4);
      v_payment_due_date    DATE;
      l_paymentInstalment   NUMBER := 0;

      CURSOR c_payment
      IS
           SELECT DISTINCT a.payment_due_date
             FROM award_instalment a, award b, stud_award_type c
            WHERE     a.award_id = b.award_id
                  AND b.stud_ref_no = p_stud_ref_no
                  AND b.session_code = p_session_code
                  AND b.stud_award_type = c.stud_award_type
                  AND (   c.TYPE IN
                             ('BURS',
                              'CESB',
                              'LPG',
                              'DEPG',
                              'LPCG',
                              'SMA',
                              'PEPG')
                       OR a.adhoc_type = 'F')
                  AND b.award_src = 'A'
         ORDER BY a.payment_due_date;

      v_payment             c_payment%ROWTYPE;
   BEGIN
      SELECT payment_due_date
        INTO v_payment_due_date
        FROM AWARD_INSTALMENT
       WHERE award_instalment_id = p_award_instalment_id;


      OPEN c_payment;

      x := 0;

      LOOP
         x := x + 1;

         FETCH c_payment INTO v_payment;

         EXIT WHEN c_payment%NOTFOUND;


         IF v_payment.payment_due_date = v_payment_due_date
         THEN
            l_paymentInstalment := x;
         END IF;
      END LOOP;

      CLOSE c_payment;


      RETURN l_paymentInstalment;
   END getPaymentNumber;


   FUNCTION checkNumberOfPaidAwards (p_award_instalment_id IN NUMBER)
      RETURN NUMBER
   IS
      paidaward        NUMBER := 0;
      v_stud_ref_no    NUMBER := 0;
      v_session_code   NUMBER := 0;
   BEGIN
      SELECT a.stud_ref_no, a.session_code
        INTO v_stud_ref_no, v_session_code
        FROM AWARD a, AWARD_INSTALMENT AI
       WHERE     A.AWARD_ID = AI.AWARD_ID
             AND AWARD_INSTALMENT_ID = p_award_instalment_id;


      SELECT COUNT (ai.award_instalment_id)
        INTO paidaward
        FROM award_instalment ai, award a
       WHERE     ai.award_id = a.award_id
             AND a.award_src = 'A' ---WE ONLY WANT TO COUNT IF AWARD PAYMENTS HAVE BEEN MADE
             AND a.stud_ref_no = v_stud_ref_no
             AND a.session_code = v_session_code
             AND ai.batch_ref IS NOT NULL
             AND ai.payment_status = 'S'; ---_THIS WAS PREVIOUSLY SET TO NULL FOR SOME REASON

      RETURN paidaward;
   END checkNumberOfPaidAwards;

   FUNCTION get_AD_NURSING_Flag (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR
   IS
      l_result   CHAR;
      l_count    NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO l_count
        FROM NMSB_SPEC_ARR a, STUD_CRSE_YEAR b
       WHERE     a.stud_ref_no = b.stud_ref_no
             AND a.session_code = b.session_code
             AND b.stud_crse_year_id = p_stud_crse_year_id;

      IF l_count > 0
      THEN
         l_result := 'Y';
      ELSE
         l_result := 'N';
      END IF;

      RETURN l_result;
   END get_AD_NURSING_Flag;



   FUNCTION checkBatchExists (p_payment_date         IN VARCHAR2,
                              p_method               IN VARCHAR2,
                              p_payee                IN VARCHAR2,
                              p_max_batch_payments   IN NUMBER)
      RETURN VARCHAR2
   IS
      batch_ref         VARCHAR2 (100) := 'N';
      batch_ref_temp    NUMBER := 0;
      batch_ref_temp2   NUMBER := 0;
   BEGIN
      SELECT COUNT (*)
        INTO batch_ref_temp
        FROM (SELECT BATCH_REF
                FROM (  SELECT pi.batch_ref AS BATCH_REF,
                               COUNT (pi.batch_ref) AS COUNT
                          FROM payment_instalment pi, scoap_batches sb
                         WHERE     pi.payment_status = 'A'
                               AND pi.payment_date =
                                      TO_DATE (p_payment_date, 'DD/MM/YYYY') ---TRUNC REMOVED
                               AND sb.dpb_batch_ref = pi.batch_ref
                               AND sb.dpb_type = p_payee --------STUDENT OR INSTITUTIONS
                               AND sb.dpb_payment_type = p_method ---PAYMENT METHOD
                      GROUP BY pi.batch_ref, sb.dpb_type, sb.dpb_payment_type)
               WHERE COUNT < p_max_batch_payments + 1);



      IF batch_ref_temp > 0
      THEN
         SELECT BATCH_REF
           INTO batch_ref
           FROM (  SELECT pi.batch_ref AS BATCH_REF,
                          COUNT (pi.batch_ref) AS COUNT
                     FROM payment_instalment pi, scoap_batches sb
                    WHERE     pi.payment_status = 'A'
                          AND pi.payment_date =
                                 TO_DATE (p_payment_date, 'DD/MM/YYYY')
                          AND sb.dpb_batch_ref = pi.batch_ref
                          AND sb.dpb_type = p_payee --------STUDENT OR INSTITUTIONS
                          AND sb.dpb_payment_type = p_method ---PAYMENT METHOD
                 GROUP BY pi.batch_ref, sb.dpb_type, sb.dpb_payment_type)
          WHERE COUNT < p_max_batch_payments + 1;
      ELSE
         batch_ref := 'FALSE';
      END IF;

      RETURN batch_ref;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         batch_ref := 'FALSE';

         RETURN batch_ref;
   END checkBatchExists;

   FUNCTION getCostCentre (award_instalment_id_in   IN NUMBER,
                           stud_award_type_in       IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_cost_centre   VARCHAR2 (6);
      l_adhoc_type    VARCHAR2 (1);
   BEGIN
      SELECT adhoc_type
        INTO l_adhoc_type
        FROM award_instalment
       WHERE award_instalment_id = award_instalment_id_in;

      IF l_adhoc_type = 'A'
      THEN
         SELECT cost_centre
           INTO l_cost_centre
           FROM stud_award_type
          WHERE STUD_AWARD_TYPE = 'ADHOC2';
      ELSIF (l_adhoc_type = 'T' OR l_adhoc_type = 'U')
      THEN
         SELECT cost_centre
           INTO l_cost_centre
           FROM stud_award_type
          WHERE STUD_AWARD_TYPE = 'ADHOC';
      ELSIF (l_adhoc_type = 'I' OR l_adhoc_type = 'N')
      THEN
         SELECT cost_centre
           INTO l_cost_centre
           FROM stud_award_type
          WHERE STUD_AWARD_TYPE = 'ADHOC3';
      ELSIF l_adhoc_type = 'W'
      THEN
         SELECT cost_centre
           INTO l_cost_centre
           FROM stud_award_type
          WHERE STUD_AWARD_TYPE = 'ADHOC4';
      ELSE
         SELECT cost_centre
           INTO l_cost_centre
           FROM stud_award_type
          WHERE STUD_AWARD_TYPE = stud_award_type_in;
      END IF;


      RETURN l_cost_centre;
   END getCostCentre;

   FUNCTION getAccountName (award_instalment_id_in   IN NUMBER,
                            stud_award_type_in       IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_account_name   VARCHAR2 (15);
      l_adhoc_type     VARCHAR2 (1);
   BEGIN
      SELECT adhoc_type
        INTO l_adhoc_type
        FROM award_instalment
       WHERE award_instalment_id = award_instalment_id_in;

      IF l_adhoc_type = 'A'
      THEN
         SELECT account_name
           INTO l_account_name
           FROM stud_award_type
          WHERE STUD_AWARD_TYPE = 'ADHOC2';
      ELSIF (l_adhoc_type = 'T' OR l_adhoc_type = 'U')
      THEN
         SELECT account_name
           INTO l_account_name
           FROM stud_award_type
          WHERE STUD_AWARD_TYPE = 'ADHOC';
      ELSIF (l_adhoc_type = 'I' OR l_adhoc_type = 'N')
      THEN
         SELECT account_name
           INTO l_account_name
           FROM stud_award_type
          WHERE STUD_AWARD_TYPE = 'ADHOC3';
      ELSIF l_adhoc_type = 'W'
      THEN
         SELECT account_name
           INTO l_account_name
           FROM stud_award_type
          WHERE STUD_AWARD_TYPE = 'ADHOC4';
      ELSE
         SELECT account_name
           INTO l_account_name
           FROM stud_award_type
          WHERE STUD_AWARD_TYPE = stud_award_type_in;
      END IF;


      RETURN l_account_name;
   END getAccountName;

   FUNCTION getProgramme (award_instalment_id_in   IN NUMBER,
                          stud_award_type_in       IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_programme    VARCHAR2 (3);
      l_adhoc_type   VARCHAR2 (1);
   BEGIN
      SELECT adhoc_type
        INTO l_adhoc_type
        FROM award_instalment
       WHERE award_instalment_id = award_instalment_id_in;

      IF l_adhoc_type = 'A'
      THEN
         SELECT programme
           INTO l_programme
           FROM stud_award_type
          WHERE STUD_AWARD_TYPE = 'ADHOC2';
      ELSIF (l_adhoc_type = 'T' OR l_adhoc_type = 'U')
      THEN
         SELECT programme
           INTO l_programme
           FROM stud_award_type
          WHERE STUD_AWARD_TYPE = 'ADHOC';
      ELSIF (l_adhoc_type = 'I' OR l_adhoc_type = 'N')
      THEN
         SELECT programme
           INTO l_programme
           FROM stud_award_type
          WHERE STUD_AWARD_TYPE = 'ADHOC3';
      ELSIF l_adhoc_type = 'W'
      THEN
         SELECT programme
           INTO l_programme
           FROM stud_award_type
          WHERE STUD_AWARD_TYPE = 'ADHOC4';
      ELSE
         SELECT programme
           INTO l_programme
           FROM stud_award_type
          WHERE STUD_AWARD_TYPE = stud_award_type_in;
      END IF;


      RETURN l_programme;
   END getProgramme;



   FUNCTION getAwardInstalmentID (p_i_id IN NUMBER, p_p_id IN NUMBER)
      RETURN NUMBER
   IS
      l_award_instalment_id   NUMBER (15);
   BEGIN
      SELECT pi.award_instalment_id
        INTO l_award_instalment_id
        FROM payment_instalment pi, payee_payment pp
       WHERE     pi.payee_payment_id = pp.payee_payment_id
             AND pi.payment_instalment_id = p_i_id
             AND pp.payee_payment_id = p_p_id;

      RETURN l_award_instalment_id;
   END getAwardInstalmentID;



   PROCEDURE select_fee_instalments (p_pay_due_days_ahead   IN     NUMBER,
                                     p_fees_paymenttype     IN OUT fees_cur)
   IS
   BEGIN
      OPEN p_fees_paymenttype FOR
         SELECT d.NAME AS account_name,
                d.account_no,
                sat.account_name AS account,
                scy.attend_confirmed,
                ad.enrol_confirmed AS AD_ENROL_CONFIRMED,
                ad.enrol_required AS AD_ENROL_REQUIRED,
                AD.ONGOING_ATTENDANCE_CONFIRMED
                   AS AD_ONGOING_ATTEND_CONFIRMED,
                ad.ongoing_required AS AD_ONGOING_REQUIRED,
                ad.restrict_fee_support_attend
                   AS AD_RESTRICT_FEE_SUPPORT_ATTEND,
                ad.restrict_fee_attend AS AD_RESTRICT_FEE_ATTEND_DATE,
                ad.release_fee_attend AS AD_RELEASE_PAYMENTS_FEES_DATE,
                ai.award_instalment_id,
                ai.campus_id,
                sat.cost_centre,
                --   a.dsa_allowance_id,
                --    ai.dsa_fee_instalment,
                sat.entity,
                scy.inst_code,
                ai.method,
                ai.net_amount,
                '1' AS nominee_id,
                ai.payee,
                ai.payment_addr,
                TO_CHAR (ai.payment_due_date, 'DD-MM-YYYY')
                   AS payment_due_date,
                d.payment_method AS campus_method,
                sat.programme,
                a.session_code,
                d.bank_sort_code,
                a.stud_award_type,
                a.stud_crse_year_id,
                a.stud_ref_no,
                '02' AS sub_type,
                --    ai.trav_amount,
                CASE
                   WHEN a.stud_award_type IN('FEES', 'SNFEE', 'GAFEE') THEN 'F'
                   WHEN a.stud_award_type = 'TFEL' THEN 'L'
                   ELSE 'A'
                END
                   AS fee_type
           FROM award_instalment ai,
                award a,
                stud_crse_year scy,
                campus d,
                stud_award_type sat,
                stud_session st,
                stud s,
                attendance_data ad
          WHERE     ai.award_id = a.award_id
                AND s.stud_ref_no = st.stud_ref_no
                AND a.stud_award_type = sat.stud_award_type
                AND a.stud_crse_year_id = scy.stud_crse_year_id
                AND scy.stud_session_id = st.stud_session_id
                AND scy.stud_crse_year_id = ad.stud_crse_year_id
                AND ai.campus_id = d.campus_id(+)
                AND a.award_src = 'T'
                AND s.suspend_payment = 'N'
                AND s.stud_suspend = 'N'
                AND st.session_suspend = 'N'
                AND scy.crse_suspend = 'N'
                AND TRUNC (ai.payment_due_date) <=
                       TRUNC (SYSDATE + p_pay_due_days_ahead)
                --CONFIG NUMBER OF DAYS HERE FOR BACS TAKEN FROM CONFIG_DATA VALUE
                AND ai.payment_status = 'U'
         UNION
         SELECT d.NAME AS account_name,
                d.account_no,
                sat.account_name AS account,
                scy.attend_confirmed,
                ad.enrol_confirmed AS AD_ENROL_CONFIRMED,
                ad.enrol_required AS AD_ENROL_REQUIRED,
                AD.ONGOING_ATTENDANCE_CONFIRMED
                   AS AD_ONGOING_ATTEND_CONFIRMED,
                ad.ongoing_required AS AD_ONGOING_REQUIRED,
                ad.restrict_fee_support_attend
                   AS AD_RESTRICT_FEE_SUPPORT_ATTEND,
                ad.restrict_fee_attend AS AD_RESTRICT_FEE_ATTEND_DATE,
                ad.release_fee_attend AS AD_RELEASE_PAYMENTS_FEES_DATE,
                ai.award_instalment_id,
                ai.campus_id,
                sat.cost_centre,
                --   a.dsa_allowance_id,
                --    ai.dsa_fee_instalment,
                sat.entity,
                scy.inst_code,
                ai.method,
                ai.net_amount,
                '1' AS nominee_id,
                ai.payee,
                ai.payment_addr,
                TO_CHAR (ai.payment_due_date, 'DD-MM-YYYY')
                   AS payment_due_date,
                d.payment_method AS campus_method,
                sat.programme,
                a.session_code,
                d.bank_sort_code,
                a.stud_award_type,
                a.stud_crse_year_id,
                a.stud_ref_no,
                '02' AS sub_type,
                --    ai.trav_amount,
                CASE
                   WHEN a.stud_award_type IN('FEES', 'SNFEE', 'GAFEE') THEN 'F'
                   WHEN a.stud_award_type = 'TFEL' THEN 'L'
                   ELSE 'A'
                END
                   AS fee_type
           FROM award_instalment ai,
                award a,
                stud_crse_year scy,
                campus d,
                stud_award_type sat,
                stud_session st,
                stud s,
                attendance_data ad
          WHERE     ai.award_id = a.award_id
                AND s.stud_ref_no = st.stud_ref_no
                AND a.stud_award_type = sat.stud_award_type
                AND a.stud_crse_year_id = scy.stud_crse_year_id
                AND scy.stud_session_id = st.stud_session_id
                AND scy.stud_crse_year_id = ad.stud_crse_year_id
                AND ai.campus_id = d.campus_id(+)
                AND a.award_src = 'T'
                -- AND s.suspend_payment = 'N'
                --AND s.stud_suspend = 'N'
                -- AND st.session_suspend = 'N'
                --AND scy.crse_suspend = 'N'
                AND TRUNC (ai.payment_due_date) <=
                       TRUNC (SYSDATE + p_pay_due_days_ahead)
                --CONFIG NUMBER OF DAYS HERE FOR BACS TAKEN FROM CONFIG_DATA VALUE
                AND ai.payment_status = 'U'
                AND S.DECEASED_FLAG = 'Y';
   END select_fee_instalments;


   PROCEDURE select_award_payments (p_days_ahead_bacs      IN     NUMBER,
                                    p_days_ahead_cheque    IN     NUMBER,
                                    p_awards_paymenttype   IN OUT awards_cur)
   IS
      bacs_process_days     NUMBER (2);
      cheque_process_days   NUMBER (2);
   BEGIN
      SELECT nval
        INTO bacs_process_days
        FROM config_data
       WHERE item_name = 'BACS_PROCESS_DAYS';

      SELECT nval
        INTO cheque_process_days
        FROM config_data
       WHERE item_name = 'CHEQUE_PROCESS_DAYS';

      OPEN p_awards_paymenttype FOR
           SELECT CASE
                     WHEN ai.payee = 'S' THEN s.forenames || ' ' || s.surname
                     WHEN ai.payee = 'N' THEN n.forename || ' ' || n.surname
                     ELSE 'DSA SPEAK TO KERRY'
                  END
                     AS account_name,
                  CASE
                     WHEN ai.payee = 'S'          --AND s.payment_method = 'B'
                                        THEN s.account_no
                     WHEN ai.payee = 'N'                 --AND ai.method = 'B'
                                        THEN n.account_no
                     ELSE NULL
                  END
                     AS account_no,
                  SGAS.PK_PAYMENTS.GETACCOUNTNAME (ai.award_instalment_id,
                                                   sat.stud_award_type)
                     AS ACCOUNT,
                  --sat.account_name AS account,
                  CASE
                     WHEN sat.TYPE IN
                             ('BURS',
                              'CESB',
                              'LPG',
                              'DEPG',
                              'LPCG',
                              'SMA',
                              'PEPG')
                     THEN
                        'Y'
                     WHEN ai.adhoc_type = 'F'
                     THEN
                        'Y'
                     ELSE
                        'N'
                  END
                     attendance_check,
                  TO_CHAR (st.date_applic_received, 'DD-MM-YYYY')
                     AS AD_DATE_APP_RECIEVED,
                  ad.enrol_confirmed AS AD_ENROL_CONFIRMED,
                  ad.enrol_required AS AD_ENROL_REQUIRED,
                  AD.ONGOING_ATTENDANCE_CONFIRMED
                     AS AD_ONGOING_ATTEND_CONFIRMED,
                  ad.ongoing_required AS AD_ONGOING_REQUIRED,
                  ad.restrict_support_enrol AS AD_RESTRICT_SUPPORT_ENROL,
                  ad.restrict_payments_enrol AS AD_RESTRICT_PAYMENTS_ENROL,
                  ad.restrict_support_attend AS AD_RESTRICT_SUPPORT_ATTEND,
                  ad.restrict_payments_attend AS AD_RESTRICT_PAYMENTS_ATTEND,
                  ad.release_payments_enrol AS AD_RELEASE_PAYMENTS_ENROL,
                  ad.release_payments_attend AS AD_RELEASE_PAYMENTS_ATTEND,
                  scy.attend_confirmed,
                  ai.award_instalment_id,
                  ai.campus_id,
                  SGAS.pk_payments.getCostCentre (ai.award_instalment_id,
                                                  sat.stud_award_type)
                     AS cost_centre,
                  --sat.cost_centre,
                  TO_CHAR (
                     SGAS.RULES_PROC_RECALC.GETSTARTDATETERM (
                        scy.stud_crse_year_id,
                        1),
                     'DD-MM-YYYY')
                     AS COURSE_START_DATE,
                  scy.dearing,
                  --     a.dsa_allowance_id,
                  --     ai.dsa_fee_instalment,
                  sat.entity,
                  scy.grad_session,
                  scy.inst_code,
                  ai.method,
                  ai.net_amount,
                  n.nominee_id,
                  ai.payee,
                  CASE WHEN ai.payee = 'N' THEN 'S' ELSE ai.payee END
                     AS payee_sb,
                  CASE
                     WHEN ai.payment_addr = 'N' THEN N.HOUSE_NO_NAME
                     WHEN ai.payment_addr = 'B' THEN NULL
                     ELSE SHA.HOUSE_NO_NAME
                  END
                     AS PAYEE_HOUSE_NO_NAME,
                  CASE
                     WHEN ai.payment_addr = 'N' THEN N.ADDR_L1
                     WHEN ai.payment_addr = 'B' THEN NULL
                     ELSE SHA.ADDR_L1
                  END
                     AS PAYEE_ADDRL1,
                  CASE
                     WHEN ai.payment_addr = 'N' THEN N.ADDR_L2
                     WHEN ai.payment_addr = 'B' THEN NULL
                     ELSE SHA.ADDR_L2
                  END
                     AS PAYEE_ADDRL2,
                  CASE
                     WHEN ai.payment_addr = 'N' THEN N.ADDR_L3
                     WHEN ai.payment_addr = 'B' THEN NULL
                     ELSE SHA.ADDR_L3
                  END
                     AS PAYEE_ADDRL3,
                  CASE
                     WHEN ai.payment_addr = 'N' THEN N.ADDR_L4
                     WHEN ai.payment_addr = 'B' THEN NULL
                     ELSE SHA.ADDR_L4
                  END
                     AS PAYEE_ADDRL4,
                  CASE
                     WHEN ai.payment_addr = 'N' THEN N.POST_CODE
                     WHEN ai.payment_addr = 'B' THEN NULL
                     ELSE SHA.POST_CODE
                  END
                     AS PAYEE_POST_CODE,
                  ai.payment_addr,
                  CASE
                     WHEN     (ai.payment_due_date <
                                  SYSDATE + bacs_process_days)
                          AND ai.method = 'B'
                     THEN
                        TO_CHAR (SYSDATE + bacs_process_days, 'DD-MM-YYYY')
                     WHEN     (ai.payment_due_date <
                                  SYSDATE + bacs_process_days)
                          AND ai.method = 'C'
                     THEN
                        TO_CHAR (SYSDATE + cheque_process_days, 'DD-MM-YYYY')
                     ELSE
                        TO_CHAR (ai.payment_due_date, 'DD-MM-YYYY')
                  END
                     AS payment_due_date,
                  CASE
                     WHEN ai.payee = 'N'
                     THEN
                        CASE
                           WHEN n.payment_method = 1 THEN 'B'
                           WHEN n.payment_method = 2 THEN 'C'
                           WHEN n.payment_method = 3 THEN 'H'
                           ELSE 'F'
                        END
                     ELSE
                        s.payment_method
                  END
                     AS payment_method,
                  SGAS.pk_payments.getProgramme (ai.award_instalment_id,
                                                 sat.stud_award_type)
                     AS PROGRAMME,
                  --sat.programme,
                  CASE
                     WHEN sat.TYPE IN
                             ('BURS',
                              'CESB',
                              'LPG',
                              'DEPG',
                              'LPCG',
                              'SMA',
                              'PEPG')
                     THEN
                        pk_payments.getPaymentNumber (ai.award_instalment_id,
                                                      a.stud_ref_no,
                                                      a.session_code)
                     WHEN ai.adhoc_type = 'F'
                     THEN
                        pk_payments.getPaymentNumber (ai.award_instalment_id,
                                                      a.stud_ref_no,
                                                      a.session_code)
                     ELSE
                        1
                  END
                     payment_sequence,
                  pk_payments.checkNumberOfPaidAwards (ai.award_instalment_id)
                     AS PAIDAWARDS,
                  scy.provisional_case,
                  a.session_code,
                  CASE
                     WHEN ai.payee = 'S' THEN s.sort_code
                     WHEN ai.payee = 'N' THEN n.sort_code
                     ELSE NULL
                  -- WE NEED TO DETERMINE HOW TO LINK TO DSA NOMINEE TABLE
                  END
                     AS sort_code,
                  a.stud_award_type,
                  a.stud_crse_year_id,
                  s.stud_ref_no,
                  s.qa_count,
                  CASE
                     WHEN (    ai.payee = 'S'
                           AND ai.method = 'C'
                           AND ai.payment_addr = 'C')
                     THEN
                        '06'
                     ELSE
                        '02'
                  END
                     sub_type,
                  --      ai.trav_amount,
                  'A' AS fee_type
             --      CASE
             --          WHEN ai.payee = 'S' AND sha.post_code IS NULL AND ai.method = 'C'
             --              THEN 'Y'
             --          WHEN ai.payee = 'N' AND n.post_code IS NULL AND ai.method = 'C'
             --              THEN 'Y'
             --          ELSE 'N'
             --      END checkPostCode
             FROM award_instalment ai,
                  award a,
                  stud_crse_year scy,
                  stud s,
                  stud_award_type sat,
                  stud_session st,
                  dsa_payment dsa,
                  nominee n,
                  attendance_data ad,
                  stud_home_addr sha
            WHERE     ai.award_id = a.award_id
                  AND ai.award_instalment_id = dsa.award_instalment_id(+)
                  AND s.stud_ref_no = sha.stud_ref_no
                  AND sha.end_date IS NULL
                  AND dsa.payee_id = n.nominee_id(+)
                  AND ad.stud_crse_year_id = a.stud_crse_year_id
                  AND a.stud_award_type = sat.stud_award_type
                  AND st.stud_session_id = scy.stud_session_id
                  AND a.stud_crse_year_id = scy.stud_crse_year_id
                  AND scy.stud_ref_no = s.stud_ref_no
                  AND a.award_src = 'A'
                  AND ai.payment_status = 'U'
                  AND ai.net_amount > 0
                  AND s.suspend_payment = 'N'
                  AND s.stud_suspend = 'N'
                  AND st.session_suspend = 'N'
                  AND scy.crse_suspend = 'N' ----WE REQUIRE JOIN TO DSA TABLE TO IMPLEMENT DSA PAYMENT STOP CODE HERE
                  AND (   (    TRUNC (ai.payment_due_date) <=
                                  TRUNC (SYSDATE + p_days_ahead_bacs)
                           --CONFIG NUMBER OF DAYS AHEAD FOR BACS PAYMENTS
                           AND ai.method = 'B')
                       OR (    TRUNC (ai.payment_due_date) <=
                                  TRUNC (SYSDATE + p_days_ahead_cheque)
                           --CONFIG NUMBER OF DAYS AHEAD FOR CHEQUE PAYMENTS
                           AND ai.method = 'C'))
         ORDER BY ai.payment_due_date;
   END select_award_payments;


   --PROCEDURE process_standard_payments;
   PROCEDURE aggregate_paymentsFees (
      p_payment_run_date   IN            VARCHAR2,
      ERROR_TEXT              OUT NOCOPY VARCHAR2)
   IS
      /******************************************************************************
         NAME:       AGGREGATE PAYMENTS
         PURPOSE:    Picks up payment instalment records associated with payment
                    batches created in the current payment job run and aggregates the data

         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        23/03/2010 Adrian Bowman    1. Created
         1.1        25/04/2010 Paul Hughes      2. Amended
         ******************************************************************************/


      v_net_amount_due_fee        NUMBER (9);
      v_net_amount_due_loan       NUMBER (9);
      v_outstanding_fee           NUMBER (9);
      v_outstanding_loan          NUMBER (9);
      v_payrecordexist            VARCHAR (1);
      v_correxist                 VARCHAR (1);
      v_prev_outstanding_amount   NUMBER (9, 2);
      v_payee_id                  NUMBER (9);
      v_payee_ref_id              NUMBER (9);
      v_batch_ref                 VARCHAR2 (7);
      v_account_name              VARCHAR2 (100);
      v_sort_code                 VARCHAR2 (6);
      v_account_no                VARCHAR2 (10);
      v_payment_run_date          DATE;
      v_payment_method            VARCHAR2 (1);
      v_payment_date              DATE;
      v_currency                  VARCHAR2 (3);
      v_process_date              DATE;



      --THIS IS USED TO SELECT ALL THE PAYEE_ID THAT ARE WITHIN THIS PAYMENT RUN.  THIS IS REQUIRED TO UPDATE PREV_OUTSTANDING_AMOUNT VALUE WITH OLD VALUE.
      CURSOR c_payee_update
      IS
         SELECT payee_id, payment_type
           FROM payee
          WHERE PREV_OUTSTANDING_AMOUNT > 0 AND payment_type IN ('F', 'L');

      v_payee_update              c_payee_update%ROWTYPE;



      ---THIS SELECTS THE DATA FROM TABLES TO CREATE THE ADI_JOURNAL FILES
      CURSOR c_adi_journal
      IS
           ---FEES AMOUNT TO JOURNAL FROM FEES ACCOUNT
           SELECT batch_ref,
                  cost_centre,
                  account_name AS ACCOUNT,
                  CASE
                     WHEN SUM (net_amount_due) > 0 THEN SUM (net_amount_due)
                     ELSE 0
                  END
                     DEBIT_AMOUNT,
                  CASE
                     WHEN SUM (net_amount_due) < 0
                     THEN
                        SUM (net_amount_due * -1)
                     ELSE
                        0
                  END
                     CREDIT_AMOUNT,
                  programme,
                  entity
             FROM (SELECT pp.batch_ref,
                          sat.cost_centre,
                          sat.account_name,
                          pp.net_amount_due,
                          sat.programme,
                          sat.entity
                     FROM payee_payment pp, payee p, stud_award_type sat
                    WHERE     pp.payee_id = p.payee_id
                          AND p.payment_type = 'F'
                          AND pp.payment_status = 'I'
                          AND pp.payment_method = 'B'
                          AND TRUNC (pp.payment_run_date) =
                                 TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                          AND sat.stud_award_type IN('FEES', 'SNFEE', 'GAFEE')) 
         GROUP BY batch_ref,
                  cost_centre,
                  account_name,
                  programme,
                  entity
         UNION
           ---LOAN JOURNAL AMOUNT
           SELECT batch_ref,
                  cost_centre,
                  account_name AS ACCOUNT,
                  CASE
                     WHEN SUM (net_amount_due) > 0 THEN SUM (net_amount_due)
                     ELSE 0
                  END
                     DEBIT_AMOUNT,
                  CASE
                     WHEN SUM (net_amount_due) < 0
                     THEN
                        SUM (net_amount_due * -1)
                     ELSE
                        0
                  END
                     CREDIT_AMOUNT,
                  programme,
                  entity
             FROM (SELECT pp.batch_ref,
                          sat.cost_centre,
                          sat.account_name,
                          pp.net_amount_due,
                          sat.programme,
                          sat.entity
                     FROM payee_payment pp, payee p, stud_award_type sat
                    WHERE     pp.payee_id = p.payee_id
                          AND p.payment_type = 'L'
                          AND pp.payment_status = 'I'
                          AND pp.payment_method = 'B'
                          AND TRUNC (pp.payment_run_date) =
                                 TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                          AND sat.stud_award_type = 'TFEL')
         GROUP BY batch_ref,
                  cost_centre,
                  account_name,
                  programme,
                  entity
         UNION
           ----THE AMOUNT TO BE JOURNALED FROM THE SUSPSENSE FOR FEES AND LOANS
           SELECT BATCH_REF,
                  COST_CENTRE,
                  ACCOUNT,
                  SUM ( (DEBIT_AMOUNT * -1)) AS DEBIT_AMOUNT,
                  0 AS CREDIT_AMOUNT,
                  PROGRAMME,
                  ENTITY
             FROM (  SELECT pp.BATCH_REF,
                            sat.cost_centre,
                            sat.account_name AS ACCOUNT,
                            SUM (pp.NET_AMOUNT_DUE) AS DEBIT_AMOUNT,
                            0 AS CREDIT_AMOUNT,
                            sat.programme,
                            sat.entity
                       FROM PAYEE_PAYMENT pp, PAYEE p, STUD_AWARD_TYPE sat
                      WHERE     pp.payee_id = p.payee_id
                            AND sat.award_type_descript = 'SAAS SUSPENSE'
                            AND p.payment_type IN ('F', 'L')
                            AND pp.payment_method = 'B'
                            AND pp.payment_status = 'I'
                            AND TRUNC (pp.payment_run_date) =
                                   TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                   GROUP BY BATCH_REF,
                            sat.cost_centre,
                            sat.account_name,
                            sat.programme,
                            sat.entity,
                            pp.payee_ref_id
                     HAVING SUM (pp.NET_AMOUNT_DUE) < 0)
         GROUP BY BATCH_REF,
                  COST_CENTRE,
                  ACCOUNT,
                  PROGRAMME,
                  ENTITY
         UNION
         --FIRST 3 STATEMENTS DEAL WITH COPYING BACK THE SUSPENSE DEBT INTO THE FEE AND LOAN ACCOUNTS
         ----THIS RETURNS THE AMOUNT WHICH WILL BE CREDITED TO THE DEBTORS ACCOUNT
         SELECT NULL AS BATCH_REF,
                sat.cost_centre,
                sat.account_name AS ACCOUNT,
                0 AS DEBIT_AMOUNT,
                SGAS.PK_PAYMENTS.GETSUSPENSEDEBTTOCREDITACCOUNT (
                   p_payment_run_date)
                   AS CREDIT_AMOUNT,
                sat.programme,
                sat.entity
           FROM STUD_AWARD_TYPE sat
          WHERE sat.award_type_descript = 'SAAS SUSPENSE'
         HAVING SGAS.PK_PAYMENTS.GETSUSPENSEDEBTTOCREDITACCOUNT (
                   p_payment_run_date) > 0
         UNION
         ---NOW WE HAVE TO PUT  THE MONEY BACK INTO THE FEES ACCOUNT FROM SUSPENSE SO WE DEBIT THE FEES.
         SELECT NULL AS BATCH_REF,
                sat.cost_centre,
                sat.account_name AS ACCOUNT,
                SGAS.PK_PAYMENTS.GETPAYEECREDITS (p_payment_run_date, 'F')
                   AS DEBIT_AMOUNT,
                0 AS CREDIT_AMOUNT,
                sat.programme,
                sat.entity
           FROM STUD_AWARD_TYPE sat
          WHERE sat.stud_award_type IN('FEES', 'SNFEE', 'GAFEE')
         HAVING SGAS.PK_PAYMENTS.GETPAYEECREDITS (p_payment_run_date, 'F') >
                   0
         UNION
         ---NOW WE HAVE TO PUT  THE MONEY BACK INTO THE LOANS ACCOUNT FROM SUSPENSE SO WE DEBIT THE LOANS
         SELECT NULL AS BATCH_REF,
                sat.cost_centre,
                sat.account_name AS ACCOUNT,
                SGAS.PK_PAYMENTS.GETPAYEECREDITS (p_payment_run_date, 'L')
                   AS DEBIT_AMOUNT,
                0 AS CREDIT_AMOUNT,
                sat.programme,
                sat.entity
           FROM STUD_AWARD_TYPE sat
          WHERE sat.stud_award_type = 'TFEL'
         HAVING SGAS.PK_PAYMENTS.GETPAYEECREDITS (p_payment_run_date, 'L') >
                   0
         UNION
           ----THE AMOUNT TO BE JOURNALED FROM THE BANK FOR FEES AND LOANS
           SELECT BATCH_REF,
                  COST_CENTRE,
                  ACCOUNT,
                  DEBIT_AMOUNT,
                  SUM (CREDIT_AMOUNT) AS CREDIT_AMOUNT,
                  PROGRAMME,
                  ENTITY
             FROM (  SELECT pp.BATCH_REF,
                            sat.cost_centre,
                            sat.account_name AS ACCOUNT,
                            0 AS DEBIT_AMOUNT,
                            SUM (pp.NET_AMOUNT_DUE) AS CREDIT_AMOUNT,
                            sat.programme,
                            sat.entity
                       FROM PAYEE_PAYMENT pp, PAYEE p, STUD_AWARD_TYPE sat
                      WHERE     pp.payee_id = p.payee_id
                            AND sat.award_type_descript = 'SAAS BANK INFO'
                            AND p.payment_type IN ('F', 'L')
                            AND pp.payment_method = 'B'
                            AND pp.payment_status = 'I'
                            AND TRUNC (pp.payment_run_date) =
                                   TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                   GROUP BY BATCH_REF,
                            sat.cost_centre,
                            sat.account_name,
                            sat.programme,
                            sat.entity,
                            pp.payee_ref_id
                     HAVING SUM (pp.NET_AMOUNT_DUE) > 0)
         GROUP BY BATCH_REF,
                  COST_CENTRE,
                  ACCOUNT,
                  DEBIT_AMOUNT,
                  PROGRAMME,
                  ENTITY;


      v_adi_journal               c_adi_journal%ROWTYPE;


      ---THIS SELECTS THE DATA FROM PAYMENT_INSTALMENT RECORD READY TO BE INSERTED INTO PAYEE_PAYMENT TABLE
      CURSOR c_payee_payment
      IS
           SELECT pi.batch_ref,
                  pi.payee_id,
                  p.payee_ref_id,
                  pi.account_name,
                  pi.sort_code,
                  pi.account_no,
                  pi.payment_run_date,
                  SUM (pi.payment_amount) - (p.prev_outstanding_amount)
                     AS net_amount_due,
                  SUM (pi.payment_amount) total_in_run,
                  p.prev_outstanding_amount AS prev_debt,
                  pi.payment_method,
                  pi.payment_date,
                  pi.currency,
                  pi.payment_status,
                  pi.process_date,
                  p.payee_type AS payment_type
             FROM payee p, payment_instalment pi
            WHERE     p.payee_id = pi.payee_id
                  AND TRUNC (pi.payment_run_date) =
                         TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                  AND pi.payment_status = 'A'
         GROUP BY pi.batch_ref,
                  pi.payee_id,
                  p.payee_ref_id,
                  pi.account_name,
                  pi.sort_code,
                  pi.account_no,
                  pi.payment_run_date,
                  pi.payment_method,
                  p.prev_outstanding_amount,
                  pi.currency,
                  pi.payment_status,
                  pi.payment_date,
                  pi.process_date,
                  p.payee_type;

      v_pay_rec                   c_payee_payment%ROWTYPE;
      v_adi_journ_id              adi_journal.adi_journal_id%TYPE;
      v_adi_jl_id                 adi_journal.adi_journal_line_id%TYPE;

      ---THIS SELECTS THE AWARD_ID AND THE BATCH_REF FROM PAYMENT_INSTALMENT RECORD IN ORDER TO UPDATE AWARD INSTALMENT TABLE.
      CURSOR c_award_id
      IS
         SELECT pi.award_instalment_id, pi.batch_ref
           FROM payment_instalment pi
          WHERE     pi.payment_status = 'A'
                AND TRUNC (pi.payment_run_date) =
                       TO_DATE (p_payment_run_date, 'DD/MM/YYYY');

      v_award_rec                 c_award_id%ROWTYPE;

      ---THIS IS USED TO CREATE THE DEBT.  IT SELECTS THE PAYEE_REF_ID's (campus_id) FOR FEE PAYMENTS ONLY

      CURSOR c_campus_id
      IS
         SELECT DISTINCT a.PAYEE_REF_ID
           FROM PAYEE_PAYMENT a, PAYEE b
          WHERE     a.PAYMENT_STATUS = 'I'
                AND TRUNC (a.payment_run_date) =
                       TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                AND a.payee_id = b.payee_id
                AND b.payment_type IN ('F', 'L');

      v_campus_rec                payee.payee_ref_id%TYPE;
   BEGIN
      SELECT adi_journ_id_seq.NEXTVAL INTO v_adi_journ_id FROM DUAL;

      ----WE NEED TO COPY THE FEE AND FEE LOAN DEBT PREVIOUS VALUES OVER
      UPDATE payee pay
         SET pay.prev_outstanding_amount = pay.outstanding_amount
       WHERE PAYMENT_TYPE IN ('F', 'L');


      OPEN c_award_id;

      LOOP
         FETCH c_award_id INTO v_award_rec;

         EXIT WHEN c_award_id%NOTFOUND;

         UPDATE award_instalment awi
            SET awi.batch_ref = v_award_rec.batch_ref
          WHERE awi.award_instalment_id = v_award_rec.award_instalment_id;
      END LOOP;

      CLOSE c_award_id;

      OPEN c_payee_payment;

      LOOP
         FETCH c_payee_payment INTO v_pay_rec;

         EXIT WHEN c_payee_payment%NOTFOUND;

         INSERT INTO sgas.payee_payment (                  --payee_payment_id,
                                         batch_ref,
                                         payee_id,
                                         payee_ref_id,
                                         account_name,
                                         sort_code,
                                         account_no,
                                         payment_run_date,
                                         net_amount_due,
                                         total_in_run,
                                         prev_debt,
                                         payment_method,
                                         payment_date,
                                         returned_date,
                                         currency,
                                         payment_status,
                                         process_date,
                                         last_updated_by,
                                         last_updated_on)
              VALUES (                         --payee_payment_id_seq.CURRVAL,
                      v_pay_rec.batch_ref,                         --batch_ref
                      v_pay_rec.payee_id,                           --payee_id
                      v_pay_rec.payee_ref_id,                   --payee_ref_id
                      v_pay_rec.account_name,                   --account_name
                      v_pay_rec.sort_code,                         --sort-code
                      v_pay_rec.account_no,                       --account_no
                      v_pay_rec.payment_run_date,           --payment_run_date
                      -- v_pay_rec.amount_paid,      --amount_paid
                      v_pay_rec.net_amount_due,               --net_amount_due
                      v_pay_rec.total_in_run,                   --total-in_run
                      v_pay_rec.prev_debt,          --Debt they had oustanding
                      v_pay_rec.payment_method,               --payment_method
                      v_pay_rec.payment_date,                   --payment_date
                      NULL,                                 --returned_date??,
                      v_pay_rec.currency,                           --currency
                      'I',              --SETTING PAYMENT STATUS TO IN PROCESS
                      v_pay_rec.process_date,                   --process_date
                      'SGAS',                                --last_updated_by
                      SYSDATE                                --last_updated_on
                             );


         UPDATE payment_instalment pi
            SET pi.payee_payment_id =
                   (SELECT pp.payee_payment_id
                      FROM payee_payment pp
                     WHERE     pp.batch_ref = v_pay_rec.batch_ref
                           AND pp.payee_id = v_pay_rec.payee_id),
                pi.payment_status = 'I',
                pi.adi_journal_id = v_adi_journ_id
          WHERE     pi.batch_ref = v_pay_rec.batch_ref
                AND pi.payee_id = v_pay_rec.payee_id
                AND pi.payment_method = 'B'
                AND pi.payment_status = 'A';
      END LOOP;

      CLOSE c_payee_payment;

      ----NEW CODE ADDED TO CREATE DUMMY PAYEE_PAYMENT RECORDS IF NECESSARY>  THIS IS ONLY WHEN THERE IS DEBT FOR SAY A CAMPUS FEE AND ONLY LOAN PAYMENTS MADE AND VICE VERSA


      OPEN c_payee_update;

      LOOP
         FETCH c_payee_update INTO v_payee_update; ------PAYEE_ID OF THE DEBT WE WANT TO CREATE A DUMMY RECORD FOR

         EXIT WHEN c_payee_update%NOTFOUND;

         SELECT SGAS.PK_PAYMENTS.doesPayeePaymentPayeeIDExist (
                   v_payee_update.payee_id,
                   p_payment_run_date)
           INTO v_payrecordexist
           FROM DUAL;

         IF v_payrecordexist = 'N'
         THEN
            ---INSTEAD OF LOOKING UP CORRESPONDING RECORD AND INSERTING JUST GET THE TYPE AND RETRIEVE DETAILS FROM THE STUD_AWARD_TYPE TABLE AND INSERT RECORD
            ---GET RID OF FUNCTIONS - EASY!!!!!

            --WE NEED TO SEE IF CORRESPONDING RECORD EXISTS
            SELECT SGAS.PK_PAYMENTS.doesCorrespondingPayeeIDExist (
                      v_payee_update.payee_id,
                      p_payment_run_date)
              INTO v_correxist
              FROM DUAL;


            IF v_correxist = 'Y'
            THEN
               ---WE NEED TO GET THE DEBT VALUES FROM THE RECORD THAT DOES NOT EXIST
               SELECT prev_outstanding_amount, payee_ref_id
                 INTO v_prev_outstanding_amount, v_payee_ref_id
                 FROM PAYEE
                WHERE payee_id = v_payee_update.payee_id;


               --WE NEED TO GET THE CORRESPONDING PAYEE_ID FOR THE OPPOSITE PAYMENT, SO IF ONLY FEE RECORD EXISTS THIS WILL RETURN
               SELECT SGAS.PK_PAYMENTS.GETCORRESPONDINGPAYEEID (
                         v_payee_update.payee_id)
                 INTO v_payee_id -----THIS IS THE CORRESPONDING OPPOSITE RECORD WE WANT TO COPY BANK DETAILS FROM
                 FROM DUAL;


               SELECT batch_ref,
                      account_name,
                      sort_code,
                      account_no,
                      --  TO_DATE(payment_run_date,'DD/MM/YYYY')
                      payment_method,
                      payment_date,
                      ---- TO_DATE(payment_date,'DD/MM/YYYY'),  ----FIXED
                      currency,
                      process_date
                 -- TO_DATE(process_date,'DD/MM/YYYY')       ----FIXED
                 INTO v_batch_ref,
                      v_account_name,
                      v_sort_code,
                      v_account_no,
                      -- v_payment_run_date,
                      v_payment_method,
                      v_payment_date,
                      v_currency,
                      v_process_date
                 FROM PAYEE_PAYMENT
                WHERE     payee_id = v_payee_id
                      AND TRUNC (payment_run_date) =
                             TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                      AND PAYMENT_STATUS = 'I'
                      AND ROWNUM < 2;



               INSERT INTO sgas.payee_payment (            --payee_payment_id,
                                               batch_ref,
                                               payee_id,
                                               payee_ref_id,
                                               account_name,
                                               sort_code,
                                               account_no,
                                               payment_run_date,
                                               net_amount_due,
                                               total_in_run,
                                               prev_debt,
                                               payment_method,
                                               payment_date,
                                               returned_date,
                                               currency,
                                               payment_status,
                                               process_date,
                                               last_updated_by,
                                               last_updated_on)
                    VALUES (                   --payee_payment_id_seq.CURRVAL,
                            v_batch_ref,                           --batch_ref
                            v_payee_update.payee_id,                --payee_id
                            v_payee_ref_id,                     --payee_ref_id
                            v_account_name,                     --account_name
                            v_sort_code,                           --sort-code
                            v_account_no,                         --account_no
                            TO_DATE (p_payment_run_date, 'DD/MM/YYYY'), --payment_run_date -----TESTING PURPOSES
                            (v_prev_outstanding_amount * -1), --net_amount_due
                            0,                                  --total-in_run
                            v_prev_outstanding_amount, --Debt they had oustanding
                            v_payment_method,                 --payment_method
                            v_payment_date,
                            ---    TO_DATE(v_payment_date,'DD/MM/YYYY'),   --payment_date
                            NULL,                           --returned_date??,
                            v_currency,                             --currency
                            'I',        --SETTING PAYMENT STATUS TO IN PROCESS
                            --   TO_DATE(v_process_date,'DD/MM/YYYY'),   --process_date
                            v_process_date,
                            'SGAS',                          --last_updated_by
                            SYSDATE                          --last_updated_on
                                   );
            END IF;
         END IF;       --if a record does exist we do not need to do anything.
      END LOOP;

      CLOSE c_payee_update;



      OPEN c_campus_id;

      LOOP
         FETCH c_campus_id INTO v_campus_rec;


         EXIT WHEN c_campus_id%NOTFOUND;

         SELECT sgas.pk_payments.getnetamountduefee (v_campus_rec)
           INTO v_net_amount_due_fee
           FROM DUAL;

         SELECT sgas.pk_payments.getnetamountdueloan (v_campus_rec)
           INTO v_net_amount_due_loan
           FROM DUAL;


         ---SET THE FEE OUTSTANDING AMOUNT FOR CAMPUS.
         IF v_net_amount_due_fee > 0
         THEN
            v_outstanding_fee := 0;
         ELSIF (v_net_amount_due_fee + v_net_amount_due_loan) > 0
         THEN
            v_outstanding_fee := 0;
         ELSIF v_net_amount_due_loan < 0
         THEN
            v_outstanding_fee := (v_net_amount_due_fee * -1);
         ELSE
            v_outstanding_fee :=
               (v_net_amount_due_fee + v_net_amount_due_loan) * -1;
         END IF;

         UPDATE PAYEE
            SET OUTSTANDING_AMOUNT = v_outstanding_fee
          WHERE payee_ref_id = v_campus_rec AND payment_type = 'F';


         --SET THE LOAN OUTSTANDING AMOUNT FOR CAMPUS

         IF v_net_amount_due_loan > 0
         THEN
            v_outstanding_loan := 0;
         ELSIF (v_net_amount_due_fee + v_net_amount_due_loan) > 0
         THEN
            v_outstanding_loan := 0;
         ELSIF v_net_amount_due_fee < 0
         THEN
            v_outstanding_loan := (v_net_amount_due_loan * -1);
         ELSE
            v_outstanding_loan :=
               (v_net_amount_due_fee + v_net_amount_due_loan) * -1;
         END IF;


         UPDATE PAYEE
            SET OUTSTANDING_AMOUNT = v_outstanding_loan
          WHERE payee_ref_id = v_campus_rec AND payment_type = 'L';
      END LOOP;

      CLOSE c_campus_id;



      OPEN c_adi_journal;

      LOOP
         FETCH c_adi_journal INTO v_adi_journal;

         EXIT WHEN c_adi_journal%NOTFOUND;

         SELECT adi_jl_seq.NEXTVAL INTO v_adi_jl_id FROM DUAL;

         IF v_adi_journal.debit_amount > 0 OR v_adi_journal.credit_amount > 0
         THEN
            ---PAYMENTS WHICH UPDATE THE DEBIT COLUMN IN ADI_JOURNAL TABLE
            INSERT INTO sgas.adi_journal (adi_journal_line_id,
                                          adi_journal_id,
                                          batch_ref,
                                          cost_centre,
                                          ACCOUNT,
                                          programme,
                                          currency,
                                          entity,
                                          --    payment_method,
                                          process_date,
                                          adi_file_status,
                                          sub_analysis1,
                                          sub_analysis2,
                                          sub_analysis3,
                                          debit_value,
                                          credit_value,
                                          payment_run_date,
                                          last_updated_by,
                                          last_updated_on)
                 VALUES (v_adi_jl_id,                    --adi_journal_line_id
                         v_adi_journ_id,                      --adi_journal_id
                         v_adi_journal.batch_ref,                  --batch_ref
                         v_adi_journal.cost_centre,              --cost_centre
                         v_adi_journal.ACCOUNT,                      --ACCOUNT
                         v_adi_journal.programme,                  --programme
                         'GBP',                                     --currency
                         v_adi_journal.entity,                        --entity
                         --                                    'B',                    --payment_method
                         SYSDATE,                               --process_date
                         'I',                                --adi_file_status
                         '000000',                            --sub_analysis1,
                         '00000000',                          --sub_analysis2,
                         '000000',                            --sub_analysis3,
                         v_adi_journal.DEBIT_AMOUNT,             --debit_value
                         v_adi_journal.CREDIT_AMOUNT,           --credit_value
                         TO_DATE (p_payment_run_date, 'DD/MM/YYYY'), --payment_run_date
                         'SGAS',                             --last_updated_by
                         SYSDATE                             --last_updated_on
                                );
         END IF;


         UPDATE payment_instalment pi
            SET pi.adi_journal_line_id = v_adi_jl_id
          WHERE     pi.cost_centre = v_adi_journal.cost_centre
                AND pi.ACCOUNT = v_adi_journal.ACCOUNT
                AND pi.batch_ref = v_adi_journal.batch_ref
                AND pi.programme = v_adi_journal.programme
                AND pi.entity = v_adi_journal.entity
                --AND pi.process_date =
                --      TRUNC
                --         (v_adi_journal.process_date)
                AND pi.adi_journal_id = v_adi_journ_id
                AND TRUNC (pi.payment_run_date) =
                       TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                AND pi.payment_method = 'B';
      END LOOP;

      CLOSE c_adi_journal;

      UPDATE payee pay
         SET pay.outstanding_amount = prev_outstanding_amount
       WHERE     pay.PAYMENT_TYPE IN ('F', 'L')
             AND pay.payee_id NOT IN
                    (SELECT a.payee_id
                       FROM payee_payment a
                      WHERE TRUNC (a.payment_run_date) =
                               TO_DATE (p_payment_run_date, 'DD/MM/YYYY')); ---REMOVE DD/MM/YYYY



      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;

         --ERROR_TEXT := 'FAILED';
         --  ERROR_TEXT := raise_application_error(-20001,'An error encountered - '||SQLCODE||'-ERROR-'||SQLERRM);
         ERROR_TEXT := CONCAT (SQLCODE, SUBSTR (SQLERRM, 1, 500));
   END aggregate_paymentsFees;



   PROCEDURE aggregate_payments (p_payment_run_date   IN            VARCHAR2,
                                 ERROR_TEXT              OUT NOCOPY VARCHAR2)
   IS
      /******************************************************************************
         NAME:       AGGREGATE PAYMENTS
         PURPOSE:    Picks up payment instalment records associated with payment
                    batches created in the current payment job run and aggregates the data

         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        23/03/2010 Adrian Bowman    1. Created
         1.1        25/04/2010 Paul Hughes      2. Amended
         1.2        31/05/2011 Paul Hughes      3.  Fix to ADI_JOURNAL_LINE_ID which was updating incorrectly due to missing BATCH_REF.

         ******************************************************************************/


      ---THIS SELECTS THE DATA FROM TABLES TO CREATE THE ADI_JOURNAL FILES
      CURSOR c_adi_journal
      IS
           ------FOR NORMAL AWARD PAYMENTS JOURNAL FROM SPECIFIC ACCOUNT CODE
           SELECT DISTINCT
                  pi.batch_ref,
                  pi.cost_centre,
                  pi.ACCOUNT,
                  CASE
                     WHEN SUM (pi.payment_amount) > 0
                     THEN
                        SUM (pi.payment_amount)
                     ELSE
                        0
                  END
                     DEBIT_AMOUNT,
                  0 AS CREDIT_AMOUNT,
                  pi.programme,
                  pi.entity
             FROM payee p, payment_instalment pi
            WHERE     pi.payee_id = p.payee_id
                  AND p.payment_type = 'A'
                  AND pi.payment_method = 'B'
                  AND pi.payment_status = 'I'
                  AND TRUNC (pi.payment_run_date) =
                         TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
         GROUP BY pi.BATCH_REF,
                  pi.COST_CENTRE,
                  pi.ACCOUNT,
                  pi.PROGRAMME,
                  pi.ENTITY
         UNION
           --THE AMOUNT TO JOURNAL OUT OF THE BANK FOR AWARDS ONLY
           ------FOR NORMAL AWARD PAYMENTS JOURNAL FROM SPECIFIC ACCOUNT CODE
           SELECT BATCH_REF,
                  COST_CENTRE,
                  ACCOUNT,
                  DEBIT_AMOUNT,
                  SUM (CREDIT_AMOUNT) AS CREDIT_AMOUNT,
                  PROGRAMME,
                  ENTITY
             FROM (  SELECT pp.BATCH_REF,
                            sat.cost_centre,
                            sat.account_name AS ACCOUNT,
                            0 AS DEBIT_AMOUNT,
                            SUM (pp.NET_AMOUNT_DUE) AS CREDIT_AMOUNT,
                            sat.programme,
                            sat.entity
                       FROM PAYEE_PAYMENT pp, PAYEE p, STUD_AWARD_TYPE sat
                      WHERE     pp.payee_id = p.payee_id
                            AND sat.award_type_descript = 'SAAS BANK INFO'
                            AND p.payment_type = 'A'
                            AND pp.payment_method = 'B'
                            AND pp.payment_status = 'I'
                            AND TRUNC (pp.payment_run_date) =
                                   TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                   GROUP BY BATCH_REF,
                            sat.cost_centre,
                            sat.account_name,
                            sat.programme,
                            sat.entity)
         GROUP BY BATCH_REF,
                  COST_CENTRE,
                  ACCOUNT,
                  DEBIT_AMOUNT,
                  PROGRAMME,
                  ENTITY;

      v_adi_journal          c_adi_journal%ROWTYPE;



      ---THIS SELECTS THE DATA FROM PAYMENT_INSTALMENT RECORD READY TO BE INSERTED INTO PAYEE_PAYMENT TABLE
      CURSOR c_payee_payment
      IS
           SELECT pi.batch_ref,
                  pi.payee_id,
                  CASE
                     WHEN p.payee_type = 'N' THEN pi.award_instalment_id
                     ELSE p.payee_ref_id
                  END
                     payee_ref_id,                    --NEW FS DSA CHANGE 2012
                  pi.account_name,
                  pi.sort_code,
                  pi.account_no,
                  pi.payment_run_date,
                  SUM (pi.payment_amount) - (p.prev_outstanding_amount)
                     AS net_amount_due,
                  SUM (pi.payment_amount) total_in_run,
                  p.prev_outstanding_amount AS prev_debt,
                  pi.payment_method,
                  pi.payment_date,
                  pi.currency,
                  pi.payment_status,
                  pi.process_date,
                  p.payee_type AS payment_type,
                  p.payee_ref_id AS PayeeReference
             FROM payee p, payment_instalment pi
            WHERE     p.payee_id = pi.payee_id
                  AND TRUNC (pi.payment_run_date) =
                         TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                  AND pi.payment_status = 'A'
         GROUP BY pi.batch_ref,
                  pi.payee_id,
                  p.payee_ref_id,
                  CASE
                     WHEN p.payee_type = 'N' THEN pi.award_instalment_id
                     ELSE p.payee_ref_id
                  END,
                  pi.account_name,
                  pi.sort_code,
                  pi.account_no,
                  pi.payment_run_date,
                  pi.payment_method,
                  p.prev_outstanding_amount,
                  pi.currency,
                  pi.payment_status,
                  pi.payment_date,
                  pi.process_date,
                  p.payee_type;


      v_pay_rec              c_payee_payment%ROWTYPE;
      v_adi_journ_id         adi_journal.adi_journal_id%TYPE;
      v_adi_jl_id            adi_journal.adi_journal_line_id%TYPE;

      ---THIS SELECTS THE AWARD_ID AND THE BATCH_REF FROM PAYMENT_INSTALMENT RECORD IN ORDER TO UPDATE AWARD INSTALMENT TABLE.
      CURSOR c_award_id
      IS
         SELECT pi.award_instalment_id, pi.batch_ref
           FROM payment_instalment pi
          WHERE     pi.payment_status = 'A'
                AND TRUNC (pi.payment_run_date) =
                       TO_DATE (p_payment_run_date, 'DD/MM/YYYY');

      v_award_rec            c_award_id%ROWTYPE;


      CURSOR c_scoap_payments
      IS
           SELECT pi.batch_ref,
                  pi.stud_ref_no AS OUR_REF1,
                  pi.stud_crse_year_id AS OUR_REF2,
                  pp.payee_payment_id AS OUR_REF3,
                  SUBSTR (pi.account_name, 1, 30) AS payee,
                  pi.payee_addrl1,
                  pi.payee_addrL2,
                  pi.payee_addrl3,
                  pi.payee_postcode,
                  pi.payment_addr,
                  SUM (pi.payment_amount) AS net_amount_due,
                  pi.sub_type,
                  pi.payment_date,
                  pp.payee_payment_id,
                  pi.stud_ref_no,
                  pp.payee_ref_id,
                  0 || pi.stud_ref_no || 'H' AS ref4
             FROM payee_payment pp, payment_instalment pi
            WHERE     pp.payee_payment_id = pi.payee_payment_id
                  AND pp.payment_method = 'C'
                  AND TRUNC (pi.payment_run_date) =
                         TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                  AND pp.payment_status = 'I'
         GROUP BY pi.batch_ref,
                  pi.stud_ref_no,
                  pi.stud_crse_year_id,
                  pp.payee_payment_id,
                  pi.account_name,
                  pi.payee_addrl1,
                  pi.payee_addrL2,
                  pi.payee_addrl3,
                  pi.payee_postcode,
                  pi.payment_addr,
                  pi.sub_type,
                  pi.payment_date,
                  pp.payee_payment_id,
                  pi.stud_ref_no,
                  pp.payee_ref_id;


      v_scoap_payments_rec   c_scoap_payments%ROWTYPE;

      CURSOR c_scoap_journal
      IS
           SELECT pp.batch_ref,
                  pi.cost_centre,
                  pi.account,
                  SUM (pi.payment_amount) AS amount,
                  pi.programme,
                  pi.entity
             FROM payee_payment pp, payment_instalment pi
            WHERE     pp.payee_payment_id = pi.payee_payment_id
                  AND pp.payment_method = 'C'
                  AND TRUNC (pi.payment_run_date) =
                         TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                  AND pp.payment_status = 'I'             --- previously was A
         GROUP BY pp.batch_ref,
                  pi.cost_centre,
                  pi.account,
                  pi.programme,
                  pi.entity;


      v_scoap_journal_rec    c_scoap_journal%ROWTYPE;
   BEGIN
      SELECT adi_journ_id_seq.NEXTVAL INTO v_adi_journ_id FROM DUAL;



      OPEN c_award_id;

      LOOP
         FETCH c_award_id INTO v_award_rec;

         EXIT WHEN c_award_id%NOTFOUND;

         UPDATE award_instalment awi
            SET awi.batch_ref = v_award_rec.batch_ref
          WHERE awi.award_instalment_id = v_award_rec.award_instalment_id;
      END LOOP;

      CLOSE c_award_id;



      OPEN c_payee_payment;

      LOOP
         FETCH c_payee_payment INTO v_pay_rec;

         EXIT WHEN c_payee_payment%NOTFOUND;

         INSERT INTO sgas.payee_payment (                  --payee_payment_id,
                                         batch_ref,
                                         payee_id,
                                         payee_ref_id,
                                         account_name,
                                         sort_code,
                                         account_no,
                                         payment_run_date,
                                         net_amount_due,
                                         total_in_run,
                                         prev_debt,
                                         payment_method,
                                         payment_date,
                                         returned_date,
                                         currency,
                                         payment_status,
                                         process_date,
                                         last_updated_by,
                                         last_updated_on)
              VALUES (                         --payee_payment_id_seq.CURRVAL,
                      v_pay_rec.batch_ref,                         --batch_ref
                      v_pay_rec.payee_id,                           --payee_id
                      v_pay_rec.payee_ref_id,                   --payee_ref_id
                      v_pay_rec.account_name,                   --account_name
                      v_pay_rec.sort_code,                         --sort-code
                      v_pay_rec.account_no,                       --account_no
                      v_pay_rec.payment_run_date,           --payment_run_date
                      -- v_pay_rec.amount_paid,      --amount_paid
                      v_pay_rec.net_amount_due,               --net_amount_due
                      v_pay_rec.total_in_run,                   --total-in_run
                      v_pay_rec.prev_debt,          --Debt they had oustanding
                      v_pay_rec.payment_method,               --payment_method
                      v_pay_rec.payment_date,                   --payment_date
                      NULL,                                 --returned_date??,
                      v_pay_rec.currency,                           --currency
                      'I',              --SETTING PAYMENT STATUS TO IN PROCESS
                      v_pay_rec.process_date,                   --process_date
                      'SGAS',                                --last_updated_by
                      SYSDATE                                --last_updated_on
                             );



         IF v_pay_rec.payment_type = 'N'
         THEN
            UPDATE payment_instalment pi
               SET pi.payee_payment_id =
                      (SELECT pp.payee_payment_id
                         FROM payee_payment pp
                        WHERE     pp.batch_ref = v_pay_rec.batch_ref
                              AND pp.payee_id = v_pay_rec.payee_id
                              AND pp.payee_ref_id = v_pay_rec.payee_ref_id),
                   pi.payment_status = 'I',
                   pi.adi_journal_id = v_adi_journ_id
             WHERE     pi.batch_ref = v_pay_rec.batch_ref
                   AND pi.payee_id = v_pay_rec.payee_id
                   AND pi.award_instalment_id = v_pay_rec.payee_ref_id
                   AND pi.payment_method = 'B'
                   AND pi.payment_status = 'A';


            UPDATE payment_instalment pi
               SET pi.payee_payment_id =
                      (SELECT pp.payee_payment_id
                         FROM payee_payment pp
                        WHERE     pp.batch_ref = v_pay_rec.batch_ref
                              AND pp.payee_id = v_pay_rec.payee_id
                              AND pp.payee_ref_id = v_pay_rec.payee_ref_id),
                   pi.payment_status = 'I'
             WHERE     pi.batch_ref = v_pay_rec.batch_ref
                   AND pi.payee_id = v_pay_rec.payee_id
                   AND pi.award_instalment_id = v_pay_rec.payee_ref_id
                   AND pi.payment_method = 'C'
                   AND pi.payment_status = 'A';

            UPDATE PAYEE_PAYMENT
               SET PAYEE_REF_ID = v_pay_rec.PayeeReference
             WHERE     PAYMENT_STATUS = 'I'
                   AND PAYEE_REF_ID = v_pay_rec.payee_ref_id;
         ELSE
            UPDATE payment_instalment pi
               SET pi.payee_payment_id =
                      (SELECT pp.payee_payment_id
                         FROM payee_payment pp
                        WHERE     pp.batch_ref = v_pay_rec.batch_ref
                              AND pp.payee_id = v_pay_rec.payee_id),
                   pi.payment_status = 'I',
                   pi.adi_journal_id = v_adi_journ_id
             WHERE     pi.batch_ref = v_pay_rec.batch_ref
                   AND pi.payee_id = v_pay_rec.payee_id
                   AND pi.payment_method = 'B'
                   AND pi.payment_status = 'A';

            UPDATE payment_instalment pi
               SET pi.payee_payment_id =
                      (SELECT pp.payee_payment_id
                         FROM payee_payment pp
                        WHERE     pp.batch_ref = v_pay_rec.batch_ref
                              AND pp.payee_id = v_pay_rec.payee_id),
                   pi.payment_status = 'I'
             WHERE     pi.batch_ref = v_pay_rec.batch_ref
                   AND pi.payee_id = v_pay_rec.payee_id
                   AND pi.payment_method = 'C'
                   AND pi.payment_status = 'A';
         END IF;
      END LOOP;

      CLOSE c_payee_payment;


      OPEN c_adi_journal;

      LOOP
         FETCH c_adi_journal INTO v_adi_journal;

         EXIT WHEN c_adi_journal%NOTFOUND;

         SELECT adi_jl_seq.NEXTVAL INTO v_adi_jl_id FROM DUAL;


         ---PAYMENTS WHICH UPDATE THE DEBIT COLUMN IN ADI_JOURNAL TABLE
         INSERT INTO sgas.adi_journal (adi_journal_line_id,
                                       adi_journal_id,
                                       batch_ref,
                                       cost_centre,
                                       ACCOUNT,
                                       programme,
                                       currency,
                                       entity,
                                       --   payment_method,
                                       process_date,
                                       adi_file_status,
                                       sub_analysis1,
                                       sub_analysis2,
                                       sub_analysis3,
                                       debit_value,
                                       credit_value,
                                       payment_run_date,
                                       last_updated_by,
                                       last_updated_on)
              VALUES (v_adi_jl_id,                       --adi_journal_line_id
                      v_adi_journ_id,                         --adi_journal_id
                      v_adi_journal.batch_ref,                     --batch_ref
                      v_adi_journal.cost_centre,                 --cost_centre
                      v_adi_journal.ACCOUNT,                         --ACCOUNT
                      v_adi_journal.programme,                     --programme
                      'GBP',                                        --currency
                      v_adi_journal.entity,                           --entity
                      --              'B',                    --payment_method
                      SYSDATE,                                  --process_date
                      'I',                                   --adi_file_status
                      '000000',                               --sub_analysis1,
                      '00000000',                             --sub_analysis2,
                      '000000',                               --sub_analysis3,
                      v_adi_journal.DEBIT_AMOUNT,                --debit_value
                      v_adi_journal.CREDIT_AMOUNT,              --credit_value
                      TO_DATE (p_payment_run_date, 'DD/MM/YYYY'), --payment_run_date
                      'SGAS',                                --last_updated_by
                      SYSDATE                                --last_updated_on
                             );


         UPDATE payment_instalment pi
            SET pi.adi_journal_line_id = v_adi_jl_id
          WHERE     pi.cost_centre = v_adi_journal.cost_centre
                AND pi.ACCOUNT = v_adi_journal.ACCOUNT
                AND pi.batch_ref = v_adi_journal.batch_ref
                AND pi.programme = v_adi_journal.programme
                AND pi.entity = v_adi_journal.entity
                --AND pi.process_date =
                --       TRUNC
                --          (v_adi_journal.process_date)
                -- AND pi.adi_journal_id = v_adi_journ_id
                AND TRUNC (pi.payment_run_date) =
                       TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                AND pi.payment_method = 'B';
      END LOOP;



      CLOSE c_adi_journal;


      OPEN c_scoap_payments;

      LOOP
         FETCH c_scoap_payments INTO v_scoap_payments_rec;

         EXIT WHEN c_scoap_payments%NOTFOUND;


         INSERT INTO sgas.scoap_payments (dpp_batch_ref,
                                          dpp_sequence_no,
                                          dpp_our_ref1,
                                          dpp_our_ref2,
                                          dpp_our_ref3,
                                          dpp_source_ref,
                                          dpp_payee,
                                          dpp_payee_address1,
                                          dpp_payee_address2,
                                          dpp_payee_address3,
                                          dpp_payee_postcode,
                                          dpp_payee_bank_account,
                                          dpp_payee_bank_sort_code,
                                          dpp_bank_account_type,
                                          dpp_build_soc_roll_no,
                                          dpp_payment_amount,
                                          dpp_payment_method,
                                          dpp_pay_sub_type,
                                          dpp_payment_date,
                                          dpp_refer_to_or_enclosure,
                                          dpp_remitter_address_code,
                                          dpp_radv_addressee,
                                          dpp_radv_address1,
                                          dpp_radv_address2,
                                          dpp_radv_address3,
                                          dpp_radv_address4,
                                          dpp_radv_postcode,
                                          dpp_bank_id,
                                          dpp_remittance_text_01,
                                          dpp_remittance_text_02,
                                          dpp_remittance_text_03,
                                          dpp_remittance_text_04,
                                          dpp_remittance_text_05,
                                          dpp_remittance_text_06,
                                          dpp_remittance_text_07,
                                          dpp_remittance_text_08,
                                          dpp_remittance_text_09,
                                          dpp_remittance_text_10,
                                          dpp_remittance_text_11,
                                          dpp_remittance_text_12,
                                          dpp_remittance_text_13,
                                          dpp_remittance_text_14,
                                          dpp_remittance_text_15,
                                          dpp_remittance_text_16,
                                          dpp_remittance_text_17,
                                          dpp_remittance_text_18,
                                          dpp_remittance_text_19,
                                          dpp_remittance_text_20,
                                          dpp_payment_id,
                                          dpp_po_num,
                                          dpp_reissue,
                                          dpp_returned,
                                          dpp_currency,
                                          dpp_our_ref4,
                                          last_updated_by,
                                          last_updated_on)
              VALUES (v_scoap_payments_rec.batch_ref,          --dpp_batch_ref
                      NULL,                                  --dpp_sequence_no
                      v_scoap_payments_rec.our_ref1,            --dpp_our_ref1
                      v_scoap_payments_rec.our_ref2,            --dpp_our_ref2
                      v_scoap_payments_rec.our_ref3,            --dpp_our_ref3
                      'NOT KNOWN',                            --dpp_source_ref
                      v_scoap_payments_rec.payee,                  --dpp_payee
                      v_scoap_payments_rec.payee_addrl1,  --dpp_payee_address1
                      v_scoap_payments_rec.payee_addrl2,  --dpp_payee_address2
                      v_scoap_payments_rec.payee_addrl3,  --dpp_payee_address3
                      v_scoap_payments_rec.payee_postcode, --dpp_payee_postcode
                      NULL,                           --dpp_payee_bank_account
                      NULL,                         --dpp_payee_bank_sort_code
                      NULL,                            --dpp_bank_account_type
                      NULL,                            --dpp_build_soc_roll_no
                      v_scoap_payments_rec.net_amount_due, --dpp_payment_amount
                      'PQ',                               --dpp_payment_method
                      v_scoap_payments_rec.sub_type,        --dpp_pay_sub_type
                      v_scoap_payments_rec.payment_date,    --dpp_payment_date
                      NULL,                        --dpp_refer_to_or_enclosure
                      'SG1',                       --dpp_remitter_address_code
                      v_scoap_payments_rec.payee,         --dpp_radv_addressee
                      v_scoap_payments_rec.payee_addrl1,   --dpp_radv_address1
                      v_scoap_payments_rec.payee_addrl2,   --dpp_radv_address2
                      v_scoap_payments_rec.payee_addrl3,   --dpp_radv_address3
                      NULL,                                --dpp_radv_address4
                      v_scoap_payments_rec.payee_postcode, --dpp_radv_postcode
                      '0001',                                    --dpp_bank_id
                      NULL,                           --dpp_remittance_text_01
                      NULL,                           --dpp_remittance_text_02
                      NULL,                           --dpp_remittance_text_03
                      NULL,                           --dpp_remittance_text_04
                      NULL,                           --dpp_remittance_text_05
                      NULL,                           --dpp_remittance_text_06
                      NULL,                           --dpp_remittance_text_07
                      NULL,                           --dpp_remittance_text_08
                      NULL,                           --dpp_remittance_text_09
                      NULL,                           --dpp_remittance_text_10
                      NULL,                           --dpp_remittance_text_11
                      NULL,                           --dpp_remittance_text_12
                      NULL,                           --dpp_remittance_text_13
                      NULL,                           --dpp_remittance_text_14
                      NULL,                           --dpp_remittance_text_15
                      NULL,                           --dpp_remittance_text_16
                      NULL,                           --dpp_remittance_text_17
                      NULL,                           --dpp_remittance_text_18
                      NULL,                           --dpp_remittance_text_19
                      NULL,                           --dpp_remittance_text_20
                      NULL,                                   --dpp_payment_id
                      NULL,                                       --dpp_po_num
                      'N',                                       --dpp_reissue
                      NULL,                                     --dpp_returned
                      'GBP',                                    --dpp_currency
                      v_scoap_payments_rec.ref4,                --dpp_our_ref4
                      'SGAS',                                --last_updated_by
                      SYSDATE                                --last_updated_on
                             );
      END LOOP;

      CLOSE c_scoap_payments;

      OPEN c_scoap_journal;

      LOOP
         FETCH c_scoap_journal INTO v_scoap_journal_rec;

         -- DBMS_OUTPUT.PUT_LINE ('Batch_Ref'|| ' ' ||v_scoap_journal_rec.batch_ref);

         EXIT WHEN c_scoap_journal%NOTFOUND;

         INSERT INTO SCOAP_JOURNAL_LINES (DPJ_BATCH_REF,
                                          DPJ_COST_CENTRE,
                                          DPJ_ACCOUNT,
                                          DPJ_ACTIVITY,
                                          DPJ_JOB,
                                          DPJ_ANALYSIS_1_ID,
                                          DPJ_SIGN,
                                          DPJ_AMOUNT,
                                          DPJ_VAT_AMOUNT,
                                          DPJ_VAT_CODE,
                                          DPJ_PROGRAMME,
                                          DPJ_CURRENCY,
                                          DPJ_ENTITY,
                                          DPJ_PAYMENT_TYPE)
              VALUES (v_scoap_journal_rec.batch_ref,           --DPJ_BATCH_REF
                      v_scoap_journal_rec.cost_centre,       --DPJ_COST_CENTRE
                      v_scoap_journal_rec.account,               --DPJ_ACCOUNT
                      '000000',                                 --DPJ_ACTIVITY
                      '00000000',                                    --DPJ_JOB
                      v_scoap_journal_rec.batch_ref,       --DPJ_ANALYSIS_1_ID
                      '+',                                          --DPJ_SIGN
                      v_scoap_journal_rec.amount,                 --DPJ_AMOUNT
                      0,                                      --DPJ_VAT_AMOUNT
                      NULL,                                     --DPJ_VAT_CODE
                      v_scoap_journal_rec.programme,           --DPJ_PROGRAMME
                      'GBP',                                    --DPJ_CURRENCY
                      v_scoap_journal_rec.entity,                 --DPJ_ENTITY
                      'C'                                   --DPJ_PAYMENT_TYPE
                         );
      END LOOP;

      CLOSE c_scoap_journal;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;

         ERROR_TEXT := CONCAT (SQLCODE, SUBSTR (SQLERRM, 1, 500));
   END aggregate_payments;


   PROCEDURE aggregate_returns (p_payment_run_date   IN            VARCHAR2,
                                ERROR_TEXT              OUT NOCOPY VARCHAR2)
   IS
      /******************************************************************************
         NAME:       AGGREGATE PAYMENTS
         PURPOSE:    Picks up payment instalment records associated with payment
                    batches created in the current payment job run and aggregates the data


         REVISIONS:
         Ver        Date        Author           Description
         ---------  ----------  ---------------  ------------------------------------
         1.0        14/09/2011     Paul Hughes   1. Created


         ******************************************************************************/


      ---THIS SELECTS THE DATA FROM TABLES TO CREATE THE ADI_JOURNAL FILES FOR THE RETURNS
      CURSOR c_adi_journal
      IS
           SELECT DISTINCT
                  pr.returns_batch_ref,
                  pr.cost_centre,
                  pr.account,
                  0 AS DEBIT_AMOUNT,
                  CASE
                     WHEN SUM (pr.returns_amount) > 0
                     THEN
                        SUM (pr.returns_amount)
                     ELSE
                        0
                  END
                     CREDIT_AMOUNT,
                  pr.programme,
                  pr.entity
             FROM PAYMENT_RETURNS pr
            WHERE     TRUNC (pr.process_date) =
                         TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                  AND pr.returns_status = 'I'
         GROUP BY pr.returns_batch_ref,
                  pr.cost_centre,
                  pr.account,
                  pr.programme,
                  pr.entity
         UNION
           SELECT pr.returns_batch_ref,
                  sat.cost_centre,
                  sat.account_name AS account,
                  SUM (pr.returns_amount) AS DEBIT_AMOUNT,
                  0 AS CREDIT_AMOUNT,
                  sat.programme,
                  sat.entity
             FROM PAYMENT_RETURNS pr, STUD_AWARD_TYPE sat
            WHERE     sat.award_type_descript = 'BACS RETURN'
                  AND pr.receipt_type_id = 1
                  AND TRUNC (pr.process_date) =
                         TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                  AND pr.RETURNS_STATUS = 'I'
         GROUP BY pr.returns_batch_ref,
                  sat.cost_centre,
                  sat.account_name,
                  sat.programme,
                  sat.entity
         UNION
           SELECT pr.returns_batch_ref,
                  sat.cost_centre,
                  sat.account_name AS account,
                  SUM (pr.returns_amount) AS DEBIT_AMOUNT,
                  0 AS CREDIT_AMOUNT,
                  sat.programme,
                  sat.entity
             FROM PAYMENT_RETURNS pr, STUD_AWARD_TYPE sat
            WHERE     sat.award_type_descript = 'CANCELLED PO'
                  AND pr.receipt_type_id = 2
                  AND TRUNC (pr.process_date) =
                         TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                  AND pr.RETURNS_STATUS = 'I'
         GROUP BY pr.returns_batch_ref,
                  sat.cost_centre,
                  sat.account_name,
                  sat.programme,
                  sat.entity
         UNION
           SELECT pr.returns_batch_ref,
                  sat.cost_centre,
                  sat.account_name AS account,
                  SUM (pr.returns_amount) AS DEBIT_AMOUNT,
                  0 AS CREDIT_AMOUNT,
                  sat.programme,
                  sat.entity
             FROM PAYMENT_RETURNS pr, STUD_AWARD_TYPE sat
            WHERE     sat.award_type_descript = 'DISHONOURED CHEQUE'
                  AND pr.receipt_type_id = 3
                  AND TRUNC (pr.process_date) =
                         TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                  AND pr.RETURNS_STATUS = 'I'
         GROUP BY pr.returns_batch_ref,
                  sat.cost_centre,
                  sat.account_name,
                  sat.programme,
                  sat.entity
         UNION
           SELECT pr.returns_batch_ref,
                  sat.cost_centre,
                  sat.account_name AS account,
                  SUM (pr.returns_amount) AS DEBIT_AMOUNT,
                  0 AS CREDIT_AMOUNT,
                  sat.programme,
                  sat.entity
             FROM PAYMENT_RETURNS pr, STUD_AWARD_TYPE sat
            WHERE     sat.award_type_descript = 'RECEIPT'
                  AND pr.receipt_type_id = 4
                  AND TRUNC (pr.process_date) =
                         TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                  AND pr.RETURNS_STATUS = 'I'
         GROUP BY pr.returns_batch_ref,
                  sat.cost_centre,
                  sat.account_name,
                  sat.programme,
                  sat.entity
         UNION
           SELECT pr.returns_batch_ref,
                  sat.cost_centre,
                  sat.account_name AS account,
                  SUM (pr.returns_amount) AS DEBIT_AMOUNT,
                  0 AS CREDIT_AMOUNT,
                  sat.programme,
                  sat.entity
             FROM PAYMENT_RETURNS pr, STUD_AWARD_TYPE sat
            WHERE     sat.award_type_descript = 'RETURNED PAYMENT'
                  AND pr.receipt_type_id = 5
                  AND TRUNC (pr.process_date) =
                         TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                  AND pr.RETURNS_STATUS = 'I'
         GROUP BY pr.returns_batch_ref,
                  sat.cost_centre,
                  sat.account_name,
                  sat.programme,
                  sat.entity
         UNION
           SELECT pr.returns_batch_ref,
                  sat.cost_centre,
                  sat.account_name AS account,
                  SUM (pr.returns_amount) AS DEBIT_AMOUNT,
                  0 AS CREDIT_AMOUNT,
                  sat.programme,
                  sat.entity
             FROM PAYMENT_RETURNS pr, STUD_AWARD_TYPE sat
            WHERE     sat.award_type_descript = 'TIME EXPIRED PO'
                  AND pr.receipt_type_id = 6
                  AND TRUNC (pr.process_date) =
                         TO_DATE (p_payment_run_date, 'DD/MM/YYYY')
                  AND pr.RETURNS_STATUS = 'I'
         GROUP BY pr.returns_batch_ref,
                  sat.cost_centre,
                  sat.account_name,
                  sat.programme,
                  sat.entity;



      v_adi_journal      c_adi_journal%ROWTYPE;
      v_adi_jl_id        adi_journal.adi_journal_line_id%TYPE;
      v_adi_journal_id   adi_journal.adi_journal_id%TYPE;
   BEGIN
      SELECT adi_journ_id_seq.NEXTVAL INTO v_adi_journal_id FROM DUAL;

      OPEN c_adi_journal;

      LOOP
         FETCH c_adi_journal INTO v_adi_journal;

         EXIT WHEN c_adi_journal%NOTFOUND;

         SELECT adi_jl_seq.NEXTVAL INTO v_adi_jl_id FROM DUAL;


         ---PAYMENTS WHICH UPDATE THE DEBIT COLUMN IN ADI_JOURNAL TABLE
         INSERT INTO sgas.adi_journal (adi_journal_line_id,
                                       adi_journal_id,
                                       returns_batch_ref,
                                       cost_centre,
                                       ACCOUNT,
                                       programme,
                                       currency,
                                       entity,
                                       --    payment_method,
                                       process_date,
                                       adi_file_status,
                                       sub_analysis1,
                                       sub_analysis2,
                                       sub_analysis3,
                                       debit_value,
                                       credit_value,
                                       payment_run_date,
                                       last_updated_by,
                                       last_updated_on)
              VALUES (v_adi_jl_id,                       --adi_journal_line_id
                      v_adi_journal_id,                       --adi_journal_id
                      v_adi_journal.returns_batch_ref,     --returns_batch_ref
                      v_adi_journal.cost_centre,                 --cost_centre
                      v_adi_journal.ACCOUNT,                         --ACCOUNT
                      v_adi_journal.programme,                     --programme
                      'GBP',                                        --currency
                      v_adi_journal.entity,                           --entity
                      --   'B',                                                  --payment_method
                      TO_DATE (p_payment_run_date, 'DD/MM/YYYY'), --process_date
                      'I',                                   --adi_file_status
                      '000000',                               --sub_analysis1,
                      '00000000',                             --sub_analysis2,
                      '000000',                               --sub_analysis3,
                      v_adi_journal.DEBIT_AMOUNT,                --debit_value
                      v_adi_journal.CREDIT_AMOUNT,              --credit_value
                      TO_DATE (p_payment_run_date, 'DD/MM/YYYY'), --payment_run_date
                      'SGAS',                                --last_updated_by
                      SYSDATE                                --last_updated_on
                             );
      END LOOP;

      CLOSE c_adi_journal;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;

         ERROR_TEXT := CONCAT (SQLCODE, SUBSTR (SQLERRM, 1, 500));
   END aggregate_returns;


   PROCEDURE aggregate_returns_UI (p_returns_batch   IN            VARCHAR2,
                                   p_batch_count     IN            NUMBER,
                                   p_total_returns   IN            NUMBER,
                                   p_year            IN            NUMBER,
                                   p_period          IN            NUMBER,
                                   ERROR_TEXT           OUT NOCOPY VARCHAR2)
   IS
      CURSOR c_payment_returns_load
      IS
         SELECT a.PAYMENT_RETURNS_LOAD_ID,
                a.RETURNS_DATE,
                CASE
                   WHEN a.RECEIPT_TYPE_ID = 4 THEN a.RETURNS_AMOUNT
                   ELSE B.PAYMENT_AMOUNT
                END
                   RETURNS_AMOUNT,
                a.RECEIPT_TYPE_ID,
                a.PROCESS_DATE,
                a.PAYEE_PAYMENT_ID,
                a.STUD_REF_NO,
                a.NAME,
                a.STUD_AWARD_TYPE,
                a.OVERRIDE,
                a.PAYMENT_METHOD,
                a.RETURNS_BATCH,
                b.PAYMENT_INSTALMENT_ID,
                b.AWARD_INSTALMENT_ID
           FROM payment_returns_load a, payment_instalment b
          WHERE     RETURNS_STATUS = 'U'
                AND a.payee_payment_id = b.payee_payment_id(+)
                AND a.RETURNS_BATCH = p_returns_batch;

      v_payment_returns_load   c_payment_returns_load%ROWTYPE;
   BEGIN
      INSERT INTO RETURN_BATCHES (RETURNS_BATCH_REF,
                                  BATCH_COUNT,
                                  AC_YEAR,
                                  AC_PERIOD,
                                  TOTAL_RETURNS,
                                  BATCH_CREATION_DATE,
                                  RETURNS_STATUS,
                                  LAST_UPDATED_BY,
                                  LAST_UPDATED_ON)
           VALUES (p_returns_batch,
                   p_batch_count,
                   p_year,
                   p_period,
                   p_total_returns,
                   SYSDATE,
                   'S',
                   'SGAS',
                   SYSDATE);


      OPEN c_payment_returns_load;

      LOOP
         FETCH c_payment_returns_load INTO v_payment_returns_load;

         EXIT WHEN c_payment_returns_load%NOTFOUND;


         IF v_payment_returns_load.receipt_type_id = 4
         THEN
            ---CREATE PAYMENT_RETURN_LOAD records.
            INSERT INTO sgas.PAYMENT_RETURNS (payment_returns_id,
                                              payment_returns_load_id,
                                              returns_batch_ref,
                                              returns_date,
                                              returns_amount,
                                              receipt_type_id,
                                              returns_status,
                                              process_date,
                                              entity,
                                              cost_centre,
                                              account,
                                              programme,
                                              sub_type,
                                              payment_method,
                                              stud_award_type,
                                              stud_ref_no,
                                              last_updated_by,
                                              last_updated_on)
                 VALUES (
                           PAY_RTNS_ID_SEQ.NEXTVAL,
                           v_payment_returns_load.payment_returns_load_id,
                           v_payment_returns_load.RETURNS_BATCH,
                           v_payment_returns_load.returns_date,
                           v_payment_returns_load.returns_amount,
                           v_payment_returns_load.receipt_type_id,
                           'I',
                           SYSDATE,
                           (SELECT ENTITY
                              FROM STUD_AWARD_TYPE
                             WHERE STUD_AWARD_TYPE =
                                      v_payment_returns_load.STUD_AWARD_TYPE),
                           (SELECT COST_CENTRE
                              FROM STUD_AWARD_TYPE
                             WHERE STUD_AWARD_TYPE =
                                      v_payment_returns_load.STUD_AWARD_TYPE),
                           (SELECT ACCOUNT_NAME
                              FROM STUD_AWARD_TYPE
                             WHERE STUD_AWARD_TYPE =
                                      v_payment_returns_load.STUD_AWARD_TYPE),
                           (SELECT PROGRAMME
                              FROM STUD_AWARD_TYPE
                             WHERE STUD_AWARD_TYPE =
                                      v_payment_returns_load.STUD_AWARD_TYPE),
                           '02', ----------SUB_TYPE WE NEED TO CHECK WHAT THIS SHOULD BE?
                           v_payment_returns_load.payment_method,
                           v_payment_returns_load.stud_award_type,
                           v_payment_returns_load.stud_ref_no,
                           'SGAS',
                           SYSDATE);

            UPDATE PAYMENT_RETURNS_LOAD
               SET RETURNS_STATUS = 'S'
             WHERE PAYMENT_RETURNS_LOAD_ID =
                      v_payment_returns_load.payment_returns_load_id;
         ELSE
            ---CREATE PAYMENT_RETURN_LOAD records.
            INSERT INTO sgas.PAYMENT_RETURNS (payment_returns_id,
                                              payment_instalment_id,
                                              payment_returns_load_id,
                                              payee_payment_id,
                                              returns_batch_ref,
                                              returns_date,
                                              returns_amount,
                                              receipt_type_id,
                                              returns_status,
                                              process_date,
                                              entity,
                                              cost_centre,
                                              account,
                                              programme,
                                              sub_type,
                                              payment_method,
                                              stud_award_type,
                                              stud_ref_no,
                                              last_updated_by,
                                              last_updated_on)
                 VALUES (
                           PAY_RTNS_ID_SEQ.NEXTVAL,
                           v_payment_returns_load.payment_instalment_id,
                           v_payment_returns_load.payment_returns_load_id,
                           v_payment_returns_load.payee_payment_id,
                           v_payment_returns_load.RETURNS_BATCH,
                           v_payment_returns_load.returns_date,
                           v_payment_returns_load.RETURNS_AMOUNT,
                           v_payment_returns_load.receipt_type_id,
                           'I',
                           SYSDATE,
                           (SELECT DISTINCT a.ENTITY
                              FROM STUD_AWARD_TYPE a,
                                   AWARD b,
                                   AWARD_INSTALMENT c,
                                   PAYMENT_INSTALMENT d
                             WHERE     a.STUD_AWARD_TYPE = b.STUD_AWARD_TYPE
                                   AND b.AWARD_ID = c.AWARD_ID
                                   AND c.AWARD_INSTALMENT_ID =
                                          d.AWARD_INSTALMENT_ID
                                   AND d.PAYMENT_INSTALMENT_ID =
                                          v_payment_returns_load.PAYMENT_INSTALMENT_ID),
                           (SELECT DISTINCT a.COST_CENTRE
                              FROM STUD_AWARD_TYPE a,
                                   AWARD b,
                                   AWARD_INSTALMENT c,
                                   PAYMENT_INSTALMENT d
                             WHERE     a.STUD_AWARD_TYPE = b.STUD_AWARD_TYPE
                                   AND b.AWARD_ID = c.AWARD_ID
                                   AND c.AWARD_INSTALMENT_ID =
                                          d.AWARD_INSTALMENT_ID
                                   AND d.PAYMENT_INSTALMENT_ID =
                                          v_payment_returns_load.PAYMENT_INSTALMENT_ID),
                           (SELECT DISTINCT a.ACCOUNT_NAME
                              FROM STUD_AWARD_TYPE a,
                                   AWARD b,
                                   AWARD_INSTALMENT c,
                                   PAYMENT_INSTALMENT d
                             WHERE     a.STUD_AWARD_TYPE = b.STUD_AWARD_TYPE
                                   AND b.AWARD_ID = c.AWARD_ID
                                   AND c.AWARD_INSTALMENT_ID =
                                          d.AWARD_INSTALMENT_ID
                                   AND d.PAYMENT_INSTALMENT_ID =
                                          v_payment_returns_load.PAYMENT_INSTALMENT_ID),
                           (SELECT DISTINCT a.PROGRAMME
                              FROM STUD_AWARD_TYPE a,
                                   AWARD b,
                                   AWARD_INSTALMENT c,
                                   PAYMENT_INSTALMENT d
                             WHERE     a.STUD_AWARD_TYPE = b.STUD_AWARD_TYPE
                                   AND b.AWARD_ID = c.AWARD_ID
                                   AND c.AWARD_INSTALMENT_ID =
                                          d.AWARD_INSTALMENT_ID
                                   AND d.PAYMENT_INSTALMENT_ID =
                                          v_payment_returns_load.PAYMENT_INSTALMENT_ID),
                           '02', ----------SUB_TYPE WE NEED TO CHECK WHAT THIS SHOULD BE?
                           v_payment_returns_load.payment_method,
                           v_payment_returns_load.stud_award_type,
                           v_payment_returns_load.stud_ref_no,
                           'SGAS',
                           SYSDATE);

            UPDATE PAYMENT_RETURNS_LOAD
               SET RETURNS_STATUS = 'S'
             WHERE PAYMENT_RETURNS_LOAD_ID =
                      v_payment_returns_load.payment_returns_load_id;

            UPDATE PAYEE_PAYMENT
               SET PAYMENT_STATUS = 'R',
                   RETURNED_DATE = TRUNC (v_payment_returns_load.RETURNS_DATE)
             WHERE PAYEE_PAYMENT_ID = v_payment_returns_load.payee_payment_id;

            UPDATE PAYMENT_INSTALMENT
               SET PAYMENT_STATUS = 'R',
                   RETURNED_DATE = TRUNC (v_payment_returns_load.RETURNS_DATE)
             WHERE PAYMENT_INSTALMENT_ID =
                      v_payment_returns_load.payment_instalment_id;

            UPDATE award_instalment
               SET returned =
                      CASE
                         WHEN returned IN ('N', 'A', 'T') THEN 'T'
                         WHEN returned IS NULL THEN 'T'
                         ELSE 'Y'
                      END,
                   returned_date = TRUNC (v_payment_returns_load.RETURNS_DATE)
             WHERE award_instalment_id =
                      v_payment_returns_load.award_instalment_id;
         END IF;
      END LOOP;


      CLOSE c_payment_returns_load;
   END aggregate_returns_UI;
END pk_payments;
/
