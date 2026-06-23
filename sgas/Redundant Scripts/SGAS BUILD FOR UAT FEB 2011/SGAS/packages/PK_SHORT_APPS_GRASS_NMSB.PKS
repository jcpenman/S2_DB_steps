CREATE OR REPLACE PACKAGE SGAS.pk_short_apps_Grass_NMSB AS

/******************************************************************************
   NAME:       pk_short_appsNMSBGRASS
   PURPOSE:     To provide data to populate Student Applications for Shortenned Applications
                This points to the GRASS Database

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        28/01/2009  Paul Hughes          1. Created this package.
   1.1        07/04/2009  Paul Hughes          2. Tidy of Code
******************************************************************************/

type shortappGrassNMSB_cursor IS ref CURSOR;

PROCEDURE shortappGrassNMSB(p_stud_ref_no IN NUMBER,p_session_code IN NUMBER, io_cursor IN OUT shortappGrassNMSB_cursor);

END pk_short_apps_Grass_NMSB;
/
