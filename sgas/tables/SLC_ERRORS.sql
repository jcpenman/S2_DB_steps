-- SLC_ERRORS.sql
-- Description: Table holding all SLC ERRORS for SGAS
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      21.04.11    A.Bowman  (SAAS)        Initial Version.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $


--
-- SLC_ERRORS  (Table) 
--

DROP TABLE SGAS.SLC_ERRORS CASCADE CONSTRAINTS;

CREATE TABLE SGAS.SLC_ERRORS
(
  SLC_FILENAME       VARCHAR2(20 BYTE),
  SLC_FILE_DATE      DATE,
  SLC_FILE_TYPE      NUMBER(1),
  STUD_CRSE_YEAR_ID  NUMBER(9),
  STUD_REF_NO        NUMBER(10),
  INST_CODE          VARCHAR2(5 BYTE),
  CRSE_CODE          VARCHAR2(4 BYTE),
  SESSION_CODE       NUMBER(4),
  SLC_REF_NO         VARCHAR2(10 BYTE),
  ERROR_DESCRIPTION  VARCHAR2(255 BYTE),
  TEAM_NAME          VARCHAR2(25 BYTE),
  RECORD_TYPE_ERROR  VARCHAR2(1 BYTE)
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
MONITORING;


DROP PUBLIC SYNONYM SLC_ERRORS;

CREATE PUBLIC SYNONYM SLC_ERRORS FOR SGAS.SLC_ERRORS;


GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  SGAS.SLC_ERRORS TO PUBLIC;                                                                        

