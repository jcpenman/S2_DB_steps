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
      stud_session_id_in     IN              NUMBER,
      io_cursor              IN OUT          dep_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   ); 
     
   PROCEDURE setdependants (
      stud_session_id_in        IN       NUMBER,
      std_id_in                 IN       NUMBER,
      first_name_in             IN       VARCHAR2,
      surname_in                IN       VARCHAR2,
      relation_id_in            IN       NUMBER,
      dob_in                    IN       DATE,
      start_date_in             IN       DATE,
      end_date_in               IN       DATE,
      income_in                 IN       NUMBER,
      user_in                   IN       VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2,
      row_count                 OUT      VARCHAR2
   );
   
   PROCEDURE insertdependants (
      stud_session_id_in        IN       NUMBER,
      first_name_in             IN       VARCHAR2,
      surname_in                IN       VARCHAR2,
      relation_id_in            IN       NUMBER,
      dob_in                    IN       DATE,
      start_date_in             IN       DATE,
      end_date_in               IN       DATE,
      income_in                 IN       NUMBER,
      user_in                   IN       VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2,
      row_count                 OUT      VARCHAR2
   );
   
     PROCEDURE deletedependants (
      stud_session_id_in        IN       NUMBER,
      std_id_in                 IN       NUMBER,
      user_in                   IN       VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2,
      row_count                 OUT      VARCHAR2
   );
   
   PROCEDURE checkdupdep (
      stud_session_id_in        IN       NUMBER,
      forename_in               IN       VARCHAR2,
      surname_in                IN       VARCHAR2,
      dup_count                 OUT      VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2
   );
   
      PROCEDURE spousedepchck (
      stud_session_id_in        IN       NUMBER,
      spouse_dep_cnt            OUT      VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2
   );
   
   PROCEDURE getmaxLPCG (
   stud_session_id_in           IN              NUMBER,
   max_lpcg_paid_out            OUT NOCOPY      VARCHAR2,
   error_boolean                OUT NOCOPY      VARCHAR2,
   ERROR_TEXT                   OUT NOCOPY      VARCHAR2
   );
   
   PROCEDURE setmaxLPCG (
   stud_session_id_in           IN              NUMBER,
   max_lpcg_paid_in             IN              VARCHAR2,
   error_boolean                OUT NOCOPY      VARCHAR2,
   ERROR_TEXT                   OUT NOCOPY      VARCHAR2
   );
   
   PROCEDURE getamtLPCG (
   stud_session_id_in           IN              NUMBER,
   lpcg_paid_amt_out            OUT NOCOPY      NUMBER,
   error_boolean                OUT NOCOPY      VARCHAR2,
   ERROR_TEXT                   OUT NOCOPY      VARCHAR2
   );
   
   PROCEDURE setamtLPCG (
   stud_session_id_in           IN              NUMBER,
   lpcg_paid_amt_in             IN              NUMBER,
   error_boolean                OUT NOCOPY      VARCHAR2,
   ERROR_TEXT                   OUT NOCOPY      VARCHAR2
   );
   
   PROCEDURE getccnumLPCG (
   stud_session_id_in           IN              NUMBER,
   child_care_no_out            OUT NOCOPY      VARCHAR2,
   error_boolean                OUT NOCOPY      VARCHAR2,
   ERROR_TEXT                   OUT NOCOPY      VARCHAR2
   );
   
   PROCEDURE setccnumLPCG (
   stud_session_id_in           IN              NUMBER,
   child_care_no_in             IN              VARCHAR2,
   error_boolean                OUT NOCOPY      VARCHAR2,
   ERROR_TEXT                   OUT NOCOPY      VARCHAR2
   );
   
   PROCEDURE getccnameLPCG (
   stud_session_id_in           IN              NUMBER,
   child_care_name_out          OUT NOCOPY      VARCHAR2,
   error_boolean                OUT NOCOPY      VARCHAR2,
   ERROR_TEXT                   OUT NOCOPY      VARCHAR2
   );
   
   PROCEDURE setccnameLPCG (
   stud_session_id_in           IN              NUMBER,
   child_care_name_in           IN              VARCHAR2,
   error_boolean                OUT NOCOPY      VARCHAR2,
   ERROR_TEXT                   OUT NOCOPY      VARCHAR2
   );
   
END pk_steps_ui_supp_grants;
/
