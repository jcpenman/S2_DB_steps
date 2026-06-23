CREATE OR REPLACE PACKAGE SGAS.SLC_UTIL IS
--
-- SCCS IDENTIFICATION STRING
-- ==========================
-- @(#) slc_util_s.sql 07/09/99 16:20:08 1.8@(#)
--
-- DESCRIPTION
-- ===========
--
-- A collection of miscellaneous functions associated with SLC operations
--
FLEXI_PAY_START_SESSION constant number := 2007;
--
FUNCTION EligibleForFlexi(p_scy stud_crse_year%rowtype) RETURN BOOLEAN;
---
function StudHasStudLoan (p_scy_id in stud_crse_year.stud_crse_year_id%type,
								p_stud_has_stud_loan in out boolean,
								p_error_message in out varchar2,
			p_debug_file_handle in out utl_file.file_type) return boolean;
---
function StudHasFeeLoan (p_scy_id in stud_crse_year.stud_crse_year_id%type,
								p_stud_has_fee_loan in out boolean,
								p_error_message in out varchar2,
			p_debug_file_handle in out utl_file.file_type)
	       return boolean;
---
  /* course_start_date - this function returns the date of the first
     of the first term of the course the student is on, using the
     students course year to decide which session to check */
  /* parameterized (pz) version does not access SCY in database */
  FUNCTION course_start_date_pz (p_start_session NUMBER,
				 p_crse_year_no NUMBER,
				 p_inst_code VARCHAR2,
				 p_crse_code VARCHAR2)
    RETURN DATE;
  PRAGMA RESTRICT_REFERENCES (course_start_date_pz, WNDS, WNPS, RNPS);
  FUNCTION course_start_date(p_stud_crse_year_id NUMBER)
    RETURN DATE;
  PRAGMA RESTRICT_REFERENCES (course_start_date, WNDS, WNPS, RNPS);
  /* inst_start_date - this function returns the date of the first
     day of the first term of the default term dates for the
	 institution and session supplied */
  /* parameterized (pz) version does not access SCY in database */
  FUNCTION inst_start_date_pz (p_start_session NUMBER,
					   p_inst_code VARCHAR2)
    RETURN DATE;
  PRAGMA RESTRICT_REFERENCES (inst_start_date_pz, WNDS, WNPS, RNPS);
  /* birthday_55 - this function returns the date that is 55 years on
     from the date passed which is assumed to be a date of birth */
  FUNCTION birthday_55(p_dob DATE)
    RETURN DATE;
  PRAGMA RESTRICT_REFERENCES (birthday_55, WNDS, WNPS, RNPS);
  /* add_year - this function returns the date that incremented by the
     number of years specified as the second parameter */
  FUNCTION add_year(p_initial_date DATE, p_years NUMBER)
    RETURN DATE;
  PRAGMA RESTRICT_REFERENCES (add_year, WNDS, RNDS, WNPS, RNPS);
  /* loan_bearing - this function checks the details of the case given
     the student course year and returns 'Y' if the course is loan
     bearing and 'N' if the course is not loan bearing or it cannot
     be determined if the case is loan bearing or not. */
  /* parameterized (pz) version does not access SCY in database */
  FUNCTION loan_bearing_pz (p_stud_ref_no NUMBER,
			    p_session_code NUMBER,
			    p_inst_code VARCHAR2,
			    p_crse_code VARCHAR2,
			    p_crse_year_no NUMBER,
			    p_dearing VARCHAR2)
    RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES (loan_bearing_pz, WNDS, WNPS, RNPS);
  FUNCTION loan_bearing (p_stud_crse_year_id NUMBER)
    RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES (loan_bearing, WNDS, WNPS, RNPS);
  /* eligibility - this function checks the details of the case given
     the student course year and returns 'Y' if the student can have
     eligibility calculated and 'N' if the eligibility cannot be
     calculated or cannot be determined. */
  /* parameterized (pz) version does not access SCY in database */
  FUNCTION eligibility_pz (p_stud_ref_no NUMBER)
    RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES (eligibility_pz, WNDS, WNPS, RNPS);
  FUNCTION eligibility (p_stud_crse_year_id NUMBER)
    RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES (eligibility, WNDS, WNPS, RNPS);
  /* application - this function checks that the student can
     apply for a loan because they have supplied all the necessary
     details. */
  /* parameterized (pz) version does not access SCY in database */
  FUNCTION application_pz (p_stud_ref_no NUMBER, p_session NUMBER)
    RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES (application_pz, WNDS, WNPS, RNPS);
  FUNCTION application (p_stud_crse_year_id NUMBER)
    RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES (application, WNDS, WNPS, RNPS);
  FUNCTION course_end_date (p_inst_code VARCHAR2,
			    p_crse_code VARCHAR2,
			    p_session_code NUMBER,
			    p_crse_year_no NUMBER,
			    p_course_end_date IN OUT VARCHAR2)
    RETURN NUMBER;
  FUNCTION available_as_loan (p_stud_crse_year_id NUMBER,
			      p_available_as_loan_amount IN OUT NUMBER)
    RETURN NUMBER;
  FUNCTION assessed_as_loan (p_stud_crse_year_id NUMBER,
			     p_assessed_as_loan_amount IN OUT NUMBER)
    RETURN NUMBER;
  FUNCTION slc_inst_code (p_stud_crse_year_id NUMBER,
			  p_slc_inst_code IN OUT VARCHAR2,
			  p_slc_inst_name IN OUT VARCHAR2)
    RETURN NUMBER;
  FUNCTION slc_crse_code (p_stud_crse_year_id NUMBER,
			  p_slc_inst_code IN OUT VARCHAR2,
			  p_slc_crse_code IN OUT VARCHAR2,
			  p_slc_crse_name IN OUT VARCHAR2)
    RETURN NUMBER;
  PRAGMA RESTRICT_REFERENCES (slc_util, WNDS, WNPS, RNPS);
--
-- New function added as part of RFC 71
--
  FUNCTION part_time_course (p_crse_code VARCHAR2)
	RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES (part_time_course, WNDS, WNPS, RNPS);
--
-- New function added as part of RFC 73
--
  FUNCTION independent (p_session_code NUMBER,
			p_dearing_status VARCHAR2,
						p_inst_code VARCHAR2,
						p_crse_year_id NUMBER,
						p_crse_year_no NUMBER,
						p_dob DATE,
						p_check_marriage BOOLEAN,
						p_marriage_date DATE,
						p_check_eu BOOLEAN)
    RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES (independent, WNDS, WNPS, RNPS);
--
-- Non boolean version for use in pure SQL calls
--
  FUNCTION independent_nb (p_session_code NUMBER,
				       p_dearing_status VARCHAR2,
						   p_inst_code VARCHAR2,
						   p_crse_year_id NUMBER,
						   p_crse_year_no NUMBER,
						   p_dob DATE,
						   p_check_marriage VARCHAR2,
						   p_marriage_date DATE,
						   p_check_eu VARCHAR2)
    RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES (independent_nb, WNDS, WNPS, RNPS);
--
--New function added as part of RFC104 GE
  FUNCTION ge_eligibility (p_stud_ref_no NUMBER)
      RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES (ge_eligibility, WNDS, WNPS, RNPS);
-- RFC172
  FUNCTION slc4_course_end_date (p_stud_crse_year_id IN OUT stud_crse_year.stud_crse_year_id%TYPE,
		p_inst_code VARCHAR2,
			    p_crse_code VARCHAR2,
			    p_session_code NUMBER,
			    p_crse_year_no NUMBER,
			    p_course_end_date IN OUT VARCHAR2)
  RETURN NUMBER;
-- END RFC172

  FUNCTION fee_loan_application_pz (p_stud_ref_no NUMBER, p_session NUMBER)
    RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES (fee_loan_application_pz, WNDS, WNPS, RNPS);
--
END;
/
