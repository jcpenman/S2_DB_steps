CREATE OR REPLACE PACKAGE SGAS.ed8_content
IS
   -- DESCRIPTION
   -- ===========
   -- Package contains the procedures that retrieves all the ED8 data
   --
   -- Modification History
   -- Date                 Author      Ref    Desc
   -- 30.04.2012          A.Bowman    001    Initial Creation of Package
   --
   --
   --
   -- Configuration Management:
   -- $HeadURL:  $
   -- $Author: $
   -- $Date:  $
   -- $Revision:  $
   --
   TYPE t_ed8_parameter IS RECORD
   (
      stud_ref_no         stud.stud_ref_no%TYPE,
      stud_session_id     stud_session.stud_session_id%TYPE,
      stud_crse_year_id   stud_crse_year.stud_crse_year_id%TYPE,
      session_code        stud_session.session_code%TYPE,
      scheme_type         VARCHAR2 (1),
      mode_type           VARCHAR2 (1)
   );

   TYPE t_ed8_output IS RECORD
   (
      report_line_fragment   VARCHAR2 (4096),
      error_boolean          VARCHAR2 (5),
      ERROR_TEXT             VARCHAR2 (1024)
   );

   PROCEDURE get_shape (shape_id OUT NOCOPY NUMBER);

   PROCEDURE build_line (
      p_stud_ref_no         IN            stud.stud_ref_no%TYPE,
      p_stud_session_id     IN            stud_session.stud_session_id%TYPE,
      p_stud_crse_year_id   IN            stud_crse_year.stud_crse_year_id%TYPE,
      param_session_code    IN            stud_session.session_code%TYPE,
      param_mode_type       IN            VARCHAR2,
      param_scheme_type     IN            VARCHAR2,
      report_line              OUT        VARCHAR2,
      error_boolean            OUT NOCOPY VARCHAR2,
      ERROR_TEXT               OUT NOCOPY VARCHAR2);

   PROCEDURE add_personal_details (ed8_parameter   IN     t_ed8_parameter,
                                   ed8_output         OUT t_ed8_output);

   PROCEDURE add_dsa_details (ed8_parameter   IN     t_ed8_parameter,
                              ed8_output         OUT t_ed8_output);

   PROCEDURE add_application_details (ed8_parameter   IN     t_ed8_parameter,
                                      ed8_output         OUT t_ed8_output);

   PROCEDURE add_course_details (ed8_parameter   IN     t_ed8_parameter,
                                 ed8_output         OUT t_ed8_output);

   PROCEDURE add_student_income_details (
      ed8_parameter   IN     t_ed8_parameter,
      ed8_output         OUT t_ed8_output);

   PROCEDURE add_ben_income_details (ed8_parameter   IN     t_ed8_parameter,
                                     ed8_output         OUT t_ed8_output);

   PROCEDURE add_bursary_grant_details (
      ed8_parameter   IN     t_ed8_parameter,
      ed8_output         OUT t_ed8_output);

   PROCEDURE add_loan_details (ed8_parameter   IN     t_ed8_parameter,
                               ed8_output         OUT t_ed8_output);

   PROCEDURE add_tuition_fee_details (ed8_parameter   IN     t_ed8_parameter,
                                      ed8_output         OUT t_ed8_output);

   PROCEDURE add_study_abroad_details (
      ed8_parameter   IN     t_ed8_parameter,
      ed8_output         OUT t_ed8_output);

   PROCEDURE add_dependants_details (ed8_parameter   IN     t_ed8_parameter,
                                     ed8_output         OUT t_ed8_output);
END ed8_content;
/
