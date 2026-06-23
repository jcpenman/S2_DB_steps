-- Build script to control creation of manadatory tables and sequences required 
-- by BT in the EDM schema.
-- log: output spooled to bt_build_edm.out
--
-- This script is most easily run from TOAD.
-- If running into a new schema then the script will generate errors when it attempts to drop non-existant objects. Either run the script twice - 
-- the first run will generate errors trying to drop non-existant objects. Select ignore all errors and allow the script to complete,
-- The second run should be error-free.
-- Alternatively scan the log from the first run to ensure no unexpected errors were encountered. 
--
-- MODIFICATION HISTORY
-- Ref.     Date            Author                          Desc.
--          08/01/2008  S Durkin (Sopra UK)     Initial Version
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/edm/tables/BT_BUILD_EDM.sql $
-- $Author: $
-- $Date: 2008-03-10 15:05:49 +0000 (Mon, 10 Mar 2008) $
-- $Revision: 365 $

SPOOL bt_build_edm.out
SELECT Sysdate FROM dual;

PROMPT *********************************
PROMPT **** Running BATCH_STATS.sql ****
PROMPT *********************************
@BATCH_STATS.sql

PROMPT **********************************
PROMPT **** Running EDM_AUD_TEMP.sql ****
PROMPT **********************************
@EDM_AUD_TEMP.sql

PROMPT **********************************
PROMPT **** Running EDM_BATCH_WF.sql ****
PROMPT **********************************
@EDM_BATCH_WF.sql

PROMPT **********************************
PROMPT **** Running EDM_COMPLETE.sql ****
PROMPT **********************************
@EDM_COMPLETE.sql

PROMPT *************************************
PROMPT **** Running EDM_CONFIG_PAGES.sql ***
PROMPT *************************************
@EDM_CONFIG_PAGES.sql

PROMPT *********************************
PROMPT **** Running EDM_TEMP.sql *******
PROMPT *********************************
@EDM_TEMP.sql

PROMPT *********************************
PROMPT **** Running RAW_DATA.sql *******
PROMPT *********************************
@RAW_DATA.sql

PROMPT ************************************
PROMPT **** Running RAW_DATA_ID_SEQ.sql ***
PROMPT ************************************
@RAW_DATA_ID_SEQ.sql

SPOOL off