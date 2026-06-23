CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_COURSE_CHANGE
IS
   /******************************************************************************
       NAME:       PK_STEPS_COURSE_CHANGE
       PURPOSE:    Course Changes

       REVISIONS:
       Ver            Date        Author          Description
       ---------    ----------    --------------- --------------------------------
       1.0          10/07/20185  James Baird    Initial Development
       1.1          04/03/2019   Mike Tolmie    Update_Course_Change() procedure
                                                signature and implementation changed.
                                                TASK_ID removed from COURSE_CHANGE 
   ******************************************************************************/

   PROCEDURE UPDATE_COURSE_CHANGE (PROCESS_ID_IN    IN VARCHAR2,
                                   STUD_REF_NO_IN   IN VARCHAR2);
   FUNCTION GET_DST_STATUS (STUD_REF_NO_IN    IN NUMBER,
                            SESSION_CODE_IN   IN NUMBER)
       RETURN VARCHAR2;                                   

   FUNCTION GET_WORK_QUEUE (STUD_REF_NO_IN    IN NUMBER,
                            SESSION_CODE_IN   IN NUMBER)
      RETURN VARCHAR2;
END PK_STEPS_COURSE_CHANGE;
/