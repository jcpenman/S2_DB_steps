-- TABLE: APPLICATION_STATUS
-- Description: Table containing the status of an ILA500 application.
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      03.06.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      06.06.08   A.Bowman (SAAS)         Added comments iro the table columns
-- 1.2      23.06.08   A.Bowman (SAAS)         Amended application_status_id data type
-- 1.3      19.10.09   A.Bowman (SAAS)         Added triggers and data
-- 1.4      15.02.10   A.Bowman (SAAS)         Amended audit triggers
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/APPLICATION_STATUS.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
 
ALTER TABLE APPLICATION_STATUS
 DROP PRIMARY KEY CASCADE
/
DROP TABLE APPLICATION_STATUS CASCADE CONSTRAINTS PURGE
/

--
-- APPLICATION_STATUS (Table) 
--

CREATE TABLE APPLICATION_STATUS
(
  APPLICATION_STATUS_ID    NUMBER(10)    NOT NULL,
  STATUS                   VARCHAR2(20 BYTE)   NOT NULL,
  APPLICATION_STATUS_DESC  VARCHAR2(200 BYTE)    NOT NULL,
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

COMMENT ON TABLE APPLICATION_STATUS IS 'Table containing the status of an ILA500 application';

COMMENT ON COLUMN APPLICATION_STATUS.APPLICATION_STATUS_ID IS 'Unique identifier for each application status';

COMMENT ON COLUMN APPLICATION_STATUS.STATUS IS 'The status of the application';

COMMENT ON COLUMN APPLICATION_STATUS.APPLICATION_STATUS_DESC IS 'A description of the application status';

COMMENT ON COLUMN APPLICATION_STATUS.LAST_UPDATED_BY IS 'The user to last update or insert a row on the application_status table';

COMMENT ON COLUMN APPLICATION_STATUS.LAST_UPDATED_ON IS 'The date of the latest update or insert on the application_status table';


CREATE UNIQUE INDEX APPLICATION_STATUS_PK ON APPLICATION_STATUS
(APPLICATION_STATUS_ID)
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


ALTER TABLE APPLICATION_STATUS ADD (
  CONSTRAINT APPLICATION_STATUS_PK
 PRIMARY KEY
 (APPLICATION_STATUS_ID)
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

/* Formatted on 2008/07/08 16:25 (Formatter Plus v4.8.8) */
-- TRIGGER: APP_STAT_IUD
-- TABLE: APPLICATION_STATUS
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/APPLICATION_STATUS.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.app_stat_iud
   AFTER DELETE OR INSERT OR UPDATE OF application_status_id,
                                       status,
                                       application_status_desc,
                                       last_updated_by
   ON ila500.application_status
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                      := SYSDATE;
   p_column_name   application_status_aud.column_name%TYPE   := NULL;
   p_primary_key   application_status_aud.primary_key%TYPE
                                                := :OLD.application_status_id;
   p_old           application_status_aud.OLD%TYPE           := NULL;
   p_new           application_status_aud.NEW%TYPE           := NULL;
   p_action        application_status_aud.action%TYPE        := NULL;
   p_username      application_status_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.application_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'APPLICATION_STATUS_ID';
   p_old := :OLD.application_status_id;
   p_new := :NEW.application_status_id;
   pk_pop_aud.ins_app_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'STATUS';
   p_old := :OLD.status;
   p_new := :NEW.status;
   pk_pop_aud.ins_app_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'APPLICATION_STATUS_DESC';
   p_old := :OLD.application_status_desc;
   p_new := :NEW.application_status_desc;
   pk_pop_aud.ins_app_stat_aud (p_aud_date,
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
   pk_pop_aud.ins_app_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END app_stat_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:34 (Formatter Plus v4.8.8) */
-- TRIGGER: APP_STAT_LUB
-- TABLE: APPLICATION_STATUS
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/APPLICATION_STATUS.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.app_stat_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.application_status
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                      := SYSDATE;
   p_column_name   application_status_aud.column_name%TYPE   := NULL;
   p_primary_key   application_status_aud.primary_key%TYPE
                                                := :OLD.application_status_id;
   p_old           application_status_aud.OLD%TYPE           := NULL;
   p_new           application_status_aud.NEW%TYPE           := NULL;
   p_action        application_status_aud.action%TYPE        := NULL;
   p_username      application_status_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.application_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_app_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END app_stat_lub;
/
SHOW ERRORS;*/



-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM APPLICATION_STATUS
/

CREATE PUBLIC SYNONYM APPLICATION_STATUS FOR ILA500.APPLICATION_STATUS
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON APPLICATION_STATUS
TO EDM_USER
/

-- Reference data
-- Table: APPLICATION_STATUS 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
--          03.06.08    A.Bowman (SAAS)         Initial Version.
--          23.06.08    A.Bowman (SAAS)         Amended data to UPPER case for consistency.
--
-- Configuration Management:
-- $HeadURL: 
-- $Author: 
-- $Date: 
-- $Revision: 

DELETE FROM APPLICATION_STATUS;

INSERT INTO APPLICATION_STATUS (APPLICATION_STATUS_ID,STATUS,APPLICATION_STATUS_DESC) 
VALUES 
(1,'NEW','AN APPLICATION HAS BEEN REGISTERED ON ILA500 BUT HAS NOT YET BEEN PROCESSED');
          
INSERT INTO APPLICATION_STATUS (APPLICATION_STATUS_ID,STATUS,APPLICATION_STATUS_DESC) 
VALUES 
(2,'CALCULATED','THE APPLICATION HAS BEEN SUCCESSFULLY PROCESSED');
                 
INSERT INTO APPLICATION_STATUS (APPLICATION_STATUS_ID,STATUS,APPLICATION_STATUS_DESC) 
VALUES 
(3,'RETURNED','THE LEARNER HAS BEEN ASKED TO PROVIDE FURTHER INFORMATION RELATING TO THEIR APPLICATION');
               
INSERT INTO APPLICATION_STATUS (APPLICATION_STATUS_ID,STATUS,APPLICATION_STATUS_DESC) 
VALUES 
(4,'REJECTED','THE APPLICATION HAS BEEN REJECTED');
               
INSERT INTO APPLICATION_STATUS (APPLICATION_STATUS_ID,STATUS,APPLICATION_STATUS_DESC) 
VALUES 
(5,'WITHDRAWN','CONFIRMATION HAS BEEN RECEIVED THAT THE LEARNER HAS WITHDRAWN FROM THEIR COURSE');
                
INSERT INTO APPLICATION_STATUS (APPLICATION_STATUS_ID,STATUS,APPLICATION_STATUS_DESC) 
VALUES 
(6,'NON_ATTENDANCE','CONFIRMATION HAS BEEN RECEIVED THAT THE LEARNER HAS NOT ATTENDED THEIR COURSE');
                     
commit;

 

