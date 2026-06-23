CREATE OR REPLACE PACKAGE BODY SGAS.pk_AWARD_LETTER_SAVE_PDF
/******************************************************************************
   NAME:       PK_STEPS_AWARD_LETTER
   PURPOSE:   Used as part of the transfer to the students online portal
              this loads the award letter pdf to the web data base and also
              creates NULL letters if the student gets their awards revoked
              resulting in no awards in the AWARD table

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   0.2         01/11/2016 Clark Bolan      CREATE_NULL_BLOB Updated to handle
                                            CESB
              14/03/2022  Ruth Gray       Added PTFG_CREATE_NULL_BLOB                 
   ***************************************************************************/
AS
   PROCEDURE Load_BLOB_From_File (l_file_name                IN     VARCHAR2,
                                  l_stud_crse_year_id        IN     NUMBER,
                                  l_learner_application_id   IN     NUMBER,
                                  l_DIRECTORY_NAME           IN     VARCHAR2,
                                  error_boolean                 OUT VARCHAR2,
                                  ERROR_TEXT                    OUT VARCHAR2)
   IS
      p_src_loc    BFILE;
      p_dest_loc   BLOB;
   BEGIN
      IF l_stud_crse_year_id IS NOT NULL
      THEN
         INSERT INTO AWARD_LETTER
              VALUES (l_stud_crse_year_id,
                      EMPTY_BLOB (),
                      SYSDATE,
                      l_stud_crse_year_id)
           RETURNING AWARD_LETTER.award_letter
                INTO p_dest_loc;
      ELSIF l_learner_application_id IS NOT NULL
      THEN
         INSERT INTO AWARD_LETTER
              VALUES (l_learner_application_id,
                      EMPTY_BLOB (),
                      SYSDATE,
                      l_learner_application_id)
           RETURNING AWARD_LETTER.award_letter
                INTO p_dest_loc;
      END IF;


      p_src_loc := BFILENAME (l_directory_name, l_file_name);


      DBMS_LOB.fileopen (p_src_loc);
      DBMS_LOB.open (p_dest_loc, DBMS_LOB.LOB_readwrite);
      DBMS_LOB.LOADFROMFILE (dest_lob   => p_dest_loc,
                             src_lob    => p_src_loc,
                             amount     => DBMS_LOB.GETLENGTH (p_src_loc));

      DBMS_LOB.close (p_dest_loc);
      DBMS_LOB.close (p_src_loc);

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure : Load_BLOB_From_File : @ '
            || SYSDATE
            || ' '
            || 'SQLCODE='
            || SQLCODE
            || ' SQL ERROR = '
            || SQLERRM;
   END Load_BLOB_From_File;


   PROCEDURE CREATE_NULL_BLOB (stud_crse_year_id NUMBER)
   IS
      revoked              NUMBER;
      al_exists            NUMBER;
      l_students_session   NUMBER;
   BEGIN
      --revoked := 1;

      SELECT scy.session_code
        INTO l_students_session
        FROM stud_crse_year scy
       WHERE SCY.STUD_CRSE_YEAR_ID = CREATE_NULL_BLOB.stud_crse_year_id;


      SELECT COUNT (a.stud_ref_no)
        INTO revoked
        FROM award a, stud_crse_year scy
       WHERE     A.STUD_CRSE_YEAR_ID = SCY.STUD_CRSE_YEAR_ID
             AND SCY.LATEST_CRSE_IND = 'Y'
             AND SCY.STUD_CRSE_YEAR_ID = CREATE_NULL_BLOB.stud_crse_year_id
             AND SCY.SAL_SENT = 'Y'
             -- AND SCY.FIRST_CALC_DATE is not null  --removed defect 51 11/03/2015
             AND a.stud_ref_no IN
                    (SELECT a.stud_ref_no
                       FROM award a, stud_award_type b
                      WHERE     a.stud_award_type = b.stud_award_type
                            AND A.STUD_CRSE_YEAR_ID = Scy.STUD_CRSE_YEAR_ID
                            AND b.TYPE IN
                                   ('BURS',
                                    'DEPG',
                                    'FEE',
                                    'LOAN',
                                    'LPCG',
                                    'LPG',
                                    'SMA',
                                    'CESB'));

      IF revoked = 0 AND (l_students_session >= 2017) --session_code added defect 58
      THEN
         --***THIS IS TO HANDLE CASES THAT ALREADY EXIST IN THE AWARD_LETER_EMPTY TABLE
         --Changed to award_letter_empty 09/03/2015.  Database job to be created to push
         --these to the web database.
         SELECT COUNT (stud_crse_year_id)
           INTO al_exists
           FROM AWARD_LETTER_EMPTY
          WHERE stud_crse_year_id = CREATE_NULL_BLOB.stud_crse_year_id;

         IF al_exists > 0
         THEN
            DELETE AWARD_LETTER_EMPTY
             WHERE stud_crse_year_id = CREATE_NULL_BLOB.stud_crse_year_id;
         END IF;

         INSERT INTO award_letter_empty (STUD_CRSE_YEAR_ID,
                                         AWARD_LETTER,
                                         AWARD_LETTER_LAST_UPDATE,
                                         LEARNER_APPLICATION_ID)
              VALUES (CREATE_NULL_BLOB.stud_crse_year_id,
                      NULL,
                      SYSDATE,
                      CREATE_NULL_BLOB.stud_crse_year_id);
      END IF;
   END CREATE_NULL_BLOB;


   PROCEDURE PTFG_CREATE_NULL_BLOB (learner_application_id IN NUMBER)
   IS
      al_exists   NUMBER;
   BEGIN
      --***THIS IS TO HANDLE CASES THAT ALREADY EXIST IN THE AWARD_LETER_EMPTY TABLE
      --Changed to award_letter_empty 09/03/2015.  Database job to be created to push
      --these to the web database.

      SELECT COUNT (learner_application_id)
        INTO al_exists
        FROM AWARD_LETTER_EMPTY
       WHERE learner_application_id =
                PTFG_CREATE_NULL_BLOB.learner_application_id;

      IF al_exists > 0
      THEN
         DELETE AWARD_LETTER_EMPTY
          WHERE learner_application_id =
                   PTFG_CREATE_NULL_BLOB.learner_application_id;
      END IF;

      INSERT INTO award_letter_empty (stud_crse_year_id,
                                           AWARD_LETTER,
                                           AWARD_LETTER_LAST_UPDATE,
                                           learner_application_id)
           VALUES (PTFG_CREATE_NULL_BLOB.learner_application_id,
                   NULL,
                   SYSDATE,
                   learner_application_id);
   END PTFG_CREATE_NULL_BLOB;
   
END pk_AWARD_LETTER_SAVE_PDF;
/