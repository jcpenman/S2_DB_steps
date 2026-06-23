-- Name:Adhoc 14 Add securezip_password
-- Description: This script has been created to add the new column securezip_password to the Provider table in
--              ILA500 for 2010 Session
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      13.04.2010    P. Grace (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

ALTER TABLE LEARNER_APPLICATION MODIFY TOTAL_ANNUAL_INCOME DEFAULT 0;

commit;