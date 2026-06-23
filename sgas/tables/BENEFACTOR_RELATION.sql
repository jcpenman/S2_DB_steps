-- BENEFACTOR_RELATION.sql
-- Description: Table holding all BENEFACTOR_RELATIONs for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      14.06.09    R Hunter (SAAS)         Initial Version.
-- 1.1      30.06.09    A.Bowman (SAAS)         Amended audit triggers.
-- 1.2      29.07.09    R.Hunter (SAAS)         Amended data list at script end
-- 1.3      28.01.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.benefactor_relation
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.benefactor_relation CASCADE CONSTRAINTS
/
--
-- BENEFACTOR_RELATION  (Table) 
--
CREATE TABLE sgas.benefactor_relation
(
  benefactor_relation_id      NUMBER(10)       NOT NULL,
  legacy_id                   NUMBER(4) NOT NULL,
  legacy_code                 VARCHAR2(4 BYTE) NOT NULL,
  descript                    VARCHAR2(1000 BYTE) NOT NULL,
  last_updated_by             VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  last_updated_on             DATE                     DEFAULT SYSDATE               NOT NULL
)
TABLESPACE users
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCOMPRESS
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN sgas.benefactor_relation.benefactor_relation_id IS 'Unique BENEFACTOR_RELATION reference number';

COMMENT ON COLUMN sgas.benefactor_relation.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.benefactor_relation.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.benefactor_relation.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.benefactor_relation.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX benefactor_relation_pk ON sgas.benefactor_relation
(benefactor_relation_id)
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


CREATE OR REPLACE TRIGGER SGAS.ben_rel_iud
   AFTER INSERT OR DELETE OR UPDATE OF benefactor_relation_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.BENEFACTOR_RELATION    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    benefactor_relation_aud.column_name%TYPE    := NULL;
   p_table_pkey1    benefactor_relation_aud.table_pkey1%TYPE
                                               := :OLD.benefactor_relation_id;
   p_table_pkey2    benefactor_relation_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    benefactor_relation_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    benefactor_relation_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    benefactor_relation_aud.table_pkey5%TYPE    := NULL;
   p_old            benefactor_relation_aud.OLD%TYPE            := NULL;
   p_new            benefactor_relation_aud.NEW%TYPE            := NULL;
   p_action         benefactor_relation_aud.action%TYPE         := NULL;
   p_username       benefactor_relation_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    benefactor_relation_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      benefactor_relation_aud.inst_code%TYPE      := NULL;
   p_session_code   benefactor_relation_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.benefactor_relation_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.benefactor_relation_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'BENEFACTOR_RELATION_ID';
   p_old := :OLD.benefactor_relation_id;
   p_new := :NEW.benefactor_relation_id;
   pk_steps_aud.ins_ben_rel_aud (p_aud_date,
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
   p_column_name := 'LEGACY_ID';
   p_old := TO_CHAR (:OLD.legacy_id);
   p_new := TO_CHAR (:NEW.legacy_id);
   pk_steps_aud.ins_ben_rel_aud (p_aud_date,
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
   p_column_name := 'LEGACY_CODE';
   p_old := TO_CHAR (:OLD.legacy_code);
   p_new := TO_CHAR (:NEW.legacy_code);
   pk_steps_aud.ins_ben_rel_aud (p_aud_date,
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
   p_column_name := 'DESCRIPT';
   p_old := TO_CHAR (:OLD.descript);
   p_new := TO_CHAR (:NEW.descript);
   pk_steps_aud.ins_ben_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_rel_aud (p_aud_date,
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
END ben_rel_iud;

SHOW ERRORS;

ALTER TABLE sgas.benefactor_relation ADD (
  CONSTRAINT benefactor_relation_pk
 PRIMARY KEY
 (benefactor_relation_id)
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
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM benefactor_relation
/
CREATE PUBLIC SYNONYM benefactor_relation FOR sgas.benefactor_relation
/
DROP SEQUENCE sgas.benefactor_relation_id_seq
/
--
-- BENEFACTOR_RELATION_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.benefactor_relation_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER SGAS.trig_benefactor_relation_seq
   BEFORE INSERT
   ON SGAS.benefactor_relation
   FOR EACH ROW
BEGIN
   SELECT benefactor_relation_id_seq.NEXTVAL
     INTO :NEW.benefactor_relation_id
     FROM DUAL;
END;  
 
--
-- INSERT DATA
--

INSERT INTO benefactor_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (30, 'P', 'FATHER OR MOTHER'
            );
INSERT INTO benefactor_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (31, 'P', 'PARENTS PARTNER'
            );
INSERT INTO benefactor_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (32, 'P', 'STEP PARENT'
            );
INSERT INTO benefactor_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (99, 'P', 'OTHER'
            );
INSERT INTO benefactor_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (28, 'O', 'HUSBAND, WIFE OR PARTNER'
            );



COMMIT ;