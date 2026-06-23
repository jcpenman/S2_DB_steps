/* Formatted on 2008/07/09 10:02 (Formatter Plus v4.8.8) */
-- TRIGGER: RULE_IUD
-- TABLE: ILA500_RULE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/RULE_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.rule_iud
   AFTER DELETE OR INSERT OR UPDATE OF rule_id,
                                       rule_type,
                                       rule_value,
                                       rule_status
   ON ila500.ila500_rule
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                               := SYSDATE;
   p_column_name   ila500_rule_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_rule_aud.primary_key%TYPE   := :OLD.rule_id;
   p_old           ila500_rule_aud.OLD%TYPE           := NULL;
   p_new           ila500_rule_aud.NEW%TYPE           := NULL;
   p_action        ila500_rule_aud.action%TYPE        := NULL;
   p_username      ila500_rule_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.rule_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'RULE_ID';
   p_old := :OLD.rule_id;
   p_new := :NEW.rule_id;
   pk_pop_aud.ins_rule_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'RULE_TYPE';
   p_old := :OLD.rule_type;
   p_new := :NEW.rule_type;
   pk_pop_aud.ins_rule_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'RULE_VALUE';
   p_old := :OLD.rule_value;
   p_new := :NEW.rule_value;
   pk_pop_aud.ins_rule_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'RULE_STATUS';
   p_old := :OLD.rule_status;
   p_new := :NEW.rule_status;
   pk_pop_aud.ins_rule_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
END rule_iud;
/