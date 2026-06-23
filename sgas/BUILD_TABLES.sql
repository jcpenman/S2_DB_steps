-- Build script to control creation of tables required in the STEPS database SGAS schema.
--
-- If running into a new schema then the scripts will generate errors as they attempt to drop non-existant objects. 
-- If the script is run twice the first run will generate errors trying to drop non-existant objects; ignore all errors and allow the script to complete,
-- The second run should be error-free.
-- Alternatively scan the log from the first run to ensure no unexpected errors were encountered.
--
-- MODIFICATION HISTORY
-- Ref.     Date            Author                          Desc.
--          08/01/2008  S Durkin (Sopra UK)     Initial Version
-- 001      08/12/2008  A.Bowman (SAAS)         Added Audit tables
-- 002      06/01/2009  A.Bowman (SAAS)         Added new tables for Payments solution
-- 003      15/01/2009  A.Bowman (SAAS)         Added new Audit tables for Payments 
-- 004      02/02/2009  A.Bowman (SAAS)         Added new Audit table for payment error codes
-- 005      03/03/2009  A.Bowman (SAAS)         Remove redundant payment tables
-- 006      14/04/2009  A.Bowman (SAAS)         Removed all new payment related tables, new solution to be developed
-- 007      09/06/2009  A.Bowman (SAAS)         Added Contact_Relationship and aud table
-- 008      07/07/2009  A.Bowman (SAAS)         Added reference data and ref data aud tables
-- 009      08/07/2009  A.Bowman (SAAS)         Added NMSB_SPEC_ARR table which was missing from this script
-- 010      09/07/2009  A.Bowman (SAAS)         Added tables DLA_REQUEST,AUTHENTICATE_STUD and AUTHENTICATE_STUD_AUD as part of WEB Data SYnc changes for StEPS
-- 011      16/07/2009  A.Bowman (SAAS)         Added more ref data and ref data aud tables
-- 012      21/07/2009	A.Bowman (SAAS)         Removed AUD table as it is no longer required
-- 013      27/08/2009  A.Bowman (SAAS)         Added stud_term_addr_aud table, created to meet History requirements
-- 014      15/09/2009  A.Bowman (SAAS)         Commented out Nominees table as it is no longer required
-- 015      31/05/2010  A.Bowman (SAAS)         Updated this script to reflect the current position in SIT
-- 016      03/08/2010	A.Bowman (SAAS)         Updated this script to reflect the current position of DEV database which is awaiting release to SIT
-- 017      22/10/2010  A.Bowman (SAAS)         Updated the script whilst testing running it in new environment
-- 018      25/11/2010  A.Bowman (SAAS)         Updated the script in light of errrors whilst testing running it in new environment
-- 019      26/11/2010  A.Bowman (SAAS)         Updated this script to reflect the current position in SIT
-- 020      07/03/2011  A.Bowman (SAAS)         Updated this script to reflect the current position in SIT after drop 25  
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/BUILD_TABLES.sql $
-- $Author: $
-- $Date: 2011-08-15 10:39:03 +0100 (Mon, 15 Aug 2011) $
-- $Revision: 7283 $

SPOOL BUILD_SGAS.out
SELECT Sysdate FROM dual;
SET DEFINE OFF;

PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT *************** BUILD REFERENCE DATA TABLES *******************************
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT *** Creating tables/AWARD_REF_DATA.sql
@tables/AWARD_REF_DATA.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/BEN_INCOME_STATUS.sql
@tables/BEN_INCOME_STATUS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/BEN_INCOME_TYPE.sql
@tables/BEN_INCOME_TYPE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/CASE_STATUS.sql
@tables/CASE_STATUS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/CONTACT_RELATIONSHIP.sql
@tables/CONTACT_RELATIONSHIP.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/COUNTRY.sql
@tables/COUNTRY.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DEARING_STATUS.sql
@tables/DEARING_STATUS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DEBT_STATUS.sql
@tables/DEBT_STATUS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DISABILITY_TYPE.sql
@tables/DISABILITY_TYPE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DOCUMENT_TYPE.sql
@tables/DOCUMENT_TYPE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/EMPLOYMENT_STATUS.sql
@tables/EMPLOYMENT_STATUS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/INST_LOCATION.sql
@tables/INST_LOCATION.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/LOAN_STATUS.sql
@tables/LOAN_STATUS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/LOCATION.sql
@tables/LOCATION.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/MARITAL_STATUS.sql
@tables/MARITAL_STATUS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/NO_NINO_REASON.sql
@tables/NO_NINO_REASON.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/OTHER_LOAN_TYPE.sql
@tables/OTHER_LOAN_TYPE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/REFERENCE_DATA.sql
@tables/REFERENCE_DATA.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/REFERENCE_DOMAINS.sql
@tables/REFERENCE_DOMAINS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/REFERENCE_TYPES.sql
@tables/REFERENCE_TYPES.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/RESIDENCE.sql
@tables/RESIDENCE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/RESIDENCE_CATEGORY.sql
@tables/RESIDENCE_CATEGORY.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/RESIDENCE_TYPE.sql
@tables/RESIDENCE_TYPE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/SCHEME_TYPE.sql
@tables/SCHEME_TYPE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/SPOUSE_TYPE.sql
@tables/SPOUSE_TYPE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/SUPP_GRANT_RELATION.sql
@tables/SUPP_GRANT_RELATION.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/TITLE.sql
@tables/TITLE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/Z_REFUSAL_STATUS.sql
@tables/Z_REFUSAL_STATUS.sql
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT ******************** BUILD STUDENT TABLES *********************************
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD.sql
@tables/STUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/BENEFACTOR.sql
@tables/BENEFACTOR.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/BENEFACTOR_DEPENDANT.sql
@tables/BENEFACTOR_DEPENDANT.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/BENEFACTOR_INCOME.sql
@tables/BENEFACTOR_INCOME.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/BENEFACTOR_RELATION.sql
@tables/BENEFACTOR_RELATION.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/JA_CASE.sql
@tables/JA_CASE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_APP_PROG.sql
@tables/STUD_APP_PROG.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_AWARD_TYPE.sql
@tables/STUD_AWARD_TYPE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_CONT_DETAILS.sql
@tables/STUD_CONT_DETAILS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_CRSE_YEAR.sql
@tables/STUD_CRSE_YEAR.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_DEPENDANT.sql
@tables/STUD_DEPENDANT.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_HOME_ADDR.sql
@tables/STUD_HOME_ADDR.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_NOMINEE.sql
@tables/STUD_NOMINEE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_NOTES.sql
@tables/STUD_NOTES.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_RATE.sql
@tables/STUD_RATE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_SESSION.sql
@tables/STUD_SESSION.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_TERM_ADDR.sql
@tables/STUD_TERM_ADDR.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_TRACK.sql
@tables/STUD_TRACK.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_TRAV_PROG.sql
@tables/STUD_TRAV_PROG.sql
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT ********************* BUILD DSA TABLES ************************************
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_ALLOWANCE.sql
@tables/DSA_ALLOWANCE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_APPLICATION.sql
@tables/DSA_APPLICATION.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_ASSESSMENT_CENTRE.sql
@tables/DSA_ASSESSMENT_CENTRE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_CATEGORY.sql
@tables/DSA_CATEGORY.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_PAYMENT.sql
@tables/DSA_PAYMENT.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_PAYMENT_STATUS.sql
@tables/DSA_PAYMENT_STATUS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_REFERRAL_REASON.sql
@tables/DSA_REFERRAL_REASON.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_REJECTION_REASON.sql
@tables/DSA_REJECTION_REASON.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_STUDENT_TYPE.sql
@tables/DSA_STUDENT_TYPE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_TYPE.sql
@tables/DSA_TYPE.sql
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT ********************* BUILD AWARD TABLES **********************************
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT *** Creating tables/AWARD.sql
@tables/AWARD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/AWARD_INSTALMENT.sql
@tables/AWARD_INSTALMENT.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/ADJUST.sql
@tables/ADJUST.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/APPLIC_REG.sql
@tables/APPLIC_REG.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/BATCH_RECALC.sql
@tables/BATCH_RECALC.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/CRSE_TERM_CHANGE.sql
@tables/CRSE_TERM_CHANGE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/INST_TERM_CHANGE.sql
@tables/INST_TERM_CHANGE.sql
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT ******************** BUILD PAYMENT TABLES *********************************
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT *** Creating tables/ADI_JOURNAL.sql
@tables/ADI_JOURNAL.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/FEE_LOAN_TYPE.sql
@tables/FEE_LOAN_TYPE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/FEE_PAYMENT_DATE.sql
@tables/FEE_PAYMENT_DATE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/FINANCE_REVERSAL_JOURNAL.sql
@tables/FINANCE_REVERSAL_JOURNAL.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PAYEE.sql
@tables/PAYEE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PAYEE_PAYMENT.sql
@tables/PAYEE_PAYMENT.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PAYMENT_ERRORS.sql
@tables/PAYMENT_ERRORS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PAYMENT_INSTALMENT.sql
@tables/PAYMENT_INSTALMENT.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PAYMENT_FILES_UNPROCESSED.sql
@tables/PAYMENT_FILES_UNPROCESSED.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PAYMENT_FILE_REF.sql
@tables/PAYMENT_FILE_REF.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PAYMENT_METHOD.sql
@tables/PAYMENT_METHOD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/NON_AWARD_PAYMENT_DATE.sql
@tables/NON_AWARD_PAYMENT_DATE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/SCOAP_BATCHES.sql
@tables/SCOAP_BATCHES.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/SCOAP_BATCHES_AUD.sql
@tables/SCOAP_BATCHES_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/SCOAP_JOURNAL_LINES.sql
@tables/SCOAP_JOURNAL_LINES.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/SCOAP_PAYMENTS.sql
@tables/SCOAP_PAYMENTS.sql
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT ********************* BUILD EMPLOYEE TABLES *******************************
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT *** Creating tables/EMPLOYEE.sql
@tables/EMPLOYEE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/EMPLOYEE_ACTIVITY.sql
@tables/EMPLOYEE_ACTIVITY.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/EMPLOYEE_CASES.sql
@tables/EMPLOYEE_CASES.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/EMPLOYEE_LOCKS.sql
@tables/EMPLOYEE_LOCKS.sql
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT ********************* BUILD MISC TABLES ***********************************
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT *** Creating tables/AUTHENTICATE_STUD.sql
@tables/AUTHENTICATE_STUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/COMPLETE_WEB_APPLICATIONS.sql
@tables/COMPLETE_WEB_APPLICATIONS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/COMPLETED_SHWAP.sql
@tables/COMPLETED_SHWAP.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/COMPLETE_TASK_DATA.sql
@tables/COMPLETE_TASK_DATA.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/COMPLETED_TEC.sql
@tables/COMPLETED_TEC.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/CONFIG_DATA.sql
@tables/CONFIG_DATA.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/CONFIG_EDM.sql
@tables/CONFIG_EDM.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/CORRES.sql
@tables/CORRES.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/CORRES_ATTACH.sql
@tables/CORRES_ATTACH.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DLA_REQUEST.sql
@tables/DLA_REQUEST.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DUP_BANK_REASON.sql
@tables/DUP_BANK_REASON.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/INST_CONT_DETAILS.sql
@tables/INST_CONT_DETAILS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/INST_CONT_EMAIL.sql
@tables/INST_CONT_EMAIL.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/JA_CASE_TYPE.sql
@tables/JA_CASE_TYPE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/JA_STUD_TYPE.sql
@tables/JA_STUD_TYPE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/LABEL_PRINT.sql
@tables/LABEL_PRINT.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/NMSB_CONTINUATION_REASON.sql
@tables/NMSB_CONTINUATION_REASON.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/NMSB_SPEC_ARR.sql
@tables/NMSB_SPEC_ARR.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/NOMINEE.sql
@tables/NOMINEE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PASSWORD_LETTER_REQUEST.sql
@tables/PASSWORD_LETTER_REQUEST.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PGCE_SUBJECT.sql
@tables/PGCE_SUBJECT.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/POSTCODE_ARCHIVE.sql
@tables/POSTCODE_ARCHIVE.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PRISONER_POSTCODES.sql
@tables/PRISONER_POSTCODES.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PROCESS_INSTANCE_DATA.sql
@tables/PROCESS_INSTANCE_DATA.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PT_STUD_DEPENDANT.sql
@tables/PT_STUD_DEPENDANT.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PT_STUD_INCOME.sql
@tables/PT_STUD_INCOME.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STD_LETTERS.sql
@tables/STD_LETTERS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STEPS_LOCKS.sql
@tables/STEPS_LOCKS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STEPS_QA_DATA.sql
@tables/STEPS_QA_DATA.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/TELEPHONY.sql
@tables/TELEPHONY.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/TELEPHONY_MIS.sql
@tables/TELEPHONY_MIS.sql
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT ********************* BUILD AUDIT TABLES **********************************
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT *** Creating tables/ADI_JOURNAL_AUD.sql
@tables/ADI_JOURNAL_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/AUTHENTICATE_STUD_AUD.sql
@tables/AUTHENTICATE_STUD_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/AWARD_AUD.sql
@tables/AWARD_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/AWARD_INSTALMENT_AUD.sql
@tables/AWARD_INSTALMENT_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/AWARD_REF_DATA_AUD.sql
@tables/AWARD_REF_DATA_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/BEN_INCOME_STATUS_AUD.sql
@tables/BEN_INCOME_STATUS_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/BEN_INCOME_TYPE_AUD.sql
@tables/BEN_INCOME_TYPE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/BENEFACTOR_AUD.sql
@tables/BENEFACTOR_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/BENEFACTOR_DEPENDANT_AUD.sql
@tables/BENEFACTOR_DEPENDANT_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/BENEFACTOR_INCOME_AUD.sql
@tables/BENEFACTOR_INCOME_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/BENEFACTOR_RELATION_AUD.sql
@tables/BENEFACTOR_RELATION_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/CASE_STATUS_AUD.sql
@tables/CASE_STATUS_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/CONTACT_RELATIONSHIP_AUD.sql
@tables/CONTACT_RELATIONSHIP_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/COUNTRY_AUD.sql
@tables/COUNTRY_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DEARING_STATUS_AUD.sql
@tables/DEARING_STATUS_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DEBT_STATUS_AUD.sql
@tables/DEBT_STATUS_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DISABILITY_TYPE_AUD.sql
@tables/DISABILITY_TYPE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_ALLOWANCE_AUD.sql
@tables/DSA_ALLOWANCE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_APPLICATION_AUD.sql
@tables/DSA_APPLICATION_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_ASSESSMENT_CENTRE_AUD.sql
@tables/DSA_ASSESSMENT_CENTRE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_CATEGORY_AUD.sql
@tables/DSA_CATEGORY_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_PAYMENT_AUD.sql
@tables/DSA_PAYMENT_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_PAYMENT_STATUS_AUD.sql
@tables/DSA_PAYMENT_STATUS_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_REFERRAL_REASON_AUD.sql
@tables/DSA_REFERRAL_REASON_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_REJECTION_REASON_AUD.sql
@tables/DSA_REJECTION_REASON_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_STUDENT_TYPE_AUD.sql
@tables/DSA_STUDENT_TYPE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DSA_TYPE_AUD.sql
@tables/DSA_TYPE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/DUP_BANK_REASON_AUD.sql
@tables/DUP_BANK_REASON_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/EMPLOYMENT_STATUS_AUD.sql
@tables/EMPLOYMENT_STATUS_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/FEE_LOAN_TYPE_AUD.sql
@tables/FEE_LOAN_TYPE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/FEE_PAYMENT_DATE_AUD.sql
@tables/FEE_PAYMENT_DATE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/FINANCE_REVERSAL_JOURNAL_AUD.sql
@tables/FINANCE_REVERSAL_JOURNAL_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/JA_CASE_AUD.sql
@tables/JA_CASE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/LOAN_STATUS_AUD.sql
@tables/LOAN_STATUS_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/LOCATION_AUD.sql
@tables/LOCATION_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/MARITAL_STATUS_AUD.sql
@tables/MARITAL_STATUS_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/NOMINEE_AUD.sql
@tables/NOMINEE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/NO_NINO_REASON_AUD.sql
@tables/NO_NINO_REASON_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/OTHER_LOAN_TYPE_AUD.sql
@tables/OTHER_LOAN_TYPE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PGCE_SUBJECT_AUD.sql
@tables/PGCE_SUBJECT_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/RESIDENCE_AUD.sql
@tables/RESIDENCE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/RESIDENCE_TYPE_AUD.sql
@tables/RESIDENCE_TYPE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/SCHEME_TYPE_AUD.sql
@tables/SCHEME_TYPE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/SPOUSE_TYPE_AUD.sql
@tables/SPOUSE_TYPE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STEPS_QA_DATA_AUD.sql
@tables/STEPS_QA_DATA_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_AUD.sql
@tables/STUD_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_APP_PROG_AUD.sql
@tables/STUD_APP_PROG_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_CRSE_YEAR_AUD.sql
@tables/STUD_CRSE_YEAR_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_DEPENDANT_AUD.sql
@tables/STUD_DEPENDANT_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_HOME_ADDR_AUD.sql
@tables/STUD_HOME_ADDR_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_NOMINEE_AUD.sql
@tables/STUD_NOMINEE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_SESSION_AUD.sql
@tables/STUD_SESSION_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/STUD_TERM_ADDR_AUD.sql
@tables/STUD_TERM_ADDR_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/SUPP_GRANT_RELATION_AUD.sql
@tables/SUPP_GRANT_RELATION_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/TITLE_AUD.sql
@tables/TITLE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/Z_REFUSAL_STATUS_AUD.sql
@tables/Z_REFUSAL_STATUS_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PAYEE_AUD.sql
@tables/PAYEE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PAYEE_PAYMENT_AUD.sql
@tables/PAYEE_PAYMENT_AUD.sql
---PROMPT ***************************************************************************
---PROMPT *** Creating tables/PAYMENT_ERRORS_AUD.sql
---@tables/PAYMENT_ERRORS_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PAYMENT_INSTALMENT_AUD.sql
@tables/PAYMENT_INSTALMENT_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/PAYMENT_METHOD_AUD.sql
@tables/PAYMENT_METHOD_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/NON_AWARD_PAYMENT_DATE_AUD.sql
@tables/NON_AWARD_PAYMENT_DATE_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/SCOAP_BATCHES_AUD.sql
@tables/SCOAP_BATCHES_AUD.sql
PROMPT ***************************************************************************
PROMPT ********************* BUILD EDM TABLES ************************************
PROMPT ***************************************************************************
PROMPT ***************************************************************************
PROMPT *** Creating tables/EDM_APP_LABELS.sql
@tables/EDM_APP_LABELS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/EDM_AUD.sql
@tables/EDM_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/EDM_EVENT_AUD.sql
@tables/EDM_EVENT_AUD.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/EDM_EVENT_AUD_ACTION.sql
@tables/EDM_EVENT_AUD_ACTION.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/EDM_IMAGES.sql
@tables/EDM_IMAGES.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/EDM_IMAGES_SMS.sql
@tables/EDM_IMAGES_SMS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/EDM_IMAGES_STATS.sql
@tables/EDM_IMAGES_STATS.sql
PROMPT ***************************************************************************
PROMPT *** Creating tables/EDM_NOTES.sql
@tables/EDM_NOTES.sql