/* Formatted on 2008/07/09 14:58 (Formatter Plus v4.8.8) */
-- TRIGGER: CONFIG_DATA_IUD
-- TABLE: ILA500_CONFIG_DATA
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/CONFIG_DATA_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.config_data_iud
   AFTER DELETE OR INSERT OR UPDATE OF item_name, cval, nval
   ON ila500.ila500_config_data
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                      := SYSDATE;
   p_column_name   ila500_config_data_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_config_data_aud.primary_key%TYPE  := :OLD.item_name;
   p_old           ila500_config_data_aud.OLD%TYPE           := NULL;
   p_new           ila500_config_data_aud.NEW%TYPE           := NULL;
   p_action        ila500_config_data_aud.action%TYPE        := NULL;
   p_username      ila500_config_data_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
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
END config_data_iud;
/