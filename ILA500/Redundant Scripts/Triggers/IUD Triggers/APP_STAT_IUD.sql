/* Formatted on 2008/07/08 16:25 (Formatter Plus v4.8.8) */
-- TRIGGER: APP_STAT_IUD
-- TABLE: APPLICATION_STATUS
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/APP_STAT_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.app_stat_iud
   AFTER DELETE OR INSERT OR UPDATE OF application_status_id,
                                       status,
                                       application_status_desc
   ON ila500.application_status
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                      := SYSDATE;
   p_column_name   application_status_aud.column_name%TYPE   := NULL;
   p_primary_key   application_status_aud.primary_key%TYPE
                                                := :OLD.application_status_id;
   p_old           application_status_aud.OLD%TYPE           := NULL;
   p_new           application_status_aud.NEW%TYPE           := NULL;
   p_action        application_status_aud.action%TYPE        := NULL;
   p_username      application_status_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.application_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'APPLICATION_STATUS_ID';
   p_old := :OLD.application_status_id;
   p_new := :NEW.application_status_id;
   pk_pop_aud.ins_app_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'STATUS';
   p_old := :OLD.status;
   p_new := :NEW.status;
   pk_pop_aud.ins_app_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'APPLICATION_STATUS_DESC';
   p_old := :OLD.application_status_desc;
   p_new := :NEW.application_status_desc;
   pk_pop_aud.ins_app_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END app_stat_iud;
/