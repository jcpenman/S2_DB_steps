CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_UI_GRASS_SUPP_GRANTS AS
/******************************************************************************
   NAME:       pk_steps_ui_grass_SUPP_GRANTS
   PURPOSE:

   REVISIONS:
   Ver        Date              Author                  Description
   ---------  ----------        ---------------         ------------------------------------
   1.0        28/01/2009      ABIRANI CHIDAMBARAM       Created this package.
******************************************************************************/

PROCEDURE getdependants (
      stud_session_id_in     IN              NUMBER,
      io_cursor              IN OUT          dep_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      d_cursor           dep_cursor;
        BEGIN
        OPEN d_cursor FOR
        SELECT sd.FIRST_NAME as first_name, sd.SURNAME as surname, sd.DOB as dob, DECODE (EMP_STATUS, 'U', 'UNEMPLOYED',
             'D', 'DISABLED', 'S', 'SELF EMPLOYED', 'H', 'HOUSE PERSON', 'E', 'EMPLOYED') as emp_status, 
              c.DESCRIPT as relationship, sd.INCOME as income
        FROM STUD_DEPENDANT @ GRASS sd, CATEGORY @ GRASS c
        WHERE sd.STUD_SESSION_ID = stud_session_id_in
        AND c.TYPE IN ('U', 'H')
        AND sd.RELATION_ID = c.ID;
        
        io_cursor := d_cursor;
        error_boolean := 'false';
        error_text := 'none';
   EXCEPTION
        WHEN OTHERS
        THEN
        error_boolean := 'true';
        ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getdependants; 
   
   PROCEDURE getLPG (
      stud_session_id_in     IN              NUMBER,
      io_cursor              IN OUT          lpg_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      l_cursor           lpg_cursor;
        BEGIN
        OPEN l_cursor FOR
        SELECT sd.FIRST_NAME as first_name, sd.SURNAME as surname, sd.DOB as dob, c.DESCRIPT as relationship
        FROM STUD_DEPENDANT @ GRASS sd, CATEGORY @ GRASS c
        WHERE sd.STUD_SESSION_ID = stud_session_id_in
        AND c.TYPE = 'H'
        AND sd.RELATION_ID = c.ID;

        io_cursor := l_cursor;
        error_boolean := 'false';
        error_text := 'none';

   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getLPG; 
END PK_STEPS_UI_GRASS_SUPP_GRANTS;
/
