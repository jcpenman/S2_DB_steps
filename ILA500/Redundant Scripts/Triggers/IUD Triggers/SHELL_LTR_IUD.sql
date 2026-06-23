/* Formatted on 2008/07/09 14:52 (Formatter Plus v4.8.8) */
-- TRIGGER: SHELL_LTR_IUD
-- TABLE: SHELL_LETTER
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/SHELL_LTR_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.shell_ltr_iud
   AFTER DELETE OR INSERT OR UPDATE OF doc_id, doc_name, doc_desc
   ON ila500.shell_letter
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                := SYSDATE;
   p_column_name   shell_letter_aud.column_name%TYPE   := NULL;
   p_primary_key   shell_letter_aud.primary_key%TYPE   := :OLD.doc_id;
   p_old           shell_letter_aud.OLD%TYPE           := NULL;
   p_new           shell_letter_aud.NEW%TYPE           := NULL;
   p_action        shell_letter_aud.action%TYPE        := NULL;
   p_username      shell_letter_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.doc_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'DOC_ID';
   p_old := :OLD.doc_id;
   p_new := :NEW.doc_id;
   pk_pop_aud.ins_shell_ltr_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'DOC_NAME';
   p_old := :OLD.doc_name;
   p_new := :NEW.doc_name;
   pk_pop_aud.ins_shell_ltr_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'DOC_DESC';
   p_old := :OLD.doc_desc;
   p_new := :NEW.doc_desc;
   pk_pop_aud.ins_shell_ltr_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END shell_ltr_iud;
/