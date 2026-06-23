CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_history
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
   PROCEDURE gethistory (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          history_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
      h_cursor   history_cursor;
   BEGIN
      OPEN h_cursor FOR
         SELECT   rownum as rownumber, to_char(vh.aud_date) as audit_date, vh.session_code as session_code, vh.column_name as column_name, vh.OLD as old_value,
                  vh.NEW as new_value,
                  DECODE (vh.action,
                          'I', 'Insert',
                          'D', 'Delete',
                          'U', 'Update',
                          vh.action
                         ) AS action_performed,
                  vh.username as employee
             FROM vu_history vh
            WHERE vh.stud_ref_no = stud_ref_no_in
         ORDER BY vh.aud_date DESC;

      io_cursor := h_cursor;
      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END gethistory;
   
END pk_steps_ui_history; 
/

