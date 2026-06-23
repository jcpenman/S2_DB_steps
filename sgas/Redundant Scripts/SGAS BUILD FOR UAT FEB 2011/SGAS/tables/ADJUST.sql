-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/ADJUST.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $

ALTER TABLE SGAS.ADJUST
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.ADJUST CASCADE CONSTRAINTS
/

--
-- ADJUST  (Table) 
--
CREATE TABLE SGAS.ADJUST
(
  STUD_CRSE_YEAR_ID  NUMBER(9) CONSTRAINT NN_AD_STUD_CRSE_YEAR_ID NOT NULL,
  STUD_REF_NO        NUMBER(10) CONSTRAINT NN_AD_STUD_REF_NO NOT NULL,
  ADJUST_DATE        DATE CONSTRAINT NN_AD_ADJUST_DATE NOT NULL,
  TYPE               VARCHAR2(1 BYTE) CONSTRAINT NN_AD_TYPE NOT NULL,
  SOURCE             VARCHAR2(1 BYTE) CONSTRAINT NN_AD_SOURCE NOT NULL,
  AMOUNT             NUMBER(9,2) CONSTRAINT NN_AD_AMOUNT NOT NULL,
  REASON             VARCHAR2(1 BYTE) CONSTRAINT NN_AD_REASON NOT NULL,
  BUDGET             VARCHAR2(1 BYTE) CONSTRAINT NN_AD_BUDGET NOT NULL,
  CAMPUS_ID          NUMBER(9),
  last_updated_by  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_AD_LAST_UPDATED_BY NOT NULL,
  last_updated_on  DATE DEFAULT Sysdate CONSTRAINT NN_AD_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
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
-- S2_AD  (Index) 
--
CREATE INDEX S2_AD ON SGAS.ADJUST
(STUD_REF_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             100K
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
-- S1_AD  (Index) 
--
CREATE INDEX S1_AD ON SGAS.ADJUST
(ADJUST_DATE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             200K
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
-- P_AD  (Index) 
--
CREATE UNIQUE INDEX P_AD ON SGAS.ADJUST
(STUD_CRSE_YEAR_ID, ADJUST_DATE, TYPE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             100K
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
-- Non Foreign Key Constraints for Table ADJUST 
-- 
ALTER TABLE SGAS.ADJUST ADD (
  CONSTRAINT AD_TYPE
 CHECK (TYPE IN('D','R','A','I','M')))
/

ALTER TABLE SGAS.ADJUST ADD (
  CONSTRAINT AD_SOURCE
 CHECK ( SOURCE IN('I','S')))
/

ALTER TABLE SGAS.ADJUST ADD (
  CONSTRAINT AD_BUDGET
 CHECK ( BUDGET IN('S','O')))
/

ALTER TABLE SGAS.ADJUST ADD (
  CONSTRAINT P_AD
 PRIMARY KEY
 (STUD_CRSE_YEAR_ID, ADJUST_DATE, TYPE)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          200K
                NEXT             100K
                MINEXTENTS       1
                MAXEXTENTS       99
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ))
/
