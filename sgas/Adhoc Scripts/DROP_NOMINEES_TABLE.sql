-- Drop no longer required NOMINEES table
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      15.09.09    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

ALTER TABLE SGAS.nominees
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.nominees PURGE
/


commit;