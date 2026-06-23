CREATE OR REPLACE PACKAGE BODY SGAS.PK_AWARD_NOTIFICATION AS
/******************************************************************************
   NAME:       PK_AWARD_NOTIFICATION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        14/08/2009  A.Anchev         1. Created this package body.
   1.1        28/10/2009  P.Hughes         2. New Functions get_parentspouse_contrib and get_stud_ssnPrint
   1.2        06/11/2009  P.Hughes         3. getREMmark2 updated
   1.3        10/11/2009  P.Hughes         4. Multiple New functions
   1.4        23/11/2009  P.Hughes         5. NVL Rem13value to 0 as causing null pointed exception when nulls returned in java server
   1.5        06/12/2009  P.Hughes         6. Fix to get_student_contibution to return stud_cont figure in ELSE statement
   1.6        11/12/2009  P.Hughes         7. LoanForFees Amount corrected as was previously subtracting FeeLoans in error
   1.7        15/12/2009  P.Hughes         8. Tuition Fees Stud Amended so it will only display for RUK B and RUK G.
   1.8        15/12/2009  P.Hughes         9. get_stud_ssnPrint Amended to include FeeLoan Types.
   1.9        18/01/2010  P.Hughes         10.  Updated SSNPrint Function to print SLC number for both loan and fee types when value is greater than 0.
   2.0        26/02/2010  P.Hughes         11.  Payment Location service fixed to remove p_returned = Y and p_recalc = Y is not required
   2.1        10/03/2010  P.Hughes         12.  Added fix supplied by Adrian Bowman for get_award_payments so payments on same day are summed together.
   2.2        12/10/2010  P.Hughes         13.  Added new Function fee_records_exist in conjunction with remarks 8 and 9.
   2.3        13/10/2010  P.Hughes  J.Penman 14. Modified  get_stud_fees_stud to retrieve the total amount of fees from the Award table directly
   2.4        28/03/2011  P.Hughes          15.  Marked as final version for live.
   2.5        01/04/2011  P.Hughes          16.  Fixed line 159 Error missing condition to only select stud_crse_year_id.
   2.6        05/04/2011  P.Hughes          17.  Fixed DSA from appearing on the Award letters.
   2.7        08/04/2011  P.Hughes          18.  Fix Overpayment Recovered Amount
   2.8        09/12/2011  P.Hughes          19.  Fix when overpaid contribution exists for get_an_award_data
******************************************************************************/


FUNCTION getOverPaymentRecordedAmount(p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS

    l_result NUMBER;
    
    BEGIN
    
        SELECT NVL(SUM(RECOVERED_AMOUNT),0)
        INTO l_result
        FROM AWARD
        WHERE STUD_CRSE_YEAR_ID = p_stud_crse_year_id;
        
    RETURN l_result;
    
END getOverPaymentRecordedAmount;



  /*
   * 
   */
   ---THIS SERVICE DETERMINES IF ANY FEE RECORDS EXIST FOR THE STUDENT AND RETURNS 'Y' IF THEY DO AND 'N' IF THEY DONT
  FUNCTION fee_records_exist(p_stud_crse_year_id IN NUMBER) RETURN CHAR
  IS
  p_fee_record_exist    CHAR(1);
  
  BEGIN
  
        SELECT DISTINCT 'Y'
        INTO p_fee_record_exist
        FROM AWARD
        WHERE STUD_CRSE_YEAR_ID = p_stud_crse_year_id
        AND AWARD_SRC = 'T'
        ;
        
        RETURN p_fee_record_exist;
        
  END fee_records_exist;
  

  FUNCTION get_stud_fees_saas(p_stud_crse_year_id IN NUMBER) RETURN NUMBER 
  IS
    p_tuition_fees_saas         NUMBER := 0; 
  BEGIN
  
     SELECT NVL(SUM(a.net_amount),0)
     INTO p_tuition_fees_saas
     FROM AWARD a
     WHERE stud_crse_year_id = p_stud_crse_year_id
     AND   a.stud_award_type = 'FEES'
     AND   a.award_src = 'T';
     
     RETURN p_tuition_fees_saas;
  END get_stud_fees_saas;
  
  --TUITION FEES ?0 show comment for RUK B and RUK G students only -- See Point 25 of Functional Specification
  FUNCTION show_fees_saas_ruk(p_stud_crse_year_id IN NUMBER) RETURN CHAR
  IS
    p_fees_saas_ruk         CHAR := 'N';
    v_rowsreturned          NUMBER := 0;
    
    BEGIN
    

            select count(A.award_id)
            INTO v_rowsreturned
            from vu_award_notification_award a, vu_award_notification_stud b
            where a.stud_crse_year_id = b.stud_crse_year_id
            and b.dearing IN('B','E')
            and b.award <> 'E'
            and a.loan_non_loan_fee <> 'fee'
            and a.stud_crse_year_id = p_stud_crse_year_id;
            
            CASE WHEN v_rowsreturned > 0
                THEN p_fees_saas_ruk := 'Y';
            ELSE p_fees_saas_ruk := 'N';
            END CASE;
                    
    RETURN p_fees_saas_ruk;
    
    END show_fees_saas_ruk;
            

  /*
   * FUNCTIONAL SPECIFICATION REFERENCE - 25.  TUITION FEES YOU WILL PAY TO YOUR COLLEGE OR UNIVERSITY
   */
  FUNCTION get_stud_fees_stud(p_stud_crse_year_id IN NUMBER) RETURN NUMBER 
  IS
    p_tuition_fees_stud         NUMBER := 0; 
    
  BEGIN
  
    SELECT NVL(SUM(a.contrib_amount + a.recovered_amount),0)
    INTO p_tuition_fees_stud
    FROM AWARD a, stud_crse_year b
    WHERE a.stud_crse_year_id = b.stud_crse_year_id
    AND a.STUD_CRSE_YEAR_ID = p_stud_crse_year_id
    AND a.award_src = 'T'
    AND a.stud_award_type = 'FEES'
    AND b.dearing IN('B','E');


     RETURN p_tuition_fees_stud;
  END get_stud_fees_stud;
  
  
    FUNCTION get_stud_fees_studBE(p_stud_crse_year_id IN NUMBER) RETURN NUMBER 
  IS
    p_tuition_fees_studbe         NUMBER := 0; 
  BEGIN
    SELECT NVL( SUM(a.tuition_fees_stud), 0 )
      INTO p_tuition_fees_studbe
      FROM vu_award_notification_award a, vu_award_notification_stud b
     WHERE a.stud_crse_year_id = p_stud_crse_year_id
     AND b.dearing IN('B','E');
     
     RETURN p_tuition_fees_studbe;
  END get_stud_fees_studBE;

  /*
   * 
   */
  FUNCTION get_stud_loan_for_fees(p_stud_crse_year_id IN NUMBER) RETURN NUMBER 
  IS
    p_loan_for_fees             NUMBER := 0; 
  BEGIN
  
     SELECT NVL(SUM(a.net_amount),0)
     INTO p_loan_for_fees
     FROM AWARD a, STUD_CRSE_YEAR b
     WHERE a.stud_crse_year_id = b.stud_crse_year_id
     AND a.stud_crse_year_id = p_stud_crse_year_id
     AND a.stud_award_type = 'TFEL'
     AND b.dearing = 'G';
     
     RETURN p_loan_for_fees;
  END get_stud_loan_for_fees;
  
  
/* Formatted on 2009/11/10 13:30 (Formatter Plus v4.8.8) */
FUNCTION get_stud_loan_displayzero (p_stud_crse_year_id IN NUMBER)
   RETURN CHAR
IS
   p_loan_for_display1       NUMBER   := 0;
   p_loan_for_display2       NUMBER   := 0;
   p_loan_for_fees_display   CHAR (1) := 'N';
BEGIN
   SELECT COUNT (a.stud_crse_year_id)
     INTO p_loan_for_display1
     FROM vu_award_notification_award a, vu_award_notification_stud b
    WHERE a.stud_crse_year_id = b.stud_crse_year_id
     AND a.stud_crse_year_id = p_stud_crse_year_id
      AND b.dearing = 'G'
      AND a.loan_non_loan_fee <> 'fee'
      AND a.award_src = 'T'
      AND a.award_id IN (SELECT c.award_id
                           FROM award_instalment c
                          WHERE NVL (c.fee_loan_instalment, 'N') = 'Y');

   SELECT COUNT (a.stud_crse_year_id)
     INTO p_loan_for_display2
     FROM vu_award_notification_award a, vu_award_notification_stud b,
          award c
    WHERE a.stud_crse_year_id = b.stud_crse_year_id
      AND a.stud_crse_year_id = p_stud_crse_year_id
      AND a.award_id = a.award_id
      AND b.dearing = 'G'
      AND a.loan_non_loan_fee = 'fee'
      AND c.net_amount = 0
      AND a.award_src = 'T'
      AND a.award_id IN (SELECT c.award_id
                           FROM award_instalment c
                          WHERE NVL (c.fee_loan_instalment, 'N') = 'Y');

   CASE
      WHEN (p_loan_for_display2 > 0 OR p_loan_for_display1 > 0)
      THEN
         p_loan_for_fees_display := 'Y';
      ELSE
         p_loan_for_fees_display := 'N';
   END CASE;

   RETURN p_loan_for_fees_display;
END get_stud_loan_displayzero;
  
 
  
  
  
  
  FUNCTION get_loan_for_living_costs(p_stud_crse_year_id IN NUMBER) RETURN NUMBER
  IS
    p_loan_for_living_costs     NUMBER :=0;
  BEGIN
  
       SELECT NVL(SUM(a.net_amount),0)
       INTO p_loan_for_living_costs
       FROM AWARD a, STUD_AWARD_TYPE b
       WHERE a.stud_award_type = b.stud_award_type
       AND a.stud_crse_year_id = p_stud_crse_year_id
       AND b.loan_non_loan_fee = 'Loan';
       
       RETURN p_loan_for_living_costs;
       
  END get_loan_for_living_costs;
  
  /*
   * 
   */
  FUNCTION get_stud_loan_amount(p_stud_crse_year_id IN NUMBER) RETURN NUMBER 
  IS
    p_total_loan_amount         NUMBER := 0; 
  BEGIN
  
       SELECT NVL(SUM(a.net_amount),0)
       INTO p_total_loan_amount
       FROM AWARD a, STUD_AWARD_TYPE b
       WHERE a.stud_award_type = b.stud_award_type
       AND a.stud_crse_year_id = p_stud_crse_year_id
       AND b.loan_non_loan_fee = 'Loan';
     
     RETURN p_total_loan_amount; -- get_stud_loan_for_fees(p_stud_crse_year_id);
  END get_stud_loan_amount;
  
  /*
   * 
   */
   
   
  FUNCTION get_stud_total(p_stud_crse_year_id IN NUMBER) RETURN NUMBER 
  IS
    p_total_amount              NUMBER := 0; 
    p_awaiting_return           NUMBER := 0;
    p_total                     NUMBER := 0;
    
  BEGIN

            SELECT NVL(SUM(a.net_amount),0)
            INTO p_total
            FROM AWARD a, STUD_AWARD_TYPE b
            WHERE a.stud_award_type = b.stud_award_type
            AND a.stud_crse_year_id = p_stud_crse_year_id
            AND a.award_src = 'A'
            AND loan_non_loan_fee <> 'fee'
            AND b.type NOT IN('DSA','TRAV','PAY','MAN')
            AND b.stud_award_type <> 'ADHOC';
  

     SELECT NVL(SUM(ai.net_amount),0)
     INTO p_awaiting_return
     FROM AWARD a, AWARD_INSTALMENT ai, STUD_AWARD_TYPE c
     WHERE a.award_id = ai.award_id 
     AND a.stud_award_type = c.stud_award_type
     AND a.stud_crse_year_id = p_stud_crse_year_id
     AND a.award_src = 'A'
     AND c.type NOT IN('DSA','TRAV','PAY','MAN')
     AND c.stud_award_type <> 'ADHOC'
     AND ai.returned = 'A';
     
     
     p_total_amount := p_total - p_awaiting_return;
     
     
     RETURN p_total_amount;
  END get_stud_total;
  
  
  --THIS FUNCTION DETERMINES IF WE SHOULD PRINT PARENTAL/SPOUSE CONTRIBUTION ON AWARD LETTER
  --THIS WILL RETURN 'S' if SPOUSE, 'P' if Parental and 'N' if not to be displayed.
  FUNCTION get_parentspouse_contib(p_stud_crse_year_id IN NUMBER) RETURN CHAR
  IS
    p_printParentalSpouse   CHAR := 'N';
    l_scheme_type           CHAR := 'N';
    p_awards                NUMBER := 0;
    p_parent_cont           NUMBER := 0;
    p_spouse_cont           NUMBER := 0;
    p_resid_par_cont        NUMBER := 0;
    p_parental_contribution NUMBER := 0;
    p_spouse_contibution    NUMBER :=0;
    
    
  BEGIN
  
    SELECT s.scheme_type, s.parent_cont, s.spouse_cont, s.resid_par_cont, get_stud_total(p_stud_crse_year_id)
        INTO l_scheme_type, p_parent_cont, p_spouse_cont, p_resid_par_cont, p_awards
        FROM VU_AWARD_NOTIFICATION_STUD s
        WHERE s.stud_crse_year_id = p_stud_crse_year_id;
    
         p_parental_contribution := p_parent_cont - p_resid_par_cont;
         p_spouse_contibution := p_spouse_cont - p_resid_par_cont;
         
         CASE 
            WHEN l_scheme_type = 'B' OR p_awards = 0 
                THEN p_printParentalSpouse := 'N';  
            WHEN p_parental_contribution > 0 AND l_scheme_type <> 'B' AND p_awards > 0
                THEN p_printParentalSpouse := 'P';
            WHEN p_spouse_contibution > 0 AND l_scheme_type <> 'B' AND p_awards > 0
                THEN p_printParentalSpouse := 'S';
            ELSE p_printParentalSpouse := 'N';
         END CASE;
    
    RETURN p_printParentalSpouse;
    
 END get_parentspouse_contib;
     

  FUNCTION get_stud_ssnPrint(p_stud_crse_year_id IN NUMBER) RETURN CHAR
  IS
    p_print_heading             CHAR := 'N';
    l_scheme_type               CHAR := 'N';
    l_get_loan_for_living_costs NUMBER:= 0;
    l_loan_fees                 NUMBER:= 0;
    
  BEGIN
       SELECT s.scheme_type, get_loan_for_living_costs(p_stud_crse_year_id), get_stud_loan_for_fees(p_stud_crse_year_id)
       INTO l_scheme_type, l_get_loan_for_living_costs, l_loan_fees
       FROM VU_AWARD_NOTIFICATION_STUD s
       WHERE s.stud_crse_year_id = p_stud_crse_year_id;
       
       IF   l_get_loan_for_living_costs >= 0 OR l_loan_fees >= 0 THEN
            p_print_heading := 'Y';
            
       ELSE p_print_heading := 'N';
       
       END IF;
       
  RETURN p_print_heading;
  
  END get_stud_ssnPrint;
  
  
  FUNCTION get_student_contibution(p_stud_crse_year_id IN NUMBER) RETURN NUMBER
  IS
        p_student_contrib       NUMBER := 0;
        p_resid_par_cont        NUMBER := 0;
        l_scheme_type           CHAR := 'N';
        
  BEGIN
        
        SELECT stud_cont, resid_par_cont, scheme_type
        INTO p_student_contrib, p_resid_par_cont, l_scheme_type
        FROM VU_AWARD_NOTIFICATION_STUD s
        WHERE s.stud_crse_year_id = p_stud_crse_year_id;
        
        CASE 
            WHEN l_scheme_type = 'B'  
                THEN p_student_contrib := 0;  
            WHEN get_parentspouse_contib(p_stud_crse_year_id) = 'N' AND l_scheme_type <> 'B'
                THEN p_student_contrib  := p_student_contrib - p_resid_par_cont;
            ELSE p_student_contrib := p_student_contrib;-- := 0;
         END CASE; 
         
     RETURN p_student_contrib;
     
 END get_student_contibution;
 
/* Formatted on 2009/10/29 16:01 (Formatter Plus v4.8.8) */
FUNCTION get_remark1 (p_stud_crse_year_id IN NUMBER)
   RETURN CHAR
IS
   b1_income_status CHAR := 'F';
   b2_income_status CHAR := 'F';
   l_rem1           CHAR := 'N';
   
BEGIN
   SELECT NVL (b.income_status, 'F'), d.rem1
     INTO b1_income_status, l_rem1
     FROM stud_session a,
          benefactor_income b,
          stud_crse_year c,
          vu_award_notification_stud d
    WHERE a.ben1_id = ben_id(+)
      AND c.latest_crse_ind = 'Y'
      AND a.stud_session_id = c.stud_session_id
      AND b.session_code = a.session_code
      AND c.stud_crse_year_id = d.stud_crse_year_id
      AND d.stud_crse_year_id = p_stud_crse_year_id;

   SELECT NVL (b.income_status, 'F')
     INTO b2_income_status
     FROM stud_session a,
          benefactor_income b,
          stud_crse_year c,
          vu_award_notification_stud d
    WHERE a.ben2_id = ben_id(+)
      AND c.latest_crse_ind = 'Y'
      AND a.stud_session_id = c.stud_session_id
      AND b.session_code = a.session_code
      AND c.stud_crse_year_id = d.stud_crse_year_id
      AND d.stud_crse_year_id = p_stud_crse_year_id;

   CASE
      WHEN ((b1_income_status = 'P' OR b2_income_status = 'P') AND (l_rem1 = 'Y'))
      THEN
         l_rem1 := 'Y';
      ELSE
         l_rem1 := 'N';
   END CASE;

   RETURN l_rem1;
END get_remark1;

FUNCTION get_remark2 (p_stud_crse_year_id IN NUMBER)
    RETURN CHAR
IS
    b1_qa_recieved              CHAR := 'N';
    l_rem2                      CHAR := 'N';
    b2_qa_recieved              CHAR := 'N';
    l_session_code              NUMBER := 0;
    l_stud_ref_no               NUMBER := 0;
    l_prevcaseexist             CHAR := 'N';

BEGIN

     SELECT A.STUD_REF_NO, NVL(D.qa_received,'N'), E.REM2, a.session_code
      INTO l_stud_ref_no, b1_qa_recieved, l_rem2, l_session_code
      FROM STUD_SESSION A, STUD_CRSE_YEAR B, BENEFACTOR_INCOME D, VU_AWARD_NOTIFICATION_STUD E
      WHERE A.STUD_SESSION_ID = B.STUD_SESSION_ID
      AND E.STUD_CRSE_YEAR_ID = B.STUD_CRSE_YEAR_ID
      AND a.session_code = d.session_code
      AND B.latest_crse_ind = 'Y'
      AND A.BEN1_ID = D.BEN_ID(+)
      AND E.STUD_CRSE_YEAR_ID = p_stud_crse_year_id;  
      
      SELECT A.STUD_REF_NO, NVL(D.qa_received,'N')
      INTO l_stud_ref_no, b2_qa_recieved
      FROM STUD_SESSION A, STUD_CRSE_YEAR B, BENEFACTOR_INCOME D, VU_AWARD_NOTIFICATION_STUD E
      WHERE A.STUD_SESSION_ID = B.STUD_SESSION_ID
      AND E.STUD_CRSE_YEAR_ID = B.STUD_CRSE_YEAR_ID
      AND a.session_code = d.session_code
      AND B.latest_crse_ind = 'Y'
      AND A.BEN2_ID = D.BEN_ID(+)  
      AND E.STUD_CRSE_YEAR_ID = p_stud_crse_year_id;   
      
      
      IF l_session_code <= STEPS_RELEASE_YEAR
      
         THEN
         
        SELECT CASE 
             WHEN B.DEARING NOT IN('B','C','D','E','F','G','N') AND (C.BEN1_ID IS NULL AND C.BEN2_ID IS NULL)
             THEN 'N'
             WHEN B.DEARING IN('B','C','D','E','F','G','N') AND (C.BEN1_ID IS NOT NULL OR C.BEN2_ID IS NOT NULL)
             THEN 'Y'
             ELSE 'N'
             END PREVRECORDEXIST        
      INTO l_prevcaseexist             
      FROM STUD A, STUD_CRSE_YEAR@GRASS B, STUD_SESSION@GRASS C
      WHERE A.STUD_REF_NO = B.STUD_REF_NO(+)   
      AND B.STUD_SESSION_ID = C.STUD_SESSION_ID(+)
      AND B.LATEST_CRSE_IND(+) = 'Y'
      AND B.PROVISIONAL_CASE(+) = 'N'
      AND B.APPLICATION_STATUS(+) = 'C'
      AND B.SESSION_CODE(+) = l_session_code - 1
      AND A.STUD_REF_NO(+) = l_stud_ref_no;
         
      ELSE 
        SELECT CASE 
             WHEN B.DEARING NOT IN('B','C','D','E','F','G','N') AND (C.BEN1_ID IS NULL AND C.BEN2_ID IS NULL)
             THEN 'N'
             WHEN B.DEARING IN('B','C','D','E','F','G','N') AND (C.BEN1_ID IS NOT NULL OR C.BEN2_ID IS NOT NULL)
             THEN 'Y'
             ELSE 'N'
             END PREVRECORDEXIST  
      INTO l_prevcaseexist                      
      FROM STUD A, STUD_CRSE_YEAR B, STUD_SESSION C
      WHERE A.STUD_REF_NO = B.STUD_REF_NO(+)   
      AND B.STUD_SESSION_ID = C.STUD_SESSION_ID(+)
      AND B.LATEST_CRSE_IND(+) = 'Y'
      AND B.PROVISIONAL_CASE(+) = 'N'
      AND B.APPLICATION_STATUS(+) = 'C'
      AND B.SESSION_CODE(+) = l_session_code - 1
      AND A.STUD_REF_NO(+) = l_stud_ref_no;

      
      END IF;
      
      CASE 
        WHEN l_rem2 = 'Y' AND l_prevcaseexist = 'Y' AND (b1_qa_recieved = 'N' OR b2_qa_recieved = 'N')
           THEN l_rem2 := 'Y';
        ELSE l_rem2 := 'N';
        END CASE;
        
        
     RETURN l_rem2;
     
END get_remark2;

/* Formatted on 2009/10/31 11:28 (Formatter Plus v4.8.8) */
FUNCTION get_remark8 (p_stud_crse_year_id IN NUMBER)
   RETURN CHAR
IS
   l_rem8     CHAR (1):= 'N';
   l_fee      CHAR (1);
   l_nonfee   NUMBER  := 0;
BEGIN
   l_nonfee := get_stud_total (p_stud_crse_year_id);
   l_fee := fee_records_exist(p_stud_crse_year_id);

   SELECT rem8
     INTO l_rem8
     FROM vu_award_notification_stud s
    WHERE stud_crse_year_id = p_stud_crse_year_id;

   CASE
      WHEN l_rem8 = 'Y' AND l_fee = 'Y' AND l_nonfee > 0
      THEN
         l_rem8 := 'Y';
      ELSE
         l_rem8 := 'N';
   END CASE;

   RETURN l_rem8;
END get_remark8;

FUNCTION get_remark9 (p_stud_crse_year_id IN NUMBER)
   RETURN CHAR
IS
   l_rem9     CHAR (1):= 'N';
   l_fee      CHAR (1);
   l_nonfee   NUMBER  := 0;
BEGIN
   l_nonfee := get_stud_total (p_stud_crse_year_id);
    l_fee := fee_records_exist(p_stud_crse_year_id);

   SELECT rem9
     INTO l_rem9
     FROM vu_award_notification_stud s
    WHERE stud_crse_year_id = p_stud_crse_year_id;

   CASE
      WHEN l_rem9 = 'Y' AND l_fee = 'Y' AND l_nonfee > 0
      THEN
         l_rem9 := 'Y';
      ELSE
         l_rem9 := 'N';
   END CASE;

   RETURN l_rem9;
END get_remark9;

FUNCTION get_remark13 (p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS
        l_rem13         CHAR(1) := 'N';
        l_studloan      NUMBER  := 0;
BEGIN
        l_studloan := get_stud_loan_amount (p_stud_crse_year_id);
        
        CASE
            WHEN l_studloan > 0
            THEN l_rem13 := 'Y';
        ELSE l_rem13 := 'N';
        END CASE;
        
        RETURN l_rem13;
END get_remark13;

FUNCTION get_rem13Value (p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS
        l_result        NUMBER := 0;
        
BEGIN
        
      SELECT SUM(NVL(b.net_amount,0) + NVL(b.unclaimed_loan,0)) AS amount
      INTO l_result
      FROM vu_award_notification_award a, award b
      WHERE a.stud_award_type = b.stud_award_type
      AND a.stud_crse_year_id = b.stud_crse_year_id
      AND a.stud_crse_year_id = p_stud_crse_year_id
      AND a.loan_non_loan_fee = 'Loan';
       
      RETURN l_result;

END get_rem13Value;


FUNCTION get_remark (p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS
        l_result        CHAR(500);
        
BEGIN
        
      SELECT b.remark
      INTO l_result
      FROM vu_award_notification_stud a, stud_crse_year b 
      WHERE a.stud_crse_year_id = b.stud_crse_year_id
      AND a.stud_crse_year_id = p_stud_crse_year_id;
       
      RETURN l_result;

END get_remark;

  /*
   * 
   */
  FUNCTION build_pay_location_string(
    p_method        IN VARCHAR2, 
    p_payee_type    IN VARCHAR2, 
    p_acc_no        IN VARCHAR2, 
    p_sort_code     IN VARCHAR2,
    p_build_soc_no  IN VARCHAR2,
    p_pay_addr      IN VARCHAR2,
    p_pay_status    IN VARCHAR2,
    p_returned      IN VARCHAR2,
    p_recalc        IN VARCHAR2,
    p_campus        IN VARCHAR2) RETURN VARCHAR2
  IS
    p_payment_location          VARCHAR2(256) := '';
  BEGIN
     IF p_method IS NOT NULL THEN
       IF p_method = 'B' THEN 
         p_payment_location := p_payment_location || 'BACS to ';
         
         IF p_payee_type IS NOT NULL AND p_payee_type = 'S' THEN
           IF p_build_soc_no IS NOT NULL THEN
              p_payment_location := p_payment_location  || 
                                    p_sort_code         || 
                                    ', '                || 
                                    p_build_soc_no;
           ELSIF p_acc_no IS NOT NULL THEN
              p_payment_location := p_payment_location  || 
                                    p_sort_code         || 
                                    ', '                || 
                                    p_acc_no;
           END IF;
         END IF;
       ELSIF p_method = 'C' THEN
         p_payment_location := p_payment_location || 'Cheque to';
         
         IF p_payee_type = 'S' THEN
           IF p_pay_addr = 'C' AND p_pay_status != 'R' THEN
           
        --   AND 
        --      p_returned = 'Y' AND p_recalc = 'Y' THEN
                -- Payable order to Campus
                p_payment_location := p_payment_location || p_campus;
                
           ELSIF p_pay_addr = 'H' AND p_pay_status != 'R' THEN 
              --   p_returned = 'Y' AND p_recalc = 'Y' THEN
                -- Payable order to Home address    
                p_payment_location := p_payment_location || ' your home address';
                
           ELSIF p_pay_addr = 'T' AND p_pay_status != 'R' THEN 
              --   p_returned = 'Y' AND p_recalc = 'Y' THEN
                -- Payable order to Term address    
                p_payment_location := p_payment_location || ' your term address';
                                                    
           END IF;
         ELSIF p_payee_type = 'N' THEN
           -- Payable order to Nominee
           p_payment_location := p_payment_location || ' your nominee';
         END IF;
       END IF;
     END IF;
     RETURN p_payment_location;
  END build_pay_location_string;
  
  
  /* Formatted on 2009/11/09 16:19 (Formatter Plus v4.8.8) */
FUNCTION show_award_instalments (p_stud_crse_year_id IN NUMBER)
   RETURN CHAR
IS
   v_unpaid              NUMBER := 0;
   v_paid                NUMBER := 0;
   v_total               NUMBER := 0;
   v_show_grantbursary   CHAR   := 'N';
BEGIN

   SELECT NVL(SUM (sum_net_amount),0)
     INTO v_unpaid
     FROM vu_award_notification_paid
    WHERE show_on_an_payments = 'Y'
          AND stud_crse_year_id = p_stud_crse_year_id;

   SELECT NVL(SUM (sum_net_amount),0)
     INTO v_paid
     FROM vu_award_notification_unpaid
    WHERE show_on_an_payments = 'Y'
          AND stud_crse_year_id = p_stud_crse_year_id;

   v_total := v_paid + v_unpaid;


   CASE
      WHEN v_total > 0
      THEN
         v_show_grantbursary := 'Y';
      ELSE
         v_show_grantbursary := 'N';
   END CASE;

   RETURN v_show_grantbursary;
   
END show_award_instalments;

  /*
   * 
   */
  PROCEDURE get_an_student_data(p_students OUT an_students_cursor) IS
    c_students    an_students_cursor;
  BEGIN
    OPEN c_students FOR
        SELECT s.stud_crse_year_id                          AS stud_crse_year_id,
               s.stud_ref_no                                AS stud_ref_no,  
               s.session_code                               AS session_code, 
               s.crse_year_no                               AS course_year_no,
               CONCAT('SAAS',s.slc_ref_number)              AS ssn, 
               sgas.pk_award_notification.get_stud_ssnPrint(s.stud_crse_year_id)       AS ssnPrint,
               NVL(s.out_uk,'N')                            AS out_uk,
               s.title                                      AS title, 
               s.forenames                                  AS first_name, 
               s.surname                                    AS last_name,
               s.inst_code                                  AS inst_code,
               s.inst_name                                  AS inst_name,
               s.crse_name                                  AS crse_name,
             --  s.account_no                                 AS accountno,       
                CASE
                    WHEN s.account_no IS NULL
                        THEN null
                    ELSE concat('****',substr(s.account_no, 5,4))                                       
                END   accountno,
               s.sort_code                                  AS sortcode,
               s.house_no_name                              AS address_line1,
               s.address_line1                              AS address_line2, 
               s.address_line2                              AS address_line3, 
               s.address_line3                              AS address_line4,
               s.address_line4                              AS address_line5, 
               s.post_code                                  AS address_line6,
               null                                         AS mailsort,
               s.dearing                                    AS dearing,
               DECODE(s.scheme_type, 'B', 'Y', 'N')         AS nmsb_flag,
               sgas.pk_award_notification.show_award_instalments(stud_crse_year_id)  AS showgrantbursary,
               s.parent_cont - resid_par_cont               AS parent_contrib,
               s.spouse_cont - resid_spouse_cont            AS partner_contrib,
               sgas.pk_award_notification.get_student_contibution(stud_crse_year_id)   AS student_contrib,
               sgas.pk_award_notification.getOverPaymentRecordedAmount(s.stud_crse_year_id) AS overpayment_recovered,
               s.resid_par_cont                             AS resid_par_contrib,
               s.resid_stud_cont                            AS resid_stud_contrib,
               s.resid_stud_cont + s.resid_par_cont         AS rem8total,          
               s.tot_ja_studs_reg                           AS jastudrequested,
               NVL(s.overpayment,0)                         AS overpayment,
               NVL(s.snb_overpayment,0)                     AS snboverpayment,
               sgas.pk_award_notification.get_parentspouse_contib(stud_crse_year_id)   AS parentspouse_contrib,
               DECODE(sgas.pk_award_notification.get_stud_loan_amount(
                         s.stud_crse_year_id),
                         0, 'N', 'Y')                       AS loan_flag,
               sgas.pk_award_notification.get_stud_fees_saas(s.stud_crse_year_id)      AS tuition_fees_saas,
               sgas.pk_award_notification.show_fees_saas_ruk(s.stud_crse_year_id)      AS tuitionFeesSAASRUK,
               sgas.pk_award_notification.get_stud_fees_stud(s.stud_crse_year_id)      AS tuition_fees_stud, 
               sgas.pk_award_notification.get_stud_fees_studBE(s.stud_crse_year_id)    AS tuition_fees_studBE,
               sgas.pk_award_notification.get_stud_loan_for_fees(s.stud_crse_year_id)  AS loan_for_fees_amt,
               sgas.pk_award_notification.get_stud_loan_displayzero(s.stud_crse_year_id) AS loan_for_fees_display,
               sgas.pk_award_notification.get_stud_loan_amount(s.stud_crse_year_id)    AS loan_amount,               
               sgas.pk_award_notification.get_stud_total(s.stud_crse_year_id)          AS total,
               NVL(s.req_dup, 'N')                          AS req_dup, 
               S.EMP_LOGIN_NAME                             AS caseworkerName,
               NVL(sgas.pk_award_notification.get_rem13Value(s.stud_crse_year_id),0)   AS rem13value,
               sgas.pk_steps_award_letter.get_remark1(s.stud_crse_year_id)             AS rem1, 
               sgas.pk_steps_award_letter.get_remark2(s.stud_crse_year_id)             AS rem2,  
               s.rem3,  s.rem4,
               s.rem5, s.rem6,  s.rem7,  
               sgas.pk_award_notification.get_remark8(s.stud_crse_year_id)             AS rem8,
               sgas.pk_award_notification.get_remark9(s.stud_crse_year_id)             AS rem9, 
               s.rem10, s.rem11, s.rem12,
               sgas.pk_award_notification.get_remark13 (s.stud_crse_year_id)           AS rem13,
               sgas.pk_award_notification.get_remark(s.stud_crse_year_id)              AS comments
             --  s.rem14                          
          FROM VU_AWARD_NOTIFICATION_STUD s;
          
          

    p_students := c_students;
     
  END get_an_student_data;
   
  /*
   * 
   */
  PROCEDURE get_an_award_data (
      p_stud_crse_year_id     IN VARCHAR2,
      p_stud_awards           OUT an_stud_awards_cursor)
  IS
    c_stud_awards       an_stud_awards_cursor;
  BEGIN
    OPEN c_stud_awards FOR
        SELECT sa.award_id                                  AS award_id,  
               sa.stud_award_type                           AS award_type, 
               sa.award_type_descript                       AS award_type_desc,
               sa.net_amount + NVL(sa.overpaid_contrib,0)   AS amount,
                CASE
                     WHEN sat.loan_non_loan_fee = 'Loan'
                        THEN 'Y'
                     WHEN sat.loan_non_loan_fee = 'fee'
                        THEN 'F'
                     ELSE 'N'
                  END AS is_loan,
                sat.show_on_an_payments
          FROM AWARD sa, stud_award_type sat
         WHERE sa.stud_crse_year_id = p_stud_crse_year_id
         AND sa.stud_award_type = sat.stud_award_type
         AND sat.type NOT IN('DSA','TRAV','PAY','MAN');
         
    p_stud_awards := c_stud_awards;
    
  END get_an_award_data;
  
  /*
   * 
   */
  PROCEDURE get_an_award_payments (
      p_stud_crse_year_id       IN VARCHAR2, 
      p_award_payments          OUT an_award_payments_cursor)
  IS
    c_award_payments    an_award_payments_cursor;
  BEGIN
    OPEN c_award_payments FOR
    
    /*
    
     R Hunter Amended for defect #221 Ordered results by payment date 2009/11/01 13:36 
SELECT   to_date(payment_date,'DD/MM/YYYY') AS payment_date, SUM (pay_amount) pay_amount, pay_location
    FROM (SELECT   payment_date, pay_amount, pay_location
              FROM (SELECT 1 AS ord, (apu.payment_due_date) AS payment_date,
                           apu.sum_net_amount AS pay_amount,
                           sgas.pk_award_notification.build_pay_location_string
                                   (apu.method,
                                    apu.payee,
                                    DECODE (apu.payee,
                                            'S', CASE
                                                    WHEN apu.stud_acc_no IS NULL
                                                    THEN NULL
                                                 ELSE concat('****',substr(apu.stud_acc_no,5,4))
                                                 END,
                                            CASE
                                                WHEN apu.camp_acc_no IS NULL
                                                THEN NULL
                                                ELSE concat('****',substr(apu.camp_acc_no,5,4))
                                                END
                                           ),
                                    DECODE (apu.payee,
                                            'S', apu.stud_sort,
                                            apu.camp_sort
                                           ),
                                    NULL,
                                    apu.payment_addr,
                                    apu.payment_status,
                                    apu.returned,
                                    apu.recalc,
                                    apu.campus_name
                                   ) AS pay_location
                      FROM vu_award_notification_unpaid apu, award a, stud_award_type b
                     WHERE apu.stud_crse_year_id = p_stud_crse_year_id
                       AND apu.stud_crse_year_id = a.stud_crse_year_id
                       AND a.stud_award_type = b.stud_award_type
                       AND b.type NOT IN('DSA','MAN','TRAV')
                       AND apu.loan_non_loan_fee <> 'fee'
                    UNION ALL
                    SELECT 0 AS ord, (app.dpp_payment_date) AS payment_date,
                           app.sum_net_amount AS pay_amount,
                           sgas.pk_award_notification.build_pay_location_string
                               (app.method,
                                app.payee,
                                app.dpp_payee_bank_account,
                                app.dpp_payee_bank_sort_code,
                                app.dpp_build_soc_roll_no,
                                app.payment_addr,
                                app.payment_status,
                                app.returned,
                                app.recalc,
                                'PAID CAMPUS'
                               ) AS pay_location
                      FROM vu_award_notification_paid app, award a, stud_award_type b
                     WHERE app.stud_crse_year_id = p_stud_crse_year_id
                      AND apu.stud_crse_year_id = a.stud_crse_year_id
                       AND a.stud_award_type = b.stud_award_type
                       AND b.type NOT IN('DSA','MAN','TRAV')
                       AND app.loan_non_loan_fee <> 'fee')
          ORDER BY ord ASC)
GROUP BY payment_date, pay_location
ORDER BY payment_date ASC;
    p_award_payments := c_award_payments;
    
    */
    
    SELECT payment_date, pay_amount, pay_location
FROM(
SELECT   to_date(payment_date,'DD/MM/YYYY') AS payment_date, SUM (pay_amount) pay_amount, pay_location
    FROM (SELECT   payment_date, pay_amount, pay_location
              FROM (SELECT 1 AS ord, (b.payment_due_date) AS payment_date,
                           b.net_amount AS pay_amount,
                           sgas.pk_steps_award_letter.build_pay_location_string
                                   (b.method,
                                    b.payee, concat('****',substr(d.account_no,5,4)), d.sort_code,
                                    NULL,
                                    b.payment_addr,
                                    b.payment_status,
                                    b.returned,
                                    b.recalc,
                                    b.campus_id
                                   ) AS pay_location
                      FROM award a, award_instalment b, stud_award_type c, stud d
                     WHERE a.stud_crse_year_id = p_stud_crse_year_id
                       AND c.loan_non_loan_fee <> 'fee'
                       AND c.type NOT IN('DSA','MAN','TRAV')
                       AND a.award_id = b.award_id
                       AND a.stud_ref_no = d.stud_ref_no
                       AND a.stud_award_type = c.stud_award_type
                       AND b.payment_status = 'U'      
                       AND b.returned = 'N'   
                    UNION ALL
                    SELECT 0 AS ord, (b.payment_due_date) AS payment_date,
                           b.net_amount AS pay_amount,
                           sgas.pk_steps_award_letter.build_pay_location_string
                               (b.method,
                                b.payee,
                                concat('****',substr(d.account_no,5,4)),
                                d.sort_code,
                                NULL,
                                b.payment_addr,
                                b.payment_status,
                                b.returned,
                                b.recalc,
                                'PAID CAMPUS'
                               ) AS pay_location
                                            FROM award a, award_instalment b, stud_award_type c, stud d
                     WHERE a.stud_crse_year_id = p_stud_crse_year_id
                       AND c.loan_non_loan_fee <> 'fee'
                       AND c.type NOT IN('DSA','MAN','TRAV')
                       AND a.award_id = b.award_id
                       AND a.stud_ref_no = d.stud_ref_no
                       AND a.stud_award_type = c.stud_award_type
                       AND b.payment_status = 'S'
                       AND b.returned = 'N')
          ORDER BY ord ASC)  
GROUP BY payment_date, pay_location
ORDER BY payment_date ASC)
WHERE pay_amount > 0;
    p_award_payments := c_award_payments;
        
  END get_an_award_payments;
  
  /*
   * 
   */
  PROCEDURE set_an_sent(p_stud_crse_year_id IN VARCHAR2)
  IS     
  BEGIN
    UPDATE stud_crse_year
       SET sal_sent = 'Y',
           sal_sent_date = SYSDATE,
           award_letter_no = award_letter_no + 1,
           req_dup = NULL
       --  also reset duplicates counter when a column becomes available
     WHERE stud_crse_year_id = p_stud_crse_year_id;
  END set_an_sent;
  
  /*
   * 
   */
  PROCEDURE set_an_dup_req(p_stud_crse_year_id IN VARCHAR2)
  IS     
  BEGIN
    UPDATE stud_crse_year
       SET sal_sent = 'N',
           sal_sent_date = NULL,
           req_dup = 'Y'           
     WHERE stud_crse_year_id = p_stud_crse_year_id
     AND application_status = 'C';
     
  END set_an_dup_req;


  PROCEDURE set_an_dup_sent(p_stud_crse_year_id IN VARCHAR2)
  IS     
  BEGIN
    UPDATE stud_crse_year
       SET req_dup = 'N'
       --  also increment duplicates counter when a column becomes available           
     WHERE stud_crse_year_id = p_stud_crse_year_id;
  END set_an_dup_sent;
  
END PK_AWARD_NOTIFICATION;
/
