-- LOCATION.sql
-- Description: Table holding all LOCATIONs for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      14.06.09    R Hunter (SAAS)         Initial Version.
-- 1.1      30.06.09    A.Bowman (SAAS)         Amended audit triggers
-- 1.2      28.01.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE SGAS.LOCATION
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.LOCATION CASCADE CONSTRAINTS PURGE
/
--
-- LOCATION  (Table) 
--
CREATE TABLE SGAS.LOCATION
(
  location_id      NUMBER(10)       NOT NULL,
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

COMMENT ON COLUMN sgas.LOCATION.location_id IS 'Unique LOCATION reference number';

COMMENT ON COLUMN sgas.LOCATION.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.LOCATION.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.LOCATION.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.LOCATION.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX location_pk ON SGAS.LOCATION
(location_id)
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


CREATE OR REPLACE TRIGGER SGAS.loc_iud
   AFTER INSERT OR DELETE OR UPDATE OF LOCATION_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.LOCATION    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    LOCATION_aud.column_name%TYPE    := NULL;
   p_table_pkey1    LOCATION_aud.table_pkey1%TYPE
                                               := :OLD.LOCATION_id;
   p_table_pkey2    LOCATION_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    LOCATION_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    LOCATION_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    LOCATION_aud.table_pkey5%TYPE    := NULL;
   p_old            LOCATION_aud.OLD%TYPE            := NULL;
   p_new            LOCATION_aud.NEW%TYPE            := NULL;
   p_action         LOCATION_aud.action%TYPE         := NULL;
   p_username       LOCATION_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    LOCATION_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      LOCATION_aud.inst_code%TYPE      := NULL;
   p_session_code   LOCATION_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.LOCATION_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.LOCATION_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'LOCATION_ID';
   p_old := :OLD.LOCATION_id;
   p_new := :NEW.LOCATION_id;
   pk_steps_aud.ins_loc_aud (p_aud_date,
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
   pk_steps_aud.ins_loc_aud (p_aud_date,
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
   pk_steps_aud.ins_loc_aud (p_aud_date,
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
   pk_steps_aud.ins_loc_aud (p_aud_date,
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
   pk_steps_aud.ins_loc_aud (p_aud_date,
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
END loc_iud;
SHOW ERRORS;

ALTER TABLE SGAS.LOCATION ADD (
  CONSTRAINT location_pk
 PRIMARY KEY
 (location_id)
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
DROP PUBLIC SYNONYM LOCATION
/
CREATE PUBLIC SYNONYM LOCATION FOR sgas.LOCATION
/
DROP SEQUENCE sgas.location_id_seq
/
--
-- LOCATION_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.location_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_location_seq
   BEFORE INSERT
   ON SGAS.LOCATION
   FOR EACH ROW
BEGIN
   SELECT location_id_seq.NEXTVAL
     INTO :NEW.location_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--

INSERT INTO LOCATION
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'H', 'Home'
            );

INSERT INTO LOCATION
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'E', 'Elsewhere'
            );
INSERT INTO LOCATION
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'L', 'London'
            );
INSERT INTO LOCATION
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'O', 'Restricted Home'
            );

INSERT INTO LOCATION
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'W', 'Restricted Elsewhere'
            );


COMMIT ;