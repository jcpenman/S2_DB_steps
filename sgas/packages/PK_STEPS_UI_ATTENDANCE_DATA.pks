/* Formatted on 2012/06/27 11:11 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_ui_attendance_data
AS
/******************************************************************************
   NAME:       PK_STEPS_UI_ATTENDANCE_DATA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        27/06/2012      PADDY GRACE Created this package.
******************************************************************************/
   PROCEDURE override_attendance_data (
      stud_crse_year_id_in   IN              VARCHAR2,
      user_id                IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );
END pk_steps_ui_attendance_data;
/