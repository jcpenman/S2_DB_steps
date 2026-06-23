CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_aud
IS
-- DESCRIPTION
-- ===========
-- Package to insert records into the respective audit tables
-- on the StEPS database if the audit columns are
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
-- 07.10.2008           A.Bowman    001    Initial Creation
-- 27.10.2008           A.Bowman    002    Added Phase 2 audit requirements
-- 13.01.2009           A.Bowman    003    Added payment table audit requirements
-- 02.02.2009           A.Bowman    004    Added payment error audit requirement
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
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   award_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT aw_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO award_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT aw_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO award_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_aw_aud;

   PROCEDURE ins_awi_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   award_instalment_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT awi_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO award_instalment_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT awi_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO award_instalment_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_awi_aud;

   PROCEDURE ins_bed_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   benefactor_dependant_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT bed_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO benefactor_dependant_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT bed_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO benefactor_dependant_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_bed_aud;

   PROCEDURE ins_bei_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   benefactor_income_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT bei_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO benefactor_income_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT bei_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO benefactor_income_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_bei_aud;

   PROCEDURE ins_ben_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   benefactor_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT ben_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO benefactor_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT ben_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO benefactor_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_ben_aud;

   PROCEDURE ins_cn_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   country_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT cn_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO country_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT cn_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO country_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_cn_aud;

   PROCEDURE ins_jac_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   ja_case_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT jac_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO ja_case_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT jac_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO ja_case_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_jac_aud;

   PROCEDURE ins_sqd_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   steps_qa_data_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT sqd_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO steps_qa_data_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT sqd_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO steps_qa_data_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_sqd_aud;

   PROCEDURE ins_st_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   stud_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT st_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT st_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_st_aud;

   PROCEDURE ins_stapp_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   stud_app_prog_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT stapp_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_app_prog_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT stapp_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_app_prog_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_stapp_aud;

   PROCEDURE ins_stcy_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   stud_crse_year_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT stcy_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_crse_year_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT stcy_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_crse_year_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_stcy_aud;

   PROCEDURE ins_std_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   stud_dependant_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT std_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_dependant_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT std_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_dependant_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_std_aud;

   PROCEDURE ins_sthome_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   stud_home_addr_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT sthome_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_home_addr_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT sthome_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_home_addr_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_sthome_aud;

   PROCEDURE ins_sts_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   stud_session_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT sts_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_session_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT sts_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_session_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_sts_aud;

   PROCEDURE ins_sc_bat_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   scoap_batches_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT sc_bat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO scoap_batches_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT sc_bat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO scoap_batches_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_sc_bat_aud;
   
   PROCEDURE ins_con_rel_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   contact_relationship_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT con_rel_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO contact_relationship_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT con_rel_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO contact_relationship_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_con_rel_aud;

   PROCEDURE ins_loc_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   location_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT loc_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO location_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT loc_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO location_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_loc_aud;

   PROCEDURE ins_pgce_sub_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   pgce_subject_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT pgce_sub_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO pgce_subject_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT pgce_sub_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO pgce_subject_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_pgce_sub_aud;

   PROCEDURE ins_pay_meth_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   payment_method_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT pay_meth_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO payment_method_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT pay_meth_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO payment_method_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_pay_meth_aud;

   PROCEDURE ins_aw_ref_dat_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   award_ref_data_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT aw_ref_dat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO award_ref_data_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT aw_ref_dat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO award_ref_data_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_aw_ref_dat_aud;

   PROCEDURE ins_sch_type_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   scheme_type_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT sch_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO scheme_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT sch_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO scheme_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_sch_type_aud;

   PROCEDURE ins_ben_inc_stat_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   ben_income_status_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT ben_inc_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO ben_income_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT ben_inc_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO ben_income_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_ben_inc_stat_aud;

   PROCEDURE ins_ben_inc_type_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   ben_income_type_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT ben_inc_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO ben_income_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT ben_inc_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO ben_income_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_ben_inc_type_aud;

   PROCEDURE ins_z_ref_stat_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   z_refusal_status_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT z_ref_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO z_refusal_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT z_ref_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO z_refusal_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_z_ref_stat_aud;

   PROCEDURE ins_dear_stat_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   dearing_status_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT dear_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dearing_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT dear_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dearing_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_dear_stat_aud;

   PROCEDURE ins_loan_stat_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   loan_status_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT loan_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO loan_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT loan_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO loan_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_loan_stat_aud;

   PROCEDURE ins_case_stat_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   case_status_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT case_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO case_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT case_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO case_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_case_stat_aud;

   PROCEDURE ins_debt_stat_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   debt_status_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT debt_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO debt_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT debt_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO debt_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_debt_stat_aud;

   PROCEDURE ins_dis_type_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   disability_type_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT dis_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO disability_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT dis_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO disability_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_dis_type_aud;

   PROCEDURE ins_spo_type_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   spouse_type_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT spo_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO spouse_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT spo_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO spouse_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_spo_type_aud;   
   
   PROCEDURE ins_emp_stat_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   employment_status_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT emp_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO employment_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT emp_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO employment_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_emp_stat_aud;

   PROCEDURE ins_mar_stat_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   marital_status_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT mar_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO marital_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT mar_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO marital_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_mar_stat_aud;

   PROCEDURE ins_title_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
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
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT title_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO title_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_title_aud;

   PROCEDURE ins_res_type_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   residence_type_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT res_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO residence_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT res_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO residence_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_res_type_aud;

   PROCEDURE ins_joi_app_rel_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   joint_app_relation_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT joint_app_rel_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO joint_app_relation_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT joint_app_rel_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO joint_app_relation_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_joi_app_rel_aud;

   PROCEDURE ins_sup_gra_rel_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   supp_grant_relation_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT sup_grant_rel_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO supp_grant_relation_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT sup_grant_rel_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO supp_grant_relation_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_sup_gra_rel_aud;

   PROCEDURE ins_ben_rel_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   benefactor_relation_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT ben_rel_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO benefactor_relation_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT ben_rel_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO benefactor_relation_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_ben_rel_aud;

   PROCEDURE ins_oth_loa_type_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   other_loan_type_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT oth_loa_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO other_loan_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT oth_loa_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO other_loan_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_oth_loa_type_aud;
   
   PROCEDURE ins_fee_loa_type_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   fee_loan_type_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT fee_loa_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO fee_loan_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT fee_loa_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO fee_loan_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_fee_loa_type_aud;
   
   PROCEDURE ins_auth_stud_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   authenticate_stud_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT auth_stud_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO authenticate_stud_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT auth_stud_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO authenticate_stud_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_auth_stud_aud;

   PROCEDURE ins_sta_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   stud_term_addr_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT stterm_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_term_addr_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT stterm_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_term_addr_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_sta_aud;
   
   PROCEDURE ins_no_nino_rea_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   no_nino_reason_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT no_nino_reason_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO no_nino_reason_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT no_nino_reason_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO no_nino_reason_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_no_nino_rea_aud;

   PROCEDURE ins_dup_bank_rea_aud (
      p_aud_date       DATE,
      p_column_name    VARCHAR2,
      p_table_pkey1    VARCHAR2,
      p_table_pkey2    VARCHAR2,
      p_table_pkey3    VARCHAR2,
      p_table_pkey4    VARCHAR2,
      p_table_pkey5    VARCHAR2,
      p_old            VARCHAR2,
      p_new            VARCHAR2,
      p_action         VARCHAR2,
      p_username       VARCHAR2,
      p_stud_ref_no    VARCHAR2,
      p_inst_code      VARCHAR2,
      p_session_code   VARCHAR2
   )
   AS
      pl_aud_id   dup_bank_reason_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT dup_bank_reason_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dup_bank_reason_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT dup_bank_reason_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dup_bank_reason_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_dup_bank_rea_aud;

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
   )
   AS
      pl_aud_id   nominee_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT nominee_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO nominee_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT nominee_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO nominee_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_nom_aud;   

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
   )
   AS
      pl_aud_id   stud_nominee_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT stud_nominee_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_nominee_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT stud_nominee_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO stud_nominee_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_stud_nom_aud;

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
   )
   AS
      pl_aud_id   dsa_type_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT dsa_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT dsa_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_dsa_type_aud;

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
   )
   AS
      pl_aud_id   dsa_category_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT dsa_category_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_category_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT dsa_category_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_category_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_dsa_cat_aud;

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
   )
   AS
      pl_aud_id   dsa_referral_reason_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT dsa_ref_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_referral_reason_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT dsa_ref_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_referral_reason_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_dsa_ref_aud;

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
   )
   AS
      pl_aud_id   dsa_rejection_reason_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT dsa_rej_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_rejection_reason_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT dsa_rej_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_rejection_reason_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_dsa_rej_aud;

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
   )
   AS
      pl_aud_id   dsa_assessment_centre_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT dsa_ac_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_assessment_centre_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT dsa_ac_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_assessment_centre_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_dsa_ac_aud;

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
   )
   AS
      pl_aud_id   dsa_payment_status_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT dsa_pay_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_payment_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT dsa_pay_stat_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_payment_status_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_dsa_pay_stat_aud;

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
   )
   AS
      pl_aud_id   dsa_student_type_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT dsa_stud_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_student_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT dsa_stud_type_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_student_type_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_dsa_stud_type_aud;

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
   )
   AS
      pl_aud_id   dsa_application_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT dsa_app_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_application_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT dsa_app_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_application_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_dsa_app_aud;

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
   )
   AS
      pl_aud_id   dsa_allowance_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT dsa_all_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_allowance_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT dsa_all_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_allowance_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_dsa_all_aud;

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
   )
   AS
      pl_aud_id   dsa_payment_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT dsa_pay_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_payment_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT dsa_pay_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO dsa_payment_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_dsa_pay_aud;

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
   )
   AS
      pl_aud_id   payee_payment_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT pay_paymt_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO payee_payment_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT pay_paymt_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO payee_payment_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_pay_paymt_aud;

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
   )
   AS
      pl_aud_id   finance_reversal_journal_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT fin_rev_jou_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO finance_reversal_journal_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT fin_rev_jou_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO finance_reversal_journal_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_fin_rev_jou_aud;

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
   )
   AS
      pl_aud_id   payee_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT pay_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO payee_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT pay_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO payee_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_pay_aud;

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
   )
   AS
      pl_aud_id   adi_journal_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT adi_jou_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO adi_journal_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT adi_jou_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO adi_journal_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_adi_jou_aud;

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
   )
   AS
      pl_aud_id   payment_errors_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT pay_err_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO payment_errors_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT pay_err_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO payment_errors_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_pay_err_aud;

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
   )
   AS
      pl_aud_id   payment_instalment_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT pay_inst_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO payment_instalment_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT pay_inst_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO payment_instalment_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_pay_inst_aud;

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
   )
   AS
      pl_aud_id   non_award_payment_date_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT napd_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO non_award_payment_date_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT napd_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO non_award_payment_date_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_napd_aud;
   
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
   )
   AS
      pl_aud_id   fee_payment_date_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT fpd_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO fee_payment_date_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT fpd_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO fee_payment_date_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_fpd_aud;
   
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
   )
   AS
      pl_aud_id   residence_aud.aud_id%TYPE;    
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT res_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO residence_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT res_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO residence_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      table_pkey2, table_pkey3, table_pkey4,
                      table_pkey5, OLD, NEW, action, username,
                      stud_ref_no, inst_code, session_code
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_table_pkey2, p_table_pkey3, p_table_pkey4,
                      p_table_pkey5, p_old, p_new, p_action, p_username,
                      p_stud_ref_no, p_inst_code, p_session_code
                     );
      END IF;
   END ins_res_aud;

-- Set the logging name on the respective audit table with the authenticated login name of the application user.

   PROCEDURE set_uid4audit_aw_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE award_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_awi_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE award_instalment_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_bed_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE benefactor_dependant_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_bei_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE benefactor_income_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_ben_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE benefactor_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_cn_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE country_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_jac_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE ja_case_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_sqd_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE steps_qa_data_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_st_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE stud_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_stapp_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_app_prog_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_stcy_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE stud_crse_year_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_std_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE stud_dependant_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_sthome_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_home_addr_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_sts_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE stud_session_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_sc_bat_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE scoap_batches_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_con_rel_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE contact_relationship_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_loc_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE location_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_pgce_sub_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE pgce_subject_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   
   PROCEDURE set_uid4audit_pay_meth_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE payment_method_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_aw_ref_dat_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE award_ref_data_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_sch_type_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE scheme_type_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_ben_inc_stat_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE ben_income_status_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_ben_inc_type_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE ben_income_type_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_z_ref_stat_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE z_refusal_status_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dear_stat_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE dearing_status_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_loan_stat_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE loan_status_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_case_stat_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE case_status_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_debt_stat_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE debt_status_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dis_type_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE disability_type_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_spo_type_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE spouse_type_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_emp_stat_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE employment_status_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;      

   PROCEDURE set_uid4audit_mar_stat_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE marital_status_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_title_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE title_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_res_type_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE residence_type_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   
   PROCEDURE set_uid4audit_joi_app_rel_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE joint_app_relation_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_sup_gra_rel_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE supp_grant_relation_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_ben_rel_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE benefactor_relation_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_oth_loa_type_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE other_loan_type_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_fee_loa_type_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE fee_loan_type_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_auth_stud_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE authenticate_stud_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_no_nino_rea_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE no_nino_reason_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dup_bank_rea_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE dup_bank_reason_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   
   PROCEDURE set_uid4audit_sta_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE stud_term_addr_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_nom_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE nominee_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   
   PROCEDURE set_uid4audit_stud_nom_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE stud_nominee_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dsa_type_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE dsa_type_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dsa_cat_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE dsa_category_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dsa_ref_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE dsa_referral_reason_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dsa_rej_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE dsa_rejection_reason_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dsa_ac_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE dsa_assessment_centre_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dsa_pay_stat_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE dsa_payment_status_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dsa_st_type_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE dsa_student_type_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dsa_app_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE dsa_application_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dsa_all_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE dsa_allowance_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dsa_pay_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE dsa_payment_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_pay_paymt_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE payee_payment_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_fin_rev_jou_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE finance_reversal_journal_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_pay_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE payee_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_adi_jou_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE adi_journal_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_pay_err_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE payment_errors_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_pay_inst_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE payment_instalment_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_fpd_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE fee_payment_date_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_napd_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE non_award_payment_date_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;
   PROCEDURE set_uid4audit_res_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2)
   AS
   BEGIN
      UPDATE residence_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

END pk_steps_aud;
/
