-- Alter column ED8_RUN_LOG.SHAPE to NOT NULL
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

ALTER TABLE ed8_run_log
MODIFY (
SHAPE NOT NULL
);