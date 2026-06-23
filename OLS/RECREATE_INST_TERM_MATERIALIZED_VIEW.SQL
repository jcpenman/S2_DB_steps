DROP MATERIALIZED VIEW INST_TERM;
CREATE MATERIALIZED VIEW INST_TERM (INST_CODE,SESSION_CODE,TERM_NO,START_DATE,END_DATE,DAYS)
TABLESPACE SAAS_DATA
LOGGING
BUILD IMMEDIATE
USING INDEX
            TABLESPACE SAAS_DATA
REFRESH FAST
START WITH SYSDATE
WITH ROWID
AS 
/* Formatted on 15/11/2018 13:40:09 (QP5 v5.256.13226.35538) */
SELECT inst_code,
       session_code,
       term_no,
       start_date,
       end_date,
       days
  FROM inst_term@steps.world;


COMMENT ON MATERIALIZED VIEW INST_TERM IS 'snapshot table for snapshot SGAS.PG_ED_PSYCH';

-- Note: Index I_SNAP$_INST_TERM will be created automatically 
--       by Oracle with the associated materialized view.
