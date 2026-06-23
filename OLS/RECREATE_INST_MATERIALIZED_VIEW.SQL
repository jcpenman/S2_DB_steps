DROP MATERIALIZED VIEW INST;
CREATE MATERIALIZED VIEW INST (INST_CODE,INST_TYPE_ID,INST_NAME,COLLEGE_TYPE,LOCATION_IND,NON_PUBLIC_FUND)
TABLESPACE SAAS_DATA
LOGGING
BUILD IMMEDIATE
USING INDEX
            TABLESPACE SAAS_DATA
REFRESH FAST
START WITH SYSDATE
WITH ROWID
AS 
/* Formatted on 15/11/2018 13:39:39 (QP5 v5.256.13226.35538) */
SELECT inst_code,
       inst_type_id,
       inst_name,
       college_type,
       location_ind,
       non_public_fund
  FROM inst@steps.world
 WHERE     inst_name NOT LIKE '%Z%REFUS%'
       AND inst_name NOT LIKE '1998/99 ENGLAND % WALES';


COMMENT ON MATERIALIZED VIEW INST IS 'snapshot table for snapshot SGAS.PG_ED_PSYCH';

-- Note: Index I_SNAP$_INST will be created automatically 
--       by Oracle with the associated materialized view.
