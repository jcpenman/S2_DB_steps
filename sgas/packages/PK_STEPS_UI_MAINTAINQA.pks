/* Formatted on 2012/02/20 16:27 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_ui_maintainqa
AS
/******************************************************************************
   NAME:       pk_steps_ui_MAINTAINQA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008      PADDY GRACE Created this package.
******************************************************************************/
   TYPE qausers_cursor IS REF CURSOR;

   TYPE qauser_cursor IS REF CURSOR;

   PROCEDURE getqausers (
      io_cursor       IN OUT          qausers_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getqauser (
      username_in           IN              VARCHAR2,
      qa_type_out           OUT             VARCHAR2,
      qa_level_out          OUT             VARCHAR2,
      no_processed_out      OUT             VARCHAR2,
      no_qa_out             OUT             VARCHAR2,
      no_fail_qa_out        OUT             VARCHAR2,
      last_updated_by_out   OUT             VARCHAR2,
      last_updated_on_out   OUT             VARCHAR2,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setqauser (
      username_in          IN              VARCHAR2,
      last_updated_by_in   IN              VARCHAR2,
      qa_level_in          IN              NUMBER,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2,
      row_count            OUT             NUMBER
   );
END pk_steps_ui_maintainqa;
/