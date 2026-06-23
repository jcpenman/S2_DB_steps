-- Create sequence script.
--
-- MODIFICATION HISTORY
-- Ref.     Date            Author                          Desc.
--          08/01/2008  S Durkin (Sopra UK)     Initial Version
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/edm/sequences/EDM_PICK_LIST_ID_SEQ.sql $
-- $Author: $
-- $Date: 2010-10-25 15:27:57 +0100 (Mon, 25 Oct 2010) $
-- $Revision: 5871 $

DROP SEQUENCE EDM.EDM_PICK_LIST_ID_SEQ;

CREATE SEQUENCE EDM.EDM_PICK_LIST_ID_SEQ
  START WITH 1000000
  MAXVALUE 999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;

DROP PUBLIC SYNONYM EDM_PICK_LIST_ID_SEQ
/

CREATE PUBLIC SYNONYM EDM_PICK_LIST_ID_SEQ FOR EDM.EDM_PICK_LIST_ID_SEQ
/


--
-- Administer grants
-- 
GRANT SELECT ON  EDM.EDM_PICK_LIST_ID_SEQ TO PUBLIC
/
