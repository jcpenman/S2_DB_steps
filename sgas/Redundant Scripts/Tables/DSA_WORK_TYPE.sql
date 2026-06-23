-- DSA_WORK_TYPE.sql
-- Description: Table holding all DSA Work Types for SGAS
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      17.09.09    A.Bowman (SAAS)         Initial Version.
-- 1.1      28.01.10    A.Bowman (SAAS)         Amended audit triggers
-- 
-- 
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.DSA_WORK_TYPE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.DSA_WORK_TYPE CASCADE CONSTRAINTS
/
--
-- DSA_WORK_TYPE  (Table) 
--
CREATE TABLE sgas.DSA_WORK_TYPE
(
  dsa_work_type_id            NUMBER(10)       NOT NULL,
  type                        VARCHAR2(32 BYTE) NOT NULL,
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

COMMENT ON COLUMN sgas.dsa_work_type.dsa_work_type_id IS 'Unique dsa_work_type reference number';

COMMENT ON COLUMN sgas.dsa_work_type.type IS 'Unique dsa work type';

COMMENT ON COLUMN sgas.dsa_work_type.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.dsa_work_type.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX dsa_work_type_pk ON sgas.dsa_work_type
(dsa_work_type_id)
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


CREATE OR REPLACE TRIGGER SGAS.dsa_work_type_iud
   AFTER INSERT OR DELETE OR UPDATE OF dsa_work_type_id,
                                       type,
                                       last_updated_by
                                       
ON SGAS.DSA_WORK_TYPE FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DSA_WORK_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_WORK_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.DSA_WORK_TYPE_ID;
   p_table_pkey2    DSA_WORK_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_WORK_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_WORK_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_WORK_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_WORK_TYPE_aud.OLD%TYPE            := NULL;
   p_new            DSA_WORK_TYPE_aud.NEW%TYPE            := NULL;
   p_action         DSA_WORK_TYPE_aud.action%TYPE         := NULL;
   p_username       DSA_WORK_TYPE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_WORK_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_WORK_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_WORK_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DSA_WORK_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DSA_WORK_TYPE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'DSA_WORK_TYPE_ID';
   p_old := :OLD.DSA_WORK_TYPE_id;
   p_new := :NEW.DSA_WORK_TYPE_id;
   pk_steps_aud.ins_dsa_wt_aud (p_aud_date,
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
   p_column_name := 'TYPE';
   p_old := TO_CHAR (:OLD.type);
   p_new := TO_CHAR (:NEW.type);
   pk_steps_aud.ins_dsa_wt_aud (p_aud_date,
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
   pk_steps_aud.ins_dsa_wt_aud (p_aud_date,
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
   
END dsa_work_type_iud;
/
SHOW ERRORS;

/*CREATE OR REPLACE TRIGGER sgas.dsa_work_type_lub
   AFTER INSERT OR DELETE OR UPDATE OF last_updated_by
   ON DSA_WORK_TYPE
   FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DSA_WORK_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_WORK_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.DSA_WORK_TYPE_id;
   p_table_pkey2    DSA_WORK_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_WORK_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_WORK_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_WORK_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_WORK_TYPE_aud.OLD%TYPE            := NULL;
   p_new            DSA_WORK_TYPE_aud.NEW%TYPE            := NULL;
   p_action         DSA_WORK_TYPE_aud.action%TYPE         := NULL;
   p_username       DSA_WORK_TYPE_aud.username%TYPE       := USER;
   p_stud_ref_no    DSA_WORK_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_WORK_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_WORK_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_table_pkey1 := :NEW.DSA_WORK_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_dsa_wt_aud (p_aud_date,
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
END dsa_work_type_lub;
/
SHOW ERRORS;*/


ALTER TABLE sgas.dsa_work_type ADD (
  CONSTRAINT dsa_work_type_pk
 PRIMARY KEY
 (dsa_work_type_id)
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
DROP PUBLIC SYNONYM dsa_work_type
/
CREATE PUBLIC SYNONYM dsa_work_type FOR sgas.dsa_work_type
/
DROP SEQUENCE sgas.dsa_work_type_id_seq
/
--
-- dsa_work_type_seq  (Sequence) 
--
CREATE SEQUENCE sgas.dsa_work_type_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_dsa_work_type_seq
   BEFORE INSERT
   ON dsa_work_type
   FOR EACH ROW
BEGIN
   SELECT dsa_work_type_id_seq.NEXTVAL
     INTO :NEW.dsa_work_type_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--
INSERT INTO dsa_work_type
            (type
            )
     VALUES ('Application'
            );
INSERT INTO dsa_work_type
            (type
            )
     VALUES ('Needs Assessment Report'
            );
INSERT INTO dsa_work_type
            (type
            )
     VALUES ('Payments'
            );
INSERT INTO dsa_work_type
            (type
            )
     VALUES ('Missing Information'
            );
INSERT INTO dsa_work_type
            (type
            )
     VALUES ('Referrals'
            );
INSERT INTO dsa_work_type
            (type
            )
     VALUES ('Travel'
            );



COMMIT ;