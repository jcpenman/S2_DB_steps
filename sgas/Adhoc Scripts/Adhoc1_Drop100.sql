-- Drop no longer required tables from SGAS Schema
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      23.10.12    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 


drop table sgas.edm_app_labels;
drop table sgas.edm_aud;
drop table sgas.edm_images_sms;
drop table sgas.edm_images_stats;
drop table sgas.edm_notes;
drop table sgas.label_print;

commit;