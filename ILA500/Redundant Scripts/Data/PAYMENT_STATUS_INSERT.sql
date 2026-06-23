-- PAYMENT_STATUS_INSERT.sql
-- Description: Script inserts PAYMENT STATUS data for ILA500
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      07.07.08    R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Data/PAYMENT_STATUS_INSERT.sql $
-- $Author: $
-- $Date: 2008-10-07 13:28:20 +0100 (Tue, 07 Oct 2008) $
-- $Revision: 1292 $


Insert into PAYMENT_STATUS
   (PAYMENT_STATUS_ID, PAYMENT_DESC, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   (1, 'UNPAID', 'ILA500', TO_DATE('07/07/2008 14:08:58', 'MM/DD/YYYY HH24:MI:SS'))
/
Insert into PAYMENT_STATUS
   (PAYMENT_STATUS_ID, PAYMENT_DESC, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   (2, 'PAID', 'ILA500', TO_DATE('07/07/2008 14:09:05', 'MM/DD/YYYY HH24:MI:SS'))
/
Insert into PAYMENT_STATUS
   (PAYMENT_STATUS_ID, PAYMENT_DESC, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   (3, 'CANCELLED', 'ILA500', TO_DATE('07/07/2008 14:09:19', 'MM/DD/YYYY HH24:MI:SS'))
/
COMMIT
/
