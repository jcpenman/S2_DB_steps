CREATE OR REPLACE PACKAGE SGAS.shortened_application_web
IS
   TYPE stud_declaration_rec_type IS RECORD (
      type_of_support_ind            VARCHAR2 (1),
      stud_ref_no                    stud.stud_ref_no%TYPE,
      stud_slc_ref_no                stud.scottish_cand%TYPE,
      stud_title                     stud.title%TYPE,
      stud_forenames                 stud.forenames%TYPE,
      stud_surname                   stud.surname%TYPE,
--    stud_bankrupt_flag  stud.bankrupt_flag%TYPE,
      stud_house_no_name             stud_home_addr.house_no_name%TYPE,
      stud_addr_l1                   stud_home_addr.addr_l1%TYPE,
      stud_addr_l2                   stud_home_addr.addr_l2%TYPE,
      stud_addr_l3                   stud_home_addr.addr_l3%TYPE,
      stud_addr_l4                   stud_home_addr.addr_l4%TYPE,
      stud_post_code                 stud_home_addr.post_code%TYPE,
      stud_tel_no                    stud_home_addr.tele_no%TYPE,
      stud_addr_corr_flag            stud.addr_corr_flag%TYPE,
      stud_nino                      stud.ni_no%TYPE,
      stud_inst_name                 stud_crse_year.inst_name%TYPE,
      stud_crse_name                 stud_crse_year.crse_name%TYPE,
      stud_crse_year_no              stud_crse_year.crse_year_no%TYPE,
      stud_account_no                stud.build_soc_no%TYPE,
      stud_sort_code                 stud.sort_code%TYPE,
      stud_crse_year_id              stud_crse_year.stud_crse_year_id%TYPE,
      stud_location_indicator        stud_term_addr.location_ind%TYPE,
      stud_cont1_relation            stud_cont_details.cont_rel_code%TYPE,
      stud_cont1_ind                 stud_cont_details.contact_ind%TYPE,
      stud_cont1_name                stud_cont_details.cont_name%TYPE,
      stud_cont1_addr_l1             stud_cont_details.cont_addr1%TYPE,
      stud_cont1_addr_l2             stud_cont_details.cont_addr2%TYPE,
      stud_cont1_addr_l3             stud_cont_details.cont_addr3%TYPE,
      stud_cont1_postcode            stud_cont_details.cont_postcode%TYPE,
      stud_cont1_tel_no              stud_cont_details.cont_tel_no%TYPE,
      stud_cont2_ind                 stud_cont_details.contact_ind%TYPE,
      stud_cont2_name                stud_cont_details.cont_name%TYPE,
      stud_cont2_addr_l1             stud_cont_details.cont_addr1%TYPE,
      stud_cont2_addr_l2             stud_cont_details.cont_addr2%TYPE,
      stud_cont2_addr_l3             stud_cont_details.cont_addr3%TYPE,
      stud_cont2_postcode            stud_cont_details.cont_postcode%TYPE,
      stud_cont2_tel_no              stud_cont_details.cont_tel_no%TYPE,
      award                          stud_crse_year.award%TYPE,
      loan_given                     stud_crse_year.loan_given%TYPE,
      dearing                        stud_crse_year.dearing%TYPE,
      crse_year_no                   stud_crse_year.crse_year_no%TYPE,
      loan_eligibility_only          stud_crse_year.loan_eligibility_only%TYPE,
      loan_request                   stud_session.loan_request%TYPE,
      max_loan_requested             stud_session.max_loan_requested%TYPE,
      fees_calculated                short_app_stud_info.fees_calculated%TYPE,
      inst_code                      stud_crse_year.inst_code%TYPE,
      crse_code                      stud_crse_year.crse_code%TYPE,
      stud_cont1_relation_descript   VALIDATION.descript%TYPE,
      stud_web_user_id               stud.web_user_id%TYPE,
      stud_email_addr                stud.email_addr%TYPE,
      stud_session_id                stud_session.stud_session_id%TYPE
   );

   TYPE stud_output_rec_type IS RECORD (
      type_of_support_ind            VARCHAR2 (1),
      stud_ref_no                    VARCHAR2 (10),
      stud_slc_ref_no                VARCHAR2 (10),
      stud_title                     VARCHAR2 (8),
      stud_forenames                 VARCHAR2 (25),
      stud_surname                   VARCHAR2 (25),
      stud_house_no_name             VARCHAR2 (32),
      stud_addr_l1                   VARCHAR2 (65),
      stud_addr_l2                   VARCHAR2 (65),
      stud_addr_l3                   VARCHAR2 (32),
      stud_addr_l4                   VARCHAR2 (32),
      stud_post_code                 VARCHAR2 (8),
      stud_tel_no                    VARCHAR2 (15),
      stud_addr_corr_flag            VARCHAR2 (1),
      stud_nino                      VARCHAR2 (10),
      stud_inst_name                 VARCHAR2 (50),
      stud_crse_name                 VARCHAR2 (50),
      stud_crse_year_no              VARCHAR2 (2),
      stud_sort_code                 VARCHAR2 (6),
      stud_account_no                VARCHAR2 (18),
      stud_location_indicator        VARCHAR2 (20),
      stud_cont1_relation            VARCHAR2 (15),
      stud_cont1_name                VARCHAR2 (60),
      stud_cont1_addr_l1             VARCHAR2 (60),
      stud_cont1_addr_l2             VARCHAR2 (60),
      stud_cont1_addr_l3             VARCHAR2 (60),
      stud_cont1_postcode            VARCHAR2 (8),
      stud_cont1_tel_no              VARCHAR2 (14),
      stud_cont2_name                VARCHAR2 (60),
      stud_cont2_addr_l1             VARCHAR2 (60),
      stud_cont2_addr_l2             VARCHAR2 (60),
      stud_cont2_addr_l3             VARCHAR2 (60),
      stud_cont2_postcode            VARCHAR2 (8),
      stud_cont2_tel_no              VARCHAR2 (14),
      stud_cont1_relation_descript   VARCHAR2 (51),
      stud_web_user_id               VARCHAR2 (25),
      stud_email_addr                VARCHAR (80)
   );

   g_pad_char         CONSTANT VARCHAR2 (1) := NULL;
   g_first_contact    CONSTANT NUMBER (1)   := 1;
   g_second_contact   CONSTANT NUMBER (1)   := 2;
   g_error                     BOOLEAN;

   FUNCTION pop_shortened_application (
      p_session_code   IN   stud_session.session_code%TYPE
      --p_logdir         IN   VARCHAR2,
      --p_filename_1     IN   VARCHAR2,
      --p_sid            IN   VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION get_stud_address (
      p_stud_declaration_rec   IN OUT   stud_declaration_rec_type,
      p_session_code           IN       NUMBER
   )
      RETURN BOOLEAN;

   FUNCTION get_term_location_ind (
      p_stud_declaration_rec          IN OUT   stud_declaration_rec_type,
      p_stud_declaration_output_rec   IN OUT   stud_output_rec_type,
      p_session_code                  IN       NUMBER
   )
      RETURN BOOLEAN;

   FUNCTION get_cont_address (
      p_cont_ind               IN       stud_cont_details.contact_ind%TYPE,
      p_stud_declaration_rec   IN OUT   stud_declaration_rec_type,
      p_session_code           IN       NUMBER
   )
      RETURN BOOLEAN;

   FUNCTION set_support_indicator_nmt (
      p_stud_declaration_rec   IN OUT   stud_declaration_rec_type,
      p_indicator_populated    IN OUT   BOOLEAN,
      p_session_code           IN       NUMBER
   )
      RETURN BOOLEAN;

   FUNCTION format_output_record (
      p_stud_declaration_rec          IN OUT   stud_declaration_rec_type,
      p_stud_declaration_output_rec   IN OUT   stud_output_rec_type,
      p_session_code                  IN       NUMBER
   )
      RETURN BOOLEAN;

   FUNCTION get_rel_code (
      p_stud_declaration_rec   IN OUT   stud_declaration_rec_type,
      p_session_code           IN       NUMBER
   )
      RETURN BOOLEAN;

   PROCEDURE initialise_records (
      p_stud_declaration_rec          IN OUT   stud_declaration_rec_type,
      p_stud_declaration_output_rec   IN OUT   stud_output_rec_type
   );

   FUNCTION write_short_app_stud_info (
      p_stud_declaration_rec   IN OUT   stud_declaration_rec_type,
      p_session_code           IN       stud_session.session_code%TYPE
   )
      RETURN BOOLEAN;

   FUNCTION update_stud_session (
      p_stud_declaration_rec   IN OUT   stud_declaration_rec_type,
      p_session_code           IN       stud_session.session_code%TYPE
   )
      RETURN BOOLEAN;

   FUNCTION shwap_table_insert (
      p_stud_declaration_rec          IN   stud_declaration_rec_type,
      p_stud_declaration_output_rec   IN   stud_output_rec_type
   )
      RETURN BOOLEAN;

   PROCEDURE clean_loop;

   FUNCTION check_inst_crse (
      p_crse_year_no        NUMBER,
      p_inst_code      IN   VARCHAR2,
      p_crse_code      IN   VARCHAR2,
      p_session_code   IN   NUMBER
   )
      RETURN VARCHAR2;
      
   PROCEDURE insert_to_web;
   
END shortened_application_web;    -- SHORTENED_APPLICATION_WEB Package spec
/