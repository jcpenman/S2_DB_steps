CREATE OR REPLACE PACKAGE SGAS.pk_steps_changes
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
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/packages/M202.pks $
-- $Author: $
-- $Date: 2009-09-29 11:41:47 +0100 (Tue, 29 Sep 2009) $
-- $Revision: 3925 $
--
   PROCEDURE award_contrib_change (
      p_old                 VARCHAR2,
      p_new                 VARCHAR2,
      p_stud_crse_year_id   NUMBER
   );

   PROCEDURE award_net_change (
      p_old                 VARCHAR2,
      p_new                 VARCHAR2,
      p_stud_crse_year_id   NUMBER
   );

   PROCEDURE stud_rep (
      p_stud_ref_no   NUMBER,
      p_forenames     VARCHAR2,
      p_surname       VARCHAR2,
      p_dob           DATE,
      p_sex           VARCHAR2
   );

   PROCEDURE crse_rep (
      p_crse_id         NUMBER,
      p_crse_code       VARCHAR2,
      p_crse_name       VARCHAR2,
      p_scheme_type     VARCHAR2,
      p_inst_code       VARCHAR2,
      p_old_crse_code   VARCHAR2
   );

   PROCEDURE stud_session_rep (p_stud_session_id NUMBER, p_session_code NUMBER);

   PROCEDURE crse_year_rep (p_crse_year_id NUMBER, p_crse_year_no NUMBER);

   PROCEDURE stud_crse_year_rep (
      p_stud_crse_year_id   NUMBER,
      p_session_code        NUMBER,
      p_crse_year_no        NUMBER,
      p_inst_code           VARCHAR2,
      p_crse_id             NUMBER
   );

   PROCEDURE tuition_fee_type_rep (
      p_tuition_fee_type_code   NUMBER,
      p_descript                VARCHAR2
   );

   PROCEDURE stud_rates_rep (p_stud_award_type VARCHAR2, p_descript VARCHAR2);

   PROCEDURE cslr_stud (p_stud_ref_no NUMBER);
   PROCEDURE cslr_stud_sess (p_stud_session_id NUMBER);
      PROCEDURE cslr_award (
      p_old                 VARCHAR2,
      p_new                 VARCHAR2,
      p_stud_crse_year_id   NUMBER
   );
   PROCEDURE cslr_awi (p_award_id NUMBER);
END pk_steps_changes;
/
