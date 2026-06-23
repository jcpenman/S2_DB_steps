CREATE OR REPLACE PACKAGE BODY SGAS.shortened_application_web
/*

THIS IS THE SHORTENED APPLICATION SELECTION CRITERIA : pop_shortened_application

*/
IS
   FUNCTION pop_shortened_application (
      p_session_code   IN   stud_session.session_code%TYPE
      --p_logdir         IN   VARCHAR2,
      --p_filename_1     IN   VARCHAR2,
      --p_sid            IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      --
      stud_declaration_rec          stud_declaration_rec_type;
      stud_declaration_output_rec   stud_output_rec_type;
      v_rec_count                   NUMBER (10);
      v_be_rec_count                NUMBER (10);
      v_error_mess                  VARCHAR2 (1024)           := 'No Errors';
      v_indicator_populated         BOOLEAN                   := TRUE;
      --v_file_seq_no                 NUMBER (10);
      --v_tmp_msg                     VARCHAR2 (256)            := NULL;
      v_pams                        VARCHAR2 (1);
      v_process                     BOOLEAN                   := TRUE;
      --v_tempdir                     VARCHAR2 (256)            := NULL;
      --v_return                      VARCHAR2 (20)             := NULL;

      CURSOR stud_recs (p_session_code IN stud_session.session_code%TYPE)
      IS
         SELECT DISTINCT s.stud_ref_no, s.scottish_cand, s.title, s.forenames,
                s.surname, s.addr_corr_flag, s.ni_no, scy.inst_name,
                scy.crse_name, scy.stud_crse_year_id, scy.crse_year_no + 1,
                NVL (s.account_no, s.build_soc_no), s.sort_code, scy.award,
                scy.loan_given, scy.dearing, scy.crse_year_no,
                scy.loan_eligibility_only, ss.loan_request,
                ss.max_loan_requested, scy.inst_code, scy.crse_code,
                s.web_user_id, s.email_addr, ss.stud_session_id
           FROM stud s,
                sgas.stud_crse_year scy,
                sgas.award a,
                sgas.stud_session ss
          WHERE s.stud_ref_no = ss.stud_ref_no
            AND s.web_user_id IS NOT NULL           -- web user id is not null
            AND ss.session_code = p_session_code        -- Session para
            AND scy.session_code = p_session_code       -- Session para
            AND ss.short_app_sent_date IS NULL           -- Short app not recd
            AND ss.stud_session_id = scy.stud_session_id
            AND scy.latest_crse_ind = 'Y'                -- Latest crse ind
            AND (ss.care_leaver IS NULL OR ss.care_leaver = 'N') --new 2017                  
            AND scy.scheme_type = 'U'                         -- Undergraduate
            AND scy.dearing IN ('C', 'D', 'F')               -- Dearing Status
            AND scy.application_status = 'C'                     -- Calculated
            AND scy.session_code < scy.grad_session          -- Not final year
            AND scy.stud_crse_year_id = a.stud_crse_year_id
            AND NOT EXISTS (                        -- Has no other award type
                   SELECT '1'
                     FROM sgas.award a1
                    WHERE a.stud_crse_year_id = a1.stud_crse_year_id
                      AND a1.stud_award_type IN
                             ('ADHOC',
                              'ISB',
                              'PSDSA',
                              'SNB',
                              'SNBDSA',
                              'SNCAP',
                              'SNDA',
                              'SNIE',
                              'SNPE',
                              'SNSPA',
                              'SOSB',
                              'TFEL',
                              'UCMFL',
                              'UCML',
                              'UCNFL',
                              'UCNL',
                              'UDHNFL',
                              'UDHNL',
                              'UDMFL',
                              'UDML',
                              'UDNFL',
                              'UDNL',
                              'UDNXL',
                              'UEMFL',
                              'UEML',
                              'UENFL',
                              'UENL',
                              'UGDA',
                              'UGDSA',
                              'UGOA',
                              'UGSMAH',
                              'YSB'
                             )
                      AND a1.amount > 0)
            AND a.stud_award_type in ('FEES','UGLOAN') --UGLOAN added for COS 2015
            AND (   (a.amount = 0 AND a.net_amount > 0)
                 OR (a.amount > 0 AND a.net_amount = 0)
                 OR (a.amount > 0 AND a.net_amount > 0)
                )
            --AND SCY.AWARD in ('A','B','C'); --Added for COS2015
            AND SCY.student_status = 'NON'; -- Changed15/1
            --Not needed COS 2015    
            --AND s.stud_ref_no NOT IN (
            --       SELECT a.stud_ref_no
            --         FROM sgas.stud_session a
            --        WHERE session_code < p_session_code +1 
            --          AND (a.max_loan_requested = 'Y' OR a.loan_request > 0));
--
   BEGIN
--  Open initial cursor
--
      g_error := FALSE;
      v_rec_count := 0;
      v_be_rec_count := 0;
--  null recs
      initialise_records (stud_declaration_rec, stud_declaration_output_rec);
      v_process := TRUE;

--
      OPEN stud_recs (p_session_code);

      LOOP
         FETCH stud_recs
          INTO stud_declaration_rec.stud_ref_no,
               stud_declaration_rec.stud_slc_ref_no,
               stud_declaration_rec.stud_title,
               stud_declaration_rec.stud_forenames,
               stud_declaration_rec.stud_surname,
               stud_declaration_rec.stud_addr_corr_flag,
               stud_declaration_rec.stud_nino,
               stud_declaration_rec.stud_inst_name,
               stud_declaration_rec.stud_crse_name,
               stud_declaration_rec.stud_crse_year_id,
               stud_declaration_rec.stud_crse_year_no,
               stud_declaration_rec.stud_account_no,
               stud_declaration_rec.stud_sort_code,
               stud_declaration_rec.award, stud_declaration_rec.loan_given,
               stud_declaration_rec.dearing,
               stud_declaration_rec.crse_year_no,
               stud_declaration_rec.loan_eligibility_only,
               stud_declaration_rec.loan_request,
               stud_declaration_rec.max_loan_requested,
               stud_declaration_rec.inst_code,
               stud_declaration_rec.crse_code,
               stud_declaration_rec.stud_web_user_id,
               stud_declaration_rec.stud_email_addr,
               stud_declaration_rec.stud_session_id;

         EXIT WHEN stud_recs%NOTFOUND;
--
         v_pams := 'N';

--
         IF pk_steps_utils.check_pams (stud_declaration_rec.inst_code,
                                       stud_declaration_rec.crse_code
                                      )
         THEN
            v_pams := 'Y';
            v_process := FALSE;
         ELSE
            v_pams := 'N';
         END IF;

--
         IF v_process = TRUE
         THEN
--   Get home details
            IF NOT get_stud_address (stud_declaration_rec, p_session_code)
            THEN
               v_process := FALSE;
            END IF;
         END IF;

--
--
         IF v_process = TRUE
         THEN
--   Get term home location indicator details
            IF NOT get_term_location_ind (stud_declaration_rec,
                                          stud_declaration_output_rec,
                                          p_session_code
                                         )
            THEN
               v_process := FALSE;
            END IF;
         END IF;

--
--
--   Set CSV file support indicator
         v_indicator_populated := TRUE;

--
         IF v_process = TRUE
         THEN
            IF NOT set_support_indicator_nmt (stud_declaration_rec,
                                              v_indicator_populated,
                                              p_session_code
                                             )
            THEN
               v_process := FALSE;
            END IF;
         END IF;

--
-- JM set v_process to false if support indicator is null/false
--
         IF v_process = TRUE
         THEN
            IF v_indicator_populated = FALSE
            THEN
               v_process := FALSE;
            END IF;
         END IF;

--
--  Check if loan bearing and get contact details
-- Design Change 11/02       IF v_process = TRUE AND
-- Design Change 11/02          stud_declaration_rec.type_of_support_ind IS NOT NULL AND  (
-- Design Change 11/02             stud_declaration_rec.type_of_support_ind = 'N' OR
-- Design Change 11/02        stud_declaration_rec.type_of_support_ind = 'B') THEN
--  First contact details
--
         IF v_process = TRUE
         THEN
            IF NOT get_cont_address (g_first_contact,
                                     stud_declaration_rec,
                                     p_session_code
                                    )
            THEN
               v_process := FALSE;
            END IF;
         END IF;

--   Second contact details
         IF v_process = TRUE
         THEN
            IF NOT get_cont_address (g_second_contact,
                                     stud_declaration_rec,
                                     p_session_code
                                    )
            THEN
               v_process := FALSE;
            END IF;
         END IF;

-- Design Change 11/02       ELSE stud_declaration_rec.stud_slc_ref_no := NULL;
-- Design Change 11/02       END IF;
--
-- decode stud_cont1_relation
--
         IF v_process = TRUE
         THEN
            IF NOT get_rel_code (stud_declaration_rec, p_session_code)
            THEN
               v_process := FALSE;
            END IF;
         END IF;

--
--
--    Format and pad the output record only if indicator has been populated correctly
--
         IF v_process = TRUE
         THEN
            IF NOT format_output_record (stud_declaration_rec,
                                         stud_declaration_output_rec,
                                         p_session_code
                                        )
            THEN
               v_process := FALSE;
            END IF;
         END IF;

--
--    Insert into SHORT_APP_STUD_INFO table
--
         IF v_process = TRUE
         THEN
            IF NOT write_short_app_stud_info (stud_declaration_rec,
                                              p_session_code
                                             )
            THEN
               v_process := FALSE;
            END IF;
         END IF;

--
-- Update the stud_session record
--
         IF v_process = TRUE
         THEN
            IF NOT update_stud_session (stud_declaration_rec, p_session_code)
            THEN
               v_process := FALSE;
            END IF;
         END IF;

--
--    Write record to table
--
         IF v_process = TRUE
         THEN
            IF NOT shwap_table_insert (stud_declaration_rec,
                                       stud_declaration_output_rec
                                      )
            THEN
               v_process := FALSE;
            END IF;
         END IF;


-- Update web SHWAP table
-- firewall issue to be resolved

         --   IF v_process = TRUE THEN
--     v_return := transfer_to_web(stud_declaration_rec.stud_crse_year_id);
--     IF v_return = 'FAIL' THEN
--           DBMS_OUTPUT.NEW_LINE;
--            DBMS_OUTPUT.PUT_LINE('Transfer to WEB FAIL');
 --           v_process := FALSE;
--     ELSIF v_return =  'OK' THEN
--            DBMS_OUTPUT.NEW_LINE;
--        DBMS_OUTPUT.PUT_LINE('Transfer to WEB OK');
--     END IF;

         --   END IF;

         --
-- Update NMT count is processed okay
--
         IF v_process = TRUE
         THEN
            v_rec_count := v_rec_count + 1;
            COMMIT;
         ELSE
            ROLLBACK;
         END IF;

--
--  null recs
         initialise_records (stud_declaration_rec,
                             stud_declaration_output_rec);
         v_process := TRUE;
--
      END LOOP;
      
      --Transfer to web
      insert_to_web();
      
      RETURN v_error_mess;
      
   EXCEPTION
      WHEN OTHERS
      THEN
         v_error_mess :=
               'An error has occurred processing student '
            || stud_declaration_rec.stud_ref_no
            || ' in session '
            || p_session_code
            || '. The Error IS AS follows '
            || ' '
            --|| p_sid
            --|| ' '
            || SQLERRM (SQLCODE)
            || ' '
            || SQLERRM
            || ' '
            || SQLCODE;
         ROLLBACK;
         RETURN v_error_mess;
   END;                                                -- Pop_stud_declaration

--
-- RFC178 AM 13/01/05- This function is used to write a record to the SHORT_APP_STUD_INFO table when a record has been successfully written to the output file.
--
   FUNCTION write_short_app_stud_info (
      p_stud_declaration_rec   IN OUT   stud_declaration_rec_type,
      p_session_code           IN       stud_session.session_code%TYPE
   )
      RETURN BOOLEAN
   IS
--
      v_tmp_msg   VARCHAR2 (512) := NULL;
--
   BEGIN
--
      INSERT INTO short_app_stud_info
                  (stud_ref_no, session_code,
                   award,
                   loan_given,
                   dearing,
                   inst_code,
                   crse_code,
                   crse_year_no,
                   loan_eligibility_only,
                   loan_request,
                   max_loan_requested,
                   fees_calculated
                  )
           VALUES (p_stud_declaration_rec.stud_ref_no, p_session_code,
                   p_stud_declaration_rec.award,
                   p_stud_declaration_rec.loan_given,
                   p_stud_declaration_rec.dearing,
                   p_stud_declaration_rec.inst_code,
                   p_stud_declaration_rec.crse_code,
                   p_stud_declaration_rec.crse_year_no,
                   p_stud_declaration_rec.loan_eligibility_only,
                   p_stud_declaration_rec.loan_request,
                   p_stud_declaration_rec.max_loan_requested,
                   p_stud_declaration_rec.fees_calculated
                  );

      RETURN TRUE;
--
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         UPDATE short_app_stud_info
            SET session_code = p_session_code
          WHERE stud_ref_no = p_stud_declaration_rec.stud_ref_no
            AND session_code = p_session_code;

         RETURN TRUE;
      WHEN OTHERS
      THEN
         v_tmp_msg := NULL;
         v_tmp_msg :=
               'Student '
            || p_stud_declaration_rec.stud_ref_no
            || ' in session '
            || p_session_code
            || ' - An error has occurred inserting into the SHORT_APP_STUD_INFO table. '
            || ' The error is as follows: '
            || SQLERRM (SQLCODE);
         RETURN FALSE;
   END write_short_app_stud_info;

--
   FUNCTION update_stud_session (
      p_stud_declaration_rec   IN OUT   stud_declaration_rec_type,
      p_session_code           IN       stud_session.session_code%TYPE
   )
      RETURN BOOLEAN
   IS
--
      v_tmp_msg   VARCHAR2 (512);
--
   BEGIN
--
      UPDATE stud_session
         SET stud_session.short_app_sent_date = TRUNC (SYSDATE)
       WHERE stud_session.stud_ref_no = p_stud_declaration_rec.stud_ref_no
         AND stud_session.session_code = p_session_code;

--
      RETURN TRUE;
--
   EXCEPTION
      WHEN OTHERS
      THEN
         v_tmp_msg := NULL;
         v_tmp_msg :=
               'Student '
            || p_stud_declaration_rec.stud_ref_no
            || ' in session '
            || p_session_code
            || ' - An error has occurred updating the students session details. '
            || ' The error is as follows: '
            || SQLERRM (SQLCODE);
         RETURN FALSE;
   END update_stud_session;

   FUNCTION get_stud_address (
      p_stud_declaration_rec   IN OUT   stud_declaration_rec_type,
      p_session_code           IN       NUMBER
   )
      RETURN BOOLEAN
   IS
--
      v_tmp_msg   VARCHAR2 (512);
--
   BEGIN
--        Get student home details
      SELECT UPPER (house_no_name),
             UPPER (addr_l1),
             UPPER (addr_l2),
             UPPER (addr_l3),
             UPPER (addr_l4),
             UPPER (post_code),
             tele_no
        INTO p_stud_declaration_rec.stud_house_no_name,
             p_stud_declaration_rec.stud_addr_l1,
             p_stud_declaration_rec.stud_addr_l2,
             p_stud_declaration_rec.stud_addr_l3,
             p_stud_declaration_rec.stud_addr_l4,
             p_stud_declaration_rec.stud_post_code,
             p_stud_declaration_rec.stud_tel_no
        FROM stud_home_addr
       WHERE stud_ref_no = p_stud_declaration_rec.stud_ref_no
         AND end_date IS NULL;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_tmp_msg := NULL;
         v_tmp_msg :=
               'Student '
            || p_stud_declaration_rec.stud_ref_no
            || ' in session '
            || p_session_code
            || ' - An error has occurred selecting student home address details '
            || ' The error is as follows: '
            || SQLERRM (SQLCODE);
         RETURN FALSE;
--
   END get_stud_address;

--
--
   FUNCTION get_term_location_ind (
      p_stud_declaration_rec          IN OUT   stud_declaration_rec_type,
      p_stud_declaration_output_rec   IN OUT   stud_output_rec_type,
      p_session_code                  IN       NUMBER
   )
      RETURN BOOLEAN
   IS
--
      v_tmp_msg   VARCHAR2 (512);
--
   BEGIN
--
--   Get term address location_ind
      SELECT location_ind
        INTO p_stud_declaration_rec.stud_location_indicator
        FROM stud_term_addr
       WHERE stud_ref_no = p_stud_declaration_rec.stud_ref_no
         AND end_date IS NULL;

--        decode location_ind
      IF p_stud_declaration_rec.stud_location_indicator IN ('E', 'W')
      THEN
         p_stud_declaration_output_rec.stud_location_indicator := 'ELSEWHERE';
      ELSIF p_stud_declaration_rec.stud_location_indicator IN ('L')
      THEN
         p_stud_declaration_output_rec.stud_location_indicator := 'LONDON';
      ELSE
         p_stud_declaration_output_rec.stud_location_indicator := 'HOME';
      END IF;

--    p_stud_declaration_output_rec.stud_location_indicator := p_stud_declaration_output_rec.stud_location_indicator ;
      RETURN TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_stud_declaration_rec.stud_location_indicator := 'H';
         p_stud_declaration_output_rec.stud_location_indicator := 'HOME';
         RETURN TRUE;
      WHEN OTHERS
      THEN
         v_tmp_msg := NULL;
         v_tmp_msg :=
               'Student '
            || p_stud_declaration_rec.stud_ref_no
            || ' in session '
            || p_session_code
            || '- Check student term address details, the error is as follows: '
            || SQLERRM (SQLCODE);
         RETURN FALSE;
--
   END get_term_location_ind;

--
--
   FUNCTION get_cont_address (
      p_cont_ind               IN       stud_cont_details.contact_ind%TYPE,
      p_stud_declaration_rec   IN OUT   stud_declaration_rec_type,
      p_session_code           IN       NUMBER
   )
      RETURN BOOLEAN
   IS
--
      v_tmp_msg   VARCHAR2 (512);
--
   BEGIN
--
      IF p_cont_ind = 1
      THEN
--        Get student home details (separate function)
         SELECT contact_ind,
                cont_name,
                UPPER (cont_addr1),
                UPPER (cont_addr2),
                UPPER (cont_addr3),
                UPPER (cont_postcode),
                cont_tel_no,
                cont_rel_code
           INTO p_stud_declaration_rec.stud_cont1_ind,
                p_stud_declaration_rec.stud_cont1_name,
                p_stud_declaration_rec.stud_cont1_addr_l1,
                p_stud_declaration_rec.stud_cont1_addr_l2,
                p_stud_declaration_rec.stud_cont1_addr_l3,
                p_stud_declaration_rec.stud_cont1_postcode,
                p_stud_declaration_rec.stud_cont1_tel_no,
                p_stud_declaration_rec.stud_cont1_relation
           FROM stud_cont_details
          WHERE stud_ref_no = p_stud_declaration_rec.stud_ref_no
            AND contact_ind = 1;
--
      ELSE
         SELECT contact_ind,
                cont_name,
                UPPER (cont_addr1),
                UPPER (cont_addr2),
                UPPER (cont_addr3),
                UPPER (cont_postcode),
                cont_tel_no
           INTO p_stud_declaration_rec.stud_cont2_ind,
                p_stud_declaration_rec.stud_cont2_name,
                p_stud_declaration_rec.stud_cont2_addr_l1,
                p_stud_declaration_rec.stud_cont2_addr_l2,
                p_stud_declaration_rec.stud_cont2_addr_l3,
                p_stud_declaration_rec.stud_cont2_postcode,
                p_stud_declaration_rec.stud_cont2_tel_no
           FROM stud_cont_details
          WHERE stud_ref_no = p_stud_declaration_rec.stud_ref_no
            AND contact_ind = 2;
      END IF;

--
      RETURN TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN TRUE;
      WHEN OTHERS
      THEN
         v_tmp_msg := NULL;
         v_tmp_msg :=
               'Student '
            || p_stud_declaration_rec.stud_ref_no
            || ' in session '
            || p_session_code
            || ' - An error has occurred selecting students contact details '
            || ' The error is as follows: '
            || SQLERRM (SQLCODE);
         RETURN FALSE;
--
   END get_cont_address;

--
--
   FUNCTION format_output_record (
      p_stud_declaration_rec          IN OUT   stud_declaration_rec_type,
      p_stud_declaration_output_rec   IN OUT   stud_output_rec_type,
      p_session_code                  IN       NUMBER
   )
      RETURN BOOLEAN
   IS
--
--v_stud_location_indicator
      v_error_mess   VARCHAR2 (256);
      v_tmp_msg      VARCHAR2 (512);
--
   BEGIN
--
      p_stud_declaration_output_rec.type_of_support_ind :=
         NVL (TO_CHAR (p_stud_declaration_rec.type_of_support_ind),
              g_pad_char
             );
      p_stud_declaration_output_rec.stud_ref_no :=
                NVL (TO_CHAR (p_stud_declaration_rec.stud_ref_no), g_pad_char);
      p_stud_declaration_output_rec.stud_slc_ref_no :=
            NVL (TO_CHAR (p_stud_declaration_rec.stud_slc_ref_no), g_pad_char);
      p_stud_declaration_output_rec.stud_title :=
                 NVL (TO_CHAR (p_stud_declaration_rec.stud_title), g_pad_char);
      p_stud_declaration_output_rec.stud_forenames :=
             NVL (TO_CHAR (p_stud_declaration_rec.stud_forenames), g_pad_char);
      p_stud_declaration_output_rec.stud_surname :=
               NVL (TO_CHAR (p_stud_declaration_rec.stud_surname), g_pad_char);
      p_stud_declaration_output_rec.stud_house_no_name :=
         NVL (TO_CHAR (p_stud_declaration_rec.stud_house_no_name), g_pad_char);
      p_stud_declaration_output_rec.stud_addr_l1 :=
               NVL (TO_CHAR (p_stud_declaration_rec.stud_addr_l1), g_pad_char);
      p_stud_declaration_output_rec.stud_addr_l2 :=
               NVL (TO_CHAR (p_stud_declaration_rec.stud_addr_l2), g_pad_char);
      p_stud_declaration_output_rec.stud_addr_l3 :=
               NVL (TO_CHAR (p_stud_declaration_rec.stud_addr_l3), g_pad_char);
      p_stud_declaration_output_rec.stud_addr_l4 :=
               NVL (TO_CHAR (p_stud_declaration_rec.stud_addr_l4), g_pad_char);
      p_stud_declaration_output_rec.stud_post_code :=
             NVL (TO_CHAR (p_stud_declaration_rec.stud_post_code), g_pad_char);
      p_stud_declaration_output_rec.stud_tel_no :=
                NVL (TO_CHAR (p_stud_declaration_rec.stud_tel_no), g_pad_char);
      p_stud_declaration_output_rec.stud_addr_corr_flag :=
         NVL (TO_CHAR (p_stud_declaration_rec.stud_addr_corr_flag),
              g_pad_char);
      p_stud_declaration_output_rec.stud_nino :=
                  NVL (TO_CHAR (p_stud_declaration_rec.stud_nino), g_pad_char);
      p_stud_declaration_output_rec.stud_inst_name :=
             NVL (TO_CHAR (p_stud_declaration_rec.stud_inst_name), g_pad_char);
      p_stud_declaration_output_rec.stud_crse_name :=
             NVL (TO_CHAR (p_stud_declaration_rec.stud_crse_name), g_pad_char);
      p_stud_declaration_output_rec.stud_crse_year_no :=
          NVL (TO_CHAR (p_stud_declaration_rec.stud_crse_year_no), g_pad_char);
      p_stud_declaration_output_rec.stud_account_no :=
            NVL (TO_CHAR (p_stud_declaration_rec.stud_account_no), g_pad_char);
      p_stud_declaration_output_rec.stud_sort_code :=
             NVL (TO_CHAR (p_stud_declaration_rec.stud_sort_code), g_pad_char);
      p_stud_declaration_output_rec.stud_cont1_name :=
            NVL (TO_CHAR (p_stud_declaration_rec.stud_cont1_name), g_pad_char);
      p_stud_declaration_output_rec.stud_cont1_addr_l1 :=
         NVL (TO_CHAR (p_stud_declaration_rec.stud_cont1_addr_l1), g_pad_char);
      p_stud_declaration_output_rec.stud_cont1_addr_l2 :=
         NVL (TO_CHAR (p_stud_declaration_rec.stud_cont1_addr_l2), g_pad_char);
      p_stud_declaration_output_rec.stud_cont1_addr_l3 :=
         NVL (TO_CHAR (p_stud_declaration_rec.stud_cont1_addr_l3), g_pad_char);
      p_stud_declaration_output_rec.stud_cont1_postcode :=
         NVL (TO_CHAR (p_stud_declaration_rec.stud_cont1_postcode),
              g_pad_char);
      p_stud_declaration_output_rec.stud_cont1_tel_no :=
          NVL (TO_CHAR (p_stud_declaration_rec.stud_cont1_tel_no), g_pad_char);
      p_stud_declaration_output_rec.stud_cont2_name :=
            NVL (TO_CHAR (p_stud_declaration_rec.stud_cont2_name), g_pad_char);
      p_stud_declaration_output_rec.stud_cont2_addr_l1 :=
         NVL (TO_CHAR (p_stud_declaration_rec.stud_cont2_addr_l1), g_pad_char);
      p_stud_declaration_output_rec.stud_cont2_addr_l2 :=
         NVL (TO_CHAR (p_stud_declaration_rec.stud_cont2_addr_l2), g_pad_char);
      p_stud_declaration_output_rec.stud_cont2_addr_l3 :=
         NVL (TO_CHAR (p_stud_declaration_rec.stud_cont2_addr_l3), g_pad_char);
      p_stud_declaration_output_rec.stud_cont2_postcode :=
         NVL (TO_CHAR (p_stud_declaration_rec.stud_cont2_postcode),
              g_pad_char);
      p_stud_declaration_output_rec.stud_cont2_tel_no :=
          NVL (TO_CHAR (p_stud_declaration_rec.stud_cont2_tel_no), g_pad_char);
      p_stud_declaration_output_rec.stud_cont1_relation_descript :=
         NVL (TO_CHAR (p_stud_declaration_rec.stud_cont1_relation_descript),
              g_pad_char
             );
      p_stud_declaration_output_rec.stud_web_user_id :=
           NVL (TO_CHAR (p_stud_declaration_rec.stud_web_user_id), g_pad_char);
-- 'nill inserted to ease file_write logic.
      p_stud_declaration_output_rec.stud_email_addr :=
                 NVL (TO_CHAR (p_stud_declaration_rec.stud_email_addr), 'nil');
--
--
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_tmp_msg := NULL;
         v_tmp_msg :=
               'Student '
            || p_stud_declaration_rec.stud_ref_no
            || ' in session '
            || p_session_code
            || ' - An error has occurred formatting student output data, the error is as follows: '
            || SQLERRM (SQLCODE);
         RETURN FALSE;
--
   END format_output_record;                           -- format_output_record

--
--
--
   FUNCTION set_support_indicator_nmt (
      p_stud_declaration_rec   IN OUT   stud_declaration_rec_type,
      p_indicator_populated    IN OUT   BOOLEAN,
      p_session_code           IN       NUMBER
   )
      RETURN BOOLEAN
   IS
--
      v_count_fees_only           NUMBER (10);
      v_count_nmt_only            NUMBER (10);
      v_count_be_fees_loan_only   NUMBER (10);
      v_tmp_msg                   VARCHAR2 (512);
--
   BEGIN
--
      SELECT COUNT (*)
        INTO v_count_fees_only
        FROM award
       WHERE award_src = 'T'
         AND stud_crse_year_id = p_stud_declaration_rec.stud_crse_year_id
         AND (   (NVL (amount, 0) = 0 AND NVL (net_amount, 0) = 0)
              OR (NVL (amount, 0) > 0 AND NVL (net_amount, 0) = 0)
              OR (NVL (amount, 0) > 0 AND NVL (net_amount, 0) > 0)
             );

--
      SELECT COUNT (*)
        INTO v_count_nmt_only
        FROM award
       WHERE stud_crse_year_id = p_stud_declaration_rec.stud_crse_year_id
         --AND (award.stud_award_type IN ('UCNL', 'UDNL')) COS 2015 change 
         AND (award.stud_award_type IN ('UGLOAN'))
         AND award.net_amount IS NOT NULL
         AND award.net_amount > 0;

--
      p_indicator_populated := TRUE;

      IF v_count_fees_only > 0 AND v_count_nmt_only <= 0
      THEN
         p_stud_declaration_rec.type_of_support_ind := 'F';
         p_stud_declaration_rec.fees_calculated := 'Y';
      ELSIF v_count_fees_only <= 0 AND v_count_nmt_only > 0
      THEN
--    p_stud_declaration_rec.type_of_support_ind := 'N';-- Design Change 11/02
         p_stud_declaration_rec.type_of_support_ind := 'B';
         p_stud_declaration_rec.fees_calculated := 'N';
      ELSIF v_count_fees_only > 0 AND v_count_nmt_only > 0
      THEN
         p_stud_declaration_rec.type_of_support_ind := 'B';
         p_stud_declaration_rec.fees_calculated := 'Y';
      ELSE             -- Nothing matched - we don't want to write to the file
         p_indicator_populated := FALSE;
      END IF;

--
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_indicator_populated := FALSE;
         v_tmp_msg := NULL;
         v_tmp_msg :=
               'NMT Student '
            || p_stud_declaration_rec.stud_ref_no
            || ' in session '
            || p_session_code
            || ' - An error has occurred selecting the support indicator for the CSV output file. '
            || ' The error is as follows: '
            || SQLERRM (SQLCODE);
         RETURN FALSE;
   END set_support_indicator_nmt;                       -- end support_ind_nmt

--
--
   FUNCTION get_rel_code (
      p_stud_declaration_rec   IN OUT   stud_declaration_rec_type,
      p_session_code           IN       NUMBER
   )
      RETURN BOOLEAN
   IS
--
      v_tmp_msg   VARCHAR2 (512);
--
   BEGIN
--        Get contact ones relationship (separate function)
      SELECT descript
        INTO p_stud_declaration_rec.stud_cont1_relation_descript
        --  INTO p_stud_declaration_output_rec.stud_cont1_relation
      FROM   VALIDATION
       WHERE TYPE = 'SLC_REL'
         AND cval = p_stud_declaration_rec.stud_cont1_relation;

--
      RETURN TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN TRUE;
      WHEN OTHERS
      THEN
         v_tmp_msg := NULL;
         v_tmp_msg :=
               'Student '
            || p_stud_declaration_rec.stud_ref_no
            || ' in session '
            || p_session_code
            || ' - An error has occurred selecting the students first contact relationship. '
            || ' The error is as follows: '
            || SQLERRM (SQLCODE);
         RETURN FALSE;
--
   END get_rel_code;

   PROCEDURE initialise_records (
      p_stud_declaration_rec          IN OUT   stud_declaration_rec_type,
      p_stud_declaration_output_rec   IN OUT   stud_output_rec_type
   )
   IS
--
   BEGIN
--
      p_stud_declaration_rec.type_of_support_ind := NULL;
      p_stud_declaration_rec.stud_ref_no := NULL;
      p_stud_declaration_rec.stud_slc_ref_no := NULL;
      p_stud_declaration_rec.stud_title := NULL;
      p_stud_declaration_rec.stud_forenames := NULL;
      p_stud_declaration_rec.stud_surname := NULL;
      p_stud_declaration_rec.stud_house_no_name := NULL;
      p_stud_declaration_rec.stud_addr_l1 := NULL;
      p_stud_declaration_rec.stud_addr_l2 := NULL;
      p_stud_declaration_rec.stud_addr_l3 := NULL;
      p_stud_declaration_rec.stud_addr_l4 := NULL;
      p_stud_declaration_rec.stud_post_code := NULL;
      p_stud_declaration_rec.stud_tel_no := NULL;
      p_stud_declaration_rec.stud_addr_corr_flag := NULL;
      p_stud_declaration_rec.stud_nino := NULL;
      p_stud_declaration_rec.stud_inst_name := NULL;
      p_stud_declaration_rec.stud_crse_name := NULL;
      p_stud_declaration_rec.stud_crse_year_id := NULL;
      p_stud_declaration_rec.stud_location_indicator := NULL;
      p_stud_declaration_rec.stud_cont1_relation := NULL;
      p_stud_declaration_rec.stud_cont1_ind := NULL;
      p_stud_declaration_rec.stud_cont2_ind := NULL;
      p_stud_declaration_rec.stud_crse_year_no := NULL;
      p_stud_declaration_rec.stud_account_no := NULL;
      p_stud_declaration_rec.stud_sort_code := NULL;
      p_stud_declaration_rec.stud_cont1_name := NULL;
      p_stud_declaration_rec.stud_cont1_addr_l1 := NULL;
      p_stud_declaration_rec.stud_cont1_addr_l2 := NULL;
      p_stud_declaration_rec.stud_cont1_addr_l3 := NULL;
      p_stud_declaration_rec.stud_cont1_postcode := NULL;
      p_stud_declaration_rec.stud_cont1_tel_no := NULL;
      p_stud_declaration_rec.stud_cont2_name := NULL;
      p_stud_declaration_rec.stud_cont2_addr_l1 := NULL;
      p_stud_declaration_rec.stud_cont2_addr_l2 := NULL;
      p_stud_declaration_rec.stud_cont2_addr_l3 := NULL;
      p_stud_declaration_rec.stud_cont2_postcode := NULL;
      p_stud_declaration_rec.stud_cont2_tel_no := NULL;
      p_stud_declaration_rec.award := NULL;
      p_stud_declaration_rec.loan_given := NULL;
      p_stud_declaration_rec.dearing := NULL;
      p_stud_declaration_rec.crse_year_no := NULL;
      p_stud_declaration_rec.loan_eligibility_only := NULL;
      p_stud_declaration_rec.loan_request := NULL;
      p_stud_declaration_rec.max_loan_requested := NULL;
      p_stud_declaration_rec.inst_code := NULL;
      p_stud_declaration_rec.crse_code := NULL;
      p_stud_declaration_rec.stud_cont1_relation_descript := NULL;
      p_stud_declaration_rec.stud_web_user_id := NULL;
      p_stud_declaration_rec.stud_email_addr := NULL;
      p_stud_declaration_rec.stud_session_id := NULL;
--
      p_stud_declaration_output_rec.type_of_support_ind := NULL;
      p_stud_declaration_output_rec.stud_ref_no := NULL;
      p_stud_declaration_output_rec.stud_slc_ref_no := NULL;
      p_stud_declaration_output_rec.stud_title := NULL;
      p_stud_declaration_output_rec.stud_forenames := NULL;
      p_stud_declaration_output_rec.stud_surname := NULL;
      p_stud_declaration_output_rec.stud_house_no_name := NULL;
      p_stud_declaration_output_rec.stud_addr_l1 := NULL;
      p_stud_declaration_output_rec.stud_addr_l2 := NULL;
      p_stud_declaration_output_rec.stud_addr_l3 := NULL;
      p_stud_declaration_output_rec.stud_addr_l4 := NULL;
      p_stud_declaration_output_rec.stud_post_code := NULL;
      p_stud_declaration_output_rec.stud_tel_no := NULL;
      p_stud_declaration_output_rec.stud_addr_corr_flag := NULL;
      p_stud_declaration_output_rec.stud_nino := NULL;
      p_stud_declaration_output_rec.stud_inst_name := NULL;
      p_stud_declaration_output_rec.stud_crse_name := NULL;
      p_stud_declaration_output_rec.stud_crse_year_no := NULL;
      p_stud_declaration_output_rec.stud_account_no := NULL;
      p_stud_declaration_output_rec.stud_sort_code := NULL;
      p_stud_declaration_output_rec.stud_cont1_relation := NULL;
      p_stud_declaration_output_rec.stud_cont1_name := NULL;
      p_stud_declaration_output_rec.stud_cont1_addr_l1 := NULL;
      p_stud_declaration_output_rec.stud_cont1_addr_l2 := NULL;
      p_stud_declaration_output_rec.stud_cont1_addr_l3 := NULL;
      p_stud_declaration_output_rec.stud_cont1_postcode := NULL;
      p_stud_declaration_output_rec.stud_cont1_tel_no := NULL;
      p_stud_declaration_output_rec.stud_cont2_name := NULL;
      p_stud_declaration_output_rec.stud_cont2_addr_l1 := NULL;
      p_stud_declaration_output_rec.stud_cont2_addr_l2 := NULL;
      p_stud_declaration_output_rec.stud_cont2_addr_l3 := NULL;
      p_stud_declaration_output_rec.stud_cont2_postcode := NULL;
      p_stud_declaration_output_rec.stud_cont2_tel_no := NULL;
      p_stud_declaration_output_rec.stud_cont1_relation_descript := NULL;
      p_stud_declaration_output_rec.stud_web_user_id := NULL;
      p_stud_declaration_output_rec.stud_email_addr := NULL;
      RETURN;
--
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN;
   END;                                                  -- Initialise records

   FUNCTION shwap_table_insert (
      p_stud_declaration_rec          IN   stud_declaration_rec_type,
      p_stud_declaration_output_rec   IN   stud_output_rec_type
   )
      RETURN BOOLEAN
   IS
      v_tmp_msg   VARCHAR2 (512);
   BEGIN
--
      INSERT INTO sgas.shwap
                  (type_of_support_ind,
                   stud_ref_no,
                   stud_slc_ref_no,
                   stud_title,
                   stud_forenames,
                   stud_surname,
                   stud_house_no_name,
                   stud_addr_l1,
                   stud_addr_l2,
                   stud_addr_l3,
                   stud_addr_l4,
                   stud_post_code,
                   stud_tel_no,
                   stud_addr_corr_flag,
                   stud_nino,
                   stud_inst_name,
                   stud_crse_name,
                   stud_crse_year_no,
                   stud_sort_code,
                   stud_account_no,
                   stud_location_indicator,
                   stud_cont1_relation,
                   stud_cont1_name,
                   stud_cont1_addr_l1,
                   stud_cont1_addr_l2,
                   stud_cont1_addr_l3,
                   stud_cont1_postcode,
                   stud_cont1_tel_no,
                   stud_cont2_name,
                   stud_cont2_addr_l1,
                   stud_cont2_addr_l2,
                   stud_cont2_addr_l3,
                   stud_cont2_postcode,
                   stud_cont2_tel_no,
                   award,
                   loan_given,
                   dearing,
                   crse_year_no,
                   loan_eligibility_only,
                   loan_request,
                   max_loan_requested,
                   fees_calculated,
                   inst_code,
                   crse_code,
                   stud_cont1_relation_descript,
                   stud_web_user_id,
                   stud_email_addr,
                   stud_crse_year_id,
                   stud_session_id
                  )
           VALUES (p_stud_declaration_rec.type_of_support_ind,
                   p_stud_declaration_rec.stud_ref_no,
                   p_stud_declaration_rec.stud_slc_ref_no,
                   p_stud_declaration_rec.stud_title,
                   p_stud_declaration_rec.stud_forenames,
                   p_stud_declaration_rec.stud_surname,
                   p_stud_declaration_rec.stud_house_no_name,
                   p_stud_declaration_rec.stud_addr_l1,
                   p_stud_declaration_rec.stud_addr_l2,
                   p_stud_declaration_rec.stud_addr_l3,
                   p_stud_declaration_rec.stud_addr_l4,
                   p_stud_declaration_rec.stud_post_code,
                   p_stud_declaration_rec.stud_tel_no,
                   p_stud_declaration_output_rec.stud_addr_corr_flag,
                   p_stud_declaration_rec.stud_nino,
                   p_stud_declaration_rec.stud_inst_name,
                   p_stud_declaration_rec.stud_crse_name,
                   p_stud_declaration_rec.stud_crse_year_no,
                   p_stud_declaration_rec.stud_sort_code,
                   p_stud_declaration_rec.stud_account_no,
                   p_stud_declaration_rec.stud_location_indicator,
                   p_stud_declaration_rec.stud_cont1_relation,
                   p_stud_declaration_rec.stud_cont1_name,
                   p_stud_declaration_rec.stud_cont1_addr_l1,
                   p_stud_declaration_rec.stud_cont1_addr_l2,
                   p_stud_declaration_rec.stud_cont1_addr_l3,
                   p_stud_declaration_rec.stud_cont1_postcode,
                   p_stud_declaration_rec.stud_cont1_tel_no,
                   p_stud_declaration_rec.stud_cont2_name,
                   p_stud_declaration_rec.stud_cont2_addr_l1,
                   p_stud_declaration_rec.stud_cont2_addr_l2,
                   p_stud_declaration_rec.stud_cont2_addr_l3,
                   p_stud_declaration_rec.stud_cont2_postcode,
                   p_stud_declaration_rec.stud_cont2_tel_no,
                   p_stud_declaration_rec.award,
                   p_stud_declaration_rec.loan_given,
                   p_stud_declaration_rec.dearing,
                   p_stud_declaration_rec.crse_year_no,
                   p_stud_declaration_rec.loan_eligibility_only,
                   p_stud_declaration_rec.loan_request,
                   p_stud_declaration_rec.max_loan_requested,
                   p_stud_declaration_rec.fees_calculated,
                   p_stud_declaration_rec.inst_code,
                   p_stud_declaration_rec.crse_code,
                   p_stud_declaration_rec.stud_cont1_relation_descript,
                   p_stud_declaration_rec.stud_web_user_id,
                   p_stud_declaration_rec.stud_email_addr,
                   p_stud_declaration_rec.stud_crse_year_id,
                   p_stud_declaration_rec.stud_session_id
                  );

      RETURN TRUE;
--
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.put_line ('no records found');
      WHEN DUP_VAL_ON_INDEX
      THEN
         UPDATE shwap
            SET type_of_support_ind =
                                    p_stud_declaration_rec.type_of_support_ind
          WHERE stud_ref_no = p_stud_declaration_rec.stud_ref_no;

         RETURN TRUE;
      WHEN OTHERS
      THEN
         v_tmp_msg := NULL;
         v_tmp_msg :=
               'Student '
            || p_stud_declaration_rec.stud_ref_no
            || ' - An error has occurred inserting into the SHWAP table. '
            || ' The error is as follows: '
            || SQLERRM (SQLCODE);
         DBMS_OUTPUT.put_line (v_tmp_msg);
         RETURN FALSE;
   END;                                                 -- shwap_insert_table;

   PROCEDURE clean_loop
   IS
      v_count         NUMBER                  := 0;
      v_stud_ref_no   stud.stud_ref_no%TYPE   := NULL;
      v_session       NUMBER                  := NULL;

--Get transferred records
      CURSOR fetch_rec
      IS
         SELECT stud_ref_no
           FROM shwap;
--        where stud_ref_no > 59000000;
--
--
   BEGIN
      SELECT cval
        INTO v_session
        FROM config_data
       WHERE item_name = 'CURRENT_SESSION';

      FOR rec IN fetch_rec
      LOOP
         IF rec.stud_ref_no IS NOT NULL
         THEN
            v_stud_ref_no := rec.stud_ref_no;

            UPDATE stud_session
               SET short_app_sent_date = NULL
             WHERE stud_ref_no = rec.stud_ref_no
               AND session_code = TO_CHAR (v_session - 1);

            DELETE FROM short_app_stud_info
                  WHERE stud_ref_no = rec.stud_ref_no
                    AND session_code = TO_CHAR (v_session - 1);

            DELETE FROM shwap
                  WHERE stud_ref_no = rec.stud_ref_no;

--
--TR822 count fix 15/05/2006
            v_count := v_count + 1;
            COMMIT;
         END IF;
      END LOOP;

--
      DBMS_OUTPUT.new_line;
      DBMS_OUTPUT.put_line (' SHWAP Cleaning Completed Successfully');
      DBMS_OUTPUT.new_line;
      DBMS_OUTPUT.put_line (v_count || ' records processed');
--RETURN true;
--
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.new_line;
         DBMS_OUTPUT.put_line
                    (   'Fatal Error in clean_LOOP while processing student '
                     || TO_CHAR (v_stud_ref_no)
                    );
         DBMS_OUTPUT.new_line;
         DBMS_OUTPUT.put_line (TO_CHAR (SQLCODE));
         ROLLBACK;
--            RETURN false;
   END;                                                          -- clean loop

--
   FUNCTION check_inst_crse (
      p_crse_year_no        NUMBER,
      p_inst_code      IN   VARCHAR2,
      p_crse_code      IN   VARCHAR2,
      p_session_code   IN   NUMBER
   )
      RETURN VARCHAR2
   IS
      vcount   NUMBER (2);
   BEGIN
      IF p_crse_year_no < 3
      THEN
         RETURN 'Y';
      ELSE
         SELECT COUNT (*)
           INTO vcount
           FROM short_app_inst_crse
          WHERE inst_code = p_inst_code
            AND crse_code = p_crse_code
            AND session_code = p_session_code;

         IF vcount > 0
         THEN
            RETURN 'N';
         ELSE
            RETURN 'Y';
         END IF;
      END IF;
--
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 'Y';
   END check_inst_crse;
   
/* Transfer SHWAP to web */
   PROCEDURE insert_to_web
      
   IS
   BEGIN
      INSERT INTO SHWAP@web
         SELECT *
           FROM SHWAP
          WHERE stud_ref_no NOT IN (SELECT stud_ref_no FROM SHWAP@web);
      DBMS_OUTPUT.PUT_LINE('Transfer to WEB OK');
      
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE('Transfer to WEB FAIL');
   END insert_to_web;
   
END shortened_application_web;         -- SHORTENED_APPLICATION_WEB Package
/