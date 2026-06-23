CREATE OR REPLACE PACKAGE ILA500.pk_payments
IS
-- DESCRIPTION
-- ===========
--
/*
PK_PAYMENTS
This stored procedure's purpose is to generate records for the individual
provider payments in PROVIDER_PAYMENT tables as well as record for the total
payment in ADI_PAYMENT for the current fee run. The logic of the procedure
could be summarized in the following sentences: For each learning provider,
for which learner applications exists in status 'Calculated', aggregate the
learner payments for those applications and create summary record in
PROVIDER_PAYMENT table. The applications which payments should be summarized
must be limited to those, whose courses fall into the scope of the current fee
run, i.e. the start_date of their course is between the fee_start_date and
fee_end_date for the current batch run and their course type corresponds to the
current batch run (the current date of the batch run equals the batch_run_date
of the course type). For each provider with calculated total in the current run
a record in PROVIDER_PAYMENT should be created. After all providers are
processed, a total for all provider should be produced and a record created in
ADI_PAYMENT table.
*/
-- Modification History
-- Date                 Author      Ref    Desc
-- 05.08.2008           R Hunter    001    Initial Creation
-- 29.08.2008           A Bowman    002    Updated as learner_application column names were changed
-- 09.06.2009           A Anchev    003    Added function for retrieval of current ILA500 session
---08.12.2009           P Hughes    004    Added new function update_course_type
-- 16.12.2009           P Hughes    005    get_app_paymentPaymentReports Function Added
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/release/ILA500/ila500-0903/PK_PAYMENTS.pks $
-- $Author: $
-- $Date: 2009-01-21 14:22:42 +0000 (Wed, 21 Jan 2009) $
-- $Revision: 2143 $
--
   PROCEDURE process_standard_payments;

   PROCEDURE create_adi_payment (adi_total_payment IN NUMBER);

   FUNCTION get_app_payment (
      p_appid   IN   learner_application.learner_application_id%TYPE
   )
      RETURN NUMBER;
      
   FUNCTION get_app_paymentPaymentReports(
      p_appid   IN   learner_application.learner_application_id%TYPE
   )
      RETURN NUMBER;

   FUNCTION has_pending_payments (
      p_appid   IN   learner_application.learner_application_id%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_updated_status (
      p_appid   IN   learner_application.learner_application_id%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_payment_status (
      p_appid   IN   learner_application.learner_application_id%TYPE
   )
      RETURN VARCHAR2;

   PROCEDURE email_error (error_message IN VARCHAR2);

   FUNCTION previous_run_date
      RETURN VARCHAR2;

   PROCEDURE update_learner_appl_nvl (
      pi_learner_id                   IN   VARCHAR2,
      pi_course_id                    IN   VARCHAR2,
      pi_course_type_id               IN   VARCHAR2,
      pi_provider_id                  IN   VARCHAR2,
      pi_application_status_id        IN   VARCHAR2,
      pi_rejection_id                 IN   VARCHAR2,
      pi_total_annual_income          IN   VARCHAR2,
      pi_tot_ann_inc_evid_id          IN   VARCHAR2,
      pi_no_income                    IN   VARCHAR2,
      pi_no_income_evid_id            IN   VARCHAR2,
      pi_job_seekers_allowance        IN   VARCHAR2,
      pi_jsa_evid_id                  IN   VARCHAR2,
      pi_income_support               IN   VARCHAR2,
      pi_inc_sup_evid_id              IN   VARCHAR2,
      pi_incapacity_benefit           IN   VARCHAR2,
      pi_inc_ben_evid_id              IN   VARCHAR2,
      pi_carers_allowance             IN   VARCHAR2,
      pi_carers_allowance_evid_id     IN   VARCHAR2,
      pi_pension_credit               IN   VARCHAR2,
      pi_pension_credit_evid_id       IN   VARCHAR2,
      pi_mct                          IN   VARCHAR2,
      pi_mct_evid_id                  IN   VARCHAR2,
      pi_session_year                 IN   VARCHAR2,
      pi_date_app_recd                IN   VARCHAR2,
      pi_date_record_created          IN   VARCHAR2,
      pi_date_of_last_calc            IN   VARCHAR2,
      pi_course_title                 IN   VARCHAR2,
      pi_course_start_date            IN   VARCHAR2,
      pi_length_of_course             IN   VARCHAR2,
      pi_current_course_year          IN   VARCHAR2,
      pi_course_end_date              IN   VARCHAR2,
      pi_help_with_fees               IN   VARCHAR2,
      pi_help_amount                  IN   VARCHAR2,
      pi_fee_requested                IN   VARCHAR2,
      pi_provider_signature_present   IN   VARCHAR2,
      pi_endorsed_by                  IN   VARCHAR2,
      pi_date_endorsed                IN   VARCHAR2,
      pi_stamped                      IN   VARCHAR2,
      pi_learner_signature_present    IN   VARCHAR2,
      pi_date_signed                  IN   VARCHAR2,
      pi_fee_paid_bacs                IN   VARCHAR2,
      pi_payment_date                 IN   VARCHAR2,
      pi_recover_fees                 IN   VARCHAR2,
      pi_debt_status                  IN   VARCHAR2,
      pi_fee_calculated               IN   VARCHAR2,
      pi_comments_for_award_letter    IN   VARCHAR2,
      pi_award_letter_duplicate       IN   VARCHAR2,
      pi_non_attendance               IN   VARCHAR2,
      pi_date_withdrawn               IN   VARCHAR2,
      pi_date_actioned                IN   VARCHAR2,
      pi_last_updated_by              IN   VARCHAR2,
      pi_learner_application_id       IN   VARCHAR2,
      pi_last_letter_generated        IN   VARCHAR2
   );

   PROCEDURE update_learner_payment_nvl (
      pi_provider_payment_id   IN   NUMBER,
      pi_transaction_type_id   IN   NUMBER,
      pi_payment_status_id     IN   NUMBER,
      pi_amount                IN   NUMBER,
      pi_last_updated_by       IN   VARCHAR2,
      pi_learner_payment_id    IN   NUMBER
   );

   PROCEDURE insert_prov_stat_hist (
      p_provider_id   IN   provider.provider_id%TYPE
   );

   FUNCTION provider_balance (p_provider_id IN provider.provider_id%TYPE)
      RETURN NUMBER;
      
    --New procedure to update the course_type value in the learner_application table
   PROCEDURE update_course_type (
   p_learner_id IN VARCHAR2);   
   

   PROCEDURE update_prov_bal (
      p_provider_id   IN   provider.provider_id%TYPE,
      p_amount             NUMBER
   );

   PROCEDURE update_learning_provider_nvl (
      pi_provider_id                 IN   VARCHAR2,
      pi_provider_name               IN   VARCHAR2,
      pi_provider_house_noname       IN   VARCHAR2,
      pi_provider_addr_l1            IN   VARCHAR2,
      pi_provider_addr_l2            IN   VARCHAR2,
      pi_provider_addr_l3            IN   VARCHAR2,
      pi_provider_addr_l4            IN   VARCHAR2,
      pi_provider_post_code          IN   VARCHAR2,
      pi_provider_tel_no             IN   VARCHAR2,
      pi_provider_fax_no             IN   VARCHAR2,
      pi_bank_sort_code              IN   VARCHAR2,
      pi_bank_account_no             IN   VARCHAR2,
      pi_main_contact_name           IN   VARCHAR2,
      pi_main_contact_position       IN   VARCHAR2,
      pi_main_contact_house_noname   IN   VARCHAR2,
      pi_main_contact_addr_l1        IN   VARCHAR2,
      pi_main_contact_addr_l2        IN   VARCHAR2,
      pi_main_contact_addr_l3        IN   VARCHAR2,
      pi_main_contact_addr_l4        IN   VARCHAR2,
      pi_main_contact_post_code      IN   VARCHAR2,
      pi_main_contact_tel_no         IN   VARCHAR2,
      pi_main_contact_fax_no         IN   VARCHAR2,
      pi_main_contact_email          IN   VARCHAR2,
      pi_fin_contact_name            IN   VARCHAR2,
      pi_fin_contact_position        IN   VARCHAR2,
      pi_fin_contact_house_noname    IN   VARCHAR2,
      pi_fin_contact_addr_l1         IN   VARCHAR2,
      pi_fin_contact_addr_l2         IN   VARCHAR2,
      pi_fin_contact_addr_l3         IN   VARCHAR2,
      pi_fin_contact_addr_l4         IN   VARCHAR2,
      pi_fin_contact_post_code       IN   VARCHAR2,
      pi_fin_contact_tel_no          IN   VARCHAR2,
      pi_fin_contact_fax_no          IN   VARCHAR2,
      pi_fin_contact_email           IN   VARCHAR2,
      pi_suspend_payments            IN   VARCHAR2,
      pi_suspend_letters             IN   VARCHAR2,
      pi_provider_type_id            IN   VARCHAR2,
      pi_provider_status_id          IN   VARCHAR2,
      pi_last_updated_by             IN   VARCHAR2,
      pi_outstanding_balance         IN   NUMBER
   );

   PROCEDURE insert_learner_appl(
      pi_learner_id                   IN VARCHAR2,
      pi_course_id                    IN VARCHAR2,
      pi_course_type_id               IN VARCHAR2,
      pi_provider_id                  IN VARCHAR2,
      pi_application_status_id        IN VARCHAR2,
      pi_rejection_id                 IN VARCHAR2,
      pi_total_annual_income          IN VARCHAR2,
      pi_tot_ann_inc_evid_id          IN VARCHAR2,
      pi_no_income                    IN VARCHAR2,
      pi_no_income_evid_id            IN VARCHAR2,
      pi_job_seekers_allowance        IN VARCHAR2,
      pi_jsa_evid_id                  IN VARCHAR2,
      pi_income_support               IN VARCHAR2,
      pi_inc_sup_evid_id              IN VARCHAR2,
      pi_incapacity_benefit           IN VARCHAR2,
      pi_inc_ben_evid_id              IN VARCHAR2,
      pi_carers_allowance             IN VARCHAR2,
      pi_carers_allowance_evid_id     IN VARCHAR2,
      pi_pension_credit               IN VARCHAR2,
      pi_pension_credit_evid_id       IN VARCHAR2,
      pi_mct                          IN VARCHAR2,
      pi_mct_evid_id                  IN VARCHAR2,
      pi_session_year                 IN VARCHAR2,
      pi_date_app_recd                IN VARCHAR2,
      pi_date_record_created          IN VARCHAR2,
      pi_date_of_last_calc            IN VARCHAR2,
      pi_course_title                 IN VARCHAR2,
      pi_course_start_date            IN VARCHAR2,
      pi_length_of_course             IN VARCHAR2,
      pi_current_course_year          IN VARCHAR2,
      pi_course_end_date              IN VARCHAR2,
      pi_help_with_fees               IN VARCHAR2,
      pi_help_amount                  IN VARCHAR2,
      pi_fee_requested                IN VARCHAR2,
      pi_provider_signature_present   IN VARCHAR2,
      pi_endorsed_by                  IN VARCHAR2,
      pi_date_endorsed                IN VARCHAR2,
      pi_stamped                      IN VARCHAR2,
      pi_learner_signature_present    IN VARCHAR2,
      pi_date_signed                  IN VARCHAR2,
      pi_fee_paid_bacs                IN VARCHAR2,
      pi_payment_date                 IN VARCHAR2,
      pi_recover_fees                 IN VARCHAR2,
      pi_debt_status                  IN VARCHAR2,
      pi_fee_calculated               IN VARCHAR2,
      pi_comments_for_award_letter    IN VARCHAR2,
      pi_award_letter_duplicate       IN VARCHAR2,
      pi_non_attendance               IN VARCHAR2,
      pi_date_withdrawn               IN VARCHAR2,
      pi_date_actioned                IN VARCHAR2,
      pi_last_updated_by              IN VARCHAR2,
      po_learner_application_id       OUT learner_application.learner_application_id%TYPE
   );

   FUNCTION get_current_session RETURN NUMBER;

END pk_payments;
/
