/* Formatted on 2009/05/29 10:45 (Formatter Plus v4.8.8) */
-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                      Desc.
-- 001      28.02.08    S Durkin (Sopra UK)         Initial Version.
-- 002      29.05.09    R Hunter (SAAS)             Populate primary key automatically using a trigger 
--                                                   and set up sequence here.
-- 003      22.06.09    A.Bowman (SAAS)             Added audit triggers.
-- 004      02.09.09    A.Bowman (SAAS)             Removed columns case_holder,first_name and last_name as these are no longer req'd 
-- 005      28.01.10    A.Bowman (SAAS)             Amended audit triggers 
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/JA_CASE.sql $
-- $Author: $
-- $Date: 2011-01-25 15:22:41 +0000 (Tue, 25 Jan 2011) $
-- $Revision: 6338 $


ALTER TABLE SGAS.ja_case
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.ja_case CASCADE CONSTRAINTS
/
--
-- JA_CASE  (Table) 
--
CREATE TABLE SGAS.ja_case
(
  ja_case_id            NUMBER(6) CONSTRAINT nn_jac_ja_case_id NOT NULL,
  session_code          NUMBER(4) CONSTRAINT nn_jac_session_code NOT NULL,
  ja_case_type          VARCHAR2(1 BYTE)        DEFAULT 'S' CONSTRAINT nn_jac_ja_case_type NOT NULL,
  no_saas_students      NUMBER(2) CONSTRAINT nn_jac_no_saas_students NOT NULL,
  no_non_saas_children  NUMBER(2) CONSTRAINT nn_jac_no_non_saas_children NOT NULL,
  no_non_saas_parents   NUMBER(1) CONSTRAINT nn_jac_no_non_saas_parents NOT NULL,
  all_registered        VARCHAR2(1 BYTE)        DEFAULT 'N' CONSTRAINT nn_jac_all_registered NOT NULL,
  parent_sma            NUMBER(9,2),
  last_updated_by       VARCHAR2(15 BYTE) DEFAULT USER CONSTRAINT nn_jac_last_updated_by NOT NULL,
  last_updated_on       DATE DEFAULT SYSDATE CONSTRAINT nn_jac_last_updated_on NOT NULL
)
TABLESPACE users
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100 k
            NEXT             100 k
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
-- P_JAC  (Index) 
--
CREATE UNIQUE INDEX p_jac ON SGAS.ja_case
(ja_case_id)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100 k
            NEXT             100 k
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

CREATE OR REPLACE TRIGGER SGAS.jac_iud
   AFTER INSERT OR DELETE OR UPDATE OF all_registered,
                                       ja_case_type,
                                       no_saas_students,
                                       no_non_saas_children,
                                       no_non_saas_parents,
                                       last_updated_by
   ON SGAS.JA_CASE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                            := SYSDATE;
   p_column_name    ja_case_aud.column_name%TYPE    := NULL;
   p_table_pkey1    ja_case_aud.table_pkey1%TYPE    := :OLD.ja_case_id;
   p_table_pkey2    ja_case_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    ja_case_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    ja_case_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    ja_case_aud.table_pkey5%TYPE    := NULL;
   p_old            ja_case_aud.OLD%TYPE            := NULL;
   p_new            ja_case_aud.NEW%TYPE            := NULL;
   p_action         ja_case_aud.action%TYPE         := NULL;
   p_username       ja_case_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    ja_case_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      ja_case_aud.inst_code%TYPE      := NULL;
   p_session_code   ja_case_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.ja_case_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.ja_case_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'ALL_REGISTERED';
   p_old := TO_CHAR (:OLD.all_registered);
   p_new := TO_CHAR (:NEW.all_registered);
   pk_steps_aud.ins_jac_aud (p_aud_date,
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
   p_column_name := 'JA_CASE_TYPE';
   p_old := TO_CHAR (:OLD.ja_case_type);
   p_new := TO_CHAR (:NEW.ja_case_type);
   pk_steps_aud.ins_jac_aud (p_aud_date,
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
   p_column_name := 'NO_SAAS_STUDENTS';
   p_old := TO_CHAR (:OLD.no_saas_students);
   p_new := TO_CHAR (:NEW.no_saas_students);
   pk_steps_aud.ins_jac_aud (p_aud_date,
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
   p_column_name := 'NO_NON_SAAS_CHILDREN';
   p_old := TO_CHAR (:OLD.no_non_saas_children);
   p_new := TO_CHAR (:NEW.no_non_saas_children);
   pk_steps_aud.ins_jac_aud (p_aud_date,
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
   p_column_name := 'NO_NON_SAAS_PARENTS';
   p_old := TO_CHAR (:OLD.no_non_saas_parents);
   p_new := TO_CHAR (:NEW.no_non_saas_parents);
   pk_steps_aud.ins_jac_aud (p_aud_date,
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
   p_old := :OLD.LAST_UPDATED_BY;
   p_new := :NEW.LAST_UPDATED_BY;
   pk_steps_aud.ins_jac_aud (p_aud_date,
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
END jac_iud;
/
SHOW ERRORS;

-- 
-- Non Foreign Key Constraints for Table JA_CASE 
-- 
ALTER TABLE SGAS.ja_case ADD (
  CONSTRAINT jac_all_registered
 CHECK ( all_registered IN('Y','N')))
/
ALTER TABLE SGAS.ja_case ADD (
  CONSTRAINT jac_ja_case_type
 CHECK ( ja_case_type IN('P','S')))
/
ALTER TABLE SGAS.ja_case ADD (
  CONSTRAINT p_jac
 PRIMARY KEY
 (ja_case_id)
    USING INDEX
    TABLESPACE users
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100 k
                NEXT             100 k
                MINEXTENTS       1
                MAXEXTENTS       99
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ))
/
DROP SEQUENCE SGAS.ja_case_id_seq
/
--
-- ja_case_id_seq  (Sequence) 
--
CREATE SEQUENCE SGAS.ja_case_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER SGAS.trig_ja_case_seq
   BEFORE INSERT
   ON sgas.ja_case
   FOR EACH ROW
BEGIN
   SELECT ja_case_id_seq.NEXTVAL
     INTO :NEW.ja_case_id
     FROM DUAL;
END;