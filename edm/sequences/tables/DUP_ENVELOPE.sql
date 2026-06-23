-- Create table script.
--
-- MODIFICATION HISTORY
-- Ref.     Date            Author                          Desc.
--          08/01/2008  S Durkin (Sopra UK)     Initial Version
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/edm/tables/DUP_ENVELOPE.sql $
-- $Author: $
-- $Date: 2010-01-19 09:45:47 +0000 (Tue, 19 Jan 2010) $
-- $Revision: 4600 $

ALTER TABLE EDM.DUP_ENVELOPE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE EDM.DUP_ENVELOPE CASCADE CONSTRAINTS
/

--
-- DUP_ENVELOPE  (Table) 
--
CREATE TABLE EDM.DUP_ENVELOPE
(
  DE_ID     NUMBER(10)                          NOT NULL,
  DE_DATE   DATE                                NOT NULL,
  DE_COUNT  NUMBER(10)                          NOT NULL,
  DE_TEXT   VARCHAR2(256 BYTE)                  NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             120K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
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
-- P_DE_ID  (Index) 
--
CREATE UNIQUE INDEX P_DE_ID ON EDM.DUP_ENVELOPE
(DE_ID)
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
-- Non Foreign Key Constraints for Table DUP_ENVELOPE 
-- 
ALTER TABLE EDM.DUP_ENVELOPE ADD (
  CONSTRAINT P_DE_ID
 PRIMARY KEY
 (DE_ID)
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
GRANT SELECT ON EDM.DUP_ENVELOPE TO PUBLIC
/
GRANT INSERT ON EDM.DUP_ENVELOPE TO PUBLIC
/
GRANT DELETE ON EDM.DUP_ENVELOPE TO PUBLIC
/
GRANT UPDATE ON EDM.DUP_ENVELOPE TO PUBLIC
/

