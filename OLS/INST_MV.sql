DROP MATERIALIZED VIEW INST;
CREATE MATERIALIZED VIEW INST (INST_CODE,INST_TYPE_ID,INST_NAME,COLLEGE_TYPE,LOCATION_IND,NON_PUBLIC_FUND)
TABLESPACE SAAS_DATA
LOGGING
BUILD IMMEDIATE
USING INDEX
            TABLESPACE SAAS_DATA
REFRESH FAST
START WITH TO_DATE('15-06-2017 06:00:00','dd-mm-yyyy hh24:mi:ss')
WITH ROWID
AS 
/* Formatted on 14/06/2017 14:09:36 (QP5 v5.256.13226.35538) */
SELECT inst_code,
       inst_type_id,
       inst_name,
       college_type,
       location_ind,
       non_public_fund
  FROM inst@grass.world
 WHERE     inst_name NOT LIKE '%Z%REFUS%'
       AND inst_name NOT LIKE '1998/99 ENGLAND % WALES';


COMMENT ON MATERIALIZED VIEW INST IS 'snapshot table for snapshot SGAS.INST';

-- Note: Index I_SNAP$_INST will be created automatically 
--       by Oracle with the associated materialized view.
