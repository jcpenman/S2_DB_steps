CREATE OR REPLACE PACKAGE BODY SGAS.ed7_download
IS
--
-- SCCS IDENTIFICATION STRING
-- ==========================
-- @(#) ed7_download_b.sql 10/05/99 10:02:29 1.5@(#)
--
-- DESCRIPTION
-- ===========
--
-- creates c.s.v file holding session specific statistical information
--
--
   PROCEDURE create_csv_file (
      param_file_name      IN       VARCHAR2,
      param_session_code   IN       stud_session.session_code%TYPE,
      param_scheme_type    IN       VARCHAR2,
      success_fail         OUT      VARCHAR2,
      start_finish         OUT      VARCHAR2,
      error_msg            OUT      VARCHAR2,
      number_of_records    OUT      VARCHAR2
   )
   IS
      hreport                         UTL_FILE.file_type;
      c_eu_flag                       CHAR (1);
      c_withdrawn_case                CHAR (1);
      c_dummy                         CHAR (1);
      c_applies_value                 CHAR (1);
      c_sosb_applies_value            CHAR (1);                    -- RFC 219
      c_value                         CHAR (1);
      v_path_name                     VARCHAR2 (100);
      v_file_name                     VARCHAR2 (100);
      v_sql_message                   VARCHAR2 (2000);
      v_location_ind                  inst.location_ind%TYPE;
      v_pams_course                   crse.pams_course%TYPE;
      v_split_session                 crse_year.split_session%TYPE;
      v_crse_type                     crse_year.crse_type%TYPE;
      v_default_terms                 crse_year.default_terms%TYPE;
      v_qual_type                     crse.qual_type%TYPE;
      d_term_date                     DATE;
      d_start_date                    DATE;
      d_finish_date                   DATE;
      n_sql_code                      NUMBER;
      n_linked_jas                    NUMBER;
      n_student_contribution          NUMBER;
      n_spouse_contribution           NUMBER;
      n_parent_contribution           NUMBER;
      n_resid_par_contribution        NUMBER;
      n_resid_spouse_contribution     NUMBER;
      n_resid_stud_contribution       NUMBER;
      n_inst_type_id                  inst.inst_type_id%TYPE;
      n_number_of_terms               NUMBER;
      n_adjust_amount                 adjust.amount%TYPE;
      n_fee_adjust_amount             adjust.amount%TYPE;          -- RFC 219
      n_debt_amount                   adjust.amount%TYPE;
      n_fee_debt_amount               adjust.amount%TYPE;          -- RFC 219
      n_repayment_amount              adjust.amount%TYPE;
      n_fee_repayment_amount          adjust.amount%TYPE;          -- RFC 219
      n_instalment_net_amount         award_instalment.net_amount%TYPE;
      n_fee_instalment_net_amount     award_instalment.net_amount%TYPE;
      -- RFC 219
      n_instalment_net_awarded        NUMBER;
      n_instalment_net_amount_paid    NUMBER;
      n_instalment_amount             NUMBER;
      n_fee_instalment_amount         NUMBER;                      -- RFC 219
      n_award_amount                  award.amount%TYPE;
      n_award_net_amount              award.net_amount%TYPE;
      n_non_tuition_fee_id            award.non_tuition_fee_id%TYPE;
      n_total_amount                  NUMBER;
      n_total_net_amount              NUMBER;
      n_total_instalment_net_amount   NUMBER;
      n_session_code                  stud_session.session_code%TYPE;
      n_records                       NUMBER;
      e_stop_processing               EXCEPTION;
      v_sma_applies                   VARCHAR2 (1);
      v_temp1                         VARCHAR2 (1);
      v_temp2                         VARCHAR2 (1);
      v_scottish_cand                 stud.scottish_cand%TYPE;
      v_study_country                 country.short_name%TYPE;
      v_study_abroad                  stud_crse_year.study_abroad%TYPE;
      v_start_abroad_date             stud_crse_year.start_date_abroad%TYPE;
      v_end_abroad_date               stud_crse_year.end_date_abroad%TYPE;
      v_country_residence             country.short_name%TYPE;
      v_pt_loan_check                 stud_session.pt_loan_check%TYPE;
      v_pt_loan_claimed               stud_session.pt_loan_claimed%TYPE;
      v_max_loan_requested            stud_session.max_loan_requested%TYPE;
      v_sum_unclaimed_loan            award_instalment.unclaimed_loan%TYPE;
      v_default_term                  crse_year.default_terms%TYPE;
      v_cont_count                    NUMBER;
      v_post_code                     stud_home_addr.post_code%TYPE;
      v_first_calc_date               DATE;
      v_location                      inst.location_ind%TYPE;
      v_dependant_count               NUMBER;
      v_ben_dep_count                 NUMBER;
      v_ben1_dep_count                NUMBER;
      v_ben2_dep_count                NUMBER;
      v_age                           NUMBER;
      v_relation                      benefactor_dependant.relation_type_id%TYPE;
      v_study_country_code            stud_crse_year.study_country%TYPE;
      v_residence_country_code        stud.residence_country_code%TYPE;
      v_amount                        NUMBER;
      v_net_amount                    NUMBER;
      v_awi_net_amount                NUMBER;
      v_count                         NUMBER;
      v_tot_loan_award                NUMBER;
      v_tot_net_award                 NUMBER;
      v_tot_unclaim_award             NUMBER;
      c_187_applies_value             VARCHAR2 (1);
      ca_187_applies_value            VARCHAR2 (1);
      c_191_applies_value             VARCHAR2 (1);
      c_195_applies_value             VARCHAR2 (1);
      c_199_applies_value             VARCHAR2 (1);
      c_203_applies_value             VARCHAR2 (1);
      v_188_amount                    NUMBER;
      va_188_amount                   NUMBER;
      v_189_net_amount                NUMBER;
      va_189_net_amount               NUMBER;
      v_190_awi_net_amount            NUMBER;
      va_190_awi_net_amount           NUMBER;
      v_192_amount                    NUMBER;
      v_193_net_amount                NUMBER;
      v_194_awi_net_amount            NUMBER;
      v_196_amount                    NUMBER;
      v_197_net_amount                NUMBER;
      v_198_awi_net_amount            NUMBER;
      v_200_amount                    NUMBER;
      v_201_net_amount                NUMBER;
      v_202_awi_net_amount            NUMBER;
      v_206_net_amount                NUMBER;
      v_sosb_amount                   NUMBER;                      -- RFC 219
      v_sosb_net_amount               NUMBER;                      -- RFC 219
      v_sosb_awi_net_amount           NUMBER;                      -- RFC 219
      d_start_term_date               DATE;
      v_ref                           VARCHAR2 (255);
      v_crse_id                       VARCHAR2 (255);
      x                               NUMBER;
      v_award_type_descript           award.award_type_descript%TYPE;
      v_birth_country                 stud.birth_country_code%TYPE;
      v_nation_country_code           stud.nation_country_code%TYPE;
      v_short_app_sent_date           stud_session.short_app_sent_date%TYPE;
      v_short_app_rec_date            stud_session.short_app_rec_date%TYPE;
      --RFC 219
      v_short_app_sent_type           VARCHAR2 (1);                 --RFC 219
      v_web_user_id                   stud.web_user_id%TYPE;       -- RFC 219
      v_email_addr                    stud.email_addr%TYPE;        -- RFC 219
      v_app_rec_type                  VARCHAR2 (1);                 --RFC 219
      v_max_fee_loan                  NUMBER;                        --RFC219
      v_temp_sandwich                 VARCHAR2 (1);                  --RFC219
      v_temp_unpaid_sandwich          VARCHAR2 (1);                  --RFC219
      v_temp_crse_year_id             crse_year.crse_year_id%TYPE;   --RFC219
      c_38_applies_value              CHAR (1);                      --RFC219
      c_45_applies_value              CHAR (1);                      --RFC219
      lv_field_number                 VARCHAR2 (100)                  := NULL;
      lv_stud_ref_no                  NUMBER (10)                     := NULL;

      CURSOR c1
      IS
         SELECT   stud_crse_year_id, stud_ref_no, crse_year_id,
                  application_status, award,
                  DECODE (scheme_type, NULL, 'U', scheme_type) scheme_type,
                  entered_date, parent_contrib_exempt, dearing,
                  provisional_case, stud_cont, inst_code,
                  NVL (crse_code, '0') crse_code,
                  NVL (crse_year_no, '0') crse_year_no, crse_id,
                  disablement_code, erasmus, withdraw_date, paid_sandwich,
                  unpaid_sandwich, snb_rate, self_funding, pgce
             FROM stud_crse_year
            WHERE session_code = param_session_code
              AND (   (param_scheme_type = 'B' AND scheme_type = 'B')
                   OR (    param_scheme_type IS NULL
                       AND DECODE (scheme_type, NULL, 'U', scheme_type) IN
                                                              ('U', 'P', 'S')
                      )
                  )
              AND latest_crse_ind = 'Y'
         ORDER BY stud_ref_no DESC;

      CURSOR c2 (param_stud_ref_no stud.stud_ref_no%TYPE)
      IS
         SELECT dob, sex, marital_status, scottish_cand, ni_no,
                payment_method
           FROM stud
          WHERE stud_ref_no = param_stud_ref_no;

      CURSOR c3 (param_stud_ref_no stud.stud_ref_no%TYPE)
      IS
         SELECT location_ind
           FROM stud_term_addr
          WHERE stud_ref_no = param_stud_ref_no
            AND (   TRUNC (d_term_date) BETWEEN TRUNC (start_date)
                                            AND TRUNC (end_date)
                 OR     TRUNC (d_term_date) >= TRUNC (start_date)
                    AND end_date IS NULL
                );

      CURSOR c4 (param_stud_ref_no stud.stud_ref_no%TYPE)
      IS
         SELECT ja_case_id, DECODE (ja_case_id, NULL, 0, 1) ja_case_ind,
                date_applic_received, ben1_id, ben1_rel_id, ben2_id,
                ben2_rel_id, ja_stud_type, smg_entitlement,
                loan_declaration_date, max_fee_loan_requested,
                fee_loan_declaration_date
           FROM stud_session
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code;

      CURSOR c5 (param_ja_case_id stud_session.ja_case_id%TYPE)
      IS
         SELECT no_saas_students
           FROM ja_case
          WHERE ja_case_id = param_ja_case_id
            AND session_code = param_session_code;

      CURSOR c6 (
         param_stud_ref_no   stud.stud_ref_no%TYPE,
         param_ja_case_id    stud_session.ja_case_id%TYPE
      )
      IS
         SELECT COUNT (*) no_of_withdrawn_cases
           FROM stud_session
          WHERE ja_case_id = param_ja_case_id
            AND session_code = param_session_code
            AND EXISTS (
                   SELECT NULL
                     FROM stud_crse_year
                    WHERE latest_crse_ind = 'Y'
                      AND stud_session_id = stud_session.stud_session_id
                      AND withdraw_date IS NOT NULL);

      CURSOR c7 (
         param_stud_crse_year_id   stud_crse_year.stud_crse_year_id%TYPE
      )
      IS
         SELECT tuition_fee_type_code
           FROM award
          WHERE stud_crse_year_id = param_stud_crse_year_id
            AND session_code = param_session_code
            AND award_src = 'T';

      CURSOR c7a (param_stud_ref_no award.stud_ref_no%TYPE)
      IS
         SELECT award.stud_crse_year_id, award.net_amount,
                stud_crse_year.dearing
           FROM award, stud_crse_year
          WHERE award.stud_ref_no = param_stud_ref_no
            AND award.session_code = param_session_code
            AND award.award_src = 'T'
            AND award.amount > 0
            AND award.stud_crse_year_id = stud_crse_year.stud_crse_year_id;

      CURSOR c7b (param_stud_ref_no award.stud_ref_no%TYPE)
      IS
         SELECT award.stud_crse_year_id
           FROM award, stud_crse_year
          WHERE award.stud_ref_no = param_stud_ref_no
            AND award.session_code = param_session_code
            AND award.award_src = 'T'
            AND award.amount > 0
            AND award.stud_crse_year_id = stud_crse_year.stud_crse_year_id
            AND stud_crse_year.dearing = 'G';

      CURSOR c8 (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT SUM (amount) amount, SUM (net_amount) net_amount
           FROM award, stud_crse_year
          WHERE award.stud_ref_no = param_stud_ref_no
            AND award.session_code = param_session_code
            AND award.award_src = 'T'
            AND award.stud_crse_year_id = stud_crse_year.stud_crse_year_id
            AND stud_crse_year.dearing <> 'G';

      CURSOR c8a (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT SUM (amount) amount, SUM (net_amount) net_amount
           FROM award, stud_crse_year
          WHERE award.stud_ref_no = param_stud_ref_no
            AND award.session_code = param_session_code
            AND award.award_src = 'T'
            AND award.stud_crse_year_id = stud_crse_year.stud_crse_year_id
            AND stud_crse_year.dearing = 'G';

      CURSOR c9 (
         param_stud_crse_year_id   stud_crse_year.stud_crse_year_id%TYPE
      )
      IS
         SELECT 'C'
           FROM award
          WHERE stud_crse_year_id = param_stud_crse_year_id
                AND award_src = 'C';

      CURSOR c10 (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type IN
                     ('UGSMA', 'UGSMAB', 'UGSMAH', 'PSSMAB', 'PSSMA', 'SSMA');

      CURSOR c10a (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type IN ('SNB');

      CURSOR c11 (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type IN ('UGMSA', 'PSMSA');

      CURSOR c11a (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type IN ('SNIE');

      CURSOR c12 (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type IN ('SSDA', 'PSDA', 'UGDA');

      CURSOR c12a (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type IN ('SNDA');

      CURSOR c13 (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type IN ('SSOA', 'PSOA', 'UGOA');

      CURSOR c13a (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type IN ('SNSPA');

      CURSOR c14 (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type IN ('UG2HM', 'PS2HM');

--C15 altered as part of SIR 1442.  PB 08/10/2003
      CURSOR c15 (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award, award_instalment aw
          WHERE award.stud_ref_no = param_stud_ref_no
            AND award.session_code = param_session_code
            AND award.award_src = 'A'
            AND award.award_id = aw.award_id
            AND NVL (aw.dsa_fee_instalment, 'N') = 'Y'
            AND award.stud_award_type IN ('SSDSA', 'PSDSA', 'UGDSA')
            AND NVL (aw.payment_status, 'X') <> 'R'
            AND aw.recalc <> 'Y'
            AND aw.returned <> 'Y';

      CURSOR c16 (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type IN ('UGTE', 'PSTE', 'UGLTE', 'PSLTE');

      CURSOR c16a (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type IN ('SNPE');

      CURSOR c17 (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type IN ('SSADJ', 'PSADJ', 'UGADJ');

      CURSOR c17a (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type IN ('SNADJ');

      CURSOR c18 (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type = 'ADHOC';

      CURSOR c19 (
         cp_inst_code   IN   stud_crse_year.inst_code%TYPE,
         cp_crse_code        stud_crse_year.crse_code%TYPE
      )
      IS
         SELECT pams_course
           FROM crse
          WHERE inst_code = cp_inst_code AND crse_code = cp_crse_code;

      CURSOR c20 (
         cp_stud_ref_no    IN   stud_crse_year.stud_ref_no%TYPE,
         cp_stud_crse_id   IN   stud_crse_year.stud_crse_year_id%TYPE
      )
      IS
         SELECT SUM (stud_cont) stud_cont, SUM (spouse_cont) spouse_cont,
                SUM (parent_cont) parent_cont,
                SUM (resid_par_cont) resid_par_cont,
                SUM (resid_spouse_cont) resid_spouse_cont,
                SUM (resid_stud_cont) resid_stud_cont
           FROM stud_crse_year
          WHERE stud_ref_no = cp_stud_ref_no
            AND session_code = param_session_code
            AND stud_crse_year_id = cp_stud_crse_id;

      CURSOR c21 (cp_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT SUM (stud_cont) stud_cont, SUM (spouse_cont) spouse_cont,
                SUM (parent_cont) parent_cont,
                SUM (resid_par_cont) resid_par_cont,
                SUM (resid_spouse_cont) resid_spouse_cont,
                SUM (resid_stud_cont) resid_stud_cont
           FROM stud_crse_year
          WHERE stud_ref_no = cp_stud_ref_no
            AND session_code = param_session_code;

      CURSOR c22 (cp_crse_id IN crse.crse_id%TYPE)
      IS
         SELECT ge_liable, qual_type, crse_code
           FROM crse
          WHERE crse_id = cp_crse_id;

      CURSOR c23 (cp_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT   TRUNC ((MONTHS_BETWEEN (TRUNC (SYSDATE), dob)) / 12) dob,
                  relation_id
             FROM stud_dependant
            WHERE session_code = param_session_code
              AND stud_ref_no = cp_stud_ref_no
              AND NVL (include, 'N') = 'Y'
         ORDER BY 1 ASC;

      CURSOR c24 (cp_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT   TRUNC ((MONTHS_BETWEEN (TRUNC (SYSDATE), dob)) / 12) dob,
                  relation_type_id
             FROM benefactor_dependant
            WHERE ben_id IN (
                     SELECT ben1_id
                       FROM stud_session
                      WHERE session_code = param_session_code
                        AND stud_ref_no = cp_stud_ref_no)
         ORDER BY 1 ASC;

      CURSOR c25 (cp_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT   TRUNC ((MONTHS_BETWEEN (TRUNC (SYSDATE), dob)) / 12) dob,
                  relation_type_id
             FROM benefactor_dependant
            WHERE ben_id IN (
                     SELECT ben2_id
                       FROM stud_session
                      WHERE session_code = param_session_code
                        AND stud_ref_no = cp_stud_ref_no)
         ORDER BY 1 ASC;

      CURSOR c26 (cp_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = cp_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type = 'YSB';

      CURSOR c26a (cp_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = cp_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type = 'ISB';

      CURSOR c27 (cp_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = cp_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type = 'YSO';

      CURSOR cu_sosb (cp_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = cp_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type = 'SOSB';

      CURSOR c28 (cp_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = cp_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type = 'LPCG';

      CURSOR c29 (cp_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = cp_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type = 'SMG';

      CURSOR c30 (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT COUNT (*) COUNT
           FROM award, award_instalment awi
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'A'
            AND stud_award_type IN ('SSDSA', 'PSDSA', 'UGDSA')
            AND award.award_id = awi.award_id
            AND NVL (awi.dsa_fee_instalment, 'N') = 'N'
            AND NVL (awi.payment_status, 'X') <> 'R'
            AND awi.recalc <> 'Y'
            AND awi.returned <> 'Y';

--C31 added as part of SIR 1442.  PB 08/10/2003
      CURSOR c31 (param_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT SUM (awi.amount) amount, SUM (awi.net_amount) net_amount
           FROM award, award_instalment awi
          WHERE stud_ref_no = param_stud_ref_no
            AND session_code = param_session_code
            AND stud_award_type IN ('SSDSA', 'PSDSA', 'UGDSA')
            AND award.award_id = awi.award_id
            AND NVL (awi.dsa_fee_instalment, 'N') = 'N'
            AND NVL (awi.payment_status, 'X') <> 'R'
            AND awi.recalc <> 'Y'
            AND awi.returned <> 'Y';

      CURSOR cu_stud_crse_year (cp_stud_crse_year_id IN NUMBER)
      IS
         SELECT snb_rate
           FROM stud_crse_year
          WHERE stud_crse_year_id = cp_stud_crse_year_id;

      rec_stud_crse_year              cu_stud_crse_year%ROWTYPE;

      --RFC 219
      CURSOR cu_edm_images (param_stud_ref_no edm_images.stud_ref_no%TYPE)
      IS
         SELECT   batch_type_code, document_type_code, attachment_type_code,
                  upload_date
             FROM edm_images
            WHERE stud_ref_no = param_stud_ref_no
              AND session_code = param_session_code
              AND (   document_type_code LIKE ('%SAS%')
                   OR document_type_code LIKE ('%APP%')
                   OR document_type_code LIKE ('%MAN%')
                   OR document_type_code LIKE ('%NMSB%')
                  )
         ORDER BY upload_date ASC;

      rec_edm_images                  cu_edm_images%ROWTYPE;        -- RFC 219

      CURSOR c32 (
         p_stud_crse_year_id   IN   stud_crse_year.stud_crse_year_id%TYPE
      )
      IS
         SELECT scy.paid_sandwich, scy.unpaid_sandwich, cy.crse_year_id,
                cy.var_sandwich_tuition_fee_amnt, cy.req_tuition_fee,
                cy.var_tuition_fee_amnt
           FROM stud_crse_year scy, crse_year cy
          WHERE stud_crse_year_id = p_stud_crse_year_id
            AND scy.crse_year_id = cy.crse_year_id;

      CURSOR cu_edm_batch_type
      IS
         SELECT nval
           FROM config_data
          WHERE item_name LIKE 'ED7_BATCH_TYPE%';

      rec_edm_batch_type              cu_edm_batch_type%ROWTYPE;
      r2                              c2%ROWTYPE;
      r3                              c3%ROWTYPE;
      r4                              c4%ROWTYPE;
      r6                              c6%ROWTYPE;
      r7                              c7%ROWTYPE;
      r7a                             c7a%ROWTYPE;        -- Added for RFC 219
      r7b                             c7b%ROWTYPE;        -- Added for RFC 219
      r8                              c8%ROWTYPE;
      r8a                             c8a%ROWTYPE;        -- Added for RFC 219
      r19                             c19%ROWTYPE;
      r20                             c20%ROWTYPE;
      r21                             c21%ROWTYPE;
      r22                             c22%ROWTYPE;
      r23                             c23%ROWTYPE;
      r24                             c24%ROWTYPE;
      r25                             c25%ROWTYPE;
      r26                             c26%ROWTYPE;
      r26a                            c26a%ROWTYPE;
      r27                             c27%ROWTYPE;
      r28                             c28%ROWTYPE;
      r29                             c29%ROWTYPE;
      r30                             c30%ROWTYPE;
      r31                             c31%ROWTYPE;
      r32                             c32%ROWTYPE;                   --RFC 219
      rec_sosb                        cu_sosb%ROWTYPE;    -- Added for RFC 219
   BEGIN
      d_start_date := SYSDATE;
      success_fail := NULL;
      n_records := 0;
      -- date to use when finding term_addr record is always 15th April on the session year parameter + 1
      n_session_code := param_session_code + 1;
      d_term_date := TO_DATE ('15/04/' || n_session_code, 'DD/MM/YYYY');

      BEGIN
         SELECT cval
           INTO v_path_name
           FROM config_data
          WHERE item_name = 'ED7_DEST';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            success_fail := 'Fatal Error Detected';
            error_msg := 'ED7_DEST config_data item could not be found';
            RAISE e_stop_processing;
      END;

      BEGIN
         hreport := UTL_FILE.fopen (v_path_name, param_file_name, 'w');
      EXCEPTION
         WHEN OTHERS
         THEN
            success_fail := 'Fatal Error Detected';
            error_msg :=
               'Could not open output file.  Check that UTL_FILE parameter in INIT.ORA matches CONFIG_DATA value for ED7_DEST';
            RAISE e_stop_processing;
      END;

      --
      FOR r1 IN c1
      LOOP
         v_ref := r1.stud_ref_no;
         v_crse_id := r1.stud_crse_year_id;
         n_total_amount := 0;
         n_total_net_amount := 0;
         n_total_instalment_net_amount := 0;
         v_tot_loan_award := 0;
         v_tot_net_award := 0;
         v_tot_unclaim_award := 0;
         lv_stud_ref_no := r1.stud_ref_no;

         --
         -- Find stud record for current stud_crse_year
         OPEN c2 (r1.stud_ref_no);

         FETCH c2
          INTO r2;

         CLOSE c2;

/**********************************************************/
         IF NVL (param_scheme_type, 'x') <> 'B'
         THEN
            -- F and G added for RFC 219
            IF     param_session_code >= 1999
               AND r1.dearing IN ('B', 'P', 'C', 'D', 'Q', 'E', 'F', 'G')
               AND NOT (pk_steps_utils.check_pams (r1.inst_code, r1.crse_code)
                       )
               AND (pk_steps_utils.course_start_date (r1.stud_crse_year_id) <=
                                           pk_steps_utils.birthday_55 (r2.dob)
                   )
            THEN
               OPEN c20 (r1.stud_ref_no, r1.stud_crse_year_id);

               FETCH c20
                INTO r20;

               CLOSE c20;

               n_student_contribution := r20.stud_cont;
               n_spouse_contribution := r20.spouse_cont;
               n_parent_contribution := r20.parent_cont;
               n_resid_par_contribution := r20.resid_par_cont;
               n_resid_spouse_contribution := r20.resid_spouse_cont;
               n_resid_stud_contribution := r20.resid_stud_cont;
            ELSE
               OPEN c21 (r1.stud_ref_no);

               FETCH c21
                INTO r21;

               CLOSE c21;

               n_student_contribution := r21.stud_cont;
               n_spouse_contribution := r21.spouse_cont;
               n_parent_contribution := r21.parent_cont;
               n_resid_par_contribution := r21.resid_par_cont;
               n_resid_spouse_contribution := r21.resid_spouse_cont;
               n_resid_stud_contribution := r21.resid_stud_cont;
            END IF;

            IF n_student_contribution IS NULL
            THEN
               n_student_contribution := 0;
            END IF;

            IF n_resid_par_contribution IS NULL
            THEN
               n_resid_par_contribution := 0;
            END IF;

            IF n_resid_spouse_contribution IS NULL
            THEN
               n_resid_spouse_contribution := 0;
            END IF;

            IF n_resid_stud_contribution IS NULL
            THEN
               n_resid_stud_contribution := 0;
            END IF;

            --
            v_scottish_cand := r2.scottish_cand;

            --
            SELECT COUNT (*)
              INTO v_cont_count
              FROM stud_cont_details
             WHERE stud_ref_no = r1.stud_ref_no;

            --
            IF (r1.crse_year_id IS NULL) OR (r1.dearing = 'O')
            THEN
               n_number_of_terms := 0;
            ELSE
               BEGIN
                  SELECT default_terms
                    INTO v_default_terms
                    FROM crse_year
                   WHERE crse_year_id = r1.crse_year_id;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_default_terms := NULL;
               END;

               IF NVL (v_default_terms, 'x') = 'N'
               THEN
                  SELECT COUNT (*)
                    INTO n_number_of_terms
                    FROM crse_term
                   WHERE crse_year_id = r1.crse_year_id;
               ELSE
                  n_number_of_terms := 3;
               END IF;
            END IF;
         --
         ELSIF NVL (param_scheme_type, 'x') = 'B'
         THEN
            --
            OPEN cu_stud_crse_year (r1.stud_crse_year_id);

            FETCH cu_stud_crse_year
             INTO r1.award;

            CLOSE cu_stud_crse_year;

            --
            n_student_contribution := 0;
            n_spouse_contribution := 0;
            n_parent_contribution := 0;
            n_resid_par_contribution := 0;
            n_resid_spouse_contribution := 0;
            n_resid_stud_contribution := 0;
            --
            r1.parent_contrib_exempt := 'Y';
            --
            v_scottish_cand := 0;
            --
            r1.disablement_code := NULL;
            --
            v_cont_count := 0;
            --
            n_number_of_terms := 4;
            --
            r1.award := r1.snb_rate;
         END IF;

/************************************************************/

         -- Find stud_term_addr record for current stud_crse_year
         IF NVL (param_scheme_type, 'x') <> 'B'
         THEN
            OPEN c3 (r1.stud_ref_no);

            FETCH c3
             INTO r3;

            IF c3%NOTFOUND
            THEN
               -- If term address date does not exist for the date in question then
               -- default location indicator to 'M' for missing.
               r3.location_ind := 'M';
            END IF;

            CLOSE c3;
         ELSE
            r3.location_ind := 'M';
         END IF;

         -- Find stud_session record for current stud_crse_year
         OPEN c4 (r1.stud_ref_no);

         FETCH c4
          INTO r4;

         CLOSE c4;

         -- Field 1. Session code
         UTL_FILE.put (hreport, param_session_code || ',');
         lv_field_number := 1;
         -- Field 2. Stud_ref_no
         UTL_FILE.put (hreport, r1.stud_ref_no || ',');
         lv_field_number := 2;
         -- Field 3. Date of birth
         UTL_FILE.put (hreport, TO_CHAR (r2.dob, 'DD-MON-YYYY') || ',');
         lv_field_number := 3;
         -- Field 4. Sex
         UTL_FILE.put (hreport, r2.sex || ',');
         lv_field_number := 4;
         -- Field 5. Marital Status
         UTL_FILE.put (hreport, r2.marital_status || ',');
         lv_field_number := 5;
         -- Field 6. Location Ind
         UTL_FILE.put (hreport, r3.location_ind || ',');
         lv_field_number := 6;
         -- Field 7. JA Case
         UTL_FILE.put (hreport, r4.ja_case_ind || ',');
         lv_field_number := 7;

         IF r4.ja_case_id IS NULL
         THEN
            n_linked_jas := 0;
         ELSE
            -- Find no of JA's linked to the student in session_code passed in as a parameter
            OPEN c5 (r4.ja_case_id);

            FETCH c5
             INTO n_linked_jas;

            IF c5%NOTFOUND
            THEN
               n_linked_jas := 0;
            END IF;

            CLOSE c5;
         END IF;

         -- Field 8. Number of JA's linked to the student
         UTL_FILE.put (hreport, n_linked_jas || ',');
         lv_field_number := 8;

         OPEN c6 (r1.stud_ref_no, r4.ja_case_id);

         FETCH c6
          INTO r6;

         IF c6%NOTFOUND
         THEN
            r6.no_of_withdrawn_cases := 0;
         END IF;

         CLOSE c6;

         IF r6.no_of_withdrawn_cases > 0
         THEN
            c_withdrawn_case := '3';
         ELSE
            c_withdrawn_case := '0';
         END IF;

         -- Field 9. A withdrawn case is in the family (3) or not (0).
         UTL_FILE.put (hreport, c_withdrawn_case || ',');
         lv_field_number := 9;

         IF r1.crse_year_id IS NULL
         THEN
            c_eu_flag := 'N';
         ELSE
            SELECT eu_flag
              INTO c_eu_flag
              FROM crse_year
             WHERE crse_year_id = r1.crse_year_id;
         END IF;

         -- Field 10. EU Student?
         UTL_FILE.put (hreport, c_eu_flag || ',');
         lv_field_number := 10;
         -- Field 11. Application Status
         UTL_FILE.put (hreport, r1.application_status || ',');
         lv_field_number := 11;
         --
         v_short_app_sent_date := NULL;
         v_short_app_rec_date := NULL;

         --
            --RFC 219 Oct 2006 PB
         BEGIN
            SELECT short_app_sent_date, short_app_rec_date
              INTO v_short_app_sent_date, v_short_app_rec_date
              FROM stud_session
             WHERE stud_ref_no = r1.stud_ref_no
               AND session_code = (param_session_code - 1);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_short_app_sent_type := NULL;
               v_short_app_rec_date := NULL;
         END;

         --
         v_web_user_id := NULL;
         v_email_addr := NULL;

         --
         BEGIN
            SELECT web_user_id, email_addr
              INTO v_web_user_id, v_email_addr
              FROM stud
             WHERE stud_ref_no = r1.stud_ref_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_web_user_id := NULL;
               v_email_addr := NULL;
         END;

         --
         v_short_app_sent_type := NULL;

         --
         IF v_short_app_sent_date IS NULL
         THEN
            v_short_app_sent_type := NULL;
         ELSIF param_session_code = 2005 AND v_short_app_sent_date IS NOT NULL
         THEN
            v_short_app_sent_type := 'P';
         ELSIF param_session_code >= 2006
         THEN
            IF    (v_short_app_sent_date IS NOT NULL AND v_web_user_id = NULL
                  )
               OR (    v_short_app_sent_date IS NOT NULL
                   AND v_web_user_id IS NOT NULL
                   AND v_email_addr IS NULL
                  )
            THEN
               v_short_app_sent_type := 'P';
            ELSIF (    v_short_app_sent_date IS NOT NULL
                   AND v_web_user_id IS NOT NULL
                   AND v_email_addr IS NOT NULL
                  )
            THEN
               v_short_app_sent_type := 'W';
            ELSE
               v_short_app_sent_type := NULL;
            END IF;
         ELSE
            v_short_app_sent_type := NULL;
         END IF;

         --
         -- Field 12. Short Application sent type
         UTL_FILE.put (hreport, v_short_app_sent_type || ',');
         lv_field_number := 12;
         --
         -- Field 13. Application Date of Issue
         UTL_FILE.put (hreport, v_short_app_sent_date || ',');
         lv_field_number := 13;
         --
         --
         v_app_rec_type := NULL;

         --
         FOR rec_edm_images IN cu_edm_images (r1.stud_ref_no)
         LOOP
            --
            --Paper Application
            --
            IF     v_short_app_rec_date IS NOT NULL
               AND rec_edm_images.batch_type_code IN (16, 21)
               AND rec_edm_images.document_type_code = 'SHORT_APP'
               AND rec_edm_images.attachment_type_code = 'TIFF'
            THEN
               v_app_rec_type := 'S';
               EXIT;
            --
            -- Web short app
            --
            ELSIF     v_short_app_rec_date IS NOT NULL
                  AND rec_edm_images.batch_type_code IN (16, 21)
                  AND rec_edm_images.document_type_code = 'WEB_SHORT_APP'
                  AND rec_edm_images.attachment_type_code = 'PDF'
            THEN
               v_app_rec_type := 'X';
               EXIT;
            --
            -- Web ordinary
            --
            ELSIF        v_short_app_rec_date IS NULL
                     AND (    rec_edm_images.batch_type_code IS NULL
                          AND rec_edm_images.document_type_code IN
                                         ('SAS3_PDF', 'SAS7_PDF', 'NMSB_PDF')
                          AND rec_edm_images.attachment_type_code = 'PDF'
                         )
                  OR (    rec_edm_images.batch_type_code = 3
                      AND rec_edm_images.document_type_code = 'WEB_APP'
                      AND rec_edm_images.attachment_type_code = 'TIFF'
                     )
            THEN
               v_app_rec_type := 'W';
               EXIT;
            --
            -- Paper
            --
            ELSIF     v_short_app_rec_date IS NULL
                  AND rec_edm_images.batch_type_code = 2
                  AND rec_edm_images.document_type_code IN ('%_MAN')
            THEN
               v_app_rec_type := 'P';
               EXIT;
            ELSE
               v_app_rec_type := 'E';
               EXIT;
            END IF;
         --
         END LOOP;

         --
         IF v_app_rec_type = NULL
         THEN
            v_app_rec_type := 'E';
         END IF;

         --
         -- Field 14. Application Received Type
         UTL_FILE.put (hreport, v_app_rec_type || ',');
         lv_field_number := 14;
         --
         -- End of RFC 219 section.

         -- Field 15. Award
         UTL_FILE.put (hreport, r1.award || ',');
         lv_field_number := 15;
         -- Field 16. Scheme Type
         UTL_FILE.put (hreport, r1.scheme_type || ',');
         lv_field_number := 16;
         -- Field 17. Date the stud_crse_year record was registered
         UTL_FILE.put (hreport,
                       TO_CHAR (r1.entered_date, 'DD-MON-YYYY') || ',');
         lv_field_number := 17;
         -- Field 18. Exempt from parental and spouse contribution
         UTL_FILE.put (hreport, r1.parent_contrib_exempt || ',');
         lv_field_number := 18;
         -- Field 19. Dearing Status
         UTL_FILE.put (hreport, r1.dearing || ',');
         lv_field_number := 19;
         -- Field 20. Provisional Award Assessment
         UTL_FILE.put (hreport, r1.provisional_case || ',');
         lv_field_number := 20;
         -- Field 21. Student contribution amount for all stud_crse_year records
         -- for the session_code parameter and the current student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_student_contribution, 0), 0) || ','
                      );
         lv_field_number := 21;
         -- Field 22. Spouse contribution amount for all stud_crse_year records
         -- for the session_code parameter and the current student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_spouse_contribution, 0), 0) || ','
                      );
         lv_field_number := 22;
         -- Field 23. Parental contribution amount for all stud_crse_year records
         -- for the session_code parameter and the current student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_parent_contribution, 0), 0) || ','
                      );
         lv_field_number := 23;
         -- Field 24. Residual parent contribution amount for all stud_crse_year records
         -- for the session_code parameter and the current student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_resid_par_contribution, 0), 0) || ','
                      );
         lv_field_number := 24;
         -- Field 25. Residual spouse contribution amount for all stud_crse_year records
         -- for the session_code parameter and the current student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_resid_spouse_contribution, 0), 0) || ','
                      );
         lv_field_number := 25;
         -- Field 26. Residual student contribution amount for all stud_crse_year records
         -- for the session_code parameter and the current student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_resid_stud_contribution, 0), 0) || ','
                      );
         lv_field_number := 26;

         -- Select the data using the inst code.  If the inst code
         -- is invalid then set it to zero along with the other fields
         BEGIN
            SELECT NVL (inst_type_id, 0), NVL (location_ind, '0')
              INTO n_inst_type_id, v_location_ind
              FROM inst
             WHERE inst_code = r1.inst_code;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               r1.inst_code := '0';
               n_inst_type_id := 0;
               v_location_ind := '0';
         END;

         -- Field 27. Institution Code
         -- for the session_code parameter and the current student
         UTL_FILE.put (hreport, r1.inst_code || ',');
         lv_field_number := 27;
         -- Field 28. Self Funding Indicator
         -- for the session_code parameter and the current student
         -- added for RFC 219
         UTL_FILE.put (hreport, NVL (r1.self_funding, 'N') || ',');
         lv_field_number := 28;
         -- Field 29. Institution Type
         -- for the session_code parameter and the current student
         UTL_FILE.put (hreport, NVL (n_inst_type_id, 0) || ',');
         lv_field_number := 29;
         -- Field 30. Institution Location.
         -- for the session_code parameter and the current student
         UTL_FILE.put (hreport, NVL (v_location_ind, '0') || ',');
         lv_field_number := 30;
         -- Field 31. Course code
         UTL_FILE.put (hreport, r1.crse_code || ',');
         lv_field_number := 31;
         -- Field 32. Year of Study
         UTL_FILE.put (hreport, r1.crse_year_no || ',');
         lv_field_number := 32;

         IF r1.crse_id IS NULL
         THEN
            v_qual_type := '0';
            v_pams_course := 'N';
         ELSE
            BEGIN
               SELECT NVL (qual_type, '0'), NVL (pams_course, 'N')
                 INTO v_qual_type, v_pams_course
                 FROM crse
                WHERE crse_id = r1.crse_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_qual_type := '0';
                  v_pams_course := 'N';
            END;
         END IF;

         -- Field 33. Course Qualification Type
         UTL_FILE.put (hreport, v_qual_type || ',');
         lv_field_number := 33;
         -- Field 34. PAMS Course
         UTL_FILE.put (hreport, v_pams_course || ',');
         lv_field_number := 34;

         IF r1.crse_year_id IS NULL
         THEN
            v_split_session := 'N';
            v_crse_type := 0;
         ELSE
            SELECT split_session, NVL (crse_type, '0')
              INTO v_split_session, v_crse_type
              FROM crse_year
             WHERE crse_year_id = r1.crse_year_id;

            IF v_crse_type IS NULL
            THEN
               v_crse_type := 0;
            ELSE
               IF r1.dearing = 'O'
               THEN
                  v_crse_type := 'P';
               END IF;
            END IF;
         END IF;

         -- Field 35. Split Session Course?
         UTL_FILE.put (hreport, v_split_session || ',');
         lv_field_number := 35;
         -- Field 36. Course Type
         UTL_FILE.put (hreport, v_crse_type || ',');
         lv_field_number := 36;
         -- Field 37. Number of Terms
         UTL_FILE.put (hreport, n_number_of_terms || ',');
         lv_field_number := 37;
         --
         --RFC 219
         --
         c_38_applies_value := NULL;
         c_45_applies_value := NULL;

         --
         OPEN c7a (r1.stud_ref_no);

         FETCH c7a
          INTO r7a;

         IF c7a%FOUND
         THEN
            IF r7a.dearing <> 'G'
            THEN
               c_38_applies_value := 'Y';
               c_45_applies_value := NULL;
            ELSIF r7a.dearing = 'G' AND r7a.net_amount > 0
            THEN
               c_38_applies_value := NULL;
               c_45_applies_value := 'Y';
            ELSIF r7a.dearing = 'G' AND r7a.net_amount = 0
            THEN
               c_38_applies_value := NULL;
               c_45_applies_value := 'N';
            END IF;
         ELSE
            IF r1.dearing = 'G'
            THEN
               c_38_applies_value := NULL;
               c_45_applies_value := 'N';
            ELSIF r1.dearing <> 'G'
            THEN
               c_38_applies_value := 'N';
               c_45_applies_value := NULL;
            END IF;
         END IF;

         CLOSE c7a;

         --
         -- Field 38.
         --
         UTL_FILE.put (hreport, c_38_applies_value || ',');
         lv_field_number := 38;

         --
         IF NVL (c_38_applies_value, 'X') = 'Y'
         THEN
            OPEN c7 (r7a.stud_crse_year_id);

            FETCH c7
             INTO r7;

            IF c7%NOTFOUND
            THEN
               r7.tuition_fee_type_code := 0;
            ELSIF r7.tuition_fee_type_code IS NULL
            THEN
               -- use crse_id instead
               BEGIN
                  SELECT tuition_fee_type_code
                    INTO r7.tuition_fee_type_code
                    FROM crse_session
                   WHERE session_code = param_session_code
                     AND crse_id = r1.crse_id;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     r7.tuition_fee_type_code := 0;
               END;
            END IF;

            CLOSE c7;
         ELSIF NVL (c_38_applies_value, 'X') = 'N'
         THEN
            r7.tuition_fee_type_code := 0;
         ELSIF c_38_applies_value IS NULL
         THEN
            r7.tuition_fee_type_code := NULL;
         END IF;

         --
         -- Field 39. Tuition Fee Band
         UTL_FILE.put (hreport, r7.tuition_fee_type_code || ',');
         lv_field_number := 39;

         --
         IF NVL (c_38_applies_value, 'X') = 'Y'
         THEN
            OPEN c8 (r1.stud_ref_no);

            FETCH c8
             INTO r8;

            IF c8%NOTFOUND
            THEN
               r8.amount := 0;
               r8.net_amount := 0;
               n_adjust_amount := 0;
               n_instalment_amount := 0;
            ELSE
               SELECT SUM (adjust.amount)
                 INTO n_debt_amount
                 FROM stud_crse_year, adjust
                WHERE stud_crse_year.stud_ref_no = r1.stud_ref_no
                  AND stud_crse_year.session_code = param_session_code
                  AND stud_crse_year.dearing <> 'G'                 -- RFC 219
                  AND adjust.stud_crse_year_id =
                                              stud_crse_year.stud_crse_year_id
                  AND adjust.SOURCE = 'I'
                  AND adjust.TYPE = 'D';

               SELECT SUM (adjust.amount)
                 INTO n_repayment_amount
                 FROM stud_crse_year, adjust
                WHERE stud_crse_year.stud_ref_no = r1.stud_ref_no
                  AND stud_crse_year.session_code = param_session_code
                  AND stud_crse_year.dearing <> 'G'                 -- RFC 219
                  AND adjust.stud_crse_year_id =
                                              stud_crse_year.stud_crse_year_id
                  AND adjust.SOURCE = 'I'
                  AND adjust.TYPE = 'R';

               n_adjust_amount :=
                    NVL (r8.net_amount, 0)
                  + (NVL (n_repayment_amount, 0) - NVL (n_debt_amount, 0));

               SELECT SUM (ai.net_amount)
                 INTO n_instalment_net_amount
                 FROM award_instalment ai,
                      award a,
                      stud_crse_year scy                            -- RFC 219
                WHERE ai.award_id = a.award_id
                  AND a.stud_ref_no = r1.stud_ref_no
                  AND a.session_code = param_session_code
                  AND a.award_src = 'T'
                  AND ai.payment_status = 'S'
                  AND ai.batch_ref IS NOT NULL
                  AND a.stud_crse_year_id = scy.stud_crse_year_id   -- RFC 219
                  AND scy.dearing <> 'G';                           -- RFC 219

               n_instalment_amount :=
                    NVL (n_instalment_net_amount, 0)
                  + (NVL (n_repayment_amount, 0) - NVL (n_debt_amount, 0));
            END IF;

            CLOSE c8;
         ELSIF NVL (c_38_applies_value, 'X') = 'N'
         THEN
            r8.amount := 0;
            r8.net_amount := 0;
            n_adjust_amount := 0;
            n_instalment_amount := 0;
         ELSIF c_38_applies_value IS NULL
         THEN
            r8.amount := NULL;
            r8.net_amount := NULL;
            n_adjust_amount := NULL;
            n_instalment_amount := NULL;
         END IF;

         -- Field 40. Tuition Fees amount applicable for session code passed in
         -- as a parameter
         UTL_FILE.put (hreport, ROUND (r8.amount, 0) || ',');
         lv_field_number := 40;

         -- Field 41. Minus sign (-) if field 37 is negative or null if field is positive
         -- as a parameter
         IF n_adjust_amount < 0
         THEN
            n_adjust_amount := n_adjust_amount * -1;
            UTL_FILE.put (hreport, '-' || ',');
         ELSE
            UTL_FILE.put (hreport, NULL || ',');
         END IF;

         lv_field_number := 41;
         -- Field 42. Tuition Fees entitlement amount
         UTL_FILE.put (hreport, ROUND (n_adjust_amount, 0) || ',');
         lv_field_number := 42;

         -- Field 43. Minus sign (-) if field 39 is negative or null if field is positive
         -- as a parameter
         IF n_instalment_amount < 0
         THEN
            n_instalment_amount := n_instalment_amount * -1;
            UTL_FILE.put (hreport, '-' || ',');
         ELSE
            UTL_FILE.put (hreport, NULL || ',');
         END IF;

         lv_field_number := 43;
         -- Field 44. Tuition Fees entitlement amount
         UTL_FILE.put (hreport, ROUND (n_instalment_amount, 0) || ',');
         lv_field_number := 44;
         --
         --RFC 219
         --
         --
         --
         -- Field 45.
         UTL_FILE.put (hreport, c_45_applies_value || ',');
         lv_field_number := 45;

         --
         IF c_45_applies_value = 'Y'
         THEN
            BEGIN
               SELECT award_type_descript
                 INTO v_award_type_descript
                 FROM award
                WHERE stud_crse_year_id = r7a.stud_crse_year_id
                  AND award_src = 'T';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_award_type_descript := 0;
            END;
         ELSIF c_45_applies_value = 'N'
         THEN
            v_award_type_descript := 0;
         ELSE
            v_award_type_descript := NULL;
         END IF;

         -- Field 46. Fee Loan Award Type Descript
         UTL_FILE.put (hreport, v_award_type_descript || ',');
         lv_field_number := 46;

         --
         IF c_45_applies_value = 'Y'
         THEN
            OPEN c8a (r1.stud_ref_no);

            FETCH c8a
             INTO r8a;

            IF c8a%NOTFOUND
            THEN
               r8a.amount := 0;
               r8a.net_amount := 0;
               n_fee_adjust_amount := 0;
               n_fee_instalment_amount := 0;
            ELSE
               SELECT SUM (adjust.amount)
                 INTO n_fee_debt_amount
                 FROM stud_crse_year, adjust
                WHERE stud_crse_year.stud_ref_no = r1.stud_ref_no
                  AND stud_crse_year.session_code = param_session_code
                  AND stud_crse_year.dearing = 'G'
                  AND adjust.stud_crse_year_id =
                                              stud_crse_year.stud_crse_year_id
                  AND adjust.SOURCE = 'I'
                  AND adjust.TYPE = 'D';

               SELECT SUM (adjust.amount)
                 INTO n_fee_repayment_amount
                 FROM stud_crse_year, adjust
                WHERE stud_crse_year.stud_ref_no = r1.stud_ref_no
                  AND stud_crse_year.session_code = param_session_code
                  AND stud_crse_year.dearing = 'G'
                  AND adjust.stud_crse_year_id =
                                              stud_crse_year.stud_crse_year_id
                  AND adjust.SOURCE = 'I'
                  AND adjust.TYPE = 'R';

               n_fee_adjust_amount :=
                    NVL (r8a.net_amount, 0)
                  + (  NVL (n_fee_repayment_amount, 0)
                     - NVL (n_fee_debt_amount, 0)
                    );

               SELECT SUM (ai.net_amount)
                 INTO n_fee_instalment_net_amount
                 FROM award_instalment ai, award a, stud_crse_year scy
                WHERE ai.award_id = a.award_id
                  AND a.stud_ref_no = r1.stud_ref_no
                  AND a.session_code = param_session_code
                  AND a.award_src = 'T'
                  AND ai.payment_status = 'S'
                  AND ai.batch_ref IS NOT NULL
                  AND a.stud_crse_year_id = scy.stud_crse_year_id
                  AND scy.dearing = 'G';

               n_fee_instalment_amount :=
                    NVL (n_fee_instalment_net_amount, 0)
                  + (  NVL (n_fee_repayment_amount, 0)
                     - NVL (n_fee_debt_amount, 0)
                    );
            END IF;

            CLOSE c8a;
         ELSIF c_45_applies_value = 'N'
         THEN
            r8a.amount := 0;
            r8a.net_amount := 0;
            n_fee_adjust_amount := 0;
            n_fee_instalment_amount := 0;
         ELSE
            r8a.amount := NULL;
            r8a.net_amount := NULL;
            n_fee_adjust_amount := NULL;
            n_fee_instalment_amount := NULL;
         END IF;

         -- Field 47. Fees Loan amount applicable for session code passed in
         -- as a parameter
         UTL_FILE.put (hreport, ROUND (r8a.amount, 0) || ',');
         lv_field_number := 47;

         -- Field 48. Fee loan sign 1
         --Minus sign (-) if field xx(next field) is negative or null if field is positive
         -- as a parameter
         IF n_fee_adjust_amount < 0
         THEN
            n_fee_adjust_amount := n_fee_adjust_amount * -1;
            UTL_FILE.put (hreport, '-' || ',');
         ELSE
            UTL_FILE.put (hreport, NULL || ',');
         END IF;

         lv_field_number := 48;
         -- Field 49. Fee Loan net amount
         UTL_FILE.put (hreport, ROUND (n_fee_adjust_amount, 0) || ',');
         lv_field_number := 49;

         -- Field 50. Fee Loans sign 2
         --Minus sign (-) if field xx(next field) is negative or null if field is positive
         -- as a parameter
         IF n_fee_instalment_amount < 0
         THEN
            n_fee_instalment_amount := n_fee_instalment_amount * -1;
            UTL_FILE.put (hreport, '-' || ',');
         ELSE
            UTL_FILE.put (hreport, NULL || ',');
         END IF;

         lv_field_number := 50;
         -- Field 51. Fee loans total amount actually paid
         UTL_FILE.put (hreport, ROUND (n_fee_instalment_amount, 0) || ',');
         lv_field_number := 51;

         --
         IF    c_45_applies_value = 'Y'
            OR (r7a.dearing = 'G' AND r7a.net_amount = 0)
         THEN
            --
            OPEN c32 (r7a.stud_crse_year_id);

            FETCH c32
             INTO r32;

            --
            IF    NVL (r32.paid_sandwich, 'N') = 'Y'
               OR NVL (r32.unpaid_sandwich, 'N') = 'Y'
            THEN
               IF (r32.req_tuition_fee IS NULL) OR (r32.req_tuition_fee = 0)
               THEN
                  v_max_fee_loan := r32.var_sandwich_tuition_fee_amnt;
               ELSE
                  IF r32.var_sandwich_tuition_fee_amnt < r32.req_tuition_fee
                  THEN
                     v_max_fee_loan := r32.var_sandwich_tuition_fee_amnt;
                  ELSIF r32.req_tuition_fee <
                                             r32.var_sandwich_tuition_fee_amnt
                  THEN
                     v_max_fee_loan := r32.req_tuition_fee;
                  END IF;
               END IF;
            ELSE
               IF (r32.req_tuition_fee IS NULL) OR (r32.req_tuition_fee = 0)
               THEN
                  v_max_fee_loan := r32.var_tuition_fee_amnt;
               ELSE
                  IF r32.var_tuition_fee_amnt < r32.req_tuition_fee
                  THEN
                     v_max_fee_loan := r32.var_tuition_fee_amnt;
                  ELSIF r32.req_tuition_fee < r32.var_tuition_fee_amnt
                  THEN
                     v_max_fee_loan := r32.req_tuition_fee;
                  END IF;
               END IF;
            END IF;

            CLOSE c32;
         ELSE
            v_max_fee_loan := NULL;
         END IF;

         -- Field 52. Maximum fee loan amount student can apply for.
         UTL_FILE.put (hreport, v_max_fee_loan || ',');
         lv_field_number := 52;

         --
         -- End of RFC 219 section
         --
         OPEN c9 (r1.stud_crse_year_id);

         FETCH c9
          INTO c_value;

         IF c9%NOTFOUND
         THEN
            c_value := '0';
         END IF;

         CLOSE c9;

         -- Field 53. Code for Course non-tuition fee
         UTL_FILE.put (hreport, NVL (c_value, '0') || ',');
         lv_field_number := 53;

         SELECT SUM (amount), SUM (net_amount)
           INTO n_award_amount, n_award_net_amount
           FROM award
          WHERE stud_ref_no = r1.stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'C';

         -- Field 54. Course non-tuition fee amount applicable
         UTL_FILE.put (hreport, ROUND (NVL (n_award_amount, 0), 0) || ',');
         lv_field_number := 54;
         -- Field 55. Course non-tuition fee entitlement amount
         UTL_FILE.put (hreport, ROUND (NVL (n_award_net_amount, 0), 0) || ',');
         lv_field_number := 55;

         SELECT SUM (ai.net_amount)
           INTO n_award_net_amount
           FROM award_instalment ai, award a
          WHERE ai.award_id = a.award_id
            AND a.stud_ref_no = r1.stud_ref_no
            AND a.award_src = 'C'
            AND a.session_code = param_session_code
            AND ai.payment_status = 'S'
            AND ai.batch_ref IS NOT NULL;

         -- Field 56. Course non-tuition fee total amount actually paid
         UTL_FILE.put (hreport, ROUND (NVL (n_award_net_amount, 0), 0) || ',');
         lv_field_number := 56;

         BEGIN
            SELECT 'I'
              INTO c_value
              FROM award
             WHERE stud_crse_year_id = r1.stud_crse_year_id
               AND session_code = param_session_code
               AND award_src = 'I';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               c_value := '0';
         END;

         -- Field 57. Code for Institution non-tuition-fee
         UTL_FILE.put (hreport, c_value || ',');
         lv_field_number := 57;

         SELECT SUM (amount), SUM (net_amount)
           INTO n_award_amount, n_award_net_amount
           FROM award
          WHERE stud_ref_no = r1.stud_ref_no
            AND session_code = param_session_code
            AND award_src = 'I';

         -- Field 58. Institution non-tuition-fee amount applicable
         UTL_FILE.put (hreport, ROUND (NVL (n_award_amount, 0), 0) || ',');
         lv_field_number := 58;
         -- Field 59. Institution Non-Tuition fee entitlement amount
         UTL_FILE.put (hreport, ROUND (NVL (n_award_net_amount, 0), 0) || ',');
         lv_field_number := 59;

         SELECT SUM (ai.net_amount)
           INTO n_instalment_net_amount
           FROM award a, award_instalment ai
          WHERE a.award_src = 'I'
            AND a.stud_ref_no = r1.stud_ref_no
            AND a.session_code = param_session_code
            AND ai.award_id = a.award_id
            AND ai.payment_status = 'S'
            AND ai.batch_ref IS NOT NULL;

         -- Field 60. Institution Non-Tuition fee total amount actually paid
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_instalment_net_amount, 0), 0) || ','
                      );
         lv_field_number := 60;

         IF r1.dearing = 'O' OR c_eu_flag = 'Y'
         THEN
            c_applies_value := 'N';
         ELSIF NVL (param_scheme_type, 'x') <> 'B'
         THEN
            OPEN c10 (r1.stud_ref_no);

            FETCH c10
             INTO c_dummy;

            IF c10%FOUND
            THEN
               c_applies_value := 'Y';
            ELSIF    (   (r1.dearing = 'N' AND param_scheme_type = 'P')
                      OR (r1.dearing = 'A' AND c_eu_flag = 'N')
                      OR (r1.dearing = 'P' AND param_session_code = 1998)
                      OR (r1.dearing = 'B' AND param_session_code = 1998)
                      OR (    r1.dearing = 'B'
                          AND pk_steps_utils.check_pams (r1.inst_code,
                                                         r1.crse_code
                                                        )
                         )
                      OR (    r1.dearing = 'C'
                          AND pk_steps_utils.check_pams (r1.inst_code,
                                                         r1.crse_code
                                                        )
                         )
                      OR (    r1.dearing = 'D'
                          AND pk_steps_utils.check_pams (r1.inst_code,
                                                         r1.crse_code
                                                        )
                         )
                      OR param_scheme_type = 'S'
                     )
                  OR     (    r1.dearing = 'F'
                          AND pk_steps_utils.check_pams (r1.inst_code,
                                                         r1.crse_code
                                                        )
                         )
                     AND (    r1.application_status IN ('C', 'W')
                          AND r1.award != 'A'
                         )
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;

            CLOSE c10;
         ELSE
            OPEN c10a (r1.stud_ref_no);

            FETCH c10a
             INTO c_dummy;

            IF c10a%FOUND
            THEN
               c_applies_value := 'Y';
            ELSIF r1.application_status IN ('C', 'W') AND r1.award != 'A'
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;

            CLOSE c10a;
         END IF;

         -- Field 61. Standard Maintenance Allowance (SMA)
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 61;

         IF c_applies_value = 'Y'
         THEN
            IF NVL (param_scheme_type, 'x') <> 'B'
            THEN
               SELECT SUM (amount), SUM (net_amount)
                 INTO n_award_amount, n_award_net_amount
                 FROM award
                WHERE stud_ref_no = r1.stud_ref_no
                  AND session_code = param_session_code
                  AND stud_award_type IN
                         ('UGSMA',
                          'UGSMAB',
                          'UGSMAH',
                          'PSSMAB',
                          'PSSMA',
                          'SSMA'
                         );

               SELECT SUM (ai.net_amount)
                 INTO n_instalment_net_amount
                 FROM award_instalment ai, award a
                WHERE a.stud_ref_no = r1.stud_ref_no
                  AND a.session_code = param_session_code
                  AND a.stud_award_type IN
                         ('UGSMA',
                          'UGSMAB',
                          'UGSMAH',
                          'PSSMAB',
                          'PSSMA',
                          'SSMA'
                         )
                  AND ai.award_id = a.award_id
                  AND ai.payment_status = 'S'
                  AND ai.batch_ref IS NOT NULL;
            ELSE
               SELECT SUM (amount), SUM (net_amount)
                 INTO n_award_amount, n_award_net_amount
                 FROM award
                WHERE stud_ref_no = r1.stud_ref_no
                  AND session_code = param_session_code
                  AND stud_award_type = 'SNB';

               --
               SELECT SUM (ai.net_amount)
                 INTO n_instalment_net_amount
                 FROM award_instalment ai, award a
                WHERE a.stud_ref_no = r1.stud_ref_no
                  AND a.session_code = param_session_code
                  AND a.stud_award_type IN ('SNB')
                  AND ai.award_id = a.award_id
                  AND ai.payment_status = 'S'
                  AND ai.batch_ref IS NOT NULL;
            END IF;               -- IF NVL(param_scheme_type,'x') <> 'B' THEN
         ELSE
            n_award_amount := 0;
            n_award_net_amount := 0;
            n_instalment_net_amount := 0;
         END IF;                              -- IF c_applies_value = 'Y' THEN

         --
         n_total_amount := NVL (n_total_amount, 0) + NVL (n_award_amount, 0);
         n_total_net_amount :=
                      NVL (n_total_net_amount, 0)
                      + NVL (n_award_net_amount, 0);
         n_total_instalment_net_amount :=
              NVL (n_total_instalment_net_amount, 0)
            + NVL (n_instalment_net_amount, 0);
         -- Field 62. SMA entitlement amount (before deduction of contribution and/or overpayment
         UTL_FILE.put (hreport, ROUND (NVL (n_award_amount, 0), 0) || ',');
         lv_field_number := 62;
         -- Field 63. SMA net amount awarded to the student
         UTL_FILE.put (hreport, ROUND (NVL (n_award_net_amount, 0), 0) || ',');
         lv_field_number := 63;
         -- Field 64. SMA net amount actually paid to the student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_instalment_net_amount, 0), 0) || ','
                      );
         lv_field_number := 64;

         IF r1.dearing = 'O'
         THEN
            c_applies_value := 'N';
         ELSIF NVL (param_scheme_type, 'x') <> 'B'
         THEN
            OPEN c11 (r1.stud_ref_no);

            FETCH c11
             INTO c_dummy;

            IF c11%FOUND
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;

            CLOSE c11;
         ELSE
            OPEN c11a (r1.stud_ref_no);

            FETCH c11a
             INTO c_dummy;

            IF c11a%FOUND
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;

            CLOSE c11a;
         END IF;                                   -- IF r1.dearing = 'O' THEN

         -- Field 65. Mature Students Allowance (MSA)
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 65;

         IF c_applies_value = 'Y'
         THEN
            IF NVL (param_scheme_type, 'x') <> 'B'
            THEN
               SELECT SUM (amount), SUM (net_amount)
                 INTO n_award_amount, n_award_net_amount
                 FROM award
                WHERE stud_ref_no = r1.stud_ref_no
                  AND session_code = param_session_code
                  AND stud_award_type IN ('UGMSA', 'PSMSA');

               SELECT SUM (ai.net_amount)
                 INTO n_instalment_net_amount
                 FROM award_instalment ai, award a
                WHERE a.stud_ref_no = r1.stud_ref_no
                  AND a.session_code = param_session_code
                  AND a.stud_award_type IN ('UGMSA', 'PSMSA')
                  AND ai.award_id = a.award_id
                  AND ai.payment_status = 'S'
                  AND ai.batch_ref IS NOT NULL;
            ELSE
               SELECT SUM (amount), SUM (net_amount)
                 INTO n_award_amount, n_award_net_amount
                 FROM award
                WHERE stud_ref_no = r1.stud_ref_no
                  AND session_code = param_session_code
                  AND stud_award_type IN ('SNIE');

               SELECT SUM (ai.net_amount)
                 INTO n_instalment_net_amount
                 FROM award_instalment ai, award a
                WHERE a.stud_ref_no = r1.stud_ref_no
                  AND a.session_code = param_session_code
                  AND a.stud_award_type IN ('SNIE')
                  AND ai.award_id = a.award_id
                  AND ai.payment_status = 'S'
                  AND ai.batch_ref IS NOT NULL;
            END IF;               -- IF NVL(param_scheme_type,'x') <> 'B' THEN
         ELSE
            n_award_amount := 0;
            n_award_net_amount := 0;
            n_instalment_net_amount := 0;
         END IF;                              -- IF c_applies_value = 'Y' THEN

         n_total_amount := NVL (n_total_amount, 0) + NVL (n_award_amount, 0);
         n_total_net_amount :=
                      NVL (n_total_net_amount, 0)
                      + NVL (n_award_net_amount, 0);
         n_total_instalment_net_amount :=
              NVL (n_total_instalment_net_amount, 0)
            + NVL (n_instalment_net_amount, 0);
         -- Field 66. MSA Entitlement amount (before deduction of contribution and/or overpayment).
         UTL_FILE.put (hreport, ROUND (NVL (n_award_amount, 0), 0) || ',');
         lv_field_number := 66;
         -- Field 67. MSA net amount awarded to the student
         UTL_FILE.put (hreport, ROUND (NVL (n_award_net_amount, 0), 0) || ',');
         lv_field_number := 67;
         -- Field 68. MSA amount actually paid to the student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_instalment_net_amount, 0), 0) || ','
                      );
         lv_field_number := 68;

         IF r1.dearing = 'O'
         THEN
            c_applies_value := 'N';
         ELSIF NVL (param_scheme_type, 'x') <> 'B'
         THEN
            OPEN c12 (r1.stud_ref_no);

            FETCH c12
             INTO c_dummy;

            IF c12%FOUND
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;

            CLOSE c12;
         ELSE
            OPEN c12a (r1.stud_ref_no);

            FETCH c12a
             INTO c_dummy;

            IF c12a%FOUND
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;

            CLOSE c12a;
         END IF;

         -- Field 69. Dependants Allowance (DA) applies for session code passed in
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 69;

         IF c_applies_value = 'Y'
         THEN
            IF NVL (param_scheme_type, 'x') <> 'B'
            THEN
               SELECT SUM (amount), SUM (net_amount)
                 INTO n_award_amount, n_award_net_amount
                 FROM award
                WHERE stud_ref_no = r1.stud_ref_no
                  AND session_code = param_session_code
                  AND stud_award_type IN ('SSDA', 'PSDA', 'UGDA');

               SELECT SUM (ai.net_amount)
                 INTO n_instalment_net_amount
                 FROM award_instalment ai, award a
                WHERE a.stud_ref_no = r1.stud_ref_no
                  AND a.session_code = param_session_code
                  AND stud_award_type IN ('SSDA', 'PSDA', 'UGDA')
                  AND ai.award_id = a.award_id
                  AND ai.payment_status = 'S'
                  AND ai.batch_ref IS NOT NULL;
            ELSE
               SELECT SUM (amount), SUM (net_amount)
                 INTO n_award_amount, n_award_net_amount
                 FROM award
                WHERE stud_ref_no = r1.stud_ref_no
                  AND session_code = param_session_code
                  AND stud_award_type IN ('SNDA');

               SELECT SUM (ai.net_amount)
                 INTO n_instalment_net_amount
                 FROM award_instalment ai, award a
                WHERE a.stud_ref_no = r1.stud_ref_no
                  AND a.session_code = param_session_code
                  AND stud_award_type IN ('SNDA')
                  AND ai.award_id = a.award_id
                  AND ai.payment_status = 'S'
                  AND ai.batch_ref IS NOT NULL;
            END IF;               -- IF NVL(param_scheme_type,'x') <> 'B' THEN
         ELSE
            n_award_amount := 0;
            n_award_net_amount := 0;
            n_instalment_net_amount := 0;
         END IF;

         n_total_amount := NVL (n_total_amount, 0) + NVL (n_award_amount, 0);
         n_total_net_amount :=
                      NVL (n_total_net_amount, 0)
                      + NVL (n_award_net_amount, 0);
         n_total_instalment_net_amount :=
              NVL (n_total_instalment_net_amount, 0)
            + NVL (n_instalment_net_amount, 0);
         -- Field 70. DA Entitlement amount (before deduction of contribution and/or overpayment).
         UTL_FILE.put (hreport, ROUND (NVL (n_award_amount, 0), 0) || ',');
         lv_field_number := 70;
         -- Field 71. DA net amount awarded to the student
         UTL_FILE.put (hreport, ROUND (NVL (n_award_net_amount, 0), 0) || ',');
         lv_field_number := 71;
         -- Field 72. DA amount actually paid to the student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_instalment_net_amount, 0), 0) || ','
                      );
         lv_field_number := 72;

         IF r1.dearing = 'O'
         THEN
            c_applies_value := 'N';
         ELSIF NVL (param_scheme_type, 'x') <> 'B'
         THEN
            OPEN c13 (r1.stud_ref_no);

            FETCH c13
             INTO c_dummy;

            IF c13%FOUND
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;

            CLOSE c13;
         ELSE
            OPEN c13a (r1.stud_ref_no);

            FETCH c13a
             INTO c_dummy;

            IF c13a%FOUND
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;

            CLOSE c13a;
         END IF;

         -- Field 73. Optional Allowance (OA) applies for session code passed in
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 73;

         IF c_applies_value = 'Y'
         THEN
            IF NVL (param_scheme_type, 'x') <> 'B'
            THEN
               SELECT SUM (amount), SUM (net_amount)
                 INTO n_award_amount, n_award_net_amount
                 FROM award
                WHERE stud_ref_no = r1.stud_ref_no
                  AND session_code = param_session_code
                  AND stud_award_type IN ('SSOA', 'PSOA', 'UGOA');

               SELECT SUM (ai.net_amount)
                 INTO n_instalment_net_amount
                 FROM award_instalment ai, award a
                WHERE a.stud_ref_no = r1.stud_ref_no
                  AND a.session_code = param_session_code
                  AND stud_award_type IN ('SSOA', 'PSOA', 'UGOA')
                  AND ai.award_id = a.award_id
                  AND ai.payment_status = 'S'
                  AND ai.batch_ref IS NOT NULL;
            ELSE
               SELECT SUM (amount), SUM (net_amount)
                 INTO n_award_amount, n_award_net_amount
                 FROM award
                WHERE stud_ref_no = r1.stud_ref_no
                  AND session_code = param_session_code
                  AND stud_award_type IN ('SNSPA');

               SELECT SUM (ai.net_amount)
                 INTO n_instalment_net_amount
                 FROM award_instalment ai, award a
                WHERE a.stud_ref_no = r1.stud_ref_no
                  AND a.session_code = param_session_code
                  AND stud_award_type IN ('SNSPA')
                  AND ai.award_id = a.award_id
                  AND ai.payment_status = 'S'
                  AND ai.batch_ref IS NOT NULL;
            END IF;                --IF NVL(param_scheme_type,'x') <> 'B' THEN
         ELSE
            n_award_amount := 0;
            n_award_net_amount := 0;
            n_instalment_net_amount := 0;
         END IF;

         n_total_amount := NVL (n_total_amount, 0) + NVL (n_award_amount, 0);
         n_total_net_amount :=
                      NVL (n_total_net_amount, 0)
                      + NVL (n_award_net_amount, 0);
         n_total_instalment_net_amount :=
              NVL (n_total_instalment_net_amount, 0)
            + NVL (n_instalment_net_amount, 0);
         -- Field 74. OA Entitlement amount (before deduction of contribution and/or overpayment).
         UTL_FILE.put (hreport, ROUND (NVL (n_award_amount, 0), 0) || ',');
         lv_field_number := 74;
         -- Field 75. OA net amount awarded to the student
         UTL_FILE.put (hreport, ROUND (NVL (n_award_net_amount, 0), 0) || ',');
         lv_field_number := 75;
         -- Field 76. OA amount actually paid to the student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_instalment_net_amount, 0), 0) || ','
                      );
         lv_field_number := 76;

         IF NVL (param_scheme_type, 'x') <> 'B' OR r1.dearing <> 'O'
         THEN
            OPEN c14 (r1.stud_ref_no);

            FETCH c14
             INTO c_dummy;

            IF c14%FOUND
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;

            CLOSE c14;
         ELSE
            c_applies_value := 'N';
         END IF;

         -- Field 77. Two Homes Allowance (OA) applies for session code passed in
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 77;

         IF c_applies_value = 'Y'
         THEN
            SELECT SUM (amount), SUM (net_amount)
              INTO n_award_amount, n_award_net_amount
              FROM award
             WHERE stud_ref_no = r1.stud_ref_no
               AND session_code = param_session_code
               AND stud_award_type IN ('UG2HM', 'PS2HM');

            SELECT SUM (ai.net_amount)
              INTO n_instalment_net_amount
              FROM award_instalment ai, award a
             WHERE a.stud_ref_no = r1.stud_ref_no
               AND a.session_code = param_session_code
               AND stud_award_type IN ('UG2HM', 'PS2HM')
               AND ai.award_id = a.award_id
               AND ai.payment_status = 'S'
               AND ai.batch_ref IS NOT NULL;
         ELSE
            n_award_amount := 0;
            n_award_net_amount := 0;
            n_instalment_net_amount := 0;
         END IF;

         n_total_amount := NVL (n_total_amount, 0) + NVL (n_award_amount, 0);
         n_total_net_amount :=
                      NVL (n_total_net_amount, 0)
                      + NVL (n_award_net_amount, 0);
         n_total_instalment_net_amount :=
              NVL (n_total_instalment_net_amount, 0)
            + NVL (n_instalment_net_amount, 0);
         -- Field 78. THA Entitlement amount (before deduction of contribution and/or overpayment).
         UTL_FILE.put (hreport, ROUND (NVL (n_award_amount, 0), 0) || ',');
         lv_field_number := 78;
         -- Field 79. THA net amount awarded to the student
         UTL_FILE.put (hreport, ROUND (NVL (n_award_net_amount, 0), 0) || ',');
         lv_field_number := 79;
         -- Field 80. THA amount actually paid to the student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_instalment_net_amount, 0), 0) || ','
                      );
         lv_field_number := 80;

         IF NVL (param_scheme_type, 'x') <> 'B'
         THEN
            OPEN c15 (r1.stud_ref_no);

            FETCH c15
             INTO c_dummy;

            IF c15%FOUND
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;

            CLOSE c15;
         ELSE
            c_applies_value := 'N';
         END IF;

         -- Field 81. Disabled Students Allowance (DSA) applies for session code passed in
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 81;

         IF c_applies_value = 'Y'
         THEN
            SELECT SUM (ai.amount), SUM (ai.net_amount)
              INTO n_instalment_amount, n_instalment_net_awarded
              FROM award_instalment ai, award a
             WHERE a.stud_ref_no = r1.stud_ref_no
               AND a.session_code = param_session_code
               AND a.stud_award_type IN ('SSDSA', 'PSDSA', 'UGDSA')
               AND ai.award_id = a.award_id
               AND NVL (ai.dsa_fee_instalment, 'N') = 'Y'
               AND NVL (ai.payment_status, 'X') <> 'R'
               AND ai.recalc <> 'Y'
               AND ai.returned <> 'Y';

            SELECT SUM (ai.amount)
              INTO n_instalment_net_amount_paid
              FROM award_instalment ai, award a
             WHERE ai.award_id = a.award_id
               AND a.stud_ref_no = r1.stud_ref_no
               AND a.session_code = param_session_code
               AND a.stud_award_type IN ('SSDSA', 'PSDSA', 'UGDSA')
               AND ai.payment_status = 'S'
               AND ai.batch_ref IS NOT NULL
               AND NVL (ai.dsa_fee_instalment, 'N') = 'Y';
         ELSE
            n_instalment_amount := 0;
            n_instalment_net_awarded := 0;
            n_instalment_net_amount_paid := 0;
         END IF;

         n_total_amount :=
                         NVL (n_total_amount, 0)
                         + NVL (n_instalment_amount, 0);
         n_total_net_amount :=
                NVL (n_total_net_amount, 0)
                + NVL (n_instalment_net_awarded, 0);
         n_total_instalment_net_amount :=
              NVL (n_total_instalment_net_amount, 0)
            + NVL (n_instalment_net_amount_paid, 0);
         -- Field 82. DSA Entitlement amount (before deduction of contribution and/or overpayment).
         UTL_FILE.put (hreport, ROUND (NVL (n_instalment_amount, 0), 0) || ',');
         lv_field_number := 82;
         -- Field 83. THA net amount awarded to the student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_instalment_net_awarded, 0), 0) || ','
                      );
         lv_field_number := 83;
         -- Field 84. THA amount actually paid to the student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_instalment_net_amount_paid, 0), 0) || ','
                      );
         lv_field_number := 84;

         IF r1.dearing = 'O'
         THEN
            c_applies_value := 'N';
         ELSIF NVL (param_scheme_type, 'x') <> 'B'
         THEN
            OPEN c16 (r1.stud_ref_no);

            FETCH c16
             INTO c_dummy;

            IF c16%FOUND
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;

            CLOSE c16;
         ELSE
            OPEN c16a (r1.stud_ref_no);

            FETCH c16a
             INTO c_dummy;

            IF c16a%FOUND
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;

            CLOSE c16a;
         END IF;

         -- Field 85. Travel Expenses applies for session code passed in
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 85;

         IF c_applies_value = 'Y'
         THEN
            IF NVL (param_scheme_type, 'x') <> 'B'
            THEN
               SELECT SUM (amount), SUM (net_amount)
                 INTO n_award_amount, n_award_net_amount
                 FROM award
                WHERE stud_ref_no = r1.stud_ref_no
                  AND session_code = param_session_code
                  AND stud_award_type IN ('UGTE', 'PSTE', 'UGLTE', 'PSLTE');

               SELECT SUM (ai.net_amount)
                 INTO n_instalment_net_amount
                 FROM award_instalment ai, award a
                WHERE a.stud_ref_no = r1.stud_ref_no
                  AND a.session_code = param_session_code
                  AND stud_award_type IN ('UGTE', 'PSTE', 'UGLTE', 'PSLTE')
                  AND ai.award_id = a.award_id
                  AND ai.payment_status = 'S'
                  AND ai.batch_ref IS NOT NULL;
            ELSE
               SELECT SUM (amount), SUM (net_amount)
                 INTO n_award_amount, n_award_net_amount
                 FROM award
                WHERE stud_ref_no = r1.stud_ref_no
                  AND session_code = param_session_code
                  AND stud_award_type IN ('SNPE');

               SELECT SUM (ai.net_amount)
                 INTO n_instalment_net_amount
                 FROM award_instalment ai, award a
                WHERE a.stud_ref_no = r1.stud_ref_no
                  AND a.session_code = param_session_code
                  AND stud_award_type IN ('SNPE')
                  AND ai.award_id = a.award_id
                  AND ai.payment_status = 'S'
                  AND ai.batch_ref IS NOT NULL;
            END IF;
         ELSE
            n_award_amount := 0;
            n_award_net_amount := 0;
            n_instalment_net_amount := 0;
         END IF;

         n_total_amount := NVL (n_total_amount, 0) + NVL (n_award_amount, 0);
         n_total_net_amount :=
                      NVL (n_total_net_amount, 0)
                      + NVL (n_award_net_amount, 0);
         n_total_instalment_net_amount :=
              NVL (n_total_instalment_net_amount, 0)
            + NVL (n_instalment_net_amount, 0);
         -- Field 86. Travel Expenses amount (before deduction of contribution and/or overpayment).
         UTL_FILE.put (hreport, ROUND (NVL (n_award_amount, 0), 0) || ',');
         lv_field_number := 86;
         -- Field 87. Travel Expenses net amount awarded to the student
         UTL_FILE.put (hreport, ROUND (NVL (n_award_net_amount, 0), 0) || ',');
         lv_field_number := 87;
         -- Field 88. Travel Expenses amount actually paid to the student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_instalment_net_amount, 0), 0) || ','
                      );
         lv_field_number := 88;

         IF r1.dearing = 'O'
         THEN
            c_applies_value := 'N';
         ELSIF NVL (param_scheme_type, 'x') <> 'B'
         THEN
            OPEN c17 (r1.stud_ref_no);

            FETCH c17
             INTO c_dummy;

            IF c17%FOUND
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;

            CLOSE c17;
         ELSE
            OPEN c17a (r1.stud_ref_no);

            FETCH c17a
             INTO c_dummy;

            IF c17a%FOUND
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;

            CLOSE c17a;
         END IF;

         -- Field 89. Adjustment Payments (ADJ) applies for session code passed in
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 89;

         IF c_applies_value = 'Y'
         THEN
            IF NVL (param_scheme_type, 'x') <> 'B'
            THEN
               SELECT SUM (amount), SUM (net_amount)
                 INTO n_award_amount, n_award_net_amount
                 FROM award
                WHERE stud_ref_no = r1.stud_ref_no
                  AND session_code = param_session_code
                  AND stud_award_type IN ('SSADJ', 'PSADJ', 'UGADJ');

               SELECT SUM (ai.net_amount)
                 INTO n_instalment_net_amount
                 FROM award_instalment ai, award a
                WHERE a.stud_ref_no = r1.stud_ref_no
                  AND a.session_code = param_session_code
                  AND stud_award_type IN ('SSADJ', 'PSADJ', 'UGADJ')
                  AND ai.award_id = a.award_id
                  AND ai.payment_status = 'S'
                  AND ai.batch_ref IS NOT NULL;
            ELSE
               SELECT SUM (amount), SUM (net_amount)
                 INTO n_award_amount, n_award_net_amount
                 FROM award
                WHERE stud_ref_no = r1.stud_ref_no
                  AND session_code = param_session_code
                  AND stud_award_type IN ('SNADJ');

               SELECT SUM (ai.net_amount)
                 INTO n_instalment_net_amount
                 FROM award_instalment ai, award a
                WHERE a.stud_ref_no = r1.stud_ref_no
                  AND a.session_code = param_session_code
                  AND stud_award_type IN ('SNADJ')
                  AND ai.award_id = a.award_id
                  AND ai.payment_status = 'S'
                  AND ai.batch_ref IS NOT NULL;
            END IF;
         ELSE
            n_award_amount := 0;
            n_award_net_amount := 0;
            n_instalment_net_amount := 0;
         END IF;

         n_total_amount := NVL (n_total_amount, 0) + NVL (n_award_amount, 0);
         n_total_net_amount :=
                      NVL (n_total_net_amount, 0)
                      + NVL (n_award_net_amount, 0);
         n_total_instalment_net_amount :=
              NVL (n_total_instalment_net_amount, 0)
            + NVL (n_instalment_net_amount, 0);
         -- Field 90. ADJ amount (before deduction of contribution and/or overpayment).
         UTL_FILE.put (hreport, ROUND (NVL (n_award_amount, 0), 0) || ',');
         lv_field_number := 90;
         -- Field 91. ADJ net amount awarded to the student
         UTL_FILE.put (hreport, ROUND (NVL (n_award_net_amount, 0), 0) || ',');
         lv_field_number := 91;
         -- Field 92. ADJ amount actually paid to the student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_instalment_net_amount, 0), 0) || ','
                      );
         lv_field_number := 92;

         IF r1.dearing = 'O'
         THEN
            c_applies_value := 'N';
         ELSE
            OPEN c18 (r1.stud_ref_no);

            FETCH c18
             INTO c_dummy;

            IF c18%FOUND
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;

            CLOSE c18;
         END IF;

         -- Field 93. Adhoc Payments applies for session code passed in
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 93;

         IF c_applies_value = 'Y'
         THEN
            SELECT SUM (amount), SUM (net_amount)
              INTO n_award_amount, n_award_net_amount
              FROM award
             WHERE stud_ref_no = r1.stud_ref_no
               AND session_code = param_session_code
               AND stud_award_type = 'ADHOC';

            SELECT SUM (ai.net_amount)
              INTO n_instalment_net_amount
              FROM award_instalment ai, award a
             WHERE a.stud_ref_no = r1.stud_ref_no
               AND a.session_code = param_session_code
               AND stud_award_type = 'ADHOC'
               AND ai.award_id = a.award_id
               AND ai.payment_status = 'S'
               AND ai.batch_ref IS NOT NULL;
         ELSE
            n_award_amount := 0;
            n_award_net_amount := 0;
            n_instalment_net_amount := 0;
         END IF;

         n_total_amount := NVL (n_total_amount, 0) + NVL (n_award_amount, 0);
         n_total_net_amount :=
                      NVL (n_total_net_amount, 0)
                      + NVL (n_award_net_amount, 0);
         n_total_instalment_net_amount :=
              NVL (n_total_instalment_net_amount, 0)
            + NVL (n_instalment_net_amount, 0);
         -- Field 94. Adhoc amount (before deduction of contribution and/or overpayment).
         UTL_FILE.put (hreport, ROUND (NVL (n_award_amount, 0), 0) || ',');
         lv_field_number := 94;
         -- Field 95. Adhoc net amount awarded to the student
         UTL_FILE.put (hreport, ROUND (NVL (n_award_net_amount, 0), 0) || ',');
         lv_field_number := 95;
         -- Field 96. Adhoc amount actually paid to the student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_instalment_net_amount, 0), 0) || ','
                      );
         lv_field_number := 96;

/******************************************************************/
         IF NVL (param_scheme_type, 'x') <> 'B' AND r1.dearing <> 'O'
         THEN
            OPEN c26 (r1.stud_ref_no);

            FETCH c26
             INTO r26;

            IF c26%FOUND
            THEN
               c_187_applies_value := 'Y';
            ELSE
               c_187_applies_value := 'N';
            END IF;

            CLOSE c26;
         ELSE
            c_187_applies_value := 'N';
         END IF;

         -- Field 204. Young students Bursary
         --UTL_FILE.PUT(hReport,c_applies_value||',');
         IF NVL (param_scheme_type, 'x') <> 'B' AND r1.dearing <> 'O'
         THEN
            OPEN c26a (r1.stud_ref_no);

            FETCH c26a
             INTO r26a;

            IF c26a%FOUND
            THEN
               ca_187_applies_value := 'Y';
            ELSE
               ca_187_applies_value := 'N';
            END IF;

            CLOSE c26a;
         ELSE
            ca_187_applies_value := 'N';
         END IF;

         -- Field 243. Young students Bursary
         --UTL_FILE.PUT(hReport,c_applies_value||',');
         IF c_187_applies_value = 'Y'
         THEN
            SELECT SUM (amount), SUM (net_amount)
              INTO v_188_amount, v_189_net_amount
              FROM award
             WHERE stud_ref_no = r1.stud_ref_no
               AND session_code = param_session_code
               AND stud_award_type = 'YSB';

            --
            SELECT SUM (net_amount)
              INTO v_190_awi_net_amount
              FROM award_instalment
             WHERE award_id IN (
                      SELECT award_id
                        FROM award
                       WHERE stud_ref_no = r1.stud_ref_no
                         AND session_code = param_session_code
                         AND stud_award_type = 'YSB'
                         AND payment_status = 'S'
                         AND batch_ref IS NOT NULL);
         ELSE
            v_188_amount := 0;
            v_189_net_amount := 0;
            v_190_awi_net_amount := 0;
         END IF;

         n_total_amount := NVL (n_total_amount, 0) + NVL (v_188_amount, 0);
         n_total_net_amount :=
                        NVL (n_total_net_amount, 0)
                        + NVL (v_189_net_amount, 0);
         n_total_instalment_net_amount :=
              NVL (n_total_instalment_net_amount, 0)
            + NVL (v_190_awi_net_amount, 0);

         -- Field 205. Young students Bursary entitlement amount
         --UTL_FILE.PUT(hReport,v_amount||',');
         -- Field 206. Young students Bursary entitlement net amount
         --UTL_FILE.PUT(hReport,v_net_amount||',');
         -- Field 207. Young students Bursary actually paid
         --UTL_FILE.PUT(hReport,v_awi_net_amount||',');
         IF ca_187_applies_value = 'Y'
         THEN
            SELECT SUM (amount), SUM (net_amount)
              INTO va_188_amount, va_189_net_amount
              FROM award
             WHERE stud_ref_no = r1.stud_ref_no
               AND session_code = param_session_code
               AND stud_award_type = 'ISB';

            --
            SELECT SUM (net_amount)
              INTO va_190_awi_net_amount
              FROM award_instalment
             WHERE award_id IN (
                      SELECT award_id
                        FROM award
                       WHERE stud_ref_no = r1.stud_ref_no
                         AND session_code = param_session_code
                         AND stud_award_type = 'ISB'
                         AND payment_status = 'S'
                         AND batch_ref IS NOT NULL);
         ELSE
            va_188_amount := 0;
            va_189_net_amount := 0;
            va_190_awi_net_amount := 0;
         END IF;

         n_total_amount := NVL (n_total_amount, 0) + NVL (va_188_amount, 0);
         n_total_net_amount :=
                       NVL (n_total_net_amount, 0)
                       + NVL (va_189_net_amount, 0);
         n_total_instalment_net_amount :=
              NVL (n_total_instalment_net_amount, 0)
            + NVL (va_190_awi_net_amount, 0);

         -- Field 244. ISB entitlement amount
         --UTL_FILE.PUT(hReport,v_amount||',');
         -- Field 245. ISB entitlement net amount
         --UTL_FILE.PUT(hReport,v_net_amount||',');
         -- Field 246. ISB actually paid
         --UTL_FILE.PUT(hReport,v_awi_net_amount||',');
         IF NVL (param_scheme_type, 'x') <> 'B' AND r1.dearing <> 'O'
         THEN
            OPEN c27 (r1.stud_ref_no);

            FETCH c27
             INTO r27;

            IF c27%FOUND
            THEN
               c_191_applies_value := 'Y';
            ELSE
               c_191_applies_value := 'N';
            END IF;

            CLOSE c27;
         ELSE
            c_191_applies_value := 'N';
         END IF;

         -- Field 208. Young students without Bursary
         --UTL_FILE.PUT(hReport,c_applies_value||',');
         IF c_191_applies_value = 'Y'
         THEN
            SELECT SUM (amount), SUM (net_amount)
              INTO v_192_amount, v_193_net_amount
              FROM award
             WHERE stud_ref_no = r1.stud_ref_no
               AND session_code = param_session_code
               AND stud_award_type = 'YSO';

            --
            SELECT SUM (net_amount)
              INTO v_194_awi_net_amount
              FROM award_instalment
             WHERE award_id IN (
                      SELECT award_id
                        FROM award
                       WHERE stud_ref_no = r1.stud_ref_no
                         AND session_code = param_session_code
                         AND stud_award_type = 'YSO'
                         AND payment_status = 'S'
                         AND batch_ref IS NOT NULL);
         ELSE
            v_192_amount := 0;
            v_193_net_amount := 0;
            v_194_awi_net_amount := 0;
         END IF;

         n_total_amount := NVL (n_total_amount, 0) + NVL (v_192_amount, 0);
         n_total_net_amount :=
                        NVL (n_total_net_amount, 0)
                        + NVL (v_193_net_amount, 0);
         n_total_instalment_net_amount :=
              NVL (n_total_instalment_net_amount, 0)
            + NVL (v_194_awi_net_amount, 0);

         -- Field 209. Young students without Bursary entitlement amount
         --UTL_FILE.PUT(hReport,v_amount||',');
         -- Field 210. Young students without Bursary entitlement net amount
         --UTL_FILE.PUT(hReport,v_net_amount||',');
         -- Field 211. Young students without Bursary actually paid
         --UTL_FILE.PUT(hReport,v_awi_net_amount||',');
         --
         -- RFC 219
         --
         IF NVL (param_scheme_type, 'x') <> 'B' AND r1.dearing <> 'O'
         THEN
            OPEN cu_sosb (r1.stud_ref_no);

            FETCH cu_sosb
             INTO rec_sosb;

            IF cu_sosb%FOUND
            THEN
               c_sosb_applies_value := 'Y';
            ELSE
               c_sosb_applies_value := 'N';
            END IF;

            CLOSE cu_sosb;
         ELSE
            c_sosb_applies_value := 'N';
         END IF;

         --
         IF c_sosb_applies_value = 'Y'
         THEN
            SELECT SUM (amount), SUM (net_amount)
              INTO v_sosb_amount, v_sosb_net_amount
              FROM award
             WHERE stud_ref_no = r1.stud_ref_no
               AND session_code = param_session_code
               AND stud_award_type = 'SOSB';

            --
            SELECT SUM (net_amount)
              INTO v_sosb_awi_net_amount
              FROM award_instalment
             WHERE award_id IN (
                      SELECT award_id
                        FROM award
                       WHERE stud_ref_no = r1.stud_ref_no
                         AND session_code = param_session_code
                         AND stud_award_type = 'SOSB')
               AND payment_status = 'S'
               AND batch_ref IS NOT NULL;
         ELSE
            v_sosb_amount := 0;
            v_sosb_net_amount := 0;
            v_sosb_awi_net_amount := 0;
         END IF;

         n_total_amount := NVL (n_total_amount, 0) + NVL (v_sosb_amount, 0);
         n_total_net_amount :=
                       NVL (n_total_net_amount, 0)
                       + NVL (v_sosb_net_amount, 0);
         n_total_instalment_net_amount :=
              NVL (n_total_instalment_net_amount, 0)
            + NVL (v_sosb_awi_net_amount, 0);

         --
         -- End of RFC 219
         --
         IF NVL (param_scheme_type, 'x') <> 'B' AND r1.dearing <> 'O'
         THEN
            OPEN c28 (r1.stud_ref_no);

            FETCH c28
             INTO r28;

            IF c28%FOUND
            THEN
               c_195_applies_value := 'Y';
            ELSE
               c_195_applies_value := 'N';
            END IF;

            CLOSE c28;
         ELSE
            c_195_applies_value := 'N';
         END IF;

         -- Field 216. Lone Parent Childcare Grant
         --UTL_FILE.PUT(hReport,c_applies_value||',');
         IF c_195_applies_value = 'Y'
         THEN
            SELECT SUM (amount), SUM (net_amount)
              INTO v_196_amount, v_197_net_amount
              FROM award
             WHERE stud_ref_no = r1.stud_ref_no
               AND session_code = param_session_code
               AND stud_award_type = 'LPCG';

            --
            SELECT SUM (net_amount)
              INTO v_198_awi_net_amount
              FROM award_instalment
             WHERE award_id IN (
                      SELECT award_id
                        FROM award
                       WHERE stud_ref_no = r1.stud_ref_no
                         AND session_code = param_session_code
                         AND stud_award_type = 'LPCG'
                         AND payment_status = 'S'
                         AND batch_ref IS NOT NULL);
         ELSE
            v_196_amount := 0;
            v_197_net_amount := 0;
            v_198_awi_net_amount := 0;
         END IF;

         n_total_amount := NVL (n_total_amount, 0) + NVL (v_196_amount, 0);
         n_total_net_amount :=
                        NVL (n_total_net_amount, 0)
                        + NVL (v_197_net_amount, 0);
         n_total_instalment_net_amount :=
              NVL (n_total_instalment_net_amount, 0)
            + NVL (v_198_awi_net_amount, 0);

         -- Field 217. LPCG entitlement amount
         --UTL_FILE.PUT(hReport,v_amount||',');
         -- Field 218. LPCG net amount
         --UTL_FILE.PUT(hReport,v_net_amount||',');
         -- Field 219. LPCG amount paid
         --UTL_FILE.PUT(hReport,v_awi_net_amount||',');
         IF NVL (param_scheme_type, 'x') <> 'B' AND r1.dearing <> 'O'
         THEN
            OPEN c29 (r1.stud_ref_no);

            FETCH c29
             INTO r29;

            IF c29%FOUND
            THEN
               c_199_applies_value := 'Y';
            ELSE
               c_199_applies_value := 'N';
            END IF;

            CLOSE c29;
         ELSE
            c_199_applies_value := 'N';
         END IF;

         -- Field 220. School meals Grant
         --UTL_FILE.PUT(hReport,c_applies_value||',');
         IF c_199_applies_value = 'Y'
         THEN
            SELECT SUM (amount), SUM (net_amount)
              INTO v_200_amount, v_201_net_amount
              FROM award
             WHERE stud_ref_no = r1.stud_ref_no
               AND session_code = param_session_code
               AND stud_award_type = 'SMG';

            --
            SELECT SUM (net_amount)
              INTO v_202_awi_net_amount
              FROM award_instalment
             WHERE award_id IN (
                      SELECT award_id
                        FROM award
                       WHERE stud_ref_no = r1.stud_ref_no
                         AND session_code = param_session_code
                         AND stud_award_type = 'SMG'
                         AND payment_status = 'S'
                         AND batch_ref IS NOT NULL);
         ELSE
            v_200_amount := 0;
            v_201_net_amount := 0;
            v_202_awi_net_amount := 0;
         END IF;

         n_total_amount := NVL (n_total_amount, 0) + NVL (v_200_amount, 0);
         n_total_net_amount :=
                        NVL (n_total_net_amount, 0)
                        + NVL (v_201_net_amount, 0);
         n_total_instalment_net_amount :=
              NVL (n_total_instalment_net_amount, 0)
            + NVL (v_202_awi_net_amount, 0);

         -- Field 221. SMG entitlement amount
         --UTL_FILE.PUT(hReport,v_amount||',');
         -- Field 222. SMG net amount awarded
         --UTL_FILE.PUT(hReport,v_net_amount||',');
         -- Field 223. SMG paid
         --UTL_FILE.PUT(hReport,v_awi_net_amount||',');
         IF NVL (param_scheme_type, 'x') <> 'B'
         THEN
            OPEN c30 (r1.stud_ref_no);

            FETCH c30
             INTO r30;

            IF r30.COUNT <> 0
            THEN
               c_203_applies_value := 'Y';
            ELSE
               c_203_applies_value := 'N';
            END IF;

            CLOSE c30;
         ELSE
            c_203_applies_value := 'N';
         END IF;

         -- Field 224. Disabled students allowance non-fees(DSA)
         --UTL_FILE.PUT(hReport,c_applies_value||',');
         OPEN c31 (r1.stud_ref_no);

         FETCH c31
          INTO r31;

         CLOSE c31;

         IF c_203_applies_value = 'N'
         THEN
            r31.amount := 0;
            r31.net_amount := 0;
         END IF;

         n_total_amount := NVL (n_total_amount, 0) + NVL (r31.amount, 0);
         n_total_net_amount :=
                          NVL (n_total_net_amount, 0)
                          + NVL (r31.net_amount, 0);

         -- Field 225. DSA non-fees amount
         --UTL_FILE.PUT(hReport,r31.amount||',');
         -- Field 226. DDSA non-fees net amount
         --UTL_FILE.PUT(hReport,r31.net_amount||',');
         IF c_203_applies_value = 'Y'
         THEN
            SELECT SUM (net_amount)
              INTO v_206_net_amount
              FROM award_instalment
             WHERE payment_status = 'S'
               AND batch_ref IS NOT NULL
               AND NVL (dsa_fee_instalment, 'N') = 'N'
               AND award_id IN (
                      SELECT award_id
                        FROM award
                       WHERE stud_ref_no = r1.stud_ref_no
                         AND session_code = param_session_code
                         AND stud_award_type IN ('SSDSA', 'PSDSA', 'UGDSA'));
         ELSE
            v_206_net_amount := 0;
         END IF;

         n_total_instalment_net_amount :=
             NVL (n_total_instalment_net_amount, 0)
             + NVL (v_206_net_amount, 0);
   -- Field 227. DDSA non-fees amount actually paid to student.
   --UTL_FILE.PUT(hReport,v_net_amount||',');
/******************************************************************/
   -- Field 97. Total student award entitlement
         UTL_FILE.put (hreport, ROUND (NVL (n_total_amount, 0), 0) || ',');
         lv_field_number := 97;
         -- Field 98. Total student award - net amount
         UTL_FILE.put (hreport, ROUND (NVL (n_total_net_amount, 0), 0) || ',');
         lv_field_number := 98;
         -- Field 99. Total student award payments actually paid to the student
         UTL_FILE.put (hreport,
                       ROUND (NVL (n_total_instalment_net_amount, 0), 0)
                      );
         lv_field_number := 99;
         -- process first benefactor details
         benefactor_details (hreport,
                             r4.ben1_id,
                             r4.ben1_rel_id,
                             param_session_code,
                             param_scheme_type
                            );
         -- process second benefactor details
         benefactor_details (hreport,
                             r4.ben2_id,
                             r4.ben2_rel_id,
                             param_session_code,
                             param_scheme_type
                            );
         -- Field 134. Scottish Cand
         UTL_FILE.put (hreport, ',' || v_scottish_cand || ',');
         lv_field_number := 134;
         -- Field 135. NI_NO
         UTL_FILE.put (hreport, r2.ni_no || ',');
         lv_field_number := 135;
         -- Field 136.
         UTL_FILE.put (hreport, r1.disablement_code || ',');
         lv_field_number := 136;

         BEGIN
            SELECT study_abroad
              INTO v_study_abroad
              FROM stud_crse_year
             WHERE stud_crse_year_id = r1.stud_crse_year_id
               AND latest_crse_ind = 'Y';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_study_abroad := NULL;
         END;

         IF NVL (v_study_abroad, 'N') = 'Y'
         THEN
            c_applies_value := 'Y';
         ELSE
            c_applies_value := 'N';
         END IF;

         -- Field 137. Study Abroad
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 137;

         IF c_applies_value = 'Y'
         THEN
            BEGIN
               SELECT country.short_name, scy.study_country
                 INTO v_study_country, v_study_country_code
                 FROM country, stud_crse_year scy
                WHERE country_code = scy.study_country
                  AND stud_crse_year_id = r1.stud_crse_year_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_study_country := NULL;
            END;
         ELSE
            v_study_country := NULL;
         END IF;

         -- Field 138. Study Country
         UTL_FILE.put (hreport, v_study_country_code || ',');
         lv_field_number := 138;

         IF c_applies_value = 'Y'
         THEN
            BEGIN
               SELECT start_date_abroad, end_date_abroad
                 INTO v_start_abroad_date, v_end_abroad_date
                 FROM stud_crse_year scy, stud
                WHERE scy.stud_crse_year_id = r1.stud_crse_year_id
                  AND scy.stud_ref_no = stud.stud_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_start_abroad_date := NULL;
                  v_end_abroad_date := NULL;
            END;
         ELSE
            v_start_abroad_date := NULL;
            v_end_abroad_date := NULL;
         END IF;

         -- Field 139. Study Abroad Start Date
         UTL_FILE.put (hreport,
                       TO_CHAR (v_start_abroad_date, 'DD-MON-YYYY') || ','
                      );
         lv_field_number := 139;
         -- Field 140. Study Abroad End Date
         UTL_FILE.put (hreport,
                       TO_CHAR (v_end_abroad_date, 'DD-MON-YYYY') || ','
                      );
         lv_field_number := 140;

         BEGIN
            SELECT country.short_name, stud.residence_country_code
              INTO v_country_residence, v_residence_country_code
              FROM country, stud
             WHERE country.country_code = stud.residence_country_code
               AND stud.stud_ref_no = r1.stud_ref_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_country_residence := NULL;
         END;

         -- Field 141. Country of Residence
         UTL_FILE.put (hreport, v_residence_country_code || ',');
         lv_field_number := 141;

         --
         -- RFC 219
         --
         BEGIN
            SELECT birth_country_code, nation_country_code
              INTO v_birth_country, v_nation_country_code
              FROM stud
             WHERE stud.stud_ref_no = r1.stud_ref_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_birth_country := NULL;
               v_nation_country_code := NULL;
         END;

         --Field 142. Country of Birth
         UTL_FILE.put (hreport, v_birth_country || ',');
         lv_field_number := 142;
         --Field 143. Nationality
         UTL_FILE.put (hreport, v_nation_country_code || ',');
         lv_field_number := 143;

         --
         --
         --
         IF r2.payment_method = 'C'
         THEN
            c_applies_value := 'N';
         ELSE
            c_applies_value := 'Y';
         END IF;

         -- Field 144. BACS Indicator
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 144;
         -- Field 145. Joint Assessment Relationship
         UTL_FILE.put (hreport, r4.ja_stud_type || ',');
         lv_field_number := 145;

         IF NVL (param_scheme_type, 'x') <> 'B'
         THEN
            IF r4.smg_entitlement IS NULL
            THEN
               r4.smg_entitlement := 0;
            END IF;
         ELSE
            r4.smg_entitlement := 0;
         END IF;

         -- Field 146. SMG Entitlement Amount
         UTL_FILE.put (hreport, r4.smg_entitlement || ',');
         lv_field_number := 146;

         IF r1.dearing = 'O'
         THEN
            BEGIN
               SELECT pt_loan_check, pt_loan_claimed
                 INTO v_pt_loan_check, v_pt_loan_claimed
                 FROM stud_session
                WHERE stud_ref_no = r1.stud_ref_no
                  AND session_code = param_session_code;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_pt_loan_check := NULL;
                  v_pt_loan_claimed := NULL;
            END;

            IF     NVL (v_pt_loan_check, 'N') = 'Y'
               AND NVL (v_pt_loan_claimed, 'N') = 'Y'
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;
         ELSIF NVL (param_scheme_type, 'x') <> 'B'
         THEN
            BEGIN
               SELECT max_loan_requested
                 INTO v_max_loan_requested
                 FROM stud_session
                WHERE stud_ref_no = r1.stud_ref_no
                  AND session_code = param_session_code;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_max_loan_requested := NULL;
            END;

            IF v_max_loan_requested IS NULL OR v_max_loan_requested = 'N'
            THEN
               SELECT SUM (awi.unclaimed_loan)
                 INTO v_sum_unclaimed_loan
                 FROM award_instalment awi, award aw
                WHERE awi.award_id = aw.award_id
                  AND stud_award_type IN
                         ('UCHNFL',
                          'UCHNL',
                          'UCMFL',
                          'UCML',
                          'UCNFL',
                          'UCNL',
                          'UDHNFL',
                          'UDHNL',
                          'UDMFL',
                          'UDML',
                          'UDNFL',
                          'UDNL',
                          'UDNXL',
                          'UEMFL',
                          'UEML',
                          'UENFL',
                          'UENL',
                          'UGHNFL',
                          'UGHNL',
                          'UGMFL',
                          'UGML',
                          'UGNFL',
                          'UGNL'
                         )
                  AND aw.stud_crse_year_id = r1.stud_crse_year_id;

               IF v_sum_unclaimed_loan > 0
               THEN
                  c_applies_value := 'N';
               ELSE
                  c_applies_value := 'Y';
               END IF;
            ELSE
               c_applies_value := 'Y';
            END IF;
         ELSE
            c_applies_value := 'N';
         END IF;                                    --IF r1.dearing = 'O' THEN

         -- Field 147. Max Loan Requested Indicator
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 147;
         -- Field 148. Date Apllication Received.
         UTL_FILE.put (hreport,
                       TO_CHAR (r4.date_applic_received, 'DD-MON-YYYY') || ','
                      );
         lv_field_number := 148;

         --
         IF r1.crse_year_id IS NOT NULL
         THEN
            BEGIN
               SELECT cy.default_terms
                 INTO v_default_term
                 FROM crse_session cs, crse_year cy
                WHERE cs.crse_session_id = cy.crse_session_id
                  AND cy.crse_year_id = r1.crse_year_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_default_term := NULL;
            END;

            --
            IF NVL (v_default_term, 'x') = 'N'
            THEN
               SELECT   MIN (start_date)
                   INTO d_start_term_date
                   FROM crse_term ct
                  WHERE ct.crse_year_id = r1.crse_year_id
               GROUP BY crse_year_id;
            ELSE
               SELECT MIN (start_date)
                 INTO d_start_term_date
                 FROM inst_term
                WHERE inst_code = r1.inst_code
                  AND session_code = param_session_code;
            END IF;
         ELSE
            d_start_term_date := NULL;
         END IF;

         d_start_term_date :=
                          TO_DATE (TO_CHAR (d_start_term_date, 'DD-MON-YYYY'));
         -- Field 149. Start date of course.
         UTL_FILE.put (hreport,
                       TO_CHAR (d_start_term_date, 'DD-MON-YYYY') || ','
                      );
         lv_field_number := 149;

         IF r1.erasmus IS NULL
         THEN
            r1.erasmus := 'N';
         END IF;

         -- Field 150. Erasmus Indicator
         UTL_FILE.put (hreport, r1.erasmus || ',');
         lv_field_number := 150;

         --Format mask of r1.withdraw date altered as part of SIR 1442.  PB 08/10/2003
         IF r1.withdraw_date IS NOT NULL
         THEN
            r1.withdraw_date := TO_CHAR (r1.withdraw_date, 'DD-MON-YYYY');
         END IF;

         -- Field 151. Date of Withdrawal
         UTL_FILE.put (hreport,
                       TO_CHAR (r1.withdraw_date, 'DD-MON-YYYY') || ','
                      );
         lv_field_number := 151;
         r4.loan_declaration_date :=
                   TO_DATE (TO_CHAR (r4.loan_declaration_date, 'DD-MON-YYYY'));
         -- Field 152. Loan Signature Date
         UTL_FILE.put (hreport,
                       TO_CHAR (r4.loan_declaration_date, 'DD-MON-YYYY')
                       || ','
                      );
         lv_field_number := 152;

         --
         OPEN c22 (r1.crse_id);

         FETCH c22
          INTO r22;

         CLOSE c22;

         --
         IF NVL (r22.ge_liable, 'N') = 'Y'
         THEN
            c_applies_value := 'Y';
         ELSE
            c_applies_value := 'N';
         END IF;

         -- Field 153. GE Liability
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 153;
         -- Field 154. Count Contact Details
         UTL_FILE.put (hreport, v_cont_count || ',');
         lv_field_number := 154;

         SELECT fast_track
           INTO c_applies_value
           FROM stud_crse_year
          WHERE stud_crse_year_id = r1.stud_crse_year_id;

         --
         IF NVL (c_applies_value, 'N') = 'N'
         THEN
            c_applies_value := 'N';
         ELSE
            c_applies_value := 'Y';
         END IF;

         -- Field 155. Fast Track Indicator
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 155;

         BEGIN
            SELECT post_code
              INTO v_post_code
              FROM stud_home_addr
             WHERE end_date IS NULL AND stud_ref_no = r1.stud_ref_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_post_code := NULL;
         END;

         -- Field 156. Post Code
         UTL_FILE.put (hreport, v_post_code || ',');
         lv_field_number := 156;

         BEGIN
            SELECT first_calc_date
              INTO v_first_calc_date
              FROM stud_crse_year
             WHERE latest_crse_ind = 'Y'
               AND stud_crse_year_id = r1.stud_crse_year_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_first_calc_date := NULL;
         END;

         --
         IF v_first_calc_date IS NOT NULL
         THEN
            v_first_calc_date := TO_CHAR (v_first_calc_date, 'DD-MON-YYYY');
         END IF;

         -- Field 157. First calc date for latest stud crse year record
         UTL_FILE.put (hreport,
                       TO_CHAR (v_first_calc_date, 'DD-MON-YYYY') || ','
                      );
         lv_field_number := 157;

         IF     NVL (r1.paid_sandwich, 'N') = 'N'
            AND NVL (r1.unpaid_sandwich, 'N') = 'N'
         THEN
            c_applies_value := 'N';
         ELSIF     NVL (r1.paid_sandwich, 'N') = 'Y'
               AND NVL (r1.unpaid_sandwich, 'N') = 'N'
         THEN
            c_applies_value := 'P';
         ELSIF     NVL (r1.paid_sandwich, 'N') = 'N'
               AND NVL (r1.unpaid_sandwich, 'N') = 'Y'
         THEN
            c_applies_value := 'U';
         END IF;

         -- Field 158.
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 158;

         --
         BEGIN
            SELECT location_ind
              INTO v_location
              FROM inst
             WHERE inst_code = r1.inst_code;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_location := NULL;
         END;

         --
         IF r22.qual_type = 'PGCE' OR NVL (r1.pgce, 'N') = 'Y'
         THEN
            IF v_location <> 1
            THEN
               c_applies_value := 'O';
            ELSIF r22.crse_code = '0015'
            THEN
               c_applies_value := 'P';
            ELSIF r22.crse_code = '0025'
            THEN
               c_applies_value := 'S';
            ELSE
               c_applies_value := 'Y';
            END IF;
         ELSE
            c_applies_value := 'N';
         END IF;

         -- Field 159. PGCE Indicator
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 159;

         --IF statement added by PB
         --RFC 219
         IF c_45_applies_value = 'Y'
         THEN
            -- Field 160. Fee Loan Declaration Date
            UTL_FILE.put (hreport, r4.fee_loan_declaration_date || ',');
            lv_field_number := 160;
            -- Field 161. Max Fee Loan Requested
            UTL_FILE.put (hreport,
                          NVL (r4.max_fee_loan_requested, 'N') || ',');
            lv_field_number := 161;
         ELSE
            -- Field 160. Fee Loan Declaration Date
            UTL_FILE.put (hreport, NULL || ',');
            lv_field_number := 160;
            -- Field 161. Max Fee Loan Requested
            UTL_FILE.put (hreport, NULL || ',');
            lv_field_number := 161;
         END IF;

         --
         --
         IF r1.dearing <> 'O'
         THEN
            SELECT COUNT (*)
              INTO v_dependant_count
              FROM stud_dependant
             WHERE session_code = param_session_code
               AND stud_ref_no = r1.stud_ref_no
               AND NVL (include, 'N') = 'Y';
         ELSE
            v_dependant_count := 0;
         END IF;

         -- Field 162. Count of Stud Dependants
         UTL_FILE.put (hreport, v_dependant_count || ',');
         lv_field_number := 162;

         IF v_dependant_count = 0
         THEN
            FOR x IN 1 .. 10
            LOOP
               r23.dob := NULL;
               r23.relation_id := NULL;
               -- Student Dependant Age
               UTL_FILE.put (hreport, r23.dob || ',');
               lv_field_number := 'Student Dependant Age';
               -- Relationship Code
               UTL_FILE.put (hreport, r23.relation_id || ',');
               lv_field_number := 'Relationship Code';
            END LOOP;
         ELSIF v_dependant_count <> 0
         THEN
            x := 1;

            FOR r23 IN c23 (r1.stud_ref_no)
            LOOP
               IF x <= 10
               THEN
                  -- Student Dependant Age
                  UTL_FILE.put (hreport, r23.dob || ',');
                  lv_field_number := 'Student Dependant Age';
                  -- Relationship Code
                  UTL_FILE.put (hreport, r23.relation_id || ',');
                  lv_field_number := 'Relationship Code';
               ELSE
                  NULL;
               END IF;

               x := x + 1;
            END LOOP;

            IF (v_dependant_count < 10) AND (v_dependant_count <> 0)
            THEN
               FOR y IN 1 .. (10 - v_dependant_count)
               LOOP
                  r23.dob := NULL;
                  r23.relation_id := NULL;
                  -- Student Dependant Age
                  UTL_FILE.put (hreport, r23.dob || ',');
                  lv_field_number := 'Student Dependant Age';
                  -- Relationship Code
                  UTL_FILE.put (hreport, r23.relation_id || ',');
                  lv_field_number := 'Relationship Code';
               END LOOP;
            END IF;
         END IF;

         --
         IF NVL (param_scheme_type, 'x') <> 'B'
         THEN
            SELECT COUNT (*)
              INTO v_ben1_dep_count
              FROM benefactor_dependant
             WHERE ben_id IN (
                      SELECT ben1_id
                        FROM stud_session
                       WHERE session_code = param_session_code
                         AND stud_ref_no = r1.stud_ref_no);

            SELECT COUNT (*)
              INTO v_ben2_dep_count
              FROM benefactor_dependant
             WHERE ben_id IN (
                      SELECT ben2_id
                        FROM stud_session
                       WHERE session_code = param_session_code
                         AND stud_ref_no = r1.stud_ref_no);

            v_ben_dep_count := v_ben1_dep_count + v_ben2_dep_count;
         ELSE
            v_ben_dep_count := 0;
         END IF;

         -- Field 183. Count of Benefactor Dependants
         UTL_FILE.put (hreport, v_ben_dep_count || ',');
         lv_field_number := 183;

         IF v_ben_dep_count = 0
         THEN
            FOR x IN 1 .. 10
            LOOP
               v_age := NULL;
               v_relation := NULL;
               -- Benefactor Dependant Age
               UTL_FILE.put (hreport, v_age || ',');
               lv_field_number := 'Benefactor Dependant Age';
               -- Relationship code of Benefactor Dependant
               UTL_FILE.put (hreport, v_relation || ',');
               lv_field_number := 'Relationship Code of Benefactor Dependant';
            END LOOP;
         END IF;

         --
         x := 1;

         IF v_ben1_dep_count <> 0
         THEN
            FOR r24 IN c24 (r1.stud_ref_no)
            LOOP
               IF x <= 10
               THEN
                  -- Benefactor Dependant Age
                  UTL_FILE.put (hreport, r24.dob || ',');
                  lv_field_number := 'Benefactor Dependant Age';
                  -- Relationship code of Benefactor Dependant
                  UTL_FILE.put (hreport, r24.relation_type_id || ',');
                  lv_field_number :=
                                  'Relationship Code of Benefactor Dependant';
               ELSE
                  NULL;
               END IF;

               x := x + 1;
            END LOOP;
         END IF;

         --
         IF v_ben1_dep_count < 10
         THEN
            IF v_ben2_dep_count <> 0
            THEN
               FOR r25 IN c25 (r1.stud_ref_no)
               LOOP
                  IF x <= 10
                  THEN
                     -- Benefactor Dependant Age
                     UTL_FILE.put (hreport, r25.dob || ',');
                     lv_field_number := 'Benefactor Dependant Age';
                     -- Relationship code of Benefactor Dependant
                     UTL_FILE.put (hreport, r25.relation_type_id || ',');
                     lv_field_number :=
                                  'Relationship Code of Benefactor Dependant';
                  ELSE
                     NULL;
                  END IF;

                  x := x + 1;
               END LOOP;
            END IF;
         END IF;

         --
         IF (v_ben_dep_count < 10) AND (v_ben_dep_count <> 0)
         THEN
            FOR y IN 1 .. (10 - v_ben_dep_count)
            LOOP
               v_age := NULL;
               v_relation := NULL;
               -- Benefactor Dependant Age
               UTL_FILE.put (hreport, v_age || ',');
               lv_field_number := 'Benefactor Dependant Age';
               -- Relationship code of Benefactor Dependant
               UTL_FILE.put (hreport, v_relation || ',');
               lv_field_number := 'Relationship Code of Benefactor Dependant';
            END LOOP;
         END IF;

         -- Field 204. Young students Bursary
         UTL_FILE.put (hreport, c_187_applies_value || ',');
         lv_field_number := 204;
         -- Field 205. Young students Bursary entitlement amount
         UTL_FILE.put (hreport, NVL (v_188_amount, 0) || ',');
         lv_field_number := 205;
         -- Field 206. Young students Bursary entitlement net amount
         UTL_FILE.put (hreport, NVL (v_189_net_amount, 0) || ',');
         lv_field_number := 206;
         -- Field 207. Young students Bursary actually paid
         UTL_FILE.put (hreport, NVL (v_190_awi_net_amount, 0) || ',');
         lv_field_number := 207;
         -- Field 208. Young students without Bursary
         UTL_FILE.put (hreport, c_191_applies_value || ',');
         lv_field_number := 208;
         -- Field 209. Young students without Bursary entitlement amount
         UTL_FILE.put (hreport, NVL (v_192_amount, 0) || ',');
         lv_field_number := 209;
         -- Field 210. Young students without Bursary entitlement net amount
         UTL_FILE.put (hreport, NVL (v_193_net_amount, 0) || ',');
         lv_field_number := 210;
         -- Field 211. Young students without Bursary actually paid
         UTL_FILE.put (hreport, NVL (v_194_awi_net_amount, 0) || ',');
         lv_field_number := 211;
         --
         -- RFC 219
         --
         -- Field 212. SOSB applies
         UTL_FILE.put (hreport, c_sosb_applies_value || ',');
         lv_field_number := 212;
         -- Field 213. SOSB entitlement amount
         UTL_FILE.put (hreport, NVL (v_sosb_amount, 0) || ',');
         lv_field_number := 213;
         -- Field 214. SOSB entitlement net amount
         UTL_FILE.put (hreport, NVL (v_sosb_net_amount, 0) || ',');
         lv_field_number := 214;
         -- Field 215. SOSB actually paid
         UTL_FILE.put (hreport, NVL (v_sosb_awi_net_amount, 0) || ',');
         lv_field_number := 215;
         --
         --
         --
         -- Field 216. Lone Parent Childcare Grant
         UTL_FILE.put (hreport, c_195_applies_value || ',');
         lv_field_number := 216;
         -- Field 217. LPCG entitlement amount
         UTL_FILE.put (hreport, NVL (v_196_amount, 0) || ',');
         lv_field_number := 217;
         -- Field 218. LPCG net amount
         UTL_FILE.put (hreport, NVL (v_197_net_amount, 0) || ',');
         lv_field_number := 218;
         -- Field 219. LPCG amount paid
         UTL_FILE.put (hreport, NVL (v_198_awi_net_amount, 0) || ',');
         lv_field_number := 219;
         -- Field 220. School meals Grant
         UTL_FILE.put (hreport, c_199_applies_value || ',');
         lv_field_number := 220;
         -- Field 221. SMG entitlement amount
         UTL_FILE.put (hreport, NVL (v_200_amount, 0) || ',');
         lv_field_number := 221;
         -- Field 222. SMG net amount awarded
         UTL_FILE.put (hreport, NVL (v_201_net_amount, 0) || ',');
         lv_field_number := 222;
         -- Field 223. SMG paid
         UTL_FILE.put (hreport, NVL (v_202_awi_net_amount, 0) || ',');
         lv_field_number := 223;
         -- Field 224. Disabled students allowance non-fees(DSA)
         UTL_FILE.put (hreport, c_203_applies_value || ',');
         lv_field_number := 224;

         IF c_203_applies_value = 'N'
         THEN
            r31.amount := 0;
            r31.net_amount := 0;
         END IF;

         -- Field 225. DSA non-fees amount
         UTL_FILE.put (hreport, r31.amount || ',');
         lv_field_number := 225;
         -- Field 226. DDSA non-fees net amount
         UTL_FILE.put (hreport, r31.net_amount || ',');
         lv_field_number := 226;
         -- Field 227. DDSA non-fees amount actually paid to student.
         UTL_FILE.put (hreport, NVL (v_206_net_amount, 0) || ',');
         lv_field_number := 227;

         IF NVL (param_scheme_type, 'x') <> 'B'
         THEN
            SELECT COUNT (*)
              INTO v_count
              FROM award
             WHERE stud_crse_year_id = r1.stud_crse_year_id
               AND stud_ref_no = r1.stud_ref_no
               AND session_code = param_session_code
               AND award_src = 'A'
               AND stud_award_type IN
                      ('UCMFL',
                       'UCML',
                       'UDMFL',
                       'UDML',
                       'UEMFL',
                       'UEML',
                       'UGMFL',
                       'UGML'
                      );

            --
            IF v_count > 0
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;
         ELSE
            c_applies_value := 'N';
         END IF;

         -- Field 228. Means Tested loans for session
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 228;

         IF c_applies_value = 'Y'
         THEN
            SELECT SUM (amount), SUM (net_amount)
              INTO v_amount, v_net_amount
              FROM award
             WHERE stud_crse_year_id = r1.stud_crse_year_id
               AND stud_ref_no = r1.stud_ref_no
               AND session_code = param_session_code
               AND stud_award_type IN
                      ('UCMFL',
                       'UCML',
                       'UDMFL',
                       'UDML',
                       'UEMFL',
                       'UEML',
                       'UGMFL',
                       'UGML'
                      );

            --
            SELECT SUM (unclaimed_loan)
              INTO v_awi_net_amount
              FROM award_instalment
             WHERE award_id IN (
                      SELECT award_id
                        FROM award
                       WHERE stud_ref_no = r1.stud_ref_no
                         AND stud_crse_year_id = r1.stud_crse_year_id
                         AND session_code = param_session_code
                         AND stud_award_type IN
                                ('UCMFL',
                                 'UCML',
                                 'UDMFL',
                                 'UDML',
                                 'UEMFL',
                                 'UEML',
                                 'UGMFL',
                                 'UGML'
                                ));
         ELSE
            v_amount := 0;
            v_net_amount := 0;
            v_awi_net_amount := 0;
         END IF;

         v_tot_loan_award := v_tot_loan_award + v_amount;
         v_tot_net_award := v_tot_net_award + v_net_amount;
         v_tot_unclaim_award := v_tot_unclaim_award + v_awi_net_amount;
         -- Field 229. Means tested loan entitlement amount
         UTL_FILE.put (hreport, NVL (v_amount, 0) || ',');
         lv_field_number := 229;
         -- Field 230. MT loan net amount awarded.
         UTL_FILE.put (hreport, NVL (v_net_amount, 0) || ',');
         lv_field_number := 230;
         -- Field 231. MT loan unclaimed loan amount.
         UTL_FILE.put (hreport, NVL (v_awi_net_amount, 0) || ',');
         lv_field_number := 231;

         IF NVL (param_scheme_type, 'x') <> 'B'
         THEN
            SELECT COUNT (*)
              INTO v_count
              FROM award
             WHERE stud_crse_year_id = r1.stud_crse_year_id
               AND stud_ref_no = r1.stud_ref_no
               AND session_code = param_session_code
               AND award_src = 'A'
               AND stud_award_type IN
                      ('PTL',
                       'UCHNFL',
                       'UCHNL',
                       'UCNFL',
                       'UCNL',
                       'UDHNFL',
                       'UDHNL',
                       'UDNFL',
                       'UDNL',
                       'UENFL',
                       'UENL',
                       'UGHNFL',
                       'UGHNL',
                       'UGNFL',
                       'UGNL'
                      );

            --
            IF v_count > 0
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;
         ELSE
            c_applies_value := 'N';
         END IF;

         -- Field 232. Non Means Tested loans for session
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 232;

         IF c_applies_value = 'Y'
         THEN
            SELECT SUM (amount), SUM (net_amount)
              INTO v_amount, v_net_amount
              FROM award
             WHERE stud_crse_year_id = r1.stud_crse_year_id
               AND stud_ref_no = r1.stud_ref_no
               AND session_code = param_session_code
               AND stud_award_type IN
                      ('PTL',
                       'UCHNFL',
                       'UCHNL',
                       'UCNFL',
                       'UCNL',
                       'UDHNFL',
                       'UDHNL',
                       'UDNFL',
                       'UDNL',
                       'UENFL',
                       'UENL',
                       'UGHNFL',
                       'UGHNL',
                       'UGNFL',
                       'UGNL'
                      );

            --
            SELECT SUM (unclaimed_loan)
              INTO v_awi_net_amount
              FROM award_instalment
             WHERE award_id IN (
                      SELECT award_id
                        FROM award
                       WHERE stud_ref_no = r1.stud_ref_no
                         AND stud_crse_year_id = r1.stud_crse_year_id
                         AND session_code = param_session_code
                         AND stud_award_type IN
                                ('PTL',
                                 'UCHNFL',
                                 'UCHNL',
                                 'UCNFL',
                                 'UCNL',
                                 'UDHNFL',
                                 'UDHNL',
                                 'UDNFL',
                                 'UDNL',
                                 'UENFL',
                                 'UENL',
                                 'UGHNFL',
                                 'UGHNL',
                                 'UGNFL',
                                 'UGNL'
                                ));
         ELSE
            v_amount := 0;
            v_net_amount := 0;
            v_awi_net_amount := 0;
         END IF;

         v_tot_loan_award := v_tot_loan_award + v_amount;
         v_tot_net_award := v_tot_net_award + v_net_amount;
         v_tot_unclaim_award := v_tot_unclaim_award + v_awi_net_amount;
         -- Field 233. Non Means tested loan entitlement amount
         UTL_FILE.put (hreport, NVL (v_amount, 0) || ',');
         lv_field_number := 233;
         -- Field 234. Non MT loan net amount awarded.
         UTL_FILE.put (hreport, NVL (v_net_amount, 0) || ',');
         lv_field_number := 234;
         -- Field 235. Non MT loan unclaimed loan amount.
         UTL_FILE.put (hreport, NVL (v_awi_net_amount, 0) || ',');
         lv_field_number := 235;

         IF NVL (param_scheme_type, 'x') <> 'B' AND r1.dearing <> 'O'
         THEN
            SELECT COUNT (*)
              INTO v_count
              FROM award
             WHERE stud_crse_year_id = r1.stud_crse_year_id
               AND stud_ref_no = r1.stud_ref_no
               AND session_code = param_session_code
               AND award_src = 'A'
               AND stud_award_type IN ('UDNXL');

            --
            IF v_count > 0
            THEN
               c_applies_value := 'Y';
            ELSE
               c_applies_value := 'N';
            END IF;
         ELSE
            c_applies_value := 'N';
         END IF;

         -- Field 236. Additional Loans for session
         UTL_FILE.put (hreport, c_applies_value || ',');
         lv_field_number := 236;

         IF c_applies_value = 'Y'
         THEN
            SELECT SUM (amount), SUM (net_amount)
              INTO v_amount, v_net_amount
              FROM award
             WHERE stud_crse_year_id = r1.stud_crse_year_id
               AND stud_ref_no = r1.stud_ref_no
               AND session_code = param_session_code
               AND stud_award_type IN ('UDNXL');

            --
            SELECT SUM (unclaimed_loan)
              INTO v_awi_net_amount
              FROM award_instalment
             WHERE award_id IN (
                      SELECT award_id
                        FROM award
                       WHERE stud_ref_no = r1.stud_ref_no
                         AND stud_crse_year_id = r1.stud_crse_year_id
                         AND session_code = param_session_code
                         AND stud_award_type IN ('UDNXL'));
         ELSE
            v_amount := 0;
            v_net_amount := 0;
            v_awi_net_amount := 0;
         END IF;

         v_tot_loan_award := v_tot_loan_award + v_amount;
         v_tot_net_award := v_tot_net_award + v_net_amount;
         v_tot_unclaim_award := v_tot_unclaim_award + v_awi_net_amount;
         -- Field 237. Additional loan entitlement amount
         UTL_FILE.put (hreport, NVL (v_amount, 0) || ',');
         lv_field_number := 237;
         -- Field 238. Additional loan net amount
         UTL_FILE.put (hreport, NVL (v_net_amount, 0) || ',');
         lv_field_number := 238;
         -- Field 239. Additional Loan unclaimed loan amount
         UTL_FILE.put (hreport, NVL (v_awi_net_amount, 0) || ',');
         lv_field_number := 239;
         -- Field 240. Total student loan award entitlement
         UTL_FILE.put (hreport, NVL (v_tot_loan_award, 0) || ',');
         lv_field_number := 240;
         -- Field 241. Total student award - net amount
         UTL_FILE.put (hreport, NVL (v_tot_net_award, 0) || ',');
         lv_field_number := 241;
         -- Field 242. Total student award unclaimed loan amount
         UTL_FILE.put (hreport, NVL (v_tot_unclaim_award, 0) || ',');
         lv_field_number := 242;
         -- Field 243. ISB
         UTL_FILE.put (hreport, ca_187_applies_value || ',');
         lv_field_number := 243;
         -- Field 244. ISB entitlement amount
         UTL_FILE.put (hreport, NVL (va_188_amount, 0) || ',');
         lv_field_number := 244;
         -- Field 245. ISB entitlement net amount
         UTL_FILE.put (hreport, NVL (va_189_net_amount, 0) || ',');
         lv_field_number := 245;
         -- Field 246. ISB actually paid
         UTL_FILE.put (hreport, NVL (va_190_awi_net_amount, 0) || ',');
         lv_field_number := 246;
         --
         UTL_FILE.new_line (hreport);
         n_records := n_records + 1;
      END LOOP;

      UTL_FILE.fclose (hreport);
      number_of_records := 'Number of records processed ' || n_records;
      success_fail := 'Completed Successfully';
      d_finish_date := SYSDATE;
      start_finish :=
            'Started '
         || TO_CHAR (d_start_date, 'dd-MON-yy hh24:mi:ss')
         || ', Finished '
         || TO_CHAR (d_finish_date, 'dd-MON-yy hh24:mi:ss');
   EXCEPTION
      WHEN e_stop_processing
      THEN
         number_of_records := NULL;
      WHEN NO_DATA_FOUND
      THEN
         n_sql_code := SQLCODE;
         v_sql_message := SQLERRM;
         success_fail :=
               'No Data Found:'
            || lv_stud_ref_no
            || 'failed on field'
            || lv_field_number;
         error_msg :=
               'Stud Ref No: ' || v_ref || ',Stud crse Year Id: ' || v_crse_id;
         number_of_records := NULL;
      WHEN OTHERS
      THEN
         n_sql_code := SQLCODE;
         v_sql_message := SQLERRM;
         success_fail :=
               'Fatal Error Detected:'
            || lv_stud_ref_no
            || 'failed on field'
            || lv_field_number;
         error_msg :=
              'Sqlcode = ' || n_sql_code || ' Sql Message = ' || v_sql_message;
         number_of_records := NULL;
   END;

--
--
--
--
--
--
--
   PROCEDURE benefactor_details (
      param_utl_file       IN   UTL_FILE.file_type,
      param_ben_id         IN   benefactor.ben_id%TYPE,
      param_ben_rel_id     IN   stud_session.ben1_rel_id%TYPE,
      param_session_code   IN   stud_session.session_code%TYPE,
      param_scheme_type    IN   VARCHAR2
   )
   IS
      -- Procedure which adds benefactor details to the already open csv file.
      -- Note that benefactor 1 and benefactor 2 details are added by this procedure
      -- which means that each put statement is responsible for two seperate fields in
      -- the file.
      n_number_of_dependants   NUMBER;

      CURSOR c1
      IS
         SELECT bank_interest, benefit, other_income, nat_saving_interest,
                paye_income, pension, self_employment, property, dividend,
                domestic, other_deduct
           --life_ins_deduct
           --loan_int_deduct
           --pension_deduct
           --rap_deduct
         FROM   benefactor_income
          WHERE ben_id = param_ben_id AND session_code = param_session_code;

      r1                       c1%ROWTYPE;
      v_ben_rel_id             stud_session.ben1_rel_id%TYPE;
   BEGIN
      IF NVL (param_scheme_type, 'x') = 'B'
      THEN
         --param_ben_rel_id := 0 ;
         v_ben_rel_id := 0;
         r1.bank_interest := 0;
         r1.benefit := 0;
         r1.other_income := 0;
         r1.nat_saving_interest := 0;
         r1.paye_income := 0;
         r1.pension := 0;
         r1.self_employment := 0;
         r1.property := 0;
         r1.dividend := 0;
         r1.domestic := 0;
         r1.other_deduct := 0;
         --  r1.life_ins_deduct := 0 ;
         --  r1.loan_int_deduct := 0 ;
         --  r1.pension_deduct := 0 ;
         --  r1.rap_deduct := 0 ;
         n_number_of_dependants := 0;
      ELSE
         v_ben_rel_id := param_ben_rel_id;

         --
         OPEN c1;

         FETCH c1
          INTO r1;

         CLOSE c1;

         --
         SELECT COUNT (*)
           INTO n_number_of_dependants
           FROM benefactor_dependant
          WHERE ben_id = param_ben_id AND session_code = param_session_code;
      END IF;

      -- Field 100 or 117. Benefactor relationship
      --UTL_FILE.PUT(param_utl_file,','||NVL(param_ben_rel_id,'0'));
      UTL_FILE.put (param_utl_file, ',' || NVL (v_ben_rel_id, '0'));
      -- Field 101 or 118. Bank Interest
      UTL_FILE.put (param_utl_file,
                    ',' || ROUND (NVL (r1.bank_interest, 0), 0)
                   );
      -- Field 102 or 119. Benefit
      UTL_FILE.put (param_utl_file, ',' || ROUND (NVL (r1.benefit, 0), 0));
      -- Field 103 or 120. Other Income
      UTL_FILE.put (param_utl_file,
                    ',' || ROUND (NVL (r1.other_income, 0), 0));
      -- Field 104 or 121. National Savings Interest
      UTL_FILE.put (param_utl_file,
                    ',' || ROUND (NVL (r1.nat_saving_interest, 0), 0)
                   );
      -- Field 105 or 122. PAYE Income
      UTL_FILE.put (param_utl_file, ',' || ROUND (NVL (r1.paye_income, 0), 0));
      -- Field 106 or 123. Pension
      UTL_FILE.put (param_utl_file, ',' || ROUND (NVL (r1.pension, 0), 0));
      -- Field 107 or 124. Self employment
      UTL_FILE.put (param_utl_file,
                    ',' || ROUND (NVL (r1.self_employment, 0), 0)
                   );
      -- Field 108 or 125. Property
      UTL_FILE.put (param_utl_file, ',' || ROUND (NVL (r1.property, 0), 0));
      -- Field 109 or 126. Dividends
      UTL_FILE.put (param_utl_file, ',' || ROUND (NVL (r1.dividend, 0), 0));
      -- Field 110 or 127. domestic
      UTL_FILE.put (param_utl_file, ',' || ROUND (NVL (r1.domestic, 0), 0));
      -- Field 111 or 128. life insurance deductions
      -- UTL_FILE.PUT(param_utl_file,','||ROUND(NVL(r1.life_ins_deduct,0),0));
      -- Field 112 or 129. benefactor deduction items
      -- UTL_FILE.PUT(param_utl_file,','||ROUND(NVL(r1.loan_int_deduct,0),0));
      -- Field 113 or 130. other deductions
      UTL_FILE.put (param_utl_file,
                    ',' || ROUND (NVL (r1.other_deduct, 0), 0));
      -- Field 114 or 131. pension deductions
      --UTL_FILE.PUT(param_utl_file,','||ROUND(NVL(r1.pension_deduct,0),0));
      -- Field 115 or 132. RAP deductions
      -- UTL_FILE.PUT(param_utl_file,','||ROUND(NVL(r1.rap_deduct,0),0));
      -- Field 116 or 133. The number of dependants for this benefactor for the current session
      UTL_FILE.put (param_utl_file,
                    ',' || ROUND (NVL (n_number_of_dependants, 0), 0)
                   );
   END;
END ed7_download;
/
