/* Formatted on 2008/07/08 16:45 (Formatter Plus v4.8.8) */
-- TRIGGER: BACS_RUN_IUD
-- TABLE: BACS_RUN
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/BACS_RUN_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.bacs_run_iud
   AFTER DELETE OR INSERT OR UPDATE OF bacs_run_id,
                                       bacs_run_date,
                                       bacs_run_name
   ON ila500.bacs_run
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                            := SYSDATE;
   p_column_name   bacs_run_aud.column_name%TYPE   := NULL;
   p_primary_key   bacs_run_aud.primary_key%TYPE   := :OLD.bacs_run_id;
   p_old           bacs_run_aud.OLD%TYPE           := NULL;
   p_new           bacs_run_aud.NEW%TYPE           := NULL;
   p_action        bacs_run_aud.action%TYPE        := NULL;
   p_username      bacs_run_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.bacs_run_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'BACS_RUN_ID';
   p_old := :OLD.bacs_run_id;
   p_new := :NEW.bacs_run_id;
   pk_pop_aud.ins_bacs_run_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'BACS_RUN_DATE';
   p_old := :OLD.bacs_run_date;
   p_new := :NEW.bacs_run_date;
   pk_pop_aud.ins_bacs_run_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'BACS_RUN_NAME';
   p_old := :OLD.bacs_run_name;
   p_new := :NEW.bacs_run_name;
   pk_pop_aud.ins_bacs_run_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END bacs_run_iud;
/