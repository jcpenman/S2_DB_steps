-- DEARING_STATUS.sql
-- Description: Table holding all DEARING_STATUSs for SGAS
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

ALTER TABLE sgas.dearing_status
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.dearing_status CASCADE CONSTRAINTS PURGE
/
--
-- DEARING_STATUS  (Table) 
--
CREATE TABLE sgas.dearing_status
(
  dearing_status_id      NUMBER(10)       NOT NULL,
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

COMMENT ON COLUMN sgas.dearing_status.dearing_status_id IS 'Unique DEARING_STATUS reference number';

COMMENT ON COLUMN sgas.dearing_status.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.dearing_status.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.dearing_status.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.dearing_status.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX dearing_status_pk ON sgas.dearing_status
(dearing_status_id)
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


CREATE OR REPLACE TRIGGER SGAS.dear_stat_iud
   AFTER INSERT OR DELETE OR UPDATE OF DEARING_STATUS_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.DEARING_STATUS    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DEARING_STATUS_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DEARING_STATUS_aud.table_pkey1%TYPE
                                               := :OLD.DEARING_STATUS_id;
   p_table_pkey2    DEARING_STATUS_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DEARING_STATUS_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DEARING_STATUS_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DEARING_STATUS_aud.table_pkey5%TYPE    := NULL;
   p_old            DEARING_STATUS_aud.OLD%TYPE            := NULL;
   p_new            DEARING_STATUS_aud.NEW%TYPE            := NULL;
   p_action         DEARING_STATUS_aud.action%TYPE         := NULL;
   p_username       DEARING_STATUS_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DEARING_STATUS_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DEARING_STATUS_aud.inst_code%TYPE      := NULL;
   p_session_code   DEARING_STATUS_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DEARING_STATUS_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DEARING_STATUS_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'DEARING_STATUS_ID';
   p_old := :OLD.DEARING_STATUS_id;
   p_new := :NEW.DEARING_STATUS_id;
   pk_steps_aud.ins_dear_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_dear_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_dear_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_dear_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_dear_stat_aud (p_aud_date,
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
END dear_stat_iud;

SHOW ERRORS;


ALTER TABLE sgas.dearing_status ADD (
  CONSTRAINT dearing_status_pk
 PRIMARY KEY
 (dearing_status_id)
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
DROP PUBLIC SYNONYM dearing_status
/
CREATE PUBLIC SYNONYM dearing_status FOR sgas.dearing_status
/
DROP SEQUENCE sgas.dearing_status_id_seq
/
--
-- DEARING_STATUS_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.dearing_status_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_dearing_status_seq
   BEFORE INSERT
   ON sgas.dearing_status
   FOR EACH ROW
BEGIN
   SELECT dearing_status_id_seq.NEXTVAL
     INTO :NEW.dearing_status_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--

INSERT INTO dearing_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'A', 'Dearing A'
            );
INSERT INTO dearing_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'B', 'RUK B'
            );
INSERT INTO dearing_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'C', 'SCOT C'
            );
INSERT INTO dearing_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'D', 'SCOT D'
            );
INSERT INTO dearing_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'E', 'RUK E'
            );
INSERT INTO dearing_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'F', 'SCOT F'
            );
INSERT INTO dearing_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'G', 'RUK G'
            );
INSERT INTO dearing_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'N', 'Non Dearing'
            );



COMMIT ;