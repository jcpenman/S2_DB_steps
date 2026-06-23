-- BEN_INCOME_TYPE.sql
-- Description: Table holding all BEN_INCOME_TYPEs for SGAS
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

ALTER TABLE sgas.ben_income_type
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.ben_income_type CASCADE CONSTRAINTS PURGE
/
--
-- BEN_INCOME_TYPE  (Table) 
--
CREATE TABLE sgas.ben_income_type
(
  ben_income_type_id      NUMBER(10)       NOT NULL,
  legacy_id                   NUMBER(4) NOT NULL,
  legacy_code                 VARCHAR2(40 BYTE) NOT NULL,
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

COMMENT ON COLUMN sgas.ben_income_type.ben_income_type_id IS 'Unique BEN_INCOME_TYPE reference number';

COMMENT ON COLUMN sgas.ben_income_type.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.ben_income_type.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.ben_income_type.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.ben_income_type.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX ben_income_type_pk ON sgas.ben_income_type
(ben_income_type_id)
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


CREATE OR REPLACE TRIGGER SGAS.ben_inc_type_iud
   AFTER INSERT OR DELETE OR UPDATE OF BEN_INCOME_TYPE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.BEN_INCOME_TYPE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    BEN_INCOME_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    BEN_INCOME_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.BEN_INCOME_TYPE_id;
   p_table_pkey2    BEN_INCOME_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    BEN_INCOME_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    BEN_INCOME_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    BEN_INCOME_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            BEN_INCOME_TYPE_aud.OLD%TYPE            := NULL;
   p_new            BEN_INCOME_TYPE_aud.NEW%TYPE            := NULL;
   p_action         BEN_INCOME_TYPE_aud.action%TYPE         := NULL;
   p_username       BEN_INCOME_TYPE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    BEN_INCOME_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      BEN_INCOME_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   BEN_INCOME_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.BEN_INCOME_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.BEN_INCOME_TYPE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'BEN_INCOME_TYPE_ID';
   p_old := :OLD.BEN_INCOME_TYPE_id;
   p_new := :NEW.BEN_INCOME_TYPE_id;
   pk_steps_aud.ins_ben_inc_type_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_inc_type_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_inc_type_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_inc_type_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_inc_type_aud (p_aud_date,
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
END ben_inc_type_iud;
SHOW ERRORS;

ALTER TABLE sgas.ben_income_type ADD (
  CONSTRAINT ben_income_type_pk
 PRIMARY KEY
 (ben_income_type_id)
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
DROP PUBLIC SYNONYM ben_income_type
/
CREATE PUBLIC SYNONYM ben_income_type FOR sgas.ben_income_type
/
DROP SEQUENCE sgas.ben_income_type_id_seq
/
--
-- BEN_INCOME_TYPE_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.ben_income_type_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_ben_income_type_seq
   BEFORE INSERT
   ON sgas.ben_income_type
   FOR EACH ROW
BEGIN
   SELECT ben_income_type_id_seq.NEXTVAL
     INTO :NEW.ben_income_type_id
     FROM DUAL;
END; 

--
-- INSERT DATA
--

INSERT INTO ben_income_type
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'P', 'Previous'
            );
INSERT INTO ben_income_type
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'C', 'Current'
            );


COMMIT ;