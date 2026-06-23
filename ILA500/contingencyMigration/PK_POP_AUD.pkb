CREATE OR REPLACE PACKAGE BODY pk_pop_aud
IS
-- DESCRIPTION
-- ===========
-- Package to insert records into the respective audit tables
-- on the ILA500 database if the audit columns are
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
   )
   AS
      pl_aud_id   adi_payment_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT adi_pay_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO adi_payment_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT adi_pay_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO adi_payment_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_adi_pay_aud;

   PROCEDURE ins_app_evid_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   application_evidence_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT app_evid_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO application_evidence_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT app_evid_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO application_evidence_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_app_evid_aud;
PROCEDURE ins_app_rej_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   application_rejection_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT app_rej_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO application_rejection_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT app_rej_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO application_rejection_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_app_rej_aud;
PROCEDURE ins_app_stat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   application_status_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT app_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO application_status_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT app_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO application_status_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_app_stat_aud;
PROCEDURE ins_bacs_run_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   bacs_run_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT bacs_run_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO bacs_run_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT bacs_run_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO bacs_run_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_bacs_run_aud;
PROCEDURE ins_case_note_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   caseworker_note_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT case_note_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO caseworker_note_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT case_note_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO caseworker_note_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_case_note_aud;
PROCEDURE ins_cou_lev_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   course_level_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT cou_lev_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO course_level_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT cou_lev_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO course_level_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_cou_lev_aud;
PROCEDURE ins_cou_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   course_type_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT cou_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO course_type_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT cou_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO course_type_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_cou_type_aud;
PROCEDURE ins_doc_reg_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   document_register_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT doc_reg_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO document_register_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT doc_reg_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO document_register_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_doc_reg_aud;
PROCEDURE ins_qa_data_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   ila500_qa_data_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT qa_data_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO ila500_qa_data_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT qa_data_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO ila500_qa_data_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_qa_data_aud;
PROCEDURE ins_rule_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   ila500_rule_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT rule_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO ila500_rule_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT rule_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO ila500_rule_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_rule_aud;
PROCEDURE ins_lea_app_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   learner_application_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT lea_app_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO learner_application_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT lea_app_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO learner_application_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_lea_app_aud;
PROCEDURE ins_lea_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   learner_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT lea_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO learner_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT lea_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO learner_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_lea_aud;
PROCEDURE ins_lea_dup_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   learner_duplicate_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT lea_dup_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO learner_duplicate_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT lea_dup_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO learner_duplicate_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_lea_dup_aud;
PROCEDURE ins_lea_pay_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   learner_payment_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT lea_pay_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO learner_payment_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT lea_pay_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO learner_payment_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_lea_pay_aud;
PROCEDURE ins_note_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   note_type_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT note_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO note_type_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT note_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO note_type_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_note_type_aud;
PROCEDURE ins_pay_stat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   payment_status_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT pay_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO payment_status_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT pay_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO payment_status_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_pay_stat_aud;
PROCEDURE ins_prov_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   provider_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT prov_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO provider_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT prov_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO provider_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_prov_aud;
PROCEDURE ins_prov_pay_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   provider_payment_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT prov_pay_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO provider_payment_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT prov_pay_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO provider_payment_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_prov_pay_aud;
PROCEDURE ins_prov_stat_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   provider_status_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT prov_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO provider_status_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT prov_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO provider_status_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_prov_stat_aud;
PROCEDURE ins_prov_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   provider_type_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT prov_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO provider_type_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT prov_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO provider_type_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_prov_type_aud;
PROCEDURE ins_rep_hist_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   report_history_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT rep_hist_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO report_history_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT rep_hist_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO report_history_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_rep_hist_aud;
PROCEDURE ins_shell_ltr_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   shell_letter_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT shell_ltr_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO shell_letter_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT shell_ltr_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO shell_letter_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_shell_ltr_aud;
PROCEDURE ins_title_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   title_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT title_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO title_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT title_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO title_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_title_aud;
PROCEDURE ins_trans_type_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   transaction_type_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT trans_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO transaction_type_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT trans_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO transaction_type_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_trans_type_aud;
PROCEDURE ins_config_data_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   ila500_config_data_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT config_data_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO ila500_config_data_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT config_data_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO ila500_config_data_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_config_data_aud;
  PROCEDURE ins_edm_images_aud (
      p_aud_date         DATE,
      p_column_name      VARCHAR2,
      p_primary_key      VARCHAR2,
      p_old              VARCHAR2,
      p_new              VARCHAR2,
      p_action           VARCHAR2,
      p_username   VARCHAR2
   )
   AS
      pl_aud_id   ila500_edm_images_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT edm_images_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO ila500_edm_images_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT edm_images_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO ila500_edm_images_aud
                     (aud_id, aud_date,column_name,
                      primary_key, OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name,
                      p_primary_key, p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_edm_images_aud;

-- Set the logging name on the respective audit table with the authenticated login name of the application user.
   PROCEDURE set_uid4audit_adi_pay_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE adi_payment_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_app_evid_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE application_evidence_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_app_rej_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE application_rejection_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_app_stat_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE application_status_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_bacs_run_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE bacs_run_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_case_note_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE caseworker_note_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_cou_lev_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE course_level_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_cou_type_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE course_type_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_doc_reg_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE document_register_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_qa_data_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE ila500_qa_data_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_rule_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE ila500_rule_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_lea_app_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE learner_application_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_lea_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE learner_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_lea_dup_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE learner_duplicate_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_lea_pay_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE learner_payment_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_note_type_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE note_type_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_pay_stat_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE payment_status_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_prov_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE provider_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_prov_pay_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE provider_payment_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_prov_stat_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE provider_status_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_prov_type_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE provider_type_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_rep_hist_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE report_history_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_shell_ltr_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE shell_letter_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_title_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE title_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_trans_type_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE transaction_type_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_config_data_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE ila500_config_data_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
      PROCEDURE set_uid4audit_edm_images_aud (
      p_user_id         VARCHAR2,
      p_primary_key   VARCHAR2
   )
   AS
   BEGIN
      UPDATE ila500_edm_images_aud
         SET username = p_user_id
         where primary_key = p_primary_key
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
END pk_pop_aud;
/