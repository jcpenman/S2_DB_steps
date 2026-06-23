CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_casenotes
AS
/******************************************************************************
   NAME:       pk_steps_ui_CASENOTES
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        17/11/2008      PADDY GRACE           Created this package.
   1.1        28/12/2008     ABIRAMI CHIDAMBARAM   Code Population 
******************************************************************************/

/* 
 * Retreive Case worker note records 
 */
 
PROCEDURE getcaseworkernotes (
      stud_ref_no_in         IN              NUMBER,
      io_cursor              IN OUT          caseworkernote_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
        cwn_cursor           caseworkernote_cursor;
       BEGIN 
        OPEN cwn_cursor FOR
        SELECT sn.id as id_out, sn.STUD_REF_NO as stud_ref_no_out,sn.NOTES_DATE as notes_date_out, sn.SESSION_CODE as session_code_out, 
        sn.EMP_LOGIN_NAME as emp_login_out, sn.NOTES_TYPE as notes_type, sn.NOTES_TEXT as notes_text
        FROM STUD_NOTES sn
        WHERE sn.STUD_REF_NO = stud_ref_no_in ;
               
      
      io_cursor := cwn_cursor;
      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getcaseworkernotes; 
   
/* 
 * Retreive problem case field value for the student from STUD table 
 */   
 
PROCEDURE getproblemcase (
      stud_ref_no_in         IN              NUMBER,
      problem_case_out       OUT NOCOPY      VARCHAR2,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
        BEGIN
        SELECT S.PROBLEM_CASE 
        INTO problem_case_out
        FROM STUD S
        WHERE S.STUD_REF_NO = stud_ref_no_in ;
            
         error_boolean := 'false';
         error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getproblemcase; 
   
   /* 
    * Update Case worker record details into STUD_NOTES table 
    */
       
   PROCEDURE setcaseworkernotes (
      id_in                     IN       NUMBER,
      stud_ref_no_in            IN       NUMBER,
      session_code_in           IN       NUMBER,
      emp_login_name_in         IN       VARCHAR2,
      notes_type_in             IN       VARCHAR2,
      notes_text_in             IN       VARCHAR2,
      user_in                   IN       VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2,
      row_count_sn              OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE STUD_NOTES 
         SET notes_date = SYSDATE,
             session_code = session_code_in,
             emp_login_name = UPPER (emp_login_name_in),
             notes_type = UPPER (notes_type_in),
             notes_text = UPPER (notes_text_in),
             last_updated_by = UPPER (user_in),
             last_updated_on = SYSDATE
        WHERE stud_ref_no = stud_ref_no_in 
          AND id = id_in;
       
      row_count_sn:= SQL%ROWCOUNT;
      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count_sn := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
           
   END setcaseworkernotes;
   
   /* 
    * Update Problem Case field value for the student into STUD table 
    */
    
   PROCEDURE setproblemcase (
      stud_ref_no_in            IN       NUMBER,
      problem_case_in           IN       VARCHAR2,
      user_in                   IN       VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2,
      row_count_s               OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE STUD
          SET problem_case = UPPER(problem_case_in),
              last_updated_by = UPPER (user_in),
              last_updated_on = SYSDATE
        WHERE stud_ref_no = stud_ref_no_in ;
       
      row_count_s:= SQL%ROWCOUNT;
      error_boolean := 'false';
      error_text := 'none';  
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count_s  := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
           
   END setproblemcase;
   
   /* 
    * Insert Case worker record details into STUD_NOTES table 
    */
    
      PROCEDURE insertcaseworkernotes (
      stud_ref_no_in            IN       NUMBER,
      session_code_in           IN       NUMBER,
      emp_login_name_in         IN       VARCHAR2,
      notes_type_in             IN       VARCHAR2,
      notes_text_in             IN       VARCHAR2,
      user_in                   IN       VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2,
      row_count                 OUT      VARCHAR2
   )
   AS
     
   BEGIN
   
          INSERT INTO STUD_NOTES
                  (id,stud_ref_no, notes_date, session_code, emp_login_name, notes_type, notes_text, last_updated_by, last_updated_on
                  )
           VALUES (STD_NOTES_ID_SEQ.NEXTVAL, stud_ref_no_in, SYSDATE, session_code_in, UPPER (emp_login_name_in), UPPER (notes_type_in), UPPER (notes_text_in),
                  UPPER (user_in), SYSDATE );

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
            
   END insertcaseworkernotes;
   
   /* 
    * Delete Case worker record detials from STUD_NOTES table 
    */
    
 PROCEDURE deletecaseworkernotes (
      id_in                  IN             NUMBER,
      user_in                IN             VARCHAR2,
      error_boolean          OUT NOCOPY     VARCHAR2,
      ERROR_TEXT             OUT NOCOPY     VARCHAR2,
      row_count              OUT            VARCHAR2
   )
      IS
        BEGIN
        
        UPDATE STUD_NOTES sn
         SET sn.last_updated_by = UPPER (user_in);
         
        DELETE from STUD_NOTES sn
        WHERE sn.id = id_in;
                
       row_count := SQL%ROWCOUNT;        
       error_boolean := 'false';
       error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END deletecaseworkernotes;   
END pk_steps_ui_casenotes;
/
