CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_familystudents
AS
/******************************************************************************
   NAME:       pk_steps_ui_familystudents
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/12/2012  PADDY GRACE      Created this package.
******************************************************************************/
   PROCEDURE getfamilystudents (
      stud_session_id_in   IN              VARCHAR2,
      io_cursor            IN OUT          familystudents_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
      fs_cursor                      familystudents_cursor;
      temp_ben1                      VARCHAR2 (9);
      temp_ben2                      VARCHAR2 (9);
      temp_session_code              NUMBER (4);
      v_count_other_family_members   NUMBER (2);
   BEGIN
      SELECT ss.ben1_id, ss.ben2_id, ss.session_code
        INTO temp_ben1, temp_ben2, temp_session_code
        FROM stud_session ss
       WHERE ss.stud_session_id = stud_session_id_in;

      SELECT COUNT (*)
        INTO v_count_other_family_members
        FROM stud_session ss, stud s
       WHERE (   ss.ben1_id IN (temp_ben1, temp_ben2)
              OR ss.ben2_id IN (temp_ben1, temp_ben2)
             )
         AND ss.session_code = temp_session_code
         AND ss.stud_ref_no = s.stud_ref_no;

      IF v_count_other_family_members > 1
      THEN
         UPDATE stud_session ss
            SET ss.ja_case = 'Y'
          WHERE ss.stud_session_id = stud_session_id_in;
      END IF;

      OPEN fs_cursor FOR
         SELECT s.stud_ref_no, s.forenames, s.surname, s.sex,
                TO_CHAR (s.dob, 'DD/MM/YYYY') AS dob
           FROM stud_session ss, stud s
          WHERE (   ss.ben1_id IN (temp_ben1, temp_ben2)
                 OR ss.ben2_id IN (temp_ben1, temp_ben2)
                )
            AND ss.session_code = temp_session_code
            AND ss.ja_case = 'Y'
            AND ss.stud_ref_no = s.stud_ref_no;

      io_cursor := fs_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getfamilystudents;
END pk_steps_ui_familystudents;
/