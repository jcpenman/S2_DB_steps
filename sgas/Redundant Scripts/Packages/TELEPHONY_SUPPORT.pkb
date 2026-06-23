CREATE OR REPLACE PACKAGE BODY SGAS.TELEPHONY_SUPPORT AS
--
-- SCCS IDENTIFICATION STRING
-- ==========================
-- @(#) telephony_support_b.sql 08/19/00 10:39:41 1.9@(#)
--
-- Modification History
-- Date       Author      Ref    Desc
-- 
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
FUNCTION agency_status (p_student_identifier NUMBER,
            p_team OUT VARCHAR2) RETURN VARCHAR2 IS
   v_agency_telephony_status CONFIG_DATA.cval%TYPE;
   v_casework_start CONFIG_DATA.cval%TYPE;
   v_casework_end CONFIG_DATA.cval%TYPE;
   v_geu_start CONFIG_DATA.cval%TYPE;
   v_geu_end CONFIG_DATA.cval%TYPE;
   /* item names for telephony start and end times, defaulted to Friday */
   v_cw_start_item_name CONFIG_DATA.item_name%TYPE := 'CW_FRI_START_TIME';
   v_cw_end_item_name CONFIG_DATA.item_name%TYPE := 'CW_FRI_END_TIME';
   v_geu_start_item_name CONFIG_DATA.item_name%TYPE := 'GEU_FRI_START_TIME';
   v_geu_end_item_name CONFIG_DATA.item_name%TYPE := 'GEU_FRI_END_TIME';
   v_current_date DATE := SYSDATE;
   v_current_time DATE := TO_DATE(TO_CHAR(v_current_date, 'HH24:MI'), 'HH24:MI');
BEGIN
   /* check if the agency is closed */
   SELECT cval
   INTO v_agency_telephony_status
   FROM CONFIG_DATA
   WHERE item_name = 'AGENCY_TELEPHONY_STATUS';
   /* if the agency is closed then */
   IF v_agency_telephony_status = 'C' THEN
      /* return the closed status */
      RETURN 'C';
   END IF;
   /* decide which day of the week it is and get the appropriate data
      from configuration data in the database */
   IF (RTRIM(TO_CHAR(SYSDATE,'DAY')) = 'MONDAY') THEN
      /* set item name values for Monday */
      v_cw_start_item_name := 'CW_MON_START_TIME';
      v_cw_end_item_name := 'CW_MON_END_TIME';
      v_geu_start_item_name := 'GEU_MON_START_TIME';
      v_geu_end_item_name := 'GEU_MON_END_TIME';
   ELSIF (RTRIM(TO_CHAR(SYSDATE,'DAY')) = 'TUESDAY') THEN
      /* set item name values for Tuesday */
      v_cw_start_item_name := 'CW_TUE_START_TIME';
      v_cw_end_item_name := 'CW_TUE_END_TIME';
      v_geu_start_item_name := 'GEU_TUE_START_TIME';
      v_geu_end_item_name := 'GEU_TUE_END_TIME';
   ELSIF (RTRIM(TO_CHAR(SYSDATE,'DAY')) = 'WEDNESDAY') THEN
      /* set item name values for Wednesday */
      v_cw_start_item_name := 'CW_WED_START_TIME';
      v_cw_end_item_name := 'CW_WED_END_TIME';
      v_geu_start_item_name := 'GEU_WED_START_TIME';
      v_geu_end_item_name := 'GEU_WED_END_TIME';
   ELSIF (RTRIM(TO_CHAR(SYSDATE,'DAY')) = 'THURSDAY') THEN
      /* set item name values for Thursday */
      v_cw_start_item_name := 'CW_THU_START_TIME';
      v_cw_end_item_name := 'CW_THU_END_TIME';
      v_geu_start_item_name := 'GEU_THU_START_TIME';
      v_geu_end_item_name := 'GEU_THU_END_TIME';
   END IF;
   /* NB set to Friday by default if not set to any other value */
   /* get the start and end times from the database */
   SELECT cval
   INTO v_casework_start
   FROM CONFIG_DATA
   WHERE item_name = v_cw_start_item_name;
   SELECT cval
   INTO v_casework_end
   FROM CONFIG_DATA
   WHERE item_name = v_cw_end_item_name;
   SELECT cval
   INTO v_geu_start
   FROM CONFIG_DATA
   WHERE item_name = v_geu_start_item_name;
   SELECT cval
   INTO v_geu_end
   FROM CONFIG_DATA
   WHERE item_name = v_geu_end_item_name;
   /* determine if the time is outside normal working hours */
   IF ((TO_CHAR(SYSDATE,'DAY') = 'SATURDAY ' OR
    TO_CHAR(SYSDATE,'DAY') = 'SUNDAY ') OR
       (v_current_time < TO_DATE(v_geu_start, 'HH24:MI')) OR
       (v_current_time > TO_DATE(v_geu_end, 'HH24:MI'))) THEN
      /* return the closed status */
      RETURN 'C';
   END IF;
   /* the agency is not closed and the current time is within normal working
      hours so now check whether the caseworkers are accepting calls */
EXCEPTION
   /* return closed if there are any problems */
   WHEN OTHERS THEN
      RETURN 'C';
END agency_status;
-----------------------------------------------------------------------------------------------------
FUNCTION request_dup_letter (p_student_identifier IN NUMBER,
                 p_session_code OUT NUMBER,
                             p_letter_date OUT DATE) RETURN VARCHAR2 IS
   /* local variables */
   v_sal_dest STUD_CRSE_YEAR.sal_dest%TYPE;
   v_award_letter_days CONFIG_DATA.nval%TYPE;
   v_max_dup_letters STUD_APP_PROG.dup_award_letter%TYPE;
   v_sess_code config_data.cval%TYPE;
   --
   CURSOR c_stud_ref_no IS
      SELECT *
      FROM STUD_APP_PROG
      WHERE STUD_REF_NO = p_student_identifier;
   CURSOR c_slc_ref_no IS
      SELECT *
      FROM STUD_APP_PROG
      WHERE TO_NUMBER(SUBSTR(SLC_REF_NO,1,8)) = p_student_identifier;
   r_stud_app_prog c_stud_ref_no%ROWTYPE;
   --
   CURSOR cu_sal_sent(p_sess_code IN config_data.cval%type) IS
    SELECT sal_sent_date
    FROM stud_crse_year
    WHERE stud_ref_no = p_student_identifier
    AND latest_crse_ind = 'Y'
    AND session_code = p_sess_code;
   rec_sal_sent cu_sal_sent%ROWTYPE;
   --
BEGIN
   --
   -- SIR 763 - PB JUL 2007
   --
   SELECT cval
   INTO v_sess_code
   FROM config_data
   WHERE UPPER(item_name) = 'CURRENT_SESSION';
   --
   OPEN cu_sal_sent(v_sess_code);
   FETCH cu_sal_sent INTO rec_sal_sent;
   --
   IF (cu_sal_sent%NOTFOUND) OR (rec_sal_sent.sal_sent_date IS NULL) THEN
   /*No letter has ever been sent to student. Prevent Duplicate LOA*/
     CLOSE cu_sal_sent;
     RETURN 'P';
   END IF;
   --
   CLOSE cu_sal_sent;
   --
   -- END SIR 763 - PB JUL 2007
   --
   /* check that this student can be sent a duplicate letter */
   OPEN c_stud_ref_no;
   FETCH c_stud_ref_no INTO r_stud_app_prog;
   /* if no matching record is found */
   IF c_stud_ref_no%NOTFOUND THEN
      /* try to select assuming the identifier is an SLC reference number */
      OPEN c_slc_ref_no;
      FETCH c_slc_ref_no INTO r_stud_app_prog;
      /* if again no matching record is found */
      IF c_slc_ref_no%NOTFOUND THEN
     /* set status to P (pre-registration) */
     r_stud_app_prog.case_status := 'P';
      END IF;
      CLOSE c_slc_ref_no;
   END IF;
   /* if there is no application registered/the application is registered only then */
   IF (r_stud_app_prog.case_status = 'P') THEN
      /* set session to current value and return not possible status */
      SELECT TO_NUMBER(cval)
      INTO p_session_code
      FROM CONFIG_DATA
      WHERE item_name = 'CURRENT_SESSION';
      RETURN 'P';
   ELSIF (r_stud_app_prog.case_status = 'R') OR
     (r_stud_app_prog.case_status = 'W') THEN
      /* the case is registered but not calculated */
      p_session_code := r_stud_app_prog.session_code;
      RETURN 'P';
   END IF;
   /* check the student course year details to see if the letter is manual
      or suspended */
   SELECT sal_dest
   INTO v_sal_dest
   FROM STUD_CRSE_YEAR
   WHERE stud_crse_year_id = r_stud_app_prog.stud_crse_year_id;
   IF (v_sal_dest = 'M' OR v_sal_dest = 'S') THEN
      p_session_code := r_stud_app_prog.session_code;
      RETURN 'N';
   END IF;
   /* check if an award letter was sent within the last few days */
   SELECT nval
   INTO v_award_letter_days
   FROM CONFIG_DATA
   WHERE item_name = 'AWARD_LETTER_DAYS';
   IF (r_stud_app_prog.award_letter_sent_date > (SYSDATE - v_award_letter_days)) THEN
      /* the last award letter was sent within v_award_letter_days */
      p_session_code := r_stud_app_prog.session_code;
      p_letter_date := r_stud_app_prog.award_letter_sent_date;
      RETURN 'R';
   END IF;
   /* check that less than the maximum number of letters have been sent already */
   SELECT nval
   INTO v_max_dup_letters
   FROM CONFIG_DATA
   WHERE item_name = 'MAX_AWARD_LETTER_REQ';
   IF (r_stud_app_prog.dup_award_letter >= v_max_dup_letters) THEN
      /* the maximum allowed have already been sent */
      p_session_code := r_stud_app_prog.session_code;
      RETURN 'L';
   END IF;
   /* a duplicate can be sent so update stud crse year so a letter will be generated in the next run */
   UPDATE STUD_APP_PROG
   SET dup_award_letter = dup_award_letter + 1
   WHERE stud_crse_year_id = r_stud_app_prog.stud_crse_year_id;
   UPDATE STUD_CRSE_YEAR
   SET sal_sent = 'N', req_dup = 'Y'
   WHERE stud_crse_year_id = r_stud_app_prog.stud_crse_year_id;
   COMMIT;
   p_session_code := r_stud_app_prog.session_code;
   RETURN 'S';
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      /* default session to this year */
      p_session_code := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'));
      /* if there is an Oracle error, return the not possible status */
      RETURN 'N';
   WHEN OTHERS THEN
      /* default session to this year */
      p_session_code := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'));
      /* if there is an Oracle error, return the not possible status */
      RETURN 'N';
END request_dup_letter;
-----------------------------------------------------------------------------------------------------
FUNCTION get_application_status (p_student_identifier NUMBER,
                 p_session_code OUT VARCHAR2,
                 p_status_change_date OUT DATE) RETURN VARCHAR2 IS
    v_case_status VARCHAR2(1);
BEGIN
    /* call the full function and filter out the W status cases */
    v_case_status := get_application_status_full (p_student_identifier,
                              p_session_code,
                                                  p_status_change_date);
    IF v_case_status = 'W' THEN
        /* convert this to a 'P' status */
        v_case_status := 'P';
    END IF;
    RETURN (v_case_status);

END get_application_status;
-----------------------------------------------------------------------------------------------------
FUNCTION get_application_status_full (p_student_identifier NUMBER,
                 p_session_code OUT VARCHAR2,
                 p_status_change_date OUT DATE) RETURN VARCHAR2 IS
   CURSOR c_stud_ref_no IS
      SELECT *
      FROM STUD_APP_PROG
      WHERE STUD_REF_NO = p_student_identifier;
   CURSOR c_slc_ref_no IS
      SELECT *
      FROM STUD_APP_PROG
      WHERE TO_NUMBER(SUBSTR(SLC_REF_NO,1,8)) = p_student_identifier;
   r_stud_app_prog c_stud_ref_no%ROWTYPE;
BEGIN
   /* fetch the status assuming the identifier is a student reference number */
   OPEN c_stud_ref_no;
   FETCH c_stud_ref_no INTO r_stud_app_prog;
   /* if no matching record is found */
   IF c_stud_ref_no%NOTFOUND THEN
      /* try to select assuming the identifier is an SLC reference number */
      OPEN c_slc_ref_no;
      FETCH c_slc_ref_no INTO r_stud_app_prog;
      /* if again no matching record is found */
      IF c_slc_ref_no%NOTFOUND THEN
     /* set status to P (pre-registration) */
     r_stud_app_prog.case_status := 'P';
      END IF;
      CLOSE c_slc_ref_no;
   END IF;
   CLOSE c_stud_ref_no;
   /* set up the return parameters depending on status */
   IF r_stud_app_prog.case_status = 'P' THEN
      /* get the current session */
      SELECT cval
      INTO p_session_code
      FROM CONFIG_DATA
      WHERE item_name = 'CURRENT_SESSION';
   ELSIF (r_stud_app_prog.case_status = 'R' OR
      r_stud_app_prog.case_status = 'U') THEN
      /* set the session and date registered */
      p_session_code := r_stud_app_prog.session_code;
      p_status_change_date := r_stud_app_prog.date_registered;
   ELSIF r_stud_app_prog.case_status = 'C' THEN
      /* set the session and date assessed */
      p_session_code := r_stud_app_prog.session_code;
      p_status_change_date := r_stud_app_prog.date_calculated;
   ELSIF r_stud_app_prog.case_status = 'L' THEN
      /* set the session and date award letter sent */
      p_session_code := r_stud_app_prog.session_code;
      p_status_change_date := r_stud_app_prog.award_letter_sent_date;
   ELSIF r_stud_app_prog.case_status = 'S' THEN
      /* set the session and date slc data sent */
      p_session_code := r_stud_app_prog.session_code;
      p_status_change_date := r_stud_app_prog.slc_sent_date;
   ELSIF r_stud_app_prog.case_status = 'W' THEN
      /* set the session and date web application submitted */
      p_session_code := r_stud_app_prog.session_code;
      p_status_change_date := r_stud_app_prog.web_submitted_date;
   END IF;
   /* return the progress enquiry status */
   RETURN (r_stud_app_prog.case_status);
EXCEPTION
   WHEN OTHERS THEN
      /* default session to this year */
      p_session_code := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'));
      /* if there is an Oracle error, return the default status */
      RETURN 'P';
END get_application_status_full;
-----------------------------------------------------------------------------------------------------
FUNCTION record_mis_info (p_stud_ref_no_in NUMBER,
                          p_service_code_in VARCHAR2,
              p_start_time_in DATE,
                          p_end_time_in DATE) RETURN VARCHAR2 IS
BEGIN
   /* insert the call record into the MIS data table */
   INSERT INTO TELEPHONY_MIS
   (STUD_REF_NO, START_TIME, END_TIME, SERVICE_CODE)
   VALUES 
   (p_stud_ref_no_in, p_start_time_in, p_end_time_in, p_service_code_in);
   COMMIT;
   RETURN 'Y';
EXCEPTION
   WHEN OTHERS THEN
        /* if there is an Oracle error, return a failure status */
      RETURN 'N';
END record_mis_info;
-----------------------------------------------------------------------------------------------------
FUNCTION get_travel_status (p_student_identifier NUMBER,
                p_session_code OUT VARCHAR2,
                            p_registration_date OUT DATE,
                            p_payment_date OUT DATE) RETURN VARCHAR2 IS
   v_travel_status VARCHAR2(1);
   CURSOR c_stud_ref_no IS
      SELECT *
      FROM STUD_TRAV_PROG
      WHERE STUD_REF_NO = p_student_identifier;
   CURSOR c_slc_ref_no IS
      SELECT *
      FROM STUD_TRAV_PROG
      WHERE TO_NUMBER(SUBSTR(SLC_REF_NO,1,8)) = p_student_identifier;
   r_stud_trav_prog STUD_TRAV_PROG%ROWTYPE;
BEGIN
   /* fetch the status assuming the identifier is a student reference number */
   OPEN c_stud_ref_no;
   FETCH c_stud_ref_no INTO r_stud_trav_prog;
   /* if no matching record is found */
   IF c_stud_ref_no%NOTFOUND THEN
      /* try to select assuming the identifier is an SLC reference number */
      OPEN c_slc_ref_no;
      FETCH c_slc_ref_no INTO r_stud_trav_prog;
      /* if again no matching record is found */
      IF c_slc_ref_no%NOTFOUND THEN
     /* set status to P (pre-assessment) */
     v_travel_status := 'P';
      END IF;
      CLOSE c_slc_ref_no;
   END IF;
   CLOSE c_stud_ref_no;
   /* if no travel status entry is found then return default */
   IF v_travel_status = 'P' THEN
      /* get the current session */
      SELECT cval
      INTO p_session_code
      FROM CONFIG_DATA
      WHERE item_name = 'CURRENT_SESSION';
   ELSE
      /* travel status entry found */
      v_travel_status := 'A';
      p_session_code := r_stud_trav_prog.session_code;
      p_registration_date := r_stud_trav_prog.date_assessed;
      p_payment_date := r_stud_trav_prog.payment_date;
   END IF;
   RETURN v_travel_status;
EXCEPTION
   WHEN OTHERS THEN
      /* default session to this year */
      p_session_code := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'));
        /* if there is an Oracle error, return the default status */
      RETURN 'P';
END get_travel_status;
-----------------------------------------------------------------------------------------------------------------
PROCEDURE update_tele(P_STUD_REF_NO NUMBER, P_ACTION VARCHAR2,P_TABLE_NAME VARCHAR2) IS
--PB Feb 2005
--
p_team VARCHAR2(1);
v_stud_ref_no STUD.STUD_REF_NO%TYPE;
--
CURSOR cu_tele_check(p_stud IN STUD.STUD_REF_NO%TYPE) IS
SELECT stud_ref_no
FROM TELEPHONY
WHERE stud_ref_no = p_stud;
rec_tele_check cu_tele_check%ROWTYPE;
--
CURSOR cu_apps IS
SELECT stud_ref_no
FROM STUD_APP_PROG;
rec_apps cu_apps%ROWTYPE;
--
BEGIN
--
IF P_TABLE_NAME = 'CONFIG_DATA' THEN

  FOR rec_apps IN cu_apps LOOP
    V_STUD_REF_NO := rec_apps.stud_ref_no;
    OPEN cu_tele_check(V_STUD_REF_NO);
    FETCH cu_tele_check INTO rec_tele_check;
    IF cu_tele_check%NOTFOUND THEN
      --
      V_STUD_REF_NO := rec_apps.stud_ref_no;
      --
      INSERT INTO TELEPHONY(stud_ref_no, rec_status) VALUES (v_stud_ref_no, p_action);
      --
    END IF;
      --
    CLOSE cu_tele_check;

  END LOOP;
ELSE
--
  OPEN cu_tele_check(P_STUD_REF_NO);
  FETCH cu_tele_check INTO rec_tele_check;
  IF cu_tele_check%NOTFOUND THEN
   --
   INSERT INTO TELEPHONY(stud_ref_no, rec_status) VALUES (p_stud_ref_no, p_action);
   --
  END IF;
  CLOSE cu_tele_check;
END IF;
--
END update_tele;
------------------------------------------------------------------------------------------------
FUNCTION dup_letter_status (p_student_identifier IN NUMBER,
                p_session_code OUT NUMBER) RETURN VARCHAR2 IS
   /* local variables */
   v_sal_dest STUD_CRSE_YEAR.sal_dest%TYPE;
   v_award_letter_days CONFIG_DATA.nval%TYPE;
   v_max_dup_letters STUD_APP_PROG.dup_award_letter%TYPE;
   v_sess_code config_data.cval%TYPE;
   --
   CURSOR c_stud_ref_no IS
      SELECT *
      FROM STUD_APP_PROG
      WHERE STUD_REF_NO = p_student_identifier;
   CURSOR c_slc_ref_no IS
      SELECT *
      FROM STUD_APP_PROG
      WHERE TO_NUMBER(SUBSTR(SLC_REF_NO,1,8)) = p_student_identifier;
   r_stud_app_prog c_stud_ref_no%ROWTYPE;
   --
   CURSOR cu_sal_sent(p_sess_code IN config_data.cval%type) IS
    SELECT sal_sent_date
    FROM stud_crse_year
    WHERE stud_ref_no = p_student_identifier
    AND latest_crse_ind = 'Y'
    AND session_code = p_sess_code;
   rec_sal_sent cu_sal_sent%ROWTYPE;
   --
BEGIN
   --
   -- SIR 763 - PB JUL 2007
   --
   SELECT cval
   INTO v_sess_code
   FROM config_data
   WHERE UPPER(item_name) = 'CURRENT_SESSION';
   --
   OPEN cu_sal_sent(v_sess_code);
   FETCH cu_sal_sent INTO rec_sal_sent;
   --
   IF (cu_sal_sent%NOTFOUND) OR (rec_sal_sent.sal_sent_date IS NULL) THEN
   /*No letter has ever been sent to student. Prevent Duplicate LOA*/
     CLOSE cu_sal_sent;
     RETURN 'P';
   END IF;
   --
   CLOSE cu_sal_sent;
   --
   -- END SIR 763 - PB JUL 2007
   --
   /* check that this student can be sent a duplicate letter */
   OPEN c_stud_ref_no;
   FETCH c_stud_ref_no INTO r_stud_app_prog;
   /* if no matching record is found */
   IF c_stud_ref_no%NOTFOUND THEN
      /* try to select assuming the identifier is an SLC reference number */
      OPEN c_slc_ref_no;
      FETCH c_slc_ref_no INTO r_stud_app_prog;
      /* if again no matching record is found */
      IF c_slc_ref_no%NOTFOUND THEN
     /* set status to P (pre-registration) */
     r_stud_app_prog.case_status := 'P';
      END IF;
      CLOSE c_slc_ref_no;
   END IF;
   /* if there is no application registered/the application is registered only then */
   IF (r_stud_app_prog.case_status = 'P') THEN
      /* set session to current value and return not possible status */
      SELECT TO_NUMBER(cval)
      INTO p_session_code
      FROM CONFIG_DATA
      WHERE item_name = 'CURRENT_SESSION';
      RETURN 'P';
   ELSIF (r_stud_app_prog.case_status = 'R') OR
     (r_stud_app_prog.case_status = 'W') THEN
      /* the case is registered but not calculated */
      p_session_code := r_stud_app_prog.session_code;
      RETURN 'P';
   END IF;
   /* check the student course year details to see if the letter is manual
      or suspended */
   SELECT sal_dest
   INTO v_sal_dest
   FROM STUD_CRSE_YEAR
   WHERE stud_crse_year_id = r_stud_app_prog.stud_crse_year_id;
   IF (v_sal_dest = 'M' OR v_sal_dest = 'S') THEN
      p_session_code := r_stud_app_prog.session_code;
      RETURN 'N';
   END IF;
   /* check if an award letter was sent within the last few days */
   SELECT nval
   INTO v_award_letter_days
   FROM CONFIG_DATA
   WHERE item_name = 'AWARD_LETTER_DAYS';
   IF (r_stud_app_prog.award_letter_sent_date > (SYSDATE - v_award_letter_days)) THEN
      /* the last award letter was sent within v_award_letter_days */
      p_session_code := r_stud_app_prog.session_code;
      --p_letter_date := r_stud_app_prog.award_letter_sent_date;
      RETURN 'R';
   END IF;
   /* check that less than the maximum number of letters have been sent already */
   SELECT nval
   INTO v_max_dup_letters
   FROM CONFIG_DATA
   WHERE item_name = 'MAX_AWARD_LETTER_REQ';
   IF (r_stud_app_prog.dup_award_letter >= v_max_dup_letters) THEN
      /* the maximum allowed have already been sent */
      p_session_code := r_stud_app_prog.session_code;
      RETURN 'L';
   END IF;
   /* a duplicate can be sent so update stud crse year so a letter will be generated in the next run */
   p_session_code := r_stud_app_prog.session_code;
   RETURN 'S';
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      /* default session to this year */
      p_session_code := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'));
      /* if there is an Oracle error, return the not possible status */
      RETURN 'N';
   WHEN OTHERS THEN
      /* default session to this year */
      p_session_code := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'));
      /* if there is an Oracle error, return the not possible status */
      RETURN 'N';
END dup_letter_status;
-----------------------------------------------------------------------------------------------------
PROCEDURE create_csv_file(success_fail OUT VARCHAR2, error_msg OUT VARCHAR2) IS
--PB 2005
--
CURSOR cu_stud_ref_no IS
SELECT *
FROM TELEPHONY
where stud_ref_no is not null;
--
rec_stud_ref_no cu_stud_ref_no%ROWTYPE;
--
CURSOR cu_get_details(p_stud_ref_no IN NUMBER) IS
SELECT DISTINCT st.stud_ref_no, INITCAP (st.initials) initials,
                UPPER (st.forenames) forenames, UPPER (st.surname) surname,
                TRUNC (st.dob) dob, UPPER (st.ni_no) ni_no,
                UPPER (st.email_addr) email_addr, st.mobile_tel_no,
                TO_DATE (stcy.auto_calc_date,
                         'DD/MM/RRRR'
                        ) date_last_calculated,
                TO_DATE (stcy.sal_sent_date,
                         'DD/MM/RRRR'
                        ) date_last_award_letter_issued,
                UPPER (stha.house_no_name) home_house_no,
                UPPER (stha.addr_l1) home_addr_l1,
                UPPER (stha.addr_l2) home_addr_l2,
                UPPER (stha.addr_l3) home_addr_l3,
                UPPER (stha.addr_l4) home_addr_l4,
                UPPER (stha.post_code) home_post_code, stha.tele_no,
                UPPER (stta.house_no_name) term_house_no,
                UPPER (stta.addr_l1) term_addr_l1,
                UPPER (stta.addr_l2) term_addr_l2,
                UPPER (stta.addr_l3) term_addr_l3,
                UPPER (stta.addr_l4) term_addr_l4,
                UPPER (stta.post_code) term_post_code
           FROM stud st,
                stud_crse_year stcy,
                stud_home_addr stha,
                stud_term_addr stta
          WHERE st.stud_ref_no = p_stud_ref_no
            AND st.stud_ref_no = stcy.stud_ref_no
            AND stcy.session_code = (SELECT MAX (session_code)
                                       FROM stud_crse_year
                                      WHERE stud_ref_no = p_stud_ref_no)
            AND stcy.latest_crse_ind = 'Y'
            AND stcy.stud_ref_no = stha.stud_ref_no
            AND stha.end_date IS NULL
            AND stcy.stud_ref_no = stta.stud_ref_no(+)
            AND stta.end_date IS NULL;
--                             
rec_get_details cu_get_details%ROWTYPE;
--
V_APPLICATION_STATUS VARCHAR2(1);
V_APPLICATION_STATUS_DATE DATE;
V_TRAVEL_PROG_STATUS VARCHAR2(1);
V_TRAVEL_PROG_DATE DATE;
V_DUPLICATE_LOA_STATUS VARCHAR2(1);
V_DUPLICATE_LOA_SESSION VARCHAR2(4);
V_SESSION_CODE VARCHAR2(4);
V_PAYMENT_DATE DATE;
v_team VARCHAR2(10);
v_dob VARCHAR2(10);
v_temp_status stud_app_prog.case_status%TYPE;
--
hReport    Utl_File.File_Type;
v_path_name VARCHAR2(100);
e_stop_processing  EXCEPTION;
n_sql_code NUMBER;
v_sql_message VARCHAR2(2000);
v_invalid_chars config_data.cval%TYPE;
--
BEGIN
--

BEGIN
 SELECT cval
 INTO v_path_name
 FROM CONFIG_DATA
 WHERE item_name = 'TELE_DEST';
EXCEPTION
 WHEN NO_DATA_FOUND THEN
 success_fail := 'Fatal Error Detected';
 error_msg    := 'TELE_DEST config_data item could not be found';
 RAISE e_stop_processing;
END;
--
BEGIN
 hReport := UTL_FILE.FOPEN(v_path_name,'GRASS.txt', 'w');
--
EXCEPTION
 WHEN OTHERS THEN
 success_fail := 'Fatal Error Detected';
 error_msg    := 'Could not open output file.  Check that UTL_FILE parameter in INIT.ORA matches CONFIG_DATA value for TELE_DEST';
 RAISE e_stop_processing;
END;
--
UTL_FILE.PUT(hReport,'Student Forenames|Student Initials|Student Surname|Student Reference Number|Date of Birth|National Insurance Number|Date Last Calculated|Date Last Award Letter Issued|Home House Name/Number|Home Address Line 1|Home Address Line 2|Home Address Line 3|Home Address Line 4|Home Post Code|Term House Name/Number|Term Address Line 1|Term Address Line 2|Term Address Line 3|Term Address Line 4|Term Post Code|Team|Application Status|Application Status Date|Travel Progress Status|Travel Progress Date|Duplicate LOA status|Duplicate LOA Session|Main Phone Number|Email Address|Mobile Number|Record Status');
--
UTL_FILE.NEW_LINE(hReport);
--
rec_stud_ref_no := null;
--
-- RFC207
--
BEGIN
 SELECT NVL(cval,'|') cval
 INTO v_invalid_chars
 FROM CONFIG_DATA
 WHERE item_name = 'GRASS_INVALID_CHARS';
EXCEPTION
 WHEN NO_DATA_FOUND THEN
 success_fail := 'Fatal Error Detected';
 error_msg    := 'GRASS_INVALID_CHARS config_data item could not be found';
 RAISE e_stop_processing;
END;
--
FOR rec_stud_ref_no IN cu_stud_ref_no LOOP
 --
 V_APPLICATION_STATUS := NULL;
 V_APPLICATION_STATUS_DATE := NULL;
 V_TRAVEL_PROG_STATUS := NULL;
 V_TRAVEL_PROG_DATE := NULL;
 V_DUPLICATE_LOA_STATUS := NULL;
 V_DUPLICATE_LOA_SESSION := NULL;
 --
 OPEN cu_get_details(rec_stud_ref_no.stud_ref_no);
 rec_get_details := null;
 FETCH cu_get_details INTO rec_get_details;
  --
  V_DUPLICATE_LOA_STATUS := dup_letter_status(rec_stud_ref_no.stud_ref_no,v_duplicate_loa_session);
  v_application_status := get_application_status(rec_stud_ref_no.stud_ref_no,v_session_code,v_application_status_date);
  v_travel_prog_status := get_travel_status(rec_stud_ref_no.stud_ref_no,v_session_code,v_travel_prog_date,v_payment_date);
  v_travel_prog_date := TO_DATE(v_travel_prog_date,'DD/MM/RRRR');
  v_dob := to_char(rec_get_details.dob,'DD/MM/YYYY');
  --
  v_temp_status := NULL;
  --
  BEGIN
   SELECT case_status
   INTO v_temp_status
   FROM stud_app_prog
   WHERE stud_ref_no = rec_stud_ref_no.stud_ref_no;
   EXCEPTION
    WHEN NO_DATA_FOUND THEN
    v_temp_status := 'W';
  END;
  --
  rec_get_details.forenames := utils3.remove_invalid_chars@grass(rec_get_details.forenames,v_invalid_chars);
  rec_get_details.initials := utils3.remove_invalid_chars@grass( rec_get_details.initials,v_invalid_chars);
  rec_get_details.surname := utils3.remove_invalid_chars@grass(rec_get_details.surname,v_invalid_chars);
  rec_get_details.ni_no := utils3.remove_invalid_chars@grass(rec_get_details.ni_no,v_invalid_chars);
  rec_get_details.home_house_no := utils3.remove_invalid_chars@grass(rec_get_details.home_house_no,v_invalid_chars);
  rec_get_details.home_addr_l1 := utils3.remove_invalid_chars@grass(rec_get_details.home_addr_l1,v_invalid_chars);
  rec_get_details.home_addr_l2 := utils3.remove_invalid_chars@grass(rec_get_details.home_addr_l2,v_invalid_chars);
  rec_get_details.home_addr_l3 := utils3.remove_invalid_chars@grass(rec_get_details.home_addr_l3,v_invalid_chars);
  rec_get_details.home_addr_l4 := utils3.remove_invalid_chars@grass(rec_get_details.home_addr_l4,v_invalid_chars);
  rec_get_details.home_post_code := utils3.remove_invalid_chars@grass(rec_get_details.home_post_code,v_invalid_chars);
  rec_get_details.term_house_no := utils3.remove_invalid_chars@grass(rec_get_details.term_house_no,v_invalid_chars);
  rec_get_details.term_addr_l1 := utils3.remove_invalid_chars@grass(rec_get_details.term_addr_l1,v_invalid_chars);
  rec_get_details.term_addr_l2 := utils3.remove_invalid_chars@grass(rec_get_details.term_addr_l2,v_invalid_chars);
  rec_get_details.term_addr_l3 := utils3.remove_invalid_chars@grass(rec_get_details.term_addr_l3,v_invalid_chars);
  rec_get_details.term_addr_l4 := utils3.remove_invalid_chars@grass(rec_get_details.term_addr_l4,v_invalid_chars);
  rec_get_details.term_post_code := utils3.remove_invalid_chars@grass(rec_get_details.term_post_code,v_invalid_chars);
  v_travel_prog_status := utils3.remove_invalid_chars@grass(v_travel_prog_status,v_invalid_chars);
  rec_get_details.tele_no := utils3.remove_invalid_chars@grass(rec_get_details.tele_no,v_invalid_chars);
  rec_get_details.email_addr := utils3.remove_invalid_chars@grass(rec_get_details.email_addr,v_invalid_chars);
  rec_get_details.mobile_tel_no := utils3.remove_invalid_chars@grass( rec_get_details.mobile_tel_no,v_invalid_chars);
    -- RFC207 END
  IF UPPER(v_temp_status) <> 'W' THEN
   UTL_FILE.PUT(hReport,rec_get_details.forenames||'|');
   UTL_FILE.PUT(hReport,rec_get_details.initials||'|');
   UTL_FILE.PUT(hReport,rec_get_details.surname||'|');
   UTL_FILE.PUT(hReport,rec_stud_ref_no.stud_ref_no||'|');
   UTL_FILE.PUT(hReport,v_dob||'|');
   UTL_FILE.PUT(hReport,rec_get_details.ni_no||'|');
   UTL_FILE.PUT(hReport,TO_CHAR(rec_get_details.date_last_calculated,'DD/MM/YYYY')||'|');
   UTL_FILE.PUT(hReport,TO_CHAR(rec_get_details.date_last_award_letter_issued,'DD/MM/YYYY')||'|');
   UTL_FILE.PUT(hReport,rec_get_details.home_house_no||'|');
   UTL_FILE.PUT(hReport,rec_get_details.home_addr_l1||'|');
   UTL_FILE.PUT(hReport,rec_get_details.home_addr_l2||'|');
   UTL_FILE.PUT(hReport,rec_get_details.home_addr_l3||'|');
   UTL_FILE.PUT(hReport,rec_get_details.home_addr_l4||'|');
   UTL_FILE.PUT(hReport,rec_get_details.home_post_code||'|');
   UTL_FILE.PUT(hReport,rec_get_details.term_house_no||'|');
   UTL_FILE.PUT(hReport,rec_get_details.term_addr_l1||'|');
   UTL_FILE.PUT(hReport,rec_get_details.term_addr_l2||'|');
   UTL_FILE.PUT(hReport,rec_get_details.term_addr_l3||'|');
   UTL_FILE.PUT(hReport,rec_get_details.term_addr_l4||'|');
   UTL_FILE.PUT(hReport,rec_get_details.term_post_code||'|');
   UTL_FILE.PUT(hReport,v_team||'|');
   UTL_FILE.PUT(hReport,v_application_status||'|');
   UTL_FILE.PUT(hReport,TO_CHAR(v_application_status_date,'DD/MM/YYYY')||'|');
   UTL_FILE.PUT(hReport,v_travel_prog_status||'|');
   UTL_FILE.PUT(hReport,TO_CHAR(v_travel_prog_date,'DD/MM/YYYY')||'|');
   UTL_FILE.PUT(hReport,v_duplicate_loa_status||'|');
   UTL_FILE.PUT(hReport,v_duplicate_loa_session||'|');
   UTL_FILE.PUT(hReport,rec_get_details.tele_no||'|');
   UTL_FILE.PUT(hReport,rec_get_details.email_addr||'|');
   UTL_FILE.PUT(hReport,rec_get_details.mobile_tel_no||'|');
   UTL_FILE.PUT(hReport,rec_stud_ref_no.rec_status);
   --
   UTL_FILE.NEW_LINE(hReport);
  END IF;
 --
 CLOSE cu_get_details;
 --
 DELETE
 FROM TELEPHONY
 WHERE stud_ref_no = rec_stud_ref_no.stud_ref_no;
 --
 rec_stud_ref_no := null;
 --
END LOOP;
--
UTL_FILE.FCLOSE(hReport);
--
COMMIT;
--
success_fail      := 'Completed Successfully';
--
EXCEPTION
   WHEN e_stop_processing THEN
    NULL;
   WHEN NO_DATA_FOUND THEN
    n_sql_code      := SQLCODE;
    v_sql_message      := SQLERRM;
    success_fail      := 'No Data FOUND';
    error_msg      := 'No Data TO process';
   WHEN OTHERS THEN
    n_sql_code      := SQLCODE;
    v_sql_message      := SQLERRM;
    success_fail      := 'Fatal Error Detected';
    error_msg      := 'SQLCODE = '||n_sql_code||' SQL Message = '||v_sql_message;
END create_csv_file;
-----------------------------------------------------------------------------------------------------
PROCEDURE duplicate_loa (success_fail OUT VARCHAR2, error_msg OUT VARCHAR2) IS
--
vSFile     utl_file.file_type;
vNewLine VARCHAR2(200);
v_path_name VARCHAR2(100);
v_status VARCHAR2(1);
v_stud_ref_no STUD.stud_ref_no%TYPE;
v_req_date VARCHAR2(25);
v_session_code NUMBER;
v_letter_date DATE;
e_stop_processing  EXCEPTION;
n_sql_code NUMBER;
v_sql_message VARCHAR2(2000);
--
BEGIN
--
BEGIN
 SELECT cval
 INTO v_path_name
 FROM CONFIG_DATA
 WHERE item_name = 'LOA_LOCATION';
EXCEPTION
 WHEN NO_DATA_FOUND THEN
 success_fail := 'Fatal Error Detected';
 error_msg    := 'LOA_LOCATION config_data item could not be found';
 RAISE e_stop_processing;
END;
--
BEGIN
 vSFile := UTL_FILE.FOPEN(v_path_name,'LOA.txt', 'r');
EXCEPTION
 WHEN OTHERS THEN
 success_fail := 'Fatal Error Detected';
 error_msg    := 'Could not open output file.  Check that UTL_FILE parameter in INIT.ORA matches CONFIG_DATA value for TELE_DEST';
 RAISE e_stop_processing;
END;
--
  IF utl_file.is_open(vSFile) THEN
    utl_file.get_line(vSFile, vNewLine);
    LOOP
      BEGIN
    --
    utl_file.get_line(vSFile, vNewLine);
    --
    IF vNewLine IS NULL THEN
      EXIT;
    END IF;
    --
    v_stud_ref_no := SUBSTR(vNewLine,1,INSTR(vNewLine,'|')-1);
    v_req_date := SUBSTR(vNewLine,INSTR(vNewLine,'|')+1);
    --
    v_status := Telephony_Support.REQUEST_DUP_LETTER(v_stud_ref_no,v_session_code,v_letter_date);
        --
    IF v_status <> 'S' THEN
      dbms_output.put_line ('Unable to request Duplicate LOA Student: '||v_stud_ref_no||', Status:'||v_status);
      --success_fail := 'Unable to request Duplicate LOA';
      --error_msg     := 'Student Ref No:'||v_stud_ref_no||', Status:'||v_status;
      --RAISE e_stop_processing;
    ELSE
      dbms_output.put_line ('Duplicate LOA requested for Student: '||v_stud_ref_no);
    END IF;
    --
      EXCEPTION
    WHEN NO_DATA_FOUND THEN
      EXIT;
      END;
    END LOOP;
    COMMIT;
  END IF;
   utl_file.fclose(vSFile);
   success_fail      := 'Success';
   error_msg         := 'Finished';
--
EXCEPTION
  WHEN e_stop_processing THEN
    NULL;
  WHEN NO_DATA_FOUND THEN
    n_sql_code      := SQLCODE;
    v_sql_message      := SQLERRM;
    success_fail      := 'No Data FOUND';
    error_msg      := 'No Data TO process';
  WHEN utl_file.invalid_mode THEN
    n_sql_code      := SQLCODE;
    v_sql_message      := SQLERRM;
    success_fail      := 'Invalid Mode Parameter';
    error_msg      := 'SQLCODE = '||n_sql_code||' SQL Message = '||v_sql_message;
  WHEN utl_file.invalid_path THEN
    n_sql_code      := SQLCODE;
    v_sql_message      := SQLERRM;
    success_fail      := 'Invalid File Location';
    error_msg      := 'SQLCODE = '||n_sql_code||' SQL Message = '||v_sql_message;
  WHEN utl_file.invalid_filehandle THEN
    n_sql_code      := SQLCODE;
    v_sql_message      := SQLERRM;
    success_fail      := 'Invalid Filehandle';
    error_msg      := 'SQLCODE = '||n_sql_code||' SQL Message = '||v_sql_message;
  WHEN utl_file.invalid_operation THEN
    n_sql_code      := SQLCODE;
    v_sql_message      := SQLERRM;
    success_fail      := 'Invalid Operation';
    error_msg      := 'SQLCODE = '||n_sql_code||' SQL Message = '||v_sql_message;
  WHEN utl_file.read_error THEN
    n_sql_code      := SQLCODE;
    v_sql_message      := SQLERRM;
    success_fail      := 'Read Error';
    error_msg      := 'SQLCODE = '||n_sql_code||' SQL Message = '||v_sql_message;
  WHEN utl_file.internal_error THEN
    n_sql_code      := SQLCODE;
    v_sql_message      := SQLERRM;
    success_fail      := 'Internal Error';
    error_msg      := 'SQLCODE = '||n_sql_code||' SQL Message = '||v_sql_message;
 /*WHEN utl_file.file_open THEN
    n_sql_code      := SQLCODE;
    v_sql_message      := SQLERRM;
    success_fail      := 'File Already Opened';
    error_msg      := 'SQLCODE = '||n_sql_code||' SQL Message = '||v_sql_message;*/
 WHEN utl_file.invalid_maxlinesize THEN
    n_sql_code      := SQLCODE;
    v_sql_message      := SQLERRM;
    success_fail      := 'Line Size Exceeds 32K';
    error_msg      := 'SQLCODE = '||n_sql_code||' SQL Message = '||v_sql_message;
 /*WHEN utl_file.invalid_filename THEN
    n_sql_code      := SQLCODE;
    v_sql_message      := SQLERRM;
    success_fail      := 'Invalid File Name';
    error_msg      := 'SQLCODE = '||n_sql_code||' SQL Message = '||v_sql_message;
 WHEN utl_file.access_denied THEN
    n_sql_code      := SQLCODE;
    v_sql_message      := SQLERRM;
    success_fail      := 'File Access Denied By';
    error_msg      := 'SQLCODE = '||n_sql_code||' SQL Message = '||v_sql_message;*/
  WHEN OTHERS THEN
    n_sql_code      := SQLCODE;
    v_sql_message      := SQLERRM;
    success_fail      := 'Fatal Error Detected';
    error_msg      := 'SQLCODE = '||n_sql_code||' SQL Message = '||v_sql_message;
END duplicate_loa;
-----------------------------------------------------------------------------------------------------
PROCEDURE update_web_mail (p_stud_ref_no NUMBER, p_email_addr VARCHAR2) IS

v_web_stud_rec_exists varchar2(1);
v_existing_email stud.email_addr%TYPE;
v_count_web_rec number(10);

BEGIN
/*   BEGIN
    select email_addr
    into v_existing_email
    from stud
    where stud_ref_no = p_stud_ref_no;
    EXCEPTION
     when no_data_found then
     v_web_stud_rec_exists := 'N';
     v_existing_email := NULL;
    end;
--
   BEGIN
      select count(*)
      into v_count_web_rec
      from personal_details@Web.world
      where application_id = (select application_id
                from personal_numbers@Web.world
                where stud_ref_no = p_stud_ref_no);
    EXCEPTION
     when no_data_found then
     v_web_stud_rec_exists := 'N';
     v_existing_email := NULL;
    end;
--
    if NVL(p_email_addr,'X') != 'X' AND v_web_stud_rec_exists = 'Y' AND v_count_web_rec > 0 then
       if NVL(v_existing_email,'X') != NVL(p_email_addr,'X') then
        update personal_details@Web.world
        set home_email = p_email_addr
        where application_id = (select application_id
                    from personal_numbers@Web.world
                    where stud_ref_no = p_stud_ref_no);
        end if;
    end if;*/
return;
exception
WHEN OTHERS THEN
return;
END; --Update web email addr

END Telephony_Support;
/

GRANT EXECUTE ON  SGAS.TELEPHONY_SUPPORT TO PUBLIC;

CREATE PUBLIC SYNONYM TELEPHONY_SUPPORT FOR SGAS.TELEPHONY_SUPPORT;

