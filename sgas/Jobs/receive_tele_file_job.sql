--
-- Description: This job picks up the telephony file from Contact Central
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      20.11.09    A.Bowman (SAAS)        Initial Version.
--
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date: $
-- $Revision: $

DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
    ( job       => X 
     ,what      => 'DECLARE   error_boolean   VARCHAR2 (100); ERROR_TEXT      VARCHAR2 (100); BEGIN   pk_steps_telephony.receive_telephony_file (error_boolean, ERROR_TEXT); DBMS_OUTPUT.put_line (error_boolean || ERROR_TEXT); END;'
     ,next_date => sysdate
     ,interval  => 'sysdate + 1/48'
     ,no_parse  => TRUE
    );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
END;
/

commit;