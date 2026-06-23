CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_UI_GRASS_JOINT_APP AS
/******************************************************************************
   NAME:       pk_steps_ui_grass_JOINT_APP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        26/01/2009      ABIRAMI CHIDAMBARAM   Created this package.
   ******************************************************************************/
   PROCEDURE getjointapplication (
      stud_session_id_in               IN              NUMBER,
      ja_case_out                      OUT NOCOPY      VARCHAR2,
      ja_stud_type_out                 OUT NOCOPY      VARCHAR2,
      total_saas_supported_out         OUT NOCOPY      NUMBER,
      total_non_saas_supported_out     OUT NOCOPY      NUMBER,
      joint_application_received_out   OUT NOCOPY      VARCHAR2,
      error_boolean                    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                       OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      SELECT ss.JA_CASE, ss.JA_STUD_TYPE, jc.NO_SAAS_STUDENTS, jc.NO_NON_SAAS_CHILDREN, jc.ALL_REGISTERED
        INTO ja_case_out, ja_stud_type_out, total_saas_supported_out, total_non_saas_supported_out, joint_application_received_out
        FROM stud_session @ GRASS ss, ja_case @ GRASS jc
       WHERE ss.ja_case_id = jc.JA_CASE_ID(+)
         AND ss.STUD_SESSION_ID = stud_session_id_in;

      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getjointapplication;
   
   PROCEDURE getjamemberslist (
      stud_session_id_in   IN              NUMBER,
      io_cursor            IN  OUT         member_list_cursor,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2,
      temp_BEN1            OUT NOCOPY      NUMBER,
      temp_BEN2            OUT NOCOPY      NUMBER
      )
   AS
      ml_cursor         member_list_cursor;
   BEGIN
          
         SELECT BEN1_ID, BEN2_ID
         INTO temp_BEN1, temp_BEN2
           FROM STUD_SESSION @ GRASS
          WHERE stud_session_id = stud_session_id_in;
              
          OPEN ml_cursor FOR
         SELECT STUD_REF_NO as stud_ref_no_out, FORENAMES as forename, SURNAME as surname, 
                to_char(DOB, 'dd/MM/yyyy') as dob, DECODE (SEX, 'F', 'FEMALE', 'M', 'MALE') as sex, DECODE (JA_STUD_TYPE, 'P', 'PARENT/CHILD', 'S', 'SIBLING') as type
           FROM STUD_SESSION @ GRASS
          WHERE BEN1_ID = temp_BEN1
          OR BEN2_ID = temp_BEN2;        
       
      io_cursor := ml_cursor;
     
      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getjamemberslist;
   
END PK_STEPS_UI_GRASS_JOINT_APP;
/
