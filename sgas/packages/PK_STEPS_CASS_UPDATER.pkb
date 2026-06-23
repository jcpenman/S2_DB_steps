CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_CASS_UPDATER
AS
/***************************************************************************************************
   NAME:       PK_STEPS_CASS_UPDATER
   PURPOSE:    Package for functions and procedures related to Current Account Switch Service (CASS)  
    
   Version    Date         Author           Description
   -------    ----------   ------------     --------------------
   1.0        27/04/2016   Ranj Benning     Created this package
   
***************************************************************************************************/

   PROCEDURE getBankDetailsByPaymentID (
            
      payment_id_in           IN            VARCHAR2,
      payee_ref_no_out        OUT           VARCHAR2,
      payee_type_out          OUT           VARCHAR2,
      payee_name_out          OUT           VARCHAR2,
      account_no_out          OUT           VARCHAR2,
      sort_code_out           OUT           VARCHAR2,
      error_boolean           OUT           VARCHAR2,
      error_text              OUT           VARCHAR2     
   )
   IS
   BEGIN
   
      SELECT P.PAYEE_TYPE, P.PAYEE_REF_ID INTO payee_type_out, payee_ref_no_out
      FROM PAYEE_PAYMENT PP, PAYEE P
      WHERE PP.PAYEE_PAYMENT_ID = payment_id_in
      AND PP.PAYEE_ID = P.PAYEE_ID; 
      
      CASE
        WHEN payee_type_out = 'S' THEN 
            SELECT S.ACCOUNT_NO, S.SORT_CODE, S.FORENAMES || ' ' || S.SURNAME INTO account_no_out, sort_code_out, payee_name_out FROM STUD S WHERE S.STUD_REF_NO = payee_ref_no_out;
        WHEN payee_type_out = 'N' THEN 
            SELECT N.ACCOUNT_NO, N.SORT_CODE, N.FORENAME || ' ' || N.SURNAME INTO account_no_out, sort_code_out, payee_name_out FROM NOMINEE N WHERE N.NOMINEE_ID = payee_ref_no_out;
        WHEN payee_type_out = 'I' THEN
            RAISE_APPLICATION_ERROR(-20100, 'Payee Payment Type is for an Institution');                    
        ELSE RAISE_APPLICATION_ERROR(-20101, 'Payee Payment Type is not recognised');
      END CASE;
      
      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         error_text := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getBankDetailsByPaymentID;
   /*******************************************/
   
   PROCEDURE updateCASSBankDetails (
      payee_type_in             IN      VARCHAR2,
      payee_ref_id_in           IN      VARCHAR2,
      existing_account_no_in    IN      VARCHAR2,
      existing_sort_code_in     IN      VARCHAR2,
      new_account_no_in         IN      VARCHAR2,
      new_sort_code_in          IN      VARCHAR2,        
      report_generation_date_in IN      VARCHAR2,
      aosn_in                   IN      VARCHAR2,
      payee_name_in             IN      VARCHAR2,
      payee_payment_id_in       IN      VARCHAR2,
      error_boolean             OUT     VARCHAR2,
      error_text                OUT     VARCHAR2
   )
   IS
   BEGIN
       
      CASE
        WHEN UPPER(payee_type_in) = 'S' THEN
            UPDATE STUD S 
            SET S.ACCOUNT_NO = new_account_no_in, 
                S.SORT_CODE = new_sort_code_in,
                S.BANK_VALIDATE = 'Y' 
            WHERE S.STUD_REF_NO = payee_ref_id_in 
            AND S.ACCOUNT_NO = existing_account_no_in 
            AND S.SORT_CODE = existing_sort_code_in;                 
        WHEN UPPER(payee_type_in) = 'N' THEN
            UPDATE NOMINEE N 
            SET N.ACCOUNT_NO = new_account_no_in, 
                N.SORT_CODE = new_sort_code_in 
            WHERE N.NOMINEE_ID = payee_ref_id_in 
            AND N.ACCOUNT_NO = existing_account_no_in 
            AND N.SORT_CODE = existing_sort_code_in;                 
        ELSE RAISE_APPLICATION_ERROR(-20102, 'Payee Type is not valid');
      END CASE;
      
      IF (SQL%ROWCOUNT = 1) THEN
            INSERT INTO SGAS.CASS_UPDATE (PAYEE_TYPE, PAYEE_REF_ID, ORIGINAL_SORT_CODE, ORIGINAL_ACCOUNT_NO, NEW_SORT_CODE, NEW_ACCOUNT_NO, AOSN, PAYEE_NAME, PAYEE_PAYMENT_ID, REPORT_GENERATION_DATE)
            VALUES (payee_type_in, payee_ref_id_in, existing_sort_code_in, existing_account_no_in, new_sort_code_in, new_account_no_in, aosn_in, payee_name_in, payee_payment_id_in, TO_DATE(report_generation_date_in, 'DD/MM/YYYY'));
            COMMIT;
      ELSE 
            RAISE_APPLICATION_ERROR(-20104, 'Payee row for reference ' || payee_ref_id_in || ' with account no ' || existing_account_no_in || ' and sort code ' ||  existing_sort_code_in || ' not found!');             
      END IF;
         
      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         error_text := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateCASSBankDetails;
   /*******************************************/
    
   PROCEDURE getCASSUpdatesBySRN (
        stud_ref_no_in          IN      VARCHAR2,
        io_cursor               IN OUT  cass_updater_cursor,
        error_boolean           OUT     VARCHAR2,
        error_text              OUT     VARCHAR2
   )
   IS
        a_cursor cass_updater_cursor;
   BEGIN
        OPEN a_cursor FOR
        /*************************/
        SELECT
            CASS_UPDATE_ID,    
            PAYEE_TYPE,    
            PAYEE_REF_ID,    
            ORIGINAL_SORT_CODE,    
            ORIGINAL_ACCOUNT_NO,    
            NEW_SORT_CODE,    
            NEW_ACCOUNT_NO,    
            AOSN,    
            PAYEE_NAME,    
            PAYEE_PAYMENT_ID,    
            REPORT_GENERATION_DATE,    
            TO_CHAR (UPDATED_ON, 'DD/MM/YYYY HH24:MI:ss') AS UPDATED_ON         
        FROM CASS_UPDATE 
        WHERE PAYEE_REF_ID = stud_ref_no_in
        ORDER BY UPDATED_ON DESC;
        /*************************/
        io_cursor := a_cursor;
        
        error_boolean := 'false';
        error_text := 'none';
   EXCEPTION
        WHEN OTHERS    
        THEN
            error_boolean := 'true';
            error_text := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCASSUpdatesBySRN;  
    /*******************************************/   
    
END PK_STEPS_CASS_UPDATER;
/