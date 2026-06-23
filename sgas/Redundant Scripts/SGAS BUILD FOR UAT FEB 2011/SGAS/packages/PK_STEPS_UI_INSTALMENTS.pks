/* Formatted on 2010/02/03 17:46 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_ui_instalments
AS
/******************************************************************************
   NAME:       pk_steps_ui_INSTALMENTS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008      PADDY GRACE Created this package.
   1.1        18/11/2008      MIKE TOLMIE Code Population.
******************************************************************************/
   TYPE instalment_cursor IS REF CURSOR;

   TYPE loan_cursor IS REF CURSOR;

   PROCEDURE instalments (
      reference_id_in        IN       VARCHAR2,
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   instalment_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   PROCEDURE getloanawarddetails (
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   loan_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );
END pk_steps_ui_instalments;
/