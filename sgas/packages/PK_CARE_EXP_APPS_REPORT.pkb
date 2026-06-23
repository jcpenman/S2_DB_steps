CREATE OR REPLACE PACKAGE BODY SGAS.pk_care_exp_apps_report
AS
   /******************************************************************************
      NAME:       pk_care_exp_apps_report
      PURPOSE:    To populate the care_experienced_apps_report table with the
                  data needed for the Care Experience report.

      REVISIONS:
      Ver        Date        Author                    Description
      ---------  ----------  ---------------           ------------------------------------
      1.0        20/04/2017  James Baird               Initial version
   ******************************************************************************/



   /******************************************************************************
      NAME:       get_default_from_date
      PURPOSE:   This willreturn the date based on the current session.
   ******************************************************************************/
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

   /******************************************************************************
      NAME:       populate_report_table
      PURPOSE:   This will populate the care_experienced_apps_report table.
     with new data from OLS and STEPS.

   ******************************************************************************/
   PROCEDURE populate_report_table
   IS
      v_session_code         NUMBER;
      v_OLS_session_code     NUMBER;
      v_STEPS_session_code   NUMBER;
      v_ols_exists           VARCHAR2 (1);
      v_steps_exists         VARCHAR2 (1);
   BEGIN
   EXECUTE IMMEDIATE 'truncate table care_experienced_apps_report REUSE STORAGE';
      SELECT nval
        INTO v_session_code
        FROM CONFIG_DATA cd
       WHERE CD.ITEM_NAME = 'CURRENT_SESSION';

      BEGIN
         SELECT 'Y'
           INTO v_ols_exists
           FROM DUAL
          WHERE EXISTS
                   (SELECT 1
                      FROM care_experienced_apps_report r
                     WHERE r.source = 'OLS');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_ols_exists := 'N';
      END;

      IF NVL (v_ols_exists, 'N') = 'Y'
      THEN
         v_OLS_session_code := v_session_code;
      ELSE
         v_session_code := NULL;
      END IF;

      BEGIN
         SELECT 'Y'
           INTO v_steps_exists
           FROM DUAL
          WHERE EXISTS
                   (SELECT 1
                      FROM care_experienced_apps_report r
                     WHERE r.source = 'STEPS');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_steps_exists := 'N';
      END;

      IF NVL (v_steps_exists, 'N') = 'Y'
      THEN
         v_steps_session_code := v_session_code;
      ELSE
         v_session_code := NULL;
      END IF;

      insert_from_OLS (v_OLS_session_code);
      insert_from_STEPS (v_STEPS_session_code);
      update_from_STEPS (v_STEPS_session_code);
      update_from_STEPS_CESB();
      
   END populate_report_table;

   /******************************************************************************
      NAME:       insert_from_OLS
      PURPOSE:   This will populate the care_experienced_apps_report table
     with new data from OLS.

   ******************************************************************************/
   PROCEDURE insert_from_OLS (session_code_in IN NUMBER)
   IS
   BEGIN
      IF session_code_in IS NULL
      THEN
         INSERT INTO care_experienced_apps_report (SOURCE,
                                                   STUD_REF_NO,
                                                   APPLICATION_ID,
                                                   DATE_APPLICATION_RECEIVED,
                                                   SESSION_CODE,
                                                   DOB,
                                                   INST_CODE,
                                                   INST_NAME,
                                                   CRSE_CODE,
                                                   CRSE_NAME,
                                                   CRSE_YEAR_NO,
                                                   CARE_EXPERIENCED_OLS,
                                                   ACCOMODATION_GRANT,
                                                   CARE_EXPERIENCED_STEPS,
                                                   NATION_COUNTRY_CODE,
                                                   NATION_COUNTRY,
                                                   BIRTH_COUNTRY_CODE,
                                                   BIRTH_COUNTRY,
                                                   APPLICATION_STATUS)
            SELECT 'OLS' source,
                   C.STUD_REF_NO,
                   C.APPLICATION_ID,
                   C.WEB_SUBMITTED "Date Application Received",
                   C.SESSION_CODE,
                   C.DOB,
                   C.INST_CODE,
                   C.INST_NAME,
                   C.CRSE_CODE,
                   C.CRSE_NAME,
                   C.CRSE_YEAR_NO,
                   NVL (
                      (SELECT MAX ('Y')
                         FROM sas_claims@web cl
                        WHERE     cl.application_id = c.application_id
                              AND cl.care_leaver = 'Y'),
                      'N')
                      care_experienced_ols,
                   NVL (
                      (SELECT MAX ('Y')
                         FROM sas_claims@web cl
                        WHERE     cl.application_id = c.application_id
                              AND cl.vacation = 'Y'),
                      'N')
                      accomodation_grant,
                   NULL care_experienced_steps,
                   C.NATION_COUNTRY_CODE,
                   N.NATIONALITY_NAME NATION_COUNTRY,
                   C.BIRTH_COUNTRY_CODE,
                   B.NATIONALITY_NAME BIRTH_COUNTRY,
                   NVL (M.DESCRIPT, C.STATUS) application_status
              FROM COMPLETE_WEB_APPLICATIONS$TEST@web C,
                   COUNTRY@web N,
                   COUNTRY@web B,
                   CASE_STATUS M
             WHERE     C.CARE_LEAVER = 'Y'
                   AND C.NATION_COUNTRY_CODE = N.COUNTRY_CODE(+)
                   AND C.BIRTH_COUNTRY_CODE = B.COUNTRY_CODE(+)
                   AND C.STATUS = M.LEGACY_CODE(+)
                   AND NOT EXISTS
                              (SELECT 1
                                 FROM care_experienced_apps_report r
                                WHERE     r.source = 'OLS'
                                      AND r.stud_ref_no = c.stud_ref_no
                                      AND r.application_id = c.application_id
                                      AND r.session_code = c.session_code);
      ELSE
         INSERT INTO care_experienced_apps_report (SOURCE,
                                                   STUD_REF_NO,
                                                   APPLICATION_ID,
                                                   DATE_APPLICATION_RECEIVED,
                                                   SESSION_CODE,
                                                   DOB,
                                                   INST_CODE,
                                                   INST_NAME,
                                                   CRSE_CODE,
                                                   CRSE_NAME,
                                                   CRSE_YEAR_NO,
                                                   CARE_EXPERIENCED_OLS,
                                                   ACCOMODATION_GRANT,
                                                   CARE_EXPERIENCED_STEPS,
                                                   NATION_COUNTRY_CODE,
                                                   NATION_COUNTRY,
                                                   BIRTH_COUNTRY_CODE,
                                                   BIRTH_COUNTRY,
                                                   APPLICATION_STATUS)
            SELECT 'OLS' source,
                   C.STUD_REF_NO,
                   C.APPLICATION_ID,
                   C.WEB_SUBMITTED "Date Application Received",
                   C.SESSION_CODE,
                   C.DOB,
                   C.INST_CODE,
                   C.INST_NAME,
                   C.CRSE_CODE,
                   C.CRSE_NAME,
                   C.CRSE_YEAR_NO,
                   NVL (
                      (SELECT MAX ('Y')
                         FROM sas_claims@web cl
                        WHERE     cl.application_id = c.application_id
                              AND cl.care_leaver = 'Y'),
                      'N')
                      care_experienced_ols,
                   NVL (
                      (SELECT MAX ('Y')
                         FROM sas_claims@web cl
                        WHERE     cl.application_id = c.application_id
                              AND cl.vacation = 'Y'),
                      'N')
                      accomodation_grant,
                   NULL care_experienced_steps,
                   C.NATION_COUNTRY_CODE,
                   N.NATIONALITY_NAME NATION_COUNTRY,
                   C.BIRTH_COUNTRY_CODE,
                   B.NATIONALITY_NAME BIRTH_COUNTRY,
                   NVL (M.DESCRIPT, C.STATUS) application_status
              FROM COMPLETE_WEB_APPLICATIONS$TEST@web C,
                   COUNTRY@web N,
                   COUNTRY@web B,
                   CASE_STATUS M
             WHERE     C.CARE_LEAVER = 'Y'
                   AND C.NATION_COUNTRY_CODE = N.COUNTRY_CODE(+)
                   AND C.BIRTH_COUNTRY_CODE = B.COUNTRY_CODE(+)
                   AND C.STATUS = M.LEGACY_CODE(+)
                   AND C.SESSION_CODE = session_code_in
                   AND NOT EXISTS
                              (SELECT 1
                                 FROM care_experienced_apps_report r
                                WHERE     r.source = 'OLS'
                                      AND r.stud_ref_no = c.stud_ref_no
                                      AND r.application_id = c.application_id
                                      AND r.session_code = c.session_code);
      END IF;

      COMMIT;
   END insert_from_OLS;

   /******************************************************************************
      NAME:       insert_from_STEPS
      PURPOSE:   This will populate the care_experienced_apps_report table
     with new data from STEPS.

   ******************************************************************************/
   PROCEDURE insert_from_STEPS (session_code_in IN NUMBER)
   IS
   BEGIN
      IF session_code_in IS NULL
      THEN
         INSERT INTO care_experienced_apps_report (SOURCE,
                                                   STUD_REF_NO,
                                                   APPLICATION_ID,
                                                   DATE_APPLICATION_RECEIVED,
                                                   SESSION_CODE,
                                                   DOB,
                                                   INST_CODE,
                                                   INST_NAME,
                                                   CRSE_CODE,
                                                   CRSE_NAME,
                                                   CRSE_YEAR_NO,
                                                   CARE_EXPERIENCED_OLS,
                                                   ACCOMODATION_GRANT,
                                                   CARE_EXPERIENCED_STEPS,
                                                   NATION_COUNTRY_CODE,
                                                   NATION_COUNTRY,
                                                   BIRTH_COUNTRY_CODE,
                                                   BIRTH_COUNTRY,
                                                   APPLICATION_STATUS)
            SELECT 'STEPS' SOURCE,
                   S.STUD_REF_NO,
                   NULL APPLICATION_ID,
                   SS.DATE_APPLIC_RECEIVED DATE_APPLICATION_RECEIVED,
                   SCY.SESSION_CODE,
                   S.DOB,
                   SCY.INST_CODE,
                   SCY.INST_NAME,
                   SCY.CRSE_CODE,
                   SCY.CRSE_NAME,
                   SCY.CRSE_YEAR_NO,
                   NULL CARE_EXPERIENCED_OLS,
                   NULL ACCOMODATION_GRANT,
                   'Y' CARE_EXPERIENCED_STEPS,
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
                   CASE_STATUS M,
                   CESB_FLAGS CF
             WHERE     SCY.LATEST_CRSE_IND = 'Y'
                   AND SCY.STUD_REF_NO = S.STUD_REF_NO
                   AND SCY.STUD_SESSION_ID = SS.STUD_SESSION_ID
                   AND S.STUD_REF_NO = CF.STUD_REF_NO(+)
                   --AND NVL (SS.CARE_LEAVER, 'N') = 'Y'
                   AND ((NVL (SS.CARE_LEAVER, 'N') = 'Y') OR CF.CARE_EXP_START_AGE IS NOT NULL)
                   AND S.NATION_COUNTRY_CODE = N.COUNTRY_CODE(+)
                   AND S.BIRTH_COUNTRY_CODE = B.COUNTRY_CODE(+)
                   AND SCY.APPLICATION_STATUS = M.LEGACY_CODE(+)
                   AND NOT EXISTS
                              (SELECT 1
                                 FROM care_experienced_apps_report r
                                WHERE     r.source = 'STEPS'
                                      AND r.stud_ref_no = scy.stud_ref_no
                                      AND r.session_code = scy.session_code);
           INSERT INTO care_experienced_apps_report (SOURCE,
                                                   STUD_REF_NO,
                                                   APPLICATION_ID,
                                                   DATE_APPLICATION_RECEIVED,
                                                   SESSION_CODE,
                                                   DOB,
                                                   INST_CODE,
                                                   INST_NAME,
                                                   CRSE_CODE,
                                                   CRSE_NAME,
                                                   CRSE_YEAR_NO,
                                                   CARE_EXPERIENCED_OLS,
                                                   ACCOMODATION_GRANT,
                                                   CARE_EXPERIENCED_STEPS,
                                                   NATION_COUNTRY_CODE,
                                                   NATION_COUNTRY,
                                                   BIRTH_COUNTRY_CODE,
                                                   BIRTH_COUNTRY,
                                                   APPLICATION_STATUS)
            SELECT 'STEPS' SOURCE,
                   S.STUD_REF_NO,
                   NULL APPLICATION_ID,
                   SS.DATE_APPLIC_RECEIVED DATE_APPLICATION_RECEIVED,
                   SCY.SESSION_CODE,
                   S.DOB,
                   SCY.INST_CODE,
                   SCY.INST_NAME,
                   SCY.CRSE_CODE,
                   SCY.CRSE_NAME,
                   SCY.CRSE_YEAR_NO,
                   NULL CARE_EXPERIENCED_OLS,
                   NULL ACCOMODATION_GRANT,
                   NVL (SS.CARE_LEAVER, 'N') CARE_EXPERIENCED_STEPS,
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
                   AND S.NATION_COUNTRY_CODE = N.COUNTRY_CODE(+)
                   AND S.BIRTH_COUNTRY_CODE = B.COUNTRY_CODE(+)
                   AND SCY.APPLICATION_STATUS = M.LEGACY_CODE(+)
                   AND NOT EXISTS
                              (SELECT 1
                                 FROM care_experienced_apps_report r
                                WHERE     r.source = 'STEPS'
                                      AND r.stud_ref_no = scy.stud_ref_no
                                      AND r.session_code = scy.session_code)
                   AND EXISTS
                          (SELECT 1
                             FROM care_experienced_apps_report r
                            WHERE     r.source = 'OLS'
                                  AND r.stud_ref_no = scy.stud_ref_no
                                  AND r.session_code = scy.session_code);
      ELSE
         INSERT INTO care_experienced_apps_report (SOURCE,
                                                   STUD_REF_NO,
                                                   APPLICATION_ID,
                                                   DATE_APPLICATION_RECEIVED,
                                                   SESSION_CODE,
                                                   DOB,
                                                   INST_CODE,
                                                   INST_NAME,
                                                   CRSE_CODE,
                                                   CRSE_NAME,
                                                   CRSE_YEAR_NO,
                                                   CARE_EXPERIENCED_OLS,
                                                   ACCOMODATION_GRANT,
                                                   CARE_EXPERIENCED_STEPS,
                                                   NATION_COUNTRY_CODE,
                                                   NATION_COUNTRY,
                                                   BIRTH_COUNTRY_CODE,
                                                   BIRTH_COUNTRY,
                                                   APPLICATION_STATUS)
            SELECT 'STEPS' SOURCE,
                   S.STUD_REF_NO,
                   NULL APPLICATION_ID,
                   SS.DATE_APPLIC_RECEIVED DATE_APPLICATION_RECEIVED,
                   SCY.SESSION_CODE,
                   S.DOB,
                   SCY.INST_CODE,
                   SCY.INST_NAME,
                   SCY.CRSE_CODE,
                   SCY.CRSE_NAME,
                   SCY.CRSE_YEAR_NO,
                   NULL CARE_EXPERIENCED_OLS,
                   NULL ACCOMODATION_GRANT,
                   'Y' CARE_EXPERIENCED_STEPS,
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
                   CASE_STATUS M,
                   CESB_FLAGS CF
             WHERE     SCY.LATEST_CRSE_IND = 'Y'
                   AND SCY.STUD_REF_NO = S.STUD_REF_NO
                   AND SCY.STUD_SESSION_ID = SS.STUD_SESSION_ID
                   AND S.STUD_REF_NO = CF.STUD_REF_NO(+)
                   --AND NVL (SS.CARE_LEAVER, 'N') = 'Y'
                   AND ((NVL (SS.CARE_LEAVER, 'N') = 'Y') OR CF.CARE_EXP_START_AGE IS NOT NULL)
                   AND SCY.SESSION_CODE = session_code_in
                   AND S.NATION_COUNTRY_CODE = N.COUNTRY_CODE(+)
                   AND S.BIRTH_COUNTRY_CODE = B.COUNTRY_CODE(+)
                   AND SCY.APPLICATION_STATUS = M.LEGACY_CODE(+)
                   AND NOT EXISTS
                              (SELECT 1
                                 FROM care_experienced_apps_report r
                                WHERE     r.source = 'STEPS'
                                      AND r.stud_ref_no = scy.stud_ref_no
                                      AND r.session_code = scy.session_code);
           INSERT INTO care_experienced_apps_report (SOURCE,
                                                   STUD_REF_NO,
                                                   APPLICATION_ID,
                                                   DATE_APPLICATION_RECEIVED,
                                                   SESSION_CODE,
                                                   DOB,
                                                   INST_CODE,
                                                   INST_NAME,
                                                   CRSE_CODE,
                                                   CRSE_NAME,
                                                   CRSE_YEAR_NO,
                                                   CARE_EXPERIENCED_OLS,
                                                   ACCOMODATION_GRANT,
                                                   CARE_EXPERIENCED_STEPS,
                                                   NATION_COUNTRY_CODE,
                                                   NATION_COUNTRY,
                                                   BIRTH_COUNTRY_CODE,
                                                   BIRTH_COUNTRY,
                                                   APPLICATION_STATUS)
            SELECT 'STEPS' SOURCE,
                   S.STUD_REF_NO,
                   NULL APPLICATION_ID,
                   SS.DATE_APPLIC_RECEIVED DATE_APPLICATION_RECEIVED,
                   SCY.SESSION_CODE,
                   S.DOB,
                   SCY.INST_CODE,
                   SCY.INST_NAME,
                   SCY.CRSE_CODE,
                   SCY.CRSE_NAME,
                   SCY.CRSE_YEAR_NO,
                   NULL CARE_EXPERIENCED_OLS,
                   NULL ACCOMODATION_GRANT,
                   NVL (SS.CARE_LEAVER, 'N') CARE_EXPERIENCED_STEPS,
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
                   AND SCY.SESSION_CODE = session_code_in
                   AND SCY.STUD_REF_NO = S.STUD_REF_NO
                   AND SCY.STUD_SESSION_ID = SS.STUD_SESSION_ID
                   AND S.NATION_COUNTRY_CODE = N.COUNTRY_CODE(+)
                   AND S.BIRTH_COUNTRY_CODE = B.COUNTRY_CODE(+)
                   AND SCY.APPLICATION_STATUS = M.LEGACY_CODE(+)
                   AND NOT EXISTS
                              (SELECT 1
                                 FROM care_experienced_apps_report r
                                WHERE     r.source = 'STEPS'
                                      AND r.stud_ref_no = scy.stud_ref_no
                                      AND r.session_code = scy.session_code)
                   AND EXISTS
                          (SELECT 1
                             FROM care_experienced_apps_report r
                            WHERE     r.source = 'OLS'
                                  AND r.stud_ref_no = scy.stud_ref_no
                                  AND r.session_code = scy.session_code);
      END IF;

      COMMIT;
   END insert_from_STEPS;

   /******************************************************************************
      NAME:       update_from_STEPS
      PURPOSE:   This will update the care_experienced_apps_report table
     with changed data from STEPS.

   ******************************************************************************/
   PROCEDURE update_from_STEPS (session_code_in IN NUMBER)
   IS
   BEGIN
      IF session_code_in IS NOT NULL
      THEN
         UPDATE care_experienced_apps_report r
            SET (DATE_APPLICATION_RECEIVED,
                 r.CARE_EXPERIENCED_STEPS,
                 r.DOB,
                 r.INST_CODE,
                 r.INST_NAME,
                 r.CRSE_CODE,
                 r.CRSE_NAME,
                 r.CRSE_YEAR_NO,
                 r.APPLICATION_STATUS) =
                   (SELECT SS.DATE_APPLIC_RECEIVED DATE_APPLICATION_RECEIVED,
                           NVL (SS.CARE_LEAVER, 'N') CARE_EXPERIENCED_STEPS,
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
                           AND r.source = 'STEPS'
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
                               AND r.source = 'STEPS'
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
                                    OR NVL (r.CARE_EXPERIENCED_STEPS, 'X') !=
                                          NVL (SS.CARE_LEAVER, 'X')
                                    OR NVL (r.INST_CODE, 'X') !=
                                          NVL (SCY.INST_CODE, 'X')
                                    OR NVL (r.CRSE_CODE, 'X') !=
                                          NVL (SCY.CRSE_CODE, 'X')
                                    OR NVL (r.CRSE_YEAR_NO, -1) !=
                                          NVL (SCY.CRSE_YEAR_NO, -1)));

         UPDATE care_experienced_apps_report r
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
                      FROM V_CARE_EXPERIENCED_AWARDS A
                     WHERE     r.stud_ref_no = A.stud_ref_no
                           AND r.session_code = A.session_code)
          WHERE     r.source = 'STEPS'
                AND R.SESSION_CODE = session_code_in
                AND EXISTS
                       (SELECT 1
                          FROM V_CARE_EXPERIENCED_AWARDS A1
                         WHERE     r.source = 'STEPS'
                               AND r.stud_ref_no = A1.stud_ref_no
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
         UPDATE care_experienced_apps_report r
            SET (DATE_APPLICATION_RECEIVED,
                 r.CARE_EXPERIENCED_STEPS,
                 r.DOB,
                 r.INST_CODE,
                 r.INST_NAME,
                 r.CRSE_CODE,
                 r.CRSE_NAME,
                 r.CRSE_YEAR_NO,
                 r.APPLICATION_STATUS) =
                   (SELECT SS.DATE_APPLIC_RECEIVED DATE_APPLICATION_RECEIVED,
                           NVL (SS.CARE_LEAVER, 'N') CARE_EXPERIENCED_STEPS,
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
                           AND r.source = 'STEPS'
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
                           AND r.source = 'STEPS'
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
                                OR NVL (r.CARE_EXPERIENCED_STEPS, 'X') !=
                                      NVL (SS.CARE_LEAVER, 'X')
                                OR NVL (r.INST_CODE, 'X') !=
                                      NVL (SCY.INST_CODE, 'X')
                                OR NVL (r.CRSE_CODE, 'X') !=
                                      NVL (SCY.CRSE_CODE, 'X')
                                OR NVL (r.CRSE_YEAR_NO, -1) !=
                                      NVL (SCY.CRSE_YEAR_NO, -1)));

         UPDATE care_experienced_apps_report r
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
                      FROM V_CARE_EXPERIENCED_AWARDS A
                     WHERE     r.stud_ref_no = A.stud_ref_no
                           AND r.session_code = A.session_code)
          WHERE     r.source = 'STEPS'
                AND EXISTS
                       (SELECT 1
                          FROM V_CARE_EXPERIENCED_AWARDS A1
                         WHERE     r.source = 'STEPS'
                               AND r.stud_ref_no = A1.stud_ref_no
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
   END update_from_STEPS;
   
   
    /******************************************************************************
      NAME:       update_from_STEPS_cesb
      PURPOSE:   This will update the care_experienced_apps_report table
     with LATEST cesb FLAGS FROM CESB_FLAGS TABLE.

   ******************************************************************************/
   PROCEDURE update_from_STEPS_CESB 
   IS
   BEGIN
   
   UPDATE care_experienced_apps_report r
            SET (R.CARE_EXP_FOSTER,
                R.CARE_EXP_HOME,
                R.CARE_EXP_KINSHIP_LA,
                R.CARE_EXP_KINSHIP_NO_LA,
                R.CARE_EXP_OTHER,
                R.CARE_EXP_OTHER_DETAILS,
                R.CARE_EXP_RES,
                R.CESB_EVI_RECVD) = 
                (SELECT 
                CF.CARE_EXP_FOSTER,
                CF.CARE_EXP_HOME,
                CF.CARE_EXP_KINSHIP_LA,
                CF.CARE_EXP_KINSHIP_NO_LA,
                CF.CARE_EXP_OTHER,
                CF.CARE_EXP_OTHER_DETAILS,
                CF.CARE_EXP_RES,
                S.CARE_EXP_EVIDENCE_RECVD
                
                FROM cesb_flags cf, stud s
                
                WHERE CF.STUD_REF_NO=R.STUD_REF_NO
                AND S.STUD_REF_NO=R.STUD_REF_NO
                );
     
   COMMIT;
   END update_from_STEPS_CESB;
   
END pk_care_exp_apps_report;
/