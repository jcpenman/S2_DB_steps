CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_supp_grants
AS
/******************************************************************************
   NAME:       pk_steps_ui_SUPP_GRANTS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        17/11/2008      PADDY GRACE           Created this package.
   1.1        01/12/2008     ABIRAMI CHIDAMBARAM   Code Population
******************************************************************************/
   TYPE dep_cursor IS REF CURSOR;

   PROCEDURE getdependants (
      stud_session_id_in   IN              NUMBER,
      io_cursor            IN OUT          dep_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setdependants (
      stud_session_id_in   IN       NUMBER,
      std_id_in            IN       NUMBER,
      first_name_in        IN       VARCHAR2,
      surname_in           IN       VARCHAR2,
      relation_id_in       IN       NUMBER,
      dob_in               IN       DATE,
      start_date_in        IN       DATE,
      end_date_in          IN       DATE,
      income_in            IN       NUMBER,
      user_in              IN       VARCHAR2,
      email_addr_in        IN       VARCHAR2,
      postcode_in          IN       VARCHAR2,
      house_no_name_in     IN       VARCHAR2,
      addr_l1_in           IN       VARCHAR2,
      addr_l2_in           IN       VARCHAR2,
      addr_l3_in           IN       VARCHAR2,
      addr_l4_in           IN       VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2,
      row_count            OUT      VARCHAR2
   );

   PROCEDURE insertdependants (
      stud_session_id_in   IN       NUMBER,
      first_name_in        IN       VARCHAR2,
      surname_in           IN       VARCHAR2,
      relation_id_in       IN       NUMBER,
      dob_in               IN       DATE,
      start_date_in        IN       DATE,
      end_date_in          IN       DATE,
      income_in            IN       NUMBER,
      user_in              IN       VARCHAR2,
      email_addr_in        IN       VARCHAR2,
      post_code_in         IN       VARCHAR2,
      house_no_name_in     IN       VARCHAR2,
      addr_l1_in           IN       VARCHAR2,
      addr_l2_in           IN       VARCHAR2,
      addr_l3_in           IN       VARCHAR2, 
      addr_l4_in           IN       VARCHAR2, 
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2,
      row_count            OUT      VARCHAR2
   );

   PROCEDURE deletedependants (
      stud_session_id_in   IN       NUMBER,
      std_id_in            IN       NUMBER,
      user_in              IN       VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2,
      row_count            OUT      VARCHAR2
   );

   PROCEDURE getlpcg (
      stud_session_id_in    IN              VARCHAR2,
      max_lpcg_paid_out     OUT NOCOPY      VARCHAR2,
      lpcg_paid_amt_out     OUT NOCOPY      VARCHAR2,
      child_care_no_out     OUT NOCOPY      VARCHAR2,
      child_care_name_out   OUT NOCOPY      VARCHAR2,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setlpcg (
      stud_session_id_in   IN              VARCHAR2,
      max_lpcg_paid_in     IN              VARCHAR2,
      lpcg_paid_amt_in     IN              NUMBER,
      child_care_no_in     IN              VARCHAR2,
      child_care_name_in   IN              VARCHAR2,
      employee_in          IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );
   
   PROCEDURE setsag(
      stud_session_id_in         IN              VARCHAR2,
      accommodation_informal_in  IN              VARCHAR2,
      accommodation_formal_in    IN              VARCHAR2,
      employee_in                IN              VARCHAR2,
      error_boolean              OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                 OUT NOCOPY      VARCHAR2
      );
      
   PROCEDURE getsag   (
      stud_session_id_in     IN              VARCHAR2,
      accommodation_informal_out OUT NOCOPY      VARCHAR2,
      accommodation_formal_out OUT NOCOPY      VARCHAR2,
      session_code_out       OUT NOCOPY      VARCHAR2,
      care_exp_evidence_out       OUT NOCOPY VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
      );

   PROCEDURE checkdupdep (
      stud_session_id_in   IN       VARCHAR2,
      forename_in          IN       VARCHAR2,
      surname_in           IN       VARCHAR2,
      stud_dep_id_in       IN       VARCHAR2,
      dup_count            OUT      VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   );

   PROCEDURE checkdupspouse (
      stud_session_id_in   IN       VARCHAR2,
      countdupspouse       OUT      VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   );

   PROCEDURE getstudcrseyearid (
      stud_session_id_in      IN       VARCHAR2,
      stud_crse_year_id_out   OUT      VARCHAR2,
      session_code_out        OUT      VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2
   );

   PROCEDURE getrelativedate (
      stud_session_id_in   IN       VARCHAR2,
      relativedate         OUT      VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      ERROR_TEXT           OUT      VARCHAR2
   );
END pk_steps_ui_supp_grants;
/