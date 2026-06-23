/* Formatted on 2008/08/19 10:33 (Formatter Plus v4.8.8) */
-- TRIGGER: PROV_PAY_IUD
-- TABLE: PROVIDER_PAYMENT
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
-- 002      19.08.2008    A.Bowman (SAAS)         Added prov_bal_amount column
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/PROV_PAY_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.prov_pay_iud
   AFTER DELETE OR INSERT OR UPDATE OF provider_payment_id,
                                       provider_id,
                                       bacs_run_id,
                                       adi_payment_id,
                                       payment_status_id,
                                       total_amount,
                                       debits_amount,
                                       credits_amount,
                                       prov_bal_amount
   ON ila500.provider_payment
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                    := SYSDATE;
   p_column_name   provider_payment_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_payment_aud.primary_key%TYPE
                                                  := :OLD.provider_payment_id;
   p_old           provider_payment_aud.OLD%TYPE           := NULL;
   p_new           provider_payment_aud.NEW%TYPE           := NULL;
   p_action        provider_payment_aud.action%TYPE        := NULL;
   p_username      provider_payment_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.provider_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'PROVIDER_PAYMENT_ID';
   p_old := :OLD.provider_payment_id;
   p_new := :NEW.provider_payment_id;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'PROVIDER_ID';
   p_old := :OLD.provider_id;
   p_new := :NEW.provider_id;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'BACS_RUN_ID';
   p_old := :OLD.bacs_run_id;
   p_new := :NEW.bacs_run_id;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'ADI_PAYMENT_ID';
   p_old := :OLD.adi_payment_id;
   p_new := :NEW.adi_payment_id;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
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
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'TOTAL_AMOUNT';
   p_old := :OLD.total_amount;
   p_new := :NEW.total_amount;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'DEBITS_AMOUNT';
   p_old := :OLD.debits_amount;
   p_new := :NEW.debits_amount;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'CREDITS_AMOUNT';
   p_old := :OLD.credits_amount;
   p_new := :NEW.credits_amount;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'PROV_BAL_AMOUNT';
   p_old := :OLD.prov_bal_amount;
   p_new := :NEW.prov_bal_amount;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END prov_pay_iud;
/