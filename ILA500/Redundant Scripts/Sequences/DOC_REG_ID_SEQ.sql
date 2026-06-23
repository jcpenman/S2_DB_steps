-- SEQUENCE SCRIPT FOR PK ON document_register TABLE
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      03.07.08    R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Sequences/DOC_REG_ID_SEQ.sql $
-- $Author: $
-- $Date: 2008-10-08 13:41:54 +0100 (Wed, 08 Oct 2008) $
-- $Revision: 1308 $
DROP SEQUENCE doc_reg_id_seq
/

--
-- doc_reg_id_seq  (Sequence) 
--
CREATE SEQUENCE doc_reg_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


CREATE OR REPLACE TRIGGER trig_document_register_seq BEFORE INSERT ON document_register
FOR EACH ROW
BEGIN
SELECT doc_reg_id_seq.NEXTVAL into :new.doc_reg_id FROM dual;
END;