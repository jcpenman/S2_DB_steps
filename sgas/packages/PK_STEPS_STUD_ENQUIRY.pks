CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_STUD_ENQUIRY
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
    
    -- Student Enquiry Data Transfer
    PROCEDURE TRANSFER_STUD_ENQUIRIES;
    
    -- Insert into STUD_ENQUIRY_TASK_MAP
    PROCEDURE INSERT_STUD_ENQUIRY_TASK_MAP (
        ENQUIRY_ID_IN   IN          NUMBER,
        TASK_ID_IN      IN          NUMBER,
        PROCESS_ID_IN   IN          VARCHAR2,
        STUD_REF_NO_IN  IN          NUMBER,
        ERROR_BOOLEAN   OUT NOCOPY  VARCHAR2,
        ERROR_TEXT      OUT NOCOPY  VARCHAR2);
        
END PK_STEPS_STUD_ENQUIRY;
/