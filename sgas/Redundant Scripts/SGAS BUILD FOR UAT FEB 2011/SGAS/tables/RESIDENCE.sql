-- RESIDENCE.sql
-- Description: Table holding all RESIDENCEs for SGAS
--
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      28.04.10    A.Bowman (SAAS)         Initial Version.
--
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.RESIDENCE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.RESIDENCE CASCADE CONSTRAINTS PURGE
/
--
-- RESIDENCE  (Table) 
--
CREATE TABLE sgas.RESIDENCE
(
  RESIDENCE_id                NUMBER(10)       NOT NULL,
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

COMMENT ON COLUMN sgas.RESIDENCE.RESIDENCE_id IS 'Unique RESIDENCE reference number';

COMMENT ON COLUMN sgas.RESIDENCE.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.RESIDENCE.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.RESIDENCE.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.RESIDENCE.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX RESIDENCE_pk ON sgas.RESIDENCE
(RESIDENCE_id)
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


CREATE OR REPLACE TRIGGER SGAS.res_iud
   AFTER INSERT OR DELETE OR UPDATE OF RESIDENCE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.RESIDENCE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    RESIDENCE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    RESIDENCE_aud.table_pkey1%TYPE
                                               := :OLD.RESIDENCE_id;
   p_table_pkey2    RESIDENCE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    RESIDENCE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    RESIDENCE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    RESIDENCE_aud.table_pkey5%TYPE    := NULL;
   p_old            RESIDENCE_aud.OLD%TYPE            := NULL;
   p_new            RESIDENCE_aud.NEW%TYPE            := NULL;
   p_action         RESIDENCE_aud.action%TYPE         := NULL;
   p_username       RESIDENCE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    RESIDENCE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      RESIDENCE_aud.inst_code%TYPE      := NULL;
   p_session_code   RESIDENCE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.RESIDENCE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.RESIDENCE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'RESIDENCE_ID';
   p_old := :OLD.RESIDENCE_id;
   p_new := :NEW.RESIDENCE_id;
   pk_steps_aud.ins_res_aud (p_aud_date,
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
   pk_steps_aud.ins_res_aud (p_aud_date,
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
   pk_steps_aud.ins_res_aud (p_aud_date,
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
   pk_steps_aud.ins_res_aud (p_aud_date,
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
   pk_steps_aud.ins_res_aud (p_aud_date,
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
END res_iud;

SHOW ERRORS;


ALTER TABLE sgas.RESIDENCE ADD (
  CONSTRAINT RESIDENCE_pk
 PRIMARY KEY
 (RESIDENCE_id)
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
DROP PUBLIC SYNONYM RESIDENCE
/
CREATE PUBLIC SYNONYM RESIDENCE FOR sgas.RESIDENCE
/
DROP SEQUENCE sgas.RESIDENCE_id_seq
/
--
-- RESIDENCE_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.RESIDENCE_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_RESIDENCE_seq
   BEFORE INSERT
   ON SGAS.RESIDENCE
   FOR EACH ROW
BEGIN
   SELECT RESIDENCE_id_seq.NEXTVAL
     INTO :NEW.RESIDENCE_id
     FROM DUAL;
END;

--                                                                       
-- INSERT DATA
--

INSERT INTO RESIDENCE
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 501, 'SCOTLAND'
            );

INSERT INTO RESIDENCE
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 502, 'REST OF BRITISH ISLES'
            );

INSERT INTO RESIDENCE
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 503, 'EUROPEAN COMMUNITY'
            );

INSERT INTO RESIDENCE
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 504, 'ELSEWHERE'
            );
COMMIT ;