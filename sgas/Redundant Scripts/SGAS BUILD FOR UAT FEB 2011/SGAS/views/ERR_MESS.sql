-- 
-- ERR_MESS.sql - create view script.
--
-- DESCRIPTION
-- View on GRASS reference table ERR_MESS, which holds the text for error messages
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            28.02.08   S Durkin (Sopra UK)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/views/ERR_MESS.sql $
-- $Author: $
-- $Date: 2009-07-02 10:37:39 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3342 $

DROP VIEW SGAS.err_mess
/

CREATE OR REPLACE VIEW SGAS.err_mess
AS 
(
SELECT  * 
FROM err_mess@grass
)
/

COMMENT ON TABLE SGAS.err_mess IS 'View on GRASS reference table ERR_MESS, which holds the text for error messages.'
/

CREATE PUBLIC SYNONYM ERR_MESS FOR SGAS.ERR_MESS
/
