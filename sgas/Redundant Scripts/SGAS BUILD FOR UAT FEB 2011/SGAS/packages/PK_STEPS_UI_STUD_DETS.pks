/* Formatted on 2010/11/03 16:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_ui_stud_dets
AS
/******************************************************************************
   NAME:       pk_steps_ui_STUD_DETS
   PURPOSE:

   REVISIONS:
   Ver        Date          Author                 Description
   ---------  ----------    ---------------        ------------------------------------
   1.0        17/11/2008    PADDY GRACE            Created this package.
   1.1        12/05/2009    ABIRAMI CHIDAMBARAM    Code Population
******************************************************************************/
   TYPE prevhomeaddr_cursor IS REF CURSOR;

   TYPE prevtermaddr_cursor IS REF CURSOR;

   PROCEDURE getstuddetails (
      stud_ref_no_in          IN              NUMBER,
      nino_out                OUT NOCOPY      VARCHAR2,
      title_out               OUT NOCOPY      VARCHAR2,
      initial_out             OUT NOCOPY      VARCHAR2,
      forename_out            OUT NOCOPY      VARCHAR2,
      surname_out             OUT NOCOPY      VARCHAR2,
      birth_forename_out      OUT NOCOPY      VARCHAR2,
      birth_surname_out       OUT NOCOPY      VARCHAR2,
      date_of_birth_out       OUT NOCOPY      DATE,
      sex_out                 OUT NOCOPY      VARCHAR2,
      marital_status_out      OUT NOCOPY      VARCHAR2,
      marriage_date_out       OUT NOCOPY      DATE,
      birth_country_out       OUT NOCOPY      VARCHAR2,
      residence_country_out   OUT NOCOPY      VARCHAR2,
      nation_country_out      OUT NOCOPY      VARCHAR2,
      birth_district_out      OUT NOCOPY      VARCHAR2,
      addr_corres_flag_out    OUT NOCOPY      VARCHAR2,
      email_addr_out          OUT NOCOPY      VARCHAR2,
      tel_no_out              OUT NOCOPY      VARCHAR2,
      mobile_tel_no_out       OUT NOCOPY      VARCHAR2,
      abroad_out              OUT NOCOPY      VARCHAR2,
      sort_code_out           OUT NOCOPY      VARCHAR2,
      account_num_out         OUT NOCOPY      VARCHAR2,
      valid_dup_acc_out       OUT NOCOPY      VARCHAR2,
      dup_bank_reason_out     OUT NOCOPY      VARCHAR2,
      stud_suspend_out        OUT NOCOPY      VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   );

   PROCEDURE updatestuddetails (
      stud_ref_no_in         IN       NUMBER,
      nino_in                IN       VARCHAR2,
      title_in               IN       VARCHAR2,
      initial_in             IN       VARCHAR2,
      forename_in            IN       VARCHAR2,
      surname_in             IN       VARCHAR2,
      birth_forename_in      IN       VARCHAR2,
      birth_surname_in       IN       VARCHAR2,
      date_of_birth_in       IN       DATE,
      sex_in                 IN       VARCHAR2,
      marital_status_in      IN       VARCHAR2,
      marriage_date_in       IN       DATE,
      birth_country_in       IN       VARCHAR2,
      residence_country_in   IN       VARCHAR2,
      nation_country_in      IN       VARCHAR2,
      birth_district_in      IN       VARCHAR2,
      stud_suspend_in        IN       VARCHAR2,
      user_in                IN       VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2,
      row_count_s            OUT      VARCHAR2
   );

   PROCEDURE updatecontactdetails (
      stud_ref_no_in        IN       NUMBER,
      email_addr_in         IN       VARCHAR2,
      mobile_tel_no_in      IN       VARCHAR2,
      addr_corres_flag_in   IN       VARCHAR2,
      user_in               IN       VARCHAR2,
      error_boolean         OUT      VARCHAR2,
      ERROR_TEXT            OUT      VARCHAR2,
      row_count_s           OUT      VARCHAR2,
      row_count_sha         OUT      VARCHAR2
   );

   PROCEDURE updatebankdetails (
      stud_ref_no_in       IN       NUMBER,
      sort_code_in         IN       VARCHAR2,
      account_num_in       IN       VARCHAR2,
      valid_dup_acc_in     IN       VARCHAR2,
      dup_bank_reason_in   IN       VARCHAR2,
      user_in              IN       VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2,
      row_count_s          OUT      VARCHAR2
   );

   PROCEDURE clearbankdetails (
      stud_ref_no_in   IN       NUMBER,
      user_in          IN       VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   );

   PROCEDURE getprevhomeaddr (
      stud_ref_no_in   IN              NUMBER,
      io_cursor        IN OUT          prevhomeaddr_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getprevtermaddr (
      stud_ref_no_in   IN              NUMBER,
      io_cursor        IN OUT          prevtermaddr_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE updatehomeaddr (
      stud_ref_no_in   IN       NUMBER,
      out_uk_in        IN       VARCHAR2,
      start_date_in    IN       VARCHAR2,
      house_num_in     IN       VARCHAR2,
      addr_l1_in       IN       VARCHAR2,
      addr_l2_in       IN       VARCHAR2,
      addr_l3_in       IN       VARCHAR2,
      addr_l4_in       IN       VARCHAR2,
      post_code_in     IN       VARCHAR2,
      user_in          IN       VARCHAR2,
      tele_no_in       IN       VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2,
      row_count_h      OUT      VARCHAR2
   );

   PROCEDURE updatetermaddr (
      stud_ref_no_in   IN       NUMBER,
      location_in      IN       VARCHAR2,
      start_date_in    IN       VARCHAR2,
      house_num_in     IN       VARCHAR2,
      addr_l1_in       IN       VARCHAR2,
      addr_l2_in       IN       VARCHAR2,
      addr_l3_in       IN       VARCHAR2,
      addr_l4_in       IN       VARCHAR2,
      post_code_in     IN       VARCHAR2,
      user_in          IN       VARCHAR2,
      tele_no_in       IN       VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2,
      row_count_t      OUT      VARCHAR2
   );

   PROCEDURE addhomeaddr (
      stud_ref_no_in     IN       NUMBER,
      out_uk_in          IN       VARCHAR2,
      start_date_in      IN       DATE,
      house_num_in       IN       VARCHAR2,
      addr_l1_in         IN       VARCHAR2,
      addr_l2_in         IN       VARCHAR2,
      addr_l3_in         IN       VARCHAR2,
      addr_l4_in         IN       VARCHAR2,
      post_code_in       IN       VARCHAR2,
      addr_easting_in    IN       VARCHAR2,
      addr_northing_in   IN       VARCHAR2,
      tele_no_in         IN       VARCHAR2,
      mail_sort_in       IN       NUMBER,
      user_in            IN       VARCHAR2,
      error_boolean      OUT      VARCHAR2,
      ERROR_TEXT         OUT      VARCHAR2,
      row_count_h        OUT      VARCHAR2
   );

   PROCEDURE addtermaddr (
      stud_ref_no_in     IN       NUMBER,
      location_ind_in    IN       VARCHAR2,
      start_date_in      IN       DATE,
      house_num_in       IN       VARCHAR2,
      addr_l1_in         IN       VARCHAR2,
      addr_l2_in         IN       VARCHAR2,
      addr_l3_in         IN       VARCHAR2,
      addr_l4_in         IN       VARCHAR2,
      post_code_in       IN       VARCHAR2,
      addr_easting_in    IN       VARCHAR2,
      addr_northing_in   IN       VARCHAR2,
      tele_no_in         IN       VARCHAR2,
      mail_sort_in       IN       NUMBER,
      user_in            IN       VARCHAR2,
      error_boolean      OUT      VARCHAR2,
      ERROR_TEXT         OUT      VARCHAR2,
      row_count_t        OUT      VARCHAR2
   );

   PROCEDURE notifybankdetschange (
      stud_ref_no_in   IN       VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   );
END pk_steps_ui_stud_dets;
/