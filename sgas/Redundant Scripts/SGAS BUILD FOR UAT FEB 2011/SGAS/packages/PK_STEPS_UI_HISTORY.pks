CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_history
AS
/******************************************************************************
   NAME:       pk_steps_ui_HISTORY
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008      PADDY GRACE  Created this package.
   1.1        28/08/2009      PADDY GRACE  Added procedure
******************************************************************************/
   TYPE history_cursor IS REF CURSOR;

   PROCEDURE gethistory (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          history_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );
END pk_steps_ui_history; 
/

