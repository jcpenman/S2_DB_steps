CREATE OR REPLACE PACKAGE BODY SGAS.SHWAP_SYNC
IS
   /******************************************************************************
      NAME:       SWAP_SYNC
      PURPOSE:

      REVISIONS:
      Ver          Date         Author           Description
      ---------  ----------     ---------------  ------------------------------------
      1.0          16/02/2006                     1. Created this package body.
      2.0          25/11/2015   E Watson          2. Moved to STEPS database  for OLS 2016
   ******************************************************************************/
 
   FUNCTION get_cwa (
      p_cwa_rec   IN OUT cwa_type,
      p_app_id    IN     complete_web_applications.application_id@web%TYPE)
      RETURN BOOLEAN
   IS
   BEGIN
      SELECT stud_ref_no,
             forenames,
             surname,
             email_addr,
             object_id,
             user_id,
             web_submitted,
             session_code
        INTO p_cwa_rec.stud_ref_no,
             p_cwa_rec.forenames,
             p_cwa_rec.surname,
             p_cwa_rec.email_addr,
             p_cwa_rec.object_id,
             p_cwa_rec.web_user_id,
             p_cwa_rec.sub_date,
             p_cwa_rec.session_code
        FROM complete_web_applications@web
       WHERE application_id = p_app_id;
       
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_cwa_rec.error_status := 'E';
         p_cwa_rec.error_mess :=
               'Application '
            || p_app_id
            || ' - An error has occurred retreiving the CWA details. The error is as follows: '
            || SQLERRM (SQLCODE);
         DBMS_OUTPUT.put_line (p_cwa_rec.error_mess);

         RETURN FALSE;
   END;                                                              --get_cwa

   --
   PROCEDURE initialise_records (p_cwa_rec IN OUT cwa_type)
   IS
   BEGIN
      p_cwa_rec.app_id := NULL;
      p_cwa_rec.app_type := 'S';
      p_cwa_rec.object_id := NULL;
      p_cwa_rec.stud_ref_no := NULL;
      p_cwa_rec.title := NULL;
      p_cwa_rec.web_user_id := NULL;
      p_cwa_rec.forenames := NULL;
      p_cwa_rec.surname := NULL;
      p_cwa_rec.email_addr := NULL;
      p_cwa_rec.house_no_name := NULL;
      p_cwa_rec.addr_l1 := NULL;
      p_cwa_rec.sex := NULL;
      p_cwa_rec.dob := NULL;
      p_cwa_rec.sub_date := NULL;
      p_cwa_rec.session_code := NULL;
      p_cwa_rec.error_mess := NULL;
      p_cwa_rec.error_status := NULL;

      RETURN;
   END;                                                   --initialise_records

 
   FUNCTION insert_shwap_error (p_cwa_rec IN cwa_type)
      RETURN BOOLEAN
   IS
      v_error_mess   VARCHAR2 (1024) := NULL;
   BEGIN
      UPDATE complete_web_applications@web
         SET status = 'E'
       WHERE application_id = p_cwa_rec.app_id;

      COMMIT;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         v_error_mess :=
                 p_cwa_rec.error_mess
               + 'A further error has occurred updating the CWA record. The error is as follows: '
            || SQLERRM (SQLCODE);
         DBMS_OUTPUT.put_line (v_error_mess);

         RETURN FALSE;
   END;                                                 -- insert_shwap_error;

   --
   FUNCTION deleteCWA (p_app_id IN applications_made.application_id@web%TYPE)
      RETURN BOOLEAN
   IS
      v_error_mess   VARCHAR2 (1024) := NULL;
   BEGIN
      DELETE FROM complete_web_applications@web
            WHERE application_id = p_app_id;

      COMMIT;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         v_error_mess :=
               'An error has occurred deleting the CWA record for '
            || p_app_id
            || ' . The error is as follows: '
            || SQLERRM (SQLCODE);
         DBMS_OUTPUT.put_line (v_error_mess);

         RETURN FALSE;
   END;                                                            --deleteCWA

   --

   FUNCTION update_Apps_Made (
      p_app_id   IN applications_made.application_id@web%TYPE,
      p_status   IN applications_made.status@web%TYPE)
      RETURN BOOLEAN
   IS
      v_error_mess   VARCHAR2 (1024) := NULL;
   BEGIN
      UPDATE applications_made@web
         SET status = p_status, last_saved_date = SYSDATE
       WHERE application_id = p_app_id;

      COMMIT;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         v_error_mess :=
               'An error has occurred updating the applications_made record for '
            || p_app_id
            || ' . The error is as follows: '
            || SQLERRM (SQLCODE);
         DBMS_OUTPUT.put_line (v_error_mess);


         RETURN FALSE;
   END;

   --
   FUNCTION data_transfer (p_app_type       IN VARCHAR2,
                           p_session_code   IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_return    VARCHAR2 (7);
      v_count     NUMBER := 0;
      v_process   BOOLEAN := TRUE;
      cwa_rec     cwa_type;

      --Get transferable records

      CURSOR fetch_rec
      IS
         SELECT stud_ref_no, application_id
           FROM complete_web_applications@web
          WHERE     object_id IS NOT NULL
                AND application_type = p_app_type
                AND session_code = p_session_code;
   --
   --
   BEGIN
      FOR rec IN fetch_rec
      LOOP
         v_process := TRUE;
         initialise_records (cwa_rec);

         IF v_process = TRUE
         THEN
            --   Get cwa records for processing
            IF NOT get_cwa (cwa_rec, rec.application_id)
            THEN
               v_process := FALSE;
            END IF;
         END IF;

         IF v_process = TRUE
         THEN
            --   insert completed_shwap records for processing
            v_return := insert_cs (cwa_rec);

            -- Send status of record to output
            IF v_return = 'FAIL'
            THEN
               DBMS_OUTPUT.NEW_LINE;
               DBMS_OUTPUT.PUT_LINE (TO_CHAR (rec.stud_ref_no) || ' FAIL');
            ELSIF v_return = 'OK'
            THEN
               DBMS_OUTPUT.NEW_LINE;
               DBMS_OUTPUT.PUT_LINE (TO_CHAR (rec.stud_ref_no) || ' OK');
            END IF;

            --
            v_count := v_count + 1;
            COMMIT;
         END IF;

         IF v_return = 'OK'
         THEN
            --   Get cwa records for processing
            IF NOT update_apps_made (rec.application_id, 'T')
            THEN
               v_process := FALSE;
            END IF;

            IF v_process = TRUE
            THEN
               IF NOT deleteCWA (rec.application_id)
               THEN
                  v_process := FALSE;
               END IF;
            END IF;
         ELSIF v_return = 'FAIL'
         THEN
            IF NOT insert_shwap_error (cwa_rec)
            THEN
               v_process := FALSE;
            END IF;
         END IF;
      END LOOP;

      --
      DBMS_OUTPUT.NEW_LINE;
      DBMS_OUTPUT.PUT_LINE (
            ' SHWAP Processing Completed at '
         || TO_CHAR (SYSDATE, 'dd-mm-yyyy HH:MI:SS'));
      DBMS_OUTPUT.NEW_LINE;
      DBMS_OUTPUT.PUT_LINE (v_count || ' records processed');
      RETURN 'OK';
   --
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.NEW_LINE;
         DBMS_OUTPUT.PUT_LINE (
            'Fatal Error in Transfer while processing student ');
         DBMS_OUTPUT.NEW_LINE;
         DBMS_OUTPUT.PUT_LINE (TO_CHAR (SQLCODE));
         ROLLBACK;
         RETURN 'FAIL';
   END;

   --

  /* Formatted on 26/11/2015 08:44:36 (QP5 v5.215.12089.38647) */
FUNCTION insert_cs (p_cwa_rec IN OUT cwa_type)
   RETURN VARCHAR2
IS
BEGIN
   INSERT INTO completed_shwap (STUD_REF_NO,
                                FORENAMES,
                                SURNAME,
                                SESSION_CODE,
                                OBJECT_ID,
                                WEB_USER_ID,
                                WEB_SUBMITTED_DATE,
                                STATUS,
                                ERROR_MESSAGE)
        VALUES (p_cwa_rec.stud_ref_no,
                p_cwa_rec.forenames,
                p_cwa_rec.surname,
                p_cwa_rec.session_code,
                p_cwa_rec.object_id,
                p_cwa_rec.web_user_id,
                p_cwa_rec.sub_date,
                p_cwa_rec.error_status,
                p_cwa_rec.error_mess);

   -- update stud web_user_id  to enable correct BPM function ------
   UPDATE stud
      SET web_user_id = p_cwa_rec.web_user_id,
          email_addr  = p_cwa_rec.email_addr
    WHERE stud_ref_no = p_cwa_rec.stud_ref_no;

   COMMIT;
   RETURN ('OK');
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('no records found');
   WHEN DUP_VAL_ON_INDEX
   THEN
      UPDATE completed_shwap
         SET object_id = p_cwa_rec.object_id,
             web_submitted_date = p_cwa_rec.sub_date
       WHERE stud_ref_no = p_cwa_rec.stud_ref_no;

      RETURN ('OK');
   WHEN OTHERS
   THEN
      p_cwa_rec.error_status := 'E';
      p_cwa_rec.error_mess :=
            'Student '
         || p_cwa_rec.stud_ref_no
         || ' - An error has occurred retreiving the CWA details. The error is as follows: '
         || SQLERRM (SQLCODE);
      DBMS_OUTPUT.put_line (p_cwa_rec.error_mess);
      ROLLBACK;
      RETURN ('FAIL');
END;                                                               --insert_cs


--
END SHWAP_SYNC;
/