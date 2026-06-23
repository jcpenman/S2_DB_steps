-- PAYMENT_INSTALMENT.sql
-- Description: Holds a detailed payment record for award instalments.
--
--              
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      22.12.09    A.Bowman (SAAS)         Initial Version.
-- 1.1      28.01.10    A.Bowman (SAAS)         Amended audit triggers
-- 1.2      21.04.10    A.Bowman (SAAS)         Added new column adi_jornal_line_id
-- 1.3      18.05.10    A.Bowman (SAAS)         Added new columns stud_crse_year_id, account_name, sort_code, account_no, inst_code and payment_addr
-- 1.4      01.06.10    A.Bowman (SAAS)         Added new constraints
-- 1.5      07.06.10    A.Bowman (SAAS)         Added new columns stud_ref_no and sub_type
-- 1.6      11.06.10    A.Bowman (SAAS)         Added new columns payee_addrl1, payee_addrl2, payee_addrl3, payee_postcode
-- 1.7      21.10.10    A.Bowman (SAAS)         Added new column payment_run_date
-- 1.8      08.11.10    A.Bowman (SAAS)         Added precision to the PAYMENT_INSTALMENT_ID, PAYEE_PAYMENT_ID, ADI_JOURNAL_LINE_ID, ADI_JOURNAL_ID, AWARD_INSTALMENT_ID, PAYEE_ID
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author:   $
-- $Date:     $
-- $Revision: $  

ALTER TABLE SGAS.PAYMENT_INSTALMENT
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.PAYMENT_INSTALMENT CASCADE CONSTRAINTS PURGE
/

--
-- PAYMENT_INSTALMENT  (Table) 
--

CREATE TABLE SGAS.PAYMENT_INSTALMENT
(
  PAYMENT_INSTALMENT_ID          NUMBER(10) NOT NULL,
  BATCH_REF                      VARCHAR2(7 BYTE) NOT NULL,
  PAYEE_PAYMENT_ID               NUMBER(10),
  ADI_JOURNAL_LINE_ID            NUMBER(10),
  ADI_JOURNAL_ID                 NUMBER(10),
  AWARD_INSTALMENT_ID            NUMBER(10) NOT NULL,
  PAYEE_ID                       NUMBER(10) NOT NULL,
  STUD_CRSE_YEAR_ID              NUMBER(9) NOT NULL,
  ACCOUNT_NAME                   VARCHAR2(100 BYTE) NOT NULL,
  SORT_CODE                      VARCHAR2(6 BYTE),
  ACCOUNT_NO                     VARCHAR2(10 BYTE),
  INST_CODE                      VARCHAR2(5 BYTE) NOT NULL,
  PAYMENT_ADDR                   VARCHAR2(1 BYTE) NOT NULL,
  PAYMENT_AMOUNT                 NUMBER(9,2) NOT NULL,
  PAYMENT_METHOD                 VARCHAR2(1 BYTE) NOT NULL,
  PAYMENT_DATE                   DATE NOT NULL,
  PAYMENT_RUN_DATE               DATE,
  RETURNED_DATE                  DATE,
  CURRENCY                       VARCHAR2(3 BYTE) DEFAULT 'GBP',
  PAYMENT_STATUS                 VARCHAR2(1 BYTE) NOT NULL,
  PROCESS_DATE                   DATE NOT NULL,
  ENTITY                         VARCHAR2(3 BYTE) DEFAULT '600' NOT NULL,
  COST_CENTRE                    VARCHAR2(6 BYTE) NOT NULL,
  ACCOUNT                        VARCHAR2(8 BYTE) NOT NULL,
  PROGRAMME                      VARCHAR2(3 BYTE) NOT NULL,
  STUD_REF_NO                    NUMBER(10) NOT NULL,
  SUB_TYPE                       VARCHAR2(2 BYTE) NOT NULL,
  PAYEE_ADDRL1                   VARCHAR2(30),
  PAYEE_ADDRL2                   VARCHAR2(30),
  PAYEE_ADDRL3                   VARCHAR2(30),
  PAYEE_POSTCODE                 VARCHAR2(10),
  LAST_UPDATED_BY                VARCHAR2(15 BYTE)  DEFAULT User NOT NULL,
  LAST_UPDATED_ON                DATE               DEFAULT Sysdate NOT NULL  


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

CREATE UNIQUE INDEX PAYMENT_INSTALMENT_PK ON SGAS.PAYMENT_INSTALMENT
(PAYMENT_INSTALMENT_ID)
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


ALTER TABLE PAYMENT_INSTALMENT ADD (
  CONSTRAINT PAYMENT_INSTALMENT_PK
 PRIMARY KEY
 (PAYMENT_INSTALMENT_ID)
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

CREATE OR REPLACE TRIGGER SGAS.pay_inst_iud
   AFTER INSERT OR DELETE OR UPDATE OF PAYMENT_INSTALMENT_ID,
                                       BATCH_REF,
                                       PAYEE_PAYMENT_ID,
                                       ADI_JOURNAL_LINE_ID,
                                       ADI_JOURNAL_ID,
                                       AWARD_INSTALMENT_ID,
                                       PAYEE_ID,
                                       STUD_CRSE_YEAR_ID,
                                       ACCOUNT_NAME,
                                       SORT_CODE,
                                       ACCOUNT_NO,
                                       INST_CODE,
                                       PAYMENT_ADDR,
                                       PAYMENT_AMOUNT,
                                       PAYMENT_METHOD,
                                       PAYMENT_DATE,
                                       RETURNED_DATE,
                                       CURRENCY,
                                       PAYMENT_STATUS,
                                       PROCESS_DATE,
                                       ENTITY,
                                       COST_CENTRE,
                                       ACCOUNT,
                                       PROGRAMME,
                                       STUD_REF_NO,
                                       SUB_TYPE,
                                       PAYEE_ADDRL1,
                                       PAYEE_ADDRL2,
                                       PAYEE_ADDRL3,
                                       PAYEE_POSTCODE,
                                       LAST_UPDATED_BY
ON SGAS.PAYMENT_INSTALMENT FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    PAYMENT_INSTALMENT_aud.column_name%TYPE    := NULL;
   p_table_pkey1    PAYMENT_INSTALMENT_aud.table_pkey1%TYPE
                                               := :OLD.PAYMENT_INSTALMENT_ID;
   p_table_pkey2    PAYMENT_INSTALMENT_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    PAYMENT_INSTALMENT_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    PAYMENT_INSTALMENT_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    PAYMENT_INSTALMENT_aud.table_pkey5%TYPE    := NULL;
   p_old            PAYMENT_INSTALMENT_aud.OLD%TYPE            := NULL;
   p_new            PAYMENT_INSTALMENT_aud.NEW%TYPE            := NULL;
   p_action         PAYMENT_INSTALMENT_aud.action%TYPE         := NULL;
   p_username       PAYMENT_INSTALMENT_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    PAYMENT_INSTALMENT_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      PAYMENT_INSTALMENT_aud.inst_code%TYPE      := NULL;
   p_session_code   PAYMENT_INSTALMENT_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.PAYMENT_INSTALMENT_ID;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.PAYMENT_INSTALMENT_ID;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'PAYMENT_INSTALMENT_ID';
   p_old := :OLD.PAYMENT_INSTALMENT_ID;
   p_new := :NEW.PAYMENT_INSTALMENT_ID;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYEE_PAYMENT_ID';
   p_old := :OLD.PAYEE_PAYMENT_ID;
   p_new := :NEW.PAYEE_PAYMENT_ID;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'ADI_JOURNAL_LINE_ID';
   p_old := :OLD.ADI_JOURNAL_LINE_ID;
   p_new := :NEW.ADI_JOURNAL_LINE_ID;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'ADI_JOURNAL_ID';
   p_old := :OLD.ADI_JOURNAL_ID;
   p_new := :NEW.ADI_JOURNAL_ID;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'STUD_CRSE_YEAR_ID';
   p_old := :OLD.STUD_CRSE_YEAR_ID;
   p_new := :NEW.STUD_CRSE_YEAR_ID;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'INST_CODE';
   p_old := :OLD.INST_CODE;
   p_new := :NEW.INST_CODE;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_ADDR';
   p_old := :OLD.PAYMENT_ADDR;
   p_new := :NEW.PAYMENT_ADDR;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_AMOUNT';
   p_old := :OLD.PAYMENT_AMOUNT;
   p_new := :NEW.PAYMENT_AMOUNT;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'ENTITY';
   p_old := :OLD.ENTITY;
   p_new := :NEW.ENTITY;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'COST_CENTRE';
   p_old := :OLD.COST_CENTRE;
   p_new := :NEW.COST_CENTRE;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'ACCOUNT';
   p_old := :OLD.ACCOUNT;
   p_new := :NEW.ACCOUNT;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PROGRAMME';
   p_old := :OLD.PROGRAMME;
   p_new := :NEW.PROGRAMME;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'STUD_REF_NO';
   p_old := :OLD.STUD_REF_NO;
   p_new := :NEW.STUD_REF_NO;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'SUB_TYPE';
   p_old := :OLD.SUB_TYPE;
   p_new := :NEW.SUB_TYPE;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYEE_ADDRL1';
   p_old := :OLD.PAYEE_ADDRL1;
   p_new := :NEW.PAYEE_ADDRL1;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYEE_ADDRL2';
   p_old := :OLD.PAYEE_ADDRL2;
   p_new := :NEW.PAYEE_ADDRL2;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYEE_ADDRL3';
   p_old := :OLD.PAYEE_ADDRL3;
   p_new := :NEW.PAYEE_ADDRL3;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYEE_POSTCODE';
   p_old := :OLD.PAYEE_POSTCODE;
   p_new := :NEW.PAYEE_POSTCODE;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
END pay_inst_iud;
SHOW ERRORS;


ALTER TABLE SGAS.PAYMENT_INSTALMENT ADD (
  CONSTRAINT F1_PINST 
 FOREIGN KEY (STUD_CRSE_YEAR_ID) 
 REFERENCES SGAS.STUD_CRSE_YEAR (STUD_CRSE_YEAR_ID));

ALTER TABLE SGAS.PAYMENT_INSTALMENT ADD (
  CONSTRAINT F2_PINST 
 FOREIGN KEY (AWARD_INSTALMENT_ID) 
 REFERENCES SGAS.AWARD_INSTALMENT (AWARD_INSTALMENT_ID));

ALTER TABLE SGAS.PAYMENT_INSTALMENT ADD (
  CONSTRAINT F3_PINST 
 FOREIGN KEY (BATCH_REF) 
 REFERENCES SGAS.SCOAP_BATCHES (DPB_BATCH_REF));

ALTER TABLE SGAS.PAYMENT_INSTALMENT ADD (
  CONSTRAINT F4_PINST 
 FOREIGN KEY (PAYEE_PAYMENT_ID) 
 REFERENCES SGAS.PAYEE_PAYMENT (PAYEE_PAYMENT_ID));

ALTER TABLE SGAS.PAYMENT_INSTALMENT ADD (
  CONSTRAINT F5_PINST 
 FOREIGN KEY (PAYEE_ID) 
 REFERENCES SGAS.PAYEE (PAYEE_ID));

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM PAYMENT_INSTALMENT
/
CREATE PUBLIC SYNONYM PAYMENT_INSTALMENT FOR SGAS.PAYMENT_INSTALMENT
/
DROP SEQUENCE SGAS.PAY_INST_ID_SEQ
/
--
-- PAY_INST_ID_seq  (Sequence) 
--

CREATE SEQUENCE SGAS.PAY_INST_ID_SEQ
  START WITH 1
  MAXVALUE 9999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/

CREATE OR REPLACE TRIGGER SGAS.TRIG_PAY_INST_SEQ 
   BEFORE INSERT
   ON SGAS.PAYMENT_INSTALMENT
   FOR EACH ROW
BEGIN
   SELECT PAY_INST_ID_SEQ.NEXTVAL
     INTO :NEW.PAYMENT_INSTALMENT_ID
     FROM DUAL;
END;

ALTER TABLE SGAS.PAYMENT_INSTALMENT ADD (
  CONSTRAINT CHECK_ACC_NO
 CHECK ((account_no IS NULL AND
    payment_method = 'C') OR (account_no IS NOT NULL AND
    payment_method != 'C')));

ALTER TABLE SGAS.PAYMENT_INSTALMENT ADD (
  CONSTRAINT CHECK_SORT_CODE
 CHECK ((sort_code IS NULL AND
    payment_method = 'C') OR (sort_code IS NOT NULL AND
    payment_method != 'C')));

ALTER TABLE SGAS.PAYMENT_INSTALMENT ADD (
  CONSTRAINT CHECK_PAYEE_ADDRL1
 CHECK ((PAYEE_ADDRL1 IS NOT NULL AND
    payment_method = 'C') OR (PAYEE_ADDRL1 IS NULL AND
    payment_method != 'C')));
    
ALTER TABLE SGAS.PAYMENT_INSTALMENT ADD (
  CONSTRAINT CHECK_PAYEE_ADDRL2
 CHECK ((PAYEE_ADDRL2 IS NOT NULL AND
    payment_method = 'C') OR (PAYEE_ADDRL2 IS NULL AND
    payment_method != 'C')));
    
ALTER TABLE SGAS.PAYMENT_INSTALMENT ADD (
  CONSTRAINT CHECK_PAYEE_POSTCODE
 CHECK ((PAYEE_POSTCODE IS NOT NULL AND
    payment_method = 'C') OR (PAYEE_POSTCODE IS NULL AND
    payment_method != 'C')));
