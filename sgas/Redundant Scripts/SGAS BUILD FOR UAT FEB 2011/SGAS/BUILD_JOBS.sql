-- Build script to control creation of database jobs required in the STEPS database SGAS schema.
--
--
-- MODIFICATION HISTORY
-- Ref.     Date        Author                 Desc.
-- 001      26/01/2011  A.Bowman(SAAS)        Initial Version
--      
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date: $
-- $Revision: $


PROMPT
PROMPT *** Creating job/change_dets_job.sql
@jobs/CHANGE_DETS_JOB.sql
PROMPT
PROMPT *** Creating job/dla_requests.sql
@jobs/DLA_REQUESTS.sql
PROMPT
PROMPT *** Creating job/password_letter_requests.sql
@jobs/PASSWORD_LETTER_REQUESTS.sql


