-- SEQUENCE SCRIPT FOR PK ON COURSE_LEVEL TABLE
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      03.07.08    R Hunter (SAAS)         Initial Version.
-- 1.1      14.07.09    A.Bowman (SAAS)         Amended seq to start with 100, this is to handle the
--                                              inclusion of default course_id value of 99.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Sequences/COURSE_ID_SEQ.sql $
-- $Author: $
-- $Date: 2009-07-14 14:12:34 +0100 (Tue, 14 Jul 2009) $
-- $Revision: 3403 $
DROP SEQUENCE course_id_seq
/

--
-- course_id_seq  (Sequence) 
--
CREATE SEQUENCE course_id_seq
  START WITH 100
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


CREATE OR REPLACE TRIGGER trig_course_level_seq BEFORE INSERT ON COURSE_LEVEL
FOR EACH ROW
BEGIN
SELECT course_id_seq.NEXTVAL into :new.course_id FROM dual;
END;