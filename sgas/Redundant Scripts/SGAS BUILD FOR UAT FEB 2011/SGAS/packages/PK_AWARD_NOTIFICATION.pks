CREATE OR REPLACE PACKAGE SGAS.PK_AWARD_NOTIFICATION AS
/******************************************************************************
   NAME:       PK_AWARD_NOTIFICATION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        14/08/2009  A.Anchev         1. Created this package
   1.1        23/10/2009  P.Hughes         2. New Function get_loan_for_living_costs   
   1.2        28/10/2009  P.Hughes         3. New Functions get_parentspouse_contrib and get_stud_ssnPrint
   1.3        10/11/2009  P.Hughes         4. Multiple new functions
   1.4        15/11/2009  P.Hughes         5. Rem13 Function Added
   1.5        12/10/2010  J.Penman         6. Updated STEPS_RELEASE_YEAR from 2009 to 2010
******************************************************************************/


 --  CURSOR DEFINITIONS
  TYPE an_students_cursor             IS REF CURSOR;
  TYPE an_stud_awards_cursor          IS REF CURSOR;
  TYPE an_award_payments_cursor       IS REF CURSOR;
  TYPE an_remark_flags_cursor         IS REF CURSOR;
  
  FUNCTION get_stud_fees_saas(p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  
  FUNCTION get_remark (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  
  FUNCTION show_fees_saas_ruk(p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  
  FUNCTION get_stud_fees_stud(p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  
  FUNCTION get_stud_loan_for_fees(p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  
  FUNCTION get_stud_loan_amount(p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  
  FUNCTION get_stud_fees_studBE(p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  
  FUNCTION get_stud_loan_displayzero(p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  
  FUNCTION get_stud_total(p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  
  FUNCTION get_loan_for_living_costs(p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
  
  FUNCTION get_stud_ssnPrint(p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  
  FUNCTION get_parentspouse_contib(p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  
  FUNCTION show_award_instalments(p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  
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
  
  FUNCTION get_remark8(p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  
  FUNCTION get_remark9 (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  
  FUNCTION get_remark13 (p_stud_crse_year_id IN NUMBER) RETURN CHAR;
  
  FUNCTION get_rem13Value (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
    
  FUNCTION get_student_contibution(p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
    
  PROCEDURE get_an_student_data(p_students OUT an_students_cursor);
  
  PROCEDURE get_an_award_data(p_stud_crse_year_id IN VARCHAR2, p_stud_awards OUT an_stud_awards_cursor);

  PROCEDURE get_an_award_payments(p_stud_crse_year_id IN VARCHAR2, p_award_payments OUT an_award_payments_cursor);
  
  PROCEDURE set_an_sent(p_stud_crse_year_id IN VARCHAR2);
  
  PROCEDURE set_an_dup_req(p_stud_crse_year_id IN VARCHAR2);
  
  PROCEDURE set_an_dup_sent(p_stud_crse_year_id IN VARCHAR2);
  
  STEPS_RELEASE_YEAR        CONSTANT NUMBER := 2010;
  
END PK_AWARD_NOTIFICATION;
/
