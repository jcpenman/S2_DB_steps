-- Drop no longer required objects from BUILD & SIT
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      23.11.10    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

drop package sgas.pk_steps_ui_joint_app;
drop package sgas.rules_proc_test;
drop trigger sgas.cat_iof_ins;
drop sequence sgas.doc_id_seq;
drop sequence sgas.dsa_cat_seq;
DROP SEQUENCE SGAS.STUD_NOTES_ID_SEQ;
drop sequence SGAS.aud_aud_id_seq;
drop sequence sgas.awards_recalc_id_seq;
drop sequence sgas.dac_id_seq;
drop sequence sgas.dap_id_seq;
drop sequence sgas.dar_id_seq;
drop sequence sgas.das_id_seq;
drop sequence sgas.doc_id_seq;
drop sequence sgas.dsa_cat_seq;
drop sequence sgas.dt_id_seq;
drop sequence sgas.edm_aud_id_seq;
drop sequence sgas.nom_nom_id_seq;
drop sequence sgas.sc_cha_aud_id_seq;
drop sequence sgas.sc_dat_aud_id_seq;
drop sequence sgas.sll_seq;
drop TRIGGER sgas.trig_stud_notes_seq;
DROP TABLE SGAS.INSTITUTION_CONTACT_DETAILS;
ALTER TABLE SGAS.AWARD_INSTALMENT DROP COLUMN DSA_ALLOWANCE_ID;


commit;