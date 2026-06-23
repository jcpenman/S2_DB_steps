/* EDM_APP_LABELS.sql
 *
 * Generated from SGAS schema in gv36eda.test2 database using TOAD.
 *
 * All objects into USERS tablespace.
 *
 * Modification history: 
 * 30.11.2007 Initial Version   Robert Hunter
 *
 */
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/EDM_APP_LABELS.sql $
-- $Author: $
-- $Date: 2010-10-22 10:24:20 +0100 (Fri, 22 Oct 2010) $
-- $Revision: 5821 $
--
ALTER TABLE SGAS.EDM_APP_LABELS
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.EDM_APP_LABELS CASCADE CONSTRAINTS PURGE
/

--
-- EDM_APP_LABELS  (Table) 
--
CREATE TABLE SGAS.EDM_APP_LABELS
(
  EDM_APP_BATCH_ID        NUMBER(16)            NOT NULL,
  APP_BATCH_PRINTED_DATE  DATE,
  BATCH_ID_PRINTED        VARCHAR2(1 BYTE)      DEFAULT 'N'
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
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
-- P_BATCH_PK  (Index) 
--
CREATE UNIQUE INDEX P_BATCH_PK ON SGAS.EDM_APP_LABELS
(EDM_APP_BATCH_ID)
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
-- APP_BATCH_ID_PRINTED  (Index) 
--
CREATE INDEX APP_BATCH_ID_PRINTED ON SGAS.EDM_APP_LABELS
(EDM_APP_BATCH_ID, BATCH_ID_PRINTED)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          502K
            NEXT             502K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

-- 
-- Non Foreign Key Constraints for Table EDM_APP_LABELS 
-- 
ALTER TABLE SGAS.EDM_APP_LABELS ADD (
  CHECK (batch_id_printed IN ('N', 'Y')))
/

ALTER TABLE SGAS.EDM_APP_LABELS ADD (
  CONSTRAINT P_BATCH_PK
 PRIMARY KEY
 (EDM_APP_BATCH_ID)
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
GRANT SELECT ON SGAS.EDM_APP_LABELS TO PUBLIC
/
GRANT DELETE ON SGAS.EDM_APP_LABELS TO PUBLIC
/
GRANT UPDATE ON SGAS.EDM_APP_LABELS TO PUBLIC
/
GRANT INSERT ON SGAS.EDM_APP_LABELS TO PUBLIC
/
