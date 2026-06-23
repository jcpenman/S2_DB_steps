CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_UI_GRASS_INSTALMENTS AS
/******************************************************************************
   NAME:       PK_STEPS_UI_GRASS_INSTALMENTS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                Description
   ---------  ----------  ---------------       ------------------------------------
   1.0        25/02/2010  ABIRAMI CHIDAMBARAM   1. Created and populated code.
******************************************************************************/
   TYPE instalment_cursor IS REF CURSOR;

   TYPE loan_cursor IS REF CURSOR;

   PROCEDURE instalments (
      reference_id_in        IN       VARCHAR2,
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   instalment_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   PROCEDURE getloanawarddetails (
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   loan_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );
END PK_STEPS_UI_GRASS_INSTALMENTS;
/
