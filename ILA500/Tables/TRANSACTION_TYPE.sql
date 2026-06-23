-- TABLE: TRANSACTION_TYPE
-- Description: Table holding each type of payment transaction for an ILA500 payment.
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      23.06.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      19.10.09   A.Bowman (SAAS)         Added triggers and data
-- 1.2      15.02.10   A.Bowman (SAAS)         Amended audit triggers
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/TRANSACTION_TYPE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:17:44 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5800 $
 
ALTER TABLE TRANSACTION_TYPE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE TRANSACTION_TYPE CASCADE CONSTRAINTS PURGE
/

--
-- TRANSACTION_TYPE (Table) 
--

CREATE TABLE TRANSACTION_TYPE
(
  TRANSACTION_TYPE_ID  NUMBER(10)               NOT NULL,
  DESCRIPTION          VARCHAR2(20 BYTE)        NOT NULL,
  LAST_UPDATED_BY      VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON      DATE                     DEFAULT SYSDATE               NOT NULL
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

COMMENT ON TABLE TRANSACTION_TYPE IS 'Table holding each type of payment transaction for an ILA500 payment';

COMMENT ON COLUMN TRANSACTION_TYPE.TRANSACTION_TYPE_ID IS 'Unique identifier for each transaction type';

COMMENT ON COLUMN TRANSACTION_TYPE.DESCRIPTION IS 'Description of each transaction type';

COMMENT ON COLUMN TRANSACTION_TYPE.LAST_UPDATED_BY IS 'The user to last update or insert a row on the transaction_type table';

COMMENT ON COLUMN TRANSACTION_TYPE.LAST_UPDATED_ON IS 'The date of the latest update or insert on the transaction_type table';


CREATE UNIQUE INDEX TRANSACTION_TYPE_PK ON TRANSACTION_TYPE
(TRANSACTION_TYPE_ID)
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


ALTER TABLE TRANSACTION_TYPE ADD (
  CONSTRAINT TRANSACTION_TYPE_PK
 PRIMARY KEY
 (TRANSACTION_TYPE_ID)
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

/* Formatted on 2008/07/09 14:46 (Formatter Plus v4.8.8) */
-- TRIGGER: TRANS_TYPE_IUD
-- TABLE: TRANSACTION_TYPE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/TRANSACTION_TYPE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:17:44 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5800 $ 
--
CREATE OR REPLACE TRIGGER ila500.trans_type_iud
   AFTER DELETE OR INSERT OR UPDATE OF transaction_type_id, description, last_updated_by
   ON ila500.transaction_type
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                    := SYSDATE;
   p_column_name   transaction_type_aud.column_name%TYPE   := NULL;
   p_primary_key   transaction_type_aud.primary_key%TYPE
                                                  := :OLD.transaction_type_id;
   p_old           transaction_type_aud.OLD%TYPE           := NULL;
   p_new           transaction_type_aud.NEW%TYPE           := NULL;
   p_action        transaction_type_aud.action%TYPE        := NULL;
   p_username      transaction_type_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.transaction_type_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'TRANSACTION_TYPE_ID';
   p_old := :OLD.transaction_type_id;
   p_new := :NEW.transaction_type_id;
   pk_pop_aud.ins_trans_type_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'DESCRIPTION';
   p_old := :OLD.description;
   p_new := :NEW.description;
   pk_pop_aud.ins_trans_type_aud (p_aud_date,
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
   pk_pop_aud.ins_trans_type_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
END trans_type_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 16:13 (Formatter Plus v4.8.8) */
-- TRIGGER: TRANS_TYPE_LUB
-- TABLE: TRANSACTION_TYPE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/TRANSACTION_TYPE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:17:44 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5800 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.trans_type_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.transaction_type
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                    := SYSDATE;
   p_column_name   transaction_type_aud.column_name%TYPE   := NULL;
   p_primary_key   transaction_type_aud.primary_key%TYPE
                                                  := :OLD.transaction_type_id;
   p_old           transaction_type_aud.OLD%TYPE           := NULL;
   p_new           transaction_type_aud.NEW%TYPE           := NULL;
   p_action        transaction_type_aud.action%TYPE        := NULL;
   p_username      transaction_type_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.transaction_type_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_trans_type_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
END trans_type_lub;
/
SHOW ERRORS;*/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM TRANSACTION_TYPE
/

CREATE PUBLIC SYNONYM TRANSACTION_TYPE FOR ILA500.TRANSACTION_TYPE
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON TRANSACTION_TYPE
TO EDM_USER
/

-- TRANSACTION_TYPE_INSERT.sql
-- Description: Script inserts payment transaction type data for ILA500
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      07.07.08    R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/TRANSACTION_TYPE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:17:44 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5800 $

DELETE FROM TRANSACTION_TYPE;

Insert into TRANSACTION_TYPE
   (TRANSACTION_TYPE_ID, DESCRIPTION, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   (1, 'CREDIT', 'ILA500', TO_DATE('07/07/2008 13:57:09', 'MM/DD/YYYY HH24:MI:SS'));

Insert into TRANSACTION_TYPE
   (TRANSACTION_TYPE_ID, DESCRIPTION, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   (2, 'DEBIT', 'ILA500', TO_DATE('07/07/2008 13:57:19', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT
/