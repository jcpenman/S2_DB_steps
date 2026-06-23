CREATE OR REPLACE PACKAGE BODY SGAS.award_screen
AS
/******************************************************************************
   NAME:       AWARD_SCREEN
   PURPOSE:    To supply the rules engine with the variables it needs to output
                the display values for the UI award screen

   REVISIONS:
   Ver          Date              Author              Description
   ---------  ----------    ---------------     ------------------------------------
   1.0        13/04/2011        CB               1. Created this package.
******************************************************************************/
   FUNCTION does_stud_dep_exist (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR
   IS
      l_count    NUMBER;
      l_result   CHAR;
   BEGIN
      SELECT COUNT (*)
        INTO l_count
        FROM stud_dependant a, stud_crse_year b
       WHERE a.stud_session_id = b.stud_session_id
         AND b.stud_crse_year_id = p_stud_crse_year_id;

      IF l_count > 0
      THEN
         l_result := 'Y';
      ELSE
         l_result := 'N';
      END IF;

      RETURN l_result;
   END does_stud_dep_exist;

   FUNCTION is_there_a_spouse (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR
   IS
      l_dep_count   NUMBER;
      l_result      CHAR;
   BEGIN
      SELECT COUNT (a.std_id)
        INTO l_dep_count
        FROM stud_dependant a, stud_crse_year b
       WHERE a.stud_session_id = b.stud_session_id
         AND b.stud_crse_year_id = p_stud_crse_year_id
         AND a.relation_id = 48;

      IF l_dep_count > 0
      THEN
         l_result := 'Y';
      ELSE
         l_result := 'N';
      END IF;

      RETURN l_result;
   END is_there_a_spouse;
   
   FUNCTION does_spouse_have_child (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR
   IS
      l_result      CHAR;
      l_dep         CHAR;
      l_dep_count   NUMBER;
   BEGIN
   
   l_dep := SGAS.AWARD_SCREEN.IS_THERE_A_SPOUSE(p_stud_crse_year_id);
   
   SELECT COUNT (a.std_id)
        INTO l_dep_count
        FROM stud_dependant a, stud_crse_year b
       WHERE a.stud_session_id = b.stud_session_id
         AND b.stud_crse_year_id = p_stud_crse_year_id
         AND a.relation_id IN (46, 47, 510, 511, 601, 602, 603);
         
         IF (l_dep = 'Y' AND l_dep_count > 0)
         THEN
            l_result := 'Y';
         ELSE
            l_result := 'N';
         END IF;
         
         RETURN l_result;
         
   
   END does_spouse_have_child;  

   FUNCTION benefactor_with_income (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR
   IS
      l_ben1_id           NUMBER;
      l_ben2_id           NUMBER;
      l_stud_session_id   NUMBER;
      l_income            NUMBER;
      l_result            CHAR;
   BEGIN
      SELECT stud_session_id
        INTO l_stud_session_id
        FROM stud_crse_year
       WHERE stud_crse_year_id = p_stud_crse_year_id;

      SELECT ben1_id, ben2_id
        INTO l_ben1_id, l_ben2_id
        FROM stud_session
       WHERE stud_session_id = l_stud_session_id;

      l_income := sgas.rules_proc_recalc.get_ben_income (p_stud_crse_year_id);

      IF (l_ben1_id IS NOT NULL OR l_ben2_id IS NOT NULL) AND l_income >= 0
      THEN
         l_result := 'Y';
      ELSE
         l_result := 'N';
      END IF;

      RETURN l_result;
   END benefactor_with_income;
 
--the function below return a Y if all mandatory fields are present for LPCG to be calculated, this enables the checkbox on the award screen, otherwise return  N 
   FUNCTION lpcg_mandatory_fields (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR
   IS
      l_max_lpcg        CHAR;
      l_lpcg_req        NUMBER;
      l_childcare_num   VARCHAR2(100);
      l_childcare_name  VARCHAR2(600);
      l_result          CHAR;
   BEGIN
   
      SELECT NVL(a.CHILD_CARE_NAME, '0'), NVL(a.child_care_no, '0'), NVL(a.lpcg_paid_amount, '0'), NVL(a.max_lpcg_paid, 'N')
      INTO  l_childcare_name, l_childcare_num, l_lpcg_req, l_max_lpcg
      FROM stud_session a, stud_crse_year b 
      WHERE a.stud_session_id = B.STUD_SESSION_ID
      AND B.STUD_CRSE_YEAR_ID = p_stud_crse_year_id;
      
      CASE
      WHEN (l_max_lpcg = 'N' AND l_lpcg_req = '0')
      THEN l_result := 'N';
      WHEN ((l_max_lpcg <> 'N' OR l_lpcg_req <> '0') AND (l_childcare_name = '0' AND l_childcare_num = '0'))
      THEN l_result := 'N';
      WHEN ((l_max_lpcg <> 'N' OR l_lpcg_req <> '0') AND (l_childcare_name <> '0' AND l_childcare_num = '0'))
      THEN l_result := 'N';
      WHEN ((l_max_lpcg <> 'N' OR l_lpcg_req <> '0') AND (l_childcare_name = '0' AND l_childcare_num <> '0'))
      THEN l_result := 'N';
      WHEN ((l_max_lpcg <> 'N' OR l_lpcg_req <> '0') AND (l_childcare_name <> '0' AND l_childcare_num <> '0'))
      THEN l_result := 'Y';  
      END CASE;
      
     
      RETURN l_result;
   END lpcg_mandatory_fields;
      
    FUNCTION NMT_only (p_stud_crse_year_id IN NUMBER)
        RETURN CHAR
    IS
        l_result            CHAR;
        l_ben1_id           NUMBER;
        l_ben2_id           NUMBER;
        l_stud_session_id   NUMBER;
        l_award             CHAR;
        l_exempt            CHAR;
        
    BEGIN
    
        SELECT stud_session_id, parent_contrib_exempt, award
        INTO l_stud_session_id, l_exempt, l_award
        FROM stud_crse_year
       WHERE stud_crse_year_id = p_stud_crse_year_id;

      SELECT ben1_id, ben2_id
        INTO l_ben1_id, l_ben2_id
        FROM stud_session
       WHERE stud_session_id = l_stud_session_id;
       
       IF ((l_ben1_id IS NULL and l_ben2_id IS NULL and l_exempt = 'N') or (l_award = 'C' or l_award = 'D'))
       THEN
            l_result := 'Y';
       ELSE
            l_result := 'N';
       END IF;
       
       RETURN l_result;
       
   END NMT_only;    

   PROCEDURE awardscreenvalues_doc (
      p_stud_crse_year_id   IN       NUMBER,
      p_awardscreen_type    IN OUT   awardscreen_type_cursor
   )
   IS
   BEGIN
      OPEN p_awardscreen_type FOR
         SELECT scy.inst_code, scy.inst_name, scy.crse_code, scy.crse_name,
                scy.crse_year_no, scy.crse_year_id, scy.crse_id,
                scy.scheme_type, scy.dearing, scy.fee_loan_given,
                scy.loan_given, crs.pams_course, cy.eu_flag,
                ss.lpcg_paid_amount, ss.max_lpcg_paid,
                sgas.award_screen.does_stud_dep_exist
                                           (p_stud_crse_year_id)
                                                               AS dep_exists,
                sgas.award_screen.is_there_a_spouse
                                      (p_stud_crse_year_id)
                                                          AS is_dep_a_spouse,
                scy.paid_sandwich, scy.pay_ysb,
                sgas.award_screen.benefactor_with_income
                                (p_stud_crse_year_id)
                                                    AS is_there_a_benefactor,
                scy.parent_contrib_exempt, scy.award, inst.location_ind,
                sgas.award_screen.lpcg_mandatory_fields (p_stud_crse_year_id)
                                                    AS lpcg_mandatory_fields,
                sgas.award_screen.does_spouse_have_child (p_stud_crse_year_id)
                                                    AS spouse_with_child,
                sgas.award_screen.NMT_only(p_stud_crse_year_id) AS NMT_only,
                scy.session_code,
                scy.psas_non_fee_loan
           FROM stud_crse_year scy,
                stud_session ss,
                stud st,
                crse@grass crs,
                crse_session@grass crss,
                crse_year@grass cy,
                inst@grass inst
          WHERE scy.stud_crse_year_id = p_stud_crse_year_id
            AND st.stud_ref_no = scy.stud_ref_no
            AND scy.crse_year_id = cy.crse_year_id
            AND cy.crse_session_id = crss.crse_session_id
            AND crss.crse_id = crs.crse_id
            AND crs.inst_code = inst.inst_code
            AND scy.stud_crse_year_id = p_stud_crse_year_id
            AND ss.stud_session_id = scy.stud_session_id
            AND crss.crse_id = crs.crse_id
            AND cy.crse_session_id = crss.crse_session_id
            AND scy.crse_year_id = cy.crse_year_id;
   END awardscreenvalues_doc;
END award_screen;
/
