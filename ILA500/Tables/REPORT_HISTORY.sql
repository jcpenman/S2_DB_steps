-- TABLE: REPORT_HISTORY
-- Description: Table holding a history of all the reports generated for ILA500
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      28.05.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      06.06.08   A.Bowman (SAAS)         Added comments iro the table columns
-- 1.2      17.06.08   A.Bowman (SAAS)         Added rep_hist_id column
-- 1.3      23.06.08   A.Bowman (SAAS)         Amended rep_hist_id data type
-- 1.4      19.10.09   A.Bowman (SAAS)         Added triggers
-- 1.5      15.02.10   A.Bowman (SAAS)         Amended audit triggers
--
-- 
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/REPORT_HISTORY.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

DROP TABLE REPORT_HISTORY CASCADE CONSTRAINTS PURGE
/

--
-- REPORT_HISTORY (Table) 
--

CREATE TABLE REPORT_HISTORY
(
  REP_HIST_ID      NUMBER(10)                   NOT NULL,
  PROVIDER_ID      VARCHAR2(10 BYTE)            NOT NULL,
  REPORT_TYPE      VARCHAR2(20 BYTE)            NOT NULL,
  DATE_OF_REPORT   DATE                         NOT NULL,
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

COMMENT ON TABLE REPORT_HISTORY IS 'Table holding a history of all the reports generated for ILA500';

COMMENT ON COLUMN REPORT_HISTORY.REP_HIST_ID IS 'The unique identifier of the report';

COMMENT ON COLUMN REPORT_HISTORY.PROVIDER_ID IS 'The unique identifier of the provider';

COMMENT ON COLUMN REPORT_HISTORY.REPORT_TYPE IS 'The type of report produced ';

COMMENT ON COLUMN REPORT_HISTORY.DATE_OF_REPORT IS 'The date the report was produced';

COMMENT ON COLUMN REPORT_HISTORY.LAST_UPDATED_BY IS 'The user to last update or insert a row on the report_history table';

COMMENT ON COLUMN REPORT_HISTORY.LAST_UPDATED_ON IS 'The date of the latest update or insert on the report_history table';

CREATE UNIQUE INDEX REPORT_HISTORY_PK ON REPORT_HISTORY
(REP_HIST_ID)
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


ALTER TABLE REPORT_HISTORY ADD (
  CONSTRAINT REPORT_HISTORY_PK
 PRIMARY KEY
 (REP_HIST_ID)
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

/* Formatted on 2008/07/09 14:30 (Formatter Plus v4.8.8) */
-- TRIGGER: REP_HIST_IUD
-- TABLE: REPORT_HISTORY
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/REPORT_HISTORY.sql $ 
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.rep_hist_iud
   AFTER DELETE OR INSERT OR UPDATE OF rep_hist_id,
                                       provider_id,
                                       report_type,
                                       date_of_report,
                                       last_updated_by
   ON ila500.report_history
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                  := SYSDATE;
   p_column_name   report_history_aud.column_name%TYPE   := NULL;
   p_primary_key   report_history_aud.primary_key%TYPE   := :OLD.rep_hist_id;
   p_old           report_history_aud.OLD%TYPE           := NULL;
   p_new           report_history_aud.NEW%TYPE           := NULL;
   p_action        report_history_aud.action%TYPE        := NULL;
   p_username      report_history_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.rep_hist_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'REP_HIST_ID';
   p_old := :OLD.rep_hist_id;
   p_new := :NEW.rep_hist_id;
   pk_pop_aud.ins_rep_hist_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'PROVIDER_ID';
   p_old := :OLD.provider_id;
   p_new := :NEW.provider_id;
   pk_pop_aud.ins_rep_hist_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'REPORT_TYPE';
   p_old := :OLD.report_type;
   p_new := :NEW.report_type;
   pk_pop_aud.ins_rep_hist_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'DATE_OF_REPORT';
   p_old := :OLD.date_of_report;
   p_new := :NEW.date_of_report;
   pk_pop_aud.ins_rep_hist_aud (p_aud_date,
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
   pk_pop_aud.ins_rep_hist_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END rep_hist_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 16:08 (Formatter Plus v4.8.8) */
-- TRIGGER: REP_HIST_LUB
-- TABLE: REPORT_HISTORY
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/REPORT_HISTORY.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.rep_hist_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.report_history
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                  := SYSDATE;
   p_column_name   report_history_aud.column_name%TYPE   := NULL;
   p_primary_key   report_history_aud.primary_key%TYPE   := :OLD.rep_hist_id;
   p_old           report_history_aud.OLD%TYPE           := NULL;
   p_new           report_history_aud.NEW%TYPE           := NULL;
   p_action        report_history_aud.action%TYPE        := NULL;
   p_username      report_history_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.rep_hist_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_rep_hist_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END rep_hist_lub;
/
SHOW ERRORS;*/

GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  REPORT_HISTORY TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM REPORT_HISTORY;

CREATE PUBLIC SYNONYM REPORT_HISTORY FOR ILA500.REPORT_HISTORY;

