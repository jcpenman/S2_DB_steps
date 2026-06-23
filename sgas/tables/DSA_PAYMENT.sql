-- DSA_PAYMENT.sql
-- Description: Table holding all DSA_PAYMENT data for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      24.09.09    R Hunter (SAAS)         Initial Version.
-- 1.1      24.09.09    A.Bowman (SAAS)         Added Audit Triggers
-- 1.2      16.11.09    A.Bowman (SAAS)         Added the following columns
--                                              amount_rate, reference, period_start_date, period_end_date, receipt_required, receipt_received,
--                                              receipt_amount, invoice_ref and notes and also updated audit trigger accordingly.
--
-- 1.3      28.01.10    A.Bowman (SAAS)         Amended audit triggers
-- 1.4      05.05.10    A.Bowman (SAAS)         Added foreign key references
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.DSA_PAYMENT
 DROP PRIMARY KEY CASCADE
/

DROP TABLE sgas.DSA_PAYMENT CASCADE CONSTRAINTS PURGE
/

--
-- DSA_PAYMENT  (Table) 
--
CREATE TABLE sgas.DSA_PAYMENT
(
  ID                   NUMBER(10) NOT NULL,
  AWARD_INSTALMENT_ID  NUMBER(10),
  DSA_ALLOWANCE_ID     NUMBER(10),
  PAYEE_TYPE           VARCHAR2(1 BYTE), --S or N
  PAYEE_ID             NUMBER(10), --stud_ref_no or nominee_id
  AMOUNT               NUMBER(15,2),
  PAYMENT_METHOD_ID    NUMBER(10),
  BATCH_DATE           DATE,
  PROCESS_DATE         DATE,
  DSA_PAYMENT_STATUS_ID NUMBER(10),
  PAYMENT_TYPE         VARCHAR2(7), --PAYMENT OR RECEIPT
  BATCH_REF            VARCHAR2(100),
  RE_ISSUE_FLAG        VARCHAR2(1 BYTE)           DEFAULT 'N',
  amount_rate VARCHAR2(100),                             --per hour per day...
  REFERENCE           VARCHAR2(100 BYTE),
  period_start_date   DATE,
  period_end_date     DATE,
  receipt_required    VARCHAR2(1 BYTE)           DEFAULT 'N',
  receipt_received    VARCHAR2(1 BYTE)           DEFAULT 'N',
  receipt_amount      NUMBER(15,2),
  invoice_ref         VARCHAR2(100 BYTE),
  notes               VARCHAR2(100 BYTE),
  LAST_UPDATED_BY      VARCHAR2(15 BYTE)          DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON      DATE                       DEFAULT SYSDATE               NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

CREATE UNIQUE INDEX dsa_payment_pk ON sgas.dsa_payment
(id)
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


CREATE OR REPLACE TRIGGER SGAS.DSA_PAY_iud
   AFTER INSERT OR DELETE OR UPDATE OF ID,
                                       AWARD_INSTALMENT_ID,
                                       DSA_ALLOWANCE_ID,     
                                       PAYEE_TYPE,             
                                       PAYEE_ID,             
                                       AMOUNT,           
                                       PAYMENT_METHOD_ID,                                           
                                       BATCH_DATE,           
                                       PROCESS_DATE,         
                                       DSA_PAYMENT_STATUS_ID, 
                                       PAYMENT_TYPE,         
                                       BATCH_REF,            
                                       RE_ISSUE_FLAG,
                                       LAST_UPDATED_BY 
ON SGAS.DSA_PAYMENT FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DSA_PAYMENT_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_PAYMENT_aud.table_pkey1%TYPE
                                               := :OLD.ID;
   p_table_pkey2    DSA_PAYMENT_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_PAYMENT_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_PAYMENT_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_PAYMENT_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_PAYMENT_aud.OLD%TYPE            := NULL;
   p_new            DSA_PAYMENT_aud.NEW%TYPE            := NULL;
   p_action         DSA_PAYMENT_aud.action%TYPE         := NULL;
   p_username       DSA_PAYMENT_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_PAYMENT_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_PAYMENT_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_PAYMENT_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'ID';
   p_old := :OLD.id;
   p_new := :NEW.id;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'AWARD_INSTALMENT_ID';
   p_old := :OLD.AWARD_INSTALMENT_ID;
   p_new := :NEW.AWARD_INSTALMENT_ID;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'DSA_ALLOWANCE_ID';
   p_old := :OLD.DSA_ALLOWANCE_ID;
   p_new := :NEW.DSA_ALLOWANCE_ID;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'PAYEE_TYPE';
   p_old := :OLD.PAYEE_TYPE;
   p_new := :NEW.PAYEE_TYPE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'AMOUNT';
   p_old := :OLD.AMOUNT;
   p_new := :NEW.AMOUNT;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_METHOD_ID';
   p_old := :OLD.PAYMENT_METHOD_ID;
   p_new := :NEW.PAYMENT_METHOD_ID;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'BATCH_DATE';
   p_old := :OLD.BATCH_DATE;
   p_new := :NEW.BATCH_DATE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'PROCESS_DATE';
   p_old := :OLD.PROCESS_DATE;
   p_new := :NEW.PROCESS_DATE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'DSA_PAYMENT_STATUS_ID';
   p_old := :OLD.DSA_PAYMENT_STATUS_ID;
   p_new := :NEW.DSA_PAYMENT_STATUS_ID;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_TYPE';
   p_old := :OLD.PAYMENT_TYPE;
   p_new := :NEW.PAYMENT_TYPE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'BATCH_REF';
   p_old := :OLD.BATCH_REF;
   p_new := :NEW.BATCH_REF;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'RE_ISSUE_FLAG';
   p_old := :OLD.RE_ISSUE_FLAG;
   p_new := :NEW.RE_ISSUE_FLAG;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'AMOUNT_RATE';
   p_old := :OLD.AMOUNT_RATE;
   p_new := :NEW.AMOUNT_RATE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'REFERENCE';
   p_old := :OLD.REFERENCE;
   p_new := :NEW.REFERENCE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'PERIOD_START_DATE';
   p_old := :OLD.PERIOD_START_DATE;
   p_new := :NEW.PERIOD_START_DATE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'PERIOD_END_DATE';
   p_old := :OLD.PERIOD_END_DATE;
   p_new := :NEW.PERIOD_END_DATE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'RECEIPT_REQUIRED';
   p_old := :OLD.RECEIPT_REQUIRED;
   p_new := :NEW.RECEIPT_REQUIRED;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'RECEIPT_RECEIVED';
   p_old := :OLD.RECEIPT_RECEIVED;
   p_new := :NEW.RECEIPT_RECEIVED;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'RECEIPT_AMOUNT';
   p_old := :OLD.RECEIPT_AMOUNT;
   p_new := :NEW.RECEIPT_AMOUNT;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'INVOICE_REF';
   p_old := :OLD.INVOICE_REF;
   p_new := :NEW.INVOICE_REF;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'NOTES';
   p_old := :OLD.NOTES;
   p_new := :NEW.NOTES;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
END DSA_PAY_iud;
SHOW ERRORS;

ALTER TABLE sgas.dsa_payment ADD (
  CONSTRAINT dsa_payment_pk
 PRIMARY KEY
 (id)
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

ALTER TABLE SGAS.DSA_PAYMENT ADD (
  CONSTRAINT F1_DSAPAY 
 FOREIGN KEY (AWARD_INSTALMENT_ID) 
 REFERENCES SGAS.AWARD_INSTALMENT (AWARD_INSTALMENT_ID));

ALTER TABLE SGAS.DSA_PAYMENT ADD (
  CONSTRAINT F2_DSAPAY 
 FOREIGN KEY (DSA_ALLOWANCE_ID) 
 REFERENCES SGAS.DSA_ALLOWANCE (ID));

ALTER TABLE SGAS.DSA_PAYMENT ADD (
  CONSTRAINT F3_DSAPAY 
 FOREIGN KEY (DSA_PAYMENT_STATUS_ID) 
 REFERENCES SGAS.DSA_PAYMENT_STATUS (DSA_PAYMENT_STATUS_ID));


-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM dsa_payment
/
CREATE PUBLIC SYNONYM dsa_payment FOR sgas.dsa_payment
/
DROP SEQUENCE sgas.dsa_payment_id_seq
/
--
-- DSA_PAYMENT_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.dsa_payment_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_dsa_payment_id_seq
   BEFORE INSERT
   ON sgas.dsa_payment
   FOR EACH ROW
BEGIN
   SELECT dsa_payment_id_seq.NEXTVAL
     INTO :NEW.id
     FROM DUAL;
END; 
/                                                                     

COMMIT;

