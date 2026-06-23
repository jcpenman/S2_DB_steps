-- JOINT_APP_RELATION.sql
-- Description: Table holding all JOINT_APP_RELATIONs for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      14.06.09    R Hunter (SAAS)         Initial Version.
-- 1.1      30.06.09    A.Bowman (SAAS)         Amended audit triggers.
-- 1.2      28.01.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.joint_app_relation
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.joint_app_relation CASCADE CONSTRAINTS
/
--
-- JOINT_APP_RELATION  (Table) 
--
CREATE TABLE sgas.joint_app_relation
(
  joint_app_relation_id      NUMBER(10)       NOT NULL,
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

COMMENT ON COLUMN sgas.joint_app_relation.joint_app_relation_id IS 'Unique JOINT_APP_RELATION reference number';

COMMENT ON COLUMN sgas.joint_app_relation.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.joint_app_relation.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.joint_app_relation.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.joint_app_relation.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX joint_app_relation_pk ON sgas.joint_app_relation
(joint_app_relation_id)
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


CREATE OR REPLACE TRIGGER SGAS.joint_app_rel_iud
   AFTER INSERT OR DELETE OR UPDATE OF JOINT_APP_RELATION_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.JOINT_APP_RELATION    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    JOINT_APP_RELATION_aud.column_name%TYPE    := NULL;
   p_table_pkey1    JOINT_APP_RELATION_aud.table_pkey1%TYPE
                                               := :OLD.JOINT_APP_RELATION_id;
   p_table_pkey2    JOINT_APP_RELATION_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    JOINT_APP_RELATION_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    JOINT_APP_RELATION_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    JOINT_APP_RELATION_aud.table_pkey5%TYPE    := NULL;
   p_old            JOINT_APP_RELATION_aud.OLD%TYPE            := NULL;
   p_new            JOINT_APP_RELATION_aud.NEW%TYPE            := NULL;
   p_action         JOINT_APP_RELATION_aud.action%TYPE         := NULL;
   p_username       JOINT_APP_RELATION_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    JOINT_APP_RELATION_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      JOINT_APP_RELATION_aud.inst_code%TYPE      := NULL;
   p_session_code   JOINT_APP_RELATION_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.JOINT_APP_RELATION_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.JOINT_APP_RELATION_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'JOINT_APP_RELATION_ID';
   p_old := :OLD.JOINT_APP_RELATION_id;
   p_new := :NEW.JOINT_APP_RELATION_id;
   pk_steps_aud.ins_joi_app_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_joi_app_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_joi_app_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_joi_app_rel_aud (p_aud_date,
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
   p_old := :OLD.descript;
   p_new := :NEW.descript;
   pk_steps_aud.ins_joi_app_rel_aud (p_aud_date,
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
END joint_app_rel_iud;
SHOW ERRORS;



ALTER TABLE sgas.joint_app_relation ADD (
  CONSTRAINT joint_app_relation_pk
 PRIMARY KEY
 (joint_app_relation_id)
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
DROP PUBLIC SYNONYM joint_app_relation
/
CREATE PUBLIC SYNONYM joint_app_relation FOR sgas.joint_app_relation
/
DROP SEQUENCE sgas.joint_app_relation_id_seq
/
--
-- JOINT_APP_RELATION_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.joint_app_relation_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_joint_app_relation_seq
   BEFORE INSERT
   ON sgas.joint_app_relation
   FOR EACH ROW
BEGIN
   SELECT joint_app_relation_id_seq.NEXTVAL
     INTO :NEW.joint_app_relation_id
     FROM DUAL;
END;                                                                       

--
-- INSERT DATA
--
INSERT INTO joint_app_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'S', 'Sibling'
            );

INSERT INTO joint_app_relation
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'P', 'Parent/Child'
            );


COMMIT ;