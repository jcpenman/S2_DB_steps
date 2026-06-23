CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_CASS_UPDATER AS
/***************************************************************************************************
   NAME:       PK_STEPS_CASS_UPDATER
   PURPOSE:    Package for functions and procedures related to Current Account Switch Service (CASS)  

   Version    Date         Author           Description
   -------    ----------   ------------     --------------------
   1.0        27/04/2016   Ranj Benning     Created this package
   
***************************************************************************************************/

    TYPE cass_updater_cursor IS REF CURSOR;
    /*********************************************************/
    
    PROCEDURE getBankDetailsByPaymentID (
        payment_id_in                   IN      VARCHAR2,
        payee_ref_no_out                OUT     VARCHAR2,
        payee_type_out                  OUT     VARCHAR2,
        payee_name_out                  OUT     VARCHAR2,
        account_no_out                  OUT     VARCHAR2,
        sort_code_out                   OUT     VARCHAR2,
        error_boolean                   OUT     VARCHAR2,
        error_text                      OUT     VARCHAR2
    );
    /*********************************************************/
         
    PROCEDURE updateCASSBankDetails (
        payee_type_in                   IN      VARCHAR2,
        payee_ref_id_in                 IN      VARCHAR2,
        existing_account_no_in          IN      VARCHAR2,
        existing_sort_code_in           IN      VARCHAR2,
        new_account_no_in               IN      VARCHAR2,
        new_sort_code_in                IN      VARCHAR2,        
        report_generation_date_in       IN      VARCHAR2,
        aosn_in                         IN      VARCHAR2,
        payee_name_in                   IN      VARCHAR2,
        payee_payment_id_in             IN      VARCHAR2,
        error_boolean                   OUT     VARCHAR2,
        error_text                      OUT     VARCHAR2
    );
    /*********************************************************/

    PROCEDURE getCASSUpdatesBySRN (
        stud_ref_no_in                  IN      VARCHAR2,
        io_cursor                       IN OUT  cass_updater_cursor,
        error_boolean                   OUT     VARCHAR2,
        error_text                      OUT     VARCHAR2
    );
    /*********************************************************/
         
END PK_STEPS_CASS_UPDATER;
/