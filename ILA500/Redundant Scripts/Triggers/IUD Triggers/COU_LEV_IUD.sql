/* Formatted on 2008/07/08 16:57 (Formatter Plus v4.8.8) */
-- TRIGGER: COU_LEV_IUD
-- TABLE: COURSE_LEVEL
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/COU_LEV_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.cou_lev_iud
   AFTER DELETE OR INSERT OR UPDATE OF course_id, course_level_desc
   ON ila500.course_level
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                := SYSDATE;
   p_column_name   course_level_aud.column_name%TYPE   := NULL;
   p_primary_key   course_level_aud.primary_key%TYPE   := :OLD.course_id;
   p_old           course_level_aud.OLD%TYPE           := NULL;
   p_new           course_level_aud.NEW%TYPE           := NULL;
   p_action        course_level_aud.action%TYPE        := NULL;
   p_username      course_level_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.course_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'COURSE_ID';
   p_old := :OLD.course_id;
   p_new := :NEW.course_id;
   pk_pop_aud.ins_cou_lev_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_LEVEL_DESC';
   p_old := :OLD.course_level_desc;
   p_new := :NEW.course_level_desc;
   pk_pop_aud.ins_cou_lev_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END cou_lev_iud;
/