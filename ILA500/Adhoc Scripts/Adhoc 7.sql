-- Name:Adhoc 7
-- Description: Updates to desc in ILA500_RULE and SHELL_LETTER table in respect of income increase 
--              to 22,000 from 18,000
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      03.06.2009    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

update shell_letter
set doc_desc = 'REJECTION LETTER AS INCOME IS GREATER THAN 22000'
where doc_id = 7;

update ila500_rule
set rule_value = 'THE LEARNERS INCOME MUST BE 22,000 OR LESS PER ANNUM'
where rule_id = 3;

commit;

