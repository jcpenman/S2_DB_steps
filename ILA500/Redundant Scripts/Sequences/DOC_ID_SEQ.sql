-- SEQUENCE SCRIPT FOR PK ON SHELL_LETTER TABLE
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      10.10.08    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date:  $
-- $Revision: $

--#SHELL_LETTER.DOC.ID SEQUENCE###############################

DROP SEQUENCE doc_id_seq;

CREATE SEQUENCE doc_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;

GRANT SELECT ON doc_id_seq
TO PUBLIC;
