-- TABLE: APPLICATION_EVIDENCE
-- Description: Table holding evidence indicators iro learner application info
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      03.06.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      06.06.08   A.Bowman (SAAS)         Added comments iro the table columns
-- 1.2      17.06.08   A.Bowman (SAAS)         Changed name of table to application_evidence
-- 1.3      23.06.08   A.Bowman (SAAS)         Amended evid_id data type
-- 1.4      19.10.09   A.Bowman (SAAS)         Added triggers and data
-- 1.5      15.02.10   A.Bowman (SAAS)         Amended audit triggers
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/APPLICATION_EVIDENCE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
 
ALTER TABLE APPLICATION_EVIDENCE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE APPLICATION_EVIDENCE CASCADE CONSTRAINTS PURGE
/

--
-- APPLICATION_EVIDENCE (Table) 
--

CREATE TABLE APPLICATION_EVIDENCE
(
  EVID_ID          NUMBER(10)             NOT NULL,
  EVID_DESC        VARCHAR2(25 BYTE)            NOT NULL,
  LAST_UPDATED_BY  VARCHAR2(15 BYTE)            DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON  DATE                         DEFAULT SYSDATE               NOT NULL
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

COMMENT ON TABLE APPLICATION_EVIDENCE IS 'Table holding evidence indicators iro learner application info';

COMMENT ON COLUMN APPLICATION_EVIDENCE.EVID_ID IS 'Unique identifier for each evidence scenario';

COMMENT ON COLUMN APPLICATION_EVIDENCE.EVID_DESC IS 'A description of whether evidence has been received or requested';

COMMENT ON COLUMN APPLICATION_EVIDENCE.LAST_UPDATED_BY IS 'The user to last update or insert a row on the APPLICATION_EVIDENCE table';

COMMENT ON COLUMN APPLICATION_EVIDENCE.LAST_UPDATED_ON IS 'The date of the latest update or insert on the APPLICATION_EVIDENCE table';


CREATE UNIQUE INDEX APPLICATION_EVIDENCE_PK ON APPLICATION_EVIDENCE
(EVID_ID)
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


ALTER TABLE APPLICATION_EVIDENCE ADD (
  CONSTRAINT APPLICATION_EVIDENCEPK
 PRIMARY KEY
 (EVID_ID)
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

/* Formatted on 2008/07/08 14:02 (Formatter Plus v4.8.8) */
-- TRIGGER: APP_EVID_IUD
-- TABLE: APPLICATION_EVIDENCE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/APPLICATION_EVIDENCE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.app_evid_iud
   AFTER DELETE OR INSERT OR UPDATE OF evid_id, evid_desc, last_updated_by
   ON ila500.application_evidence
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                        := SYSDATE;
   p_column_name   application_evidence_aud.column_name%TYPE   := NULL;
   p_primary_key   application_evidence_aud.primary_key%TYPE  := :OLD.evid_id;
   p_old           application_evidence_aud.OLD%TYPE           := NULL;
   p_new           application_evidence_aud.NEW%TYPE           := NULL;
   p_action        application_evidence_aud.action%TYPE        := NULL;
   p_username      application_evidence_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.evid_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'EVID_ID';
   p_old := :OLD.evid_id;
   p_new := :NEW.evid_id;
   pk_pop_aud.ins_app_evid_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'EVID_DESC';
   p_old := :OLD.evid_desc;
   p_new := :NEW.evid_desc;
   pk_pop_aud.ins_app_evid_aud (p_aud_date,
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
   pk_pop_aud.ins_app_evid_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
END app_evid_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:29 (Formatter Plus v4.8.8) */
-- TRIGGER: APP_EVID_LUB
-- TABLE: APPLICATION_EVIDENCE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/APPLICATION_EVIDENCE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ILA500.app_evid_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ILA500.APPLICATION_EVIDENCE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                        := SYSDATE;
   p_column_name   application_evidence_aud.column_name%TYPE   := NULL;
   p_primary_key   application_evidence_aud.primary_key%TYPE  := :OLD.evid_id;
   p_old           application_evidence_aud.OLD%TYPE           := NULL;
   p_new           application_evidence_aud.NEW%TYPE           := NULL;
   p_action        application_evidence_aud.action%TYPE        := NULL;
   p_username      application_evidence_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.evid_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_app_evid_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END app_evid_lub;
/
SHOW ERRORS;*/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM APPLICATION_EVIDENCE
/

CREATE PUBLIC SYNONYM APPLICATION_EVIDENCE FOR ILA500.APPLICATION_EVIDENCE
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON APPLICATION_EVIDENCE
TO EDM_USER
/

-- Reference data
-- Table: APPLICATION_EVIDENCE 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
--          17.06.08    A Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: 
-- $Author: 
-- $Date: 
-- $Revision: 

delete from application_evidence;

INSERT INTO APPLICATION_EVIDENCE ( EVID_ID,EVID_DESC ) 
VALUES 
(1,'EVIDENCE_RECEIVED');
INSERT INTO APPLICATION_EVIDENCE ( EVID_ID,EVID_DESC ) 
VALUES 
(2,'EVIDENCE_REQUESTED'); 
commit;
