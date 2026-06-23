-- SEQUENCE SCRIPT FOR PK ON caseworker_note TABLE
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      25.08.08    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Sequences/CW_NOTE_ID_SEQ.sql $
-- $Author: $
-- $Date: 2008-10-08 13:41:54 +0100 (Wed, 08 Oct 2008) $
-- $Revision: 1308 $
DROP SEQUENCE cw_note_id_seq
/

--
-- cw_note_id_seq  (Sequence) 
--
CREATE SEQUENCE cw_note_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


CREATE OR REPLACE TRIGGER trig_caseworker_note_seq BEFORE INSERT ON caseworker_note
FOR EACH ROW
BEGIN
SELECT cw_note_id_seq.NEXTVAL into :new.cw_note_id FROM dual;
END;