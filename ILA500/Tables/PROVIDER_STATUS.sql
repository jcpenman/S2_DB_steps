-- TABLE: PROVIDER_STATUS
-- Description: Table holding the learning provider status for ILA500
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      28.05.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      06.06.08   A.Bowman (SAAS)         Added comments iro the table columns
-- 1.2      23.06.08   A.Bowman (SAAS)         Amended prov_status_id data type
-- 1.3      19.10.09   A.Bowman (SAAS)         Added triggers and data
-- 1.4      15.02.10   A.Bowman (SAAS)         Amended audit triggers
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PROVIDER_STATUS.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
 
ALTER TABLE PROVIDER_STATUS
 DROP PRIMARY KEY CASCADE
/
DROP TABLE PROVIDER_STATUS CASCADE CONSTRAINTS PURGE
/

--
-- PROVIDER_STATUS (Table) 
--

CREATE TABLE PROVIDER_STATUS
(
  PROV_STATUS_ID    NUMBER(10)            NOT NULL,
  PROV_STATUS_DESC  VARCHAR2(20 BYTE)           NOT NULL,
  LAST_UPDATED_BY   VARCHAR2(15 BYTE)           DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON   DATE                        DEFAULT SYSDATE               NOT NULL
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

COMMENT ON TABLE PROVIDER_STATUS IS 'Table holding the learning provider status for ILA500';

COMMENT ON COLUMN PROVIDER_STATUS.PROV_STATUS_ID IS 'Unique identifier for each provider status';

COMMENT ON COLUMN PROVIDER_STATUS.PROV_STATUS_DESC IS 'A description of the provider status';

COMMENT ON COLUMN PROVIDER_STATUS.LAST_UPDATED_BY IS 'The user to last update or insert a row on the provider_status table';

COMMENT ON COLUMN PROVIDER_STATUS.LAST_UPDATED_ON IS 'The date of the latest update or insert on the provider_status table';


CREATE UNIQUE INDEX PROVIDER_STATUS_PK ON PROVIDER_STATUS
(PROV_STATUS_ID)
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


ALTER TABLE PROVIDER_STATUS ADD (
  CONSTRAINT PROVIDER_STATUS_PK
 PRIMARY KEY
 (PROV_STATUS_ID)
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

/* Formatted on 2008/07/09 14:03 (Formatter Plus v4.8.8) */
-- TRIGGER: PROV_STAT_IUD
-- TABLE: PROVIDER_STATUS
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PROVIDER_STATUS.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.prov_stat_iud
   AFTER DELETE OR INSERT OR UPDATE OF prov_status_id, prov_status_desc, last_updated_by
   ON ila500.provider_status
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                   := SYSDATE;
   p_column_name   provider_status_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_status_aud.primary_key%TYPE
                                                       := :OLD.prov_status_id;
   p_old           provider_status_aud.OLD%TYPE           := NULL;
   p_new           provider_status_aud.NEW%TYPE           := NULL;
   p_action        provider_status_aud.action%TYPE        := NULL;
   p_username      provider_status_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.prov_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'PROV_STATUS_ID';
   p_old := :OLD.prov_status_id;
   p_new := :NEW.prov_status_id;
   pk_pop_aud.ins_prov_stat_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'PROV_STATUS_DESC';
   p_old := :OLD.prov_status_desc;
   p_new := :NEW.prov_status_desc;
   pk_pop_aud.ins_prov_stat_aud (p_aud_date,
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
   pk_pop_aud.ins_prov_stat_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END prov_stat_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 16:04 (Formatter Plus v4.8.8) */
-- TRIGGER: PROV_STAT_LUB
-- TABLE: PROVIDER_STATUS
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PROVIDER_STATUS.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.prov_stat_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.provider_status
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                   := SYSDATE;
   p_column_name   provider_status_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_status_aud.primary_key%TYPE
                                                       := :OLD.prov_status_id;
   p_old           provider_status_aud.OLD%TYPE           := NULL;
   p_new           provider_status_aud.NEW%TYPE           := NULL;
   p_action        provider_status_aud.action%TYPE        := NULL;
   p_username      provider_status_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.prov_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_prov_stat_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END prov_stat_lub;
/
SHOW ERRORS;*/


-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM PROVIDER_STATUS
/

CREATE PUBLIC SYNONYM PROVIDER_STATUS FOR ILA500.PROVIDER_STATUS
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON PROVIDER_STATUS
TO EDM_USER
/

-- Reference data
-- Table: PROVIDER_STATUS 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      19.06.08    A.Bowman (SAAS)         Initial Version.
-- 1.1      23.06.08    A.Bowman (SAAS)         Amended data to UPPER case for consistency. 
--
-- Configuration Management:
-- $HeadURL: 
-- $Author: 
-- $Date: 
-- $Revision: 

DELETE FROM PROVIDER_STATUS;

INSERT INTO PROVIDER_STATUS ( PROV_STATUS_ID,PROV_STATUS_DESC ) 
VALUES 
(1,'ACTIVE');
INSERT INTO PROVIDER_STATUS ( PROV_STATUS_ID,PROV_STATUS_DESC ) 
VALUES 
(2,'INACTIVE');
commit;
 
