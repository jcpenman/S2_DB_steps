/* Formatted on 2008/07/09 17:39 (Formatter Plus v4.8.8) */
-- TRIGGER: PROV_IUD
-- TABLE: PROVIDER
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
-- 002      18.08.2008    A.Bowman (SAAS)         Added outstanding_amount column
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/PROV_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.prov_iud
   AFTER DELETE OR INSERT OR UPDATE OF provider_id,
                                       provider_name,
                                       provider_house_no_or_name,
                                       provider_addr_l1,
                                       provider_addr_l2,
                                       provider_addr_l3,
                                       provider_addr_l4,
                                       provider_post_code,
                                       provider_tel_no,
                                       provider_fax_no,
                                       bank_sort_code,
                                       bank_account_no,
                                       main_contact_name,
                                       main_contact_position,
                                       main_contact_house_no_or_name,
                                       main_contact_addr_l1,
                                       main_contact_addr_l2,
                                       main_contact_addr_l3,
                                       main_contact_addr_l4,
                                       main_contact_post_code,
                                       main_contact_tel_no,
                                       main_contact_fax_no,
                                       main_contact_email,
                                       fin_contact_name,
                                       fin_contact_position,
                                       fin_contact_house_no_or_name,
                                       fin_contact_addr_l1,
                                       fin_contact_addr_l2,
                                       fin_contact_addr_l3,
                                       fin_contact_addr_l4,
                                       fin_contact_post_code,
                                       fin_contact_tel_no,
                                       fin_contact_fax_no,
                                       fin_contact_email,
                                       suspend_payments,
                                       suspend_letters,
                                       prov_type_id,
                                       prov_status_id,
                                       outstanding_amount
   ON ila500.provider
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                            := SYSDATE;
   p_column_name   provider_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_aud.primary_key%TYPE   := :OLD.provider_id;
   p_old           provider_aud.OLD%TYPE           := NULL;
   p_new           provider_aud.NEW%TYPE           := NULL;
   p_action        provider_aud.action%TYPE        := NULL;
   p_username      provider_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.provider_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'PROVIDER_ID';
   p_old := :OLD.provider_id;
   p_new := :NEW.provider_id;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_NAME';
   p_old := :OLD.provider_name;
   p_new := :NEW.provider_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_HOUSE_NO_OR_NAME';
   p_old := :OLD.provider_house_no_or_name;
   p_new := :NEW.provider_house_no_or_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_ADDR_L1';
   p_old := :OLD.provider_addr_l1;
   p_new := :NEW.provider_addr_l1;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_ADDR_L2';
   p_old := :OLD.provider_addr_l2;
   p_new := :NEW.provider_addr_l2;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_ADDR_L3';
   p_old := :OLD.provider_addr_l3;
   p_new := :NEW.provider_addr_l3;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_ADDR_L4';
   p_old := :OLD.provider_addr_l4;
   p_new := :NEW.provider_addr_l4;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_POST_CODE';
   p_old := :OLD.provider_post_code;
   p_new := :NEW.provider_post_code;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_TEL_NO';
   p_old := :OLD.provider_tel_no;
   p_new := :NEW.provider_tel_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_FAX_NO';
   p_old := :OLD.provider_fax_no;
   p_new := :NEW.provider_fax_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'BANK_SORT_CODE';
   p_old := :OLD.bank_sort_code;
   p_new := :NEW.bank_sort_code;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'BANK_ACCOUNT_NO';
   p_old := :OLD.bank_account_no;
   p_new := :NEW.bank_account_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_NAME';
   p_old := :OLD.main_contact_name;
   p_new := :NEW.main_contact_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_POSITION';
   p_old := :OLD.main_contact_position;
   p_new := :NEW.main_contact_position;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_HOUSE_NO_OR_NAME';
   p_old := :OLD.main_contact_house_no_or_name;
   p_new := :NEW.main_contact_house_no_or_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_ADDR_L1';
   p_old := :OLD.main_contact_addr_l1;
   p_new := :NEW.main_contact_addr_l1;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_ADDR_L2';
   p_old := :OLD.main_contact_addr_l2;
   p_new := :NEW.main_contact_addr_l2;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_ADDR_L3';
   p_old := :OLD.main_contact_addr_l3;
   p_new := :NEW.main_contact_addr_l3;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_ADDR_L4';
   p_old := :OLD.main_contact_addr_l4;
   p_new := :NEW.main_contact_addr_l4;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_POST_CODE';
   p_old := :OLD.main_contact_post_code;
   p_new := :NEW.main_contact_post_code;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_TEL_NO';
   p_old := :OLD.main_contact_tel_no;
   p_new := :NEW.main_contact_tel_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_FAX_NO';
   p_old := :OLD.main_contact_fax_no;
   p_new := :NEW.main_contact_fax_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_EMAIL';
   p_old := :OLD.main_contact_email;
   p_new := :NEW.main_contact_email;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_NAME';
   p_old := :OLD.fin_contact_name;
   p_new := :NEW.fin_contact_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_POSITION';
   p_old := :OLD.fin_contact_position;
   p_new := :NEW.fin_contact_position;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_HOUSE_NO_OR_NAME';
   p_old := :OLD.fin_contact_house_no_or_name;
   p_new := :NEW.fin_contact_house_no_or_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_ADDR_L1';
   p_old := :OLD.fin_contact_addr_l1;
   p_new := :NEW.fin_contact_addr_l1;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_ADDR_L2';
   p_old := :OLD.fin_contact_addr_l2;
   p_new := :NEW.fin_contact_addr_l2;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_ADDR_L3';
   p_old := :OLD.fin_contact_addr_l3;
   p_new := :NEW.fin_contact_addr_l3;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_ADDR_L4';
   p_old := :OLD.fin_contact_addr_l4;
   p_new := :NEW.fin_contact_addr_l4;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_POST_CODE';
   p_old := :OLD.fin_contact_post_code;
   p_new := :NEW.fin_contact_post_code;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_TEL_NO';
   p_old := :OLD.fin_contact_tel_no;
   p_new := :NEW.fin_contact_tel_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_FAX_NO';
   p_old := :OLD.fin_contact_fax_no;
   p_new := :NEW.fin_contact_fax_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_EMAIL';
   p_old := :OLD.fin_contact_email;
   p_new := :NEW.fin_contact_email;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'SUSPEND_PAYMENTS';
   p_old := :OLD.suspend_payments;
   p_new := :NEW.suspend_payments;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'SUSPEND_LETTERS';
   p_old := :OLD.suspend_letters;
   p_new := :NEW.suspend_letters;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROV_TYPE_ID';
   p_old := :OLD.prov_type_id;
   p_new := :NEW.prov_type_id;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROV_STATUS_ID';
   p_old := :OLD.prov_status_id;
   p_new := :NEW.prov_status_id;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'OUTSTANDING_AMOUNT';
   p_old := :OLD.outstanding_amount;
   p_new := :NEW.outstanding_amount;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
END prov_iud;