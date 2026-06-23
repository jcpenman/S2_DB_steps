CREATE OR REPLACE PACKAGE BODY SLCADMIN.PK_TERM_DATES
AS
   /***************************************************************************************************
      NAME:       PK_TERM_DATES
      PURPOSE:    Package for functions and procedures related to maintenance of the Institution,
                 course and term dates data.

      Version    Date         Author           Description
      -------    ----------   ------------     --------------------
      1.0        14/09/2018   James Baird     Created this package

   ***************************************************************************************************/
      V_SYSDATE DATE;

   PROCEDURE LOAD_TERM_DATES
   IS
   BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE LATEST_COLLEGE REUSE STORAGE';

      EXECUTE IMMEDIATE 'TRUNCATE TABLE LATEST_COURSE REUSE STORAGE';

      EXECUTE IMMEDIATE 'TRUNCATE TABLE LATEST_TERM REUSE STORAGE';

      INSERT INTO LATEST_COLLEGE
           SELECT HEI_INST_CODE,
                  INST_CODE,
                  HEI_INST_NAME,
                  SESSION_CODE SESSION_CODE,
                  MAX (MAX_FEE) MAX_FEE
             FROM EXT_COLLEGE
         GROUP BY HEI_INST_CODE, INST_CODE, HEI_INST_NAME, SESSION_CODE;

      INSERT INTO LATEST_COURSE
           SELECT HEI_INST_CODE,
                  INST_CODE,
                  CAMPUS,
                  HEI_CRSE_CODE,
                  CRSE_CODE,
                  PK_TERM_DATES.IS_COURSE_SCOTTISH(HEI_CRSE_NAME) SCOTTISH,
                  HEI_CRSE_NAME,
                  DUMMY1,
                  SESSION_CODE SESSION_CODE,
                  DURATION
             FROM EXT_COURSE
         GROUP BY HEI_INST_CODE,
                  INST_CODE,
                  CAMPUS,
                  HEI_CRSE_CODE,
                  CRSE_CODE,
                  PK_TERM_DATES.IS_COURSE_SCOTTISH(HEI_CRSE_NAME),
                  HEI_CRSE_NAME,
                  DUMMY1,
                  SESSION_CODE,
                  DURATION;

      INSERT INTO LATEST_TERM
           SELECT HEI_CRSE_CODE,
                  ACADEMIC_YEAR,
                  TERM,
                  TERM_START,
                  TERM_END,
                  SESSION_CODE,
                  FEES
             FROM EXT_TERM
         GROUP BY HEI_CRSE_CODE,
                  ACADEMIC_YEAR,
                  TERM,
                  TERM_START,
                  TERM_END,
                  SESSION_CODE,
                  FEES;
      UPDATE LATEST_TERM LT
           SET LT.ACADEMIC_YEAR = LT.ACADEMIC_YEAR + 1
         WHERE EXISTS
                  (SELECT 1
                     FROM LATEST_TERM LT1
                    WHERE     LT1.ACADEMIC_YEAR = 0
                          AND LT1.HEI_CRSE_CODE = LT.HEI_CRSE_CODE
                          AND LT1.SESSION_CODE = LT.SESSION_CODE);
   END LOAD_TERM_DATES;
   
      FUNCTION IS_COURSE_SCOTTISH(COURSE_NAME    IN VARCHAR2)
      RETURN VARCHAR2
      IS
      V_COURSE_NAME VARCHAR2(100);
      V_RESULT VARCHAR2(1);
      BEGIN

        V_COURSE_NAME := REGEXP_REPLACE (
                         REGEXP_REPLACE (
                         REGEXP_REPLACE (
                         REGEXP_REPLACE (COURSE_NAME, 'ENG[[:alpha:]]', '9999'),
                                               '[[:alpha:]]ENG','9999'), 
                                               'SCO[[:alpha:]]', '9999'),
                                                '[[:alpha:]]SCO','9999');
      CASE
            WHEN (   ( V_COURSE_NAME LIKE '%-ENG%'
                      OR V_COURSE_NAME LIKE '%ENG-%'
                      OR V_COURSE_NAME LIKE '%.ENG%'
                      OR V_COURSE_NAME LIKE '%ENG.%')
                  AND V_COURSE_NAME NOT LIKE '%SCO%')
            THEN
               V_RESULT := 'N'; --'ENGLISH'
            WHEN (    (   V_COURSE_NAME LIKE '%-NI%'
                       OR V_COURSE_NAME LIKE '%NI-%'
                       OR V_COURSE_NAME LIKE '%.NI %')
  --                AND V_COURSE_NAME NOT LIKE '%ENG%'
                  AND V_COURSE_NAME NOT LIKE '%SCO%')
            THEN
               V_RESULT := 'N'; --'N-IRELAND'
            WHEN (    (   V_COURSE_NAME LIKE '%-WAL%'
                       OR V_COURSE_NAME LIKE '%WAL-%'
                       OR V_COURSE_NAME LIKE '%.WAL%')
                  AND V_COURSE_NAME NOT LIKE '%SCO%')
            THEN
               V_RESULT := 'N'; --'WALES'
            ELSE
               V_RESULT := 'Y'; --'SCOTTISH'
         END CASE;
        RETURN V_RESULT;
      END IS_COURSE_SCOTTISH;




   FUNCTION VALIDATE_TERM_DATES
      RETURN VARCHAR2
   IS
      V_EXISTS      BOOLEAN;
      V_LENGTH      NUMBER;
      V_BLOCKSIZE   NUMBER;
      V_BADFILES    VARCHAR2 (4000);
   BEGIN
      UTL_FILE.FGETATTR ('SLC_TERM_DATE_DIR',
                         'EXT_COLLEGE_2018.BADFILE',
                         V_EXISTS,
                         V_LENGTH,
                         V_BLOCKSIZE);

      IF V_EXISTS AND V_LENGTH > 0
      THEN
         V_BADFILES := V_BADFILES || ' EXT_COLLEGE_2018.BADFILE  ';
      END IF;

      DBMS_OUTPUT.PUT_LINE ('LENGTH IS: ' || V_LENGTH);
      DBMS_OUTPUT.PUT_LINE ('BLOCKSIZE IS: ' || V_BLOCKSIZE);

      UTL_FILE.FGETATTR ('SLC_TERM_DATE_DIR',
                         'EXT_COURSE_2018.BADFILE',
                         V_EXISTS,
                         V_LENGTH,
                         V_BLOCKSIZE);

      IF V_EXISTS AND V_LENGTH > 0
      THEN
         V_BADFILES := V_BADFILES || ' EXT_COURSE_2018.BADFILE  ';
      END IF;

      DBMS_OUTPUT.PUT_LINE ('LENGTH IS: ' || V_LENGTH);
      DBMS_OUTPUT.PUT_LINE ('BLOCKSIZE IS: ' || V_BLOCKSIZE);

      UTL_FILE.FGETATTR ('SLC_TERM_DATE_DIR',
                         'EXT_TERM_2018.BADFILE',
                         V_EXISTS,
                         V_LENGTH,
                         V_BLOCKSIZE);

      IF V_EXISTS AND V_LENGTH > 0
      THEN
         V_BADFILES := V_BADFILES || ' EXT_TERM_2018.BADFILE  ';
      END IF;

      DBMS_OUTPUT.PUT_LINE ('LENGTH IS: ' || V_LENGTH);
      DBMS_OUTPUT.PUT_LINE ('BLOCKSIZE IS: ' || V_BLOCKSIZE);

      UTL_FILE.FGETATTR ('SLC_TERM_DATE_DIR',
                         'EXT_COLLEGE_2019.BADFILE',
                         V_EXISTS,
                         V_LENGTH,
                         V_BLOCKSIZE);

      IF V_EXISTS AND V_LENGTH > 0
      THEN
         V_BADFILES := V_BADFILES || ' EXT_COLLEGE_2019.BADFILE  ';
      END IF;

      DBMS_OUTPUT.PUT_LINE ('LENGTH IS: ' || V_LENGTH);
      DBMS_OUTPUT.PUT_LINE ('BLOCKSIZE IS: ' || V_BLOCKSIZE);

      UTL_FILE.FGETATTR ('SLC_TERM_DATE_DIR',
                         'EXT_COURSE_2019.BADFILE',
                         V_EXISTS,
                         V_LENGTH,
                         V_BLOCKSIZE);

      IF V_EXISTS AND V_LENGTH > 0
      THEN
         V_BADFILES := V_BADFILES || ' EXT_COURSE_2019.BADFILE  ';
      END IF;

      DBMS_OUTPUT.PUT_LINE ('LENGTH IS: ' || V_LENGTH);
      DBMS_OUTPUT.PUT_LINE ('BLOCKSIZE IS: ' || V_BLOCKSIZE);

      UTL_FILE.FGETATTR ('SLC_TERM_DATE_DIR',
                         'EXT_TERM_2019.BADFILE',
                         V_EXISTS,
                         V_LENGTH,
                         V_BLOCKSIZE);

      IF V_EXISTS AND V_LENGTH > 0
      THEN
         V_BADFILES := V_BADFILES || ' EXT_TERM_2019.BADFILE  ';
      END IF;

      DBMS_OUTPUT.PUT_LINE ('LENGTH IS: ' || V_LENGTH);
      DBMS_OUTPUT.PUT_LINE ('BLOCKSIZE IS: ' || V_BLOCKSIZE);
      RETURN V_BADFILES;
   END VALIDATE_TERM_DATES;

    PROCEDURE REASONABLE_TEST (TEST_STATUS    OUT VARCHAR2,
                               TEST_SUMMARY   OUT VARCHAR2)
    IS /***************************************************************************************************
        This will test the latest data against the current data to see if it is reasonable.
         i.e. it is not reasonable that most of Institutions have been removed.

     ***************************************************************************************************/
       CURSOR C_SUMMARY
       IS
          SELECT (SELECT COUNT (0) FROM LATEST_COLLEGE) LATEST_COLLEGE_TOTAL,
                 (SELECT COUNT (0) FROM CURRENT_COLLEGE) CURRENT_COLLEGE_TOTAL,
                 (SELECT COUNT (0) FROM LATEST_COURSE) LATEST_COURSE_TOTAL,
                 (SELECT COUNT (0) FROM CURRENT_COURSE) CURRENT_COURSE_TOTAL,
                 (SELECT COUNT (0) FROM LATEST_TERM) LATEST_TERM_TOTAL,
                 (SELECT COUNT (0) FROM CURRENT_TERM) CURRENT_TERM_TOTAL
            FROM DUAL;

       CURSOR C_CONFIG
       IS
            SELECT ITEM_NAME, CVAL, NVAL
              FROM CONFIG_DATA C
             WHERE    C.ITEM_NAME LIKE 'SLC_TERMDATES_%ERROR'
                   OR C.ITEM_NAME LIKE 'SLC_TERMDATES_%WARNING'
          ORDER BY 2, 3;

       V_LATEST_COLLEGE_TOTAL    NUMBER (10);
       V_CURRENT_COLLEGE_TOTAL   NUMBER (10);
       V_LATEST_COURSE_TOTAL     NUMBER (10);
       V_CURRENT_COURSE_TOTAL    NUMBER (10);
       V_LATEST_TERM_TOTAL       NUMBER (10);
       V_CURRENT_TERM_TOTAL      NUMBER (10);
       V_COLLEGE_ERROR           VARCHAR2 (1);
       V_COURSE_ERROR            VARCHAR2 (1);
       V_TERM_ERROR              VARCHAR2 (1);
    BEGIN
       FOR GET_REC IN C_SUMMARY
       LOOP
          V_LATEST_COLLEGE_TOTAL := GET_REC.LATEST_COLLEGE_TOTAL;
          V_CURRENT_COLLEGE_TOTAL := GET_REC.CURRENT_COLLEGE_TOTAL;
          V_LATEST_COURSE_TOTAL := GET_REC.LATEST_COURSE_TOTAL;
          V_CURRENT_COURSE_TOTAL := GET_REC.CURRENT_COURSE_TOTAL;
          V_LATEST_TERM_TOTAL := GET_REC.LATEST_TERM_TOTAL;
          V_CURRENT_TERM_TOTAL := GET_REC.CURRENT_TERM_TOTAL;
       END LOOP;

       FOR GET_REC IN C_CONFIG
       LOOP
          --INSTITUTION
          IF     GET_REC.ITEM_NAME LIKE 'SLC_TERMDATES_INSTITUTION_%'
             AND (   (V_LATEST_COLLEGE_TOTAL - V_CURRENT_COLLEGE_TOTAL) >
                        GET_REC.NVAL
                  OR (V_CURRENT_COLLEGE_TOTAL - V_LATEST_COLLEGE_TOTAL) >
                        GET_REC.NVAL)
          THEN
             IF GET_REC.CVAL = 'E'
             THEN
                V_COLLEGE_ERROR := 'Y';
                TEST_STATUS := TEST_STATUS || 'ERROR';
                TEST_SUMMARY :=
                      TEST_SUMMARY
                   || CHR (10)
                   || 'INSTITUTIONS ERROR: LATEST = '
                   || TO_CHAR (V_LATEST_COLLEGE_TOTAL)
                   || ' CURRENT = '
                   || TO_CHAR (V_CURRENT_COLLEGE_TOTAL)
                   || ' DIFFERENCE = '
                   || TO_CHAR (V_LATEST_COLLEGE_TOTAL - V_CURRENT_COLLEGE_TOTAL);

                INSERT INTO SLC_FILE_DETAIL (CREATED_DATE,
                                             DETAIL_SECTION,
                                             DETAIL_TYPE,
                                             DETAIL_NVAL,
                                             SORT_ORDER)
                   SELECT V_SYSDATE,
                          'REASONABLE_TEST',
                             'INSTITUTIONS ERROR: LATEST = '
                          || TO_CHAR (V_LATEST_COLLEGE_TOTAL)
                          || ' CURRENT = '
                          || TO_CHAR (V_CURRENT_COLLEGE_TOTAL)
                          || ' DIFFERENCE = '
                          || TO_CHAR (
                                V_LATEST_COLLEGE_TOTAL - V_CURRENT_COLLEGE_TOTAL),
                          NULL,
                          101
                     FROM DUAL;
             END IF;

             IF GET_REC.CVAL = 'W' AND NVL (V_COLLEGE_ERROR, 'N') != 'Y'
             THEN
                TEST_STATUS := TEST_STATUS || 'WARNING';
                TEST_SUMMARY :=
                      TEST_SUMMARY
                   || CHR (10)
                   || 'INSTITUTIONS WARNING: LATEST = '
                   || TO_CHAR (V_LATEST_COLLEGE_TOTAL)
                   || ' CURRENT = '
                   || TO_CHAR (V_CURRENT_COLLEGE_TOTAL)
                   || ' DIFFERENCE = '
                   || TO_CHAR (V_LATEST_COLLEGE_TOTAL - V_CURRENT_COLLEGE_TOTAL);

                INSERT INTO SLC_FILE_DETAIL (CREATED_DATE,
                                             DETAIL_SECTION,
                                             DETAIL_TYPE,
                                             DETAIL_NVAL,
                                             SORT_ORDER)
                   SELECT V_SYSDATE,
                          'REASONABLE_TEST',
                             'INSTITUTIONS WARNING: LATEST = '
                          || TO_CHAR (V_LATEST_COLLEGE_TOTAL)
                          || ' CURRENT = '
                          || TO_CHAR (V_CURRENT_COLLEGE_TOTAL)
                          || ' DIFFERENCE = '
                          || TO_CHAR (
                                V_LATEST_COLLEGE_TOTAL - V_CURRENT_COLLEGE_TOTAL),
                          NULL,
                          102
                     FROM DUAL;
             END IF;
          END IF;

          -- COURSE
          IF     GET_REC.ITEM_NAME LIKE 'SLC_TERMDATES_COURSE_%'
             AND (   (V_LATEST_COURSE_TOTAL - V_CURRENT_COURSE_TOTAL) >
                        GET_REC.NVAL
                  OR (V_CURRENT_COURSE_TOTAL - V_LATEST_COURSE_TOTAL) >
                        GET_REC.NVAL)
          THEN
             IF GET_REC.CVAL = 'E'
             THEN
                V_COURSE_ERROR := 'Y';
                TEST_STATUS := TEST_STATUS || 'ERROR';
                TEST_SUMMARY :=
                      TEST_SUMMARY
                   || CHR (10)
                   || 'COURSE ERROR: LATEST = '
                   || TO_CHAR (V_LATEST_COURSE_TOTAL)
                   || ' CURRENT = '
                   || TO_CHAR (V_CURRENT_COURSE_TOTAL)
                   || ' DIFFERENCE = '
                   || TO_CHAR (V_LATEST_COURSE_TOTAL - V_CURRENT_COURSE_TOTAL);

                INSERT INTO SLC_FILE_DETAIL (CREATED_DATE,
                                             DETAIL_SECTION,
                                             DETAIL_TYPE,
                                             DETAIL_NVAL,
                                             SORT_ORDER)
                   SELECT V_SYSDATE,
                          'REASONABLE_TEST',
                             'COURSE ERROR: LATEST = '
                          || TO_CHAR (V_LATEST_COURSE_TOTAL)
                          || ' CURRENT = '
                          || TO_CHAR (V_CURRENT_COURSE_TOTAL)
                          || ' DIFFERENCE = '
                          || TO_CHAR (
                                V_LATEST_COURSE_TOTAL - V_CURRENT_COURSE_TOTAL),
                          NULL,
                          105
                     FROM DUAL;
             END IF;

             IF GET_REC.CVAL = 'W' AND NVL (V_COURSE_ERROR, 'N') != 'Y'
             THEN
                TEST_STATUS := TEST_STATUS || 'WARNING';
                TEST_SUMMARY :=
                      TEST_SUMMARY
                   || CHR (10)
                   || 'COURSE WARNING: LATEST = '
                   || TO_CHAR (V_LATEST_COURSE_TOTAL)
                   || ' CURRENT = '
                   || TO_CHAR (V_CURRENT_COURSE_TOTAL)
                   || ' DIFFERENCE = '
                   || TO_CHAR (V_LATEST_COURSE_TOTAL - V_CURRENT_COURSE_TOTAL);

                INSERT INTO SLC_FILE_DETAIL (CREATED_DATE,
                                             DETAIL_SECTION,
                                             DETAIL_TYPE,
                                             DETAIL_NVAL,
                                             SORT_ORDER)
                   SELECT V_SYSDATE,
                          'REASONABLE_TEST',
                             'COURSE WARNING: LATEST = '
                          || TO_CHAR (V_LATEST_COURSE_TOTAL)
                          || ' CURRENT = '
                          || TO_CHAR (V_CURRENT_COURSE_TOTAL)
                          || ' DIFFERENCE = '
                          || TO_CHAR (
                                V_LATEST_COURSE_TOTAL - V_CURRENT_COURSE_TOTAL),
                          NULL,
                          106
                     FROM DUAL;
             END IF;
          END IF;

          --TERM
          IF     GET_REC.ITEM_NAME LIKE 'SLC_TERMDATES_TERM_%'
             AND (   (V_LATEST_TERM_TOTAL - V_CURRENT_TERM_TOTAL) > GET_REC.NVAL
                  OR (V_CURRENT_TERM_TOTAL - V_LATEST_TERM_TOTAL) > GET_REC.NVAL)
          THEN
             IF GET_REC.CVAL = 'E'
             THEN
                V_TERM_ERROR := 'Y';
                TEST_STATUS := TEST_STATUS || 'ERROR';
                TEST_SUMMARY :=
                      TEST_SUMMARY
                   || CHR (10)
                   || 'TERM ERROR: LATEST = '
                   || TO_CHAR (V_LATEST_TERM_TOTAL)
                   || ' CURRENT = '
                   || TO_CHAR (V_CURRENT_TERM_TOTAL)
                   || ' DIFFERENCE = '
                   || TO_CHAR (V_LATEST_TERM_TOTAL - V_CURRENT_TERM_TOTAL);

                INSERT INTO SLC_FILE_DETAIL (CREATED_DATE,
                                             DETAIL_SECTION,
                                             DETAIL_TYPE,
                                             DETAIL_NVAL,
                                             SORT_ORDER)
                   SELECT V_SYSDATE,
                          'REASONABLE_TEST',
                             'TERM ERROR: LATEST = '
                          || TO_CHAR (V_LATEST_TERM_TOTAL)
                          || ' CURRENT = '
                          || TO_CHAR (V_CURRENT_TERM_TOTAL)
                          || ' DIFFERENCE = '
                          || TO_CHAR (V_LATEST_TERM_TOTAL - V_CURRENT_TERM_TOTAL),
                          NULL,
                          110
                     FROM DUAL;
             END IF;

             IF GET_REC.CVAL = 'W' AND NVL (V_TERM_ERROR, 'N') != 'Y'
             THEN
                TEST_STATUS := TEST_STATUS || 'WARNING';
                TEST_SUMMARY :=
                      TEST_SUMMARY
                   || CHR (10)
                   || 'TERM WARNING: LATEST = '
                   || TO_CHAR (V_LATEST_TERM_TOTAL)
                   || ' CURRENT = '
                   || TO_CHAR (V_CURRENT_TERM_TOTAL)
                   || ' DIFFERENCE = '
                   || TO_CHAR (V_LATEST_TERM_TOTAL - V_CURRENT_TERM_TOTAL);

                INSERT INTO SLC_FILE_DETAIL (CREATED_DATE,
                                             DETAIL_SECTION,
                                             DETAIL_TYPE,
                                             DETAIL_NVAL,
                                             SORT_ORDER)
                   SELECT V_SYSDATE,
                          'REASONABLE_TEST',
                             'TERM WARNING: LATEST = '
                          || TO_CHAR (V_LATEST_TERM_TOTAL)
                          || ' CURRENT = '
                          || TO_CHAR (V_CURRENT_TERM_TOTAL)
                          || ' DIFFERENCE = '
                          || TO_CHAR (V_LATEST_TERM_TOTAL - V_CURRENT_TERM_TOTAL),
                          NULL,
                          112
                     FROM DUAL;
             END IF;
          END IF;
       END LOOP;

       IF INSTR (TEST_STATUS, 'ERROR') > 0
       THEN
          TEST_STATUS := 'ERROR';
       ELSE
          IF INSTR (TEST_STATUS, 'WARNING') > 1
          THEN
             TEST_STATUS := 'WARNING';
          END IF;
       END IF;
    END REASONABLE_TEST;

   PROCEDURE MAINTAIN_SUMMARY
   /***************************************************************************************************
      This will populate the SLC_FILE_DETAIL table with the summary information about the files.

   ***************************************************************************************************/
   IS
   BEGIN
          INSERT INTO SLC_FILE_DETAIL (CREATED_DATE,
                                 DETAIL_SECTION,
                                 DETAIL_TYPE,
                                 DETAIL_NVAL,
                                 SORT_ORDER)
       SELECT V_SYSDATE,
              'SUMMARY' DETAIL_SECTION,
              Y.DETAIL_TYPE,
              Y.DETAIL_NVAL,
              ROWNUM SORT_ORDER
         FROM (SELECT X.CREATED_DATE, X.DETAIL_TYPE, X.DETAIL_NVAL
                 FROM (SELECT V_SYSDATE CREATED_DATE,
                                 'INSTITUTION FILES-'
                              || L1.SESSION_CODE
                              || '-LATEST_ROWS'
                                 DETAIL_TYPE,
                              L1.LATEST_ROWS DETAIL_NVAL
                         FROM (  SELECT L.SESSION_CODE, COUNT (0) LATEST_ROWS
                                   FROM (SELECT DISTINCT * FROM EXT_COLLEGE) L
                               GROUP BY L.SESSION_CODE
                               ORDER BY 1 DESC) L1
                       UNION ALL
                       SELECT V_SYSDATE,
                                 'INSTITUTION FILES-'
                              || C1.SESSION_CODE
                              || '-CURRENT_ROWS'
                                 DETAIL_TYPE,
                              C1.LATEST_ROWS DETAIL_NVAL
                         FROM (  SELECT C.SESSION_CODE, COUNT (0) LATEST_ROWS
                                   FROM (SELECT DISTINCT * FROM CURRENT_COLLEGE) C
                               GROUP BY C.SESSION_CODE
                               ORDER BY 1 DESC) C1) X
               UNION ALL
               SELECT X.CREATED_DATE, X.DETAIL_TYPE, X.DETAIL_NVAL
                 FROM (SELECT V_SYSDATE CREATED_DATE,
                                 'COURSE FILES-'
                              || L1.SESSION_CODE
                              || '-LATEST_ROWS'
                                 DETAIL_TYPE,
                              L1.LATEST_ROWS DETAIL_NVAL
                         FROM (  SELECT L.SESSION_CODE, COUNT (0) LATEST_ROWS
                                   FROM (SELECT DISTINCT * FROM EXT_COURSE) L
                               GROUP BY L.SESSION_CODE
                               ORDER BY 1 DESC) L1
                       UNION ALL
                       SELECT V_SYSDATE,
                                 'COURSE FILES-'
                              || C1.SESSION_CODE
                              || '-CURRENT_ROWS'
                                 DETAIL_TYPE,
                              C1.LATEST_ROWS DETAIL_NVAL
                         FROM (  SELECT C.SESSION_CODE, COUNT (0) LATEST_ROWS
                                   FROM (SELECT DISTINCT * FROM CURRENT_COURSE) C
                               GROUP BY C.SESSION_CODE
                               ORDER BY 1 DESC) C1) X
               ORDER BY 2 DESC) Y
       UNION ALL
       SELECT V_SYSDATE,
              'SUMMARY' DETAIL_SECTION,
              Y.DETAIL_TYPE,
              Y.DETAIL_NVAL,
              ROWNUM + 8 SORT_ORDER
         FROM (  SELECT X.CREATED_DATE, X.DETAIL_TYPE, X.DETAIL_NVAL
                   FROM (SELECT V_SYSDATE CREATED_DATE,
                                'TERM FILES-' || L1.SESSION_CODE || '-LATEST_ROWS'
                                   DETAIL_TYPE,
                                L1.LATEST_ROWS DETAIL_NVAL
                           FROM (  SELECT L.SESSION_CODE, COUNT (0) LATEST_ROWS
                                     FROM (SELECT DISTINCT * FROM EXT_TERM) L
                                 GROUP BY L.SESSION_CODE) L1
                         UNION ALL
                         SELECT V_SYSDATE,
                                'TERM FILES-' || C1.SESSION_CODE || '-CURRENT_ROWS'
                                   DETAIL_TYPE,
                                C1.LATEST_ROWS DETAIL_NVAL
                           FROM (  SELECT C.SESSION_CODE, COUNT (0) LATEST_ROWS
                                     FROM (SELECT DISTINCT * FROM CURRENT_TERM) C
                                 GROUP BY C.SESSION_CODE) C1) X
               ORDER BY 2 DESC) Y;
   END MAINTAIN_SUMMARY;


    PROCEDURE MAINTAIN_HEI
    /***************************************************************************************************
       This will insert any new institutions or courses into the HEI_INST or HEI_CRSE tables.

    ***************************************************************************************************/
    IS
    BEGIN
       INSERT INTO HEI_INST@GRASS (HEI_INST_CODE, HEI_INST_NAME)
          SELECT DISTINCT LC.HEI_INST_CODE, HEI_INST_NAME
            FROM (  SELECT HEI_INST_CODE,
                           INST_CODE,
                           HEI_INST_NAME,
                           SESSION_CODE,
                           MAX (MAX_FEE) MAX_FEE
                      FROM EXT_COLLEGE
                  GROUP BY HEI_INST_CODE, INST_CODE, HEI_INST_NAME, SESSION_CODE) LC
           WHERE NOT EXISTS
                    (SELECT 1
                       FROM HEI_INST@GRASS HI
                      WHERE HI.HEI_INST_CODE = LC.HEI_INST_CODE);

       INSERT INTO HEI_CRSE@GRASS (HEI_INST_CODE,
                                   HEI_CRSE_CODE,
                                   HEI_CRSE_NAME,
                                   SLC_CODE,
                                   SLC_COURSE_CODE,
                                   DURATION,
                                   VALID_YEARS)
          WITH HEI_CRSE_ALL
               AS (SELECT LC.HEI_INST_CODE,
                          NVL (LC.CRSE_CODE, LC.HEI_CRSE_CODE) HEI_CRSE_CODE,
                          LC.HEI_CRSE_NAME,
                          CASE
                             WHEN NVL (LC.HEI_CRSE_CODE, 'dummy') =
                                     NVL (LC.CRSE_CODE, LC.HEI_CRSE_CODE)
                             THEN
                                'Y'
                             ELSE
                                'N'
                          END
                             SLC_CODE,
                          LC.HEI_CRSE_CODE SLC_COURSE_CODE,
                          LC.DURATION
                     FROM (  SELECT HEI_INST_CODE,
                                    INST_CODE,
                                    CAMPUS,
                                    HEI_CRSE_CODE,
                                    CRSE_CODE,
                                    SCOTTISH,
                                    HEI_CRSE_NAME,
                                    DUMMY1,
                                    SESSION_CODE,
                                    DURATION
                               FROM EXT_COURSE
                           GROUP BY HEI_INST_CODE,
                                    INST_CODE,
                                    CAMPUS,
                                    HEI_CRSE_CODE,
                                    CRSE_CODE,
                                    SCOTTISH,
                                    HEI_CRSE_NAME,
                                    DUMMY1,
                                    SESSION_CODE,
                                    DURATION) LC)
          SELECT HEI_INST_CODE,
                 HEI_CRSE_CODE,
                 HEI_CRSE_NAME,
                 SLC_CODE,
                 SLC_COURSE_CODE,
                 DURATION,
                 NULL VALID_YEARS
            FROM HEI_CRSE_ALL HJ
          MINUS
          SELECT HEI_INST_CODE,
                 HEI_CRSE_CODE,
                 HEI_CRSE_NAME,
                 SLC_CODE,
                 SLC_COURSE_CODE,
                 DURATION,
                 NULL VALID_YEARS
            FROM HEI_CRSE_ALL HJ
           WHERE EXISTS
                    (SELECT 1
                       FROM HEI_CRSE@GRASS HC
                      WHERE     HC.HEI_INST_CODE = HJ.HEI_INST_CODE
                            AND HC.SLC_COURSE_CODE = HJ.SLC_COURSE_CODE);
    END MAINTAIN_HEI;


    PROCEDURE REFRESH_CURRENT
    /***************************************************************************************************
       This will refresh the CURRENT_COURSE and CURRENT_TERM for the data in the RESET_COURSE.
       This will also refresh the data in the COLLEGE_INST_LINK.

    ***************************************************************************************************/
    IS
    BEGIN
         INSERT INTO RESET_COURSE RC (RC.CRSE_ID, RC.SESSION_CODE)
           SELECT DISTINCT C.CRSE_ID, CS.SESSION_CODE
             FROM SLCADMIN.RESET_INST_TERM RIT,
                  SGAS.CRSE C,
                  SGAS.CRSE_SESSION CS,
                  SGAS.CRSE_YEAR CY
            WHERE     C.INST_CODE = RIT.INST_CODE
                  AND C.CRSE_ID = CS.CRSE_ID
                  AND CS.SESSION_CODE = RIT.SESSION_CODE
                  AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
                  AND NVL (CY.DEFAULT_TERMS, 'N') = 'Y'
                  AND RIT.SESSION_CODE IN (SELECT DISTINCT CC.SESSION_CODE
                                             FROM SLCADMIN.CURRENT_COLLEGE CC)
                  AND NOT EXISTS
                             (SELECT 1
                                FROM RESET_COURSE RC1
                               WHERE     RC1.CRSE_ID = C.CRSE_ID
                                     AND RC1.SESSION_CODE = CS.SESSION_CODE);
                                     
        DELETE FROM CURRENT_COURSE CC
        WHERE (CC.HEI_INST_CODE, CC.HEI_CRSE_CODE, CC.SESSION_CODE) IN 
        (SELECT DISTINCT HC.HEI_INST_CODE,
               COURSE.HEI_CRSE_CODE,
               COURSE.SESSION_CODE
               FROM ( SELECT C.CRSE_CODE,
                              C.CRSE_NAME,
                              C.INST_CODE,
                              I.HEI_INST_CODE,
                              NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) HEI_CRSE_CODE,
                              C.MAINT_CAMPUS CAMPUS,
                              SUBSTR(CS.MAX_DURATION,1,1) DURATION,
                              CS.SESSION_CODE SESSION_CODE
                         FROM SGAS.CRSE C,
                              SGAS.CRSE_SESSION CS,
                              SGAS.CRSE_YEAR CY,
                              SGAS.INST I,
                              SLCADMIN.RESET_COURSE RC 
                        WHERE     C.CRSE_ID = CS.CRSE_ID
                              AND RC.SESSION_CODE IN (2018, 2019)
                              AND C.CRSE_ID = CY.CRSE_ID
                              AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
                              AND I.INST_CODE = C.INST_CODE
                              AND RC.CRSE_ID = C.CRSE_ID
                              AND RC.SESSION_CODE = CS.SESSION_CODE
                     GROUP BY C.CRSE_CODE,
                              C.CRSE_NAME,
                              C.INST_CODE,
                              I.HEI_INST_CODE,
                              NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE),
                              C.MAINT_CAMPUS,
                              CS.MAX_DURATION,
                              CS.SESSION_CODE) COURSE,
                    HEI_CRSE@GRASS HC
              WHERE     (   COURSE.HEI_CRSE_CODE = HC.HEI_CRSE_CODE
                         OR COURSE.HEI_CRSE_CODE = TO_CHAR (HC.SLC_COURSE_CODE))
                    AND HC.HEI_INST_CODE = COURSE.HEI_INST_CODE);                                     
                            
       INSERT INTO CURRENT_COURSE (HEI_INST_CODE,
                                INST_CODE,
                                CAMPUS,
                                HEI_CRSE_CODE,
                                CRSE_CODE,
                                SCOTTISH,
                                HEI_CRSE_NAME,
                                SESSION_CODE,
                                DURATION)
         SELECT  DISTINCT HC.HEI_INST_CODE,
                COURSE.INST_CODE,
                COURSE.CAMPUS,
                COURSE.HEI_CRSE_CODE,
                COURSE.CRSE_CODE,
                'Y' SCOTTISH,
                HC.HEI_CRSE_NAME,
                COURSE.SESSION_CODE,
                COURSE.DURATION
           FROM ( SELECT C.CRSE_CODE,
                          C.CRSE_NAME,
                          C.INST_CODE,
                          I.HEI_INST_CODE,
                          NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) HEI_CRSE_CODE,
                          C.MAINT_CAMPUS CAMPUS,
                          SUBSTR(CS.MAX_DURATION,1,1) DURATION,
                          CS.SESSION_CODE SESSION_CODE
                     FROM SGAS.CRSE C,
                          SGAS.CRSE_SESSION CS,
                          SGAS.CRSE_YEAR CY,
                          SGAS.INST I,
                          SLCADMIN.RESET_COURSE RC 
                    WHERE     C.CRSE_ID = CS.CRSE_ID
                          AND RC.SESSION_CODE IN (2018, 2019)
                          AND C.CRSE_ID = CY.CRSE_ID
                          AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
                          AND I.INST_CODE = C.INST_CODE
                          AND RC.CRSE_ID = C.CRSE_ID
                          AND RC.SESSION_CODE = CS.SESSION_CODE
                 GROUP BY C.CRSE_CODE,
                          C.CRSE_NAME,
                          C.INST_CODE,
                          I.HEI_INST_CODE,
                          NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE),
                          C.MAINT_CAMPUS,
                          CS.MAX_DURATION,
                          CS.SESSION_CODE) COURSE,
                HEI_CRSE@GRASS HC
          WHERE     (   COURSE.HEI_CRSE_CODE = HC.HEI_CRSE_CODE
                     OR COURSE.HEI_CRSE_CODE = TO_CHAR (HC.SLC_COURSE_CODE))
                AND HC.HEI_INST_CODE = COURSE.HEI_INST_CODE;
    
        DELETE FROM CURRENT_TERM CC
            WHERE (CC.HEI_CRSE_CODE, CC.SESSION_CODE) IN 
            (SELECT DISTINCT COURSE.HEI_CRSE_CODE,
                             COURSE.SESSION_CODE
                   FROM ( SELECT C.CRSE_CODE,
                                  C.CRSE_NAME,
                                  C.INST_CODE,
                                  I.HEI_INST_CODE,
                                  NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) HEI_CRSE_CODE,
                                  C.MAINT_CAMPUS CAMPUS,
                                  SUBSTR(CS.MAX_DURATION,1,1) DURATION,
                                  CS.SESSION_CODE SESSION_CODE
                             FROM SGAS.CRSE C,
                                  SGAS.CRSE_SESSION CS,
                                  SGAS.CRSE_YEAR CY,
                                  SGAS.INST I,
                                  SLCADMIN.RESET_COURSE RC 
                            WHERE     C.CRSE_ID = CS.CRSE_ID
                                  AND RC.SESSION_CODE IN (2018, 2019)
                                  AND C.CRSE_ID = CY.CRSE_ID
                                  AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
                                  AND I.INST_CODE = C.INST_CODE
                                  AND RC.CRSE_ID = C.CRSE_ID
                                  AND RC.SESSION_CODE = CS.SESSION_CODE
                         GROUP BY C.CRSE_CODE,
                                  C.CRSE_NAME,
                                  C.INST_CODE,
                                  I.HEI_INST_CODE,
                                  NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE),
                                  C.MAINT_CAMPUS,
                                  CS.MAX_DURATION,
                                  CS.SESSION_CODE) COURSE,
                        HEI_CRSE@GRASS HC
                  WHERE     (   COURSE.HEI_CRSE_CODE = HC.HEI_CRSE_CODE
                             OR COURSE.HEI_CRSE_CODE = TO_CHAR (HC.SLC_COURSE_CODE))
                        AND HC.HEI_INST_CODE = COURSE.HEI_INST_CODE); 
                        
        INSERT INTO CURRENT_TERM (HEI_CRSE_CODE,
                                  ACADEMIC_YEAR,
                                  TERM,
                                  TERM_START,
                                  TERM_END,
                                  SESSION_CODE,
                                  FEES)
           SELECT DISTINCT NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) HEI_CRSE_CODE,
                           CY.CRSE_YEAR_NO ACADEMIC_YEAR,
                           CT.TERM_NO TERM,
                           CT.START_DATE TERM_START,
                           CT.END_DATE TERM_END,
                           CS.SESSION_CODE SESSION_CODE,
                           NVL (CY.VAR_TUITION_FEE_AMNT, 9250) FEES
             FROM SGAS.CRSE C,
                  SGAS.CRSE_SESSION CS,
                  SGAS.CRSE_YEAR CY,
                  SGAS.INST I,
                  SGAS.CRSE_TERM CT,
                  SGAS.HEI_CRSE@GRASS HC,
                  SLCADMIN.RESET_COURSE RC
            WHERE     C.CRSE_ID = CS.CRSE_ID
                  AND CS.SESSION_CODE IN (2018, 2019)
                  AND RC.CRSE_ID = C.CRSE_ID
                  AND RC.SESSION_CODE = CS.SESSION_CODE
                  AND C.CRSE_ID = CY.CRSE_ID
                  AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
                  AND I.INST_CODE = C.INST_CODE
                  AND CY.CRSE_YEAR_ID = CT.CRSE_YEAR_ID
                  AND NVL (CY.DEFAULT_TERMS, 'N') != 'Y'
                  AND (   NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) = HC.HEI_CRSE_CODE
                       OR NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) =
                             TO_CHAR (HC.SLC_COURSE_CODE))
                  AND HC.HEI_INST_CODE = I.HEI_INST_CODE
           UNION
           SELECT DISTINCT NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) HEI_CRSE_CODE,
                           CY.CRSE_YEAR_NO ACADEMIC_YEAR,
                           IT.TERM_NO TERM,
                           IT.START_DATE TERM_START,
                           IT.END_DATE TERM_END,
                           CS.SESSION_CODE SESSION_CODE,
                           NVL (CY.VAR_TUITION_FEE_AMNT, 9250) FEES
             FROM SGAS.CRSE C,
                  SGAS.CRSE_SESSION CS,
                  SGAS.CRSE_YEAR CY,
                  SGAS.INST I,
                  SGAS.INST_TERM IT,
                  SGAS.HEI_CRSE@GRASS HC,
                  SLCADMIN.RESET_COURSE RC
            WHERE     C.CRSE_ID = CS.CRSE_ID
                  AND CS.SESSION_CODE IN (2018, 2019)
                  AND RC.CRSE_ID = C.CRSE_ID
                  AND RC.SESSION_CODE = CS.SESSION_CODE
                  AND C.CRSE_ID = CY.CRSE_ID
                  AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
                  AND I.INST_CODE = C.INST_CODE
                  AND NVL (CY.DEFAULT_TERMS, 'N') = 'Y'
                  AND (   NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) = HC.HEI_CRSE_CODE
                       OR NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) =
                             TO_CHAR (HC.SLC_COURSE_CODE))
                  AND HC.HEI_INST_CODE = I.HEI_INST_CODE
                  AND C.INST_CODE = IT.INST_CODE
                  AND CS.SESSION_CODE = IT.SESSION_CODE;   
        DELETE FROM CURRENT_TERM CT
        WHERE CT.HEI_CRSE_CODE IS NULL;
                          
        COMMIT;
        EXECUTE IMMEDIATE 'TRUNCATE TABLE RESET_COURSE REUSE STORAGE';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE RESET_INST_TERM REUSE STORAGE';
        
        EXECUTE IMMEDIATE 'TRUNCATE  TABLE COLLEGE_INST_LINK REUSE STORAGE';

        INSERT INTO COLLEGE_INST_LINK (HEI_INST_CODE, INST_CODE)
           SELECT DISTINCT i.hei_inst_code, i.inst_code
             FROM sgas.inst i
            WHERE     i.hei_inst_code IS NOT NULL
                  AND i.hei_inst_code IN (  SELECT i1.hei_inst_code
                                              FROM sgas.inst i1
                                             WHERE hei_inst_code IS NOT NULL
                                          GROUP BY i1.hei_inst_code
                                            HAVING COUNT (DISTINCT i1.inst_code) > 1)
                  AND EXISTS
                         (SELECT 1
                            FROM sgas.crse_session cs, sgas.crse c
                           WHERE     c.crse_id = cs.crse_id
                           and cs.session_code IN ( 2019, 2018)
                                 AND c.inst_code = i.inst_code)
                                 order by 1,2;


        DELETE FROM COLLEGE_INST_LINK C
              WHERE C.HEI_INST_CODE NOT IN (  SELECT C1.HEI_INST_CODE
                                                FROM COLLEGE_INST_LINK C1
                                            GROUP BY C1.HEI_INST_CODE
                                              HAVING COUNT (0) > 1);
        COMMIT;             
    END REFRESH_CURRENT;
    
   PROCEDURE GENERATE_CHANGES
   /***************************************************************************************************
      This will compare the latest data against the current data to seewhat changes there are All
      changes will be inserted into the changes tables..

   ***************************************************************************************************/
   IS
   BEGIN
      -- NEW COLLEGES
      INSERT INTO COLLEGE_CHANGE CCH (CCH.HEI_INST_CODE,
                                      CCH.NEW_INST_CODE,
                                      CCH.NEW_HEI_INST_NAME,
                                      CCH.NEW_MAX_FEE,
                                      CCH.OLD_INST_CODE,
                                      CCH.OLD_HEI_INST_NAME,
                                      CCH.OLD_MAX_FEE,
                                      CCH.CHANGE_TYPE,
                                      CCH.CREATED_DATE,
                                      CCH.CREATED_BY,
                                      CCH.STATUS,
                                      CCH.STATUS_BY,
                                      CCH.SESSION_CODE)
         SELECT LC.HEI_INST_CODE,
                NVL (CIL.INST_CODE, LC.INST_CODE) NEW_INST_CODE,
                LC.HEI_INST_NAME NEW_HEI_INST_NAME,
                LC.MAX_FEE NEW_MAX_FEE,
                NULL OLD_INST_CODE,
                NULL OLD_HEI_INST_NAME,
                NULL OLD_MAX_FEE,
                'I' CHANGE_TYPE,
                V_SYSDATE CREATED_DATE,
                'SLCADMIN' CREATED_BY,
                'NEW' STATUS,
                'SLCADMIN' STATUS_BY,
                LC.SESSION_CODE SESSION_CODE
           FROM LATEST_COLLEGE LC, COLLEGE_INST_LINK CIL
          WHERE     LC.HEI_INST_CODE = CIL.HEI_INST_CODE
                AND NOT EXISTS
                           (SELECT 1
                              FROM CURRENT_COLLEGE CC
                             WHERE     CC.HEI_INST_CODE = LC.HEI_INST_CODE
                                   AND NVL(LC.INST_CODE,'DUMMY') =  NVL(CC.INST_CODE,'DUMMY'))
UNION ALL
SELECT LC.HEI_INST_CODE,
       LC.INST_CODE NEW_INST_CODE,
       LC.HEI_INST_NAME NEW_HEI_INST_NAME,
       LC.MAX_FEE NEW_MAX_FEE,
       NULL OLD_INST_CODE,
       NULL OLD_HEI_INST_NAME,
       NULL OLD_MAX_FEE,
       'I' CHANGE_TYPE,
               V_SYSDATE CREATED_DATE,
       'SLCADMIN' CREATED_BY,
       'NEW' STATUS,
       'SLCADMIN' STATUS_BY,
       LC.SESSION_CODE SESSION_CODE
  FROM LATEST_COLLEGE LC
 WHERE     NOT EXISTS
                  (SELECT 1
                     FROM CURRENT_COLLEGE CC
                    WHERE     CC.HEI_INST_CODE = LC.HEI_INST_CODE
                          AND NVL (CC.INST_CODE, 'DUMMY') =
                                 NVL (CC.INST_CODE, 'DUMMY'))
       AND NOT EXISTS
              (SELECT 1
                 FROM COLLEGE_INST_LINK CIL
                WHERE LC.HEI_INST_CODE = CIL.HEI_INST_CODE); 

      -- REMOVED COLLEGES
      INSERT INTO COLLEGE_CHANGE CCH (CCH.HEI_INST_CODE,
                                      CCH.NEW_INST_CODE,
                                      CCH.NEW_HEI_INST_NAME,
                                      CCH.NEW_MAX_FEE,
                                      CCH.OLD_INST_CODE,
                                      CCH.OLD_HEI_INST_NAME,
                                      CCH.OLD_MAX_FEE,
                                      CCH.CHANGE_TYPE,
                                      CCH.CREATED_DATE,
                                      CCH.CREATED_BY,
                                      CCH.STATUS,
                                      CCH.STATUS_BY,
                                      CCH.SESSION_CODE)
         SELECT DISTINCT CC.HEI_INST_CODE,
               CC.INST_CODE NEW_INST_CODE,
               CC.HEI_INST_NAME NEW_HEI_INST_NAME,
               CC.MAX_FEE NEW_MAX_FEE,
               NULL OLD_INST_CODE,
               NULL OLD_HEI_INST_NAME,
               NULL OLD_MAX_FEE,
               'D' CHANGE_TYPE,
               V_SYSDATE CREATED_DATE,
               'SLCADMIN' CREATED_BY,
               'NEW' STATUS,
               'SLCADMIN' STATUS_BY,
               CC.SESSION_CODE SESSION_CODE
          FROM CURRENT_COLLEGE CC
         WHERE     NOT EXISTS
                      (SELECT 1
                         FROM COLLEGE_INST_LINK CIL
                        WHERE CC.HEI_INST_CODE = CIL.HEI_INST_CODE)
               AND NOT EXISTS
                      (SELECT 1
                         FROM LATEST_COLLEGE LC
                        WHERE LC.HEI_INST_CODE = CC.HEI_INST_CODE)
        UNION 
        SELECT DISTINCT CC.HEI_INST_CODE,
               CC.INST_CODE NEW_INST_CODE,
               CC.HEI_INST_NAME NEW_HEI_INST_NAME,
               CC.MAX_FEE NEW_MAX_FEE,
               NULL OLD_INST_CODE,
               NULL OLD_HEI_INST_NAME,
               NULL OLD_MAX_FEE,
               'D' CHANGE_TYPE,
               V_SYSDATE CREATED_DATE,
               'SLCADMIN' CREATED_BY,
               'NEW' STATUS,
               'SLCADMIN' STATUS_BY,
               CC.SESSION_CODE SESSION_CODE
           FROM CURRENT_COLLEGE CC
         WHERE     NOT EXISTS
                          (SELECT 1
                             FROM LATEST_COLLEGE LC
                            WHERE     LC.HEI_INST_CODE = CC.HEI_INST_CODE
                                  AND NVL (CC.INST_CODE, 'DUMMY') =
                                         NVL (LC.INST_CODE, 'DUMMY'))
               AND NOT EXISTS
                          (SELECT 1
                             FROM LATEST_COLLEGE LC, COLLEGE_INST_LINK CIL
                            WHERE     LC.HEI_INST_CODE = CIL.HEI_INST_CODE
                                  AND (   NVL (CIL.INST_CODE, 'DUMMY') =
                                             NVL (LC.INST_CODE, 'DUMMY')
                                       OR     CC.INST_CODE IS NULL
                                          AND LC.INST_CODE IS NULL));

      -- CHANGED COLLEGES

      INSERT INTO COLLEGE_CHANGE CCH (CCH.HEI_INST_CODE,
                                      CCH.NEW_INST_CODE,
                                      CCH.NEW_HEI_INST_NAME,
                                      CCH.NEW_MAX_FEE,
                                      CCH.OLD_INST_CODE,
                                      CCH.OLD_HEI_INST_NAME,
                                      CCH.OLD_MAX_FEE,
                                      CCH.CHANGE_TYPE,
                                      CCH.CREATED_DATE,
                                      CCH.CREATED_BY,
                                      CCH.STATUS,
                                      CCH.STATUS_BY,
                                      CCH.SESSION_CODE)
         SELECT DISTINCT LC.HEI_INST_CODE,
                LC.INST_CODE NEW_INST_CODE,
                LC.HEI_INST_NAME NEW_HEI_INST_NAME,
                LC.MAX_FEE NEW_MAX_FEE,
                CC.INST_CODE OLD_INST_CODE,
                CC.HEI_INST_NAME OLD_HEI_INST_NAME,
                CC.MAX_FEE OLD_MAX_FEE,
                'U' CHANGE_TYPE,
                V_SYSDATE CREATED_DATE,
                'SLCADMIN' CREATED_BY,
                'NEW' STATUS,
                'SLCADMIN' STATUS_BY,
                LC.SESSION_CODE SESSION_CODE
           FROM (SELECT DISTINCT LC.HEI_INST_CODE,
                        NVL (CIL.INST_CODE, LC.INST_CODE) INST_CODE,
                        LC.HEI_INST_NAME HEI_INST_NAME,
                        LC.MAX_FEE MAX_FEE,
                        LC.SESSION_CODE
                   FROM LATEST_COLLEGE LC, COLLEGE_INST_LINK CIL
                  WHERE LC.HEI_INST_CODE = CIL.HEI_INST_CODE(+)) LC,
                (SELECT DISTINCT CC.HEI_INST_CODE,
                        NVL (CIL.INST_CODE, CC.INST_CODE) INST_CODE,
                        CC.HEI_INST_NAME HEI_INST_NAME,
                        CC.MAX_FEE MAX_FEE,
                        CC.SESSION_CODE
                   FROM CURRENT_COLLEGE CC, COLLEGE_INST_LINK CIL
                  WHERE CC.HEI_INST_CODE = CIL.HEI_INST_CODE(+)) CC
          WHERE     LC.HEI_INST_CODE = CC.HEI_INST_CODE
                AND LC.SESSION_CODE = CC.SESSION_CODE
                AND (   LC.HEI_INST_NAME <> CC.HEI_INST_NAME
                     OR LC.MAX_FEE <> CC.MAX_FEE);


      -- NEW COURSES
      INSERT INTO COURSE_CHANGE CCH (CCH.HEI_INST_CODE,
                                     CCH.NEW_INST_CODE,
                                     CCH.NEW_CAMPUS,
                                     CCH.NEW_HEI_CRSE_CODE,
                                     CCH.NEW_CRSE_CODE,
                                     CCH.NEW_SCOTTISH,
                                     CCH.NEW_HEI_CRSE_NAME,
                                     CCH.DUMMY1,
                                     CCH.NEW_DURATION,
                                     CCH.OLD_INST_CODE,
                                     CCH.OLD_CAMPUS,
                                     CCH.OLD_HEI_CRSE_CODE,
                                     CCH.OLD_CRSE_CODE,
                                     CCH.OLD_SCOTTISH,
                                     CCH.OLD_HEI_CRSE_NAME,
                                     CCH.OLD_DURATION,
                                     CCH.CHANGE_TYPE,
                                     CCH.CREATED_DATE,
                                     CCH.CREATED_BY,
                                     CCH.STATUS,
                                     CCH.STATUS_BY,
                                     CCH.SESSION_CODE)
         SELECT DISTINCT LC.HEI_INST_CODE HEI_INST_CODE,
                LC.INST_CODE NEW_INST_CODE,
                LC.CAMPUS NEW_CAMPUS,
                LC.HEI_CRSE_CODE NEW_HEI_CRSE_CODE,
                LC.CRSE_CODE NEW_CRSE_CODE,
                'Y' NEW_SCOTTISH,
                LC.HEI_CRSE_NAME NEW_HEI_CRSE_NAME,
                NULL DUMMY1,
                LC.DURATION NEW_DURATION,
                NULL OLD_INST_CODE,
                NULL OLD_CAMPUS,
                NULL OLD_HEI_CRSE_CODE,
                NULL OLD_CRSE_CODE,
                NULL OLD_SCOTTISH,
                NULL OLD_HEI_CRSE_NAME,
                NULL OLD_DURATION,
                'I' CHANGE_TYPE,
                V_SYSDATE CREATED_DATE,
                'SLCADMIN' CREATED_BY,
                'NEW' STATUS,
                'SLCADMIN' STATUS_BY,
                LC.SESSION_CODE SESSION_CODE
           FROM LATEST_COURSE LC, CURRENT_COLLEGE CCO
           WHERE     LC.SCOTTISH = 'Y'
           AND LC.HEI_INST_CODE = CCO.HEI_INST_CODE
                AND NOT EXISTS
                           (SELECT 1
                              FROM CURRENT_COURSE CC
                             WHERE     CC.HEI_CRSE_CODE = LC.HEI_CRSE_CODE
                                   AND CC.HEI_INST_CODE = LC.HEI_INST_CODE
                                   AND CC.SESSION_CODE = LC.SESSION_CODE
                                   AND CC.SCOTTISH = 'Y');

      -- REMOVED COURSES
      INSERT INTO COURSE_CHANGE CCH (CCH.HEI_INST_CODE,
                                     CCH.NEW_INST_CODE,
                                     CCH.NEW_CAMPUS,
                                     CCH.NEW_HEI_CRSE_CODE,
                                     CCH.NEW_CRSE_CODE,
                                     CCH.NEW_SCOTTISH,
                                     CCH.NEW_HEI_CRSE_NAME,
                                     CCH.DUMMY1,
                                     CCH.NEW_DURATION,
                                     CCH.OLD_INST_CODE,
                                     CCH.OLD_CAMPUS,
                                     CCH.OLD_HEI_CRSE_CODE,
                                     CCH.OLD_CRSE_CODE,
                                     CCH.OLD_SCOTTISH,
                                     CCH.OLD_HEI_CRSE_NAME,
                                     CCH.OLD_DURATION,
                                     CCH.CHANGE_TYPE,
                                     CCH.CREATED_DATE,
                                     CCH.CREATED_BY,
                                     CCH.STATUS,
                                     CCH.STATUS_BY,
                                     CCH.SESSION_CODE)
         SELECT DISTINCT CC.HEI_INST_CODE HEI_INST_CODE,
                NULL NEW_INST_CODE,
                NULL NEW_CAMPUS,
                NULL NEW_HEI_CRSE_CODE,
                NULL NEW_CRSE_CODE,
                NULL NEW_SCOTTISH,
                NULL NEW_HEI_CRSE_NAME,
                NULL DUMMY1,
                NULL NEW_DURATION,
                CC.INST_CODE OLD_INST_CODE,
                CC.CAMPUS OLD_CAMPUS,
                CC.HEI_CRSE_CODE OLD_HEI_CRSE_CODE,
                CC.CRSE_CODE OLD_CRSE_CODE,
                'Y' OLD_SCOTTISH,
                CC.HEI_CRSE_NAME OLD_HEI_CRSE_NAME,
                CC.DURATION OLD_DURATION,
                'D' CHANGE_TYPE,
                V_SYSDATE CREATED_DATE,
                'SLCADMIN' CREATED_BY,
                'NEW' STATUS,
                'SLCADMIN' STATUS_BY,
                CC.SESSION_CODE SESSION_CODE
           FROM CURRENT_COURSE CC
          WHERE     CC.SCOTTISH = 'Y'
                AND NOT EXISTS
                           (SELECT 1
                              FROM LATEST_COURSE LC
                             WHERE     LC.HEI_CRSE_CODE = CC.HEI_CRSE_CODE
                                   AND LC.HEI_INST_CODE = CC.HEI_INST_CODE
                                   AND LC.SESSION_CODE = CC.SESSION_CODE
                                   AND LC.SCOTTISH = 'Y');


      -- UPDATED COURSES
      INSERT INTO COURSE_CHANGE CCH (CCH.HEI_INST_CODE,
                                     CCH.NEW_INST_CODE,
                                     CCH.NEW_CAMPUS,
                                     CCH.NEW_HEI_CRSE_CODE,
                                     CCH.NEW_CRSE_CODE,
                                     CCH.NEW_SCOTTISH,
                                     CCH.NEW_HEI_CRSE_NAME,
                                     CCH.DUMMY1,
                                     CCH.NEW_DURATION,
                                     CCH.OLD_INST_CODE,
                                     CCH.OLD_CAMPUS,
                                     CCH.OLD_HEI_CRSE_CODE,
                                     CCH.OLD_CRSE_CODE,
                                     CCH.OLD_SCOTTISH,
                                     CCH.OLD_HEI_CRSE_NAME,
                                     CCH.OLD_DURATION,
                                     CCH.CHANGE_TYPE,
                                     CCH.CREATED_DATE,
                                     CCH.CREATED_BY,
                                     CCH.STATUS,
                                     CCH.STATUS_BY,
                                     CCH.SESSION_CODE)
         SELECT DISTINCT CC.HEI_INST_CODE HEI_INST_CODE,
                LC.INST_CODE NEW_INST_CODE,
                LC.CAMPUS NEW_CAMPUS,
                LC.HEI_CRSE_CODE NEW_HEI_CRSE_CODE,
                LC.CRSE_CODE NEW_CRSE_CODE,
                'Y' NEW_SCOTTISH,
                LC.HEI_CRSE_NAME NEW_HEI_CRSE_NAME,
                NULL DUMMY1,
                LC.DURATION NEW_DURATION,
                CC.INST_CODE OLD_INST_CODE,
                CC.CAMPUS OLD_CAMPUS,
                CC.HEI_CRSE_CODE OLD_HEI_CRSE_CODE,
                CC.CRSE_CODE OLD_CRSE_CODE,
                'Y' OLD_SCOTTISH,
                CC.HEI_CRSE_NAME OLD_HEI_CRSE_NAME,
                CC.DURATION OLD_DURATION,
                'U' CHANGE_TYPE,
                V_SYSDATE CREATED_DATE,
                'SLCADMIN' CREATED_BY,
                'NEW' STATUS,
                'SLCADMIN' STATUS_BY,
                CC.SESSION_CODE SESSION_CODE
           FROM CURRENT_COURSE CC, LATEST_COURSE LC
          WHERE     CC.SCOTTISH = 'Y'
                AND LC.HEI_CRSE_CODE = CC.HEI_CRSE_CODE
                AND LC.HEI_INST_CODE = CC.HEI_INST_CODE
                AND LC.SESSION_CODE = CC.SESSION_CODE
                AND (   RTRIM(LC.HEI_CRSE_NAME) <> RTRIM(CC.HEI_CRSE_NAME)
                     OR LC.DURATION <> CC.DURATION);

      --     AND LC.SCOTTISH = 'Y';

      -- NEW TERMS

      INSERT INTO TERM_CHANGE TC (TC.HEI_CRSE_CODE,
                                  TC.ACADEMIC_YEAR,
                                  TC.TERM,
                                  TC.NEW_TERM_START,
                                  TC.NEW_TERM_END,
                                  TC.NEW_FEES,
                                  TC.OLD_TERM_START,
                                  TC.OLD_TERM_END,
                                  TC.OLD_FEES,
                                  TC.CHANGE_TYPE,
                                  TC.CREATED_DATE,
                                  TC.CREATED_BY,
                                  TC.STATUS,
                                  TC.STATUS_BY,
                                  TC.SESSION_CODE)
         SELECT DISTINCT LT.HEI_CRSE_CODE,
                LT.ACADEMIC_YEAR,
                LT.TERM,
                LT.TERM_START NEW_TERM_START,
                LT.TERM_END NEW_TERM_END,
                LT.FEES NEW_FEES,
                NULL OLD_TERM_START,
                NULL OLD_TERM_END,
                NULL OLD_FEES,
                'I' CHANGE_TYPE,
                V_SYSDATE CREATED_DATE,
                'SLCADMIN' CREATED_BY,
                'NEW' STATUS,
                'SLCADMIN' STATUS_BY,
                LT.SESSION_CODE SESSION_CODE
           FROM LATEST_TERM LT, LATEST_COURSE LC, CURRENT_COLLEGE CC
          WHERE LT.HEI_CRSE_CODE = LC.HEI_CRSE_CODE
          AND LC.HEI_INST_CODE = CC.HEI_INST_CODE
          AND LC.SCOTTISH = 'Y'
          AND NOT EXISTS
                       (SELECT 1
                          FROM CURRENT_TERM CT
                         WHERE     CT.HEI_CRSE_CODE = LT.HEI_CRSE_CODE
                               AND CT.ACADEMIC_YEAR = LT.ACADEMIC_YEAR
                               AND CT.TERM = LT.TERM
                               AND CT.SESSION_CODE = LT.SESSION_CODE);

      -- REMOVED TERMS

      INSERT INTO TERM_CHANGE TC (TC.HEI_CRSE_CODE,
                                  TC.ACADEMIC_YEAR,
                                  TC.TERM,
                                  TC.NEW_TERM_START,
                                  TC.NEW_TERM_END,
                                  TC.NEW_FEES,
                                  TC.OLD_TERM_START,
                                  TC.OLD_TERM_END,
                                  TC.OLD_FEES,
                                  TC.CHANGE_TYPE,
                                  TC.CREATED_DATE,
                                  TC.CREATED_BY,
                                  TC.STATUS,
                                  TC.STATUS_BY,
                                  TC.SESSION_CODE)
         SELECT DISTINCT CT.HEI_CRSE_CODE,
                CT.ACADEMIC_YEAR,
                CT.TERM,
                NULL NEW_TERM_START,
                NULL NEW_TERM_END,
                NULL NEW_FEES,
                CT.TERM_START OLD_TERM_START,
                CT.TERM_END OLD_TERM_END,
                CT.FEES OLD_FEES,
                'D' CHANGE_TYPE,
                V_SYSDATE CREATED_DATE,
                'SLCADMIN' CREATED_BY,
                'NEW' STATUS,
                'SLCADMIN' STATUS_BY,
                CT.SESSION_CODE SESSION_CODE
           FROM CURRENT_TERM CT
          WHERE NOT EXISTS
                       (SELECT 1
                          FROM LATEST_TERM LT
                         WHERE     LT.HEI_CRSE_CODE = CT.HEI_CRSE_CODE
                               AND LT.ACADEMIC_YEAR = CT.ACADEMIC_YEAR
                               AND LT.TERM = CT.TERM
                               AND LT.SESSION_CODE = CT.SESSION_CODE);

      -- UPDATED TERMS

      INSERT INTO TERM_CHANGE TC (TC.HEI_CRSE_CODE,
                                  TC.ACADEMIC_YEAR,
                                  TC.TERM,
                                  TC.NEW_TERM_START,
                                  TC.NEW_TERM_END,
                                  TC.NEW_FEES,
                                  TC.OLD_TERM_START,
                                  TC.OLD_TERM_END,
                                  TC.OLD_FEES,
                                  TC.CHANGE_TYPE,
                                  TC.CREATED_DATE,
                                  TC.CREATED_BY,
                                  TC.STATUS,
                                  TC.STATUS_BY,
                                  TC.SESSION_CODE)
         SELECT DISTINCT CT.HEI_CRSE_CODE,
                CT.ACADEMIC_YEAR,
                CT.TERM,
                LT.TERM_START NEW_TERM_START,
                LT.TERM_END NEW_TERM_END,
                LT.FEES NEW_FEES,
                CT.TERM_START OLD_TERM_START,
                CT.TERM_END OLD_TERM_END,
                CT.FEES OLD_FEES,
                'U' CHANGE_TYPE,
                V_SYSDATE CREATED_DATE,
                'SLCADMIN' CREATED_BY,
                'NEW' STATUS,
                'SLCADMIN' STATUS_BY,
                CT.SESSION_CODE SESSION_CODE
           FROM CURRENT_TERM CT, LATEST_TERM LT
          WHERE     LT.HEI_CRSE_CODE = CT.HEI_CRSE_CODE
                AND LT.ACADEMIC_YEAR = CT.ACADEMIC_YEAR
                AND LT.TERM = CT.TERM
                AND LT.SESSION_CODE = CT.SESSION_CODE
                AND (   LT.TERM_START <> CT.TERM_START
                     OR LT.TERM_END <> CT.TERM_END
                     OR LT.FEES <> CT.FEES);
   END GENERATE_CHANGES;


   PROCEDURE COPY_LATEST_TO_CURRENT
   /***************************************************************************************************
      This will copy the latest data to the current data tables.

   ***************************************************************************************************/
   IS
   BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE CURRENT_COLLEGE REUSE STORAGE';

      EXECUTE IMMEDIATE 'TRUNCATE TABLE CURRENT_COURSE REUSE STORAGE';

      EXECUTE IMMEDIATE 'TRUNCATE TABLE CURRENT_TERM REUSE STORAGE';

      INSERT INTO CURRENT_COLLEGE
         SELECT * FROM LATEST_COLLEGE;

      INSERT INTO CURRENT_COURSE
         SELECT * FROM LATEST_COURSE;

      INSERT INTO CURRENT_TERM
         SELECT * FROM LATEST_TERM;
   END COPY_LATEST_TO_CURRENT;

   PROCEDURE REJECT_UNUSED_CHANGES
   /***************************************************************************************************
      Any change for courses where the Institution does not exist in GRASS will be rejected.
      Any change for terms where the course does not exist in GRASS will be rejected. 

   ***************************************************************************************************/
   IS
   
   CURSOR C_CRSE_TERM_DATES
   IS
   WITH TCH
     AS (SELECT /*+ PARALLEL (TC1,4) */ DISTINCT TC1.*
           FROM TERM_CHANGE TC1
          WHERE TC1.CHANGE_TYPE IN ('I', 'U') AND TC1.STATUS = 'NEW' AND TC1.CREATED_DATE = V_SYSDATE)
    SELECT DISTINCT TC.ROWID TC_ROWID
        FROM TCH TC, CURRENT_GRASS_TERM CGT
     WHERE     TC.HEI_CRSE_CODE = CGT.HEI_CRSE_CODE
           AND TC.SESSION_CODE = CGT.SESSION_CODE
           AND TC.ACADEMIC_YEAR = CGT.ACADEMIC_YEAR
           AND TC.TERM = CGT.TERM
           AND TC.NEW_TERM_START = CGT.TERM_START
           AND TC.NEW_TERM_END = CGT.TERM_END
           AND TC.NEW_FEES <> TC.OLD_FEES
           AND NOT (CGT.SCHEME_TYPE = 'U' AND CGT.RUK = 'Y'  );
           
           

   TYPE t_tab IS TABLE OF C_CRSE_TERM_DATES%ROWTYPE;
    l_tab    t_tab := t_tab();    
       
   BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE CURRENT_GRASS_TERM REUSE STORAGE';

        INSERT /* APPEND */ INTO CURRENT_GRASS_TERM
           (
           HEI_CRSE_CODE,
           ACADEMIC_YEAR,
           TERM,
           TERM_START,
           TERM_END,
           SESSION_CODE,
           FEES,
           CRSE_YEAR_ID,
           CRSE_ID,
           SCHEME_TYPE,
           RUK
           )
           SELECT /*+ PARALLEL( CS,8 )PARALLEL( CY,8 )  */
                  DISTINCT NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) HEI_CRSE_CODE,
                           CY.CRSE_YEAR_NO ACADEMIC_YEAR,
                           CT.TERM_NO TERM,
                           CT.START_DATE TERM_START,
                           CT.END_DATE TERM_END,
                           CS.SESSION_CODE SESSION_CODE,
                           NVL (CY.VAR_TUITION_FEE_AMNT, -1) FEES,
                           CY.CRSE_YEAR_ID,
                           C.CRSE_ID,
                           C.SCHEME_TYPE,
                           CASE
                              WHEN I.LOCATION_IND IN (2,
                                                      3,
                                                      4,
                                                      5)
                              THEN
                                 'Y'
                              ELSE
                                 'N'
                           END
                              RUK
             FROM SGAS.CRSE C,
                  SGAS.CRSE_SESSION CS,
                  SGAS.CRSE_YEAR CY,
                  SGAS.INST I,
                  SGAS.CRSE_TERM CT,
                  HEI_CRSE@grass HC
            WHERE     C.CRSE_ID = CS.CRSE_ID
                  AND CS.SESSION_CODE IN (TO_CHAR (SYSDATE, 'YYYY') + 1,
                                          TO_CHAR (SYSDATE, 'YYYY'),
                                          TO_CHAR (SYSDATE, 'YYYY') - 1)
                  AND C.CRSE_ID = CY.CRSE_ID
                  AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
                  AND I.INST_CODE = C.INST_CODE
                  AND CY.CRSE_YEAR_ID = CT.CRSE_YEAR_ID
                  AND NVL (CY.DEFAULT_TERMS, 'N') != 'Y'
                  AND (   NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) = HC.HEI_CRSE_CODE
                       OR NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) =
                             TO_CHAR (HC.SLC_COURSE_CODE))
                  AND HC.HEI_INST_CODE = I.HEI_INST_CODE
           UNION
           SELECT /*+ PARALLEL( CS,8 )PARALLEL( CY,8 )  */
                  DISTINCT NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) HEI_CRSE_CODE,
                           CY.CRSE_YEAR_NO ACADEMIC_YEAR,
                           IT.TERM_NO TERM,
                           IT.START_DATE TERM_START,
                           IT.END_DATE TERM_END,
                           CS.SESSION_CODE SESSION_CODE,
                           NVL (CY.VAR_TUITION_FEE_AMNT, -1) FEES,
                           CY.CRSE_YEAR_ID,
                           C.CRSE_ID,
                           C.SCHEME_TYPE,
                           CASE
                              WHEN I.LOCATION_IND IN (2,
                                                      3,
                                                      4,
                                                      5)
                              THEN
                                 'Y'
                              ELSE
                                 'N'
                           END
                              RUK
             FROM SGAS.CRSE C,
                  SGAS.CRSE_SESSION CS,
                  SGAS.CRSE_YEAR CY,
                  SGAS.INST I,
                  SGAS.INST_TERM IT,
                  HEI_CRSE@grass HC
            WHERE     C.CRSE_ID = CS.CRSE_ID
                  AND CS.SESSION_CODE IN (TO_CHAR (SYSDATE, 'YYYY') + 1,
                                          TO_CHAR (SYSDATE, 'YYYY'),
                                          TO_CHAR (SYSDATE, 'YYYY') - 1)
                  AND C.CRSE_ID = CY.CRSE_ID
                  AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
                  AND I.INST_CODE = C.INST_CODE
                  AND NVL (CY.DEFAULT_TERMS, 'N') = 'Y'
                  AND (   NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) = HC.HEI_CRSE_CODE
                       OR NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) =
                             TO_CHAR (HC.SLC_COURSE_CODE))
                  AND HC.HEI_INST_CODE = I.HEI_INST_CODE
                  AND C.INST_CODE = IT.INST_CODE
                  AND CS.SESSION_CODE = IT.SESSION_CODE
           UNION
           SELECT /*+ PARALLEL( CS,8 )PARALLEL( CY,8 )  */
                  DISTINCT NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) HEI_CRSE_CODE,
                           CY.CRSE_YEAR_NO ACADEMIC_YEAR,
                           0 TERM,
                           SYSDATE + 1000 TERM_START,
                           SYSDATE + 1000 TERM_END,
                           CS.SESSION_CODE SESSION_CODE,
                           NVL (CY.VAR_TUITION_FEE_AMNT, -1) FEES,
                           CY.CRSE_YEAR_ID,
                           C.CRSE_ID,
                           C.SCHEME_TYPE,
                           CASE
                              WHEN I.LOCATION_IND IN (2,
                                                      3,
                                                      4,
                                                      5)
                              THEN
                                 'Y'
                              ELSE
                                 'N'
                           END
                              RUK
             FROM SGAS.CRSE C,
                  SGAS.CRSE_SESSION CS,
                  SGAS.CRSE_YEAR CY,
                  SGAS.INST I,
                  HEI_CRSE@grass HC
            WHERE     C.CRSE_ID = CS.CRSE_ID
                  AND CS.SESSION_CODE IN (TO_CHAR (SYSDATE, 'YYYY') + 1,
                                          TO_CHAR (SYSDATE, 'YYYY'),
                                          TO_CHAR (SYSDATE, 'YYYY') - 1)
                  AND C.CRSE_ID = CY.CRSE_ID
                  AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
                  AND I.INST_CODE = C.INST_CODE
                  AND NVL (CY.DEFAULT_TERMS, 'N') = 'Y'
                  AND (   NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) = HC.HEI_CRSE_CODE
                       OR NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) =
                             TO_CHAR (HC.SLC_COURSE_CODE))
                  AND HC.HEI_INST_CODE = I.HEI_INST_CODE
                  AND NOT EXISTS
                             (SELECT 1
                                FROM SGAS.INST_TERM IT
                               WHERE     C.INST_CODE = IT.INST_CODE
                                     AND CS.SESSION_CODE = IT.SESSION_CODE);
                                     
        COMMIT; 

--    UPDATE COURSE_CHANGE CC
--       SET CC.STATUS = 'REJECTED',
--           CC.STATUS_REASON = 'INSTITUTION NOT IN STEPS'
     DELETE FROM  COURSE_CHANGE CC
     WHERE     CC.CREATED_DATE = V_SYSDATE
     AND CC.STATUS = 'NEW'
           AND NOT EXISTS
                  (SELECT 1
                     FROM SGAS.INST I
                    WHERE I.HEI_INST_CODE = CC.HEI_INST_CODE);
                    
--    UPDATE TERM_CHANGE TC
--       SET TC.STATUS = 'REJECTED',
--           TC.STATUS_REASON = 'COURSE SESSION NOT IN STEPS'
     DELETE FROM TERM_CHANGE TC
     WHERE     TC.CREATED_DATE = V_SYSDATE
     AND TC.STATUS = 'NEW'
           AND NOT EXISTS
                  (SELECT 1
                     FROM CURRENT_GRASS_TERM CGT
                    WHERE TC.HEI_CRSE_CODE = CGT.HEI_CRSE_CODE  
                    AND TC.SESSION_CODE = CGT.SESSION_CODE  );                    

-- reject rows where the term dates are correct
    OPEN C_CRSE_TERM_DATES;
    LOOP
    
        FETCH C_CRSE_TERM_DATES BULK COLLECT INTO l_tab LIMIT 1000;
        EXIT WHEN l_tab.count = 0;
        DBMS_OUTPUT.PUT_LINE('C_CRSE_TERM_DATES : '||to_char(l_tab.count()));
        
        FORALL i IN l_tab.first..l_tab.last
--            UPDATE TERM_CHANGE TC
--            SET TC.STATUS = 'REJECTED',
--                TC.STATUS_REASON = 'FEE CHANGE NOT RUK UNDERGRADUATE'
            DELETE FROM TERM_CHANGE TC
            WHERE TC.ROWID = l_tab(i).TC_ROWID;
            
            
    END LOOP;
    CLOSE C_CRSE_TERM_DATES;
   

    END REJECT_UNUSED_CHANGES;
    
    PROCEDURE POPULATE_HEI_INST_CODE
   /***************************************************************************************************
      This will update the HEI_INST_CODE on the TERM_CHANGE rows.

   ***************************************************************************************************/
   IS
   CURSOR C_TC IS
   SELECT TC.TERM_CHANGE_ID, H.HEI_INST_CODE
    FROM HEI_CRSE@GRASS H, TERM_CHANGE TC
    WHERE  TC.HEI_CRSE_CODE = TO_CHAR(H.SLC_COURSE_CODE)
    AND TC.CHANGE_TYPE != 'D'
    AND TC.HEI_INST_CODE IS NULL
    UNION 
       SELECT TC.TERM_CHANGE_ID, CC.HEI_INST_CODE
    FROM CURRENT_COURSE CC, TERM_CHANGE TC
    WHERE  TC.HEI_CRSE_CODE = CC.HEI_CRSE_CODE
    AND TC.CHANGE_TYPE = 'D'
    AND TC.HEI_INST_CODE IS NULL
    UNION 
    SELECT DISTINCT TC.TERM_CHANGE_ID, H.HEI_INST_CODE
     FROM TERM_CHANGE TC, HEI_CRSE@GRASS H
     WHERE TC.HEI_INST_CODE IS NULL
     AND TC.HEI_CRSE_CODE = H.HEI_CRSE_CODE
     AND TRIM(TRANSLATE(TC.HEI_CRSE_CODE, '0123456789',' ')) IS NULL;
    
    TYPE T_TAB IS TABLE OF C_TC%ROWTYPE;
    l_tab T_TAB := T_TAB();
    
    BEGIN
        OPEN C_TC;
    LOOP
    
        FETCH C_TC BULK COLLECT INTO l_tab LIMIT 10000;
        EXIT WHEN l_tab.count = 0;
   --     DBMS_OUTPUT.PUT_LINE('C_CRSE_TERM_DATES : '||to_char(l_tab.count()));
        
        FORALL i IN l_tab.first..l_tab.last
            UPDATE TERM_CHANGE TC
            SET TC.HEI_INST_CODE = l_tab(i).HEI_INST_CODE
            WHERE TC.TERM_CHANGE_ID = l_tab(i).TERM_CHANGE_ID;
            
            
    END LOOP;
    CLOSE C_TC;
    COMMIT;
    END POPULATE_HEI_INST_CODE;
       
   PROCEDURE AUTOMATE_SAFE_CHANGES
   /***************************************************************************************************
      The generated changes are used to determine safe changes. All safe changes will be
      automatically made to the Institution, course and term data.

   ***************************************************************************************************/
   IS
   
      CURSOR C_CRSE_TERM_DATES
   IS
/* Formatted on 08/11/2018 15:04:13 (QP5 v5.256.13226.35538) */
    WITH TCH
         AS (SELECT /*+ PARALLEL (TC1,4) */
                    DISTINCT TC1.ROWID TC_ROWID,
                             TC1.ACADEMIC_YEAR,
                             TC1.HEI_CRSE_CODE,
                             TC1.NEW_TERM_END,
                             TC1.NEW_TERM_START,
                             TC1.SESSION_CODE,
                             TC1.STATUS,
                             TC1.TERM,
                             TC1.NEW_FEES,
                             TC1.OLD_FEES,
                             CGT.CRSE_ID, 
                             CGT.CRSE_YEAR_ID,
                             CGT.SCHEME_TYPE,
                             CGT.RUK
               FROM TERM_CHANGE TC1,
                    (SELECT CD.CVAL SESSION_CODE
                       FROM SGAS.CONFIG_DATA CD
                      WHERE CD.ITEM_NAME = 'CURRENT_SESSION') SESS,
                    CURRENT_GRASS_TERM CGT
              WHERE     TC1.CHANGE_TYPE IN ('I', 'U')
                    AND TC1.STATUS = 'NEW'
                    AND TC1.SESSION_CODE >= SESS.SESSION_CODE
                    AND TC1.HEI_CRSE_CODE = CGT.HEI_CRSE_CODE
                    AND TC1.SESSION_CODE = CGT.SESSION_CODE
                    AND TC1.CREATED_DATE = V_SYSDATE
                    AND NOT EXISTS
                           (SELECT 1
                              FROM SGAS.STUD_CRSE_YEAR SCY, CURRENT_GRASS_TERM CGT1
                              WHERE    CGT1.CRSE_ID = SCY.CRSE_ID 
                              AND CGT1.HEI_CRSE_CODE = TC1.HEI_CRSE_CODE
                              AND CGT1.SESSION_CODE = TC1.SESSION_CODE
                              AND SCY.SESSION_CODE = TC1.SESSION_CODE   ))
      SELECT /*+ PARALLEL (CGT,4) */
               DISTINCT TC.TC_ROWID,
                      TC.ACADEMIC_YEAR,
                      TC.HEI_CRSE_CODE,
                      TC.NEW_TERM_END,
                      TC.NEW_TERM_START,
                      TC.SESSION_CODE,
                      TC.STATUS,
                      TC.TERM,
                      TC.NEW_FEES,
                      CGT.CRSE_YEAR_ID,
                      CGT.TERM TERM_NO,
                      CGT.TERM_START START_DATE,
                      CGT.TERM_END END_DATE,
                      CGT.SCHEME_TYPE,
                      CGT.RUK
        FROM TCH TC, CURRENT_GRASS_TERM CGT
       WHERE     TC.HEI_CRSE_CODE = CGT.HEI_CRSE_CODE
             AND TC.SESSION_CODE = CGT.SESSION_CODE
             AND TC.ACADEMIC_YEAR = CGT.ACADEMIC_YEAR
             AND TC.TERM = CGT.TERM
             AND (   TC.NEW_TERM_START <> CGT.TERM_START
                  OR TC.NEW_TERM_END <> CGT.TERM_END
                  OR NVL(TC.NEW_FEES,-2) <> NVL(TC.OLD_FEES,-1) )
    ORDER BY 1,
             TC.SESSION_CODE,
             2,
             3;
               
         
    CURSOR C_MISSING_INST_TERM
    IS
    /* Formatted on 11/10/2018 09:34:26 (QP5 v5.256.13226.35538) */
        WITH TCH
         AS (SELECT /*+ PARALLEL (TC1,4) */
                    DISTINCT TC1.ROWID TC_ROWID,
                             TC1.ACADEMIC_YEAR,
                             TC1.HEI_CRSE_CODE,
                             TC1.NEW_TERM_END,
                             TC1.NEW_TERM_START,
                             TC1.SESSION_CODE,
                             TC1.STATUS,
                             TC1.TERM,
                             TC1.NEW_FEES,
                             TC1.OLD_FEES,
                             CGT.CRSE_ID, 
                             CGT.CRSE_YEAR_ID,
                             CGT.SCHEME_TYPE,
                             CGT.RUK
               FROM TERM_CHANGE TC1,
                    (SELECT CD.CVAL SESSION_CODE
                       FROM SGAS.CONFIG_DATA CD
                      WHERE CD.ITEM_NAME = 'CURRENT_SESSION') SESS,
                    CURRENT_GRASS_TERM CGT
              WHERE     TC1.CHANGE_TYPE IN ('I', 'U')
                    AND TC1.STATUS = 'NEW'
                    AND TC1.SESSION_CODE >= SESS.SESSION_CODE
                    AND TC1.HEI_CRSE_CODE = CGT.HEI_CRSE_CODE
                    AND TC1.SESSION_CODE = CGT.SESSION_CODE
                    AND TC1.CREATED_DATE = V_SYSDATE
                    AND NOT EXISTS
                           (SELECT 1
                              FROM SGAS.STUD_CRSE_YEAR SCY, CURRENT_GRASS_TERM CGT1
                              WHERE    CGT1.CRSE_ID = SCY.CRSE_ID 
                              AND CGT1.HEI_CRSE_CODE = TC1.HEI_CRSE_CODE
                              AND CGT1.SESSION_CODE = TC1.SESSION_CODE
                              AND SCY.SESSION_CODE = TC1.SESSION_CODE   ))
      SELECT /*+ PARALLEL (CGT,4) */
               DISTINCT TC.TC_ROWID,
                      TC.ACADEMIC_YEAR,
                      TC.HEI_CRSE_CODE,
                      TC.NEW_TERM_END,
                      TC.NEW_TERM_START,
                      TC.SESSION_CODE,
                      TC.STATUS,
                      TC.TERM,
                      TC.NEW_FEES,
                      CGT.CRSE_YEAR_ID,
                      CGT.TERM TERM_NO,
                      CGT.TERM_START START_DATE,
                      CGT.TERM_END END_DATE,
                      CGT.SCHEME_TYPE,
                      CGT.RUK
        FROM TCH TC, CURRENT_GRASS_TERM CGT
       WHERE     TC.HEI_CRSE_CODE = CGT.HEI_CRSE_CODE
             AND TC.SESSION_CODE = CGT.SESSION_CODE
             AND TC.ACADEMIC_YEAR = CGT.ACADEMIC_YEAR
             AND 0 = CGT.TERM
             AND (   TC.NEW_TERM_START <> CGT.TERM_START
                  OR TC.NEW_TERM_END <> CGT.TERM_END
                  OR NVL(TC.NEW_FEES,-2) <> NVL(TC.OLD_FEES,-1))
    ORDER BY 1,
             TC.SESSION_CODE,
             2,
             3;     

   BEGIN
   
    FOR GET_REC IN C_CRSE_TERM_DATES
    LOOP
    
        UPDATE SGAS.CRSE_YEAR CY
        SET CY.DEFAULT_TERMS = 'N',
            CY.VAR_TUITION_FEE_AMNT = CASE
                                        WHEN GET_REC.SCHEME_TYPE = 'U' AND GET_REC.RUK = 'Y'
                                        THEN
                                            TO_NUMBER(GET_REC.NEW_FEES)
                                        ELSE
                                             CY.VAR_TUITION_FEE_AMNT
                                        END,
            CY.VAR_SANDWICH_TUITION_FEE_AMNT = CASE
                                        WHEN GET_REC.SCHEME_TYPE = 'U' AND GET_REC.RUK = 'Y'
                                        THEN
                                            ROUND(TO_NUMBER(GET_REC.NEW_FEES) / 2)
                                        ELSE
                                             CY.VAR_SANDWICH_TUITION_FEE_AMNT
                                        END,
            CY.LAST_UPDATED_BY = 'SLCADMIN'
        WHERE CY.CRSE_YEAR_ID = GET_REC.CRSE_YEAR_ID;


   --     USING (SELECT GET_REC.CRSE_YEAR_ID CRSE_YEAR_ID, GET_REC.TERM TERM_NO, 1 DAYS, GET_REC.NEW_TERM_START START_DATE, GET_REC.NEW_TERM_END END_DATE  FROM DUAL) S
        
        MERGE INTO SGAS.CRSE_TERM CT
        USING (SELECT GET_REC.CRSE_YEAR_ID CRSE_YEAR_ID, LT.TERM TERM_NO, (LT.TERM_END - LT.TERM_START) + 1 DAYS, LT.TERM_START START_DATE, LT.TERM_END END_DATE 
                FROM LATEST_TERM LT
                WHERE LT.HEI_CRSE_CODE = GET_REC.HEI_CRSE_CODE
                AND LT.SESSION_CODE = GET_REC.SESSION_CODE
                AND LT.ACADEMIC_YEAR = GET_REC.ACADEMIC_YEAR ) S
        ON (CT.CRSE_YEAR_ID = S.CRSE_YEAR_ID AND CT.TERM_NO = S.TERM_NO)
        WHEN MATCHED THEN
            UPDATE SET CT.START_DATE = S.START_DATE,
                       CT.END_DATE = S.END_DATE,
                       CT.DAYS = S.DAYS,
                       CT.LAST_UPDATED_BY = 'SLCADMIN'
        WHEN NOT MATCHED THEN
        INSERT (CRSE_YEAR_ID, TERM_NO, DAYS, START_DATE, END_DATE, LAST_UPDATED_BY)
        VALUES (S.CRSE_YEAR_ID, S.TERM_NO, S.DAYS, S.START_DATE, S.END_DATE, 'SLCADMIN');
        
        UPDATE TERM_CHANGE TC
        SET TC.STATUS = 'AUTHORISED'
        WHERE TC.ROWID = GET_REC.TC_ROWID;
            
            
            
    END LOOP;
 
-- ADD LOOP FOR INST 

    FOR GET_REC IN C_MISSING_INST_TERM
    LOOP
    
        UPDATE SGAS.CRSE_YEAR CY
        SET CY.DEFAULT_TERMS = 'N',
            CY.VAR_TUITION_FEE_AMNT = CASE
                                        WHEN GET_REC.SCHEME_TYPE = 'U' AND GET_REC.RUK = 'Y'
                                        THEN
                                            TO_NUMBER(GET_REC.NEW_FEES)
                                        ELSE
                                             CY.VAR_TUITION_FEE_AMNT
                                        END,
            CY.VAR_SANDWICH_TUITION_FEE_AMNT = CASE
                                        WHEN GET_REC.SCHEME_TYPE = 'U' AND GET_REC.RUK = 'Y'
                                        THEN
                                            ROUND(TO_NUMBER(GET_REC.NEW_FEES) / 2)
                                        ELSE
                                             CY.VAR_SANDWICH_TUITION_FEE_AMNT
                                        END,
            CY.LAST_UPDATED_BY = 'SLCADMIN'
        WHERE CY.CRSE_YEAR_ID = GET_REC.CRSE_YEAR_ID;

--        USING (SELECT GET_REC.CRSE_YEAR_ID CRSE_YEAR_ID, GET_REC.TERM TERM_NO, TRUNC(GET_REC.NEW_TERM_END) - TRUNC(GET_REC.NEW_TERM_START) DAYS, GET_REC.NEW_TERM_START START_DATE, GET_REC.NEW_TERM_END END_DATE  FROM DUAL) S
        
        
        MERGE INTO SGAS.CRSE_TERM CT
        USING (SELECT GET_REC.CRSE_YEAR_ID CRSE_YEAR_ID, LT.TERM TERM_NO, (TRUNC(LT.TERM_END) - TRUNC(LT.TERM_START)) + 1 DAYS, LT.TERM_START START_DATE, LT.TERM_END END_DATE 
                FROM LATEST_TERM LT
                WHERE LT.HEI_CRSE_CODE = GET_REC.HEI_CRSE_CODE
                AND LT.SESSION_CODE = GET_REC.SESSION_CODE
                AND LT.ACADEMIC_YEAR = GET_REC.ACADEMIC_YEAR ) S
        ON (CT.CRSE_YEAR_ID = S.CRSE_YEAR_ID AND CT.TERM_NO = S.TERM_NO)
        WHEN MATCHED THEN
            UPDATE SET CT.START_DATE = S.START_DATE,
                       CT.END_DATE = S.END_DATE,
                       CT.DAYS = S.DAYS,
                       CT.LAST_UPDATED_BY = 'SLCADMIN'
        WHEN NOT MATCHED THEN
        INSERT (CRSE_YEAR_ID, TERM_NO, DAYS, START_DATE, END_DATE, LAST_UPDATED_BY)
        VALUES (S.CRSE_YEAR_ID, S.TERM_NO, S.DAYS, S.START_DATE, S.END_DATE, 'SLCADMIN');
        
        UPDATE TERM_CHANGE TC
        SET TC.STATUS = 'AUTHORISED'
        WHERE TC.ROWID = GET_REC.TC_ROWID;
            
            
            
    END LOOP;


   END AUTOMATE_SAFE_CHANGES;
   
   PROCEDURE SET_DEFAULT_INST_DATES
   /***************************************************************************************************
      The will check that the default Institution dates are set for the coming session.
   ***************************************************************************************************/
   IS
   BEGIN
      NULL;
   END SET_DEFAULT_INST_DATES;   



   PROCEDURE PROCESS_TERM_DATES
   IS
   

      V_BADFILES   VARCHAR2 (4000) NULL;
      V_TEST_STATUS VARCHAR2(1000);
      V_TEST_SUMMARY VARCHAR2(1000);
      V_LOCKED_STATUS VARCHAR2(500);
      V_LOCKED_MESSAGE VARCHAR2(500);
      
   BEGIN
      V_SYSDATE := SYSDATE;
      LOAD_TERM_DATES;
      V_BADFILES := VALIDATE_TERM_DATES;
      REASONABLE_TEST (V_TEST_STATUS,
                       V_TEST_SUMMARY);
      MAINTAIN_SUMMARY;
      COMMIT;

      IF V_BADFILES IS NOT NULL 
      THEN
         DBMS_OUTPUT.PUT_LINE ('ITS NOT VALID : ' || V_BADFILES);
         RAISE_APPLICATION_ERROR(-20000, 'Data is not valid: '|| V_BADFILES);
      ELSIF NVL(V_TEST_STATUS,'DUMMY') = 'ERROR'
      THEN 
         DBMS_OUTPUT.PUT_LINE ('ITS NOT VALID : ' );
         RAISE_APPLICATION_ERROR(-20000, 'Data Failed reasonable tests: '|| V_TEST_SUMMARY);
      ELSE
         DBMS_OUTPUT.PUT_LINE ('ITS  VALID : ' || V_BADFILES);
         SGAS.PK_GENERAL_LOCKING.UNLOCKALLRECORDS ( 'SLCADMIN' );
         SGAS.PK_GENERAL_LOCKING.LOCKRECORD ( USERNAME_IN => 'SLCADMIN', 
                                              REFERENCE_TYPE_IN => 'TERMDATES', 
                                              REFERENCE_ID_IN => 'ALL', 
                                              LOCKED_STATUS => V_LOCKED_STATUS, 
                                              LOCKED_MESSAGE => V_LOCKED_MESSAGE );
         DELETE FROM SGAS.CRSE_CODE CC
         WHERE CC.CREATED_DATE < SYSDATE - 1
         AND NOT EXISTS (SELECT 1 FROM SGAS.CRSE C WHERE C.INST_CODE = CC.INST_CODE AND C.CRSE_CODE = CC.CRSE_CODE);
         COMMIT; 
         MAINTAIN_HEI;
         REFRESH_CURRENT;
         GENERATE_CHANGES;
         COMMIT;
         REJECT_UNUSED_CHANGES;
         COMMIT;
         POPULATE_HEI_INST_CODE;
         COMMIT;
         AUTOMATE_SAFE_CHANGES;         
         
         COPY_LATEST_TO_CURRENT;   
         EXECUTE IMMEDIATE 'TRUNCATE TABLE RESET_COURSE REUSE STORAGE';

         SGAS.PK_GENERAL_LOCKING.UNLOCKRECORD ( USERNAME_IN => 'SLCADMIN', 
                                      REFERENCE_TYPE_IN => 'TERMDATES', 
                                      REFERENCE_ID_IN => 'ALL', 
                                      LOCKED_STATUS => V_LOCKED_STATUS, 
                                      LOCKED_MESSAGE => V_LOCKED_MESSAGE );
      
    --     SET_DEFAULT_INST_DATES;
    COMMIT;
      END IF;

   --   EXCEPTION
   --      WHEN OTHERS
   --      THEN
   --         error_boolean := 'true';
   --         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END PROCESS_TERM_DATES;
END PK_TERM_DATES;
/