-- *THIS SCRIPT SHOULD BE RUN FROM THE ILA500 SCHEMA 
-- =================================================
-- Build script to control creation of only BT MANDATORY TABLES
-- required in the ILA500 schema.
-- Outputs: output spooled to bt_build_ila500_tables.out
--
-- This script is most easily run from TOAD.
-- If running into a new schema then the script will generate errors when it 
-- attempts to drop non-existant objects. Either run the script twice - 
-- the first run will generate errors trying to drop non-existant objects. 
-- Select ignore all errors and allow the script to complete,
-- The second run should be error-free.
-- Alternatively scan the log from the first run to ensure no unexpected errors 
-- were encountered. 
--
-- Configuration Management: 
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/BT%20Releases/BT%20ILA500%203.0/BT_BUILD_ILA500_TABLES.sql $ 
-- $Author: $ 
-- $Date: 2008-10-07 13:29:55 +0100 (Tue, 07 Oct 2008) $ 
-- $Revision: 1293 $ 

SPOOL bt_build_ila500_tables.out

PROMPT *******************************
PROMPT **** Running LEARNER.sql
PROMPT *******************************
@LEARNER.sql
 
PROMPT *************************
PROMPT **** Running PROVIDER.sql
PROMPT *************************
@PROVIDER.sql

PROMPT *************************
PROMPT **** Running PROVIDER_INSERT.sql
PROMPT *************************
@PROVIDER_INSERT.sql
SPOOL off