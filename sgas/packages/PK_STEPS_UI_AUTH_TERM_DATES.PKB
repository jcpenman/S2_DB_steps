CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_UI_AUTH_TERM_DATES
AS
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
            WHERE     INST.INST_CODE = NVL (instCode_in, INST.INST_CODE)
                  AND INST.INST_NAME LIKE
                         UPPER (
                            '%' || NVL (instName_in, INST.INST_NAME) || '%')
         ORDER BY 2;


      io_cursor := termDates_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      /*
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         */
   END searchInstitute;

   PROCEDURE getSessionList (io_cursor       IN OUT        TERM_DATES_CURSOR,
                             error_boolean      OUT NOCOPY VARCHAR2,
                             ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      SessionList_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN SessionList_cursor FOR
         SELECT TO_CHAR (ROWNUM + 2016) SESSION_CODE
          FROM STUD
         WHERE ROWNUM <=   (SELECT GREATEST(NVAL,(SELECT MAX(SESSION_CODE ) FROM CRSE_SESSION)) SESSION_CODE
                             FROM CONFIG_DATA CD
                            WHERE CD.ITEM_NAME = 'CURRENT_SESSION'
                            )
                        - 2016
        ORDER BY 1 DESC;

      io_cursor := SessionList_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getSessionList;
   
   
    PROCEDURE getCourses (newHEICrseCode_in   IN            VARCHAR2,
                          oldHEICrseCode_in   IN            VARCHAR2,
                          changeType_in       IN            VARCHAR2,
                          sessionCode_in      IN            VARCHAR2,
                          courseChangeId_in   IN            NUMBER,
                          crseId_in           IN            VARCHAR2,
                          io_cursor           IN OUT        TERM_DATES_CURSOR,
                          error_boolean          OUT NOCOPY VARCHAR2,
                          ERROR_TEXT             OUT NOCOPY VARCHAR2)
   IS
      CoursesList_cursor   TERM_DATES_CURSOR;
      V_HEI_CRSE_CODE VARCHAR2(100);
   BEGIN
    IF crseId_in is null
    then     
      IF changeType_in = 'D'
      THEN
        V_HEI_CRSE_CODE := NVL(oldHEICrseCode_in, newHEICrseCode_in);
      ELSE
        V_HEI_CRSE_CODE := newHEICrseCode_in;
      END IF;
      OPEN CoursesList_cursor FOR
         SELECT TO_CHAR(X.CRSE_ID) CRSE_ID, X.CRSE_CODE, X.CRSE_NAME, X.INST_CODE, X.INST_NAME, TO_CHAR(COUNT(0) OVER()) TOTAL_ROWS
         FROM (SELECT DISTINCT C.CRSE_ID,  C.CRSE_CODE, C.CRSE_NAME, C.INST_CODE, C.INST_NAME
          FROM CRSE C, CRSE_SESSION CS, CRSE_YEAR CY
         WHERE     CS.SESSION_CODE = sessionCode_in
               AND CY.HEI_CRSE_CODE = V_HEI_CRSE_CODE
               AND CY.CRSE_SESSION_ID = CS.CRSE_SESSION_ID
               AND CS.CRSE_ID = C.CRSE_ID
        UNION 
        SELECT DISTINCT C.CRSE_ID, C.CRSE_CODE, C.CRSE_NAME, C.INST_CODE, C.INST_NAME
          FROM CRSE C, CRSE_SESSION CS, CRSE_YEAR CY
         WHERE     CS.SESSION_CODE = sessionCode_in
               AND C.HEI_CRSE_CODE = V_HEI_CRSE_CODE
               AND NULL = CY.HEI_CRSE_CODE(+)
               AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID(+)
               AND NOT EXISTS (SELECT 1 FROM CRSE_YEAR CY1 WHERE CY1.CRSE_SESSION_ID = CS.CRSE_SESSION_ID AND CY1.HEI_CRSE_CODE = C.HEI_CRSE_CODE)
               AND CS.CRSE_ID = C.CRSE_ID
         UNION
         SELECT  DISTINCT C.CRSE_ID, C.CRSE_CODE, C.CRSE_NAME, C.INST_CODE, C.INST_NAME
            FROM CRSE C, CRSE_SESSION CS, CRSE_YEAR CY
           WHERE     CY.HEI_CRSE_CODE = V_HEI_CRSE_CODE
                 AND CY.CRSE_SESSION_ID = CS.CRSE_SESSION_ID
                 AND CS.CRSE_ID = C.CRSE_ID
                 AND NOT EXISTS
                            (SELECT 1
                               FROM CRSE_YEAR CY1, CRSE_SESSION CS1
                              WHERE     CY1.CRSE_SESSION_ID = CS1.CRSE_SESSION_ID
                                    AND CY1.HEI_CRSE_CODE = V_HEI_CRSE_CODE
                                    AND CS1.SESSION_CODE = sessionCode_in  )  ) X
        ORDER BY 3,2;
    ELSE
        OPEN CoursesList_cursor FOR
        SELECT TO_CHAR(C.CRSE_ID) CRSE_ID, C.CRSE_CODE, C.CRSE_NAME, C.INST_CODE, C.INST_NAME, TO_CHAR(COUNT(0) OVER()) TOTAL_ROWS
        FROM CRSE C
        WHERE C.CRSE_ID = crseId_in;
    END IF;
      io_cursor := CoursesList_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCourses;                             

   PROCEDURE getInstituteChanges (
      status_new_in             IN            VARCHAR2,
      status_authorised_in      IN            VARCHAR2,
      status_rejected_in        IN            VARCHAR2,
      change_type_inserted_in   IN            VARCHAR2,
      change_type_deleted_in    IN            VARCHAR2,
      change_type_updated_in    IN            VARCHAR2,
      change_latest_only_in     IN            VARCHAR2,
      change_all_in             IN            VARCHAR2,
      change_all_batch_in       IN            VARCHAR2,
      change_steps_only_in      IN            VARCHAR2,
      session_code_in           IN            VARCHAR2,
      hei_inst_code_in          IN            VARCHAR2,
      max_search_results_in     IN            VARCHAR2,
      io_cursor                 IN OUT        TERM_DATES_CURSOR,
      error_boolean                OUT NOCOPY VARCHAR2,
      ERROR_TEXT                   OUT NOCOPY VARCHAR2)
   IS
      instchanges_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN instchanges_cursor FOR
         SELECT CC.HEI_INST_CODE,
                CC.NEW_INST_CODE,
                CC.NEW_HEI_INST_NAME,
                CC.NEW_MAX_FEE,
                CC.OLD_INST_CODE,
                CC.OLD_HEI_INST_NAME,
                CC.OLD_MAX_FEE,
                CC.CHANGE_TYPE,
                TO_CHAR(CC.CREATED_DATE,'dd/mm/yyyy') CREATED_DATE,
                PK_GENERAL_LOCKING.get_employee_name(CC.CREATED_BY) CREATED_BY,
                CC.STATUS,
                PK_GENERAL_LOCKING.get_employee_name(CC.STATUS_BY) STATUS_BY,
                CC.SESSION_CODE,
                CC.COLLEGE_CHANGE_ID                
           FROM SLCADMIN.COLLEGE_CHANGE cc
          WHERE   CC.HEI_INST_CODE = NVL (HEI_INST_CODE_IN, CC.HEI_INST_CODE)
          AND   cc.status IN (NVL (status_new_in, 'x'),
                                  NVL (status_authorised_in, 'x'),
                                  NVL (status_rejected_in, 'x'))
                AND CC.CHANGE_TYPE IN (NVL (change_type_inserted_in, 'x'),
                                       NVL (change_type_deleted_in, 'x'),
                                       NVL (change_type_updated_in, 'x'))
                AND CC.SESSION_CODE = session_code_in
                AND (   (    change_latest_only_in = 'TRUE'
                         AND CC.CREATED_DATE =
                                (SELECT MAX (CREATED_DATE)
                                   FROM SLCADMIN.COLLEGE_CHANGE cc1
                                  WHERE CC1.CREATED_BY = 'SLCADMIN'))
                     OR (change_all_in = 'TRUE')
                    OR (change_all_batch_in = 'TRUE' AND CC.CREATED_BY = 'SLCADMIN')
                     OR (    change_steps_only_in = 'TRUE'
                         AND CC.CREATED_BY <> 'SLCADMIN'))
                 AND ROWNUM < TO_NUMBER(MAX_SEARCH_RESULTS_IN) + 1
           order by 1,2,3,5,6;


      io_cursor := instchanges_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getInstituteChanges;
   
   PROCEDURE getCourseChanges (
      status_new_in             IN            VARCHAR2,
      status_authorised_in      IN            VARCHAR2,
      status_rejected_in        IN            VARCHAR2,
      change_type_inserted_in   IN            VARCHAR2,
      change_type_deleted_in    IN            VARCHAR2,
      change_type_updated_in    IN            VARCHAR2,
      change_latest_only_in     IN            VARCHAR2,
      change_all_in             IN            VARCHAR2,
      change_all_batch_in       IN            VARCHAR2,
      change_steps_only_in      IN            VARCHAR2,
      session_code_in           IN            VARCHAR2,
      hei_inst_code_in          IN            VARCHAR2,
      max_search_results_in     IN            VARCHAR2,
      io_cursor                 IN OUT        TERM_DATES_CURSOR,
      error_boolean                OUT NOCOPY VARCHAR2,
      ERROR_TEXT                   OUT NOCOPY VARCHAR2)  
  IS
      coursechanges_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN coursechanges_cursor FOR
          SELECT CC.COURSE_CHANGE_ID,
                 CC.HEI_INST_CODE,
                 CC.NEW_INST_CODE,
                 NVL (CASE
                         WHEN I.INST_NAME IS NULL AND CC.OLD_INST_CODE IS NOT NULL
                         THEN
                            (SELECT I1.INST_NAME
                               FROM INST I1
                              WHERE I1.INST_CODE = CC.OLD_INST_CODE)
                         ELSE
                            I.INST_NAME
                      END,
                      (SELECT H.HEI_INST_NAME INST_NAME
                         FROM HEI_INST@GRASS H
                        WHERE H.HEI_INST_CODE = CC.HEI_INST_CODE))
                    INST_NAME,
                 CC.NEW_CAMPUS,
                 CC.NEW_HEI_CRSE_CODE,
                 CC.NEW_CRSE_CODE,
                 CC.NEW_HEI_CRSE_NAME,
                 CC.NEW_DURATION,
                 CC.OLD_INST_CODE,
                 CC.OLD_CAMPUS,
                 CC.OLD_HEI_CRSE_CODE,
                 CC.OLD_CRSE_CODE,
                 CC.OLD_HEI_CRSE_NAME,
                 CC.OLD_DURATION,
                 CC.CHANGE_TYPE,
                 to_char(CC.CREATED_DATE,'DD/MM/YYYY') CREATED_DATE,
                 PK_GENERAL_LOCKING.get_employee_name(CC.CREATED_BY) CREATED_BY,
                 CC.STATUS,
                 PK_GENERAL_LOCKING.get_employee_name(CC.STATUS_BY) STATUS_BY,
                 CC.SESSION_CODE
            FROM SLCADMIN.COURSE_CHANGE CC, INST I
           WHERE    CC.NEW_INST_CODE = I.INST_CODE(+)
                 AND CC.HEI_INST_CODE = NVL (HEI_INST_CODE_IN, CC.HEI_INST_CODE)
                 AND CC.STATUS IN (NVL (STATUS_NEW_IN, 'x'),
                                   NVL (STATUS_AUTHORISED_IN, 'x'),
                                   NVL (STATUS_REJECTED_IN, 'x'))
                 AND CC.CHANGE_TYPE IN (NVL (CHANGE_TYPE_INSERTED_IN, 'x'),
                                        NVL (CHANGE_TYPE_DELETED_IN, 'x'),
                                        NVL (CHANGE_TYPE_UPDATED_IN, 'x'))
                 AND CC.SESSION_CODE = SESSION_CODE_IN
                 AND (   (    CHANGE_LATEST_ONLY_IN = 'TRUE'
                          AND CC.CREATED_DATE = (SELECT MAX (CREATED_DATE)
                                                   FROM SLCADMIN.COURSE_CHANGE CC1
                                                  WHERE CC1.CREATED_BY = 'SLCADMIN'))
                      OR (CHANGE_ALL_IN = 'TRUE')
                    OR (CHANGE_ALL_BATCH_IN = 'TRUE' AND CC.CREATED_BY = 'SLCADMIN')
                      OR (CHANGE_STEPS_ONLY_IN = 'TRUE' AND CC.CREATED_BY <> 'SLCADMIN'))
                 AND ROWNUM < TO_NUMBER(MAX_SEARCH_RESULTS_IN) + 1
        ORDER BY 4,CC.CHANGE_TYPE, CC.NEW_HEI_CRSE_CODE, CC.OLD_HEI_CRSE_CODE;


      io_cursor := coursechanges_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCourseChanges;    
   
   PROCEDURE gettermchanges (
      status_new_in             IN            VARCHAR2,
      status_authorised_in      IN            VARCHAR2,
      status_rejected_in        IN            VARCHAR2,
      change_type_inserted_in   IN            VARCHAR2,
      change_type_deleted_in    IN            VARCHAR2,
      change_type_updated_in    IN            VARCHAR2,
      change_latest_only_in     IN            VARCHAR2,
      change_all_in             IN            VARCHAR2,
      change_all_batch_in       IN            VARCHAR2,
      change_steps_only_in      IN            VARCHAR2,
      session_code_in           IN            VARCHAR2,
      hei_inst_code_in          IN            VARCHAR2,
      max_search_results_in     IN            VARCHAR2,
      io_cursor                 IN OUT        TERM_DATES_CURSOR,
      error_boolean                OUT NOCOPY VARCHAR2,
      ERROR_TEXT                   OUT NOCOPY VARCHAR2)  
  IS
      termchanges_cursor   TERM_DATES_CURSOR;
      V_SQL1 VARCHAR2(1000);
      V_SQL_HINT VARCHAR2(100);
      V_SQL2 VARCHAR2(3500);
      V_SQL_STATUS VARCHAR2(1000);
      V_SQL_CHANGE_TYPE VARCHAR2(1000);
      V_SQL_CHANGE VARCHAR2(1000);
      V_SQL3 VARCHAR2(2000);
      V_SQL_ORDER VARCHAR2(1000);
      V_SQL VARCHAR2(8000);
      
   BEGIN
     V_SQL1 := ' ';
     V_SQL_HINT := ' ';
    
     V_SQL2 := '   SELECT  Y.HEI_INST_CODE,
         NVL(C2.INST_CODE,Y.INST_CODE) INST_CODE,
         NVL(C2.INST_NAME,Y.INST_NAME) INST_NAME,
         Y.HEI_CRSE_CODE,
         NVL(C2.CRSE_NAME,Y.CRSE_NAME) CRSE_NAME,
         Y.ACADEMIC_YEAR,
         Y.TERM,
         Y.NEW_TERM_START,
         Y.NEW_TERM_END,
         Y.NEW_FEES,
         Y.OLD_TERM_START,
         Y.OLD_TERM_END,
         Y.OLD_FEES,
         Y.CHANGE_TYPE,
         Y.CREATED_DATE,
         PK_GENERAL_LOCKING.get_employee_name(Y.CREATED_BY) CREATED_BY,
         Y.STATUS,
         PK_GENERAL_LOCKING.get_employee_name(Y.STATUS_BY) STATUS_BY,
         Y.SESSION_CODE,
         Y.TERM_CHANGE_ID,
         ROWNUM,
         Y.CRSE_ID
    FROM (SELECT DISTINCT
                 X.HEI_INST_CODE,
                 FIRST_VALUE (I.INST_CODE)
                    IGNORE NULLS
                    OVER (PARTITION BY I.HEI_INST_CODE ORDER BY I.INST_NAME)
                    INST_CODE,
                 FIRST_VALUE (I.INST_NAME)
                    IGNORE NULLS
                    OVER (PARTITION BY I.HEI_INST_CODE ORDER BY I.INST_NAME)
                    INST_NAME,
                 X.HEI_CRSE_CODE,
                 (SELECT FIRST_VALUE (C.CRSE_NAME)
                            IGNORE NULLS
                            OVER (ORDER BY C.CRSE_NAME)
                            CRSE_NAME
                    FROM CRSE C
                   WHERE CY.CRSE_ID = C.CRSE_ID)
                    CRSE_NAME,
                 X.ACADEMIC_YEAR,
                 X.TERM,
                 X.NEW_TERM_START,
                 X.NEW_TERM_END,
                 X.NEW_FEES,
                 X.OLD_TERM_START,
                 X.OLD_TERM_END,
                 X.OLD_FEES,
                 X.CHANGE_TYPE,
                 X.CREATED_DATE,
                 X.CREATED_BY,
                 X.STATUS,
                 X.STATUS_BY,
                 X.SESSION_CODE,
                 X.TERM_CHANGE_ID,
                 X.CRSE_ID
            FROM (SELECT  DISTINCT
                         TC.HEI_INST_CODE,
                         NULL INST_CODE,
                         NULL INST_NAME,
                         TC.HEI_CRSE_CODE,
                         NULL CRSE_NAME,
                         TC.ACADEMIC_YEAR,
                         TC.TERM,
                         TO_CHAR (TC.NEW_TERM_START,'''||'DD/MM/YYYY'''||') NEW_TERM_START,
                      TO_CHAR(TC.NEW_TERM_END, '''||'DD/MM/YYYY'''||') NEW_TERM_END,
                      TC.NEW_FEES,
                      TO_CHAR(TC.OLD_TERM_START, '''||'DD/MM/YYYY'''||') OLD_TERM_START,
                      TO_CHAR(TC.OLD_TERM_END, '''||'DD/MM/YYYY'''||') OLD_TERM_END,
                      TC.OLD_FEES,
                      TC.CHANGE_TYPE,
                      TO_CHAR(TC.CREATED_DATE, '''||'DD/MM/YYYY'''||') CREATED_DATE,
                         TC.CREATED_BY,
                         TC.STATUS,
                         TC.STATUS_BY,
                         TC.SESSION_CODE,
                         TC.TERM_CHANGE_ID,
                         TC.CRSE_ID
                    FROM SLCADMIN.TERM_CHANGE TC
                   WHERE     1 = 1 ';
      IF  HEI_INST_CODE_IN IS NOT NULL
       THEN
            V_SQL2 := V_SQL2 || ' AND  TC.HEI_INST_CODE = '''||HEI_INST_CODE_IN||''' ';
      ELSE
       V_SQL2 := V_SQL2 || ' AND ROWNUM < TO_NUMBER('||MAX_SEARCH_RESULTS_IN||') + 1 ';      
      END IF;
      IF SESSION_CODE_IN <> 'Show All'
      THEN
       V_SQL2 := V_SQL2 || ' AND  TC.SESSION_CODE = '''||SESSION_CODE_IN||''' '; 
      END IF; 
      V_SQL_STATUS := ' AND TC.STATUS IN ( ';
      IF status_new_in = 'NEW'
      THEN
        V_SQL_STATUS := V_SQL_STATUS || ' '''||'NEW'''||' ';
      END IF;
      IF status_authorised_in = 'AUTHORISED'
      THEN
         IF status_new_in = 'NEW'
          THEN
            V_SQL_STATUS := V_SQL_STATUS || ' , '''||'AUTHORISED'''||' ';
          ELSE 
            V_SQL_STATUS := V_SQL_STATUS || ' '''||'AUTHORISED'''||' ';
          END IF;
      END IF;
      
      IF status_rejected_in = 'REJECTED'
      THEN
         IF status_new_in = 'NEW' OR status_authorised_in = 'AUTHORISED'
          THEN
            V_SQL_STATUS := V_SQL_STATUS || ' , '''||'REJECTED'''||' ';
          ELSE 
            V_SQL_STATUS := V_SQL_STATUS || ' '''||'REJECTED'''||' ';
          END IF;
      END IF;      
      V_SQL_STATUS := V_SQL_STATUS ||' ) ';
      
                   
      V_SQL_CHANGE_TYPE := ' AND TC.CHANGE_TYPE||'''||''' IN ('||'''X'||''', ';
      IF CHANGE_TYPE_INSERTED_IN = 'I'
      THEN
        V_SQL_CHANGE_TYPE := V_SQL_CHANGE_TYPE || ' '''||'I'''||' ';
      END IF;
      IF CHANGE_TYPE_DELETED_IN = 'D'
      THEN
         IF CHANGE_TYPE_INSERTED_IN = 'I'
          THEN
            V_SQL_CHANGE_TYPE := V_SQL_CHANGE_TYPE || ' , '''||'D'''||' ';
          ELSE 
            V_SQL_CHANGE_TYPE := V_SQL_CHANGE_TYPE || ' '''||'D'''||' ';
          END IF;
      END IF;
      
      IF CHANGE_TYPE_UPDATED_IN = 'U'
      THEN
         IF CHANGE_TYPE_INSERTED_IN = 'I' OR CHANGE_TYPE_DELETED_IN = 'D'
          THEN
            V_SQL_CHANGE_TYPE := V_SQL_CHANGE_TYPE || ' , '''||'U'''||' ';
          ELSE 
            V_SQL_CHANGE_TYPE := V_SQL_CHANGE_TYPE || ' '''||'U'''||' ';
          END IF;
      END IF;      
      V_SQL_CHANGE_TYPE := V_SQL_CHANGE_TYPE ||' ) ';      
      
      
      
      
      IF CHANGE_LATEST_ONLY_IN = 'TRUE'
      THEN
          V_SQL_CHANGE := ' AND TC.CREATED_DATE = (SELECT MAX (TC1.CREATED_DATE)
                                                           FROM SLCADMIN.TERM_CHANGE TC1
                                                          WHERE TC1.CREATED_BY = '''||'SLCADMIN'''||') ';
      END IF;
      IF CHANGE_ALL_BATCH_IN = 'TRUE' 
      THEN
          V_SQL_CHANGE := ' AND TC.CREATED_BY = '''||'SLCADMIN'''||' ';
      END IF;
      IF CHANGE_STEPS_ONLY_IN = 'TRUE' 
      THEN
          V_SQL_CHANGE := ' AND TC.CREATED_BY  IN (SELECT TC3.CREATED_BY FROM  SLCADMIN.TERM_CHANGE TC3 WHERE  TC3.CREATED_BY > '''||'SLCADMIN'||''' 
                                                 UNION ALL 
                                                 SELECT TC4.CREATED_BY FROM  SLCADMIN.TERM_CHANGE TC4 WHERE  TC4.CREATED_BY < '''||'SLCADMIN'||''' ) ';
      END IF;
      
      V_SQL3 :=  ' )
                 X,
                 INST I,
                 CRSE_YEAR CY
           WHERE     X.HEI_INST_CODE = I.HEI_INST_CODE(+)
                 AND X.HEI_CRSE_CODE = CY.HEI_CRSE_CODE(+)) Y,
                 CRSE C2
            WHERE Y.CRSE_ID = C2.CRSE_ID(+)
            AND ROWNUM < TO_NUMBER('||MAX_SEARCH_RESULTS_IN||') + 1 ';

          V_SQL_ORDER := 'ORDER BY 1 NULLS FIRST,  2,  3, 4,5,6,7,14 ';
          V_SQL :=    V_SQL1 ||V_SQL_HINT || V_SQL2 || V_SQL_STATUS || V_SQL_CHANGE_TYPE || V_SQL_CHANGE || V_SQL3 ||V_SQL_ORDER;    
          DBMS_OUTPUT.PUT_LINE(V_SQL);
          OPEN termchanges_cursor FOR V_SQL;

--        OPEN termchanges_cursor FOR
--              SELECT /*+ parallel(TC, 8) */
--             DISTINCT CR.HEI_INST_CODE,
--                      CR.INST_CODE,
--                      CR.INST_NAME,
--                      TC.HEI_CRSE_CODE,
--                      CR.CRSE_NAME,
--                      TC.ACADEMIC_YEAR,
--                      TC.TERM,
--                      TO_CHAR(TC.NEW_TERM_START, 'DD/MM/YYYY') NEW_TERM_START,
--                      TO_CHAR(TC.NEW_TERM_END, 'DD/MM/YYYY') NEW_TERM_END,
--                      TC.NEW_FEES,
--                      TO_CHAR(TC.OLD_TERM_START, 'DD/MM/YYYY') OLD_TERM_START,
--                      TO_CHAR(TC.OLD_TERM_END, 'DD/MM/YYYY') OLD_TERM_END,
--                      TC.OLD_FEES,
--                      TC.CHANGE_TYPE,
--                      TO_CHAR(TC.CREATED_DATE, 'DD/MM/YYYY') CREATED_DATE,
--                      TC.CREATED_BY,
--                      TC.STATUS,
--                      TC.STATUS_BY,
--                      TC.SESSION_CODE,
--                      TC.TERM_CHANGE_ID                      
--        FROM SLCADMIN.TERM_CHANGE TC,
--             (SELECT DISTINCT
--                     NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) HEI_CRSE_CODE,
--                     I.HEI_INST_CODE,
--                     C.INST_CODE,
--                     C.INST_NAME,
--                     C.CRSE_NAME
--                FROM CRSE C, CRSE_YEAR CY, INST I
--               WHERE C.CRSE_ID = CY.CRSE_ID AND C.INST_CODE = I.INST_CODE) CR
--       WHERE TC.HEI_CRSE_CODE = CR.HEI_CRSE_CODE(+)
--
--               AND    CR.HEI_INST_CODE = NVL (HEI_INST_CODE_IN, CR.HEI_INST_CODE)
--                     AND TC.STATUS IN (NVL (STATUS_NEW_IN, 'x'),
--                                       NVL (STATUS_AUTHORISED_IN, 'x'),
--                                       NVL (STATUS_REJECTED_IN, 'x'))
--                     AND TC.CHANGE_TYPE IN (NVL (CHANGE_TYPE_INSERTED_IN, 'x'),
--                                            NVL (CHANGE_TYPE_DELETED_IN, 'x'),
--                                            NVL (CHANGE_TYPE_UPDATED_IN, 'x'))
--                     AND TC.SESSION_CODE = SESSION_CODE_IN
--                     AND (   (    CHANGE_LATEST_ONLY_IN = 'TRUE'
--                              AND TC.CREATED_DATE = (SELECT MAX (TC1.CREATED_DATE)
--                                                       FROM SLCADMIN.TERM_CHANGE TC1
--                                                      WHERE TC1.CREATED_BY = 'SLCADMIN'))
--                          OR (CHANGE_ALL_IN = 'TRUE')
--                          OR (CHANGE_ALL_BATCH_IN = 'TRUE' AND TC.CREATED_BY = 'SLCADMIN')
--                          OR (CHANGE_STEPS_ONLY_IN = 'TRUE' AND TC.CREATED_BY <> 'SLCADMIN'))
--                     AND ROWNUM < TO_NUMBER(MAX_SEARCH_RESULTS_IN) + 1
--            ORDER BY 1 NULLS FIRST,
--             2,
--             3,
--             4,5,6,7,14;
--       END IF;    
             
    
      io_cursor := termchanges_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getTermChanges;    
      
       FUNCTION getStudentList (instCode_in IN VARCHAR2, sessionCode_in IN VARCHAR2)
       RETURN VARCHAR2
       IS
        CURSOR C_STUDENTS IS
        SELECT DBMS_LOB.SUBSTR (
          RTRIM (
             XMLAGG (XMLELEMENT (E, X.STUDENTS || CHR (10))).EXTRACT (
                '//text()').GETCLOBVAL(),
             ','),
          4000,
          1)
          STUDENTS
          FROM (  SELECT    'Year '
                         || SCY.CRSE_YEAR_NO
                         || ' - '
                         || RTRIM (
                               XMLAGG (XMLELEMENT (E, SCY.STUD_REF_NO || ',')).EXTRACT (
                                  '//text()').GETCLOBVAL(),
                               ',')
                            STUDENTS
                    FROM STUD_CRSE_YEAR SCY, CRSE_YEAR CY
                   WHERE SCY.INST_CODE = UPPER (instCode_in) 
                             AND SCY.SESSION_CODE = sessionCode_in 
                             AND SCY.CRSE_YEAR_ID = CY.CRSE_YEAR_ID
                             AND CY.DEFAULT_TERMS = 'Y'
                GROUP BY SCY.CRSE_YEAR_NO) X;
       V_STUDENT_LIST VARCHAR2(8000);
       
       BEGIN
        OPEN C_STUDENTS;
        FETCH C_STUDENTS INTO V_STUDENT_LIST;
        CLOSE C_STUDENTS;
        RETURN V_STUDENT_LIST;
       END getStudentList;

   PROCEDURE getInstTermChanges (
      status_new_in             IN            VARCHAR2,
      status_authorised_in      IN            VARCHAR2,
      status_rejected_in        IN            VARCHAR2,
      change_type_inserted_in   IN            VARCHAR2,
      change_type_deleted_in    IN            VARCHAR2,
      change_type_updated_in    IN            VARCHAR2,
      change_latest_only_in     IN            VARCHAR2,
      change_all_in             IN            VARCHAR2,
      change_all_batch_in       IN            VARCHAR2,
      change_steps_only_in      IN            VARCHAR2,
      session_code_in           IN            VARCHAR2,
      hei_inst_code_in          IN            VARCHAR2,
      inst_code_in              IN            VARCHAR2,
      max_search_results_in     IN            VARCHAR2,
      io_cursor                 IN OUT        TERM_DATES_CURSOR,
      error_boolean                OUT NOCOPY VARCHAR2,
      ERROR_TEXT                   OUT NOCOPY VARCHAR2)
   IS
      insttermchanges_cursor   TERM_DATES_CURSOR;
   BEGIN
        IF NVL(change_steps_only_in,'x') = 'TRUE' OR NVL(change_all_in,'X') = 'TRUE'
        THEN 
         OPEN insttermchanges_cursor FOR
             /* Formatted on 11/03/2019 13:39:34 (QP5 v5.256.13226.35538) */
              SELECT ITC.HEI_INST_CODE,
                     I.INST_NAME,
                     ITC.INST_CODE,
                     ITC.SESSION_CODE,
                     ITC.TERM_NO,
                     TO_CHAR (ITC.NEW_START_DATE, 'dd/mm/yyyy') NEW_START_DATE,
                     TO_CHAR (ITC.NEW_END_DATE, 'dd/mm/yyyy') NEW_END_DATE,
                     ITC.NEW_DAYS,
                     TO_CHAR (ITC.OLD_START_DATE, 'dd/mm/yyyy') OLD_START_DATE,
                     TO_CHAR (ITC.OLD_END_DATE, 'dd/mm/yyyy') OLD_END_DATE,
                     ITC.OLD_DAYS,
                     PK_GENERAL_LOCKING.get_employee_name(ITC.CREATED_BY) CREATED_BY,
                     TO_CHAR (ITC.CREATED_DATE, 'dd/mm/yyyy') CREATED_DATE,
                     ITC.STATUS,
                     PK_GENERAL_LOCKING.get_employee_name(ITC.STATUS_BY) STATUS_BY,
                     ITC.INST_TERM_CHANGE_ID,
                     (SELECT COUNT (DISTINCT (SCY.STUD_REF_NO)) STUDENTS
                        FROM STUD_CRSE_YEAR SCY, CRSE_YEAR CY
                       WHERE     SCY.INST_CODE = UPPER (ITC.INST_CODE )
                             AND SCY.SESSION_CODE = ITC.SESSION_CODE 
                             AND SCY.CRSE_YEAR_ID = CY.CRSE_YEAR_ID
                             AND CY.DEFAULT_TERMS = 'Y')
                        STUDENTS,
                        PK_STEPS_UI_AUTH_TERM_DATES.getStudentList(ITC.INST_CODE,ITC.SESSION_CODE)  STUDENT_LIST,
                     ITC.CHANGE_TYPE
                FROM SLCADMIN.INST_TERM_CHANGE itc, INST I
               WHERE     ITC.INST_CODE = I.INST_CODE
                     AND ITC.INST_CODE = NVL (inst_code_in, ITC.INST_CODE)
                     AND ITC.status IN (NVL (status_new_in, 'x'),
                                        NVL (status_authorised_in, 'x'),
                                        NVL (status_rejected_in, 'x'))
                     AND ITC.CHANGE_TYPE IN (NVL (change_type_inserted_in, 'x'),
                                             NVL (change_type_deleted_in, 'x'),
                                             NVL (change_type_updated_in, 'x'))
                     AND ITC.SESSION_CODE = CASE WHEN session_code_in <> 'Show All' THEN TO_NUMBER(session_code_in) ELSE ITC.SESSION_CODE END 
                     AND ROWNUM < TO_NUMBER (max_search_results_in) + 1
            ORDER BY 1,
                     2,
                     3,
                     5,
                     6;
        ELSE
            OPEN insttermchanges_cursor FOR
             /* Formatted on 11/03/2019 13:39:34 (QP5 v5.256.13226.35538) */
                  SELECT ITC.HEI_INST_CODE,
                         ITC.INST_CODE,
                         ITC.SESSION_CODE,
                         ITC.TERM_NO,
                         TO_CHAR (ITC.NEW_START_DATE,'dd/mm/yyyy') NEW_START_DATE,
                         TO_CHAR (ITC.NEW_END_DATE,'dd/mm/yyyy') NEW_END_DATE,
                         ITC.NEW_DAYS,
                         TO_CHAR (ITC.OLD_START_DATE,'dd/mm/yyyy') OLD_START_DATE,
                         TO_CHAR (ITC.OLD_END_DATE,'dd/mm/yyyy') OLD_END_DATE,
                         ITC.OLD_DAYS,
                         PK_GENERAL_LOCKING.get_employee_name(ITC.CREATED_BY) CREATED_BY,
                         TO_CHAR (ITC.CREATED_DATE,'dd/mm/yyyy') CREATED_DATE,
                         ITC.STATUS,
                         PK_GENERAL_LOCKING.get_employee_name(ITC.STATUS_BY) STATUS_BY,
                         ITC.INST_TERM_CHANGE_ID,
                         NULL STUDENTS
                    FROM SLCADMIN.INST_TERM_CHANGE itc
                    WHERE 1 = 2;
        END IF;

      io_cursor := insttermchanges_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getInstTermChanges;
   
   
     PROCEDURE getCourseList (hei_crse_code_in   IN            VARCHAR2,
                            session_code_in    IN            VARCHAR2,
                            io_cursor       IN OUT        TERM_DATES_CURSOR,
                            error_boolean      OUT NOCOPY VARCHAR2,
                            ERROR_TEXT         OUT NOCOPY VARCHAR2)
   IS
      courseList_cursor   TERM_DATES_CURSOR;
   BEGIN
      OPEN courseList_cursor FOR
/* Formatted on 07/01/2019 10:41:23 (QP5 v5.256.13226.35538) */
          SELECT X.CRSE_CODE,
                 X.CRSE_NAME,
                 X.CRSE_ID,
                 X.INST_CODE,
                 X.INST_NAME,
                 X.SESSION_CODE,
                 X.HEI_CRSE_CODE,
                 COUNT(0) OVER () TOTAL_COURSES
            FROM (SELECT C.CRSE_CODE,
                         C.CRSE_NAME,
                         C.CRSE_ID,
                         C.INST_CODE,
                         C.INST_NAME,
                         CS.SESSION_CODE,
                         CY.HEI_CRSE_CODE
                    FROM CRSE C, CRSE_SESSION CS, CRSE_YEAR CY
                   WHERE     CS.SESSION_CODE = session_code_in
                         AND CY.HEI_CRSE_CODE = hei_crse_code_in
                         AND CY.CRSE_SESSION_ID = CS.CRSE_SESSION_ID
                         AND CS.CRSE_ID = C.CRSE_ID
                  UNION 
                  SELECT C.CRSE_CODE,
                         C.CRSE_NAME,
                         C.CRSE_ID,
                         C.INST_CODE,
                         C.INST_NAME,
                         CS.SESSION_CODE,
                         C.HEI_CRSE_CODE
                    FROM CRSE C, CRSE_SESSION CS, CRSE_YEAR CY
                   WHERE     CS.SESSION_CODE = session_code_in
                         AND C.HEI_CRSE_CODE = hei_crse_code_in
                         AND NULL = CY.HEI_CRSE_CODE(+)
                         AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID(+)
                         AND NOT EXISTS
                                    (SELECT 1
                                       FROM CRSE_YEAR CY1
                                      WHERE     CY1.CRSE_SESSION_ID =
                                                   CS.CRSE_SESSION_ID
                                            AND CY1.HEI_CRSE_CODE = C.HEI_CRSE_CODE)
                         AND CS.CRSE_ID = C.CRSE_ID    ) X
        ORDER BY 4, 5, 1;

      io_cursor := courseList_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCourseList;
   
    /* Formatted on 05/02/2019 11:42:30 (QP5 v5.256.13226.35538) */
    PROCEDURE getCourseDetails (
       crse_id_in          IN            VARCHAR2,
       sessionCode_in      IN            VARCHAR2,
       courseChangeId_in   IN            VARCHAR2,
       termChangeId_in     IN            VARCHAR2,
       io_cursor           IN OUT        TERM_DATES_CURSOR,
       error_boolean          OUT NOCOPY VARCHAR2,
       ERROR_TEXT             OUT NOCOPY VARCHAR2)
    IS
       courseDetails_cursor   TERM_DATES_CURSOR;
       V_COURSE_CHANGE_ID VARCHAR2(10);
       CURSOR C_COURSE_CHANGE
       IS
       SELECT MAX (CC.COURSE_CHANGE_ID) COURSE_CHANGE_ID           
              FROM SLCADMIN.COURSE_CHANGE CC, SLCADMIN.TERM_CHANGE TC
             WHERE     TC.TERM_CHANGE_ID = termChangeId_in
                   AND TC.HEI_CRSE_CODE = CC.NEW_HEI_CRSE_CODE
                   AND TC.HEI_INST_CODE = CC.HEI_INST_CODE
                   AND TC.SESSION_CODE = CC.SESSION_CODE
                   AND CC.STATUS = 'NEW';
    BEGIN
       error_boolean := 'false';
       ERROR_TEXT := 'none';
       IF (NVL(courseChangeId_in,0) < 1 AND NVL(termChangeId_in,0) > 0)
       THEN
           OPEN C_COURSE_CHANGE;
           FETCH C_COURSE_CHANGE INTO V_COURSE_CHANGE_ID;
           CLOSE C_COURSE_CHANGE;
       ELSE 
        V_COURSE_CHANGE_ID := courseChangeId_in;
       END IF;
       
       IF crse_id_in > 0
       THEN
          OPEN courseDetails_cursor FOR
             SELECT C.INST_CODE,
                    C.INST_NAME,
                    C.CRSE_CODE,
                    C.CRSE_NAME,
                    (SELECT MIN(CASE
                              WHEN NVL (CC.NEW_HEI_CRSE_NAME, 'X') <>
                                      NVL (CC.OLD_HEI_CRSE_NAME, 'Y')
                              THEN
                                CUC.HEI_CRSE_NAME
                              ELSE
                                 NULL
                           END)
                              SLC_COURSE_NAME
                      FROM SLCADMIN.COURSE_CHANGE CC, SLCADMIN.CURRENT_COURSE CUC
                     WHERE     CC.COURSE_CHANGE_ID = V_COURSE_CHANGE_ID
                           AND CC.CHANGE_TYPE = 'U'
                           AND CC.NEW_HEI_CRSE_CODE = CUC.HEI_CRSE_CODE
                           AND CC.HEI_INST_CODE = CUC.HEI_INST_CODE
                           AND CC.SESSION_CODE = CUC.SESSION_CODE) SLC_COURSE_NAME,
                    C.HEI_CRSE_CODE,
                    C.SCHEME_TYPE,
                    C.SUBJECT_CAT_ID,
                    (SELECT CATEGORY.DESCRIPT
                       FROM CATEGORY
                      WHERE CATEGORY.ID = C.SUBJECT_CAT_ID)
                       AS SUBJECT_DESCRIPTION,
                    C.QUAL_TYPE,
                    C.FEES_CAMPUS,
                    (SELECT NAME
                       FROM CAMPUS
                      WHERE CAMPUS_ID = C.FEES_CAMPUS)
                       AS FEES_CAMPUS_NAME,
                    C.MAINT_CAMPUS,
                    (SELECT NAME
                       FROM CAMPUS
                      WHERE CAMPUS_ID = C.MAINT_CAMPUS)
                       AS MAINT_CAMPUS_NAME,
                    C.PAMS_COURSE,
                    C.GRADUATE_APPRENTICE,
                    C.APPROVED,         
                    NVL((SELECT CASE
                              WHEN NVL (CC.NEW_DURATION  , -1) <>
                                      NVL (CC.OLD_DURATION, -2)
                              THEN
                                 CUC.DURATION
                              ELSE
                                 CS.MAX_DURATION
                           END
                              MAX_DURATION
                      FROM SLCADMIN.COURSE_CHANGE CC, SLCADMIN.CURRENT_COURSE CUC
                     WHERE     CC.COURSE_CHANGE_ID = V_COURSE_CHANGE_ID
                           AND CC.CHANGE_TYPE in ('I', 'U')
                           AND CC.NEW_HEI_CRSE_CODE = CUC.HEI_CRSE_CODE
                           AND CC.HEI_INST_CODE = CUC.HEI_INST_CODE
                           AND CC.SESSION_CODE = CUC.SESSION_CODE),CS.MAX_DURATION) MAX_DURATION,                                        
                    (SELECT CS.MAX_DURATION
                      FROM SLCADMIN.COURSE_CHANGE CC, SLCADMIN.CURRENT_COURSE CUC
                     WHERE     CC.COURSE_CHANGE_ID = V_COURSE_CHANGE_ID
                           AND CC.CHANGE_TYPE = 'U'
                           AND CC.NEW_HEI_CRSE_CODE = CUC.HEI_CRSE_CODE
                           AND CC.HEI_INST_CODE = CUC.HEI_INST_CODE
                           AND CC.SESSION_CODE = CUC.SESSION_CODE) OLD_MAX_DURATION,                            
                    sessionCode_in SESSION_CODE,
                    CS.CRSE_SESSION_ID,
                    (SELECT SUBSTR(RTRIM (
                              XMLAGG (XMLELEMENT (E, X.STUDENTS || CHR (10))).EXTRACT (
                                 '//text()'),
                              ','),1,4000)
                              STUDENTS
                      FROM (  SELECT    'Year '
                                     || SCY.CRSE_YEAR_NO
                                     || ' - '
                                     || RTRIM (
                                           XMLAGG (XMLELEMENT (E, SCY.STUD_REF_NO || ',')).EXTRACT (
                                              '//text()'),
                                           ',')
                                        STUDENTS
                                FROM STUD_CRSE_YEAR SCY
                               WHERE SCY.CRSE_ID = crse_id_in AND SCY.SESSION_CODE = sessionCode_in
                            GROUP BY SCY.CRSE_YEAR_NO) X ) STUDENT_LIST,
                   (SELECT CASE
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
                      FROM INST I
                     WHERE I.INST_CODE = C.INST_CODE ) RUK,
                   C.CRSE_ID
               FROM CRSE C, CRSE_SESSION CS
              WHERE     C.CRSE_ID = crse_id_in
                    AND C.CRSE_ID = CS.CRSE_ID(+)
                    AND sessionCode_in = CS.SESSION_CODE(+);
       ELSIF courseChangeId_in > 0
       THEN
          OPEN courseDetails_cursor FOR
             SELECT X.INST_CODE,
                    X.INST_NAME,
                    NVL( X.CRSE_CODE,PK_STEPS_UI_TERM_DATES_UTIL.next_course_code(X.INST_CODE)) CRSE_CODE,
                    X.CRSE_NAME,
                    X.SLC_COURSE_NAME,
                    X.HEI_CRSE_CODE,
                    X.SCHEME_TYPE,
                    X.SUBJECT_CAT_ID,
                    X.SUBJECT_DESCRIPTION,
                    X.QUAL_TYPE,
                    (SELECT MIN (C.CAMPUS_ID)
                       FROM CAMPUS C
                      WHERE     X.INST_CODE = C.INST_CODE(+)
                            AND '-' = C.CAMPUS_CODE(+))
                       FEES_CAMPUS,
                    (SELECT MIN (C.NAME)
                       FROM CAMPUS C
                      WHERE     X.INST_CODE = C.INST_CODE(+)
                            AND '-' = C.CAMPUS_CODE(+))
                       FEES_CAMPUS_NAME,
                    (SELECT MIN (C.CAMPUS_ID)
                       FROM CAMPUS C
                      WHERE     X.INST_CODE = C.INST_CODE(+)
                            AND '-' = C.CAMPUS_CODE(+))
                       MAINT_CAMPUS,
                    (SELECT MIN (C.NAME)
                       FROM CAMPUS C
                      WHERE     X.INST_CODE = C.INST_CODE(+)
                            AND '-' = C.CAMPUS_CODE(+))
                       MAINT_CAMPUS_NAME,
                    X.PAMS_COURSE,
                    X.GRADUATE_APPRENTICE,
                    X.APPROVED,
                    X.MAX_DURATION,
                    NULL OLD_MAX_DURATION,  
                    X.SESSION_CODE,
                    X.CRSE_SESSION_ID,
                    NULL STUDENT_LIST,
                    X.RUK,
                    NULL CRSE_ID
               FROM (SELECT NVL (
                               CASE
                                  WHEN     I.INST_CODE IS NULL
                                       AND I2.INST_CODE IS NOT NULL
                                  THEN
                                     CC.OLD_INST_CODE
                                  ELSE
                                     I.INST_CODE
                               END,
                               (SELECT DISTINCT
                                       FIRST_VALUE (
                                          I2.INST_CODE)
                                       IGNORE NULLS
                                       OVER (PARTITION BY I2.HEI_INST_CODE
                                             ORDER BY I2.INST_NAME)
                                          AS INST_CODE
                                  FROM INST I2
                                 WHERE I2.HEI_INST_CODE = CC.HEI_INST_CODE))
                               INST_CODE,
                            NVL (
                               CASE
                                  WHEN     I.INST_NAME IS NULL
                                       AND I2.INST_CODE IS NOT NULL
                                  THEN
                                     I2.INST_NAME
                                  ELSE
                                     I.INST_NAME
                               END,
                               (SELECT H.HEI_INST_NAME INST_NAME
                                  FROM HEI_INST@GRASS H
                                 WHERE H.HEI_INST_CODE = CC.HEI_INST_CODE))
                               INST_NAME,
                            NULL CRSE_CODE,
                            NULL CRSE_NAME,
                            CC.NEW_HEI_CRSE_NAME SLC_COURSE_NAME,
                            NVL (CC.NEW_HEI_CRSE_CODE, CC.OLD_HEI_CRSE_CODE)
                               HEI_CRSE_CODE,
                            NULL SCHEME_TYPE,
                            NULL SUBJECT_CAT_ID,
                            NULL SUBJECT_DESCRIPTION,
                            NULL QUAL_TYPE,
                            NULL FEES_CAMPUS,
                            NULL FEES_CAMPUS_NAME,
                            NULL MAINT_CAMPUS,
                            NULL MAINT_CAMPUS_NAME,
                            NULL PAMS_COURSE,
                            NULL GRADUATE_APPRENTICE,
                            NULL APPROVED,
                            CC.NEW_DURATION MAX_DURATION,
                            CC.SESSION_CODE,
                            NULL CRSE_SESSION_ID, 
                            
                            NVL(CASE
                                  WHEN     I.INST_NAME IS NULL
                                       AND CC.OLD_INST_CODE IS NOT NULL
                                  THEN
                                     (SELECT  CASE
                                      WHEN I1.LOCATION_IND IN (2,
                                                              3,
                                                              4,
                                                              5)
                                      THEN
                                         'Y'
                                      ELSE
                                         'N'
                                      END
                                       FROM INST I1
                                       WHERE I1.INST_CODE = CC.OLD_INST_CODE)
                                  ELSE
                                     CASE
                                      WHEN NVL(I.LOCATION_IND,0) < 1
                                      THEN NULL
                                      WHEN I.LOCATION_IND IN (2,
                                                              3,
                                                              4,
                                                              5)
                                      THEN
                                         'Y'
                                      ELSE
                                         'N'
                                   END
                               END, (SELECT CASE
                                       WHEN MAX(I2.LOCATION_IND) IN (2,
                                                               3,
                                                               4,
                                                               5)
                                       THEN
                                          'Y'
                                       ELSE
                                          'N'
                                    END
                               FROM INST I2
                              WHERE I2.HEI_INST_CODE = CC.HEI_INST_CODE
                              AND   I2.INST_CODE = (SELECT DISTINCT FIRST_VALUE(I3.INST_CODE) OVER (ORDER BY I3.INST_NAME) FROM INST I3 WHERE I3.HEI_INST_CODE = I2.HEI_INST_CODE  )) ) RUK
                       FROM SLCADMIN.COURSE_CHANGE CC, INST I, INST I2
                      WHERE     CC.NEW_INST_CODE = I.INST_CODE(+)
                      AND       CC.OLD_INST_CODE = I2.INST_CODE(+)
                            AND CC.COURSE_CHANGE_ID = courseChangeId_in) X;
       ELSIF termChangeId_in > 0
       THEN
          NULL; 
       ELSE
          error_boolean := 'true';
          ERROR_TEXT := 'crse_id, courseChangeId and termchangeid are not set';
       END IF;

       io_cursor := courseDetails_cursor;
    EXCEPTION
       WHEN OTHERS
       THEN
          error_boolean := 'true';
          ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
    END getCourseDetails;

--    FUNCTION next_course_code (inst_code_in IN VARCHAR2)
--       RETURN VARCHAR2
--    IS
--       CURSOR C_MAX_CRSE_CODE
--       IS
--          WITH C_POSSIBLE_CRSE
--               AS (SELECT    CHR (ASCII ('A') + TRUNC (ROWNUM / 1000))
--                          || SUBSTR (LPAD (ROWNUM, 10, '0'), -3)
--                             POSSIBLE_CRSE_CODE,
--                          MOD (ROWNUM, 1000) MOD_VAL
--                     FROM STUD_CRSE_YEAR S
--                    WHERE ROWNUM < 26000)
--          SELECT                                                        --DISTINCT
--                                                                    --I.INST_CODE,
--                                                                    --I.INST_NAME,
--                (SELECT MIN (X.POSSIBLE_CRSE_CODE) NEXT_CRSE_CODE
--                   FROM C_POSSIBLE_CRSE X, CRSE C
--                  WHERE     X.MOD_VAL > 0
--                        AND X.POSSIBLE_CRSE_CODE = C.CRSE_CODE(+)
--                        AND I.INST_CODE = C.INST_CODE(+)
--                        AND NULL = C.CRSE_CODE(+))
--                   NEXT_CRSE_CODE
--           FROM INST I
--          WHERE I.INST_CODE = inst_code_in;
--       V_MAX_CRSE_CODE VARCHAR2(4);
--    BEGIN
--       OPEN C_MAX_CRSE_CODE;
--
--       FETCH C_MAX_CRSE_CODE INTO V_MAX_CRSE_CODE;
--
--       CLOSE C_MAX_CRSE_CODE;
--
--       RETURN V_MAX_CRSE_CODE;
--    END next_course_code;


   
      PROCEDURE getSessionDetails (
       crseSessionId_in          IN            VARCHAR2,
       courseChangeId_in   IN            VARCHAR2,
       termChangeId_in     IN            VARCHAR2,
      io_cursor        IN OUT        TERM_DATES_CURSOR,
      error_boolean       OUT NOCOPY VARCHAR2,
      ERROR_TEXT          OUT NOCOPY VARCHAR2)
   IS
        CURSOR C_CHECK_CRSE_ID IS
        SELECT CASE
          WHEN X.SCHEME_TYPE = 'B' THEN 'Y'
          WHEN X.EU_FLAG = 'Y' THEN 'Y'
          WHEN X.HEI_CRSE_CODE IS NULL AND X.CRSE_ID IS NOT NULL THEN 'Y'
          ELSE 'N'
       END
          USE_CRSE_ID
          FROM (SELECT MAX (C.SCHEME_TYPE) SCHEME_TYPE,
                       MAX (NVL (CY.EU_FLAG, 'N')) EU_FLAG,
                       MAX (TC.HEI_CRSE_CODE) HEI_CRSE_CODE,
                       MAX(TC.CRSE_ID) CRSE_ID
                  FROM SLCADMIN.TERM_CHANGE TC,
                       CRSE C,
                       CRSE_SESSION CS,
                       CRSE_YEAR CY
                 WHERE     TC.TERM_CHANGE_ID = NVL (termChangeId_in, 0)
                       AND TC.CRSE_ID = C.CRSE_ID
                       AND TC.CRSE_ID = CS.CRSE_ID
                       AND TC.SESSION_CODE = CS.SESSION_CODE
                       AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID(+)) X;
               
      V_USE_CRSE_ID           VARCHAR2 (1);         
      temp_session_id         VARCHAR2 (10);
      sessionDetails_cursor   TERM_DATES_CURSOR;
   BEGIN
        IF NVL(crseSessionId_in,0) > 0 
       THEN
            IF courseChangeId_in > 0
            THEN
          OPEN sessionDetails_cursor FOR
             WITH COURSE_CHANGES
             AS (SELECT /*+ INLINE */
                       CT.ACADEMIC_YEAR CRSE_YEAR_NO,
                        NULL STUDY_ABROAD,
                        TO_NUMBER (CT.FEES) SLC_VAR_AMOUNT,
                        ROUND (TO_NUMBER (CT.FEES) / 2) AS SLC_SANDWICH_AMOUNT,
                        NULL VAR_AMOUNT,
                        NULL SANDWICH_AMOUNT,                        
                        CASE
                          WHEN TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                   IGNORE NULLS
                                   OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'MM') > 7
                          THEN
                             'DEFAULT'
                          WHEN TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                   IGNORE NULLS
                                   OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'MM') < 4
                          THEN
                             'JANUARY START'
                          WHEN TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                   IGNORE NULLS
                                   OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'MM') BETWEEN 4 AND 6
                          THEN
                             'OTHER'
                          ELSE
                             NULL
                       END
                          SLC_CUTOFF_TYPE,
                       CASE
                          WHEN TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                   IGNORE NULLS
                                   OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'MM') > 7
                          THEN
                             TO_CHAR (
                                TO_DATE ('01/12/' || TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                   IGNORE NULLS
                                   OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'YYYY'),
                                         'DD/MM/YYYY'),
                                'DD/MM/YYYY')
                          WHEN TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                   IGNORE NULLS
                                   OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'MM') < 4
                          THEN
                             TO_CHAR (
                                TO_DATE ('01/3/' || TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                   IGNORE NULLS
                                   OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'YYYY'),
                                         'DD/MM/YYYY'),
                                'DD/MM/YYYY')
                          WHEN TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                   IGNORE NULLS
                                   OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'MM') BETWEEN 4 AND 6
                          THEN
                             TO_CHAR (
                                TO_DATE ('01/6/' || TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                   IGNORE NULLS
                                   OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'YYYY'),
                                         'DD/MM/YYYY'),
                                'DD/MM/YYYY')
                          ELSE
                             NULL
                       END
                          SLC_CUTOFF_DATE,                        
                        'false' DEFAULT_TERMS,
                        'false' EU_FLAG,
                        CT.HEI_CRSE_CODE HEI_CRSE_CODE,
                        CT.TERM,
                        CT.TERM_START,
                        FIRST_VALUE (CT.TERM_START)
                           IGNORE NULLS
                           OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM)
                           AS FIRST_TERM_START,
                        (SELECT MAX (CASE
                                        WHEN     C2.SCHEME_TYPE = 'U'
                                             AND I2.LOCATION_IND IN (2,
                                                                     3,
                                                                     4,
                                                                     5)
                                        THEN
                                           'Y'
                                        ELSE
                                           'N'
                                     END)
                                   RUK
                           FROM CRSE_YEAR CY2, CRSE C2, INST I2
                          WHERE     CY2.CRSE_SESSION_ID = crseSessionId_in
                                AND CY2.CRSE_ID = C2.CRSE_ID
                                AND C2.INST_CODE = I2.INST_CODE)
                           RUK_UG,
                           CT.SESSION_CODE
                   FROM SLCADMIN.CURRENT_COURSE CUC,
                        SLCADMIN.CURRENT_TERM CT,
                        (SELECT NVL (CC.NEW_HEI_CRSE_CODE, CC.OLD_HEI_CRSE_CODE)
                                   HEI_CRSE_CODE,
                                CC.SESSION_CODE
                           FROM SLCADMIN.COURSE_CHANGE CC
                          WHERE CC.COURSE_CHANGE_ID = NVL (courseChangeId_in, 0)) CC2
                  WHERE     CUC.HEI_CRSE_CODE = CC2.HEI_CRSE_CODE
                        AND CUC.HEI_CRSE_CODE = CT.HEI_CRSE_CODE
                        AND CUC.SESSION_CODE = CC2.SESSION_CODE
                        AND CUC.SESSION_CODE = CT.SESSION_CODE
                        AND CT.TERM =
                               (SELECT MIN (CT1.TERM)
                                  FROM SLCADMIN.CURRENT_TERM CT1
                                 WHERE     CT1.HEI_CRSE_CODE = CT.HEI_CRSE_CODE
                                       AND CT1.SESSION_CODE = CT.SESSION_CODE
                                       AND CT1.ACADEMIC_YEAR = CT.ACADEMIC_YEAR))
        SELECT CY.CRSE_YEAR_NO,
               CY.STUDY_ABROAD,
               NULL SLC_VAR_AMOUNT,
               NULL SLC_SANDWICH_AMOUNT,
               CASE
                  WHEN CCS.RUK_UG = 'Y'
                  THEN
                     NVL (CCS.SLC_VAR_AMOUNT, CY.VAR_TUITION_FEE_AMNT)
                  ELSE
                     CY.VAR_TUITION_FEE_AMNT
               END
                  AS VAR_AMOUNT,
               CASE
                  WHEN CCS.RUK_UG = 'Y'
                  THEN
                     NVL (CCS.SLC_SANDWICH_AMOUNT, CY.VAR_SANDWICH_TUITION_FEE_AMNT)
                  ELSE
                     CY.VAR_SANDWICH_TUITION_FEE_AMNT
               END
                  AS SANDWICH_AMOUNT,
               UPPER(NVL(SLC_CUTOFF_TYPE,CY.CUTOFF_TYPE)) CUTOFF_TYPE,
               NVL(SLC_CUTOFF_DATE, TO_CHAR (CY.CUTOFF_DATE, 'DD/MM/YYYY')) CUTOFF_DATE,
               CASE
                  WHEN NVL (CY.DEFAULT_TERMS, 'X') = 'Y' THEN 'true'
                  ELSE 'false'
               END
                  DEFAULT_TERMS,
               CASE WHEN NVL (CY.EU_FLAG, 'X') = 'Y' THEN 'true' ELSE 'false' END
                  EU_FLAG,
               CY.HEI_CRSE_CODE,
               (SELECT COUNT (DISTINCT SCY.STUD_REF_NO) STUDENTS
                  FROM STUD_CRSE_YEAR SCY
                 WHERE SCY.CRSE_YEAR_ID = CY.CRSE_YEAR_ID)
                  STUDENTS,
               CY.CRSE_YEAR_ID,
               NVL(CY.VAR_TUITION_FEE_AMNT,0) OLD_VAR_AMOUNT,
               NVL(CY.VAR_SANDWICH_TUITION_FEE_AMNT,0) OLD_SANDWICH_AMOUNT,
               CCS.RUK_UG,
               UPPER(CY.CUTOFF_TYPE) OLD_CUTOFF_TYPE,
               TO_CHAR (CY.CUTOFF_DATE, 'DD/MM/YYYY') OLD_CUTOFF_DATE,
               (SELECT CASE WHEN COUNT (0) = 0 THEN 'D' ELSE NULL END CHANGE_TYPE
                  FROM SLCADMIN.CURRENT_TERM CT
                 WHERE     CT.HEI_CRSE_CODE = CY.HEI_CRSE_CODE
                       AND CT.SESSION_CODE = CCS.SESSION_CODE
                       AND CT.ACADEMIC_YEAR = CY.CRSE_YEAR_NO) CHANGE_TYPE
          FROM CRSE_YEAR CY, COURSE_CHANGES CCS
         WHERE CRSE_SESSION_ID = crseSessionId_in AND CY.CRSE_YEAR_NO = CCS.CRSE_YEAR_NO(+)
        UNION
        SELECT X.CRSE_YEAR_NO,
               X.STUDY_ABROAD,
               X.SLC_VAR_AMOUNT,
               X.SLC_SANDWICH_AMOUNT,
               CASE
                  WHEN X.RUK_UG = 'Y' THEN TO_NUMBER (X.SLC_VAR_AMOUNT)
                  ELSE TO_NUMBER (X.VAR_AMOUNT)
               END
                  VAR_AMOUNT,
               CASE
                  WHEN X.RUK_UG = 'Y' THEN TO_NUMBER (X.SLC_SANDWICH_AMOUNT)
                  ELSE TO_NUMBER (X.SANDWICH_AMOUNT)
               END
                  SANDWICH_AMOUNT,
               X.SLC_CUTOFF_TYPE CUTOFF_TYPE,
               X.SLC_CUTOFF_DATE CUTOFF_DATE,
               X.DEFAULT_TERMS,
               X.EU_FLAG,
               X.HEI_CRSE_CODE,
               0 STUDENTS,
               NULL CRSE_YEAR_ID,
               NULL OLD_VAR_AMOUNT,
               NULL OLD_SANDWICH_AMOUNT,
               NULL RUK_UG,
               NULL OLD_CUTOFF_TYPE,
               NULL OLD_CUTOFF_DATE,
               NULL CHANGE_TYPE
          FROM COURSE_CHANGES X
         WHERE NOT EXISTS
                      (SELECT 1
                         FROM CRSE_YEAR CY
                        WHERE     CY.CRSE_SESSION_ID = crseSessionId_in
                              AND CY.CRSE_YEAR_NO = X.CRSE_YEAR_NO)
        ORDER BY 1;
        ELSE 
        
            OPEN C_CHECK_CRSE_ID;
            FETCH C_CHECK_CRSE_ID INTO V_USE_CRSE_ID;
            CLOSE C_CHECK_CRSE_ID;
            IF NVL(V_USE_CRSE_ID,'N') = 'Y'
            THEN
              OPEN sessionDetails_cursor FOR   
                WITH COURSE_CHANGES
                     AS (/* Formatted on 02/08/2019 10:38:39 (QP5 v5.256.13226.35538) */
SELECT 
       x.ACADEMIC_YEAR CRSE_YEAR_NO,
       FIRST_VALUE (x.STUDY_ABROAD)
          IGNORE NULLS
          OVER (PARTITION BY x.ACADEMIC_YEAR ORDER BY x.TERM)
          STUDY_ABROAD,
       x.SLC_VAR_AMOUNT,
       x.SLC_SANDWICH_AMOUNT,
       NULL VAR_AMOUNT,
       NULL SANDWICH_AMOUNT,
       CASE
          WHEN TO_CHAR (
                  FIRST_VALUE (x.NEW_TERM_START)
                     IGNORE NULLS
                     OVER (PARTITION BY x.ACADEMIC_YEAR ORDER BY x.TERM),
                  'MM') > 7
          THEN
             'DEFAULT'
          WHEN TO_CHAR (
                  FIRST_VALUE (x.NEW_TERM_START)
                     IGNORE NULLS
                     OVER (PARTITION BY x.ACADEMIC_YEAR ORDER BY x.TERM),
                  'MM') < 4
          THEN
             'JANUARY START'
          WHEN TO_CHAR (
                  FIRST_VALUE (x.NEW_TERM_START)
                     IGNORE NULLS
                     OVER (PARTITION BY x.ACADEMIC_YEAR ORDER BY x.TERM),
                  'MM') BETWEEN 4
                            AND 6
          THEN
             'OTHER'
          ELSE
             NULL
       END
          SLC_CUTOFF_TYPE,
       CASE
          WHEN TO_CHAR (
                  FIRST_VALUE (x.NEW_TERM_START)
                     IGNORE NULLS
                     OVER (PARTITION BY x.ACADEMIC_YEAR ORDER BY x.TERM),
                  'MM') > 7
          THEN
             TO_CHAR (
                TO_DATE (
                      '01/12/'
                   || TO_CHAR (
                         FIRST_VALUE (x.NEW_TERM_START)
                         IGNORE NULLS
                         OVER (PARTITION BY x.ACADEMIC_YEAR ORDER BY x.TERM),
                         'YYYY'),
                   'DD/MM/YYYY'),
                'DD/MM/YYYY')
          WHEN TO_CHAR (
                  FIRST_VALUE (x.NEW_TERM_START)
                     IGNORE NULLS
                     OVER (PARTITION BY x.ACADEMIC_YEAR ORDER BY x.TERM),
                  'MM') < 4
          THEN
             TO_CHAR (
                TO_DATE (
                      '01/3/'
                   || TO_CHAR (
                         FIRST_VALUE (x.NEW_TERM_START)
                         IGNORE NULLS
                         OVER (PARTITION BY x.ACADEMIC_YEAR ORDER BY x.TERM),
                         'YYYY'),
                   'DD/MM/YYYY'),
                'DD/MM/YYYY')
          WHEN TO_CHAR (
                  FIRST_VALUE (x.NEW_TERM_START)
                     IGNORE NULLS
                     OVER (PARTITION BY x.ACADEMIC_YEAR ORDER BY x.TERM),
                  'MM') BETWEEN 4
                            AND 6
          THEN
             TO_CHAR (
                TO_DATE (
                      '01/6/'
                   || TO_CHAR (
                         FIRST_VALUE (x.NEW_TERM_START)
                         IGNORE NULLS
                         OVER (PARTITION BY x.ACADEMIC_YEAR ORDER BY x.TERM),
                         'YYYY'),
                   'DD/MM/YYYY'),
                'DD/MM/YYYY')
          ELSE
             NULL
       END
          SLC_CUTOFF_DATE,
       'false' DEFAULT_TERMS,
       'false' EU_FLAG,
       x.HEI_CRSE_CODE HEI_CRSE_CODE,
       x.TERM,
       x.NEW_TERM_START,
       FIRST_VALUE (x.NEW_TERM_START)
          IGNORE NULLS
          OVER (PARTITION BY x.ACADEMIC_YEAR ORDER BY x.TERM)
          AS FIRST_TERM_START,
       x.RUK_UG,
       x.SESSION_CODE
  FROM (SELECT TC1.ACADEMIC_YEAR CRSE_YEAR_NO,
               NULL STUDY_ABROAD,
               TO_NUMBER (TC1.NEW_FEES) SLC_VAR_AMOUNT,
               ROUND (TO_NUMBER (TC1.NEW_FEES) / 2) AS SLC_SANDWICH_AMOUNT,
               NULL VAR_AMOUNT,
               NULL SANDWICH_AMOUNT,
               TC1.NEW_TERM_START,
               TC1.ACADEMIC_YEAR,
               TC1.TERM,
               'false' DEFAULT_TERMS,
               'false' EU_FLAG,
               TC1.HEI_CRSE_CODE HEI_CRSE_CODE,
               (SELECT MAX (CASE
                               WHEN     C2.SCHEME_TYPE = 'U'
                                    AND I2.LOCATION_IND IN (2,
                                                            3,
                                                            4,
                                                            5)
                               THEN
                                  'Y'
                               ELSE
                                  'N'
                            END)
                          RUK
                  FROM CRSE_YEAR CY2, CRSE C2, INST I2
                 WHERE     CY2.CRSE_SESSION_ID = crseSessionId_in
                       AND CY2.CRSE_ID = C2.CRSE_ID
                       AND C2.INST_CODE = I2.INST_CODE)
                  RUK_UG,
               TC1.SESSION_CODE
          FROM SLCADMIN.TERM_CHANGE TC1,
               (SELECT TC.*
                  FROM SLCADMIN.TERM_CHANGE TC
                 WHERE TC.TERM_CHANGE_ID = NVL (termChangeId_in, 0)) TC2
         WHERE     TC1.CRSE_ID = TC2.CRSE_ID
               AND TC1.SESSION_CODE = TC2.SESSION_CODE
               AND TC1.STATUS = 'NEW'
               AND TC1.CHANGE_TYPE IN ('I', 'U')
        UNION ALL
        SELECT CY.CRSE_YEAR_NO,
               CY.STUDY_ABROAD STUDY_ABROAD,
               CY.VAR_TUITION_FEE_AMNT SLC_VAR_AMOUNT,
               CY.VAR_SANDWICH_TUITION_FEE_AMNT SLC_SANDWICH_AMOUNT,
               NULL VAR_AMOUNT,
               NULL SANDWICH_AMOUNT,
               CT.START_DATE,
               CY.CRSE_YEAR_NO,
               CT.TERM_NO,
               'false' DEFAULT_TERMS,
               'false' EU_FLAG,
               CY.HEI_CRSE_CODE HEI_CRSE_CODE,
               (SELECT MAX (CASE
                               WHEN     C2.SCHEME_TYPE = 'U'
                                    AND I2.LOCATION_IND IN (2,
                                                            3,
                                                            4,
                                                            5)
                               THEN
                                  'Y'
                               ELSE
                                  'N'
                            END)
                          RUK
                  FROM CRSE_YEAR CY2, CRSE C2, INST I2
                 WHERE     CY2.CRSE_SESSION_ID = crseSessionId_in
                       AND CY2.CRSE_ID = C2.CRSE_ID
                       AND C2.INST_CODE = I2.INST_CODE)
                  RUK_UG,
               (SELECT TO_CHAR (CS.SESSION_CODE) SESSION_CODE
                  FROM CRSE_SESSION CS
                 WHERE CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID)
                  SESSION_CODE
          FROM CRSE_YEAR CY,
               CRSE_TERM CT,
               (SELECT MAX (CASE
                               WHEN     C2.SCHEME_TYPE = 'U'
                                    AND I2.LOCATION_IND IN (2,
                                                            3,
                                                            4,
                                                            5)
                               THEN
                                  'Y'
                               ELSE
                                  'N'
                            END)
                          RUK
                  FROM CRSE_YEAR CY2, CRSE C2, INST I2
                 WHERE     CY2.CRSE_SESSION_ID = crseSessionId_in
                       AND CY2.CRSE_ID = C2.CRSE_ID
                       AND C2.INST_CODE = I2.INST_CODE) RUK_UG
         WHERE     CY.CRSE_SESSION_ID = crseSessionId_in
               AND CY.DEFAULT_TERMS = 'N'
               AND CT.CRSE_YEAR_ID = CY.CRSE_YEAR_ID
               AND (CY.CRSE_YEAR_NO, CT.TERM_NO) NOT IN (SELECT TC1.ACADEMIC_YEAR,
                                                                TC1.TERM
                                                           FROM SLCADMIN.TERM_CHANGE TC1,
                                                                (SELECT TC.*
                                                                   FROM SLCADMIN.TERM_CHANGE TC
                                                                  WHERE TC.TERM_CHANGE_ID =
                                                                           NVL (
                                                                              termChangeId_in,
                                                                              0))
                                                                TC2
                                                          WHERE     TC1.CRSE_ID =
                                                                       TC2.CRSE_ID
                                                                AND TC1.SESSION_CODE =
                                                                       TC2.SESSION_CODE
                                                                AND TC1.STATUS =
                                                                       'NEW')
        UNION ALL
        SELECT CY.CRSE_YEAR_NO,
               CY.STUDY_ABROAD STUDY_ABROAD,
               CY.VAR_TUITION_FEE_AMNT SLC_VAR_AMOUNT,
               CY.VAR_SANDWICH_TUITION_FEE_AMNT SLC_SANDWICH_AMOUNT,
               NULL VAR_AMOUNT,
               NULL SANDWICH_AMOUNT,
               IT.START_DATE,
               CY.CRSE_YEAR_NO,
               IT.TERM_NO,
               'false' DEFAULT_TERMS,
               'false' EU_FLAG,
               CY.HEI_CRSE_CODE HEI_CRSE_CODE,
               (SELECT MAX (CASE
                               WHEN     C2.SCHEME_TYPE = 'U'
                                    AND I2.LOCATION_IND IN (2,
                                                            3,
                                                            4,
                                                            5)
                               THEN
                                  'Y'
                               ELSE
                                  'N'
                            END)
                          RUK
                  FROM CRSE_YEAR CY2, CRSE C2, INST I2
                 WHERE     CY2.CRSE_SESSION_ID = crseSessionId_in
                       AND CY2.CRSE_ID = C2.CRSE_ID
                       AND C2.INST_CODE = I2.INST_CODE)
                  RUK_UG,
               (SELECT TO_CHAR (CS.SESSION_CODE) SESSION_CODE
                  FROM CRSE_SESSION CS
                 WHERE CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID)
                  SESSION_CODE
          FROM CRSE_YEAR CY,
               CRSE_SESSION CS,
               CRSE C,
               INST_TERM IT,
               (SELECT MAX (CASE
                               WHEN     C2.SCHEME_TYPE = 'U'
                                    AND I2.LOCATION_IND IN (2,
                                                            3,
                                                            4,
                                                            5)
                               THEN
                                  'Y'
                               ELSE
                                  'N'
                            END)
                          RUK
                  FROM CRSE_YEAR CY2, CRSE C2, INST I2
                 WHERE     CY2.CRSE_SESSION_ID = crseSessionId_in
                       AND CY2.CRSE_ID = C2.CRSE_ID
                       AND C2.INST_CODE = I2.INST_CODE) RUK_UG
         WHERE     CY.CRSE_SESSION_ID = crseSessionId_in
               AND CY.CRSE_SESSION_ID = CS.CRSE_SESSION_ID
               AND CY.DEFAULT_TERMS = 'Y'
               AND CY.CRSE_ID = C.CRSE_ID
               AND C.INST_CODE = IT.INST_CODE
               AND CS.SESSION_CODE = IT.SESSION_CODE
               AND CY.CRSE_YEAR_NO NOT IN (SELECT TC1.ACADEMIC_YEAR
                                             FROM SLCADMIN.TERM_CHANGE TC1,
                                                  (SELECT TC.*
                                                     FROM SLCADMIN.TERM_CHANGE TC
                                                    WHERE TC.TERM_CHANGE_ID =
                                                             NVL (termChangeId_in,
                                                                  0)) TC2
                                            WHERE     TC1.CRSE_ID =
                                                         TC2.CRSE_ID
                                                  AND TC1.SESSION_CODE =
                                                         TC2.SESSION_CODE
                                                  AND TC1.STATUS = 'NEW')) x)
                SELECT CY.CRSE_YEAR_NO,
                       CY.STUDY_ABROAD,
                       NULL SLC_VAR_AMOUNT,
                       NULL SLC_SANDWICH_AMOUNT,
                       CASE
                          WHEN CCS.RUK_UG = 'Y'
                          THEN
                             NVL (CCS.SLC_VAR_AMOUNT, CY.VAR_TUITION_FEE_AMNT)
                          ELSE
                             CY.VAR_TUITION_FEE_AMNT
                       END
                          AS VAR_AMOUNT,
                       CASE
                          WHEN CCS.RUK_UG = 'Y'
                          THEN
                             NVL (CCS.SLC_SANDWICH_AMOUNT, CY.VAR_SANDWICH_TUITION_FEE_AMNT)
                          ELSE
                             CY.VAR_SANDWICH_TUITION_FEE_AMNT
                       END
                          AS SANDWICH_AMOUNT,
                       UPPER (NVL (SLC_CUTOFF_TYPE, CY.CUTOFF_TYPE)) CUTOFF_TYPE,
                       NVL (SLC_CUTOFF_DATE, TO_CHAR (CY.CUTOFF_DATE, 'DD/MM/YYYY'))
                          CUTOFF_DATE,
                       CASE
                          WHEN NVL (CY.DEFAULT_TERMS, 'X') = 'Y' THEN 'true'
                          ELSE 'false'
                       END
                          DEFAULT_TERMS,
                       CASE WHEN NVL (CY.EU_FLAG, 'X') = 'Y' THEN 'true' ELSE 'false' END
                          EU_FLAG,
                       CY.HEI_CRSE_CODE,
                       (SELECT COUNT (DISTINCT SCY.STUD_REF_NO) STUDENTS
                          FROM STUD_CRSE_YEAR SCY
                         WHERE SCY.CRSE_YEAR_ID = CY.CRSE_YEAR_ID)
                          STUDENTS,
                       CY.CRSE_YEAR_ID,
                       NVL (CY.VAR_TUITION_FEE_AMNT, 0) OLD_VAR_AMOUNT,
                       NVL (CY.VAR_SANDWICH_TUITION_FEE_AMNT, 0) OLD_SANDWICH_AMOUNT,
                       CCS.RUK_UG,
                       UPPER (CY.CUTOFF_TYPE) OLD_CUTOFF_TYPE,
                       TO_CHAR (CY.CUTOFF_DATE, 'DD/MM/YYYY') OLD_CUTOFF_DATE,
                       (SELECT  CASE WHEN COUNT (0) > 0 THEN 'D' ELSE NULL END CHANGE_TYPE
                        FROM SLCADMIN.TERM_CHANGE TC, CRSE_SESSION CS
--                        WHERE (TC.CRSE_ID =    CY.CRSE_ID OR TC.HEI_CRSE_CODE = CY.HEI_CRSE_CODE)
                        WHERE TC.CRSE_ID =    CY.CRSE_ID 
                        AND TC.ACADEMIC_YEAR = CY.CRSE_YEAR_NO
                        AND TC.CHANGE_TYPE = 'D'
                        AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
                        AND TC.SESSION_CODE = CS.SESSION_CODE
                        AND TC.STATUS = 'NEW')
                      CHANGE_TYPE
                  FROM CRSE_YEAR CY, COURSE_CHANGES CCS
                 WHERE CRSE_SESSION_ID = crseSessionId_in AND CY.CRSE_YEAR_NO = CCS.CRSE_YEAR_NO(+)
                UNION
                SELECT X.CRSE_YEAR_NO,
                       X.STUDY_ABROAD,
                       X.SLC_VAR_AMOUNT,
                       X.SLC_SANDWICH_AMOUNT,
                       CASE
                          WHEN X.RUK_UG = 'Y' THEN TO_NUMBER (X.SLC_VAR_AMOUNT)
                          ELSE TO_NUMBER (X.VAR_AMOUNT)
                       END
                          VAR_AMOUNT,
                       CASE
                          WHEN X.RUK_UG = 'Y' THEN TO_NUMBER (X.SLC_SANDWICH_AMOUNT)
                          ELSE TO_NUMBER (X.SANDWICH_AMOUNT)
                       END
                          SANDWICH_AMOUNT,
                       X.SLC_CUTOFF_TYPE CUTOFF_TYPE,
                       X.SLC_CUTOFF_DATE CUTOFF_DATE,
                       X.DEFAULT_TERMS,
                       X.EU_FLAG,
                       X.HEI_CRSE_CODE,
                       0 STUDENTS,
                       NULL CRSE_YEAR_ID,
                       NULL OLD_VAR_AMOUNT,
                       NULL OLD_SANDWICH_AMOUNT,
                       NULL RUK_UG,
                       NULL OLD_CUTOFF_TYPE,
                       NULL OLD_CUTOFF_DATE,
                       NULL CHANGE_TYPE
                  FROM COURSE_CHANGES X
                 WHERE NOT EXISTS
                              (SELECT 1
                                 FROM CRSE_YEAR CY
                                WHERE     CY.CRSE_SESSION_ID = crseSessionId_in
                                      AND CY.CRSE_YEAR_NO = X.CRSE_YEAR_NO)
                ORDER BY 1;
            ELSE
              OPEN sessionDetails_cursor FOR
                 WITH COURSE_CHANGES
                 AS (SELECT /*+ INLINE */
                           CT.ACADEMIC_YEAR CRSE_YEAR_NO,
                            NULL STUDY_ABROAD,
                            TO_NUMBER (CT.FEES) SLC_VAR_AMOUNT,
                            ROUND (TO_NUMBER (CT.FEES) / 2) AS SLC_SANDWICH_AMOUNT,
                            NULL VAR_AMOUNT,
                            NULL SANDWICH_AMOUNT,                        
                            CASE
                              WHEN TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                       IGNORE NULLS
                                       OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'MM') > 7
                              THEN
                                 'DEFAULT'
                              WHEN TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                       IGNORE NULLS
                                       OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'MM') < 4
                              THEN
                                 'JANUARY START'
                              WHEN TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                       IGNORE NULLS
                                       OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'MM') BETWEEN 4 AND 6
                              THEN
                                 'OTHER'
                              ELSE
                                 NULL
                           END
                              SLC_CUTOFF_TYPE,
                           CASE
                              WHEN TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                       IGNORE NULLS
                                       OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'MM') > 7
                              THEN
                                 TO_CHAR (
                                    TO_DATE ('01/12/' || TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                       IGNORE NULLS
                                       OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'YYYY'),
                                             'DD/MM/YYYY'),
                                    'DD/MM/YYYY')
                              WHEN TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                       IGNORE NULLS
                                       OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'MM') < 4
                              THEN
                                 TO_CHAR (
                                    TO_DATE ('01/3/' || TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                       IGNORE NULLS
                                       OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'YYYY'),
                                             'DD/MM/YYYY'),
                                    'DD/MM/YYYY')
                              WHEN TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                       IGNORE NULLS
                                       OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'MM') BETWEEN 4 AND 6
                              THEN
                                 TO_CHAR (
                                    TO_DATE ('01/6/' || TO_CHAR (FIRST_VALUE (CT.TERM_START)
                                       IGNORE NULLS
                                       OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM), 'YYYY'),
                                             'DD/MM/YYYY'),
                                    'DD/MM/YYYY')
                              ELSE
                                 NULL
                           END
                              SLC_CUTOFF_DATE,                        
                            'false' DEFAULT_TERMS,
                            'false' EU_FLAG,
                            CT.HEI_CRSE_CODE HEI_CRSE_CODE,
                            CT.TERM,
                            CT.TERM_START,
                            FIRST_VALUE (CT.TERM_START)
                               IGNORE NULLS
                               OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM)
                               AS FIRST_TERM_START,
                            (SELECT MAX (CASE
                                            WHEN     C2.SCHEME_TYPE = 'U'
                                                 AND I2.LOCATION_IND IN (2,
                                                                         3,
                                                                         4,
                                                                         5)
                                            THEN
                                               'Y'
                                            ELSE
                                               'N'
                                         END)
                                       RUK
                               FROM CRSE_YEAR CY2, CRSE C2, INST I2
                              WHERE     CY2.CRSE_SESSION_ID = crseSessionId_in
                                    AND CY2.CRSE_ID = C2.CRSE_ID
                                    AND C2.INST_CODE = I2.INST_CODE)
                               RUK_UG,
                               CT.SESSION_CODE
                       FROM SLCADMIN.CURRENT_COURSE CUC,
                            SLCADMIN.CURRENT_TERM CT,
                            (SELECT TC.HEI_CRSE_CODE,
                                    TC.SESSION_CODE
                               FROM SLCADMIN.TERM_CHANGE TC
                              WHERE TC.TERM_CHANGE_ID = NVL (termChangeId_in, 0)) CC2
                      WHERE     CUC.HEI_CRSE_CODE = CC2.HEI_CRSE_CODE
                            AND CUC.HEI_CRSE_CODE = CT.HEI_CRSE_CODE
                            AND CUC.SESSION_CODE = CC2.SESSION_CODE
                            AND CUC.SESSION_CODE = CT.SESSION_CODE
                            AND CT.TERM =
                                   (SELECT MIN (CT1.TERM)
                                      FROM SLCADMIN.CURRENT_TERM CT1
                                     WHERE     CT1.HEI_CRSE_CODE = CT.HEI_CRSE_CODE
                                           AND CT1.SESSION_CODE = CT.SESSION_CODE
                                           AND CT1.ACADEMIC_YEAR = CT.ACADEMIC_YEAR))
            SELECT CY.CRSE_YEAR_NO,
                   CY.STUDY_ABROAD,
                   NULL SLC_VAR_AMOUNT,
                   NULL SLC_SANDWICH_AMOUNT,
                   CASE
                      WHEN CCS.RUK_UG = 'Y'
                      THEN
                         NVL (CCS.SLC_VAR_AMOUNT, CY.VAR_TUITION_FEE_AMNT)
                      ELSE
                         CY.VAR_TUITION_FEE_AMNT
                   END
                      AS VAR_AMOUNT,
                   CASE
                      WHEN CCS.RUK_UG = 'Y'
                      THEN
                         NVL (CCS.SLC_SANDWICH_AMOUNT, CY.VAR_SANDWICH_TUITION_FEE_AMNT)
                      ELSE
                         CY.VAR_SANDWICH_TUITION_FEE_AMNT
                   END
                      AS SANDWICH_AMOUNT,
                   UPPER(NVL(SLC_CUTOFF_TYPE,CY.CUTOFF_TYPE)) CUTOFF_TYPE,
                   NVL(SLC_CUTOFF_DATE, TO_CHAR (CY.CUTOFF_DATE, 'DD/MM/YYYY')) CUTOFF_DATE,
                   CASE
                      WHEN NVL (CY.DEFAULT_TERMS, 'X') = 'Y' THEN 'true'
                      ELSE 'false'
                   END
                      DEFAULT_TERMS,
                   CASE WHEN NVL (CY.EU_FLAG, 'X') = 'Y' THEN 'true' ELSE 'false' END
                      EU_FLAG,
                   CY.HEI_CRSE_CODE,
                   (SELECT COUNT (DISTINCT SCY.STUD_REF_NO) STUDENTS
                      FROM STUD_CRSE_YEAR SCY
                     WHERE SCY.CRSE_YEAR_ID = CY.CRSE_YEAR_ID)
                      STUDENTS,
                   CY.CRSE_YEAR_ID,
                   NVL(CY.VAR_TUITION_FEE_AMNT,0) OLD_VAR_AMOUNT,
                   NVL(CY.VAR_SANDWICH_TUITION_FEE_AMNT,0) OLD_SANDWICH_AMOUNT,
                   CCS.RUK_UG,
                   UPPER(CY.CUTOFF_TYPE) OLD_CUTOFF_TYPE,
                   TO_CHAR (CY.CUTOFF_DATE, 'DD/MM/YYYY') OLD_CUTOFF_DATE,
                   (SELECT CASE WHEN COUNT (0) = 0 THEN 'D' ELSE NULL END CHANGE_TYPE
                      FROM SLCADMIN.CURRENT_TERM CT
                     WHERE     CT.HEI_CRSE_CODE = CY.HEI_CRSE_CODE
                           AND CT.SESSION_CODE = CCS.SESSION_CODE
                           AND CT.ACADEMIC_YEAR = CY.CRSE_YEAR_NO) CHANGE_TYPE
              FROM CRSE_YEAR CY, COURSE_CHANGES CCS
             WHERE CRSE_SESSION_ID = crseSessionId_in AND CY.CRSE_YEAR_NO = CCS.CRSE_YEAR_NO(+)
            UNION
            SELECT X.CRSE_YEAR_NO,
                   X.STUDY_ABROAD,
                   X.SLC_VAR_AMOUNT,
                   X.SLC_SANDWICH_AMOUNT,
                   CASE
                      WHEN X.RUK_UG = 'Y' THEN TO_NUMBER (X.SLC_VAR_AMOUNT)
                      ELSE TO_NUMBER (X.VAR_AMOUNT)
                   END
                      VAR_AMOUNT,
                   CASE
                      WHEN X.RUK_UG = 'Y' THEN TO_NUMBER (X.SLC_SANDWICH_AMOUNT)
                      ELSE TO_NUMBER (X.SANDWICH_AMOUNT)
                   END
                      SANDWICH_AMOUNT,
                   X.SLC_CUTOFF_TYPE CUTOFF_TYPE,
                   X.SLC_CUTOFF_DATE CUTOFF_DATE,
                   X.DEFAULT_TERMS,
                   X.EU_FLAG,
                   X.HEI_CRSE_CODE,
                   0 STUDENTS,
                   NULL CRSE_YEAR_ID,
                   NULL OLD_VAR_AMOUNT,
                   NULL OLD_SANDWICH_AMOUNT,
                   NULL RUK_UG,
                   NULL OLD_CUTOFF_TYPE,
                   NULL OLD_CUTOFF_DATE,
                   NULL CHANGE_TYPE
              FROM COURSE_CHANGES X
             WHERE NOT EXISTS
                          (SELECT 1
                             FROM CRSE_YEAR CY
                            WHERE     CY.CRSE_SESSION_ID = crseSessionId_in
                                  AND CY.CRSE_YEAR_NO = X.CRSE_YEAR_NO)
            ORDER BY 1;
          END IF;
        END IF;
       ELSIF courseChangeId_in > 0
       THEN
          
          OPEN sessionDetails_cursor FOR
               SELECT X.CRSE_YEAR_NO,
                 X.STUDY_ABROAD,
                 X.SLC_VAR_AMOUNT,
                 X.SLC_SANDWICH_AMOUNT,
                 X.VAR_AMOUNT,
                 X.SANDWICH_AMOUNT,
                 CASE
                    WHEN TO_CHAR (X.FIRST_TERM_START, 'MM') > 7
                    THEN
                       'DEFAULT'
                    WHEN TO_CHAR (X.FIRST_TERM_START, 'MM') < 4
                    THEN
                       'JANUARY START'
                    WHEN TO_CHAR (X.FIRST_TERM_START, 'MM') BETWEEN 4 AND 6
                    THEN
                       'OTHER'
                    ELSE
                       NULL
                 END
                    CUTOFF_TYPE,
                 CASE
                    WHEN TO_CHAR (X.FIRST_TERM_START, 'MM') > 7
                    THEN
                       TO_CHAR(TO_DATE ('01/12/' || TO_CHAR (X.FIRST_TERM_START, 'YYYY'),
                                'DD/MM/YYYY'),'DD/MM/YYYY')
                    WHEN TO_CHAR (X.FIRST_TERM_START, 'MM') < 4
                    THEN
                       TO_CHAR(TO_DATE ('01/3/' || TO_CHAR (X.FIRST_TERM_START, 'YYYY'),
                                'DD/MM/YYYY'),'DD/MM/YYYY')
                    WHEN TO_CHAR (X.FIRST_TERM_START, 'MM') BETWEEN 4 AND 6
                    THEN
                       TO_CHAR(TO_DATE ('01/6/' || TO_CHAR (X.FIRST_TERM_START, 'YYYY'),
                                'DD/MM/YYYY'),'DD/MM/YYYY')
                    ELSE
                       NULL
                 END
                    CUTOFF_DATE,
                 X.DEFAULT_TERMS,
                 X.EU_FLAG,
                 X.HEI_CRSE_CODE,
                 0 STUDENTS,
                 NULL CRSE_YEAR_ID,
               NULL OLD_VAR_AMOUNT,
               NULL OLD_SANDWICH_AMOUNT,
               NULL RUK_UG,
               NULL OLD_CUTOFF_TYPE,
               NULL OLD_CUTOFF_DATE,
               NULL CHANGE_TYPE
            FROM (SELECT CT.ACADEMIC_YEAR CRSE_YEAR_NO,
                         NULL STUDY_ABROAD,
                         CT.FEES SLC_VAR_AMOUNT,
                         ROUND (TO_NUMBER (CT.FEES) / 2) AS SLC_SANDWICH_AMOUNT,
                         NULL VAR_AMOUNT,
                         NULL SANDWICH_AMOUNT,
                         NULL CUTOFF_TYPE,
                         NULL CUTOFF_DATE,
                         'false' DEFAULT_TERMS,
                         'false' EU_FLAG,
                         CT.HEI_CRSE_CODE HEI_CRSE_CODE,
                         CT.TERM,
                         CT.TERM_START,
                         FIRST_VALUE (CT.TERM_START)
                            IGNORE NULLS
                            OVER (PARTITION BY CT.ACADEMIC_YEAR ORDER BY CT.TERM)
                            AS FIRST_TERM_START
                    FROM SLCADMIN.CURRENT_COURSE CUC,
                         SLCADMIN.CURRENT_TERM CT,
                         (SELECT NVL (CC.NEW_HEI_CRSE_CODE, CC.OLD_HEI_CRSE_CODE)
                                    HEI_CRSE_CODE,
                                 CC.SESSION_CODE
                            FROM SLCADMIN.COURSE_CHANGE CC
                           WHERE CC.COURSE_CHANGE_ID = courseChangeId_in) CC2
                   WHERE     CUC.HEI_CRSE_CODE = CC2.HEI_CRSE_CODE
                         AND CUC.HEI_CRSE_CODE = CT.HEI_CRSE_CODE
                         AND CUC.SESSION_CODE = CC2.SESSION_CODE
                         AND CUC.SESSION_CODE = CT.SESSION_CODE
                         AND CT.TERM =
                                (SELECT MIN (CT1.TERM)
                                   FROM SLCADMIN.CURRENT_TERM CT1
                                  WHERE     CT1.HEI_CRSE_CODE = CT.HEI_CRSE_CODE
                                        AND CT1.SESSION_CODE = CT.SESSION_CODE
                                        AND CT1.ACADEMIC_YEAR = CT.ACADEMIC_YEAR)) X
            ORDER BY 1;
       ELSIF termChangeId_in > 0
       THEN
          NULL;
       ELSE
          error_boolean := 'true';
          ERROR_TEXT := 'crse_id, courseChangeId and termchangeid are not set';
       END IF;

      io_cursor := sessionDetails_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getSessionDetails;
   
   PROCEDURE getCourseTerms (
       crseSessionId_in          IN            VARCHAR2,
       courseChangeId_in   IN            VARCHAR2,
       termChangeId_in     IN            VARCHAR2,
      io_cursor        IN OUT        TERM_DATES_CURSOR,
      error_boolean       OUT NOCOPY VARCHAR2,
      ERROR_TEXT          OUT NOCOPY VARCHAR2)
   IS
     CURSOR C_CHECK_CRSE_ID IS
        SELECT CASE
          WHEN X.SCHEME_TYPE = 'B' THEN 'Y'
          WHEN X.EU_FLAG = 'Y' THEN 'Y'
          WHEN X.HEI_CRSE_CODE IS NULL AND X.CRSE_ID IS NOT NULL  THEN 'Y'
          ELSE 'N'
       END
          USE_CRSE_ID
          FROM (SELECT MAX (C.SCHEME_TYPE) SCHEME_TYPE,
                       MAX (NVL (CY.EU_FLAG, 'N')) EU_FLAG,
                       MAX (TC.HEI_CRSE_CODE) HEI_CRSE_CODE,
                       MAX(TC.CRSE_ID) CRSE_ID
                  FROM SLCADMIN.TERM_CHANGE TC,
                       CRSE C,
                       CRSE_SESSION CS,
                       CRSE_YEAR CY
                 WHERE     TC.TERM_CHANGE_ID = NVL (termChangeId_in, 0)
                       AND TC.CRSE_ID = C.CRSE_ID
                       AND TC.CRSE_ID = CS.CRSE_ID
                       AND TC.SESSION_CODE = CS.SESSION_CODE
                       AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID(+)) X;
               
      V_USE_CRSE_ID           VARCHAR2 (1);         

      temp_session_id         VARCHAR2 (10);
      sessionDetails_cursor   TERM_DATES_CURSOR;
   BEGIN
        IF NVL(crseSessionId_in,0) > 0 
       THEN
       IF courseChangeId_in > 0
       THEN
          OPEN sessionDetails_cursor FOR
             WITH c_course_changes
                 AS (SELECT CT.ACADEMIC_YEAR CRSE_YEAR_NO,
                            CT.TERM TERM_NO,
                            CT.TERM_START START_DATE,
                            CT.TERM_END END_DATE,
                            CT.TERM_END - CT.TERM_START + 1 DAYS,
                            NULL CRSE_YEAR_ID
                       FROM SLCADMIN.CURRENT_COURSE CUC,
                            SLCADMIN.CURRENT_TERM CT,
                            (SELECT NVL (CC.NEW_HEI_CRSE_CODE, CC.OLD_HEI_CRSE_CODE)
                                       HEI_CRSE_CODE,
                                    CC.SESSION_CODE
                               FROM SLCADMIN.COURSE_CHANGE CC
                              WHERE CC.COURSE_CHANGE_ID = courseChangeId_in --'871444'                     --'650839'
                                                                ) CC2
                      WHERE     CUC.HEI_CRSE_CODE = CC2.HEI_CRSE_CODE
                            AND CUC.HEI_CRSE_CODE = CT.HEI_CRSE_CODE
                            AND CUC.SESSION_CODE = CC2.SESSION_CODE
                            AND CUC.SESSION_CODE = CT.SESSION_CODE)
            SELECT ROWNUM,
                   Y.CRSE_YEAR_NO,
                   Y.TERM_NO,
                   NVL(Y.NEW_START_DATE,Y.START_DATE) START_DATE,
                   NVL(Y.NEW_END_DATE,Y.END_DATE) END_DATE,
                   NVL(Y.NEW_DAYS,Y.DAYS) DAYS,
                   Y.CRSE_YEAR_ID,
                   Y.START_DATE OLD_START_DATE,
                   Y.END_DATE OLD_END_DATE,
                   Y.DAYS OLD_DAYS,
                   CASE WHEN Y.CURRENT_TERM_NO IS NULL
                   THEN
                        'D'
                        ELSE
                        NULL
                   END CHANGE_TYPE
              FROM (  SELECT X.CRSE_YEAR_NO,
                             X.TERM_NO,
                             TO_CHAR (X.START_DATE, 'DD/MM/YYYY') START_DATE,
                             TO_CHAR (X.END_DATE, 'DD/MM/YYYY') END_DATE,
                             X.DAYS,
                             X.CRSE_YEAR_ID,
                             TO_CHAR(CCH.START_DATE, 'DD/MM/YYYY') NEW_START_DATE,
                             TO_CHAR(CCH.END_DATE, 'DD/MM/YYYY') NEW_END_DATE,
                             CCH.DAYS NEW_DAYS,
                             CCH.TERM_NO CURRENT_TERM_NO
                        FROM (SELECT CY.CRSE_YEAR_NO,
                                     CT.TERM_NO,
                                     CT.START_DATE,
                                     CT.END_DATE,
                                     CT.DAYS,
                                     CT.CRSE_YEAR_ID
                                FROM CRSE_TERM CT, CRSE_YEAR CY
                               WHERE     CT.CRSE_YEAR_ID = CY.CRSE_YEAR_ID
                                     AND CY.CRSE_SESSION_ID = crseSessionId_in
                                     AND CY.DEFAULT_TERMS = 'N'
                              UNION
                              SELECT CY.CRSE_YEAR_NO,
                                     IT.TERM_NO,
                                     IT.START_DATE,
                                     IT.END_DATE,
                                     IT.DAYS,
                                     -1 CRSE_YEAR_ID
                                FROM INST_TERM IT,
                                     CRSE_YEAR CY,
                                     CRSE_SESSION CS,
                                     CRSE C
                               WHERE     IT.SESSION_CODE = CS.SESSION_CODE
                                     AND CY.CRSE_SESSION_ID = crseSessionId_in
                                     AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
                                     AND C.CRSE_ID = CS.CRSE_ID
                                     AND C.INST_CODE = IT.INST_CODE
                                     AND CY.DEFAULT_TERMS = 'Y'
                              UNION
                              SELECT Z.CRSE_YEAR_NO,
                                     Z.TERM_NO,
                                     Z.START_DATE,
                                     Z.END_DATE,
                                     Z.DAYS,
                                     Z.CRSE_YEAR_ID
                                FROM c_course_changes Z
                               WHERE     NOT EXISTS
                                                (SELECT 1
                                                   FROM CRSE_TERM CT, CRSE_YEAR CY
                                                  WHERE     CT.CRSE_YEAR_ID =
                                                               CY.CRSE_YEAR_ID
                                                        AND CY.CRSE_SESSION_ID = crseSessionId_in
                                                        AND CY.DEFAULT_TERMS = 'N'
                                                        AND Z.CRSE_YEAR_NO =
                                                               CY.CRSE_YEAR_NO
                                                        AND Z.TERM_NO = CT.TERM_NO)
                                     AND NOT EXISTS
                                                (SELECT 1
                                                   FROM INST_TERM IT,
                                                        CRSE_YEAR CY,
                                                        CRSE_SESSION CS,
                                                        CRSE C
                                                  WHERE     IT.SESSION_CODE =
                                                               CS.SESSION_CODE
                                                        AND CY.CRSE_SESSION_ID = crseSessionId_in
                                                        AND CS.CRSE_SESSION_ID =
                                                               CY.CRSE_SESSION_ID
                                                        AND C.CRSE_ID = CS.CRSE_ID
                                                        AND C.INST_CODE = IT.INST_CODE
                                                        AND CY.DEFAULT_TERMS = 'Y'
                                                        AND Z.CRSE_YEAR_NO =
                                                               CY.CRSE_YEAR_NO
                                                        AND Z.TERM_NO = IT.TERM_NO)) X,
                             c_course_changes cch
                       WHERE     x.crse_year_no = cch.crse_year_no(+)
                             AND x.term_no = cch.term_no(+)
                    ORDER BY 1, 2, 3) Y;   
        ELSE
        
           OPEN C_CHECK_CRSE_ID;
           FETCH C_CHECK_CRSE_ID INTO V_USE_CRSE_ID;
           CLOSE C_CHECK_CRSE_ID;
           IF NVL(V_USE_CRSE_ID,'N') = 'Y'
           THEN
              OPEN sessionDetails_cursor FOR   
                 WITH c_course_changes
                     AS (SELECT TC1.ACADEMIC_YEAR CRSE_YEAR_NO,
                       TC1.TERM TERM_NO,
                       TC1.NEW_TERM_START START_DATE,
                       TC1.NEW_TERM_END END_DATE,
                       TC1.NEW_TERM_END - TC1.NEW_TERM_START + 1 DAYS,
                       NULL CRSE_YEAR_ID
                  FROM SLCADMIN.TERM_CHANGE TC1,
                       (SELECT TC.CRSE_ID, TC.SESSION_CODE
                          FROM SLCADMIN.TERM_CHANGE TC
                         WHERE TC.TERM_CHANGE_ID = termChangeId_in) TC2
                 WHERE     TC1.CRSE_ID = TC2.CRSE_ID
                       AND TC1.SESSION_CODE = TC2.SESSION_CODE
                       AND TC1.STATUS = 'NEW'
                       AND TC1.CHANGE_TYPE IN ('I', 'U')
                UNION ALL
                SELECT CY.CRSE_YEAR_NO CRSE_YEAR_NO,
                       CT.TERM_NO TERM_NO,
                       CT.START_DATE START_DATE,
                       CT.END_DATE END_DATE,
                       CT.END_DATE - CT.START_DATE + 1 DAYS,
                       CY.CRSE_YEAR_ID
                  FROM CRSE_YEAR CY,
                       CRSE_TERM CT,
                       (SELECT MAX (CASE
                                       WHEN     C2.SCHEME_TYPE = 'U'
                                            AND I2.LOCATION_IND IN (2,
                                                                    3,
                                                                    4,
                                                                    5)
                                       THEN
                                          'Y'
                                       ELSE
                                          'N'
                                    END)
                                  RUK
                          FROM CRSE_YEAR CY2, CRSE C2, INST I2
                         WHERE     CY2.CRSE_SESSION_ID = crseSessionId_in
                               AND CY2.CRSE_ID = C2.CRSE_ID
                               AND C2.INST_CODE = I2.INST_CODE) RUK_UG
                 WHERE     CY.CRSE_SESSION_ID = crseSessionId_in
                       AND CY.DEFAULT_TERMS = 'N'
                       AND CT.CRSE_YEAR_ID = CY.CRSE_YEAR_ID
                       AND (CY.CRSE_YEAR_NO, CT.TERM_NO) NOT IN (
                                                SELECT TC1.ACADEMIC_YEAR, TC1.TERM
                                                  FROM SLCADMIN.TERM_CHANGE TC1,
                                                       (SELECT TC.*
                                                          FROM SLCADMIN.TERM_CHANGE TC
                                                         WHERE TC.TERM_CHANGE_ID = NVL (termChangeId_in, 0)) TC2
                                                 WHERE     TC1.CRSE_ID = TC2.CRSE_ID
                                                       AND TC1.SESSION_CODE = TC2.SESSION_CODE
                                                       AND TC1.STATUS = 'NEW')
                UNION ALL
                SELECT CY.CRSE_YEAR_NO CRSE_YEAR_NO,
                       IT.TERM_NO TERM_NO,
                       IT.START_DATE START_DATE,
                       IT.END_DATE END_DATE,
                       IT.END_DATE - IT.START_DATE + 1 DAYS,
                       CY.CRSE_YEAR_ID
                FROM CRSE_YEAR CY,
                    CRSE_SESSION CS,
                    CRSE C,
                    INST_TERM IT,
                    (SELECT MAX (CASE
                                    WHEN     C2.SCHEME_TYPE = 'U'
                                         AND I2.LOCATION_IND IN (2,
                                                                 3,
                                                                 4,
                                                                 5)
                                    THEN
                                       'Y'
                                    ELSE
                                       'N'
                                 END)
                               RUK
                       FROM CRSE_YEAR CY2, CRSE C2, INST I2
                      WHERE     CY2.CRSE_SESSION_ID = crseSessionId_in
                            AND CY2.CRSE_ID = C2.CRSE_ID
                            AND C2.INST_CODE = I2.INST_CODE) RUK_UG
                WHERE     CY.CRSE_SESSION_ID = crseSessionId_in
                AND CY.CRSE_SESSION_ID = CS.CRSE_SESSION_ID
                AND CY.DEFAULT_TERMS = 'Y'
                AND CY.CRSE_ID = C.CRSE_ID
                AND C.INST_CODE = IT.INST_CODE
                AND CS.SESSION_CODE = IT.SESSION_CODE
                AND CY.CRSE_YEAR_NO NOT IN (
                                    SELECT TC1.ACADEMIC_YEAR
                                      FROM SLCADMIN.TERM_CHANGE TC1,
                                           (SELECT TC.*
                                              FROM SLCADMIN.TERM_CHANGE TC
                                             WHERE TC.TERM_CHANGE_ID = NVL (termChangeId_in, 0)) TC2
                                     WHERE     TC1.CRSE_ID = TC2.CRSE_ID
                                           AND TC1.SESSION_CODE = TC2.SESSION_CODE
                                           AND TC1.STATUS = 'NEW') )
                SELECT ROWNUM,
                       Y.CRSE_YEAR_NO,
                       Y.TERM_NO,
                       NVL(Y.NEW_START_DATE,Y.START_DATE) START_DATE,
                       NVL(Y.NEW_END_DATE,Y.END_DATE) END_DATE,
                       NVL(Y.NEW_DAYS,Y.DAYS) DAYS,
                       Y.CRSE_YEAR_ID,
                       Y.START_DATE OLD_START_DATE,
                       Y.END_DATE OLD_END_DATE,
                       Y.DAYS OLD_DAYS,
                       CASE WHEN Y.CURRENT_TERM_NO IS NULL
                       THEN
                            'D'
                            ELSE
                            NULL
                       END CHANGE_TYPE
                  FROM (  SELECT X.CRSE_YEAR_NO,
                                 X.TERM_NO,
                                 TO_CHAR (X.START_DATE, 'DD/MM/YYYY') START_DATE,
                                 TO_CHAR (X.END_DATE, 'DD/MM/YYYY') END_DATE,
                                 X.DAYS,
                                 X.CRSE_YEAR_ID,
                                 TO_CHAR(CCH.START_DATE, 'DD/MM/YYYY') NEW_START_DATE,
                                 TO_CHAR(CCH.END_DATE, 'DD/MM/YYYY') NEW_END_DATE,
                                 CCH.DAYS NEW_DAYS,
                                 CCH.TERM_NO CURRENT_TERM_NO
                            FROM (SELECT CY.CRSE_YEAR_NO,
                                         CT.TERM_NO,
                                         CT.START_DATE,
                                         CT.END_DATE,
                                         CT.DAYS,
                                         CT.CRSE_YEAR_ID
                                    FROM CRSE_TERM CT, CRSE_YEAR CY
                                   WHERE     CT.CRSE_YEAR_ID = CY.CRSE_YEAR_ID
                                         AND CY.CRSE_SESSION_ID = crseSessionId_in
                                         AND CY.DEFAULT_TERMS = 'N'
                                  UNION
                                  SELECT CY.CRSE_YEAR_NO,
                                         IT.TERM_NO,
                                         IT.START_DATE,
                                         IT.END_DATE,
                                         IT.DAYS,
                                         -1 CRSE_YEAR_ID
                                    FROM INST_TERM IT,
                                         CRSE_YEAR CY,
                                         CRSE_SESSION CS,
                                         CRSE C
                                   WHERE     IT.SESSION_CODE = CS.SESSION_CODE
                                         AND CY.CRSE_SESSION_ID = crseSessionId_in
                                         AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
                                         AND C.CRSE_ID = CS.CRSE_ID
                                         AND C.INST_CODE = IT.INST_CODE
                                         AND CY.DEFAULT_TERMS = 'Y'
                                  UNION
                                  SELECT Z.CRSE_YEAR_NO,
                                         Z.TERM_NO,
                                         Z.START_DATE,
                                         Z.END_DATE,
                                         Z.DAYS,
                                         Z.CRSE_YEAR_ID
                                    FROM c_course_changes Z
                                   WHERE     NOT EXISTS
                                                    (SELECT 1
                                                       FROM CRSE_TERM CT, CRSE_YEAR CY
                                                      WHERE     CT.CRSE_YEAR_ID =
                                                                   CY.CRSE_YEAR_ID
                                                            AND CY.CRSE_SESSION_ID = crseSessionId_in
                                                            AND CY.DEFAULT_TERMS = 'N'
                                                            AND Z.CRSE_YEAR_NO =
                                                                   CY.CRSE_YEAR_NO
                                                            AND Z.TERM_NO = CT.TERM_NO)
                                         AND NOT EXISTS
                                                    (SELECT 1
                                                       FROM INST_TERM IT,
                                                            CRSE_YEAR CY,
                                                            CRSE_SESSION CS,
                                                            CRSE C
                                                      WHERE     IT.SESSION_CODE =
                                                                   CS.SESSION_CODE
                                                            AND CY.CRSE_SESSION_ID = crseSessionId_in
                                                            AND CS.CRSE_SESSION_ID =
                                                                   CY.CRSE_SESSION_ID
                                                            AND C.CRSE_ID = CS.CRSE_ID
                                                            AND C.INST_CODE = IT.INST_CODE
                                                            AND CY.DEFAULT_TERMS = 'Y'
                                                            AND Z.CRSE_YEAR_NO =
                                                                   CY.CRSE_YEAR_NO
                                                            AND Z.TERM_NO = IT.TERM_NO)) X,
                                 c_course_changes cch
                           WHERE     x.crse_year_no = cch.crse_year_no(+)
                                 AND x.term_no = cch.term_no(+)
                        ORDER BY 1, 2, 3) Y;                
           ELSE

           OPEN sessionDetails_cursor FOR
             WITH c_course_changes
                 AS (SELECT CT.ACADEMIC_YEAR CRSE_YEAR_NO,
                            CT.TERM TERM_NO,
                            CT.TERM_START START_DATE,
                            CT.TERM_END END_DATE,
                            CT.TERM_END - CT.TERM_START + 1 DAYS,
                            NULL CRSE_YEAR_ID
                       FROM SLCADMIN.CURRENT_COURSE CUC,
                            SLCADMIN.CURRENT_TERM CT,
                            (SELECT TC.HEI_CRSE_CODE,
                                    TC.SESSION_CODE
                               FROM SLCADMIN.TERM_CHANGE TC
                              WHERE TC.TERM_CHANGE_ID = termChangeId_in --'871444'                     --'650839'
                                                                ) CC2
                      WHERE     CUC.HEI_CRSE_CODE = CC2.HEI_CRSE_CODE
                            AND CUC.HEI_CRSE_CODE = CT.HEI_CRSE_CODE
                            AND CUC.SESSION_CODE = CC2.SESSION_CODE
                            AND CUC.SESSION_CODE = CT.SESSION_CODE)
            SELECT ROWNUM,
                   Y.CRSE_YEAR_NO,
                   Y.TERM_NO,
                   NVL(Y.NEW_START_DATE,Y.START_DATE) START_DATE,
                   NVL(Y.NEW_END_DATE,Y.END_DATE) END_DATE,
                   NVL(Y.NEW_DAYS,Y.DAYS) DAYS,
                   Y.CRSE_YEAR_ID,
                   Y.START_DATE OLD_START_DATE,
                   Y.END_DATE OLD_END_DATE,
                   Y.DAYS OLD_DAYS,
                   CASE WHEN Y.CURRENT_TERM_NO IS NULL
                   THEN
                        'D'
                        ELSE
                        NULL
                   END CHANGE_TYPE
              FROM (  SELECT X.CRSE_YEAR_NO,
                             X.TERM_NO,
                             TO_CHAR (X.START_DATE, 'DD/MM/YYYY') START_DATE,
                             TO_CHAR (X.END_DATE, 'DD/MM/YYYY') END_DATE,
                             X.DAYS,
                             X.CRSE_YEAR_ID,
                             TO_CHAR(CCH.START_DATE, 'DD/MM/YYYY') NEW_START_DATE,
                             TO_CHAR(CCH.END_DATE, 'DD/MM/YYYY') NEW_END_DATE,
                             CCH.DAYS NEW_DAYS,
                             CCH.TERM_NO CURRENT_TERM_NO
                        FROM (SELECT CY.CRSE_YEAR_NO,
                                     CT.TERM_NO,
                                     CT.START_DATE,
                                     CT.END_DATE,
                                     CT.DAYS,
                                     CT.CRSE_YEAR_ID
                                FROM CRSE_TERM CT, CRSE_YEAR CY
                               WHERE     CT.CRSE_YEAR_ID = CY.CRSE_YEAR_ID
                                     AND CY.CRSE_SESSION_ID = crseSessionId_in
                                     AND CY.DEFAULT_TERMS = 'N'
                              UNION
                              SELECT CY.CRSE_YEAR_NO,
                                     IT.TERM_NO,
                                     IT.START_DATE,
                                     IT.END_DATE,
                                     IT.DAYS,
                                     -1 CRSE_YEAR_ID
                                FROM INST_TERM IT,
                                     CRSE_YEAR CY,
                                     CRSE_SESSION CS,
                                     CRSE C
                               WHERE     IT.SESSION_CODE = CS.SESSION_CODE
                                     AND CY.CRSE_SESSION_ID = crseSessionId_in
                                     AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
                                     AND C.CRSE_ID = CS.CRSE_ID
                                     AND C.INST_CODE = IT.INST_CODE
                                     AND CY.DEFAULT_TERMS = 'Y'
                              UNION
                              SELECT Z.CRSE_YEAR_NO,
                                     Z.TERM_NO,
                                     Z.START_DATE,
                                     Z.END_DATE,
                                     Z.DAYS,
                                     Z.CRSE_YEAR_ID
                                FROM c_course_changes Z
                               WHERE     NOT EXISTS
                                                (SELECT 1
                                                   FROM CRSE_TERM CT, CRSE_YEAR CY
                                                  WHERE     CT.CRSE_YEAR_ID =
                                                               CY.CRSE_YEAR_ID
                                                        AND CY.CRSE_SESSION_ID = crseSessionId_in
                                                        AND CY.DEFAULT_TERMS = 'N'
                                                        AND Z.CRSE_YEAR_NO =
                                                               CY.CRSE_YEAR_NO
                                                        AND Z.TERM_NO = CT.TERM_NO)
                                     AND NOT EXISTS
                                                (SELECT 1
                                                   FROM INST_TERM IT,
                                                        CRSE_YEAR CY,
                                                        CRSE_SESSION CS,
                                                        CRSE C
                                                  WHERE     IT.SESSION_CODE =
                                                               CS.SESSION_CODE
                                                        AND CY.CRSE_SESSION_ID = crseSessionId_in
                                                        AND CS.CRSE_SESSION_ID =
                                                               CY.CRSE_SESSION_ID
                                                        AND C.CRSE_ID = CS.CRSE_ID
                                                        AND C.INST_CODE = IT.INST_CODE
                                                        AND CY.DEFAULT_TERMS = 'Y'
                                                        AND Z.CRSE_YEAR_NO =
                                                               CY.CRSE_YEAR_NO
                                                        AND Z.TERM_NO = IT.TERM_NO)) X,
                             c_course_changes cch
                       WHERE     x.crse_year_no = cch.crse_year_no(+)
                             AND x.term_no = cch.term_no(+)
                    ORDER BY 1, 2, 3) Y;  
           END IF;                 
        END IF;   
       ELSIF courseChangeId_in > 0
       THEN
          
          OPEN sessionDetails_cursor FOR
                 SELECT ROWNUM,
                         Y.CRSE_YEAR_NO,
                         Y.TERM_NO,
                         Y.START_DATE,
                         Y.END_DATE,
                         Y.DAYS,
                         Y.CRSE_YEAR_ID,
                         NULL OLD_START_DATE,
                         NULL OLD_END_DATE,
                         NULL OLD_DAYS
                         FROM (SELECT 
                         CT.ACADEMIC_YEAR CRSE_YEAR_NO,
                         CT.TERM TERM_NO,
                         TO_CHAR(CT.TERM_START,'DD/MM/YYYY') START_DATE,
                         TO_CHAR(CT.TERM_END,'DD/MM/YYYY') END_DATE,
                         CT.TERM_END - CT.TERM_START + 1 DAYS,
                         NULL CRSE_YEAR_ID
                    FROM SLCADMIN.CURRENT_COURSE CUC,
                         SLCADMIN.CURRENT_TERM CT,
                         (SELECT NVL (CC.NEW_HEI_CRSE_CODE, CC.OLD_HEI_CRSE_CODE) HEI_CRSE_CODE,
                                 CC.SESSION_CODE
                            FROM SLCADMIN.COURSE_CHANGE CC
                           WHERE CC.COURSE_CHANGE_ID = courseChangeId_in --'871444'                     --'650839'
                                                               ) CC2
                   WHERE     CUC.HEI_CRSE_CODE = CC2.HEI_CRSE_CODE
                         AND CUC.HEI_CRSE_CODE = CT.HEI_CRSE_CODE
                         AND CUC.SESSION_CODE = CC2.SESSION_CODE
                         AND CUC.SESSION_CODE = CT.SESSION_CODE
                ORDER BY  1, 2, 3) Y;
       ELSIF termChangeId_in > 0
       THEN
          NULL;
       ELSE
          error_boolean := 'true';
          ERROR_TEXT := 'crse_id, courseChangeId and termchangeid are not set';
       END IF;

      io_cursor := sessionDetails_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getCourseTerms;
   
   PROCEDURE getInstTerms (
       instCode_in          IN            VARCHAR2,
       sessionCode_in       IN            VARCHAR2,
      io_cursor             IN OUT        TERM_DATES_CURSOR,
      error_boolean       OUT NOCOPY VARCHAR2,
      ERROR_TEXT          OUT NOCOPY VARCHAR2)
   IS
      temp_session_id         VARCHAR2 (10);
      instTerms_cursor   TERM_DATES_CURSOR;
   BEGIN
 
      OPEN instTerms_cursor FOR
          SELECT ROWNUM, X.*
            FROM (SELECT ITC.INST_CODE,
                   ITC.SESSION_CODE,
                   ITC.TERM_NO,
                   TO_CHAR(ITC.NEW_START_DATE,'DD/MM/YYYY') NEW_START_DATE,
                   TO_CHAR(ITC.NEW_END_DATE,'DD/MM/YYYY') NEW_END_DATE,
                   ITC.NEW_DAYS,
                   TO_CHAR(IT.START_DATE,'DD/MM/YYYY') OLD_START_DATE,
                   TO_CHAR(IT.END_DATE,'DD/MM/YYYY') OLD_END_DATE,
                   IT.DAYS OLD_DAYS,
                   CASE
                      WHEN ITC.CHANGE_TYPE = 'I' AND IT.INST_CODE IS NOT NULL
                      -- if the term exists, then change type is U for Update
                      THEN
                         'U'
                      WHEN ITC.CHANGE_TYPE = 'U' AND IT.INST_CODE IS NULL
                      -- if the term does not exists, then change type is I for Insert
                      THEN
                         'I'
                      ELSE
                         ITC.CHANGE_TYPE
                   END CHANGE_TYPE
              FROM SLCADMIN.INST_TERM_CHANGE ITC, INST_TERM IT
             WHERE     ITC.INST_CODE = instCode_in
                   AND ITC.SESSION_CODE = sessionCode_in
                   AND ITC.STATUS = 'NEW'
                   AND ITC.CHANGE_TYPE != 'D'
                   AND ITC.INST_CODE = IT.INST_CODE(+)
                   AND ITC.SESSION_CODE = IT.SESSION_CODE(+)
                   AND ITC.TERM_NO = IT.TERM_NO(+)
            UNION ALL
            SELECT IT.INST_CODE,
                   IT.SESSION_CODE,
                   IT.TERM_NO,
                   TO_CHAR(IT.START_DATE,'DD/MM/YYYY') NEW_START_DATE,
                   TO_CHAR(IT.END_DATE,'DD/MM/YYYY') NEW_END_DATE,
                   IT.DAYS NEW_DAYS,
                   NULL OLD_START_DATE,
                   NULL OLD_END_DATE,
                   NULL OLD_DAYS,
                   ITC.CHANGE_TYPE CHANGE_TYPE
              FROM INST_TERM IT, SLCADMIN.INST_TERM_CHANGE ITC
             WHERE     IT.INST_CODE = instCode_in
                   AND IT.SESSION_CODE = sessionCode_in
                   AND IT.INST_CODE = ITC.INST_CODE
                   AND IT.SESSION_CODE = ITC.SESSION_CODE
                   AND IT.TERM_NO = ITC.TERM_NO
                   AND 'D' = ITC.CHANGE_TYPE
                   AND 'NEW' = ITC.STATUS
            UNION ALL
            SELECT IT.INST_CODE,
                   IT.SESSION_CODE,
                   IT.TERM_NO,
                   TO_CHAR(IT.START_DATE,'DD/MM/YYYY') NEW_START_DATE,
                   TO_CHAR(IT.END_DATE,'DD/MM/YYYY') NEW_END_DATE,
                   IT.DAYS NEW_DAYS,
                   TO_CHAR(IT.START_DATE,'DD/MM/YYYY') OLD_START_DATE,
                   TO_CHAR(IT.END_DATE,'DD/MM/YYYY') OLD_END_DATE,
                   IT.DAYS OLD_DAYS,
                   NULL CHANGE_TYPE
              FROM INST_TERM IT
             WHERE     IT.INST_CODE = instCode_in
                   AND IT.SESSION_CODE = sessionCode_in
                   AND NOT EXISTS (SELECT 1 
                   FROM SLCADMIN.INST_TERM_CHANGE ITC
                   WHERE IT.INST_CODE = ITC.INST_CODE(+)
                   AND IT.SESSION_CODE = ITC.SESSION_CODE(+)
                   AND IT.TERM_NO = ITC.TERM_NO(+)
                   AND 'NEW' = ITC.STATUS(+))
            ORDER BY 1,
                     2,
                     3,
                     4) X;
 

      io_cursor := instTerms_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getInstTerms;   
   
       PROCEDURE updateCourseDetails (
       user_id_in             IN            VARCHAR2,
       inst_code_in             IN            VARCHAR2,
       inst_name_in             IN            VARCHAR2,
       crse_code_in             IN            VARCHAR2,
       crse_name_in             IN            VARCHAR2,
       slc_course_name_in       IN            VARCHAR2,
       hei_crse_code_in         IN            VARCHAR2,
       scheme_type_in           IN            VARCHAR2,
       subject_cat_id_in        IN            VARCHAR2,
       subject_description_in   IN            VARCHAR2,
       qual_type_in             IN            VARCHAR2,
       fees_campus_in           IN            VARCHAR2,
       fees_campus_name_in      IN            VARCHAR2,
       maint_campus_in          IN            VARCHAR2,
       maint_campus_name_in     IN            VARCHAR2,
       pams_course_in           IN            VARCHAR2,
       ga_student_in            IN            VARCHAR2,
       approved_in              IN            VARCHAR2,
       max_duration_in          IN            VARCHAR2,
       old_max_duration_in      IN            VARCHAR2,
       session_code_in          IN            VARCHAR2,
       crse_session_id_in       IN            VARCHAR2,
       student_list_in          IN            VARCHAR2,
       ruk_in                   IN            VARCHAR2,
       crse_id_in               IN            VARCHAR2,
       crse_id_out               OUT NOCOPY VARCHAR2,
       crse_session_id_out       OUT NOCOPY VARCHAR2,
       error_boolean             OUT NOCOPY VARCHAR2,
       ERROR_TEXT                OUT NOCOPY VARCHAR2)
       IS
        V_CRSE_ID NUMBER(9);
        V_CRSE_SESSION_ID NUMBER(9);
       BEGIN

        IF crse_id_in IS NOT NULL
        THEN -- DO THE UPDATE
            UPDATE CRSE C
               SET 
--                   C.INST_CODE = inst_code_in,
--                   C.INST_NAME = inst_name_in,
--                   C.CRSE_CODE = crse_code_in,
                   C.CRSE_NAME = crse_name_in,
                   C.HEI_CRSE_CODE = hei_crse_code_in,
                   C.SCHEME_TYPE = scheme_type_in,
                   --subject_cat_id_in,
                   --subject_description_in,
                   C.QUAL_TYPE = qual_type_in,
                   C.FEES_CAMPUS = fees_campus_in,
                   --fees_campus_name_in,
                   C.MAINT_CAMPUS = maint_campus_in,
                   --maint_campus_name_in,
                   C.PAMS_COURSE = pams_course_in,
                   C.GRADUATE_APPRENTICE = ga_student_in,
                   C.LAST_UPDATED_BY = user_id_in
                   --C.APPROVED = approved_in
             WHERE C.CRSE_ID = crse_id_in;
             crse_id_out := crse_id_in;
         ELSE -- DO THE INSERT
            SELECT CRS_CRSE_ID_SEQ.NEXTVAL INTO V_CRSE_ID FROM DUAL;
            crse_id_out := V_CRSE_ID;
            INSERT INTO CRSE C (C.APPROVED, C.CRSE_CODE, C.CRSE_ID, C.CRSE_NAME, C.FEES_CAMPUS, C.HEI_CRSE_CODE, C.INST_CODE, C.INST_NAME, C.MAINT_CAMPUS, C.PAMS_COURSE, C.GRADUATE_APPRENTICE, C.QUAL_TYPE, C.SCHEME_TYPE, C.DEPARTMENT, C.SUBJECT_CAT_ID ,C.SKELETON, C.GE_LIABLE, C.LAST_UPDATED_BY   )
            VALUES ('Y', crse_code_in, V_CRSE_ID, crse_name_in, fees_campus_in, hei_crse_code_in, inst_code_in, inst_name_in, maint_campus_in, pams_course_in, ga_student_in, qual_type_in, scheme_type_in, '',148, 'N', 'N', user_id_in);
         END IF;
        
        IF NVL(crse_session_id_in,0) > 0
        THEN
            UPDATE CRSE_SESSION CS
            SET CS.MAX_DURATION = max_duration_in,
                   CS.LAST_UPDATED_BY = user_id_in
            WHERE CS.CRSE_SESSION_ID = crse_session_id_in;
            crse_session_id_out := crse_session_id_in;
        ELSE
            SELECT CRSS_CRSE_SESSION_ID_SEQ.NEXTVAL INTO V_CRSE_SESSION_ID FROM DUAL;
            INSERT INTO CRSE_SESSION CS (CS.CRSE_SESSION_ID, CS.CRSE_ID, CS.SESSION_CODE, CS.MAX_DURATION, CS.PSAS_BID_NON_QUOTA, CS.LAST_UPDATED_BY)
            VALUES (V_CRSE_SESSION_ID, crse_id_out, session_code_in, max_duration_in, 'N', user_id_in);
            crse_session_id_out :=  V_CRSE_SESSION_ID;
            
        END IF;
         
       EXCEPTION
          WHEN OTHERS
          THEN
             error_boolean := 'true';
             ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
       END updateCourseDetails;
       
    PROCEDURE updateSessionDetails (user_id_in           IN            VARCHAR2,
                                    crse_year_no_in      IN            VARCHAR2,
                                    study_abroad_in      IN            VARCHAR2,
                                    var_amount_in        IN            VARCHAR2,
                                    sandwich_amount_in   IN            VARCHAR2,
                                    cutoff_type_in       IN            VARCHAR2,
                                    cutoff_date_in       IN            VARCHAR2,
                                    default_terms_in     IN            VARCHAR2,
                                    eu_flag_in           IN            VARCHAR2,
                                    hei_crse_code_in     IN            VARCHAR2,
                                    crse_year_id_in      IN            VARCHAR2,
                                    inst_code_in         IN            VARCHAR2,
                                    session_code_in      IN            VARCHAR2,
                                    crse_id_in           IN            VARCHAR2,
                                    crse_session_id_in   IN            VARCHAR2,
                                    delete_flag_in       IN            VARCHAR2,
                                    crse_year_id_out        OUT NOCOPY VARCHAR2,
                                    error_boolean           OUT NOCOPY VARCHAR2,
                                    ERROR_TEXT              OUT NOCOPY VARCHAR2)
      IS
        V_CRSE_YEAR_ID NUMBER(9);
        CURSOR C_SCHEME
        IS
        SELECT C.SCHEME_TYPE FROM CRSE C WHERE C.CRSE_ID = crse_id_in;
        V_SCHEME_TYPE VARCHAR2(1);
       BEGIN

        IF NVL(delete_flag_in,'N') = 'Y'
        THEN -- DO THE DELETE
            UPDATE CRSE_TERM CT
            SET CT.LAST_UPDATED_BY = user_id_in
            WHERE CT.CRSE_YEAR_ID = crse_year_id_in;
            UPDATE CRSE_YEAR CY
            SET CY.LAST_UPDATED_BY = user_id_in
            WHERE CY.CRSE_YEAR_ID = crse_year_id_in;
            DELETE FROM CRSE_TERM CT
            WHERE CT.CRSE_YEAR_ID = crse_year_id_in;
            DELETE FROM CRSE_YEAR CY
            WHERE CY.CRSE_YEAR_ID = crse_year_id_in;
            
       ELSE -- DO THE MERGE
            OPEN C_SCHEME;
            FETCH C_SCHEME INTO V_SCHEME_TYPE;
            CLOSE C_SCHEME;
           IF crse_year_id_in IS NOT NULL
           THEN -- DO THE UPDATE
                UPDATE CRSE_YEAR CY
                SET  CY.CRSE_YEAR_NO = crse_year_no_in, 

                     CY.CUTOFF_DATE = CASE 
                                        WHEN V_SCHEME_TYPE = 'U' THEN TO_DATE (cutoff_date_in,'DD/MM/YYYY') 
                                        WHEN V_SCHEME_TYPE = 'B' AND SESSION_CODE_IN >= 2021 THEN TO_DATE (cutoff_date_in,'DD/MM/YYYY') 
                                        ELSE CY.CUTOFF_DATE END, 
                     CY.CUTOFF_ITEM_NAME = CASE 
                                            WHEN V_SCHEME_TYPE = 'U' THEN 'FEES_CUTOFF_'||cutoff_type_in||'_'||session_code_in 
                                            WHEN V_SCHEME_TYPE = 'B' AND SESSION_CODE_IN >= 2021 THEN 'FEES_CUTOFF_'||cutoff_type_in||'_'||session_code_in 

                                            ELSE CY.CUTOFF_ITEM_NAME END, 
                     CY.CUTOFF_TYPE = CASE 
                                        WHEN V_SCHEME_TYPE = 'U' THEN cutoff_type_in 
                                        WHEN V_SCHEME_TYPE = 'B' AND SESSION_CODE_IN >= 2021 THEN cutoff_type_in 
                                        ELSE CY.CUTOFF_TYPE END, 
                     CY.DEFAULT_TERMS = default_terms_in, 
                     CY.EU_FLAG = eu_flag_in, 
                     CY.HEI_CRSE_CODE = hei_crse_code_in, 
                     CY.INST_CODE = inst_code_in, 
       --              CY.STUDY_ABROAD = study_abroad_in, 
                     CY.VAR_SANDWICH_TUITION_FEE_AMNT =sandwich_amount_in, 
                     CY.VAR_TUITION_FEE_AMNT = var_amount_in,
                     CY.LAST_UPDATED_BY = user_id_in
                WHERE CY.CRSE_YEAR_ID = crse_year_id_in;
                crse_year_id_out := crse_year_id_in;
                
           ELSE -- DO THE INSERT
           SELECT CRSY_CRSE_YEAR_ID_SEQ.nextval into V_CRSE_YEAR_ID FROM DUAL;
                INSERT INTO CRSE_YEAR CY (CY.CRSE_ID, CY.CRSE_SESSION_ID, CY.CRSE_YEAR_ID, CY.CRSE_YEAR_NO, CY.CUTOFF_DATE, CY.CUTOFF_ITEM_NAME, CY.CUTOFF_TYPE, CY.DEFAULT_TERMS, CY.EU_FLAG, CY.HEI_CRSE_CODE, CY.INST_CODE, CY.STUDY_ABROAD, CY.VAR_SANDWICH_TUITION_FEE_AMNT, CY.VAR_TUITION_FEE_AMNT, CY.LAST_UPDATED_BY)

                VALUES  (crse_id_in, crse_session_id_in, V_CRSE_YEAR_ID, crse_year_no_in, 
                            CASE 
                                WHEN V_SCHEME_TYPE = 'U' THEN TO_DATE (cutoff_date_in,'DD/MM/YYYY') 
                                WHEN V_SCHEME_TYPE = 'B' AND SESSION_CODE_IN >= 2021 THEN TO_DATE (cutoff_date_in,'DD/MM/YYYY') 
                                ELSE NULL END, 
                            CASE 
                                WHEN V_SCHEME_TYPE = 'U' THEN 'FEES_CUTOFF_'||cutoff_type_in||'_'||session_code_in 
                                WHEN V_SCHEME_TYPE = 'B' AND SESSION_CODE_IN >= 2021 THEN 'FEES_CUTOFF_'||cutoff_type_in||'_'||session_code_in 
                                ELSE NULL END, 
                            CASE 
                                WHEN V_SCHEME_TYPE = 'U' THEN cutoff_type_in 
                                WHEN V_SCHEME_TYPE = 'B' AND SESSION_CODE_IN >= 2021 THEN cutoff_type_in 
                                ELSE NULL END, 
                        default_terms_in, eu_flag_in, hei_crse_code_in, inst_code_in, 'N', sandwich_amount_in, var_amount_in, user_id_in);
                crse_year_id_out := V_CRSE_YEAR_ID;
           END IF;
       END IF;          
       EXCEPTION
          WHEN OTHERS
          THEN
             error_boolean := 'true';
             ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
       END updateSessionDetails;                                           

    PROCEDURE updateCourseTerms (user_id_in        IN            VARCHAR2,
                                 crse_year_id_in   IN            VARCHAR2,
                                 term_no_in        IN            VARCHAR2,
                                 days_in           IN            VARCHAR2,
                                 start_date_in     IN            VARCHAR2,
                                 end_date_in       IN            VARCHAR2,
                                 delete_flag_in    IN            VARCHAR2,
                                 crse_session_id_in   IN         VARCHAR2,
                                 year_no_in           IN         VARCHAR2,
                                 error_boolean        OUT NOCOPY VARCHAR2,
                                 ERROR_TEXT           OUT NOCOPY VARCHAR2)
       IS
         V_CRSE_YEAR_ID  NUMBER(9);
       BEGIN

        IF NVL(delete_flag_in,'N') = 'Y'
        THEN -- DO THE DELETE
            UPDATE CRSE_TERM CT
            SET CT.LAST_UPDATED_BY = user_id_in
            WHERE CT.CRSE_YEAR_ID = crse_year_id_in
            AND CT.TERM_NO = term_no_in;

            DELETE FROM CRSE_TERM CT
            WHERE CT.CRSE_YEAR_ID = crse_year_id_in
            AND CT.TERM_NO = term_no_in;
            
       ELSE -- DO THE MERGE
        IF NVL(year_no_in,0) > 0
        THEN
           IF NVL(crse_year_id_in,0) < 1
           THEN
            SELECT CY.CRSE_YEAR_ID INTO V_CRSE_YEAR_ID  FROM CRSE_YEAR CY WHERE CY.CRSE_SESSION_ID = crse_session_id_in AND CY.CRSE_YEAR_NO = year_no_in;
           ELSE
            V_CRSE_YEAR_ID := crse_year_id_in;
           END IF;
           MERGE INTO CRSE_TERM CT
            USING (SELECT V_CRSE_YEAR_ID CRSE_YEAR_ID, 
                          term_no_in TERM_NO, 
                          NVL(days_in, TO_DATE(end_date_in,'DD/MM/YYYY') - TO_DATE(start_date_in,'DD/MM/YYYY') + 1) DAYS,
                          TO_DATE(start_date_in,'DD/MM/YYYY') START_DATE, 
                          TO_DATE(end_date_in,'DD/MM/YYYY') END_DATE 
                    FROM DUAL ) S
            ON (CT.CRSE_YEAR_ID = S.CRSE_YEAR_ID AND CT.TERM_NO = S.TERM_NO)
            WHEN MATCHED THEN
                UPDATE SET CT.START_DATE = S.START_DATE,
                           CT.END_DATE = S.END_DATE,
                           CT.DAYS = S.DAYS,
                           CT.LAST_UPDATED_BY = user_id_in
            WHEN NOT MATCHED THEN
            INSERT (CRSE_YEAR_ID, TERM_NO, DAYS, START_DATE, END_DATE, LAST_UPDATED_BY)
            VALUES (S.CRSE_YEAR_ID, S.TERM_NO, S.DAYS, S.START_DATE, S.END_DATE, user_id_in);
            
            UPDATE CRSE_YEAR CY SET CY.DEFAULT_TERMS = 'N' ,CY.LAST_UPDATED_BY = user_id_in
            WHERE CY.CRSE_YEAR_ID = V_CRSE_YEAR_ID;
        END IF;
       END IF;
                 
       EXCEPTION
          WHEN OTHERS
          THEN
             error_boolean := 'true';
             ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
       END updateCourseTerms; 
       
    PROCEDURE updateInstTerms (user_id_in           IN            VARCHAR2,
                                inst_code_in      IN            VARCHAR2,
                                session_code_in      IN            VARCHAR2,
                                term_no_in           IN            VARCHAR2,
                                days_in              IN            VARCHAR2,
                                start_date_in        IN            VARCHAR2,
                                end_date_in          IN            VARCHAR2,
                                delete_flag_in       IN            VARCHAR2,
                                error_boolean           OUT NOCOPY VARCHAR2,
                                ERROR_TEXT              OUT NOCOPY VARCHAR2)
       IS

       BEGIN

        IF NVL(delete_flag_in,'N') = 'Y'
        THEN -- DO THE DELETE
            UPDATE INST_TERM IT
            SET IT.LAST_UPDATED_BY = user_id_in
            WHERE IT.INST_CODE = inst_code_in
            AND it.session_code = session_code_in
            and it.term_no = term_no_in;
            DELETE FROM INST_TERM IT
            WHERE IT.INST_CODE = inst_code_in
            AND it.session_code = session_code_in
            and it.term_no = term_no_in;
            
       ELSE -- DO THE MERGE

           MERGE INTO INST_TERM IT
            USING (SELECT inst_code_in INST_CODE, 
                          session_code_in SESSION_CODE,
                          term_no_in TERM_NO, 
                          NVL(days_in, TO_DATE(end_date_in,'DD/MM/YYYY') - TO_DATE(start_date_in,'DD/MM/YYYY') + 1) DAYS,
                          TO_DATE(start_date_in,'DD/MM/YYYY') START_DATE, 
                          TO_DATE(end_date_in,'DD/MM/YYYY') END_DATE 
                    FROM DUAL ) S
            ON (IT.INST_CODE = S.INST_CODE AND IT.SESSION_CODE = S.SESSION_CODE AND IT.TERM_NO = S.TERM_NO)
            WHEN MATCHED THEN
                UPDATE SET IT.START_DATE = S.START_DATE,
                           IT.END_DATE = S.END_DATE,
                           IT.DAYS = S.DAYS,
                           IT.LAST_UPDATED_BY = user_id_in
            WHEN NOT MATCHED THEN
            INSERT (INST_CODE, SESSION_CODE, TERM_NO, DAYS, START_DATE, END_DATE, LAST_UPDATED_BY)
            VALUES (S.INST_CODE, S.SESSION_CODE, S.TERM_NO, S.DAYS, S.START_DATE, S.END_DATE, user_id_in);
            
       
       END IF;
                 
       EXCEPTION
          WHEN OTHERS
          THEN
             error_boolean := 'true';
             ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
       END updateInstTerms;  
                                                        
   
   PROCEDURE rejectCourseChanges (
      change_id1_in         IN            NUMBER,
      change_id2_in         IN            NUMBER,
      change_id3_in         IN            NUMBER,
      change_id4_in         IN            NUMBER,
      change_id5_in         IN            NUMBER,
      change_id6_in         IN            NUMBER,
      change_id7_in         IN            NUMBER,
      change_id8_in         IN            NUMBER,
      change_id9_in         IN            NUMBER,
      change_id10_in         IN            NUMBER,
      change_id11_in         IN            NUMBER,
      change_id12_in         IN            NUMBER,
      change_id13_in         IN            NUMBER,
      change_id14_in         IN            NUMBER,
      change_id15_in         IN            NUMBER,
      change_id16_in         IN            NUMBER,
      change_id17_in         IN            NUMBER,
      change_id18_in         IN            NUMBER,
      change_id19_in         IN            NUMBER,
      change_id20_in         IN            NUMBER,
      change_id21_in         IN            NUMBER,
      change_id22_in         IN            NUMBER,
      change_id23_in         IN            NUMBER,
      change_id24_in         IN            NUMBER,
      change_id25_in         IN            NUMBER,
      change_id26_in         IN            NUMBER,
      change_id27_in         IN            NUMBER,
      change_id28_in         IN            NUMBER,
      change_id29_in         IN            NUMBER,
      change_id30_in         IN            NUMBER,
      change_id31_in         IN            NUMBER,
      change_id32_in         IN            NUMBER,
      change_id33_in         IN            NUMBER,
      change_id34_in         IN            NUMBER,
      change_id35_in         IN            NUMBER,
      change_id36_in         IN            NUMBER,
      change_id37_in         IN            NUMBER,
      change_id38_in         IN            NUMBER,
      change_id39_in         IN            NUMBER,
      change_id40_in         IN            NUMBER,
      change_id41_in         IN            NUMBER,
      change_id42_in         IN            NUMBER,
      change_id43_in         IN            NUMBER,
      change_id44_in         IN            NUMBER,
      change_id45_in         IN            NUMBER,
      change_id46_in         IN            NUMBER,
      change_id47_in         IN            NUMBER,
      change_id48_in         IN            NUMBER,
      change_id49_in         IN            NUMBER,
      change_id50_in         IN            NUMBER,
      user_in            IN VARCHAR2,
      error_boolean         OUT NOCOPY VARCHAR2,
      ERROR_TEXT            OUT NOCOPY VARCHAR2)
   IS
    v_changes CHANGES;
   BEGIN
    v_changes := CHANGES();
    v_changes.EXTEND(50);
    v_changes(1) := NVL(change_id1_in,0);
    v_changes(2) := NVL(change_id2_in,0);
    v_changes(3) := NVL(change_id3_in,0);
    v_changes(4) := NVL(change_id4_in,0);
    v_changes(5) := NVL(change_id5_in,0);
    v_changes(6) := NVL(change_id6_in,0);
    v_changes(7) := NVL(change_id7_in,0);
    v_changes(8) := NVL(change_id8_in,0);
    v_changes(9) := NVL(change_id9_in,0);
    v_changes(10) := NVL(change_id10_in,0);
    v_changes(11) := NVL(change_id11_in,0);
    v_changes(12) := NVL(change_id12_in,0);
    v_changes(13) := NVL(change_id13_in,0);
    v_changes(14) := NVL(change_id14_in,0);
    v_changes(15) := NVL(change_id15_in,0);
    v_changes(16) := NVL(change_id16_in,0);
    v_changes(17) := NVL(change_id17_in,0);
    v_changes(18) := NVL(change_id18_in,0);
    v_changes(19) := NVL(change_id19_in,0);
    v_changes(20) := NVL(change_id20_in,0);

    v_changes(21) := NVL(change_id21_in,0);
    v_changes(22) := NVL(change_id22_in,0);
    v_changes(23) := NVL(change_id23_in,0);
    v_changes(24) := NVL(change_id24_in,0);
    v_changes(25) := NVL(change_id25_in,0);
    v_changes(26) := NVL(change_id26_in,0);
    v_changes(27) := NVL(change_id27_in,0);
    v_changes(28) := NVL(change_id28_in,0);
    v_changes(29) := NVL(change_id29_in,0);
    v_changes(30) := NVL(change_id30_in,0);
    
    v_changes(31) := NVL(change_id31_in,0);
    v_changes(32) := NVL(change_id32_in,0);
    v_changes(33) := NVL(change_id33_in,0);
    v_changes(34) := NVL(change_id34_in,0);
    v_changes(35) := NVL(change_id35_in,0);
    v_changes(36) := NVL(change_id36_in,0);
    v_changes(37) := NVL(change_id37_in,0);
    v_changes(38) := NVL(change_id38_in,0);
    v_changes(39) := NVL(change_id39_in,0);
    v_changes(40) := NVL(change_id40_in,0);

    v_changes(41) := NVL(change_id41_in,0);
    v_changes(42) := NVL(change_id42_in,0);
    v_changes(43) := NVL(change_id43_in,0);
    v_changes(44) := NVL(change_id44_in,0);
    v_changes(45) := NVL(change_id45_in,0);
    v_changes(46) := NVL(change_id46_in,0);
    v_changes(47) := NVL(change_id47_in,0);
    v_changes(48) := NVL(change_id48_in,0);
    v_changes(49) := NVL(change_id49_in,0);
    v_changes(50) := NVL(change_id50_in,0);
    

        FORALL i IN v_changes.FIRST..v_changes.LAST
        UPDATE SLCADMIN.COURSE_CHANGE CC
        SET CC.STATUS = 'REJECTED',
            CC.STATUS_BY = user_in
        WHERE CC.COURSE_CHANGE_ID = v_changes(i)
        AND CC.STATUS = 'NEW';
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END rejectCourseChanges;            
   
 
   PROCEDURE rejectCollegeChanges (
      change_id1_in         IN            NUMBER,
      change_id2_in         IN            NUMBER,
      change_id3_in         IN            NUMBER,
      change_id4_in         IN            NUMBER,
      change_id5_in         IN            NUMBER,
      change_id6_in         IN            NUMBER,
      change_id7_in         IN            NUMBER,
      change_id8_in         IN            NUMBER,
      change_id9_in         IN            NUMBER,
      change_id10_in         IN            NUMBER,
      change_id11_in         IN            NUMBER,
      change_id12_in         IN            NUMBER,
      change_id13_in         IN            NUMBER,
      change_id14_in         IN            NUMBER,
      change_id15_in         IN            NUMBER,
      change_id16_in         IN            NUMBER,
      change_id17_in         IN            NUMBER,
      change_id18_in         IN            NUMBER,
      change_id19_in         IN            NUMBER,
      change_id20_in         IN            NUMBER,
      change_id21_in         IN            NUMBER,
      change_id22_in         IN            NUMBER,
      change_id23_in         IN            NUMBER,
      change_id24_in         IN            NUMBER,
      change_id25_in         IN            NUMBER,
      change_id26_in         IN            NUMBER,
      change_id27_in         IN            NUMBER,
      change_id28_in         IN            NUMBER,
      change_id29_in         IN            NUMBER,
      change_id30_in         IN            NUMBER,
      change_id31_in         IN            NUMBER,
      change_id32_in         IN            NUMBER,
      change_id33_in         IN            NUMBER,
      change_id34_in         IN            NUMBER,
      change_id35_in         IN            NUMBER,
      change_id36_in         IN            NUMBER,
      change_id37_in         IN            NUMBER,
      change_id38_in         IN            NUMBER,
      change_id39_in         IN            NUMBER,
      change_id40_in         IN            NUMBER,
      change_id41_in         IN            NUMBER,
      change_id42_in         IN            NUMBER,
      change_id43_in         IN            NUMBER,
      change_id44_in         IN            NUMBER,
      change_id45_in         IN            NUMBER,
      change_id46_in         IN            NUMBER,
      change_id47_in         IN            NUMBER,
      change_id48_in         IN            NUMBER,
      change_id49_in         IN            NUMBER,
      change_id50_in         IN            NUMBER,
      user_in            IN VARCHAR2,
      error_boolean         OUT NOCOPY VARCHAR2,
      ERROR_TEXT            OUT NOCOPY VARCHAR2)
   IS
    v_changes CHANGES;
   BEGIN
    v_changes := CHANGES();
    v_changes.EXTEND(50);
    v_changes(1) := NVL(change_id1_in,0);
    v_changes(2) := NVL(change_id2_in,0);
    v_changes(3) := NVL(change_id3_in,0);
    v_changes(4) := NVL(change_id4_in,0);
    v_changes(5) := NVL(change_id5_in,0);
    v_changes(6) := NVL(change_id6_in,0);
    v_changes(7) := NVL(change_id7_in,0);
    v_changes(8) := NVL(change_id8_in,0);
    v_changes(9) := NVL(change_id9_in,0);
    v_changes(10) := NVL(change_id10_in,0);
    v_changes(11) := NVL(change_id11_in,0);
    v_changes(12) := NVL(change_id12_in,0);
    v_changes(13) := NVL(change_id13_in,0);
    v_changes(14) := NVL(change_id14_in,0);
    v_changes(15) := NVL(change_id15_in,0);
    v_changes(16) := NVL(change_id16_in,0);
    v_changes(17) := NVL(change_id17_in,0);
    v_changes(18) := NVL(change_id18_in,0);
    v_changes(19) := NVL(change_id19_in,0);
    v_changes(20) := NVL(change_id20_in,0);

    v_changes(21) := NVL(change_id21_in,0);
    v_changes(22) := NVL(change_id22_in,0);
    v_changes(23) := NVL(change_id23_in,0);
    v_changes(24) := NVL(change_id24_in,0);
    v_changes(25) := NVL(change_id25_in,0);
    v_changes(26) := NVL(change_id26_in,0);
    v_changes(27) := NVL(change_id27_in,0);
    v_changes(28) := NVL(change_id28_in,0);
    v_changes(29) := NVL(change_id29_in,0);
    v_changes(30) := NVL(change_id30_in,0);
    
    v_changes(31) := NVL(change_id31_in,0);
    v_changes(32) := NVL(change_id32_in,0);
    v_changes(33) := NVL(change_id33_in,0);
    v_changes(34) := NVL(change_id34_in,0);
    v_changes(35) := NVL(change_id35_in,0);
    v_changes(36) := NVL(change_id36_in,0);
    v_changes(37) := NVL(change_id37_in,0);
    v_changes(38) := NVL(change_id38_in,0);
    v_changes(39) := NVL(change_id39_in,0);
    v_changes(40) := NVL(change_id40_in,0);

    v_changes(41) := NVL(change_id41_in,0);
    v_changes(42) := NVL(change_id42_in,0);
    v_changes(43) := NVL(change_id43_in,0);
    v_changes(44) := NVL(change_id44_in,0);
    v_changes(45) := NVL(change_id45_in,0);
    v_changes(46) := NVL(change_id46_in,0);
    v_changes(47) := NVL(change_id47_in,0);
    v_changes(48) := NVL(change_id48_in,0);
    v_changes(49) := NVL(change_id49_in,0);
    v_changes(50) := NVL(change_id50_in,0);
    

        FORALL i IN v_changes.FIRST..v_changes.LAST
        UPDATE SLCADMIN.COLLEGE_CHANGE CC
        SET CC.STATUS = 'REJECTED',
            CC.STATUS_BY = user_in
        WHERE CC.COLLEGE_CHANGE_ID = v_changes(i);
   --     AND CC.STATUS = 'NEW';
      error_boolean := 'false';
      ERROR_TEXT := 'none';
--   EXCEPTION
--      WHEN OTHERS
--      THEN
--         error_boolean := 'true';
--         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END rejectCollegeChanges;  
   
      PROCEDURE rejectTermChanges (
      change_id1_in         IN            NUMBER,
      change_id2_in         IN            NUMBER,
      change_id3_in         IN            NUMBER,
      change_id4_in         IN            NUMBER,
      change_id5_in         IN            NUMBER,
      change_id6_in         IN            NUMBER,
      change_id7_in         IN            NUMBER,
      change_id8_in         IN            NUMBER,
      change_id9_in         IN            NUMBER,
      change_id10_in         IN            NUMBER,
      change_id11_in         IN            NUMBER,
      change_id12_in         IN            NUMBER,
      change_id13_in         IN            NUMBER,
      change_id14_in         IN            NUMBER,
      change_id15_in         IN            NUMBER,
      change_id16_in         IN            NUMBER,
      change_id17_in         IN            NUMBER,
      change_id18_in         IN            NUMBER,
      change_id19_in         IN            NUMBER,
      change_id20_in         IN            NUMBER,
      change_id21_in         IN            NUMBER,
      change_id22_in         IN            NUMBER,
      change_id23_in         IN            NUMBER,
      change_id24_in         IN            NUMBER,
      change_id25_in         IN            NUMBER,
      change_id26_in         IN            NUMBER,
      change_id27_in         IN            NUMBER,
      change_id28_in         IN            NUMBER,
      change_id29_in         IN            NUMBER,
      change_id30_in         IN            NUMBER,
      change_id31_in         IN            NUMBER,
      change_id32_in         IN            NUMBER,
      change_id33_in         IN            NUMBER,
      change_id34_in         IN            NUMBER,
      change_id35_in         IN            NUMBER,
      change_id36_in         IN            NUMBER,
      change_id37_in         IN            NUMBER,
      change_id38_in         IN            NUMBER,
      change_id39_in         IN            NUMBER,
      change_id40_in         IN            NUMBER,
      change_id41_in         IN            NUMBER,
      change_id42_in         IN            NUMBER,
      change_id43_in         IN            NUMBER,
      change_id44_in         IN            NUMBER,
      change_id45_in         IN            NUMBER,
      change_id46_in         IN            NUMBER,
      change_id47_in         IN            NUMBER,
      change_id48_in         IN            NUMBER,
      change_id49_in         IN            NUMBER,
      change_id50_in         IN            NUMBER,
      user_in            IN VARCHAR2,
      error_boolean         OUT NOCOPY VARCHAR2,
      ERROR_TEXT            OUT NOCOPY VARCHAR2)
   IS
    v_changes CHANGES;
   BEGIN
    v_changes := CHANGES();
    v_changes.EXTEND(50);
    v_changes(1) := NVL(change_id1_in,0);
    v_changes(2) := NVL(change_id2_in,0);
    v_changes(3) := NVL(change_id3_in,0);
    v_changes(4) := NVL(change_id4_in,0);
    v_changes(5) := NVL(change_id5_in,0);
    v_changes(6) := NVL(change_id6_in,0);
    v_changes(7) := NVL(change_id7_in,0);
    v_changes(8) := NVL(change_id8_in,0);
    v_changes(9) := NVL(change_id9_in,0);
    v_changes(10) := NVL(change_id10_in,0);
    v_changes(11) := NVL(change_id11_in,0);
    v_changes(12) := NVL(change_id12_in,0);
    v_changes(13) := NVL(change_id13_in,0);
    v_changes(14) := NVL(change_id14_in,0);
    v_changes(15) := NVL(change_id15_in,0);
    v_changes(16) := NVL(change_id16_in,0);
    v_changes(17) := NVL(change_id17_in,0);
    v_changes(18) := NVL(change_id18_in,0);
    v_changes(19) := NVL(change_id19_in,0);
    v_changes(20) := NVL(change_id20_in,0);

    v_changes(21) := NVL(change_id21_in,0);
    v_changes(22) := NVL(change_id22_in,0);
    v_changes(23) := NVL(change_id23_in,0);
    v_changes(24) := NVL(change_id24_in,0);
    v_changes(25) := NVL(change_id25_in,0);
    v_changes(26) := NVL(change_id26_in,0);
    v_changes(27) := NVL(change_id27_in,0);
    v_changes(28) := NVL(change_id28_in,0);
    v_changes(29) := NVL(change_id29_in,0);
    v_changes(30) := NVL(change_id30_in,0);
    
    v_changes(31) := NVL(change_id31_in,0);
    v_changes(32) := NVL(change_id32_in,0);
    v_changes(33) := NVL(change_id33_in,0);
    v_changes(34) := NVL(change_id34_in,0);
    v_changes(35) := NVL(change_id35_in,0);
    v_changes(36) := NVL(change_id36_in,0);
    v_changes(37) := NVL(change_id37_in,0);
    v_changes(38) := NVL(change_id38_in,0);
    v_changes(39) := NVL(change_id39_in,0);
    v_changes(40) := NVL(change_id40_in,0);

    v_changes(41) := NVL(change_id41_in,0);
    v_changes(42) := NVL(change_id42_in,0);
    v_changes(43) := NVL(change_id43_in,0);
    v_changes(44) := NVL(change_id44_in,0);
    v_changes(45) := NVL(change_id45_in,0);
    v_changes(46) := NVL(change_id46_in,0);
    v_changes(47) := NVL(change_id47_in,0);
    v_changes(48) := NVL(change_id48_in,0);
    v_changes(49) := NVL(change_id49_in,0);
    v_changes(50) := NVL(change_id50_in,0);
    

        FORALL i IN v_changes.FIRST..v_changes.LAST
        UPDATE SLCADMIN.TERM_CHANGE CC
        SET CC.STATUS = 'REJECTED',
            CC.STATUS_BY = user_in
        WHERE CC.TERM_CHANGE_ID = v_changes(i)
        AND CC.STATUS = 'NEW';
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END rejectTermChanges;  
   
   PROCEDURE rejectInstTermChanges (
      change_id1_in         IN            NUMBER,
      change_id2_in         IN            NUMBER,
      change_id3_in         IN            NUMBER,
      change_id4_in         IN            NUMBER,
      change_id5_in         IN            NUMBER,
      change_id6_in         IN            NUMBER,
      change_id7_in         IN            NUMBER,
      change_id8_in         IN            NUMBER,
      change_id9_in         IN            NUMBER,
      change_id10_in         IN            NUMBER,
      change_id11_in         IN            NUMBER,
      change_id12_in         IN            NUMBER,
      change_id13_in         IN            NUMBER,
      change_id14_in         IN            NUMBER,
      change_id15_in         IN            NUMBER,
      change_id16_in         IN            NUMBER,
      change_id17_in         IN            NUMBER,
      change_id18_in         IN            NUMBER,
      change_id19_in         IN            NUMBER,
      change_id20_in         IN            NUMBER,
      change_id21_in         IN            NUMBER,
      change_id22_in         IN            NUMBER,
      change_id23_in         IN            NUMBER,
      change_id24_in         IN            NUMBER,
      change_id25_in         IN            NUMBER,
      change_id26_in         IN            NUMBER,
      change_id27_in         IN            NUMBER,
      change_id28_in         IN            NUMBER,
      change_id29_in         IN            NUMBER,
      change_id30_in         IN            NUMBER,
      change_id31_in         IN            NUMBER,
      change_id32_in         IN            NUMBER,
      change_id33_in         IN            NUMBER,
      change_id34_in         IN            NUMBER,
      change_id35_in         IN            NUMBER,
      change_id36_in         IN            NUMBER,
      change_id37_in         IN            NUMBER,
      change_id38_in         IN            NUMBER,
      change_id39_in         IN            NUMBER,
      change_id40_in         IN            NUMBER,
      change_id41_in         IN            NUMBER,
      change_id42_in         IN            NUMBER,
      change_id43_in         IN            NUMBER,
      change_id44_in         IN            NUMBER,
      change_id45_in         IN            NUMBER,
      change_id46_in         IN            NUMBER,
      change_id47_in         IN            NUMBER,
      change_id48_in         IN            NUMBER,
      change_id49_in         IN            NUMBER,
      change_id50_in         IN            NUMBER,
      user_in            IN VARCHAR2,
      error_boolean         OUT NOCOPY VARCHAR2,
      ERROR_TEXT            OUT NOCOPY VARCHAR2)
   IS
    v_changes CHANGES;
   BEGIN
    v_changes := CHANGES();
    v_changes.EXTEND(50);
    v_changes(1) := NVL(change_id1_in,0);
    v_changes(2) := NVL(change_id2_in,0);
    v_changes(3) := NVL(change_id3_in,0);
    v_changes(4) := NVL(change_id4_in,0);
    v_changes(5) := NVL(change_id5_in,0);
    v_changes(6) := NVL(change_id6_in,0);
    v_changes(7) := NVL(change_id7_in,0);
    v_changes(8) := NVL(change_id8_in,0);
    v_changes(9) := NVL(change_id9_in,0);
    v_changes(10) := NVL(change_id10_in,0);
    v_changes(11) := NVL(change_id11_in,0);
    v_changes(12) := NVL(change_id12_in,0);
    v_changes(13) := NVL(change_id13_in,0);
    v_changes(14) := NVL(change_id14_in,0);
    v_changes(15) := NVL(change_id15_in,0);
    v_changes(16) := NVL(change_id16_in,0);
    v_changes(17) := NVL(change_id17_in,0);
    v_changes(18) := NVL(change_id18_in,0);
    v_changes(19) := NVL(change_id19_in,0);
    v_changes(20) := NVL(change_id20_in,0);

    v_changes(21) := NVL(change_id21_in,0);
    v_changes(22) := NVL(change_id22_in,0);
    v_changes(23) := NVL(change_id23_in,0);
    v_changes(24) := NVL(change_id24_in,0);
    v_changes(25) := NVL(change_id25_in,0);
    v_changes(26) := NVL(change_id26_in,0);
    v_changes(27) := NVL(change_id27_in,0);
    v_changes(28) := NVL(change_id28_in,0);
    v_changes(29) := NVL(change_id29_in,0);
    v_changes(30) := NVL(change_id30_in,0);
    
    v_changes(31) := NVL(change_id31_in,0);
    v_changes(32) := NVL(change_id32_in,0);
    v_changes(33) := NVL(change_id33_in,0);
    v_changes(34) := NVL(change_id34_in,0);
    v_changes(35) := NVL(change_id35_in,0);
    v_changes(36) := NVL(change_id36_in,0);
    v_changes(37) := NVL(change_id37_in,0);
    v_changes(38) := NVL(change_id38_in,0);
    v_changes(39) := NVL(change_id39_in,0);
    v_changes(40) := NVL(change_id40_in,0);

    v_changes(41) := NVL(change_id41_in,0);
    v_changes(42) := NVL(change_id42_in,0);
    v_changes(43) := NVL(change_id43_in,0);
    v_changes(44) := NVL(change_id44_in,0);
    v_changes(45) := NVL(change_id45_in,0);
    v_changes(46) := NVL(change_id46_in,0);
    v_changes(47) := NVL(change_id47_in,0);
    v_changes(48) := NVL(change_id48_in,0);
    v_changes(49) := NVL(change_id49_in,0);
    v_changes(50) := NVL(change_id50_in,0);
    

        FORALL i IN v_changes.FIRST..v_changes.LAST
        UPDATE SLCADMIN.INST_TERM_CHANGE CC
        SET CC.STATUS = 'REJECTED',
            CC.STATUS_BY = user_in
        WHERE CC.INST_TERM_CHANGE_ID = v_changes(i)
        AND CC.STATUS = 'NEW';
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END rejectInstTermChanges; 
 
   PROCEDURE authoriseChange (user_id_in          IN            VARCHAR2,
                              courseChangeId_in   IN            VARCHAR2,
                              termChangeId_in     IN            VARCHAR2,
                              inst_code_in        IN            VARCHAR2,
                              session_code_in     IN            VARCHAR2,
                              error_boolean          OUT NOCOPY VARCHAR2,
                              ERROR_TEXT             OUT NOCOPY VARCHAR2)
   IS
   BEGIN
    IF NVL(courseChangeId_in,0) > 0
    THEN

        UPDATE SLCADMIN.COURSE_CHANGE CC
           SET CC.STATUS = 'AUTHORISED',
               CC.STATUS_BY = user_id_in
         WHERE CC.COURSE_CHANGE_ID IN (SELECT CC1.COURSE_CHANGE_ID
                                         FROM SLCADMIN.COURSE_CHANGE CC1,
                                              SLCADMIN.COURSE_CHANGE CC2
                                        WHERE     CC1.NEW_HEI_CRSE_CODE =
                                                     NVL(CC2.NEW_HEI_CRSE_CODE, CC2.OLD_HEI_CRSE_CODE)
                                              AND CC1.SESSION_CODE = CC2.SESSION_CODE
                                              AND CC1.STATUS = 'NEW'
                                              AND CC2.COURSE_CHANGE_ID = courseChangeId_in
                                        UNION
                                        SELECT CC1.COURSE_CHANGE_ID
                                         FROM SLCADMIN.COURSE_CHANGE CC1,
                                              SLCADMIN.COURSE_CHANGE CC2
                                        WHERE     CC1.OLD_HEI_CRSE_CODE =
                                                      NVL(CC2.NEW_HEI_CRSE_CODE, CC2.OLD_HEI_CRSE_CODE)
                                              AND CC1.SESSION_CODE = CC2.SESSION_CODE
                                              AND CC1.STATUS = 'NEW'
                                              AND CC2.COURSE_CHANGE_ID = courseChangeId_in
                                        UNION
                                        SELECT TO_NUMBER(courseChangeId_in) FROM DUAL);

        UPDATE SLCADMIN.TERM_CHANGE TC
           SET TC.STATUS = 'AUTHORISED',
               TC.STATUS_BY = user_id_in
         WHERE TC.TERM_CHANGE_ID IN (SELECT TC1.TERM_CHANGE_ID
                                       FROM SLCADMIN.TERM_CHANGE TC1,
                                            SLCADMIN.COURSE_CHANGE CC2
                                      WHERE     TC1.HEI_CRSE_CODE =
                                                   NVL(CC2.NEW_HEI_CRSE_CODE, CC2.OLD_HEI_CRSE_CODE)
                                            AND TC1.SESSION_CODE = CC2.SESSION_CODE
                                            AND TC1.STATUS = 'NEW'
                                            AND CC2.COURSE_CHANGE_ID =
                                                   courseChangeId_in);

     ELSIF NVL(termChangeId_in,0) > 0
    THEN

        UPDATE SLCADMIN.COURSE_CHANGE CC
           SET CC.STATUS = 'AUTHORISED',
               CC.STATUS_BY = user_id_in
         WHERE CC.COURSE_CHANGE_ID IN (SELECT CC1.COURSE_CHANGE_ID
                                 FROM SLCADMIN.COURSE_CHANGE CC1,
                                      SLCADMIN.TERM_CHANGE TC2
                                WHERE     CC1.NEW_HEI_CRSE_CODE =
                                             TC2.HEI_CRSE_CODE
                                      AND CC1.SESSION_CODE = TC2.SESSION_CODE
                                      AND CC1.STATUS = 'NEW'
                                              AND TC2.TERM_CHANGE_ID = termChangeId_in
                                      UNION
                                      SELECT CC1.COURSE_CHANGE_ID
                                 FROM SLCADMIN.COURSE_CHANGE CC1,
                                      SLCADMIN.TERM_CHANGE TC2
                                WHERE     CC1.OLD_HEI_CRSE_CODE =
                                             TC2.HEI_CRSE_CODE
                                      AND CC1.SESSION_CODE = TC2.SESSION_CODE
                                      AND CC1.STATUS = 'NEW'
                                              AND TC2.TERM_CHANGE_ID = termChangeId_in);

        UPDATE SLCADMIN.TERM_CHANGE TC
           SET TC.STATUS = 'AUTHORISED',
               TC.STATUS_BY = user_id_in
         WHERE TC.TERM_CHANGE_ID IN (SELECT TC1.TERM_CHANGE_ID
                                       FROM SLCADMIN.TERM_CHANGE TC1,
                                            SLCADMIN.TERM_CHANGE TC2
                                      WHERE     TC1.HEI_CRSE_CODE =
                                                   TC2.HEI_CRSE_CODE
                                            AND TC1.SESSION_CODE = TC2.SESSION_CODE
                                            AND TC1.STATUS = 'NEW'
                                            AND TC2.TERM_CHANGE_ID = termChangeId_in
                                      UNION 
                                      SELECT TC1.TERM_CHANGE_ID
                                       FROM SLCADMIN.TERM_CHANGE TC1,
                                            SLCADMIN.TERM_CHANGE TC2
                                      WHERE     TC1.CRSE_ID = TC2.CRSE_ID
                                            AND TC1.SESSION_CODE = TC2.SESSION_CODE
                                            AND TC1.STATUS = 'NEW'
                                            AND TC2.TERM_CHANGE_ID = termChangeId_in
                                      UNION 
                                      SELECT TO_NUMBER(termChangeId_in) FROM DUAL);

     ELSIF inst_code_in IS NOT NULL
     THEN
        UPDATE SLCADMIN.INST_TERM_CHANGE ITC
        SET ITC.STATUS = 'AUTHORISED',
               ITC.STATUS_BY = user_id_in
        WHERE ITC.INST_CODE = inst_code_in
        AND ITC.SESSION_CODE = session_code_in
        AND ITC.STATUS = 'NEW';
     END IF;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END authoriseChange;
 

    PROCEDURE getChangeCreatedBy (user_id_in         IN            VARCHAR2,
                                  hei_crse_code_in   IN            VARCHAR2,
                                  crse_id_in         IN            VARCHAR2,
                                  inst_code_in       IN            VARCHAR2,
                                  session_code_in    IN            VARCHAR2,
                                  changedByUser      OUT        VARCHAR2)
     IS
        CURSOR C_TERM
        IS
        SELECT 'Y'
        FROM SLCADMIN.TERM_CHANGE TC
        WHERE TC.CREATED_BY = user_id_in
        AND TC.STATUS = 'NEW'
        AND TC.SESSION_CODE = session_code_in
        AND TC.HEI_CRSE_CODE = hei_crse_code_in;
        
        CURSOR C_TERM_CRSE_ID
        IS
        SELECT 'Y'
        FROM SLCADMIN.TERM_CHANGE TC
        WHERE TC.CREATED_BY = user_id_in
        AND TC.STATUS = 'NEW'
        AND TC.SESSION_CODE = session_code_in
        AND (TC.CRSE_ID = crse_id_in or  TC.HEI_CRSE_CODE = hei_crse_code_in);
        
        
        CURSOR C_INST
        IS
        SELECT 'Y'
        FROM SLCADMIN.INST_TERM_CHANGE ITC
        WHERE ITC.CREATED_BY = user_id_in
        AND ITC.STATUS = 'NEW'
        AND ITC.SESSION_CODE = session_code_in
        AND ITC.INST_CODE = inst_code_in;
        V_CHANGE_BY_USER VARCHAR2(1);
     BEGIN
        IF crse_id_in IS NOT NULL
        THEN
            OPEN C_TERM_CRSE_ID;
            FETCH C_TERM_CRSE_ID INTO V_CHANGE_BY_USER;
            CLOSE C_TERM_CRSE_ID;
        ELSIF hei_crse_code_in IS NOT NULL
        THEN
            OPEN C_TERM;
            FETCH C_TERM INTO V_CHANGE_BY_USER;
            CLOSE C_TERM;
        ELSE
            OPEN C_INST;
            FETCH C_INST INTO V_CHANGE_BY_USER;
            CLOSE C_INST;
        END IF;
        changedByUser := NVL(V_CHANGE_BY_USER,'N');
     END getChangeCreatedBy;      
END PK_STEPS_UI_AUTH_TERM_DATES;
/