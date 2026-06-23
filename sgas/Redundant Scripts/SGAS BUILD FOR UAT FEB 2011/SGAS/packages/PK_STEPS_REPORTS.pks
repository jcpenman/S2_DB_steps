CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_REPORTS AS
/******************************************************************************
   NAME:       NMSB_RULES_PROC
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03.11.2010  Paul Hughes      Created this package body

******************************************************************************/


--  CURSOR DEFINITIONS
     TYPE fee_status_cursor             IS REF CURSOR;
     TYPE fee_payment_cursor            IS REF CURSOR;
     
     
 
PROCEDURE getFeeStatusReport (p_inst_code IN CHAR, p_session_code IN NUMBER, p_fee_status IN OUT fee_status_cursor);

PROCEDURE getFeePaymentReport (p_campus_id IN NUMBER, p_fee_payment_date IN VARCHAR2, p_fee_payment IN OUT fee_payment_cursor);

END PK_STEPS_REPORTS;
/
