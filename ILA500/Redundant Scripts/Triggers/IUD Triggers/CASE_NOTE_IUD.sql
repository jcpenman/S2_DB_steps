/* Formatted on 2008/07/09 15:12 (Formatter Plus v4.8.8) */
-- TRIGGER: CASE_NOTE_IUD
-- TABLE: CASEWORKER_NOTE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/CASE_NOTE_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.case_note_iud
   AFTER DELETE OR INSERT OR UPDATE OF cw_note_id,
                                       source_table,
                                       primary_key,
                                       note_type_id,
                                       note_date,
                                       session_year,
                                       note_text
   ON ila500.caseworker_note
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                   := SYSDATE;
   p_column_name   caseworker_note_aud.column_name%TYPE   := NULL;
   p_primary_key   caseworker_note_aud.primary_key%TYPE   := :OLD.cw_note_id;
   p_old           caseworker_note_aud.OLD%TYPE           := NULL;
   p_new           caseworker_note_aud.NEW%TYPE           := NULL;
   p_action        caseworker_note_aud.action%TYPE        := NULL;
   p_username      caseworker_note_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.cw_note_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'CW_NOTE_ID';
   p_old := :OLD.cw_note_id;
   p_new := :NEW.cw_note_id;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'SOURCE_TABLE';
   p_old := :OLD.source_table;
   p_new := :NEW.source_table;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'PRIMARY_KEY';
   p_old := :OLD.primary_key;
   p_new := :NEW.primary_key;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'NOTE_TYPE_ID';
   p_old := :OLD.note_type_id;
   p_new := :NEW.note_type_id;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'NOTE_DATE';
   p_old := :OLD.note_date;
   p_new := :NEW.note_date;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'SESSION_YEAR';
   p_old := :OLD.session_year;
   p_new := :NEW.session_year;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'NOTE_TEXT';
   p_old := :OLD.note_text;
   p_new := :NEW.note_text;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END case_note_iud;
/