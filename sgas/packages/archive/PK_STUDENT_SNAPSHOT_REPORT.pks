CREATE OR REPLACE PACKAGE SGAS.pk_student_snapshot_report
AS
/******************************************************************************
   NAME:       pk_student_snapshot_report
   PURPOSE:

   REVISIONS:
   Ver        Date        Author            Description
   ---------  ----------  ---------------   ------------------------------------
   1.0        14/02/2012  A.Bowman          Created this package.
   1.1        26/06/2012  J.Wynne           Modified get_stcy_dets to format dates
   2.0        03/07/2012  J.Wynne           Added two new procdeures get_loan_dets and getloan_total_dets 
   2.1        12/07/2012  J.Wynne           Added procedure get_awards_paid_out  
******************************************************************************/
   TYPE session_code_cursor IS REF CURSOR;

   TYPE stcy_dets_cursor IS REF CURSOR;

   TYPE award_dets_cursor IS REF CURSOR;

   TYPE fee_award_dets_cursor IS REF CURSOR;
   
   TYPE loan_dets_cursor IS REF CURSOR;
   
   TYPE loan_total_dets_cursor IS REF CURSOR;
   
   TYPE award_payment_cursor IS REF CURSOR;
   
   PROCEDURE get_header_info (
      stud_ref_no_in       IN              VARCHAR2,
      name_out             OUT NOCOPY      VARCHAR2,
      nino_out             OUT NOCOPY      VARCHAR2,
      dob_out              OUT NOCOPY      VARCHAR2,
      marital_status_out   OUT NOCOPY      VARCHAR2,
      house_no_name_out    OUT NOCOPY      VARCHAR2,
      addr1_out            OUT NOCOPY      VARCHAR2,
      addr2_out            OUT NOCOPY      VARCHAR2,
      addr3_out            OUT NOCOPY      VARCHAR2,
      addr4_out            OUT NOCOPY      VARCHAR2,
      post_code_out        OUT NOCOPY      VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_session_code (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          session_code_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_stcy_dets (
      stud_session_id_in   IN              VARCHAR2,
      io_cursor            IN OUT          stcy_dets_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_award_dets (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          award_dets_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE get_fee_award_dets (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          fee_award_dets_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );
   
   PROCEDURE get_loan_dets (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          loan_dets_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2            
   );
   
   PROCEDURE get_loan_total_dets (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          loan_total_dets_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2            
   );   
   
   PROCEDURE get_awards_paid_out (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          award_payment_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );
   
END pk_student_snapshot_report;
/
