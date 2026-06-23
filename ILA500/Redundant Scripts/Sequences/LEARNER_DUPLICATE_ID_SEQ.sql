-- SEQUENCE SCRIPT FOR PK ON learner_duplicate TABLE
-- Author R. Hunter (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      27.08.08    R.Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Sequences/LEARNER_DUPLICATE_ID_SEQ.sql $
-- $Author: $
-- $Date: 2008-10-08 13:41:54 +0100 (Wed, 08 Oct 2008) $
-- $Revision: 1308 $
DROP SEQUENCE learner_duplicate_id_seq
/

--
-- learner_duplicate_id_seq  (Sequence) 
--
CREATE SEQUENCE learner_duplicate_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


CREATE OR REPLACE TRIGGER trig_learner_duplicate_seq BEFORE INSERT ON learner_duplicate
FOR EACH ROW
BEGIN
SELECT learner_duplicate_id_seq.NEXTVAL into :new.learner_duplicate_id FROM dual;
END;