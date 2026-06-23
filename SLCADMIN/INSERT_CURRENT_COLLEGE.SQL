/* Formatted on 17/10/2018 14:30:08 (QP5 v5.256.13226.35538) */
INSERT INTO CURRENT_COLLEGE (HEI_INST_CODE,
                             INST_CODE,
                             HEI_INST_NAME,
                             SESSION_CODE,
                             MAX_FEE)
     SELECT DISTINCT I.HEI_INST_CODE HEI_INST_CODE,
                     I.INST_CODE INST_CODE,
                     HI.HEI_INST_NAME HEI_INST_NAME,
                     TO_CHAR (MAX (CS.SESSION_CODE)) SESSION_CODE,
                     9000 MAX_FEE
       FROM SGAS.INST@GRASS I,
            SGAS.CRSE@GRASS C,
            SGAS.HEI_INST@GRASS HI,
            SGAS.CRSE_SESSION@GRASS CS
      WHERE     I.INST_CODE = C.INST_CODE
            AND I.HEI_INST_CODE = HI.HEI_INST_CODE
            AND I.HEI_INST_CODE IS NOT NULL
            AND C.CRSE_ID = CS.CRSE_ID
            AND CS.SESSION_CODE IN (2018, 2017)
   GROUP BY I.HEI_INST_CODE, I.INST_CODE, HI.HEI_INST_NAME;

COMMIT;
