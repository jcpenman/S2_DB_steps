CREATE OR REPLACE PACKAGE SGAS.M202 IS
-- SCCS IDENTIFICATION STRING
-- ==========================
-- @(#) m202_s.sql 10/07/98 11:07:35 1.13@(#)
--
-- DESCRIPTION
-- ===========
-- Package to insert records into AUD the table if the audit columns are
-- changed or records deleted.
-- This is a common function called by the audit database triggers.
-- P_Variable means the variable is a Parameter passed from the
-- Database Trigger.
-- PL_Variavle implies it is a PL/SQL Variable
-- Variables, Parameters, Package, Function, Procedure, Trigger,
-- Table, Alias and Column names are in capital letters.
-- All other reserve words are in lower case letters.
--
-- Modification History
-- Date       Author      Ref    Desc
-- 24/03/2010 A Bowman    005    Removed steps to grass synch code, this is now contained within pk_steps_to_grass
-- 29/09/2009 A Bowman    004    Removed marital_status and marriage_date from PROCEDURE update_stud_in_grass
-- 21/07/2009 A Bowman    003    Commented out AUD procedures as they are now handled by PK_STEPS_AUD
-- 03/03/2008 A Bowman    002    Added procedures as part of the change of details steps to grass synch process.
-- 09/01/2008 S Durkin    001    Add procedure set_uid4audit() to allow app code to correct userid recorded on deleted records.
--            A Bowman    000    Commented out REP functions.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/packages/M202.pks $
-- $Author: $
-- $Date: 2010-03-25 14:38:12 +0000 (Thu, 25 Mar 2010) $
-- $Revision: 5005 $
--
/*003  procedure INSERT_AUD(
        P_AUD_DATE        date,
        P_SESSION_CODE        number,
        P_TABLE_NAME        varchar2,
        P_COLUMN_NAME        varchar2,
        P_TABLE_PKEY1        varchar2,
        P_TABLE_PKEY2        varchar2,
        P_TABLE_PKEY3        varchar2,
        P_TABLE_PKEY4        varchar2,
        P_TABLE_PKEY5        varchar2,
        P_EMP_LOGIN_NAME    varchar2,
        P_OLD            varchar2,
        P_ACTION        varchar2,
        P_NEW            varchar2,
        P_STUD_REF_NO        number,
        P_INST_CODE        varchar2
    );
--
-- 001: procedure SET_UID4AUDIT ()  - 
-- Set the logging name on the AUD  audit table with the authenticated login name of the application user.
    PROCEDURE set_uid4audit(
        user_id          VARCHAR2,
        p_table_name     VARCHAR2,
        p_table_pkey1    VARCHAR2,
        p_table_pkey2    VARCHAR2 := '',
        p_table_pkey3    VARCHAR2 := '',
        p_table_pkey4    VARCHAR2 := '',
        p_table_pkey5    VARCHAR2 := ''
    );*/
-- Ref: 000
--    procedure INSERT_REP(
--        P_AUD_DATE        date,
--        P_TABLE_NAME        varchar2,
--        P_COLUMN_NAME        varchar2,
--        P_EMP_LOGIN_NAME    varchar2,
--        P_OLD            varchar2,
--        P_NEW            varchar2,
--        P_INST_CODE        varchar2,
--        P_CAMPUS_CODE        varchar2
--    );
    procedure AWARD_CONTRIB_CHANGE( P_OLD varchar2, P_NEW varchar2, P_STUD_CRSE_YEAR_ID number);
    procedure AWARD_NET_CHANGE( P_OLD varchar2, P_NEW varchar2, P_STUD_CRSE_YEAR_ID number);
    procedure STUD_REP(
            P_STUD_REF_NO    number,
            P_FORENAMES    varchar2,
            P_SURNAME    varchar2,
            P_DOB        date,
            P_SEX        varchar2
        );
    procedure CRSE_REP(
            P_CRSE_ID    number,
            P_CRSE_CODE    varchar2,
            P_CRSE_NAME    varchar2,
            P_SCHEME_TYPE    varchar2,
            P_INST_CODE    varchar2,
            P_OLD_CRSE_CODE    varchar2
        );
-- Ref: 000
--    procedure INST_REP(
--            P_INST_CODE    varchar2,
--            P_INST_NAME    varchar2
--        );
    procedure STUD_SESSION_REP(
            P_STUD_SESSION_ID    number,
            P_SESSION_CODE        number
        );
    procedure CRSE_YEAR_REP(
            P_CRSE_YEAR_ID    number,
            P_CRSE_YEAR_NO    number
        );
    procedure STUD_CRSE_YEAR_REP(
            P_STUD_CRSE_YEAR_ID    number,
            P_SESSION_CODE        number,
            P_CRSE_YEAR_NO        number,
            P_INST_CODE        varchar2,
            P_CRSE_ID        number
        );
    procedure TUITION_FEE_TYPE_REP(
            P_TUITION_FEE_TYPE_CODE number,
            P_DESCRIPT        varchar2
        );
    procedure STUD_RATES_REP(
            P_STUD_AWARD_TYPE     varchar2,
            P_DESCRIPT        varchar2
        );
-- Ref: 000
--    procedure EMP_REP(
--            P_EMP_LOGIN_NAME     varchar2,
--            P_FIRST_NAME        varchar2,
--            P_LAST_NAME        varchar2
--        );
-- Ref: 002
        
end M202; 
/

