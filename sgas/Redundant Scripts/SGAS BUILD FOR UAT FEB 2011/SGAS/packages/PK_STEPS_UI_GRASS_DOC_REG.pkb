CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_grass_doc_reg
AS
/******************************************************************************
   NAME:       pk_steps_ui_grass_doc_reg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        04/08/2008      PADDY GRACE Created this package.
******************************************************************************/
   PROCEDURE getdocreg (
      stud_ref_no_in   IN       VARCHAR2,
      io_cursor        IN OUT   doc_reg_cursor,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   )
   AS
      dr_cursor   doc_reg_cursor;
   BEGIN
      OPEN dr_cursor FOR
         SELECT ROWNUM as rownum, TO_DATE (arg.received_date, 'dd-MM-yyyy') as received_date,
                arg.session_code as session_code, TO_DATE (arg.returned_date, 'dd-MM-yyyy') as returned_date,
                arg.document_type as document_type
           FROM applic_reg@grass arg
          WHERE arg.stud_ref_no = stud_ref_no_in;

      io_cursor := dr_cursor;
      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdocreg;
END pk_steps_ui_grass_doc_reg;
/
