-- NO_NINO_REASON.sql
-- Description: Table holding all NO_NINO_REASONs for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      16.07.09    A.Bowman (SAAS)         Initial Version.
-- 1.1      28.01.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.NO_NINO_REASON
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.NO_NINO_REASON CASCADE CONSTRAINTS PURGE
/
--
-- NO_NINO_REASON  (Table) 
--
CREATE TABLE sgas.NO_NINO_REASON
(
  NO_NINO_REASON_id      NUMBER(10)       NOT NULL,
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

COMMENT ON COLUMN sgas.NO_NINO_REASON.NO_NINO_REASON_id IS 'Unique NO_NINO_REASON reference number';

COMMENT ON COLUMN sgas.NO_NINO_REASON.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.NO_NINO_REASON.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.NO_NINO_REASON.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.NO_NINO_REASON.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX NO_NINO_REASON_pk ON sgas.NO_NINO_REASON
(NO_NINO_REASON_id)
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


CREATE OR REPLACE TRIGGER SGAS.NO_NINO_REA_iud
   AFTER INSERT OR DELETE OR UPDATE OF NO_NINO_REASON_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.NO_NINO_REASON    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    NO_NINO_REASON_aud.column_name%TYPE    := NULL;
   p_table_pkey1    NO_NINO_REASON_aud.table_pkey1%TYPE
                                               := :OLD.NO_NINO_REASON_id;
   p_table_pkey2    NO_NINO_REASON_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    NO_NINO_REASON_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    NO_NINO_REASON_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    NO_NINO_REASON_aud.table_pkey5%TYPE    := NULL;
   p_old            NO_NINO_REASON_aud.OLD%TYPE            := NULL;
   p_new            NO_NINO_REASON_aud.NEW%TYPE            := NULL;
   p_action         NO_NINO_REASON_aud.action%TYPE         := NULL;
   p_username       NO_NINO_REASON_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    NO_NINO_REASON_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      NO_NINO_REASON_aud.inst_code%TYPE      := NULL;
   p_session_code   NO_NINO_REASON_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.NO_NINO_REASON_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.NO_NINO_REASON_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'NO_NINO_REASON_ID';
   p_old := :OLD.NO_NINO_REASON_id;
   p_new := :NEW.NO_NINO_REASON_id;
   pk_steps_aud.ins_NO_NINO_REA_aud (p_aud_date,
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
   pk_steps_aud.ins_NO_NINO_REA_aud (p_aud_date,
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
   pk_steps_aud.ins_NO_NINO_REA_aud (p_aud_date,
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
   pk_steps_aud.ins_NO_NINO_REA_aud (p_aud_date,
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
   pk_steps_aud.ins_NO_NINO_REA_aud (p_aud_date,
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
END NO_NINO_REA_iud;
SHOW ERRORS;

ALTER TABLE sgas.NO_NINO_REASON ADD (
  CONSTRAINT NO_NINO_REASON_pk
 PRIMARY KEY
 (NO_NINO_REASON_id)
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
DROP PUBLIC SYNONYM NO_NINO_REASON
/
CREATE PUBLIC SYNONYM NO_NINO_REASON FOR sgas.NO_NINO_REASON
/
DROP SEQUENCE sgas.NO_NINO_REASON_id_seq
/
--
-- NO_NINO_REASON_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.NO_NINO_REASON_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_NO_NINO_REASON_seq
   BEFORE INSERT
   ON SGAS.NO_NINO_REASON
   FOR EACH ROW
BEGIN
   SELECT NO_NINO_REASON_id_seq.NEXTVAL
     INTO :NEW.NO_NINO_REASON_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--

INSERT INTO NO_NINO_REASON
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 901, 'No Child Benefit'
            );


INSERT INTO NO_NINO_REASON
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 902, 'Non UK'
            );


INSERT INTO NO_NINO_REASON
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 903, 'Other'
            );


INSERT INTO NO_NINO_REASON
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 904, 'Refugee'
            );


COMMIT ;