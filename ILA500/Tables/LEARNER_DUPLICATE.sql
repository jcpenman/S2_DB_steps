-- learner_duplicate.sql
-- Description: Table holding all learner duplicates in ILA500
-- e.g. in year 1 john smith has ila ref abc123
--      in year 2 john smith submits a form with ila ref xyz000
--      we will use abc123 for john smith, but we will capture "xyz000" in the learner duplicate table
--      in year 3 john smith submits a form with ila ref awk777
--      we will use abc123 for john smith, but we will capture "awk777" in the learner duplicate table
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      02.07.08    R Hunter (SAAS)         Initial Version.
-- 2.0      27.08.08    R Hunter (SAAS)         Amended to include duplicates
--                                              identified using UI warning
--                                              flags
-- 3.0      19.10.09    A.Bowman (SAAS)         Added triggers and sequence
-- 3.1      15.02.10    A.Bowman (SAAS)         Amended audit triggers 
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER_DUPLICATE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

ALTER TABLE learner_duplicate
 DROP PRIMARY KEY CASCADE
/
DROP TABLE learner_duplicate CASCADE CONSTRAINTS PURGE
/

--
-- learner_duplicate  (Table) 
--
CREATE TABLE learner_duplicate
(
  	learner_duplicate_ID          	NUMBER       NOT NULL,
	learner_id 			VARCHAR2(10 BYTE),
    duplicate_system    VARCHAR2(10 BYTE),
	duplicate_id 		VARCHAR2(10 BYTE),
    dsa_duplicate       VARCHAR2(1 BYTE),
  	LAST_UPDATED_BY      		VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  	LAST_UPDATED_ON      		DATE                     DEFAULT SYSDATE               NOT NULL
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

COMMENT ON COLUMN learner_duplicate.learner_duplicate_ID IS 'Unique learner_duplicate reference number';
COMMENT ON COLUMN learner_duplicate.learner_ID IS 'Correct ILA reference number for this learner - FK to learner table';
COMMENT ON COLUMN learner_duplicate.duplicate_id IS 'Incorrect ILA reference number for this learner';


CREATE UNIQUE INDEX learner_duplicate_PK ON learner_duplicate
(learner_duplicate_ID)
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


ALTER TABLE learner_duplicate ADD (
  CONSTRAINT learner_duplicate_PK
 PRIMARY KEY
 (learner_duplicate_ID)
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

/* Formatted on 2008/08/28 13:56 (Formatter Plus v4.8.8) */
-- TRIGGER: LEA_DUP_IUD
-- TABLE: LEARNER_DUPLICATE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
-- 002      28.08.2008    A.Bowman (SAAS)         Additional columns to be audited
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER_DUPLICATE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
--
CREATE OR REPLACE TRIGGER ila500.lea_dup_iud
   AFTER DELETE OR INSERT OR UPDATE OF learner_duplicate_id,
                                       learner_id,
                                       duplicate_system,
                                       duplicate_id,
                                       dsa_duplicate,
                                       last_updated_by
   ON ila500.learner_duplicate
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   learner_duplicate_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_duplicate_aud.primary_key%TYPE
                                                 := :OLD.learner_duplicate_id;
   p_old           learner_duplicate_aud.OLD%TYPE           := NULL;
   p_new           learner_duplicate_aud.NEW%TYPE           := NULL;
   p_action        learner_duplicate_aud.action%TYPE        := NULL;
   p_username      learner_duplicate_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.learner_duplicate_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'LEARNER_DUPLICATE_ID';
   p_old := :OLD.learner_duplicate_id;
   p_new := :NEW.learner_duplicate_id;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LEARNER_ID';
   p_old := :OLD.learner_id;
   p_new := :NEW.learner_id;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DUPLICATE_SYSTEM';
   p_old := :OLD.duplicate_system;
   p_new := :NEW.duplicate_system;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DUPLICATE_ID';
   p_old := :OLD.duplicate_id;
   p_new := :NEW.duplicate_id;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DSA_DUPLICATE';
   p_old := :OLD.dsa_duplicate;
   p_new := :NEW.dsa_duplicate;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
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
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END lea_dup_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:54 (Formatter Plus v4.8.8) */
-- TRIGGER: LEA_DUP_LUB
-- TABLE: LEARNER_DUPLICATE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER_DUPLICATE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.lea_dup_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.learner_duplicate
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   learner_duplicate_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_duplicate_aud.primary_key%TYPE
                                                 := :OLD.learner_duplicate_id;
   p_old           learner_duplicate_aud.OLD%TYPE           := NULL;
   p_new           learner_duplicate_aud.NEW%TYPE           := NULL;
   p_action        learner_duplicate_aud.action%TYPE        := NULL;
   p_username      learner_duplicate_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.learner_duplicate_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END lea_dup_lub;
/
SHOW ERRORS;*/

-- SEQUENCE SCRIPT FOR PK ON learner_duplicate TABLE
-- Author R. Hunter (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      27.08.08    R.Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER_DUPLICATE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
DROP SEQUENCE learner_duplicate_id_seq
/

--
-- learner_duplicate_id_seq  (Sequence) 
--
CREATE SEQUENCE learner_duplicate_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


CREATE OR REPLACE TRIGGER trig_learner_duplicate_seq BEFORE INSERT ON learner_duplicate
FOR EACH ROW
BEGIN
SELECT learner_duplicate_id_seq.NEXTVAL into :new.learner_duplicate_id FROM dual;
END;

GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  learner_duplicate TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM learner_duplicate
/

CREATE PUBLIC SYNONYM learner_duplicate FOR ILA500.learner_duplicate
/