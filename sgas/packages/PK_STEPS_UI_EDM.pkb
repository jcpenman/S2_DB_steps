CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_edm
AS
/******************************************************************************
   NAME:       pk_steps_ui_EDM
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008  PADDY GRACE      Created this package.
   1.1        16/05/2011  PADDY GRACE      Amended Update EDM Images proc
   1.2        03/06/2014  Ranj Benning     Amended Get EDM Images proc
******************************************************************************/
   PROCEDURE getedmconfigdata (
      eistream_domain_name   OUT   VARCHAR2,
      edm_client_path        OUT   VARCHAR2,
      edm_server_path        OUT   VARCHAR2,
      error_boolean          OUT   VARCHAR2,
      ERROR_TEXT             OUT   VARCHAR2
   )
   IS
   BEGIN
      SELECT c1, c2, c3
        INTO eistream_domain_name, edm_client_path, edm_server_path
        FROM (SELECT cval c1
                FROM config_data
               WHERE item_name = 'EISTREAM_DOMAIN_NAME'),
             (SELECT cval c2
                FROM config_data
               WHERE item_name = 'EDM_REMOTE_DIR'),
             (SELECT cval c3
                FROM config_data
               WHERE item_name = 'EDM_LOCAL_DIR');

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getedmconfigdata @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getedmconfigdata;

   /********************************************************************* 
   Ranj Benning - 03/06/2014 
   Ordering is done, in a 2 step process. This is done to have control over how rownum is assigned to result rows. This is important because rownum is used to label the rows with a unique identifier.
   The first part of the ordering is in the nested SQL call that orders results using scan_date ascending order. 
   This deals with the scenario whereby a user/caseworker is viewing a students EDM docs and then adds another doc.
   On the subsequent SQL call the rownum that is assigned to the added doc will be the next number in sequence (and the docs that were already returned in previous call will be assigned the same rownums they were previously assigned).
   The second part of the ordering is in the outer wrapper call which then re-orders the results in descending order as this is how it is to be displayed on screen. 
   **********************************************************************/
   PROCEDURE getedmimages (
      stud_ref_no_in   IN       VARCHAR2,
      io_cursor        IN OUT   edmimages_cursor,
      error_boolean    OUT      VARCHAR2,
      ERROR_TEXT       OUT      VARCHAR2
   )
   IS
      e_cursor   edmimages_cursor;
   BEGIN
      OPEN e_cursor FOR
         SELECT ROWNUM || '-' || object_id || '-' || document_name AS unique_id , 
                  source_db, annot, attachment_type_code,
                  batch_id, batch_type_code, document_name,
                  document_type_name, document_type_code,
                  document_type_count, envelope_id, object_id, raw_data_id,
                  req_original, rescan, rescan_req, rescan_request_id,
                  scan_date, session_code, upload_date, viewed_doc 
         FROM
             (SELECT * FROM (
                       SELECT 'S' AS source_db,
                              ei.annot, ei.attachment_type_code, ei.batch_id,
                              ei.batch_type_code, ei.document_name,
                              sgas.pk_steps_ui_edm.edm_doctype_to_doctypename
                                     (ei.document_type_code)
                                                            AS document_type_name,
                              ei.document_type_code, ei.document_type_count,
                              ei.envelope_id, ei.object_id, ei.raw_data_id,
                              ei.req_original, ei.rescan, ei.rescan_req,
                              ei.rescan_request_id, ei.scan_date, ei.session_code,
                              ei.upload_date, ei.viewed_doc
                         FROM edm_images ei
                        WHERE ei.stud_ref_no = stud_ref_no_in
                          AND ei.document_type_code != 'XML'
                          AND ei.rescan != 'Y'
                       UNION
                       SELECT 'G' AS source_db,
                              gei.annot, gei.attachment_type_code, gei.batch_id,
                              gei.batch_type_code, gei.document_name,
                              sgas.pk_steps_ui_edm.edm_doctype_to_doctypename
                                    (gei.document_type_code)
                                                            AS document_type_name,
                              gei.document_type_code, gei.document_type_count,
                              gei.envelope_id, gei.object_id, gei.raw_data_id,
                              gei.req_original, gei.rescan, gei.rescan_req,
                              gei.rescan_request_id, gei.scan_date,
                              gei.session_code, gei.upload_date, gei.viewed_doc
                         FROM edm_images@grass gei
                        WHERE gei.stud_ref_no = stud_ref_no_in
                          AND gei.document_type_code != 'XML'
                          AND gei.rescan != 'Y') a
                     ORDER BY scan_date ASC, object_id, document_name, document_type_code, upload_date)
         ORDER BY scan_date DESC, object_id, document_name, document_type_code, upload_date;
      io_cursor := e_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : edm : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getedmimages;

   FUNCTION edm_doctype_to_doctypename (document_type_code_in IN VARCHAR2)
      RETURN VARCHAR2
   AS
      v_doc_type_name   VARCHAR2 (50) := NULL;
      v_doc_count       NUMBER (2)    := NULL;
   BEGIN
      SELECT COUNT (*)
        INTO v_doc_count
        FROM config_edm
       WHERE document_type_code = document_type_code_in;

      IF v_doc_count > 0
      THEN
         SELECT document_type_name
           INTO v_doc_type_name
           FROM config_edm
          WHERE document_type_code = document_type_code_in;
      ELSE
         SELECT document_type_name
           INTO v_doc_type_name
           FROM config_edm@grass
          WHERE document_type_code = document_type_code_in;
      END IF;

      RETURN v_doc_type_name;
   END edm_doctype_to_doctypename;

   PROCEDURE edm_doctypename_to_doctype (
      document_name_in         IN       VARCHAR2,
      document_type_code_out   OUT      VARCHAR2,
      error_boolean            OUT      VARCHAR2,
      ERROR_TEXT               OUT      VARCHAR2
   )
   AS
   BEGIN
      SELECT document_type_code
        INTO document_type_code_out
        FROM config_edm
       WHERE document_type_name = document_name_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : edm_doctypename_to_doctype : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END edm_doctypename_to_doctype;

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
   )
   AS
   BEGIN
   
      ERROR_TEXT := 'Inserting document into edm_images ';
   
      INSERT INTO edm_images ei
                  (ei.annot, ei.attachment_type_code,
                   ei.batch_id, ei.batch_type_code,
                   ei.document_name, ei.document_type_code,
                   ei.document_type_count, ei.envelope_id,
                   ei.object_id, ei.raw_data_id, ei.req_original,
                   ei.rescan, ei.rescan_req, ei.rescan_request_id,
                   ei.scan_date,
                   ei.session_code, ei.stud_ref_no,
                   ei.upload_date,
                   ei.viewed_doc
                  )
           VALUES (UPPER (annot_in), UPPER (attachment_type_code_in),
                   batch_id_in, batch_type_code_in,
                   UPPER (document_name_in), UPPER (document_type_code_in),
                   UPPER (document_type_count_in), envelope_id_in,
                   object_id_in, raw_data_id_in, UPPER (req_original_in),
                   rescan_in, UPPER (rescan_req_in), rescan_request_id_in,
                   TO_DATE (scan_date_in, 'dd-MM-yyyy HH24:MI:SS'),
                   session_code_in, stud_ref_no_in,
                   TO_DATE (upload_date_in, 'dd-MM-yyyy'),
                   UPPER (viewed_doc_in)
                  );

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      row_count := SQL%ROWCOUNT;
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=  ERROR_TEXT ||
               'ERROR : plsql procedure : insertedm : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
         row_count := 0;
   END insertedmimages;

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
   )
   AS
      steps         VARCHAR2 (1);
      grass         VARCHAR2 (1);
      v_ceg_count   NUMBER (2);
   BEGIN
      steps := 'S';
      grass := 'G';

      IF UPPER (dbase_flag) = steps
      THEN
         UPDATE edm_images ei
            SET ei.session_code = NVL (session_year_in, ei.session_code),
                ei.document_type_code =
                   NVL (UPPER (new_document_type_code_in),
                        ei.document_type_code
                       )
          WHERE ei.stud_ref_no = stud_ref_no_in
            AND ei.object_id = object_id_in
            AND ei.document_type_code != 'XML'
            AND ei.document_type_code = old_document_type_code_in
            AND ei.document_name = document_name_in;

         row_count := SQL%ROWCOUNT;
         error_boolean := 'false';
         ERROR_TEXT := 'none';
         COMMIT;
      ELSIF UPPER (dbase_flag) = grass
      THEN
         SELECT COUNT (*)
           INTO v_ceg_count
           FROM config_edm@grass ceg
          WHERE ceg.document_type_code = UPPER (new_document_type_code_in);

         IF v_ceg_count > 0
         THEN
            UPDATE edm_images@grass ei
               SET ei.session_code = NVL (session_year_in, ei.session_code),
                   ei.document_type_code =
                      NVL (UPPER (new_document_type_code_in),
                           ei.document_type_code
                          )
             WHERE ei.stud_ref_no = stud_ref_no_in
               AND ei.object_id = object_id_in
               AND ei.document_type_code != 'XML'
               AND ei.document_type_code = old_document_type_code_in
               AND ei.document_name = document_name_in;

            row_count := SQL%ROWCOUNT;
            error_boolean := 'false';
            ERROR_TEXT := 'none';
            COMMIT;
         ELSE
            UPDATE edm_images@grass ei
               SET ei.session_code = NVL (session_year_in, ei.session_code)
             WHERE ei.stud_ref_no = stud_ref_no_in
               AND ei.object_id = object_id_in
               AND ei.document_type_code != 'XML';

            row_count := SQL%ROWCOUNT;
            error_boolean := 'true';
            ERROR_TEXT :=
                  'You are unable to update the document type code for this record'
               || 'as this type does not exist for GRASS EDM records';
            COMMIT;
         END IF;
      END IF;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : updateedm : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
         row_count := 0;
   END updateedmimages;

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
   )
   AS
      steps   VARCHAR2 (1);
      grass   VARCHAR2 (1);
   BEGIN
      steps := 'S';
      grass := 'G';

      IF UPPER (dbase_flag) = steps
      THEN
         SELECT surname
           INTO student_surname
           FROM stud
          WHERE stud_ref_no = stud_ref_no_in;

         SELECT post_code, addr_l1
           INTO student_postcode, student_addr_l1
           FROM stud_home_addr
          WHERE stud_ref_no = stud_ref_no_in;

         SELECT crse_name, inst_name
           INTO student_course_name, student_inst_name
           FROM stud_crse_year
          WHERE stud_crse_year_id = stud_crse_year_id_in
            AND stud_session_id = stud_session_id_in;
      END IF;

      IF UPPER (dbase_flag) = grass
      THEN
         SELECT surname
           INTO student_surname
           FROM stud@grass
          WHERE stud_ref_no = stud_ref_no_in;

         SELECT post_code, addr_l1
           INTO student_postcode, student_addr_l1
           FROM stud_home_addr@grass
          WHERE stud_ref_no = stud_ref_no_in;

         SELECT crse_name, inst_name
           INTO student_course_name, student_inst_name
           FROM stud_crse_year@grass
          WHERE stud_crse_year_id = stud_crse_year_id_in
            AND stud_session_id = stud_session_id_in;
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         error_boolean := 'false';
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getedmlearnerdetails : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getedmstudentdetails;

   PROCEDURE getapplicabledoctypecode (
      file_ext_in     IN       VARCHAR2,
      io_cursor       IN OUT   doctype_cursor,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      e_cursor   doctype_cursor;
   BEGIN
      IF file_ext_in IS NULL
      THEN
         OPEN e_cursor FOR
            SELECT document_type_code, document_type_name
              FROM config_edm ce;
      ELSE
         OPEN e_cursor FOR
            SELECT document_type_code, document_type_name
              FROM config_edm ce
             WHERE ce.file_ext = UPPER (file_ext_in);
      END IF;

      io_cursor := e_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : getapplicabledoctypecode : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END getapplicabledoctypecode;

   PROCEDURE edmrescan (
      object_id_in            IN       VARCHAR2,
      dbase_flag              IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      rescan_request_id_in    IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   )
   AS
      steps   VARCHAR2 (1);
      grass   VARCHAR2 (1);
   BEGIN
      steps := 'S';
      grass := 'G';

      IF UPPER (dbase_flag) = steps
      THEN
         UPDATE edm_images ei
            SET ei.rescan_req = 'Y',
                ei.rescan_request_id = rescan_request_id_in
          WHERE ei.object_id = object_id_in
            AND ei.document_type_code = document_type_code_in;
      END IF;

      IF UPPER (dbase_flag) = grass
      THEN
         UPDATE edm_images@grass ei
            SET ei.rescan_req = 'Y',
                ei.rescan_request_id = rescan_request_id_in
          WHERE ei.object_id = object_id_in
            AND ei.document_type_code = document_type_code_in;
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      row_count := SQL%ROWCOUNT;
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : edmrescan : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
         row_count := 0;
   END edmrescan;

   PROCEDURE edm_orig_req (
      object_id_in            IN       VARCHAR2,
      dbase_flag              IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   )
   AS
      steps   VARCHAR2 (1);
      grass   VARCHAR2 (1);
   BEGIN
      steps := 'S';
      grass := 'G';

      IF UPPER (dbase_flag) = steps
      THEN
         UPDATE edm_images ei
            SET ei.req_original = 'Y'
          WHERE ei.object_id = object_id_in
            AND ei.document_type_code = document_type_code_in;
      END IF;

      IF UPPER (dbase_flag) = grass
      THEN
         UPDATE edm_images@grass ei
            SET ei.req_original = 'Y'
          WHERE ei.object_id = object_id_in
            AND ei.document_type_code = document_type_code_in;
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      row_count := SQL%ROWCOUNT;
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : edm_orig_req : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
         row_count := 0;
   END edm_orig_req;

   PROCEDURE setviewed (
      object_id_in            IN       VARCHAR2,
      dbase_flag              IN       VARCHAR2,
      document_type_code_in   IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2,
      row_count               OUT      VARCHAR2
   )
   AS
      steps   VARCHAR2 (1);
      grass   VARCHAR2 (1);
   BEGIN
      steps := 'S';
      grass := 'G';

      IF UPPER (dbase_flag) = steps
      THEN
         UPDATE edm_images ei
            SET ei.viewed_doc = 'Y'
          WHERE ei.object_id = object_id_in
            AND ei.document_type_code = document_type_code_in;
      END IF;

      IF UPPER (dbase_flag) = grass
      THEN
         UPDATE edm_images@grass ei
            SET ei.viewed_doc = 'Y'
          WHERE ei.object_id = object_id_in
            AND ei.document_type_code = document_type_code_in;
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      row_count := SQL%ROWCOUNT;
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : edmviewed : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
         row_count := 0;
   END setviewed;
END pk_steps_ui_edm;
/