-- 
--reference_types.sql - create table script.
--
-- DESCRIPTION
-- reference_types are the generic domains or groupings for general lookup information in steps.
-- The data held in the reference_data table is not specific to any one part of the system. It is 
-- all static data.
-- 
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            28.02.08   S Durkin (Sopra UK)         Initial Version.
-- 001      03.02.10    A.Bowman (SAAS)              Added data insert script
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/REFERENCE_TYPES.sql $
-- $Author: $
-- $Date: 2010-02-03 11:35:48 +0000 (Wed, 03 Feb 2010) $
-- $Revision: 4733 $

ALTER TABLE SGAS.reference_types
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.reference_types CASCADE CONSTRAINTS
/

--
-- reference types
--
CREATE TABLE SGAS.reference_types
(
 id          NUMBER(10), -- Sys id. 
 domain      VARCHAR2(100), -- general grouping. E,g, "binary values"
 name        VARCHAR2(100), -- Will hold old category "type" values. 
 grass_code  VARCHAR2(1),   -- The old GRASS type designation .  For transition only.
 description VARCHAR2(4000)  -- Free text description or the type. 
)
/

--
-- Column comments
-- 
COMMENT ON COLUMN SGAS.reference_types.id IS 'System reference: Category Type unique ID'
/
COMMENT ON COLUMN SGAS.reference_types.domain IS 'General category type group, such as relationships or binary values'
/
COMMENT ON COLUMN SGAS.reference_types.name IS 'Category type name.'
/
COMMENT ON COLUMN SGAS.reference_types.grass_code IS 'Old GRASS type deignation. For transition only.'
/
COMMENT ON COLUMN SGAS.reference_types.description IS 'Free text description of the type or domain.'
/

ALTER TABLE SGAS.reference_types ADD (
  CONSTRAINT p_ref
 PRIMARY KEY
 (id)
)
/

ALTER TABLE SGAS.REFERENCE_TYPES ADD (
  CONSTRAINT F_RDM1 
 FOREIGN KEY (DOMAIN) 
 REFERENCES REFERENCE_DOMAINS (DOMAIN_NAME))
/

--- SET DEFINE OFF;
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (1, 'GRASS_CATEGORIES', NULL, 'D', 'The type of document sent to the agency in support of a students award application.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (2, 'GRASS_CATEGORIES', NULL, 'P', 'Parental relationships to the student, e.g. Father.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (3, 'GRASS_CATEGORIES', NULL, 'O', 'Spouse relationships to the student, e.g. Wife.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (4, 'GRASS_CATEGORIES', NULL, 'U', 'Familial relationship to the student, e.g. brother, uncle etc.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (5, 'GRASS_CATEGORIES', NULL, 'H', 'Child relationships to the student, e.g. Son.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (6, 'GRASS_CATEGORIES', NULL, 'I', 'The type of institution e.g. University.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (7, 'GRASS_CATEGORIES', NULL, 'E', 'The generalised place into which the students permanent residence may be allocated eg Scotland / elsewhere.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (8, 'GRASS_CATEGORIES', NULL, 'S', 'The subject reference_data used to label SSS scheme courses.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (9, 'GRASS_CATEGORIES', NULL, 'A', 'The disability reference_data used when a student claims DSA.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (10, 'GRASS_CATEGORIES', NULL, 'F', 'The category of RAG folders.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (11, 'GRASS_CATEGORIES', NULL, 'G', 'The code of the geographical region that an institution is in');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (12, 'GRASS_CATEGORIES', NULL, 'C', 'The type of a college. TODO: This description from the spec. does not tally with the data.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (13, 'GRASS_CATEGORIES', NULL, 'R', 'Returning Student. Deprecated - Previously used in GRASS for the Graduate Endowment Deferral Reason.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (14, 'GRASS_CATEGORIES', NULL, 'N', 'Missing NINO reason');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (15, 'APPLICATION_REF', 'SAAS_SCHEME', NULL, 'Valid SAAS steps schemes');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (16, 'APPLICATION_REF', 'CORRESPONDENCE', NULL, 'Type of documentation sent to the agency in support of an application.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (17, 'APPLICATION_REF', 'AWARDS', NULL, 'Result of the award bering calculated either by system or by the caseworker.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (18, 'APPLICATION_REF', 'PAYMENT_METHOD', NULL, 'Method used to make payments to the student.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (19, 'APPLICATION_REF', 'PGCE_SUBJECTS', NULL, 'PGCE Course subjects. e.g. english, mathematics, chemistry...');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (20, 'APPLICATION_REF', 'LOCATION', NULL, 'Regional locations relevant to the application such as `` - NOT specific geographic areas: See COUNTRY table');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (21, 'APPLICATION_REF', 'FEE_LOAN', NULL, 'Standard fee loan related comments.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (22, 'APPLICATION_REF', 'OTHER_LOAN', NULL, 'Standard other loan type related comments');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (23, 'APPLICATION_REF', 'DUP_BANK_ACC', NULL, 'Standard explanations for duplicate bank account details in STEPS.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (24, 'APPLICATION_REF', 'HEY_NO_NINO', NULL, 'Reasons for no national insurance number.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (25, 'STATES', 'DEBT_STATUS', NULL, 'Overpayment status.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (26, 'STATES', 'CASE_STATUS', NULL, 'Application case status codes e.g. New, Returned- Not system codes.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (27, 'STATES', 'Z_REF', NULL, 'Z-Ref Status - TODO: clarify what this is!');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (28, 'STATES', 'INCOME_TYPE', NULL, 'At time of writing incomes may be current or previous.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (29, 'STATES', 'INCOME_STATUS', NULL, 'Valid income states e.g. provisional.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (30, 'STATES', 'LOAN_STATUS', NULL, 'Valid status values for loan applications.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (31, 'BINARY_VALUES', 'YORN', NULL, 'Binary yes or no');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (32, 'BINARY_VALUES', 'TORF', NULL, 'Binary true or false');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (33, 'PERSONAL_STATUS', 'MARITAL_STATUS', NULL, 'Marital status e.g. Married, Single etc.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (34, 'PERSONAL_STATUS', 'EMPLOYMENT_STATUS', NULL, 'Standard descriptions of emplyment status');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (35, 'PERSONAL_STATUS', 'SPOUSE_TYPE', NULL, 'Standard names of marital relationships: husband, wife, partner, etc.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (36, 'PERSONAL_STATUS', 'DISABILITY_TYPE', NULL, 'Standard STEPS disability codes.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (37, 'RELATIONS', 'JOINT_APPLICATIONS', NULL, 'Familial relationship types relevant to joint-applications.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (38, 'RELATIONS', 'SUPPLEMENTARY_GRANTS', NULL, 'Familial relationship types relevant to supplementary grants.');
Insert into REFERENCE_TYPES
   (ID, DOMAIN, NAME, GRASS_CODE, DESCRIPTION)
 Values
   (39, 'RELATIONS', 'BENEFACTOR', NULL, 'Familial relationship types relevant to benefactor types.');
COMMIT;
