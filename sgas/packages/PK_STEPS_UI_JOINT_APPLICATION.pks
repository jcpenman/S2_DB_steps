CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_joint_application
AS
/******************************************************************************
   NAME:       pk_steps_ui_JOINT_APPLICATION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        15/11/2010  PADDY GRACE           Created this package.
******************************************************************************/
   TYPE ja_members_cursor IS REF CURSOR;
   TYPE jointassessment_cursor IS REF CURSOR;

   PROCEDURE getjamembers (
      stud_session_id_in   IN              VARCHAR2,
      io_cursor            IN OUT          ja_members_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getjamemberdetails (
      stud_session_id_in   IN              VARCHAR2,
      stud_ref_no_out      OUT NOCOPY      VARCHAR2,
      forename_out         OUT NOCOPY      VARCHAR2,
      surname_out          OUT NOCOPY      VARCHAR2,
      dob_out              OUT NOCOPY      DATE,
      sex_out              OUT NOCOPY      VARCHAR2,
      ja_stud_type_out     OUT NOCOPY      VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getstudsessionjadetails (
      stud_session_id_in   IN              VARCHAR2,
      ja_case_out          OUT NOCOPY      VARCHAR2,
      ja_case_id_out       OUT NOCOPY      VARCHAR2,
      ja_stud_type_out     OUT NOCOPY      VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setstudsessionjadetails (
      stud_session_id_in   IN              VARCHAR2,
      ja_case_in           IN              VARCHAR2,
      ja_case_id_in        IN              VARCHAR2,
      ja_stud_type_in      IN              VARCHAR2,
      employee_in          IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getjacase (
      ja_case_id_in                  IN              VARCHAR2,
      ja_case_type_out               OUT NOCOPY      VARCHAR2,
      total_saas_supported_out       OUT NOCOPY      VARCHAR2,
      total_non_saas_supported_out   OUT NOCOPY      VARCHAR2,
      all_registered_out             OUT NOCOPY      VARCHAR2,
      error_boolean                  OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                     OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setjacase (
      ja_case_id_in                 IN              VARCHAR2,
      ja_case_type_in               IN              VARCHAR2,
      total_saas_supported_in       IN              VARCHAR2,
      total_non_saas_supported_in   IN              VARCHAR2,
      employee_in                   IN              VARCHAR2,
      error_boolean                 OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                    OUT NOCOPY      VARCHAR2
   );

  PROCEDURE insertjacase (
      session_code_in               IN              VARCHAR2,
      ja_case_type_in               IN              VARCHAR2,
      total_saas_supported_in       IN              VARCHAR2,
      total_non_saas_supported_in   IN              VARCHAR2,
      all_registered_in             IN              VARCHAR2,
      employee_in                   IN              VARCHAR2,
      ja_case_id_out                OUT NOCOPY      VARCHAR2,
      error_boolean                 OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                    OUT NOCOPY      VARCHAR2
   );
   
   PROCEDURE findjacases (
      stud_session_id_in   IN              VARCHAR2,
      io_cursor            IN OUT          jointassessment_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2,
      row_count            OUT NOCOPY      VARCHAR2
   );
END pk_steps_ui_joint_application;
/
