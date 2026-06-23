-- AWARD_REF_DATA.sql
-- Description: Table holding all AWARD_REF_DATAs for SGAS
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

ALTER TABLE sgas.award_ref_data
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.award_ref_data CASCADE CONSTRAINTS PURGE
/
--
-- AWARD_REF_DATA  (Table) 
--
CREATE TABLE sgas.award_ref_data
(
  award_ref_data_id      NUMBER(10)       NOT NULL,
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

COMMENT ON COLUMN sgas.award_ref_data.award_ref_data_id IS 'Unique AWARD_REF_DATA reference number';

COMMENT ON COLUMN sgas.award_ref_data.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.award_ref_data.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.award_ref_data.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.award_ref_data.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX award_ref_data_pk ON sgas.award_ref_data
(award_ref_data_id)
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



CREATE OR REPLACE TRIGGER SGAS.aw_ref_dat_iud
   AFTER INSERT OR DELETE OR UPDATE OF AWARD_REF_DATA_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.AWARD_REF_DATA    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    AWARD_REF_DATA_aud.column_name%TYPE    := NULL;
   p_table_pkey1    AWARD_REF_DATA_aud.table_pkey1%TYPE
                                               := :OLD.AWARD_REF_DATA_id;
   p_table_pkey2    AWARD_REF_DATA_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    AWARD_REF_DATA_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    AWARD_REF_DATA_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    AWARD_REF_DATA_aud.table_pkey5%TYPE    := NULL;
   p_old            AWARD_REF_DATA_aud.OLD%TYPE            := NULL;
   p_new            AWARD_REF_DATA_aud.NEW%TYPE            := NULL;
   p_action         AWARD_REF_DATA_aud.action%TYPE         := NULL;
   p_username       AWARD_REF_DATA_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    AWARD_REF_DATA_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      AWARD_REF_DATA_aud.inst_code%TYPE      := NULL;
   p_session_code   AWARD_REF_DATA_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.AWARD_REF_DATA_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.AWARD_REF_DATA_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'AWARD_REF_DATA_ID';
   p_old := :OLD.AWARD_REF_DATA_id;
   p_new := :NEW.AWARD_REF_DATA_id;
   pk_steps_aud.ins_aw_ref_dat_aud (p_aud_date,
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
   pk_steps_aud.ins_aw_ref_dat_aud (p_aud_date,
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
   pk_steps_aud.ins_aw_ref_dat_aud (p_aud_date,
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
   pk_steps_aud.ins_aw_ref_dat_aud (p_aud_date,
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
   pk_steps_aud.ins_aw_ref_dat_aud (p_aud_date,
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
END aw_ref_dat_iud;

SHOW ERRORS;

ALTER TABLE sgas.award_ref_data ADD (
  CONSTRAINT award_ref_data_pk
 PRIMARY KEY
 (award_ref_data_id)
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
DROP PUBLIC SYNONYM award_ref_data
/
CREATE PUBLIC SYNONYM award_ref_data FOR sgas.award_ref_data
/
DROP SEQUENCE sgas.award_ref_data_id_seq
/
--
-- AWARD_REF_DATA_ID_seq  (Sequence) 
--
CREATE SEQUENCE SGAS.award_ref_data_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/

CREATE OR REPLACE TRIGGER SGAS.trig_award_ref_data_seq
   BEFORE INSERT
   ON SGAS.award_ref_data
   FOR EACH ROW
BEGIN
   SELECT award_ref_data_id_seq.NEXTVAL
     INTO :NEW.award_ref_data_id
     FROM DUAL;
END;   

--
-- INSERT DATA
--

INSERT INTO award_ref_data
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'E', 'All Support'
            );

INSERT INTO award_ref_data
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'A', 'Fees and Non-means tested loan (claimed)'
            );


INSERT INTO award_ref_data
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'B', 'Fees and Non-means tested loan (assessed)'
            );

INSERT INTO award_ref_data
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'C', 'Fees and Non-means tested loan (system)'
            );


INSERT INTO award_ref_data
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'D', 'Fees and Non-means tested loan (caseworker)'
            );


COMMIT ;