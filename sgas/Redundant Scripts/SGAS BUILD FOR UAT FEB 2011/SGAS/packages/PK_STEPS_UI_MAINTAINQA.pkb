create or replace PACKAGE BODY      pk_steps_ui_maintainqa
AS
/******************************************************************************
   NAME:       pk_steps_ui_MAINTAINQA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008      PADDY GRACE Created this package.
******************************************************************************/
PROCEDURE getqausers (
      io_cursor       IN OUT          qausers_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   IS
      qa_cursor   qausers_cursor;
   BEGIN
      OPEN qa_cursor FOR
         SELECT   qa.username, qa.qa_type, qa.qa_level, qa.no_processed,
                  qa.no_qa, qa.no_fail_qa, qa.last_updated_by,
                  TO_CHAR
                         (TO_DATE (qa.last_updated_on,
                                   'DD-MM-YYYY HH12:MI:SS')
                         ) AS last_updated_on
             FROM steps_qa_data qa
         ORDER BY qa.username DESC;

      error_boolean := 'false';
      error_text := 'none';
      io_cursor := qa_cursor;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getqausers;

   PROCEDURE setqauser (
      username_in          IN              VARCHAR2,
      last_updated_by_in   IN              VARCHAR2,
      qa_level_in          IN              NUMBER,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2,
      row_count            OUT             NUMBER
   )
   AS
   BEGIN
      UPDATE steps_qa_data qa
         SET qa.qa_level = NVL (qa_level_in, qa.qa_level),
             qa.last_updated_by =
                          NVL (UPPER (last_updated_by_in), qa.last_updated_by),
             qa.last_updated_on = SYSDATE,
             qa.no_processed =
                         DECODE (qa.qa_level,
                                 qa_level_in, qa.no_processed,
                                 0
                                ),
             qa.no_qa = DECODE (qa.qa_level, qa_level_in, qa.no_qa, 0),
             qa.no_fail_qa =
                           DECODE (qa.qa_level,
                                   qa_level_in, qa.no_fail_qa,
                                   0
                                  )
       WHERE UPPER (qa.username) = UPPER (username_in);

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         row_count := 0;
   END setqauser;
   
   PROCEDURE getselectedqausers (
      username_in        IN              VARCHAR2,
      io_cursor       IN OUT          qaselectedusers_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )   
   IS
      qa_cursor   qaselectedusers_cursor;
   BEGIN
      OPEN qa_cursor FOR
         SELECT   qa.username, qa.qa_type, qa.qa_level, qa.no_processed,
                  qa.no_qa, qa.no_fail_qa, qa.last_updated_by,
                  TO_CHAR
                         (TO_DATE (qa.last_updated_on,
                                   'DD-MM-YYYY HH12:MI:SS')
                         ) AS last_updated_on
             FROM steps_qa_data qa
             WHERE upper(qa.username) like upper('%'||username_in||'%')
         ORDER BY qa.username DESC;

      error_boolean := 'false';
      error_text := 'none';
      io_cursor := qa_cursor;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getselectedqausers;   
   
END pk_steps_ui_maintainqa; 
