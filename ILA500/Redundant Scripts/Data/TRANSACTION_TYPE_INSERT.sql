-- TRANSACTION_TYPE_INSERT.sql
-- Description: Script inserts payment transaction type data for ILA500
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      07.07.08    R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Data/TRANSACTION_TYPE_INSERT.sql $
-- $Author: $
-- $Date: 2008-10-07 13:28:20 +0100 (Tue, 07 Oct 2008) $
-- $Revision: 1292 $


Insert into TRANSACTION_TYPE
   (TRANSACTION_TYPE_ID, DESCRIPTION, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   (1, 'CREDIT', 'ILA500', TO_DATE('07/07/2008 13:57:09', 'MM/DD/YYYY HH24:MI:SS'));
/
Insert into TRANSACTION_TYPE
   (TRANSACTION_TYPE_ID, DESCRIPTION, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   (2, 'DEBIT', 'ILA500', TO_DATE('07/07/2008 13:57:19', 'MM/DD/YYYY HH24:MI:SS'));
/
COMMIT
/