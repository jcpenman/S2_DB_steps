-- Adhoc Drop for SGAS
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 1.0      05.04.2011    A.Bowman (SAAS)         Initial Version.
-- 
-- Description: Dropping redundant tables and associated objects, creating new table and amending existing packages
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

drop table sgas.joint_app_relation;
drop table sgas.joint_app_relation_aud;
drop sequence sgas.joint_app_rel_aud_id_seq;
drop sequence sgas.joint_app_relation_id_seq;
drop public synonym joint_app_relation;
drop public synonym joint_app_relation_aud;

commit;