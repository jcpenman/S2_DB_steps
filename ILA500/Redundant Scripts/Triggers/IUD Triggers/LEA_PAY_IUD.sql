/* Formatted on 2008/07/09 12:01 (Formatter Plus v4.8.8) */
-- TRIGGER: LEA_PAY_IUD
-- TABLE: LEARNER_PAYMENT
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/LEA_PAY_IUD.sql $ 
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.lea_pay_iud
   AFTER DELETE OR INSERT OR UPDATE OF learner_payment_id,
                                       learner_application_id,
                                       provider_payment_id,
                                       transaction_type_id,
                                       payment_status_id,
                                       amount
   ON ila500.learner_payment
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                   := SYSDATE;
   p_column_name   learner_payment_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_payment_aud.primary_key%TYPE
                                                   := :OLD.learner_payment_id;
   p_old           learner_payment_aud.OLD%TYPE           := NULL;
   p_new           learner_payment_aud.NEW%TYPE           := NULL;
   p_action        learner_payment_aud.action%TYPE        := NULL;
   p_username      learner_payment_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.learner_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'LEARNER_PAYMENT_ID';
   p_old := :OLD.learner_payment_id;
   p_new := :NEW.learner_payment_id;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LEARNER_APPLICATION_ID';
   p_old := :OLD.learner_application_id;
   p_new := :NEW.learner_application_id;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PROVIDER_PAYMENT_ID';
   p_old := :OLD.provider_payment_id;
   p_new := :NEW.provider_payment_id;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'TRANSACTION_TYPE_ID';
   p_old := :OLD.transaction_type_id;
   p_new := :NEW.transaction_type_id;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PAYMENT_STATUS_ID';
   p_old := :OLD.payment_status_id;
   p_new := :NEW.payment_status_id;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'AMOUNT';
   p_old := :OLD.amount;
   p_new := :NEW.amount;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END lea_pay_iud;
/