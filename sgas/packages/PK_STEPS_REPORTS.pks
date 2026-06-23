CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_REPORTS AS 
/******************************************************************************
   NAME:       NMSB_RULES_PROC
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03.11.2010  Paul Hughes      Created this package body
   1.1        28.03.2011  Paul Hughes      Marked as final live version
   1.2        27.01.2013  Paul Hughes       Fix to live issue of duplicate Rows

******************************************************************************/


--  CURSOR DEFINITIONS
     TYPE fee_status_cursor             IS REF CURSOR;
     TYPE fee_payment_cursor            IS REF CURSOR;
     TYPE stats_cursor                  IS REF CURSOR;
     
FUNCTION getFeePaymentDate (p_stud_crse_year_id IN NUMBER) RETURN DATE;

FUNCTION getFeePaidDate (p_stud_crse_year_id IN NUMBER) RETURN DATE;

FUNCTION getfeesAwarded (p_stud_crse_year_id IN NUMBER) RETURN NUMBER; 

FUNCTION getFeesPayable (p_stud_crse_year_id IN NUMBER) RETURN NUMBER;
     
PROCEDURE getFeeStatusReport2012 (p_inst_code IN CHAR, p_session_code IN NUMBER, p_fee_status IN OUT fee_status_cursor);

PROCEDURE getFeePaymentReport (p_campus_id IN NUMBER, p_fee_payment_date IN VARCHAR2, p_fee_payment IN OUT fee_payment_cursor);

PROCEDURE update_attendance_scheduled;

  PROCEDURE getDailyStats(p_session_code IN NUMBER, p_enter_number_of_days_back IN NUMBER, p_enter_days_back_minus_one IN NUMBER, p_stats_curs OUT stats_cursor);
PROCEDURE getTaskData(p_stats_curs OUT stats_cursor); -- 2nd block of SQL code
PROCEDURE getTeamActivity(p_stats_curs OUT stats_cursor); -- 3rd block of SQL code
PROCEDURE getUserData(p_enter_days_back IN NUMBER, p_stats_curs OUT stats_cursor); -- 4th block of SQL code

END PK_STEPS_REPORTS; 
/
