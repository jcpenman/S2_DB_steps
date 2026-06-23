-- VU_HISTORY.sql
-- Description: dbView to show all audit information required to be displayed in the History UI screen
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      28.08.09    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date: $
-- $Revision: $

DROP VIEW VU_HISTORY
/

/* Formatted on 2009/08/28 10:39 (Formatter Plus v4.8.8) */
--
-- VU_HISTORY (View) 
--
CREATE OR REPLACE VIEW vu_history (stud_ref_no,
                                   aud_date,
                                   session_code,
                                   column_name,
                                   OLD,
                                   NEW,
                                   action,
                                   username
                                  )
AS
   SELECT f.stud_ref_no, e.aud_date, e.session_code, e.column_name, e.OLD, e.NEW,
       e.action, e.username
  FROM stud_aud e, stud f
 WHERE e.column_name IN ('SORT_CODE', 'ACCOUNT_NO')
   AND e.table_pkey1 = f.stud_ref_no
UNION
SELECT d.stud_ref_no, c.aud_date, c.session_code, c.column_name, c.OLD, c.NEW,
       c.action, c.username
  FROM stud_term_addr_aud c, stud_term_addr d
 WHERE c.column_name = 'LOCATION_IND' AND c.table_pkey1 = d.stud_ref_no
UNION
SELECT b.stud_ref_no, a.aud_date, a.session_code, a.column_name, a.OLD, a.NEW,
       a.action, a.username
  FROM stud_session_aud a, stud_session b
 WHERE a.column_name = 'DATE_APPLIC_RECEIVED'
   AND a.table_pkey1 = b.stud_session_id
UNION
SELECT g.stud_ref_no, h.aud_date, h.session_code, h.column_name, h.OLD, h.NEW,
       h.action, h.username
  FROM stud_crse_year_aud h, stud_crse_year g
 WHERE h.column_name IN
                     ('FIRST_CALC_DATE', 'SLC2_STATUS', 'APPLICATION_STATUS')
   AND h.table_pkey1 = g.stud_crse_year_id
UNION
SELECT l.stud_ref_no, i.aud_date, i.session_code, i.column_name, i.OLD, i.NEW,
       i.action, i.username
  FROM benefactor_income_aud i,
       benefactor_income j,
       benefactor k,
       stud_session l
 WHERE i.column_name = 'INCOME_STATUS'
   AND i.table_pkey1 = j.ben_id
   AND j.ben_id = k.ben_id
   AND k.ben_id IN (l.ben1_id);