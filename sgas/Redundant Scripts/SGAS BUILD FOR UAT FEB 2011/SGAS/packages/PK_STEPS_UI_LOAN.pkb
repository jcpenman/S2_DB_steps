CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_loan
AS
/******************************************************************************
   NAME:       pk_steps_ui_LOAN
   PURPOSE:

   REVISIONS:
   Ver        Date              Author                  Description
   ---------  ----------        ---------------         ------------------------------------
   1.0        17/11/2008         PADDY GRACE            Created this package.
   1.1        09/06/2009         ABIRAMI CHIDAMBARAM    Code Population.
******************************************************************************/
   PROCEDURE getloancontactone (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          loanconatctone_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
      lco_cursor   loanconatctone_cursor;
   BEGIN
      OPEN lco_cursor FOR
         SELECT sc.cont_name AS NAME, sc.cont_rel_code AS relationship,
                sc.cont_addr1 AS addr_l1, sc.cont_addr2 AS addr_l2,
                sc.cont_addr3 AS addr_l3, sc.cont_postcode AS postcode,
                sc.cont_tel_no AS tele_no,
                (SELECT COUNT (*)
                   FROM stud_cont_details sc
                  WHERE sc.stud_ref_no = stud_ref_no_in
                    AND sc.contact_ind = '1') AS record_count
           FROM stud_cont_details sc
          WHERE sc.stud_ref_no = stud_ref_no_in AND sc.contact_ind = '1';

      io_cursor := lco_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getloancontactone;

   PROCEDURE setloancontactone (
      stud_ref_no_in   IN              VARCHAR2,
      NAME_IN          IN              VARCHAR2,
      rel_in           IN              VARCHAR2,
      addr_l1_in       IN              VARCHAR2,
      addr_l2_in       IN              VARCHAR2,
      addr_l3_in       IN              VARCHAR2,
      postcode_in      IN              VARCHAR2,
      tele_no_in       IN              VARCHAR2,
      user_in          IN              VARCHAR2,
      row_count        OUT             VARCHAR2,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_cont_details sc
         SET sc.cont_name = UPPER (NAME_IN),
             sc.cont_rel_code = UPPER (rel_in),
             sc.cont_addr1 = UPPER (addr_l1_in),
             sc.cont_addr2 = UPPER (addr_l2_in),
             sc.cont_addr3 = UPPER (addr_l3_in),
             sc.cont_postcode = UPPER (postcode_in),
             sc.cont_tel_no = tele_no_in,
             sc.last_updated_by = UPPER (user_in),
             sc.last_updated_on = SYSDATE
       WHERE sc.stud_ref_no = stud_ref_no_in AND sc.contact_ind = '1';

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setloancontactone;

   PROCEDURE insertloancontactone (
      stud_ref_no_in   IN              VARCHAR2,
      NAME_IN          IN              VARCHAR2,
      rel_in           IN              VARCHAR2,
      addr_l1_in       IN              VARCHAR2,
      addr_l2_in       IN              VARCHAR2,
      addr_l3_in       IN              VARCHAR2,
      postcode_in      IN              VARCHAR2,
      tele_no_in       IN              VARCHAR2,
      user_in          IN              VARCHAR2,
      row_count        OUT             VARCHAR2,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      INSERT INTO stud_cont_details sc
                  (sc.stud_ref_no, sc.cont_name, sc.cont_rel_code,
                   sc.cont_addr1, sc.cont_addr2,
                   sc.cont_addr3, sc.cont_postcode, sc.cont_tel_no,
                   sc.contact_ind, sc.last_updated_by, sc.last_updated_on
                  )
           VALUES (stud_ref_no_in, UPPER (NAME_IN), UPPER (rel_in),
                   UPPER (addr_l1_in), UPPER (addr_l2_in),
                   UPPER (addr_l3_in), UPPER (postcode_in), tele_no_in,
                   '1', UPPER (user_in), SYSDATE
                  );
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertloancontactone;

   PROCEDURE getloancontacttwo (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          loanconatcttwo_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
      lct_cursor   loanconatcttwo_cursor;
   BEGIN
      OPEN lct_cursor FOR
         SELECT sc.cont_name AS NAME, sc.cont_addr1 AS addr_l1,
                sc.cont_addr2 AS addr_l2, sc.cont_addr3 AS addr_l3,
                sc.cont_postcode AS postcode, sc.cont_tel_no AS tele_no,
                (SELECT COUNT (*)
                   FROM stud_cont_details sc
                  WHERE sc.stud_ref_no = stud_ref_no_in
                    AND sc.contact_ind = '2') AS record_count
           FROM stud_cont_details sc
          WHERE sc.stud_ref_no = stud_ref_no_in AND sc.contact_ind = '2';

      io_cursor := lct_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getloancontacttwo;

   PROCEDURE setloancontacttwo (
      stud_ref_no_in   IN              VARCHAR2,
      NAME_IN          IN              VARCHAR2,
      addr_l1_in       IN              VARCHAR2,
      addr_l2_in       IN              VARCHAR2,
      addr_l3_in       IN              VARCHAR2,
      postcode_in      IN              VARCHAR2,
      tele_no_in       IN              VARCHAR2,
      user_in          IN              VARCHAR2,
      row_count        OUT             VARCHAR2,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_cont_details sc
         SET sc.cont_name = UPPER (NAME_IN),
             sc.cont_addr1 = UPPER (addr_l1_in),
             sc.cont_addr2 = UPPER (addr_l2_in),
             sc.cont_addr3 = UPPER (addr_l3_in),
             sc.cont_postcode = UPPER (postcode_in),
             sc.cont_tel_no = tele_no_in,
             sc.last_updated_by = UPPER (user_in),
             sc.last_updated_on = SYSDATE
       WHERE sc.stud_ref_no = stud_ref_no_in AND sc.contact_ind = '2';

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setloancontacttwo;

   PROCEDURE insertloancontacttwo (
      stud_ref_no_in   IN              VARCHAR2,
      NAME_IN          IN              VARCHAR2,
      addr_l1_in       IN              VARCHAR2,
      addr_l2_in       IN              VARCHAR2,
      addr_l3_in       IN              VARCHAR2,
      postcode_in      IN              VARCHAR2,
      tele_no_in       IN              VARCHAR2,
      user_in          IN              VARCHAR2,
      row_count        OUT             VARCHAR2,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      INSERT INTO stud_cont_details sc
                  (sc.stud_ref_no, sc.cont_name, sc.cont_addr1,
                   sc.cont_addr2, sc.cont_addr3,
                   sc.cont_postcode, sc.cont_tel_no, sc.contact_ind,
                   sc.last_updated_by, sc.last_updated_on
                  )
           VALUES (stud_ref_no_in, UPPER (NAME_IN), UPPER (addr_l1_in),
                   UPPER (addr_l2_in), UPPER (addr_l3_in),
                   UPPER (postcode_in), tele_no_in, '2',
                   UPPER (user_in), SYSDATE
                  );

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertloancontacttwo;

   PROCEDURE getloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          loandetails_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      ld_cursor   loandetails_cursor;
   BEGIN
      OPEN ld_cursor FOR
         SELECT ss.max_loan_requested AS maximum_loan,
                sc.loan_given AS loan_given, ss.loan_request AS loan_amount,
                ss.loan_declaration_date AS loan_sign_date,
                ss.reason_no_nino AS no_nino_reason,
                s.bankrupt_flag AS bankrupt, s.ni_no AS nino
           FROM stud_crse_year sc, stud s, stud_session ss
          WHERE ss.stud_session_id = sc.stud_session_id
            AND s.stud_ref_no = sc.stud_ref_no
            AND sc.stud_crse_year_id = stud_crse_year_id_in;

      io_cursor := ld_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getloandetails;

   PROCEDURE setloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      stud_ref_no_in         IN              VARCHAR2,
      max_loan_in            IN              VARCHAR2,
      loan_given_in          IN              VARCHAR2,
      loan_request_in        IN              VARCHAR2,
      loan_dec_date          IN              DATE,
      reason_no_nino_in      IN              VARCHAR2,
      bankrupt_in            IN              VARCHAR2,
      user_in                IN              VARCHAR2,
      row_count_ss           OUT             VARCHAR2,
      row_count_sc           OUT             VARCHAR2,
      row_count_s            OUT             VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_session ss
         SET ss.max_loan_requested = UPPER (max_loan_in),
             ss.loan_request = UPPER (loan_request_in),
             ss.loan_declaration_date = loan_dec_date,
             ss.reason_no_nino = UPPER (reason_no_nino_in),
             ss.last_updated_by = UPPER (user_in),
             ss.last_updated_on = SYSDATE
       WHERE ss.stud_session_id =
                          (SELECT sc.stud_session_id
                             FROM stud_crse_year sc
                            WHERE sc.stud_crse_year_id = stud_crse_year_id_in);

      row_count_ss := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      UPDATE stud_crse_year sc
         SET sc.loan_given = UPPER (loan_given_in),
             sc.last_updated_by = UPPER (user_in),
             sc.last_updated_on = SYSDATE
       WHERE sc.stud_crse_year_id = stud_crse_year_id_in;

      row_count_sc := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      UPDATE stud s
         SET s.bankrupt_flag = UPPER (bankrupt_in),
             s.last_updated_by = UPPER (user_in),
             s.last_updated_on = SYSDATE
       WHERE s.stud_ref_no =
                          (SELECT sc.stud_ref_no
                             FROM stud_crse_year sc
                            WHERE sc.stud_crse_year_id = stud_crse_year_id_in);

      row_count_s := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count_ss := '0';
         row_count_sc := '0';
         row_count_s := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setloandetails;

   PROCEDURE getfeeloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      stud_ref_no_in         IN              VARCHAR2,
      io_cursor              IN OUT          feeloandetails_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      fld_cursor   feeloandetails_cursor;
   BEGIN
      OPEN fld_cursor FOR
         SELECT ss.max_fee_loan_requested AS max_fee_loan,
                ss.fee_loan_request_amount AS fee_loan_amt,
                ss.fee_loan_charged AS fee_loan_charged,
                sc.fee_loan_given AS fee_loan_given,
                ss.fee_loan_declaration_date AS fee_loan_sign_date,
                (SELECT COUNT (*)
                   FROM stud_crse_year sc
                  WHERE sc.stud_ref_no = stud_ref_no_in
                    AND sc.session_code =
                           (SELECT sc.session_code
                              FROM stud_crse_year sc
                             WHERE sc.stud_crse_year_id = stud_crse_year_id_in)
                    AND sc.dearing = 'G') AS record_count,
                s.commence_session AS commence_session
           FROM stud_crse_year sc, stud_session ss, stud s
          WHERE ss.stud_session_id = sc.stud_session_id
            AND s.stud_ref_no = sc.stud_ref_no
            AND sc.dearing = 'G'
            AND sc.stud_crse_year_id = stud_crse_year_id_in;

      io_cursor := fld_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getfeeloandetails;

   PROCEDURE setfeeloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      stud_ref_no_in         IN              VARCHAR2,
      max_fee_loan_in        IN              VARCHAR2,
      fee_loan_given_in      IN              VARCHAR2,
      fee_loan_request_in    IN              VARCHAR2,
      fee_loan_charged_in    IN              VARCHAR2,
      fee_loan_dec_date      IN              DATE,
      user_in                IN              VARCHAR2,
      row_count_ss           OUT             VARCHAR2,
      row_count_sc           OUT             VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_session ss
         SET ss.max_fee_loan_requested = max_fee_loan_in,
             ss.fee_loan_request_amount = fee_loan_request_in,
             ss.fee_loan_charged = fee_loan_charged_in,
             ss.fee_loan_declaration_date = fee_loan_dec_date,
             ss.last_updated_by = UPPER (user_in),
             ss.last_updated_on = SYSDATE
       WHERE ss.stud_session_id =
                          (SELECT sc.stud_session_id
                             FROM stud_crse_year sc
                            WHERE sc.stud_crse_year_id = stud_crse_year_id_in);

      row_count_ss := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      UPDATE stud_crse_year sc
         SET sc.fee_loan_given = fee_loan_given_in,
             sc.last_updated_by = UPPER (user_in),
             sc.last_updated_on = SYSDATE
       WHERE sc.stud_crse_year_id = stud_crse_year_id_in;

      row_count_sc := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count_ss := '0';
         row_count_sc := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setfeeloandetails;

   PROCEDURE getslc (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          studloancompany_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      slc_cursor   studloancompany_cursor;
   BEGIN
      OPEN slc_cursor FOR
         SELECT s.scottish_cand AS slc_ref_num_in,
                sc.slc1_sent_date AS loan_ass_last_sent,
                sc.slc1_status AS loan_ass_status,
                sc.first_slc1_sent_date AS loan_ass_first_sent,
                sc.slc2_sent_date AS loan_app_last_sent,
                sc.slc2_status AS loan_app_status,
                sc.first_slc2_sent_date AS loan_app_first_sent
           FROM stud_crse_year sc, stud s
          WHERE sc.stud_ref_no = s.stud_ref_no
            AND sc.stud_crse_year_id = stud_crse_year_id_in;

      io_cursor := slc_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getslc;

   PROCEDURE setslc (
      stud_crse_year_id_in   IN              VARCHAR2,
      loan_ass_status_in     IN              VARCHAR2,
      loan_app_status_in     IN              VARCHAR2,
      user_in                IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
      UPDATE stud_crse_year sc
         SET sc.slc1_status = UPPER (loan_ass_status_in),
             sc.slc2_status = UPPER (loan_app_status_in),
             sc.last_updated_by = UPPER (user_in),
             sc.last_updated_on = SYSDATE
       WHERE sc.stud_crse_year_id = stud_crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setslc;
   
  PROCEDURE deleteloancontact (
      stud_ref_no_in      IN              VARCHAR2,
      contact_number_in   IN              VARCHAR2,
      user_in             IN              VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   )
   AS
   BEGIN
   
      UPDATE stud_cont_details scd 
      SET SCD.LAST_UPDATED_BY = UPPER(user_in)
      WHERE scd.stud_ref_no = stud_ref_no_in
      AND scd.contact_ind = contact_number_in;
   
      DELETE FROM stud_cont_details scd
      WHERE  scd.stud_ref_no = stud_ref_no_in
      AND scd.contact_ind = contact_number_in;
 
      error_boolean := 'false';
      ERROR_TEXT := 'none';     
         
   EXCEPTION
     WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;   
   
   END deleteloancontact;   
END pk_steps_ui_loan;
/
