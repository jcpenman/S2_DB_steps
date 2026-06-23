CREATE OR REPLACE PACKAGE SGAS.pk_steps_to_grass
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
-- 02/09/2010 A Bowman    002    Added additional code to cover data STEPS to GRASS data synch
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
   );

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
   );

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
   );

   PROCEDURE update_aw_inst (p_stud_ref_no NUMBER);

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
   );

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
   );

   PROCEDURE update_batch_recalc (p_stud_ref_no NUMBER);
END pk_steps_to_grass;
/