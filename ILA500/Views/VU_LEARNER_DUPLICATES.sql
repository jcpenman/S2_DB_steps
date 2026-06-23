-- VU_LEARNER_DUPLICATES.sql
-- Description: dbView holding all learner/stud duplicates in ILA/GRASS/StEPS 
-- Author J.Penman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      18.07.08    J.Penman (SAAS)         Initial Version.
-- 1.1	27.08.08	A.Anchev			Modified to select session specific data for GRASS and STEPS
-- 
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Views/VU_LEARNER_DUPLICATES.sql $
-- $Author: $
-- $Date: 2008-10-07 13:46:57 +0100 (Tue, 07 Oct 2008) $
-- $Revision: 1295 $
CREATE OR REPLACE VIEW VU_LEARNER_DUPLICATES
(SOURCE_DATABASE, SESSION_YEAR, REF_NUM, FIRST_NAME, LAST_NAME, DOB)
AS 
(
SELECT 'ILA500' AS source_database, null AS session_year, l.learner_id AS ref_num,
       l.forename AS first_name, l.surname AS last_name, l.dob AS dob
  FROM learner l
UNION
SELECT 'GRASS' AS source_database, s.session_code AS session_year, to_char(s.stud_ref_no) AS ref_num,
       s.forenames AS first_name, s.surname AS last_name, s.dob AS dob
  FROM stud_session@grass s
UNION
SELECT 'STEPS' AS source_database, sg.session_code AS session_year, to_char(sg.stud_ref_no) AS ref_num,
       sg.forenames AS first_name, sg.surname AS last_name, sg.dob AS dob
  FROM sgas.stud_session sg
UNION   
SELECT 'ILA200' AS source_database, null AS session_year, to_char(il.id) AS ref_num,
       il.forenames AS first_name, il.surname AS last_name, il.dob AS dob
  FROM learner@ila200 il
)
/



