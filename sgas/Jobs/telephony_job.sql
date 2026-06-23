--
-- Description: This job sends the telephony file to Contact Central
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      18.11.09    R Hunter (SAAS)         Initial Version.
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
     ,what      => 'DECLARE   error_boolean   VARCHAR2 (100); ERROR_TEXT      VARCHAR2 (100); BEGIN   pk_steps_telephony.send_telephony_file (error_boolean, ERROR_TEXT); DBMS_OUTPUT.put_line (error_boolean || ERROR_TEXT); END;'
     ,next_date => SYSDATE,
     ,interval  => 'sysdate + 1/288'
     ,no_parse  => TRUE
    );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
END;
/

commit;