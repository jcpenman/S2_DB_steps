-- 
--reference_domains.sql - create table script.
--
-- DESCRIPTION
-- reference_domains are the generic domains or groupings for general lookup information in steps.
-- The data held in the reference_data table is not specific to any one part of the system. It is 
-- all static data.
-- 
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            28.02.08   S Durkin (Sopra UK)         Initial Version.
-- 001      03.02.10    A.Bowman (SAAS)              Added data insert script
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/REFERENCE_DOMAINS.sql $
-- $Author: $
-- $Date: 2010-02-03 11:35:48 +0000 (Wed, 03 Feb 2010) $
-- $Revision: 4733 $

ALTER TABLE SGAS.reference_domains
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.reference_domains CASCADE CONSTRAINTS
/

--
-- dsa_casenotes (Table)
--
CREATE TABLE SGAS.reference_domains
(
 domain_name VARCHAR2(100),
 description VARCHAR2(4000)  -- Free text description or the type. 
)
/

--
-- Column comments
-- 
COMMENT ON TABLE SGAS.reference_domains IS 'Reference data types.'
/
COMMENT ON COLUMN SGAS.reference_domains.domain_name IS 'Domain name.'
/
COMMENT ON COLUMN SGAS.reference_domains.description IS 'Free text description of the type or domain.'
/

ALTER TABLE SGAS.reference_domains ADD (
  CONSTRAINT p_cd
 PRIMARY KEY
 (domain_name)
)
/

--- SET DEFINE OFF;
Insert into REFERENCE_DOMAINS
   (DOMAIN_NAME, DESCRIPTION)
 Values
   ('GRASS_CATEGORIES', NULL);
Insert into REFERENCE_DOMAINS
   (DOMAIN_NAME, DESCRIPTION)
 Values
   ('APPLICATION_REF', NULL);
Insert into REFERENCE_DOMAINS
   (DOMAIN_NAME, DESCRIPTION)
 Values
   ('BINARY_VALUES', NULL);
Insert into REFERENCE_DOMAINS
   (DOMAIN_NAME, DESCRIPTION)
 Values
   ('STATES', NULL);
Insert into REFERENCE_DOMAINS
   (DOMAIN_NAME, DESCRIPTION)
 Values
   ('PERSONAL_STATUS', NULL);
Insert into REFERENCE_DOMAINS
   (DOMAIN_NAME, DESCRIPTION)
 Values
   ('RELATIONS', NULL);
COMMIT;

