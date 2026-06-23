/* Formatted on 2008/08/28 13:56 (Formatter Plus v4.8.8) */
-- TRIGGER: LEA_DUP_IUD
-- TABLE: LEARNER_DUPLICATE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
-- 002      28.08.2008    A.Bowman (SAAS)         Additional columns to be audited
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/LEA_DUP_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $
--
CREATE OR REPLACE TRIGGER ila500.lea_dup_iud
   AFTER DELETE OR INSERT OR UPDATE OF learner_duplicate_id,
                                       learner_id,
                                       duplicate_system,
                                       duplicate_id,
                                       dsa_duplicate
   ON ila500.learner_duplicate
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   learner_duplicate_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_duplicate_aud.primary_key%TYPE
                                                 := :OLD.learner_duplicate_id;
   p_old           learner_duplicate_aud.OLD%TYPE           := NULL;
   p_new           learner_duplicate_aud.NEW%TYPE           := NULL;
   p_action        learner_duplicate_aud.action%TYPE        := NULL;
   p_username      learner_duplicate_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.learner_duplicate_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'LEARNER_DUPLICATE_ID';
   p_old := :OLD.learner_duplicate_id;
   p_new := :NEW.learner_duplicate_id;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LEARNER_ID';
   p_old := :OLD.learner_id;
   p_new := :NEW.learner_id;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DUPLICATE_SYSTEM';
   p_old := :OLD.duplicate_system;
   p_new := :NEW.duplicate_system;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DUPLICATE_ID';
   p_old := :OLD.duplicate_id;
   p_new := :NEW.duplicate_id;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DSA_DUPLICATE';
   p_old := :OLD.dsa_duplicate;
   p_new := :NEW.dsa_duplicate;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END lea_dup_iud;
/