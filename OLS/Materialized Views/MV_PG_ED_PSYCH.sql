CREATE MATERIALIZED VIEW SGAS.PG_ED_PSYCH (INST_CODE,CRSE_CODE,IS_LOCAL_AUTHORITY)
TABLESPACE SAAS_DATA
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
USING INDEX
            TABLESPACE SAAS_DATA
            PCTFREE    10
            INITRANS   2
            MAXTRANS   255
            STORAGE    (
                        INITIAL          64K
                        NEXT             1M
                        MINEXTENTS       1
                        MAXEXTENTS       UNLIMITED
                        PCTINCREASE      0
                        BUFFER_POOL      DEFAULT
                        FLASH_CACHE      DEFAULT
                        CELL_FLASH_CACHE DEFAULT
                       )
REFRESH COMPLETE ON DEMAND
WITH PRIMARY KEY
AS 

SELECT INST_CODE, CRSE_CODE, IS_LOCAL_AUTHORITY FROM SGAS.PG_ED_PSYCH@STEPS.WORLD;

COMMENT ON MATERIALIZED VIEW SGAS.PG_ED_PSYCH IS 'snapshot table for snapshot SGAS.PG_ED_PSYCH';


