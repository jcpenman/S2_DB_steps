-- Build reference tables and populate with static data.
--
-- If running into a new schema then the scripts will generate errors as they attempt to drop non-existant objects. 
-- If the script is run twice the first run will generate errors trying to drop non-existant objects; ignore all errors and allow the script to complete,
-- The second run should be error-free.
-- Alternatively scan the log from the first run to ensure no unexpected errors were encountered.
--
-- MODIFICATION HISTORY
-- Ref.     Date            Author                          Desc.
--          08/01/2008  S Durkin (Sopra UK)     Initial Version
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/BUILD_REF.sql $
-- $Author: $
-- $Date: 2008-10-01 14:25:43 +0100 (Wed, 01 Oct 2008) $
-- $Revision: 1235 $

PROMPT ***************************
PROMPT ******* REF TABLES ********
PROMPT ***************************
PROMPT
PROMPT **** Running tables/REFERENCE_DOMAINS
@tables/REFERENCE_DOMAINS.sql
PROMPT
PROMPT **** Running tables/REFERENCE_TYPES.sql
@tables/REFERENCE_TYPES.sql
PROMPT
PROMPT **** Running tables/REFERENCE_DATA.sql
@tables/REFERENCE_DATA.sql
PROMPT
PROMPT **** data/REFERENCE_DOMAINS.sql
@data/REFERENCE_DOMAINS.sql
PROMPT
PROMPT **** data/REFERENCE_TYPES.sql
@data/REFERENCE_TYPES.sql
PROMPT
PROMPT **** data/REFERENCE_DATA.sql
@data/REFERENCE_DATA.sql
PROMPT
PROMPT *******************************
PROMPT **** BUILD CATEGORY VIEW...
PROMPT *******************************
PROMPT
@views/CATEGORY.sql
@triggers/CAT_IOF_INS.sql
@data/CATEGORY.sql
PROMPT
PROMPT *******************************
PROMPT **** BUILD 