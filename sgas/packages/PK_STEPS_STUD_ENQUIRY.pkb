CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_STUD_ENQUIRY
IS
/******************************************************************************
    NAME:       PK_STEPS_STUD_ENQUIRY
    PURPOSE:    Student Enquiry 

    REVISIONS:
    Ver            Date        Author          Description
    ---------    ----------    --------------- --------------------------------
    1.0            24/11/2015  RANJ BENNING    Initial Development
    1.1            11/04/2017  RANJ BENNING    Update for CR-OLS-203  
******************************************************************************/

    PROCEDURE TRANSFER_STUD_ENQUIRIES 
        IS
        V_ERRM VARCHAR2(128);
        MAX_ID NUMBER;

        BEGIN
            SELECT MAX(ENQUIRY_ID) INTO MAX_ID FROM ENQUIRY_FORM@WEB; 
            INSERT INTO SGAS.STUD_ENQUIRY (ENQUIRY_ID, STUD_REF_NO, ENQUIRY_OPTION_ID, ENQUIRY_TEXT, ENQUIRY_DATE) SELECT * FROM ENQUIRY_FORM@WEB WHERE ENQUIRY_ID <= MAX_ID;
            DELETE ENQUIRY_FORM@WEB WHERE ENQUIRY_ID <= MAX_ID;
            COMMIT;
        EXCEPTION
        WHEN OTHERS
        THEN         
             BEGIN
                ROLLBACK;
                V_ERRM := SUBSTR(SQLERRM,1,128);
                INSERT INTO SGAS.STUD_ENQUIRY_TRANSFER_ERROR (ERROR_TEXT) VALUES (V_ERRM);
                COMMIT;
             END;
        END TRANSFER_STUD_ENQUIRIES;
        
    PROCEDURE INSERT_STUD_ENQUIRY_TASK_MAP (   
        ENQUIRY_ID_IN   IN              NUMBER,
        TASK_ID_IN      IN              NUMBER,
        PROCESS_ID_IN   IN              VARCHAR2,
        STUD_REF_NO_IN  IN              NUMBER,
        ERROR_BOOLEAN   OUT NOCOPY      VARCHAR2,
        ERROR_TEXT      OUT NOCOPY      VARCHAR2    
        )
        IS        
        BEGIN
            INSERT INTO STUD_ENQUIRY_TASK_MAP SE
                (SE.ENQUIRY_ID, SE.PROCESS_ID, SE.TASK_ID, SE.STUD_REF_NO)
            VALUES 
                (ENQUIRY_ID_IN, PROCESS_ID_IN, TASK_ID_IN, STUD_REF_NO_IN);
            ERROR_BOOLEAN := 'false';
            ERROR_TEXT := 'none';
        EXCEPTION
        WHEN OTHERS
        THEN
            ERROR_BOOLEAN := 'true';
            ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
        END INSERT_STUD_ENQUIRY_TASK_MAP;
END PK_STEPS_STUD_ENQUIRY;
/