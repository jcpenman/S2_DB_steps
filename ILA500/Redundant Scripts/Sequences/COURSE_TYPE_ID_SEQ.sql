-- SEQUENCE SCRIPT FOR PK ON COURSE_TYPE TABLE
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      03.07.08    R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Sequences/COURSE_TYPE_ID_SEQ.sql $
-- $Author: $
-- $Date: 2008-10-08 13:41:54 +0100 (Wed, 08 Oct 2008) $
-- $Revision: 1308 $
DROP SEQUENCE course_type_id_seq
/

--
-- course_type_id_seq  (Sequence) 
--
CREATE SEQUENCE course_type_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


CREATE OR REPLACE TRIGGER trig_COURSE_TYPE_seq BEFORE INSERT ON COURSE_TYPE
FOR EACH ROW
BEGIN
SELECT course_type_id_seq.NEXTVAL into :new.course_type_id FROM dual;
END;