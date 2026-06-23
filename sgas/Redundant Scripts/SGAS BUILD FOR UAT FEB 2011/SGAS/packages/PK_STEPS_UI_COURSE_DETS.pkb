/* Formatted on 2010/11/03 16:48 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY sgas.pk_steps_ui_course_dets
AS
/******************************************************************************
   NAME:       pk_steps_ui_COURSE_DETS
   PURPOSE:    This package is used to retreive and alter information for the
               portlet project STEPS_UI_CourseDetails

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008      PADDY GRACE Created this package.
******************************************************************************/
   PROCEDURE getcoursedetails (
      stud_crse_year_id_in             IN              VARCHAR2,
      study_commencement_session_out   OUT NOCOPY      VARCHAR2,
      student_type_out                 OUT NOCOPY      VARCHAR2,
      scheme_type_out                  OUT NOCOPY      VARCHAR2,
      application_status_out           OUT NOCOPY      VARCHAR2,
      institution_code_out             OUT NOCOPY      VARCHAR2,
      institution_name_out             OUT NOCOPY      VARCHAR2,
      course_code_out                  OUT NOCOPY      VARCHAR2,
      course_name_out                  OUT NOCOPY      VARCHAR2,
      crse_id_out                      OUT NOCOPY      VARCHAR2,
      education_level_out              OUT NOCOPY      VARCHAR2,
      subject_out                      OUT NOCOPY      VARCHAR2,
      course_year_out                  OUT NOCOPY      VARCHAR2,
      graduation_year_out              OUT NOCOPY      VARCHAR2,
      study_start_date_out             OUT NOCOPY      DATE,
      psas_pt_out                      OUT NOCOPY      VARCHAR2,
      sandwich_paid_out                OUT NOCOPY      VARCHAR2,
      sandwich_unpaid_out              OUT NOCOPY      VARCHAR2,
      repeat_out                       OUT NOCOPY      VARCHAR2,
      course_change_date_out           OUT NOCOPY      DATE,
      withdraw_date_out                OUT NOCOPY      DATE,
      self_funding_out                 OUT NOCOPY      VARCHAR2,
      missing_information_out          OUT NOCOPY      VARCHAR2,
      student_in_attendance_out        OUT NOCOPY      VARCHAR2,
      coa_date_out                     OUT NOCOPY      DATE,
      non_attendance_actioned_out      OUT NOCOPY      VARCHAR2,
      non_attendance_date_out          OUT NOCOPY      DATE,
      z_refusal_status_out             OUT NOCOPY      VARCHAR2,
      z_refusal_date_out               OUT NOCOPY      DATE,
      z_refusal_cancelled_date_out     OUT NOCOPY      DATE,
      bursary_deductions_out           OUT NOCOPY      VARCHAR2,
      ispgce_out                       OUT NOCOPY      VARCHAR2,
      crse_suspend_out                 OUT NOCOPY      VARCHAR2,
      error_boolean                    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                       OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      /*
       * Retreive students stud_crse_year record
       */
      SELECT s.commence_session, scy.dearing,
             scy.scheme_type, scy.application_status, scy.inst_code,
             scy.inst_name, scy.crse_code, scy.crse_name,
             scy.crse_id, scy.pgce_edu_level, scy.pgce_subject,
             scy.crse_year_no, scy.grad_session, scy.start_date,
             scy.psas_pt, scy.paid_sandwich, scy.unpaid_sandwich,
             scy.crse_chg, scy.repeat_year, scy.withdraw_date,
             scy.self_funding, scy.page_incomplete,
             scy.attend_confirmed, scy.hei_date_attended,
             scy.non_att_actioned, scy.non_att_actioned_date,
             scy.z_ref_status, scy.z_ref_date,
             scy.z_ref_proc_date, ss.bursary_deduction,
             scy.pgce, scy.crse_suspend
        INTO study_commencement_session_out, student_type_out,
             scheme_type_out, application_status_out, institution_code_out,
             institution_name_out, course_code_out, course_name_out,
             crse_id_out, education_level_out, subject_out,
             course_year_out, graduation_year_out, study_start_date_out,
             psas_pt_out, sandwich_paid_out, sandwich_unpaid_out,
             course_change_date_out, repeat_out, withdraw_date_out,
             self_funding_out, missing_information_out,
             student_in_attendance_out, coa_date_out,
             non_attendance_actioned_out, non_attendance_date_out,
             z_refusal_status_out, z_refusal_date_out,
             z_refusal_cancelled_date_out, bursary_deductions_out,
             ispgce_out, crse_suspend_out
        FROM stud_crse_year scy, stud_session ss, stud s
       WHERE s.stud_ref_no = scy.stud_ref_no
         AND ss.stud_session_id = scy.stud_session_id
         AND scy.stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getcoursedetails;

   PROCEDURE gettermdates (
      stud_crse_year_id_in   IN              VARCHAR2,
      default_terms_out      OUT NOCOPY      VARCHAR2,
      io_cursor              IN OUT          termdates_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      td_cursor           termdates_cursor;
      temp_crse_year_id   NUMBER (9);
   BEGIN
      /*
       * Retreive students course details, if any
       */
      SELECT scy.crse_year_id
        INTO temp_crse_year_id
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      /*
       * Depending on contents of students course details,
       * return the term dates or an empty resultset
       */
      IF temp_crse_year_id IS NOT NULL
      THEN
         SELECT cy.default_terms
           INTO default_terms_out
           FROM crse_year cy
          WHERE cy.crse_year_id = temp_crse_year_id;

         OPEN td_cursor FOR
            SELECT   ct.term_no AS term_no, ct.start_date AS start_date,
                     ct.end_date AS end_date, ct.days AS days
                FROM crse_term ct
               WHERE ct.crse_year_id = temp_crse_year_id
            ORDER BY ct.term_no;
      ELSE
         OPEN td_cursor FOR
            SELECT '', '', '', ''
              FROM DUAL;
      END IF;

      io_cursor := td_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END gettermdates;

   PROCEDURE getdefaulttermdates (
      inst_code_in      IN              VARCHAR2,
      session_code_in   IN              VARCHAR2,
      io_cursor         IN OUT          default_termdates_cursor,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   )
   IS
      dtd_cursor          default_termdates_cursor;
      temp_crse_year_id   NUMBER (9);
   BEGIN
      /*
       * Retreive the default terms from the institution
       */
      OPEN dtd_cursor FOR
         SELECT it.term_no AS term_no, it.start_date AS start_date,
                it.end_date AS end_date, it.days AS days
           FROM inst_term it
          WHERE it.inst_code = inst_code_in
            AND it.session_code = session_code_in;

      io_cursor := dtd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getdefaulttermdates;

   PROCEDURE getmenuvariables (
      stud_crse_year_id_in   IN              VARCHAR2,
      scheme_type_out        OUT NOCOPY      VARCHAR2,
      session_code_out       OUT NOCOPY      VARCHAR2,
      inst_code_out          OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      /*
       * Retreives the variables for running various services
       */
      SELECT scy.scheme_type, scy.session_code, scy.inst_code
        INTO scheme_type_out, session_code_out, inst_code_out
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getmenuvariables;

   PROCEDURE setcoursedetails (
      stud_crse_year_id_in            IN              VARCHAR2,
      study_commencement_session_in   IN              VARCHAR2,
      application_status_in           IN              VARCHAR2,
      institution_code_in             IN              VARCHAR2,
      course_code_in                  IN              VARCHAR2,
      education_level_in              IN              VARCHAR2,
      subject_in                      IN              VARCHAR2,
      course_year_in                  IN              VARCHAR2,
      study_start_date_in             IN              DATE,
      psas_pt_in                      IN              VARCHAR2,
      sandwich_paid_in                IN              VARCHAR2,
      sandwich_unpaid_in              IN              VARCHAR2,
      course_change_date_in           IN              VARCHAR2,
      repeat_in                       IN              VARCHAR2,
      withdraw_date_in                IN              VARCHAR2,
      self_funding_in                 IN              VARCHAR2,
      missing_information_in          IN              VARCHAR2,
      non_attendance_actioned_in      IN              VARCHAR2,
      non_attendance_date_in          IN              DATE,
      z_refusal_status_in             IN              VARCHAR2,
      z_refusal_date_in               IN              DATE,
      z_refusal_cancelled_date_out    IN              DATE,
      bursary_deductions_in           IN              VARCHAR2,
      ispgce_in                       IN              VARCHAR2,
      crse_suspend_in                 IN              VARCHAR2,
      employee_in                     IN              VARCHAR2,
      error_boolean                   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                      OUT NOCOPY      VARCHAR2
   )
   AS
      temp_inst_code                 VARCHAR (10);
      temp_crse_code                 VARCHAR (10);
      temp_inst_name                 VARCHAR2 (50);
      temp_course_name               VARCHAR2 (50);
      temp_crse_id                   NUMBER (9);
      temp_crse_year_id              NUMBER (9);
      temp_grad_session              NUMBER (4);
      temp_scheme_type               VARCHAR2 (1);
      temp_education_level           VARCHAR2 (10);
      temp_subject                   VARCHAR2 (20);
      checkqual_temp_crse_id         NUMBER (9);
      checkqual_temp_ispgcertdip     VARCHAR (1);
      checkqual_temp_error_boolean   VARCHAR (5);
      checkqual_temp_error_text      VARCHAR (50);
      temp_session_code              NUMBER (4);
   BEGIN
      SELECT scy.session_code
        INTO temp_session_code
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      sgas.pk_steps_ui_shared.getinstandcrsedets (temp_session_code,
                                                  institution_code_in,
                                                  course_code_in,
                                                  course_year_in,
                                                  temp_inst_code,
                                                  temp_crse_code,
                                                  temp_inst_name,
                                                  temp_course_name,
                                                  temp_crse_id,
                                                  temp_crse_year_id,
                                                  temp_grad_session,
                                                  temp_scheme_type,
                                                  error_boolean,
                                                  ERROR_TEXT
                                                 );

      /*
      * Check for database errors in
      * the course fields
      */
      IF temp_crse_id IS NOT NULL OR temp_crse_year_id IS NOT NULL
      THEN
         /*
          * Check if the course the student is attending is a PG Cert / Dip
          * and if so, store the given education level and subject for
          * using in the main update statement
          */
         SELECT scy.crse_id
           INTO checkqual_temp_crse_id
           FROM stud_crse_year scy
          WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

         ERROR_TEXT := 'Pre PG check - ';
         sgas.pk_steps_ui_course_dets.ispgcertdip
                                                (checkqual_temp_crse_id,
                                                 checkqual_temp_ispgcertdip,
                                                 checkqual_temp_error_boolean,
                                                 checkqual_temp_error_text
                                                );

         IF checkqual_temp_ispgcertdip = 'N'
         THEN
            temp_education_level := NULL;
            temp_subject := NULL;
         ELSE
            temp_education_level := education_level_in;
            temp_subject := subject_in;
         END IF;
      END IF;

      ERROR_TEXT := 'Post PG check - ';

      /*
       * Update the students course year record
       *
       */
      UPDATE stud_crse_year scy
         SET scy.application_status = UPPER (application_status_in),
             scy.inst_code = UPPER (temp_inst_code),
             scy.inst_name = UPPER (temp_inst_name),
             scy.crse_code = UPPER (temp_crse_code),
             scy.crse_name = UPPER (temp_course_name),
             scy.crse_id = temp_crse_id,
             scy.crse_year_id = temp_crse_year_id,
             scy.scheme_type = UPPER (temp_scheme_type),
             scy.pgce_edu_level = UPPER (temp_education_level),
             scy.pgce_subject = UPPER (temp_subject),
             scy.crse_year_no = UPPER (course_year_in),
             scy.grad_session = NVL (temp_grad_session, scy.grad_session),
             scy.start_date = study_start_date_in,
             scy.psas_pt = UPPER (psas_pt_in),
             scy.paid_sandwich = UPPER (sandwich_paid_in),
             scy.unpaid_sandwich = UPPER (sandwich_unpaid_in),
             scy.crse_chg = course_change_date_in,
             scy.repeat_year = UPPER (repeat_in),
             scy.withdraw_date = withdraw_date_in,
             scy.self_funding = UPPER (self_funding_in),
             scy.page_incomplete = UPPER (missing_information_in),
             scy.non_att_actioned = UPPER (non_attendance_actioned_in),
             scy.non_att_actioned_date = non_attendance_date_in,
             scy.z_ref_status = UPPER (z_refusal_status_in),
             scy.z_ref_date = z_refusal_date_in,
             scy.z_ref_proc_date = z_refusal_cancelled_date_out,
             scy.pgce = UPPER (ispgce_in),
             scy.crse_suspend = UPPER (crse_suspend_in),
             scy.last_updated_by = employee_in,
             scy.last_updated_on = SYSDATE
       WHERE stud_crse_year_id = stud_crse_year_id_in;

      ERROR_TEXT := 'Post Student Course Year Update - ';

      /*
      * Update bursary deductions
      *
      */
      UPDATE stud_session ss
         SET ss.bursary_deduction = bursary_deductions_in
       WHERE ss.stud_session_id IN (
                                SELECT scy.stud_session_id
                                  FROM stud_crse_year scy
                                 WHERE stud_crse_year_id =
                                                          stud_crse_year_id_in);

      ERROR_TEXT := 'Post Student Session Update - ';

      /*
       * Update the students commencement session
       *
       */
      UPDATE stud s
         SET s.commence_session = study_commencement_session_in
       WHERE s.stud_ref_no =
                         (SELECT scy.stud_ref_no
                            FROM stud_crse_year scy
                           WHERE scy.stud_crse_year_id = stud_crse_year_id_in);

      ERROR_TEXT := 'Post Commencement Update - ';
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setcoursedetails;

   PROCEDURE ispgcertdip (
      crse_id_in        IN              VARCHAR2,
      ispgcertdip_out   OUT             VARCHAR,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   )
   AS
      temp_count   VARCHAR2 (1);
   BEGIN
      /*
       * Checks a course id for a QUAL_TYPE beginning
       * PGC or PGD
       */
      SELECT COUNT (c.crse_id)
        INTO temp_count
        FROM crse@grass c
       WHERE (c.qual_type LIKE 'PGC%' OR c.qual_type LIKE 'PGD%')
         AND c.crse_id = crse_id_in;

      IF temp_count = 1
      THEN
         ispgcertdip_out := 'Y';
      ELSE
         ispgcertdip_out := 'N';
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END ispgcertdip;

   PROCEDURE iserasmus (
      stud_crse_year_id_in   IN              VARCHAR2,
      iserasmus_out          OUT             VARCHAR,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      /*
       * Retreive ERASMUS flag from students course year record
       */
      SELECT scy.erasmus
        INTO iserasmus_out
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END iserasmus;

   PROCEDURE islatestscy (
      stud_crse_year_id_in   IN              VARCHAR2,
      islatestscy_out        OUT             VARCHAR,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      /*
       * Retreive latest_crse_ind flag from students course year record
       */
      SELECT scy.latest_crse_ind
        INTO islatestscy_out
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END islatestscy;

   PROCEDURE getnmsb (
      stud_crse_year_id_in     IN              VARCHAR2,
      nmsb_spec_arr_id_out     OUT NOCOPY      VARCHAR2,
      nmsb_spec_arr_type_out   OUT NOCOPY      VARCHAR2,
      start_date_out           OUT NOCOPY      VARCHAR2,
      end_date_out             OUT NOCOPY      VARCHAR2,
      recommence_date_out      OUT NOCOPY      VARCHAR2,
      length_of_spec_arr_out   OUT NOCOPY      VARCHAR2,
      reason_code_out          OUT NOCOPY      VARCHAR2,
      error_boolean            OUT NOCOPY      VARCHAR2,
      ERROR_TEXT               OUT NOCOPY      VARCHAR2
   )
   AS
      temp_stud_ref_no           VARCHAR2 (9);
      temp_session_code          NUMBER (4);
      temp_count_nmsb_spec_arr   NUMBER (1);
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      /*
       * Retreive students reference number from STUD_CRSE_YEAR
       */
      SELECT scy.stud_ref_no, scy.session_code
        INTO temp_stud_ref_no, temp_session_code
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      SELECT COUNT (*)
        INTO temp_count_nmsb_spec_arr
        FROM nmsb_spec_arr nsa
       WHERE nsa.stud_ref_no = temp_stud_ref_no
         AND nsa.session_code = temp_session_code;

      IF temp_count_nmsb_spec_arr > 1
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'More than one NMSB special arrangement exists for this student in session '
            || temp_session_code
            || '. Please contact BSU.';
      ELSE
         /*
          * Retreive students NMSB details
          */
         SELECT nsa.nmsb_spec_arr_id, nsa.nmsb_spec_arr_type,
                nsa.start_date, nsa.end_date, nsa.recommence_date,
                nsa.length_of_spec_arr, nsa.reason_code
           INTO nmsb_spec_arr_id_out, nmsb_spec_arr_type_out,
                start_date_out, end_date_out, recommence_date_out,
                length_of_spec_arr_out, reason_code_out
           FROM nmsb_spec_arr nsa
          WHERE nsa.stud_ref_no = temp_stud_ref_no;
      END IF;

      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getnmsb;

   PROCEDURE setnmsb (
      nmsb_spec_arr_id_in     IN              VARCHAR2,
      nmsb_spec_arr_type_in   IN              VARCHAR2,
      start_date_in           IN              DATE,
      end_date_in             IN              DATE,
      recommence_date_in      IN              DATE,
      reason_code_in          IN              VARCHAR2,
      employee_in             IN              VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   )
   AS
      temp_period_end_date   DATE;
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      IF end_date_in < start_date_in
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'The End date must be after the Start Date';
      ELSIF recommence_date_in < start_date_in
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            'The Recommencement / Continuation Date must be after the Start Date';
      ELSE
         ERROR_TEXT := 'Pre period check';

         /*
          * Find the correct period end date
          */
         IF MONTHS_BETWEEN (end_date_in, recommence_date_in) <= 0
         THEN
            temp_period_end_date := end_date_in;
         ELSE
            temp_period_end_date := recommence_date_in;
         END IF;

         ERROR_TEXT := 'Post period check';

         /*
          * Update the students new NMSB details
          */
         UPDATE nmsb_spec_arr nsa
            SET nsa.nmsb_spec_arr_type = UPPER (nmsb_spec_arr_type_in),
                nsa.start_date = start_date_in,
                nsa.end_date = end_date_in,
                nsa.recommence_date = recommence_date_in,
                nsa.length_of_spec_arr =
                            FLOOR ((temp_period_end_date - start_date_in) / 7),
                nsa.reason_code = reason_code_in,
                nsa.last_updated_by = UPPER (employee_in),
                nsa.last_updated_on = SYSDATE
          WHERE nsa.nmsb_spec_arr_id = nmsb_spec_arr_id_in;

         IF error_boolean = 'false'
         THEN
            ERROR_TEXT := 'none';
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setnmsb;

   PROCEDURE insertnmsb (
      stud_crse_year_id_in    IN              VARCHAR2,
      nmsb_spec_arr_type_in   IN              VARCHAR2,
      start_date_in           IN              DATE,
      end_date_in             IN              DATE,
      recommence_date_in      IN              DATE,
      reason_code_in          IN              VARCHAR2,
      employee_in             IN              VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   )
   AS
      temp_stud_ref_no        NUMBER (10);
      temp_session_code       NUMBER (4);
      temp_nmsb_spec_arr_id   NUMBER (9);
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      SELECT scy.stud_ref_no, scy.session_code
        INTO temp_stud_ref_no, temp_session_code
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      SELECT nmsb_spec_arr_id_seq.NEXTVAL
        INTO temp_nmsb_spec_arr_id
        FROM DUAL;

      ERROR_TEXT := 'Pre insert';

      INSERT INTO nmsb_spec_arr
                  (nmsb_spec_arr_id, stud_ref_no,
                   session_code, last_updated_by, last_updated_on
                  )
           VALUES (temp_nmsb_spec_arr_id, temp_stud_ref_no,
                   temp_session_code, UPPER (employee_in), SYSDATE
                  );

      ERROR_TEXT := 'Pre update procedure execution';
      sgas.pk_steps_ui_course_dets.setnmsb (temp_nmsb_spec_arr_id,
                                            nmsb_spec_arr_type_in,
                                            start_date_in,
                                            end_date_in,
                                            recommence_date_in,
                                            reason_code_in,
                                            employee_in,
                                            error_boolean,
                                            ERROR_TEXT
                                           );

      IF error_boolean = 'false'
      THEN
         ERROR_TEXT := 'none';
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertnmsb;

   PROCEDURE iscurrentlycalculated (
      stud_crse_year_id_in   IN              VARCHAR2,
      iscalculated           OUT             VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   AS
      v_countawardrecords   NUMBER (3);
   BEGIN
      SELECT COUNT (*)
        INTO v_countawardrecords
        FROM award a
       WHERE a.stud_crse_year_id = stud_crse_year_id_in;

      IF v_countawardrecords > 0
      THEN
         iscalculated := 'Y';
      ELSE
         iscalculated := 'N';
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END iscurrentlycalculated;
END pk_steps_ui_course_dets;
/