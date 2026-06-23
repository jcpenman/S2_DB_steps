-- LEARNER.sql
-- Description: Table holding all learners who have applied for ILA500
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      27.05.08    R Hunter (SAAS)         Initial Version.
-- 1.1      24.06.08    A.Bowman (SAAS)         Amended column name to title_id from title
-- 1.2      27.08.08    R.Hunter (SAAS)         Added new columns for WARNING check flags
-- 1.3      28.08.08    R.Hunter (SAAS)         Added new column ADDR_MAIL_SORT 
-- 1.4      10.11.08    A.Bowman (SAAS)         Removed not null constraint for title_id, housename_no, address_line1, address_line2, 
--                                              postcode and dob in line with changes to func spec.
-- 1.5      11.03.09    A.Bowman (SAAS)         Added not null constraint for title_id, housename_no, address_line1, address_line2 
--                                              and dob in line with FURTHER changes to func spec.
-- 1.6      19.10.09    A.Bowman (SAAS)         Added triggers
-- 1.7      15.02.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

ALTER TABLE LEARNER
 DROP PRIMARY KEY CASCADE
/
DROP TABLE LEARNER CASCADE CONSTRAINTS PURGE
/

--
-- LEARNER  (Table) 
--
CREATE TABLE LEARNER
(
  LEARNER_ID           VARCHAR2(10 BYTE)        NOT NULL,
  TITLE_ID             NUMBER(10)               NOT NULL,
  OTHER_TITLE          VARCHAR2(25 BYTE),
  FORENAME             VARCHAR2(25 BYTE)        NOT NULL,
  SURNAME              VARCHAR2(25 BYTE)        NOT NULL,
  HOUSENAME_NO         VARCHAR2(32 BYTE)        NOT NULL,
  ADDRESS_LINE1        VARCHAR2(65 BYTE)        NOT NULL,
  ADDRESS_LINE2        VARCHAR2(65 BYTE)        NOT NULL,
  ADDRESS_LINE3        VARCHAR2(32 BYTE),
  ADDRESS_LINE4        VARCHAR2(32 BYTE),
  POSTCODE             VARCHAR2(8 BYTE),
  DOB                  DATE                     NOT NULL,
  GENDER               VARCHAR2(1 BYTE),
  TELEPHONE_NO         VARCHAR2(15 BYTE),
  EMAIL_ADDRESS        VARCHAR2(80 BYTE),
  LIVES_SCOTLAND_FLAG  VARCHAR2(1 BYTE),
  LIVES_AWAY_FLAG      VARCHAR2(1 BYTE),
  DECEASED_FLAG        VARCHAR2(1 BYTE),
  MAIL_RETURNED_DATE   DATE,
  HOLD_PAYMENTS        VARCHAR2(1 BYTE),
  HOLD_LETTERS         VARCHAR2(1 BYTE),

  GRASS_CHECKED         VARCHAR2(1 BYTE)        DEFAULT 'N',
  CASES_GRASS_CHECKED   NUMBER                  DEFAULT 0,
  STEPS_CHECKED         VARCHAR2(1 BYTE)        DEFAULT 'N',
  CASES_STEPS_CHECKED   NUMBER                  DEFAULT 0,
  ILA200_CHECKED        VARCHAR2(1 BYTE)        DEFAULT 'N',
  CASES_ILA200_CHECKED  NUMBER                  DEFAULT 0,
  ILA500_CHECKED        VARCHAR2(1 BYTE)        DEFAULT 'N',
  CASES_ILA500_CHECKED  NUMBER                  DEFAULT 0,

  ADDR_MAIL_SORT        VARCHAR2(5 BYTE),

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

COMMENT ON COLUMN LEARNER.LEARNER_ID IS 'Unique learner reference number';

COMMENT ON COLUMN LEARNER.TITLE_ID IS 'Title of learner';

COMMENT ON COLUMN LEARNER.OTHER_TITLE IS 'Used when learner title is not in title dropdown';

COMMENT ON COLUMN LEARNER.FORENAME IS 'First name of learner';

COMMENT ON COLUMN LEARNER.SURNAME IS 'Last name of learner';

COMMENT ON COLUMN LEARNER.HOUSENAME_NO IS 'Name or number of learner address';

COMMENT ON COLUMN LEARNER.ADDRESS_LINE1 IS 'First line of learner address';

COMMENT ON COLUMN LEARNER.ADDRESS_LINE2 IS 'Second line of learner address';

COMMENT ON COLUMN LEARNER.ADDRESS_LINE3 IS 'Third line of learner address';

COMMENT ON COLUMN LEARNER.ADDRESS_LINE4 IS 'Fourth line of learner address';

COMMENT ON COLUMN LEARNER.POSTCODE IS 'Learner post code';

COMMENT ON COLUMN LEARNER.DOB IS 'Learner date of birth';

COMMENT ON COLUMN LEARNER.GENDER IS 'Learner gender';

COMMENT ON COLUMN LEARNER.TELEPHONE_NO IS 'Learner telephone number';

COMMENT ON COLUMN LEARNER.EMAIL_ADDRESS IS 'Learner email address';

COMMENT ON COLUMN LEARNER.LIVES_SCOTLAND_FLAG IS 'Learner lives in Scotland Y or N';

COMMENT ON COLUMN LEARNER.LIVES_AWAY_FLAG IS 'Learner temporarily outside Scotland Y or N';

COMMENT ON COLUMN LEARNER.DECEASED_FLAG IS 'Learner deceased Y or N';

COMMENT ON COLUMN LEARNER.MAIL_RETURNED_DATE IS 'Date that mail was returned undelivered from learner address';

COMMENT ON COLUMN LEARNER.HOLD_PAYMENTS IS 'Hold payments flag Y or N';

COMMENT ON COLUMN LEARNER.HOLD_LETTERS IS 'Hold letters flag Y or N';

COMMENT ON COLUMN LEARNER.LAST_UPDATED_BY IS 'Last person to update Learner record';

COMMENT ON COLUMN LEARNER.LAST_UPDATED_ON IS 'Date Learner record was last updated';


CREATE UNIQUE INDEX LEARNER_PK ON LEARNER
(LEARNER_ID)
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


ALTER TABLE LEARNER ADD (
  CONSTRAINT LEARNER_PK
 PRIMARY KEY
 (LEARNER_ID)
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

/* Formatted on 2008/10/20 15:43 (Formatter Plus v4.8.8) */
-- TRIGGER: LEA_IUD
-- TABLE: LEARNER
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
-- 002      28.08.2008    A.Bowman (SAAS)         Additional Columns added
-- 003      28.08.2008    A.Bowman (SAAS)         Yet another additional column added
-- 004      16.10.2008    A.Bowman (SAAS)         Added Telephony functionality
-- 005      04.06.2009    A.Bowman (SAAS)         Telephony functionality removed, no longer required, surprise surprise
-- 
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
--
CREATE OR REPLACE TRIGGER ILA500.lea_iud
   AFTER DELETE OR INSERT OR UPDATE OF learner_id,
                                       title_id,
                                       other_title,
                                       forename,
                                       surname,
                                       housename_no,
                                       address_line1,
                                       address_line2,
                                       address_line3,
                                       address_line4,
                                       postcode,
                                       dob,
                                       gender,
                                       telephone_no,
                                       email_address,
                                       lives_scotland_flag,
                                       lives_away_flag,
                                       deceased_flag,
                                       mail_returned_date,
                                       hold_payments,
                                       hold_letters,
                                       grass_checked,
                                       cases_grass_checked,
                                       steps_checked,
                                       cases_steps_checked,
                                       ila200_checked,
                                       cases_ila200_checked,
                                       ila500_checked,
                                       cases_ila500_checked,
                                       addr_mail_sort,
                                       last_updated_by
   ON ILA500.LEARNER    FOR EACH ROW
DECLARE
   p_aud_date      DATE                           := SYSDATE;
   p_column_name   learner_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_aud.primary_key%TYPE   := :OLD.learner_id;
   p_old           learner_aud.OLD%TYPE           := NULL;
   p_new           learner_aud.NEW%TYPE           := NULL;
   p_action        learner_aud.action%TYPE        := NULL;
   p_username      learner_aud.username%TYPE      := :NEW.last_updated_by;
   p_learner_id    learner.learner_id%TYPE   := :OLD.learner_id;
   p_table_name    VARCHAR2 (32)                  := 'LEARNER';
   v_updated       VARCHAR2 (1)                   := 'N';
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_learner_id := :OLD.learner_id;
      p_username := :OLD.last_updated_by; 
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.learner_id;
      p_learner_id := :NEW.learner_id;
      
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_learner_id := :OLD.learner_id;
      
   END IF;

   p_column_name := 'LEARNER_ID';
   p_old := :OLD.learner_id;
   p_new := :NEW.learner_id;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'TITLE_ID';
   p_old := :OLD.title_id;
   p_new := :NEW.title_id;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'OTHER_TITLE';
   p_old := :OLD.other_title;
   p_new := :NEW.other_title;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'FORENAME';
   p_old := :OLD.forename;
   p_new := :NEW.forename;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'SURNAME';
   p_old := :OLD.surname;
   p_new := :NEW.surname;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'HOUSENAME_NO';
   p_old := :OLD.housename_no;
   p_new := :NEW.housename_no;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'ADDRESS_LINE1';
   p_old := :OLD.address_line1;
   p_new := :NEW.address_line1;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'ADDRESS_LINE2';
   p_old := :OLD.address_line2;
   p_new := :NEW.address_line2;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'ADDRESS_LINE3';
   p_old := :OLD.address_line3;
   p_new := :NEW.address_line3;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'ADDRESS_LINE4';
   p_old := :OLD.address_line4;
   p_new := :NEW.address_line4;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'POSTCODE';
   p_old := :OLD.postcode;
   p_new := :NEW.postcode;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'DOB';
   p_old := :OLD.dob;
   p_new := :NEW.dob;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'GENDER';
   p_old := :OLD.gender;
   p_new := :NEW.gender;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'TELEPHONE_NO';
   p_old := :OLD.telephone_no;
   p_new := :NEW.telephone_no;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'EMAIL_ADDRESS';
   p_old := :OLD.email_address;
   p_new := :NEW.email_address;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'LIVES_SCOTLAND_FLAG';
   p_old := :OLD.lives_scotland_flag;
   p_new := :NEW.lives_scotland_flag;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'LIVES_AWAY_FLAG';
   p_old := :OLD.lives_away_flag;
   p_new := :NEW.lives_away_flag;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'DECEASED_FLAG';
   p_old := :OLD.deceased_flag;
   p_new := :NEW.deceased_flag;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'MAIL_RETURNED_DATE';
   p_old := :OLD.mail_returned_date;
   p_new := :NEW.mail_returned_date;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'HOLD_PAYMENTS';
   p_old := :OLD.hold_payments;
   p_new := :NEW.hold_payments;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'HOLD_LETTERS';
   p_old := :OLD.hold_letters;
   p_new := :NEW.hold_letters;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'GRASS_CHECKED';
   p_old := :OLD.grass_checked;
   p_new := :NEW.grass_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'CASES_GRASS_CHECKED';
   p_old := :OLD.cases_grass_checked;
   p_new := :NEW.cases_grass_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'STEPS_CHECKED';
   p_old := :OLD.steps_checked;
   p_new := :NEW.steps_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'CASES_STEPS_CHECKED';
   p_old := :OLD.cases_steps_checked;
   p_new := :NEW.cases_steps_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'ILA200_CHECKED';
   p_old := :OLD.ila200_checked;
   p_new := :NEW.ila200_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'CASES_ILA200_CHECKED';
   p_old := :OLD.cases_ila200_checked;
   p_new := :NEW.cases_ila200_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'ILA500_CHECKED';
   p_old := :OLD.ila500_checked;
   p_new := :NEW.ila500_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'CASES_ILA500_CHECKED';
   p_old := :OLD.cases_ila500_checked;
   p_new := :NEW.cases_ila500_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'ADDR_MAIL_SORT';
   p_old := :OLD.addr_mail_sort;
   p_new := :NEW.addr_mail_sort;
   pk_pop_aud.ins_lea_aud (p_aud_date,
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
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
END lea_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:53 (Formatter Plus v4.8.8) */
-- TRIGGER: LEA_LUB
-- TABLE: LEARNER
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.lea_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.learner
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                           := SYSDATE;
   p_column_name   learner_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_aud.primary_key%TYPE   := :OLD.learner_id;
   p_old           learner_aud.OLD%TYPE           := NULL;
   p_new           learner_aud.NEW%TYPE           := NULL;
   p_action        learner_aud.action%TYPE        := NULL;
   p_username      learner_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.learner_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
END lea_lub;
/
SHOW ERRORS;*/

CREATE OR REPLACE TRIGGER trig_LEARNER_DOB BEFORE INSERT OR UPDATE ON LEARNER
FOR EACH ROW
BEGIN
SELECT TRUNC(:new.DOB) into :new.DOB FROM dual;
END;
/
SHOW ERRORS;


GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  LEARNER TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM LEARNER
/

CREATE PUBLIC SYNONYM LEARNER FOR ILA500.LEARNER
/