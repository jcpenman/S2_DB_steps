
-- TRIGGER: DEBT_STATUS_LUB
-- TABLE: DEBT_STATUS
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      11.11.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $
--
CREATE OR REPLACE TRIGGER ila500.debt_status_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.debt_status
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                    := SYSDATE;
   p_column_name   debt_status_aud.column_name%TYPE   := NULL;
   p_primary_key   debt_status_aud.primary_key%TYPE
                                                  := :OLD.debt_status_id;
   p_old           debt_status_aud.OLD%TYPE           := NULL;
   p_new           debt_status_aud.NEW%TYPE           := NULL;
   p_action        debt_status_aud.action%TYPE        := NULL;
   p_username      debt_status_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.debt_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_debt_status_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
END debt_status_lub;
/