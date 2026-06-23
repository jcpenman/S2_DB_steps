-- TABLE: PAYMENT_STATUS
-- Description: Table holding the payment status of an ILA500 application
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      06.06.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      23.06.08   A.Bowman (SAAS)         Amended payment_status_id data type
-- 1.2      19.10.09   A.Bowman (SAAS)         Added triggers and data
-- 1.3      15.02.10   A.Bowman (SAAS)         Amended audit triggers
--
-- 
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PAYMENT_STATUS.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

DROP TABLE PAYMENT_STATUS CASCADE CONSTRAINTS PURGE
/

--
-- PAYMENT_STATUS (Table) 
--

CREATE TABLE PAYMENT_STATUS
(
  PAYMENT_STATUS_ID  NUMBER(10)                 NOT NULL,
  PAYMENT_DESC       VARCHAR2(12 BYTE)          NOT NULL,
  LAST_UPDATED_BY    VARCHAR2(15 BYTE)          DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON    DATE                       DEFAULT SYSDATE               NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
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

COMMENT ON TABLE PAYMENT_STATUS IS 'Table holding the payment status of an ILA500 application';

COMMENT ON COLUMN PAYMENT_STATUS.PAYMENT_STATUS_ID IS 'Unique identifier for each payment status';

COMMENT ON COLUMN PAYMENT_STATUS.PAYMENT_DESC IS 'Description of payment status';

COMMENT ON COLUMN PAYMENT_STATUS.LAST_UPDATED_BY IS 'The user to last update or insert a row on the payment_status table';

COMMENT ON COLUMN PAYMENT_STATUS.LAST_UPDATED_ON IS 'The date of the latest update or insert on the payment_status table';


CREATE UNIQUE INDEX PAYMENT_STATUS_PK ON PAYMENT_STATUS
(PAYMENT_STATUS_ID)
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


ALTER TABLE PAYMENT_STATUS ADD (
  CONSTRAINT PAYMENT_STATUS_PK
 PRIMARY KEY
 (PAYMENT_STATUS_ID)
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

/* Formatted on 2008/07/09 14:37 (Formatter Plus v4.8.8) */
-- TRIGGER: PAY_STAT_IUD
-- TABLE: PAYMENT_STATUS
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PAYMENT_STATUS.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.pay_stat_iud
   AFTER DELETE OR INSERT OR UPDATE OF payment_status_id, payment_desc, last_updated_by
   ON ila500.payment_status
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                  := SYSDATE;
   p_column_name   payment_status_aud.column_name%TYPE   := NULL;
   p_primary_key   payment_status_aud.primary_key%TYPE
                                                    := :OLD.payment_status_id;
   p_old           payment_status_aud.OLD%TYPE           := NULL;
   p_new           payment_status_aud.NEW%TYPE           := NULL;
   p_action        payment_status_aud.action%TYPE        := NULL;
   p_username      payment_status_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.payment_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'PAYMENT_STATUS_ID';
   p_old := :OLD.payment_status_id;
   p_new := :NEW.payment_status_id;
   pk_pop_aud.ins_pay_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'PAYMENT_DESC';
   p_old := :OLD.payment_desc;
   p_new := :NEW.payment_desc;
   pk_pop_aud.ins_pay_stat_aud (p_aud_date,
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
   pk_pop_aud.ins_pay_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END pay_stat_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:59 (Formatter Plus v4.8.8) */
-- TRIGGER: PAY_STAT_LUB
-- TABLE: PAYMENT_STATUS
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PAYMENT_STATUS.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.pay_stat_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.payment_status
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                  := SYSDATE;
   p_column_name   payment_status_aud.column_name%TYPE   := NULL;
   p_primary_key   payment_status_aud.primary_key%TYPE
                                                    := :OLD.payment_status_id;
   p_old           payment_status_aud.OLD%TYPE           := NULL;
   p_new           payment_status_aud.NEW%TYPE           := NULL;
   p_action        payment_status_aud.action%TYPE        := NULL;
   p_username      payment_status_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.payment_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_pay_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END pay_stat_lub;
/
SHOW ERRORS;*/

GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  PAYMENT_STATUS TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM PAYMENT_STATUS
/

CREATE PUBLIC SYNONYM PAYMENT_STATUS FOR ILA500.PAYMENT_STATUS
/

-- PAYMENT_STATUS_INSERT.sql
-- Description: Script inserts PAYMENT STATUS data for ILA500
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      07.07.08    R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PAYMENT_STATUS.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

DELETE FROM PAYMENT_STATUS;

Insert into PAYMENT_STATUS
   (PAYMENT_STATUS_ID, PAYMENT_DESC, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   (1, 'UNPAID', 'ILA500', TO_DATE('07/07/2008 14:08:58', 'MM/DD/YYYY HH24:MI:SS'))
/
Insert into PAYMENT_STATUS
   (PAYMENT_STATUS_ID, PAYMENT_DESC, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   (2, 'PAID', 'ILA500', TO_DATE('07/07/2008 14:09:05', 'MM/DD/YYYY HH24:MI:SS'))
/
Insert into PAYMENT_STATUS
   (PAYMENT_STATUS_ID, PAYMENT_DESC, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   (3, 'CANCELLED', 'ILA500', TO_DATE('07/07/2008 14:09:19', 'MM/DD/YYYY HH24:MI:SS'))
/
COMMIT
/
