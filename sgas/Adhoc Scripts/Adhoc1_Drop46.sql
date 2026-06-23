-- Drop no longer required table and trigger
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      15.08.11    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 


drop trigger sgas.pay_err_iud;
drop table sgas.payment_errors_aud;
DROP SEQUENCE SGAS.PAY_ERR_AUD_ID_SEQ;

EXEC DBMS_UTILITY.compile_schema(schema => 'SGAS');


commit;