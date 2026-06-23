-- Drop no longer required AWARDS_RECALC table
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      12.10.10    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 


drop package sgas.pk_awards_recalc;
DROP TABLE SGAS.AWARDS_RECALC purge;


commit;