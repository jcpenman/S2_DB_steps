CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_coursedetails
AS
/******************************************************************************
   NAME:       pk_steps_ui_COURSEDETAILS
   PURPOSE:    This package is used to retreive and alter information for the
               portlet project STEPS_UI_CourseDetails

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        20/11/2011  PADDY GRACE      Created this package.
   1.1        11/11/2015  E Watson         Removed getsupplementarystatus 
   1.2        29/10/2019  James Baird     Removed the @GRASS for course and institution tables.
******************************************************************************/
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


PROCEDURE getprovcaseflag (
    stud_crse_year_id_in    IN          VARCHAR2,
    provisional_case        OUT NOCOPY  VARCHAR2,
    error_boolean           OUT NOCOPY  VARCHAR2,
    ERROR_TEXT              OUT NOCOPY  VARCHAR2
)
IS
        
BEGIN
        
        SELECT scy.provisional_case 
        INTO provisional_case
        FROM stud_crse_year scy
        WHERE scy.stud_crse_year_id =  stud_crse_year_id_in;

        error_boolean := 'false';
        ERROR_TEXT := 'none';
EXCEPTION

    WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         
END getprovcaseflag;


PROCEDURE updateprovisionalcase (
      stud_session_id_in  IN       VARCHAR2,
      provisional_in      IN       VARCHAR2,
      error_boolean       OUT      VARCHAR2,
      ERROR_TEXT          OUT      VARCHAR2
   )
   IS 
     
   BEGIN
   
      UPDATE STUD_CRSE_YEAR
         SET STUD_CRSE_YEAR.PROVISIONAL_CASE = provisional_in
       WHERE 
              STUD_CRSE_YEAR.STUD_SESSION_ID = stud_session_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;   
     
   EXCEPTION 
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;   
      ROLLBACK;   
   END updateprovisionalcase;   


   PROCEDURE gettermdates (
      stud_crse_year_id_in   IN              VARCHAR2,
      default_terms_out      OUT NOCOPY      VARCHAR2,
      io_cursor              IN OUT          termdates_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      v_count_terms       NUMBER (2);
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

         SELECT COUNT (*)
           INTO v_count_terms
           FROM crse_term ct
          WHERE ct.crse_year_id = temp_crse_year_id;

         IF v_count_terms > 0
         THEN
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

   PROCEDURE getmenuvariables (
      stud_crse_year_id_in   IN              VARCHAR2,
      scheme_type_out        OUT NOCOPY      VARCHAR2,
      session_code_out       OUT NOCOPY      VARCHAR2,
      inst_code_out          OUT NOCOPY      VARCHAR2,
      app_status_out         OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      /*
       * Retreives the variables for running various services
       */
      SELECT scy.scheme_type, scy.session_code, scy.inst_code, scy.application_status
        INTO scheme_type_out, session_code_out, inst_code_out, app_status_out
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

   PROCEDURE getcoursedetails (
      stud_crse_year_id_in             IN              VARCHAR2,
      study_commencement_session_out   OUT NOCOPY      VARCHAR2,
      session_code_out                 OUT NOCOPY      VARCHAR2,
      student_type_out                 OUT NOCOPY      VARCHAR2,
      scheme_type_out                  OUT NOCOPY      VARCHAR2,
      application_status_out           OUT NOCOPY      VARCHAR2,
      institution_code_out             OUT NOCOPY      VARCHAR2,
      course_code_out                  OUT NOCOPY      VARCHAR2,
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
      award_end_reason_out             OUT NOCOPY      NUMBER,
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
      attend_required_out              OUT NOCOPY      VARCHAR2,
      hei_payment_route_out            OUT NOCOPY      VARCHAR2,
      sds_data_consent_out             OUT NOCOPY      VARCHAR2,
      stud_hei_consent_out             OUT NOCOPY      VARCHAR2,
      is_currentlycalculated           OUT NOCOPY      VARCHAR2,
      is_pgcertdip                     OUT NOCOPY      VARCHAR2,
      is_erasmus                       OUT NOCOPY      VARCHAR2,
      is_latestscy                     OUT NOCOPY      VARCHAR2,
      is_psasnonloanfee                OUT NOCOPY      VARCHAR2,
      fee_override_amt_out             OUT NOCOPY      VARCHAR2,
      no_trace_out                     OUT NOCOPY      VARCHAR2,
      comp_jour_out                    OUT NOCOPY      VARCHAR2,
      is_nmsb_absence_out              OUT NOCOPY      VARCHAR2,
      nmsb_absence_return_date_out     OUT NOCOPY      DATE,
      is_covid_extension               OUT NOCOPY      VARCHAR2,       
      is_dsa_only_out                  OUT NOCOPY      VARCHAR2,
      error_boolean                    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                       OUT NOCOPY      VARCHAR2
   )
   IS
      v_countawardrecords   NUMBER (3);
      crse_id_count         VARCHAR2 (1);
   BEGIN
      ERROR_TEXT := 'Main getCourseDetails Query';

      /*
       * Retreive students stud_crse_year record
       */
      SELECT s.commence_session, ss.session_code,
             scy.dearing,
             /*THIS LINE HAS BEEN ADDED TO CONVERT ANY GA STUDENT 
             FROM ENDING UP WITH A 'G' AS THEIR SCHEME_TYPE */
             DECODE(scy.scheme_type, 'G', 'U', 'P', 'P', 'B', 'B', 'U') as SCHEME_TYPE,
             scy.application_status,
             scy.inst_code, scy.crse_code, scy.crse_id,
             scy.pgce_edu_level, scy.pgce_subject, scy.crse_year_no,
             scy.grad_session, scy.start_date, scy.psas_pt,
             scy.paid_sandwich, scy.unpaid_sandwich, scy.crse_chg,
             scy.repeat_year, scy.withdraw_date, scy.nmsb_award_end_reason, scy.self_funding,
             scy.page_incomplete, scy.attend_confirmed,
             scy.hei_date_attended, scy.non_att_actioned,
             scy.non_att_actioned_date, scy.z_ref_status,
             scy.z_ref_date, scy.z_ref_proc_date,
             ss.bursary_deduction, scy.pgce, scy.crse_suspend,
             scy.attend_reqd, scy.hei_payment_route,
             DECODE (ss.sds_data_share, NULL, 'N', 'Y', 'Y', 'N', 'N')AS sds_share_consent, 
             ss.stud_hei_consent,                                                                                                                                       
             scy.latest_crse_ind, scy.erasmus, scy.psas_non_fee_loan,
             scy.variable_fee_override_amount, s.comp_jour,
             scy.nmsb_absence, scy.nmsb_absence_return_date, covid_extension_ind, scy.dsa_only
        INTO study_commencement_session_out, session_code_out,
             student_type_out, scheme_type_out, application_status_out,
             institution_code_out, course_code_out, crse_id_out,
             education_level_out, subject_out, course_year_out,
             graduation_year_out, study_start_date_out, psas_pt_out,
             sandwich_paid_out, sandwich_unpaid_out, course_change_date_out,
             repeat_out, withdraw_date_out, award_end_reason_out, self_funding_out,
             missing_information_out, student_in_attendance_out,
             coa_date_out, non_attendance_actioned_out,
             non_attendance_date_out, z_refusal_status_out,
             z_refusal_date_out, z_refusal_cancelled_date_out,
             bursary_deductions_out, ispgce_out, crse_suspend_out,
             attend_required_out, hei_payment_route_out,
             sds_data_consent_out, stud_hei_consent_out,
             is_latestscy, is_erasmus, is_psasnonloanfee,
             fee_override_amt_out, comp_jour_out,
             is_nmsb_absence_out, nmsb_absence_return_date_out, is_covid_extension, is_dsa_only_out
        FROM stud_crse_year scy, stud_session ss, stud s
       WHERE s.stud_ref_no = scy.stud_ref_no
         AND ss.stud_session_id = scy.stud_session_id
         AND scy.stud_crse_year_id = stud_crse_year_id_in;

      SELECT COUNT (*)
        INTO v_countawardrecords
        FROM award a
       WHERE a.stud_crse_year_id = stud_crse_year_id_in;

      ERROR_TEXT := 'Checking currently calculated';

      IF v_countawardrecords > 0
      THEN
         is_currentlycalculated := 'Y';
      ELSE
         is_currentlycalculated := 'N';
      END IF;

      ERROR_TEXT := 'Checking for PGC/D';

      /*
       * Checks a course id for a QUAL_TYPE beginning
       * PGC or PGD
       */
      SELECT COUNT (c.crse_id)
        INTO crse_id_count
        FROM crse c
       WHERE (c.qual_type LIKE 'PGC%' OR c.qual_type LIKE 'PGD%')
         AND c.crse_id = crse_id_out;

      IF crse_id_count = 1
      THEN
         is_pgcertdip := 'Y';
      ELSE
         is_pgcertdip := 'N';
      END IF;

      ERROR_TEXT := 'Getting NO TRACE';

      SELECT ad.no_trace
        INTO no_trace_out
        FROM attendance_data ad
       WHERE ad.stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || ' : SQLCODE=' || SQLCODE || ' SQL ERROR = '
            || SQLERRM;
   END getcoursedetails;

   PROCEDURE setcoursedetails (
      stud_crse_year_id_in            IN              VARCHAR2,
      study_commencement_session_in   IN              VARCHAR2,
      application_status_in           IN              VARCHAR2,
      institution_code_in             IN              VARCHAR2,
      course_code_in                  IN              VARCHAR2,
      education_level_in              IN              VARCHAR2,
      subject_in                      IN              VARCHAR2,
      course_year_in                  IN              VARCHAR2,
      study_start_date_in             IN              VARCHAR2,
      psas_pt_in                      IN              VARCHAR2,
      sandwich_paid_in                IN              VARCHAR2,
      sandwich_unpaid_in              IN              VARCHAR2,
      course_change_date_in           IN              VARCHAR2,
      repeat_in                       IN              VARCHAR2,
      withdraw_date_in                IN              VARCHAR2,
      award_end_reason_in             IN              VARCHAR2,
      self_funding_in                 IN              VARCHAR2,
      missing_information_in          IN              VARCHAR2,
      non_attendance_actioned_in      IN              VARCHAR2,
      non_attendance_date_in          IN              VARCHAR2,
      z_refusal_status_in             IN              VARCHAR2,
      z_refusal_date_in               IN              VARCHAR2,
      z_refusal_cancelled_date_in     IN              VARCHAR2,
      bursary_deductions_in           IN              VARCHAR2,
      ispgce_in                       IN              VARCHAR2,
      crse_suspend_in                 IN              VARCHAR2,
      hei_payment_route_in            IN              VARCHAR2,
      sds_data_consent_in             IN              VARCHAR2,
      stud_hei_consent_in             IN              VARCHAR2,      
      is_psas_non_fee_loan_in         IN              VARCHAR2,
      variable_fee_override_amt_in    IN              VARCHAR2,
      no_trace_in                     IN              VARCHAR2,
      comp_jour_in                    IN              VARCHAR2,
      employee_in                     IN              VARCHAR2,
      is_nmsb_absence_in              IN              VARCHAR2,
      nmsb_absence_return_date_in     IN              VARCHAR2,
      is_covid_extension_in           IN              VARCHAR2,  
      is_dsa_only_in                     IN              VARCHAR2,
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
      temp_stud_session_id           NUMBER (9);
      temp_count                     NUMBER (1);
      v_no_trace                     VARCHAR2 (1);
   BEGIN
   
      ERROR_TEXT := 'Session code and Id. ' || stud_crse_year_id_in ;
   
      SELECT scy.session_code, scy.stud_session_id
        INTO temp_session_code, temp_stud_session_id
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;  
       
        /* THIS IF STATEMENT TO DEAL WITH GRADUATE APPRENTICE COURSES*/
        IF temp_scheme_type = 'G'
         THEN
            temp_scheme_type := 'U';
        END IF;           

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

      IF temp_inst_code IS NULL
      THEN
         ERROR_TEXT :=
             'Institution code ' || institution_code_in || ' does not exist ';
         error_boolean := 'true';
      ELSE
             /*
         * Check for database errors in
         * the course fields
         */
         IF temp_crse_id IS NOT NULL OR temp_crse_year_id IS NOT NULL
         THEN
            ERROR_TEXT := 'Course id. ' ;
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

                 /*
            * Checks a course id for a QUAL_TYPE beginning
            * PGC or PGD
            */
            SELECT COUNT (c.crse_id)
              INTO temp_count
              FROM crse c
             WHERE (c.qual_type LIKE 'PGC%' OR c.qual_type LIKE 'PGD%')
               AND c.crse_id = checkqual_temp_crse_id;

            IF temp_count = 1
            THEN
               checkqual_temp_ispgcertdip := 'Y';
            ELSE
               checkqual_temp_ispgcertdip := 'N';
            END IF;

            IF checkqual_temp_ispgcertdip = 'N'
            THEN
               temp_education_level := NULL;
               temp_subject := NULL;
            ELSE
               temp_education_level := education_level_in;

               IF temp_education_level = 'S'
               THEN
                  temp_subject := subject_in;
               ELSE
                  temp_subject := NULL;
               END IF;
            END IF;
         END IF;

         ERROR_TEXT := 'Post PG check - ';
         
         
        /* THIS IF STATEMENT TO DEAL WITH GRADUATE APPRENTICE COURSES*/
        IF temp_scheme_type = 'G'
         THEN
            temp_scheme_type := 'U';
        END IF;

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
                scy.grad_session = temp_grad_session,
                scy.start_date = TO_DATE (study_start_date_in, 'dd/mm/yyyy'),
                scy.psas_pt = UPPER (psas_pt_in),
                scy.paid_sandwich = UPPER (sandwich_paid_in),
                scy.unpaid_sandwich = UPPER (sandwich_unpaid_in),
                scy.crse_chg = TO_DATE (course_change_date_in, 'dd/mm/yyyy'),
                scy.repeat_year = UPPER (repeat_in),
                scy.withdraw_date = TO_DATE (withdraw_date_in, 'dd/mm/yyyy'),
                SCY.NMSB_AWARD_END_REASON = UPPER(award_end_reason_in),
                scy.self_funding = UPPER (self_funding_in),
                scy.page_incomplete = UPPER (missing_information_in),
                scy.non_att_actioned = UPPER (non_attendance_actioned_in),
                scy.non_att_actioned_date =
                                TO_DATE (non_attendance_date_in, 'dd/mm/yyyy'),
                scy.z_ref_status = UPPER (z_refusal_status_in),
                scy.z_ref_date = TO_DATE (z_refusal_date_in, 'dd/mm/yyyy'),
                scy.z_ref_proc_date =
                           TO_DATE (z_refusal_cancelled_date_in, 'dd/mm/yyyy'),
                scy.pgce = UPPER (ispgce_in),
                scy.crse_suspend = UPPER (crse_suspend_in),
                scy.hei_payment_route = UPPER (hei_payment_route_in),
                scy.psas_non_fee_loan = UPPER (is_psas_non_fee_loan_in),
                scy.variable_fee_override_amount =
                                          UPPER (variable_fee_override_amt_in),
                scy.nmsb_absence = UPPER (is_nmsb_absence_in),                          
                scy.nmsb_absence_return_date = TO_DATE (nmsb_absence_return_date_in, 'dd/mm/yyyy'),  
                SCY.COVID_EXTENSION_IND = UPPER(is_covid_extension_in), 
                scy.dsa_only = UPPER(is_dsa_only_in),
                scy.last_updated_by = UPPER (employee_in),
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

         UPDATE sgas.stud_session
            SET sgas.stud_session.sds_data_share = sds_data_consent_in,
                sgas.stud_session.stud_hei_consent = stud_hei_consent_in
          WHERE stud_session.stud_session_id = temp_stud_session_id;

         ERROR_TEXT := 'Post Student Session Update - ';

         /*
          * Update the students commencement session
          *
          */
         UPDATE stud s
            SET s.commence_session = study_commencement_session_in,
                s.comp_jour = comp_jour_in
          WHERE s.stud_ref_no =
                         (SELECT scy.stud_ref_no
                            FROM stud_crse_year scy
                           WHERE scy.stud_crse_year_id = stud_crse_year_id_in);

         ERROR_TEXT := 'None';
         error_boolean := 'false';
         COMMIT;
      END IF;

      SELECT ad.no_trace
        INTO v_no_trace
        FROM attendance_data ad
       WHERE ad.stud_crse_year_id = stud_crse_year_id_in;

      IF v_no_trace != no_trace_in
      THEN
         UPDATE attendance_data ad
            SET ad.no_trace = UPPER (no_trace_in),
                ad.chngd_since_last_report = 'Y'
          WHERE ad.stud_crse_year_id = stud_crse_year_id_in;
      END IF;
      
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setcoursedetails;
   
   
   
   
END pk_steps_ui_coursedetails;
/
