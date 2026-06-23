/* Formatted on 2011/12/12 17:13 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_ui_student_payments
AS
/******************************************************************************
   NAME:       pk_steps_ui_SUMMARY
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/12/2011  PADDY GRACE      Created this package.
******************************************************************************/
   TYPE student_payments_cursor IS REF CURSOR;

   PROCEDURE getstudentpayments (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          student_payments_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );
END pk_steps_ui_student_payments;
/