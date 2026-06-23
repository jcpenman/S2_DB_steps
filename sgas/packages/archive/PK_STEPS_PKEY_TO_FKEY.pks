CREATE OR REPLACE PACKAGE SGAS.pk_steps_pkey_to_fkey
IS
-- DESCRIPTION
-- ===========
-- Package contains procedures to retrieve foreign keys from primary keys
--
-- Modification History
-- Date                 Author      Ref    Desc
-- 27.07.2011          A.Bowman    001    Initial Creation of Package
--
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision:  $
--
   PROCEDURE get_adi_journals_fkeys (
      adi_journal_line_id_in   IN              NUMBER,
      dpb_batch_ref            OUT             VARCHAR2,
      error_boolean            OUT NOCOPY      VARCHAR2,
      ERROR_TEXT               OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_attendance_data_fkeys (
      attendance_data_id_in   IN              NUMBER,
      stud_crse_year_id       OUT             NUMBER,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_att_data_message_fkeys (
      attendance_data_message_id_in   IN              NUMBER,
      attendance_data_received_id     OUT             NUMBER,
      error_boolean                   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_att_data_received_fkeys (
      attendance_data_received_id_in   IN              NUMBER,
      loa_reason_code                  OUT             VARCHAR2,
      reason_code                      OUT             VARCHAR2,
      status_code                      OUT             VARCHAR2,
      stud_ref_no                      OUT             NUMBER,
      error_boolean                    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_award_fkeys (
      award_id_in         IN              NUMBER,
      dsa_allowance_id    OUT             NUMBER,
      stud_crse_year_id   OUT             NUMBER,
      stud_ref_no         OUT             NUMBER,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_award_instalment_fkeys (
      award_instalment_id_in   IN              NUMBER,
      award_id                 OUT             NUMBER,
      batch_ref                OUT             VARCHAR2,
      error_boolean            OUT NOCOPY      VARCHAR2,
      ERROR_TEXT               OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_benefactor_dependant_fkeys (
      bed_id_in       IN              NUMBER,
      ben_id          OUT             NUMBER,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_benefactor_income_fkeys (
      ben_id_in         IN              NUMBER,
      session_code_in   IN              NUMBER,
      ben_id            OUT             NUMBER,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_complete_task_data_fkeys (
      complete_task_id_in   IN              NUMBER,
      process_id            OUT             VARCHAR2,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_dsa_allowance_fkeys (
      dsa_allowance_id_in   IN              NUMBER,
      dsa_application_id    OUT             NUMBER,
      dsa_category_id       OUT             NUMBER,
      stud_crse_year_id     OUT             NUMBER,
      stud_session_id       OUT             NUMBER,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_dsa_application_fkeys (
      dsa_application_id_in      IN              NUMBER,
      dsa_assessment_centre_id   OUT             NUMBER,
      disability_type_id         OUT             NUMBER,
      dsa_referral_reason_id     OUT             NUMBER,
      dsa_rejection_reason_id    OUT             NUMBER,
      dsa_student_type_id        OUT             NUMBER,
      stud_ref_no                OUT             NUMBER,
      error_boolean              OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                 OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_dsa_payment_fkeys (
      dsa_payment_id_in       IN              NUMBER,
      dsa_allowance_id        OUT             NUMBER,
      dsa_payment_status_id   OUT             NUMBER,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_employee_activity_fkeys (
      username_in        IN              VARCHAR2,
      activity_date_in   IN              DATE,
      username           OUT             VARCHAR2,
      error_boolean      OUT NOCOPY      VARCHAR2,
      ERROR_TEXT         OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_employee_cases_fkeys (
      employee_case_id_in   IN              NUMBER,
      username              OUT             VARCHAR2,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_employee_locks_fkeys (
      username_in     IN              VARCHAR2,
      username        OUT             VARCHAR2,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_inst_cont_email_fkeys (
      inst_code_id_in IN              VARCHAR2,
      inst_code       OUT             VARCHAR2,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_nmsb_spec_arr_fkeys (
      nmsb_spec_arr_id_in   IN              NUMBER,
      nmsb_cont_id          OUT             NUMBER,
      stud_ref_no           OUT             NUMBER,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_payee_payment_fkeys (
      payee_payment_id_in   IN              NUMBER,
      dpb_batch_ref         OUT             VARCHAR2,
      payee_id              OUT             NUMBER,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_pay_files_unproc_fkeys (
      payment_file_id_in   IN              NUMBER,
      type_code            OUT             VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_payment_instalment_fkeys (
      payment_instalment_id_in   IN              NUMBER,
      award_instalment_id        OUT             NUMBER,
      dpb_batch_ref              OUT             VARCHAR2,
      payee_id                   OUT             NUMBER,
      payee_payment_id           OUT             NUMBER,
      stud_crse_year_id          OUT             NUMBER,
      error_boolean              OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                 OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_reference_data_fkeys (
      reference_data_id_in   IN              NUMBER,
      ref_type_id            OUT             NUMBER,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_reference_types_fkeys (
      reference_type_id_in   IN              NUMBER,
      domain_name            OUT             VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_stud_fkeys (
      stud_ref_no_in           IN              NUMBER,
      disability_type_id       OUT             NUMBER,
      birth_country_code       OUT             NUMBER,
      residence_country_code   OUT             NUMBER,
      nation_country_code      OUT             NUMBER,
      error_boolean            OUT NOCOPY      VARCHAR2,
      ERROR_TEXT               OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_stud_crse_year_fkeys (
      stud_crse_year_id_in   IN              NUMBER,
      stud_ref_no            OUT             NUMBER,
      stud_session_id        OUT             NUMBER,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_stud_dependant_fkeys (
      std_id_in         IN              NUMBER,
      stud_ref_no       OUT             NUMBER,
      stud_session_id   OUT             NUMBER,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_stud_home_addr_fkeys (
      stud_ref_no_in   IN              NUMBER,
      start_date_in    IN              VARCHAR2,
      stud_ref_no      OUT             NUMBER,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_stud_nominee_fkeys (
      stud_nom_id_in   IN              NUMBER,
      nominee_id       OUT             NUMBER,
      stud_ref_no      OUT             NUMBER,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_stud_notes_fkeys (
      stud_notes_id_in   IN              NUMBER,
      stud_ref_no        OUT             NUMBER,
      error_boolean      OUT NOCOPY      VARCHAR2,
      ERROR_TEXT         OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_stud_rate_fkeys (
      stud_rate_id_in      IN              NUMBER,
      stud_award_type_id   OUT             NUMBER,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_stud_session_fkeys (
      stud_session_id_in   IN              NUMBER,
      ben1_id              OUT             NUMBER,
      ben2_id              OUT             NUMBER,
      ja_case_id           OUT             VARCHAR2,
      stud_ref_no          OUT             NUMBER,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_stud_term_addr_fkeys (
      stud_ref_no_in   IN              NUMBER,
      start_date_in    IN              VARCHAR2,
      stud_ref_no      OUT             NUMBER,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_stud_track_fkeys (
      stud_ref_no_in   IN              NUMBER,
      date_moved_in    IN              VARCHAR2,
      stud_ref_no      OUT             NUMBER,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );
END pk_steps_pkey_to_fkey;
/
