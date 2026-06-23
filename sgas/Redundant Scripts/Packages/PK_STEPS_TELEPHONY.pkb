/* Formatted on 2009/11/20 09:49 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY sgas.pk_steps_telephony
AS
-- DESCRIPTION
-- ===========
-- Package contains procedure to create the file for telephony
--
-- Modification History
-- Date                 Author      Ref    Desc
-- 18.11.2009           R.Hunter    001    Initial Creation of Package
-- 19.11.2009           A.Bowman    002    Added procedure clear_telephony
-- 20.11.2009           A.Bowman    003    Added procedure receive_telephony_file
--
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision:  $
--
   PROCEDURE create_telephony_file (
      PATH            IN       VARCHAR2,
      filename        IN       VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   AS
      output_file         UTL_FILE.file_type;

      CURSOR telephony_cur
      IS
         SELECT *
           FROM steps_telephony_out;

      telephony_cur_rec   VARCHAR2 (32767);
   BEGIN
      output_file := UTL_FILE.fopen (PATH, filename, 'W');

      OPEN telephony_cur;

      LOOP
         EXIT WHEN telephony_cur%NOTFOUND;

         FETCH telephony_cur
          INTO telephony_cur_rec;

         UTL_FILE.put_line (output_file, telephony_cur_rec);
      END LOOP;

      CLOSE telephony_cur;

      UTL_FILE.fclose (output_file);
      /* all okay so set error_boolean to false and error text empty*/
      error_boolean := 'false';
      ERROR_TEXT := '';
/* not okay so code drops to exception handler */
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         RAISE;
   END create_telephony_file;

   PROCEDURE send_telephony_file (
      error_boolean   OUT   VARCHAR2,
      ERROR_TEXT      OUT   VARCHAR2
   )
   IS
      v_path   VARCHAR2 (1000);
   BEGIN
      v_path := '/projects/sgas/temp/telephony/TEST2';
      create_telephony_file (v_path, 'GRASS.txt', error_boolean, ERROR_TEXT);
      /* all okay so set error_boolean to false and error text empty*/
      error_boolean := 'false';
      ERROR_TEXT := '';
   /* not okay so code drops to exception handler */
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         RAISE;
   END send_telephony_file;

   /*PROCEDURE clear_telephony
   IS
   BEGIN
     -- Not sure if these are required COMMIT;
     -- SET TRANSACTION USE ROLLBACK SEGMENT rbs1;

      DELETE FROM telephony;

      COMMIT;

   END clear_telephony;*/

   PROCEDURE receive_telephony_file (
      error_boolean   OUT   VARCHAR2,
      ERROR_TEXT      OUT   VARCHAR2
   )
   IS
 --  SET serveroutput on/
--read telephony file

      -- DECLARE
      v_path              VARCHAR2 (1000);
      v_filename          VARCHAR2 (1000);
      input_file          UTL_FILE.file_type;     -- handle on the input file
      v_records_on_file   VARCHAR2 (1000)    := NULL;
      v_stud_ref_no       VARCHAR2 (1000)    := NULL;
      v_req_date          VARCHAR2 (1000)    := NULL;
   BEGIN
      v_path := '/projects/sgas/temp/telephony/TEST2';
      v_filename := 'LOA.txt';
--      open file for reading
      input_file := UTL_FILE.fopen (v_path, v_filename, 'R');
      UTL_FILE.get_line (input_file, v_records_on_file);
                                                       --ignore header record
-- assume at least 1 record on file with data
      v_records_on_file := '1';

      LOOP
         EXIT WHEN v_records_on_file IS NULL;
         UTL_FILE.get_line (input_file, v_records_on_file);
         v_stud_ref_no :=
             SUBSTR (v_records_on_file, 1, INSTR (v_records_on_file, '|') - 1);
         v_req_date :=
                SUBSTR (v_records_on_file, INSTR (v_records_on_file, '|') + 1);
         DBMS_OUTPUT.put_line (v_stud_ref_no || '********' || v_req_date);

         --request duplicate award notice via the StEPS database
         IF v_stud_ref_no IS NOT NULL AND v_req_date IS NOT NULL
         THEN
            UPDATE sgas.stud_crse_year
               SET sal_sent = 'N',
                   stud_crse_year.req_dup = 'Y'
             WHERE latest_crse_ind = 'Y'
               AND stud_ref_no = TO_NUMBER (v_stud_ref_no);

            UPDATE sgas.stud_app_prog
               SET dup_award_letter = dup_award_letter + 1
             WHERE stud_ref_no = v_stud_ref_no;

            INSERT INTO sgas.dla_request
                        (stud_crse_year_id,
                         date_requested
                        )
                 VALUES ((SELECT stud_crse_year_id
                            FROM sgas.stud_crse_year
                           WHERE stud_ref_no = v_stud_ref_no
                             AND latest_crse_ind = 'Y'),
                         TO_DATE (v_req_date, 'dd/mm/yyyy')
                        );

            COMMIT;
         END IF;
      END LOOP;

--close file
      UTL_FILE.fclose (input_file);
      /* all okay so set error_boolean to false and error text empty*/
      error_boolean := 'false';
      ERROR_TEXT := '';
/* not okay so code drops to exception handler */
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         RAISE;
   END receive_telephony_file;

END pk_steps_telephony;
/