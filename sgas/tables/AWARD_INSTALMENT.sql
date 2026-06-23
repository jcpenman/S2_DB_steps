-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY
-- REF  DATE        AUTHOR          DESCRIPTION
-- 010  16.11.12    A.Bowman (SAAS) Added new column adhoc_type
-- 009  11.03.11    A.Bowman (SAAS) Added new functionality to AWI_IUD trigger to update changed since last report flag on attendance_data table
-- 008  23.11.10    A.Bowman (SAAS) Removed redundant column DSA_ALLOWANCE_ID
-- 007  08.11.10    A.Bowman (SAAS) Added precision to AWARD_INSTALMENT_ID
-- 006  05.10.10    A.Bowman (SAAS) Added new column 'CHAPS' and associated constraint
-- 005  14.09.10    A.Bowman (SAAS) Amended trig for id seq
-- 004  16.06.10    A.Bowman (SAAS) DSA_ARRANGEMENT_ID renamed DSA_ALLOWANCE_ID
-- 003  06.05.10    A.Bowman (SAAS) Added foreign key references
-- 002  28.01.10    A.Bowman (SAAS) Amended audit triggers
-- 001  22.06.09    A.Bowman (SAAS) Added audit triggers 
-- DSA  11.02.08    Steve Durkin    Add columns to record DSA claims including
--                                  - receipts. -- Receipts will be required in some instances only. Status for receipts may be one of:  
--                                                  Y - yes 
--                                                  N - no 
--                                                  U - uneeded 
--                                  - invoices.
--                                  - student_nominee_id.                     
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/AWARD_INSTALMENT.sql $
-- $Author: $
-- $Date: 2012-11-16 10:54:25 +0000 (Fri, 16 Nov 2012) $
-- $Revision: 8336 $


DROP TABLE SGAS.AWARD_INSTALMENT CASCADE CONSTRAINTS
/

--
-- AWARD_INSTALMENT  (Table) 
--
CREATE TABLE SGAS.AWARD_INSTALMENT
(
  AWARD_INSTALMENT_ID           NUMBER(10)          NOT NULL,
  AWARD_ID                      NUMBER(10) CONSTRAINT NN_AWI_AWARD_ID NOT NULL,
  PAYMENT_DUE_DATE              DATE CONSTRAINT NN_AWI_PAYMENT_DUE_DATE NOT NULL,
  INSTALL_TYPE                  VARCHAR2(2 BYTE) CONSTRAINT NN_AWI_INSTALL_TYPE NOT NULL,
  ASSESSMENT_DATE               DATE CONSTRAINT NN_AWI_ASSESSMENT_DATE NOT NULL,
  AMOUNT                        NUMBER(9,2) CONSTRAINT NN_AWI_AMOUNT NOT NULL,
  RECOVERED_AMOUNT              NUMBER(9,2) CONSTRAINT NN_AWI_RECOVERED_AMOUNT NOT NULL,
  CONTRIB_AMOUNT                NUMBER(9,2) CONSTRAINT NN_AWI_CONTRIB_AMOUNT NOT NULL,
  NET_AMOUNT                    NUMBER(9,2) CONSTRAINT NN_AWI_NET_AMOUNT NOT NULL,
  METHOD                        VARCHAR2(1 BYTE) DEFAULT 'C' CONSTRAINT NN_AWI_METHOD NOT NULL,
  PAYEE                         VARCHAR2(1 BYTE) CONSTRAINT NN_AWI_PAYEE NOT NULL,
  PAYMENT_ADDR                  VARCHAR2(1 BYTE) CONSTRAINT NN_AWI_PAYMENT_ADDR NOT NULL,
  CAMPUS_ID                     NUMBER(9),
  PAYMENT_STATUS                VARCHAR2(1 BYTE),
  BATCH_REF                     VARCHAR2(7 BYTE),
  TRAV_AMOUNT                   NUMBER(9,2),
  NET_PAID_CONTRIB              NUMBER(9,2),
  PAYMENT_ID                    NUMBER(5),
  RETURNED                      VARCHAR2(1 BYTE) DEFAULT 'N',
  RETURNED_DATE                 DATE,
  RECALC                        VARCHAR2(1 BYTE) DEFAULT 'N',
  REISSUE                       VARCHAR2(1 BYTE) DEFAULT 'N',
  DEBT_RETURNED                 VARCHAR2(1 BYTE),
  PREV_RETURNED                 VARCHAR2(1 BYTE),
  PREV_REISSUE                  VARCHAR2(1 BYTE),
  UNCLAIMED_LOAN                NUMBER(9,2),
  DEBT_PAID_CONTRIB             NUMBER(9,2),
  DSA_FEE_INSTALMENT            VARCHAR2(1 BYTE),
  FEE_LOAN_INSTALMENT           VARCHAR2(1 BYTE),
  UNCLAIMED_FEE_LOAN            NUMBER(9,2),
  FEE_LOAN_TRANSACTION_CREATED  VARCHAR2(1 BYTE),
  PAYEE_REFERENCE               VARCHAR2(50 BYTE),
  INVOICE_NO                    NUMBER,
  INVOICE_DATE                  DATE,
  RECEIPTS_RECEIVED             VARCHAR2(1 BYTE) DEFAULT 'U',
  CHAPS                         VARCHAR2(1 BYTE),
  ADHOC_TYPE                    VARCHAR2(1 BYTE),
  -- Add Audit Columns
  LAST_UPDATED_BY               VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_AWI_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON               DATE DEFAULT Sysdate CONSTRAINT NN_AWI_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2500K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON COLUMN SGAS.AWARD_INSTALMENT.PAYEE_REFERENCE IS 'HOLDS A PAYEE REFERENCE FOR THE AWARD_INSTALMENT.'
/

COMMENT ON COLUMN SGAS.AWARD_INSTALMENT.RECEIPTS_RECEIVED IS 'If this is a DSA claim has a receipt been received where appropriate? See constraint for options.'
/

COMMENT ON COLUMN SGAS.AWARD_INSTALMENT.INVOICE_NO IS 'Invoice ID for DSA claims.'
/

COMMENT ON COLUMN SGAS.AWARD_INSTALMENT.INVOICE_DATE IS 'Date of DSA Invoice.'
/

--
-- S3_AWI  (Index)  
--
CREATE INDEX S3_AWI ON SGAS.AWARD_INSTALMENT
(BATCH_REF)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          800K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S1_AWI  (Index) 
--
CREATE INDEX S1_AWI ON SGAS.AWARD_INSTALMENT
(AWARD_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1000K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S4_AWI  (Index) 
--
CREATE INDEX S4_AWI ON SGAS.AWARD_INSTALMENT
(PAYMENT_DUE_DATE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1200K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       121
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


/* Formatted on 2011/03/11 13:09 (Formatter Plus v4.8.8) */
CREATE OR REPLACE TRIGGER sgas.awi_iud
   AFTER INSERT OR DELETE OR UPDATE OF payment_due_date,
                                       payment_status,
                                       install_type,
                                       amount,
                                       method,
                                       payment_addr,
                                       returned,
                                       unclaimed_fee_loan,
                                       fee_loan_instalment,
                                       fee_loan_transaction_created,
                                       payee_reference,
                                       invoice_no,
                                       invoice_date,
                                       net_amount,
                                       contrib_amount,
                                       recovered_amount,
                                       last_updated_by
   ON sgas.award_instalment
   FOR EACH ROW
DECLARE
   p_aud_date         DATE                                     := SYSDATE;
   p_column_name      award_instalment_aud.column_name%TYPE    := NULL;
   p_table_pkey1      award_instalment_aud.table_pkey1%TYPE
                                                   := TO_CHAR (:OLD.award_id);
   p_table_pkey2      award_instalment_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3      award_instalment_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4      award_instalment_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5      award_instalment_aud.table_pkey5%TYPE    := NULL;
   p_old              award_instalment_aud.OLD%TYPE            := NULL;
   p_new              award_instalment_aud.NEW%TYPE            := NULL;
   p_action           award_instalment_aud.action%TYPE         := NULL;
   p_username         award_instalment_aud.username%TYPE
                                                      := :NEW.last_updated_by;
   p_stud_ref_no      award_instalment_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code        award_instalment_aud.inst_code%TYPE      := NULL;
   p_session_code     award_instalment_aud.session_code%TYPE   := NULL;
   result_trav_null   VARCHAR2 (2);
   unpaid_count       NUMBER (5);
   min_date           DATE;
   max_date           DATE;
   p_award_id         award.award_id%TYPE                    := :OLD.award_id;
   v_chngd            VARCHAR2 (1)                             := 'N';
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.award_id;
      p_award_id := :NEW.award_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.award_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'PAYMENT_DUE_DATE';
   p_old := TO_CHAR (:OLD.payment_due_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.payment_due_date, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'INSTALL_TYPE';
   p_old := :OLD.install_type;
   p_new := :NEW.install_type;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_old := TO_CHAR (:OLD.amount);
   p_new := TO_CHAR (:NEW.amount);
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'METHOD';
   p_old := :OLD.method;
   p_new := :NEW.method;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_old := :OLD.payment_addr;
   p_new := :NEW.payment_addr;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_old := :OLD.payment_status;
   p_new := :NEW.payment_status;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'RETURNED';
   p_old := :OLD.returned;
   p_new := :NEW.returned;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'UNCLAIMED_FEE_LOAN';
   p_old := :OLD.unclaimed_fee_loan;
   p_new := :NEW.unclaimed_fee_loan;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'FEE_LOAN_INSTALMENT';
   p_old := :OLD.fee_loan_instalment;
   p_new := :NEW.fee_loan_instalment;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'FEE_LOAN_TRANSACTION_CREATED';
   p_old := :OLD.fee_loan_transaction_created;
   p_new := :NEW.fee_loan_transaction_created;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'PAYEE_REFERENCE';
   p_old := :OLD.payee_reference;
   p_new := :NEW.payee_reference;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'INVOICE_NO';
   p_old := :OLD.invoice_no;
   p_new := :NEW.invoice_no;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'INVOICE_DATE';
   p_old := :OLD.invoice_date;
   p_new := :NEW.invoice_date;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'NET_AMOUNT';
   p_old := :OLD.net_amount;
   p_new := :NEW.net_amount;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'CONTRIB_AMOUNT';
   p_old := :OLD.contrib_amount;
   p_new := :NEW.contrib_amount;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'RECOVERED_AMOUNT';
   p_old := :OLD.recovered_amount;
   p_new := :NEW.recovered_amount;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   pk_steps_aud.ins_awi_aud (p_aud_date,
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

   IF NVL (:OLD.payment_due_date, '01/JAN/1900') <>
                                    NVL (:NEW.payment_due_date, '01/JAN/1900')
   THEN
      v_chngd := 'Y';
   END IF;

   IF NVL (:OLD.net_amount, '0') <> NVL (:NEW.net_amount, '0')
   THEN
      v_chngd := 'Y';
   END IF;

   IF v_chngd = 'Y'
   THEN
      pk_steps_changes.cslr_awi (p_award_id);
   END IF;
END awi_iud;
SHOW ERRORS;


DROP SEQUENCE SGAS.AWARD_INSTALMENT_ID_SEQ;

CREATE SEQUENCE SGAS.AWARD_INSTALMENT_ID_SEQ
  START WITH 220000
  MAXVALUE 9999999999
  MINVALUE 0
  NOCYCLE
  NOCACHE
  NOORDER;

CREATE OR REPLACE TRIGGER SGAS.trig_awi_seq
   BEFORE INSERT
   ON SGAS.award_instalment
   FOR EACH ROW
BEGIN
   SELECT award_instalment_id_seq.NEXTVAL
     INTO :NEW.award_instalment_id
     FROM DUAL;
END;                                                                        
/


-- 
-- Non Foreign Key Constraints for Table AWARD_INSTALMENT 
-- 

ALTER TABLE SGAS.AWARD_INSTALMENT ADD (
  CONSTRAINT P_AWI
 PRIMARY KEY
 (AWARD_INSTALMENT_ID))
/

ALTER TABLE SGAS.AWARD_INSTALMENT ADD (
  CONSTRAINT AWI_REISSUE
 CHECK (reissue in ('Y','N')))
/

ALTER TABLE SGAS.AWARD_INSTALMENT ADD (
  CONSTRAINT AWI_METHOD
 CHECK ( METHOD IN('B','C')))
/

ALTER TABLE SGAS.AWARD_INSTALMENT ADD (
  CONSTRAINT AWI_PAYEE
 CHECK ( PAYEE IN('S','I','N')))
/

ALTER TABLE SGAS.AWARD_INSTALMENT ADD (
  CONSTRAINT AWI_RETURNED
 CHECK (returned in ('Y','N','A','T','P')))
/

ALTER TABLE SGAS.AWARD_INSTALMENT ADD (
  CONSTRAINT AWI_RECALC
 CHECK (recalc in ('Y','N')))
/

ALTER TABLE SGAS.AWARD_INSTALMENT ADD (
  CONSTRAINT AWI_DEBT_RETURNED
 CHECK (debt_returned in ('Y','N',null)))
/

ALTER TABLE SGAS.AWARD_INSTALMENT ADD (
  CONSTRAINT AWI_PAYMENT_ADDR
 CHECK ( PAYMENT_ADDR IN('C','N','H','T','B')))
/

ALTER TABLE SGAS.AWARD_INSTALMENT ADD (
  CONSTRAINT AWI_DSA_FEE_INSTALMENT
 CHECK (dsa_fee_instalment IN('Y','N')))
/

ALTER TABLE SGAS.AWARD_INSTALMENT ADD (
  CONSTRAINT AWI_FEE_LOAN_INSTAL
 CHECK (fee_loan_instalment in('Y','N')))
/

ALTER TABLE SGAS.AWARD_INSTALMENT ADD (
  CONSTRAINT AWI_FEE_LOAN_TRANS
 CHECK (fee_loan_transaction_created in('Y','N')))
/

ALTER TABLE SGAS.AWARD_INSTALMENT ADD (
  CONSTRAINT AWI_CHAPS
 CHECK (chaps in ('Y','N',null)))
/

ALTER TABLE SGAS.AWARD_INSTALMENT ADD (
  CONSTRAINT F1_AWI
 FOREIGN KEY (AWARD_ID) 
 REFERENCES SGAS.AWARD (AWARD_ID));

ALTER TABLE SGAS.AWARD_INSTALMENT ADD (
  CONSTRAINT F3_AWI
 FOREIGN KEY (BATCH_REF) 
 REFERENCES SGAS.SCOAP_BATCHES (DPB_BATCH_REF));
