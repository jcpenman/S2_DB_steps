-- Update SHAPE column in ED8_RUN_LOG for all records
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      13/08/2013  P Grace                 Initial Version.
--
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date: $
-- $Revision: $

UPDATE ed8_run_log
   SET shape = 0;

COMMIT;