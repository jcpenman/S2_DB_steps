-- Build script to control creation of objects required in the ILA500 schema.
-- Outputs: output spooled to sgas_build.out
--
-- This script is most easily run from TOAD.
-- If running into a new schema then the script will generate errors when it attempts to drop non-existant objects. Either run the script twice -
-- the first run will generate errors trying to drop non-existant objects. Select ignore all errors and allow the script to complete,
-- The second run should be error-free.
-- Alternatively scan the log from the first run to ensure no unexpected errors were encountered.
--
-- MODIFICATION HISTORY
-- Ref.     Date        Author                  Desc.
-- 001      20/10/2010  A.Bowman (SAAS)     Initial Version
--
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date: $
-- $Revision: $

-- THE PROMPT BEFORE THE @ COMMAND WILL NEED TO BE REMOVED WHEN RUNNING THIS SCRIPT, THIS HAS BEEN ADDED TO ENSURE THE SCRIPT CANNOT BE RUN BY MISTAKE

SPOOL BUILD_ILA500.out
SELECT Sysdate FROM dual;
SET DEFINE OFF;

PROMPT
PROMPT ******************************************************************
PROMPT ****** ILA500 TABLES *********************************************
PROMPT ** The table scripts contain all triggers, sequences etc *********
PROMPT ******************************************************************
PROMPT ******************************************************************
PROMPT @BUILD_TABLES.sql


PROMPT
PROMPT ******************************************************************
PROMPT ******* ILA500 VIEWS *********************************************           
PROMPT ******************************************************************
PROMPT @BUILD_VIEWS.sql

PROMPT
PROMPT ******************************************************************
PROMPT ******* ILA500 PACKAGES ******************************************
PROMPT ******************************************************************
PROMPT @BUILD_PACKAGES.sql

PROMPT
PROMPT ******************************************************************
PROMPT ******* ILA500 DB LINKS ******************************************
PROMPT ******************************************************************
PROMPT @DB_LINKS.sql

PROMPT Build Completed 

exit;