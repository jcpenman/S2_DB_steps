-- Build script to control creation of ILA500 tables
--
-- MODIFICATION HISTORY 
-- Ref.     Date            Author                          Desc.
-- 001      07/10/2008    S Durkin (Sopra UK)     Initial Version
-- 002      27/10/2008    A.Bowman (SAAS)         Added ILA500_Telephony tables
-- 003      11/11/2008    A.Bowman (SAAS)         Added DEBT_STATUS and DEBT_STATUS_AUD tables
-- 004      04/06/2009    A.Bowman (SAAS)         Removed ILA500_Telephony tables as it is no longer req'd
-- 005      05/06/2009    A.Bowman (SAAS)         Added PAYMENT_REPORT_ARCHIVE tables
-- 006      08/06/2009    A.Bowman (SAAS)         Added WORK_ITEMS tables
-- 007      21/10/2010    A.Bowman (SAAS)         Altered the sructure of this script to make it easier to read
--
-- Configuration Management: 
-- $HeadURL:  $ 
-- $Author: $ 
-- $Date:  $ 
-- $Revision:  $ 

PROMPT
PROMPT *** Creating tables/ADI_PAYMENT.sql
@tables/ADI_PAYMENT.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/ADI_PAYMENT_AUD.sql
@tables/ADI_PAYMENT_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/APPLICATION_EVIDENCE.sql
@tables/APPLICATION_EVIDENCE.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/APPLICATION_EVIDENCE_AUD.sql
@tables/APPLICATION_EVIDENCE_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/APPLICATION_REJECTION.sql
@tables/APPLICATION_REJECTION.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/APPLICATION_REJECTION_AUD.sql
@tables/APPLICATION_REJECTION_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/APPLICATION_STATUS.sql
@tables/APPLICATION_STATUS.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/APPLICATION_STATUS_AUD.sql
@tables/APPLICATION_STATUS_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/BACS_RUN.sql
@tables/BACS_RUN.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/BACS_RUN_AUD.sql
@tables/BACS_RUN_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/CASEWORKER_NOTE.sql
@tables/CASEWORKER_NOTE.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/CASEWORKER_NOTE_AUD.sql
@tables/CASEWORKER_NOTE_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/COURSE_LEVEL.sql
@tables/COURSE_LEVEL.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/COURSE_LEVEL_AUD.sql
@tables/COURSE_LEVEL_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/COURSE_TYPE.sql
@tables/COURSE_TYPE.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/COURSE_TYPE_AUD.sql
@tables/COURSE_TYPE_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/DOCUMENT_REGISTER.sql
@tables/DOCUMENT_REGISTER.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/DOCUMENT_REGISTER_AUD.sql
@tables/DOCUMENT_REGISTER_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/ILA500_CASEWORKER_LOCKS.sql
@tables/ILA500_CASEWORKER_LOCKS.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/ILA500_CONFIG_DATA.sql
@tables/ILA500_CONFIG_DATA.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/ILA500_CONFIG_DATA_AUD.sql
@tables/ILA500_CONFIG_DATA_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/ILA500_EDM_IMAGES.sql
@tables/ILA500_EDM_IMAGES.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/ILA500_EDM_IMAGES_AUD.sql
@tables/ILA500_EDM_IMAGES_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/ILA500_QA_DATA.sql
@tables/ILA500_QA_DATA.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/ILA500_QA_DATA_AUD.sql
@tables/ILA500_QA_DATA_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/ILA500_RULE.sql
@tables/ILA500_RULE.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/ILA500_RULE_AUD.sql
@tables/ILA500_RULE_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/LEARNER.sql
@tables/LEARNER.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/LEARNER_APPLICATION.sql
@tables/LEARNER_APPLICATION.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/LEARNER_APPLICATION_AUD.sql
@tables/LEARNER_APPLICATION_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/LEARNER_AUD.sql
@tables/LEARNER_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/LEARNER_DUPLICATE.sql
@tables/LEARNER_DUPLICATE.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/LEARNER_DUPLICATE_AUD.sql
@tables/LEARNER_DUPLICATE_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/LEARNER_PAYMENT.sql
@tables/LEARNER_PAYMENT.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/LEARNER_PAYMENT_AUD.sql
@tables/LEARNER_PAYMENT_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/NOTE_TYPE.sql
@tables/NOTE_TYPE.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/NOTE_TYPE_AUD.sql
@tables/NOTE_TYPE_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/PAYMENT_STATUS.sql
@tables/PAYMENT_STATUS.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/PAYMENT_STATUS_AUD.sql
@tables/PAYMENT_STATUS_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/PROV_STAT_HIST.sql
@tables/PROV_STAT_HIST.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/PROVIDER.sql
@tables/PROVIDER.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/PROVIDER_AUD.sql
@tables/PROVIDER_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/PROVIDER_PAYMENT.sql
@tables/PROVIDER_PAYMENT.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/PROVIDER_PAYMENT_AUD.sql
@tables/PROVIDER_PAYMENT_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/PROVIDER_STATUS.sql
@tables/PROVIDER_STATUS.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/PROVIDER_STATUS_AUD.sql
@tables/PROVIDER_STATUS_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/PROVIDER_TYPE.sql
@tables/PROVIDER_TYPE.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/PROVIDER_TYPE_AUD.sql
@tables/PROVIDER_TYPE_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/RAW_DATA.sql
@tables/RAW_DATA.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/REPORT_HISTORY.sql
@tables/REPORT_HISTORY.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/REPORT_HISTORY_AUD.sql
@tables/REPORT_HISTORY_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/SHELL_LETTER.sql
@tables/SHELL_LETTER.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/SHELL_LETTER_AUD.sql
@tables/SHELL_LETTER_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/TITLE.sql
@tables/TITLE.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/TITLE_AUD.sql
@tables/TITLE_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/TRANSACTION_TYPE.sql
@tables/TRANSACTION_TYPE.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/TRANSACTION_TYPE_AUD.sql
@tables/TRANSACTION_TYPE_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/DEBT_STATUS.sql
@tables/DEBT_STATUS.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/DEBT_STATUS_AUD.sql
@tables/DEBT_STATUS_AUD.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/PAYMENT_REPORT_ARCHIVE.sql
@tables/PAYMENT_REPORT_ARCHIVE.sql
PROMPT *******************************************************
PROMPT
PROMPT *** Creating tables/WORK_ITEMS.sql
@tables/WORK_ITEMS.sql
PROMPT *******************************************************
PROMPT