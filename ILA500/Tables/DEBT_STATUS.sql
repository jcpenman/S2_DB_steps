-- TABLE: DEBT_STATUS
-- Description: Table containing the debt status of an ILA500 application.
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      11.11.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      19.10.09   A.Bowman (SAAS)         Added triggers and data
-- 1.2      15.02.10   A.Bowman (SAAS)         Amended audit triggers
-- 
--
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date: $
-- $Revision: $
 
ALTER TABLE DEBT_STATUS
 DROP PRIMARY KEY CASCADE
/
DROP TABLE DEBT_STATUS CASCADE CONSTRAINTS PURGE
/

--
-- DEBT_STATUS (Table) 
--

CREATE TABLE DEBT_STATUS
(
  DEBT_STATUS_ID           NUMBER(10)    NOT NULL,
  DEBT_STATUS_DESC         VARCHAR2(40 BYTE)   NOT NULL,
  LAST_UPDATED_BY          VARCHAR2(15 BYTE)    DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON          DATE                 DEFAULT SYSDATE               NOT NULL
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

COMMENT ON TABLE DEBT_STATUS IS 'Table containing the status of an ILA500 application';

COMMENT ON COLUMN DEBT_STATUS.DEBT_STATUS_ID IS 'Unique identifier for each debt status';

COMMENT ON COLUMN DEBT_STATUS.DEBT_STATUS_DESC IS 'The debt status of the application';

COMMENT ON COLUMN DEBT_STATUS.LAST_UPDATED_BY IS 'The user to last update or insert a row on the application_status table';

COMMENT ON COLUMN DEBT_STATUS.LAST_UPDATED_ON IS 'The date of the latest update or insert on the application_status table';


CREATE UNIQUE INDEX DEBT_STATUS_PK ON DEBT_STATUS
(DEBT_STATUS_ID)
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


ALTER TABLE DEBT_STATUS ADD (
  CONSTRAINT DEBT_STATUS_PK
 PRIMARY KEY
 (DEBT_STATUS_ID)
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


-- TRIGGER: DEBT_STATUS_IUD
-- TABLE: DEBT_STATUS
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      11.11.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 
--
CREATE OR REPLACE TRIGGER ila500.debt_status_iud
   AFTER DELETE OR INSERT OR UPDATE OF debt_status_id, debt_status_desc, last_updated_by
   ON ila500.debt_status
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                    := SYSDATE;
   p_column_name   debt_status_aud.column_name%TYPE   := NULL;
   p_primary_key   debt_status_aud.primary_key%TYPE
                                                  := :OLD.debt_status_id;
   p_old           debt_status_aud.OLD%TYPE           := NULL;
   p_new           debt_status_aud.NEW%TYPE           := NULL;
   p_action        debt_status_aud.action%TYPE        := NULL;
   p_username      debt_status_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.debt_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'DEBT_STATUS_ID';
   p_old := :OLD.debt_status_id;
   p_new := :NEW.debt_status_id;
   pk_pop_aud.ins_debt_status_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'DESCRIPTION';
   p_old := :OLD.debt_status_desc;
   p_new := :NEW.debt_status_desc;
   pk_pop_aud.ins_debt_status_aud (p_aud_date,
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
   pk_pop_aud.ins_debt_status_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
END debt_status_iud;

SHOW ERRORS;


-- TRIGGER: DEBT_STATUS_LUB
-- TABLE: DEBT_STATUS
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      11.11.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $
--
/*CREATE OR REPLACE TRIGGER ila500.debt_status_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.debt_status
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                    := SYSDATE;
   p_column_name   debt_status_aud.column_name%TYPE   := NULL;
   p_primary_key   debt_status_aud.primary_key%TYPE
                                                  := :OLD.debt_status_id;
   p_old           debt_status_aud.OLD%TYPE           := NULL;
   p_new           debt_status_aud.NEW%TYPE           := NULL;
   p_action        debt_status_aud.action%TYPE        := NULL;
   p_username      debt_status_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.debt_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_debt_status_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
END debt_status_lub;
/
SHOW ERRORS;*/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM DEBT_STATUS
/

CREATE PUBLIC SYNONYM DEBT_STATUS FOR ILA500.DEBT_STATUS
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON DEBT_STATUS
TO EDM_USER
/

-- DEBT_STATUS_INSERT.sql
-- Description: Script inserts debt status data for ILA500
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      11.11.08    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date: $
-- $Revision: $

DELETE FROM DEBT_STATUS;

Insert into DEBT_STATUS
   (DEBT_STATUS_ID, DEBT_STATUS_DESC) 
 Values
   (1, 'NOT RECOVERED');
Insert into DEBT_STATUS
   (DEBT_STATUS_ID, DEBT_STATUS_DESC)
 Values
   (2, 'RECOVERED AUTOMATICALLY');
Insert into DEBT_STATUS
   (DEBT_STATUS_ID, DEBT_STATUS_DESC)
 Values
   (3, 'RECOVERED MANUALLY');
COMMIT
/