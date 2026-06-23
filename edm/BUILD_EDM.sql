-- Build script to control creation of objects required in the EDM schema.
-- log: output spooled to edm_build.out
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
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/edm/BUILD_EDM.sql $
-- $Author: $
-- $Date: 2008-03-26 10:16:45 +0000 (Wed, 26 Mar 2008) $
-- $Revision: 392 $

SPOOL edm_build.out
SELECT Sysdate FROM dual;

PROMPT
PROMPT ************************************
PROMPT ************ TABLES ****************
PROMPT ************************************
PROMPT
PROMPT *********************************
PROMPT **** Running BATCH_STATS.sql ****
PROMPT *********************************
@tables/BATCH_STATS.sql

PROMPT **********************************
PROMPT **** Running DUP_ENVELOPE.sql ****
PROMPT **********************************
@tables/DUP_ENVELOPE.sql

PROMPT **********************************
PROMPT **** Running EDM_AUD_TEMP.sql ****
PROMPT **********************************
@tables/EDM_AUD_TEMP.sql

PROMPT **********************************
PROMPT **** Running EDM_BATCH_WF.sql ****
PROMPT **********************************
@tables/EDM_BATCH_WF.sql

PROMPT **********************************
PROMPT **** Running EDM_COMPLETE.sql ****
PROMPT **********************************
@tables/EDM_COMPLETE.sql

PROMPT **************************************
PROMPT **** Running EDM_CONFIG_PAGES.sql ****
PROMPT **************************************
@tables/EDM_CONFIG_PAGES.sql

PROMPT *********************************
PROMPT **** Running EDM_ERROR_LOG.sql **
PROMPT *********************************
@tables/EDM_ERROR_LOG.sql

PROMPT *********************************
PROMPT **** Running EDM_TEMP.sql *******
PROMPT *********************************
@tables/EDM_TEMP.sql

PROMPT *********************************
PROMPT **** Running PICK_LIST.sql ******
PROMPT *********************************
@tables/PICK_LIST.sql

PROMPT *********************************
PROMPT **** Running RAW_DATA.sql *******
PROMPT *********************************
@tables/RAW_DATA.sql

PROMPT *****************************************
PROMPT **** Running TMP_EDM_MESSAGE_LOG.sql ****
PROMPT *****************************************
@tables/TMP_EDM_MESSAGE_LOG.sql

PROMPT
PROMPT ************************************
PROMPT *********** SEQUENCES **************
PROMPT ************************************
PROMPT
PROMPT ************************************
PROMPT **** Running RAW_DATA_ID_SEQ.sql ***
PROMPT ************************************
@sequences/RAW_DATA_ID_SEQ.sql

PROMPT *************************************
PROMPT **** Running DUP_ENVELOPE_SEQ.sql ***
PROMPT *************************************
@sequences/DUP_ENVELOPE_SEQ.sql

PROMPT *****************************************
PROMPT **** Running EDM_PICK_LIST_ID_SEQ.sql ***
PROMPT *****************************************
@sequences/EDM_PICK_LIST_ID_SEQ.sql

exit;