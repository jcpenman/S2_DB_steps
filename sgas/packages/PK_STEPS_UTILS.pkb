CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_utils
IS
   FUNCTION f_study_gap_exists (p_stud_ref IN NUMBER, p_session_code IN NUMBER)
      RETURN NUMBER
   IS
         /* REQUIRED FOR WEBMETHODS TRANSFORM
          * f_study_gap_exists
          * Returns ZERO if no study gap exists for a student
          * Returns commencement session code if a gap exists
          * CALLED BY: f_get_comm_yr
          * Modification history:
          * 18.12.2007 Initial Version   Robert Hunter
          * 19.12.2007 Version 0.01
          * 08.01.2008 Version 0.02    Paul Hughes
          * Code Amended to take session_code from Application as an input and regard this as part of gap existing
          * 16.01.2008 Version 0.03    Paul Hughes
          * Code Amended to take care of application status's of 'C' and 'W' only
          * Removed stud_session table and using Stud_Crse_year for session_Code

      */
      CURSOR c_stud_session
      IS
         SELECT   iv1.session_code
             FROM (SELECT NVL (TO_NUMBER (y.session_code), 0) session_code
                     FROM stud_crse_year@grass y
                    WHERE y.stud_ref_no = p_stud_ref
                      AND y.latest_crse_ind = 'Y'
                      AND y.application_status IN ('W', 'C')
                   UNION
                   SELECT NVL (TO_NUMBER (y.session_code), 0) session_code
                     FROM sgas.stud_crse_year y
                    WHERE y.stud_ref_no = p_stud_ref
                      AND y.latest_crse_ind = 'Y'
                      AND y.application_status IN ('W', 'C')
                   UNION
                   SELECT p_session_code
                     FROM DUAL) iv1
         ORDER BY iv1.session_code DESC;

      v_session_code    NUMBER := 0;
      v_previous_code   NUMBER := 0;
      v_count           NUMBER := 0;
   BEGIN
      OPEN c_stud_session;

      LOOP
         FETCH c_stud_session
          INTO v_session_code;

         IF v_count = 0 AND v_session_code = 0              --first row empty
         THEN
            RETURN NULL;

            CLOSE c_stud_session;
         END IF;

         EXIT WHEN c_stud_session%NOTFOUND;

         IF v_count <> 0                               /*  ignore first row */
         THEN
            IF (v_previous_code - 1) <> v_session_code
            THEN
               RETURN v_previous_code;
            END IF;
         END IF;

         v_count := v_count + 1;
         v_previous_code := v_session_code;
      END LOOP;

      RETURN 0;

      CLOSE c_stud_session;
   EXCEPTION
      WHEN OTHERS
      THEN
         CLOSE c_stud_session;

         RETURN NULL;
   END f_study_gap_exists;

   FUNCTION f_get_comm_yr (p_stud_ref IN NUMBER, p_session_code IN NUMBER)
      RETURN NUMBER
   IS
      /* REQUIRED FOR WEBMETHODS TRANSFORM
       * f_get_comm_yr
       * Returns earliest session commencement year if no gap in study
       * Else return commencement year from f_study_gap_exists
       * CALLS: f_study_gap_exists
       * Modification history:
       * 18.12.2007 Initial Version   Robert Hunter
       * 08.01.2008 Version 0.02    Paul Hughes
       * Code Amended to take session_code from Application as an input and regard this as part of gap existing
       * 16.01.2008 Version 0.03    Paul Hughes
       * Code Amended to take care of application status's of 'C' and 'W' only
       * Removed stud_session table and using Stud_Crse_year for session_Code
       *
       * 21.04.2009  Version 0.04   Robert Hunter
       * Ensure data integrity of the input parameters
       * Rnsure data integrity of returned value
       * Return commencementYear if there is an exception.
       *
       *
       */
      commencementyear   NUMBER := 0;
      v_gap_year_out     NUMBER := 0;
      v_stud_ref         NUMBER := 0;
      v_session_code     NUMBER := 0;
   BEGIN
      v_stud_ref := p_stud_ref;
      v_session_code := p_session_code;

      --0.04 start RH
      IF v_stud_ref > 0
      THEN
         -- do nothing
         v_stud_ref := v_stud_ref;
      ELSE                                                   -- set it to NULL
         v_stud_ref := NULL;
      END IF;

      IF v_session_code > 0
      THEN
         -- do nothing
         v_session_code := v_session_code;
      ELSE                                                   -- set it to NULL
         v_session_code := NULL;
      END IF;

      --0.04 end RH
      IF f_study_gap_exists (v_stud_ref, v_session_code) = 0
      -- no gaps so get earliest year
      THEN
         SELECT MIN (iv1.session_code)
           INTO commencementyear
           FROM (SELECT MIN (NVL (TO_NUMBER (y.session_code), 0))
                                                                 session_code
                   FROM stud_crse_year@grass y
                  WHERE y.stud_ref_no = v_stud_ref
                    AND y.latest_crse_ind = 'Y'
                    AND y.application_status IN ('W', 'C')
                 UNION
                 SELECT MIN (NVL (TO_NUMBER (y.session_code), 0))
                                                                 session_code
                   FROM sgas.stud_crse_year y
                  WHERE y.stud_ref_no = v_stud_ref
                    AND y.latest_crse_ind = 'Y'
                    AND y.application_status IN ('W', 'C')
                 UNION
                 SELECT v_session_code
                   FROM DUAL) iv1;

         --0.04 RH start
         IF commencementyear > 0
         THEN
            -- do nothing
            commencementyear := commencementyear;
         ELSE                                                -- set it to NULL
            commencementyear := NULL;
         END IF;

         --0.04 RH end
         RETURN commencementyear;
      ELSE
         commencementyear := f_study_gap_exists (v_stud_ref, v_session_code);

         --0.04 RH start
         IF commencementyear > 0
         THEN
            -- do nothing
            commencementyear := commencementyear;
         ELSE                                                -- set it to NULL
            commencementyear := NULL;
         END IF;

         --0.04 RH end
         RETURN commencementyear;                     --gaps so take latest yr
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         commencementyear := NULL;
         RETURN commencementyear;                                   --0.04 RH
   END f_get_comm_yr;


    /* f_get_inst_location takes in the inst_code and return the location ind of the institution*/
    FUNCTION f_get_inst_location (p_inst_code IN VARCHAR2)
       RETURN VARCHAR2
    AS
       v_location_ind   VARCHAR2 (3) := null;
    BEGIN
       SELECT I.LOCATION_IND
         INTO v_location_ind
         FROM inst i
        WHERE I.INST_CODE = p_inst_code;

       RETURN v_location_ind;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN v_location_ind;                                   --0.04 RH
    END f_get_inst_location;
   
   -- 002 - Wee function from "asktom" to return date difference in specified units...
   FUNCTION datediff (p_what IN VARCHAR2, p_d1 IN DATE, p_d2 IN DATE)
      RETURN NUMBER
   AS
      v_result   NUMBER;
   BEGIN
      SELECT   (p_d2 - p_d1)
             * DECODE (UPPER (p_what),
                       'SS', 24 * 60 * 60,
                       'MI', 24 * 60,
                       'HH', 24,
                       NULL
                      )
        INTO v_result
        FROM DUAL;

      RETURN NVL (v_result, 0);
   END;

   -- 001 - Steps application locks.
   PROCEDURE insert_steps_lock (
      p_object_id              steps_locks.object_id%TYPE,
      p_batch_type             steps_locks.batch_type%TYPE,
      p_lock_type              steps_locks.lock_type%TYPE,
      p_combination            steps_locks.combination%TYPE,
      p_msg           IN OUT   VARCHAR2,
      p_lock_age      OUT      NUMBER,
      p_status        IN OUT   VARCHAR2
   )
   IS
      v_msg_detail   VARCHAR2 (100);
   BEGIN
      BEGIN
         INSERT INTO steps_locks
                     (object_id, batch_type, lock_type, combination,
                      datetime
                     )
              VALUES (p_object_id, p_batch_type, p_lock_type, p_combination,
                      SYSDATE
                     );

         COMMIT;
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            p_status := 'FALSE';

            -- How old is the lock - in minutes?
            -- Assume that all locks are placed at same time for given object_id
            BEGIN
               SELECT ROUND (datediff ('MI', datetime, SYSDATE))
                 INTO p_lock_age
                 FROM steps_locks
                WHERE lock_type = p_lock_type
                  AND combination = p_combination
                  AND batch_type = p_batch_type
                  AND object_id = p_object_id;
            -- Lock may be cleared by other threads - so watch out for the error if it has...
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  p_status := 'FALSE';
                  p_lock_age := 0;
                  ROLLBACK;
            END;

            v_msg_detail :=
                    p_lock_type || ':' || CHR (34) || p_combination
                    || CHR (34);

            IF p_msg IS NULL
            THEN
               p_msg := 'Failed locks - ' || v_msg_detail;
            ELSE
               p_msg := p_msg || ', ' || v_msg_detail;
            END IF;

            ROLLBACK;
      -- Throw the exception for others...
      END;
   END insert_steps_lock;

   -- 001 - Implement steps application locks.
   -- Note: Should use arrays but would require oracle jdbc i*faces (not available from IS?) - SD.
   -- Boolean status changed to string type to ease handling in WM.
   PROCEDURE set_steps_lock (
      p_object_id                    VARCHAR2,
      p_batch_id                     VARCHAR2,
      p_lock_type1          IN       steps_locks.lock_type%TYPE := NULL,
      p_lock_combination1   IN       steps_locks.combination%TYPE := NULL,
      p_lock_type2          IN       steps_locks.lock_type%TYPE := NULL,
      p_lock_combination2   IN       steps_locks.combination%TYPE := NULL,
      p_lock_type3          IN       steps_locks.lock_type%TYPE := NULL,
      p_lock_combination3   IN       steps_locks.combination%TYPE := NULL,
      p_lock_type4          IN       steps_locks.lock_type%TYPE := NULL,
      p_lock_combination4   IN       steps_locks.combination%TYPE := NULL,
      p_lock_type5          IN       steps_locks.lock_type%TYPE := NULL,
      p_lock_combination5   IN       steps_locks.combination%TYPE := NULL,
      p_lock_type6          IN       steps_locks.lock_type%TYPE := NULL,
      p_lock_combination6   IN       steps_locks.combination%TYPE := NULL,
      p_lock_type7          IN       steps_locks.lock_type%TYPE := NULL,
      p_lock_combination7   IN       steps_locks.combination%TYPE := NULL,
      p_lock_type8          IN       steps_locks.lock_type%TYPE := NULL,
      p_lock_combination8   IN       steps_locks.combination%TYPE := NULL,
      p_msg                 OUT      VARCHAR2,
      p_lock_age            OUT      NUMBER,
      p_status              OUT      VARCHAR2
   )
   IS
   BEGIN
      p_status := 'TRUE';
      p_msg := '';

      -- If the lock_type is null do nothing, otherwise insert the new lock.
      IF p_lock_combination1 IS NOT NULL
      THEN
         insert_steps_lock (p_object_id,
                            p_batch_id,
                            p_lock_type1,
                            p_lock_combination1,
                            p_msg,
                            p_lock_age,
                            p_status
                           );
      END IF;

      IF p_lock_combination2 IS NOT NULL
      THEN
         insert_steps_lock (p_object_id,
                            p_batch_id,
                            p_lock_type2,
                            p_lock_combination2,
                            p_msg,
                            p_lock_age,
                            p_status
                           );
      END IF;

      IF p_lock_combination3 IS NOT NULL
      THEN
         insert_steps_lock (p_object_id,
                            p_batch_id,
                            p_lock_type3,
                            p_lock_combination3,
                            p_msg,
                            p_lock_age,
                            p_status
                           );
      END IF;

      IF p_lock_combination4 IS NOT NULL
      THEN
         insert_steps_lock (p_object_id,
                            p_batch_id,
                            p_lock_type4,
                            p_lock_combination4,
                            p_msg,
                            p_lock_age,
                            p_status
                           );
      END IF;

      IF p_lock_combination5 IS NOT NULL
      THEN
         insert_steps_lock (p_object_id,
                            p_batch_id,
                            p_lock_type5,
                            p_lock_combination5,
                            p_msg,
                            p_lock_age,
                            p_status
                           );
      END IF;

      IF p_lock_combination6 IS NOT NULL
      THEN
         insert_steps_lock (p_object_id,
                            p_batch_id,
                            p_lock_type6,
                            p_lock_combination6,
                            p_msg,
                            p_lock_age,
                            p_status
                           );
      END IF;

      IF p_lock_combination7 IS NOT NULL
      THEN
         insert_steps_lock (p_object_id,
                            p_batch_id,
                            p_lock_type7,
                            p_lock_combination7,
                            p_msg,
                            p_lock_age,
                            p_status
                           );
      END IF;

      IF p_lock_combination8 IS NOT NULL
      THEN
         insert_steps_lock (p_object_id,
                            p_batch_id,
                            p_lock_type8,
                            p_lock_combination8,
                            p_msg,
                            p_lock_age,
                            p_status
                           );
      END IF;
   END set_steps_lock;
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
FUNCTION check_pams(p_inst_code INST.inst_code%TYPE,
            p_crse_code CRSE.crse_code%TYPE) RETURN BOOLEAN IS
v_pams    VARCHAR2(1);
v_qual    CRSE.qual_type%TYPE;
BEGIN
       SELECT NVL(pams_course,'N'), qual_type
       INTO v_pams, v_qual
       FROM CRSE
       WHERE crse_code = p_crse_code
       AND     inst_code = p_inst_code;
       IF (v_pams = 'Y' OR v_qual = 'HEALTH') THEN
           RETURN TRUE;
       ELSE
           RETURN FALSE;
       END IF;
EXCEPTION
WHEN OTHERS THEN
  RETURN FALSE;
END check_pams;
END pk_steps_utils;
/
