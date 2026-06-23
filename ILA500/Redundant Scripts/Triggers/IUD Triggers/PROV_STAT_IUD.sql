/* Formatted on 2008/07/09 14:03 (Formatter Plus v4.8.8) */
-- TRIGGER: PROV_STAT_IUD
-- TABLE: PROVIDER_STATUS
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/PROV_STAT_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.prov_stat_iud
   AFTER DELETE OR INSERT OR UPDATE OF prov_status_id, prov_status_desc
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
END prov_stat_iud;
/