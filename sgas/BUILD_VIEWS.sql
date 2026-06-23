-- Build script to control creation of views required in the STEPS database SGAS schema.
--
-- DEPENDENCIES:
-- Some of the views are based on steps tables which must be created first.
--
-- NOTES:
-- If running into a new schema then the scripts will generate errors as they attempt to drop non-existant objects. 
-- If the script is run twice the first run will generate errors trying to drop non-existant objects.sql ignore all errors and allow the script to complete,
-- The second run should be error-free.
-- Alternatively scan the log from the first run to ensure no unexpected errors were encountered.
--
-- MODIFICATION HISTORY
-- Ref.     Date        Author                 Desc.
--          08/01/2008  S Durkin (Sopra UK)    Initial Version
--          21/08/2008  S Durkin (Sopra UK)    Add named query views on GRASS DB.
-- 001      31/05/2010  A.Bowman (SAAS)        Updated this script to reflect the current position in SIT
-- 002      03/08/2010  A.Bowman (SAAS)        Updated this script to reflect the current position of DEV database which is awaiting release to SIT
-- 003      25/11/2010  A.Bowman (SAAS)        Updated this script to reflect the current position of DEV database
-- 004      26/11/2010  A.Bowman (SAAS)        Updated this script to reflect the current position on the SIT database       
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/BUILD_VIEWS.sql $
-- $Author: $
-- $Date: 2012-01-24 11:50:40 +0000 (Tue, 24 Jan 2012) $
-- $Revision: 7655 $


PROMPT ************************************************
PROMPT *** Running views/AWARD_NOTIFICATION.sql
@views/AWARD_NOTIFICATION.sql
PROMPT ************************************************
PROMPT *** Running views/CATEGORY.sql
@views/CATEGORY.sql
PROMPT ************************************************
PROMPT *** Running views/CRSE.sql
@views/CRSE.sql
PROMPT ************************************************
PROMPT *** Running views/CRSE_SESSION.sql
@views/CRSE_SESSION.sql
PROMPT ************************************************
PROMPT *** Running views/CRSE_TERM.sql
@views/CRSE_TERM.sql
PROMPT ************************************************
PROMPT *** Running views/CRSE_YEAR.sql
@views/CRSE_YEAR.sql
PROMPT ************************************************
PROMPT *** Running views/ERR_MESS.sql
@views/ERR_MESS.sql
PROMPT ************************************************
PROMPT *** Running views/INST.sql
@views/INST.sql
PROMPT ************************************************
PROMPT *** Running views/INST_TERM.sql
@views/INST_TERM.sql
PROMPT ************************************************
PROMPT *** Running views/SESSION_CONTRIB.sql
@views/SESSION_CONTRIB.sql
PROMPT ************************************************
PROMPT *** Running views/SESSION_XLOAN_YSB_PAYABLE.sql
@views/SESSION_XLOAN_YSB_PAYABLE.sql
PROMPT ************************************************
PROMPT *** Running views/STUD_RATES.sql
@views/STUD_RATES.sql
-- These views where orginally implemented as materialised views - replaced with 
-- named-query views to provide immediate view of data. (Note key that foreign 
-- key constraints are not enforced - the constraints are enforced in GRASS)
PROMPT ************************************************
PROMPT *** Running views/SUPPORT_CALCULATOR_RATES.sql
@views/SUPPORT_CALCULATOR_RATES.sql
PROMPT ************************************************
PROMPT *** Running views/UCAS.sql
@views/UCAS.sql
PROMPT ************************************************
PROMPT *** Running views/VALIDATION.sql
@views/VALIDATION.sql
PROMPT *************************************************
PROMPT *** Running views/VU_HISTORY.sql
@views/VU_HISTORY.sql
