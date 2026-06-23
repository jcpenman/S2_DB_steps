CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_familystudents
AS
/******************************************************************************
   NAME:       pk_steps_ui_familystudents
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/12/2012  PADDY GRACE      Created this package.
******************************************************************************/
   TYPE familystudents_cursor IS REF CURSOR;

   PROCEDURE getfamilystudents (
      stud_session_id_in   IN              VARCHAR2,
      io_cursor            IN OUT          familystudents_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );
END pk_steps_ui_familystudents;
/