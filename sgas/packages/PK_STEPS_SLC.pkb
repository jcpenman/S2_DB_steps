CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_SLC IS
--

--
-- DESCRIPTION
-- ===========
/* CHANGE HISTORY
Version Date         Author         Change 
1.0    04/05/2011   P. HUUGHES      Initial Main Release to SIT for all 3 files
1.1    23/02/2012   C.Bolan         updated procedure to ensure multiple rows are not returned when running sub querys
1.2    17/08/2013   P.HUGHES        Added in to only pick up session records less than the pay loan session for file 1 and file 2.
1.3    11/09/2013   P.HUGHES        SLC Live Issue fixes
1.4    12/12/2013   C. Bolan        Removal of the Pay Loans code for change of session 2014
                                    - PAY_LOANS_RELEASE YEAR
1.41   17/01/2019   J. Penman      Changed data width for defect 11 in PROCEDURE get_slc_filefeeLoan (Accelerated Degree SFD3) 
1.42   16/04/2021  J. Penman       CR25 Added extra logic to handle loan cancellations
1.43   14/07/2021  J. Penman       CR18 -Modifications to include HEBBS bursary award      
1.44   07/11/2023  J.Penman       Emergency Fix for COS24-25 - changed the mask in SELECT statement   LTRIM(TO_CHAR(sgas.pk_steps_slc.getLivingCostLoanAvailable(scy.stud_crse_year_id),'09999.99')) AS LivingCostLoanAvailable, (lines 728 and 920)                             
                                  
                                    
*/

FUNCTION getBenefactor1TotalIncome(p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER
IS

    v_result    NUMBER;
    l_ben1_id    NUMBER;
    
BEGIN

    SELECT CASE
            WHEN BEN1_ID IS NOT NULL
                THEN ben1_id
           ELSE 0
           END count
           INTO l_ben1_id
           FROM STUD_SESSION   
           WHERE STUD_REF_NO = p_stud_ref_no
           AND SESSION_CODE = p_session_code;
           
           IF l_ben1_id  = 0
                THEN v_result := null;
           ELSE 
              SELECT  NVL (bank_interest, 0)
               + NVL (benefit, 0)
               + NVL (other_income, 0)
               + NVL (nat_saving_interest, 0)
               + NVL (paye_income, 0)
               + NVL (pension, 0)
               + NVL (self_employment, 0)
               + NVL (property, 0)
               + NVL (dividend, 0)
               - NVL (other_deduct, 0)
               INTO v_result
               FROM BENEFACTOR_INCOME
               WHERE ben_id = l_ben1_id
               AND session_code = p_session_code;
               
            END IF;
            
      RETURN v_result;
      
END getBenefactor1TotalIncome;

FUNCTION getBenefactor2TotalIncome(p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER
IS

    v_result    NUMBER;
    l_ben2_id    NUMBER;
    
BEGIN

    SELECT CASE
            WHEN BEN2_ID IS NOT NULL
                THEN ben2_id
           ELSE 0
           END count
           INTO l_ben2_id
           FROM STUD_SESSION   
           WHERE STUD_REF_NO = p_stud_ref_no
           AND SESSION_CODE = p_session_code;
           
           IF l_ben2_id  = 0
                THEN v_result := null;
           ELSE 
              SELECT  NVL (bank_interest, 0)
               + NVL (benefit, 0)
               + NVL (other_income, 0)
               + NVL (nat_saving_interest, 0)
               + NVL (paye_income, 0)
               + NVL (pension, 0)
               + NVL (self_employment, 0)
               + NVL (property, 0)
               + NVL (dividend, 0)
               - NVL (other_deduct, 0)
               INTO v_result
               FROM BENEFACTOR_INCOME
               WHERE ben_id = l_ben2_id
               AND session_code = p_session_code;
               
            END IF;
            
      RETURN v_result;
      
END getBenefactor2TotalIncome;
              
FUNCTION getHouseHoldResidential(p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER
IS

    v_result    NUMBER;
    l_count     NUMBER;
    l_ben1      NUMBER;
    l_ben2      NUMBER;
    v_ben1_consent CHAR;
    v_ben2_consent CHAR;
    
BEGIN   

    SELECT CASE
            WHEN BEN1_ID IS NULL AND BEN2_ID IS NULL
            THEN 0
            WHEN BEN1_ID IS NOT NULL AND BEN2_ID IS NULL
            THEN 1
            WHEN BEN1_ID IS NOT NULL AND BEN2_ID IS NOT NULL
            THEN 2
            END count
            INTO l_count
            FROM STUD_SESSION   
            WHERE STUD_REF_NO = p_stud_ref_no
            AND SESSION_CODE = p_session_code;
            
            CASE
                WHEN l_count = 0
                    THEN v_result := null;
                WHEN l_count = 1 --ONE BENEFACTOR EXISTS ONLY
                    THEN
                    
                           SELECT NVL(BEN_HEI_BURSARY_CONSENT,'N')
                           INTO v_ben1_consent
                           FROM BENEFACTOR_INCOME bi, stud_session ss
                           WHERE bi.session_code = ss.session_code
                           AND bi.ben_id = ss.ben1_id
                           AND ss.session_code = p_session_code
                           AND ss.stud_ref_no = p_stud_ref_no;
                           
                           IF v_ben1_consent = 'Y'
                            THEN
                                       SELECT  NVL (bi.bank_interest, 0)
                                       + NVL (bi.benefit, 0)
                                       + NVL (bi.other_income, 0)
                                       + NVL (bi.nat_saving_interest, 0)
                                       + NVL (bi.paye_income, 0)
                                       + NVL (bi.pension, 0)
                                       + NVL (bi.self_employment, 0)
                                       + NVL (bi.property, 0)
                                       + NVL (bi.dividend, 0)
                                       - NVL (bi.other_deduct, 0)
                                       INTO v_result
                                       FROM BENEFACTOR_INCOME bi, stud_session ss
                                       WHERE bi.session_code = ss.session_code
                                       AND bi.ben_id = ss.ben1_id
                                       AND ss.session_code = p_session_code
                                       AND ss.stud_ref_no = p_stud_ref_no;
                            ELSE v_result := null;
                            END IF;
                           
                           
                WHEN l_count = 2 --TWO BENEFACTORRS EXIST
                      THEN
                      
                            SELECT NVL(BEN_HEI_BURSARY_CONSENT,'N')
                           INTO v_ben1_consent
                           FROM BENEFACTOR_INCOME bi, stud_session ss
                           WHERE bi.session_code = ss.session_code
                           AND bi.ben_id = ss.ben1_id
                           AND ss.session_code = p_session_code
                           AND ss.stud_ref_no = p_stud_ref_no;
                           
                           SELECT NVL(BEN_HEI_BURSARY_CONSENT,'N')
                           INTO v_ben2_consent
                           FROM BENEFACTOR_INCOME bi, stud_session ss
                           WHERE bi.session_code = ss.session_code
                           AND bi.ben_id = ss.ben2_id
                           AND ss.session_code = p_session_code
                           AND ss.stud_ref_no = p_stud_ref_no;
                           
                           IF v_ben1_consent = 'Y' AND v_ben2_consent = 'Y'
                               THEN

                           SELECT  NVL (bank_interest, 0)
                           + NVL (benefit, 0)
                           + NVL (other_income, 0)
                           + NVL (nat_saving_interest, 0)
                           + NVL (paye_income, 0)
                           + NVL (pension, 0)
                           + NVL (self_employment, 0)
                           + NVL (property, 0)
                           + NVL (dividend, 0)
                           - NVL (other_deduct, 0)
                           INTO l_ben1
                           FROM BENEFACTOR_INCOME bi, stud_session ss
                           WHERE bi.session_code = ss.session_code
                           AND bi.ben_id = ss.ben1_id
                           AND ss.session_code = p_session_code
                           AND ss.stud_ref_no = p_stud_ref_no;
                           
                           SELECT  NVL (bank_interest, 0)
                           + NVL (benefit, 0)
                           + NVL (other_income, 0)
                           + NVL (nat_saving_interest, 0)
                           + NVL (paye_income, 0)
                           + NVL (pension, 0)
                           + NVL (self_employment, 0)
                           + NVL (property, 0)
                           + NVL (dividend, 0)
                           - NVL (other_deduct, 0)
                           INTO l_ben2
                           FROM BENEFACTOR_INCOME bi, stud_session ss
                           WHERE bi.session_code = ss.session_code
                           AND bi.ben_id = ss.ben2_id
                           AND ss.session_code = p_session_code
                           AND ss.stud_ref_no = p_stud_ref_no;
                           
                           v_result := l_ben1 + l_ben2;
                           
                           ELSE v_result := null;
                           END IF;
                           
                 END CASE;
                 
                 
        RETURN v_result;
        
 END getHouseHoldResidential;
 
 
FUNCTION getSOSBTotal(p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER
IS

    v_result    NUMBER;
    l_count     NUMBER;
    
BEGIN

        IF p_session_code > 2012
        
            THEN 
            
                SELECT COUNT(*)
                INTO l_count
                FROM AWARD
                WHERE STUD_REF_NO = p_stud_ref_no
                AND SESSION_CODE = p_session_code
                AND STUD_AWARD_TYPE IN ('YSB','ISB');
    
                IF l_count = 0
                    THEN v_result := null;
                ELSE
                    SELECT SUM(NET_AMOUNT)
                    INTO v_result
                    FROM AWARD
                    WHERE STUD_REF_NO = p_stud_ref_no
                    AND SESSION_CODE = p_session_code
                    AND STUD_AWARD_TYPE IN('YSB','ISB');
                    
                END IF;
        
        ELSE
            
            

                SELECT COUNT(*)
                INTO l_count
                FROM AWARD
                WHERE STUD_REF_NO = p_stud_ref_no
                AND SESSION_CODE = p_session_code
                AND STUD_AWARD_TYPE = 'SOSB';
                
                IF l_count = 0
                    THEN v_result := null;
                ELSE
                    SELECT SUM(NET_AMOUNT)
                    INTO v_result
                    FROM AWARD
                    WHERE STUD_REF_NO = p_stud_ref_no
                    AND SESSION_CODE = p_session_code
                    AND STUD_AWARD_TYPE = 'SOSB';
        
                        END IF;
                        
      END IF;
    
    RETURN v_result;
    
    END getSOSBTotal;
    


FUNCTION getHEIInstName(p_HEI_INST_CODE IN CHAR) RETURN CHAR
IS

    v_result CHAR(25);
    
BEGIN

        SELECT SUBSTR(HEI_INST_NAME,0,25)
        INTO v_result
        FROM HEI_INST@GRASS
        WHERE HEI_INST_CODE = p_HEI_INST_CODE;
        
        RETURN v_result;
        
END getHEIInstName;

FUNCTION getHEICrseName(p_HEI_CRSE_CODE IN CHAR, p_HEI_INST_CODE IN CHAR) RETURN CHAR
IS

    v_result CHAR(25);
    
BEGIN

        SELECT SUBSTR(HEI_CRSE_NAME,0,25)
        INTO v_result
        FROM HEI_CRSE@GRASS
        WHERE HEI_CRSE_CODE = p_HEI_CRSE_CODE
        AND HEI_INST_CODE = p_HEI_INST_CODE
        AND SLC_CODE = 'Y';

        
        RETURN v_result;
        
END getHEICrseName;


FUNCTION getCrseEndDate(p_stud_crse_year_id IN NUMBER) RETURN DATE
IS

    v_result    DATE;
    v_temp      CHAR(8);
    v_duration  NUMBER;
    v_crse_year_no  NUMBER;
    
BEGIN

            v_temp := TO_CHAR(sgas.rules_proc_recalc.getStudyEnddate(p_stud_crse_year_id),'DDMMYYYY');
            
            
            SELECT cs.max_duration
            INTO v_duration
            FROM CRSE_SESSION cs, CRSE_YEAR cy, STUD_CRSE_YEAR scy
            WHERE cs.crse_session_id = cy.crse_session_id
            AND scy.crse_year_id = cy.crse_year_id
            AND scy.stud_crse_year_id = p_stud_crse_year_id;
            
            SELECT scy.crse_year_no
            INTO v_crse_year_no
            FROM STUD_CRSE_YEAR scy
            WHERE scy.stud_crse_year_id = p_stud_crse_year_id;
            
            v_result := ADD_MONTHS(TO_DATE(v_temp,'DD-MM-YYYY'), 12 * (v_duration - v_crse_year_no));
            
            RETURN v_result;
            
            
END getCrseEndDate;
            
            
            
            
    



FUNCTION getMaxStudCrseYearLoan(p_stud_ref_no IN NUMBER) RETURN NUMBER
IS
    v_number NUMBER;
    
BEGIN

    SELECT MAX(stud_crse_year_id)
    INTO v_number
    FROM AWARD a, stud_award_type b
    WHERE a.STUD_REF_NO = p_stud_ref_no
    AND a.stud_award_type = 'TFEL';
    
    RETURN v_number;
    
    END getMaxStudCrseYearLoan;
    
 
FUNCTION getNetAmountClaimed (p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS

    v_number NUMBER;
    
BEGIN

        SELECT SUM(a.NET_AMOUNT)
        INTO v_number
        FROM AWARD a, stud_award_type b
        WHERE a.stud_crse_year_id = p_stud_crse_year_id
        AND a.stud_award_type = b.stud_award_type
        and b.type = 'LOAN';    


   RETURN v_number;
   
   END getNetAmountClaimed;
   
   
 
FUNCTION getLivingCostLoanAvailable (p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS

    v_number NUMBER;
    
BEGIN

        SELECT SUM(a.NET_AMOUNT)
        INTO v_number
        FROM AWARD a, stud_award_type b
        WHERE a.stud_crse_year_id = p_stud_crse_year_id
        AND a.stud_award_type = b.stud_award_type
        and b.type = 'LOAN';    


   RETURN v_number;
   
   END getLivingCostLoanAvailable;
   
FUNCTION getFeeLoanIntAccrual (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN CHAR
IS

    v_credit_count    NUMBER;
    v_debit_count     NUMBER;
    v_credit_amount   NUMBER;
    v_debit_amount    NUMBER;
    v_result          CHAR;
    
BEGIN

        SELECT COUNT(TXN_AMOUNT)
        INTO v_credit_count
        FROM FEE_LOAN_TRANSACTION
        WHERE STUD_REF_NO = p_stud_ref_no 
        AND SESSION_CODE = p_session_code
        AND (STATUS IS NULL OR STATUS = 'C')
        AND TXN_DC_FLG = 'C';
        
        SELECT COUNT(TXN_AMOUNT)
        INTO v_debit_count
        FROM FEE_LOAN_TRANSACTION
        WHERE STUD_REF_NO = p_stud_ref_no 
        AND SESSION_CODE = p_session_code
        AND (STATUS IS NULL OR STATUS = 'C')
        AND TXN_DC_FLG = 'D';
        
        IF v_debit_count = 0
            THEN v_debit_amount := 0;
        ELSE 
                        SELECT SUM(TXN_AMOUNT)
                        INTO v_debit_amount
                        FROM FEE_LOAN_TRANSACTION
                        WHERE STUD_REF_NO = p_stud_ref_no 
                        AND SESSION_CODE = p_session_code
                        AND (STATUS IS NULL OR STATUS = 'C')
                        AND TXN_DC_FLG = 'D';
        END IF;
        
        IF v_credit_count = 0
            THEN v_debit_amount := 0;
        ELSE 
                            SELECT SUM(TXN_AMOUNT)
                            INTO v_credit_amount
                            FROM FEE_LOAN_TRANSACTION
                            WHERE STUD_REF_NO = p_stud_ref_no 
                            AND SESSION_CODE = p_session_code
                            AND (STATUS IS NULL OR STATUS = 'C')
                            AND TXN_DC_FLG = 'C';
        END IF;
        
        IF v_credit_amount >= v_debit_amount
            THEN v_result := 'C';
        ELSE v_result := 'D';
        END IF;
        
        RETURN v_result;
        
      END getFeeLoanIntAccrual;
      
---_THIS RETURNS ONLY WHAT IS GOING TO BE PAID FOR STUDENT IN THIS PARTICULAR RUN.  THE RESULT IS NEVER NEGATIVE.      
FUNCTION getFeeLoanPayment (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER
IS

    v_credit_count    NUMBER;
    v_debit_count     NUMBER;
    v_credit_amount   NUMBER;
    v_debit_amount    NUMBER;
    v_result          NUMBER;
    
BEGIN

        SELECT COUNT(TXN_AMOUNT)
        INTO v_credit_count
        FROM FEE_LOAN_TRANSACTION
        WHERE STUD_REF_NO = p_stud_ref_no 
        AND SESSION_CODE = p_session_code
        AND (STATUS IS NULL OR STATUS = 'C')
        AND TXN_DC_FLG = 'C';
        
        SELECT COUNT(TXN_AMOUNT)
        INTO v_debit_count
        FROM FEE_LOAN_TRANSACTION
        WHERE STUD_REF_NO = p_stud_ref_no
        AND SESSION_CODE = p_session_code
        AND (STATUS IS NULL OR STATUS = 'C')
        AND TXN_DC_FLG = 'D';
        
        IF v_debit_count = 0
            THEN v_debit_amount := 0;
        ELSE 
                        SELECT SUM(TXN_AMOUNT)
                        INTO v_debit_amount
                        FROM FEE_LOAN_TRANSACTION
                        WHERE STUD_REF_NO = p_stud_ref_no
                        AND SESSION_CODE = p_session_code
                        AND (STATUS IS NULL OR STATUS = 'C')
                        AND TXN_DC_FLG = 'D';
        END IF;
        
        
        
        IF v_credit_count = 0
            THEN v_credit_amount := 0;
        ELSE 
                            SELECT SUM(TXN_AMOUNT)
                            INTO v_credit_amount
                            FROM FEE_LOAN_TRANSACTION
                            WHERE STUD_REF_NO = p_stud_ref_no
                            AND SESSION_CODE = p_session_code
                            AND (STATUS IS NULL OR STATUS = 'C')
                            AND TXN_DC_FLG = 'C';
        END IF;
        
        
        
        IF v_debit_amount >= v_credit_amount
            THEN v_result := (v_debit_amount - v_credit_amount);
        ELSE v_result := ((v_debit_amount - v_credit_amount) * -1);
        END IF;
        
        
        
        RETURN v_result;

        
        
      END getFeeLoanPayment;
      
FUNCTION getFeeLoanAmount (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER
IS

    v_credit_count    NUMBER;
    v_debit_count     NUMBER;
    v_credit_amount   NUMBER;
    v_debit_amount    NUMBER;
    v_result          NUMBER;
    
BEGIN

        SELECT COUNT(TXN_AMOUNT)
        INTO v_credit_count
        FROM FEE_LOAN_TRANSACTION
        WHERE STUD_REF_NO = p_stud_ref_no 
        AND SESSION_CODE = p_session_code
        AND (STATUS IS NULL OR STATUS = 'C' OR STATUS = 'S')
        AND TXN_DC_FLG = 'C';
        
        SELECT COUNT(TXN_AMOUNT)
        INTO v_debit_count
        FROM FEE_LOAN_TRANSACTION
        WHERE STUD_REF_NO = p_stud_ref_no
        AND SESSION_CODE = p_session_code 
        AND (STATUS IS NULL OR STATUS = 'C' OR STATUS = 'S')
        AND TXN_DC_FLG = 'D';
        
        IF v_debit_count = 0
            THEN v_debit_amount := 0;
        ELSE 
                        SELECT SUM(TXN_AMOUNT)
                        INTO v_debit_amount
                        FROM FEE_LOAN_TRANSACTION
                        WHERE STUD_REF_NO = p_stud_ref_no  
                        AND SESSION_CODE = p_session_code
                        AND (STATUS IS NULL OR STATUS = 'C' OR STATUS = 'S')
                        AND TXN_DC_FLG = 'D';
        END IF;
        
        IF v_credit_count = 0
            THEN v_credit_amount := 0;
        ELSE 
                            SELECT SUM(TXN_AMOUNT)
                            INTO v_credit_amount
                            FROM FEE_LOAN_TRANSACTION
                            WHERE STUD_REF_NO = p_stud_ref_no  
                            AND SESSION_CODE = p_session_code
                            AND (STATUS IS NULL OR STATUS = 'C' OR STATUS = 'S')
                            AND TXN_DC_FLG = 'C';
        END IF;
        
        
        
        IF v_debit_amount >= v_credit_amount
            THEN v_result := (v_debit_amount - v_credit_amount);
        ELSE v_result := ((v_debit_amount - v_credit_amount) * -1);
        END IF;
        
        
        RETURN v_result;
        
        
        
        RETURN v_debit_amount;
        
      END getFeeLoanAmount;
      
      FUNCTION getFeeSLCInclude (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN CHAR
IS

    v_result          CHAR;
    v_temp            NUMBER;
    
BEGIN

        v_temp := SGAS.PK_STEPS_SLC.getFeeLoanPayment(p_stud_ref_no, p_session_code);
        
        IF v_temp = 0
        THEN v_result := 'N';
        ELSE v_result := 'Y';
        END IF;
        
RETURN v_result;

        
END getFeeSLCInclude;
        
  
  PROCEDURE get_slc_file1(p_file_one OUT file_one_cursor)IS
-------------------------------
-- File 1 Student loan records.
-------------------------------
c_file_one       file_one_cursor;  
  

BEGIN
  OPEN c_file_one FOR   
     
      SELECT  DISTINCT CASE
                WHEN scy.provisional_case = 'Y' AND scy.application_status = 'C'
                    THEN 'P'
                WHEN scy.provisional_case = 'N' AND scy.application_status = 'C'
                    THEN 'F'
                WHEN scy.application_status = 'W'
                    THEN 'W'
                ELSE 'X' END Status,
                scy.hei_payment_route AS NonHEIPayRoute,
                CONCAT('SAAS',s.scottish_cand) AS StudSLCRefNo,
                s.ucas_no AS UCASNo, 
                s.prev_loan_acc_no AS PrevStudLoanAccNo,
                CASE
                    WHEN i.hei_inst_code IS NOT NULL
                        THEN sgas.pk_steps_slc.getHEIInstName(i.hei_inst_code)
                    ELSE NULL
                END HEIName,
                CASE
                    WHEN i.hei_inst_code IS NOT NULL
                        THEN SUBSTR(i.hei_inst_code ,0,4)
                    ELSE null
                END HEICode,
                CASE
                    WHEN (cy.hei_crse_code IS NOT NULL AND c.hei_crse_code IS NOT NULL) OR (cy.hei_crse_code IS NOT NULL AND c.hei_crse_code IS NULL)
                        THEN CASE
                                WHEN TRANSLATE(cy.hei_crse_code,
                                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ') IS NULL 
                              THEN LPAD(cy.hei_crse_code, 6, '0')
                              ELSE RPAD(cy.hei_crse_code, 6, ' ')
                        END
                    WHEN cy.hei_crse_code IS NULL AND c.hei_crse_code IS NOT NULL
                        THEN
                            CASE
                                WHEN TRANSLATE(c.hei_crse_code,
                                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ') IS NULL 
                              THEN LPAD(c.hei_crse_code, 6, '0')
                              ELSE RPAD(c.hei_crse_code, 6, ' ')
                        END
                    ELSE null
                END CourseCode,
                scy.crse_year_no AS YearOfCourse,
                CASE 
                    WHEN (SELECT HEI_CRSE_NAME FROM HEI_CRSE@GRASS WHERE HEI_CRSE_CODE = c.hei_crse_code AND HEI_INST_CODE = i.hei_inst_code AND SLC_CODE = 'Y') IS NULL
                        THEN SUBSTR(c.crse_name,0,25)
                    ELSE (SELECT SUBSTR(HEI_CRSE_NAME,0,25) FROM HEI_CRSE@GRASS WHERE HEI_CRSE_CODE = c.hei_crse_code AND HEI_INST_CODE = i.hei_inst_code AND SLC_CODE = 'Y')
                    END CourseName,
                SUBSTR(s.title,0,4) AS Title,
                s.surname AS Surname,
                s.forenames AS Forenames,
                sha.house_no_name,
                sha.addr_l1 AS HomeAddrL1,
                sha.addr_l2 AS HomeAddrL2,
                sha.addr_l3 AS HomeAddrL3,
                sha.addr_l4 AS HomeAddrL4,
                sha.post_code AS PostCode,
                s.sex,
                s.dob AS DOB,
                CASE    
                            WHEN TO_CHAR(scy.withdraw_date, 'MMYYYY') IS NOT NULL
                                THEN TO_CHAR(scy.withdraw_date, 'MMYYYY')
                            WHEN TO_CHAR(CRSE_CHG, 'MMYYYY') IS NOT NULL
                                THEN TO_CHAR(scy.CRSE_CHG,'MMYYYY')
                            ELSE TO_CHAR(SGAS.PK_STEPS_SLC.getCrseEndDate(scy.stud_crse_year_id),'MMYYYY')
                            END CrseEndDate,
                 s.birth_surname AS SurnameAtBirth,
                 s.birth_forenames AS FirstnameAtBirth,
                 SUBSTR(sha.tele_no,0,14) AS HomeTelNo,
                 s.district_birth_cert_issued AS BirthDistrict,
                (SELECT SUBSTR(long_name,0,25) from country where country_code = s.birth_country_code) as BirthCountry,    
                LTRIM(TO_CHAR(sgas.pk_steps_slc.getLivingCostLoanAvailable(scy.stud_crse_year_id),'09999.99')) AS LivingCostLoanAvailable,
                CASE
                    WHEN scy.dearing = 'G' AND ss.stud_hei_bursary_consent = 'Y'
                        THEN ss.stud_hei_bursary_consent
                    ELSE null
                END StudConsent, 
                    (SELECT ben_hei_bursary_consent from benefactor_income where ben_id = ss.ben1_id AND SESSION_CODE = SS.SESSION_CODE) as ben1Consent,
                    (SELECT ben_hei_bursary_consent from benefactor_income where ben_id = ss.ben2_id AND SESSION_CODE = SS.SESSION_CODE) as ben2Consent,
                CASE
                    WHEN scy.dearing  = 'G' AND ss.stud_hei_bursary_consent ='Y'
                        THEN NVL(scy.repeat_year,'N')
                    ELSE null
                END RepeatYear,
                CASE
                    WHEN scy.dearing  = 'G' AND ss.stud_hei_bursary_consent ='Y'
                        THEN 
                                CASE
                            WHEN ss.ben1_id IS NULL AND ss.ben2_id IS NULL
                            THEN 0
                            WHEN ss.ben1_id IS NULL AND ss.ben2_id IS NOT NULL
                            THEN 1
                            WHEN ss.ben1_id IS NOT NULL AND ss.ben2_id IS NULL
                            THEN 1
                            WHEN ss.ben1_id IS NOT NULL AND ss.ben2_id IS NOT NULL
                            THEN 2
                            END
                     ELSE null
                END NoOfBenefactors,
                CASE
                    WHEN scy.dearing  = 'G' AND ss.stud_hei_bursary_consent ='Y'
                        THEN 
                                  CASE
                                        WHEN scy.award = 'E'
                                        THEN 'N'
                                        ELSE 'Y'
                                  END 
                    ELSE null
                 END NonMeansTested,
                 CASE
                    WHEN scy.dearing  = 'G' AND ss.stud_hei_bursary_consent ='Y'
                        THEN 
                            CASE
                                WHEN sgas.nmsb_rules_proc_recalc.get_dependants(scy.stud_crse_year_id) > 9
                                THEN 9
                                ELSE sgas.nmsb_rules_proc_recalc.get_dependants(scy.stud_crse_year_id)
                            END
                    ELSE null 
                 END NoOfDependants,
                 CASE
                    WHEN  scy.dearing  = 'G'
                        THEN LTRIM(TO_CHAR(sgas.pk_steps_slc.getHouseHoldResidential(ss.stud_ref_no, ss.session_code),'0999999.99'))
                    ELSE null
                 END ResidHouseIncome,
                 CASE
                    WHEN  (SELECT ben_hei_bursary_consent from benefactor_income where ben_id = ss.ben1_id AND SESSION_CODE = SS.SESSION_CODE ) = 'Y' AND scy.dearing  = 'G'
                        THEN LTRIM(TO_CHAR(sgas.pk_steps_slc.getBenefactor1TotalIncome(ss.stud_ref_no, ss.session_code),'0999999.99'))
                    ELSE null
                 END Ben1TotalIncome,
                    CASE
                    WHEN  (SELECT ben_hei_bursary_consent from benefactor_income where ben_id = ss.ben2_id AND SESSION_CODE = SS.SESSION_CODE  ) = 'Y' AND scy.dearing  = 'G'
                        THEN LTRIM(TO_CHAR(sgas.pk_steps_slc.getBenefactor2TotalIncome(ss.stud_ref_no, ss.session_code),'0999999.99'))
                    ELSE null
                 END Ben2TotalIncome,
                  CASE
                        WHEN scy.dearing = 'G' AND ss.stud_hei_bursary_consent = 'Y'
                        THEN LTRIM(TO_CHAR((SELECT AMOUNT FROM AWARD WHERE STUD_AWARD_TYPE = 'TFEL' AND STUD_CRSE_YEAR_ID = scy.stud_crse_year_id),'09999.99'))
                        ELSE null
                        END TotalFeeLoanAvailable, 
                    CASE
                    WHEN  scy.dearing  = 'G' AND ss.stud_hei_bursary_consent = 'Y'
                        THEN LTRIM(TO_CHAR(sgas.pk_steps_slc.getSOSBTotal(ss.stud_ref_no, ss.session_code),'09999.99'))
                    ELSE null
                 END sosb_entitlement,                        
                        scy.session_code, scy.stud_crse_year_id, scy.dearing, scy.stud_ref_no, s.scottish_cand, scy.crse_code, scy.inst_code
                 FROM stud_crse_year scy,
                      stud_session ss,
                      stud s,
                      stud_home_addr sha,
                      inst i,
                      crse c,
                      crse_year cy,
                      award a,
                      stud_award_type sat
                WHERE ss.stud_ref_no = s.stud_ref_no
                  AND sha.stud_ref_no = s.stud_ref_no
                  AND scy.stud_crse_year_id = a.stud_crse_year_id
                  AND sat.stud_award_type = a.stud_award_type
                  AND scy.stud_session_id = ss.stud_session_id
                  AND scy.inst_code = i.inst_code
                  AND scy.crse_id = c.crse_id
                  AND scy.crse_year_id = cy.crse_year_id
                  AND sat.loan_non_loan_fee = 'Loan'
                  AND sha.end_date IS NULL           
                  AND scy.sal_sent = 'Y'
                  AND scy.slc1_sent = 'N'
                  AND scy.sal_dest = '1'
                  AND S.STUD_SUSPEND <> 'Y'
                  AND scy.crse_suspend <> 'Y'
                  AND ss.session_suspend <> 'Y'
                  AND s.suspend_payment <> 'Y'
                  AND scy.application_status IN('C','W')
                  AND (s.suspend_payment = 'N' OR s.suspend_payment IS NULL)
                  AND (scy.slc1_status NOT IN ('E', 'R') OR scy.slc1_status IS NULL)                   
                  AND ( (    scy.loan_given IN ('E', 'F') )
                     OR (    scy.loan_given IN ('D') AND scy.slc1_sent_date IS NOT NULL)
                     OR (    scy.loan_given NOT IN ('A', 'B') AND I.LOCATION_IND != 1 AND SCY.SCHEME_TYPE = 'U'))
                  AND scy.latest_crse_ind = 'Y';
                                                  
   p_file_one := c_file_one;
                         
  END get_slc_file1;
  
    PROCEDURE get_slc_file1_hebbs(p_file_one_hebbs OUT file_one_cursor_hebbs)IS
-------------------------------
-- File 1 Student loan records.(HEBBS version - CR18)
-------------------------------
c_file_one_hebbs       file_one_cursor_hebbs;  
  

BEGIN
  OPEN c_file_one_hebbs FOR   
     
SELECT  DISTINCT CASE
                WHEN scy.provisional_case = 'Y' AND scy.application_status = 'C'
                    THEN 'P'
                WHEN scy.provisional_case = 'N' AND scy.application_status = 'C'
                    THEN 'F'
                WHEN scy.application_status = 'W'
                    THEN 'W'
                ELSE 'X' END Status,
                scy.hei_payment_route AS NonHEIPayRoute,
                CONCAT('SAAS',s.scottish_cand) AS StudSLCRefNo,
                s.ucas_no AS UCASNo, 
                s.prev_loan_acc_no AS PrevStudLoanAccNo,
                CASE
                    WHEN i.hei_inst_code IS NOT NULL
                        THEN sgas.pk_steps_slc.getHEIInstName(i.hei_inst_code)
                    ELSE NULL
                END HEIName,
                CASE
                    WHEN i.hei_inst_code IS NOT NULL
                        THEN SUBSTR(i.hei_inst_code ,0,4)
                    ELSE null
                END HEICode,
                CASE
                    WHEN (cy.hei_crse_code IS NOT NULL AND c.hei_crse_code IS NOT NULL) OR (cy.hei_crse_code IS NOT NULL AND c.hei_crse_code IS NULL)
                        THEN CASE
                                WHEN TRANSLATE(cy.hei_crse_code,
                                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ') IS NULL 
                              THEN LPAD(cy.hei_crse_code, 6, '0')
                              ELSE RPAD(cy.hei_crse_code, 6, ' ')
                        END
                    WHEN cy.hei_crse_code IS NULL AND c.hei_crse_code IS NOT NULL
                        THEN
                            CASE
                                WHEN TRANSLATE(c.hei_crse_code,
                                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ') IS NULL 
                              THEN LPAD(c.hei_crse_code, 6, '0')
                              ELSE RPAD(c.hei_crse_code, 6, ' ')
                        END
                    ELSE null
                END CourseCode,
                scy.crse_year_no AS YearOfCourse,
                CASE 
                    WHEN (SELECT HEI_CRSE_NAME FROM HEI_CRSE@GRASS WHERE HEI_CRSE_CODE = c.hei_crse_code AND HEI_INST_CODE = i.hei_inst_code AND SLC_CODE = 'Y') IS NULL
                        THEN SUBSTR(c.crse_name,0,25)
                    ELSE (SELECT SUBSTR(HEI_CRSE_NAME,0,25) FROM HEI_CRSE@GRASS WHERE HEI_CRSE_CODE = c.hei_crse_code AND HEI_INST_CODE = i.hei_inst_code AND SLC_CODE = 'Y')
                    END CourseName,
                SUBSTR(s.title,0,4) AS Title,
                s.surname AS Surname,
                s.forenames AS Forenames,
                sha.house_no_name,
                sha.addr_l1 AS HomeAddrL1,
                sha.addr_l2 AS HomeAddrL2,
                sha.addr_l3 AS HomeAddrL3,
                sha.addr_l4 AS HomeAddrL4,
                sha.post_code AS PostCode,
                s.sex,
                s.dob AS DOB,
                CASE    
                            WHEN TO_CHAR(scy.withdraw_date, 'MMYYYY') IS NOT NULL
                                THEN TO_CHAR(scy.withdraw_date, 'MMYYYY')
                            WHEN TO_CHAR(CRSE_CHG, 'MMYYYY') IS NOT NULL
                                THEN TO_CHAR(scy.CRSE_CHG,'MMYYYY')
                            ELSE TO_CHAR(SGAS.PK_STEPS_SLC.getCrseEndDate(scy.stud_crse_year_id),'MMYYYY')
                            END CrseEndDate,
                 s.birth_surname AS SurnameAtBirth,
                 s.birth_forenames AS FirstnameAtBirth,
                 SUBSTR(sha.tele_no,0,14) AS HomeTelNo,
                 s.district_birth_cert_issued AS BirthDistrict,
                (SELECT SUBSTR(long_name,0,25) from country where country_code = s.birth_country_code) as BirthCountry,    
                LTRIM(TO_CHAR(sgas.pk_steps_slc.getLivingCostLoanAvailable(scy.stud_crse_year_id),'09999.99')) AS LivingCostLoanAvailable,
                CASE
                    WHEN scy.dearing = 'G' AND ss.stud_hei_bursary_consent = 'Y'
                        THEN ss.stud_hei_bursary_consent
                    ELSE null
                END StudConsent, 
                    (SELECT ben_hei_bursary_consent from benefactor_income where ben_id = ss.ben1_id AND SESSION_CODE = SS.SESSION_CODE) as ben1Consent,
                    (SELECT ben_hei_bursary_consent from benefactor_income where ben_id = ss.ben2_id AND SESSION_CODE = SS.SESSION_CODE) as ben2Consent,
                CASE
                    WHEN scy.dearing  = 'G' AND ss.stud_hei_bursary_consent ='Y'
                        THEN NVL(scy.repeat_year,'N')
                    ELSE null
                END RepeatYear,
                CASE
                    WHEN scy.dearing  = 'G' AND ss.stud_hei_bursary_consent ='Y'
                        THEN 
                                CASE
                            WHEN ss.ben1_id IS NULL AND ss.ben2_id IS NULL
                            THEN 0
                            WHEN ss.ben1_id IS NULL AND ss.ben2_id IS NOT NULL
                            THEN 1
                            WHEN ss.ben1_id IS NOT NULL AND ss.ben2_id IS NULL
                            THEN 1
                            WHEN ss.ben1_id IS NOT NULL AND ss.ben2_id IS NOT NULL
                            THEN 2
                            END
                     ELSE null
                END NoOfBenefactors,
                'Y'as NonMeansTested,
                 CASE
                    WHEN scy.dearing  = 'G' AND ss.stud_hei_bursary_consent ='Y'
                        THEN 
                            CASE
                                WHEN sgas.nmsb_rules_proc_recalc.get_dependants(scy.stud_crse_year_id) > 9
                                THEN 9
                                ELSE sgas.nmsb_rules_proc_recalc.get_dependants(scy.stud_crse_year_id)
                            END
                    ELSE null 
                 END NoOfDependants,
                 CASE
                    WHEN  scy.dearing  = 'G' 
                        THEN LTRIM('0000000.00')
                    ELSE null
                 END ResidHouseIncome,
                 CASE
                    WHEN  (SELECT ben_hei_bursary_consent from benefactor_income where ben_id = ss.ben1_id AND SESSION_CODE = SS.SESSION_CODE ) = 'Y' AND scy.dearing  = 'G'
                        THEN LTRIM(TO_CHAR(sgas.pk_steps_slc.getBenefactor1TotalIncome(ss.stud_ref_no, ss.session_code),'0999999.99'))
                    ELSE null
                 END Ben1TotalIncome,
                    CASE
                    WHEN  (SELECT ben_hei_bursary_consent from benefactor_income where ben_id = ss.ben2_id AND SESSION_CODE = SS.SESSION_CODE  ) = 'Y' AND scy.dearing  = 'G'
                        THEN LTRIM(TO_CHAR(sgas.pk_steps_slc.getBenefactor2TotalIncome(ss.stud_ref_no, ss.session_code),'0999999.99'))
                    ELSE null
                 END Ben2TotalIncome,
                  CASE
                        WHEN scy.dearing = 'G' AND ss.stud_hei_bursary_consent = 'Y'
                        THEN LTRIM(TO_CHAR((SELECT AMOUNT FROM AWARD WHERE STUD_AWARD_TYPE = 'TFEL' AND STUD_CRSE_YEAR_ID = scy.stud_crse_year_id),'09999.99'))
                        ELSE null
                        END TotalFeeLoanAvailable, 
                    CASE
                    WHEN  scy.dearing  = 'G' AND ss.stud_hei_bursary_consent = 'Y'
                        THEN LTRIM(TO_CHAR(sgas.pk_steps_slc.getSOSBTotal(ss.stud_ref_no, ss.session_code),'09999.99'))
                    ELSE null
                 END sosb_entitlement,                        
                        scy.session_code, scy.stud_crse_year_id, scy.dearing, scy.stud_ref_no, s.scottish_cand, scy.crse_code, scy.inst_code
                 FROM stud_crse_year scy,
                      stud_session ss,
                      stud s,
                      stud_home_addr sha,
                      inst i,
                      crse c,
                      crse_year cy,
                      award a,
                      stud_award_type sat
                WHERE ss.stud_ref_no = s.stud_ref_no
                  AND sha.stud_ref_no = s.stud_ref_no
                  AND scy.stud_crse_year_id = a.stud_crse_year_id
                  AND sat.stud_award_type = a.stud_award_type
                  AND scy.stud_session_id = ss.stud_session_id
                  AND scy.inst_code = i.inst_code
                  AND scy.crse_id = c.crse_id
                  AND scy.crse_year_id = cy.crse_year_id
                  --AND sat.loan_non_loan_fee = 'Loan'
                  AND sha.end_date IS NULL           
                  AND scy.sal_sent = 'Y'
                  AND scy.slc1_sent = 'N'
                  AND scy.sal_dest = '1'
                  AND S.STUD_SUSPEND <> 'Y'
                  AND scy.crse_suspend <> 'Y'
                  AND ss.session_suspend <> 'Y'
                  AND s.suspend_payment <> 'Y'
                  AND scy.application_status IN('C','W')
                  AND (s.suspend_payment = 'N' OR s.suspend_payment IS NULL)
                  AND (scy.slc1_status NOT IN ('E', 'R') OR scy.slc1_status IS NULL)                   
                  AND scy.latest_crse_ind = 'Y'
                  AND SCY.DEARING = 'G'
                  AND (A.STUD_AWARD_TYPE = 'CESB' OR SCY.PARENT_CONTRIB_EXEMPT = 'Y')
                  AND SS.SESSION_CODE >= 2021
                  AND ss.stud_hei_bursary_consent = 'Y';
                                               
   p_file_one_hebbs := c_file_one_hebbs;
                         
  END get_slc_file1_hebbs;
  
  
    PROCEDURE get_slc_file2(p_file_two OUT file_two_cursor)IS
-------------------------------
-- File 2 Student loan records.
-------------------------------
c_file_two       file_two_cursor;  
  

BEGIN
  OPEN c_file_two FOR   
     
     SELECT  DISTINCT
        iv_cont1.AcademicYear,
        iv_cont1.StudSLCRefNo,
        iv_cont1.Title,
        iv_cont1.Surname,
        iv_cont1.Forenames,
        iv_cont1.TotalLoanClaimed,
        iv_cont1.h_house_no_name,
        iv_cont1.HomeAddrL1,
        iv_cont1.HomeAddrL2,
        iv_cont1.HomeAddrL3,
        iv_cont1.HomeAddrL4,
        iv_cont1.HomePostCode,
        iv_cont1.HomeTelNo,
        iv_cont1.t_house_no_name,
        iv_cont1.TermAddrL1,
        iv_cont1.TermAddrL2,
        iv_cont1.TermAddrL3,
        iv_cont1.TermAddrL4,
        iv_cont1.TermPostCode,
        iv_cont1.TermTelNo,
        iv_cont1.CorrIndicator,
        iv_cont1.PrevStudLoanAccNo,
        iv_cont1.cont1_name,
        iv_cont1.cont1_rel_code,
        iv_cont1.cont1_addr1,
        iv_cont1.cont1_addr2,
        iv_cont1.cont1_addr3,
        iv_cont1.cont1_post_code,
        iv_cont1.cont1_tel_no,
        iv_cont2.Cont2_name,
        iv_cont2.Cont2_addr1, 
        iv_cont2.Cont2_addr2,
        iv_cont2.Cont2_addr3,
        iv_cont2.Cont2_postcode,
        iv_cont2.Cont2_tel_no,
        iv_cont1.sort_code,
        iv_cont1.account_no,
        iv_cont1.build_soc_no,
        iv_cont1.BankRupt,
        iv_cont1.ni_no,
        iv_cont1.LoanDeclarationDate,
        iv_cont1.LoanPaymentMethod, 
        iv_cont1.scottish_cand, 
        iv_cont1.stud_crse_year_id, 
        iv_cont1.ucas_no, 
        iv_cont1.dearing, 
        iv_cont1.pams_course, 
        iv_cont1.crse_code,
        iv_cont1.inst_code, 
        iv_cont1.stud_ref_no
FROM(   SELECT  DISTINCT scy.session_code AS AcademicYear, 
             CONCAT('SAAS',s.scottish_cand) AS StudSLCRefNo,
             SUBSTR(s.title,0,4) AS Title,
             s.surname AS Surname,
             s.forenames AS Forenames,
             LTRIM(TO_CHAR(sgas.pk_steps_slc.getNetAmountClaimed(scy.stud_crse_year_id),'09999.99'))  AS TotalLoanClaimed,
             sha.house_no_name AS h_house_no_name,
             sha.addr_l1 AS HomeAddrL1,
             sha.addr_l2 AS HomeAddrL2,
             sha.addr_l3 AS HomeAddrL3,
             sha.addr_l4 AS HomeAddrL4,
             sha.post_code AS HomePostCode,
             SUBSTR(sha.tele_no,0,14) AS HomeTelNo,
             sta.house_no_name AS t_house_no_name,
             sta.addr_l1 AS TermAddrL1,
             sta.addr_l2 AS TermAddrL2,
             sta.addr_l3 AS TermAddrL3,
             sta.addr_l4 AS TermAddrL4,
             sta.post_code AS TermPostCode,
             SUBSTR(sta.tele_no,0,14) AS TermTelNo,
             s.ADDR_CORR_FLAG AS CorrIndicator,
             s.prev_loan_acc_no AS PrevStudLoanAccNo,
             scd.cont_name as cont1_name,
             scd.cont_rel_code as cont1_rel_code,
             scd.cont_addr1 as cont1_addr1,
             scd.cont_addr2 as cont1_addr2,
             scd.cont_addr3 as cont1_addr3,
             scd.cont_postcode as cont1_post_code,
             SUBSTR(scd.cont_tel_no,0,14) as cont1_tel_no,
             s.sort_code,
             s.account_no,
             s.build_soc_no,
             NVL(s.bankrupt_flag,'N') AS BankRupt,
             s.ni_no,
             TO_CHAR(ss.loan_declaration_date,'DDMMYYYY') AS LoanDeclarationDate,
             CASE
                WHEN (scy.session_code >= 2007 AND ss.top_option = 'Y' AND scy.scheme_type = 'U')
                    THEN 'A'  --code for payments split across 12 months
                WHEN (scy.session_code >= 2007 AND scy.scheme_type IN('U','P') AND ins.location_ind = 1 AND ss.top_option IN('N', null))
                    THEN 'M'  --code for payments over the length of their course
                 ELSE 'T'  --code for termly payments
             END LoanPaymentMethod, s.scottish_cand, scy.stud_crse_year_id, s.ucas_no, scy.dearing, c.pams_course, scy.crse_code, scy.inst_code, scy.stud_ref_no
                 FROM stud_crse_year scy,
                      stud_session ss,
                      stud s,
                      stud_home_addr sha,
                      award a,
                      stud_award_type sat,
                      stud_term_addr sta,
                      inst ins,
                      crse c,
                      stud_cont_details scd
                WHERE ss.stud_ref_no = s.stud_ref_no
                  AND scy.stud_crse_year_id = a.stud_crse_year_id
                  AND sat.loan_non_loan_fee = 'Loan'
                  AND sha.stud_ref_no = s.stud_ref_no
                  AND scy.stud_session_id = ss.stud_session_id
                  AND a.stud_award_type = sat.stud_award_type
                  AND s.stud_ref_no = sta.stud_ref_no(+)                ---SOME STUDENTS DO NOT HAVE A STUD_TERM_ADDRESS
                  AND scy.inst_code = ins.inst_code
                  AND scy.stud_ref_no = scd.stud_ref_no(+)
                  AND scd.contact_ind(+) = 1
                  AND scy.crse_id = c.crse_id
                  AND sha.end_date IS NULL
                  AND scy.slc2_sent = 'N'
                  AND sta.end_date(+) IS NULL
                  AND scy.loan_given IN ('E','F')
                  AND scy.sal_sent = 'Y'
                  AND scy.slc1_sent = 'Y'
                  AND scy.sal_dest = '1'     
                  AND scy.application_status = 'C'
                  AND S.STUD_SUSPEND <> 'Y'
                  AND scy.crse_suspend <> 'Y'
                  AND ss.session_suspend <> 'Y'
                  AND s.suspend_payment <> 'Y'
                  AND scy.latest_crse_ind = 'Y'
                  AND (   scy.slc2_status NOT IN ('E', 'R')
                       OR scy.slc2_status IS NULL))iv_cont1,
           (SELECT stud.stud_ref_no,
                        scd.cont_name AS Cont2_name,
                        scd.cont_addr1 AS Cont2_addr1, 
                        scd.cont_addr2 AS Cont2_addr2,
                        scd.cont_addr3 AS Cont2_addr3,
                        scd.cont_postcode AS Cont2_postcode,
                        SUBSTR(scd.cont_tel_no,0,14) AS Cont2_tel_no
                   FROM sgas.stud,
                        sgas.stud_cont_details scd  
                  WHERE  stud.stud_ref_no = scd.stud_ref_no(+)
                         AND scd.contact_ind = 2) iv_cont2
    where iv_cont1.stud_ref_no = iv_cont2.stud_ref_no (+);
                                
   p_file_two := c_file_two;
                         
  END get_slc_file2;
  
  PROCEDURE updateFeeLoanTransaction(p_transaction OUT transaction_cursor)IS

  
  c_transaction_cursor    transaction_cursor;
  
  BEGIN
  
  OPEN c_transaction_cursor FOR

  
      SELECT  a.session_code,
            a.stud_ref_no,
            a.stud_crse_year_id,
            ai.net_amount AS txn_amount,
            'D' as txn_dc_flg,
            'P' as txn_type,
            sysdate AS txn_date,
            ai.payment_due_date AS txn_due_date,
            pi.payment_date AS txn_payment_date,
            ai.payment_due_date + 3 AS txn_interest_accural_date,
                'B' as payment_method,
                a.inst_code AS INST_CODE,
                c.bank_sort_code,
                c.account_no,
                ai.campus_id,
                ai.batch_ref,
                pi.payee_payment_id as payment_id,
                null as slc2_filename,
                null as slc2_file_date,
                null as status,
                null as status_changed_date,
                ai.award_instalment_id
    FROM AWARD_INSTALMENT ai, AWARD a, PAYMENT_INSTALMENT pi, campus c
    WHERE ai.AWARD_ID = a.AWARD_ID
    AND ai.award_instalment_id = pi.award_instalment_id
    AND ai.campus_id = c.campus_id
    AND ai.PAYMENT_STATUS = 'S'
    AND ai.net_amount > 0
    AND NVL(ai.FEE_LOAN_TRANSACTION_CREATED,'N') = 'N'
    AND ai.FEE_LOAN_INSTALMENT = 'Y'
    UNION
          SELECT  a.session_code,
            a.stud_ref_no,
            a.stud_crse_year_id,
            ai.net_amount * -1 AS txn_amount,
            'C' AS txn_dc_flg,
            'A' AS txn_type,
            sysdate AS txn_date,
            sysdate AS txn_due_date,
            null as txn_payment_date,
            ai.payment_due_date + 3 AS txn_interest_accural_date,
                'B' as payment_method,
                a.inst_code AS INST_CODE,
                c.bank_sort_code,
                c.account_no,
                ai.campus_id,
                ai.batch_ref,
                null as payment_id,
                null as slc2_filename,
                null as slc2_file_date,
                null as status,
                null as status_changed_date,
                ai.award_instalment_id
    FROM AWARD_INSTALMENT ai, AWARD a, campus c
    WHERE ai.AWARD_ID = a.AWARD_ID
    AND ai.campus_id = c.campus_id
    AND ai.net_amount < 0
    AND NVL(ai.FEE_LOAN_TRANSACTION_CREATED,'N') = 'N'
    AND ai.FEE_LOAN_INSTALMENT = 'Y';
    
    p_transaction := c_transaction_cursor;
    
  
  END updateFeeLoanTransaction;
  
      PROCEDURE get_slc_fileFL1(p_feeLoanfile_one OUT feeLoanfile_one_cursor)IS
-------------------------------
-- File 1 Student loan records.
-------------------------------
c_feeLoanfile_one       feeLoanfile_one_cursor;  
  

BEGIN
  OPEN c_feeLoanfile_one FOR   

                SELECT DISTINCT scy.session_code AS AcademicYear, 
                CASE WHEN scy.application_status = 'C'
                     THEN 'E'
                     WHEN scy.application_status = 'W'
                     THEN 'X'
                     WHEN scy.application_status = 'A'
                     THEN 'C'
                     END Status,
                scy.hei_payment_route AS NonHEIPayRoute,
                CONCAT('SAAS',s.scottish_cand) AS StudSLCRefNo,
                s.ucas_no AS UCASNo, 
                s.prev_loan_acc_no AS PrevStudLoanAccNo,
                CASE
                    WHEN i.hei_inst_code IS NOT NULL
                        THEN sgas.pk_steps_slc.getHEIInstName(i.hei_inst_code)
                    ELSE NULL
                END HEIName,
                CASE
                    WHEN i.hei_inst_code IS NOT NULL
                        THEN SUBSTR(i.hei_inst_code ,0,4)
                    ELSE null
                END HEICode,
                CASE
                    WHEN (cy.hei_crse_code IS NOT NULL AND c.hei_crse_code IS NOT NULL) OR (cy.hei_crse_code IS NOT NULL AND c.hei_crse_code IS NULL)
                        THEN CASE
                                WHEN TRANSLATE(cy.hei_crse_code,
                                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ') IS NULL 
                              THEN LPAD(cy.hei_crse_code, 6, '0')
                              ELSE RPAD(cy.hei_crse_code, 6, ' ')
                        END
                    WHEN cy.hei_crse_code IS NULL AND c.hei_crse_code IS NOT NULL
                        THEN
                            CASE
                                WHEN TRANSLATE(c.hei_crse_code,
                                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ') IS NULL 
                              THEN LPAD(c.hei_crse_code, 6, '0')
                              ELSE RPAD(c.hei_crse_code, 6, ' ')
                        END
                    ELSE null
                END CourseCode,
                scy.crse_year_no AS YearOfCourse,
                CASE 
                    WHEN (SELECT HEI_CRSE_NAME FROM HEI_CRSE@GRASS WHERE HEI_CRSE_CODE = c.hei_crse_code AND HEI_INST_CODE = i.hei_inst_code AND SLC_CODE = 'Y') IS NULL
                        THEN SUBSTR(c.crse_name,0,25)
                    ELSE (SELECT SUBSTR(HEI_CRSE_NAME,0,25) FROM HEI_CRSE@GRASS WHERE HEI_CRSE_CODE = c.hei_crse_code AND HEI_INST_CODE = i.hei_inst_code AND SLC_CODE = 'Y')
                    END CourseName,
                SUBSTR(s.title,0,4) AS Title,
                s.surname AS Surname,
                s.forenames AS Forenames,
                sha.house_no_name,
                sha.addr_l1 AS HomeAddrL1,
                sha.addr_l2 AS HomeAddrL2,
                sha.addr_l3 AS HomeAddrL3,
                sha.addr_l4 AS HomeAddrL4,
                sha.post_code AS PostCode,
                s.sex,
                s.dob AS DOB,
                CASE    
                            WHEN TO_CHAR(scy.withdraw_date, 'MMYYYY') IS NOT NULL
                                THEN TO_CHAR(scy.withdraw_date, 'MMYYYY')
                            WHEN TO_CHAR(CRSE_CHG, 'MMYYYY') IS NOT NULL
                                THEN TO_CHAR(scy.CRSE_CHG,'MMYYYY')
                            ELSE TO_CHAR(getCrseEndDate(scy.stud_crse_year_id),'MMYYYY')
                            END CrseEndDate,
                 s.birth_surname AS SurnameAtBirth,
                 s.birth_forenames AS FirstnameAtBirth,
                 SUBSTR(sha.tele_no,0,14) AS HomeTelNo,
                 s.district_birth_cert_issued AS BirthDistrict,
                (SELECT SUBSTR(long_name,0,25) from country where country_code = s.birth_country_code) as BirthCountry,   
                '0000.00' AS LivingCostLoanAvailable,           
                CASE
                    WHEN scy.dearing = 'G' AND ss.stud_hei_bursary_consent = 'Y'
                        THEN ss.stud_hei_bursary_consent
                    ELSE null
                END StudConsent, 
                (SELECT ben_hei_bursary_consent from benefactor_income where ben_id = ss.ben1_id AND SESSION_CODE = SS.SESSION_CODE) as ben1Consent,
                (SELECT ben_hei_bursary_consent from benefactor_income where ben_id = ss.ben2_id AND SESSION_CODE = SS.SESSION_CODE) as ben2Consent,
                CASE
                    WHEN scy.dearing  = 'G' AND ss.stud_hei_bursary_consent ='Y'
                        THEN NVL(scy.repeat_year,'N')
                    ELSE null
                END RepeatYear,
                CASE
                    WHEN scy.dearing  = 'G' AND ss.stud_hei_bursary_consent ='Y'
                        THEN 
                                CASE
                            WHEN ss.ben1_id IS NULL AND ss.ben2_id IS NULL
                            THEN 0
                            WHEN ss.ben1_id IS NULL AND ss.ben2_id IS NOT NULL
                            THEN 1
                            WHEN ss.ben1_id IS NOT NULL AND ss.ben2_id IS NULL
                            THEN 1
                            WHEN ss.ben1_id IS NOT NULL AND ss.ben2_id IS NOT NULL
                            THEN 2
                            END
                     ELSE null
                END NoOfBenefactors,
                CASE
                    WHEN scy.dearing  = 'G' AND ss.stud_hei_bursary_consent ='Y'
                        THEN 
                                  CASE
                                        WHEN scy.award = 'E'
                                        THEN 'N'
                                        ELSE 'Y'
                                  END 
                    ELSE null
                 END NonMeansTested,
                 CASE
                    WHEN scy.dearing  = 'G' AND ss.stud_hei_bursary_consent ='Y'
                        THEN 
                            CASE
                                WHEN sgas.nmsb_rules_proc_recalc.get_dependants(scy.stud_crse_year_id) > 9
                                THEN 9
                                ELSE sgas.nmsb_rules_proc_recalc.get_dependants(scy.stud_crse_year_id)
                            END
                    ELSE null 
                 END NoOfDependants,
                 CASE
                    WHEN  scy.dearing  = 'G'
                        THEN LTRIM(TO_CHAR(sgas.pk_steps_slc.getHouseHoldResidential(ss.stud_ref_no, ss.session_code),'0999999.99'))
                    ELSE null
                 END ResidHouseIncome,
                 CASE
                    WHEN  (SELECT ben_hei_bursary_consent from benefactor_income where ben_id = ss.ben1_id AND session_code = ss.session_code ) = 'Y' AND scy.dearing  = 'G'
                        THEN LTRIM(TO_CHAR(sgas.pk_steps_slc.getBenefactor1TotalIncome(ss.stud_ref_no, ss.session_code),'0999999.99'))
                    ELSE null
                 END Ben1TotalIncome,
                    CASE
                    WHEN  (SELECT ben_hei_bursary_consent from benefactor_income where ben_id = ss.ben2_id AND session_code = ss.session_code) = 'Y' AND scy.dearing  = 'G'
                        THEN LTRIM(TO_CHAR(sgas.pk_steps_slc.getBenefactor2TotalIncome(ss.stud_ref_no, ss.session_code),'0999999.99'))
                    ELSE null
                 END Ben2TotalIncome,
                  CASE
                        WHEN scy.dearing = 'G' AND ss.stud_hei_bursary_consent = 'Y'
                        THEN LTRIM(TO_CHAR((SELECT AMOUNT FROM AWARD WHERE STUD_AWARD_TYPE = 'TFEL' AND STUD_CRSE_YEAR_ID = scy.stud_crse_year_id),'09999.99'))
                        ELSE null
                        END TotalFeeLoanAvailable, 
                    CASE
                    WHEN  scy.dearing  = 'G' AND ss.stud_hei_bursary_consent = 'Y'
                        THEN LTRIM(TO_CHAR(sgas.pk_steps_slc.getSOSBTotal(ss.stud_ref_no, ss.session_code),'09999.99'))
                    ELSE null
                 END sosb_entitlement,                        
                        scy.stud_crse_year_id, scy.dearing, scy.stud_ref_no, s.scottish_cand, scy.crse_code, scy.inst_code,
                        sgas.pk_steps_slc.getFeeSLCInclude(scy.stud_ref_no, scy.session_code) AS SLCInclude                                                      
                FROM STUD_CRSE_YEAR scy, STUD s, STUD_SESSION ss, AWARD a, STUD_HOME_ADDR sha, fee_loan_transaction flt, crse c, inst i, crse_year cy
                WHERE scy.stud_ref_no = s.stud_ref_no
                AND scy.crse_id = c.crse_id
                AND scy.crse_year_id = cy.crse_year_id
                AND scy.inst_code = i.inst_code
                AND scy.stud_session_id = ss.stud_session_id
                AND scy.stud_crse_year_id = a.stud_crse_year_id
                AND s.stud_ref_no = sha.stud_ref_no
                AND sha.end_date IS NULL
                AND flt.stud_crse_year_id = scy.stud_crse_year_id
                AND a.stud_award_type = 'TFEL'
                AND scy.sal_sent = 'Y'
                AND ss.slc1_fl_sent = 'N'
                AND (flt.STATUS IS NULL OR flt.STATUS = 'C')
                AND scy.APPLICATION_STATUS IN('A','W','C');
                                               
   p_feeLoanfile_one := c_feeLoanfile_one;
                         
  END get_slc_fileFL1;
  
  
    PROCEDURE get_slc_filefeeLoan(p_file_feeLoan OUT file_feeLoan_cursor)IS
-------------------------------
-- File 1 Student loan records.
-------------------------------
c_file_feeLoan       file_feeLoan_cursor;  
  

BEGIN
  OPEN c_file_feeLoan FOR   
     
  
       SELECT  
        iv_cont1.AcademicYear,
        iv_cont1.StudSLCRefNo,
        iv_cont1.Title,
        iv_cont1.Surname,
        iv_cont1.Forenames,
        iv_cont1.TotalLoanClaimed,
        iv_cont1.h_house_no_name,
        iv_cont1.HomeAddrL1,
        iv_cont1.HomeAddrL2,
        iv_cont1.HomeAddrL3,
        iv_cont1.HomeAddrL4,
        iv_cont1.HomePostCode,
        iv_cont1.HomeTelNo,
        iv_cont1.t_house_no_name,
        iv_cont1.TermAddrL1,
        iv_cont1.TermAddrL2,
        iv_cont1.TermAddrL3,
        iv_cont1.TermAddrL4,
        iv_cont1.TermPostCode,
        iv_cont1.TermTelNo,
        iv_cont1.CorrIndicator,
        iv_cont1.PrevStudLoanAccNo,
        iv_cont1.cont1_name,
        iv_cont1.cont1_rel_code,
        iv_cont1.cont1_addr1,
        iv_cont1.cont1_addr2,
        iv_cont1.cont1_addr3,
        iv_cont1.cont1_post_code,
        iv_cont1.cont1_tel_no,
        iv_cont2.Cont2_name,
        iv_cont2.Cont2_addr1, 
        iv_cont2.Cont2_addr2,
        iv_cont2.Cont2_addr3,
        iv_cont2.Cont2_postcode,
        iv_cont2.Cont2_tel_no,
        iv_cont1.build_soc_no,
        iv_cont1.BankRupt,
        iv_cont1.ni_no,
        iv_cont1.LoanDeclarationDate,
        iv_cont1.FeeLoanIntAcDate,
        iv_cont1.FeeLoanPayment,
        iv_cont1.DebitOrCredit,
        iv_cont1.TotalFeeAmount,
        iv_cont1.scottish_cand, 
        iv_cont1.stud_crse_year_id, 
        iv_cont1.ucas_no, 
        iv_cont1.dearing, 
        iv_cont1.pams_course, 
        iv_cont1.crse_code,
        iv_cont1.inst_code, 
        iv_cont1.stud_ref_no
     --   iv_cont1.slcInclude
FROM(   SELECT  DISTINCT scy.session_code AS AcademicYear, 
             CONCAT('SAAS',s.scottish_cand) AS StudSLCRefNo,
             SUBSTR(s.title,0,4) AS Title,
             s.surname AS Surname,
             s.forenames AS Forenames,
             '0000.00' AS TotalLoanClaimed,
             sha.house_no_name AS h_house_no_name,
             sha.addr_l1 AS HomeAddrL1,
             sha.addr_l2 AS HomeAddrL2,
             sha.addr_l3 AS HomeAddrL3,
             sha.addr_l4 AS HomeAddrL4,
             sha.post_code AS HomePostCode,
             SUBSTR(sha.tele_no,0,14) AS HomeTelNo,
             sta.house_no_name AS t_house_no_name,
             sta.addr_l1 AS TermAddrL1,
             sta.addr_l2 AS TermAddrL2,
             sta.addr_l3 AS TermAddrL3,
             sta.addr_l4 AS TermAddrL4,
             sta.post_code AS TermPostCode,
             SUBSTR(sta.tele_no,0,14) AS TermTelNo,
             s.ADDR_CORR_FLAG AS CorrIndicator,
             s.prev_loan_acc_no AS PrevStudLoanAccNo,
             scd.cont_name as cont1_name,
             scd.cont_rel_code as cont1_rel_code,
             scd.cont_addr1 as cont1_addr1,
             scd.cont_addr2 as cont1_addr2,
             scd.cont_addr3 as cont1_addr3,
             scd.cont_postcode as cont1_post_code,
             SUBSTR(scd.cont_tel_no,0,14) as cont1_tel_no,
             s.build_soc_no,
             NVL(s.bankrupt_flag,'N') AS BankRupt,
             s.ni_no,
             TO_CHAR(ss.fee_loan_declaration_date,'DDMMYYYY') AS LoanDeclarationDate,
             TO_CHAR(flt.txn_interest_accrual_date,'DDMMYYYY') AS FeeLoanIntAcDate,
             LTRIM(TO_CHAR(sgas.pk_steps_slc.getFeeLoanPayment(scy.stud_ref_no, scy.session_code),'09999.99')) AS FeeLoanPayment,
             CASE
                WHEN sgas.pk_steps_slc.getFeeLoanIntAccrual (scy.stud_ref_no, scy.session_code) = 'C'
                    THEN 'CR'
                ELSE 'DR'
             END DebitOrCredit,
             LTRIM(TO_CHAR(sgas.pk_steps_slc.getFeeLoanAmount(scy.stud_ref_no, scy.session_code),'09999.99')) AS TotalFeeAmount,                            ----FUNCTION REQUIRED HERE TO CALCULATE 
            s.scottish_cand, scy.stud_crse_year_id, s.ucas_no, scy.dearing, c.pams_course, scy.crse_code, scy.inst_code, scy.stud_ref_no 
           -- sgas.pk_steps_slc.getFeeSLCInclude(scy.stud_crse_year_id) AS SLCInclude
                 FROM stud_crse_year scy,
                      stud_session ss,
                      stud s,
                      stud_home_addr sha,
                      stud_term_addr sta,
                      inst ins,
                      crse c,
                      stud_cont_details scd,
                      fee_loan_transaction flt
                WHERE ss.stud_ref_no = s.stud_ref_no
                  AND sha.stud_ref_no = s.stud_ref_no
                  AND scy.stud_session_id = ss.stud_session_id
                  AND s.stud_ref_no = sta.stud_ref_no(+)                ---SOME STUDENTS DO NOT HAVE A STUD_TERM_ADDRESS
                  AND scy.inst_code = ins.inst_code
                  AND scy.stud_ref_no = scd.stud_ref_no(+)
                  AND scy.stud_crse_year_id = flt.stud_crse_year_id
                  AND scd.contact_ind(+) = 1
                  AND scy.crse_id = c.crse_id
                  AND sha.end_date IS NULL
                  AND sta.end_date(+) IS NULL
                  AND scy.sal_sent = 'Y'
                  AND ss.slc1_fl_sent = 'Y'
                  AND (flt.STATUS IS NULL OR flt.STATUS = 'C')) iv_cont1,
           (SELECT stud.stud_ref_no,
                        scd.cont_name AS Cont2_name,
                        scd.cont_addr1 AS Cont2_addr1, 
                        scd.cont_addr2 AS Cont2_addr2,
                        scd.cont_addr3 AS Cont2_addr3,
                        scd.cont_postcode AS Cont2_postcode,
                        SUBSTR(scd.cont_tel_no,0,14) AS Cont2_tel_no
                   FROM sgas.stud,
                        sgas.stud_cont_details scd  
                  WHERE  stud.stud_ref_no = scd.stud_ref_no(+)
                         AND scd.contact_ind = 2) iv_cont2
    where iv_cont1.stud_ref_no = iv_cont2.stud_ref_no (+);
                                
   p_file_feeLoan := c_file_feeLoan;
                         
  END get_slc_filefeeLoan;
  
 
  
  PROCEDURE update_stud_crse_yr_slc_status (p_stud_crse_yr_id NUMBER)
   AS
   
   v_first_slc1_sent_date   stud_crse_year.first_slc1_sent_date%TYPE;
        
        
   BEGIN
      SELECT first_slc1_sent_date INTO v_first_slc1_sent_date from stud_crse_year WHERE stud_crse_year_id = p_stud_crse_yr_id;  
   
      UPDATE stud_crse_year
         SET slc1_sent = 'Y',
             slc1_status = 'S',
             slc1_sent_date = SYSDATE
       WHERE stud_crse_year_id = p_stud_crse_yr_id;
    
        
        
        IF v_first_slc1_sent_date IS NULL
      THEN
        UPDATE stud_crse_year
         SET first_slc1_sent_date = SYSDATE
       WHERE stud_crse_year_id = p_stud_crse_yr_id;
      END IF;
       
   END update_stud_crse_yr_slc_status;
   
   PROCEDURE updatedatabaseAmounts
   IS
   

     
     
       CURSOR c_awards
     IS
        SELECT 
        CASE
                    WHEN  scy.dearing  = 'G'
                        THEN LTRIM(TO_CHAR(sgas.pk_steps_slc.getHouseHoldResidential(scy.stud_ref_no, scy.session_code),'0999999.99'))
                    ELSE null
                 END ResidHouseIncome,
                 CASE
                    WHEN  (SELECT ben_hei_bursary_consent from benefactor_income where ben_id = ss.ben1_id AND SESSION_CODE = scy.SESSION_CODE ) = 'Y' AND scy.dearing  = 'G'
                        THEN LTRIM(TO_CHAR(sgas.pk_steps_slc.getBenefactor1TotalIncome(scy.stud_ref_no, scy.session_code),'0999999.99'))
                    ELSE null
                 END Ben1TotalIncome,
                    CASE
                    WHEN  (SELECT ben_hei_bursary_consent from benefactor_income where ben_id = ss.ben2_id AND SESSION_CODE = scy.SESSION_CODE  ) = 'Y' AND scy.dearing  = 'G'
                        THEN LTRIM(TO_CHAR(sgas.pk_steps_slc.getBenefactor2TotalIncome(scy.stud_ref_no, scy.session_code),'0999999.99'))
                    ELSE null
                 END Ben2TotalIncome,
                    CASE
                    WHEN  scy.dearing  = 'G' AND ss.stud_hei_bursary_consent = 'Y'
                        THEN LTRIM(TO_CHAR(sgas.pk_steps_slc.getSOSBTotal(scy.stud_ref_no, scy.session_code),'09999.99'))
                    ELSE null
                 END sosb_entitlement, scy.stud_ref_no, scy.session_code
                 FROM stud_crse_year scy, stud_session ss
                 WHERE scy.dearing = 'G'
                 AND ss.stud_session_id = scy.stud_session_id
                 AND scy.APPLICATION_STATUS = 'C'
                 AND scy.SAL_SENT = 'Y'
                 AND scy.SLC1_SENT = 'N';
                 
                      v_awards        c_awards%ROWTYPE;    
     
     
     BEGIN
     
     OPEN c_awards;
     
     LOOP
     
     FETCH c_awards
     INTO v_awards;
     
        EXIT WHEN c_awards%NOTFOUND;
     
                    IF v_awards.ResidHouseIncome IS NOT NULL
                    THEN
                            UPDATE STUD_CRSE_YEAR
                            SET HOUSEHOLD_RESID_INCOME = v_awards.ResidHouseIncome
                            WHERE STUD_REF_NO = v_awards.stud_ref_no
                            AND SESSION_CODE = v_awards.session_code;
                            
                    END IF;
                    
                    IF v_awards.Ben1TotalIncome IS NOT NULL
                    THEN
                            UPDATE STUD_CRSE_YEAR
                            SET BEN1_TOTAL_INCOME = v_awards.Ben1TotalIncome
                            WHERE STUD_REF_NO = v_awards.stud_ref_no
                            AND SESSION_CODE = v_awards.session_code;
                            
                    END IF;
                    
                    IF v_awards.Ben2TotalIncome IS NOT NULL
                    THEN
                            UPDATE STUD_CRSE_YEAR
                            SET BEN2_TOTAL_INCOME = v_awards.Ben2TotalIncome
                            WHERE STUD_REF_NO = v_awards.stud_ref_no
                            AND SESSION_CODE = v_awards.session_code;
                            
                    END IF;
                    
                    IF v_awards.sosb_entitlement IS NOT NULL
                    THEN  
                            UPDATE STUD_SESSION
                            SET SOSB_ENTITLEMENT = v_awards.sosb_entitlement
                            WHERE STUD_REF_NO = v_awards.stud_ref_no
                            AND SESSION_CODE = v_awards.session_code;
                    END IF;
                             
     END LOOP;

     CLOSE c_awards;
     
     END updatedatabaseAmounts;
  
   

  
END PK_STEPS_SLC;
/