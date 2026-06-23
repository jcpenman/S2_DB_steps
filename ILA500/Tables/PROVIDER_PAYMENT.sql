-- PROVIDER_PAYMENT.sql
-- Description: Table shows payment amount paid to each provider in an ILA500 bacs run
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      02.07.08    R Hunter (SAAS)         Initial Version.
-- 1.1      21.08.08    A.Bowman (SAAS)         Amended prov_bal_amount, total_amount, debits_amount and credit_amounts data type to number(15,2)
-- 1.2      19.10.09    A.Bowman (SAAS)         Added triggers and sequence
-- 1.3      15.02.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PROVIDER_PAYMENT.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

ALTER TABLE PROVIDER_PAYMENT
 DROP PRIMARY KEY CASCADE
/
DROP TABLE PROVIDER_PAYMENT CASCADE CONSTRAINTS PURGE
/

--
-- PROVIDER_PAYMENT  (Table) 
--
CREATE TABLE PROVIDER_PAYMENT
(
  PROVIDER_PAYMENT_ID  NUMBER                   NOT NULL,
  PROVIDER_ID          NUMBER                   NOT NULL,
  BACS_RUN_ID          NUMBER                   NOT NULL,
  ADI_PAYMENT_ID       NUMBER,
  PAYMENT_STATUS_ID    NUMBER                   DEFAULT 1 NOT NULL ,
  TOTAL_AMOUNT         NUMBER(15,2) DEFAULT 0   NOT NULL,
  DEBITS_AMOUNT        NUMBER(15,2) DEFAULT 0   NOT NULL,
  CREDITS_AMOUNT       NUMBER(15,2) DEFAULT 0   NOT NULL,
  PROV_BAL_AMOUNT      NUMBER(15,2) DEFAULT 0   NOT NULL,
  LAST_UPDATED_BY      VARCHAR2(25 BYTE)        DEFAULT USER NOT NULL,
  LAST_UPDATED_ON      DATE                     DEFAULT SYSDATE NOT NULL
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


--
-- PROVIDER_PAYMENT_PK  (Index) 
--
CREATE UNIQUE INDEX PROVIDER_PAYMENT_PK ON PROVIDER_PAYMENT
(PROVIDER_PAYMENT_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


-- 
-- Non Foreign Key Constraints for Table PROVIDER_PAYMENT 
-- 
ALTER TABLE PROVIDER_PAYMENT ADD (
  CONSTRAINT PROVIDER_PAYMENT_PK
 PRIMARY KEY
 (PROVIDER_PAYMENT_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ))
/

/* Formatted on 2008/08/19 10:33 (Formatter Plus v4.8.8) */
-- TRIGGER: PROV_PAY_IUD
-- TABLE: PROVIDER_PAYMENT
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
-- 002      19.08.2008    A.Bowman (SAAS)         Added prov_bal_amount column
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PROVIDER_PAYMENT.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.prov_pay_iud
   AFTER DELETE OR INSERT OR UPDATE OF provider_payment_id,
                                       provider_id,
                                       bacs_run_id,
                                       adi_payment_id,
                                       payment_status_id,
                                       total_amount,
                                       debits_amount,
                                       credits_amount,
                                       prov_bal_amount,
                                       last_updated_by
   ON ila500.provider_payment
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                    := SYSDATE;
   p_column_name   provider_payment_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_payment_aud.primary_key%TYPE
                                                  := :OLD.provider_payment_id;
   p_old           provider_payment_aud.OLD%TYPE           := NULL;
   p_new           provider_payment_aud.NEW%TYPE           := NULL;
   p_action        provider_payment_aud.action%TYPE        := NULL;
   p_username      provider_payment_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.provider_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'PROVIDER_PAYMENT_ID';
   p_old := :OLD.provider_payment_id;
   p_new := :NEW.provider_payment_id;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'PROVIDER_ID';
   p_old := :OLD.provider_id;
   p_new := :NEW.provider_id;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'BACS_RUN_ID';
   p_old := :OLD.bacs_run_id;
   p_new := :NEW.bacs_run_id;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'ADI_PAYMENT_ID';
   p_old := :OLD.adi_payment_id;
   p_new := :NEW.adi_payment_id;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'PAYMENT_STATUS_ID';
   p_old := :OLD.payment_status_id;
   p_new := :NEW.payment_status_id;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'TOTAL_AMOUNT';
   p_old := :OLD.total_amount;
   p_new := :NEW.total_amount;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'DEBITS_AMOUNT';
   p_old := :OLD.debits_amount;
   p_new := :NEW.debits_amount;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'CREDITS_AMOUNT';
   p_old := :OLD.credits_amount;
   p_new := :NEW.credits_amount;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'PROV_BAL_AMOUNT';
   p_old := :OLD.prov_bal_amount;
   p_new := :NEW.prov_bal_amount;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END prov_pay_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 16:18 (Formatter Plus v4.8.8) */
-- TRIGGER: PROV_PAY_LUB
-- TABLE: PROVIDER_PAYMENT
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PROVIDER_PAYMENT.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.prov_pay_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.provider_payment
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                    := SYSDATE;
   p_column_name   provider_payment_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_payment_aud.primary_key%TYPE
                                                  := :OLD.provider_payment_id;
   p_old           provider_payment_aud.OLD%TYPE           := NULL;
   p_new           provider_payment_aud.NEW%TYPE           := NULL;
   p_action        provider_payment_aud.action%TYPE        := NULL;
   p_username      provider_payment_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.provider_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END prov_pay_lub;
/
SHOW ERRORS;*/

-- SEQUENCE SCRIPT FOR PK ON provider_payment TABLE
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      03.07.08    R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PROVIDER_PAYMENT.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
DROP SEQUENCE provider_payment_id_seq
/

--
-- provider_payment_id_seq  (Sequence) 
--
CREATE SEQUENCE provider_payment_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


CREATE OR REPLACE TRIGGER trig_provider_payment_seq BEFORE INSERT ON provider_payment
FOR EACH ROW
BEGIN
SELECT provider_payment_id_seq.NEXTVAL into :new.provider_payment_id FROM dual;
END;



GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  PROVIDER_PAYMENT TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM PROVIDER_PAYMENT
/

CREATE PUBLIC SYNONYM PROVIDER_PAYMENT FOR ILA500.PROVIDER_PAYMENT
/

