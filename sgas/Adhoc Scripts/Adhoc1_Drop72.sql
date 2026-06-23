-- Amend size of column on FEE_LOAN_TRANSACTION
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      05.04.12    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

Alter table fee_loan_transaction modify (payment_id number(10));

Insert into CONFIG_DATA
   (ITEM_NAME, NVAL)
 Values
   ('SEAS_AC_YEAR', 2012);

commit;