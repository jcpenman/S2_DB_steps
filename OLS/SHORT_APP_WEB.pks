CREATE OR REPLACE PACKAGE SGAS.Short_App_Web
  IS
--
TYPE cwa_type IS RECORD (
  app_id	  	 	 applications_made.application_id%type,
--next two lines need replacing 	
	app_type		   varchar2(1),
--	app_type		   complete_web_applications.application_type%type,
	object_id		   varchar2(44) ,	
--	object_id		   complete_web_applications.object_id%type,
	stud_ref_no	 	 STUD.stud_ref_no%TYPE,
	web_user_id		 STUD.web_user_id%type,
  email_addr     STUD.email_addr%type,
	title	     	   STUD.title%TYPE,
	forenames	 	   STUD.forenames%TYPE,
	surname	     	 STUD.surname%TYPE,
	house_no_name  STUD_HOME_ADDR.house_no_name%TYPE,
	addr_l1	    	 STUD_HOME_ADDR.addr_l1%TYPE,
	sub_date		   complete_web_applications.web_submitted%type,
	session_code	 complete_web_applications.session_code%type,
	sex				     stud.sex%type,
	dob				     stud.dob%type, 
    top_option           varchar2(1),
	error_mess		 varchar2(1),
	error_status	 varchar2(1024)
	);

--

PROCEDURE proc_generateCWA(    p_application_id   IN NUMBER,                               
                               p_user_id          IN VARCHAR2,
                               p_result             OUT VARCHAR2 );

FUNCTION generateCWA(p_app_id IN  applications_made.application_id%type,
		 			 p_stud IN stud.stud_ref_no%type) RETURN  VARCHAR2  ;
--
FUNCTION get_stud_dets(p_cwa_rec IN OUT cwa_type,
			       p_stud IN stud.stud_ref_no%TYPE) RETURN  BOOLEAN;
--
PROCEDURE initialise_records(p_cwa_rec IN OUT cwa_type);
--
function insert_shwap_error(p_cwa_rec IN cwa_type) return boolean;
--
function deleteCWA(p_app_id IN  applications_made.application_id%type) RETURN  boolean ;
--
function update_Apps_Made(p_app_id IN  applications_made.application_id%type,
		 					p_status IN applications_made.status%type) RETURN boolean ;				   
--	
/*function data_transfer(p_app_type IN varchar2, p_session_code in varchar2) RETURN  VARCHAR2;*/
--
FUNCTION get_cwa(p_cwa_rec IN OUT cwa_type,
			       p_app_id IN complete_web_applications.application_id%TYPE) RETURN  BOOLEAN;
--
/*function insert_cs(p_cwa_rec IN OUT cwa_type) RETURN  VARCHAR2;	*/

function insert_cwa(p_cwa_rec IN OUT cwa_type, 
		 			p_status in complete_web_applications.status%type) RETURN  VARCHAR2 ;
		   
				   
--
END; -- SHORT_APP_WEB Package spec
/