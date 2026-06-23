-- *THIS SCRIPT SHOULD BE RUN FROM THE EDM SCHEMA 
-- =================================================
-- Build script to control creation of only BT STATIC DATA
-- required in the EDM schema for the ILA500 development.
-- Outputs: output spooled to bt_build_ila500_edm_data.out
--
-- This script is most easily run from TOAD.
--
-- Configuration Management: 
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/BT%20Releases/BT%20ILA500%204.0/BT_BUILD_ILA500_EDM_DATA.sql $ 
-- $Author: $ 
-- $Date: 2008-10-07 13:29:55 +0100 (Tue, 07 Oct 2008) $ 
-- $Revision: 1293 $ 

SPOOL bt_build_ila500_edm_data.out

PROMPT *******************************
PROMPT **** Running EDM_BATCH_WF_INSERT.sql
PROMPT *******************************
@EDM_BATCH_WF_INSERT.sql
 
SPOOL off