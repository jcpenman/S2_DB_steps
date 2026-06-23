CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_stud_pay_returns AS
/******************************************************************************
   NAME:       pk_steps_ui_stud_pay_returns
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03/03/2014  Suresh Sharada   1. Created this package body.
   1.1        09/04/2014  John Wynne       Changed getstudentpaymentsreturns to return 
                                           the payments as newest first    
******************************************************************************/
   TYPE stud_pay_returns_cursor IS REF CURSOR;

   PROCEDURE getstudentpaymentsreturns (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          stud_pay_returns_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );
END pk_steps_ui_stud_pay_returns;
/