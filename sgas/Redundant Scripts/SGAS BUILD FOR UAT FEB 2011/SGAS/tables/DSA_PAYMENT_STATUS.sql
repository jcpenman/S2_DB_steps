-- DSA_PAYMENT_STATUS.sql
-- Description: Table holding all DSA Payment Status' for SGAS
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      23.09.09    A.Bowman (SAAS)         Initial Version.
-- 1.1      28.01.10    A.Bowman (SAAS)         Amended audit triggers
-- 
-- 
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.DSA_PAYMENT_STATUS
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.DSA_PAYMENT_STATUS CASCADE CONSTRAINTS
/
--
-- DSA_PAYMENT_STATUS  (Table) 
--
CREATE TABLE sgas.DSA_PAYMENT_STATUS
(
  DSA_PAYMENT_STATUS_id      NUMBER(10)       NOT NULL,
  status                     VARCHAR2(32 BYTE) NOT NULL,
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

COMMENT ON COLUMN sgas.DSA_PAYMENT_STATUS.DSA_PAYMENT_STATUS_id IS 'Unique DSA_PAYMENT_STATUS reference number';

COMMENT ON COLUMN sgas.DSA_PAYMENT_STATUS.status IS 'Unique dsa status description';

COMMENT ON COLUMN sgas.DSA_PAYMENT_STATUS.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.DSA_PAYMENT_STATUS.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX DSA_PAYMENT_STATUS_pk ON sgas.DSA_PAYMENT_STATUS
(DSA_PAYMENT_STATUS_id)
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


CREATE OR REPLACE TRIGGER SGAS.dsa_pay_stat_iud
   AFTER INSERT OR DELETE OR UPDATE OF DSA_PAYMENT_STATUS_id,
                                       status,
                                       last_updated_by
                                       
ON SGAS.DSA_PAYMENT_STATUS FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DSA_PAYMENT_STATUS_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_PAYMENT_STATUS_aud.table_pkey1%TYPE
                                               := :OLD.DSA_PAYMENT_STATUS_ID;
   p_table_pkey2    DSA_PAYMENT_STATUS_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_PAYMENT_STATUS_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_PAYMENT_STATUS_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_PAYMENT_STATUS_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_PAYMENT_STATUS_aud.OLD%TYPE            := NULL;
   p_new            DSA_PAYMENT_STATUS_aud.NEW%TYPE            := NULL;
   p_action         DSA_PAYMENT_STATUS_aud.action%TYPE         := NULL;
   p_username       DSA_PAYMENT_STATUS_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_PAYMENT_STATUS_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_PAYMENT_STATUS_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_PAYMENT_STATUS_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DSA_PAYMENT_STATUS_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DSA_PAYMENT_STATUS_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'DSA_PAYMENT_STATUS_ID';
   p_old := :OLD.DSA_PAYMENT_STATUS_id;
   p_new := :NEW.DSA_PAYMENT_STATUS_id;
   pk_steps_aud.ins_DSA_PAY_STAT_aud (p_aud_date,
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
   p_column_name := 'STATUS';
   p_old := TO_CHAR (:OLD.status);
   p_new := TO_CHAR (:NEW.status);
   pk_steps_aud.ins_DSA_PAY_STAT_aud (p_aud_date,
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
   pk_steps_aud.ins_DSA_PAY_STAT_aud (p_aud_date,
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
END DSA_PAY_STAT_iud;
SHOW ERRORS;

ALTER TABLE sgas.DSA_PAYMENT_STATUS ADD (
  CONSTRAINT DSA_PAYMENT_STATUS_pk
 PRIMARY KEY
 (DSA_PAYMENT_STATUS_id)
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
DROP PUBLIC SYNONYM DSA_PAYMENT_STATUS
/
CREATE PUBLIC SYNONYM DSA_PAYMENT_STATUS FOR sgas.DSA_PAYMENT_STATUS
/
DROP SEQUENCE sgas.DSA_PAY_STAT_id_seq
/
--
-- DSA_PAYMENT_STATUS_seq  (Sequence) 
--
CREATE SEQUENCE sgas.DSA_PAY_STAT_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_DSA_PAY_STAT_seq
   BEFORE INSERT
   ON SGAS.DSA_PAYMENT_STATUS
   FOR EACH ROW
BEGIN
   SELECT DSA_PAY_STAT_id_seq.NEXTVAL
     INTO :NEW.DSA_PAYMENT_STATUS_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--
INSERT INTO DSA_PAYMENT_STATUS
            (status
            )
     VALUES ('Awaiting Payment' 
            );
INSERT INTO DSA_PAYMENT_STATUS
            (status
            )
     VALUES ('Paid'
            );
INSERT INTO DSA_PAYMENT_STATUS
            (status
            )
     VALUES ('Failed'
            );
INSERT INTO DSA_PAYMENT_STATUS
            (status
            )
     VALUES ('Returned'
            );


COMMIT ;