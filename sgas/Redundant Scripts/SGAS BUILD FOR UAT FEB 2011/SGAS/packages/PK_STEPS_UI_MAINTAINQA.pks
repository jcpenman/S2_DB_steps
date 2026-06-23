create or replace PACKAGE      pk_steps_ui_maintainqa
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

   TYPE qaselectedusers_cursor IS REF CURSOR;

   PROCEDURE setqauser (
      username_in          IN              VARCHAR2,
      last_updated_by_in   IN              VARCHAR2,
      qa_level_in          IN              NUMBER,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2,
      row_count            OUT             NUMBER
   );

   PROCEDURE getqausers (
      io_cursor       IN OUT          qausers_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getselectedqausers (
      username_in        IN           VARCHAR2,
      io_cursor       IN OUT          qaselectedusers_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

END pk_steps_ui_maintainqa; 

