-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- Modification History
-- Date        Author           Ref    Desc
-- 15.02.08    Steve Durkin     001    New columns.
-- 10.03.09    A.Bowman (SAAS)  002    Added new column stud income
-- 22.06.09    A.Bowman (SAAS)  003    Added audit triggers
-- 27.08.09    A.Bowman (SAAS)  004    Added new auditable column date_applic_received to trigger SGAS.sts_iud
--                                     to meet History requirements
-- 30.09.09    A.Bowman (SAAS)  005    Added new columns as part of CR's 
-- 15.10.09    A.Bowman (SAAS)  006    Added materialized view log script
-- 18.10.09    R.Hunter (SGAS)  007    Grant Access for ILA500 Duplicates View
-- 10.12.09    A.Bowman (SAAS)  008    Added new column fee_loan_charged
-- 28.01.10    A.Bowman (SAAS)  009    Amended audit triggers
-- 15.03.10    A.Bowman (SAAS)  010    Added new column bursary_deduction
-- 29.04.10    A.Bowman (SAAS)  011    Added foreign key references
-- 03.06.10    A.Bowman (SAAS)  012    Added new column SESSION_SUSPEND
-- 26.08.10    A.Bowman (SAAS)  013    Added default of 0 to columns net_income, trust_income, pension_income, working_tax_credit  
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STUD_SESSION.sql $
-- $Author: $
-- $Date: 2011-01-27 14:11:48 +0000 (Thu, 27 Jan 2011) $
-- $Revision: 6356 $


ALTER TABLE SGAS.STUD_SESSION
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.STUD_SESSION CASCADE CONSTRAINTS PURGE
/

--
-- STUD_SESSION  (Table) 
--
CREATE TABLE SGAS.STUD_SESSION
(
  STUD_SESSION_ID            NUMBER(9) CONSTRAINT NN_STS_STUD_SESSION_ID NOT NULL,
  STUD_REF_NO                NUMBER(10) CONSTRAINT NN_STS_STUD_REF_NO NOT NULL,
  SESSION_CODE               NUMBER(4) CONSTRAINT NN_STS_SESSION_CODE NOT NULL,
  LIFE_INS_DOC               VARCHAR2(1 BYTE)   DEFAULT 'N' CONSTRAINT NN_STS_LIFE_INS_DOC NOT NULL,
  MARRIAGE_CERT              VARCHAR2(1 BYTE)   DEFAULT 'N' CONSTRAINT NN_STS_MARRIAGE_CERT NOT NULL,
  PENSION_DOC                VARCHAR2(1 BYTE)   DEFAULT 'N' CONSTRAINT NN_STS_PENSION_DOC NOT NULL,
  MORTGAGE_INT               VARCHAR2(1 BYTE)   DEFAULT 'N' CONSTRAINT NN_STS_MORTGAGE_INT NOT NULL,
  JA_CASE                    VARCHAR2(1 BYTE)   DEFAULT 'N' CONSTRAINT NN_STS_JA_CASE NOT NULL,
  FORENAMES                  VARCHAR2(25 BYTE) CONSTRAINT NN_STS_FORENAMES NOT NULL,
  SURNAME                    VARCHAR2(25 BYTE) CONSTRAINT NN_STS_SURNAME NOT NULL,
  DOB                        DATE CONSTRAINT NN_STS_DOB NOT NULL,
  SEX                        VARCHAR2(1 BYTE) CONSTRAINT NN_STS_SEX NOT NULL,
  RESIDENCE_QUERY            VARCHAR2(1 BYTE)   DEFAULT 'N' CONSTRAINT NN_STS_RESIDENCE_QUERY NOT NULL,
  EMP_LOGIN_NAME             VARCHAR2(15 BYTE),
  FIRST_NAME                 VARCHAR2(15 BYTE),
  LAST_NAME                  VARCHAR2(15 BYTE),
  JA_CASE_ID                 NUMBER(6),
  JA_STUD_TYPE               VARCHAR2(1 BYTE),
  BEN1_ID                    NUMBER(9),
  BEN2_ID                    NUMBER(9),
  BEN1_REL_ID                NUMBER(4),
  BEN2_REL_ID                NUMBER(4),
  NET_INCOME                 NUMBER(9,2)        DEFAULT 0,
  TRUST_INCOME               NUMBER(9,2)        DEFAULT 0,
  PENSION_INCOME             NUMBER(9,2)        DEFAULT 0,
  EMPLOYMENT_DESCRIPT        VARCHAR2(100 BYTE),
  BEN1_START_DATE            DATE,
  BEN1_END_DATE              DATE,
  BEN2_START_DATE            DATE,
  BEN2_END_DATE              DATE,
  UNUSED_JA_CONT             NUMBER(9,2)        DEFAULT 0,
  DEDUCTS                    NUMBER(9,2),
  LOAN_DECLARATION_DATE      DATE,
  DATE_APPLIC_RECEIVED       DATE,
  LOAN_REQUEST               NUMBER(7,2),
  MAX_LOAN_REQUESTED         VARCHAR2(1 BYTE),
  REQ_SENT_DATE              DATE,
  DOC_REQ_ISSUE              NUMBER(1),
  PT_LOAN_CHECK              VARCHAR2(1 BYTE),
  PT_LOAN_CLAIMED            VARCHAR2(1 BYTE),
  SMG_ENTITLEMENT            NUMBER(9,2),
  YSB_ENTITLEMENT            NUMBER(9,2),
  YSO_ENTITLEMENT            NUMBER(9,2),
  MAX_LPCG_PAID              VARCHAR2(1 BYTE),
  LPCG_PAID_AMOUNT           NUMBER(9,2),
  GE_LIABILITY               VARCHAR2(1 BYTE),
  SHORT_APP_SENT_DATE        DATE,
  SHORT_APP_REC_DATE         DATE,
  REGISTERED_FOR_DSA         VARCHAR2(1 BYTE),
  DOCUMENT_RECEIPT_DATE      DATE,
  FEE_LOAN_REQUEST_AMOUNT    NUMBER(7,2),
  MAX_FEE_LOAN_REQUESTED     VARCHAR2(1 BYTE),
  FEE_LOAN_DECLARATION_DATE  DATE,
  -- 008
  FEE_LOAN_CHARGED           NUMBER(7,2),
  SOSB_ENTITLEMENT           NUMBER(9,2),
  STUD_HEI_BURSARY_CONSENT   VARCHAR2(1 BYTE),
  SLC1_FL_SENT               VARCHAR2(1 BYTE),
  SLC1_FL_SENT_DATE          DATE,
  REASON_NO_NINO             NUMBER(4),
  -- 001
  CHILD_CARE_NO              VARCHAR2(10),
  CHILD_CARE_NAME            VARCHAR2(60),
  TOTAL_HOUSE_INCOME         NUMBER(9,2),
  -- 002
  STUD_INCOME                VARCHAR2(1 BYTE),
  -- 005
  WORKING_TAX_CREDIT         NUMBER(9,2)          DEFAULT 0,
  EMPLOYMENT_SUPPORT_ALLOWANCE VARCHAR2(1 BYTE),
  INCAPACITY_BENEFIT         VARCHAR2(1 BYTE),
  INCOME_SUPPORT             VARCHAR2(1 BYTE),
  INVALIDITY_BENEFIT         VARCHAR2(1 BYTE),
  JOBSEEKERS_ALLOWANCE       VARCHAR2(1 BYTE),
  MAINTENANCE_PAYMENT        VARCHAR2(1 BYTE),
  SDS_DATA_SHARE             VARCHAR2(1 BYTE),
  --- 010
  BURSARY_DEDUCTION          NUMBER(9,2)        DEFAULT 0,
  SESSION_SUSPEND            VARCHAR2(1) DEFAULT 'N',
  LAST_UPDATED_BY            VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_STS_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON            DATE DEFAULT Sysdate CONSTRAINT NN_STS_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
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
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON COLUMN SGAS.STUD_SESSION.STUD_HEI_BURSARY_CONSENT IS 'Indicates that the student has given permission to share HEI Bursary details'
/
-- 001
COMMENT ON COLUMN SGAS.STUD_SESSION.CHILD_CARE_NO       IS 'Registration number of childcare provider'
/
COMMENT ON COLUMN SGAS.STUD_SESSION.CHILD_CARE_NAME     IS 'Name of childcare provider'
/
COMMENT ON COLUMN SGAS.STUD_SESSION.TOTAL_HOUSE_INCOME  IS 'Total household income (combined benefactor income for student)'
/

--
-- S5_STS  (Index) 
--
CREATE INDEX S5_STS ON SGAS.STUD_SESSION
(SLC1_FL_SENT)
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
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- U1_STS  (Index) 
--
CREATE UNIQUE INDEX U1_STS ON SGAS.STUD_SESSION
(STUD_REF_NO, SESSION_CODE)
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
-- S3_STS  (Index) 
--
CREATE INDEX S3_STS ON SGAS.STUD_SESSION
(EMP_LOGIN_NAME)
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
-- S1_STS  (Index) 
--
CREATE INDEX S1_STS ON SGAS.STUD_SESSION
(JA_CASE_ID)
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
-- S2_STS  (Index) 
--
CREATE INDEX S2_STS ON SGAS.STUD_SESSION
(BEN1_ID)
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
-- P_STS  (Index) 
--
CREATE UNIQUE INDEX P_STS ON SGAS.STUD_SESSION
(STUD_SESSION_ID)
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

CREATE OR REPLACE TRIGGER SGAS.sts_iud
   AFTER INSERT OR DELETE OR UPDATE OF ben1_id,
                                       ben2_id,
                                       emp_login_name,
                                       ja_case,
                                       loan_declaration_date,
                                       loan_request,
                                       max_loan_requested,
                                       net_income,
                                       pension_income,
                                       session_code,
                                       trust_income,
                                       ysb_entitlement,
                                       fee_loan_request_amount,
                                       max_fee_loan_requested,
                                       fee_loan_declaration_date,
                                       stud_hei_bursary_consent,
                                       reason_no_nino,
                                       slc1_fl_sent,
                                       slc1_fl_sent_date,
                                       lpcg_paid_amount,
                                       max_lpcg_paid,
                                       smg_entitlement,
                                       child_care_no,
                                       child_care_name,
                                       ben1_rel_id,
                                       ben2_rel_id,
                                       total_house_income,
                                       stud_income,
                                       date_applic_received,
                                       fee_loan_charged,
                                       session_suspend,
                                       last_updated_by
   ON SGAS.STUD_SESSION    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   p_aud_date       DATE                                 := SYSDATE;
   p_column_name    stud_session_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_session_aud.table_pkey1%TYPE
                                            := TO_CHAR (:OLD.stud_session_id);
   p_table_pkey2    stud_session_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_session_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_session_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_session_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_session_aud.OLD%TYPE            := NULL;
   p_new            stud_session_aud.NEW%TYPE            := NULL;
   p_action         stud_session_aud.action%TYPE         := NULL;
   p_username       stud_session_aud.username%TYPE       := :NEW.last_updated_by;
   p_stud_ref_no    stud_session_aud.stud_ref_no%TYPE    := :OLD.stud_ref_no;
   p_inst_code      stud_session_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_session_aud.session_code%TYPE   := :NEW.session_code;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_session_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   /* Removed nvl as Oracle 9i doesn't cope */
   --IF (NVL(:OLD.SESSION_CODE,' ')  <> NVL(:NEW.SESSION_CODE,' ')) THEN
   /*IF (:OLD.SESSION_CODE  <> :NEW.SESSION_CODE) THEN
       M202.STUD_SESSION_REP(:OLD.STUD_SESSION_ID,
                   :NEW.SESSION_CODE);*/
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_session_code := :OLD.session_code;
      p_stud_ref_no := :OLD.stud_ref_no;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'BEN1_ID';
   p_old := TO_CHAR (:OLD.ben1_id);
   p_new := TO_CHAR (:NEW.ben1_id);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'BEN2_ID';
   p_old := TO_CHAR (:OLD.ben2_id);
   p_new := TO_CHAR (:NEW.ben2_id);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'EMP_LOGIN_NAME';
   p_old := :OLD.emp_login_name;
   p_new := :NEW.emp_login_name;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'JA_CASE';
   p_old := :OLD.ja_case;
   p_new := :NEW.ja_case;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'LOAN_DECLARATION_DATE';
   p_old := :OLD.loan_declaration_date;
   p_new := :NEW.loan_declaration_date;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'LOAN_REQUEST';
   p_old := TO_CHAR (:OLD.loan_request);
   p_new := TO_CHAR (:NEW.loan_request);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'MAX_LOAN_REQUESTED';
   p_old := :OLD.max_loan_requested;
   p_new := :NEW.max_loan_requested;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'NET_INCOME';
   p_old := TO_CHAR (:OLD.net_income);
   p_new := TO_CHAR (:NEW.net_income);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'PENSION_INCOME';
   p_old := TO_CHAR (:OLD.pension_income);
   p_new := TO_CHAR (:NEW.pension_income);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'TRUST_INCOME';
   p_old := TO_CHAR (:OLD.trust_income);
   p_new := TO_CHAR (:NEW.trust_income);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'YSB_ENTITLEMENT';
   p_old := :OLD.ysb_entitlement;
   p_new := :NEW.ysb_entitlement;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'FEE_LOAN_REQUEST_AMOUNT';
   p_old := :OLD.fee_loan_request_amount;
   p_new := :NEW.fee_loan_request_amount;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'MAX_FEE_LOAN_REQUESTED';
   p_old := :OLD.max_fee_loan_requested;
   p_new := :NEW.max_fee_loan_requested;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'FEE_LOAN_DECLARATION_DATE';
   p_old := :OLD.fee_loan_declaration_date;
   p_new := :NEW.fee_loan_declaration_date;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'FEE_LOAN_CHARGED';
   p_old := :OLD.fee_loan_charged;
   p_new := :NEW.fee_loan_charged;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'STUD_HEI_BURSARY_CONSENT';
   p_old := :OLD.stud_hei_bursary_consent;
   p_new := :NEW.stud_hei_bursary_consent;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'REASON_NO_NINO';
   p_old := TO_CHAR (:OLD.reason_no_nino);
   p_new := TO_CHAR (:NEW.reason_no_nino);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'SLC1_FL_SENT';
   p_old := TO_CHAR (:OLD.slc1_fl_sent);
   p_new := TO_CHAR (:NEW.slc1_fl_sent);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'SLC1_FL_SENT_DATE';
   p_old := TO_CHAR (:OLD.slc1_fl_sent_date);
   p_new := TO_CHAR (:NEW.slc1_fl_sent_date);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'LPCG_PAID_AMOUNT';
   p_old := :OLD.lpcg_paid_amount;
   p_new := :NEW.lpcg_paid_amount;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'MAX_LPCG_PAID';
   p_old := :OLD.max_lpcg_paid;
   p_new := :NEW.max_lpcg_paid;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'SMG_ENTITLEMENT';
   p_old := :OLD.smg_entitlement;
   p_new := :NEW.smg_entitlement;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'CHILD_CARE_NO';
   p_old := :OLD.child_care_no;
   p_new := :NEW.child_care_no;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'CHILD_CARE_NAME';
   p_old := :OLD.child_care_name;
   p_new := :NEW.child_care_name;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'BEN1_REL_ID';
   p_old := :OLD.ben1_rel_id;
   p_new := :NEW.ben1_rel_id;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'BEN2_REL_ID';
   p_old := :OLD.ben2_rel_id;
   p_new := :NEW.ben2_rel_id;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'TOTAL_HOUSE_INCOME';
   p_old := :OLD.total_house_income;
   p_new := :NEW.total_house_income;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'STUD_INCOME';
   p_old := :OLD.stud_income;
   p_new := :NEW.stud_income;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'DATE_APPLIC_RECEIVED';
   p_old := :OLD.date_applic_received;
   p_new := :NEW.date_applic_received;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'SESSION_SUSPEND';
   p_old := :OLD.session_suspend;
   p_new := :NEW.session_suspend;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
END sts_iud;
SHOW ERRORS;

-- 
-- Non Foreign Key Constraints for Table STUD_SESSION 
-- 
ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT CHECK_REL2
 CHECK ((ben2_id is not null and ben2_rel_id is not null) or                                 (ben2_id is null and ben2_rel_id is null)))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT CHECK_REL1
 CHECK ((ben1_id is not null and ben1_rel_id is not null) or                                 (ben1_id is null and ben1_rel_id is null)))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT SS_PT_LOAN_CLAIMED
 CHECK (PT_LOAN_CLAIMED IN ('Y','N')))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT SS_PT_LOAN_CHECK
 CHECK (PT_LOAN_CHECK IN ('Y','N')))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT STS_JA_CASE
 CHECK ( JA_CASE IN('Y','N')))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT STS_JA_STUD_TYPE
 CHECK ( JA_STUD_TYPE IN('P','C','S')))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT STS_LIFE_INS_DOC
 CHECK ( LIFE_INS_DOC IN('Y','N')))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT STS_MARRIAGE_CERT
 CHECK ( MARRIAGE_CERT IN('Y','N')))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT STS_MAX_LPCG_PAID
 CHECK (max_lpcg_paid in('Y','N')))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT STS_MAX_FEE_LOAN_REQUESTED
 CHECK (max_fee_loan_requested IN ('Y','N')))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT STS_MORTGAGE_INT
 CHECK ( MORTGAGE_INT IN('Y','N')))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT STS_RESIDENCE_QUERY
 CHECK ( RESIDENCE_QUERY IN('Y','N')))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT STS_PENSION_DOC
 CHECK ( PENSION_DOC IN('Y','N')))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT ST_GE
 CHECK (ge_liability in ('Y','N')))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT STS_SUSPEND
 CHECK (session_suspend in ('Y','N')))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT STS_SLC1_FL_SENT
 CHECK (slc1_fl_sent in ('Y', 'N', 'E')))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT P_STS
 PRIMARY KEY
 (STUD_SESSION_ID)
    USING INDEX 
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
               ))
/

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT F1_STS 
 FOREIGN KEY (STUD_REF_NO) 
 REFERENCES SGAS.STUD (STUD_REF_NO));

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT F2_STS 
 FOREIGN KEY (JA_CASE_ID) 
 REFERENCES SGAS.JA_CASE (JA_CASE_ID));

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT F3_STS 
 FOREIGN KEY (BEN1_ID) 
 REFERENCES SGAS.BENEFACTOR (BEN_ID));

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT F4_STS 
 FOREIGN KEY (BEN2_ID) 
 REFERENCES SGAS.BENEFACTOR (BEN_ID));

--
-- STUD_SESSION  (Materialized View Log)
--
DROP SNAPSHOT LOG ON STUD_SESSION
/
--
-- STUD_SESSION  (Materialized View Log) 
--
CREATE MATERIALIZED VIEW LOG ON STUD_SESSION
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


DROP SEQUENCE SGAS.STS_STUD_SESSION_ID_SEQ;

CREATE SEQUENCE SGAS.STS_STUD_SESSION_ID_SEQ
  START WITH 3000000
  MAXVALUE 999999999999
  MINVALUE 3000000
  NOCYCLE
  NOCACHE
  NOORDER;


DROP PUBLIC SYNONYM STS_STUD_SESSION_ID_SEQ;

CREATE PUBLIC SYNONYM STS_STUD_SESSION_ID_SEQ FOR SGAS.STS_STUD_SESSION_ID_SEQ;


GRANT SELECT ON  SGAS.STS_STUD_SESSION_ID_SEQ TO PUBLIC;

GRANT SELECT ON SGAS.STUD_SESSION TO ILA500;
