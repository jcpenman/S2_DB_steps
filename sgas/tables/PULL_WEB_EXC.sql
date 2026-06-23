-- PULL_WEB_EXC.sql
-- Description: This table is used to store all web change exceptions
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

DROP TABLE SGAS.PULL_WEB_EXC CASCADE CONSTRAINTS;

CREATE TABLE SGAS.PULL_WEB_EXC
(
  CHANGE_DATE  DATE,
  SQLCODE      VARCHAR2(25 BYTE),
  SQLERRM      VARCHAR2(100 BYTE)
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

DROP PUBLIC SYNONYM PULL_WEB_EXC;

CREATE PUBLIC SYNONYM PULL_WEB_EXC FOR SGAS.PULL_WEB_EXC;