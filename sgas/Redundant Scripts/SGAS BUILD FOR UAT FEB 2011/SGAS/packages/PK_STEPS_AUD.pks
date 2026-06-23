CREATE OR REPLACE PACKAGE SGAS.pk_steps_aud
IS
-- DESCRIPTION
-- ===========
-- Package to insert records into the respective audit tables on the
-- StEPS database when table columns are changed or records deleted.
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
-- 07.10.2008           A.Bowman    001    Initial Creation
-- 27.10.2008           A.Bowman    002    Added Phase 2 audit requirements
-- 13.01.2009           A.Bowman    003    Added payment table audit requirements
-- 02.02.2009           A.Bowman    004    Added payment error codes audit requirement
-- 03.03.2009           A.Bowman    005    Removed no longer req'd payment table audit requirements
-- 04.03.2009           A.Bowman    006    Added payment error code and type audit requirements
-- 14.04.2009           A.Bowman    007    Removed no longer req'd payment table audit requirements
-- 09.06.2009           A.Bowman    008    Added contact_relationship audit requirements
-- 29.06.2009           A.Bowman    009    Added reference data table audit requirements
-- 07.07.2009           A.Bowman    010    Added more reference data table audit requirements
-- 09.07.2009           A.Bowman    011    Added authenticate_stud audit requirements
-- 16.07.2009           A.Bowman    012    Added more reference data table audit requirements
-- 27.08.2009           A.Bowman    013    Added stud_term_addr audit requirements to meet History requirements
-- 01.09.2009           J.Penman    014    Added nominee and stud_nominee audit requirements
-- 24.09.2009           A.Bowman    015    Added dsa reference data table audit requirements
-- 06.01.2010           A.Bowman    016    Added payment tables audit requirements
--
-- 
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision:  $
--
   PROCEDURE ins_aw_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_awi_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_bed_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_bei_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_ben_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_cn_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_jac_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_sqd_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_st_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_stapp_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_stcy_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_std_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_sthome_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_sts_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_sc_bat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_con_rel_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_loc_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_pgce_sub_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_pay_meth_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_aw_ref_dat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_sch_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_ben_inc_stat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_ben_inc_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_z_ref_stat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_dear_stat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_loan_stat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_case_stat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_debt_stat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_dis_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_spo_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_emp_stat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_mar_stat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_title_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_res_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_joi_app_rel_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_sup_gra_rel_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_ben_rel_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_oth_loa_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_fee_loa_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_auth_stud_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_no_nino_rea_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_dup_bank_rea_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_sta_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
    PROCEDURE ins_nom_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   
    PROCEDURE ins_stud_nom_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );

      PROCEDURE ins_dsa_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
      
      PROCEDURE ins_dsa_cat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
      PROCEDURE ins_dsa_ref_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
      PROCEDURE ins_dsa_rej_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
      PROCEDURE ins_dsa_ac_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
      PROCEDURE ins_dsa_pay_stat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
      PROCEDURE ins_dsa_stud_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
      PROCEDURE ins_dsa_app_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
       PROCEDURE ins_dsa_all_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
       PROCEDURE ins_dsa_pay_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   ); 
      PROCEDURE ins_pay_paymt_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
      PROCEDURE ins_fin_rev_jou_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   ); 
      PROCEDURE ins_pay_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
      PROCEDURE ins_adi_jou_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
      PROCEDURE ins_pay_err_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   ); 
      PROCEDURE ins_pay_inst_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_fpd_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_napd_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE ins_res_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_table_pkey1      VARCHAR2,
      p_table_pkey2      VARCHAR2,
      p_table_pkey3      VARCHAR2,
      p_table_pkey4      VARCHAR2,
      p_table_pkey5      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username         VARCHAR2,
      p_stud_ref_no      VARCHAR2,
      p_inst_code        VARCHAR2,
      p_session_code     VARCHAR2
   );
   PROCEDURE set_uid4audit_aw_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
   PROCEDURE set_uid4audit_awi_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_bed_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_bei_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_ben_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_cn_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_jac_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_sqd_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_st_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_stapp_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_stcy_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_std_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_sthome_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_sts_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_sc_bat_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_con_rel_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_loc_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   ); 
      PROCEDURE set_uid4audit_pgce_sub_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   ); 
      PROCEDURE set_uid4audit_pay_meth_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_aw_ref_dat_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   ); 
      PROCEDURE set_uid4audit_sch_type_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_ben_inc_stat_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_ben_inc_type_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_z_ref_stat_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   ); 
      PROCEDURE set_uid4audit_dear_stat_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   ); 
      PROCEDURE set_uid4audit_loan_stat_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   ); 
      PROCEDURE set_uid4audit_case_stat_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_debt_stat_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_dis_type_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   ); 
      PROCEDURE set_uid4audit_spo_type_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_emp_stat_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_mar_stat_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_title_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_res_type_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_joi_app_rel_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_sup_gra_rel_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   ); 
      PROCEDURE set_uid4audit_ben_rel_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_oth_loa_type_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_fee_loa_type_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_auth_stud_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_no_nino_rea_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_dup_bank_rea_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_sta_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_nom_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );   
      PROCEDURE set_uid4audit_stud_nom_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );   
      PROCEDURE set_uid4audit_dsa_type_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   ); 
      PROCEDURE set_uid4audit_dsa_cat_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_dsa_ref_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_dsa_rej_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_dsa_ac_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_dsa_pay_stat_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_dsa_st_type_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_dsa_app_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_dsa_all_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_dsa_pay_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   ); 
      PROCEDURE set_uid4audit_pay_paymt_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_fin_rev_jou_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_pay_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   ); 
      PROCEDURE set_uid4audit_adi_jou_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   ); 
      PROCEDURE set_uid4audit_pay_err_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
      PROCEDURE set_uid4audit_pay_inst_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
   PROCEDURE set_uid4audit_fpd_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
   PROCEDURE set_uid4audit_napd_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
   PROCEDURE set_uid4audit_res_aud (
      p_user_id         VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
END pk_steps_aud;
/
