CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_UI_GRASS_SUPP_GRANTS AS
/******************************************************************************
   NAME:       pk_steps_ui_grass_SUPP_GRANTS
   PURPOSE:

   REVISIONS:
   Ver        Date              Author                  Description
   ---------  ----------        ---------------         ------------------------------------
   1.0        28/01/2009      ABIRANI CHIDAMBARAM       Created this package.
******************************************************************************/
  TYPE dep_cursor IS REF CURSOR;
  TYPE lpg_cursor IS REF CURSOR;
  
  PROCEDURE getdependants (
      stud_session_id_in     IN              NUMBER,
      io_cursor              IN OUT          dep_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   ); 
   
      PROCEDURE getLPG (
      stud_session_id_in     IN              NUMBER,
      io_cursor              IN OUT          lpg_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

END PK_STEPS_UI_GRASS_SUPP_GRANTS; 
/

