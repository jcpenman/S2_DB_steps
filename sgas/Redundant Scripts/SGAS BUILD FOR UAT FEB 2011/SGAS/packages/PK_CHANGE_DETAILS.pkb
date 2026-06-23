CREATE OR REPLACE PACKAGE BODY SGAS.pk_change_details
IS
   PROCEDURE pull_web_changes
   IS
/*
 * Procedure picks up all web changes since the last run date (half an hour ago)
 * and either updates the GRASS (NMSB) or STEPS database. Procedure is called by
 * dbms job on the steps database
 *
 */
      v_last_run_date   DATE                         := NULL;
      v_change_date     DATE                         := NULL;
      v_stud_ref        sgas.stud.stud_ref_no%TYPE   := NULL;
      v_return_string   VARCHAR2 (1000)              := NULL;
      v_change_type     VARCHAR2 (1000)              := NULL;

      CURSOR web_changes_cur
      IS
         SELECT stud_ref_no, TRUNC (change_date), 'MAIL'
           FROM email_mphone_change@web a
          WHERE change_date >= TRUNC (SYSDATE)
            AND stud_ref_no IS NOT NULL
            AND change_date =
                            (SELECT MAX (change_date)  /* most recent change*/
                               FROM email_mphone_change@web b
                              WHERE a.stud_ref_no = b.stud_ref_no)
         UNION
         SELECT stud_ref_no, TRUNC (change_date), 'TERM'
           FROM term_addr_change@web a
          WHERE change_date >= TRUNC (SYSDATE)
            AND stud_ref_no IS NOT NULL
            AND change_date = (SELECT MAX (change_date)
                                 FROM term_addr_change@web b
                                WHERE a.stud_ref_no = b.stud_ref_no)
         UNION
         SELECT stud_ref_no, TRUNC (change_date), 'HOME'
           FROM home_addr_change@web a
          WHERE change_date >= TRUNC (SYSDATE)
            AND stud_ref_no IS NOT NULL
            AND change_date = (SELECT MAX (change_date)
                                 FROM home_addr_change@web b
                                WHERE a.stud_ref_no = b.stud_ref_no)
         UNION
         SELECT stud_ref_no, TRUNC (change_date), 'BANK'
           FROM bank_change@web a
          WHERE change_date >= TRUNC (SYSDATE)
            AND stud_ref_no IS NOT NULL
            AND change_date = (SELECT MAX (change_date)
                                 FROM bank_change@web b
                                WHERE a.stud_ref_no = b.stud_ref_no)
         UNION
         SELECT stud_ref_no, TRUNC (change_date), 'LOAN'
           FROM loan_contacts_change@web a
          WHERE change_date >= TRUNC (SYSDATE)
            AND stud_ref_no IS NOT NULL
            AND change_date = (SELECT MAX (change_date)
                                 FROM loan_contacts_change@web b
                                WHERE a.stud_ref_no = b.stud_ref_no)
         UNION
         SELECT stud_ref_no, TRUNC (change_date), 'NAME'
           FROM title_name_change@web a
          WHERE change_date >= TRUNC (SYSDATE)
            AND stud_ref_no IS NOT NULL
            AND change_date = (SELECT MAX (change_date)
                                 FROM title_name_change@web b
                                WHERE a.stud_ref_no = b.stud_ref_no)
         UNION
         SELECT stud_ref_no, TRUNC (change_date), 'OTHER'
           FROM other_change@web a
          WHERE change_date >= TRUNC (SYSDATE)
            AND stud_ref_no IS NOT NULL
            AND change_date = (SELECT MAX (change_date)
                                 FROM other_change@web b
                                WHERE a.stud_ref_no = b.stud_ref_no);

      lnum              NUMBER                       := 0;
      v_database        VARCHAR2 (5)                 := NULL;
   BEGIN
      OPEN web_changes_cur;

      LOOP
         lnum := lnum + 1;

         FETCH web_changes_cur
          INTO v_stud_ref, v_change_date, v_change_type;

         EXIT WHEN web_changes_cur%NOTFOUND;
         v_database := f_which_database (v_stud_ref);
         DBMS_OUTPUT.put_line (   lnum
                               || '.'
                               || v_stud_ref
                               || v_change_date
                               || v_change_type
                               || v_database
                              );

         IF v_database = 'STEPS'
         THEN
            DBMS_OUTPUT.put_line ('STEPS');
            DBMS_OUTPUT.put_line ('calling steps cod');
            steps_change_of_details (v_stud_ref,
                                     v_change_date,
                                     v_change_type,
                                     v_return_string
                                    );
         ELSE
            DBMS_OUTPUT.put_line ('GRASS');
            v_return_string :=
                          grass_change_of_details (v_stud_ref, v_change_date);
         END IF;

         DBMS_OUTPUT.put_line ('return string' || v_return_string);
      END LOOP;

      CLOSE web_changes_cur;

      delete_web_change;
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);

         CLOSE web_changes_cur;

         ROLLBACK;                            --we can re-process these cases
   END pull_web_changes;

   FUNCTION f_which_database (p_stud_ref IN NUMBER)
      RETURN VARCHAR2
   IS
      /* REQUIRED FOR STEPS CHANGE OF DETAILS PROCESSING
       *
       * f_which_database
       *
       * PARAMETERS IN: student reference number
       *
       * PARAMETERS OUT: NONE
       *
       * RETURN VALUE:
       * Returns GRASS if GRASS only (NMSB)
       * Returns STEPS if STEPS only (non-NMSB current session data)
       * Returns NULL if stud not found on either database
       *
       * CALLS: NONE
       *
       * CALLED BY: pull_web_changes
       *
       * Modification history:
       * 06.02.2008 Initial Version   Robert Hunter
       *
       */
      v_steps   NUMBER := 0;
      v_grass   NUMBER := 0;
   BEGIN
      SELECT COUNT (stud_ref_no)
        INTO v_steps
        FROM sgas.stud
       WHERE stud_ref_no = p_stud_ref AND stud_ref_no IS NOT NULL;

      SELECT COUNT (stud_ref_no)
        INTO v_grass
        FROM sgas.stud@grass
       WHERE stud_ref_no = p_stud_ref AND stud_ref_no IS NOT NULL;

      IF v_steps > 0
      THEN
         RETURN 'STEPS';
      ELSIF v_grass > 0
      THEN
         RETURN 'GRASS';
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
         RETURN NULL;
   END f_which_database;

/*****************************************************************************
* The following is a copy of TRANSFORM.change_of_details_copy from EBUST1
*
* 06-FEB-2008
*
* This will be used to put Web changes onto GRASS i.e. existing processing
******************************************************************************/
--
-- Added for RFC 122 Change of Details
-- This function copies data from the WEB database to the GRASS tables
-- and creates Workflow items and warning where appropriate
--
-- RH 19/02/08
-- added input parameters
-- (p_stud_ref, p_change_date) to
-- parameterise function,
   FUNCTION grass_change_of_details (
      p_stud_ref      IN   NUMBER,
      p_change_date   IN   DATE
   )
      RETURN VARCHAR2
   IS
      CURSOR term_addr_change
      IS
         SELECT                                                --stud_ref_no,
                change_date, UPPER (house_no_name), UPPER (addr_l1),
                UPPER (addr_l2), UPPER (addr_l3), UPPER (addr_l4),
                UPPER (post_code), UPPER (residence_ind),
                UPPER (to_from_parents_fg)
           FROM term_addr_change@web
          WHERE stud_ref_no = p_stud_ref
            AND change_date = p_change_date
            AND stud_ref_no IS NOT NULL;

      --RH200208 parameterising this function

      --
      CURSOR home_addr_change
      IS
         SELECT                                                 --stud_ref_no,
                change_date, UPPER (house_no_name), UPPER (addr_l1),
                UPPER (addr_l2), UPPER (addr_l3), UPPER (addr_l4),
                UPPER (post_code), UPPER (apply_to_ben_1),
                UPPER (apply_to_ben_2), mailsort_code
           FROM home_addr_change@web
          WHERE stud_ref_no = p_stud_ref
            AND change_date = p_change_date
            AND stud_ref_no IS NOT NULL;

      --RH200208 parameterising this function

      --
      CURSOR bank_change
      IS
         SELECT                                                 --stud_ref_no,
                change_date, account_no, sort_code, bank_validate
           FROM bank_change@web
          WHERE stud_ref_no = p_stud_ref
            AND change_date = p_change_date
            AND stud_ref_no IS NOT NULL;

      --RH200208 parameterising this function

      --
      CURSOR loan_contacts_change
      IS
         SELECT                                                 --stud_ref_no,
                change_date, UPPER (name_1), UPPER (house_no_name_1),
                UPPER (addr_l1_1), UPPER (addr_l2_1), UPPER (addr_l3_1),
                UPPER (addr_l4_1), UPPER (post_code_1), tel_no_1,
                UPPER (rel_code_1), UPPER (name_2), UPPER (house_no_name_2),
                UPPER (addr_l1_2), UPPER (addr_l2_2), UPPER (addr_l3_2),
                UPPER (addr_l4_2), UPPER (post_code_2), tel_no_2
           FROM loan_contacts_change@web
          WHERE stud_ref_no = p_stud_ref
            AND change_date = p_change_date
            AND stud_ref_no IS NOT NULL;

      --RH200208 parameterising this function;

      --
      CURSOR title_name_change
      IS
         SELECT                                                 --stud_ref_no,
                change_date, UPPER (title), UPPER (forenames),
                UPPER (surname), UPPER (birth_forenames),
                UPPER (birth_surname)
           FROM title_name_change@web
          WHERE stud_ref_no = p_stud_ref
            AND change_date = p_change_date
            AND stud_ref_no IS NOT NULL;

      --RH200208 parameterising this function;

      --
      CURSOR emailphone_change
      IS
         SELECT                                                 --stud_ref_no,
                change_date, new_email, new_phone
           FROM email_mphone_change@web
          WHERE stud_ref_no = p_stud_ref
            AND change_date = p_change_date
            AND stud_ref_no IS NOT NULL;

      --RH200208 parameterising this function;

      --
      CURSOR other_change
      IS
         SELECT                                                 --stud_ref_no,
                change_date, UPPER (CHANGE)
           FROM other_change@web
          WHERE stud_ref_no = p_stud_ref
            AND change_date = p_change_date
            AND stud_ref_no IS NOT NULL;

      --RH200208 parameterising this function;

      --
--v_stud_ref_no        term_addr_change.stud_ref_no@web%type;
      v_change_date             term_addr_change.change_date@web%TYPE;
      v_house_no_name           term_addr_change.house_no_name@web%TYPE;
      v_addr_l1                 term_addr_change.addr_l1@web%TYPE;
      v_addr_l2                 term_addr_change.addr_l2@web%TYPE;
      v_addr_l3                 term_addr_change.addr_l3@web%TYPE;
      v_addr_l4                 term_addr_change.addr_l4@web%TYPE;
      v_post_code               term_addr_change.post_code@web%TYPE;
      v_residence_ind           term_addr_change.residence_ind@web%TYPE;
      v_to_from_parents_fg      term_addr_change.to_from_parents_fg@web%TYPE;
      v_term_old_start_date     DATE;
--
--
--v_home_stud_ref_no    home_addr_change.stud_ref_no@web%type;
      v_home_change_date        home_addr_change.change_date@web%TYPE;
      v_home_house_no_name      home_addr_change.house_no_name@web%TYPE;
      v_home_addr_l1            home_addr_change.addr_l1@web%TYPE;
      v_home_addr_l2            home_addr_change.addr_l2@web%TYPE;
      v_home_addr_l3            home_addr_change.addr_l3@web%TYPE;
      v_home_addr_l4            home_addr_change.addr_l4@web%TYPE;
      v_home_post_code          home_addr_change.post_code@web%TYPE;
      v_apply_to_ben_1          home_addr_change.apply_to_ben_1@web%TYPE;
      v_apply_to_ben_2          home_addr_change.apply_to_ben_2@web%TYPE;
      v_home_mailsort_code      home_addr_change.mailsort_code@web%TYPE;
      v_home_old_start_date     DATE;
--
--
--v_bank_stud_ref_no    bank_change.stud_ref_no@web%type;
      v_bank_change_date        bank_change.change_date@web%TYPE;
      v_account_no              bank_change.account_no@web%TYPE;
      v_sort_code               bank_change.account_no@web%TYPE;
      v_bank_validate           bank_change.bank_validate@web%TYPE; -- RFC 221
      v_grass_payment_method    VARCHAR2 (1);
      v_grass_account_no        bank_change.account_no@web%TYPE;    -- RFC 137
      v_grass_sort_code         bank_change.account_no@web%TYPE;    -- RFC 137
      v_warning_end             VARCHAR2 (71)                          := NULL;
                                                                    -- RFC 137
--
--
--v_loan_stud_ref_no    loan_contacts_change.stud_ref_no@web%type;
      v_loan_change_date        loan_contacts_change.change_date@web%TYPE;
      v_name_1                  loan_contacts_change.name_1@web%TYPE;
      v_house_no_name_1         loan_contacts_change.house_no_name_1@web%TYPE;
      v_addr_l1_1               loan_contacts_change.addr_l1_1@web%TYPE;
      v_addr_l2_1               loan_contacts_change.addr_l2_1@web%TYPE;
      v_addr_l3_1               VARCHAR2 (60);
      v_addr_l4_1               VARCHAR2 (60);
      v_post_code_1             loan_contacts_change.post_code_1@web%TYPE;
      v_tel_no_1                loan_contacts_change.tel_no_1@web%TYPE;
      v_rel_code_1              loan_contacts_change.rel_code_1@web%TYPE;
      v_name_2                  loan_contacts_change.name_2@web%TYPE;
      v_house_no_name_2         loan_contacts_change.house_no_name_2@web%TYPE;
      v_addr_l1_2               loan_contacts_change.addr_l1_2@web%TYPE;
      v_addr_l2_2               loan_contacts_change.addr_l2_2@web%TYPE;
      v_addr_l3_2               VARCHAR2 (60);
      v_addr_l4_2               VARCHAR2 (60);
      v_post_code_2             loan_contacts_change.post_code_2@web%TYPE;
      v_tel_no_2                loan_contacts_change.tel_no_2@web%TYPE;
--
--
--v_title_stud_ref_no    title_name_change.stud_ref_no@web%type;
      v_title_change_date       title_name_change.change_date@web%TYPE;
      v_title                   title_name_change.title@web%TYPE;
      v_forenames               title_name_change.forenames@web%TYPE;
      v_surname                 title_name_change.surname@web%TYPE;
      v_birth_forenames         title_name_change.birth_forenames@web%TYPE;
      v_birth_surname           title_name_change.birth_surname@web%TYPE;
--
--v_me_stud_ref_no    email_mphone_change.stud_ref_no@web%TYPE;
      v_me_change_date          email_mphone_change.change_date@web%TYPE;
      v_email                   email_mphone_change.new_email@web%TYPE;
      v_mobphone                email_mphone_change.new_phone@web%TYPE;
--
--v_other_stud_ref_no    other_change.stud_ref_no@web%type;
      v_other_change_date       other_change.change_date@web%TYPE;
      v_change                  other_change.CHANGE@web%TYPE;
--
      v_del                     VARCHAR2 (1);
      v_return_string           VARCHAR2 (1000);
      v_error_str               VARCHAR2 (255);
      v_current_session         NUMBER (4);
      v_count                   NUMBER (2);
      v_stud_crse_year_id       NUMBER (9);
      v_retval                  BOOLEAN;
      v_ben1_id                 NUMBER (9);
      v_ben2_id                 NUMBER (9);
      v_residence_text          VARCHAR2 (13);
      v_update_stud_term_addr   BOOLEAN;                             -- SIR241
      v_current_nmsb_session    VARCHAR2 (4);
      v_non_nmsb_session        VARCHAR2 (4);
      v_nmsb                    VARCHAR2 (255);
      v_authenticated_ind       student.authenticated_ind@web%TYPE;
      v_existing_email          stud.email_addr%TYPE;
      v_existing_mphone         stud.mobile_tel_no%TYPE;
--
   BEGIN
--
      DBMS_OUTPUT.put_line (   '*** DATA CHANGE TRANSFER STARTING AT '
                            || TO_CHAR (SYSDATE, 'dd/mm/yyyy hh24:mi:ss')
                            || ' ***'
                           );
      v_return_string := 'Selecting Current Session';

      SELECT cval
        INTO v_current_session
        FROM config_data@grass
       WHERE item_name = 'CURRENT_SESSION';

--
      SELECT cval
        INTO v_current_nmsb_session
        FROM config_data@grass
       WHERE item_name = 'CURRENT_NMSB_SESSION';

--
      v_non_nmsb_session := v_current_session;
--
      v_return_string := 'opening cursors';

      OPEN term_addr_change;

      LOOP
         BEGIN
            /* Set the delete flag to Y */
            v_del := 'Y';
            v_update_stud_term_addr := TRUE;                        -- SIR241

--
            FETCH term_addr_change
             INTO                                            --v_stud_ref_no,
                  v_change_date, v_house_no_name, v_addr_l1, v_addr_l2,
                  v_addr_l3, v_addr_l4, v_post_code, v_residence_ind,
                  v_to_from_parents_fg;

            EXIT WHEN term_addr_change%NOTFOUND;

--
--      SIR241 - Check for no data found. If no data then set update flag to false
            BEGIN
               v_return_string := 'Selecting from stud_term_addr table';

               SELECT TRUNC (start_date)
                 INTO v_term_old_start_date
                 FROM stud_term_addr@grass
                WHERE stud_ref_no = p_stud_ref
                  AND end_date IS NULL
                  AND stud_ref_no IS NOT NULL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_update_stud_term_addr := FALSE;
            END;

--    SIR241 END
--
           /* RAM TR474 11/10/2004 */
--    SIR241. If old term start date is null, ensure its well in the past so we don't get this message
            IF TRUNC (v_change_date) <=
                  NVL (v_term_old_start_date,
                       TO_DATE ('01-JAN-1900', 'DD-MON-YYYY')
                      )
            THEN
               transform.write_warning@grass
                  (p_stud_ref,
                      'New term address record start date will overlap with existing GRASS record. '
                   || 'The new term address record has not been transferred: '
                   || v_house_no_name
                   || ''', '''
                   || v_post_code
                   || ''', '''
                   || v_addr_l1
                   || ''', '''
                   || v_addr_l2
                   || ''', '''
                   || v_addr_l3
                   || ''', '''
                   || v_addr_l4
                   || ''', '''
                   || v_residence_text
                   || '''.'
                  );
            ELSE
--
--    SIR241 Only update end date if we have a previous record
               IF v_update_stud_term_addr = TRUE
               THEN
                  v_return_string := 'Updating stud_term_addr table';

                  UPDATE stud_term_addr@grass
                     SET end_date = TRUNC (v_change_date) - 1
                   WHERE stud_ref_no = p_stud_ref AND end_date IS NULL;
               END IF;

--    SIR241 End
               --
               v_return_string := 'Checking stud_term_addr record';
               /* WS 202 - Call procedure to check that addr_l1 does not contain the house_no_name */
               transform.check_addr@grass (v_house_no_name,
                                           v_addr_l1,
                                           v_addr_l2,
                                           v_addr_l3,
                                           v_addr_l4
                                          );
--
               v_return_string := 'Inserting new stud_term_addr record';

               INSERT INTO stud_term_addr@grass
                           (stud_ref_no, start_date,
                            house_no_name, addr_l1, addr_l2, addr_l3,
                            addr_l4, post_code,
                            location_ind,
                            residence_ind
                           )
                    VALUES (p_stud_ref, TRUNC (v_change_date),
                            v_house_no_name, v_addr_l1, v_addr_l2, v_addr_l3,
                            v_addr_l4, v_post_code,
                            DECODE (v_residence_ind, 'X', 'E', 'H'),
                            v_residence_ind
                           );

--
               IF v_to_from_parents_fg = 'Y'
               THEN
                  /* Create a workflow item and a warning */
                  v_return_string :=
                                    'Writing Warning for Term Address Change';

                  -- Fix TR 602 - decode residence ind
                  SELECT DECODE (v_residence_ind,
                                 'P', 'Parental Home',
                                 'O', 'Own Home',
                                 'X', 'Elsewhere'
                                )
                    INTO v_residence_text
                    FROM DUAL;

                  --
                  transform.write_warning@web
                                            (p_stud_ref,
                                                'New Term Address Details: '''
                                             || v_house_no_name
                                             || ''', '''
                                             || v_post_code
                                             || ''', '''
                                             || v_addr_l1
                                             || ''', '''
                                             || v_addr_l2
                                             || ''', '''
                                             || v_addr_l3
                                             || ''', '''
                                             || v_addr_l4
                                             || ''', '''
                                             || v_residence_text
                                             || '''.'
                                            );
--
                  v_return_string :=
                              'Creating Workflow Item for Term Address Change';

                  IF NOT transform.create_workflow_item@web
                                                           (p_stud_ref,
                                                            v_current_session,
                                                            'N',
                                                            v_error_str,
                                                            v_change_date
                                                           )
                  THEN
                     DBMS_OUTPUT.put_line (   'Unhandled exception '
                                           || TO_CHAR (SQLCODE)
                                           || ' ('
                                           || v_error_str
                                           || ') While '
                                           || v_return_string
                                           || ' for student '
                                           || TO_CHAR (p_stud_ref)
                                          );
                     ROLLBACK;
                     v_del := 'N';
                  END IF;
               ELSE
                  /* Select latest stud_crse_year_id to update SLC file flags */
                  BEGIN
                     SELECT stud_crse_year_id
                       INTO v_stud_crse_year_id
                       FROM stud_crse_year@grass
                      WHERE stud_ref_no = p_stud_ref          -- TR EB 636 fix
                        AND session_code = v_current_session
                        AND latest_crse_ind = 'Y'
                        AND first_slc1_sent_date IS NOT NULL
                        AND stud_ref_no IS NOT NULL;

                     /* Set the SLC flags for another file to go to SLC */
                     IF slc_util.loan_bearing@grass (v_stud_crse_year_id) =
                                                                           'Y'
                     THEN
                        v_return_string := 'Updating the SLC flags.';

                        UPDATE stud_crse_year@grass
                           SET slc1_sent = 'N',
                               slc2_sent = 'N'
                         WHERE stud_crse_year_id = v_stud_crse_year_id
                           AND slc1_sent_date IS NOT NULL;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        NULL;
                  END;
               END IF;
            END IF;

            /* Delete the interface data */
            IF v_del = 'Y'
            THEN
               v_return_string := 'deleting from web TERM_ADDR_CHANGE table';
            --DELETE FROM TERM_ADDR_CHANGE
            --WHERE stud_ref_no = p_stud_ref;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (   'Unhandled exception '
                                     || TO_CHAR (SQLCODE)
                                     || ' While '
                                     || v_return_string
                                     || ' for student '
                                     || TO_CHAR (p_stud_ref)
                                    );
               ROLLBACK;
               v_del := 'N';
         END;

         COMMIT;
      END LOOP;

      CLOSE term_addr_change;

--
--
      OPEN home_addr_change;

      LOOP
         BEGIN
            /* Set the delete flag to Y */
            v_del := 'Y';

--
            FETCH home_addr_change
             INTO                                       --v_home_stud_ref_no,
                  v_home_change_date, v_home_house_no_name, v_home_addr_l1,
                  v_home_addr_l2, v_home_addr_l3, v_home_addr_l4,
                  v_home_post_code, v_apply_to_ben_1, v_apply_to_ben_2,
                  v_home_mailsort_code;

            EXIT WHEN home_addr_change%NOTFOUND;
--
            v_current_session := v_non_nmsb_session;
            v_nmsb :=
               transform.check_nmsb_session@web (p_stud_ref,
                                                 v_current_session,
                                                 v_current_nmsb_session
                                                );

            IF v_nmsb != 'OK'
            THEN
               DBMS_OUTPUT.put_line (v_nmsb);
               ROLLBACK;
            END IF;

--
            v_return_string := 'Selecting from stud_home_addr table';

            SELECT TRUNC (start_date)
              INTO v_home_old_start_date
              FROM stud_home_addr@grass
             WHERE stud_ref_no = p_stud_ref
               AND end_date IS NULL
               AND stud_ref_no IS NOT NULL;

--
           /* RAM TR474 11/10/2004 */
            IF TRUNC (v_home_change_date) <= v_home_old_start_date
            THEN
               transform.write_warning@grass
                  (p_stud_ref,
                      'New home address record start date will overlap with existing GRASS record. '
                   || 'The new home address record has not been transferred: '
                   || v_home_house_no_name
                   || ''', '''
                   || v_home_post_code
                   || ''', '''
                   || v_home_addr_l1
                   || ''', '''
                   || v_home_addr_l2
                   || ''', '''
                   || v_home_addr_l3
                   || ''', '''
                   || v_home_addr_l4
                   || ''', '''
                   || v_apply_to_ben_1
                   || ''', '''
                   || v_apply_to_ben_2
                   || '''.'
                  );
            ELSE
               v_return_string := 'Updating stud_home_addr table';

               UPDATE stud_home_addr@grass
                  SET end_date = TRUNC (v_home_change_date) - 1
                WHERE stud_ref_no = p_stud_ref AND end_date IS NULL;

--
               v_return_string := 'Checking stud_home_addr record';
               /* WS 202 - Call procedure to check that addr_l1 does not contain the house_no_name */
               transform.check_addr@grass (v_home_house_no_name,
                                           v_home_addr_l1,
                                           v_home_addr_l2,
                                           v_home_addr_l3,
                                           v_home_addr_l4
                                          );
               --
               v_return_string := 'Inserting new stud_home_addr record';

               INSERT INTO stud_home_addr@grass
                           (stud_ref_no, start_date,
                            house_no_name, addr_l1,
                            addr_l2, addr_l3, addr_l4,
                            post_code, mailsort
                           )
                    VALUES (p_stud_ref, TRUNC (v_home_change_date),
                            v_home_house_no_name, v_home_addr_l1,
                            v_home_addr_l2, v_home_addr_l3, v_home_addr_l4,
                            v_home_post_code, v_home_mailsort_code
                           );

               /* Select latest stud_crse_year_id to update sal_sent
                  and trigger another award letter */
               BEGIN
                  v_return_string :=
                           'requesting a duplicate LOA (Home Address Change)';

                  SELECT stud_crse_year_id
                    INTO v_stud_crse_year_id
                    FROM stud_crse_year@grass
                   WHERE stud_ref_no = p_stud_ref
                     AND session_code = v_current_session
                     AND latest_crse_ind = 'Y'
                     AND sal_sent_date IS NOT NULL
                     AND stud_ref_no IS NOT NULL;

                  /* Request a duplicate award letter */
                  UPDATE stud_crse_year@grass
                     SET sal_sent = 'N',
                         req_dup = 'Y'
                   WHERE stud_crse_year_id = v_stud_crse_year_id;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     NULL;
               END;

               /* Select latest stud_crse_year_id to reset SLC flags */
               BEGIN
                  v_return_string :=
                                 'requesting SLC files (Home Address Change)';

                  SELECT stud_crse_year_id
                    INTO v_stud_crse_year_id
                    FROM stud_crse_year@grass
                   WHERE stud_ref_no = p_stud_ref
                     AND session_code = v_current_session
                     AND latest_crse_ind = 'Y'
                     AND first_slc1_sent_date IS NOT NULL
                     AND stud_ref_no IS NOT NULL;

                  /* Set the SLC flags for another file to go to SLC */
                  IF slc_util.loan_bearing@grass (v_stud_crse_year_id) = 'Y'
                  THEN
                     v_return_string := 'Updating the SLC flags.';

                     UPDATE stud_crse_year@grass
                        SET slc1_sent = 'N',
                            slc2_sent = 'N'
                      WHERE stud_crse_year_id = v_stud_crse_year_id
                        AND slc1_sent_date IS NOT NULL;
                  END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     NULL;
               END;

               /*  Check whether to apply the changes to Benefactor Records */
               IF v_apply_to_ben_1 = 'Y' OR v_apply_to_ben_2 = 'Y'
               THEN
                  BEGIN
                     v_return_string :=
                                     'applying home address change to Ben1/2';

                     SELECT ben1_id, ben2_id
                       INTO v_ben1_id, v_ben2_id
                       FROM stud_session@grass
                      WHERE stud_ref_no = p_stud_ref
                        AND session_code = v_current_session
                        AND stud_ref_no IS NOT NULL;

--
                     IF v_apply_to_ben_1 = 'Y'
                     THEN
                        UPDATE benefactor@grass
                           SET house_no_name = v_home_house_no_name,
                               addr_l1 = v_home_addr_l1,
                               addr_l2 = v_home_addr_l2,
                               addr_l3 = v_home_addr_l3,
                               addr_l4 = v_home_addr_l4,
                               post_code = v_home_post_code,
                               mailsort = v_home_mailsort_code
                         WHERE ben_id = v_ben1_id;
                     END IF;

--
                     IF v_apply_to_ben_2 = 'Y'
                     THEN
                        UPDATE benefactor@grass
                           SET house_no_name = v_home_house_no_name,
                               addr_l1 = v_home_addr_l1,
                               addr_l2 = v_home_addr_l2,
                               addr_l3 = v_home_addr_l3,
                               addr_l4 = v_home_addr_l4,
                               post_code = v_home_post_code,
                               mailsort = v_home_mailsort_code
                         WHERE ben_id = v_ben2_id;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        NULL;
                  END;
               END IF;
            END IF;

            /* Delete the interface data */
            IF v_del = 'Y'
            THEN
               v_return_string := 'deleting from web HOME_ADDR_CHANGE table';
            --DELETE FROM HOME_ADDR_CHANGE
            --WHERE stud_ref_no = p_stud_ref;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (   'Unhandled exception aa'
                                     || TO_CHAR (SQLCODE)
                                     || ' While '
                                     || v_return_string
                                     || ' for student '
                                     || TO_CHAR (p_stud_ref)
                                    );
               ROLLBACK;
               v_del := 'N';
         END;

         COMMIT;
      END LOOP;

      CLOSE home_addr_change;

--
      OPEN bank_change;

      LOOP
         BEGIN
            /* Set the delete flag to Y */
            v_del := 'Y';

--
            FETCH bank_change
             INTO                                       --v_bank_stud_ref_no,
                  v_bank_change_date, v_account_no, v_sort_code,
                  v_bank_validate;

            EXIT WHEN bank_change%NOTFOUND;
            --
            v_current_session := v_non_nmsb_session;
            v_nmsb :=
               transform.check_nmsb_session@web (p_stud_ref,
                                                 v_current_session,
                                                 v_current_nmsb_session
                                                );

            IF v_nmsb != 'OK'
            THEN
               DBMS_OUTPUT.put_line (v_nmsb);
               ROLLBACK;
            END IF;

                --
            -- RFC 137 - Check whether to re-set method of payment
            SELECT payment_method, account_no,
                   sort_code
              INTO v_grass_payment_method, v_grass_account_no,
                   v_grass_sort_code
              FROM stud@grass
             WHERE stud_ref_no = p_stud_ref AND stud_ref_no IS NOT NULL;

            -- check whether bank details tally
            IF     v_grass_account_no = v_account_no
               AND v_grass_sort_code = v_sort_code
            THEN
               -- details are the same - don't change method of payment
               -- or change bank details
               v_warning_end := NULL;
            ELSE
               -- SIR 944 and 952 - update bank details on GRASS as ac details have changed
               UPDATE stud@grass
                  SET payment_method = 'B',
                      account_no = v_account_no,
                      build_soc_no = NULL,
                      sort_code = v_sort_code,
                      bank_name = NULL,
                      bank_house_no_name = NULL,
                      bank_addr_l1 = NULL,
                      bank_addr_l2 = NULL,
                      bank_addr_l3 = NULL,
                      bank_addr_l4 = NULL,
                      bank_post_code = NULL,
                      bank_validate = v_bank_validate
                WHERE stud_ref_no = p_stud_ref;

               -- SIR 944 update end
               /* Select latest stud_crse_year_id to update SLC file flags */
               BEGIN
                  SELECT stud_crse_year_id
                    INTO v_stud_crse_year_id
                    FROM stud_crse_year@grass
                   WHERE stud_ref_no = p_stud_ref
                     AND session_code = v_current_session
                     AND latest_crse_ind = 'Y'
                     AND first_slc1_sent_date IS NOT NULL
                     AND stud_ref_no IS NOT NULL;

                  /* Set the SLC flags for another file to go to SLC */
                  IF slc_util.loan_bearing@grass (v_stud_crse_year_id) = 'Y'
                  THEN
                     v_return_string := 'Updating the SLC flags.';

                     UPDATE stud_crse_year@grass
                        SET slc2_sent = 'N'
                      -- removed setting for slc1_sent TR 640
                     WHERE  stud_crse_year_id = v_stud_crse_year_id
                        AND slc1_sent_date IS NOT NULL;

                     --
                     v_warning_end :=
                        ' The old bank details have been deleted and SLC notification triggered.';
                  ELSE
                     -- Not loan-bearing - no SLC details to change
                     v_warning_end :=
                                   ' The old bank details have been deleted.';
                  END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_warning_end :=
                                   ' The old bank details have been deleted.';
               END;

               -- SIR 944 payment check
               /* Check if any instalments are waiting to be paid by cheque
                 latest course */
               SELECT COUNT (*)
                 INTO v_count
                 FROM award_instalment@grass ai, award@grass a
                WHERE a.stud_ref_no = p_stud_ref
                  AND a.award_id = ai.award_id
                  AND ai.payment_status IN ('U', 'A')
                  AND ai.method = 'C'
                  AND stud_ref_no IS NOT NULL;

--
               IF v_count > 0
               THEN
                     /* Update the unpaid award_instalment records to pay by BACS
                  where they are set to Cheque and not nominee or Loan payments */
                  UPDATE award_instalment@grass
                     SET method = 'B',
                         payee = 'S',
                         payment_addr = 'B'
                   WHERE method = 'C'
                     AND payment_status IN ('U', 'A')
                     AND award_id IN (
                            SELECT award_id
                              FROM award@grass
                             WHERE stud_ref_no = p_stud_ref
                               AND stud_ref_no IS NOT NULL
                               AND award_src = 'A'
                               AND stud_award_type NOT LIKE ('U%L')
                               AND payee = 'S');

--
                 /* Check if any instalments are waiting to be paid by cheque
              to the nominee */
                  SELECT COUNT (*)
                    INTO v_count
                    FROM award_instalment@grass ai, award@grass a
                   WHERE a.stud_ref_no = p_stud_ref
                     AND stud_ref_no IS NOT NULL
                     AND a.award_id = ai.award_id
                     AND ai.payment_status IN ('U', 'A')
                     AND ai.method = 'C'
                     AND ai.payee = 'N';

                  IF v_count > 0
                  THEN
                     /* Create a warning */
                     v_return_string :=
                                  'Writing Warning for Bank Change (nominee)';
                     transform.write_warning@web
                        (p_stud_ref,
                            'New student bank details have been received via the web'
                         || ' and award instalment(s) waiting to be paid are already set to pay to nominee by cheque.'
                        );
                     /* Create an Urgent workflow item */
                     v_return_string :=
                        'Creating Workflow Item for Bank Change (nominee payments exist)';

                     IF NOT transform.create_workflow_item@web
                                                           (p_stud_ref,
                                                            v_current_session,
                                                            'Y',
                                                            v_error_str,
                                                            v_bank_change_date
                                                           )
                     THEN
                        DBMS_OUTPUT.put_line (   'Unhandled exception '
                                              || TO_CHAR (SQLCODE)
                                              || ' ('
                                              || v_error_str
                                              || ') While '
                                              || v_return_string
                                              || ' for student '
                                              || TO_CHAR (p_stud_ref)
                                             );
                        ROLLBACK;
                        v_del := 'N';
                     END IF;
                  END IF;
--
--         -- SIR 944 payment check end
               END IF;                            -- end of bank account check
            -- End of RFC 137 addition
            END IF;

--
--
    /* Delete the interface data */
            IF v_del = 'Y'
            THEN
               v_return_string := 'deleting from web BANK_CHANGE table';
            --DELETE FROM BANK_CHANGE
            --WHERE stud_ref_no = p_stud_ref;
            END IF;
--
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (   'Unhandled exception '
                                     || TO_CHAR (SQLCODE)
                                     || ' While '
                                     || v_return_string
                                     || ' for student '
                                     || TO_CHAR (p_stud_ref)
                                    );
               ROLLBACK;
               v_del := 'N';
         END;

--
         COMMIT;
      END LOOP;

      CLOSE bank_change;

--
--
      OPEN loan_contacts_change;

      LOOP
         BEGIN
            /* Set the delete flag to Y */
            v_del := 'Y';

--
            FETCH loan_contacts_change
             INTO                                       --v_loan_stud_ref_no,
                  v_loan_change_date, v_name_1, v_house_no_name_1,
                  v_addr_l1_1, v_addr_l2_1, v_addr_l3_1, v_addr_l4_1,
                  v_post_code_1, v_tel_no_1, v_rel_code_1, v_name_2,
                  v_house_no_name_2, v_addr_l1_2, v_addr_l2_2, v_addr_l3_2,
                  v_addr_l4_2, v_post_code_2, v_tel_no_2;

            EXIT WHEN loan_contacts_change%NOTFOUND;
            --
            v_return_string := 'checking STUD_CONT_DETAILS RECORD 1';
            --
            transform.check_loan_addr@grass ('first',
                                             p_stud_ref,
                                             v_house_no_name_1,
                                             v_post_code_1,
                                             v_addr_l1_1,
                                             v_addr_l2_1,
                                             v_addr_l3_1,
                                             v_addr_l4_1
                                            );

            --
            -- Fix TR 600
            SELECT COUNT (*)
              INTO v_count
              FROM stud_cont_details@grass
             WHERE stud_ref_no = p_stud_ref
               AND stud_ref_no IS NOT NULL
               AND contact_ind = 1;

            --
            IF v_count > 0
            THEN
               --
               v_return_string :=
                               'Updating stud_cont_details table - Contact 1';

               UPDATE stud_cont_details@grass
                  SET cont_name = v_name_1,
                      cont_addr1 = v_house_no_name_1 || ' ' || v_addr_l1_1,
                      cont_addr2 = v_addr_l2_1,
                      cont_addr3 = v_addr_l3_1,
                      cont_postcode = v_post_code_1,
                      cont_tel_no = v_tel_no_1,
                      cont_rel_code = v_rel_code_1
                WHERE stud_ref_no = p_stud_ref AND contact_ind = 1;
            ELSE
               -- Fix TR 600
               v_return_string :=
                         'Inserting into stud_cont_details table - Contact 1';

               INSERT INTO stud_cont_details@grass
                           (stud_ref_no, contact_ind, cont_name,
                            cont_addr1,
                            cont_addr2, cont_addr3, cont_postcode,
                            cont_tel_no, cont_rel_code
                           )
                    VALUES (p_stud_ref, 1, v_name_1,
                            v_house_no_name_1 || ' ' || v_addr_l1_1,
                            v_addr_l2_1, v_addr_l3_1, v_post_code_1,
                            v_tel_no_1, v_rel_code_1
                           );
            END IF;

            --
            --
            v_return_string := 'checking STUD_CONT_DETAILS RECORD 2';
            transform.check_loan_addr@grass ('second',
                                             p_stud_ref,
                                             v_house_no_name_2,
                                             v_post_code_2,
                                             v_addr_l1_2,
                                             v_addr_l2_2,
                                             v_addr_l3_2,
                                             v_addr_l4_2
                                            );

            --
            --
            SELECT COUNT (*)                                     -- Fix TR 600
              INTO v_count
              FROM stud_cont_details@grass
             WHERE stud_ref_no = p_stud_ref
               AND stud_ref_no IS NOT NULL
               AND contact_ind = 2;

            --
            --
            IF v_count > 0
            THEN
               v_return_string :=
                               'Updating stud_cont_details table - Contact 2';

               UPDATE stud_cont_details@grass
                  SET cont_name = v_name_2,
                      cont_addr1 = v_house_no_name_2 || ' ' || v_addr_l1_2,
                      cont_addr2 = v_addr_l2_2,
                      cont_addr3 = v_addr_l3_2,
                      cont_postcode = v_post_code_2,
                      cont_tel_no = v_tel_no_2
                WHERE stud_ref_no = p_stud_ref AND contact_ind = 2;
            ELSE                                                 -- Fix TR 600
               v_return_string :=
                         'Inserting into stud_cont_details table - Contact 2';

               INSERT INTO stud_cont_details@grass
                           (stud_ref_no, contact_ind, cont_name,
                            cont_addr1,
                            cont_addr2, cont_addr3, cont_postcode,
                            cont_tel_no
                           )
                    VALUES (p_stud_ref, 2, v_name_2,
                            v_house_no_name_2 || ' ' || v_addr_l1_2,
                            v_addr_l2_2, v_addr_l3_2, v_post_code_2,
                            v_tel_no_2
                           );
            END IF;

           --
           --
--
        /* Create a workflow item and a warning */
        -- TR 602 - reword message
            v_return_string := 'Writing Warning for Contact Details Change';
            transform.write_warning@web
               (p_stud_ref,
                   'New Loan Contact details have been '
                || 'updated via the web. Consider subsequent appropriate action, '
                || 'including SLC notification.'
               );
--
            v_return_string :=
                           'Creating Workflow Item for Contact Details Change';

            IF NOT transform.create_workflow_item@web (p_stud_ref,
                                                       v_current_session,
                                                       'N',
                                                       v_error_str,
                                                       v_loan_change_date
                                                      )
            THEN
               DBMS_OUTPUT.put_line (   'Unhandled exception '
                                     || TO_CHAR (SQLCODE)
                                     || ' ('
                                     || v_error_str
                                     || ') While '
                                     || v_return_string
                                     || ' for student '
                                     || TO_CHAR (p_stud_ref)
                                    );
               ROLLBACK;
               v_del := 'N';
            END IF;

--
                /* Delete the interface data */
            IF v_del = 'Y'
            THEN
               v_return_string :=
                               'deleting from web LOAN_CONTACTS_CHANGE table';
            --DELETE FROM LOAN_CONTACTS_CHANGE
            --WHERE stud_ref_no = p_stud_ref;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (   'Unhandled exception '
                                     || TO_CHAR (SQLCODE)
                                     || ' While '
                                     || v_return_string
                                     || ' for student '
                                     || TO_CHAR (p_stud_ref)
                                    );
               ROLLBACK;
               v_del := 'N';
         END;

         COMMIT;
      END LOOP;

      CLOSE loan_contacts_change;

--
--
      OPEN title_name_change;

      LOOP
         BEGIN
            /* Set the delete flag to Y */
            v_del := 'Y';

--
            FETCH title_name_change
             INTO                                      --v_title_stud_ref_no,
                  v_title_change_date, v_title, v_forenames, v_surname,
                  v_birth_forenames, v_birth_surname;

            EXIT WHEN title_name_change%NOTFOUND;
--
--
            v_current_session := v_non_nmsb_session;
            v_nmsb :=
               transform.check_nmsb_session@web (p_stud_ref,
                                                 v_current_session,
                                                 v_current_nmsb_session
                                                );

            IF v_nmsb != 'OK'
            THEN
               DBMS_OUTPUT.put_line (v_nmsb);
               ROLLBACK;
            END IF;

            --
             /* Create a workflow item and a warning */
            v_return_string := 'Writing Warning for Title/Name Change';
            transform.write_warning@web (p_stud_ref,
                                            'New Title/Name Details: '''
                                         || v_title
                                         || ''', '''
                                         || v_forenames
                                         || ''', '''
                                         || v_surname
                                         || ''', '''
                                         || v_birth_forenames
                                         || ''', '''
                                         || v_birth_surname
                                         || '''.'
                                        );
--
            v_return_string := 'Creating Workflow Item for Title/Name Change';

            IF NOT transform.create_workflow_item@web (p_stud_ref,
                                                       v_current_session,
                                                       'N',
                                                       v_error_str,
                                                       v_title_change_date
                                                      )
            THEN
               DBMS_OUTPUT.put_line (   'Unhandled exception '
                                     || TO_CHAR (SQLCODE)
                                     || ' ('
                                     || v_error_str
                                     || ') While '
                                     || v_return_string
                                     || ' for student '
                                     || TO_CHAR (p_stud_ref)
                                    );
               ROLLBACK;
               v_del := 'N';
            END IF;                                                          --

            /* Delete the interface data */
            IF v_del = 'Y'
            THEN
               v_return_string := 'deleting from web TITLE_NAME_CHANGE table';
            --DELETE FROM TITLE_NAME_CHANGE
            --WHERE stud_ref_no = p_stud_ref;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (   'Unhandled exception '
                                     || TO_CHAR (SQLCODE)
                                     || ' While '
                                     || v_return_string
                                     || ' for student '
                                     || TO_CHAR (p_stud_ref)
                                    );
               ROLLBACK;
               v_del := 'N';
         END;

         COMMIT;
      END LOOP;

      CLOSE title_name_change;

--
---- rfc190 start
      OPEN emailphone_change;

      LOOP
         BEGIN
            /* Set the delete flag to Y */
            v_del := 'Y';

--
            FETCH emailphone_change
             INTO                                         --v_me_stud_ref_no,
                  v_me_change_date, v_email, v_mobphone;

            DBMS_OUTPUT.put_line (v_me_change_date || v_email || v_mobphone);
            EXIT WHEN emailphone_change%NOTFOUND;
--
            v_current_session := v_non_nmsb_session;
            v_nmsb :=
               transform.check_nmsb_session@web (p_stud_ref,
                                                 v_current_session,
                                                 v_current_nmsb_session
                                                );

            IF v_nmsb != 'OK'
            THEN
               DBMS_OUTPUT.put_line (v_nmsb);
               ROLLBACK;
            END IF;

--
            IF p_stud_ref IS NOT NULL
            THEN
               SELECT NVL (st.authenticated_ind, 0)
                 INTO v_authenticated_ind
                 FROM student_personal_details@web std, student@web st
                WHERE std.username = st.username
                  AND std.stud_ref_no = p_stud_ref
                  AND stud_ref_no IS NOT NULL;

--
               IF v_authenticated_ind = 1
               THEN
                  IF v_email IS NOT NULL
                  THEN
                     SELECT NVL (email_addr, 'X')
                       INTO v_existing_email
                       FROM stud@grass
                      WHERE stud_ref_no = p_stud_ref
                        AND stud_ref_no IS NOT NULL;

                     IF v_existing_email <> v_email
                     THEN
                        UPDATE stud@grass
                           SET email_addr = v_email
                         WHERE stud_ref_no = p_stud_ref;

                        transform.write_warning@web (p_stud_ref,
                                                        'New E-Mail Details: '
                                                     || v_email
                                                    );
                     END IF;
                  END IF;

                  IF v_mobphone IS NOT NULL
                  THEN
                     DBMS_OUTPUT.put_line ('v_mobphone=' || v_mobphone);

                     SELECT NVL (mobile_tel_no, 'X')
                       INTO v_existing_mphone
                       FROM stud@grass
                      WHERE stud_ref_no = p_stud_ref
                        AND stud_ref_no IS NOT NULL;

                     DBMS_OUTPUT.put_line (   'v_existing_mphone='
                                           || v_existing_mphone
                                          );

                     IF v_existing_mphone <> v_mobphone
                     THEN
                        UPDATE stud@grass
                           SET stud.mobile_tel_no = v_mobphone
                         WHERE stud_ref_no = p_stud_ref;

                        transform.write_warning@web
                                              (p_stud_ref,
                                                  'New Mobile Phone Details: '
                                               || v_mobphone
                                              );
                     END IF;
                  END IF;
               END IF;

        /* Create a workflow item and a warning */
--
               v_return_string :=
                            'Writing Warning for E-Mail / Mobile Phone Change';

               IF NOT transform.create_workflow_item@web (p_stud_ref,
                                                          v_current_session,
                                                          'N',
                                                          v_error_str,
                                                          v_me_change_date
                                                         )
               THEN
                  DBMS_OUTPUT.put_line (   'Unhandled exception '
                                        || TO_CHAR (SQLCODE)
                                        || ' ('
                                        || v_error_str
                                        || ') While '
                                        || v_return_string
                                        || ' for student '
                                        || TO_CHAR (p_stud_ref)
                                       );
                  ROLLBACK;
                  v_del := 'N';
               END IF;                                                       --

               /* Delete the interface data */
               IF v_del = 'Y'
               THEN
                  v_return_string :=
                                'deleting from web email_Mphone_change table';
               --DELETE FROM email_Mphone_change
               --WHERE stud_ref_no = p_stud_ref;
               END IF;
            END IF;
--
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (   'Unhandled exception '
                                     || TO_CHAR (SQLCODE)
                                     || ' While '
                                     || v_return_string
                                     || ' for student '
                                     || TO_CHAR (p_stud_ref)
                                    );
               ROLLBACK;
               v_del := 'N';
         END;

         COMMIT;
      END LOOP;

      CLOSE emailphone_change;

-- rfc190 END
--
--
      OPEN other_change;

      LOOP
         BEGIN
            /* Set the delete flag to Y */
            v_del := 'Y';

--
            FETCH other_change
             INTO                                            --v_stud_ref_no,
                  v_other_change_date, v_change;

            EXIT WHEN other_change%NOTFOUND;
--
--
            v_current_session := v_non_nmsb_session;
            v_nmsb :=
               transform.check_nmsb_session@web (p_stud_ref,
                                                 v_current_session,
                                                 v_current_nmsb_session
                                                );

            IF v_nmsb != 'OK'
            THEN
               DBMS_OUTPUT.put_line (v_nmsb);
               ROLLBACK;
            END IF;

--
      /* Create a workflow item and a warning */
            v_return_string := 'Writing Warning for Other Change';
            transform.write_warning@web (p_stud_ref,
                                         'New Change: ''' || v_change || '''.'
                                        );
--
            v_return_string := 'Creating Workflow Item for Other Change';

            IF NOT transform.create_workflow_item@web (p_stud_ref,
                                                       v_current_session,
                                                       'N',
                                                       v_error_str,
                                                       v_title_change_date
                                                      )
            THEN
               DBMS_OUTPUT.put_line (   'Unhandled exception '
                                     || TO_CHAR (SQLCODE)
                                     || ' ('
                                     || v_error_str
                                     || ') While '
                                     || v_return_string
                                     || ' for student '
                                     || TO_CHAR (p_stud_ref)
                                    );
               ROLLBACK;
               v_del := 'N';
            END IF;

--
             /* Delete the interface data */
            IF v_del = 'Y'
            THEN
               v_return_string := 'deleting from web OTHER_CHANGE table';
            --DELETE FROM OTHER_CHANGE
            --WHERE stud_ref_no = p_stud_ref;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (   'Unhandled exception '
                                     || TO_CHAR (SQLCODE)
                                     || ' While '
                                     || v_return_string
                                     || ' for student '
                                     || TO_CHAR (p_stud_ref)
                                    );
               ROLLBACK;
               v_del := 'N';
         END;

         COMMIT;
      END LOOP;

      CLOSE other_change;

      DBMS_OUTPUT.put_line (   '*** CHANGE OF DETAILS TRANSFER ENDING AT '
                            || TO_CHAR (SYSDATE, 'dd/mm/yyyy hh24:mi:ss')
                            || ' ***'
                           );
      COMMIT;
      RETURN ('OK');
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
   END grass_change_of_details;

/*****************************************************************************
* End of copy of TRANSFORM.change_of_details_copy from EBUST1
*
* 06-FEB-2008
*
*
******************************************************************************/
   PROCEDURE steps_change_of_details (
      p_stud_ref        IN       NUMBER,
      p_change_date     IN       DATE,
      p_change_type     IN       VARCHAR2,
      p_return_string   OUT      VARCHAR2
   )
   IS
      v_display_date   VARCHAR2 (1000);
   BEGIN
      --SELECT TO_CHAR (p_change_date, 'dd-mon-yy hh:mi')
       -- INTO v_display_date
       -- FROM DUAL;
      DBMS_OUTPUT.put_line ('in the function=' || p_change_type || '=');
      DBMS_OUTPUT.put_line (p_stud_ref || p_change_date || p_change_type);

      CASE p_change_type
         WHEN 'BANK'
         THEN
            steps_bank_change (p_stud_ref, p_change_date);
         WHEN 'HOME'
         THEN
            steps_home_change (p_stud_ref, p_change_date);
         WHEN 'LOAN'
         THEN
            steps_loan_change (p_stud_ref, p_change_date);
         WHEN 'MAIL'
         THEN
            steps_mail_change (p_stud_ref, p_change_date);
         WHEN 'NAME'
         THEN
            steps_name_change (p_stud_ref, p_change_date);
         WHEN 'OTHER'
         THEN
            steps_other_change (p_stud_ref, p_change_date);
         WHEN 'TERM'
         THEN
            steps_term_change (p_stud_ref, p_change_date);
         ELSE
            p_return_string := 'INVALID CHANGE TYPE';
      END CASE;

      p_return_string := 'NO ERROR';
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
   END steps_change_of_details;

   PROCEDURE steps_bank_change (p_stud_ref IN NUMBER, p_change_date IN DATE)
   IS
      CURSOR bank_cur
      IS
         SELECT account_no, sort_code, bank_validate
           FROM bank_change@web
          WHERE stud_ref_no = p_stud_ref
            AND TRUNC (change_date) = p_change_date;

      v_account_no      stud.account_no%TYPE      := NULL;
      v_sort_code       stud.sort_code%TYPE       := NULL;
      v_bank_validate   stud.bank_validate%TYPE   := NULL;
   BEGIN
      OPEN bank_cur;

      FETCH bank_cur
       INTO v_account_no, v_sort_code, v_bank_validate;

      IF v_account_no IS NOT NULL AND v_sort_code IS NOT NULL
      THEN
         UPDATE stud
            SET payment_method = 'B',
                account_no = v_account_no,
                sort_code = v_sort_code,
                bank_validate = v_bank_validate,
                build_soc_no = NULL,
                bank_name = NULL,
                bank_house_no_name = NULL,
                bank_addr_l1 = NULL,
                bank_addr_l2 = NULL,
                bank_addr_l3 = NULL,
                bank_addr_l4 = NULL,
                bank_post_code = NULL,
                last_updated_by = USER,
                last_updated_on = SYSDATE
          WHERE stud_ref_no = p_stud_ref;
      END IF;

      CLOSE bank_cur;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
   END steps_bank_change;

   PROCEDURE steps_mail_change (p_stud_ref IN NUMBER, p_change_date IN DATE)
   IS
      CURSOR mail_cur
      IS
         SELECT new_email, new_phone
           FROM email_mphone_change@web
          WHERE stud_ref_no = p_stud_ref
            AND TRUNC (change_date) = p_change_date;

      v_new_email   stud.email_addr%TYPE      := NULL;
      v_new_phone   stud.mobile_tel_no%TYPE   := NULL;
   BEGIN
      OPEN mail_cur;

      FETCH mail_cur
       INTO v_new_email, v_new_phone;

      IF v_new_email IS NOT NULL
      THEN
         UPDATE stud
            SET email_addr = v_new_email,
                last_updated_by = USER,
                last_updated_on = SYSDATE
          WHERE stud_ref_no = p_stud_ref;
      END IF;

      IF v_new_phone IS NOT NULL
      THEN
         UPDATE stud
            SET mobile_tel_no = v_new_phone,
                last_updated_by = USER,
                last_updated_on = SYSDATE
          WHERE stud_ref_no = p_stud_ref;
      END IF;

      CLOSE mail_cur;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
   END steps_mail_change;

   PROCEDURE steps_home_change (p_stud_ref IN NUMBER, p_change_date IN DATE)
   IS
      CURSOR home_cur
      IS
         SELECT UPPER (house_no_name), UPPER (addr_l1), UPPER (addr_l2),
                UPPER (addr_l3), UPPER (addr_l4), UPPER (post_code),
                UPPER (mailsort_code)
           FROM home_addr_change@web
          WHERE stud_ref_no = p_stud_ref
            AND TRUNC (change_date) = p_change_date;

      v_house_no_name   sgas.stud_home_addr.house_no_name%TYPE   := NULL;
      v_addr_l1         sgas.stud_home_addr.addr_l1%TYPE         := NULL;
      v_addr_l2         sgas.stud_home_addr.addr_l2%TYPE         := NULL;
      v_addr_l3         sgas.stud_home_addr.addr_l3%TYPE         := NULL;
      v_addr_l4         sgas.stud_home_addr.addr_l4%TYPE         := NULL;
      v_post_code       sgas.stud_home_addr.post_code%TYPE       := NULL;
      v_mailsort_code   sgas.stud_home_addr.mailsort%TYPE        := NULL;
   BEGIN
      OPEN home_cur;

      FETCH home_cur
       INTO v_house_no_name, v_addr_l1, v_addr_l2, v_addr_l3, v_addr_l4,
            v_post_code, v_mailsort_code;

      UPDATE sgas.stud_home_addr
         SET end_date = TRUNC (p_change_date) - 1
       WHERE stud_ref_no = p_stud_ref AND end_date IS NULL;

      DBMS_OUTPUT.put_line ('update stud_home_addr done');

      INSERT INTO sgas.stud_home_addr
                  (stud_ref_no, start_date, house_no_name, addr_l1,
                   addr_l2, addr_l3, addr_l4, post_code,
                   mailsort
                  )
           VALUES (p_stud_ref, SYSDATE, v_house_no_name, v_addr_l1,
                   v_addr_l2, v_addr_l3, v_addr_l4, v_post_code,
                   v_mailsort_code
                  );

      CLOSE home_cur;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
   END steps_home_change;

   PROCEDURE steps_loan_change (p_stud_ref IN NUMBER, p_change_date IN DATE)
   IS
/*******************************************************************************
 FIRST CONTACT DETAILS
 ******************************************************************************/
      CURSOR loan_cur1
      IS
         SELECT UPPER (name_1), UPPER (house_no_name_1), UPPER (addr_l1_1),
                UPPER (addr_l2_1), UPPER (addr_l3_1), UPPER (post_code_1),
                tel_no_1, rel_code_1
           FROM loan_contacts_change@web
          WHERE stud_ref_no = p_stud_ref
            AND TRUNC (change_date) = p_change_date;

      v_name_1            sgas.stud_cont_details.cont_name%TYPE       := NULL;
      v_house_no_name_1   VARCHAR2 (1000)                             := NULL;
      v_addr_l1_1         sgas.stud_cont_details.cont_addr1%TYPE      := NULL;
      v_addr_l2_1         sgas.stud_cont_details.cont_addr2%TYPE      := NULL;
      v_addr_l3_1         sgas.stud_cont_details.cont_addr3%TYPE      := NULL;
      v_post_code_1       sgas.stud_cont_details.cont_postcode%TYPE   := NULL;
      v_tel_no_1          sgas.stud_cont_details.cont_tel_no%TYPE     := NULL;
      v_rel_code_1        sgas.stud_cont_details.cont_rel_code%TYPE   := NULL;
      v_addr1_substring   VARCHAR2 (100)                              := NULL;

/*******************************************************************************
 SECOND CONTACT DETAILS
 ******************************************************************************/
      CURSOR loan_cur2
      IS
         SELECT UPPER (name_2), UPPER (house_no_name_2), UPPER (addr_l1_2),
                UPPER (addr_l2_2), UPPER (addr_l3_2), UPPER (post_code_2),
                tel_no_2
           FROM loan_contacts_change@web
          WHERE stud_ref_no = p_stud_ref
                AND TRUNC (change_date) = p_change_date;

      v_name_2            sgas.stud_cont_details.cont_name%TYPE       := NULL;
      v_house_no_name_2   VARCHAR2 (1000)                             := NULL;
      v_addr_l1_2         sgas.stud_cont_details.cont_addr1%TYPE      := NULL;
      v_addr_l2_2         sgas.stud_cont_details.cont_addr2%TYPE      := NULL;
      v_addr_l3_2         sgas.stud_cont_details.cont_addr3%TYPE      := NULL;
      v_post_code_2       sgas.stud_cont_details.cont_postcode%TYPE   := NULL;
      v_tel_no_2          sgas.stud_cont_details.cont_tel_no%TYPE     := NULL;
      v_addr2_substring   VARCHAR2 (100)                              := NULL;
      v_point             VARCHAR2 (1000);
      
   BEGIN
/*******************************************************************************
 FIRST CONTACT DETAILS
 ******************************************************************************/
      OPEN loan_cur1;

      FETCH loan_cur1
       INTO v_name_1, v_house_no_name_1, v_addr_l1_1, v_addr_l2_1,
            v_addr_l3_1, v_post_code_1, v_tel_no_1, v_rel_code_1;

      IF v_name_1 IS NOT NULL
      THEN
         v_point := 'update 1';
         v_addr1_substring := substr(v_addr_l1_1,0,length(v_house_no_name_1));
         IF v_addr1_substring = v_house_no_name_1
         THEN
         v_addr_l1_1 := substr(v_addr_l1_1,length(v_house_no_name_1)+1,length(v_addr_l1_1));
         END IF;

         IF f_cont1_exists (p_stud_ref)
         THEN
            UPDATE sgas.stud_cont_details
               SET cont_name = v_name_1,
                   cont_addr1 = v_house_no_name_1 || ' ' || v_addr_l1_1,
                   cont_addr2 = v_addr_l2_1,
                   cont_addr3 = v_addr_l3_1,
                   cont_postcode = v_post_code_1,
                   cont_tel_no = v_tel_no_1,
                   cont_rel_code = v_rel_code_1,
                   last_updated_by = USER,
                   last_updated_on = SYSDATE
             WHERE stud_ref_no = p_stud_ref AND contact_ind = 1;
         ELSE
            v_point := 'insert 1';

            INSERT INTO sgas.stud_cont_details
                        (stud_ref_no, contact_ind, cont_name,
                         cont_addr1,
                         cont_addr2, cont_addr3, cont_postcode,
                         cont_tel_no, last_updated_by, last_updated_on
                        )
                 VALUES (p_stud_ref, 1, v_name_1,
                         v_house_no_name_1 || ' ' || v_addr_l1_1,
                         v_addr_l2_1, v_addr_l3_1, v_post_code_1,
                         v_tel_no_1, USER, SYSDATE
                        );
         END IF;
      END IF;

      CLOSE loan_cur1;

/*******************************************************************************
 SECOND CONTACT DETAILS
 ******************************************************************************/
      OPEN loan_cur2;

      FETCH loan_cur2
       INTO v_name_2, v_house_no_name_2, v_addr_l1_2, v_addr_l2_2,
            v_addr_l3_2, v_post_code_2, v_tel_no_2;

      IF v_name_2 IS NOT NULL
      THEN
       v_addr2_substring := substr(v_addr_l1_2,0,length(v_house_no_name_2));
      
        IF v_addr2_substring = v_house_no_name_2
        THEN
        v_addr_l1_2 := substr(v_addr_l1_2,length(v_house_no_name_2)+1,length(v_addr_l1_2));
        END IF;
        
         IF f_cont2_exists (p_stud_ref)
         THEN
            v_point := 'update 2';

            UPDATE sgas.stud_cont_details
               SET cont_name = v_name_2,
                   cont_addr1 = v_house_no_name_2 || ' ' || v_addr_l1_2,
                   cont_addr2 = v_addr_l2_2,
                   cont_addr3 = v_addr_l3_2,
                   cont_postcode = v_post_code_2,
                   cont_tel_no = v_tel_no_2,
                   last_updated_by = USER,
                   last_updated_on = SYSDATE
             WHERE stud_ref_no = p_stud_ref AND contact_ind = 2;
         ELSE
            v_point := 'insert 2';

            INSERT INTO sgas.stud_cont_details
                        (stud_ref_no, contact_ind, cont_name,
                         cont_addr1,
                         cont_addr2, cont_addr3, cont_postcode,
                         cont_tel_no, last_updated_by, last_updated_on
                        )
                 VALUES (p_stud_ref, 2, v_name_2,
                         v_house_no_name_2 || ' ' || v_addr_l1_2,
                         v_addr_l2_2, v_addr_l3_2, v_post_code_2,
                         v_tel_no_2, USER, SYSDATE
                        );
         END IF;
      END IF;

      CLOSE loan_cur2;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (v_point || ' ' || SQLCODE || SQLERRM);
   END steps_loan_change;

   PROCEDURE steps_name_change (p_stud_ref IN NUMBER, p_change_date IN DATE)
   IS
      CURSOR name_cur
      IS
         SELECT UPPER (title), UPPER (forenames), UPPER (surname),
                UPPER (birth_forenames), UPPER (birth_surname)
           FROM title_name_change@web
          WHERE stud_ref_no = p_stud_ref
            AND TRUNC (change_date) = p_change_date;

      v_title             stud.title%TYPE             := NULL;
      v_forenames         stud.forenames%TYPE         := NULL;
      v_surname           stud.surname%TYPE           := NULL;
      v_birth_forenames   stud.birth_forenames%TYPE   := NULL;
      v_birth_surname     stud.birth_surname%TYPE     := NULL;
   BEGIN
      OPEN name_cur;

      FETCH name_cur
       INTO v_title, v_forenames, v_surname, v_birth_forenames,
            v_birth_surname;

      UPDATE stud
         SET stud.title = v_title,
             stud.forenames = v_forenames,
             stud.surname = v_surname,
             stud.birth_forenames = v_birth_forenames,
             stud.birth_surname = v_birth_surname,
             last_updated_by = USER,
             last_updated_on = SYSDATE
       WHERE stud.stud_ref_no = p_stud_ref;

      CLOSE name_cur;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
   END steps_name_change;

   PROCEDURE steps_term_change (p_stud_ref IN NUMBER, p_change_date IN DATE)
   IS
      CURSOR term_cur
      IS
         SELECT UPPER (house_no_name), UPPER (addr_l1), UPPER (addr_l2),
                UPPER (addr_l3), UPPER (addr_l4), UPPER (post_code),
                UPPER (residence_ind)
           FROM term_addr_change@web
          WHERE stud_ref_no = p_stud_ref
            AND TRUNC (change_date) = p_change_date;

      v_house_no_name   sgas.stud_term_addr.house_no_name%TYPE   := NULL;
      v_addr_l1         sgas.stud_term_addr.addr_l1%TYPE         := NULL;
      v_addr_l2         sgas.stud_term_addr.addr_l2%TYPE         := NULL;
      v_addr_l3         sgas.stud_term_addr.addr_l3%TYPE         := NULL;
      v_addr_l4         sgas.stud_term_addr.addr_l4%TYPE         := NULL;
      v_post_code       sgas.stud_term_addr.post_code%TYPE       := NULL;
      v_residence_ind   sgas.stud_term_addr.residence_ind%TYPE   := NULL;
   BEGIN
      DBMS_OUTPUT.put_line (   'in term change='
                            || p_stud_ref
                            || '='
                            || p_change_date
                           );

      OPEN term_cur;

      FETCH term_cur
       INTO v_house_no_name, v_addr_l1, v_addr_l2, v_addr_l3, v_addr_l4,
            v_post_code, v_residence_ind;

      DBMS_OUTPUT.put_line ('postfetch=' || SQLCODE);

      UPDATE sgas.stud_term_addr
         SET end_date = TRUNC (p_change_date) - 1
       WHERE stud_ref_no = p_stud_ref AND end_date IS NULL;

      DBMS_OUTPUT.put_line ('postupdate=' || SQLCODE);

      INSERT INTO sgas.stud_term_addr
                  (stud_ref_no, start_date, house_no_name, addr_l1,
                   addr_l2, addr_l3, addr_l4, post_code,
                   location_ind, residence_ind
                  )
           VALUES (p_stud_ref, SYSDATE, v_house_no_name, v_addr_l1,
                   v_addr_l2, v_addr_l3, v_addr_l4, v_post_code,
                   DECODE (v_residence_ind, 'P', 'H', 'E'), 'X'
                  );

      DBMS_OUTPUT.put_line ('postinsert=' || SQLCODE);

      CLOSE term_cur;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
   END steps_term_change;

   PROCEDURE steps_other_change (p_stud_ref IN NUMBER, p_change_date IN DATE)
   IS
   BEGIN
      NULL;
-- what are we are doing with these changes - existing manual process?
   END steps_other_change;

   FUNCTION f_cont1_exists (p_stud_ref IN NUMBER)
      RETURN BOOLEAN
   IS
      CURSOR cont1_cur
      IS
         SELECT 1
           FROM sgas.stud_cont_details
          WHERE stud_ref_no = p_stud_ref AND contact_ind = 1;

      v_result   NUMBER := 0;
   BEGIN
      OPEN cont1_cur;

      FETCH cont1_cur
       INTO v_result;

      IF v_result = 1
      THEN
         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;

      CLOSE cont1_cur;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
   END f_cont1_exists;

   FUNCTION f_cont2_exists (p_stud_ref IN NUMBER)
      RETURN BOOLEAN
   IS
      CURSOR cont2_cur
      IS
         SELECT 1
           FROM sgas.stud_cont_details
          WHERE stud_ref_no = p_stud_ref AND contact_ind = 2;

      v_result   NUMBER := 0;
   BEGIN
      OPEN cont2_cur;

      FETCH cont2_cur
       INTO v_result;

      IF v_result = 1
      THEN
         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;

      CLOSE cont2_cur;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
   END f_cont2_exists;

   PROCEDURE delete_web_change
   IS
   BEGIN
      DELETE FROM term_addr_change@web;

      DELETE FROM home_addr_change@web;

      DELETE FROM bank_change@web;

      DELETE FROM loan_contacts_change@web;

      DELETE FROM title_name_change@web;

      DELETE FROM email_mphone_change@web;

      DELETE FROM other_change@web;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('error deleting ' || SQLCODE || SQLERRM);
   END delete_web_change;
END pk_change_details;
/