CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_changes
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
-- 11/03/2001 A Bowman    008    Added procedures to update attendance data changed since last report flag
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
   END award_contrib_change;

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
   END award_net_change;

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

   PROCEDURE cslr_stud (p_stud_ref_no NUMBER)
   AS
      CURSOR c_stcy_id
      IS
         SELECT stud_crse_year_id
           FROM stud_crse_year
          WHERE stud_ref_no = p_stud_ref_no;

      v_stcy_id   c_stcy_id%ROWTYPE;
   BEGIN
      OPEN c_stcy_id;

      LOOP
         FETCH c_stcy_id
          INTO v_stcy_id;

         EXIT WHEN c_stcy_id%NOTFOUND;

         UPDATE attendance_data
            SET chngd_since_last_report = 'Y'
          WHERE stud_crse_year_id = v_stcy_id.stud_crse_year_id;
      END LOOP;

      CLOSE c_stcy_id;
   END cslr_stud;

   PROCEDURE cslr_stud_sess (p_stud_session_id NUMBER)
   AS
      CURSOR c_stcy_id
      IS
         SELECT stud_crse_year_id
           FROM stud_crse_year
          WHERE stud_session_id = p_stud_session_id;

      v_stcy_id   c_stcy_id%ROWTYPE;
   BEGIN
      OPEN c_stcy_id;

      LOOP
         FETCH c_stcy_id
          INTO v_stcy_id;

         EXIT WHEN c_stcy_id%NOTFOUND;

         UPDATE attendance_data
            SET chngd_since_last_report = 'Y'
          WHERE stud_crse_year_id = v_stcy_id.stud_crse_year_id;
      END LOOP;

      CLOSE c_stcy_id;
   END cslr_stud_sess;

   PROCEDURE cslr_award (
      p_old                 VARCHAR2,
      p_new                 VARCHAR2,
      p_stud_crse_year_id   NUMBER
   )
   AS
   BEGIN
      IF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         UPDATE attendance_data
            SET chngd_since_last_report = 'Y'
          WHERE stud_crse_year_id = p_stud_crse_year_id;
      END IF;
   END cslr_award;

   PROCEDURE cslr_awi (p_award_id NUMBER)
   AS
      v_src       award.award_src%TYPE;
      v_stcy_id   stud_crse_year.stud_crse_year_id%TYPE;
   BEGIN
      SELECT award_src
        INTO v_src
        FROM award
       WHERE award_id = p_award_id;

      SELECT stud_crse_year_id
        INTO v_stcy_id
        FROM award
       WHERE award_id = p_award_id;

      IF v_src = 'T'
      THEN
         UPDATE attendance_data
            SET chngd_since_last_report = 'Y'
          WHERE stud_crse_year_id = v_stcy_id;
      END IF;
   END cslr_awi;
END pk_steps_changes;
/
