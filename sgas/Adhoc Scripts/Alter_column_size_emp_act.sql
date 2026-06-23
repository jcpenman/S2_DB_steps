-- Amend size of columns on EMPLOYEE_ACTIVITY
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      20.05.10    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

Alter table employee_activity modify (first_name varchar2(50));
Alter table employee_activity modify (last_name varchar2(50));

commit;