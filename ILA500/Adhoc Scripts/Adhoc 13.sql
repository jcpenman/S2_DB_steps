-- Name:Adhoc 12
-- Description: This script has been created to drop the LUB triggers in ILA500, audit of the last_updated_by column will
--              now be handled by the IUD triggers.
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      15.02.2010    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

drop trigger ILA500.adi_pay_lub;
drop trigger ILA500.app_evid_lub;
drop trigger ILA500.app_rej_lub;
drop trigger ILA500.app_stat_lub;
drop trigger ILA500.bacs_run_lub;
drop trigger ILA500.case_note_lub;
drop trigger ILA500.cou_lev_lub;
drop trigger ILA500.cou_type_lub;
drop trigger ILA500.doc_reg_lub;
drop trigger ILA500.debt_status_lub;
drop trigger ILA500.qa_data_lub;
drop trigger ILA500.rule_lub;
drop trigger ILA500.lea_app_lub;
drop trigger ILA500.lea_lub;
drop trigger ILA500.lea_dup_lub;
drop trigger ILA500.lea_pay_lub;
drop trigger ILA500.note_type_lub;
drop trigger ILA500.pay_stat_lub;
drop trigger ILA500.prov_lub;
drop trigger ILA500.prov_pay_lub;
drop trigger ILA500.prov_stat_lub;
drop trigger ILA500.prov_type_lub;
drop trigger ILA500.rep_hist_lub;
drop trigger ILA500.shell_ltr_lub;
drop trigger ILA500.title_lub;
drop trigger ILA500.trans_type_lub;
drop trigger ILA500.config_data_lub;
drop trigger ILA500.edm_images_lub;

commit;