/* Formatted on 2011/05/16 11:28 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_ui_edm
AS
/******************************************************************************
   NAME:       pk_steps_ui_EDM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008  PADDY GRACE      Created this package.
   1.1        16/05/2011  PaDDY GRACE      Amended Update EDM Images proc
******************************************************************************/

   --
   TYPE edmimages_cursor IS REF CURSOR;

   TYPE doctype_cursor IS REF CURSOR;

   TYPE studentlist_cursor IS REF CURSOR;

   PROCEDURE getedmconfigdata (
      eistream_domain_name   OUT   VARCHAR2,
      edm_client_path        OUT   VARCHAR2,
      edm_server_path        OUT   VARCHAR2,
      error_boolean          OUT   VARCHAR2,
      ERROR_TEXT             OUT   VARCHAR2
   );

   PROCEDURE getedmimages (
      stud_ref_no_in   IN       VARCHAR2,
      io_cursor        IN OUT   edmimages_cursor,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   );

   FUNCTION edm_doctype_to_doctypename (document_type_code_in IN VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE edm_doctypename_to_doctype (
      document_name_in         IN       VARCHAR2,
      document_type_code_out   OUT      VARCHAR2,
      error_boolean            OUT      VARCHAR2,
      ERROR_TEXT               OUT      VARCHAR2
   );

   PROCEDURE insertedmimages (
      stud_ref_no_in            IN       VARCHAR2,
      annot_in                  IN       VARCHAR2,
      attachment_type_code_in   IN       VARCHAR2,
      batch_id_in               IN       VARCHAR2,
      batch_type_code_in        IN       VARCHAR2,
      document_name_in          IN       VARCHAR2,
      document_type_code_in     IN       VARCHAR2,
      document_type_count_in    IN       VARCHAR2,
      envelope_id_in            IN       VARCHAR2,
      object_id_in              IN       VARCHAR2,
      raw_data_id_in            IN       VARCHAR2,
      req_original_in           IN       VARCHAR2,
      rescan_in                 IN       VARCHAR2,
      rescan_req_in             IN       VARCHAR2,
      rescan_request_id_in      IN       VARCHAR2,
      scan_date_in              IN       VARCHAR2,
      session_code_in           IN       VARCHAR2,
      upload_date_in            IN       VARCHAR2,
      viewed_doc_in             IN       VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2,
      row_count                 OUT      VARCHAR2
   );

   PROCEDURE updateedmimages (
      stud_ref_no_in              IN       VARCHAR2,
      dbase_flag                  IN       VARCHAR2,
      object_id_in                IN       VARCHAR2,
      session_year_in             IN       VARCHAR2,
      old_document_type_code_in   IN       VARCHAR2,
      new_document_type_code_in   IN       VARCHAR2,
      document_name_in            IN       VARCHAR2,
      error_boolean               OUT      VARCHAR2,
      ERROR_TEXT                  OUT      VARCHAR2,
      row_count                   OUT      VARCHAR2
   );

   PROCEDURE getedmstudentdetails (
      stud_ref_no_in         IN       VARCHAR2,
      dbase_flag             IN       VARCHAR2,
      stud_crse_year_id_in   IN       VARCHAR2,
      stud_session_id_in     IN       VARCHAR2,
      student_surname        OUT      VARCHAR2,
      student_postcode       OUT      VARCHAR2,
      student_addr_l1        OUT      VARCHAR2,
      student_inst_name      OUT      VARCHAR2,
      student_course_name    OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   PROCEDURE getapplicabledoctypecode (
      file_ext_in     IN       VARCHAR2,
      io_cursor       IN OUT   doctype_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE edmrescan (
      object_id_in            IN       VARCHAR2,
      dbase_flag              IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      rescan_request_id_in    IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   );

   PROCEDURE edm_orig_req (
      object_id_in            IN       VARCHAR2,
      dbase_flag              IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   );

   PROCEDURE setviewed (
      object_id_in            IN       VARCHAR2,
      dbase_flag              IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   );
END pk_steps_ui_edm;
/