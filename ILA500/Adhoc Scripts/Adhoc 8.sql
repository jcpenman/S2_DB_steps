-- Name:Adhoc 8
-- Description: Inserts new course level dummy value.
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

insert into course_level (course_id, course_level_desc)
values (0, 'NONE');

commit;

