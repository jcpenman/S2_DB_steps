/* Formatted on 2010/08/09 12:43 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_ui_doc_reg
AS
/******************************************************************************
   NAME:       pk_steps_ui_DOC_REG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                        Description
   ---------  ----------  ---------------               ------------------------------------
   1.0        17/11/2008      PADDY GRACE               Created this package.
   1.1        06/05/2009     ABIRAMI CHIDAMBARAM        Code Population
******************************************************************************/
   TYPE docregister_cursor IS REF CURSOR;

   TYPE doctype_cursor IS REF CURSOR;

   PROCEDURE getdocumentregister (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          docregister_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setdocumentregister (
      applic_reg_id_in   IN       VARCHAR2,
      session_code_in    IN       VARCHAR2,
      doc_type_id_in     IN       VARCHAR2,
      document_type_in   IN       VARCHAR2,
      received_date_in   IN       DATE,
      returned_date_in   IN       DATE,
      employee_in        IN       VARCHAR2,
      error_boolean      OUT      VARCHAR2,
      ERROR_TEXT         OUT      VARCHAR2
   );

   PROCEDURE insertdocumentregister (
      stud_ref_no_in     IN       NUMBER,
      session_code_in    IN       NUMBER,
      doc_type_id_in     IN       NUMBER,
      document_type_in   IN       VARCHAR2,
      received_date_in   IN       DATE,
      returned_date_in   IN       DATE,
      employee_in        IN       VARCHAR2,
      error_boolean      OUT      VARCHAR2,
      ERROR_TEXT         OUT      VARCHAR2
   );

END pk_steps_ui_doc_reg;
/