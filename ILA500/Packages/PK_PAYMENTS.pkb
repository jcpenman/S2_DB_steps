CREATE OR REPLACE PACKAGE BODY ILA500.pk_payments
IS
-- DESCRIPTION
-- ===========
--
--
-- Modification History
-- Date                 Author      Ref    Desc
-- 05.08.2008           R Hunter    001    Initial Creation
-- 29.08.2008           A Bowman    002    Updated as learner_application column names were changed
-- 09.06.2009           A Anchev    003    Added function for retrieval of current ILA500 session
-- 10.08.2009           A Anchev    004    Changed the get_app_payment function to exclude canceled payments
-- 19.11.2009           P Hughes    005    Changed the get_app_payment function to include Non Attendance and Withdrawn cases
-- 19.11.2009           P Hughes    006    Changed get_app_payment and reversed logic so if paid we display negative, unpaid display zero
-- 23.11.2009           P Hughes    007    Removed condition where start date between dates as not required - this lets previous payments get paid
-- 25.11.2009           P Hughes    008    Script updated to make join to learner table so that only records with no hold payments are picked up
-- 01.12.2009           P Hughes    009    Existing cases who are withdrawn and non attendance will not have correct fields marked in learner_application table - this fix will pick them up using only the application_status's.
-- 08.12.2009           P Hughes    010    New Procedure update_course_type to return course_type_id value back to original value after payments run - called via BPM flow.
-- 16.12.2009           P Hughes    011    Added new function get_app_paymentPaymentReports to be used by payment reports only.
-- 21.12.2009           P Hughes    012    Amended code for hold_payment = 'N' to <> 'Y' as there are 'N' and null values held in LIVE.
-- 22.12.2009           P Hughes    013    Amended update of Learner table to update sysdate not to use TO_DATE.
-- 08.04.2009           P Hughes    014    Debt Payment Status updated status in standard payments run
-- 21.04.2010           P Hughes    015    Fix updating of LEARNER_PAYMENT.PROVIDER_PAYMENT_ID value not updating correctly for all records.
-- 05.05.2010           P Hughes    016    Fix to update LEARNER_APPLICATION.PAYMENT_DATE for cases which withdrew after fee cut off date and were paid.
-- 18.02.2011           P Hughes    017    Fix with final course type update at end of payments incorrectly setting the course type id for some payments.

-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Packages/PK_PAYMENTS.pkb $
-- $Author: $
-- $Date: 2008-12-04 16:21:38 +0000 (Thu, 04 Dec 2008) $
-- $Revision: 1768 $
--
    FUNCTION get_app_payment (
      p_appid   IN   learner_application.learner_application_id%TYPE
   )
      RETURN NUMBER
   IS
/*
get_app_payment
(appID IN learner_application.application_status_id%TYPE)
Returns the amount of the payment for this application. If there is only one
positive payment for the application the returned amount should be the amount
of that payment. If there is a negative amount, the returned value should be 0
if the recovery has already been paid or minus the amount if the recovery
payment is still pending.
*/
      CURSOR payment_amt_cur
      IS
         SELECT CASE
                   WHEN (    ttp.description = 'DEBIT'
                         AND lstat.payment_desc = 'UNPAID'
                        )
/*recovery withdrawal/non attendance*/
                THEN -1 * amount                            --pending recovery
                   WHEN (    ttp.description = 'DEBIT'
                         AND lstat.payment_desc = 'PAID'

                        )
                      THEN 0                          -- recovery already paid
                   ELSE lpay.amount
                END status_of_payment
           FROM learner_payment lpay,
                payment_status lstat,
                transaction_type ttp
          WHERE lpay.payment_status_id = lstat.payment_status_id
            AND lpay.transaction_type_id = ttp.transaction_type_id
            AND lpay.learner_application_id = p_appid
            AND lstat.payment_desc <> 'CANCELLED'
            /* ensure we take only most recent payment status, could be more than one per application*/
            AND lpay.learner_payment_id =
                                 (SELECT MAX (learnerpayid)
                                        FROM (SELECT MIN (
                                                        lp2.learner_payment_id)
                                                        learnerpayid
                                                FROM learner_payment lp2,
                                                     learner_application la
                                               WHERE     lp2.learner_application_id =
                                                            p_appid
                                                     AND la.learner_application_id =
                                                            lp2.learner_application_id
                                                     AND la.recalculated_fee
                                                            IS NOT NULL
                                              UNION
                                              SELECT MAX (
                                                        lp2.learner_payment_id)
                                                FROM learner_payment lp2,
                                                     learner_application la
                                               WHERE     lp2.learner_application_id =
                                                            p_appid
                                                     AND la.learner_application_id =
                                                            lp2.learner_application_id
                                                     AND la.recalculated_fee
                                                            IS NULL) x);


      v_return_amt   VARCHAR2 (100) := NULL;
   BEGIN
      OPEN payment_amt_cur;

      FETCH payment_amt_cur
       INTO v_return_amt;

      CLOSE payment_amt_cur;

      RETURN NVL (v_return_amt, 0);
   EXCEPTION
      WHEN OTHERS
      THEN
         email_error (   'get_app_payment '
                      || 'SQLCODE='
                      || SQLCODE
                      || ' SQL ERROR = '
                      || SQLERRM
                     );
         RETURN 0;
   END get_app_payment;
   
   ---THIS FUNCTION IS USED FOR THE VU_PROVIDER_PAYMENT_REPORT AS THIS REPORTS ON PAYMENTS AFTER PAYMENT THE LOGIC IS DIFFERENT
   FUNCTION get_app_paymentPaymentReports (
      p_appid   IN   learner_application.learner_application_id%TYPE
   )
      RETURN NUMBER
   IS
/*
get_app_payment
(appID IN learner_application.application_status_id%TYPE)
Returns the amount of the payment for this application. If there is only one
positive payment for the application the returned amount should be the amount
of that payment. If there is a negative amount, the returned value should be 0
if the recovery has already been paid or minus the amount if the recovery
payment is still pending.
*/
      CURSOR payment_amt_cur
      IS
         SELECT CASE
                   WHEN (    ttp.description = 'DEBIT'
                         AND lstat.payment_desc = 'PAID'
                        )
/*recovery withdrawal/non attendance*/
                THEN -1 * amount   
                    WHEN (lstat.payment_desc = 'CANCELLED'                      --pending recovery
                        )
                      THEN 0                          -- recovery already paid
                   ELSE lpay.amount
                END status_of_payment
           FROM learner_payment lpay,
                payment_status lstat,
                transaction_type ttp
          WHERE lpay.payment_status_id = lstat.payment_status_id
            AND lpay.transaction_type_id = ttp.transaction_type_id
            AND lpay.learner_application_id = p_appid
            AND lstat.payment_desc <> 'CANCELLED'
            /* ensure we take only most recent payment status, could be more than one per application*/
            AND lpay.learner_payment_id =
                                 (SELECT MAX (lp2.learner_payment_id)
                                    FROM learner_payment lp2
                                   WHERE lp2.learner_application_id = p_appid);

      v_return_amt   VARCHAR2 (100) := NULL;
   BEGIN
      OPEN payment_amt_cur;

      FETCH payment_amt_cur
       INTO v_return_amt;

      CLOSE payment_amt_cur;

      RETURN NVL (v_return_amt, 0);
   EXCEPTION
      WHEN OTHERS
      THEN
         email_error (   'get_app_payment '
                      || 'SQLCODE='
                      || SQLCODE
                      || ' SQL ERROR = '
                      || SQLERRM
                     );
         RETURN 0;
   END get_app_paymentPaymentReports;
   
   
FUNCTION getPaymentReportFeesAwarded (
      p_appid   IN   learner_application.learner_application_id%TYPE
   )
      RETURN NUMBER
   IS
/*
get_app_payment
(appID IN learner_application.application_status_id%TYPE)
Returns the amount of the payment for this application. If there is only one
positive payment for the application the returned amount should be the amount
of that payment. If there is a negative amount, the returned value should be 0
if the recovery has already been paid or minus the amount if the recovery
payment is still pending.
*/
      CURSOR payment_amt_cur
      IS
        SELECT   SUM (DECODE (transaction_type_id, 1, amount, 0)) - SUM (DECODE (transaction_type_id, 2, amount, 0))
            amount
            FROM learner_payment
        WHERE  learner_application_id = p_appid
        AND payment_status_id = '2'
        AND transaction_type_id IN ('1', '2')
        AND to_date(LEARNER_PAYMENT.LAST_UPDATED_ON) =
              (SELECT to_date(last_updated_on)
                 FROM learner_payment
                WHERE learner_payment_id = (SELECT MAX (learner_payment_id)
                                              FROM learner_payment
                                             WHERE payment_status_id = '2' and learner_application_id=p_appid));

      v_return_amt   VARCHAR2 (100) := NULL;
   BEGIN
      OPEN payment_amt_cur;

      FETCH payment_amt_cur
       INTO v_return_amt;

      CLOSE payment_amt_cur;

      RETURN NVL (v_return_amt, 0);
   EXCEPTION
      WHEN OTHERS
      THEN
         email_error (   'get_app_payment '
                      || 'SQLCODE='
                      || SQLCODE
                      || ' SQL ERROR = '
                      || SQLERRM
                     );
         RETURN 0;
   END getPaymentReportFeesAwarded;
 
FUNCTION getPayReportFeesAlreadyPaid (
      p_appid   IN   learner_application.learner_application_id%TYPE
   )
      RETURN NUMBER
   IS
/*
get_app_payment
(appID IN learner_application.application_status_id%TYPE)
Returns the amount of the payment for this application. If there is only one
positive payment for the application the returned amount should be the amount
of that payment. If there is a negative amount, the returned value should be 0
if the recovery has already been paid or minus the amount if the recovery
payment is still pending.
*/
      CURSOR payment_amt_cur
      IS
        SELECT   SUM (DECODE (transaction_type_id, 1, amount, 0)) - SUM (DECODE (transaction_type_id, 2, amount, 0))
            amount
            FROM learner_payment
        WHERE  learner_application_id = p_appid
        AND payment_status_id = '2'
        AND transaction_type_id IN ('1', '2')
        AND to_date(LEARNER_PAYMENT.LAST_UPDATED_ON) <>
              (SELECT to_date(last_updated_on)
                 FROM learner_payment
                WHERE learner_payment_id = (SELECT MAX (learner_payment_id)
                                              FROM learner_payment
                                             WHERE payment_status_id = '2' and learner_application_id=p_appid));

      v_return_amt   VARCHAR2 (100) := NULL;
   BEGIN
      OPEN payment_amt_cur;

      FETCH payment_amt_cur
       INTO v_return_amt;

      CLOSE payment_amt_cur;

      RETURN NVL (v_return_amt, 0);
   EXCEPTION
      WHEN OTHERS
      THEN
         email_error (   'get_app_payment '
                      || 'SQLCODE='
                      || SQLCODE
                      || ' SQL ERROR = '
                      || SQLERRM
                     );
         RETURN 0;
   END getPayReportFeesAlreadyPaid;
  
   FUNCTION has_pending_payments (
      p_appid   IN   learner_application.learner_application_id%TYPE
   )
      RETURN VARCHAR2
   IS
/*
has_pending_payments
(appID IN learner_application.application_status_id%TYPE)
This function should return 'true' if the application has payments in status
'Pending' regardless of their type or session for which the application was
registered.
*/
      v_return_val   VARCHAR2 (100) := NULL;

      CURSOR pend_payments_cur
      IS
         SELECT 1
           FROM learner_payment
          WHERE learner_application_id = p_appid AND payment_status_id = 1;
   -- unpaid
   BEGIN
      OPEN pend_payments_cur;

      FETCH pend_payments_cur
       INTO v_return_val;

      CLOSE pend_payments_cur;

      SELECT DECODE (v_return_val, 1, 'true', 'false')
        INTO v_return_val
        FROM DUAL;

      RETURN v_return_val;
   EXCEPTION
      WHEN OTHERS
      THEN
         email_error (   'has_pending_payments '
                      || 'SQLCODE='
                      || SQLCODE
                      || ' SQL ERROR = '
                      || SQLERRM
                     );
         RETURN 'false';
   END has_pending_payments;

   FUNCTION provider_balance (p_provider_id IN provider.provider_id%TYPE)
      RETURN NUMBER
   IS
/*
has_pending_payments
(appID IN learner_application.application_status_id%TYPE)
This function should return 'true' if the application has payments in status
'Pending' regardless of their type or session for which the application was
registered.
*/
      v_return_val   VARCHAR2 (100) := NULL;

      CURSOR prov_bal_cur
      IS
         SELECT NVL (p.outstanding_amount, 0)
           FROM provider p
          WHERE p.provider_id = p_provider_id;
   BEGIN
      OPEN prov_bal_cur;

      FETCH prov_bal_cur
       INTO v_return_val;

      CLOSE prov_bal_cur;

      RETURN NVL (v_return_val, 0);
   EXCEPTION
      WHEN OTHERS
      THEN
         email_error (   'provider_balance '
                      || 'SQLCODE='
                      || SQLCODE
                      || ' SQL ERROR = '
                      || SQLERRM
                     );
         RETURN NULL;
   END provider_balance;

   FUNCTION get_updated_status (
      p_appid   IN   learner_application.learner_application_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_prev_run_date                 VARCHAR2 (19)
                                             := pk_payments.previous_run_date;

/*get_updated_status
(appID IN learner_application.application_status_id%TYPE)
This function should return 'true' if any of the fields comprising the
V_PROVIDER_STATUS_REPORT record have been changed since the last run of the
status report. The changes should be considered as new, when they are made
after the date specified as a run date for the report from the previous month.
This date can be read from the ILA500 configuration table in the following way:
select cval
  from ila500_config_data
 where UPPER(item_name) =
       UPPER(trim(to_char(trunc(sysdate, 'MONTH') - 1, 'Month')))
       || '_LAST_WDAY'

*/
      CURSOR vu_flashback_cur
      IS
/* #######MAY BE ABLE TO USE FEATURE BELOW IN 11G !!!
 SELECT iv1.session_year, iv1.ilarefnum, iv1.forename, iv1.surname,
        iv1.dob, iv1.courselevel, iv1.coursetype,
        iv1.current_course_year, iv1.feesawarded, iv1.paymentdate,
        iv1.feestatus, iv1.applstatus, iv1.current_provider,
        iv1.current_session
   FROM (SELECT learner_application_id, session_year, ilarefnum,
                forename, surname, dob, courselevel, coursetype,
                current_course_year, feesawarded, paymentdate,
                feestatus, applstatus, current_provider,
                current_session
           FROM vu_provider_status_report AS OF TIMESTAMP TO_TIMESTAMP
                                                            (v_prev_run_date,

                                                             --function call
                                                             'YYYY-MM-DD HH24:MI:SS'
                                                            )) iv1
  WHERE iv1.learner_application_id = p_appid;*/
         SELECT session_year, ilarefnum, forename, surname, dob, courselevel,
                coursetype, current_course_year, feesawarded, paymentdate,
                feestatus, applstatus, current_provider, current_session,
                recalculated_fee, difference, payment_deduction_date
           FROM prov_stat_hist
          WHERE learner_application_id = p_appid;

      CURSOR vu_current_cur
      IS
         SELECT session_year, ilarefnum, forename, surname, dob, courselevel,
                coursetype, current_course_year, feesawarded, paymentdate,
                feestatus, applstatus, current_provider, current_session,
                recalculated_fee,difference, payment_deduction_date
           FROM vu_provider_status_report
          WHERE learner_application_id = p_appid;

      v_old_session_year              vu_provider_status_report.session_year%TYPE;
      v_old_ilarefnum                 vu_provider_status_report.ilarefnum%TYPE;
      v_old_forename                  vu_provider_status_report.forename%TYPE;
      v_old_surname                   vu_provider_status_report.surname%TYPE;
      v_old_dob                       vu_provider_status_report.dob%TYPE;
      v_old_courselevel               vu_provider_status_report.courselevel%TYPE;
      v_old_coursetype                vu_provider_status_report.coursetype%TYPE;
      v_old_current_course_year       vu_provider_status_report.current_course_year%TYPE;
      v_old_feesawarded               vu_provider_status_report.feesawarded%TYPE;
      v_old_paymentdate               vu_provider_status_report.paymentdate%TYPE;
      v_old_feestatus                 vu_provider_status_report.feestatus%TYPE;
      v_old_applstatus                vu_provider_status_report.applstatus%TYPE;
      v_old_current_provider          vu_provider_status_report.current_provider%TYPE;
      v_old_current_session           vu_provider_status_report.current_session%TYPE;
      v_old_recalculated_fee          vu_provider_status_report.recalculated_fee%TYPE;
      v_old_difference                vu_provider_status_report.difference%TYPE;
      v_old_payment_deduction_date    vu_provider_status_report.payment_deduction_date%TYPE;
      v_current_session_year          vu_provider_status_report.session_year%TYPE;
      v_current_ilarefnum             vu_provider_status_report.ilarefnum%TYPE;
      v_current_forename              vu_provider_status_report.forename%TYPE;
      v_current_surname               vu_provider_status_report.surname%TYPE;
      v_current_dob                   vu_provider_status_report.dob%TYPE;
      v_current_courselevel           vu_provider_status_report.courselevel%TYPE;
      v_current_coursetype            vu_provider_status_report.coursetype%TYPE;
      v_current_current_course_year   vu_provider_status_report.current_course_year%TYPE;
      v_current_feesawarded           vu_provider_status_report.feesawarded%TYPE;
      v_current_paymentdate           vu_provider_status_report.paymentdate%TYPE;
      v_current_feestatus             vu_provider_status_report.feestatus%TYPE;
      v_current_applstatus            vu_provider_status_report.applstatus%TYPE;
      v_current_current_provider      vu_provider_status_report.current_provider%TYPE;
      v_current_current_session       vu_provider_status_report.current_session%TYPE;
      v_current_recalculated_fee      vu_provider_status_report.recalculated_fee%TYPE;
      v_current_difference            vu_provider_status_report.difference%TYPE;
      v_cur_payment_deduction_date    vu_provider_status_report.payment_deduction_date%TYPE;
      
   BEGIN
      OPEN vu_flashback_cur;

      FETCH vu_flashback_cur
       INTO v_old_session_year, v_old_ilarefnum, v_old_forename,
            v_old_surname, v_old_dob, v_old_courselevel, v_old_coursetype,
            v_old_current_course_year, v_old_feesawarded, v_old_paymentdate,
            v_old_feestatus, v_old_applstatus, v_old_current_provider,
            v_old_current_session, v_old_recalculated_fee, v_old_difference,
            v_old_payment_deduction_date;

      CLOSE vu_flashback_cur;

      OPEN vu_current_cur;

      FETCH vu_current_cur
       INTO v_current_session_year, v_current_ilarefnum, v_current_forename,
            v_current_surname, v_current_dob, v_current_courselevel,
            v_current_coursetype, v_current_current_course_year,
            v_current_feesawarded, v_current_paymentdate,
            v_current_feestatus, v_current_applstatus,
            v_current_current_provider, v_current_current_session,
            v_current_recalculated_fee, v_current_difference,
            v_cur_payment_deduction_date;

      CLOSE vu_current_cur;

      IF (   v_current_session_year <> v_old_session_year
          OR v_current_ilarefnum <> v_old_ilarefnum
          OR v_current_forename <> v_old_forename
          OR v_current_surname <> v_old_surname
          OR v_current_dob <> v_old_dob
          OR v_current_courselevel <> v_old_courselevel
          OR v_current_coursetype <> v_old_coursetype
          OR v_current_current_course_year <> v_old_current_course_year
          OR v_current_feesawarded <> v_old_feesawarded
          OR v_current_paymentdate <> v_old_paymentdate
          OR v_current_feestatus <> v_old_feestatus
          OR v_current_applstatus <> v_old_applstatus
          OR v_current_current_provider <> v_old_current_provider
          OR v_current_current_session <> v_old_current_session
          OR v_current_recalculated_fee <> v_old_recalculated_fee
          OR v_current_difference <> v_old_difference
          OR v_cur_payment_deduction_date <> v_old_payment_deduction_date
         )
      THEN
         RETURN 'true';                                                --true
      ELSE
         RETURN 'false';
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         email_error (   'get_updated_status '
                      || 'SQLCODE='
                      || SQLCODE
                      || ' SQL ERROR = '
                      || SQLERRM
                     );
         RETURN 'false';
   END get_updated_status;

   FUNCTION get_payment_status (
      p_appid   IN   learner_application.learner_application_id%TYPE
   )
      RETURN VARCHAR2
   IS
/*get_payment_status
(appID IN learner_application.application_status_id%TYPE)
Returns the status of the payment, if any, for this particular learner
application. If the application has a recovery payments (due to withdrawal or
non attendance) and the status of the payment is 'Pending' the returned status
should be "Recovery". If the recovery payment is already paid, the returned
status should be "Recovered".
*/
      CURSOR pay_status_cur
      IS
         SELECT CASE
                   WHEN (    ttp.description = 'DEBIT'
                         AND lstat.payment_desc = 'UNPAID'
                        )
/*recovery withdrawal/non attendance*/
                THEN 'RECOVERY'
                   WHEN (    ttp.description = 'DEBIT'
                         AND lstat.payment_desc = 'PAID'
                        )
                      THEN 'RECOVERED'
                   ELSE lstat.payment_desc
                END status_of_payment
           FROM learner_payment lpay,
                payment_status lstat,
                transaction_type ttp
          WHERE lpay.payment_status_id = lstat.payment_status_id
            AND lpay.transaction_type_id = ttp.transaction_type_id
            AND lpay.learner_application_id = p_appid
            /* ensure we take only most recent payment status, could be more than one per application*/
            AND lpay.learner_payment_id =
                                 (SELECT MAX (learnerpayid)
                                        FROM (SELECT MIN (
                                                        lp2.learner_payment_id)
                                                        learnerpayid
                                                FROM learner_payment lp2,
                                                     learner_application la
                                               WHERE     lp2.learner_application_id =
                                                            p_appid
                                                     AND la.learner_application_id =
                                                            lp2.learner_application_id
                                                     AND la.recalculated_fee
                                                            IS NOT NULL
                                              UNION
                                              SELECT MAX (
                                                        lp2.learner_payment_id)
                                                FROM learner_payment lp2,
                                                     learner_application la
                                               WHERE     lp2.learner_application_id =
                                                            p_appid
                                                     AND la.learner_application_id =
                                                            lp2.learner_application_id
                                                     AND la.recalculated_fee
                                                            IS NULL) x);

      v_return_status   VARCHAR2 (100) := NULL;
   BEGIN
      OPEN pay_status_cur;

      FETCH pay_status_cur
       INTO v_return_status;

      CLOSE pay_status_cur;

      RETURN NVL (v_return_status, 'NULL');
   EXCEPTION
      WHEN OTHERS
      THEN
         email_error (   'get_payment_status '
                      || 'SQLCODE='
                      || SQLCODE
                      || ' SQL ERROR = '
                      || SQLERRM
                     );
         RETURN NULL;
   END get_payment_status;

FUNCTION get_recalc_payment_date (
      p_appid   IN   learner_application.learner_application_id%TYPE
   )
      RETURN VARCHAR2
   IS
/*get_payment_status
(appID IN learner_application.application_status_id%TYPE)
Returns the status of the payment, if any, for this particular learner
application. If the application has a recovery payments (due to withdrawal or
non attendance) and the status of the payment is 'Pending' the returned status
should be "Recovery". If the recovery payment is already paid, the returned
status should be "Recovered".
*/
      CURSOR pay_status_cur
      IS
         SELECT CASE
          WHEN (lpay.payment_status_id='2')
           THEN
             TO_CHAR(lpay.last_updated_on,'dd/mm/yyyy')                                 
          ELSE
             lstat.payment_desc
       END
          status_of_payment
  FROM learner_payment lpay, payment_status lstat
 WHERE     lpay.payment_status_id = lstat.payment_status_id
       AND lpay.learner_application_id = p_appid
       AND lpay.learner_payment_id = (select max(learner_payment_id) from learner_payment where learner_application_id=p_appid);

      v_return_status   VARCHAR2 (100) := NULL;
   BEGIN
      OPEN pay_status_cur;

      FETCH pay_status_cur
       INTO v_return_status;

      CLOSE pay_status_cur;

      RETURN NVL (v_return_status, 'NULL');
   EXCEPTION
      WHEN OTHERS
      THEN
         email_error (   'get_payment_status '
                      || 'SQLCODE='
                      || SQLCODE
                      || ' SQL ERROR = '
                      || SQLERRM
                     );
         RETURN NULL;
   END get_recalc_payment_date;

PROCEDURE process_standard_payments
IS
/*
This stored procedure's purpose is to generate records for the individual
provider payments in PROVIDER_PAYMENT tables as well as record for the total
payment in ADI_PAYMENT for the current fee run. The logic of the procedure
could be summarized in the following sentences: For each learning provider,
for which learner applications exists in status 'Calculated', aggregate the
learner payments for those applications and create summary record in
PROVIDER_PAYMENT table. The applications which payments should be summarized
must be limited to those, whose courses fall into the scope of the current fee
run, i.e. the start_date of their course is between the fee_start_date and
fee_end_date for the current batch run and their course type corresponds to the
current batch run (the current date of the batch run equals the batch_run_date
of the course type). For each provider with calculated total in the current run
a record in PROVIDER_PAYMENT should be created. After all providers are
processed, a total for all provider should be produced and a record created in
ADI_PAYMENT table.

RH 11/03/2009 testing error 354. Change code to include learner applications
                with status 'Calculated' AND 'WITHDRAWN' AND 'NON_ATTENDANCE'
                
RH 03/06/2009 testing error 541. Change code to update only the relevant learner
payment records, i.e. update only learner payments for the provider payment just
created: WHERE app.provider_id = a_provider (indx)               
                
*/
   TYPE provider_array IS VARRAY (10000) OF NUMBER (30);

   TYPE amount_array IS VARRAY (10000) OF NUMBER (30, 2);

   a_provider          provider_array;
   a_amount            amount_array;
   a_debits_amount     amount_array;
   a_credits_amount    amount_array;
   a_run_id            provider_array;
   a_prov_bal          amount_array;

   CURSOR c_num_recs
   IS
      SELECT COUNT (1)
        FROM learner_application app,
             course_type ctp,
             learner_payment lpy,
             learner l,
             (SELECT transaction_type_id debit
                FROM transaction_type
               WHERE description = 'DEBIT') iv_trans_type,
             (SELECT application_status_id calculated
                FROM application_status
               WHERE status IN ('CALCULATED', 'WITHDRAWN', 'NON_ATTENDANCE')) iv_status,
             (SELECT payment_status_id unpaid
                FROM payment_status
               WHERE payment_desc = 'UNPAID') iv_pay_status,
             (SELECT bacs_run_id run_id
                FROM bacs_run
               WHERE bacs_run_date = TRUNC (SYSDATE)) iv_bacs_run
       WHERE lpy.learner_application_id = app.learner_application_id
         AND app.application_status_id = iv_status.calculated
         AND app.course_type_id = ctp.course_type_id
         AND l.learner_id = app.learner_id
    --     AND app.course_start_date BETWEEN ctp.fee_period_start
     --                                  AND ctp.fee_period_end
         AND ctp.batch_run_date = TRUNC (SYSDATE)
         AND lpy.provider_payment_id IS NULL
         AND l.hold_payments <> 'Y'
         AND lpy.payment_status_id = iv_pay_status.unpaid;

   CURSOR c1
   IS
SELECT   app.provider_id,
           SUM (DECODE (lpy.transaction_type_id,
                        iv_trans_type.debit, -1 * lpy.amount,
                        lpy.amount
                       )
               )
         + pk_payments.provider_balance (provider_id) amount,
         SUM (DECODE (lpy.transaction_type_id,
                      iv_trans_type.debit, -1 * lpy.amount,
                      0
                     )
             ) debits_amount,                                    -- recoveries
         SUM (DECODE (lpy.transaction_type_id,
                      iv_trans_type.debit, 0,
                      lpy.amount
                     )
             ) credits_amount,
         iv_bacs_run.run_id,
         pk_payments.provider_balance (provider_id) prov_bal_amount
                                         -- can be positive provider owes saas
    -- negative we owe provider
    -- or 0
FROM     learner_application app,
         course_type ctp,
         learner_payment lpy,
         learner l,
         (SELECT transaction_type_id debit
            FROM transaction_type
           WHERE description = 'DEBIT') iv_trans_type,
         (SELECT payment_status_id unpaid
            FROM payment_status
           WHERE payment_desc = 'UNPAID') iv_pay_status,
         (SELECT bacs_run_id run_id
            FROM bacs_run
           WHERE bacs_run_date = TRUNC (SYSDATE)
                                                -- should modify this date for unit testing
         ) iv_bacs_run
   --ALL RUNS
WHERE    lpy.learner_application_id = app.learner_application_id
     AND lpy.provider_payment_id IS NULL                      -- not processed
     AND lpy.payment_status_id = iv_pay_status.unpaid
     AND app.course_type_id = ctp.course_type_id
     AND app.learner_id = l.learner_id
     AND l.hold_payments <> 'Y'
     --STANDARD RUNS
     AND (   (    ctp.batch_run_date = TRUNC (SYSDATE)
              AND app.application_status_id = 2
         --     AND app.course_start_date BETWEEN ctp.fee_period_start
          --                                  AND ctp.fee_period_end
             )
--for withdrawal cases
          OR (app.application_status_id = 5
             )
--for non-attendance cases
          OR (app.application_status_id = 6)
         )
GROUP BY app.provider_id, iv_bacs_run.run_id;

   v_run_date          DATE            := NULL;
   v_sql               VARCHAR2 (1000);
   adi_total_payment   NUMBER (30, 2)  := 0;
   v_debug             VARCHAR2 (1000);
   no_data             EXCEPTION;
   l_num_recs          NUMBER          := 0;
   
   l_provider_id       provider.PROVIDER_ID%TYPE:=0;
   
BEGIN
   OPEN c_num_recs;

   FETCH c_num_recs
    INTO l_num_recs;

   CLOSE c_num_recs;

   IF l_num_recs = 0                    -- Exit procedure if there is no data
   THEN
      DBMS_OUTPUT.put_line ('NOT FOUND');
      v_debug := 'No data found, exiting the procedure';
      RAISE no_data;
   END IF;

   OPEN c1;

   FETCH c1
   BULK COLLECT INTO a_provider, a_amount, a_debits_amount, a_credits_amount,
          a_run_id, a_prov_bal;

   CLOSE c1;

   FOR indx IN a_provider.FIRST .. a_provider.LAST
   LOOP
   
      l_provider_id := a_provider (indx);
   
      DBMS_OUTPUT.put_line (   a_provider (indx)
                            || ' '
                            || a_debits_amount (indx)
                            || ' '
                            || a_credits_amount (indx)
                            || ' '
                            || a_amount (indx)
                            || ' '
                            || a_run_id (indx)
                           );
      v_sql :=
            ' INSERT INTO PROVIDER_PAYMENT ('
         || '   BACS_RUN_ID, PROVIDER_ID, TOTAL_AMOUNT,DEBITS_AMOUNT,CREDITS_AMOUNT, ADI_PAYMENT_ID, prov_bal_amount) '
         || 'VALUES ('
         || a_run_id (indx)                                    /*BACS RUN ID*/
         || ' ,'
         || a_provider (indx)
         || ' ,'
         || a_amount (indx)
         || ' ,'
         || a_debits_amount (indx)
         || ','
         || a_credits_amount (indx)
         || ','
         || 0                  -- will be updated later with the correct value
         || ','
         || a_prov_bal (indx)
         || ')';
      DBMS_OUTPUT.put_line (v_sql);
      v_debug := 'inserting into provider payment';

      EXECUTE IMMEDIATE v_sql;

--update learner payment here

UPDATE learner_payment
   SET provider_payment_id = provider_payment_id_seq.CURRVAL,
       payment_status_id = (SELECT payment_status_id
                              FROM payment_status
                             WHERE payment_desc = 'PAID')
 WHERE learner_payment_id IN (
          SELECT lpy.learner_payment_id
            FROM learner_application app,
                 course_type ctp,
                 learner_payment lpy,
                 learner l,
                 (SELECT transaction_type_id debit
                    FROM transaction_type
                   WHERE description = 'DEBIT') iv_trans_type,
                 (SELECT payment_status_id unpaid
                    FROM payment_status
                   WHERE payment_desc = 'UNPAID') iv_pay_status,
                 (SELECT bacs_run_id run_id
                    FROM bacs_run
                   WHERE bacs_run_date = TRUNC (SYSDATE)
                                                        -- should modify this date for unit testing
                 ) iv_bacs_run
           --ALL RUNS
          WHERE  lpy.learner_application_id = app.learner_application_id
             AND lpy.provider_payment_id IS NULL              -- not processed
             AND lpy.payment_status_id = iv_pay_status.unpaid
             AND app.course_type_id = ctp.course_type_id
             AND app.learner_id = l.learner_id
             AND app.provider_id = l_provider_id 
             AND l.hold_payments <> 'Y'
             --STANDARD RUNS
             AND (   (    ctp.batch_run_date = TRUNC (SYSDATE)
                      AND app.application_status_id = 2
                  --    AND app.course_start_date BETWEEN ctp.fee_period_start
                   --                                 AND ctp.fee_period_end
                     )
--for withdrawal cases
                  OR (  app.application_status_id = 5
                     )
--for non-attendance cases
                  OR ( app.application_status_id = 6
                     )
                 ));
               
--UPDATE LEARNER_APPLICATION PAYMENT DATE 
 
          UPDATE learner_application app
          SET  app.payment_date = sysdate
          WHERE app.learner_application_id IN(     
          SELECT app.learner_application_id
            FROM learner_application app,
                 course_type ctp,
                 learner_payment lpy,
                 learner l
          WHERE  lpy.learner_application_id = app.learner_application_id
             AND lpy.provider_payment_id IS NOT NULL              
             AND lpy.payment_status_id = 2
             AND app.course_type_id = ctp.course_type_id
             AND app.learner_id = l.learner_id
             AND l.hold_payments <> 'Y'
             AND ctp.batch_run_date = TRUNC (SYSDATE));
          --   AND app.application_status_id = 2);   ---THIS IS NOT REQUIRED AS THIS WILL STILL RETURN CASES WHICH WERE PAID TO INCLUDE WITHDRAWN CASES
             
--UPDATE LEARNER_APPLICATION DEBT STATUS

            UPDATE learner_application app
            SET app.debt_status = 2
            WHERE app.learner_application_id IN(
            
            SELECT app.learner_application_id
            FROM learner_application app,
                 learner_payment lpy,
                 learner l
          WHERE  lpy.learner_application_id = app.learner_application_id
             AND lpy.provider_payment_id IS NOT NULL              
             AND lpy.payment_status_id = 2
             AND lpy.transaction_type_id = 2
             AND app.recover_fees = 'Y'
             AND app.learner_id = l.learner_id
             AND l.hold_payments <> 'Y'
             AND app.application_status_id IN(5,6));
             

--if amount>=0 then
--update provider_balance set prov_bal_amount=0, and add to adi file total
--else
--update provider_balance set prov_bal_amount=amount
      IF a_amount (indx) >= 0
      THEN
         update_prov_bal (a_provider (indx), 0);
         adi_total_payment := adi_total_payment + a_amount (indx);
      ELSE
         update_prov_bal (a_provider (indx), a_amount (indx));
--do not add negatice amounts to adi file total
      END IF;
   END LOOP;

   create_adi_payment (adi_total_payment);

   --set adi payment id
   UPDATE provider_payment
      SET adi_payment_id = adi_payment_id_seq.CURRVAL
    WHERE adi_payment_id = 0;

   COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND
   THEN   
      email_error (   'NO DATA FROM  process_standard_payments CURSOR '
                   || 'SQLCODE='
                   || SQLCODE
                   || ' SQL ERROR = '
                   || SQLERRM
                  ); 
      ROLLBACK;
   WHEN OTHERS 
   THEN 
      email_error (   'process_standard_payments '
                   || 'SQLCODE='
                   || SQLCODE
                   || ' SQL ERROR = '
                   || SQLERRM
                  ); 
      ROLLBACK;
END process_standard_payments;   
PROCEDURE create_adi_payment (adi_total_payment IN NUMBER)
   IS
/*
This stored procedure's purpose is to sum all the provider payments from the
current batch fee run and produce ADI payment record, which is the total for
all providers. This procedure should only take into account the provider
records which are generated for the current run, i.e. have batch_run_id equal
to the one passed as parameter and having payment status 'Unpaid'.
*/
   BEGIN
      INSERT INTO adi_payment
                  (total_payment_amount
                  )
           VALUES (adi_total_payment
                  );
   EXCEPTION
      WHEN OTHERS
      THEN
         email_error (   'create_adi_payment '
                      || 'SQLCODE='
                      || SQLCODE
                      || ' SQL ERROR = '
                      || SQLERRM
                     );
         RAISE;
   END create_adi_payment;

   PROCEDURE email_error (error_message IN VARCHAR2)
   IS 
      cursor dbname_cursor is select SYS_CONTEXT ('USERENV', 'DB_NAME') db_name from dual;
      l_mailhost    VARCHAR2 (64)       := 'mailhost';
      l_from        VARCHAR2 (64)      := 'clark.bolan@scotland.gsi.gov.uk';
      l_subject     VARCHAR2 (64)       := 'ILA500.PK_PAYMENTS PLSQL ERROR ';
      l_to          VARCHAR2 (200)      := 'clark.bolan@scotland.gsi.gov.uk';
      l_to2         VARCHAR2 (200)      := 'john.Penman@scotland.gsi.gov.uk';
      l_to3         VARCHAR2 (200)      := 'paul.hughes@scotland.gsi.gov.uk';
      --BSU LIVE
      l_mail_conn   UTL_SMTP.connection;
      v_dbname VARCHAR2(100);
   BEGIN
      open dbname_cursor;
      fetch dbname_cursor into v_dbname;
      close dbname_cursor;

      l_mail_conn := UTL_SMTP.open_connection (l_mailhost, 25);
      UTL_SMTP.helo (l_mail_conn, l_mailhost);
      UTL_SMTP.mail (l_mail_conn, l_from);
      UTL_SMTP.rcpt (l_mail_conn, l_to);
      UTL_SMTP.rcpt (l_mail_conn, l_to2);
      UTL_SMTP.rcpt (l_mail_conn, l_to3);
      UTL_SMTP.open_data (l_mail_conn);
      UTL_SMTP.write_data (l_mail_conn,
                              'Date: '
                           || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS')
                           || CHR (13)
                          );
      UTL_SMTP.write_data (l_mail_conn, 'From: ' || l_from || CHR (13));
      UTL_SMTP.write_data (l_mail_conn, 'Subject: ' || l_subject || v_dbname||CHR (13));
      UTL_SMTP.write_data (l_mail_conn, 'To: ' || l_to || CHR (13));
      UTL_SMTP.write_data (l_mail_conn, '' || CHR (13));
-- loop could be used for several messages, commented out here
--      FOR i IN 1 .. 10
--      LOOP
      UTL_SMTP.write_data (l_mail_conn,
                           error_message /*|| TO_CHAR (i) */ || CHR (13)
                          );
--      END LOOP;
      UTL_SMTP.close_data (l_mail_conn);
      UTL_SMTP.quit (l_mail_conn);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('pk_payments.email_error procedure FAILURE');
         RAISE;
   END email_error;

   FUNCTION previous_run_date
      RETURN VARCHAR2
   IS
      CURSOR previous_run_cur
      IS
         SELECT TO_CHAR (TO_DATE (   cval
                                  || '-'
                                  || UPPER (TRIM (TO_CHAR (  TRUNC (SYSDATE,
                                                                    'MONTH'
                                                                   )
                                                           - 1,
                                                           'Month'
                                                          )
                                                 )
                                           )
                                  || '-'
                                  || TO_CHAR (SYSDATE, 'yyyy')
                                 ),
                         'YYYY-MM-DD HH24:MI:SS'
                        )
           FROM ila500_config_data
          WHERE UPPER (item_name) =
                      UPPER (TRIM (TO_CHAR (TRUNC (SYSDATE, 'MONTH') - 1,
                                            'Month'
                                           )
                                  )
                            )
                   || '_LAST_WDAY';

      v_last_run_date   VARCHAR2 (19) := NULL;
   BEGIN
      OPEN previous_run_cur;

      FETCH previous_run_cur
       INTO v_last_run_date;

      CLOSE previous_run_cur;

      RETURN NVL (v_last_run_date, '0000-00-00 00:00:00');
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line
                            ('pk_payments.previous_run_date function FAILURE');
         RETURN '0000-00-00 00:00:00';
         RAISE;
   END previous_run_date;

   PROCEDURE update_learner_appl_nvl (
      pi_learner_id                   IN   VARCHAR2,
      pi_course_id                    IN   VARCHAR2,
      pi_course_type_id               IN   VARCHAR2,
      pi_provider_id                  IN   VARCHAR2,
      pi_application_status_id        IN   VARCHAR2,
      pi_rejection_id                 IN   VARCHAR2,
      pi_total_annual_income          IN   VARCHAR2,
      pi_tot_ann_inc_evid_id          IN   VARCHAR2,
      pi_no_income                    IN   VARCHAR2,
      pi_no_income_evid_id            IN   VARCHAR2,
      pi_job_seekers_allowance        IN   VARCHAR2,
      pi_jsa_evid_id                  IN   VARCHAR2,
      pi_income_support               IN   VARCHAR2,
      pi_inc_sup_evid_id              IN   VARCHAR2,
      pi_incapacity_benefit           IN   VARCHAR2,
      pi_inc_ben_evid_id              IN   VARCHAR2,
      pi_carers_allowance             IN   VARCHAR2,
      pi_carers_allowance_evid_id     IN   VARCHAR2,
      pi_pension_credit               IN   VARCHAR2,
      pi_pension_credit_evid_id       IN   VARCHAR2,
      pi_mct                          IN   VARCHAR2,
      pi_mct_evid_id                  IN   VARCHAR2,
      pi_session_year                 IN   VARCHAR2,
      pi_date_app_recd                IN   VARCHAR2,
      pi_date_record_created          IN   VARCHAR2,
      pi_date_of_last_calc            IN   VARCHAR2,
      pi_course_title                 IN   VARCHAR2,
      pi_course_start_date            IN   VARCHAR2,
      pi_length_of_course             IN   VARCHAR2,
      pi_current_course_year          IN   VARCHAR2,
      pi_course_end_date              IN   VARCHAR2,
      pi_help_with_fees               IN   VARCHAR2,
      pi_help_amount                  IN   VARCHAR2,
      pi_fee_requested                IN   VARCHAR2,
      pi_provider_signature_present   IN   VARCHAR2,
      pi_endorsed_by                  IN   VARCHAR2,
      pi_date_endorsed                IN   VARCHAR2,
      pi_stamped                      IN   VARCHAR2,
      pi_learner_signature_present    IN   VARCHAR2,
      pi_date_signed                  IN   VARCHAR2,
      pi_fee_paid_bacs                IN   VARCHAR2,
      pi_payment_date                 IN   VARCHAR2,
      pi_recover_fees                 IN   VARCHAR2,
      pi_debt_status                  IN   VARCHAR2,
      pi_fee_calculated               IN   VARCHAR2,
      pi_comments_for_award_letter    IN   VARCHAR2,
      pi_award_letter_duplicate       IN   VARCHAR2,
      pi_non_attendance               IN   VARCHAR2,
      pi_date_withdrawn               IN   VARCHAR2,
      pi_date_actioned                IN   VARCHAR2,
      pi_last_updated_by              IN   VARCHAR2,
      pi_learner_application_id       IN   VARCHAR2,
      pi_last_letter_generated        IN   VARCHAR2
   )
   IS
   /******************************************************************************
      NAME:       UPDATE_LEARNER_APPL_NVL
      PURPOSE:    Dynamically updates the fields of a learner application.
                  The fields that dont get values at runtime are left with
                  their original values.

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        12/08/2008  Angel Anchev     Created this procedure.
      1.1        04/12/2008  Angel Anchev     All parameters changed to VARCHAR2
   ******************************************************************************/
   BEGIN
      UPDATE learner_application
         SET learner_id = NVL (pi_learner_id, learner_id),
             course_id = NVL (pi_course_id, course_id),
             course_type_id = NVL (pi_course_type_id, course_type_id),
             provider_id = NVL (pi_provider_id, provider_id),
             application_status_id =
                         NVL (pi_application_status_id, application_status_id),
             rejection_id = NVL (pi_rejection_id, rejection_id),
             total_annual_income =
                             NVL (pi_total_annual_income, total_annual_income),
             tot_ann_inc_evid_id =
                             NVL (pi_tot_ann_inc_evid_id, tot_ann_inc_evid_id),
             no_income = NVL (pi_no_income, no_income),
             no_income_evid_id = NVL (pi_no_income_evid_id, no_income_evid_id),
             job_seekers_allowance =
                         NVL (pi_job_seekers_allowance, job_seekers_allowance),
             jsa_evid_id = NVL (pi_jsa_evid_id, jsa_evid_id),
             income_support = NVL (pi_income_support, income_support),
             inc_sup_evid_id = NVL (pi_inc_sup_evid_id, inc_sup_evid_id),
             incapacity_benefit =
                               NVL (pi_incapacity_benefit, incapacity_benefit),
             inc_ben_evid_id = NVL (pi_inc_ben_evid_id, inc_ben_evid_id),
             carers_allowance = NVL (pi_carers_allowance, carers_allowance),
             carers_allowance_evid_id =
                   NVL (pi_carers_allowance_evid_id, carers_allowance_evid_id),
             pension_credit = NVL (pi_pension_credit, pension_credit),
             pension_credit_evid_id =
                       NVL (pi_pension_credit_evid_id, pension_credit_evid_id),
             max_child_tax_credit = NVL (pi_mct, max_child_tax_credit),
             max_child_tax_credit_evid_id =
                            NVL (pi_mct_evid_id, max_child_tax_credit_evid_id),
             session_year = NVL (pi_session_year, session_year),
             date_app_recd =
                 NVL (TO_DATE (pi_date_app_recd, 'DD-MM-YYYY'), date_app_recd),
             date_record_created =
                NVL (TO_DATE (pi_date_record_created, 'DD-MM-YYYY'),
                     date_record_created
                    ),
             date_of_last_calc =
                NVL (TO_DATE (pi_date_of_last_calc, 'DD-MM-YYYY'),
                     date_of_last_calc
                    ),
             course_title = NVL (pi_course_title, course_title),
             course_start_date =
                NVL (TO_DATE (pi_course_start_date, 'DD-MM-YYYY'),
                     course_start_date
                    ),
             length_of_course = NVL (pi_length_of_course, length_of_course),
             current_course_year =
                             NVL (pi_current_course_year, current_course_year),
             course_end_date = NVL (pi_course_end_date, course_end_date),
             help_with_fees = NVL (pi_help_with_fees, help_with_fees),
             help_amount = NVL (pi_help_amount, help_amount),
             fee_requested = NVL (pi_fee_requested, fee_requested),
             provider_signature_present =
                NVL (pi_provider_signature_present,
                     provider_signature_present),
             endorsed_by = NVL (pi_endorsed_by, endorsed_by),
             date_endorsed =
                 NVL (TO_DATE (pi_date_endorsed, 'DD-MM-YYYY'), date_endorsed),
             stamped = NVL (pi_stamped, stamped),
             learner_signature_present =
                 NVL (pi_learner_signature_present, learner_signature_present),
             date_signed =
                     NVL (TO_DATE (pi_date_signed, 'DD-MM-YYYY'), date_signed),
             fee_paid_bacs = NVL (pi_fee_paid_bacs, fee_paid_bacs),
             payment_date =
                   NVL (TO_DATE (pi_payment_date, 'DD-MM-YYYY'), payment_date),
             last_letter_generated  =
                   NVL (TO_DATE (pi_last_letter_generated, 'DD-MM-YYYY'), last_letter_generated),
             recover_fees = NVL (pi_recover_fees, recover_fees),
             debt_status = NVL (pi_debt_status, debt_status),
             fee_calculated = NVL (pi_fee_calculated, fee_calculated),
             comments_for_award_letter =
                 NVL (pi_comments_for_award_letter, comments_for_award_letter),
             award_letter_duplicate =
                       NVL (pi_award_letter_duplicate, award_letter_duplicate),
             non_attendance = NVL (pi_non_attendance, non_attendance),
             date_withdrawn =
                NVL (TO_DATE (pi_date_withdrawn, 'DD-MM-YYYY'),
                     date_withdrawn),
             date_actioned =
                 NVL (TO_DATE (pi_date_actioned, 'DD-MM-YYYY'), date_actioned),
             last_updated_by = NVL (pi_last_updated_by, last_updated_by)
       WHERE learner_application_id = pi_learner_application_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         -- Consider logging the error and then re-raise
         RAISE;
   END update_learner_appl_nvl;

   PROCEDURE update_learner_payment_nvl (
      pi_provider_payment_id   IN   NUMBER,
      pi_transaction_type_id   IN   NUMBER,
      pi_payment_status_id     IN   NUMBER,
      pi_amount                IN   NUMBER,
      pi_last_updated_by       IN   VARCHAR2,
      pi_learner_payment_id    IN   NUMBER
   )
   IS
   /******************************************************************************
      NAME:       UPDATE_LEARNER_PAYMENT_NVL
      PURPOSE:    Dynamically updates the fields of a learner payment.
                  The fields that dont get values at runtime are left with
                  their original values.

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        13/08/2008  Angel Anchev     1. Created this procedure.

   ******************************************************************************/
   BEGIN
      UPDATE learner_payment
         SET provider_payment_id =
                             NVL (pi_provider_payment_id, provider_payment_id),
             transaction_type_id =
                             NVL (pi_transaction_type_id, transaction_type_id),
             payment_status_id = NVL (pi_payment_status_id, payment_status_id),
             amount = NVL (pi_amount, amount),
             last_updated_by = NVL (pi_last_updated_by, last_updated_by)
       WHERE learner_payment_id = pi_learner_payment_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         -- Consider logging the error and then re-raise
         RAISE;
   END update_learner_payment_nvl;

   PROCEDURE insert_prov_stat_hist (
      p_provider_id   IN   provider.provider_id%TYPE
   )
   IS
   BEGIN
      DELETE FROM prov_stat_hist
            WHERE current_provider = p_provider_id;

      COMMIT;

      INSERT INTO prov_stat_hist
         SELECT learner_application_id, session_year, ilarefnum, forename,
                surname, dob, courselevel, coursetype, current_course_year,
                feesawarded, paymentdate, feestatus, applstatus, 
                current_provider, current_session,
                recalculated_fee, difference, payment_deduction_date
           FROM vu_provider_status_report
          WHERE current_provider = p_provider_id;

      COMMIT;
   END insert_prov_stat_hist;

   PROCEDURE update_learning_provider_nvl (
      pi_provider_id                 IN   VARCHAR2,
      pi_provider_name               IN   VARCHAR2,
      pi_provider_house_noname       IN   VARCHAR2,
      pi_provider_addr_l1            IN   VARCHAR2,
      pi_provider_addr_l2            IN   VARCHAR2,
      pi_provider_addr_l3            IN   VARCHAR2,
      pi_provider_addr_l4            IN   VARCHAR2,
      pi_provider_post_code          IN   VARCHAR2,
      pi_provider_tel_no             IN   VARCHAR2,
      pi_provider_fax_no             IN   VARCHAR2,
      pi_bank_sort_code              IN   VARCHAR2,
      pi_bank_account_no             IN   VARCHAR2,
      pi_main_contact_name           IN   VARCHAR2,
      pi_main_contact_position       IN   VARCHAR2,
      pi_main_contact_house_noname   IN   VARCHAR2,
      pi_main_contact_addr_l1        IN   VARCHAR2,
      pi_main_contact_addr_l2        IN   VARCHAR2,
      pi_main_contact_addr_l3        IN   VARCHAR2,
      pi_main_contact_addr_l4        IN   VARCHAR2,
      pi_main_contact_post_code      IN   VARCHAR2,
      pi_main_contact_tel_no         IN   VARCHAR2,
      pi_main_contact_fax_no         IN   VARCHAR2,
      pi_main_contact_email          IN   VARCHAR2,
      pi_fin_contact_name            IN   VARCHAR2,
      pi_fin_contact_position        IN   VARCHAR2,
      pi_fin_contact_house_noname    IN   VARCHAR2,
      pi_fin_contact_addr_l1         IN   VARCHAR2,
      pi_fin_contact_addr_l2         IN   VARCHAR2,
      pi_fin_contact_addr_l3         IN   VARCHAR2,
      pi_fin_contact_addr_l4         IN   VARCHAR2,
      pi_fin_contact_post_code       IN   VARCHAR2,
      pi_fin_contact_tel_no          IN   VARCHAR2,
      pi_fin_contact_fax_no          IN   VARCHAR2,
      pi_fin_contact_email           IN   VARCHAR2,
      pi_suspend_payments            IN   VARCHAR2,
      pi_suspend_letters             IN   VARCHAR2,
      pi_provider_type_id            IN   VARCHAR2,
      pi_provider_status_id          IN   VARCHAR2,
      pi_last_updated_by             IN   VARCHAR2,
      pi_outstanding_balance         IN   NUMBER
   )
   IS
   /******************************************************************************
      NAME:       UPDATE_LEARNING_PROVIDER_NVL
      PURPOSE:    Dynamically updates the fields of a learner payment.
                  The fields that dont get values at runtime are left with
                  their original values.

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        13/08/2008  Angel Anchev     1. Created this procedure.

   ******************************************************************************/
   BEGIN
      UPDATE provider
         SET provider_name = NVL (pi_provider_name, provider_name),
             provider_house_no_or_name =
                     NVL (pi_provider_house_noname, provider_house_no_or_name),
             provider_addr_l1 = NVL (pi_provider_addr_l1, provider_addr_l1),
             provider_addr_l2 = NVL (pi_provider_addr_l2, provider_addr_l2),
             provider_addr_l3 = NVL (pi_provider_addr_l3, provider_addr_l3),
             provider_addr_l4 = NVL (pi_provider_addr_l4, provider_addr_l4),
             provider_post_code =
                               NVL (pi_provider_post_code, provider_post_code),
             provider_tel_no = NVL (pi_provider_tel_no, provider_tel_no),
             provider_fax_no = NVL (pi_provider_fax_no, provider_fax_no),
             bank_sort_code = NVL (pi_bank_sort_code, bank_sort_code),
             bank_account_no = NVL (pi_bank_account_no, bank_account_no),
             main_contact_name = NVL (pi_main_contact_name, main_contact_name),
             main_contact_position =
                         NVL (pi_main_contact_position, main_contact_position),
             main_contact_house_no_or_name =
                NVL (pi_main_contact_house_noname,
                     main_contact_house_no_or_name
                    ),
             main_contact_addr_l1 =
                           NVL (pi_main_contact_addr_l1, main_contact_addr_l1),
             main_contact_addr_l2 =
                           NVL (pi_main_contact_addr_l2, main_contact_addr_l2),
             main_contact_addr_l3 =
                           NVL (pi_main_contact_addr_l3, main_contact_addr_l3),
             main_contact_addr_l4 =
                           NVL (pi_main_contact_addr_l4, main_contact_addr_l4),
             main_contact_post_code =
                       NVL (pi_main_contact_post_code, main_contact_post_code),
             main_contact_tel_no =
                             NVL (pi_main_contact_tel_no, main_contact_tel_no),
             main_contact_fax_no =
                             NVL (pi_main_contact_fax_no, main_contact_fax_no),
             main_contact_email =
                               NVL (pi_main_contact_email, main_contact_email),
             fin_contact_name = NVL (pi_main_contact_name, main_contact_name),
             fin_contact_position =
                           NVL (pi_fin_contact_position, fin_contact_position),
             fin_contact_house_no_or_name =
                NVL (pi_fin_contact_house_noname,
                     fin_contact_house_no_or_name),
             fin_contact_addr_l1 =
                             NVL (pi_fin_contact_addr_l1, fin_contact_addr_l1),
             fin_contact_addr_l2 =
                             NVL (pi_fin_contact_addr_l2, fin_contact_addr_l2),
             fin_contact_addr_l3 =
                             NVL (pi_fin_contact_addr_l3, fin_contact_addr_l3),
             fin_contact_addr_l4 =
                             NVL (pi_fin_contact_addr_l4, fin_contact_addr_l4),
             fin_contact_post_code =
                         NVL (pi_fin_contact_post_code, fin_contact_post_code),
             fin_contact_tel_no =
                               NVL (pi_fin_contact_tel_no, fin_contact_tel_no),
             fin_contact_fax_no =
                               NVL (pi_fin_contact_fax_no, fin_contact_fax_no),
             fin_contact_email = NVL (pi_fin_contact_email, fin_contact_email),
             suspend_payments = NVL (pi_suspend_payments, suspend_payments),
             suspend_letters = NVL (pi_suspend_letters, suspend_letters),
             prov_type_id = NVL (pi_provider_type_id, prov_type_id),
             prov_status_id = NVL (pi_provider_status_id, prov_status_id),
             last_updated_by = NVL (pi_last_updated_by, last_updated_by),
             outstanding_amount =
                              NVL (pi_outstanding_balance, outstanding_amount)
       WHERE provider_id = pi_provider_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         -- Consider logging the error and then re-raise
         RAISE;
   END update_learning_provider_nvl;

   PROCEDURE update_prov_bal (
      p_provider_id   IN   provider.provider_id%TYPE,
      p_amount             NUMBER
   )
   IS
   BEGIN
      UPDATE provider p
         SET p.outstanding_amount = p_amount
       WHERE p.provider_id = p_provider_id;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         email_error (   'update_prov_bal '
                      || 'SQLCODE='
                      || SQLCODE
                      || ' SQL ERROR = '
                      || SQLERRM
                     );
         ROLLBACK;
   END update_prov_bal;
   
/* Formatted on 2009/12/08 14:55 (Formatter Plus v4.8.8) */
   --THIS PROCEDURE WAS ADDED IN ORDER TO RETURN PAYMENTS PAID BEFORE THE CURRENT PAYMENT RUN TO THEIR PREVIOUS CORRECT COURSE_TYPE_ID
    --IF THE COURSE TYPE ID IS NOT FOUND FOR ANY REASON THIS WILL UPDATE THIS TO 0 - ALTHOUGH THIS SHOULD NEVER HAPPEN.   

PROCEDURE update_course_type (p_learner_id IN VARCHAR2)
IS

 --  l_course_type   NUMBER (9) := 0;

   CURSOR c_cursor
   IS
      SELECT b.course_type_id, a.session_year
        FROM course_type b, learner_application a
       WHERE a.course_start_date BETWEEN b.fee_period_start AND b.fee_period_end
         AND a.learner_id = p_learner_id;
         
         v_cursor   c_cursor%ROWTYPE;
BEGIN

   OPEN c_cursor;
   
   LOOP

   FETCH c_cursor
    INTO v_cursor;
    
    EXIT WHEN c_cursor%NOTFOUND;
 
 

   UPDATE learner_application a
      SET a.course_type_id = v_cursor.course_type_id
    WHERE a.learner_id = p_learner_id
    AND a.session_year = v_cursor.session_year;
    
    END LOOP;

   CLOSE c_cursor;

   COMMIT;
   
   
EXCEPTION
   WHEN NO_DATA_FOUND
--MAY OCCUR IF COURSE IS NOT SET UP - X will be returned which is handled in other Function to use default date of 1 AUGUST
   THEN
      UPDATE learner_application a
         SET a.course_type_id = -1
       WHERE a.learner_id = p_learner_id;
       
   COMMIT;
       
   WHEN OTHERS
   THEN
      email_error (   'update_prov_bal '
                   || 'SQLCODE='
                   || SQLCODE
                   || ' SQL ERROR = '
                   || SQLERRM
                  );
      ROLLBACK;
      
END update_course_type;
   
   
   /******************************************************************************
      NAME:       INSERT_LEARNER_APPL
      PURPOSE:    Saves the application data in learner_appliation table.

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        13/08/2008  Angel Anchev     1. Created this procedure.
      1.1        18/11/2008  Angel Anchev     Procedure amended to handle the 
                                              format of date fields in the PL/SQL 
                                              rather than rely on JDBC adapter 
                                              to do that, as the different date
                                              formats on the database on the different
                                              environments cause problems with the 
                                              internal JDBC adapter conversion
   ******************************************************************************/   
   PROCEDURE insert_learner_appl(
      pi_learner_id                   IN VARCHAR2,
      pi_course_id                    IN VARCHAR2,
      pi_course_type_id               IN VARCHAR2,
      pi_provider_id                  IN VARCHAR2,
      pi_application_status_id        IN VARCHAR2,
      pi_rejection_id                 IN VARCHAR2,
      pi_total_annual_income          IN VARCHAR2,
      pi_tot_ann_inc_evid_id          IN VARCHAR2,
      pi_no_income                    IN VARCHAR2,
      pi_no_income_evid_id            IN VARCHAR2,
      pi_job_seekers_allowance        IN VARCHAR2,
      pi_jsa_evid_id                  IN VARCHAR2,
      pi_income_support               IN VARCHAR2,
      pi_inc_sup_evid_id              IN VARCHAR2,
      pi_incapacity_benefit           IN VARCHAR2,
      pi_inc_ben_evid_id              IN VARCHAR2,
      pi_carers_allowance             IN VARCHAR2,
      pi_carers_allowance_evid_id     IN VARCHAR2,
      pi_pension_credit               IN VARCHAR2,
      pi_pension_credit_evid_id       IN VARCHAR2,
      pi_mct                          IN VARCHAR2,
      pi_mct_evid_id                  IN VARCHAR2,
      pi_session_year                 IN VARCHAR2,
      pi_date_app_recd                IN VARCHAR2,
      pi_date_record_created          IN VARCHAR2,
      pi_date_of_last_calc            IN VARCHAR2,
      pi_course_title                 IN VARCHAR2,
      pi_course_start_date            IN VARCHAR2,
      pi_length_of_course             IN VARCHAR2,
      pi_current_course_year          IN VARCHAR2,
      pi_course_end_date              IN VARCHAR2,
      pi_help_with_fees               IN VARCHAR2,
      pi_help_amount                  IN VARCHAR2,
      pi_fee_requested                IN VARCHAR2,
      pi_provider_signature_present   IN VARCHAR2,
      pi_endorsed_by                  IN VARCHAR2,
      pi_date_endorsed                IN VARCHAR2,
      pi_stamped                      IN VARCHAR2,
      pi_learner_signature_present    IN VARCHAR2,
      pi_date_signed                  IN VARCHAR2,
      pi_fee_paid_bacs                IN VARCHAR2,
      pi_payment_date                 IN VARCHAR2,
      pi_recover_fees                 IN VARCHAR2,
      pi_debt_status                  IN VARCHAR2,
      pi_fee_calculated               IN VARCHAR2,
      pi_comments_for_award_letter    IN VARCHAR2,
      pi_award_letter_duplicate       IN VARCHAR2,
      pi_non_attendance               IN VARCHAR2,
      pi_date_withdrawn               IN VARCHAR2,
      pi_date_actioned                IN VARCHAR2,
      pi_last_updated_by              IN VARCHAR2,
      po_learner_application_id       OUT learner_application.learner_application_id%TYPE
   )
   IS
   sqlstring    varchar2(2024) := '';
   BEGIN
   INSERT INTO learner_application
         (learner_id, course_id, course_type_id, provider_id, application_status_id, 
          rejection_id, total_annual_income, tot_ann_inc_evid_id, no_income, 
          no_income_evid_id, job_seekers_allowance, jsa_evid_id, income_support, 
          inc_sup_evid_id, incapacity_benefit, inc_ben_evid_id, carers_allowance, 
          carers_allowance_evid_id, pension_credit, pension_credit_evid_id, 
          max_child_tax_credit, max_child_tax_credit_evid_id, session_year, 
          date_app_recd, date_record_created, date_of_last_calc, course_title, 
          course_start_date, length_of_course, current_course_year, 
          course_end_date, help_with_fees, help_amount, provider_signature_present, 
          fee_requested, endorsed_by, date_endorsed, stamped, learner_signature_present, 
          date_signed, fee_paid_bacs, payment_date, recover_fees, debt_status, 
          fee_calculated, comments_for_award_letter, award_letter_duplicate, 
          non_attendance, date_withdrawn, date_actioned, last_updated_by)
   VALUES (pi_learner_id, pi_course_id, pi_course_type_id, pi_provider_id, 
          pi_application_status_id, pi_rejection_id, pi_total_annual_income, 
          pi_tot_ann_inc_evid_id, pi_no_income, pi_no_income_evid_id, 
          pi_job_seekers_allowance, pi_jsa_evid_id, pi_income_support, 
          pi_inc_sup_evid_id, pi_incapacity_benefit, pi_inc_ben_evid_id, 
          pi_carers_allowance, pi_carers_allowance_evid_id, pi_pension_credit,
          pi_pension_credit_evid_id, pi_mct, pi_mct_evid_id, pi_session_year, 
          to_date(pi_date_app_recd, 'DD-MM-YYYY'), to_date(pi_date_record_created, 'DD-MM-YYYY'), 
          to_date(pi_date_of_last_calc, 'DD-MM-YYYY'), pi_course_title, 
          to_date(pi_course_start_date, 'DD-MM-YYYY'), pi_length_of_course, 
          pi_current_course_year, to_date(pi_course_end_date, 'DD-MM-YYYY'), 
          pi_help_with_fees, pi_help_amount, pi_provider_signature_present, 
          pi_fee_requested, pi_endorsed_by, to_date(pi_date_endorsed, 'DD-MM-YYYY'), 
          pi_stamped, pi_learner_signature_present, to_date(pi_date_signed, 'DD-MM-YYYY'), 
          pi_fee_paid_bacs, to_date(pi_payment_date, 'DD-MM-YYYY'), pi_recover_fees, pi_debt_status, 
          pi_fee_calculated, pi_comments_for_award_letter, pi_award_letter_duplicate, 
          pi_non_attendance, to_date(pi_date_withdrawn, 'DD-MM-YYYY'), 
          to_date(pi_date_actioned, 'DD-MM-YYYY'), pi_last_updated_by)
   RETURNING learner_application_id INTO po_learner_application_id;
  
   EXCEPTION
      WHEN OTHERS
      THEN
         email_error (   'insert learner application'
                      || 'SQLCODE='
                      || 'SQLSTRING = ' || sqlstring || ' '
                      || SQLCODE
                      || ' SQL ERROR = '
                      || SQLERRM
                     );
         RAISE;
   END;

   FUNCTION get_current_session RETURN NUMBER
   IS
   /******************************************************************************
      NAME:       GET_CURRENT_SESSION
      PURPOSE:    Returns the current ILA500 session. The current session is 
                  configurable in the table ILA500_CONFIG_DATA under the key
                  CURRENT_SESSION.

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        09/06/20089 Angel Anchev     1. Created the procedure.

   ******************************************************************************/
      v_return_val   VARCHAR2 (4) := NULL;

      CURSOR curr_session
      IS
         SELECT c.cval AS value
           FROM ILA500_CONFIG_DATA c
          WHERE c.item_name = 'CURRENT_SESSION';
   BEGIN
   
      OPEN curr_session;
      FETCH curr_session INTO v_return_val;
      IF curr_session%NOTFOUND 
      THEN
          RAISE NO_DATA_FOUND;
      END IF;
      CLOSE curr_session;
      
      RETURN v_return_val;

   EXCEPTION      
      WHEN NO_DATA_FOUND 
      THEN
         email_error (   'get_current_session '
                      || 'SQLCODE='
                      || SQLCODE
                      || ' SQL ERROR = '
                      || 'Current session is not configured!'
                     );
         RETURN NULL;
      WHEN OTHERS
      THEN
         email_error (   'get_current_session '
                      || 'SQLCODE='
                      || SQLCODE
                      || ' SQL ERROR = '
                      || SQLERRM
                     );
         RETURN NULL;
   END get_current_session;
END pk_payments;
/