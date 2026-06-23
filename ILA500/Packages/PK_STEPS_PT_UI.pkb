/* Formatted on 2011/06/13 10:33 (Formatter Plus v4.8.8) */
-- DESCRIPTION
-- ============
-- Package to read, write, insert and delete records
-- from the ILA500 database via the user interface
--
-- Modification History
-- Date                 Author       Ref    Desc
-- 07.07.2008           N Pickard    001    Initial Creation
--                      P Grace
--                      M Tolmie
-- 07/04/2009           A Anchev     391    SetQAUser procedure changed to zero the
--                                          user statistics when QA level changed.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision:  $
--

CREATE OR REPLACE PACKAGE BODY ila500.pk_steps_pt_ui
AS
   CURSOR alfp_cursor (provider_id_in IN VARCHAR2)
   IS
      SELECT la.learner_id ID, l.forename || ' ' || l.surname NAME
        FROM learner_application la, learner l
       WHERE la.provider_id = provider_id_in
         AND la.learner_id = l.learner_id
         AND session_year = (SELECT cval
                               FROM ila500_config_data
                              WHERE item_name = 'CURRENT_SESSION');

   FUNCTION getcursorrowcount (provider_id_in IN VARCHAR2)
      RETURN VARCHAR2
   IS
      ID                VARCHAR2 (20);
      NAME              VARCHAR2 (100);
      cursor_rowcount   VARCHAR2 (5);
   BEGIN
      OPEN alfp_cursor (provider_id_in);

      LOOP
         FETCH alfp_cursor
          INTO ID, NAME;

         EXIT WHEN alfp_cursor%NOTFOUND;
         cursor_rowcount := alfp_cursor%ROWCOUNT;
      END LOOP;

      IF cursor_rowcount IS NULL
      THEN
         cursor_rowcount := '0';
      END IF;

      CLOSE alfp_cursor;

      RETURN cursor_rowcount;
   END getcursorrowcount;

   PROCEDURE getsession (
      learner_application_id_in   IN              VARCHAR2,
      session_code_out            OUT NOCOPY      NUMBER
   )
   IS
   BEGIN
      SELECT la.session_year
        INTO session_code_out
        FROM learner_application la
       WHERE la.learner_application_id = learner_application_id_in;
   END getsession;

   PROCEDURE getgeneratedref (generated_ref_out OUT NOCOPY NUMBER)
   IS
   BEGIN
      SELECT ila500.learner_ref_seq.NEXTVAL
        INTO generated_ref_out
        FROM DUAL;
   END getgeneratedref;

   PROCEDURE getlatestapplication (
      learner_id_in                IN              VARCHAR2,
      learner_application_id_out   OUT NOCOPY      NUMBER
   )
   IS
   BEGIN
      SELECT MAX (learner_application_id)
        INTO learner_application_id_out
        FROM learner_application
       WHERE learner_id = learner_id_in;
   END getlatestapplication;

   PROCEDURE shell_letter_config (
      shell_path_out                OUT NOCOPY   VARCHAR2,
      shell_type_out                OUT NOCOPY   VARCHAR2,
      shell_client_target_dir_out   OUT NOCOPY   VARCHAR2,
      shell_server_target_dir_out   OUT NOCOPY   VARCHAR2,
      error_boolean                 OUT NOCOPY   VARCHAR2,
      ERROR_TEXT                    OUT NOCOPY   VARCHAR2
   )
   IS
   BEGIN
      SELECT iv1.c1, iv2.c2, iv3.c3,
             iv4.c4
        INTO shell_path_out, shell_type_out, shell_client_target_dir_out,
             shell_server_target_dir_out
        FROM (SELECT cval c1
                FROM ila500_config_data
               WHERE UPPER (item_name) = 'SHELL_PATH') iv1,
             (SELECT cval c2
                FROM ila500_config_data
               WHERE UPPER (item_name) = 'SHELL_TYPE') iv2,
             (SELECT cval c3
                FROM ila500_config_data
               WHERE UPPER (item_name) = 'SHELL_CLIENT_TARGET_DIR') iv3,
             (SELECT cval c4
                FROM ila500_config_data
               WHERE UPPER (item_name) = 'SHELL_SERVER_TARGET_DIR') iv4;

      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END shell_letter_config;

   PROCEDURE shellletters (
      io_cursor       IN OUT          shellletters_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   IS
      sl_cursor   shellletters_cursor;
   BEGIN
      OPEN sl_cursor FOR
         SELECT sl.doc_id, sl.doc_name, sl.doc_desc
           FROM shell_letter sl;

      error_boolean := 'false';
      io_cursor := sl_cursor;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END shellletters;

   PROCEDURE getlearneraddr (
      learner_id_in       IN              VARCHAR2,
      title_out           OUT NOCOPY      VARCHAR2,
      forename_out        OUT NOCOPY      VARCHAR2,
      surname_out         OUT NOCOPY      VARCHAR2,
      housename_no_out    OUT NOCOPY      VARCHAR2,
      address_line1_out   OUT NOCOPY      VARCHAR2,
      address_line2_out   OUT NOCOPY      VARCHAR2,
      address_line3_out   OUT NOCOPY      VARCHAR2,
      address_line4_out   OUT NOCOPY      VARCHAR2,
      postcode_out        OUT NOCOPY      VARCHAR2,
      mailsort_out        OUT NOCOPY      VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   )
   IS
      title_id_temp   NUMBER;
      title_temp      VARCHAR2 (15);
   BEGIN
      IF learner_id_in IS NOT NULL
      THEN
         SELECT l.title_id, l.forename, l.surname, l.housename_no,
                l.address_line1, l.address_line2, l.address_line3,
                l.address_line4, l.postcode, l.addr_mail_sort
           INTO title_id_temp, forename_out, surname_out, housename_no_out,
                address_line1_out, address_line2_out, address_line3_out,
                address_line4_out, postcode_out, mailsort_out
           FROM learner l
          WHERE UPPER (learner_id) = UPPER (learner_id_in);

         IF title_id_temp IS NOT NULL
         THEN
            SELECT description
              INTO title_temp
              FROM title
             WHERE title_id = title_id_temp;
         END IF;

         IF title_temp = 'OTHER'
         THEN
            SELECT l.other_title
              INTO title_temp
              FROM learner l
             WHERE UPPER (learner_id) = UPPER (learner_id_in);
         END IF;

         title_out := title_temp;
         error_boolean := 'false';
      ELSE
         error_boolean := 'true';
         ERROR_TEXT :=
                     'No Learner Id has been passed to getLearnerAddr PL/SQL';
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'There is no Learner Address Data for this Learner';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getlearneraddr;

   PROCEDURE getcourseinfo (
      learner_application_id_in   IN              NUMBER,
      learning_provider_out       OUT NOCOPY      VARCHAR2,
      course_out                  OUT NOCOPY      VARCHAR2,
      course_level_out            OUT NOCOPY      VARCHAR2,
      session_out                 OUT NOCOPY      VARCHAR2,
      error_boolean               OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT p.provider_name, la.course_title, cl.course_level_desc,
             la.session_year
        INTO learning_provider_out, course_out, course_level_out,
             session_out
        FROM learner_application la, provider p, course_level cl
       WHERE la.learner_application_id = learner_application_id_in
         AND la.provider_id = p.provider_id
         AND cl.course_id = la.course_id;

      error_boolean := 'false';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            'This is only a skeleton record. Full details of the application for this Learner will be shown when the application is scanned onto the system and full details have been registered';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getcourseinfo;

   PROCEDURE getincomeinfo (
      learner_application_id_in      IN              NUMBER,
      no_income_evid_id_out          OUT NOCOPY      VARCHAR2,
      jsa_evid_id_out                OUT NOCOPY      VARCHAR2,
      inc_sup_evid_id_out            OUT NOCOPY      VARCHAR2,
      inc_ben_evid_id_out            OUT NOCOPY      VARCHAR2,
      carers_allowance_evid_id_out   OUT NOCOPY      VARCHAR2,
      pension_credit_evid_id_out     OUT NOCOPY      VARCHAR2,
      max_child_tc_evid_id_out       OUT NOCOPY      VARCHAR2,
      error_boolean                  OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                     OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT NVL (la.no_income_evid_id, 'N'), NVL (la.jsa_evid_id, 'N'),
             NVL (la.inc_sup_evid_id, 'N'), NVL (la.inc_ben_evid_id, 'N'),
             NVL (la.carers_allowance_evid_id, 'N'),
             NVL (la.pension_credit_evid_id, 'N'),
             NVL (la.max_child_tax_credit_evid_id, 'N')
        INTO no_income_evid_id_out, jsa_evid_id_out,
             inc_sup_evid_id_out, inc_ben_evid_id_out,
             carers_allowance_evid_id_out,
             pension_credit_evid_id_out,
             max_child_tc_evid_id_out
        FROM learner_application la
       WHERE la.learner_application_id = learner_application_id_in;

      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getincomeinfo;

   PROCEDURE getsummary (
      learner_id_in               IN              VARCHAR2,
      title_out                   OUT NOCOPY      VARCHAR2,
      forename_out                OUT NOCOPY      VARCHAR2,
      surname_out                 OUT NOCOPY      VARCHAR2,
      dob_out                     OUT NOCOPY      VARCHAR2,
      gender_out                  OUT NOCOPY      VARCHAR2,
      housename_no_out            OUT NOCOPY      VARCHAR2,
      address_line1_out           OUT NOCOPY      VARCHAR2,
      address_line2_out           OUT NOCOPY      VARCHAR2,
      address_line3_out           OUT NOCOPY      VARCHAR2,
      address_line4_out           OUT NOCOPY      VARCHAR2,
      postcode_out                OUT NOCOPY      VARCHAR2,
      tele_no_out                 OUT NOCOPY      VARCHAR2,
      email_addr_out              OUT NOCOPY      VARCHAR2,
      status_out                  OUT NOCOPY      VARCHAR2,
      provider_out                OUT NOCOPY      VARCHAR2,
      course_out                  OUT NOCOPY      VARCHAR2,
      course_level_out            OUT NOCOPY      VARCHAR2,
      course_start_date_out       OUT NOCOPY      VARCHAR2,
      last_letter_generated_out   OUT NOCOPY      VARCHAR2,
      error_boolean               OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY      VARCHAR2
   )
   IS
      temp_learner_application_id   NUMBER;
      temp_mailsort                 VARCHAR2 (20);
      temp_session                  NUMBER;
   BEGIN
      getlearneraddr (learner_id_in,
                      title_out,
                      forename_out,
                      surname_out,
                      housename_no_out,
                      address_line1_out,
                      address_line2_out,
                      address_line3_out,
                      address_line4_out,
                      postcode_out,
                      temp_mailsort,
                      error_boolean,
                      ERROR_TEXT
                     );

      SELECT l.email_address, TO_CHAR (TO_DATE (l.dob, 'DD-MON-YYYY')),
             DECODE (l.gender, 'M', 'Male', 'F', 'Female'), l.telephone_no
        INTO email_addr_out, dob_out,
             gender_out, tele_no_out
        FROM learner l
       WHERE UPPER (l.learner_id) = UPPER (learner_id_in);

      IF error_boolean = 'false'
      THEN
         getlatestapplication (learner_id_in, temp_learner_application_id);
         getcourseinfo (temp_learner_application_id,
                        provider_out,
                        course_out,
                        course_level_out,
                        temp_session,
                        error_boolean,
                        ERROR_TEXT
                       );

         SELECT TO_CHAR (TO_DATE (la.course_start_date, 'DD-MON-YYYY')),
                a_s.application_status_desc,
                TO_CHAR (TO_DATE (la.last_letter_generated, 'DD-MON-YYYY'))
           INTO course_start_date_out,
                status_out,
                last_letter_generated_out
           FROM learner_application la, application_status a_s
          WHERE la.learner_application_id = temp_learner_application_id
            AND a_s.application_status_id = la.application_status_id;
      ELSE
         ERROR_TEXT := ' getlearneraddr error -' || ERROR_TEXT;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || ' SQLCODE=' || SQLCODE || ' SQL ERROR = '
            || SQLERRM;
   END getsummary;

   PROCEDURE getcaseworkernotes (
      pk_in           IN              VARCHAR2,
      io_cursor       IN OUT          notes_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   IS
      n_cursor   notes_cursor;
   BEGIN
      OPEN n_cursor FOR
         SELECT nt.ROWID || cn.ROWID AS row_id, nt.description,
                TO_CHAR (TO_DATE (cn.note_date, 'DD-MM-YY')) AS note_date,
                cn.session_year, cn.note_text
           FROM caseworker_note cn, note_type nt
          WHERE cn.primary_key = pk_in AND nt.note_type_id = cn.note_type_id;

      io_cursor := n_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getcaseworkernotes;

   PROCEDURE getcoursetypes (
      session_year_in   IN              VARCHAR2,
      io_cursor         IN OUT          course_types_cursor,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   )
   IS
      ct_cursor   course_types_cursor;
   BEGIN
      OPEN ct_cursor FOR
         SELECT   ct.course_type_id, ct.bacs_payment_date,
                  ct.course_type_desc, ct.fee_cut_off_date,
                  ct.fee_period_start, ct.fee_period_end, ct.submitted_date,
                  ct.batch_run_date, ct.session_year, ct.last_updated_by,
                  TO_CHAR (TO_DATE (ct.last_updated_on, 'DD-MON-YYYY')
                          ) AS last_updated_on
             FROM course_type ct
            WHERE ct.session_year LIKE '%' || session_year_in || '%'
         ORDER BY ct.course_type_id DESC;

      error_boolean := 'false';
      io_cursor := ct_cursor;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getcoursetypes;

   PROCEDURE setcoursetype (
      course_type_id_in      IN              NUMBER,
      bacs_payment_date_in   IN              DATE,
      course_type_desc_in    IN              VARCHAR2,
      session_code_in        IN              VARCHAR2,
      fee_cut_off_date_in    IN              DATE,
      fee_period_start_in    IN              DATE,
      fee_period_end_in      IN              DATE,
      submitted_date_in      IN              DATE,
      batch_run_date_in      IN              DATE,
      last_updated_by_in     IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2,
      row_count              OUT             NUMBER
   )
   AS
   BEGIN
      UPDATE course_type ct
         SET ct.bacs_payment_date =
                              NVL (bacs_payment_date_in, ct.bacs_payment_date),
             ct.course_type_desc =
                        NVL (UPPER (course_type_desc_in), ct.course_type_desc),
             ct.session_year = NVL (session_code_in, ct.session_year),
             ct.fee_cut_off_date =
                                NVL (fee_cut_off_date_in, ct.fee_cut_off_date),
             ct.fee_period_start =
                                NVL (fee_period_start_in, ct.fee_period_start),
             ct.fee_period_end = NVL (fee_period_end_in, ct.fee_period_end),
             ct.submitted_date = NVL (submitted_date_in, ct.submitted_date),
             ct.batch_run_date = NVL (batch_run_date_in, ct.batch_run_date),
             ct.last_updated_by =
                          NVL (UPPER (last_updated_by_in), ct.last_updated_by),
             ct.last_updated_on = SYSDATE
       WHERE ct.course_type_id = course_type_id_in;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         row_count := 0;
   END setcoursetype;

   PROCEDURE getcourselevels (
      io_cursor       IN OUT          course_levels_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   IS
      cl_cursor   course_levels_cursor;
   BEGIN
      OPEN cl_cursor FOR
         SELECT   cl.course_id, cl.course_level_desc, cl.last_updated_by,
                  TO_CHAR
                         (TO_DATE (cl.last_updated_on,
                                   'DD-MM-YYYY HH12:MI:SS')
                         ) AS last_updated_on
             FROM course_level cl
            WHERE cl.course_id != 99
         ORDER BY cl.course_id DESC;

      error_boolean := 'false';
      io_cursor := cl_cursor;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getcourselevels;

   PROCEDURE setcourselevels (
      course_id_in           IN              NUMBER,
      last_updated_by_in     IN              VARCHAR2,
      course_level_desc_in   IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2,
      row_count              OUT             NUMBER
   )
   AS
   BEGIN
      UPDATE course_level cl
         SET cl.course_level_desc =
                      NVL (UPPER (course_level_desc_in), cl.course_level_desc),
             cl.last_updated_by =
                          NVL (UPPER (last_updated_by_in), cl.last_updated_by),
             cl.last_updated_on = SYSDATE
       WHERE cl.course_id = course_id_in;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         row_count := 0;
   END setcourselevels;

   PROCEDURE insertcourselevels (
      last_updated_by_in     IN              VARCHAR2,
      course_level_desc_in   IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2,
      row_count              OUT             NUMBER
   )
   AS
   BEGIN
      INSERT INTO course_level
                  (course_level_desc, last_updated_by,
                   last_updated_on
                  )
           VALUES (UPPER (course_level_desc_in), UPPER (last_updated_by_in),
                   SYSDATE
                  );

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         row_count := 0;
   END insertcourselevels;

   PROCEDURE getqausers (
      io_cursor       IN OUT          qausers_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   IS
      qa_cursor   qausers_cursor;
   BEGIN
      OPEN qa_cursor FOR
         SELECT   qa.username, qa.qa_type, qa.qa_level, qa.no_processed,
                  qa.no_qa, qa.no_fail_qa, qa.last_updated_by,
                  TO_CHAR
                         (TO_DATE (qa.last_updated_on,
                                   'DD-MM-YYYY HH12:MI:SS')
                         ) AS last_updated_on
             FROM ila500_qa_data qa
         ORDER BY qa.username DESC;

      error_boolean := 'false';
      io_cursor := qa_cursor;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getqausers;

   PROCEDURE setqauser (
      username_in          IN              VARCHAR2,
      last_updated_by_in   IN              VARCHAR2,
      qa_level_in          IN              NUMBER,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2,
      row_count            OUT             NUMBER
   )
   AS
   BEGIN
      UPDATE ila500_qa_data qa
         SET qa.qa_level = NVL (qa_level_in, qa.qa_level),
             qa.last_updated_by =
                          NVL (UPPER (last_updated_by_in), qa.last_updated_by),
             qa.last_updated_on = SYSDATE,
             qa.no_processed =
                         DECODE (qa.qa_level,
                                 qa_level_in, qa.no_processed,
                                 0
                                ),
             qa.no_qa = DECODE (qa.qa_level, qa_level_in, qa.no_qa, 0),
             qa.no_fail_qa =
                           DECODE (qa.qa_level,
                                   qa_level_in, qa.no_fail_qa,
                                   0
                                  )
       WHERE UPPER (qa.username) = UPPER (username_in);

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         row_count := 0;
   END setqauser;

   PROCEDURE getedmconfigdata (
      eistream_domain_name   OUT   VARCHAR2,
      edm_client_path        OUT   VARCHAR2,
      edm_server_path        OUT   VARCHAR2,
      error_boolean          OUT   VARCHAR2,
      ERROR_TEXT             OUT   VARCHAR2
   )
   IS
   BEGIN
      SELECT c1, c2, c3
        INTO eistream_domain_name, edm_client_path, edm_server_path
        FROM (SELECT cval c1
                FROM ila500_config_data
               WHERE item_name = 'EISTREAM_DOMAIN_NAME'),
             (SELECT cval c2
                FROM ila500_config_data
               WHERE item_name = 'EDM_CLIENT_TARGET_DIR'),
             (SELECT cval c3
                FROM ila500_config_data
               WHERE item_name = 'SHELL_SERVER_TARGET_DIR');

      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getedmconfigdata @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getedmconfigdata;

   PROCEDURE edm (
      learner_id_in   IN       VARCHAR2,
      io_cursor       IN OUT   edm_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      e_cursor   edm_cursor;
   BEGIN
      OPEN e_cursor FOR
         SELECT   ei.object_id,
                  edm_doctype_to_doctypename
                                 (ei.document_type_code)
                                                       AS document_type_code,
                  ei.document_name doc_id, ei.viewed_doc, ei.session_year,
                  TO_CHAR (ei.scan_date,
                           'DAY DD MONTH YYYY HH24:MI:SS'
                          ) scan_date,
                  ei.rescan_req, ei.req_original, ei.annot,
                  ei.attachment_type_code, ei.batch_id, ei.envelope_id,
                  ei.document_type_count, ei.document_type_code doc_code,
                     ei.object_id
                  || '_'
                  || ei.document_type_code
                  || ROWNUM unique_id
             FROM ila500_edm_images ei
            WHERE ei.learner_id = learner_id_in
              AND ei.attachment_type_code != 'XML'
         ORDER BY ei.scan_date DESC, ei.session_year DESC;

      io_cursor := e_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : edm : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END edm;

   FUNCTION edm_doctype_to_doctypename (document_type_code_in IN VARCHAR2)
      RETURN VARCHAR2
   AS
      v_doc_type_name   VARCHAR2 (50);
   BEGIN
      SELECT document_type_name
        INTO v_doc_type_name
        FROM sgas.config_edm
       WHERE document_type_code = document_type_code_in;

      RETURN v_doc_type_name;
   END edm_doctype_to_doctypename;

   PROCEDURE edm_doctypename_to_doctype (
      document_name_in         IN       VARCHAR2,
      document_type_code_out   OUT      VARCHAR2,
      error_boolean            OUT      VARCHAR2,
      ERROR_TEXT               OUT      VARCHAR2
   )
   AS
   BEGIN
      SELECT document_type_code
        INTO document_type_code_out
        FROM sgas.config_edm
       WHERE document_type_name = document_name_in;

      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : edm_doctypename_to_doctype : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END edm_doctypename_to_doctype;

   PROCEDURE insertedm (
      learner_id_in           IN       VARCHAR2,
      object_id_in            IN       VARCHAR2,
      session_year_in         IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      filename_in             IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   )
   AS
   BEGIN
      INSERT INTO ila500_edm_images ei
                  (ei.learner_id, ei.scan_date, ei.object_id,
                   ei.session_year, ei.document_type_code, ei.document_name,
                   ei.attachment_type_code, ei.document_type_count,
                   ei.rescan, ei.rescan_req, ei.req_original, ei.annot
                  )
           VALUES (learner_id_in, SYSDATE, object_id_in,
                   session_year_in, document_type_code_in, filename_in,
                   (SELECT file_ext
                      FROM sgas.config_edm
                     WHERE document_type_code = document_type_code_in), 1,
                   NULL, NULL, NULL, NULL
                  );

      error_boolean := 'false';
      row_count := SQL%ROWCOUNT;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : insertedm : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
         row_count := 0;
   END insertedm;

   PROCEDURE updateedm (
      learner_id_in           IN       VARCHAR2,
      object_id_in            IN       VARCHAR2,
      session_year_in         IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   )
   AS
   BEGIN
      UPDATE ila500_edm_images ei
         SET ei.session_year = NVL (session_year_in, ei.session_year),
             ei.document_type_code =
                    NVL (UPPER (document_type_code_in), ei.document_type_code)
       WHERE ei.learner_id = learner_id_in AND ei.object_id = object_id_in;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : updateedm : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
         row_count := 0;
   END updateedm;

   PROCEDURE getedmlearnerdetails (
      learner_id_in         IN       VARCHAR2,
      learner_surname       OUT      VARCHAR2,
      learner_postcode      OUT      VARCHAR2,
      learner_addr_l1       OUT      VARCHAR2,
      learner_inst_name     OUT      VARCHAR2,
      learner_course_name   OUT      VARCHAR2,
      error_boolean         OUT      VARCHAR2,
      ERROR_TEXT            OUT      VARCHAR2
   )
   AS
      provider_id_in   VARCHAR2 (10);
   BEGIN
      SELECT surname, postcode, address_line1
        INTO learner_surname, learner_postcode, learner_addr_l1
        FROM learner
       WHERE learner_id = learner_id_in;

      SELECT course_title, provider_id
        INTO learner_course_name, provider_id_in
        FROM learner_application
       WHERE learner_id = learner_id_in;

      SELECT provider_name
        INTO learner_inst_name
        FROM provider
       WHERE provider_id = provider_id_in;

      error_boolean := 'false';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         error_boolean := 'false';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getedmlearnerdetails : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getedmlearnerdetails;

   PROCEDURE getapplicabledoctypecode (
      file_ext_in     IN       VARCHAR2,
      io_cursor       IN OUT   doctype_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      e_cursor   doctype_cursor;
   BEGIN
      IF file_ext_in IS NULL
      THEN
         OPEN e_cursor FOR
            SELECT document_type_code, document_type_name
              FROM sgas.config_edm ce;
      ELSE
         OPEN e_cursor FOR
            SELECT document_type_code, document_type_name
              FROM sgas.config_edm ce
             WHERE ce.file_ext = UPPER (file_ext_in);
      END IF;

      io_cursor := e_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getapplicabledoctypecode : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getapplicabledoctypecode;

   PROCEDURE edmrescan (
      object_id_in            IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      rescan_request_id_in    IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   )
   AS
   BEGIN
      UPDATE ila500_edm_images ei
         SET ei.rescan_req = 'Y',
             ei.rescan_request_id = rescan_request_id_in
       WHERE ei.object_id = object_id_in
         AND ei.document_type_code = document_type_code_in;

      error_boolean := 'false';
      row_count := SQL%ROWCOUNT;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : edmrescan : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
         row_count := 0;
   END edmrescan;

   PROCEDURE edm_orig_req (
      object_id_in            IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   )
   AS
   BEGIN
      UPDATE ila500_edm_images ei
         SET ei.req_original = 'Y'
       WHERE ei.object_id = object_id_in
         AND ei.document_type_code = document_type_code_in;

      error_boolean := 'false';
      row_count := SQL%ROWCOUNT;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : edm_orig_req : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
         row_count := 0;
   END edm_orig_req;

   PROCEDURE edmviewed (
      object_id_in            IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   )
   AS
   BEGIN
      UPDATE ila500_edm_images ei
         SET ei.viewed_doc = 'Y'
       WHERE ei.object_id = object_id_in
         AND ei.document_type_code = document_type_code_in;

      error_boolean := 'false';
      row_count := SQL%ROWCOUNT;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : edmviewed : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
         row_count := 0;
   END edmviewed;

   PROCEDURE geteistreampassword (
      eistream_user       IN       VARCHAR2,
      eistream_password   OUT      VARCHAR2,
      error_boolean       OUT      VARCHAR2,
      ERROR_TEXT          OUT      VARCHAR2
   )
   AS
   BEGIN
      COMMIT;
      SET TRANSACTION READ ONLY;

      SELECT PASSWORD
        INTO eistream_password
        FROM resources@saasedmt
       WHERE UPPER (o_resource) = UPPER (eistream_user);

      COMMIT;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : geteistreampassword : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END geteistreampassword;

   PROCEDURE geteistreamuser (
      eistream_user_in    IN       VARCHAR2,
      eistream_user_out   OUT      VARCHAR2,
      error_boolean       OUT      VARCHAR2,
      ERROR_TEXT          OUT      VARCHAR2
   )
   AS
   BEGIN
      COMMIT;
      SET TRANSACTION READ ONLY;

      SELECT o_resource
        INTO eistream_user_out
        FROM resources@saasedmt
       WHERE UPPER (eistream_user_in) = UPPER (o_resource);

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : geteistreamuser : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END geteistreamuser;

   PROCEDURE getpicklistlearnerdetails (
      learner_id_in       IN       VARCHAR2,
      learner_forenames   OUT      VARCHAR2,
      learner_surname     OUT      VARCHAR2,
      error_boolean       OUT      VARCHAR2,
      ERROR_TEXT          OUT      VARCHAR2
   )
   AS
   BEGIN
      SELECT forename, surname
        INTO learner_forenames, learner_surname
        FROM learner
       WHERE UPPER (learner_id) = UPPER (learner_id_in);

      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getpicklistlearnerdetails : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getpicklistlearnerdetails;

   PROCEDURE getpicklistproviderdetails (
      provider_id_in   IN       VARCHAR2,
      provider_name    OUT      VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   )
   AS
   BEGIN
      SELECT provider_name
        INTO provider_name
        FROM provider
       WHERE UPPER (provider_id) = UPPER (provider_id_in);

      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getpicklistproviderdetails : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getpicklistproviderdetails;

   PROCEDURE getlearnerdetails (
      learner_id_in          IN              VARCHAR2,
      title_out              OUT NOCOPY      VARCHAR2,
      other_title_out        OUT NOCOPY      VARCHAR2,
      forename_out           OUT NOCOPY      VARCHAR2,
      surname_out            OUT NOCOPY      VARCHAR2,
      dob_out                OUT NOCOPY      DATE,
      gender_out             OUT NOCOPY      VARCHAR2,
      living_scot_out        OUT NOCOPY      VARCHAR2,
      living_away_out        OUT NOCOPY      VARCHAR2,
      housename_no_out       OUT NOCOPY      VARCHAR2,
      address_line1_out      OUT NOCOPY      VARCHAR2,
      address_line2_out      OUT NOCOPY      VARCHAR2,
      address_line3_out      OUT NOCOPY      VARCHAR2,
      address_line4_out      OUT NOCOPY      VARCHAR2,
      postcode_out           OUT NOCOPY      VARCHAR2,
      mailsort_out           OUT NOCOPY      VARCHAR2,
      tele_no_out            OUT NOCOPY      VARCHAR2,
      email_addr_out         OUT NOCOPY      VARCHAR2,
      hold_payments_out      OUT NOCOPY      VARCHAR2,
      hold_letters_out       OUT NOCOPY      VARCHAR2,
      mail_returned_out      OUT NOCOPY      DATE,
      learner_deceased_out   OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      temp_title_count          NUMBER (1);
      temp_title                VARCHAR2 (25);
      temp_title_description    VARCHAR2 (25);
      temp_application_status   VARCHAR2 (20);
   BEGIN
      pk_steps_pt_ui.getlearneraddr (learner_id_in,
                                     temp_title_description,
                                     forename_out,
                                     surname_out,
                                     housename_no_out,
                                     address_line1_out,
                                     address_line2_out,
                                     address_line3_out,
                                     address_line4_out,
                                     postcode_out,
                                     mailsort_out,
                                     error_boolean,
                                     ERROR_TEXT
                                    );

      IF error_boolean = 'false'
      THEN
         SELECT l.email_address, l.dob, l.gender, l.lives_scotland_flag,
                l.lives_away_flag, l.telephone_no, l.mail_returned_date,
                l.hold_payments, hold_letters, l.deceased_flag
           INTO email_addr_out, dob_out, gender_out, living_scot_out,
                living_away_out, tele_no_out, mail_returned_out,
                hold_payments_out, hold_letters_out, learner_deceased_out
           FROM learner l
          WHERE UPPER (l.learner_id) = UPPER (learner_id_in);

         SELECT COUNT (l.title_id)
           INTO temp_title_count
           FROM learner l
          WHERE UPPER (l.learner_id) = UPPER (learner_id_in);

         IF temp_title_count != 0
         THEN
            SELECT l.title_id
              INTO title_out
              FROM learner l
             WHERE UPPER (l.learner_id) = UPPER (learner_id_in);
         END IF;

         IF temp_title != NULL
         THEN
            SELECT t.description
              INTO temp_title
              FROM title t
             WHERE t.title_id = title_out;
         END IF;

         IF temp_title = 'OTHER'
         THEN
            other_title_out := temp_title_description;
         ELSE
            other_title_out := NULL;
         END IF;
      ELSIF error_boolean = 'true'
      THEN
         ERROR_TEXT :=
               'There has been an error in PL/SQL procedure getLearnerAddr, nested in getLearnerDetails: '
            || ERROR_TEXT;
      ELSE
         ERROR_TEXT :=
            'There has been an unspecified error in getLearnerDetails PL/SQL';
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || 'There is no Learner Details Data for this Learner. ';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getlearnerdetails;

   PROCEDURE setlearnerdetails (
      learner_id_in          IN       VARCHAR2,
      title_out              IN       VARCHAR2,
      other_title_out        IN       VARCHAR2,
      forename_out           IN       VARCHAR2,
      surname_out            IN       VARCHAR2,
      dob_out                IN       DATE,
      gender_out             IN       VARCHAR2,
      living_scot_out        IN       VARCHAR2,
      living_away_out        IN       VARCHAR2,
      housename_no_out       IN       VARCHAR2,
      address_line1_out      IN       VARCHAR2,
      address_line2_out      IN       VARCHAR2,
      address_line3_out      IN       VARCHAR2,
      address_line4_out      IN       VARCHAR2,
      postcode_out           IN       VARCHAR2,
      tele_no_out            IN       VARCHAR2,
      email_addr_out         IN       VARCHAR2,
      hold_payments_out      IN       VARCHAR2,
      hold_letters_out       IN       VARCHAR2,
      mail_returned_out      IN       DATE,
      learner_deceased_out   IN       VARCHAR2,
      grass_checked_in       IN       VARCHAR2,
      steps_checked_in       IN       VARCHAR2,
      ila200_checked_in      IN       VARCHAR2,
      ila500_checked_in      IN       VARCHAR2,
      employee_in            IN       VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2,
      row_count              OUT      VARCHAR2
   )
   IS
      temp_title_desc   VARCHAR (10);
      temp_title        VARCHAR2 (15);
   BEGIN
      SELECT t.description
        INTO temp_title_desc
        FROM title t
       WHERE t.title_id = title_out;

      IF temp_title_desc != 'OTHER'
      THEN
         temp_title := NULL;
      ELSE
         temp_title := other_title_out;
      END IF;

      UPDATE learner l
         SET l.title_id = UPPER (title_out),
             l.other_title = UPPER (temp_title),
             l.forename = UPPER (forename_out),
             l.surname = UPPER (surname_out),
             l.dob = dob_out,
             l.gender = UPPER (gender_out),
             l.lives_scotland_flag = UPPER (living_scot_out),
             l.lives_away_flag = living_away_out,
             l.housename_no = UPPER (housename_no_out),
             l.address_line1 = UPPER (address_line1_out),
             l.address_line2 = UPPER (address_line2_out),
             l.address_line3 = UPPER (address_line3_out),
             l.address_line4 = UPPER (address_line4_out),
             l.postcode = UPPER (postcode_out),
             l.telephone_no = UPPER (tele_no_out),
             l.email_address = UPPER (email_addr_out),
             l.hold_payments = UPPER (hold_payments_out),
             l.hold_letters = UPPER (hold_letters_out),
             l.mail_returned_date = mail_returned_out,
             l.deceased_flag = UPPER (learner_deceased_out),
             l.grass_checked = UPPER (grass_checked_in),
             l.steps_checked = UPPER (steps_checked_in),
             l.ila200_checked = UPPER (ila200_checked_in),
             l.ila500_checked = UPPER (ila500_checked_in),
             l.last_updated_by = UPPER (employee_in),
             l.last_updated_on = SYSDATE
       WHERE UPPER (l.learner_id) = UPPER (learner_id_in);

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setlearnerdetails;

   PROCEDURE gettitledd (
      io_cursor       IN OUT   title_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      t_cursor   title_cursor;
   BEGIN
      OPEN t_cursor FOR
         SELECT t.title_id, t.description
           FROM title t;

      io_cursor := t_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END gettitledd;

   PROCEDURE getstatusdd (
      io_cursor       IN OUT   status_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      s_cursor   status_cursor;
   BEGIN
      OPEN s_cursor FOR
         SELECT a_s.application_status_id, a_s.status
           FROM application_status a_s;

      io_cursor := s_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstatusdd;

   PROCEDURE getrejectdd (
      io_cursor       IN OUT   reject_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      r_cursor   reject_cursor;
   BEGIN
      OPEN r_cursor FOR
         SELECT a_r.application_rejection_id, a_r.rejection_reason
           FROM application_rejection a_r;

      io_cursor := r_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getrejectdd;

   PROCEDURE getlearnerapplication (
      learner_application_id_in        IN              VARCHAR2,
      course_id_out                    OUT NOCOPY      VARCHAR2,
      course_type_id_out               OUT NOCOPY      VARCHAR2,
      provider_id_out                  OUT NOCOPY      VARCHAR2,
      application_status_id_out        OUT NOCOPY      VARCHAR2,
      rejection_id_out                 OUT NOCOPY      VARCHAR2,
      total_annual_income_out          OUT NOCOPY      VARCHAR2,
      tot_ann_inc_evid_id_out          OUT NOCOPY      VARCHAR2,
      no_income_out                    OUT NOCOPY      VARCHAR2,
      no_income_evid_id_out            OUT NOCOPY      VARCHAR2,
      job_seekers_allowance_out        OUT NOCOPY      VARCHAR2,
      jsa_evid_id_out                  OUT NOCOPY      VARCHAR2,
      income_support_out               OUT NOCOPY      VARCHAR2,
      inc_sup_evid_id_out              OUT NOCOPY      VARCHAR2,
      incapacity_benefit_out           OUT NOCOPY      VARCHAR2,
      inc_ben_evid_id_out              OUT NOCOPY      VARCHAR2,
      carers_allowance_out             OUT NOCOPY      VARCHAR2,
      carers_allowance_evid_id_out     OUT NOCOPY      VARCHAR2,
      pension_credit_out               OUT NOCOPY      VARCHAR2,
      pension_credit_evid_id_out       OUT NOCOPY      VARCHAR2,
      max_child_tax_credit_out         OUT NOCOPY      VARCHAR2,
      max_child_tc_evid_id_out         OUT NOCOPY      VARCHAR2,
      session_year_out                 OUT NOCOPY      VARCHAR2,
      date_app_recd_out                OUT NOCOPY      DATE,
      date_record_created_out          OUT NOCOPY      DATE,
      date_of_last_calc_out            OUT NOCOPY      DATE,
      course_title_out                 OUT NOCOPY      VARCHAR2,
      course_start_date_out            OUT NOCOPY      DATE,
      length_of_course_out             OUT NOCOPY      VARCHAR2,
      current_course_year_out          OUT NOCOPY      VARCHAR2,
      course_end_date_out              OUT NOCOPY      DATE,
      help_with_fees_out               OUT NOCOPY      VARCHAR2,
      help_amount_out                  OUT NOCOPY      VARCHAR2,
      fee_requested_out                OUT NOCOPY      VARCHAR2,
      provider_signature_present_out   OUT NOCOPY      VARCHAR2,
      date_endorsed_out                OUT NOCOPY      DATE,
      endorsed_by_out                  OUT NOCOPY      VARCHAR2,
      stamped_out                      OUT NOCOPY      VARCHAR2,
      learner_signature_present_out    OUT NOCOPY      VARCHAR2,
      date_signed_out                  OUT NOCOPY      DATE,
      fee_paid_bacs_out                OUT NOCOPY      VARCHAR2,
      payment_date_out                 OUT NOCOPY      DATE,
      recover_fees_out                 OUT NOCOPY      VARCHAR2,
      debt_status_out                  OUT NOCOPY      VARCHAR2,
      fee_calculated_out               OUT NOCOPY      VARCHAR2,
      comments_for_award_letter_out    OUT NOCOPY      VARCHAR2,
      non_attendance_out               OUT NOCOPY      VARCHAR2,
      date_withdrawn_out               OUT NOCOPY      DATE,
      date_actioned_out                OUT NOCOPY      DATE,
      error_boolean                    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                       OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT la.course_id, la.course_type_id, la.provider_id,
             la.application_status_id, la.rejection_id,
             la.total_annual_income, la.tot_ann_inc_evid_id,
             la.no_income, la.no_income_evid_id,
             la.job_seekers_allowance, la.jsa_evid_id, la.income_support,
             la.inc_sup_evid_id, la.incapacity_benefit,
             la.inc_ben_evid_id, la.carers_allowance,
             la.carers_allowance_evid_id, la.pension_credit,
             la.pension_credit_evid_id, la.max_child_tax_credit,
             la.max_child_tax_credit_evid_id, la.session_year,
             la.date_app_recd, la.date_record_created,
             la.date_of_last_calc, la.course_title, la.course_start_date,
             la.length_of_course, la.current_course_year,
             la.course_end_date, la.help_with_fees, la.help_amount,
             la.fee_requested, la.provider_signature_present,
             la.date_endorsed, la.endorsed_by, la.stamped,
             la.learner_signature_present, la.date_signed,
             la.fee_paid_bacs, la.payment_date, la.recover_fees,
             la.debt_status, la.fee_calculated,
             la.comments_for_award_letter, la.non_attendance,
             la.date_withdrawn, la.date_actioned
        INTO course_id_out, course_type_id_out, provider_id_out,
             application_status_id_out, rejection_id_out,
             total_annual_income_out, tot_ann_inc_evid_id_out,
             no_income_out, no_income_evid_id_out,
             job_seekers_allowance_out, jsa_evid_id_out, income_support_out,
             inc_sup_evid_id_out, incapacity_benefit_out,
             inc_ben_evid_id_out, carers_allowance_out,
             carers_allowance_evid_id_out, pension_credit_out,
             pension_credit_evid_id_out, max_child_tax_credit_out,
             max_child_tc_evid_id_out, session_year_out,
             date_app_recd_out, date_record_created_out,
             date_of_last_calc_out, course_title_out, course_start_date_out,
             length_of_course_out, current_course_year_out,
             course_end_date_out, help_with_fees_out, help_amount_out,
             fee_requested_out, provider_signature_present_out,
             date_endorsed_out, endorsed_by_out, stamped_out,
             learner_signature_present_out, date_signed_out,
             fee_paid_bacs_out, payment_date_out, recover_fees_out,
             debt_status_out, fee_calculated_out,
             comments_for_award_letter_out, non_attendance_out,
             date_withdrawn_out, date_actioned_out
        FROM learner_application la
       WHERE la.learner_application_id = learner_application_id_in;

      error_boolean := 'false';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         ERROR_TEXT :=
               ERROR_TEXT
            || 'There is no Learner Application Data for this Learner';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getlearnerapplication;

   PROCEDURE setlearnerapplication (
      learner_application_id_in       IN       VARCHAR2,
      course_id_in                    IN       VARCHAR2,
      course_type_id_in               IN       VARCHAR2,
      provider_id_in                  IN       VARCHAR2,
      application_status_id_in        IN       VARCHAR2,
      rejection_id_in                 IN       VARCHAR2,
      total_annual_income_in          IN       VARCHAR2,
      tot_ann_inc_evid_id_in          IN       VARCHAR2,
      no_income_in                    IN       VARCHAR2,
      no_income_evid_id_in            IN       VARCHAR2,
      job_seekers_allowance_in        IN       VARCHAR2,
      jsa_evid_id_in                  IN       VARCHAR2,
      income_support_in               IN       VARCHAR2,
      inc_sup_evid_id_in              IN       VARCHAR2,
      incapacity_benefit_in           IN       VARCHAR2,
      inc_ben_evid_id_in              IN       VARCHAR2,
      carers_allowance_in             IN       VARCHAR2,
      carers_allowance_evid_id_in     IN       VARCHAR2,
      pension_credit_in               IN       VARCHAR2,
      pension_credit_evid_id_in       IN       VARCHAR2,
      max_child_tax_credit_in         IN       VARCHAR2,
      max_child_tc_evid_id_in         IN       VARCHAR2,
      session_year_in                 IN       VARCHAR2,
      course_title_in                 IN       VARCHAR2,
      current_course_year_in          IN       VARCHAR2,
      course_start_date_in            IN       DATE,
      course_end_date_in              IN       DATE,
      length_of_course_in             IN       VARCHAR2,
      help_with_fees_in               IN       VARCHAR2,
      help_amount_in                  IN       VARCHAR2,
      fee_requested_in                IN       VARCHAR2,
      provider_signature_present_in   IN       VARCHAR2,
      date_endorsed_in                IN       DATE,
      endorsed_by_in                  IN       VARCHAR2,
      stamped_in                      IN       VARCHAR2,
      learner_signature_present_in    IN       VARCHAR2,
      date_signed_in                  IN       DATE,
      debt_status_in                  IN       VARCHAR2,
      comments_for_award_letter_in    IN       VARCHAR2,
      employee_in                     IN       VARCHAR2,
      error_boolean                   OUT      VARCHAR2,
      ERROR_TEXT                      OUT      VARCHAR2,
      row_count                       OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE learner_application la
         SET la.course_id = UPPER (course_id_in),
             la.course_type_id =
                pk_steps_pt_ui.getcoursetypeid (course_start_date_in,
                                                session_year_in
                                               ),
             la.provider_id = UPPER (provider_id_in),
             la.application_status_id = UPPER (application_status_id_in),
             la.rejection_id = UPPER (rejection_id_in),
             la.total_annual_income = UPPER (total_annual_income_in),
             la.tot_ann_inc_evid_id = UPPER (tot_ann_inc_evid_id_in),
             la.no_income = UPPER (no_income_in),
             la.no_income_evid_id = UPPER (no_income_evid_id_in),
             la.job_seekers_allowance = UPPER (job_seekers_allowance_in),
             la.jsa_evid_id = UPPER (jsa_evid_id_in),
             la.income_support = UPPER (income_support_in),
             la.inc_sup_evid_id = UPPER (inc_sup_evid_id_in),
             la.incapacity_benefit = UPPER (incapacity_benefit_in),
             la.inc_ben_evid_id = UPPER (inc_ben_evid_id_in),
             la.carers_allowance = UPPER (carers_allowance_in),
             la.carers_allowance_evid_id = UPPER (carers_allowance_evid_id_in),
             la.pension_credit = UPPER (pension_credit_in),
             la.pension_credit_evid_id = UPPER (pension_credit_evid_id_in),
             la.max_child_tax_credit = UPPER (max_child_tax_credit_in),
             la.max_child_tax_credit_evid_id = UPPER (max_child_tc_evid_id_in),
             la.session_year = UPPER (session_year_in),
             la.course_title = UPPER (course_title_in),
             la.current_course_year = UPPER (current_course_year_in),
             la.course_start_date = course_start_date_in,
             la.course_end_date = course_end_date_in,
             la.length_of_course = UPPER (length_of_course_in),
             la.help_with_fees = UPPER (help_with_fees_in),
             la.help_amount = UPPER (help_amount_in),
             la.fee_requested = UPPER (fee_requested_in),
             la.provider_signature_present =
                                         UPPER (provider_signature_present_in),
             la.date_endorsed = date_endorsed_in,
             la.endorsed_by = UPPER (endorsed_by_in),
             la.stamped = UPPER (stamped_in),
             la.learner_signature_present =
                                          UPPER (learner_signature_present_in),
             la.date_signed = date_signed_in,
             la.debt_status = UPPER (debt_status_in),
             la.comments_for_award_letter =
                                          UPPER (comments_for_award_letter_in),
             la.last_updated_by = UPPER (employee_in),
             la.last_updated_on = SYSDATE
       WHERE la.learner_application_id = learner_application_id_in;

      row_count := SQL%ROWCOUNT;

      IF row_count = 0
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            'There is no Learner Application record. Update has not been performed';
      ELSE
         error_boolean := 'false';
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setlearnerapplication;

   FUNCTION getcoursetypeid (
      course_start_date_in   IN   DATE,
      session_year_in        IN   VARCHAR2
   )
      RETURN NUMBER
   AS
      v_course_type_id   NUMBER (10);
   BEGIN
      SELECT course_type_id
        INTO v_course_type_id
        FROM course_type ct
       WHERE course_start_date_in BETWEEN ct.fee_period_start
                                      AND ct.fee_period_end
         AND ct.session_year = session_year_in;

      RETURN v_course_type_id;
   EXCEPTION
      WHEN TOO_MANY_ROWS
      THEN
         v_course_type_id := 0;
         RETURN v_course_type_id;
      WHEN NO_DATA_FOUND
      THEN
         v_course_type_id := -1;
         RETURN v_course_type_id;
      WHEN OTHERS
      THEN
         v_course_type_id := -2;
         RETURN v_course_type_id;
   END getcoursetypeid;

   PROCEDURE getcoursetype (
      course_start_date_in   IN              DATE,
      session_year_in        IN              VARCHAR2,
      course_type_id_out     OUT NOCOPY      NUMBER,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      course_type_id_out :=
         pk_steps_pt_ui.getcoursetypeid (course_start_date_in,
                                         session_year_in
                                        );

      IF course_type_id_out = 0
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            'Cannot define Course Type. More than 1 record exists for this start period.';
      ELSIF course_type_id_out = -1
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            'Cannot define Course Type. No Course Type Id found for Course Start Date.';
      ELSIF course_type_id_out = -2
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            'Cannot define Course Type. Undefined error - Please check Course Start Date.';
      ELSE
         error_boolean := 'false';
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'There is no Course Payment Period for the Start Date entered in session '
            || session_year_in
            || '. Please check details';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getcoursetype;

   PROCEDURE getlearningproviderdd (
      io_cursor       IN OUT   learningprovider_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      lp_cursor   learningprovider_cursor;
   BEGIN
      OPEN lp_cursor FOR
         SELECT   p.provider_id, p.provider_name
             FROM provider p
         ORDER BY p.provider_name;

      io_cursor := lp_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getlearningproviderdd;

   PROCEDURE getcoursetypedd (
      io_cursor       IN OUT   coursetype_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      ct_cursor   coursetype_cursor;
   BEGIN
      OPEN ct_cursor FOR
         SELECT   ct.course_type_id, ct.course_type_desc
             FROM course_type ct
         ORDER BY ct.course_type_desc;

      io_cursor := ct_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getcoursetypedd;

   PROCEDURE getcourseleveldd (
      io_cursor       IN OUT   courselevel_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      cl_cursor   courselevel_cursor;
   BEGIN
      OPEN cl_cursor FOR
         SELECT   cl.course_id, cl.course_level_desc
             FROM course_level cl
         ORDER BY cl.course_id ASC;

      io_cursor := cl_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getcourseleveldd;

   PROCEDURE getdebtstatusdd (
      io_cursor       IN OUT   debtstatus_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      ds_cursor   debtstatus_cursor;
   BEGIN
      OPEN ds_cursor FOR
         SELECT   ds.debt_status_id, ds.debt_status_desc
             FROM debt_status ds
         ORDER BY ds.debt_status_desc;

      io_cursor := ds_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getdebtstatusdd;

   PROCEDURE getincomeeviddd (
      io_cursor       IN OUT   incomeevid_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      ie_cursor   incomeevid_cursor;
   BEGIN
      OPEN ie_cursor FOR
         SELECT   ae.evid_id, ae.evid_desc
             FROM application_evidence ae
         ORDER BY ae.evid_desc;

      io_cursor := ie_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getincomeeviddd;

   PROCEDURE getdocumentregister (
      learner_id_in   IN       VARCHAR2,
      io_cursor       IN OUT   documentregister_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      dr_cursor   documentregister_cursor;
   BEGIN
      OPEN dr_cursor FOR
         SELECT doc_reg_id, session_year, document_type_code document,
                TO_CHAR (received_date, 'DD MON YYYY') received_date,
                TO_CHAR (returned_date, 'DD MON YYYY') returned_date,
                last_updated_by,
                TO_CHAR (last_updated_on,
                         'DY DD MON YYYY HH24:MI:SS'
                        ) last_updated_on
           FROM document_register
          WHERE primary_key = learner_id_in;

      io_cursor := dr_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getdocumentregister : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getdocumentregister;

   PROCEDURE updatedocumentregister (
      learner_id_in           IN       VARCHAR2,
      doc_reg_id_in           IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      received_date_in        IN       VARCHAR2,
      session_year_in         IN       VARCHAR2,
      returned_date_in        IN       VARCHAR2,
      last_updated_by_in      IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE document_register dr
         SET dr.document_type_code = document_type_code_in,
             dr.received_date = received_date_in,
             dr.session_year = session_year_in,
             dr.returned_date = returned_date_in,
             dr.last_updated_by = UPPER (last_updated_by_in),
             dr.last_updated_on = SYSDATE
       WHERE dr.primary_key = learner_id_in AND dr.doc_reg_id = doc_reg_id_in;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT :=
               'ERROR : plsql procedure : updatedocumentregister : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END updatedocumentregister;

   PROCEDURE insertdocumentregister (
      learner_id_in           IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      received_date_in        IN       VARCHAR2,
      session_year_in         IN       VARCHAR2,
      returned_date_in        IN       VARCHAR2,
      last_updated_by_in      IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   )
   IS
   BEGIN
      --IF returned_date_in = ""
      --THEN
      --returned_date_in := null;
      --END IF;
      INSERT INTO document_register
                  (source_table, primary_key, document_type_code,
                   received_date, session_year,
                   returned_date, last_updated_by,
                   last_updated_on
                  )
           VALUES ('LEARNER', learner_id_in, document_type_code_in,
                   received_date_in, session_year_in,
                   NVL (returned_date_in, NULL), UPPER (last_updated_by_in),
                   SYSDATE
                  );

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT :=
               'ERROR : plsql procedure : insertdocumentregister : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END insertdocumentregister;

   PROCEDURE deletedocumentregister (
      learner_id_in      IN       VARCHAR2,
      doc_reg_id_in      IN       VARCHAR2,
      deleted_by_id_in   IN       VARCHAR2,
      error_boolean      OUT      VARCHAR2,
      ERROR_TEXT         OUT      VARCHAR2,
      row_count          OUT      VARCHAR2
   )
   IS
   BEGIN
      DELETE FROM document_register dr
            WHERE dr.primary_key = learner_id_in
              AND dr.doc_reg_id = doc_reg_id_in;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      pk_pop_aud.set_uid4audit_doc_reg_aud (deleted_by_id_in, doc_reg_id_in);
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT :=
               'ERROR : plsql procedure : deletedocumentregister : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END deletedocumentregister;

   PROCEDURE getlearnerorproviderlist (
      type_flag       IN       VARCHAR2,
      search_text1    IN       VARCHAR2,
      search_text2    IN       VARCHAR2,
      io_cursor       IN OUT   learnerorproviderlist_cursor,
      row_count       OUT      VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      lp_cursor   learnerorproviderlist_cursor;
   BEGIN
      IF UPPER (type_flag) = 'L'
      THEN
         IF search_text1 IS NOT NULL AND search_text2 IS NOT NULL
         THEN
            OPEN lp_cursor FOR
               SELECT learner_id ID,
                         'Id : '
                      || learner_id
                      || '  '
                      || forename
                      || ' '
                      || surname
                      || '  '
                      || 'DOB : '
                      || dob NAME
                 FROM learner
                WHERE UPPER (forename) LIKE '%' || UPPER (search_text1)
                                            || '%'
                  AND UPPER (surname) LIKE '%' || UPPER (search_text2) || '%';
         ELSIF search_text1 IS NOT NULL AND search_text2 IS NULL
         THEN
            OPEN lp_cursor FOR
               SELECT learner_id ID,
                         'Id : '
                      || learner_id
                      || '  '
                      || forename
                      || ' '
                      || surname
                      || '  '
                      || 'DOB : '
                      || dob NAME
                 FROM learner
                WHERE UPPER (forename) LIKE '%' || UPPER (search_text1)
                                            || '%';
         ELSIF search_text1 IS NULL AND search_text2 IS NOT NULL
         THEN
            OPEN lp_cursor FOR
               SELECT learner_id ID,
                         'Id : '
                      || learner_id
                      || '  '
                      || forename
                      || ' '
                      || surname
                      || '  '
                      || 'DOB : '
                      || dob NAME
                 FROM learner
                WHERE UPPER (surname) LIKE '%' || UPPER (search_text2) || '%';
         ELSE
            OPEN lp_cursor FOR
               SELECT learner_id ID,
                         'Id : '
                      || learner_id
                      || '  '
                      || forename
                      || ' '
                      || surname
                      || '  '
                      || 'DOB : '
                      || dob NAME
                 FROM learner;
         END IF;
      ELSIF UPPER (type_flag) = 'P' OR UPPER (type_flag) = 'A'
      THEN
         IF search_text1 IS NOT NULL
         THEN
            OPEN lp_cursor FOR
               SELECT provider_id ID, provider_name NAME
                 FROM provider
                WHERE UPPER (provider_name) LIKE
                                            '%' || UPPER (search_text1)
                                            || '%';
         ELSE
            OPEN lp_cursor FOR
               SELECT provider_id ID, provider_name NAME
                 FROM provider;
         END IF;

         row_count := '0';
      END IF;

      io_cursor := lp_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getlearnerofproviderlist using parameter '
            || UPPER (type_flag)
            || ': @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getlearnerorproviderlist;

   PROCEDURE getalllearnersforprovider (
      provider_id_in   IN       VARCHAR2,
      io_cursor        IN OUT   alllearnerforprovider_cursor,
      row_count        OUT      VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   )
   IS
      alfp_cursor   alllearnerforprovider_cursor;
   BEGIN
      OPEN alfp_cursor FOR
         SELECT la.learner_id ID, l.forename || ' ' || l.surname NAME
           FROM learner_application la, learner l
          WHERE la.provider_id = provider_id_in
            AND la.learner_id = l.learner_id
            AND session_year = (SELECT cval
                                  FROM ila500_config_data
                                 WHERE item_name = 'CURRENT_SESSION');

      io_cursor := alfp_cursor;
      error_boolean := 'false';
      row_count := getcursorrowcount (provider_id_in);
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getalllearnersforprovider '
            || ': @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getalllearnersforprovider;

   PROCEDURE getcaseworkernote (
      learner_id_in   IN       VARCHAR2,
      io_cursor       IN OUT   caseworkernote_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      cn_cursor   caseworkernote_cursor;
   BEGIN
      OPEN cn_cursor FOR
         SELECT cn.cw_note_id, nt.description,
                TO_CHAR (cn.note_date, 'DD MON YYYY') note_date,
                cn.session_year, cn.note_text, cn.last_updated_by,
                TO_CHAR (cn.last_updated_on,
                         'DY DD MON YYYY HH24:MI:SS'
                        ) last_updated_on
           FROM caseworker_note cn, note_type nt
          WHERE cn.primary_key = learner_id_in
            AND nt.note_type_id = cn.note_type_id;

      io_cursor := cn_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getcaseworkernote : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getcaseworkernote;

   PROCEDURE updatecaseworkernote (
      learner_id_in        IN       VARCHAR2,
      cw_note_id_in        IN       VARCHAR2,
      note_type_id_in      IN       VARCHAR2,
      session_year_in      IN       VARCHAR2,
      note_text_in         IN       VARCHAR2,
      last_updated_by_in   IN       VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2,
      row_count            OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE caseworker_note cn
         SET cn.note_type_id = NVL (note_type_id_in, cn.note_type_id),
             cn.session_year = NVL (session_year_in, cn.session_year),
             cn.note_text = NVL (note_text_in, cn.note_text),
             cn.last_updated_by =
                          NVL (UPPER (last_updated_by_in), cn.last_updated_by),
             cn.last_updated_on = SYSDATE
       WHERE cn.primary_key = learner_id_in AND cn.cw_note_id = cw_note_id_in;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT :=
               'ERROR : plsql procedure : updatecaseworkernote : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END updatecaseworkernote;

   PROCEDURE insertcaseworkernote (
      reference_id_in      IN       VARCHAR2,
      reference_type_in    IN       VARCHAR2,
      note_type_id_in      IN       VARCHAR2,
      session_year_in      IN       VARCHAR2,
      note_text_in         IN       VARCHAR2,
      last_updated_by_in   IN       VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2,
      row_count            OUT      VARCHAR2
   )
   IS
   BEGIN
      INSERT INTO caseworker_note
                  (source_table, primary_key, note_type_id,
                   note_date, session_year, note_text,
                   last_updated_by, last_updated_on
                  )
           VALUES (reference_type_in, reference_id_in, note_type_id_in,
                   TRUNC (SYSDATE), session_year_in, note_text_in,
                   UPPER (last_updated_by_in), SYSDATE
                  );

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT :=
               'ERROR : plsql procedure : insertcaseworkernote : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END insertcaseworkernote;

   PROCEDURE deletecaseworkernote (
      learner_id_in      IN       VARCHAR2,
      cw_note_id_in      IN       VARCHAR2,
      deleted_by_id_in   IN       VARCHAR2,
      error_boolean      OUT      VARCHAR2,
      ERROR_TEXT         OUT      VARCHAR2,
      row_count          OUT      VARCHAR2
   )
   IS
   BEGIN
      DELETE FROM caseworker_note cn
            WHERE cn.primary_key = learner_id_in
              AND cn.cw_note_id = cw_note_id_in;

      row_count := SQL%ROWCOUNT;
      pk_pop_aud.set_uid4audit_case_note_aud (deleted_by_id_in, cw_note_id_in);
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT :=
               'ERROR : plsql procedure : deletecaseworkernote : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END deletecaseworkernote;

   PROCEDURE getcaseworkernotetype (
      io_cursor       IN OUT   caseworkernotetype_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      cnt_cursor   caseworkernotetype_cursor;
   BEGIN
      OPEN cnt_cursor FOR
         SELECT note_type_id, description
           FROM note_type;

      io_cursor := cnt_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getcaseworkernotetype : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getcaseworkernotetype;

   PROCEDURE getconfigdatacurrentsession (
      current_session   OUT   VARCHAR2,
      error_boolean     OUT   VARCHAR2,
      ERROR_TEXT        OUT   VARCHAR2
   )
   IS
   BEGIN
      SELECT cval
        INTO current_session
        FROM ila500_config_data
       WHERE item_name = 'CURRENT_SESSION';

      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getconfigdatacurrentsession : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getconfigdatacurrentsession;

   PROCEDURE learnerorprovider (
      reference_id_in         IN       VARCHAR2,
      learnerorproviderflag   OUT      VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2
   )
   IS
      learner_check                 NUMBER;
      provider_check                NUMBER;
      i                             NUMBER;
      containsnonnumericcharacter   BOOLEAN;
   BEGIN
      containsnonnumericcharacter := FALSE;
      i := 0;
      /*
      WHILE (i < LENGTH (reference_id_in))
      LOOP
         IF (ASCII (SUBSTR (reference_id_in, i, 1)) NOT BETWEEN 48 AND 57)
         THEN
            containsnonnumericcharacter := TRUE;
            EXIT;
         END IF;

         i := i + 1;
      END LOOP;
      */

      --initialize
      learner_check := 0;
      provider_check := 0;

      IF containsnonnumericcharacter = FALSE
      THEN
         SELECT COUNT (*)
           INTO learner_check
           FROM learner
          WHERE UPPER (learner_id) = UPPER (reference_id_in);
      END IF;

      IF containsnonnumericcharacter = FALSE
      THEN
         SELECT COUNT (*)
           INTO provider_check
           FROM provider
          WHERE UPPER (provider_id) = UPPER (reference_id_in);
      END IF;

      IF learner_check = 1 AND provider_check = 1
      THEN
         RAISE duplicate_id;
      ELSIF learner_check = 0 AND provider_check = 0
      THEN
         RAISE invalid_id;
      ELSIF learner_check = 1 AND provider_check = 0
      THEN
         learnerorproviderflag := 'L';
      ELSE
         learnerorproviderflag := 'P';
      END IF;

      error_boolean := 'false';
   EXCEPTION
      WHEN invalid_id
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : learnerorprovider : @ '
            || SYSDATE
            || ': Provided ID is not a valid Learner OR Provider id.';
      WHEN duplicate_id
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : learnerorprovider : @ '
            || SYSDATE
            || ': Provided ID appears in both Learner and Provider tables.';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : learnerorprovider : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END learnerorprovider;

   PROCEDURE getapplications (
      learner_id_in   IN              VARCHAR2,
      io_cursor       IN OUT          application_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   IS
      a_cursor   application_cursor;
   BEGIN
      OPEN a_cursor FOR
         SELECT   la.learner_application_id,
                  la.session_year || ' ' || a_s.status AS session_label
             FROM learner_application la, application_status a_s
            WHERE la.learner_id = learner_id_in
              AND a_s.application_status_id = la.application_status_id
         ORDER BY la.learner_application_id;

      io_cursor := a_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getapplications;

   PROCEDURE getawardnoticedets (
      learner_application_id_in       IN       VARCHAR2,
      learner_id_out                  OUT      VARCHAR2,
      title_out                       OUT      VARCHAR2,
      forenames_out                   OUT      VARCHAR2,
      surname_out                     OUT      VARCHAR2,
      housename_no_out                OUT      VARCHAR2,
      address_line1_out               OUT      VARCHAR2,
      address_line2_out               OUT      VARCHAR2,
      address_line3_out               OUT      VARCHAR2,
      address_line4_out               OUT      VARCHAR2,
      postcode_out                    OUT      VARCHAR2,
      mailsort_out                    OUT      VARCHAR2,
      hold_letters_out                OUT      VARCHAR2,
      session_year_out                OUT      VARCHAR2,
      provider_out                    OUT      VARCHAR2,
      course_name_out                 OUT      VARCHAR2,
      qualification_out               OUT      VARCHAR2,
      course_year_out                 OUT      VARCHAR2,
      fee_calculated_out              OUT      VARCHAR2,
      comments_for_award_letter_out   OUT      VARCHAR2,
      error_boolean                   OUT      VARCHAR2,
      ERROR_TEXT                      OUT      VARCHAR2
   )
   IS
      temp_title_id            VARCHAR2 (5);
      temp_title               VARCHAR2 (25);
      temp_title_description   VARCHAR2 (25);
   BEGIN
      SELECT la.learner_id, l.hold_letters, la.session_year,
             p.provider_name, la.course_title, cl.course_level_desc,
             la.current_course_year, la.fee_calculated,
             la.comments_for_award_letter
        INTO learner_id_out, hold_letters_out, session_year_out,
             provider_out, course_name_out, qualification_out,
             course_year_out, fee_calculated_out,
             comments_for_award_letter_out
        FROM learner_application la, learner l, provider p, course_level cl
       WHERE la.learner_application_id = learner_application_id_in
         AND la.learner_id = l.learner_id
         AND la.provider_id = p.provider_id
         AND cl.course_id = la.course_id;

      pk_steps_pt_ui.getlearneraddr (learner_id_out,
                                     title_out,
                                     forenames_out,
                                     surname_out,
                                     housename_no_out,
                                     address_line1_out,
                                     address_line2_out,
                                     address_line3_out,
                                     address_line4_out,
                                     postcode_out,
                                     mailsort_out,
                                     error_boolean,
                                     ERROR_TEXT
                                    );
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getawardnoticedets;

   PROCEDURE getlearnerproviderrecord (
      provider_id_in                  IN       VARCHAR2,
      provider_name                   OUT      VARCHAR2,
      provider_house_no_or_name       OUT      VARCHAR2,
      provider_addr_l1                OUT      VARCHAR2,
      provider_addr_l2                OUT      VARCHAR2,
      provider_addr_l3                OUT      VARCHAR2,
      provider_addr_l4                OUT      VARCHAR2,
      provider_post_code              OUT      VARCHAR2,
      provider_tel_no                 OUT      VARCHAR2,
      provider_fax_no                 OUT      VARCHAR2,
      bank_sort_code                  OUT      VARCHAR2,
      bank_account_no                 OUT      VARCHAR2,
      main_contact_name               OUT      VARCHAR2,
      main_contact_position           OUT      VARCHAR2,
      main_contact_house_no_or_name   OUT      VARCHAR2,
      main_contact_addr_l1            OUT      VARCHAR2,
      main_contact_addr_l2            OUT      VARCHAR2,
      main_contact_addr_l3            OUT      VARCHAR2,
      main_contact_addr_l4            OUT      VARCHAR2,
      main_contact_post_code          OUT      VARCHAR2,
      main_contact_tel_no             OUT      VARCHAR2,
      main_contact_fax_no             OUT      VARCHAR2,
      main_contact_email              OUT      VARCHAR2,
      fin_contact_name                OUT      VARCHAR2,
      fin_contact_position            OUT      VARCHAR2,
      fin_contact_house_no_or_name    OUT      VARCHAR2,
      fin_contact_addr_l1             OUT      VARCHAR2,
      fin_contact_addr_l2             OUT      VARCHAR2,
      fin_contact_addr_l3             OUT      VARCHAR2,
      fin_contact_addr_l4             OUT      VARCHAR2,
      fin_contact_post_code           OUT      VARCHAR2,
      fin_contact_tel_no              OUT      VARCHAR2,
      fin_contact_fax_no              OUT      VARCHAR2,
      fin_contact_email               OUT      VARCHAR2,
      suspend_payments                OUT      VARCHAR2,
      suspend_letters                 OUT      VARCHAR2,
      prov_type_id                    OUT      VARCHAR2,
      prov_status_id                  OUT      VARCHAR2,
      record_creation_date            OUT      VARCHAR2,
      last_updated_by                 OUT      VARCHAR2,
      last_updated_on                 OUT      VARCHAR2,
      outstanding_amount              OUT      VARCHAR2,
      securezip_password              OUT      VARCHAR2,
      error_boolean                   OUT      VARCHAR2,
      ERROR_TEXT                      OUT      VARCHAR2
   )
   IS
   BEGIN
      SELECT provider_name, provider_house_no_or_name, provider_addr_l1,
             provider_addr_l2, provider_addr_l3, provider_addr_l4,
             provider_post_code, provider_tel_no, provider_fax_no,
             bank_sort_code, bank_account_no, main_contact_name,
             main_contact_position, main_contact_house_no_or_name,
             main_contact_addr_l1, main_contact_addr_l2,
             main_contact_addr_l3, main_contact_addr_l4,
             main_contact_post_code, main_contact_tel_no,
             main_contact_fax_no, main_contact_email, fin_contact_name,
             fin_contact_position, fin_contact_house_no_or_name,
             fin_contact_addr_l1, fin_contact_addr_l2, fin_contact_addr_l3,
             fin_contact_addr_l4, fin_contact_post_code, fin_contact_tel_no,
             fin_contact_fax_no, fin_contact_email, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             (SELECT MIN (aud_date)
                FROM provider_aud
               WHERE action = 'I'
                 AND primary_key = provider_id_in
                 AND column_name = 'PROVIDER_ID'),
             last_updated_by, last_updated_on, outstanding_amount,
             securezip_password
        INTO provider_name, provider_house_no_or_name, provider_addr_l1,
             provider_addr_l2, provider_addr_l3, provider_addr_l4,
             provider_post_code, provider_tel_no, provider_fax_no,
             bank_sort_code, bank_account_no, main_contact_name,
             main_contact_position, main_contact_house_no_or_name,
             main_contact_addr_l1, main_contact_addr_l2,
             main_contact_addr_l3, main_contact_addr_l4,
             main_contact_post_code, main_contact_tel_no,
             main_contact_fax_no, main_contact_email, fin_contact_name,
             fin_contact_position, fin_contact_house_no_or_name,
             fin_contact_addr_l1, fin_contact_addr_l2, fin_contact_addr_l3,
             fin_contact_addr_l4, fin_contact_post_code, fin_contact_tel_no,
             fin_contact_fax_no, fin_contact_email, suspend_payments,
             suspend_letters, prov_type_id, prov_status_id,
             record_creation_date,
             last_updated_by, last_updated_on, outstanding_amount,
             securezip_password
        FROM provider
       WHERE provider_id = provider_id_in;

      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getlearnerproviderrecord : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getlearnerproviderrecord;

   PROCEDURE updatelearnerproviderrecord (
      provider_id_in              IN       VARCHAR2,
      provider_name_in            IN       VARCHAR2,
      provider_house_in           IN       VARCHAR2,
      provider_addr_l1_in         IN       VARCHAR2,
      provider_addr_l2_in         IN       VARCHAR2,
      provider_addr_l3_in         IN       VARCHAR2,
      provider_addr_l4_in         IN       VARCHAR2,
      provider_post_code_in       IN       VARCHAR2,
      provider_tel_no_in          IN       VARCHAR2,
      provider_fax_no_in          IN       VARCHAR2,
      bank_sort_code_in           IN       VARCHAR2,
      bank_account_no_in          IN       VARCHAR2,
      main_contact_name_in        IN       VARCHAR2,
      main_contact_position_in    IN       VARCHAR2,
      main_contact_house_in       IN       VARCHAR2,
      main_contact_addr_l1_in     IN       VARCHAR2,
      main_contact_addr_l2_in     IN       VARCHAR2,
      main_contact_addr_l3_in     IN       VARCHAR2,
      main_contact_addr_l4_in     IN       VARCHAR2,
      main_contact_post_code_in   IN       VARCHAR2,
      main_contact_tel_no_in      IN       VARCHAR2,
      main_contact_fax_no_in      IN       VARCHAR2,
      main_contact_email_in       IN       VARCHAR2,
      fin_contact_name_in         IN       VARCHAR2,
      fin_contact_position_in     IN       VARCHAR2,
      fin_contact_house_in        IN       VARCHAR2,
      fin_contact_addr_l1_in      IN       VARCHAR2,
      fin_contact_addr_l2_in      IN       VARCHAR2,
      fin_contact_addr_l3_in      IN       VARCHAR2,
      fin_contact_addr_l4_in      IN       VARCHAR2,
      fin_contact_post_code_in    IN       VARCHAR2,
      fin_contact_tel_no_in       IN       VARCHAR2,
      fin_contact_fax_no_in       IN       VARCHAR2,
      fin_contact_email_in        IN       VARCHAR2,
      suspend_payments_in         IN       VARCHAR2,
      suspend_letters_in          IN       VARCHAR2,
      prov_type_id_in             IN       VARCHAR2,
      prov_status_id_in           IN       VARCHAR2,
      last_updated_by_in          IN       VARCHAR2,
      outstanding_amount_in       IN       VARCHAR2,
      securezip_password_in       IN       VARCHAR2,
      error_boolean               OUT      VARCHAR2,
      ERROR_TEXT                  OUT      VARCHAR2,
      row_count                   OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE provider p
         SET p.provider_name = NVL (provider_name_in, p.provider_name),
             p.provider_house_no_or_name =
                          NVL (provider_house_in, p.provider_house_no_or_name),
             p.provider_addr_l1 =
                                 NVL (provider_addr_l1_in, p.provider_addr_l1),
             p.provider_addr_l2 =
                                 NVL (provider_addr_l2_in, p.provider_addr_l2),
             p.provider_addr_l3 =
                                 NVL (provider_addr_l3_in, p.provider_addr_l3),
             p.provider_addr_l4 =
                                 NVL (provider_addr_l4_in, p.provider_addr_l4),
             p.provider_post_code =
                             NVL (provider_post_code_in, p.provider_post_code),
             p.provider_tel_no = NVL (provider_tel_no_in, p.provider_tel_no),
             p.provider_fax_no = NVL (provider_fax_no_in, p.provider_fax_no),
             p.bank_sort_code = NVL (bank_sort_code_in, p.bank_sort_code),
             p.bank_account_no = NVL (bank_account_no_in, p.bank_account_no),
             p.main_contact_name =
                               NVL (main_contact_name_in, p.main_contact_name),
             p.main_contact_position =
                       NVL (main_contact_position_in, p.main_contact_position),
             p.main_contact_house_no_or_name =
                  NVL (main_contact_house_in, p.main_contact_house_no_or_name),
             p.main_contact_addr_l1 =
                         NVL (main_contact_addr_l1_in, p.main_contact_addr_l1),
             p.main_contact_addr_l2 =
                         NVL (main_contact_addr_l2_in, p.main_contact_addr_l2),
             p.main_contact_addr_l3 =
                         NVL (main_contact_addr_l3_in, p.main_contact_addr_l3),
             p.main_contact_addr_l4 =
                         NVL (main_contact_addr_l4_in, p.main_contact_addr_l4),
             p.main_contact_post_code =
                     NVL (main_contact_post_code_in, p.main_contact_post_code),
             p.main_contact_tel_no =
                           NVL (main_contact_tel_no_in, p.main_contact_tel_no),
             p.main_contact_fax_no =
                           NVL (main_contact_fax_no_in, p.main_contact_fax_no),
             p.main_contact_email =
                             NVL (main_contact_email_in, p.main_contact_email),
             p.fin_contact_name =
                                 NVL (fin_contact_name_in, p.fin_contact_name),
             p.fin_contact_position =
                         NVL (fin_contact_position_in, p.fin_contact_position),
             p.fin_contact_house_no_or_name =
                    NVL (fin_contact_house_in, p.fin_contact_house_no_or_name),
             p.fin_contact_addr_l1 =
                           NVL (fin_contact_addr_l1_in, p.fin_contact_addr_l1),
             p.fin_contact_addr_l2 =
                           NVL (fin_contact_addr_l2_in, p.fin_contact_addr_l2),
             p.fin_contact_addr_l3 =
                           NVL (fin_contact_addr_l3_in, p.fin_contact_addr_l3),
             p.fin_contact_addr_l4 =
                           NVL (fin_contact_addr_l4_in, p.fin_contact_addr_l4),
             p.fin_contact_post_code =
                       NVL (fin_contact_post_code_in, p.fin_contact_post_code),
             p.fin_contact_tel_no =
                             NVL (fin_contact_tel_no_in, p.fin_contact_tel_no),
             p.fin_contact_fax_no =
                             NVL (fin_contact_fax_no_in, p.fin_contact_fax_no),
             p.fin_contact_email =
                               NVL (fin_contact_email_in, p.fin_contact_email),
             p.suspend_payments =
                                 NVL (suspend_payments_in, p.suspend_payments),
             p.suspend_letters = NVL (suspend_letters_in, p.suspend_letters),
             p.prov_type_id = NVL (prov_type_id_in, p.prov_type_id),
             p.prov_status_id = NVL (prov_status_id_in, p.prov_status_id),
             p.last_updated_by =
                           NVL (UPPER (last_updated_by_in), p.last_updated_by),
             p.last_updated_on = SYSDATE,
             p.outstanding_amount =
                                NVL (outstanding_amount, p.outstanding_amount),
             p.securezip_password = securezip_password_in
       WHERE p.provider_id = provider_id_in;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : updatelearnerproviderrecord : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END updatelearnerproviderrecord;

   PROCEDURE getprovidertypelist (
      io_cursor       IN OUT   providertype_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      pt_cursor   providertype_cursor;
   BEGIN
      OPEN pt_cursor FOR
         SELECT prov_type_id ID, prov_type_desc description
           FROM provider_type;

      io_cursor := pt_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : updatelearnerproviderrecord : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getprovidertypelist;

   PROCEDURE getproviderstatuslist (
      io_cursor       IN OUT   providerstatus_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      ps_cursor   providerstatus_cursor;
   BEGIN
      OPEN ps_cursor FOR
         SELECT prov_status_id ID, prov_status_desc description
           FROM provider_status;

      io_cursor := ps_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : updatelearnerproviderrecord : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getproviderstatuslist;

   PROCEDURE getnextpaymentdate (
      payment_date    OUT   VARCHAR2,
      error_boolean   OUT   VARCHAR2,
      ERROR_TEXT      OUT   VARCHAR2
   )
   IS
   BEGIN
      SELECT TO_CHAR (MIN (bacs_run_date), 'DD MON YYYY')
        INTO payment_date
        FROM bacs_run
       WHERE bacs_run_date > SYSDATE;

      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getnextpaymentdate : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getnextpaymentdate;

   PROCEDURE getlatestproviderreportdates (
      provider_id_in             IN       VARCHAR2,
      last_payment_report_date   OUT      VARCHAR2,
      last_status_report_date    OUT      VARCHAR2,
      error_boolean              OUT      VARCHAR2,
      ERROR_TEXT                 OUT      VARCHAR2
   )
   IS
   BEGIN
      SELECT TO_CHAR (date_of_report, 'DD MON YYYY')
        INTO last_payment_report_date
        FROM report_history
       WHERE provider_id = provider_id_in AND report_type = 'PAYMENT';

      SELECT TO_CHAR (date_of_report, 'DD MON YYYY')
        INTO last_status_report_date
        FROM report_history
       WHERE provider_id = provider_id_in AND report_type = 'STATUS';

      error_boolean := 'false';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         error_boolean := 'false';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getlatestproviderreportdates : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getlatestproviderreportdates;

   PROCEDURE getproviderpaymentdetails (
      provider_id_in   IN       VARCHAR2,
      io_cursor        IN OUT   providerpayments_cursor,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   )
   IS
      ppd_cursor   providerpayments_cursor;
   BEGIN
      OPEN ppd_cursor FOR
         SELECT provider_payment_id ID,
                TO_CHAR ((SELECT bacs_run_date
                            FROM bacs_run
                           WHERE bacs_run_id = pp.bacs_run_id),
                         'DD MON YYYY'
                        ) run_date,
                total_amount, 'BACS' AS payment_method, pp.bacs_run_id,
                (SELECT payment_desc
                   FROM payment_status
                  WHERE payment_status_id =
                                          pp.payment_status_id)
                                                              payment_status,
                'NO REASON' AS reason, 'N' AS re_issue_payment
           FROM provider_payment pp
          WHERE provider_id = provider_id_in;

      io_cursor := ppd_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getproviderpaymentdetails : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getproviderpaymentdetails;

   PROCEDURE updateproviderpaymentdetails (
      provider_payment_id_in   IN       VARCHAR2,
      payment_method_id_in     IN       VARCHAR2,
      payment_status_id_in     IN       VARCHAR2,
      re_issue_payment_in      IN       VARCHAR2,
      last_updated_by_in       IN       VARCHAR2,
      error_boolean            OUT      VARCHAR2,
      ERROR_TEXT               OUT      VARCHAR2,
      row_count                OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE provider_payment
         SET payment_status_id = payment_status_id_in,
             last_updated_by = UPPER (last_updated_by_in),
             last_updated_on = SYSDATE
       WHERE provider_payment_id = provider_payment_id_in;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : updateproviderpaymentdetails : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END updateproviderpaymentdetails;

   PROCEDURE getpaymentstatuslist (
      io_cursor       IN OUT   payment_status_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      ps_cursor   payment_status_cursor;
   BEGIN
      OPEN ps_cursor FOR
         SELECT payment_status_id ID, payment_desc description
           FROM payment_status;

      io_cursor := ps_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getpaymentstatuslist : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getpaymentstatuslist;

   PROCEDURE getpaymentmethodlist (
      io_cursor       IN OUT   payment_method_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      pm_cursor   payment_method_cursor;
   BEGIN
      OPEN pm_cursor FOR
         SELECT ROWNUM ID, cval description
           FROM ila500_config_data
          WHERE item_name LIKE 'PAYMENT_METHOD%';

      io_cursor := pm_cursor;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getpaymentstatuslist : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getpaymentmethodlist;

   PROCEDURE getlearnercheckdets (
      learner_application_id_in   IN              VARCHAR2,
      learner_id_in               IN              VARCHAR2,
      forenames_out               OUT NOCOPY      VARCHAR2,
      surname_out                 OUT NOCOPY      VARCHAR2,
      dob_out                     OUT NOCOPY      VARCHAR2,
      session_out                 OUT NOCOPY      VARCHAR2,
      error_boolean               OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT l.forename, l.surname, TO_CHAR (l.dob)
        INTO forenames_out, surname_out, dob_out
        FROM learner l
       WHERE UPPER (l.learner_id) = UPPER (learner_id_in);

      IF learner_application_id_in IS NOT NULL
      THEN
         SELECT la.session_year
           INTO session_out
           FROM learner_application la
          WHERE la.learner_application_id = learner_application_id_in;
      END IF;

      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getlearnercheckdets;

   PROCEDURE getprovidername (
      provider_id_in      IN              VARCHAR2,
      provider_name_out   OUT NOCOPY      VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT p.provider_name
        INTO provider_name_out
        FROM provider p
       WHERE p.provider_id = provider_id_in;

      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getprovidername;

   PROCEDURE getproviderdebt (
      provider_id_in   IN       VARCHAR2,
      provider_debt    OUT      VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   )
   IS
   BEGIN
      SELECT outstanding_amount
        INTO provider_debt
        FROM provider
       WHERE provider_id = provider_id_in;

      error_boolean := 'false';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         error_boolean := 'false';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getproviderdebt @ '
            || SYSDATE
            || ' SQLCODE= '
            || SQLCODE
            || ' SQL ERROR = '
            || SQLERRM;
   END getproviderdebt;

   PROCEDURE checkforoutstandingapplication (
      learner_id_in            IN       VARCHAR2,
      count_outstanding_apps   OUT      VARCHAR2,
      error_boolean            OUT      VARCHAR2,
      ERROR_TEXT               OUT      VARCHAR2
   )
   IS
   BEGIN
      SELECT COUNT (learner_id)
        INTO count_outstanding_apps
        FROM raw_data
       WHERE learner_id = learner_id_in;

      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getproviderdebt @ '
            || SYSDATE
            || ' SQLCODE= '
            || SQLCODE
            || ' SQL ERROR = '
            || SQLERRM;
   END checkforoutstandingapplication;
END pk_steps_pt_ui;
/