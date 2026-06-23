CREATE OR REPLACE PACKAGE SGAS.CRSE_ROLLOVER
  IS
--
--
-- Purpose: Roll over crse_session and crse_year details
-- for the sesion passed in
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
-- A Dobbie    08/02/05 Initial version for RFC 182
--
   v_sql_message	VARCHAR2(2000);
   v_sql_code		NUMBER;
	v_activity				VARCHAR2(100);
	v_inst_code	CRSE_YEAR.INST_CODE%TYPE;
	v_crse_code	CRSE.CRSE_CODE%TYPE;
	v_session_count	NUMBER(10) := 0;
	v_year_count	NUMBER(10) := 0;
--
   FUNCTION crse_rollover
     ( p_session_code IN number,
       p_logdir IN varchar2,
       p_sid IN varchar2)
     RETURN  VARCHAR2;

   FUNCTION find_crse_rollover
     ( p_session_code IN NUMBER)
     RETURN  VARCHAR2;

   FUNCTION do_crse_rollover
     ( p_session_code IN NUMBER,
		 p_crse_session_id IN NUMBER)
     RETURN  VARCHAR2;
END;
/
