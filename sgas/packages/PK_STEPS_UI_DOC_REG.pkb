/* Formatted on 2011/02/07 13:58 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY sgas.pk_steps_ui_doc_reg
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
   PROCEDURE getdocumentregister (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          docregister_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
      dr_cursor   docregister_cursor;
   BEGIN
      OPEN dr_cursor FOR
         SELECT ar.applic_reg_id, ar.session_code, ar.doc_type_id,
                ar.document_type,
                TO_CHAR (TO_DATE (ar.received_date, 'DD-MM-YYYY')
                        ) AS received_date,
                TO_CHAR (TO_DATE (ar.returned_date, 'DD-MM-YYYY')
                        ) AS returned_date,
                ar.last_updated_by,
                TO_CHAR (TO_DATE (ar.last_updated_on, 'DD-MM-YYYY')
                        ) AS last_updated_on
           FROM applic_reg ar
          WHERE ar.stud_ref_no = stud_ref_no_in;

      io_cursor := dr_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getdocumentregister;

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
   )
   IS
      doc_desc   VARCHAR2 (100);
   BEGIN
      UPDATE applic_reg ar
         SET ar.session_code = session_code_in,
             ar.doc_type_id = doc_type_id_in,
             ar.document_type = document_type_in,
             ar.received_date = received_date_in,
             ar.returned_date = returned_date_in,
             ar.last_updated_by = UPPER (employee_in),
             ar.last_updated_on = SYSDATE
       WHERE ar.applic_reg_id = applic_reg_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setdocumentregister;

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
   )
   AS
   BEGIN
      INSERT INTO applic_reg ar
                  (ar.applic_reg_id, ar.stud_ref_no,
                   ar.session_code, ar.doc_type_id, ar.document_type,
                   ar.received_date, ar.returned_date, ar.last_updated_by,
                   ar.last_updated_on
                  )
           VALUES (applic_reg_id_seq.NEXTVAL, stud_ref_no_in,
                   session_code_in, doc_type_id_in, document_type_in,
                   received_date_in, returned_date_in, UPPER (employee_in),
                   SYSDATE
                  );

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertdocumentregister;
END pk_steps_ui_doc_reg;
/