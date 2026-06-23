-- PAYMENT_METHOD.sql
-- Description: Table holding all PAYMENT_METHODs for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      14.06.09    R Hunter (SAAS)         Initial Version.
-- 1.1      30.06.09    A.Bowman (SAAS)         Amended Audit Triggers.
-- 1.2      08.10.09    A.Bowman (SAAS)         Added new standing data value of CHAPS and FOREIGN BANK TRANSFER, n.b. we do not have legacy info for this
--                                              so dummy values have been used.
-- 1.3      28.01.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.payment_method
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.payment_method CASCADE CONSTRAINTS
/
--
-- PAYMENT_METHOD  (Table) 
--
CREATE TABLE sgas.payment_method
(
  payment_method_id      NUMBER(10)       NOT NULL,
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

COMMENT ON COLUMN sgas.payment_method.payment_method_id IS 'Unique PAYMENT_METHOD reference number';

COMMENT ON COLUMN sgas.payment_method.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.payment_method.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.payment_method.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.payment_method.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX payment_method_pk ON sgas.payment_method
(payment_method_id)
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


CREATE OR REPLACE TRIGGER SGAS.pay_meth_iud
   AFTER INSERT OR DELETE OR UPDATE OF PAYMENT_METHOD_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.PAYMENT_METHOD    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    PAYMENT_METHOD_aud.column_name%TYPE    := NULL;
   p_table_pkey1    PAYMENT_METHOD_aud.table_pkey1%TYPE
                                               := :OLD.PAYMENT_METHOD_id;
   p_table_pkey2    PAYMENT_METHOD_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    PAYMENT_METHOD_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    PAYMENT_METHOD_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    PAYMENT_METHOD_aud.table_pkey5%TYPE    := NULL;
   p_old            PAYMENT_METHOD_aud.OLD%TYPE            := NULL;
   p_new            PAYMENT_METHOD_aud.NEW%TYPE            := NULL;
   p_action         PAYMENT_METHOD_aud.action%TYPE         := NULL;
   p_username       PAYMENT_METHOD_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    PAYMENT_METHOD_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      PAYMENT_METHOD_aud.inst_code%TYPE      := NULL;
   p_session_code   PAYMENT_METHOD_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.PAYMENT_METHOD_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.PAYMENT_METHOD_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'PAYMENT_METHOD_ID';
   p_old := :OLD.PAYMENT_METHOD_id;
   p_new := :NEW.PAYMENT_METHOD_id;
   pk_steps_aud.ins_pay_meth_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_meth_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_meth_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_meth_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_meth_aud (p_aud_date,
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
END pay_meth_iud;
SHOW ERRORS;


ALTER TABLE sgas.payment_method ADD (
  CONSTRAINT payment_method_pk
 PRIMARY KEY
 (payment_method_id)
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
DROP PUBLIC SYNONYM payment_method
/
CREATE PUBLIC SYNONYM payment_method FOR sgas.payment_method
/
DROP SEQUENCE sgas.payment_method_id_seq
/
--
-- PAYMENT_METHOD_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.payment_method_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_payment_method_seq
   BEFORE INSERT
   ON sgas.payment_method
   FOR EACH ROW
BEGIN
   SELECT payment_method_id_seq.NEXTVAL
     INTO :NEW.payment_method_id
     FROM DUAL;
END;                          

--
-- INSERT DATA
--
INSERT INTO payment_method
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'B', 'BACS payment'
            );
INSERT INTO payment_method
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'C', 'Cheque'
            );
INSERT INTO payment_method
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'H', 'CHAPS'
            );
INSERT INTO payment_method
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'F', 'Foreign Bank Transfer'
            );
COMMIT ;