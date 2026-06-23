CREATE OR REPLACE PACKAGE BODY SGAS.SLC_UTIL IS
--
-- SCCS IDENTIFICATION STRING
-- ==========================
-- @(#) slc_util_b.sql 03/06/00 15:36:35 1.18@(#)
--
-- DESCRIPTION
-- ===========
--
-- A collection of miscellaneous functions associated with SLC operations
--
--
/* CHANGE HISTORY
Version Date         Author         Change 
1.19?    16/01/2008    R Hunter    Changes to SQL to include STEPS data in the production of SLC 1 and SLC 2 files
                    Changes marked /* RH 16/01/2008 START */ /* RH 16/01/2008 END */

  c_yes CONSTANT VARCHAR2(1) := 'Y';
  c_no CONSTANT VARCHAR2(1) := 'N';
--
FUNCTION EligibleForFlexi(p_scy stud_crse_year%rowtype ) RETURN BOOLEAN IS
/*
This function return true if the student is eliglible for flexible payments, and false if they are not
A student is eligible for flexi if they are starting study after the 2006/2007 session, either undergradute
or post graduate non PGCE student, not a part time student and is studying in Scotland.
*/
ln_location INST.location_ind%TYPE;
ret_val boolean;
---
BEGIN
   ret_val := false;
---
    IF (p_scy.session_code >= slc_util.FLEXI_PAY_START_SESSION) AND -- session >= 2007
       p_scy.scheme_type = 'U'  AND--undergraduate
       p_scy.dearing != 'O' THEN --part time student
       BEGIN
        /* RH 16/01/2008 START */
        SELECT iv1.location_ind
          INTO ln_location
          FROM (SELECT location_ind
              FROM inst i, stud_crse_year scy
             WHERE scy.inst_code = i.inst_code
               AND scy.stud_crse_year_id = p_scy.stud_crse_year_id
            UNION
            SELECT location_ind
              FROM inst i, steps_stud_crse_year scy
             WHERE scy.inst_code = i.inst_code
               AND scy.stud_crse_year_id = p_scy.stud_crse_year_id) iv1;       
        /* RH 16/01/2008 END */
                   
       EXCEPTION
       WHEN OTHERS THEN
       ret_val := false;
       END;
       IF ln_location = 1 THEN
     ret_val := true;
        END IF;
    END IF;
---
    RETURN ret_val;

EXCEPTION
   WHEN others THEN
      RETURN ret_val;
END;
---
function StudHasStudLoan (p_scy_id in stud_crse_year.stud_crse_year_id%type,
                                p_stud_has_stud_loan in out boolean,
                                p_error_message in out varchar2,
            p_debug_file_handle in out utl_file.file_type) return boolean is
--
ret_val boolean;
fatal_error exception;
num_stud_loan_recs number;
--
BEGIN
--
    ret_val := true;
    num_stud_loan_recs := 0;
    p_stud_has_stud_loan := false;
--
    /* RH 16/01/2008 START */
    SELECT NVL (iv1.grass_count, 0) + NVL (iv2.steps_count, 0)
      INTO num_stud_loan_recs
      FROM (SELECT COUNT (*) grass_count
          FROM stud_crse_year scy, award a
         WHERE scy.stud_crse_year_id = p_scy_id
           AND scy.stud_crse_year_id = a.stud_crse_year_id
           AND (   a.stud_award_type LIKE ('U%L')
            OR a.stud_award_type LIKE ('P%L')
               )) iv1,
           (SELECT COUNT (*) steps_count
          FROM steps_stud_crse_year scy, steps_award a
         WHERE scy.stud_crse_year_id = p_scy_id
           AND scy.stud_crse_year_id = a.stud_crse_year_id
           AND (   a.stud_award_type LIKE ('U%L')
            OR a.stud_award_type LIKE ('P%L')
               )) iv2;
    /* RH 16/01/2008 END */


--
    if (num_stud_loan_recs > 0) then
        p_stud_has_stud_loan := true;
   else
      pop_m263.WriteToLog (p_debug_file_handle, '--- Student does not have a stud loan in scy ' || p_scy_id);
    end if;
--
    return ret_val;
--
EXCEPTION
--
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        p_error_message := 'The following fatal error occured in POP_M263.StudHasStudLoan '||SQLCODE||' '||SQLERRM;
        RETURN ret_val;
--
end;
--
function StudHasFeeLoan (p_scy_id in stud_crse_year.stud_crse_year_id%type,
                                p_stud_has_fee_loan in out boolean,
                                p_error_message in out varchar2,
            p_debug_file_handle in out utl_file.file_type)
           return boolean is
--
ret_val boolean;
fatal_error exception;
num_fee_loan_recs number;
--
BEGIN
--
    ret_val := true;
    num_fee_loan_recs := 0;
    p_stud_has_fee_loan := false;
--
        /* RH 16/01/2008 START */ 
    SELECT NVL (iv1.grass_count, 0) + NVL (iv2.steps_count, 0)
      INTO num_fee_loan_recs
      FROM (SELECT COUNT (*) grass_count
          FROM stud_crse_year scy, award a, award_instalment ai
         WHERE scy.stud_crse_year_id = p_scy_id
           AND scy.stud_crse_year_id = a.stud_crse_year_id
           AND a.award_id = ai.award_id
           AND ai.fee_loan_instalment = 'Y') iv1,
           (SELECT COUNT (*) steps_count
          FROM steps_stud_crse_year scy,
               steps_award a,
               steps_award_instalment ai
         WHERE scy.stud_crse_year_id = p_scy_id
           AND scy.stud_crse_year_id = a.stud_crse_year_id
           AND a.award_id = ai.award_id
           AND ai.fee_loan_instalment = 'Y') iv2;
       /* RH 16/01/2008 END */
--
    if (num_fee_loan_recs > 0) then
        p_stud_has_fee_loan := true;
   else
      pop_m263.WriteToLog (p_debug_file_handle, '--- Student does not have a fee loan in scy ' || p_scy_id);
    end if;
--
    return ret_val;
--
EXCEPTION
--
    WHEN OTHERS THEN
        -- report error to logfile and stop processing.
        ret_val := false;
        p_error_message := 'The following fatal error occured in POP_M263.StudHasFeeLoan '||SQLCODE||' '||SQLERRM;
        RETURN ret_val;
--
end;
--
  FUNCTION course_start_date_pz (p_start_session NUMBER,
                 p_crse_year_no NUMBER,
                 p_inst_code VARCHAR2,
                 p_crse_code VARCHAR2)
  RETURN DATE IS
    /* local variables */
    v_crse_id sgas.crse.crse_id%TYPE;
    v_def_terms sgas.crse_year.default_terms%TYPE;
    v_crse_year_id sgas.crse_year.crse_year_id%TYPE;
    v_start_session sgas.crse_session.session_code%TYPE := p_start_session;
    v_start_date DATE;
    v_inst_code sgas.inst.inst_code%TYPE;
  BEGIN
    /* calculate the session code for the start session */
    v_start_session := TO_CHAR(ADD_MONTHS(TO_DATE(v_start_session, 'YYYY'),
                     -(p_crse_year_no - 1) * 12),
                   'YYYY');
    /* fetch the first year and session */
    BEGIN
      SELECT default_terms, crse_year_id
      INTO v_def_terms, v_crse_year_id
      FROM crse c, crse_year cy, crse_session cs
      WHERE c.inst_code = p_inst_code
      AND c.crse_code = p_crse_code
      AND cs.crse_id = c.crse_id
      AND cs.session_code = v_start_session
      AND cy.crse_session_id = cs.crse_session_id
      AND cy.crse_year_no = 1;
    EXCEPTION
      WHEN others THEN
    /* all we can do is return the current date */
    RETURN SYSDATE;
    END;
    /* get start date from either course or institution level */
    BEGIN
      /* determine whether to use default terms */
      IF v_def_terms = 'Y' THEN
    /* get the institution term start date */
    SELECT MIN(start_date)
    INTO v_start_date
    FROM inst_term
    WHERE inst_code = p_inst_code
    AND session_code = v_start_session;
      ELSE
    /* get the course term start date */
    SELECT MIN(start_date)
    INTO v_start_date
    FROM crse_term
    WHERE crse_year_id = v_crse_year_id;
      END IF;
      IF v_start_date IS NOT NULL THEN
    RETURN v_start_date;
      ELSE
        RETURN SYSDATE;
      END IF;
    EXCEPTION
      WHEN others THEN
    RETURN SYSDATE;
    END;
  END;
  FUNCTION course_start_date (p_stud_crse_year_id NUMBER)
  RETURN DATE IS
    /* local variables */
    v_session_code sgas.stud_crse_year.session_code%TYPE;
    v_inst_code sgas.stud_crse_year.inst_code%TYPE;
    v_crse_code sgas.stud_crse_year.crse_code%TYPE;
    v_crse_year_no sgas.stud_crse_year.crse_year_no%TYPE;
    v_start_date DATE;
  BEGIN
    /* fetch the necessary data */
    BEGIN
      SELECT sgas.stud_crse_year.session_code,
         sgas.stud_crse_year.crse_year_no,
         sgas.stud_crse_year.inst_code,
         sgas.stud_crse_year.crse_code
      INTO v_session_code,
       v_crse_year_no,
       v_inst_code,
       v_crse_code
      FROM sgas.stud_crse_year
      WHERE sgas.stud_crse_year.stud_crse_year_id = p_stud_crse_year_id;
    EXCEPTION
      WHEN OTHERS THEN
    RETURN SYSDATE;
    END;
    v_start_date := course_start_date_pz (v_session_code,
                      v_crse_year_no,
                      v_inst_code,
                      v_crse_code);
    RETURN v_start_date;
  END;
  FUNCTION inst_start_date_pz (p_start_session NUMBER,
                           p_inst_code VARCHAR2)
  RETURN DATE IS
    /* local variables */
    v_start_date DATE;
  BEGIN
    BEGIN
      /* get the institution term start date */
      SELECT MIN(start_date)
      INTO v_start_date
      FROM inst_term
      WHERE inst_code = p_inst_code
      AND session_code = p_start_session;
    EXCEPTION
      WHEN others THEN
    RETURN SYSDATE;
    END;
    IF v_start_date IS NULL THEN
      RETURN SYSDATE;
    ELSE
      RETURN v_start_date;
    END IF;
  END;
  FUNCTION birthday_55 (p_dob DATE)
  RETURN DATE IS
    /* calculate the exact date the student is 55 */
    v_birthday_55 DATE;
  BEGIN
    /* if the date of birth is the 29th of February
       the set the date to be the 28th because adding 55 years
       to a leap year is never another leap year */
    IF TO_CHAR(p_dob, 'DD/MON') = '29/FEB' THEN
      v_birthday_55 := TO_DATE('28/FEB'||'/'||
                   TO_CHAR(TO_NUMBER(TO_CHAR(p_dob, 'YYYY')) + 55),
                   'DD/MON/YYYY');
    ELSE
      v_birthday_55 := TO_DATE(TO_CHAR(p_dob, 'DD/MON')||'/'||
                   TO_CHAR(TO_NUMBER(TO_CHAR(p_dob, 'YYYY')) + 55),
                   'DD/MON/YYYY');
    END IF;
    RETURN v_birthday_55;
  END;
  FUNCTION add_year (p_initial_date DATE, p_years NUMBER)
  RETURN DATE IS
      v_new_date DATE;
  BEGIN
    /* if the date of birth is the 29th of February
       the set the date to be the 28th because the new date
       is not certain to be a leap year */
    IF TO_CHAR(p_initial_date, 'DD/MON') = '29/FEB' THEN
      v_new_date := TO_DATE('28/FEB'||'/'||
                TO_CHAR(TO_NUMBER(TO_CHAR(p_initial_date, 'YYYY')) + p_years),
                'DD/MON/YYYY');
    ELSE
      v_new_date := TO_DATE(TO_CHAR(p_initial_date, 'DD/MON')||'/'||
                   TO_CHAR(TO_NUMBER(TO_CHAR(p_initial_date, 'YYYY')) + p_years),
                   'DD/MON/YYYY');
    END IF;
    RETURN v_new_date;
  END;
  FUNCTION loan_bearing_pz (p_stud_ref_no NUMBER,
                p_session_code NUMBER,
                p_inst_code VARCHAR2,
                p_crse_code VARCHAR2,
                p_crse_year_no NUMBER,
                p_dearing VARCHAR2)
  RETURN VARCHAR2 IS
    /* local variables */
    v_dob stud.dob%TYPE;
    v_scheme_type stud_crse_year.scheme_type%TYPE;
    v_qual_type crse.qual_type%TYPE;
    v_eu_flag crse_year.eu_flag%TYPE;
  BEGIN
    /* session code must be greater than 1998 */
    IF p_session_code < 1999 THEN
      RETURN c_no;
    END IF;
    /* fetch the necessary data */
    BEGIN
      SELECT c.scheme_type, c.qual_type, cy.eu_flag
      INTO v_scheme_type, v_qual_type, v_eu_flag
      FROM  crse c, crse_session cs, crse_year cy
      WHERE p_inst_code = c.inst_code
      AND p_crse_code = c.crse_code
      AND c.crse_id = cs.crse_id
      AND cs.crse_session_id = cy.crse_session_id
      AND cs.session_code = p_session_code
      AND cy.crse_id = cs.crse_id
      AND cy.crse_session_id = cs.crse_session_id
      AND cy.crse_year_no = p_crse_year_no;
      
      /* RH 16/01/2008 START */
    SELECT iv1.dob
      INTO v_dob
      FROM (SELECT s.dob
          FROM stud s
         WHERE p_stud_ref_no = s.stud_ref_no
        UNION
        SELECT s.dob
          FROM steps_stud s
         WHERE p_stud_ref_no = s.stud_ref_no) iv1;
      /* RH 16/01/2008 END */
      
    EXCEPTION
      WHEN OTHERS THEN
    RETURN c_no;
    END;
    /* age must be less than 55 at start of course */
    /* for efficiency, check if over 54 now and only then
       check against accurate beginning of course */
    IF course_start_date_pz(p_session_code,
                p_crse_year_no,
                p_inst_code,
                p_crse_code) > birthday_55(v_dob) THEN
      RETURN c_no;
    END IF;
    /* student is not an EU student */
    IF v_eu_flag = 'Y' THEN
      RETURN c_no;
    END IF;
--
    /* course is a dearing B, dearing P, dearing C, PGCCE or Dearing O */
    /* RFC75 - Add Cubie D and P (Q) */
    /* RFC96 - Add Cubie E */
   /* JM 02/02/2006 add SCOT F and RUK G RFC 188 */
--
    IF p_dearing IN('B','P','C','O','D','Q','E','F','G') THEN
      RETURN c_yes;
    ELSIF p_dearing = 'N' AND v_scheme_type = 'P' AND
      v_qual_type = 'PGCE' THEN
      /* this is a PGCCE (Community Education) course */
      RETURN c_yes;
    ELSE
      RETURN c_no;
    END IF;
  END;
  FUNCTION loan_bearing (p_stud_crse_year_id NUMBER)
  RETURN VARCHAR2 IS
    v_stud_ref_no sgas.stud_crse_year.stud_ref_no%TYPE;
    v_session_code sgas.stud_crse_year.session_code%TYPE;
    v_inst_code sgas.stud_crse_year.inst_code%TYPE;
    v_crse_code sgas.stud_crse_year.crse_code%TYPE;
    v_crse_year_no sgas.stud_crse_year.crse_year_no%TYPE;
    v_dearing sgas.stud_crse_year.dearing%TYPE;
    v_rc VARCHAR2(1);
  BEGIN
    /* fetch the necessary data */
    BEGIN
    
    /* RH 16/01/2008 START */
    SELECT iv1.stud_ref_no, iv1.session_code, iv1.inst_code, iv1.crse_code,
           iv1.crse_year_no, iv1.dearing
      INTO v_stud_ref_no, v_session_code, v_inst_code, v_crse_code,
           v_crse_year_no, v_dearing
      FROM (SELECT sgas.stud_crse_year.stud_ref_no,
               sgas.stud_crse_year.session_code,
               sgas.stud_crse_year.inst_code, sgas.stud_crse_year.crse_code,
               sgas.stud_crse_year.crse_year_no, sgas.stud_crse_year.dearing
          FROM sgas.stud_crse_year
         WHERE sgas.stud_crse_year.stud_crse_year_id = p_stud_crse_year_id
        UNION
        SELECT stud_ref_no, session_code, inst_code, crse_code, crse_year_no,
               dearing
          FROM steps_stud_crse_year
         WHERE stud_crse_year_id = p_stud_crse_year_id) iv1;
    /* RH 16/01/2008 END */  
      
    EXCEPTION
      WHEN OTHERS THEN
    RETURN c_no;
    END;
    /* call the parameterized version of the function */
    v_rc := loan_bearing_pz(v_stud_ref_no,
                v_session_code,
                v_inst_code,
                v_crse_code,
                v_crse_year_no,
                v_dearing);
    RETURN v_rc;
  END;
  FUNCTION eligibility_pz (p_stud_ref_no NUMBER)
  RETURN VARCHAR2 IS
    /* obtain the birth certificate flag */
    /* The district_birth_cert_issued field is checked as part of RFC71 */
    v_bc_missing stud.district_birth_cert_issued%TYPE;
  BEGIN
    BEGIN
      SELECT s.district_birth_cert_issued
      INTO v_bc_missing
      FROM stud s
      WHERE p_stud_ref_no = s.stud_ref_no;
    EXCEPTION
      WHEN OTHERS THEN
    RETURN 'N';
    END;
    IF v_bc_missing IS NOT NULL THEN
        RETURN 'Y';
    ELSE
        RETURN 'N';
    END IF;
  END;
  FUNCTION eligibility (p_stud_crse_year_id NUMBER)
  RETURN VARCHAR2 IS
    /* obtain the stud ref no */
    v_stud_ref_no stud.stud_ref_no%TYPE;
    v_rc VARCHAR2(1);
  BEGIN
    BEGIN
      SELECT scy.stud_ref_no
      INTO v_stud_ref_no
      FROM stud_crse_year scy
      WHERE scy.stud_crse_year_id = p_stud_crse_year_id;
    EXCEPTION
      WHEN OTHERS THEN
    RETURN 'N';
    END;
    v_rc := eligibility_pz(v_stud_ref_no);
    RETURN v_rc;
  END;
--
  FUNCTION application_pz (p_stud_ref_no NUMBER, p_session NUMBER)
  RETURN VARCHAR2 IS
    /* an application is permitted if two sets of contact
       details are provided - mandatory fields are name,
       relationship, address 1 and either address 2 or address 3 */
    /* RFC 71 - Signature date must also be complete */
    v_contacts NUMBER;
    v_relatives NUMBER;
    v_sig_date  DATE;
  BEGIN
    BEGIN
      SELECT count(*), sum(decode(scd.cont_rel_code, NULL, 0, 1))
      INTO v_contacts, v_relatives
      FROM stud_cont_details scd
      WHERE p_stud_ref_no = scd.stud_ref_no
      AND scd.cont_name IS NOT NULL
      AND scd.cont_addr1 IS NOT NULL
      AND (scd.cont_addr2 IS NOT NULL OR
       scd.cont_addr3 IS NOT NULL);
    EXCEPTION
      WHEN OTHERS THEN
    RETURN 'N';
    END;
--
    SELECT loan_declaration_date
    INTO v_sig_date
    FROM stud_session
    WHERE stud_ref_no = p_stud_ref_no
    AND session_code = p_session;
--
    IF v_contacts = 2 AND v_relatives >= 1 AND v_sig_date IS NOT NULL THEN
      RETURN 'Y';
    ELSE
      RETURN 'N';
    END IF;
  END;
--
  FUNCTION application (p_stud_crse_year_id NUMBER)
  RETURN VARCHAR2 IS
    /* obtain the stud ref no */
    v_stud_ref_no stud.stud_ref_no%TYPE;
    v_session      NUMBER;
    v_rc          VARCHAR2(1);
  BEGIN
    BEGIN
      SELECT scy.stud_ref_no,
               scy.session_code
      INTO v_stud_ref_no,
             v_session
      FROM stud_crse_year scy
      WHERE scy.stud_crse_year_id = p_stud_crse_year_id;
    EXCEPTION
      WHEN OTHERS THEN
        RETURN 'N';
    END;
    v_rc := application_pz(v_stud_ref_no, v_session);
    RETURN v_rc;
  END;
--
  FUNCTION course_end_date (p_inst_code VARCHAR2,
                p_crse_code VARCHAR2,
                p_session_code NUMBER,
                p_crse_year_no NUMBER,
                p_course_end_date IN OUT VARCHAR2)
  RETURN NUMBER IS
    /* local variables */
    v_crse_id crse.crse_id%TYPE;
    v_duration crse_session.max_duration%TYPE;
    v_curr_crse_sess_id crse_session.crse_session_id%TYPE;
    v_def_terms crse_year.default_terms%TYPE;
    v_crse_year_id crse_year.crse_year_id%TYPE;
    v_start_session crse_session.session_code%TYPE;
    v_end_session crse_session.session_code%TYPE;
    v_end_date DATE;
    v_rc NUMBER;
    /* local constants */
    c_success CONSTANT NUMBER := 0;
    c_failure CONSTANT NUMBER := 1;
    /* local functions */
    /* common code to get end date from course or institution */
    FUNCTION fetch_end_date(p_def_terms VARCHAR2,
                p_inst_code VARCHAR2,
                p_session_code NUMBER,
                p_crse_year_id NUMBER,
                p_end_date IN OUT DATE)
    RETURN NUMBER IS
    BEGIN
      BEGIN
    /* determine whether to use default terms */
    IF p_def_terms = 'Y' THEN
      /* get the institution term final date */
      SELECT MAX(end_date)
      INTO p_end_date
      FROM inst_term
      WHERE inst_code = p_inst_code
      AND session_code = p_session_code;
    ELSE
      /* get the course term final date */
      SELECT MAX(end_date)
      INTO p_end_date
      FROM crse_term
      WHERE crse_year_id = p_crse_year_id;
    END IF;
    IF p_end_date IS NOT NULL THEN
      RETURN c_success;
    ELSE
      RETURN c_failure;
    END IF;
      EXCEPTION
    WHEN others THEN
      RETURN c_failure;
      END;
    END;
  BEGIN
    /* check the current year of the course exists */
    BEGIN
      SELECT cs.max_duration, c.crse_id, cs.crse_session_id
      INTO v_duration, v_crse_id, v_curr_crse_sess_id
      FROM crse c, crse_session cs
      WHERE c.inst_code = p_inst_code
      AND c.crse_code = p_crse_code
      AND c.crse_id = cs.crse_id
      AND cs.session_code = p_session_code;
    EXCEPTION
      WHEN others THEN
    /* there is no course or course session record for these parameters */
    RETURN c_failure;
    END;
    /* calculate the session codes for the first and final sessions */
    v_start_session := p_session_code - p_crse_year_no + 1;
    v_end_session := p_session_code + v_duration - p_crse_year_no;
    /* first try to fetch the actual value from the course or institution for
       the last year of the course */
    BEGIN
      SELECT cy.default_terms, cy.crse_year_id
      INTO v_def_terms, v_crse_year_id
      FROM crse_year cy, crse_session cs
      WHERE cy.crse_id = v_crse_id
      AND cy.crse_session_id = cs.crse_session_id
      AND cy.crse_year_no = v_duration
      AND cs.crse_id = v_crse_id
      AND cs.session_code = v_end_session;
    EXCEPTION
      WHEN others THEN
    /* there may not be a crse year record so continue */
    NULL;
    END;
    /* if a course year record exists for the final year */
    v_end_date := NULL;
    IF v_crse_year_id IS NOT NULL THEN
      /* fetch the end date from course or institution */
      v_rc := fetch_end_date(v_def_terms,
                 p_inst_code,
                 v_end_session,
                 v_crse_year_id,
                 v_end_date);
      /* ignore return code in this instance - alternative derivation */
    END IF;
    /* if date is not set yet, estimate from first year */
    IF v_end_date IS NULL THEN
      BEGIN
    SELECT cy.default_terms, cy.crse_year_id
    INTO v_def_terms, v_crse_year_id
    FROM crse_year cy, crse_session cs
    WHERE cy.crse_id = v_crse_id
    AND cy.crse_session_id = cs.crse_session_id
    AND cs.crse_id = v_crse_id
    AND cs.session_code = v_start_session
    AND cy.crse_year_no = 1;
      EXCEPTION
    WHEN others THEN
      /* if we can't even get a course year for year one then use current year */
      BEGIN
        SELECT cy.default_terms, cy.crse_year_id
        INTO v_def_terms, v_crse_year_id
        FROM crse_year cy
        WHERE cy.crse_id = v_crse_id
        AND cy.crse_session_id = v_curr_crse_sess_id
        AND cy.crse_year_no = p_crse_year_no;
       EXCEPTION
        WHEN others THEN
          /* if we can't even get a course year for current year give up */
          RETURN c_failure;
      END;
      v_rc := fetch_end_date(v_def_terms,
                    p_inst_code,
                 p_session_code,
                 v_crse_year_id,
                 v_end_date);
      /* if fetch has failed this time then course end date cannot be derived */
      IF v_rc = c_failure THEN
        RETURN c_failure;
      END IF;
      v_end_date := ADD_MONTHS(v_end_date, 12 * (v_duration - p_crse_year_no));
      END;
      IF v_end_date IS NULL THEN
     /* fetch the end date from course or institution for first year */
     v_rc := fetch_end_date(v_def_terms,
                   p_inst_code,
                v_start_session,
                v_crse_year_id,
                v_end_date);
     /* if fetch has failed this time then use the current year again */
     IF v_rc = c_failure THEN
         BEGIN
           SELECT cy.default_terms, cy.crse_year_id
           INTO v_def_terms, v_crse_year_id
           FROM crse_year cy
              WHERE cy.crse_id = v_crse_id
           AND cy.crse_session_id = v_curr_crse_sess_id
           AND cy.crse_year_no = p_crse_year_no;
          EXCEPTION
           WHEN others THEN
         /* if we can't even get a course year for current year give up */
         RETURN c_failure;
         END;
         v_rc := fetch_end_date(v_def_terms,
                       p_inst_code,
                    p_session_code,
                    v_crse_year_id,
                    v_end_date);
         /* if fetch has failed this time then course end date cannot be derived */
         IF v_rc = c_failure THEN
           RETURN c_failure;
         END IF;
         v_end_date := ADD_MONTHS(v_end_date, 12 * (v_duration - p_crse_year_no));
     END IF;
     /* increment the end date by duration years */
     v_end_date := ADD_MONTHS(v_end_date, 12 * (v_duration - 1));
       END IF;
    END IF;
    p_course_end_date :=  TO_CHAR(v_end_date, 'MMYYYY');
    RETURN c_success;
  END;
  FUNCTION available_as_loan (p_stud_crse_year_id NUMBER,
                  p_available_as_loan_amount IN OUT NUMBER)
  RETURN NUMBER IS
    /* local constants */
    c_success CONSTANT NUMBER := 0;
    c_award_records_missing CONSTANT NUMBER := 1;
    c_failure CONSTANT NUMBER := 2;
  BEGIN
    /* set to zero as default */
    p_available_as_loan_amount := 0;
    /* fetch loan awards for this course year record */
    BEGIN
    /* fix TR 1693 - manual awards don't have unclaimed_loan set to 0  */
    
          /* RH 16/01/2008 START */
    SELECT   NVL (iv1.available_as_loan_amount_grass, 0)
           + NVL (iv2.available_as_loan_amount_steps, 0)
      INTO p_available_as_loan_amount
      FROM (SELECT SUM (aw.net_amount + NVL (aw.unclaimed_loan, 0)
               ) available_as_loan_amount_grass
        FROM   award aw
         WHERE aw.stud_crse_year_id = p_stud_crse_year_id
           AND award_types.loan_award (aw.stud_award_type) = 'Y') iv1,
           (SELECT SUM (aw.net_amount + NVL (aw.unclaimed_loan, 0)
               ) available_as_loan_amount_steps
          FROM steps_award aw
         WHERE aw.stud_crse_year_id = p_stud_crse_year_id
           AND award_types.loan_award (aw.stud_award_type) = 'Y') iv2;
          /* RH 16/01/2008 END */
      
    EXCEPTION
      WHEN no_data_found THEN
    RETURN c_award_records_missing;
      WHEN others THEN
    RETURN c_failure;
    END;
    IF p_available_as_loan_amount IS NULL THEN
      p_available_as_loan_amount := 0;
      RETURN c_award_records_missing;
    END IF;
    RETURN c_success;
  END;
  FUNCTION assessed_as_loan (p_stud_crse_year_id NUMBER,
                 p_assessed_as_loan_amount IN OUT NUMBER)
  RETURN NUMBER IS
    /* local constants */
    c_success CONSTANT NUMBER := 0;
    c_award_records_missing CONSTANT NUMBER := 1;
    c_failure CONSTANT NUMBER := 2;
  BEGIN
    /* set to zero as default */
    p_assessed_as_loan_amount := 0;
    /* fetch loan awards for this course year record */
    BEGIN

    /* RH 16/01/2008 START */ 
    SELECT (iv_grass_aw.grass_amt + iv_steps_aw.steps_amt)
      INTO p_assessed_as_loan_amount
      FROM (SELECT NVL(SUM (aw.net_amount),0) grass_amt
          FROM award aw
         WHERE aw.stud_crse_year_id = p_stud_crse_year_id
           AND award_types.loan_award (aw.stud_award_type) = 'Y') iv_grass_aw,
           (SELECT NVL (SUM (aw.net_amount), 0) steps_amt
          FROM steps_award aw
         WHERE aw.stud_crse_year_id = p_stud_crse_year_id
           AND award_types.loan_award (aw.stud_award_type) = 'Y') iv_steps_aw;    
    /* RH 16/01/2008 END */

    EXCEPTION
      WHEN no_data_found THEN
    RETURN c_award_records_missing;
      WHEN others THEN
    RETURN c_failure;
    END;
    IF p_assessed_as_loan_amount IS NULL THEN
      p_assessed_as_loan_amount := 0;
      RETURN c_award_records_missing;
    END IF;
    RETURN c_success;
  END;
  FUNCTION slc_inst_code (p_stud_crse_year_id NUMBER,
              p_slc_inst_code IN OUT VARCHAR2,
              p_slc_inst_name IN OUT VARCHAR2)
  RETURN NUMBER IS
    /* local variables */
    v_inst_code inst.inst_code%TYPE;
    /* local constants */
    c_success CONSTANT NUMBER := 0;
    c_code_not_found CONSTANT NUMBER := 1;
    c_name_not_found CONSTANT NUMBER := 2;
    c_failure CONSTANT NUMBER := 3;
  BEGIN
    /* get inst_code from stud crse year record */
    BEGIN

    /* RH 16/01/2008 START */
    SELECT iv1.inst_code
      INTO v_inst_code
      FROM (SELECT inst_code
          FROM stud_crse_year
         WHERE stud_crse_year_id = p_stud_crse_year_id
        UNION
        SELECT inst_code
          FROM steps_stud_crse_year
         WHERE stud_crse_year_id = p_stud_crse_year_id) iv1;
    /* RH 16/01/2008 END */


    EXCEPTION
      WHEN others THEN
    /* this is an invalid stud_crse_year_id */
    RETURN c_failure;
    END;
    /* given inst_code, get the corresponding hei_inst_code from
       the INST database table */
    BEGIN
      SELECT hei_inst_code
      INTO p_slc_inst_code
      FROM inst
      WHERE inst_code = v_inst_code;
    EXCEPTION
      WHEN others THEN
    RETURN c_failure;
    END;
    IF p_slc_inst_code IS NULL THEN
      /* there is no HEI code set for this institution */
      RETURN c_code_not_found;
    END IF;
    /* now fetch the name from the HEI_INST table */
    BEGIN
      SELECT hei_inst_name
      INTO p_slc_inst_name
      FROM hei_inst
      WHERE hei_inst_code = p_slc_inst_code;
    EXCEPTION
      WHEN no_data_found THEN
    /* if no hei name exists, use the GRASS name */
    BEGIN
      SELECT inst_name
      INTO p_slc_inst_name
      FROM inst
      WHERE inst_code = v_inst_code;
      RETURN c_name_not_found;
    EXCEPTION
      WHEN others THEN
        /* this is a failure */
        RETURN c_failure;
    END;
      WHEN others THEN
    /* this is a failure */
    RETURN c_failure;
    END;
    RETURN c_success;
  END;
  FUNCTION slc_crse_code (p_stud_crse_year_id NUMBER,
              p_slc_inst_code IN OUT VARCHAR2,
              p_slc_crse_code IN OUT VARCHAR2,
              p_slc_crse_name IN OUT VARCHAR2)
  RETURN NUMBER IS
    /* local variables */
    v_rc NUMBER;
    v_inst_name hei_inst.hei_inst_name%TYPE;
    v_crse_code crse.crse_code%TYPE;
    v_crse_id crse.crse_id%TYPE;
    v_crse_year_id crse_year.crse_year_id%TYPE;
    /* local constants */
    c_success CONSTANT NUMBER := 0;
    c_code_not_found CONSTANT NUMBER := 1;
    c_name_not_found CONSTANT NUMBER := 2;
    c_failure CONSTANT NUMBER := 3;
    /* local function */
    PROCEDURE translate_code(p_crse_code IN OUT VARCHAR2) IS
    BEGIN
      IF (TRANSLATE(p_crse_code,
            'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
            'ABCDEFGHIJKLMNOPQRSTUVWXYZ') IS NULL) THEN
    /* code is numeric only */
    p_crse_code := LPAD(p_crse_code, 6, '0');
      ELSE
    /* code is of type UCAS */
    p_crse_code := RPAD(p_crse_code, 6, ' ');
      END IF;
    END;
  BEGIN
    /* call the hei inst function to determine the hei_inst_code */
    v_rc := slc_inst_code(p_stud_crse_year_id,
              p_slc_inst_code,
              v_inst_name);
    IF v_rc = c_code_not_found OR v_rc = c_failure THEN
      RETURN v_rc;
    END IF;
    /* get crse id and crse year id from stud crse year record */
    BEGIN
      /* RH 16/01/2008 START */
    SELECT iv1.crse_code, iv1.crse_id, iv1.crse_year_id
      INTO v_crse_code, v_crse_id, v_crse_year_id
      FROM (SELECT crse_code, crse_id, crse_year_id
          FROM stud_crse_year
         WHERE stud_crse_year_id = p_stud_crse_year_id
        UNION
        SELECT crse_code, crse_id, crse_year_id
          FROM steps_stud_crse_year
         WHERE stud_crse_year_id = p_stud_crse_year_id) iv1;
      /* RH 16/01/2008 END */
    EXCEPTION
      WHEN others THEN
    /* this is an invalid stud_crse_year_id */
    RETURN c_failure;
    END;
    /* first check the course year table to see if the HEI code is
       held there */
    BEGIN
      SELECT hei_crse_code
      INTO p_slc_crse_code
      FROM crse_year
      WHERE crse_year_id = v_crse_year_id;
    EXCEPTION
      WHEN others THEN
    RETURN c_failure;
    END;
    IF p_slc_crse_code IS NULL THEN
      /* there is no HEI code set at course year level */
      BEGIN
    SELECT hei_crse_code
    INTO p_slc_crse_code
    FROM crse
    WHERE crse_id = v_crse_id;
      EXCEPTION
    WHEN others THEN
      RETURN c_failure;
      END;
      IF p_slc_crse_code IS NULL THEN
    /* there is no HEI code at course level either */
    RETURN c_code_not_found;
      END IF;
    END IF;
    /* now fetch the name from the HEI_CRSE table */
    BEGIN
      SELECT hei_crse_name
      INTO p_slc_crse_name
      FROM hei_crse
      WHERE hei_inst_code = p_slc_inst_code
      AND hei_crse_code = p_slc_crse_code;
    EXCEPTION
      WHEN no_data_found THEN
    /* if no hei name exists, use the GRASS name */
    BEGIN
      SELECT crse_name
      INTO p_slc_crse_name
      FROM crse
      WHERE crse_id = v_crse_id;
      translate_code(p_slc_crse_code);
      RETURN c_name_not_found;
    EXCEPTION
      WHEN others THEN
        /* this is a failure */
        RETURN c_failure;
    END;
      WHEN others THEN
    /* this is a failure */
    RETURN c_failure;
    END;
    translate_code(p_slc_crse_code);
    RETURN c_success;
  END;
--
  FUNCTION part_time_course (p_crse_code  VARCHAR2)
  RETURN VARCHAR2 IS
  BEGIN
      /* Return Y if the course code passed is that of a part time course */
    if p_crse_code = 'PART' then
         RETURN c_yes;
    else
        RETURN c_no;
    end if;
  END;
--
--
-- New function added as part of RFC 73
-- This function determines if a student is independent or not.
-- It returns 'Y' if the student is independent and NULL otherwise.
-- Set p_check_marriage to TRUE if the marriage date is to be
-- checked.
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
  RETURN VARCHAR2 IS
    /* local variables */
    v_session_start DATE;
    v_date_25 DATE;
    v_dom DATE;
    v_check_date VARCHAR2(11);
    v_date_string VARCHAR2(11);
    v_start_date DATE;
    v_def_terms VARCHAR2(1);
    v_eu crse_year.eu_flag%type;
    date_range_1                DATE;
    date_range_2                DATE;
    date_range_3                DATE;
    date_range_4                DATE;
    date_range_5                DATE;
    date_range_6                DATE;
    v_app_error VARCHAR2(255);
  BEGIN
    /* if any of the course details are missing then return NULL */
    IF (p_crse_year_id IS NULL) OR
       (p_crse_year_no IS NULL) THEN
        RETURN NULL;
    END IF;
    BEGIN
        IF p_check_eu THEN
       SELECT eu_flag
       INTO v_eu
       FROM crse_year
       WHERE crse_year_id = p_crse_year_id;
        ELSE
           v_eu := 'N';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
        /* if there is a problem then don't set the flag */
            RETURN NULL;
    END;
    IF (p_session_code >= 2000) AND
    /* RFC 73 - requirement number 3 - remove dearing check  (p_dearing_status = 'C') AND */
    /* add a check that case is not PART time */
       (p_dearing_status <> 'O') AND
       (v_eu = 'N') THEN
           /* RFC75 - 2 year marriage rule removed from 2001 */
        IF p_session_code >= 2001 then
            v_dom := p_marriage_date;
        ELSE
            /* find out when the student would have been married for 2 years */
            v_dom := slc_util.add_year(NVL(p_marriage_date, slc_util.add_year(SYSDATE, 25)), 2);
        END IF;
        BEGIN
        /* get the start date for the student */
            SELECT default_terms
            INTO v_def_terms
             FROM crse_year cy, crse_session cs
            WHERE cy.crse_year_id = p_crse_year_id
            AND cy.crse_session_id = cs.crse_session_id
            AND cy.crse_year_no = p_crse_year_no;
        IF v_def_terms = 'Y' THEN
                SELECT start_date
                INTO v_start_date
                FROM inst_term
                WHERE inst_code = p_inst_code
                AND session_code = p_session_code
                AND term_no = 1;
            ELSE
                SELECT start_date
                INTO v_start_date
                FROM crse_term
                WHERE crse_year_id = p_crse_year_id
                AND term_no = 1;
            END IF;
        EXCEPTION
            WHEN no_data_found THEN
        /* have to use sysdate to work out age */
        v_start_date := SYSDATE;
        END;
    --v_check_date := to_char(v_start_date);
        date_range_1 := to_date('01-AUG-'||to_char(p_session_code), 'DD-MON-YYYY');
        date_range_2 := to_date('31-DEC-'||to_char(p_session_code), 'DD-MON-YYYY');
        date_range_3 := to_date('01-JAN-'||to_char(p_session_code + 1), 'DD-MON-YYYY');
        date_range_4 := to_date('31-MAR-'||to_char(p_session_code + 1), 'DD-MON-YYYY');
        date_range_5 := to_date('01-APR-'||to_char(p_session_code + 1), 'DD-MON-YYYY');
        date_range_6 := to_date('30-JUN-'||to_char(p_session_code + 1), 'DD-MON-YYYY');
        IF v_start_date between  date_range_1 and date_range_2 THEN
            v_date_string := '01-AUG-'||to_char(p_session_code);
        ELSIF v_start_date between    date_range_3 and date_range_4 THEN
            v_date_string := '01-JAN-'||to_char(p_session_code + 1);
        ELSIF v_start_date between    date_range_5 and date_range_6 THEN
            v_date_string := '01-APR-'||to_char(p_session_code + 1);
        ELSE
            v_date_string := '01-JUL-'||to_char(p_session_code + 1);
        END IF;
        v_session_start := to_date(v_date_string,'DD-MON-YYYY');
    /* find out when the student will be 25 */
        v_date_25 := slc_util.add_year(p_dob, 25);
    /* if the student is over 25 or married more than 2 years on the relevant date set the flag */
        IF p_check_eu AND
           (v_date_25 < v_session_start) OR
           (p_check_marriage AND (v_dom < v_session_start)) THEN
            RETURN c_yes;
    /* TR 1679 - check dob <= relevant date for 25 or over message only */
        ELSIF NOT p_check_eu AND
        /* change <= to = for RFC 91 */
           (v_date_25 < v_session_start) OR
           (p_check_marriage AND (v_dom < v_session_start)) THEN
            RETURN c_yes;
        ELSE
            RETURN c_no;
        END IF;
    END IF;
    RETURN NULL;
  EXCEPTION
     WHEN OTHERS THEN
        v_app_error := 'Trapped '||SQLCODE||' in slc_util.independent.';
        raise_application_error(-20101, v_app_error);
  END;
--
-- Non boolean version of function for use in pure SQL
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
  RETURN VARCHAR2 IS
     /* local variables */
     v_check_marriage BOOLEAN := TRUE;
     v_check_eu BOOLEAN := TRUE;
     v_independent_flag VARCHAR2(1) := NULL;
  BEGIN
    IF p_check_marriage = 'Y' THEN
      v_check_marriage := TRUE;
    ELSE
      v_check_marriage := FALSE;
    END IF;
    IF p_check_eu = 'Y' THEN
      v_check_eu := TRUE;
    ELSE
      v_check_eu := FALSE;
    END IF;
    v_independent_flag := independent(p_session_code,
                          p_dearing_status,
                      p_inst_code,
                                  p_crse_year_id,
                                  p_crse_year_no,
                                  p_dob,
                                  v_check_marriage,
                                  p_marriage_date,
                                  v_check_eu);
    RETURN v_independent_flag;
  END;

  FUNCTION ge_eligibility (p_stud_ref_no NUMBER)
  RETURN VARCHAR2 IS
    /* obtain the birth certificate flag, contact details and signature details*/
    v_bc_missing stud.district_birth_cert_issued%TYPE;
    v_contacts NUMBER;
    v_relatives NUMBER;
    v_sig_date  DATE;
  BEGIN
    BEGIN
      SELECT s.district_birth_cert_issued
      INTO v_bc_missing
      FROM stud s
      WHERE p_stud_ref_no = s.stud_ref_no;

      SELECT count(*), sum(decode(scd.cont_rel_code, NULL, 0, 1))
      INTO v_contacts, v_relatives
      FROM stud_cont_details scd
      WHERE p_stud_ref_no = scd.stud_ref_no
      AND scd.cont_name IS NOT NULL
      AND scd.cont_addr1 IS NOT NULL
      AND (scd.cont_addr2 IS NOT NULL OR
       scd.cont_addr3 IS NOT NULL);


    SELECT signature_date
    INTO v_sig_date
    FROM grad_endow
    WHERE stud_ref_no = p_stud_ref_no;
    --
    IF v_contacts = 2 AND v_relatives >= 1 AND v_sig_date IS NOT NULL
      AND v_bc_missing IS NOT NULL THEN
      RETURN 'Y';
    ELSE
      RETURN 'N';
    END IF;
    EXCEPTION
      WHEN OTHERS THEN
    RETURN 'N';

  END;
  END;
--
-- RFC172
  FUNCTION slc4_course_end_date (p_stud_crse_year_id IN OUT stud_crse_year.stud_crse_year_id%TYPE,
        p_inst_code VARCHAR2,
                p_crse_code VARCHAR2,
                p_session_code NUMBER,
                p_crse_year_no NUMBER,
                p_course_end_date IN OUT VARCHAR2)
  RETURN NUMBER IS
    /* local variables */
    v_crse_id crse.crse_id%TYPE;
    v_curr_crse_sess_id crse_session.crse_session_id%TYPE;
    v_def_terms crse_year.default_terms%TYPE;
    v_crse_year_id crse_year.crse_year_id%TYPE;
    v_start_session crse_session.session_code%TYPE;
    v_end_session crse_session.session_code%TYPE;
    v_end_date DATE;
    v_rc NUMBER;
    v_withdraw_date stud_crse_year.withdraw_date%TYPE;
    v_app_status stud_crse_year.application_status%TYPE;
    /* local constants */
    c_success CONSTANT NUMBER := 0;
    c_failure CONSTANT NUMBER := 1;
    v_stud_ref_no stud.stud_ref_no%TYPE;
    /* local functions */
    /* common code to get end date from course or institution */
    FUNCTION fetch_end_date(p_def_terms VARCHAR2,
                p_inst_code VARCHAR2,
                p_session_code NUMBER,
                p_crse_year_id NUMBER,
                p_end_date IN OUT DATE)
    RETURN NUMBER IS
    BEGIN
      BEGIN
    /* determine whether to use default terms */
    IF p_def_terms = 'Y' THEN
      /* get the institution term final date */
      SELECT MAX(end_date)
      INTO p_end_date
      FROM inst_term
      WHERE inst_code = p_inst_code
      AND session_code = p_session_code;
    ELSE
      /* get the course term final date */
      SELECT MAX(end_date)
      INTO p_end_date
      FROM crse_term
      WHERE crse_year_id = p_crse_year_id;
    END IF;
    IF p_end_date IS NOT NULL THEN
      RETURN c_success;
    ELSE
      RETURN c_failure;
    END IF;
      EXCEPTION
    WHEN others THEN
      RETURN c_failure;
      END;
    END;
  BEGIN
  --
    BEGIN
    SELECT withdraw_date, application_status, stud_ref_no
    INTO v_withdraw_date, v_app_status,  v_stud_ref_no
    FROM stud_crse_year
    WHERE stud_crse_year_id = p_stud_crse_year_id;
    EXCEPTION
    WHEN no_data_found THEN
    v_withdraw_date := NULL;
    v_app_status := NULL;
    END;
--
/*    IF nvl(v_app_status,'X')IN ('A','R','T') THEN
    SELECT MAX(stud_crse_year_id)
    FROM stud_crse_year

    END IF;*/
    /* check the current year of the course exists */
    BEGIN
      SELECT c.crse_id, cs.crse_session_id
      INTO v_crse_id, v_curr_crse_sess_id
      FROM crse c, crse_session cs
      WHERE c.inst_code = p_inst_code
      AND c.crse_code = p_crse_code
      AND c.crse_id = cs.crse_id
      AND cs.session_code = p_session_code;
    EXCEPTION
      WHEN others THEN
    /* there is no course or course session record for these parameters */
    RETURN c_failure;
    END;
    /* calculate the session codes for the first and final sessions */
      SELECT cy.default_terms, cy.crse_year_id
      INTO v_def_terms, v_crse_year_id
      FROM crse_year cy, crse_session cs
      WHERE cy.crse_id = v_crse_id
      AND cy.crse_session_id = cs.crse_session_id
      AND cy.crse_year_no = p_crse_year_no
      AND cs.crse_id = v_crse_id
      AND cs.session_code = p_session_code;
--
--
    IF v_withdraw_date IS NOT NULL AND NVL(v_app_status,'X')='W' THEN
    v_end_date := v_withdraw_date;
    ELSIF v_app_status = 'C' THEN
      v_rc := fetch_end_date(v_def_terms,
                 p_inst_code,
                 p_session_code,
                 v_crse_year_id,
                 v_end_date);
    END IF;
--
--     v_end_date := ADD_MONTHS(v_end_date, 12 * (v_duration - 1));
    p_course_end_date :=  TO_CHAR(v_end_date, 'MMYYYY');
    RETURN c_success;
  END;
--
-- RFC 188 new fee loan application function
--
  FUNCTION fee_loan_application_pz (p_stud_ref_no NUMBER, p_session NUMBER)
  RETURN VARCHAR2 IS
    /* a fee loan application is permitted if two sets of contact
       details are provided - mandatory fields are name,
       relationship, address 1 and either address 2 or address 3 */
   v_contacts NUMBER;
   v_relatives NUMBER;
   v_sig_date  DATE;
  BEGIN
    BEGIN
      SELECT count(*), sum(decode(scd.cont_rel_code, NULL, 0, 1))
      INTO v_contacts, v_relatives
      FROM stud_cont_details scd
      WHERE p_stud_ref_no = scd.stud_ref_no
      AND scd.cont_name IS NOT NULL
      AND scd.cont_addr1 IS NOT NULL
      AND (scd.cont_addr2 IS NOT NULL OR
       scd.cont_addr3 IS NOT NULL);
    EXCEPTION
      WHEN OTHERS THEN
    RETURN 'N';
    END;
--
    IF v_contacts = 2 AND v_relatives >= 1 THEN
      RETURN 'Y';
    ELSE
      RETURN 'N';
    END IF;
  END fee_loan_application_pz;
--
--
END;
-- END RFC172
/
