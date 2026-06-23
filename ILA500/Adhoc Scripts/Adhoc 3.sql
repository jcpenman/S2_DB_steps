-- Name:Adhoc 3
-- Description: This script has been created to drop the no longer required constraints on the 
--              Learner_Application table and to add a new constraint requirement on the SIT database.  
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


ALTER TABLE learner_application DROP CONSTRAINT SYS_C0014859;
ALTER TABLE learner_application DROP CONSTRAINT SYS_C0014860;
ALTER TABLE learner_application DROP CONSTRAINT SYS_C0014861;
ALTER TABLE learner_application DROP CONSTRAINT SYS_C0014863;

ALTER TABLE LEARNER_APPLICATION ADD (
  CONSTRAINT LEARNER_APPLICATION_C01
 CHECK (not ((course_id is null or provider_id is null or course_type_id is null or session_year is null) and application_status_id in ('1','2'))));


commit;