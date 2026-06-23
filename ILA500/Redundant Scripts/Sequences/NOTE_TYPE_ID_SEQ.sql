-- SEQUENCE SCRIPT FOR PK ON NOTE_TYPE TABLE
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      10.10.08    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date:  $
-- $Revision: $
DROP SEQUENCE note_type_id_seq
/

--
-- note_type_id_seq  (Sequence) 
--
CREATE SEQUENCE note_type_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/

CREATE OR REPLACE TRIGGER trig_note_type_seq BEFORE INSERT ON note_type
FOR EACH ROW
BEGIN
SELECT note_type_id_seq.NEXTVAL into :new.note_type_id FROM dual;
END;

