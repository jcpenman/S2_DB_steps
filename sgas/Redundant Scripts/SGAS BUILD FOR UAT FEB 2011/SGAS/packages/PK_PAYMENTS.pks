CREATE OR REPLACE PACKAGE SGAS.PK_PAYMENTS AS
/******************************************************************************
   NAME:       PK_PAYMENTS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/12/2010   Paul Hughes     1. Created this package.
******************************************************************************/

 TYPE fees_cur               IS REF CURSOR;
 TYPE awards_cur             IS REF CURSOR;   
 TYPE adiD_cur               IS REF CURSOR;
 TYPE adiC_cur               IS REF CURSOR;
 
 
 FUNCTION getPaymentNumber (p_award_instalment_id IN NUMBER, p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER;
 
 FUNCTION countvariationAwards (p_days_ahead_bacs IN NUMBER, p_days_ahead_cheque IN NUMBER) RETURN NUMBER;
 
 FUNCTION countAwardPayments (p_days_ahead_bacs IN NUMBER, p_days_ahead_cheque IN NUMBER) RETURN NUMBER;
 
 FUNCTION countvariationFees (p_pay_due_days_ahead IN NUMBER) RETURN NUMBER;
 
 FUNCTION countFeePayments (p_pay_due_days_ahead IN NUMBER) RETURN NUMBER;
 
 FUNCTION checkNumberOfPaidAwards (p_award_instalment_id IN NUMBER) RETURN NUMBER;
  
 --PROCEDURE getADIJournalDebits (p_creation_date IN VARCHAR2, p_adiJournalDebits IN OUT   adiD_cur);
 
 --PROCEDURE getADIJournalCredits (p_creation_date IN VARCHAR2, p_adiJournalCredits IN OUT   adiC_cur);
  
 PROCEDURE SELECT_FEE_INSTALMENTS (p_pay_due_days_ahead IN NUMBER, p_fees_paymenttype IN OUT fees_cur);
 
 PROCEDURE aggregate_payments    (ERROR_TEXT          OUT NOCOPY      VARCHAR2);
 
 PROCEDURE SELECT_AWARD_PAYMENTS (p_days_ahead_bacs IN NUMBER, p_days_ahead_cheque IN NUMBER, p_awards_paymenttype IN OUT awards_cur);
 
 FUNCTION checkBatchExists(p_payment_date IN VARCHAR2, 
                            p_method IN VARCHAR2, p_payee IN VARCHAR2, p_max_batch_payments IN NUMBER) RETURN VARCHAR2;

END PK_PAYMENTS;
/
