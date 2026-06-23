CREATE OR REPLACE PACKAGE BODY SGAS.pop_stepsloa
AS
--
-- DESCRIPTION
-- ===========
--
-- Populates the LOA tables for the student award letter report
--
   FUNCTION pop_stepsloa (p_stud_crse_year_id NUMBER, p_post_type VARCHAR2)
      RETURN VARCHAR2
   IS
      -- Constants used throughout the code
      c_style          CONSTANT VARCHAR2 (1)                           := '3';
      c_bacs           CONSTANT VARCHAR2 (1)                           := 'B';
      c_nominee        CONSTANT VARCHAR2 (1)                           := 'N';
      c_campus         CONSTANT VARCHAR2 (1)                           := 'C';
      c_part_time      CONSTANT VARCHAR2 (1)                           := 'O';
      c_calculated     CONSTANT VARCHAR2 (1)                           := 'C';
      c_awaiting       CONSTANT VARCHAR2 (1)                           := 'A';
      c_unpaid         CONSTANT VARCHAR2 (1)                           := 'U';
      c_returned       CONSTANT VARCHAR2 (1)                           := 'R';
      /* Variables for the loa_stud table */
      i_stud_crse_year_id       rep_msteps_loa_stud.stud_crse_year_id%TYPE;
      i_issue_date              rep_msteps_loa_stud.issue_date%TYPE;
      i_style                   rep_msteps_loa_stud.style%TYPE;
      i_duplicate               rep_msteps_loa_stud.duplicate%TYPE;
      i_stud_ref_no             rep_msteps_loa_stud.stud_ref_no%TYPE;
      i_stud_title              rep_msteps_loa_stud.title%TYPE;
      i_stud_initials           rep_msteps_loa_stud.initials%TYPE;
      i_stud_surname            rep_msteps_loa_stud.surname%TYPE;
      i_stud_forenames          rep_msteps_loa_stud.forename%TYPE;
      i_stud_house_no_name      rep_msteps_loa_stud.house_no_name%TYPE;
      i_stud_addr_l1            rep_msteps_loa_stud.addr_l1%TYPE;
      i_stud_addr_l2            rep_msteps_loa_stud.addr_l2%TYPE;
      i_stud_addr_l3            rep_msteps_loa_stud.addr_l3%TYPE;
      i_stud_addr_l4            rep_msteps_loa_stud.addr_l4%TYPE;
      i_stud_post_code          rep_msteps_loa_stud.post_code%TYPE;
      i_stud_mailsort           rep_msteps_loa_stud.mailsort%TYPE;
      i_emp_tel_ext             rep_msteps_loa_stud.emp_tel_ext%TYPE;
      i_dearing_status          rep_msteps_loa_stud.dearing_status%TYPE;
      i_inst_name               rep_msteps_loa_stud.inst_name%TYPE;
      i_crse_name               rep_msteps_loa_stud.crse_name%TYPE;
      i_crse_year_no            rep_msteps_loa_stud.crse_year_no%TYPE;
      i_saas_ref                rep_msteps_loa_stud.saas_ref%TYPE;
      i_slc_ref_no              rep_msteps_loa_stud.slc_ref%TYPE;
      i_session_code            rep_msteps_loa_stud.session_code%TYPE;
      i_independent             rep_msteps_loa_stud.independent%TYPE;
      i_remaining_amount        rep_msteps_loa_stud.remaining_amount%TYPE;
      i_parent_cont             rep_msteps_loa_stud.parent_cont%TYPE;
      i_spouse_cont             rep_msteps_loa_stud.spouse_cont%TYPE;
      i_student_cont            rep_msteps_loa_stud.student_cont%TYPE;
      i_sponsor_cont            rep_msteps_loa_stud.sponsor_cont%TYPE;
      i_resid_par_cont          rep_msteps_loa_stud.resid_par_cont%TYPE;
      i_resid_spouse_cont       rep_msteps_loa_stud.resid_spouse_cont%TYPE;
      i_resid_stud_cont         rep_msteps_loa_stud.resid_stud_cont%TYPE;
      i_resid_sponsor_cont      rep_msteps_loa_stud.resid_sponsor_cont%TYPE;
      i_op_recovered            rep_msteps_loa_stud.overpayment_recovered%TYPE;
      i_caseworker_name         rep_msteps_loa_stud.caseworker_name%TYPE;
      i_overpayment             rep_msteps_loa_stud.overpayment%TYPE;
      i_pams                    rep_msteps_loa_stud.pams%TYPE;
      vfs1                      rep_msteps_loa_stud.fs1%TYPE;
      vfs2                      rep_msteps_loa_stud.fs2%TYPE;
      vfs3                      rep_msteps_loa_stud.fs3%TYPE;
      vfs4                      rep_msteps_loa_stud.fs4%TYPE;
      vfs5                      rep_msteps_loa_stud.fs5%TYPE;
      vfs6                      rep_msteps_loa_stud.fs6%TYPE;
      vfs7                      rep_msteps_loa_stud.fs7%TYPE;
      vfs8                      rep_msteps_loa_stud.fs8%TYPE;
      vfs9                      rep_msteps_loa_stud.fs9%TYPE;
      vrem1                     rep_msteps_loa_stud.rem1%TYPE;
      vrem2                     rep_msteps_loa_stud.rem2%TYPE;
      vrem3                     rep_msteps_loa_stud.rem3%TYPE;
      vrem4                     rep_msteps_loa_stud.rem4%TYPE;
      vrem5                     rep_msteps_loa_stud.rem5%TYPE;
      vrem6                     rep_msteps_loa_stud.rem6%TYPE;
      vrem7                     rep_msteps_loa_stud.rem7%TYPE;
      vrem8                     rep_msteps_loa_stud.rem8%TYPE;
      vrem9                     rep_msteps_loa_stud.rem9%TYPE;
      vrem10                    rep_msteps_loa_stud.rem10%TYPE;
      -- RFC 188
      vrem11                    rep_msteps_loa_stud.rem11%TYPE;
      vrem12                    rep_msteps_loa_stud.rem12%TYPE;
      vrem13                    rep_msteps_loa_stud.rem13%TYPE;
      --Monthly Payments
      vrem14                    rep_msteps_loa_stud.rem14%TYPE;
      i_loan_amount_rem14       rep_msteps_loa_award.net_amount%TYPE;
      --
      /* Variables for loa_award table */
      i_fee_amount              rep_msteps_loa_award.net_amount%TYPE;
      i_you_pay_fees            rep_msteps_loa_award.you_pay_fees%TYPE;
      i_we_pay_fees             rep_msteps_loa_award.we_pay_fees%TYPE;
      i_net_amount              rep_msteps_loa_award.net_amount%TYPE;
      i_loan_amount             rep_msteps_loa_award.net_amount%TYPE;
      i_max_loan                rep_msteps_loa_award.max_loan%TYPE;
      i_descript                rep_msteps_loa_award.descript%TYPE;
      i_stud_award_type         rep_msteps_loa_award.stud_award_type%TYPE;
      /* Variables for loa_payments table */
      i_payment_method          rep_msteps_loa_payments.payment_method_ind%TYPE;
      i_payment_addr            rep_msteps_loa_payments.payment_addr%TYPE;
      i_payment_due_date        rep_msteps_loa_payments.payment_due_date%TYPE;
      i_sum_awi_net_amount      rep_msteps_loa_payments.net_amount%TYPE;
      i_sort_code               rep_msteps_loa_payments.sort_code%TYPE;
      i_account_no              rep_msteps_loa_payments.account_no%TYPE;
      i_build_soc_no            rep_msteps_loa_payments.build_soc_no%TYPE;
      i_sum_aw_net_amount       rep_msteps_loa_payments.net_amount%TYPE;
      i_nom_name                rep_msteps_loa_payments.payee_name%TYPE;
      i_paid_sort_code          rep_msteps_loa_payments.sort_code%TYPE;
      i_paid_account_no         rep_msteps_loa_payments.account_no%TYPE;
      i_paid_build_soc_no       rep_msteps_loa_payments.build_soc_no%TYPE;
      i_payee_name              rep_msteps_loa_payments.payee_name%TYPE;
      /* General Variables */
      return_string             VARCHAR2 (1000);
      v_batch_size              NUMBER;
      v_inst_code               inst.inst_code@grass%TYPE;
      v_crse_code               crse.crse_code@grass%TYPE;
      v_ge_liability            VARCHAR2 (1);
      v_fees_exist              BOOLEAN;
      v_award_id                sgas.award.award_id%TYPE;
      v_fee_award_id            sgas.award.award_id%TYPE;
      v_ben_cnt                 NUMBER;
      v_ysb_yso                 VARCHAR2 (1);
      v_erasmus                 VARCHAR2 (1);
      v_paid_sandwich           VARCHAR2 (1);
      v_unpaid_sandwich         VARCHAR2 (1);
      b1_p60_req                VARCHAR2 (1);
      b1_a_req                  VARCHAR2 (1);
      b1_d_req                  VARCHAR2 (1);
      b1_e_req                  VARCHAR2 (1);
      b1_pen_req                VARCHAR2 (1);
      b1_dss_req                VARCHAR2 (1);
      b1_int_req                VARCHAR2 (1);
      b1_life_req               VARCHAR2 (1);
      b1_rap_req                VARCHAR2 (1);
      b1_other_req              VARCHAR2 (1);
      b2_p60_req                VARCHAR2 (1);
      b2_a_req                  VARCHAR2 (1);
      b2_d_req                  VARCHAR2 (1);
      b2_e_req                  VARCHAR2 (1);
      b2_pen_req                VARCHAR2 (1);
      b2_dss_req                VARCHAR2 (1);
      b2_int_req                VARCHAR2 (1);
      b2_life_req               VARCHAR2 (1);
      b2_rap_req                VARCHAR2 (1);
      b2_other_req              VARCHAR2 (1);
      default_caseworker        VARCHAR2 (31);
      default_tele_no           VARCHAR2 (15);
      v_left_agency             VARCHAR2 (1);
      vret                      NUMBER;
      v_eu_crse                 VARCHAR2 (1);
      v_qual_type               crse.qual_type@grass%TYPE;
      v_provisional_case        VARCHAR2 (1);
      v_location_ind            VARCHAR2 (1);
      v_award_given             VARCHAR2 (1);
      v_parent_contrib_exempt   VARCHAR2 (1);
      v_scheme                  VARCHAR2 (1);
      v_ja_case                 VARCHAR2 (1);
      v_ja_case_id              NUMBER (6);
      v_session_count           NUMBER (2);
      v_opayment                NUMBER (9, 2);
      v_snb_opayment            NUMBER (9, 2);
      v_def_terms               VARCHAR2 (1);
      v_term_start              DATE;
      v_no_ja_studs_reg         NUMBER;
      v_no_ja_studs_tot         NUMBER;
      v_cur_sess_op             NUMBER;
      v_scy_rid                 ROWID;
      v_cy_rid                  ROWID;
      tname                     VARCHAR2 (25);
      v_campus_id               campus.campus_id@grass%TYPE;
      v_remark                  sgas.stud_crse_year.remark%TYPE;   -- SIR 262
      v_ben1_id                 sgas.stud_session.ben1_id%TYPE;
      v_ben2_id                 sgas.stud_session.ben2_id%TYPE;
      v_corres_dest             sgas.stud_crse_year.corres_dest%TYPE;
      v_crse_year_id            crse_year.crse_year_id@grass%TYPE;
      v_batch_ref               sgas.award_instalment.batch_ref%TYPE;
      v_source_ref              VARCHAR2 (10);
      v_sum1                    NUMBER;
      v_sum2                    NUMBER;
      v_qa_received             NUMBER (2);                         -- SIR 50
      v_ni_no                   stud.ni_no%TYPE;                   -- RFC 188
      v_fee_loan_given          sgas.stud_crse_year.fee_loan_given%TYPE;
      -- RFC 188
      v_self_funding            sgas.stud_crse_year.self_funding%TYPE;
      -- RFC 188
      v_loan_given              sgas.stud_crse_year.loan_given%TYPE;
      -- Monthly Payments
      v_loan_text               VARCHAR2 (100);

/*****************************************************************/
/* If called from cron for the new Letter of Award(LOA)    retrieve */
/* information from Stud, Stud_Session and Stud_Crse_Year tables */
/*****************************************************************/
      CURSOR loa_cron_curs (
         ptype        IN   sgas.stud_crse_year.sal_dest%TYPE,
         batch_size   IN   NUMBER
      )
      IS
         SELECT     st.title, st.initials, st.forenames, st.surname,
                    st.stud_ref_no, st.scottish_cand,
                                                     -- This is the SLC Ref number
                                                     st.overpayment,
                    st.snb_overpayment, st.nom_name, st.account_no,
                    st.sort_code, st.build_soc_no, st.ni_no,       -- RFC 188
                                                            stcy.ROWID,
                    stcy.inst_code, stcy.inst_name, stcy.crse_code,
                    stcy.crse_name, stcy.crse_year_no,
                    stcy.parent_contrib_exempt, stcy.stud_crse_year_id,
                    stcy.corres_dest, stcy.provisional_case, stcy.award,
                    stcy.crse_year_id, stcy.scheme_type, stcy.dearing,
                    stcy.req_dup, stcy.independent,
                    NVL (stcy.due_ysb_yso_ind, 'N'), stcy.erasmus,
                    stcy.paid_sandwich, stcy.unpaid_sandwich,
                    NVL (stcy.parent_cont, 0), NVL (stcy.spouse_cont, 0),
                    NVL (stcy.stud_cont, 0), NVL (stcy.sponsor_cont, 0),
                    NVL (stcy.resid_par_cont, 0),
                    NVL (stcy.resid_spouse_cont, 0),
                    NVL (stcy.resid_stud_cont, 0),
                    NVL (stcy.resid_sponsor_cont, 0),
                    NVL (stcy.tot_ja_studs_reg, 0), stcy.remark,   -- SIR 262
                    stcy.fee_loan_given,                           -- RFC 188
                                        stcy.self_funding,         -- RFC 188
                                                          stcy.loan_given,
                    
                    -- Monthly Payments
                    sts.ben1_id, sts.ben2_id, sts.session_code, sts.ja_case,
                    sts.ja_case_id, NVL (sts.ge_liability, 'N'),
                    --e.first_name || ' ' || e.last_name, e.tele_no,
                    null,null ,
                    null--e.left_agency
               FROM sgas.stud_crse_year stcy,
                    sgas.stud_session sts,
                    stud st--,
                    --emp@grass e
              WHERE NVL (st.suspend_payment, 'N') = 'N'
                AND st.stud_ref_no = sts.stud_ref_no
                AND sts.stud_session_id = stcy.stud_session_id
                AND stcy.latest_crse_ind = 'Y'
                AND stcy.sal_dest = ptype
                AND stcy.sal_sent = 'N'
                --AND sts.emp_login_name = e.emp_login_name
                AND (   EXISTS (
                           SELECT award_id
                             FROM sgas.award a
                            WHERE a.stud_crse_year_id = stcy.stud_crse_year_id
                              AND (   (    a.stud_award_type IS NOT NULL
                                       AND a.stud_award_type NOT IN
                                              ('UGTE', 'UGLTE', 'PSTE',
                                               'PSLTE', 'SNPE', 'PSDSA',
                                               'SSDSA', 'UGDSA', 'ADHOC',
                                               'UGADJ', 'PSADJ', 'SSADJ',
                                               'SNADJ', 'SNBDSA', 'UGNL',
                                               'UGNFL', 'UGML', 'UGMFL',
                                               'UGHNL', 'UGHNFL', 'UCNL',
                                               'UCNFL', 'UCML', 'UCMFL',
                                               'UCHNL', 'UCHNFL', 'UDNL',
                                               'UDNFL', 'UDML', 'UDMFL',
                                               'UDHNL', 'UDHNFL', 'UDNXL',
                                               'UENL', 'UENFL', 'UEML',
                                               'UEMFL', 'PTL')
                                      )
                                   OR a.stud_award_type IS NULL
                                  ))
                     OR (SELECT SUM (net_amount)
                           FROM sgas.award a2
                          WHERE a2.stud_crse_year_id = stcy.stud_crse_year_id
                            AND a2.stud_award_type IN
                                   ('UGNL', 'UGNFL', 'UGML', 'UGMFL', 'UGHNL',
                                    'UGHNFL', 'UCNL', 'UCNFL', 'UCML',
                                    'UCMFL', 'UCHNL', 'UCHNFL', 'UDNL',
                                    'UDNFL', 'UDML', 'UDMFL', 'UDHNL',
                                    'UDHNFL', 'UDNXL', 'UENL', 'UENFL',
                                    'UEML', 'UEMFL', 'PTL')) > 0
                    )
                AND ROWNUM <= batch_size
           ORDER BY sts.session_code, st.stud_ref_no
         FOR UPDATE;

/********************************************************************/
/* If called from M024 retrieve information from stud, stud_session */
/* and stud_crse_year tables (Result may be many records).        */
/********************************************************************/
      CURSOR loa_single_curs (
         scyid   IN   sgas.stud_crse_year.stud_crse_year_id%TYPE
      )
      IS
         SELECT     st.title, st.initials, st.forenames, st.surname,
                    st.stud_ref_no, st.scottish_cand,
                                                     -- This is the SLC Ref number
                                                     st.overpayment,
                    st.snb_overpayment, st.nom_name, st.account_no,
                    st.sort_code, st.build_soc_no, st.ni_no,        -- RFC 188
                                                            stcy.ROWID,
                    stcy.inst_code, stcy.inst_name, stcy.crse_code,
                    stcy.crse_name, stcy.crse_year_no,
                    stcy.parent_contrib_exempt, stcy.stud_crse_year_id,
                    stcy.corres_dest, stcy.provisional_case, stcy.award,
                    stcy.crse_year_id, stcy.scheme_type, stcy.dearing,
                    stcy.req_dup, stcy.independent,
                    NVL (stcy.due_ysb_yso_ind, 'N'), stcy.erasmus,
                    stcy.paid_sandwich, stcy.unpaid_sandwich,
                    NVL (stcy.parent_cont, 0), NVL (stcy.spouse_cont, 0),
                    NVL (stcy.stud_cont, 0), NVL (stcy.sponsor_cont, 0),
                    NVL (stcy.resid_par_cont, 0),
                    NVL (stcy.resid_spouse_cont, 0),
                    NVL (stcy.resid_stud_cont, 0),
                    NVL (stcy.resid_sponsor_cont, 0),
                    NVL (stcy.tot_ja_studs_reg, 0), stcy.remark,    -- SIR 262
                    stcy.fee_loan_given,                            -- RFC 188
                                        stcy.self_funding,          -- RFC 188
                                                          stcy.loan_given,
                    
                    -- Monthly Payments
                    sts.ben1_id, sts.ben2_id, sts.session_code, sts.ja_case,
                    sts.ja_case_id, NVL (sts.ge_liability, 'N'),
                    --e.first_name || ' ' || e.last_name, e.tele_no,
                    --e.left_agency
                    null,null,null
               FROM sgas.stud_crse_year stcy,
                    sgas.stud_session sts,
                    stud st--,
                    --emp@grass e
              WHERE st.stud_ref_no = sts.stud_ref_no
                AND sts.stud_session_id = stcy.stud_session_id
                AND stcy.latest_crse_ind = 'Y'
                AND stcy.stud_crse_year_id = scyid
                --AND sts.emp_login_name = e.emp_login_name
           ORDER BY sts.session_code, st.stud_ref_no
         FOR UPDATE;

/***********************************************************/
/* Retrieve details of Awards - Result may be many records */
/***********************************************************/
      CURSOR cur_awd (scyid IN sgas.stud_crse_year.stud_crse_year_id%TYPE)
      IS
         SELECT a.award_id, a.stud_award_type, UPPER (sr.descript),
                LEAST (a.amount, a.net_amount)
           FROM sgas.award a, stud_rates@grass sr
          WHERE a.stud_crse_year_id = scyid
            AND a.stud_award_type IS NOT NULL
            AND a.stud_award_type NOT IN
                   ('UGTE', 'UGLTE', 'PSTE', 'PSLTE', 'SNPE', 'PSDSA',
                    'SSDSA', 'UGDSA', 'ADHOC', 'UGNL', 'UGNFL', 'UGML',
                    'UGMFL', 'UGHNL', 'UGHNFL', 'UCNL', 'UCNFL', 'UCML',
                    'UCMFL', 'UCHNL', 'UCHNFL', 'UDNL', 'UDNFL', 'UDML',
                    'UDMFL', 'UDHNL', 'UDHNFL', 'UDNXL', 'UENL', 'UENFL',
                    'UEML', 'UEMFL', 'SNBDSA', 'PTL', 'UGADJ', 'PSADJ',
                    'SSADJ', 'SNADJ', 'SNBDSA')
            AND a.stud_award_type = sr.stud_award_type
            AND sr.end_date IS NULL;

/************************************************************************************************************/
/* Retrieve unpaid summary records from Award Instalment payment_due_date wise - Result may be many records */
/************************************************************************************************************/
      CURSOR cur_awi_unpaid (
         scyid   IN   sgas.stud_crse_year.stud_crse_year_id%TYPE
      )
      IS
         SELECT   awi.payment_due_date, awi.method,
                  DECODE (awi.payee,
                          'N', 'N',
                          awi.payment_addr
                         ) payment_addr, awi.campus_id, SUM (awi.net_amount)
             FROM sgas.award a, sgas.award_instalment awi
            WHERE a.stud_crse_year_id = scyid
              AND awi.award_id = a.award_id
              AND awi.payment_status IN (c_awaiting, c_unpaid)
              AND (   (    awi.returned = 'N'
                       AND awi.recalc = 'N'
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
              AND (    a.stud_award_type IS NOT NULL
                   AND a.stud_award_type NOT IN
                          ('UGTE', 'UGLTE', 'PSTE', 'PSLTE', 'SNPE', 'PSDSA',
                           'SSDSA', 'UGDSA', 'ADHOC', 'UGNL', 'UGNFL', 'UGML',
                           'UGMFL', 'UGHNL', 'UGHNFL', 'UCNL', 'UCNFL',
                           'UCML', 'UCMFL', 'UCHNL', 'UCHNFL', 'UDNL',
                           'UDNFL', 'UDML', 'UDMFL', 'UDHNL', 'UDHNFL',
                           'UDNXL', 'UENL', 'UENFL', 'UEML', 'UEMFL',
                           'SNBDSA', 'PTL', 'UGADJ', 'PSADJ', 'SSADJ',
                           'SNADJ', 'SNBDSA')
                  )
         GROUP BY payment_due_date,
                  method,
                  DECODE (awi.payee, 'N', 'N', awi.payment_addr),
                  campus_id;

/*****************************************************************************************************/
/* Retrieve paid summary records from Award Instalment payment_due_date wise - Result may be many records */
/*****************************************************************************************************/
      CURSOR cur_awi_paid (
         scyid   IN   sgas.stud_crse_year.stud_crse_year_id%TYPE
      )
      IS
         SELECT   sp.dpp_payment_date, awi.method,
                  DECODE (awi.payee,
                          'N', 'N',
                          awi.payment_addr
                         ) payment_addr, sp.dpp_payee,
                  sp.dpp_payee_bank_account, sp.dpp_payee_bank_sort_code,
                  sp.dpp_build_soc_roll_no, sp.dpp_source_ref,
                  SUM (awi.net_amount)
             FROM sgas.award a,
                  sgas.award_instalment awi,
                  sgas.scoap_payments sp
            WHERE a.stud_crse_year_id = scyid
              AND awi.award_id = a.award_id
              AND (   awi.payment_status IS NULL
                   OR (    awi.payment_status = c_returned
                       AND awi.returned = 'Y'
                       AND awi.recalc = 'N'
                      )
                  )
              AND a.stud_award_type IS NOT NULL
              AND a.stud_award_type NOT IN
                     ('UGTE', 'UGLTE', 'PSTE', 'PSLTE', 'SNPE', 'PSDSA',
                      'SSDSA', 'UGDSA', 'ADHOC', 'UGNL', 'UGNFL', 'UGML',
                      'UGMFL', 'UGHNL', 'UGHNFL', 'UCNL', 'UCNFL', 'UCML',
                      'UCMFL', 'UCHNL', 'UCHNFL', 'UDNL', 'UDNFL', 'UDML',
                      'UDMFL', 'UDHNL', 'UDHNFL', 'UDNXL', 'UENL', 'UENFL',
                      'UEML', 'UEMFL', 'SNBDSA', 'PTL', 'UGADJ', 'PSADJ',
                      'SSADJ', 'SNADJ', 'SNBDSA')
              AND awi.batch_ref = sp.dpp_batch_ref
              AND a.stud_crse_year_id = sp.dpp_our_ref2
              AND awi.payment_id = sp.dpp_payment_id
         GROUP BY dpp_payment_date,
                  method,
                  DECODE (awi.payee, 'N', 'N', awi.payment_addr),
                  dpp_payee,
                  dpp_payee_bank_account,
                  dpp_payee_bank_sort_code,
                  dpp_build_soc_roll_no,
                  dpp_source_ref;
   BEGIN
      /* Set the report to date if the job is a scheduled batch job (i.e. a scy_id is supplied) */
      IF p_stud_crse_year_id = 0
      THEN
         i_issue_date := SYSDATE;
      ELSE
         i_issue_date := NULL;
      END IF;

      BEGIN
         /* Retrieve the default caseworker name - Used when the associated caseworker has left the Agency */
         SELECT e.first_name || ' ' || e.last_name, e.tele_no
          INTO default_caseworker, default_tele_no
           FROM emp@grass e, config_data@grass c
          WHERE e.emp_login_name = c.cval AND c.item_name = 'DEFAULT_USER';

          
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN ('The default user entry in CONFIG_DATA table is either missing or invalid.');
      END;

      -- Get the batch size from CONFIG_DATA
      BEGIN
         SELECT nval
           INTO v_batch_size
           FROM config_data@grass
          WHERE item_name = 'LOA_BATCH_SIZE';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN ('The LOA_BATCH_SIZE entry in CONFIG_DATA is missing.');
      END;

      COMMIT;
      SET TRANSACTION USE ROLLBACK SEGMENT rbs1;

      -- Open the relevant cursor - If stud_crse_year_id passed is 0 then it is called from cron
      IF p_stud_crse_year_id = 0
      THEN
         -- Called from cron
         OPEN loa_cron_curs (p_post_type, v_batch_size);
      ELSE
         -- Called from m024
         OPEN loa_single_curs (p_stud_crse_year_id);
      END IF;

      LOOP
         IF p_stud_crse_year_id = 0
         THEN
            FETCH loa_cron_curs
             INTO i_stud_title, i_stud_initials, i_stud_forenames,
                  i_stud_surname, i_stud_ref_no, i_slc_ref_no, v_opayment,
                  v_snb_opayment, i_nom_name, i_account_no, i_sort_code,
                  i_build_soc_no, v_ni_no,                         -- RFC 188
                                          v_scy_rid, v_inst_code,
                  i_inst_name, v_crse_code, i_crse_name, i_crse_year_no,
                  v_parent_contrib_exempt, i_stud_crse_year_id,
                  v_corres_dest, v_provisional_case, v_award_given,
                  v_crse_year_id, v_scheme, i_dearing_status, i_duplicate,
                  i_independent, v_ysb_yso, v_erasmus, v_paid_sandwich,
                  v_unpaid_sandwich, i_parent_cont, i_spouse_cont,
                  i_student_cont, i_sponsor_cont, i_resid_par_cont,
                  i_resid_spouse_cont, i_resid_stud_cont,
                  i_resid_sponsor_cont, v_no_ja_studs_reg, v_remark,
                  
                  -- SIR 262
                  v_fee_loan_given,                                -- RFC 188
                                   v_self_funding,                 -- RFC 188
                                                  v_loan_given,
                                                               -- Monthly Payments
                                                               v_ben1_id,
                  v_ben2_id, i_session_code, v_ja_case, v_ja_case_id,
                  v_ge_liability, i_caseworker_name, i_emp_tel_ext,
                  v_left_agency;

            EXIT WHEN loa_cron_curs%NOTFOUND;
         ELSE
            FETCH loa_single_curs
             INTO i_stud_title, i_stud_initials, i_stud_forenames,
                  i_stud_surname, i_stud_ref_no, i_slc_ref_no, v_opayment,
                  v_snb_opayment, i_nom_name, i_account_no, i_sort_code,
                  i_build_soc_no, v_ni_no,                         -- RFC 188
                                          v_scy_rid, v_inst_code,
                  i_inst_name, v_crse_code, i_crse_name, i_crse_year_no,
                  v_parent_contrib_exempt, i_stud_crse_year_id,
                  v_corres_dest, v_provisional_case, v_award_given,
                  v_crse_year_id, v_scheme, i_dearing_status, i_duplicate,
                  i_independent, v_ysb_yso, v_erasmus, v_paid_sandwich,
                  v_unpaid_sandwich, i_parent_cont, i_spouse_cont,
                  i_student_cont, i_sponsor_cont, i_resid_par_cont,
                  i_resid_spouse_cont, i_resid_stud_cont,
                  i_resid_sponsor_cont, v_no_ja_studs_reg, v_remark,
                  
                  -- SIR 262
                  v_fee_loan_given,                                -- RFC 188
                                   v_self_funding,                 -- RFC 188
                                                  v_loan_given,
                                                               -- Monthly Payments
                                                               v_ben1_id,
                  v_ben2_id, i_session_code, v_ja_case, v_ja_case_id,
                  v_ge_liability, i_caseworker_name, i_emp_tel_ext,
                  v_left_agency;

            EXIT WHEN loa_single_curs%NOTFOUND;
         END IF;

         /* Set the SAAS ref to be the stud_ref_no prefixed by the team number */
         BEGIN
            /* Get the team name */
            --Telephony_Support.determine_team(I_stud_crse_year_id, tname);
            tname := NULL;
                /* Set the prefix using the team name */
            /* removed prefix for RFC 188 */
                /*IF tname = 'SSS' THEN
                    I_saas_ref := 'S/'||TO_CHAR(I_stud_ref_no);
                ELSIF tname = 'PSAS' THEN
                    I_saas_ref := 'P/'||TO_CHAR(I_stud_ref_no);
                ELSIF tname = 'SNB' THEN
                    I_saas_ref := 'B/'||TO_CHAR(I_stud_ref_no);
                ELSIF tname = 'SAS_I' THEN
                    I_saas_ref := '1/'||TO_CHAR(I_stud_ref_no);
                ELSIF tname = 'SAS_II' THEN
                    I_saas_ref := '2/'||TO_CHAR(I_stud_ref_no);
                ELSIF tname = 'SAS_III' THEN
                    I_saas_ref := '3/'||TO_CHAR(I_stud_ref_no);
                ELSIF tname = 'SAS_IV' THEN
                    I_saas_ref := '4/'||TO_CHAR(I_stud_ref_no);
                ELSIF tname = 'SAS_V' THEN
                    I_saas_ref := '5/'||TO_CHAR(I_stud_ref_no);
                ELSIF tname = 'SAS_VI' THEN
                    I_saas_ref := '6/'||TO_CHAR(I_stud_ref_no);
                ELSIF tname = 'SAS_VII' THEN
                    I_saas_ref := '7/'||TO_CHAR(I_stud_ref_no);
                ELSIF tname = 'SAS_IX' THEN
                    I_saas_ref := '9/'||TO_CHAR(I_stud_ref_no);
                ELSE
                    I_saas_ref := TO_CHAR(I_stud_ref_no);
                END IF;*/
            i_saas_ref := TO_CHAR (i_stud_ref_no);
         EXCEPTION
            WHEN OTHERS
            THEN
               i_saas_ref := TO_CHAR (i_stud_ref_no);
               tname := 'UNKNOWN';
         END;

         /* Establish which caseworker telephone number to print on the letter */
         BEGIN
            /* If the employee has left the agency then use the default name and number */
            IF v_left_agency = 'Y'
            THEN
               i_caseworker_name := default_caseworker;
               i_emp_tel_ext := default_tele_no;
            ELSE
               /* Otherwise, get the general number for the team that the caseworker belongs to */
               IF tname = 'UNKNOWN'
               THEN
                  i_emp_tel_ext := default_tele_no;
               ELSE
                  SELECT cval
                    INTO i_emp_tel_ext
                    FROM config_data
                   WHERE item_name = tname || '_NO';
               END IF;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               i_emp_tel_ext := default_tele_no;
         END;

         /* Get the term start date (and qual type and EU flag for later on) */
         BEGIN
            SELECT     NVL (cy.default_terms, 'N'), NVL (cy.eu_flag, 'N'),
                       cy.ROWID, c.qual_type
                  INTO v_def_terms, v_eu_crse,
                       v_cy_rid, v_qual_type
                  FROM crse@grass c, crse_year@grass cy
                 WHERE crse_year_id = v_crse_year_id
                       AND cy.crse_id = c.crse_id
            FOR UPDATE;

            IF v_def_terms = 'Y'
            THEN
               SELECT TRUNC (it.start_date)
                 INTO v_term_start
                 FROM inst_term@grass it, sgas.stud_crse_year scy
                WHERE scy.ROWID = v_scy_rid
                  AND scy.inst_code = it.inst_code
                  AND it.session_code = i_session_code
                  AND it.term_no = 1;
            ELSE
               SELECT TRUNC (start_date)
                 INTO v_term_start
                 FROM crse_term@grass
                WHERE crse_year_id = v_crse_year_id AND term_no = 1;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_term_start := NULL;
         END;

         -- Decide whether to print the independant flag
         IF i_independent = 'Y'
         THEN
            IF     (   (i_session_code >= 2000 AND v_scheme = 'U')
                    OR (i_session_code >= 2001 AND v_qual_type = 'PGCE')
                   )
               AND i_dearing_status != 'O'
               AND v_eu_crse = 'N'
               AND v_ysb_yso = 'N'
            THEN
               i_independent := 'Y';
            ELSE
               i_independent := 'N';
            END IF;
         END IF;

         -- Determine whether PAMS or not
         IF sgas_utils.check_pams@grass (v_inst_code, v_crse_code)
         THEN
            i_pams := 'Y';
         ELSE
            i_pams := 'N';
         END IF;

         -- Derive the OP Recovered amount
         BEGIN
            -- Get the OP Recovered amount for all award types
            SELECT SUM (LEAST (NVL (amount, 0), NVL (recovered_amount, 0)))
              INTO v_sum1
              FROM sgas.award
             WHERE stud_crse_year_id = i_stud_crse_year_id
               AND stud_award_type IS NOT NULL;

            -- Get the recovered amount for the fee
            SELECT SUM (NVL (recovered_amount, 0))
              INTO v_sum2
              FROM sgas.award
             WHERE stud_crse_year_id = i_stud_crse_year_id
               AND stud_award_type IS NULL;

            i_op_recovered := NVL (v_sum1, 0) + NVL (v_sum2, 0);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               i_op_recovered := 0;
         END;

         -- Calculate the cont variables
         i_parent_cont := i_parent_cont - i_resid_par_cont;
         i_spouse_cont := i_spouse_cont - i_resid_spouse_cont;
         i_student_cont := i_student_cont - i_resid_stud_cont;
         i_sponsor_cont := i_sponsor_cont - i_resid_sponsor_cont;

         -- Reset to 0 for certain student types
         IF v_scheme = 'B'
         THEN
            i_parent_cont := 0;
            i_spouse_cont := 0;
            i_student_cont := 0;
            i_sponsor_cont := 0;
         END IF;

         IF i_dearing_status = 'O'
         THEN
            i_parent_cont := 0;
            i_sponsor_cont := 0;
         END IF;

         -- Retrieve Details of First benefactor ( Result one record )
         -- If id is null then null the variables
         vrem1 := 'N';

         IF v_ben1_id IS NOT NULL
         THEN
            BEGIN
               -- Select the benefactor doc's required
               SELECT p60_req, sched_a_req, sched_d_req, sched_e_req,
                      pension_cb, benefit_cb, loan_int_cb, life_ins_cb,
                      rap_cb, oth_deducts_cb
                 INTO b1_p60_req, b1_a_req, b1_d_req, b1_e_req,
                      b1_pen_req, b1_dss_req, b1_int_req, b1_life_req,
                      b1_rap_req, b1_other_req
                 FROM sgas.benefactor_income
                WHERE ben_id = v_ben1_id AND session_code = i_session_code;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  b1_p60_req := NULL;
                  b1_a_req := NULL;
                  b1_d_req := NULL;
                  b1_e_req := NULL;
                  b1_pen_req := NULL;
                  b1_dss_req := NULL;
                  b1_int_req := NULL;
                  b1_life_req := NULL;
                  b1_rap_req := NULL;
                  b1_other_req := NULL;
            END;
         ELSE
            -- No benefactor - null the variables
            b1_p60_req := NULL;
            b1_a_req := NULL;
            b1_d_req := NULL;
            b1_e_req := NULL;
            b1_pen_req := NULL;
            b1_dss_req := NULL;
            b1_int_req := NULL;
            b1_life_req := NULL;
            b1_rap_req := NULL;
            b1_other_req := NULL;
         END IF;

         -- Select benefactor 2 details
         IF v_ben2_id IS NOT NULL
         THEN
            BEGIN
               -- Select the doc's required
               SELECT p60_req, sched_a_req, sched_d_req, sched_e_req,
                      pension_cb, benefit_cb, loan_int_cb, life_ins_cb,
                      rap_cb, oth_deducts_cb
                 INTO b2_p60_req, b2_a_req, b2_d_req, b2_e_req,
                      b2_pen_req, b2_dss_req, b2_int_req, b2_life_req,
                      b2_rap_req, b2_other_req
                 FROM sgas.benefactor_income
                WHERE ben_id = v_ben2_id AND session_code = i_session_code;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  b2_p60_req := NULL;
                  b2_a_req := NULL;
                  b2_d_req := NULL;
                  b2_e_req := NULL;
                  b2_pen_req := NULL;
                  b2_dss_req := NULL;
                  b2_int_req := NULL;
                  b2_life_req := NULL;
                  b2_rap_req := NULL;
                  b2_other_req := NULL;
            END;
         ELSE
            -- Null the variables
            b2_p60_req := NULL;
            b2_a_req := NULL;
            b2_d_req := NULL;
            b2_e_req := NULL;
            b2_pen_req := NULL;
            b2_dss_req := NULL;
            b2_int_req := NULL;
            b2_life_req := NULL;
            b2_rap_req := NULL;
            b2_other_req := NULL;
         END IF;

         IF v_provisional_case = 'Y'
         THEN
            /* Remark 1 */
            IF     (   b1_p60_req = 'Y'
                    OR b1_a_req = 'Y'
                    OR b1_d_req = 'Y'
                    OR b1_e_req = 'Y'
                    OR b1_pen_req = 'Y'
                    OR b1_dss_req = 'Y'
                    OR b1_int_req = 'Y'
                    OR b1_life_req = 'Y'
                    OR b1_rap_req = 'Y'
                    OR b1_other_req = 'Y'
                    OR b2_p60_req = 'Y'
                    OR b2_a_req = 'Y'
                    OR b2_d_req = 'Y'
                    OR b2_e_req = 'Y'
                    OR b2_pen_req = 'Y'
                    OR b2_dss_req = 'Y'
                    OR b2_int_req = 'Y'
                    OR b2_life_req = 'Y'
                    OR b2_rap_req = 'Y'
                    OR b2_other_req = 'Y'
                   )
               AND v_parent_contrib_exempt = 'N'
            THEN
               -- Check REM2 code below as this will get reset if REM2 is printed
               vrem1 := 'Y';
            ELSE
               vrem1 := 'N';
            END IF;
         ELSE
            vrem1 := 'N';
         END IF;

         /* End of Remark 1 */

         /* Remark 2 - Identify abbreviated processing case */
         vrem2 := 'N';

         -- SIR 50 Janis
         IF v_ben1_id IS NOT NULL
         THEN
--        SELECT COUNT(*)
--        INTO v_qa_received
--        FROM BENEFACTOR_INCOME
--        WHERE session_code = I_session_code
--        AND NVL(qa_received,'N') ='N'
--        AND (ben_id IN(SELECT ben1_id FROM STUD_SESSION
--                    WHERE SESSION_code = I_session_code
--                    AND stud_ref_no = I_stud_ref_no)
--            OR
--            ben_id IN(SELECT ben2_id FROM STUD_SESSION
--                    WHERE SESSION_code = I_session_code
--                    AND stud_ref_no = I_stud_ref_no));    -- End SIR 50 Janis

            -- SIR164 - SQL above has been refined to run quicker
            SELECT COUNT (*)
              INTO v_qa_received
              FROM sgas.stud_session s, sgas.benefactor_income b
             WHERE s.stud_ref_no = i_stud_ref_no
               AND s.session_code = i_session_code
               AND s.session_code = b.session_code
               AND (b.ben_id = s.ben1_id OR b.ben_id = s.ben2_id)
               AND NVL (b.qa_received, 'N') = 'N';

            -- End of SIR164
            IF     i_session_code > 1999
               AND v_scheme IN ('U', 'P')
               AND v_qa_received > 0
            THEN
               SELECT COUNT (*)
                 INTO v_session_count
                 FROM sgas.stud_crse_year
                WHERE stud_ref_no = i_stud_ref_no
                  AND session_code = i_session_code - 1
                  AND application_status = c_calculated
                  AND latest_crse_ind = 'Y'
                  AND provisional_case = 'N'
                  AND dearing IN ('A', 'B', 'C', 'D', 'E', 'F', 'G');

               -- RFC 188 F and G added

               -- Print remark if count > 0 and and benefactor was present for the previous session
               IF v_session_count > 0
               THEN
                  -- Get ben id's for previous session
                  SELECT COUNT (*)
                    INTO v_ben_cnt
                    FROM sgas.stud_session
                   WHERE stud_ref_no = i_stud_ref_no
                     AND session_code = i_session_code - 1
                     AND (ben1_id IS NOT NULL OR ben2_id IS NOT NULL);

                  IF v_ben_cnt > 0
                  THEN
                     -- Set the REM2 flag and also reset REM1 as you cannot have both REM1 and REM2 printed
                     vrem1 := 'N';
                     vrem2 := 'Y';
                  END IF;
               END IF;
            END IF;
         END IF;

         /* End of Remark 2 */

         /* Remarks 3 and 4 */
         vrem4 := 'N';
         vrem3 := 'N';
         v_no_ja_studs_tot := NULL;

         IF v_ja_case = 'Y'
         THEN
            BEGIN
               SELECT no_saas_students + no_non_saas_children
                 INTO v_no_ja_studs_tot
                 FROM sgas.ja_case
                WHERE ja_case_id = v_ja_case_id;

               IF v_no_ja_studs_tot = v_no_ja_studs_reg
               THEN
                  vrem3 := 'Y';
               ELSE
                  vrem4 := 'Y';
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;
         END IF;

         /* End of Remarks 3 and 4 */

         /* Remark 5 */
         BEGIN
            vrem5 := 'N';
            i_overpayment := NULL;

            IF v_scheme = 'B'
            THEN
               IF NVL (v_snb_opayment, 0) > 0
               THEN
                  v_cur_sess_op := v_snb_opayment;
                  i_overpayment := v_snb_opayment;
                  vrem5 := 'Y';
               END IF;
            ELSE
               IF NVL (v_opayment, 0) > 0
               THEN
                  v_cur_sess_op := v_opayment;
                  i_overpayment := v_opayment;
                  vrem5 := 'Y';
               END IF;
            END IF;
         END;

         /* End of Remark 5 */

         /* Remark 6/7 */
         vrem6 := 'N';
         vrem7 := 'N';

         IF v_award_given = 'D'
         THEN
            vrem6 := 'Y';
         ELSIF v_award_given = 'C'
         THEN
            vrem7 := 'Y';
         END IF;

         /*End of Remark 6/7 */

         /* Remark 8 */
         vrem8 := 'N';

         IF v_ge_liability = 'Y'
         THEN
            vrem8 := 'Y';
         END IF;

         /* End of Remark 8 */

         /* Remark 9 */
         vrem9 := 'N';

         IF v_scheme IN ('U', 'P') AND v_award_given NOT IN ('A', 'C', 'D')
         THEN
            IF (  i_resid_stud_cont
                + i_resid_spouse_cont
                + i_resid_sponsor_cont
                + i_resid_par_cont
               ) > 0
            THEN
               vrem9 := 'Y';
            END IF;
         END IF;

         /* End of Remark 9 */

         /* Remark 10 */
         vrem10 := 'N';

         IF     i_dearing_status IN ('B', 'E')
            AND (   v_erasmus = 'Y'
                 OR v_paid_sandwich = 'Y'
                 OR v_unpaid_sandwich = 'Y'
                )
         THEN
            vrem10 := 'Y';
         END IF;

         /* End of Remark 10 */

         -- RFC 188 additions
          /* Remark 11 */
         vrem11 := 'N';

         IF     i_session_code >= 2006
            AND v_ni_no IS NULL
            AND (   v_fee_loan_given IN ('E', 'F')
                 OR i_dearing_status = 'G' AND v_fee_loan_given = 'C'
                )
         THEN
            vrem11 := 'Y';
         END IF;

         /* End of Remark 11 */

         /* Remark 12 */
         vrem12 := 'N';

         IF i_dearing_status = 'G' AND v_fee_loan_given = 'E'
         THEN
            vrem12 := 'Y';
         END IF;

         /* End of Remark 12 */

         /* Remark 13 */
         vrem13 := 'N';

         IF i_dearing_status = 'F' AND NVL (v_self_funding, 'N') = 'Y'
         THEN
            vrem13 := 'Y';
         END IF;

         /* End of Remark 13 */

         /* Remark 14*/ -- Monthly Payments
         vrem14 := 'N';

         IF (v_loan_given IN ('E', 'F') AND i_dearing_status <> 'O')
         THEN
            SELECT SUM (net_amount)
              INTO i_loan_amount_rem14
              FROM sgas.award
             WHERE stud_crse_year_id = i_stud_crse_year_id
               AND award_types.loan_award@grass (stud_award_type) = 'Y';

            IF NVL (i_loan_amount_rem14, 0) > 0
            THEN
               vrem14 := 'Y';
            END IF;
         END IF;

         /* End of Remark 14 */

         -- End of RFC 188 additions
          /* Get the appropriate address for the student */
         IF v_corres_dest = 'T'
         THEN
            /* Retrieve Student Term Address ( Result one record ) */
            BEGIN
               SELECT house_no_name, addr_l1, addr_l2,
                      addr_l3, addr_l4, post_code,
                      mailsort
                 INTO i_stud_house_no_name, i_stud_addr_l1, i_stud_addr_l2,
                      i_stud_addr_l3, i_stud_addr_l4, i_stud_post_code,
                      i_stud_mailsort
                 FROM sgas.stud_term_addr
                WHERE stud_ref_no = i_stud_ref_no AND end_date IS NULL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  ROLLBACK;
                  RETURN (   'No current term address for student '
                          || TO_CHAR (i_stud_ref_no)
                         );
               WHEN TOO_MANY_ROWS
               THEN
                  ROLLBACK;
                  RETURN (   'Multiple term addresses for student '
                          || TO_CHAR (i_stud_ref_no)
                         );
            END;
         ELSE
            /* Retrieve Student Present Home Address ( Result one record ) */
            BEGIN
               SELECT house_no_name, addr_l1, addr_l2,
                      addr_l3, addr_l4, post_code,
                      mailsort
                 INTO i_stud_house_no_name, i_stud_addr_l1, i_stud_addr_l2,
                      i_stud_addr_l3, i_stud_addr_l4, i_stud_post_code,
                      i_stud_mailsort
                 FROM sgas.stud_home_addr
                WHERE stud_ref_no = i_stud_ref_no AND end_date IS NULL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  ROLLBACK;
                  RETURN (   'No current home address for student '
                          || TO_CHAR (i_stud_ref_no)
                         );
               WHEN TOO_MANY_ROWS
               THEN
                  ROLLBACK;
                  RETURN (   'Multiple home addresses for student '
                          || TO_CHAR (i_stud_ref_no)
                         );
            END;
         END IF;

         /* End of address section */

         /* Retrieve the fee amounts */
         BEGIN
            v_fees_exist := TRUE;

            SELECT award_id, NVL (amount, 0),
                   NVL (contrib_amount, 0) + NVL (recovered_amount, 0),
                   NVL (net_amount, 0) - NVL (overpayment_amount, 0)
              -- added op amount for RFC 188 TR 859
            INTO   v_fee_award_id, i_fee_amount,
                   i_you_pay_fees,
                   i_we_pay_fees
              FROM sgas.award
             WHERE stud_crse_year_id = i_stud_crse_year_id
               AND award_src = 'T'
               AND amount > 0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               -- For dearing B and E we need to show the amount payable by the agency as 0
               IF    (i_dearing_status IN ('B', 'E') AND v_award_given != 'E'
                     )
                  OR (i_dearing_status = 'G')
               THEN              -- G added for RFC 188 - reordered for TR 862
                  v_fees_exist := TRUE;
                  i_fee_amount := 1;
                  i_you_pay_fees := 0;
                  i_we_pay_fees := 0;
               ELSE
                  v_fees_exist := FALSE;
                  i_fee_amount := NULL;
                  i_you_pay_fees := NULL;
                  i_we_pay_fees := NULL;
               END IF;
            WHEN TOO_MANY_ROWS
            THEN
               ROLLBACK;
               RETURN (   'Multiple AWARD records where AWARD_SRC = T for stud_crse_year_id '
                       || TO_CHAR (i_stud_crse_year_id)
                      );
         END;

         /* Get loan amount */
         SELECT SUM (net_amount)
           INTO i_loan_amount
           FROM sgas.award
          WHERE stud_crse_year_id = i_stud_crse_year_id
            AND award_types.loan_award@grass (stud_award_type) = 'Y';

         /* Get loan entitlement amount */
         SELECT SUM (net_amount + unclaimed_loan)
           INTO i_max_loan
           FROM sgas.award
          WHERE stud_crse_year_id = i_stud_crse_year_id
            AND award_types.loan_award@grass (stud_award_type) = 'Y';

         /* Get award remaining amount */
         SELECT SUM (awi.net_amount)
           INTO i_remaining_amount
           FROM sgas.award a, sgas.award_instalment awi
          WHERE a.stud_crse_year_id = i_stud_crse_year_id
            AND a.award_id = awi.award_id
            AND (   (    awi.returned = 'N'
                     AND awi.recalc = 'N'
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
                     AND awi.recovered_amount = 0
                     AND awi.contrib_amount = 0
                    )
                )
            AND (    a.stud_award_type IS NOT NULL
                 AND a.stud_award_type NOT IN
                        ('UGTE', 'UGLTE', 'PSTE', 'PSLTE', 'SNPE', 'PSDSA',
                         'SSDSA', 'UGDSA', 'ADHOC', 'UGNL', 'UGNFL', 'UGML',
                         'UGMFL', 'UGHNL', 'UGHNFL', 'UCNL', 'UCNFL', 'UCML',
                         'UCMFL', 'UCHNL', 'UCHNFL', 'UDNL', 'UDNFL', 'UDML',
                         'UDMFL', 'UDHNL', 'UDHNFL', 'UDNXL', 'UENL', 'UENFL',
                         'UEML', 'UEMFL', 'SNBDSA', 'PTL', 'UGADJ', 'SNADJ',
                         'PSADJ', 'SSADJ', 'SNBDSA')
                );

         /* Set the flags for the fixed remarks */
         /* FS1 */
         IF    v_award_given IN ('A', 'B', 'C', 'D')
            OR i_dearing_status = c_part_time
         THEN
            vfs1 := 'N';
         ELSE
            vfs1 := 'Y';
         END IF;

         /* End of FS1 */

         /* FS2 */
         IF    v_award_given IN ('A', 'B', 'C', 'D')
            OR i_dearing_status = c_part_time
         THEN
            vfs2 := 'N';
         ELSE
            vfs2 := 'Y';
         END IF;

         /* End of FS2 */

         /* FS3 - Not printed for part time students */
         IF i_dearing_status != c_part_time
         THEN
            vfs3 := 'Y';
         ELSE
            vfs3 := 'N';
         END IF;

         /* End of FS3 */

         /* FS4 - Not printed for part time students */
         IF i_dearing_status != c_part_time
         THEN
            vfs4 := 'Y';
         ELSE
            vfs4 := 'N';
         END IF;

         /* End of FS4 */

         /* FS5 - Not printed for part time students */
         IF i_dearing_status != c_part_time
         THEN
            vfs5 := 'Y';
         ELSE
            vfs5 := 'N';
         END IF;

         /* End of FS5 */

         /* FS6 - Not printed for part time students */
         IF i_dearing_status != c_part_time
         THEN
            vfs6 := 'Y';
         ELSE
            vfs6 := 'N';
         END IF;

         /* End of FS6 */

         /* FS7 - Not printed for part time students */
         IF i_dearing_status != c_part_time
         THEN
            vfs7 := 'Y';
         ELSE
            vfs7 := 'N';
         END IF;

         /* End of FS7 */

         /* FS8 - Not printed for part time or NMSB students */
         IF i_dearing_status != c_part_time AND v_scheme != 'B'
         THEN
            vfs8 := 'Y';
         ELSE
            vfs8 := 'N';
         END IF;

         /* End of FS8 */

         /* FS9 - Only printed for NMSB students */
         IF v_scheme = 'B'
         THEN
            vfs9 := 'Y';
         ELSE
            vfs9 := 'N';
         END IF;

         /* End of FS9 */
         /* End of fixed remarks */
         INSERT INTO rep_msteps_loa_stud
                     (stud_crse_year_id, issue_date, style,
                      duplicate, stud_ref_no, title,
                      initials, surname, forename,
                      house_no_name, addr_l1, addr_l2,
                      addr_l3, addr_l4, post_code,
                      mailsort, emp_tel_ext, dearing_status,
                      inst_name, crse_name, crse_year_no, saas_ref,
                      slc_ref, session_code, independent,
                      remaining_amount, parent_cont, spouse_cont,
                      student_cont, sponsor_cont, resid_par_cont,
                      resid_spouse_cont, resid_stud_cont,
                      resid_sponsor_cont, overpayment_recovered,
                      caseworker_name, scheme_type, ja_stud_tot,
                      overpayment, pams, fs1, fs2, fs3, fs4, fs5,
                      fs6, fs7, fs8, fs9, rem1, rem2, rem3, rem4,
                      rem5, rem6, rem7, rem8, rem9, rem10, rem11,   -- RFC 188
                      rem12,                                        -- RFC 188
                            rem13,                                  -- RFC 188
                                  rem14,                   -- Monthly Payments
                                        rem_adhoc,                  -- SIR 262
                                                  loan_assessed_only
                     )                                   -- Added for RFC 113D
              VALUES (i_stud_crse_year_id, i_issue_date, c_style,
                      i_duplicate, i_stud_ref_no, i_stud_title,
                      i_stud_initials, i_stud_surname, i_stud_forenames,
                      i_stud_house_no_name, i_stud_addr_l1, i_stud_addr_l2,
                      i_stud_addr_l3, i_stud_addr_l4, i_stud_post_code,
                      i_stud_mailsort, i_emp_tel_ext, i_dearing_status,
                      i_inst_name, i_crse_name, i_crse_year_no, i_saas_ref,
                      i_slc_ref_no, i_session_code, i_independent,
                      i_remaining_amount, i_parent_cont, i_spouse_cont,
                      i_student_cont, i_sponsor_cont, i_resid_par_cont,
                      i_resid_spouse_cont, i_resid_stud_cont,
                      i_resid_sponsor_cont, i_op_recovered,
                      i_caseworker_name, v_scheme, v_no_ja_studs_tot,
                      i_overpayment, i_pams, vfs1, vfs2, vfs3, vfs4, vfs5,
                      vfs6, vfs7, vfs8, vfs9, vrem1, vrem2, vrem3, vrem4,
                      vrem5, vrem6, vrem7, vrem8, vrem9, vrem10, vrem11,
                      -- RFC 188
                      vrem12,                                       -- RFC 188
                             vrem13,                                -- RFC 188
                                    vrem14,                 --Monthly Payments
                                           v_remark,                -- SIR 262
                                                    'N'
                     );                                   -- Added for RFC113D

         OPEN cur_awd (i_stud_crse_year_id);

         LOOP
            FETCH cur_awd
             INTO v_award_id, i_stud_award_type, i_descript, i_net_amount;

            EXIT WHEN cur_awd%NOTFOUND;

            /* Insert the award record */
            INSERT INTO rep_msteps_loa_award
                        (stud_crse_year_id, issue_date,
                         stud_award_type, descript, net_amount
                        )
                 VALUES (i_stud_crse_year_id, i_issue_date,
                         i_stud_award_type, i_descript, i_net_amount
                        );
         END LOOP;

         CLOSE cur_awd;

         /* Insert the tuition fee record if one exists */
         IF v_fees_exist
         THEN
            INSERT INTO rep_msteps_loa_award
                        (stud_crse_year_id, issue_date, descript,
                         net_amount, we_pay_fees, you_pay_fees
                        )
                 VALUES (i_stud_crse_year_id, i_issue_date, 'FEE',
                         i_fee_amount, i_we_pay_fees, i_you_pay_fees
                        );
         END IF;

         /* Insert the loan record if loan details exist and a loan has been claimed (i.e. both amounts are > 0) */
         IF NVL (i_loan_amount, 0) > 0 AND NVL (i_max_loan, 0) > 0
         THEN
            IF i_dearing_status = 'O'
            THEN                                     --Monthly Payments START
               v_loan_text := 'LOAN';
            ELSE
               v_loan_text := 'LOAN FOR LIVING COSTS';
            END IF;                                     --Monthly Payments END

            INSERT INTO rep_msteps_loa_award
                        (stud_crse_year_id, issue_date, descript,
                         net_amount, max_loan
                        )
                 VALUES (i_stud_crse_year_id, i_issue_date, v_loan_text,
                         -- RFC 188 -- MP
                         i_loan_amount, i_max_loan
                        );
         END IF;

         /* RFC 113D Update REP_MSTEPS_LOA_STUD
         where student is loan assessed only
         so barcode is printed on LOA */
         IF NVL (i_loan_amount, 0) = 0 AND NVL (i_max_loan, 0) > 0
         THEN
            UPDATE rep_msteps_loa_stud
               SET loan_assessed_only = 'Y'
             WHERE stud_crse_year_id = i_stud_crse_year_id;
         END IF;

         /* Write details of unpaid instalments */
         OPEN cur_awi_unpaid (i_stud_crse_year_id);

         LOOP
            FETCH cur_awi_unpaid
             INTO i_payment_due_date, i_payment_method, i_payment_addr,
                  v_campus_id, i_sum_awi_net_amount;

            EXIT WHEN cur_awi_unpaid%NOTFOUND;

            /* Establish the payee name */
            IF i_payment_addr = c_nominee
            THEN
               i_payee_name := i_nom_name;
            ELSIF i_payment_addr = c_campus
            THEN
               SELECT NAME
                 INTO i_payee_name
                 FROM campus@grass
                WHERE campus_id = v_campus_id;
            END IF;

            -- Only insert the payment record if > 0
            IF NVL (i_sum_awi_net_amount, 0) > 0
            THEN
               INSERT INTO rep_msteps_loa_payments
                           (stud_crse_year_id, net_amount,
                            payment_due_date, payment_method_ind,
                            sort_code,
                            account_no,
                            build_soc_no,
                            payment_addr, payee_name
                           )
                    VALUES (i_stud_crse_year_id, i_sum_awi_net_amount,
                            i_payment_due_date, i_payment_method,
                            DECODE (i_payment_method,
                                    c_bacs, i_sort_code,
                                    NULL
                                   ),
                            DECODE (i_payment_method,
                                    c_bacs, i_account_no,
                                    NULL
                                   ),
                            DECODE (i_payment_method,
                                    c_bacs, i_build_soc_no,
                                    NULL
                                   ),
                            i_payment_addr, i_payee_name
                           );
            END IF;
         END LOOP;

         CLOSE cur_awi_unpaid;

         /* End of unpaid instalments */

         /* Write details of paid instalments */
         OPEN cur_awi_paid (i_stud_crse_year_id);

         LOOP
            FETCH cur_awi_paid
             INTO i_payment_due_date, i_payment_method, i_payment_addr,
                  i_payee_name, i_paid_account_no, i_paid_sort_code,
                  i_paid_build_soc_no, v_source_ref, i_sum_awi_net_amount;

            EXIT WHEN cur_awi_paid%NOTFOUND;

            -- If payment is to a campus, get the name using the campus ID held in the source ref column
            IF i_payment_addr = 'C'
            THEN
               SELECT NAME
                 INTO i_payee_name
                 FROM campus@grass
                WHERE campus_id = v_source_ref;
            END IF;

            -- Only insert the payment record if > 0
            IF NVL (i_sum_awi_net_amount, 0) > 0
            THEN
               /* Insert the record */
               INSERT INTO rep_msteps_loa_payments
                           (stud_crse_year_id, net_amount,
                            payment_due_date, payment_method_ind,
                            sort_code, account_no,
                            build_soc_no, payment_addr, payee_name
                           )
                    VALUES (i_stud_crse_year_id, i_sum_awi_net_amount,
                            i_payment_due_date, i_payment_method,
                            i_paid_sort_code, i_paid_account_no,
                            i_paid_build_soc_no, i_payment_addr, i_payee_name
                           );
            END IF;
         END LOOP;

         CLOSE cur_awi_paid;

         /* End of paid instalments */

         /* Update the sent date etc */
         IF p_stud_crse_year_id = 0
         THEN
            UPDATE sgas.stud_crse_year
               SET sal_sent = 'Y',
                   sal_sent_date = i_issue_date,
                   award_letter_no = award_letter_no + 1,
                   first_sal_date =
                      DECODE (first_sal_date,
                              NULL, i_issue_date,
                              first_sal_date
                             )
             WHERE ROWID = v_scy_rid;
         END IF;
      END LOOP;

      /* Close the appropriate cursor */
      IF p_stud_crse_year_id = 0
      THEN
         CLOSE loa_cron_curs;
      ELSE
         CLOSE loa_single_curs;
      END IF;

      COMMIT;
      RETURN ('OK');
   EXCEPTION
      WHEN OTHERS
      THEN
         IF p_stud_crse_year_id = 0
         THEN
            ROLLBACK;
         ELSE
            COMMIT;
         END IF;

         RETURN (   'Fatal error in POP_STEPSLOA, sqlcode = '''
                 || TO_CHAR (SQLERRM)
                 || ''' stud_crse_year_id = '
                 || TO_CHAR (i_stud_crse_year_id)
                );
--
   END pop_stepsloa;

--
--
--
   PROCEDURE clear_temp_tab
   IS
   BEGIN
      COMMIT;
      SET TRANSACTION USE ROLLBACK SEGMENT rbs1;

      INSERT INTO rep_msteps_hist_loa_payments
         (SELECT *
            FROM rep_msteps_loa_payments);

      INSERT INTO rep_msteps_hist_loa_award
         (SELECT *
            FROM rep_msteps_loa_award);

      INSERT INTO rep_msteps_hist_loa_stud
         (SELECT *
            FROM rep_msteps_loa_stud);

--
      DELETE FROM rep_msteps_loa_payments;

      DELETE FROM rep_msteps_loa_award;

      DELETE FROM rep_msteps_loa_stud;

      COMMIT;
--
   END clear_temp_tab;
--
--
END pop_stepsloa; 
/

