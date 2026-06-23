-- EDM_BATCH_WF
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                     Desc.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/edm/db_data/EDM_BATCH_WF.sql $
-- $Author: $ 
-- $Date: 2008-10-01 14:26:20 +0100 (Wed, 01 Oct 2008) $
-- $Revision: 1237 $

INSERT INTO edm_batch_wf
(SELECT * FROM edm_batch_wf@grass
 WHERE batch_type_description like 'SAS%ONLINE'
)
/