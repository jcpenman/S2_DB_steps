/* Formatted on 2008/07/09 14:37 (Formatter Plus v4.8.8) */
-- TRIGGER: PAY_STAT_IUD
-- TABLE: PAYMENT_STATUS
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/PAY_STAT_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.pay_stat_iud
   AFTER DELETE OR INSERT OR UPDATE OF payment_status_id, payment_desc
   ON ila500.payment_status
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                  := SYSDATE;
   p_column_name   payment_status_aud.column_name%TYPE   := NULL;
   p_primary_key   payment_status_aud.primary_key%TYPE
                                                    := :OLD.payment_status_id;
   p_old           payment_status_aud.OLD%TYPE           := NULL;
   p_new           payment_status_aud.NEW%TYPE           := NULL;
   p_action        payment_status_aud.action%TYPE        := NULL;
   p_username      payment_status_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.payment_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'PAYMENT_STATUS_ID';
   p_old := :OLD.payment_status_id;
   p_new := :NEW.payment_status_id;
   pk_pop_aud.ins_pay_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'PAYMENT_DESC';
   p_old := :OLD.payment_desc;
   p_new := :NEW.payment_desc;
   pk_pop_aud.ins_pay_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END pay_stat_iud;
/