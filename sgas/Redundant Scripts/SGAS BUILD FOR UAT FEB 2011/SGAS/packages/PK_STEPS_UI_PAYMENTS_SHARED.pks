/* Formatted on 2010/11/09 17:20 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_ui_payments_shared
AS
/******************************************************************************
   NAME:       pk_steps_ui_PAYMENTS_SHARED
   PURPOSE:

   REVISIONS:
   Ver        Date          Author                  Description
   ---------  ----------    ---------------         ------------------------------------
   1.0        04/10/2010    PADDY GRACE             Created this package.
******************************************************************************/
   TYPE sat_cursor IS REF CURSOR;
   TYPE pd_cursor IS REF CURSOR;

   PROCEDURE getstudentsawardtypes (
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   sat_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   PROCEDURE getpaymentdates (
      session_code_in   IN       VARCHAR2,
      io_cursor         IN OUT   pd_cursor,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   );
END pk_steps_ui_payments_shared;
/