CREATE OR REPLACE PACKAGE BODY SGAS.pk_payments
AS
/******************************************************************************
   NAME:       SELECT_FEE_INSTALMENTS
   PURPOSE:    Picks up data required for FEE Payments

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/02/2010 Paul Hughes    1. Created
   1.1        20/05/2010 John Penman    2. Modified select statement for new
                                           mappings and remove old columns for
                                           mappings
   1.2        27/05/2010 John Penman    3. Created checkBatchExists function        
   1.3        22/06/2010 Paul Hughes    4.  cursor SCOAP_PAYMENTS REF3 changed to use payee_payment_id      
   1.4        11/11/2010 Paul Hughes    5.  Aggregate Procedure is updated to handle debt.                             
******************************************************************************/

 

FUNCTION countvariationAwards (p_days_ahead_bacs IN NUMBER, p_days_ahead_cheque IN NUMBER) RETURN NUMBER

IS

        variationAwards NUMBER(9);
        
BEGIN

         SELECT COUNT(DISTINCT ai.payment_due_date||ai.method)+1 --||ai.payee)
           INTO variationAwards
            FROM award_instalment ai, award a, stud_crse_year scy, stud s, stud_award_type sat, stud_session st, dsa_payment dsa, nominee n
          WHERE ai.award_id = a.award_id
            AND ai.award_instalment_id = dsa.award_instalment_id(+)
            AND dsa.payee_id = n.nominee_id(+)
            AND a.stud_award_type = sat.stud_award_type
            AND st.stud_session_id = scy.stud_session_id
            AND a.stud_crse_year_id = scy.stud_crse_year_id
            AND scy.stud_ref_no = s.stud_ref_no
            AND a.award_src = 'A'
            AND ai.payment_status = 'U'
            AND ai.net_amount > 0
            AND s.suspend_payment = 'N'
            AND s.stud_suspend = 'N'
            AND st.session_suspend = 'N'
            AND scy.crse_suspend = 'N'                                           ----WE REQUIRE JOIN TO DSA TABLE TO IMPLEMENT DSA PAYMENT STOP CODE HERE
            AND (   (    TRUNC (ai.payment_due_date) <=
                            TRUNC
                               (SYSDATE + p_days_ahead_bacs)
                               --CONFIG NUMBER OF DAYS AHEAD FOR BACS PAYMENTS
                     AND ai.method = 'B'
                     AND ai.payment_due_date >= sysdate + (select nval from config_data where item_name = 'BACS_PROCESS_DAYS')
                    )
                 OR (    TRUNC (ai.payment_due_date) <=
                            TRUNC
                               (SYSDATE + p_days_ahead_cheque)
                             --CONFIG NUMBER OF DAYS AHEAD FOR CHEQUE PAYMENTS
                     AND ai.method = 'C'
                     AND ai.payment_due_date >= sysdate + (select nval from config_data where item_name = 'CHEQUE_PROCESS_DAYS')
                    )
                );
                
     RETURN variationAwards;
     
END countvariationAwards;


---VARIATION IN FEES IS ALWAYS ONE AS THEY ARE ALL SAME PAYMENT DATE AND SAME BATCH
FUNCTION countvariationFees (p_pay_due_days_ahead IN NUMBER) RETURN NUMBER

IS

        variationfees NUMBER(9);
        
BEGIN

         SELECT COUNT(DISTINCT ai.payment_due_date||ai.method)
           INTO variationfees
           FROM award_instalment ai, award a, stud_crse_year scy, campus d, stud_award_type sat, stud_session st, stud s
          WHERE ai.award_id = a.award_id
            AND s.stud_ref_no = st.stud_ref_no
            AND a.stud_award_type = sat.stud_award_type
            AND a.stud_crse_year_id = scy.stud_crse_year_id
            AND scy.stud_session_id = st.stud_session_id
            AND ai.campus_id = d.campus_id(+)
            AND a.award_src = 'T'
            AND s.suspend_payment = 'N'
            AND s.stud_suspend = 'N'
            AND st.session_suspend = 'N'
            AND scy.crse_suspend = 'N'
            AND TRUNC (ai.payment_due_date) <= TRUNC (SYSDATE + p_pay_due_days_ahead)
            --CONFIG NUMBER OF DAYS HERE FOR BACS TAKEN FROM CONFIG_DATA VALUE
            AND ai.payment_status = 'U'
            AND ai.net_amount IS NOT NULL;
                
     RETURN variationFees;
     
END countvariationFees;

FUNCTION countFeePayments (p_pay_due_days_ahead IN NUMBER) RETURN NUMBER

IS

            totalFees NUMBER(9);

BEGIN

 
         SELECT COUNT(*)
           INTO totalFees
           FROM award_instalment ai, award a, stud_crse_year scy, campus d, stud_award_type sat, stud_session st, stud s
          WHERE ai.award_id = a.award_id
            AND s.stud_ref_no = st.stud_ref_no
            AND a.stud_award_type = sat.stud_award_type
            AND a.stud_crse_year_id = scy.stud_crse_year_id
            AND scy.stud_session_id = st.stud_session_id
            AND ai.campus_id = d.campus_id(+)
            AND a.award_src = 'T'
            AND s.suspend_payment = 'N'
            AND s.stud_suspend = 'N'
            AND st.session_suspend = 'N'
            AND scy.crse_suspend = 'N'
            AND TRUNC (ai.payment_due_date) <= TRUNC (SYSDATE + p_pay_due_days_ahead)
            --CONFIG NUMBER OF DAYS HERE FOR BACS TAKEN FROM CONFIG_DATA VALUE
            AND ai.payment_status = 'U'
            AND ai.net_amount IS NOT NULL;
                
   RETURN totalFees;

END countFeePayments;




FUNCTION countAwardPayments (p_days_ahead_bacs IN NUMBER, p_days_ahead_cheque IN NUMBER) RETURN NUMBER

IS

            totalAwards NUMBER(9);

BEGIN

 SELECT    COUNT(*)
            INTO totalAwards
          FROM award_instalment ai, award a, stud_crse_year scy, stud s, stud_award_type sat, stud_session st, dsa_payment dsa, nominee n
          WHERE ai.award_id = a.award_id
            AND ai.award_instalment_id = dsa.award_instalment_id(+)
            AND dsa.payee_id = n.nominee_id(+)
            AND a.stud_award_type = sat.stud_award_type
            AND st.stud_session_id = scy.stud_session_id
            AND a.stud_crse_year_id = scy.stud_crse_year_id
            AND scy.stud_ref_no = s.stud_ref_no
            AND a.award_src = 'A'
            AND ai.payment_status = 'U'
            AND ai.net_amount > 0
            AND s.suspend_payment = 'N'
            AND s.stud_suspend = 'N'
            AND st.session_suspend = 'N'
            AND scy.crse_suspend = 'N'                                           ----WE REQUIRE JOIN TO DSA TABLE TO IMPLEMENT DSA PAYMENT STOP CODE HERE
            AND (   (    TRUNC (ai.payment_due_date) <=
                            TRUNC
                               (SYSDATE + p_days_ahead_bacs)
                               --CONFIG NUMBER OF DAYS AHEAD FOR BACS PAYMENTS
                     AND ai.method = 'B'
                    )
                 OR (    TRUNC (ai.payment_due_date) <=
                            TRUNC
                               (SYSDATE + p_days_ahead_cheque)
                             --CONFIG NUMBER OF DAYS AHEAD FOR CHEQUE PAYMENTS
                     AND ai.method = 'C'
                    )
                );
                
   RETURN totalAwards;

END countAwardPayments;
    
FUNCTION getPaymentNumber(p_award_instalment_id IN NUMBER, p_stud_ref_no IN NUMBER, p_session_code IN NUMBER) RETURN NUMBER
IS

    x             NUMBER(4);
    v_payment_due_date  DATE;
    l_paymentInstalment NUMBER := 0;

         CURSOR c_payment
      IS
      
            SELECT DISTINCT a.payment_due_date
            FROM award_instalment a, award b
            WHERE a.award_id = b.award_id
            AND b.stud_ref_no = p_stud_ref_no
            AND b.session_code = p_session_code
            AND b.award_src = 'A'
            ORDER by a.payment_due_date;
          
                  v_payment    c_payment%ROWTYPE;
    
    BEGIN
    
            SELECT payment_due_date
            INTO v_payment_due_date
            FROM AWARD_INSTALMENT
            WHERE award_instalment_id = p_award_instalment_id;
    
  
    OPEN c_payment;
    
        x := 0;    
    
        LOOP 
                
            x := x + 1;

            FETCH c_payment
            INTO v_payment;
            
            EXIT WHEN c_payment%NOTFOUND;
            
            
            IF v_payment.payment_due_date = v_payment_due_date
            THEN l_paymentInstalment := x;
            END IF;
            
            
            
           END LOOP;
         
         CLOSE c_payment;
            

    RETURN l_paymentInstalment;
    
    END getPaymentNumber;     

    
FUNCTION checkNumberOfPaidAwards(p_award_instalment_id IN NUMBER) RETURN NUMBER

IS

    paidaward           NUMBER :=0;
    v_stud_ref_no       NUMBER :=0;
    v_session_code      NUMBER :=0;
    
    BEGIN
    
    SELECT a.stud_ref_no, a.session_code
    INTO v_stud_ref_no, v_session_code
    FROM AWARD a, AWARD_INSTALMENT AI
    WHERE A.AWARD_ID = AI.AWARD_ID
    AND AWARD_INSTALMENT_ID = p_award_instalment_id;
    
    
    select count(ai.award_instalment_id)
    INTO paidaward
    from award_instalment ai, award a
    where ai.award_id = a.award_id
    and a.award_src = 'A'           ---WE ONLY WANT TO COUNT IF AWARD PAYMENTS HAVE BEEN MADE
    and ai.award_instalment_id = p_award_instalment_id
    and ai.batch_ref IS NOT NULL
    and ai.payment_status IS NULL;
    
    RETURN paidaward;
    
    END checkNumberOfPaidAwards;
    
FUNCTION checkBatchExists(p_payment_date IN VARCHAR2, 
                            p_method IN VARCHAR2, p_payee IN VARCHAR2, p_max_batch_payments IN NUMBER) RETURN VARCHAR2
   IS
   
    batch_ref VARCHAR2(100) := 'N';
    batch_ref_temp NUMBER  := 0;
    batch_ref_temp2 NUMBER  := 0;
   BEGIN 
   
   select COUNT(*)
   INTO batch_ref_temp
   from scoap_batches sb, payment_instalment pi
   WHERE sb.dpb_batch_ref = pi.batch_ref
   AND trunc(sb.dpb_batch_creation_date) = trunc(sysdate)                      ---WE ONLY WANT TO CHECK PAYMENTS DONE TODAY
   AND trunc(sb.dpb_payment_date) = trunc(to_date(p_payment_date, 'DD/MM/YYYY')) ---BATCH LIMITED BY UNIQUE PAYMENT DUE DATE
   AND sb.dpb_type = p_payee    ---- INPUT TO SERVICE TO INDICATE S (STUDENT OR 'I' INSTITUTION)  NOTE DSA PAYMENTS ARE SET TO 'S'
   AND sb.dpb_payment_type = p_method  ---WE WANT TO COUNT OTHER CHEQUE OR BACS PAYMENTS
   AND pi.payment_status = 'A'
   AND rownum = 1
   GROUP BY pi.batch_ref
   having count(pi.award_instalment_id) < p_max_batch_payments; 

    
            IF    batch_ref_temp > 0
            
                    THEN
            
                               SELECT sb.dpb_batch_ref
                               INTO batch_ref
                               from scoap_batches sb, payment_instalment pi
                                WHERE sb.dpb_batch_ref = pi.batch_ref
                               AND trunc(sb.dpb_batch_creation_date) = trunc(sysdate)                      ---WE ONLY WANT TO CHECK PAYMENTS DONE TODAY
                               AND trunc(sb.dpb_payment_date) = trunc(to_date(p_payment_date, 'DD/MM/YYYY')) ---BATCH LIMITED BY UNIQUE PAYMENT DUE DATE
                               AND sb.dpb_type = p_payee     ---- INPUT TO SERVICE TO INDICATE S (STUDENT OR 'I' INSTITUTION)  NOTE DSA PAYMENTS ARE SET TO 'S'
                               AND sb.dpb_payment_type = p_method  ---WE WANT TO COUNT OTHER CHEQUE OR BACS PAYMENTS
                               AND pi.payment_status = 'A'
                               AND rownum = 1
                                                group by sb.dpb_batch_ref
                                                having count(pi.award_instalment_id) < p_max_batch_payments; 
                                                
   
                
                    ELSE batch_ref := 'FALSE';
                    
                      
            END IF;
            
        RETURN batch_ref;
            
          EXCEPTION
        WHEN NO_DATA_FOUND THEN
           batch_ref := 'FALSE';   
           
           RETURN batch_ref;
            
           
   END checkBatchExists;                 
   


   PROCEDURE select_fee_instalments (
      p_pay_due_days_ahead    IN       NUMBER,
      p_fees_paymenttype     IN OUT   fees_cur
   )
   IS
   BEGIN
      OPEN p_fees_paymenttype FOR
      
         SELECT d.NAME AS account_name, 
                d.account_no, 
                sat.account_name AS account,
                scy.attend_confirmed,
                ai.award_instalment_id, 
                ai.campus_id, 
                sat.cost_centre,
                a.dsa_allowance_id, 
                ai.dsa_fee_instalment,   
                sat.entity,
                scy.inst_code,
                ai.method, 
                ai.net_amount, 
                '1' AS nominee_id, 
                ai.payee, 
                ai.payment_addr,
                TO_CHAR (ai.payment_due_date,
                         'DD-MM-YYYY'
                        ) AS payment_due_date,
                d.payment_method AS campus_method, 
                sat.programme,
                a.session_code,
                d.bank_sort_code, 
                a.stud_award_type, 
                a.stud_crse_year_id,
                a.stud_ref_no, '02' as sub_type, 
                ai.trav_amount,
                CASE
                    WHEN a.stud_award_type = 'FEES'
                        THEN 'F'
                    WHEN a.stud_award_type = 'TFEL'
                        THEN 'L'
                    ELSE 'A'
                END AS fee_type
           FROM award_instalment ai, award a, stud_crse_year scy, campus d, stud_award_type sat, stud_session st, stud s
          WHERE ai.award_id = a.award_id
            AND s.stud_ref_no = st.stud_ref_no
            AND a.stud_award_type = sat.stud_award_type
            AND a.stud_crse_year_id = scy.stud_crse_year_id
            AND scy.stud_session_id = st.stud_session_id
            AND ai.campus_id = d.campus_id(+)
            AND a.award_src = 'T'
            AND s.suspend_payment = 'N'
            AND s.stud_suspend = 'N'
            AND st.session_suspend = 'N'
            AND scy.crse_suspend = 'N'
            AND TRUNC (ai.payment_due_date) <= TRUNC (SYSDATE + p_pay_due_days_ahead)
            --CONFIG NUMBER OF DAYS HERE FOR BACS TAKEN FROM CONFIG_DATA VALUE
            AND ai.payment_status = 'U'
            AND ai.net_amount IS NOT NULL;
            
   END select_fee_instalments;
   
   
      PROCEDURE select_award_payments (
      p_days_ahead_bacs      IN       NUMBER,
      p_days_ahead_cheque    IN       NUMBER,
      p_awards_paymenttype   IN OUT   awards_cur
   )
   IS
   
   bacs_process_days      NUMBER(2);
   cheque_process_days    NUMBER(2);
   
   BEGIN
   
   SELECT nval 
   INTO bacs_process_days
   from config_data
   where item_name = 'BACS_PROCESS_DAYS';
   
   SELECT nval 
   INTO cheque_process_days
   from config_data
   where item_name = 'CHEQUE_PROCESS_DAYS';
     
      OPEN p_awards_paymenttype FOR
      
                    SELECT CASE
                   WHEN ai.payee = 'S'
                      THEN s.forenames || ' ' || s.surname
                   WHEN ai.payee = 'N'
                      THEN n.forename || ' ' || n.surname
                   ELSE 'DSA SPEAK TO KERRY'
                END AS account_name,
                CASE
                   WHEN ai.payee = 'S' --AND s.payment_method = 'B'
                      THEN s.account_no
                   WHEN ai.payee = 'N' --AND ai.method = 'B'
                      THEN n.account_no   
                   ELSE null
                END AS account_no,
                sat.account_name AS account, 
                scy.attend_confirmed, ai.award_instalment_id, ai.campus_id, 
                sat.cost_centre, 
                scy.dearing,
                a.dsa_allowance_id, 
                ai.dsa_fee_instalment,
                sat.entity, scy.grad_session,
                scy.inst_code, ai.method,
                ai.net_amount, 
                n.nominee_id, 
                ai.payee, 
                CASE
                    WHEN ai.payee = 'N'
                        THEN 'S'
                    ELSE ai.payee
                END AS payee_sb,                
                ai.payment_addr,
                CASE
                    WHEN (ai.payment_due_date < sysdate + bacs_process_days) AND ai.method = 'B'
                    THEN TO_CHAR(sysdate + bacs_process_days, 'DD-MM-YYYY')
                    WHEN (ai.payment_due_date < sysdate + bacs_process_days) AND ai.method = 'C'
                    THEN TO_CHAR(sysdate + cheque_process_days, 'DD-MM-YYYY')
                    ELSE TO_CHAR(ai.payment_due_date, 'DD-MM-YYYY')
                    END AS payment_due_date,
                s.payment_method, 
                sat.programme, 
                pk_payments.getPaymentNumber(ai.award_instalment_id, a.stud_ref_no, a.session_code) AS payment_sequence,
                pk_payments.checkNumberOfPaidAwards(ai.award_instalment_id) AS PAIDAWARDS,
                scy.provisional_case,
                a.session_code,
                CASE
                   WHEN ai.payee = 'S'
                      THEN s.sort_code
                   WHEN ai.payee = 'N'
                      THEN n.sort_code
                   ELSE null
        -- WE NEED TO DETERMINE HOW TO LINK TO DSA NOMINEE TABLE
                END AS sort_code,
                a.stud_award_type, a.stud_crse_year_id, s.stud_ref_no, s.qa_count,
                CASE
                    WHEN (ai.payee = 'S' AND ai.method = 'C' AND ai.payment_addr = 'C')
                        THEN '06'
                     ELSE '02'
                END sub_type,
                ai.trav_amount
           FROM award_instalment ai, award a, stud_crse_year scy, stud s, stud_award_type sat, stud_session st, dsa_payment dsa, nominee n
          WHERE ai.award_id = a.award_id
            AND ai.award_instalment_id = dsa.award_instalment_id(+)
            AND dsa.payee_id = n.nominee_id(+)
            AND a.stud_award_type = sat.stud_award_type
            AND st.stud_session_id = scy.stud_session_id
            AND a.stud_crse_year_id = scy.stud_crse_year_id
            AND scy.stud_ref_no = s.stud_ref_no
            AND a.award_src = 'A'
            AND ai.payment_status = 'U'
            AND ai.net_amount > 0
            AND s.suspend_payment = 'N'
            AND s.stud_suspend = 'N'
            AND st.session_suspend = 'N'
            AND scy.crse_suspend = 'N'                                           ----WE REQUIRE JOIN TO DSA TABLE TO IMPLEMENT DSA PAYMENT STOP CODE HERE
            AND (   (    TRUNC (ai.payment_due_date) <=
                            TRUNC
                               (SYSDATE + p_days_ahead_bacs)
                               --CONFIG NUMBER OF DAYS AHEAD FOR BACS PAYMENTS
                     AND ai.method = 'B'
                    )
                 OR (    TRUNC (ai.payment_due_date) <=
                            TRUNC
                               (SYSDATE + p_days_ahead_cheque)
                             --CONFIG NUMBER OF DAYS AHEAD FOR CHEQUE PAYMENTS
                     AND ai.method = 'C'
                    )
                )
             ORDER BY ai.payment_due_date;
                

   END select_award_payments;
   
  
--PROCEDURE process_standard_payments;
   PROCEDURE aggregate_payments    (ERROR_TEXT          OUT NOCOPY      VARCHAR2)

   IS
/******************************************************************************
   NAME:       AGGREGATE PAYMENTS
   PURPOSE:    Picks up payment instalment records associated with payment
              batches created in the current payment job run and aggregates the data

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        23/03/2010 Adrian Bowman    1. Created
   1.1        25/04/2010 Paul Hughes      2. Amended
   ******************************************************************************/

      --THIS IS USED TO SELECT ALL THE PAYEE_ID THAT ARE WITHIN THIS PAYMENT RUN.  THIS IS REQUIRED TO UPDATE PREV_OUTSTANDING_AMOUNT VALUE WITH OLD VALUE.
      CURSOR c_payee_id
      IS
         SELECT DISTINCT payee_id
                    FROM payment_instalment
                   WHERE payment_status = 'A';

      v_pay_id         payee.payee_id%TYPE;

      ---THIS SELECTS THE DATA FROM PAYMENT_INSTALMENT RECORD READY TO BE INSERTED INTO ADI_JOURNAL TABLE FOR PAYMENTS BEING MADE
      CURSOR c_adi_journal_payment_debit
      IS
         SELECT   pi.batch_ref,                                
                               pi.cost_centre, pi.ACCOUNT,
                  SUM (pi.payment_amount) AS amount, 
                  pi.programme,
                  pi.currency, pi.entity, pi.payment_method, pi.process_date
             FROM payment_instalment pi
            WHERE pi.payment_status = 'I' AND pi.payment_method = 'B'
                  AND pi.payment_amount > 0
         GROUP BY pi.batch_ref,                          
                  pi.cost_centre,
                  pi.ACCOUNT,
                  pi.programme,
                  pi.currency,
                  pi.entity,
                  pi.payment_method,
                  pi.process_date;

      v_adi_journal_payment_debit    c_adi_journal_payment_debit%ROWTYPE;
      
      ---THIS SELECTS THE DATA FROM PAYMENT_INSTALMENT RECORD READY TO BE INSERTED INTO ADI_JOURNAL TABLE FOR RECOVERIES BEING MADE
      CURSOR c_adi_journal_recovery_credit
      IS
         SELECT   pi.batch_ref,          
                               pi.cost_centre, pi.ACCOUNT, 
                  SUM (pi.payment_amount) * -1 AS amount, 
                  pi.programme,
                  pi.currency, pi.entity, pi.payment_method, pi.process_date
             FROM payment_instalment pi--, payee p
            WHERE pi.payment_status = 'I' AND pi.payment_method = 'B'
                  AND pi.payment_amount < 0
         GROUP BY pi.batch_ref,                                
                  pi.cost_centre,
                  pi.ACCOUNT,
                  pi.programme,
                  pi.currency,
                  pi.entity,
                  pi.payment_method,
                  pi.process_date;

      v_adi_journal_recovery_credit    c_adi_journal_recovery_credit%ROWTYPE;
      
      
       ---THIS CREATES THE CORRESPONDING RECORDS INTO THE CREDIT FIELD IN THE ADI JOURNAL TABLE FOR PAYMENTS BEING MADE AND CREDITED TO BANK ACCOUNT
      CURSOR c_adi_journal_payment_credit
      IS

                  SELECT pi.batch_ref, sat.cost_centre, sat.account_name as ACCOUNT, SUM(pi.payment_amount) as amount,
                  sat.programme, sat.entity                 
                  FROM payment_instalment pi, stud_award_type sat
                  WHERE pi.payment_status = 'I' AND pi.payment_method = 'B'
                  AND pi.payment_amount > 0
                  AND sat.award_type_descript = 'SAAS BANK INFO'
                  GROUP by pi.batch_ref, sat.cost_centre, sat.account_name, sat.programme, sat.entity;
                  
       v_adi_journal_payment_credit    c_adi_journal_payment_credit%ROWTYPE;
       
       

      
       ---THIS CREATES THE CORRESPONDING RECORDS INTO THE DEBIT FIELD IN THE ADI JOURNAL TABLE FOR RECOVERIES BEING MADE FROM SUSPENSE ACCOUNT
      CURSOR c_adi_journal_recovery_debit
      IS

                  SELECT pi.batch_ref, sat.cost_centre, sat.account_name as ACCOUNT, SUM(pi.payment_amount) * -1 as amount,
                  sat.programme, sat.entity                 
                  FROM payment_instalment pi, stud_award_type sat
                  WHERE pi.payment_status = 'I' AND pi.payment_method = 'B'
                  AND pi.payment_amount < 0
                  AND sat.award_type_descript = 'SAAS SUSPENSE'
                  GROUP by pi.batch_ref, sat.cost_centre, sat.account_name, sat.programme, sat.entity;
                  
       v_adi_journal_recovery_debit    c_adi_journal_recovery_debit%ROWTYPE;
       
   

      ---THIS SELECTS THE DATA FROM PAYMENT_INSTALMENT RECORD READY TO BE INSERTED INTO PAYEE_PAYMENT TABLE
      CURSOR c_payee_payment
                
      IS
      
                  SELECT     
                  pi.batch_ref, pi.payee_id, p.payee_ref_id,
                  pi.account_name, pi.sort_code, pi.account_no, pi.payment_run_date,
                    CASE
                    WHEN SUM(pi.payment_amount) - (p.prev_outstanding_amount) >= 0
                        THEN SUM(pi.payment_amount) - p.prev_outstanding_amount
                    ELSE 0
                  END amount_paid,  
                  SUM(pi.payment_amount) - (p.prev_outstanding_amount) AS net_amount_due,       
                  SUM (pi.payment_amount) total_in_run, 
                  p.prev_outstanding_amount AS prev_debt,  
                  pi.payment_method, pi.payment_date, pi.currency, pi.payment_status,
                  pi.process_date,   
                   p.payee_type as payment_type
             FROM payee p, payment_instalment pi
            WHERE p.payee_id = pi.payee_id
              AND pi.payment_status = 'A'
         GROUP BY pi.batch_ref,
                  pi.payee_id,
                  p.payee_ref_id,
                  pi.account_name,
                  pi.sort_code,
                  pi.account_no,
                  pi.payment_run_date,
                  pi.payment_method,
                  p.prev_outstanding_amount,
                  pi.currency,
                  pi.payment_status,
                  pi.payment_date,
                  pi.process_date,
                  p.payee_type;
                  


      v_pay_rec        c_payee_payment%ROWTYPE;
      v_adi_journ_id   adi_journal.adi_journal_id%TYPE;
      v_adi_jl_id      adi_journal.adi_journal_line_id%TYPE;

      ---THIS SELECTS THE AWARD_ID AND THE BATCH_REF FROM PAYMENT_INSTALMENT RECORD IN ORDER TO UPDATE AWARD INSTALMENT TABLE.
      CURSOR c_award_id
      IS
         SELECT pi.award_instalment_id, pi.batch_ref
           FROM payment_instalment pi
          WHERE pi.payment_status = 'A';

      v_award_rec      c_award_id%ROWTYPE;


      CURSOR c_scoap_payments
      IS
      
                        SELECT pi.batch_ref, pi.stud_ref_no AS OUR_REF1,
                             pi.stud_crse_year_id AS OUR_REF2,
                                pp.payee_payment_id AS OUR_REF3, pi.account_name AS payee, pi.payee_addrl1, pi.payee_addrL2, pi.payee_addrl3, pi.payee_postcode,
                                pi.payment_addr, SUM(pi.payment_amount) AS net_amount_due, pi.sub_type, pi.payment_date,
                                pp.payee_payment_id, pi.stud_ref_no, pp.payee_ref_id, 0||pi.stud_ref_no||'H' as ref4
        FROM payee_payment pp, payment_instalment pi
        WHERE pp.payee_payment_id = pi.payee_payment_id
        AND pp.payment_method = 'C'
        AND pp.payment_status = 'I'
        GROUP BY pi.batch_ref, pi.stud_ref_no, pi.stud_crse_year_id,
                                pp.payee_payment_id, pi.account_name, pi.payee_addrl1, pi.payee_addrL2, pi.payee_addrl3, pi.payee_postcode,
                                pi.payment_addr, pi.sub_type, pi.payment_date,
                                pp.payee_payment_id, pi.stud_ref_no, pp.payee_ref_id;
      
        /*
        SELECT pp.batch_ref, pi.stud_ref_no AS OUR_REF1,
                             pi.stud_crse_year_id AS OUR_REF2,
                                pp.payee_payment_id AS OUR_REF3, pi.account_name AS payee, pi.payee_addrl1, pi.payee_addrL2, pi.payee_addrl3, pi.payee_postcode,
                                pi.payment_addr, pp.net_amount_due, pi.sub_type, pp.payment_date,
                                pp.payee_payment_id, pi.stud_ref_no, pp.payee_ref_id, 0||pi.stud_ref_no||'H' as ref4
        FROM payee_payment pp, payment_instalment pi
        WHERE pp.payee_payment_id = pi.payee_payment_id
        AND pp.payment_method = 'C'
        AND pp.payment_status = 'I';
        
       */

        v_scoap_payments_rec    c_scoap_payments%ROWTYPE;
        
        CURSOR c_scoap_journal
      IS
      
        SELECT pp.batch_ref, pi.cost_centre, pi.account, SUM(pi.payment_amount) AS amount, pi.programme, pi.entity
        FROM payee_payment pp, payment_instalment pi
        WHERE pp.payee_payment_id = pi.payee_payment_id
        AND pp.payment_method = 'C'
        AND pp.payment_status = 'I'   --- previously was A
        GROUP BY pp.batch_ref, pi.cost_centre, pi.account, pi.programme, pi.entity;
        

        v_scoap_journal_rec    c_scoap_journal%ROWTYPE;


   BEGIN
      SELECT adi_journ_id_seq.NEXTVAL
        INTO v_adi_journ_id
        FROM DUAL;

      ---THIS IS LOOPING OVER ALL THE PAYEE_ID's AND UPDATING PREV_OUTSTANDING_AMOUNT
      OPEN c_payee_id;

      LOOP
         FETCH c_payee_id
          INTO v_pay_id;

         EXIT WHEN c_payee_id%NOTFOUND;

         UPDATE payee pay
            SET pay.prev_outstanding_amount = pay.outstanding_amount
          WHERE pay.payee_id = v_pay_id;
      END LOOP;

      CLOSE c_payee_id;

      OPEN c_award_id;

      LOOP
         FETCH c_award_id
          INTO v_award_rec;

         EXIT WHEN c_award_id%NOTFOUND;

         UPDATE award_instalment awi
            SET awi.batch_ref = v_award_rec.batch_ref
          WHERE awi.award_instalment_id = v_award_rec.award_instalment_id;
      END LOOP;

      CLOSE c_award_id;
      
            OPEN c_payee_payment;

      LOOP
         FETCH c_payee_payment
          INTO v_pay_rec;

         EXIT WHEN c_payee_payment%NOTFOUND;

          INSERT INTO sgas.payee_payment
                     (                                    --payee_payment_id,
                      batch_ref, payee_id,
                      payee_ref_id, account_name, sort_code, account_no, payment_run_date, amount_paid,
                      net_amount_due, 
                      total_in_run, prev_debt,
                      payment_method, payment_date,
                      returned_date, currency, payment_status,
                      process_date, last_updated_by,
                      last_updated_on
                     )
              VALUES (                          --payee_payment_id_seq.CURRVAL,
                      v_pay_rec.batch_ref,      --batch_ref
                      v_pay_rec.payee_id,       --payee_id
                      v_pay_rec.payee_ref_id,   --payee_ref_id
                      v_pay_rec.account_name,    --account_name
                      v_pay_rec.sort_code,       --sort-code
                      v_pay_rec.account_no,      --account_no
                      v_pay_rec.payment_run_date, --payment_run_date
                      v_pay_rec.amount_paid,      --amount_paid
                      v_pay_rec.net_amount_due,  --net_amount_due
                      v_pay_rec.total_in_run,    --total-in_run
                      v_pay_rec.prev_debt,      --Debt they had oustanding
                      v_pay_rec.payment_method, --payment_method
                      v_pay_rec.payment_date,   --payment_date
                      NULL,                     --returned_date??,
                      v_pay_rec.currency,       --currency
                      'I',                      --SETTING PAYMENT STATUS TO IN PROCESS
                      v_pay_rec.process_date,   --process_date
                      'SGAS',                   --last_updated_by
                      SYSDATE                   --last_updated_on
                     );
                     
               IF v_pay_rec.total_in_run - v_pay_rec.prev_debt < 0
                THEN 
                        UPDATE payee
                        SET outstanding_amount = (v_pay_rec.total_in_run - v_pay_rec.prev_debt) * -1
                        WHERE payee_id = v_pay_rec.payee_id;
                        
               ELSE
                        UPDATE payee
                        SET outstanding_amount = 0
                        WHERE payee_id = v_pay_rec.payee_id;
               END IF;
                


         UPDATE payment_instalment pi
            SET pi.payee_payment_id =
                   (SELECT pp.payee_payment_id
                      FROM payee_payment pp
                     WHERE pp.batch_ref = v_pay_rec.batch_ref
                       AND pp.payee_id = v_pay_rec.payee_id),
                pi.payment_status = 'I',
                pi.adi_journal_id = v_adi_journ_id
            WHERE pi.batch_ref = v_pay_rec.batch_ref
            AND pi.payee_id = v_pay_rec.payee_id
            AND pi.payment_method = 'B'
            AND pi.payment_status = 'A';   
            
            UPDATE payment_instalment pi
            SET pi.payee_payment_id =
                   (SELECT pp.payee_payment_id
                      FROM payee_payment pp
                     WHERE pp.batch_ref = v_pay_rec.batch_ref
                       AND pp.payee_id = v_pay_rec.payee_id),
                pi.payment_status = 'I'
            WHERE pi.batch_ref = v_pay_rec.batch_ref
            AND pi.payee_id = v_pay_rec.payee_id
            AND pi.payment_method = 'C'
            AND pi.payment_status = 'A';                  
      END LOOP;
      
            CLOSE c_payee_payment;

      OPEN c_adi_journal_payment_debit;

      LOOP
         FETCH c_adi_journal_payment_debit
          INTO v_adi_journal_payment_debit;

         EXIT WHEN c_adi_journal_payment_debit%NOTFOUND;

         SELECT adi_jl_seq.NEXTVAL
           INTO v_adi_jl_id
           FROM DUAL;
           

                            ---PAYMENTS WHICH UPDATE THE DEBIT COLUMN IN ADI_JOURNAL TABLE
                             INSERT INTO sgas.adi_journal
                                         (adi_journal_line_id, 
                                         adi_journal_id, 
                                         batch_ref,
                                         cost_centre, 
                                         ACCOUNT, 
                                         programme, 
                                         currency,
                                         entity,
                                         payment_method,
                                         process_date, 
                                         adi_file_status, 
                                         sub_analysis1, sub_analysis2, sub_analysis3, 
                                         debit_value, credit_value, payment_run_date,
                                         last_updated_by,last_updated_on
                                         )
                                  VALUES (v_adi_jl_id,                  --adi_journal_line_id
                                          v_adi_journ_id,               --adi_journal_id
                                          v_adi_journal_payment_debit.batch_ref,      --batch_ref
                                          v_adi_journal_payment_debit.cost_centre,    --cost_centre
                                          v_adi_journal_payment_debit.ACCOUNT,        --ACCOUNT
                                          v_adi_journal_payment_debit.programme,      --programme
                                          v_adi_journal_payment_debit.currency,       --currency
                                          v_adi_journal_payment_debit.entity,         --entity
                                          v_adi_journal_payment_debit.payment_method, --payment_method
                                          v_adi_journal_payment_debit.process_date,   --process_date
                                          'I',                          --adi_file_status
                                          '000000',                       --sub_analysis1,
                                          '00000000',                    --sub_analysis2,
                                          '000000',                       --sub_analysis3,
                                          v_adi_journal_payment_debit.amount,         --debit_value
                                          null,                             --credit_value
                                          SYSDATE,                        --payment_run_date
                                          'SGAS',                       --last_updated_by
                                          SYSDATE                       --last_updated_on
                                         );
   

         UPDATE payment_instalment pi
            SET pi.adi_journal_line_id = v_adi_jl_id
          WHERE pi.cost_centre = v_adi_journal_payment_debit.cost_centre
            AND pi.ACCOUNT = v_adi_journal_payment_debit.ACCOUNT
            AND pi.programme = v_adi_journal_payment_debit.programme
            AND pi.entity = v_adi_journal_payment_debit.entity
            AND pi.process_date =
                   TRUNC
                      (v_adi_journal_payment_debit.process_date)
            AND pi.adi_journal_id = v_adi_journ_id
            AND pi.payment_method = 'B';
      END LOOP;

      CLOSE c_adi_journal_payment_debit;
      
        
      
            OPEN c_adi_journal_recovery_credit;

      LOOP
         FETCH c_adi_journal_recovery_credit
          INTO v_adi_journal_recovery_credit;

         EXIT WHEN c_adi_journal_recovery_credit%NOTFOUND;

         SELECT adi_jl_seq.NEXTVAL
           INTO v_adi_jl_id
           FROM DUAL;
           

                            ---PAYMENTS WHICH UPDATE THE DEBIT COLUMN IN ADI_JOURNAL TABLE
                             INSERT INTO sgas.adi_journal
                                         (adi_journal_line_id, 
                                         adi_journal_id, 
                                         batch_ref,
                                         cost_centre, 
                                         ACCOUNT, 
                                         programme, 
                                         currency,
                                         entity,
                                         payment_method,
                                         process_date, 
                                         adi_file_status, 
                                         sub_analysis1, sub_analysis2, sub_analysis3, 
                                         debit_value, credit_value, payment_run_date,
                                         last_updated_by,last_updated_on
                                         )
                                  VALUES (v_adi_jl_id,                  --adi_journal_line_id
                                          v_adi_journ_id,               --adi_journal_id
                                          v_adi_journal_recovery_credit.batch_ref,      --batch_ref
                                          v_adi_journal_recovery_credit.cost_centre,    --cost_centre
                                          v_adi_journal_recovery_credit.ACCOUNT,        --ACCOUNT
                                          v_adi_journal_recovery_credit.programme,      --programme
                                          v_adi_journal_recovery_credit.currency,       --currency
                                          v_adi_journal_recovery_credit.entity,         --entity
                                          v_adi_journal_recovery_credit.payment_method, --payment_method
                                          v_adi_journal_recovery_credit.process_date,   --process_date
                                          'I',                          --adi_file_status
                                          '000000',                       --sub_analysis1,
                                          '00000000',                    --sub_analysis2,
                                          '000000',                       --sub_analysis3,
                                          null,                            --debit_value
                                          v_adi_journal_recovery_credit.amount,    --credit_value
                                          SYSDATE,                        --payment_run_date
                                          'SGAS',                       --last_updated_by
                                          SYSDATE                       --last_updated_on
                                         );
   

         UPDATE payment_instalment pi
            SET pi.adi_journal_line_id = v_adi_jl_id
          WHERE pi.cost_centre = v_adi_journal_recovery_credit.cost_centre
            AND pi.ACCOUNT = v_adi_journal_recovery_credit.ACCOUNT
            AND pi.programme = v_adi_journal_recovery_credit.programme
            AND pi.entity = v_adi_journal_recovery_credit.entity
            AND pi.process_date =
                   TRUNC
                      (v_adi_journal_recovery_credit.process_date)
            AND pi.adi_journal_id = v_adi_journ_id
            AND pi.payment_method = 'B';
      END LOOP;

      CLOSE c_adi_journal_recovery_credit;

    
      
            OPEN c_adi_journal_payment_credit;

      LOOP
         FETCH c_adi_journal_payment_credit
          INTO v_adi_journal_payment_credit;

         EXIT WHEN c_adi_journal_payment_credit%NOTFOUND;

         SELECT adi_jl_seq.NEXTVAL
           INTO v_adi_jl_id
           FROM DUAL;
           
           
                                            ---PAYMENTS WHICH UPDATE THE CREDIT COLUMN IN ADI_JOURNAL TABLE
                             INSERT INTO sgas.adi_journal
                                         (adi_journal_line_id, 
                                         adi_journal_id, 
                                         batch_ref,
                                         cost_centre, 
                                         ACCOUNT, 
                                         programme, 
                                         currency,
                                         entity,
                                         payment_method,
                                         process_date, 
                                         adi_file_status, 
                                         sub_analysis1, sub_analysis2, sub_analysis3, 
                                         debit_value, credit_value, payment_run_date,
                                         last_updated_by,last_updated_on
                                         )
                                  VALUES (v_adi_jl_id,                  --adi_journal_line_id
                                          v_adi_journ_id,               --adi_journal_id
                                          v_adi_journal_payment_credit.batch_ref,      --batch_ref
                                          v_adi_journal_payment_credit.cost_centre,    --cost_centre
                                          v_adi_journal_payment_credit.ACCOUNT,        --ACCOUNT
                                          v_adi_journal_payment_credit.programme,      --programme
                                          'GBP',                             --currency
                                          v_adi_journal_payment_credit.entity,         --entity
                                          'B',                               --payment_method
                                          sysdate,                      --process_date
                                          'I',                          --adi_file_status
                                           '000000',                       --sub_analysis1,
                                          '00000000',                    --sub_analysis2,
                                          '000000',                       --sub_analysis3,
                                          null,         --debit_value
                                          v_adi_journal_payment_credit.amount,                             --credit_value
                                          SYSDATE,                        --payment_run_date
                                          'SGAS',                       --last_updated_by
                                          SYSDATE                       --last_updated_on
                                         );
           
           END LOOP;

      CLOSE c_adi_journal_payment_credit;    
      
       
      
                  OPEN c_adi_journal_recovery_debit;

      LOOP
         FETCH c_adi_journal_recovery_debit
          INTO v_adi_journal_recovery_debit;

         EXIT WHEN c_adi_journal_recovery_debit%NOTFOUND;

         SELECT adi_jl_seq.NEXTVAL
           INTO v_adi_jl_id
           FROM DUAL;
           
           
                                            ---PAYMENTS WHICH UPDATE THE CREDIT COLUMN IN ADI_JOURNAL TABLE
                             INSERT INTO sgas.adi_journal
                                         (adi_journal_line_id, 
                                         adi_journal_id, 
                                         batch_ref,
                                         cost_centre, 
                                         ACCOUNT, 
                                         programme, 
                                         currency,
                                         entity,
                                         payment_method,
                                         process_date, 
                                         adi_file_status, 
                                         sub_analysis1, sub_analysis2, sub_analysis3, 
                                         debit_value, credit_value, payment_run_date,
                                         last_updated_by,last_updated_on
                                         )
                                  VALUES (v_adi_jl_id,                  --adi_journal_line_id
                                          v_adi_journ_id,               --adi_journal_id
                                          v_adi_journal_recovery_debit.batch_ref,      --batch_ref
                                          v_adi_journal_recovery_debit.cost_centre,    --cost_centre
                                          v_adi_journal_recovery_debit.ACCOUNT,        --ACCOUNT
                                          v_adi_journal_recovery_debit.programme,      --programme
                                          'GBP',                             --currency
                                          v_adi_journal_recovery_debit.entity,         --entity
                                          'B',                               --payment_method
                                          sysdate,                      --process_date
                                          'I',                          --adi_file_status
                                           '000000',                       --sub_analysis1,
                                          '00000000',                    --sub_analysis2,
                                          '000000',                       --sub_analysis3,
                                          v_adi_journal_recovery_debit.amount,         --debit_value
                                          null,                             --credit_value
                                          SYSDATE,                        --payment_run_date
                                          'SGAS',                       --last_updated_by
                                          SYSDATE                       --last_updated_on
                                         );
           
           END LOOP;

      CLOSE c_adi_journal_recovery_debit;          
      
      
      OPEN c_scoap_payments;
      
        LOOP
            FETCH c_scoap_payments
            INTO v_scoap_payments_rec;
            
            EXIT WHEN  c_scoap_payments%NOTFOUND;
            

      INSERT INTO sgas.scoap_payments
                  (dpp_batch_ref, dpp_sequence_no, dpp_our_ref1,
                   dpp_our_ref2, dpp_our_ref3, dpp_source_ref, dpp_payee,
                   dpp_payee_address1, dpp_payee_address2,
                   dpp_payee_address3, dpp_payee_postcode,
                   dpp_payee_bank_account, dpp_payee_bank_sort_code,
                   dpp_bank_account_type, dpp_build_soc_roll_no,
                   dpp_payment_amount, dpp_payment_method,
                   dpp_pay_sub_type, dpp_payment_date,
                   dpp_refer_to_or_enclosure, dpp_remitter_address_code,
                   dpp_radv_addressee, dpp_radv_address1,
                   dpp_radv_address2, dpp_radv_address3,
                   dpp_radv_address4, dpp_radv_postcode, dpp_bank_id,
                   dpp_remittance_text_01, dpp_remittance_text_02,
                   dpp_remittance_text_03, dpp_remittance_text_04,
                   dpp_remittance_text_05, dpp_remittance_text_06,
                   dpp_remittance_text_07, dpp_remittance_text_08,
                   dpp_remittance_text_09, dpp_remittance_text_10,
                   dpp_remittance_text_11, dpp_remittance_text_12,
                   dpp_remittance_text_13, dpp_remittance_text_14,
                   dpp_remittance_text_15, dpp_remittance_text_16,
                   dpp_remittance_text_17, dpp_remittance_text_18,
                   dpp_remittance_text_19, dpp_remittance_text_20,
                   dpp_payment_id, dpp_po_num, dpp_reissue, dpp_returned,
                   dpp_currency, dpp_our_ref4, last_updated_by,
                   last_updated_on
                  )
           VALUES (v_scoap_payments_rec.batch_ref,         --dpp_batch_ref 
                                       NULL,               --dpp_sequence_no      
                   v_scoap_payments_rec.our_ref1,          --dpp_our_ref1   
                   v_scoap_payments_rec.our_ref2,          --dpp_our_ref2 
                   v_scoap_payments_rec.our_ref3,          --dpp_our_ref3 
                             'NOT KNOWN',                  --dpp_source_ref        
                   v_scoap_payments_rec.payee,             --dpp_payee
                   v_scoap_payments_rec.payee_addrl1,      --dpp_payee_address1
                   v_scoap_payments_rec.payee_addrl2,      --dpp_payee_address2
                   v_scoap_payments_rec.payee_addrl3,      --dpp_payee_address3
                   v_scoap_payments_rec.payee_postcode,    --dpp_payee_postcode
                   NULL,                                   --dpp_payee_bank_account 
                        NULL,                              --dpp_payee_bank_sort_code
                   NULL,                                   --dpp_bank_account_type  
                        NULL,                              --dpp_build_soc_roll_no                    
                   v_scoap_payments_rec.net_amount_due,    --dpp_payment_amount           
                   'PQ',                                   --dpp_payment_method 
                   v_scoap_payments_rec.sub_type,          --dpp_pay_sub_type
                   v_scoap_payments_rec.payment_date,      --dpp_payment_date
                   NULL,                                   --dpp_refer_to_or_enclosure
                   'SG1',                                  --dpp_remitter_address_code                       
                        v_scoap_payments_rec.payee,        --dpp_radv_addressee
                        NULL,                              --dpp_radv_address1
                   NULL,                                   --dpp_radv_address2
                        NULL,                              --dpp_radv_address3
                   NULL,                                   --dpp_radv_address4
                        NULL,                              --dpp_radv_postcode
                   '0001',                                   --dpp_bank_id
                   NULL,                                   --dpp_remittance_text_01
                        NULL,                              --dpp_remittance_text_02
                   NULL,                                   --dpp_remittance_text_03
                        NULL,                              --dpp_remittance_text_04
                   NULL,                                   --dpp_remittance_text_05
                        NULL,                              --dpp_remittance_text_06
                   NULL,                                   --dpp_remittance_text_07
                        NULL,                              --dpp_remittance_text_08
                   NULL,                                   --dpp_remittance_text_09
                        NULL,                              --dpp_remittance_text_10
                   NULL,                                   --dpp_remittance_text_11
                        NULL,                              --dpp_remittance_text_12
                   NULL,                                   --dpp_remittance_text_13
                        NULL,                              --dpp_remittance_text_14
                   NULL,                                   --dpp_remittance_text_15
                        NULL,                              --dpp_remittance_text_16
                   NULL,                                   --dpp_remittance_text_17
                        NULL,                              --dpp_remittance_text_18
                   NULL,                                   --dpp_remittance_text_19
                        NULL,                              --dpp_remittance_text_20
                   v_scoap_payments_rec.payee_payment_id,  --dpp_payment_id                           
                   NULL,                                   --dpp_po_num                            
                   'N',                                    --dpp_reissue 
                                  NULL,                    --dpp_returned
                   'GBP',                                   --dpp_currency 
                   v_scoap_payments_rec.ref4,                              --dpp_our_ref4
                             'SGAS',                       --last_updated_by
                   SYSDATE                                 --last_updated_on                   
                  );
        
      END LOOP;

      CLOSE c_scoap_payments;
       
      OPEN c_scoap_journal;
      
      LOOP
        FETCH c_scoap_journal
        INTO v_scoap_journal_rec;
        
        EXIT WHEN c_scoap_journal%NOTFOUND;
      
        INSERT INTO SCOAP_JOURNAL_LINES
        (DPJ_BATCH_REF, 
        DPJ_COST_CENTRE, 
        DPJ_ACCOUNT, 
        DPJ_ACTIVITY, 
        DPJ_JOB, 
        DPJ_ANALYSIS_1_ID, 
        DPJ_SIGN, 
        DPJ_AMOUNT, 
        DPJ_VAT_AMOUNT, 
        DPJ_VAT_CODE, 
        DPJ_PROGRAMME, 
        DPJ_CURRENCY, 
        DPJ_ENTITY, 
        DPJ_PAYMENT_TYPE)
        VALUES
        (v_scoap_journal_rec.batch_ref,   --DPJ_BATCH_REF
        v_scoap_journal_rec.cost_centre,  --DPJ_COST_CENTRE
        v_scoap_journal_rec.account,      --DPJ_ACCOUNT
        0,                             --DPJ_ACTIVITY
        0,                             --DPJ_JOB
        v_scoap_journal_rec.batch_ref,    --DPJ_ANALYSIS_1_ID
        '+',                              --DPJ_SIGN
        v_scoap_journal_rec.amount,       --DPJ_AMOUNT
        0,                             --DPJ_VAT_AMOUNT
        null,                             --DPJ_VAT_CODE
        v_scoap_journal_rec.programme,    --DPJ_PROGRAMME
        'GBP',                            --DPJ_CURRENCY
        v_scoap_journal_rec.entity,       --DPJ_ENTITY
        'C'                               --DPJ_PAYMENT_TYPE
        );
        
        END LOOP;
        
        close c_scoap_journal;
         
      COMMIT;
   


  EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
           
   END aggregate_payments;


END pk_payments;
/
