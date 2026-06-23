
DROP MATERIALIZED VIEW CURRENT_GRASS_TERM;

CREATE TABLE CURRENT_GRASS_TERM
   (
   HEI_CRSE_CODE,
   ACADEMIC_YEAR,
   TERM,
   TERM_START,
   TERM_END,
   SESSION_CODE,
   FEES,
   CRSE_YEAR_ID,
   CRSE_ID,
   SCHEME_TYPE,
   RUK
   )
   TABLESPACE SLC_DATA
   LOGGING
AS
   SELECT /*+ PARALLEL( CS,8 )PARALLEL( CY,8 )  */
          DISTINCT NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) HEI_CRSE_CODE,
                   CY.CRSE_YEAR_NO ACADEMIC_YEAR,
                   CT.TERM_NO TERM,
                   CT.START_DATE TERM_START,
                   CT.END_DATE TERM_END,
                   CS.SESSION_CODE SESSION_CODE,
                   NVL (CY.VAR_TUITION_FEE_AMNT, -1) FEES,
                   CY.CRSE_YEAR_ID,
                   C.CRSE_ID,
                   C.SCHEME_TYPE,
                   CASE
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
     FROM SGAS.CRSE C,
          SGAS.CRSE_SESSION CS,
          SGAS.CRSE_YEAR CY,
          SGAS.INST I,
          SGAS.CRSE_TERM CT,
          HEI_CRSE@grass HC
    WHERE     C.CRSE_ID = CS.CRSE_ID
          AND CS.SESSION_CODE IN (TO_CHAR (SYSDATE, 'YYYY') + 1,
                                  TO_CHAR (SYSDATE, 'YYYY'),
                                  TO_CHAR (SYSDATE, 'YYYY') - 1)
          AND C.CRSE_ID = CY.CRSE_ID
          AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
          AND I.INST_CODE = C.INST_CODE
          AND CY.CRSE_YEAR_ID = CT.CRSE_YEAR_ID
          AND NVL (CY.DEFAULT_TERMS, 'N') != 'Y'
          AND (   NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) = HC.HEI_CRSE_CODE
               OR NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) =
                     TO_CHAR (HC.SLC_COURSE_CODE))
          AND HC.HEI_INST_CODE = I.HEI_INST_CODE
   UNION
   SELECT /*+ PARALLEL( CS,8 )PARALLEL( CY,8 )  */
          DISTINCT NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) HEI_CRSE_CODE,
                   CY.CRSE_YEAR_NO ACADEMIC_YEAR,
                   IT.TERM_NO TERM,
                   IT.START_DATE TERM_START,
                   IT.END_DATE TERM_END,
                   CS.SESSION_CODE SESSION_CODE,
                   NVL (CY.VAR_TUITION_FEE_AMNT, -1) FEES,
                   CY.CRSE_YEAR_ID,
                   C.CRSE_ID,
                   C.SCHEME_TYPE,
                   CASE
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
     FROM SGAS.CRSE C,
          SGAS.CRSE_SESSION CS,
          SGAS.CRSE_YEAR CY,
          SGAS.INST I,
          SGAS.INST_TERM IT,
          HEI_CRSE@grass HC
    WHERE     C.CRSE_ID = CS.CRSE_ID
          AND CS.SESSION_CODE IN (TO_CHAR (SYSDATE, 'YYYY') + 1,
                                  TO_CHAR (SYSDATE, 'YYYY'),
                                  TO_CHAR (SYSDATE, 'YYYY') - 1)
          AND C.CRSE_ID = CY.CRSE_ID
          AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
          AND I.INST_CODE = C.INST_CODE
          AND NVL (CY.DEFAULT_TERMS, 'N') = 'Y'
          AND (   NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) = HC.HEI_CRSE_CODE
               OR NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) =
                     TO_CHAR (HC.SLC_COURSE_CODE))
          AND HC.HEI_INST_CODE = I.HEI_INST_CODE
          AND C.INST_CODE = IT.INST_CODE
          AND CS.SESSION_CODE = IT.SESSION_CODE
   UNION
   SELECT /*+ PARALLEL( CS,8 )PARALLEL( CY,8 )  */
          DISTINCT NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) HEI_CRSE_CODE,
                   CY.CRSE_YEAR_NO ACADEMIC_YEAR,
                   0 TERM,
                   SYSDATE + 1000 TERM_START,
                   SYSDATE + 1000 TERM_END,
                   CS.SESSION_CODE SESSION_CODE,
                   NVL (CY.VAR_TUITION_FEE_AMNT, -1) FEES,
                   CY.CRSE_YEAR_ID,
                   C.CRSE_ID,
                   C.SCHEME_TYPE,
                   CASE
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
     FROM SGAS.CRSE C,
          SGAS.CRSE_SESSION CS,
          SGAS.CRSE_YEAR CY,
          SGAS.INST I,
          HEI_CRSE@grass HC
    WHERE     C.CRSE_ID = CS.CRSE_ID
          AND CS.SESSION_CODE IN (TO_CHAR (SYSDATE, 'YYYY') + 1,
                                  TO_CHAR (SYSDATE, 'YYYY'),
                                  TO_CHAR (SYSDATE, 'YYYY') - 1)
          AND C.CRSE_ID = CY.CRSE_ID
          AND CS.CRSE_SESSION_ID = CY.CRSE_SESSION_ID
          AND I.INST_CODE = C.INST_CODE
          AND NVL (CY.DEFAULT_TERMS, 'N') = 'Y'
          AND (   NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) = HC.HEI_CRSE_CODE
               OR NVL (CY.HEI_CRSE_CODE, C.HEI_CRSE_CODE) =
                     TO_CHAR (HC.SLC_COURSE_CODE))
          AND HC.HEI_INST_CODE = I.HEI_INST_CODE
          AND NOT EXISTS
                     (SELECT 1
                        FROM SGAS.INST_TERM IT
                       WHERE     C.INST_CODE = IT.INST_CODE
                             AND CS.SESSION_CODE = IT.SESSION_CODE);


   
    
CREATE INDEX CGT1_IND1
   ON CURRENT_GRASS_TERM (HEI_CRSE_CODE, CRSE_ID)
   LOGGING
   TABLESPACE SLC_DATA;
   