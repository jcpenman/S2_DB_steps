/* EDM_EVENT_AUD.sql
 *
 * Generated from SGAS schema in gv36eda.test2 database using TOAD.
 *
 * All objects into USERS tablespace.
 * Init storage now 100K
 *
 * Modification history: 
 * 30.11.2007 Initial Version   Robert Hunter
 * 09/01/2008 Add synonyms and grants. Steve Durkin
 *
 * Configuration Management: 
 * $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/EDM_EVENT_AUD.sql $ 
 * $Author: $ 
 * $Date: 2011-01-27 14:11:48 +0000 (Thu, 27 Jan 2011) $ 
 * $Revision: 6356 $ 
 */
 
ALTER TABLE SGAS.EDM_EVENT_AUD
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.EDM_EVENT_AUD CASCADE CONSTRAINTS
/

--
-- EDM_EVENT_AUD  (Table) 
--
CREATE TABLE SGAS.EDM_EVENT_AUD
(
  BATCH_ID         NUMBER(16)                   NOT NULL,
  ENVELOPE_ID      NUMBER(4)                    NOT NULL,
  EVENT_AUD_ID     NUMBER(10)                   NOT NULL,
  EVENT_AUD_DATE   DATE                         NOT NULL,
  BATCH_TYPE_CODE  NUMBER(2)                    NOT NULL,
  SCAN_MACHINE_ID  VARCHAR2(50 BYTE)            NOT NULL,
  NUMBER_OF_PAGES  NUMBER(3)
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
            PCTINCREASE      0
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
-- EDM_EVENT_AUD_PK  (Index) 
--
CREATE UNIQUE INDEX EDM_EVENT_AUD_PK ON SGAS.EDM_EVENT_AUD
(ENVELOPE_ID, BATCH_ID)
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
-- EDM_EVENT_AUD_UK01  (Index) 
--
CREATE UNIQUE INDEX EDM_EVENT_AUD_UK01 ON SGAS.EDM_EVENT_AUD
(EVENT_AUD_ID)
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
-- Non Foreign Key Constraints for Table EDM_EVENT_AUD 
-- 
ALTER TABLE SGAS.EDM_EVENT_AUD ADD (
  CONSTRAINT EDM_EVENT_AUD_PK
 PRIMARY KEY
 (ENVELOPE_ID, BATCH_ID)
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

ALTER TABLE SGAS.EDM_EVENT_AUD ADD (
  CONSTRAINT EDM_EVENT_AUD_UK01
 UNIQUE (EVENT_AUD_ID)
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
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM EDM_EVENT_AUD
/

CREATE PUBLIC SYNONYM EDM_EVENT_AUD FOR SGAS.EDM_EVENT_AUD
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON SGAS.EDM_EVENT_AUD
TO EDM_USER
/


DROP SEQUENCE SGAS.EDM_EVENT_AUD_ID_SEQ;

CREATE SEQUENCE SGAS.EDM_EVENT_AUD_ID_SEQ
  START WITH 5000000
  MAXVALUE 999999999999
  MINVALUE 5000000
  NOCYCLE
  NOCACHE
  NOORDER;


DROP PUBLIC SYNONYM EDM_EVENT_AUD_ID_SEQ;

CREATE PUBLIC SYNONYM EDM_EVENT_AUD_ID_SEQ FOR SGAS.EDM_EVENT_AUD_ID_SEQ;


GRANT SELECT ON  SGAS.EDM_EVENT_AUD_ID_SEQ TO PUBLIC;