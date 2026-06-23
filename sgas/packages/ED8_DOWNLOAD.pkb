CREATE OR REPLACE PACKAGE BODY SGAS.ed8_download
IS
   PROCEDURE create_csv_file (
      param_file_name      IN            VARCHAR2,
      param_session_code   IN            stud_session.session_code%TYPE,
      param_mode_type      IN            VARCHAR2,
      param_scheme_type    IN            VARCHAR2,
      success_fail            OUT        VARCHAR2,
      start_finish            OUT        VARCHAR2,
      error_msg               OUT        VARCHAR2,
      number_of_records       OUT        VARCHAR2,
      error_boolean           OUT NOCOPY VARCHAR2,
      ERROR_TEXT              OUT NOCOPY VARCHAR2)
   IS
      e_stop_processing   EXCEPTION;                       -- severe exception
      v_handle            UTL_FILE.file_type;            -- report file handle
      v_path_name         VARCHAR2 (100);        -- holds file path for output
      v_sql_message       VARCHAR2 (2000);          -- used in exception block
      v_sql_code          NUMBER;                   -- used in exception block
      v_max_line_chars    NUMBER;         -- Max number of characters per line
      v_session_code      stud_session.session_code%TYPE;    -- report session
      v_records           NUMBER;               -- number of records processed
      v_start_date        DATE;                           -- report start date
      v_finish_date       DATE;                             -- report end date
      v_stud_ref_no       stud.stud_ref_no%TYPE;      -- the student processed

      /*
      *   This cursor determines all students to be included in extract
      *   It return the stud_crse_year_id, stud_session_id and stud_ref_no to make available to all queries
      */
      CURSOR c_extract_students
      IS
           SELECT stud_ref_no,stud_session_id,stud_crse_year_id,crse_year_id,DECODE (scheme_type, NULL, 'U', scheme_type) scheme_type
           FROM stud_crse_year
           WHERE session_code = param_session_code
           AND
           (   
             (param_scheme_type = 'B' AND scheme_type = 'B')
           OR (param_scheme_type IS NULL AND DECODE (scheme_type, NULL, 'null', scheme_type) IN ('U','P','S','null'))
           )
           AND latest_crse_ind = 'Y'
           ORDER BY stud_ref_no DESC;
   BEGIN
      v_max_line_chars := 4096;
      v_start_date := SYSDATE;
      success_fail := NULL;
      v_records := 0;
      v_session_code := param_session_code + 1;
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      -- get path for file destination
      BEGIN
         SELECT cval
           INTO v_path_name
           FROM config_data
          WHERE item_name = 'ED8_DEST';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            success_fail := 'Fatal Error Detected';
            error_msg := 'ED8_DEST config_data item could not be found';
            RAISE e_stop_processing;
      END;

      -- Open file for writing
      BEGIN
         v_handle :=
            UTL_FILE.fopen (v_path_name,
                            param_file_name,
                            'w',
                            v_max_line_chars);
      EXCEPTION
         WHEN OTHERS
         THEN
            success_fail := 'Fatal Error Detected';
            error_msg :=
               'Could not open output file.  Check that UTL_FILE parameter in INIT.ORA matches CONFIG_DATA value for ED8_DEST';
            RAISE e_stop_processing;
      END;

      -- Loop through relevant students
      FOR r_processing_student IN c_extract_students
      LOOP
         v_stud_ref_no := r_processing_student.stud_ref_no;
         create_csv_line (r_processing_student.stud_ref_no,
                          r_processing_student.stud_session_id,
                          r_processing_student.stud_crse_year_id,
                          param_session_code,
                          param_mode_type,
                          param_scheme_type,
                          v_handle,
                          error_boolean,
                          ERROR_TEXT);

         IF param_mode_type = 'P' AND error_boolean = 'true'
         THEN
            success_fail := 'Application Error @ Student : ' || v_stud_ref_no;
            error_msg := ERROR_TEXT;
            RAISE e_stop_processing;
         END IF;

         UTL_FILE.new_line (v_handle);          -- move to next line of report
         v_records := v_records + 1;                 -- increment record count
      END LOOP;

      UTL_FILE.fclose (v_handle);                         -- close report file
      number_of_records := 'Number of records processed ' || v_records;
      -- report record count
      success_fail := 'Completed Successfully';   -- report success or failure
      v_finish_date := SYSDATE;                          -- report finish date
      start_finish :=
            'Started '
         || TO_CHAR (v_start_date, 'dd-MON-yy hh24:mi:ss')
         || ', Finished '
         || TO_CHAR (v_finish_date, 'dd-MON-yy hh24:mi:ss');
      update_run_log (param_file_name,
                      param_session_code,
                      param_mode_type,
                      param_scheme_type,
                      success_fail,
                      v_start_date,
                      v_finish_date,
                      error_msg,
                      v_records);
      COMMIT;
   EXCEPTION
      WHEN e_stop_processing
      THEN
         number_of_records := 0;
         v_finish_date := SYSDATE;
         update_run_log (param_file_name,
                         param_session_code,
                         param_mode_type,
                         param_scheme_type,
                         success_fail,
                         v_start_date,
                         v_finish_date,
                         error_msg,
                         v_records);
      WHEN NO_DATA_FOUND
      THEN
         v_sql_code := SQLCODE;
         v_sql_message := SQLERRM;
         success_fail := 'No Data Found:' || v_stud_ref_no;
         error_msg :=
               'Stud Ref No: '
            || v_stud_ref_no
            || ' - Error Msg : ('
            || v_sql_code
            || ') '
            || v_sql_message;
         number_of_records := 0;
         v_finish_date := SYSDATE;                       -- report finish date
         update_run_log (param_file_name,
                         param_session_code,
                         param_mode_type,
                         param_scheme_type,
                         success_fail,
                         v_start_date,
                         v_finish_date,
                         error_msg,
                         v_records);
      WHEN OTHERS
      THEN
         v_sql_code := SQLCODE;
         v_sql_message := SQLERRM;
         success_fail := 'Failed on Student:' || v_stud_ref_no;
         error_msg :=
               'Stud Ref No: '
            || v_stud_ref_no
            || ' - Error Msg : ('
            || v_sql_code
            || ') '
            || v_sql_message;
         number_of_records := 0;
         v_finish_date := SYSDATE;                       -- report finish date
         update_run_log (param_file_name,
                         param_session_code,
                         param_mode_type,
                         param_scheme_type,
                         success_fail,
                         v_start_date,
                         v_finish_date,
                         error_msg,
                         v_records);
   END create_csv_file;

   PROCEDURE create_csv_line (
      p_stud_ref_no         IN            stud.stud_ref_no%TYPE,
      p_stud_session_id     IN            stud_session.stud_session_id%TYPE,
      p_stud_crse_year_id   IN            stud_crse_year.stud_crse_year_id%TYPE,
      param_session_code    IN            stud_session.session_code%TYPE,
      param_mode_type       IN            VARCHAR2,
      param_scheme_type     IN            VARCHAR2,
      p_handle              IN OUT        UTL_FILE.file_type,
      error_boolean            OUT NOCOPY VARCHAR2,
      ERROR_TEXT               OUT NOCOPY VARCHAR2)
   IS
      v_report_line   VARCHAR (4096);
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      get_report_line (p_stud_ref_no,
                       p_stud_session_id,
                       p_stud_crse_year_id,
                       param_session_code,
                       param_mode_type,
                       param_scheme_type,
                       v_report_line,
                       error_boolean,
                       ERROR_TEXT);
      UTL_FILE.put (
         p_handle,
            p_stud_ref_no
         || '~'
         || p_stud_session_id
         || '~'
         || p_stud_crse_year_id
         || '~'
         || v_report_line);
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : create_csv_line : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END create_csv_line;

   PROCEDURE get_report_line (
      p_stud_ref_no         IN            stud.stud_ref_no%TYPE,
      p_stud_session_id     IN            stud_session.stud_session_id%TYPE,
      p_stud_crse_year_id   IN            stud_crse_year.stud_crse_year_id%TYPE,
      param_session_code    IN            stud_session.session_code%TYPE,
      param_mode_type       IN            VARCHAR2,
      param_scheme_type     IN            VARCHAR2,
      report_line              OUT        VARCHAR2,
      error_boolean            OUT NOCOPY VARCHAR2,
      ERROR_TEXT               OUT NOCOPY VARCHAR2)
   IS
      v_report_line   VARCHAR2 (4096);
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      ed8_content.build_line (p_stud_ref_no,
                              p_stud_session_id,
                              p_stud_crse_year_id,
                              param_session_code,
                              param_mode_type,
                              param_scheme_type,
                              v_report_line,
                              error_boolean,
                              ERROR_TEXT);
      report_line := v_report_line;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : get_report_line : @ '
            || SYSDATE
            || ': '
            || SQLCODE
            || ' '
            || SQLERRM;
   END get_report_line;

   PROCEDURE update_run_log (p_filename        IN VARCHAR2,
                             p_session_code    IN NUMBER,
                             p_mode_type       IN VARCHAR2,
                             p_scheme_type     IN VARCHAR2,
                             p_success         IN VARCHAR2,
                             p_start           IN DATE,
                             p_finish          IN DATE,
                             p_error_msg       IN VARCHAR2,
                             p_no_of_records   IN NUMBER)
   IS
      v_shape   NUMBER;
   BEGIN
      ED8_CONTENT.GET_SHAPE (v_shape);

      INSERT INTO sgas.ed8_run_log (filename,
                                    session_code,
                                    mode_type,
                                    scheme_type,
                                    success,
                                    start_time,
                                    finish_time,
                                    error_msg,
                                    no_of_records,
                                    shape)
           VALUES (p_filename,
                   p_session_code,
                   p_mode_type,
                   p_scheme_type,
                   p_success,
                   p_start,
                   p_finish,
                   p_error_msg,
                   p_no_of_records,
                   v_shape);
   END update_run_log;
END ed8_download;
/