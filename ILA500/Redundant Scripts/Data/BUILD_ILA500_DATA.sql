-- Build script to control creation of standing data required in ILA500
-- MODIFICATION HISTORY
-- Ref.     Date            Author                          Desc.
-- 001      19/09/2008      R Hunter (SAAS)                 Initial Version
-- 002      22/10/2008      A.Bowman (SAAS)                 Added ILA500_QA_DATA_INSERT
-- 003      11/11/2008      A.Bowman (SAAS)                 Added DEBT_STATUS_INSERT
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision:  $


delete from note_type
/
commit
/
PROMPT
PROMPT *** Running NOTE_TYPE_INSERT.sql
@NOTE_TYPE_INSERT.sql
PROMPT


delete from provider
/
commit
/
PROMPT
PROMPT *** Running PROVIDER_INSERT.sql
@PROVIDER_INSERT.sql
PROMPT


delete from course_level
/
commit
/
PROMPT
PROMPT *** Running COURSE_LEVEL_INSERT.sql
@COURSE_LEVEL_INSERT.sql
PROMPT


delete from course_type
/
commit
/
PROMPT
PROMPT *** Running COURSE_TYPE_INSERT.sql
@COURSE_TYPE_INSERT.sql
PROMPT



delete from ila500_config_data
/
commit
/
PROMPT
PROMPT *** Running ILA500_CONFIG_DATA_INSERT.sql
@ILA500_CONFIG_DATA_INSERT.sql
PROMPT



delete from transaction_type
/
commit
/
PROMPT
PROMPT *** Running TRANSACTION_TYPE_INSERT.sql
@TRANSACTION_TYPE_INSERT.sql
PROMPT


delete from payment_status
/
commit
/
PROMPT
PROMPT *** Running PAYMENT_STATUS_INSERT.sql
@PAYMENT_STATUS_INSERT.sql
PROMPT



delete from bacs_run
/
commit
/
PROMPT
PROMPT *** Running BACS_RUN_INSERT.sql
@BACS_RUN_INSERT.sql
PROMPT



delete from ila500_rule
/
commit
/
PROMPT
PROMPT *** Running ILA500_RULE_INSERT.sql
@ILA500_RULE_INSERT.sql
PROMPT



delete from shell_letter
/
commit
/
PROMPT
PROMPT *** Running SHELL_LETTER_INSERT.sql
@SHELL_LETTER_INSERT.sql
PROMPT

delete from title
/
commit
/
PROMPT
PROMPT *** Running TITLE_INSERT.sql
@TITLE_INSERT.sql
PROMPT


delete from provider_type
/
commit
/
PROMPT
PROMPT *** Running PROVIDER_TYPE_INSERT.sql
@PROVIDER_TYPE_INSERT.sql
PROMPT

delete from provider_status
/
commit
/
PROMPT
PROMPT *** Running PROVIDER_STATUS_INSERT.sql
@PROVIDER_STATUS_INSERT.sql
PROMPT

delete from application_status
/
commit
/
PROMPT
PROMPT *** Running APPLICATION_STATUS_INSERT.sql
@APPLICATION_STATUS_INSERT.sql
PROMPT



delete from application_rejection
/
commit
/
PROMPT
PROMPT *** Running APPLICATION_REJECTION_INSERT.sql
@APPLICATION_REJECTION_INSERT.sql
PROMPT



delete from application_evidence
/
commit
/
PROMPT
PROMPT *** Running APPLICATION_EVIDENCE_INSERT.sql
@APPLICATION_EVIDENCE_INSERT.sql
PROMPT

delete from ila500_qa_data
/
commit
/
PROMPT
PROMPT *** Running ILA500_QA_DATA_INSERT.sql
@ILA500_QA_DATA_INSERT.sql
PROMPT

delete from debt_status
/
commit
/
PROMPT
PROMPT *** Running DEBT_STATUS_INSERT.sql
@DEBT_STATUS_INSERT.sql
PROMPT
