/* Formatted on 29/10/2018 10:02:29 (QP5 v5.256.13226.35538) */
TRUNCATE TABLE CURRENT_COURSE REUSE STORAGE;

INSERT INTO CURRENT_COURSE (HEI_INST_CODE,
                            INST_CODE,
                            CAMPUS,
                            HEI_CRSE_CODE,
                            CRSE_CODE,
                            SCOTTISH,
                            HEI_CRSE_NAME,
                            SESSION_CODE,
                            DURATION)
     SELECT HC.HEI_INST_CODE,
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
                 FROM SGAS.CRSE@GRASS C,
                      SGAS.CRSE_SESSION@GRASS CS,
                      CRSE_YEAR@GRASS CY,
                      INST@GRASS I
                WHERE     C.CRSE_ID = CS.CRSE_ID
                      AND CS.SESSION_CODE IN (2018, 2017)
                      AND C.CRSE_ID = CY.CRSE_ID
                      AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
                      AND I.INST_CODE = C.INST_CODE
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



COMMIT;
