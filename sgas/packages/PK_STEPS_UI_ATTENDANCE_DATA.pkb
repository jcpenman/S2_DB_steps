CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_attendance_data
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
   )
   IS
      v_enrol_confirmed            VARCHAR2 (1);
      v_ongoing_attend_confirmed   VARCHAR2 (1);
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT ad.enrol_confirmed, ad.ongoing_attendance_confirmed
        INTO v_enrol_confirmed, v_ongoing_attend_confirmed
        FROM attendance_data ad
       WHERE ad.stud_crse_year_id = stud_crse_year_id_in;

      IF v_enrol_confirmed = 'N'
      THEN
         UPDATE attendance_data ad
            SET ad.enrol_confirmed = 'Y',
                ad.enrol_required = 'Y',
                ad.enrol_received_date = SYSDATE,
                ad.enrol_applied_date = SYSDATE,
                ad.enrol_updated_by = UPPER (user_id),
                ad.chngd_since_last_report = 'Y',
                ad.last_updated_by = UPPER (user_id)
          WHERE ad.stud_crse_year_id = stud_crse_year_id_in;
      END IF;

      IF v_ongoing_attend_confirmed = 'N'
      THEN
         UPDATE attendance_data ad
            SET ad.ongoing_required = 'Y',
                ad.ongoing_attendance_confirmed = 'Y',
                ad.attend_received_date = SYSDATE,
                ad.attend_applied_date = SYSDATE,
                ad.chngd_since_last_report = 'Y',
                ad.attend_updated_by = UPPER (user_id)
          WHERE ad.stud_crse_year_id = stud_crse_year_id_in;
      END IF;

      UPDATE attendance_data ad
         SET ad.attendance_override = 'Y'
       WHERE ad.stud_crse_year_id = stud_crse_year_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : override_attendance_data : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END override_attendance_data;
END pk_steps_ui_attendance_data;
/