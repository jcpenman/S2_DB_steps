-- TABLE: SHELL_LETTER
-- Description: Table holding details of each shell letter for ILA500
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      06.06.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      19.10.09   A.Bowman (SAAS)         Added triggers, sequence and data
-- 1.2      15.02.10   A.Bowman (SAAS)         Amended audit triggers
--1.3       17.05.10   P.Grace(SAAS)		Added new letter desc
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/SHELL_LETTER.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
 
ALTER TABLE SHELL_LETTER
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SHELL_LETTER CASCADE CONSTRAINTS PURGE
/

--
-- SHELL_LETTER  (Table) 
--
CREATE TABLE SHELL_LETTER
(
  DOC_ID           NUMBER(10)                   NOT NULL,
  DOC_NAME         VARCHAR2(12 BYTE)            NOT NULL,
  DOC_DESC         VARCHAR2(100 BYTE)           NOT NULL,
  LAST_UPDATED_BY  VARCHAR2(15 BYTE)            DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON  DATE                         DEFAULT SYSDATE               NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          504K
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

COMMENT ON TABLE SHELL_LETTER IS 'Table holding details of each shell letter for ILA500';

COMMENT ON COLUMN SHELL_LETTER.DOC_ID IS 'Primary key.';

COMMENT ON COLUMN SHELL_LETTER.DOC_NAME IS 'File name of original document.';

COMMENT ON COLUMN SHELL_LETTER.DOC_DESC IS 'Free text information on the file.';

COMMENT ON COLUMN SHELL_LETTER.LAST_UPDATED_ON IS 'The user to last update or insert a row on the shell_LETTER table';

COMMENT ON COLUMN SHELL_LETTER.LAST_UPDATED_BY IS 'The date of the latest update or insert on the shell_LETTER table';


CREATE UNIQUE INDEX P_SHELL_LETTER ON SHELL_LETTER
(DOC_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


-- 
-- Non Foreign Key Constraints for Table SHELL_LETTER
-- 
ALTER TABLE SHELL_LETTER ADD (
  CONSTRAINT P_SHELL_LETTER
 PRIMARY KEY
 (DOC_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          104K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

/* Formatted on 2008/07/09 14:52 (Formatter Plus v4.8.8) */
-- TRIGGER: SHELL_LTR_IUD
-- TABLE: SHELL_LETTER
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/SHELL_LETTER.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.shell_ltr_iud
   AFTER DELETE OR INSERT OR UPDATE OF doc_id, doc_name, doc_desc, last_updated_by
   ON ila500.shell_letter
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                := SYSDATE;
   p_column_name   shell_letter_aud.column_name%TYPE   := NULL;
   p_primary_key   shell_letter_aud.primary_key%TYPE   := :OLD.doc_id;
   p_old           shell_letter_aud.OLD%TYPE           := NULL;
   p_new           shell_letter_aud.NEW%TYPE           := NULL;
   p_action        shell_letter_aud.action%TYPE        := NULL;
   p_username      shell_letter_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.doc_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'DOC_ID';
   p_old := :OLD.doc_id;
   p_new := :NEW.doc_id;
   pk_pop_aud.ins_shell_ltr_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'DOC_NAME';
   p_old := :OLD.doc_name;
   p_new := :NEW.doc_name;
   pk_pop_aud.ins_shell_ltr_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'DOC_DESC';
   p_old := :OLD.doc_desc;
   p_new := :NEW.doc_desc;
   pk_pop_aud.ins_shell_ltr_aud (p_aud_date,
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
   pk_pop_aud.ins_shell_ltr_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END shell_ltr_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 16:10 (Formatter Plus v4.8.8) */
-- TRIGGER: SHELL_LTR_LUB
-- TABLE: SHELL_LETTER
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/SHELL_LETTER.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.shell_ltr_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.shell_letter
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                := SYSDATE;
   p_column_name   shell_letter_aud.column_name%TYPE   := NULL;
   p_primary_key   shell_letter_aud.primary_key%TYPE   := :OLD.doc_id;
   p_old           shell_letter_aud.OLD%TYPE           := NULL;
   p_new           shell_letter_aud.NEW%TYPE           := NULL;
   p_action        shell_letter_aud.action%TYPE        := NULL;
   p_username      shell_letter_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.doc_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_shell_ltr_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END shell_ltr_lub;
/
SHOW ERRORS;*/

-- SEQUENCE SCRIPT FOR PK ON SHELL_LETTER TABLE
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      10.10.08    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/SHELL_LETTER.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

--#SHELL_LETTER.DOC.ID SEQUENCE###############################

DROP SEQUENCE doc_id_seq;

CREATE SEQUENCE doc_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;

GRANT SELECT ON doc_id_seq
TO PUBLIC;

GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  SHELL_LETTER TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM SHELL_LETTER;

CREATE PUBLIC SYNONYM SHELL_LETTER FOR ILA500.SHELL_LETTER;

-- Reference data
-- Table: SHELL_LETTER 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      24.06.08    A Bowman (SAAS)         Initial Version.
--
-- Configuration Management: $
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/SHELL_LETTER.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 

DELETE FROM SHELL_LETTER;

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(1,'GENERIC','GENERIC REJECTION LETTER');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(2,'AGE','REJECTION LETTER AS STUDENT IS UNDER 16 YEARS OF AGE WHEN THE COURSE STARTS');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(3,'DETAILS','REJECTION LETTER AS DETAILS HAVE BEEN AMENDED');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(4,'BLANK','BLANK SHELL LETTER');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(5,'COURSE','REJECTION LETTER AS COURSE IS NOT ELIGIBLE FOR PART TIME FEE GRANT SUPPORT');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(6,'DUPLICATE','REJECTION LETTER AS APPLICANT HAS ALREADY APPLIED FOR PART TIME SUPPORT IN THE SESSION');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(7,'INCOME','REJECTION LETTER AS INCOME IS GREATER THAN 22000');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(8,'RESIDENCY','REJECTION LETTER AS STUDENT IS NOT RESIDENT IN SCOTLAND');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(9,'UNSIGNED','RETURNED LETTER AS APPLICATION FORM IS UNSIGNED');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(10,'ENDORSED','RETURNED LETTER AS APPLICATION HAS NOT BEEN ENDORSED BY INSTITUTION');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(11,'REQUEST','LETTER REQUESTING MORE INCOME EVIDENCE');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(12,'NO INCOME','LETTER REQUESTING PROOF OF NO INCOME');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(13, 'EARLY', 'LETTER REJECTING EARLY APPLICATION');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(14, 'EARLYOU', 'LETTER REJECTING EARLY OU APPLICATION');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(15, 'SELFEMP', 'LETTER REQUESTING EVIDENCE OF SELF EMPLOYMENT');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(16, 'ADD_DETAILS', 'RETURN LETTER AS ADDITIONAL DETS NOT COMPLETE');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(17, 'NO_RESIDENCY', 'RETURN LETTER AS RESIDENCY NOT COMPLETE');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(18, 'NO_SIGNATURE', 'aPPLICATION HAS NOT BEEN SIGNED');

INSERT INTO SHELL_LETTER (DOC_ID,DOC_NAME,DOC_DESC) 
VALUES 
(19, 'PAYSLIPS', 'RETURN LETTER AS PAYSLIP HANDWRITTEN');

commit;
 
