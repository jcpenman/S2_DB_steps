-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- Modification History
-- Date          Author       Ref   Desc
-- 09.01.2008    S.Durkin     001   Add synonyms and grants.
-- 14.01.2008    S.Durkin     002   Add COMMENCE_SESSION column.
-- 15.02.08      S.DUrkin     003   New columns to support maintenance of bank accs.
-- 18.02.08      A.Bowman     004   Add Audit Columns
-- 29.04.08      S.Durkin     005   New column PROBLEM_CASE. See column comments.
-- 02.07.2008    P.Hughes     006   Check Contstraint Marital status added 'E' status for Partner
-- 03.06.2009    A.Bowman     007   Added trigger to create slc ref no before insert on stud
-- 15.06.2009    A.Bowman     008   Added audit triggers
-- 29.09.2009    A.Bowman     009   Amended trigger ST_AU to remove marital_status and marriage_date
-- 30.09.2009    A.Bowman     010   Added new column residence_type_id as result of CR
-- 15.10.2009    A.Bowman     011   Added materialized view log script
-- 28.01.2010    A.Bowman     012   Amended audit triggers
-- 24.03.2010    A.Bowman     013   Amended St_AU trigger
-- 15.04.2010    A.Bowman     014   Amended slc ref no trigger to ignore students with existing slc ref no
-- 29.04.2010    A.Bowman     015   Added foreign key references
-- 18.05.2010    A.Bowman     016   Added new column QA_COUNT
-- 03.06.2010    A.Bowman     017   Added new column STUD_SUSPEND
-- 09.09.2010    A.Bowman     018   Removed marital_status etc from st_aiu trigger
-- 06.10.2010    A.Bowman     019   Amended st_aiu trigger to fix errors
-- 22.10.2010    A.Bowman     020   Added default of 'N' to suspend_payment
-- 21.02.2011    A.Bowman     021   Added new column RESIDENCE_STATUS
-- 
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STUD.sql $
-- $Author: $
-- $Date: 2011-02-21 14:24:49 +0000 (Mon, 21 Feb 2011) $
-- $Revision: 6494 $

ALTER TABLE SGAS.STUD
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.STUD CASCADE CONSTRAINTS PURGE
/

--
-- STUD  (Table) 
--
CREATE TABLE SGAS.STUD
(
  STUD_REF_NO                 NUMBER(10) CONSTRAINT NN_ST_STUD_REF_NO NOT NULL,
  ABROAD                      VARCHAR2(1 BYTE)      NULL,
  DOB                         DATE CONSTRAINT NN_ST_DOB NOT NULL,
  DOB_CHANGED                 VARCHAR2(1 BYTE)      NULL,
  TITLE                       VARCHAR2(8 BYTE) CONSTRAINT NN_ST_TITLE NOT NULL,
  INITIALS                    VARCHAR2(5 BYTE)      NULL,
  FORENAMES                   VARCHAR2(25 BYTE) CONSTRAINT NN_ST_FORENAMES NOT NULL,
  SURNAME                     VARCHAR2(25 BYTE) CONSTRAINT NN_ST_SURNAME NOT NULL,
  SEX                         VARCHAR2(1 BYTE)  DEFAULT 'M' CONSTRAINT NN_ST_SEX NOT NULL,
  RESIDENCE_ID                NUMBER(4)         DEFAULT 501 CONSTRAINT NN_ST_RESIDENCE_ID NOT NULL,
  BIRTH_COUNTRY_CODE          NUMBER(3)             NULL,
  BC_CHANGED                  VARCHAR2(1 BYTE)      NULL,
  RESIDENCE_COUNTRY_CODE      NUMBER(3)             NULL,
  RC_CHANGED                  VARCHAR2(1 BYTE)      NULL,
  NATION_COUNTRY_CODE         NUMBER(3)         DEFAULT 299                       NULL,
  NOMINEE                     VARCHAR2(1 BYTE)  DEFAULT 'N' CONSTRAINT NN_ST_NOMINEE NOT NULL,
  PAYMENT_METHOD              VARCHAR2(1 BYTE)  DEFAULT 'C' CONSTRAINT NN_ST_PAYMENT_METHOD NOT NULL,
  OVERPAY_STAT                VARCHAR2(2 BYTE)  DEFAULT 'OK' CONSTRAINT NN_ST_OVERPAY_STAT NOT NULL,
  FRAUD                       NUMBER(2)         DEFAULT 0 CONSTRAINT NN_ST_FRAUD NOT NULL,
  OVERPAYMENT                 NUMBER(9,2)           NULL,
  DEF_OVERPAYMENT             NUMBER(9,2)           NULL,
  SNB_OVERPAYMENT             NUMBER(9,2)           NULL,
  SNB_DEF_OVERPAYMENT         NUMBER(9,2)           NULL,
  CAND_ENDOW_IND              VARCHAR2(1 BYTE)      NULL,
  DISABLED                    VARCHAR2(1 BYTE)      NULL,
  SCOTTISH_CAND               VARCHAR2(10 BYTE)     NULL,
  NI_NO                       VARCHAR2(9 BYTE)      NULL,
  DEBT_ID                     VARCHAR2(10 BYTE)     NULL,
  WRITE_OFF_DATE              DATE                  NULL,
  WRITE_OFF_IND               VARCHAR2(1 BYTE)      NULL,
  UCAS_NO                     VARCHAR2(9 BYTE)      NULL,
  MARITAL_STATUS              VARCHAR2(1 BYTE)  DEFAULT 'S'                       NULL,
  MARRIAGE_DATE               DATE                  NULL,
  BANK_NAME                   VARCHAR2(25 BYTE)     NULL,
  ACCOUNT_NO                  VARCHAR2(10 BYTE)     NULL,
  SORT_CODE                   VARCHAR2(6 BYTE)      NULL,
  BANK_HOUSE_NO_NAME          VARCHAR2(32 BYTE)     NULL,
  BANK_ADDR_L1                VARCHAR2(65 BYTE)     NULL,
  BANK_ADDR_L2                VARCHAR2(65 BYTE)     NULL,
  BANK_ADDR_L3                VARCHAR2(32 BYTE)     NULL,
  BANK_ADDR_L4                VARCHAR2(32 BYTE)     NULL,
  BANK_POST_CODE              VARCHAR2(8 BYTE)      NULL,
  NOM_METHOD                  VARCHAR2(1 BYTE)  DEFAULT 'C'                       NULL,
  NOM_BANK_ACCOUNT            VARCHAR2(10 BYTE)     NULL,
  NOM_BANK_SORT_CODE          VARCHAR2(6 BYTE)      NULL,
  NOM_NAME                    VARCHAR2(25 BYTE)     NULL,
  NOM_BANK_NAME               VARCHAR2(25 BYTE)     NULL,
  NOM_BANK_HOUSE              VARCHAR2(32 BYTE)     NULL,
  NOM_BANK_ADDR_L1            VARCHAR2(65 BYTE)     NULL,
  NOM_BANK_ADDR_L2            VARCHAR2(65 BYTE)     NULL,
  NOM_BANK_ADDR_L3            VARCHAR2(32 BYTE)     NULL,
  NOM_BANK_ADDR_L4            VARCHAR2(32 BYTE)     NULL,
  NOM_BANK_POST_CODE          VARCHAR2(8 BYTE)      NULL,
  MAIDEN_NAME                 VARCHAR2(25 BYTE)     NULL,
  DSA_EQMT                    NUMBER(9,2)           NULL,
  SEARCH_DATE                 DATE                  NULL,
  SEARCH_RESULT               NUMBER(4)             NULL,
  RES_PLACE_ID                NUMBER(4)             NULL,
  BIRTH_PLACE_ID              NUMBER(4)             NULL,
  SCHOOL_ID                   NUMBER(4)             NULL,
  STUD_OCC_ID                 NUMBER(4)             NULL,
  PARENT_OCC_ID               NUMBER(4)             NULL,
  DISABILITY_ID               NUMBER(4)             NULL,
  RELIGION_ID                 NUMBER(4)             NULL,
  PREV_SUBJECT_ID             NUMBER(4)             NULL,
  PROP_SUBJECT_ID             NUMBER(4)             NULL,
  PREV_INST_CODE              VARCHAR2(5 BYTE)      NULL,
  PROP_INST_CODE              VARCHAR2(5 BYTE)      NULL,
  STUDY_TYPE_ID               NUMBER(4)             NULL,
  STUDY_LEVEL_ID              NUMBER(4)             NULL,
  QUAL_ID                     NUMBER(4)             NULL,
  MISC_ID                     NUMBER(4)             NULL,
  SUSPEND_PAYMENT             VARCHAR2(1 BYTE)      DEFAULT 'N'                       NULL,
  ARC_RESTORE_DATE            DATE                  NULL,
  ARC_LAST_CRSE               VARCHAR2(50 BYTE)     NULL,
  ARC_LAST_INST               VARCHAR2(50 BYTE)     NULL,
  ARC_LAST_SESSION            NUMBER(4)             NULL,
  ARC_ID                      NUMBER(9)             NULL,
  STUD_LABEL                  VARCHAR2(1 BYTE)      NULL,
  EMP_ID                      VARCHAR2(15 BYTE)     NULL,
  COLOUR_LABEL                VARCHAR2(1 BYTE)      NULL,
  BIRTH_FORENAMES             VARCHAR2(30 BYTE)     NULL,
  BIRTH_SURNAME               VARCHAR2(30 BYTE)     NULL,
  DISTRICT_BIRTH_CERT_ISSUED  VARCHAR2(25 BYTE)     NULL,
  BIRTH_CERT_FLAG             VARCHAR2(1 BYTE)      NULL,
  OFFER_FLAG                  VARCHAR2(1 BYTE)      NULL,
  PREV_LOAN_ACC_NO            VARCHAR2(11 BYTE)     NULL,
  ADDR_CORR_FLAG              VARCHAR2(1 BYTE)  DEFAULT 'H'                       NULL,
  BUILD_SOC_NO                VARCHAR2(18 BYTE)     NULL,
  BANKRUPT_FLAG               VARCHAR2(1 BYTE)  DEFAULT 'N'                       NULL,
  TRAVEL_METHOD               VARCHAR2(1 BYTE)      NULL,
  WEB_USER_ID                 VARCHAR2(25 BYTE)     NULL,
  BANK_VALIDATE               VARCHAR2(1 BYTE)      NULL,
  BANK_DETL_REQ               DATE                  NULL,
  SYS_GE_LIABILITY            VARCHAR2(1 BYTE)      NULL,
  CW_GE_LIABILITY             VARCHAR2(1 BYTE)      NULL,
  EDM_BATCH_ID                NUMBER(16)            NULL,
  WORK_ITEM_IN_USE            VARCHAR2(1 BYTE)      NULL,
  EDM_APP_BATCH_ID            NUMBER(16)            NULL,
  MOBILE_TEL_NO               VARCHAR2(14 BYTE)     NULL,
  EMAIL_ADDR                  VARCHAR2(80 BYTE)     NULL,
  -- 002 - Add commence_session column (See comment below)
  COMMENCE_SESSION            NUMBER(4)             NULL,
  -- 003 - New columns to support maintenance of bank details
  ACC_LAST_UPDATED            DATE                  NULL,
  VALID_DUPLICATE_ACC         VARCHAR2(1) DEFAULT 'N' CONSTRAINT NN_ST_DUP_ACC NOT NULL,
  DUP_BANK_REASON             VARCHAR2(100)         NULL,
  -- 005
  PROBLEM_CASE                VARCHAR2(1) DEFAULT 'N' NOT NULL,
  RESIDENCE_TYPE_ID           NUMBER(10),
  QA_COUNT                    NUMBER(4) DEFAULT 0, 
  STUD_SUSPEND                VARCHAR2(1) DEFAULT 'N',
  RESIDENCE_STATUS            VARCHAR2(1), 
  -- 004 - Audit Columns
  LAST_UPDATED_BY             VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_ST_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON             DATE DEFAULT Sysdate CONSTRAINT NN_ST_LAST_UPDATED_ON NOT NULL
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

--
-- Table comments
--
-- 002
COMMENT ON COLUMN SGAS.STUD.COMMENCE_SESSION     IS 'Year student began most recent period of study. Derived from previous years data'
/
-- 003
COMMENT ON COLUMN SGAS.STUD.ACC_LAST_UPDATED     IS 'Date of the last change to the bank details. Set to Sysdate() on update or insert of bank details.'
/
COMMENT ON COLUMN SGAS.STUD.VALID_DUPLICATE_ACC  IS 'Defaulting to "N" this field indicates if duplicate bank details found in the STUD table are valid. A reason is mandatory if the duplicates are valid.'
/
COMMENT ON COLUMN SGAS.STUD.DUP_BANK_REASON      IS 'Free text description of why this students bank details are duplicated in the STUD table, e.g.  - E.G. husband and wife both students - joint account.'
/
-- 005
COMMENT ON COLUMN SGAS.STUD.PROBLEM_CASE         IS 'Indicator for use on UI to indicate any cases that may have presented problems. Notes should be added to stud_notes though this is not enforced.'
/

--
-- SA_ST  (Index) 
--
CREATE INDEX SA_ST ON SGAS.STUD
(STUD_OCC_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             200K
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
-- S1_ST  (Index) 
--
CREATE INDEX S1_ST ON SGAS.STUD
(DOB)
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
-- U3_ST  (Index) 
--
CREATE UNIQUE INDEX U3_ST ON SGAS.STUD
(SCOTTISH_CAND)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             512K
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
-- SK_ST  (Index) 
--
CREATE INDEX SK_ST ON SGAS.STUD
(QUAL_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             200K
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
-- BATCH_ID  (Index) 
--
CREATE INDEX BATCH_ID ON SGAS.STUD
(EDM_BATCH_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          502K
            NEXT             502K
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
-- APP_BATCH_ID  (Index) 
--
CREATE INDEX APP_BATCH_ID ON SGAS.STUD
(EDM_APP_BATCH_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          502K
            NEXT             502K
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
-- S9_ST  (Index) 
--
CREATE INDEX S9_ST ON SGAS.STUD
(SCHOOL_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             200K
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
-- SD_ST  (Index) 
--
CREATE INDEX SD_ST ON SGAS.STUD
(RELIGION_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             200K
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
-- SE_ST  (Index) 
--
CREATE INDEX SE_ST ON SGAS.STUD
(PREV_SUBJECT_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             200K
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
-- SF_ST  (Index) 
--
CREATE INDEX SF_ST ON SGAS.STUD
(PROP_SUBJECT_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             200K
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
-- SI_ST  (Index) 
--
CREATE INDEX SI_ST ON SGAS.STUD
(STUDY_TYPE_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             200K
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
-- SL_ST  (Index) 
--
CREATE INDEX SL_ST ON SGAS.STUD
(MISC_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             200K
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
-- U1_ST  (Index) 
--
CREATE UNIQUE INDEX U1_ST ON SGAS.STUD
(NI_NO)
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
-- S4_ST  (Index) 
--
CREATE INDEX S4_ST ON SGAS.STUD
(PREV_INST_CODE)
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
-- S5_ST  (Index) 
--
CREATE INDEX S5_ST ON SGAS.STUD
(PROP_INST_CODE)
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
-- S6_ST  (Index) 
--
CREATE INDEX S6_ST ON SGAS.STUD
(ARC_ID)
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
-- SB_ST  (Index) 
--
CREATE INDEX SB_ST ON SGAS.STUD
(PARENT_OCC_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             200K
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
-- S3_ST  (Index) 
--
CREATE INDEX S3_ST ON SGAS.STUD
(RESIDENCE_ID)
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
-- P_ST  (Index) 
--
CREATE UNIQUE INDEX P_ST ON SGAS.STUD
(STUD_REF_NO)
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
-- SM_ST  (Index) 
--
CREATE INDEX SM_ST ON SGAS.STUD
(ACCOUNT_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             500K
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
-- S2_ST  (Index) 
--
CREATE INDEX S2_ST ON SGAS.STUD
(SURNAME)
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
-- U2_ST  (Index) 
--
CREATE UNIQUE INDEX U2_ST ON SGAS.STUD
(UCAS_NO)
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
-- SC_ST  (Index) 
--
CREATE INDEX SC_ST ON SGAS.STUD
(DISABILITY_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             200K
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
-- SJ_ST  (Index) 
--
CREATE INDEX SJ_ST ON SGAS.STUD
(STUDY_LEVEL_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             200K
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
-- S7_ST  (Index) 
--
CREATE INDEX S7_ST ON SGAS.STUD
(RES_PLACE_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             200K
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
-- S8_ST  (Index) 
--
CREATE INDEX S8_ST ON SGAS.STUD
(BIRTH_PLACE_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             200K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

-- 005
ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_PROBLEM_CASE
 CHECK ( PROBLEM_CASE IN('Y', 'N')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_BC_CHANGED
 CHECK ( BC_CHANGED IN('Y')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_ABROAD
 CHECK ( ABROAD IN('0','1','2')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_ADDR_CORR_FLAG
 CHECK (ADDR_CORR_FLAG IN ('H','T')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_STUD_LABEL
 CHECK (stud_label in ('N','C')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_NOMINEE
 CHECK ( NOMINEE IN('Y','N')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_SEX
 CHECK ( SEX IN('M','F')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_CAND_ENDOW_IND
 CHECK ( CAND_ENDOW_IND IN('Y','N')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_PAYMENT_METHOD
 CHECK ( PAYMENT_METHOD IN('B','C')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_NOM_METHOD
 CHECK ( NOM_METHOD IN('B','C')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_DISABLED
 CHECK ( DISABLED IN('Y','N')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_SUSPEND_PAYMENT
 CHECK ( SUSPEND_PAYMENT IN('Y','N')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_RC_CHANGED
 CHECK ( RC_CHANGED IN('Y')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_WRITE_OFF_IND
 CHECK ( WRITE_OFF_IND IN('Y','N')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_MARITAL_STATUS
 CHECK ( MARITAL_STATUS IN('S','M','D','P','W','E')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_DOB_CHANGED
 CHECK ( DOB_CHANGED IN('Y')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_COLOUR_LABEL
 CHECK (COLOUR_LABEL IN('Y','N')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_GE1
 CHECK (sys_ge_liability in ('Y','N')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_GE2
 CHECK (cw_ge_liability in ('Y','N','A')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT ST_SUSPEND
 CHECK (stud_suspend in('Y', 'N')))
/

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT P_ST
 PRIMARY KEY
 (STUD_REF_NO)
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

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT F1_ST
 FOREIGN KEY (BIRTH_COUNTRY_CODE) 
 REFERENCES SGAS.COUNTRY (COUNTRY_CODE));

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT F2_ST
 FOREIGN KEY (NATION_COUNTRY_CODE) 
 REFERENCES SGAS.COUNTRY (COUNTRY_CODE));

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT F3_ST
 FOREIGN KEY (RESIDENCE_COUNTRY_CODE) 
 REFERENCES SGAS.COUNTRY (COUNTRY_CODE));

ALTER TABLE SGAS.STUD ADD (
  CONSTRAINT F4_ST
 FOREIGN KEY (DISABILITY_ID) 
 REFERENCES SGAS.DISABILITY_TYPE (DISABILITY_TYPE_ID));


DROP SEQUENCE SGAS.ST_SLC_REF_NO_SEQ;

CREATE SEQUENCE SGAS.ST_SLC_REF_NO_SEQ
  START WITH 700000
  MAXVALUE 999999
  MINVALUE 700000
  NOCYCLE
  NOCACHE
  NOORDER;

GRANT SELECT ON  SGAS.ST_SLC_REF_NO_SEQ TO PUBLIC;

---007
CREATE OR REPLACE TRIGGER sgas.trig_st_slc_ref_no_seq
   BEFORE INSERT
   ON sgas.stud
   FOR EACH ROW
DECLARE
   slc               NUMBER;
   dig1              NUMBER;
   dig2              NUMBER;
   dig3              NUMBER;
   dig4              NUMBER;
   dig5              NUMBER;
   dig6              NUMBER;
   dig7              NUMBER;
   dig8              NUMBER;
   dig9              NUMBER;
   dig10             NUMBER;
   dig11             NUMBER;
   dig12             NUMBER;
   l_total           NUMBER;
   l_rem             NUMBER;
   l_diff            NUMBER;
   l_sess            VARCHAR2 (4);
   slcno             VARCHAR2 (10);
   chk_dig           VARCHAR2 (1);
   p_scottish_cand   stud.scottish_cand%TYPE   := :NEW.scottish_cand;
BEGIN
   IF p_scottish_cand IS NULL
   THEN
      SELECT st_slc_ref_no_seq.NEXTVAL
        INTO slc
        FROM DUAL;

      SELECT SUBSTR (cval, 3, 2)
        INTO l_sess
        FROM config_data
       WHERE item_name = 'CURRENT_SESSION';

      slcno :=
              LTRIM (RTRIM (l_sess))
              || LTRIM (RTRIM (TO_CHAR (slc, '000000')));
      --
      dig1 := 16 * 13;
      dig2 := 1 * 12;
      dig3 := 1 * 11;
      dig4 := 16 * 10;
      dig5 := TO_NUMBER (SUBSTR (l_sess, 1, 1)) * 9;
      dig6 := TO_NUMBER (SUBSTR (l_sess, 2, 1)) * 8;
      dig7 := TO_NUMBER (SUBSTR (slcno, 3, 1)) * 7;
      dig8 := TO_NUMBER (SUBSTR (slcno, 4, 1)) * 6;
      dig9 := TO_NUMBER (SUBSTR (slcno, 5, 1)) * 5;
      dig10 := TO_NUMBER (SUBSTR (slcno, 6, 1)) * 4;
      dig11 := TO_NUMBER (SUBSTR (slcno, 7, 1)) * 3;
      dig12 := TO_NUMBER (SUBSTR (slcno, 8, 1)) * 2;
      --
      l_total :=
           dig1
         + dig2
         + dig3
         + dig4
         + dig5
         + dig6
         + dig7
         + dig8
         + dig9
         + dig10
         + dig11
         + dig12;

      --
      SELECT MOD (l_total, 23)
        INTO l_rem
        FROM DUAL;

      --
      l_diff := 23 - l_rem;

      --
      IF l_diff = 1
      THEN
         chk_dig := 'A';
      ELSIF l_diff = 2
      THEN
         chk_dig := 'B';
      ELSIF l_diff = 3
      THEN
         chk_dig := 'C';
      ELSIF l_diff = 4
      THEN
         chk_dig := 'D';
      ELSIF l_diff = 5
      THEN
         chk_dig := 'E';
      ELSIF l_diff = 6
      THEN
         chk_dig := 'F';
      ELSIF l_diff = 7
      THEN
         chk_dig := 'G';
      ELSIF l_diff = 8
      THEN
         chk_dig := 'H';
      ELSIF l_diff = 9
      THEN
         chk_dig := 'J';
      ELSIF l_diff = 10
      THEN
         chk_dig := 'K';
      ELSIF l_diff = 11
      THEN
         chk_dig := 'L';
      ELSIF l_diff = 12
      THEN
         chk_dig := 'M';
      ELSIF l_diff = 13
      THEN
         chk_dig := 'N';
      ELSIF l_diff = 14
      THEN
         chk_dig := 'P';
      ELSIF l_diff = 15
      THEN
         chk_dig := 'R';
      ELSIF l_diff = 16
      THEN
         chk_dig := 'S';
      ELSIF l_diff = 17
      THEN
         chk_dig := 'T';
      ELSIF l_diff = 18
      THEN
         chk_dig := 'U';
      ELSIF l_diff = 19
      THEN
         chk_dig := 'V';
      ELSIF l_diff = 20
      THEN
         chk_dig := 'W';
      ELSIF l_diff = 21
      THEN
         chk_dig := 'X';
      ELSIF l_diff = 22
      THEN
         chk_dig := 'Y';
      ELSIF l_diff = 23
      THEN
         chk_dig := 'Z';
      END IF;

      --
      slcno := slcno || chk_dig;

      SELECT slcno
        INTO :NEW.scottish_cand
        FROM DUAL;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20000,
                               'SLC_REF_NO ERROR: ' || SQLERRM || SQLCODE
                              );
END trig_st_slc_ref_no_seq;
/

--- 008

/* Formatted on 2008/10/15 10:53 (Formatter Plus v4.8.8) */
/******************************************************************************
NAME: ST_IUD        
PURPOSE: Trigger to meet audit requirements

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        07.10.2008  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STUD.sql $ 
$Author: $ 
$Date: 2011-02-21 14:24:49 +0000 (Mon, 21 Feb 2011) $ 
$Revision: 6494 $ 
 
*******************************************************************************/
CREATE OR REPLACE TRIGGER SGAS.st_iud
   AFTER INSERT OR DELETE OR UPDATE OF account_no,
                                       birth_cert_flag,
                                       birth_country_code,
                                       def_overpayment,
                                       disabled,
                                       dob,
                                       dsa_eqmt,
                                       forenames,
                                       initials,
                                       maiden_name,
                                       marital_status,
                                       marriage_date,
                                       nation_country_code,
                                       ni_no,
                                       nominee,
                                       nom_method,
                                       nom_name,
                                       overpayment,
                                       overpay_stat,
                                       payment_method,
                                       residence_country_code,
                                       residence_id,
                                       sex,
                                       snb_def_overpayment,
                                       snb_overpayment,
                                       sort_code,
                                       surname,
                                       title,
                                       valid_duplicate_acc,
                                       dup_bank_reason,
                                       bankrupt_flag,
                                       qa_count,
                                       stud_suspend,
                                       last_updated_by
   ON SGAS.STUD    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   p_aud_date       DATE                         := SYSDATE;
   p_column_name    stud_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_aud.table_pkey1%TYPE    := :OLD.stud_ref_no;
   p_table_pkey2    stud_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_aud.OLD%TYPE            := NULL;
   p_new            stud_aud.NEW%TYPE            := NULL;
   p_action         stud_aud.action%TYPE         := NULL;
   p_username       stud_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    stud_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      stud_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_aud.session_code%TYPE   := NULL;
   will_update      VARCHAR2 (1)                 := 'N';
   p_table_name     VARCHAR2 (32)                := 'STUD';
   p_dob            stud.dob%TYPE;
   p_initials       stud.initials%TYPE;
   p_forenames      stud.forenames%TYPE;
   p_surname        stud.surname%TYPE;
   p_ni_no          stud.ni_no%TYPE;
   p_mobile         stud.mobile_tel_no%TYPE;
   p_email          stud.email_addr%TYPE;
   p_calc           DATE                         := NULL;
   p_sent           DATE                         := NULL;
   v_updated        VARCHAR2 (1)                 := 'N';
BEGIN
   /*IF Change_Audit.auditing_on != 'FALSE' THEN
   --PB Feb 2005
   P_STUD_REF_NO := :NEW.STUD_REF_NO;
   P_DOB := :NEW.DOB;
   P_INITIALS := :NEW.INITIALS;
   P_FORENAMES := :NEW.FORENAMES;
   P_SURNAME := :NEW.SURNAME;
   P_NI_NO := :NEW.NI_NO;
   P_MOBILE := :NEW.MOBILE_TEL_NO;
   P_EMAIL := :NEW.EMAIL_ADDR;*/
   --
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
      p_stud_ref_no := :OLD.stud_ref_no;
      p_dob := :OLD.dob;
      p_initials := :OLD.initials;
      p_forenames := :OLD.forenames;
      p_surname := :OLD.surname;
      p_ni_no := :OLD.ni_no;
      p_mobile := :OLD.mobile_tel_no;
      p_email := :OLD.email_addr;
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
      p_table_pkey1 := :NEW.stud_ref_no;
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   ELSIF UPDATING
   THEN
      p_action := 'U';

      IF (NVL (:OLD.forenames, ' ') <> NVL (:NEW.forenames, ' '))
      THEN
         will_update := 'Y';
      ELSIF (NVL (:OLD.surname, ' ') <> NVL (:NEW.surname, ' '))
      THEN
         will_update := 'Y';
      ELSIF (NVL (:OLD.sex, ' ') <> NVL (:NEW.sex, ' '))
      THEN
         will_update := 'Y';
      ELSIF (:OLD.dob <> :NEW.dob)
      THEN
         will_update := 'Y';
      END IF;

      IF will_update = 'Y'
      THEN
         pk_steps_changes.stud_rep (:OLD.stud_ref_no,
                        :NEW.forenames,
                        :NEW.surname,
                        :NEW.dob,
                        :NEW.sex
                       );
      END IF;
   END IF;

   --- IF P_ACTION <> 'I' THEN
   p_column_name := 'DOB';
   p_old := TO_CHAR (:OLD.dob, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.dob, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'TITLE';
   p_old := :OLD.title;
   p_new := :NEW.title;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'INITIALS';
   p_old := :OLD.initials;
   p_new := :NEW.initials;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'FORENAMES';
   p_old := :OLD.forenames;
   p_new := :NEW.forenames;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'SURNAME';
   p_old := :OLD.surname;
   p_new := :NEW.surname;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'SEX';
   p_old := :OLD.sex;
   p_new := :NEW.sex;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'RESIDENCE_ID';
   p_old := TO_CHAR (:OLD.residence_id);
   p_new := TO_CHAR (:NEW.residence_id);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'BIRTH_COUNTRY_CODE';
   p_old := TO_CHAR (:OLD.birth_country_code);
   p_new := TO_CHAR (:NEW.birth_country_code);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'RESIDENCE_COUNTRY_CODE';
   p_old := TO_CHAR (:OLD.residence_country_code);
   p_new := TO_CHAR (:NEW.residence_country_code);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'NATION_COUNTRY_CODE';
   p_old := TO_CHAR (:OLD.nation_country_code);
   p_new := TO_CHAR (:NEW.nation_country_code);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'NOMINEE';
   p_old := :OLD.nominee;
   p_new := :NEW.nominee;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_METHOD';
   p_old := :OLD.payment_method;
   p_new := :NEW.payment_method;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'OVERPAY_STAT';
   p_old := :OLD.overpay_stat;
   p_new := :NEW.overpay_stat;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'OVERPAYMENT';
   p_old := TO_CHAR (:OLD.overpayment);
   p_new := TO_CHAR (:NEW.overpayment);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'DEF_OVERPAYMENT';
   p_old := TO_CHAR (:OLD.def_overpayment);
   p_new := TO_CHAR (:NEW.def_overpayment);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'SNB_OVERPAYMENT';
   p_old := TO_CHAR (:OLD.snb_overpayment);
   p_new := TO_CHAR (:NEW.snb_overpayment);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'SNB_DEF_OVERPAYMENT';
   p_old := TO_CHAR (:OLD.snb_def_overpayment);
   p_new := TO_CHAR (:NEW.snb_def_overpayment);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'DISABLED';
   p_old := :OLD.disabled;
   p_new := :NEW.disabled;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'MARITAL_STATUS';
   p_old := :OLD.marital_status;
   p_new := :NEW.marital_status;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'MARRIAGE_DATE';
   p_old := TO_CHAR (:OLD.marriage_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.marriage_date, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'ACCOUNT_NO';
   p_old := :OLD.account_no;
   p_new := :NEW.account_no;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'SORT_CODE';
   p_old := :OLD.sort_code;
   p_new := :NEW.sort_code;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'NOM_METHOD';
   p_old := :OLD.nom_method;
   p_new := :NEW.nom_method;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'NOM_NAME';
   p_old := :OLD.nom_name;
   p_new := :NEW.nom_name;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'MAIDEN_NAME';
   p_old := :OLD.maiden_name;
   p_new := :NEW.maiden_name;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'DSA_EQMT';
   p_old := TO_CHAR (:OLD.dsa_eqmt);
   p_new := TO_CHAR (:NEW.dsa_eqmt);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'SUSPEND_PAYMENT';
   p_old := :OLD.suspend_payment;
   p_new := :NEW.suspend_payment;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'NI_NO';
   p_old := :OLD.ni_no;
   p_new := :NEW.ni_no;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'BIRTH_CERT_FLAG';
   p_old := :OLD.birth_cert_flag;
   p_new := :NEW.birth_cert_flag;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'VALID_DUPLICATE_ACC';
   p_old := :OLD.valid_duplicate_acc;
   p_new := :NEW.valid_duplicate_acc;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'DUP_BANK_REASON';
   p_old := :OLD.dup_bank_reason;
   p_new := :NEW.dup_bank_reason;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'BANKRUPT_FLAG';
   p_old := :OLD.bankrupt_flag;
   p_new := :NEW.bankrupt_flag;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'QA_COUNT';
   p_old := :OLD.qa_count;
   p_new := :NEW.qa_count;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'STUD_SUSPEND';
   p_old := :OLD.STUD_SUSPEND;
   p_new := :NEW.STUD_SUSPEND;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   --END IF;

   /*New auditing for Telephony - PB Feb 2005*/
    --
   p_column_name := 'STUD_REF_NO';
   p_old := :OLD.stud_ref_no;
   p_new := :NEW.stud_ref_no;

   IF :OLD.stud_ref_no <> :NEW.stud_ref_no
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'DOB';
   p_old := TO_CHAR (:OLD.dob, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.dob, 'DD/MM/YYYY HH24:MI');

   IF :OLD.dob <> :NEW.dob
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'INITIALS';
   p_old := :OLD.initials;
   p_new := :NEW.initials;

   IF NVL (:OLD.initials, 'BLANK') <> NVL (:NEW.initials, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'FORENAMES';
   p_old := :OLD.forenames;
   p_new := :NEW.forenames;

   IF :OLD.forenames <> :NEW.forenames
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'SURNAME';
   p_old := :OLD.surname;
   p_new := :NEW.surname;

   IF :OLD.surname <> :NEW.surname
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'NI_NO';
   p_old := :OLD.ni_no;
   p_new := :NEW.ni_no;

   IF NVL (:OLD.ni_no, 'BLANK') <> NVL (:NEW.ni_no, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'MOBILE_TEL_NO';
   p_old := :OLD.mobile_tel_no;
   p_new := :NEW.mobile_tel_no;

   IF NVL (:OLD.mobile_tel_no, 0) <> NVL (:NEW.mobile_tel_no, 0)
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'EMAIL_ADDR';
   p_old := :OLD.email_addr;
   p_new := :NEW.email_addr;

   IF NVL (:OLD.email_addr, 'BLANK') <> NVL (:NEW.email_addr, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   IF v_updated = 'Y'
   THEN
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
      telephony_support.update_web_mail (p_stud_ref_no, :NEW.email_addr);
   END IF;
/* End of Additions
     END IF;*/
END st_iud;
SHOW ERRORS;


CREATE OR REPLACE TRIGGER sgas.st_aiu
   AFTER INSERT OR UPDATE OF abroad,
                             dob,
                             title,
                             initials,
                             forenames,
                             surname,
                             sex,
                             birth_country_code,
                             residence_country_code,
                             nation_country_code,
                             ucas_no,
                             suspend_payment,
                             birth_forenames,
                             birth_surname,
                             district_birth_cert_issued,
                             addr_corr_flag,
                             bankrupt_flag,
                             travel_method,
                             bank_validate,
                             mobile_tel_no,
                             email_addr,
                             payment_method,
                             ni_no,
                             account_no,
                             sort_code
   ON sgas.stud
   FOR EACH ROW
DECLARE
   p_stud_ref_no                  stud.stud_ref_no%TYPE   := :OLD.stud_ref_no;
   p_abroad                       stud.abroad%TYPE;
   p_dob                          stud.dob%TYPE;
   p_title                        stud.title%TYPE;
   p_initials                     stud.initials%TYPE;
   p_forenames                    stud.forenames%TYPE;
   p_surname                      stud.surname%TYPE;
   p_sex                          stud.sex%TYPE;
   p_birth_country_code           stud.birth_country_code%TYPE;
   p_residence_country_code       stud.residence_country_code%TYPE;
   p_nation_country_code          stud.nation_country_code%TYPE;
   p_ucas_no                      stud.ucas_no%TYPE;
   p_suspend_payment              stud.suspend_payment%TYPE;
   p_birth_forenames              stud.birth_forenames%TYPE;
   p_birth_surname                stud.birth_surname%TYPE;
   p_district_birth_cert_issued   stud.district_birth_cert_issued%TYPE;
   p_addr_corr_flag               stud.addr_corr_flag%TYPE;
   p_bankrupt_flag                stud.bankrupt_flag%TYPE;
   p_travel_method                stud.travel_method%TYPE;
   p_bank_validate                stud.bank_validate%TYPE;
   p_mobile_tel_no                stud.mobile_tel_no%TYPE;
   p_email_addr                   stud.email_addr%TYPE;
   p_payment_method               stud.payment_method%TYPE;
   p_ni_no                        stud.ni_no%TYPE;
   p_account_no                   stud.account_no%TYPE;
   p_sort_code                    stud.sort_code%TYPE;
   p_action                       VARCHAR2 (1)                        := NULL;
   update_batch_recalc            VARCHAR2 (1)                         := 'N';
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_stud_ref_no := :OLD.stud_ref_no;
   END IF;

   IF (    (:OLD.payment_method IS NOT NULL
            AND :NEW.payment_method IS NOT NULL
           )
       AND (:OLD.payment_method <> :NEW.payment_method)
      )
   THEN
      update_batch_recalc := 'Y';
   ELSIF (NVL (:OLD.ni_no, ' ') <> NVL (:NEW.ni_no, ' '))
   THEN
      update_batch_recalc := 'Y';
   ELSIF (NVL (:OLD.account_no, ' ') <> NVL (:NEW.account_no, ' '))
   THEN
      update_batch_recalc := 'Y';
   ELSIF (NVL (:OLD.sort_code, ' ') <> NVL (:NEW.sort_code, ' '))
   THEN
      update_batch_recalc := 'Y';
   END IF;

   IF p_action = 'I'
   THEN
      pk_steps_to_grass.update_stud_in_grass
                                            (p_stud_ref_no,
                                             :NEW.abroad,
                                             :NEW.dob,
                                             :NEW.title,
                                             :NEW.initials,
                                             :NEW.forenames,
                                             :NEW.surname,
                                             :NEW.sex,
                                             :NEW.birth_country_code,
                                             :NEW.residence_country_code,
                                             :NEW.nation_country_code,
                                             :NEW.ucas_no,
                                             :NEW.suspend_payment,
                                             :NEW.birth_forenames,
                                             :NEW.birth_surname,
                                             :NEW.district_birth_cert_issued,
                                             :NEW.addr_corr_flag,
                                             :NEW.bankrupt_flag,
                                             :NEW.travel_method,
                                             :NEW.bank_validate,
                                             :NEW.mobile_tel_no,
                                             :NEW.email_addr,
                                             :NEW.payment_method,
                                             :NEW.ni_no,
                                             :NEW.account_no,
                                             :NEW.sort_code
                                            );
   ELSIF p_action = 'U'
   THEN
      pk_steps_to_grass.update_stud_in_grass
                                            (p_stud_ref_no,
                                             :NEW.abroad,
                                             :NEW.dob,
                                             :NEW.title,
                                             :NEW.initials,
                                             :NEW.forenames,
                                             :NEW.surname,
                                             :NEW.sex,
                                             :NEW.birth_country_code,
                                             :NEW.residence_country_code,
                                             :NEW.nation_country_code,
                                             :NEW.ucas_no,
                                             :NEW.suspend_payment,
                                             :NEW.birth_forenames,
                                             :NEW.birth_surname,
                                             :NEW.district_birth_cert_issued,
                                             :NEW.addr_corr_flag,
                                             :NEW.bankrupt_flag,
                                             :NEW.travel_method,
                                             :NEW.bank_validate,
                                             :NEW.mobile_tel_no,
                                             :NEW.email_addr,
                                             :NEW.payment_method,
                                             :NEW.ni_no,
                                             :NEW.account_no,
                                             :NEW.sort_code
                                            );
   END IF;

   IF update_batch_recalc = 'Y'
   THEN
      pk_steps_to_grass.update_batch_recalc (p_stud_ref_no);
   END IF;

   /* Update the unpaid award_instalment to pay by new method*/
   IF     (NVL (:OLD.payment_method, ' ') <> NVL (:NEW.payment_method, ' '))
      AND :NEW.payment_method = 'B'
   THEN
      pk_steps_to_grass.update_aw_inst (p_stud_ref_no);

      /* Re-send student to the SLC for FILE 2 ONLY*/
      UPDATE stud_crse_year
         SET slc2_sent = 'N'
       WHERE stud_crse_year_id =
                (SELECT MAX (stud_crse_year_id)
                   FROM stud_crse_year
                  WHERE stud_ref_no = p_stud_ref_no
                    AND latest_crse_ind = 'Y'
                    AND first_slc1_sent_date IS NOT NULL);
   END IF;

END st_aiu;
/

SHOW ERRORS;



-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM STUD
/

CREATE PUBLIC SYNONYM STUD FOR SGAS.STUD
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON SGAS.STUD
TO EDM_USER
/

--
-- STUD  (Materialized View Log)
--
DROP SNAPSHOT LOG ON STUD
/
--
-- STUD  (Materialized View Log) 
--
CREATE MATERIALIZED VIEW LOG ON STUD
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

DROP SEQUENCE sgas.st_stud_ref_no_seq;

CREATE SEQUENCE sgas.st_stud_ref_no_seq
  START WITH 2000000
  MAXVALUE 999999999999
  MINVALUE 2000000
  NOCYCLE
  NOCACHE
  NOORDER;

DROP PUBLIC SYNONYM st_stud_ref_no_seq;

CREATE PUBLIC SYNONYM st_stud_ref_no_seq 
FOR sgas.st_stud_ref_no_seq;

GRANT SELECT ON  sgas.st_stud_ref_no_seq 
TO PUBLIC;