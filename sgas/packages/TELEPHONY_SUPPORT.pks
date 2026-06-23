CREATE OR REPLACE PACKAGE SGAS.TELEPHONY_SUPPORT IS
--
-- SCCS IDENTIFICATION STRING
-- ==========================
-- @(#) telephony_support_s.sql 05/24/00 16:22:54 1.6@(#)
--
-- DESCRIPTION
-- ===========
--
-- Modification History
-- Date       Author      Ref    Desc
-- 05/03/2008 A Bowman    001   Removed all Team related procedures from the package as it is not required for StEPS
-- 
-- Package used to hold functions required for telephony rfc66
-----------------------------------------------------------------------------------------------------
   FUNCTION get_application_status (p_student_identifier NUMBER, p_session_code OUT VARCHAR2, p_status_change_date OUT DATE) RETURN VARCHAR2;
   FUNCTION get_application_status_full (p_student_identifier NUMBER, p_session_code OUT VARCHAR2, p_status_change_date OUT DATE) RETURN VARCHAR2;
   FUNCTION get_travel_status (p_student_identifier NUMBER, p_session_code OUT VARCHAR2, p_registration_date OUT DATE, p_payment_date OUT DATE) RETURN VARCHAR2;
   FUNCTION request_dup_letter (p_student_identifier IN NUMBER, p_session_code OUT NUMBER, p_letter_date OUT DATE) RETURN VARCHAR2;
   FUNCTION agency_status (p_student_identifier NUMBER, p_team OUT VARCHAR2) RETURN VARCHAR2;
   FUNCTION record_mis_info (p_stud_ref_no_in NUMBER, p_service_code_in VARCHAR2, p_start_time_in DATE, p_end_time_in DATE) RETURN VARCHAR2;
   PROCEDURE update_tele (P_STUD_REF_NO NUMBER, P_ACTION VARCHAR2, P_TABLE_NAME VARCHAR2);
   FUNCTION dup_letter_status (p_student_identifier IN NUMBER,p_session_code OUT NUMBER) RETURN VARCHAR2;
   PROCEDURE create_csv_file(success_fail OUT VARCHAR2, error_msg OUT VARCHAR2);
   PROCEDURE duplicate_loa (success_fail OUT VARCHAR2, error_msg OUT VARCHAR2);
   PROCEDURE update_web_mail (p_stud_ref_no NUMBER, p_email_addr VARCHAR2);
END Telephony_Support;
/