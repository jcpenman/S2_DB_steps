CREATE OR REPLACE PACKAGE pk_pop_aud
IS
-- DESCRIPTION
-- ===========
-- Package to insert records into the respective audit tables on thet
-- ILA500 database when table columns are changed or records deleted.
-- This is a common function called by the audit database triggers.
-- P_Variable means the variable is a Parameter passed from the
-- Database Trigger.
-- PL_Variavle implies it is a PL/SQL Variable
-- Variables, Parameters, Package, Function, Procedure, Trigger,
-- Table, Alias and Column names are in capital letters.
-- All other reserve words are in lower case letters.
--
-- Modification History
-- Date                 Author      Ref    Desc
-- 07.07.2008           A Bowman    001    Initial Creation
-- 29.07.2008           A Bowman    002    Added procedures for ILA500_EDM_IMAGES table
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision:  $
--
   PROCEDURE ins_adi_pay_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_app_evid_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_app_rej_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_app_stat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_bacs_run_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_case_note_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_cou_lev_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_cou_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_doc_reg_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_qa_data_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_rule_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_lea_app_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_lea_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_lea_dup_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_lea_pay_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_note_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_pay_stat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_prov_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_prov_pay_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_prov_stat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_prov_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_rep_hist_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_shell_ltr_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_title_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_trans_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE ins_config_data_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
      PROCEDURE ins_edm_images_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   );
   PROCEDURE set_uid4audit_adi_pay_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
   PROCEDURE set_uid4audit_app_evid_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_app_rej_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_app_stat_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_bacs_run_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_case_note_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_cou_lev_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_cou_type_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_doc_reg_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_qa_data_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_rule_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_lea_app_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_lea_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_lea_dup_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_lea_pay_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_note_type_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_pay_stat_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_prov_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_prov_pay_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_prov_stat_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_prov_type_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_rep_hist_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_shell_ltr_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_title_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_trans_type_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
      PROCEDURE set_uid4audit_config_data_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
         PROCEDURE set_uid4audit_edm_images_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   );
END pk_pop_aud;
/