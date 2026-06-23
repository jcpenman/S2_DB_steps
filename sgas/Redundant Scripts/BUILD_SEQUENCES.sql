-- Build scriptfor sequences in the STEPS SGAS schema.
--
-- If running into a new schema then the scripts will generate errors as they attempt to drop non-existant objects. 
-- If the script is run twice the first run will generate errors trying to drop non-existant objects; ignore all errors and allow the script to complete,
-- The second run should be error-free.
-- Alternatively scan the log from the first run to ensure no unexpected errors were encountered.
--
-- MODIFICATION HISTORY
-- Ref.     Date            Author                          Desc.
--          08/01/2008  S Durkin (Sopra UK)     Initial Version
-- 001      08/12/2008  A.Bowman (SAAS)         Added audit sequences
-- 002      14/01/2009  A.Bowman (SAAS)         Added payment tables sequences
-- 003      03/03/2009  A.Bowman (SAAS)         Removed redundant payment seq's
-- 004      14/04/2009  A.Bowman (SAAS)         Removed redundant payment seq's
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/BUILD_SEQUENCES.sql $
-- $Author: $
-- $Date: 2009-04-14 11:20:28 +0100 (Tue, 14 Apr 2009) $
-- $Revision: 2768 $

PROMPT
PROMPT *** Running AUD_AUD_ID_SEQ.sql
@sequences/AUD_AUD_ID_SEQ.sql
PROMPT
PROMPT *** Running AW_AWARD_ID_SEQ.sql
@sequences/AW_AWARD_ID_SEQ.sql
PROMPT
PROMPT *** Running AWARDS_RECALC_ID_SEQ.sql
@sequences/AWARDS_RECALC_ID_SEQ.sql
PROMPT
PROMPT *** Running AWARD_INSTALMENT_ID_SEQ.sql
@sequences/AWARD_INSTALMENT_ID_SEQ.sql
PROMPT
PROMPT *** Running BE_BEN_ID_SEQ.sql
@sequences/BE_BEN_ID_SEQ.sql
PROMPT
PROMPT *** Running BED_BED_ID_SEQ.sql
@sequences/BED_BED_ID_SEQ.sql
PROMPT
PROMPT *** Running DAC_ID_SEQ.sql
@sequences/DAC_ID_SEQ.sql
PROMPT
PROMPT *** Running DAP_ID_SEQ.sql
@sequences/DAP_ID_SEQ.sql
PROMPT
PROMPT *** Running DAR_ID_SEQ.sql
@sequences/DAR_ID_SEQ.sql
PROMPT
PROMPT *** Running DAS_ID_SEQ.sql
@sequences/DAS_ID_SEQ.sql
PROMPT
PROMPT *** Running DSA_CAT_SEQ.sql
@sequences/DSA_CAT_SEQ.sql
PROMPT
PROMPT *** Running DT_ID_SEQ.sql
@sequences/DT_ID_SEQ.sql
PROMPT
PROMPT *** Running EDM_AUD_ID_SEQ.sql
@sequences/EDM_AUD_ID_SEQ.sql
PROMPT
PROMPT *** Running EDM_EVENT_AUD_ID_SEQ.sql
@sequences/EDM_EVENT_AUD_ID_SEQ.sql
PROMPT
PROMPT *** Running NOM_NOM_ID_SEQ.sql
@sequences/NOM_NOM_ID_SEQ.sql
PROMPT
PROMPT *** Running SLL_SEQ.sql
@sequences/SLL_SEQ.sql
PROMPT
PROMPT *** Running STD_NOTES_ID_SEQ.sql
@sequences/STD_NOTES_ID_SEQ.sql
PROMPT
PROMPT *** Running STCY_STUD_CRSE_YEAR_ID_SEQ.sql
@sequences/STCY_STUD_CRSE_YEAR_ID_SEQ.sql
PROMPT
PROMPT *** Running ST_SLC_REF_NO_SEQ.sql
@sequences/ST_SLC_REF_NO_SEQ.sql
PROMPT
PROMPT *** Running ST_STUD_REF_NO_SEQ.sql
@sequences/ST_STUD_REF_NO_SEQ.sql
PROMPT
PROMPT *** Running STCY_STUD_CRSE_YEAR_ID_SEQ.sql
@sequences/STCY_STUD_CRSE_YEAR_ID_SEQ.sql
PROMPT
PROMPT *** Running STD_STD_ID_SEQ.sql
@sequences/STD_STD_ID_SEQ.sql
PROMPT
PROMPT *** Running STS_STUD_SESSION_ID_SEQ.sql
@sequences/STS_STUD_SESSION_ID_SEQ.sql
--- 001
PROMPT
PROMPT *** Running AUDIT_SEQUENCES.sql
@sequences/AUDIT_SEQUENCES.sql
