CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_UI_NMSB_PAYMENT_DATES AS
/***********************************************************************************************
    NAME:           pk_steps_ui_nmsb_payment_dates
    PURPOSE:        Used for operations against table: NMSB_PAYMENT_DATE 
    REVISIONS:
    Ver        Date            Author               Description
    ---------  ----------      ---------------      ----------------------------------------
    0.1        02/12/2014      Ranj Benning         Created this package.
***********************************************************************************************/
    -- CURSOR DEFINITIONS
    TYPE nmsb_payment_dates_cursor     IS REF CURSOR;
    PROCEDURE getNMSBPaymentDates (
        io_cursor                  IN OUT  nmsb_payment_dates_cursor,
        error_boolean              OUT     VARCHAR2,
        ERROR_TEXT                 OUT     VARCHAR2
    );
    /*******************************************/
    PROCEDURE addNMSBPaymentDate (
        payment_date_in            IN      VARCHAR2,
        employee_in                IN      VARCHAR2,
        error_boolean              OUT     VARCHAR2,
        ERROR_TEXT                 OUT     VARCHAR2
    );
    /*******************************************/
    PROCEDURE updateNMSBPaymentDate (
        nmsb_payment_date_id_in    IN      VARCHAR2,
        payment_date_in            IN      VARCHAR2,
        employee_in                IN      VARCHAR2,
        error_boolean              OUT     VARCHAR2,
        ERROR_TEXT                 OUT     VARCHAR2
    );    
    /*******************************************/
    PROCEDURE deleteNMSBPaymentDate (
        nmsb_payment_date_id_in    IN        VARCHAR2,
        error_boolean              OUT     VARCHAR2,
        ERROR_TEXT                 OUT     VARCHAR2
    );        
END PK_STEPS_UI_NMSB_PAYMENT_DATES;
/