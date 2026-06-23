CREATE OR REPLACE PACKAGE SGAS.pop_m263
IS
--
-- SCCS IDENTIFICATION STRING
-- ==========================
-- @(#) pop_m263_s.sql 05/14/99 10:27:12 1.2@(#)
--
-- DESCRIPTION
-- ===========
-- Loan Interface File Production
--
/* CHANGE HISTORY
Version Date         Author         Change
1.3?    16/01/2008    R Hunter    Changes to SQL to include STEPS data in the production of SLC 1 and SLC 2 files
                    Changes marked /* RH 16/01/2008 START */ /* RH 16/01/2008 END */
   success                    CONSTANT INTEGER                           := 0;
   failure                    CONSTANT INTEGER                           := 1;
---
   pop_m263_debug_file_handle          UTL_FILE.file_type;
   pop_m263a_debug_file_handle         UTL_FILE.file_type;
   pop_m263b_debug_file_handle         UTL_FILE.file_type;
--
   gs_debug_dirname                    VARCHAR2 (64)                := '/tmp';
--
   db_name                    CONSTANT config_data.item_name%TYPE
                                                                 := 'DB_NAME';
   m263_debug                 CONSTANT config_data.item_name%TYPE
                                                              := 'M263_DEBUG';
   default_m263_debug         CONSTANT config_data.cval%TYPE           := 'Y';
---
   fee_loan_txn_corrected     CONSTANT fee_loan_transaction.status%TYPE
                                                                       := 'C';
   fee_loan_txn_cancelled     CONSTANT fee_loan_transaction.status%TYPE
                                                                       := 'X';
   fee_loan_txn_sent          CONSTANT fee_loan_transaction.status%TYPE
                                                                       := 'S';
--
   stud_loan                  CONSTANT VARCHAR2 (1)                    := 'S';
   fee_loan                   CONSTANT VARCHAR2 (1)                    := 'F';
--
   slc_file_1_id              CONSTANT NUMBER                            := 1;
   slc_file_1_form_type       CONSTANT slc_data.form_type%TYPE        := 'SN';
--
   slc_file_2_id              CONSTANT NUMBER                            := 2;
   slc_file_2_form_type       CONSTANT slc_data.form_type%TYPE        := 'SA';
--
   inst_in_scotland           CONSTANT inst.location_ind%TYPE            := 1;
--
   find_max_flt_scy_details   CONSTANT NUMBER                            := 1;
   find_scy_details           CONSTANT NUMBER                            := 2;

--
-- File 1 fee loan transaction record.
   TYPE flt_for_slc_struct IS RECORD (
      stud_ref_no         fee_loan_transaction.stud_ref_no%TYPE,
      session_code        fee_loan_transaction.session_code%TYPE,
      stud_crse_year_id   fee_loan_transaction.stud_crse_year_id%TYPE,
      status              fee_loan_transaction.status%TYPE
   );

--
   TYPE stud_scy_struct IS RECORD (
      stud_crse_year_id   stud_crse_year.stud_crse_year_id%TYPE,
      stud_ref_no         stud_crse_year.stud_ref_no%TYPE,
      dearing             stud_crse_year.dearing%TYPE,
      inst_code           stud_crse_year.inst_code%TYPE,
      crse_code           stud_crse_year.crse_code%TYPE,
      crse_id             stud_crse_year.crse_id%TYPE,
      session_code        stud_crse_year.session_code%TYPE,
      scheme_type         stud_crse_year.scheme_type%TYPE,
      scottish_cand       stud.scottish_cand%TYPE
   );

--
-- File 2 fee loan transaction record.
   TYPE flt_for_f2_slc_struct IS RECORD (
      stud_ref_no                 fee_loan_transaction.stud_ref_no%TYPE,
      session_code                fee_loan_transaction.session_code%TYPE,
      stud_crse_year_id           fee_loan_transaction.stud_crse_year_id%TYPE,
      txn_interest_accrual_date   fee_loan_transaction.txn_interest_accrual_date%TYPE,
      sum_txns                    fee_loan_transaction.txn_amount%TYPE,
      total_fee_loan_dr           slc_batches.total_fee_loan_dr%TYPE,
      total_fee_loan_cr           slc_batches.total_fee_loan_cr%TYPE
   );

--
-------------------------------
-- File 1 Student loan records.
-------------------------------
   CURSOR c_f1_stud_loans
   IS
      SELECT DISTINCT s.stud_ref_no, scy.stud_crse_year_id, ss.session_code,
                      scy.sal_sent_date, s.scottish_cand, s.title, s.surname,
                      s.forenames, ss.loan_request, s.prev_loan_acc_no,
                      scy.provisional_case, scy.inst_code, scy.crse_code,
                      s.ucas_no, scy.crse_year_id, s.sex, s.dob,
                      s.birth_surname, s.birth_forenames,
                      s.district_birth_cert_issued, scy.crse_year_no,
                      s.birth_country_code, ss.max_loan_requested,
                      scy.hei_payment_route, scy.scheme_type, scy.dearing,
                      scy.crse_id, scy.withdraw_date, scy.application_status,
                      scy.first_slc1_sent_date
                                              --rfc204
                      , ss.stud_hei_bursary_consent, scy.repeat_year,
                      scy.parent_contrib_exempt, ben1_id, ben2_id,
                      DECODE (ss.ben2_id,
                              NULL, DECODE (ss.ben1_id, NULL, 0, 1),
                              DECODE (ss.ben1_id, NULL, 1, 2)
                             ) no_ben,
                      ss.stud_session_id,
                      DECODE (scy.award, 'E', 'N', 'Y') award,
                      scy.household_resid_income, scy.ben1_total_income,
                      scy.ben2_total_income
                                             --rfc204
                                           --rfc226
                      , NULL stud_loan_amount, NULL sosb_amount
                 --rfc226
      FROM            stud_crse_year scy, stud_session ss, award a, stud s
                WHERE ss.stud_ref_no = s.stud_ref_no
                  AND scy.stud_session_id = ss.stud_session_id
                  AND a.stud_crse_year_id = scy.stud_crse_year_id
                  AND award_types.loan_award (a.stud_award_type) = 'Y'
                  AND slc_util.loan_bearing (scy.stud_crse_year_id) = 'Y'
                  AND scy.sal_sent = 'Y'
                  AND scy.slc1_sent = 'N'
                  AND scy.sal_dest IN ('1', 'R', 'A', 'M')
                  AND (s.suspend_payment = 'N' OR s.suspend_payment IS NULL)
                  AND scy.latest_crse_ind = 'Y'
                  AND (   scy.slc1_status NOT IN ('E', 'R')
                       OR scy.slc1_status IS NULL
                      )
      UNION
      SELECT DISTINCT s.stud_ref_no, scy.stud_crse_year_id, ss.session_code,
                      scy.sal_sent_date, s.scottish_cand, s.title, s.surname,
                      s.forenames, ss.loan_request, s.prev_loan_acc_no,
                      scy.provisional_case, scy.inst_code, scy.crse_code,
                      s.ucas_no, scy.crse_year_id, s.sex, s.dob,
                      s.birth_surname, s.birth_forenames,
                      s.district_birth_cert_issued, scy.crse_year_no,
                      s.birth_country_code, ss.max_loan_requested,
                      scy.hei_payment_route, scy.scheme_type, scy.dearing,
                      scy.crse_id, scy.withdraw_date, scy.application_status,
                      scy.first_slc1_sent_date
                                              --rfc204
                      , ss.stud_hei_bursary_consent, scy.repeat_year,
                      scy.parent_contrib_exempt, ben1_id, ben2_id,
                      DECODE (ss.ben2_id,
                              NULL, DECODE (ss.ben1_id, NULL, 0, 1),
                              DECODE (ss.ben1_id, NULL, 1, 2)
                             ) no_ben,
                      ss.stud_session_id,
                      DECODE (scy.award, 'E', 'N', 'Y') award,
                      scy.household_resid_income, scy.ben1_total_income,
                      scy.ben2_total_income
                                             --rfc204
                                           --rfc226
                      , NULL stud_loan_amount, NULL sosb_amount
                 --rfc226
      FROM            stud_crse_year scy, stud_session ss, stud s
                WHERE ss.stud_ref_no = s.stud_ref_no
                  AND scy.stud_session_id = ss.stud_session_id
                  AND scy.application_status = 'A'
                  AND scy.first_slc1_sent_date IS NOT NULL
                  AND slc_util.loan_bearing (scy.stud_crse_year_id) = 'Y'
                  AND scy.sal_sent = 'Y'
                  AND scy.slc1_sent = 'N'
                  AND scy.sal_dest IN ('1', 'R', 'A', 'M')
                  AND (s.suspend_payment = 'N' OR s.suspend_payment IS NULL)
                  AND scy.latest_crse_ind = 'Y'
                  AND (   scy.slc1_status NOT IN ('E', 'R')
                       OR scy.slc1_status IS NULL
                      )
      /* RH 16/01/2008 START */
      UNION
      SELECT DISTINCT s.stud_ref_no, scy.stud_crse_year_id, ss.session_code,
                      scy.sal_sent_date, s.scottish_cand, s.title, s.surname,
                      s.forenames, ss.loan_request, s.prev_loan_acc_no,
                      scy.provisional_case, scy.inst_code, scy.crse_code,
                      s.ucas_no, scy.crse_year_id, s.sex, s.dob,
                      s.birth_surname, s.birth_forenames,
                      s.district_birth_cert_issued, scy.crse_year_no,
                      s.birth_country_code, ss.max_loan_requested,
                      scy.hei_payment_route, scy.scheme_type, scy.dearing,
                      scy.crse_id, scy.withdraw_date, scy.application_status,
                      scy.first_slc1_sent_date, ss.stud_hei_bursary_consent,
                      scy.repeat_year, scy.parent_contrib_exempt, ben1_id,
                      ben2_id,
                      DECODE (ss.ben2_id,
                              NULL, DECODE (ss.ben1_id, NULL, 0, 1),
                              DECODE (ss.ben1_id, NULL, 1, 2)
                             ) no_ben,
                      ss.stud_session_id,
                      DECODE (scy.award, 'E', 'N', 'Y') award,
                      scy.household_resid_income, scy.ben1_total_income,
                      scy.ben2_total_income, NULL stud_loan_amount,
                      NULL sosb_amount
                 FROM steps_stud_crse_year scy,
                      steps_stud_session ss,
                      steps_award a,
                      steps_stud s
                WHERE ss.stud_ref_no = s.stud_ref_no
                  AND scy.stud_session_id = ss.stud_session_id
                  AND a.stud_crse_year_id = scy.stud_crse_year_id
                  AND a.stud_award_type IN (
                                       SELECT stud_award_type
                                         FROM stud_award_type@stepssit.world
                                        WHERE loan_non_loan_fee = 'Loan')
                  AND slc_util.loan_bearing (scy.stud_crse_year_id) = 'Y'
                  AND scy.sal_sent = 'Y'
                  AND scy.slc1_sent = 'N'
                  AND scy.sal_dest IN ('1', 'R', 'A', 'M')
                  AND (s.suspend_payment = 'N' OR s.suspend_payment IS NULL)
                  AND scy.latest_crse_ind = 'Y'
                  AND (   scy.slc1_status NOT IN ('E', 'R')
                       OR scy.slc1_status IS NULL
                      )
      UNION
      SELECT DISTINCT s.stud_ref_no, scy.stud_crse_year_id, ss.session_code,
                      scy.sal_sent_date, s.scottish_cand, s.title, s.surname,
                      s.forenames, ss.loan_request, s.prev_loan_acc_no,
                      scy.provisional_case, scy.inst_code, scy.crse_code,
                      s.ucas_no, scy.crse_year_id, s.sex, s.dob,
                      s.birth_surname, s.birth_forenames,
                      s.district_birth_cert_issued, scy.crse_year_no,
                      s.birth_country_code, ss.max_loan_requested,
                      scy.hei_payment_route, scy.scheme_type, scy.dearing,
                      scy.crse_id, scy.withdraw_date, scy.application_status,
                      scy.first_slc1_sent_date, ss.stud_hei_bursary_consent,
                      scy.repeat_year, scy.parent_contrib_exempt, ben1_id,
                      ben2_id,
                      DECODE (ss.ben2_id,
                              NULL, DECODE (ss.ben1_id, NULL, 0, 1),
                              DECODE (ss.ben1_id, NULL, 1, 2)
                             ) no_ben,
                      ss.stud_session_id,
                      DECODE (scy.award, 'E', 'N', 'Y') award,
                      scy.household_resid_income, scy.ben1_total_income,
                      scy.ben2_total_income, NULL stud_loan_amount,
                      NULL sosb_amount
                 FROM steps_stud_crse_year scy,
                      steps_stud_session ss,
                      steps_stud s
                WHERE ss.stud_ref_no = s.stud_ref_no
                  AND scy.stud_session_id = ss.stud_session_id
                  AND scy.application_status = 'A'
                  AND scy.first_slc1_sent_date IS NOT NULL
                  AND slc_util.loan_bearing (scy.stud_crse_year_id) = 'Y'
                  AND scy.sal_sent = 'Y'
                  AND scy.slc1_sent = 'N'
                  AND scy.sal_dest IN ('1', 'R', 'A', 'M')
                  AND (s.suspend_payment = 'N' OR s.suspend_payment IS NULL)
                  AND scy.latest_crse_ind = 'Y'
                  AND (   scy.slc1_status NOT IN ('E', 'R')
                       OR scy.slc1_status IS NULL
                      );

   /* RH 16/01/2008 END */

   --
--------------------------------------
-- File 1 Fee Loan Transaction Cursor
--------------------------------------
   CURSOR c_flt_for_slc
   IS
      SELECT   fl.stud_ref_no, fl.session_code
          FROM fee_loan_transaction fl, stud_session ss
         WHERE (    fl.session_code >= 2006
                AND fl.session_code = ss.session_code
                AND fl.stud_ref_no = ss.stud_ref_no
               )
--
           AND                     -- For new or corrected flts send a file 1.
               (   (    NVL (fl.status, 'Z') IN
                           ('Z', 'C')
                                   -- flt recs not sent or sent and corrected.
                    AND NVL (ss.slc1_fl_sent, 'N') =
                                     'N'
                                        -- file 1 not sent or sent and failed.
                    -- and no other flts are in error or rejected (file 2 to be sent or has gone ok).
                    AND NOT EXISTS (
                           SELECT '1'
                             FROM fee_loan_transaction flt
                            WHERE fl.stud_ref_no = flt.stud_ref_no
                              AND fl.session_code = flt.session_code
                              AND NVL (flt.status, 'Z') IN ('E', 'R'))
                   )
--
                OR               -- For any previously failed file 1 students.
                   (    NVL (ss.slc1_fl_sent, 'Y') =
                                           'N'
                                              -- file 1 has previously failed.
                    AND EXISTS (
                           SELECT '1'
                             FROM fee_loan_transaction flt
                            WHERE fl.stud_ref_no = flt.stud_ref_no
                              AND fl.session_code = flt.session_code
                              AND slc2_file_date IS NOT NULL
                                                      -- file 2 has been sent.
                              AND NVL (fl.status, 'Z') <> 'R')
                   )
               )                    -- flts are new or have not been rejected.
--
      GROUP BY fl.stud_ref_no, fl.session_code;

--
---------------------------------------
-- File 1 Fee Loan Only Students Cursor
---------------------------------------
   CURSOR c_fee_loan_only
   IS
      SELECT DISTINCT ss.stud_ref_no, ss.session_code, scy.stud_crse_year_id
                 FROM stud_crse_year scy, stud_session ss
                WHERE ss.session_code >= 2006
                  AND scy.stud_session_id = ss.stud_session_id
                  AND scy.stud_ref_no = ss.stud_ref_no
                  AND scy.dearing = 'G'
                  AND scy.latest_crse_ind = 'Y'
                  AND NVL (scy.sal_sent, 'N') =
                                           'Y'
                                              --  LOA has been sent to student
                  AND scy.sal_sent_date IS NOT NULL
                                              --  LOA has been sent to student
                  AND NVL (ss.slc1_fl_sent, 'Z') =
                                              'N'
                                                 -- select only aokd students.
                  AND ss.slc1_fl_sent_date IS NULL
             -- student has never had a file 1 fee loan record sent to the SLC
                  AND scy.slc1_sent_date IS NULL;      -- file 1 not yet sent.

--
---------------------
-- Stud home address.
---------------------
   CURSOR c_f1_sha (param_stud_ref_no stud_home_addr.stud_ref_no%TYPE)
   IS
      SELECT SUBSTR (house_no_name || ' ' || addr_l1, 1, 60) addr_l1,
             SUBSTR (addr_l2, 1, 60) addr_l2, addr_l3, addr_l4, post_code,
             tele_no
        FROM stud_home_addr
       WHERE stud_ref_no = param_stud_ref_no AND end_date IS NULL
      /* RH 16/01/2008 START */
      UNION
      SELECT SUBSTR (house_no_name || ' ' || addr_l1, 1, 60) addr_l1,
             SUBSTR (addr_l2, 1, 60) addr_l2, addr_l3, addr_l4, post_code,
             tele_no
        FROM steps_stud_home_addr
       WHERE stud_ref_no = param_stud_ref_no AND end_date IS NULL;

   /* RH 16/01/2008 END */

   -----------
-- Country.
-----------
   CURSOR c_f1_country (param_country_code country.country_code%TYPE)
   IS
      SELECT SUBSTR (long_name, 1, 25) birth_country
        FROM country
       WHERE country_code = param_country_code;

--
-------------------------
-- Max file size allowed.
-------------------------
   CURSOR c_f1_2_max_size
   IS
      SELECT nval
        FROM config_data
       WHERE item_name = 'SLC_MAX_FILESIZE';

--
---------------------
-- Benefactor income.
---------------------
   CURSOR cur_get_ben_con (cp_ben_id VARCHAR2, cp_session_code NUMBER)
   IS
      SELECT NVL (ben_hei_bursary_consent, 'N')
        FROM benefactor_income
       WHERE ben_id = cp_ben_id AND session_code = cp_session_code
      /* RH 16/01/2008 START */
      UNION
      SELECT NVL (ben_hei_bursary_consent, 'N')
        FROM steps_benefactor_income
       WHERE ben_id = cp_ben_id AND session_code = cp_session_code;

     /* RH 16/01/2008 END */
--
-- -------------------------
-- File 2 for Student Loans.
-- ------------------------
   CURSOR c_f2_stud_loans
   IS
      SELECT DISTINCT s.stud_ref_no, scy.stud_crse_year_id, ss.session_code,
                      scy.sal_sent_date, s.scottish_cand, s.title, s.surname,
                      s.forenames, ss.loan_request, scy.crse_code,
                      scy.inst_code, s.addr_corr_flag, s.prev_loan_acc_no,
                      s.sort_code, s.account_no, s.build_soc_no,
                      s.bankrupt_flag, s.ni_no, ss.loan_declaration_date,
                      scy.corres_dest, ss.max_loan_requested, scy.scheme_type,
                      scy.dearing, scy.crse_id, ss.fee_loan_declaration_date,
                      ss.reason_no_nino
                 FROM stud_crse_year scy, stud_session ss, award a, stud s
                WHERE ss.stud_ref_no = s.stud_ref_no
                  AND scy.stud_session_id = ss.stud_session_id
                  AND a.stud_crse_year_id = scy.stud_crse_year_id
                  AND award_types.loan_award (a.stud_award_type) = 'Y'
                  AND slc_util.loan_bearing (scy.stud_crse_year_id) = 'Y'
                  AND scy.withdraw_date IS NULL
                  AND scy.slc2_sent = 'N'
                  AND scy.sal_sent = 'Y'
                  AND scy.slc1_sent = 'Y'
                  AND scy.sal_dest IN ('1', 'R', 'A', 'M')
                  AND scy.dearing <> 'O'
                  AND (s.suspend_payment = 'N' OR s.suspend_payment IS NULL)
                  AND scy.latest_crse_ind = 'Y'
                  AND (scy.slc2_status NOT IN ('E', 'R')
                       OR slc2_status IS NULL
                      )
                  AND (   (    (ss.loan_request != 0
                                OR ss.loan_request IS NULL
                               )
                           AND a.net_amount != 0
                          )
                       OR (ss.loan_request = 0 AND a.net_amount != 0)
                      )
      /* RH 16/01/2008 START */
      UNION
      SELECT DISTINCT s.stud_ref_no, scy.stud_crse_year_id, ss.session_code,
                      scy.sal_sent_date, s.scottish_cand, s.title, s.surname,
                      s.forenames, ss.loan_request, scy.crse_code,
                      scy.inst_code, s.addr_corr_flag, s.prev_loan_acc_no,
                      s.sort_code, s.account_no, s.build_soc_no,
                      s.bankrupt_flag, s.ni_no, ss.loan_declaration_date,
                      scy.corres_dest, ss.max_loan_requested, scy.scheme_type,
                      scy.dearing, scy.crse_id, ss.fee_loan_declaration_date,
                      ss.reason_no_nino
                 FROM steps_stud_crse_year scy,
                      steps_stud_session ss,
                      steps_award a,
                      steps_stud s
                WHERE ss.stud_ref_no = s.stud_ref_no
                  AND scy.stud_session_id = ss.stud_session_id
                  AND a.stud_crse_year_id = scy.stud_crse_year_id
                  AND a.stud_award_type IN (
                                       SELECT stud_award_type
                                         FROM stud_award_type@stepssit.world
                                        WHERE loan_non_loan_fee = 'Loan')
                  AND slc_util.loan_bearing (scy.stud_crse_year_id) = 'Y'
                  AND scy.withdraw_date IS NULL
                  AND scy.slc2_sent = 'N'
                  AND scy.sal_sent = 'Y'
                  AND scy.slc1_sent = 'Y'
                  AND scy.sal_dest IN ('1', 'R', 'A', 'M')
                  AND scy.dearing <> 'O'
                  AND (s.suspend_payment = 'N' OR s.suspend_payment IS NULL)
                  AND scy.latest_crse_ind = 'Y'
                  AND (scy.slc2_status NOT IN ('E', 'R')
                       OR slc2_status IS NULL
                      )
                  AND (   (    (ss.loan_request != 0
                                OR ss.loan_request IS NULL
                               )
                           AND a.net_amount != 0
                          )
                       OR (ss.loan_request = 0 AND a.net_amount != 0)
                      );

   /* RH 16/01/2008 END */

   --------------------------------
-- File 2 Fee loan Transactions
-------------------------------
   CURSOR c_f2_flt
   IS
      SELECT   stud_ref_no, session_code, txn_interest_accrual_date,
               (  SUM (DECODE (txn_dc_flg, 'D', txn_amount, 0))
                - SUM (DECODE (txn_dc_flg, 'C', txn_amount, 0))
               )
          --SUM(DECODE(txn_dc_flg,'D',txn_amount,0)), SUM(DECODE(txn_dc_flg,'C',txn_amount,0))
      FROM     fee_loan_transaction flt1
         WHERE flt1.session_code >= 2006
           AND NVL (flt1.status, 'Z') IN
                  ('Z', 'C')
-- record has not been sent before or has been corrected after a failure and awaiting re-submission
           AND NOT EXISTS (
                  SELECT '1'
                    FROM fee_loan_transaction flt2
                   WHERE flt1.stud_ref_no = flt2.stud_ref_no
                     AND flt1.session_code = flt2.session_code
                     AND NVL (flt2.status, 'Z') IN ('E', 'R'))
                                -- no records for session in error or rejected
      GROUP BY stud_ref_no, session_code, txn_interest_accrual_date;

--
---------------------------
-- File 2 Stud home address
---------------------------
   CURSOR c_f2_sha (param_stud_ref_no stud_home_addr.stud_ref_no%TYPE)
   IS
      SELECT house_no_name || ' ' || addr_l1 addr_l1, addr_l2, addr_l3,
             addr_l4, post_code, tele_no
        FROM stud_home_addr
       WHERE stud_ref_no = param_stud_ref_no AND end_date IS NULL
      /* RH 16/01/2008 START */
      UNION
      SELECT house_no_name || ' ' || addr_l1 addr_l1, addr_l2, addr_l3,
             addr_l4, post_code, tele_no
        FROM steps_stud_home_addr
       WHERE stud_ref_no = param_stud_ref_no AND end_date IS NULL;

   /* RH 16/01/2008 END */

   ---------------------------
-- File 2 Stud term address
---------------------------
   CURSOR c_f2_sta (param_stud_ref_no stud_term_addr.stud_ref_no%TYPE)
   IS
      SELECT house_no_name || ' ' || addr_l1 addr_l1, addr_l2, addr_l3,
             addr_l4, post_code, tele_no
        FROM stud_term_addr
       WHERE stud_ref_no = param_stud_ref_no AND end_date IS NULL
      /* RH 16/01/2008 START */
      UNION
      SELECT house_no_name || ' ' || addr_l1 addr_l1, addr_l2, addr_l3,
             addr_l4, post_code, tele_no
        FROM steps_stud_term_addr
       WHERE stud_ref_no = param_stud_ref_no AND end_date IS NULL;

   /* RH 16/01/2008 END */

   ------------------------------------
-- File 2 First Stud contact details
------------------------------------
   CURSOR c_f2_scd_1 (param_stud_ref_no stud_cont_details.stud_ref_no%TYPE)
   IS
      SELECT cont_name, cont_postcode, cont_addr1, cont_addr2, cont_addr3,
             cont_tel_no, cont_rel_code
        FROM stud_cont_details
       WHERE stud_ref_no = param_stud_ref_no AND contact_ind = 1
      /* RH 16/01/2008 START */
      UNION
      SELECT cont_name, cont_postcode, cont_addr1, cont_addr2, cont_addr3,
             cont_tel_no, cont_rel_code
        FROM steps_stud_cont_details
       WHERE stud_ref_no = param_stud_ref_no AND contact_ind = 1;

   /* RH 16/01/2008 END */

   -------------------------------------
-- File 2 Second Stud contact details
-------------------------------------
   CURSOR c_f2_scd_2 (param_stud_ref_no stud_cont_details.stud_ref_no%TYPE)
   IS
      SELECT cont_name, cont_postcode, cont_addr1, cont_addr2, cont_addr3,
             cont_tel_no
        FROM stud_cont_details
       WHERE stud_ref_no = param_stud_ref_no AND contact_ind = 2
      /* RH 16/01/2008 START */
      UNION
      SELECT cont_name, cont_postcode, cont_addr1, cont_addr2, cont_addr3,
             cont_tel_no
        FROM steps_stud_cont_details
       WHERE stud_ref_no = param_stud_ref_no AND contact_ind = 2;

   /* RH 16/01/2008 END */

   ---
------------------------------------
--Cursor added for rfc226 to get award details
------------------------------------
   CURSOR cur_get_award_amount (
      cn_stud_crse_year_id   award.stud_crse_year_id%TYPE,
      cv_award_src           award.award_src%TYPE,
      cv_stud_award_type     award.stud_award_type%TYPE
   )
   IS
      SELECT NVL (amount, 0)
        FROM award
       WHERE (    stud_crse_year_id = cn_stud_crse_year_id
              AND award_src = cv_award_src
              AND stud_award_type IS NULL
             )
          OR (    stud_crse_year_id = cn_stud_crse_year_id
              AND stud_award_type = cv_stud_award_type
             )
--end rfc226

      /* RH 16/01/2008 START */
      UNION
      SELECT NVL (amount, 0)
        FROM steps_award
       WHERE (    stud_crse_year_id = cn_stud_crse_year_id
              AND award_src = cv_award_src
             -- AND stud_award_type IS NULL -- stud_award_type is 'TFEL'in StEPS 
              AND stud_award_type = 'TFEL'
             )
          OR (    stud_crse_year_id = cn_stud_crse_year_id
              AND stud_award_type = cv_stud_award_type
              AND stud_award_type <> 'TFEL' 
             );

   /* RH 16/01/2008 END */

   ---
   FUNCTION updfile1flags (
      p_rep     IN   VARCHAR2,
      p_fname   IN   VARCHAR2,
      p_fdate   IN   DATE
   )
      RETURN INTEGER;

---
   FUNCTION updfile2flags (
      p_rep     IN   VARCHAR2,
      p_fname   IN   VARCHAR2,
      p_fdate   IN   DATE
   )
      RETURN INTEGER;

---
   FUNCTION chkdebugon (
      p_debug_filename   IN       VARCHAR2,
      p_debug_dirname    IN OUT   VARCHAR2,
      p_debug_on         IN OUT   config_data.cval%TYPE,
      p_error_message    IN OUT   VARCHAR
   )
      RETURN BOOLEAN;

---
   FUNCTION updloanflags (
      p_stud_ref_no                 IN       slc_errors.stud_ref_no%TYPE,
      p_session_code                IN       stud_session.session_code%TYPE,
      p_scy_id                      IN       stud_crse_year.stud_crse_year_id%TYPE,
      p_txn_interest_accrual_date   IN       fee_loan_transaction.txn_interest_accrual_date%TYPE,
      p_filename                    IN       slc_data.slc_filename%TYPE,
      p_filedate                    IN       slc_data.slc_file_date%TYPE,
      p_loan_type                   IN       slc_errors.record_type_error%TYPE,
      p_filetype                    IN       slc_errors.slc_file_type%TYPE,
      p_debug_file_handle           IN OUT   UTL_FILE.file_type,
      p_error_message               IN OUT   VARCHAR2
   )
      RETURN BOOLEAN;

--
   FUNCTION chkstudnotinbatch (
      p_fl_only_rec               IN       flt_for_slc_struct,
      p_filename                  IN       slc_data.slc_filename%TYPE,
      p_filedate                  IN       slc_data.slc_file_date%TYPE,
      p_latest_loan_elig_scy_id   IN       slc_data.stud_crse_year_id%TYPE,
      p_rec_type                  IN       slc_data.record_type%TYPE,
      p_sd_recs_exist             IN OUT   BOOLEAN,
      p_debug_file_handle         IN OUT   UTL_FILE.file_type,
      p_error_message             IN OUT   VARCHAR2
   )
      RETURN BOOLEAN;

---
   FUNCTION delslcbatch (
      p_slc_filename        IN       slc_batches.slc_filename%TYPE,
      p_slc_file_date       IN       slc_batches.slc_file_date%TYPE,
      p_debug_file_handle   IN OUT   UTL_FILE.file_type,
      p_error_message       IN OUT   VARCHAR2
   )
      RETURN BOOLEAN;

--
   FUNCTION chkprocstudloans (
      p_slc_filename        IN       slc_data.slc_filename%TYPE,
      p_slc_file_date       IN       slc_data.slc_file_date%TYPE,
      p_form_type           IN       slc_data.form_type%TYPE,
      p_proc_stud_loan      IN OUT   BOOLEAN,
      p_debug_file_handle   IN OUT   UTL_FILE.file_type,
      p_error_message       IN OUT   VARCHAR2
   )
      RETURN BOOLEAN;

--
   FUNCTION findstudloc (
      p_scy_id          IN       stud_crse_year.stud_crse_year_id%TYPE,
      p_stud_ref_no     IN       stud_crse_year.stud_ref_no%TYPE,
      p_session_code    IN       stud_crse_year.session_code%TYPE,
      p_stud_loc_ind    IN OUT   inst.location_ind%TYPE,
      p_error_message   IN OUT   VARCHAR2
   )
      RETURN BOOLEAN;

--
   FUNCTION createfile2 (
      p_f2_flt_rec       IN       flt_for_f2_slc_struct,
      p_r1               IN OUT   c_f2_stud_loans%ROWTYPE,
      p_r2               IN OUT   c_f2_sha%ROWTYPE,
      p_r3               IN OUT   c_f2_sta%ROWTYPE,
      p_r4               IN OUT   c_f2_scd_1%ROWTYPE,
      p_r5               IN OUT   c_f2_scd_2%ROWTYPE,
      p_sd               IN OUT   slc_data%ROWTYPE,
      p_filename         IN       VARCHAR2,
      p_filedate         IN       DATE,
      p_b_record_valid   IN OUT   BOOLEAN,
      p_loan_type        IN       slc_errors.record_type_error%TYPE,
      p_error_message    IN OUT   VARCHAR2
   )
      RETURN BOOLEAN;

--
   FUNCTION totalsessfeeloandebt (
      p_f2_flt_rec      IN       flt_for_f2_slc_struct,
      p_sd              IN OUT   slc_data%ROWTYPE,
      p_error_message   IN OUT   VARCHAR2
   )
      RETURN BOOLEAN;

--
   FUNCTION chkflonly (
      fl_only_rec           IN       flt_for_slc_struct,
      p_fee_loan_only       IN OUT   BOOLEAN,
      p_error_message       IN OUT   VARCHAR2,
      p_debug_file_handle   IN OUT   UTL_FILE.file_type
   )
      RETURN BOOLEAN;

--
   FUNCTION findmaxfltscyid (
      p_flt_for_slc_rec   IN OUT   flt_for_slc_struct,
      p_error_message     IN OUT   VARCHAR2
   )
      RETURN BOOLEAN;

--
   FUNCTION updssflsentflagton (
      p_stud_ref_no     IN       fee_loan_transaction.stud_ref_no%TYPE,
      p_session_code    IN       fee_loan_transaction.session_code%TYPE,
      p_error_message   IN OUT   VARCHAR2
   )
      RETURN BOOLEAN;

--
   FUNCTION updscyflags (
      p_scy_id              IN       stud_crse_year.stud_crse_year_id%TYPE,
      p_file_id             IN       NUMBER,
      p_error_message       IN OUT   VARCHAR2,
      p_debug_file_handle   IN OUT   UTL_FILE.file_type
   )
      RETURN BOOLEAN;

--
   PROCEDURE closelogfile (p_file_handle IN OUT UTL_FILE.file_type);

--
   PROCEDURE writetolog (
      p_file_handle   IN OUT   UTL_FILE.file_type,
      p_msg           IN       VARCHAR2
   );

--
   FUNCTION findfile1studsessscydetails (
      p_scy_id              IN       stud_crse_year.stud_crse_year_id%TYPE,
      p_r1                  IN OUT   c_f1_stud_loans%ROWTYPE,
      p_error_message       IN OUT   VARCHAR2,
      p_debug_file_handle   IN OUT   UTL_FILE.file_type
   )
      RETURN BOOLEAN;

--
   FUNCTION findfile2studsessscydetails (
      p_f2_flt_rec      IN       flt_for_f2_slc_struct,
      p_r1              IN OUT   c_f2_stud_loans%ROWTYPE,
      p_error_message   IN OUT   VARCHAR2
   )
      RETURN BOOLEAN;

--
   FUNCTION readstudscyrec (
      p_flt_for_slc_rec   IN OUT   flt_for_slc_struct,
      p_stud_scy_rec      IN OUT   stud_scy_struct,
      p_error_message     IN OUT   VARCHAR2
   )
      RETURN BOOLEAN;

--
   FUNCTION chkoktosendflt (
      flt_for_slc_rec             IN       flt_for_slc_struct,
      p_latest_loan_elig_scy_id   IN OUT   stud_crse_year.stud_crse_year_id%TYPE,
      p_error_message             IN OUT   VARCHAR2
   )
      RETURN BOOLEAN;

--
   FUNCTION updslcbatches (
      p_filename            IN       VARCHAR2,
      p_filedate            IN       DATE,
      p_number_of_records   IN       NUMBER,
      p_num_stud_loans      IN       slc_batches.student_loan_record_count%TYPE,
      p_num_fee_loans       IN       slc_batches.fee_loan_record_count%TYPE,
      p_sum_dr              IN       slc_batches.total_fee_loan_dr%TYPE,
      p_sum_cr              IN       slc_batches.total_fee_loan_cr%TYPE,
      p_error_message       IN OUT   VARCHAR2,
      p_debug_file_handle   IN OUT   UTL_FILE.file_type
   )
      RETURN BOOLEAN;

--
   FUNCTION setfeeloantxntocancel (
      p_error_message   IN OUT   VARCHAR2,
      p_flt_ctr         IN OUT   NUMBER
   )
      RETURN BOOLEAN;

--
   FUNCTION insfile1slcdata (
      p_r1                  IN OUT   c_f1_stud_loans%ROWTYPE,
      p_r2                  IN OUT   c_f1_sha%ROWTYPE,
      p_r5                  IN OUT   c_f1_country%ROWTYPE,
      p_sd                  IN OUT   slc_data%ROWTYPE,
      p_form_type           IN       slc_data.form_type%TYPE,
      p_error_message       IN OUT   VARCHAR2,
      p_debug_file_handle   IN OUT   UTL_FILE.file_type
   )
      RETURN BOOLEAN;

--
   FUNCTION insfile2slcdata (
      p_r1                  IN OUT   c_f2_stud_loans%ROWTYPE,
      p_r2                  IN OUT   c_f2_sha%ROWTYPE,
      p_r3                  IN OUT   c_f2_sta%ROWTYPE,
      p_r4                  IN OUT   c_f2_scd_1%ROWTYPE,
      p_r5                  IN OUT   c_f2_scd_2%ROWTYPE,
      p_sd                  IN OUT   slc_data%ROWTYPE,
      p_form_type           IN       slc_data.form_type%TYPE,
      p_ins_ok              IN OUT   BOOLEAN,
      p_error_message       IN OUT   VARCHAR2,
      p_debug_file_handle   IN OUT   UTL_FILE.file_type
   )
      RETURN BOOLEAN;

--
   FUNCTION createfile1 (
      p_r1               IN OUT   c_f1_stud_loans%ROWTYPE,
      p_r2               IN OUT   c_f1_sha%ROWTYPE,
      p_r5               IN OUT   c_f1_country%ROWTYPE,
      p_sd               IN OUT   slc_data%ROWTYPE,
      p_filename         IN       VARCHAR2,
      p_filedate         IN       DATE,
      p_b_record_valid   IN OUT   BOOLEAN,
      p_loan_type        IN       slc_errors.record_type_error%TYPE,
      p_error_message    IN OUT   VARCHAR2
   )
      RETURN BOOLEAN;

--
   FUNCTION writesummarydata (
      p_debug_file_handle   IN OUT   UTL_FILE.file_type,
      p_file_type           IN       NUMBER,
      p_filename            IN       slc_data.slc_filename%TYPE,
      p_tot_rec_ctr         IN       NUMBER,
      p_num_filtered        IN       NUMBER,
      p_num_in_err          IN       NUMBER,
      p_num_stud            IN       NUMBER,
      p_num_flt             IN       NUMBER,
      p_num_fl_only         IN       NUMBER,
      p_number_of_records   IN       NUMBER,
      p_sum_dr              IN       NUMBER,
      p_sum_cr              IN       NUMBER,
      p_error_message       IN OUT   VARCHAR2
   )
      RETURN BOOLEAN;

--
   FUNCTION pop_m263 (p_filetype IN NUMBER, p_error_message OUT VARCHAR2)
      RETURN NUMBER;

--
   FUNCTION pop_m263a (
      p_filename        IN       VARCHAR2,
      p_filedate        IN       DATE,
      p_repeat          OUT      BOOLEAN,
      p_error_message   OUT      VARCHAR2
   )
      RETURN NUMBER;

--
   FUNCTION pop_m263b (
      p_filename        IN       VARCHAR2,
      p_filedate        IN       DATE,
      p_repeat          OUT      BOOLEAN,
      p_error_message   OUT      VARCHAR2
   )
      RETURN NUMBER;

--
   FUNCTION pop_m263c (
      p_filename        IN       VARCHAR2,
      p_filedate        IN       DATE,
      p_repeat          OUT      BOOLEAN,
      p_error_message   OUT      VARCHAR2
   )
      RETURN NUMBER;

--
   FUNCTION pop_m263d (
      p_filename            IN       VARCHAR2,
      p_filedate            IN       DATE,
      p_repeat              OUT      BOOLEAN,
      p_error_message       OUT      VARCHAR2,
      p_total_loan_amount   OUT      NUMBER
   )
      RETURN NUMBER;

--
   PROCEDURE pop_m263_error (
      p_filename                 slc_errors.slc_filename%TYPE,
      p_filedate                 slc_errors.slc_file_date%TYPE,
      p_filetype                 slc_errors.slc_file_type%TYPE,
      p_stud_crse_year_id        slc_errors.stud_crse_year_id%TYPE,
      p_stud_ref_no              slc_errors.stud_ref_no%TYPE,
      p_inst_code                slc_errors.inst_code%TYPE,
      p_crse_code                slc_errors.crse_code%TYPE,
      p_crse_id                  crse.crse_id%TYPE,
      p_session_code             slc_errors.session_code%TYPE,
      p_slc_ref_no               slc_errors.slc_ref_no%TYPE,
      p_error_description        slc_errors.error_description%TYPE,
      p_scheme_type              stud_crse_year.scheme_type%TYPE,
      p_dearing                  stud_crse_year.dearing%TYPE,
      p_loan_type           IN   slc_errors.record_type_error%TYPE
   );

--
   FUNCTION pop_m263_postcode (
      p_in_postcode    IN       VARCHAR2,
      p_out_postcode   OUT      VARCHAR2
   )
      RETURN BOOLEAN;
--
END pop_m263;
/
