CREATE OR REPLACE PACKAGE BODY SGAS.SHORT_APP_WEB AS
/******************************************************************************
   NAME:       SHORT_APP_WEB
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        16/02/2006             1. Created this package body.
******************************************************************************/
--
FUNCTION get_stud_dets(p_cwa_rec IN OUT cwa_type,
			       p_stud IN STUD.stud_ref_no%TYPE) RETURN  BOOLEAN
is
BEGIN

  --Grab user id separately
  select user_id
  into p_cwa_rec.web_user_id
  from student_personal_details
  where stud_ref_no = p_stud;
  
  select email_addr
  into p_cwa_rec.email_addr
  from user_personal_details
  where user_id = p_cwa_rec.web_user_id;

	 SELECT s.stud_ref_no, 
	 		s.title, 
			s.forenames, 
			s.surname, 
			sha.HOUSE_NO_NAME, 
			sha.ADDR_L1,
			s.sex, 
			s.dob,
            sc.top_option
						 
	 	 INTO p_cwa_rec.stud_ref_no, 
		 	  p_cwa_rec.title, 
			  p_cwa_rec.forenames, 
			  p_cwa_rec.surname , 
			  p_cwa_rec.house_no_name ,
			  p_cwa_rec.addr_l1 ,
			  p_cwa_rec.sex ,
			  p_cwa_rec.dob ,
              p_cwa_rec.top_option
		   FROM stud s, stud_home_addr sha, sas_claims sc
			WHERE s.stud_ref_no = p_stud
		 	  and sha.stud_ref_no = s.stud_ref_no
              and sha.end_date is null; 

		RETURN TRUE;
	 EXCEPTION
		WHEN OTHERS THEN
		p_cwa_rec.error_status := 'E';
		p_cwa_rec.error_mess := 'Student ' || p_stud ||
		    ' - An error has occurred retreiving the SHWAP details. The error is as follows: '||  SQLERRM(SQLCODE);
	   	 dbms_output.put_line(p_cwa_rec.error_mess);
		 
	RETURN FALSE;
		
				   
end;
--
FUNCTION get_cwa(p_cwa_rec IN OUT cwa_type,
			       p_app_id IN complete_web_applications.application_id%TYPE) RETURN  BOOLEAN
is
BEGIN

	 SELECT stud_ref_no, 
	 		forenames, 
			surname, 
			object_id,
			USER_ID,
			web_submitted,
			session_code
	 	 INTO p_cwa_rec.stud_ref_no, 
		 	  p_cwa_rec.forenames, 
			  p_cwa_rec.surname , 
			  p_cwa_rec.object_id ,
			  p_cwa_rec.web_user_id ,
			  p_cwa_rec.sub_date,
			  p_cwa_rec.session_code
		   FROM complete_web_applications 
			WHERE application_id = p_app_id ;
		RETURN TRUE;
	 EXCEPTION
		WHEN OTHERS THEN
		p_cwa_rec.error_status := 'E';
		p_cwa_rec.error_mess := 'Application ' || p_app_id ||
		    ' - An error has occurred retreiving the CWA details. The error is as follows: '||  SQLERRM(SQLCODE);
	   	 dbms_output.put_line(p_cwa_rec.error_mess);
		 
	RETURN FALSE;
		
				   
end; --get_cwa
--
PROCEDURE initialise_records(p_cwa_rec IN OUT cwa_type) is
begin

p_cwa_rec.app_id 			:= NULL;
p_cwa_rec.app_type			:= 'S';
p_cwa_rec.object_id		    := NULL;	
p_cwa_rec.stud_ref_no	 	:= NULL;
p_cwa_rec.title	     	  	:= NULL;
p_cwa_rec.web_user_id		:= NULL;
p_cwa_rec.forenames	 	  	:= NULL;
p_cwa_rec.surname	     	:= NULL;
p_cwa_rec.house_no_name  	:= NULL;
p_cwa_rec.addr_l1	    	:= NULL;
p_cwa_rec.sex				:= NULL;
p_cwa_rec.dob				:= NULL;
p_cwa_rec.sub_date			:= NULL;
p_cwa_rec.session_code		:= NULL;
p_cwa_rec.top_option        := NULL;
p_cwa_rec.error_mess		:= NULL;
p_cwa_rec.error_status	   	:= NULL;

return;
end; --initialise_records 

PROCEDURE proc_generateCWA(    p_application_id   IN NUMBER,                               
                               p_user_id          IN VARCHAR2,
                               p_result             OUT VARCHAR2
    ) IS    
BEGIN
   -- Call the function
   p_result := generateCWA(p_application_id, p_user_id);    
END proc_generateCWA; 

FUNCTION generateCWA
     (p_app_id IN  applications_made.application_id%type,
	  p_stud IN stud.stud_ref_no%type) 
RETURN  VARCHAR2  is
v_process BOOLEAN := TRUE;
v_return VARCHAR2(7) := null;
v_app_cnt number := null ;
cwa_rec cwa_type ;

BEGIN
	/* Check whether the application has already been transformed */
	SELECT COUNT(*)
	INTO v_app_cnt
	FROM COMPLETE_WEB_APPLICATIONS
	WHERE application_id = p_app_id;
--
	/* If record exists then no need to run the proc - Return success */
	IF v_app_cnt > 0 THEN
		RETURN('OK');
	END IF;


		  v_process := TRUE;
   		  initialise_records(cwa_rec);
		  cwa_rec.app_id := p_app_id;
   
   IF v_process = TRUE THEN
--   build record for insertion
      IF NOT get_stud_dets(cwa_rec, p_stud) THEN
	       v_process := FALSE;
      END IF;
   END IF;	

   IF v_process = TRUE THEN
--   insert record in CWA
    v_return := insert_CWA(cwa_rec, 'S');
	   IF v_return = 'FAIL' THEN
	   	  DBMS_OUTPUT.NEW_LINE;
    	  DBMS_OUTPUT.PUT_LINE(to_char(p_stud) || ' FAIL');
		RETURN('FAIL'); 	
	   ELSIF v_return =  'OK' THEN
	      DBMS_OUTPUT.NEW_LINE;
		  DBMS_OUTPUT.PUT_LINE(to_char(p_stud) || ' OK');
		RETURN('OK');  
	   END IF;
	
   END IF;	

exception
		 WHEN OTHERS THEN
	 	 	  		cwa_rec.error_status := 'E';
					cwa_rec.error_mess := 'Student ' || cwa_rec.stud_ref_no ||
		    ' - An error has occurred retreiving the CWA details. The error is as follows: '||  SQLERRM(SQLCODE);
	   	 dbms_output.put_line(cwa_rec.error_mess);
	 	 rollback;
	 	 RETURN('FAIL'); 
   

end; -- generate_CWA

--
function insert_shwap_error(p_cwa_rec IN cwa_type) 
return boolean IS

v_error_mess varchar2(1024) := null ;

BEGIN
	   update complete_web_applications
	   		  set status = 'E'
			  	 where application_id = p_cwa_rec.app_id ;
				  
		commit;
		
RETURN true;
EXCEPTION
		WHEN OTHERS THEN
		 rollback;
		 v_error_mess :=  p_cwa_rec.error_mess + 'A further error has occurred updating the CWA record. The error is as follows: '||  SQLERRM(SQLCODE);
	   	 dbms_output.put_line(v_error_mess);

	RETURN false;


END; -- insert_shwap_error;
--
function deleteCWA(p_app_id IN  applications_made.application_id%type) 
return boolean IS

v_error_mess varchar2(1024) := null ;

BEGIN
	   delete from  complete_web_applications
	   		  	 where application_id = p_app_id ;
				  
		commit;
		
RETURN true;
EXCEPTION
		WHEN OTHERS THEN
		 rollback;
		 v_error_mess := 'An error has occurred deleting the CWA record for '|| p_app_id ||' . The error is as follows: '||  SQLERRM(SQLCODE);
	   	 dbms_output.put_line(v_error_mess);

	RETURN false;

end; --deleteCWA
--

function update_Apps_Made(p_app_id IN  applications_made.application_id%type,
		 					p_status IN applications_made.status%type) 
return boolean IS

v_error_mess varchar2(1024) := null ;

BEGIN
	   update applications_made
	   		  set status = p_status,
			  	  last_saved_date = sysdate
			  	 where application_id = p_app_id ;
				  
		commit;
		
RETURN true;
EXCEPTION
		WHEN OTHERS THEN
		 rollback;
		 v_error_mess := 'An error has occurred updating the applications_made record for '|| p_app_id ||' . The error is as follows: '||  SQLERRM(SQLCODE);
	   	 dbms_output.put_line(v_error_mess);
		 
		 
	RETURN false;


end;				   
--	
/*function data_transfer(p_app_type IN varchar2, p_session_code in varchar2) 
RETURN  VARCHAR2 is
v_return	    VARCHAR2(7);
v_count 	    NUMBER := 0;
v_process BOOLEAN := TRUE;
cwa_rec cwa_type ;

--Get transferable records

CURSOR	fetch_rec IS
SELECT	stud_ref_no, application_id
FROM	Complete_web_applications
WHERE	object_id IS NOT NULL
and application_type= p_app_type
and session_code = p_session_code
;
--
--
BEGIN

for rec in fetch_rec
loop
   
   v_process := TRUE;
   initialise_records(cwa_rec);
   
   IF v_process = TRUE THEN
--   Get cwa records for processing
      IF NOT get_cwa(cwa_rec, rec.application_id) THEN
	       v_process := FALSE;
      END IF;
   END IF;

   IF v_process = TRUE THEN
--   insert GRASS completed_shwap records for processing
      v_return := insert_cs(cwa_rec);
	-- Send status of record to output
	   IF v_return = 'FAIL' THEN
	   	  DBMS_OUTPUT.NEW_LINE;
    	  	DBMS_OUTPUT.PUT_LINE(to_char(rec.stud_ref_no) || ' FAIL');
	   ELSIF v_return =  'OK' THEN
	      DBMS_OUTPUT.NEW_LINE;
		  DBMS_OUTPUT.PUT_LINE(to_char(rec.stud_ref_no) || ' OK');
	   END IF;
	--
	   	   v_count := v_count + 1;
	   	   COMMIT;
   END IF;
	
   IF v_return = 'OK' THEN
--   Get cwa records for processing
      IF NOT update_apps_made(rec.application_id, 'T') THEN
	       v_process := FALSE;
      END IF;
	  IF v_process = TRUE THEN
	  	 IF NOT deleteCWA(rec.application_id) THEN
	       v_process := FALSE;
	  	 end if;   
      END IF; 
   ELSIF v_return =  'FAIL' THEN
   		 IF NOT insert_shwap_error(cwa_rec) THEN
		        v_process := FALSE;
      	 END IF;
   
   END IF;	
	  
	
END LOOP;
--
DBMS_OUTPUT.NEW_LINE;
DBMS_OUTPUT.PUT_LINE(' SHWAP Processing Completed at '|| to_char(sysdate, 'dd-mm-yyyy HH:MI:SS'));
DBMS_OUTPUT.NEW_LINE;
DBMS_OUTPUT.PUT_LINE(v_count || ' records processed');
RETURN 'OK';
--
EXCEPTION
    WHEN OTHERS THEN
			DBMS_OUTPUT.NEW_LINE;
			DBMS_OUTPUT.PUT_LINE('Fatal Error in Transfer while processing student ');
			DBMS_OUTPUT.NEW_LINE;
			DBMS_OUTPUT.PUT_LINE(TO_CHAR(sqlcode));
			ROLLBACK;
			RETURN 'FAIL';	

end ;*/
--
/*function insert_cs(p_cwa_rec IN OUT cwa_type) 
RETURN  VARCHAR2 is
begin
	 insert into sgas.completed_shwap@test1.world
	 			  (STUD_REF_NO,
				   FORENAMES,
  				   SURNAME ,
  				   SESSION_CODE,
  				   OBJECT_ID,
  				   WEB_USER_ID,
  				   WEB_SUBMITTED_DATE,
  				   STATUS,
  				   ERROR_MESSAGE)
	 		values(p_cwa_rec.stud_ref_no,
				   p_cwa_rec.forenames,
				   p_cwa_rec.surname,
				   p_cwa_rec.session_code,
				   p_cwa_rec.object_id,
				   p_cwa_rec.web_user_id,	
				   p_cwa_rec.sub_date,
				   p_cwa_rec.error_status,
				   p_cwa_rec.error_mess);
			
			commit;	   
			RETURN('OK');
	 
	 EXCEPTION
		 WHEN NO_DATA_FOUND THEN
		 	  dbms_output.put_line('no records found');
		 WHEN DUP_VAL_ON_INDEX THEN
	 	 	  UPDATE sgas.COMPLETED_SHWAP@test1.world 
	 	 	  SET object_id = p_cwa_rec.object_id,
		 	  	  web_submitted_date= p_cwa_rec.sub_date
		 		  WHERE stud_ref_no = p_cwa_rec.stud_ref_no ;
	 	 	  RETURN('OK');
		 WHEN OTHERS THEN
	 	 	  		p_cwa_rec.error_status := 'E';
					p_cwa_rec.error_mess := 'Student ' || p_cwa_rec.stud_ref_no ||
		    ' - An error has occurred retreiving the CWA details. The error is as follows: '||  SQLERRM(SQLCODE);
	   	 dbms_output.put_line(p_cwa_rec.error_mess);
	 	 rollback;
	 	 RETURN('FAIL');

end; --insert_cs*/

function insert_cwa(p_cwa_rec IN OUT cwa_type, p_status in complete_web_applications.status%type) 
RETURN  VARCHAR2 is


begin

p_cwa_rec.sub_date := sysdate ;
		select cval 
		 into p_cwa_rec.session_code
		   from config_data 
	   		where item_name = 'CURRENT_SESSION';		 			 

	 insert into complete_web_applications
	 			  (STUD_REF_NO,
				   title,
				   FORENAMES,
  				   SURNAME ,
				   home_house_no_name,
				   home_addr_l1 ,
				   sex ,
				   dob,
  				   SESSION_CODE,
  				   USER_ID,
             EMAIL_ADDR,
  				   WEB_SUBMITTED,
  				   application_id,
				   status,
				   application_type,
                   top_option)
	 		values(p_cwa_rec.stud_ref_no, 
		 	  	   p_cwa_rec.title, 
			  	   p_cwa_rec.forenames, 
			  	   p_cwa_rec.surname , 
			  	   p_cwa_rec.house_no_name ,
			  	   p_cwa_rec.addr_l1 ,
			  	   p_cwa_rec.sex ,
			  	   p_cwa_rec.dob,
				   p_cwa_rec.session_code,
				   p_cwa_rec.web_user_id,	
           p_cwa_rec.email_addr,
				   p_cwa_rec.sub_date,
				   p_cwa_rec.app_id,
				   p_status,
				   p_cwa_rec.app_type,
                   p_cwa_rec.top_option);
			
			commit;	   
			RETURN('OK');
	 
	 EXCEPTION
		 WHEN NO_DATA_FOUND THEN
		 	  dbms_output.put_line('no records found');
		 WHEN DUP_VAL_ON_INDEX THEN
	 	 	  UPDATE COMPLETE_WEb_APPLICATIONS 
	 	 	  SET web_submitted = p_cwa_rec.sub_date
		 		  WHERE application_id = p_cwa_rec.app_id ;
	 	 	  RETURN('OK');
		 WHEN OTHERS THEN
	 	 	  		p_cwa_rec.error_status := 'E';
					p_cwa_rec.error_mess := 'Student ' || p_cwa_rec.stud_ref_no ||
		    ' - An error has occurred inserting the CWA details. The error is as follows: '||  SQLERRM(SQLCODE);
	   	 dbms_output.put_line(p_cwa_rec.error_mess);
	 	 rollback;
	 	 RETURN('FAIL');

end; --insert_CWA



END SHORT_APP_WEB;
/