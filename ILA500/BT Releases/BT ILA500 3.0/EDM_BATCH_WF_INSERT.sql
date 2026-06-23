-- *THIS SCRIPT SHOULD BE RUN FROM THE EDM SCHEMA 
-- Populates EDM_BATCH_WF table with ILA500 reference data 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
-- 1.0      29.05.08    R Hunter                                Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/BT%20Releases/BT%20ILA500%203.0/EDM_BATCH_WF_INSERT.sql $
-- $Author: $
-- $Date: 2008-10-07 13:29:55 +0100 (Tue, 07 Oct 2008) $
-- $Revision: 1293 $


--#StEPS ILA500 Learner Application
--#
INSERT INTO EDM_BATCH_WF (
   BATCH_TYPE_CODE, BATCH_TYPE_DESCRIPTION, WORK_ITEM_INDICATOR, 
   FIRST_SESSION, REPORTED_AS, RAW_DATA_REQD) 
VALUES ( 70,'StEPS ILA500 Learner Application' , 'S',NULL
    ,'C' ,'N' );


--#StEPS ILA500 Learner Correspondence
--#
INSERT INTO EDM_BATCH_WF (
   BATCH_TYPE_CODE, BATCH_TYPE_DESCRIPTION, WORK_ITEM_INDICATOR, 
   FIRST_SESSION, REPORTED_AS, RAW_DATA_REQD) 
VALUES ( 71,'StEPS ILA500 Learner Correspondence' , 'S',NULL
    ,'C' ,'N' );

--#StEPS ILA500 Learning Provider Correspondence
--#
INSERT INTO EDM_BATCH_WF (
   BATCH_TYPE_CODE, BATCH_TYPE_DESCRIPTION, WORK_ITEM_INDICATOR, 
   FIRST_SESSION, REPORTED_AS, RAW_DATA_REQD) 
VALUES ( 72, 'StEPS ILA500 Learning Provider Correspondence', 'S',NULL
    ,'C' ,'N' );

COMMIT;
