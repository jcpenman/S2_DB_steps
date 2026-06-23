CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_deceasedStudent
AS
/******************************************************************************
   NAME:      pk_steps_ui_deceasedStudent
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   --------- ----------  ---------------           ------------------------------------
   1.0       09/08/2016   SURESH SHARADA            Created this package.
   
******************************************************************************/
   TYPE deceased_cursor IS REF CURSOR;

   PROCEDURE getDeceasedStatus (
      stud_ref_no_in   IN              NUMBER,
      latest_session_in     IN              VARCHAR2,
      io_cursor        IN OUT          deceased_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      error_text       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE updateDeceasedStudent (
      stud_ref_no_in       IN       NUMBER,
      date_Of_Death_in     IN       DATE,
      deceased_Source_in   IN       VARCHAR2,
      latest_session_in     IN      VARCHAR2,
      error_boolean        OUT      VARCHAR2,
      error_text           OUT      VARCHAR2
   );
   
   PROCEDURE finaliseBenefactorAllSession(
    
    stud_ref_no_in           IN      NUMBER,
      error_boolean        OUT      VARCHAR2,
      error_text           OUT      VARCHAR2
      
      
  );
   
   PROCEDURE CheckSLCExists(
     stud_ref_no_in           IN      NUMBER,
     slc_exists_out           OUT     VARCHAR2,
     error_boolean            OUT      VARCHAR2,
     error_text               OUT      VARCHAR2
      
   );
END pk_steps_ui_deceasedStudent;
/
