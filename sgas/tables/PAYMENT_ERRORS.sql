-- PAYMENT_ERRORS.sql
-- Description: Holds error information gathered during the execution of payment job, enabling future use of that information for reporting purposes or simply display on UI to assist support officers in quickly resolving errors
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      22.12.09    A.Bowman (SAAS)         Initial Version.
-- 1.1      07.01.10    A.Bowman (SAAS)         Added Audit Triggers
-- 1.2      22.01.10    A.Bowman (SAAS)         Amended primary key name
-- 1.3      28.01.10    A.Bowman (SAAS)         Amended audit triggers
-- 1.4      18.03.10    A.Bowman (SAAS)         Removed not null constraint from BATCH_REF as requested by PH
-- 1.5      08.11.10    A.Bowman (SAAS)         Added precision to PAY_ERR_ID
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author:   $
-- $Date:     $
-- $Revision: $  

ALTER TABLE SGAS.PAYMENT_ERRORS
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.PAYMENT_ERRORS CASCADE CONSTRAINTS PURGE
/

--
-- PAYMENT_ERRORS  (Table) 
--

CREATE TABLE SGAS.PAYMENT_ERRORS
(
  PAY_ERR_ID              NUMBER(10) NOT NULL,
  BATCH_REF               VARCHAR2(7 BYTE),
  AWARD_INSTALMENT_ID     NUMBER(10),
  ERROR_TYPE              VARCHAR2(100 BYTE),
  ERROR_MODULE            VARCHAR2(100 BYTE),
  OPERATION               VARCHAR2(100 BYTE),
  ERROR_CODE              VARCHAR2(100 BYTE),
  ERROR_DATE              DATE,
  ERROR_MSG               VARCHAR2(1000 BYTE),
  INST_CODE               VARCHAR2(5 BYTE),
  STUD_REF_NO             NUMBER(10),
  PAYMENT_DATE            DATE,
  LAST_UPDATED_BY         VARCHAR2(15 BYTE)  DEFAULT User NOT NULL,
  LAST_UPDATED_ON         DATE               DEFAULT Sysdate NOT NULL
)

TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX PAYMENT_ERRORS_PK ON SGAS.PAYMENT_ERRORS
(PAY_ERR_ID)
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


ALTER TABLE PAYMENT_ERRORS ADD (
  CONSTRAINT PAYMENT_ERRORS_PK
 PRIMARY KEY
 (PAY_ERR_ID)
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

/*CREATE OR REPLACE TRIGGER SGAS.pay_err_iud
   AFTER INSERT OR DELETE OR UPDATE OF   PAY_ERR_ID,
                                         BATCH_REF,
                                         AWARD_INSTALMENT_ID,
                                         ERROR_TYPE,
                                         ERROR_MODULE,
                                         OPERATION,
                                         ERROR_CODE,
                                         ERROR_DATE,
                                         ERROR_MSG,
                                         INST_CODE,
                                         STUD_REF_NO,
                                         PAYMENT_DATE,
                                         LAST_UPDATED_BY
ON SGAS.PAYMENT_ERRORS FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    PAYMENT_ERRORS_aud.column_name%TYPE    := NULL;
   p_table_pkey1    PAYMENT_ERRORS_aud.table_pkey1%TYPE
                                               := :OLD.PAY_ERR_ID;
   p_table_pkey2    PAYMENT_ERRORS_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    PAYMENT_ERRORS_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    PAYMENT_ERRORS_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    PAYMENT_ERRORS_aud.table_pkey5%TYPE    := NULL;
   p_old            PAYMENT_ERRORS_aud.OLD%TYPE            := NULL;
   p_new            PAYMENT_ERRORS_aud.NEW%TYPE            := NULL;
   p_action         PAYMENT_ERRORS_aud.action%TYPE         := NULL;
   p_username       PAYMENT_ERRORS_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    PAYMENT_ERRORS_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      PAYMENT_ERRORS_aud.inst_code%TYPE      := NULL;
   p_session_code   PAYMENT_ERRORS_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.PAY_ERR_ID;
--   ELSIF UPDATING
--  THEN
--      p_action := 'U';
--   ELSIF DELETING
--   THEN
 --     p_action := 'D';
 --     p_table_pkey1 := :OLD.PAY_ERR_ID;
 --     p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'PAY_ERR_ID';
   p_old := :OLD.pay_err_id;
   p_new := :NEW.pay_err_id;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'ERROR_TYPE';
   p_old := :OLD.ERROR_TYPE;
   p_new := :NEW.ERROR_TYPE;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'ERROR_MODULE';
   p_old := :OLD.ERROR_MODULE;
   p_new := :NEW.ERROR_MODULE;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'OPERATION';
   p_old := :OLD.OPERATION;
   p_new := :NEW.OPERATION;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'ERROR_CODE';
   p_old := :OLD.ERROR_CODE;
   p_new := :NEW.ERROR_CODE;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'ERROR_DATE';
   p_old := :OLD.ERROR_DATE;
   p_new := :NEW.ERROR_DATE;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'ERROR_MSG';
   p_old := :OLD.ERROR_MSG;
   p_new := :NEW.ERROR_MSG;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   
END pay_err_iud;
SHOW ERRORS;*/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM PAYMENT_ERRORS
/

CREATE PUBLIC SYNONYM PAYMENT_ERRORS FOR SGAS.PAYMENT_ERRORS
/

DROP SEQUENCE SGAS.PAY_ERRORS_ID_SEQ
/
--
-- PAY_ERRORS_ID_seq  (Sequence) 
--
CREATE SEQUENCE SGAS.PAY_ERRORS_ID_SEQ
  START WITH 1
  MAXVALUE 9999999999
  MINVALUE 1
  CYCLE
  NOCACHE
  NOORDER
/

CREATE OR REPLACE TRIGGER SGAS.TRIG_PAY_ERRORS_SEQ 
   BEFORE INSERT
   ON SGAS.PAYMENT_ERRORS
   FOR EACH ROW
BEGIN
   SELECT PAY_ERRORS_ID_SEQ.NEXTVAL
     INTO :NEW.PAY_ERR_ID
     FROM DUAL;
END;
