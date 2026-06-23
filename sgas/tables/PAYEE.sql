-- PAYEE.sql
-- Description: Holds a record of who is a PAYEE in StEPS e.g. a Nominee or a Campus
--
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      22.12.09    A.Bowman (SAAS)         Initial Version.
-- 1.1      07.01.10    A.Bowman (SAAS)         Added Audit Triggers
-- 1.2      25.01.10    A.Bowman (SAAS)         Amended name of PK
-- 1.3      28.01.10    A.Bowman (SAAS)         Amended audit trigger
-- 1.4      15.03.10    A.Bowman (SAAS)         Amended table structure in line with latest version of spec
-- 1.5      08.11.10    A.Bowman (SAAS)         Added precision to PAYEE_ID
-- 1.6      22.11.10    A.Bowman (SAAS)         Added new column fee_type
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author:   $
-- $Date:     $
-- $Revision: $  

ALTER TABLE SGAS.PAYEE
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.PAYEE CASCADE CONSTRAINTS PURGE
/

--
-- PAYEE  (Table) 
--

CREATE TABLE SGAS.PAYEE
(
  PAYEE_ID                   NUMBER(10) NOT NULL,
  PAYEE_REF_ID               NUMBER(10) NOT NULL,
  PAYEE_TYPE                 VARCHAR2(20 BYTE),
  PAYMENT_TYPE               VARCHAR2(1 BYTE), 
  OUTSTANDING_AMOUNT         NUMBER(9,2),
  PREV_OUTSTANDING_AMOUNT    NUMBER(9,2),
  LAST_UPDATED_BY VARCHAR2(25 BYTE) DEFAULT USER NOT NULL,
  LAST_UPDATED_ON DATE DEFAULT SYSDATE NOT NULL
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


CREATE UNIQUE INDEX PAYEE_PK ON SGAS.PAYEE
(PAYEE_ID)
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


ALTER TABLE PAYEE ADD (
  CONSTRAINT PAYEE_PK
 PRIMARY KEY
 (PAYEE_ID)
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

ALTER TABLE SGAS.PAYEE ADD (
  CONSTRAINT PAY_FT
 CHECK (payment_type in ('F','L','A')))
/

ALTER TABLE SGAS.PAYEE ADD (
  CONSTRAINT PAY_TP
 CHECK (payee_type in ('S','N','I')))
/

CREATE OR REPLACE TRIGGER SGAS.pay_iud
   AFTER INSERT OR DELETE OR UPDATE OF  PAYEE_ID,
                                        PAYEE_REF_ID,
                                        PAYEE_TYPE,
                                        PAYMENT_TYPE,
                                        OUTSTANDING_AMOUNT,
                                        PREV_OUTSTANDING_AMOUNT,
                                        LAST_UPDATED_BY
                                              
ON SGAS.PAYEE FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    PAYEE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    PAYEE_aud.table_pkey1%TYPE
                                               := :OLD.PAYEE_ID;
   p_table_pkey2    PAYEE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    PAYEE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    PAYEE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    PAYEE_aud.table_pkey5%TYPE    := NULL;
   p_old            PAYEE_aud.OLD%TYPE            := NULL;
   p_new            PAYEE_aud.NEW%TYPE            := NULL;
   p_action         PAYEE_aud.action%TYPE         := NULL;
   p_username       PAYEE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    PAYEE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      PAYEE_aud.inst_code%TYPE      := NULL;
   p_session_code   PAYEE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.PAYEE_ID;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.PAYEE_ID;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'PAYEE_ID';
   p_old := :OLD.PAYEE_ID;
   p_new := :NEW.PAYEE_ID;
   pk_steps_aud.ins_pay_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_aud (p_aud_date,
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
   p_column_name := 'OUTSTANDING_AMOUNT';
   p_old := :OLD.OUTSTANDING_AMOUNT;
   p_new := :NEW.OUTSTANDING_AMOUNT;
   pk_steps_aud.ins_pay_aud (p_aud_date,
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
   p_column_name := 'PREV_OUTSTANDING_AMOUNT';
   p_old := :OLD.PREV_OUTSTANDING_AMOUNT;
   p_new := :NEW.PREV_OUTSTANDING_AMOUNT;
   pk_steps_aud.ins_pay_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_aud (p_aud_date,
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
END pay_iud;

SHOW ERRORS;


-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM PAYEE
/

CREATE PUBLIC SYNONYM PAYEE FOR SGAS.PAYEE
/

-- GRANT SELECT ON PAYEE TO PUBLIC;

DROP SEQUENCE SGAS.PAYEE_ID_SEQ
/
--
-- PAYEE_ID_SEQ  (Sequence) 
--
CREATE SEQUENCE SGAS.PAYEE_ID_SEQ
  START WITH 1
  MAXVALUE 9999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/

CREATE OR REPLACE TRIGGER SGAS.TRIG_PAYEE_SEQ 
   BEFORE INSERT
   ON SGAS.PAYEE
   FOR EACH ROW
BEGIN
   SELECT PAYEE_ID_SEQ.NEXTVAL
     INTO :NEW.PAYEE_ID
     FROM DUAL;
END;