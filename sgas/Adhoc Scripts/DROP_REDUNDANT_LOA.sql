-- Drop no longer required LOA tables and package
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      25.03.10    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

drop package sgas.pop_stepsloa;
drop package sgas.m202;
drop table sgas.rep_msteps_hist_loa_award;
drop table sgas.rep_msteps_hist_loa_payments;
drop table sgas.rep_msteps_hist_loa_stud;
drop table sgas.rep_msteps_loa_award;
drop table sgas.rep_msteps_loa_payments;
drop table sgas.rep_msteps_loa_stud;

commit;