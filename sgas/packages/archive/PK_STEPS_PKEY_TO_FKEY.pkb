CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_pkey_to_fkey
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
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT aj.batch_ref
        INTO dpb_batch_ref
        FROM adi_journal aj
       WHERE aj.adi_journal_line_id = adi_journal_line_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_adi_journals_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_adi_journals_fkeys;

   PROCEDURE get_attendance_data_fkeys (
      attendance_data_id_in   IN              NUMBER,
      stud_crse_year_id       OUT             NUMBER,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT ad.stud_crse_year_id
        INTO stud_crse_year_id
        FROM attendance_data ad
       WHERE ad.attendance_data_id = attendance_data_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_attendance_data_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_attendance_data_fkeys;

   PROCEDURE get_att_data_message_fkeys (
      attendance_data_message_id_in   IN              NUMBER,
      attendance_data_received_id     OUT             NUMBER,
      error_boolean                   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                      OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT adm.attendance_data_received_id
        INTO attendance_data_received_id
        FROM attendance_data_message adm
       WHERE adm.attendance_data_message_id = attendance_data_message_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_attendance_data_message_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_att_data_message_fkeys;

   PROCEDURE get_att_data_received_fkeys (
      attendance_data_received_id_in   IN              NUMBER,
      loa_reason_code                  OUT             VARCHAR2,
      reason_code                      OUT             VARCHAR2,
      status_code                      OUT             VARCHAR2,
      stud_ref_no                      OUT             NUMBER,
      error_boolean                    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                       OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT adr.loa_reason, adr.repeat_year_reason, adr.status,
             adr.stud_ref_no
        INTO loa_reason_code, reason_code, status_code,
             stud_ref_no
        FROM attendance_data_received adr
       WHERE adr.attendance_data_received_id = attendance_data_received_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_attendance_data_received_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_att_data_received_fkeys;

   PROCEDURE get_award_fkeys (
      award_id_in         IN              NUMBER,
      dsa_allowance_id    OUT             NUMBER,
      stud_crse_year_id   OUT             NUMBER,
      stud_ref_no         OUT             NUMBER,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT a.dsa_allowance_id, a.stud_crse_year_id, a.stud_ref_no
        INTO dsa_allowance_id, stud_crse_year_id, stud_ref_no
        FROM award a
       WHERE a.award_id = award_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_award_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_award_fkeys;

   PROCEDURE get_award_instalment_fkeys (
      award_instalment_id_in   IN              NUMBER,
      award_id                 OUT             NUMBER,
      batch_ref                OUT             VARCHAR2,
      error_boolean            OUT NOCOPY      VARCHAR2,
      ERROR_TEXT               OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT awi.award_id, awi.batch_ref
        INTO award_id, batch_ref
        FROM award_instalment awi
       WHERE awi.award_instalment_id = award_instalment_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_award_instalment_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_award_instalment_fkeys;

   PROCEDURE get_benefactor_dependant_fkeys (
      bed_id_in       IN              NUMBER,
      ben_id          OUT             NUMBER,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT bed.ben_id
        INTO ben_id
        FROM benefactor_dependant bed
       WHERE bed.bed_id = bed_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_benefactor_dependant_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_benefactor_dependant_fkeys;

   PROCEDURE get_benefactor_income_fkeys (
      ben_id_in         IN              NUMBER,
      session_code_in   IN              NUMBER,
      ben_id            OUT             NUMBER,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT bei.ben_id
        INTO ben_id
        FROM benefactor_income bei
       WHERE bei.ben_id = ben_id_in AND session_code = session_code_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_benefactor_income_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_benefactor_income_fkeys;

   PROCEDURE get_complete_task_data_fkeys (
      complete_task_id_in   IN              NUMBER,
      process_id            OUT             VARCHAR2,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT ctd.process_id
        INTO process_id
        FROM complete_task_data ctd
       WHERE ctd.complete_task_id = complete_task_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_complete_task_data_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_complete_task_data_fkeys;

   PROCEDURE get_dsa_allowance_fkeys (
      dsa_allowance_id_in   IN              NUMBER,
      dsa_application_id    OUT             NUMBER,
      dsa_category_id       OUT             NUMBER,
      stud_crse_year_id     OUT             NUMBER,
      stud_session_id       OUT             NUMBER,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT dsa.dsa_application_id, dsa.dsa_category_id,
             dsa.stud_crse_year_id, dsa.stud_session_id
        INTO dsa_application_id, dsa_category_id,
             stud_crse_year_id, stud_session_id
        FROM dsa_allowance dsa
       WHERE dsa.ID = dsa_allowance_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_dsa_allowance_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_dsa_allowance_fkeys;

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
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT dsapp.assessment_centre_id, dsapp.disability_type_id,
             dsapp.dsa_referral_reason_id, dsapp.dsa_rejection_reason_id,
             dsapp.dsa_student_type_id, dsapp.stud_ref_no
        INTO dsa_assessment_centre_id, disability_type_id,
             dsa_referral_reason_id, dsa_rejection_reason_id,
             dsa_student_type_id, stud_ref_no
        FROM dsa_application dsapp
       WHERE dsapp.ID = dsa_application_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_dsa_application_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_dsa_application_fkeys;

   PROCEDURE get_dsa_payment_fkeys (
      dsa_payment_id_in       IN              NUMBER,
      dsa_allowance_id        OUT             NUMBER,
      dsa_payment_status_id   OUT             NUMBER,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT dsapay.dsa_allowance_id, dsapay.dsa_payment_status_id
        INTO dsa_allowance_id, dsa_payment_status_id
        FROM dsa_payment dsapay
       WHERE dsapay.ID = dsa_payment_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_dsa_payment_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_dsa_payment_fkeys;

   PROCEDURE get_employee_activity_fkeys (
      username_in        IN              VARCHAR2,
      activity_date_in   IN              DATE,
      username           OUT             VARCHAR2,
      error_boolean      OUT NOCOPY      VARCHAR2,
      ERROR_TEXT         OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT ea.username
        INTO username
        FROM employee_activity ea
       WHERE ea.username = username_in AND ea.activity_date = activity_date_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_employee_activity_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_employee_activity_fkeys;

   PROCEDURE get_employee_cases_fkeys (
      employee_case_id_in   IN              NUMBER,
      username              OUT             VARCHAR2,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT ec.username
        INTO username
        FROM employee_cases ec
       WHERE ec.employee_case_id = employee_case_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_employee_cases_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_employee_cases_fkeys;

   PROCEDURE get_employee_locks_fkeys (
      username_in     IN              VARCHAR2,
      username        OUT             VARCHAR2,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT el.username
        INTO username
        FROM employee_locks el
       WHERE el.username = username_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_employee_locks_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_employee_locks_fkeys;

   PROCEDURE get_inst_cont_email_fkeys (
      inst_code_id_in IN              VARCHAR2,
      inst_code       OUT             VARCHAR2,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT ice.inst_code
        INTO inst_code
        FROM inst_cont_email ice
       WHERE ice.inst_code_id = inst_code_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_inst_cont_email_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_inst_cont_email_fkeys;

   PROCEDURE get_nmsb_spec_arr_fkeys (
      nmsb_spec_arr_id_in   IN              NUMBER,
      nmsb_cont_id          OUT             NUMBER,
      stud_ref_no           OUT             NUMBER,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT nsa.reason_code, nsa.stud_ref_no
        INTO nmsb_cont_id, stud_ref_no
        FROM nmsb_spec_arr nsa
       WHERE nsa.nmsb_spec_arr_id = nmsb_spec_arr_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_nmsb_spec_arr_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_nmsb_spec_arr_fkeys;

   PROCEDURE get_payee_payment_fkeys (
      payee_payment_id_in   IN              NUMBER,
      dpb_batch_ref         OUT             VARCHAR2,
      payee_id              OUT             NUMBER,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT pp.batch_ref, pp.payee_id
        INTO dpb_batch_ref, payee_id
        FROM payee_payment pp
       WHERE pp.payee_payment_id = payee_payment_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_payee_payment_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_payee_payment_fkeys;

   PROCEDURE get_pay_files_unproc_fkeys (
      payment_file_id_in   IN              NUMBER,
      type_code            OUT             VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT pfu.type_code
        INTO type_code
        FROM payment_files_unprocessed pfu
       WHERE pfu.payment_file_id = payment_file_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_pay_files_unproc_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_pay_files_unproc_fkeys;

   PROCEDURE get_payment_instalment_fkeys (
      payment_instalment_id_in   IN              NUMBER,
      award_instalment_id        OUT             NUMBER,
      dpb_batch_ref              OUT             VARCHAR2,
      payee_id                   OUT             NUMBER,
      payee_payment_id           OUT             NUMBER,
      stud_crse_year_id          OUT             NUMBER,
      error_boolean              OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                 OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT pi.award_instalment_id, pi.batch_ref, pi.payee_id,
             pi.payee_payment_id, pi.stud_crse_year_id
        INTO award_instalment_id, dpb_batch_ref, payee_id,
             payee_payment_id, stud_crse_year_id
        FROM payment_instalment pi
       WHERE pi.payment_instalment_id = payment_instalment_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_payment_instalment_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_payment_instalment_fkeys;

   PROCEDURE get_reference_data_fkeys (
      reference_data_id_in   IN              NUMBER,
      ref_type_id            OUT             NUMBER,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT rd.ref_type_id
        INTO ref_type_id
        FROM reference_data rd
       WHERE rd.ID = reference_data_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_reference_data_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_reference_data_fkeys;

   PROCEDURE get_reference_types_fkeys (
      reference_type_id_in   IN              NUMBER,
      domain_name            OUT             VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT rt.domain
        INTO domain_name
        FROM reference_types rt
       WHERE rt.ID = reference_type_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_reference_types_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_reference_types_fkeys;

   PROCEDURE get_stud_fkeys (
      stud_ref_no_in           IN              NUMBER,
      disability_type_id       OUT             NUMBER,
      birth_country_code       OUT             NUMBER,
      residence_country_code   OUT             NUMBER,
      nation_country_code      OUT             NUMBER,
      error_boolean            OUT NOCOPY      VARCHAR2,
      ERROR_TEXT               OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT st.disability_id, st.birth_country_code,
             st.residence_country_code, st.nation_country_code
        INTO disability_type_id, birth_country_code,
             residence_country_code, nation_country_code
        FROM stud st
       WHERE st.stud_ref_no = stud_ref_no_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_stud_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_stud_fkeys;

   PROCEDURE get_stud_crse_year_fkeys (
      stud_crse_year_id_in   IN              NUMBER,
      stud_ref_no            OUT             NUMBER,
      stud_session_id        OUT             NUMBER,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT stcy.stud_ref_no, stcy.stud_session_id
        INTO stud_ref_no, stud_session_id
        FROM stud_crse_year stcy
       WHERE stcy.stud_crse_year_id = stud_crse_year_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_stud_crse_year_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_stud_crse_year_fkeys;

   PROCEDURE get_stud_dependant_fkeys (
      std_id_in         IN              NUMBER,
      stud_ref_no       OUT             NUMBER,
      stud_session_id   OUT             NUMBER,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT std.stud_ref_no, std.stud_session_id
        INTO stud_ref_no, stud_session_id
        FROM stud_dependant std
       WHERE std.std_id = std_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_stud_dependant_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_stud_dependant_fkeys;

   PROCEDURE get_stud_home_addr_fkeys (
      stud_ref_no_in   IN              NUMBER,
      start_date_in    IN              VARCHAR2,
      stud_ref_no      OUT             NUMBER,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT sha.stud_ref_no
        INTO stud_ref_no
        FROM stud_home_addr sha
       WHERE sha.stud_ref_no = stud_ref_no_in
         AND sha.start_date = to_date(start_date_in, 'dd/MM/yyyyHH24:MI:SS');         
         
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_stud_home_addr_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_stud_home_addr_fkeys;

   PROCEDURE get_stud_nominee_fkeys (
      stud_nom_id_in   IN              NUMBER,
      nominee_id       OUT             NUMBER,
      stud_ref_no      OUT             NUMBER,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT sn.nominee_id, sn.stud_ref_no
        INTO nominee_id, stud_ref_no
        FROM stud_nominee sn
       WHERE sn.stud_nom_id = stud_nom_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_stud_nominee_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_stud_nominee_fkeys;

   PROCEDURE get_stud_notes_fkeys (
      stud_notes_id_in   IN              NUMBER,
      stud_ref_no        OUT             NUMBER,
      error_boolean      OUT NOCOPY      VARCHAR2,
      ERROR_TEXT         OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT sno.stud_ref_no
        INTO stud_ref_no
        FROM stud_notes sno
       WHERE sno.ID = stud_notes_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_stud_notes_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_stud_notes_fkeys;

   PROCEDURE get_stud_rate_fkeys (
      stud_rate_id_in      IN              NUMBER,
      stud_award_type_id   OUT             NUMBER,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT sr.stud_award_type_id
        INTO stud_award_type_id
        FROM stud_rate sr
       WHERE sr.stud_rate_id = stud_rate_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_stud_rate_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_stud_rate_fkeys;

   PROCEDURE get_stud_session_fkeys (
      stud_session_id_in   IN              NUMBER,
      ben1_id              OUT             NUMBER,
      ben2_id              OUT             NUMBER,
      ja_case_id           OUT             VARCHAR2,
      stud_ref_no          OUT             NUMBER,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT ss.ben1_id, ss.ben2_id, ss.ja_case_id, ss.stud_ref_no
        INTO ben1_id, ben2_id, ja_case_id, stud_ref_no
        FROM stud_session ss
       WHERE ss.stud_session_id = stud_session_id_in;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_stud_session_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_stud_session_fkeys;

   PROCEDURE get_stud_term_addr_fkeys (
      stud_ref_no_in   IN              NUMBER,
      start_date_in    IN              VARCHAR2,
      stud_ref_no      OUT             NUMBER,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT stterm.stud_ref_no
        INTO stud_ref_no
        FROM stud_term_addr stterm
       WHERE stterm.stud_ref_no = stud_ref_no_in
         AND stterm.start_date = to_date(start_date_in, 'dd/MM/yyyyHH24:MI:SS');
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_stud_term_addr_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_stud_term_addr_fkeys;

   PROCEDURE get_stud_track_fkeys (
      stud_ref_no_in   IN              NUMBER,
      date_moved_in    IN              VARCHAR2,
      stud_ref_no      OUT             NUMBER,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT sttrack.stud_ref_no
        INTO stud_ref_no
        FROM stud_track sttrack
       WHERE sttrack.stud_ref_no = stud_ref_no_in
         AND sttrack.date_moved = to_date(date_moved_in, 'dd/MM/yyyyHH24:MI:SS');
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_stud_track_fkeys : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_stud_track_fkeys;
END pk_steps_pkey_to_fkey;
/
