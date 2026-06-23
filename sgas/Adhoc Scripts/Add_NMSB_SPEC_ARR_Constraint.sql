-- New constraint required for NMSB_SPEC_ARR table
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      24.03.2010  A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

Alter table nmsb_spec_arr
Add CONSTRAINT nmsb_spec_arr_uk UNIQUE (stud_ref_no, session_code);


commit;