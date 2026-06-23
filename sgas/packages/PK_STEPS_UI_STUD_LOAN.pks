CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_stud_loan
AS
/******************************************************************************
   NAME:       pk_steps_ui_LOAN
   PURPOSE:

   REVISIONS:
   Ver        Date              Author                  Description
   ---------  ----------        ---------------         ------------------------------------
   1.0        06/10/2011        PADDY GRACE            Created this package.
******************************************************************************/
   FUNCTION loan_contact_exists (
      stud_ref_no_in      IN   VARCHAR2,
      contact_number_in   IN   VARCHAR2
   )
      RETURN NUMBER;

   PROCEDURE checkloancontact (
      stud_ref_no_in      IN              VARCHAR2,
      contact_number_in   IN              VARCHAR2,
      contact_exists      OUT NOCOPY      VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getloancontact (
      stud_ref_no_in      IN              VARCHAR2,
      contact_number_in   IN              VARCHAR2,
      contact_name        OUT NOCOPY      VARCHAR2,
      relationship        OUT NOCOPY      VARCHAR2,
      addrl1              OUT NOCOPY      VARCHAR2,
      addrl2              OUT NOCOPY      VARCHAR2,
      addrl3              OUT NOCOPY      VARCHAR2,
      postcode            OUT NOCOPY      VARCHAR2,
      tele_no             OUT NOCOPY      VARCHAR2,
      record_count        OUT NOCOPY      VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setloancontact (
      stud_ref_no_in      IN              VARCHAR2,
      contact_number_in   IN              VARCHAR2,
      contact_name_in     IN              VARCHAR2,
      relationship_in     IN              VARCHAR2,
      addr_l1_in          IN              VARCHAR2,
      addr_l2_in          IN              VARCHAR2,
      addr_l3_in          IN              VARCHAR2,
      postcode_in         IN              VARCHAR2,
      tele_no_in          IN              VARCHAR2,
      employee_in         IN              VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   );

   PROCEDURE insertloancontact (
      stud_ref_no_in      IN              VARCHAR2,
      contact_number_in   IN              VARCHAR2,
      contact_name_in     IN              VARCHAR2,
      relationship_in     IN              VARCHAR2,
      addrl1_in           IN              VARCHAR2,
      addrl2_in           IN              VARCHAR2,
      addrl3_in           IN              VARCHAR2,
      postcode_in         IN              VARCHAR2,
      tele_no_in          IN              VARCHAR2,
      employee_in         IN              VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   );

   PROCEDURE deleteloancontact (
      stud_ref_no_in      IN              VARCHAR2,
      contact_number_in   IN              VARCHAR2,
      employee_in         IN              VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      maximum_loan           OUT NOCOPY      VARCHAR2,
      loan_given             OUT NOCOPY      VARCHAR2,
      loan_amount            OUT NOCOPY      VARCHAR2,
      loan_sign_date         OUT NOCOPY      VARCHAR2,
      no_nino_reason         OUT NOCOPY      VARCHAR2,
      bankrupt               OUT NOCOPY      VARCHAR2,
      nino                   OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      max_loan_in            IN              VARCHAR2,
      loan_given_in          IN              VARCHAR2,
      loan_request_in        IN              VARCHAR2,
      loan_dec_date_in       IN              VARCHAR2,
      reason_no_nino_in      IN              VARCHAR2,
      bankrupt_in            IN              VARCHAR2,
      employee_in            IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getfeeloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      max_fee_loan           OUT NOCOPY      VARCHAR2,
      fee_loan_amt           OUT NOCOPY      VARCHAR2,
      fee_loan_charged       OUT NOCOPY      VARCHAR2,
      fee_loan_given         OUT NOCOPY      VARCHAR2,
      fee_loan_sign_date     OUT NOCOPY      VARCHAR2,
      record_count           OUT NOCOPY      VARCHAR2,
      commence_session       OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setfeeloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      max_fee_loan_in        IN              VARCHAR2,
      fee_loan_given_in      IN              VARCHAR2,
      fee_loan_request_in    IN              VARCHAR2,
      fee_loan_charged_in    IN              VARCHAR2,
      fee_loan_dec_date_in   IN              VARCHAR2,
      employee_in            IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getslc (
      stud_crse_year_id_in   IN              VARCHAR2,
      slc_ref_num            OUT NOCOPY      VARCHAR2,
      loan_ass_last_sent     OUT NOCOPY      VARCHAR2,
      loan_ass_status        OUT NOCOPY      VARCHAR2,
      loan_ass_first_sent    OUT NOCOPY      VARCHAR2,
      loan_app_last_sent     OUT NOCOPY      VARCHAR2,
      loan_app_status        OUT NOCOPY      VARCHAR2,
      loan_app_first_sent    OUT NOCOPY      VARCHAR2,
      loan_slc1_sent         OUT NOCOPY      VARCHAR2,
      loan_slc2_sent         OUT NOCOPY      VARCHAR2,      
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setslc (
      stud_crse_year_id_in   IN              VARCHAR2,
      loan_ass_status_in     IN              VARCHAR2,
      loan_app_status_in     IN              VARCHAR2,
      employee_in            IN              VARCHAR2,
      slc1_sent_in           IN              VARCHAR2,
      slc2_sent_in           IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );
   
   PROCEDURE getslcfeeloan (
      stud_crse_year_id_in   IN              VARCHAR2,
      stud_session_id_in     IN              VARCHAR2,
      slc_ref_num            OUT NOCOPY      VARCHAR2,
      fee_loan_ass_sent_date OUT NOCOPY      VARCHAR2,
      fee_loan_ass_sent      OUT NOCOPY      VARCHAR2,
      fee_loan_status        OUT NOCOPY      VARCHAR2,
      fee_loan_app_sent_date OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );
   
   PROCEDURE setslcfeeloan (
      stud_crse_year_id_in   IN              VARCHAR2,
      fee_loan_status_in     IN              VARCHAR2,
      employee_in            IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

END pk_steps_ui_stud_loan;
/