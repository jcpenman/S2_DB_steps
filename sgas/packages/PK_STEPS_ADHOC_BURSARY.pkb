CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_ADHOC_BURSARY
IS
   /******************************************************************************
      NAME:       PK_STEPS_ADHOC_BURSARY_2015_2016
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        28/08/2015  Clark Bolan     Adhoc bursary 2015/2016
   ******************************************************************************/
   PROCEDURE get_adhoc_bursary_students (p_students OUT ab_students_cursor)
   IS
      c_students              ab_students_cursor;
      l_include_provisional   CHAR;
   BEGIN
      SELECT cval
        INTO l_include_provisional
        FROM config_data
       WHERE item_name = 'ADHOC_BURS_INCLUDE_PROVISIONAL';


      IF l_include_provisional = 'Y'       --don't check for provisional cases
      THEN
         OPEN c_students FOR
            SELECT DISTINCT
                   s.stud_ref_no,
                   SCY.STUD_CRSE_YEAR_ID,
                   SCY.INST_CODE,
                   SCY.CRSE_ID,
                   SCY.SESSION_CODE,
                   SCY.CRSE_YEAR_NO,
                   (SELECT cval
                      FROM config_data
                     WHERE item_name = 'ADHOC_PAYMENT_DATE')
                      AS adhoc_payment_date,
                   SUBSTR (S.STUD_REF_NO, -4, 4) MASKED_SRN,
                   S.EMAIL_ADDR,
                   (CASE
                       WHEN INSTR (s.forenames, ' ') > 1
                       THEN
                          SUBSTR (s.forenames,
                                  0,
                                  INSTR (s.forenames, ' ') - 1)
                       ELSE
                          s.FORENAMES
                    END)
                      FORENAMES
              FROM award a,
                   stud s,
                   attendance_data ad,
                   stud_session ss,
                   stud_crse_year scy
             WHERE     S.STUD_REF_NO = SCY.STUD_REF_NO            --table join
                   AND SCY.STUD_CRSE_YEAR_ID = AD.STUD_CRSE_YEAR_ID --table join
                   AND A.STUD_CRSE_YEAR_ID = SCY.STUD_CRSE_YEAR_ID --table join
                   AND SS.STUD_SESSION_ID = SCY.STUD_SESSION_ID   --table join
                   AND SGAS.PK_AWARD_CALCULATION.getHouseHoldIncome (
                          scy.stud_crse_year_id) < 24000 -- household income is below 24k
                   AND SCY.LATEST_CRSE_IND = 'Y' -- latest course year records only
                   AND SCY.SESSION_CODE = 2015                 -- Session 2015
                   AND a.STUD_AWARD_TYPE IN ('YSB', 'ISB') -- only select YSB and ISB with AMOUNT greater 0
                   AND A.AMOUNT > 0 -- only select YSB and ISB with AMOUNT greater 0
                   AND SCY.APPLICATION_STATUS = 'C'   -- Calculated cases only
                   AND ad.ENROL_CONFIRMED = 'Y' -- Enrolment and Attendace confirmed
                   AND ad.ENROL_REQUIRED = 'Y' -- Enrolment and Attendace confirmed
                   AND ad.ONGOING_ATTENDANCE_CONFIRMED = 'Y' -- Enrolment and Attendace confirmed
                   AND ad.ONGOING_REQUIRED = 'Y' -- Enrolment and Attendace confirmed
                   AND S.STUD_SUSPEND = 'N'                   -- not suspended
                   AND S.SUSPEND_PAYMENT = 'N'                -- not suspended
                   AND SCY.CRSE_SUSPEND = 'N'                 -- not suspended
                   AND SS.SESSION_SUSPEND = 'N'               -- not suspended
                   AND NOT EXISTS
                              (SELECT 1
                                 FROM award_instalment
                                WHERE     adhoc_type = 'B'
                                      AND award_id IN
                                             (SELECT award_id
                                                FROM award
                                               WHERE stud_ref_no =
                                                        s.stud_ref_no)) -- no adhoc bursary already
                   AND S.QA_COUNT = 0;
      ELSE
         OPEN c_students FOR           --check that provisional is not flagged
            SELECT DISTINCT
                   s.stud_ref_no,
                   SCY.STUD_CRSE_YEAR_ID,
                   SCY.INST_CODE,
                   SCY.CRSE_ID,
                   SCY.SESSION_CODE,
                   SCY.CRSE_YEAR_NO,
                   (SELECT cval
                      FROM config_data
                     WHERE item_name = 'ADHOC_PAYMENT_DATE')
                      AS adhoc_payment_date,
                   SUBSTR (S.STUD_REF_NO, -4, 4) MASKED_SRN,
                   S.EMAIL_ADDR,
                   (CASE
                       WHEN INSTR (s.forenames, ' ') > 1
                       THEN
                          SUBSTR (s.forenames,
                                  0,
                                  INSTR (s.forenames, ' ') - 1)
                       ELSE
                          s.FORENAMES
                    END)
                      FORENAMES
              FROM award a,
                   stud s,
                   attendance_data ad,
                   stud_session ss,
                   stud_crse_year scy
             WHERE     S.STUD_REF_NO = SCY.STUD_REF_NO            --table join
                   AND SCY.STUD_CRSE_YEAR_ID = AD.STUD_CRSE_YEAR_ID --table join
                   AND A.STUD_CRSE_YEAR_ID = SCY.STUD_CRSE_YEAR_ID --table join
                   AND SS.STUD_SESSION_ID = SCY.STUD_SESSION_ID   --table join
                   AND SGAS.PK_AWARD_CALCULATION.getHouseHoldIncome (
                          scy.stud_crse_year_id) < 24000 -- household income is below 24k
                   AND SCY.LATEST_CRSE_IND = 'Y' -- latest course year records only
                   AND SCY.SESSION_CODE = 2015                 -- Session 2015
                   AND a.STUD_AWARD_TYPE IN ('YSB', 'ISB') -- only select YSB and ISB with AMOUNT greater 0
                   AND A.AMOUNT > 0 -- only select YSB and ISB with AMOUNT greater 0
                   AND SCY.APPLICATION_STATUS = 'C'   -- Calculated cases only
                   AND ad.ENROL_CONFIRMED = 'Y' -- Enrolment and Attendace confirmed
                   AND ad.ENROL_REQUIRED = 'Y' -- Enrolment and Attendace confirmed
                   AND ad.ONGOING_ATTENDANCE_CONFIRMED = 'Y' -- Enrolment and Attendace confirmed
                   AND ad.ONGOING_REQUIRED = 'Y' -- Enrolment and Attendace confirmed
                   AND S.STUD_SUSPEND = 'N'                   -- not suspended
                   AND S.SUSPEND_PAYMENT = 'N'                -- not suspended
                   AND SCY.CRSE_SUSPEND = 'N'                 -- not suspended
                   AND SS.SESSION_SUSPEND = 'N'               -- not suspended
                   AND NOT EXISTS
                              (SELECT 1
                                 FROM award_instalment
                                WHERE     adhoc_type = 'B'
                                      AND award_id IN
                                             (SELECT award_id
                                                FROM award
                                               WHERE stud_ref_no =
                                                        s.stud_ref_no)) -- no adhoc bursary already
                   AND S.QA_COUNT = 0
                   AND SCY.PROVISIONAL_CASE = 'N';
      END IF;

      p_students := c_students;
   END get_adhoc_bursary_students;
END PK_STEPS_ADHOC_BURSARY;
/