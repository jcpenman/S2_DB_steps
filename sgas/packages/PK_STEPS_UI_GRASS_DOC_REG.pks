CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_grass_doc_reg
AS
/******************************************************************************
   NAME:       pk_steps_ui_grass_doc_reg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/08/2008      PADDY GRACE Created this package.
******************************************************************************/
TYPE doc_reg_cursor IS REF CURSOR;

   PROCEDURE getdocreg (
      stud_ref_no_in   IN       VARCHAR2,
      io_cursor        IN OUT   doc_reg_cursor,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   );
END pk_steps_ui_grass_doc_reg;
/
