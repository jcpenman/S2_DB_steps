-- LEARNER_PAYMENT.sql
-- Description: Table shows virtual payment amount paid to each provider per learner in an ILA500 bacs run
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      02.07.08    R Hunter (SAAS)         Initial Version.
-- 1.1      21.08.08    A.Bowman (SAAS)         Amended amount data type to number(15,2)
-- 1.2      19.10.09    A.Bowman (SAAS)         Added trigger and sequence
-- 1.3      15.02.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER_PAYMENT.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

ALTER TABLE LEARNER_PAYMENT
 DROP PRIMARY KEY CASCADE
/
DROP TABLE LEARNER_PAYMENT CASCADE CONSTRAINTS PURGE
/

--
-- LEARNER_PAYMENT  (Table) 
--
CREATE TABLE LEARNER_PAYMENT
(
  LEARNER_PAYMENT_ID     NUMBER NOT NULL,
  LEARNER_application_ID NUMBER NOT NULL,
  provider_payment_id    NUMBER,
  transaction_type_id    NUMBER NOT NULL,
  PAYMENT_STATUS_ID      NUMBER NOT NULL,
  AMOUNT  	         NUMBER(15,2) DEFAULT 0 NOT NULL,
  LAST_UPDATED_BY        VARCHAR2(25 BYTE) DEFAULT USER NOT NULL,
  LAST_UPDATED_ON        DATE DEFAULT SYSDATE NOT NULL
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

CREATE UNIQUE INDEX LEARNER_PAYMENT_PK ON LEARNER_PAYMENT
(LEARNER_PAYMENT_ID)
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


ALTER TABLE LEARNER_PAYMENT ADD (
  CONSTRAINT LEARNER_PAYMENT_PK
 PRIMARY KEY
 (LEARNER_PAYMENT_ID)
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

/* Formatted on 2008/07/09 12:01 (Formatter Plus v4.8.8) */
-- TRIGGER: LEA_PAY_IUD
-- TABLE: LEARNER_PAYMENT
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER_PAYMENT.sql $ 
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.lea_pay_iud
   AFTER DELETE OR INSERT OR UPDATE OF learner_payment_id,
                                       learner_application_id,
                                       provider_payment_id,
                                       transaction_type_id,
                                       payment_status_id,
                                       amount,
                                       last_updated_by
   ON ila500.learner_payment
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                   := SYSDATE;
   p_column_name   learner_payment_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_payment_aud.primary_key%TYPE
                                                   := :OLD.learner_payment_id;
   p_old           learner_payment_aud.OLD%TYPE           := NULL;
   p_new           learner_payment_aud.NEW%TYPE           := NULL;
   p_action        learner_payment_aud.action%TYPE        := NULL;
   p_username      learner_payment_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.learner_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'LEARNER_PAYMENT_ID';
   p_old := :OLD.learner_payment_id;
   p_new := :NEW.learner_payment_id;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LEARNER_APPLICATION_ID';
   p_old := :OLD.learner_application_id;
   p_new := :NEW.learner_application_id;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PROVIDER_PAYMENT_ID';
   p_old := :OLD.provider_payment_id;
   p_new := :NEW.provider_payment_id;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'TRANSACTION_TYPE_ID';
   p_old := :OLD.transaction_type_id;
   p_new := :NEW.transaction_type_id;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
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
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'AMOUNT';
   p_old := :OLD.amount;
   p_new := :NEW.amount;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
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
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END lea_pay_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:56 (Formatter Plus v4.8.8) */
-- TRIGGER: LEA_PAY_LUB
-- TABLE: LEARNER_PAYMENT
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER_PAYMENT.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.lea_pay_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.learner_payment
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                   := SYSDATE;
   p_column_name   learner_payment_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_payment_aud.primary_key%TYPE
                                                   := :OLD.learner_payment_id;
   p_old           learner_payment_aud.OLD%TYPE           := NULL;
   p_new           learner_payment_aud.NEW%TYPE           := NULL;
   p_action        learner_payment_aud.action%TYPE        := NULL;
   p_username      learner_payment_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.learner_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END lea_pay_lub;
/
SHOW ERRORS;*/

-- SEQUENCE SCRIPT FOR PK ON learner_payment TABLE
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      03.07.08    R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER_PAYMENT.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
DROP SEQUENCE learner_payment_id_seq
/

--
-- learner_payment_id_seq  (Sequence) 
--
CREATE SEQUENCE learner_payment_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


CREATE OR REPLACE TRIGGER trig_learner_payment_seq BEFORE INSERT ON learner_payment
FOR EACH ROW
BEGIN
SELECT learner_payment_id_seq.NEXTVAL into :new.learner_payment_id FROM dual;
END;


GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  LEARNER_PAYMENT TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM LEARNER_PAYMENT
/

CREATE PUBLIC SYNONYM LEARNER_PAYMENT FOR ILA500.LEARNER_PAYMENT
/

