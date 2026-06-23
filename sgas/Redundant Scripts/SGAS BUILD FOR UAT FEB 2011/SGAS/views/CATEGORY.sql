-- 
-- Category.sql - create view script.
-- 
-- DESCRIPTION 
REM DEPRECATED 
-- The category view is a transitional view to support old code which previously referenced 
-- the category table in GRASS. The category view replicates the category table from GRASS. It presents 
-- a view of the reference_data data consistent with the original category table.
-- This view is to be removed when dependencies on the category table have been removed from the system. 
-- New application code should not use this view. 
-- 
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            28.02.08   S Durkin (Sopra UK)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/views/CATEGORY.sql $
-- $Author: $
-- $Date: 2009-07-02 10:37:39 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3342 $

ALTER view SGAS.category
 DROP PRIMARY KEY
/

DROP VIEW SGAS.category
/

CREATE OR REPLACE VIEW SGAS.category
(
 id, -- cat_type 
 type,
 descript
)
AS 
(
SELECT  d.id
,       t.grass_code
,       d.description
FROM reference_data d
,    reference_types t
WHERE t.grass_code IS NOT Null
AND d.ref_type_id = t.id
)
/

COMMENT ON TABLE SGAS.category IS 'DEPRECATED: This view replicates the GRASS category table. It is TRANSITIONAL as the original GRASS category structure is deprecated in STEPS and should be dropped.'
/
COMMENT ON COLUMN SGAS.category.id IS 'System reference - internal unique identifier.'
/
COMMENT ON COLUMN SGAS.category.type IS 'The category type. (From reference_types)'
/
COMMENT ON COLUMN SGAS.category.descript IS 'Free text description of the category.'
/

ALTER VIEW SGAS.category ADD (
  CONSTRAINT c_pk
  PRIMARY KEY (id)
  DISABLE NOVALIDATE
)
/

GRANT SELECT ON  SGAS.CATEGORY TO PUBLIC
/