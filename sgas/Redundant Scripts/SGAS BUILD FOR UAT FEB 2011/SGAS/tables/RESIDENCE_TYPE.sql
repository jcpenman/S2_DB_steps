-- RESIDENCE_TYPE.sql
-- Description: Table holding all RESIDENCE_TYPEs for SGAS
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

ALTER TABLE sgas.residence_type
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.residence_type CASCADE CONSTRAINTS PURGE
/
--
-- RESIDENCE_TYPE  (Table) 
--
CREATE TABLE sgas.residence_type
(
  residence_type_id      NUMBER(10)       NOT NULL,
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

COMMENT ON COLUMN sgas.residence_type.residence_type_id IS 'Unique RESIDENCE_TYPE reference number';

COMMENT ON COLUMN sgas.residence_type.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.residence_type.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.residence_type.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.residence_type.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX residence_type_pk ON sgas.residence_type
(residence_type_id)
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


CREATE OR REPLACE TRIGGER SGAS.res_type_iud
   AFTER INSERT OR DELETE OR UPDATE OF RESIDENCE_TYPE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.RESIDENCE_TYPE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    RESIDENCE_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    RESIDENCE_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.RESIDENCE_TYPE_id;
   p_table_pkey2    RESIDENCE_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    RESIDENCE_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    RESIDENCE_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    RESIDENCE_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            RESIDENCE_TYPE_aud.OLD%TYPE            := NULL;
   p_new            RESIDENCE_TYPE_aud.NEW%TYPE            := NULL;
   p_action         RESIDENCE_TYPE_aud.action%TYPE         := NULL;
   p_username       RESIDENCE_TYPE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    RESIDENCE_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      RESIDENCE_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   RESIDENCE_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.RESIDENCE_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.RESIDENCE_TYPE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'RESIDENCE_TYPE_ID';
   p_old := :OLD.RESIDENCE_TYPE_id;
   p_new := :NEW.RESIDENCE_TYPE_id;
   pk_steps_aud.ins_res_type_aud (p_aud_date,
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
   pk_steps_aud.ins_res_type_aud (p_aud_date,
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
   pk_steps_aud.ins_res_type_aud (p_aud_date,
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
   pk_steps_aud.ins_res_type_aud (p_aud_date,
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
   pk_steps_aud.ins_res_type_aud (p_aud_date,
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
END res_type_iud;
SHOW ERRORS;

ALTER TABLE sgas.residence_type ADD (
  CONSTRAINT residence_type_pk
 PRIMARY KEY
 (residence_type_id)
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
DROP PUBLIC SYNONYM residence_type
/
CREATE PUBLIC SYNONYM residence_type FOR sgas.residence_type
/
DROP SEQUENCE sgas.residence_type_id_seq
/
--
-- RESIDENCE_TYPE_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.residence_type_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_residence_type_seq
   BEFORE INSERT
   ON sgas.residence_type
   FOR EACH ROW
BEGIN
   SELECT residence_type_id_seq.NEXTVAL
     INTO :NEW.residence_type_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--

INSERT INTO residence_type
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'P', 'Parental Home'
            );

INSERT INTO residence_type
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'H', 'Halls of Residence'
            );

INSERT INTO residence_type
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'O', 'Own Home'
            );

INSERT INTO residence_type
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'R', 'Rented Accomodation'
            );
INSERT INTO residence_type
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'X', 'Other'
            );

COMMIT ;