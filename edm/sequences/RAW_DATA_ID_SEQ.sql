-- Create sequence script.
--
-- MODIFICATION HISTORY
-- Ref.     Date            Author                          Desc.
--          08/01/2008  S Durkin (Sopra UK)     Initial Version
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/edm/sequences/RAW_DATA_ID_SEQ.sql $
-- $Author: $
-- $Date: 2010-10-25 15:27:57 +0100 (Mon, 25 Oct 2010) $
-- $Revision: 5871 $

DROP SEQUENCE EDM.RAW_DATA_ID_SEQ;

CREATE SEQUENCE EDM.RAW_DATA_ID_SEQ
  START WITH 1000000
  MAXVALUE 999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;



-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM RAW_DATA_ID_SEQ
/

CREATE PUBLIC SYNONYM  RAW_DATA_ID_SEQ FOR EDM.RAW_DATA_ID_SEQ
/

--
-- Administer grants
-- 
GRANT SELECT ON  EDM.RAW_DATA_ID_SEQ TO EDM_USER
/
 