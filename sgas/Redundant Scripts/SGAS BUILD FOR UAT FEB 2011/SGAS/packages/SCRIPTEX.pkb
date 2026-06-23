CREATE OR REPLACE PACKAGE BODY SGAS.SCRIPTEX
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
      p_session_code IN edm_aud_temp.session_code%TYPE)RETURN VARCHAR2
    IS

     v_return varchar2(256);
   BEGIN
   INSERT INTO EDM_AUD_TEMP
	    (RAW_DATA_ID,
	     OBJECT_ID,
	     AUD_DATE,
	     BATCH_TYPE_CODE,
	     FIELD_NAME,
	     EMP_LOGIN_NAME,
	     OLD,
	     ACTION,
	     NEW,
	     STUD_REF_NO,
	     SESSION_CODE)
   VALUES (p_raw_data_id,
	   p_object_id ,
	   p_aud_date,
	   p_batch_type_code  ,
	   UPPER(p_field_name),
	   p_emp_login_name,
	   NULL,
	   p_action,
	    p_new ,
	   p_stud_ref_no,
	   p_session_code);

	   v_return := 'TRUE';
	   return v_return;

-- remove exception handler to report error to scriptex for handling
--   EXCEPTION
--	WHEN others THEN
--	    v_return := 'Package Scriptex failed inserting to EDM_AUD_TEMP ' || to_char(SQLCODE)|| ' : ' || to_char(SQLERRM)  ;
--	    return v_return;
   END; -- Insert_EDM_AUD_TEMP

   -- Enter further code below as specified in the Package spec.
END; -- Package body
/

GRANT EXECUTE ON  SGAS.SCRIPTEX TO PUBLIC;
