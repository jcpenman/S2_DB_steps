-- Name:Adhoc 8
-- Description: Changes description of two shell letters.
--              to 22,000 from 18,000
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.06.2009    P.Grace (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

update shell_letters 
set doc_desc = 'RETURNED LETTER AS APPLICATION FORM IS UNSIGNED'
where doc_id = 9;

update shell_letters 
set doc_desc = 'RETURNED LETTER AS APPLICATION HAS NOT BEEN ENDORSED BY INSTITUTION'
where doc_id = 10;

commit;

