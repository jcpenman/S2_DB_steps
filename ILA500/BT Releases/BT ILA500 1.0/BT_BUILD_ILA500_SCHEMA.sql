-- *THIS SCRIPT SHOULD BE RUN FROM THE SYSTEM SCHEMA 
-- =================================================
-- Build script to control creation of only BT ILA500 SCHEMA
-- Outputs: output spooled to bt_build_ila500_schema.out
--
-- This script is most easily run from TOAD.
--
-- Configuration Management: 
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/BT%20Releases/BT%20ILA500%201.0/BT_BUILD_ILA500_SCHEMA.sql $ 
-- $Author: $ 
-- $Date: 2008-10-07 13:29:55 +0100 (Tue, 07 Oct 2008) $ 
-- $Revision: 1293 $ 

SPOOL bt_build_ila500_schema.out

PROMPT *******************************
PROMPT **** Running ILA_500_SCHEMA_BT.sql
PROMPT *******************************
@ILA_500_SCHEMA_BT.sql
 
SPOOL off