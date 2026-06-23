--
-- Description: This job picks up password letter requests from the WEB
--
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 1.0      05.03.2010    A.Bowman (SAAS)         Initial Version.
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
     ,what      => 'DECLARE    ERROR_MESSAGE      VARCHAR2 (100); BEGIN   pk_steps_web.password_letter_requests (ERROR_MESSAGE); DBMS_OUTPUT.put_line (ERROR_MESSAGE); END;'
     ,next_date => to_date('05/03/2010 15:30:00','dd/mm/yyyy hh24:mi:ss')
     ,interval  => 'SYSDATE+15/1440 '
     ,no_parse  => TRUE
    );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));

--  SYS.DBMS_JOB.BROKEN
--  (job => X,
--   broken => TRUE);

END;
/


commit;