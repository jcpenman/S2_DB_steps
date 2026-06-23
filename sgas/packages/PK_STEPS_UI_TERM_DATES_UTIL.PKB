CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_UI_TERM_DATES_UTIL
AS

    FUNCTION next_course_code (inst_code_in IN VARCHAR2)
       RETURN VARCHAR2
    IS
    PRAGMA AUTONOMOUS_TRANSACTION;
       CURSOR C_MAX_CRSE_CODE
       IS
          WITH C_POSSIBLE_CRSE
               AS (SELECT    CHR (ASCII ('A') + TRUNC (ROWNUM / 1000))
                          || SUBSTR (LPAD (ROWNUM, 10, '0'), -3)
                             POSSIBLE_CRSE_CODE,
                          MOD (ROWNUM, 1000) MOD_VAL
                     FROM STUD_CRSE_YEAR S
                    WHERE ROWNUM < 26000)
          SELECT                                                        --DISTINCT
                                                                    --I.INST_CODE,
                                                                    --I.INST_NAME,
               (SELECT MIN (X.POSSIBLE_CRSE_CODE) NEXT_CRSE_CODE
                     FROM C_POSSIBLE_CRSE X, (SELECT CC1.INST_CODE, CC1.CRSE_CODE CRSE_CODE
                                          FROM CRSE_CODE CC1
                                         WHERE CC1.INST_CODE = inst_code_in
                                         UNION 
                                         SELECT C.INST_CODE, C.CRSE_CODE CRSE_CODE
                                          FROM CRSE C
                                         WHERE C.INST_CODE = inst_code_in) C
                    WHERE     X.MOD_VAL > 0
                          AND X.POSSIBLE_CRSE_CODE = C.CRSE_CODE(+)
                          AND I.INST_CODE = C.INST_CODE(+)
                          AND C.CRSE_CODE IS NULL)
                  NEXT_CRSE_CODE
          FROM INST I
          WHERE I.INST_CODE = inst_code_in;
       V_MAX_CRSE_CODE VARCHAR2(4);
    BEGIN
       OPEN C_MAX_CRSE_CODE;

       FETCH C_MAX_CRSE_CODE INTO V_MAX_CRSE_CODE;

       CLOSE C_MAX_CRSE_CODE;
       IF (inst_code_in IS NOT NULL AND V_MAX_CRSE_CODE IS NOT NULL)
       THEN
        INSERT INTO CRSE_CODE (INST_CODE, CRSE_CODE)
        VALUES (inst_code_in, V_MAX_CRSE_CODE);
        END IF;
        COMMIT;
       RETURN V_MAX_CRSE_CODE;
    END next_course_code;
    

    PROCEDURE generateCourseCode (instCode_in     IN         VARCHAR2,
                                  crseCode_out    OUT        VARCHAR2,
                                  error_boolean   OUT NOCOPY VARCHAR2,
                                  error_text      OUT NOCOPY VARCHAR2)
    IS
    BEGIN
       SELECT next_course_code(instCode_in) INTO crseCode_out FROM DUAL;

       error_boolean := 'false';
       error_text := 'none';
    EXCEPTION
       WHEN OTHERS
       THEN
          error_boolean := 'true';
          error_text := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
    END generateCourseCode;
    
    
    PROCEDURE getMaxTermDatesSession (maxTermDatesSession_out   OUT         VARCHAR2,
                                      error_boolean             OUT NOCOPY  VARCHAR2,
                                      error_text                OUT NOCOPY  VARCHAR2)
    IS
        V_STEPS_CURRENT_SESSION VARCHAR2(4);
        V_GRASS_CURRENT_SESSION VARCHAR2(4);
    
    BEGIN
       SELECT CVAL INTO V_STEPS_CURRENT_SESSION FROM CONFIG_DATA WHERE ITEM_NAME = 'CURRENT_SESSION';
       SELECT CVAL INTO V_GRASS_CURRENT_SESSION FROM CONFIG_DATA@GRASS WHERE ITEM_NAME = 'CURRENT_SESSION';
       SELECT GREATEST(NVL(V_GRASS_CURRENT_SESSION, V_STEPS_CURRENT_SESSION),(SELECT MAX(SESSION_CODE ) FROM CRSE_SESSION))
               INTO maxTermDatesSession_out FROM DUAL;

       error_boolean := 'false';
       error_text := 'none';
    EXCEPTION
       WHEN OTHERS
       THEN
          maxTermDatesSession_out := V_STEPS_CURRENT_SESSION;
          error_boolean := 'true';
          error_text := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
    END getMaxTermDatesSession;    
        
    
END PK_STEPS_UI_TERM_DATES_UTIL;
/