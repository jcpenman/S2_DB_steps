-- Name:Adhoc 4
-- Description: Creation of sequence for debt_status_aud table  
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      12.11.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 


--#DEBT_STATUS_AUD.DEBT_STATUS_AUD_ID SEQUENCE###############################
DROP SEQUENCE ILA500.DEBT_STATUS_AUD_ID_SEQ;

CREATE SEQUENCE ILA500.DEBT_STATUS_AUD_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


GRANT SELECT ON  ILA500.DEBT_STATUS_AUD_ID_SEQ TO PUBLIC;