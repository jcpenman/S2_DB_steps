-- Build script to control creation of objects required in the SGAS schema.
-- Outputs: output spooled to sgas_build.out
--
-- This script is most easily run from TOAD.
-- If running into a new schema then the script will generate errors when it attempts to drop non-existant objects and references objects that have not yet been created. 
-- Select ignore all errors and allow the script to complete.
-- The entire script should be run once and then the BUILD_TABLES and BUILD_REFERENTIAL_CONSTRAINTS script should be run again before compiling the database.
-- The second run should be error-free and you should have no compilation errors.
--
--
-- MODIFICATION HISTORY
-- Ref.     Date        Author                  Desc.
--          08/01/2008  S Durkin (Sopra UK)     Initial Version
-- 001      16/07/2009  A.Bowman (SAAS)         Removed sequences and triggers as these have been incorporated
--                                              on the table scripts
-- 002      31/05/2010  A.Bowman (SAAS)         Updated this script to reflect current scripts
-- 003      26/11/2010  A.Bowman (SAAS)         This script has been updated to reflect the issues encountered when running this script into a new environment   
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/BUILD_SGAS.sql $
-- $Author: $
-- $Date: 2010-11-26 13:47:37 +0000 (Fri, 26 Nov 2010) $
-- $Revision: 6109 $
--
-- THE PROMPT BEFORE THE @ COMMAND WILL NEED TO BE REMOVED WHEN RUNNING THIS SCRIPT, THIS HAS BEEN ADDED TO ENSURE THE SCRIPT CANNOT BE RUN BY MISTAKE
--


SPOOL BUILD_SGAS.out
SELECT Sysdate FROM dual;
SET DEFINE OFF;

PROMPT
PROMPT ************************************************************************************************
PROMPT **************************** APPLICATION TABLES ************************************************
PROMPT ***** These table scripts contain all triggers, data, synonyms, sequences etc ******************
PROMPT ************************************************************************************************
PROMPT ************************************************************************************************
PROMPT @BUILD_TABLES


PROMPT
PROMPT ************************************************************************************************
PROMPT ********************************* VIEWS ********************************************************
PROMPT **************************** Named-query views only ********************************************
PROMPT ********************** materialised views built seperately *************************************
PROMPT ************************************************************************************************
PROMPT ************************************************************************************************
PROMPT @BUILD_VIEWS.sql

PROMPT
PROMPT ************************************************************************************************
PROMPT ************************************************************************************************
PROMPT *************************** GRASS_SYNONYMS.sql *************************************************
PROMPT ************************************************************************************************
PROMPT ************************************************************************************************
PROMPT @GRASS_SYNONYMS.sql

PROMPT ************************************************************************************************
PROMPT ************************************************************************************************
PROMPT *************************** WEB_SYNONYMS.sql ***************************************************
PROMPT ************************************************************************************************
PROMPT ************************************************************************************************
PROMPT @WEB_SYNONYMS.sql


PROMPT ************************************************************************************************
PROMPT ************************************************************************************************
PROMPT ******************************* PACKAGES *******************************************************
PROMPT ************************************************************************************************
PROMPT ************************************************************************************************
PROMPT @BUILD_PACKAGES.sql

PROMPT ************************************************************************************************
PROMPT ************************************************************************************************
PROMPT ********************************* JOBS *********************************************************
PROMPT ************************************************************************************************
PROMPT ************************************************************************************************
PROMPT @BUILD_JOBS.sql

PROMPT ************************************************************************************************
PROMPT ************************************************************************************************
PROMPT ************************* REFERENTIAL CONSTRAINTS **********************************************
PROMPT ************************************************************************************************
PROMPT ************************************************************************************************
PROMPT @BUILD_REFERENTIAL_CONSTRAINTS.sql

PROMPT Build Completed 

exit;