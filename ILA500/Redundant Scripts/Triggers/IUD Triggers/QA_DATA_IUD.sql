/* Formatted on 2008/07/09 10:15 (Formatter Plus v4.8.8) */
-- TRIGGER: QA_DATA_IUD
-- TABLE: ILA500_QA_DATA
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/QA_DATA_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.qa_data_iud
   AFTER DELETE OR INSERT OR UPDATE OF username,
                                       qa_type,
                                       qa_level,
                                       no_processed,
                                       no_qa,
                                       no_fail_qa
   ON ila500.ila500_qa_data
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                  := SYSDATE;
   p_column_name   ila500_qa_data_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_qa_data_aud.primary_key%TYPE   := :OLD.username;
   p_old           ila500_qa_data_aud.OLD%TYPE           := NULL;
   p_new           ila500_qa_data_aud.NEW%TYPE           := NULL;
   p_action        ila500_qa_data_aud.action%TYPE        := NULL;
   p_username      ila500_qa_data_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.username;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'USERNAME';
   p_old := :OLD.username;
   p_new := :NEW.username;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'QA_TYPE';
   p_old := :OLD.qa_type;
   p_new := :NEW.qa_type;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'QA_LEVEL';
   p_old := :OLD.qa_level;
   p_new := :NEW.qa_level;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NO_PROCESSED';
   p_old := :OLD.no_processed;
   p_new := :NEW.no_processed;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NO_QA';
   p_old := :OLD.no_qa;
   p_new := :NEW.no_qa;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NO_FAIL_QA';
   p_old := :OLD.no_fail_qa;
   p_new := :NEW.no_fail_qa;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END qa_data_iud;
/