-- TITLE.sql
-- Description: Table holding the title options of ILA500 applicants
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      20.06.08    A Bowman (SAAS)         Initial Version.
-- 1.1      23.06.08    A.Bowman (SAAS)         Amended title_id data type.
-- 1.2      19.10.09    A.Bowman (SAAS)         Added triggers and data
-- 1.3      15.02.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/TITLE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

ALTER TABLE TITLE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE TITLE CASCADE CONSTRAINTS PURGE
/

--
-- TITLE  (Table) 
--
CREATE TABLE TITLE
(
  TITLE_ID         NUMBER(10)                   NOT NULL,
  DESCRIPTION      VARCHAR2(15 BYTE)            NOT NULL,
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

COMMENT ON TABLE TITLE IS 'Table holding the title options of ILA500 applicants';

COMMENT ON COLUMN TITLE.TITLE_ID IS 'Unique identifier for each title ';

COMMENT ON COLUMN TITLE.DESCRIPTION IS 'Description of each title ';

COMMENT ON COLUMN TITLE.LAST_UPDATED_BY IS 'The user to last update or insert a row on the title table';

COMMENT ON COLUMN TITLE.LAST_UPDATED_ON IS 'The date of the latest update or insert on the title table';


CREATE UNIQUE INDEX TITLE_PK ON TITLE
(TITLE_ID)
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


ALTER TABLE TITLE ADD (
  CONSTRAINT TITLE_PK
 PRIMARY KEY
 (TITLE_ID)
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

/* Formatted on 2008/07/09 14:42 (Formatter Plus v4.8.8) */
-- TRIGGER: TITLE_IUD
-- TABLE: TITLE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/TITLE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.title_iud
   AFTER DELETE OR INSERT OR UPDATE OF title_id, description, last_updated_by
   ON ila500.title
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                         := SYSDATE;
   p_column_name   title_aud.column_name%TYPE   := NULL;
   p_primary_key   title_aud.primary_key%TYPE   := :OLD.title_id;
   p_old           title_aud.OLD%TYPE           := NULL;
   p_new           title_aud.NEW%TYPE           := NULL;
   p_action        title_aud.action%TYPE        := NULL;
   p_username      title_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.title_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'TITLE_ID';
   p_old := :OLD.title_id;
   p_new := :NEW.title_id;
   pk_pop_aud.ins_title_aud (p_aud_date,
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
   pk_pop_aud.ins_title_aud (p_aud_date,
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
   pk_pop_aud.ins_title_aud (p_aud_date,
                             p_column_name,
                             p_primary_key,
                             p_old,
                             p_new,
                             p_action,
                             p_username
                            );
END title_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 16:12 (Formatter Plus v4.8.8) */
-- TRIGGER: TITLE_LUB
-- TABLE: TITLE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/TITLE.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.title_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.title
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                         := SYSDATE;
   p_column_name   title_aud.column_name%TYPE   := NULL;
   p_primary_key   title_aud.primary_key%TYPE   := :OLD.title_id;
   p_old           title_aud.OLD%TYPE           := NULL;
   p_new           title_aud.NEW%TYPE           := NULL;
   p_action        title_aud.action%TYPE        := NULL;
   p_username      title_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.title_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_title_aud (p_aud_date,
                             p_column_name,
                             p_primary_key,
                             p_old,
                             p_new,
                             p_action,
                             p_username
                            );
END title_lub;
/
SHOW ERRORS;*/


GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  TITLE TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM TITLE
/

CREATE PUBLIC SYNONYM TITLE FOR ILA500.TITLE
/

-- Reference data
-- Table: TITLE 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
--          20.06.08    A Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: 
-- $Author: 
-- $Date: 
-- $Revision:

DELETE FROM TITLE; 

INSERT INTO TITLE (TITLE_ID,DESCRIPTION) 
VALUES 
(1,'MR');
INSERT INTO TITLE (TITLE_ID,DESCRIPTION) 
VALUES 
(2,'MRS');
INSERT INTO TITLE (TITLE_ID,DESCRIPTION) 
VALUES 
(3,'MS');
INSERT INTO TITLE (TITLE_ID,DESCRIPTION) 
VALUES 
(4,'MISS');
INSERT INTO TITLE (TITLE_ID,DESCRIPTION) 
VALUES 
(5,'DR');
INSERT INTO TITLE (TITLE_ID,DESCRIPTION) 
VALUES 
(6,'PROFESSOR');
INSERT INTO TITLE (TITLE_ID,DESCRIPTION) 
VALUES 
(7,'OTHER');
commit;
 
