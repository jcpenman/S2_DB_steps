-- 
-- SCOT_POSTCODE.sql - create view script.
--
-- DESCRIPTION
-- A list of all scottish small user postcodes. The view provides a filter on the data supplied by GROS. 
-- 
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            28.02.08   S Durkin (Sopra UK)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/views/SCOT_POSTCODES.sql $
-- $Author: $
-- $Date: 2009-07-02 10:37:39 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3342 $

DROP VIEW SGAS.scot_postcodes
/

CREATE OR REPLACE VIEW SGAS.scot_postcodes
(
 postcode
)
AS 
(
    SELECT p1.postcode 
    FROM postcode_archive p1 
    WHERE p1.end_date IS NULL 
)
/

COMMENT ON TABLE SGAS.scot_postcodes IS 'A list of all unique scottish small user postcodes. The view provides a filter on the data supplied by GROS'
/
COMMENT ON COLUMN SGAS.scot_postcodes.postcode IS 'Royal mail postcode.'
/