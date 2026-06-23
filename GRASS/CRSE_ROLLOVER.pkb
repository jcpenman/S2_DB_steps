ACCEPT STEPS_DB_LINK CHAR PROMPT 'Enter the STEPS DBLINK name' DEFAULT 'STEPS.WORLD'


CREATE OR REPLACE PACKAGE BODY SGAS.CRSE_ROLLOVER
IS
--
-- To modify this template, edit file PKGBODY.TXT in TEMPLATE
-- directory of SQL Navigator
--
--
-- Purpose: Roll over crse_session and crse_year details
-- for the sesion passed in
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
-- A Dobbie    08/02/05 Initial version for RFC 182


   FUNCTION crse_rollover
     ( p_session_code IN number,
       p_logdir IN varchar2,
       p_sid IN varchar2)
     RETURN  VARCHAR2 IS
        v_count NUMBER(2);
        v_result VARCHAR2(1000);
        v_session_code NUMBER(4);

   BEGIN
      DBMS_OUTPUT.PUT_LINE
         ( 'Copying session '||to_char (p_session_code - 1 ) ||' to session '||to_char (p_session_code)||'.' );

        -- First Check whether session code is in correct format
        IF LENGTH(p_session_code) > 4 THEN
            DBMS_OUTPUT.PUT_LINE('Session Code must be 4 digits in length');
            RETURN 'Processing Terminated with errors';
        END IF;

        -- First check whether config_data fees cutoff
        v_activity := 'Checking config_data record';
        SELECT count(*)
        INTO    v_count
        FROM config_data
        WHERE item_name = 'FEES_CUTOFF_'||p_session_code;

        IF v_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No CONFIG_DATA record for FEES_CUTOFF_'||p_session_code);
            RETURN 'Processing Terminated with errors';
        ELSE
        -- Check whether scoap_data fees cutoffs exist
            v_activity := 'Checking scoap_data record';
            SELECT count(*)
            INTO    v_count
            FROM scoap_data
            WHERE item_name LIKE 'FEES_CUTOFF_%'||p_session_code;
            IF v_count = 0 THEN
                DBMS_OUTPUT.PUT_LINE('No SCOAP_DATA records for fees cutoff dates in session '||p_session_code);
                RETURN 'Processing Terminated with errors';
            ELSE
            -- Continue processing
                v_result := find_crse_rollover(p_session_code);
             END IF;
            DBMS_OUTPUT.PUT_LINE(v_session_count||' crse_session records processed ');
            DBMS_OUTPUT.PUT_LINE(v_year_count||' crse_year records processed ');
            RETURN 'Processing Completed OK';
         END IF;
    EXCEPTION
         WHEN OTHERS THEN
          v_sql_code    := SQLCODE;
            v_sql_message := SQLERRM;
            DBMS_OUTPUT.PUT_LINE('Error '|| v_sql_code ||' '|| v_sql_message||' occurred in '||v_activity);
            RETURN 'Error in crse_rollover';
   END crse_rollover;

   FUNCTION find_crse_rollover
     ( p_session_code IN NUMBER)
     RETURN  VARCHAR2 IS
        CURSOR    get_crse_session_dets IS
            -- Get all crse_sesion_id where no later sessions than p_session exist
            SELECT crse_session_id,
                    inst_code,
                    crse_code
            FROM CRSE_SESSION cs, CRSE c
            WHERE session_code =  p_session_code - 1
            AND c.crse_id = cs.crse_id
            AND c.crse_id = cs.crse_id
            AND cs.crse_id NOT IN(SELECT crse_id
            FROM CRSE_SESSION
            WHERE session_code >=  p_session_code)
            ORDER BY inst_code,crse_code;  -- coded so the log file shows inst/crse order
            --
            --
            v_crse_session_id CRSE_SESSION.CRSE_SESSION_ID%TYPE;
            v_inst_code CRSE.INST_CODE%TYPE;
            v_crse_code CRSE.CRSE_CODE%TYPE;
            v_count NUMBER(10);
            v_max_crse_year_id CRSE_YEAR.CRSE_YEAR_ID%TYPE;
            v_min_crse_year_id CRSE_YEAR.CRSE_YEAR_ID%TYPE;
            v_result VARCHAR2(1000);
   BEGIN
        -- Identify courses that can be rolled forwards
        -- Do not finish if one fails (only if really bad error)
        OPEN get_crse_session_dets;
        LOOP

        v_activity := 'getting crse_session details to roll forwards';

        FETCH get_crse_session_dets INTO v_crse_session_id,
                                                    v_inst_code,
                                                    v_crse_code;

            EXIT WHEN get_crse_session_dets%NOTFOUND;

            IF v_crse_session_id IS NULL THEN
                -- No course session details to roll forwards - exit
                DBMS_OUTPUT.PUT_LINE('No course session details to roll forwards. Processing terminated');
                RETURN ('OK');
            END IF;

            -- Select the latest course year id for the crse_session
            v_activity := 'selecting first and final course year ids';
            SELECT MAX(crse_year_id), MIN(crse_year_id)
            INTO v_max_crse_year_id, v_min_crse_year_id
            FROM CRSE_YEAR
            WHERE crse_session_id = v_crse_session_id;

            IF v_max_crse_year_id != v_min_crse_year_id THEN
             -- get a count of all non final year students for crse_session
                v_activity := 'getting a count of all non final year students for crse_session';
                SELECT count(*)
                INTO v_count
                FROM STUD_CRSE_YEAR@&STEPS_DB_LINK
                WHERE crse_year_id IN (SELECT crse_year_id
                                FROM CRSE_YEAR
                                WHERE crse_session_id = v_crse_session_id
                                AND crse_year_id != v_max_crse_year_id)
                                AND ROWNUM = 1;
            ELSE
            -- 1 year course
             -- get a count of all non final year students for crse_session
                v_activity := 'getting a count of all students for crse_session on 1 year course';
                SELECT count(*)
                INTO v_count
                FROM STUD_CRSE_YEAR@&STEPS_DB_LINK
                WHERE crse_year_id IN (SELECT crse_year_id
                                FROM CRSE_YEAR
                                WHERE crse_session_id = v_crse_session_id)
                AND rownum = 1;
            END IF;

            IF v_count > 0 THEN
                -- Roll course sessions and course years over
                v_activity := 'calling do_crse_rollover';
                v_result := do_crse_rollover(p_session_code, v_crse_session_id);
            END IF;
        END LOOP;

        CLOSE get_crse_session_dets;

        RETURN 'OK';
   EXCEPTION
         WHEN OTHERS THEN
          v_sql_code    := SQLCODE;
            v_sql_message := SQLERRM;
            DBMS_OUTPUT.PUT_LINE('Error '|| v_sql_code ||' '|| v_sql_message||' occurred in '||v_activity ||' for Inst '||v_inst_code||', Crse '||v_crse_code);
            rollback;
            RETURN 'Error in find_crse_rollover';
   END find_crse_rollover;

   FUNCTION do_crse_rollover
     ( p_session_code IN NUMBER,
         p_crse_session_id IN NUMBER)
     RETURN  VARCHAR2 IS
        CURSOR get_crse_year IS
            SELECT crse_id,
                    crse_year_no,
                    inst_code,
                    study_abroad,
                    split_session,
                    crse_type,
                    req_tuition_fee,
                    eu_flag,
                    cutoff_item_name,
                    cutoff_type,
                    semester,
                    hei_crse_code
            FROM CRSE_YEAR
            WHERE crse_session_id = p_crse_session_id;

        v_new_crse_session_id CRSE_SESSION.CRSE_SESSION_ID%TYPE;
        --
        v_session_code    CRSE_SESSION.SESSION_CODE%TYPE;
        v_tuition_fee_type_code    CRSE_SESSION.TUITION_FEE_TYPE_CODE%TYPE;
        v_max_duration    CRSE_SESSION.MAX_DURATION%TYPE;
        v_psas_loan    CRSE_SESSION.PSAS_LOAN%TYPE;
        v_psas_cat    CRSE_SESSION.PSAS_CAT%TYPE;
        v_teacher_short    CRSE_SESSION.TEACHER_SHORT%TYPE;
        v_psas_bid_non_quota    CRSE_SESSION.PSAS_BID_NON_QUOTA%TYPE;
        v_paid_sandwich_fee_type_code    CRSE_SESSION.PAID_SANDWICH_FEE_TYPE_CODE%TYPE;
        -- RFC 221
        v_h_tuition_fee_type_code    CRSE_SESSION.HIGHER_TUITION_FEE_TYPE_CODE%TYPE;
        v_h_sandwich_fee_type_code    CRSE_SESSION.HIGHER_SANDWICH_FEE_TYPE_CODE%TYPE;
        -- end of RFC 221
        --
        v_new_crse_year_id    CRSE_YEAR.CRSE_YEAR_ID%TYPE;
        v_crse_id    CRSE_YEAR.CRSE_ID%TYPE;
        v_crse_year_no    CRSE_YEAR.CRSE_YEAR_NO%TYPE;

        v_study_abroad    CRSE_YEAR.STUDY_ABROAD%TYPE;
        v_split_session    CRSE_YEAR.SPLIT_SESSION%TYPE;
        v_crse_type    CRSE_YEAR.CRSE_TYPE%TYPE;
        v_req_tuition_fee    CRSE_YEAR.REQ_TUITION_FEE%TYPE;
        v_eu_flag    CRSE_YEAR.EU_FLAG%TYPE;
        v_cutoff_item_name    CRSE_YEAR.CUTOFF_ITEM_NAME%TYPE;
        v_semester    CRSE_YEAR.SEMESTER%TYPE;
        v_hei_crse_code    CRSE_YEAR.HEI_CRSE_CODE%TYPE;
        v_cutoff_type CRSE_YEAR.CUTOFF_TYPE%TYPE;
        v_cutoff_date CRSE_YEAR.CUTOFF_DATE%TYPE;


   BEGIN
        SELECT crss_crse_session_id_seq.nextval@&STEPS_DB_LINK
        INTO    v_new_crse_session_id
        FROM dual;

        SELECT     crse_id,
                    session_code + 1,
                    tuition_fee_type_code,
                    max_duration,
                    psas_loan,
                    psas_cat,
                    teacher_short,
                    psas_bid_non_quota,
                    paid_sandwich_fee_type_code,
                    -- RFC 221
                    higher_tuition_fee_type_code,
                    higher_sandwich_fee_type_code
                    -- end of RFC 221
        INTO        v_crse_id,
                    v_session_code,
                    v_tuition_fee_type_code,
                    v_max_duration,
                    v_psas_loan,
                    v_psas_cat,
                    v_teacher_short,
                    v_psas_bid_non_quota,
                    v_paid_sandwich_fee_type_code,
                    -- RFC 221
                    v_h_tuition_fee_type_code,
                    v_h_sandwich_fee_type_code
                    -- end of RFC 221
        FROM        CRSE_SESSION
        WHERE        crse_session_id = p_crse_session_id;

        INSERT INTO CRSE_SESSION@&STEPS_DB_LINK
            (crse_session_id,
            crse_id,
            session_code,
            tuition_fee_type_code,
            max_duration,
            psas_loan,
            psas_cat,
            teacher_short,
            psas_bid_non_quota,
            psas_alloc_date,
            psas_alloc_no,
            psas_bid_doc_ref,
            psas_bid_date,
            psas_bid_quota,
            paid_sandwich_fee_type_code,
        -- RFC 221
            higher_tuition_fee_type_code,
            higher_sandwich_fee_type_code)
            -- end of RFC 221
        VALUES
            (v_new_crse_session_id,
            v_crse_id,
            v_session_code,
            v_tuition_fee_type_code,
            v_max_duration,
            v_psas_loan,
            v_psas_cat,
            v_teacher_short,
            v_psas_bid_non_quota,
            null,
            null,
            null,
            null,
            null,
            v_paid_sandwich_fee_type_code,
            -- RFC 221
            v_h_tuition_fee_type_code,
            v_h_sandwich_fee_type_code);
            -- end of RFC 221
            v_session_count := v_session_count + 1;
        BEGIN
            OPEN get_crse_year;
            LOOP
            FETCH get_crse_year INTO
                    v_crse_id,
                    v_crse_year_no,
                    v_inst_code,
                    v_study_abroad,
                    v_split_session,
                    v_crse_type,
                    v_req_tuition_fee,
                    v_eu_flag,
                    v_cutoff_item_name,
                    v_cutoff_type,
                    v_semester,
                    v_hei_crse_code;

            EXIT WHEN get_crse_year%NOTFOUND;

            IF v_cutoff_item_name NOT LIKE 'FEES_CUTOFF_DEFAULT%' AND
                v_cutoff_item_name IS NOT NULL THEN
            -- Use default cutoff date and flag case to log
                SELECT inst_code,crse_code
                INTO v_inst_code,v_crse_code
                FROM crse
                WHERE crse_id = v_crse_id;
                -- write case to log and continue
                DBMS_OUTPUT.PUT_LINE('Inst '||v_inst_code||', Crse '||v_crse_code||', Year '||v_crse_year_no||
                ' allocated default cutoff date as previous session used '|| v_cutoff_type);
            END IF;
            -- set all item names to be the default one where one existed lastcrse_year
            IF v_cutoff_item_name IS NOT NULL THEN
                v_cutoff_item_name := 'FEES_CUTOFF_DEFAULT_'||p_session_code;
                --
                SELECT description,
                        TO_DATE(cval,'DD/MM/YYYY')
                INTO     v_cutoff_type,
                        v_cutoff_date
                FROM SCOAP_DATA
                WHERE    item_name = v_cutoff_item_name;
                --
            END IF;
            SELECT crsy_crse_year_id_seq.nextval@&STEPS_DB_LINK
            INTO    v_new_crse_year_id
            FROM dual;
            --
            INSERT INTO crse_year@&STEPS_DB_LINK
                    (crse_year_id,
                    crse_id,
                    crse_session_id,
                    crse_year_no,
                    inst_code,
                    study_abroad,
                    default_terms,
                    split_session,
                    crse_type,
                    req_tuition_fee,
                    eu_flag,
                    cutoff_item_name,
                    cutoff_type,
                    cutoff_date,
                    semester,
                    hei_crse_code)
                VALUES
                    (v_new_crse_year_id,
                    v_crse_id,
                    v_new_crse_session_id,
                    v_crse_year_no,
                    v_inst_code,
                    v_study_abroad,
                    'Y',
                    v_split_session,
                    v_crse_type,
                    v_req_tuition_fee,
                    v_eu_flag,
                    v_cutoff_item_name,
                    v_cutoff_type,
                    v_cutoff_date,
                    v_semester,
                    v_hei_crse_code);
                    --
                    v_year_count := v_year_count + 1;
                END LOOP;
                CLOSE get_crse_year;
            EXCEPTION
              WHEN OTHERS THEN
                    v_sql_code    := SQLCODE;
                v_sql_message := SQLERRM;
                DBMS_OUTPUT.PUT_LINE('Error '|| v_sql_code ||' '|| v_sql_message||' occurred while copying crse_year details for Inst'||v_inst_code||', Crse '||v_crse_code);
                    rollback;
            END;
        -- commit changes to crse_session and crse_year records
        commit;
        -- return to find_crse_rollover
        RETURN 'OK';
   EXCEPTION
         WHEN OTHERS THEN
          v_sql_code    := SQLCODE;
            v_sql_message := SQLERRM;
            DBMS_OUTPUT.PUT_LINE('Error '|| v_sql_code ||' '|| v_sql_message||' occurred while copying crse_session details for Inst'||v_inst_code||', Crse '||v_crse_code);
            rollback;
   END do_crse_rollover;

END;
/