-- View on GRASS Reference Data
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            28.02.08   S Durkin (Sopra UK)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/views/CRSE.sql $
-- $Author: $
-- $Date: 2009-07-02 10:37:39 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3342 $

DROP VIEW SGAS.crse
/

CREATE VIEW SGAS.CRSE
AS
(
 SELECT *
 FROM CRSE@GRASS
)
/

