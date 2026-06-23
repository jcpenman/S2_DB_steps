-- *THIS SCRIPT SHOULD BE RUN FROM THE SGAS SCHEMA 
-- Populates config_data table with ILA500 reference data 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
-- 1.0      29.05.08    R Hunter                                Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/BT%20Releases/BT%20ILA500%201.0/CONFIG_DATA_INSERT.sql $
-- $Author: $
-- $Date: 2008-10-07 13:29:55 +0100 (Tue, 07 Oct 2008) $
-- $Revision: 1293 $


--#StEPS ILA500 Current Session
--#
INSERT INTO CONFIG_DATA ( ITEM_NAME, CVAL, NVAL ) VALUES ( 
'ILA500_CURRENT_SESSION', NULL, 2008); 

COMMIT;
