CREATE OR REPLACE PACKAGE BODY SGAS.MAINTAIN_REPOSITORY AS
-------------------------------------------------------------------------------
-- Function to handle the update or delete of application status records
-------------------------------------------------------------------------------
FUNCTION record_app_status (stud_ref_no_in NUMBER,
                case_status VARCHAR2,
                stud_crse_year_id_in NUMBER,
                stored_date_in DATE)
RETURN VARCHAR2 IS
BEGIN
    IF case_status ='D' THEN
        /* application deleted */
        DELETE FROM stud_app_prog
        WHERE STUD_REF_NO = stud_ref_no_in;
--
    ELSIF case_status ='R' THEN
        /* application registered - Used for web applications */
        UPDATE stud_app_prog
        SET DATE_REGISTERED = stored_date_in,
            CASE_STATUS = 'R',
            STUD_CRSE_YEAR_ID = stud_crse_year_id_in
        WHERE STUD_REF_NO = stud_ref_no_in;
--
    ELSIF case_status ='C' THEN
        /* application assessed or re-assessed */
        UPDATE stud_app_prog
        SET DATE_CALCULATED = stored_date_in,
            CASE_STATUS = 'C'
        WHERE STUD_CRSE_YEAR_ID = stud_crse_year_id_in;
--
    ELSIF case_status ='L' THEN
        /* the award letter sent */
        UPDATE stud_app_prog
        SET AWARD_LETTER_SENT_DATE = stored_date_in,
            CASE_STATUS = 'L'
        WHERE STUD_CRSE_YEAR_ID = stud_crse_year_id_in;
--
    ELSIF case_status = 'S' THEN
        /* data sent to SLC*/
        UPDATE stud_app_prog
        SET SLC_SENT_DATE = stored_date_in,
            CASE_STATUS = 'S'
        WHERE STUD_CRSE_YEAR_ID = stud_crse_year_id_in;
--
    ELSIF case_status = 'U' THEN
        /* a change of course processed */
        UPDATE stud_app_prog
        SET DATE_REGISTERED = stored_date_in,
            CASE_STATUS = 'U'
        WHERE STUD_CRSE_YEAR_ID = stud_crse_year_id_in;
--
    ELSIF case_status = 'W' THEN
        /* a change of course processed */
        UPDATE stud_app_prog
        SET WEB_SUBMITTED_DATE = stored_date_in,
            CASE_STATUS = 'W'
        WHERE STUD_REF_NO = stud_ref_no_in;
    END IF;
--
    RETURN 'Y';
--
EXCEPTION
    /* there are occasions when there may be no record in the current session
       e.g. when recalculating an earlier session where all later crse records
       have been deleted. this is not a problem but will cause the updates to
       fail so 'N' is returned here */
    WHEN OTHERS THEN
        RETURN 'N';
END record_app_status;
--
--
--
--
FUNCTION record_trav_status (award_id_in NUMBER, payments_made NUMBER, min_date DATE, max_date DATE) RETURN VARCHAR2 IS
   TmpVar VARCHAR(2);
   stud_crse_year_id_match NUMBER(9);
   stud_crse_year_id_trav NUMBER(9);
   latest_temp VARCHAR2(1);
--   count_temp Number(5);
BEGIN
   SELECT DISTINCT(stud_crse_year_id) INTO stud_crse_year_id_match FROM award WHERE award_id = award_id_in;
   SELECT stud_crse_year_id INTO stud_crse_year_id_trav FROM stud_trav_prog WHERE stud_crse_year_id = stud_crse_year_id_match;
   SELECT latest_crse_ind INTO latest_temp FROM stud_crse_year WHERE stud_crse_year_id = stud_crse_year_id_match;
--   SELECT count(*)
--   INTO count_temp
--   FROM  award_instalment
--   WHERE award_id = award_id_in AND payment_status IN ('A', 'U');
   IF (stud_crse_year_id_trav = stud_crse_year_id_match) AND latest_temp = 'Y'
--   THEN IF count_temp > 0
   THEN IF payments_made > 0
           THEN UPDATE stud_trav_prog
--             SET PAYMENT_DATE = ((SELECT min(payment_due_date) FROM award_instalment WHERE award_id= award_id_in AND payment_status IN ('A', 'U')))
             SET PAYMENT_DATE = min_date + 10
             WHERE STUD_CRSE_YEAR_ID = stud_crse_year_id_match;
        ELSE
             UPDATE stud_trav_prog
--             SET PAYMENT_DATE = ((select max(payment_due_date) from award_instalment where award_id= award_id_in))
             SET PAYMENT_DATE = max_date + 10
             WHERE STUD_CRSE_YEAR_ID = stud_crse_year_id_match;
        END IF;
    END IF;
   tmpVar := 0;
   RETURN tmpVar;
END record_trav_status;
--
--
--
--
-------------------------------------------------------------------------------
-- Procedure to delete from the application, travel or mis repositories
-------------------------------------------------------------------------------
PROCEDURE delete_session (session_code_in NUMBER,
              mis_delete_date VARCHAR2,
              repository VARCHAR2) IS
    /* local variables */
    v_current_sess config_data.cval%TYPE;
BEGIN
-- ensure that RBS1 is used
    COMMIT;
    SET TRANSACTION USE ROLLBACK SEGMENT RBS1;
--
    /* determine the current session - data for sessions later than the
       current one will not be deleted */
    SELECT cval
    INTO v_current_sess
    FROM config_data
    WHERE item_name = 'CURRENT_SESSION';
    /* verify the passed session is not in the future */
    IF session_code_in > v_current_sess THEN
    /* write an error message to the error log */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(sysdate, 'DD.MM.YYYY HH24:MI:SS') ||
                 ':Cannot delete repository data for session ' ||
                 session_code_in ||
                 ' because it is later than current session ' ||
                 v_current_sess);
    RETURN;
    END IF;
    /* delete from the tables depending on the repository parameter */
    IF (UPPER(repository) = 'APP') THEN
    /* delete all application progress records for earlier sessions
       that are complete (letter sent or SLC data sent) */
    DELETE FROM stud_app_prog
    WHERE session_code < session_code_in
    AND case_status IN ('L', 'S');
    ELSIF (UPPER(repository) = 'TRAV') THEN
    /* delete all travel progress records for earlier sessions */
    DELETE FROM stud_trav_prog
    WHERE session_code < session_code_in;
    ELSIF (UPPER(repository) = 'MIS') THEN
    /* delete all application progress records for earlier sessions
       that are complete (letter sent or SLC data sent) */
    DELETE FROM telephony_mis
    WHERE start_time < TO_DATE(mis_delete_date,'YYYYMMDD');
    ELSE
    /* write an error message to the error log */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(sysdate, 'DD.MM.YYYY HH24:MI:SS') ||
                 ':Cannot delete repository data for unknown ' ||
                 'repository type ' || repository);
    RETURN;
    END IF;
    /* report standard operation */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(sysdate, 'DD.MM.YYYY HH24:MI:SS') ||
             ':Deleted ' || SQL%ROWCOUNT || ' records from ' ||
             'repository type ' || repository ||
             ' for session ' || session_code_in);
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(sysdate, 'DD.MM.YYYY HH24:MI:SS') ||
                 ':No data found when deleting from ' ||
                 'repository type ' || repository ||
                 ' in session ' || session_code_in);
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(sysdate, 'DD.MM.YYYY HH24:MI:SS') ||
                 ':Oracle error raised ('|| SQLCODE ||
                 '-' || SQLERRM || ' when deleting ' ||
                 'repository type ' || repository ||
                 ' in session ' || session_code_in);
END delete_session;
--
--
--
--
-------------------------------------------------------------------------------
-- Additional function to determine the latest student course year
-------------------------------------------------------------------------------
FUNCTION latest_stud_crse_year (p_stud_ref_no NUMBER,
                p_session_code NUMBER,
                p_latest_crse_ind VARCHAR2) RETURN VARCHAR2 IS
    /* local variables */
    v_max_session_code stud_crse_year.session_code%TYPE;
BEGIN
    /* check the latest course indicator */
    IF p_latest_crse_ind <> 'Y' THEN
    /* this is not the latest course - return no */
    RETURN 'N';
    ELSE
    /* check that this record is in the latest session */
    SELECT MAX(session_code)
    INTO v_max_session_code
    FROM stud_session
    WHERE stud_ref_no = p_stud_ref_no;
    /* check fetched latest session against this records session */
    IF p_session_code < v_max_session_code THEN
        /* this is not the latest session - return no */
        RETURN 'N';
    ELSE
        /* this is the latest session and course record - return yes */
        RETURN 'Y';
    END IF;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    /* When no data is found, assume its the last (only) course */
    RETURN 'Y';
    WHEN OTHERS THEN
    /* For other errors, return no */
    RETURN 'N';
END latest_stud_crse_year;
--
--
--
--
-------------------------------------------------------------------------------
-- Function for creating an entry in the stud app progress table for a new
-- or existing student course year record (latest session, course assumed)
-------------------------------------------------------------------------------
FUNCTION create_app_status (p_stud_ref_no NUMBER,
                p_stud_crse_year_id NUMBER,
                p_session_code NUMBER,
                p_entered_date DATE,
                p_auto_calc_date DATE,
                p_sal_sent_date DATE,
                p_slc2_sent_date DATE) RETURN VARCHAR2 IS
    /* local variables */
    v_slc_ref_no stud.scottish_cand%TYPE;
    v_case_status stud_app_prog.case_status%TYPE;
    v_count          NUMBER(2) := 0;
    v_session_code stud_session.session_code%TYPE;
BEGIN
    /* get the SLC reference number */
    BEGIN
        SELECT scottish_cand
        INTO v_slc_ref_no
        FROM stud
        WHERE stud_ref_no = p_stud_ref_no;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_slc_ref_no := NULL;
    END;
--
    /* determine status */
    IF p_slc2_sent_date IS NOT NULL THEN
        v_case_status := 'S';
    ELSIF p_sal_sent_date IS NOT NULL THEN
        v_case_status := 'L';
    ELSIF p_auto_calc_date IS NOT NULL THEN
        v_case_status := 'C';
    ELSE
        v_case_status := 'R';
    END IF;
--
    /* create record in stud_app_prog if one doesn't already exist*/
    SELECT COUNT(*)
    INTO v_count
    FROM stud_app_prog
    WHERE stud_ref_no = p_stud_ref_no;
--
    v_session_code := p_session_code;
    IF check_nmsb_session(p_stud_ref_no, p_stud_crse_year_id,v_session_code) = 'OK' THEN
--
    IF v_count = 0 THEN
        INSERT INTO stud_app_prog
            (stud_ref_no,
            slc_ref_no,
            stud_crse_year_id,
            session_code,
            case_status,
            date_registered,
            date_calculated,
            award_letter_sent_date,
            slc_sent_date,
            dup_award_letter)
        VALUES (p_stud_ref_no,
            v_slc_ref_no,
            p_stud_crse_year_id,
            v_session_code,
            v_case_status,
            p_entered_date,
            p_auto_calc_date,
            p_sal_sent_date,
            p_slc2_sent_date,
            0); -- default for dup_award_letter
    END IF;
    END IF;    -- NMSB Check
--
    /* return the derived case status */
    RETURN v_case_status;
--
EXCEPTION
    WHEN OTHERS THEN
        /* report failure without causing forms errors */
        RETURN 'N';
END create_app_status;
--
--
--
--
-------------------------------------
-- The init_repos top level package.
-------------------------------------
-------------------------------------
PROCEDURE init_repos( success_fail  OUT VARCHAR2,
              start_finish  OUT VARCHAR2,
              num_procd     OUT VARCHAR2,
              error_msg        OUT VARCHAR2 ) IS
--
---BASE_NOM_STR CONSTANT VARCHAR2(20) := 'FFFFFFFFFFFFFFFFFFFF';
--
------------------------------------------
-- Declare stud_crse_year fields required.
------------------------------------------
v_stud_ref_no           stud_crse_year.stud_ref_no%TYPE;
v_slc_ref_no           stud.scottish_cand%TYPE;
v_stud_crse_year_id       stud_crse_year.stud_crse_year_id%TYPE;
v_trav_stud_crse_year_id   stud_crse_year.stud_crse_year_id%TYPE;
v_session_code           stud_crse_year.session_code%TYPE;
v_trav_session_code       stud_crse_year.session_code%TYPE;
v_entered_date           stud_crse_year.entered_date%TYPE;
v_auto_calc_date       stud_crse_year.auto_calc_date%TYPE;
v_sal_sent_date        stud_crse_year.sal_sent_date%TYPE;
v_first_sal_date       stud_crse_year.first_sal_date%TYPE;
v_slc2_sent_date       stud_crse_year.slc2_sent_date%TYPE;
v_slc2_status           stud_crse_year.slc2_status%TYPE;
v_award_letter_sent_date   stud_crse_year.sal_sent_date%TYPE;
v_dup_award_letter       stud_app_prog.dup_award_letter%TYPE;
v_case_status           stud_app_prog.case_status%TYPE;
v_assessment_date       award.assessment_date%TYPE;
v_award_id           award.award_id%TYPE;
v_payment_due_date       award_instalment.payment_due_date%TYPE;
v_current_session       config_data.cval%TYPE;
v_item_name           config_data.item_name%TYPE;
--
-----------------------------------
-- Declare working fields required.
-----------------------------------
--
start_date          DATE;
finish_date          DATE;
--
success_count          NUMBER(5);
fail_count          NUMBER(5);
--
v_err_msg          varchar2(255);
--
called_func_failed    EXCEPTION;
--
b_debug           BOOLEAN;
b_case_status_found   BOOLEAN;
b_unpaid_travel_found BOOLEAN;
b_paid_travel_found BOOLEAN;
v_last_stud_ref_no    stud_crse_year.stud_ref_no%TYPE;
b_award_sent_found    BOOLEAN;
n_num_sap          NUMBER(9);
n_num_stp          NUMBER(9);
n_num_apps          NUMBER (9);
n_num_travs          NUMBER (9);
n_num_scy          NUMBER (9);
n_num_scy_disc          NUMBER (9);
n_num_scy_to_do       NUMBER (9);
--
------------------------------------------
-- Find travel awards for the student.
-- Return the earliest unpaid award first.
------------------------------------------
CURSOR c_paid_travel_award (v_stud_ref_no stud_crse_year.stud_ref_no%TYPE, v_current_session config_data.cval%TYPE) IS
  SELECT a.assessment_date,
     ai.payment_due_date,
     a.award_id,
     a.stud_crse_year_id,
     a.session_code
  FROM award a, award_instalment ai
  WHERE a.stud_ref_no = v_stud_ref_no
  AND a.award_id = ai.award_id
  AND (ai.payment_status IS NULL)
  AND a.stud_award_type IN ('UGTE', 'UGLTE', 'PSTE', 'PSLTE')
  AND a.session_code >= v_current_session
  ORDER BY ai.payment_due_date DESC;
--
CURSOR c_unp_travel_award (v_stud_ref_no stud_crse_year.stud_ref_no%TYPE, v_current_session config_data.cval%TYPE) IS
  SELECT a.assessment_date,
     ai.payment_due_date,
     a.award_id,
     a.stud_crse_year_id,
     a.session_code
  FROM award a, award_instalment ai
  WHERE a.stud_ref_no = v_stud_ref_no
  AND a.award_id = ai.award_id
  AND (ai.payment_status = 'U' OR ai.payment_status = 'A')
  AND a.stud_award_type IN ('UGTE', 'UGLTE', 'PSTE', 'PSLTE')
  AND a.session_code >= v_current_session
  ORDER BY ai.payment_due_date ASC;
--
-------------------------------------------------
-- Find the scy records for students after the current session.
---------------------------------------------------------------
CURSOR c_scy (v_current_session config_data.cval%TYPE) IS
  SELECT scy.stud_ref_no,
     s.scottish_cand,
     scy.stud_crse_year_id,
     scy.session_code,
     scy.entered_date,
     scy.auto_calc_date,
     scy.sal_sent_date,
     scy.first_sal_date,
     scy.slc2_sent_date,
     scy.slc2_status
  FROM stud_crse_year scy, stud s
  WHERE scy.stud_ref_no = s.stud_ref_no
  AND scy.session_code >= v_current_session
  AND scy.latest_crse_ind = 'Y'
  ORDER BY scy.stud_ref_no DESC, scy.session_code DESC;
--
BEGIN
--
   DBMS_OUTPUT.PUT_LINE ( ' ' );
   DBMS_OUTPUT.PUT_LINE ( 'initialise_repository: START - ' || TO_CHAR ( SYSDATE, 'dd-mon-yyyy hh24:mi' ) );
   DBMS_OUTPUT.PUT_LINE ( ' ' );
--
   success_count := 0;
   fail_count := 0;
   b_debug := FALSE;
   v_item_name := 'CURRENT_SESSION';
   v_current_session := NULL;
   n_num_sap := 0;
   n_num_stp := 0;
   start_date := NULL;
   finish_date := NULL;
   v_err_msg := NULL;
   v_last_stud_ref_no := 0;
   n_num_apps :=0;
   n_num_travs :=0;
   n_num_scy :=0;
   n_num_scy_to_do := 0;
   n_num_scy_disc := 0;
   num_procd := NULL;
--
--
   commit;
   set transaction use rollback segment RBS1;
--
   SELECT sysdate INTO start_date FROM dual;
   -----------------------------
   -- Find the current session.
   -----------------------------
   SELECT CVAL
   INTO v_current_session
   FROM config_data
   WHERE ITEM_NAME = v_item_name;
--
   ---------------------------------------------------------------------
   -- delete the contents of the stud_app_prog and stud_trav_prog tables.
   ----------------------------------------------------------------------
   ----------------------------------------------------------------------
   SELECT COUNT (*)
   INTO n_num_sap
   FROM stud_app_prog;
--
   commit;
   set transaction use rollback segment RBS1;
--
   DELETE from stud_app_prog;
   commit;
   set transaction use rollback segment RBS1;
--
   DBMS_OUTPUT.PUT_LINE ( '---');
   DBMS_OUTPUT.PUT_LINE ( n_num_sap || ' stud_app_prog records deleted at ' || TO_CHAR ( SYSDATE, 'dd-mon-yyyy hh24:mi' ) );
--
   SELECT COUNT (*)
   INTO n_num_stp
   FROM stud_trav_prog;
--
   commit;
   set transaction use rollback segment RBS1;
--
   DELETE from stud_trav_prog;
   commit;
   set transaction use rollback segment RBS1;
--
   DBMS_OUTPUT.PUT_LINE ( n_num_stp || ' stud_trav_prog records deleted at ' || TO_CHAR ( SYSDATE, 'dd-mon-yyyy hh24:mi' ) );
--
   SELECT COUNT (*)
   INTO n_num_scy_to_do
   FROM stud_crse_year scy, stud s
   WHERE scy.stud_ref_no = s.stud_ref_no
   AND scy.session_code >= v_current_session
   AND scy.latest_crse_ind = 'Y'
   ORDER BY scy.stud_ref_no DESC, scy.session_code DESC;
--
   commit;
   set transaction use rollback segment RBS1;
--
   DBMS_OUTPUT.PUT_LINE ( ' Processing students from '    || v_current_session );
   DBMS_OUTPUT.PUT_LINE ( n_num_scy_to_do || ' stud_crse_year records to process. ' );
   DBMS_OUTPUT.PUT_LINE ( '---');
--
--
   OPEN c_scy (v_current_session);
--
   LOOP
--
     ------------------------------------
     -- Initialise all re used variables.
     ------------------------------------
     v_stud_ref_no := NULL;
     v_slc_ref_no := NULL;
     v_stud_crse_year_id := NULL;
     v_session_code := NULL;
     v_entered_date := NULL;
     v_auto_calc_date := NULL;
     v_sal_sent_date := NULL;
     v_first_sal_date := NULL;
     v_slc2_sent_date := NULL;
     v_slc2_status := NULL;
     v_award_letter_sent_date := NULL;
     v_case_status := NULL;
     v_assessment_date := NULL;
     v_award_id  := NULL;
     v_payment_due_date := NULL;
     v_dup_award_letter := 0;
--
     b_case_status_found := FALSE;
     v_trav_stud_crse_year_id := NULL;
     v_trav_session_code := NULL;
     b_unpaid_travel_found := TRUE;
--
--
      FETCH c_scy INTO    v_stud_ref_no,
            v_slc_ref_no,
            v_stud_crse_year_id,
            v_session_code,
            v_entered_date,
            v_auto_calc_date,
            v_sal_sent_date,
            v_first_sal_date,
            v_slc2_sent_date,
            v_slc2_status ;
--
      EXIT WHEN c_scy%NOTFOUND;
      -------------------------------------------------------
      -- Process only the latest scy record for this student.
      -------------------------------------------------------
--
      n_num_scy := (n_num_scy + 1);
--
      IF (v_last_stud_ref_no <> v_stud_ref_no) THEN
    --------------------------------------------------------------------------------
    -- The current student is not the same as the last student, process this record.
    --------------------------------------------------------------------------------
    IF (b_debug) THEN
       DBMS_OUTPUT.PUT_LINE ( 'Student ' || v_stud_ref_no || ' on course ' || v_session_code || ' scy_id ' || v_stud_crse_year_id );
    END IF;
--
    -------------------------------
    -- Find the application status.
    -------------------------------
    -------------------------------
    b_case_status_found := FALSE;
    ----------------------------------------------------------------------------------
    -- If the slc file has been sent and the sls status is 'S' set status to be 'S'lc.
    ----------------------------------------------------------------------------------
    IF (v_slc2_sent_date IS NOT NULL) AND (v_slc2_status = 'S') AND (NOT b_case_status_found) THEN
        v_case_status := 'S';
        b_case_status_found := TRUE;
    ELSE
        v_slc2_sent_date := NULL;
    END IF;
    ----------------------------------------------------------------
    -- If the award letter has been sent set the status to 'L'etter.
    ----------------------------------------------------------------
    IF ((v_sal_sent_date IS NOT NULL) OR (v_first_sal_date IS NOT NULL)) AND (NOT b_case_status_found) THEN
        v_case_status := 'L';
        b_case_status_found := TRUE;
    END IF;
    -------------------------------------------------------------------
    -- If the award has been calculated set the status to 'C'alculated.
    -------------------------------------------------------------------
    IF (v_auto_calc_date IS NOT NULL) AND (NOT b_case_status_found) THEN
        v_case_status := 'C';
        b_case_status_found := TRUE;
    END IF;
    ---------------------------------------------------------------------------
    -- If none of the above conditions were met set the status to 'R'egistered.
    ---------------------------------------------------------------------------
    IF (NOT b_case_status_found) THEN
        v_case_status := 'R';
        b_case_status_found := TRUE;
    END IF;
    ---------------------------------------------------------------------------
    -- Find the award_letter_date.
    -- If a sal_sent or first_sal_sent_date cannot be forund, leave it as null.
    ----------------------------------------------------------------------------
    IF (b_debug) THEN
        DBMS_OUTPUT.PUT_LINE ( 'Student ' || v_stud_ref_no || ' has a sal_sent_date '  || TO_CHAR(v_sal_sent_date,'dd-MON-yy hh24:mi') );
        DBMS_OUTPUT.PUT_LINE ( 'Student ' || v_stud_ref_no || ' has a first_sal_date ' || TO_CHAR(v_first_sal_date,'dd-MON-yy hh24:mi') );
    END IF;
--
    b_award_sent_found := FALSE;
    IF (v_sal_sent_date IS NOT NULL) AND (NOT b_award_sent_found) THEN
       v_award_letter_sent_date := v_sal_sent_date;
       b_award_sent_found := TRUE;
    END IF;
--
    IF (v_first_sal_date IS NOT NULL) AND (NOT b_award_sent_found) THEN
      v_award_letter_sent_date := v_first_sal_date;
      b_award_sent_found := TRUE;
    END IF;
    ------------------------------------------------------------------------
    -- Find the latest unpaid travel award instalment data for this student.
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
    b_unpaid_travel_found := FALSE;
    b_paid_travel_found := FALSE;
--
    OPEN c_unp_travel_award (v_stud_ref_no, v_current_session);
--
--
    FETCH c_unp_travel_award INTO v_assessment_date,
                      v_payment_due_date,
                      v_award_id,
                      v_trav_stud_crse_year_id,
                      v_trav_session_code;
--
    IF NOT c_unp_travel_award%NOTFOUND THEN
       -----------------------------------------------------------------------
       -- Unpaid travel award found for this scy record, create an stp record.
       -- We only need to take the earliest unpaid travel award record.
       -- If an unpaid travel award does not exist then search for the latest
       -- paid award.
       ------------------------------------------------------------------------
       b_unpaid_travel_found := TRUE;
       IF (b_debug) THEN
          DBMS_OUTPUT.PUT_LINE ( 'Student ' || v_stud_ref_no || ' has unpaid travel award ' || v_award_id || ' for ' || TO_CHAR(v_assessment_date,'dd-MON-yy hh24:mi') );
       END IF;
    END IF;
--
    CLOSE c_unp_travel_award;
--
    -------------------------------------------------------------------
    -- If an unpaid travel was not found, find the earliest paid travel
    -- award instalment data for this student.
    -------------------------------------------------------------------
    -------------------------------------------------------------------
    IF (NOT b_unpaid_travel_found) THEN
--
       OPEN c_paid_travel_award (v_stud_ref_no, v_current_session);
--
       FETCH c_paid_travel_award INTO v_assessment_date,
                      v_payment_due_date,
                      v_award_id,
                      v_trav_stud_crse_year_id,
                      v_trav_session_code;
--
       IF NOT c_paid_travel_award%NOTFOUND THEN
          ---------------------------------------------------------------------
          -- Paid travel award found for this scy record, create an stp record.
          ---------------------------------------------------------------------
          b_paid_travel_found := TRUE;
          IF (b_debug) THEN
         DBMS_OUTPUT.PUT_LINE ( ' Student' || v_stud_ref_no || ' has paid travel award ' || v_award_id || ' for ' || TO_CHAR(v_assessment_date,'dd-MON-yy hh24:mi') || TO_CHAR(v_payment_due_date,'dd-MON-yy hh24:mi') );
          END IF;
       END IF;
--
       CLOSE c_paid_travel_award;
--
    END IF;
--
    --------------------------------------------------------------------
    -- Insert stud_app_prog and stud_trav_prog records for this student.
    --------------------------------------------------------------------
    --------------------------------------------------------------------
    IF (b_debug) THEN
       DBMS_OUTPUT.PUT_LINE ( 'Inserting stud_app_prog for Student ' || v_stud_ref_no || ';' || v_slc_ref_no || ';' || v_stud_crse_year_id || ';' || v_session_code || ';' || v_case_status || ';' || TO_CHAR (v_entered_date, 'dd-mon-yyyy hh24:mi') || ';
' || TO_CHAR (v_auto_calc_date, 'dd-mon-yyyy hh24:mi')    || ';' || TO_CHAR (v_award_letter_sent_date, 'dd-mon-yyyy hh24:mi') || ';' || TO_CHAR (v_slc2_sent_date, 'dd-mon-yyyy hh24:mi') || ';' || v_dup_award_letter );
    END IF;
--

    IF check_nmsb_session(v_stud_ref_no, v_stud_crse_year_id,v_session_code) = 'OK' THEN
    INSERT INTO stud_app_prog
    (STUD_REF_NO,
     SLC_REF_NO,
     STUD_CRSE_YEAR_ID,
     SESSION_CODE,
     CASE_STATUS,
     DATE_REGISTERED,
     DATE_CALCULATED,
     AWARD_LETTER_SENT_DATE,
     SLC_SENT_DATE,
     DUP_AWARD_LETTER)
    VALUES
    (v_stud_ref_no,
     v_slc_ref_no,
     v_stud_crse_year_id,
     v_session_code,
     v_case_status,
     v_entered_date,
     v_auto_calc_date,
     v_award_letter_sent_date,
     v_slc2_sent_date,
     v_dup_award_letter
     );
     END IF;
--
    n_num_apps := (n_num_apps + 1);
--
    IF ( (b_unpaid_travel_found) OR (b_paid_travel_found) ) THEN
--
       IF (b_debug) THEN
          DBMS_OUTPUT.PUT_LINE ( 'Inserting stud_trav_prog for Student ' || v_stud_ref_no || ';' || v_slc_ref_no || ';' || v_trav_stud_crse_year_id || ';' || v_trav_session_code || ';' || TO_CHAR (v_assessment_date, 'dd-mon-yyyy hh24:mi') || ';' ||
      TO_CHAR (v_payment_due_date, 'dd-mon-yyyy hh24:mi') );
       END IF;
--
       INSERT INTO stud_trav_prog
        (STUD_REF_NO,
        SLC_REF_NO,
        STUD_CRSE_YEAR_ID,
        SESSION_CODE,
        DATE_ASSESSED,
        PAYMENT_DATE)
       VALUES
       (v_stud_ref_no,
        v_slc_ref_no,
        v_trav_stud_crse_year_id,
        v_trav_session_code,
        v_assessment_date,
        v_payment_due_date
       );
--
       n_num_travs := (n_num_travs + 1);
    END IF;
--
      ELSE
     ---------------------------------------
     -- Ignore student as processed earlier.
     ---------------------------------------
     n_num_scy_disc := (n_num_scy_disc + 1);
     IF (b_debug) THEN
        DBMS_OUTPUT.PUT_LINE ( ' Student ' || v_stud_ref_no || ' on course ' || v_session_code || ' same as last student ' || v_last_stud_ref_no || ' Not processing it. ');
     END IF;
      END IF;
--
      ---------------------------------------------------------------
      -- Save this stud_ref_no as only need to process latest record.
      ---------------------------------------------------------------
      IF (b_debug) THEN
     DBMS_OUTPUT.PUT_LINE ( ' --- ' );
      END IF;
      v_last_stud_ref_no := v_stud_ref_no;
--
-- End scy loop
   END LOOP;
--
   CLOSE c_scy;
--
   -------------------------------
   -- Commit all records together.
   -------------------------------
   commit;
   set transaction use rollback segment RBS1;
--
   DBMS_OUTPUT.PUT_LINE ( ' ' );
   DBMS_OUTPUT.PUT_LINE ( 'initialise_repository: ENDING - ' || TO_CHAR ( SYSDATE, 'dd-mon-yyyy hh24:mi' ) );
   DBMS_OUTPUT.PUT_LINE ( ' ' );
--
   SELECT sysdate INTO finish_date FROM dual;
--
   success_fail := 'Completed Successfully';
   error_msg := null;
   start_finish := 'Started '||TO_CHAR(start_date,'dd-MON-yy hh24:mi')||
           ', Finished '||TO_CHAR(finish_date,'dd-MON-yy hh24:mi');
   num_procd := 'No of stud_crse_year records considered : ' || TO_CHAR(n_num_scy) || ' No of stud_app_prog records created : ' || TO_CHAR(n_num_apps) || ', No of stud_trav_prog records created : ' || TO_CHAR(n_num_travs);
--
--
  EXCEPTION
--
    WHEN called_func_failed THEN
      success_fail := 'Fatal Error Detected';
      error_msg := g_err_msg;
      SELECT sysdate INTO finish_date FROM dual;
      start_finish := 'Started '||TO_CHAR(start_date,'dd-MON-yy hh24:mi')||
              ', Finished '||TO_CHAR(finish_date,'dd-MON-yy hh24:mi');
      num_procd := 'No of stud_crse_year records considered : ' || TO_CHAR(n_num_scy) || ' No of stud_app_prog records created : ' || TO_CHAR(n_num_apps) || ', No of stud_trav_prog records created : ' || TO_CHAR(n_num_travs);
--
      COMMIT;
--
    WHEN OTHERS THEN
      success_fail := 'Fatal Error Detected';
      error_msg := error.usererror ( 1056, 'telephony_support.init_repos', TO_CHAR ( SQLCODE ) );
      SELECT sysdate INTO finish_date FROM dual;
      start_finish := 'Started '||TO_CHAR(start_date,'dd-MON-yy hh24:mi')||
              ', Finished '||TO_CHAR(finish_date,'dd-MON-yy hh24:mi');
      num_procd := 'No of stud_crse_year records considered : ' || TO_CHAR(n_num_scy) || ' No of stud_app_prog records created : ' || TO_CHAR(n_num_apps) || ', No of stud_trav_prog records created : ' || TO_CHAR(n_num_travs) ;
--
      COMMIT;
--
END init_repos;

--
 FUNCTION    check_nmsb_session
        (p_stud_ref_no IN stud.stud_ref_no%TYPE,
    p_stud_crse_year_id IN stud_crse_year.stud_crse_year_id%TYPE,
         p_session IN OUT stud_session.session_code%TYPE) RETURN VARCHAR2 IS
--
    v_errmess varchar2(256);
    v_scheme_type stud_crse_year.scheme_type%TYPE;
    v_session_code stud_session.session_code%TYPE;
    v_max_session stud_session.session_code%TYPE;
     v_stud_crse_year_id stud_crse_year.stud_crse_year_id%TYPE;
     v_count number(10) := 0;
--
--
begin
    SELECT count(*) INTO v_count      FROM complete_web_applications
        WHERE stud_ref_no = p_stud_ref_no;

    IF v_count    > 0 THEN
        SELECT session_code
        INTO p_session
        FROM complete_web_applications
        WHERE stud_ref_no = p_stud_ref_no;
    ELSE
    IF p_stud_crse_year_id IS NOT NULL THEN
           SELECT scheme_type
           INTO v_scheme_type
           FROM stud_crse_year
           WHERE stud_crse_year_id = p_stud_crse_year_id;
           --
               IF v_scheme_type = 'B' THEN
               SELECT cval
           INTO p_session
           FROM config_data
           where item_name = 'CURRENT_NMSB_SESSION';
           END IF;

           --
    ELSE
           RETURN 'OK';
    end if;
       END IF;
--
--
    RETURN 'OK';
 EXCEPTION
    WHEN OTHERS THEN
    v_errmess := 'Error while checking NMSB session ' || TO_CHAR (SQLCODE) || '  ' || TO_CHAR (SQLERRM);
    RETURN v_errmess;
END check_nmsb_session;
--
END maintain_repository; 
/

