-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            12.02.08   S Durkin (Sopra UK)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/CORRES.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $


ALTER TABLE SGAS.CORRES
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.CORRES CASCADE CONSTRAINTS
/

--
-- CORRES  (Table) 
--
CREATE TABLE SGAS.CORRES
(
  CORRES_ID      NUMBER(8) CONSTRAINT NN_CO_CORRES_ID NOT NULL,
  IO_TYPE        VARCHAR2(1 BYTE) CONSTRAINT NN_CO_IO_TYPE NOT NULL,
  CORR_TYPE      VARCHAR2(1 BYTE) CONSTRAINT NN_CO_CORR_TYPE NOT NULL,
  CORR_SUB_TYPE  VARCHAR2(1 BYTE)               DEFAULT 'Q',
  CORRES_NAME    VARCHAR2(25 BYTE),
  START_DATE     DATE CONSTRAINT NN_CO_START_DATE NOT NULL,
  END_DATE       DATE,
  STUD_REF_NO    NUMBER(10),
  NOTES          VARCHAR2(400 BYTE),
  last_updated_by  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_CO_LAST_UPDATED_BY NOT NULL,
  last_updated_on  DATE DEFAULT Sysdate CONSTRAINT NN_CO_LAST_UPDATED_ON NOT NULL
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
-- S2_CO  (Index) 
--
CREATE INDEX S2_CO ON SGAS.CORRES
(START_DATE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
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
NOPARALLEL
/


--
-- S1_CO  (Index) 
--
CREATE INDEX S1_CO ON SGAS.CORRES
(STUD_REF_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
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
NOPARALLEL
/


--
-- P_CO  (Index) 
--
CREATE UNIQUE INDEX P_CO ON SGAS.CORRES
(CORRES_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
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
NOPARALLEL
/


-- 
-- Non Foreign Key Constraints for Table CORRES 
-- 
ALTER TABLE SGAS.CORRES ADD (
  CONSTRAINT CO_CORR_TYPE
 CHECK (corr_type IN('W','G','T','A','P')))
/

ALTER TABLE SGAS.CORRES ADD (
  CONSTRAINT CO_CORR_SUB_TYPE
 CHECK ( CORR_SUB_TYPE IN('A','C','P','Q')))
/

ALTER TABLE SGAS.CORRES ADD (
  CONSTRAINT CO_IO_TYPE
 CHECK ( IO_TYPE IN('I','O')))
/

ALTER TABLE SGAS.CORRES ADD (
  CONSTRAINT P_CO
 PRIMARY KEY
 (CORRES_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100K
                NEXT             100K
                MINEXTENTS       1
                MAXEXTENTS       99
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ))
/
