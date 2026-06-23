/* EDM_EVENT_AUD_ACTION.sql
 *
 * Generated from SGAS schema in gv36eda.test2 database using TOAD.
 *
 * All objects into USERS tablespace.
 * Init storage now 100K
 *
 * Modification history: 
 * 30.11.2007 Initial Version   Robert Hunter
 * 04/01/2007 Add F/K constraint S Durkin.
 *            Add svn keywords to comments for Config mgt info.
 * 09/01/2008 Add synonyms and grants. Steve Durkin
 * 09/09/2008 Move FK definition to TAB_FKS.sql
 * 
 * Configuration Management: 
 * $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/EDM_EVENT_AUD_ACTION.sql $ 
 * $Author: $ 
 * $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $ 
 * $Revision: 3341 $ 
 *
 */
 
ALTER TABLE SGAS.EDM_EVENT_AUD_ACTION
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.EDM_EVENT_AUD_ACTION CASCADE CONSTRAINTS
/

--
-- EDM_EVENT_AUD_ACTION  (Table) 
--
CREATE TABLE SGAS.EDM_EVENT_AUD_ACTION
(
  EVENT_TYPE       NUMBER(2)                    NOT NULL,
  EVENT_USER_NAME  VARCHAR2(15 BYTE)            NOT NULL,
  EVENT_DATE       DATE                         NOT NULL,
  EVENT_AUD_ID     NUMBER(10)                   NOT NULL
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
-- EDM_EVENT_AUD_ACTION_PK  (Index) 
--
CREATE UNIQUE INDEX EDM_EVENT_AUD_ACTION_PK ON SGAS.EDM_EVENT_AUD_ACTION
(EVENT_TYPE, EVENT_USER_NAME, EVENT_DATE, EVENT_AUD_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             512K
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
-- Non Foreign Key Constraints for Table EDM_EVENT_AUD_ACTION 
-- 
ALTER TABLE SGAS.EDM_EVENT_AUD_ACTION ADD (
  CONSTRAINT EDM_EVENT_AUD_ACTION_PK
 PRIMARY KEY
 (EVENT_TYPE, EVENT_USER_NAME, EVENT_DATE, EVENT_AUD_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          500K
                NEXT             512K
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
DROP PUBLIC SYNONYM EDM_EVENT_AUD_ACTION
/

CREATE PUBLIC SYNONYM EDM_EVENT_AUD_ACTION FOR SGAS.EDM_EVENT_AUD_ACTION
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON SGAS.EDM_EVENT_AUD_ACTION
TO EDM_USER
/
