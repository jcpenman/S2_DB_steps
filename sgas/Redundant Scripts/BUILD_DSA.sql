-- Build script to control creation of objects required in the SGAS schema.
-- Outputs: output spooled to sgas_build.out
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
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/BUILD_DSA.sql $
-- $Author: $
-- $Date: 2008-10-01 14:25:43 +0100 (Wed, 01 Oct 2008) $
-- $Revision: 1235 $

PROMPT
PROMPT **************************************
PROMPT *************** DSA ******************
PROMPT **************************************
PROMPT
PROMPT ************************************
PROMPT ************ TABLES...
PROMPT ************************************
PROMPT
PROMPT **** Running tables/DSA_TYPES.sql
@tables/DSA_TYPES.sql

PROMPT
PROMPT **** Running tables/DSA_MAX_AWARDS.sql
@tables/DSA_MAX_AWARDS.sql

PROMPT
PROMPT **** Running tables/NOMINEES.sql
@tables/NOMINEES.sql

PROMPT
PROMPT **** Running tables/DSA_CATEGORIES.sql
@tables/DSA_CATEGORIES.sql

PROMPT
PROMPT **** Running tables/DSA_ASSESSMENT_CENTRES.sql
@tables/DSA_ASSESSMENT_CENTRES.sql

PROMPT
PROMPT **** Running tables/DSA_ASSESSMENTS.sql
@tables/DSA_ASSESSMENTS.sql

PROMPT
PROMPT **** Running tables/DSA_APPROVALS.sql
@tables/DSA_APPROVALS.sql

PROMPT
PROMPT **** Running tables/DSA_ARRANGEMENTS.sql
@tables/DSA_ARRANGEMENTS.sql

PROMPT
PROMPT **** Running tables/DSA_CASENOTES.sql
@tables/DSA_CASENOTES.sql

PROMPT
PROMPT ************************************
PROMPT ************ DATA...
PROMPT ************************************
PROMPT
PROMPT **** Running tables/DSA_TYPES.sql
@data/DSA_TYPES.sql

PROMPT
PROMPT **** Running tables/DSA_MAX_AWARDS.sql
@data/DSA_MAX_AWARDS.sql

PROMPT
PROMPT **** Running tables/DSA_CATEGORIES.sql
@data/DSA_CATEGORIES.sql


