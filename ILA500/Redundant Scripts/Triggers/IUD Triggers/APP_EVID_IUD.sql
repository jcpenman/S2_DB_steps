/* Formatted on 2008/07/08 14:02 (Formatter Plus v4.8.8) */
-- TRIGGER: APP_EVID_IUD
-- TABLE: APPLICATION_EVIDENCE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/APP_EVID_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.app_evid_iud
   AFTER DELETE OR INSERT OR UPDATE OF evid_id, evid_desc
   ON ila500.application_evidence
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                        := SYSDATE;
   p_column_name   application_evidence_aud.column_name%TYPE   := NULL;
   p_primary_key   application_evidence_aud.primary_key%TYPE  := :OLD.evid_id;
   p_old           application_evidence_aud.OLD%TYPE           := NULL;
   p_new           application_evidence_aud.NEW%TYPE           := NULL;
   p_action        application_evidence_aud.action%TYPE        := NULL;
   p_username      application_evidence_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.evid_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'EVID_ID';
   p_old := :OLD.evid_id;
   p_new := :NEW.evid_id;
   pk_pop_aud.ins_app_evid_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'EVID_DESC';
   p_old := :OLD.evid_desc;
   p_new := :NEW.evid_desc;
   pk_pop_aud.ins_app_evid_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
END app_evid_iud;
/