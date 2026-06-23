CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_travel
AS
/******************************************************************************
   NAME:       pk_steps_ui_TRAVEL
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008      PADDY GRACE Created this package.
******************************************************************************/
   PROCEDURE dummy_procedure (
      error_boolean   OUT NOCOPY   VARCHAR2,
      ERROR_TEXT      OUT NOCOPY   VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END dummy_procedure;
END pk_steps_ui_travel; 
/

