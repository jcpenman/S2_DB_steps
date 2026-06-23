CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_messages
AS
/******************************************************************************
   NAME:       pk_steps_ui_messages
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0       17/12/2014  SURESH SHARADA            Created this package.
 ******************************************************************************/
   PROCEDURE getstudentmessages (
      stud_ref_no_in   IN              NUMBER,
      io_cursor        IN OUT          messages_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
      msg_cursor   messages_cursor;
   BEGIN
      OPEN msg_cursor FOR
         SELECT sm.stud_msg_id AS stud_msg_id_out, 
                sm.stud_ref_no AS stud_ref_no_out,
                sm.created_by AS created_by_out,
                sm.message_text AS message_text_out, 
                TO_CHAR (sm.display_from, 'DD/MM/yyyy') AS display_from_out,
                TO_CHAR (sm.display_to, 'DD/MM/yyyy') AS display_to_out,
                sm.subject,
                sms.description
          FROM stud_message sm, student_message_subject sms
          WHERE sm.stud_ref_no = stud_ref_no_in AND SM.SUBJECT=SMS.STUDENT_MESSAGE_SUBJECT_ID
          ORDER BY sm.display_from DESC;

      io_cursor := msg_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstudentmessages;

   PROCEDURE updatestudentmessage (
      stud_msg_id_in    IN       NUMBER,
      stud_ref_no_in    IN       NUMBER,
      user_in           IN       VARCHAR2,
      display_to_in     IN       DATE,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE stud_message
         SET created_by = UPPER (user_in),
             display_to = display_to_in 
             
       WHERE stud_ref_no = stud_ref_no_in AND stud_msg_id = stud_msg_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updatestudentmessage;

   PROCEDURE insertstudentmessage (
      stud_ref_no_in                IN       NUMBER,
      message_text_in               IN       VARCHAR2,
      user_in                       IN       VARCHAR2,
      display_to_in                 IN       DATE,
      subject_in                    IN       VARCHAR2,
      error_boolean                 OUT      VARCHAR2,
      ERROR_TEXT                    OUT      VARCHAR2
   )
   AS
   BEGIN
      INSERT INTO stud_message
                  (STUD_REF_NO, CREATED_BY, 
                  MESSAGE_TEXT, DISPLAY_FROM, DISPLAY_TO,SUBJECT)
           VALUES (stud_ref_no_in, user_in,
                   message_text_in, SYSDATE, display_to_in,subject_in
                  );

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertstudentmessage;
   
END pk_steps_ui_messages;
/