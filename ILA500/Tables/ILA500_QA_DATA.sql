-- TABLE: ILA500_QA_DATA
-- Description: Table containing the QA data for ILA500.
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      04.06.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      06.06.08   A.Bowman (SAAS)         Added comments iro the table columns
-- 1.2      19.10.09   A.Bowman (SAAS)         Added triggers
-- 1.3      15.02.10   A.Bowman (SAAS)         Amended audit triggers
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ILA500_QA_DATA.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

ALTER TABLE ila500_qa_data
 DROP PRIMARY KEY CASCADE
/
DROP TABLE ila500_qa_data CASCADE CONSTRAINTS PURGE
/
--
-- ILA500_QA_DATA  (Table) 
--
CREATE TABLE ila500_qa_data
(
  username         VARCHAR2(15 BYTE) CONSTRAINT nn_iqd_username NOT NULL,
  qa_type          VARCHAR2(1 BYTE) CONSTRAINT nn_iqd_qa_type NOT NULL,
  qa_level         NUMBER(3)                    DEFAULT 100,
  no_processed     NUMBER(7)                    DEFAULT 0,
  no_qa            NUMBER(7)                    DEFAULT 1,
  no_fail_qa       NUMBER(7)                    DEFAULT 0,
  last_updated_by  VARCHAR2(15 BYTE)            DEFAULT USER CONSTRAINT nn_iqd_last_updated_by NOT NULL,
  last_updated_on  DATE                         DEFAULT SYSDATE CONSTRAINT nn_iqd_last_updated_on NOT NULL
)
TABLESPACE users
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200 k
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCOMPRESS
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE ILA500_QA_DATA IS 'Table containing the QA data for ILA500';

COMMENT ON COLUMN ILA500_QA_DATA.USERNAME IS 'The unique identifier of the user carrying out the QA';

COMMENT ON COLUMN ILA500_QA_DATA.QA_TYPE IS 'The type of QA';

COMMENT ON COLUMN ILA500_QA_DATA.QA_LEVEL IS 'The level of QA';

COMMENT ON COLUMN ILA500_QA_DATA.NO_PROCESSED IS 'A count of how many cases the user has processed';

COMMENT ON COLUMN ILA500_QA_DATA.NO_QA IS 'A count for how many cases have gone to QA for the user';

COMMENT ON COLUMN ILA500_QA_DATA.NO_FAIL_QA IS 'The number of cases that have failed the QA for the user';

COMMENT ON COLUMN ILA500_QA_DATA.LAST_UPDATED_BY IS 'The user to last update or insert a row on the ILA500_QA_DATA table';

COMMENT ON COLUMN ILA500_QA_DATA.LAST_UPDATED_ON IS 'The date of the latest update or insert on the ILA500_QA_DATA table';


--
-- P_SQD  (Index) 
--
CREATE UNIQUE INDEX p_iqd ON ila500_qa_data
(username)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104 k
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

-- 
-- Non Foreign Key Constraints for Table ILA500_QA_DATA 
-- 
ALTER TABLE ila500_qa_data ADD (
  CONSTRAINT p_sqd
 PRIMARY KEY
 (username)
    USING INDEX
    TABLESPACE users
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          104 k
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ))
/



ALTER TABLE ILA500_QA_DATA ADD (
  CONSTRAINT QATYPES
 CHECK ( QA_TYPE IN('U', 'S')))
/

/* Formatted on 2008/07/09 10:15 (Formatter Plus v4.8.8) */
-- TRIGGER: QA_DATA_IUD
-- TABLE: ILA500_QA_DATA
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ILA500_QA_DATA.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.qa_data_iud
   AFTER DELETE OR INSERT OR UPDATE OF username,
                                       qa_type,
                                       qa_level,
                                       no_processed,
                                       no_qa,
                                       no_fail_qa,
                                       last_updated_by
   ON ila500.ila500_qa_data
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                  := SYSDATE;
   p_column_name   ila500_qa_data_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_qa_data_aud.primary_key%TYPE   := :OLD.username;
   p_old           ila500_qa_data_aud.OLD%TYPE           := NULL;
   p_new           ila500_qa_data_aud.NEW%TYPE           := NULL;
   p_action        ila500_qa_data_aud.action%TYPE        := NULL;
   p_username      ila500_qa_data_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.username;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'USERNAME';
   p_old := :OLD.username;
   p_new := :NEW.username;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'QA_TYPE';
   p_old := :OLD.qa_type;
   p_new := :NEW.qa_type;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'QA_LEVEL';
   p_old := :OLD.qa_level;
   p_new := :NEW.qa_level;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NO_PROCESSED';
   p_old := :OLD.no_processed;
   p_new := :NEW.no_processed;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NO_QA';
   p_old := :OLD.no_qa;
   p_new := :NEW.no_qa;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NO_FAIL_QA';
   p_old := :OLD.no_fail_qa;
   p_new := :NEW.no_fail_qa;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
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
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END qa_data_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:46 (Formatter Plus v4.8.8) */
-- TRIGGER: QA_DATA_LUB
-- TABLE: ILA500_QA_DATA
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ILA500_QA_DATA.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.qa_data_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.ila500_qa_data
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                  := SYSDATE;
   p_column_name   ila500_qa_data_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_qa_data_aud.primary_key%TYPE   := :OLD.username;
   p_old           ila500_qa_data_aud.OLD%TYPE           := NULL;
   p_new           ila500_qa_data_aud.NEW%TYPE           := NULL;
   p_action        ila500_qa_data_aud.action%TYPE        := NULL;
   p_username      ila500_qa_data_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.username;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END qa_data_lub;
/
SHOW ERRORS;*/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM ILA500_QA_DATA
/

CREATE PUBLIC SYNONYM ILA500_QA_DATA FOR ILA500.ILA500_QA_DATA
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON ILA500_QA_DATA
TO EDM_USER
/

-- Reference data
-- Table: ILA500_QA_DATA 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      22.10.08    A.Bowman (SAAS)         Initial Version.
--  
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ILA500_QA_DATA.sql $ 
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 

DELETE FROM ILA500_QA_DATA;

INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTEDMTL1', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 

INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTEDMTL2', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTEDMTL3', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTEDMTL4', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTEDMTL5', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTEDMCW1', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTEDMCW2', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTEDMCW3', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTEDMCW4', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTEDMCW5', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTFinTL1', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTFinTL2', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTFinTL3', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTFinTL4', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTFinTL5', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTFinCW1', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTFinCW2', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTFinCW3', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTFinCW4', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTFinCW5', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTILACW1', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTILACW2', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTILACW3', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTILACW4', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTILACW5', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTILATL1', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTILATL2', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTILATL3', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTILATL4', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 


INSERT INTO ILA500_QA_DATA ( USERNAME, QA_TYPE, QA_LEVEL, NO_PROCESSED, NO_QA, NO_FAIL_QA,
LAST_UPDATED_BY, LAST_UPDATED_ON ) VALUES ( 
'SPTILATL5', 'U', 100, 0, 0, 0, 'ILA500',  sysdate); 

COMMIT;