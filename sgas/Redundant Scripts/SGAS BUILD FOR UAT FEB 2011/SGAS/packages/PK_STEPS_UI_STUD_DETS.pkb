/* Formatted on 2010/11/03 16:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY sgas.pk_steps_ui_stud_dets
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
   )
   IS
   BEGIN
      SELECT s.ni_no, s.title, s.initials, s.forenames, s.surname,
             s.birth_forenames, s.birth_surname, s.dob,
             s.sex, s.marital_status, s.marriage_date,
             s.birth_country_code, s.residence_country_code,
             s.nation_country_code, s.district_birth_cert_issued,
             s.addr_corr_flag, s.email_addr, sha.tele_no,
             s.mobile_tel_no, sha.out_uk, s.sort_code, s.account_no,
             s.valid_duplicate_acc, s.dup_bank_reason, s.stud_suspend
        INTO nino_out, title_out, initial_out, forename_out, surname_out,
             birth_forename_out, birth_surname_out, date_of_birth_out,
             sex_out, marital_status_out, marriage_date_out,
             birth_country_out, residence_country_out,
             nation_country_out, birth_district_out,
             addr_corres_flag_out, email_addr_out, tel_no_out,
             mobile_tel_no_out, abroad_out, sort_code_out, account_num_out,
             valid_dup_acc_out, dup_bank_reason_out, stud_suspend_out
        FROM stud s, stud_home_addr sha
       WHERE s.stud_ref_no = stud_ref_no_in
         AND s.stud_ref_no = sha.stud_ref_no
         AND sha.end_date IS NULL;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstuddetails;

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
   )
   IS
   BEGIN
      UPDATE stud s
         SET s.ni_no = UPPER (nino_in),
             s.title = UPPER (title_in),
             s.initials = UPPER (initial_in),
             s.forenames = UPPER (forename_in),
             s.surname = UPPER (surname_in),
             s.birth_forenames = UPPER (birth_forename_in),
             s.birth_surname = UPPER (birth_surname_in),
             s.dob = date_of_birth_in,
             s.sex = UPPER (sex_in),
             s.marital_status = UPPER (marital_status_in),
             s.marriage_date = marriage_date_in,
             s.birth_country_code = birth_country_in,
             s.residence_country_code = residence_country_in,
             s.nation_country_code = nation_country_in,
             s.district_birth_cert_issued = UPPER (birth_district_in),
             s.stud_suspend = UPPER (stud_suspend_in),
             s.last_updated_by = UPPER (user_in),
             s.last_updated_on = SYSDATE
       WHERE s.stud_ref_no = stud_ref_no_in;

      row_count_s := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count_s := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updatestuddetails;

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
   )
   IS
   BEGIN
      UPDATE stud s
         SET s.email_addr = UPPER (email_addr_in),
             s.mobile_tel_no = mobile_tel_no_in,
             s.addr_corr_flag = UPPER (addr_corres_flag_in),
             s.last_updated_by = UPPER (user_in),
             s.last_updated_on = SYSDATE
       WHERE s.stud_ref_no = stud_ref_no_in;

      row_count_s := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      UPDATE stud_home_addr sha
         SET sha.last_updated_by = UPPER (user_in),
             sha.last_updated_on = SYSDATE
       WHERE sha.stud_ref_no = stud_ref_no_in;

      row_count_sha := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count_s := '0';
         row_count_sha := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updatecontactdetails;

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
   )
   IS
   BEGIN
      UPDATE stud s
         SET s.sort_code = sort_code_in,
             s.account_no = account_num_in,
             s.bank_validate = 'Y',
             s.payment_method = 'B',
             s.valid_duplicate_acc = UPPER (valid_dup_acc_in),
             s.dup_bank_reason = dup_bank_reason_in,
             s.last_updated_by = UPPER (user_in),
             s.last_updated_on = SYSDATE
       WHERE s.stud_ref_no = stud_ref_no_in;

      row_count_s := SQL%ROWCOUNT;
      sgas.pk_steps_ui_stud_dets.notifybankdetschange (stud_ref_no_in,
                                                       error_boolean,
                                                       ERROR_TEXT
                                                      );
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count_s := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updatebankdetails;

   PROCEDURE clearbankdetails (
      stud_ref_no_in   IN       NUMBER,
      user_in          IN       VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE stud s
         SET s.sort_code = NULL,
             s.account_no = NULL,
             s.bank_validate = 'N',
             s.payment_method = 'C',
             s.dup_bank_reason = NULL,
             s.valid_duplicate_acc = 'N',
             s.last_updated_by = UPPER (user_in),
             s.last_updated_on = SYSDATE
       WHERE s.stud_ref_no = stud_ref_no_in;

      sgas.pk_steps_ui_stud_dets.notifybankdetschange (stud_ref_no_in,
                                                       error_boolean,
                                                       ERROR_TEXT
                                                      );
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END clearbankdetails;

   PROCEDURE getprevhomeaddr (
      stud_ref_no_in   IN              NUMBER,
      io_cursor        IN OUT          prevhomeaddr_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
      pha_cursor   prevhomeaddr_cursor;
   BEGIN
      OPEN pha_cursor FOR
         SELECT   ROWNUM, sha.out_uk AS outuk, sha.start_date AS startdate,
                  sha.end_date AS enddate, sha.house_no_name AS houseno,
                  sha.addr_l1 AS addrl1, sha.addr_l2 AS addrl2,
                  sha.addr_l3 AS addrl3, sha.addr_l4 AS addrl4,
                  sha.post_code AS postcode, sha.tele_no AS telephone
             FROM stud_home_addr sha
            WHERE sha.stud_ref_no = stud_ref_no_in
         ORDER BY sha.end_date DESC;

      io_cursor := pha_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getprevhomeaddr;

   PROCEDURE getprevtermaddr (
      stud_ref_no_in   IN              NUMBER,
      io_cursor        IN OUT          prevtermaddr_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
      pta_cursor   prevtermaddr_cursor;
   BEGIN
      OPEN pta_cursor FOR
         SELECT   ROWNUM, stad.location_ind AS location_ind,
                  stad.start_date AS start_date, stad.end_date AS end_date,
                  stad.house_no_name AS house_no, stad.addr_l1 AS addr_l1,
                  stad.addr_l2 AS addr_l2, stad.addr_l3 AS addr_l3,
                  stad.addr_l4 AS addr_l4, stad.post_code AS postcode,
                  stad.tele_no AS telephone
             FROM stud_term_addr stad
            WHERE stad.stud_ref_no = stud_ref_no_in
         ORDER BY stad.end_date DESC;

      io_cursor := pta_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getprevtermaddr;

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
   )
   IS
   BEGIN
      UPDATE stud_home_addr sha
         SET sha.out_uk = UPPER (out_uk_in),
             sha.start_date = TO_DATE (start_date_in, 'DD-MM-YYYY HH24:MI:SS'),
             sha.house_no_name = UPPER (house_num_in),
             sha.addr_l1 = UPPER (addr_l1_in),
             sha.addr_l2 = UPPER (addr_l2_in),
             sha.addr_l3 = UPPER (addr_l3_in),
             sha.addr_l4 = UPPER (addr_l4_in),
             sha.post_code = UPPER (post_code_in),
             sha.last_updated_by = UPPER (user_in),
             sha.last_updated_on = SYSDATE,
             sha.tele_no = tele_no_in
       WHERE sha.stud_ref_no = stud_ref_no_in AND sha.end_date IS NULL;

      row_count_h := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count_h := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updatehomeaddr;

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
   )
   IS
   BEGIN
      UPDATE stud_term_addr stad
         SET stad.location_ind = UPPER (location_in),
             stad.start_date =
                              TO_DATE (start_date_in, 'DD-MM-YYYY HH24:MI:SS'),
             stad.house_no_name = UPPER (house_num_in),
             stad.addr_l1 = UPPER (addr_l1_in),
             stad.addr_l2 = UPPER (addr_l2_in),
             stad.addr_l3 = UPPER (addr_l3_in),
             stad.addr_l4 = UPPER (addr_l4_in),
             stad.post_code = UPPER (post_code_in),
             stad.last_updated_by = UPPER (user_in),
             stad.last_updated_on = SYSDATE,
             stad.tele_no = tele_no_in
       WHERE stad.stud_ref_no = stud_ref_no_in AND stad.end_date IS NULL;

      row_count_t := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count_t := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updatetermaddr;

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
   )
   AS
   BEGIN
      UPDATE stud_home_addr sha
         SET sha.end_date = (start_date_in - 1)
       WHERE sha.stud_ref_no = stud_ref_no_in AND sha.end_date IS NULL;

      INSERT INTO stud_home_addr
                  (stud_ref_no, out_uk, start_date, end_date,
                   house_no_name, addr_l1,
                   addr_l2, addr_l3,
                   addr_l4, post_code,
                   addr_easting, addr_northing,
                   tele_no, mailsort, last_updated_by,
                   last_updated_on
                  )
           VALUES (stud_ref_no_in, UPPER (out_uk_in), start_date_in, NULL,
                   UPPER (house_num_in), UPPER (addr_l1_in),
                   UPPER (addr_l2_in), UPPER (addr_l3_in),
                   UPPER (addr_l4_in), UPPER (post_code_in),
                   UPPER (addr_easting_in), UPPER (addr_northing_in),
                   UPPER (tele_no_in), UPPER (mail_sort_in), UPPER (user_in),
                   SYSDATE
                  );

      row_count_h := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         row_count_h := '0';
         ERROR_TEXT :=
               'SQLCODE='
            || SQLCODE
            || ' SQL ERROR = '
            || SQLERRM
            || ' : Changes have been rolled back';
   END addhomeaddr;

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
   )
   AS
   BEGIN
      UPDATE stud_term_addr stad
         SET stad.end_date = (start_date_in - 1)
       WHERE stad.stud_ref_no = stud_ref_no_in AND stad.end_date IS NULL;

      INSERT INTO stud_term_addr
                  (stud_ref_no, location_ind, residence_ind,
                   start_date, end_date, house_no_name,
                   addr_l1, addr_l2,
                   addr_l3, addr_l4,
                   post_code, addr_easting,
                   addr_northing, tele_no,
                   mailsort, last_updated_by, last_updated_on
                  )
           VALUES (stud_ref_no_in, UPPER (location_ind_in), 'O',
                   start_date_in, NULL, UPPER (house_num_in),
                   UPPER (addr_l1_in), UPPER (addr_l2_in),
                   UPPER (addr_l3_in), UPPER (addr_l4_in),
                   UPPER (post_code_in), UPPER (addr_easting_in),
                   UPPER (addr_northing_in), UPPER (tele_no_in),
                   UPPER (mail_sort_in), UPPER (user_in), SYSDATE
                  );

      row_count_t := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count_t := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END addtermaddr;

   PROCEDURE notifybankdetschange (
      stud_ref_no_in   IN       VARCHAR2,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   )
   IS
      v_stud_crse_year_id   NUMBER;
   BEGIN
      ERROR_TEXT := 'Getting supporting info ';

      SELECT scy.stud_crse_year_id
        INTO v_stud_crse_year_id
        FROM stud_crse_year scy
       WHERE scy.session_code =
                (SELECT MAX (scy.session_code)
                   FROM stud_crse_year scy
                  WHERE scy.stud_ref_no = stud_ref_no_in
                    AND latest_crse_ind = 'Y')
         AND scy.stud_ref_no = stud_ref_no_in
         AND scy.latest_crse_ind = 'Y';

      ERROR_TEXT := 'Updating Student Course Year ';

      UPDATE stud_crse_year scy
         SET scy.sal_sent = 'N'
       WHERE scy.stud_crse_year_id = v_stud_crse_year_id;

      COMMIT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END notifybankdetschange;
END pk_steps_ui_stud_dets;
/