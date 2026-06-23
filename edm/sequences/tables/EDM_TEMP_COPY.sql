-- Create table script.
--
-- MODIFICATION HISTORY
-- Ref.     Date             Author                          Desc.
--          01/05/2008  S Durkin (Sopra UK)     Initial Version
--
-- edm_temp_copy is intended to store data from EDM in the test database. Data from EDM_TEMP will be copied to EDM_TEMP_COPY to give test team members a permanent copy of the data & allow the output of 
-- full edm processing to be duplicated without running the full EDM process. 
-- The table is intended  only for development or test environments.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/edm/tables/EDM_TEMP_COPY.sql $
-- $Author: $
-- $Date: 2008-10-01 14:26:20 +0100 (Wed, 01 Oct 2008) $
-- $Revision: 1237 $

DROP TABLE EDM_TEMP_COPY CASCADE CONSTRAINTS
/

--
-- EDM_TEMP  (Table) 
--
CREATE TABLE EDM_TEMP_COPY
(
  OBJECT_ID             VARCHAR2(44 BYTE),
  SESSION_CODE          NUMBER(4),
  DOCUMENT_TYPE_CODE    VARCHAR2(16 BYTE),
  DOCUMENT_NAME         VARCHAR2(40 BYTE),
  DOCUMENT_TYPE_COUNT   NUMBER(3),
  ATTACHMENT_TYPE_CODE  VARCHAR2(10 BYTE),
  RESCAN_REQUEST_ID     NUMBER(10)
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
-- Administer grants - grant everything to public....
-- 
GRANT ALTER ON EDM_TEMP_COPY TO PUBLIC
/

GRANT DEBUG ON EDM_TEMP_COPY TO PUBLIC
/

GRANT QUERY REWRITE ON EDM_TEMP_COPY TO PUBLIC
/

GRANT ON COMMIT REFRESH ON EDM_TEMP_COPY TO PUBLIC
/

GRANT DELETE ON EDM_TEMP_COPY TO PUBLIC
/

GRANT UPDATE ON EDM_TEMP_COPY TO PUBLIC
/

GRANT SELECT ON EDM_TEMP_COPY TO PUBLIC
/

GRANT INSERT ON EDM_TEMP_COPY TO PUBLIC
/

GRANT INDEX ON EDM_TEMP_COPY TO PUBLIC
/

GRANT REFERENCES ON EDM_TEMP_COPY TO PUBLIC
/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM EDM_TEMP_COPY
/

CREATE PUBLIC SYNONYM EDM_TEMP_COPY FOR EDM.EDM_TEMP_COPY
/
