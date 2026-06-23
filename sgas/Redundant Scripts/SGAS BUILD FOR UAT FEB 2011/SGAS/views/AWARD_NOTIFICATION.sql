-- AWARD_NOTIFICATION.sql
--
-- Description: This script contains 4 database views for the StEPS Award Notifications.
--              One master/parent record view is for student data (vu_award_notification_stud)
--              There are detail/child record views for award data (vu_award_notification_award) as many award types per student;
--                                                  for unpaid instalments (vu_award_notification_unpaid);
--                                                + for paid instalments (vu_awawrd_notification_paid).
--
-- Author R Hunter (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      01.08.09    R HUNTER                Initial Version.
-- 2.0      27.10.09    R HUNTER                Fix stud view for defects 223 + 225
-- 3.0      28.10.09	R Hunter                Fix remarks as per func spec for defects 244
-- 4.0      01.11.09    R HUNTER                Fix unpaid view for defect 212 outer join needed on campus for nmsb
-- 5.0      03.11.09    R HUNTER                Fix stud view remark 11 for defect #244, added dearing = G
-- 6.0      16.11.09    R HUNTER                Fix stud view defect for #287 only pick up records where stud_crse_year.SAL_DEST = 1 (normal)
-- 7.0      10.02.10    P HUGHES                Fix for remark 1 which was missing check for P60 and SCHED_E_REQ documents 
-- 8.0      15.02.10    P HUGHES                Fix for remarks 3 and 4 to NVL figures as if NULLS the conditions do not occur.
-- 9.0      16.02.10    P HUGHES                Fix to remark 5 wording and logic to include scheme_type check.
-- 1.0      16.11.10    P HUGHES                Added in suspend flags
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date: $
-- $Revision: $


CREATE OR REPLACE VIEW vu_award_notification_stud
AS
   (SELECT UNIQUE stcy.stud_crse_year_id, st.title, st.initials, st.forenames,
                  st.surname, sha.house_no_name AS house_no_name,
                  sha.post_code AS post_code, sha.addr_l1 AS address_line1,
                  sha.addr_l2 AS address_line2, sha.addr_l3 AS address_line3,
                  sha.addr_l4 AS address_line4, sha.mailsort AS mailsort,
                  st.stud_ref_no, st.scottish_cand slc_ref_number,
                  st.overpayment, st.snb_overpayment, st.nom_name,
                  st.account_no, st.sort_code, st.build_soc_no, st.ni_no,
                  stcy.ROWID row_id, stcy.inst_code, stcy.inst_name,
                  stcy.crse_code, stcy.crse_name, stcy.crse_year_no,
                  stcy.parent_contrib_exempt, stcy.corres_dest,
                  stcy.provisional_case, stcy.award, stcy.crse_year_id,
                  stcy.scheme_type, stcy.dearing, stcy.req_dup,
                  stcy.independent,
                  NVL (stcy.due_ysb_yso_ind, 'N') due_ysb_yso_ind,
                  stcy.erasmus, stcy.paid_sandwich, stcy.unpaid_sandwich,
                  NVL (stcy.parent_cont, 0) parent_cont,
                  NVL (stcy.spouse_cont, 0) spouse_cont,
                  NVL (stcy.stud_cont, 0) stud_cont,
                  NVL (stcy.sponsor_cont, 0) sponsor_cont,
                  NVL (stcy.resid_par_cont, 0) resid_par_cont,
                  NVL (stcy.resid_spouse_cont, 0) resid_spouse_cont,
                  NVL (stcy.resid_stud_cont, 0) resid_stud_cont,
                  NVL (stcy.resid_sponsor_cont, 0) resid_sponsor_cont,
                  NVL (stcy.tot_ja_studs_reg, 0) tot_ja_studs_reg,
                  stcy.remark, stcy.fee_loan_given, stcy.self_funding,
                  stcy.loan_given monthly_payments, sts.ben1_id, sts.ben2_id,
                  sts.session_code, sts.ja_case, sts.ja_case_id,
                  ja.no_saas_students, ja.no_non_saas_children,
                  NVL (sts.ge_liability, 'N') ge_liability,
                  sts.emp_login_name, sha.out_uk,
                  CASE
                     WHEN (    stcy.provisional_case = 'Y'
                           AND stcy.scheme_type IN ('U', 'P') )
                        THEN 'Y'
                     ELSE 'N'
                  END AS rem1,
                  CASE
                     WHEN (stcy.scheme_type IN ('U', 'P'))
                        THEN 'Y'
                     ELSE 'N'
                  END AS rem2,                                  -- defect #244
                  CASE
                     WHEN (    sts.ja_case = 'Y'
                           AND (NVL(ja.no_saas_students,0) + NVL(ja.no_non_saas_children,0) =
                                                         NVL(stcy.tot_ja_studs_reg,0)
                               )
                          )
                        THEN 'Y'
                     ELSE 'N'
                  END AS rem3,                                  -- defect #223
                  CASE
                     WHEN (    sts.ja_case = 'Y'
                           AND (NVL(ja.no_saas_students,0) + NVL(ja.no_non_saas_children,0) <>
                                                         NVL(stcy.tot_ja_studs_reg,0)
                               )
                          )
                        THEN 'Y'
                     ELSE 'N'
                  END AS rem4,                                   -- defect 244
                  CASE
                     WHEN ((st.overpayment > 0) AND (stcy.scheme_type <> 'B'))
                        THEN 'Y'
                     WHEN ((st.snb_overpayment > 0) AND (stcy.scheme_type = 'B'))
                        THEN 'Y'
                     ELSE 'N'
                  END AS rem5,                                   --DEFECT #225
                  CASE
                     WHEN (stcy.award = 'D')
                        THEN 'Y'
                     ELSE 'N'
                  END AS rem6,
                  CASE
                     WHEN (stcy.award = 'C')
                        THEN 'Y'
                     ELSE 'N'
                  END AS rem7,
                  CASE
                     WHEN (    stcy.scheme_type IN ('U', 'P')
                           AND stcy.award NOT IN ('A', 'C', 'D')
                           AND ((NVL(stcy.resid_par_cont,0) + NVL(stcy.resid_stud_cont,0)) >
                                                                             0
                               )
                          )
                        THEN 'Y'
                     ELSE 'N'
                  END AS rem8,
                  CASE
                     WHEN (   stcy.dearing IN ('B', 'E')
                              AND stcy.erasmus = 'Y'
                           OR stcy.paid_sandwich = 'Y'
                           OR stcy.unpaid_sandwich = 'Y'
                          )
                        THEN 'Y'
                     ELSE 'N'
                  END AS rem9,
                  CASE
                     WHEN (    st.ni_no IS NULL
                           AND stcy.dearing = 'G'
                           AND stcy.fee_loan_given = 'C'
                          )
                        THEN 'Y'
                     ELSE 'N'
                  END AS rem10,
                  CASE
                     WHEN (fee_loan_given = 'E' AND stcy.dearing = 'G'
                          )
                        THEN 'Y'
                     ELSE 'N'
                  END AS rem11,
                  CASE
                     WHEN (stcy.dearing = 'F' AND stcy.self_funding = 'Y'
                          )
                        THEN 'Y'
                     ELSE 'N'
                  END AS rem12,
                  'Y' AS rem13
             FROM stud_crse_year stcy,
                  stud_session sts,
                  stud st,
                  stud_home_addr sha,
                  stud_award_type sat,
                  award a,
                  ja_case ja
            WHERE st.stud_ref_no = sts.stud_ref_no
              AND sts.stud_session_id = stcy.stud_session_id
              AND stcy.latest_crse_ind = 'Y'
              AND stcy.sal_sent = 'N'
              AND sts.session_suspend = 'N'
              AND st.stud_suspend = 'N'
              AND stcy.crse_suspend = 'N'
              AND stcy.sal_dest = '1'                                 --normal
              AND a.stud_crse_year_id = stcy.stud_crse_year_id
              AND a.stud_award_type = sat.stud_award_type
              AND stcy.stud_ref_no = sha.stud_ref_no
              AND sha.end_date IS NULL
              AND sts.ja_case_id = ja.ja_case_id(+));



CREATE OR REPLACE VIEW vu_award_notification_award
AS
   (SELECT a.stud_crse_year_id, a.award_id, a.stud_award_type, a.award_src,
           UPPER (a.award_type_descript) award_type_desc,
           LEAST (a.amount, a.net_amount) amount,
           (SELECT   award.net_amount
                   - award.overpayment_amount
              FROM award
             WHERE a.award_id = award.award_id
               AND award.award_src = 'T'
               AND award.amount > 0
               AND award.award_id IN (
                                     SELECT award_id
                                       FROM award_instalment
                                      WHERE NVL (fee_loan_instalment, 'N') =
                                                                           'N'))
                                                            tuition_fees_saas,
           (SELECT SUM (award.contrib_amount + award.recovered_amount
                       )
              FROM award
             WHERE a.award_id = award.award_id
               AND award.award_src = 'T'
               AND award.amount > 0
               AND award.award_id IN (
                                     SELECT award_id
                                       FROM award_instalment
                                      WHERE NVL (fee_loan_instalment, 'N') =
                                                                           'N'))
                                                            tuition_fees_stud,
           (SELECT award.net_amount - award.overpayment_amount
              FROM award
             WHERE a.award_id = award.award_id
               AND award.award_src = 'T'
               AND award.amount > 0
               AND award.award_id IN (
                                     SELECT award_id
                                       FROM award_instalment
                                      WHERE NVL (fee_loan_instalment, 'N') =
                                                                           'Y'))
                                                                loan_for_fees,
           sat.stud_award_type_id, sat.loan_non_loan_fee,
           sat.show_on_an_payments
      FROM award a, stud_award_type sat
     WHERE a.stud_award_type = sat.stud_award_type);


CREATE OR REPLACE VIEW vu_award_notification_unpaid
AS
   (SELECT   a.stud_crse_year_id, awi.payment_due_date, awi.method,
             DECODE (awi.payee, 'N', 'N', awi.payment_addr) payment_addr,
             awi.campus_id, campus_bank.NAME campus_name,
             SUM (awi.net_amount) sum_net_amount, awi.payment_status,
             awi.returned, awi.recalc, stud_bank.account_no stud_acc_no,
             stud_bank.sort_code stud_sort,
             campus_bank.account_no camp_acc_no,
             campus_bank.bank_sort_code camp_sort, awi.payee,
             sat.stud_award_type_id, sat.loan_non_loan_fee,
             sat.show_on_an_payments
        FROM award a,
             award_instalment awi,
             (SELECT x.account_no, x.sort_code, x.stud_ref_no
                FROM stud x) stud_bank,
             (SELECT y.bank_sort_code, y.account_no, y.campus_id, y.NAME
                FROM campus y) campus_bank,
             stud_award_type sat
       WHERE awi.award_id = a.award_id
         AND a.stud_ref_no = stud_bank.stud_ref_no
         AND awi.campus_id = campus_bank.campus_id(+)
         AND (   (awi.returned = 'N' AND awi.recalc = 'N'
                  AND awi.reissue = 'N'
                 )
              OR (    awi.install_type = 'AN'
                  AND awi.returned = 'Y'
                  AND awi.recalc = 'N'
                 )
              OR (    awi.install_type = 'AN'
                  AND awi.returned = 'N'
                  AND awi.recalc = 'N'
                 )
              OR (    awi.install_type = 'MN'
                  AND awi.returned = 'Y'
                  AND awi.recalc = 'N'
                  AND awi.reissue = 'Y'
                 )
             )
         AND a.stud_award_type = sat.stud_award_type
    GROUP BY payment_due_date,
             method,
             DECODE (awi.payee, 'N', 'N', awi.payment_addr),
             awi.campus_id,
             a.stud_crse_year_id,
             awi.payment_status,
             awi.returned,
             awi.recalc,
             stud_bank.account_no,
             stud_bank.sort_code,
             campus_bank.account_no,
             campus_bank.bank_sort_code,
             awi.payee,
             campus_bank.NAME,
             sat.stud_award_type_id,
             sat.loan_non_loan_fee,
             sat.show_on_an_payments);


CREATE OR REPLACE VIEW vu_award_notification_paid
AS
   (SELECT   a.stud_crse_year_id, sp.dpp_payment_date, awi.method,
             DECODE (awi.payee, 'N', 'N', awi.payment_addr) payment_addr,
             sp.dpp_payee, sp.dpp_payee_bank_account,
             sp.dpp_payee_bank_sort_code, sp.dpp_build_soc_roll_no,
             sp.dpp_source_ref, SUM (awi.net_amount) sum_net_amount,
             awi.payment_status, awi.returned, awi.recalc, awi.payee,
             y.NAME campus_name, sat.stud_award_type_id,
             sat.loan_non_loan_fee, sat.show_on_an_payments
        FROM award a,
             award_instalment awi,
             scoap_payments sp,
             campus y,
             stud_award_type sat
       WHERE awi.award_id = a.award_id
         AND (   awi.payment_status IS NULL
              OR (awi.returned = 'Y' AND awi.recalc = 'N')
             )
         AND a.stud_award_type = sat.stud_award_type
         AND awi.batch_ref = sp.dpp_batch_ref
         AND a.stud_crse_year_id = sp.dpp_our_ref2
         AND awi.payment_id = sp.dpp_payment_id
         AND awi.campus_id = y.campus_id
    GROUP BY dpp_payment_date,
             method,
             DECODE (awi.payee, 'N', 'N', awi.payment_addr),
             dpp_payee,
             dpp_payee_bank_account,
             dpp_payee_bank_sort_code,
             dpp_build_soc_roll_no,
             dpp_source_ref,
             a.stud_crse_year_id,
             awi.payment_status,
             awi.returned,
             awi.recalc,
             awi.payee,
             y.NAME,
             sat.stud_award_type_id,
             sat.loan_non_loan_fee,
             sat.show_on_an_payments);
