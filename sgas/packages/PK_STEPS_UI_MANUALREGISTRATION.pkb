CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_manualregistration
AS
/******************************************************************************
   NAME:       PK_STEPS_UI_ManualRegistration
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        29/08/2011  Paddy Grace      Created this package.
    1.2        29/10/2019  James Baird     Removed the @GRASS for course and institution tables.
   1.3        05/07/2021  Clark Bolan     Debt only feature added
******************************************************************************/
   PROCEDURE getstudentprepopdata (
      stud_ref_no_in      IN       VARCHAR2,
      session_code_in     IN       VARCHAR2,
      nino                OUT      VARCHAR2,
      title               OUT      VARCHAR2,
      forename            OUT      VARCHAR2,
      surname             OUT      VARCHAR2,
      dob                 OUT      VARCHAR2,
      sex                 OUT      VARCHAR2,
      marital_status      OUT      VARCHAR2,
      birth_district      OUT      VARCHAR2,
      birth_country       OUT      VARCHAR2,
      nationality         OUT      VARCHAR2,
      residence_country   OUT      VARCHAR2,
      home_post_code      OUT      VARCHAR2,
      home_house_no       OUT      VARCHAR2,
      home_addr_l1        OUT      VARCHAR2,
      home_addr_l2        OUT      VARCHAR2,
      home_addr_l3        OUT      VARCHAR2,
      home_addr_l4        OUT      VARCHAR2,
      location_ind        OUT      VARCHAR2,
      term_post_code      OUT      VARCHAR2,
      term_house_no       OUT      VARCHAR2,
      term_addr_l1        OUT      VARCHAR2,
      term_addr_l2        OUT      VARCHAR2,
      term_addr_l3        OUT      VARCHAR2,
      term_addr_l4        OUT      VARCHAR2,
      scheme_type         OUT      VARCHAR2,
      inst_code           OUT      VARCHAR2,
      course_code         OUT      VARCHAR2,
      error_boolean       OUT      VARCHAR2,
      ERROR_TEXT          OUT      VARCHAR2,
      is_existing         OUT      VARCHAR2
   )
   IS
      stud_record_count                NUMBER;
      stud_term_count                  NUMBER;
      stud_home_count                  NUMBER;
      dbase_flag                       VARCHAR2 (1);
      latest_session                   VARCHAR2 (10);
      latest_scy                       VARCHAR2 (10);
      temp_duplicate_session           NUMBER (2);
      v_sessions_registered_in_grass   NUMBER (2);
   BEGIN
      /*
       * Check Initially for stud ref no in StEPS Database
       */
      SELECT COUNT (*)
        INTO stud_record_count
        FROM stud
       WHERE stud_ref_no = stud_ref_no_in;

      dbase_flag := 'S';

      /*
       * If no record found , check for stud ref no in GRASS Database
       */
      IF stud_record_count = 0
      THEN
         SELECT COUNT (*)
           INTO stud_record_count
           FROM stud@grass
          WHERE stud_ref_no = stud_ref_no_in;

         dbase_flag := 'G';
      END IF;

      /*
       * If no records are found in GRASS, mark this student as NEW
       */
      IF stud_record_count = 0
      THEN
         IF LENGTH (stud_ref_no_in) > 0
         THEN
            error_boolean := 'true';
            ERROR_TEXT :=
               'The student reference number does not exist in either StEPS or GRASS. Please update or remove before proceeding.';
            is_existing := 'false';
         ELSE
            error_boolean := 'false';
            ERROR_TEXT := 'none';
            is_existing := 'false';
         END IF;
      ELSE
         /*
          * Retreive Student Details from Steps Database if Student record is found in Steps
          */
         is_existing := 'true';

         IF (dbase_flag = 'S')
         THEN
            temp_duplicate_session :=
               sgas.pk_steps_ui_manualregistration.checkstudentssessionduplicate
                                                             (stud_ref_no_in,
                                                              session_code_in
                                                             );

            IF temp_duplicate_session = 1
            THEN
               error_boolean := 'true';
               ERROR_TEXT :=
                        'This student is already registered for this session';
            ELSE
               SELECT MAX (ss.stud_session_id)
                 INTO latest_session
                 FROM stud_session ss
                WHERE ss.stud_ref_no = stud_ref_no_in;

               SELECT scy.stud_crse_year_id
                 INTO latest_scy
                 FROM stud_crse_year scy
                WHERE scy.stud_session_id = latest_session
                  AND scy.latest_crse_ind = 'Y';

               SELECT ni_no, title, forenames, surname,
                      TO_CHAR (dob, 'dd/MM/yyyy'), sex, marital_status,
                      district_birth_cert_issued, birth_country_code,
                      nation_country_code, residence_country_code
                 INTO nino, title, forename, surname,
                      dob, sex, marital_status,
                      birth_district, birth_country,
                      nationality, residence_country
                 FROM stud
                WHERE stud_ref_no = stud_ref_no_in;

               SELECT inst_code, crse_code, scheme_type
                 INTO inst_code, course_code, scheme_type
                 FROM stud_crse_year
                WHERE stud_crse_year_id = latest_scy;

               SELECT post_code, house_no_name, addr_l1,
                      addr_l2, addr_l3, addr_l4
                 INTO home_post_code, home_house_no, home_addr_l1,
                      home_addr_l2, home_addr_l3, home_addr_l4
                 FROM stud_home_addr
                WHERE stud_ref_no = stud_ref_no_in AND end_date IS NULL;

               SELECT COUNT (*)
                 INTO stud_term_count
                 FROM stud_term_addr
                WHERE stud_ref_no = stud_ref_no_in AND end_date IS NULL;

               IF stud_term_count = 1
               THEN
                  SELECT location_ind, post_code, house_no_name,
                         addr_l1, addr_l2, addr_l3,
                         addr_l4
                    INTO location_ind, term_post_code, term_house_no,
                         term_addr_l1, term_addr_l2, term_addr_l3,
                         term_addr_l4
                    FROM stud_term_addr
                   WHERE stud_ref_no = stud_ref_no_in AND end_date IS NULL;
               ELSE
                  location_ind := '';
                  term_post_code := '';
                  term_house_no := '';
                  term_addr_l1 := '';
                  term_addr_l2 := '';
                  term_addr_l3 := '';
                  term_addr_l4 := '';
               END IF;

               error_boolean := 'false';
               ERROR_TEXT := 'none';
            END IF;
         END IF;

         /*
          * Retreive Student Details from Grass Database if Student record is found in Grass
          */
         IF (dbase_flag = 'G')
         THEN
            temp_duplicate_session :=
               sgas.pk_steps_ui_manualregistration.checkstudentssessionduplicate
                                                             (stud_ref_no_in,
                                                              session_code_in
                                                             );

            IF temp_duplicate_session = 1
            THEN
               error_boolean := 'true';
            ELSE
               SELECT COUNT (*)
                 INTO v_sessions_registered_in_grass
                 FROM stud_session@grass ss
                WHERE ss.stud_ref_no = stud_ref_no_in;

               IF v_sessions_registered_in_grass = 0
               THEN
                  inst_code := '';
                  course_code := '';
                  scheme_type := '';
               ELSE
                  SELECT MAX (ss.stud_session_id)
                    INTO latest_session
                    FROM stud_session@grass ss
                   WHERE ss.stud_ref_no = stud_ref_no_in;

                  SELECT scy.stud_crse_year_id
                    INTO latest_scy
                    FROM stud_crse_year@grass scy
                   WHERE scy.stud_session_id = latest_session
                     AND scy.latest_crse_ind = 'Y';

                  SELECT inst_code, crse_code, scheme_type
                    INTO inst_code, course_code, scheme_type
                    FROM stud_crse_year@grass
                   WHERE stud_crse_year_id = latest_scy;
               END IF;

               SELECT ni_no, title, forenames, surname,
                      TO_CHAR (dob, 'dd/MM/yyyy'), sex, marital_status,
                      district_birth_cert_issued, birth_country_code,
                      nation_country_code, residence_country_code
                 INTO nino, title, forename, surname,
                      dob, sex, marital_status,
                      birth_district, birth_country,
                      nationality, residence_country
                 FROM stud@grass
                WHERE stud_ref_no = stud_ref_no_in;

               SELECT COUNT (*)
                 INTO stud_home_count
                 FROM stud_home_addr@grass
                WHERE stud_ref_no = stud_ref_no_in AND end_date IS NULL;

               IF stud_home_count = 1
               THEN
                  SELECT post_code, house_no_name, addr_l1,
                         addr_l2, addr_l3, addr_l4
                    INTO home_post_code, home_house_no, home_addr_l1,
                         home_addr_l2, home_addr_l3, home_addr_l4
                    FROM stud_home_addr@grass
                   WHERE stud_ref_no = stud_ref_no_in AND end_date IS NULL;
               ELSE
                  home_post_code := '';
                  home_house_no := '';
                  home_addr_l1 := '';
                  home_addr_l2 := '';
                  home_addr_l3 := '';
                  home_addr_l4 := '';
               END IF;

               SELECT COUNT (*)
                 INTO stud_term_count
                 FROM stud_term_addr@grass
                WHERE stud_ref_no = stud_ref_no_in AND end_date IS NULL;

               IF stud_term_count = 1
               THEN
                  SELECT location_ind, post_code, house_no_name,
                         addr_l1, addr_l2, addr_l3,
                         addr_l4
                    INTO location_ind, term_post_code, term_house_no,
                         term_addr_l1, term_addr_l2, term_addr_l3,
                         term_addr_l4
                    FROM stud_term_addr@grass
                   WHERE stud_ref_no = stud_ref_no_in AND end_date IS NULL;
               ELSE
                  location_ind := '';
                  term_post_code := '';
                  term_house_no := '';
                  term_addr_l1 := '';
                  term_addr_l2 := '';
                  term_addr_l3 := '';
                  term_addr_l4 := '';
               END IF;

               error_boolean := 'false';

               IF ERROR_TEXT = ''
               THEN
                  ERROR_TEXT := 'none';
               END IF;
            END IF;
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || ' ERROR : PL SQL Procedure : getstudentprepopdata : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getstudentprepopdata;

   PROCEDURE createstudentrecords (
      stud_ref_no_in         IN       VARCHAR2,
      debt_only_in           IN       VARCHAR2,
      nino_in                IN       VARCHAR2,
      title_in               IN       VARCHAR2,
      forename_in            IN       VARCHAR2,
      surname_in             IN       VARCHAR2,
      dob_in                 IN       DATE,
      sex_in                 IN       VARCHAR2,
      marital_status_in      IN       VARCHAR2,
      birth_district_in      IN       VARCHAR2,
      birth_country_in       IN       VARCHAR2,
      nationality_in         IN       VARCHAR2,
      residence_country_in   IN       VARCHAR2,
      home_house_no_in       IN       VARCHAR2,
      home_addr_l1_in        IN       VARCHAR2,
      home_addr_l2_in        IN       VARCHAR2,
      home_addr_l3_in        IN       VARCHAR2,
      home_addr_l4_in        IN       VARCHAR2,
      home_post_code_in      IN       VARCHAR2,
      home_mailsort_in       IN       VARCHAR2,
      term_location_in       IN       VARCHAR2,
      term_house_no_in       IN       VARCHAR2,
      term_addr_l1_in        IN       VARCHAR2,
      term_addr_l2_in        IN       VARCHAR2,
      term_addr_l3_in        IN       VARCHAR2,
      term_addr_l4_in        IN       VARCHAR2,
      term_post_code_in      IN       VARCHAR2,
      term_mailsort_in       IN       VARCHAR2,
      scheme_type_in         IN       VARCHAR2,
      session_in             IN       VARCHAR2,
      inst_code_in           IN       VARCHAR2,
      crse_code_in           IN       VARCHAR2,
      crse_yr_no_in          IN       VARCHAR2,
      employee_in            IN       VARCHAR2,
      stud_ref_no_out        OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   IS
      new_student             VARCHAR2 (10);
      the_stud_ref_no         NUMBER;
      stud_session_id_new     NUMBER;
      scottish_cand_id        VARCHAR2 (10);
      current_house_no_name   VARCHAR2 (100);
      current_post_code       VARCHAR2 (20);
      stud_crse_year_id_new   NUMBER;
      stud_count              NUMBER;
      stud_term_addr_count    NUMBER;
      stud_app_prog_count     NUMBER;
      temp_commence_session   NUMBER;
      temp_scottish_cand      VARCHAR (10);
      temp_inst_code          VARCHAR (10);
      temp_crse_code          VARCHAR (10);
      temp_inst_name          VARCHAR2 (50);
      temp_course_name        VARCHAR2 (50);
      temp_crse_id            NUMBER (9);
      temp_crse_year_id       NUMBER (9);
      temp_grad_session       NUMBER (4);
      temp_scheme_type        VARCHAR2 (1);
      temp_fees_campus        VARCHAR2 (1);
      temp_award_status       VARCHAR2 (1); -- CB 04/06/2014
            
   BEGIN
      new_student := 'false';      
      error_boolean := 'false';
      ERROR_TEXT := 'Inserting ew STUD record ';

      /*
       * Insert new student record into STUD table if stud ref no is left blank
       */
      IF (stud_ref_no_in IS NULL)
      THEN
         new_student := 'true';

         /*
          * Retreive next student reference, stud session
          * and course year ids from sequence
          */
         SELECT st_stud_ref_no_seq.NEXTVAL
           INTO the_stud_ref_no
           FROM DUAL;

         INSERT INTO stud
                     (stud_ref_no, ni_no, dob,
                      title, forenames,
                      surname, sex, marital_status,
                      district_birth_cert_issued, birth_country_code,
                      nation_country_code, residence_country_code,
                      bankrupt_flag, addr_corr_flag, payment_method,
                      disabled, commence_session, bank_validate,
                      last_updated_by, last_updated_on
                     )
              VALUES (the_stud_ref_no, UPPER (nino_in), dob_in,
                      UPPER (title_in), UPPER (forename_in),
                      UPPER (surname_in), sex_in, marital_status_in,
                      birth_district_in, birth_country_in,
                      nationality_in, residence_country_in,
                      'N', 'H', 'C',
                      'N', (SELECT cval
                              FROM config_data
                             WHERE item_name = 'CURRENT_SESSION'), 'N',
                      UPPER (employee_in), SYSDATE
                     );
      ELSIF (stud_ref_no_in IS NOT NULL)
      THEN
         /*
          * If stud ref no has a not null value,
          * check to find if this student exists already in steps database
          * If yes update the details in STUD table
          * If not insert a new record into STUD table.
          */
         ERROR_TEXT := 'Adding continuing STUD record ';

         SELECT COUNT (*)
           INTO stud_count
           FROM stud
          WHERE stud_ref_no = stud_ref_no_in;

         the_stud_ref_no := stud_ref_no_in;
         ERROR_TEXT := 'Updating an existing record ';

         IF (stud_count = '1')
         THEN
            UPDATE stud s
               SET s.ni_no = UPPER (nino_in),
                   s.dob = UPPER (dob_in),
                   s.title = UPPER (title_in),
                   s.forenames = UPPER (forename_in),
                   s.surname = UPPER (surname_in),
                   s.sex = UPPER (sex_in),
                   s.marital_status = UPPER (marital_status_in),
                   s.district_birth_cert_issued = UPPER (birth_district_in),
                   s.birth_country_code = birth_country_in,
                   s.nation_country_code = UPPER (nationality_in),
                   s.residence_country_code = UPPER (residence_country_in)
             WHERE s.stud_ref_no = the_stud_ref_no;
         ELSIF (stud_count = '0')
         THEN
            ERROR_TEXT := 'Adding an new record ';

            SELECT cd.cval
              INTO temp_commence_session
              FROM config_data cd
             WHERE cd.item_name = 'CURRENT_SESSION';

            SELECT scottish_cand
              INTO temp_scottish_cand
              FROM stud@grass
             WHERE stud_ref_no = stud_ref_no_in;

            INSERT INTO stud
                        (stud_ref_no, ni_no, dob,
                         title, forenames,
                         surname, sex, marital_status,
                         district_birth_cert_issued, birth_country_code,
                         nation_country_code, scottish_cand,
                         residence_country_code, bankrupt_flag,
                         addr_corr_flag, payment_method, disabled,
                         commence_session, bank_validate, last_updated_by,
                         last_updated_on
                        )
                 VALUES (the_stud_ref_no, UPPER (nino_in), dob_in,
                         UPPER (title_in), UPPER (forename_in),
                         UPPER (surname_in), sex_in, marital_status_in,
                         birth_district_in, birth_country_in,
                         nationality_in, temp_scottish_cand,
                         residence_country_in, 'N',
                         'H', 'C', 'N',
                         temp_commence_session, 'N', UPPER (employee_in),
                         SYSDATE
                        );
         END IF;
      END IF;

      SELECT sts_stud_session_id_seq.NEXTVAL
        INTO stud_session_id_new
        FROM DUAL;

      SELECT stcy_stud_crse_year_id_seq.NEXTVAL
        INTO stud_crse_year_id_new
        FROM DUAL;

      ERROR_TEXT := 'Inserting a new STUD_SESSION record ';

      /*
       * Insert Stud Record into stud session, stud crse year tables.
       */
      INSERT INTO stud_session
                  (stud_session_id, stud_ref_no, session_code,
                   forenames, surname, dob, sex,
                   loan_request, max_loan_requested, date_applic_received,
                   deducts, ja_case, net_income, pension_income,
                   trust_income, residence_query, document_receipt_date,
                   last_updated_by, last_updated_on, debt_only
                  )
           VALUES (stud_session_id_new, the_stud_ref_no, session_in,
                   UPPER (forename_in), UPPER (surname_in), dob_in, sex_in,
                   '0', 'N', SYSDATE,
                   '0', 'N', '0', '0',
                   '0', 'N', SYSDATE,
                   UPPER (employee_in), SYSDATE, debt_only_in
                  );

      ERROR_TEXT := 'Getting CRSE details ';
      /*
       * Get course and institution info for stud_crse_year table
       */
      sgas.pk_steps_ui_shared.getinstandcrsedets (session_in,
                                                  inst_code_in,
                                                  crse_code_in,
                                                  crse_yr_no_in,
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

      IF error_boolean != 'true'
      THEN
         ERROR_TEXT := 'Inserting a new Course year record.';

         SELECT b.campus_code
           INTO temp_fees_campus
           FROM crse a, campus b
          WHERE a.fees_campus = b.campus_id AND a.crse_id = temp_crse_id;
         

         INSERT INTO stud_crse_year
                     (stud_crse_year_id, stud_session_id,
                      stud_ref_no, inst_code, inst_name,
                      crse_code, crse_year_no, crse_name,
                      crse_id, crse_year_id, grad_session,
                      scheme_type, session_code, latest_crse_ind,
                      fees_campus, award_letter_no, case_complex,
                      entered_date, ara_sent, sal_sent, pal_sent, tel_sent,
                      corres_dest, two_home, owns_home, own_home_rent,
                      inst_change, transfer_cert, unconditional,
                      study_abroad, parent_contrib_exempt, z_ref_status,
                      form_comp, application_status, provisional_case,
                      loan_given, calc_fee, assess_loan, calc_loan,
                      calc_bursary, calc_dep_grant, calc_lpg, calc_lpcg,
                      last_updated_by, last_updated_on
                     )
              VALUES (stud_crse_year_id_new, stud_session_id_new,
                      the_stud_ref_no, temp_inst_code, temp_inst_name,
                      temp_crse_code, crse_yr_no_in, temp_course_name,
                      temp_crse_id, temp_crse_year_id, temp_grad_session,
                      temp_scheme_type, session_in, 'Y',
                      temp_fees_campus, 0, 0,
                      SYSDATE, 'N', 'Y', 'Y', 'Y',
                      'H', 'N', 'N', 'N',
                      'N', 'N', 'Y',
                      'N', 'N', 'N',
                      'N', 'N', 'N',
                      'A', 'N', 'N', 'N',
                      'N', 'N', 'N', 'N', 
                      UPPER (employee_in), SYSDATE
                     );
                     

         ERROR_TEXT := 'Inserting a new ATTENDANCE_DATA record ';

         INSERT INTO sgas.attendance_data
                     (stud_crse_year_id, chngd_since_last_report,
                      enrol_confirmed, enrol_required,
                      ongoing_attendance_confirmed, ongoing_required,
                      enrol_received_date, enrol_applied_date,
                      enrol_updated_by, attend_received_date,
                      attend_applied_date, attend_updated_by,
                      restrict_support_enrol, restrict_payments_enrol,
                      release_payments_enrol, restrict_support_attend,
                      restrict_payments_attend, release_payments_attend,
                      restrict_fee_support_attend, restrict_fee_attend,
                      release_fee_attend
                     )
              VALUES (stud_crse_year_id_new, 'Y',
                      'N', 'Y',
                      'N', 'N',
                      NULL, NULL,
                      NULL, NULL,
                      NULL, NULL,
                      'N', NULL,
                      NULL, 'N',
                      NULL, NULL,
                      'N', NULL,
                      NULL
                     );

         ERROR_TEXT := 'Inserting a new STUD_HOME_ADDR record ';

         /*
          * IF NEW STUDENT, INSERT NEW HOME ADDRESS RECORD
          * IF CONTINUING STUDENT : COMPARE OLD HOME ADDRESS WITH CURRENT ADDRESS, IF SAME DO NOTHING,
          * IF NOT UPDATE OLD ONE END DATE TO PREV DATE AND INSERT NEW ADDRESS
          */
         IF (new_student = 'true')
         THEN
            ERROR_TEXT := ERROR_TEXT || ' New Student : ';

            --INSERT NEW RECORD - END_DATE IS NULL
            INSERT INTO stud_home_addr
                        (stud_ref_no, start_date, house_no_name,
                         addr_l1, addr_l2,
                         addr_l3, addr_l4,
                         post_code,
                         mailsort, last_updated_by,
                         last_updated_on
                        )
                 VALUES (the_stud_ref_no, SYSDATE, UPPER (home_house_no_in),
                         UPPER (home_addr_l1_in), UPPER (home_addr_l2_in),
                         UPPER (home_addr_l3_in), UPPER (home_addr_l4_in),
                         UPPER (home_post_code_in),
                         UPPER (home_mailsort_in), UPPER (employee_in),
                         SYSDATE
                        );
         ELSE
            ERROR_TEXT := ERROR_TEXT || ' Continuing Student : ';

            IF (stud_count = '1')
            THEN
               ERROR_TEXT := ERROR_TEXT || ' Student found in StEPS : ';

               /*
                * Compare STUD_HOME_ADDR address details with those entered update if different
                */
               SELECT house_no_name, post_code
                 INTO current_house_no_name, current_post_code
                 FROM stud_home_addr
                WHERE stud_ref_no = the_stud_ref_no AND end_date IS NULL;

               IF (   UPPER (current_house_no_name) !=
                                                      UPPER (home_house_no_in)
                   OR UPPER (current_post_code) != UPPER (home_post_code_in)
                  )
               THEN
                  ERROR_TEXT :=
                        ERROR_TEXT
                     || ' Address has changed - Updating old address and inserting new address : ';

                  /*
                   * End the current record END_DATE = SYSDATE and INSERT a new record for the new data
                   */
                  UPDATE stud_home_addr
                     SET end_date = (SYSDATE - 1)
                   WHERE stud_ref_no = the_stud_ref_no;

                  INSERT INTO stud_home_addr
                              (stud_ref_no, start_date,
                               house_no_name,
                               addr_l1,
                               addr_l2,
                               addr_l3,
                               addr_l4,
                               post_code,
                               mailsort, last_updated_by,
                               last_updated_on
                              )
                       VALUES (the_stud_ref_no, SYSDATE,
                               UPPER (home_house_no_in),
                               UPPER (home_addr_l1_in),
                               UPPER (home_addr_l2_in),
                               UPPER (home_addr_l3_in),
                               UPPER (home_addr_l4_in),
                               UPPER (home_post_code_in),
                               UPPER (home_mailsort_in), UPPER (employee_in),
                               SYSDATE
                              );
               --Do nothing if data is a match
               END IF;
            ELSIF (stud_count = '0')
            THEN
               ERROR_TEXT := ERROR_TEXT || ' Student not found in StEPS : ';

               INSERT INTO stud_home_addr
                           (stud_ref_no, start_date,
                            house_no_name,
                            addr_l1,
                            addr_l2,
                            addr_l3,
                            addr_l4,
                            post_code,
                            mailsort, last_updated_by,
                            last_updated_on
                           )
                    VALUES (the_stud_ref_no, SYSDATE,
                            UPPER (home_house_no_in),
                            UPPER (home_addr_l1_in),
                            UPPER (home_addr_l2_in),
                            UPPER (home_addr_l3_in),
                            UPPER (home_addr_l4_in),
                            UPPER (home_post_code_in),
                            UPPER (home_mailsort_in), UPPER (employee_in),
                            SYSDATE
                           );
            END IF;
         END IF;

         ERROR_TEXT := 'Inserting a new STUD_TERM_ADDR record ';

         /*
          * IF NEW STUDENT, INSERT NEW TERM ADDRESS RECORD
          * IF CONTINUING STUDENT : COMPARE OLD HOME ADDRESS WITH CURRENT ADDRESS, IF SAME DO NOTHING,
          * IF NOT UPDATE OLD ONE END DATE TO PREV DATE AND INSERT NEW ADDRESS
          */
          
         SELECT COUNT (*)
           INTO stud_term_addr_count
           FROM stud_term_addr
          WHERE stud_ref_no = stud_ref_no_in;
          
         IF (new_student = 'true' OR stud_term_addr_count = 0)
         THEN
            ERROR_TEXT := ERROR_TEXT || ' New Student : ';

            /*
             * INSERT NEW RECORD - END_DATE IS NULL
             */
            INSERT INTO stud_term_addr
                        (stud_ref_no, start_date, location_ind,
                         residence_ind, house_no_name,
                         addr_l1, addr_l2,
                         addr_l3, addr_l4,
                         post_code,
                         mailsort, last_updated_by,
                         last_updated_on
                        )
                 VALUES (the_stud_ref_no, SYSDATE, UPPER (term_location_in),
                         'P', UPPER (term_house_no_in),
                         UPPER (term_addr_l1_in), UPPER (term_addr_l2_in),
                         UPPER (term_addr_l3_in), UPPER (term_addr_l4_in),
                         UPPER (term_post_code_in),
                         UPPER (term_mailsort_in), UPPER (employee_in),
                         SYSDATE
                        );
         ELSE
            IF (stud_count = '1')
            THEN
               ERROR_TEXT := ERROR_TEXT || ' Student found in StEPS : ';

               /*
                * Compare STUD_HOME_ADDR address details with those entered update if different
                */
               SELECT house_no_name, post_code
                 INTO current_house_no_name, current_post_code
                 FROM stud_term_addr
                WHERE stud_ref_no = the_stud_ref_no AND end_date IS NULL;

               IF (   UPPER (current_house_no_name) !=
                                                      UPPER (term_house_no_in)
                   OR UPPER (current_post_code) != UPPER (term_post_code_in)
                  )
               THEN
                  ERROR_TEXT :=
                        ERROR_TEXT
                     || ' Address has changed - Updating old address and inserting new address : ';

                  /*
                   * End the current record END_DATE = SYSDATE and INSERT a new record for the new data
                   */
                  UPDATE stud_term_addr
                     SET end_date = (SYSDATE - 1)
                   WHERE stud_ref_no = the_stud_ref_no;

                  INSERT INTO stud_term_addr
                              (stud_ref_no, start_date,
                               location_ind, residence_ind,
                               house_no_name,
                               addr_l1,
                               addr_l2,
                               addr_l3,
                               addr_l4,
                               post_code,
                               mailsort, last_updated_by,
                               last_updated_on
                              )
                       VALUES (the_stud_ref_no, SYSDATE,
                               UPPER (term_location_in), 'P',
                               UPPER (term_house_no_in),
                               UPPER (term_addr_l1_in),
                               UPPER (term_addr_l2_in),
                               UPPER (term_addr_l3_in),
                               UPPER (term_addr_l4_in),
                               UPPER (term_post_code_in),
                               UPPER (term_mailsort_in), UPPER (employee_in),
                               SYSDATE
                              );
               --Do nothing if data is a match
               END IF;
            ELSIF (stud_count = '0')
            THEN
               ERROR_TEXT := ERROR_TEXT || ' Student not found in StEPS : ';

               INSERT INTO stud_term_addr
                           (stud_ref_no, start_date,
                            location_ind, residence_ind,
                            house_no_name,
                            addr_l1,
                            addr_l2,
                            addr_l3,
                            addr_l4,
                            post_code,
                            mailsort, last_updated_by,
                            last_updated_on
                           )
                    VALUES (the_stud_ref_no, SYSDATE,
                            UPPER (term_location_in), 'P',
                            UPPER (term_house_no_in),
                            UPPER (term_addr_l1_in),
                            UPPER (term_addr_l2_in),
                            UPPER (term_addr_l3_in),
                            UPPER (term_addr_l4_in),
                            UPPER (term_post_code_in),
                            UPPER (term_mailsort_in), UPPER (employee_in),
                            SYSDATE
                           );
            END IF;
         END IF;

         UPDATE stud s
            SET s.commence_session =
                   sgas.pk_steps_utils.f_get_comm_yr (the_stud_ref_no,
                                                      session_in
                                                     )
          WHERE s.stud_ref_no = the_stud_ref_no;

         IF temp_scottish_cand = '' OR temp_scottish_cand IS NULL
         THEN
            SELECT scottish_cand
              INTO temp_scottish_cand
              FROM stud
             WHERE stud_ref_no = the_stud_ref_no;
         END IF;

         SELECT COUNT (*)
           INTO stud_app_prog_count
           FROM stud_app_prog sap
          WHERE sap.stud_ref_no = the_stud_ref_no;

         IF stud_app_prog_count = 0
         THEN
            INSERT INTO stud_app_prog
                        (stud_ref_no, slc_ref_no,
                         stud_crse_year_id, session_code, case_status,
                         date_registered
                        )
                 VALUES (the_stud_ref_no, temp_scottish_cand,
                         stud_crse_year_id_new, session_in, 'R',
                         SYSDATE
                        );
         ELSE
            UPDATE stud_app_prog sap
               SET sap.stud_crse_year_id = stud_crse_year_id_new,
                   sap.session_code = session_in,
                   sap.case_status = 'R',
                   sap.date_registered = SYSDATE,
                   sap.award_letter_sent_date = NULL,
                   sap.date_calculated = NULL,
                   sap.dup_award_letter = 0,
                   sap.slc_sent_date = NULL
             WHERE sap.stud_ref_no = the_stud_ref_no;
         END IF;

         COMMIT;
                  --add by clark bolan 04/06/2014

        SELECT SGAS.PK_AWARD_CALCULATION.AWARD_STATUS (stud_crse_year_id_new)
          INTO temp_award_status
          FROM DUAL;

        UPDATE stud_crse_year
           SET award = temp_award_status
         WHERE stud_crse_year_id = stud_crse_year_id_new;
         
         stud_ref_no_out := the_stud_ref_no;
      ELSE
         ROLLBACK;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || '.PL SQL Procedure : createstudentrecords : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
         ROLLBACK;
   END createstudentrecords;

   FUNCTION checkstudentssessionduplicate (
      stud_ref_no_in    IN   VARCHAR2,
      session_code_in   IN   VARCHAR2
   )
      RETURN NUMBER
   IS
      temp_duplicate_session   NUMBER (2);
   BEGIN
      SELECT COUNT (*)
        INTO temp_duplicate_session
        FROM (SELECT scy.session_code
                FROM stud_crse_year@grass scy
               WHERE scy.stud_ref_no = stud_ref_no_in
              UNION
              SELECT scy.session_code
                FROM stud_crse_year scy
               WHERE scy.stud_ref_no = stud_ref_no_in) a
       WHERE session_code_in IN a.session_code;

      RETURN temp_duplicate_session;
   END checkstudentssessionduplicate;
END pk_steps_ui_manualregistration;
/