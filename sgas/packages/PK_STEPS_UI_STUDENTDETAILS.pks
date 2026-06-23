CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_studentdetails
AS
/******************************************************************************
   NAME:       pk_steps_ui_STUD_DETAILS
   PURPOSE:

   REVISIONS:
   Ver        Date          Author                 Description
   ---------  ----------    ---------------        ------------------------------------
   1.0        17/11/2008    PADDY GRACE            Created this package.
   1.1        12/05/2009    ABIRAMI CHIDAMBARAM    Code Population
   1.2        04/02/2013    PADDY GRACE            Update for COS2013
   1.3        01/05/2014    RANJ BENNING           Update for CR263 - added plus_one_used to getpersonaldetails, setpersonaldetails  
   1.4        05/12/2014    EWAN WATSON            Added dual_nationality COS 2015
   1.5        28/09/2020    MIKE TOLMIE            COS 2021 EU Brexit  
   1.6        26/01/2021    RANJ BENNING           COS 2021 EU Exceptions
******************************************************************************/
   TYPE homeaddr_cursor IS REF CURSOR;

   TYPE termaddr_cursor IS REF CURSOR;

   TYPE rescat_cursor IS REF CURSOR;

   PROCEDURE getpersonaldetails (
      stud_session_id_in      IN              VARCHAR2,
      session_code_out        OUT NOCOPY      VARCHAR2,
      stud_ref_no_out         OUT NOCOPY      VARCHAR2,
      nino_out                OUT NOCOPY      VARCHAR2,
      title_out               OUT NOCOPY      VARCHAR2,
      initial_out             OUT NOCOPY      VARCHAR2,
      forename_out            OUT NOCOPY      VARCHAR2,
      surname_out             OUT NOCOPY      VARCHAR2,
      birth_forename_out      OUT NOCOPY      VARCHAR2,
      birth_surname_out       OUT NOCOPY      VARCHAR2,
      date_of_birth_out       OUT NOCOPY      VARCHAR2,
      sex_out                 OUT NOCOPY      VARCHAR2,
      marital_status_out      OUT NOCOPY      VARCHAR2,
      marriage_date_out       OUT NOCOPY      VARCHAR2,
      birth_country_out       OUT NOCOPY      VARCHAR2,
      residence_country_out   OUT NOCOPY      VARCHAR2,
      nation_country_out      OUT NOCOPY      VARCHAR2,
      birth_district_out      OUT NOCOPY      VARCHAR2,
      res_status_out          OUT NOCOPY      VARCHAR2,
      eu_flag_out             OUT NOCOPY      VARCHAR2,
      nrs_cb_out              OUT NOCOPY      VARCHAR2,
      plus_one_used_out       OUT NOCOPY      VARCHAR2,
      care_exp_repeat_out     OUT NOCOPY      VARCHAR2,
      dual_nationality_out    OUT NOCOPY      VARCHAR2,
      complex_residency_out             OUT NOCOPY      VARCHAR2,
      eu_settled_status_out             OUT NOCOPY      VARCHAR2,
      eu_settled_status_confirmed_out   OUT NOCOPY      VARCHAR2,
      ga_student_out                    OUT NOCOPY      VARCHAR2,
      eu_residence_type_out               OUT NOCOPY      VARCHAR2,      
      error_boolean                     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getcontactdetails (
      stud_ref_no_in      IN              NUMBER,
      mobile_tel_no_out   OUT NOCOPY      VARCHAR2,
      email_addr          OUT NOCOPY      VARCHAR2,
      addr_corr_flag      OUT NOCOPY      VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   );

    PROCEDURE getOnlineAccount (
      stud_ref_no_in        IN              VARCHAR2,
      online_account       OUT             VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getaddresses (
      stud_ref_no_in   IN       NUMBER,
      h_cursor         IN OUT   homeaddr_cursor,
      t_cursor         IN OUT   termaddr_cursor,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   );

   PROCEDURE getbankdetails (
      stud_ref_no_in    IN       NUMBER,
      sort_code         OUT      VARCHAR2,
      account_num       OUT      VARCHAR2,
      valid_dup_acc     OUT      VARCHAR2,
      dup_bank_reason   OUT      VARCHAR2,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   );

   PROCEDURE setpersonaldetails (
      stud_session_id_in     IN       VARCHAR2,
      nino_in                IN       VARCHAR2,
      title_in               IN       VARCHAR2,
      initial_in             IN       VARCHAR2,
      forename_in            IN       VARCHAR2,
      surname_in             IN       VARCHAR2,
      birth_forename_in      IN       VARCHAR2,
      birth_surname_in       IN       VARCHAR2,
      date_of_birth_in       IN       VARCHAR2,
      sex_in                 IN       VARCHAR2,
      marital_status_in      IN       VARCHAR2,
      marriage_date_in       IN       VARCHAR2,
      birth_country_in       IN       VARCHAR2,
      residence_country_in   IN       VARCHAR2,
      nation_country_in      IN       VARCHAR2,
      birth_district_in      IN       VARCHAR2,
      res_status_in          IN       VARCHAR2,
      eu_flag_in             IN       VARCHAR2,
      nrs_cb_in              IN       VARCHAR2,
      plus_one_used_in       IN       VARCHAR2,
      care_exp_repeat_in     IN       VARCHAR2,
      employee               IN       VARCHAR2,
      dual_nationality_in    IN       VARCHAR2,
      complex_residency_in              IN       VARCHAR2,
      eu_settled_status_in              IN       VARCHAR2,
      eu_settled_status_confirmed_in    IN       VARCHAR2,
      ga_student_in                     IN       VARCHAR2,
      eu_residence_type_in               IN       VARCHAR2,           
      error_boolean                     OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   PROCEDURE setcontactdetails (
      stud_ref_no_in        IN       NUMBER,
      email_addr_in         IN       VARCHAR2,
      mobile_tel_no_in      IN       VARCHAR2,
      addr_corres_flag_in   IN       VARCHAR2,
      employee              IN       VARCHAR2,
      error_boolean         OUT      VARCHAR2,
      ERROR_TEXT            OUT      VARCHAR2
   );

   PROCEDURE setbankdetails (
      stud_ref_no_in       IN       NUMBER,
      sort_code_in         IN       VARCHAR2,
      account_num_in       IN       VARCHAR2,
      valid_dup_acc_in     IN       VARCHAR2,
      dup_bank_reason_in   IN       VARCHAR2,
      employee             IN       VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   );

   PROCEDURE clearbankdetails (
      stud_ref_no_in   IN       NUMBER,
      user_in          IN       VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   );

   PROCEDURE notifybankdetschange (
      stud_ref_no_in   IN       VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   );

   PROCEDURE updatehomeaddr (
      stud_ref_no_in        IN       VARCHAR2,
      original_start_date   IN       VARCHAR2,
      out_uk_in             IN       VARCHAR2,
      start_date_in         IN       VARCHAR2,
      house_num_in          IN       VARCHAR2,
      addr_l1_in            IN       VARCHAR2,
      addr_l2_in            IN       VARCHAR2,
      addr_l3_in            IN       VARCHAR2,
      addr_l4_in            IN       VARCHAR2,
      post_code_in          IN       VARCHAR2,
      tele_no_in            IN       VARCHAR2,
      user_in               IN       VARCHAR2,
      error_boolean         OUT      VARCHAR2,
      ERROR_TEXT            OUT      VARCHAR2
   );

   PROCEDURE updatetermaddr (
      stud_ref_no_in        IN       VARCHAR2,
      original_start_date   IN       VARCHAR2,
      location_in           IN       VARCHAR2,
      start_date_in         IN       VARCHAR2,
      house_num_in          IN       VARCHAR2,
      addr_l1_in            IN       VARCHAR2,
      addr_l2_in            IN       VARCHAR2,
      addr_l3_in            IN       VARCHAR2,
      addr_l4_in            IN       VARCHAR2,
      post_code_in          IN       VARCHAR2,
      tele_no_in            IN       VARCHAR2,
      user_in               IN       VARCHAR2,
      error_boolean         OUT      VARCHAR2,
      ERROR_TEXT            OUT      VARCHAR2
   );

   PROCEDURE addhomeaddr (
      stud_ref_no_in   IN       VARCHAR2,
      out_uk_in        IN       VARCHAR2,
      start_date_in    IN       VARCHAR2,
      house_num_in     IN       VARCHAR2,
      addr_l1_in       IN       VARCHAR2,
      addr_l2_in       IN       VARCHAR2,
      addr_l3_in       IN       VARCHAR2,
      addr_l4_in       IN       VARCHAR2,
      post_code_in     IN       VARCHAR2,
      tele_no_in       IN       VARCHAR2,
      user_in          IN       VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   );

   PROCEDURE addtermaddr (
      stud_ref_no_in    IN       VARCHAR2,
      location_ind_in   IN       VARCHAR2,
      start_date_in     IN       VARCHAR2,
      house_num_in      IN       VARCHAR2,
      addr_l1_in        IN       VARCHAR2,
      addr_l2_in        IN       VARCHAR2,
      addr_l3_in        IN       VARCHAR2,
      addr_l4_in        IN       VARCHAR2,
      post_code_in      IN       VARCHAR2,
      tele_no_in        IN       VARCHAR2,
      user_in           IN       VARCHAR2,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   );

   PROCEDURE checktermaddrexists (
      stud_ref_no_in     IN       VARCHAR2,
      start_date_in      IN       DATE,
      term_addr_exists   OUT      VARCHAR2,
      error_boolean      OUT      VARCHAR2,
      ERROR_TEXT         OUT      VARCHAR2
   );

   PROCEDURE checkhomeaddrexists (
      stud_ref_no_in     IN       VARCHAR2,
      start_date_in      IN       DATE,
      home_addr_exists   OUT      VARCHAR2,
      error_boolean      OUT      VARCHAR2,
      ERROR_TEXT         OUT      VARCHAR2
   );
END pk_steps_ui_studentdetails;
/