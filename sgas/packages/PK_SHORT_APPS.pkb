CREATE OR REPLACE PACKAGE BODY SGAS.pk_short_apps
AS
   /******************************************************************************
      NAME:       PK_SHORT_APPS
      PURPOSE:    SELECTS DATA FROM THE GRASS DATABASE FOR STEPS SHORTENNED APPLICATION
                  THIS LOOKS THE DATA UP IN THE STEPS DATABASE

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0       03.11.2008   Paul Hughes     Created this package body
      1.1       07.04.2009   Paul Hughes     Tidy of Code
      1.2       16/09/2009   Clark Bolan     SGAS prefix added to ensure PROCEDURE works in BUI
      1.3       21.12.2011   Paul Hughes     Change of session changes made
      1.4       04/05/2015   Clark Bolan     NEW FUNCTION does_student_have_loan added
      1.5       09/11/2016   Clark Bolan     new clause in selection care_leaver = 'N'
   ******************************************************************************/


   FUNCTION claimFees (p_stud_ref_no IN NUMBER, p_session_code IN NUMBER)
      RETURN CHAR
   IS
      l_count    NUMBER;
      l_result   CHAR;
   BEGIN
      SELECT COUNT (*)
        INTO l_count
        FROM stud_crse_year a, award b
       WHERE     a.stud_crse_year_id = b.stud_crse_year_id
             AND a.stud_ref_no = p_stud_ref_no
             AND a.session_code = p_session_code
             AND b.award_src = 'T';

      IF l_count > 0
      THEN
         l_result := 'Y';
      ELSE
         l_result := 'N';
      END IF;

      RETURN l_result;
   END claimFees;

   FUNCTION getMaxAuditDate (p_stud_ref_no    IN NUMBER,
                             p_session_code   IN NUMBER)
      RETURN DATE
   IS
      l_result   DATE;
   BEGIN
      SELECT MAX (last_updated_on)
        INTO l_result
        FROM (SELECT last_updated_on
                FROM STUD
               WHERE stud_ref_no = p_stud_ref_no
              UNION
              SELECT last_updated_on
                FROM STUD_SESSION
               WHERE     STUD_REF_NO = p_stud_ref_no
                     AND SESSION_CODE = p_session_code
              UNION
              SELECT last_updated_on
                FROM STUD_CRSE_YEAR
               WHERE STUD_REF_NO = p_stud_ref_no);

      RETURN l_result;
   END getMaxAuditDate;
   
   FUNCTION does_student_have_loan (p_stud_ref_no IN NUMBER,
                                    p_session_code IN NUMBER)
        RETURN VARCHAR
   IS
        
    loan_award NUMBER; 
    result  VARCHAR(1);    
   
   BEGIN
   
        SELECT COUNT (a.stud_ref_no)
        INTO loan_award
        FROM AWARD a, STUD_AWARD_TYPE b
        WHERE A.STUD_AWARD_TYPE = B.STUD_AWARD_TYPE
        AND B.TYPE = 'LOAN'
        AND A.SESSION_CODE = p_session_code
        AND A.STUD_REF_NO =  p_stud_ref_no
        AND A.NET_AMOUNT > 0;
    
    IF loan_award > 0 
        THEN
           result := 'Y';
        ELSE 
           result := 'N';
    END IF;
    
    RETURN result;
   
   
   END does_student_have_loan;                                   


   PROCEDURE all_shortapp_all (
      p_stud_ref_no    IN     NUMBER,
      p_session_code   IN     NUMBER,
      io_cursor        IN OUT all_shortapp_all_cursor)
   IS
      adh_cursor   all_shortapp_all_cursor;
   BEGIN
      OPEN adh_cursor FOR
         SELECT iv_cont1.stud_ref_no,
                iv_cont1.ni_no,
                iv_cont1.scottish_cand,
                iv_cont1.title,
                iv_cont1.forenames,
                iv_cont1.surname,
                iv_cont1.district_birth_cert_issued,
                iv_cont1.sex,
                iv_cont1.addr_corr_flag,                                 --NEW
                iv_cont1.dob,
                iv_cont1.marital_status,
                iv_cont1.marriage_date,
                iv_cont1.homehouse_no_name,
                iv_cont1.homeaddr_l1,
                iv_cont1.homeaddr_l2,
                iv_cont1.homeaddr_l3,
                iv_cont1.homeaddr_l4,
                iv_cont1.homepost_code,
                iv_cont1.location_ind,
                iv_cont1.hometele_no,
                iv_cont1.mobile_tel_no,
                iv_cont1.email_addr,
                iv_cont1.sort_code,
                iv_cont1.account_no,
                iv_cont1.countryofbirth,
                iv_cont1.nationality,
                iv_cont1.domicile,
                iv_cont1.termhouse_no_name,
                iv_cont1.termaddr_l1,
                iv_cont1.termaddr_l2,
                iv_cont1.termaddr_l3,
                iv_cont1.termaddr_l4,
                iv_cont1.termpost_code,
                iv_cont1.loan_request,
                iv_cont1.max_loan_requested,
                iv_cont1.loan_declaration_date,
                iv_cont1.inst_code,
                iv_cont1.inst_name,
                iv_cont1.crse_code,
                iv_cont1.crse_name,
                iv_cont1.crse_year_no,
                iv_cont1.parent_contrib_exempt,
                iv_cont1.cont_name,
                iv_cont1.cont_addr1,
                iv_cont1.cont_addr2,
                iv_cont1.cont_addr3,
                iv_cont1.cont_postcode,
                iv_cont1.cont_rel_code,
                iv_cont1.cont_tel_no,
                iv_cont2.Cont2_name,
                iv_cont2.Cont2_addr1,
                iv_cont2.Cont2_addr2,
                iv_cont2.Cont2_addr3,
                iv_cont2.Cont2_postcode,
                iv_cont2.Cont2_tel_no,
                iv_cont1.mailsort,
                iv_cont1.web_user_id,
                iv_cont1.emp_id,
                iv_cont1.out_uk,
                iv_cont1.eu_flag,
                iv_cont1.short_app_sent_date,
                iv_cont1.audit_date,
                iv_cont1.claimFees,
                iv_cont1.commence_session,
                iv_cont1.RESIDENCY_CATEGORY
           FROM (SELECT a.stud_ref_no,
                        a.ni_no,
                        a.scottish_cand,
                        a.title,
                        a.forenames,
                        a.surname,
                        a.district_birth_cert_issued,
                        a.sex,
                        a.addr_corr_flag,
                        TO_CHAR (a.dob, 'DDMMYYYY') dob,
                        a.marital_status,
                        TO_CHAR (a.marriage_date, 'DDMMYYYY') marriage_date,
                        b.house_no_name homehouse_no_name,
                        b.addr_l1 homeaddr_l1,
                        b.addr_l2 homeaddr_l2,
                        b.addr_l3 homeaddr_l3,
                        b.addr_l4 homeaddr_l4,
                        b.post_code homepost_code,
                        c.location_ind,
                        b.tele_no hometele_no,
                        a.mobile_tel_no,
                        a.email_addr,
                        a.sort_code,
                        a.account_no,
                        a.birth_country_code countryofbirth,
                        a.nation_country_code nationality,
                        a.residence_country_code domicile,
                        c.house_no_name termhouse_no_name,
                        c.addr_l1 termaddr_l1,
                        c.addr_l2 termaddr_l2,
                        c.addr_l3 termaddr_l3,
                        c.addr_l4 termaddr_l4,
                        c.post_code termpost_code,
                        CASE WHEN does_student_have_loan (p_stud_ref_no, P_SESSION_CODE) = 'N' THEN 0  ELSE D.LOAN_REQUEST END loan_request,  ---COS 2015 defect 39
                        CASE WHEN does_student_have_loan (p_stud_ref_no, P_SESSION_CODE) = 'N' THEN 'N'  ELSE D.MAX_LOAN_REQUESTED END max_loan_requested, ---COS 2015 defect 39
                        CASE WHEN does_student_have_loan (p_stud_ref_no, P_SESSION_CODE) = 'N' THEN NULL  ELSE D.LOAN_DECLARATION_DATE END loan_declaration_date, ---COS 2015 defect 39
                        e.inst_code,
                        e.inst_name,
                        e.crse_code,
                        e.crse_name,
                        e.crse_year_no,
                        e.parent_contrib_exempt,
                        f.cont_name,
                        f.cont_addr1,
                        f.cont_addr2,
                        f.cont_addr3,
                        f.cont_postcode,
                        f.cont_rel_code,
                        f.cont_tel_no,
                        b.mailsort,
                        a.web_user_id,
                        a.emp_id,
                        b.out_uk,
                        g.eu_flag,
                        TO_CHAR (d.short_app_sent_date, 'DDMMYYYY')
                           AS short_app_sent_date,
                        TO_CHAR (
                           getMaxAuditDate (p_stud_ref_no, p_session_code),
                           'DDMMYYYY')
                           audit_date,
                        sgas.pk_short_apps.claimFees (p_stud_ref_no,
                                                      p_session_code)
                           claimFees,
                        a.commence_session,
                        A.RESIDENCY_CATEGORY
                   FROM sgas.stud a,
                        sgas.stud_home_addr b,
                        sgas.stud_term_addr c,
                        sgas.stud_session d,
                        sgas.stud_crse_year e,
                        sgas.stud_cont_details f,
                        sgas.crse_year g
                  WHERE     a.stud_ref_no = b.stud_ref_no
                        AND a.stud_ref_no = p_stud_ref_no
                        AND a.stud_ref_no = c.stud_ref_no
                        AND d.stud_ref_no = a.stud_ref_no
                        AND d.stud_session_id = e.stud_session_id
                        AND f.stud_ref_no(+) = a.stud_ref_no
                        AND g.crse_year_id = e.crse_year_id
                        AND d.session_code = p_session_code
                        AND e.latest_crse_ind = 'Y'
                        AND b.end_date IS NULL
                        AND c.end_date IS NULL
                        AND (d.care_leaver IS NULL OR d.care_leaver = 'N') --new 2017
                        AND f.contact_ind(+) = 1) iv_cont1,
                (SELECT stud.stud_ref_no,
                        scd.contact_ind AS Cont2_ind,
                        scd.cont_name AS Cont2_name,
                        scd.cont_addr1 AS Cont2_addr1,
                        scd.cont_addr2 AS Cont2_addr2,
                        scd.cont_addr3 AS Cont2_addr3,
                        scd.cont_postcode AS Cont2_postcode,
                        scd.cont_tel_no AS Cont2_tel_no
                   FROM sgas.stud, sgas.stud_cont_details scd
                  WHERE     stud.stud_ref_no = scd.stud_ref_no(+)
                        AND stud.stud_ref_no = p_stud_ref_no
                        AND scd.contact_ind = 2) iv_cont2
          WHERE iv_cont1.stud_ref_no = iv_cont2.stud_ref_no(+);

      io_cursor := adh_cursor;
   END all_shortapp_all;
END;
/