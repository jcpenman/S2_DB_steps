CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_studentdetails
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
   )
   IS
   BEGIN
      SELECT ss.eu_flag, ss.session_code, ss.stud_ref_no, SCY.GA_STUDENT, ss.eu_residence_type
        INTO eu_flag_out, session_code_out, stud_ref_no_out, ga_student_out, eu_residence_type_out
        FROM stud_session ss, stud_crse_year scy
       WHERE SS.STUD_SESSION_ID = SCY.STUD_SESSION_ID
         AND ss.stud_session_id = stud_session_id_in
         AND SCY.LATEST_CRSE_IND = 'Y';

      SELECT s.stud_ref_no, s.ni_no, s.title, s.initials, s.forenames,
             s.surname, s.birth_forenames, s.birth_surname,
             TO_CHAR (s.dob, 'DD/MM/YYYY'), s.sex, s.marital_status,
             TO_CHAR (s.marriage_date, 'DD/MM/YYYY'), s.birth_country_code,
             s.residence_country_code, s.nation_country_code,
             s.district_birth_cert_issued, s.residence_status, s.nrs_cb,
             s.plus_one_used, s.care_exp_repeat ,s.dual_nationality, s.complex_residency,
             s.eu_settled_status, s.eu_settled_status_confirmed         
        INTO stud_ref_no_out, nino_out, title_out, initial_out, forename_out,
             surname_out, birth_forename_out, birth_surname_out,
             date_of_birth_out, sex_out, marital_status_out,
             marriage_date_out, birth_country_out,
             residence_country_out, nation_country_out,
             birth_district_out, res_status_out, nrs_cb_out, 
             plus_one_used_out, care_exp_repeat_out ,dual_nationality_out, complex_residency_out,
             eu_settled_status_out, eu_settled_status_confirmed_out
        FROM stud s
       WHERE s.stud_ref_no = stud_ref_no_out;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getpersonaldetails;

   PROCEDURE getcontactdetails (
      stud_ref_no_in      IN              NUMBER,
      mobile_tel_no_out   OUT NOCOPY      VARCHAR2,
      email_addr          OUT NOCOPY      VARCHAR2,
      addr_corr_flag      OUT NOCOPY      VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT s.mobile_tel_no, s.email_addr, s.addr_corr_flag
        INTO mobile_tel_no_out, email_addr, addr_corr_flag
        FROM stud s
       WHERE s.stud_ref_no = stud_ref_no_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getcontactdetails;

PROCEDURE getOnlineAccount (
      stud_ref_no_in        IN            VARCHAR2,
      online_account        OUT           VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   )
   IS
   portal_id VARCHAR2(25);
   
   BEGIN
      SELECT STUD.PORTAL_USER_ID INTO portal_id FROM STUD WHERE STUD.STUD_REF_NO = stud_ref_no_in;
    
      IF(portal_id is null) 
      THEN
        online_account := 'false';
      ELSE
        online_account := 'true';
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getOnlineAccount;


   PROCEDURE getbankdetails (
      stud_ref_no_in    IN       NUMBER,
      sort_code         OUT      VARCHAR2,
      account_num       OUT      VARCHAR2,
      valid_dup_acc     OUT      VARCHAR2,
      dup_bank_reason   OUT      VARCHAR2,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   )
   IS
   BEGIN
      SELECT s.sort_code, s.account_no, s.valid_duplicate_acc,
             s.dup_bank_reason
        INTO sort_code, account_num, valid_dup_acc,
             dup_bank_reason
        FROM stud s
       WHERE s.stud_ref_no = stud_ref_no_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getbankdetails;

   PROCEDURE getaddresses (
      stud_ref_no_in   IN       NUMBER,
      h_cursor         IN OUT   homeaddr_cursor,
      t_cursor         IN OUT   termaddr_cursor,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   )
   IS
      ha_cursor   homeaddr_cursor;
      ta_cursor   termaddr_cursor;
   BEGIN
      OPEN ha_cursor FOR
         SELECT   sha.out_uk AS outuk,
                  TO_CHAR (sha.start_date,
                           'DD/MM/YYYY HH24:MI:SS'
                          ) AS startdate,
                  TO_CHAR (sha.end_date, 'DD/MM/YYYY HH24:MI:SS') AS enddate,
                  sha.house_no_name AS houseno, sha.addr_l1 AS addrl1,
                  sha.addr_l2 AS addrl2, sha.addr_l3 AS addrl3,
                  sha.addr_l4 AS addrl4, sha.post_code AS postcode,
                  sha.tele_no AS telephone
             FROM stud_home_addr sha
            WHERE sha.stud_ref_no = stud_ref_no_in
         ORDER BY sha.end_date DESC;

      h_cursor := ha_cursor;

      OPEN ta_cursor FOR
         SELECT   stad.location_ind AS location_ind,
                  TO_CHAR (stad.start_date,
                           'DD/MM/YYYY HH24:MI:SS'
                          ) AS start_date,
                  TO_CHAR (stad.end_date,
                           'DD/MM/YYYY HH24:MI:SS') AS end_date,
                  stad.house_no_name AS houseno, stad.addr_l1 AS addrl1,
                  stad.addr_l2 AS addrl2, stad.addr_l3 AS addrl3,
                  stad.addr_l4 AS addrl4, stad.post_code AS postcode,
                  stad.tele_no AS telephone
             FROM stud_term_addr stad
            WHERE stad.stud_ref_no = stud_ref_no_in
         ORDER BY stad.end_date DESC;

      t_cursor := ta_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getaddresses;

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
      ERROR_TEXT                        OUT      VARCHAR2
   )
   IS
      v_stud_ref_no   VARCHAR (10);
      v_stud_crse_year_id VARCHAR(10);
   BEGIN
      UPDATE stud_session ss
         SET ss.eu_flag = UPPER (eu_flag_in),
             ss.eu_residence_type = UPPER (eu_residence_type_in)
       WHERE ss.stud_session_id = stud_session_id_in;

      SELECT ss.stud_ref_no
        INTO v_stud_ref_no
        FROM stud_session ss
       WHERE ss.stud_session_id = stud_session_id_in;
       
       SELECT a.stud_crse_year_id
         INTO v_stud_crse_year_id
         FROM stud_crse_year a
        WHERE A.STUD_SESSION_ID = stud_session_id_in
          AND A.LATEST_CRSE_IND = 'Y';

      UPDATE stud s
         SET s.ni_no = UPPER (nino_in),
             s.title = UPPER (title_in),
             s.initials = UPPER (initial_in),
             s.forenames = UPPER (forename_in),
             s.surname = UPPER (surname_in),
             s.birth_forenames = UPPER (birth_forename_in),
             s.birth_surname = UPPER (birth_surname_in),
             s.dob = TO_DATE (date_of_birth_in, 'DD/MM.yyyy'),
             s.sex = UPPER (sex_in),
             s.marital_status = UPPER (marital_status_in),
             s.marriage_date = TO_DATE (marriage_date_in, 'DD/MM.yyyy'),
             s.birth_country_code = birth_country_in,
             s.residence_country_code = residence_country_in,
             s.nation_country_code = nation_country_in,
             s.district_birth_cert_issued = UPPER (birth_district_in),
             s.residence_status = UPPER (res_status_in),
             s.nrs_cb = UPPER (nrs_cb_in),
             s.plus_one_used = UPPER (plus_one_used_in),
             s.care_exp_repeat = UPPER(care_exp_repeat_in),
             s.dual_nationality = UPPER (dual_nationality_in),
             S.COMPLEX_RESIDENCY = UPPER(complex_residency_in),
             S.EU_SETTLED_STATUS = eu_settled_status_in,
             S.EU_SETTLED_STATUS_CONFIRMED = eu_settled_status_confirmed_in,
             s.last_updated_by = UPPER (employee),
             s.last_updated_on = SYSDATE
       WHERE s.stud_ref_no = v_stud_ref_no;
       
       UPDATE stud_crse_year scy
          SET SCY.GA_STUDENT = UPPER(ga_student_in)
          WHERE scy.stud_crse_year_id = v_stud_crse_year_id;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setpersonaldetails;

   PROCEDURE setcontactdetails (
      stud_ref_no_in        IN       NUMBER,
      email_addr_in         IN       VARCHAR2,
      mobile_tel_no_in      IN       VARCHAR2,
      addr_corres_flag_in   IN       VARCHAR2,
      employee              IN       VARCHAR2,
      error_boolean         OUT      VARCHAR2,
      ERROR_TEXT            OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE stud s
         SET s.email_addr = UPPER (email_addr_in),
             s.mobile_tel_no = mobile_tel_no_in,
             s.addr_corr_flag = UPPER (addr_corres_flag_in),
             s.last_updated_by = UPPER (employee),
             s.last_updated_on = SYSDATE
       WHERE s.stud_ref_no = stud_ref_no_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setcontactdetails;

   PROCEDURE setbankdetails (
      stud_ref_no_in       IN       NUMBER,
      sort_code_in         IN       VARCHAR2,
      account_num_in       IN       VARCHAR2,
      valid_dup_acc_in     IN       VARCHAR2,
      dup_bank_reason_in   IN       VARCHAR2,
      employee             IN       VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
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
             s.last_updated_by = UPPER (employee),
             s.last_updated_on = SYSDATE
       WHERE s.stud_ref_no = stud_ref_no_in;

      sgas.pk_steps_ui_studentdetails.notifybankdetschange (stud_ref_no_in,
                                                            error_boolean,
                                                            ERROR_TEXT
                                                           );
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setbankdetails;

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

      sgas.pk_steps_ui_studentdetails.notifybankdetschange (stud_ref_no_in,
                                                            error_boolean,
                                                            ERROR_TEXT
                                                           );
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END clearbankdetails;

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
   )
   IS
   BEGIN
      UPDATE stud_home_addr sha
         SET sha.out_uk = UPPER (out_uk_in),
             sha.start_date = TO_DATE (start_date_in, 'DD/MM/YYYY HH24:MI:SS'),
             sha.house_no_name = UPPER (house_num_in),
             sha.addr_l1 = UPPER (addr_l1_in),
             sha.addr_l2 = UPPER (addr_l2_in),
             sha.addr_l3 = UPPER (addr_l3_in),
             sha.addr_l4 = UPPER (addr_l4_in),
             sha.post_code = UPPER (post_code_in),
             sha.last_updated_by = UPPER (user_in),
             sha.last_updated_on = SYSDATE,
             sha.tele_no = tele_no_in
       WHERE sha.stud_ref_no = stud_ref_no_in
         AND sha.start_date =
                        TO_DATE (original_start_date, 'DD/MM/YYYY HH24:MI:SS');

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updatehomeaddr;

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
   )
   IS
   BEGIN
      UPDATE stud_term_addr stad
         SET stad.location_ind = UPPER (location_in),
             stad.start_date =
                              TO_DATE (start_date_in, 'DD/MM/YYYY HH24:MI:SS'),
             stad.house_no_name = UPPER (house_num_in),
             stad.addr_l1 = UPPER (addr_l1_in),
             stad.addr_l2 = UPPER (addr_l2_in),
             stad.addr_l3 = UPPER (addr_l3_in),
             stad.addr_l4 = UPPER (addr_l4_in),
             stad.post_code = UPPER (post_code_in),
             stad.last_updated_by = UPPER (user_in),
             stad.last_updated_on = SYSDATE,
             stad.tele_no = tele_no_in
       WHERE stad.stud_ref_no = stud_ref_no_in
         AND stad.start_date =
                        TO_DATE (original_start_date, 'DD/MM/YYYY HH24:MI:SS');

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updatetermaddr;

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
   )
   AS
      v_prev_addr_end_date   DATE;
   BEGIN
      ERROR_TEXT := 'Determining previous end date. ';
      v_prev_addr_end_date :=
                          TO_DATE (start_date_in, 'DD/MM/YYYY HH24:MI:SS')
                          - 1;
      ERROR_TEXT := 'Updating previous address. ';

      UPDATE stud_home_addr sha
         SET sha.end_date = v_prev_addr_end_date
       WHERE sha.stud_ref_no = stud_ref_no_in AND sha.end_date IS NULL;

      ERROR_TEXT := 'Inserting new address. ';

      INSERT INTO stud_home_addr
                  (stud_ref_no, out_uk,
                   start_date, end_date,
                   house_no_name, addr_l1,
                   addr_l2, addr_l3,
                   addr_l4, post_code,
                   tele_no, last_updated_by, last_updated_on
                  )
           VALUES (stud_ref_no_in, UPPER (out_uk_in),
                   TO_DATE (start_date_in, 'DD/MM/YYYY HH24:MI:SS'), NULL,
                   UPPER (house_num_in), UPPER (addr_l1_in),
                   UPPER (addr_l2_in), UPPER (addr_l3_in),
                   UPPER (addr_l4_in), UPPER (post_code_in),
                   UPPER (tele_no_in), UPPER (user_in), SYSDATE
                  );

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               ERROR_TEXT
            || 'SQLCODE='
            || SQLCODE
            || ' SQL ERROR = '
            || SQLERRM
            || ' : Changes have been rolled back';
   END addhomeaddr;

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
   )
   AS
      v_prev_addr_end_date   DATE;
      v_term_addr_count      NUMBER;
   BEGIN
      ERROR_TEXT :=
         'Term address for this student on this start date already exists. Address not inserted';

      SELECT COUNT (*)
        INTO v_term_addr_count
        FROM stud_term_addr
       WHERE stud_term_addr.stud_ref_no = stud_ref_no_in
         AND stud_term_addr.start_date = TO_DATE (start_date_in, 'dd/MM/yyyy');

      IF v_term_addr_count = 0
      THEN
         ERROR_TEXT := 'Determining previous end date. ';
         v_prev_addr_end_date :=
                          TO_DATE (start_date_in, 'DD/MM/YYYY HH24:MI:SS')
                          - 1;
         ERROR_TEXT := 'Updating previous address. ';

         UPDATE stud_term_addr stad
            SET stad.end_date = v_prev_addr_end_date
          WHERE stad.stud_ref_no = stud_ref_no_in AND stad.end_date IS NULL;

         ERROR_TEXT := 'Inserting new address. ';

         INSERT INTO stud_term_addr
                     (stud_ref_no, location_ind, residence_ind,
                      start_date, end_date,
                      house_no_name, addr_l1,
                      addr_l2, addr_l3,
                      addr_l4, post_code,
                      tele_no, last_updated_by, last_updated_on
                     )
              VALUES (stud_ref_no_in, UPPER (location_ind_in), 'O',
                      TO_DATE (start_date_in, 'DD/MM/YYYY HH24:MI:SS'), NULL,
                      UPPER (house_num_in), UPPER (addr_l1_in),
                      UPPER (addr_l2_in), UPPER (addr_l3_in),
                      UPPER (addr_l4_in), UPPER (post_code_in),
                      UPPER (tele_no_in), UPPER (user_in), SYSDATE
                     );

         error_boolean := 'false';
         ERROR_TEXT := 'none';
         COMMIT;
      ELSE
         error_boolean := 'true';
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END addtermaddr;

   PROCEDURE checktermaddrexists (
      stud_ref_no_in     IN       VARCHAR2,
      start_date_in      IN       DATE,
      term_addr_exists   OUT      VARCHAR2,
      error_boolean      OUT      VARCHAR2,
      ERROR_TEXT         OUT      VARCHAR2
   )
   AS
      v_term_addr_count   NUMBER;
   BEGIN
      ERROR_TEXT := 'Checking term address';

      SELECT COUNT (*)
        INTO v_term_addr_count
        FROM stud_term_addr
       WHERE stud_term_addr.stud_ref_no = stud_ref_no_in
         AND TRUNC (stud_term_addr.start_date) = TRUNC (start_date_in);

      IF v_term_addr_count = 0
      THEN
         term_addr_exists := 'false';
      ELSE
         term_addr_exists := 'true';
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END checktermaddrexists;

   PROCEDURE checkhomeaddrexists (
      stud_ref_no_in     IN       VARCHAR2,
      start_date_in      IN       DATE,
      home_addr_exists   OUT      VARCHAR2,
      error_boolean      OUT      VARCHAR2,
      ERROR_TEXT         OUT      VARCHAR2
   )
   AS
      v_home_addr_count   NUMBER;
   BEGIN
      ERROR_TEXT := 'Checking home address';

      SELECT COUNT (*)
        INTO v_home_addr_count
        FROM stud_home_addr
       WHERE stud_home_addr.stud_ref_no = stud_ref_no_in
         AND TRUNC (stud_home_addr.start_date) = TRUNC (start_date_in);

      IF v_home_addr_count = 0
      THEN
         home_addr_exists := 'false';
      ELSE
         home_addr_exists := 'true';
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END checkhomeaddrexists;
END pk_steps_ui_studentdetails;
/