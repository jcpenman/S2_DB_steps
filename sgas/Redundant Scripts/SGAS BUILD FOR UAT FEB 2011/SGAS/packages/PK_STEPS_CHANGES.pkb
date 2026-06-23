/* Formatted on 2010/10/12 09:42 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY sgas.pk_steps_changes
IS
-- DESCRIPTION
-- ===========
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
-- 12/10/2010 A Bowman    007    Added procedure for inserting record in batch_recalc table when location_ind is updated on stud_term_addr table
-- 13/05/2010 A Bowman    006    Renamed package M202 to more meaningful PK_STEPS_CHANGES
-- 24/03/2010 A Bowman    005    Removed steps to grass synch code, this is now contained within pk_steps_to_grass
-- 29/09/2009 A Bowman    004    Removed marital_status and marriage_date from PROCEDURE update_stud_in_grass
-- 21/07/2009 A Bowman    003    Commented out AUD procedures as they are now handled by PK_STEPS_AUD
-- 03/03/2008 A Bowman    002    Added procedures as part of the change of details steps to grass synch process.
-- 09/01/2008 S Durkin    001    Add procedure set_uid4audit() to allow app code to correct userid recorded on deleted records.
--            A Bowman    000    Commented out REP functions.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/packages/M202.pkb $
-- $Author: $
-- $Date: 2009-09-29 11:41:47 +0100 (Tue, 29 Sep 2009) $
-- $Revision: 3925 $
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
   PROCEDURE award_contrib_change (
      p_old                 VARCHAR2,
      p_new                 VARCHAR2,
      p_stud_crse_year_id   NUMBER
   )
   AS
   BEGIN
      IF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         UPDATE stud_crse_year
            SET contrib_changed = SYSDATE
          WHERE stud_crse_year_id = p_stud_crse_year_id;
      END IF;
   END;

--
   PROCEDURE award_net_change (
      p_old                 VARCHAR2,
      p_new                 VARCHAR2,
      p_stud_crse_year_id   NUMBER
   )
   AS
   BEGIN
      IF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         UPDATE stud_crse_year
            SET net_amount_changed = SYSDATE
          WHERE stud_crse_year_id = p_stud_crse_year_id;
      END IF;
   END;

--
   PROCEDURE stud_rep (
      p_stud_ref_no   NUMBER,
      p_forenames     VARCHAR2,
      p_surname       VARCHAR2,
      p_dob           DATE,
      p_sex           VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_session
         SET forenames = p_forenames,
             surname = p_surname,
             dob = p_dob,
             sex = p_sex
       WHERE stud_ref_no = p_stud_ref_no;
   END stud_rep;

--
   PROCEDURE crse_rep (
      p_crse_id         NUMBER,
      p_crse_code       VARCHAR2,
      p_crse_name       VARCHAR2,
      p_scheme_type     VARCHAR2,
      p_inst_code       VARCHAR2,
      p_old_crse_code   VARCHAR2
   )
   AS
   BEGIN
      BEGIN
         UPDATE stud_crse_year
            SET crse_name = p_crse_name,
                scheme_type = p_scheme_type,
                crse_code = p_crse_code
          WHERE crse_id = p_crse_id
                                   --    Need to only update for course within selected institution
                                   --    Fix of SIR 86 - JT 20/05/1997
                                   --  Janis RFC7 if crse_code is changed in M002 update
                                   -- all stud_crse_year records for the inst_code/crse_code
                                   -- combination.  Also if the changed crse_code is held
                                   -- in prev_crse_code,crse_name then update these values
                                   -- with the new values.  23/06/1997 add CRSE_ID in update
                                   -- statement to identify the old crse_record.
                AND inst_code = p_inst_code;
      END;

      BEGIN
         UPDATE stud_crse_year
            SET prev_crse_name = p_crse_name,
                prev_crse_code = p_crse_code
          WHERE prev_crse_code = p_old_crse_code
            AND prev_inst_code = p_inst_code;
      END;
   END crse_rep;

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
   PROCEDURE stud_session_rep (p_stud_session_id NUMBER, p_session_code NUMBER)
   AS
   BEGIN
      UPDATE stud_crse_year
         SET session_code = p_session_code
       WHERE stud_session_id = p_stud_session_id;
   END stud_session_rep;

--
   PROCEDURE crse_year_rep (p_crse_year_id NUMBER, p_crse_year_no NUMBER)
   AS
   BEGIN
      UPDATE stud_crse_year
         SET crse_year_no = p_crse_year_no
       WHERE crse_year_id = p_crse_year_id;
   END crse_year_rep;

--
   PROCEDURE stud_crse_year_rep (
      p_stud_crse_year_id   NUMBER,
      p_session_code        NUMBER,
      p_crse_year_no        NUMBER,
      p_inst_code           VARCHAR2,
      p_crse_id             NUMBER
   )
   AS
   BEGIN
      UPDATE award
         SET session_code = p_session_code,
             crse_year_no =
                   DECODE (p_crse_year_no,
                           NULL, crse_year_no,
                           p_crse_year_no
                          ),
             inst_code = p_inst_code,
             crse_id = DECODE (p_crse_id, NULL, crse_id, p_crse_id)
       WHERE stud_crse_year_id = p_stud_crse_year_id;
   END stud_crse_year_rep;

--
   PROCEDURE tuition_fee_type_rep (
      p_tuition_fee_type_code   NUMBER,
      p_descript                VARCHAR2
   )
   AS
   BEGIN
      UPDATE award
         SET award_type_descript = p_descript
       WHERE tuition_fee_type_code = p_tuition_fee_type_code;
   END tuition_fee_type_rep;

--
   PROCEDURE stud_rates_rep (p_stud_award_type VARCHAR2, p_descript VARCHAR2)
   AS
   BEGIN
      UPDATE award
         SET award_type_descript = p_descript
       WHERE stud_award_type = p_stud_award_type;
   END stud_rates_rep;

   PROCEDURE ins_batch_recalc (p_stud_ref_no NUMBER)
   AS
      v_stud_crse_year_id   stud_crse_year.stud_crse_year_id%TYPE;
      v_sess_code           config_data.cval%TYPE;
   BEGIN
      SELECT cval
        INTO v_sess_code
        FROM config_data
       WHERE UPPER (item_name) = 'CURRENT_SESSION';

      SELECT stcy.stud_crse_year_id
        INTO v_stud_crse_year_id
        FROM stud_crse_year stcy
       WHERE stcy.stud_ref_no = p_stud_ref_no
         AND stcy.session_code = v_sess_code
         AND stcy.latest_crse_ind = 'Y';

      INSERT INTO sgas.batch_recalc
                  (stud_crse_year_id, recall_date, stud_ref_no, pass_fail,
                   error_message
                  )
           VALUES (v_stud_crse_year_id, SYSDATE, p_stud_ref_no, NULL,
                   NULL
                  );
   END ins_batch_recalc;
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
END pk_steps_changes;
/