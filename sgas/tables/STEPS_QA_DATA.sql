-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STEPS_QA_DATA.sql $
-- $Author: $
-- $Date: 2010-12-21 14:42:40 +0000 (Tue, 21 Dec 2010) $
-- $Revision: 6206 $


-- MODIFICATION HISTORY:
-- Ref      Date        Author                      Desc.
-- 001      22.06.09    A.Bowman (SAAS)             Added audit triggers.
-- 002      28.01.10    A.Bowman (SAAS)             Amended audit triggers
-- 003      11.02.10    A.Bowman (SAAS)             Added data insert 
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STEPS_QA_DATA.sql $
-- $Author: $
-- $Date: 2010-12-21 14:42:40 +0000 (Tue, 21 Dec 2010) $
-- $Revision: 6206 $


ALTER TABLE SGAS.STEPS_QA_DATA
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.STEPS_QA_DATA CASCADE CONSTRAINTS
/
--
-- STEPS_QA_DATA (Table) 
--
CREATE TABLE SGAS.STEPS_QA_DATA
(
  USERNAME         VARCHAR2(15 BYTE) CONSTRAINT NN_SQD_USER_ID NOT NULL,
  QA_TYPE          VARCHAR2(1)         CONSTRAINT NN_SQD_TOTAL NOT NULL,
  QA_LEVEL         NUMBER(3) DEFAULT 100,
  NO_PROCESSED     NUMBER(7) DEFAULT 0,
  NO_QA            NUMBER(7) DEFAULT 1, 
  NO_FAIL_QA       NUMBER(7) DEFAULT 0,
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_SQD_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE Default Sysdate CONSTRAINT NN_SQD_LAST_UPDATED_ON NOT NULL 
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
-- P_CO  (Index)
--
CREATE UNIQUE INDEX P_SQD ON SGAS.STEPS_QA_DATA
(USERNAME)
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

CREATE OR REPLACE TRIGGER SGAS.sqd_iud
   AFTER INSERT OR DELETE OR UPDATE OF qa_type, qa_level, last_updated_by
   ON SGAS.STEPS_QA_DATA    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    steps_qa_data_aud.column_name%TYPE    := NULL;
   p_table_pkey1    steps_qa_data_aud.table_pkey1%TYPE
                                                   := TO_CHAR (:OLD.username);
   p_table_pkey2    steps_qa_data_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    steps_qa_data_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    steps_qa_data_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    steps_qa_data_aud.table_pkey5%TYPE    := NULL;
   p_old            steps_qa_data_aud.OLD%TYPE            := NULL;
   p_new            steps_qa_data_aud.NEW%TYPE            := NULL;
   p_action         steps_qa_data_aud.action%TYPE         := NULL;
   p_username       steps_qa_data_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    steps_qa_data_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      steps_qa_data_aud.inst_code%TYPE      := NULL;
   p_session_code   steps_qa_data_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.username;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.username;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'QA_TYPE';
   p_old := TO_CHAR (:OLD.qa_type);
   p_new := TO_CHAR (:NEW.qa_type);
   pk_steps_aud.ins_sqd_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'QA_LEVEL';
   p_old := TO_CHAR (:OLD.qa_level);
   p_new := TO_CHAR (:NEW.qa_level);
   pk_steps_aud.ins_sqd_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_sqd_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
END sqd_iud;

SHOW ERRORS;


ALTER TABLE SGAS.STEPS_QA_DATA ADD (
  CONSTRAINT P_SQDA
 PRIMARY KEY
 (USERNAME,qa_type)
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

---
--- Insert Data
---

Insert into SGAS.STEPS_QA_DATA
   (USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, 
    NO_FAIL_QA, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   ('SYSTEM', 'U', 0, 0, 0, 
    0, 'SGAS', TO_DATE(sysdate));
commit;