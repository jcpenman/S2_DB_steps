-- Name:Adhoc 8
-- Description: Removes previous 
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.06.2009    P.Grace (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

delete from course_level
where course_level_desc = 'NONE'
OR course_level_desc = 'None';

commit;

