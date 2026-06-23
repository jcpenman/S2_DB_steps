CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_PG_ED_PSYCH AS
/***********************************************************************************************
    NAME:           PK_STEPS_PG_ED_PSYCH
    PURPOSE:        Used to return details related to PG Educational Psychology Courses 
    REVISIONS:
    Ver        Date            Author               Description
    ---------  ----------      ---------------      ----------------------------------------
    0.1        30/10/2018      Ranj Benning         Created this package.
***********************************************************************************************/

    FUNCTION checkIfPgEdPsychCourse (
        instCode_in                 IN      VARCHAR2,
        crseCode_in                 IN      VARCHAR2
    ) 
    RETURN CHAR
   
    IS
    numOfMatches NUMBER:= 0;
    isPgEdPsychCourse_out CHAR:= 'N';
    
    BEGIN
        SELECT COUNT(*) 
        INTO numOfMatches 
        FROM PG_ED_PSYCH PEP 
        WHERE UPPER(PEP.INST_CODE) = UPPER(instCode_in) 
        AND UPPER(PEP.CRSE_CODE) = UPPER(crseCode_in);
        
        IF(numOfMatches = 0)
            THEN
                isPgEdPsychCourse_out := 'N';
            ELSE
                isPgEdPsychCourse_out := 'Y';
        END IF;

        RETURN isPgEdPsychCourse_out;
 
    END checkIfPgEdPsychCourse;
    
    /*******************************************/
    PROCEDURE isPgEdPsychCourse (
        instCode_in                 IN      VARCHAR2,
        crseCode_in                 IN      VARCHAR2,
        isPgEdPsychCourse_out       OUT     VARCHAR2,
        error_boolean               OUT     VARCHAR2,
        error_text                  OUT     VARCHAR2
    )
    IS
        
    BEGIN
        isPgEdPsychCourse_out := checkIfPgEdPsychCourse(instCode_in, crseCode_in);
        error_boolean := 'false';
        error_text := 'none';
    EXCEPTION
        WHEN OTHERS
        THEN
            ROLLBACK;
            error_boolean := 'true';
            error_text := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
            
    END isPgEdPsychCourse;
    
    /*******************************************/    
    PROCEDURE isPgEdPsychCourseCurrentYr (
        studRefNo_in                IN      VARCHAR2,
        isPgEdPsychCourse_out       OUT     VARCHAR2,
        error_boolean               OUT     VARCHAR2,
        error_text                  OUT     VARCHAR2
    )    
    IS
        
    CURSOR crseInfo
    
    IS
        
    SELECT INST_CODE, CRSE_CODE FROM STUD_CRSE_YEAR 
    WHERE STUD_REF_NO = studRefNo_in
    AND SESSION_CODE = (SELECT CVAL FROM CONFIG_DATA WHERE ITEM_NAME = 'CURRENT_SESSION');
         
    v_crseInfo crseInfo%ROWTYPE;
         
    BEGIN
        OPEN crseInfo;
        isPgEdPsychCourse_out := 'N';
    
        LOOP
            FETCH crseInfo INTO v_crseInfo;
            
            IF checkIfPgEdPsychCourse(v_crseInfo.INST_CODE, v_crseInfo.CRSE_CODE) = 'Y'
            THEN 
                isPgEdPsychCourse_out := 'Y';
            END IF;                
            
            EXIT WHEN crseInfo%NOTFOUND;
            
        END LOOP;
        CLOSE crseInfo;
        
        error_boolean := 'false';
        error_text := 'none';
    EXCEPTION
        WHEN OTHERS
        THEN
            ROLLBACK;
            error_boolean := 'true';
            error_text := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
            
    END isPgEdPsychCourseCurrentYr;
    
    
    
    PROCEDURE isPgEdPsychCourseOPExempt (
        studRefNo_in                IN      VARCHAR2,
        sessionCode_in              IN      VARCHAR2,
        isPgEdPsychCourse_out       OUT     VARCHAR2,
        error_boolean               OUT     VARCHAR2,
        error_text                  OUT     VARCHAR2
    )    
    IS
        
    CURSOR crseInfo
    
    IS
        
    SELECT INST_CODE, CRSE_CODE FROM STUD_CRSE_YEAR 
    WHERE STUD_REF_NO = studRefNo_in
    AND SESSION_CODE = sessionCode_in;
         
    v_crseInfo crseInfo%ROWTYPE;
         
    BEGIN
        OPEN crseInfo;
        isPgEdPsychCourse_out := 'N';
    
        LOOP
            FETCH crseInfo INTO v_crseInfo;
            
            IF checkIfPgEdPsychCourse(v_crseInfo.INST_CODE, v_crseInfo.CRSE_CODE) = 'Y'
            THEN 
                isPgEdPsychCourse_out := 'Y';
            END IF;                
            
            EXIT WHEN crseInfo%NOTFOUND;
            
        END LOOP;
        CLOSE crseInfo;
        
        error_boolean := 'false';
        error_text := 'none';
    EXCEPTION
        WHEN OTHERS
        THEN
            ROLLBACK;
            error_boolean := 'true';
            error_text := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
            
    END isPgEdPsychCourseOPExempt;
    
    /*******************************************/   
    PROCEDURE getLocalAuthorityInstDetails (
        instCode_out                OUT     VARCHAR2,
        instName_out                OUT     VARCHAR2,
        crseCode_out                OUT     VARCHAR2,
        crseName_out                OUT     VARCHAR2,        
        error_boolean               OUT     VARCHAR2,
        error_text                  OUT     VARCHAR2
    )
    IS 

    BEGIN
      
        SELECT C.INST_CODE, C.INST_NAME , C.CRSE_CODE, C.CRSE_NAME  
        INTO instCode_out, instName_out, crseCode_out, crseName_out 
        FROM CRSE C, PG_ED_PSYCH P 
        WHERE P.IS_LOCAL_AUTHORITY = 'Y'
        AND P.INST_CODE = C.INST_CODE
        AND P.CRSE_CODE = C.CRSE_CODE;      
    
        error_boolean := 'false';
        error_text := 'none';
      
    EXCEPTION
        WHEN OTHERS
        THEN
            ROLLBACK;
            error_boolean := 'true';
            error_text := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
      
    END getLocalAuthorityInstDetails;      
       
END PK_STEPS_PG_ED_PSYCH;
/