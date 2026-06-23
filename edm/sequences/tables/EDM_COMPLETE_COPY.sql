-- Create table script.
--
-- MODIFICATION HISTORY
-- Ref.     Date            Author                          Desc.
--          08/01/2008  S Durkin (Sopra UK)     Initial Version
--
-- EDM_COMPLETE_COPY is intended to store data from EDM in the test database. Data from EDM_COMPLETE will be copied to EDM_COMPLETE_COPY to give test team members a permanent copy of the data & allow the output of 
-- full edm processing to be duplicated without running the full EDM process. 
-- The table is intended  only for development or test environments.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/edm/tables/EDM_COMPLETE_COPY.sql $ 
-- $Author: $ 
-- $Date: 2008-10-01 14:26:20 +0100 (Wed, 01 Oct 2008) $ 
-- $Revision: 1237 $ 

DROP TABLE EDM_COMPLETE_COPY CASCADE CONSTRAINTS
/

-- 
-- EDM_COMPLETE  (Table) 
-- 
CREATE TABLE EDM_COMPLETE_COPY
(
  OBJECT_ID        VARCHAR2(44 BYTE),
  RAW_DATA_ID      NUMBER(10),
  BATCH_TYPE_CODE  NUMBER(2),
  STUD_REF_NO      NUMBER(10),
  BATCH_ID         NUMBER(16),
  ENVELOPE_ID      NUMBER(4),
  SCAN_DATE        DATE,
  PROC_ERROR       VARCHAR2(1 BYTE)             DEFAULT 'N'                   NOT NULL,
  URGENT           VARCHAR2(1 BYTE)             DEFAULT 'N'                   NOT NULL
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
-- Non Foreign Key Constraints for Table EDM_COMPLETE 
-- 
ALTER TABLE EDM_COMPLETE_COPY ADD (
  CONSTRAINT EDM_COMPLETE_CC01
 CHECK (proc_error in ('Y', 'N')))
/

ALTER TABLE EDM_COMPLETE_COPY ADD (
  CONSTRAINT EDM_COMPLETE_CC02
 CHECK (urgent in ('Y', 'N')))
/

--
-- Administer grants
-- 
GRANT DEBUG ON EDM_COMPLETE_COPY TO PUBLIC
/

GRANT QUERY REWRITE ON EDM_COMPLETE_COPY TO PUBLIC
/

GRANT ON COMMIT REFRESH ON EDM_COMPLETE_COPY TO PUBLIC
/

GRANT REFERENCES ON EDM_COMPLETE_COPY TO PUBLIC
/

GRANT UPDATE ON EDM_COMPLETE_COPY TO PUBLIC
/

GRANT SELECT ON EDM_COMPLETE_COPY TO PUBLIC
/

GRANT INSERT ON EDM_COMPLETE_COPY TO PUBLIC
/

GRANT INDEX ON EDM_COMPLETE_COPY TO PUBLIC
/

GRANT DELETE ON EDM_COMPLETE_COPY TO PUBLIC
/

GRANT ALTER ON EDM_COMPLETE_COPY TO PUBLIC
/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM EDM_COMPLETE_COPY
/

CREATE PUBLIC SYNONYM EDM_COMPLETE_COPY FOR EDM.EDM_COMPLETE_COPY
/
