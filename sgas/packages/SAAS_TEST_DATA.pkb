CREATE OR REPLACE PACKAGE BODY SGAS.SAAS_TEST_DATA
AS
   /******************************************************************************
      NAME:      SAAS_TEST_DATA
      PURPOSE:TEST AUTOMATION
      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      0.1        17/11/2017     Paul Hughes    Creation of db package
      0.2       22/07/2020     Kara Fraser     Update package to submit applications to take into account all TANDV checks, added auto calc procedure and submit student enquiry procedure.
      0.3       14/08/2020      Kara Fraser     Added in procedure to submit correspondence
      0.4       18/02/2021      Kara Fraser     Added in procedure to submit auto calc cases only.
   ******************************************************************************/



   PROCEDURE Test_pop_shortened_application
   IS
      RetVal           VARCHAR2 (32767);



      P_SESSION_CODE   NUMBER;
   BEGIN
      SELECT NVAL - 1
        INTO P_SESSION_CODE
        FROM CONFIG_DATA
       WHERE ITEM_NAME = 'CURRENT_SESSION';



      RetVal :=
         SGAS.SHORTENED_APPLICATION_WEB.POP_SHORTENED_APPLICATION (
            P_SESSION_CODE);



      DBMS_OUTPUT.Put_Line ('RetVal = ' || RetVal);



      DBMS_OUTPUT.Put_Line ('');



      COMMIT;
   END;



   PROCEDURE ProcessTask (Task_number IN NUMBER)
   IS
      v_session_code      NUMBER := 2017;
      v_batch_type_code   VARCHAR2 (1);
      v_attendance_type   VARCHAR2 (1);



      v_items             NUMBER;
   BEGIN
      IF Task_number = 1
      THEN
         SubmitAttendanceDataTasks (v_session_code,
                                    'W',
                                    1);
      END IF;
   END;



   PROCEDURE SubmitAttendanceDataTasks (current_session      IN NUMBER,
                                        AttendanceDataType   IN VARCHAR2,
                                        number_of_items         NUMBER)
   IS
      --------AMEND THE v_status type to suite the type of attendance data you are submitting
      ----O = Other
      ---C = Course Change
      ---W = Withdrawal
      ---T = No Trace
      ---N = Non Attendance
      ----E = Enrolement
      ---R = Repeat Year
      ---X = Exchange/Year Abroad
      ---P = Placement

      v_status        VARCHAR2 (1) := AttendanceDataType; -----AMEND BATCH_TYPE_CODE TO DIFFERENT BATCH TYPES
      x               NUMBER := 0;

      CURSOR c_students
      IS
         SELECT a.STUD_REF_NO,
                a.INST_NAME,
                a.SESSION_CODE
           FROM STUD_CRSE_YEAR A,
                ATTENDANCE_DATA B
          WHERE     A.STUD_CRSE_YEAR_ID = b.STUD_CRSE_YEAR_ID
                AND A.SESSION_CODE = current_session
                AND a.application_status = 'C' ------USE THIS FOR WITHDRAWAL OR NON ATTENDANCE CASES TO PRODUCE A LETTER
                AND (B.ENROL_REQUIRED = 'Y' OR B.ONGOING_REQUIRED = 'Y')
                AND a.STUD_REF_NO NOT IN
                       (SELECT stud_ref_no
                          FROM attendance_data_received
                         WHERE session_code = current_session)
                AND ROWNUM < number_of_items;



      v_studentsRec   c_students%ROWTYPE;
   BEGIN
      OPEN c_students;



      LOOP
         FETCH c_students INTO v_studentsRec;



         EXIT WHEN c_students%NOTFOUND;



         IF v_status = 'O'
         THEN
            INSERT
              INTO SGAS.ATTENDANCE_DATA_RECEIVED (ATTENDANCE_DATA_RECEIVED_ID,
                                                  FILE_CREATION_DATE,
                                                  INSTITUTION,
                                                  SESSION_CODE,
                                                  STUD_REF_NO,
                                                  STATUS,
                                                  ADDITIONAL_INFO,
                                                  DATE_REC_CREATED,
                                                  DUPLICATE,
                                                  PROCESSED)
            VALUES (att_data_recd_id_seq.NEXTVAL,
                    SYSDATE,
                    v_studentsRec.INST_NAME,
                    v_studentsRec.session_code,
                    v_studentsRec.stud_ref_no,
                    v_status,
                    'A message from the Institution',
                    SYSDATE,
                    'N',
                    'N');



            COMMIT;
         ELSIF v_status = 'C'
         THEN
            INSERT
              INTO SGAS.ATTENDANCE_DATA_RECEIVED (ATTENDANCE_DATA_RECEIVED_ID,
                                                  FILE_CREATION_DATE,
                                                  INSTITUTION,
                                                  SESSION_CODE,
                                                  STUD_REF_NO,
                                                  STATUS,
                                                  COURSE_CODE,
                                                  COURSE_TITLE,
                                                  CONFIRMED_CRSE_YEAR,
                                                  DATE_COURSE_CHANGED,
                                                  DATE_REC_CREATED,
                                                  DUPLICATE,
                                                  PROCESSED)
            VALUES (att_data_recd_id_seq.NEXTVAL,
                    SYSDATE,
                    v_studentsRec.INST_NAME,
                    v_studentsRec.session_code,
                    v_studentsRec.stud_ref_no,
                    v_status,
                    'ABC',
                    'BLAH',
                    1,
                    SYSDATE,
                    SYSDATE,
                    'N',
                    'N');



            COMMIT;
         ELSIF v_status = 'W'
         THEN
            INSERT
              INTO SGAS.ATTENDANCE_DATA_RECEIVED (ATTENDANCE_DATA_RECEIVED_ID,
                                                  FILE_CREATION_DATE,
                                                  INSTITUTION,
                                                  SESSION_CODE,
                                                  STUD_REF_NO,
                                                  STATUS,
                                                  EFFECTIVE_DATE_WITHDRAWN,
                                                  DATE_REC_CREATED,
                                                  DUPLICATE,
                                                  PROCESSED)
            VALUES (att_data_recd_id_seq.NEXTVAL,
                    SYSDATE,
                    v_studentsRec.INST_NAME,
                    v_studentsRec.session_code,
                    v_studentsRec.stud_ref_no,
                    v_status,
                    TO_DATE ('11/08/2018 00:00:00',
                             'MM/DD/YYYY HH24:MI:SS'), --------NOTE THIS NEEDS TO BE WITHIN THE TERM DATE OR WILL GO TO WORKITEM.
                    SYSDATE,
                    'N',
                    'N');



            COMMIT;
         ELSIF v_status = 'T'
         THEN
            INSERT
              INTO SGAS.ATTENDANCE_DATA_RECEIVED (ATTENDANCE_DATA_RECEIVED_ID,
                                                  FILE_CREATION_DATE,
                                                  INSTITUTION,
                                                  SESSION_CODE,
                                                  STUD_REF_NO,
                                                  STATUS,
                                                  DATE_REC_CREATED,
                                                  DUPLICATE,
                                                  PROCESSED)
            VALUES (att_data_recd_id_seq.NEXTVAL,
                    SYSDATE,
                    v_studentsRec.INST_NAME,
                    v_studentsRec.session_code,
                    v_studentsRec.stud_ref_no,
                    v_status,
                    SYSDATE,
                    'N',
                    'N');



            COMMIT;
         ELSIF v_status = 'N'
         THEN
            INSERT
              INTO SGAS.ATTENDANCE_DATA_RECEIVED (ATTENDANCE_DATA_RECEIVED_ID,
                                                  FILE_CREATION_DATE,
                                                  INSTITUTION,
                                                  SESSION_CODE,
                                                  STUD_REF_NO,
                                                  STATUS,
                                                  DATE_REC_CREATED,
                                                  DUPLICATE,
                                                  PROCESSED)
            VALUES (att_data_recd_id_seq.NEXTVAL,
                    SYSDATE,
                    v_studentsRec.INST_NAME,
                    v_studentsRec.session_code,
                    v_studentsRec.stud_ref_no,
                    v_status,
                    SYSDATE,
                    'N',
                    'N');



            COMMIT;
         ELSIF v_status = 'E'
         THEN
            INSERT
              INTO SGAS.ATTENDANCE_DATA_RECEIVED (ATTENDANCE_DATA_RECEIVED_ID,
                                                  FILE_CREATION_DATE,
                                                  INSTITUTION,
                                                  SESSION_CODE,
                                                  STUD_REF_NO,
                                                  STATUS,
                                                  DATE_REC_CREATED,
                                                  DUPLICATE,
                                                  PROCESSED)
            VALUES (att_data_recd_id_seq.NEXTVAL,
                    SYSDATE,
                    v_studentsRec.INST_NAME,
                    v_studentsRec.session_code,
                    v_studentsRec.stud_ref_no,
                    v_status,
                    SYSDATE,
                    'N',
                    'N');



            COMMIT;
         ELSIF v_status = 'R'
         THEN
            INSERT
              INTO SGAS.ATTENDANCE_DATA_RECEIVED (ATTENDANCE_DATA_RECEIVED_ID,
                                                  FILE_CREATION_DATE,
                                                  INSTITUTION,
                                                  SESSION_CODE,
                                                  STUD_REF_NO,
                                                  STATUS,
                                                  CONFIRMED_CRSE_YEAR,
                                                  ADDITIONAL_INFO,
                                                  DATE_REC_CREATED,
                                                  DUPLICATE,
                                                  PROCESSED)
            VALUES (att_data_recd_id_seq.NEXTVAL,
                    SYSDATE,
                    v_studentsRec.INST_NAME,
                    v_studentsRec.session_code,
                    v_studentsRec.stud_ref_no,
                    v_status,
                    3,
                    'RWA',
                    SYSDATE,
                    'N',
                    'N');



            COMMIT;
         ELSIF v_status = 'X'
         THEN
            INSERT
              INTO SGAS.ATTENDANCE_DATA_RECEIVED (
                      ATTENDANCE_DATA_RECEIVED_ID,
                      FILE_CREATION_DATE,
                      INSTITUTION,
                      SESSION_CODE,
                      STUD_REF_NO,
                      STATUS,
                      COURSE_CODE,
                      COURSE_TITLE,
                      CONFIRMED_CRSE_YEAR,
                      ADDITIONAL_INFO,
                      DATE_REC_CREATED,
                      DUPLICATE,
                      PROCESSED)
            VALUES (
                      att_data_recd_id_seq.NEXTVAL,
                      SYSDATE,
                      v_studentsRec.INST_NAME,
                      v_studentsRec.session_code,
                      v_studentsRec.stud_ref_no,
                      v_status,
                      'A200',
                      'TEST CODE',
                      4,
                      'Student is taking part in a voluntary exchange programme for part of the year',
                      SYSDATE,
                      'N',
                      'N');



            COMMIT;
         ELSIF v_status = 'P'
         THEN
            INSERT
              INTO SGAS.ATTENDANCE_DATA_RECEIVED (ATTENDANCE_DATA_RECEIVED_ID,
                                                  FILE_CREATION_DATE,
                                                  INSTITUTION,
                                                  SESSION_CODE,
                                                  STUD_REF_NO,
                                                  STATUS,
                                                  COURSE_TITLE,
                                                  CONFIRMED_CRSE_YEAR,
                                                  ADDITIONAL_INFO,
                                                  DATE_REC_CREATED,
                                                  DUPLICATE,
                                                  PROCESSED)
            VALUES (att_data_recd_id_seq.NEXTVAL,
                    SYSDATE,
                    v_studentsRec.INST_NAME,
                    v_studentsRec.session_code,
                    v_studentsRec.stud_ref_no,
                    v_status,
                    'TEST CODE',
                    4,
                    'full year compulsory placement',
                    SYSDATE,
                    'N',
                    'N');



            COMMIT;
         END IF;



         DBMS_OUTPUT.PUT_LINE (
            'Created ' || v_studentsRec.stud_ref_no || ' Student Reference');



         x := x + 1;
      END LOOP;



      DBMS_OUTPUT.PUT_LINE ('Created ' || x || ' CorrWorkItems');



      CLOSE c_students;
   END;



   PROCEDURE SubmitCorrespondence (schemetype          IN VARCHAR2,
                                   current_session     IN NUMBER,
                                   batch_type_code     IN NUMBER,
                                   number_of_corress      NUMBER)
   IS
      v_batch_code           NUMBER := batch_type_code; -----AMEND BATCH_TYPE_CODE TO DIFFERENT BATCH TYPES
      v_document_type_code   VARCHAR2 (20);
      v_document_name        VARCHAR2 (20);
      x                      NUMBER := 0;
      y                      NUMBER := 10000;
      v_object_id            VARCHAR2 (15) := 'SAAS000000';
      v_temp                 VARCHAR2 (15);
      v_session_code         NUMBER (4) := current_session;
      v_corress_item_no      NUMBER (2) := number_of_corress;
      v_scheme_type          VARCHAR2 (1) := schemetype;

      CURSOR c_students
      IS
         -----SELECTION CRITERIA- AMEND HERE



         SELECT SS.stud_ref_no,
                SS.session_code
           FROM STUD_SESSION SS,
                STUD_CRSE_YEAR SCY
          WHERE     SS.STUD_SESSION_ID = SCY.STUD_SESSION_ID
                AND SCHEME_TYPE = v_scheme_type
                AND SCY.SESSION_CODE = v_session_code ----- AMEND SESSION CODE IF NECESSARY
                AND ROWNUM < v_corress_item_no; -------_AMEND TO HOW MANY CORRESPONDENCE ITEMS IS REQUIRED



      v_studentsRec          c_students%ROWTYPE;
   BEGIN
      OPEN c_students;



      LOOP
         FETCH c_students INTO v_studentsRec;



         EXIT WHEN c_students%NOTFOUND;



         IF v_batch_code = 55
         THEN
            v_document_type_code := 'GEN_CORR';



            v_document_name := 'GEN_CORR:1112';
         ELSIF v_batch_code = 56
         THEN
            v_document_type_code := 'DSA_APP';



            v_document_name := 'DSA_APP:1112';
         ELSIF v_batch_code = 99
         THEN
            v_document_type_code := 'SE_AMEND_APP';
         END IF;



         v_temp := v_object_id || TO_CHAR (y);



         IF v_batch_code IN (55, 56)
         THEN
            --     SET DEFINE OFF;



            INSERT INTO EDM.EDM_TEMP (OBJECT_ID,
                                      DOCUMENT_TYPE_CODE,
                                      DOCUMENT_NAME,
                                      DOCUMENT_TYPE_COUNT,
                                      ATTACHMENT_TYPE_CODE)
                 VALUES (v_temp,
                         'XML',
                         'XML',
                         1,
                         'XML');



            INSERT INTO EDM.EDM_TEMP (OBJECT_ID,
                                      SESSION_CODE,
                                      DOCUMENT_TYPE_CODE,
                                      DOCUMENT_NAME,
                                      DOCUMENT_TYPE_COUNT,
                                      ATTACHMENT_TYPE_CODE)
                 VALUES (v_temp,
                         v_studentsRec.session_code,
                         v_document_type_code,
                         v_document_name,
                         1,
                         'TIFF');



            INSERT INTO EDM.EDM_COMPLETE (OBJECT_ID,
                                          BATCH_TYPE_CODE,
                                          STUD_REF_NO,
                                          BATCH_ID,
                                          ENVELOPE_ID,
                                          SCAN_DATE,
                                          PROC_ERROR,
                                          URGENT)
                 VALUES (v_temp,
                         v_batch_code,
                         v_studentsRec.stud_ref_no,
                         2.0110228355E15,
                         1,
                         SYSDATE,
                         'N',
                         'N');



            x := x + 1;



            y := y + 1;
         ELSIF v_batch_code = 99
         THEN
            INSERT INTO EDM.EDM_TEMP (OBJECT_ID,
                                      SESSION_CODE,
                                      DOCUMENT_TYPE_CODE,
                                      DOCUMENT_NAME,
                                      DOCUMENT_TYPE_COUNT,
                                      ATTACHMENT_TYPE_CODE)
                 VALUES (v_temp,
                         v_studentsRec.session_code,
                         v_document_type_code,
                         v_studentsRec.stud_ref_no || '-STUD_ENQUIRY_MSG',
                         1,
                         'PDF');



            INSERT INTO EDM.EDM_COMPLETE (OBJECT_ID,
                                          BATCH_TYPE_CODE,
                                          STUD_REF_NO,
                                          SCAN_DATE,
                                          PROC_ERROR,
                                          URGENT)
                 VALUES (v_temp,
                         v_batch_code,
                         v_studentsRec.stud_ref_no,
                         SYSDATE,
                         'N',
                         'N');



            x := x + 1;



            y := y + 1;
         END IF;



         COMMIT;



         DBMS_OUTPUT.PUT_LINE (
            'Created correspondence ' || v_studentsRec.stud_ref_no);
      END LOOP;



      DBMS_OUTPUT.PUT_LINE ('Created ' || x || ' CorrWorkItems');



      CLOSE c_students;
   END;



   PROCEDURE SubmitTestApplicationsMessages
   IS
      v_batch_code           NUMBER;
      v_raw_data_id          NUMBER;
      v_session_code         NUMBER (4);
      v_session_code_61      NUMBER (4);
      v_document_type_code   VARCHAR2 (20);
      v_document_name        VARCHAR2 (20);
      x                      NUMBER := 0;
      y                      NUMBER;
      v_object_id            VARCHAR2 (15) := 'SAAS';
      v_object_temp          VARCHAR2 (6);
      v_temp                 VARCHAR2 (15);
      v_slc_Ref_no           VARCHAR2 (10);
      v_stud_Ref_no          NUMBER (10);
      v_forenames            VARCHAR2 (25);
      v_surname              VARCHAR2 (25);
      v_nino                 VARCHAR2 (10);
      v_email                VARCHAR2 (80);
      v_portal_user_id       VARCHAR2 (20);
      v_sort_code            VARCHAR2 (6);
      v_account_no           VARCHAR2 (10);
      v_dob                  VARCHAR2 (10);
      v_count                NUMBER (10);
      v_date_app_rec         VARCHAR2 (10);

      CURSOR c_students      --Select all active cases from TEST_DATA_RAW_DATA
      IS
           SELECT *
             FROM EDM.TEST_DATA_RAW_DATA
            WHERE IS_ACTIVE = 'Y' AND CASE_ID > 0
         ORDER BY CASE_ID;

      v_studentsRec          c_students%ROWTYPE;
   BEGIN
      BEGIN                                              --Reset results field
         UPDATE EDM.TEST_STUDENT_MESSAGES
            SET RESULT = NULL,
                STUD_REF_NO = NULL;
      END;



      SELECT NVAL                                        --Set current session
        INTO v_session_code
        FROM SGAS.CONFIG_DATA
       WHERE ITEM_NAME = 'CURRENT_SESSION';



      v_session_code_61 := v_session_code - 61; --used for students aged over 61 check later in the script



      SELECT MESSAGE         --This value is used to create a unique object id
        INTO y
        FROM EDM.TEST_STUDENT_MESSAGES
       WHERE CASE_ID = 0;



      OPEN c_students;



      LOOP
         FETCH c_students INTO v_studentsRec;



         EXIT WHEN c_students%NOTFOUND;



         v_temp := v_object_id || v_object_temp || TO_CHAR (y); --Create new object id

         SELECT EDM.RAW_DATA_ID_SEQ.NEXTVAL INTO v_raw_data_id FROM DUAL; --Create new raw data id



         SELECT TO_CHAR (SYSDATE,     --Set application recieved date to today
                         'DDMMYYYY')
           INTO v_date_app_rec
           FROM DUAL;



         v_email := NULL; --Set email and portal user id to NULL to prevent duplicates

         v_portal_user_id := NULL;

         --Section to set student reference number

         IF v_studentsRec.case_id IN (15, 31, 41, 57, 90) -- Find an existing student for these cases that has a GRASS record but not StEPS record.
         THEN
            BEGIN
               SELECT STUD_REF_NO
                 INTO v_stud_ref_no
                 FROM SGAS.STUD@GRASS S
                WHERE     NOT EXISTS
                             (SELECT STUD_REF_NO
                                FROM SGAS.STUD S2
                               WHERE S.STUD_REF_NO = S2.STUD_REF_NO)
                      AND NOT EXISTS
                             (SELECT STUD_REF_NO
                                FROM EDM.TEST_STUDENT_MESSAGES E
                               WHERE S.STUD_REF_NO = E.STUD_REF_NO)
                      AND ROWNUM < 2;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  DBMS_OUTPUT.PUT_LINE (
                        'Created Case ID '
                     || v_studentsRec.case_id
                     || ' Cannot create Unique Case - Missing Data ');
            END;



            IF v_studentsRec.case_id IN (31, 57)         --- Add debt to GRASS
            THEN
               UPDATE SGAS.STUD@GRASS
                  SET OVERPAYMENT = '100'
                WHERE STUD_REF_NO = v_stud_ref_no;
            ELSIF v_studentsRec.case_id IN (15, 41, 90) --- Set the suspend flag to Y in GRASS
            THEN
               UPDATE SGAS.STUD@GRASS
                  SET SUSPEND_PAYMENT = 'Y'
                WHERE STUD_REF_NO = v_stud_ref_no;
            END IF;
         ELSIF     v_studentsRec.new_student = 'N'
               AND v_studentsRec.case_id NOT IN (15, 31, 41, 57, 90)
         THEN
            v_stud_ref_no := v_studentsRec.stud_ref_no;
         ELSE
            SELECT SGAS.ST_STUD_REF_NO_SEQ.NEXTVAL
              INTO v_stud_ref_no
              FROM DUAL;             --Generate a new student reference number
         END IF;



         IF        v_studentsRec.new_student = 'N'
               AND v_studentsRec.case_id NOT IN (15, 31, 41, 57, 90) --Set NINO
            OR v_studentsRec.case_id IN (19, 21, 22, 27, 28, 48, 55, 74)
         THEN
            v_nino := v_studentsRec.NI_NO;
         ELSIF     v_studentsRec.new_student = 'N'
               AND v_studentsRec.case_id IN (15, 31, 41, 57, 90)
         THEN
            SELECT NI_NO
              INTO v_nino
              FROM SGAS.STUD@GRASS
             WHERE STUD_REF_NO = v_stud_ref_no;
         ELSE
            LOOP
               SELECT SGAS.PK_COPY_APPLICATION.GET_UNIQUE_NINO
                 INTO v_nino
                 FROM DUAL;



               SELECT COUNT (*)
                 INTO v_count
                 FROM SGAS.STUD
                WHERE NI_NO = v_nino;



               EXIT WHEN v_count = 0;
            END LOOP;
         END IF;



         --Set forename and surnme.



         IF    v_studentsRec.new_student = 'N'
            OR v_studentsRec.case_id IN (22, 24, 28, 46, 48, 71) -- Duplicate check case, names and dob should not be changed.
         THEN
            v_forenames := v_studentsRec.forenames;



            v_surname := v_studentsRec.surname;
         ELSE
            v_forenames := 'AutoTest'; -- All other cases given new forename and surname to prevent duplicate cases building up.



            v_surname :=
               DBMS_RANDOM.string ('U',
                                   25);
         END IF;

         IF v_studentsRec.case_id IN (85, 155) -- Check for students aged under 16
         THEN
            SELECT TO_CHAR (SYSDATE - INTERVAL '16' YEAR + 1,
                            'DDMMYYYY')
              INTO v_dob
              FROM DUAL;
         ELSIF v_studentsRec.case_id = 81 -- Check for students aged over 61 - dob is 1st August of current session
         THEN
            v_dob := '0108' || v_session_code_61;
         ELSIF v_studentsRec.case_id = 12 -- Check for students aged over 61 - dob is 1st August of current session +1
         THEN
            v_dob := '0107' || (v_session_code_61 + 1);
         ELSIF v_studentsRec.case_id = 129 -- Auto calc case to check that a student aged 61 on 2nd August current session +1 WILL auto calc.
         THEN
            v_dob := '0207' || (v_session_code_61 + 1);
         ELSIF v_studentsRec.case_id = 86 -- Auto calc case to check that a student aged 61 on 2nd August current session +1 WILL auto calc.
         THEN
            v_dob := '0208' || (v_session_code - 25); -- Check relating to students aged under 25. Students 25th birthday is 2nd August i.e. just after cut off so should still be treated as under 25.
         ELSIF v_studentsRec.case_id = 163 -- Auto calc case to check that a student aged 16 today will be auto calc'd.
         THEN
            SELECT TO_CHAR (SYSDATE - INTERVAL '16' YEAR,
                            'DDMMYYYY')
              INTO v_dob
              FROM DUAL;
         ELSE
            v_dob := v_studentsRec.dob;
         END IF;



         v_sort_code := v_studentsRec.sort_code;            --Set bank details



         v_account_no := v_studentsRec.account_no;


         IF     v_studentsRec.new_student = 'N'
            AND v_studentsRec.case_id NOT IN (15, 31, 41, 57, 90)
         THEN
            v_slc_ref_no := v_studentsRec.scottish_cand;
         ELSIF     v_studentsRec.new_student = 'N'
               AND v_studentsRec.case_id NOT IN (15, 31, 41, 57, 90)
         THEN
            SELECT SCOTTISH_CAND
              INTO v_slc_ref_no
              FROM SGAS.STUD@GRASS
             WHERE STUD_REF_NO = v_stud_ref_no;
         ELSE
            v_slc_Ref_no := NULL;
         END IF;                   --Reset SLC Reference to NULL for each loop



         -----CASE SPECIFIC AREA IF THERE IS ANYTHING SPECIFIC TO A CASE WE NEED TO LOOK UP SOME DATA

         IF v_studentsRec.case_id IN (20, 46, 51) --SET SORT_CODE AND ACCOUNT_NO FOR DUPLICATE CASES
         THEN
            BEGIN
               SELECT SORT_CODE,
                      ACCOUNT_NO
                 INTO v_sort_code,
                      v_account_no
                 FROM SGAS.STUD S
                WHERE     SORT_CODE IS NOT NULL
                      AND NOT EXISTS
                                 (SELECT SORT_CODE,
                                         ACCOUNT_NO
                                    FROM SGAS.STUD S2
                                   WHERE     S2.STUD_REF_NO != S.STUD_REF_NO
                                         AND S2.SORT_CODE = S.SORT_CODE
                                         AND S2.ACCOUNT_NO = S.ACCOUNT_NO)
                      AND ACCOUNT_NO != '12345678'
                      AND ROWNUM < 2;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  DBMS_OUTPUT.PUT_LINE (
                        'Created Case ID '
                     || v_studentsRec.case_id
                     || ' Cannot create Unique Case - Missing Data ');
            END;
         END IF;


         IF     v_studentsRec.new_student = 'N'
            AND v_studentsRec.case_id NOT IN (15, 31, 41, 57, 90)
         THEN
            BEGIN
               SELECT EMAIL_ADDR
                 INTO v_email
                 FROM SGAS.STUD
                WHERE STUD_REF_NO = v_stud_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_email := NULL;
            END;



            BEGIN
               SELECT PORTAL_USER_ID
                 INTO v_portal_user_id
                 FROM SGAS.STUD
                WHERE STUD_REF_NO = v_stud_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_portal_user_id := NULL;
            END;



            BEGIN
               SELECT SCOTTISH_CAND
                 INTO v_slc_ref_no
                 FROM SGAS.STUD
                WHERE STUD_REF_NO = v_stud_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_slc_ref_no := NULL;
            END;



            BEGIN
               SELECT FORENAMES
                 INTO v_forenames
                 FROM SGAS.STUD
                WHERE STUD_REF_NO = v_stud_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_forenames := 'FIRST NAME';
            END;



            BEGIN
               SELECT surname
                 INTO v_surname
                 FROM SGAS.STUD
                WHERE STUD_REF_NO = v_stud_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_forenames := 'SURNAME';
            END;



            BEGIN
               SELECT NI_NO
                 INTO v_nino
                 FROM SGAS.STUD
                WHERE STUD_REF_NO = v_stud_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_nino := NULL;
            END;
         END IF;

         IF     v_studentsRec.scheme_type = 'U'
            AND v_studentsRec.case_id != '182' --Set values for EDM complete and temp insert
         THEN
            v_document_type_code := 'SAS3_PDF';
            v_document_name := '3' || v_stud_ref_no || v_session_code;
            v_batch_code := 31;
         ELSIF     v_studentsRec.scheme_type = 'U'
               AND v_studentsRec.case_id = '182'
         THEN
            v_document_type_code := 'SAS3_PDF';
            v_document_name := '3' || v_stud_ref_no || v_session_code;
            v_batch_code := 36;
         ELSIF v_studentsRec.scheme_type = 'P'
         THEN
            v_document_type_code := 'SAS7_PDF';
            v_document_name := v_stud_ref_no || v_session_code || ':1';
            v_batch_code := 32;
         ELSIF v_studentsRec.scheme_type = 'B'
         THEN
            v_document_type_code := 'NMSB1_PDF';
            v_document_name := 'B' || v_stud_ref_no || v_session_code || ':1';
            v_batch_code := 33;
         END IF;



         --------------------------------------------------MAIN SECTION      ------CREATE THE RAW_DATA RECORD



         INSERT INTO EDM.RAW_DATA (OBJECT_ID,
                                   RAW_DATA_ID,
                                   BATCH_ID,
                                   ENVELOPE_ID,
                                   SUPPLEMENTARY_GRANTS,
                                   STUD_REF_NO,
                                   SCOTTISH_CAND,
                                   NI_NO,
                                   NI_NO_F,
                                   TITLE,
                                   SURNAME,
                                   FORENAMES,
                                   BIRTH_SURNAME,
                                   BIRTH_FORENAMES,
                                   DOB,
                                   DOB_F,
                                   DISTRICT_BIRTH_CERT_ISSUED,
                                   SEX,
                                   MARITAL_STATUS,
                                   MARRIAGE_DATE,
                                   HOME_HOUSE_NO_NAME,
                                   HOME_POST_CODE,
                                   HOME_ADDR_L1,
                                   HOME_ADDR_L2,
                                   HOME_ADDR_L3,
                                   HOME_ADDR_L4,
                                   HOME_TELE_NO,
                                   SORT_CODE,
                                   SORT_CODE_F,
                                   ACCOUNT_NO,
                                   ACCOUNT_NO_F,
                                   BIRTH_COUNTRY_CODE,
                                   BIRTH_COUNTRY_CODE_F,
                                   NATION_COUNTRY_CODE,
                                   NATION_COUNTRY_CODE_F,
                                   RESIDENCE_COUNTRY_CODE,
                                   RESIDENCE_COUNTRY_CODE_F,
                                   INST_NAME,
                                   INST_NAME_F,
                                   INST_CODE,
                                   CRSE_NAME,
                                   CRSE_NAME_F,
                                   CRSE_CODE,
                                   CRSE_YEAR_NO,
                                   FIRST_DEP_SURNAME,
                                   FIRST_DEP_FORENAMES,
                                   FIRST_DEP_DOB,
                                   FIRST_DEP_DOB_F,
                                   FIRST_DEP_REL_TYPE,
                                   FIRST_DEP_INCOME_CODE_1,
                                   FIRST_DEP_INCOME_CODE_1_F,
                                   FIRST_DEP_INCOME_AMOUNT_1,
                                   FIRST_DEP_INCOME_AMOUNT_1_F,
                                   FIRST_DEP_INCOME_CODE_2,
                                   FIRST_DEP_INCOME_CODE_2_F,
                                   FIRST_DEP_INCOME_AMOUNT_2,
                                   FIRST_DEP_INCOME_AMOUNT_2_F,
                                   FIRST_DEP_INCOME_CODE_3,
                                   FIRST_DEP_INCOME_CODE_3_F,
                                   FIRST_DEP_INCOME_AMOUNT_3,
                                   FIRST_DEP_INCOME_AMOUNT_3_F,
                                   SEC_DEP_SURNAME,
                                   SEC_DEP_FORENAMES,
                                   SEC_DEP_DOB,
                                   SEC_DEP_DOB_F,
                                   SEC_DEP_REL_TYPE,
                                   SEC_DEP_INCOME_CODE_1,
                                   SEC_DEP_INCOME_CODE_1_F,
                                   SEC_DEP_INCOME_AMOUNT_1,
                                   SEC_DEP_INCOME_AMOUNT_1_F,
                                   SEC_DEP_INCOME_CODE_2,
                                   SEC_DEP_INCOME_CODE_2_F,
                                   SEC_DEP_INCOME_AMOUNT_2,
                                   SEC_DEP_INCOME_AMOUNT_2_F,
                                   SEC_DEP_INCOME_CODE_3,
                                   SEC_DEP_INCOME_CODE_3_F,
                                   SEC_DEP_INCOME_AMOUNT_3,
                                   SEC_DEP_INCOME_AMOUNT_3_F,
                                   THIRD_DEP_SURNAME,
                                   THIRD_DEP_FORENAMES,
                                   THIRD_DEP_DOB,
                                   THIRD_DEP_DOB_F,
                                   THIRD_DEP_REL_TYPE,
                                   THIRD_DEP_INCOME_CODE_1,
                                   THIRD_DEP_INCOME_CODE_1_F,
                                   THIRD_DEP_INCOME_AMOUNT_1,
                                   THIRD_DEP_INCOME_AMOUNT_1_F,
                                   THIRD_DEP_INCOME_CODE_2,
                                   THIRD_DEP_INCOME_CODE_2_F,
                                   THIRD_DEP_INCOME_AMOUNT_2,
                                   THIRD_DEP_INCOME_AMOUNT_2_F,
                                   THIRD_DEP_INCOME_CODE_3,
                                   THIRD_DEP_INCOME_CODE_3_F,
                                   THIRD_DEP_INCOME_AMOUNT_3,
                                   THIRD_DEP_INCOME_AMOUNT_3_F,
                                   ADD_DEP_DETAILS,
                                   LPCG,
                                   TWO_HOMES_ALLOW,
                                   VAC_GRANT,
                                   NET_INCOME,
                                   NET_INCOME_F,
                                   PENSION_INCOME,
                                   PENSION_INCOME_F,
                                   TRUST_INCOME,
                                   TRUST_INCOME_F,
                                   AWARD_ORG,
                                   ANNUAL_VALUE,
                                   MAINTENANCE,
                                   FEES,
                                   LENGTH_OF_SUPPORT,
                                   SUPPORT_START_DATE,
                                   APP_FORM_SIG,
                                   MAX_LOAN_REQUESTED,
                                   LOAN_REQUEST,
                                   LOAN_REQUEST_F,
                                   CONT1_FORENAME,
                                   CONT1_SURNAME,
                                   CONT1_NAME,
                                   CONT1_REL_CODE,
                                   CONT1_HOUSE_NO_NM,
                                   CONT1_POSTCODE,
                                   CONT1_ADDR1,
                                   CONT1_ADDR2,
                                   CONT1_ADDR3,
                                   CONT1_ADDR4,
                                   CONT1_TEL_NO,
                                   CONT2_FORENAME,
                                   CONT2_SURNAME,
                                   CONT2_NAME,
                                   CONT2_HOUSE_NO_NM,
                                   CONT2_POSTCODE,
                                   CONT2_ADDR1,
                                   CONT2_ADDR2,
                                   CONT2_ADDR3,
                                   CONT2_ADDR4,
                                   CONT2_TEL_NO,
                                   BANKRUPT_FLAG,
                                   TERM_HOUSE_NO_NAME,
                                   TERM_POST_CODE,
                                   TERM_ADDR_L1,
                                   TERM_ADDR_L2,
                                   TERM_ADDR_L3,
                                   TERM_ADDR_L4,
                                   SLC_CORRES_DEST,
                                   LOAN_SIGNATURE,
                                   LOAN_DECLARATION_DATE,
                                   LOAN_DECLARATION_DATE_F,
                                   BEN1_NI_NO,
                                   BEN1_NI_NO_F,
                                   BEN1_TITLE,
                                   BEN1_SURNAME,
                                   BEN1_FORENAMES,
                                   BEN1_REL_TYPE,
                                   BEN1_HOUSE_NO_NAME,
                                   BEN1_POSTCODE,
                                   BEN1_ADDR1,
                                   BEN1_ADDR2,
                                   BEN1_ADDR3,
                                   BEN1_ADDR4,
                                   BEN1_EMP_STATUS,
                                   BEN2_NI_NO,
                                   BEN2_NI_NO_F,
                                   BEN2_TITLE,
                                   BEN2_SURNAME,
                                   BEN2_FORENAMES,
                                   BEN2_REL_TYPE,
                                   BEN2_HOUSE_NO_NAME,
                                   BEN2_POSTCODE,
                                   BEN2_ADDR1,
                                   BEN2_ADDR2,
                                   BEN2_ADDR3,
                                   BEN2_ADDR4,
                                   BEN2_EMP_STATUS,
                                   JA_CASE,
                                   BEN1_PAYE,
                                   BEN1_PAYE_F,
                                   BEN2_PAYE,
                                   BEN2_PAYE_F,
                                   BEN1_SELF_EMPLOYMENT,
                                   BEN1_SELF_EMPLOYMENT_F,
                                   BEN2_SELF_EMPLOYMENT,
                                   BEN2_SELF_EMPLOYMENT_F,
                                   BEN1_PROPERTY,
                                   BEN1_PROPERTY_F,
                                   BEN2_PROPERTY,
                                   BEN2_PROPERTY_F,
                                   BEN1_PENSIONS,
                                   BEN1_PENSIONS_F,
                                   BEN2_PENSIONS,
                                   BEN2_PENSIONS_F,
                                   BEN1_BENEFITS,
                                   BEN1_BENEFITS_F,
                                   BEN2_BENEFITS,
                                   BEN2_BENEFITS_F,
                                   BEN1_NAT_SAVINGS,
                                   BEN1_NAT_SAVINGS_F,
                                   BEN2_NAT_SAVINGS,
                                   BEN2_NAT_SAVINGS_F,
                                   BEN1_INTEREST,
                                   BEN1_INTEREST_F,
                                   BEN2_INTEREST,
                                   BEN2_INTEREST_F,
                                   BEN1_DIVIDEND,
                                   BEN1_DIVIDEND_F,
                                   BEN2_DIVIDEND,
                                   BEN2_DIVIDEND_F,
                                   BEN1_OTHER_INC,
                                   BEN1_OTHER_INC_F,
                                   BEN2_OTHER_INC,
                                   BEN2_OTHER_INC_F,
                                   BEN1_SUPERANN,
                                   BEN1_SUPERANN_F,
                                   BEN2_SUPERANN,
                                   BEN2_SUPERANN_F,
                                   BEN1_RAP,
                                   BEN1_RAP_F,
                                   BEN2_RAP,
                                   BEN2_RAP_F,
                                   BEN1_OTHER_DED,
                                   BEN1_OTHER_DED_F,
                                   BEN2_OTHER_DED,
                                   BEN2_OTHER_DED_F,
                                   BEN1_FIRST_DEP_DOB,
                                   BEN1_FIRST_DEP_DOB_F,
                                   BEN1_SEC_DEP_DOB,
                                   BEN1_SEC_DEP_DOB_F,
                                   BEN1_THIRD_DEP_DOB,
                                   BEN1_THIRD_DEP_DOB_F,
                                   DOMESTIC_HELP,
                                   BEN_DEC_SIG,
                                   EXTRA_NOTES,
                                   OUT_UK,
                                   FAST_TRACK,
                                   RES_QUERY,
                                   ARA_SENT,
                                   BIRTH_CERT_FLAG,
                                   OFFER_FLAG,
                                   REPEAT_YEAR,
                                   DATE_APPLIC_RECEIVED,
                                   EMP_LOGIN,
                                   APP_FORM_SIG_DATE,
                                   PGCE,
                                   DSA,
                                   TOT_TRAV_AMOUNT_CLAIMED,
                                   TOT_TRAV_AMOUNT_CLAIMED_F,
                                   MOBILE_TEL_NO,
                                   HOME_ADDR_MAIL_SORT,
                                   BEN1_MAIL_SORT,
                                   BEN2_MAIL_SORT,
                                   EMAIL_ADDR,
                                   WEB_USER_ID,
                                   BANK_VALIDATE,
                                   EMAIL_ADDR_F,
                                   TERM_TIME_RESIDENCE,
                                   TERM_TIME_RESIDENCE_F,
                                   RELEVANT_DATE,
                                   RELEVANT_DATE_F,
                                   ORDIN_RES_UK_3_YEARS,
                                   ORDIN_RES_UK_3_YEARS_F,
                                   ORDIN_RES_SCOT_REL_DATE,
                                   ORDIN_RES_SCOT_REL_DATE_F,
                                   IN_EDUC_SINCE_LEAVE_SCHOOL,
                                   IN_EDUC_SINCE_LEAVE_SCHOOL_F,
                                   EU_GRADUATE,
                                   EU_GRADUATE_F,
                                   STUDY_ABROAD,
                                   STUDY_ABROAD_F,
                                   PLACEMENT_YEAR,
                                   PLACEMENT_YEAR_F,
                                   SECONDARY_OR_PRIMARY_ED,
                                   SECONDARY_OR_PRIMARY_ED_F,
                                   SECONDARY_SUBJECT,
                                   SECONDARY_SUBJECT_F,
                                   EXEMPT_FROM_PARENT_CONTRIB,
                                   EXEMPT_FROM_PARENT_CONTRIB_F,
                                   PLAN_TO_WORK_OUTSIDE_UK,
                                   PLAN_TO_WORK_OUTSIDE_UK_F,
                                   BEN1_FIRST_DEP_LAST_NAME,
                                   BEN1_FIRST_DEP_LAST_NAME_F,
                                   BEN1_FIRST_DEP_FIRST_NAME,
                                   BEN1_FIRST_DEP_FIRST_NAME_F,
                                   BEN1_FIRST_DEP_LEAVE_SCHOOL,
                                   BEN1_FIRST_DEP_LEAVE_SCHOOL_F,
                                   BEN1_SEC_DEP_LAST_NAME,
                                   BEN1_SEC_DEP_LAST_NAME_F,
                                   BEN1_SEC_DEP_FIRST_NAME,
                                   BEN1_SEC_DEP_FIRST_NAME_F,
                                   BEN1_SEC_DEP_LEAVE_SCHOOL,
                                   BEN1_SEC_DEP_LEAVE_SCHOOL_F,
                                   BEN1_THIRD_DEP_LAST_NAME,
                                   BEN1_THIRD_DEP_LAST_NAME_F,
                                   BEN1_THIRD_DEP_FIRST_NAME,
                                   BEN1_THIRD_DEP_FIRST_NAME_F,
                                   BEN1_THIRD_DEP_LEAVE_SCHOOL,
                                   BEN1_THIRD_DEP_LEAVE_SCHOOL_F,
                                   EU_STUDENT,
                                   NOS_YEARS_COURSE_TAKES,
                                   ORD_RES_SCOTLAND_WEB,
                                   ORD_RES_UK_WEB,
                                   MAX_FEE_LOAN,
                                   FEE_LOAN_AMOUNT,
                                   FEE_LOAN_CHARGED_AMOUNT,
                                   DEP_GRANT,
                                   LPG,
                                   MORE_THAN_3_BEN_DEPS,
                                   MIGRANT_WORKER,
                                   SPOUSE_OF_MIGRANT_WORKER,
                                   PLAN_TO_WORK_DURING_CRSE,
                                   STUDY_FT_OR_PT,
                                   STUDY_FT_OR_PT_F,
                                   BEN1_WORKING_TAX_CREDIT,
                                   BEN1_EMP_SUPPORT_ALLOWANCE,
                                   BEN1_INCAPACITY_BENEFIT,
                                   BEN1_INCOME_SUPPORT,
                                   BEN1_INVALIDITY_BENEFIT,
                                   BEN1_JOBSEEKERS_ALLOWANCE,
                                   BEN1_MAINTENANCE_PAYMENT,
                                   BEN2_WORKING_TAX_CREDIT,
                                   BEN2_EMP_SUPPORT_ALLOWANCE,
                                   BEN2_INCAPACITY_BENEFIT,
                                   BEN2_INCOME_SUPPORT,
                                   BEN2_INVALIDITY_BENEFIT,
                                   BEN2_JOBSEEKERS_ALLOWANCE,
                                   BEN2_MAINTENANCE_PAYMENT,
                                   STUD_INCOME,
                                   AB36,
                                   SKILLS_DEV_DATA_SHARE,
                                   RESIDENCE_IND,
                                   WORKING_TAX_CREDIT_IND,
                                   EMPLOYMENT_SUPPORT_ALLOWANCE,
                                   INCAPACITY_BENEFIT,
                                   INCOME_SUPPORT,
                                   INVALIDITY_BENEFIT,
                                   JOBSEEKERS_ALLOWANCE,
                                   UK_PASSPORT,
                                   PASSPORT_NUMBER,
                                   PASSPORT_FIRST_NAMES,
                                   PASSPORT_SURNAME,
                                   PASSPORT_ISSUE_DATE,
                                   PASSPORT_EXPIRY_DATE,
                                   UK_BIRTH_CNTRY_CODE,
                                   TUITION_FEES,
                                   MAINTENANCE_GRANT,
                                   BURSARY_ONLY,
                                   INCOME_ASSESSED_LOAN,
                                   NON_INCOME_ASSESSED_LOAN,
                                   YSB,
                                   YSB_OUTSIDE_SCOTLAND,
                                   HEALTHCARE_FUNDING,
                                   CLAIMING_DSA,
                                   INSIDE_OUTSIDE_SCOTLAND,
                                   INSCOT_YEAR,
                                   CONSENT_FROM_STUDENT,
                                   CONSENT_FROM_FATHER,
                                   CONSENT_FROM_MOTHER,
                                   CONSENT_FROM_HUSBAND_WIFE,
                                   STUD_INCOME_AMT1,
                                   STUD_INCOME_TYPE1,
                                   STUD_INCOME_AMT2,
                                   STUD_INCOME_TYPE2,
                                   STUD_INCOME_AMT3,
                                   STUD_INCOME_TYPE3,
                                   STUD_INCOME_AMT4,
                                   STUD_INCOME_TYPE4,
                                   STUD_INCOME_AMT5,
                                   STUD_INCOME_TYPE5,
                                   STUD_INCOME_AMT6,
                                   STUD_INCOME_TYPE6,
                                   REASON_NO_INCOME_BEN1,
                                   REASON_NO_INCOME_BEN2,
                                   HEI_CONSENT,
                                   CARE_LEAVER,
                                   DUAL_NATIONALITY,
                                   BEN1_HEI_CONSENT,
                                   BEN2_HEI_CONSENT,
                                   BEN1_AB36,
                                   BEN2_AB36,
                                   ONLY_ONE_BEN,
                                   REASON_FOR_ONE_BEN_ID,
                                   PSAS_PT,
                                   BEN1_OTHER_INC_DETAILS,
                                   BEN2_OTHER_INC_DETAILS,
                                   CONT1_CONSENT,
                                   CONT2_CONSENT,
                                   INTERRUPTION_FROM_STUDY,
                                   IS_INDEPENDENT,
                                   RESIDENCY_CATEGORY,
                                   BEN1_CONSENT_TO_SHARE_STUDENT,
                                   BEN2_CONSENT_TO_SHARE_STUDENT,
                                   INDEPENDENT,
                                   ORPHAN,
                                   OVER_25,
                                   CARE_EXP_FOSTER,
                                   CARE_EXP_RES,
                                   CARE_EXP_KINSHIP_LA,
                                   CARE_EXP_KINSHIP_NO_LA,
                                   CARE_EXP_HOME,
                                   CARE_EXP_OTHER,
                                   CARE_EXP_OTHER_DETAILS,
                                   CARE_EXP_START_AGE,
                                   CARE_EXP_END_AGE,
                                   START_DATE_ABROAD,
                                   END_DATE_ABROAD,
                                   BEN1_EMAIL_ADDR,
                                   BEN2_EMAIL_ADDR,
                                   PG_ED_PSYCH_GRANT,
                                   PG_ED_PSYCH_FEES,
                                   PG_ED_PSYCH_QEPS,
                                   PG_ED_PSYCH_DECLARATION,
                                   ESTRANGED,
                                   CONTINUINGTHREEYEARSORMORE,
                                   COMPLEX_RESIDENCY,
                                   EU_SETTLED_STATUS,
                                   EU_SETTLED_STATUS_CONFIRMED,
                                   TOP_OPTION,
                                   EU_RESIDENCE_TYPE)
              VALUES (v_temp,
                      v_raw_data_id,
                      NULL,
                      NULL,
                      v_studentsRec.SUPPLEMENTARY_GRANTS,
                      v_stud_ref_no,
                      v_slc_Ref_no,
                      v_nino,
                      v_studentsRec.NI_NO_F,
                      v_studentsRec.TITLE,
                      v_surname,
                      v_forenames,
                      v_studentsRec.BIRTH_SURNAME,
                      v_studentsRec.BIRTH_FORENAMES,
                      v_dob,
                      v_studentsRec.DOB_F,
                      v_studentsRec.DISTRICT_BIRTH_CERT_ISSUED,
                      v_studentsRec.SEX,
                      v_studentsRec.MARITAL_STATUS,
                      v_studentsRec.MARRIAGE_DATE,
                      v_studentsRec.HOME_HOUSE_NO_NAME,
                      v_studentsRec.HOME_POST_CODE,
                      v_studentsRec.HOME_ADDR_L1,
                      v_studentsRec.HOME_ADDR_L2,
                      v_studentsRec.HOME_ADDR_L3,
                      v_studentsRec.HOME_ADDR_L4,
                      v_studentsRec.HOME_TELE_NO,
                      v_sort_code,
                      v_studentsRec.SORT_CODE_F,
                      v_account_no,
                      v_studentsRec.ACCOUNT_NO_F,
                      v_studentsRec.BIRTH_COUNTRY_CODE,
                      v_studentsRec.BIRTH_COUNTRY_CODE_F,
                      v_studentsRec.NATION_COUNTRY_CODE,
                      v_studentsRec.NATION_COUNTRY_CODE_F,
                      v_studentsRec.RESIDENCE_COUNTRY_CODE,
                      v_studentsRec.RESIDENCE_COUNTRY_CODE_F,
                      v_studentsRec.INST_NAME,
                      v_studentsRec.INST_NAME_F,
                      v_studentsRec.INST_CODE,
                      v_studentsRec.CRSE_NAME,
                      v_studentsRec.CRSE_NAME_F,
                      v_studentsRec.CRSE_CODE,
                      v_studentsRec.CRSE_YEAR_NO,
                      v_studentsRec.FIRST_DEP_SURNAME,
                      v_studentsRec.FIRST_DEP_FORENAMES,
                      v_studentsRec.FIRST_DEP_DOB,
                      v_studentsRec.FIRST_DEP_DOB_F,
                      v_studentsRec.FIRST_DEP_REL_TYPE,
                      v_studentsRec.FIRST_DEP_INCOME_CODE_1,
                      v_studentsRec.FIRST_DEP_INCOME_CODE_1_F,
                      v_studentsRec.FIRST_DEP_INCOME_AMOUNT_1,
                      v_studentsRec.FIRST_DEP_INCOME_AMOUNT_1_F,
                      v_studentsRec.FIRST_DEP_INCOME_CODE_2,
                      v_studentsRec.FIRST_DEP_INCOME_CODE_2_F,
                      v_studentsRec.FIRST_DEP_INCOME_AMOUNT_2,
                      v_studentsRec.FIRST_DEP_INCOME_AMOUNT_2_F,
                      v_studentsRec.FIRST_DEP_INCOME_CODE_3,
                      v_studentsRec.FIRST_DEP_INCOME_CODE_3_F,
                      v_studentsRec.FIRST_DEP_INCOME_AMOUNT_3,
                      v_studentsRec.FIRST_DEP_INCOME_AMOUNT_3_F,
                      v_studentsRec.SEC_DEP_SURNAME,
                      v_studentsRec.SEC_DEP_FORENAMES,
                      v_studentsRec.SEC_DEP_DOB,
                      v_studentsRec.SEC_DEP_DOB_F,
                      v_studentsRec.SEC_DEP_REL_TYPE,
                      v_studentsRec.SEC_DEP_INCOME_CODE_1,
                      v_studentsRec.SEC_DEP_INCOME_CODE_1_F,
                      v_studentsRec.SEC_DEP_INCOME_AMOUNT_1,
                      v_studentsRec.SEC_DEP_INCOME_AMOUNT_1_F,
                      v_studentsRec.SEC_DEP_INCOME_CODE_2,
                      v_studentsRec.SEC_DEP_INCOME_CODE_2_F,
                      v_studentsRec.SEC_DEP_INCOME_AMOUNT_2,
                      v_studentsRec.SEC_DEP_INCOME_AMOUNT_2_F,
                      v_studentsRec.SEC_DEP_INCOME_CODE_3,
                      v_studentsRec.SEC_DEP_INCOME_CODE_3_F,
                      v_studentsRec.SEC_DEP_INCOME_AMOUNT_3,
                      v_studentsRec.SEC_DEP_INCOME_AMOUNT_3_F,
                      v_studentsRec.THIRD_DEP_SURNAME,
                      v_studentsRec.THIRD_DEP_FORENAMES,
                      v_studentsRec.THIRD_DEP_DOB,
                      v_studentsRec.THIRD_DEP_DOB_F,
                      v_studentsRec.THIRD_DEP_REL_TYPE,
                      v_studentsRec.THIRD_DEP_INCOME_CODE_1,
                      v_studentsRec.THIRD_DEP_INCOME_CODE_1_F,
                      v_studentsRec.THIRD_DEP_INCOME_AMOUNT_1,
                      v_studentsRec.THIRD_DEP_INCOME_AMOUNT_1_F,
                      v_studentsRec.THIRD_DEP_INCOME_CODE_2,
                      v_studentsRec.THIRD_DEP_INCOME_CODE_2_F,
                      v_studentsRec.THIRD_DEP_INCOME_AMOUNT_2,
                      v_studentsRec.THIRD_DEP_INCOME_AMOUNT_2_F,
                      v_studentsRec.THIRD_DEP_INCOME_CODE_3,
                      v_studentsRec.THIRD_DEP_INCOME_CODE_3_F,
                      v_studentsRec.THIRD_DEP_INCOME_AMOUNT_3,
                      v_studentsRec.THIRD_DEP_INCOME_AMOUNT_3_F,
                      v_studentsRec.ADD_DEP_DETAILS,
                      v_studentsRec.LPCG,
                      v_studentsRec.TWO_HOMES_ALLOW,
                      v_studentsRec.VAC_GRANT,
                      v_studentsRec.NET_INCOME,
                      v_studentsRec.NET_INCOME_F,
                      v_studentsRec.PENSION_INCOME,
                      v_studentsRec.PENSION_INCOME_F,
                      v_studentsRec.TRUST_INCOME,
                      v_studentsRec.TRUST_INCOME_F,
                      v_studentsRec.AWARD_ORG,
                      v_studentsRec.ANNUAL_VALUE,
                      v_studentsRec.MAINTENANCE,
                      v_studentsRec.FEES,
                      v_studentsRec.LENGTH_OF_SUPPORT,
                      v_studentsRec.SUPPORT_START_DATE,
                      v_studentsRec.APP_FORM_SIG,
                      v_studentsRec.MAX_LOAN_REQUESTED,
                      v_studentsRec.LOAN_REQUEST,
                      v_studentsRec.LOAN_REQUEST_F,
                      v_studentsRec.CONT1_FORENAME,
                      v_studentsRec.CONT1_SURNAME,
                      v_studentsRec.CONT1_NAME,
                      v_studentsRec.CONT1_REL_CODE,
                      v_studentsRec.CONT1_HOUSE_NO_NM,
                      v_studentsRec.CONT1_POSTCODE,
                      v_studentsRec.CONT1_ADDR1,
                      v_studentsRec.CONT1_ADDR2,
                      v_studentsRec.CONT1_ADDR3,
                      v_studentsRec.CONT1_ADDR4,
                      v_studentsRec.CONT1_TEL_NO,
                      v_studentsRec.CONT2_FORENAME,
                      v_studentsRec.CONT2_SURNAME,
                      v_studentsRec.CONT2_NAME,
                      v_studentsRec.CONT2_HOUSE_NO_NM,
                      v_studentsRec.CONT2_POSTCODE,
                      v_studentsRec.CONT2_ADDR1,
                      v_studentsRec.CONT2_ADDR2,
                      v_studentsRec.CONT2_ADDR3,
                      v_studentsRec.CONT2_ADDR4,
                      v_studentsRec.CONT2_TEL_NO,
                      v_studentsRec.BANKRUPT_FLAG,
                      v_studentsRec.TERM_HOUSE_NO_NAME,
                      v_studentsRec.TERM_POST_CODE,
                      v_studentsRec.TERM_ADDR_L1,
                      v_studentsRec.TERM_ADDR_L2,
                      v_studentsRec.TERM_ADDR_L3,
                      v_studentsRec.TERM_ADDR_L4,
                      v_studentsRec.SLC_CORRES_DEST,
                      v_studentsRec.LOAN_SIGNATURE,
                      v_studentsRec.LOAN_DECLARATION_DATE,
                      v_studentsRec.LOAN_DECLARATION_DATE_F,
                      v_studentsRec.BEN1_NI_NO,
                      v_studentsRec.BEN1_NI_NO_F,
                      v_studentsRec.BEN1_TITLE,
                      v_studentsRec.BEN1_SURNAME,
                      v_studentsRec.BEN1_FORENAMES,
                      v_studentsRec.BEN1_REL_TYPE,
                      v_studentsRec.BEN1_HOUSE_NO_NAME,
                      v_studentsRec.BEN1_POSTCODE,
                      v_studentsRec.BEN1_ADDR1,
                      v_studentsRec.BEN1_ADDR2,
                      v_studentsRec.BEN1_ADDR3,
                      v_studentsRec.BEN1_ADDR4,
                      v_studentsRec.BEN1_EMP_STATUS,
                      v_studentsRec.BEN2_NI_NO,
                      v_studentsRec.BEN2_NI_NO_F,
                      v_studentsRec.BEN2_TITLE,
                      v_studentsRec.BEN2_SURNAME,
                      v_studentsRec.BEN2_FORENAMES,
                      v_studentsRec.BEN2_REL_TYPE,
                      v_studentsRec.BEN2_HOUSE_NO_NAME,
                      v_studentsRec.BEN2_POSTCODE,
                      v_studentsRec.BEN2_ADDR1,
                      v_studentsRec.BEN2_ADDR2,
                      v_studentsRec.BEN2_ADDR3,
                      v_studentsRec.BEN2_ADDR4,
                      v_studentsRec.BEN2_EMP_STATUS,
                      v_studentsRec.JA_CASE,
                      v_studentsRec.BEN1_PAYE,
                      v_studentsRec.BEN1_PAYE_F,
                      v_studentsRec.BEN2_PAYE,
                      v_studentsRec.BEN2_PAYE_F,
                      v_studentsRec.BEN1_SELF_EMPLOYMENT,
                      v_studentsRec.BEN1_SELF_EMPLOYMENT_F,
                      v_studentsRec.BEN2_SELF_EMPLOYMENT,
                      v_studentsRec.BEN2_SELF_EMPLOYMENT_F,
                      v_studentsRec.BEN1_PROPERTY,
                      v_studentsRec.BEN1_PROPERTY_F,
                      v_studentsRec.BEN2_PROPERTY,
                      v_studentsRec.BEN2_PROPERTY_F,
                      v_studentsRec.BEN1_PENSIONS,
                      v_studentsRec.BEN1_PENSIONS_F,
                      v_studentsRec.BEN2_PENSIONS,
                      v_studentsRec.BEN2_PENSIONS_F,
                      v_studentsRec.BEN1_BENEFITS,
                      v_studentsRec.BEN1_BENEFITS_F,
                      v_studentsRec.BEN2_BENEFITS,
                      v_studentsRec.BEN2_BENEFITS_F,
                      v_studentsRec.BEN1_NAT_SAVINGS,
                      v_studentsRec.BEN1_NAT_SAVINGS_F,
                      v_studentsRec.BEN2_NAT_SAVINGS,
                      v_studentsRec.BEN2_NAT_SAVINGS_F,
                      v_studentsRec.BEN1_INTEREST,
                      v_studentsRec.BEN1_INTEREST_F,
                      v_studentsRec.BEN2_INTEREST,
                      v_studentsRec.BEN2_INTEREST_F,
                      v_studentsRec.BEN1_DIVIDEND,
                      v_studentsRec.BEN1_DIVIDEND_F,
                      v_studentsRec.BEN2_DIVIDEND,
                      v_studentsRec.BEN2_DIVIDEND_F,
                      v_studentsRec.BEN1_OTHER_INC,
                      v_studentsRec.BEN1_OTHER_INC_F,
                      v_studentsRec.BEN2_OTHER_INC,
                      v_studentsRec.BEN2_OTHER_INC_F,
                      v_studentsRec.BEN1_SUPERANN,
                      v_studentsRec.BEN1_SUPERANN_F,
                      v_studentsRec.BEN2_SUPERANN,
                      v_studentsRec.BEN2_SUPERANN_F,
                      v_studentsRec.BEN1_RAP,
                      v_studentsRec.BEN1_RAP_F,
                      v_studentsRec.BEN2_RAP,
                      v_studentsRec.BEN2_RAP_F,
                      v_studentsRec.BEN1_OTHER_DED,
                      v_studentsRec.BEN1_OTHER_DED_F,
                      v_studentsRec.BEN2_OTHER_DED,
                      v_studentsRec.BEN2_OTHER_DED_F,
                      v_studentsRec.BEN1_FIRST_DEP_DOB,
                      v_studentsRec.BEN1_FIRST_DEP_DOB_F,
                      v_studentsRec.BEN1_SEC_DEP_DOB,
                      v_studentsRec.BEN1_SEC_DEP_DOB_F,
                      v_studentsRec.BEN1_THIRD_DEP_DOB,
                      v_studentsRec.BEN1_THIRD_DEP_DOB_F,
                      v_studentsRec.DOMESTIC_HELP,
                      v_studentsRec.BEN_DEC_SIG,
                      v_studentsRec.EXTRA_NOTES,
                      v_studentsRec.OUT_UK,
                      v_studentsRec.FAST_TRACK,
                      v_studentsRec.RES_QUERY,
                      v_studentsRec.ARA_SENT,
                      v_studentsRec.BIRTH_CERT_FLAG,
                      v_studentsRec.OFFER_FLAG,
                      v_studentsRec.REPEAT_YEAR,
                      v_date_app_rec,
                      v_studentsRec.EMP_LOGIN,
                      v_studentsRec.APP_FORM_SIG_DATE,
                      v_studentsRec.PGCE,
                      v_studentsRec.DSA,
                      v_studentsRec.TOT_TRAV_AMOUNT_CLAIMED,
                      v_studentsRec.TOT_TRAV_AMOUNT_CLAIMED_F,
                      v_studentsRec.MOBILE_TEL_NO,
                      v_studentsRec.HOME_ADDR_MAIL_SORT,
                      v_studentsRec.BEN1_MAIL_SORT,
                      v_studentsRec.BEN2_MAIL_SORT,
                      v_email,
                      v_portal_user_id,
                      v_studentsRec.BANK_VALIDATE,
                      v_studentsRec.EMAIL_ADDR_F,
                      v_studentsRec.TERM_TIME_RESIDENCE,
                      v_studentsRec.TERM_TIME_RESIDENCE_F,
                      v_studentsRec.RELEVANT_DATE,
                      v_studentsRec.RELEVANT_DATE_F,
                      v_studentsRec.ORDIN_RES_UK_3_YEARS,
                      v_studentsRec.ORDIN_RES_UK_3_YEARS_F,
                      v_studentsRec.ORDIN_RES_SCOT_REL_DATE,
                      v_studentsRec.ORDIN_RES_SCOT_REL_DATE_F,
                      v_studentsRec.IN_EDUC_SINCE_LEAVE_SCHOOL,
                      v_studentsRec.IN_EDUC_SINCE_LEAVE_SCHOOL_F,
                      v_studentsRec.EU_GRADUATE,
                      v_studentsRec.EU_GRADUATE_F,
                      v_studentsRec.STUDY_ABROAD,
                      v_studentsRec.STUDY_ABROAD_F,
                      v_studentsRec.PLACEMENT_YEAR,
                      v_studentsRec.PLACEMENT_YEAR_F,
                      v_studentsRec.SECONDARY_OR_PRIMARY_ED,
                      v_studentsRec.SECONDARY_OR_PRIMARY_ED_F,
                      v_studentsRec.SECONDARY_SUBJECT,
                      v_studentsRec.SECONDARY_SUBJECT_F,
                      v_studentsRec.EXEMPT_FROM_PARENT_CONTRIB,
                      v_studentsRec.EXEMPT_FROM_PARENT_CONTRIB_F,
                      v_studentsRec.PLAN_TO_WORK_OUTSIDE_UK,
                      v_studentsRec.PLAN_TO_WORK_OUTSIDE_UK_F,
                      v_studentsRec.BEN1_FIRST_DEP_LAST_NAME,
                      v_studentsRec.BEN1_FIRST_DEP_LAST_NAME_F,
                      v_studentsRec.BEN1_FIRST_DEP_FIRST_NAME,
                      v_studentsRec.BEN1_FIRST_DEP_FIRST_NAME_F,
                      v_studentsRec.BEN1_FIRST_DEP_LEAVE_SCHOOL,
                      v_studentsRec.BEN1_FIRST_DEP_LEAVE_SCHOOL_F,
                      v_studentsRec.BEN1_SEC_DEP_LAST_NAME,
                      v_studentsRec.BEN1_SEC_DEP_LAST_NAME_F,
                      v_studentsRec.BEN1_SEC_DEP_FIRST_NAME,
                      v_studentsRec.BEN1_SEC_DEP_FIRST_NAME_F,
                      v_studentsRec.BEN1_SEC_DEP_LEAVE_SCHOOL,
                      v_studentsRec.BEN1_SEC_DEP_LEAVE_SCHOOL_F,
                      v_studentsRec.BEN1_THIRD_DEP_LAST_NAME,
                      v_studentsRec.BEN1_THIRD_DEP_LAST_NAME_F,
                      v_studentsRec.BEN1_THIRD_DEP_FIRST_NAME,
                      v_studentsRec.BEN1_THIRD_DEP_FIRST_NAME_F,
                      v_studentsRec.BEN1_THIRD_DEP_LEAVE_SCHOOL,
                      v_studentsRec.BEN1_THIRD_DEP_LEAVE_SCHOOL_F,
                      v_studentsRec.EU_STUDENT,
                      v_studentsRec.NOS_YEARS_COURSE_TAKES,
                      v_studentsRec.ORD_RES_SCOTLAND_WEB,
                      v_studentsRec.ORD_RES_UK_WEB,
                      v_studentsRec.MAX_FEE_LOAN,
                      v_studentsRec.FEE_LOAN_AMOUNT,
                      v_studentsRec.FEE_LOAN_CHARGED_AMOUNT,
                      v_studentsRec.DEP_GRANT,
                      v_studentsRec.LPG,
                      v_studentsRec.MORE_THAN_3_BEN_DEPS,
                      v_studentsRec.MIGRANT_WORKER,
                      v_studentsRec.SPOUSE_OF_MIGRANT_WORKER,
                      v_studentsRec.PLAN_TO_WORK_DURING_CRSE,
                      v_studentsRec.STUDY_FT_OR_PT,
                      v_studentsRec.STUDY_FT_OR_PT_F,
                      v_studentsRec.BEN1_WORKING_TAX_CREDIT,
                      v_studentsRec.BEN1_EMP_SUPPORT_ALLOWANCE,
                      v_studentsRec.BEN1_INCAPACITY_BENEFIT,
                      v_studentsRec.BEN1_INCOME_SUPPORT,
                      v_studentsRec.BEN1_INVALIDITY_BENEFIT,
                      v_studentsRec.BEN1_JOBSEEKERS_ALLOWANCE,
                      v_studentsRec.BEN1_MAINTENANCE_PAYMENT,
                      v_studentsRec.BEN2_WORKING_TAX_CREDIT,
                      v_studentsRec.BEN2_EMP_SUPPORT_ALLOWANCE,
                      v_studentsRec.BEN2_INCAPACITY_BENEFIT,
                      v_studentsRec.BEN2_INCOME_SUPPORT,
                      v_studentsRec.BEN2_INVALIDITY_BENEFIT,
                      v_studentsRec.BEN2_JOBSEEKERS_ALLOWANCE,
                      v_studentsRec.BEN2_MAINTENANCE_PAYMENT,
                      v_studentsRec.STUD_INCOME,
                      v_studentsRec.AB36,
                      v_studentsRec.SKILLS_DEV_DATA_SHARE,
                      v_studentsRec.RESIDENCE_IND,
                      v_studentsRec.WORKING_TAX_CREDIT_IND,
                      v_studentsRec.EMPLOYMENT_SUPPORT_ALLOWANCE,
                      v_studentsRec.INCAPACITY_BENEFIT,
                      v_studentsRec.INCOME_SUPPORT,
                      v_studentsRec.INVALIDITY_BENEFIT,
                      v_studentsRec.JOBSEEKERS_ALLOWANCE,
                      v_studentsRec.UK_PASSPORT,
                      v_studentsRec.PASSPORT_NUMBER,
                      v_studentsRec.PASSPORT_FIRST_NAMES,
                      v_studentsRec.PASSPORT_SURNAME,
                      v_studentsRec.PASSPORT_ISSUE_DATE,
                      v_studentsRec.PASSPORT_EXPIRY_DATE,
                      v_studentsRec.UK_BIRTH_CNTRY_CODE,
                      v_studentsRec.TUITION_FEES,
                      v_studentsRec.MAINTENANCE_GRANT,
                      v_studentsRec.BURSARY_ONLY,
                      v_studentsRec.INCOME_ASSESSED_LOAN,
                      v_studentsRec.NON_INCOME_ASSESSED_LOAN,
                      v_studentsRec.YSB,
                      v_studentsRec.YSB_OUTSIDE_SCOTLAND,
                      v_studentsRec.HEALTHCARE_FUNDING,
                      v_studentsRec.CLAIMING_DSA,
                      v_studentsRec.INSIDE_OUTSIDE_SCOTLAND,
                      v_studentsRec.INSCOT_YEAR,
                      v_studentsRec.CONSENT_FROM_STUDENT,
                      v_studentsRec.CONSENT_FROM_FATHER,
                      v_studentsRec.CONSENT_FROM_MOTHER,
                      v_studentsRec.CONSENT_FROM_HUSBAND_WIFE,
                      v_studentsRec.STUD_INCOME_AMT1,
                      v_studentsRec.STUD_INCOME_TYPE1,
                      v_studentsRec.STUD_INCOME_AMT2,
                      v_studentsRec.STUD_INCOME_TYPE2,
                      v_studentsRec.STUD_INCOME_AMT3,
                      v_studentsRec.STUD_INCOME_TYPE3,
                      v_studentsRec.STUD_INCOME_AMT4,
                      v_studentsRec.STUD_INCOME_TYPE4,
                      v_studentsRec.STUD_INCOME_AMT5,
                      v_studentsRec.STUD_INCOME_TYPE5,
                      v_studentsRec.STUD_INCOME_AMT6,
                      v_studentsRec.STUD_INCOME_TYPE6,
                      v_studentsRec.REASON_NO_INCOME_BEN1,
                      v_studentsRec.REASON_NO_INCOME_BEN2,
                      v_studentsRec.HEI_CONSENT,
                      v_studentsRec.CARE_LEAVER,
                      v_studentsRec.DUAL_NATIONALITY,
                      v_studentsRec.BEN1_HEI_CONSENT,
                      v_studentsRec.BEN2_HEI_CONSENT,
                      v_studentsRec.BEN1_AB36,
                      v_studentsRec.BEN2_AB36,
                      v_studentsRec.ONLY_ONE_BEN,
                      v_studentsRec.REASON_FOR_ONE_BEN_ID,
                      v_studentsRec.PSAS_PT,
                      v_studentsRec.BEN1_OTHER_INC_DETAILS,
                      v_studentsRec.BEN2_OTHER_INC_DETAILS,
                      v_studentsRec.CONT1_CONSENT,
                      v_studentsRec.CONT2_CONSENT,
                      v_studentsRec.INTERRUPTION_FROM_STUDY,
                      v_studentsRec.IS_INDEPENDENT,
                      v_studentsRec.RESIDENCY_CATEGORY,
                      v_studentsRec.BEN1_CONSENT_TO_SHARE_STUDENT,
                      v_studentsRec.BEN2_CONSENT_TO_SHARE_STUDENT,
                      v_studentsRec.INDEPENDENT,
                      v_studentsRec.ORPHAN,
                      v_studentsRec.OVER_25,
                      v_studentsRec.CARE_EXP_FOSTER,
                      v_studentsRec.CARE_EXP_RES,
                      v_studentsRec.CARE_EXP_KINSHIP_LA,
                      v_studentsRec.CARE_EXP_KINSHIP_NO_LA,
                      v_studentsRec.CARE_EXP_HOME,
                      v_studentsRec.CARE_EXP_OTHER,
                      v_studentsRec.CARE_EXP_OTHER_DETAILS,
                      v_studentsRec.CARE_EXP_START_AGE,
                      v_studentsRec.CARE_EXP_END_AGE,
                      v_studentsRec.START_DATE_ABROAD,
                      v_studentsRec.END_DATE_ABROAD,
                      v_studentsRec.BEN1_EMAIL_ADDR,
                      v_studentsRec.BEN2_EMAIL_ADDR,
                      v_studentsRec.PG_ED_PSYCH_GRANT,
                      v_studentsRec.PG_ED_PSYCH_FEES,
                      v_studentsRec.PG_ED_PSYCH_QEPS,
                      v_studentsRec.PG_ED_PSYCH_DECLARATION,
                      v_studentsRec.ESTRANGED,
                      v_studentsRec.CONTINUINGTHREEYEARSORMORE,
                      v_studentsRec.COMPLEX_RESIDENCY,
                      v_studentsRec.EU_SETTLED_STATUS,
                      v_studentsRec.EU_SETTLED_STATUS_CONFIRMED,
                      v_studentsRec.TOP_OPTION,
                      v_studentsRec.EU_RESIDENCE_TYPE);



         INSERT INTO EDM.EDM_TEMP (OBJECT_ID,
                                   SESSION_CODE,
                                   DOCUMENT_TYPE_CODE,
                                   DOCUMENT_NAME,
                                   DOCUMENT_TYPE_COUNT,
                                   ATTACHMENT_TYPE_CODE)
              VALUES (v_temp,
                      v_session_code,
                      v_document_type_code,
                      v_document_name,
                      1,
                      'PDF');



         INSERT INTO EDM.EDM_COMPLETE (OBJECT_ID,
                                       BATCH_TYPE_CODE,
                                       STUD_REF_NO,
                                       BATCH_ID,
                                       ENVELOPE_ID,
                                       SCAN_DATE,
                                       PROC_ERROR,
                                       URGENT)
              VALUES (v_temp,
                      v_batch_code,
                      v_stud_ref_no,
                      NULL,
                      NULL,
                      SYSDATE,
                      'N',
                      'N');



         x := x + 1;                          ----SIMPLY FOR COUNTER IN REPORT



         y := y + 1;


         UPDATE EDM.TEST_STUDENT_MESSAGES
            SET STUD_REF_NO = v_stud_ref_no
          WHERE RAW_DATA_CASE_ID = v_studentsRec.case_id;



         DBMS_OUTPUT.PUT_LINE (
               'Created Case ID '
            || v_studentsRec.case_id
            || ' as Student Reference Number '
            || v_stud_ref_no);



         COMMIT;
      END LOOP;



      DBMS_OUTPUT.PUT_LINE ('Created ' || x || ' Applications');



      UPDATE EDM.TEST_STUDENT_MESSAGES
         SET MESSAGE = y
       WHERE CASE_ID = 0;



      COMMIT;



      CLOSE c_students;
   END SubmitTestApplicationsMessages;



   PROCEDURE Check_Results
   IS
      v_count             NUMBER;
      v_count_2           NUMBER;
      v_current_session   NUMBER;
      v_result            VARCHAR2 (1);

      CURSOR c_results
      IS
           SELECT *
             FROM EDM.TEST_STUDENT_MESSAGES
            WHERE STUD_REF_NO IS NOT NULL AND AUTO_CALC = 'N'
         ORDER BY CASE_ID ASC;



      v_resultsRec        c_results%ROWTYPE;
   BEGIN
      SELECT NVAL
        INTO v_current_session
        FROM SGAS.CONFIG_DATA
       WHERE ITEM_NAME = 'CURRENT_SESSION';



      OPEN c_results;



      LOOP
         FETCH c_results INTO v_resultsRec;



         EXIT WHEN c_results%NOTFOUND;



         SELECT COUNT (*)
           INTO v_count
           FROM sgas.stud_notes a,
                EDM.TEST_STUDENT_MESSAGES b
          WHERE     a.STUD_REF_NO = v_resultsRec.stud_ref_no
                AND a.SESSION_CODE = v_current_session
                AND a.stud_ref_no = b.stud_ref_no
                AND INSTR (UPPER (a.notes_text),
                           UPPER (b.MESSAGE)) > 0
                AND b.CASE_ID = v_resultsRec.case_id;



         IF v_count = 0
         THEN
            UPDATE EDM.TEST_STUDENT_MESSAGES
               SET RESULT = 'F'
             WHERE CASE_ID = v_resultsRec.case_id;



            v_result := 'F';
         ELSE
            UPDATE EDM.TEST_STUDENT_MESSAGES
               SET RESULT = 'P'
             WHERE CASE_ID = v_resultsRec.case_id;



            v_result := 'P';
         END IF;



         DBMS_OUTPUT.PUT_LINE (
               'Case ID: '
            || v_resultsRec.case_id
            || ' Scheme Type: '
            || v_resultsRec.scheme_type
            || ' Student Reference No: '
            || v_resultsRec.stud_ref_no
            || ' Message: '
            || v_resultsRec.MESSAGE
            || ' '
            || v_resultsRec.notes
            || ' Result: '
            || ''
            || v_count);
      END LOOP;



      SELECT COUNT (*)
        INTO v_count
        FROM EDM.TEST_STUDENT_MESSAGES
       WHERE RESULT = 'F' AND AUTO_CALC = 'N';



      SELECT COUNT (*)
        INTO v_count_2
        FROM EDM.TEST_STUDENT_MESSAGES
       WHERE RESULT = 'P' AND AUTO_CALC = 'N';



      DBMS_OUTPUT.PUT_LINE (v_count || ' Case(s) failed validation checks');



      DBMS_OUTPUT.PUT_LINE (v_count_2 || ' Case(s) passed validation checks');



      CLOSE c_results;



      COMMIT;
   END Check_Results;



   PROCEDURE Check_Results_Autocalc
   IS
      v_count              NUMBER;
      v_count_2            NUMBER;
      v_current_session    NUMBER;
      v_result             VARCHAR2 (1);
      v_award_amount       NUMBER;
      v_award_net_amount   NUMBER;
      v_award1             NUMBER := 1;
      v_award2             NUMBER := 1;
      v_award3             NUMBER := 1;

      /* Select the data from the TEST_STUDENT_MESSAGES table for all auto calc test cases */

      CURSOR c_results
      IS
           SELECT *
             FROM EDM.TEST_STUDENT_MESSAGES
            WHERE STUD_REF_NO IS NOT NULL AND AUTO_CALC = 'Y'
         ORDER BY CASE_ID ASC;



      v_resultsRec         c_results%ROWTYPE;
   BEGIN
      SELECT NVAL
        INTO v_current_session
        FROM SGAS.CONFIG_DATA
       WHERE ITEM_NAME = 'CURRENT_SESSION';



      OPEN c_results;



      LOOP
         FETCH c_results INTO v_resultsRec;



         EXIT WHEN c_results%NOTFOUND;

         /* Count how many award records have been created for each case.This should match the number held in TEST_STUDENT_MESSAGES.no_of_awards for each case
         If none have been created then the case has not been automatically calculated - output a message to say that no award records have been found
         Or if the wrong number of award records have been created then output a message to say so */

         SELECT COUNT (*)
           INTO v_count
           FROM SGAS.AWARD
          WHERE     SESSION_CODE = v_current_session
                AND STUD_REF_NO = v_resultsRec.stud_ref_no;


         IF v_count = 0
         THEN
            v_award1 := 0;


            DBMS_OUTPUT.PUT_LINE (
               'No award records for Case ID ' || v_resultsRec.case_id);
         ELSIF v_count != v_resultsRec.no_of_awards
         THEN
            v_award1 := 0;



            DBMS_OUTPUT.PUT_LINE (
                  'Wrong number of award records found for Case ID '
               || v_resultsRec.case_id);
         ELSE
            v_award1 := 1;
         END IF;

         /* If the correct number of awards have been calculated then check the amounts and net_amounts are correct */

         IF v_count = v_resultsRec.no_of_awards
         THEN
            BEGIN
               SELECT AMOUNT,
                      NET_AMOUNT
                 INTO v_award_amount,
                      v_award_net_amount
                 FROM SGAS.AWARD
                WHERE     SESSION_CODE = v_current_session
                      AND STUD_AWARD_TYPE = v_resultsRec.award_type1
                      AND STUD_REF_NO = v_resultsRec.stud_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  DBMS_OUTPUT.PUT_LINE (
                        'Case ID '
                     || v_resultsRec.case_id
                     || ' Cannot find net amount for first award record');
            END;


            IF    v_award_amount != v_resultsRec.award_amount1
               OR v_award_net_amount != v_resultsRec.award_net_amount1
            THEN
               v_award1 := 0;
               DBMS_OUTPUT.PUT_LINE (
                  'Award amount 1 is not correct ' || v_resultsRec.case_id);
            END IF;



            IF v_resultsRec.no_of_awards > 1
            THEN
               SELECT AMOUNT,
                      NET_AMOUNT
                 INTO v_award_amount,
                      v_award_net_amount
                 FROM SGAS.AWARD
                WHERE     SESSION_CODE = v_current_session
                      AND STUD_AWARD_TYPE = v_resultsRec.award_type2
                      AND STUD_REF_NO = v_resultsRec.stud_ref_no;


               IF    v_award_amount != v_resultsRec.award_amount2
                  OR v_award_net_amount != v_resultsRec.award_net_amount2
               THEN
                  v_award2 := 0;
                  DBMS_OUTPUT.PUT_LINE (
                     'Award amount 2 is not correct ' || v_resultsRec.case_id);
               END IF;
            END IF;



            IF v_resultsRec.no_of_awards > 2
            THEN
               SELECT AMOUNT,
                      NET_AMOUNT
                 INTO v_award_amount,
                      v_award_net_amount
                 FROM SGAS.AWARD
                WHERE     SESSION_CODE = v_current_session
                      AND STUD_AWARD_TYPE = v_resultsRec.award_type3
                      AND STUD_REF_NO = v_resultsRec.stud_ref_no;



               IF    v_award_amount != v_resultsRec.award_amount3
                  OR v_award_net_amount != v_resultsRec.award_net_amount3
               THEN
                  v_award3 := 0;
                  DBMS_OUTPUT.PUT_LINE (
                     'Award amount 3 is not correct ' || v_resultsRec.case_id);
               END IF;
            END IF;
         END IF;

         /* Report the results */


         IF v_award1 = 0 OR v_award2 = 0 OR v_award3 = 0
         THEN
            UPDATE EDM.TEST_STUDENT_MESSAGES
               SET RESULT = 'F'
             WHERE CASE_ID = v_resultsRec.case_id;



            v_result := 'F';
         ELSE
            UPDATE EDM.TEST_STUDENT_MESSAGES
               SET RESULT = 'P'
             WHERE CASE_ID = v_resultsRec.case_id;



            v_result := 'P';
         END IF;



         DBMS_OUTPUT.PUT_LINE (
               'Case ID: '
            || v_resultsRec.case_id
            || ' Scheme Type: '
            || v_resultsRec.scheme_type
            || ' Student Reference No: '
            || v_resultsRec.stud_ref_no
            || ' Result: '
            || ''
            || v_result);
         v_award1 := 1;
         v_award2 := 1;
         v_award3 := 1;
      END LOOP;


      SELECT COUNT (*)
        INTO v_count
        FROM EDM.TEST_STUDENT_MESSAGES
       WHERE RESULT = 'F' AND AUTO_CALC = 'Y';



      SELECT COUNT (*)
        INTO v_count_2
        FROM EDM.TEST_STUDENT_MESSAGES
       WHERE RESULT = 'P' AND AUTO_CALC = 'Y';



      DBMS_OUTPUT.PUT_LINE (v_count || ' Case(s) failed validation checks');



      DBMS_OUTPUT.PUT_LINE (v_count_2 || ' Case(s) passed validation checks');



      CLOSE c_results;



      COMMIT;
   END Check_Results_Autocalc;



   PROCEDURE Submit_Single_Student_Enquiry (ref_no IN NUMBER)
   IS
      v_ref_no         NUMBER (8) := ref_no;

      v_session_code   NUMBER (4);
   BEGIN
      SELECT NVAL
        INTO v_session_code
        FROM SGAS.CONFIG_DATA
       WHERE ITEM_NAME = 'CURRENT_SESSION';



      INSERT INTO SGAS.STUD_ENQUIRY (ENQUIRY_ID,
                                     STUD_REF_NO,
                                     ENQUIRY_OPTION_ID,
                                     ENQUIRY_TEXT,
                                     ENQUIRY_DATE,
                                     SESSION_CODE,
                                     IS_VIEWED)
           VALUES (SGAS.ENQUIRY_OPTION_ID_SEQ.NEXTVAL,
                   v_ref_no,
                   9,
                   'Testing the Student Enquiry form...',
                   SYSDATE,
                   v_session_code,
                   'N');



      COMMIT;



      DBMS_OUTPUT.PUT_LINE (
         'Submitted Student Enquiry for student reference number ' || ref_no);



      COMMIT;
   END Submit_Single_Student_Enquiry;



   PROCEDURE Submit_Single_Correspondence (ref_no            IN NUMBER,
                                           batch_type_code   IN NUMBER)
   IS
      v_stud_ref_no          NUMBER (8) := ref_no;
      v_session_code         NUMBER (4);
      v_batch_type_code      NUMBER (2) := batch_type_code;
      v_document_type_code   VARCHAR2 (20);
      v_document_name        VARCHAR (20);
   /* Get the current session code from the database */
   BEGIN
      SELECT NVAL
        INTO v_session_code
        FROM SGAS.CONFIG_DATA
       WHERE ITEM_NAME = 'CURRENT_SESSION';

      /* Set the document type codes and document names to be used in the insert into the EDM tables */

      IF v_batch_type_code = 59                        -- Fee Loan Application
      THEN
         v_document_type_code := 'FEE_LOAN_APP';

         v_document_name := 'FEE_LOAN_APP:2021';
      ELSIF v_batch_type_code = 62                 -- Placement Expenses Claim
      THEN
         v_document_type_code := 'AB4_EDM_APP';

         v_document_name := 'AB4_EDM_APP:2021';
      ELSIF v_batch_type_code = 56                          -- DSA Application
      THEN
         v_document_type_code := 'DSA_APP';

         v_document_name := 'DSA_APP:2021';
      ELSIF v_batch_type_code = 57                       -- DSA Correspondence
      THEN
         v_document_type_code := 'DSA_CORR';

         v_document_name := 'DSA_CORR:2021';
      ELSIF v_batch_type_code = 58               -- Overpayment Correspondence
      THEN
         v_document_type_code := 'OP_CORR';

         v_document_name := 'OP_CORR:2021';
      ELSIF v_batch_type_code = 55                   -- General Correspondence
      THEN
         v_document_type_code := 'GEN_CORR';

         v_document_name := 'GEN_CORR:2021';
      END IF;

      /* INSERT INTO THE EDM_COMPLETE AND EDM_TEMP TABLES */

      INSERT INTO EDM.EDM_COMPLETE (OBJECT_ID,
                                    BATCH_TYPE_CODE,
                                    STUD_REF_NO,
                                    BATCH_ID,
                                    ENVELOPE_ID,
                                    SCAN_DATE,
                                    PROC_ERROR,
                                    URGENT)
           VALUES ('20226SAAS028553',
                   v_batch_type_code,
                   v_stud_ref_no,
                   130820207102,
                   1,
                   SYSDATE,
                   'N',
                   'N');



      INSERT INTO EDM.EDM_TEMP (OBJECT_ID,
                                DOCUMENT_TYPE_CODE,
                                DOCUMENT_NAME,
                                DOCUMENT_TYPE_COUNT,
                                ATTACHMENT_TYPE_CODE)
           VALUES ('20226SAAS028553',
                   'XML',
                   'XML',
                   1,
                   'XML');



      INSERT INTO EDM.EDM_TEMP (OBJECT_ID,
                                SESSION_CODE,
                                DOCUMENT_TYPE_CODE,
                                DOCUMENT_NAME,
                                DOCUMENT_TYPE_COUNT,
                                ATTACHMENT_TYPE_CODE)
           VALUES ('20226SAAS028553',
                   v_session_code,
                   v_document_type_code,
                   v_document_name,
                   1,
                   'TIFF');



      COMMIT;

      DBMS_OUTPUT.PUT_LINE (
         'Submitted Correspondence for student reference number ' || ref_no);



      COMMIT;
   END Submit_Single_Correspondence;


   PROCEDURE SubmitTestAutoCalcApplications
   IS
      v_batch_code           NUMBER;
      v_raw_data_id          NUMBER;
      v_session_code         NUMBER (4);
      v_session_code_61      NUMBER (4);
      v_document_type_code   VARCHAR2 (20);
      v_document_name        VARCHAR2 (20);
      x                      NUMBER := 0;
      y                      NUMBER;
      v_object_id            VARCHAR2 (15) := 'SAAS';
      v_temp                 VARCHAR2 (15);
      v_slc_Ref_no           VARCHAR2 (10);
      v_stud_Ref_no          NUMBER (10);
      v_forenames            VARCHAR2 (25);
      v_surname              VARCHAR2 (25);
      v_nino                 VARCHAR2 (10);
      v_email                VARCHAR2 (80);
      v_portal_user_id       VARCHAR2 (20);
      v_dob                  VARCHAR2 (10);
      v_count                NUMBER (10);
      v_date_app_rec         VARCHAR2 (10);



      CURSOR c_students --Select all active auto calc cases from TEST_DATA_RAW_DATA
      IS
           SELECT *
             FROM EDM.TEST_DATA_RAW_DATA
            WHERE IS_ACTIVE = 'Y' AND CASE_ID > 0 AND AUTO_CALC = 'Y'
         ORDER BY CASE_ID;

      v_studentsRec          c_students%ROWTYPE;
   BEGIN
      BEGIN                                                    --Reset results
         UPDATE EDM.TEST_STUDENT_MESSAGES
            SET RESULT = NULL,
                STUD_REF_NO = NULL
          WHERE AUTO_CALC = 'Y';
      END;



      SELECT NVAL                  --Set v_session_code to the current session
        INTO v_session_code
        FROM SGAS.CONFIG_DATA
       WHERE ITEM_NAME = 'CURRENT_SESSION';



      v_session_code_61 := v_session_code - 61; --used for students aged over 61 check later in the script



      SELECT MESSAGE         --This value is used to create a unique object id
        INTO y
        FROM EDM.TEST_STUDENT_MESSAGES
       WHERE CASE_ID = 0;



      OPEN c_students;



      LOOP
         FETCH c_students INTO v_studentsRec;



         EXIT WHEN c_students%NOTFOUND;



         v_temp := v_object_id || TO_CHAR (y);          --Create new object id

         SELECT EDM.RAW_DATA_ID_SEQ.NEXTVAL INTO v_raw_data_id FROM DUAL; --Create new raw data id



         SELECT TO_CHAR (SYSDATE,     --Set application recieved date to today
                         'DDMMYYYY')
           INTO v_date_app_rec
           FROM DUAL;


         /* Set the fields below to NULL for each run to avoid duplicates.
         If the student is continuing, they will be updated later to match the data in StEPS */

         v_email := NULL;

         v_portal_user_id := NULL;

         v_slc_Ref_no := NULL;

         /* Section to set student reference number
         If the student is continuing then use the student reference number assigned to the case in the TEST_DATA_RAW_DATA table
         Otherwise assign a new student reference number*/


         IF v_studentsRec.new_student = 'N'
         THEN
            v_stud_ref_no := v_studentsRec.stud_ref_no;
         ELSE
            SELECT SGAS.ST_STUD_REF_NO_SEQ.NEXTVAL
              INTO v_stud_ref_no
              FROM DUAL;
         END IF;

         /* Section to set NINO
         If the student is continuing then use the NINO assigned to the case in the TEST_DATA_RAW_DATA table
         Otherwise assign a new unique NINO*/


         IF v_studentsRec.new_student = 'N'
         THEN
            v_nino := v_studentsRec.NI_NO;
         ELSE
            LOOP
               SELECT SGAS.PK_COPY_APPLICATION.GET_UNIQUE_NINO
                 INTO v_nino
                 FROM DUAL;

               SELECT COUNT (*)
                 INTO v_count
                 FROM SGAS.STUD
                WHERE NI_NO = v_nino;

               EXIT WHEN v_count = 0;
            END LOOP;
         END IF;


         /* Set forename and surnme.
         If the student is continuing then set the forename and surname to match those held in TEST_DATA_RAW_DATA.
         Otherwise set the forename to autotest and generate a new random surname to prevent too many duplicates*/

         IF v_studentsRec.new_student = 'N'
         THEN
            v_forenames := v_studentsRec.forenames;
            v_surname := v_studentsRec.surname;
         ELSE
            v_forenames := 'AutoTest';
            v_surname :=
               DBMS_RANDOM.string ('U',
                                   25);
         END IF;

         /* Set the date of birth
         This can normally just be set to the same as the value held in TEST_DATA_RAW_DATA.
         However, there are some cases where a particular date should be generated (see below)*/

         IF v_studentsRec.case_id = 129 -- Auto calc case to check that a student aged 61 on 2nd August current session +1 WILL auto calc.
         THEN
            v_dob := '0207' || (v_session_code_61 + 1);
         ELSIF v_studentsRec.case_id = 163 -- Auto calc case to check that a student aged 16 today will be auto calc'd.
         THEN
            SELECT TO_CHAR (SYSDATE - INTERVAL '16' YEAR,
                            'DDMMYYYY')
              INTO v_dob
              FROM DUAL;
         ELSE
            v_dob := v_studentsRec.dob;
         END IF;

         /* Update the following fields for continuing students to ensure the records remain consistent with the data held in StEPS */

         IF v_studentsRec.new_student = 'N'
         THEN
            BEGIN
               SELECT EMAIL_ADDR
                 INTO v_email
                 FROM SGAS.STUD
                WHERE STUD_REF_NO = v_stud_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_email := NULL;
            END;


            BEGIN
               SELECT PORTAL_USER_ID
                 INTO v_portal_user_id
                 FROM SGAS.STUD
                WHERE STUD_REF_NO = v_stud_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_portal_user_id := NULL;
            END;


            BEGIN
               SELECT SCOTTISH_CAND
                 INTO v_slc_ref_no
                 FROM SGAS.STUD
                WHERE STUD_REF_NO = v_stud_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_slc_ref_no := NULL;
            END;



            BEGIN
               SELECT FORENAMES
                 INTO v_forenames
                 FROM SGAS.STUD
                WHERE STUD_REF_NO = v_stud_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_forenames := 'FIRST NAME';
            END;



            BEGIN
               SELECT surname
                 INTO v_surname
                 FROM SGAS.STUD
                WHERE STUD_REF_NO = v_stud_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_forenames := 'SURNAME';
            END;



            BEGIN
               SELECT NI_NO
                 INTO v_nino
                 FROM SGAS.STUD
                WHERE STUD_REF_NO = v_stud_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_nino := NULL;
            END;
         END IF;

         /* Set the values required for the EDM_COMPLETE and EDM_TEMP inserts */

         IF     v_studentsRec.scheme_type = 'U'
            AND v_studentsRec.case_id != '182'
         THEN
            v_document_type_code := 'SAS3_PDF';
            v_document_name := '3' || v_stud_ref_no || v_session_code;
            v_batch_code := 31;
         ELSIF     v_studentsRec.scheme_type = 'U'
               AND v_studentsRec.case_id = '182'
         THEN
            v_document_type_code := 'SAS3_PDF';
            v_document_name := '3' || v_stud_ref_no || v_session_code;
            v_batch_code := 36;
         ELSIF v_studentsRec.scheme_type = 'P'
         THEN
            v_document_type_code := 'SAS7_PDF';
            v_document_name := v_stud_ref_no || v_session_code || ':1';
            v_batch_code := 32;
         ELSIF v_studentsRec.scheme_type = 'B'
         THEN
            v_document_type_code := 'NMSB1_PDF';
            v_document_name := 'B' || v_stud_ref_no || v_session_code || ':1';
            v_batch_code := 33;
         END IF;



         -- INSERT THE RAW_DATA, EDM_COMPLETE and EDM_TEMP RECORDS --



         INSERT INTO EDM.RAW_DATA (OBJECT_ID,
                                   RAW_DATA_ID,
                                   BATCH_ID,
                                   ENVELOPE_ID,
                                   SUPPLEMENTARY_GRANTS,
                                   STUD_REF_NO,
                                   SCOTTISH_CAND,
                                   NI_NO,
                                   NI_NO_F,
                                   TITLE,
                                   SURNAME,
                                   FORENAMES,
                                   BIRTH_SURNAME,
                                   BIRTH_FORENAMES,
                                   DOB,
                                   DOB_F,
                                   DISTRICT_BIRTH_CERT_ISSUED,
                                   SEX,
                                   MARITAL_STATUS,
                                   MARRIAGE_DATE,
                                   HOME_HOUSE_NO_NAME,
                                   HOME_POST_CODE,
                                   HOME_ADDR_L1,
                                   HOME_ADDR_L2,
                                   HOME_ADDR_L3,
                                   HOME_ADDR_L4,
                                   HOME_TELE_NO,
                                   SORT_CODE,
                                   SORT_CODE_F,
                                   ACCOUNT_NO,
                                   ACCOUNT_NO_F,
                                   BIRTH_COUNTRY_CODE,
                                   BIRTH_COUNTRY_CODE_F,
                                   NATION_COUNTRY_CODE,
                                   NATION_COUNTRY_CODE_F,
                                   RESIDENCE_COUNTRY_CODE,
                                   RESIDENCE_COUNTRY_CODE_F,
                                   INST_NAME,
                                   INST_NAME_F,
                                   INST_CODE,
                                   CRSE_NAME,
                                   CRSE_NAME_F,
                                   CRSE_CODE,
                                   CRSE_YEAR_NO,
                                   FIRST_DEP_SURNAME,
                                   FIRST_DEP_FORENAMES,
                                   FIRST_DEP_DOB,
                                   FIRST_DEP_DOB_F,
                                   FIRST_DEP_REL_TYPE,
                                   FIRST_DEP_INCOME_CODE_1,
                                   FIRST_DEP_INCOME_CODE_1_F,
                                   FIRST_DEP_INCOME_AMOUNT_1,
                                   FIRST_DEP_INCOME_AMOUNT_1_F,
                                   FIRST_DEP_INCOME_CODE_2,
                                   FIRST_DEP_INCOME_CODE_2_F,
                                   FIRST_DEP_INCOME_AMOUNT_2,
                                   FIRST_DEP_INCOME_AMOUNT_2_F,
                                   FIRST_DEP_INCOME_CODE_3,
                                   FIRST_DEP_INCOME_CODE_3_F,
                                   FIRST_DEP_INCOME_AMOUNT_3,
                                   FIRST_DEP_INCOME_AMOUNT_3_F,
                                   SEC_DEP_SURNAME,
                                   SEC_DEP_FORENAMES,
                                   SEC_DEP_DOB,
                                   SEC_DEP_DOB_F,
                                   SEC_DEP_REL_TYPE,
                                   SEC_DEP_INCOME_CODE_1,
                                   SEC_DEP_INCOME_CODE_1_F,
                                   SEC_DEP_INCOME_AMOUNT_1,
                                   SEC_DEP_INCOME_AMOUNT_1_F,
                                   SEC_DEP_INCOME_CODE_2,
                                   SEC_DEP_INCOME_CODE_2_F,
                                   SEC_DEP_INCOME_AMOUNT_2,
                                   SEC_DEP_INCOME_AMOUNT_2_F,
                                   SEC_DEP_INCOME_CODE_3,
                                   SEC_DEP_INCOME_CODE_3_F,
                                   SEC_DEP_INCOME_AMOUNT_3,
                                   SEC_DEP_INCOME_AMOUNT_3_F,
                                   THIRD_DEP_SURNAME,
                                   THIRD_DEP_FORENAMES,
                                   THIRD_DEP_DOB,
                                   THIRD_DEP_DOB_F,
                                   THIRD_DEP_REL_TYPE,
                                   THIRD_DEP_INCOME_CODE_1,
                                   THIRD_DEP_INCOME_CODE_1_F,
                                   THIRD_DEP_INCOME_AMOUNT_1,
                                   THIRD_DEP_INCOME_AMOUNT_1_F,
                                   THIRD_DEP_INCOME_CODE_2,
                                   THIRD_DEP_INCOME_CODE_2_F,
                                   THIRD_DEP_INCOME_AMOUNT_2,
                                   THIRD_DEP_INCOME_AMOUNT_2_F,
                                   THIRD_DEP_INCOME_CODE_3,
                                   THIRD_DEP_INCOME_CODE_3_F,
                                   THIRD_DEP_INCOME_AMOUNT_3,
                                   THIRD_DEP_INCOME_AMOUNT_3_F,
                                   ADD_DEP_DETAILS,
                                   LPCG,
                                   TWO_HOMES_ALLOW,
                                   VAC_GRANT,
                                   NET_INCOME,
                                   NET_INCOME_F,
                                   PENSION_INCOME,
                                   PENSION_INCOME_F,
                                   TRUST_INCOME,
                                   TRUST_INCOME_F,
                                   AWARD_ORG,
                                   ANNUAL_VALUE,
                                   MAINTENANCE,
                                   FEES,
                                   LENGTH_OF_SUPPORT,
                                   SUPPORT_START_DATE,
                                   APP_FORM_SIG,
                                   MAX_LOAN_REQUESTED,
                                   LOAN_REQUEST,
                                   LOAN_REQUEST_F,
                                   CONT1_FORENAME,
                                   CONT1_SURNAME,
                                   CONT1_NAME,
                                   CONT1_REL_CODE,
                                   CONT1_HOUSE_NO_NM,
                                   CONT1_POSTCODE,
                                   CONT1_ADDR1,
                                   CONT1_ADDR2,
                                   CONT1_ADDR3,
                                   CONT1_ADDR4,
                                   CONT1_TEL_NO,
                                   CONT2_FORENAME,
                                   CONT2_SURNAME,
                                   CONT2_NAME,
                                   CONT2_HOUSE_NO_NM,
                                   CONT2_POSTCODE,
                                   CONT2_ADDR1,
                                   CONT2_ADDR2,
                                   CONT2_ADDR3,
                                   CONT2_ADDR4,
                                   CONT2_TEL_NO,
                                   BANKRUPT_FLAG,
                                   TERM_HOUSE_NO_NAME,
                                   TERM_POST_CODE,
                                   TERM_ADDR_L1,
                                   TERM_ADDR_L2,
                                   TERM_ADDR_L3,
                                   TERM_ADDR_L4,
                                   SLC_CORRES_DEST,
                                   LOAN_SIGNATURE,
                                   LOAN_DECLARATION_DATE,
                                   LOAN_DECLARATION_DATE_F,
                                   BEN1_NI_NO,
                                   BEN1_NI_NO_F,
                                   BEN1_TITLE,
                                   BEN1_SURNAME,
                                   BEN1_FORENAMES,
                                   BEN1_REL_TYPE,
                                   BEN1_HOUSE_NO_NAME,
                                   BEN1_POSTCODE,
                                   BEN1_ADDR1,
                                   BEN1_ADDR2,
                                   BEN1_ADDR3,
                                   BEN1_ADDR4,
                                   BEN1_EMP_STATUS,
                                   BEN2_NI_NO,
                                   BEN2_NI_NO_F,
                                   BEN2_TITLE,
                                   BEN2_SURNAME,
                                   BEN2_FORENAMES,
                                   BEN2_REL_TYPE,
                                   BEN2_HOUSE_NO_NAME,
                                   BEN2_POSTCODE,
                                   BEN2_ADDR1,
                                   BEN2_ADDR2,
                                   BEN2_ADDR3,
                                   BEN2_ADDR4,
                                   BEN2_EMP_STATUS,
                                   JA_CASE,
                                   BEN1_PAYE,
                                   BEN1_PAYE_F,
                                   BEN2_PAYE,
                                   BEN2_PAYE_F,
                                   BEN1_SELF_EMPLOYMENT,
                                   BEN1_SELF_EMPLOYMENT_F,
                                   BEN2_SELF_EMPLOYMENT,
                                   BEN2_SELF_EMPLOYMENT_F,
                                   BEN1_PROPERTY,
                                   BEN1_PROPERTY_F,
                                   BEN2_PROPERTY,
                                   BEN2_PROPERTY_F,
                                   BEN1_PENSIONS,
                                   BEN1_PENSIONS_F,
                                   BEN2_PENSIONS,
                                   BEN2_PENSIONS_F,
                                   BEN1_BENEFITS,
                                   BEN1_BENEFITS_F,
                                   BEN2_BENEFITS,
                                   BEN2_BENEFITS_F,
                                   BEN1_NAT_SAVINGS,
                                   BEN1_NAT_SAVINGS_F,
                                   BEN2_NAT_SAVINGS,
                                   BEN2_NAT_SAVINGS_F,
                                   BEN1_INTEREST,
                                   BEN1_INTEREST_F,
                                   BEN2_INTEREST,
                                   BEN2_INTEREST_F,
                                   BEN1_DIVIDEND,
                                   BEN1_DIVIDEND_F,
                                   BEN2_DIVIDEND,
                                   BEN2_DIVIDEND_F,
                                   BEN1_OTHER_INC,
                                   BEN1_OTHER_INC_F,
                                   BEN2_OTHER_INC,
                                   BEN2_OTHER_INC_F,
                                   BEN1_SUPERANN,
                                   BEN1_SUPERANN_F,
                                   BEN2_SUPERANN,
                                   BEN2_SUPERANN_F,
                                   BEN1_RAP,
                                   BEN1_RAP_F,
                                   BEN2_RAP,
                                   BEN2_RAP_F,
                                   BEN1_OTHER_DED,
                                   BEN1_OTHER_DED_F,
                                   BEN2_OTHER_DED,
                                   BEN2_OTHER_DED_F,
                                   BEN1_FIRST_DEP_DOB,
                                   BEN1_FIRST_DEP_DOB_F,
                                   BEN1_SEC_DEP_DOB,
                                   BEN1_SEC_DEP_DOB_F,
                                   BEN1_THIRD_DEP_DOB,
                                   BEN1_THIRD_DEP_DOB_F,
                                   DOMESTIC_HELP,
                                   BEN_DEC_SIG,
                                   EXTRA_NOTES,
                                   OUT_UK,
                                   FAST_TRACK,
                                   RES_QUERY,
                                   ARA_SENT,
                                   BIRTH_CERT_FLAG,
                                   OFFER_FLAG,
                                   REPEAT_YEAR,
                                   DATE_APPLIC_RECEIVED,
                                   EMP_LOGIN,
                                   APP_FORM_SIG_DATE,
                                   PGCE,
                                   DSA,
                                   TOT_TRAV_AMOUNT_CLAIMED,
                                   TOT_TRAV_AMOUNT_CLAIMED_F,
                                   MOBILE_TEL_NO,
                                   HOME_ADDR_MAIL_SORT,
                                   BEN1_MAIL_SORT,
                                   BEN2_MAIL_SORT,
                                   EMAIL_ADDR,
                                   WEB_USER_ID,
                                   BANK_VALIDATE,
                                   EMAIL_ADDR_F,
                                   TERM_TIME_RESIDENCE,
                                   TERM_TIME_RESIDENCE_F,
                                   RELEVANT_DATE,
                                   RELEVANT_DATE_F,
                                   ORDIN_RES_UK_3_YEARS,
                                   ORDIN_RES_UK_3_YEARS_F,
                                   ORDIN_RES_SCOT_REL_DATE,
                                   ORDIN_RES_SCOT_REL_DATE_F,
                                   IN_EDUC_SINCE_LEAVE_SCHOOL,
                                   IN_EDUC_SINCE_LEAVE_SCHOOL_F,
                                   EU_GRADUATE,
                                   EU_GRADUATE_F,
                                   STUDY_ABROAD,
                                   STUDY_ABROAD_F,
                                   PLACEMENT_YEAR,
                                   PLACEMENT_YEAR_F,
                                   SECONDARY_OR_PRIMARY_ED,
                                   SECONDARY_OR_PRIMARY_ED_F,
                                   SECONDARY_SUBJECT,
                                   SECONDARY_SUBJECT_F,
                                   EXEMPT_FROM_PARENT_CONTRIB,
                                   EXEMPT_FROM_PARENT_CONTRIB_F,
                                   PLAN_TO_WORK_OUTSIDE_UK,
                                   PLAN_TO_WORK_OUTSIDE_UK_F,
                                   BEN1_FIRST_DEP_LAST_NAME,
                                   BEN1_FIRST_DEP_LAST_NAME_F,
                                   BEN1_FIRST_DEP_FIRST_NAME,
                                   BEN1_FIRST_DEP_FIRST_NAME_F,
                                   BEN1_FIRST_DEP_LEAVE_SCHOOL,
                                   BEN1_FIRST_DEP_LEAVE_SCHOOL_F,
                                   BEN1_SEC_DEP_LAST_NAME,
                                   BEN1_SEC_DEP_LAST_NAME_F,
                                   BEN1_SEC_DEP_FIRST_NAME,
                                   BEN1_SEC_DEP_FIRST_NAME_F,
                                   BEN1_SEC_DEP_LEAVE_SCHOOL,
                                   BEN1_SEC_DEP_LEAVE_SCHOOL_F,
                                   BEN1_THIRD_DEP_LAST_NAME,
                                   BEN1_THIRD_DEP_LAST_NAME_F,
                                   BEN1_THIRD_DEP_FIRST_NAME,
                                   BEN1_THIRD_DEP_FIRST_NAME_F,
                                   BEN1_THIRD_DEP_LEAVE_SCHOOL,
                                   BEN1_THIRD_DEP_LEAVE_SCHOOL_F,
                                   EU_STUDENT,
                                   NOS_YEARS_COURSE_TAKES,
                                   ORD_RES_SCOTLAND_WEB,
                                   ORD_RES_UK_WEB,
                                   MAX_FEE_LOAN,
                                   FEE_LOAN_AMOUNT,
                                   FEE_LOAN_CHARGED_AMOUNT,
                                   DEP_GRANT,
                                   LPG,
                                   MORE_THAN_3_BEN_DEPS,
                                   MIGRANT_WORKER,
                                   SPOUSE_OF_MIGRANT_WORKER,
                                   PLAN_TO_WORK_DURING_CRSE,
                                   STUDY_FT_OR_PT,
                                   STUDY_FT_OR_PT_F,
                                   BEN1_WORKING_TAX_CREDIT,
                                   BEN1_EMP_SUPPORT_ALLOWANCE,
                                   BEN1_INCAPACITY_BENEFIT,
                                   BEN1_INCOME_SUPPORT,
                                   BEN1_INVALIDITY_BENEFIT,
                                   BEN1_JOBSEEKERS_ALLOWANCE,
                                   BEN1_MAINTENANCE_PAYMENT,
                                   BEN2_WORKING_TAX_CREDIT,
                                   BEN2_EMP_SUPPORT_ALLOWANCE,
                                   BEN2_INCAPACITY_BENEFIT,
                                   BEN2_INCOME_SUPPORT,
                                   BEN2_INVALIDITY_BENEFIT,
                                   BEN2_JOBSEEKERS_ALLOWANCE,
                                   BEN2_MAINTENANCE_PAYMENT,
                                   STUD_INCOME,
                                   AB36,
                                   SKILLS_DEV_DATA_SHARE,
                                   RESIDENCE_IND,
                                   WORKING_TAX_CREDIT_IND,
                                   EMPLOYMENT_SUPPORT_ALLOWANCE,
                                   INCAPACITY_BENEFIT,
                                   INCOME_SUPPORT,
                                   INVALIDITY_BENEFIT,
                                   JOBSEEKERS_ALLOWANCE,
                                   UK_PASSPORT,
                                   PASSPORT_NUMBER,
                                   PASSPORT_FIRST_NAMES,
                                   PASSPORT_SURNAME,
                                   PASSPORT_ISSUE_DATE,
                                   PASSPORT_EXPIRY_DATE,
                                   UK_BIRTH_CNTRY_CODE,
                                   TUITION_FEES,
                                   MAINTENANCE_GRANT,
                                   BURSARY_ONLY,
                                   INCOME_ASSESSED_LOAN,
                                   NON_INCOME_ASSESSED_LOAN,
                                   YSB,
                                   YSB_OUTSIDE_SCOTLAND,
                                   HEALTHCARE_FUNDING,
                                   CLAIMING_DSA,
                                   INSIDE_OUTSIDE_SCOTLAND,
                                   INSCOT_YEAR,
                                   CONSENT_FROM_STUDENT,
                                   CONSENT_FROM_FATHER,
                                   CONSENT_FROM_MOTHER,
                                   CONSENT_FROM_HUSBAND_WIFE,
                                   STUD_INCOME_AMT1,
                                   STUD_INCOME_TYPE1,
                                   STUD_INCOME_AMT2,
                                   STUD_INCOME_TYPE2,
                                   STUD_INCOME_AMT3,
                                   STUD_INCOME_TYPE3,
                                   STUD_INCOME_AMT4,
                                   STUD_INCOME_TYPE4,
                                   STUD_INCOME_AMT5,
                                   STUD_INCOME_TYPE5,
                                   STUD_INCOME_AMT6,
                                   STUD_INCOME_TYPE6,
                                   REASON_NO_INCOME_BEN1,
                                   REASON_NO_INCOME_BEN2,
                                   HEI_CONSENT,
                                   CARE_LEAVER,
                                   DUAL_NATIONALITY,
                                   BEN1_HEI_CONSENT,
                                   BEN2_HEI_CONSENT,
                                   BEN1_AB36,
                                   BEN2_AB36,
                                   ONLY_ONE_BEN,
                                   REASON_FOR_ONE_BEN_ID,
                                   PSAS_PT,
                                   BEN1_OTHER_INC_DETAILS,
                                   BEN2_OTHER_INC_DETAILS,
                                   CONT1_CONSENT,
                                   CONT2_CONSENT,
                                   INTERRUPTION_FROM_STUDY,
                                   IS_INDEPENDENT,
                                   RESIDENCY_CATEGORY,
                                   BEN1_CONSENT_TO_SHARE_STUDENT,
                                   BEN2_CONSENT_TO_SHARE_STUDENT,
                                   INDEPENDENT,
                                   ORPHAN,
                                   OVER_25,
                                   CARE_EXP_FOSTER,
                                   CARE_EXP_RES,
                                   CARE_EXP_KINSHIP_LA,
                                   CARE_EXP_KINSHIP_NO_LA,
                                   CARE_EXP_HOME,
                                   CARE_EXP_OTHER,
                                   CARE_EXP_OTHER_DETAILS,
                                   CARE_EXP_START_AGE,
                                   CARE_EXP_END_AGE,
                                   START_DATE_ABROAD,
                                   END_DATE_ABROAD,
                                   BEN1_EMAIL_ADDR,
                                   BEN2_EMAIL_ADDR,
                                   PG_ED_PSYCH_GRANT,
                                   PG_ED_PSYCH_FEES,
                                   PG_ED_PSYCH_QEPS,
                                   PG_ED_PSYCH_DECLARATION,
                                   ESTRANGED,
                                   CONTINUINGTHREEYEARSORMORE,
                                   COMPLEX_RESIDENCY,
                                   EU_SETTLED_STATUS,
                                   EU_SETTLED_STATUS_CONFIRMED,
                                   TOP_OPTION,
                                   EU_RESIDENCE_TYPE)
              VALUES (v_temp,
                      v_raw_data_id,
                      NULL,
                      NULL,
                      v_studentsRec.SUPPLEMENTARY_GRANTS,
                      v_stud_ref_no,
                      v_slc_Ref_no,
                      v_nino,
                      v_studentsRec.NI_NO_F,
                      v_studentsRec.TITLE,
                      v_surname,
                      v_forenames,
                      v_studentsRec.BIRTH_SURNAME,
                      v_studentsRec.BIRTH_FORENAMES,
                      v_dob,
                      v_studentsRec.DOB_F,
                      v_studentsRec.DISTRICT_BIRTH_CERT_ISSUED,
                      v_studentsRec.SEX,
                      v_studentsRec.MARITAL_STATUS,
                      v_studentsRec.MARRIAGE_DATE,
                      v_studentsRec.HOME_HOUSE_NO_NAME,
                      v_studentsRec.HOME_POST_CODE,
                      v_studentsRec.HOME_ADDR_L1,
                      v_studentsRec.HOME_ADDR_L2,
                      v_studentsRec.HOME_ADDR_L3,
                      v_studentsRec.HOME_ADDR_L4,
                      v_studentsRec.HOME_TELE_NO,
                      v_studentsRec.SORT_CODE,
                      v_studentsRec.SORT_CODE_F,
                      v_studentsRec.ACCOUNT_NO,
                      v_studentsRec.ACCOUNT_NO_F,
                      v_studentsRec.BIRTH_COUNTRY_CODE,
                      v_studentsRec.BIRTH_COUNTRY_CODE_F,
                      v_studentsRec.NATION_COUNTRY_CODE,
                      v_studentsRec.NATION_COUNTRY_CODE_F,
                      v_studentsRec.RESIDENCE_COUNTRY_CODE,
                      v_studentsRec.RESIDENCE_COUNTRY_CODE_F,
                      v_studentsRec.INST_NAME,
                      v_studentsRec.INST_NAME_F,
                      v_studentsRec.INST_CODE,
                      v_studentsRec.CRSE_NAME,
                      v_studentsRec.CRSE_NAME_F,
                      v_studentsRec.CRSE_CODE,
                      v_studentsRec.CRSE_YEAR_NO,
                      v_studentsRec.FIRST_DEP_SURNAME,
                      v_studentsRec.FIRST_DEP_FORENAMES,
                      v_studentsRec.FIRST_DEP_DOB,
                      v_studentsRec.FIRST_DEP_DOB_F,
                      v_studentsRec.FIRST_DEP_REL_TYPE,
                      v_studentsRec.FIRST_DEP_INCOME_CODE_1,
                      v_studentsRec.FIRST_DEP_INCOME_CODE_1_F,
                      v_studentsRec.FIRST_DEP_INCOME_AMOUNT_1,
                      v_studentsRec.FIRST_DEP_INCOME_AMOUNT_1_F,
                      v_studentsRec.FIRST_DEP_INCOME_CODE_2,
                      v_studentsRec.FIRST_DEP_INCOME_CODE_2_F,
                      v_studentsRec.FIRST_DEP_INCOME_AMOUNT_2,
                      v_studentsRec.FIRST_DEP_INCOME_AMOUNT_2_F,
                      v_studentsRec.FIRST_DEP_INCOME_CODE_3,
                      v_studentsRec.FIRST_DEP_INCOME_CODE_3_F,
                      v_studentsRec.FIRST_DEP_INCOME_AMOUNT_3,
                      v_studentsRec.FIRST_DEP_INCOME_AMOUNT_3_F,
                      v_studentsRec.SEC_DEP_SURNAME,
                      v_studentsRec.SEC_DEP_FORENAMES,
                      v_studentsRec.SEC_DEP_DOB,
                      v_studentsRec.SEC_DEP_DOB_F,
                      v_studentsRec.SEC_DEP_REL_TYPE,
                      v_studentsRec.SEC_DEP_INCOME_CODE_1,
                      v_studentsRec.SEC_DEP_INCOME_CODE_1_F,
                      v_studentsRec.SEC_DEP_INCOME_AMOUNT_1,
                      v_studentsRec.SEC_DEP_INCOME_AMOUNT_1_F,
                      v_studentsRec.SEC_DEP_INCOME_CODE_2,
                      v_studentsRec.SEC_DEP_INCOME_CODE_2_F,
                      v_studentsRec.SEC_DEP_INCOME_AMOUNT_2,
                      v_studentsRec.SEC_DEP_INCOME_AMOUNT_2_F,
                      v_studentsRec.SEC_DEP_INCOME_CODE_3,
                      v_studentsRec.SEC_DEP_INCOME_CODE_3_F,
                      v_studentsRec.SEC_DEP_INCOME_AMOUNT_3,
                      v_studentsRec.SEC_DEP_INCOME_AMOUNT_3_F,
                      v_studentsRec.THIRD_DEP_SURNAME,
                      v_studentsRec.THIRD_DEP_FORENAMES,
                      v_studentsRec.THIRD_DEP_DOB,
                      v_studentsRec.THIRD_DEP_DOB_F,
                      v_studentsRec.THIRD_DEP_REL_TYPE,
                      v_studentsRec.THIRD_DEP_INCOME_CODE_1,
                      v_studentsRec.THIRD_DEP_INCOME_CODE_1_F,
                      v_studentsRec.THIRD_DEP_INCOME_AMOUNT_1,
                      v_studentsRec.THIRD_DEP_INCOME_AMOUNT_1_F,
                      v_studentsRec.THIRD_DEP_INCOME_CODE_2,
                      v_studentsRec.THIRD_DEP_INCOME_CODE_2_F,
                      v_studentsRec.THIRD_DEP_INCOME_AMOUNT_2,
                      v_studentsRec.THIRD_DEP_INCOME_AMOUNT_2_F,
                      v_studentsRec.THIRD_DEP_INCOME_CODE_3,
                      v_studentsRec.THIRD_DEP_INCOME_CODE_3_F,
                      v_studentsRec.THIRD_DEP_INCOME_AMOUNT_3,
                      v_studentsRec.THIRD_DEP_INCOME_AMOUNT_3_F,
                      v_studentsRec.ADD_DEP_DETAILS,
                      v_studentsRec.LPCG,
                      v_studentsRec.TWO_HOMES_ALLOW,
                      v_studentsRec.VAC_GRANT,
                      v_studentsRec.NET_INCOME,
                      v_studentsRec.NET_INCOME_F,
                      v_studentsRec.PENSION_INCOME,
                      v_studentsRec.PENSION_INCOME_F,
                      v_studentsRec.TRUST_INCOME,
                      v_studentsRec.TRUST_INCOME_F,
                      v_studentsRec.AWARD_ORG,
                      v_studentsRec.ANNUAL_VALUE,
                      v_studentsRec.MAINTENANCE,
                      v_studentsRec.FEES,
                      v_studentsRec.LENGTH_OF_SUPPORT,
                      v_studentsRec.SUPPORT_START_DATE,
                      v_studentsRec.APP_FORM_SIG,
                      v_studentsRec.MAX_LOAN_REQUESTED,
                      v_studentsRec.LOAN_REQUEST,
                      v_studentsRec.LOAN_REQUEST_F,
                      v_studentsRec.CONT1_FORENAME,
                      v_studentsRec.CONT1_SURNAME,
                      v_studentsRec.CONT1_NAME,
                      v_studentsRec.CONT1_REL_CODE,
                      v_studentsRec.CONT1_HOUSE_NO_NM,
                      v_studentsRec.CONT1_POSTCODE,
                      v_studentsRec.CONT1_ADDR1,
                      v_studentsRec.CONT1_ADDR2,
                      v_studentsRec.CONT1_ADDR3,
                      v_studentsRec.CONT1_ADDR4,
                      v_studentsRec.CONT1_TEL_NO,
                      v_studentsRec.CONT2_FORENAME,
                      v_studentsRec.CONT2_SURNAME,
                      v_studentsRec.CONT2_NAME,
                      v_studentsRec.CONT2_HOUSE_NO_NM,
                      v_studentsRec.CONT2_POSTCODE,
                      v_studentsRec.CONT2_ADDR1,
                      v_studentsRec.CONT2_ADDR2,
                      v_studentsRec.CONT2_ADDR3,
                      v_studentsRec.CONT2_ADDR4,
                      v_studentsRec.CONT2_TEL_NO,
                      v_studentsRec.BANKRUPT_FLAG,
                      v_studentsRec.TERM_HOUSE_NO_NAME,
                      v_studentsRec.TERM_POST_CODE,
                      v_studentsRec.TERM_ADDR_L1,
                      v_studentsRec.TERM_ADDR_L2,
                      v_studentsRec.TERM_ADDR_L3,
                      v_studentsRec.TERM_ADDR_L4,
                      v_studentsRec.SLC_CORRES_DEST,
                      v_studentsRec.LOAN_SIGNATURE,
                      v_studentsRec.LOAN_DECLARATION_DATE,
                      v_studentsRec.LOAN_DECLARATION_DATE_F,
                      v_studentsRec.BEN1_NI_NO,
                      v_studentsRec.BEN1_NI_NO_F,
                      v_studentsRec.BEN1_TITLE,
                      v_studentsRec.BEN1_SURNAME,
                      v_studentsRec.BEN1_FORENAMES,
                      v_studentsRec.BEN1_REL_TYPE,
                      v_studentsRec.BEN1_HOUSE_NO_NAME,
                      v_studentsRec.BEN1_POSTCODE,
                      v_studentsRec.BEN1_ADDR1,
                      v_studentsRec.BEN1_ADDR2,
                      v_studentsRec.BEN1_ADDR3,
                      v_studentsRec.BEN1_ADDR4,
                      v_studentsRec.BEN1_EMP_STATUS,
                      v_studentsRec.BEN2_NI_NO,
                      v_studentsRec.BEN2_NI_NO_F,
                      v_studentsRec.BEN2_TITLE,
                      v_studentsRec.BEN2_SURNAME,
                      v_studentsRec.BEN2_FORENAMES,
                      v_studentsRec.BEN2_REL_TYPE,
                      v_studentsRec.BEN2_HOUSE_NO_NAME,
                      v_studentsRec.BEN2_POSTCODE,
                      v_studentsRec.BEN2_ADDR1,
                      v_studentsRec.BEN2_ADDR2,
                      v_studentsRec.BEN2_ADDR3,
                      v_studentsRec.BEN2_ADDR4,
                      v_studentsRec.BEN2_EMP_STATUS,
                      v_studentsRec.JA_CASE,
                      v_studentsRec.BEN1_PAYE,
                      v_studentsRec.BEN1_PAYE_F,
                      v_studentsRec.BEN2_PAYE,
                      v_studentsRec.BEN2_PAYE_F,
                      v_studentsRec.BEN1_SELF_EMPLOYMENT,
                      v_studentsRec.BEN1_SELF_EMPLOYMENT_F,
                      v_studentsRec.BEN2_SELF_EMPLOYMENT,
                      v_studentsRec.BEN2_SELF_EMPLOYMENT_F,
                      v_studentsRec.BEN1_PROPERTY,
                      v_studentsRec.BEN1_PROPERTY_F,
                      v_studentsRec.BEN2_PROPERTY,
                      v_studentsRec.BEN2_PROPERTY_F,
                      v_studentsRec.BEN1_PENSIONS,
                      v_studentsRec.BEN1_PENSIONS_F,
                      v_studentsRec.BEN2_PENSIONS,
                      v_studentsRec.BEN2_PENSIONS_F,
                      v_studentsRec.BEN1_BENEFITS,
                      v_studentsRec.BEN1_BENEFITS_F,
                      v_studentsRec.BEN2_BENEFITS,
                      v_studentsRec.BEN2_BENEFITS_F,
                      v_studentsRec.BEN1_NAT_SAVINGS,
                      v_studentsRec.BEN1_NAT_SAVINGS_F,
                      v_studentsRec.BEN2_NAT_SAVINGS,
                      v_studentsRec.BEN2_NAT_SAVINGS_F,
                      v_studentsRec.BEN1_INTEREST,
                      v_studentsRec.BEN1_INTEREST_F,
                      v_studentsRec.BEN2_INTEREST,
                      v_studentsRec.BEN2_INTEREST_F,
                      v_studentsRec.BEN1_DIVIDEND,
                      v_studentsRec.BEN1_DIVIDEND_F,
                      v_studentsRec.BEN2_DIVIDEND,
                      v_studentsRec.BEN2_DIVIDEND_F,
                      v_studentsRec.BEN1_OTHER_INC,
                      v_studentsRec.BEN1_OTHER_INC_F,
                      v_studentsRec.BEN2_OTHER_INC,
                      v_studentsRec.BEN2_OTHER_INC_F,
                      v_studentsRec.BEN1_SUPERANN,
                      v_studentsRec.BEN1_SUPERANN_F,
                      v_studentsRec.BEN2_SUPERANN,
                      v_studentsRec.BEN2_SUPERANN_F,
                      v_studentsRec.BEN1_RAP,
                      v_studentsRec.BEN1_RAP_F,
                      v_studentsRec.BEN2_RAP,
                      v_studentsRec.BEN2_RAP_F,
                      v_studentsRec.BEN1_OTHER_DED,
                      v_studentsRec.BEN1_OTHER_DED_F,
                      v_studentsRec.BEN2_OTHER_DED,
                      v_studentsRec.BEN2_OTHER_DED_F,
                      v_studentsRec.BEN1_FIRST_DEP_DOB,
                      v_studentsRec.BEN1_FIRST_DEP_DOB_F,
                      v_studentsRec.BEN1_SEC_DEP_DOB,
                      v_studentsRec.BEN1_SEC_DEP_DOB_F,
                      v_studentsRec.BEN1_THIRD_DEP_DOB,
                      v_studentsRec.BEN1_THIRD_DEP_DOB_F,
                      v_studentsRec.DOMESTIC_HELP,
                      v_studentsRec.BEN_DEC_SIG,
                      v_studentsRec.EXTRA_NOTES,
                      v_studentsRec.OUT_UK,
                      v_studentsRec.FAST_TRACK,
                      v_studentsRec.RES_QUERY,
                      v_studentsRec.ARA_SENT,
                      v_studentsRec.BIRTH_CERT_FLAG,
                      v_studentsRec.OFFER_FLAG,
                      v_studentsRec.REPEAT_YEAR,
                      v_date_app_rec,
                      v_studentsRec.EMP_LOGIN,
                      v_studentsRec.APP_FORM_SIG_DATE,
                      v_studentsRec.PGCE,
                      v_studentsRec.DSA,
                      v_studentsRec.TOT_TRAV_AMOUNT_CLAIMED,
                      v_studentsRec.TOT_TRAV_AMOUNT_CLAIMED_F,
                      v_studentsRec.MOBILE_TEL_NO,
                      v_studentsRec.HOME_ADDR_MAIL_SORT,
                      v_studentsRec.BEN1_MAIL_SORT,
                      v_studentsRec.BEN2_MAIL_SORT,
                      v_email,
                      v_portal_user_id,
                      v_studentsRec.BANK_VALIDATE,
                      v_studentsRec.EMAIL_ADDR_F,
                      v_studentsRec.TERM_TIME_RESIDENCE,
                      v_studentsRec.TERM_TIME_RESIDENCE_F,
                      v_studentsRec.RELEVANT_DATE,
                      v_studentsRec.RELEVANT_DATE_F,
                      v_studentsRec.ORDIN_RES_UK_3_YEARS,
                      v_studentsRec.ORDIN_RES_UK_3_YEARS_F,
                      v_studentsRec.ORDIN_RES_SCOT_REL_DATE,
                      v_studentsRec.ORDIN_RES_SCOT_REL_DATE_F,
                      v_studentsRec.IN_EDUC_SINCE_LEAVE_SCHOOL,
                      v_studentsRec.IN_EDUC_SINCE_LEAVE_SCHOOL_F,
                      v_studentsRec.EU_GRADUATE,
                      v_studentsRec.EU_GRADUATE_F,
                      v_studentsRec.STUDY_ABROAD,
                      v_studentsRec.STUDY_ABROAD_F,
                      v_studentsRec.PLACEMENT_YEAR,
                      v_studentsRec.PLACEMENT_YEAR_F,
                      v_studentsRec.SECONDARY_OR_PRIMARY_ED,
                      v_studentsRec.SECONDARY_OR_PRIMARY_ED_F,
                      v_studentsRec.SECONDARY_SUBJECT,
                      v_studentsRec.SECONDARY_SUBJECT_F,
                      v_studentsRec.EXEMPT_FROM_PARENT_CONTRIB,
                      v_studentsRec.EXEMPT_FROM_PARENT_CONTRIB_F,
                      v_studentsRec.PLAN_TO_WORK_OUTSIDE_UK,
                      v_studentsRec.PLAN_TO_WORK_OUTSIDE_UK_F,
                      v_studentsRec.BEN1_FIRST_DEP_LAST_NAME,
                      v_studentsRec.BEN1_FIRST_DEP_LAST_NAME_F,
                      v_studentsRec.BEN1_FIRST_DEP_FIRST_NAME,
                      v_studentsRec.BEN1_FIRST_DEP_FIRST_NAME_F,
                      v_studentsRec.BEN1_FIRST_DEP_LEAVE_SCHOOL,
                      v_studentsRec.BEN1_FIRST_DEP_LEAVE_SCHOOL_F,
                      v_studentsRec.BEN1_SEC_DEP_LAST_NAME,
                      v_studentsRec.BEN1_SEC_DEP_LAST_NAME_F,
                      v_studentsRec.BEN1_SEC_DEP_FIRST_NAME,
                      v_studentsRec.BEN1_SEC_DEP_FIRST_NAME_F,
                      v_studentsRec.BEN1_SEC_DEP_LEAVE_SCHOOL,
                      v_studentsRec.BEN1_SEC_DEP_LEAVE_SCHOOL_F,
                      v_studentsRec.BEN1_THIRD_DEP_LAST_NAME,
                      v_studentsRec.BEN1_THIRD_DEP_LAST_NAME_F,
                      v_studentsRec.BEN1_THIRD_DEP_FIRST_NAME,
                      v_studentsRec.BEN1_THIRD_DEP_FIRST_NAME_F,
                      v_studentsRec.BEN1_THIRD_DEP_LEAVE_SCHOOL,
                      v_studentsRec.BEN1_THIRD_DEP_LEAVE_SCHOOL_F,
                      v_studentsRec.EU_STUDENT,
                      v_studentsRec.NOS_YEARS_COURSE_TAKES,
                      v_studentsRec.ORD_RES_SCOTLAND_WEB,
                      v_studentsRec.ORD_RES_UK_WEB,
                      v_studentsRec.MAX_FEE_LOAN,
                      v_studentsRec.FEE_LOAN_AMOUNT,
                      v_studentsRec.FEE_LOAN_CHARGED_AMOUNT,
                      v_studentsRec.DEP_GRANT,
                      v_studentsRec.LPG,
                      v_studentsRec.MORE_THAN_3_BEN_DEPS,
                      v_studentsRec.MIGRANT_WORKER,
                      v_studentsRec.SPOUSE_OF_MIGRANT_WORKER,
                      v_studentsRec.PLAN_TO_WORK_DURING_CRSE,
                      v_studentsRec.STUDY_FT_OR_PT,
                      v_studentsRec.STUDY_FT_OR_PT_F,
                      v_studentsRec.BEN1_WORKING_TAX_CREDIT,
                      v_studentsRec.BEN1_EMP_SUPPORT_ALLOWANCE,
                      v_studentsRec.BEN1_INCAPACITY_BENEFIT,
                      v_studentsRec.BEN1_INCOME_SUPPORT,
                      v_studentsRec.BEN1_INVALIDITY_BENEFIT,
                      v_studentsRec.BEN1_JOBSEEKERS_ALLOWANCE,
                      v_studentsRec.BEN1_MAINTENANCE_PAYMENT,
                      v_studentsRec.BEN2_WORKING_TAX_CREDIT,
                      v_studentsRec.BEN2_EMP_SUPPORT_ALLOWANCE,
                      v_studentsRec.BEN2_INCAPACITY_BENEFIT,
                      v_studentsRec.BEN2_INCOME_SUPPORT,
                      v_studentsRec.BEN2_INVALIDITY_BENEFIT,
                      v_studentsRec.BEN2_JOBSEEKERS_ALLOWANCE,
                      v_studentsRec.BEN2_MAINTENANCE_PAYMENT,
                      v_studentsRec.STUD_INCOME,
                      v_studentsRec.AB36,
                      v_studentsRec.SKILLS_DEV_DATA_SHARE,
                      v_studentsRec.RESIDENCE_IND,
                      v_studentsRec.WORKING_TAX_CREDIT_IND,
                      v_studentsRec.EMPLOYMENT_SUPPORT_ALLOWANCE,
                      v_studentsRec.INCAPACITY_BENEFIT,
                      v_studentsRec.INCOME_SUPPORT,
                      v_studentsRec.INVALIDITY_BENEFIT,
                      v_studentsRec.JOBSEEKERS_ALLOWANCE,
                      v_studentsRec.UK_PASSPORT,
                      v_studentsRec.PASSPORT_NUMBER,
                      v_studentsRec.PASSPORT_FIRST_NAMES,
                      v_studentsRec.PASSPORT_SURNAME,
                      v_studentsRec.PASSPORT_ISSUE_DATE,
                      v_studentsRec.PASSPORT_EXPIRY_DATE,
                      v_studentsRec.UK_BIRTH_CNTRY_CODE,
                      v_studentsRec.TUITION_FEES,
                      v_studentsRec.MAINTENANCE_GRANT,
                      v_studentsRec.BURSARY_ONLY,
                      v_studentsRec.INCOME_ASSESSED_LOAN,
                      v_studentsRec.NON_INCOME_ASSESSED_LOAN,
                      v_studentsRec.YSB,
                      v_studentsRec.YSB_OUTSIDE_SCOTLAND,
                      v_studentsRec.HEALTHCARE_FUNDING,
                      v_studentsRec.CLAIMING_DSA,
                      v_studentsRec.INSIDE_OUTSIDE_SCOTLAND,
                      v_studentsRec.INSCOT_YEAR,
                      v_studentsRec.CONSENT_FROM_STUDENT,
                      v_studentsRec.CONSENT_FROM_FATHER,
                      v_studentsRec.CONSENT_FROM_MOTHER,
                      v_studentsRec.CONSENT_FROM_HUSBAND_WIFE,
                      v_studentsRec.STUD_INCOME_AMT1,
                      v_studentsRec.STUD_INCOME_TYPE1,
                      v_studentsRec.STUD_INCOME_AMT2,
                      v_studentsRec.STUD_INCOME_TYPE2,
                      v_studentsRec.STUD_INCOME_AMT3,
                      v_studentsRec.STUD_INCOME_TYPE3,
                      v_studentsRec.STUD_INCOME_AMT4,
                      v_studentsRec.STUD_INCOME_TYPE4,
                      v_studentsRec.STUD_INCOME_AMT5,
                      v_studentsRec.STUD_INCOME_TYPE5,
                      v_studentsRec.STUD_INCOME_AMT6,
                      v_studentsRec.STUD_INCOME_TYPE6,
                      v_studentsRec.REASON_NO_INCOME_BEN1,
                      v_studentsRec.REASON_NO_INCOME_BEN2,
                      v_studentsRec.HEI_CONSENT,
                      v_studentsRec.CARE_LEAVER,
                      v_studentsRec.DUAL_NATIONALITY,
                      v_studentsRec.BEN1_HEI_CONSENT,
                      v_studentsRec.BEN2_HEI_CONSENT,
                      v_studentsRec.BEN1_AB36,
                      v_studentsRec.BEN2_AB36,
                      v_studentsRec.ONLY_ONE_BEN,
                      v_studentsRec.REASON_FOR_ONE_BEN_ID,
                      v_studentsRec.PSAS_PT,
                      v_studentsRec.BEN1_OTHER_INC_DETAILS,
                      v_studentsRec.BEN2_OTHER_INC_DETAILS,
                      v_studentsRec.CONT1_CONSENT,
                      v_studentsRec.CONT2_CONSENT,
                      v_studentsRec.INTERRUPTION_FROM_STUDY,
                      v_studentsRec.IS_INDEPENDENT,
                      v_studentsRec.RESIDENCY_CATEGORY,
                      v_studentsRec.BEN1_CONSENT_TO_SHARE_STUDENT,
                      v_studentsRec.BEN2_CONSENT_TO_SHARE_STUDENT,
                      v_studentsRec.INDEPENDENT,
                      v_studentsRec.ORPHAN,
                      v_studentsRec.OVER_25,
                      v_studentsRec.CARE_EXP_FOSTER,
                      v_studentsRec.CARE_EXP_RES,
                      v_studentsRec.CARE_EXP_KINSHIP_LA,
                      v_studentsRec.CARE_EXP_KINSHIP_NO_LA,
                      v_studentsRec.CARE_EXP_HOME,
                      v_studentsRec.CARE_EXP_OTHER,
                      v_studentsRec.CARE_EXP_OTHER_DETAILS,
                      v_studentsRec.CARE_EXP_START_AGE,
                      v_studentsRec.CARE_EXP_END_AGE,
                      v_studentsRec.START_DATE_ABROAD,
                      v_studentsRec.END_DATE_ABROAD,
                      v_studentsRec.BEN1_EMAIL_ADDR,
                      v_studentsRec.BEN2_EMAIL_ADDR,
                      v_studentsRec.PG_ED_PSYCH_GRANT,
                      v_studentsRec.PG_ED_PSYCH_FEES,
                      v_studentsRec.PG_ED_PSYCH_QEPS,
                      v_studentsRec.PG_ED_PSYCH_DECLARATION,
                      v_studentsRec.ESTRANGED,
                      v_studentsRec.CONTINUINGTHREEYEARSORMORE,
                      v_studentsRec.COMPLEX_RESIDENCY,
                      v_studentsRec.EU_SETTLED_STATUS,
                      v_studentsRec.EU_SETTLED_STATUS_CONFIRMED,
                      v_studentsRec.TOP_OPTION,
                      v_studentsRec.EU_RESIDENCE_TYPE);



         INSERT INTO EDM.EDM_TEMP (OBJECT_ID,
                                   SESSION_CODE,
                                   DOCUMENT_TYPE_CODE,
                                   DOCUMENT_NAME,
                                   DOCUMENT_TYPE_COUNT,
                                   ATTACHMENT_TYPE_CODE)
              VALUES (v_temp,
                      v_session_code,
                      v_document_type_code,
                      v_document_name,
                      1,
                      'PDF');



         INSERT INTO EDM.EDM_COMPLETE (OBJECT_ID,
                                       BATCH_TYPE_CODE,
                                       STUD_REF_NO,
                                       BATCH_ID,
                                       ENVELOPE_ID,
                                       SCAN_DATE,
                                       PROC_ERROR,
                                       URGENT)
              VALUES (v_temp,
                      v_batch_code,
                      v_stud_ref_no,
                      NULL,
                      NULL,
                      SYSDATE,
                      'N',
                      'N');


         /* Update x by 1, this is used for the counter in the report */
         x := x + 1;

         /* Update y by 1, this ensures that a unique object_id is created each time */

         y := y + 1;

         /* Update TEST_STUDENT_MESSAGES to show the reference number of each case */

         UPDATE EDM.TEST_STUDENT_MESSAGES
            SET STUD_REF_NO = v_stud_ref_no
          WHERE RAW_DATA_CASE_ID = v_studentsRec.case_id;

         /* Report each case that is created */

         DBMS_OUTPUT.PUT_LINE (
               'Created Case ID '
            || v_studentsRec.case_id
            || ' as Student Reference Number '
            || v_stud_ref_no);



         COMMIT;
      END LOOP;



      DBMS_OUTPUT.PUT_LINE ('Created ' || x || ' Applications');


      /* Write this value back to the original table so that unique object_id's case be created the next time this is run */

      UPDATE EDM.TEST_STUDENT_MESSAGES
         SET MESSAGE = y
       WHERE CASE_ID = 0;



      COMMIT;



      CLOSE c_students;
   END SubmitTestAutoCalcApplications;
END SAAS_TEST_DATA;
/