-- Adhoc to remove all non reference data from SIT database
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      10.05.2010  A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

/* THIS SHOULD BE RUN FROM THE SIT ENVIRONMENT TO CLEAR DATA! */

--truncate table edm.raw_data;

--truncate table edm.edm_temp;

--truncate table edm.edm_complete;

truncate table sgas.stud_crse_year;

truncate table sgas.stud_crse_year_aud;

truncate table sgas.stud_cont_details;

truncate table sgas.stud_home_addr;

truncate table sgas.stud_home_addr_aud;

truncate table sgas.stud_term_addr;

truncate table sgas.stud_term_addr_aud;

truncate table sgas.award_instalment;

truncate table sgas.award_instalment_aud;

truncate table sgas.award;

truncate table sgas.award_aud;

truncate table sgas.benefactor_income;

truncate table sgas.benefactor_income_aud;

truncate table sgas.benefactor;

truncate table sgas.benefactor_aud;

truncate table sgas.benefactor_dependant;

truncate table sgas.benefactor_dependant_aud;

truncate table sgas.STEPS_LOCKS;

COMMIT;

truncate table sgas.stud_dependant;

truncate table sgas.stud_dependant_aud;

truncate table sgas.JA_CASE;

truncate table sgas.JA_CASE_AUD;

truncate table sgas.stud_session;

truncate table sgas.stud_session_aud;

truncate table sgas.stud;

truncate table sgas.stud_aud;

truncate table sgas.stud_app_prog;

truncate table sgas.stud_app_prog_aud;

truncate table sgas.edm_images;

COMMIT;

truncate table sgas.applic_reg;

truncate table sgas.authenticate_stud;

truncate table sgas.authenticate_stud_aud;

truncate table sgas.awards_recalc;

truncate table sgas.caseworker_locks;

truncate table sgas.dsa_allowance;

truncate table sgas.dsa_allowance_aud;

truncate table sgas.dsa_application;

truncate table sgas.dsa_application_aud;

truncate table sgas.dsa_payment;

truncate table sgas.dsa_payment_aud;

truncate table sgas.employee_activity;

truncate table sgas.nmsb_spec_arr;

truncate table sgas.nominee;

--truncate table sgas.steps_qa_data;

--truncate table sgas.steps_qa_data_aud;

truncate table sgas.stud_notes;

truncate table sgas.telephony;

COMMIT;






















