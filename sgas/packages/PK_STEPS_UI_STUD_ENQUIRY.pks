CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_stud_enquiry AS
/************************************************************************************
   NAME:       pk_steps_ui_stud_enquiry
   PURPOSE:    Student Enquiry Message functionality implemented as part of OLS 2016 

   Version    Date         Author           Description
   -------    ----------   ------------     --------------------
   1.0        12/11/2015   Ranj Benning     Created this package
   1.1		  14/03/2017   Ranj Benning     Added user_in parameter	
   
************************************************************************************/

    TYPE studenquiry_cursor IS REF CURSOR;
    TYPE dd_cursor_enquiry_options IS REF CURSOR;
    /*********************************************************/
    
    PROCEDURE getStudEnquiriesForSRN (
        stud_ref_no_in                  IN      VARCHAR2,
        io_cursor                       IN OUT  studenquiry_cursor,
        error_boolean                   OUT     VARCHAR2,
        ERROR_TEXT                      OUT     VARCHAR2
    );
    /*********************************************************/
  
    PROCEDURE setEnquiryViewed (
        enquiry_id_in                   IN      VARCHAR2,
        user_in                         IN      VARCHAR2,
        error_boolean                   OUT     VARCHAR2,
        ERROR_TEXT                      OUT     VARCHAR2
    );
    /*********************************************************/

    PROCEDURE getDD_EnquiryOptions (
        io_cursor                       IN OUT  dd_cursor_enquiry_options,
        error_boolean                   OUT     VARCHAR2,
        ERROR_TEXT                      OUT     VARCHAR2
    );
    /*********************************************************/
    
    PROCEDURE updateStudEnquiry (
        enquiry_id_in                   IN       VARCHAR2,
        enquiry_option_id_in            IN       VARCHAR2,
        session_code_in                 IN       VARCHAR2,
        user_in                         IN       VARCHAR2,
        error_boolean                   OUT      VARCHAR2,
        ERROR_TEXT                      OUT      VARCHAR2
    );
    /*********************************************************/
    
END pk_steps_ui_stud_enquiry;
/