/* Formatted on 2008/07/08 16:14 (Formatter Plus v4.8.8) */
-- TRIGGER: APP_REJ_IUD
-- TABLE: APPLICATION_REJECTION
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/APP_REJ_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.app_rej_iud
   AFTER DELETE OR INSERT OR UPDATE OF application_rejection_id,
                                       rejection_reason,
                                       application_rejection_desc
   ON ila500.application_rejection
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                         := SYSDATE;
   p_column_name   application_rejection_aud.column_name%TYPE   := NULL;
   p_primary_key   application_rejection_aud.primary_key%TYPE
                                             := :OLD.application_rejection_id;
   p_old           application_rejection_aud.OLD%TYPE           := NULL;
   p_new           application_rejection_aud.NEW%TYPE           := NULL;
   p_action        application_rejection_aud.action%TYPE        := NULL;
   p_username      application_rejection_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.application_rejection_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'APPLICATION_REJECTION_ID';
   p_old := :OLD.application_rejection_id;
   p_new := :NEW.application_rejection_id;
   pk_pop_aud.ins_app_rej_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'REJECTION_REASON';
   p_old := :OLD.rejection_reason;
   p_new := :NEW.rejection_reason;
   pk_pop_aud.ins_app_rej_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'APPLICATION_REJECTION_DESC';
   p_old := :OLD.application_rejection_desc;
   p_new := :NEW.application_rejection_desc;
   pk_pop_aud.ins_app_rej_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END app_rej_iud;
/