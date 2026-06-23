CREATE OR REPLACE PACKAGE BODY SGAS.pk_short_apps_Grass_NMSB
AS

/******************************************************************************
   NAME:       pk_short_appsNMSBGRASS
   PURPOSE:     To provide data to populate Student Applications for Shortenned Applications
                This points to the GRASS Database

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        28/01/2009  Paul Hughes          1. Created this package.
   1.1        07/04/2009  Paul Hughes          2. Tidy of Code
******************************************************************************/

   PROCEDURE shortappGrassNMSB (
      p_stud_ref_no    IN       NUMBER,
      p_session_code   IN       NUMBER,
      io_cursor        IN OUT   shortappGrassNMSB_cursor
   )
   IS
      adh_cursor   shortappGrassNMSB_cursor;
   BEGIN
      OPEN adh_cursor FOR
             
         SELECT iv_cont1.stud_ref_no,
                iv_cont1.ni_no,
                iv_cont1.scottish_cand,
                iv_cont1.title,
                iv_cont1.forenames,
                iv_cont1.surname,
                iv_cont1.sex,
                iv_cont1.dob,
                iv_cont1.marital_status,
                iv_cont1.marriage_date,
                iv_cont1.sort_code,
                iv_cont1.account_no,
                iv_cont1.countryofbirth,
                iv_cont1.nationality,
                iv_cont1.domicile,
                iv_cont1.bank_validate,
                iv_cont1.WebuserID,
                iv_cont1.homehouse_no_name,
                iv_cont1.homeaddr_l1, 
                iv_cont1.homeaddr_l2, 
                iv_cont1.homeaddr_l3, 
                iv_cont1.homeaddr_l4, 
                iv_cont1.homepost_code,
                iv_cont1.hometele_no,
                iv_cont1.out_UK,
                iv_cont1.mailsort,
                iv_cont1.inst_code, 
                iv_cont1.inst_name, 
                iv_cont1.crse_code, 
                iv_cont1.crse_name, 
                iv_cont1.crse_year_no
                                                                      
         FROM   (SELECT a.stud_ref_no, 
                        a.ni_no, 
                        a.scottish_cand, 
                        a.title, 
                        a.forenames, 
                        a.surname,
                        a.sex, 
                        to_char(a.dob,'DDMMYYYY') dob,
                        a.marital_status, 
                        to_char(a.marriage_date,'DDMMYYYY') marriage_date,
                        a.sort_code,
                        a.account_no,
                        a.birth_country_code countryofbirth,
                        a.nation_country_code nationality,
                        a.residence_country_code domicile,
                        a.bank_validate,
                        a.emp_id WebuserID,
                        b.house_no_name homehouse_no_name, 
                        b.addr_l1 homeaddr_l1, 
                        b.addr_l2 homeaddr_l2, 
                        b.addr_l3 homeaddr_l3, 
                        b.addr_l4 homeaddr_l4, 
                        b.post_code homepost_code, 
                        b.tele_no hometele_no,
                        b.out_UK,
                        b.mailsort,
                        e.inst_code, 
                        e.inst_name, 
                        e.crse_code, 
                        e.crse_name, 
                        e.crse_year_no
                                                                   
                        FROM stud@grass a, 
                        stud_home_addr@grass b, 
                        stud_session@grass d, 
                        stud_crse_year@grass e
                                               
                   WHERE a.stud_ref_no = b.stud_ref_no 
                        AND a.stud_ref_no = p_stud_ref_no
                        AND d.session_code = p_session_code
                        AND d.stud_ref_no = a.stud_ref_no
                        AND d.stud_session_id = e.stud_session_id
                        AND e.latest_crse_ind = 'Y'
                        AND b.end_date IS NULL) iv_cont1;

io_cursor:= adh_cursor;

END shortappGrassNMSB;
END;
/
