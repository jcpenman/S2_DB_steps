CREATE OR REPLACE PACKAGE BODY SGAS.M202 IS
-- SCCS IDENTIFICATION STRING
-- ==========================
-- @(#) m202_b.sql 09/11/97 09:12:21 1.11@(#)
--
-- DESCRIPTION
-- ===========
--
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
--            A Bowman    000    Commented out REP functions, not required on STEPS.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/packages/M202.pkb $
-- $Author: $
-- $Date: 2010-03-25 14:38:12 +0000 (Thu, 25 Mar 2010) $
-- $Revision: 5005 $
--
   /* procedure INSERT_AUD(P_AUD_DATE       date    , P_SESSION_CODE number,
                 P_TABLE_NAME  varchar2,
                 P_COLUMN_NAME    varchar2, P_TABLE_PKEY1 varchar2,
                 P_TABLE_PKEY2    varchar2, P_TABLE_PKEY3 varchar2,
                 P_TABLE_PKEY4    varchar2, P_TABLE_PKEY5 varchar2,
                 P_EMP_LOGIN_NAME varchar2, P_OLD          varchar2,
                 P_ACTION          varchar2, P_NEW          varchar2,
                 P_STUD_REF_NO    number  , P_INST_CODE   varchar2) as
        PL_AUD_ID    AUD.AUD_ID%type;
    begin
        if ( P_ACTION = 'D' ) then
            select    aud_aud_id_seq.nextval
            into    PL_AUD_ID
            from    dual;
            insert    into    aud
                (AUD_ID, AUD_DATE, TABLE_NAME, COLUMN_NAME,
                 TABLE_PKEY1, TABLE_PKEY2, TABLE_PKEY3,
                 TABLE_PKEY4, TABLE_PKEY5, EMP_LOGIN_NAME,
                  OLD, ACTION, NEW, STUD_REF_NO, INST_CODE,
                 SESSION_CODE)
            values
                 (PL_AUD_ID, P_AUD_DATE, P_TABLE_NAME, P_COLUMN_NAME,
                 P_TABLE_PKEY1, P_TABLE_PKEY2, P_TABLE_PKEY3,
                 P_TABLE_PKEY4, P_TABLE_PKEY5, P_EMP_LOGIN_NAME,
                  P_OLD, P_ACTION, P_NEW, P_STUD_REF_NO,
                 P_INST_CODE, P_SESSION_CODE);
        elsif ( nvl(P_OLD,' ') <> nvl(P_NEW,' ') ) then
            select    aud_aud_id_seq.nextval
            into    PL_AUD_ID
            from    dual;
            insert    into    aud
                (AUD_ID, AUD_DATE, TABLE_NAME, COLUMN_NAME,
                 TABLE_PKEY1, TABLE_PKEY2, TABLE_PKEY3,
                 TABLE_PKEY4, TABLE_PKEY5, EMP_LOGIN_NAME,
                  OLD, ACTION, NEW, STUD_REF_NO, INST_CODE,
                 SESSION_CODE)
            values (PL_AUD_ID, P_AUD_DATE, P_TABLE_NAME, P_COLUMN_NAME,
                 P_TABLE_PKEY1, P_TABLE_PKEY2, P_TABLE_PKEY3,
                 P_TABLE_PKEY4, P_TABLE_PKEY5, P_EMP_LOGIN_NAME,
                  P_OLD, P_ACTION, P_NEW, P_STUD_REF_NO,
                 P_INST_CODE, P_SESSION_CODE);
        end if;
    end INSERT_AUD;
--
-- Ref: 001
-- procedure SET_UID4AUDIT ()  - 
-- Set the logging name on the AUD  audit table with the authenticated login name of the application user. 
-- Will only update audit entries for deletes done in the last hour. 
    PROCEDURE set_uid4audit (
        user_id          VARCHAR2,
        p_table_name     VARCHAR2,
        p_table_pkey1    VARCHAR2,
        p_table_pkey2    VARCHAR2 := '',
        p_table_pkey3    VARCHAR2 := '',
        p_table_pkey4    VARCHAR2 := '',
        p_table_pkey5    VARCHAR2 := ''
    ) AS
    BEGIN
        UPDATE  aud
        SET     emp_login_name = user_id
        WHERE   table_name = p_table_name
        AND     table_pkey1 = p_table_pkey1
        AND     Nvl(table_pkey2,'null') = Nvl(p_table_pkey2,'null')
        AND     Nvl(table_pkey3,'null') = Nvl(p_table_pkey3,'null')
        AND     Nvl(table_pkey4,'null') = Nvl(p_table_pkey4,'null')
        AND     Nvl(table_pkey5,'null') = Nvl(p_table_pkey5,'null')
        AND     action = 'D'
        AND     AUD_DATE BETWEEN Sysdate -(1/24) AND Sysdate;
    END;*/
--
-- Ref: 000
    -- PROCEDURE INSERT_REP (P_AUD_DATE       DATE,
                  -- P_TABLE_NAME     VARCHAR2,
                  -- P_COLUMN_NAME    VARCHAR2,
                  -- P_EMP_LOGIN_NAME VARCHAR2,
                  -- P_OLD           VARCHAR2,
                  -- P_NEW           VARCHAR2,
                  -- P_INST_CODE      VARCHAR2,
                  -- P_CAMPUS_CODE    VARCHAR2)
    -- AS
    -- BEGIN
      -- IF (NVL(P_OLD,' ') <> NVL(P_NEW,' ')) THEN
          -- INSERT INTO REP_INST_CHANGES (change_date, table_name, column_name, emp_login_name,
                      -- old, new, inst_code, campus_code)
        -- VALUES (p_aud_date, p_table_name, p_column_name, p_emp_login_name, p_old, p_new,
            -- p_inst_code, p_campus_code);
      -- END IF;
    -- END INSERT_REP;
--
    procedure AWARD_CONTRIB_CHANGE(P_OLD varchar2, P_NEW varchar2,P_STUD_CRSE_YEAR_ID number) as
    begin
        if ( nvl(P_OLD,' ') <> nvl(P_NEW,' ') ) then
        update stud_crse_year
        set    contrib_changed = sysdate
        where  stud_crse_year_id = p_stud_crse_year_id;
        end if;
    end;
--
    procedure AWARD_NET_CHANGE(P_OLD varchar2, P_NEW varchar2,P_STUD_CRSE_YEAR_ID number) as
    begin
        if ( nvl(P_OLD,' ') <> nvl(P_NEW,' ') ) then
        update stud_crse_year
        set    net_amount_changed = sysdate
        where  stud_crse_year_id = p_stud_crse_year_id;
        end if;
    end;
--
    procedure STUD_REP(
            P_STUD_REF_NO    number,
            P_FORENAMES    varchar2,
            P_SURNAME    varchar2,
            P_DOB        date,
            P_SEX        varchar2) as
    begin
        update    STUD_SESSION
        set    FORENAMES   = P_FORENAMES,
            SURNAME     = P_SURNAME,
            DOB        = P_DOB,
            SEX        = P_SEX
        where    STUD_REF_NO = P_STUD_REF_NO;
    end STUD_REP;
--
    procedure CRSE_REP(
            P_CRSE_ID number,
            P_CRSE_CODE    varchar2,
            P_CRSE_NAME    varchar2,
            P_SCHEME_TYPE    varchar2,
            P_INST_CODE    varchar2,
            P_OLD_CRSE_CODE varchar2) as
    begin
        begin
            update    STUD_CRSE_YEAR
            set    CRSE_NAME   = P_CRSE_NAME,
                SCHEME_TYPE = P_SCHEME_TYPE,
                CRSE_CODE   = P_CRSE_CODE
            where    CRSE_ID = P_CRSE_ID
            --    Need to only update for course within selected institution
            --    Fix of SIR 86 - JT 20/05/1997
            --  Janis RFC7 if crse_code is changed in M002 update
            -- all stud_crse_year records for the inst_code/crse_code
            -- combination.  Also if the changed crse_code is held
            -- in prev_crse_code,crse_name then update these values
            -- with the new values.  23/06/1997 add CRSE_ID in update
            -- statement to identify the old crse_record.
            and    INST_CODE   = P_INST_CODE;
        end;
        begin
            update    STUD_CRSE_YEAR
            set    PREV_CRSE_NAME     = P_CRSE_NAME,
                PREV_CRSE_CODE     = P_CRSE_CODE
            where PREV_CRSE_CODE = P_OLD_CRSE_CODE
            and    PREV_INST_CODE     = P_INST_CODE;
        end;
    end CRSE_REP;
-- Ref: 000
--    procedure INST_REP(
--            P_INST_CODE    varchar2,
--            P_INST_NAME    varchar2) as
--    begin
--        update    STUD_CRSE_YEAR
--        set        INST_NAME = P_INST_NAME
--        where    INST_CODE = P_INST_CODE;
--        update    STUD_CRSE_YEAR
--        set        PREV_INST_NAME = P_INST_NAME
--        where    PREV_INST_CODE = P_INST_CODE;
--        update    CRSE
--        set        INST_NAME = P_INST_NAME
--        where    INST_CODE = P_INST_CODE;
--    end INST_REP;
--
    procedure STUD_SESSION_REP(
            P_STUD_SESSION_ID    number,
            P_SESSION_CODE        number ) as
    begin
        update     STUD_CRSE_YEAR
        set    SESSION_CODE    = P_SESSION_CODE
        where     STUD_SESSION_ID = P_STUD_SESSION_ID;
    end STUD_SESSION_REP;
--
    procedure CRSE_YEAR_REP(
            P_CRSE_YEAR_ID    number,
            P_CRSE_YEAR_NO    number ) as
    begin
        update     STUD_CRSE_YEAR
        set    CRSE_YEAR_NO = P_CRSE_YEAR_NO
        where    CRSE_YEAR_ID = P_CRSE_YEAR_ID;
    end CRSE_YEAR_REP;
--
    procedure STUD_CRSE_YEAR_REP(
            P_STUD_CRSE_YEAR_ID    number,
            P_SESSION_CODE        number,
            P_CRSE_YEAR_NO        number,
            P_INST_CODE        varchar2,
            P_CRSE_ID        number     ) as
    begin
            update     AWARD
            set    SESSION_CODE = P_SESSION_CODE,
                CRSE_YEAR_NO =
            decode(P_CRSE_YEAR_NO,null,CRSE_YEAR_NO,P_CRSE_YEAR_NO),
                INST_CODE    = P_INST_CODE,
                CRSE_ID      =
                   decode(P_CRSE_ID,null,CRSE_ID,P_CRSE_ID)
            where    STUD_CRSE_YEAR_ID = P_STUD_CRSE_YEAR_ID;
    end STUD_CRSE_YEAR_REP;
--
    procedure TUITION_FEE_TYPE_REP(
            P_TUITION_FEE_TYPE_CODE number,
            P_DESCRIPT        varchar2 ) as
    begin
        update    AWARD
        set    AWARD_TYPE_DESCRIPT = P_DESCRIPT
        where     TUITION_FEE_TYPE_CODE = P_TUITION_FEE_TYPE_CODE;
    end TUITION_FEE_TYPE_REP;
--
    procedure STUD_RATES_REP(
            P_STUD_AWARD_TYPE     varchar2,
            P_DESCRIPT        varchar2 ) as
    begin
        update    AWARD
        set    AWARD_TYPE_DESCRIPT = P_DESCRIPT
        where    STUD_AWARD_TYPE = P_STUD_AWARD_TYPE;
    end STUD_RATES_REP;
-- Ref: 000
--    procedure EMP_REP(
--            P_EMP_LOGIN_NAME     varchar2,
--            P_FIRST_NAME        varchar2,
--            P_LAST_NAME        varchar2 ) as
--    begin
--        update    JA_CASE
--        set    FIRST_NAME = P_FIRST_NAME,
--            LAST_NAME = P_LAST_NAME
--        where    CASE_HOLDER = P_EMP_LOGIN_NAME;
--        update    STUD_SESSION
--        set    FIRST_NAME = P_FIRST_NAME,
--            LAST_NAME = P_LAST_NAME
--        where    EMP_LOGIN_NAME = P_EMP_LOGIN_NAME;
--        update    TEAM
--        set    FIRST_NAME = P_FIRST_NAME,
--            LAST_NAME = P_LAST_NAME
--        where    LEAD_EMP_LOGIN_NAME = P_EMP_LOGIN_NAME;
--    end EMP_REP;
-- Ref: 002
      
end M202;
/