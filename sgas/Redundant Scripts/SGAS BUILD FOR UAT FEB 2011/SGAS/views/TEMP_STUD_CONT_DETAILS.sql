CREATE OR REPLACE VIEW SGAS.TEMP_STUD_CONT_DETAILS
(S_STUD_REF_NO, G_STUD_REF_NO, S_CONTACT_IND, G_CONTACT_IND, S_CONT_NAME, 
 G_CONT_NAME, S_CONT_POSTCODE, G_CONT_POSTCODE, S_CONT_ADDR1, G_CONT_ADDR1, 
 S_CONT_ADDR2, G_CONT_ADDR2, S_CONT_ADDR3, G_CONT_ADDR3, S_CONT_TEL_NO, 
 G_CONT_TEL_NO, S_CONT_REL_CODE, G_CONT_REL_CODE)
AS 
select scd.stud_ref_no as s_stud_ref_no,
       scdg.stud_ref_no as g_stud_ref_no,
       scd.contact_ind as s_contact_ind,
       scdg.contact_ind as g_contact_ind, 
       scd.cont_name as s_cont_name, 
       scdg.cont_name as g_cont_name,
       scd.cont_postcode as s_cont_postcode,
       scdg.cont_postcode as g_cont_postcode,
       scd.cont_addr1 as s_cont_addr1,
       scdg.cont_addr1 as g_cont_addr1,
       scd.cont_addr2 as s_cont_addr2,
       scdg.cont_addr2 as g_cont_addr2,
       scd.cont_addr3 as s_cont_addr3,
       scdg.cont_addr3 as g_cont_addr3,
       scd.cont_tel_no as s_cont_tel_no,
       scdg.cont_tel_no as g_cont_tel_no,
       scd.cont_rel_code as s_cont_rel_code,
       scdg.cont_rel_code as g_cont_rel_code
from stud_cont_details scd, stud_cont_details@grass scdg
where scd.stud_ref_no = scdg.stud_ref_no
and scd.contact_ind = scdg.contact_ind
/


GRANT SELECT ON  SGAS.TEMP_STUD_CONT_DETAILS TO SGAS_EUL
/