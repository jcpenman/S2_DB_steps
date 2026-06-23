CREATE OR REPLACE PACKAGE SGAS.ed8_download
IS
   PROCEDURE create_csv_file (
      param_file_name      IN              VARCHAR2,
      param_session_code   IN              stud_session.session_code%TYPE,
      param_mode_type      IN              VARCHAR2,
      param_scheme_type    IN              VARCHAR2,
      success_fail         OUT             VARCHAR2,
      start_finish         OUT             VARCHAR2,
      error_msg            OUT             VARCHAR2,
      number_of_records    OUT             VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE create_csv_line (
      p_stud_ref_no         IN              stud.stud_ref_no%TYPE,
      p_stud_session_id     IN              stud_session.stud_session_id%TYPE,
      p_stud_crse_year_id   IN              stud_crse_year.stud_crse_year_id%TYPE,
      param_session_code    IN              stud_session.session_code%TYPE,
      param_mode_type       IN              VARCHAR2,
      param_scheme_type     IN              VARCHAR2,
      p_handle              IN OUT          UTL_FILE.file_type,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_report_line (
      p_stud_ref_no         IN              stud.stud_ref_no%TYPE,
      p_stud_session_id     IN              stud_session.stud_session_id%TYPE,
      p_stud_crse_year_id   IN              stud_crse_year.stud_crse_year_id%TYPE,
      param_session_code    IN              stud_session.session_code%TYPE,
      param_mode_type       IN              VARCHAR2,
      param_scheme_type     IN              VARCHAR2,
      report_line           OUT             VARCHAR2,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   );

   PROCEDURE update_run_log (
      p_filename        IN   VARCHAR2,
      p_session_code    IN   NUMBER,
      p_mode_type       IN   VARCHAR2,
      p_scheme_type     IN   VARCHAR2,
      p_success         IN   VARCHAR2,
      p_start           IN   DATE,
      p_finish          IN   DATE,
      p_error_msg       IN   VARCHAR2,
      p_no_of_records   IN   NUMBER
   );
END ed8_download;
/