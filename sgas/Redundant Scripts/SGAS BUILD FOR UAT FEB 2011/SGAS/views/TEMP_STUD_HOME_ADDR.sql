CREATE OR REPLACE VIEW SGAS.TEMP_STUD_HOME_ADDR
(S_STUD_REF_NO, G_STUD_REF_NO, S_START_DATE, G_START_DATE, S_OUT_UK, 
 G_OUT_UK, S_HOUSE_NO_NAME, G_HOUSE_NO_NAME, S_ADDR_L1, G_ADDR_L1, 
 S_ADDR_L2, G_ADDR_L2, S_ADDR_L3, G_ADDR_L3, S_ADDR_L4, 
 G_ADDR_L4, S_POST_CODE, G_POST_CODE, S_ADDR_EASTING, G_ADDR_EASTING, 
 S_ADDR_NORTHING, G_ADDR_NORTHING, S_TELE_NO, G_TELE_NO, S_END_DATE, 
 G_END_DATE, S_MAILSORT, G_MAILSORT)
AS 
select stha.stud_ref_no as s_stud_ref_no,
       sthag.stud_ref_no as g_stud_ref_no,
       trunc(stha.start_date) as s_start_date,
       trunc(sthag.start_date) as g_start_date, 
       stha.out_uk as s_out_uk, 
       sthag.out_uk as g_out_uk,
       stha.house_no_name as s_house_no_name,
       sthag.house_no_name as g_house_no_name,
       stha.addr_l1 as s_addr_l1,
       sthag.addr_l1 as g_addr_l1,
       stha.addr_l2 as s_addr_l2,
       sthag.addr_l2 as g_addr_l2,
       stha.addr_l3 as s_addr_l3,
       sthag.addr_l3 as g_addr_l3,
       stha.addr_l4 as s_addr_l4,
       sthag.addr_l4 as g_addr_l4,
       stha.post_code as s_post_code,
       sthag.post_code as g_post_code,
       stha.addr_easting as s_addr_easting,
       sthag.addr_easting as g_addr_easting,
       stha.addr_northing as s_addr_northing,
       sthag.addr_northing as g_addr_northing,
       stha.tele_no as s_tele_no,
       sthag.tele_no as g_tele_no,
       stha.end_date as s_end_date,
       sthag.end_date as g_end_date,
       stha.mailsort as s_mailsort,
       sthag.mailsort as g_mailsort
from stud_home_addr stha, stud_home_addr@grass sthag
where stha.stud_ref_no = sthag.stud_ref_no
and stha.end_date is null
and sthag.end_date is null
/


GRANT SELECT ON  SGAS.TEMP_STUD_HOME_ADDR TO SGAS_EUL
/