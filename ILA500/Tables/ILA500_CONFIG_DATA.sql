-- ILA500_CONFIG_DATA.sql
-- Description: Table holding all configuration data for ILA500
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      07.07.08    R Hunter (SAAS)         Initial Version.
-- 1.1      19.10.09    A.Bowman (SAAS)         Added triggers and data
-- 1.2      15.02.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ILA500_CONFIG_DATA.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

ALTER TABLE ILA500_CONFIG_DATA
 DROP PRIMARY KEY CASCADE
/
DROP TABLE ILA500_CONFIG_DATA CASCADE CONSTRAINTS PURGE
/

--
-- ILA500_CONFIG_DATA  (Table) 
--
CREATE TABLE ILA500_CONFIG_DATA
(
  ITEM_NAME  VARCHAR2(40 BYTE) CONSTRAINT NN_ICD_ITEM_NAME NOT NULL,
  CVAL       VARCHAR2(4000 BYTE),
  NVAL       NUMBER,
  LAST_UPDATED_BY      VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON      DATE                     DEFAULT SYSDATE               NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
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


--
-- P_COD  (Index) 
--
CREATE UNIQUE INDEX P_ICD ON ILA500_CONFIG_DATA
(ITEM_NAME)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


-- 
-- Non Foreign Key Constraints for Table ILA500_CONFIG_DATA 
-- 
ALTER TABLE ILA500_CONFIG_DATA ADD (
  CONSTRAINT P_ICD
 PRIMARY KEY
 (ITEM_NAME)
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
               ))
/

/* Formatted on 2008/07/09 14:58 (Formatter Plus v4.8.8) */
-- TRIGGER: CONFIG_DATA_IUD
-- TABLE: ILA500_CONFIG_DATA
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ILA500_CONFIG_DATA.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.config_data_iud
   AFTER DELETE OR INSERT OR UPDATE OF item_name, cval, nval, last_updated_by
   ON ila500.ila500_config_data
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                      := SYSDATE;
   p_column_name   ila500_config_data_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_config_data_aud.primary_key%TYPE  := :OLD.item_name;
   p_old           ila500_config_data_aud.OLD%TYPE           := NULL;
   p_new           ila500_config_data_aud.NEW%TYPE           := NULL;
   p_action        ila500_config_data_aud.action%TYPE        := NULL;
   p_username      ila500_config_data_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.item_name;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'ITEM_NAME';
   p_old := :OLD.item_name;
   p_new := :NEW.item_name;
   pk_pop_aud.ins_config_data_aud (p_aud_date,
                                   p_column_name,
                                   p_primary_key,
                                   p_old,
                                   p_new,
                                   p_action,
                                   p_username
                                  );
   p_column_name := 'CVAL';
   p_old := :OLD.cval;
   p_new := :NEW.cval;
   pk_pop_aud.ins_config_data_aud (p_aud_date,
                                   p_column_name,
                                   p_primary_key,
                                   p_old,
                                   p_new,
                                   p_action,
                                   p_username
                                  );
   p_column_name := 'NVAL';
   p_old := :OLD.nval;
   p_new := :NEW.nval;
   pk_pop_aud.ins_config_data_aud (p_aud_date,
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
   pk_pop_aud.ins_config_data_aud (p_aud_date,
                                   p_column_name,
                                   p_primary_key,
                                   p_old,
                                   p_new,
                                   p_action,
                                   p_username
                                  );
END config_data_iud;

SHOW ERRORS;

/* Formatted on 2008/07/08 10:54 (Formatter Plus v4.8.8) */
-- TRIGGER: CONFIG_DATA_LUB
-- TABLE: ILA500_CONFIG_DATA
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ILA500_CONFIG_DATA.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.config_data_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.ila500_config_data
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                      := SYSDATE;
   p_column_name   ila500_config_data_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_config_data_aud.primary_key%TYPE   := :OLD.item_name;
   p_old           ila500_config_data_aud.OLD%TYPE           := NULL;
   p_new           ila500_config_data_aud.NEW%TYPE           := NULL;
   p_action        ila500_config_data_aud.action%TYPE        := NULL;
   p_username      ila500_config_data_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.item_name;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_config_data_aud (p_aud_date,
                                   p_column_name,
                                   p_primary_key,
                                   p_old,
                                   p_new,
                                   p_action,
                                   p_username
                                  );
END config_data_lub;
/
SHOW ERRORS;*/

GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  ILA500_CONFIG_DATA TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM ILA500_CONFIG_DATA
/

CREATE PUBLIC SYNONYM ILA500_CONFIG_DATA FOR ILA500.ILA500_CONFIG_DATA
/

-- ILA500_CONFIG_DATA_INSERT.sql
-- Description: Script inserts configuration data for ILA500
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      07.07.08    R Hunter (SAAS)         Initial Version.
-- 1.1      17.10.08    A.Bowman (SAAS)         Missing rows discovered after deploy to SIT added
-- 1.2      10.11.08    A.Bowman (SAAS)         Data amended as part of UI development
-- 1.3      18.05.09    A.Bowman (SAAS)         Added to support functionality detailed in the EDM request rescan / original specification.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/ILA500_CONFIG_DATA.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

DELETE FROM ila500_config_data
/
COMMIT
/
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'EISTREAM_DOMAIN_NAME', 'SAASEDMT', NULL, 'ILA500',  TO_Date( '07/29/2008 10:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'EDM_CLIENT_TARGET_DIR', 'Z:\\edm_documents\\', NULL, 'ILA500',  TO_Date( '07/29/2008 10:05:12 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'PAYMENT_METHOD_1', 'BACS', NULL, 'ILA500',  TO_Date( '11/07/2008 07:49:38 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'PAYMENT_METHOD_2', 'BACS', NULL, 'ILA500',  TO_Date( '11/07/2008 07:49:50 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'PAYMENT_METHOD_3', 'BACS', NULL, 'ILA500',  TO_Date( '11/07/2008 07:50:02 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'PAYMENT_METHOD_4', 'BACS', NULL, 'ILA500',  TO_Date( '11/07/2008 07:50:13 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'SHELL_PATH', 'L:\DUMMY_Shell_Letters_ILA', NULL, 'ILA500',  TO_Date( '07/09/2008 10:32:37 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'SHELL_TYPE', 'doc', NULL, 'ILA500',  TO_Date( '07/09/2008 10:32:37 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'SHELL_CLIENT_TARGET_DIR', 'L:\edm_documents\', NULL, 'ILA500',  TO_Date( '07/09/2008 10:32:37 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'SHELL_SERVER_TARGET_DIR', '/export/home/development_share/edm_documents/', NULL, 'ILA500'
,  TO_Date( '07/09/2008 10:32:37 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'AGE_ELIGIBILITY_LIMIT', '16', NULL, 'ILA500',  TO_Date( '07/22/2008 03:00:15 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'PROVIDER_PAYMENT_REPORT_PATH', '/projects/app/webmethods/REPORTS/PAYMENT_REPORTS/'
, NULL, 'ILA500',  TO_Date( '08/06/2008 10:36:07 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'JANUARY_LAST_WDAY', '31', NULL, 'ILA500',  TO_Date( '07/14/2008 11:00:36 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'FEBRUARY_LAST_WDAY', '27', NULL, 'ILA500',  TO_Date( '07/14/2008 11:01:07 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'MARCH_LAT_WDAY', '31', NULL, 'ILA500',  TO_Date( '07/14/2008 11:01:31 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'APRIL_LAST_WDAY', '30', NULL, 'ILA500',  TO_Date( '07/14/2008 11:02:18 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'MAY_LAST_WDAY', '29', NULL, 'ILA500',  TO_Date( '07/14/2008 11:02:37 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'JUNE_LAST_WDAY', '30', NULL, 'ILA500',  TO_Date( '07/14/2008 11:02:58 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'JULY_LAST_WDAY', '31', NULL, 'ILA500',  TO_Date( '07/14/2008 11:03:31 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'AUGUST_LAST_WDAY', '31', NULL, 'ILA500',  TO_Date( '07/14/2008 11:03:51 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'SEPTEMBER_LAST_WDAY', '30', NULL, 'ILA500',  TO_Date( '07/14/2008 11:04:14 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'OCTOBER_LAST_WDAY', '30', NULL, 'ILA500',  TO_Date( '07/14/2008 11:05:21 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'NOVEMBER_LAST_WDAY', '30', NULL, 'ILA500',  TO_Date( '07/14/2008 11:05:45 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'DECEMBER_LAST_WDAY', '31', NULL, 'ILA500',  TO_Date( '07/14/2008 11:06:11 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'CURRENT_SESSION', '2009', NULL, 'ILA500',  TO_Date( '07/14/2008 11:52:39 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'PROVIDER_STATUS_REPORT_PATH', '/projects/app/webmethods/REPORTS/STATUS_REPORTS/'
, NULL, 'ILA500',  TO_Date( '07/14/2008 11:53:35 AM', 'MM/DD/YYYY HH:MI:SS AM'));
---1.3
INSERT INTO ILA500_CONFIG_DATA ( ITEM_NAME, CVAL, NVAL, LAST_UPDATED_BY,
LAST_UPDATED_ON ) VALUES ( 
'EDM_ORIGINAL_RETAIN_PERIOD', '30'
, NULL, 'ILA500', Sysdate);

COMMIT
/
