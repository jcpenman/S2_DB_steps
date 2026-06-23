-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            28.02.08   S Durkin (Sopra UK)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/PT_STUD_INCOME.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $


DROP TABLE SGAS.PT_STUD_INCOME CASCADE CONSTRAINTS
/

--
-- PT_STUD_INCOME  (Table) 
--
CREATE TABLE SGAS.PT_STUD_INCOME
(
  STUD_SESSION_ID      NUMBER(9)                NOT NULL,
  STUD_REF_NO          NUMBER(10)               NOT NULL,
  SESSION_CODE         NUMBER(4)                NOT NULL,
  INCOME_TYPE          VARCHAR2(1 BYTE)         DEFAULT 'C'                   NOT NULL,
  INCOME_STATUS        VARCHAR2(1 BYTE)         NOT NULL,
  RETIRED              VARCHAR2(1 BYTE)         DEFAULT 'N'                   NOT NULL,
  UNEMPLOYED           VARCHAR2(1 BYTE)         DEFAULT 'N'                   NOT NULL,
  BANK_INTEREST        NUMBER(9,2)              NOT NULL,
  BENEFIT              NUMBER(9,2)              NOT NULL,
  OTHER_INCOME         NUMBER(9,2)              NOT NULL,
  NAT_SAVING_INTEREST  NUMBER(9,2)              NOT NULL,
  PAYE_INCOME          NUMBER(9,2)              NOT NULL,
  PENSION              NUMBER(9,2)              NOT NULL,
  SELF_EMPLOYMENT      NUMBER(9,2)              NOT NULL,
  PROPERTY             NUMBER(9,2)              NOT NULL,
  DIVIDEND             NUMBER(9,2)              NOT NULL,
  P60_REQ              VARCHAR2(1 BYTE)         DEFAULT 'Y'                   NOT NULL,
  SCHED_A_REQ          VARCHAR2(1 BYTE)         DEFAULT 'N'                   NOT NULL,
  SCHED_D_REQ          VARCHAR2(1 BYTE)         DEFAULT 'N'                   NOT NULL,
  SCHED_E_REQ          VARCHAR2(1 BYTE)         DEFAULT 'N'                   NOT NULL,
  PENSION_CB           VARCHAR2(1 BYTE)         DEFAULT 'N',
  BENEFIT_CB           VARCHAR2(1 BYTE)         DEFAULT 'N',
  QA_RECEIVED          VARCHAR2(1 BYTE),
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_PTSI_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_PTSI_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
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
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/


--
-- P_PTSI  (Index) 
--
CREATE UNIQUE INDEX P_PTSI ON SGAS.PT_STUD_INCOME
(STUD_SESSION_ID)
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
-- S1_PTSI  (Index) 
--
CREATE INDEX S1_PTSI ON SGAS.PT_STUD_INCOME
(STUD_REF_NO)
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
-- S2_PTSI  (Index) 
--
CREATE INDEX S2_PTSI ON SGAS.PT_STUD_INCOME
(SESSION_CODE)
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
-- Non Foreign Key Constraints for Table PT_STUD_INCOME 
-- 
ALTER TABLE SGAS.PT_STUD_INCOME ADD (
  CONSTRAINT PTSI_QA_RECEIVED
 CHECK (QA_RECEIVED IN('Y','N')))
/

ALTER TABLE SGAS.PT_STUD_INCOME ADD (
  CONSTRAINT PTSI_BENEFIT_CB
 CHECK (BENEFIT_CB IN('Y','N')))
/

ALTER TABLE SGAS.PT_STUD_INCOME ADD (
  CONSTRAINT PTSI_PENSION_CB
 CHECK (PENSION_CB IN('Y','N')))
/

ALTER TABLE SGAS.PT_STUD_INCOME ADD (
  CONSTRAINT PTSI_SCHED_E_REQ
 CHECK (SCHED_E_REQ IN('Y','N')))
/

ALTER TABLE SGAS.PT_STUD_INCOME ADD (
  CONSTRAINT PTSI_SCHED_D_REQ
 CHECK (SCHED_D_REQ IN('Y','N')))
/

ALTER TABLE SGAS.PT_STUD_INCOME ADD (
  CONSTRAINT PTSI_SCHED_A_REQ
 CHECK (SCHED_A_REQ IN('Y','N')))
/

ALTER TABLE SGAS.PT_STUD_INCOME ADD (
  CONSTRAINT PTSI_P60_REQ
 CHECK (P60_REQ IN('Y','N')))
/

ALTER TABLE SGAS.PT_STUD_INCOME ADD (
  CONSTRAINT PTSI_UNEMPLOYED
 CHECK (UNEMPLOYED IN('Y','N')))
/

ALTER TABLE SGAS.PT_STUD_INCOME ADD (
  CONSTRAINT PTSI_RETIRED
 CHECK (RETIRED IN('Y','N')))
/

ALTER TABLE SGAS.PT_STUD_INCOME ADD (
  CONSTRAINT PTSI_INCOME_STATUS
 CHECK (INCOME_STATUS IN('P','F','Q')))
/

ALTER TABLE SGAS.PT_STUD_INCOME ADD (
  CONSTRAINT PTSI_INCOME_TYPE
 CHECK (INCOME_TYPE IN('P','C')))
/
