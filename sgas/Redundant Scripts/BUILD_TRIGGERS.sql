--
-- COMPILE_TRIGGERS.sql
--
-- DESCRIPTION:
-- Build script to control creation of trigger required in the SGAS schema.
-- Outputs: output spooled to sgas_triggers.out
-- 
-- MODIFICATION HISTORY
-- Date          Author                 Ref    Desc
-- 19.02.08     SteveDurkin (Sopra UK)  001   Initial Version
-- 08.12.08     A.Bowman (SAAS)         002   Amended triggers for audit
-- 15.01.09     A.Bowman (SAAS)         003   Added triggers for payment table audit
-- 03.03.09     A.Bowman (SAAS)         004   Removed redundant payment audit triggers
-- 04.03.09     A.Bowman (SAAS)         005   Added triggers for payment error code and type
-- 14.04.09     A.Bowman (SAAS)         006   Removed redundant payment audit triggers
--
-- Configuration Management: 
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/BUILD_TRIGGERS.sql $ 
-- $Author: $ 
-- $Date: 2009-07-07 11:00:45 +0100 (Tue, 07 Jul 2009) $ 
-- $Revision: 3364 $ 

PROMPT
PROMPT *** Running triggers/AW_IUD.sql
@triggers/AW_IUD.sql
PROMPT
PROMPT *** Running triggers/AW_LUB.sql
@triggers/AW_LUB.sql
PROMPT
PROMPT *** Running triggers/AWI_IUD.sql
@triggers/AWI_IUD.sql
PROMPT
PROMPT *** Running triggers/AWI_BI.sql
@triggers/AWI_BI.sql
PROMPT
PROMPT *** Running triggers/AWI_LUB.sql
@triggers/AWI_LUB.sql
PROMPT
PROMPT *** Running triggers/BE_AU.sql
@triggers/BE_AU.sql
PROMPT
PROMPT *** Running triggers/BED_IUD.sql
@triggers/BED_IUD.sql
PROMPT
PROMPT *** Running triggers/BED_LUB.sql
@triggers/BED_LUB.sql
PROMPT
PROMPT *** Running triggers/BEI_IUD.sql
@triggers/BEI_IUD.sql
PROMPT
PROMPT *** Running triggers/BEI_LUB.sql
@triggers/BEI_LUB.sql
PROMPT
PROMPT *** Running triggers/BEN_IUD.sql
@triggers/BEN_IUD.sql
PROMPT
PROMPT *** Running triggers/BEN_LUB.sql
@triggers/BEN_LUB.sql
PROMPT
PROMPT *** Running triggers/CAT_IOF_INS.sql
@triggers/CAT_IOF_INS.sql
PROMPT
PROMPT *** Running triggers/CN_IUD.sql
@triggers/CN_IUD.sql
PROMPT
PROMPT *** Running triggers/CN_LUB.sql
@triggers/CN_LUB.sql
PROMPT
PROMPT *** Running triggers/JAC_IUD.sql
@triggers/JAC_IUD.sql
PROMPT
PROMPT *** Running triggers/JAC_LUB.sql
@triggers/JAC_LUB.sql
PROMPT
PROMPT *** Running triggers/ML_I.sql
@triggers/ML_I.sql
PROMPT
PROMPT *** Running triggers/SQD_IUD.sql
@triggers/SQD_IUD.sql
PROMPT
PROMPT *** Running triggers/SQD_LUB.sql
@triggers/SQD_LUB.sql
PROMPT
PROMPT *** Running triggers/ST_AU.sql
@triggers/ST_AU.sql
PROMPT
PROMPT *** Running triggers/ST_IUD.sql
@triggers/ST_IUD.sql
PROMPT
PROMPT *** Running triggers/ST_LUB.sql
@triggers/ST_LUB.sql
PROMPT
PROMPT *** Running triggers/STAPP_IUD.sql
@triggers/STAPP_IUD.sql
PROMPT
PROMPT *** Running triggers/STAPP_LUB.sql
@triggers/STAPP_LUB.sql
PROMPT
PROMPT *** Running triggers/STCY_IUD.sql
@triggers/STCY_IUD.sql
PROMPT
PROMPT *** Running triggers/STCY_LUB.sql
@triggers/STCY_LUB.sql
PROMPT
PROMPT *** Running triggers/STD_IUD.sql
@triggers/STD_IUD.sql
PROMPT
PROMPT *** Running triggers/STD_LUB.sql
@triggers/STD_LUB.sql
PROMPT
PROMPT *** Running triggers/STH_AIU.sql
@triggers/STH_AIU.sql
PROMPT
PROMPT *** Running triggers/STHOME_IUD.sql
@triggers/STHOME_IUD.sql
PROMPT
PROMPT *** Running triggers/STHOME_LUB.sql
@triggers/STHOME_LUB.sql
PROMPT
PROMPT *** Running triggers/STS_IUD.sql
@triggers/STS_IUD.sql
PROMPT
PROMPT *** Running triggers/STS_LUB.sql
@triggers/STS_LUB.sql
PROMPT
PROMPT *** Running triggers/STT_AIU.sql
@triggers/STT_AIU.sql
PROMPT
PROMPT *** Running triggers/STTERM_UD.sql
@triggers/STTERM_UD.sql
PROMPT
PROMPT *** Running triggers/STTRAV_UD.sql
@triggers/STTRAV_UD.sql
PROMPT
PROMPT *** Running triggers/SC_CHA_IUD.sql
@triggers/SC_CHA_IUD.sql
PROMPT
PROMPT *** Running triggers/SC_CHA_LUB.sql
@triggers/SC_CHA_LUB.sql
PROMPT
PROMPT *** Running triggers/SC_DAT_IUD.sql
@triggers/SC_DAT_IUD.sql
PROMPT
PROMPT *** Running triggers/SC_DAT_LUB.sql
@triggers/SC_DAT_LUB.sql
PROMPT
PROMPT *** Running triggers/SC_BAT_IUD.sql
@triggers/SC_BAT_IUD.sql
PROMPT
PROMPT *** Running triggers/SC_BAT_LUB.sql
@triggers/SC_BAT_LUB.sql
PROMPT
PROMPT *** Running triggers/CON_REL_IUD.sql
@triggers/CON_REL_IUD.sql
PROMPT
PROMPT *** Running triggers/CON_REL_LUB.sql
@triggers/CON_REL_LUB.sql
PROMPT
PROMPT *** Running triggers/LOC_IUD.sql
@triggers/LOC_IUD.sql
PROMPT
PROMPT *** Running triggers/LOC_LUB.sql
@triggers/LOC_LUB.sql
PROMPT
PROMPT *** Running triggers/PGCE_SUB_IUD.sql
@triggers/PGCE_SUB_IUD.sql
PROMPT
PROMPT *** Running triggers/PGCE_SUB_LUB.sql
@triggers/PGCE_SUB_LUB.sql
PROMPT
PROMPT *** Running triggers/PAY_METH_IUD.sql
@triggers/PAY_METH_IUD.sql
PROMPT
PROMPT *** Running triggers/PAY_METH_LUB.sql
@triggers/PAY_METH_LUB.sql
PROMPT
PROMPT *** Running triggers/AW_REF_DAT_IUD.sql
@triggers/AW_REF_DAT_IUD.sql
PROMPT
PROMPT *** Running triggers/AW_REF_DAT_LUB.sql
@triggers/AW_REF_DAT_LUB.sql
PROMPT
PROMPT *** Running triggers/SCH_TYPE_IUD.sql
@triggers/SCH_TYPE_IUD.sql
PROMPT
PROMPT *** Running triggers/SCH_TYPE_LUB.sql
@triggers/SCH_TYPE_LUB.sql
PROMPT
PROMPT *** Running triggers/BEN_INC_STAT_IUD.sql
@triggers/BEN_INC_STAT_IUD.sql		
PROMPT
PROMPT *** Running triggers/BEN_INC_STAT_LUB.sql
@triggers/BEN_INC_STAT_LUB.sql		
PROMPT
PROMPT *** Running triggers/BEN_INC_TYPE_IUD.sql
@triggers/BEN_INC_TYPE_IUD.sql
PROMPT
PROMPT *** Running triggers/BEN_INC_TYPE_LUB.sql
@triggers/BEN_INC_TYPE_LUB.sql		
PROMPT
PROMPT *** Running triggers/Z_REF_STAT_IUD.sql
@triggers/Z_REF_STAT_IUD.sql		
PROMPT
PROMPT *** Running triggers/Z_REF_STAT_LUB.sql
@triggers/Z_REF_STAT_LUB.sql
PROMPT
PROMPT *** Running triggers/DEAR_STAT_IUD.sql
@triggers/DEAR_STAT_IUD.sql
PROMPT
PROMPT *** Running triggers/DEAR_STAT_LUB.sql
@triggers/DEAR_STAT_LUB.sql
PROMPT
PROMPT *** Running triggers/LOAN_STAT_IUD.sql
@triggers/LOAN_STAT_IUD.sql		
PROMPT
PROMPT *** Running triggers/LOAN_STAT_LUB.sql
@triggers/LOAN_STAT_LUB.sql
PROMPT
PROMPT *** Running triggers/CASE_STAT_IUD.sql
@triggers/CASE_STAT_IUD.sql
PROMPT
PROMPT *** Running triggers/CASE_STAT_LUB.sql
@triggers/CASE_STAT_LUB.sql
PROMPT
PROMPT *** Running triggers/DEBT_STAT_IUD.sql
@triggers/DEBT_STAT_IUD.sql
PROMPT
PROMPT *** Running triggers/DEBT_STAT_LUB.sql
@triggers/DEBT_STAT_LUB.sql
PROMPT
PROMPT *** Running triggers/DIS_TYPE_IUD.sql
@triggers/DIS_TYPE_IUD.sql
PROMPT
PROMPT *** Running triggers/DIS_TYPE_LUB.sql
@triggers/DIS_TYPE_LUB.sql
PROMPT
PROMPT *** Running triggers/SPO_TYPE_IUD.sql
@triggers/SPO_TYPE_IUD.sql
PROMPT
PROMPT *** Running triggers/SPO_TYPE_LUB.sql
@triggers/SPO_TYPE_LUB.sql
PROMPT
PROMPT *** Running triggers/EMP_STAT_IUD.sql
@triggers/EMP_STAT_IUD.sql
PROMPT
PROMPT *** Running triggers/EMP_STAT_LUB.sql
@triggers/EMP_STAT_LUB.sql
PROMPT
PROMPT *** Running triggers/MAR_STAT_IUD.sql
@triggers/MAR_STAT_IUD.sql
PROMPT
PROMPT *** Running triggers/MAR_STAT_LUB.sql
@triggers/MAR_STAT_LUB.sql
PROMPT
PROMPT *** Running triggers/TITLE_IUD.sql
@triggers/TITLE_IUD.sql
PROMPT
PROMPT *** Running triggers/TITLE_LUB.sql
@triggers/TITLE_LUB.sql
PROMPT
PROMPT *** Running triggers/RES_TYPE_IUD.sql
@triggers/RES_TYPE_IUD.sql
PROMPT
PROMPT *** Running triggers/RES_TYPE_LUB.sql
@triggers/RES_TYPE_LUB.sql
PROMPT
PROMPT *** Running triggers/JOINT_APP_REL_IUD.sql
@triggers/JOINT_APP_REL_IUD.sql
PROMPT
PROMPT *** Running triggers/JOINT_APP_REL_LUB.sql
@triggers/JOINT_APP_REL_LUB.sql
PROMPT
PROMPT *** Running triggers/SUPP_GRANT_REL_IUD.sql
@triggers/SUPP_GRANT_REL_IUD.sql
PROMPT
PROMPT *** Running triggers/SUPP_GRANT_REL_LUB.sql
@triggers/SUPP_GRANT_REL_LUB.sql
PROMPT
PROMPT *** Running triggers/BEN_REL_IUD.sql
@triggers/BEN_REL_IUD.sql
PROMPT
PROMPT *** Running triggers/BEN_REL_LUB.sql
@triggers/BEN_REL_LUB.sql
PROMPT
PROMPT *** Running triggers/OTH_LOA_TYPE_IUD.sql
@triggers/OTH_LOA_TYPE_IUD.sql
PROMPT
PROMPT *** Running triggers/OTH_LOA_TYPE_LUB.sql
@triggers/OTH_LOA_TYPE_LUB.sql
PROMPT
PROMPT *** Running triggers/FEE_LOA_TYPE_IUD.sql
@triggers/FEE_LOA_TYPE_IUD.sql		
PROMPT
PROMPT *** Running triggers/FEE_LOA_TYPE_LUB.sql
@triggers/FEE_LOA_TYPE_LUB.sql