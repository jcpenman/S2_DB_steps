DROP VIEW SGAS.VU_HISTORY;

/* Formatted on 30/11/2017 14:37:21 (QP5 v5.215.12089.38647) */
CREATE OR REPLACE FORCE VIEW SGAS.VU_HISTORY
(
   STUD_REF_NO,
   AUD_DATE,
   SESSION_CODE,
   COLUMN_NAME,
   OLD,
   NEW,
   ACTION,
   USERNAME
)
AS
   SELECT f.stud_ref_no,
          e.aud_date,
          e.session_code,
          e.column_name,
          e.OLD,
          e.NEW,
          e.action,
          e.username
     FROM stud_aud e, stud f
    WHERE     e.column_name IN
                 ('SORT_CODE', 'ACCOUNT_NO', 'TITLE', 'FORENAMES', 'SURNAME')
          AND e.table_pkey1 = TO_CHAR (f.stud_ref_no)
   UNION ALL
   SELECT d.stud_ref_no,
          c.aud_date,
          c.session_code,
          c.column_name,
          c.OLD,
          c.NEW,
          c.action,
          c.username
     FROM stud_term_addr_aud c, stud_term_addr d
    WHERE     c.column_name = 'LOCATION_IND'
          AND c.table_pkey1 = TO_CHAR (d.stud_ref_no)
   UNION ALL
   SELECT b.stud_ref_no,
          a.aud_date,
          a.session_code,
          a.column_name,
          a.OLD,
          a.NEW,
          a.action,
          a.username
     FROM stud_session_aud a, stud_session b
    WHERE     a.column_name IN('DATE_APPLIC_RECEIVED','CARE_LEAVER')
          AND a.table_pkey1 = TO_CHAR (b.stud_session_id)
   UNION ALL
   SELECT g.stud_ref_no,
          h.aud_date,
          h.session_code,
          h.column_name,
          h.OLD,
          h.NEW,
          h.action,
          h.username
     FROM stud_crse_year_aud h, stud_crse_year g
    WHERE     h.column_name IN
                 ('FIRST_CALC_DATE', 'SLC2_STATUS', 'APPLICATION_STATUS')
          AND h.table_pkey1 = TO_CHAR (g.stud_crse_year_id)
   UNION ALL
   SELECT l.stud_ref_no,
          i.aud_date,
          i.session_code,
          i.column_name,
          i.OLD,
          i.NEW,
          i.action,
          i.username
     FROM benefactor_income_aud i,
          benefactor_income j,
          benefactor k,
          stud_session l
    WHERE     i.column_name = 'INCOME_STATUS'
          AND i.table_pkey1 = TO_CHAR (j.ben_id)
          AND j.ben_id = k.ben_id
          AND k.ben_id IN (l.ben1_id)
    UNION ALL
    SELECT f.stud_ref_no,
          e.aud_date,
          NULL as session_code,
          e.column_name,
          e.OLD,
          e.NEW,
          e.action,
          e.username
     FROM CESB_Flags_AUD e, stud f
    WHERE e.table_pkey1 = TO_CHAR (f.stud_ref_no);


GRANT SELECT ON SGAS.VU_HISTORY TO SGAS_EUL;

GRANT DELETE, INSERT, SELECT, UPDATE ON SGAS.VU_HISTORY TO STEPS_SGAS_ROLE;
