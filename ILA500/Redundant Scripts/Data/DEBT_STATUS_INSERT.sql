-- DEBT_STATUS_INSERT.sql
-- Description: Script inserts debt status data for ILA500
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      11.11.08    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date: $
-- $Revision: $


Insert into DEBT_STATUS
   (DEBT_STATUS_ID, DEBT_STATUS_DESC) 
 Values
   (1, 'NOT RECOVERED');
Insert into DEBT_STATUS
   (DEBT_STATUS_ID, DEBT_STATUS_DESC)
 Values
   (2, 'RECOVERED AUTOMATICALLY');
Insert into DEBT_STATUS
   (DEBT_STATUS_ID, DEBT_STATUS_DESC)
 Values
   (3, 'RECOVERED MANUALLY');
COMMIT
/