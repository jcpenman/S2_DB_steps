/* Formatted on 2008/10/21 14:45 (Formatter Plus v4.8.8) */
-- TRIGGER: LEA_APP_BEFORE_UD
-- TABLE: LEARNER_APPLICATION
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      21.10.2008    A.Bowman (SAAS)         Initial Version.
-- 002      28.10.2008    A.Bowman (SAAS)         Amended code to fix testing defect 232 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 
--
CREATE OR REPLACE TRIGGER ILA500.lea_app_before_ud
   BEFORE INSERT OR UPDATE OF FEE_CALCULATED
   ON ILA500.LEARNER_APPLICATION    FOR EACH ROW
BEGIN
   IF NVL (:OLD.FEE_CALCULATED,'0') <> NVL (:NEW.FEE_CALCULATED,'0')
   THEN
      :NEW.DATE_OF_LAST_CALC := SYSDATE;
   END IF;
END;
/