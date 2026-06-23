CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_loan
AS
/******************************************************************************
   NAME:       pk_steps_ui_LOAN
   PURPOSE:

   REVISIONS:
   Ver        Date              Author                  Description
   ---------  ----------        ---------------         ------------------------------------
   1.0        17/11/2008         PADDY GRACE            Created this package.
   1.1        09/06/2009         ABIRAMI CHIDAMBARAM    Code Population.
******************************************************************************/
   TYPE loanconatctone_cursor IS REF CURSOR;

   TYPE loanconatcttwo_cursor IS REF CURSOR;

   TYPE loandetails_cursor IS REF CURSOR;

   TYPE feeloandetails_cursor IS REF CURSOR;

   TYPE studloancompany_cursor IS REF CURSOR;

   PROCEDURE getloancontactone (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          loanconatctone_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getloancontacttwo (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          loanconatcttwo_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          loandetails_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getfeeloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      stud_ref_no_in         IN              VARCHAR2,
      io_cursor              IN OUT          feeloandetails_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getslc (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          studloancompany_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setloancontactone (
      stud_ref_no_in   IN              VARCHAR2,
      NAME_IN          IN              VARCHAR2,
      rel_in           IN              VARCHAR2,
      addr_l1_in       IN              VARCHAR2,
      addr_l2_in       IN              VARCHAR2,
      addr_l3_in       IN              VARCHAR2,
      postcode_in      IN              VARCHAR2,
      tele_no_in       IN              VARCHAR2,
      user_in          IN              VARCHAR2,
      row_count        OUT             VARCHAR2,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setloancontacttwo (
      stud_ref_no_in   IN              VARCHAR2,
      NAME_IN          IN              VARCHAR2,
      addr_l1_in       IN              VARCHAR2,
      addr_l2_in       IN              VARCHAR2,
      addr_l3_in       IN              VARCHAR2,
      postcode_in      IN              VARCHAR2,
      tele_no_in       IN              VARCHAR2,
      user_in          IN              VARCHAR2,
      row_count        OUT             VARCHAR2,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      stud_ref_no_in         IN              VARCHAR2,
      max_loan_in            IN              VARCHAR2,
      loan_given_in          IN              VARCHAR2,
      loan_request_in        IN              VARCHAR2,
      loan_dec_date          IN              DATE,
      reason_no_nino_in      IN              VARCHAR2,
      bankrupt_in            IN              VARCHAR2,
      user_in                IN              VARCHAR2,
      row_count_ss           OUT             VARCHAR2,
      row_count_sc           OUT             VARCHAR2,
      row_count_s            OUT             VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setfeeloandetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      stud_ref_no_in         IN              VARCHAR2,
      max_fee_loan_in        IN              VARCHAR2,
      fee_loan_given_in      IN              VARCHAR2,
      fee_loan_request_in    IN              VARCHAR2,
      fee_loan_charged_in    IN              VARCHAR2,
      fee_loan_dec_date      IN              DATE,
      user_in                IN              VARCHAR2,
      row_count_ss           OUT             VARCHAR2,
      row_count_sc           OUT             VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE insertloancontactone (
      stud_ref_no_in   IN              VARCHAR2,
      NAME_IN          IN              VARCHAR2,
      rel_in           IN              VARCHAR2,
      addr_l1_in       IN              VARCHAR2,
      addr_l2_in       IN              VARCHAR2,
      addr_l3_in       IN              VARCHAR2,
      postcode_in      IN              VARCHAR2,
      tele_no_in       IN              VARCHAR2,
      user_in          IN              VARCHAR2,
      row_count        OUT             VARCHAR2,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE insertloancontacttwo (
      stud_ref_no_in   IN              VARCHAR2,
      NAME_IN          IN              VARCHAR2,
      addr_l1_in       IN              VARCHAR2,
      addr_l2_in       IN              VARCHAR2,
      addr_l3_in       IN              VARCHAR2,
      postcode_in      IN              VARCHAR2,
      tele_no_in       IN              VARCHAR2,
      user_in          IN              VARCHAR2,
      row_count        OUT             VARCHAR2,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setslc (
      stud_crse_year_id_in   IN              VARCHAR2,
      loan_ass_status_in     IN              VARCHAR2,
      loan_app_status_in     IN              VARCHAR2,
      user_in                IN              VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );
   
  PROCEDURE deleteloancontact (
      stud_ref_no_in      IN              VARCHAR2,
      contact_number_in   IN              VARCHAR2,
      user_in             IN              VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   );   
END pk_steps_ui_loan;
/
