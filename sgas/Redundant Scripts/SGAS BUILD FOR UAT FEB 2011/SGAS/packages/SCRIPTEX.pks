CREATE OR REPLACE PACKAGE SGAS.SCRIPTEX
  IS

   FUNCTION insert_edm_aud_temp
    ( p_raw_data_id IN edm_aud_temp.raw_data_id%TYPE,
      p_object_id IN edm_aud_temp.object_id%TYPE,
      p_aud_date IN DATE,
      p_batch_type_code IN edm_aud_temp.batch_type_code%TYPE,
      p_field_name IN edm_aud_temp.field_name%TYPE,
      p_emp_login_name IN edm_aud_temp.emp_login_name%TYPE,
      p_old IN edm_aud_temp.old%TYPE,
      p_action IN edm_aud_temp.action%TYPE,
      p_new IN edm_aud_temp.new%TYPE,
      p_stud_ref_no IN edm_aud_temp.stud_ref_no%TYPE,
      p_session_code IN edm_aud_temp.session_code%TYPE)RETURN VARCHAR2;

END; -- Package spec
/

