/* Formatted on 2008/07/07 15:42 (Formatter Plus v4.8.8) */
-- TRIGGER: COU_TYPE_LUB
-- TABLE: COURSE_TYPE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/LUB%20Triggers/COU_TYPE_LUB.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.cou_type_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.course_type
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                               := SYSDATE;
   p_column_name   course_type_aud.column_name%TYPE   := NULL;
   p_primary_key   course_type_aud.primary_key%TYPE   := :OLD.course_type_id;
   p_old           course_type_aud.OLD%TYPE           := NULL;
   p_new           course_type_aud.NEW%TYPE           := NULL;
   p_action        course_type_aud.action%TYPE        := NULL;
   p_username      course_type_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.course_type_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END cou_type_lub;
/