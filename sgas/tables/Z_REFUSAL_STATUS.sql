-- Z_REFUSAL_STATUS.sql
-- Description: Table holding all Z_REFUSAL_STATUSs for SGAS
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

ALTER TABLE SGAS.Z_REFUSAL_STATUS
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.Z_REFUSAL_STATUS CASCADE CONSTRAINTS PURGE
/
--
-- Z_REFUSAL_STATUS  (Table) 
--
CREATE TABLE SGAS.Z_REFUSAL_STATUS
(
  Z_REFUSAL_STATUS_id      NUMBER(10)       NOT NULL,
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

COMMENT ON COLUMN SGAS.Z_REFUSAL_STATUS.Z_REFUSAL_STATUS_id IS 'Unique Z_REFUSAL_STATUS reference number';

COMMENT ON COLUMN SGAS.Z_REFUSAL_STATUS.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN SGAS.Z_REFUSAL_STATUS.descript IS 'Description of data item';

COMMENT ON COLUMN SGAS.Z_REFUSAL_STATUS.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN SGAS.Z_REFUSAL_STATUS.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX Z_REFUSAL_STATUS_pk ON SGAS.Z_REFUSAL_STATUS
(Z_REFUSAL_STATUS_id)
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



CREATE OR REPLACE TRIGGER SGAS.z_ref_stat_iud
   AFTER INSERT OR DELETE OR UPDATE OF Z_REFUSAL_STATUS_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.Z_REFUSAL_STATUS    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    Z_REFUSAL_STATUS_aud.column_name%TYPE    := NULL;
   p_table_pkey1    Z_REFUSAL_STATUS_aud.table_pkey1%TYPE
                                               := :OLD.Z_REFUSAL_STATUS_id;
   p_table_pkey2    Z_REFUSAL_STATUS_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    Z_REFUSAL_STATUS_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    Z_REFUSAL_STATUS_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    Z_REFUSAL_STATUS_aud.table_pkey5%TYPE    := NULL;
   p_old            Z_REFUSAL_STATUS_aud.OLD%TYPE            := NULL;
   p_new            Z_REFUSAL_STATUS_aud.NEW%TYPE            := NULL;
   p_action         Z_REFUSAL_STATUS_aud.action%TYPE         := NULL;
   p_username       Z_REFUSAL_STATUS_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    Z_REFUSAL_STATUS_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      Z_REFUSAL_STATUS_aud.inst_code%TYPE      := NULL;
   p_session_code   Z_REFUSAL_STATUS_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.Z_REFUSAL_STATUS_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.Z_REFUSAL_STATUS_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'Z_REFUSAL_STATUS_ID';
   p_old := :OLD.Z_REFUSAL_STATUS_id;
   p_new := :NEW.Z_REFUSAL_STATUS_id;
   pk_steps_aud.ins_z_ref_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_z_ref_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_z_ref_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_z_ref_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_z_ref_stat_aud (p_aud_date,
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
END z_ref_stat_iud;

SHOW ERRORS;

ALTER TABLE SGAS.Z_REFUSAL_STATUS ADD (
  CONSTRAINT Z_REFUSAL_STATUS_pk
 PRIMARY KEY
 (Z_REFUSAL_STATUS_id)
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
DROP PUBLIC SYNONYM Z_REFUSAL_STATUS
/
CREATE PUBLIC SYNONYM Z_REFUSAL_STATUS FOR sgas.Z_REFUSAL_STATUS
/
DROP SEQUENCE SGAS.Z_REFUSAL_STATUS_id_seq
/
--
-- Z_REFUSAL_STATUS_ID_seq  (Sequence) 
--
CREATE SEQUENCE SGAS.Z_REFUSAL_STATUS_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_Z_REFUSAL_STATUS_seq
   BEFORE INSERT
   ON SGAS.Z_REFUSAL_STATUS
   FOR EACH ROW
BEGIN
   SELECT Z_REFUSAL_STATUS_id_seq.NEXTVAL
     INTO :NEW.Z_REFUSAL_STATUS_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--

INSERT INTO Z_REFUSAL_STATUS
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'N', 'Not Applicable' 
            );
INSERT INTO Z_REFUSAL_STATUS
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'R', 'Refused' 
            );
INSERT INTO Z_REFUSAL_STATUS
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'I', 'Reinstated'
            );
 
 
COMMIT ;