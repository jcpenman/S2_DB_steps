-- PAYEE_PAYMENT.sql
-- Description: Holds total payment record for a payee; equivalent database record of one line from a BACS file
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      22.12.09    A.Bowman (SAAS)         Initial Version.
-- 1.1      07.01.10    A.Bowman (SAAS)         Added Audit Triggers
-- 1.2      28.01.10    A.Bowman (SAAS)         Amended Audit Triggers
-- 1.3      16.03.10    A.Bowman (SAAS)         Added new columns sort_code and account_no
-- 1.4      26.03.10    A.Bowman (SAAS)         Added new columns account_name and payee_ref_id
-- 1.5      18.05.10    A.Bowman (SAAS)         Removed columns account_name, sort_code and account_no....these have been added to Payment_Instalments
-- 1.6      08.11.10    A.Bowman (SAAS)         Added new columns prev_amount and total_payment
-- 1.7      08.11.10    A.Bowman (SAAS)         Added precision to PAYEE_PAYMENT_ID, PAYEE_ID, CREDIT_BATCH_REF
-- 1.8      14.02.11    A.Bowman (SAAS)         Removed column amount_paid as it is no longer required
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author:   $
-- $Date:     $
-- $Revision: $  

ALTER TABLE SGAS.PAYEE_PAYMENT
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.PAYEE_PAYMENT CASCADE CONSTRAINTS PURGE
/

--
-- PAYEE_PAYMENT  (Table) 
--

CREATE TABLE SGAS.PAYEE_PAYMENT
(
  PAYEE_PAYMENT_ID           NUMBER(10) NOT NULL,
  BATCH_REF                  VARCHAR2(7 BYTE) NOT NULL,
  PAYEE_ID                   NUMBER(10),
  PAYEE_REF_ID               NUMBER(10),
  ACCOUNT_NAME               VARCHAR2(100 BYTE),
  SORT_CODE                  VARCHAR2(6 BYTE),
  ACCOUNT_NO                 VARCHAR2(10 BYTE),
  PAYMENT_RUN_DATE           DATE,
  NET_AMOUNT_DUE             NUMBER(9,2),
  TOTAL_IN_RUN               NUMBER(9,2) DEFAULT 0,
  PREV_DEBT                  NUMBER(9,2) DEFAULT 0,
  PAYMENT_METHOD             VARCHAR2(1 BYTE),
  PAYMENT_DATE               DATE NOT NULL,
  RETURNED_DATE              DATE,  
  CURRENCY                   VARCHAR2(3 BYTE) DEFAULT 'GBP',
  PAYMENT_STATUS             VARCHAR2(1 BYTE),
  PROCESS_DATE               DATE,
  LAST_UPDATED_BY            VARCHAR2(15 BYTE)  DEFAULT User NOT NULL,
  LAST_UPDATED_ON            DATE               DEFAULT Sysdate NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          3400K
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

CREATE UNIQUE INDEX PAYEE_PAYMENT_PK ON SGAS.PAYEE_PAYMENT
(PAYEE_PAYMENT_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE PAYEE_PAYMENT ADD (
  CONSTRAINT PAYEE_PAYMENT_PK
 PRIMARY KEY
 (PAYEE_PAYMENT_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));

ALTER TABLE SGAS.PAYEE_PAYMENT ADD (
  CONSTRAINT F1_PYE 
 FOREIGN KEY (PAYEE_ID) 
 REFERENCES SGAS.PAYEE (PAYEE_ID));

ALTER TABLE SGAS.PAYEE_PAYMENT ADD (
  CONSTRAINT F2_PYE 
 FOREIGN KEY (BATCH_REF) 
 REFERENCES SGAS.SCOAP_BATCHES (DPB_BATCH_REF));

ALTER TABLE SGAS.PAYEE_PAYMENT ADD (
  CONSTRAINT PP_TP
 CHECK (NET_AMOUNT_DUE = TOTAL_IN_RUN - PREV_DEBT));

CREATE OR REPLACE TRIGGER SGAS.pay_paymt_iud
   AFTER INSERT OR DELETE OR UPDATE OF PAYEE_PAYMENT_ID,
                                       BATCH_REF,
                                       PAYEE_ID,
                                       PAYEE_REF_ID,
                                       ACCOUNT_NAME,
                                       SORT_CODE,
                                       ACCOUNT_NO,
                                       PAYMENT_RUN_DATE,
                                       NET_AMOUNT_DUE,
                                       TOTAL_IN_RUN,
                                       PREV_DEBT,
                                       PAYMENT_METHOD,
                                       PAYMENT_DATE,
                                       RETURNED_DATE,  
                                       CURRENCY,
                                       PAYMENT_STATUS,
                                       PROCESS_DATE,
                                       LAST_UPDATED_BY
ON SGAS.PAYEE_PAYMENT FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    PAYEE_PAYMENT_aud.column_name%TYPE    := NULL;
   p_table_pkey1    PAYEE_PAYMENT_aud.table_pkey1%TYPE
                                               := :OLD.PAYEE_PAYMENT_ID;
   p_table_pkey2    PAYEE_PAYMENT_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    PAYEE_PAYMENT_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    PAYEE_PAYMENT_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    PAYEE_PAYMENT_aud.table_pkey5%TYPE    := NULL;
   p_old            PAYEE_PAYMENT_aud.OLD%TYPE            := NULL;
   p_new            PAYEE_PAYMENT_aud.NEW%TYPE            := NULL;
   p_action         PAYEE_PAYMENT_aud.action%TYPE         := NULL;
   p_username       PAYEE_PAYMENT_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    PAYEE_PAYMENT_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      PAYEE_PAYMENT_aud.inst_code%TYPE      := NULL;
   p_session_code   PAYEE_PAYMENT_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.payee_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.payee_payment_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'PAYEE_PAYMENT_ID';
   p_old := :OLD.payee_payment_id;
   p_new := :NEW.payee_payment_id;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'PAYEE_ID';
   p_old := :OLD.PAYEE_ID;
   p_new := :NEW.PAYEE_ID;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'PAYEE_REF_ID';
   p_old := :OLD.PAYEE_REF_ID;
   p_new := :NEW.PAYEE_REF_ID;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'ACCOUNT_NAME';
   p_old := :OLD.ACCOUNT_NAME;
   p_new := :NEW.ACCOUNT_NAME;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'SORT_CODE';
   p_old := :OLD.SORT_CODE;
   p_new := :NEW.SORT_CODE;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'ACCOUNT_NO';
   p_old := :OLD.ACCOUNT_NO;
   p_new := :NEW.ACCOUNT_NO;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_RUN_DATE';
   p_old := :OLD.PAYMENT_RUN_DATE;
   p_new := :NEW.PAYMENT_RUN_DATE;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'NET_AMOUNT_DUE';
   p_old := :OLD.NET_AMOUNT_DUE;
   p_new := :NEW.NET_AMOUNT_DUE;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'TOTAL_IN_RUN';
   p_old := :OLD.TOTAL_IN_RUN;
   p_new := :NEW.TOTAL_IN_RUN;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'PREV_DEBT';
   p_old := :OLD.PREV_DEBT;
   p_new := :NEW.PREV_DEBT;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_METHOD';
   p_old := :OLD.PAYMENT_METHOD;
   p_new := :NEW.PAYMENT_METHOD;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_DATE';
   p_old := :OLD.PAYMENT_DATE;
   p_new := :NEW.PAYMENT_DATE;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'RETURNED_DATE';
   p_old := :OLD.RETURNED_DATE;
   p_new := :NEW.RETURNED_DATE;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'CURRENCY';
   p_old := :OLD.CURRENCY;
   p_new := :NEW.CURRENCY;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_STATUS';
   p_old := :OLD.PAYMENT_STATUS;
   p_new := :NEW.PAYMENT_STATUS;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   
END pay_paymt_iud;

SHOW ERRORS;

GRANT SELECT ON PAYEE_PAYMENT TO PUBLIC;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM PAYEE_PAYMENT
/

CREATE PUBLIC SYNONYM PAYEE_PAYMENT FOR SGAS.PAYEE_PAYMENT
/

DROP SEQUENCE SGAS.PAYEE_PAYMT_ID_SEQ
/
--
-- PAYEE_PAYMT_ID_SEQ  (Sequence) 
--
CREATE SEQUENCE SGAS.PAYEE_PAYMT_ID_SEQ
  START WITH 1
  MAXVALUE 9999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/

CREATE OR REPLACE TRIGGER SGAS.TRIG_PAYEE_PAYMT_SEQ 
   BEFORE INSERT
   ON SGAS.PAYEE_PAYMENT
   FOR EACH ROW
BEGIN
   SELECT PAYEE_PAYMT_ID_SEQ.NEXTVAL
     INTO :NEW.PAYEE_PAYMENT_ID
     FROM DUAL;
END;