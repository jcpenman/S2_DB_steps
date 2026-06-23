CREATE OR REPLACE PACKAGE SGAS.pk_short_apps AS

/******************************************************************************
   NAME:       PK_SHORT_APPS
   PURPOSE:    SELECTS DATA FROM THE GRASS DATABASE FOR STEPS SHORTENNED APPLICATION
               THIS LOOKS THE DATA UP IN THE STEPS DATABASE

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03.11.2008   Paul Hughes      Created this package body
   1.1       07.04.2009   Paul Hughes      Tidy of Code
******************************************************************************/

type all_shortapp_all_cursor IS ref CURSOR;

PROCEDURE all_shortapp_all(p_stud_ref_no IN NUMBER,p_session_code IN NUMBER, io_cursor IN OUT all_shortapp_all_cursor);

END pk_short_apps;
/
