-- ADI_JOURNAL.sql
-- Description: Holds adi payment record for a batch; equivalent database record of one line from an ADI file
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      22.12.09    A.Bowman (SAAS)         Initial Version.
-- 1.1      07.01.10    A.Bowman (SAAS)         Added Audit Triggers
-- 1.2      28.01.10    A.Bowman (SAAS)         Amended Audit Triggers
-- 1.3      14.04.10    A.Bowman (SAAS)         Removed unique pk on adi_journal_id and seq trigger
-- 1.4      21.04.10    A.Bowman (SAAS)         Added new unique pk and seq trigger for adi_journal_line_id
-- 1.5      13.05.10    A.Bowman (SAAS)         Seq trigger for adi_journal_line_id removed as it is no longer required, value set in pk_payments
-- 1.6      08.11.10    A.Bowman (SAAS)         Added precision to ADI_JOURAL_ID and ADI_JOURNAL_LINE_ID 
--
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author:   $
-- $Date:     $
-- $Revision: $  

ALTER TABLE SGAS.ADI_JOURNAL
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.ADI_JOURNAL CASCADE CONSTRAINTS PURGE
/

--
-- ADI_JOURNAL  (Table) 
--

CREATE TABLE SGAS.ADI_JOURNAL
(
  ADI_JOURNAL_LINE_ID   NUMBER(10) NOT NULL,
  ADI_JOURNAL_ID        NUMBER(10) NOT NULL,
  BATCH_REF             VARCHAR2(7 BYTE) NOT NULL,
  COST_CENTRE           VARCHAR2(6 BYTE),
  ACCOUNT               VARCHAR2(8 BYTE),
  PROGRAMME             VARCHAR2(3 BYTE),
  CURRENCY              VARCHAR2(3 BYTE) DEFAULT 'GBP',
  ENTITY                VARCHAR2(3 BYTE) DEFAULT '600',
  PAYMENT_METHOD        VARCHAR2(2 BYTE), 
  PROCESS_DATE          DATE,
  ADI_FILE_STATUS       VARCHAR2(1 BYTE),
  SUB_ANALYSIS1		VARCHAR2(6 BYTE),
  SUB_ANALYSIS2		VARCHAR2(8 BYTE),
  SUB_ANALYSIS3		VARCHAR2(6 BYTE),
  DEBIT_VALUE		NUMBER(9,2),
  CREDIT_VALUE		NUMBER(9,2),
  PAYMENT_RUN_DATE	DATE,
  LAST_UPDATED_BY       VARCHAR2(15 BYTE)          DEFAULT User NOT NULL,
  LAST_UPDATED_ON       DATE                       DEFAULT Sysdate NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
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

CREATE UNIQUE INDEX ADI_JOURNAL_PK ON SGAS.ADI_JOURNAL
(ADI_JOURNAL_LINE_ID)
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


ALTER TABLE ADI_JOURNAL ADD (
  CONSTRAINT ADI_JOURNAL_PK
 PRIMARY KEY
 (ADI_JOURNAL_LINE_ID)
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

ALTER TABLE SGAS.ADI_JOURNAL ADD (
  CONSTRAINT F1_ADI 
 FOREIGN KEY (BATCH_REF) 
 REFERENCES SGAS.SCOAP_BATCHES (DPB_BATCH_REF));

CREATE OR REPLACE TRIGGER SGAS.adi_jou_iud
   AFTER INSERT OR DELETE OR UPDATE OF  ADI_JOURNAL_LINE_ID,
                                        ADI_JOURNAL_ID,
                                        BATCH_REF,
                                        COST_CENTRE,
                                        ACCOUNT,
                                        PROGRAMME,
                                        CURRENCY,
                                        ENTITY,
                                        PAYMENT_METHOD, 
                                        PROCESS_DATE,
                                        ADI_FILE_STATUS,
                                        SUB_ANALYSIS1,			
                                        SUB_ANALYSIS2,			
                                        SUB_ANALYSIS3,			
                                        DEBIT_VALUE,		
                                        CREDIT_VALUE,			
                                        PAYMENT_RUN_DATE,		
                                        LAST_UPDATED_BY         
ON SGAS.ADI_JOURNAL FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    ADI_JOURNAL_aud.column_name%TYPE    := NULL;
   p_table_pkey1    ADI_JOURNAL_aud.table_pkey1%TYPE
                                               := :OLD.ADI_JOURNAL_LINE_ID;
   p_table_pkey2    ADI_JOURNAL_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    ADI_JOURNAL_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    ADI_JOURNAL_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    ADI_JOURNAL_aud.table_pkey5%TYPE    := NULL;
   p_old            ADI_JOURNAL_aud.OLD%TYPE            := NULL;
   p_new            ADI_JOURNAL_aud.NEW%TYPE            := NULL;
   p_action         ADI_JOURNAL_aud.action%TYPE         := NULL;
   p_username       ADI_JOURNAL_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    ADI_JOURNAL_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      ADI_JOURNAL_aud.inst_code%TYPE      := NULL;
   p_session_code   ADI_JOURNAL_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.ADI_JOURNAL_LINE_ID;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.ADI_JOURNAL_LINE_ID;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'ADI_JOURNAL_LINE_ID';
   p_old := :OLD.ADI_JOURNAL_LINE_ID;
   p_new := :NEW.ADI_JOURNAL_LINE_ID;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'ADI_FILE_STATUS';
   p_old := :OLD.ADI_FILE_STATUS;
   p_new := :NEW.ADI_FILE_STATUS;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'SUB_ANALYSIS1';
   p_old := :OLD.SUB_ANALYSIS1;
   p_new := :NEW.SUB_ANALYSIS1;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'SUB_ANALYSIS2';
   p_old := :OLD.SUB_ANALYSIS2;
   p_new := :NEW.SUB_ANALYSIS2;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'SUB_ANALYSIS3';
   p_old := :OLD.SUB_ANALYSIS3;
   p_new := :NEW.SUB_ANALYSIS3;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'DEBIT_VALUE';
   p_old := :OLD.DEBIT_VALUE;
   p_new := :NEW.DEBIT_VALUE;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'CREDIT_VALUE';
   p_old := :OLD.CREDIT_VALUE;
   p_new := :NEW.CREDIT_VALUE;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
END adi_jou_iud;

SHOW ERRORS;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM ADI_JOURNAL
/

CREATE PUBLIC SYNONYM ADI_JOURNAL FOR SGAS.ADI_JOURNAL
/

DROP SEQUENCE SGAS.ADI_JL_SEQ
/
--
-- ADI_JL_SEQ  (Sequence) 
--
CREATE SEQUENCE SGAS.ADI_JL_SEQ
  START WITH 1
  MAXVALUE 9999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/

DROP SEQUENCE SGAS.ADI_JOURN_ID_SEQ
/
--
-- ADI_JOURN_ID_SEQ  (Sequence) 
--
CREATE SEQUENCE SGAS.ADI_JOURN_ID_SEQ
  START WITH 1
  MAXVALUE 9999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


