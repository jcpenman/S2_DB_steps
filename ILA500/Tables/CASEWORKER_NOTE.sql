-- TABLE: CASEWORKER_NOTE
-- Description: Table holding notes created by the caseworkers for reference.
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      28.05.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      06.06.08   A.Bowman (SAAS)         Added comments iro the table columns
-- 1.2      19.10.09   A.Bowman (SAAS)         Added triggers and sequence
-- 1.3      15.02.10   A.Bowman (SAAS)         Amended audit triggers
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/CASEWORKER_NOTE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
 
ALTER TABLE CASEWORKER_NOTE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE caseworker_note CASCADE CONSTRAINTS PURGE
/
--
-- CASEWORKER_note  (Table) 
--
CREATE TABLE CASEWORKER_NOTE
(
  CW_NOTE_ID       NUMBER(10)                   NOT NULL,
  SOURCE_TABLE     VARCHAR2(30 BYTE)            NOT NULL,
  PRIMARY_KEY      VARCHAR2(20 BYTE)            NOT NULL,
  NOTE_TYPE_ID     VARCHAR2(14 BYTE)            NOT NULL,
  NOTE_DATE        DATE,
  SESSION_YEAR     NUMBER(4),
  NOTE_TEXT        VARCHAR2(300 BYTE),
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

COMMENT ON TABLE CASEWORKER_NOTE IS 'Table holding notes created by the caseworkers for reference';

COMMENT ON COLUMN CASEWORKER_NOTE.CW_NOTE_ID IS 'Unique identifier for each caseworker note';

COMMENT ON COLUMN CASEWORKER_NOTE.SOURCE_TABLE IS 'The table which the caseworker note refers, eg Learner, provider';

COMMENT ON COLUMN CASEWORKER_NOTE.PRIMARY_KEY IS 'The primary key of the source table, eg learner_id, provider_id';

COMMENT ON COLUMN CASEWORKER_NOTE.NOTE_TYPE_ID IS 'Unique identifier for the type of note';

COMMENT ON COLUMN CASEWORKER_NOTE.NOTE_DATE IS 'The date the note was made';

COMMENT ON COLUMN CASEWORKER_NOTE.SESSION_YEAR IS 'The session the note refers to';

COMMENT ON COLUMN CASEWORKER_NOTE.NOTE_TEXT IS 'The actual content of the note ';

COMMENT ON COLUMN CASEWORKER_NOTE.LAST_UPDATED_BY IS 'The user to last update or insert a row on the caseworker_note table';

COMMENT ON COLUMN CASEWORKER_NOTE.LAST_UPDATED_ON IS 'The date of the latest update or insert on the caseworker_note table';


CREATE UNIQUE INDEX CASEWORKER_NOTE_PK ON CASEWORKER_NOTE
(CW_NOTE_ID)
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


ALTER TABLE CASEWORKER_NOTE ADD (
  CONSTRAINT CASEWORKER_NOTE_PK
 PRIMARY KEY
 (CW_NOTE_ID)
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

/* Formatted on 2008/07/09 15:12 (Formatter Plus v4.8.8) */
-- TRIGGER: CASE_NOTE_IUD
-- TABLE: CASEWORKER_NOTE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/CASEWORKER_NOTE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.case_note_iud
   AFTER DELETE OR INSERT OR UPDATE OF cw_note_id,
                                       source_table,
                                       primary_key,
                                       note_type_id,
                                       note_date,
                                       session_year,
                                       note_text,
                                       last_updated_by
   ON ila500.caseworker_note
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                   := SYSDATE;
   p_column_name   caseworker_note_aud.column_name%TYPE   := NULL;
   p_primary_key   caseworker_note_aud.primary_key%TYPE   := :OLD.cw_note_id;
   p_old           caseworker_note_aud.OLD%TYPE           := NULL;
   p_new           caseworker_note_aud.NEW%TYPE           := NULL;
   p_action        caseworker_note_aud.action%TYPE        := NULL;
   p_username      caseworker_note_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.cw_note_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'CW_NOTE_ID';
   p_old := :OLD.cw_note_id;
   p_new := :NEW.cw_note_id;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'SOURCE_TABLE';
   p_old := :OLD.source_table;
   p_new := :NEW.source_table;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'PRIMARY_KEY';
   p_old := :OLD.primary_key;
   p_new := :NEW.primary_key;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'NOTE_TYPE_ID';
   p_old := :OLD.note_type_id;
   p_new := :NEW.note_type_id;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'NOTE_DATE';
   p_old := :OLD.note_date;
   p_new := :NEW.note_date;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'SESSION_YEAR';
   p_old := :OLD.session_year;
   p_new := :NEW.session_year;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'NOTE_TEXT';
   p_old := :OLD.note_text;
   p_new := :NEW.note_text;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
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
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END case_note_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:38 (Formatter Plus v4.8.8) */
-- TRIGGER: CASE_NOTE_LUB
-- TABLE: CASEWORKER_NOTE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/CASEWORKER_NOTE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.case_note_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.caseworker_note
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                   := SYSDATE;
   p_column_name   caseworker_note_aud.column_name%TYPE   := NULL;
   p_primary_key   caseworker_note_aud.primary_key%TYPE   := :OLD.cw_note_id;
   p_old           caseworker_note_aud.OLD%TYPE           := NULL;
   p_new           caseworker_note_aud.NEW%TYPE           := NULL;
   p_action        caseworker_note_aud.action%TYPE        := NULL;
   p_username      caseworker_note_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.cw_note_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END case_note_lub;
/
SHOW ERRORS;*/

-- SEQUENCE SCRIPT FOR PK ON caseworker_note TABLE
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      25.08.08    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/CASEWORKER_NOTE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
DROP SEQUENCE cw_note_id_seq
/

--
-- cw_note_id_seq  (Sequence) 
--
CREATE SEQUENCE cw_note_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


CREATE OR REPLACE TRIGGER trig_caseworker_note_seq BEFORE INSERT ON caseworker_note
FOR EACH ROW
BEGIN
SELECT cw_note_id_seq.NEXTVAL into :new.cw_note_id FROM dual;
END;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM caseworker_note
/

CREATE PUBLIC SYNONYM caseworker_note FOR ILA500.caseworker_note
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON caseworker_note
TO EDM_USER
/
