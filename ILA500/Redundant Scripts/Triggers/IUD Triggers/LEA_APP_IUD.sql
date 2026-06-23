/* Formatted on 2008/10/16 10:01 (Formatter Plus v4.8.8) */
-- TRIGGER: LEA_APP_IUD
-- TABLE: LEARNER_APPLICATION
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
-- 002      16.07.2008    A.Bowman (SAAS)         p_column_name changed to upper case.
-- 003      28.08.2008    A.Bowman (SAAS)         3 column names changed so trigger req'd update also
-- 004      16.10.2008    A.Bowman (SAAS)         Added telephony functionality
-- 005      29.01.2009    A.Bowman (SAAS)         Added last_letter_generated column
-- 006      04.06.2009    A.Bowman (SAAS)         Telephony functionality removed, no longer required, surprise surprise
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/LEA_APP_IUD.sql $
-- $Author: $
-- $Date: 2009-06-04 09:13:28 +0100 (Thu, 04 Jun 2009) $
-- $Revision: 3097 $
--
CREATE OR REPLACE TRIGGER ILA500.lea_app_iud
   AFTER DELETE OR INSERT OR UPDATE OF learner_application_id,
                                       learner_id,
                                       course_id,
                                       course_type_id,
                                       provider_id,
                                       application_status_id,
                                       rejection_id,
                                       total_annual_income,
                                       tot_ann_inc_evid_id,
                                       no_income,
                                       no_income_evid_id,
                                       job_seekers_allowance,
                                       jsa_evid_id,
                                       income_support,
                                       inc_sup_evid_id,
                                       incapacity_benefit,
                                       inc_ben_evid_id,
                                       carers_allowance,
                                       carers_allowance_evid_id,
                                       pension_credit,
                                       pension_credit_evid_id,
                                       max_child_tax_credit,
                                       max_child_tax_credit_evid_id,
                                       session_year,
                                       date_app_recd,
                                       date_record_created,
                                       date_of_last_calc,
                                       course_title,
                                       course_start_date,
                                       length_of_course,
                                       current_course_year,
                                       course_end_date,
                                       help_with_fees,
                                       help_amount,
                                       fee_requested,
                                       provider_signature_present,
                                       endorsed_by,
                                       date_endorsed,
                                       stamped,
                                       learner_signature_present,
                                       date_signed,
                                       fee_paid_bacs,
                                       payment_date,
                                       recover_fees,
                                       debt_status,
                                       fee_calculated,
                                       last_letter_generated,
                                       comments_for_award_letter,
                                       award_letter_duplicate,
                                       non_attendance,
                                       date_withdrawn,
                                       date_actioned
   ON ILA500.LEARNER_APPLICATION    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                       := SYSDATE;
   p_column_name   learner_application_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_application_aud.primary_key%TYPE
                                               := :OLD.learner_application_id;
   p_old           learner_application_aud.OLD%TYPE           := NULL;
   p_new           learner_application_aud.NEW%TYPE           := NULL;
   p_action        learner_application_aud.action%TYPE        := NULL;
   p_username      learner_application_aud.username%TYPE      := USER;
   p_learner_id    learner.learner_id%TYPE                 := :OLD.learner_id;
   p_table_name    VARCHAR2 (32)                     := 'LEARNER_APPLICATION';
   v_updated       VARCHAR2 (1)                               := 'N';
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.learner_application_id;
      p_learner_id := :NEW.learner_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'LEARNER_APPLICATION_ID';
   p_old := :OLD.learner_application_id;
   p_new := :NEW.learner_application_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LEARNER_ID';
   p_old := :OLD.learner_id;
   p_new := :NEW.learner_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_ID';
   p_old := :OLD.course_id;
   p_new := :NEW.course_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_TYPE_ID';
   p_old := :OLD.course_type_id;
   p_new := :NEW.course_type_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PROVIDER_ID';
   p_old := :OLD.provider_id;
   p_new := :NEW.provider_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'APPLICATION_STATUS_ID';
   p_old := :OLD.application_status_id;
   p_new := :NEW.application_status_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'REJECTION_ID';
   p_old := :OLD.rejection_id;
   p_new := :NEW.rejection_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'TOTAL_ANNUAL_INCOME';
   p_old := :OLD.total_annual_income;
   p_new := :NEW.total_annual_income;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'TOT_ANN_INC_EVID_ID';
   p_old := :OLD.tot_ann_inc_evid_id;
   p_new := :NEW.tot_ann_inc_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NO_INCOME';
   p_old := :OLD.no_income;
   p_new := :NEW.no_income;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NO_INCOME_EVID_ID';
   p_old := :OLD.no_income_evid_id;
   p_new := :NEW.no_income_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'JOB_SEEKERS_ALLOWANCE';
   p_old := :OLD.job_seekers_allowance;
   p_new := :NEW.job_seekers_allowance;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'JSA_EVID_ID';
   p_old := :OLD.jsa_evid_id;
   p_new := :NEW.jsa_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'INCOME_SUPPORT';
   p_old := :OLD.income_support;
   p_new := :NEW.income_support;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'INC_SUP_EVID_ID';
   p_old := :OLD.inc_sup_evid_id;
   p_new := :NEW.inc_sup_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'INCAPACITY_BENEFIT';
   p_old := :OLD.incapacity_benefit;
   p_new := :NEW.incapacity_benefit;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'INC_BEN_EVID_ID';
   p_old := :OLD.inc_ben_evid_id;
   p_new := :NEW.inc_ben_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'CARERS_ALLOWANCE';
   p_old := :OLD.carers_allowance;
   p_new := :NEW.carers_allowance;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'CARERS_ALLOWANCE_EVID_ID';
   p_old := :OLD.carers_allowance_evid_id;
   p_new := :NEW.carers_allowance_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PENSION_CREDIT';
   p_old := :OLD.pension_credit;
   p_new := :NEW.pension_credit;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PENSION_CREDIT_EVID_ID';
   p_old := :OLD.pension_credit_evid_id;
   p_new := :NEW.pension_credit_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'MAX_CHILD_TAX_CREDIT';
   p_old := :OLD.max_child_tax_credit;
   p_new := :NEW.max_child_tax_credit;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'MAX_CHILD_TAX_CREDIT_EVID_ID';
   p_old := :OLD.max_child_tax_credit_evid_id;
   p_new := :NEW.max_child_tax_credit_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'SESSION_YEAR';
   p_old := :OLD.session_year;
   p_new := :NEW.session_year;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_APP_RECD';
   p_old := :OLD.date_app_recd;
   p_new := :NEW.date_app_recd;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_RECORD_CREATED';
   p_old := :OLD.date_record_created;
   p_new := :NEW.date_record_created;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_OF_LAST_CALC';
   p_old := :OLD.date_of_last_calc;
   p_new := :NEW.date_of_last_calc;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_TITLE';
   p_old := :OLD.course_title;
   p_new := :NEW.course_title;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_START_DATE';
   p_old := :OLD.course_start_date;
   p_new := :NEW.course_start_date;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LENGTH_OF_COURSE';
   p_old := :OLD.length_of_course;
   p_new := :NEW.length_of_course;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'CURRENT_COURSE_YEAR';
   p_old := :OLD.current_course_year;
   p_new := :NEW.current_course_year;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_END_DATE';
   p_old := :OLD.course_end_date;
   p_new := :NEW.course_end_date;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'HELP_WITH_FEES';
   p_old := :OLD.help_with_fees;
   p_new := :NEW.help_with_fees;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'HELP_AMOUNT';
   p_old := :OLD.help_amount;
   p_new := :NEW.help_amount;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'FEE_REQUESTED';
   p_old := :OLD.fee_requested;
   p_new := :NEW.fee_requested;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PROVIDER_SIGNATURE_PRESENT';
   p_old := :OLD.provider_signature_present;
   p_new := :NEW.provider_signature_present;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'ENDORSED_BY';
   p_old := :OLD.endorsed_by;
   p_new := :NEW.endorsed_by;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_ENDORSED';
   p_old := :OLD.date_endorsed;
   p_new := :NEW.date_endorsed;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'STAMPED';
   p_old := :OLD.stamped;
   p_new := :NEW.stamped;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LEARNER_SIGNATURE_PRESENT';
   p_old := :OLD.learner_signature_present;
   p_new := :NEW.learner_signature_present;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_SIGNED';
   p_old := :OLD.date_signed;
   p_new := :NEW.date_signed;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'FEE_PAID_BACS';
   p_old := :OLD.fee_paid_bacs;
   p_new := :NEW.fee_paid_bacs;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PAYMENT_DATE';
   p_old := :OLD.payment_date;
   p_new := :NEW.payment_date;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'RECOVER_FEES';
   p_old := :OLD.recover_fees;
   p_new := :NEW.recover_fees;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DEBT_STATUS';
   p_old := :OLD.debt_status;
   p_new := :NEW.debt_status;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'FEE_CALCULATED';
   p_old := :OLD.fee_calculated;
   p_new := :NEW.fee_calculated;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LAST_LETTER_GENERATED';
   p_old := :OLD.last_letter_generated;
   p_new := :NEW.last_letter_generated;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COMMENTS_FOR_AWARD_LETTER';
   p_old := :OLD.comments_for_award_letter;
   p_new := :NEW.comments_for_award_letter;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'AWARD_LETTER_DUPLICATE';
   p_old := :OLD.award_letter_duplicate;
   p_new := :NEW.award_letter_duplicate;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NON_ATTENDANCE';
   p_old := :OLD.non_attendance;
   p_new := :NEW.non_attendance;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_WITHDRAWN';
   p_old := :OLD.date_withdrawn;
   p_new := :NEW.date_withdrawn;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_ACTIONED';
   p_old := :OLD.date_actioned;
   p_new := :NEW.date_actioned;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END lea_app_iud;
/