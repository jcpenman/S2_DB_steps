CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_casenotes
AS
/******************************************************************************
   NAME:       pk_steps_ui_CASENOTES
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        17/11/2008     PADDY GRACE            Created this package.
   1.1        28/12/2008     ABIRAMI CHIDAMBARAM    Code Population
   1.2        19/06//2012    Paddy Grace            Code reworked
******************************************************************************/
   PROCEDURE getcaseworkernotes (
      stud_ref_no_in   IN              NUMBER,
      io_cursor        IN OUT          caseworkernote_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
      cwn_cursor   caseworkernote_cursor;
   BEGIN
      OPEN cwn_cursor FOR
         SELECT sn.ID AS id_out, sn.notes_date AS notes_date_out,
                sn.session_code AS session_code_out,
                sn.emp_login_name AS emp_login_out, sn.last_updated_by,
                sn.last_updated_on, sn.notes_type AS notes_type,
                sn.notes_text AS notes_text
           FROM stud_notes sn
          WHERE sn.stud_ref_no = stud_ref_no_in
          ORDER BY notes_date_out DESC;

      io_cursor := cwn_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getcaseworkernotes;

PROCEDURE searchcasenotes (
 stud_ref_no_in        IN              NUMBER,
      notes_date_from_in    IN              DATE,
      notes_date_to_in      IN              DATE,
      session_code_in          IN              VARCHAR2,
      notes_type_in         IN              VARCHAR2,
      created_by_in         IN              VARCHAR2,
      last_update_date_from IN              DATE,
      last_update_date_to   IN              DATE,
      notes_text_in         IN              VARCHAR2,
      io_cursor             IN OUT          caseworkernote_cursor,
      error_boolean         OUT NOCOPY      VARCHAR2,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
)
IS
  /* Formatted on 08/06/2018 09:46:36 (QP5 v5.215.12089.38647) */
    cwn_cursor   caseworkernote_cursor;

BEGIN

   OPEN cwn_cursor FOR
   
 --  with c_note as (select  substr(x.f1,1,instr(x.f1,',') -1) firstnote
     
 /*with c_note as (select  substr(x.f1,    1,                       instr(x.f1,',',1,1) -1)                               firstnote,
                          substr(x.f1,instr(x.f1,',',1,1) + 1, instr(x.f1,',',1,2) - (instr(x.f1,',',1,1) +1  )   ) secondnote,
       substr(x.f1,instr(x.f1,',',1,2) + 1, instr(x.f1,',',1,3) - (instr(x.f1,',',1,2) +1  )   ) third
       
       substr(x.f1,instr(x.f1,',',1,3) + 1, instr(x.f1,',',1,4) - (instr(x.f1,',',1,3) +1  )   ) forth,
       substr(x.f1,instr(x.f1,',',1,4) + 1, instr(x.f1,',',1,5) - (instr(x.f1,',',1,4) +1  )   ) fifth,
       substr(x.f1,instr(x.f1,',',1,5) + 1, instr(x.f1,',',1,6) - (instr(x.f1,',',1,5) +1  )   ) sixth,
       substr(x.f1,instr(x.f1,',',1,6) + 1, instr(x.f1,',',1,7) - (instr(x.f1,',',1,6) +1  )   ) seventh,
       substr(x.f1,instr(x.f1,',',1,7) + 1, instr(x.f1,',',1,8) - (instr(x.f1,',',1,7) +1  )   ) eighth,
       substr(x.f1,instr(x.f1,',',1,8) + 1, instr(x.f1,',',1,9) - (instr(x.f1,',',1,8) +1  )   ) ninth,
       substr(x.f1,instr(x.f1,',',1,9) + 1, instr(x.f1,',',1,10) - (instr(x.f1,',',1,9) +1  )   ) tenth
       
    from (select notes_text_in f1 from dual)x )
*/
  

        SELECT sn.ID AS id_out,
               sn.notes_date AS notes_date_out,
               sn.session_code AS session_code_out,
               sn.emp_login_name AS emp_login_out,
               sn.last_updated_by,
               sn.last_updated_on,
               sn.notes_type AS notes_type,
               sn.notes_text AS notes_text
          FROM stud_notes sn
         WHERE     sn.stud_ref_no = stud_ref_no_in
               AND sn.session_code = NVL (session_code_in, sn.session_code)
               AND sn.emp_login_name = NVL (created_by_in, sn.emp_login_name)
               AND sn.notes_type = NVL (notes_type_in, sn.notes_type)
               AND (UPPER(sn.notes_text) LIKE UPPER(NVL ('%'||notes_text_in||'%', sn.notes_text)))
               AND trunc(sn.notes_date) BETWEEN trunc(NVL(notes_date_from_in,sn.notes_date)) AND trunc(NVL(notes_date_to_in,sn.notes_date))
               AND trunc(sn.last_updated_on) BETWEEN trunc(NVL(last_update_date_from,sn.last_updated_on)) AND trunc(NVL(last_update_date_to,sn.last_updated_on))
              
              ORDER BY notes_date_out DESC;
         
         
         
            /* OR UPPER(sn.notes_text) LIKE UPPER(NVL ('%'||note_text.secondnote||'%', sn.notes_text))
               OR UPPER(sn.notes_text) LIKE UPPER(NVL ('%'||note_text.third||'%', sn.notes_text))
              
               OR UPPER(sn.notes_text) LIKE UPPER(NVL ('%'||note_text.forth||'%', sn.notes_text))
               OR UPPER(sn.notes_text) LIKE UPPER(NVL ('%'||note_text.fifth||'%', sn.notes_text))
               OR UPPER(sn.notes_text) LIKE UPPER(NVL ('%'||note_text.sixth||'%', sn.notes_text))
               OR UPPER(sn.notes_text) LIKE UPPER(NVL ('%'||note_text.seventh||'%', sn.notes_text))
               OR UPPER(sn.notes_text) LIKE UPPER(NVL ('%'||note_text.eighth||'%', sn.notes_text))
               OR UPPER(sn.notes_text) LIKE UPPER(NVL ('%'||note_text.ninth||'%', sn.notes_text))
               OR UPPER(sn.notes_text) LIKE UPPER(NVL ('%'||note_text.tenth||'%', sn.notes_text))
               */
      
      io_cursor := cwn_cursor;
      
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;

END searchcasenotes;





   PROCEDURE setcaseworkernotes (
      id_in             IN       NUMBER,
      stud_ref_no_in    IN       NUMBER,
      session_code_in   IN       NUMBER,
      notes_type_in     IN       VARCHAR2,
      notes_text_in     IN       VARCHAR2,
      user_in           IN       VARCHAR2,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE stud_notes
         SET session_code = session_code_in,
             notes_type = UPPER (notes_type_in),
             notes_text =  notes_text_in,
             last_updated_by = UPPER (user_in),
             last_updated_on = SYSDATE
       WHERE stud_ref_no = stud_ref_no_in AND ID = id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setcaseworkernotes;

   PROCEDURE insertcaseworkernotes (
      stud_ref_no_in    IN       NUMBER,
      session_code_in   IN       NUMBER,
      notes_type_in     IN       VARCHAR2,
      notes_text_in     IN       VARCHAR2,
      user_in           IN       VARCHAR2,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   )
   AS
   BEGIN
      INSERT INTO stud_notes
                  (ID, stud_ref_no, notes_date,
                   session_code, emp_login_name, notes_type,
                   notes_text, last_updated_by, last_updated_on
                  )
           VALUES (std_notes_id_seq.NEXTVAL, stud_ref_no_in, SYSDATE,
                   session_code_in, UPPER (user_in), UPPER (notes_type_in),
                   notes_text_in, UPPER (user_in), SYSDATE
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
   END insertcaseworkernotes;

   PROCEDURE deletecaseworkernotes (
      id_in           IN              NUMBER,
      user_in         IN              VARCHAR2,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      UPDATE stud_notes sn
         SET sn.last_updated_by = UPPER (user_in)
       WHERE sn.ID = id_in;

      DELETE FROM stud_notes sn
            WHERE sn.ID = id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END deletecaseworkernotes;

   PROCEDURE getproblemcase (
      stud_ref_no_in     IN              NUMBER,
      problem_case_out   OUT NOCOPY      VARCHAR2,
      error_boolean      OUT NOCOPY      VARCHAR2,
      ERROR_TEXT         OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT s.problem_case
        INTO problem_case_out
        FROM stud s
       WHERE s.stud_ref_no = stud_ref_no_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getproblemcase;

   PROCEDURE setproblemcase (
      stud_ref_no_in    IN       NUMBER,
      problem_case_in   IN       VARCHAR2,
      user_in           IN       VARCHAR2,
      error_boolean     OUT      VARCHAR2,
      ERROR_TEXT        OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE stud
         SET problem_case = UPPER (problem_case_in),
             last_updated_by = UPPER (user_in),
             last_updated_on = SYSDATE
       WHERE stud_ref_no = stud_ref_no_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setproblemcase;
   
END pk_steps_ui_casenotes;
/