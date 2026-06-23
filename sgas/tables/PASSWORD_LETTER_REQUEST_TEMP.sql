-- PASSWORD_LETTER_REQUEST_TEMP.sql
-- Description: TEMP Table to hold web password letter requests data
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      04.07.11   A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $
DROP TABLE SGAS.PASSWORD_LETTER_REQUEST_TEMP CASCADE CONSTRAINTS
/

--
-- PASSWORD_LETTER_REQUEST_TEMP  (Table) 
--
CREATE TABLE SGAS.PASSWORD_LETTER_REQUEST_TEMP
(
  USERNAME        VARCHAR2(25 BYTE),
  PASSWORD        VARCHAR2(50 BYTE),
  DATE_REQUESTED  DATE,
  STUD_REF_NO     NUMBER(10),
  TITLE           VARCHAR2(5 BYTE),
  FORENAMES       VARCHAR2(25 BYTE),
  SURNAME         VARCHAR2(25 BYTE),
  HOUSE_NO_NAME   VARCHAR2(32 BYTE),
  ADDR_L1         VARCHAR2(65 BYTE),
  ADDR_L2         VARCHAR2(65 BYTE),
  ADDR_L3         VARCHAR2(65 BYTE),
  ADDR_L4         VARCHAR2(65 BYTE),
  POST_CODE       VARCHAR2(8 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

