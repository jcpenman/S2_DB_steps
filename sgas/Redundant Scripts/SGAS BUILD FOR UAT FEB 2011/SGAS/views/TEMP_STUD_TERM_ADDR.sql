CREATE OR REPLACE VIEW SGAS.TEMP_STUD_TERM_ADDR
(S_STUD_REF_NO, G_STUD_REF_NO, S_START_DATE, G_START_DATE, S_LOCATION_IND, 
 G_LOCATION_IND, S_RESIDENCE_IND, G_RESIDENCE_IND, S_HOUSE_NO_NAME, G_HOUSE_NO_NAME, 
 S_ADDR_L1, G_ADDR_L1, S_ADDR_L2, G_ADDR_L2, S_ADDR_L3, 
 G_ADDR_L3, S_ADDR_L4, G_ADDR_L4, S_POST_CODE, G_POST_CODE, 
 S_ADDR_EASTING, G_ADDR_EASTING, S_ADDR_NORTHING, G_ADDR_NORTHING, S_TELE_NO, 
 G_TELE_NO, S_END_DATE, G_END_DATE, S_MAILSORT, G_MAILSORT)
AS 
select stta.stud_ref_no as s_stud_ref_no,
       sttag.stud_ref_no as g_stud_ref_no,
       trunc(stta.start_date) as s_start_date,
       trunc(sttag.start_date) as g_start_date, 
       stta.location_ind as s_location_ind, 
       sttag.location_ind as g_location_ind,
       stta.residence_ind as s_residence_ind, 
       sttag.residence_ind as g_residence_ind,
       stta.house_no_name as s_house_no_name,
       sttag.house_no_name as g_house_no_name,
       stta.addr_l1 as s_addr_l1,
       sttag.addr_l1 as g_addr_l1,
       stta.addr_l2 as s_addr_l2,
       sttag.addr_l2 as g_addr_l2,
       stta.addr_l3 as s_addr_l3,
       sttag.addr_l3 as g_addr_l3,
       stta.addr_l4 as s_addr_l4,
       sttag.addr_l4 as g_addr_l4,
       stta.post_code as s_post_code,
       sttag.post_code as g_post_code,
       stta.addr_easting as s_addr_easting,
       sttag.addr_easting as g_addr_easting,
       stta.addr_northing as s_addr_northing,
       sttag.addr_northing as g_addr_northing,
       stta.tele_no as s_tele_no,
       sttag.tele_no as g_tele_no,
       stta.end_date as s_end_date,
       sttag.end_date as g_end_date,
       stta.mailsort as s_mailsort,
       sttag.mailsort as g_mailsort
from stud_term_addr stta, stud_term_addr@grass sttag
where stta.stud_ref_no = sttag.stud_ref_no
and stta.end_date is null
and sttag.end_date is null
/


GRANT SELECT ON  SGAS.TEMP_STUD_TERM_ADDR TO SGAS_EUL
/