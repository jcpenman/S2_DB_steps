-- TITLE_NAME_CHANGE_EXC.sql
-- Description: This table is used to store any title_name change exceptions and the data
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

DROP TABLE SGAS.TITLE_NAME_CHANGE_EXC CASCADE CONSTRAINTS;

CREATE TABLE SGAS.TITLE_NAME_CHANGE_EXC
(
  STUD_REF_NO      NUMBER(10)                   NOT NULL,
  CHANGE_DATE      DATE                         NOT NULL,
  TITLE            VARCHAR2(8 BYTE)             NOT NULL,
  FORENAMES        VARCHAR2(25 BYTE)            NOT NULL,
  SURNAME          VARCHAR2(25 BYTE)            NOT NULL,
  BIRTH_FORENAMES  VARCHAR2(30 BYTE),
  BIRTH_SURNAME    VARCHAR2(30 BYTE),
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

DROP PUBLIC SYNONYM TITLE_NAME_CHANGE_EXC;

CREATE PUBLIC SYNONYM TITLE_NAME_CHANGE_EXC FOR SGAS.TITLE_NAME_CHANGE_EXC;