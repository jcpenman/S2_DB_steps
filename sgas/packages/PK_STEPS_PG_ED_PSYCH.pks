CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_PG_ED_PSYCH AS
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
    RETURN CHAR;    
    /*******************************************/
    PROCEDURE isPgEdPsychCourseCurrentYr (
        studRefNo_in                IN      VARCHAR2,
        isPgEdPsychCourse_out       OUT     VARCHAR2,
        error_boolean               OUT     VARCHAR2,
        error_text                  OUT     VARCHAR2
    );
    /*******************************************/
    PROCEDURE isPgEdPsychCourse (
        instCode_in                 IN      VARCHAR2,
        crseCode_in                 IN      VARCHAR2,
        isPgEdPsychCourse_out       OUT     VARCHAR2,
        error_boolean               OUT     VARCHAR2,
        error_text                  OUT     VARCHAR2
    );
    
     PROCEDURE isPgEdPsychCourseOPExempt (
        studRefNo_in                IN      VARCHAR2,
        sessionCode_in              IN      VARCHAR2,
        isPgEdPsychCourse_out       OUT     VARCHAR2,
        error_boolean               OUT     VARCHAR2,
        error_text                  OUT     VARCHAR2
    );
    
    /*******************************************/
    PROCEDURE getLocalAuthorityInstDetails (
        instCode_out                OUT     VARCHAR2,
        instName_out                OUT     VARCHAR2,
        crseCode_out                OUT     VARCHAR2,
        crseName_out                OUT     VARCHAR2,        
        error_boolean               OUT     VARCHAR2,
        error_text                  OUT     VARCHAR2
    );    
       
END PK_STEPS_PG_ED_PSYCH;
/