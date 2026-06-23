CREATE OR REPLACE PACKAGE BODY SGAS.Pop_M139
IS
--
-- SCCS IDENTIFICATION STRING
-- ==========================
-- @(#) pop_m139_b.sql 10/03/00 10:13:45 1.10@(#)
--
-- DESCRIPTION
-- ===========
--
-- Populates the table rep_m139 for the benefactor income letter report
--
   FUNCTION Pop_M139 (
      p_session_code   IN   STUD_SESSION.session_code%TYPE
    , p_logdir         IN   VARCHAR2
    , p_filename_1     IN   VARCHAR2
    , p_sid            IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
--
      stud_declaration_rec          stud_declaration_rec_type;
      stud_declaration_output_rec   stud_output_rec_type;
      v_rec_count                   NUMBER ( 10 );
      v_error_mess                  VARCHAR2 ( 1024 );
      v_file_seq_no                 NUMBER ( 10 );
      v_tmp_msg                     VARCHAR2 ( 256 )          := NULL;
      v_process                     BOOLEAN                   := TRUE;
      v_tempdir                     VARCHAR2 ( 256 )          := NULL;
      --
      out_file_invalid_path         EXCEPTION;
      out_file_invalid_mode         EXCEPTION;
      out_file_invalid_filehandle   EXCEPTION;
      out_file_write_error          EXCEPTION;
      --
      bad_file_invalid_path         EXCEPTION;
      bad_file_invalid_mode         EXCEPTION;
      bad_file_invalid_filehandle   EXCEPTION;
      bad_file_write_error          EXCEPTION;

-----------------------------------
-- retrieve details benefactor     --
-- ( Result may be many records )--
-----------------------------------
      CURSOR cur_ben
      IS
         SELECT DISTINCT s.stud_ref_no, s.forenames, s.surname
                       , scy.session_code session_code
                       , scy.session_code + 1 session_code1, ss.ben1_id
                       , ss.ben2_id
                    FROM STUD s
                       , STUD_CRSE_YEAR scy
                       , STUD_SESSION ss
                       , BENEFACTOR b
                       , BENEFACTOR_INCOME bi
                     WHERE ss.session_code = p_session_code
                     AND s.stud_ref_no = ss.stud_ref_no
                     AND ss.stud_session_id = scy.stud_session_id
                     AND scy.provisional_case = 'Y'
                     AND scy.latest_crse_ind = 'Y'
--RFC71 - No Part Time Students
 --                    AND Slc_Util.part_time_course ( scy.crse_code ) = 'N'
                     AND (    ss.ben1_id = b.ben_id
                           OR ss.ben2_id = b.ben_id )
                     AND b.ben_id = bi.ben_id
                     AND ss.session_code = bi.session_code
-- SIR S965 fix - check suppress reminder flag
                     AND bi.suppress_reminder = 'N'
                     AND (    bi.p60_req = 'Y'
                           OR bi.sched_a_req = 'Y'
                           OR bi.sched_d_req = 'Y'
                          -- OR bi.sched_e_req = 'Y'
                           OR bi.pension_cb = 'Y'
                           OR bi.benefit_cb = 'Y'
                         )
                     ;
   BEGIN
      --
      g_error        := FALSE;
      v_rec_count    := 0;

--
--
--
      SELECT cval
        INTO v_tempdir
        FROM CONFIG_DATA
       WHERE item_name = 'PROV_INCOME_DEST';

--  Function to open output file (Filename 1)
      IF NOT file_open_out_file ( v_tempdir, p_sid, p_filename_1
                                , v_error_mess ) THEN
         RETURN v_error_mess;
      END IF;

-- Function to open bad record file
      IF NOT file_open_bad_file ( v_tempdir, p_sid, p_filename_1
                                , v_error_mess ) THEN
         RETURN v_error_mess;
      END IF;

--
--  null recs
      initialise_records ( stud_declaration_rec, stud_declaration_output_rec );
      v_process      := TRUE;

--
      OPEN cur_ben;

      LOOP
         FETCH cur_ben
          INTO stud_declaration_rec.stud_ref_no
             , stud_declaration_rec.stud_forenames
             , stud_declaration_rec.stud_surname
             , stud_declaration_rec.session_code
             , stud_declaration_rec.session_code1
             , stud_declaration_rec.i_ben1_id
             , stud_declaration_rec.i_ben2_id
             ;

         EXIT WHEN cur_ben%NOTFOUND;
v_tmp_msg    := NULL;
         v_tmp_msg    :=
               'Doing first setup';
         UTL_FILE.PUT_LINE ( g_bad_handle, v_tmp_msg );
         BEGIN
-- select ben1 details
v_tmp_msg    := NULL;
         v_tmp_msg    :=
               'Doing first benefactor';
         UTL_FILE.PUT_LINE ( g_bad_handle, v_tmp_msg );
            SELECT b.title
                 , b.forenames
                 , b.surname
                 , b.house_no_name
                 , b.addr_l1
                 , b.addr_l2
                 , b.addr_l3
                 , b.addr_l4
                 , b.post_code
                 , b.mailsort
                 , bi.p60_req ben1_p60
                 , bi.sched_a_req ben1_scheda
                 , bi.sched_d_req ben1_schedd
           --      , bi.sched_e_req ben1_schede
                 , bi.pension_cb ben1_pension
                 , bi.benefit_cb ben1_benefit
              INTO stud_declaration_rec.ben_title
                 , stud_declaration_rec.ben_forenames
                 , stud_declaration_rec.ben_surname
                 , stud_declaration_rec.ben_house_no_name
                 , stud_declaration_rec.ben_addr_l1
                 , stud_declaration_rec.ben_addr_l2
                 , stud_declaration_rec.ben_addr_l3
                 , stud_declaration_rec.ben_addr_l4
                 , stud_declaration_rec.ben_post_code
                 , stud_declaration_rec.ben_mailsort
                 , stud_declaration_rec.i_ben1_p60
                 , stud_declaration_rec.i_ben1_scheda
                 , stud_declaration_rec.i_ben1_schedd
             --    , stud_declaration_rec.i_ben1_schede
                 , stud_declaration_rec.i_ben1_pension
                 , stud_declaration_rec.i_ben1_benefit
              FROM BENEFACTOR b, BENEFACTOR_INCOME bi
             WHERE b.ben_id = stud_declaration_rec.i_ben1_id
               AND b.ben_id = bi.ben_id
               AND bi.session_code = stud_declaration_rec.session_code;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               SELECT title
                    , forenames
                    , surname
                    , house_no_name
                    , addr_l1
                    , addr_l2
                    , addr_l3
                    , addr_l4
                    , post_code
                    , mailsort
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                    , NULL
                 INTO stud_declaration_rec.ben_title
                    , stud_declaration_rec.ben_forenames
                    , stud_declaration_rec.ben_surname
                    , stud_declaration_rec.ben_house_no_name
                    , stud_declaration_rec.ben_addr_l1
                    , stud_declaration_rec.ben_addr_l2
                    , stud_declaration_rec.ben_addr_l3
                    , stud_declaration_rec.ben_addr_l4
                    , stud_declaration_rec.ben_post_code
                    , stud_declaration_rec.ben_mailsort
                    , stud_declaration_rec.i_ben1_p60
                    , stud_declaration_rec.i_ben1_scheda
                    , stud_declaration_rec.i_ben1_schedd
               --     , stud_declaration_rec.i_ben1_schede
                    , stud_declaration_rec.i_ben1_pension
                    , stud_declaration_rec.i_ben1_benefit
                 FROM BENEFACTOR
                WHERE ben_id = stud_declaration_rec.i_ben1_id;
         END;

         BEGIN
-- select ben2 details
v_tmp_msg    := NULL;
         v_tmp_msg    :=
               'Doing second benefactor';
         UTL_FILE.PUT_LINE ( g_bad_handle, v_tmp_msg );
            SELECT b.title
                 , b.forenames
                 , b.surname
                 , bi.p60_req
                 , bi.sched_a_req
                 , bi.sched_d_req
              --   , bi.sched_e_req
                 , bi.pension_cb
                 , bi.benefit_cb
              INTO stud_declaration_rec.ben2_title
                 , stud_declaration_rec.ben2_forenames
                 , stud_declaration_rec.ben2_surname
                 , stud_declaration_rec.i_ben2_p60
                 , stud_declaration_rec.i_ben2_scheda
                 , stud_declaration_rec.i_ben2_schedd
              --   , stud_declaration_rec.i_ben2_schede
                 , stud_declaration_rec.i_ben2_pension
                 , stud_declaration_rec.i_ben2_benefit
              FROM BENEFACTOR b, BENEFACTOR_INCOME bi
             WHERE b.ben_id = stud_declaration_rec.i_ben2_id
               AND b.ben_id = bi.ben_id
               AND bi.session_code = stud_declaration_rec.session_code;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               /* Null the variables */
               stud_declaration_rec.ben2_title        := NULL;
               stud_declaration_rec.ben2_forenames    := NULL;
               stud_declaration_rec.ben2_surname      := NULL;
               stud_declaration_rec.i_ben2_p60        := NULL;
               stud_declaration_rec.i_ben2_scheda     := NULL;
               stud_declaration_rec.i_ben2_schedd     := NULL;
            --   stud_declaration_rec.i_ben2_schede     := NULL;
               stud_declaration_rec.i_ben2_pension    := NULL;
               stud_declaration_rec.i_ben2_benefit    := NULL;
         END;
v_tmp_msg    := NULL;
         v_tmp_msg    :=
               'Finished populating data';
         UTL_FILE.PUT_LINE ( g_bad_handle, v_tmp_msg );
         
--
         IF v_process = TRUE THEN
		 v_tmp_msg    := NULL;
         v_tmp_msg    :=
               'Format record';
         UTL_FILE.PUT_LINE ( g_bad_handle, v_tmp_msg );
            IF NOT format_output_record ( stud_declaration_rec
                                        , stud_declaration_output_rec
                                        , p_session_code ) THEN
               v_process    := FALSE;
            END IF;
         END IF;

--
-- Write record to file
--
         IF v_process = TRUE THEN
		 v_tmp_msg    := NULL;
         v_tmp_msg    :=
               'Write record';
         UTL_FILE.PUT_LINE ( g_bad_handle, v_tmp_msg );
            IF NOT file_write ( g_file_handle, stud_declaration_output_rec ) THEN
               v_process    := FALSE;
            END IF;
         END IF;

--
         IF v_process = TRUE THEN
		 v_tmp_msg    := NULL;
         v_tmp_msg    :=
               'Increment Count';
         UTL_FILE.PUT_LINE ( g_bad_handle, v_tmp_msg );
            v_rec_count    := v_rec_count + 1;
            COMMIT;
         ELSE
            ROLLBACK;
         END IF;

--  null recs
v_tmp_msg    := NULL;
         v_tmp_msg    :=
               'Null records';
         UTL_FILE.PUT_LINE ( g_bad_handle, v_tmp_msg );
         initialise_records ( stud_declaration_rec
                            , stud_declaration_output_rec );
         v_process    := TRUE;
--
      END LOOP;

--
      file_close ( g_file_handle );
--
      file_close ( g_bad_handle );

      IF v_rec_count > 0 THEN
         v_error_mess    :=
                p_filename_1 || ' - Prov Income file produced successfully, ';
         v_error_mess    :=
               v_error_mess
            || NVL ( v_rec_count, 0 )
            || ' Prov Income students processed.';
      ELSE
         v_error_mess    :=
               p_filename_1
            || ' - No valid prov income students to be processed. ';
      END IF;

--
      RETURN v_error_mess;
   EXCEPTION
      WHEN OTHERS THEN
         v_error_mess    :=
               'An pop_m139 error has occurred processing student '
            || stud_declaration_rec.stud_ref_no
            || ' in session '
            || p_session_code
			|| ' record number '
			|| v_rec_count
            || '.
		    THE Error IS AS follows '
            || ' '
            || p_sid
            || ' '
            || SQLERRM ( SQLCODE )
            || ' '
            || SQLERRM
            || ' '
            || SQLCODE;
         ROLLBACK;
         RETURN v_error_mess;
   END;   -- Pop_m139_declaration

--
--
--
--
   FUNCTION file_write (
      p_file_handle                            UTL_FILE.FILE_TYPE
    , p_stud_declaration_output_rec   IN OUT   stud_output_rec_type
   )
      RETURN BOOLEAN
   IS
-- Write to file
--
      s_date      DATE;
      s_tmp_msg   VARCHAR2 ( 2200 );
      v_tmp_msg   VARCHAR2 ( 512 )  := NULL;
--
   BEGIN
--
--   IF utl_file.is_open (p_file_handle) THEN -- JM remove and allow validation to work
--
      UTL_FILE.FFLUSH ( p_file_handle );
--
--  Assemble record
      s_tmp_msg    := NULL;
      s_tmp_msg    :=
	  	p_stud_declaration_output_rec.stud_ref_no
         || '~'
         || p_stud_declaration_output_rec.stud_forenames
         || '~'
         || p_stud_declaration_output_rec.stud_surname
         || '~'
         || p_stud_declaration_output_rec.ben_house_no_name
         || '~'
         || p_stud_declaration_output_rec.ben_addr_l1
         || '~'
         || p_stud_declaration_output_rec.ben_addr_l2
         || '~'
         || p_stud_declaration_output_rec.ben_addr_l3
         || '~'
         || p_stud_declaration_output_rec.ben_addr_l4
         || '~'
         || p_stud_declaration_output_rec.ben_post_code
         || '~'
         || p_stud_declaration_output_rec.ben_mailsort
         || '~'
         || p_stud_declaration_output_rec.ben_title
         || '~'
         || p_stud_declaration_output_rec.ben_forenames
         || '~'
         || p_stud_declaration_output_rec.ben_surname
         || '~'
         || p_stud_declaration_output_rec.ben2_title
         || '~'
         || p_stud_declaration_output_rec.ben2_forenames
         || '~'
         || p_stud_declaration_output_rec.ben2_surname
         || '~'
         || p_stud_declaration_output_rec.session_code
         || '~'
         || p_stud_declaration_output_rec.session_code1
         || '~'
         || p_stud_declaration_output_rec.i_ben1_p60
         || '~'
         || p_stud_declaration_output_rec.i_ben1_sched
         || '~'
         || p_stud_declaration_output_rec.i_ben1_pension
         || '~'
         || p_stud_declaration_output_rec.i_ben1_benefit
         || '~'
         || p_stud_declaration_output_rec.i_ben2_p60
         || '~'
         || p_stud_declaration_output_rec.i_ben2_sched
         || '~'
         || p_stud_declaration_output_rec.i_ben2_pension
         || '~'
         || p_stud_declaration_output_rec.i_ben2_benefit
         ;
--
      UTL_FILE.PUT_LINE ( p_file_handle, s_tmp_msg );
      UTL_FILE.FFLUSH ( p_file_handle );
      RETURN TRUE;
--
   EXCEPTION
      WHEN UTL_FILE.INVALID_OPERATION THEN
         v_tmp_msg    := ' Invalid file operation';
         UTL_FILE.PUT_LINE ( g_bad_handle, v_tmp_msg );
         UTL_FILE.FFLUSH ( g_bad_handle );
         RETURN FALSE;
--
      WHEN UTL_FILE.INVALID_PATH THEN
         v_tmp_msg    :=
                      ' Invalid file path - failed to write CSV output file.';
         UTL_FILE.PUT_LINE ( g_bad_handle, v_tmp_msg );
         UTL_FILE.FFLUSH ( g_bad_handle );
         RETURN FALSE;
--
      WHEN UTL_FILE.INVALID_MODE THEN
         v_tmp_msg    :=
                     'Invalid file mode, unable to write to CSV output file.';
         UTL_FILE.PUT_LINE ( g_bad_handle, v_tmp_msg );
         UTL_FILE.FFLUSH ( g_bad_handle );
         RETURN FALSE;
--
      WHEN UTL_FILE.INVALID_FILEHANDLE THEN
         v_tmp_msg    :=
                  ' Invalid file handle, unable to write to CSV output file.';
         UTL_FILE.PUT_LINE ( g_bad_handle, v_tmp_msg );
         UTL_FILE.FFLUSH ( g_bad_handle );
         RETURN FALSE;
--
      WHEN UTL_FILE.WRITE_ERROR THEN
         v_tmp_msg    :=
                 ' Write error occurred, unable to write to CSV output file.';
         UTL_FILE.PUT_LINE ( g_bad_handle, v_tmp_msg );
         UTL_FILE.FFLUSH ( g_bad_handle );
         RETURN FALSE;
      WHEN OTHERS THEN
         v_tmp_msg    :=
               'Unhandled exception occurred when attempting to open CSV output file. '
            || TO_CHAR ( SQLCODE );
         UTL_FILE.PUT_LINE ( g_bad_handle, v_tmp_msg );
         UTL_FILE.FFLUSH ( g_bad_handle );
         RETURN FALSE;
--
   END file_write;

--
   PROCEDURE file_close (
      p_file_handle   IN OUT   UTL_FILE.FILE_TYPE
   )
   IS
--
--
   BEGIN
--
      IF ( UTL_FILE.IS_OPEN ( p_file_handle )) THEN
         UTL_FILE.FCLOSE ( p_file_handle );
      END IF;

--
      RETURN;
--
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.NEW_LINE;
         DBMS_OUTPUT.PUT_LINE ( 'Failed to close Output file or log file.' );
         DBMS_OUTPUT.NEW_LINE;
         RETURN;
   END file_close;

--
--
--
   FUNCTION file_open_out_file (
      p_tempdir    IN       VARCHAR2
    , p_sid        IN       VARCHAR2
    , p_filename   IN       VARCHAR2
    , p_error      IN OUT   VARCHAR2
   )
      RETURN BOOLEAN
   IS
--
g_tmp_msg      VARCHAR2 ( 512 );
   BEGIN
--
   	  g_file_dirname    := 'PROV_DIR';
      g_file_path       := 'PROV_DIR' || '/' || p_filename;
      g_file_handle     := UTL_FILE.FOPEN ( g_file_dirname, p_filename, 'w' );
--
-- Write header row
UTL_FILE.FFLUSH ( g_file_handle );
--
--  Assemble record
      g_tmp_msg    := NULL;
      g_tmp_msg    :=
	  		'stud_ref_no'
         || '~'
         || 'stud_forenames'
         || '~'
         || 'stud_surname'
         || '~'
         || 'ben_house_no_name'
         || '~'
         || 'ben_addr_l1'
         || '~'
         || 'ben_addr_l2'
         || '~'
         || 'ben_addr_l3'
         || '~'
         || 'ben_addr_l4'
         || '~'
         || 'ben_post_code'
         || '~'
         || 'ben_mailsort'
         || '~'
         || 'ben_title'
         || '~'
         || 'ben_forenames'
         || '~'
         || 'ben_surname'
         || '~'
         || 'ben2_title'
         || '~'
         || 'ben2_forenames'
         || '~'
         || 'ben2_surname'
         || '~'
         || 'session_code'
         || '~'
         || 'session_code1'
         || '~'
         || 'i_ben1_p60'
         || '~'
         || 'i_ben1_sched'
         || '~'
         || 'i_ben1_pension'
         || '~'
         || 'i_ben1_benefit'
         || '~'
         || 'i_ben2_p60'
         || '~'
         || 'i_ben2_sched'
         || '~'
         || 'i_ben2_pension'
         || '~'
         || 'i_ben2_benefit'
         ;
--
      UTL_FILE.PUT_LINE ( g_file_handle, g_tmp_msg );
      UTL_FILE.FFLUSH ( g_file_handle ); 
      RETURN TRUE;
--
   EXCEPTION
      WHEN UTL_FILE.INVALID_OPERATION THEN
         file_close ( g_file_handle );
         p_error    :=
              ' Invalid file operation on the following file ' || g_file_path;
         RETURN FALSE;
--
      WHEN UTL_FILE.INVALID_PATH THEN
         file_close ( g_file_handle );
         p_error    :=
            ' Invalid file path - failed to open output files '
            || g_file_path;
         RETURN FALSE;
--
      WHEN UTL_FILE.INVALID_MODE THEN
         file_close ( g_file_handle );
         p_error    :=
               'Invalid file mode. File '
            || g_file_path
            || ' could not be opened ';
         RETURN FALSE;
--
      WHEN UTL_FILE.INVALID_FILEHANDLE THEN
         file_close ( g_file_handle );
         p_error    :=
               ' Invalid filehandle. File '
            || g_file_path
            || ' could not be opened';
         RETURN FALSE;
--
      WHEN UTL_FILE.WRITE_ERROR THEN
         file_close ( g_file_handle );
         p_error    := ' Write error occurred in file ' || g_file_path;
         RETURN FALSE;
      WHEN OTHERS THEN
         file_close ( g_file_handle );
         p_error    :=
               'Unhandled exception occurred when attempting to open file '
            || g_file_path
            || '. '
            || TO_CHAR ( SQLCODE );
         RETURN FALSE;
--
--		
   END;   -- Open Output file

--
   FUNCTION file_open_bad_file (
      p_tempdir    IN       VARCHAR2
    , p_sid        IN       VARCHAR2
    , p_filename   IN       VARCHAR2
    , p_error      IN OUT   VARCHAR2
   )
      RETURN BOOLEAN
   IS
--
   BEGIN
--
      g_bad_filename    := 'prov_income.bad';
      g_bad_path        := p_tempdir || '/' || p_sid || '/' || g_bad_filename;
      g_bad_handle      :=
                       UTL_FILE.FOPEN ( g_file_dirname, g_bad_filename, 'w' );
--
      RETURN TRUE;
   EXCEPTION
      WHEN UTL_FILE.INVALID_OPERATION THEN
         file_close ( g_bad_handle );
         ROLLBACK;
         p_error    :=
               ' Invalid file operation on the following file ' || g_bad_path;
         RETURN FALSE;
--
      WHEN UTL_FILE.INVALID_PATH THEN
         file_close ( g_bad_handle );
         p_error    :=
            ' Invalid file path - failed to open output files ' || g_bad_path;
         RETURN FALSE;
--
      WHEN UTL_FILE.INVALID_MODE THEN
         file_close ( g_bad_handle );
         p_error    :=
            'Invalid file mode. File ' || g_bad_path
            || ' could not be opened ';
         RETURN FALSE;
--
      WHEN UTL_FILE.INVALID_FILEHANDLE THEN
         file_close ( g_bad_handle );
         p_error    :=
               ' Invalid filehandle. File '
            || g_bad_path
            || ' could not be opened';
         RETURN FALSE;
--
      WHEN UTL_FILE.WRITE_ERROR THEN
         file_close ( g_bad_handle );
         p_error    := ' Write error occurred in file ' || g_bad_path;
         RETURN FALSE;
--
      WHEN OTHERS THEN
         file_close ( g_bad_handle );
         p_error    :=
               'Unhandled exception occurred when attempting to open file '
            || g_bad_path
            || '. '
            || TO_CHAR ( SQLCODE );
         RETURN FALSE;
   END;   -- Open Bad file

   FUNCTION format_output_record (
      p_stud_declaration_rec          IN OUT   stud_declaration_rec_type
    , p_stud_declaration_output_rec   IN OUT   stud_output_rec_type
    , p_session_code                  IN       NUMBER
   )
      RETURN BOOLEAN
   IS
--
--v_stud_location_indicator
      v_error_mess   VARCHAR2 ( 256 );
      v_tmp_msg      VARCHAR2 ( 512 );
--
   BEGIN
--
      p_stud_declaration_output_rec.stud_ref_no          :=
           NVL (TO_CHAR ( p_stud_declaration_rec.stud_ref_no ), g_pad_char );
      p_stud_declaration_output_rec.stud_forenames       :=
         NVL (INITCAP( TO_CHAR ( p_stud_declaration_rec.stud_forenames )), g_pad_char );
      p_stud_declaration_output_rec.stud_surname         :=
          NVL (INITCAP( TO_CHAR ( p_stud_declaration_rec.stud_surname )), g_pad_char );
      p_stud_declaration_output_rec.ben_house_no_name    :=
         NVL (INITCAP( TO_CHAR ( p_stud_declaration_rec.ben_house_no_name ))
             , g_pad_char );
      p_stud_declaration_output_rec.ben_addr_l1          :=
           NVL (INITCAP( TO_CHAR ( p_stud_declaration_rec.ben_addr_l1 )), g_pad_char );
      p_stud_declaration_output_rec.ben_addr_l2          :=
           NVL (INITCAP( TO_CHAR ( p_stud_declaration_rec.ben_addr_l2 )), g_pad_char );
      p_stud_declaration_output_rec.ben_addr_l3          :=
           NVL (INITCAP( TO_CHAR ( p_stud_declaration_rec.ben_addr_l3 )), g_pad_char );
      p_stud_declaration_output_rec.ben_addr_l4          :=
           NVL (INITCAP( TO_CHAR ( p_stud_declaration_rec.ben_addr_l4 )), g_pad_char );
      p_stud_declaration_output_rec.ben_post_code        :=
         NVL ( TO_CHAR ( p_stud_declaration_rec.ben_post_code ), g_pad_char );
      p_stud_declaration_output_rec.ben_mailsort         :=
          NVL ( TO_CHAR ( p_stud_declaration_rec.ben_mailsort ), g_pad_char );
      p_stud_declaration_output_rec.ben_title            :=
             NVL (INITCAP( TO_CHAR ( p_stud_declaration_rec.ben_title )), g_pad_char );
      p_stud_declaration_output_rec.ben_forenames        :=
         NVL (INITCAP( TO_CHAR ( p_stud_declaration_rec.ben_forenames )), g_pad_char );
      p_stud_declaration_output_rec.ben_surname          :=
           NVL (INITCAP( TO_CHAR ( p_stud_declaration_rec.ben_surname )), g_pad_char );
      p_stud_declaration_output_rec.ben2_title           :=
            NVL (INITCAP( TO_CHAR ( p_stud_declaration_rec.ben2_title )), g_pad_char );
      p_stud_declaration_output_rec.ben2_forenames       :=
         NVL (INITCAP( TO_CHAR ( p_stud_declaration_rec.ben2_forenames )), g_pad_char );
      p_stud_declaration_output_rec.ben2_surname         :=
          NVL (INITCAP( TO_CHAR ( p_stud_declaration_rec.ben2_surname )), g_pad_char );
      p_stud_declaration_output_rec.session_code         :=
          NVL ( TO_CHAR ( p_stud_declaration_rec.session_code ), g_pad_char );
      p_stud_declaration_output_rec.session_code1        :=
         NVL ( TO_CHAR ( p_stud_declaration_rec.session_code1 ), g_pad_char );
      p_stud_declaration_output_rec.i_ben1_p60           :=
            NVL ( TO_CHAR ( p_stud_declaration_rec.i_ben1_p60 ), g_flag_char );
	  IF (p_stud_declaration_rec.i_ben1_scheda = 'Y'
	      OR p_stud_declaration_rec.i_ben1_schedd = 'Y')
		--  OR p_stud_declaration_rec.i_ben1_schede = 'Y')
	  THEN p_stud_declaration_output_rec.i_ben1_sched := 'Y';
	  ELSE p_stud_declaration_output_rec.i_ben1_sched := 'N';
	  END IF;
--         NVL ( TO_CHAR ( p_stud_declaration_rec.i_ben1_scheda ), g_flag_char );
--      p_stud_declaration_output_rec.i_ben1_schedd        :=
--         NVL ( TO_CHAR ( p_stud_declaration_rec.i_ben1_schedd ), g_flag_char );
--     p_stud_declaration_output_rec.i_ben1_schede        :=
--         NVL ( TO_CHAR ( p_stud_declaration_rec.i_ben1_schede ), g_flag_char );
      p_stud_declaration_output_rec.i_ben1_pension       :=
         NVL ( TO_CHAR ( p_stud_declaration_rec.i_ben1_pension ), g_flag_char );
      p_stud_declaration_output_rec.i_ben1_benefit       :=
         NVL ( TO_CHAR ( p_stud_declaration_rec.i_ben1_benefit ), g_flag_char );
      p_stud_declaration_output_rec.i_ben2_p60           :=
            NVL ( TO_CHAR ( p_stud_declaration_rec.i_ben2_p60 ), g_flag_char );
	  IF (p_stud_declaration_rec.i_ben2_scheda = 'Y'
	      OR p_stud_declaration_rec.i_ben2_schedd = 'Y')
		--  OR p_stud_declaration_rec.i_ben2_schede = 'Y')
	  THEN p_stud_declaration_output_rec.i_ben2_sched := 'Y';
	  ELSE p_stud_declaration_output_rec.i_ben2_sched := 'N';
	  END IF;
      p_stud_declaration_output_rec.i_ben2_pension       :=
         NVL ( TO_CHAR ( p_stud_declaration_rec.i_ben2_pension ), g_flag_char );
      p_stud_declaration_output_rec.i_ben2_benefit       :=
         NVL ( TO_CHAR ( p_stud_declaration_rec.i_ben2_benefit ), g_flag_char );
      --
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         UTL_FILE.FFLUSH ( g_bad_handle );
         v_tmp_msg    := NULL;
         v_tmp_msg    :=
               'Student '
            || p_stud_declaration_rec.stud_ref_no
			|| ' in session '
            || p_session_code
            || ' - An error has occurred formatting student output data, the error is as follows: '
            || SQLERRM ( SQLCODE );
         UTL_FILE.PUT_LINE ( g_bad_handle, v_tmp_msg );
         UTL_FILE.FFLUSH ( g_bad_handle );
         RETURN FALSE;
--
   END format_output_record;   -- format_output_record

   PROCEDURE initialise_records (
      p_stud_declaration_rec          IN OUT   stud_declaration_rec_type
    , p_stud_declaration_output_rec   IN OUT   stud_output_rec_type
   )
   IS
--
   BEGIN
--
      p_stud_declaration_rec.stud_ref_no                 := NULL;
      p_stud_declaration_rec.stud_forenames              := NULL;
      p_stud_declaration_rec.stud_surname                := NULL;
      p_stud_declaration_rec.ben_house_no_name           := NULL;
      p_stud_declaration_rec.ben_addr_l1                 := NULL;
      p_stud_declaration_rec.ben_addr_l2                 := NULL;
      p_stud_declaration_rec.ben_addr_l3                 := NULL;
      p_stud_declaration_rec.ben_addr_l4                 := NULL;
      p_stud_declaration_rec.ben_post_code               := NULL;
      p_stud_declaration_rec.ben_mailsort                := NULL;
      p_stud_declaration_rec.ben_title                   := NULL;
      p_stud_declaration_rec.ben_forenames               := NULL;
      p_stud_declaration_rec.ben_surname                 := NULL;
	  p_stud_declaration_rec.ben2_title                   := NULL;
      p_stud_declaration_rec.ben2_forenames               := NULL;
      p_stud_declaration_rec.ben2_surname                 := NULL;
	  p_stud_declaration_rec.i_ben1_id                 := NULL;
	  p_stud_declaration_rec.i_ben2_id                 := NULL;
      p_stud_declaration_rec.session_code                := NULL;
      p_stud_declaration_rec.session_code1               := NULL;
      p_stud_declaration_rec.i_ben1_p60                  := NULL;
      p_stud_declaration_rec.i_ben1_scheda               := NULL;
      p_stud_declaration_rec.i_ben1_schedd               := NULL;
    --  p_stud_declaration_rec.i_ben1_schede               := NULL;
      p_stud_declaration_rec.i_ben1_pension              := NULL;
      p_stud_declaration_rec.i_ben1_benefit              := NULL;
      p_stud_declaration_rec.i_ben2_p60                  := NULL;
      p_stud_declaration_rec.i_ben2_scheda               := NULL;
      p_stud_declaration_rec.i_ben2_schedd               := NULL;
    --  p_stud_declaration_rec.i_ben2_schede               := NULL;
      p_stud_declaration_rec.i_ben2_pension              := NULL;
      p_stud_declaration_rec.i_ben2_benefit              := NULL;
      --
RETURN;
--
   EXCEPTION
      WHEN OTHERS THEN
         RETURN;
   END;   -- Initialise records
END;   -- Prov Income Package
/