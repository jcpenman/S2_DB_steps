CREATE OR REPLACE PACKAGE SGAS.MAINTAIN_REPOSITORY IS
--
-- SCCS IDENTIFICATION STRING
-- ==========================
-- @(#) maintain_repository_s.sql 04/17/00 12:56:32 1.8@(#)
--
-- DESCRIPTION
-- ===========
-- Package used to maintain repository data for telephony
--
   FUNCTION record_app_status (stud_ref_no_in NUMBER,case_status VARCHAR2, stud_crse_year_id_in NUMBER, stored_date_in DATE) RETURN VARCHAR2;
   FUNCTION record_trav_status (award_id_in NUMBER, payments_made NUMBER, min_date DATE, max_date DATE) RETURN VARCHAR2;
-- Function to delete data from the repository(s)
   PROCEDURE delete_session (session_code_in NUMBER,
                 mis_delete_date VARCHAR2,
                 repository VARCHAR2);
-- Additional function to determine the latest student course year
   FUNCTION latest_stud_crse_year (p_stud_ref_no NUMBER,
                   p_session_code NUMBER,
                   p_latest_crse_ind VARCHAR2) RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES(latest_stud_crse_year,WNDS,WNPS);
-- Function for creating an entry in the stud app progress table
FUNCTION create_app_status (p_stud_ref_no NUMBER,
                p_stud_crse_year_id NUMBER,
                p_session_code NUMBER,
                p_entered_date DATE,
                p_auto_calc_date DATE,
                p_sal_sent_date DATE,
                p_slc2_sent_date DATE) RETURN VARCHAR2;
        --
 FUNCTION    check_nmsb_session
        (p_stud_ref_no in stud.stud_ref_no%TYPE,
    p_stud_crse_year_id IN stud_crse_year.stud_crse_year_id%TYPE,
         p_session IN OUT stud_session.session_code%TYPE) RETURN VARCHAR2;
--
-- init_repos : To initialise the stud_app_prog and stud_trav_prog tables.
--
   g_err_msg     VARCHAR2(255);

   PROCEDURE init_repos ( success_fail    OUT VARCHAR2,
              start_finish    OUT VARCHAR2,
              num_procd    OUT VARCHAR2,
              error_msg    OUT VARCHAR2 );
END MAINTAIN_REPOSITORY; 
/

