CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_joint_application
AS
/******************************************************************************
   NAME:       pk_steps_ui_JOINT_APPLICATION
   PURPOSE:

   REVISIONS:
   Ver        Date           Author                 Description
   ---------  ----------     ---------------        ------------------------------------
   1.0        15/11/2010    PADDY GRACE            Created this package.
******************************************************************************/
   PROCEDURE getjamembers (
      stud_session_id_in   IN              VARCHAR2,
      io_cursor            IN OUT          ja_members_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
      jm_cursor        ja_members_cursor;
      v_ben1_id        NUMBER (10);
      v_ben2_id        NUMBER (10);
      v_session_code   NUMBER (4);
   BEGIN
      ERROR_TEXT := 'Searching for benefactors ';

      SELECT ss.ben1_id, ss.ben2_id, ss.session_code
        INTO v_ben1_id, v_ben2_id, v_session_code
        FROM stud_session ss
       WHERE ss.stud_session_id = stud_session_id_in;

      ERROR_TEXT := 'Searching for Joint Assessment Members ';

      OPEN jm_cursor FOR
         SELECT ss.stud_session_id
           FROM stud_session ss
          WHERE ss.ja_case = 'Y'
            AND ss.ja_stud_type IS NOT NULL
            AND ss.session_code = v_session_code
            AND ( ss.ben1_id IN (v_ben1_id, v_ben2_id) OR ss.ben2_id IN (v_ben1_id, v_ben2_id));

      io_cursor := jm_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getjamembers;

   PROCEDURE getjamemberdetails (
      stud_session_id_in   IN              VARCHAR2,
      stud_ref_no_out      OUT NOCOPY      VARCHAR2,
      forename_out         OUT NOCOPY      VARCHAR2,
      surname_out          OUT NOCOPY      VARCHAR2,
      dob_out              OUT NOCOPY      DATE,
      sex_out              OUT NOCOPY      VARCHAR2,
      ja_stud_type_out     OUT NOCOPY      VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT s.stud_ref_no, s.forenames, s.surname, s.dob, s.sex,
             ss.ja_stud_type
        INTO stud_ref_no_out, forename_out, surname_out, dob_out, sex_out,
             ja_stud_type_out
        FROM stud s, stud_session ss
       WHERE ss.stud_session_id = stud_session_id_in
         AND ss.stud_ref_no = s.stud_ref_no;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getjamemberdetails;

   PROCEDURE getstudsessionjadetails (
      stud_session_id_in   IN              VARCHAR2,
      ja_case_out          OUT NOCOPY      VARCHAR2,
      ja_case_id_out       OUT NOCOPY      VARCHAR2,
      ja_stud_type_out     OUT NOCOPY      VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT ss.ja_case, ss.ja_case_id, ss.ja_stud_type
        INTO ja_case_out, ja_case_id_out, ja_stud_type_out
        FROM stud_session ss
       WHERE ss.stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstudsessionjadetails;

   PROCEDURE setstudsessionjadetails (
      stud_session_id_in   IN              VARCHAR2,
      ja_case_in           IN              VARCHAR2,
      ja_case_id_in        IN              VARCHAR2,
      ja_stud_type_in      IN              VARCHAR2,
      employee_in          IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      UPDATE stud_session ss
         SET ss.ja_case = ja_case_in,
             ss.ja_case_id = ja_case_id_in,
             ss.ja_stud_type = ja_stud_type_in,
             ss.last_updated_by = UPPER (employee_in),
             ss.last_updated_on = SYSDATE
       WHERE ss.stud_session_id = stud_session_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setstudsessionjadetails;

   PROCEDURE getjacase (
      ja_case_id_in                  IN              VARCHAR2,
      ja_case_type_out               OUT NOCOPY      VARCHAR2,
      total_saas_supported_out       OUT NOCOPY      VARCHAR2,
      total_non_saas_supported_out   OUT NOCOPY      VARCHAR2,
      all_registered_out             OUT NOCOPY      VARCHAR2,
      error_boolean                  OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                     OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT jc.ja_case_type, jc.no_saas_students,
             jc.no_non_saas_children, jc.all_registered
        INTO ja_case_type_out, total_saas_supported_out,
             total_non_saas_supported_out, all_registered_out
        FROM ja_case jc
       WHERE jc.ja_case_id = ja_case_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getjacase;

   PROCEDURE setjacase (
      ja_case_id_in                 IN              VARCHAR2,
      ja_case_type_in               IN              VARCHAR2,
      total_saas_supported_in       IN              VARCHAR2,
      total_non_saas_supported_in   IN              VARCHAR2,
      employee_in                   IN              VARCHAR2,
      error_boolean                 OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                    OUT NOCOPY      VARCHAR2
   )
   IS
      v_all_registered        VARCHAR2 (1);
      v_expected_registered   NUMBER (2);
      v_current_registered    NUMBER (2);
   BEGIN
      SELECT COUNT (ss.stud_session_id)
        INTO v_current_registered
        FROM stud_session ss
       WHERE ss.ja_case_id = ja_case_id_in;

      IF v_current_registered = total_saas_supported_in
      THEN
         v_all_registered := 'Y';
      ELSE
         v_all_registered := 'N';
      END IF;

      UPDATE ja_case jc
         SET jc.ja_case_type = UPPER (ja_case_type_in),
             jc.no_saas_students = total_saas_supported_in,
             jc.no_non_saas_children = total_non_saas_supported_in,
             jc.all_registered = UPPER (v_all_registered),
             jc.last_updated_by = UPPER (employee_in),
             jc.last_updated_on = SYSDATE
       WHERE jc.ja_case_id = ja_case_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setjacase;

   PROCEDURE insertjacase (
      session_code_in               IN              VARCHAR2,
      ja_case_type_in               IN              VARCHAR2,
      total_saas_supported_in       IN              VARCHAR2,
      total_non_saas_supported_in   IN              VARCHAR2,
      all_registered_in             IN              VARCHAR2,
      employee_in                   IN              VARCHAR2,
      ja_case_id_out                OUT NOCOPY      VARCHAR2,
      error_boolean                 OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                    OUT NOCOPY      VARCHAR2
   )
   IS  
   BEGIN          
   
      INSERT INTO ja_case
                  ( session_code,
                   ja_case_type, no_saas_students,
                   no_non_saas_children, no_non_saas_parents,
                   all_registered, last_updated_by, last_updated_on
                  )
           VALUES ( session_code_in,
                   UPPER (ja_case_type_in), total_saas_supported_in,
                   total_non_saas_supported_in, 0,
                   all_registered_in, UPPER (employee_in), SYSDATE
                  );

      SELECT ja_case_id_seq.CURRVAL
      INTO ja_case_id_out
      FROM DUAL;   

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertjacase;

   PROCEDURE findjacases (
      stud_session_id_in   IN              VARCHAR2,
      io_cursor            IN OUT          jointassessment_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2,
      row_count            OUT NOCOPY      VARCHAR2
   )
   IS
      ja_cursor           jointassessment_cursor;
      temp_ben1           VARCHAR2 (9);
      temp_ben2           VARCHAR2 (9);
      temp_session_code   NUMBER (4);
   
   BEGIN
      SELECT ss.ben1_id, ss.ben2_id, ss.session_code
        INTO temp_ben1, temp_ben2, temp_session_code
        FROM stud_session ss
       WHERE ss.stud_session_id = stud_session_id_in;

      OPEN ja_cursor FOR
         SELECT ss.stud_session_id AS stud_session_id
         FROM stud_session ss
         WHERE ( ss.ben1_id IN (temp_ben1, temp_ben2)
                 OR ss.ben2_id IN (temp_ben1, temp_ben2)
                )
         AND ss.session_code = temp_session_code
         AND SS.JA_CASE = 'Y';
      
      io_cursor := ja_cursor;
      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END findjacases;
END pk_steps_ui_joint_application;
/
