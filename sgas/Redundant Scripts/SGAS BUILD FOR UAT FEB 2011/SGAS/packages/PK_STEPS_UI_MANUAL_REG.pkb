/* Formatted on 2011/01/31 13:20 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY sgas.pk_steps_ui_manual_reg
AS
/******************************************************************************
   NAME:       pk_steps_ui_MANUAL_REG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        17/11/2008      PADDY GRACE           Created this package.
   1.1        02/12/2009    ABIRAMI CHIDAMBARAM     Code changes
   1.2        10/02/2010    Paddy Grace             Code changes to getstudentprepopdata, added session_code_in
******************************************************************************//*
    * Procedure to populate the manual registration page with student details if found
    */
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
      not_found_boolean   OUT      VARCHAR2
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
      ERROR_TEXT := 'Checking StEPS for Student';

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
         ERROR_TEXT := 'Checking Grass for student';

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
         error_boolean := 'false';
         ERROR_TEXT := 'NEW_STUDENT';
         not_found_boolean := 'true';
      ELSE
         /*
          * Retreive Student Details from Steps Database if Student record is found in Steps
          */
         not_found_boolean := 'false';

         IF (dbase_flag = 'S')
         THEN
            ERROR_TEXT := 'Checking if duplicate session being registered';
            temp_duplicate_session :=
               sgas.pk_steps_ui_manual_reg.checkstudentssessionduplicate
                                                             (stud_ref_no_in,
                                                              session_code_in
                                                             );

            IF temp_duplicate_session = 1
            THEN
               error_boolean := 'true';
               ERROR_TEXT :=
                        'This student is already registered for this session';
            ELSE
               ERROR_TEXT := 'Getting latest session';

               SELECT MAX (ss.stud_session_id)
                 INTO latest_session
                 FROM stud_session ss
                WHERE ss.stud_ref_no = stud_ref_no_in;

               ERROR_TEXT := 'Getting latest course year record';

               SELECT scy.stud_crse_year_id
                 INTO latest_scy
                 FROM stud_crse_year scy
                WHERE scy.stud_session_id = latest_session
                  AND scy.latest_crse_ind = 'Y';

               ERROR_TEXT := 'Getting personal details';

               SELECT ni_no, title, forenames, surname,
                      TO_CHAR (dob, 'dd/MM/yyyy'), sex, marital_status,
                      district_birth_cert_issued, nation_country_code,
                      residence_country_code
                 INTO nino, title, forename, surname,
                      dob, sex, marital_status,
                      birth_district, nationality,
                      residence_country
                 FROM stud
                WHERE stud_ref_no = stud_ref_no_in;

               ERROR_TEXT := 'Getting previous course details';

               SELECT inst_code, crse_code, scheme_type
                 INTO inst_code, course_code, scheme_type
                 FROM stud_crse_year
                WHERE stud_crse_year_id = latest_scy;

               ERROR_TEXT := 'Getting home address';

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
                  ERROR_TEXT := 'Getting Term Address';

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
            ERROR_TEXT := 'Checknig for duplicate session being registered';
            temp_duplicate_session :=
               sgas.pk_steps_ui_manual_reg.checkstudentssessionduplicate
                                                             (stud_ref_no_in,
                                                              session_code_in
                                                             );

            IF temp_duplicate_session = 1
            THEN
               error_boolean := 'true';
               ERROR_TEXT :=
                        'This student is already registered for this session';
            ELSE
               SELECT COUNT (*)
                 INTO v_sessions_registered_in_grass
                 FROM stud_session@grass ss
                WHERE ss.stud_ref_no = stud_ref_no_in;

               IF v_sessions_registered_in_grass = 0
               THEN
                  ERROR_TEXT :=
                         'No session records found in GRASS for this student';
                  inst_code := '';
                  course_code := '';
                  scheme_type := '';
               ELSE
                  ERROR_TEXT := 'Getting latest GRASS session';

                  SELECT MAX (ss.stud_session_id)
                    INTO latest_session
                    FROM stud_session@grass ss
                   WHERE ss.stud_ref_no = stud_ref_no_in;

                  ERROR_TEXT := 'Getting latest GRASS course year';

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

               ERROR_TEXT := 'Getting personal details';

               SELECT ni_no, title, forenames, surname,
                      TO_CHAR (dob, 'dd/MM/yyyy'), sex, marital_status,
                      district_birth_cert_issued, nation_country_code,
                      residence_country_code
                 INTO nino, title, forename, surname,
                      dob, sex, marital_status,
                      birth_district, nationality,
                      residence_country
                 FROM stud@grass
                WHERE stud_ref_no = stud_ref_no_in;

               ERROR_TEXT := 'Getting home address';

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
                  ERROR_TEXT := 'Partial Grass details found ';
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
                  ERROR_TEXT := 'Getting Term Address';

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

   /*
    * Procedure to check for duplicate records based on forename, surname and Date of Birth in both Steps and Grass database
    */
   PROCEDURE checkforduplicate (
      forename_in     IN       VARCHAR2,
      surname_in      IN       VARCHAR2,
      dob_in          IN       DATE,
      io_cursor       IN OUT   dup_cursor,
      is_duplicate    OUT      VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      record_found_count_g   NUMBER;
      record_found_count_s   NUMBER;
      duplicate_cursor       dup_cursor;
   BEGIN
      is_duplicate := 'false';

      SELECT COUNT (*)
        INTO record_found_count_s
        FROM stud
       WHERE UPPER (forenames) = UPPER (forename_in)
         AND UPPER (surname) = UPPER (surname_in)
         AND dob = dob_in;

      SELECT COUNT (*)
        INTO record_found_count_g
        FROM stud@grass
       WHERE UPPER (forenames) = UPPER (forename_in)
         AND UPPER (surname) = UPPER (surname_in)
         AND dob = dob_in;

      IF (record_found_count_s > 0 OR record_found_count_g > 0)
      THEN
         is_duplicate := 'true';
      END IF;

      OPEN duplicate_cursor FOR
         SELECT   stud_ref_no, 'Steps' dbase
             FROM stud
            WHERE UPPER (forenames) = UPPER (forename_in)
              AND UPPER (surname) = UPPER (surname_in)
              AND dob = dob_in
         UNION
         SELECT   stud_ref_no, 'Grass' dbase
             FROM stud@grass
            WHERE UPPER (forenames) = UPPER (forename_in)
              AND UPPER (surname) = UPPER (surname_in)
              AND dob = dob_in
         ORDER BY 2 ASC, 1 ASC;

      io_cursor := duplicate_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : PL SQL Procedure : checkforduplicate : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END checkforduplicate;

   /*
    * Procedure to check for duplicate records based on Student Reference Number in both Steps and Grass database
    */
   PROCEDURE checkdupsrn (
      srn_in          IN       NUMBER,
      is_duplicate    OUT      VARCHAR2,
      dbase           OUT      VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      record_count_g   NUMBER;
      record_count_s   NUMBER;
   BEGIN
      is_duplicate := 'false';

      SELECT COUNT (*)
        INTO record_count_s
        FROM stud
       WHERE stud_ref_no = srn_in;

      SELECT COUNT (*)
        INTO record_count_g
        FROM stud@grass
       WHERE stud_ref_no = srn_in;

      IF (record_count_s > 0)
      THEN
         is_duplicate := 'true';
         dbase := 'Steps';
      END IF;

      IF (record_count_g > 0)
      THEN
         is_duplicate := 'true';
         dbase := 'Grass';
      END IF;

      IF (record_count_s > 0 AND record_count_g > 0)
      THEN
         is_duplicate := 'true';
         dbase := 'Steps';
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : PL SQL Procedure : checkdupsrn : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END checkdupsrn;

   /*
    * Check for Student Reference Number in Steps and Grass and also if the student has got session record in Steps or not
    */
   PROCEDURE checksrnandsession (
      stud_ref_no_in       IN       VARCHAR2,
      session_in           IN       VARCHAR2,
      is_valid_srn         OUT      VARCHAR2,
      has_session_record   OUT      VARCHAR2,
      dbase_flag           OUT      VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   )
   IS
      srn_record_count       NUMBER;
      session_record_count   NUMBER;
   BEGIN
      /*
       * Check firstly for srn in StEPS
       */
      SELECT COUNT (*)
        INTO srn_record_count
        FROM stud
       WHERE stud_ref_no = stud_ref_no_in;

      dbase_flag := 'S';

      /*
       * If no record found , check for srn in GRASS
       */
      IF srn_record_count = 0
      THEN
         SELECT COUNT (*)
           INTO srn_record_count
           FROM stud@grass
          WHERE stud_ref_no = stud_ref_no_in;

         dbase_flag := 'G';
      END IF;

      IF srn_record_count = 0
      THEN
         is_valid_srn := 'false';
         has_session_record := 'false';
      ELSE
         is_valid_srn := 'true';

         SELECT COUNT (*)
           INTO session_record_count
           FROM stud_session
          WHERE stud_ref_no = stud_ref_no_in AND session_code = session_in;

         IF session_record_count = 0
         THEN
            has_session_record := 'false';
         ELSE
            has_session_record := 'true';
         END IF;
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : PL SQL Procedure : checksrnandsession : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END checksrnandsession;

   /*
    * Procedure to insert a new student record or update one if the student already exists in StEPS
    */
   PROCEDURE createstudentrecords (
      stud_ref_no_in         IN       VARCHAR2,
      inst_code_in           IN       VARCHAR2,
      inst_name_in           IN       VARCHAR2,
      crse_code_in           IN       VARCHAR2,
      crse_yr_no_in          IN       VARCHAR2,
      crse_name_in           IN       VARCHAR2,
      scheme_type_in         IN       VARCHAR2,
      session_in             IN       VARCHAR2,
      nino_in                IN       VARCHAR2,
      title_in               IN       VARCHAR2,
      forename_in            IN       VARCHAR2,
      surname_in             IN       VARCHAR2,
      dob_in                 IN       DATE,
      sex_in                 IN       VARCHAR2,
      marital_status_in      IN       VARCHAR2,
      birth_district_in      IN       VARCHAR2,
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
      last_updated_by        IN       VARCHAR2,
      stud_ref_no_out        OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   IS
      new_student             VARCHAR2 (10);
      the_stud_ref_no         NUMBER;
      stud_session_id         NUMBER;
      scottish_cand_id        VARCHAR2 (10);
      current_house_no_name   VARCHAR2 (100);
      current_post_code       VARCHAR2 (20);
      stud_crse_year_id       NUMBER;
      stud_count              NUMBER;
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
                      district_birth_cert_issued, nation_country_code,
                      residence_country_code, bankrupt_flag, addr_corr_flag,
                      payment_method, disabled, commence_session,
                      bank_validate, last_updated_by, last_updated_on
                     )
              VALUES (the_stud_ref_no, UPPER (nino_in), dob_in,
                      UPPER (title_in), UPPER (forename_in),
                      UPPER (surname_in), sex_in, marital_status_in,
                      birth_district_in, nationality_in,
                      residence_country_in, 'N', 'H',
                      'C', 'N', (SELECT cval
                                   FROM config_data
                                  WHERE item_name = 'CURRENT_SESSION'),
                      'N', UPPER (last_updated_by), SYSDATE
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
                         district_birth_cert_issued, nation_country_code,
                         scottish_cand, residence_country_code,
                         bankrupt_flag, addr_corr_flag, payment_method,
                         disabled, commence_session, bank_validate,
                         last_updated_by, last_updated_on
                        )
                 VALUES (the_stud_ref_no, UPPER (nino_in), dob_in,
                         UPPER (title_in), UPPER (forename_in),
                         UPPER (surname_in), sex_in, marital_status_in,
                         birth_district_in, nationality_in,
                         temp_scottish_cand, residence_country_in,
                         'N', 'H', 'C',
                         'N', temp_commence_session, 'N',
                         UPPER (last_updated_by), SYSDATE
                        );
         END IF;
      END IF;

      SELECT sts_stud_session_id_seq.NEXTVAL
        INTO stud_session_id
        FROM DUAL;

      SELECT stcy_stud_crse_year_id_seq.NEXTVAL
        INTO stud_crse_year_id
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
                   last_updated_by, last_updated_on
                  )
           VALUES (stud_session_id, the_stud_ref_no, session_in,
                   UPPER (forename_in), UPPER (surname_in), dob_in, sex_in,
                   '0', 'N', SYSDATE,
                   '0', 'N', '0', '0',
                   '0', 'N', SYSDATE,
                   UPPER (last_updated_by), SYSDATE
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
      ERROR_TEXT := 'Inserting a new STUD_CRSE_YEAR record ';

      SELECT b.campus_code
        INTO temp_fees_campus
        FROM crse@grass a, campus@grass b
       WHERE a.fees_campus = b.campus_id AND a.crse_id = temp_crse_id;

      INSERT INTO stud_crse_year
                  (stud_crse_year_id, stud_session_id, stud_ref_no,
                   inst_code, inst_name, crse_code,
                   crse_year_no, crse_name, crse_id,
                   crse_year_id, grad_session, scheme_type,
                   session_code, latest_crse_ind, fees_campus,
                   award_letter_no, case_complex, entered_date, ara_sent,
                   sal_sent, pal_sent, tel_sent, corres_dest, two_home,
                   owns_home, own_home_rent, inst_change, transfer_cert,
                   unconditional, study_abroad, parent_contrib_exempt,
                   z_ref_status, form_comp, application_status,
                   provisional_case, loan_given, calc_fee, assess_loan,
                   calc_loan, calc_bursary, calc_dep_grant, calc_lpg,
                   calc_lpcg, last_updated_by, last_updated_on
                  )
           VALUES (stud_crse_year_id, stud_session_id, the_stud_ref_no,
                   temp_inst_code, temp_inst_name, temp_crse_code,
                   crse_yr_no_in, temp_course_name, temp_crse_id,
                   temp_crse_year_id, temp_grad_session, temp_scheme_type,
                   session_in, 'Y', temp_fees_campus,
                   0, 0, SYSDATE, 'N',
                   'Y', 'Y', 'Y', 'H', 'N',
                   'N', 'N', 'N', 'N',
                   'Y', 'N', 'N',
                   'N', 'N', 'N',
                   'N', 'D', 'N', 'N',
                   'N', 'N', 'N', 'N',
                   'N', UPPER (last_updated_by), SYSDATE
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
                      post_code, mailsort,
                      last_updated_by, last_updated_on
                     )
              VALUES (the_stud_ref_no, SYSDATE, UPPER (home_house_no_in),
                      UPPER (home_addr_l1_in), UPPER (home_addr_l2_in),
                      UPPER (home_addr_l3_in), UPPER (home_addr_l4_in),
                      UPPER (home_post_code_in), UPPER (home_mailsort_in),
                      UPPER (last_updated_by), SYSDATE
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

            IF (   UPPER (current_house_no_name) != UPPER (home_house_no_in)
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
                            addr_l1, addr_l2,
                            addr_l3, addr_l4,
                            post_code,
                            mailsort,
                            last_updated_by, last_updated_on
                           )
                    VALUES (the_stud_ref_no, SYSDATE,
                            UPPER (home_house_no_in),
                            UPPER (home_addr_l1_in), UPPER (home_addr_l2_in),
                            UPPER (home_addr_l3_in), UPPER (home_addr_l4_in),
                            UPPER (home_post_code_in),
                            UPPER (home_mailsort_in),
                            UPPER (last_updated_by), SYSDATE
                           );
            --Do nothing if data is a match
            END IF;
         ELSIF (stud_count = '0')
         THEN
            ERROR_TEXT := ERROR_TEXT || ' Student not found in StEPS : ';

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
                         UPPER (home_mailsort_in), UPPER (last_updated_by),
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
      IF (new_student = 'true')
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
                      post_code, mailsort,
                      last_updated_by, last_updated_on
                     )
              VALUES (the_stud_ref_no, SYSDATE, UPPER (term_location_in),
                      'P', UPPER (term_house_no_in),
                      UPPER (term_addr_l1_in), UPPER (term_addr_l2_in),
                      UPPER (term_addr_l3_in), UPPER (term_addr_l4_in),
                      UPPER (term_post_code_in), UPPER (term_mailsort_in),
                      UPPER (last_updated_by), SYSDATE
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

            IF (   UPPER (current_house_no_name) != UPPER (term_house_no_in)
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
                            addr_l1, addr_l2,
                            addr_l3, addr_l4,
                            post_code,
                            mailsort,
                            last_updated_by, last_updated_on
                           )
                    VALUES (the_stud_ref_no, SYSDATE,
                            UPPER (term_location_in), 'P',
                            UPPER (term_house_no_in),
                            UPPER (term_addr_l1_in), UPPER (term_addr_l2_in),
                            UPPER (term_addr_l3_in), UPPER (term_addr_l4_in),
                            UPPER (term_post_code_in),
                            UPPER (term_mailsort_in),
                            UPPER (last_updated_by), SYSDATE
                           );
            --Do nothing if data is a match
            END IF;
         ELSIF (stud_count = '0')
         THEN
            ERROR_TEXT := ERROR_TEXT || ' Student not found in StEPS : ';

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
                         UPPER (term_mailsort_in), UPPER (last_updated_by),
                         SYSDATE
                        );
         END IF;
      END IF;

      UPDATE stud s
         SET s.commence_session =
                sgas.pk_steps_utils.f_get_comm_yr (the_stud_ref_no,
                                                   session_in)
       WHERE s.stud_ref_no = the_stud_ref_no;

      IF temp_scottish_cand = '' OR temp_scottish_cand IS NULL
      THEN
         SELECT scottish_cand
           INTO temp_scottish_cand
           FROM stud
          WHERE stud_ref_no = the_stud_ref_no;
      END IF;

      INSERT INTO stud_app_prog
                  (stud_ref_no, slc_ref_no, stud_crse_year_id,
                   session_code, case_status, date_registered
                  )
           VALUES (the_stud_ref_no, temp_scottish_cand, stud_crse_year_id,
                   session_in, 'R', SYSDATE
                  );

      COMMIT;
      stud_ref_no_out := the_stud_ref_no;
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
END pk_steps_ui_manual_reg;
/