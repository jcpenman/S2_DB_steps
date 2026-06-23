-- TABLE: APPLICATION_REJECTION
-- Description: Table containing the reasons for rejecting an ILA500 application.
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      03.06.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      06.06.08   A.Bowman (SAAS)         Added comments iro the table columns
-- 1.2      23.06.08   A.Bowman (SAAS)         Amended application_rejection_id data type 
-- 1.3      19.10.09   A.Bowman (SAAS)         Added triggers and data
-- 1.4      15.02.10   A.Bowman (SAAS)         Amended audit triggers
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/APPLICATION_REJECTION.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
 
ALTER TABLE APPLICATION_REJECTION
 DROP PRIMARY KEY CASCADE
/
DROP TABLE APPLICATION_REJECTION CASCADE CONSTRAINTS PURGE
/

--
-- APPLICATION_REJECTION (Table) 
--

CREATE TABLE APPLICATION_REJECTION
(
  APPLICATION_REJECTION_ID    NUMBER(10)  NOT NULL,
  REJECTION_REASON            VARCHAR2(30 BYTE) NOT NULL,
  APPLICATION_REJECTION_DESC  VARCHAR2(200 BYTE) NOT NULL,
  LAST_UPDATED_BY             VARCHAR2(15 BYTE) DEFAULT USER NOT NULL,
  LAST_UPDATED_ON             DATE              DEFAULT SYSDATE NOT NULL
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

COMMENT ON TABLE APPLICATION_REJECTION IS 'Table containing the reasons for rejecting an ILA500 application.';

COMMENT ON COLUMN APPLICATION_REJECTION.APPLICATION_REJECTION_ID IS 'Unique identifier for each application rejection reason';

COMMENT ON COLUMN APPLICATION_REJECTION.REJECTION_REASON IS 'Reason for rejecting ILA500 application';

COMMENT ON COLUMN APPLICATION_REJECTION.APPLICATION_REJECTION_DESC IS 'Description of the rejection reason';

COMMENT ON COLUMN APPLICATION_REJECTION.LAST_UPDATED_BY IS 'The user to last update or insert a row on the application_rejection table';

COMMENT ON COLUMN APPLICATION_REJECTION.LAST_UPDATED_ON IS 'The date of the latest update or insert on the application_rejection table';


CREATE UNIQUE INDEX APPLICATION_REJECTION_PK ON APPLICATION_REJECTION
(APPLICATION_REJECTION_ID)
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


ALTER TABLE APPLICATION_REJECTION ADD (
  CONSTRAINT APPLICATION_REJECTION_PK
 PRIMARY KEY
 (APPLICATION_REJECTION_ID)
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

/* Formatted on 2008/07/08 16:14 (Formatter Plus v4.8.8) */
-- TRIGGER: APP_REJ_IUD
-- TABLE: APPLICATION_REJECTION
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/APPLICATION_REJECTION.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.app_rej_iud
   AFTER DELETE OR INSERT OR UPDATE OF application_rejection_id,
                                       rejection_reason,
                                       application_rejection_desc,
                                       last_updated_by
   ON ila500.application_rejection
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                         := SYSDATE;
   p_column_name   application_rejection_aud.column_name%TYPE   := NULL;
   p_primary_key   application_rejection_aud.primary_key%TYPE
                                             := :OLD.application_rejection_id;
   p_old           application_rejection_aud.OLD%TYPE           := NULL;
   p_new           application_rejection_aud.NEW%TYPE           := NULL;
   p_action        application_rejection_aud.action%TYPE        := NULL;
   p_username      application_rejection_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.application_rejection_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'APPLICATION_REJECTION_ID';
   p_old := :OLD.application_rejection_id;
   p_new := :NEW.application_rejection_id;
   pk_pop_aud.ins_app_rej_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'REJECTION_REASON';
   p_old := :OLD.rejection_reason;
   p_new := :NEW.rejection_reason;
   pk_pop_aud.ins_app_rej_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'APPLICATION_REJECTION_DESC';
   p_old := :OLD.application_rejection_desc;
   p_new := :NEW.application_rejection_desc;
   pk_pop_aud.ins_app_rej_aud (p_aud_date,
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
   pk_pop_aud.ins_app_rej_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END app_rej_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:33 (Formatter Plus v4.8.8) */
-- TRIGGER: APP_REJ_LUB
-- TABLE: APPLICATION_REJECTION
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/APPLICATION_REJECTION.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.app_rej_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.application_rejection
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                         := SYSDATE;
   p_column_name   application_rejection_aud.column_name%TYPE   := NULL;
   p_primary_key   application_rejection_aud.primary_key%TYPE
                                             := :OLD.application_rejection_id;
   p_old           application_rejection_aud.OLD%TYPE           := NULL;
   p_new           application_rejection_aud.NEW%TYPE           := NULL;
   p_action        application_rejection_aud.action%TYPE        := NULL;
   p_username      application_rejection_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.application_rejection_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_app_rej_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END app_rej_lub;
/
SHOW ERRORS;*/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM APPLICATION_REJECTION
/

CREATE PUBLIC SYNONYM APPLICATION_REJECTION FOR ILA500.APPLICATION_REJECTION
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON APPLICATION_REJECTION
TO EDM_USER
/

-- Reference data
-- Table: APPLICATION_REJECTION 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      03.06.08    A.Bowman (SAAS)         Initial Version.
-- 1.1      23.06.08    A.Bowman (SAAS)         Amended data to UPPER case for consistency.
-- 1.2      23.03.09    A.Bowman (SAAS)         Added new rejection reasons 9 and 10
-- 1.3      21.04.09    A.Bowman (SAAS)         Amended the income threshold to 22,000 (application_rejection_id = 4)
--
-- Configuration Management:
-- $HeadURL: 
-- $Author: 
-- $Date: 
-- $Revision:

delete from application_rejection; 

INSERT INTO APPLICATION_REJECTION (APPLICATION_REJECTION_ID,REJECTION_REASON,APPLICATION_REJECTION_DESC) 
VALUES 
(1,'NAME_CHANGED','THE NAME AND DETAILS ON THE APPLICATION FORM HAS BEEN COMPLETELY CHANGED');

INSERT INTO APPLICATION_REJECTION (APPLICATION_REJECTION_ID,REJECTION_REASON,APPLICATION_REJECTION_DESC) 
VALUES 
(2,'AGE','THE LEARNER WILL NOT BE OVER 16 YEARS OLD WHEN THE COURSE STARTS');

INSERT INTO APPLICATION_REJECTION (APPLICATION_REJECTION_ID,REJECTION_REASON,APPLICATION_REJECTION_DESC) 
VALUES 
(3,'RESIDENCY','THE LEARNER IS NOT RESIDENT IN SCOTLAND');

INSERT INTO APPLICATION_REJECTION (APPLICATION_REJECTION_ID,REJECTION_REASON,APPLICATION_REJECTION_DESC) 
VALUES 
(4,'INCOME','THE LEARNERS INCOME IS OVER 22,000');

INSERT INTO APPLICATION_REJECTION (APPLICATION_REJECTION_ID,REJECTION_REASON,APPLICATION_REJECTION_DESC) 
VALUES 
(5,'LEARNING PROVIDER','THE LEARNING PROVIDER IS NOT REGISTERED FOR ILA500');

INSERT INTO APPLICATION_REJECTION (APPLICATION_REJECTION_ID,REJECTION_REASON,APPLICATION_REJECTION_DESC) 
VALUES 
(6,'COURSE LEVEL','THE LEVEL OF COURSE THE LEARNER IS ATTENDING IS NOT ELIGIBLE FOR ILA500 FUNDING');

INSERT INTO APPLICATION_REJECTION (APPLICATION_REJECTION_ID,REJECTION_REASON,APPLICATION_REJECTION_DESC) 
VALUES 
(7,'DUPLICATE APPLICATION','THE LEARNER HAS ALREADY RECEIVED ILA500 FUNDING FOR THE CURRENT ACADEMIC YEAR');

INSERT INTO APPLICATION_REJECTION (APPLICATION_REJECTION_ID,REJECTION_REASON,APPLICATION_REJECTION_DESC) 
VALUES 
(8,'ALREADY RECEIVING FUNDING','THE LEARNER IS NOT ELIGIBLE FOR ILA500 AS THEY HAVE A CURRENT SESSION RECORD ON GRASS/STEPS OR ILA200 AFTER YEAR 1');

INSERT INTO APPLICATION_REJECTION (APPLICATION_REJECTION_ID,REJECTION_REASON,APPLICATION_REJECTION_DESC) 
VALUES 
(9,'NO RESPONSE','THE LEARNER HAS NOT RESPONDED WITHIN 30 DAYS');

INSERT INTO APPLICATION_REJECTION (APPLICATION_REJECTION_ID,REJECTION_REASON,APPLICATION_REJECTION_DESC) 
VALUES 
(10,'EARLY APPLICATION','THE APPLICATION HAS BEEN RECEIVED EARLY');

commit;

 
