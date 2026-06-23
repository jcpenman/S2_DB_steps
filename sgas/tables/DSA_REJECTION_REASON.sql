-- DSA_REJECTION_REASON.sql
-- Description: Table holding all DSA Rejection Reasons for SGAS
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      22.09.09    A.Bowman (SAAS)         Initial Version.
-- 1.1      28.01.10    A.Bowman (SAAS)         Amended audit triggers
-- 
-- 
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.DSA_REJECTION_REASON
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.DSA_REJECTION_REASON CASCADE CONSTRAINTS
/
--
-- DSA_REJECTION_REASON  (Table) 
--
CREATE TABLE sgas.DSA_REJECTION_REASON
(
  DSA_REJECTION_REASON_id     NUMBER(10) NOT NULL,
  reason                     VARCHAR2(80 BYTE) NOT NULL,
  last_updated_by            VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  last_updated_on            DATE                     DEFAULT SYSDATE               NOT NULL
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

COMMENT ON COLUMN sgas.DSA_REJECTION_REASON.DSA_REJECTION_REASON_id IS 'Unique DSA_REJECTION_REASON reference number';

COMMENT ON COLUMN sgas.DSA_REJECTION_REASON.reason IS 'Unique DSA rejection reason';

COMMENT ON COLUMN sgas.DSA_REJECTION_REASON.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.DSA_REJECTION_REASON.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX DSA_REJECTION_REASON_pk ON sgas.DSA_REJECTION_REASON
(DSA_REJECTION_REASON_id)
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


CREATE OR REPLACE TRIGGER SGAS.dsa_rej_iud
AFTER INSERT OR DELETE OR UPDATE OF DSA_REJECTION_REASON_id,
                                       reason,
                                       last_updated_by
ON SGAS.DSA_REJECTION_REASON FOR EACH ROW
DECLARE
   p_aud_date       DATE                                 := SYSDATE;
   p_column_name    DSA_REJECTION_REASON_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_REJECTION_REASON_aud.table_pkey1%TYPE := :OLD.DSA_REJECTION_REASON_id;
   p_table_pkey2    DSA_REJECTION_REASON_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_REJECTION_REASON_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_REJECTION_REASON_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_REJECTION_REASON_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_REJECTION_REASON_aud.OLD%TYPE            := NULL;
   p_new            DSA_REJECTION_REASON_aud.NEW%TYPE            := NULL;
   p_action         DSA_REJECTION_REASON_aud.action%TYPE         := NULL;
   p_username       DSA_REJECTION_REASON_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_REJECTION_REASON_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_REJECTION_REASON_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_REJECTION_REASON_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DSA_REJECTION_REASON_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DSA_REJECTION_REASON_id;
      p_username := :OLD.LAST_UPDATED_BY;   
   END IF;

   p_column_name := 'DSA_REJECTION_REASON_ID';
   p_old := :OLD.DSA_REJECTION_REASON_id;
   p_new := :NEW.DSA_REJECTION_REASON_id;
   pk_steps_aud.ins_dsa_rej_aud (p_aud_date,
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
   p_column_name := 'REASON';
   p_old := :OLD.REASON;
   p_new := :NEW.REASON;
   pk_steps_aud.ins_dsa_rej_aud (p_aud_date,
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
   pk_steps_aud.ins_dsa_rej_aud (p_aud_date,
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
END dsa_rej_iud;
SHOW ERRORS;


ALTER TABLE sgas.DSA_REJECTION_REASON ADD (
  CONSTRAINT DSA_REJECTION_REASON_pk
 PRIMARY KEY
 (DSA_REJECTION_REASON_id)
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
DROP PUBLIC SYNONYM DSA_REJECTION_REASON
/
CREATE PUBLIC SYNONYM DSA_REJECTION_REASON FOR sgas.DSA_REJECTION_REASON
/
DROP SEQUENCE sgas.dsa_rej_id_seq
/
--
-- DSA_REJECTION_REASON_seq  (Sequence) 
--
CREATE SEQUENCE sgas.dsa_rej_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_dsa_rej_seq
   BEFORE INSERT
   ON SGAS.DSA_REJECTION_REASON
   FOR EACH ROW
BEGIN
   SELECT dsa_rej_id_seq.NEXTVAL
     INTO :NEW.DSA_REJECTION_REASON_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--
INSERT INTO DSA_REJECTION_REASON
            (reason
            )
     VALUES ('EU Student'
            );
INSERT INTO DSA_REJECTION_REASON
            (reason
            )
     VALUES ('Residence'
            );
INSERT INTO DSA_REJECTION_REASON
            (reason
            )
     VALUES ('No Disability/recommendations'
            );
INSERT INTO DSA_REJECTION_REASON
            (reason
            )
     VALUES ('Large items maximum reached'
            );
INSERT INTO DSA_REJECTION_REASON
            (reason
            )
     VALUES ('Course not SAAS funded'
            );
INSERT INTO DSA_REJECTION_REASON
            (reason
            )
     VALUES ('Other'
            );
COMMIT ;