CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_UI_NMSB_PAYMENT_DATES AS
/***********************************************************************************************
    NAME:           PK_STEPS_UI_NMSB_PAYMENT_DATES
    PURPOSE:        Used to perform CRUD operations against table: NMSB_PAYMENT_DATE 
    REVISIONS:
    Ver        Date            Author               Description
    ---------  ----------      ---------------      ---------------------------------------------
    0.1        02/12/2014      Ranj Benning         Created this package and retrieve procedure.
    0.2        02/02/2015      Ranj Benning         Tidied up error handling
***********************************************************************************************/
    PROCEDURE getNMSBPaymentDates (
        io_cursor               IN OUT   nmsb_payment_dates_cursor,
        error_boolean           OUT      VARCHAR2,
        ERROR_TEXT              OUT      VARCHAR2
    )
    IS
        a_cursor   nmsb_payment_dates_cursor;
    BEGIN
        OPEN a_cursor FOR
        /*************************/
        SELECT   NMSB_PAYMENT_DATE_ID, TO_CHAR (PAYMENT_DATE, 'DD/MM/YYYY'), LAST_UPDATED_BY, LAST_UPDATED_ON
        FROM     NMSB_PAYMENT_DATE
        ORDER BY PAYMENT_DATE ASC;
        /*************************/
        io_cursor := a_cursor;
        error_boolean := 'false';
        ERROR_TEXT := 'none';
    EXCEPTION
    WHEN OTHERS    THEN
        error_boolean := 'true';
        ERROR_TEXT := 'ERROR IN PK_STEPS_UI_NMSB_PAYMENT_DATES.getNMSBPaymentDates ' || 'SQL-CODE: ' || SQLCODE || ' SQL-ERROR: ' || SQLERRM;
    END getNMSBPaymentDates;  
    /*******************************************/
    PROCEDURE addNMSBPaymentDate (
        payment_date_in            IN      VARCHAR2,
        employee_in                IN      VARCHAR2,
        error_boolean              OUT     VARCHAR2,
        ERROR_TEXT                 OUT     VARCHAR2
    )
    IS
    BEGIN
        /*************************/
        INSERT INTO SGAS.NMSB_PAYMENT_DATE (PAYMENT_DATE, LAST_UPDATED_BY, LAST_UPDATED_ON)
        VALUES (TO_DATE(payment_date_in, 'DD/MM/YYYY'), employee_in, SYSDATE);
        /*************************/
        error_boolean := 'false';
        ERROR_TEXT := 'none';
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        error_boolean := 'true';
        ERROR_TEXT := 'ERROR IN PK_STEPS_UI_NMSB_PAYMENT_DATES.addNMSBPaymentDate ' || 'SQL-CODE: ' || SQLCODE || ' SQL-ERROR: ' || SQLERRM;
    END addNMSBPaymentDate;
    /*******************************************/
    PROCEDURE updateNMSBPaymentDate (
        nmsb_payment_date_id_in    IN      VARCHAR2,
        payment_date_in            IN      VARCHAR2,
        employee_in                IN      VARCHAR2,
        error_boolean              OUT     VARCHAR2,
        ERROR_TEXT                 OUT     VARCHAR2
    )
    IS
    BEGIN
        /*************************/
        UPDATE SGAS.NMSB_PAYMENT_DATE 
        SET PAYMENT_DATE = TO_DATE(payment_date_in, 'DD/MM/YYYY'),
            LAST_UPDATED_BY = employee_in,
            LAST_UPDATED_ON = SYSDATE
        WHERE NMSB_PAYMENT_DATE_ID = nmsb_payment_date_id_in;
        /*************************/
        error_boolean := 'false';
        ERROR_TEXT := 'none';
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        error_boolean := 'true';
        ERROR_TEXT := 'ERROR IN PK_STEPS_UI_NMSB_PAYMENT_DATES.updateNMSBPaymentDate ' || 'SQL-CODE: ' || SQLCODE || ' SQL-ERROR: ' || SQLERRM;
    END updateNMSBPaymentDate;    
    /*******************************************/
    PROCEDURE deleteNMSBPaymentDate (
        nmsb_payment_date_id_in    IN      VARCHAR2,
        error_boolean              OUT     VARCHAR2,
        ERROR_TEXT                 OUT     VARCHAR2
    )
    IS
    BEGIN
        /*************************/
        DELETE FROM SGAS.NMSB_PAYMENT_DATE 
        WHERE NMSB_PAYMENT_DATE_ID = nmsb_payment_date_id_in;
        /*************************/
        error_boolean := 'false';
        ERROR_TEXT := 'none';
        COMMIT;
    EXCEPTION
        WHEN OTHERS    THEN
        ROLLBACK;
        error_boolean := 'true';
        ERROR_TEXT := 'ERROR IN PK_STEPS_UI_NMSB_PAYMENT_DATES.deleteNMSBPaymentDate ' || 'SQL-CODE: ' || SQLCODE || ' SQL-ERROR: ' || SQLERRM;
    END deleteNMSBPaymentDate;        
END PK_STEPS_UI_NMSB_PAYMENT_DATES;
/