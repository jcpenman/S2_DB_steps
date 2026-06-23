CREATE OR REPLACE PACKAGE BODY SGAS.pk_student_snapshot_report
IS
/******************************************************************************
   NAME:       pk_student_snapshot_report
   PURPOSE:

   REVISIONS:
   Ver        Date        Author            Description
   ---------  ----------  ---------------   ------------------------------------
   1.0        14/02/2012  A.Bowman          Created this package.
   1.1        26/06/2012  J.Wynne           Modified get_stcy_dets to format dates
   2.0        03/07/2012  J.Wynne           Added two new procdeures get_loan_dets AND getloan_total_dets
   2.1        12/07/2012  J.Wynne           Added procedure get_awards_paid_out
*********************************************************************************/
   PROCEDURE get_header_info (
      stud_ref_no_in       IN              VARCHAR2,
      name_out             OUT NOCOPY      VARCHAR2,
      nino_out             OUT NOCOPY      VARCHAR2,
      dob_out              OUT NOCOPY      VARCHAR2,
      marital_status_out   OUT NOCOPY      VARCHAR2,
      house_no_name_out    OUT NOCOPY      VARCHAR2,
      addr1_out            OUT NOCOPY      VARCHAR2,
      addr2_out            OUT NOCOPY      VARCHAR2,
      addr3_out            OUT NOCOPY      VARCHAR2,
      addr4_out            OUT NOCOPY      VARCHAR2,
      post_code_out        OUT NOCOPY      VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT st.forenames || ' ' || st.surname NAME, st.ni_no, st.dob,
             st.marital_status, sth.house_no_name, sth.addr_l1, sth.addr_l2,
             sth.addr_l3, sth.addr_l4, sth.post_code
        INTO name_out, nino_out, dob_out,
             marital_status_out, house_no_name_out, addr1_out, addr2_out,
             addr3_out, addr4_out, post_code_out
        FROM stud st, stud_home_addr sth
       WHERE st.stud_ref_no = stud_ref_no_in
         AND st.stud_ref_no = sth.stud_ref_no;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END get_header_info;

   PROCEDURE get_session_code (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          session_code_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
      sess_cursor   session_code_cursor;
   BEGIN
      OPEN sess_cursor FOR
         SELECT ss.stud_session_id, ss.session_code
           FROM stud_session ss
          WHERE ss.stud_ref_no = stud_ref_no_in;

      io_cursor := sess_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END get_session_code;

   PROCEDURE get_stcy_dets (
      stud_session_id_in   IN              VARCHAR2,
      io_cursor            IN OUT          stcy_dets_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
      stcy_cursor   stcy_dets_cursor;
   BEGIN
      OPEN stcy_cursor FOR
         SELECT   scy.stud_session_id, scy.stud_crse_year_id, scy.inst_name,
                  scy.crse_name, scy.crse_year_id, scy.crse_year_no,
                  scy.application_status, scy.withdraw_date,
                  scy.declaration_date,
                  TO_CHAR (ss.date_applic_received,
                           'DD-MON-YYYY'
                          ) date_applic_received,
                  TO_CHAR (NVL (ct.start_date, it.start_date),
                           'DD-MON-YYYY'
                          ) term_start,                   
                  TO_CHAR (NVL (ct.end_date, it.end_date),
                           'DD-MON-YYYY'
                          ) term_end,
                  TO_CHAR (NVL (MIN (c2.start_date), MIN (i2.start_date)),
                           'DD-MON-YYYY'
                          ) period_start,
                  TO_CHAR (NVL (MAX (c2.end_date), MAX (i2.end_date)),
                           'DD-MON-YYYY'
                          ) period_end,
                  NVL (ct.start_date, it.start_date) orderByDate  
             FROM stud_crse_year scy,
                  stud_session ss,
                  crse_term ct,
                  crse_term c2,
                  inst_term it,
                  inst_term i2
            WHERE scy.stud_session_id = stud_session_id_in
              AND scy.stud_session_id = ss.stud_session_id
              AND scy.latest_crse_ind = 'Y'
              AND scy.crse_year_id = ct.crse_year_id(+)
              AND scy.crse_year_id = c2.crse_year_id(+)
              AND scy.inst_code = it.inst_code
              AND scy.session_code = it.session_code
              AND scy.inst_code = i2.inst_code
              AND scy.session_code = i2.session_code
         GROUP BY scy.stud_session_id,
                  scy.stud_crse_year_id,
                  scy.inst_name,
                  scy.crse_name,
                  scy.crse_year_id,
                  scy.inst_name,
                  scy.crse_name,
                  scy.crse_year_no,
                  scy.withdraw_date,
                  scy.application_status,
                  scy.declaration_date,
                  TO_CHAR (ss.date_applic_received, 'DD-MON-YYYY'),
                  TO_CHAR (NVL (ct.start_date, it.start_date), 'DD-MON-YYYY'),                  
                  TO_CHAR (NVL (ct.end_date, it.end_date), 'DD-MON-YYYY'),
                  NVL (ct.start_date, it.start_date)
                  ORDER BY orderByDate;

      io_cursor := stcy_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END get_stcy_dets;

   PROCEDURE get_award_dets (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          award_dets_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      aw_cursor   award_dets_cursor;
   BEGIN
      OPEN aw_cursor FOR
         SELECT aw.stud_crse_year_id, aw.award_type_descript, aw.amount,
                aw.contrib_amount, aw.overpayment_amount, aw.net_amount
           FROM award aw, stud_award_type sap
          WHERE aw.stud_crse_year_id = stud_crse_year_id_in
            AND aw.stud_award_type = sap.stud_award_type
            AND sap.loan_non_loan_fee = 'non-Loan';

      io_cursor := aw_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END get_award_dets;

   PROCEDURE get_fee_award_dets (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          fee_award_dets_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      faw_cursor   fee_award_dets_cursor;
   BEGIN
      OPEN faw_cursor FOR
         SELECT aw.stud_crse_year_id, aw.award_type_descript, aw.amount,
                aw.contrib_amount, aw.overpayment_amount, aw.net_amount
           FROM award aw, stud_award_type sap
          WHERE aw.stud_crse_year_id = stud_crse_year_id_in
            AND aw.stud_award_type = sap.stud_award_type
            AND sap.loan_non_loan_fee = 'fee';

      io_cursor := faw_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END get_fee_award_dets;

   PROCEDURE get_loan_dets (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          loan_dets_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      loan_cursor   loan_dets_cursor;
   BEGIN
      OPEN loan_cursor FOR
         SELECT a.award_type_descript, a.stud_award_type, a.amount,
                a.contrib_amount, a.unclaimed_loan, a.net_amount
           FROM award a
          WHERE a.stud_crse_year_id = stud_crse_year_id_in
            AND a.stud_award_type IN (
                                   SELECT sat.stud_award_type
                                     FROM stud_award_type sat
                                    WHERE UPPER (sat.loan_non_loan_fee) =
                                                                        'LOAN');

      io_cursor := loan_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END get_loan_dets;

   PROCEDURE get_loan_total_dets (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          loan_total_dets_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      loan_tot_cursor   loan_total_dets_cursor;
   BEGIN
      OPEN loan_tot_cursor FOR
         SELECT 'Total' AS award_type_descript, SUM (a.amount),
                SUM (a.contrib_amount), SUM (a.unclaimed_loan),
                SUM (a.net_amount)
           FROM award a
          WHERE a.stud_crse_year_id = stud_crse_year_id_in
            AND a.stud_award_type IN (
                                   SELECT sat.stud_award_type
                                     FROM stud_award_type sat
                                    WHERE UPPER (sat.loan_non_loan_fee) =
                                                                        'LOAN');

      io_cursor := loan_tot_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END get_loan_total_dets;

   PROCEDURE get_awards_paid_out (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          award_payment_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      awards_paid_cursor   award_payment_cursor;
      award_count          NUMBER (4);
   BEGIN
      /*SELECT COUNT (*)
        INTO award_count
        FROM award aw, stud_award_type sap, award_instalment ai
       WHERE aw.stud_crse_year_id = stud_crse_year_id_in
         AND aw.stud_award_type = sap.stud_award_type
         AND ai.award_id = aw.award_id
         AND UPPER (sap.loan_non_loan_fee) = UPPER ('non-Loan')
         AND ai.payment_status = 'S'
         AND ai.returned = 'N';

      IF award_count > 0
      THEN*/
      OPEN awards_paid_cursor FOR
         SELECT   aw.award_type_descript, SUM (ai.amount) AS amount_paid
             FROM award aw, stud_award_type sap, award_instalment ai
            WHERE aw.stud_crse_year_id = stud_crse_year_id_in
              AND aw.stud_award_type = sap.stud_award_type
              AND ai.award_id = aw.award_id
              AND UPPER (sap.loan_non_loan_fee) = UPPER ('non-Loan')
              AND ai.payment_status = 'S'
              AND ai.returned = 'N'
         GROUP BY aw.award_type_descript;

      -- ELSE
      --       OPEN awards_paid_cursor FOR
      --          SELECT '' AS award_type_descript, 0 AS amount_paid
      --            FROM DUAL;
        -- END IF;
      io_cursor := awards_paid_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END get_awards_paid_out;
END pk_student_snapshot_report;
/
