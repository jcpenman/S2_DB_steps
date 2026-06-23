-- TERM_ADDR_CHANGE_EXC.sql
-- Description: This table is used to store any term address change exceptions and the data
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

DROP TABLE SGAS.TERM_ADDR_CHANGE_EXC CASCADE CONSTRAINTS;

CREATE TABLE SGAS.TERM_ADDR_CHANGE_EXC
(
  STUD_REF_NO         NUMBER(10)                NOT NULL,
  CHANGE_DATE         DATE                      NOT NULL,
  HOUSE_NO_NAME       VARCHAR2(32 BYTE)         NOT NULL,
  ADDR_L1             VARCHAR2(65 BYTE)         NOT NULL,
  ADDR_L2             VARCHAR2(65 BYTE),
  ADDR_L3             VARCHAR2(32 BYTE),
  ADDR_L4             VARCHAR2(32 BYTE),
  POST_CODE           VARCHAR2(8 BYTE),
  RESIDENCE_IND       VARCHAR2(1 BYTE)          NOT NULL,
  TO_FROM_PARENTS_FG  VARCHAR2(1 BYTE)          NOT NULL,
  SQLCODE             VARCHAR2(25 BYTE),
  SQLERRM             VARCHAR2(100 BYTE)
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

DROP PUBLIC SYNONYM TERM_ADDR_CHANGE_EXC;

CREATE PUBLIC SYNONYM TERM_ADDR_CHANGE_EXC FOR SGAS.TERM_ADDR_CHANGE_EXC;