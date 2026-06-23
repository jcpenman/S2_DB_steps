-- NOTE_TYPE.sql
-- Description: Table holding list of all document types
-- Author P Hughes.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      05.06.08    P Hughes (SAAS)         Initial Version.
-- 1.1      23.06.08    A.Bowman (SAAS)         Amended note_type_id data type
-- 1.2      19.10.09    A.Bowman (SAAS)         Added sequence, triggers and data to script
-- 1.3      15.02.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/NOTE_TYPE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

ALTER TABLE NOTE_TYPE
DROP PRIMARY KEY CASCADE
/ 
DROP TABLE NOTE_TYPE CASCADE CONSTRAINTS PURGE
/

--
-- NOTE_TYPE  (Table) 
--
CREATE TABLE NOTE_TYPE
( 
  NOTE_TYPE_ID         NUMBER(10)       NOT NULL,
  DESCRIPTION          VARCHAR(25 BYTE)        NOT NULL,
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

COMMENT ON COLUMN NOTE_TYPE.NOTE_TYPE_ID IS 'Unique 4 digit number for document';
COMMENT ON COLUMN NOTE_TYPE.DESCRIPTION IS 'Description of note type';



CREATE UNIQUE INDEX NOTE_TYPE_PK ON NOTE_TYPE
(NOTE_TYPE_ID)

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

ALTER TABLE NOTE_TYPE ADD (
  CONSTRAINT NOTE_TYPE_PK
 PRIMARY KEY
 (NOTE_TYPE_ID)
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

/* Formatted on 2008/07/09 15:45 (Formatter Plus v4.8.8) */
-- TRIGGER: NOTE_TYPE_IUD
-- TABLE: NOTE_TYPE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/NOTE_TYPE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.note_type_iud
   AFTER DELETE OR INSERT OR UPDATE OF note_type_id, description, last_updated_by
   ON ila500.note_type
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                             := SYSDATE;
   p_column_name   note_type_aud.column_name%TYPE   := NULL;
   p_primary_key   note_type_aud.primary_key%TYPE   := :OLD.note_type_id;
   p_old           note_type_aud.OLD%TYPE           := NULL;
   p_new           note_type_aud.NEW%TYPE           := NULL;
   p_action        note_type_aud.action%TYPE        := NULL;
   p_username      note_type_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.note_type_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'NOTE_TYPE_ID';
   p_old := :OLD.note_type_id;
   p_new := :NEW.note_type_id;
   pk_pop_aud.ins_note_type_aud (p_aud_date,
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
   pk_pop_aud.ins_note_type_aud (p_aud_date,
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
   pk_pop_aud.ins_note_type_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END note_type_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:57 (Formatter Plus v4.8.8) */
-- TRIGGER: NOTE_TYPE_LUB
-- TABLE: NOTE_TYPE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/NOTE_TYPE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.note_type_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.note_type
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                             := SYSDATE;
   p_column_name   note_type_aud.column_name%TYPE   := NULL;
   p_primary_key   note_type_aud.primary_key%TYPE   := :OLD.note_type_id;
   p_old           note_type_aud.OLD%TYPE           := NULL;
   p_new           note_type_aud.NEW%TYPE           := NULL;
   p_action        note_type_aud.action%TYPE        := NULL;
   p_username      note_type_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.note_type_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_note_type_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END note_type_lub;
/
SHOW ERRORS;*/

DROP SEQUENCE note_type_id_seq
/

--
-- note_type_id_seq  (Sequence) 
--
CREATE SEQUENCE note_type_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/

CREATE OR REPLACE TRIGGER trig_note_type_seq BEFORE INSERT ON note_type
FOR EACH ROW
BEGIN
SELECT note_type_id_seq.NEXTVAL into :new.note_type_id FROM dual;
END;


GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  NOTE_TYPE TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM NOTE_TYPE
/

CREATE PUBLIC SYNONYM NOTE_TYPE FOR ILA500.NOTE_TYPE;

-- NOTE_TYPE.sql
-- Description: Table holding list of all document types
-- Author P Hughes.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                 Desc.
-- 001      05.06.08    P Hughes (SAAS)        Initial Version.
-- 002      11.09.08    A.Bowman (SAAS)        Added new note_type
-- 003      17.10.08    A.Bowman (SAAS)        Removed note_type_id as this will be created by a sequence, issue found when deploying to SIT
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/NOTE_TYPE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

delete from note_type;

Insert into NOTE_TYPE
   (DESCRIPTION, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   ('TELEPHONE','ILA500',SYSDATE); 
Insert into NOTE_TYPE
   (DESCRIPTION, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   ('EMAIL','ILA500',SYSDATE);
Insert into NOTE_TYPE
   (DESCRIPTION, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   ('WRITTEN CORRESPONDENCE','ILA500',SYSDATE);
Insert into NOTE_TYPE
   (DESCRIPTION, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   ('FAX CORRESPONDENCE','ILA500',SYSDATE);
---002
Insert into NOTE_TYPE
   (DESCRIPTION, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   ('CASEWORKER NOTE','ILA500',SYSDATE); 
COMMIT;

