CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_casenotes
AS
/******************************************************************************
   NAME:       pk_steps_ui_CASENOTES
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        17/11/2008      PADDY GRACE           Created this package.
   1.1        28/12/2008     ABIRAMI CHIDAMBARAM   Code Population
******************************************************************************/
TYPE caseworkernote_cursor IS REF CURSOR;
PROCEDURE getcaseworkernotes (
      stud_ref_no_in         IN              NUMBER,
      io_cursor              IN OUT          caseworkernote_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );
   
   PROCEDURE getproblemcase (
      stud_ref_no_in         IN              NUMBER,
      problem_case_out       OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

  PROCEDURE setcaseworkernotes (
      id_in                     IN       NUMBER,
      stud_ref_no_in            IN       NUMBER,
      session_code_in           IN       NUMBER,
      emp_login_name_in         IN       VARCHAR2,
      notes_type_in             IN       VARCHAR2,
      notes_text_in             IN       VARCHAR2,
      user_in                   IN       VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2,
      row_count_sn              OUT      VARCHAR2
   );
   
   PROCEDURE setproblemcase (
      stud_ref_no_in            IN       NUMBER,
      problem_case_in           IN       VARCHAR2,
      user_in                   IN       VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2,
      row_count_s               OUT      VARCHAR2
   );
   
   PROCEDURE insertcaseworkernotes (
      stud_ref_no_in            IN       NUMBER,
      session_code_in           IN       NUMBER,
      emp_login_name_in         IN       VARCHAR2,
      notes_type_in             IN       VARCHAR2,
      notes_text_in             IN       VARCHAR2,
      user_in                   IN       VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2,
      row_count                 OUT      VARCHAR2
   );
   
 PROCEDURE deletecaseworkernotes (
      id_in                  IN             NUMBER,
      user_in                IN             VARCHAR2,
      error_boolean          OUT NOCOPY     VARCHAR2,
      ERROR_TEXT             OUT NOCOPY     VARCHAR2,
      row_count              OUT            VARCHAR2
   );
END pk_steps_ui_casenotes;
/
