CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_finance
AS 
/******************************************************************************
   NAME:       PK_STEPS_UI_FINANCE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        01/10/2012   John Wynne      Created this package.
   1.1        14/02/2013   John Wynne      Added Get award types
   1.2        17/04/2013   John Wynne      Corrected defect in findtotalstudentspayment
******************************************************************************/
   TYPE methods_cursor IS REF CURSOR;

   TYPE statuses_cursor IS REF CURSOR;

   TYPE payee_type_cursor IS REF CURSOR;

   TYPE dd_cursor_awardtype IS REF CURSOR;

   TYPE sat_awardtype_cursor IS REF CURSOR;

   TYPE stud_awards_cursor IS REF CURSOR;

   TYPE stud_payment_awards_cursor IS REF CURSOR;

   PROCEDURE getmethod (
      io_cursor       IN OUT          methods_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getstatuses (
      io_cursor       IN OUT          statuses_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getpayeetype (
      io_cursor       IN OUT          payee_type_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

   PROCEDURE findstudent (
      stud_ref_in       IN              VARCHAR2,
      stud_exists_out   OUT             VARCHAR2,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   );

   PROCEDURE checkpaymentreturned (
      payee_payment_id_in   IN              VARCHAR2,
      payment_exists_out    OUT             VARCHAR2,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   );

   PROCEDURE findtotalstudentspayment (
      payee_ref_id_in     IN              VARCHAR2,
      award_type_in       IN              VARCHAR2,
      total_payment_out   OUT             NUMBER,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getstudentsawardtypepayments (
      io_cursor         IN OUT          sat_awardtype_cursor,
      payee_ref_id_in   IN              VARCHAR2,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getawardtypes (
      io_cursor         IN OUT   dd_cursor_awardtype,
      payee_ref_id_in   IN       VARCHAR2,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   );

   PROCEDURE insertreturnedpayment (
      batch_date           IN              VARCHAR2,
      amount               IN              VARCHAR2,
      receipt_type_value   IN              VARCHAR2,
      payment_date         IN              VARCHAR2,
      payer_payment_id     IN              VARCHAR2,
      payer_ref            IN              VARCHAR2,
      payer_name           IN              VARCHAR2,
      award_type_value     IN              VARCHAR2,
      user_in              IN              VARCHAR2,
      method_value         IN              VARCHAR2,
      batch_reference      IN              VARCHAR2,
      ret_status           IN              VARCHAR2,
      override_in          IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getstudawardtypes (
      io_cursor        IN OUT          stud_awards_cursor,
      stud_ref_no_in   IN              VARCHAR2,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getstudname (
      payee_ref_no_in   IN              VARCHAR2,
      payee_type_in     IN              VARCHAR2,
      student_name      OUT             VARCHAR2,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getstudawardpayments (
      payee_ref_no_in   IN              VARCHAR2,
      payee_type_in     IN              VARCHAR2,
      io_cursor         IN OUT          stud_payment_awards_cursor,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   );
END pk_steps_ui_finance;
/