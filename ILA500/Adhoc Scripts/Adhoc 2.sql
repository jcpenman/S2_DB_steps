-- Name:Adhoc 2
-- Description: This script has been created to drop the no longer required constraints on the 
--              Learner table on the SIT database.  
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      11.11.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 


ALTER TABLE learner DROP CONSTRAINT SYS_C0014846;
ALTER TABLE learner DROP CONSTRAINT SYS_C0014849;
ALTER TABLE learner DROP CONSTRAINT SYS_C0014850;
ALTER TABLE learner DROP CONSTRAINT SYS_C0014851;
ALTER TABLE learner DROP CONSTRAINT SYS_C0014852;
ALTER TABLE learner DROP CONSTRAINT SYS_C0014853;
commit;