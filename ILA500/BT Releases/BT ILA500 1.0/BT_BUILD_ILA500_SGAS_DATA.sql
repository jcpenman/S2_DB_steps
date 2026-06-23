-- *THIS SCRIPT SHOULD BE RUN FROM THE SGAS SCHEMA 
-- =================================================
-- Build script to control creation of only BT STATIC DATA
-- required in the SGAS schema for the ILA500 development.
-- Outputs: output spooled to bt_build_ila500_sgas_data.out
--
--
-- Configuration Management: 
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/BT%20Releases/BT%20ILA500%201.0/BT_BUILD_ILA500_SGAS_DATA.sql $ 
-- $Author: $ 
-- $Date: 2008-10-07 13:29:55 +0100 (Tue, 07 Oct 2008) $ 
-- $Revision: 1293 $ 

SPOOL bt_build_ila500_sgas_data.out

PROMPT *******************************
PROMPT **** Running CONFIG_EDM_INSERT.sql
PROMPT *******************************
@CONFIG_EDM_INSERT.sql

PROMPT *******************************
PROMPT **** Running CONFIG_DATA_INSERT.sql
PROMPT *******************************
@CONFIG_DATA_INSERT.sql
 
SPOOL off