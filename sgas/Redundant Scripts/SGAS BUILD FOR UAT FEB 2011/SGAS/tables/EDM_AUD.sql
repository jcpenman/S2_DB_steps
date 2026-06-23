/* EDM_AUD.sql
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
 * 
 * Configuration Management: 
 * $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/EDM_AUD.sql $ 
 * $Author: $ 
 * $Date: 2011-01-27 14:11:48 +0000 (Thu, 27 Jan 2011) $ 
 * $Revision: 6356 $ 
 */
 
ALTER TABLE SGAS.EDM_AUD
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.EDM_AUD CASCADE CONSTRAINTS PURGE
/

--
-- EDM_AUD  (Table) 
--
CREATE TABLE SGAS.EDM_AUD
(
  AUD_ID           NUMBER(10)                   NOT NULL,
  AUD_DATE         DATE                         NOT NULL,
  BATCH_TYPE_CODE  NUMBER(2)                    NOT NULL,
  FIELD_NAME       VARCHAR2(50 BYTE)            NOT NULL,
  EMP_LOGIN_NAME   VARCHAR2(15 BYTE)            NOT NULL,
  OLD              VARCHAR2(400 BYTE),
  ACTION           VARCHAR2(1 BYTE)             NOT NULL,
  NEW              VARCHAR2(400 BYTE),
  STUD_REF_NO      NUMBER(10)                   NOT NULL,
  SESSION_CODE     NUMBER(4)                    NOT NULL
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
-- EDM_AUD_PK  (Index) 
--
CREATE UNIQUE INDEX EDM_AUD_PK ON SGAS.EDM_AUD
(AUD_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             506K
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
-- EDM_AUD_IDX01  (Index) 
--
CREATE INDEX EDM_AUD_IDX01 ON SGAS.EDM_AUD
(STUD_REF_NO)
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
-- EDM_AUD_IDX02  (Index) 
--
CREATE INDEX EDM_AUD_IDX02 ON SGAS.EDM_AUD
(AUD_DATE)
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
-- EDM_AUD_IDX03  (Index) 
--
CREATE INDEX EDM_AUD_IDX03 ON SGAS.EDM_AUD
(EMP_LOGIN_NAME)
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
-- Non Foreign Key Constraints for Table EDM_AUD 
-- 
ALTER TABLE SGAS.EDM_AUD ADD (
  CONSTRAINT EDM_AUD_CC01
 CHECK (action in ('A', 'B')))
/

ALTER TABLE SGAS.EDM_AUD ADD (
  CONSTRAINT EDM_AUD_PK
 PRIMARY KEY
 (AUD_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          500K
                NEXT             506K
                MINEXTENTS       1
                MAXEXTENTS       99
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ))
/


-- 
-- SD: Add foriegn key constraint to STUD 
-- 
ALTER TABLE SGAS.EDM_AUD ADD (
  CONSTRAINT EDM_AUD_STUD_FK 
 FOREIGN KEY (STUD_REF_NO) 
 REFERENCES STUD (STUD_REF_NO) DISABLE);


-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM EDM_AUD
/

CREATE PUBLIC SYNONYM EDM_AUD FOR SGAS.EDM_AUD
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON SGAS.EDM_AUD
TO EDM_USER
/


DROP SEQUENCE SGAS.EDM_AUD_ID_SEQ;

CREATE SEQUENCE SGAS.EDM_AUD_ID_SEQ
  START WITH 7000000
  MAXVALUE 999999999999
  MINVALUE 7000000
  NOCYCLE
  NOCACHE
  NOORDER;


DROP PUBLIC SYNONYM EDM_AUD_ID_SEQ;

CREATE PUBLIC SYNONYM EDM_AUD_ID_SEQ FOR SGAS.EDM_AUD_ID_SEQ;


GRANT SELECT ON  SGAS.EDM_AUD_ID_SEQ TO PUBLIC;
