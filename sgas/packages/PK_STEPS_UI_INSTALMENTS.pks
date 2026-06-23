CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_instalments
AS
/******************************************************************************
   NAME:       pk_steps_ui_INSTALMENTS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008      PADDY GRACE Created this package.
   1.1        18/11/2008      MIKE TOLMIE Code Population.
   1.2        07/03/2013      JOHN WYNNE  Updated getInstalments to return adhoc type
******************************************************************************/
   TYPE loan_cursor IS REF CURSOR;

   TYPE award_cursor IS REF CURSOR;

   TYPE instalment_cursor IS REF CURSOR;

   PROCEDURE getawards (
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   award_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   PROCEDURE getinstalments (
      award_id_in     IN       VARCHAR2,
      io_cursor       IN OUT   instalment_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getloanawarddetails (
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   loan_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   PROCEDURE getloanawardtotals (
      stud_crse_year_id_in   IN       VARCHAR2,
      description_out        OUT      VARCHAR2,
      amount_out             OUT      VARCHAR2,
      contrib_amount_out     OUT      VARCHAR2,
      unclaimed_loan_out     OUT      VARCHAR2,
      net_amount_out         OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );
END pk_steps_ui_instalments;
/
