-- Drop no longer required DSA tables
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      18.09.09    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

ALTER TABLE SGAS.dsa_approvals
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_approvals PURGE
/

ALTER TABLE SGAS.dsa_arrangements
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_arrangements PURGE
/

ALTER TABLE SGAS.dsa_assessment_centres
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_assessment_centres PURGE
/

ALTER TABLE SGAS.dsa_assessments
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_assessments PURGE
/

ALTER TABLE SGAS.dsa_casenotes
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_casenotes PURGE
/

ALTER TABLE SGAS.dsa_categories
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_categories PURGE
/

ALTER TABLE SGAS.dsa_types
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_types PURGE
/

ALTER TABLE SGAS.dsa_max_awards
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_max_awards PURGE
/

commit;