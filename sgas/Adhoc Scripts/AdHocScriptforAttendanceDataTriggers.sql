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

/* Formatted on 2011/03/11 12:11 (Formatter Plus v4.8.8) */
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

CREATE OR REPLACE TRIGGER SGAS.st_iud
   AFTER INSERT OR DELETE OR UPDATE OF account_no,
                                       birth_cert_flag,
                                       birth_country_code,
                                       def_overpayment,
                                       disabled,
                                       dob,
                                       dsa_eqmt,
                                       forenames,
                                       initials,
                                       maiden_name,
                                       marital_status,
                                       marriage_date,
                                       nation_country_code,
                                       ni_no,
                                       nominee,
                                       nom_method,
                                       nom_name,
                                       overpayment,
                                       overpay_stat,
                                       payment_method,
                                       residence_country_code,
                                       residence_id,
                                       sex,
                                       snb_def_overpayment,
                                       snb_overpayment,
                                       sort_code,
                                       surname,
                                       title,
                                       valid_duplicate_acc,
                                       dup_bank_reason,
                                       bankrupt_flag,
                                       qa_count,
                                       stud_suspend,
                                       last_updated_by
   ON SGAS.STUD    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   p_aud_date       DATE                         := SYSDATE;
   p_column_name    stud_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_aud.table_pkey1%TYPE    := :OLD.stud_ref_no;
   p_table_pkey2    stud_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_aud.OLD%TYPE            := NULL;
   p_new            stud_aud.NEW%TYPE            := NULL;
   p_action         stud_aud.action%TYPE         := NULL;
   p_username       stud_aud.username%TYPE       := :NEW.last_updated_by;
   p_stud_ref_no    stud_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      stud_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_aud.session_code%TYPE   := NULL;
   will_update      VARCHAR2 (1)                 := 'N';
   p_table_name     VARCHAR2 (32)                := 'STUD';
   p_dob            stud.dob%TYPE;
   p_initials       stud.initials%TYPE;
   p_forenames      stud.forenames%TYPE;
   p_surname        stud.surname%TYPE;
   p_ni_no          stud.ni_no%TYPE;
   p_mobile         stud.mobile_tel_no%TYPE;
   p_email          stud.email_addr%TYPE;
   p_calc           DATE                         := NULL;
   p_sent           DATE                         := NULL;
   v_updated        VARCHAR2 (1)                 := 'N';
   v_chngd          VARCHAR2 (1)                 := 'N';
BEGIN
   /*IF Change_Audit.auditing_on != 'FALSE' THEN
   --PB Feb 2005
   P_STUD_REF_NO := :NEW.STUD_REF_NO;
   P_DOB := :NEW.DOB;
   P_INITIALS := :NEW.INITIALS;
   P_FORENAMES := :NEW.FORENAMES;
   P_SURNAME := :NEW.SURNAME;
   P_NI_NO := :NEW.NI_NO;
   P_MOBILE := :NEW.MOBILE_TEL_NO;
   P_EMAIL := :NEW.EMAIL_ADDR;*/
   --
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
      p_stud_ref_no := :OLD.stud_ref_no;
      p_dob := :OLD.dob;
      p_initials := :OLD.initials;
      p_forenames := :OLD.forenames;
      p_surname := :OLD.surname;
      p_ni_no := :OLD.ni_no;
      p_mobile := :OLD.mobile_tel_no;
      p_email := :OLD.email_addr;
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
      p_table_pkey1 := :NEW.stud_ref_no;
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   ELSIF UPDATING
   THEN
      p_action := 'U';

      IF (NVL (:OLD.forenames, ' ') <> NVL (:NEW.forenames, ' '))
      THEN
         will_update := 'Y';
      ELSIF (NVL (:OLD.surname, ' ') <> NVL (:NEW.surname, ' '))
      THEN
         will_update := 'Y';
      ELSIF (NVL (:OLD.sex, ' ') <> NVL (:NEW.sex, ' '))
      THEN
         will_update := 'Y';
      ELSIF (:OLD.dob <> :NEW.dob)
      THEN
         will_update := 'Y';
      END IF;

      IF will_update = 'Y'
      THEN
         pk_steps_changes.stud_rep (:OLD.stud_ref_no,
                                    :NEW.forenames,
                                    :NEW.surname,
                                    :NEW.dob,
                                    :NEW.sex
                                   );
      END IF;
   END IF;

   --- IF P_ACTION <> 'I' THEN
   p_column_name := 'DOB';
   p_old := TO_CHAR (:OLD.dob, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.dob, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'TITLE';
   p_old := :OLD.title;
   p_new := :NEW.title;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'INITIALS';
   p_old := :OLD.initials;
   p_new := :NEW.initials;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'FORENAMES';
   p_old := :OLD.forenames;
   p_new := :NEW.forenames;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'SURNAME';
   p_old := :OLD.surname;
   p_new := :NEW.surname;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'SEX';
   p_old := :OLD.sex;
   p_new := :NEW.sex;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'RESIDENCE_ID';
   p_old := TO_CHAR (:OLD.residence_id);
   p_new := TO_CHAR (:NEW.residence_id);
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'BIRTH_COUNTRY_CODE';
   p_old := TO_CHAR (:OLD.birth_country_code);
   p_new := TO_CHAR (:NEW.birth_country_code);
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'RESIDENCE_COUNTRY_CODE';
   p_old := TO_CHAR (:OLD.residence_country_code);
   p_new := TO_CHAR (:NEW.residence_country_code);
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'NATION_COUNTRY_CODE';
   p_old := TO_CHAR (:OLD.nation_country_code);
   p_new := TO_CHAR (:NEW.nation_country_code);
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'NOMINEE';
   p_old := :OLD.nominee;
   p_new := :NEW.nominee;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'PAYMENT_METHOD';
   p_old := :OLD.payment_method;
   p_new := :NEW.payment_method;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'OVERPAY_STAT';
   p_old := :OLD.overpay_stat;
   p_new := :NEW.overpay_stat;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'OVERPAYMENT';
   p_old := TO_CHAR (:OLD.overpayment);
   p_new := TO_CHAR (:NEW.overpayment);
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'DEF_OVERPAYMENT';
   p_old := TO_CHAR (:OLD.def_overpayment);
   p_new := TO_CHAR (:NEW.def_overpayment);
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'SNB_OVERPAYMENT';
   p_old := TO_CHAR (:OLD.snb_overpayment);
   p_new := TO_CHAR (:NEW.snb_overpayment);
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'SNB_DEF_OVERPAYMENT';
   p_old := TO_CHAR (:OLD.snb_def_overpayment);
   p_new := TO_CHAR (:NEW.snb_def_overpayment);
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'DISABLED';
   p_old := :OLD.disabled;
   p_new := :NEW.disabled;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'MARITAL_STATUS';
   p_old := :OLD.marital_status;
   p_new := :NEW.marital_status;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'MARRIAGE_DATE';
   p_old := TO_CHAR (:OLD.marriage_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.marriage_date, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'ACCOUNT_NO';
   p_old := :OLD.account_no;
   p_new := :NEW.account_no;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'SORT_CODE';
   p_old := :OLD.sort_code;
   p_new := :NEW.sort_code;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'NOM_METHOD';
   p_old := :OLD.nom_method;
   p_new := :NEW.nom_method;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'NOM_NAME';
   p_old := :OLD.nom_name;
   p_new := :NEW.nom_name;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'MAIDEN_NAME';
   p_old := :OLD.maiden_name;
   p_new := :NEW.maiden_name;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'DSA_EQMT';
   p_old := TO_CHAR (:OLD.dsa_eqmt);
   p_new := TO_CHAR (:NEW.dsa_eqmt);
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'SUSPEND_PAYMENT';
   p_old := :OLD.suspend_payment;
   p_new := :NEW.suspend_payment;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'NI_NO';
   p_old := :OLD.ni_no;
   p_new := :NEW.ni_no;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'BIRTH_CERT_FLAG';
   p_old := :OLD.birth_cert_flag;
   p_new := :NEW.birth_cert_flag;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'VALID_DUPLICATE_ACC';
   p_old := :OLD.valid_duplicate_acc;
   p_new := :NEW.valid_duplicate_acc;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'DUP_BANK_REASON';
   p_old := :OLD.dup_bank_reason;
   p_new := :NEW.dup_bank_reason;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'BANKRUPT_FLAG';
   p_old := :OLD.bankrupt_flag;
   p_new := :NEW.bankrupt_flag;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'QA_COUNT';
   p_old := :OLD.qa_count;
   p_new := :NEW.qa_count;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'STUD_SUSPEND';
   p_old := :OLD.stud_suspend;
   p_new := :NEW.stud_suspend;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_st_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_stud_ref_no,
                            p_inst_code,
                            p_session_code
                           );
   --END IF;

   /*New auditing for Telephony - PB Feb 2005*/
    --
   p_column_name := 'STUD_REF_NO';
   p_old := :OLD.stud_ref_no;
   p_new := :NEW.stud_ref_no;

   IF :OLD.stud_ref_no <> :NEW.stud_ref_no
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'DOB';
   p_old := TO_CHAR (:OLD.dob, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.dob, 'DD/MM/YYYY HH24:MI');

   IF :OLD.dob <> :NEW.dob
   THEN
      v_updated := 'Y';
      v_chngd := 'Y';
   END IF;

   --
   p_column_name := 'INITIALS';
   p_old := :OLD.initials;
   p_new := :NEW.initials;

   IF NVL (:OLD.initials, 'BLANK') <> NVL (:NEW.initials, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'FORENAMES';
   p_old := :OLD.forenames;
   p_new := :NEW.forenames;

   IF :OLD.forenames <> :NEW.forenames
   THEN
      v_updated := 'Y';
      v_chngd := 'Y';
   END IF;

   --
   p_column_name := 'SURNAME';
   p_old := :OLD.surname;
   p_new := :NEW.surname;

   IF :OLD.surname <> :NEW.surname
   THEN
      v_updated := 'Y';
      v_chngd := 'Y';
   END IF;

   --
   p_column_name := 'NI_NO';
   p_old := :OLD.ni_no;
   p_new := :NEW.ni_no;

   IF NVL (:OLD.ni_no, 'BLANK') <> NVL (:NEW.ni_no, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'MOBILE_TEL_NO';
   p_old := :OLD.mobile_tel_no;
   p_new := :NEW.mobile_tel_no;

   IF NVL (:OLD.mobile_tel_no, 0) <> NVL (:NEW.mobile_tel_no, 0)
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'EMAIL_ADDR';
   p_old := :OLD.email_addr;
   p_new := :NEW.email_addr;

   IF NVL (:OLD.email_addr, 'BLANK') <> NVL (:NEW.email_addr, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   p_column_name := 'STUD_SUSPEND';
   p_old := :OLD.stud_suspend;
   p_new := :NEW.stud_suspend;

   IF NVL (:OLD.stud_suspend, 'BLANK') <> NVL (:NEW.stud_suspend, 'BLANK')
   THEN
      v_chngd := 'Y';
   END IF;

   IF v_updated = 'Y'
   THEN
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
      telephony_support.update_web_mail (p_stud_ref_no, :NEW.email_addr);
   END IF;

  IF v_chngd = 'Y'
   THEN
    p_stud_ref_no := :OLD.stud_ref_no;
    pk_steps_changes.cslr_stud (p_stud_ref_no);
  END IF;
/* End of Additions
     END IF;*/
END st_iud;
show errors;

/* Formatted on 2011/03/11 13:29 (Formatter Plus v4.8.8) */
CREATE OR REPLACE TRIGGER sgas.sts_iud
   AFTER INSERT OR DELETE OR UPDATE OF ben1_id,
                                       ben2_id,
                                       emp_login_name,
                                       ja_case,
                                       loan_declaration_date,
                                       loan_request,
                                       max_loan_requested,
                                       net_income,
                                       pension_income,
                                       session_code,
                                       trust_income,
                                       ysb_entitlement,
                                       fee_loan_request_amount,
                                       max_fee_loan_requested,
                                       fee_loan_declaration_date,
                                       stud_hei_bursary_consent,
                                       reason_no_nino,
                                       slc1_fl_sent,
                                       slc1_fl_sent_date,
                                       lpcg_paid_amount,
                                       max_lpcg_paid,
                                       smg_entitlement,
                                       child_care_no,
                                       child_care_name,
                                       ben1_rel_id,
                                       ben2_rel_id,
                                       total_house_income,
                                       stud_income,
                                       date_applic_received,
                                       fee_loan_charged,
                                       session_suspend,
                                       last_updated_by
   ON sgas.stud_session
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   p_aud_date          DATE                                 := SYSDATE;
   p_column_name       stud_session_aud.column_name%TYPE    := NULL;
   p_table_pkey1       stud_session_aud.table_pkey1%TYPE
                                            := TO_CHAR (:OLD.stud_session_id);
   p_table_pkey2       stud_session_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3       stud_session_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4       stud_session_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5       stud_session_aud.table_pkey5%TYPE    := NULL;
   p_old               stud_session_aud.OLD%TYPE            := NULL;
   p_new               stud_session_aud.NEW%TYPE            := NULL;
   p_action            stud_session_aud.action%TYPE         := NULL;
   p_username          stud_session_aud.username%TYPE := :NEW.last_updated_by;
   p_stud_ref_no       stud_session_aud.stud_ref_no%TYPE  := :OLD.stud_ref_no;
   p_inst_code         stud_session_aud.inst_code%TYPE      := NULL;
   p_session_code      stud_session_aud.session_code%TYPE
                                                         := :NEW.session_code;
   p_stud_session_id   stud_session.stud_session_id%TYPE
                                                      := :OLD.stud_session_id;
   v_chngd             VARCHAR2 (1)                         := 'N';
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_session_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   /* Removed nvl as Oracle 9i doesn't cope */
   --IF (NVL(:OLD.SESSION_CODE,' ')  <> NVL(:NEW.SESSION_CODE,' ')) THEN
   /*IF (:OLD.SESSION_CODE  <> :NEW.SESSION_CODE) THEN
       M202.STUD_SESSION_REP(:OLD.STUD_SESSION_ID,
                   :NEW.SESSION_CODE);*/
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_session_code := :OLD.session_code;
      p_stud_ref_no := :OLD.stud_ref_no;
      p_username := :OLD.last_updated_by;
   END IF;

   IF p_action = 'U'
   THEN
      IF :OLD.session_suspend <> :NEW.session_suspend
      THEN
         v_chngd := 'Y';
      END IF;
   END IF;

   IF v_chngd = 'Y'
   THEN
      pk_steps_changes.cslr_stud_sess (p_stud_session_id);
   END IF;

   p_column_name := 'BEN1_ID';
   p_old := TO_CHAR (:OLD.ben1_id);
   p_new := TO_CHAR (:NEW.ben1_id);
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'BEN2_ID';
   p_old := TO_CHAR (:OLD.ben2_id);
   p_new := TO_CHAR (:NEW.ben2_id);
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'EMP_LOGIN_NAME';
   p_old := :OLD.emp_login_name;
   p_new := :NEW.emp_login_name;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'JA_CASE';
   p_old := :OLD.ja_case;
   p_new := :NEW.ja_case;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'LOAN_DECLARATION_DATE';
   p_old := :OLD.loan_declaration_date;
   p_new := :NEW.loan_declaration_date;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'LOAN_REQUEST';
   p_old := TO_CHAR (:OLD.loan_request);
   p_new := TO_CHAR (:NEW.loan_request);
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'MAX_LOAN_REQUESTED';
   p_old := :OLD.max_loan_requested;
   p_new := :NEW.max_loan_requested;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'NET_INCOME';
   p_old := TO_CHAR (:OLD.net_income);
   p_new := TO_CHAR (:NEW.net_income);
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'PENSION_INCOME';
   p_old := TO_CHAR (:OLD.pension_income);
   p_new := TO_CHAR (:NEW.pension_income);
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'SESSION_CODE';
   p_old := :OLD.session_code;
   p_new := :NEW.session_code;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'TRUST_INCOME';
   p_old := TO_CHAR (:OLD.trust_income);
   p_new := TO_CHAR (:NEW.trust_income);
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'YSB_ENTITLEMENT';
   p_old := :OLD.ysb_entitlement;
   p_new := :NEW.ysb_entitlement;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'FEE_LOAN_REQUEST_AMOUNT';
   p_old := :OLD.fee_loan_request_amount;
   p_new := :NEW.fee_loan_request_amount;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'MAX_FEE_LOAN_REQUESTED';
   p_old := :OLD.max_fee_loan_requested;
   p_new := :NEW.max_fee_loan_requested;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'FEE_LOAN_DECLARATION_DATE';
   p_old := :OLD.fee_loan_declaration_date;
   p_new := :NEW.fee_loan_declaration_date;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'FEE_LOAN_CHARGED';
   p_old := :OLD.fee_loan_charged;
   p_new := :NEW.fee_loan_charged;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'STUD_HEI_BURSARY_CONSENT';
   p_old := :OLD.stud_hei_bursary_consent;
   p_new := :NEW.stud_hei_bursary_consent;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'REASON_NO_NINO';
   p_old := TO_CHAR (:OLD.reason_no_nino);
   p_new := TO_CHAR (:NEW.reason_no_nino);
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'SLC1_FL_SENT';
   p_old := TO_CHAR (:OLD.slc1_fl_sent);
   p_new := TO_CHAR (:NEW.slc1_fl_sent);
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'SLC1_FL_SENT_DATE';
   p_old := TO_CHAR (:OLD.slc1_fl_sent_date);
   p_new := TO_CHAR (:NEW.slc1_fl_sent_date);
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'LPCG_PAID_AMOUNT';
   p_old := :OLD.lpcg_paid_amount;
   p_new := :NEW.lpcg_paid_amount;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'MAX_LPCG_PAID';
   p_old := :OLD.max_lpcg_paid;
   p_new := :NEW.max_lpcg_paid;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'SMG_ENTITLEMENT';
   p_old := :OLD.smg_entitlement;
   p_new := :NEW.smg_entitlement;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'CHILD_CARE_NO';
   p_old := :OLD.child_care_no;
   p_new := :NEW.child_care_no;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'CHILD_CARE_NAME';
   p_old := :OLD.child_care_name;
   p_new := :NEW.child_care_name;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'BEN1_REL_ID';
   p_old := :OLD.ben1_rel_id;
   p_new := :NEW.ben1_rel_id;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'BEN2_REL_ID';
   p_old := :OLD.ben2_rel_id;
   p_new := :NEW.ben2_rel_id;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'TOTAL_HOUSE_INCOME';
   p_old := :OLD.total_house_income;
   p_new := :NEW.total_house_income;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'STUD_INCOME';
   p_old := :OLD.stud_income;
   p_new := :NEW.stud_income;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'DATE_APPLIC_RECEIVED';
   p_old := :OLD.date_applic_received;
   p_new := :NEW.date_applic_received;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'SESSION_SUSPEND';
   p_old := :OLD.session_suspend;
   p_new := :NEW.session_suspend;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_sts_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
END sts_iud;
show errors;

/* Formatted on 2011/03/11 10:43 (Formatter Plus v4.8.8) */
CREATE OR REPLACE TRIGGER sgas.stcy_iud
 AFTER INSERT OR DELETE OR UPDATE OF sal_sent, application_status, inst_change, parent_contrib_exempt,
             award, start_date, withdraw_date, vacation, crse_chg,study_country, snb_grad, award_letter_date, 
             award_letter_no, batch_recalc, dearing, resid_par_cont, 
             resid_spouse_cont,resid_stud_cont, parent_cont, spouse_cont, stud_cont,resid_trav_allow, sml_equip_rqst, 
             sml_equip_approve,lge_equip_descript,lge_equip_approve, lge_equip_rqst, diet_need_descript,disablement_code,
             end_date_abroad,erasmus, diet_need_req,diet_need_approve, non_med_req, 
             non_med_approve,provisional_case,provisional_date,repeat_year, req_dup, session_code, crse_year_no, inst_code, crse_id,
             unconditional, slc1_status, slc2_status,loan_given,latest_crse_ind,auto_calc_date,dsa_fee_descript,dsa_fee_rqst,
             dsa_fee_approve,attend_reqd, attend_confirmed,hei_date_attended, non_att_actioned, non_att_actioned_date, 
             trav_submitted_date,sal_sent_date, sal_dest, variable_fee_override_amount, fee_loan_given, fee_loan_eligibility_only,
             pgce, self_funding, independent, due_ysb_yso_ind, household_resid_income, ben1_total_income, ben2_total_income,
             snb_single_rate, nmsb_session_calc,start_date_abroad, study_abroad, unpaid_sandwich, paid_sandwich, calc_fee, calc_bursary,
             calc_loan, calc_dep_grant, calc_lpg, calc_lpcg, pay_ysb, pgce_edu_level, pgce_subject, first_calc_date, psas_pt, crse_suspend,last_updated_by
   ON sgas.stud_crse_year
   FOR EACH ROW
DECLARE
   p_aud_date            DATE                                    := SYSDATE;
   p_column_name         stud_crse_year_aud.column_name%TYPE     := NULL;
   p_table_pkey1         stud_crse_year_aud.table_pkey1%TYPE
                                          := TO_CHAR (:OLD.stud_crse_year_id);
   p_table_pkey2         stud_crse_year_aud.table_pkey2%TYPE     := NULL;
   p_table_pkey3         stud_crse_year_aud.table_pkey3%TYPE     := NULL;
   p_table_pkey4         stud_crse_year_aud.table_pkey4%TYPE     := NULL;
   p_table_pkey5         stud_crse_year_aud.table_pkey5%TYPE     := NULL;
   p_old                 stud_crse_year_aud.OLD%TYPE             := NULL;
   p_new                 stud_crse_year_aud.NEW%TYPE             := NULL;
   p_action              stud_crse_year_aud.action%TYPE          := NULL;
   p_username            stud_crse_year_aud.username%TYPE
                                                      := :NEW.last_updated_by;
   p_stud_ref_no         stud_crse_year_aud.stud_ref_no%TYPE     := NULL;
   p_inst_code           stud_crse_year_aud.inst_code%TYPE       := NULL;
   p_table_name          VARCHAR2 (32)                    := 'STUD_CRSE_YEAR';
   will_update           VARCHAR2 (1)                            := 'N';
   p_session_code        stud_crse_year.session_code%TYPE
                                                         := :NEW.session_code;
   p_dob                 stud.dob%TYPE                           := NULL;
   p_initials            stud.initials%TYPE                      := NULL;
   p_forenames           stud.forenames%TYPE                     := NULL;
   p_surname             stud.surname%TYPE                       := NULL;
   p_ni_no               stud.ni_no%TYPE                         := NULL;
   p_mobile              stud.mobile_tel_no%TYPE                 := NULL;
   p_email               stud.email_addr%TYPE                    := NULL;
   p_calc                DATE;
   p_sent                DATE;
   p_stud_crse_year_id   stud_crse_year.stud_crse_year_id%TYPE   := NULL;
   v_updated             VARCHAR2 (1)                            := 'N';
   v_chngd               VARCHAR2 (1)                            := 'N';
--
-----------------------------------------------------------------------------------------------------------------------------
--
   v_result              VARCHAR2 (1);
   v_default_date        DATE       := TO_DATE ('01/JAN/2000', 'DD/MON/YYYY');
    --
-----------------------------------------------------------------------------------------------------------------------------
--
--
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
      --
      -- TR 190 fix.
      -- Set P_SESSION_CODE to :OLD.SESSION_CODE as :NEW.SESSION_CODE will not
      -- exist.
      --
      p_session_code := :OLD.session_code;

      --
      -- End of TR 190 fix.
      --
      IF maintain_repository.latest_stud_crse_year (:OLD.stud_ref_no,
                                                    :OLD.session_code,
                                                    :OLD.latest_crse_ind
                                                   ) = 'Y'
      THEN
         v_result :=
            maintain_repository.record_app_status (:OLD.stud_ref_no,
                                                   'D',
                                                   :OLD.stud_crse_year_id,
                                                   SYSDATE
                                                  );
      END IF;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
      p_table_pkey1 := :NEW.stud_crse_year_id;
      p_dob := NULL;
      p_initials := NULL;
      p_forenames := NULL;
      p_surname := NULL;
      p_ni_no := NULL;
      p_mobile := NULL;
      p_email := NULL;
      p_calc := :NEW.auto_calc_date;
      p_sent := :NEW.sal_sent_date;
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);

      INSERT INTO sgas.attendance_data
                  (attendance_data_id,stud_crse_year_id) 
           VALUES (attendance_data_id_seq.nextval,:NEW.stud_crse_year_id);

   ELSIF UPDATING
   THEN
      p_action := 'U';

      IF :OLD.session_code <> :NEW.session_code
      THEN
         will_update := 'Y';
      ELSIF :OLD.crse_year_no <> :NEW.crse_year_no
      THEN
         will_update := 'Y';
         v_chngd := 'Y';
      ELSIF (NVL (:OLD.inst_code, ' ') <> NVL (:NEW.inst_code, ' '))
      THEN
         will_update := 'Y';
      ELSIF :OLD.crse_id <> :NEW.crse_id
      THEN
         will_update := 'Y';
         v_chngd := 'Y';
      ELSIF :OLD.crse_code <> :NEW.crse_code
      THEN
         v_chngd := 'Y';
      ELSIF :OLD.crse_name <> :NEW.crse_name
      THEN
         v_chngd := 'Y';
      ELSIF :OLD.crse_suspend <> :NEW.crse_suspend
      THEN
         v_chngd := 'Y';
      ELSIF :OLD.repeat_year <> :NEW.repeat_year
      THEN
         v_chngd := 'Y';
      ELSIF :OLD.application_status <> :NEW.application_status
      THEN
         v_chngd := 'Y';
      ELSIF :OLD.withdraw_date <> :NEW.withdraw_date
      THEN
         v_chngd := 'Y';
      ELSIF :OLD.reg_confirmed <> :NEW.reg_confirmed
      THEN
         v_chngd := 'Y';
      ELSIF :OLD.ongoing_attend <> :NEW.ongoing_attend
      THEN
         v_chngd := 'Y';
      END IF;

      IF v_chngd = 'Y'
      THEN
         p_stud_crse_year_id := :OLD.stud_crse_year_id;

         UPDATE attendance_data
            SET chngd_since_last_report = 'Y'
          WHERE stud_crse_year_id = p_stud_crse_year_id;
      END IF;

      IF will_update = 'Y'
      THEN
         pk_steps_changes.stud_crse_year_rep (:OLD.stud_crse_year_id,
                                              :NEW.session_code,
                                              :NEW.crse_year_no,
                                              :NEW.inst_code,
                                              :NEW.crse_id
                                             );
      END IF;

      /* check if a calculation has just been performed */
      IF NVL (:OLD.auto_calc_date, v_default_date) <>
                                     NVL (:NEW.auto_calc_date, v_default_date)
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* set the application status to be calculated */
            v_result :=
               maintain_repository.record_app_status (:NEW.stud_ref_no,
                                                      'C',
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.auto_calc_date
                                                     );
         END IF;
      END IF;

      /* check if the award letter has just been sent */
      IF NVL (:NEW.sal_sent, 'Y') = 'Y' AND NVL (:OLD.sal_sent, 'Y') = 'N'
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* set the application status to be letter issued */
            v_result :=
               maintain_repository.record_app_status (:NEW.stud_ref_no,
                                                      'L',
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.sal_sent_date
                                                     );
         END IF;
      END IF;

      /* check if the slc status (file 2) has been updated to sent */
      /* RAM SIR7 16/03/2004 */
      IF (   (    NVL (:OLD.slc2_status, 'A') <> NVL (:NEW.slc2_status, 'A')
              AND NVL (:NEW.slc2_status, 'A') = 'S'
             )
          OR (    NVL (:OLD.slc2_sent, 'A') <> NVL (:NEW.slc2_sent, 'A')
              AND NVL (:NEW.slc2_sent, 'A') = 'Y'
              AND NVL (:NEW.slc2_status, 'A') = 'S'
             )
         )
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* set the application status to be slc data sent */
            v_result :=
               maintain_repository.record_app_status (:NEW.stud_ref_no,
                                                      'S',
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.slc2_sent_date
                                                     );
         END IF;
      END IF;

      /* TR 1537 - check if the latest_crse_ind has been updated to 'Y' */
      IF :OLD.latest_crse_ind = 'N' AND :NEW.latest_crse_ind = 'Y'
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* create a new record as previous one has been deleted */
            v_result :=
               maintain_repository.create_app_status (:NEW.stud_ref_no,
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.session_code,
                                                      :NEW.entered_date,
                                                      :NEW.auto_calc_date,
                                                      :NEW.sal_sent_date,
                                                      :NEW.slc2_sent_date
                                                     );
         END IF;
      END IF;
   END IF;

   p_column_name := 'SAL_SENT';
   p_old := :OLD.sal_sent;
   p_new := :NEW.sal_sent;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'APPLICATION_STATUS';
   p_old := :OLD.application_status;
   p_new := :NEW.application_status;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'INST_CHANGE';
   p_old := :OLD.inst_change;
   p_new := :NEW.inst_change;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PARENT_CONTRIB_EXEMPT';
   p_old := :OLD.parent_contrib_exempt;
   p_new := :NEW.parent_contrib_exempt;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'AWARD';
   p_old := :OLD.award;
   p_new := :NEW.award;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'START_DATE';
   p_old := TO_CHAR (:OLD.start_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.start_date, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'WITHDRAW_DATE';
   p_old := TO_CHAR (:OLD.withdraw_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.withdraw_date, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'VACATION';
   p_old := TO_CHAR (:OLD.vacation);
   p_new := TO_CHAR (:NEW.vacation);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CRSE_CHG';
   p_old := TO_CHAR (:OLD.crse_chg, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.crse_chg, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'STUDY_COUNTRY';
   p_old := TO_CHAR (:OLD.study_country);
   p_new := TO_CHAR (:NEW.study_country);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SNB_GRAD';
   p_old := :OLD.snb_grad;
   p_new := :NEW.snb_grad;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'AWARD_LETTER_DATE';
   p_old := :OLD.award_letter_date;
   p_new := :NEW.award_letter_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'AWARD_LETTER_NO';
   p_old := :OLD.award_letter_no;
   p_new := :NEW.award_letter_no;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'BATCH_RECALC';
   p_old := :OLD.batch_recalc;
   p_new := :NEW.batch_recalc;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DEARING';
   p_old := :OLD.dearing;
   p_new := :NEW.dearing;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'RESID_PAR_CONT';
   p_old := TO_CHAR (:OLD.resid_par_cont);
   p_new := TO_CHAR (:NEW.resid_par_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'RESID_SPOUSE_CONT';
   p_old := TO_CHAR (:OLD.resid_spouse_cont);
   p_new := TO_CHAR (:NEW.resid_spouse_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'RESID_STUD_CONT';
   p_old := TO_CHAR (:OLD.resid_stud_cont);
   p_new := TO_CHAR (:NEW.resid_stud_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PARENT_CONT';
   p_old := TO_CHAR (:OLD.parent_cont);
   p_new := TO_CHAR (:NEW.parent_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SPOUSE_CONT';
   p_old := TO_CHAR (:OLD.spouse_cont);
   p_new := TO_CHAR (:NEW.spouse_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'STUD_CONT';
   p_old := TO_CHAR (:OLD.stud_cont);
   p_new := TO_CHAR (:NEW.stud_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'RESID_TRAV_ALLOW';
   p_old := TO_CHAR (:OLD.resid_trav_allow);
   p_new := TO_CHAR (:NEW.resid_trav_allow);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SML_EQUIP_RQST';
   p_old := TO_CHAR (:OLD.sml_equip_rqst);
   p_new := TO_CHAR (:NEW.sml_equip_rqst);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SML_EQUIP_APPROVE';
   p_old := TO_CHAR (:OLD.sml_equip_approve);
   p_new := TO_CHAR (:NEW.sml_equip_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LGE_EQUIP_DESCRIPT';
   p_old := TO_CHAR (:OLD.lge_equip_descript);
   p_new := TO_CHAR (:NEW.lge_equip_descript);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LGE_EQUIP_APPROVE';
   p_old := TO_CHAR (:OLD.lge_equip_approve);
   p_new := TO_CHAR (:NEW.lge_equip_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LGE_EQUIP_RQST';
   p_old := TO_CHAR (:OLD.lge_equip_rqst);
   p_new := TO_CHAR (:NEW.lge_equip_rqst);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DIET_NEED_DESCRIPT';
   p_old := TO_CHAR (:OLD.diet_need_descript);
   p_new := TO_CHAR (:NEW.diet_need_descript);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DISABLEMENT_CODE';
   p_old := TO_CHAR (:OLD.disablement_code);
   p_new := TO_CHAR (:NEW.disablement_code);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'END_DATE_ABROAD';
   p_old := :OLD.end_date_abroad;
   p_new := :NEW.end_date_abroad;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'ERASMUS';
   p_old := :OLD.erasmus;
   p_new := :NEW.erasmus;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DIET_NEED_REQ';
   p_old := TO_CHAR (:OLD.diet_need_req);
   p_new := TO_CHAR (:NEW.diet_need_req);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DIET_NEED_APPROVE';
   p_old := TO_CHAR (:OLD.diet_need_approve);
   p_new := TO_CHAR (:NEW.diet_need_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'NON_MED_REQ';
   p_old := TO_CHAR (:OLD.non_med_req);
   p_new := TO_CHAR (:NEW.non_med_req);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'NON_MED_APPROVE';
   p_old := TO_CHAR (:OLD.non_med_approve);
   p_new := TO_CHAR (:NEW.non_med_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PROVISIONAL_CASE';
   p_old := :OLD.provisional_case;
   p_new := :NEW.provisional_case;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PROVISIONAL_DATE';
   p_old := :OLD.provisional_date;
   p_new := :NEW.provisional_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'REPEAT_YEAR';
   p_old := :OLD.repeat_year;
   p_new := :NEW.repeat_year;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'REQ_DUP';
   p_old := :OLD.req_dup;
   p_new := :NEW.req_dup;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SESSION_CODE';
   p_old := :OLD.session_code;
   p_new := :NEW.session_code;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CRSE_YEAR_NO';
   p_old := :OLD.crse_year_no;
   p_new := :NEW.crse_year_no;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'INST_CODE';
   p_old := :OLD.inst_code;
   p_new := :NEW.inst_code;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CRSE_ID';
   p_old := :OLD.crse_id;
   p_new := :NEW.crse_id;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'UNCONDITIONAL';
   p_old := :OLD.unconditional;
   p_new := :NEW.unconditional;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SLC1_STATUS';
   p_old := :OLD.slc1_status;
   p_new := :NEW.slc1_status;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SLC2_STATUS';
   p_old := :OLD.slc2_status;
   p_new := :NEW.slc2_status;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LOAN_GIVEN';
   p_old := :OLD.loan_given;
   p_new := :NEW.loan_given;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LATEST_CRSE_IND';
   p_old := :OLD.latest_crse_ind;
   p_new := :NEW.latest_crse_ind;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'AUTO_CALC_DATE';
   p_old := :OLD.auto_calc_date;
   p_new := :NEW.auto_calc_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   -- RFC 112 addition
   --
   p_column_name := 'DSA_FEE_DESCRIPT';
   p_old := :OLD.dsa_fee_descript;
   p_new := :NEW.dsa_fee_descript;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DSA_FEE_RQST';
   p_old := :OLD.dsa_fee_rqst;
   p_new := :NEW.dsa_fee_rqst;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'DSA_FEE_APPROVE';
   p_old := :OLD.dsa_fee_approve;
   p_new := :NEW.dsa_fee_approve;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   -- END OF RFC 112 addition
   --
   -- RFC 113b Janis 28/06/04
   --
   p_column_name := 'ATTEND_REQD';
   p_old := :OLD.attend_reqd;
   p_new := :NEW.attend_reqd;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   -- End rfc 113b
   --
   -- RFC 113c MT 05/07/04
   --
   p_column_name := 'ATTEND_CONFIRMED';
   p_old := :OLD.attend_confirmed;
   p_new := :NEW.attend_confirmed;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'HEI_DATE_ATTENDED';
   p_old := :OLD.hei_date_attended;
   p_new := :NEW.hei_date_attended;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'NON_ATT_ACTIONED';
   p_old := :OLD.non_att_actioned;
   p_new := :NEW.non_att_actioned;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'NON_ATT_ACTIONED_DATE';
   p_old := :OLD.non_att_actioned_date;
   p_new := :NEW.non_att_actioned_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'TRAV_SUBMITTED_DATE';
   p_old := :OLD.trav_submitted_date;
   p_new := :NEW.trav_submitted_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SAL_SENT_DATE';
   p_old := :OLD.sal_sent_date;
   p_new := :NEW.sal_sent_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'SAL_DEST';
   p_old := :OLD.sal_dest;
   p_new := :NEW.sal_dest;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
--- RFC188
   p_column_name := 'VARIABLE_FEE_OVERRIDE_AMOUNT';
   p_old := :OLD.variable_fee_override_amount;
   p_new := :NEW.variable_fee_override_amount;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'FEE_LOAN_GIVEN';
   p_old := :OLD.fee_loan_given;
   p_new := :NEW.fee_loan_given;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'FEE_LOAN_ELIGIBILITY_ONLY';
   p_old := :OLD.fee_loan_eligibility_only;
   p_new := :NEW.fee_loan_eligibility_only;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'PGCE';
   p_old := :OLD.pgce;
   p_new := :NEW.pgce;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'SELF_FUNDING';
   p_old := :OLD.self_funding;
   p_new := :NEW.self_funding;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'INDEPENDENT';
   p_old := :OLD.independent;
   p_new := :NEW.independent;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   --
   p_column_name := 'DUE_YSB_YSO_IND';
   p_old := :OLD.due_ysb_yso_ind;
   p_new := :NEW.due_ysb_yso_ind;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
--END OF RFC188
-- RFC204
   p_column_name := 'HOUSEHOLD_RESID_INCOME';
   p_old := :OLD.household_resid_income;
   p_new := :NEW.household_resid_income;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'BEN1_TOTAL_INCOME';
   p_old := :OLD.ben1_total_income;
   p_new := :NEW.ben1_total_income;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'BEN2_TOTAL_INCOME';
   p_old := :OLD.ben2_total_income;
   p_new := :NEW.ben2_total_income;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
-- RFC204

   --RFC 222
   p_column_name := 'SNB_SINGLE_RATE';
   p_old := :OLD.snb_single_rate;
   p_new := :NEW.snb_single_rate;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
--RFC 222
   p_column_name := 'NMSB_SESSION_CALC';
   p_old := :OLD.nmsb_session_calc;
   p_new := :NEW.nmsb_session_calc;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'START_DATE_ABROAD';
   p_old := TO_CHAR (:OLD.start_date_abroad, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.start_date_abroad, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'STUDY_ABROAD';
   p_old := :OLD.study_abroad;
   p_new := :NEW.study_abroad;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'UNPAID_SANDWICH';
   p_old := :OLD.unpaid_sandwich;
   p_new := :NEW.unpaid_sandwich;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PAID_SANDWICH';
   p_old := :OLD.paid_sandwich;
   p_new := :NEW.paid_sandwich;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_FEE';
   p_old := :OLD.calc_fee;
   p_new := :NEW.calc_fee;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_BURSARY';
   p_old := :OLD.calc_bursary;
   p_new := :NEW.calc_bursary;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_LOAN';
   p_old := :OLD.calc_loan;
   p_new := :NEW.calc_loan;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_DEP_GRANT';
   p_old := :OLD.calc_dep_grant;
   p_new := :NEW.calc_dep_grant;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_LPG';
   p_old := :OLD.calc_lpg;
   p_new := :NEW.calc_lpg;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CALC_LPCG';
   p_old := :OLD.calc_lpcg;
   p_new := :NEW.calc_lpcg;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PAY_YSB';
   p_old := :OLD.pay_ysb;
   p_new := :NEW.pay_ysb;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PGCE_EDU_LEVEL';
   p_old := :OLD.pgce_edu_level;
   p_new := :NEW.pgce_edu_level;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PGCE_SUBJECT';
   p_old := :OLD.pgce_subject;
   p_new := :NEW.pgce_subject;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'FIRST_CALC_DATE';
   p_old := :OLD.first_calc_date;
   p_new := :NEW.first_calc_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'PSAS_PT';
   p_old := :OLD.psas_pt;
   p_new := :NEW.psas_pt;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'CRSE_SUSPEND';
   p_old := :OLD.crse_suspend;
   p_new := :NEW.crse_suspend;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
                              p_column_name,
                              p_table_pkey1,
                              p_table_pkey2,
                              p_table_pkey3,
                              p_table_pkey4,
                              p_table_pkey5,
                              p_old,
                              p_new,
                              p_action,
                              p_username,
                              p_stud_ref_no,
                              p_inst_code,
                              p_session_code
                             );
    --
/* Telephony Auditing PB Feb 2005*/
    --
   p_column_name := 'DATE_LAST_CALCULATED';
   p_old := :OLD.auto_calc_date;
   p_new := :NEW.auto_calc_date;

   IF NVL (:OLD.auto_calc_date, '01/JAN/1900') <>
                                      NVL (:NEW.auto_calc_date, '01/JAN/1900')
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'DATE_LAST_AWARD_LETTER_ISSUED';
   p_old := :OLD.sal_sent_date;
   p_new := :NEW.sal_sent_date;

   IF NVL (:OLD.sal_sent_date, '01/JAN/1900') <>
                                       NVL (:NEW.sal_sent_date, '01/JAN/1900')
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'SAL_DEST';
   p_old := :OLD.sal_dest;
   p_new := :NEW.sal_dest;

   IF NVL (:OLD.sal_dest, 'X') <> NVL (:NEW.sal_dest, 'X')
   THEN
      v_updated := 'Y';
   END IF;

   --
   IF v_updated = 'Y'
   THEN
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   END IF;
END stcy_iud;
show errors;

CREATE OR REPLACE TRIGGER SGAS.aw_iud
   AFTER INSERT OR DELETE OR UPDATE OF non_tuition_fee_id,
                                       amount,
                                       net_amount,
                                       contrib_amount,
                                       recovered_amount,
                                       travel_award_type,
                                       unclaimed_fee_loan,
                                       award_type_descript,
                                       last_updated_by
   ON SGAS.AWARD    FOR EACH ROW
DECLARE
   p_aud_date            DATE                           := SYSDATE;
   p_column_name         award_aud.column_name%TYPE     := NULL;
   p_table_pkey1         award_aud.table_pkey1%TYPE     := :OLD.award_id;
   p_table_pkey2         award_aud.table_pkey2%TYPE     := NULL;
   p_table_pkey3         award_aud.table_pkey3%TYPE     := NULL;
   p_table_pkey4         award_aud.table_pkey4%TYPE     := NULL;
   p_table_pkey5         award_aud.table_pkey5%TYPE     := NULL;
   p_old                 award_aud.OLD%TYPE             := NULL;
   p_new                 award_aud.NEW%TYPE             := NULL;
   p_action              award_aud.action%TYPE          := NULL;
   p_username            award_aud.username%TYPE        := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no         award_aud.stud_ref_no%TYPE     := NULL;
   p_inst_code           award_aud.inst_code%TYPE       := NULL;
   p_session_code        award_aud.session_code%TYPE    := NULL;
   p_stud_crse_year_id   award.stud_crse_year_id%TYPE
                                                    := :OLD.stud_crse_year_id;
   p_src                 award.award_src%TYPE           := :OLD.award_src;
   p_stud_award_type     award.stud_award_type%TYPE;
   v_temp                VARCHAR2 (1)                   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.award_id;
      p_stud_ref_no := :NEW.stud_ref_no;
      p_stud_crse_year_id := :NEW.stud_crse_year_id;
      p_src := :NEW.award_src;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.award_id;
      p_src := :OLD.award_src;
      p_username := :OLD.last_updated_by;
   END IF;
   
   
   SELECT session_code
     INTO p_session_code
     FROM stud_crse_year
    WHERE stud_crse_year_id = p_stud_crse_year_id;

      p_column_name := 'NON_TUITION_FEE_ID';
      p_old := TO_CHAR (:OLD.non_tuition_fee_id);
      p_new := TO_CHAR (:NEW.non_tuition_fee_id);
      pk_steps_aud.ins_aw_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_table_pkey3,
                               p_table_pkey4,
                               p_table_pkey5,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no,
                               p_inst_code,
                               p_session_code
                              );
      p_column_name := 'AMOUNT';
      p_old := TO_CHAR (:OLD.amount);
      p_new := TO_CHAR (:NEW.amount);
      pk_steps_aud.ins_aw_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_table_pkey3,
                               p_table_pkey4,
                               p_table_pkey5,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no,
                               p_inst_code,
                               p_session_code
                              );

      IF p_src = 'T'
      THEN
         pk_steps_changes.award_net_change (p_old, p_new, p_stud_crse_year_id);
      END IF;

      p_column_name := 'NET_AMOUNT';
      p_old := TO_CHAR (:OLD.net_amount);
      p_new := TO_CHAR (:NEW.net_amount);
      pk_steps_aud.ins_aw_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_table_pkey3,
                               p_table_pkey4,
                               p_table_pkey5,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no,
                               p_inst_code,
                               p_session_code
                              );

      IF p_src = 'T'
      THEN
         pk_steps_changes.award_net_change (p_old, p_new, p_stud_crse_year_id);
         pk_steps_changes.cslr_award (p_old, p_new, p_stud_crse_year_id);
      END IF;

      p_column_name := 'CONTRIB_AMOUNT';
      p_old := TO_CHAR (:OLD.contrib_amount);
      p_new := TO_CHAR (:NEW.contrib_amount);
      pk_steps_aud.ins_aw_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_table_pkey3,
                               p_table_pkey4,
                               p_table_pkey5,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no,
                               p_inst_code,
                               p_session_code
                              );

      IF p_src = 'T'
      THEN
         pk_steps_changes.award_contrib_change (p_old, p_new, p_stud_crse_year_id);
      END IF;

      p_column_name := 'RECOVERED_AMOUNT';
      p_old := TO_CHAR (:OLD.recovered_amount);
      p_new := TO_CHAR (:NEW.recovered_amount);
      pk_steps_aud.ins_aw_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_table_pkey3,
                               p_table_pkey4,
                               p_table_pkey5,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no,
                               p_inst_code,
                               p_session_code
                              );
      p_column_name := 'TRAVEL_AWARD_TYPE';
      p_old := TO_CHAR (:OLD.travel_award_type);
      p_new := TO_CHAR (:NEW.travel_award_type);
      p_stud_award_type := TO_CHAR (:OLD.stud_award_type);

      IF p_stud_award_type IN ('UGTE', 'UGLTE', 'PSTE', 'PSLTE')
      THEN
         pk_steps_aud.ins_aw_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_table_pkey2,
                                  p_table_pkey3,
                                  p_table_pkey4,
                                  p_table_pkey5,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username,
                                  p_stud_ref_no,
                                  p_inst_code,
                                  p_session_code
                                 );
      END IF;

      p_column_name := 'UNCLAIMED_FEE_LOAN';
      p_old := TO_CHAR (:OLD.unclaimed_fee_loan);
      p_new := TO_CHAR (:NEW.unclaimed_fee_loan);
      pk_steps_aud.ins_aw_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_table_pkey3,
                               p_table_pkey4,
                               p_table_pkey5,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no,
                               p_inst_code,
                               p_session_code
                              );
      p_column_name := 'AWARD_TYPE_DESCRIPT';
      p_old := :OLD.award_type_descript;
      p_new := :NEW.award_type_descript;
      pk_steps_aud.ins_aw_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_table_pkey3,
                               p_table_pkey4,
                               p_table_pkey5,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no,
                               p_inst_code,
                               p_session_code
                              );
      p_column_name := 'LAST_UPDATED_BY';
      p_old := :OLD.last_updated_by;
      p_new := :NEW.last_updated_by;
      pk_steps_aud.ins_aw_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_table_pkey3,
                               p_table_pkey4,
                               p_table_pkey5,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no,
                               p_inst_code,
                               p_session_code
                              );
EXCEPTION
   WHEN OTHERS
   THEN
      v_temp := 'N';
      
END aw_iud;
show errors;

/* Formatted on 2011/03/11 13:09 (Formatter Plus v4.8.8) */
CREATE OR REPLACE TRIGGER sgas.awi_iud
   AFTER INSERT OR DELETE OR UPDATE OF payment_due_date,
                                       payment_status,
                                       install_type,
                                       amount,
                                       method,
                                       payment_addr,
                                       returned,
                                       unclaimed_fee_loan,
                                       fee_loan_instalment,
                                       fee_loan_transaction_created,
                                       payee_reference,
                                       invoice_no,
                                       invoice_date,
                                       net_amount,
                                       contrib_amount,
                                       recovered_amount,
                                       last_updated_by
   ON sgas.award_instalment
   FOR EACH ROW
DECLARE
   p_aud_date         DATE                                     := SYSDATE;
   p_column_name      award_instalment_aud.column_name%TYPE    := NULL;
   p_table_pkey1      award_instalment_aud.table_pkey1%TYPE
                                                   := TO_CHAR (:OLD.award_id);
   p_table_pkey2      award_instalment_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3      award_instalment_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4      award_instalment_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5      award_instalment_aud.table_pkey5%TYPE    := NULL;
   p_old              award_instalment_aud.OLD%TYPE            := NULL;
   p_new              award_instalment_aud.NEW%TYPE            := NULL;
   p_action           award_instalment_aud.action%TYPE         := NULL;
   p_username         award_instalment_aud.username%TYPE
                                                      := :NEW.last_updated_by;
   p_stud_ref_no      award_instalment_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code        award_instalment_aud.inst_code%TYPE      := NULL;
   p_session_code     award_instalment_aud.session_code%TYPE   := NULL;
   result_trav_null   VARCHAR2 (2);
   unpaid_count       NUMBER (5);
   min_date           DATE;
   max_date           DATE;
   p_award_id         award.award_id%TYPE                    := :OLD.award_id;
   v_chngd            VARCHAR2 (1)                             := 'N';
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.award_id;
      p_award_id := :NEW.award_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.award_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'PAYMENT_DUE_DATE';
   p_old := TO_CHAR (:OLD.payment_due_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.payment_due_date, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'INSTALL_TYPE';
   p_old := :OLD.install_type;
   p_new := :NEW.install_type;
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'AMOUNT';
   p_old := TO_CHAR (:OLD.amount);
   p_new := TO_CHAR (:NEW.amount);
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'METHOD';
   p_old := :OLD.method;
   p_new := :NEW.method;
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'PAYMENT_ADDR';
   p_old := :OLD.payment_addr;
   p_new := :NEW.payment_addr;
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'PAYMENT_STATUS';
   p_old := :OLD.payment_status;
   p_new := :NEW.payment_status;
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'RETURNED';
   p_old := :OLD.returned;
   p_new := :NEW.returned;
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'UNCLAIMED_FEE_LOAN';
   p_old := :OLD.unclaimed_fee_loan;
   p_new := :NEW.unclaimed_fee_loan;
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'FEE_LOAN_INSTALMENT';
   p_old := :OLD.fee_loan_instalment;
   p_new := :NEW.fee_loan_instalment;
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'FEE_LOAN_TRANSACTION_CREATED';
   p_old := :OLD.fee_loan_transaction_created;
   p_new := :NEW.fee_loan_transaction_created;
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'PAYEE_REFERENCE';
   p_old := :OLD.payee_reference;
   p_new := :NEW.payee_reference;
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'INVOICE_NO';
   p_old := :OLD.invoice_no;
   p_new := :NEW.invoice_no;
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'INVOICE_DATE';
   p_old := :OLD.invoice_date;
   p_new := :NEW.invoice_date;
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'NET_AMOUNT';
   p_old := :OLD.net_amount;
   p_new := :NEW.net_amount;
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'CONTRIB_AMOUNT';
   p_old := :OLD.contrib_amount;
   p_new := :NEW.contrib_amount;
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'RECOVERED_AMOUNT';
   p_old := :OLD.recovered_amount;
   p_new := :NEW.recovered_amount;
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_awi_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );

   IF NVL (:OLD.payment_due_date, '01/JAN/1900') <>
                                    NVL (:NEW.payment_due_date, '01/JAN/1900')
   THEN
      v_chngd := 'Y';
   END IF;

   IF NVL (:OLD.net_amount, '0') <> NVL (:NEW.net_amount, '0')
   THEN
      v_chngd := 'Y';
   END IF;

   IF v_chngd = 'Y'
   THEN
      pk_steps_changes.cslr_awi (p_award_id);
   END IF;
END awi_iud;
show errors;