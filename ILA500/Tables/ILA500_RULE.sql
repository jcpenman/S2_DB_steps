-- TABLE: ILA500_RULE
-- Description: Table containing the RULE of eligibility for an ILA500 application.
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      04.06.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      06.06.08   A.Bowman (SAAS)         Added comments iro the table columns
-- 1.2      23.06.08   A.Bowman (SAAS)         Amended rule_id data type
-- 1.3      19.10.09   A.Bowman (SAAS)         Added triggers and data
-- 1.4      15.02.10   A.Bowman (SAAS)         Amended audit triggers
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ILA500_RULE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
 
ALTER TABLE ILA500_RULE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE ILA500_RULE CASCADE CONSTRAINTS PURGE
/

--
-- ILA500_RULE (Table) 
--

CREATE TABLE ILA500_RULE
( 
  RULE_ID          NUMBER(10)                   NOT NULL,
  RULE_TYPE        VARCHAR2(15 BYTE)            NOT NULL,
  RULE_VALUE       VARCHAR2(100 BYTE)           NOT NULL,
  RULE_STATUS      VARCHAR2(12 BYTE)            NOT NULL,
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

COMMENT ON TABLE ILA500_RULE IS 'Table containing the RULE of eligibility for an ILA500 application.';

COMMENT ON COLUMN ILA500_RULE.RULE_ID IS 'Unique identifier for each ILA500 application rule';

COMMENT ON COLUMN ILA500_RULE.RULE_TYPE IS 'The type of rule';

COMMENT ON COLUMN ILA500_RULE.RULE_VALUE IS 'The current value of the rule';

COMMENT ON COLUMN ILA500_RULE.RULE_STATUS IS 'The current status of the rule, eg applicable, non applicable';

COMMENT ON COLUMN ILA500_RULE.LAST_UPDATED_BY IS 'The user to last update or insert a row on the ILA500_RULE table';

COMMENT ON COLUMN ILA500_RULE.LAST_UPDATED_ON IS 'The date of the latest update or insert on the ILA500 table';


CREATE UNIQUE INDEX ILA500_RULE_PK ON ILA500_RULE
(RULE_ID)
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


ALTER TABLE ILA500_RULE ADD (
  CONSTRAINT ILA500_RULE_PK
 PRIMARY KEY
 (RULE_ID)
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

/* Formatted on 2008/07/09 10:02 (Formatter Plus v4.8.8) */
-- TRIGGER: RULE_IUD
-- TABLE: ILA500_RULE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ILA500_RULE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.rule_iud
   AFTER DELETE OR INSERT OR UPDATE OF rule_id,
                                       rule_type,
                                       rule_value,
                                       rule_status,
                                       last_updated_by
   ON ila500.ila500_rule
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                               := SYSDATE;
   p_column_name   ila500_rule_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_rule_aud.primary_key%TYPE   := :OLD.rule_id;
   p_old           ila500_rule_aud.OLD%TYPE           := NULL;
   p_new           ila500_rule_aud.NEW%TYPE           := NULL;
   p_action        ila500_rule_aud.action%TYPE        := NULL;
   p_username      ila500_rule_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.rule_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'RULE_ID';
   p_old := :OLD.rule_id;
   p_new := :NEW.rule_id;
   pk_pop_aud.ins_rule_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'RULE_TYPE';
   p_old := :OLD.rule_type;
   p_new := :NEW.rule_type;
   pk_pop_aud.ins_rule_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'RULE_VALUE';
   p_old := :OLD.rule_value;
   p_new := :NEW.rule_value;
   pk_pop_aud.ins_rule_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'RULE_STATUS';
   p_old := :OLD.rule_status;
   p_new := :NEW.rule_status;
   pk_pop_aud.ins_rule_aud (p_aud_date,
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
   pk_pop_aud.ins_rule_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
END rule_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:49 (Formatter Plus v4.8.8) */
-- TRIGGER: RULE_LUB
-- TABLE: ILA500_RULES
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ILA500_RULE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.rule_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.ila500_rule
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                := SYSDATE;
   p_column_name   ila500_rule_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_rule_aud.primary_key%TYPE   := :OLD.rule_id;
   p_old           ila500_rule_aud.OLD%TYPE           := NULL;
   p_new           ila500_rule_aud.NEW%TYPE           := NULL;
   p_action        ila500_rule_aud.action%TYPE        := NULL;
   p_username      ila500_rule_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.rule_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_rule_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
END rule_lub;
/
SHOW ERRORS*/


-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM ILA500_RULE
/

CREATE PUBLIC SYNONYM ILA500_RULE FOR ILA500.ILA500_RULE
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON ILA500_RULE
TO EDM_USER
/

-- Reference data
-- Table: ILA500_RULE 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      04.06.08    A.Bowman (SAAS)         Initial Version.
-- 1.1      23.06.08    A.Bowman (SAAS)         Amended data to UPPER case for consistency.
-- 1.2      03.06.09    A.Bowman (SAAS)         Amended rule 3 - Income changed to 22,000
--
-- Configuration Management:
-- $HeadURL: 
-- $Author: 
-- $Date: 
-- $Revision: 

DELETE FROM ILA500_RULE;

INSERT INTO ILA500_RULE (RULE_ID,RULE_TYPE,RULE_VALUE,RULE_STATUS) 
VALUES 
(1,'AGE','THE LEARNER MUST BE OVER 16 YEARS OLD ON THE FIRST DAY OF THEIR COURSE','ACTIVE');

INSERT INTO ILA500_RULE (RULE_ID,RULE_TYPE,RULE_VALUE,RULE_STATUS) 
VALUES 
(2,'RESIDENCY','THE LEARNER MUST BE RESIDENT IN SCOTLAND','ACTIVE');

INSERT INTO ILA500_RULE (RULE_ID,RULE_TYPE,RULE_VALUE,RULE_STATUS) 
VALUES 
(3,'INCOME','THE LEARNERS INCOME MUST BE 22,000 OR LESS PER ANNUM','ACTIVE');

COMMIT;

 
