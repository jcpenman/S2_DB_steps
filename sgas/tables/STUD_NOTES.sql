-- Create STUD_NOTES table.
--
-- Modification History
-- Date               Author    Ref    Desc
-- ??-??-????         S Durkin  0.1    Initial Creation
-- 31-07-2009         R Hunter  0.2    Amended for UI. ID column should be 
--                                     a proper Primary Key, wasn't in GRASS
-- 30.04.2010         A.Bowman  0.3    Added foreign key reference
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STUD_NOTES.sql $
-- $Author: $
-- $Date: 2011-01-18 16:03:26 +0000 (Tue, 18 Jan 2011) $
-- $Revision: 6309 $


ALTER TABLE sgas.stud_notes
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.stud_notes  CASCADE CONSTRAINTS
/
--
-- STUD_NOTES  (Table)
--
CREATE TABLE sgas.stud_notes
    (ID             NUMBER(10,0)        NOT NULL ENABLE,
     stud_ref_no    NUMBER(10,0)        NOT NULL ENABLE,
     notes_date     DATE                NOT NULL ENABLE,
     session_code   NUMBER(4,0)         NOT NULL ENABLE,
     emp_login_name VARCHAR2(15 BYTE)   NOT NULL ENABLE,
     notes_type     VARCHAR2(14 BYTE)   NOT NULL ENABLE,
     notes_text     VARCHAR2(300 BYTE)  NOT NULL ENABLE,
     last_updated_by  VARCHAR2(15 BYTE) DEFAULT USER CONSTRAINT nn_stn_last_updated_by NOT NULL,
     last_updated_on  DATE DEFAULT SYSDATE CONSTRAINT nn_stn_last_updated_on NOT NULL
    )
TABLESPACE users
PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
STORAGE (
        INITIAL 65536
        NEXT 1048576
        MINEXTENTS 1
        MAXEXTENTS 2147483645
        PCTINCREASE 0
        FREELISTS 1
        FREELIST GROUPS 1
        BUFFER_POOL DEFAULT
        )
NOPARALLEL
/
CREATE UNIQUE INDEX stud_notes_pk ON sgas.stud_notes
(ID)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE sgas.stud_notes ADD (
  CONSTRAINT stud_notes_pk
 PRIMARY KEY
 (ID)
    USING INDEX
    TABLESPACE users
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64 k
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));



--
-- S1_STN  (Index) 
--
--  Dependencies: 
--   STUD_NOTES (Table)
--
CREATE INDEX s1_stn ON sgas.stud_notes
(stud_ref_no)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500 k
            NEXT             500 k
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

ALTER TABLE SGAS.STUD_NOTES ADD (
  CONSTRAINT F1_STNS
 FOREIGN KEY (STUD_REF_NO) 
 REFERENCES SGAS.STUD (STUD_REF_NO));



DROP PUBLIC SYNONYM stud_notes
/
--
-- STUD_NOTES  (Synonym) 
--
--  Dependencies: 
--   STUD_NOTES (Table)
--
CREATE PUBLIC SYNONYM stud_notes FOR sgas.stud_notes
/
DROP SEQUENCE sgas.std_notes_id_seq
/
--
-- STUD_NOTES_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.std_notes_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/

COMMIT ;