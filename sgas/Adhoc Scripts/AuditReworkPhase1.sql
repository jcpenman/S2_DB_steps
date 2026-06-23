CREATE OR REPLACE TRIGGER SGAS.aw_aiu
   AFTER INSERT OR DELETE OR UPDATE OF amount, net_amount, contrib_amount
   ON SGAS.AWARD    FOR EACH ROW
DECLARE
   p_column_name         award_aud.column_name%TYPE     := NULL;
   p_old                 award_aud.OLD%TYPE             := NULL;
   p_new                 award_aud.NEW%TYPE             := NULL;
   p_action              award_aud.action%TYPE          := NULL;
   p_session_code        award.session_code%TYPE    := NULL;
   p_stud_crse_year_id   award.stud_crse_year_id%TYPE
                                                    := :OLD.stud_crse_year_id;
   p_src                 award.award_src%TYPE           := :OLD.award_src;
   p_stud_award_type     award.stud_award_type%TYPE;
   v_temp                VARCHAR2 (1)                   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_stud_crse_year_id := :NEW.stud_crse_year_id;
      p_src := :NEW.award_src;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_src := :OLD.award_src;
   END IF;

   SELECT session_code
     INTO p_session_code
     FROM stud_crse_year
    WHERE stud_crse_year_id = p_stud_crse_year_id;

   p_column_name := 'AMOUNT';
   p_old := TO_CHAR (:OLD.amount);
   p_new := TO_CHAR (:NEW.amount);

   IF p_src = 'T'
   THEN
      pk_steps_changes.award_net_change (p_old, p_new, p_stud_crse_year_id);
   END IF;

   p_column_name := 'NET_AMOUNT';
   p_old := TO_CHAR (:OLD.net_amount);
   p_new := TO_CHAR (:NEW.net_amount);

   IF p_src = 'T'
   THEN
      pk_steps_changes.award_net_change (p_old, p_new, p_stud_crse_year_id);
      pk_steps_changes.cslr_award (p_old, p_new, p_stud_crse_year_id);
   END IF;

   p_column_name := 'CONTRIB_AMOUNT';
   p_old := TO_CHAR (:OLD.contrib_amount);
   p_new := TO_CHAR (:NEW.contrib_amount);

   IF p_src = 'T'
   THEN
      pk_steps_changes.award_contrib_change (p_old,
                                             p_new,
                                             p_stud_crse_year_id
                                            );
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      v_temp := 'N';
END aw_aiu;
show errors;

CREATE OR REPLACE TRIGGER SGAS.awi_aiu
   AFTER INSERT OR DELETE OR UPDATE OF payment_due_date, net_amount
   ON SGAS.AWARD_INSTALMENT    FOR EACH ROW
DECLARE
   p_award_id   award.award_id%TYPE   := :OLD.award_id;
   v_chngd      VARCHAR2 (1)          := 'N';
BEGIN
   IF INSERTING
   THEN
      p_award_id := :NEW.award_id;
   END IF;

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
END awi_aiu;
show errors;

CREATE OR REPLACE TRIGGER SGAS.st_aiu
   AFTER INSERT OR UPDATE OF abroad,
                             dob,
                             title,
                             initials,
                             forenames,
                             surname,
                             sex,
                             birth_country_code,
                             residence_country_code,
                             nation_country_code,
                             ucas_no,
                             suspend_payment,
                             birth_forenames,
                             birth_surname,
                             district_birth_cert_issued,
                             addr_corr_flag,
                             bankrupt_flag,
                             travel_method,
                             bank_validate,
                             mobile_tel_no,
                             email_addr,
                             payment_method,
                             ni_no,
                             account_no,
                             sort_code,
                             stud_suspend
   ON SGAS.STUD    FOR EACH ROW
DECLARE
   p_stud_ref_no                  stud.stud_ref_no%TYPE   := :OLD.stud_ref_no;
   p_abroad                       stud.abroad%TYPE;
   p_dob                          stud.dob%TYPE;
   p_title                        stud.title%TYPE;
   p_initials                     stud.initials%TYPE;
   p_forenames                    stud.forenames%TYPE;
   p_surname                      stud.surname%TYPE;
   p_sex                          stud.sex%TYPE;
   p_birth_country_code           stud.birth_country_code%TYPE;
   p_residence_country_code       stud.residence_country_code%TYPE;
   p_nation_country_code          stud.nation_country_code%TYPE;
   p_ucas_no                      stud.ucas_no%TYPE;
   p_suspend_payment              stud.suspend_payment%TYPE;
   p_birth_forenames              stud.birth_forenames%TYPE;
   p_birth_surname                stud.birth_surname%TYPE;
   p_district_birth_cert_issued   stud.district_birth_cert_issued%TYPE;
   p_addr_corr_flag               stud.addr_corr_flag%TYPE;
   p_bankrupt_flag                stud.bankrupt_flag%TYPE;
   p_travel_method                stud.travel_method%TYPE;
   p_bank_validate                stud.bank_validate%TYPE;
   p_mobile_tel_no                stud.mobile_tel_no%TYPE;
   p_email_addr                   stud.email_addr%TYPE;
   p_payment_method               stud.payment_method%TYPE;
   p_ni_no                        stud.ni_no%TYPE;
   p_account_no                   stud.account_no%TYPE;
   p_sort_code                    stud.sort_code%TYPE;
   p_action                       VARCHAR2 (1)                        := NULL;
   update_batch_recalc            VARCHAR2 (1)                         := 'N';
   will_update                    VARCHAR2 (1)                         := 'N';
   v_chngd                        VARCHAR2 (1)                         := 'N';
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_stud_ref_no := :OLD.stud_ref_no;

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

   IF (NVL (:OLD.forenames, ' ') <> NVL (:NEW.forenames, ' '))
   THEN
      v_chngd := 'Y';
   ELSIF (NVL (:OLD.surname, ' ') <> NVL (:NEW.surname, ' '))
   THEN
      v_chngd := 'Y';
   ELSIF (:OLD.dob <> :NEW.dob)
   THEN
      v_chngd := 'Y';
   ELSIF (NVL (:OLD.stud_suspend, 'BLANK') <> NVL (:NEW.stud_suspend, 'BLANK')
         )
   THEN
      v_chngd := 'Y';
   END IF;

   IF v_chngd = 'Y'
   THEN
      p_stud_ref_no := :OLD.stud_ref_no;
      pk_steps_changes.cslr_stud (p_stud_ref_no);
   END IF;

   IF (    (:OLD.payment_method IS NOT NULL
            AND :NEW.payment_method IS NOT NULL
           )
       AND (:OLD.payment_method <> :NEW.payment_method)
      )
   THEN
      update_batch_recalc := 'Y';
   ELSIF (NVL (:OLD.ni_no, ' ') <> NVL (:NEW.ni_no, ' '))
   THEN
      update_batch_recalc := 'Y';
   ELSIF (NVL (:OLD.account_no, ' ') <> NVL (:NEW.account_no, ' '))
   THEN
      update_batch_recalc := 'Y';
   ELSIF (NVL (:OLD.sort_code, ' ') <> NVL (:NEW.sort_code, ' '))
   THEN
      update_batch_recalc := 'Y';
   END IF;

   IF update_batch_recalc = 'Y'
   THEN
      pk_steps_to_grass.update_batch_recalc (p_stud_ref_no,
                                             :NEW.payment_method,
                                             :NEW.ni_no,
                                             :NEW.account_no,
                                             :NEW.sort_code
                                            );
   END IF;

   IF p_action = 'I'
   THEN
      pk_steps_to_grass.update_stud_in_grass
                                            (p_stud_ref_no,
                                             :NEW.abroad,
                                             :NEW.dob,
                                             :NEW.title,
                                             :NEW.initials,
                                             :NEW.forenames,
                                             :NEW.surname,
                                             :NEW.sex,
                                             :NEW.birth_country_code,
                                             :NEW.residence_country_code,
                                             :NEW.nation_country_code,
                                             :NEW.ucas_no,
                                             :NEW.suspend_payment,
                                             :NEW.birth_forenames,
                                             :NEW.birth_surname,
                                             :NEW.district_birth_cert_issued,
                                             :NEW.addr_corr_flag,
                                             :NEW.bankrupt_flag,
                                             :NEW.travel_method,
                                             :NEW.bank_validate,
                                             :NEW.mobile_tel_no,
                                             :NEW.email_addr,
                                             :NEW.payment_method,
                                             :NEW.ni_no,
                                             :NEW.account_no,
                                             :NEW.sort_code
                                            );
   ELSIF p_action = 'U'
   THEN
      pk_steps_to_grass.update_stud_in_grass
                                            (p_stud_ref_no,
                                             :NEW.abroad,
                                             :NEW.dob,
                                             :NEW.title,
                                             :NEW.initials,
                                             :NEW.forenames,
                                             :NEW.surname,
                                             :NEW.sex,
                                             :NEW.birth_country_code,
                                             :NEW.residence_country_code,
                                             :NEW.nation_country_code,
                                             :NEW.ucas_no,
                                             :NEW.suspend_payment,
                                             :NEW.birth_forenames,
                                             :NEW.birth_surname,
                                             :NEW.district_birth_cert_issued,
                                             :NEW.addr_corr_flag,
                                             :NEW.bankrupt_flag,
                                             :NEW.travel_method,
                                             :NEW.bank_validate,
                                             :NEW.mobile_tel_no,
                                             :NEW.email_addr,
                                             :NEW.payment_method,
                                             :NEW.ni_no,
                                             :NEW.account_no,
                                             :NEW.sort_code
                                            );
   END IF;

   /* Update the unpaid award_instalment to pay by new method*/
   IF     (NVL (:OLD.payment_method, ' ') <> NVL (:NEW.payment_method, ' '))
      AND :NEW.payment_method = 'B'
   THEN
      pk_steps_to_grass.update_aw_inst (p_stud_ref_no);

      /* Re-send student to the SLC for FILE 2 ONLY*/
      UPDATE stud_crse_year
         SET slc2_sent = 'N'
       WHERE stud_crse_year_id =
                (SELECT MAX (stud_crse_year_id)
                   FROM stud_crse_year
                  WHERE stud_ref_no = p_stud_ref_no
                    AND latest_crse_ind = 'Y'
                    AND first_slc1_sent_date IS NOT NULL);
   END IF;
END st_aiu;
show errors;

CREATE OR REPLACE TRIGGER SGAS.stcy_aiu
   AFTER INSERT OR DELETE OR UPDATE OF auto_calc_date,
                                       sal_sent_date,
                                       session_code,
                                       crse_year_no,
                                       inst_code,
                                       crse_id,
                                       crse_code,
                                       crse_name,
                                       crse_suspend,
                                       repeat_year,
                                       application_status,
                                       sal_sent,
                                       withdraw_date,
                                       latest_crse_ind,
                                       slc2_status,
                                       slc2_sent,
                                       slc2_sent_date,
                                       entered_date,
                                       study_abroad,
                                       paid_sandwich,
                                       unpaid_sandwich
   ON SGAS.STUD_CRSE_YEAR    FOR EACH ROW
DECLARE
   p_action              stud_crse_year_aud.action%TYPE               := NULL;
   p_username            stud_crse_year_aud.username%TYPE  := :NEW.last_updated_by;
   p_stud_ref_no         stud_crse_year.stud_ref_no%TYPE         := NULL;
   p_inst_code           stud_crse_year.inst_code%TYPE           := NULL;
   p_session_code        stud_crse_year.session_code%TYPE
                                                         := :NEW.session_code;
   p_stud_crse_year_id   stud_crse_year.stud_crse_year_id%TYPE   := NULL;
   will_update           VARCHAR2 (1)                            := 'N';
   v_chngd               VARCHAR2 (1)                            := 'N';
   v_result              VARCHAR2 (1);
   v_default_date        DATE       := TO_DATE ('01/JAN/2000', 'DD/MON/YYYY');
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
      p_session_code := :OLD.session_code;

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
      p_stud_crse_year_id := :NEW.stud_crse_year_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';

      IF :OLD.session_code <> :NEW.session_code
      THEN
         will_update := 'Y';
      ELSIF (NVL (:OLD.crse_year_no, '0') <> NVL (:NEW.crse_year_no, '0'))
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
      ELSIF (NVL (:OLD.withdraw_date, '01/JAN/1900') <>
                                       NVL (:NEW.withdraw_date, '01/JAN/1900')
            )
      THEN
         v_chngd := 'Y';
      ELSIF (NVL (:OLD.study_abroad, ' ') <> NVL (:NEW.study_abroad, ' '))
      THEN
         v_chngd := 'Y';
      ELSIF (NVL (:OLD.paid_sandwich, ' ') <> NVL (:NEW.paid_sandwich, ' '))
      THEN
         v_chngd := 'Y';
      ELSIF (NVL (:OLD.unpaid_sandwich, ' ') <>
                                               NVL (:NEW.unpaid_sandwich, ' ')
            )
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
END stcy_aiu;
show errors;

CREATE OR REPLACE TRIGGER SGAS.sts_aiu
   AFTER UPDATE OF session_suspend
   ON SGAS.STUD_SESSION    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   p_action            stud_session_aud.action%TYPE        := NULL;
   p_stud_session_id   stud_session.stud_session_id%TYPE
                                                      := :OLD.stud_session_id;
   v_chngd             VARCHAR2 (1)                        := 'N';
BEGIN
   IF UPDATING
   THEN
      p_action := 'U';
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
END sts_aiu;
show errors;

CREATE OR REPLACE TRIGGER SGAS.sthome_iud
   AFTER INSERT OR DELETE OR UPDATE OF addr_l1,
                                       addr_l2,
                                       addr_l3,
                                       addr_l4,
                                       house_no_name,
                                       post_code,
                                       tele_no,
                                       end_date,
                                       mailsort,
                                       last_updated_by
   ON SGAS.STUD_HOME_ADDR    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   p_aud_date       DATE                                   := SYSDATE;
   p_column_name    stud_home_addr_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_home_addr_aud.table_pkey1%TYPE   := :OLD.stud_ref_no;
   p_table_pkey2    stud_home_addr_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_home_addr_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_home_addr_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_home_addr_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_home_addr_aud.OLD%TYPE            := NULL;
   p_new            stud_home_addr_aud.NEW%TYPE            := NULL;
   p_action         stud_home_addr_aud.action%TYPE         := NULL;
   p_username       stud_home_addr_aud.username%TYPE  := :NEW.last_updated_by;
   p_stud_ref_no    stud_home_addr_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      stud_home_addr_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_home_addr_aud.session_code%TYPE   := NULL;
   p_table_name     VARCHAR2 (32)                         := 'STUD_HOME_ADDR';
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_ref_no;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'HOUSE_NO_NAME';
   p_old := :OLD.house_no_name;
   p_new := :NEW.house_no_name;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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
   p_column_name := 'HOME_ADDR_L1';
   p_old := :OLD.addr_l1;
   p_new := :NEW.addr_l1;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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
   p_column_name := 'HOME_ADDR_L2';
   p_old := :OLD.addr_l2;
   p_new := :NEW.addr_l2;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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
   p_column_name := 'HOME_ADDR_L3';
   p_old := :OLD.addr_l3;
   p_new := :NEW.addr_l3;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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
   p_column_name := 'HOME_ADDR_L4';
   p_old := :OLD.addr_l4;
   p_new := :NEW.addr_l4;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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
   p_column_name := 'HOME_POST_CODE';
   p_old := :OLD.post_code;
   p_new := :NEW.post_code;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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
   p_column_name := 'HOME_TELE_NO';
   p_old := :OLD.tele_no;
   p_new := :NEW.tele_no;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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
   p_column_name := 'END_DATE';
   p_old := :OLD.end_date;
   p_new := :NEW.end_date;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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
   p_column_name := 'MAILSORT';
   p_old := :OLD.mailsort;
   p_new := :NEW.mailsort;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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
END sthome_iud;
show errors;

CREATE OR REPLACE TRIGGER SGAS.stapp_iud
   AFTER INSERT OR DELETE OR UPDATE OF award_letter_sent_date,
                                       date_calculated,
                                       last_updated_by
   ON SGAS.STUD_APP_PROG    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    stud_app_prog_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_app_prog_aud.table_pkey1%TYPE    := :OLD.stud_ref_no;
   p_table_pkey2    stud_app_prog_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_app_prog_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_app_prog_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_app_prog_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_app_prog_aud.OLD%TYPE            := NULL;
   p_new            stud_app_prog_aud.NEW%TYPE            := NULL;
   p_action         stud_app_prog_aud.action%TYPE         := NULL;
   p_username       stud_app_prog_aud.username%TYPE       := :NEW.last_updated_by;
   p_stud_ref_no    stud_app_prog_aud.stud_ref_no%TYPE    := :OLD.stud_ref_no;
   p_inst_code      stud_app_prog_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_app_prog_aud.session_code%TYPE   := NULL;
   p_table_name     VARCHAR2 (32)                         := 'STUD_APP_PROG';
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_ref_no;
      p_stud_ref_no := :NEW.stud_ref_no;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.stud_ref_no;
      p_stud_ref_no := :OLD.stud_ref_no;
      p_username    := :OLD.last_updated_by;
   END IF;

   p_column_name := 'AWARD_LETTER_SENT_DATE';
   p_old := :OLD.award_letter_sent_date;
   p_new := :NEW.award_letter_sent_date;
   pk_steps_aud.ins_stapp_aud (p_aud_date,
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
   p_column_name := 'DATE_CALCULATED';
   p_old := :OLD.date_calculated;
   p_new := :NEW.date_calculated;
   pk_steps_aud.ins_stapp_aud (p_aud_date,
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
   p_old := :OLD.LAST_UPDATED_BY;
   p_new := :NEW.LAST_UPDATED_BY;
   pk_steps_aud.ins_stapp_aud (p_aud_date,
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
END stapp_iud;
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
   p_stud_award_type     award.stud_award_type%TYPE;

BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.award_id;
      p_stud_ref_no := :NEW.stud_ref_no;
      p_stud_crse_year_id := :NEW.stud_crse_year_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.award_id;
      p_username := :OLD.last_updated_by;
   END IF;
   
   

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
END aw_iud;
show errors;

CREATE OR REPLACE TRIGGER SGAS.awi_iud
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
   ON SGAS.AWARD_INSTALMENT    FOR EACH ROW
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
   p_award_id         award.award_id%TYPE                    := :OLD.award_id;

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
END awi_iud;
show errors;

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
   IF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
      p_table_pkey1 := :NEW.stud_ref_no;
      p_username := :NEW.last_updated_by;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_stud_ref_no := :OLD.stud_ref_no;
      p_table_pkey1 := :OLD.stud_ref_no;
      p_username := :OLD.last_updated_by;
   END IF;

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
END st_iud;
show errors;

CREATE OR REPLACE TRIGGER SGAS.stcy_iud
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
             calc_loan, calc_dep_grant, calc_lpg, calc_lpcg, pay_ysb, pgce_edu_level, pgce_subject, first_calc_date, psas_pt, crse_suspend,crse_code,crse_name,last_updated_by
   ON SGAS.STUD_CRSE_YEAR    FOR EACH ROW
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
   p_session_code        stud_crse_year.session_code%TYPE
                                                         := :NEW.session_code;
   p_stud_crse_year_id   stud_crse_year.stud_crse_year_id%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
      p_table_pkey1 := :NEW.stud_crse_year_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
      p_stud_ref_no := :OLD.stud_ref_no;
      p_table_pkey1 := :OLD.stud_crse_year_id;
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
   p_column_name := 'CRSE_CODE';
   p_old := :OLD.crse_code;
   p_new := :NEW.crse_code;
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
   p_column_name := 'CRSE_NAME';
   p_old := :OLD.crse_name;
   p_new := :NEW.crse_name;
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
END stcy_iud;
show errors;

CREATE OR REPLACE TRIGGER SGAS.sts_iud
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
   ON SGAS.STUD_SESSION    REFERENCING OLD AS OLD NEW AS NEW
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
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_session_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_session_code := :OLD.session_code;
      p_stud_ref_no := :OLD.stud_ref_no;
      p_username := :OLD.last_updated_by;
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

drop trigger sgas.aw_ref_dat_iud;
drop trigger sgas.ben_inc_stat_iud;
drop trigger sgas.ben_inc_type_iud;
drop trigger sgas.ben_rel_iud;
drop trigger sgas.case_stat_iud;
drop trigger sgas.con_rel_iud;
drop trigger sgas.dear_stat_iud;
drop trigger sgas.debt_stat_iud;
drop trigger sgas.dis_type_iud;
drop trigger sgas.dsa_ac_iud;
drop trigger sgas.dsa_pay_stat_iud;
drop trigger sgas.dsa_ref_iud;
drop trigger sgas.dsa_rej_iud;
drop trigger sgas.dsa_stud_type_iud;
drop trigger sgas.dsa_type_iud;
drop trigger sgas.dup_bank_rea_iud;
drop trigger sgas.emp_stat_iud;
drop trigger sgas.fee_loa_type_iud;
drop trigger sgas.loan_stat_iud;
drop trigger sgas.loc_iud;
drop trigger sgas.mar_stat_iud;
drop trigger sgas.no_nino_rea_iud;
drop trigger sgas.oth_loa_type_iud;
drop trigger sgas.pay_meth_iud;
drop trigger sgas.pgce_sub_iud;
drop trigger sgas.res_iud;
drop trigger sgas.res_type_iud;
drop trigger sgas.sch_type_iud;
drop trigger sgas.spo_type_iud;
drop trigger sgas.supp_grant_rel_iud;
drop trigger sgas.title_iud;
drop trigger sgas.z_ref_stat_iud;
drop table sgas.award_ref_data_aud;
drop table sgas.ben_income_status_aud;
drop table sgas.ben_income_type_aud;
drop table sgas.benefactor_relation_aud;
drop table sgas.case_status_aud;
drop table sgas.contact_relationship_aud;
drop table sgas.dearing_status_aud;
drop table sgas.debt_status_aud;
drop table sgas.disability_type_aud;
drop table sgas.dsa_assessment_centre_aud;
drop table sgas.dsa_payment_status_aud;
drop table sgas.dsa_referral_reason_aud;
drop table sgas.dsa_rejection_reason_aud;
drop table sgas.dsa_student_type_aud;
drop table sgas.dsa_type_aud;
drop table sgas.dup_bank_reason_aud;
drop table sgas.employment_status_aud;
drop table sgas.fee_loan_type_aud;
drop table sgas.loan_status_aud;
drop table sgas.location_aud;
drop table sgas.marital_status_aud;
drop table sgas.no_nino_reason_aud;
drop table sgas.other_loan_type_aud;
drop table sgas.payment_method_aud;
drop table sgas.pgce_subject_aud;
drop table sgas.residence_aud;
drop table sgas.residence_type_aud;
drop table sgas.scheme_type_aud;
drop table sgas.spouse_type_aud;
drop table sgas.supp_grant_relation_aud;
drop table sgas.title_aud;
drop table sgas.z_refusal_status_aud;
drop sequence sgas.aw_ref_dat_aud_id_seq;
drop sequence sgas.ben_inc_stat_aud_id_seq;
drop sequence sgas.ben_inc_type_aud_id_seq;
drop sequence sgas.ben_rel_aud_id_seq;
drop sequence sgas.case_stat_aud_id_seq;
drop sequence sgas.con_rel_aud_id_seq;
drop sequence sgas.dear_stat_aud_id_seq;
drop sequence sgas.debt_stat_aud_id_seq;
drop sequence sgas.dis_type_aud_id_seq;
drop sequence sgas.dsa_ac_aud_id_seq;
drop sequence sgas.dsa_pay_stat_aud_id_seq;
drop sequence sgas.dsa_ref_aud_id_seq;
drop sequence sgas.dsa_rej_aud_id_seq;
drop sequence sgas.dsa_stud_type_aud_id_seq;
drop sequence sgas.dsa_type_aud_id_seq;
drop sequence sgas.dup_bank_reason_aud_id_seq;
drop sequence sgas.emp_stat_aud_id_seq;
drop sequence sgas.fee_loa_type_aud_id_seq;
drop sequence sgas.loan_stat_aud_id_seq;
drop sequence sgas.loc_aud_id_seq;
drop sequence sgas.mar_stat_aud_id_seq;
drop sequence sgas.no_nino_reason_aud_id_seq;
drop sequence sgas.oth_loa_type_aud_id_seq;
drop sequence sgas.pay_meth_aud_id_seq;
drop sequence sgas.pgce_sub_aud_id_seq;
drop sequence sgas.res_aud_id_seq;
drop sequence sgas.res_type_aud_id_seq;
drop sequence sgas.sch_type_aud_id_seq;
drop sequence sgas.spo_type_aud_id_seq;
drop sequence sgas.sup_grant_rel_aud_id_seq;
drop sequence sgas.title_aud_id_seq;
drop sequence sgas.z_ref_stat_aud_id_seq;


/* Formatted on 2012/10/09 15:20 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_aud
IS
-- DESCRIPTION
-- ===========
-- Package to insert records into the respective audit tables on the
-- StEPS database when table columns are changed or records deleted.
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
-- 02.02.2009           A.Bowman    004    Added payment error codes audit requirement
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
   );

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
   );

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
   );

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
   );

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
   );

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
   );

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
   );

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
   );

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
   );

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
   );

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
   );

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
   );

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
   );

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
   );

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
   );

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
   );

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
   );

   PROCEDURE ins_nom_aud (
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
   );

   PROCEDURE ins_stud_nom_aud (
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
   );

   PROCEDURE ins_dsa_cat_aud (
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
   );

   PROCEDURE ins_dsa_app_aud (
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
   );

   PROCEDURE ins_dsa_all_aud (
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
   );

   PROCEDURE ins_dsa_pay_aud (
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
   );

   PROCEDURE ins_pay_paymt_aud (
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
   );

   PROCEDURE ins_fin_rev_jou_aud (
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
   );

   PROCEDURE ins_pay_aud (
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
   );

   PROCEDURE ins_adi_jou_aud (
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
   );

   PROCEDURE ins_pay_inst_aud (
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
   );

   PROCEDURE ins_fpd_aud (
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
   );

   PROCEDURE ins_napd_aud (
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
   );

   PROCEDURE ins_att_data_aud (
      p_aud_date      DATE,
      p_column_name   VARCHAR2,
      p_table_pkey1   VARCHAR2,
      p_old           VARCHAR2,
      p_new           VARCHAR2,
      p_action        VARCHAR2,
      p_username      VARCHAR2
   );

   PROCEDURE set_uid4audit_aw_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2);

   PROCEDURE set_uid4audit_awi_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2);

   PROCEDURE set_uid4audit_bed_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2);

   PROCEDURE set_uid4audit_bei_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2);

   PROCEDURE set_uid4audit_ben_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2);

   PROCEDURE set_uid4audit_cn_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2);

   PROCEDURE set_uid4audit_jac_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2);

   PROCEDURE set_uid4audit_sqd_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2);

   PROCEDURE set_uid4audit_st_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2);

   PROCEDURE set_uid4audit_stapp_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   );

   PROCEDURE set_uid4audit_stcy_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   );

   PROCEDURE set_uid4audit_std_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2);

   PROCEDURE set_uid4audit_sthome_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   );

   PROCEDURE set_uid4audit_sts_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2);

   PROCEDURE set_uid4audit_sc_bat_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   );

   PROCEDURE set_uid4audit_auth_stud_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   );

   PROCEDURE set_uid4audit_sta_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2);

   PROCEDURE set_uid4audit_nom_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2);

   PROCEDURE set_uid4audit_stud_nom_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   );

   PROCEDURE set_uid4audit_dsa_cat_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   );

   PROCEDURE set_uid4audit_dsa_app_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   );

   PROCEDURE set_uid4audit_dsa_all_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   );

   PROCEDURE set_uid4audit_dsa_pay_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   );

   PROCEDURE set_uid4audit_pay_paymt_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   );

   PROCEDURE set_uid4audit_fin_rev_jou_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   );

   PROCEDURE set_uid4audit_pay_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2);

   PROCEDURE set_uid4audit_adi_jou_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   );

   PROCEDURE set_uid4audit_pay_inst_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   );

   PROCEDURE set_uid4audit_fpd_aud (p_user_id VARCHAR2, p_table_pkey1 VARCHAR2);

   PROCEDURE set_uid4audit_napd_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   );
END pk_steps_aud;
/

/* Formatted on 2012/10/09 15:11 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY sgas.pk_steps_aud
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

   PROCEDURE ins_nom_aud (
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

   PROCEDURE ins_dsa_cat_aud (
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

   PROCEDURE ins_dsa_app_aud (
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

   PROCEDURE ins_pay_inst_aud (
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

   PROCEDURE ins_att_data_aud (
      p_aud_date      DATE,
      p_column_name   VARCHAR2,
      p_table_pkey1   VARCHAR2,
      p_old           VARCHAR2,
      p_new           VARCHAR2,
      p_action        VARCHAR2,
      p_username      VARCHAR2
   )
   AS
      pl_aud_id   attendance_data_aud.aud_id%TYPE;
   BEGIN
      IF (p_action = 'D')
      THEN
         SELECT att_data_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO attendance_data_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_old, p_new, p_action, p_username
                     );
      ELSIF (NVL (p_old, ' ') <> NVL (p_new, ' '))
      THEN
         SELECT att_data_aud_id_seq.NEXTVAL
           INTO pl_aud_id
           FROM DUAL;

         INSERT INTO attendance_data_aud
                     (aud_id, aud_date, column_name, table_pkey1,
                      OLD, NEW, action, username
                     )
              VALUES (pl_aud_id, p_aud_date, p_column_name, p_table_pkey1,
                      p_old, p_new, p_action, p_username
                     );
      END IF;
   END ins_att_data_aud;

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

   PROCEDURE set_uid4audit_sc_bat_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   )
   AS
   BEGIN
      UPDATE scoap_batches_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_auth_stud_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   )
   AS
   BEGIN
      UPDATE authenticate_stud_aud
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

   PROCEDURE set_uid4audit_stud_nom_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_nominee_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dsa_cat_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   )
   AS
   BEGIN
      UPDATE dsa_category_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dsa_app_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   )
   AS
   BEGIN
      UPDATE dsa_application_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dsa_all_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   )
   AS
   BEGIN
      UPDATE dsa_allowance_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_dsa_pay_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   )
   AS
   BEGIN
      UPDATE dsa_payment_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_pay_paymt_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   )
   AS
   BEGIN
      UPDATE payee_payment_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_fin_rev_jou_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   )
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

   PROCEDURE set_uid4audit_adi_jou_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   )
   AS
   BEGIN
      UPDATE adi_journal_aud
         SET username = p_user_id
       WHERE table_pkey1 = p_table_pkey1
         AND action = 'D'
         AND aud_date BETWEEN SYSDATE - (1 / 24) AND SYSDATE;
   END;

   PROCEDURE set_uid4audit_pay_inst_aud (
      p_user_id       VARCHAR2,
      p_table_pkey1   VARCHAR2
   )
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
END pk_steps_aud;
/

EXEC DBMS_UTILITY.compile_schema(schema => 'SGAS');

PURGE RECYCLEBIN;
