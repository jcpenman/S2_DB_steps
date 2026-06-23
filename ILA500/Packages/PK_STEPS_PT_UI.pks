/* Formatted on 2011/06/13 10:29 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE ila500.pk_steps_pt_ui
AS
-- DESCRIPTION
-- ============
-- Package to read, write, insert and delete records
-- from the ILA500 database via the user interface
--
-- Modification History
-- Date                 Author       Ref    Desc
-- 07.07.2008           N Pickard    001    Initial Creation
--                      P Grace
--                      M Tolmie
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision:  $
--
   TYPE application_cursor IS REF CURSOR;

   TYPE qausers_cursor IS REF CURSOR;

   TYPE qauser_cursor IS REF CURSOR;

   TYPE course_levels_cursor IS REF CURSOR;

   TYPE shellletters_cursor IS REF CURSOR;

   TYPE course_types_cursor IS REF CURSOR;

   TYPE notes_cursor IS REF CURSOR;

   TYPE edm_cursor IS REF CURSOR;

   TYPE title_cursor IS REF CURSOR;

   TYPE status_cursor IS REF CURSOR;

   TYPE reject_cursor IS REF CURSOR;

   TYPE doctype_cursor IS REF CURSOR;

   TYPE learningprovider_cursor IS REF CURSOR;

   TYPE coursetype_cursor IS REF CURSOR;

   TYPE courselevel_cursor IS REF CURSOR;

   TYPE debtstatus_cursor IS REF CURSOR;

   TYPE incomeevid_cursor IS REF CURSOR;

   TYPE documentregister_cursor IS REF CURSOR;

   TYPE learnerorproviderlist_cursor IS REF CURSOR;

   TYPE caseworkernote_cursor IS REF CURSOR;

   TYPE caseworkernotetype_cursor IS REF CURSOR;

   TYPE alllearnerforprovider_cursor IS REF CURSOR;

   TYPE audit_cursor IS REF CURSOR;

   TYPE providertype_cursor IS REF CURSOR;

   TYPE providerstatus_cursor IS REF CURSOR;

   TYPE providerpayments_cursor IS REF CURSOR;

   TYPE payment_status_cursor IS REF CURSOR;

   TYPE payment_method_cursor IS REF CURSOR;

   invalid_id     EXCEPTION;
   duplicate_id   EXCEPTION;

   PROCEDURE getsession (
      learner_application_id_in   IN              VARCHAR2,
      session_code_out            OUT NOCOPY      NUMBER
   );

   PROCEDURE getgeneratedref (generated_ref_out OUT NOCOPY NUMBER);

   PROCEDURE getlatestapplication (
      learner_id_in                IN              VARCHAR2,
      learner_application_id_out   OUT NOCOPY      NUMBER
   );

   PROCEDURE shell_letter_config (
      shell_path_out                OUT NOCOPY   VARCHAR2,
      shell_type_out                OUT NOCOPY   VARCHAR2,
      shell_client_target_dir_out   OUT NOCOPY   VARCHAR2,
      shell_server_target_dir_out   OUT NOCOPY   VARCHAR2,
      error_boolean                 OUT NOCOPY   VARCHAR2,
      ERROR_TEXT                    OUT NOCOPY   VARCHAR2
   );

   PROCEDURE shellletters (
      io_cursor       IN OUT          shellletters_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getlearneraddr (
      learner_id_in       IN              VARCHAR2,
      title_out           OUT NOCOPY      VARCHAR2,
      forename_out        OUT NOCOPY      VARCHAR2,
      surname_out         OUT NOCOPY      VARCHAR2,
      housename_no_out    OUT NOCOPY      VARCHAR2,
      address_line1_out   OUT NOCOPY      VARCHAR2,
      address_line2_out   OUT NOCOPY      VARCHAR2,
      address_line3_out   OUT NOCOPY      VARCHAR2,
      address_line4_out   OUT NOCOPY      VARCHAR2,
      postcode_out        OUT NOCOPY      VARCHAR2,
      mailsort_out        OUT NOCOPY      VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getcourseinfo (
      learner_application_id_in   IN              NUMBER,
      learning_provider_out       OUT NOCOPY      VARCHAR2,
      course_out                  OUT NOCOPY      VARCHAR2,
      course_level_out            OUT NOCOPY      VARCHAR2,
      session_out                 OUT NOCOPY      VARCHAR2,
      error_boolean               OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getincomeinfo (
      learner_application_id_in      IN              NUMBER,
      no_income_evid_id_out          OUT NOCOPY      VARCHAR2,
      jsa_evid_id_out                OUT NOCOPY      VARCHAR2,
      inc_sup_evid_id_out            OUT NOCOPY      VARCHAR2,
      inc_ben_evid_id_out            OUT NOCOPY      VARCHAR2,
      carers_allowance_evid_id_out   OUT NOCOPY      VARCHAR2,
      pension_credit_evid_id_out     OUT NOCOPY      VARCHAR2,
      max_child_tc_evid_id_out       OUT NOCOPY      VARCHAR2,
      error_boolean                  OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                     OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getsummary (
      learner_id_in               IN              VARCHAR2,
      title_out                   OUT NOCOPY      VARCHAR2,
      forename_out                OUT NOCOPY      VARCHAR2,
      surname_out                 OUT NOCOPY      VARCHAR2,
      dob_out                     OUT NOCOPY      VARCHAR2,
      gender_out                  OUT NOCOPY      VARCHAR2,
      housename_no_out            OUT NOCOPY      VARCHAR2,
      address_line1_out           OUT NOCOPY      VARCHAR2,
      address_line2_out           OUT NOCOPY      VARCHAR2,
      address_line3_out           OUT NOCOPY      VARCHAR2,
      address_line4_out           OUT NOCOPY      VARCHAR2,
      postcode_out                OUT NOCOPY      VARCHAR2,
      tele_no_out                 OUT NOCOPY      VARCHAR2,
      email_addr_out              OUT NOCOPY      VARCHAR2,
      status_out                  OUT NOCOPY      VARCHAR2,
      provider_out                OUT NOCOPY      VARCHAR2,
      course_out                  OUT NOCOPY      VARCHAR2,
      course_level_out            OUT NOCOPY      VARCHAR2,
      course_start_date_out       OUT NOCOPY      VARCHAR2,
      last_letter_generated_out   OUT NOCOPY      VARCHAR2,
      error_boolean               OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getcaseworkernotes (
      pk_in           IN              VARCHAR2,
      io_cursor       IN OUT          notes_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getcoursetypes (
      session_year_in   IN              VARCHAR2,
      io_cursor         IN OUT          course_types_cursor,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setcoursetype (
      course_type_id_in      IN              NUMBER,
      bacs_payment_date_in   IN              DATE,
      course_type_desc_in    IN              VARCHAR2,
      session_code_in        IN              VARCHAR2,
      fee_cut_off_date_in    IN              DATE,
      fee_period_start_in    IN              DATE,
      fee_period_end_in      IN              DATE,
      submitted_date_in      IN              DATE,
      batch_run_date_in      IN              DATE,
      last_updated_by_in     IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2,
      row_count              OUT             NUMBER
   );

   PROCEDURE getcourselevels (
      io_cursor       IN OUT          course_levels_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setcourselevels (
      course_id_in           IN              NUMBER,
      last_updated_by_in     IN              VARCHAR2,
      course_level_desc_in   IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2,
      row_count              OUT             NUMBER
   );

   PROCEDURE insertcourselevels (
      last_updated_by_in     IN              VARCHAR2,
      course_level_desc_in   IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2,
      row_count              OUT             NUMBER
   );

   PROCEDURE getqausers (
      io_cursor       IN OUT          qausers_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setqauser (
      username_in          IN              VARCHAR2,
      last_updated_by_in   IN              VARCHAR2,
      qa_level_in          IN              NUMBER,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2,
      row_count            OUT             NUMBER
   );

   PROCEDURE getedmconfigdata (
      eistream_domain_name   OUT   VARCHAR2,
      edm_client_path        OUT   VARCHAR2,
      edm_server_path        OUT   VARCHAR2,
      error_boolean          OUT   VARCHAR2,
      ERROR_TEXT             OUT   VARCHAR2
   );

   PROCEDURE edm (
      learner_id_in   IN       VARCHAR2,
      io_cursor       IN OUT   edm_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   FUNCTION edm_doctype_to_doctypename (document_type_code_in IN VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE edm_doctypename_to_doctype (
      document_name_in         IN       VARCHAR2,
      document_type_code_out   OUT      VARCHAR2,
      error_boolean            OUT      VARCHAR2,
      ERROR_TEXT               OUT      VARCHAR2
   );

   PROCEDURE insertedm (
      learner_id_in           IN       VARCHAR2,
      object_id_in            IN       VARCHAR2,
      session_year_in         IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      filename_in             IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   );

   PROCEDURE updateedm (
      learner_id_in           IN       VARCHAR2,
      object_id_in            IN       VARCHAR2,
      session_year_in         IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   );

   PROCEDURE getapplicabledoctypecode (
      file_ext_in     IN       VARCHAR2,
      io_cursor       IN OUT   doctype_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE edmrescan (
      object_id_in            IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      rescan_request_id_in    IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   );

   PROCEDURE edm_orig_req (
      object_id_in            IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   );

   PROCEDURE edmviewed (
      object_id_in            IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   );

   PROCEDURE geteistreampassword (
      eistream_user       IN       VARCHAR2,
      eistream_password   OUT      VARCHAR2,
      error_boolean       OUT      VARCHAR2,
      ERROR_TEXT          OUT      VARCHAR2
   );

   PROCEDURE geteistreamuser (
      eistream_user_in    IN       VARCHAR2,
      eistream_user_out   OUT      VARCHAR2,
      error_boolean       OUT      VARCHAR2,
      ERROR_TEXT          OUT      VARCHAR2
   );

   PROCEDURE getedmlearnerdetails (
      learner_id_in         IN       VARCHAR2,
      learner_surname       OUT      VARCHAR2,
      learner_postcode      OUT      VARCHAR2,
      learner_addr_l1       OUT      VARCHAR2,
      learner_inst_name     OUT      VARCHAR2,
      learner_course_name   OUT      VARCHAR2,
      error_boolean         OUT      VARCHAR2,
      ERROR_TEXT            OUT      VARCHAR2
   );

   PROCEDURE getpicklistlearnerdetails (
      learner_id_in       IN       VARCHAR2,
      learner_forenames   OUT      VARCHAR2,
      learner_surname     OUT      VARCHAR2,
      error_boolean       OUT      VARCHAR2,
      ERROR_TEXT          OUT      VARCHAR2
   );

   PROCEDURE getpicklistproviderdetails (
      provider_id_in   IN       VARCHAR2,
      provider_name    OUT      VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   );

   PROCEDURE getlearnerdetails (
      learner_id_in          IN              VARCHAR2,
      title_out              OUT NOCOPY      VARCHAR2,
      other_title_out        OUT NOCOPY      VARCHAR2,
      forename_out           OUT NOCOPY      VARCHAR2,
      surname_out            OUT NOCOPY      VARCHAR2,
      dob_out                OUT NOCOPY      DATE,
      gender_out             OUT NOCOPY      VARCHAR2,
      living_scot_out        OUT NOCOPY      VARCHAR2,
      living_away_out        OUT NOCOPY      VARCHAR2,
      housename_no_out       OUT NOCOPY      VARCHAR2,
      address_line1_out      OUT NOCOPY      VARCHAR2,
      address_line2_out      OUT NOCOPY      VARCHAR2,
      address_line3_out      OUT NOCOPY      VARCHAR2,
      address_line4_out      OUT NOCOPY      VARCHAR2,
      postcode_out           OUT NOCOPY      VARCHAR2,
      mailsort_out           OUT NOCOPY      VARCHAR2,
      tele_no_out            OUT NOCOPY      VARCHAR2,
      email_addr_out         OUT NOCOPY      VARCHAR2,
      hold_payments_out      OUT NOCOPY      VARCHAR2,
      hold_letters_out       OUT NOCOPY      VARCHAR2,
      mail_returned_out      OUT NOCOPY      DATE,
      learner_deceased_out   OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setlearnerdetails (
      learner_id_in          IN       VARCHAR2,
      title_out              IN       VARCHAR2,
      other_title_out        IN       VARCHAR2,
      forename_out           IN       VARCHAR2,
      surname_out            IN       VARCHAR2,
      dob_out                IN       DATE,
      gender_out             IN       VARCHAR2,
      living_scot_out        IN       VARCHAR2,
      living_away_out        IN       VARCHAR2,
      housename_no_out       IN       VARCHAR2,
      address_line1_out      IN       VARCHAR2,
      address_line2_out      IN       VARCHAR2,
      address_line3_out      IN       VARCHAR2,
      address_line4_out      IN       VARCHAR2,
      postcode_out           IN       VARCHAR2,
      tele_no_out            IN       VARCHAR2,
      email_addr_out         IN       VARCHAR2,
      hold_payments_out      IN       VARCHAR2,
      hold_letters_out       IN       VARCHAR2,
      mail_returned_out      IN       DATE,
      learner_deceased_out   IN       VARCHAR2,
      grass_checked_in       IN       VARCHAR2,
      steps_checked_in       IN       VARCHAR2,
      ila200_checked_in      IN       VARCHAR2,
      ila500_checked_in      IN       VARCHAR2,
      employee_in            IN       VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2,
      row_count              OUT      VARCHAR2
   );

   PROCEDURE gettitledd (
      io_cursor       IN OUT   title_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getstatusdd (
      io_cursor       IN OUT   status_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getrejectdd (
      io_cursor       IN OUT   reject_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getlearnerapplication (
      learner_application_id_in        IN              VARCHAR2,
      course_id_out                    OUT NOCOPY      VARCHAR2,
      course_type_id_out               OUT NOCOPY      VARCHAR2,
      provider_id_out                  OUT NOCOPY      VARCHAR2,
      application_status_id_out        OUT NOCOPY      VARCHAR2,
      rejection_id_out                 OUT NOCOPY      VARCHAR2,
      total_annual_income_out          OUT NOCOPY      VARCHAR2,
      tot_ann_inc_evid_id_out          OUT NOCOPY      VARCHAR2,
      no_income_out                    OUT NOCOPY      VARCHAR2,
      no_income_evid_id_out            OUT NOCOPY      VARCHAR2,
      job_seekers_allowance_out        OUT NOCOPY      VARCHAR2,
      jsa_evid_id_out                  OUT NOCOPY      VARCHAR2,
      income_support_out               OUT NOCOPY      VARCHAR2,
      inc_sup_evid_id_out              OUT NOCOPY      VARCHAR2,
      incapacity_benefit_out           OUT NOCOPY      VARCHAR2,
      inc_ben_evid_id_out              OUT NOCOPY      VARCHAR2,
      carers_allowance_out             OUT NOCOPY      VARCHAR2,
      carers_allowance_evid_id_out     OUT NOCOPY      VARCHAR2,
      pension_credit_out               OUT NOCOPY      VARCHAR2,
      pension_credit_evid_id_out       OUT NOCOPY      VARCHAR2,
      max_child_tax_credit_out         OUT NOCOPY      VARCHAR2,
      max_child_tc_evid_id_out         OUT NOCOPY      VARCHAR2,
      session_year_out                 OUT NOCOPY      VARCHAR2,
      date_app_recd_out                OUT NOCOPY      DATE,
      date_record_created_out          OUT NOCOPY      DATE,
      date_of_last_calc_out            OUT NOCOPY      DATE,
      course_title_out                 OUT NOCOPY      VARCHAR2,
      course_start_date_out            OUT NOCOPY      DATE,
      length_of_course_out             OUT NOCOPY      VARCHAR2,
      current_course_year_out          OUT NOCOPY      VARCHAR2,
      course_end_date_out              OUT NOCOPY      DATE,
      help_with_fees_out               OUT NOCOPY      VARCHAR2,
      help_amount_out                  OUT NOCOPY      VARCHAR2,
      fee_requested_out                OUT NOCOPY      VARCHAR2,
      provider_signature_present_out   OUT NOCOPY      VARCHAR2,
      date_endorsed_out                OUT NOCOPY      DATE,
      endorsed_by_out                  OUT NOCOPY      VARCHAR2,
      stamped_out                      OUT NOCOPY      VARCHAR2,
      learner_signature_present_out    OUT NOCOPY      VARCHAR2,
      date_signed_out                  OUT NOCOPY      DATE,
      fee_paid_bacs_out                OUT NOCOPY      VARCHAR2,
      payment_date_out                 OUT NOCOPY      DATE,
      recover_fees_out                 OUT NOCOPY      VARCHAR2,
      debt_status_out                  OUT NOCOPY      VARCHAR2,
      fee_calculated_out               OUT NOCOPY      VARCHAR2,
      comments_for_award_letter_out    OUT NOCOPY      VARCHAR2,
      non_attendance_out               OUT NOCOPY      VARCHAR2,
      date_withdrawn_out               OUT NOCOPY      DATE,
      date_actioned_out                OUT NOCOPY      DATE,
      error_boolean                    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                       OUT NOCOPY      VARCHAR2
   );

   FUNCTION getcoursetypeid (
      course_start_date_in   IN   DATE,
      session_year_in        IN   VARCHAR2
   )
      RETURN NUMBER;

   PROCEDURE getcoursetype (
      course_start_date_in   IN              DATE,
      session_year_in        IN              VARCHAR2,
      course_type_id_out     OUT NOCOPY      NUMBER,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setlearnerapplication (
      learner_application_id_in       IN       VARCHAR2,
      course_id_in                    IN       VARCHAR2,
      course_type_id_in               IN       VARCHAR2,
      provider_id_in                  IN       VARCHAR2,
      application_status_id_in        IN       VARCHAR2,
      rejection_id_in                 IN       VARCHAR2,
      total_annual_income_in          IN       VARCHAR2,
      tot_ann_inc_evid_id_in          IN       VARCHAR2,
      no_income_in                    IN       VARCHAR2,
      no_income_evid_id_in            IN       VARCHAR2,
      job_seekers_allowance_in        IN       VARCHAR2,
      jsa_evid_id_in                  IN       VARCHAR2,
      income_support_in               IN       VARCHAR2,
      inc_sup_evid_id_in              IN       VARCHAR2,
      incapacity_benefit_in           IN       VARCHAR2,
      inc_ben_evid_id_in              IN       VARCHAR2,
      carers_allowance_in             IN       VARCHAR2,
      carers_allowance_evid_id_in     IN       VARCHAR2,
      pension_credit_in               IN       VARCHAR2,
      pension_credit_evid_id_in       IN       VARCHAR2,
      max_child_tax_credit_in         IN       VARCHAR2,
      max_child_tc_evid_id_in         IN       VARCHAR2,
      session_year_in                 IN       VARCHAR2,
      course_title_in                 IN       VARCHAR2,
      current_course_year_in          IN       VARCHAR2,
      course_start_date_in            IN       DATE,
      course_end_date_in              IN       DATE,
      length_of_course_in             IN       VARCHAR2,
      help_with_fees_in               IN       VARCHAR2,
      help_amount_in                  IN       VARCHAR2,
      fee_requested_in                IN       VARCHAR2,
      provider_signature_present_in   IN       VARCHAR2,
      date_endorsed_in                IN       DATE,
      endorsed_by_in                  IN       VARCHAR2,
      stamped_in                      IN       VARCHAR2,
      learner_signature_present_in    IN       VARCHAR2,
      date_signed_in                  IN       DATE,
      debt_status_in                  IN       VARCHAR2,
      comments_for_award_letter_in    IN       VARCHAR2,
      employee_in                     IN       VARCHAR2,
      error_boolean                   OUT      VARCHAR2,
      ERROR_TEXT                      OUT      VARCHAR2,
      row_count                       OUT      VARCHAR2
   );

   PROCEDURE getlearningproviderdd (
      io_cursor       IN OUT   learningprovider_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getcoursetypedd (
      io_cursor       IN OUT   coursetype_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getcourseleveldd (
      io_cursor       IN OUT   courselevel_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdebtstatusdd (
      io_cursor       IN OUT   debtstatus_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getincomeeviddd (
      io_cursor       IN OUT   incomeevid_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getdocumentregister (
      learner_id_in   IN       VARCHAR2,
      io_cursor       IN OUT   documentregister_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE updatedocumentregister (
      learner_id_in           IN       VARCHAR2,
      doc_reg_id_in           IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      received_date_in        IN       VARCHAR2,
      session_year_in         IN       VARCHAR2,
      returned_date_in        IN       VARCHAR2,
      last_updated_by_in      IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   );

   PROCEDURE insertdocumentregister (
      learner_id_in           IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      received_date_in        IN       VARCHAR2,
      session_year_in         IN       VARCHAR2,
      returned_date_in        IN       VARCHAR2,
      last_updated_by_in      IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   );

   PROCEDURE deletedocumentregister (
      learner_id_in      IN       VARCHAR2,
      doc_reg_id_in      IN       VARCHAR2,
      deleted_by_id_in   IN       VARCHAR2,
      error_boolean      OUT      VARCHAR2,
      ERROR_TEXT         OUT      VARCHAR2,
      row_count          OUT      VARCHAR2
   );

   PROCEDURE getlearnerorproviderlist (
      type_flag       IN       VARCHAR2,
      search_text1    IN       VARCHAR2,
      search_text2    IN       VARCHAR2,
      io_cursor       IN OUT   learnerorproviderlist_cursor,
      row_count       OUT      VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getalllearnersforprovider (
      provider_id_in   IN       VARCHAR2,
      io_cursor        IN OUT   alllearnerforprovider_cursor,
      row_count        OUT      VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   );

   PROCEDURE getcaseworkernote (
      learner_id_in   IN       VARCHAR2,
      io_cursor       IN OUT   caseworkernote_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE updatecaseworkernote (
      learner_id_in        IN       VARCHAR2,
      cw_note_id_in        IN       VARCHAR2,
      note_type_id_in      IN       VARCHAR2,
      session_year_in      IN       VARCHAR2,
      note_text_in         IN       VARCHAR2,
      last_updated_by_in   IN       VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2,
      row_count            OUT      VARCHAR2
   );

   PROCEDURE insertcaseworkernote (
      reference_id_in      IN       VARCHAR2,
      reference_type_in    IN       VARCHAR2,
      note_type_id_in      IN       VARCHAR2,
      session_year_in      IN       VARCHAR2,
      note_text_in         IN       VARCHAR2,
      last_updated_by_in   IN       VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2,
      row_count            OUT      VARCHAR2
   );

   PROCEDURE getcaseworkernotetype (
      io_cursor       IN OUT   caseworkernotetype_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getconfigdatacurrentsession (
      current_session   OUT   VARCHAR2,
      error_boolean     OUT   VARCHAR2,
      ERROR_TEXT        OUT   VARCHAR2
   );

   PROCEDURE learnerorprovider (
      reference_id_in         IN       VARCHAR2,
      learnerorproviderflag   OUT      VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2
   );

   PROCEDURE getapplications (
      learner_id_in   IN              VARCHAR2,
      io_cursor       IN OUT          application_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getawardnoticedets (
      learner_application_id_in       IN       VARCHAR2,
      learner_id_out                  OUT      VARCHAR2,
      title_out                       OUT      VARCHAR2,
      forenames_out                   OUT      VARCHAR2,
      surname_out                     OUT      VARCHAR2,
      housename_no_out                OUT      VARCHAR2,
      address_line1_out               OUT      VARCHAR2,
      address_line2_out               OUT      VARCHAR2,
      address_line3_out               OUT      VARCHAR2,
      address_line4_out               OUT      VARCHAR2,
      postcode_out                    OUT      VARCHAR2,
      mailsort_out                    OUT      VARCHAR2,
      hold_letters_out                OUT      VARCHAR2,
      session_year_out                OUT      VARCHAR2,
      provider_out                    OUT      VARCHAR2,
      course_name_out                 OUT      VARCHAR2,
      qualification_out               OUT      VARCHAR2,
      course_year_out                 OUT      VARCHAR2,
      fee_calculated_out              OUT      VARCHAR2,
      comments_for_award_letter_out   OUT      VARCHAR2,
      error_boolean                   OUT      VARCHAR2,
      ERROR_TEXT                      OUT      VARCHAR2
   );

   PROCEDURE getlearnerproviderrecord (
      provider_id_in                  IN       VARCHAR2,
      provider_name                   OUT      VARCHAR2,
      provider_house_no_or_name       OUT      VARCHAR2,
      provider_addr_l1                OUT      VARCHAR2,
      provider_addr_l2                OUT      VARCHAR2,
      provider_addr_l3                OUT      VARCHAR2,
      provider_addr_l4                OUT      VARCHAR2,
      provider_post_code              OUT      VARCHAR2,
      provider_tel_no                 OUT      VARCHAR2,
      provider_fax_no                 OUT      VARCHAR2,
      bank_sort_code                  OUT      VARCHAR2,
      bank_account_no                 OUT      VARCHAR2,
      main_contact_name               OUT      VARCHAR2,
      main_contact_position           OUT      VARCHAR2,
      main_contact_house_no_or_name   OUT      VARCHAR2,
      main_contact_addr_l1            OUT      VARCHAR2,
      main_contact_addr_l2            OUT      VARCHAR2,
      main_contact_addr_l3            OUT      VARCHAR2,
      main_contact_addr_l4            OUT      VARCHAR2,
      main_contact_post_code          OUT      VARCHAR2,
      main_contact_tel_no             OUT      VARCHAR2,
      main_contact_fax_no             OUT      VARCHAR2,
      main_contact_email              OUT      VARCHAR2,
      fin_contact_name                OUT      VARCHAR2,
      fin_contact_position            OUT      VARCHAR2,
      fin_contact_house_no_or_name    OUT      VARCHAR2,
      fin_contact_addr_l1             OUT      VARCHAR2,
      fin_contact_addr_l2             OUT      VARCHAR2,
      fin_contact_addr_l3             OUT      VARCHAR2,
      fin_contact_addr_l4             OUT      VARCHAR2,
      fin_contact_post_code           OUT      VARCHAR2,
      fin_contact_tel_no              OUT      VARCHAR2,
      fin_contact_fax_no              OUT      VARCHAR2,
      fin_contact_email               OUT      VARCHAR2,
      suspend_payments                OUT      VARCHAR2,
      suspend_letters                 OUT      VARCHAR2,
      prov_type_id                    OUT      VARCHAR2,
      prov_status_id                  OUT      VARCHAR2,
      record_creation_date            OUT      VARCHAR2,
      last_updated_by                 OUT      VARCHAR2,
      last_updated_on                 OUT      VARCHAR2,
      outstanding_amount              OUT      VARCHAR2,
      securezip_password              OUT      VARCHAR2,
      error_boolean                   OUT      VARCHAR2,
      ERROR_TEXT                      OUT      VARCHAR2
   );

   PROCEDURE updatelearnerproviderrecord (
      provider_id_in              IN       VARCHAR2,
      provider_name_in            IN       VARCHAR2,
      provider_house_in           IN       VARCHAR2,
      provider_addr_l1_in         IN       VARCHAR2,
      provider_addr_l2_in         IN       VARCHAR2,
      provider_addr_l3_in         IN       VARCHAR2,
      provider_addr_l4_in         IN       VARCHAR2,
      provider_post_code_in       IN       VARCHAR2,
      provider_tel_no_in          IN       VARCHAR2,
      provider_fax_no_in          IN       VARCHAR2,
      bank_sort_code_in           IN       VARCHAR2,
      bank_account_no_in          IN       VARCHAR2,
      main_contact_name_in        IN       VARCHAR2,
      main_contact_position_in    IN       VARCHAR2,
      main_contact_house_in       IN       VARCHAR2,
      main_contact_addr_l1_in     IN       VARCHAR2,
      main_contact_addr_l2_in     IN       VARCHAR2,
      main_contact_addr_l3_in     IN       VARCHAR2,
      main_contact_addr_l4_in     IN       VARCHAR2,
      main_contact_post_code_in   IN       VARCHAR2,
      main_contact_tel_no_in      IN       VARCHAR2,
      main_contact_fax_no_in      IN       VARCHAR2,
      main_contact_email_in       IN       VARCHAR2,
      fin_contact_name_in         IN       VARCHAR2,
      fin_contact_position_in     IN       VARCHAR2,
      fin_contact_house_in        IN       VARCHAR2,
      fin_contact_addr_l1_in      IN       VARCHAR2,
      fin_contact_addr_l2_in      IN       VARCHAR2,
      fin_contact_addr_l3_in      IN       VARCHAR2,
      fin_contact_addr_l4_in      IN       VARCHAR2,
      fin_contact_post_code_in    IN       VARCHAR2,
      fin_contact_tel_no_in       IN       VARCHAR2,
      fin_contact_fax_no_in       IN       VARCHAR2,
      fin_contact_email_in        IN       VARCHAR2,
      suspend_payments_in         IN       VARCHAR2,
      suspend_letters_in          IN       VARCHAR2,
      prov_type_id_in             IN       VARCHAR2,
      prov_status_id_in           IN       VARCHAR2,
      last_updated_by_in          IN       VARCHAR2,
      outstanding_amount_in       IN       VARCHAR2,
      securezip_password_in       IN       VARCHAR2,
      error_boolean               OUT      VARCHAR2,
      ERROR_TEXT                  OUT      VARCHAR2,
      row_count                   OUT      VARCHAR2
   );

   PROCEDURE getprovidertypelist (
      io_cursor       IN OUT   providertype_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getproviderstatuslist (
      io_cursor       IN OUT   providerstatus_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getnextpaymentdate (
      payment_date    OUT   VARCHAR2,
      error_boolean   OUT   VARCHAR2,
      ERROR_TEXT      OUT   VARCHAR2
   );

   PROCEDURE getlatestproviderreportdates (
      provider_id_in             IN       VARCHAR2,
      last_payment_report_date   OUT      VARCHAR2,
      last_status_report_date    OUT      VARCHAR2,
      error_boolean              OUT      VARCHAR2,
      ERROR_TEXT                 OUT      VARCHAR2
   );

   PROCEDURE getproviderpaymentdetails (
      provider_id_in   IN       VARCHAR2,
      io_cursor        IN OUT   providerpayments_cursor,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   );

   PROCEDURE updateproviderpaymentdetails (
      provider_payment_id_in   IN       VARCHAR2,
      payment_method_id_in     IN       VARCHAR2,
      payment_status_id_in     IN       VARCHAR2,
      re_issue_payment_in      IN       VARCHAR2,
      last_updated_by_in       IN       VARCHAR2,
      error_boolean            OUT      VARCHAR2,
      ERROR_TEXT               OUT      VARCHAR2,
      row_count                OUT      VARCHAR2
   );

   PROCEDURE getpaymentstatuslist (
      io_cursor       IN OUT   payment_status_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getpaymentmethodlist (
      io_cursor       IN OUT   payment_method_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getlearnercheckdets (
      learner_application_id_in   IN              VARCHAR2,
      learner_id_in               IN              VARCHAR2,
      forenames_out               OUT NOCOPY      VARCHAR2,
      surname_out                 OUT NOCOPY      VARCHAR2,
      dob_out                     OUT NOCOPY      VARCHAR2,
      session_out                 OUT NOCOPY      VARCHAR2,
      error_boolean               OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getprovidername (
      provider_id_in      IN              VARCHAR2,
      provider_name_out   OUT NOCOPY      VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getproviderdebt (
      provider_id_in   IN       VARCHAR2,
      provider_debt    OUT      VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   );

   PROCEDURE checkforoutstandingapplication (
      learner_id_in            IN       VARCHAR2,
      count_outstanding_apps   OUT      VARCHAR2,
      error_boolean            OUT      VARCHAR2,
      ERROR_TEXT               OUT      VARCHAR2
   );
END pk_steps_pt_ui;
/