CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_manual_payments
AS
/******************************************************************************
   NAME:       pk_steps_ui_MANUAL_PAYMENTS
   PURPOSE:

   REVISIONS:
   Ver        Date          Author                  Description
   ---------  ----------    ---------------         ------------------------------------
   1.0        04/10/2010    PADDY GRACE             Created this package.
   1.1        25/02/2013    paddy Grace             added ADHOC_TYPE field to getawardinstalments, updateawardinstalments, insertawardinstalments
******************************************************************************/
   TYPE i_cursor IS REF CURSOR;

   PROCEDURE getcontribanddebt (
      stud_crse_year_id_in       IN       VARCHAR2,
      overpayment                OUT      VARCHAR2,
      outstanding_contribution   OUT      VARCHAR2,
      error_boolean              OUT      VARCHAR2,
      ERROR_TEXT                 OUT      VARCHAR2
   );

   PROCEDURE getawardinstalments (
      award_id_in     IN       VARCHAR2,
      io_cursor       IN OUT   i_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE updateawardinstalment (
      award_instalment_id_in   IN       VARCHAR2,
      pay_due_date_in          IN       DATE,
      amount_in                IN       VARCHAR2,
      recovered_amount_in      IN       VARCHAR2,
      contrib_amount_in        IN       VARCHAR2,
      net_amount_in            IN       VARCHAR2,
      returned_in              IN       VARCHAR2,
      employee_in              IN       VARCHAR2,
      payee_reference_in       IN       VARCHAR2,
      adhoc_type_in            IN       VARCHAR2,
      error_boolean            OUT      VARCHAR2,
      ERROR_TEXT               OUT      VARCHAR2
   );

   PROCEDURE insertawardinstalment (
      award_id_in           IN       VARCHAR2,
      payment_due_date_in   IN       DATE,
      amount_in             IN       VARCHAR2,
      recovered_amount_in   IN       VARCHAR2,
      contrib_amount_in     IN       VARCHAR2,
      net_amount_in         IN       VARCHAR2,
      chaps_in              IN       VARCHAR2,
      adhoc_type_in         IN       VARCHAR2,
      employee_in           IN       VARCHAR2,
      error_boolean         OUT      VARCHAR2,
      ERROR_TEXT            OUT      VARCHAR2
   );

   PROCEDURE updateothers (
      award_id_in               IN       VARCHAR2,
      overpayment_diff_in       IN       VARCHAR2,
      snb_overpayment_diff_in   IN       VARCHAR2,
      resid_par_cont_diff_in    IN       VARCHAR2,
      employee_in               IN       VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2
   );

   PROCEDURE addaward (
      stud_crse_year_id_in   IN       VARCHAR2,
      amount_in              IN       VARCHAR2,
      contrib_in             IN       VARCHAR2,
      recovered_amount_in    IN       VARCHAR2,
      employee_in            IN       VARCHAR2,
      award_id_out           OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );
 PROCEDURE getawarddetails (
      stud_crse_year_id_in     IN       VARCHAR2,
      stud_award_type_in       IN       VARCHAR2,
      award_id_out             OUT      VARCHAR2,
      amount_out               OUT      VARCHAR2,
      net_amount_out           OUT      VARCHAR2,
      contrib_amount_out       OUT      VARCHAR2,
      recovered_amount_out     OUT      VARCHAR2,
      overpayment_amount_out   OUT      VARCHAR2,
      session_code_out         OUT      VARCHAR2,
      error_boolean            OUT      VARCHAR2,      
	  ERROR_TEXT               OUT      VARCHAR2
   );   
   PROCEDURE updateadhocaward (
      award_id_in                IN       VARCHAR2,
      old_amount_in              IN       VARCHAR2,
      old_contrib_in             IN       VARCHAR2,
      old_recovered_amount_in    IN       VARCHAR2,
      new_amount_in              IN       VARCHAR2,
      new_contrib_in             IN       VARCHAR2,
      new_recovered_amount_in    IN       VARCHAR2,
      employee_in                IN       VARCHAR2,  
      error_boolean              OUT      VARCHAR2,
      ERROR_TEXT                 OUT      VARCHAR2
   );   
   PROCEDURE getawardtype (
      stud_award_type_in                IN       VARCHAR2,
      stud_award_type_id_out            OUT      VARCHAR2,
      stud_award_type_out               OUT      VARCHAR2,
      scheme_out                        OUT      VARCHAR2,
      award_type_descript_out           OUT      VARCHAR2,
      saas_make_payment_out             OUT      VARCHAR2,
      error_boolean                     OUT      VARCHAR2,
      ERROR_TEXT                        OUT      VARCHAR2            
   );   
END pk_steps_ui_manual_payments;
/
