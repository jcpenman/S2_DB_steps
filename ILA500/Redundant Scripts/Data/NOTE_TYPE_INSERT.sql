-- NOTE_TYPE.sql
-- Description: Table holding list of all document types
-- Author P Hughes.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                 Desc.
-- 001      05.06.08    P Hughes (SAAS)        Initial Version.
-- 002      11.09.08    A.Bowman (SAAS)        Added new note_type
-- 003      17.10.08    A.Bowman (SAAS)        Removed note_type_id as this will be created by a sequence, issue found when deploying to SIT
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Data/NOTE_TYPE_INSERT.sql $
-- $Author: $
-- $Date: 2008-10-17 12:14:40 +0100 (Fri, 17 Oct 2008) $
-- $Revision: 1394 $


SET DEFINE OFF;
Insert into NOTE_TYPE
   (DESCRIPTION, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   ('TELEPHONE','ILA500',SYSDATE); 
Insert into NOTE_TYPE
   (DESCRIPTION, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   ('EMAIL','ILA500',SYSDATE);
Insert into NOTE_TYPE
   (DESCRIPTION, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   ('WRITTEN CORRESPONDENCE','ILA500',SYSDATE);
Insert into NOTE_TYPE
   (DESCRIPTION, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   ('FAX CORRESPONDENCE','ILA500',SYSDATE);
---002
Insert into NOTE_TYPE
   (DESCRIPTION, LAST_UPDATED_BY, LAST_UPDATED_ON)
 Values
   ('CASEWORKER NOTE','ILA500',SYSDATE); 
COMMIT;
