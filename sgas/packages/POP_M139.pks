CREATE OR REPLACE PACKAGE SGAS.Pop_M139 IS
--
-- SCCS IDENTIFICATION STRING
-- ==========================
-- @(#) 03/06/98 03/06/98 1.1@(#)
--
-- DESCRIPTION
-- ===========
--
-- Populates the table rep_139 for the award letter report
--
TYPE stud_declaration_rec_type IS RECORD
    (	stud_ref_no	    STUD.stud_ref_no%TYPE,
	stud_forenames	    STUD.forenames%TYPE,
	stud_surname	    STUD.surname%TYPE,
	ben_house_no_name  BENEFACTOR.house_no_name%TYPE,
	ben_addr_l1	    BENEFACTOR.addr_l1%TYPE,
	ben_addr_l2	    BENEFACTOR.addr_l2%TYPE,
	ben_addr_l3	    BENEFACTOR.addr_l3%TYPE,
	ben_addr_l4	    BENEFACTOR.addr_l4%TYPE,
	ben_post_code	    BENEFACTOR.post_code%TYPE,
	ben_mailsort		BENEFACTOR.mailsort%TYPE,
	ben_title			BENEFACTOR.title%TYPE,
	ben_forenames		BENEFACTOR.forenames%TYPE,
	ben_surname			BENEFACTOR.surname%TYPE,
	ben2_title			BENEFACTOR.title%TYPE,
	ben2_forenames		BENEFACTOR.forenames%TYPE,
	ben2_surname			BENEFACTOR.surname%TYPE,
	session_code			STUD_SESSION.session_code%TYPE,
	session_code1			STUD_SESSION.session_code%TYPE,
	i_ben1_id					STUD_SESSION.ben1_id%TYPE,
	i_ben2_id					STUD_SESSION.ben2_id%TYPE,
	i_ben1_p60			BENEFACTOR_INCOME.p60_req%TYPE,
	i_ben1_scheda			BENEFACTOR_INCOME.sched_a_req%TYPE,
	i_ben1_schedd			BENEFACTOR_INCOME.sched_d_req%TYPE,
--	i_ben1_schede			BENEFACTOR_INCOME.sched_e_req%TYPE,
	i_ben1_pension			BENEFACTOR_INCOME.pension_cb%TYPE,
	i_ben1_benefit			BENEFACTOR_INCOME.benefit_cb%TYPE,
	i_ben2_p60			BENEFACTOR_INCOME.p60_req%TYPE,
	i_ben2_scheda			BENEFACTOR_INCOME.sched_a_req%TYPE,
	i_ben2_schedd			BENEFACTOR_INCOME.sched_d_req%TYPE,
--	i_ben2_schede			BENEFACTOR_INCOME.sched_e_req%TYPE,
	i_ben2_pension			BENEFACTOR_INCOME.pension_cb%TYPE,
	i_ben2_benefit			BENEFACTOR_INCOME.benefit_cb%TYPE
	);

--
TYPE stud_output_rec_type IS RECORD
    (	stud_ref_no	    VARCHAR2(10),
	stud_forenames	    VARCHAR2(25),
	stud_surname	    VARCHAR2(25),
	ben_house_no_name  VARCHAR2(32),
	ben_addr_l1	    VARCHAR2(65),
	ben_addr_l2	    VARCHAR2(65),
	ben_addr_l3	    VARCHAR2(32),
	ben_addr_l4	    VARCHAR2(32),
	ben_post_code	    VARCHAR2(8),
	ben_mailsort		VARCHAR2(5),
	ben_title			VARCHAR2(8),
	ben_forenames		VARCHAR2(25),
	ben_surname			VARCHAR2(25),
	ben2_title			VARCHAR2(8),
	ben2_forenames		VARCHAR2(25),
	ben2_surname			VARCHAR2(25),
	session_code			VARCHAR2(4),
	session_code1			VARCHAR2(4),
	i_ben1_p60			VARCHAR2(1),
	i_ben1_sched 			VARCHAR2(1),
	i_ben1_pension			VARCHAR2(1),
	i_ben1_benefit			VARCHAR2(1),
	i_ben2_p60			VARCHAR2(1),
	i_ben2_sched			VARCHAR2(1),
	i_ben2_pension			VARCHAR2(1),
	i_ben2_benefit			VARCHAR2(1)
	);
--
g_file_handle	UTL_FILE.FILE_TYPE;
g_filename  VARCHAR2(200);
g_file_dirname VARCHAR2(200);
g_file_path VARCHAR2(200);
--
--
g_bad_handle   UTL_FILE.FILE_TYPE;
g_bad_filename	VARCHAR2(200);
g_bad_path VARCHAR2(200);
--
g_pad_char CONSTANT  VARCHAR2(1) := NULL;
g_flag_char CONSTANT VARCHAR2(1) := 'N';
g_error BOOLEAN;

	FUNCTION Pop_M139 (p_session_code IN STUD_SESSION.session_code%TYPE,
			 			p_logdir IN VARCHAR2,
						p_filename_1 IN VARCHAR2,
						p_sid IN VARCHAR2) RETURN VARCHAR2;
--


  	PROCEDURE File_close(p_file_handle IN OUT UTL_FILE.FILE_TYPE);
--
  	FUNCTION File_write (p_file_handle UTL_FILE.FILE_TYPE,
		      p_stud_declaration_output_rec IN OUT stud_output_rec_type) RETURN BOOLEAN;
--
	FUNCTION format_output_record(p_stud_declaration_rec IN OUT stud_declaration_rec_type,
			   p_stud_declaration_output_rec IN OUT stud_output_rec_type,
			   p_session_code IN NUMBER) RETURN  BOOLEAN;
--
  	PROCEDURE initialise_records(p_stud_declaration_rec IN OUT stud_declaration_rec_type,
	    p_stud_declaration_output_rec IN OUT stud_output_rec_type);
--
  	FUNCTION file_open_out_file(p_tempdir IN VARCHAR2,
			    p_sid IN VARCHAR2,
			    p_filename IN VARCHAR2,
			    p_error IN OUT VARCHAR2 ) RETURN BOOLEAN;
--

  	FUNCTION file_open_bad_file(p_tempdir IN VARCHAR2,
			    p_sid IN VARCHAR2,
			    p_filename IN VARCHAR2,
			    p_error IN OUT VARCHAR2 )RETURN BOOLEAN;
END Pop_M139;
/