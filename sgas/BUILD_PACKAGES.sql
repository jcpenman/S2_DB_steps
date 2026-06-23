-- Build script to control compilation of packages required in the STEPS database SGAS schema.
--
-- If running into a new schema then the scripts will generate errors as they attempt to drop non-existant objects. 
-- If the script is run twice the first run will generate errors trying to drop non-existant objects; ignore all errors and allow the script to complete,
-- The second run should be error-free.
-- Alternatively scan the log from the first run to ensure no unexpected errors were encountered.
--
-- MODIFICATION HISTORY
-- Ref.     Date        Author                  Desc.
--          08/01/2008  S Durkin (Sopra UK)     Initial Version
-- 001      08/12/2008  A.Bowman (SAAS)         Added package for audit
-- 002      31/05/2010  A.Bowman (SAAS)         Updated this script to reflect the current position in SIT
-- 003      03/08/2010  A.Bowman (SAAS)         Updated this script to reflect the current position of DEV database which is awaiting release to SIT
-- 004      24/11/2010  A.Bowman (SAAS)         Added new package PK_STEPS_UI_PAYMENTS_SHARED
-- 005      26/11/2010  A.Bowman (SAAS)         Updated this script to reflect the current position in SIT 
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/BUILD_PACKAGES.sql $
-- $Author: $
-- $Date: 2012-01-24 11:43:46 +0000 (Tue, 24 Jan 2012) $
-- $Revision: 7654 $

PROMPT
PROMPT *** Build packages

PROMPT
PROMPT *** CHANGE_AUDIT
@packages/CHANGE_AUDIT.pks
@packages/CHANGE_AUDIT.pkb
PROMPT
PROMPT *** EDM_INDEX
@packages/EDM_INDEX.pks
@packages/EDM_INDEX.pkb
PROMPT
PROMPT *** EDM_INFO
@packages/EDM_INFO.pks
@packages/EDM_INFO.pkb
PROMPT
PROMPT *** ERROR
@packages/ERROR.pks
@packages/ERROR.pkb
PROMPT
PROMPT *** MAINTAIN_REPOSITORY 
@packages/MAINTAIN_REPOSITORY.pks
@packages/MAINTAIN_REPOSITORY.pkb
PROMPT
PROMPT *** NMSB_RULES_PROC_RECALC
@packages/NMSB_RULES_PROC_RECALC.pks
@packages/NMSB_RULES_PROC_RECALC.pkb
PROMPT
PROMPT *** PK_AWARD_NOTIFICATION
@packages/PK_AWARD_NOTIFICATION.pks
@packages/PK_AWARD_NOTIFICATION.pkb
PROMPT
PROMPT *** PK_CHANGE_DETAILS
@packages/PK_CHANGE_DETAILS.pks
@packages/PK_CHANGE_DETAILS.pkb
PROMPT
PROMPT *** PK_PAYMENTS
@packages/PK_PAYMENTS.pks
@packages/PK_PAYMENTS.pkb
PROMPT
PROMPT *** PK_SHORT_APPS
@packages/PK_SHORT_APPS.pks
@packages/PK_SHORT_APPS.pkb
PROMPT
PROMPT *** PK_SHORT_APPSGRASS
@packages/PK_SHORT_APPSGRASS.pks
@packages/PK_SHORT_APPSGRASS.pkb
PROMPT
PROMPT *** PK_SHORT_APPSNMSB
@packages/PK_SHORT_APPSNMSB.pks
@packages/PK_SHORT_APPSNMSB.pkb
PROMPT
PROMPT *** PK_SHORT_APPS_GRASS_NMSB
@packages/PK_SHORT_APPS_GRASS_NMSB.pks
@packages/PK_SHORT_APPS_GRASS_NMSB.pkb
PROMPT
PROMPT *** PK_STEPS_AUD
@packages/PK_STEPS_AUD.pks
@packages/PK_STEPS_AUD.pkb
PROMPT
PROMPT *** PK_STEPS_CHANGES
@packages/PK_STEPS_CHANGES.pks
@packages/PK_STEPS_CHANGES.pkb
PROMPT
PROMPT *** PK_STEPS_REPORTS
@packages/PK_STEPS_REPORTS.pks
@packages/PK_STEPS_REPORTS.pkb
PROMPT
PROMPT *** PK_STEPS_TO_GRASS
@packages/PK_STEPS_TO_GRASS.pks
@packages/PK_STEPS_TO_GRASS.pkb
PROMPT
PROMPT *** PK_STEPS_UI_AWARD
@packages/PK_STEPS_UI_AWARD.pks
@packages/PK_STEPS_UI_AWARD.pkb
PROMPT
PROMPT *** PK_STEPS_UI_BENE_DETS
@packages/PK_STEPS_UI_BENE_DETS.pks
@packages/PK_STEPS_UI_BENE_DETS.pkb
PROMPT
PROMPT *** PK_STEPS_UI_CASENOTES
@packages/PK_STEPS_UI_CASENOTES.pks
@packages/PK_STEPS_UI_CASENOTES.pkb
PROMPT
PROMPT *** PK_STEPS_UI_COURSE_DETS
@packages/PK_STEPS_UI_COURSE_DETS.pks
@packages/PK_STEPS_UI_COURSE_DETS.pkb
PROMPT
PROMPT *** PK_STEPS_UI_DOC_REG
@packages/PK_STEPS_UI_DOC_REG.pks
@packages/PK_STEPS_UI_DOC_REG.pkb
PROMPT
PROMPT *** PK_STEPS_UI_DSA
@packages/PK_STEPS_UI_DSA.pks
@packages/PK_STEPS_UI_DSA.pkb
PROMPT
PROMPT *** PK_STEPS_UI_EDM
@packages/PK_STEPS_UI_EDM.pks
@packages/PK_STEPS_UI_EDM.pkb
PROMPT
PROMPT *** PK_STEPS_UI_GRASS_DOC_REG
@packages/PK_STEPS_UI_GRASS_DOC_REG.pks
@packages/PK_STEPS_UI_GRASS_DOC_REG.pkb
PROMPT
PROMPT *** PK_STEPS_UI_GRASS_INSTALMENTS
@packages/PK_STEPS_UI_GRASS_INSTALMENTS.pks
@packages/PK_STEPS_UI_GRASS_INSTALMENTS.pkb
PROMPT
PROMPT *** PK_STEPS_UI_GRASS_JOINT_APP
@packages/PK_STEPS_UI_GRASS_JOINT_APP.pks
@packages/PK_STEPS_UI_GRASS_JOINT_APP.pkb
PROMPT
PROMPT *** PK_STEPS_UI_GRASS_SUPP_GRANTS
@packages/PK_STEPS_UI_GRASS_SUPP_GRANTS.pks
@packages/PK_STEPS_UI_GRASS_SUPP_GRANTS.pkb
PROMPT
PROMPT *** PK_STEPS_UI_HISTORY
@packages/PK_STEPS_UI_HISTORY.pks
@packages/PK_STEPS_UI_HISTORY.pkb
PROMPT
PROMPT *** PK_STEPS_UI_INCOME
@packages/PK_STEPS_UI_INCOME.pks
@packages/PK_STEPS_UI_INCOME.pkb
PROMPT
PROMPT *** PK_STEPS_UI_INSTALMENTS
@packages/PK_STEPS_UI_INSTALMENTS.pks
@packages/PK_STEPS_UI_INSTALMENTS.pkb
PROMPT
PROMPT *** PK_STEPS_UI_JOINT_APPLICATION
@packages/PK_STEPS_UI_JOINT_APPLICATION.pks
@packages/PK_STEPS_UI_JOINT_APPLICATION.pkb
PROMPT
PROMPT *** PK_STEPS_UI_LOAN
@packages/PK_STEPS_UI_LOAN.pks
@packages/PK_STEPS_UI_LOAN.pkb
PROMPT
PROMPT *** PK_STEPS_UI_MAINTAINDSAALLOW
@packages/PK_STEPS_UI_MAINTAINDSAALLOW.pks
@packages/PK_STEPS_UI_MAINTAINDSAALLOW.pkb
PROMPT
PROMPT *** PK_STEPS_UI_MAINTAINNOMINEE
@packages/PK_STEPS_UI_MAINTAINNOMINEE.pks
@packages/PK_STEPS_UI_MAINTAINNOMINEE.pkb
PROMPT
PROMPT *** PK_STEPS_UI_MAINTAINQA
@packages/PK_STEPS_UI_MAINTAINQA.pks
@packages/PK_STEPS_UI_MAINTAINQA.pkb
PROMPT
PROMPT *** PK_STEPS_UI_MANUAL_PAYMENTS
@packages/PK_STEPS_UI_MANUAL_PAYMENTS.pks
@packages/PK_STEPS_UI_MANUAL_PAYMENTS.pkb
PROMPT
PROMPT *** PK_STEPS_UI_MANUAL_REG
@packages/PK_STEPS_UI_MANUAL_REG.pks
@packages/PK_STEPS_UI_MANUAL_REG.pkb
PROMPT
PROMPT *** PK_STEPS_UI_NMSB_PLACEMENT_EXP
@packages/PK_STEPS_UI_NMSB_PLACEMENT_EXP.pks
@packages/PK_STEPS_UI_NMSB_PLACEMENT_EXP.pkb
PROMPT
PROMPT *** PK_STEPS_UI_PAYMENTS_SHARED
@packages/PK_STEPS_UI_PAYMENTS_SHARED.pks
@packages/PK_STEPS_UI_PAYMENTS_SHARED.pkb
PROMPT
PROMPT *** PK_STEPS_UI_RECORDLOCKING
@packages/PK_STEPS_UI_RECORDLOCKING.pks
@packages/PK_STEPS_UI_RECORDLOCKING.pkb
PROMPT
PROMPT *** PK_STEPS_UI_SHARED
@packages/PK_STEPS_UI_SHARED.pks
@packages/PK_STEPS_UI_SHARED.pkb
PROMPT
PROMPT *** PK_STEPS_UI_SHELL_LETTERS
@packages/PK_STEPS_UI_SHELL_LETTERS.pks
@packages/PK_STEPS_UI_SHELL_LETTERS.pkb
PROMPT
PROMPT *** PK_STEPS_UI_STUDY_ABROAD
@packages/PK_STEPS_UI_STUDY_ABROAD.pks
@packages/PK_STEPS_UI_STUDY_ABROAD.pkb
PROMPT
PROMPT *** PK_STEPS_UI_STUD_DETS
@packages/PK_STEPS_UI_STUD_DETS.pks
@packages/PK_STEPS_UI_STUD_DETS.pkb
PROMPT
PROMPT *** PK_STEPS_UI_SUMMARY
@packages/PK_STEPS_UI_SUMMARY.pks
@packages/PK_STEPS_UI_SUMMARY.pkb
PROMPT
PROMPT *** PK_STEPS_UI_SUPP_GRANTS
@packages/PK_STEPS_UI_SUPP_GRANTS.pks
@packages/PK_STEPS_UI_SUPP_GRANTS.pkb
PROMPT
PROMPT *** PK_STEPS_UTILS
@packages/PK_STEPS_UTILS.pks
@packages/PK_STEPS_UTILS.pkb
PROMPT
PROMPT *** PK_STEPS_WEB
@packages/PK_STEPS_WEB.pks
@packages/PK_STEPS_WEB.pkb
PROMPT
PROMPT *** RULES_PROC_RECALC
@packages/RULES_PROC_RECALC.pks
@packages/RULES_PROC_RECALC.pkb
PROMPT
PROMPT *** SCRIPTEX
@packages/SCRIPTEX.pks
@packages/SCRIPTEX.pkb
PROMPT
PROMPT *** SHORTENED_APPLICATION_WEB_ST
@packages/SHORTENED_APPLICATION_WEB_ST.pks
@packages/SHORTENED_APPLICATION_WEB_ST.pkb
PROMPT
PROMPT *** TELEPHONY_SUPPORT
@packages/TELEPHONY_SUPPORT.pks
@packages/TELEPHONY_SUPPORT.pkb

