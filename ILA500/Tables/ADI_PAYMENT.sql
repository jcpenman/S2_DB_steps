-- ADI_PAYMENT.sql
-- Description: Table shows total amount paid to all providers in a single bacs run. 
-- For ADI journal in ILA500.
-- We make payments 4 times per year
-- OR ON AN ADHOC BASIS IF A PAYMENT FAILS AND FINANCE WANT TO RESUBMIT TO BACS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      02.07.08    R Hunter (SAAS)         Initial Version.
-- 2.0      21.08.08	A.Bowman (SAAS)         Amended total_payment_amount data type to number(15,2)
-- 3.0      19.10.09    A.Bowman (SAAS)         Added triggers and sequence 
-- 3.1      15.02.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ADI_PAYMENT.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

ALTER TABLE ADI_PAYMENT
 DROP PRIMARY KEY CASCADE
/
DROP TABLE ADI_PAYMENT CASCADE CONSTRAINTS PURGE
/


--
-- ADI_PAYMENT  (Table) 
--
CREATE TABLE ADI_PAYMENT
(
  ADI_PAYMENT_ID        NUMBER NOT NULL,
  PAYMENT_STATUS_ID     NUMBER DEFAULT 1 NOT NULL,
  TOTAL_PAYMENT_AMOUNT  NUMBER(15,2) DEFAULT 0 NOT NULL,
  LAST_UPDATED_BY       VARCHAR2(25 BYTE) DEFAULT USER NOT NULL,
  LAST_UPDATED_ON       DATE DEFAULT SYSDATE NOT NULL
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

COMMENT ON COLUMN ADI_PAYMENT.ADI_PAYMENT_ID IS 'Unique record identifier';

COMMENT ON COLUMN ADI_PAYMENT.PAYMENT_STATUS_ID IS 'Foreign key to payment status lookup table';

COMMENT ON COLUMN ADI_PAYMENT.TOTAL_PAYMENT_AMOUNT IS 'Total amount paid to all institutions in a single bacs file';

CREATE UNIQUE INDEX ADI_PAYMENT_PK ON ADI_PAYMENT
(ADI_PAYMENT_ID)
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


ALTER TABLE ADI_PAYMENT ADD (
  CONSTRAINT ADI_PAYMENT_PK
 PRIMARY KEY
 (ADI_PAYMENT_ID)
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

/* Formatted on 2008/07/08 16:04 (Formatter Plus v4.8.8) */
-- TRIGGER: ADI_PAY_IUD
-- TABLE: ADI_PAYMENT
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ADI_PAYMENT.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.adi_pay_iud
   AFTER DELETE OR INSERT OR UPDATE OF adi_payment_id,
                                       payment_status_id,
                                       total_payment_amount,
                                       last_updated_by
   ON ila500.adi_payment
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                               := SYSDATE;
   p_column_name   adi_payment_aud.column_name%TYPE   := NULL;
   p_primary_key   adi_payment_aud.primary_key%TYPE   := :OLD.adi_payment_id;
   p_old           adi_payment_aud.OLD%TYPE           := NULL;
   p_new           adi_payment_aud.NEW%TYPE           := NULL;
   p_action        adi_payment_aud.action%TYPE        := NULL;
   p_username      adi_payment_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.adi_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'ADI_PAYMENT_ID';
   p_old := :OLD.adi_payment_id;
   p_new := :NEW.adi_payment_id;
   pk_pop_aud.ins_adi_pay_aud (p_aud_date,
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
   pk_pop_aud.ins_adi_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'TOTAL_PAYMENT_AMOUNT';
   p_old := :OLD.total_payment_amount;
   p_new := :NEW.total_payment_amount;
   pk_pop_aud.ins_adi_pay_aud (p_aud_date,
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
   pk_pop_aud.ins_adi_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END adi_pay_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:29 (Formatter Plus v4.8.8) */
-- TRIGGER: ADI_PAY_LUB
-- TABLE: ADI_PAYMENT
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ADI_PAYMENT.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.adi_pay_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.adi_payment
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                               := SYSDATE;
   p_column_name   adi_payment_aud.column_name%TYPE   := NULL;
   p_primary_key   adi_payment_aud.primary_key%TYPE   := :OLD.adi_payment_id;
   p_old           adi_payment_aud.OLD%TYPE           := NULL;
   p_new           adi_payment_aud.NEW%TYPE           := NULL;
   p_action        adi_payment_aud.action%TYPE        := NULL;
   p_username      adi_payment_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.adi_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_adi_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END api_pay_lub;
/
SHOW ERRORS;*/

-- SEQUENCE SCRIPT FOR PK ON ADI_PAYMENT TABLE
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      03.07.08    R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ADI_PAYMENT.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
DROP SEQUENCE adi_payment_id_seq
/

--
-- adi_payment_id_seq  (Sequence) 
--
CREATE SEQUENCE adi_payment_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


CREATE OR REPLACE TRIGGER trig_adi_payment_seq BEFORE INSERT ON ADI_PAYMENT
FOR EACH ROW
BEGIN
SELECT adi_payment_id_seq.NEXTVAL into :new.adi_payment_id FROM dual;
END;


GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  ADI_PAYMENT TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM ADI_PAYMENT
/

CREATE PUBLIC SYNONYM ADI_PAYMENT FOR ILA500.ADI_PAYMENT
/

