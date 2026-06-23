-- *THIS SCRIPT SHOULD BE RUN FROM THE SGAS SCHEMA 
-- Populates config_edm table with ILA500 reference data 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
-- 1.0      29.05.08    R Hunter                                Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/BT%20Releases/BT%20ILA500%201.0/CONFIG_EDM_INSERT.sql $
-- $Author: $
-- $Date: 2008-10-07 13:29:55 +0100 (Tue, 07 Oct 2008) $
-- $Revision: 1293 $


--#StEPS ILA500 Learner Application
--#
INSERT INTO CONFIG_EDM ( DOCUMENT_TYPE_CODE, DOCUMENT_TYPE_NAME, TYPE, MULTIPAGE, RESCAN_ALLOWED,
REQ_ORIGINAL_ALLOWED, FILE_EXT ) VALUES ( 
'STEPSILA500APP', 'StEPS ILA500 Learner Application', 'E', 'N', 'Y', 'Y', 'TIFF'); 



--#StEPS ILA500 Learner Correspondence
--#
INSERT INTO CONFIG_EDM ( DOCUMENT_TYPE_CODE, DOCUMENT_TYPE_NAME, TYPE, MULTIPAGE, RESCAN_ALLOWED,
REQ_ORIGINAL_ALLOWED, FILE_EXT ) VALUES ( 
'STEPSILA500LCORR', 'StEPS ILA500 Learner Correspondence', 'E', 'N', 'Y', 'Y', 'TIFF'); 


--#StEPS ILA500 Learning Provider Correspondence
--#
INSERT INTO CONFIG_EDM ( DOCUMENT_TYPE_CODE, DOCUMENT_TYPE_NAME, TYPE, MULTIPAGE, RESCAN_ALLOWED,
REQ_ORIGINAL_ALLOWED, FILE_EXT ) VALUES ( 
'STEPSILA500PCORR', 'StEPS ILA500 Learning Provider Correspondence', 'E', 'N', 'Y', 'Y', 'TIFF'); 


commit;
