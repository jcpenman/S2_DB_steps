CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_AWARD_LETTER AS 
/******************************************************************************
   NAME:       PK_STEPS_AWARD_LETTER
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/04/2011    Paul hughes     Initial Creation CR89
   1.1        09/12/2011    Paul Hughes     Fix to award letter when overpaid contribution exists
   1.2        02/05/2012    Paul Hughes     Fee Loan and Fee condition amended to include SCHEME_TYPE <> 'B'
   1.3       14/01/2014     Clark Bolan    add STUD_SESSION.max_loan_requested change for COS 2104 
   1.4       24/04/2014    Clark Bolan     Change rem11 to match spec on the back of defect64 StEPSDefects Project
   1.5       29/08/2016    John Penman    Added extra condition (AND st.deceased_flag = 'N') in procedure get_an_student_data for CR (Death of a Student)   
   1.6      01/11/2016     Clark Bolan   get_an_student_data updated to include CESB award types
   1.7      07/12/2018      Ranj Benning     get_an_student_data updated to include PG Education Psychology types 
   1.8        29/10/2019  James Baird     Removed the @GRASS for course and institution tables.
******************************************************************************/


---FUNCTION FOR REMARK 6 PARMS OUTSIDE SCOTLAND
FUNCTION getPAMSOutsideScotland(p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS
    l_result    CHAR;
    l_count     NUMBER;
    
    BEGIN
    
        SELECT COUNT(*)
        INTO l_count
        FROM STUD_CRSE_YEAR scy, crse_year cy, crse c, inst i
        WHERE scy.crse_year_id = cy.crse_year_id
        AND cy.crse_id = c.crse_id
        AND scy.inst_code = i.inst_code
        AND scy.stud_crse_year_id = p_stud_crse_year_id
        AND i.location_ind <> 1
        AND c.pams_course = 'Y';
        
        IF l_count = 0
            THEN l_result := 'N';
            ELSE l_result := 'Y';
        END IF;
        
        RETURN l_result;
        
 END getPAMSOutsideScotland;


   ---THIS SERVICE DETERMINES IF ANY FEE RECORDS EXIST FOR THE STUDENT AND RETURNS 'Y' IF THEY DO AND 'N' IF THEY DONT
  FUNCTION fee_records_exist(p_stud_crse_year_id IN NUMBER) RETURN CHAR
  IS
  p_fee_record_exist    CHAR;
  l_count               NUMBER;
  
  BEGIN
  
        SELECT COUNT(*)
        INTO l_count
        FROM AWARD a, STUD_CRSE_YEAR b
        WHERE a.STUD_CRSE_YEAR_ID = p_stud_crse_year_id
        AND a.stud_crse_year_id = b.stud_crse_year_id  -------------WHAT ABOUT IF THIS IS FEE LOAN????
        AND AWARD_SRC = 'T';
        
        IF l_count > 0
            THEN p_fee_record_exist := 'Y';
            ELSE p_fee_record_exist := 'N';
        END IF;
        
        RETURN p_fee_record_exist;
        
  END fee_records_exist;
  

  FUNCTION get_stud_fees_saas(p_stud_crse_year_id IN NUMBER) RETURN NUMBER 
  IS
    p_tuition_fees_saas         NUMBER := 0; 
  BEGIN
      
     SELECT NVL(SUM(a.net_amount),0)
     INTO p_tuition_fees_saas
     FROM AWARD a, stud_crse_year b
     WHERE a.stud_crse_year_id = p_stud_crse_year_id
     AND   a.stud_crse_year_id = b.stud_crse_year_id
     AND   a.stud_award_type IN('FEES','GAFEE')
     AND   b.scheme_type <> 'B'
     AND   a.award_src = 'T';
     
     
     RETURN p_tuition_fees_saas;
     
  END get_stud_fees_saas;
  
  
    FUNCTION get_stud_fees_nmsb(p_stud_crse_year_id IN NUMBER) RETURN NUMBER 
  IS
    p_tuition_fees_nmsb         NUMBER := 0; 
  BEGIN
      
     SELECT NVL(SUM(a.net_amount),0)
     INTO p_tuition_fees_nmsb
     FROM AWARD a, stud_crse_year b
     WHERE a.stud_crse_year_id = p_stud_crse_year_id
     AND   a.stud_crse_year_id = b.stud_crse_year_id
     AND   a.stud_award_type = 'SNFEE'
     AND   b.scheme_type = 'B';
     
     RETURN p_tuition_fees_nmsb;
     
  END get_stud_fees_nmsb;

  
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
     AND a.award_src = 'T'
     AND b.scheme_type <> 'B';
     
     
     RETURN p_loan_for_fees;
  END get_stud_loan_for_fees;
    
  
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
       
     RETURN p_total_loan_amount; 
     
  END get_stud_loan_amount;
  
   
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
  
  
     

  FUNCTION get_stud_ssnPrint(p_stud_crse_year_id IN NUMBER) RETURN CHAR
  IS
    p_print_heading             CHAR := 'N';
    l_scheme_type               CHAR := 'N';
    l_get_loan_for_living_costs NUMBER:= 0;
    l_loan_fees                 NUMBER:= 0;
    
  BEGIN
  
       SELECT s.scheme_type, get_stud_loan_amount(p_stud_crse_year_id), get_stud_loan_for_fees(p_stud_crse_year_id)
       INTO l_scheme_type, l_get_loan_for_living_costs, l_loan_fees
       FROM STUD_CRSE_YEAR s
       WHERE s.stud_crse_year_id = p_stud_crse_year_id;
       
       IF   l_get_loan_for_living_costs >= 0 OR l_loan_fees >= 0 THEN
            p_print_heading := 'Y';
            
       ELSE p_print_heading := 'N';
       
       END IF;
       
  RETURN p_print_heading;
  
  END get_stud_ssnPrint;
  
 
FUNCTION remark2_prev_session_exist(p_stud_crse_year_id IN NUMBER)
    RETURN CHAR
IS
    l_result        CHAR;
    l_stud_ref_no   NUMBER;
    l_session_code  NUMBER;
    l_count         NUMBER;
    l_count_bens    NUMBER;
    ben1_income     CHAR;
    ben2_income     CHAR;
    
BEGIN


        SELECT stud_ref_no, session_code
        INTO l_stud_ref_no, l_session_code
        FROM STUD_CRSE_YEAR scy
        WHERE scy.stud_crse_year_id = p_stud_crse_year_id;
        
        IF l_session_code > STEPS_RELEASE_YEAR
            THEN
        
                    SELECT COUNT(*)
                    INTO l_count
                    FROM STUD_CRSE_YEAR
                    WHERE STUD_REF_NO = l_stud_ref_no
                    AND SESSION_CODE = l_session_code - 1
                    AND LATEST_CRSE_IND = 'Y'
                    AND PROVISIONAL_CASE = 'N'
                    AND APPLICATION_STATUS = 'C';
                    
             ELSE 
             
                    SELECT COUNT(*)
                    INTO l_count
                    FROM STUD_CRSE_YEAR@grass
                    WHERE STUD_REF_NO = l_stud_ref_no
                    AND SESSION_CODE = l_session_code - 1
                    AND LATEST_CRSE_IND = 'Y'
                    AND PROVISIONAL_CASE = 'N'
                    AND APPLICATION_STATUS = 'C';
                    
             END IF;
        
        IF l_count > 0
            THEN 
                ---MEANS WE NEED TO CHECK THAT THE BENEFACTOR INCOME STATUS IS FINAL FOR BOTH BENEFACTORS
                
                IF l_session_code > STEPS_RELEASE_YEAR
                            THEN
                                    SELECT CASE
                                    WHEN ss.BEN1_ID IS NULL AND ss.BEN2_ID IS NULL
                                        THEN 0
                                    WHEN ss.BEN1_ID IS NOT NULL AND ss.BEN2_ID IS NULL
                                        THEN 1
                                    WHEN ss.BEN1_ID IS NOT NULL AND ss.BEN2_ID IS NOT NULL
                                        THEN 2
                                    ELSE 0
                                    END count
                                    INTO l_count_bens
                                    FROM STUD_SESSION ss
                                    WHERE ss.session_code = l_session_code - 1
                                    AND ss.stud_ref_no = l_stud_ref_no;
                                    
                                    CASE
                                        WHEN l_count_bens = 0
                                        THEN l_result := 'N';
                                        WHEN l_count_bens = 1
                                        THEN  
                                                SELECT NVL(INCOME_STATUS,'P') 
                                                INTO ben1_income
                                                FROM BENEFACTOR_INCOME bi, STUD_SESSION ss
                                                WHERE ss.ben1_id = bi.ben_id
                                                AND ss.session_code = l_session_code - 1
                                                AND bi.session_code = l_session_code - 1
                                                AND ss.stud_ref_no = l_stud_ref_no;
                                                
                                                IF ben1_income = 'F'
                                                    THEN l_result := 'Y';
                                                ELSE l_result := 'N';
                                                END IF;
             
                                                      --FUTHER CHECKING TO SEE INCOME STATUS OF BENEFACTOR
                                        WHEN l_count_bens = 2
                                            THEN
                                                SELECT NVL(INCOME_STATUS,'P') 
                                                INTO ben1_income
                                                FROM BENEFACTOR_INCOME bi, STUD_SESSION ss
                                                WHERE ss.ben1_id = bi.ben_id
                                                AND ss.session_code = l_session_code - 1
                                                AND bi.session_code = l_session_code - 1
                                                AND ss.stud_ref_no = l_stud_ref_no;
                                                
                                                SELECT NVL(INCOME_STATUS,'P') 
                                                INTO ben2_income
                                                FROM BENEFACTOR_INCOME bi, STUD_SESSION ss
                                                WHERE ss.ben2_id = bi.ben_id
                                                AND ss.session_code = l_session_code - 1
                                                AND bi.session_code = l_session_code - 1
                                                AND ss.stud_ref_no = l_stud_ref_no;
                                                
                                                IF ben1_income = 'F' and ben2_income = 'F'
                                                    THEN l_result := 'Y';
                                                ELSE l_result := 'N';
                                                END IF;
                                                
                                               
                                    END CASE;
                        
                        
                ELSE ---REPEAT FOR GRASS
                                              SELECT CASE
                        WHEN ss.BEN1_ID IS NULL AND ss.BEN2_ID IS NULL
                            THEN 0
                        WHEN ss.BEN1_ID IS NOT NULL AND ss.BEN2_ID IS NULL
                            THEN 1
                        WHEN ss.BEN1_ID IS NOT NULL AND ss.BEN2_ID IS NOT NULL
                            THEN 2
                        ELSE 0
                        END count
                        INTO l_count_bens
                        FROM STUD_SESSION@grass ss
                        WHERE ss.session_code = l_session_code - 1
                        AND ss.stud_ref_no = l_stud_ref_no;
                        
                        CASE
                            WHEN l_count_bens = 0
                            THEN l_result := 'N';
                            WHEN l_count_bens = 1
                            THEN  
                                    SELECT NVL(INCOME_STATUS,'P') 
                                    INTO ben1_income
                                    FROM BENEFACTOR_INCOME@grass bi, STUD_SESSION@grass ss
                                    WHERE ss.ben1_id = bi.ben_id
                                    AND ss.session_code = l_session_code - 1
                                    AND bi.session_code = l_session_code - 1
                                    AND ss.stud_ref_no = l_stud_ref_no;
                                    
                                    IF ben1_income = 'F'
                                        THEN l_result := 'Y';
                                    ELSE l_result := 'N';
                                    END IF;
 
                                          --FUTHER CHECKING TO SEE INCOME STATUS OF BENEFACTOR
                            WHEN l_count_bens = 2
                                THEN
                                    SELECT NVL(INCOME_STATUS,'P') 
                                    INTO ben1_income
                                    FROM BENEFACTOR_INCOME@grass bi, STUD_SESSION@grass ss
                                    WHERE ss.ben1_id = bi.ben_id
                                    AND ss.session_code = l_session_code - 1
                                    AND bi.session_code = l_session_code - 1
                                    AND ss.stud_ref_no = l_stud_ref_no;
                                    
                                    SELECT NVL(INCOME_STATUS,'P') 
                                    INTO ben2_income
                                    FROM BENEFACTOR_INCOME@grass bi, STUD_SESSION@grass ss
                                    WHERE ss.ben2_id = bi.ben_id
                                    AND ss.session_code = l_session_code - 1
                                    AND bi.session_code = l_session_code - 1
                                    AND ss.stud_ref_no = l_stud_ref_no;
                                    
                                    IF ben1_income = 'F' and ben2_income = 'F'
                                        THEN l_result := 'Y';
                                    ELSE l_result := 'N';
                                    END IF;
                                       
                        END CASE;
                        
                 END IF;
            
            ELSE l_result := 'N';
        END IF;
        
        
        RETURN l_result;

END remark2_prev_session_exist;
        
 
/* Formatted on 2009/10/29 16:01 (Formatter Plus v4.8.8) */
FUNCTION get_remark1 (p_stud_crse_year_id IN NUMBER)
   RETURN CHAR
IS
   b1_income_status CHAR := 'F';
   b2_income_status CHAR := 'F';
   l_rem1           CHAR := 'N';
   l_count          NUMBER;
   
BEGIN

    SELECT CASE
            WHEN ss.BEN1_ID IS NULL AND ss.BEN2_ID IS NULL
                THEN 0
            WHEN ss.BEN1_ID IS NOT NULL AND ss.BEN2_ID IS NULL AND  scy.provisional_case = 'Y' AND scy.scheme_type IN('U','P')
                THEN 1
            WHEN ss.BEN1_ID IS NOT NULL AND ss.BEN2_ID IS NOT NULL AND scy.provisional_case = 'Y' AND scy.scheme_type IN('U','P')
                THEN 2
            ELSE 0
            END count
            INTO l_count
            FROM STUD_SESSION ss, STUD_CRSE_YEAR scy
            WHERE ss.stud_session_id = scy.stud_session_id
            AND scy.stud_crse_year_id = p_stud_crse_year_id;
            
            CASE WHEN l_count = 1
                    THEN 
                        SELECT NVL(bi.INCOME_STATUS,'F')
                        INTO b1_income_status
                        FROM BENEFACTOR_INCOME bi, STUD_SESSION ss, STUD_CRSE_YEAR scy
                        WHERE ss.ben1_id = bi.ben_id
                        AND scy.stud_session_id = ss.stud_session_id
                        AND bi.session_code = ss.session_code
                        AND scy.stud_crse_year_id = p_stud_crse_year_id;
                        
                        IF b1_income_status = 'P'
                            THEN l_rem1 := 'Y'; 
                        ELSE l_rem1 := 'N';
                        END IF;
                
            WHEN l_count = 2
                    THEN
                        SELECT NVL(bi.INCOME_STATUS,'F')
                        INTO b1_income_status
                        FROM BENEFACTOR_INCOME bi, STUD_SESSION ss, STUD_CRSE_YEAR scy
                        WHERE ss.ben1_id = bi.ben_id
                        AND scy.stud_session_id = ss.stud_session_id
                        AND bi.session_code = ss.session_code
                        AND scy.stud_crse_year_id = p_stud_crse_year_id;
                        
                        SELECT NVL(bi.INCOME_STATUS,'F')
                        INTO b2_income_status
                        FROM BENEFACTOR_INCOME bi, STUD_SESSION ss, STUD_CRSE_YEAR scy
                        WHERE ss.ben2_id = bi.ben_id
                        AND scy.stud_session_id = ss.stud_session_id
                        AND bi.session_code = ss.session_code
                        AND scy.stud_crse_year_id = p_stud_crse_year_id;
                        
                        IF b1_income_status = 'P' OR b2_income_status = 'P'
                            THEN l_rem1 := 'Y';
                        ELSE l_rem1 := 'N';
                        END IF;
                        
                    
                    
            ELSE l_rem1 := 'N';   
            END CASE;
            
         

   RETURN l_rem1;
   
END get_remark1;

FUNCTION get_remark2 (p_stud_crse_year_id IN NUMBER)
    RETURN CHAR
IS

    l_count                     NUMBER;
    b1_qa_recieved              CHAR := 'N';
    b1_income_status            CHAR;
    l_rem2                      CHAR := 'N';
    b2_qa_recieved              CHAR := 'N';
    b2_income_status            CHAR;
    l_prev_exists               CHAR;
    l_count_awards              NUMBER;
    

BEGIN


        SELECT CASE
            WHEN ss.BEN1_ID IS NULL AND ss.BEN2_ID IS NULL
                THEN 0
            WHEN ss.BEN1_ID IS NOT NULL AND ss.BEN2_ID IS NULL  AND scy.scheme_type = 'U'
                THEN 1
            WHEN ss.BEN1_ID IS NOT NULL AND ss.BEN2_ID IS NOT NULL AND scy.scheme_type = 'U'
                THEN 2
            ELSE 0
            END count
            INTO l_count
            FROM STUD_SESSION ss, STUD_CRSE_YEAR scy
            WHERE ss.stud_session_id = scy.stud_session_id
            AND scy.stud_crse_year_id = p_stud_crse_year_id;
                      
            SELECT COUNT(*)
            INTO l_count_awards
            FROM AWARD a, STUD_AWARD_TYPE b
            WHERE A.STUD_AWARD_TYPE IN('YSO','SOSB','YSB','ISB','UDMFL','UCMFL','UGML','UGMFL','UDNXL','UDML','UEMFL','UEML','UCML','RGML','RGMFL','PSDA','UGDA','UGLOAN')
            AND A.STUD_AWARD_TYPE = B.STUD_AWARD_TYPE
            AND A.STUD_CRSE_YEAR_ID = p_stud_crse_year_id;     
            
            CASE 
                WHEN l_count = 1
                        THEN
                                l_prev_exists := remark2_prev_session_exist(p_stud_crse_year_id);
                                
                                IF l_prev_exists = 'Y'
                                    THEN
                                
                                        SELECT NVL(bi.qa_received  ,'N'), NVL(bi.income_status,'P')
                                        INTO b1_qa_recieved, b1_income_status
                                        FROM BENEFACTOR_INCOME bi, STUD_SESSION ss, STUD_CRSE_YEAR scy
                                        WHERE ss.ben1_id = bi.ben_id
                                        AND scy.stud_session_id = ss.stud_session_id
                                        AND bi.session_code = ss.session_code
                                        AND scy.stud_crse_year_id = p_stud_crse_year_id;
                                
                                                IF b1_qa_recieved = 'N' AND b1_income_status = 'F' AND l_count_awards > 0
                                                    THEN l_rem2 := 'Y';
                                                ELSE l_rem2 := 'N';
                                                END IF;
                                
                                ELSE l_rem2 := 'N';
                                END IF;
           
                WHEN l_count = 2
                        THEN
                                l_prev_exists := remark2_prev_session_exist(p_stud_crse_year_id);
                                
                                IF l_prev_exists = 'Y'
                                    THEN      
                        
                                SELECT NVL(bi.qa_received,'N'), NVL(bi.income_status,'P')
                                INTO b1_qa_recieved, b1_income_status
                                FROM BENEFACTOR_INCOME bi, STUD_SESSION ss, STUD_CRSE_YEAR scy
                                WHERE ss.ben1_id = bi.ben_id
                                AND scy.stud_session_id = ss.stud_session_id
                                AND bi.session_code = ss.session_code
                                AND scy.stud_crse_year_id = p_stud_crse_year_id;
                                
                                SELECT NVL(bi.qa_received,'N'), NVL(bi.income_status,'P')
                                INTO b2_qa_recieved, b2_income_status
                                FROM BENEFACTOR_INCOME bi, STUD_SESSION ss, STUD_CRSE_YEAR scy
                                WHERE ss.ben2_id = bi.ben_id
                                AND scy.stud_session_id = ss.stud_session_id
                                AND bi.session_code = ss.session_code
                                AND scy.stud_crse_year_id = p_stud_crse_year_id;
                                
                                IF (b1_qa_recieved = 'N' OR b2_qa_recieved = 'N') AND b1_income_status = 'F' AND b2_income_status = 'F' AND l_count_awards > 0
                                     THEN l_rem2 := 'Y';
                                   
                                ELSE l_rem2 := 'N';
                                END IF;
                                
                                ELSE l_rem2 := 'N';
                                END IF;
                        
                WHEN l_count = 0
                

                        THEN l_rem2 := 'N'; 
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

   SELECT  CASE
                     WHEN (    s.scheme_type IN ('U', 'P')
                           AND s.award NOT IN ('A', 'C', 'D')
                           AND ((  NVL (s.resid_par_cont, 0)
                                 + NVL (s.resid_stud_cont, 0)
                                ) > 0
                               )
                          )
                        THEN 'Y'
                     ELSE 'N'
                  END rem8
     INTO l_rem8
     FROM stud_crse_year s
    WHERE s.stud_crse_year_id = p_stud_crse_year_id;

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

   SELECT CASE
                     WHEN (   s.dearing IN ('B', 'E')
                              AND s.erasmus = 'Y'
                           OR s.paid_sandwich = 'Y'
                           OR s.unpaid_sandwich = 'Y'
                          )
                        THEN 'Y'
                     ELSE 'N'
                  END rem9
     INTO l_rem9
     FROM stud_crse_year s
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


FUNCTION get_rem13Value (p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS
        l_result        NUMBER := 0;
        
BEGIN
        
      SELECT SUM(NVL(b.net_amount,0) + NVL(b.unclaimed_loan,0)) AS amount
      INTO l_result
      FROM stud_award_type a, award b
      WHERE a.stud_award_type = b.stud_award_type
      AND b.stud_crse_year_id = p_stud_crse_year_id
      AND a.loan_non_loan_fee = 'Loan';
       
      RETURN l_result;

END get_rem13Value;


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
     
       IF p_method = 'B' 
       
        THEN 

         IF p_payee_type IS NOT NULL AND p_payee_type = 'S' 
         
                THEN
         
                        p_payment_location := 'Sort code        '||p_sort_code||'         Acc                 '|| p_acc_no;

         END IF;
         
       ELSE 

         p_payment_location := 'Awaiting bank details';
          
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

        
        SELECT NVL(SUM(b.net_amount),0)
        INTO v_unpaid
        FROM AWARD a, AWARD_INSTALMENT b, stud_award_type c
        WHERE a.award_id = b.award_id
        AND c.stud_award_type = a.stud_award_type
        AND c.show_on_an_payments = 'Y'
        AND a.award_src = 'A'
        AND c.type NOT IN('DSA','TRAV','PAY','MAN')
        AND c.stud_award_type <> 'ADHOC'
        AND a.stud_crse_year_id = p_stud_crse_year_id
        AND b.payment_status = 'U';

        
        SELECT NVL(SUM(b.net_amount),0)
        INTO v_paid
        FROM AWARD a, AWARD_INSTALMENT b, stud_award_type c
        WHERE a.award_id = b.award_id
        AND c.stud_award_type = a.stud_award_type
        AND c.show_on_an_payments = 'Y'
        AND b.payment_status = 'S'
        AND b.returned = 'N'
        AND a.award_src = 'A'
        AND c.type NOT IN('DSA','TRAV','PAY','MAN')
        AND c.stud_award_type <> 'ADHOC'
        AND a.stud_crse_year_id = p_stud_crse_year_id
        AND b.payment_status = 'S';
            
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

FUNCTION getRemarkTwoNumber(p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS

    l_result NUMBER;
    l_temp   NUMBER;
    
    BEGIN
    
        SELECT i.location_ind
        INTO l_temp
        FROM STUD_CRSE_YEAR scy, INST i
        WHERE scy.inst_code = i.inst_code
        AND scy.stud_crse_year_id = p_stud_crse_year_id;
        
     CASE
        WHEN l_temp = 1
                THEN SELECT NVAL
                     INTO l_result
                     FROM CONFIG_DATA
                     WHERE ITEM_NAME = 'PROVISIONAL_STOP_PAY_SEQUENCE_SCOTT';
        ELSE 
                SELECT NVAL
                     INTO l_result
                     FROM CONFIG_DATA
                     WHERE ITEM_NAME = 'PROVISIONAL_STOP_PAY_SEQUENCE_RUK';
     END CASE;
     
     RETURN l_result;
     
END getRemarkTwoNumber;

FUNCTION get_inst_location (p_stud_crse_year_id IN NUMBER) RETURN VARCHAR2
IS
    location_ind    VARCHAR2(1);
    
    BEGIN

    SELECT a.location_ind
    INTO location_ind
      FROM inst a,
           sgas.stud_crse_year scy,
           sgas.stud c,
           crse d,
           crse_year e,
           crse_session f,
           sgas.stud_session ss
     WHERE     c.stud_ref_no = scy.stud_ref_no
           AND scy.crse_year_id = e.crse_year_id
           AND e.crse_session_id = f.crse_session_id
           AND f.crse_id = d.crse_id
           AND d.inst_code = a.inst_code
           AND scy.stud_session_id = ss.stud_session_id
           AND scy.stud_crse_year_id = p_stud_crse_year_id;
           
           RETURN location_ind;

END   get_inst_location;         

/* Formatted on 2012/06/21 12:49 (Formatter Plus v4.8.8) */
PROCEDURE get_an_student_data (p_students OUT an_students_cursor)
IS
   c_students   an_students_cursor;
BEGIN
   OPEN c_students FOR
      SELECT DISTINCT stcy.stud_crse_year_id AS stud_crse_year_id,
                      stcy.stud_ref_no AS stud_ref_no,
                      stcy.session_code AS session_code,
                      stcy.crse_year_no AS course_year_no,
                      CONCAT ('SAAS', st.scottish_cand) AS ssn,
                      sgas.pk_steps_award_letter.get_stud_ssnprint
                                          (stcy.stud_crse_year_id)
                                                                 AS ssnprint,
                      NVL (sha.out_uk, 'N') AS out_uk, st.title AS title,
                      st.forenames AS first_name, st.surname AS last_name,
                      stcy.inst_name AS inst_name,
                      stcy.crse_name AS crse_name,
                      CASE
                         WHEN st.account_no IS NULL
                            THEN NULL
                         ELSE CONCAT ('****',
                                      SUBSTR (st.account_no, 5, 4)
                                     )
                      END AS accountno,
                      st.sort_code AS sortcode,
                      st.payment_method AS paymentmethod,
                      CASE
                        WHEN sts.eu_flag = 'Y' AND st.ADDR_CORR_FLAG = 'T' AND stcy.SCHEME_TYPE <> 'B'
                         THEN sta.house_no_name
                      ELSE sha.house_no_name 
                      END address_line1,
                      CASE
                        WHEN sts.eu_flag = 'Y' AND st.ADDR_CORR_FLAG = 'T' AND stcy.SCHEME_TYPE <> 'B'
                         THEN sta.addr_l1
                      ELSE sha.addr_l1 
                      END address_line2,
                      CASE
                        WHEN sts.eu_flag = 'Y' AND st.ADDR_CORR_FLAG = 'T' AND stcy.SCHEME_TYPE <> 'B'
                         THEN sta.addr_l2
                      ELSE sha.addr_l2 
                      END address_line3,
                      CASE
                        WHEN sts.eu_flag = 'Y' AND st.ADDR_CORR_FLAG = 'T' AND stcy.SCHEME_TYPE <> 'B'
                         THEN sta.addr_l3
                      ELSE sha.addr_l3 
                      END address_line4,
                      CASE
                        WHEN sts.eu_flag = 'Y' AND st.ADDR_CORR_FLAG = 'T' AND stcy.SCHEME_TYPE <> 'B'
                         THEN sta.addr_l4
                      ELSE sha.addr_l4 
                      END address_line5,
                      CASE
                        WHEN sts.eu_flag = 'Y' AND st.ADDR_CORR_FLAG = 'T' AND stcy.SCHEME_TYPE <> 'B'
                         THEN sta.post_code
                      ELSE sha.post_code 
                      END address_line6,
                      stcy.dearing AS dearing,
                      DECODE (stcy.scheme_type, 'B', 'Y', 'N') AS nmsb_flag,
                      sgas.pk_steps_award_letter.show_award_instalments
                                  (stcy.stud_crse_year_id)
                                                         AS showgrantbursary,
                      sgas.pk_steps_award_letter.getoverpaymentrecordedamount
                             (stcy.stud_crse_year_id)
                                                    AS overpayment_recovered,
                      sgas.pk_steps_award_letter.getremarktwonumber
                                        (stcy.stud_crse_year_id)
                                                               AS rem2number,
                      NVL (st.overpayment, 0) AS overpayment,
                      NVL (st.snb_overpayment, 0) AS snboverpayment,
                      sgas.pk_steps_award_letter.get_stud_fees_saas
                                 (stcy.stud_crse_year_id)
                                                        AS tuition_fees_saas,
                      sgas.pk_steps_award_letter.get_stud_fees_nmsb
                                 (stcy.stud_crse_year_id)
                                                        AS tuition_fees_nmsb,                                                        
                      sgas.pk_steps_award_letter.get_stud_fees_stud
                                 (stcy.stud_crse_year_id)
                                                        AS tuition_fees_stud,
                      sgas.pk_steps_award_letter.get_stud_loan_for_fees
                                 (stcy.stud_crse_year_id)
                                                        AS loan_for_fees_amt,
                      sgas.pk_steps_award_letter.get_stud_loan_amount
                                       (stcy.stud_crse_year_id)
                                                              AS loan_amount,
                      NVL (stcy.req_dup, 'N') AS req_dup,
                      sts.emp_login_name AS caseworkername,
                      NVL
                         (sgas.pk_steps_award_letter.get_remark1
                                                       (stcy.stud_crse_year_id),
                          'N'
                         ) AS rem1,
                      NVL
                         (sgas.pk_steps_award_letter.get_remark2
                                                       (stcy.stud_crse_year_id),
                          'N'
                         ) AS rem2,
                      CASE
                         WHEN (    (st.overpayment > 0)
                               AND (stcy.scheme_type <> 'B')
                              )
                            THEN 'Y'
                         WHEN (    (st.snb_overpayment > 0)
                               AND (stcy.scheme_type = 'B')
                              )
                            THEN 'Y'
                         ELSE 'N'
                      END AS rem5,
                      CASE
                         WHEN (stcy.award = 'D')
                         AND sgas.pk_steps_award_letter.getpamsoutsidescotland
                                                       (stcy.stud_crse_year_id) =
                                                                           'N'
                            THEN 'Y'
                         ELSE 'N'
                      END AS rem6,
                      CASE
                         WHEN (stcy.award = 'C')
                         AND sgas.pk_steps_award_letter.getpamsoutsidescotland
                                                       (stcy.stud_crse_year_id) =
                                                                           'N'
                            THEN 'Y'
                         ELSE 'N'
                      END AS rem7,
                      --Changed on the back of defect 64 24/04/2014 Clark Bolan
                      CASE
                         WHEN ((SELECT COUNT(STUD_CRSE_YEAR_ID) 
                                FROM AWARD 
                                   WHERE STUD_AWARD_TYPE = 'TFEL' 
                                   AND STUD_CRSE_YEAR_ID = stcy.stud_crse_year_id)) >= 1 
                                AND STCY.FEE_LOAN_GIVEN = 'E'
                            THEN 'Y'
                         ELSE 'N'
                      END AS rem11,
                      stcy.remark AS comments,
                      CASE
                      WHEN STCY.GA_STUDENT = 'Y'
                            THEN 'G'    
                        WHEN stcy.scheme_type = 'U' and NVL(sts.eu_flag,'N') = 'N'
                            THEN 'UN'
                        WHEN stcy.scheme_type = 'U' and NVL(sts.eu_flag,'N') = 'Y'
                            THEN 'UY'
                        WHEN stcy.scheme_type = 'P'
                            THEN 'P'
                        WHEN stcy.scheme_type = 'B'
                            THEN 'B'
                        END studentSupport,
                      CASE
                        WHEN scheme_type = 'P'
                            THEN sgas.rules_proc_recalc.fee_cut_off_date(stcy.stud_crse_year_id)
                        ELSE cy.cutoff_date
                        END relativeDate, 
                        CASE
                            WHEN sts.eu_flag = 'Y' AND ST.ADDR_CORR_FLAG = 'T'  -- COS2015 defect 22 Changed from STCY.CORRES_DEST 28/01/2016
                                THEN 'T'
                             ELSE 'H'
                             END corr,
                        STS.MAX_LOAN_REQUESTED,
                        SGAS.PK_STEPS_AWARD_LETTER.get_inst_location (stcy.stud_crse_year_id) as location_ind,
                        SGAS.PK_STEPS_PG_ED_PSYCH.checkIfPgEdPsychCourse(stcy.inst_code, stcy.crse_code) AS isPgEdPsychCourse,
                        STCY.COVID_EXTENSION_IND
                 FROM stud_crse_year stcy,
                      stud_session sts,
                      stud st,
                      stud_home_addr sha,
                      ja_case ja,
                      award a,
                      stud_term_addr sta,
                      crse_year cy
                WHERE st.stud_ref_no = sts.stud_ref_no
                  AND sts.stud_session_id = stcy.stud_session_id
                  AND stcy.stud_ref_no = sha.stud_ref_no
                  AND a.stud_crse_year_id = stcy.stud_crse_year_id
                  AND cy.crse_year_id = stcy.crse_year_id
                  AND st.stud_ref_no = sta.stud_ref_no(+)
                  AND stcy.latest_crse_ind = 'Y'
                  AND stcy.sal_sent = 'N'
                  AND sts.session_suspend = 'N'
                  AND st.stud_suspend = 'N'
                  AND stcy.crse_suspend = 'N'
                  AND st.qa_count = 0
                  AND stcy.sal_dest = '1'
                  AND sha.end_date IS NULL
                  AND sta.end_date IS NULL
                  AND st.suspend_payment = 'N'
                  AND st.stud_ref_no IN (
                   SELECT a.stud_ref_no
                     FROM award a, stud_award_type b
                    WHERE a.stud_award_type = b.stud_award_type
                      AND A.STUD_CRSE_YEAR_ID = STCY.STUD_CRSE_YEAR_ID
                      AND b.type IN
                             ('BURS', 'DEPG', 'FEE', 'LOAN', 'LPCG', 'LPG',
                              'SMA','CESB', 'PEPF', 'PEPG'))
                  AND sts.ja_case_id = ja.ja_case_id(+)
                  AND st.deceased_flag = 'N';

   p_students := c_students;
END get_an_student_data;
   
 /* Formatted on 19/08/2015 10:33:53 (QP5 v5.215.12089.38647) */
PROCEDURE get_an_award_data (
   p_stud_crse_year_id   IN     VARCHAR2,
   p_stud_awards            OUT an_stud_awards_cursor)
IS
   c_stud_awards   an_stud_awards_cursor;
BEGIN
   OPEN c_stud_awards FOR
      SELECT sa.award_type_descript AS award_type_desc,
             CASE
                WHEN   NVL (sa.amount, 0)
                     - NVL (sa.recovered_amount, 0)
                     - NVL (sa.contrib_amount, 0)
                     + NVL (sa.overpaid_contrib, 0) < 0
                THEN
                   0
                ELSE
                     NVL (sa.amount, 0)
                   - NVL (sa.recovered_amount, 0)
                   - NVL (sa.contrib_amount, 0)
                   + NVL (sa.overpaid_contrib, 0)
             END
                amount,
             CASE
                WHEN sat.loan_non_loan_fee = 'Loan' THEN 'Y'
                WHEN sat.loan_non_loan_fee = 'fee' THEN 'F'
                ELSE 'N'
             END
                AS is_loan,
             sat.show_on_an_payments
        FROM AWARD sa, stud_award_type sat
       WHERE     sa.stud_crse_year_id = p_stud_crse_year_id
             AND sa.stud_award_type = sat.stud_award_type
             AND sat.TYPE NOT IN ('DSA', 'TRAV', 'PAY', 'MAN');

   p_stud_awards := c_stud_awards;
END get_an_award_data;
  

  PROCEDURE get_an_award_payments (
      p_stud_crse_year_id       IN VARCHAR2, 
      p_award_payments          OUT an_award_payments_cursor)
  IS
    c_award_payments    an_award_payments_cursor;
  BEGIN
    OPEN c_award_payments FOR
SELECT payment_date, pay_amount, pay_location
FROM(
SELECT   payment_date, SUM (pay_amount) pay_amount, pay_location
    FROM (SELECT   payment_date, pay_amount, pay_location
              FROM (SELECT 1 AS ord, (b.payment_due_date) AS payment_date,
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
                    UNION ALL
                    SELECT 0 AS ord, (b.payment_due_date) AS payment_date,
                           b.net_amount AS pay_amount,
                           sgas.pk_steps_award_letter.build_pay_location_string
                               (b.method,
                                b.payee,
                                concat('****',substr(pi.account_no,5,4)),
                                pi.sort_code,
                                NULL,
                                b.payment_addr,
                                b.payment_status,
                                b.returned,
                                b.recalc,
                                'PAID CAMPUS'
                               ) AS pay_location
                                            FROM award a, award_instalment b, stud_award_type c, stud d, payment_instalment pi
                     WHERE a.stud_crse_year_id = p_stud_crse_year_id
                       AND c.loan_non_loan_fee <> 'fee'
                       AND c.type NOT IN('DSA','MAN','TRAV')
                       AND a.award_id = b.award_id
                       AND b.award_instalment_id = pi.award_instalment_id
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
  
END PK_STEPS_AWARD_LETTER;
/

