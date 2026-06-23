CREATE OR REPLACE TRIGGER SGAS.sth_aiu
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
                             mailsort
   ON SGAS.STUD_HOME_ADDR    FOR EACH ROW
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
SHOW ERRORS;

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
SHOW ERRORS;