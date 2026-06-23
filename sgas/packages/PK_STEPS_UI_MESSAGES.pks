CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_messages
AS
/******************************************************************************
   NAME:       pk_steps_ui_messages
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   --------- ----------  ---------------           ------------------------------------
   1.0       17/12/2014   SURESH SHARADA            Created this package.
   
******************************************************************************/
   TYPE messages_cursor IS REF CURSOR;

   PROCEDURE getstudentmessages (
      stud_ref_no_in   IN              NUMBER,
      io_cursor        IN OUT          messages_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE updatestudentmessage (
      stud_msg_id_in    IN       NUMBER,
      stud_ref_no_in    IN       NUMBER,
      user_in           IN       VARCHAR2,
      display_to_in     IN       DATE,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   );

   PROCEDURE insertstudentmessage (
      stud_ref_no_in                IN       NUMBER,
      message_text_in               IN       VARCHAR2,
      user_in                       IN       VARCHAR2,
      display_to_in                 IN       DATE,
      subject_in                    IN       VARCHAR2,
      error_boolean                 OUT      VARCHAR2,
      ERROR_TEXT                    OUT      VARCHAR2
   );
   
END pk_steps_ui_messages;
/