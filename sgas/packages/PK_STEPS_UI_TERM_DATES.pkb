CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_UI_TERM_DATES
AS
   PROCEDURE getdd_campus_List (instCode_in     IN     VARCHAR2,
                                io_cursor          OUT TERM_DATES_CURSOR,
                                error_boolean      OUT VARCHAR2,
                                ERROR_TEXT         OUT VARCHAR2)
   AS
      dd_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN dd_cursor FOR
           SELECT campus_id, name
             FROM campus
            WHERE inst_code = UPPER (instCode_in)
         ORDER BY 1;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_campus_List;


   PROCEDURE getdd_inst_location (io_cursor       OUT TERM_DATES_CURSOR,
                                  error_boolean   OUT VARCHAR2,
                                  ERROR_TEXT      OUT VARCHAR2)
   AS
      dd_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN dd_cursor FOR
           SELECT INST_LOCATION.INST_LOCATION_ID, INST_LOCATION.DESCRIPT
             FROM inst_location
         ORDER BY 1;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_inst_location;


   PROCEDURE getdd_inst_type (io_cursor       OUT TERM_DATES_CURSOR,
                              error_boolean   OUT VARCHAR2,
                              ERROR_TEXT      OUT VARCHAR2)
   AS
      dd_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN dd_cursor FOR
           SELECT *
             FROM SGAS.INSTITUTE_TYPES
         ORDER BY 1;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_inst_type;


   PROCEDURE getdd_subj_cat (io_cursor       OUT TERM_DATES_CURSOR,
                             error_boolean   OUT VARCHAR2,
                             ERROR_TEXT      OUT VARCHAR2)
   AS
      dd_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN dd_cursor FOR
           SELECT *
             FROM COURSE_SUBJECT_CATEGORY
         ORDER BY 1;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_subj_cat;


   PROCEDURE getdd_Qual_List (io_cursor       OUT TERM_DATES_CURSOR,
                              error_boolean   OUT VARCHAR2,
                              ERROR_TEXT      OUT VARCHAR2)
   AS
      dd_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN dd_cursor FOR
           SELECT description AS key, description AS label
             FROM qual_types
         ORDER BY 1;

      io_cursor := dd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'ERROR';
   END getdd_Qual_List;


   PROCEDURE getCampusDetails (
      campusCode_in   IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      campusdetails_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN campusdetails_cursor FOR
         SELECT CAMPUS.CAMPUS_CODE,
                CAMPUS.NAME,
                CAMPUS.POSTCODE,
                CAMPUS.HOUSE_NO_NAME,
                CAMPUS.ADDR_L1,
                CAMPUS.ADDR_L2,
                CAMPUS.ADDR_L3,
                CAMPUS.ADDR_L4,
                CAMPUS.PAYMENT_METHOD,
                CAMPUS.BANK_NAME,
                CAMPUS.BANK_POST_CODE,
                CAMPUS.BANK_HOUSE_NO_NAME,
                CAMPUS.BANK_ADDR_L1,
                CAMPUS.BANK_ADDR_L2,
                CAMPUS.BANK_ADDR_L3,
                CAMPUS.BANK_ADDR_L4,
                CAMPUS.BANK_SORT_CODE,
                CAMPUS.ACCOUNT_NO
           FROM campus
          WHERE CAMPUS.CAMPUS_ID = campusCode_in;

      io_cursor := campusdetails_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCampusDetails;


   PROCEDURE getCourseDetails (instCode_in     IN            VARCHAR2,
                               crseCode_in     IN            VARCHAR2,
                               io_cursor       IN OUT        TERM_DATES_CURSOR,
                               error_boolean      OUT NOCOPY VARCHAR2,
                               ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      courseDetails_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN courseDetails_cursor FOR
         SELECT CRSE.CRSE_ID,
                CRSE.CRSE_CODE,
                CRSE.CRSE_NAME,
                CRSE.HEI_CRSE_CODE,
                CRSE.SCHEME_TYPE,
                CRSE.SUBJECT_CAT_ID,
                (SELECT CATEGORY.DESCRIPT
                   FROM CATEGORY
                  WHERE CATEGORY.ID = CRSE.SUBJECT_CAT_ID)
                   AS SUBJECT_DESCRIPTION,
                CRSE.QUAL_TYPE,
                CRSE.FEES_CAMPUS,
                (SELECT NAME
                   FROM CAMPUS
                  WHERE CAMPUS_ID = CRSE.FEES_CAMPUS)
                   AS FEES_COMPUS_NAME,
                CRSE.MAINT_CAMPUS,
                (SELECT NAME
                   FROM CAMPUS
                  WHERE CAMPUS_ID = CRSE.MAINT_CAMPUS)
                   AS MAINT_CAMPUS_NAME,
                CRSE.PAMS_COURSE,
                CRSE.GRADUATE_APPRENTICE,
                CRSE.APPROVED,
                CRSE.DSA_ONLY
           FROM CRSE
          WHERE CRSE.CRSE_CODE = crseCode_in AND CRSE.INST_CODE = instCode_in;

      io_cursor := courseDetails_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCourseDetails;


   PROCEDURE getCourseList (instCode_in     IN            VARCHAR2,
                            io_cursor       IN OUT        TERM_DATES_CURSOR,
                            error_boolean      OUT NOCOPY VARCHAR2,
                            ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      courseList_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN courseList_cursor FOR
           SELECT CRSE.CRSE_CODE, CRSE.CRSE_NAME
             FROM CRSE
            WHERE INST_CODE = instCode_in
         ORDER BY 2;

      io_cursor := courseList_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCourseList;


   PROCEDURE getCourseSessionList (
      instCode_in     IN            VARCHAR2,
      crseCode_in     IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      courseSessionList_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN courseSessionList_cursor FOR
           SELECT session_code
             FROM crse_session
            WHERE crse_id IN (SELECT crse_id
                                FROM crse
                               WHERE     crse_code = crseCode_in
                                     AND inst_code = instCode_in)
         ORDER BY 1 DESC;

      io_cursor := courseSessionList_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCourseSessionList;


   PROCEDURE getCrseTermDates (
      instCode_in      IN            VARCHAR2,
      sessionCode_in   IN            VARCHAR2,
      crseCode_in      IN            VARCHAR2,
      crseYearNo_in    IN            VARCHAR2,
      io_cursor        IN OUT        TERM_DATES_CURSOR,
      error_boolean       OUT NOCOPY VARCHAR2,
      ERROR_TEXT          OUT NOCOPY VARCHAR2)
   IS
      crsetermdates_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN crsetermdates_cursor FOR
           SELECT crse_year_id,
                  term_no,
                  days,
                  start_date,
                  end_date
             FROM crse_term ct
            WHERE ct.crse_year_id IN (SELECT crse_year_id
                                        FROM crse_year cy
                                       WHERE     cy.crse_id =
                                                    (SELECT crse_id
                                                       FROM crse
                                                      WHERE     crse_code =
                                                                   crseCode_in
                                                            AND inst_code =
                                                                   instCode_in
                                                            AND crse_year_no =
                                                                   crseYearNo_in)
                                             AND crse_session_id =
                                                    (SELECT crse_session_id
                                                       FROM crse_session cs
                                                      WHERE     cs.session_code =
                                                                   sessionCode_in
                                                            AND cs.crse_id =
                                                                   (SELECT crse_id
                                                                      FROM crse
                                                                     WHERE     crse_code =
                                                                                  crseCode_in
                                                                           AND inst_code =
                                                                                  instCode_in)))
         ORDER BY term_no;

      io_cursor := crsetermdates_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCrseTermDates;


   PROCEDURE getCrseTermDetails (
      instCode_in               IN            VARCHAR2,
      sessionCode_in            IN            VARCHAR2,
      crseCode_in               IN            VARCHAR2,
      crseYearNo_in             IN            VARCHAR2,
      io_cursor                 IN OUT        TERM_DATES_CURSOR,
      noOfCrseTermChanges_out      OUT        VARCHAR2,
      error_boolean                OUT NOCOPY VARCHAR2,
      ERROR_TEXT                   OUT NOCOPY VARCHAR2)
   IS
      crsetermdetails_cursor   TERM_DATES_CURSOR;
      temp_crse_id             VARCHAR2 (9);
   BEGIN
      error_boolean := 'false';
      ERROR_TEXT := 'none';

      --  SELECT CRSE_ID
      SELECT NVL (CRSE_ID, 0)
        INTO temp_crse_id
        FROM CRSE
       WHERE CRSE_CODE = CRSECODE_IN AND INST_CODE = INSTCODE_IN;

      IF NVL (temp_crse_id, 0) > 0
      THEN
         OPEN crsetermdetails_cursor FOR
            SELECT ROWNUM, X.*
              FROM (SELECT TC.TERM_CHANGE_ID,
                           TC.ACADEMIC_YEAR CRSE_YEAR_NO,
                           TC.TERM TERM_NO,
                           TO_CHAR (TC.NEW_TERM_START, 'DD/MM/YYYY')
                              NEW_START_DATE,
                           TO_CHAR (TC.NEW_TERM_END, 'DD/MM/YYYY')
                              NEW_END_DATE,
                           TC.NEW_TERM_END - TC.NEW_TERM_START + 1 NEW_DAYS,
                           TO_CHAR (TC.OLD_TERM_START, 'DD/MM/YYYY')
                              OLD_START_DATE,
                           TO_CHAR (TC.OLD_TERM_END, 'DD/MM/YYYY')
                              OLD_END_DATE,
                           TC.OLD_TERM_END - TC.OLD_TERM_START + 1 OLD_DAYS,
                           TC.CHANGE_TYPE CHANGE_TYPE,
                           NULL CRSE_YEAR_ID
                      FROM SLCADMIN.TERM_CHANGE TC
                     WHERE     TC.STATUS = 'NEW'
                           AND TC.CREATED_BY != 'SLCADMIN'
                           AND TC.ACADEMIC_YEAR = crseYearNo_in
                           AND TC.SESSION_CODE = sessionCode_in
                           --AND TC.HEI_INST_CODE =
                           --       (SELECT HEI_INST_CODE
                           --          FROM INST
                           --         WHERE INST_CODE = instCode_in)
                           --AND TC.HEI_CRSE_CODE IN
                           --       (SELECT HEI_CRSE_CODE
                           --          FROM CRSE_YEAR
                           --         WHERE CRSE_ID IN
                           --                  (SELECT CRSE_ID
                           --                     FROM CRSE
                           --                    WHERE     INST_CODE =
                           --                                 instCode_in
                           --                          AND CRSE_CODE =
                           --                                 crseCode_in))
                           AND TC.CRSE_ID = temp_crse_id
                    UNION
                    SELECT NULL TERM_CHANGE_ID,
                           NULL CRSE_YEAR_NO,
                           TERM_NO TERM_NO,
                           TO_CHAR (START_DATE, 'DD/MM/YYYY') NEW_START_DATE,
                           TO_CHAR (END_DATE, 'DD/MM/YYYY') NEW_END_DATE,
                           DAYS NEW_DAYS,
                           NULL OLD_START_DATE,
                           NULL OLD_END_DATE,
                           NULL OLD_DAYS,
                           NULL CHANGE_TYPE,
                           CRSE_YEAR_ID CRSE_YEAR_ID
                      FROM CRSE_TERM CT
                     WHERE     CT.CRSE_YEAR_ID IN (SELECT CRSE_YEAR_ID
                                                     FROM CRSE_YEAR CY
                                                    WHERE     CY.CRSE_ID =
                                                                 temp_crse_id
                                                          AND CRSE_YEAR_NO =
                                                                 crseYearNo_in
                                                          AND CRSE_SESSION_ID =
                                                                 (SELECT CRSE_SESSION_ID
                                                                    FROM CRSE_SESSION CS
                                                                   WHERE     CS.SESSION_CODE =
                                                                                sessionCode_in
                                                                         AND CS.CRSE_ID =
                                                                                temp_crse_id))
                           AND TERM_NO NOT IN (SELECT TERM
                                                 FROM SLCADMIN.TERM_CHANGE TC
                                                WHERE     TC.STATUS = 'NEW'
                                                      AND TC.CREATED_BY !=
                                                             'SLCADMIN'
                                                      AND TC.ACADEMIC_YEAR =
                                                             crseYearNo_in
                                                      AND TC.SESSION_CODE =
                                                             sessionCode_in
                                                      --               AND TC.HEI_INST_CODE =
                                                      --                      (SELECT HEI_INST_CODE
                                                      --                         FROM INST
                                                      --                        WHERE INST_CODE =
                                                      --                                 instCode_in)
                                                      --               AND TC.HEI_CRSE_CODE IN
                                                      --                      (SELECT HEI_CRSE_CODE
                                                      --                         FROM CRSE_YEAR
                                                      --                        WHERE CRSE_ID IN
                                                      --                                 (SELECT CRSE_ID
                                                      --                                    FROM CRSE
                                                      --                                   WHERE     INST_CODE =
                                                      --                                                instCode_in
                                                      --                                         AND CRSE_CODE =
                                                      --                                                crseCode_in)))
                                                      AND TC.CRSE_ID =
                                                             temp_crse_id)
                    ORDER BY TERM_NO ASC) X;

         SELECT COUNT (*)
           INTO noOfCrseTermChanges_out
           FROM SLCADMIN.TERM_CHANGE TC
          WHERE     TC.STATUS = 'NEW'
                AND TC.CREATED_BY != 'SLCADMIN'
                AND TC.ACADEMIC_YEAR = crseYearNo_in
                AND TC.SESSION_CODE = sessionCode_in
                --AND TC.HEI_INST_CODE = (SELECT HEI_INST_CODE
                --                          FROM INST
                --                         WHERE INST_CODE = instCode_in)
                --AND TC.HEI_CRSE_CODE IN
                --       (SELECT HEI_CRSE_CODE
                --          FROM CRSE_YEAR
                --         WHERE CRSE_ID IN
                --                  (SELECT CRSE_ID
                --                     FROM CRSE
                --                    WHERE     INST_CODE = instCode_in
                --                          AND CRSE_CODE = crseCode_in));
                AND TC.CRSE_ID = temp_crse_id;
      ELSE
         noOfCrseTermChanges_out := 0;
         error_boolean := 'true';
         ERROR_TEXT := 'Course details could not be found';
      END IF;

      io_cursor := crsetermdetails_cursor;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCrseTermDetails;


   PROCEDURE getHEICrseCodeCount (instCode_in          IN     VARCHAR2,
                                  heiCrseCode_in       IN     VARCHAR2,
                                  crseId_in            IN     VARCHAR2,
                                  numMatchesDiffInst      OUT VARCHAR2,
                                  numMatchesSameInst      OUT VARCHAR2,
                                  error_boolean           OUT VARCHAR2,
                                  ERROR_TEXT              OUT VARCHAR2)
   IS
   BEGIN
      SELECT COUNT (*)
        INTO numMatchesDiffInst
        FROM CRSE C
       WHERE HEI_CRSE_CODE = heiCrseCode_in AND C.INST_CODE <> instCode_in;

      IF crseId_in IS NOT NULL
      THEN
         SELECT COUNT (*)
           INTO numMatchesSameInst
           FROM CRSE C
          WHERE     HEI_CRSE_CODE = heiCrseCode_in
                AND C.INST_CODE = instCode_in
                AND C.CRSE_ID != crseId_in;
      ELSE
         SELECT COUNT (*)
           INTO numMatchesSameInst
           FROM CRSE C
          WHERE HEI_CRSE_CODE = heiCrseCode_in AND C.INST_CODE = instCode_in;
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getHEICrseCodeCount;


   PROCEDURE getInstituteDetails (
      instCode_in     IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      instdetails_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN instdetails_cursor FOR
         SELECT INST.INST_CODE,
                INST.HEI_INST_CODE,
                INST.INST_NAME,
                INST.POST_CODE,
                INST.HOUSE_NO_OR_NAME,
                INST.ADDR_L1,
                INST.ADDR_L2,
                INST.ADDR_L3,
                INST.ADDR_L4,
                INST.TELE_NO,
                INST.INST_TYPE_ID,
                INST.PAYMENT_METHOD,
                INST.LOCATION_IND,
                INST.PAMS,
                INST.NON_PUBLIC_FUND,
                INST.DSA_ONLY
           FROM INST
          WHERE INST_CODE = instCode_in;

      io_cursor := instdetails_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getInstituteDetails;


   PROCEDURE getInstBankDetails (
      instCode_in     IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      instbankdetails_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN instbankdetails_cursor FOR
         SELECT INST.BANK_POST_CODE,
                INST.BANK_NAME,
                INST.BANK_HOUSE_NO_NAME,
                INST.BANK_ADDR_L1,
                INST.BANK_ADDR_L2,
                INST.BANK_ADDR_L3,
                INST.BANK_ADDR_L4,
                INST.BANK_SORT_CODE,
                INST.ACCOUNT_NO
           FROM inst
          WHERE inst_code = UPPER (instCode_in);

      io_cursor := instbankdetails_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getInstBankDetails;


   PROCEDURE getInstSessionList (
      instCode_in     IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      instSessionList_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN instSessionList_cursor FOR
         SELECT *
           FROM (  SELECT DISTINCT session_code
                     FROM inst_term
                    WHERE inst_code = UPPER (instCode_in)
                 ORDER BY 1 DESC)
          WHERE ROWNUM < 11;

      io_cursor := instSessionList_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getInstSessionList;


   PROCEDURE getInstTermDates (
      instCode_in              IN            VARCHAR2,
      sessionCode_in           IN            VARCHAR2,
      io_cursor                IN OUT        TERM_DATES_CURSOR,
      studInstTermsCount_out      OUT        VARCHAR2,
      error_boolean               OUT NOCOPY VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY VARCHAR2)
   IS
      termdates_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN termdates_cursor FOR
           SELECT SESSION_CODE,
                  TERM_NO,
                  START_DATE,
                  END_DATE,
                  DAYS
             FROM INST_TERM
            WHERE     INST_CODE = UPPER (instCode_in)
                  AND session_code = sessionCode_in
         ORDER BY SESSION_CODE, TERM_NO;

      io_cursor := termdates_cursor;
      studInstTermsCount_out := 0;

      SELECT COUNT (DISTINCT (STUD_REF_NO)) STUDENTS
        INTO studInstTermsCount_out
        FROM STUD_CRSE_YEAR SCY, CRSE_YEAR CY
       WHERE     SCY.INST_CODE = UPPER (instCode_in)
             AND SCY.SESSION_CODE = sessionCode_in
             AND SCY.CRSE_YEAR_ID = CY.CRSE_YEAR_ID
             AND CY.DEFAULT_TERMS = 'Y';

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getInstTermDates;


   PROCEDURE getInstTermDetails (
      instCode_in               IN            VARCHAR2,
      sessionCode_in            IN            VARCHAR2,
      io_cursor                 IN OUT        TERM_DATES_CURSOR,
      noOfInstTermChanges_out      OUT        VARCHAR2,
      error_boolean                OUT NOCOPY VARCHAR2,
      ERROR_TEXT                   OUT NOCOPY VARCHAR2)
   IS
      temp_session_id    VARCHAR2 (10);
      instTerms_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN instTerms_cursor FOR
         SELECT ROWNUM, X.*
           FROM (SELECT ITC.INST_CODE,
                        ITC.SESSION_CODE,
                        ITC.TERM_NO,
                        TO_CHAR (ITC.NEW_START_DATE, 'DD/MM/YYYY')
                           NEW_START_DATE,
                        TO_CHAR (ITC.NEW_END_DATE, 'DD/MM/YYYY') NEW_END_DATE,
                        ITC.NEW_DAYS,
                        TO_CHAR (IT.START_DATE, 'DD/MM/YYYY') OLD_START_DATE,
                        TO_CHAR (IT.END_DATE, 'DD/MM/YYYY') OLD_END_DATE,
                        IT.DAYS OLD_DAYS,
                        ITC.CHANGE_TYPE
                   FROM SLCADMIN.INST_TERM_CHANGE ITC, INST_TERM IT
                  WHERE     ITC.INST_CODE = UPPER (instCode_in)
                        AND ITC.SESSION_CODE = sessionCode_in
                        AND ITC.STATUS = 'NEW'
                        AND ITC.CREATED_BY != 'SLCADMIN'
                        --AND ITC.CHANGE_TYPE != 'D'
                        AND ITC.INST_CODE = IT.INST_CODE(+)
                        AND ITC.SESSION_CODE = IT.SESSION_CODE(+)
                        AND ITC.TERM_NO = IT.TERM_NO(+)
                 UNION ALL
                 SELECT IT.INST_CODE,
                        IT.SESSION_CODE,
                        IT.TERM_NO,
                        TO_CHAR (IT.START_DATE, 'DD/MM/YYYY') NEW_START_DATE,
                        TO_CHAR (IT.END_DATE, 'DD/MM/YYYY') NEW_END_DATE,
                        IT.DAYS NEW_DAYS,
                        NULL OLD_START_DATE,
                        NULL OLD_END_DATE,
                        NULL OLD_DAYS,
                        ITC.CHANGE_TYPE CHANGE_TYP
                   FROM INST_TERM IT, SLCADMIN.INST_TERM_CHANGE ITC
                  WHERE     IT.INST_CODE = UPPER (instCode_in)
                        AND IT.SESSION_CODE = sessionCode_in
                        AND IT.INST_CODE = ITC.INST_CODE(+)
                        AND IT.SESSION_CODE = ITC.SESSION_CODE(+)
                        AND IT.TERM_NO = ITC.TERM_NO(+)
                        AND 'D' = ITC.CHANGE_TYPE(+)
                        AND 'NEW' = ITC.STATUS(+)
                        AND 'SLCADMIN' != ITC.CREATED_BY(+)
                        AND IT.TERM_NO NOT IN (SELECT TERM_NO
                                                 FROM SLCADMIN.INST_TERM_CHANGE ITC
                                                WHERE     ITC.INST_CODE =
                                                             UPPER (
                                                                instCode_in)
                                                      AND ITC.SESSION_CODE =
                                                             sessionCode_in
                                                      AND ITC.STATUS = 'NEW'
                                                      AND ITC.CREATED_BY !=
                                                             'SLCADMIN')
                 ORDER BY 1,
                          2,
                          3,
                          4) X;

      SELECT COUNT (*)
        INTO noOfInstTermChanges_out
        FROM SLCADMIN.INST_TERM_CHANGE ITC
       WHERE     ITC.INST_CODE = UPPER (instCode_in)
             AND ITC.SESSION_CODE = sessionCode_in
             AND ITC.STATUS = 'NEW'
             AND ITC.CREATED_BY != 'SLCADMIN';

      io_cursor := instTerms_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getInstTermDetails;


   PROCEDURE getLatestSessionCode (instCode_in       IN            VARCHAR2,
                                   crseCode_in       IN            VARCHAR2,
                                   sessioncCodeOut      OUT        VARCHAR2,
                                   error_boolean        OUT NOCOPY VARCHAR2,
                                   ERROR_TEXT           OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      SELECT MAX (session_code)
        INTO sessioncCodeOut
        FROM crse_session
       WHERE crse_id IN (SELECT crse_id
                           FROM crse
                          WHERE     crse_code = crseCode_in
                                AND inst_code = instCode_in);

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getLatestSessionCode;


   PROCEDURE getSessionDetails (
      instCode_in                  IN            VARCHAR2,
      crseCode_in                  IN            VARCHAR2,
      sessionCode_in               IN            VARCHAR2,
      io_cursor                    IN OUT        TERM_DATES_CURSOR,
      max_duration                    OUT        VARCHAR2,
      studentsOnSessionCount_out      OUT        VARCHAR2,
      error_boolean                   OUT NOCOPY VARCHAR2,
      ERROR_TEXT                      OUT NOCOPY VARCHAR2)
   IS
      temp_session_id         VARCHAR2 (10);
      temp_crse_id            VARCHAR2 (9);
      sessionDetails_cursor   TERM_DATES_CURSOR;
   BEGIN
      SELECT MAX_DURATION
        INTO max_duration
        FROM crse_session CS
       WHERE     session_code = sessionCode_in
             AND crse_id =
                    (SELECT crse_id
                       FROM crse C
                      WHERE     crse_code = crseCode_in
                            AND inst_code = instCode_in);

      SELECT crse_id
        INTO temp_crse_id
        FROM crse C
       WHERE crse_code = crseCode_in AND inst_code = instCode_in;

      SELECT crse_session_id
        INTO temp_session_id
        FROM crse_session CS
       WHERE crse_id = temp_crse_id                      --    (SELECT crse_id
                                    --       FROM crse C
                                    --      WHERE     crse_code = crseCode_in
                                    --            AND inst_code = instCode_in)
             AND session_code = sessionCode_in;

      SELECT COUNT (*)
        INTO studentsOnSessionCount_out
        FROM STUD_CRSE_YEAR
       WHERE     INST_CODE = instCode_in
             AND CRSE_CODE = crseCode_in
             AND SESSION_CODE = sessionCode_in;

      OPEN sessionDetails_cursor FOR
         SELECT ROWNUM,
                CRSE_YEAR_ID,
                CRSE_YEAR_NO,
                STUDY_ABROAD,
                VAR_TUITION_FEE_AMNT AS VAR_AMOUNT,
                VAR_SANDWICH_TUITION_FEE_AMNT AS SANDWICH_AMOUNT,
                CUTOFF_TYPE,
                CUTOFF_DATE,
                DEFAULT_TERMS,
                EU_FLAG,
                EU_FEE_LOAN,
                HEI_CRSE_CODE,
                (SELECT COUNT (DISTINCT SCY.STUD_REF_NO) STUDENTS
                   FROM STUD_CRSE_YEAR SCY
                  WHERE SCY.CRSE_YEAR_ID = CY.CRSE_YEAR_ID)
                   STUDENTS,
                (SELECT COUNT (*)
                   FROM SLCADMIN.TERM_CHANGE TC
                  WHERE     TC.STATUS = 'NEW'
                        AND TC.CREATED_BY != 'SLCADMIN'
                        AND TC.ACADEMIC_YEAR = CRSE_YEAR_NO
                        AND TC.SESSION_CODE = sessionCode_in
                        AND TC.CRSE_ID = temp_crse_id)
                   --AND TC.HEI_INST_CODE =
                   --       (SELECT HEI_INST_CODE
                   --          FROM INST
                   --         WHERE INST_CODE = instCode_in)
                   --AND TC.HEI_CRSE_CODE IN
                   --       (SELECT HEI_CRSE_CODE
                   --          FROM CRSE_YEAR
                   --         WHERE CRSE_ID IN
                   --                  (SELECT CRSE_ID
                   --                     FROM CRSE
                   --                    WHERE     INST_CODE = instCode_in
                   --                          AND CRSE_CODE = crseCode_in)))
                   CRSE_TERM_CHANGES_COUNT
           FROM CRSE_YEAR CY
          WHERE CRSE_SESSION_ID = temp_session_id;

      io_cursor := sessionDetails_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getSessionDetails;


   PROCEDURE getStudCrseTermsCount (
      instCode_in              IN            VARCHAR2,
      crseCode_in              IN            VARCHAR2,
      sessionCode_in           IN            VARCHAR2,
      crseYearNo_in            IN            VARCHAR2,
      studCrseTermsCount_out      OUT        VARCHAR2,
      studentList_out             OUT        VARCHAR2,
      error_boolean               OUT NOCOPY VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      studCrseTermsCount_out := 0;

      SELECT COUNT (DISTINCT (STUD_REF_NO)) STUDENTS
        INTO studCrseTermsCount_out
        FROM STUD_CRSE_YEAR SCY,
             CRSE_SESSION CS,
             CRSE_YEAR CY,
             CRSE C
       WHERE     C.CRSE_CODE = UPPER (crseCode_in)
             AND C.INST_CODE = UPPER (instCode_in)
             AND C.CRSE_ID = CS.CRSE_ID
             AND CS.SESSION_CODE = sessionCode_in
             AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
             AND CY.CRSE_YEAR_NO = crseYearNo_in
             AND CY.CRSE_YEAR_ID = SCY.CRSE_YEAR_ID;

      SELECT SUBSTR (
                RTRIM (
                   XMLAGG (XMLELEMENT (E, X.STUDENTS || CHR (10))).EXTRACT (
                      '//text()'),
                   ','),
                1,
                4000)
                STUDENTS
        INTO studentList_out
        FROM (  SELECT    'Year '
                       || SCY.CRSE_YEAR_NO
                       || ' - '
                       || RTRIM (
                             XMLAGG (XMLELEMENT (E, SCY.STUD_REF_NO || ',')).EXTRACT (
                                '//text()'),
                             ',')
                          STUDENTS
                  FROM STUD_CRSE_YEAR SCY, CRSE_YEAR CY
                 WHERE     SCY.INST_CODE = UPPER (instCode_in)
                       AND SCY.CRSE_CODE = UPPER (crseCode_in)
                       AND SCY.SESSION_CODE = sessionCode_in
                       AND SCY.CRSE_YEAR_ID = CY.CRSE_YEAR_ID
                       AND SCY.CRSE_ID = CY.CRSE_ID
              GROUP BY SCY.CRSE_YEAR_NO) X;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getStudCrseTermsCount;


   FUNCTION getStudentListForInst (instCode_in      IN VARCHAR2,
                                   sessionCode_in   IN VARCHAR2)
      RETURN VARCHAR2
   IS
      CURSOR C_STUDENTS
      IS
         SELECT DBMS_LOB.SUBSTR (
                   RTRIM (
                      XMLAGG (XMLELEMENT (E, X.STUDENTS || CHR (10))).EXTRACT (
                         '//text()').GETCLOBVAL (),
                      ','),
                   4000,
                   1)
                   STUDENTS
           FROM (  SELECT    'Year '
                          || SCY.CRSE_YEAR_NO
                          || ' - '
                          || RTRIM (
                                XMLAGG (XMLELEMENT (E, SCY.STUD_REF_NO || ',')).EXTRACT (
                                   '//text()').GETCLOBVAL (),
                                ',')
                             STUDENTS
                     FROM STUD_CRSE_YEAR SCY, CRSE_YEAR CY
                    WHERE     SCY.INST_CODE = UPPER (instCode_in)
                          AND SCY.SESSION_CODE = sessionCode_in
                          AND SCY.CRSE_YEAR_ID = CY.CRSE_YEAR_ID
                          AND CY.DEFAULT_TERMS = 'Y'
                 GROUP BY SCY.CRSE_YEAR_NO) X;

      V_STUDENT_LIST   VARCHAR2 (8000);
   BEGIN
      OPEN C_STUDENTS;

      FETCH C_STUDENTS INTO V_STUDENT_LIST;

      CLOSE C_STUDENTS;

      RETURN V_STUDENT_LIST;
   END getStudentListForInst;


   PROCEDURE getStudInstTermsCount (
      instCode_in              IN            VARCHAR2,
      sessionCode_in           IN            VARCHAR2,
      studInstTermsCount_out      OUT        VARCHAR2,
      studentList_out             OUT        VARCHAR2,
      error_boolean               OUT NOCOPY VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      studInstTermsCount_out := 0;

      SELECT COUNT (DISTINCT (STUD_REF_NO)) STUDENTS
        INTO studInstTermsCount_out
        FROM STUD_CRSE_YEAR SCY, CRSE_YEAR CY
       WHERE     SCY.INST_CODE = UPPER (instCode_in)
             AND SCY.SESSION_CODE = sessionCode_in
             AND SCY.CRSE_YEAR_ID = CY.CRSE_YEAR_ID
             AND CY.DEFAULT_TERMS = 'Y';

      SELECT getStudentListForInst (instCode_in, sessionCode_in)
        INTO studentList_out
        FROM DUAL;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getStudInstTermsCount;


   PROCEDURE addCourseSession (crse_code_in          IN            VARCHAR2,
                               inst_code_in          IN            VARCHAR2,
                               session_code_in       IN            VARCHAR2,
                               max_duration_in       IN            VARCHAR2,
                               user_in               IN            VARCHAR2,
                               crse_session_id_out      OUT NOCOPY VARCHAR2,
                               error_boolean            OUT NOCOPY VARCHAR2,
                               ERROR_TEXT               OUT NOCOPY VARCHAR2)
   IS
      V_CRSE_SESSION_ID   NUMBER (9);
      V_CRSE_ID           NUMBER (9);
   BEGIN
      SELECT CRSS_CRSE_SESSION_ID_SEQ.NEXTVAL
        INTO V_CRSE_SESSION_ID
        FROM DUAL;

      SELECT C.CRSE_ID
        INTO V_CRSE_ID
        FROM CRSE C
       WHERE     C.CRSE_CODE = UPPER (crse_code_in)
             AND C.INST_CODE = UPPER (inst_code_in);

      INSERT INTO CRSE_SESSION CS (CS.CRSE_SESSION_ID,
                                   CS.CRSE_ID,
                                   CS.SESSION_CODE,
                                   CS.MAX_DURATION,
                                   CS.PSAS_BID_NON_QUOTA,
                                   CS.LAST_UPDATED_BY)
           VALUES (V_CRSE_SESSION_ID,
                   V_CRSE_ID,
                   session_code_in,
                   max_duration_in,
                   'N',
                   UPPER (user_in));

      crse_session_id_out := V_CRSE_SESSION_ID;
      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END addCourseSession;


   PROCEDURE addInstitute (instCode_in          IN     VARCHAR2,
                           hei_inst_code_in     IN     VARCHAR2,
                           inst_name_in         IN     VARCHAR2,
                           post_code_in         IN     VARCHAR2,
                           house_no_in          IN     VARCHAR2,
                           address_l1_in        IN     VARCHAR2,
                           address_l2_in        IN     VARCHAR2,
                           address_l3_in        IN     VARCHAR2,
                           address_l4_in        IN     VARCHAR2,
                           telephone_no_in      IN     VARCHAR2,
                           inst_type_in         IN     VARCHAR2,
                           pay_method_in        IN     VARCHAR2,
                           location_in          IN     VARCHAR2,
                           pams_in              IN     VARCHAR2,
                           non_public_fund_in   IN     VARCHAR2,
                           user_in              IN     VARCHAR2,
                           dsa_only_in          IN     VARCHAR2,
                           error_boolean           OUT VARCHAR2,
                           ERROR_TEXT              OUT VARCHAR2)
   IS
   BEGIN
      INSERT INTO INST (INST_CODE,
                        HEI_INST_CODE,
                        INST_NAME,
                        POST_CODE,
                        HOUSE_NO_OR_NAME,
                        ADDR_L1,
                        ADDR_L2,
                        ADDR_L3,
                        ADDR_L4,
                        TELE_NO,
                        INST_TYPE_ID,
                        PAYMENT_METHOD,
                        LOCATION_IND,
                        PAMS,
                        NON_PUBLIC_FUND,
                        --Following values are not provided in query since they are not present in UI anymore.
                        SKELETON,
                        COLLEGE_TYPE,
                        NOMINATED_IND,
                        INST.CATEGORY,
                        INST.LAST_UPDATED_BY,
                        INST.DSA_ONLY)
           VALUES (UPPER (instCode_in),
                   UPPER (hei_inst_code_in),
                   UPPER (inst_name_in),
                   UPPER (post_code_in),
                   UPPER (house_no_in),
                   UPPER (address_l1_in),
                   UPPER (address_l2_in),
                   UPPER (address_l3_in),
                   UPPER (address_l4_in),
                   telephone_no_in,
                   inst_type_in,
                   UPPER (pay_method_in),
                   location_in,
                   pams_in,
                   non_public_fund_in,
                   --Following values are not provided in query since they are not present in UI anymore.
                   'N',
                   '328',
                   'N',
                   'NO',
                   UPPER (user_in),
                   UPPER (dsa_only_in));

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END addInstitute;


   PROCEDURE addInstTermDates (instCode_in      IN     VARCHAR2,
                               sessioncode_in   IN     VARCHAR2,
                               termno_in        IN     VARCHAR2,
                               startdate_in     IN     VARCHAR2,
                               enddate_in       IN     VARCHAR2,
                               days_in          IN     VARCHAR2,
                               user_in          IN     VARCHAR2,
                               error_boolean       OUT VARCHAR2,
                               ERROR_TEXT          OUT VARCHAR2)
   IS
   BEGIN
      INSERT INTO INST_TERM COLUMNS (INST_CODE,
                                     SESSION_CODE,
                                     TERM_NO,
                                     START_DATE,
                                     END_DATE,
                                     DAYS,
                                     LAST_UPDATED_BY)
           VALUES (instCode_in,
                   sessioncode_in,
                   termno_in,
                   startdate_in,
                   enddate_in,
                   days_in,
                   UPPER (user_in));

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END addInstTermDates;


   PROCEDURE insertCampus (instCode_in        IN     VARCHAR2,
                           campusCode_in      IN     VARCHAR2,
                           campusName_in      IN     VARCHAR2,
                           post_code_in       IN     VARCHAR2,
                           house_no_in        IN     VARCHAR2,
                           address_l1_in      IN     VARCHAR2,
                           address_l2_in      IN     VARCHAR2,
                           address_l3_in      IN     VARCHAR2,
                           address_l4_in      IN     VARCHAR2,
                           pay_method_in      IN     VARCHAR2,
                           bankName_in        IN     VARCHAR2,
                           bankPostcode_in    IN     VARCHAR2,
                           bankHouseName_in   IN     VARCHAR2,
                           bankAddr1_in       IN     VARCHAR2,
                           bankAddr2_in       IN     VARCHAR2,
                           bankAddr3_in       IN     VARCHAR2,
                           bankAddr4_in       IN     VARCHAR2,
                           bankSortCode_in    IN     VARCHAR2,
                           bankAccNo_in       IN     VARCHAR2,
                           user_in            IN     VARCHAR2,
                           error_boolean         OUT VARCHAR2,
                           ERROR_TEXT            OUT VARCHAR2)
   IS
   BEGIN
      INSERT INTO CAMPUS COLUMNS (CAMPUS_ID,
                                  INST_CODE,
                                  CAMPUS_CODE,
                                  NAME,
                                  HOUSE_NO_NAME,
                                  ADDR_L1,
                                  ADDR_L2,
                                  ADDR_L3,
                                  ADDR_L4,
                                  POSTCODE,
                                  ADDR_EASTING,
                                  ADDR_NORTHING,
                                  PAYMENT_METHOD,
                                  BANK_NAME,
                                  BANK_SORT_CODE,
                                  ACCOUNT_NO,
                                  BANK_HOUSE_NO_NAME,
                                  BANK_ADDR_L1,
                                  BANK_ADDR_L2,
                                  BANK_ADDR_L3,
                                  BANK_ADDR_L4,
                                  BANK_POST_CODE,
                                  CAMPUS_DEBT,
                                  CSV_ID,
                                  FEE_LOAN_DEBT,
                                  LAST_UPDATED_BY)
           VALUES ( (SELECT MAX (campus_id) FROM campus) + 1,
                   UPPER (instCode_in),
                   UPPER (campusCode_in),
                   UPPER (campusName_in),
                   UPPER (house_no_in),
                   UPPER (address_l1_in),
                   UPPER (address_l2_in),
                   UPPER (address_l3_in),
                   UPPER (address_l4_in),
                   UPPER (post_code_in),
                   '',
                   '',
                   UPPER (pay_method_in),
                   UPPER (bankName_in),
                   UPPER (bankSortCode_in),
                   UPPER (bankAccNo_in),
                   UPPER (bankHouseName_in),
                   UPPER (bankAddr1_in),
                   UPPER (bankAddr2_in),
                   UPPER (bankAddr3_in),
                   UPPER (bankAddr4_in),
                   UPPER (bankPostcode_in),
                   '',
                   '',
                   '',
                   UPPER (user_in));

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertCampus;


   PROCEDURE insertCourse (instCode_in      IN     VARCHAR2,
                           instName_in      IN     VARCHAR2,
                           crseCode_in      IN     VARCHAR2,
                           crseName_in      IN     VARCHAR2,
                           feesCampus_in    IN     VARCHAR2,
                           maintCampus_in   IN     VARCHAR2,
                           qualType_in      IN     VARCHAR2,
                           schemeType_in    IN     VARCHAR2,
                           pamsCourse_in    IN     VARCHAR2,
                           ga_in            IN     VARCHAR2,
                           heiCrseCode_in   IN     VARCHAR2,
                           user_in          IN     VARCHAR2,
                           dsa_only_in      IN     VARCHAR2,
                           error_boolean       OUT VARCHAR2,
                           ERROR_TEXT          OUT VARCHAR2)
   IS
      temp_crse_id       VARCHAR2 (6);
      temp_scheme_type   VARCHAR2 (1) := schemeType_in;
   BEGIN
      SELECT CRS_CRSE_ID_SEQ.NEXTVAL INTO temp_crse_id FROM DUAL;

      IF ga_in = 'Y'
      THEN
         temp_scheme_type := 'G';
      END IF;

      INSERT INTO CRSE COLUMNS (CRSE_ID,
                                INST_CODE,
                                INST_NAME,
                                CRSE_CODE,
                                CRSE_NAME,
                                FEES_CAMPUS,
                                MAINT_CAMPUS,
                                QUAL_TYPE,
                                SCHEME_TYPE,
                                APPROVED,
                                DEPARTMENT,
                                SUBJECT_CAT_ID,
                                SUPERVISOR,
                                PAMS_COURSE,
                                GRADUATE_APPRENTICE,
                                SKELETON,
                                HEI_CRSE_CODE,
                                GE_LIABLE,
                                LAST_UPDATED_BY,
                                DSA_ONLY)
           VALUES (temp_crse_id,
                   UPPER (instCode_in),
                   UPPER (instName_in),
                   UPPER (crseCode_in),
                   UPPER (crseName_in),
                   feesCampus_in,
                   maintCampus_in,
                   UPPER (qualType_in),
                   UPPER (temp_scheme_type),
                   'Y',
                   '',
                   '148',
                   '',
                   pamsCourse_in,
                   ga_in,
                   'N',
                   UPPER (heiCrseCode_in),
                   'N',
                   UPPER (user_in),
                   UPPER (dsa_only_in));

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertCourse;


   PROCEDURE insertCrseTermChange (
      hei_crse_code_in    IN            VARCHAR2,
      academic_year_in    IN            VARCHAR2,
      term_in             IN            VARCHAR2,
      new_term_start_in   IN            VARCHAR2,
      new_term_end_in     IN            VARCHAR2,
      new_fees_in         IN            VARCHAR2,
      old_term_start_in   IN            VARCHAR2,
      old_term_end_in     IN            VARCHAR2,
      old_fees_in         IN            VARCHAR2,
      change_type_in      IN            VARCHAR2,
      created_date_in     IN            VARCHAR2,
      created_by_in       IN            VARCHAR2,
      status_in           IN            VARCHAR2,
      status_by_in        IN            VARCHAR2,
      session_code_in     IN            VARCHAR2,
      hei_inst_code_in    IN            VARCHAR2,
      crse_id_in          IN            VARCHAR2,
      error_boolean          OUT NOCOPY VARCHAR2,
      ERROR_TEXT             OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      INSERT INTO SLCADMIN.TERM_CHANGE (HEI_CRSE_CODE,
                                        ACADEMIC_YEAR,
                                        TERM,
                                        NEW_TERM_START,
                                        NEW_TERM_END,
                                        NEW_FEES,
                                        OLD_TERM_START,
                                        OLD_TERM_END,
                                        OLD_FEES,
                                        CHANGE_TYPE,
                                        CREATED_DATE,
                                        CREATED_BY,
                                        STATUS,
                                        STATUS_BY,
                                        SESSION_CODE,
                                        HEI_INST_CODE,
                                        CRSE_ID)
           VALUES (hei_crse_code_in,
                   academic_year_in,
                   term_in,
                   TO_DATE (new_term_start_in, 'DD/MM/YYYY'),
                   TO_DATE (new_term_end_in, 'DD/MM/YYYY'),
                   new_fees_in,
                   TO_DATE (old_term_start_in, 'DD/MM/YYYY'),
                   TO_DATE (old_term_end_in, 'DD/MM/YYYY'),
                   old_fees_in,
                   change_type_in,
                   SYSDATE,
                   created_by_in,
                   'NEW',
                   status_by_in,
                   session_code_in,
                   hei_inst_code_in,
                   crse_id_in);

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertCrseTermChange;


   PROCEDURE insertInstTermChange (
      hei_inst_code_in        IN            VARCHAR2,
      inst_code_in            IN            VARCHAR2,
      session_code_in         IN            VARCHAR2,
      term_no_in              IN            VARCHAR2,
      new_start_date_in       IN            VARCHAR2,
      new_end_date_in         IN            VARCHAR2,
      new_days_in             IN            VARCHAR2,
      old_start_date_in       IN            VARCHAR2,
      old_end_date_in         IN            VARCHAR2,
      old_days_in             IN            VARCHAR2,
      change_type_in          IN            VARCHAR2,
      created_date_in         IN            VARCHAR2,
      created_by_in           IN            VARCHAR2,
      status_in               IN            VARCHAR2,
      status_by_in            IN            VARCHAR2,
      last_modified_date_in   IN            VARCHAR2,
      error_boolean              OUT NOCOPY VARCHAR2,
      ERROR_TEXT                 OUT NOCOPY VARCHAR2)
   IS
   BEGIN
      INSERT INTO SLCADMIN.INST_TERM_CHANGE (HEI_INST_CODE,
                                             INST_CODE,
                                             SESSION_CODE,
                                             TERM_NO,
                                             NEW_START_DATE,
                                             NEW_END_DATE,
                                             NEW_DAYS,
                                             OLD_START_DATE,
                                             OLD_END_DATE,
                                             OLD_DAYS,
                                             CHANGE_TYPE,
                                             CREATED_DATE,
                                             CREATED_BY,
                                             STATUS,
                                             STATUS_BY,
                                             LAST_UPDATED_DATE)
           VALUES (hei_inst_code_in,
                   inst_code_in,
                   session_code_in,
                   term_no_in,
                   TO_DATE (new_start_date_in, 'DD/MM/YYYY'),
                   TO_DATE (new_end_date_in, 'DD/MM/YYYY'),
                   new_days_in,
                   TO_DATE (old_start_date_in, 'DD/MM/YYYY'),
                   TO_DATE (old_end_date_in, 'DD/MM/YYYY'),
                   old_days_in,
                   change_type_in,
                   SYSDATE,
                   created_by_in,
                   'NEW',
                   status_by_in,
                   SYSDATE);

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertInstTermChange;


   PROCEDURE saveCrseTermDates (crse_year_id_in   IN     VARCHAR2,
                                termno_in         IN     VARCHAR2,
                                startdate_in      IN     VARCHAR2,
                                enddate_in        IN     VARCHAR2,
                                days_in           IN     VARCHAR2,
                                user_in           IN     VARCHAR2,
                                error_boolean        OUT VARCHAR2,
                                ERROR_TEXT           OUT VARCHAR2)
   IS
      temp_crse_term   VARCHAR2 (9);
   BEGIN
      SELECT CASE
                WHEN EXISTS
                        (SELECT 1
                           FROM CRSE_TERM
                          WHERE     CRSE_TERM.CRSE_YEAR_ID = crse_year_id_in
                                AND CRSE_TERM.TERM_NO = termno_in)
                THEN
                   'Y'
                ELSE
                   'N'
             END
        INTO temp_crse_term
        FROM DUAL;

      IF (temp_crse_term = 'Y')
      THEN
         UPDATE CRSE_TERM
            SET START_DATE = TO_DATE (startdate_in, 'DD/MM/YYYY'),
                END_DATE = TO_DATE (enddate_in, 'DD/MM/YYYY'),
                DAYS = days_in,
                LAST_UPDATED_BY = UPPER (user_in),
                LAST_UPDATED_ON = SYSDATE
          WHERE     CRSE_TERM.CRSE_YEAR_ID = crse_year_id_in
                AND CRSE_TERM.TERM_NO = termno_in;
      ELSE
         INSERT INTO CRSE_TERM COLUMNS (CRSE_YEAR_ID,
                                        TERM_NO,
                                        DAYS,
                                        START_DATE,
                                        END_DATE,
                                        LAST_UPDATED_BY)
              VALUES (crse_year_id_in,
                      termno_in,
                      days_in,
                      TO_DATE (startdate_in, 'DD/MM/YYYY'),
                      TO_DATE (enddate_in, 'DD/MM/YYYY'),
                      UPPER (user_in));
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END saveCrseTermDates;


   PROCEDURE updateCampus (instCode_in        IN     VARCHAR2,
                           campusCode_in      IN     VARCHAR2,
                           campusName_in      IN     VARCHAR2,
                           post_code_in       IN     VARCHAR2,
                           house_no_in        IN     VARCHAR2,
                           address_l1_in      IN     VARCHAR2,
                           address_l2_in      IN     VARCHAR2,
                           address_l3_in      IN     VARCHAR2,
                           address_l4_in      IN     VARCHAR2,
                           pay_method_in      IN     VARCHAR2,
                           bankName_in        IN     VARCHAR2,
                           bankPostcode_in    IN     VARCHAR2,
                           bankHouseName_in   IN     VARCHAR2,
                           bankAddr1_in       IN     VARCHAR2,
                           bankAddr2_in       IN     VARCHAR2,
                           bankAddr3_in       IN     VARCHAR2,
                           bankAddr4_in       IN     VARCHAR2,
                           bankSortCode_in    IN     VARCHAR2,
                           bankAccNo_in       IN     VARCHAR2,
                           user_in            IN     VARCHAR2,
                           error_boolean         OUT VARCHAR2,
                           ERROR_TEXT            OUT VARCHAR2)
   IS
   BEGIN
      UPDATE campus
         SET campus.name = UPPER (campusName_in),
             CAMPUS.POSTCODE = UPPER (post_code_in),
             CAMPUS.HOUSE_NO_NAME = UPPER (house_no_in),
             CAMPUS.ADDR_L1 = UPPER (address_l1_in),
             CAMPUS.ADDR_L2 = UPPER (address_l2_in),
             CAMPUS.ADDR_L3 = UPPER (address_l3_in),
             CAMPUS.ADDR_l4 = UPPER (address_l4_in),
             CAMPUS.PAYMENT_METHOD = UPPER (pay_method_in),
             CAMPUS.BANK_NAME = UPPER (bankName_in),
             CAMPUS.BANK_POST_CODE = UPPER (bankPostcode_in),
             CAMPUS.BANK_HOUSE_NO_NAME = UPPER (bankHouseName_in),
             CAMPUS.BANK_ADDR_L1 = UPPER (bankAddr1_in),
             CAMPUS.BANK_ADDR_L2 = UPPER (bankAddr2_in),
             CAMPUS.BANK_ADDR_L3 = UPPER (bankAddr3_in),
             CAMPUS.BANK_ADDR_L4 = UPPER (bankAddr4_in),
             CAMPUS.BANK_SORT_CODE = bankSortCode_in,
             CAMPUS.ACCOUNT_NO = bankAccNo_in,
             CAMPUS.LAST_UPDATED_BY = UPPER (user_in),
             CAMPUS.LAST_UPDATED_ON = SYSDATE
       WHERE     CAMPUS.inst_code = UPPER (instCode_in)
             AND CAMPUS.CAMPUS_CODE = UPPER (campusCode_in);

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateCampus;


   PROCEDURE updateCourse (instCode_in      IN     VARCHAR2,
                           heiCrseCode_in   IN     VARCHAR2,
                           crseName_in      IN     VARCHAR2,
                           schemeType_in    IN     VARCHAR2,
                           qualType_in      IN     VARCHAR2,
                           feesCampus_in    IN     VARCHAR2,
                           maintCampus_in   IN     VARCHAR2,
                           pamsCourse_in    IN     VARCHAR2,
                           ga_in            IN     VARCHAR2,
                           crseCode_in      IN     VARCHAR2,
                           user_in          IN     VARCHAR2,
                           dsa_only_in      IN     VARCHAR2,
                           error_boolean       OUT VARCHAR2,
                           ERROR_TEXT          OUT VARCHAR2)
   IS
      temp_scheme_type   VARCHAR (1) := schemeType_in;
   BEGIN
      IF ga_in = 'Y'
      THEN
         temp_scheme_type := 'G';
      END IF;

      UPDATE crse
         SET CRSE.CRSE_NAME = UPPER (crseName_in),
             CRSE.HEI_CRSE_CODE = UPPER (heiCrseCode_in),
             CRSE.SCHEME_TYPE = UPPER (temp_scheme_type),
             CRSE.QUAL_TYPE = UPPER (qualType_in),
             CRSE.FEES_CAMPUS = UPPER (feesCampus_in),
             CRSE.MAINT_CAMPUS = UPPER (maintCampus_in),
             CRSE.PAMS_COURSE = pamsCourse_in,
             CRSE.GRADUATE_APPRENTICE = ga_in,
             CRSE.APPROVED = 'Y',
             CRSE.SKELETON = 'N',
             CRSE.GE_LIABLE = 'N',
             CRSE.SUBJECT_CAT_ID = '148',
             CRSE.LAST_UPDATED_BY = UPPER (user_in),
             CRSE.LAST_UPDATED_ON = SYSDATE,
             CRSE.DSA_ONLY = UPPER (dsa_only_in)
       WHERE     crse.inst_code = UPPER (instCode_in)
             AND CRSE.CRSE_CODE = UPPER (crseCode_in);

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateCourse;


   PROCEDURE updateCourseSession (crse_code_in      IN            VARCHAR2,
                                  inst_code_in      IN            VARCHAR2,
                                  session_code_in   IN            VARCHAR2,
                                  max_duration_in   IN            VARCHAR2,
                                  user_in           IN            VARCHAR2,
                                  error_boolean        OUT NOCOPY VARCHAR2,
                                  ERROR_TEXT           OUT NOCOPY VARCHAR2)
   IS
      V_CRSE_ID   NUMBER (9);
   BEGIN
      SELECT C.CRSE_ID
        INTO V_CRSE_ID
        FROM CRSE C
       WHERE     C.CRSE_CODE = UPPER (crse_code_in)
             AND C.INST_CODE = UPPER (inst_code_in);

      UPDATE CRSE_SESSION
         SET MAX_DURATION = max_duration_in,
             LAST_UPDATED_BY = UPPER (user_in),
             LAST_UPDATED_ON = SYSDATE
       WHERE CRSE_ID = V_CRSE_ID AND SESSION_CODE = session_code_in;

      error_boolean := 'false';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateCourseSession;


   PROCEDURE updateCrseYearDetails (instCode_in              IN     VARCHAR2,
                                    crseCode_in              IN     VARCHAR2,
                                    sessionCode_in           IN     VARCHAR2,
                                    max_duration_in          IN     VARCHAR2,
                                    crse_year_no_in          IN     VARCHAR2,
                                    study_abroad_in          IN     VARCHAR2,
                                    var_tui_fee_amount_in    IN     VARCHAR2,
                                    var_sand_fee_amount_in   IN     VARCHAR2,
                                    cutoff_type_in           IN     VARCHAR2,
                                    cutoff_date_in           IN     VARCHAR2,
                                    default_terms_in         IN     VARCHAR2,
                                    eu_flag_in               IN     VARCHAR2,
                                    eu_fee_loan_in           IN     VARCHAR2,
                                    hei_crse_code_in         IN     VARCHAR2,
                                    user_in                  IN     VARCHAR2,
                                    error_boolean               OUT VARCHAR2,
                                    ERROR_TEXT                  OUT VARCHAR2)
   IS
      temp_session_id     VARCHAR2 (10);
      temp_crse_year_id   VARCHAR2 (6);
      new_crse_year_id    NUMBER (9);
      temp_crse_id        NUMBER (9);
   BEGIN
      SELECT crse_session_id
        INTO temp_session_id
        FROM crse_session CS
       WHERE     crse_id =
                    (SELECT crse_id
                       FROM crse C
                      WHERE     crse_code = crseCode_in
                            AND inst_code = instCode_in)
             AND session_code = sessionCode_in;

      /*SELECT crse_year_id
          INTO temp_crse_year_id
          FROM crse_year
          WHERE CRSE_YEAR.CRSE_SESSION_ID = temp_session_id
                  AND CRSE_YEAR.CRSE_YEAR_NO = crse_year_no_in;
  */
      SELECT CASE
                WHEN EXISTS
                        (SELECT 1
                           FROM crse_year
                          WHERE     CRSE_YEAR.CRSE_SESSION_ID =
                                       temp_session_id
                                AND CRSE_YEAR.CRSE_YEAR_NO = crse_year_no_in)
                THEN
                   'Y'
                ELSE
                   'N'
             END
        INTO temp_crse_year_id
        FROM DUAL;

      SELECT CRSY_CRSE_YEAR_ID_SEQ.NEXTVAL INTO new_crse_year_id FROM DUAL;

      SELECT crse_id
        INTO temp_crse_id
        FROM crse C
       WHERE crse_code = crseCode_in AND inst_code = instCode_in;

      IF (temp_crse_year_id = 'Y')
      THEN
         UPDATE CRSE_YEAR
            SET CRSE_YEAR.STUDY_ABROAD = 'N',
                CRSE_YEAR.DEFAULT_TERMS = default_terms_in,
                CRSE_YEAR.VAR_TUITION_FEE_AMNT = var_tui_fee_amount_in,
                CRSE_YEAR.VAR_SANDWICH_TUITION_FEE_AMNT =
                   var_sand_fee_amount_in,
                CRSE_YEAR.CUTOFF_TYPE = cutoff_type_in,
                CRSE_YEAR.CUTOFF_DATE = cutoff_date_in,
                CRSE_YEAR.EU_FLAG = eu_flag_in,
                CRSE_YEAR.EU_FEE_LOAN = eu_fee_loan_in,
                CRSE_YEAR.HEI_CRSE_CODE = hei_crse_code_in,
                CRSE_YEAR.LAST_UPDATED_BY = UPPER (user_in),
                CRSE_YEAR.LAST_UPDATED_ON = SYSDATE
          WHERE     CRSE_YEAR.CRSE_SESSION_ID = temp_session_id
                AND CRSE_YEAR.CRSE_YEAR_NO = crse_year_no_in;
      ELSE
         --Insert new record here.
         INSERT INTO crse_year (crse_year_id,
                                crse_id,
                                crse_session_id,
                                crse_year_no,
                                inst_code,
                                study_abroad,
                                default_terms,
                                split_session,
                                crse_type,
                                eu_flag,
                                eu_fee_loan,
                                cutoff_type,
                                cutoff_date,
                                semester,
                                hei_crse_code,
                                var_tuition_fee_amnt,
                                var_sandwich_tuition_fee_amnt,
                                last_updated_by)
              VALUES (new_crse_year_id,
                      temp_crse_id,
                      temp_session_id,
                      crse_year_no_in,
                      instCode_in,
                      'N',
                      default_terms_in,
                      'N',
                      'N',
                      eu_flag_in,
                      eu_fee_loan_in,
                      cutoff_type_in,
                      cutoff_date_in,
                      'N',
                      hei_crse_code_in,
                      var_tui_fee_amount_in,
                      var_sand_fee_amount_in,
                      UPPER (user_in));
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateCrseYearDetails;


   PROCEDURE updateDefaultTermsFlag (crse_year_id_in         IN     VARCHAR2,
                                     default_terms_flag_in   IN     VARCHAR2,
                                     user_in                 IN     VARCHAR2,
                                     error_boolean              OUT VARCHAR2,
                                     ERROR_TEXT                 OUT VARCHAR2)
   IS
   BEGIN
      UPDATE CRSE_YEAR CY
         SET CY.DEFAULT_TERMS = UPPER (default_terms_flag_in),
             CY.LAST_UPDATED_BY = UPPER (user_in),
             CY.LAST_UPDATED_ON = SYSDATE
       WHERE CY.CRSE_YEAR_ID = crse_year_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateDefaultTermsFlag;


   PROCEDURE updateInstitute (instCode_in          IN     VARCHAR2,
                              hei_inst_code_in     IN     VARCHAR2,
                              inst_name_in         IN     VARCHAR2,
                              post_code_in         IN     VARCHAR2,
                              house_no_in          IN     VARCHAR2,
                              address_l1_in        IN     VARCHAR2,
                              address_l2_in        IN     VARCHAR2,
                              address_l3_in        IN     VARCHAR2,
                              address_l4_in        IN     VARCHAR2,
                              telephone_no_in      IN     VARCHAR2,
                              inst_type_in         IN     VARCHAR2,
                              pay_method_in        IN     VARCHAR2,
                              location_in          IN     VARCHAR2,
                              pams_in              IN     VARCHAR2,
                              non_public_fund_in   IN     VARCHAR2,
                              user_in              IN     VARCHAR2,
                              dsa_only_in          IN     VARCHAR2,
                              error_boolean           OUT VARCHAR2,
                              ERROR_TEXT              OUT VARCHAR2)
   IS
   BEGIN
      UPDATE INST
         SET INST.HEI_INST_CODE = UPPER (hei_inst_code_in),
             INST.INST_NAME = UPPER (inst_name_in),
             INST.POST_CODE = UPPER (post_code_in),
             INST.HOUSE_NO_OR_NAME = UPPER (house_no_in),
             INST.ADDR_L1 = UPPER (address_l1_in),
             INST.ADDR_L2 = UPPER (address_l2_in),
             INST.ADDR_L3 = UPPER (address_l3_in),
             INST.ADDR_L4 = UPPER (address_l4_in),
             INST.TELE_NO = telephone_no_in,
             INST.INST_TYPE_ID = inst_type_in,
             INST.PAYMENT_METHOD = UPPER (pay_method_in),
             INST.LOCATION_IND = location_in,
             INST.PAMS = pams_in,
             INST.NON_PUBLIC_FUND = non_public_fund_in,
             --Following values are not provided in query since they are not present in UI anymore.
             INST.SKELETON = 'N',
             INST.COLLEGE_TYPE = '328',
             INST.NOMINATED_IND = 'N',
             INST.CATEGORY = 'NO',
             INST.LAST_UPDATED_BY = UPPER (user_in),
             INST.LAST_UPDATED_ON = SYSDATE,
             INST.DSA_ONLY = UPPER (dsa_only_in)
       WHERE INST.INST_CODE = UPPER (instCode_in);

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateInstitute;


   PROCEDURE updateInstituteBankDetails (instCode_in         IN     VARCHAR2,
                                         bankname_in         IN     VARCHAR2,
                                         bankpostcode_in     IN     VARCHAR2,
                                         house_no_in         IN     VARCHAR2,
                                         bankaddress_l1_in   IN     VARCHAR2,
                                         bankaddress_l2_in   IN     VARCHAR2,
                                         bankaddress_l3_in   IN     VARCHAR2,
                                         bankaddress_l4_in   IN     VARCHAR2,
                                         sortcode_in         IN     VARCHAR2,
                                         accountno_in        IN     VARCHAR2,
                                         user_in             IN     VARCHAR2,
                                         error_boolean          OUT VARCHAR2,
                                         ERROR_TEXT             OUT VARCHAR2)
   IS
   BEGIN
      UPDATE INST
         SET INST.BANK_NAME = UPPER (bankname_in),
             INST.BANK_POST_CODE = UPPER (bankpostcode_in),
             INST.BANK_HOUSE_NO_NAME = UPPER (house_no_in),
             INST.BANK_ADDR_L1 = UPPER (bankaddress_l1_in),
             INST.BANK_ADDR_L2 = UPPER (bankaddress_l2_in),
             INST.BANK_ADDR_L3 = UPPER (bankaddress_l3_in),
             INST.BANK_ADDR_L4 = UPPER (bankaddress_l4_in),
             INST.BANK_SORT_CODE = sortcode_in,
             INST.ACCOUNT_NO = accountno_in,
             INST.LAST_UPDATED_BY = UPPER (user_in),
             INST.LAST_UPDATED_ON = SYSDATE
       WHERE INST.INST_CODE = UPPER (instCode_in);

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateInstituteBankDetails;


   PROCEDURE updateInstTermDates (instCode_in      IN     VARCHAR2,
                                  sessioncode_in   IN     VARCHAR2,
                                  termno_in        IN     VARCHAR2,
                                  startdate_in     IN     VARCHAR2,
                                  enddate_in       IN     VARCHAR2,
                                  days_in          IN     VARCHAR2,
                                  user_in          IN     VARCHAR2,
                                  error_boolean       OUT VARCHAR2,
                                  ERROR_TEXT          OUT VARCHAR2)
   IS
      temp_inst_term   VARCHAR2 (5);
   BEGIN
      SELECT CASE
                WHEN EXISTS
                        (SELECT 1
                           FROM INST_TERM
                          WHERE     INST_TERM.INST_CODE = instCode_in
                                AND INST_TERM.SESSION_CODE = sessioncode_in
                                AND INST_TERM.TERM_NO = termno_in)
                THEN
                   'Y'
                ELSE
                   'N'
             END
        INTO temp_inst_term
        FROM DUAL;

      IF (temp_inst_term = 'Y')
      THEN
         UPDATE INST_TERM
            SET START_DATE = TO_DATE (startdate_in, 'DD/MM/YYYY'),
                END_DATE = TO_DATE (enddate_in, 'DD/MM/YYYY'),
                DAYS = days_in,
                LAST_UPDATED_BY = UPPER (user_in),
                LAST_UPDATED_ON = SYSDATE
          WHERE     INST_CODE = instcode_in
                AND SESSION_CODE = sessioncode_in
                AND TERM_NO = termno_in;
      ELSE
         INSERT INTO INST_TERM COLUMNS (INST_CODE,
                                        SESSION_CODE,
                                        TERM_NO,
                                        START_DATE,
                                        END_DATE,
                                        DAYS,
                                        LAST_UPDATED_BY)
              VALUES (instCode_in,
                      sessioncode_in,
                      termno_in,
                      TO_DATE (startdate_in, 'DD/MM/YYYY'),
                      TO_DATE (enddate_in, 'DD/MM/YYYY'),
                      days_in,
                      UPPER (user_in));
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateInstTermDates;


   PROCEDURE deleteCrseSession (inst_code_in      IN     VARCHAR2,
                                crse_code_in      IN     VARCHAR2,
                                session_code_in   IN     VARCHAR2,
                                user_in           IN     VARCHAR2,
                                error_boolean        OUT VARCHAR2,
                                ERROR_TEXT           OUT VARCHAR2)
   IS
      V_CRSE_ID   NUMBER (9);
   BEGIN
      SELECT C.CRSE_ID
        INTO V_CRSE_ID
        FROM CRSE C
       WHERE     C.CRSE_CODE = UPPER (crse_code_in)
             AND C.INST_CODE = UPPER (inst_code_in);

      UPDATE CRSE_SESSION
         SET LAST_UPDATED_BY = UPPER (user_in), LAST_UPDATED_ON = SYSDATE
       WHERE CRSE_ID = V_CRSE_ID AND SESSION_CODE = session_code_in;

      DELETE FROM CRSE_SESSION CS
            WHERE     CS.CRSE_ID = V_CRSE_ID
                  AND CS.SESSION_CODE = session_code_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END deleteCrseSession;


   PROCEDURE deleteCrseTermDates (crseYearId_in   IN     VARCHAR2,
                                  termno_in       IN     VARCHAR2,
                                  user_in         IN     VARCHAR2,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2)
   IS
   BEGIN
      UPDATE CRSE_TERM
         SET LAST_UPDATED_BY = UPPER (user_in), LAST_UPDATED_ON = SYSDATE
       WHERE     CRSE_TERM.CRSE_YEAR_ID = crseYearId_in
             AND CRSE_TERM.TERM_NO = termno_in;

      DELETE FROM CRSE_TERM
            WHERE CRSE_YEAR_ID = crseYearId_in AND TERM_NO = termno_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END deleteCrseTermDates;


   PROCEDURE deleteCrseYearDetails (instCode_in       IN     VARCHAR2,
                                    crseCode_in       IN     VARCHAR2,
                                    sessionCode_in    IN     VARCHAR2,
                                    crse_year_no_in   IN     VARCHAR2,
                                    user_in           IN     VARCHAR2,
                                    error_boolean        OUT VARCHAR2,
                                    ERROR_TEXT           OUT VARCHAR2)
   IS
      temp_crse_id        VARCHAR2 (9);
      temp_session_id     VARCHAR2 (10);
      temp_crse_year_id   VARCHAR2 (9);
   BEGIN
      SELECT crse_id
        INTO temp_crse_id
        FROM crse C
       WHERE crse_code = crseCode_in AND inst_code = instCode_in;

      SELECT crse_session_id
        INTO temp_session_id
        FROM crse_session CS
       WHERE crse_id = temp_crse_id AND session_code = sessionCode_in;

      SELECT crse_year_id
        INTO temp_crse_year_id
        FROM CRSE_YEAR CY
       WHERE     CY.CRSE_ID = temp_crse_id
             AND CRSE_YEAR_NO = crse_year_no_in
             AND CRSE_SESSION_ID = temp_session_id;

      UPDATE CRSE_YEAR
         SET CRSE_YEAR.LAST_UPDATED_BY = UPPER (user_in),
             CRSE_YEAR.LAST_UPDATED_ON = SYSDATE
       WHERE     CRSE_YEAR.CRSE_SESSION_ID = temp_session_id
             AND CRSE_YEAR.CRSE_YEAR_NO = crse_year_no_in;

      DELETE FROM CRSE_TERM
            WHERE CRSE_YEAR_ID = temp_crse_year_id;

      DELETE FROM CRSE_YEAR
            WHERE     CRSE_SESSION_ID = temp_session_id
                  AND CRSE_YEAR_NO = crse_year_no_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END deleteCrseYearDetails;


   PROCEDURE deleteInstTermDates (instCode_in      IN     VARCHAR2,
                                  sessionCode_in   IN     VARCHAR2,
                                  termno_in        IN     VARCHAR2,
                                  user_in          IN     VARCHAR2,
                                  error_boolean       OUT VARCHAR2,
                                  ERROR_TEXT          OUT VARCHAR2)
   IS
   BEGIN
      UPDATE INST_TERM
         SET LAST_UPDATED_BY = UPPER (user_in), LAST_UPDATED_ON = SYSDATE
       WHERE     INST_CODE = instcode_in
             AND SESSION_CODE = sessionCode_in
             AND TERM_NO = termno_in;

      DELETE FROM INST_TERM
            WHERE     INST_CODE = instCode_in
                  AND SESSION_CODE = sessionCode_in
                  AND TERM_NO = termno_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END deleteInstTermDates;


   PROCEDURE searchCourseList (instCode_in     IN            VARCHAR2,
                               crseCode_in     IN            VARCHAR2,
                               slcCode_in      IN            VARCHAR2,
                               crseName_in     IN            VARCHAR2,
                               io_cursor       IN OUT        TERM_DATES_CURSOR,
                               error_boolean      OUT NOCOPY VARCHAR2,
                               ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      searchcourseList_cursor   TERM_DATES_CURSOR;
   BEGIN
      IF slcCode_in IS NOT NULL
      THEN
         OPEN searchcourseList_cursor FOR
              SELECT DISTINCT C.CRSE_CODE, C.CRSE_NAME
                FROM CRSE C, CRSE_YEAR CY
               WHERE     C.CRSE_ID = CY.CRSE_ID(+)
                     AND UPPER (C.INST_CODE) = UPPER (instCode_in)
                     AND UPPER (C.CRSE_CODE) =
                            UPPER (NVL (crseCode_in, C.CRSE_CODE))
                     AND UPPER (C.CRSE_NAME) LIKE
                            UPPER (
                               '%' || NVL (crseName_in, C.CRSE_NAME) || '%')
                     AND UPPER (CY.HEI_CRSE_CODE) =
                            UPPER (NVL (slcCode_in, CY.HEI_CRSE_CODE))
            ORDER BY 2;
      ELSE
         OPEN searchcourseList_cursor FOR
              SELECT DISTINCT C.CRSE_CODE, C.CRSE_NAME
                FROM CRSE C, CRSE_YEAR CY
               WHERE     C.CRSE_ID = CY.CRSE_ID(+)
                     AND UPPER (C.INST_CODE) = UPPER (instCode_in)
                     AND UPPER (C.CRSE_CODE) =
                            UPPER (NVL (crseCode_in, C.CRSE_CODE))
                     AND UPPER (C.CRSE_NAME) LIKE
                            UPPER (
                               '%' || NVL (crseName_in, C.CRSE_NAME) || '%')
            ORDER BY 2;
      END IF;

      io_cursor := searchcourseList_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END searchCourseList;


   PROCEDURE searchInstitute (instName_in     IN            VARCHAR2,
                              instCode_in     IN            VARCHAR2,
                              io_cursor       IN OUT        TERM_DATES_CURSOR,
                              error_boolean      OUT NOCOPY VARCHAR2,
                              ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      termDates_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN termDates_cursor FOR
           SELECT INST_CODE, INST_NAME, HEI_INST_CODE
             FROM INST
            WHERE     INST.INST_CODE =
                         UPPER (NVL (instCode_in, INST.INST_CODE))
                  AND INST.INST_NAME LIKE
                         UPPER (
                            '%' || NVL (instName_in, INST.INST_NAME) || '%')
         ORDER BY 2;

      io_cursor := termDates_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END searchInstitute;


   PROCEDURE getDsaOnlyFlagCount (instCode_in     IN     VARCHAR2,
                                  crseId_in       IN     VARCHAR2,
                                  countResult        OUT VARCHAR2,
                                  error_boolean      OUT VARCHAR2,
                                  ERROR_TEXT         OUT VARCHAR2)
   IS
   BEGIN
         
      IF crseId_in IS NOT NULL
      THEN
		  SELECT COUNT (*)
			INTO countResult
			FROM CRSE C
		   WHERE     inst_Code = instCode_in
				 AND dsa_only = 'Y'
				 AND crse_id <> crseId_in;
      ELSE
		  SELECT COUNT (*)
			INTO countResult
			FROM CRSE C
		   WHERE     inst_Code = instCode_in
				 AND dsa_only = 'Y';
      END IF;   
   
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getDsaOnlyFlagCount;
END PK_STEPS_UI_TERM_DATES;
/
