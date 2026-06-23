-- Name:Adhoc 18
-- Description: This script was created in order to fix ILA500.LEARNER_PAYMENT.PROVIDER_PAYMENT_ID field which was incorrectly updating to the same value for all fields.
--              This script has been run through DEV, BUILD environments and should be applied to LIVE.
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      05.05.2010   P.Hughes (SAAS)         Initial Version.
--
DECLARE

    CURSOR c_provider IS
    
    SELECT distinct provider_id, last_updated_on
    FROM PROVIDER_PAYMENT;
   
    v_providerRec c_provider%ROWTYPE;
    
 BEGIN
 
    OPEN c_provider;
    
    LOOP
    
        FETCH c_provider INTO v_providerRec;
        EXIT WHEN c_provider%NOTFOUND;
        
       UPDATE LEARNER_PAYMENT
       SET PROVIDER_PAYMENT_ID = (SELECT PROVIDER_PAYMENT_ID FROM PROVIDER_PAYMENT 
                                        WHERE PROVIDER_ID = v_providerRec.provider_id
                                        AND TRUNC(last_updated_on) = TRUNC(v_providerRec.last_updated_on))
       WHERE LEARNER_APPLICATION_ID IN(                     
                                        SELECT LEARNER_APPLICATION_ID
                                        FROM LEARNER_APPLICATION
                                        WHERE PROVIDER_ID = v_providerRec.provider_id
                                        AND TRUNC(PAYMENT_DATE) = TRUNC(v_providerRec.last_updated_on)
                                        AND PAYMENT_DATE IS NOT NULL)
       AND PROVIDER_PAYMENT_ID IS NOT NULL
       AND TRANSACTION_TYPE_ID = 1;
       
    END LOOP;
    
    CLOSE c_provider;
    
  END;
  

