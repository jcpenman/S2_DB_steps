-- LOAN_CONTACTS_CHANGE_EXC.sql
-- Description: This table is used to store any loan contacts change exceptions and the data
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      02.06.11    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

DROP TABLE SGAS.LOAN_CONTACTS_CHANGE_EXC CASCADE CONSTRAINTS;

CREATE TABLE SGAS.LOAN_CONTACTS_CHANGE_EXC
(
  STUD_REF_NO      NUMBER(10)                   NOT NULL,
  CHANGE_DATE      DATE                         NOT NULL,
  NAME_1           VARCHAR2(60 BYTE)            NOT NULL,
  HOUSE_NO_NAME_1  VARCHAR2(32 BYTE)            NOT NULL,
  ADDR_L1_1        VARCHAR2(65 BYTE)            NOT NULL,
  ADDR_L2_1        VARCHAR2(65 BYTE),
  ADDR_L3_1        VARCHAR2(32 BYTE),
  ADDR_L4_1        VARCHAR2(32 BYTE),
  POST_CODE_1      VARCHAR2(8 BYTE),
  TEL_NO_1         VARCHAR2(14 BYTE),
  REL_CODE_1       VARCHAR2(1 BYTE)             NOT NULL,
  NAME_2           VARCHAR2(60 BYTE)            NOT NULL,
  HOUSE_NO_NAME_2  VARCHAR2(32 BYTE)            NOT NULL,
  ADDR_L1_2        VARCHAR2(65 BYTE)            NOT NULL,
  ADDR_L2_2        VARCHAR2(65 BYTE),
  ADDR_L3_2        VARCHAR2(32 BYTE),
  ADDR_L4_2        VARCHAR2(32 BYTE),
  POST_CODE_2      VARCHAR2(8 BYTE),
  TEL_NO_2         VARCHAR2(14 BYTE),
  SQLCODE          VARCHAR2(25 BYTE),
  SQLERRM          VARCHAR2(100 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

DROP PUBLIC SYNONYM LOAN_CONTACTS_CHANGE_EXC;

CREATE PUBLIC SYNONYM LOAN_CONTACTS_CHANGE_EXC FOR SGAS.LOAN_CONTACTS_CHANGE_EXC;