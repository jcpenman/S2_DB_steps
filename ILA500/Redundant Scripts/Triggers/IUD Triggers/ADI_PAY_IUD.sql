/* Formatted on 2008/07/08 16:04 (Formatter Plus v4.8.8) */
-- TRIGGER: ADI_PAY_IUD
-- TABLE: ADI_PAYMENT
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/ADI_PAY_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.adi_pay_iud
   AFTER DELETE OR INSERT OR UPDATE OF adi_payment_id,
                                       payment_status_id,
                                       total_payment_amount
   ON ila500.adi_payment
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                               := SYSDATE;
   p_column_name   adi_payment_aud.column_name%TYPE   := NULL;
   p_primary_key   adi_payment_aud.primary_key%TYPE   := :OLD.adi_payment_id;
   p_old           adi_payment_aud.OLD%TYPE           := NULL;
   p_new           adi_payment_aud.NEW%TYPE           := NULL;
   p_action        adi_payment_aud.action%TYPE        := NULL;
   p_username      adi_payment_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.adi_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'ADI_PAYMENT_ID';
   p_old := :OLD.adi_payment_id;
   p_new := :NEW.adi_payment_id;
   pk_pop_aud.ins_adi_pay_aud (p_aud_date,
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
   pk_pop_aud.ins_adi_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'TOTAL_PAYMENT_AMOUNT';
   p_old := :OLD.total_payment_amount;
   p_new := :NEW.total_payment_amount;
   pk_pop_aud.ins_adi_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END adi_pay_iud;
/