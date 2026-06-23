CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_stud_enquiry AS
/***********************************************************************************
   NAME:      pk_steps_ui_stud_enquiry
   PURPOSE:   Student Enquiry Message functionality implemented as part of OLS 2016 

   Version    Date         Author           Description
   -------    ----------   ------------     --------------------
   1.0        12/11/2015   Ranj Benning     Created this package
   1.1		  14/03/2017   Ranj Benning     Added user_in parameter	
   
***********************************************************************************/

    PROCEDURE getStudEnquiriesForSRN (
        stud_ref_no_in      IN      VARCHAR2,
        io_cursor           IN OUT  studenquiry_cursor,
        error_boolean       OUT     VARCHAR2,
        ERROR_TEXT          OUT     VARCHAR2
    )
    IS
        a_cursor studenquiry_cursor;
    BEGIN
        OPEN a_cursor FOR
        ---------------------------------------------------
        SELECT SE.*, 
               SUBSTR(SE.ENQUIRY_TEXT,1,LEAST(75,LENGTH(SE.ENQUIRY_TEXT))) AS SUMMARY,        
               EO.DESCRIPTION AS ENQUIRY_OPTION_DESC 
        FROM STUD_ENQUIRY SE, ENQUIRY_OPTION EO 
        WHERE SE.ENQUIRY_OPTION_ID = EO.ENQUIRY_OPTION_ID
        AND SE.STUD_REF_NO = stud_ref_no_in
        ORDER BY ENQUIRY_DATE DESC;
        ---------------------------------------------------
        io_cursor := a_cursor;
        error_boolean := 'false';
        ERROR_TEXT := 'none';
    EXCEPTION
    WHEN OTHERS THEN
        error_boolean := 'true';
        ERROR_TEXT := 'ERROR';
    END getStudEnquiriesForSRN;  
    /*********************************************************/

    PROCEDURE setEnquiryViewed (
        enquiry_id_in       IN      VARCHAR2,
        user_in             IN      VARCHAR2,
        error_boolean       OUT     VARCHAR2,
        ERROR_TEXT          OUT     VARCHAR2
    )
    AS    
    BEGIN
        ---------------------------------------------------
        UPDATE STUD_ENQUIRY SE
        SET SE.IS_VIEWED = 'Y',
        SE.LAST_UPDATED_BY = UPPER (user_in),
        SE.LAST_UPDATED_ON = sysdate
        WHERE SE.ENQUIRY_ID = enquiry_id_in;
        ---------------------------------------------------
        error_boolean := 'false';
        ERROR_TEXT := 'none';
        COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'Error in PLSQL procedure pk_steps_ui_stud_enquiry.setEnquiryViewed @ ' || SYSDATE || ' ' || SQLCODE || ' ' || SQLERRM;
    END setEnquiryViewed;
    /*********************************************************/

    PROCEDURE getDD_EnquiryOptions (
        io_cursor           IN OUT  dd_cursor_enquiry_options,
        error_boolean       OUT     VARCHAR2,
        ERROR_TEXT          OUT     VARCHAR2
    )
    AS    
        dd_cursor   dd_cursor_enquiry_options;
    BEGIN
        OPEN dd_cursor FOR
        ---------------------------------------------------
        SELECT EO.ENQUIRY_OPTION_ID AS KEY, 
               EO.DESCRIPTION AS LABEL 
        FROM ENQUIRY_OPTION EO
        WHERE IS_ACTIVE = 'Y';
        ---------------------------------------------------
        io_cursor := dd_cursor;
        error_boolean := 'false';
        ERROR_TEXT := 'none';        
    EXCEPTION
    WHEN OTHERS THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR in PLSQL procedure pk_steps_ui_stud_enquiry.getDD_EnquiryOptions @ ' || SYSDATE || ' ' || SQLCODE || ' ' || SQLERRM;
    END getDD_EnquiryOptions;
    /*********************************************************/

    PROCEDURE updateStudEnquiry (
        enquiry_id_in                   IN       VARCHAR2,
        enquiry_option_id_in            IN       VARCHAR2,
        session_code_in                 IN       VARCHAR2,
        user_in                         IN       VARCHAR2,
        error_boolean                   OUT      VARCHAR2,
        ERROR_TEXT                      OUT      VARCHAR2
    )
    AS
    BEGIN
        ---------------------------------------------------
        UPDATE STUD_ENQUIRY SE
        SET SE.ENQUIRY_OPTION_ID = enquiry_option_id_in,
        SE.SESSION_CODE = session_code_in,
        SE.LAST_UPDATED_BY = UPPER (user_in),
        SE.LAST_UPDATED_ON = sysdate 
        WHERE SE.ENQUIRY_ID = enquiry_id_in;
        ---------------------------------------------------
        error_boolean := 'false';
        ERROR_TEXT := 'none';
        COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'Error in PLSQL procedure pk_steps_ui_stud_enquiry.updateStudEnquiry @ ' || SYSDATE || ' ' || SQLCODE || ' ' || SQLERRM;
    END updateStudEnquiry;
    
END pk_steps_ui_stud_enquiry;
/