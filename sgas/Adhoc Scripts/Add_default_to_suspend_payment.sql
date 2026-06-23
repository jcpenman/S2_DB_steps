-- Set a default of 'N' against column STUD.SUSPEND_PAYMENT
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      22.10.10    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

Alter table stud modify (suspend_payment default 'N');

commit;