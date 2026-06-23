/* Formatted on 13/09/2018 10:39:11 (QP5 v5.256.13226.35538) */
--DROP TABLE COLLEGE_INST_LINK;

CREATE TABLE COLLEGE_INST_LINK

AS
   SELECT i.hei_inst_code, i.inst_code
     FROM sgas.inst@grass i
    WHERE     i.hei_inst_code IS NOT NULL
          AND i.hei_inst_code IN (  SELECT i1.hei_inst_code
                                      FROM sgas.inst@grass i1
                                     WHERE hei_inst_code IS NOT NULL
                                  GROUP BY i1.hei_inst_code
                                    HAVING COUNT (DISTINCT i1.inst_code) > 1)
          AND EXISTS
                 (SELECT 1
                    FROM sgas.crse_session@grass cs, sgas.crse@grass c
                   WHERE     c.crse_id = cs.crse_id
                   and cs.session_code IN ( 2017, 2018)
                         AND c.inst_code = i.inst_code)
                         order by 1,2;


DELETE FROM COLLEGE_INST_LINK C
      WHERE C.HEI_INST_CODE NOT IN (  SELECT C1.HEI_INST_CODE
                                        FROM COLLEGE_INST_LINK C1
                                    GROUP BY C1.HEI_INST_CODE
                                      HAVING COUNT (0) > 1);
                                      
COMMIT;                                      