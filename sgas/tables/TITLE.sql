-- TITLE.sql
-- Description: Table holding all TITLEs for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      14.06.09    R Hunter (SAAS)         Initial Version.
-- 1.1      30.06.09    A.Bowman (SAAS)         Amended audit triggers.
-- 1.2	    25.01.2010  P Grace (SAAS)		Abbreviated Professer entry as too long for title field
-- 1.3      28.01.2010  A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.title
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.title CASCADE CONSTRAINTS PURGE
/
--
-- TITLE  (Table) 
--
CREATE TABLE sgas.title
(
  title_id      NUMBER(10)       NOT NULL,
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

COMMENT ON COLUMN sgas.title.title_id IS 'Unique TITLE reference number';

COMMENT ON COLUMN sgas.title.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.title.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.title.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.title.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX title_pk ON sgas.title
(title_id)
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



CREATE OR REPLACE TRIGGER SGAS.title_iud
   AFTER INSERT OR DELETE OR UPDATE OF TITLE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.TITLE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    TITLE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    TITLE_aud.table_pkey1%TYPE
                                               := :OLD.TITLE_id;
   p_table_pkey2    TITLE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    TITLE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    TITLE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    TITLE_aud.table_pkey5%TYPE    := NULL;
   p_old            TITLE_aud.OLD%TYPE            := NULL;
   p_new            TITLE_aud.NEW%TYPE            := NULL;
   p_action         TITLE_aud.action%TYPE         := NULL;
   p_username       TITLE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    TITLE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      TITLE_aud.inst_code%TYPE      := NULL;
   p_session_code   TITLE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.TITLE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.TITLE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'TITLE_ID';
   p_old := :OLD.TITLE_id;
   p_new := :NEW.TITLE_id;
   pk_steps_aud.ins_title_aud (p_aud_date,
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
   pk_steps_aud.ins_title_aud (p_aud_date,
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
   pk_steps_aud.ins_title_aud (p_aud_date,
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
   pk_steps_aud.ins_title_aud (p_aud_date,
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
   pk_steps_aud.ins_title_aud (p_aud_date,
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
END title_iud;
SHOW ERRORS;


ALTER TABLE sgas.title ADD (
  CONSTRAINT title_pk
 PRIMARY KEY
 (title_id)
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
DROP PUBLIC SYNONYM title
/
CREATE PUBLIC SYNONYM title FOR sgas.title
/
DROP SEQUENCE sgas.title_id_seq
/
--
-- TITLE_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.title_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_title_seq
   BEFORE INSERT
   ON sgas.title
   FOR EACH ROW
BEGIN
   SELECT title_id_seq.NEXTVAL
     INTO :NEW.title_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--

INSERT INTO title
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'MR', 'Mr'
            );


INSERT INTO title
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'MRS', 'Mrs'
            );


INSERT INTO title
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'MISS', 'Miss'
            );


INSERT INTO title
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'MS', 'Ms'
            );


INSERT INTO title
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'DR', 'Dr'
            );


INSERT INTO title
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'PROF.', 'Professor'
            );


INSERT INTO title
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'OTHER', 'Other'
            );


COMMIT ;