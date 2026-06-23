CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_COURSE_CHANGE
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
      1.2          18/09/2020   Clark Bolan     added FUNCTION GET_DST_STATUS and
                                                used this in GET_WORK_QUEUE                                           
   ******************************************************************************/
   FUNCTION GET_WORK_QUEUE (STUD_REF_NO_IN    IN NUMBER,
                            SESSION_CODE_IN   IN NUMBER)
      RETURN VARCHAR2
   IS
      V_WORK_QUEUE   VARCHAR2 (100);
      V_IS_DST VARCHAR2 (1) := PK_STEPS_COURSE_CHANGE.GET_DST_STATUS(STUD_REF_NO_IN, SESSION_CODE_IN);
   BEGIN
      WITH C_DET
           AS (SELECT NVL (SCY.SCHEME_TYPE, 'NULL') SCHEME_TYPE,
                      NVL (I.LOCATION_IND, 'NULL') LOCATION_IND,
                      NVL (C.PAMS_COURSE, 'NULL') PAMS,
                      NVL (EP.INST_CODE, 'N') EU_PORTABILITY,
                      CASE WHEN ( NVL (SCY.SCHEME_TYPE, 'NULL') = 'U' AND C.QUAL_TYPE = 'PGCE' ) THEN 'Y' ELSE 'N' END PGCE,
                      NVL (ST.RESIDENCY_CATEGORY, 'NULL') RESIDENCY_CATEGORY                     
                 FROM STUD_CRSE_YEAR SCY, INST I, EU_PORTABILITY EP, CRSE C, STUD ST
                WHERE     SCY.STUD_REF_NO = STUD_REF_NO_IN
                      AND SCY.STUD_REF_NO = ST.STUD_REF_NO
                      AND SCY.SESSION_CODE = SESSION_CODE_IN                      
                      AND SCY.LATEST_CRSE_IND = 'Y'
                      AND SCY.INST_CODE = I.INST_CODE(+)
                      AND I.INST_CODE = EP.INST_CODE(+)
                      AND SCY.CRSE_ID = C.CRSE_ID(+))
                      
      /*
      CR-OLS86 Amended @5 April 2019
      
      SCHEME_TYPE           INSTITUTION LOCATION    PAMS Course(GRASS)  StEPS Task Work Queue   IF DST
      ==================================================================================================        
 1    Undergraduate         1(Scotland)             Y                   AHP                     DST3
 2    Undergraduate         1(Scotland)             N                   UG                      DST1
 3    Undergraduate         2-5(RUK)                Y                   AHP                     DST3
 4    Undergraduate         2-5(RUK)                N                   RUK                     DST1
 5    Undergraduate         6(ROI)                  -                   RUK                     DST1
 6    Undergraduate         EU Portability          -                   RUK                     DST1
 7    Undergraduate         7(Other EU)             -                   -                       
 8    Undergraduate(EU)     1(Scotland)             -                   EU                      DST1
 9    PGDE                  1-7                     -                   UG                      DST1
 10   PGDE                  EU Portability          -                   -                       
 11   Postgraduate          1-7                     -                   PG                      DST2
 12   NMSB                  1-7                     -                   NMSB                    DST3
      */                
                      
                      
      SELECT CASE
      
                

 /* 10 */
               WHEN (D.PGCE = 'Y' AND D.EU_PORTABILITY != 'N') THEN ''


 /* 9 */
               WHEN (D.PGCE = 'Y' AND D.LOCATION_IND IN ('1','2','3','4','5','6','7') AND V_IS_DST = 'Y') THEN 'DST1' 
               WHEN (D.PGCE = 'Y' AND D.LOCATION_IND IN ('1','2','3','4','5','6','7')) THEN 'UG'

 /* 6 */
               WHEN (D.SCHEME_TYPE = 'U' AND D.EU_PORTABILITY != 'N' AND V_IS_DST = 'Y') THEN 'DST1'
               WHEN (D.SCHEME_TYPE = 'U' AND D.EU_PORTABILITY != 'N') THEN 'RUK'

 /* 1 and 3 */
               WHEN (D.SCHEME_TYPE = 'U' AND D.PAMS = 'Y' AND D.LOCATION_IND IN ('1','2','3','4','5') AND V_IS_DST = 'Y') THEN 'DST3'
               WHEN (D.SCHEME_TYPE = 'U' AND D.PAMS = 'Y' AND D.LOCATION_IND IN ('1','2','3','4','5')) THEN 'AHP'

 /* 2 */
               WHEN (D.SCHEME_TYPE = 'U' AND D.PAMS = 'N' AND D.LOCATION_IND = '1' AND D.RESIDENCY_CATEGORY != 'EU' AND V_IS_DST = 'Y') THEN 'DST1'
               WHEN (D.SCHEME_TYPE = 'U' AND D.PAMS = 'N' AND D.LOCATION_IND = '1' AND D.RESIDENCY_CATEGORY != 'EU') THEN 'UG'

 /* 4 */
               WHEN (D.SCHEME_TYPE = 'U' AND D.PAMS = 'N' AND D.LOCATION_IND IN ('2','3','4','5') AND V_IS_DST = 'Y') THEN 'DST1'
               WHEN (D.SCHEME_TYPE = 'U' AND D.PAMS = 'N' AND D.LOCATION_IND IN ('2','3','4','5')) THEN 'RUK'

 /* 5 */
               WHEN (D.SCHEME_TYPE = 'U' AND D.LOCATION_IND = '6' AND V_IS_DST = 'Y') THEN 'DST1'
               WHEN (D.SCHEME_TYPE = 'U' AND D.LOCATION_IND = '6') THEN 'RUK'

 /* 7 */
               WHEN (D.SCHEME_TYPE = 'U' AND D.LOCATION_IND = '7') THEN ''


 /* 8 */
               WHEN (D.SCHEME_TYPE = 'U' AND  D.LOCATION_IND = '1' AND D.RESIDENCY_CATEGORY = 'EU' AND V_IS_DST = 'Y') THEN 'DST1'
               WHEN (D.SCHEME_TYPE = 'U' AND  D.LOCATION_IND = '1' AND D.RESIDENCY_CATEGORY = 'EU') THEN 'EU'

 /* 11 */
               WHEN (D.SCHEME_TYPE = 'P' AND D.LOCATION_IND IN ('1','2','3','4','5','6','7') AND V_IS_DST = 'Y') THEN 'DST2'
               WHEN (D.SCHEME_TYPE = 'P' AND D.LOCATION_IND IN ('1','2','3','4','5','6','7')) THEN 'PG'
               
               WHEN (D.SCHEME_TYPE = 'B' AND D.LOCATION_IND IN ('1','2','3','4','5','6','7') AND V_IS_DST = 'Y') THEN 'DST3'
 /* 12 */     WHEN (D.SCHEME_TYPE = 'B' AND D.LOCATION_IND IN ('1','2','3','4','5','6','7')) THEN 'NMSB'
         

        
                ELSE 'UG'
                
                
             END
                WORK_QUEUE
        INTO V_WORK_QUEUE
        FROM C_DET D;

      RETURN NVL (V_WORK_QUEUE, 'UNKNOWN');
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 'ERROR';
   END GET_WORK_QUEUE;
   
   FUNCTION GET_DST_STATUS (STUD_REF_NO_IN    IN NUMBER,
                            SESSION_CODE_IN   IN NUMBER)
      RETURN VARCHAR2
   IS
      V_STUD_REF_NO NUMBER(10);
      V_IS_DST   VARCHAR2 (1);
   BEGIN
            BEGIN
   
                SELECT DISTINCT (S.STUD_REF_NO)
                  INTO V_STUD_REF_NO
                  FROM stud s, stud_session ss
                 WHERE     S.STUD_REF_NO = SS.STUD_REF_NO
                       AND (   (S.COMPLEX_RESIDENCY = 'Y')
                            OR (SS.CARE_LEAVER = 'Y')
                            OR (S.CARE_EXP_EVIDENCE_RECVD = 'Y')
                            OR (S.ESTRANGED = 'Y'))
                       AND ss.session_code = SESSION_CODE_IN
                       AND S.STUD_REF_NO = STUD_REF_NO_IN;
                       
           EXCEPTION WHEN NO_DATA_FOUND THEN V_STUD_REF_NO := NULL; 
                                    WHEN others THEN
                                dbms_output.put_line('Course Change message - Not a DST case continuing'); 
        END;   
   
    IF V_STUD_REF_NO IS NOT NULL
        THEN
            V_IS_DST := 'Y';
        ELSE
            V_IS_DST := 'N';
   END IF;
   
   RETURN V_IS_DST;
   
   END GET_DST_STATUS;


   PROCEDURE UPDATE_COURSE_CHANGE (PROCESS_ID_IN    IN VARCHAR2,
                                   STUD_REF_NO_IN   IN VARCHAR2)
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      UPDATE COURSE_CHANGE CC
         SET CC.PROCESS_ID = PROCESS_ID_IN
       WHERE     CC.STUD_REF_NO = STUD_REF_NO_IN
             AND CC.CREATED_DATE =
                    (SELECT MAX (CC1.CREATED_DATE)
                       FROM COURSE_CHANGE CC1
                      WHERE     CC.STUD_REF_NO = STUD_REF_NO_IN);

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
   END UPDATE_COURSE_CHANGE;
END PK_STEPS_COURSE_CHANGE;
/