CREATE OR REPLACE PACKAGE SGAS.PK_PAYMENTS AS   
/******************************************************************************
   NAME:       PK_PAYMENTS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/12/2010   Paul Hughes     1. Created this package.
   1.1        18/03/2011   Paul Hughes     2. Tidy of code
   1.2        28/03/2011   Paul Hughes     3. Marked as final live version
   1.3        19/07/2011   Paul Hughes     4. Attendance Data changes
******************************************************************************/

 TYPE fees_cur               IS REF CURSOR;
 TYPE awards_cur             IS REF CURSOR;   
 TYPE adiD_cur               IS REF CURSOR;
 TYPE adiC_cur               IS REF CURSOR;
 

 FUNCTION getCorrespondingPayeeID(p_payee_id IN NUMBER) RETURN NUMBER;
 
 FUNCTION doesPayeePaymentPayeeIDExist(p_payee_id IN NUMBER, p_payment_run_date IN CHAR) RETURN CHAR;
 
 FUNCTION doesCorrespondingPayeeIDExist(p_payee_id IN NUMBER, p_payment_run_date IN CHAR) RETURN CHAR;
 
 FUNCTION getNetAmountDueFee(p_campus_id IN NUMBER) RETURN NUMBER;
 
 FUNCTION getNetAmountDueLoan(p_campus_id IN NUMBER) RETURN NUMBER;
 
 FUNCTION getSuspenseDebtToCreditAccount(p_payment_run_date IN CHAR) RETURN NUMBER;
 
 FUNCTION GETPAYEECREDITS(p_payment_run_date IN CHAR, p_type IN CHAR) RETURN NUMBER;
 
 FUNCTION getPaymentNumber (p_award_instalment_id IN NUMBER, p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
 
 FUNCTION countvariationAwards (p_days_ahead_bacs IN NUMBER, p_days_ahead_cheque IN NUMBER) RETURN NUMBER;
 
 FUNCTION countAwardPayments (p_days_ahead_bacs IN NUMBER, p_days_ahead_cheque IN NUMBER) RETURN NUMBER;
 
 FUNCTION countvariationFees (p_pay_due_days_ahead IN NUMBER) RETURN NUMBER;
 
 FUNCTION countFeePayments (p_pay_due_days_ahead IN NUMBER) RETURN NUMBER;
 
 FUNCTION checkNumberOfPaidAwards (p_award_instalment_id IN NUMBER) RETURN NUMBER;
 
 FUNCTION get_AD_NURSING_Flag(p_stud_crse_year_id IN NUMBER) RETURN CHAR;
 
 FUNCTION getCostCentre (award_instalment_id_in IN NUMBER, stud_award_type_in IN VARCHAR2) RETURN VARCHAR2;
 
 FUNCTION getAccountName (award_instalment_id_in IN NUMBER, stud_award_type_in IN VARCHAR2) RETURN VARCHAR2;
 
 FUNCTION getProgramme (award_instalment_id_in IN NUMBER, stud_award_type_in IN VARCHAR2) RETURN VARCHAR2;
  
 FUNCTION getAwardInstalmentID(p_i_id IN NUMBER, p_p_id IN NUMBER) RETURN NUMBER;
  
 PROCEDURE SELECT_FEE_INSTALMENTS (p_pay_due_days_ahead IN NUMBER, p_fees_paymenttype IN OUT fees_cur);
 
 PROCEDURE aggregate_paymentsFees    (p_payment_run_date IN VARCHAR2, ERROR_TEXT          OUT NOCOPY      VARCHAR2);
 
 PROCEDURE aggregate_payments    (p_payment_run_date IN VARCHAR2, ERROR_TEXT          OUT NOCOPY      VARCHAR2);
 
  PROCEDURE aggregate_returns    (p_payment_run_date IN VARCHAR2, ERROR_TEXT          OUT NOCOPY      VARCHAR2);
 
 PROCEDURE SELECT_AWARD_PAYMENTS (p_days_ahead_bacs IN NUMBER, p_days_ahead_cheque IN NUMBER, p_awards_paymenttype IN OUT awards_cur);
 
 FUNCTION checkBatchExists(p_payment_date IN VARCHAR2, 
                            p_method IN VARCHAR2, p_payee IN VARCHAR2, p_max_batch_payments IN NUMBER) RETURN VARCHAR2;
                            
 PROCEDURE aggregate_returns_UI     (p_returns_batch IN VARCHAR2, p_batch_count IN NUMBER, p_total_returns IN NUMBER, p_year IN NUMBER, p_period IN NUMBER,  ERROR_TEXT          OUT NOCOPY      VARCHAR2);

END PK_PAYMENTS;
/