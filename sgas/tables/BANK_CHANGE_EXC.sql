-- BANK_CHANGE_EXC.sql
-- Description: This table is used to store any bank change exceptions and the data
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

DROP TABLE SGAS.BANK_CHANGE_EXC CASCADE CONSTRAINTS;

CREATE TABLE SGAS.BANK_CHANGE_EXC
(
  STUD_REF_NO       NUMBER(10)                  NOT NULL,
  CHANGE_DATE       DATE                        NOT NULL,
  NAME              VARCHAR2(25 BYTE),
  BUILDING_NO_NAME  VARCHAR2(32 BYTE),
  ADDR_L1           VARCHAR2(65 BYTE),
  ADDR_L2           VARCHAR2(65 BYTE),
  ADDR_L3           VARCHAR2(32 BYTE),
  ADDR_L4           VARCHAR2(32 BYTE),
  POST_CODE         VARCHAR2(8 BYTE),
  ACCOUNT_NO        VARCHAR2(10 BYTE)           NOT NULL,
  SORT_CODE         VARCHAR2(6 BYTE)            NOT NULL,
  BANK_VALIDATE     VARCHAR2(1 BYTE),
  SQLCODE           VARCHAR2(25 BYTE),
  SQLERRM           VARCHAR2(100 BYTE)
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

DROP PUBLIC SYNONYM BANK_CHANGE_EXC;

CREATE PUBLIC SYNONYM BANK_CHANGE_EXC FOR SGAS.BANK_CHANGE_EXC;