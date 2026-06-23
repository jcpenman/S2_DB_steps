CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_AWARD_LETTER AS
/******************************************************************************
   NAME:       PK_STEPS_AWARD_LETTER 
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/01/2013   Paul Hughes     New Award Letter - 2013 Base
******************************************************************************/


 --  CURSOR DEFINITIONS
  TYPE an_students_cursor             IS REF CURSOR;
  TYPE an_stud_awards_cursor          IS REF CURSOR;
  TYPE an_award_payments_cursor       IS REF CURSOR;

  
  FUNCTION get_stud_fees_saas(p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  
  FUNCTION get_stud_fees_nmsb(p_stud_crse_year_id IN NUMBER) RETURN NUMBER; 
  
  FUNCTION get_stud_fees_stud(p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  
  FUNCTION get_stud_loan_for_fees(p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  
  FUNCTION get_stud_loan_amount(p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  
  FUNCTION fee_records_exist(p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  
  FUNCTION get_stud_total(p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  
  FUNCTION getOverPaymentRecordedAmount(p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  
  FUNCTION get_stud_ssnPrint(p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  
  FUNCTION show_award_instalments(p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  
  FUNCTION getPAMSOutsideScotland(p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  
  FUNCTION build_pay_location_string(
    p_method        IN VARCHAR2, 
    p_payee_type    IN VARCHAR2, 
    p_acc_no        IN VARCHAR2, 
    p_sort_code     IN VARCHAR2,
    p_build_soc_no  IN VARCHAR2,
    p_pay_addr      IN VARCHAR2,
    p_pay_status    IN VARCHAR2,
    p_returned      IN VARCHAR2,
    p_recalc        IN VARCHAR2,
    p_campus        IN VARCHAR2) RETURN VARCHAR2;
    
  FUNCTION get_remark1 (p_stud_crse_year_id NUMBER) RETURN CHAR;
  
  FUNCTION get_remark2 (p_stud_crse_year_id NUMBER) RETURN CHAR;
  
  FUNCTION remark2_prev_session_exist(p_stud_crse_year_id IN NUMBER)RETURN CHAR;
  
  FUNCTION get_remark8(p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  
  FUNCTION get_remark9 (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  
  FUNCTION get_rem13Value (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  
  FUNCTION getRemarkTwoNumber (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  
  FUNCTION get_inst_location (p_stud_crse_year_id IN NUMBER) RETURN VARCHAR2;
    
  PROCEDURE get_an_student_data(p_students OUT an_students_cursor);
  
  PROCEDURE get_an_award_data(p_stud_crse_year_id IN VARCHAR2, p_stud_awards OUT an_stud_awards_cursor);

  PROCEDURE get_an_award_payments(p_stud_crse_year_id IN VARCHAR2, p_award_payments OUT an_award_payments_cursor);
  
  PROCEDURE set_an_sent(p_stud_crse_year_id IN VARCHAR2);
  
  PROCEDURE set_an_dup_req(p_stud_crse_year_id IN VARCHAR2);
  
  PROCEDURE set_an_dup_sent(p_stud_crse_year_id IN VARCHAR2);
  
  STEPS_RELEASE_YEAR        CONSTANT NUMBER := 2011;
  
END PK_STEPS_AWARD_LETTER;
/
