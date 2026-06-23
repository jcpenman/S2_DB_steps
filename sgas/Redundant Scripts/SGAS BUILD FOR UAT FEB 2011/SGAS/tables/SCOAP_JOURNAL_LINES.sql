-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            28.02.08   S Durkin (Sopra UK)         Initial Version.
-- 001      03.09.10    A.Bowman (SAAS)              Added foreign key constraint
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/SCOAP_JOURNAL_LINES.sql $
-- $Author: $
-- $Date: 2010-09-03 10:58:37 +0100 (Fri, 03 Sep 2010) $
-- $Revision: 5627 $


DROP TABLE SGAS.SCOAP_JOURNAL_LINES CASCADE CONSTRAINTS
/

--
-- SCOAP_JOURNAL_LINES  (Table) 
--
CREATE TABLE SGAS.SCOAP_JOURNAL_LINES
(
  DPJ_BATCH_REF      VARCHAR2(7 BYTE) CONSTRAINT NN_SJ_DPJ_BATCH_REF NOT NULL,
  DPJ_COST_CENTRE    VARCHAR2(6 BYTE),
  DPJ_ACCOUNT        VARCHAR2(8 BYTE),
  DPJ_ACTIVITY       VARCHAR2(6 BYTE),
  DPJ_JOB            VARCHAR2(8 BYTE),
  DPJ_ANALYSIS_1_ID  VARCHAR2(10 BYTE),
  DPJ_ANALYSIS_2_ID  VARCHAR2(10 BYTE)          DEFAULT '          ',
  DPJ_ANALYSIS_3_ID  VARCHAR2(10 BYTE)          DEFAULT '          ',
  DPJ_ANALYSIS_4_ID  VARCHAR2(10 BYTE)          DEFAULT '          ',
  DPJ_ANALYSIS_5_ID  VARCHAR2(10 BYTE)          DEFAULT '          ',
  DPJ_ANALYSIS_6_ID  VARCHAR2(10 BYTE)          DEFAULT '          ',
  DPJ_SIGN           VARCHAR2(1 BYTE),
  DPJ_AMOUNT         NUMBER(15,2),
  DPJ_VOLUME         NUMBER(15,2),
  DPJ_UOM            VARCHAR2(3 BYTE),
  DPJ_DESCRIPTION    VARCHAR2(30 BYTE),
  DPJ_VAT_AMOUNT     NUMBER(15,2)               DEFAULT 0,
  DPJ_VAT_CODE       VARCHAR2(2 BYTE),
  DPJ_PROGRAMME      VARCHAR2(3 BYTE),
  DPJ_CURRENCY       VARCHAR2(15 BYTE),
  DPJ_ENTITY         VARCHAR2(3 BYTE),
  DPJ_PAYMENT_TYPE   VARCHAR2(1 BYTE),
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_SJ_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_SJ_LAST_UPDATED_ON NOT NULL
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

COMMENT ON COLUMN SGAS.SCOAP_JOURNAL_LINES.DPJ_PAYMENT_TYPE IS 'Payment type of batch ''C'' payable order ''B'' BACs'
/


--
-- S1_SJ  (Index) 
--
CREATE INDEX S1_SJ ON SGAS.SCOAP_JOURNAL_LINES
(DPJ_BATCH_REF)
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
-- Non Foreign Key Constraints for Table SCOAP_JOURNAL_LINES 
-- 
ALTER TABLE SGAS.SCOAP_JOURNAL_LINES ADD (
  CONSTRAINT SJ_DPJ_SIGN
 CHECK ( DPJ_SIGN IN('+','-')))
/

ALTER TABLE SGAS.SCOAP_JOURNAL_LINES ADD (
  CHECK (DPJ_PAYMENT_TYPE IN ('C','B')))
/

ALTER TABLE SGAS.SCOAP_JOURNAL_LINES ADD (
  CONSTRAINT F1_SJ 
 FOREIGN KEY (DPJ_BATCH_REF) 
 REFERENCES SGAS.SCOAP_BATCHES (DPB_BATCH_REF));