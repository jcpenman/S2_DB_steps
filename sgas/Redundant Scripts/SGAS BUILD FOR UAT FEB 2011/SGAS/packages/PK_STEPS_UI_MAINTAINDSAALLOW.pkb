/* Formatted on 2010/11/02 15:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY sgas.pk_steps_ui_maintaindsaallow
AS
/******************************************************************************
   NAME:       pk_steps_ui_MAINTAINDSAALLOWANCES
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        01/11/2010      PADDY GRACE Created this package.
******************************************************************************/
   PROCEDURE insertnewlimitrecord (
      stud_award_type_id_in   IN              VARCHAR2,
      session_code_in         IN              VARCHAR2,
      employee_in             IN              VARCHAR2,
      stud_rate_id_out        OUT NOCOPY      VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      INSERT INTO stud_rate
                  (stud_award_type_id, session_code, last_updated_by,
                   last_updated_on
                  )
           VALUES (stud_award_type_id_in, session_code_in, employee_in,
                   SYSDATE
                  );

      SELECT stud_rate_id_seq.CURRVAL
        INTO stud_rate_id_out
        FROM DUAL;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertnewlimitrecord;
END pk_steps_ui_maintaindsaallow;
/