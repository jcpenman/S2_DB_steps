-- STUD_CRSE_YEAR
--
-- Modification History
-- Date        Author       Ref    Desc
-- 21.02.11   A.Bowman      014    Added new column NON_ERASMUS_EXCHANGE
-- 09.12.10   A.Bowman      013    Added new column CHNG_SINCE_LAST_REPORT, REG_CONFIRMED, ONGOING_ATTEND
-- 03.06.10   A.Bowman      012    Added new column CRSE_SUSPEND
-- 29.04.10   A.Bowman      011    Added foreign key references
-- 28.01.10   A.Bowman      010    Amended audit triggers
-- 22.01.10   A.Bowman      009    Added new column PSAS_PT as a result of CR - Post Graduate Funding Changes 2010
-- 15.10.09   A.Bowman      008    Added materialized view log script
-- 30.09.09   A.Bowman      007    Added new column calc_sma as result of CR
-- 27.08.09   A.Bowman      006    Added new auditable column first_calc_date to trigger sgas.stcy_iud as part of History requirements 
-- 22.06.09   A.Bowman      005    Added audit triggers.
-- 11.11.08   Robert Hunter 004    New columns for NMSB project
-- 28.02.08   Steve Durkin  003    Add PGCE cols.
-- 25.02.08   Steve Durkin  002    Increase PAGE_INCOMPLETE (varchar2) from 25 to 100 bytes.  
-- 15.02.08   Steve Durkin  001    New columns.
-- 
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STUD_CRSE_YEAR.sql $
-- $Author: $
-- $Date: 2011-02-21 14:24:31 +0000 (Mon, 21 Feb 2011) $
-- $Revision: 6493 $

ALTER TABLE SGAS.STUD_CRSE_YEAR
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.STUD_CRSE_YEAR CASCADE CONSTRAINTS PURGE
/

--
-- STUD_CRSE_YEAR  (Table) 
--
CREATE TABLE SGAS.STUD_CRSE_YEAR
(
  STUD_CRSE_YEAR_ID             NUMBER(9) CONSTRAINT NN_STCY_STUD_CRSE_YEAR_ID NOT NULL,
  STUD_SESSION_ID               NUMBER(9) CONSTRAINT NN_STCY_STUD_SESSION_ID NOT NULL,
  STUD_REF_NO                   NUMBER(10) CONSTRAINT NN_STCY_STUD_REF_NO NOT NULL,
  INST_CODE                     VARCHAR2(5 BYTE) CONSTRAINT NN_STCY_INST_CODE NOT NULL,
  INST_NAME                     VARCHAR2(50 BYTE) CONSTRAINT NN_STCY_INST_NAME NOT NULL,
  SESSION_CODE                  NUMBER(4) CONSTRAINT NN_STCY_SESSION_CODE NOT NULL,
  LATEST_CRSE_IND               VARCHAR2(1 BYTE) DEFAULT 'Y' CONSTRAINT NN_STCY_LATEST_CRSE_IND NOT NULL,
  AWARD_LETTER_NO               NUMBER(2) DEFAULT 0 CONSTRAINT NN_STCY_AWARD_LETTER_NO NOT NULL,
  CASE_COMPLEX                  VARCHAR2(1 BYTE) CONSTRAINT NN_STCY_CASE_COMPLEX NOT NULL,
  ENTERED_DATE                  DATE DEFAULT SYSDATE CONSTRAINT NN_STCY_ENTERED_DATE NOT NULL,
  ARA_SENT                      VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STCY_ARA_SENT NOT NULL,
  SAL_SENT                      VARCHAR2(1 BYTE) DEFAULT 'Y' CONSTRAINT NN_STCY_SAL_SENT NOT NULL,
  PAL_SENT                      VARCHAR2(1 BYTE) DEFAULT 'Y' CONSTRAINT NN_STCY_PAL_SENT NOT NULL,
  TEL_SENT                      VARCHAR2(1 BYTE) DEFAULT 'Y' CONSTRAINT NN_STCY_TEL_SENT NOT NULL,
  ARA_SENT_DATE                 DATE,
  SAL_SENT_DATE                 DATE,
  PAL_SENT_DATE                 DATE,
  TEL_SENT_DATE                 DATE,
  CORRES_DEST                   VARCHAR2(1 BYTE) DEFAULT 'H' CONSTRAINT NN_STCY_CORRES_DEST NOT NULL,
  TWO_HOME                      VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STCY_TWO_HOME NOT NULL,
  OWNS_HOME                     VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STCY_OWNS_HOME NOT NULL,
  OWN_HOME_RENT                 VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STCY_OWN_HOME_RENT NOT NULL,
  INST_CHANGE                   VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STCY_INST_CHANGE NOT NULL,
  TRANSFER_CERT                 VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STCY_TRANSFER_CERT NOT NULL,
  UNCONDITIONAL                 VARCHAR2(1 BYTE) DEFAULT 'Y' CONSTRAINT NN_STCY_UNCONDITIONAL NOT NULL,
  STUDY_ABROAD                  VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STCY_STUDY_ABROAD NOT NULL,
  PARENT_CONTRIB_EXEMPT         VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STCY_PARENT_CONTRIB_EXEMPT NOT NULL,
  Z_REF_STATUS                  VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STCY_Z_REF_STATUS NOT NULL,
  FORM_COMP                     VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STCY_FORM_COMP NOT NULL,
  APPLICATION_STATUS            VARCHAR2(1 BYTE) CONSTRAINT NN_STCY_APPLICATION_STATUS NOT NULL,
  PROVISIONAL_CASE              VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STCY_PROVISIONAL_CASE NOT NULL,
  CRSE_YEAR_NO                  NUMBER(2),
  CRSE_YEAR_ID                  NUMBER(9),
  CRSE_ID                       NUMBER(9),
  CRSE_NAME                     VARCHAR2(50 BYTE),
  CRSE_CODE                     VARCHAR2(4 BYTE),
  SCHEME_TYPE                   VARCHAR2(1 BYTE),
  AWARD                         VARCHAR2(1 BYTE) DEFAULT 'E',
  START_DATE                    DATE,
  PSAS_APPLIC_RESULT            VARCHAR2(1 BYTE),
  EC_ENDORSE                    VARCHAR2(25 BYTE),
  WITHDRAW_DATE                 DATE,
  VACATION                      NUMBER(2),
  CRSE_CHG                      DATE,
  STUDY_COUNTRY                 NUMBER(3),
  SNB_GRAD                      VARCHAR2(1 BYTE),
  GRAD_SESSION                  NUMBER(4),
  MSS_YEARS                     NUMBER(2),
  PREV_SSS_APP                  VARCHAR2(1 BYTE),
  AWARD_LETTER_DATE             VARCHAR2(1 BYTE) DEFAULT 'N',
  PREVIOUS_RESULT               VARCHAR2(3 BYTE),
  PREV_SSS_APP_YEAR             VARCHAR2(4 BYTE),
  RESULT_PREV_SSS               VARCHAR2(1 BYTE),
  SSS_APP_OFFER                 VARCHAR2(1 BYTE),
  SSS_APP_RESULT                VARCHAR2(1 BYTE),
  OUTSCOT_RESULT                VARCHAR2(1 BYTE),
  START_DATE_ABROAD             DATE,
  END_DATE_ABROAD               DATE,
  AUTO_CALC_DATE                DATE,
  DECLARATION_DATE              DATE,
  Z_REF_DATE                    DATE,
  Z_REF_PROC_DATE               DATE,
  RESID_SPONSOR_CONT            NUMBER(9,2),
  SPONSOR_CONT                  NUMBER(9,2),
  TOTAL_SPONSOR                 NUMBER(9,2),
  RESID_PAR_CONT                NUMBER(9,2),
  RESID_SPOUSE_CONT             NUMBER(9,2),
  RESID_STUD_CONT               NUMBER(9,2),
  PARENT_CONT                   NUMBER(9,2),
  SPOUSE_CONT                   NUMBER(9,2),
  STUD_CONT                     NUMBER(9,2),
  DISABLEMENT_CODE              NUMBER(4),
  -- 002 
  PAGE_INCOMPLETE               VARCHAR2(100 BYTE),
  DIET_NEED_LET                 VARCHAR2(1 BYTE),
  RESID_TRAV_ALLOW              NUMBER(9,2),
  SML_EQUIP_DESCRIPT            VARCHAR2(100 BYTE),
  SML_EQUIP_RQST                NUMBER(9,2),
  SML_EQUIP_APPROVE             NUMBER(9,2),
  LGE_EQUIP_DESCRIPT            VARCHAR2(100 BYTE),
  LGE_EQUIP_APPROVE             NUMBER(9,2),
  LGE_EQUIP_RQST                NUMBER(9,2),
  DIET_NEED_DESCRIPT            VARCHAR2(100 BYTE),
  DIET_NEED_REQ                 NUMBER(9,2),
  DIET_NEED_APPROVE             NUMBER(9,2),
  NON_MED_REQ                   NUMBER(9,2),
  NON_MED_APPROVE               NUMBER(9,2),
  NON_MED_DESCRIPT              VARCHAR2(100 BYTE),
  PROVISIONAL_DATE              DATE,
  MAX_TRAV_AWARD                VARCHAR2(1 BYTE),
  PREV_QUAL                     VARCHAR2(10 BYTE),
  PREV_INST_CODE                VARCHAR2(5 BYTE),
  PREV_INST_NAME                VARCHAR2(50 BYTE),
  PREV_CRSE_CODE                VARCHAR2(4 BYTE),
  PREV_CRSE_NAME                VARCHAR2(50 BYTE),
  STUDY_CAMPUS                  VARCHAR2(1 BYTE),
  FEES_CAMPUS                   VARCHAR2(1 BYTE),
  MAINT_CAMPUS                  VARCHAR2(1 BYTE),
  CONT_RATES_DATE               DATE,
  REMARK                        VARCHAR2(500 BYTE),
  SAL_DEST                      VARCHAR2(1 BYTE) DEFAULT '1',
  PAL_DEST                      VARCHAR2(1 BYTE) DEFAULT '2',
  DA_ADVANCE                    NUMBER(9,2),
  DPNDNTS_MOVED                 NUMBER(2)       DEFAULT 0,
  TOT_JA_STUDS_REG              NUMBER(2),
  SUPP_PAYMENTS                 VARCHAR2(1 BYTE) DEFAULT 'N',
  BATCH_RECALC                  VARCHAR2(1 BYTE) DEFAULT 'N',
  DEARING                       VARCHAR2(1 BYTE) DEFAULT 'N',
  DEARING_CHANGE_DATE           DATE,
  NEG_CON_DEBT                  NUMBER(9,2)     DEFAULT 0,
  FIRST_EMP                     VARCHAR2(15 BYTE),
  FIRST_CALC_DATE               DATE,
  FIRST_SAL_DATE                DATE,
  DSS_INCOME_ONLY               VARCHAR2(1 BYTE) DEFAULT 'N',
  STATUS_CHANGED                DATE,
  CONTRIB_CHANGED               DATE,
  NET_AMOUNT_CHANGED            DATE,
  REPEAT_YEAR                   VARCHAR2(1 BYTE),
  SLC1_STATUS                   VARCHAR2(1 BYTE),
  SLC2_STATUS                   VARCHAR2(1 BYTE),
  SLC1_SENT                     VARCHAR2(1 BYTE),
  SLC2_SENT                     VARCHAR2(1 BYTE),
  SLC1_SENT_DATE                DATE,
  SLC2_SENT_DATE                DATE,
  FIRST_SLC1_SENT_DATE          DATE,
  FIRST_SLC2_SENT_DATE          DATE,
  EXTRA_WEEKS_SUPPORT           NUMBER(9,2),
  LOAN_GIVEN                    VARCHAR2(1 BYTE),
  LOAN_ELIGIBILITY_ONLY         VARCHAR2(1 BYTE) DEFAULT 'N',
  PAID_SANDWICH                 VARCHAR2(1 BYTE) DEFAULT 'N',
  UNPAID_SANDWICH               VARCHAR2(1 BYTE) DEFAULT 'N',
  ERASMUS                       VARCHAR2(1 BYTE) DEFAULT 'N',
  NON_ERASMUS_EXCHANGE          VARCHAR2(1 BYTE) DEFAULT 'N',
  HEI_PAYMENT_ROUTE             VARCHAR2(1 BYTE),
  USED_ERASMUS_CB               NUMBER(9,2),
  USED_SANDWICH_CB              NUMBER(9,2),
  WD_DEBT                       NUMBER(9,2),
  FAST_TRACK                    VARCHAR2(1 BYTE),
  SNB_RATE                      VARCHAR2(1 BYTE),
  INDEPENDENT                   VARCHAR2(1 BYTE),
  PAY_YSB                       VARCHAR2(1 BYTE),
  REQ_DUP                       VARCHAR2(1 BYTE),
  OS_ADD_PAY                    NUMBER(9,2),
  CONT_MOVED                    NUMBER(9,2),
  OA_ADVANCE                    NUMBER(9,2),
  DUE_YSB_YSO_IND               VARCHAR2(1 BYTE),
  WEB_SUBMITTED                 DATE,
  LPCG_ADVANCE                  NUMBER(9,2),
  DSA_FEE_DESCRIPT              VARCHAR2(100 BYTE),
  DSA_FEE_RQST                  NUMBER(9,2),
  DSA_FEE_APPROVE               NUMBER(9,2),
  TRAV_SUBMITTED_DATE           DATE,
  ATTEND_REQD                   VARCHAR2(1 BYTE),
  ATTEND_CONFIRMED              VARCHAR2(1 BYTE),
  HEI_DATE_ATTENDED             DATE,
  NON_ATT_ACTIONED              VARCHAR2(1 BYTE),
  NON_ATT_ACTIONED_DATE         DATE,
  SHORT_APP_AUTO_CALC_DATE      DATE,
  PGCE                          VARCHAR2(1 BYTE),
  SELF_FUNDING                  VARCHAR2(1 BYTE),
  VARIABLE_FEE_OVERRIDE_AMOUNT  NUMBER(7,2),
  FEE_LOAN_ELIGIBILITY_ONLY     VARCHAR2(1 BYTE),
  FEE_LOAN_GIVEN                VARCHAR2(1 BYTE),
  HOUSEHOLD_RESID_INCOME        NUMBER(9,2),
  BEN1_TOTAL_INCOME             NUMBER(9,2),
  BEN2_TOTAL_INCOME             NUMBER(9,2),
  NMSB_SESSION_CALC             NUMBER(4),
  SNB_SINGLE_RATE               VARCHAR2(1 BYTE),
  -- 003
  pgce_edu_level                varchar2(10), 
  pgce_subject                  varchar2(20),
  -- 001
  CALC_FEE         VARCHAR2(1) DEFAULT 'Y' CONSTRAINT nn_stcy_calc_fee       NOT NULL,
  ASSESS_LOAN      VARCHAR2(1) DEFAULT 'N' CONSTRAINT nn_stcy_assess_loan    NOT NULL,
  CALC_LOAN        VARCHAR2(1) DEFAULT 'N' CONSTRAINT nn_stcy_calc_loan      NOT NULL,
  CALC_BURSARY     VARCHAR2(1) DEFAULT 'Y' CONSTRAINT nn_stcy_calc_bursary   NOT NULL,
  CALC_DEP_GRANT   VARCHAR2(1) DEFAULT 'N' CONSTRAINT nn_stcy_calc_dep_grant NOT NULL,
  CALC_LPG         VARCHAR2(1) DEFAULT 'N' CONSTRAINT nn_stcy_calc_lpg       NOT NULL,
  CALC_LPCG        VARCHAR2(1) DEFAULT 'N' CONSTRAINT nn_stcy_calc_lpcg      NOT NULL,
  -- 004 start RH
  NMSB_INIT_EXPENSES	 	VARCHAR2(1),
  CALC_NMSB	 	 	VARCHAR2(1),
  CALC_SPA	 	 	VARCHAR2(1),
  NMSB_PART_TIME	 	VARCHAR2(1),  
  -- 004 end   RH
  -- 007 
  CALC_SMA                      VARCHAR2(1),
  -- 009
  PSAS_PT                       VARCHAR2(1),
  CRSE_SUSPEND                  VARCHAR2(1 BYTE) DEFAULT 'N',
  CHNG_SINCE_LAST_REPORT        VARCHAR2(1),
  REG_CONFIRMED                 VARCHAR2(1),
  ONGOING_ATTEND                VARCHAR2(1),                      
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_STCY_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_STCY_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2700K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON COLUMN SGAS.STUD_CRSE_YEAR.HOUSEHOLD_RESID_INCOME IS 'The sum of benefactor residual incomes (total income - less disregards)'
/
COMMENT ON COLUMN SGAS.STUD_CRSE_YEAR.BEN1_TOTAL_INCOME IS 'The total gross income for benefactor 1'
/
COMMENT ON COLUMN SGAS.STUD_CRSE_YEAR.BEN2_TOTAL_INCOME IS 'The total gross income for benefactor 2'
/
-- 001
COMMENT ON COLUMN SGAS.STUD_CRSE_YEAR.CALC_FEE        IS 'Calculate fee indicator. Fees will be calculatee if set to "Y".'
/
COMMENT ON COLUMN SGAS.STUD_CRSE_YEAR.ASSESS_LOAN     IS 'Assess loan indicator. Loan entitlemenet will be assessed if set to "Y". (This is not the same as CALCULATING loan entitlement.)'
/
COMMENT ON COLUMN SGAS.STUD_CRSE_YEAR.CALC_LOAN       IS 'Calculate loan indicator - laon entitlement will be calculated if set to "Y".'
/
COMMENT ON COLUMN SGAS.STUD_CRSE_YEAR.CALC_BURSARY    IS 'Calculate bursary indicator. Bursary allowance will be calculated if set to "Y".'
/
COMMENT ON COLUMN SGAS.STUD_CRSE_YEAR.CALC_DEP_GRANT  IS 'Calculate dependants grant inidicator. Dependants grant will be calculated if set to "Y"'
/
COMMENT ON COLUMN SGAS.STUD_CRSE_YEAR.CALC_LPG        IS 'Calculate LPG indicator - Lone Parents Grant will be calculated if set to "Y".'
/
COMMENT ON COLUMN SGAS.STUD_CRSE_YEAR.CALC_LPCG       IS 'Calculate LPCG indicator. Lone Parents Childcare Grant will be calculated if set to "Y"'
/

-- 004 start RH
COMMENT ON COLUMN SGAS.STUD_CRSE_YEAR.NMSB_INIT_EXPENSES        IS  'Indicates whether the student should have Initial expenses awarded for the course year.'
/
COMMENT ON COLUMN SGAS.STUD_CRSE_YEAR.CALC_NMSB                 IS  'Indicates whether the student should have NMSB calculated for the course year.'
/
COMMENT ON COLUMN SGAS.STUD_CRSE_YEAR.CALC_SPA                  IS  'Indicates whether the students should have single parents allowance calculated for the course year.'
/
COMMENT ON COLUMN SGAS.STUD_CRSE_YEAR.NMSB_PART_TIME            IS  'Indicates whether the students is enrolled on a part time course.'
/
-- 004 end RH

--
-- S2_STCY  (Index) 
--
CREATE INDEX S2_STCY ON SGAS.STUD_CRSE_YEAR
(CRSE_YEAR_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

--
-- S5_STCY  (Index) 
--
CREATE INDEX S5_STCY ON SGAS.STUD_CRSE_YEAR
(CRSE_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          300K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S7_STCY  (Index) 
--
CREATE INDEX S7_STCY ON SGAS.STUD_CRSE_YEAR
(Z_REF_DATE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S4_STCY  (Index) 
--
CREATE INDEX S4_STCY ON SGAS.STUD_CRSE_YEAR
(INST_CODE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          300K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S3_STCY  (Index) 
--
CREATE INDEX S3_STCY ON SGAS.STUD_CRSE_YEAR
(STUD_REF_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          300K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S8_STCY  (Index) 
--
CREATE INDEX S8_STCY ON SGAS.STUD_CRSE_YEAR
(DISABLEMENT_CODE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- P_STCY  (Index) 
--
CREATE UNIQUE INDEX P_STCY ON SGAS.STUD_CRSE_YEAR
(STUD_CRSE_YEAR_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S9_STCY  (Index) 
--
CREATE INDEX S9_STCY ON SGAS.STUD_CRSE_YEAR
(SESSION_CODE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             122K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S1_STCY  (Index) 
--
CREATE INDEX S1_STCY ON SGAS.STUD_CRSE_YEAR
(STUD_SESSION_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          300K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S6_STCY  (Index) 
--
CREATE INDEX S6_STCY ON SGAS.STUD_CRSE_YEAR
(SCHEME_TYPE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

CREATE OR REPLACE TRIGGER SGAS.stcy_iud
   AFTER INSERT OR DELETE OR UPDATE OF sal_sent, application_status, inst_change, parent_contrib_exempt,
             award, start_date, withdraw_date, vacation, crse_chg,study_country, snb_grad, award_letter_date, 
             award_letter_no, batch_recalc, dearing, resid_par_cont, 
             resid_spouse_cont,resid_stud_cont, parent_cont, spouse_cont, stud_cont,resid_trav_allow, sml_equip_rqst, 
             sml_equip_approve,lge_equip_descript,lge_equip_approve, lge_equip_rqst, diet_need_descript,disablement_code,
             end_date_abroad,erasmus, diet_need_req,diet_need_approve, non_med_req, 
             non_med_approve,provisional_case,provisional_date,repeat_year, req_dup, session_code, crse_year_no, inst_code, crse_id,
             unconditional, slc1_status, slc2_status,loan_given,latest_crse_ind,auto_calc_date,dsa_fee_descript,dsa_fee_rqst,
             dsa_fee_approve,attend_reqd, attend_confirmed,hei_date_attended, non_att_actioned, non_att_actioned_date, 
             trav_submitted_date,sal_sent_date, sal_dest, variable_fee_override_amount, fee_loan_given, fee_loan_eligibility_only,
             pgce, self_funding, independent, due_ysb_yso_ind, household_resid_income, ben1_total_income, ben2_total_income,
             snb_single_rate, nmsb_session_calc,start_date_abroad, study_abroad, unpaid_sandwich, paid_sandwich, calc_fee, calc_bursary,
             calc_loan, calc_dep_grant, calc_lpg, calc_lpcg, pay_ysb, pgce_edu_level, pgce_subject, first_calc_date, psas_pt, crse_suspend,last_updated_by
   ON SGAS.STUD_CRSE_YEAR    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    stud_crse_year_aud.column_name%TYPE   := NULL;
   p_table_pkey1    stud_crse_year_aud.table_pkey1%TYPE
                                          := TO_CHAR (:OLD.stud_crse_year_id);
   p_table_pkey2    stud_crse_year_aud.table_pkey2%TYPE   := NULL;
   p_table_pkey3    stud_crse_year_aud.table_pkey3%TYPE   := NULL;
   p_table_pkey4    stud_crse_year_aud.table_pkey4%TYPE   := NULL;
   p_table_pkey5    stud_crse_year_aud.table_pkey5%TYPE   := NULL;
   p_old            stud_crse_year_aud.OLD%TYPE           := NULL;
   p_new            stud_crse_year_aud.NEW%TYPE           := NULL;
   p_action         stud_crse_year_aud.action%TYPE        := NULL;
   p_username       stud_crse_year_aud.username%TYPE      := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    stud_crse_year_aud.stud_ref_no%TYPE   := NULL;
   p_inst_code      stud_crse_year_aud.inst_code%TYPE     := NULL;
   p_table_name     VARCHAR2 (32)                         := 'STUD_CRSE_YEAR';
   will_update      VARCHAR2 (1)                          := 'N';
   p_session_code   stud_crse_year.session_code%TYPE     := :NEW.session_code;
   p_dob            stud.dob%TYPE                         := NULL;
   p_initials       stud.initials%TYPE                    := NULL;
   p_forenames      stud.forenames%TYPE                   := NULL;
   p_surname        stud.surname%TYPE                     := NULL;
   p_ni_no          stud.ni_no%TYPE                       := NULL;
   p_mobile         stud.mobile_tel_no%TYPE               := NULL;
   p_email          stud.email_addr%TYPE                  := NULL;
   p_calc           DATE;
   p_sent           DATE;
   v_updated        VARCHAR2 (1)                          := 'N';
--
-----------------------------------------------------------------------------------------------------------------------------
--
   v_result         VARCHAR2 (1);
   v_default_date   DATE            := TO_DATE ('01/JAN/2000', 'DD/MON/YYYY');
    --
-----------------------------------------------------------------------------------------------------------------------------
--
--
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.LAST_UPDATED_BY;
      --
      -- TR 190 fix.
      -- Set P_SESSION_CODE to :OLD.SESSION_CODE as :NEW.SESSION_CODE will not
      -- exist.
      --
      p_session_code := :OLD.session_code;

      --
      -- End of TR 190 fix.
      --
      IF maintain_repository.latest_stud_crse_year (:OLD.stud_ref_no,
                                                    :OLD.session_code,
                                                    :OLD.latest_crse_ind
                                                   ) = 'Y'
      THEN
         v_result :=
            maintain_repository.record_app_status (:OLD.stud_ref_no,
                                                   'D',
                                                   :OLD.stud_crse_year_id,
                                                   SYSDATE
                                                  );
      END IF;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
      p_table_pkey1 := :NEW.stud_crse_year_id;
      p_dob := NULL;
      p_initials := NULL;
      p_forenames := NULL;
      p_surname := NULL;
      p_ni_no := NULL;
      p_mobile := NULL;
      p_email := NULL;
      p_calc := :NEW.auto_calc_date;
      p_sent := :NEW.sal_sent_date;
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   ELSIF UPDATING
   THEN
      p_action := 'U';

          /* Removed the following as Oracle 9 doesn't like
          numerics being set to ' ' */
      /*if (nvl(:old.SESSION_CODE,' ')  <> nvl(:new.SESSION_CODE,' ')) then
          WILL_UPDATE := 'Y';
      elsif (nvl(:old.CRSE_YEAR_NO,' ')     <> nvl(:new.CRSE_YEAR_NO,' ')) then
          WILL_UPDATE := 'Y';
      elsif (nvl(:old.INST_CODE,' ')     <> nvl(:new.INST_CODE,' ')) then
          WILL_UPDATE := 'Y';
      elsif (nvl(:old.CRSE_ID,' ')     <> nvl(:new.CRSE_ID,' ')) then
          WILL_UPDATE := 'Y';
      end if; */
      IF :OLD.session_code <> :NEW.session_code
      THEN
         will_update := 'Y';
      ELSIF :OLD.crse_year_no <> :NEW.crse_year_no
      THEN
         will_update := 'Y';
      ELSIF (NVL (:OLD.inst_code, ' ') <> NVL (:NEW.inst_code, ' '))
      THEN
         will_update := 'Y';
      ELSIF :OLD.crse_id <> :NEW.crse_id
      THEN
         will_update := 'Y';
      END IF;

      IF will_update = 'Y'
      THEN
         pk_steps_changes.stud_crse_year_rep (:OLD.stud_crse_year_id,
                                  :NEW.session_code,
                                  :NEW.crse_year_no,
                                  :NEW.inst_code,
                                  :NEW.crse_id
                                 );
      END IF;

      /* check if a calculation has just been performed */
      IF NVL (:OLD.auto_calc_date, v_default_date) <>
                                     NVL (:NEW.auto_calc_date, v_default_date)
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* set the application status to be calculated */
            v_result :=
               maintain_repository.record_app_status (:NEW.stud_ref_no,
                                                      'C',
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.auto_calc_date
                                                     );
         END IF;
      END IF;

      /* check if the award letter has just been sent */
      IF NVL (:NEW.sal_sent, 'Y') = 'Y' AND NVL (:OLD.sal_sent, 'Y') = 'N'
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* set the application status to be letter issued */
            v_result :=
               maintain_repository.record_app_status (:NEW.stud_ref_no,
                                                      'L',
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.sal_sent_date
                                                     );
         END IF;
      END IF;

      /* check if the slc status (file 2) has been updated to sent */
      /* RAM SIR7 16/03/2004 */
      IF (   (    NVL (:OLD.slc2_status, 'A') <> NVL (:NEW.slc2_status, 'A')
              AND NVL (:NEW.slc2_status, 'A') = 'S'
             )
          OR (    NVL (:OLD.slc2_sent, 'A') <> NVL (:NEW.slc2_sent, 'A')
              AND NVL (:NEW.slc2_sent, 'A') = 'Y'
              AND NVL (:NEW.slc2_status, 'A') = 'S'
             )
         )
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* set the application status to be slc data sent */
            v_result :=
               maintain_repository.record_app_status (:NEW.stud_ref_no,
                                                      'S',
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.slc2_sent_date
                                                     );
         END IF;
      END IF;

      /* TR 1537 - check if the latest_crse_ind has been updated to 'Y' */
      IF :OLD.latest_crse_ind = 'N' AND :NEW.latest_crse_ind = 'Y'
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* create a new record as previous one has been deleted */
            v_result :=
               maintain_repository.create_app_status (:NEW.stud_ref_no,
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.session_code,
                                                      :NEW.entered_date,
                                                      :NEW.auto_calc_date,
                                                      :NEW.sal_sent_date,
                                                      :NEW.slc2_sent_date
                                                     );
         END IF;
      END IF;
   END IF;

   p_column_name := 'SAL_SENT';
   p_old := :OLD.sal_sent;
   p_new := :NEW.sal_sent;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'APPLICATION_STATUS';
   p_old := :OLD.application_status;
   p_new := :NEW.application_status;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'INST_CHANGE';
   p_old := :OLD.inst_change;
   p_new := :NEW.inst_change;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PARENT_CONTRIB_EXEMPT';
   p_old := :OLD.parent_contrib_exempt;
   p_new := :NEW.parent_contrib_exempt;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'AWARD';
   p_old := :OLD.award;
   p_new := :NEW.award;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'START_DATE';
   p_old := TO_CHAR (:OLD.start_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.start_date, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'WITHDRAW_DATE';
   p_old := TO_CHAR (:OLD.withdraw_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.withdraw_date, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'VACATION';
   p_old := TO_CHAR (:OLD.vacation);
   p_new := TO_CHAR (:NEW.vacation);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CRSE_CHG';
   p_old := TO_CHAR (:OLD.crse_chg, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.crse_chg, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'STUDY_COUNTRY';
   p_old := TO_CHAR (:OLD.study_country);
   p_new := TO_CHAR (:NEW.study_country);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SNB_GRAD';
   p_old := :OLD.snb_grad;
   p_new := :NEW.snb_grad;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'AWARD_LETTER_DATE';
   p_old := :OLD.award_letter_date;
   p_new := :NEW.award_letter_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'AWARD_LETTER_NO';
   p_old := :OLD.award_letter_no;
   p_new := :NEW.award_letter_no;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'BATCH_RECALC';
   p_old := :OLD.batch_recalc;
   p_new := :NEW.batch_recalc;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DEARING';
   p_old := :OLD.dearing;
   p_new := :NEW.dearing;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'RESID_PAR_CONT';
   p_old := TO_CHAR (:OLD.resid_par_cont);
   p_new := TO_CHAR (:NEW.resid_par_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'RESID_SPOUSE_CONT';
   p_old := TO_CHAR (:OLD.resid_spouse_cont);
   p_new := TO_CHAR (:NEW.resid_spouse_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'RESID_STUD_CONT';
   p_old := TO_CHAR (:OLD.resid_stud_cont);
   p_new := TO_CHAR (:NEW.resid_stud_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PARENT_CONT';
   p_old := TO_CHAR (:OLD.parent_cont);
   p_new := TO_CHAR (:NEW.parent_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SPOUSE_CONT';
   p_old := TO_CHAR (:OLD.spouse_cont);
   p_new := TO_CHAR (:NEW.spouse_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'STUD_CONT';
   p_old := TO_CHAR (:OLD.stud_cont);
   p_new := TO_CHAR (:NEW.stud_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'RESID_TRAV_ALLOW';
   p_old := TO_CHAR (:OLD.resid_trav_allow);
   p_new := TO_CHAR (:NEW.resid_trav_allow);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SML_EQUIP_RQST';
   p_old := TO_CHAR (:OLD.sml_equip_rqst);
   p_new := TO_CHAR (:NEW.sml_equip_rqst);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SML_EQUIP_APPROVE';
   p_old := TO_CHAR (:OLD.sml_equip_approve);
   p_new := TO_CHAR (:NEW.sml_equip_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LGE_EQUIP_DESCRIPT';
   p_old := TO_CHAR (:OLD.lge_equip_descript);
   p_new := TO_CHAR (:NEW.lge_equip_descript);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LGE_EQUIP_APPROVE';
   p_old := TO_CHAR (:OLD.lge_equip_approve);
   p_new := TO_CHAR (:NEW.lge_equip_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LGE_EQUIP_RQST';
   p_old := TO_CHAR (:OLD.lge_equip_rqst);
   p_new := TO_CHAR (:NEW.lge_equip_rqst);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DIET_NEED_DESCRIPT';
   p_old := TO_CHAR (:OLD.diet_need_descript);
   p_new := TO_CHAR (:NEW.diet_need_descript);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DISABLEMENT_CODE';
   p_old := TO_CHAR (:OLD.disablement_code);
   p_new := TO_CHAR (:NEW.disablement_code);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'END_DATE_ABROAD';
   p_old := :OLD.end_date_abroad;
   p_new := :NEW.end_date_abroad;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'ERASMUS';
   p_old := :OLD.erasmus;
   p_new := :NEW.erasmus;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DIET_NEED_REQ';
   p_old := TO_CHAR (:OLD.diet_need_req);
   p_new := TO_CHAR (:NEW.diet_need_req);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DIET_NEED_APPROVE';
   p_old := TO_CHAR (:OLD.diet_need_approve);
   p_new := TO_CHAR (:NEW.diet_need_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'NON_MED_REQ';
   p_old := TO_CHAR (:OLD.non_med_req);
   p_new := TO_CHAR (:NEW.non_med_req);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'NON_MED_APPROVE';
   p_old := TO_CHAR (:OLD.non_med_approve);
   p_new := TO_CHAR (:NEW.non_med_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PROVISIONAL_CASE';
   p_old := :OLD.provisional_case;
   p_new := :NEW.provisional_case;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PROVISIONAL_DATE';
   p_old := :OLD.provisional_date;
   p_new := :NEW.provisional_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'REPEAT_YEAR';
   p_old := :OLD.repeat_year;
   p_new := :NEW.repeat_year;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'REQ_DUP';
   p_old := :OLD.req_dup;
   p_new := :NEW.req_dup;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SESSION_CODE';
   p_old := :OLD.session_code;
   p_new := :NEW.session_code;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CRSE_YEAR_NO';
   p_old := :OLD.crse_year_no;
   p_new := :NEW.crse_year_no;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'INST_CODE';
   p_old := :OLD.inst_code;
   p_new := :NEW.inst_code;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CRSE_ID';
   p_old := :OLD.crse_id;
   p_new := :NEW.crse_id;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'UNCONDITIONAL';
   p_old := :OLD.unconditional;
   p_new := :NEW.unconditional;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SLC1_STATUS';
   p_old := :OLD.slc1_status;
   p_new := :NEW.slc1_status;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SLC2_STATUS';
   p_old := :OLD.slc2_status;
   p_new := :NEW.slc2_status;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LOAN_GIVEN';
   p_old := :OLD.loan_given;
   p_new := :NEW.loan_given;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LATEST_CRSE_IND';
   p_old := :OLD.latest_crse_ind;
   p_new := :NEW.latest_crse_ind;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'AUTO_CALC_DATE';
   p_old := :OLD.auto_calc_date;
   p_new := :NEW.auto_calc_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   -- RFC 112 addition
   --
   p_column_name := 'DSA_FEE_DESCRIPT';
   p_old := :OLD.dsa_fee_descript;
   p_new := :NEW.dsa_fee_descript;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DSA_FEE_RQST';
   p_old := :OLD.dsa_fee_rqst;
   p_new := :NEW.dsa_fee_rqst;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DSA_FEE_APPROVE';
   p_old := :OLD.dsa_fee_approve;
   p_new := :NEW.dsa_fee_approve;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   -- END OF RFC 112 addition
   --
   -- RFC 113b Janis 28/06/04
   --
   p_column_name := 'ATTEND_REQD';
   p_old := :OLD.attend_reqd;
   p_new := :NEW.attend_reqd;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   -- End rfc 113b
   --
   -- RFC 113c MT 05/07/04
   --
   p_column_name := 'ATTEND_CONFIRMED';
   p_old := :OLD.attend_confirmed;
   p_new := :NEW.attend_confirmed;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'HEI_DATE_ATTENDED';
   p_old := :OLD.hei_date_attended;
   p_new := :NEW.hei_date_attended;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'NON_ATT_ACTIONED';
   p_old := :OLD.non_att_actioned;
   p_new := :NEW.non_att_actioned;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'NON_ATT_ACTIONED_DATE';
   p_old := :OLD.non_att_actioned_date;
   p_new := :NEW.non_att_actioned_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'TRAV_SUBMITTED_DATE';
   p_old := :OLD.trav_submitted_date;
   p_new := :NEW.trav_submitted_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SAL_SENT_DATE';
   p_old := :OLD.sal_sent_date;
   p_new := :NEW.sal_sent_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SAL_DEST';
   p_old := :OLD.sal_dest;
   p_new := :NEW.sal_dest;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
--- RFC188
   p_column_name := 'VARIABLE_FEE_OVERRIDE_AMOUNT';
   p_old := :OLD.variable_fee_override_amount;
   p_new := :NEW.variable_fee_override_amount;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'FEE_LOAN_GIVEN';
   p_old := :OLD.fee_loan_given;
   p_new := :NEW.fee_loan_given;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'FEE_LOAN_ELIGIBILITY_ONLY';
   p_old := :OLD.fee_loan_eligibility_only;
   p_new := :NEW.fee_loan_eligibility_only;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'PGCE';
   p_old := :OLD.pgce;
   p_new := :NEW.pgce;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'SELF_FUNDING';
   p_old := :OLD.self_funding;
   p_new := :NEW.self_funding;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'INDEPENDENT';
   p_old := :OLD.independent;
   p_new := :NEW.independent;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'DUE_YSB_YSO_IND';
   p_old := :OLD.due_ysb_yso_ind;
   p_new := :NEW.due_ysb_yso_ind;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
--END OF RFC188
-- RFC204
   p_column_name := 'HOUSEHOLD_RESID_INCOME';
   p_old := :OLD.household_resid_income;
   p_new := :NEW.household_resid_income;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'BEN1_TOTAL_INCOME';
   p_old := :OLD.ben1_total_income;
   p_new := :NEW.ben1_total_income;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'BEN2_TOTAL_INCOME';
   p_old := :OLD.ben2_total_income;
   p_new := :NEW.ben2_total_income;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
-- RFC204

   --RFC 222
   p_column_name := 'SNB_SINGLE_RATE';
   p_old := :OLD.snb_single_rate;
   p_new := :NEW.snb_single_rate;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
--RFC 222
   p_column_name := 'NMSB_SESSION_CALC';
   p_old := :OLD.nmsb_session_calc;
   p_new := :NEW.nmsb_session_calc;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'START_DATE_ABROAD';
   p_old := TO_CHAR (:OLD.start_date_abroad, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.start_date_abroad, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'STUDY_ABROAD';
   p_old := :OLD.study_abroad;
   p_new := :NEW.study_abroad;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'UNPAID_SANDWICH';
   p_old := :OLD.unpaid_sandwich;
   p_new := :NEW.unpaid_sandwich;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PAID_SANDWICH';
   p_old := :OLD.paid_sandwich;
   p_new := :NEW.paid_sandwich;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_FEE';
   p_old := :OLD.calc_fee;
   p_new := :NEW.calc_fee;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_BURSARY';
   p_old := :OLD.calc_bursary;
   p_new := :NEW.calc_bursary;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_LOAN';
   p_old := :OLD.calc_loan;
   p_new := :NEW.calc_loan;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_DEP_GRANT';
   p_old := :OLD.calc_dep_grant;
   p_new := :NEW.calc_dep_grant;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_LPG';
   p_old := :OLD.calc_lpg;
   p_new := :NEW.calc_lpg;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_LPCG';
   p_old := :OLD.calc_lpcg;
   p_new := :NEW.calc_lpcg;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PAY_YSB';
   p_old := :OLD.pay_ysb;
   p_new := :NEW.pay_ysb;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PGCE_EDU_LEVEL';
   p_old := :OLD.pgce_edu_level;
   p_new := :NEW.pgce_edu_level;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PGCE_SUBJECT';
   p_old := :OLD.pgce_subject;
   p_new := :NEW.pgce_subject;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'FIRST_CALC_DATE';
   p_old := :OLD.first_calc_date;
   p_new := :NEW.first_calc_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PSAS_PT';
   p_old := :OLD.psas_pt;
   p_new := :NEW.psas_pt;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CRSE_SUSPEND';
   p_old := :OLD.crse_suspend;
   p_new := :NEW.crse_suspend;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
    --
/* Telephony Auditing PB Feb 2005*/
    --
   p_column_name := 'DATE_LAST_CALCULATED';
   p_old := :OLD.auto_calc_date;
   p_new := :NEW.auto_calc_date;

   IF NVL (:OLD.auto_calc_date, '01/JAN/1900') <>
                                      NVL (:NEW.auto_calc_date, '01/JAN/1900')
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'DATE_LAST_AWARD_LETTER_ISSUED';
   p_old := :OLD.sal_sent_date;
   p_new := :NEW.sal_sent_date;

   IF NVL (:OLD.sal_sent_date, '01/JAN/1900') <>
                                       NVL (:NEW.sal_sent_date, '01/JAN/1900')
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'SAL_DEST';
   p_old := :OLD.sal_dest;
   p_new := :NEW.sal_dest;

   IF NVL (:OLD.sal_dest, 'X') <> NVL (:NEW.sal_dest, 'X')
   THEN
      v_updated := 'Y';
   END IF;

   --
   IF v_updated = 'Y'
   THEN
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   END IF;
END stcy_iud;
SHOW ERRORS;

-- 
-- Non Foreign Key Constraints for Table STUD_CRSE_YEAR 
-- 

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT SCY_NON_ATT_ACTIONED
 CHECK (non_att_actioned in ('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT SCY_ATTEND_CONFIRMED
 CHECK (attend_confirmed in('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT SCY_HEI_PAY_RT
 CHECK (HEI_PAYMENT_ROUTE IN ('O','P','M','U','G',NULL)))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT SCY_INDEPENDENT
 CHECK (INDEPENDENT IN ('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_ATTEND_REQD
 CHECK (attend_reqd in('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_APPLICATION_STATUS
 CHECK (APPLICATION_STATUS IN('N','R' ,'C','W','T','A')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_BATCH_RECALC
 CHECK (BATCH_RECALC IN('N','Y','F','S')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_CASE_COMPLEX
 CHECK ( CASE_COMPLEX BETWEEN '0' and '4'))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_AWARD_LETTER_DATE
 CHECK (AWARD_LETTER_DATE IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_CORRES_DEST
 CHECK ( CORRES_DEST IN('H','T','I','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_AWARD
 CHECK ( AWARD IN('A','B','C','D','E','F')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_ARA_SENT
 CHECK ( ARA_SENT IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT SCY_PAL_DEST
 CHECK (pal_dest IN ('2','H','R','S','A','M')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_ERASMUS
 CHECK (ERASMUS IN ('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_DUE_YSB_YSO_IND
 CHECK (due_ysb_yso_ind in('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_DEARING
 CHECK (dearing IN('A','B','C','D','E','N','O','P','Q','F','G')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_FTRACK
 CHECK (fast_track in('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_OUTSCOT_RESULT
 CHECK ( OUTSCOT_RESULT IN('A','R')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_LATEST_CRSE_IND
 CHECK ( LATEST_CRSE_IND IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_OWNS_HOME
 CHECK ( OWNS_HOME IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_MAX_TRAV_AWARD
 CHECK ( MAX_TRAV_AWARD IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_INST_CHANGE
 CHECK ( INST_CHANGE IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_FORM_COMP
 CHECK ( FORM_COMP IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_OWN_HOME_RENT
 CHECK ( OWN_HOME_RENT IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_LOAN_ELIGIBILTY
 CHECK (LOAN_ELIGIBILITY_ONLY IN ('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_FEE_LOAN_ELIGIBILITY_ONLY
 CHECK (fee_loan_eligibility_only IN ('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_FEE_LOAN_GIVEN
 CHECK (fee_loan_given IN ('A','B','C','D','E','F')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_PROVISIONAL_CASE
 CHECK ( PROVISIONAL_CASE IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_SAL_SENT
 CHECK ( SAL_SENT IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_RESULT_PREV_SSS
 CHECK ( RESULT_PREV_SSS IN('A','R')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_PREV_SSS_APP
 CHECK ( PREV_SSS_APP IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_PARENT_CONTRIB_EXEMPT
 CHECK ( PARENT_CONTRIB_EXEMPT IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_PSAS_APPLIC_RESULT
 CHECK ( PSAS_APPLIC_RESULT IN('A','R')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_PAL_SENT
 CHECK ( PAL_SENT IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_SAL_DEST
 CHECK (sal_dest IN ('1','H','R','S','A','M')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_PAID_SANDWICH
 CHECK (PAID_SANDWICH IN ('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_PAY_YSB
 CHECK (pay_ysb in('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_REQ_DUP
 CHECK (REQ_DUP IN ('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_PGCE
 CHECK (pgce IN ('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_SUPP_PAYMENTS
 CHECK (supp_payments in('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_SSS_APP_OFFER
 CHECK ( SSS_APP_OFFER IN('S','M')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_TWO_HOME
 CHECK ( TWO_HOME IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_STUDY_ABROAD
 CHECK ( STUDY_ABROAD IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_TEL_SENT
 CHECK ( TEL_SENT IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_SSS_APP_RESULT
 CHECK ( SSS_APP_RESULT IN('A','R')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_TRANSFER_CERT
 CHECK ( TRANSFER_CERT IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_SNB_GRAD
 CHECK ( SNB_GRAD IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_SLC1_STATUS
 CHECK (SLC1_STATUS IN ('R','E','S','C',NULL)))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_SLC2_STATUS
 CHECK (SLC2_STATUS IN ('R','E','S','C',NULL)))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_SELF_FUNDING
 CHECK (self_funding IN ('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_SNB_RATE
 CHECK (snb_rate in('H','L','S')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_Z_REF_STATUS
 CHECK (z_ref_status in ('N','R','I')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_UNCONDITIONAL
 CHECK ( UNCONDITIONAL IN('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_UNPAID_SANDWICH
 CHECK (UNPAID_SANDWICH IN ('Y','N')))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT STCY_SUSPEND
 CHECK (CRSE_SUSPEND IN('Y','N')))
/

ALTER TABLE SGAS.stud_crse_year ADD (
  CONSTRAINT STCY_NON_ERA_EX
 CHECK (non_erasmus_exchange in ('Y','N')));

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT P_STCY
 PRIMARY KEY
 (STUD_CRSE_YEAR_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          200K
                NEXT             100K
                MINEXTENTS       1
                MAXEXTENTS       99
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ))
/

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT F1_STCY 
 FOREIGN KEY (STUD_SESSION_ID) 
 REFERENCES SGAS.STUD_SESSION (STUD_SESSION_ID));

ALTER TABLE SGAS.STUD_CRSE_YEAR ADD (
  CONSTRAINT F2_STCY 
 FOREIGN KEY (STUD_REF_NO) 
 REFERENCES SGAS.STUD (STUD_REF_NO));

--
-- STUD_CRSE_YEAR  (Materialized View Log)
--
DROP SNAPSHOT LOG ON STUD_CRSE_YEAR
/
--
-- STUD_CRSE_YEAR  (Materialized View Log) 
--
CREATE MATERIALIZED VIEW LOG ON STUD_CRSE_YEAR
TABLESPACE USERS
PCTUSED    0
PCTFREE    60
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOPARALLEL
WITH ROWID, SEQUENCE
INCLUDING NEW VALUES
/

DROP SEQUENCE SGAS.STCY_STUD_CRSE_YEAR_ID_SEQ;

CREATE SEQUENCE SGAS.STCY_STUD_CRSE_YEAR_ID_SEQ
  START WITH 3000000
  MAXVALUE 999999999999
  MINVALUE 3000000
  NOCYCLE
  NOCACHE
  NOORDER;


DROP PUBLIC SYNONYM STCY_STUD_CRSE_YEAR_ID_SEQ;

CREATE PUBLIC SYNONYM STCY_STUD_CRSE_YEAR_ID_SEQ FOR SGAS.STCY_STUD_CRSE_YEAR_ID_SEQ;


GRANT SELECT ON  SGAS.STCY_STUD_CRSE_YEAR_ID_SEQ TO PUBLIC;