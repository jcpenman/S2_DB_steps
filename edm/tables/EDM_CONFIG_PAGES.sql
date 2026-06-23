-- Table create script for EDM_CONFIG_PAGES. 
--
-- Run this script as EDM user from SQL.  
--
-- Configuration Management: 
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/edm/tables/EDM_CONFIG_PAGES.sql $ 
-- $Author: $ 
-- $Date: 2010-01-19 09:45:47 +0000 (Tue, 19 Jan 2010) $ 
-- $Revision: 4600 $ 

ALTER TABLE EDM.EDM_CONFIG_PAGES
 DROP PRIMARY KEY CASCADE
/
DROP TABLE EDM.EDM_CONFIG_PAGES CASCADE CONSTRAINTS
/

--
-- EDM_CONFIG_PAGES  (Table) 
--
CREATE TABLE EDM.EDM_CONFIG_PAGES
(
  BATCH_TYPE_CODE  NUMBER(2)                    NOT NULL,
  PAGE_NO          NUMBER(2)                    NOT NULL,
  MANDATORY        VARCHAR2(1 BYTE)             NOT NULL
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
-- ECP_PK  (Index) 
--
CREATE UNIQUE INDEX ECP_PK ON EDM.EDM_CONFIG_PAGES
(BATCH_TYPE_CODE, PAGE_NO)
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
-- Non Foreign Key Constraints for Table EDM_CONFIG_PAGES 
-- 
ALTER TABLE EDM.EDM_CONFIG_PAGES ADD (
  CONSTRAINT ECP_MANDATORY
 CHECK (mandatory in ('Y','N')))
/

ALTER TABLE EDM.EDM_CONFIG_PAGES ADD (
  CONSTRAINT ECP_PK
 PRIMARY KEY
 (BATCH_TYPE_CODE, PAGE_NO)
    USING INDEX 
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
               ))
/


--
-- Administer grants
-- 
GRANT SELECT ON EDM.EDM_CONFIG_PAGES TO PUBLIC
/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM EDM_CONFIG_PAGES
/

CREATE PUBLIC SYNONYM EDM_CONFIG_PAGES FOR EDM.EDM_CONFIG_PAGES
/
