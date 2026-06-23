-- FEE_LOAN_TRANSACTION.sql
-- Description: Table holding FEE_LOAN_TRANSACTION data
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      01.11.11    A.Bowman  (SAAS)        Initial Version.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $


--
-- FEE_LOAN_TRANSACTION  (Table) 
--

DROP TABLE SGAS.FEE_LOAN_TRANSACTION CASCADE CONSTRAINTS;

CREATE TABLE SGAS.FEE_LOAN_TRANSACTION
(
  TRANS_ID                   NUMBER(10),
  SESSION_CODE               NUMBER(4),
  STUD_REF_NO                NUMBER(10)         NOT NULL,
  STUD_CRSE_YEAR_ID          NUMBER(9)          NOT NULL,
  TXN_AMOUNT                 NUMBER(9,2)        NOT NULL,
  TXN_DC_FLG                 VARCHAR2(1 BYTE)   NOT NULL,
  TXN_TYPE                   VARCHAR2(1 BYTE)   NOT NULL,
  TXN_DATE                   DATE               NOT NULL,
  TXN_DUE_DATE               DATE               NOT NULL,
  TXN_PAYMENT_DATE           DATE,
  TXN_INTEREST_ACCRUAL_DATE  DATE,
  PAYMENT_METHOD             VARCHAR2(1 BYTE)   NOT NULL,
  INST_CODE                  VARCHAR2(5 BYTE)   NOT NULL,
  INST_BANK_SORT_CODE        VARCHAR2(6 BYTE),
  INST_ACCOUNT_NO            VARCHAR2(10 BYTE),
  CAMPUS_ID                  NUMBER(9)          NOT NULL,
  BATCH_REF                  VARCHAR2(7 BYTE),
  PAYMENT_ID                 NUMBER(5),
  SLC2_FILENAME              VARCHAR2(25 BYTE),
  SLC2_FILE_DATE             DATE,
  STATUS                     VARCHAR2(1 BYTE),
  STATUS_CHANGED_DATE        DATE,
  LAST_UPDATED_BY       VARCHAR2(15 BYTE)       DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON       DATE                    DEFAULT SYSDATE               NOT NULL
)
TABLESPACE STEPS_DATA
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             500K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE INDEX SGAS.S1_FLT ON SGAS.FEE_LOAN_TRANSACTION
(STUD_REF_NO)
LOGGING
TABLESPACE STEPS_INDEX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             500K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX SGAS.S2_FLT ON SGAS.FEE_LOAN_TRANSACTION
(SESSION_CODE)
LOGGING
TABLESPACE STEPS_INDEX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             500K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX SGAS.P_FLT ON SGAS.FEE_LOAN_TRANSACTION
(TRANS_ID)
LOGGING
TABLESPACE STEPS_INDEX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             500K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


DROP PUBLIC SYNONYM FEE_LOAN_TRANSACTION;

CREATE PUBLIC SYNONYM FEE_LOAN_TRANSACTION FOR SGAS.FEE_LOAN_TRANSACTION;


ALTER TABLE SGAS.FEE_LOAN_TRANSACTION ADD (
  CONSTRAINT FLT_PAYMENT_METHOD
 CHECK (Payment_method IN ('C', 'B')));

ALTER TABLE SGAS.FEE_LOAN_TRANSACTION ADD (
  CONSTRAINT FLT_TXN_DC_FLG
 CHECK (Txn_dc_flg IN ('D', 'C')));

ALTER TABLE SGAS.FEE_LOAN_TRANSACTION ADD (
  CONSTRAINT FLT_TXN_TYPE
 CHECK (Txn_type IN ('P', 'A')));

ALTER TABLE SGAS.FEE_LOAN_TRANSACTION ADD (
  CONSTRAINT P_FLT
 PRIMARY KEY
 (TRANS_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          500K
                NEXT             500K
                MINEXTENTS       1
                MAXEXTENTS       99
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ));

DROP SEQUENCE SGAS.FEE_LOAN_TRANS_SEQ
/

--
-- FEE_LOAN_TRANS_SEQ  (Sequence) 
--
CREATE SEQUENCE SGAS.FEE_LOAN_TRANS_SEQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
                                                                        

CREATE OR REPLACE TRIGGER SGAS.TRIG_FEE_LOAN_TRANS_SEQ
   BEFORE INSERT
   ON SGAS.FEE_LOAN_TRANSACTION    FOR EACH ROW
BEGIN
   SELECT FEE_LOAN_TRANS_SEQ.NEXTVAL
     INTO :NEW.trans_id
     FROM DUAL;
END;
/