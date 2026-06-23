-- SEQUENCE SCRIPT FOR PK ON learner_payment TABLE
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      03.07.08    R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Sequences/LEARNER_PAYMENT_ID_SEQ.sql $
-- $Author: $
-- $Date: 2008-10-08 13:41:54 +0100 (Wed, 08 Oct 2008) $
-- $Revision: 1308 $
DROP SEQUENCE learner_payment_id_seq
/

--
-- learner_payment_id_seq  (Sequence) 
--
CREATE SEQUENCE learner_payment_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


CREATE OR REPLACE TRIGGER trig_learner_payment_seq BEFORE INSERT ON learner_payment
FOR EACH ROW
BEGIN
SELECT learner_payment_id_seq.NEXTVAL into :new.learner_payment_id FROM dual;
END;