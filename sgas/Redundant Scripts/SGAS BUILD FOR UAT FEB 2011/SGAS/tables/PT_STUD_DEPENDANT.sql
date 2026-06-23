-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            28.02.08   S Durkin (Sopra UK)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/PT_STUD_DEPENDANT.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $


DROP TABLE SGAS.PT_STUD_DEPENDANT CASCADE CONSTRAINTS
/

--
-- PT_STUD_DEPENDANT  (Table) 
--
CREATE TABLE SGAS.PT_STUD_DEPENDANT
(
  PT_STUD_DEP_ID    NUMBER(10)                  NOT NULL,
  STUD_SESSION_ID   NUMBER(9)                   NOT NULL,
  STUD_REF_NO       NUMBER(10)                  NOT NULL,
  SESSION_CODE      NUMBER(4)                   NOT NULL,
  DOB               DATE,
  DEPENDANT_TYPE    VARCHAR2(1 BYTE)            DEFAULT 'C'                   NOT NULL,
  RELATION_TYPE_ID  NUMBER(4)                   NOT NULL,
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_PSTD_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_PSTD_LAST_UPDATED_ON NOT NULL
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
-- P_PTSD  (Index) 
--
CREATE UNIQUE INDEX P_PTSD ON SGAS.PT_STUD_DEPENDANT
(PT_STUD_DEP_ID)
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
-- S1_PTSD  (Index) 
--
CREATE INDEX S1_PTSD ON SGAS.PT_STUD_DEPENDANT
(STUD_REF_NO)
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
-- Non Foreign Key Constraints for Table PT_STUD_DEPENDANT 
-- 
ALTER TABLE SGAS.PT_STUD_DEPENDANT ADD (
  CONSTRAINT PTSD_DEPENDANT_TYPE
 CHECK (DEPENDANT_TYPE IN('C','A')))
/
