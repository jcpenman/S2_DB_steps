CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_study_abroad
AS
/******************************************************************************
   NAME:       pk_steps_ui_STUDY_ABROAD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        17/11/2008      PADDY GRACE           Created this package.
   1.1        24/11/2008     ABIRAMI CHIDAMBARAM   Code Population
******************************************************************************/
   TYPE studycountry_cursor IS REF CURSOR;

   PROCEDURE getstudyabroad (
      stud_crse_year_id_in   IN              VARCHAR2,
      study_abroad_out       OUT NOCOPY      VARCHAR2,
      erasmus_out            OUT NOCOPY      VARCHAR2,
      stud_country_out       OUT NOCOPY      VARCHAR2,
      startdate_out          OUT NOCOPY      VARCHAR2,
      enddate_out            OUT NOCOPY      VARCHAR2,
      non_erasmus_out        OUT NOCOPY      VARCHAR2,
      session_code_out       OUT NOCOPY      VARCHAR2,              
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setstudyabroad (
      stud_crse_year_id_in   IN              VARCHAR2,
      study_abroad_in        IN              VARCHAR2,
      erasmus_in             IN              VARCHAR2,
      stud_country_in        IN              VARCHAR2,
      startdate_in           IN              VARCHAR2,
      enddate_in             IN              VARCHAR2,
      user_in                IN              VARCHAR2,
      non_erasmus_in         IN              VARCHAR2,      
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getstudycountry (
      io_cursor       IN OUT          studycountry_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );

END pk_steps_ui_study_abroad;
/
