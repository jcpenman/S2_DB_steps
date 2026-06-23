-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                      Desc.
-- 001      28.02.08    S Durkin (Sopra UK)         Initial Version.
-- 002      05.05.10    A.Bowman (SAAS)             Added foreign key references
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STUD_TRACK.sql $
-- $Author: $
-- $Date: 2010-05-06 08:55:04 +0100 (Thu, 06 May 2010) $
-- $Revision: 5236 $


ALTER TABLE SGAS.STUD_TRACK
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.STUD_TRACK CASCADE CONSTRAINTS
/

--
-- STUD_TRACK  (Table) 
--
CREATE TABLE SGAS.STUD_TRACK
(
  STUD_REF_NO       NUMBER(10)                  NOT NULL,
  DATE_MOVED        DATE                        NOT NULL,
  EMP_LOGIN_NAME    VARCHAR2(15 BYTE)           NOT NULL,
  DEPT_CODE         VARCHAR2(5 BYTE),
  LOC_CODE          VARCHAR2(5 BYTE),
  FILE_STATUS_CODE  VARCHAR2(5 BYTE),
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_STK_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_STK_LAST_UPDATED_ON NOT NULL
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
-- P_STK  (Index) 
--
CREATE UNIQUE INDEX P_STK ON SGAS.STUD_TRACK
(STUD_REF_NO, DATE_MOVED)
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
-- Non Foreign Key Constraints for Table STUD_TRACK 
-- 
ALTER TABLE SGAS.STUD_TRACK ADD (
  CONSTRAINT P_STK
 PRIMARY KEY
 (STUD_REF_NO, DATE_MOVED)
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

ALTER TABLE SGAS.STUD_TRACK ADD (
  CONSTRAINT F1_STT
 FOREIGN KEY (STUD_REF_NO) 
 REFERENCES SGAS.STUD (STUD_REF_NO));
