-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/LABEL_PRINT.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $


ALTER TABLE SGAS.LABEL_PRINT
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.LABEL_PRINT CASCADE CONSTRAINTS
/

--
-- LABEL_PRINT  (Table) 
--
CREATE TABLE SGAS.LABEL_PRINT
(
  STUD_REF_NO     NUMBER(10)                    NOT NULL,
  DATE_CREATED    DATE                          NOT NULL,
  EMP_LOGIN_NAME  VARCHAR2(15 BYTE)             NOT NULL,
  PRINT           VARCHAR2(1 BYTE),
  GENERATED       VARCHAR2(1 BYTE),
  CATEGORY        NUMBER(1),
  TEAM_ID         NUMBER(3),
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_LP_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_LP_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
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
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/


--
-- P_LP  (Index) 
--
CREATE UNIQUE INDEX P_LP ON SGAS.LABEL_PRINT
(STUD_REF_NO, DATE_CREATED, EMP_LOGIN_NAME)
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
-- Non Foreign Key Constraints for Table LABEL_PRINT 
-- 
ALTER TABLE SGAS.LABEL_PRINT ADD (
  CONSTRAINT LP_CATEGORY
 CHECK (CATEGORY IN(1,2,3)))
/

ALTER TABLE SGAS.LABEL_PRINT ADD (
  CONSTRAINT LP_GENERATED
 CHECK (GENERATED IN('Y','N')))
/

ALTER TABLE SGAS.LABEL_PRINT ADD (
  CONSTRAINT LP_PRINT
 CHECK (PRINT IN('Y','N')))
/

ALTER TABLE SGAS.LABEL_PRINT ADD (
  CONSTRAINT P_LP
 PRIMARY KEY
 (STUD_REF_NO, DATE_CREATED, EMP_LOGIN_NAME)
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
