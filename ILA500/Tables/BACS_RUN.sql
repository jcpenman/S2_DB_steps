-- BACS_RUN.sql
-- Description: Table holding list of bacs run information for ILA500
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      02.07.08    R Hunter (SAAS)         Initial Version.
-- 1.1      19.10.09    A.Bowman (SAAS)         Added triggers and data
-- 1.2      15.02.10    A.Bowman (SAAS)         Amended audit trigger
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/BACS_RUN.sql $
-- $Author: $
-- $Date: 2010-10-21 11:41:13 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5801 $

ALTER TABLE BACS_RUN
 DROP PRIMARY KEY CASCADE
/
DROP TABLE BACS_RUN CASCADE CONSTRAINTS PURGE
/

--
-- BACS_RUN  (Table) 
--
CREATE TABLE BACS_RUN
(
  BACS_RUN_ID     NUMBER NOT NULL,
  BACS_RUN_DATE   DATE NOT NULL,
  BACS_RUN_NAME   VARCHAR2(25 BYTE) NOT NULL,
  LAST_UPDATED_BY VARCHAR2(25 BYTE) DEFAULT USER NOT NULL,
  LAST_UPDATED_ON DATE DEFAULT SYSDATE NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON COLUMN BACS_RUN.BACS_RUN_ID IS 'Unique bacs run identifier';

COMMENT ON COLUMN BACS_RUN.BACS_RUN_DATE IS 'Date of the bacs run';

COMMENT ON COLUMN BACS_RUN.BACS_RUN_NAME IS 'Description of the bacs run';

CREATE UNIQUE INDEX BACS_RUN_PK ON BACS_RUN
(BACS_RUN_ID)
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


ALTER TABLE BACS_RUN ADD (
  CONSTRAINT BACS_RUN_PK
 PRIMARY KEY
 (BACS_RUN_ID)
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

/* Formatted on 2008/07/08 16:45 (Formatter Plus v4.8.8) */
-- TRIGGER: BACS_RUN_IUD
-- TABLE: BACS_RUN
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/BACS_RUN.sql $
-- $Author: $
-- $Date: 2010-10-21 11:41:13 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5801 $ 
--
CREATE OR REPLACE TRIGGER ila500.bacs_run_iud
   AFTER DELETE OR INSERT OR UPDATE OF bacs_run_id,
                                       bacs_run_date,
                                       bacs_run_name,
                                       last_updated_by
   ON ila500.bacs_run
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                            := SYSDATE;
   p_column_name   bacs_run_aud.column_name%TYPE   := NULL;
   p_primary_key   bacs_run_aud.primary_key%TYPE   := :OLD.bacs_run_id;
   p_old           bacs_run_aud.OLD%TYPE           := NULL;
   p_new           bacs_run_aud.NEW%TYPE           := NULL;
   p_action        bacs_run_aud.action%TYPE        := NULL;
   p_username      bacs_run_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.bacs_run_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'BACS_RUN_ID';
   p_old := :OLD.bacs_run_id;
   p_new := :NEW.bacs_run_id;
   pk_pop_aud.ins_bacs_run_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'BACS_RUN_DATE';
   p_old := :OLD.bacs_run_date;
   p_new := :NEW.bacs_run_date;
   pk_pop_aud.ins_bacs_run_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'BACS_RUN_NAME';
   p_old := :OLD.bacs_run_name;
   p_new := :NEW.bacs_run_name;
   pk_pop_aud.ins_bacs_run_aud (p_aud_date,
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
   pk_pop_aud.ins_bacs_run_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END bacs_run_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:36 (Formatter Plus v4.8.8) */
-- TRIGGER: BACS_RUN_LUB
-- TABLE: BACS_RUN
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/BACS_RUN.sql $
-- $Author: $
-- $Date: 2010-10-21 11:41:13 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5801 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.bacs_run_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.bacs_run
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                            := SYSDATE;
   p_column_name   bacs_run_aud.column_name%TYPE   := NULL;
   p_primary_key   bacs_run_aud.primary_key%TYPE   := :OLD.bacs_run_id;
   p_old           bacs_run_aud.OLD%TYPE           := NULL;
   p_new           bacs_run_aud.NEW%TYPE           := NULL;
   p_action        bacs_run_aud.action%TYPE        := NULL;
   p_username      bacs_run_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.bacs_run_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_bacs_run_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END bacs_run_lub;
/
SHOW ERRORS;*/


GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  BACS_RUN TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM BACS_RUN
/

CREATE PUBLIC SYNONYM BACS_RUN FOR ILA500.BACS_RUN
/

-- BACS_RUN_INSERT.sql
-- Description: Script inserts BACS RUN data for ILA500
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      07.07.08    R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/BACS_RUN.sql $
-- $Author: $
-- $Date: 2010-10-21 11:41:13 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5801 $

Delete from BACS_RUN;

Insert into BACS_RUN
   (BACS_RUN_ID, BACS_RUN_DATE, BACS_RUN_NAME, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   (5, TO_DATE('07/02/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'AD HOC', 'RH', TO_DATE('07/02/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

Insert into BACS_RUN
   (BACS_RUN_ID, BACS_RUN_DATE, BACS_RUN_NAME, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   (1, TO_DATE('01/02/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'JANUARY', 'ANG', TO_DATE('07/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

Insert into BACS_RUN
   (BACS_RUN_ID, BACS_RUN_DATE, BACS_RUN_NAME, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   (2, TO_DATE('03/20/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'MARCH', 'ANG', TO_DATE('07/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

Insert into BACS_RUN
   (BACS_RUN_ID, BACS_RUN_DATE, BACS_RUN_NAME, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   (3, TO_DATE('07/19/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'JUNE', 'ANG', TO_DATE('07/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

Insert into BACS_RUN
   (BACS_RUN_ID, BACS_RUN_DATE, BACS_RUN_NAME, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   (4, TO_DATE('09/30/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'SEPTEMBER', 'ANGE', TO_DATE('07/01/2008 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;
