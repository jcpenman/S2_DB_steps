-- Adhoc to re-create synch triggers and award inst seq trigger
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      22.09.2010  A.Bowman (SAAS)         Initial Version.
-- 1.1      12.10.2010  A.Bowman (SAAS)         Updated version
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

CREATE OR REPLACE TRIGGER sgas.scd_aiu
   AFTER INSERT OR UPDATE OF cont_name,
                             cont_postcode,
                             cont_addr1,
                             cont_addr2,
                             cont_addr3,
                             cont_tel_no,
                             cont_rel_code
   ON sgas.stud_cont_details
   FOR EACH ROW
DECLARE
   p_stud_ref_no     stud_cont_details.stud_ref_no%TYPE   := :OLD.stud_ref_no;
   p_contact_ind     stud_cont_details.contact_ind%TYPE   := :OLD.contact_ind;
   p_cont_name       stud_cont_details.cont_name%TYPE;
   p_cont_postcode   stud_cont_details.cont_postcode%TYPE;
   p_cont_addr1      stud_cont_details.cont_addr1%TYPE;
   p_cont_addr2      stud_cont_details.cont_addr2%TYPE;
   p_cont_addr3      stud_cont_details.cont_addr3%TYPE;
   p_cont_tel_no     stud_cont_details.cont_tel_no%TYPE;
   p_cont_rel_code   stud_cont_details.cont_rel_code%TYPE;
   p_action          VARCHAR2 (1)                           := NULL;

BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_stud_ref_no := :OLD.stud_ref_no;
   END IF;

   IF p_action = 'I'                               
   THEN
      pk_steps_to_grass.update_scd_in_grass (:NEW.stud_ref_no,
                                             :NEW.contact_ind,
                                             :NEW.cont_name,
                                             :NEW.cont_postcode,
                                             :NEW.cont_addr1,
                                             :NEW.cont_addr2,
                                             :NEW.cont_addr3,
                                             :NEW.cont_tel_no,
                                             :NEW.cont_rel_code
                                            );
   ELSIF p_action = 'U'                             
   THEN
      pk_steps_to_grass.update_scd_in_grass (:OLD.stud_ref_no,
                                             :OLD.contact_ind,
                                             :NEW.cont_name,
                                             :NEW.cont_postcode,
                                             :NEW.cont_addr1,
                                             :NEW.cont_addr2,
                                             :NEW.cont_addr3,
                                             :NEW.cont_tel_no,
                                             :NEW.cont_rel_code
                                            );
   END IF;
END scd_aiu;
/

show errors;

CREATE OR REPLACE TRIGGER sgas.st_aiu
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
                             sort_code
   ON sgas.stud
   FOR EACH ROW
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
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_stud_ref_no := :OLD.stud_ref_no;
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

   IF update_batch_recalc = 'Y'
   THEN
      pk_steps_to_grass.update_batch_recalc (p_stud_ref_no);
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
/

show errors;

CREATE OR REPLACE TRIGGER sgas.sth_aiu
   AFTER INSERT OR UPDATE OF out_uk,
                             house_no_name,
                             addr_l1,
                             addr_l2,
                             addr_l3,
                             addr_l4,
                             post_code,
                             addr_easting,
                             addr_northing,
                             tele_no,
                             end_date,
                             mailsort
   ON sgas.stud_home_addr
   FOR EACH ROW
DECLARE
   p_stud_ref_no     stud_home_addr.stud_ref_no%TYPE     := :OLD.stud_ref_no;
   p_start_date      stud_home_addr.start_date%TYPE      := SYSDATE;
   p_out_uk          stud_home_addr.out_uk%TYPE;
   p_house_no_name   stud_home_addr.house_no_name%TYPE;
   p_addr_l1         stud_home_addr.addr_l1%TYPE;
   p_addr_l2         stud_home_addr.addr_l2%TYPE;
   p_addr_l3         stud_home_addr.addr_l3%TYPE;
   p_addr_l4         stud_home_addr.addr_l4%TYPE;
   p_post_code       stud_home_addr.post_code%TYPE;
   p_addr_easting    stud_home_addr.addr_easting%TYPE;
   p_addr_northing   stud_home_addr.addr_northing%TYPE;
   p_tele_no         stud_home_addr.tele_no%TYPE;
   p_end_date        stud_home_addr.end_date%TYPE        := NULL;
   p_mailsort        stud_home_addr.mailsort%TYPE;
   p_action          VARCHAR2 (1)                        := NULL;
   v_ben1            VARCHAR2 (1)                        := NULL;
   v_ben2            VARCHAR2 (1)                        := NULL;
BEGIN
   -- dbms_output.put_line('*******TRIGGER1 HAS FIRED*******');
   IF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_stud_ref_no := :OLD.stud_ref_no;
   END IF;

   IF p_action = 'I'
   THEN
      pk_steps_to_grass.update_sha_in_grass (:NEW.stud_ref_no,
                                             :NEW.start_date,
                                             :NEW.out_uk,
                                             :NEW.house_no_name,
                                             :NEW.addr_l1,
                                             :NEW.addr_l2,
                                             :NEW.addr_l3,
                                             :NEW.addr_l4,
                                             :NEW.post_code,
                                             :NEW.addr_easting,
                                             :NEW.addr_northing,
                                             :NEW.tele_no,
                                             :NEW.end_date,
                                             :NEW.mailsort
                                            );
   ELSIF p_action = 'U'
   THEN
      pk_steps_to_grass.update_sha_in_grass (:OLD.stud_ref_no,
                                             :NEW.start_date,
                                             :NEW.out_uk,
                                             :NEW.house_no_name,
                                             :NEW.addr_l1,
                                             :NEW.addr_l2,
                                             :NEW.addr_l3,
                                             :NEW.addr_l4,
                                             :NEW.post_code,
                                             :NEW.addr_easting,
                                             :NEW.addr_northing,
                                             :NEW.tele_no,
                                             :NEW.end_date,
                                             :NEW.mailsort
                                            );
   END IF;

--    dbms_output.put_line('*******TRIGGER2 HAS FIRED*******');

   /* Re-send student to the SLC */
   UPDATE stud_crse_year
      SET slc1_sent = 'N',
          slc2_sent = 'N'
    WHERE stud_crse_year_id =
             (SELECT MAX (stud_crse_year_id)
                FROM stud_crse_year
               WHERE stud_ref_no = :NEW.stud_ref_no
                 AND latest_crse_ind = 'Y'
                 AND first_slc1_sent_date IS NOT NULL);

   /* issue a new award letter */
   UPDATE stud_crse_year
      SET sal_sent = 'N',
          req_dup = 'Y'
    WHERE stud_crse_year_id =
             (SELECT MAX (stud_crse_year_id)
                FROM stud_crse_year
               WHERE stud_ref_no = :NEW.stud_ref_no
                 AND latest_crse_ind = 'Y'
                 AND sal_sent_date IS NOT NULL);

--   dbms_output.put_line('*******TRIGGER3 HAS FIRED*******');
   SELECT apply_to_ben_1, apply_to_ben_2
     INTO v_ben1, v_ben2
     FROM home_addr_change@web x
    WHERE stud_ref_no = :NEW.stud_ref_no
      AND TRUNC (change_date) = TRUNC (SYSDATE)
      AND change_date = (SELECT MAX (change_date)
                           FROM home_addr_change@web
                          WHERE stud_ref_no = :NEW.stud_ref_no);

   IF v_ben1 = 'Y'
   THEN
      UPDATE benefactor
         SET house_no_name = :NEW.house_no_name,
             addr_l1 = :NEW.addr_l1,
             addr_l2 = :NEW.addr_l2,
             addr_l3 = :NEW.addr_l3,
             addr_l4 = :NEW.addr_l4,
             post_code = :NEW.post_code,
             mailsort = :NEW.mailsort
       WHERE ben_id = (SELECT MAX (ben1_id)
                         FROM stud_session
                        WHERE stud_ref_no = :NEW.stud_ref_no);
   END IF;

   IF v_ben2 = 'Y'
   THEN
      UPDATE benefactor
         SET house_no_name = :NEW.house_no_name,
             addr_l1 = :NEW.addr_l1,
             addr_l2 = :NEW.addr_l2,
             addr_l3 = :NEW.addr_l3,
             addr_l4 = :NEW.addr_l4,
             post_code = :NEW.post_code,
             mailsort = :NEW.mailsort
       WHERE ben_id = (SELECT MAX (ben2_id)
                         FROM stud_session
                        WHERE stud_ref_no = :NEW.stud_ref_no);
   END IF;
--   dbms_output.put_line('*******TRIGGER4 HAS FIRED*******');
EXCEPTION
   WHEN OTHERS
   THEN
      v_ben1 := 'N';
      v_ben2 := 'N';
END sth_aiu;
/

show errors;

CREATE OR REPLACE TRIGGER SGAS.stt_aiu
   AFTER INSERT OR UPDATE OF location_ind,
                             residence_ind,
                             house_no_name,
                             addr_l1,
                             addr_l2,
                             addr_l3,
                             addr_l4,
                             post_code,
                             addr_easting,
                             addr_northing,
                             tele_no,
                             end_date,
                             mailsort
   ON SGAS.STUD_TERM_ADDR    FOR EACH ROW
DECLARE
   p_stud_ref_no     stud_term_addr.stud_ref_no%TYPE     := :OLD.stud_ref_no;
   p_start_date      stud_term_addr.start_date%TYPE      := SYSDATE;
   p_location_ind    stud_term_addr.location_ind%TYPE;
   p_residence_ind   stud_term_addr.residence_ind%TYPE;
   p_house_no_name   stud_term_addr.house_no_name%TYPE;
   p_addr_l1         stud_term_addr.addr_l1%TYPE;
   p_addr_l2         stud_term_addr.addr_l2%TYPE;
   p_addr_l3         stud_term_addr.addr_l3%TYPE;
   p_addr_l4         stud_term_addr.addr_l4%TYPE;
   p_post_code       stud_term_addr.post_code%TYPE;
   p_addr_easting    stud_term_addr.addr_easting%TYPE;
   p_addr_northing   stud_term_addr.addr_northing%TYPE;
   p_tele_no         stud_term_addr.tele_no%TYPE;
   p_end_date        stud_term_addr.end_date%TYPE        := NULL;
   p_mailsort        stud_term_addr.mailsort%TYPE;
   p_action          VARCHAR2 (1)                        := NULL;
   v_to_from_pfg     VARCHAR2 (1)                        := NULL;
   v_session_code    stud_crse_year.session_code%TYPE;
   v_batch_recalc    varchar2 (1)                        := 'N';
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_stud_ref_no := :OLD.stud_ref_no;
   END IF;

   IF p_action = 'I'
   THEN
      pk_steps_to_grass.update_stt_in_grass (:NEW.stud_ref_no,
                                             :NEW.start_date,
                                             :NEW.location_ind,
                                             :NEW.residence_ind,
                                             :NEW.house_no_name,
                                             :NEW.addr_l1,
                                             :NEW.addr_l2,
                                             :NEW.addr_l3,
                                             :NEW.addr_l4,
                                             :NEW.post_code,
                                             :NEW.addr_easting,
                                             :NEW.addr_northing,
                                             :NEW.tele_no,
                                             :NEW.end_date,
                                             :NEW.mailsort
                                            );
   ELSIF p_action = 'U'
   THEN
      pk_steps_to_grass.update_stt_in_grass (:OLD.stud_ref_no,
                                             :NEW.start_date,
                                             :NEW.location_ind,
                                             :NEW.residence_ind,
                                             :NEW.house_no_name,
                                             :NEW.addr_l1,
                                             :NEW.addr_l2,
                                             :NEW.addr_l3,
                                             :NEW.addr_l4,
                                             :NEW.post_code,
                                             :NEW.addr_easting,
                                             :NEW.addr_northing,
                                             :NEW.tele_no,
                                             :NEW.end_date,
                                             :NEW.mailsort
                                            );
   END IF;
   
   IF (NVL (:OLD.location_ind, ' ') <> NVL (:NEW.location_ind, ' '))
   THEN
      v_batch_recalc := 'Y';
   END IF;
   
   IF p_action = 'U' and v_batch_recalc = 'Y'
   THEN
      pk_steps_changes.ins_batch_recalc (p_stud_ref_no);
                     
   END IF;

   --  dbms_output.put_line('*******TRIGGER0 HAS FIRED*******');
    /* Get session_code for Awards_Recalc */
    /*This functionality is no longer required*/
   /*SELECT MAX (session_code)
     INTO v_session_code
     FROM stud_crse_year
    WHERE stud_crse_year_id =
             (SELECT MAX (stud_crse_year_id)
                FROM stud_crse_year
               WHERE stud_ref_no = :NEW.stud_ref_no
                 AND latest_crse_ind = 'Y'
                 AND first_slc1_sent_date IS NOT NULL);*/

   --   dbms_output.put_line('*******TRIGGER1 HAS FIRED*******');

   /*Check web change to see if move is from parents address*/
   SELECT to_from_parents_fg
     INTO v_to_from_pfg
     FROM term_addr_change@web x
    WHERE stud_ref_no = :NEW.stud_ref_no
      AND TRUNC (change_date) = TRUNC (SYSDATE)
      AND change_date = (SELECT MAX (change_date)
                           FROM term_addr_change@web
                          WHERE stud_ref_no = :NEW.stud_ref_no);

   --   dbms_output.put_line('*******TRIGGER2 HAS FIRED*******');
   IF v_to_from_pfg = 'Y'
   THEN
      --     dbms_output.put_line('*******TRIGGER3 HAS FIRED*******');
           /* Re-send student to the SLC */
      UPDATE stud_crse_year
         SET slc1_sent = 'N',
             slc2_sent = 'N'
       WHERE stud_crse_year_id =
                (SELECT MAX (stud_crse_year_id)
                   FROM stud_crse_year
                  WHERE stud_ref_no = :NEW.stud_ref_no
                    AND latest_crse_ind = 'Y'
                    AND first_slc1_sent_date IS NOT NULL);

      --          dbms_output.put_line('*******TRIGGER4 HAS FIRED*******');

      /*001 - Recalculate award */
      /* This functionality is no longer required 
      IF v_session_code <> 0
      THEN
         --     dbms_output.put_line('*******TRIGGER5 HAS FIRED*******');
         INSERT INTO awards_recalc
                     (awards_recalc_id, stud_ref_no,
                      session_code, processed_flag, created_date, user_id
                     )
              VALUES (awards_recalc_id_seq.NEXTVAL, :NEW.stud_ref_no,
                      v_session_code, 'N', SYSDATE, USER
                     );
      END IF;*/

      /* issue a new award letter */
      UPDATE stud_crse_year
         SET sal_sent = 'N',
             req_dup = 'Y'
       WHERE stud_crse_year_id =
                (SELECT MAX (stud_crse_year_id)
                   FROM stud_crse_year
                  WHERE stud_ref_no = :NEW.stud_ref_no
                    AND latest_crse_ind = 'Y'
                    AND sal_sent_date IS NOT NULL);
   --    dbms_output.put_line('*******TRIGGER6 HAS FIRED*******');
   ELSIF v_to_from_pfg = 'N'
   THEN
      /* Re-send student to the SLC */
      UPDATE stud_crse_year
         SET slc1_sent = 'N',
             slc2_sent = 'N'
       WHERE stud_crse_year_id =
                (SELECT MAX (stud_crse_year_id)
                   FROM stud_crse_year
                  WHERE stud_ref_no = :NEW.stud_ref_no
                    AND latest_crse_ind = 'Y'
                    AND first_slc1_sent_date IS NOT NULL);
   --    dbms_output.put_line('*******TRIGGER7 HAS FIRED*******');
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      v_to_from_pfg := 'N';
END stt_aiu;
/

show errors;