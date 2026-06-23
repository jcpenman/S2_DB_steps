/* Formatted on 2008/07/09 15:38 (Formatter Plus v4.8.8) */
-- TRIGGER: DOC_REG_IUD
-- TABLE: DOCUMENT_REGISTER
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/DOC_REG_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.doc_reg_iud
   AFTER DELETE OR INSERT OR UPDATE OF doc_reg_id,
                                       source_table,
                                       primary_key,
                                       document_type_code,
                                       received_date,
                                       session_year,
                                       returned_date
   ON ila500.document_register
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   document_register_aud.column_name%TYPE   := NULL;
   p_primary_key   document_register_aud.primary_key%TYPE  := :OLD.doc_reg_id;
   p_old           document_register_aud.OLD%TYPE           := NULL;
   p_new           document_register_aud.NEW%TYPE           := NULL;
   p_action        document_register_aud.action%TYPE        := NULL;
   p_username      document_register_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.doc_reg_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'DOC_REG_ID';
   p_old := :OLD.doc_reg_id;
   p_new := :NEW.doc_reg_id;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
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
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
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
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DOCUMENT_TYPE_CODE';
   p_old := :OLD.document_type_code;
   p_new := :NEW.document_type_code;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'RECEIVED_DATE';
   p_old := :OLD.received_date;
   p_new := :NEW.received_date;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
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
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'RETURNED_DATE';
   p_old := :OLD.returned_date;
   p_new := :NEW.returned_date;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END doc_reg_iud;
/