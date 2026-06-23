-- SCHEME_TYPE.sql
-- Description: Table holding all SCHEME_TYPEs for SGAS
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

ALTER TABLE sgas.scheme_type
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.scheme_type CASCADE CONSTRAINTS PURGE
/
--
-- SCHEME_TYPE  (Table) 
--
CREATE TABLE sgas.scheme_type
(
  scheme_type_id      NUMBER(10)       NOT NULL,
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

COMMENT ON COLUMN sgas.scheme_type.scheme_type_id IS 'Unique SCHEME_TYPE reference number';

COMMENT ON COLUMN sgas.scheme_type.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.scheme_type.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.scheme_type.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.scheme_type.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX scheme_type_pk ON sgas.scheme_type
(scheme_type_id)
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


CREATE OR REPLACE TRIGGER SGAS.sch_type_iud
   AFTER INSERT OR DELETE OR UPDATE OF SCHEME_TYPE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.SCHEME_TYPE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    SCHEME_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    SCHEME_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.SCHEME_TYPE_id;
   p_table_pkey2    SCHEME_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    SCHEME_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    SCHEME_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    SCHEME_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            SCHEME_TYPE_aud.OLD%TYPE            := NULL;
   p_new            SCHEME_TYPE_aud.NEW%TYPE            := NULL;
   p_action         SCHEME_TYPE_aud.action%TYPE         := NULL;
   p_username       SCHEME_TYPE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    SCHEME_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      SCHEME_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   SCHEME_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.SCHEME_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.SCHEME_TYPE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'SCHEME_TYPE_ID';
   p_old := :OLD.SCHEME_TYPE_id;
   p_new := :NEW.SCHEME_TYPE_id;
   pk_steps_aud.ins_sch_type_aud (p_aud_date,
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
   pk_steps_aud.ins_sch_type_aud (p_aud_date,
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
   pk_steps_aud.ins_sch_type_aud (p_aud_date,
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
   pk_steps_aud.ins_sch_type_aud (p_aud_date,
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
   pk_steps_aud.ins_sch_type_aud (p_aud_date,
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
END sch_type_iud;

SHOW ERRORS;

ALTER TABLE sgas.scheme_type ADD (
  CONSTRAINT scheme_type_pk
 PRIMARY KEY
 (scheme_type_id)
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
DROP PUBLIC SYNONYM scheme_type
/
CREATE PUBLIC SYNONYM scheme_type FOR sgas.scheme_type
/
DROP SEQUENCE sgas.scheme_type_id_seq
/
--
-- SCHEME_TYPE_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.scheme_type_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_scheme_type_seq
   BEFORE INSERT
   ON sgas.scheme_type
   FOR EACH ROW
BEGIN
   SELECT scheme_type_id_seq.NEXTVAL
     INTO :NEW.scheme_type_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--

INSERT INTO scheme_type
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'U', 'Undergraduate'
            );
INSERT INTO scheme_type
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'B', 'Nursing and Midwifery'
            );
INSERT INTO scheme_type
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'P', 'Postgraduate'
            );



COMMIT ;