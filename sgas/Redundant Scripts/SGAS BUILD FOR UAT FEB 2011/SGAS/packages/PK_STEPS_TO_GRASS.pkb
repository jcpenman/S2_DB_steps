CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_to_grass
IS
--
-- DESCRIPTION
-- ===========
--
-- Package that holds the code to synch changes made in StEPS to GRASS
--
-- Modification History
-- Date       Author      Ref    Desc
-- 24/03/2010 A Bowman    001    Initial Creation
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision:  $
--
   PROCEDURE update_ben_in_grass (
      p_ben_id          VARCHAR2,
      p_title           VARCHAR2,
      p_initials        VARCHAR2,
      p_forenames       VARCHAR2,
      p_surname         VARCHAR2,
      p_house_no_name   VARCHAR2,
      p_addr_l1         VARCHAR2,
      p_addr_l2         VARCHAR2,
      p_addr_l3         VARCHAR2,
      p_addr_l4         VARCHAR2,
      p_post_code       VARCHAR2,
      p_tele_no         VARCHAR2
   )
   AS
   BEGIN
      UPDATE benefactor@grass bg
         SET bg.title = p_title,
             bg.initials = p_initials,
             bg.forenames = p_forenames,
             bg.surname = p_surname,
             bg.house_no_name = p_house_no_name,
             bg.addr_l1 = p_addr_l1,
             bg.addr_l2 = p_addr_l2,
             bg.addr_l3 = p_addr_l3,
             bg.addr_l4 = p_addr_l4,
             bg.post_code = p_post_code,
             bg.tele_no = p_tele_no
       WHERE bg.ben_id = p_ben_id;
   END update_ben_in_grass;

   PROCEDURE update_stud_in_grass (
      p_stud_ref_no                  NUMBER,
      p_abroad                       VARCHAR2,
      p_dob                          DATE,
      p_title                        VARCHAR2,
      p_initials                     VARCHAR2,
      p_forenames                    VARCHAR2,
      p_surname                      VARCHAR2,
      p_sex                          VARCHAR2,
      p_birth_country_code           NUMBER,
      p_residence_country_code       NUMBER,
      p_nation_country_code          NUMBER,
      p_ucas_no                      VARCHAR2,
      p_suspend_payment              VARCHAR2,
      p_birth_forenames              VARCHAR2,
      p_birth_surname                VARCHAR2,
      p_district_birth_cert_issued   VARCHAR2,
      p_addr_corr_flag               VARCHAR2,
      p_bankrupt_flag                VARCHAR2,
      p_travel_method                VARCHAR2,
      p_bank_validate                VARCHAR2,
      p_mobile_tel_no                VARCHAR2,
      p_email_addr                   VARCHAR2,
      p_payment_method               VARCHAR2,
      p_ni_no                        VARCHAR2,
      p_account_no                   VARCHAR2,
      p_sort_code                    VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud@grass sg
         SET sg.abroad = p_abroad,
             sg.dob = p_dob,
             sg.title = p_title,
             sg.initials = p_initials,
             sg.forenames = p_forenames,
             sg.surname = p_surname,
             sg.sex = p_sex,
             sg.birth_country_code = p_birth_country_code,
             sg.residence_country_code = p_residence_country_code,
             sg.nation_country_code = p_nation_country_code,
             sg.ucas_no = p_ucas_no,
             sg.suspend_payment = p_suspend_payment,
             sg.birth_forenames = p_birth_forenames,
             sg.birth_surname = p_birth_surname,
             sg.district_birth_cert_issued = p_district_birth_cert_issued,
             sg.addr_corr_flag = p_addr_corr_flag,
             sg.bankrupt_flag = p_bankrupt_flag,
             sg.travel_method = p_travel_method,
             sg.bank_validate = p_bank_validate,
             sg.mobile_tel_no = p_mobile_tel_no,
             sg.email_addr = p_email_addr,
             sg.payment_method = p_payment_method,
             sg.ni_no = p_ni_no,
             sg.account_no = p_account_no,
             sg.sort_code = p_sort_code
       WHERE sg.stud_ref_no = p_stud_ref_no;
   END update_stud_in_grass;

   PROCEDURE update_scd_in_grass (
      p_stud_ref_no     NUMBER,
      p_contact_ind     NUMBER,
      p_cont_name       VARCHAR2,
      p_cont_postcode   VARCHAR2,
      p_cont_addr1      VARCHAR2,
      p_cont_addr2      VARCHAR2,
      p_cont_addr3      VARCHAR2,
      p_cont_tel_no     VARCHAR2,
      p_cont_rel_code   VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_cont_details@grass scdg
         SET scdg.cont_name = p_cont_name,
             scdg.cont_postcode = p_cont_postcode,
             scdg.cont_addr1 = p_cont_addr1,
             scdg.cont_addr2 = p_cont_addr2,
             scdg.cont_addr3 = p_cont_addr3,
             scdg.cont_tel_no = p_cont_tel_no,
             scdg.cont_rel_code = p_cont_rel_code
       WHERE scdg.stud_ref_no = p_stud_ref_no
         AND scdg.contact_ind = p_contact_ind;
   END update_scd_in_grass;

   PROCEDURE update_sha_in_grass (
      p_stud_ref_no     NUMBER,
      p_start_date      DATE,
      p_out_uk          VARCHAR2,
      p_house_no_name   VARCHAR2,
      p_addr_l1         VARCHAR2,
      p_addr_l2         VARCHAR2,
      p_addr_l3         VARCHAR2,
      p_addr_l4         VARCHAR2,
      p_post_code       VARCHAR2,
      p_addr_easting    VARCHAR2,
      p_addr_northing   VARCHAR2,
      p_tele_no         VARCHAR2,
      p_end_date        DATE,
      p_mailsort        NUMBER
   )
   AS
   BEGIN
        
        --dbms_output.put_line('Stud_ref_no='||p_stud_ref_no); 
         UPDATE stud_home_addr@grass
            SET end_date = SYSDATE - 1
          WHERE stud_ref_no = p_stud_ref_no AND end_date IS NULL;

          INSERT INTO stud_home_addr@grass
                     (stud_ref_no, start_date, out_uk, house_no_name,
                      addr_l1, addr_l2, addr_l3, addr_l4,
                      post_code, addr_easting, addr_northing,
                      tele_no, end_date, mailsort
                     )
              VALUES (p_stud_ref_no, sysdate, p_out_uk, p_house_no_name,
                      p_addr_l1, p_addr_l2, p_addr_l3, p_addr_l4,
                      p_post_code, p_addr_easting, p_addr_northing,
                      p_tele_no, p_end_date, p_mailsort
                     );
         --dbms_output.put_line('*******pckg HAS FIRED*******');
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
   END update_sha_in_grass;

   PROCEDURE update_aw_inst (p_stud_ref_no NUMBER)
   AS
   BEGIN
      UPDATE award_instalment@grass aig
         SET aig.method = 'B',             --- cant change from BACS to Cheque
             aig.payee = 'S',
             aig.payment_addr = 'B'
       WHERE aig.method = 'C'
         AND aig.payee = 'S'
         AND aig.payment_status IN ('U', 'A')
         AND award_id IN (
                SELECT award_id ag
                  FROM award@grass ag
                 WHERE ag.stud_ref_no = p_stud_ref_no
                   AND ag.award_src = 'A'
                   AND ag.stud_award_type NOT LIKE ('U%L'));

      UPDATE award_instalment
         SET method = 'B',                 --- cant change from BACS to Cheque
             payee = 'S',
             payment_addr = 'B'
       WHERE method = 'C'
         AND payee = 'S'
         AND payment_status IN ('U', 'A')
         AND award_id IN (
                SELECT award_id
                  FROM award
                 WHERE stud_ref_no = p_stud_ref_no
                   AND award_src = 'A'
                   AND stud_award_type NOT LIKE ('U%L'));
   END update_aw_inst;

   PROCEDURE update_stt_in_grass (
      p_stud_ref_no     NUMBER,
      p_start_date      DATE,
      p_location_ind    VARCHAR2,
      p_residence_ind   VARCHAR2,
      p_house_no_name   VARCHAR2,
      p_addr_l1         VARCHAR2,
      p_addr_l2         VARCHAR2,
      p_addr_l3         VARCHAR2,
      p_addr_l4         VARCHAR2,
      p_post_code       VARCHAR2,
      p_addr_easting    VARCHAR2,
      p_addr_northing   VARCHAR2,
      p_tele_no         VARCHAR2,
      p_end_date        DATE,
      p_mailsort        NUMBER
   )
   AS
   BEGIN
      
      -- dbms_output.put_line('Stud_ref_no='||p_stud_ref_no);
         UPDATE stud_term_addr@grass
            SET end_date = SYSDATE - 1
          WHERE stud_ref_no = p_stud_ref_no AND end_date IS NULL;

         --  dbms_output.put_line('Doing insert');
         INSERT INTO stud_term_addr@grass
                     (stud_ref_no, start_date, location_ind,
                      residence_ind, house_no_name, addr_l1, addr_l2,
                      addr_l3, addr_l4, post_code, addr_easting,
                      addr_northing, tele_no, end_date, mailsort
                     )
              VALUES (p_stud_ref_no, sysdate, p_location_ind,
                      p_residence_ind, p_house_no_name, p_addr_l1, p_addr_l2,
                      p_addr_l3, p_addr_l4, p_post_code, p_addr_easting,
                      p_addr_northing, p_tele_no, p_end_date, p_mailsort
                     );
     
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLCODE || SQLERRM);
   END update_stt_in_grass;

   PROCEDURE update_batch_recalc (p_stud_ref_no NUMBER)
   AS
      v_current_session   config_data.cval%TYPE;
   BEGIN
      SELECT cval
        INTO v_current_session
        FROM config_data
       WHERE item_name = 'CURRENT_SESSION';

      UPDATE stud_crse_year@grass gscy
         SET gscy.batch_recalc = 'Y'
       WHERE gscy.stud_ref_no = p_stud_ref_no
         AND gscy.latest_crse_ind = 'Y'
         AND gscy.session_code = v_current_session - 1;
   END update_batch_recalc;
END pk_steps_to_grass;
/