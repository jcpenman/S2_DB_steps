-- Name:Adhoc 5
-- Description: Update the income threshold amount in the Application_Rejection table 
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      21.04.2009    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

UPDATE application_rejection
   SET application_rejection_desc = 'THE LEARNERS INCOME IS OVER 22,000'
 WHERE application_rejection_id = 4;

commit;


