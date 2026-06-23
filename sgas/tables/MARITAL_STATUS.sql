-- MARITAL_STATUS.sql
-- Description: Table holding all MARITAL_STATUSs for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      14.06.09    R Hunter (SAAS)         Initial Version.
-- 1.1      30.06.09    A.Bowman (SAAS)         Amended audit triggers.
-- 1.2      02.09.09    A.Bowman (SAAS)         Amended reference data insert script to correct values
-- 1.3      28.01.10    A.Bowman (SAAS)         Amended audit triggers
-- 1.4      03.02.13    A.Bowman (SAAS)         Added new data item
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.marital_status
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.marital_status CASCADE CONSTRAINTS PURGE
/
--
-- MARITAL_STATUS  (Table) 
--
CREATE TABLE sgas.marital_status
(
  marital_status_id      NUMBER(10)       NOT NULL,
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

COMMENT ON COLUMN sgas.marital_status.marital_status_id IS 'Unique MARITAL_STATUS reference number';

COMMENT ON COLUMN sgas.marital_status.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.marital_status.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.marital_status.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.marital_status.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX marital_status_pk ON sgas.marital_status
(marital_status_id)
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


CREATE OR REPLACE TRIGGER SGAS.mar_stat_iud
   AFTER INSERT OR DELETE OR UPDATE OF MARITAL_STATUS_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.MARITAL_STATUS    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    MARITAL_STATUS_aud.column_name%TYPE    := NULL;
   p_table_pkey1    MARITAL_STATUS_aud.table_pkey1%TYPE
                                               := :OLD.MARITAL_STATUS_id;
   p_table_pkey2    MARITAL_STATUS_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    MARITAL_STATUS_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    MARITAL_STATUS_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    MARITAL_STATUS_aud.table_pkey5%TYPE    := NULL;
   p_old            MARITAL_STATUS_aud.OLD%TYPE            := NULL;
   p_new            MARITAL_STATUS_aud.NEW%TYPE            := NULL;
   p_action         MARITAL_STATUS_aud.action%TYPE         := NULL;
   p_username       MARITAL_STATUS_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    MARITAL_STATUS_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      MARITAL_STATUS_aud.inst_code%TYPE      := NULL;
   p_session_code   MARITAL_STATUS_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.MARITAL_STATUS_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.MARITAL_STATUS_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'MARITAL_STATUS_ID';
   p_old := :OLD.MARITAL_STATUS_id;
   p_new := :NEW.MARITAL_STATUS_id;
   pk_steps_aud.ins_mar_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_mar_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_mar_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_mar_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_mar_stat_aud (p_aud_date,
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
END mar_stat_iud;

SHOW ERRORS;

ALTER TABLE sgas.marital_status ADD (
  CONSTRAINT marital_status_pk
 PRIMARY KEY
 (marital_status_id)
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
DROP PUBLIC SYNONYM marital_status
/
CREATE PUBLIC SYNONYM marital_status FOR sgas.marital_status
/
DROP SEQUENCE sgas.marital_status_id_seq
/
--
-- MARITAL_STATUS_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.marital_status_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_marital_status_seq
   BEFORE INSERT
   ON sgas.marital_status
   FOR EACH ROW
BEGIN
   SELECT marital_status_id_seq.NEXTVAL
     INTO :NEW.marital_status_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--

INSERT INTO marital_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'S', 'Single'
            );
INSERT INTO marital_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'M', 'Married'
            );
INSERT INTO marital_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'D', 'Divorced'
            );
INSERT INTO marital_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'P', 'Separated'
            );
INSERT INTO marital_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'W', 'Widowed'
            );
INSERT INTO marital_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'E', 'Living with partner'
            );

-- 1.4 

INSERT INTO marital_status
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'K', 'Civil Parntership'
            );



COMMIT ;