CREATE OR REPLACE PACKAGE BODY SGAS.ed8_content
IS
-- DESCRIPTION
-- ===========
-- Package contains the procedures that retrieves all the ED8 data
--
-- Modification History
-- Date               Author       Ref          Desc
-- 30.04.2012       A.Bowman       001    Initial Creation of Package
-- 13.08.2013       P Grace        001    Amendments for 2013 changes
-- 08.08.2014       Clark Bolan    001    CR 222 and defect fixes
-- 02.09.2014       Clark Bolan    001    addition defects 91 and 92
-- 17.07.2015       John Penman    001    fix for defect 268 - column 109
-- 30.01.2019       Mike Tolmie    001    SFD3 Educational Pyschology
-- 05.03.2019       M.Tolmie       001    CR499 Implementation 
-- 12.03.2019       J.Penman       001    Modification for CR514
-- 19.03.2019       M.Tolmie       001    StepsDefects #567
-- 28.03.2019       J.Penman       001    Removed surplus fields. The fields now
--                                        consistent with Mike Tolmie's revised 
--                                        spec (an update of the original functional
--                                        spec,which is now totally out of date. 
-- 13.12.2022      J.Penman        001   Added new variables for Estranged (COS2023) project                          
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision:  $
--
   TYPE t_personal_details IS RECORD (
      dob                        stud.dob%TYPE,
      sex                        stud.sex%TYPE,
      marital_status             stud.marital_status%TYPE,
      comp_jour                  stud.comp_jour%TYPE,
      post_code                  stud_home_addr.post_code%TYPE,
      eu_flag                    stud_session.eu_flag%TYPE,
      ni_no                      stud.ni_no%TYPE,
      withdraw_date              DATE,
      earliest_start_term_date   DATE,
      self_funding               stud_crse_year.self_funding%TYPE,
      residence_country_code     stud.residence_country_code%TYPE,
      birth_country_code         stud.birth_country_code%TYPE,
      nation_country_code        stud.nation_country_code%TYPE
   );

   TYPE t_dsa_details IS RECORD (
      disabled             VARCHAR2 (1),
      descript             disability_type.descript%TYPE,
      max_amount_a         dsa_allowance.max_amount%TYPE,
      paid_amount_a        dsa_allowance.paid_amount%TYPE,
      available_amount_a   dsa_allowance.available_amount%TYPE,
      max_amount_b         dsa_allowance.max_amount%TYPE,
      paid_amount_b        dsa_allowance.paid_amount%TYPE,
      available_amount_b   dsa_allowance.available_amount%TYPE,
      max_amount_c         dsa_allowance.max_amount%TYPE,
      paid_amount_c        dsa_allowance.paid_amount%TYPE,
      available_amount_c   dsa_allowance.available_amount%TYPE,
      max_amount_d         dsa_allowance.max_amount%TYPE,
      paid_amount_d        dsa_allowance.paid_amount%TYPE,
      available_amount_d   dsa_allowance.available_amount%TYPE
   );

   TYPE t_application_details IS RECORD (
      application_status     stud_crse_year.application_status%TYPE,
      date_applic_received   DATE,
      provisional_case       stud_crse_year.provisional_case%TYPE,
      max_loan_requested     stud_session.max_loan_requested%TYPE,
      dearing                stud_crse_year.dearing%TYPE
   );

      TYPE t_course_details IS RECORD (
      inst_code         stud_crse_year.inst_code%TYPE,
      scheme_type       stud_crse_year.scheme_type%TYPE,
      inst_type_id      inst.inst_type_id%TYPE,
      location_ind      inst.location_ind%TYPE,
      crse_code         stud_crse_year.crse_code%TYPE,
      crse_name         stud_crse_year.crse_name%TYPE,
      grad              stud_crse_year.grad_session%TYPE,
      crse_year_no      stud_crse_year.crse_year_no%TYPE,
      qual_type         crse.qual_type%TYPE,
      /*--CR499 M.Tolmie Sep 2018 : Distance Learning Course Flag*/
      dl_course         VARCHAR2 (1),
      pams_course       crse.pams_course%TYPE,
      --Graduate Apprentice Clark Bolan COS 2021--
      ga_student        stud_crse_year.ga_student%TYPE,
      split_session     crse_year.split_session%TYPE,
      crse_type         crse_year.crse_type%TYPE,
      no_terms          NUMBER (2),
      start_date        DATE,
      first_calc_date   DATE,
      pgce_ind          VARCHAR2 (1)
   );

   TYPE t_student_income_details IS RECORD (
      inc_amount_none       stud_income.amount%TYPE,
      inc_amount_benefits   stud_income.amount%TYPE,
      inc_amount_wtc        stud_income.amount%TYPE,
      inc_amount_trust      stud_income.amount%TYPE,
      inc_amount_pension    stud_income.amount%TYPE,
      inc_amount_prop       stud_income.amount%TYPE,
      inc_amount_other      stud_income.amount%TYPE
   );

   TYPE t_ben_income_details IS RECORD (
      ben1_rel_id            stud_session.ben1_rel_id%TYPE,
      bank_interest1         benefactor_income.bank_interest%TYPE,
      benefit1               benefactor_income.benefit%TYPE,
      other_income1          benefactor_income.other_income%TYPE,
      nat_saving_interest1   benefactor_income.nat_saving_interest%TYPE,
      paye_income1           benefactor_income.paye_income%TYPE,
      pension1               benefactor_income.pension%TYPE,
      self_employment1       benefactor_income.self_employment%TYPE,
      property1              benefactor_income.property%TYPE,
      dividend1              benefactor_income.dividend%TYPE,
      domestic1              benefactor_income.domestic%TYPE,
      other_deduct1          benefactor_income.other_deduct%TYPE,
      working_tax_credit1    benefactor_income.working_tax_credit%TYPE,
      reason_no_income1      benefactor_income.reason_no_income%TYPE,
      ben2_rel_id            stud_session.ben2_rel_id%TYPE,
      bank_interest2         benefactor_income.bank_interest%TYPE,
      benefit2               benefactor_income.benefit%TYPE,
      other_income2          benefactor_income.other_income%TYPE,
      nat_saving_interest2   benefactor_income.nat_saving_interest%TYPE,
      paye_income2           benefactor_income.paye_income%TYPE,
      pension2               benefactor_income.pension%TYPE,
      self_employment2       benefactor_income.self_employment%TYPE,
      property2              benefactor_income.property%TYPE,
      dividend2              benefactor_income.dividend%TYPE,
      domestic2              benefactor_income.domestic%TYPE,
      other_deduct2          benefactor_income.other_deduct%TYPE,
      working_tax_credit2    benefactor_income.working_tax_credit%TYPE,
      reason_no_income2      benefactor_income.reason_no_income%TYPE
   );

   TYPE t_bursary_grant_details IS RECORD (
      isb_amount                    NUMBER,
      isb_net_amount                NUMBER,
      isb_awi_net_amount            NUMBER,
      isb_overpayment_amount        NUMBER,
      isb_recovered_amount          NUMBER,
      ysb_amount                    NUMBER,
      ysb_net_amount                NUMBER,
      ysb_awi_net_amount            NUMBER,
      ysb_overpayment_amount        NUMBER,
      ysb_recovered_amount          NUMBER,
      
      /*--CR499 M.Tolmie Sep 2018 : Add CESB flag*/
      cesb_awarded                  VARCHAR2 (1),
      cesb_net_amount               NUMBER,
      cesb_awi_net_amount           NUMBER,
      
      /*-- Estranged COS2023 13/12/2022 John Penman*/
      esb_amount                    NUMBER, 
      esb_net_amount                NUMBER, 
      esb_awi_net_amount            NUMBER, 
      esb_overpayment_amount        NUMBER, 
      esb_recovered_amount          NUMBER, 

      
      
      ugoa_snspa_amount             NUMBER,
      ugoa_snspa_net_amount         NUMBER,
      ugoa_snspa_awi_net_amount     NUMBER,
      ugoa_snspa_opymnt_amount      NUMBER,
      ugoa_snspa_recovered_amount   NUMBER,
      sncap_amount                  NUMBER,
      sncap_net_amount              NUMBER,
      sncap_awi_net_amount          NUMBER,
      sncap_opymnt_amount           NUMBER,
      sncap_recovered_amount        NUMBER,
      snb_amount                    NUMBER,
      snb_net_amount                NUMBER,
      snb_awi_net_amount            NUMBER,
      snb_overpayment_amount        NUMBER,
      snb_recovered_amount          NUMBER,
      dsa_amount                    NUMBER,
      dsa_net_amount                NUMBER,
      dsa_awi_net_amount            NUMBER,
      dsa_overpayment_amount        NUMBER,
      dsa_recovered_amount          NUMBER,
      da_amount                     NUMBER,
      da_net_amount                 NUMBER,
      da_awi_net_amount             NUMBER,
      da_overpayment_amount         NUMBER,
      da_recovered_amount           NUMBER,
      snpe_amount                   NUMBER,
      snpe_net_amount               NUMBER,
      snpe_awi_net_amount           NUMBER,
      snpe_overpayment_amount       NUMBER,
      snpe_recovered_amount         NUMBER,
      snie_amount                   NUMBER,
      snie_net_amount               NUMBER,
      snie_awi_net_amount           NUMBER,
      snie_overpayment_amount       NUMBER,
      snie_recovered_amount         NUMBER,
      adhoc_amount                  NUMBER,
      adhoc_type_f                  NUMBER,
      adhoc_type_a                  NUMBER,
      adhoc_type_o                  NUMBER,
      adhoc_type_e                  NUMBER,
      adhoc_type_r                  NUMBER,
      adhoc_type_t                  NUMBER,
      adhoc_type_p                  NUMBER,
      adhoc_type_v                  NUMBER,
      adhoc_type_l                  NUMBER,
      
      adhoc_type_i                  NUMBER, -- CR514 12/03/2019 John Penman
      adhoc_type_u                  NUMBER, -- CR514 12/03/2019 John Penman
      adhoc_type_n                  NUMBER, -- CR514 12/03/2019 John Penman
      
      adhoc_net_amount              NUMBER,
      adhoc_awi_net_amount          NUMBER,
      adhoc_overpayment_amount      NUMBER,
      adhoc_recovered_amount        NUMBER,
      tot_amount                    NUMBER,
      tot_net_amount                NUMBER,
      tot_awi_net_amount            NUMBER,
      tot_overpayment_amount        NUMBER,
      tot_recovered_amount          NUMBER,
      edpy_grant_amount             NUMBER,
      edpy_grant_net_amount         NUMBER,
      edpy_grant_awi_net_amount     NUMBER,
      edpy_grant_overpayment_amount NUMBER,
      edpy_grant_recovered_amount   NUMBER,
      edpy_fees_amount              NUMBER,
      edpy_fees_net_amount          NUMBER,
      edpy_fees_awi_net_amount      NUMBER,
      edpy_fees_overpayment_amount  NUMBER,
      edpy_fees_recovered_amount    NUMBER,
      edpy_phd_grant_amount             NUMBER,
      edpy_phd_grant_net_amount         NUMBER,
      edpy_phd_grant_awi_net_amount     NUMBER,
      edpy_phd_grant_overpayment_amount NUMBER,
      edpy_phd_grant_recovered_amount   NUMBER,
      edpy_phd_fees_amount              NUMBER,
      edpy_phd_fees_net_amount          NUMBER,
      edpy_phd_fees_awi_net_amount      NUMBER,
      edpy_phd_fees_overpayment_amount  NUMBER,
      edpy_phd_fees_recovered_amount    NUMBER      
      
   );

   TYPE t_loan_details IS RECORD (
      ugl_amount           NUMBER,
      ugl_net_amount       NUMBER,
      ugl_unclaimed_loan   NUMBER
   );

   TYPE t_tuition_fee_details IS RECORD (
      fee_loan_declaration_date   stud_session.fee_loan_declaration_date%TYPE,
      max_fee_loan_requested      stud_session.max_fee_loan_requested%TYPE,
      tuition_fee_type_code       award.tuition_fee_type_code%TYPE,
      tf_amount                   NUMBER,
      tf_net_amount               NUMBER,
      tf_awi_net_amount           NUMBER,
      award_type_descript         award.award_type_descript%TYPE,
      fl_amount                   NUMBER,
      fl_net_amount               NUMBER,
      fl_awi_net_amount           NUMBER,
      max_fee_loan                NUMBER
   );

   TYPE t_study_abroad_details IS RECORD (
      erasmus             stud_crse_year.erasmus%TYPE,
      study_abroad        stud_crse_year.study_abroad%TYPE,
      study_country       stud_crse_year.study_country%TYPE,
      start_date_abroad   stud_crse_year.start_date_abroad%TYPE,
      end_date_abroad     stud_crse_year.end_date_abroad%TYPE
   );

   TYPE t_dependants_details IS RECORD (
      stud_dependants_count   NUMBER (2),
      dep1_age                NUMBER (2),
      dep1_rel_type           sgas.stud_dependant.relation_id%TYPE,
      dep2_age                NUMBER (2),
      dep2_rel_type           sgas.stud_dependant.relation_id%TYPE,
      dep3_age                NUMBER (2),
      dep3_rel_type           sgas.stud_dependant.relation_id%TYPE,
      dep4_age                NUMBER (2),
      dep4_rel_type           sgas.stud_dependant.relation_id%TYPE,
      dep5_age                NUMBER (2),
      dep5_rel_type           sgas.stud_dependant.relation_id%TYPE,
      dep6_age                NUMBER (2),
      dep6_rel_type           sgas.stud_dependant.relation_id%TYPE,
      dep7_age                NUMBER (2),
      dep7_rel_type           sgas.stud_dependant.relation_id%TYPE,
      dep8_age                NUMBER (2),
      dep8_rel_type           sgas.stud_dependant.relation_id%TYPE,
      dep9_age                NUMBER (2),
      dep9_rel_type           sgas.stud_dependant.relation_id%TYPE,
      dep10_age               NUMBER (2),
      dep10_rel_type          sgas.stud_dependant.relation_id%TYPE
   );

   FUNCTION get_personal_details (v_ed8_parameter IN t_ed8_parameter)
      RETURN t_personal_details
   IS
      v_personal_details             t_personal_details;
      v_withdraw_date                DATE;
      v_inst_code                    VARCHAR2 (5);
      v_default_terms                VARCHAR2 (1);
      v_start_term_date              DATE;
      v_earliest_stud_session_id     NUMBER (9);
      v_session_code                 NUMBER (4);
      v_earliest_stud_crse_year_id   NUMBER (9);
      v_earliest_crse_year_id        NUMBER (9);
      v_release_year                 NUMBER (4);

      CURSOR per1 (p_stud_ref_no stud.stud_ref_no%TYPE)
      IS
         SELECT dob, sex, marital_status, comp_jour, ni_no,
                residence_country_code, birth_country_code,
                nation_country_code
           FROM stud
          WHERE stud_ref_no = p_stud_ref_no;

      CURSOR per2 (p_stud_ref_no stud.stud_ref_no%TYPE)
      IS
         SELECT post_code
           FROM stud_home_addr
          WHERE stud_ref_no = p_stud_ref_no AND end_date IS NULL;
   BEGIN
      OPEN per1 (v_ed8_parameter.stud_ref_no);

      FETCH per1
       INTO v_personal_details.dob, v_personal_details.sex,
            v_personal_details.marital_status, v_personal_details.comp_jour,
            v_personal_details.ni_no,
            v_personal_details.residence_country_code,
            v_personal_details.birth_country_code,
            v_personal_details.nation_country_code;

      CLOSE per1;

      -- Find stud_home_addr record for current stud_crse_year record
      OPEN per2 (v_ed8_parameter.stud_ref_no);

      FETCH per2
       INTO v_personal_details.post_code;

      IF per2%NOTFOUND
      THEN
         -- If home address does not exist where end date is null then add
         -- default postcode of XXXX XXX
         v_personal_details.post_code := NULL;
      END IF;

      CLOSE per2;

      SELECT withdraw_date, inst_code,
             self_funding
        INTO v_personal_details.withdraw_date, v_inst_code,
             v_personal_details.self_funding
        FROM stud_crse_year
       WHERE stud_crse_year_id = v_ed8_parameter.stud_crse_year_id;

      -- Get EU Flag
       /*--CR499 M.Tolmie Sept 2018 : Null EU_Flag returned as N*/
        SELECT NVL(eu_flag,'N')
        INTO v_personal_details.eu_flag
        FROM stud_session
       WHERE stud_session_id = v_ed8_parameter.stud_session_id;

      SELECT MIN (student_sessions.earliest_session_code)
        INTO v_session_code
        FROM (SELECT   MIN (ss.session_code) AS earliest_session_code
                  FROM stud_session ss
                 WHERE ss.stud_ref_no = v_ed8_parameter.stud_ref_no
              GROUP BY ss.stud_session_id
              UNION
              SELECT   MIN (ss.session_code) AS earliest_session_code
                  FROM stud_session@grass ss
                 WHERE ss.stud_ref_no = v_ed8_parameter.stud_ref_no
              GROUP BY ss.stud_session_id) student_sessions;

      SELECT nval
        INTO v_release_year
        FROM config_data
       WHERE item_name = 'STEPS_RELEASE_YEAR';

      IF v_session_code >= v_release_year
      THEN
         SELECT ss.stud_session_id
           INTO v_earliest_stud_session_id
           FROM stud_session ss
          WHERE ss.session_code = v_session_code
            AND ss.stud_ref_no = v_ed8_parameter.stud_ref_no;

         SELECT MIN (scy.stud_crse_year_id)
           INTO v_earliest_stud_crse_year_id
           FROM stud_crse_year scy
          WHERE scy.stud_session_id = v_earliest_stud_session_id;

         SELECT scy.crse_year_id
           INTO v_earliest_crse_year_id
           FROM stud_crse_year scy
          WHERE scy.stud_crse_year_id = v_earliest_stud_crse_year_id;
      ELSE
         SELECT gss.stud_session_id
           INTO v_earliest_stud_session_id
           FROM stud_session@grass gss
          WHERE gss.session_code = v_session_code
            AND gss.stud_ref_no = v_ed8_parameter.stud_ref_no;

         SELECT MIN (gscy.stud_crse_year_id)
           INTO v_earliest_stud_crse_year_id
           FROM stud_crse_year@grass gscy
          WHERE gscy.stud_session_id = v_earliest_stud_session_id;

         SELECT gscy.crse_year_id
           INTO v_earliest_crse_year_id
           FROM stud_crse_year@grass gscy
          WHERE gscy.stud_crse_year_id = v_earliest_stud_crse_year_id;
      END IF;

      IF v_earliest_crse_year_id IS NOT NULL
      THEN
         BEGIN
            SELECT cy.default_terms
              INTO v_default_terms
              FROM crse_session cs, crse_year cy
             WHERE cs.crse_session_id = cy.crse_session_id
               AND cy.crse_year_id = v_earliest_crse_year_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_default_terms := NULL;
         END;

         IF NVL (v_default_terms, 'x') = 'N'
         THEN
            SELECT   MIN (start_date)
                INTO v_personal_details.earliest_start_term_date
                FROM crse_term ct
               WHERE ct.crse_year_id = v_earliest_crse_year_id
            GROUP BY crse_year_id;
         ELSE
            SELECT MIN (start_date)
              INTO v_personal_details.earliest_start_term_date
              FROM inst_term
             WHERE inst_code = v_inst_code AND session_code = v_session_code;
         END IF;
      ELSE
         v_personal_details.earliest_start_term_date := NULL;
      END IF;

      RETURN v_personal_details;
   END get_personal_details;

   FUNCTION get_dsa_details (v_ed8_parameter IN t_ed8_parameter)
      RETURN t_dsa_details
   IS
      v_dsa_details   t_dsa_details;

      CURSOR dsa1 (p_stud_ref_no stud.stud_ref_no%TYPE)
      IS
         SELECT 1
           FROM dsa_application
          WHERE stud_ref_no = p_stud_ref_no;

      CURSOR dsa2 (
         p_stud_ref_no        IN   stud.stud_ref_no%TYPE,
         param_session_code   IN   stud_session.session_code%TYPE
      )
      IS
         SELECT dt.descript
           FROM disability_type dt
          WHERE dt.disability_type_id =
                   (SELECT d.disability_type_id
                      FROM dsa_application d, stud s
                     WHERE d.stud_ref_no = s.stud_ref_no
                       AND s.stud_ref_no = p_stud_ref_no
                       AND d.session_code = param_session_code);

      --StEPSDefects #567 : DSA_TYPE_ID 2 = Basic And Small Equipment
      --This type does contain multiple categories and must be summed
      CURSOR dsa3 (p_stud_ref_no stud.stud_ref_no%TYPE)
      IS
         SELECT NVL(SUM(da.max_amount),0), NVL(SUM(da.paid_amount),0), NVL(SUM(da.available_amount),0)
           FROM dsa_allowance da,
                dsa_application d,
                dsa_category dc,
                dsa_type dt
          WHERE da.dsa_application_id = d.ID
            AND d.stud_ref_no = p_stud_ref_no
            AND da.dsa_category_id = dc.dsa_category_id
            AND dc.type_id = dt.dsa_type_id
            AND dt.dsa_type_id = 2;
      
      --StEPSDefects #567 : DSA_TYPE_ID 4 = DSA Travel
      --This type does contain multiple categories and must be summed
      CURSOR dsa4 (p_stud_ref_no stud.stud_ref_no%TYPE)
      IS
         SELECT NVL(SUM(da.max_amount),0), NVL(SUM(da.paid_amount),0), NVL(SUM(da.available_amount),0)
           FROM dsa_allowance da,
                dsa_application d,
                dsa_category dc,
                dsa_type dt
          WHERE da.dsa_application_id = d.ID
            AND d.stud_ref_no = p_stud_ref_no
            AND da.dsa_category_id = dc.dsa_category_id
            AND dc.type_id = dt.dsa_type_id
            AND dt.dsa_type_id = 4;
      
      --StEPSDefects #567 : DSA_TYPE_ID 3 = Non Medical Support
      --This type does contain multiple categories and must be summed
      CURSOR dsa5 (p_stud_ref_no stud.stud_ref_no%TYPE)
      IS
         SELECT NVL(SUM(da.max_amount),0), NVL(SUM(da.paid_amount),0), NVL(SUM(da.available_amount),0)
           FROM dsa_allowance da,
                dsa_application d,
                dsa_category dc,
                dsa_type dt
          WHERE da.dsa_application_id = d.ID
            AND d.stud_ref_no = p_stud_ref_no
            AND da.dsa_category_id = dc.dsa_category_id
            AND dc.type_id = dt.dsa_type_id
            AND dt.dsa_type_id = 3;
      
      --StEPSDefects #567 : DSA_TYPE_ID 1 = Large Equipment
      --This type does contain multiple categories and must be summed
      CURSOR dsa6 (p_stud_ref_no stud.stud_ref_no%TYPE)
      IS
         SELECT NVL(SUM(da.max_amount),0), NVL(SUM(da.paid_amount),0), NVL(SUM(da.available_amount),0)
           FROM dsa_allowance da,
                dsa_application d,
                dsa_category dc,
                dsa_type dt
          WHERE da.dsa_application_id = d.ID
            AND d.stud_ref_no = p_stud_ref_no
            AND da.dsa_category_id = dc.dsa_category_id
            AND dc.type_id = dt.dsa_type_id
            AND dt.dsa_type_id = 1;
   BEGIN
      OPEN dsa1 (v_ed8_parameter.stud_ref_no);

      FETCH dsa1
       INTO v_dsa_details.disabled;

      IF dsa1%FOUND
      THEN
         v_dsa_details.disabled := 'Y';
      ELSE
         v_dsa_details.disabled := NULL;
      END IF;

      CLOSE dsa1;

      OPEN dsa2 (v_ed8_parameter.stud_ref_no, v_ed8_parameter.session_code);

      FETCH dsa2
       INTO v_dsa_details.descript;

      IF dsa2%NOTFOUND
      THEN
         v_dsa_details.descript := NULL;
      END IF;

      CLOSE dsa2;

      OPEN dsa3 (v_ed8_parameter.stud_ref_no);

      FETCH dsa3
       INTO v_dsa_details.max_amount_a, v_dsa_details.paid_amount_a,
            v_dsa_details.available_amount_a;

      IF dsa3%NOTFOUND
      THEN
         v_dsa_details.max_amount_a := 0;
         v_dsa_details.paid_amount_a := 0;
         v_dsa_details.available_amount_a := 0;
      END IF;

      CLOSE dsa3;

      OPEN dsa4 (v_ed8_parameter.stud_ref_no);

      FETCH dsa4
       INTO v_dsa_details.max_amount_b, v_dsa_details.paid_amount_b,
            v_dsa_details.available_amount_b;

      IF dsa4%NOTFOUND
      THEN
         v_dsa_details.max_amount_b := 0;
         v_dsa_details.paid_amount_b := 0;
         v_dsa_details.available_amount_b := 0;
      END IF;

      CLOSE dsa4;

      OPEN dsa5 (v_ed8_parameter.stud_ref_no);

      FETCH dsa5
       INTO v_dsa_details.max_amount_c, v_dsa_details.paid_amount_c,
            v_dsa_details.available_amount_c;

      IF dsa5%NOTFOUND
      THEN
         v_dsa_details.max_amount_c := 0;
         v_dsa_details.paid_amount_c := 0;
         v_dsa_details.available_amount_c := 0;
      END IF;

      CLOSE dsa5;

      OPEN dsa6 (v_ed8_parameter.stud_ref_no);

      FETCH dsa6
       INTO v_dsa_details.max_amount_d, v_dsa_details.paid_amount_d,
            v_dsa_details.available_amount_d;

      IF dsa6%NOTFOUND
      THEN
         v_dsa_details.max_amount_d := 0;
         v_dsa_details.paid_amount_d := 0;
         v_dsa_details.available_amount_d := 0;
      END IF;

      CLOSE dsa6;

      RETURN v_dsa_details;
   END get_dsa_details;

   FUNCTION get_application_details (v_ed8_parameter IN t_ed8_parameter)
      RETURN t_application_details
   IS
      v_application_details   t_application_details;
      v_sum_unclaimed_loan    award_instalment.unclaimed_loan%TYPE;

      CURSOR app1 (p_stud_crse_year_id stud_crse_year.stud_crse_year_id%TYPE)
      IS
         SELECT application_status, provisional_case, dearing
           FROM stud_crse_year
          WHERE stud_crse_year_id = p_stud_crse_year_id;

      CURSOR app2 (p_stud_session_id stud_session.stud_session_id%TYPE)
      IS
         SELECT date_applic_received
           FROM stud_session
          WHERE stud_session_id = p_stud_session_id;
   BEGIN
      OPEN app1 (v_ed8_parameter.stud_crse_year_id);

      FETCH app1
       INTO v_application_details.application_status,
            v_application_details.provisional_case,
            v_application_details.dearing;

      CLOSE app1;

      OPEN app2 (v_ed8_parameter.stud_session_id);

      FETCH app2
       INTO v_application_details.date_applic_received;

      CLOSE app2;

      IF NVL (v_ed8_parameter.scheme_type, 'x') <> 'B'
      THEN
         BEGIN
            SELECT max_loan_requested
              INTO v_application_details.max_loan_requested
              FROM stud_session
             WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
               AND session_code = v_ed8_parameter.session_code;
         END;

         IF    v_application_details.max_loan_requested IS NULL
            OR v_application_details.max_loan_requested = 'N'
         THEN
            SELECT NVL (SUM (awi.unclaimed_loan), 0)
              INTO v_sum_unclaimed_loan
              FROM award_instalment awi, award aw
             WHERE awi.award_id = aw.award_id
               AND stud_award_type IN ('UGLOAN')
               AND aw.stud_crse_year_id = v_ed8_parameter.stud_crse_year_id;

            IF v_sum_unclaimed_loan > 0
            THEN
               v_application_details.max_loan_requested := 'N';
            ELSE
               v_application_details.max_loan_requested := 'Y';
            END IF;
         ELSE
            v_application_details.max_loan_requested := 'Y';
         END IF;
      ELSE
         v_application_details.max_loan_requested := 'N';
      END IF;

      RETURN v_application_details;
   END get_application_details;

   FUNCTION get_course_details (v_ed8_parameter IN t_ed8_parameter)
      RETURN t_course_details
   IS
      v_course_details   t_course_details;
      v_applies_value    VARCHAR2 (4);
      v_crse_id          NUMBER (9);
      v_crse_year_id     NUMBER (9);
      v_psas_pt          VARCHAR2 (1);
      v_nmsb_part_time   VARCHAR2 (1);
      v_pgce             VARCHAR2 (1);
      v_pt               VARCHAR2 (1);
      v_default_terms    VARCHAR2 (1);
      v_default_term_1   VARCHAR2 (1);
      v_applies_value2   VARCHAR2 (4);
   BEGIN
      SELECT inst_code, scheme_type,
             crse_code, crse_name,
             crse_year_no, crse_id, crse_year_id,
             psas_pt, nmsb_part_time, pgce, grad_session, ga_student
        INTO v_course_details.inst_code, v_course_details.scheme_type,
             v_course_details.crse_code, v_course_details.crse_name,
             v_course_details.crse_year_no, v_crse_id, v_crse_year_id,
             v_psas_pt, v_nmsb_part_time, v_pgce, v_course_details.grad , v_course_details.ga_student
        FROM stud_crse_year
       WHERE stud_crse_year_id = v_ed8_parameter.stud_crse_year_id;

      SELECT inst_type_id, location_ind
        INTO v_course_details.inst_type_id, v_course_details.location_ind
        FROM inst
       WHERE inst_code = v_course_details.inst_code;

      IF v_course_details.inst_type_id IS NULL
      THEN
         v_course_details.inst_type_id := 0;
      END IF;

      IF v_course_details.location_ind IS NULL
      THEN
         v_course_details.location_ind := 0;
      END IF;

      IF v_course_details.crse_code IS NULL
      THEN
         v_course_details.crse_code := 0;
      END IF;

      IF v_course_details.crse_year_no IS NULL
      THEN
         v_course_details.crse_year_no := 0;
      END IF;

      IF v_course_details.grad IS NULL
      THEN
         v_course_details.grad := 0;
      END IF;

      IF v_crse_id IS NULL
      THEN
         v_course_details.qual_type := 0;
      ELSE
         SELECT qual_type
           INTO v_course_details.qual_type
           FROM crse
          WHERE crse_id = v_crse_id;
      END IF;

      IF v_course_details.qual_type IS NULL
      THEN
         v_course_details.qual_type := 0;
      END IF;
      
      
      /*--CR499 M.Tolmie Sep 2018 : Add distance learning course flag*/
      IF v_course_details.crse_name LIKE '%(DL)'
      THEN
        v_course_details.dl_course := 'Y';
      ELSE
        v_course_details.dl_course := 'N';
     END IF;
      
      

      IF v_crse_id IS NULL
      THEN
         v_course_details.pams_course := 'N';
      ELSE
         SELECT pams_course
           INTO v_course_details.pams_course
           FROM crse
          WHERE crse_id = v_crse_id;
      END IF;

      IF v_crse_year_id IS NULL
      THEN
         v_course_details.split_session := 'N';
      ELSE
         SELECT split_session
           INTO v_course_details.split_session
           FROM crse_year
          WHERE crse_year_id = v_crse_year_id;
      END IF;

      IF v_psas_pt = 'Y' OR v_nmsb_part_time = 'Y' OR v_nmsb_part_time = 'Y'
      THEN
         v_pt := 'Y';
      ELSE
         v_pt := 'N';
      END IF;

      IF v_crse_year_id IS NULL
      THEN
         v_course_details.crse_type := 0;
      ELSE
         SELECT crse_type
           INTO v_course_details.crse_type
           FROM crse_year
          WHERE crse_year_id = v_crse_year_id;

         IF v_course_details.crse_type IS NULL
         THEN
            v_course_details.crse_type := 0;
         ELSE
            IF v_pt = 'Y'
            THEN
               v_course_details.crse_type := 'P';
            END IF;
         END IF;
      END IF;

      IF NVL (v_ed8_parameter.scheme_type, 'x') <> 'B'
      THEN
         IF v_crse_year_id IS NULL
         THEN
            v_course_details.no_terms := 0;
         ELSE
            BEGIN
               SELECT default_terms
                 INTO v_default_terms
                 FROM crse_year
                WHERE crse_year_id = v_crse_year_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_default_terms := NULL;
            END;

            IF NVL (v_default_terms, 'x') = 'N'
            THEN
               SELECT COUNT (*)
                 INTO v_course_details.no_terms
                 FROM crse_term
                WHERE crse_year_id = v_crse_year_id;
            ELSE
               v_course_details.no_terms := 3;
            END IF;
         END IF;
      ELSE
         v_course_details.no_terms := 4;
      END IF;

      IF v_crse_year_id IS NOT NULL
      THEN
         BEGIN
            SELECT cy.default_terms
              INTO v_default_term_1
              FROM crse_session cs, crse_year cy
             WHERE cs.crse_session_id = cy.crse_session_id
               AND cy.crse_year_id = v_crse_year_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_default_term_1 := NULL;
         END;

         IF NVL (v_default_term_1, 'x') = 'N'
         THEN
            SELECT   MIN (start_date)
                INTO v_course_details.start_date
                FROM crse_term ct
               WHERE ct.crse_year_id = v_crse_year_id
            GROUP BY crse_year_id;
         ELSE
            SELECT MIN (start_date)
              INTO v_course_details.start_date
              FROM inst_term
             WHERE inst_code = v_course_details.inst_code
               AND session_code = v_ed8_parameter.session_code;
         END IF;
      ELSE
         v_course_details.start_date := NULL;
      END IF;

      v_course_details.start_date :=
                TO_DATE (TO_CHAR (v_course_details.start_date, 'DD-MON-YYYY'));

      BEGIN
         SELECT first_calc_date
           INTO v_course_details.first_calc_date
           FROM stud_crse_year
          WHERE stud_crse_year_id = v_ed8_parameter.stud_crse_year_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_course_details.first_calc_date := NULL;
      END;

      IF v_course_details.first_calc_date IS NOT NULL
      THEN
         v_course_details.first_calc_date :=
                    TO_CHAR (v_course_details.first_calc_date, 'DD-MON-YYYY');
      END IF;

      IF v_course_details.qual_type = 'PGCE' OR NVL (v_pgce, 'N') = 'Y'
      THEN
         IF v_course_details.location_ind <> 1
         THEN
            v_course_details.pgce_ind := 'O';
         ELSIF v_course_details.crse_code = '0015'
         THEN
            v_course_details.pgce_ind := 'P';
         ELSIF v_course_details.crse_code = '0025'
         THEN
            v_course_details.pgce_ind := 'S';
         ELSE
            v_course_details.pgce_ind := 'Y';
         END IF;
      ELSE
         v_course_details.pgce_ind := 'N';
      END IF;

      RETURN v_course_details;
   END get_course_details;

   FUNCTION get_student_income_details (v_ed8_parameter IN t_ed8_parameter)
      RETURN t_student_income_details
   IS
      v_student_income_details   t_student_income_details;
      v_stud_income_count        NUMBER;

      CURSOR c_stud_inc (
         cp_stud_session_id   IN   stud_session.stud_session_id%TYPE
      )
      IS
         SELECT   si.income_type AS inc_type, si.amount AS inc_amount
             FROM stud_income si
            WHERE si.stud_session_id = cp_stud_session_id
         ORDER BY si.income_type;
   BEGIN
      v_student_income_details.inc_amount_none := NULL;
      v_student_income_details.inc_amount_benefits := NULL;
      v_student_income_details.inc_amount_wtc := NULL;
      v_student_income_details.inc_amount_trust := NULL;
      v_student_income_details.inc_amount_pension := NULL;
      v_student_income_details.inc_amount_prop := NULL;
      v_student_income_details.inc_amount_other := NULL;

      SELECT   COUNT (*)
          INTO v_stud_income_count
          FROM stud_income si
         WHERE si.stud_session_id = v_ed8_parameter.stud_session_id
      ORDER BY si.income_type;

      IF v_stud_income_count <> 0
      THEN
         FOR v_stud_inc IN c_stud_inc (v_ed8_parameter.stud_session_id)
         LOOP
            IF v_stud_inc.inc_type = 0
            THEN
               v_student_income_details.inc_amount_none :=
                                                        v_stud_inc.inc_amount;
            END IF;

            IF v_stud_inc.inc_type = 1
            THEN
               v_student_income_details.inc_amount_benefits :=
                                                        v_stud_inc.inc_amount;
            END IF;

            IF v_stud_inc.inc_type = 2
            THEN
               v_student_income_details.inc_amount_wtc :=
                                                        v_stud_inc.inc_amount;
            END IF;

            IF v_stud_inc.inc_type = 3
            THEN
               v_student_income_details.inc_amount_trust :=
                                                        v_stud_inc.inc_amount;
            END IF;

            IF v_stud_inc.inc_type = 4
            THEN
               v_student_income_details.inc_amount_pension :=
                                                        v_stud_inc.inc_amount;
            END IF;

            IF v_stud_inc.inc_type = 5
            THEN
               v_student_income_details.inc_amount_prop :=
                                                        v_stud_inc.inc_amount;
            END IF;

            IF v_stud_inc.inc_type = 6
            THEN
               v_student_income_details.inc_amount_other :=
                                                        v_stud_inc.inc_amount;
            END IF;
         END LOOP;
      END IF;

      RETURN v_student_income_details;
   END get_student_income_details;

   FUNCTION get_ben_income_details (v_ed8_parameter IN t_ed8_parameter)
      RETURN t_ben_income_details
   IS
      v_ben_income_details   t_ben_income_details;
      v_ben1_id              stud_session.ben1_id%TYPE;
      v_ben2_id              stud_session.ben2_id%TYPE;
   BEGIN
      IF NVL (v_ed8_parameter.scheme_type, 'x') <> 'B'
      THEN
         SELECT ben1_id, ben1_rel_id, ben2_id,
                ben2_rel_id
           INTO v_ben1_id, v_ben_income_details.ben1_rel_id, v_ben2_id,
                v_ben_income_details.ben2_rel_id
           FROM stud_session
          WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code;

         IF v_ben1_id IS NULL
         THEN
            v_ben_income_details.ben1_rel_id := 0;
            v_ben_income_details.bank_interest1 := 0;
            v_ben_income_details.benefit1 := 0;
            v_ben_income_details.other_income1 := 0;
            v_ben_income_details.nat_saving_interest1 := 0;
            v_ben_income_details.paye_income1 := 0;
            v_ben_income_details.pension1 := 0;
            v_ben_income_details.self_employment1 := 0;
            v_ben_income_details.property1 := 0;
            v_ben_income_details.dividend1 := 0;
            v_ben_income_details.domestic1 := 0;
            v_ben_income_details.other_deduct1 := 0;
            v_ben_income_details.working_tax_credit1 := 0;
            v_ben_income_details.reason_no_income1 := NULL;
         ELSE
            BEGIN
               SELECT NVL (bank_interest, 0),
                      NVL (benefit, 0),
                      NVL (other_income, 0),
                      NVL (nat_saving_interest, 0),
                      NVL (paye_income, 0),
                      NVL (pension, 0),
                      NVL (self_employment, 0),
                      NVL (property, 0),
                      NVL (dividend, 0),
                      NVL (domestic, 0),
                      NVL (other_deduct, 0),
                      NVL (working_tax_credit, 0),
                      reason_no_income
                 INTO v_ben_income_details.bank_interest1,
                      v_ben_income_details.benefit1,
                      v_ben_income_details.other_income1,
                      v_ben_income_details.nat_saving_interest1,
                      v_ben_income_details.paye_income1,
                      v_ben_income_details.pension1,
                      v_ben_income_details.self_employment1,
                      v_ben_income_details.property1,
                      v_ben_income_details.dividend1,
                      v_ben_income_details.domestic1,
                      v_ben_income_details.other_deduct1,
                      v_ben_income_details.working_tax_credit1,
                      v_ben_income_details.reason_no_income1
                 FROM benefactor_income
                WHERE ben_id = v_ben1_id
                  AND session_code = v_ed8_parameter.session_code;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_ben1_id := 0;
                  v_ben_income_details.ben1_rel_id := 0;
                  v_ben2_id := 0;
                  v_ben_income_details.ben2_rel_id := 0;
                  v_ben_income_details.bank_interest1 := 0;
                  v_ben_income_details.benefit1 := 0;
                  v_ben_income_details.other_income1 := 0;
                  v_ben_income_details.nat_saving_interest1 := 0;
                  v_ben_income_details.paye_income1 := 0;
                  v_ben_income_details.pension1 := 0;
                  v_ben_income_details.self_employment1 := 0;
                  v_ben_income_details.property1 := 0;
                  v_ben_income_details.dividend1 := 0;
                  v_ben_income_details.domestic1 := 0;
                  v_ben_income_details.other_deduct1 := 0;
                  v_ben_income_details.working_tax_credit1 := 0;
                  v_ben_income_details.reason_no_income1 := NULL;
            END;
         END IF;

         IF v_ben2_id IS NULL
         THEN
            v_ben_income_details.ben2_rel_id := 0;
            v_ben_income_details.bank_interest2 := 0;
            v_ben_income_details.benefit2 := 0;
            v_ben_income_details.other_income2 := 0;
            v_ben_income_details.nat_saving_interest2 := 0;
            v_ben_income_details.paye_income2 := 0;
            v_ben_income_details.pension2 := 0;
            v_ben_income_details.self_employment2 := 0;
            v_ben_income_details.property2 := 0;
            v_ben_income_details.dividend2 := 0;
            v_ben_income_details.domestic2 := 0;
            v_ben_income_details.other_deduct2 := 0;
            v_ben_income_details.working_tax_credit2 := 0;
            v_ben_income_details.reason_no_income2 := NULL;
         ELSE
            BEGIN
               SELECT NVL (bank_interest, 0),
                      NVL (benefit, 0),
                      NVL (other_income, 0),
                      NVL (nat_saving_interest, 0),
                      NVL (paye_income, 0),
                      NVL (pension, 0),
                      NVL (self_employment, 0),
                      NVL (property, 0),
                      NVL (dividend, 0),
                      NVL (domestic, 0),
                      NVL (other_deduct, 0),
                      NVL (working_tax_credit, 0),
                      reason_no_income
                 INTO v_ben_income_details.bank_interest2,
                      v_ben_income_details.benefit2,
                      v_ben_income_details.other_income2,
                      v_ben_income_details.nat_saving_interest2,
                      v_ben_income_details.paye_income2,
                      v_ben_income_details.pension2,
                      v_ben_income_details.self_employment2,
                      v_ben_income_details.property2,
                      v_ben_income_details.dividend2,
                      v_ben_income_details.domestic2,
                      v_ben_income_details.other_deduct2,
                      v_ben_income_details.working_tax_credit2,
                      v_ben_income_details.reason_no_income2
                 FROM benefactor_income
                WHERE ben_id = v_ben2_id
                  AND session_code = v_ed8_parameter.session_code;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_ben_income_details.bank_interest2 := 0;
                  v_ben_income_details.benefit2 := 0;
                  v_ben_income_details.other_income2 := 0;
                  v_ben_income_details.nat_saving_interest2 := 0;
                  v_ben_income_details.paye_income2 := 0;
                  v_ben_income_details.pension2 := 0;
                  v_ben_income_details.self_employment2 := 0;
                  v_ben_income_details.property2 := 0;
                  v_ben_income_details.dividend2 := 0;
                  v_ben_income_details.domestic2 := 0;
                  v_ben_income_details.other_deduct2 := 0;
                  v_ben_income_details.working_tax_credit2 := 0;
                  v_ben_income_details.reason_no_income2 := NULL;
            END;
         END IF;
      ELSE
         v_ben1_id := 0;
         v_ben_income_details.ben1_rel_id := 0;
         v_ben2_id := 0;
         v_ben_income_details.ben2_rel_id := 0;
         v_ben_income_details.bank_interest1 := 0;
         v_ben_income_details.benefit1 := 0;
         v_ben_income_details.other_income1 := 0;
         v_ben_income_details.nat_saving_interest1 := 0;
         v_ben_income_details.paye_income1 := 0;
         v_ben_income_details.pension1 := 0;
         v_ben_income_details.self_employment1 := 0;
         v_ben_income_details.property1 := 0;
         v_ben_income_details.dividend1 := 0;
         v_ben_income_details.domestic1 := 0;
         v_ben_income_details.other_deduct1 := 0;
         v_ben_income_details.working_tax_credit1 := 0;
         v_ben_income_details.bank_interest2 := 0;
         v_ben_income_details.benefit2 := 0;
         v_ben_income_details.other_income2 := 0;
         v_ben_income_details.nat_saving_interest2 := 0;
         v_ben_income_details.paye_income2 := 0;
         v_ben_income_details.pension2 := 0;
         v_ben_income_details.self_employment2 := 0;
         v_ben_income_details.property2 := 0;
         v_ben_income_details.dividend2 := 0;
         v_ben_income_details.domestic2 := 0;
         v_ben_income_details.other_deduct2 := 0;
         v_ben_income_details.working_tax_credit2 := 0;
         v_ben_income_details.reason_no_income1 := 0;
         v_ben_income_details.reason_no_income2 := 0 ;
      END IF;

      RETURN v_ben_income_details;
   END get_ben_income_details;

   FUNCTION get_bursary_grant_details (v_ed8_parameter IN t_ed8_parameter)
      RETURN t_bursary_grant_details
   IS
      v_bursary_grant_details   t_bursary_grant_details;
      v_isb_applies             VARCHAR2 (1);
      v_ysb_applies             VARCHAR2 (1);
      /*--CR499 M.Tolmie Sep 2018 : CESB*/
      v_cesb_applies            VARCHAR2 (1);
      v_ugoa_snspa_applies      VARCHAR2 (1);
      v_sncap_applies           VARCHAR2 (1);
      v_eu_flag                 VARCHAR2 (1);
      v_crse_year_id            stud_crse_year.crse_year_id%TYPE;
      v_dearing                 stud_crse_year.dearing%TYPE;
      v_inst_code               stud_crse_year.inst_code%TYPE;
      v_crse_code               stud_crse_year.crse_code%TYPE;
      v_application_status      stud_crse_year.application_status%TYPE;
      v_award                   stud_crse_year.award%TYPE;
      v_dummy                   VARCHAR2 (1);
      v_snb_applies             VARCHAR2 (1);
      v_dsa                     VARCHAR2 (1);
      v_dsa_applies             VARCHAR2 (1);
      v_da                      VARCHAR2 (1);
      v_da_applies              VARCHAR2 (1);
      v_snie_applies            VARCHAR2 (1);
      v_snpe_applies            VARCHAR2 (1);
      v_adhoc_applies           VARCHAR2 (1);
      v_adhoc_type_count        NUMBER;
      v_edpy_grant_applies      VARCHAR2 (1);
      v_edpy_fees_applies       VARCHAR2 (1);
      v_esb_applies             VARCHAR2 (1); -- Estrangement COS 2023 Project John Penman 13/12/2022       
      v_edpy_phd_grant_applies  VARCHAR2 (1);
      v_edpy_phd_fees_applies   VARCHAR2 (1);

      CURSOR isb (p_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = p_stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'A'
            AND stud_award_type = 'ISB';

      CURSOR ysb (p_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = p_stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'A'
            AND stud_award_type = 'YSB';
     
      /*--CR499 M.Tolmie Sep 2018 : CESB */     
      CURSOR cesb (p_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'Y'
           FROM award
          WHERE stud_ref_no = p_stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND stud_award_type = 'CESB';

      /*--Estrangement COS 2023 John Penman 13/12/2022 ESB--*/
      CURSOR esb (p_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = p_stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'A'
            AND stud_award_type = 'ESB';

        
      CURSOR ugoa (p_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = p_stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'A'
            AND stud_award_type = 'UGOA';

      CURSOR snspa (p_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = p_stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'A'
            AND stud_award_type = 'SNSPA';

      CURSOR sncap (p_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = p_stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'A'
            AND stud_award_type = 'SNCAP';

      CURSOR snb (p_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = p_stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'A'
            AND stud_award_type IN ('SNB');

      CURSOR dsa (p_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award, award_instalment aw
          WHERE award.stud_ref_no = p_stud_ref_no
            AND award.session_code = v_ed8_parameter.session_code
            AND award.award_src = 'A'
            AND award.award_id = aw.award_id
            AND NVL (aw.dsa_fee_instalment, 'N') = 'N'
            AND award.stud_award_type IN ('PSDSA', 'UGDSA')
            AND NVL (aw.payment_status, 'X') <> 'R'
            AND aw.recalc <> 'Y'
            AND aw.returned <> 'Y';

      CURSOR dsa1 (p_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award, award_instalment aw
          WHERE award.stud_ref_no = p_stud_ref_no
            AND award.session_code = v_ed8_parameter.session_code
            AND award.award_src = 'A'
            AND award.award_id = aw.award_id
            AND NVL (aw.dsa_fee_instalment, 'N') = 'N'
            AND award.stud_award_type IN ('SNBDSA')
            AND NVL (aw.payment_status, 'X') <> 'R'
            AND aw.recalc <> 'Y'
            AND aw.returned <> 'Y';

      CURSOR da (p_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = p_stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'A'
            AND stud_award_type IN ('UGDA');

      CURSOR da1 (p_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = p_stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'A'
            AND stud_award_type IN ('SNDA');

      CURSOR snie (p_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = p_stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'A'
            AND stud_award_type IN ('SNIE');

      CURSOR snpe (p_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = p_stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'A'
            AND stud_award_type IN ('SNPE');

      CURSOR adhoc (p_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_ref_no = p_stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'A'
            AND stud_award_type = 'ADHOC';

      CURSOR c_adhoc_type (p_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT   ai.adhoc_type AS adhoc_type,
                  NVL (SUM (net_amount), 0) AS adhoc_type_total
             FROM award_instalment ai
            WHERE ai.award_id IN (
                     SELECT award_id
                       FROM award
                      WHERE stud_ref_no = p_stud_ref_no
                        AND session_code = v_ed8_parameter.session_code
                        AND stud_award_type = 'ADHOC'
                        AND payment_status = 'S'
                        AND returned = 'N'
                        AND batch_ref IS NOT NULL)
         GROUP BY ai.adhoc_type;
         
         
    --EDUCATIONAL PSYCHOLOGY LIVING COSTS GRANT (MSc)
    CURSOR edpy_grant (p_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
    IS
    SELECT 'x'
    FROM award
    WHERE stud_ref_no = p_stud_ref_no
    AND session_code = v_ed8_parameter.session_code
    AND award_src = 'A'
    AND stud_award_type = 'PGEDG';    
    
    --EDUCATIONAL PSYCHOLOGY MSC FEES GRANT (MSc)
    CURSOR edpy_fees (p_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
    IS
    SELECT 'x'
    FROM award
    WHERE stud_ref_no = p_stud_ref_no
    AND session_code = v_ed8_parameter.session_code
    AND award_src = 'T'
    AND stud_award_type = 'PGEDF';     

    --PHD EDUCATIONAL PSYCHOLOGY LIVING COSTS GRANT (PhD)
    CURSOR edpy_phd_grant (p_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
    IS
    SELECT 'x'
    FROM award
    WHERE stud_ref_no = p_stud_ref_no
    AND session_code = v_ed8_parameter.session_code
    AND award_src = 'A'
    AND stud_award_type = 'PGEDGP';    
    
    --PHD EDUCATIONAL PSYCHOLOGY FEES GRANT (PhD)
    CURSOR edpy_phd_fees (p_stud_ref_no IN stud_crse_year.stud_ref_no%TYPE)
    IS
    SELECT 'x'
    FROM award
    WHERE stud_ref_no = p_stud_ref_no
    AND session_code = v_ed8_parameter.session_code
    AND award_src = 'T'
    AND stud_award_type = 'PGEDFP';    
         
   BEGIN
      --Check if ISB applies to student
      IF NVL (v_ed8_parameter.scheme_type, 'x') <> 'B'
      THEN
         OPEN isb (v_ed8_parameter.stud_ref_no);

         FETCH isb
          INTO v_isb_applies;

         IF isb%FOUND
         THEN
            v_isb_applies := 'Y';
         ELSE
            v_isb_applies := 'N';
         END IF;

         CLOSE isb;
      ELSE
         v_isb_applies := 'N';
      END IF;

      IF v_isb_applies = 'Y'
      THEN
         SELECT NVL (SUM (amount), 0),
                NVL (SUM (net_amount), 0),
                NVL (SUM (overpayment_amount), 0)
           INTO v_bursary_grant_details.isb_amount,
                v_bursary_grant_details.isb_net_amount,
                v_bursary_grant_details.isb_overpayment_amount
           FROM award
          WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND stud_award_type = 'ISB';

         SELECT NVL (SUM (net_amount), 0),
                NVL (SUM (recovered_amount), 0)
           INTO v_bursary_grant_details.isb_awi_net_amount,
                v_bursary_grant_details.isb_recovered_amount
           FROM award_instalment
          WHERE award_id IN (
                   SELECT award_id
                     FROM award
                    WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
                      AND session_code = v_ed8_parameter.session_code
                      AND stud_award_type = 'ISB'
                      AND payment_status = 'S'
                      AND returned = 'N'
                      AND batch_ref IS NOT NULL);
      ELSE
         v_bursary_grant_details.isb_amount := 0;
         v_bursary_grant_details.isb_net_amount := 0;
         v_bursary_grant_details.isb_awi_net_amount := 0;
         v_bursary_grant_details.isb_overpayment_amount := 0;
         v_bursary_grant_details.isb_recovered_amount := 0;
      END IF;

     /*-- New code for ESB - Estrangement COS 2023 Project 13/12/2023  John Penman --*/
     
     
      --Check if ESB applies to student
      IF NVL (v_ed8_parameter.scheme_type, 'x') <> 'B'
      THEN
         OPEN esb (v_ed8_parameter.stud_ref_no);

         FETCH esb
          INTO v_esb_applies;

         IF esb%FOUND
         THEN
            v_esb_applies := 'Y';
         ELSE
            v_esb_applies := 'N';
         END IF;

         CLOSE esb;
      ELSE
         v_esb_applies := 'N';
      END IF;

      IF v_esb_applies = 'Y'
      THEN
         SELECT NVL (SUM (amount), 0),
                NVL (SUM (net_amount), 0),
                NVL (SUM (overpayment_amount), 0)
           INTO v_bursary_grant_details.esb_amount,
                v_bursary_grant_details.esb_net_amount,
                v_bursary_grant_details.esb_overpayment_amount
           FROM award
          WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND stud_award_type = 'ESB';

         SELECT NVL (SUM (net_amount), 0),
                NVL (SUM (recovered_amount), 0)
           INTO v_bursary_grant_details.esb_awi_net_amount,
                v_bursary_grant_details.esb_recovered_amount
           FROM award_instalment
          WHERE award_id IN (
                   SELECT award_id
                     FROM award
                    WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
                      AND session_code = v_ed8_parameter.session_code
                      AND stud_award_type = 'ESB'
                      AND payment_status = 'S'
                      AND returned = 'N'
                      AND batch_ref IS NOT NULL);
      ELSE
         v_bursary_grant_details.esb_amount := 0;
         v_bursary_grant_details.esb_net_amount := 0;
         v_bursary_grant_details.esb_awi_net_amount := 0;
         v_bursary_grant_details.esb_overpayment_amount := 0;
         v_bursary_grant_details.esb_recovered_amount := 0;
      END IF;
     
     /*-- End of new code for ESB Estrangement COS 2023 --*/



      --Check if YSB applies to student
      IF NVL (v_ed8_parameter.scheme_type, 'x') <> 'B'
      THEN
         OPEN ysb (v_ed8_parameter.stud_ref_no);

         FETCH ysb
          INTO v_ysb_applies;

         IF ysb%FOUND
         THEN
            v_ysb_applies := 'Y';
         ELSE
            v_ysb_applies := 'N';
         END IF;

         CLOSE ysb;
      ELSE
         v_ysb_applies := 'N';
      END IF;

      IF v_ysb_applies = 'Y'
      THEN
         SELECT NVL (SUM (amount), 0),
                NVL (SUM (net_amount), 0),
                NVL (SUM (overpayment_amount), 0)
           INTO v_bursary_grant_details.ysb_amount,
                v_bursary_grant_details.ysb_net_amount,
                v_bursary_grant_details.ysb_overpayment_amount
           FROM award
          WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND stud_award_type = 'YSB';

         SELECT NVL (SUM (net_amount), 0),
                NVL (SUM (recovered_amount), 0)
           INTO v_bursary_grant_details.ysb_awi_net_amount,
                v_bursary_grant_details.ysb_recovered_amount
           FROM award_instalment
          WHERE award_id IN (
                   SELECT award_id
                     FROM award
                    WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
                      AND session_code = v_ed8_parameter.session_code
                      AND stud_award_type = 'YSB'
                      AND payment_status = 'S'
                      AND returned = 'N'
                      AND batch_ref IS NOT NULL);
      ELSE
         v_bursary_grant_details.ysb_amount := 0;
         v_bursary_grant_details.ysb_net_amount := 0;
         v_bursary_grant_details.ysb_awi_net_amount := 0;
         v_bursary_grant_details.ysb_overpayment_amount := 0;
         v_bursary_grant_details.ysb_recovered_amount := 0;
      END IF;


      /*--CR499 M.Tolmie Sep 2018 : CESB Flag*/
        OPEN cesb (v_ed8_parameter.stud_ref_no);
        FETCH cesb into v_cesb_applies;
        v_bursary_grant_details.cesb_awarded := NVL(v_cesb_applies,'N'); 
        CLOSE cesb;
      
      IF v_cesb_applies = 'Y'
      THEN
         SELECT NVL (SUM (net_amount), 0)
           INTO v_bursary_grant_details.cesb_net_amount
           FROM award
          WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND stud_award_type IN ('CESB');
         SELECT NVL (SUM (net_amount), 0)
           INTO v_bursary_grant_details.cesb_awi_net_amount
           FROM award_instalment
          WHERE award_id IN (
                   SELECT award_id
                     FROM award
                    WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
                      AND session_code = v_ed8_parameter.session_code
                      AND stud_award_type IN ('CESB')
                      AND payment_status = 'S'
                      AND returned = 'N'
                      AND batch_ref IS NOT NULL);
      ELSE
         v_bursary_grant_details.cesb_net_amount := 0;
         v_bursary_grant_details.cesb_awi_net_amount := 0;
      END IF;
      

      --Check if UGOA or SNSPA applies to student
      IF NVL (v_ed8_parameter.scheme_type, 'x') <> 'B'
      THEN
         OPEN ugoa (v_ed8_parameter.stud_ref_no);

         FETCH ugoa
          INTO v_ugoa_snspa_applies;

         IF ugoa%FOUND
         THEN
            v_ugoa_snspa_applies := 'Y';
         ELSE
            v_ugoa_snspa_applies := 'N';
         END IF;

         CLOSE ugoa;
      ELSIF NVL (v_ed8_parameter.scheme_type, 'x') = 'B'
      THEN
         OPEN snspa (v_ed8_parameter.stud_ref_no);

         FETCH snspa
          INTO v_ugoa_snspa_applies;

         IF snspa%FOUND
         THEN
            v_ugoa_snspa_applies := 'Y';
         ELSE
            v_ugoa_snspa_applies := 'N';
         END IF;

         CLOSE snspa;
      ELSE
         v_ugoa_snspa_applies := 'N';
      END IF;

      IF v_ugoa_snspa_applies = 'Y'
      THEN
         SELECT NVL (SUM (amount), 0),
                NVL (SUM (net_amount), 0),
                NVL (SUM (overpayment_amount), 0)
           INTO v_bursary_grant_details.ugoa_snspa_amount,
                v_bursary_grant_details.ugoa_snspa_net_amount,
                v_bursary_grant_details.ugoa_snspa_opymnt_amount
           FROM award
          WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND stud_award_type IN ('UGOA', 'SNSPA');

         SELECT NVL (SUM (net_amount), 0),
                NVL (SUM (recovered_amount), 0)
           INTO v_bursary_grant_details.ugoa_snspa_awi_net_amount,
                v_bursary_grant_details.ugoa_snspa_recovered_amount
           FROM award_instalment
          WHERE award_id IN (
                   SELECT award_id
                     FROM award
                    WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
                      AND session_code = v_ed8_parameter.session_code
                      AND stud_award_type IN ('UGOA', 'SNSPA')
                      AND payment_status = 'S'
                      AND returned = 'N'
                      AND batch_ref IS NOT NULL);
      ELSE
         v_bursary_grant_details.ugoa_snspa_amount := 0;
         v_bursary_grant_details.ugoa_snspa_net_amount := 0;
         v_bursary_grant_details.ugoa_snspa_awi_net_amount := 0;
         v_bursary_grant_details.ugoa_snspa_opymnt_amount := 0;
         v_bursary_grant_details.ugoa_snspa_recovered_amount := 0;
      END IF;

      --Check if SNCAP applies to student
      IF NVL (v_ed8_parameter.scheme_type, 'x') = 'B'
      THEN
         OPEN sncap (v_ed8_parameter.stud_ref_no);

         FETCH sncap
          INTO v_sncap_applies;

         IF sncap%FOUND
         THEN
            v_sncap_applies := 'Y';
         ELSE
            v_sncap_applies := 'N';
         END IF;

         CLOSE sncap;
      ELSE
         v_sncap_applies := 'N';
      END IF;

      IF v_sncap_applies = 'Y'
      THEN
         SELECT NVL (SUM (amount), 0),
                NVL (SUM (net_amount), 0),
                NVL (SUM (overpayment_amount), 0)
           INTO v_bursary_grant_details.sncap_amount,
                v_bursary_grant_details.sncap_net_amount,
                v_bursary_grant_details.sncap_opymnt_amount
           FROM award
          WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND stud_award_type IN ('SNCAP');

         SELECT NVL (SUM (net_amount), 0),
                NVL (SUM (recovered_amount), 0)
           INTO v_bursary_grant_details.sncap_awi_net_amount,
                v_bursary_grant_details.sncap_recovered_amount
           FROM award_instalment
          WHERE award_id IN (
                   SELECT award_id
                     FROM award
                    WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
                      AND session_code = v_ed8_parameter.session_code
                      AND stud_award_type IN ('SNCAP')
                      AND payment_status = 'S'
                      AND returned = 'N'
                      AND batch_ref IS NOT NULL);
      ELSE
         v_bursary_grant_details.sncap_amount := 0;
         v_bursary_grant_details.sncap_net_amount := 0;
         v_bursary_grant_details.sncap_awi_net_amount := 0;
         v_bursary_grant_details.sncap_opymnt_amount := 0;
         v_bursary_grant_details.sncap_recovered_amount := 0;
      END IF;
      
    --********SNB APPLIES SET award.SNB_AMOUNT(107),award.SNB_net_amount(108), award_instalment.SNB_AWI_NET_AMOUNT(109)
    --********award.SNB_OVERPAYMENT(110), award.SNB_RECOVERED_AMOUNT(111)
    --********Clark Bolan 31/07/2014 CR222 defect fix 
      IF NVL (v_ed8_parameter.scheme_type, 'x') = 'B'
      THEN
         OPEN snb (v_ed8_parameter.stud_ref_no);

         FETCH snb
          INTO v_dummy;

         IF snb%FOUND
         THEN
            v_snb_applies := 'Y';
           -- ELSIF v_application_status IN ('C', 'W') AND v_award != 'A'  ---COMMENTED OUT CR222 defect
           --THEN
           -- v_snb_applies := 'Y';
         ELSE
            v_snb_applies := 'N';
         END IF;
         
         CLOSE snb;
         
         IF v_snb_applies = 'Y'
         THEN
            SELECT NVL (SUM (a.amount),0), NVL(SUM(a.net_amount),0), NVL(SUM(A.OVERPAYMENT_AMOUNT), 0)
            INTO v_bursary_grant_details.snb_amount, v_bursary_grant_details.snb_net_amount, v_bursary_grant_details.snb_overpayment_amount
            FROM AWARD a
            WHERE a.stud_ref_no = v_ed8_parameter.stud_ref_no
            AND a.session_code = v_ed8_parameter.session_code
            AND A.STUD_AWARD_TYPE = 'SNB';
            
            SELECT NVL (SUM (ai.amount), 0),
                NVL (SUM (ai.recovered_amount), 0)
            INTO v_bursary_grant_details.snb_awi_net_amount, v_bursary_grant_details.snb_recovered_amount
            FROM award_instalment ai, award a
            WHERE ai.award_id = a.award_id
            AND a.stud_ref_no = v_ed8_parameter.stud_ref_no
            AND a.session_code = v_ed8_parameter.session_code
            AND a.stud_award_type in ('SNB') --JCP160715 added extra condition to fix  defect 268
            AND ai.payment_status = 'S'
            AND ai.returned = 'N'
            AND ai.batch_ref is not null; 
         ELSE
           
                v_bursary_grant_details.snb_amount := 0;
                v_bursary_grant_details.snb_net_amount := 0; 
                v_bursary_grant_details.snb_overpayment_amount := 0;
                v_bursary_grant_details.snb_awi_net_amount := 0;
                v_bursary_grant_details.snb_recovered_amount := 0 ;
         END IF;
         
      END IF;

      --Check if DSA applies to student
      IF NVL (v_ed8_parameter.scheme_type, 'x') <> 'B'
      THEN
         OPEN dsa (v_ed8_parameter.stud_ref_no);

         FETCH dsa
          INTO v_dsa;

         IF dsa%FOUND
         THEN
            v_dsa_applies := 'Y';
         ELSE
            v_dsa_applies := 'N';
         END IF;

         CLOSE dsa;
      ELSIF NVL (v_ed8_parameter.scheme_type, 'x') = 'B'
      THEN
         OPEN dsa1 (v_ed8_parameter.stud_ref_no);

         FETCH dsa1
          INTO v_dsa;

         IF dsa1%FOUND
         THEN
            v_dsa_applies := 'Y';
         ELSE
            v_dsa_applies := 'N';
         END IF;

         CLOSE dsa1;
      ELSE
         v_dsa_applies := 'N';
      END IF;

      IF v_dsa_applies = 'Y'
      THEN
         SELECT NVL (SUM (a.amount), 0),
                NVL (SUM (a.net_amount), 0),
                NVL (SUM (a.overpayment_amount), 0)
           INTO v_bursary_grant_details.dsa_amount,
                v_bursary_grant_details.dsa_net_amount,
                v_bursary_grant_details.dsa_overpayment_amount
           FROM award_instalment ai, award a
          WHERE a.stud_ref_no = v_ed8_parameter.stud_ref_no
            AND a.session_code = v_ed8_parameter.session_code
            AND a.stud_award_type IN ('PSDSA', 'UGDSA', 'SNBDSA')
            AND ai.award_id = a.award_id
            AND NVL (ai.dsa_fee_instalment, 'N') = 'N'
            AND NVL (ai.payment_status, 'X') <> 'R'
            AND ai.recalc <> 'Y'
            AND ai.returned <> 'Y';

         SELECT NVL (SUM (ai.amount), 0),
                NVL (SUM (ai.recovered_amount), 0)
           INTO v_bursary_grant_details.dsa_awi_net_amount,
                v_bursary_grant_details.dsa_recovered_amount
           FROM award_instalment ai, award a
          WHERE ai.award_id = a.award_id
            AND a.stud_ref_no = v_ed8_parameter.stud_ref_no
            AND a.session_code = v_ed8_parameter.session_code
            AND a.stud_award_type IN ('PSDSA', 'UGDSA', 'SNBDSA')
            AND ai.payment_status = 'S'
            AND ai.batch_ref IS NOT NULL
            AND NVL (ai.dsa_fee_instalment, 'N') = 'N';
      ELSE
         v_bursary_grant_details.dsa_amount := 0;
         v_bursary_grant_details.dsa_net_amount := 0;
         v_bursary_grant_details.dsa_awi_net_amount := 0;
         v_bursary_grant_details.dsa_overpayment_amount := 0;
         v_bursary_grant_details.dsa_recovered_amount := 0;
      END IF;

      --Check if Dependants Allowance applies to student
      IF NVL (v_ed8_parameter.scheme_type, 'x') <> 'B'
      THEN
         OPEN da (v_ed8_parameter.stud_ref_no);

         FETCH da
          INTO v_da;

         IF da%FOUND
         THEN
            v_da_applies := 'Y';
         ELSE
            v_da_applies := 'N';
         END IF;

         CLOSE da;
      ELSIF NVL (v_ed8_parameter.scheme_type, 'x') = 'B'
      THEN
         OPEN da1 (v_ed8_parameter.stud_ref_no);

         FETCH da1
          INTO v_da;

         IF da1%FOUND
         THEN
            v_da_applies := 'Y';
         ELSE
            v_da_applies := 'N';
         END IF;

         CLOSE da1;
      ELSE
         v_da_applies := 'N';
      END IF;

      IF v_da_applies = 'Y'
      THEN
         SELECT NVL (SUM (a.amount), 0),
                NVL (SUM (a.net_amount), 0),
                NVL (SUM (a.overpayment_amount), 0)
           INTO v_bursary_grant_details.da_amount,
                v_bursary_grant_details.da_net_amount,
                v_bursary_grant_details.da_overpayment_amount
           FROM award a
          WHERE a.stud_ref_no = v_ed8_parameter.stud_ref_no
            AND a.session_code = v_ed8_parameter.session_code
            AND a.stud_award_type IN ('UGDA', 'SNDA');

         SELECT NVL (SUM (ai.amount), 0),
                NVL (SUM (ai.recovered_amount), 0)
           INTO v_bursary_grant_details.da_awi_net_amount,
                v_bursary_grant_details.da_recovered_amount
           FROM award_instalment ai, award a
          WHERE ai.award_id = a.award_id
            AND a.stud_ref_no = v_ed8_parameter.stud_ref_no
            AND a.session_code = v_ed8_parameter.session_code
            AND a.stud_award_type IN ('UGDA', 'SNDA')
            AND ai.award_id = a.award_id
            AND ai.payment_status = 'S'
            AND returned = 'N'
            AND ai.batch_ref IS NOT NULL;
      ELSE
         v_bursary_grant_details.da_amount := 0;
         v_bursary_grant_details.da_net_amount := 0;
         v_bursary_grant_details.da_awi_net_amount := 0;
         v_bursary_grant_details.da_overpayment_amount := 0;
         v_bursary_grant_details.da_recovered_amount := 0;
      END IF;
       

      --Check if SNPE applies to student
      IF NVL (v_ed8_parameter.scheme_type, 'x') = 'B'
      THEN
         OPEN snpe (v_ed8_parameter.stud_ref_no);

         FETCH snpe
          INTO v_snpe_applies;

         IF snpe%FOUND
         THEN
            v_snpe_applies := 'Y';
         ELSE
            v_snpe_applies := 'N';
         END IF;

         CLOSE snpe;
      ELSE
         v_snpe_applies := 'N';
      END IF;

      IF v_snpe_applies = 'Y'
      THEN
         SELECT NVL (SUM (amount), 0),
                NVL (SUM (net_amount), 0),
                NVL (SUM (overpayment_amount), 0)
           INTO v_bursary_grant_details.snpe_amount,
                v_bursary_grant_details.snpe_net_amount,
                v_bursary_grant_details.snpe_overpayment_amount
           FROM award
          WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND stud_award_type = 'SNPE';

         SELECT NVL (SUM (net_amount), 0),
                NVL (SUM (recovered_amount), 0)
           INTO v_bursary_grant_details.snpe_awi_net_amount,
                v_bursary_grant_details.snpe_recovered_amount
           FROM award_instalment
          WHERE award_id IN (
                   SELECT award_id
                     FROM award
                    WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
                      AND session_code = v_ed8_parameter.session_code
                      AND stud_award_type = 'SNPE'
                      AND payment_status = 'S'
                      AND returned = 'N'
                      AND batch_ref IS NOT NULL);
      ELSE
         v_bursary_grant_details.snpe_amount := 0;
         v_bursary_grant_details.snpe_net_amount := 0;
         v_bursary_grant_details.snpe_awi_net_amount := 0;
         v_bursary_grant_details.snpe_overpayment_amount := 0;
         v_bursary_grant_details.snpe_recovered_amount := 0;
      END IF;

      --Check if SNIE applies to student
      IF NVL (v_ed8_parameter.scheme_type, 'x') = 'B'
      THEN
         OPEN snie (v_ed8_parameter.stud_ref_no);

         FETCH snie
          INTO v_snie_applies;

         IF snie%FOUND
         THEN
            v_snie_applies := 'Y';
         ELSE
            v_snie_applies := 'N';
         END IF;

         CLOSE snie;
      ELSE
         v_snie_applies := 'N';
      END IF;

      IF v_snie_applies = 'Y'
      THEN
         SELECT NVL (SUM (amount), 0),
                NVL (SUM (net_amount), 0),
                NVL (SUM (overpayment_amount), 0)
           INTO v_bursary_grant_details.snie_amount,
                v_bursary_grant_details.snie_net_amount,
                v_bursary_grant_details.snie_overpayment_amount
           FROM award
          WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND stud_award_type = 'SNIE';

         SELECT NVL (SUM (net_amount), 0),
                NVL (SUM (recovered_amount), 0)
           INTO v_bursary_grant_details.snie_awi_net_amount,
                v_bursary_grant_details.snie_recovered_amount
           FROM award_instalment
          WHERE award_id IN (
                   SELECT award_id
                     FROM award
                    WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
                      AND session_code = v_ed8_parameter.session_code
                      AND stud_award_type = 'SNIE'
                      AND payment_status = 'S'
                      AND returned = 'N'
                      AND batch_ref IS NOT NULL);
      ELSE
         v_bursary_grant_details.snie_amount := 0;
         v_bursary_grant_details.snie_net_amount := 0;
         v_bursary_grant_details.snie_awi_net_amount := 0;
         v_bursary_grant_details.snie_overpayment_amount := 0;
         v_bursary_grant_details.snie_recovered_amount := 0;
      END IF;

      --Check if ADHOC applies to student both NMSB and UG

         OPEN adhoc (v_ed8_parameter.stud_ref_no);

         FETCH adhoc
          INTO v_adhoc_applies;

         IF adhoc%FOUND
         THEN
            v_adhoc_applies := 'Y';
         ELSE
            v_adhoc_applies := 'N';
         END IF;

         CLOSE adhoc;


      IF v_adhoc_applies = 'Y'
      THEN
         v_bursary_grant_details.adhoc_type_f := NULL;
         v_bursary_grant_details.adhoc_type_a := NULL;
         v_bursary_grant_details.adhoc_type_o := NULL;
         v_bursary_grant_details.adhoc_type_e := NULL;
         v_bursary_grant_details.adhoc_type_r := NULL;
         v_bursary_grant_details.adhoc_type_t := NULL;
         v_bursary_grant_details.adhoc_type_p := NULL;
         v_bursary_grant_details.adhoc_type_v := NULL;
         v_bursary_grant_details.adhoc_type_l := NULL;
         
         v_bursary_grant_details.adhoc_type_i := NULL; -- CR514 12/03/2019 John Penman
         v_bursary_grant_details.adhoc_type_u := NULL; -- CR514 12/03/2019 John Penman
         v_bursary_grant_details.adhoc_type_n := NULL; -- CR514 12/03/2019 John Penman
         
         
         v_adhoc_type_count := 1;
         
         IF v_adhoc_type_count <> 0
         THEN
            FOR v_adhoc_type IN c_adhoc_type (v_ed8_parameter.stud_ref_no)
            LOOP
               IF v_adhoc_type.adhoc_type = 'F'
               THEN
                  v_bursary_grant_details.adhoc_type_f :=
                                                v_adhoc_type.adhoc_type_total;
               END IF;

               IF v_adhoc_type.adhoc_type = 'A'
               THEN
                  v_bursary_grant_details.adhoc_type_a :=
                                                v_adhoc_type.adhoc_type_total;
               END IF;

               IF v_adhoc_type.adhoc_type = 'O'
               THEN
                  v_bursary_grant_details.adhoc_type_o :=
                                                v_adhoc_type.adhoc_type_total;
               END IF;

               IF v_adhoc_type.adhoc_type = 'E'
               THEN
                  v_bursary_grant_details.adhoc_type_e :=
                                                v_adhoc_type.adhoc_type_total;
               END IF;

               IF v_adhoc_type.adhoc_type = 'R'
               THEN
                  v_bursary_grant_details.adhoc_type_r :=
                                                v_adhoc_type.adhoc_type_total;
               END IF;

               IF v_adhoc_type.adhoc_type = 'T'
               THEN
                  v_bursary_grant_details.adhoc_type_t :=
                                                v_adhoc_type.adhoc_type_total;
               END IF;

               IF v_adhoc_type.adhoc_type = 'P'
               THEN
                  v_bursary_grant_details.adhoc_type_p :=
                                                v_adhoc_type.adhoc_type_total;
               END IF;

               IF v_adhoc_type.adhoc_type = 'V'
               THEN
                  v_bursary_grant_details.adhoc_type_v :=
                                                v_adhoc_type.adhoc_type_total;
               END IF;

               IF v_adhoc_type.adhoc_type = 'L'
               THEN
                  v_bursary_grant_details.adhoc_type_l :=
                                                v_adhoc_type.adhoc_type_total;
               END IF;
               -- the following additional code is for CR514 12/03/2019 John Penman
               
               IF v_adhoc_type.adhoc_type = 'I'
               THEN
                v_bursary_grant_details.adhoc_type_i := v_adhoc_type.adhoc_type_total;
               END IF;   
               
               IF v_adhoc_type.adhoc_type = 'U'
               THEN
                v_bursary_grant_details.adhoc_type_u := v_adhoc_type.adhoc_type_total;
               END IF;                           
               
               IF v_adhoc_type.adhoc_type = 'N'
               THEN
                v_bursary_grant_details.adhoc_type_n := v_adhoc_type.adhoc_type_total;
               END IF;
               
               --- END OF NEW CODE FOR CR514               
            END LOOP;
         END IF;

         SELECT NVL (SUM (amount), 0),
                NVL (SUM (net_amount), 0),
                NVL (SUM (overpayment_amount), 0)
           INTO v_bursary_grant_details.adhoc_amount,
                v_bursary_grant_details.adhoc_net_amount,
                v_bursary_grant_details.adhoc_overpayment_amount
           FROM award
          WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND stud_award_type = 'ADHOC';
            

         SELECT NVL (SUM (net_amount), 0),
                NVL (SUM (recovered_amount), 0)
           INTO v_bursary_grant_details.adhoc_awi_net_amount,
                v_bursary_grant_details.adhoc_recovered_amount
           FROM award_instalment
          WHERE award_id IN (
                   SELECT award_id
                     FROM award
                    WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
                      AND session_code = v_ed8_parameter.session_code
                      AND stud_award_type = 'ADHOC'
                      AND payment_status = 'S'
                      AND returned = 'N'
                      AND batch_ref IS NOT NULL);
      ELSE
         v_bursary_grant_details.adhoc_amount := 0;
         v_bursary_grant_details.adhoc_net_amount := 0;
         v_bursary_grant_details.adhoc_awi_net_amount := 0;
         v_bursary_grant_details.adhoc_overpayment_amount := 0;
         v_bursary_grant_details.adhoc_recovered_amount := 0;
      END IF;
      
      
      
      --EDUCATIONAL PYSCHOLOGY
      --GRANT COMPONENT
      
      --Verify that not an NMSB student
      IF NVL (v_ed8_parameter.scheme_type, 'x') <> 'B'
      THEN
         OPEN edpy_grant (v_ed8_parameter.stud_ref_no);

         FETCH edpy_grant
         INTO v_edpy_grant_applies; --must define
          
        --Check if ED PYSC applies to student
         IF edpy_grant%FOUND
         THEN
            v_edpy_grant_applies := 'Y';
         ELSE
            v_edpy_grant_applies := 'N';
         END IF;

         CLOSE edpy_grant;
      ELSE
         v_edpy_grant_applies := 'N';
      END IF;

      
      
      IF v_edpy_grant_applies = 'Y'
      THEN
         SELECT NVL (SUM (amount), 0),
                NVL (SUM (net_amount), 0),
                NVL (SUM (overpayment_amount), 0)
           INTO v_bursary_grant_details.edpy_grant_amount,
                v_bursary_grant_details.edpy_grant_net_amount,
                v_bursary_grant_details.edpy_grant_overpayment_amount
           FROM award
          WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND stud_award_type = 'PGEDG';

         SELECT NVL (SUM (net_amount), 0),
                NVL (SUM (recovered_amount), 0)
           INTO v_bursary_grant_details.edpy_grant_awi_net_amount,
                v_bursary_grant_details.edpy_grant_recovered_amount
           FROM award_instalment
          WHERE award_id IN (
                   SELECT award_id
                     FROM award
                    WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
                      AND session_code = v_ed8_parameter.session_code
                      AND stud_award_type = 'PGEDG'
                      AND payment_status = 'S'
                      AND returned = 'N'
                      AND batch_ref IS NOT NULL);
      ELSE
         v_bursary_grant_details.edpy_grant_amount := 0;
         v_bursary_grant_details.edpy_grant_net_amount := 0;
         v_bursary_grant_details.edpy_grant_awi_net_amount := 0;
         v_bursary_grant_details.edpy_grant_overpayment_amount := 0;
         v_bursary_grant_details.edpy_grant_recovered_amount := 0;
      END IF;
      
      
      --EDUCATIONAL PYSCHOLOGY
      --FEES COMPONENT
      
      --Verify that not an NMSB student
      IF NVL (v_ed8_parameter.scheme_type, 'x') <> 'B'
      THEN
         OPEN edpy_fees (v_ed8_parameter.stud_ref_no);

         FETCH edpy_fees
         INTO v_edpy_fees_applies; --must define
          
        --Check if ED PYSC applies to student
         IF edpy_fees%FOUND
         THEN
            v_edpy_fees_applies := 'Y';
         ELSE
            v_edpy_fees_applies := 'N';
         END IF;

         CLOSE edpy_fees;
      ELSE
         v_edpy_fees_applies := 'N';
      END IF; 
      
      IF v_edpy_fees_applies = 'Y'
      THEN
         SELECT NVL (SUM (amount), 0),
                NVL (SUM (net_amount), 0),
                NVL (SUM (overpayment_amount), 0)
           INTO v_bursary_grant_details.edpy_fees_amount,
                v_bursary_grant_details.edpy_fees_net_amount,
                v_bursary_grant_details.edpy_fees_overpayment_amount
           FROM award
          WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND stud_award_type = 'PGEDF';

         SELECT NVL (SUM (net_amount), 0),
                NVL (SUM (recovered_amount), 0)
           INTO v_bursary_grant_details.edpy_fees_awi_net_amount,
                v_bursary_grant_details.edpy_fees_recovered_amount
           FROM award_instalment
          WHERE award_id IN (
                   SELECT award_id
                     FROM award
                    WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
                      AND session_code = v_ed8_parameter.session_code
                      AND stud_award_type = 'PGEDF'
                      AND payment_status = 'S'
                      AND returned = 'N'
                      AND batch_ref IS NOT NULL);
      ELSE
         v_bursary_grant_details.edpy_fees_amount := 0;
         v_bursary_grant_details.edpy_fees_net_amount := 0;
         v_bursary_grant_details.edpy_fees_awi_net_amount := 0;
         v_bursary_grant_details.edpy_fees_overpayment_amount := 0;
         v_bursary_grant_details.edpy_fees_recovered_amount := 0;
      END IF;
      
      
      -- PHD EDUCATIONAL PSYCHOLOGY BEGIN
  
      --PHD EDUCATIONAL PYSCHOLOGY
      --GRANT COMPONENT
      
      --Verify that not an NMSB student
      IF NVL (v_ed8_parameter.scheme_type, 'x') <> 'B'
      THEN
         OPEN edpy_phd_grant (v_ed8_parameter.stud_ref_no);

         FETCH edpy_phd_grant
         INTO v_edpy_phd_grant_applies; --must define
          
        --Check if ED PYSC applies to student
         IF edpy_phd_grant%FOUND
         THEN
            v_edpy_phd_grant_applies := 'Y';
         ELSE
            v_edpy_phd_grant_applies := 'N';
         END IF;

         CLOSE edpy_phd_grant;
      ELSE
         v_edpy_phd_grant_applies := 'N';
      END IF;

      
      
      IF v_edpy_phd_grant_applies = 'Y'
      THEN
         SELECT NVL (SUM (amount), 0),
                NVL (SUM (net_amount), 0),
                NVL (SUM (overpayment_amount), 0)
           INTO v_bursary_grant_details.edpy_phd_grant_amount,
                v_bursary_grant_details.edpy_phd_grant_net_amount,
                v_bursary_grant_details.edpy_phd_grant_overpayment_amount
           FROM award
          WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND stud_award_type = 'PGEDGP';

         SELECT NVL (SUM (net_amount), 0),
                NVL (SUM (recovered_amount), 0)
           INTO v_bursary_grant_details.edpy_phd_grant_awi_net_amount,
                v_bursary_grant_details.edpy_phd_grant_recovered_amount
           FROM award_instalment
          WHERE award_id IN (
                   SELECT award_id
                     FROM award
                    WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
                      AND session_code = v_ed8_parameter.session_code
                      AND stud_award_type = 'PGEDGP'
                      AND payment_status = 'S'
                      AND returned = 'N'
                      AND batch_ref IS NOT NULL);
      ELSE
         v_bursary_grant_details.edpy_phd_grant_amount := 0;
         v_bursary_grant_details.edpy_phd_grant_net_amount := 0;
         v_bursary_grant_details.edpy_phd_grant_awi_net_amount := 0;
         v_bursary_grant_details.edpy_phd_grant_overpayment_amount := 0;
         v_bursary_grant_details.edpy_phd_grant_recovered_amount := 0;
      END IF;
      
      
      --PHD EDUCATIONAL PYSCHOLOGY
      --FEES COMPONENT
      
      --Verify that not an NMSB student
      IF NVL (v_ed8_parameter.scheme_type, 'x') <> 'B'
      THEN
         OPEN edpy_phd_fees (v_ed8_parameter.stud_ref_no);

         FETCH edpy_phd_fees
         INTO v_edpy_phd_fees_applies; --must define
          
        --Check if ED PYSC applies to student
         IF edpy_phd_fees%FOUND
         THEN
            v_edpy_phd_fees_applies := 'Y';
         ELSE
            v_edpy_phd_fees_applies := 'N';
         END IF;

         CLOSE edpy_phd_fees;
      ELSE
         v_edpy_phd_fees_applies := 'N';
      END IF; 
      
      IF v_edpy_phd_fees_applies = 'Y'
      THEN
         SELECT NVL (SUM (amount), 0),
                NVL (SUM (net_amount), 0),
                NVL (SUM (overpayment_amount), 0)
           INTO v_bursary_grant_details.edpy_phd_fees_amount,
                v_bursary_grant_details.edpy_phd_fees_net_amount,
                v_bursary_grant_details.edpy_phd_fees_overpayment_amount
           FROM award
          WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND stud_award_type = 'PGEDFP';

         SELECT NVL (SUM (net_amount), 0),
                NVL (SUM (recovered_amount), 0)
           INTO v_bursary_grant_details.edpy_phd_fees_awi_net_amount,
                v_bursary_grant_details.edpy_phd_fees_recovered_amount
           FROM award_instalment
          WHERE award_id IN (
                   SELECT award_id
                     FROM award
                    WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
                      AND session_code = v_ed8_parameter.session_code
                      AND stud_award_type = 'PGEDFP'
                      AND payment_status = 'S'
                      AND returned = 'N'
                      AND batch_ref IS NOT NULL);
      ELSE
         v_bursary_grant_details.edpy_phd_fees_amount := 0;
         v_bursary_grant_details.edpy_phd_fees_net_amount := 0;
         v_bursary_grant_details.edpy_phd_fees_awi_net_amount := 0;
         v_bursary_grant_details.edpy_phd_fees_overpayment_amount := 0;
         v_bursary_grant_details.edpy_phd_fees_recovered_amount := 0;
      END IF;
            
      -- PHD EDUCATIONAL PSYCHOLOGY END
      
      

      --Total up amounts
      v_bursary_grant_details.tot_amount :=
           v_bursary_grant_details.isb_amount
         + v_bursary_grant_details.esb_amount --Estrangement COS 2023 John Penman 13/12/2023  
         + v_bursary_grant_details.ysb_amount
         + v_bursary_grant_details.ugoa_snspa_amount
         + v_bursary_grant_details.sncap_amount
         + v_bursary_grant_details.snb_amount
         + v_bursary_grant_details.dsa_amount
         + v_bursary_grant_details.da_amount
         + v_bursary_grant_details.snpe_amount
         + v_bursary_grant_details.snie_amount
         + v_bursary_grant_details.adhoc_amount
         + v_bursary_grant_details.edpy_grant_amount
         + v_bursary_grant_details.edpy_fees_amount
         + v_bursary_grant_details.edpy_phd_grant_amount
         + v_bursary_grant_details.edpy_phd_fees_amount;
      v_bursary_grant_details.tot_net_amount :=
           v_bursary_grant_details.isb_net_amount
         + v_bursary_grant_details.esb_net_amount --Estrangement COS 2023 John Penman 13/12/2023  
         + v_bursary_grant_details.ysb_net_amount
         + v_bursary_grant_details.cesb_net_amount --CR499 CESB M.Tolmie
         + v_bursary_grant_details.ugoa_snspa_net_amount
         + v_bursary_grant_details.sncap_net_amount
         + v_bursary_grant_details.snb_net_amount
         + v_bursary_grant_details.dsa_net_amount
         + v_bursary_grant_details.da_net_amount
         + v_bursary_grant_details.snpe_net_amount
         + v_bursary_grant_details.snie_net_amount
         + v_bursary_grant_details.adhoc_net_amount
         + v_bursary_grant_details.edpy_grant_net_amount
         + v_bursary_grant_details.edpy_fees_net_amount
         + v_bursary_grant_details.edpy_phd_grant_net_amount
         + v_bursary_grant_details.edpy_phd_fees_net_amount;
      v_bursary_grant_details.tot_awi_net_amount :=
           v_bursary_grant_details.isb_awi_net_amount
         + v_bursary_grant_details.esb_awi_net_amount --Estrangement COS 2023 John Penman 13/12/2023  
         + v_bursary_grant_details.ysb_awi_net_amount
         + v_bursary_grant_details.cesb_awi_net_amount --CR499 CESB M.Tolmie
         + v_bursary_grant_details.ugoa_snspa_awi_net_amount
         + v_bursary_grant_details.sncap_awi_net_amount
         + v_bursary_grant_details.snb_awi_net_amount
         + v_bursary_grant_details.dsa_awi_net_amount
         + v_bursary_grant_details.da_awi_net_amount
         + v_bursary_grant_details.snpe_awi_net_amount
         + v_bursary_grant_details.snie_awi_net_amount
         + v_bursary_grant_details.adhoc_awi_net_amount
         + v_bursary_grant_details.edpy_grant_awi_net_amount
         + v_bursary_grant_details.edpy_fees_awi_net_amount         
         + v_bursary_grant_details.edpy_phd_grant_awi_net_amount
         + v_bursary_grant_details.edpy_phd_fees_awi_net_amount;
      v_bursary_grant_details.tot_overpayment_amount :=
           v_bursary_grant_details.isb_overpayment_amount
         + v_bursary_grant_details.esb_overpayment_amount --Estrangement COS 2023 John Penman 13/12/2023  
         + v_bursary_grant_details.ysb_overpayment_amount
         + v_bursary_grant_details.ugoa_snspa_opymnt_amount
         + v_bursary_grant_details.sncap_opymnt_amount
         + v_bursary_grant_details.snb_overpayment_amount
         + v_bursary_grant_details.dsa_overpayment_amount
         + v_bursary_grant_details.da_overpayment_amount
         + v_bursary_grant_details.snpe_overpayment_amount
         + v_bursary_grant_details.snie_overpayment_amount
         + v_bursary_grant_details.adhoc_overpayment_amount
         + v_bursary_grant_details.edpy_grant_overpayment_amount
         + v_bursary_grant_details.edpy_fees_overpayment_amount         
         + v_bursary_grant_details.edpy_phd_grant_overpayment_amount
         + v_bursary_grant_details.edpy_phd_fees_overpayment_amount;                  
      v_bursary_grant_details.tot_recovered_amount :=
           v_bursary_grant_details.isb_recovered_amount
         + v_bursary_grant_details.esb_recovered_amount --Estrangement COS 2023 John Penman 13/12/2023   
         + v_bursary_grant_details.ysb_recovered_amount
         + v_bursary_grant_details.ugoa_snspa_recovered_amount
         + v_bursary_grant_details.sncap_recovered_amount
         + v_bursary_grant_details.snb_recovered_amount
         + v_bursary_grant_details.dsa_recovered_amount
         + v_bursary_grant_details.da_recovered_amount
         + v_bursary_grant_details.snpe_recovered_amount
         + v_bursary_grant_details.snie_recovered_amount
         + v_bursary_grant_details.adhoc_recovered_amount
         + v_bursary_grant_details.edpy_grant_recovered_amount
         + v_bursary_grant_details.edpy_fees_recovered_amount         
         + v_bursary_grant_details.edpy_phd_grant_recovered_amount
         + v_bursary_grant_details.edpy_phd_fees_recovered_amount;         
      RETURN v_bursary_grant_details;
   END get_bursary_grant_details;

   FUNCTION get_loan_details (v_ed8_parameter IN t_ed8_parameter)
      RETURN t_loan_details
   IS
      v_loan_details    t_loan_details;
      v_count           NUMBER;
      c_applies_value   VARCHAR2 (1);
   BEGIN
      IF NVL (v_ed8_parameter.scheme_type, 'x') <> 'B'
      THEN
         SELECT COUNT (*)
           INTO v_count
           FROM award
          WHERE stud_crse_year_id = v_ed8_parameter.stud_crse_year_id
            AND stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'A'
            AND stud_award_type IN ('UGLOAN');

         IF v_count > 0
         THEN
            c_applies_value := 'Y';
         ELSE
            c_applies_value := 'N';
         END IF;
      ELSE
         c_applies_value := 'N';
      END IF;

      IF c_applies_value = 'Y'
      THEN
         SELECT NVL (SUM (amount), 0), NVL (SUM (net_amount), 0),
                NVL (SUM (unclaimed_loan), 0)
           INTO v_loan_details.ugl_amount, v_loan_details.ugl_net_amount,
                v_loan_details.ugl_unclaimed_loan
           FROM award
          WHERE stud_crse_year_id = v_ed8_parameter.stud_crse_year_id
            AND stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code
            AND stud_award_type IN ('UGLOAN');
      ELSE
         v_loan_details.ugl_amount := 0;
         v_loan_details.ugl_net_amount := 0;
         v_loan_details.ugl_unclaimed_loan := 0;
      END IF;

      RETURN v_loan_details;
   END get_loan_details;

   FUNCTION get_tuition_fee_details (v_ed8_parameter IN t_ed8_parameter)
      RETURN t_tuition_fee_details
   IS
      v_tuition_fee_details      t_tuition_fee_details;
      v_crse_id                  stud_crse_year.crse_id%TYPE;
      v_apply                    VARCHAR2 (2);
      v_tfel_apply               VARCHAR2 (1);
      v_fees_apply               VARCHAR2 (1);
     -- c_38_applies_value         VARCHAR2 (1); ****COMMENTED OUT CR222
      --c_45_applies_value         VARCHAR2 (1); ****COMMENTED OUT CR222
      v_stud_crse_year_id        award.stud_crse_year_id%TYPE;
      v_amount                   award.amount%TYPE;
      v_net_amount               award.net_amount%TYPE;
      v_dearing                  stud_crse_year.dearing%TYPE;
      v_paid_sandwich            stud_crse_year.paid_sandwich%TYPE;
      v_unpaid_sandwich          stud_crse_year.unpaid_sandwich%TYPE;
      v_crse_year_id             crse_year.crse_year_id%TYPE;
      v_var_sand_tuit_fee_amnt   crse_year.var_sandwich_tuition_fee_amnt%TYPE;
      v_req_tuition_fee          crse_year.req_tuition_fee%TYPE;
      v_var_tuition_fee_amnt     crse_year.var_tuition_fee_amnt%TYPE;

      CURSOR tf1a (p_stud_crse_year_id stud_crse_year.stud_crse_year_id%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_crse_year_id = p_stud_crse_year_id
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'T'
            AND amount > 0
            AND net_amount > 0
            AND stud_award_type = 'TFEL';

      CURSOR tf1b (p_stud_crse_year_id stud_crse_year.stud_crse_year_id%TYPE)
      IS
         SELECT 'x'
           FROM award
          WHERE stud_crse_year_id = p_stud_crse_year_id
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'T'
            AND amount > 0
            AND net_amount > 0
            AND stud_award_type IN('FEES', 'GAFEE', 'SNFEE');

      CURSOR tf1 (p_stud_crse_year_id stud_crse_year.stud_crse_year_id%TYPE)
      IS
         SELECT tuition_fee_type_code
           FROM award
          WHERE stud_crse_year_id = p_stud_crse_year_id
            AND session_code = v_ed8_parameter.session_code
            AND award_src = 'T'
            AND amount > 0
            AND net_amount > 0;

      CURSOR tf2 (p_stud_ref_no award.stud_ref_no%TYPE)
      IS
         SELECT award.stud_crse_year_id, award.net_amount,
                stud_crse_year.dearing, award.amount
           FROM award, stud_crse_year
          WHERE award.stud_ref_no = p_stud_ref_no
            AND award.session_code = v_ed8_parameter.session_code
            AND award.award_src = 'T'
            AND award.amount > 0
            AND award.stud_crse_year_id = stud_crse_year.stud_crse_year_id;

      CURSOR tf3 (p_stud_ref_no award.stud_ref_no%TYPE)
      IS
         SELECT award.stud_crse_year_id
           FROM award, stud_crse_year
          WHERE award.stud_ref_no = p_stud_ref_no
            AND award.session_code = v_ed8_parameter.session_code
            AND award.award_src = 'T'
            AND award.amount > 0
            AND award.stud_crse_year_id = stud_crse_year.stud_crse_year_id
            --AND stud_crse_year.dearing = 'G'
            ;

      CURSOR tf4 (p_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT NVL (SUM (amount), 0) amount,
                NVL (SUM (net_amount), 0) net_amount
           FROM award, stud_crse_year
          WHERE award.stud_ref_no = p_stud_ref_no
            AND award.session_code = v_ed8_parameter.session_code
            AND award.award_src = 'T'
            AND award.stud_crse_year_id = stud_crse_year.stud_crse_year_id
            --AND stud_crse_year.dearing <> 'G'
            ;

      CURSOR tf5 (p_stud_ref_no stud_crse_year.stud_ref_no%TYPE)
      IS
         SELECT NVL (SUM (amount), 0) amount,
                NVL (SUM (net_amount), 0) net_amount
           FROM award, stud_crse_year
          WHERE award.stud_ref_no = p_stud_ref_no
            AND award.session_code = v_ed8_parameter.session_code
            AND award.award_src = 'T'
            AND award.stud_crse_year_id = stud_crse_year.stud_crse_year_id;
            --AND stud_crse_year.dearing = 'G'  ****commented out as part of the CR222
            
     /*
      CURSOR tf6 (
         p_stud_crse_year_id   IN   stud_crse_year.stud_crse_year_id%TYPE
      )
      IS
         SELECT scy.paid_sandwich, scy.unpaid_sandwich, cy.crse_year_id,
                cy.var_sandwich_tuition_fee_amnt, cy.req_tuition_fee,
                cy.var_tuition_fee_amnt
           FROM stud_crse_year scy, crse_year cy
          WHERE stud_crse_year_id = p_stud_crse_year_id
            AND scy.crse_year_id = cy.crse_year_id;
      */
      
            
   BEGIN
      OPEN tf1a (v_ed8_parameter.stud_crse_year_id);

      FETCH tf1a
       INTO v_tfel_apply;

      IF tf1a%FOUND
      THEN
         v_tfel_apply := 'Y';
      ELSE
         v_tfel_apply := 'N';
      END IF;

      CLOSE tf1a;

      IF v_tfel_apply = 'Y'
      THEN
         SELECT TO_CHAR (fee_loan_declaration_date, 'DD-MON-YYYY'),
                max_fee_loan_requested
           INTO v_tuition_fee_details.fee_loan_declaration_date,
                v_tuition_fee_details.max_fee_loan_requested
           FROM stud_session
          WHERE stud_ref_no = v_ed8_parameter.stud_ref_no
            AND session_code = v_ed8_parameter.session_code;
      ELSE
         v_tuition_fee_details.fee_loan_declaration_date := NULL;
         v_tuition_fee_details.max_fee_loan_requested := NULL;
      END IF;

      --- Get Fee Loan data
      IF v_tfel_apply = 'Y'
      THEN
         OPEN tf5 (v_ed8_parameter.stud_ref_no);

         FETCH tf5
          INTO v_tuition_fee_details.fl_amount,
               v_tuition_fee_details.fl_net_amount;

         IF tf5%NOTFOUND
         THEN
            v_tuition_fee_details.fl_amount := 0;
            v_tuition_fee_details.fl_net_amount := 0;
            v_tuition_fee_details.fl_awi_net_amount := 0;
         ELSE
            SELECT NVL (SUM (ai.net_amount), 0)
              INTO v_tuition_fee_details.fl_awi_net_amount
              FROM award_instalment ai, award a, stud_crse_year scy
             WHERE ai.award_id = a.award_id
               AND a.stud_ref_no = v_ed8_parameter.stud_ref_no
               AND a.session_code = v_ed8_parameter.session_code
               AND a.award_src = 'T'
               AND ai.payment_status = 'S'
               AND ai.returned = 'N'
               AND ai.batch_ref IS NOT NULL
               AND a.stud_crse_year_id = scy.stud_crse_year_id;
               --AND scy.dearing = 'G' ****commented out as part of the CR222
               
         END IF;

         CLOSE tf5;
      ELSIF v_tfel_apply = 'N'
      THEN
         v_tuition_fee_details.fl_amount := 0;
         v_tuition_fee_details.fl_net_amount := 0;
         v_tuition_fee_details.fl_awi_net_amount := 0;
      END IF;

      OPEN tf1b (v_ed8_parameter.stud_crse_year_id);

      FETCH tf1b
       INTO v_fees_apply;

      IF tf1b%FOUND
      THEN
         v_fees_apply := 'Y';
      ELSE
         v_fees_apply := 'N';
      END IF;

      CLOSE tf1b;

      --- Get Fees data
      IF v_fees_apply = 'Y'
      THEN
         OPEN tf4 (v_ed8_parameter.stud_ref_no);

         FETCH tf4
          INTO v_tuition_fee_details.tf_amount,
               v_tuition_fee_details.tf_net_amount;

         IF tf4%NOTFOUND
         THEN
            v_tuition_fee_details.tf_amount := 0;
            v_tuition_fee_details.tf_net_amount := 0;
            v_tuition_fee_details.tf_awi_net_amount := 0;
         ELSE
            SELECT NVL (SUM (ai.net_amount), 0)
              INTO v_tuition_fee_details.tf_awi_net_amount
              FROM award_instalment ai, award a, stud_crse_year scy
             WHERE ai.award_id = a.award_id
               AND a.stud_ref_no = v_ed8_parameter.stud_ref_no
               AND a.session_code = v_ed8_parameter.session_code
               AND a.award_src = 'T'
               AND ai.payment_status = 'S'
               AND ai.returned = 'N'
               AND ai.batch_ref IS NOT NULL
               AND a.stud_crse_year_id = scy.stud_crse_year_id;
              -- AND scy.dearing <> 'G' ****commented out as part of the CR222
         END IF;

         CLOSE tf4;
      ELSIF v_fees_apply = 'N'
      THEN
         v_tuition_fee_details.tf_amount := 0;
         v_tuition_fee_details.tf_net_amount := 0;
         v_tuition_fee_details.tf_awi_net_amount := 0;
      END IF;
      
      --NEXT SECTION COMMENTED OUT DUE TO CR222

    /*  SELECT crse_id
        INTO v_crse_id
        FROM stud_crse_year
       WHERE stud_crse_year_id = v_ed8_parameter.stud_crse_year_id;

      c_38_applies_value := NULL;
      c_45_applies_value := NULL;

      OPEN tf2 (v_ed8_parameter.stud_ref_no);

      FETCH tf2
       INTO v_stud_crse_year_id, v_net_amount, v_dearing;

      IF tf2%FOUND
      THEN
         IF v_dearing <> 'G'
         THEN
            c_38_applies_value := 'Y';
            c_45_applies_value := NULL;
         ELSIF v_dearing = 'G' AND v_net_amount > 0
         THEN
            c_38_applies_value := NULL;
            c_45_applies_value := 'Y';
         ELSIF v_dearing = 'G' AND v_net_amount = 0
         THEN
            c_38_applies_value := NULL;
            c_45_applies_value := 'N';
         END IF;
      ELSE
         IF v_dearing = 'G'
         THEN
            c_38_applies_value := NULL;
            c_45_applies_value := 'N';
         ELSIF v_dearing <> 'G'
         THEN
            c_38_applies_value := 'N';
            c_45_applies_value := NULL;
         END IF;
      END IF;

      CLOSE tf2;

      IF NVL (c_38_applies_value, 'X') = 'Y'
      THEN
         OPEN tf1 (v_stud_crse_year_id);

         FETCH tf1
          INTO v_tuition_fee_details.tuition_fee_type_code;

         IF tf1%NOTFOUND
         THEN
            v_tuition_fee_details.tuition_fee_type_code := 0;
         ELSIF v_tuition_fee_details.tuition_fee_type_code IS NULL
         THEN
            -- use crse_id instead
            BEGIN
               SELECT tuition_fee_type_code
                 INTO v_tuition_fee_details.tuition_fee_type_code
                 FROM crse_session
                WHERE session_code = v_ed8_parameter.session_code
                  AND crse_id = v_crse_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_tuition_fee_details.tuition_fee_type_code := 0;
            END;
         END IF;

         CLOSE tf1;
      ELSIF NVL (c_38_applies_value, 'X') = 'N'
      THEN
         v_tuition_fee_details.tuition_fee_type_code := 0;
      ELSIF c_38_applies_value IS NULL
      THEN
         v_tuition_fee_details.tuition_fee_type_code := NULL;
      END IF;
      */

        --added for CR222 C Bolan 28/07/2014
        --SET tuition_fee_type_code to always be 0
        v_tuition_fee_details.tuition_fee_type_code := 0;
        
        OPEN tf2 (v_ed8_parameter.stud_ref_no);

      FETCH tf2
       INTO v_stud_crse_year_id, v_net_amount, v_dearing, v_amount;
       
       CLOSE tf2;

      OPEN tf1 (v_ed8_parameter.stud_crse_year_id);

      FETCH tf1
       INTO v_apply;

      IF tf1%FOUND
      THEN
         v_apply := 'Y';
      ELSE
         v_apply := 'N';
      END IF;

      CLOSE tf1;

      IF v_apply = 'Y'
      THEN
         BEGIN
            SELECT award_type_descript
              INTO v_tuition_fee_details.award_type_descript
              FROM award
             WHERE stud_crse_year_id = v_stud_crse_year_id AND award_src = 'T';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_tuition_fee_details.award_type_descript := NULL;
         END;
      ELSE
         v_tuition_fee_details.award_type_descript := NULL;
      END IF;

    /*
      --- Get Maximum fee loan
      IF v_tfel_apply = 'Y' 
      --OR (v_dearing = 'G' AND v_net_amount = 0) ****commented out as part of the CR22
      THEN
         OPEN tf6 (v_stud_crse_year_id);

         FETCH tf6
          INTO v_paid_sandwich, v_unpaid_sandwich, v_crse_year_id,
               v_var_sand_tuit_fee_amnt, v_req_tuition_fee,
               v_var_tuition_fee_amnt;

         IF    NVL (v_paid_sandwich, 'N') = 'Y'
            OR NVL (v_unpaid_sandwich, 'N') = 'Y'
         THEN
            IF (v_req_tuition_fee IS NULL) OR (v_req_tuition_fee = 0)
            THEN
               v_tuition_fee_details.max_fee_loan := v_var_sand_tuit_fee_amnt;
            ELSE
               IF v_var_sand_tuit_fee_amnt < v_req_tuition_fee
               THEN
                  v_tuition_fee_details.max_fee_loan :=
                                                     v_var_sand_tuit_fee_amnt;
               ELSIF v_req_tuition_fee < v_var_sand_tuit_fee_amnt
               THEN
                  v_tuition_fee_details.max_fee_loan := v_req_tuition_fee;
               END IF;
            END IF;
         ELSE
            IF (v_req_tuition_fee IS NULL) OR (v_req_tuition_fee = 0)
            THEN
               v_tuition_fee_details.max_fee_loan := v_var_tuition_fee_amnt;
            ELSE
               IF v_var_tuition_fee_amnt < v_req_tuition_fee
               THEN
                  v_tuition_fee_details.max_fee_loan :=
                                                       v_var_tuition_fee_amnt;
               ELSIF v_req_tuition_fee < v_var_tuition_fee_amnt
               THEN
                  v_tuition_fee_details.max_fee_loan := v_req_tuition_fee;
               END IF;
            END IF;
         END IF;

         CLOSE tf6;
      ELSE
         v_tuition_fee_details.max_fee_loan := NULL;
      END IF;
      */
      
      
      --- Get Maximum fee loan
       IF v_tfel_apply = 'Y'
       THEN
       OPEN tf2 (v_ed8_parameter.stud_ref_no);
        FETCH tf2
        INTO v_stud_crse_year_id, v_net_amount, v_dearing, v_amount;
        
        v_tuition_fee_details.max_fee_loan := v_amount;

       ELSE
         v_tuition_fee_details.max_fee_loan := NULL;
      END IF;

      RETURN v_tuition_fee_details;
   END get_tuition_fee_details;

   FUNCTION get_study_abroad_details (v_ed8_parameter IN t_ed8_parameter)
      RETURN t_study_abroad_details
   IS
      v_study_abroad_details   t_study_abroad_details;
   BEGIN
      SELECT erasmus,
             study_abroad,
             study_country,
             start_date_abroad,
             end_date_abroad
        INTO v_study_abroad_details.erasmus,
             v_study_abroad_details.study_abroad,
             v_study_abroad_details.study_country,
             v_study_abroad_details.start_date_abroad,
             v_study_abroad_details.end_date_abroad
        FROM stud_crse_year
       WHERE stud_crse_year_id = v_ed8_parameter.stud_crse_year_id;

      IF v_study_abroad_details.erasmus IS NULL
      THEN
         v_study_abroad_details.erasmus := 'N';
      END IF;

      IF v_study_abroad_details.study_abroad IS NULL
      THEN
         v_study_abroad_details.study_abroad := 'N';
      END IF;

      RETURN v_study_abroad_details;
   END get_study_abroad_details;

   FUNCTION get_dependants_details (v_ed8_parameter IN t_ed8_parameter)
      RETURN t_dependants_details
   IS
      v_dependants_details   t_dependants_details;

      CURSOR c_dep_age (
         cp_stud_ref_no    IN   stud_crse_year.stud_ref_no%TYPE,
         cp_session_code   IN   stud_crse_year.session_code%TYPE
      )
      IS
         SELECT   TRUNC ((MONTHS_BETWEEN (TRUNC (SYSDATE), dob)) / 12) age,
                  relation_id
             FROM stud_dependant
            WHERE session_code = cp_session_code
              AND stud_ref_no = cp_stud_ref_no
              AND NVL (include, 'N') = 'Y'
         ORDER BY 1 ASC;

      v_dep_age              c_dep_age%ROWTYPE;
   BEGIN
      SELECT COUNT (*)
        INTO v_dependants_details.stud_dependants_count
        FROM stud_dependant
       WHERE session_code = v_ed8_parameter.session_code
         AND stud_ref_no = v_ed8_parameter.stud_ref_no
         AND NVL (include, 'N') = 'Y';

      IF v_dependants_details.stud_dependants_count <> 0
      THEN
         OPEN c_dep_age (v_ed8_parameter.stud_ref_no,
                         v_ed8_parameter.session_code
                        );

         FETCH c_dep_age
          INTO v_dep_age;

         v_dependants_details.dep1_age := v_dep_age.age;
         v_dependants_details.dep1_rel_type := v_dep_age.relation_id;

         IF v_dependants_details.stud_dependants_count > 1
         THEN
            FETCH c_dep_age
             INTO v_dep_age;

            v_dependants_details.dep2_age := v_dep_age.age;
            v_dependants_details.dep2_rel_type := v_dep_age.relation_id;
         ELSE
            v_dependants_details.dep2_age := NULL;
            v_dependants_details.dep2_rel_type := NULL;
         END IF;

         IF v_dependants_details.stud_dependants_count > 2
         THEN
            FETCH c_dep_age
             INTO v_dep_age;

            v_dependants_details.dep3_age := v_dep_age.age;
            v_dependants_details.dep3_rel_type := v_dep_age.relation_id;
         ELSE
            v_dependants_details.dep3_age := NULL;
            v_dependants_details.dep3_rel_type := NULL;
         END IF;

         IF v_dependants_details.stud_dependants_count > 3
         THEN
            FETCH c_dep_age
             INTO v_dep_age;

            v_dependants_details.dep4_age := v_dep_age.age;
            v_dependants_details.dep4_rel_type := v_dep_age.relation_id;
         ELSE
            v_dependants_details.dep4_age := NULL;
            v_dependants_details.dep4_rel_type := NULL;
         END IF;

         IF v_dependants_details.stud_dependants_count > 4
         THEN
            FETCH c_dep_age
             INTO v_dep_age;

            v_dependants_details.dep5_age := v_dep_age.age;
            v_dependants_details.dep5_rel_type := v_dep_age.relation_id;
         ELSE
            v_dependants_details.dep5_age := NULL;
            v_dependants_details.dep5_rel_type := NULL;
         END IF;

         IF v_dependants_details.stud_dependants_count > 5
         THEN
            FETCH c_dep_age
             INTO v_dep_age;

            v_dependants_details.dep6_age := v_dep_age.age;
            v_dependants_details.dep6_rel_type := v_dep_age.relation_id;
         ELSE
            v_dependants_details.dep6_age := NULL;
            v_dependants_details.dep6_rel_type := NULL;
         END IF;

         IF v_dependants_details.stud_dependants_count > 6
         THEN
            FETCH c_dep_age
             INTO v_dep_age;

            v_dependants_details.dep7_age := v_dep_age.age;
            v_dependants_details.dep7_rel_type := v_dep_age.relation_id;
         ELSE
            v_dependants_details.dep7_age := NULL;
            v_dependants_details.dep7_rel_type := NULL;
         END IF;

         IF v_dependants_details.stud_dependants_count > 7
         THEN
            FETCH c_dep_age
             INTO v_dep_age;

            v_dependants_details.dep8_age := v_dep_age.age;
            v_dependants_details.dep8_rel_type := v_dep_age.relation_id;
         ELSE
            v_dependants_details.dep8_age := NULL;
            v_dependants_details.dep8_rel_type := NULL;
         END IF;

         IF v_dependants_details.stud_dependants_count > 8
         THEN
            FETCH c_dep_age
             INTO v_dep_age;

            v_dependants_details.dep9_age := v_dep_age.age;
            v_dependants_details.dep9_rel_type := v_dep_age.relation_id;
         ELSE
            v_dependants_details.dep9_age := NULL;
            v_dependants_details.dep9_rel_type := NULL;
         END IF;

         IF v_dependants_details.stud_dependants_count > 9
         THEN
            FETCH c_dep_age
             INTO v_dep_age;

            v_dependants_details.dep10_age := v_dep_age.age;
            v_dependants_details.dep10_rel_type := v_dep_age.relation_id;
         ELSE
            v_dependants_details.dep10_age := NULL;
            v_dependants_details.dep10_rel_type := NULL;
         END IF;

         CLOSE c_dep_age;
      ELSIF v_dependants_details.stud_dependants_count = 0
      THEN
         v_dependants_details.dep1_age := NULL;
         v_dependants_details.dep1_rel_type := NULL;
         v_dependants_details.dep2_age := NULL;
         v_dependants_details.dep2_rel_type := NULL;
         v_dependants_details.dep3_age := NULL;
         v_dependants_details.dep3_rel_type := NULL;
         v_dependants_details.dep4_age := NULL;
         v_dependants_details.dep4_rel_type := NULL;
         v_dependants_details.dep5_age := NULL;
         v_dependants_details.dep5_rel_type := NULL;
         v_dependants_details.dep6_age := NULL;
         v_dependants_details.dep6_rel_type := NULL;
         v_dependants_details.dep7_age := NULL;
         v_dependants_details.dep7_rel_type := NULL;
         v_dependants_details.dep8_age := NULL;
         v_dependants_details.dep8_rel_type := NULL;
         v_dependants_details.dep9_age := NULL;
         v_dependants_details.dep9_rel_type := NULL;
         v_dependants_details.dep10_age := NULL;
         v_dependants_details.dep10_rel_type := NULL;
      END IF;

      RETURN v_dependants_details;
   END get_dependants_details;

   FUNCTION pop_ed8_parameter (
      p_stud_ref_no         IN   stud.stud_ref_no%TYPE,
      p_stud_session_id     IN   stud_session.stud_session_id%TYPE,
      p_stud_crse_year_id   IN   stud_crse_year.stud_crse_year_id%TYPE,
      param_session_code    IN   stud_session.session_code%TYPE,
      param_mode_type       IN   VARCHAR2,
      param_scheme_type     IN   VARCHAR2
   )
      RETURN t_ed8_parameter
   IS
      v_ed8_parameter   t_ed8_parameter;
   BEGIN
      v_ed8_parameter.stud_ref_no := p_stud_ref_no;
      v_ed8_parameter.stud_session_id := p_stud_session_id;
      v_ed8_parameter.stud_crse_year_id := p_stud_crse_year_id;
      v_ed8_parameter.session_code := param_session_code;
      v_ed8_parameter.scheme_type := param_scheme_type;
      v_ed8_parameter.mode_type := param_mode_type;
      RETURN v_ed8_parameter;
   END pop_ed8_parameter;

   PROCEDURE get_shape (shape_id OUT NOCOPY NUMBER)
   IS
   BEGIN
      -- The current shape of the extract output
      -- This should be incremented when the content of the extracted is changed
      shape_id := 1;
   END get_shape;

   PROCEDURE build_line (
      p_stud_ref_no         IN              stud.stud_ref_no%TYPE,
      p_stud_session_id     IN              stud_session.stud_session_id%TYPE,
      p_stud_crse_year_id   IN              stud_crse_year.stud_crse_year_id%TYPE,
      param_session_code    IN              stud_session.session_code%TYPE,
      param_mode_type       IN              VARCHAR2,
      param_scheme_type     IN              VARCHAR2,
      report_line           OUT             VARCHAR2,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )
   IS
      v_ed8_parameter   t_ed8_parameter;
      v_ed8_output      t_ed8_output;
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := '';
      v_ed8_parameter :=
         pop_ed8_parameter (p_stud_ref_no,
                            p_stud_session_id,
                            p_stud_crse_year_id,
                            param_session_code,
                            param_mode_type,
                            param_scheme_type
                           );
      report_line := NULL;
      add_personal_details (v_ed8_parameter, v_ed8_output);
      report_line := report_line || v_ed8_output.report_line_fragment || '~';

      IF v_ed8_output.error_boolean = 'true'
      THEN
         error_boolean := v_ed8_output.error_boolean;
         ERROR_TEXT :=
                 ERROR_TEXT || '[PERSONAL:' || v_ed8_output.ERROR_TEXT || ']';
      END IF;

      add_dsa_details (v_ed8_parameter, v_ed8_output);
      report_line := report_line || v_ed8_output.report_line_fragment || '~';

      IF v_ed8_output.error_boolean = 'true'
      THEN
         error_boolean := v_ed8_output.error_boolean;
         ERROR_TEXT := ERROR_TEXT || '[DSA' || v_ed8_output.ERROR_TEXT || ']';
      END IF;

      add_application_details (v_ed8_parameter, v_ed8_output);
      report_line := report_line || v_ed8_output.report_line_fragment || '~';

      IF v_ed8_output.error_boolean = 'true'
      THEN
         error_boolean := v_ed8_output.error_boolean;
         ERROR_TEXT :=
               ERROR_TEXT || '[APPLICATION' || v_ed8_output.ERROR_TEXT || ']';
      END IF;

      add_course_details (v_ed8_parameter, v_ed8_output);
      report_line := report_line || v_ed8_output.report_line_fragment || '~';

      IF v_ed8_output.error_boolean = 'true'
      THEN
         error_boolean := v_ed8_output.error_boolean;
         ERROR_TEXT :=
                    ERROR_TEXT || '[COURSE' || v_ed8_output.ERROR_TEXT || ']';
      END IF;

      add_student_income_details (v_ed8_parameter, v_ed8_output);
      report_line := report_line || v_ed8_output.report_line_fragment || '~';

      IF v_ed8_output.error_boolean = 'true'
      THEN
         error_boolean := v_ed8_output.error_boolean;
         ERROR_TEXT :=
               ERROR_TEXT || '[STUD_INCOME' || v_ed8_output.ERROR_TEXT || ']';
      END IF;

      add_ben_income_details (v_ed8_parameter, v_ed8_output);
      report_line := report_line || v_ed8_output.report_line_fragment || '~';

      IF v_ed8_output.error_boolean = 'true'
      THEN
         error_boolean := v_ed8_output.error_boolean;
         ERROR_TEXT :=
                ERROR_TEXT || '[BEN_INCOME' || v_ed8_output.ERROR_TEXT || ']';
      END IF;

      add_bursary_grant_details (v_ed8_parameter, v_ed8_output);
      report_line := report_line || v_ed8_output.report_line_fragment || '~';

      IF v_ed8_output.error_boolean = 'true'
      THEN
         error_boolean := v_ed8_output.error_boolean;
         ERROR_TEXT :=
             ERROR_TEXT || '[BURSARY_GRANT' || v_ed8_output.ERROR_TEXT || ']';
      END IF;

      add_loan_details (v_ed8_parameter, v_ed8_output);
      report_line := report_line || v_ed8_output.report_line_fragment || '~';

      IF v_ed8_output.error_boolean = 'true'
      THEN
         error_boolean := v_ed8_output.error_boolean;
         ERROR_TEXT :=
                      ERROR_TEXT || '[LOAN' || v_ed8_output.ERROR_TEXT || ']';
      END IF;

      add_tuition_fee_details (v_ed8_parameter, v_ed8_output);
      report_line := report_line || v_ed8_output.report_line_fragment || '~';

      IF v_ed8_output.error_boolean = 'true'
      THEN
         error_boolean := v_ed8_output.error_boolean;
         ERROR_TEXT :=
               ERROR_TEXT || '[TUITION_FEE' || v_ed8_output.ERROR_TEXT || ']';
      END IF;

      add_study_abroad_details (v_ed8_parameter, v_ed8_output);
      report_line := report_line || v_ed8_output.report_line_fragment || '~';

      IF v_ed8_output.error_boolean = 'true'
      THEN
         error_boolean := v_ed8_output.error_boolean;
         ERROR_TEXT :=
              ERROR_TEXT || '[STUDY_ABROAD' || v_ed8_output.ERROR_TEXT || ']';
      END IF;

      add_dependants_details (v_ed8_parameter, v_ed8_output);
      report_line := report_line || v_ed8_output.report_line_fragment || '~';

      IF v_ed8_output.error_boolean = 'true'
      THEN
         error_boolean := v_ed8_output.error_boolean;
         ERROR_TEXT :=
                 ERROR_TEXT || '[DEPENDANT' || v_ed8_output.ERROR_TEXT || ']';
      END IF;
   END build_line;

   PROCEDURE add_personal_details (
      ed8_parameter   IN       t_ed8_parameter,
      ed8_output      OUT      t_ed8_output
   )
   IS
      v_personal_details   t_personal_details;
   BEGIN
      ed8_output.error_boolean := 'false';
      ed8_output.ERROR_TEXT := 'none';

      IF ed8_parameter.mode_type = 'P'
      THEN
         v_personal_details := get_personal_details (ed8_parameter);
         ed8_output.report_line_fragment :=
               v_personal_details.dob
            || '~'
            || v_personal_details.sex
            || '~'
            || v_personal_details.marital_status
            || '~'
            || v_personal_details.comp_jour
            || '~'
            || v_personal_details.post_code
            || '~'
            || v_personal_details.eu_flag
            || '~'
            || v_personal_details.ni_no
            || '~'
            || v_personal_details.withdraw_date
            || '~'
            || v_personal_details.earliest_start_term_date
            || '~'
            || v_personal_details.self_funding
            || '~'
            || v_personal_details.residence_country_code
            || '~'
            || v_personal_details.birth_country_code
            || '~'
            || v_personal_details.nation_country_code;
      ELSE
         BEGIN
            v_personal_details := get_personal_details (ed8_parameter);
            ed8_output.report_line_fragment := 'PERSONAL_DETAILS:PASS';
         EXCEPTION
            WHEN OTHERS
            THEN
               ed8_output.report_line_fragment := 'PERSONAL_DETAILS:FAIL';
         END;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ed8_output.error_boolean := 'true';
         ed8_output.ERROR_TEXT := DBMS_UTILITY.format_error_backtrace;
   END add_personal_details;

   PROCEDURE add_dsa_details (
      ed8_parameter   IN       t_ed8_parameter,
      ed8_output      OUT      t_ed8_output
   )
   IS
      v_dsa_details   t_dsa_details;
   BEGIN
      ed8_output.error_boolean := 'false';
      ed8_output.ERROR_TEXT := 'none';

      IF ed8_parameter.mode_type = 'P'
      THEN
         v_dsa_details := get_dsa_details (ed8_parameter);
         ed8_output.report_line_fragment :=
               v_dsa_details.disabled
            || '~'
            || v_dsa_details.descript
            || '~'
            || v_dsa_details.max_amount_a
            || '~'
            || v_dsa_details.paid_amount_a
            || '~'
            || v_dsa_details.available_amount_a
            || '~'
            || v_dsa_details.max_amount_b
            || '~'
            || v_dsa_details.paid_amount_b
            || '~'
            || v_dsa_details.available_amount_b
            || '~'
            || v_dsa_details.max_amount_c
            || '~'
            || v_dsa_details.paid_amount_c
            || '~'
            || v_dsa_details.available_amount_c
            || '~'
            || v_dsa_details.max_amount_d
            || '~'
            || v_dsa_details.paid_amount_d
            || '~'
            || v_dsa_details.available_amount_d;
      ELSE
         BEGIN
            v_dsa_details := get_dsa_details (ed8_parameter);
            ed8_output.report_line_fragment := 'DSA_DETAILS:PASS';
         EXCEPTION
            WHEN OTHERS
            THEN
               ed8_output.report_line_fragment := 'DSA_DETAILS:FAIL';
         END;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ed8_output.error_boolean := 'true';
         ed8_output.ERROR_TEXT := DBMS_UTILITY.format_error_backtrace;
   END add_dsa_details;

   PROCEDURE add_application_details (
      ed8_parameter   IN       t_ed8_parameter,
      ed8_output      OUT      t_ed8_output
   )
   IS
      v_application_details   t_application_details;
   BEGIN
      ed8_output.error_boolean := 'false';
      ed8_output.ERROR_TEXT := 'none';

      IF ed8_parameter.mode_type = 'P'
      THEN
         v_application_details := get_application_details (ed8_parameter);
         ed8_output.report_line_fragment :=
               v_application_details.application_status
            || '~'
            || v_application_details.date_applic_received
            || '~'
            || v_application_details.provisional_case
            || '~'
            || v_application_details.max_loan_requested
            || '~'
            || v_application_details.dearing;
      ELSE
         BEGIN
            v_application_details := get_application_details (ed8_parameter);
            ed8_output.report_line_fragment := 'APPLICATION_DETAILS:PASS';
         EXCEPTION
            WHEN OTHERS
            THEN
               ed8_output.report_line_fragment := 'APPLICATION_DETAILS:FAIL';
         END;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ed8_output.error_boolean := 'true';
         ed8_output.ERROR_TEXT := DBMS_UTILITY.format_error_backtrace;
   END add_application_details;

   PROCEDURE add_course_details (
      ed8_parameter   IN       t_ed8_parameter,
      ed8_output      OUT      t_ed8_output
   )
   IS
      v_course_details   t_course_details;
   BEGIN
      ed8_output.error_boolean := 'false';
      ed8_output.ERROR_TEXT := 'none';

      IF ed8_parameter.mode_type = 'P'
      THEN
         v_course_details := get_course_details (ed8_parameter);
         ed8_output.report_line_fragment :=
               v_course_details.inst_code
            || '~'
            || v_course_details.scheme_type
            || '~'
            || v_course_details.inst_type_id
            || '~'
            || v_course_details.location_ind
            || '~'
            || v_course_details.crse_code
            || '~'
            || v_course_details.crse_name
            || '~'
            || v_course_details.grad
            || '~'
            || v_course_details.crse_year_no
            || '~'
            || v_course_details.qual_type
            || '~'
            /*--CR499 M.Tolmie Sep 2018 : Add distance learning course flag*/
            || v_course_details.dl_course
            || '~'
            || v_course_details.pams_course
            || '~'
            || v_course_details.split_session
            || '~'
            || v_course_details.crse_type
            || '~'
            || v_course_details.no_terms
            || '~'
            || v_course_details.start_date
            || '~'
            || v_course_details.first_calc_date
            || '~'
            || v_course_details.pgce_ind
            || '~'
            --Graduate Apprentice COS 2021 - Clark Bolan
            || v_course_details.ga_student;
            
      ELSE
         BEGIN
            v_course_details := get_course_details (ed8_parameter);
            ed8_output.report_line_fragment := 'COURSE_DETAILS:PASS';
         EXCEPTION
            WHEN OTHERS
            THEN
               ed8_output.report_line_fragment := 'COURSE_DETAILS:FAIL';
         END;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ed8_output.error_boolean := 'true';
         ed8_output.ERROR_TEXT := DBMS_UTILITY.format_error_backtrace;
   END add_course_details;

   PROCEDURE add_student_income_details (
      ed8_parameter   IN       t_ed8_parameter,
      ed8_output      OUT      t_ed8_output
   )
   IS
      v_student_income_details   t_student_income_details;
   BEGIN
      ed8_output.error_boolean := 'false';
      ed8_output.ERROR_TEXT := 'none';

      IF ed8_parameter.mode_type = 'P'
      THEN
         v_student_income_details :=
                                   get_student_income_details (ed8_parameter);
         ed8_output.report_line_fragment :=
               v_student_income_details.inc_amount_none
            || '~'
            || v_student_income_details.inc_amount_benefits
            || '~'
            || v_student_income_details.inc_amount_wtc
            || '~'
            || v_student_income_details.inc_amount_trust
            || '~'
            || v_student_income_details.inc_amount_pension
            || '~'
            || v_student_income_details.inc_amount_prop
            || '~'
            || v_student_income_details.inc_amount_other;
      ELSE
         BEGIN
            v_student_income_details :=
                                   get_student_income_details (ed8_parameter);
            ed8_output.report_line_fragment := 'STUDENT_INCOME_DETAILS:PASS';
         EXCEPTION
            WHEN OTHERS
            THEN
               ed8_output.report_line_fragment :=
                                                'STUDENT_INCOME_DETAILS:FAIL';
         END;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ed8_output.error_boolean := 'true';
         ed8_output.ERROR_TEXT := DBMS_UTILITY.format_error_backtrace;
   END add_student_income_details;

   PROCEDURE add_ben_income_details (
      ed8_parameter   IN       t_ed8_parameter,
      ed8_output      OUT      t_ed8_output
   )
   IS
      v_ben_income_details   t_ben_income_details;
   BEGIN
      ed8_output.error_boolean := 'false';
      ed8_output.ERROR_TEXT := 'none';

      IF ed8_parameter.mode_type = 'P'
      THEN
         v_ben_income_details := get_ben_income_details (ed8_parameter);
         ed8_output.report_line_fragment :=
               v_ben_income_details.ben1_rel_id
            || '~'
            || v_ben_income_details.bank_interest1
            || '~'
            || v_ben_income_details.benefit1
            || '~'
            || v_ben_income_details.other_income1
            || '~'
            || v_ben_income_details.nat_saving_interest1
            || '~'
            || v_ben_income_details.paye_income1
            || '~'
            || v_ben_income_details.pension1
            || '~'
            || v_ben_income_details.self_employment1
            || '~'
            || v_ben_income_details.property1
            || '~'
            || v_ben_income_details.dividend1
            || '~'
            || v_ben_income_details.domestic1
            || '~'
            || v_ben_income_details.other_deduct1
            || '~'
            || v_ben_income_details.working_tax_credit1
            || '~'
            || v_ben_income_details.reason_no_income1
            || '~'
            || v_ben_income_details.ben2_rel_id
            || '~'
            || v_ben_income_details.bank_interest2
            || '~'
            || v_ben_income_details.benefit2
            || '~'
            || v_ben_income_details.other_income2
            || '~'
            || v_ben_income_details.nat_saving_interest2
            || '~'
            || v_ben_income_details.paye_income2
            || '~'
            || v_ben_income_details.pension2
            || '~'
            || v_ben_income_details.self_employment2
            || '~'
            || v_ben_income_details.property2
            || '~'
            || v_ben_income_details.dividend2
            || '~'
            || v_ben_income_details.domestic2
            || '~'
            || v_ben_income_details.other_deduct2
            || '~'
            || v_ben_income_details.working_tax_credit2
            || '~'
            || v_ben_income_details.reason_no_income2;
      ELSE
         BEGIN
            v_ben_income_details := get_ben_income_details (ed8_parameter);
            ed8_output.report_line_fragment := 'BEN_INCOME_DETAILS:PASS';
         EXCEPTION
            WHEN OTHERS
            THEN
               ed8_output.report_line_fragment := 'BEN_INCOME_DETAILS:FAIL';
         END;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ed8_output.error_boolean := 'true';
         ed8_output.ERROR_TEXT := DBMS_UTILITY.format_error_backtrace;
   END add_ben_income_details;

   PROCEDURE add_bursary_grant_details (
      ed8_parameter   IN       t_ed8_parameter,
      ed8_output      OUT      t_ed8_output
   )
   IS
      v_bursary_grant_details   t_bursary_grant_details;
   BEGIN
      ed8_output.error_boolean := 'false';
      ed8_output.ERROR_TEXT := 'none';

      IF ed8_parameter.mode_type = 'P'
      THEN
         v_bursary_grant_details := get_bursary_grant_details (ed8_parameter);
         ed8_output.report_line_fragment :=
               v_bursary_grant_details.isb_amount
            || '~'
            || v_bursary_grant_details.isb_net_amount
            || '~'
            || v_bursary_grant_details.isb_awi_net_amount
            || '~'
            || v_bursary_grant_details.isb_overpayment_amount
            || '~'
            || v_bursary_grant_details.isb_recovered_amount
            || '~'
            /*-- Estranged COS 2023 Project John Penman 13/12/2022--*/
            || v_bursary_grant_details.esb_amount
            || '~'
            || v_bursary_grant_details.esb_net_amount
            || '~'
            || v_bursary_grant_details.esb_awi_net_amount
            || '~'
            || v_bursary_grant_details.esb_overpayment_amount
            || '~'
            || v_bursary_grant_details.esb_recovered_amount
            || '~'
            || v_bursary_grant_details.ysb_amount
            || '~'
            || v_bursary_grant_details.ysb_net_amount
            || '~'
            || v_bursary_grant_details.ysb_awi_net_amount
            || '~'
            || v_bursary_grant_details.ysb_overpayment_amount
            || '~'
            || v_bursary_grant_details.ysb_recovered_amount
            || '~'
            /*--CR499 M.Tolmie Sep 2018 : CESB*/
            || v_bursary_grant_details.cesb_awarded
            || '~'
            || v_bursary_grant_details.cesb_net_amount
            || '~'
            || v_bursary_grant_details.cesb_awi_net_amount
            || '~'
            || v_bursary_grant_details.ugoa_snspa_amount
            || '~'
            || v_bursary_grant_details.ugoa_snspa_net_amount
            || '~'
            || v_bursary_grant_details.ugoa_snspa_awi_net_amount
            || '~'
            || v_bursary_grant_details.ugoa_snspa_opymnt_amount
            || '~'
            || v_bursary_grant_details.ugoa_snspa_recovered_amount
            || '~'
            || v_bursary_grant_details.sncap_amount
            || '~'
            || v_bursary_grant_details.sncap_net_amount
            || '~'
            || v_bursary_grant_details.sncap_awi_net_amount
            || '~'
            || v_bursary_grant_details.sncap_opymnt_amount
            || '~'
            || v_bursary_grant_details.sncap_recovered_amount
            || '~'
            || v_bursary_grant_details.snb_amount
            || '~'
            || v_bursary_grant_details.snb_net_amount
            || '~'
            || v_bursary_grant_details.snb_awi_net_amount
            || '~'
            || v_bursary_grant_details.snb_overpayment_amount
            || '~'
            || v_bursary_grant_details.snb_recovered_amount
            || '~'
            || v_bursary_grant_details.dsa_amount
            || '~'
            || v_bursary_grant_details.dsa_net_amount
            || '~'
            || v_bursary_grant_details.dsa_awi_net_amount
            || '~'
            || v_bursary_grant_details.dsa_overpayment_amount
            || '~'
            || v_bursary_grant_details.dsa_recovered_amount
            || '~'
            || v_bursary_grant_details.da_amount
            || '~'
            || v_bursary_grant_details.da_net_amount
            || '~'
            || v_bursary_grant_details.da_awi_net_amount
            || '~'
            || v_bursary_grant_details.da_overpayment_amount
            || '~'
            || v_bursary_grant_details.da_recovered_amount
            || '~'
            || v_bursary_grant_details.snpe_amount
            || '~'
            || v_bursary_grant_details.snpe_net_amount
            || '~'
            || v_bursary_grant_details.snpe_awi_net_amount
            || '~'
            || v_bursary_grant_details.snpe_overpayment_amount
            || '~'
            || v_bursary_grant_details.snpe_recovered_amount
            || '~'
            || v_bursary_grant_details.snie_amount
            || '~'
            || v_bursary_grant_details.snie_net_amount
            || '~'
            || v_bursary_grant_details.snie_awi_net_amount
            || '~'
            || v_bursary_grant_details.snie_overpayment_amount
            || '~'
            || v_bursary_grant_details.snie_recovered_amount
            || '~'
            || v_bursary_grant_details.adhoc_amount
            || '~'
            || v_bursary_grant_details.adhoc_type_f
            || '~'
            || v_bursary_grant_details.adhoc_type_a
            || '~'
            || v_bursary_grant_details.adhoc_type_o
            || '~'
            || v_bursary_grant_details.adhoc_type_e
            || '~'
            || v_bursary_grant_details.adhoc_type_r
            || '~'
            || v_bursary_grant_details.adhoc_type_t
            || '~'
            || v_bursary_grant_details.adhoc_type_p
            || '~'
            || v_bursary_grant_details.adhoc_type_v
            || '~'
            || v_bursary_grant_details.adhoc_type_l
            || '~'
            || v_bursary_grant_details.adhoc_type_i -- CR514 12/03/2019 John Penman
            || '~'
            || v_bursary_grant_details.adhoc_type_u -- CR514 12/03/2019 John Penman
            || '~'
            || v_bursary_grant_details.adhoc_type_n -- CR514 12/03/2019 John Penman
            || '~'
            || v_bursary_grant_details.adhoc_net_amount
            || '~'
            || v_bursary_grant_details.adhoc_awi_net_amount
            || '~'
            || v_bursary_grant_details.adhoc_overpayment_amount
            || '~'
            || v_bursary_grant_details.adhoc_recovered_amount
            || '~'
            || v_bursary_grant_details.edpy_grant_amount
            || '~'
            || v_bursary_grant_details.edpy_grant_net_amount
            || '~'
            || v_bursary_grant_details.edpy_grant_awi_net_amount
            || '~'
            || v_bursary_grant_details.edpy_grant_overpayment_amount
            || '~'
            || v_bursary_grant_details.edpy_grant_recovered_amount
            || '~'
            || v_bursary_grant_details.edpy_fees_amount
            || '~'
            || v_bursary_grant_details.edpy_fees_net_amount
            || '~'
            || v_bursary_grant_details.edpy_fees_awi_net_amount
            || '~'
            || v_bursary_grant_details.edpy_fees_overpayment_amount
            || '~'
            || v_bursary_grant_details.edpy_fees_recovered_amount
            || '~'
            || v_bursary_grant_details.edpy_phd_grant_amount
            || '~'
            || v_bursary_grant_details.edpy_phd_grant_net_amount
            || '~'
            || v_bursary_grant_details.edpy_phd_grant_awi_net_amount
            || '~'
            || v_bursary_grant_details.edpy_phd_grant_overpayment_amount
            || '~'
            || v_bursary_grant_details.edpy_phd_grant_recovered_amount
            || '~'
            || v_bursary_grant_details.edpy_phd_fees_amount
            || '~'
            || v_bursary_grant_details.edpy_phd_fees_net_amount
            || '~'
            || v_bursary_grant_details.edpy_phd_fees_awi_net_amount
            || '~'
            || v_bursary_grant_details.edpy_phd_fees_overpayment_amount
            || '~'
            || v_bursary_grant_details.edpy_phd_fees_recovered_amount
            || '~'			
            || v_bursary_grant_details.tot_amount
            || '~'
            || v_bursary_grant_details.tot_net_amount
            || '~'
            || v_bursary_grant_details.tot_awi_net_amount
            || '~'
            || v_bursary_grant_details.tot_overpayment_amount
            || '~'
            || v_bursary_grant_details.tot_recovered_amount;
      ELSE
         BEGIN
            v_bursary_grant_details :=
                                    get_bursary_grant_details (ed8_parameter);
            ed8_output.report_line_fragment := 'BURSARY_GRANT_DETAILS:PASS';
         EXCEPTION
            WHEN OTHERS
            THEN
               ed8_output.report_line_fragment :=
                                                 'BURSARY_GRANT_DETAILS:FAIL';
         END;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ed8_output.error_boolean := 'true';
         ed8_output.ERROR_TEXT := DBMS_UTILITY.format_error_backtrace;
   END add_bursary_grant_details;

   PROCEDURE add_loan_details (
      ed8_parameter   IN       t_ed8_parameter,
      ed8_output      OUT      t_ed8_output
   )
   IS
      v_loan_details   t_loan_details;
   BEGIN
      ed8_output.error_boolean := 'false';
      ed8_output.ERROR_TEXT := 'none';

      IF ed8_parameter.mode_type = 'P'
      THEN
         v_loan_details := get_loan_details (ed8_parameter);
         ed8_output.report_line_fragment :=
               v_loan_details.ugl_amount
            || '~'
            || v_loan_details.ugl_net_amount
            || '~'
            || v_loan_details.ugl_unclaimed_loan;
      ELSE
         BEGIN
            v_loan_details := get_loan_details (ed8_parameter);
            ed8_output.report_line_fragment := 'LOAN_DETAILS:PASS';
         EXCEPTION
            WHEN OTHERS
            THEN
               ed8_output.report_line_fragment := 'LOAN_DETAILS:FAIL';
         END;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ed8_output.error_boolean := 'true';
         ed8_output.ERROR_TEXT := DBMS_UTILITY.format_error_backtrace;
   END add_loan_details;

   PROCEDURE add_tuition_fee_details (
      ed8_parameter   IN       t_ed8_parameter,
      ed8_output      OUT      t_ed8_output
   )
   IS
      v_tuition_fee_details   t_tuition_fee_details;
   BEGIN
      ed8_output.error_boolean := 'false';
      ed8_output.ERROR_TEXT := 'none';

      IF ed8_parameter.mode_type = 'P'
      THEN
         v_tuition_fee_details := get_tuition_fee_details (ed8_parameter);
         ed8_output.report_line_fragment :=
               v_tuition_fee_details.fee_loan_declaration_date
            || '~'
            || v_tuition_fee_details.max_fee_loan_requested
            || '~'
            || v_tuition_fee_details.tuition_fee_type_code
            || '~'
            || v_tuition_fee_details.tf_amount
            || '~'
            || v_tuition_fee_details.tf_net_amount
            || '~'
            || v_tuition_fee_details.tf_awi_net_amount
            || '~'
            || v_tuition_fee_details.award_type_descript
            || '~'
            || v_tuition_fee_details.fl_amount
            || '~'
            || v_tuition_fee_details.fl_net_amount
            || '~'
            || v_tuition_fee_details.fl_awi_net_amount
            || '~'
            || v_tuition_fee_details.max_fee_loan;
      ELSE
         BEGIN
            v_tuition_fee_details := get_tuition_fee_details (ed8_parameter);
            ed8_output.report_line_fragment := 'TUITION_FEE_DETAILS:PASS';
         EXCEPTION
            WHEN OTHERS
            THEN
               ed8_output.report_line_fragment := 'TUITION_FEE_DETAILS:FAIL';
         END;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ed8_output.error_boolean := 'true';
         ed8_output.ERROR_TEXT := DBMS_UTILITY.format_error_backtrace;
   END add_tuition_fee_details;

   PROCEDURE add_study_abroad_details (
      ed8_parameter   IN       t_ed8_parameter,
      ed8_output      OUT      t_ed8_output
   )
   IS
      v_study_abroad_details   t_study_abroad_details;
   BEGIN
      ed8_output.error_boolean := 'false';
      ed8_output.ERROR_TEXT := 'none';

      IF ed8_parameter.mode_type = 'P'
      THEN
         v_study_abroad_details := get_study_abroad_details (ed8_parameter);
         ed8_output.report_line_fragment :=
               v_study_abroad_details.erasmus
            || '~'
            || v_study_abroad_details.study_abroad
            || '~'
            || v_study_abroad_details.study_country
            || '~'
            || v_study_abroad_details.start_date_abroad
            || '~'
            || v_study_abroad_details.end_date_abroad;
      ELSE
         BEGIN
            v_study_abroad_details :=
                                     get_study_abroad_details (ed8_parameter);
            ed8_output.report_line_fragment := 'STUDY_ABROAD_DETAILS:PASS';
         EXCEPTION
            WHEN OTHERS
            THEN
               ed8_output.report_line_fragment := 'STUDY_ABROAD_DETAILS:FAIL';
         END;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ed8_output.error_boolean := 'true';
         ed8_output.ERROR_TEXT := DBMS_UTILITY.format_error_backtrace;
   END add_study_abroad_details;

   PROCEDURE add_dependants_details (
      ed8_parameter   IN       t_ed8_parameter,
      ed8_output      OUT      t_ed8_output
   )
   IS
      v_dependants_details   t_dependants_details;
   BEGIN
      ed8_output.error_boolean := 'false';
      ed8_output.ERROR_TEXT := 'none';

      IF ed8_parameter.mode_type = 'P'
      THEN
         v_dependants_details := get_dependants_details (ed8_parameter);
         ed8_output.report_line_fragment :=
               v_dependants_details.stud_dependants_count
            || '~'
            || v_dependants_details.dep1_age
            || '~'
            || v_dependants_details.dep1_rel_type
            || '~'
            || v_dependants_details.dep2_age
            || '~'
            || v_dependants_details.dep2_rel_type
            || '~'
            || v_dependants_details.dep3_age
            || '~'
            || v_dependants_details.dep3_rel_type
            || '~'
            || v_dependants_details.dep4_age
            || '~'
            || v_dependants_details.dep4_rel_type
            || '~'
            || v_dependants_details.dep5_age
            || '~'
            || v_dependants_details.dep5_rel_type
            || '~'
            || v_dependants_details.dep6_age
            || '~'
            || v_dependants_details.dep6_rel_type
            || '~'
            || v_dependants_details.dep7_age
            || '~'
            || v_dependants_details.dep7_rel_type
            || '~'
            || v_dependants_details.dep8_age
            || '~'
            || v_dependants_details.dep8_rel_type
            || '~'
            || v_dependants_details.dep9_age
            || '~'
            || v_dependants_details.dep9_rel_type
            || '~'
            || v_dependants_details.dep10_age
            || '~'
            || v_dependants_details.dep10_rel_type;
      ELSE
         BEGIN
            v_dependants_details := get_dependants_details (ed8_parameter);
            ed8_output.report_line_fragment := 'DEPENDANTS_DETAILS:PASS';
         EXCEPTION
            WHEN OTHERS
            THEN
               ed8_output.report_line_fragment := 'DEPENDANTS_DETAILS:FAIL';
         END;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ed8_output.error_boolean := 'true';
         ed8_output.ERROR_TEXT := DBMS_UTILITY.format_error_backtrace;
   END add_dependants_details;
END ed8_content;
/
