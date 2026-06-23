-- Create table script.
--
-- MODIFICATION HISTORY
-- Ref.     Date            Author                          Desc.
--          08/01/2008  S Durkin (Sopra UK)     Initial Version
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/edm/tables/EDM_AUD_TEMP.sql $
-- $Author: $
-- $Date: 2010-01-19 09:45:47 +0000 (Tue, 19 Jan 2010) $
-- $Revision: 4600 $

DROP TABLE EDM.EDM_AUD_TEMP CASCADE CONSTRAINTS
/

--
-- EDM_AUD_TEMP  (Table) 
--
CREATE TABLE EDM.EDM_AUD_TEMP
(
  RAW_DATA_ID      NUMBER(10)                   NOT NULL,
  OBJECT_ID        VARCHAR2(44 BYTE),
  AUD_DATE         DATE                         NOT NULL,
  BATCH_TYPE_CODE  NUMBER(2)                    NOT NULL,
  FIELD_NAME       VARCHAR2(50 BYTE)            NOT NULL,
  EMP_LOGIN_NAME   VARCHAR2(15 BYTE)            NOT NULL,
  OLD              VARCHAR2(400 BYTE),
  ACTION           VARCHAR2(1 BYTE)             NOT NULL,
  NEW              VARCHAR2(400 BYTE),
  STUD_REF_NO      NUMBER(10),
  SESSION_CODE     NUMBER(4)                    NOT NULL
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
-- S1_EAT  (Index) 
--
CREATE INDEX S1_EAT ON EDM.EDM_AUD_TEMP
(RAW_DATA_ID)
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
-- Administer grants
-- 
GRANT ALTER ON EDM.EDM_AUD_TEMP TO PUBLIC
/
GRANT DELETE ON EDM.EDM_AUD_TEMP TO PUBLIC
/
GRANT INDEX ON EDM.EDM_AUD_TEMP TO PUBLIC
/
GRANT INSERT ON EDM.EDM_AUD_TEMP TO PUBLIC
/
GRANT SELECT ON EDM.EDM_AUD_TEMP TO PUBLIC
/
GRANT UPDATE ON EDM.EDM_AUD_TEMP TO PUBLIC
/
GRANT REFERENCES ON EDM.EDM_AUD_TEMP TO PUBLIC
/
GRANT ON COMMIT REFRESH ON EDM.EDM_AUD_TEMP TO PUBLIC
/
GRANT QUERY REWRITE ON EDM.EDM_AUD_TEMP TO PUBLIC
/
GRANT DEBUG ON EDM.EDM_AUD_TEMP TO PUBLIC
/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM EDM_AUD_TEMP
/

CREATE PUBLIC SYNONYM EDM_AUD_TEMP FOR EDM.EDM_AUD_TEMP
/
