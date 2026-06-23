CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_ESTRANGED_STUD_REPORT
AS
   /******************************************************************************************
      NAME:       PK_STEPS_ESTRANGED_STUD_REPORT
      PURPOSE:    To populate the ESTRANGED_STUD_REPORT table with the required data

      REVISIONS:
      Ver        Date        Author                    Description
      ---------  ----------  ---------------           -----------------------------
      1.0        12/12/2017  Ranj Benning              Initial version
   ******************************************************************************************/

   /******************************************************************************************
      NAME:      get_default_from_date
      PURPOSE:   This will return the date based on the current session
   ******************************************************************************************/
   FUNCTION get_default_from_date
      RETURN DATE
   IS
      v_return_date   DATE;
   BEGIN
      SELECT TO_DATE ('01/04/' || cval, 'dd/mm/yyyy') return_date
        INTO v_return_date
        FROM CONFIG_DATA cd
       WHERE CD.ITEM_NAME = 'CURRENT_SESSION';

      RETURN NVL (v_return_date, TO_DATE ('01/04/2017', 'dd/mm/yyyy'));
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN TO_DATE ('01/04/2017', 'dd/mm/yyyy');
   END get_default_from_date;

   /******************************************************************************************
      NAME:      populate_report_table
      PURPOSE:   This will populate the ESTRANGED_STUD_REPORT table with new data from STEPS
   ******************************************************************************************/
   PROCEDURE populate_report_table
   IS
      v_session_code         NUMBER;
      v_STEPS_session_code   NUMBER;
   BEGIN
   EXECUTE IMMEDIATE 'truncate table ESTRANGED_STUD_REPORT REUSE STORAGE';
      SELECT nval
        INTO v_session_code
        FROM CONFIG_DATA cd
       WHERE CD.ITEM_NAME = 'CURRENT_SESSION';

      insert_estranged_records (v_STEPS_session_code);
      update_estranged_records (v_STEPS_session_code);
   END populate_report_table;

   /******************************************************************************************
      NAME:      insert_estranged_records
      PURPOSE:   This will insert records into the ESTRANGED_STUD_REPORT table
   ******************************************************************************************/
   PROCEDURE insert_estranged_records (session_code_in IN NUMBER)
   IS
   BEGIN
      IF session_code_in IS NULL
      THEN
         INSERT INTO ESTRANGED_STUD_REPORT (STUD_REF_NO,
                                                   DATE_APPLICATION_RECEIVED,
                                                   SESSION_CODE,
                                                   DOB,
                                                   INST_CODE,
                                                   INST_NAME,
                                                   CRSE_CODE,
                                                   CRSE_NAME,
                                                   CRSE_YEAR_NO,
                                                   NATION_COUNTRY_CODE,
                                                   NATION_COUNTRY,
                                                   BIRTH_COUNTRY_CODE,
                                                   BIRTH_COUNTRY,
                                                   APPLICATION_STATUS)
            SELECT S.STUD_REF_NO,
                   SS.DATE_APPLIC_RECEIVED DATE_APPLICATION_RECEIVED,
                   SCY.SESSION_CODE,
                   S.DOB,
                   SCY.INST_CODE,
                   SCY.INST_NAME,
                   SCY.CRSE_CODE,
                   SCY.CRSE_NAME,
                   SCY.CRSE_YEAR_NO,
                   S.NATION_COUNTRY_CODE,
                   N.NATIONALITY_NAME NATION_COUNTRY,
                   S.BIRTH_COUNTRY_CODE,
                   B.NATIONALITY_NAME BIRTH_COUNTRY,
                   NVL (M.DESCRIPT, SCY.APPLICATION_STATUS)
                      application_status
              FROM STUD_CRSE_YEAR SCY,
                   STUD S,
                   STUD_SESSION SS,
                   COUNTRY N,
                   COUNTRY B,
                   CASE_STATUS M
             WHERE     SCY.LATEST_CRSE_IND = 'Y'
                   AND SCY.STUD_REF_NO = S.STUD_REF_NO
                   AND SCY.STUD_SESSION_ID = SS.STUD_SESSION_ID
                   AND NVL (S.ESTRANGED, 'N') = 'Y'
                   AND S.NATION_COUNTRY_CODE = N.COUNTRY_CODE(+)
                   AND S.BIRTH_COUNTRY_CODE = B.COUNTRY_CODE(+)
                   AND SCY.APPLICATION_STATUS = M.LEGACY_CODE(+);
      ELSE
         INSERT INTO ESTRANGED_STUD_REPORT (STUD_REF_NO,
                                                   DATE_APPLICATION_RECEIVED,
                                                   SESSION_CODE,
                                                   DOB,
                                                   INST_CODE,
                                                   INST_NAME,
                                                   CRSE_CODE,
                                                   CRSE_NAME,
                                                   CRSE_YEAR_NO,
                                                   NATION_COUNTRY_CODE,
                                                   NATION_COUNTRY,
                                                   BIRTH_COUNTRY_CODE,
                                                   BIRTH_COUNTRY,
                                                   APPLICATION_STATUS)
            SELECT S.STUD_REF_NO,
                   SS.DATE_APPLIC_RECEIVED DATE_APPLICATION_RECEIVED,
                   SCY.SESSION_CODE,
                   S.DOB,
                   SCY.INST_CODE,
                   SCY.INST_NAME,
                   SCY.CRSE_CODE,
                   SCY.CRSE_NAME,
                   SCY.CRSE_YEAR_NO,
                   S.NATION_COUNTRY_CODE,
                   N.NATIONALITY_NAME NATION_COUNTRY,
                   S.BIRTH_COUNTRY_CODE,
                   B.NATIONALITY_NAME BIRTH_COUNTRY,
                   NVL (M.DESCRIPT, SCY.APPLICATION_STATUS)
                      application_status
              FROM STUD_CRSE_YEAR SCY,
                   STUD S,
                   STUD_SESSION SS,
                   COUNTRY N,
                   COUNTRY B,
                   CASE_STATUS M
             WHERE     SCY.LATEST_CRSE_IND = 'Y'
                   AND SCY.STUD_REF_NO = S.STUD_REF_NO
                   AND SCY.STUD_SESSION_ID = SS.STUD_SESSION_ID                   
                   AND NVL (S.ESTRANGED, 'N') = 'Y'                   
                   AND SCY.SESSION_CODE = session_code_in
                   AND S.NATION_COUNTRY_CODE = N.COUNTRY_CODE(+)
                   AND S.BIRTH_COUNTRY_CODE = B.COUNTRY_CODE(+)
                   AND SCY.APPLICATION_STATUS = M.LEGACY_CODE(+);
       END IF;
      COMMIT;
   END insert_estranged_records;
 
   /******************************************************************************************
      NAME:      update_estranged_records
      PURPOSE:   This will update records in the ESTRANGED_STUD_REPORT table
   ******************************************************************************************/   
   PROCEDURE update_estranged_records (session_code_in IN NUMBER)
   IS
   BEGIN
      IF session_code_in IS NOT NULL
      THEN
         UPDATE ESTRANGED_STUD_REPORT r
            SET (DATE_APPLICATION_RECEIVED,
                 r.DOB,
                 r.INST_CODE,
                 r.INST_NAME,
                 r.CRSE_CODE,
                 r.CRSE_NAME,
                 r.CRSE_YEAR_NO,
                 r.APPLICATION_STATUS) =
                   (SELECT SS.DATE_APPLIC_RECEIVED DATE_APPLICATION_RECEIVED,
                           S.DOB,
                           SCY.INST_CODE,
                           SCY.INST_NAME,
                           SCY.CRSE_CODE,
                           SCY.CRSE_NAME,
                           SCY.CRSE_YEAR_NO,
                           NVL (M.DESCRIPT, SCY.APPLICATION_STATUS)
                              application_status
                      FROM STUD_CRSE_YEAR SCY,
                           STUD S,
                           STUD_SESSION SS,
                           CASE_STATUS M
                     WHERE     SCY.LATEST_CRSE_IND = 'Y'
                           AND SCY.STUD_REF_NO = S.STUD_REF_NO
                           AND SCY.STUD_SESSION_ID = SS.STUD_SESSION_ID
                           AND SCY.APPLICATION_STATUS = M.LEGACY_CODE(+)                         
                           AND r.stud_ref_no = scy.stud_ref_no
                           AND r.session_code = scy.session_code)
          WHERE     R.SESSION_CODE = session_code_in
                AND EXISTS
                       (SELECT 1
                          FROM STUD_CRSE_YEAR SCY,
                               STUD S,
                               STUD_SESSION SS,
                               CASE_STATUS M
                         WHERE     SCY.LATEST_CRSE_IND = 'Y'
                               AND SCY.STUD_REF_NO = S.STUD_REF_NO
                               AND SCY.STUD_SESSION_ID = SS.STUD_SESSION_ID
                               AND r.stud_ref_no = scy.stud_ref_no
                               AND r.session_code = scy.session_code
                               AND SCY.APPLICATION_STATUS = M.LEGACY_CODE(+)
                               AND (   NVL (r.DATE_APPLICATION_RECEIVED,
                                            SYSDATE + 5) !=
                                          NVL (SS.DATE_APPLIC_RECEIVED,
                                               SYSDATE + 5)
                                    OR r.DOB != S.DOB
                                    OR r.APPLICATION_STATUS !=
                                          NVL (M.DESCRIPT,
                                               SCY.APPLICATION_STATUS)                                    
                                    OR NVL (r.INST_CODE, 'X') !=
                                          NVL (SCY.INST_CODE, 'X')
                                    OR NVL (r.CRSE_CODE, 'X') !=
                                          NVL (SCY.CRSE_CODE, 'X')
                                    OR NVL (r.CRSE_YEAR_NO, -1) !=
                                          NVL (SCY.CRSE_YEAR_NO, -1)));

         UPDATE ESTRANGED_STUD_REPORT r
            SET (r.FEES,
                 r.CESB,
                 r.ISB,
                 r.YSB,
                 r.UGLOAN,
                 r.UGOA,
                 r.UGDA,
                 r.UGDSA,
                 r.PGLOAN,
                 r.SNB,
                 r.SNCAP,
                 r.SNDA,
                 r.SNIE,
                 r.SNSPA,
                 r.TFEL,
                 r.OTHER_AWARD_TYPE) =
                   (SELECT A.FEES,
                           A.CESB,
                           A.ISB,
                           A.YSB,
                           A.UGLOAN,
                           A.UGOA,
                           A.UGDA,
                           A.UGDSA,
                           A.PGLOAN,
                           A.SNB,
                           A.SNCAP,
                           A.SNDA,
                           A.SNIE,
                           A.SNSPA,
                           A.TFEL,
                           A.OTHER_AWARD_TYPE
                      FROM V_AWARDS_REPORT A
                     WHERE     r.stud_ref_no = A.stud_ref_no
                           AND r.session_code = A.session_code)
          WHERE     R.SESSION_CODE = session_code_in
                AND EXISTS
                       (SELECT 1
                          FROM V_AWARDS_REPORT A1
                         WHERE     r.stud_ref_no = A1.stud_ref_no
                               AND r.session_code = A1.session_code
                               AND (   NVL (r.FEES, 999) !=
                                          NVL (A1.FEES, 999)
                                    OR NVL (r.CESB, 999) !=
                                          NVL (A1.CESB, 999)
                                    OR NVL (r.ISB, 999) != NVL (A1.ISB, 999)
                                    OR NVL (r.YSB, 999) != NVL (A1.YSB, 999)
                                    OR NVL (r.UGLOAN, 999) !=
                                          NVL (A1.UGLOAN, 999)
                                    OR NVL (r.UGOA, 999) !=
                                          NVL (A1.UGOA, 999)
                                    OR NVL (r.UGDA, 999) !=
                                          NVL (A1.UGDA, 999)
                                    OR NVL (r.UGDSA, 999) !=
                                          NVL (A1.UGDSA, 999)
                                    OR NVL (r.PGLOAN, 999) !=
                                          NVL (A1.PGLOAN, 999)
                                    OR NVL (r.SNB, 999) != NVL (A1.SNB, 999)
                                    OR NVL (r.SNCAP, 999) !=
                                          NVL (A1.SNCAP, 999)
                                    OR NVL (r.SNDA, 999) !=
                                          NVL (A1.SNDA, 999)
                                    OR NVL (r.SNIE, 999) !=
                                          NVL (A1.SNIE, 999)
                                    OR NVL (r.SNSPA, 999) !=
                                          NVL (A1.SNSPA, 999)
                                    OR NVL (r.TFEL, 999) !=
                                          NVL (A1.TFEL, 999)
                                    OR NVL (r.OTHER_AWARD_TYPE, 999) !=
                                          NVL (A1.OTHER_AWARD_TYPE, 999)));
      ELSE
         UPDATE ESTRANGED_STUD_REPORT r
            SET (DATE_APPLICATION_RECEIVED,
                 r.DOB,
                 r.INST_CODE,
                 r.INST_NAME,
                 r.CRSE_CODE,
                 r.CRSE_NAME,
                 r.CRSE_YEAR_NO,
                 r.APPLICATION_STATUS) =
                   (SELECT SS.DATE_APPLIC_RECEIVED DATE_APPLICATION_RECEIVED,
                           S.DOB,
                           SCY.INST_CODE,
                           SCY.INST_NAME,
                           SCY.CRSE_CODE,
                           SCY.CRSE_NAME,
                           SCY.CRSE_YEAR_NO,
                           NVL (M.DESCRIPT, SCY.APPLICATION_STATUS)
                              application_status
                      FROM STUD_CRSE_YEAR SCY,
                           STUD S,
                           STUD_SESSION SS,
                           CASE_STATUS M
                     WHERE     SCY.LATEST_CRSE_IND = 'Y'
                           AND SCY.STUD_REF_NO = S.STUD_REF_NO
                           AND SCY.STUD_SESSION_ID = SS.STUD_SESSION_ID
                           AND SCY.APPLICATION_STATUS = M.LEGACY_CODE(+)
                           AND r.stud_ref_no = scy.stud_ref_no
                           AND r.session_code = scy.session_code)
          WHERE EXISTS
                   (SELECT 1
                      FROM STUD_CRSE_YEAR SCY,
                           STUD S,
                           STUD_SESSION SS,
                           CASE_STATUS M
                     WHERE     SCY.LATEST_CRSE_IND = 'Y'
                           AND SCY.STUD_REF_NO = S.STUD_REF_NO
                           AND SCY.STUD_SESSION_ID = SS.STUD_SESSION_ID
                           AND r.stud_ref_no = scy.stud_ref_no
                           AND r.session_code = scy.session_code
                           AND SCY.APPLICATION_STATUS = M.LEGACY_CODE(+)
                           AND (   NVL (r.DATE_APPLICATION_RECEIVED,
                                        SYSDATE + 5) !=
                                      NVL (SS.DATE_APPLIC_RECEIVED,
                                           SYSDATE + 5)
                                OR r.DOB != S.DOB
                                OR r.APPLICATION_STATUS !=
                                      NVL (M.DESCRIPT,
                                           SCY.APPLICATION_STATUS)
                                OR NVL (r.INST_CODE, 'X') !=
                                      NVL (SCY.INST_CODE, 'X')
                                OR NVL (r.CRSE_CODE, 'X') !=
                                      NVL (SCY.CRSE_CODE, 'X')
                                OR NVL (r.CRSE_YEAR_NO, -1) !=
                                      NVL (SCY.CRSE_YEAR_NO, -1)));

         UPDATE ESTRANGED_STUD_REPORT r
            SET (r.FEES,
                 r.CESB,
                 r.ISB,
                 r.YSB,
                 r.UGLOAN,
                 r.UGOA,
                 r.UGDA,
                 r.UGDSA,
                 r.PGLOAN,
                 r.SNB,
                 r.SNCAP,
                 r.SNDA,
                 r.SNIE,
                 r.SNSPA,
                 r.TFEL,
                 r.OTHER_AWARD_TYPE) =
                   (SELECT A.FEES,
                           A.CESB,
                           A.ISB,
                           A.YSB,
                           A.UGLOAN,
                           A.UGOA,
                           A.UGDA,
                           A.UGDSA,
                           A.PGLOAN,
                           A.SNB,
                           A.SNCAP,
                           A.SNDA,
                           A.SNIE,
                           A.SNSPA,
                           A.TFEL,
                           A.OTHER_AWARD_TYPE
                      FROM V_AWARDS_REPORT A
                     WHERE     r.stud_ref_no = A.stud_ref_no
                           AND r.session_code = A.session_code)
          WHERE     EXISTS
                       (SELECT 1
                          FROM V_AWARDS_REPORT A1
                         WHERE     r.stud_ref_no = A1.stud_ref_no
                               AND r.session_code = A1.session_code
                               AND (   NVL (r.FEES, 999) !=
                                          NVL (A1.FEES, 999)
                                    OR NVL (r.CESB, 999) !=
                                          NVL (A1.CESB, 999)
                                    OR NVL (r.ISB, 999) != NVL (A1.ISB, 999)
                                    OR NVL (r.YSB, 999) != NVL (A1.YSB, 999)
                                    OR NVL (r.UGLOAN, 999) !=
                                          NVL (A1.UGLOAN, 999)
                                    OR NVL (r.UGOA, 999) !=
                                          NVL (A1.UGOA, 999)
                                    OR NVL (r.UGDA, 999) !=
                                          NVL (A1.UGDA, 999)
                                    OR NVL (r.UGDSA, 999) !=
                                          NVL (A1.UGDSA, 999)
                                    OR NVL (r.PGLOAN, 999) !=
                                          NVL (A1.PGLOAN, 999)
                                    OR NVL (r.SNB, 999) != NVL (A1.SNB, 999)
                                    OR NVL (r.SNCAP, 999) !=
                                          NVL (A1.SNCAP, 999)
                                    OR NVL (r.SNDA, 999) !=
                                          NVL (A1.SNDA, 999)
                                    OR NVL (r.SNIE, 999) !=
                                          NVL (A1.SNIE, 999)
                                    OR NVL (r.SNSPA, 999) !=
                                          NVL (A1.SNSPA, 999)
                                    OR NVL (r.TFEL, 999) !=
                                          NVL (A1.TFEL, 999)
                                    OR NVL (r.OTHER_AWARD_TYPE, 999) !=
                                          NVL (A1.OTHER_AWARD_TYPE, 999)));
      END IF;
      COMMIT;
   END update_estranged_records;     
      
END PK_STEPS_ESTRANGED_STUD_REPORT;
/