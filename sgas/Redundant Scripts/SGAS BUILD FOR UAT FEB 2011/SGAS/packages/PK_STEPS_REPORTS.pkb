CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_REPORTS
AS
/******************************************************************************
   NAME:       NMSB_RULES_PROC
   PURPOSE:    This package is used in order to supply the Rules service with values in which to calculate the NMSB Student Award

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03.11.2010  Paul Hughes     Created this package body
   1.01       15.11.2010 John Penman      Added getTuitionFeeStatusReport procedure
   1.02       14.12.2010 John Penman      Corrected getFeeStatusReport   


******************************************************************************/


PROCEDURE getFeeStatusReport (p_inst_code IN CHAR, p_session_code IN NUMBER, p_fee_status IN OUT fee_status_cursor)
IS

BEGIN

    OPEN p_fee_status FOR
        ----FIRST SELECT WILL DEAL WITH APPLICATIONS WHICH DO NOT HAVE AWARD RECORDS
SELECT ss.session_code as sessionCode, s.stud_ref_no AS saasRef, s.forenames AS firstName, s.surname, s.dob, ca.campus_id as campusID, scy.crse_code as crseCode, scy.crse_name AS crseTitle,
       scy.crse_year_no AS crseYear, NVL(scy.repeat_year,'N') AS repeatYear, 
                       CASE
                    WHEN scy.application_status = 'C'
                        THEN 'Calculated'
                    WHEN scy.application_status = 'W'
                        THEN 'Withdrawn'
                    WHEN scy.application_status = 'A'
                        THEN 'NonAttendance'
                    WHEN scy.application_status = 'R'
                        THEN 'Rejected'
                    WHEN scy.application_status = 'N'
                        THEN 'New'
                    ELSE 'Unknown'
                END applicationStatus, scy.withdraw_date AS dateWithdrawn, NVL(scy.reg_confirmed,'N') as registrationConfirmed, NVL(scy.attend_confirmed,'N') AS attendanceConfirmed, 
                CASE
                    WHEN s.suspend_payment = 'Y' OR s.stud_suspend = 'Y' OR ss.session_suspend = 'Y' OR scy.crse_suspend = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                END paymentSuspended, 
                null as feePayDate, 
                0 as feesAwarded, 
                0 as feesPayable, 
                null as feesPaidDate, 
                s.scottish_cand AS SLC, NVL(scy.chng_since_last_report,'N') as changed,
                scy.inst_code as instCode, scy.inst_name as instName, scy.stud_crse_year_id
FROM stud_crse_year scy, stud_session ss, crse c, campus ca, stud s
WHERE scy.stud_session_id = ss.stud_session_id
AND s.stud_ref_no = scy.stud_ref_no
AND scy.crse_id = c.crse_id
AND c.fees_campus = ca.campus_id
AND scy.latest_crse_ind = 'Y'
AND scy.session_code = p_session_code
AND scy.inst_code = p_inst_code
AND scy.stud_crse_year_id NOT IN(select stud_crse_year_id from AWARD)
UNION --- DEALS WITH APPLICATIONS IN CURRENT SESSION THAT HAVE AWARD RECORDS
---THIS QUERY WILL RETURN RECORDS WHICH EXIST ON THE AWARD TABLE.  THESE ARE LATEST_CRSE_IND = Y BUT FOR RECORDS WITH AWARD_SRC = T ONLY.
SELECT ss.session_code as sessionCode, s.stud_ref_no AS saasRef, s.forenames AS firstName, s.surname, s.dob, ca.campus_id as campusID, scy.crse_code as crseCode, scy.crse_name AS crseTitle,
       scy.crse_year_no AS crseYear, NVL(scy.repeat_year,'N') AS repeatYear, 
                       CASE
                    WHEN scy.application_status = 'C'
                        THEN 'Calculated'
                    WHEN scy.application_status = 'W'
                        THEN 'Withdrawn'
                    WHEN scy.application_status = 'A'
                        THEN 'NonAttendance'
                    WHEN scy.application_status = 'R'
                        THEN 'Rejected'
                    WHEN scy.application_status = 'N'
                        THEN 'New'
                    ELSE 'Unknown'
                END applicationStatus,
                scy.withdraw_date AS dateWithdrawn, 
               NVL(scy.reg_confirmed,'N') as registrationConfirmed, NVL(scy.attend_confirmed,'N') AS attendanceConfirmed, 
                CASE
                    WHEN s.suspend_payment = 'Y' OR s.stud_suspend = 'Y' OR ss.session_suspend = 'Y' OR scy.crse_suspend = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                END paymentSuspended, 
                ai.payment_due_date as feePayDate, 
                a.net_amount as feesAwarded, 
                ai.net_amount as feesPayable, 
                pi.payment_date as feesPaidDate,
                s.scottish_cand AS SLC, NVL(scy.chng_since_last_report,'N') as changed,
                scy.inst_code as instCode, scy.inst_name as instName, scy.stud_crse_year_id
FROM stud_crse_year scy, stud_session ss, crse c, campus ca, stud s, award a, award_instalment ai, payment_instalment pi
WHERE scy.stud_session_id = ss.stud_session_id
AND ai.award_instalment_id = pi.award_instalment_id(+)
AND s.stud_ref_no = scy.stud_ref_no
AND scy.stud_crse_year_id = a.stud_crse_year_id
AND a.award_id = ai.award_id
AND scy.crse_id = c.crse_id
AND c.fees_campus = ca.campus_id
AND scy.latest_crse_ind = 'Y'
AND a.award_src = 'T'
AND scy.session_code = p_session_code
AND scy.inst_code = p_inst_code
UNION
---THIS QUERY WILL RETURN RECORDS WHICH EXIST ON THE AWARD TABLE.  THESE ARE LATEST_CRSE_IND = Y BUT FOR RECORDS WITH AWARD_SRC = 'A'ONLY.  IN ORDER NOT TO RETRIEVE TOO MANY ROWS
---VALUES FOR FEES PAID IS SET TO 0.
SELECT DISTINCT ss.session_code as sessionCode, s.stud_ref_no AS saasRef, s.forenames AS firstName, s.surname, s.dob, ca.campus_id as campusID, scy.crse_code as crseCode, scy.crse_name AS crseTitle,
       scy.crse_year_no AS crseYear, NVL(scy.repeat_year,'N') AS repeatYear, 
                       CASE
                    WHEN scy.application_status = 'C'
                        THEN 'Calculated'
                    WHEN scy.application_status = 'W'
                        THEN 'Withdrawn'
                    WHEN scy.application_status = 'A'
                        THEN 'NonAttendance'
                    WHEN scy.application_status = 'R'
                        THEN 'Rejected'
                    WHEN scy.application_status = 'N'
                        THEN 'New'
                    ELSE 'Unknown'
                END applicationStatus,
                scy.withdraw_date AS dateWithdrawn, 
               NVL(scy.reg_confirmed,'N') as registrationConfirmed, NVL(scy.attend_confirmed,'N') AS attendanceConfirmed, 
                CASE
                    WHEN s.suspend_payment = 'Y' OR s.stud_suspend = 'Y' OR ss.session_suspend = 'Y' OR scy.crse_suspend = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                END paymentSuspended, 
                null as feePayDate, 
                0 as feesAwarded, 
                0 as feesPayable, 
                null as feesPaidDate,
                s.scottish_cand AS SLC, NVL(scy.chng_since_last_report,'N') as changed,
                scy.inst_code as instCode, scy.inst_name as instName, scy.stud_crse_year_id
FROM stud_crse_year scy, stud_session ss, crse c, campus ca, stud s, award a, award_instalment ai
WHERE scy.stud_session_id = ss.stud_session_id
AND s.stud_ref_no = scy.stud_ref_no
AND scy.stud_crse_year_id = a.stud_crse_year_id
AND a.award_id = ai.award_id
AND scy.crse_id = c.crse_id
AND c.fees_campus = ca.campus_id
AND scy.latest_crse_ind = 'Y'
AND a.award_src = 'A'
AND scy.session_code = p_session_code
AND scy.inst_code = p_inst_code
UNION
SELECT ss.session_code as sessionCode, s.stud_ref_no AS saasRef, s.forenames AS firstName, s.surname, s.dob, ca.campus_id as campusID, scy.crse_code as crseCode, scy.crse_name AS crseTitle,
       scy.crse_year_no AS crseYear, NVL(scy.repeat_year,'N') AS repeatYear, 
                                             CASE
                    WHEN scy.application_status = 'C'
                        THEN 'Calculated'
                    WHEN scy.application_status = 'W'
                        THEN 'Withdrawn'
                    WHEN scy.application_status = 'A'
                        THEN 'NonAttendance'
                    WHEN scy.application_status = 'R'
                        THEN 'Rejected'
                    WHEN scy.application_status = 'N'
                        THEN 'New'
                    ELSE 'Unknown'
                END applicationStatus,
                scy.withdraw_date AS dateWithdrawn, 
               NVL(scy.reg_confirmed,'N') as registrationConfirmed, NVL(scy.attend_confirmed,'N') AS attendanceConfirmed, 
                CASE
                    WHEN s.suspend_payment = 'Y' OR s.stud_suspend = 'Y' OR ss.session_suspend = 'Y' OR scy.crse_suspend = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                END paymentSuspended, 
                ai.payment_due_date as feePayDate, 
                a.net_amount as feesAwarded, 
                ai.net_amount as feesPayable, 
                pi.payment_date as feesPaidDate,
                s.scottish_cand AS SLC, NVL(scy.chng_since_last_report,'N') as changed,
                scy.inst_code as instCode, scy.inst_name as instName, scy.stud_crse_year_id
FROM stud_crse_year scy, stud_session ss, crse c, campus ca, stud s, award a, award_instalment ai, payment_instalment pi
WHERE scy.stud_session_id = ss.stud_session_id
AND ai.award_instalment_id = pi.award_instalment_id(+)
AND s.stud_ref_no = scy.stud_ref_no
AND scy.stud_crse_year_id = a.stud_crse_year_id
AND a.award_id = ai.award_id
AND scy.crse_id = c.crse_id
AND c.fees_campus = ca.campus_id
AND scy.inst_code = p_inst_code
AND a.award_src = 'T'
AND ai.payment_status <> 'S'
AND ai.net_amount <> 0
UNION
SELECT ss.session_code as sessionCode, s.stud_ref_no AS saasRef, s.forenames AS firstName, s.surname, s.dob, ca.campus_id as campusID, scy.crse_code as crseCode, scy.crse_name AS crseTitle,
       scy.crse_year_no AS crseYear, NVL(scy.repeat_year,'N') AS repeatYear, 
                CASE
                    WHEN scy.application_status = 'C'
                        THEN 'Calculated'
                    WHEN scy.application_status = 'W'
                        THEN 'Withdrawn'
                    WHEN scy.application_status = 'A'
                        THEN 'NonAttendance'
                    WHEN scy.application_status = 'R'
                        THEN 'Rejected'
                    WHEN scy.application_status = 'N'
                        THEN 'New'
                    ELSE 'Unknown'
                END applicationStatus,
                scy.withdraw_date AS dateWithdrawn, 
               NVL(scy.reg_confirmed,'N') as registrationConfirmed, NVL(scy.attend_confirmed,'N') AS attendanceConfirmed, 
                CASE
                    WHEN s.suspend_payment = 'Y' OR s.stud_suspend = 'Y' OR ss.session_suspend = 'Y' OR scy.crse_suspend = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                END paymentSuspended, 
                ai.payment_due_date as feePayDate, 
                a.net_amount as feesAwarded, 
                ai.net_amount as feesPayable, 
                pi.payment_date as feesPaidDate,
                s.scottish_cand AS SLC, NVL(scy.chng_since_last_report,'N') as changed,
                scy.inst_code as instCode, scy.inst_name as instName, scy.stud_crse_year_id
FROM stud_crse_year scy, stud_session ss, crse c, campus ca, stud s, award a, award_instalment ai, payment_instalment pi
WHERE scy.stud_session_id = ss.stud_session_id
AND ai.award_instalment_id = pi.award_instalment_id(+)
AND s.stud_ref_no = scy.stud_ref_no
AND scy.stud_crse_year_id = a.stud_crse_year_id
AND a.award_id = ai.award_id
AND scy.crse_id = c.crse_id
AND c.fees_campus = ca.campus_id
AND scy.latest_crse_ind = 'Y'
AND scy.application_status IN('C','W')
AND scy.reg_confirmed <> 'Y'
AND scy.ongoing_attend <> 'Y'
AND scy.session_code <> p_session_code
AND a.award_src = 'T'
AND scy.inst_code = p_inst_code
UNION
SELECT DISTINCT ss.session_code as sessionCode, s.stud_ref_no AS saasRef, s.forenames AS firstName, s.surname, s.dob, ca.campus_id as campusID, scy.crse_code as crseCode, scy.crse_name AS crseTitle,
       scy.crse_year_no AS crseYear, NVL(scy.repeat_year,'N') AS repeatYear, 
                CASE
                    WHEN scy.application_status = 'C'
                        THEN 'Calculated'
                    WHEN scy.application_status = 'W'
                        THEN 'Withdrawn'
                    WHEN scy.application_status = 'A'
                        THEN 'NonAttendance'
                    WHEN scy.application_status = 'R'
                        THEN 'Rejected'
                    WHEN scy.application_status = 'N'
                        THEN 'New'
                    ELSE 'Unknown'
                END applicationStatus,
                scy.withdraw_date AS dateWithdrawn, 
               NVL(scy.reg_confirmed,'N') as registrationConfirmed, NVL(scy.attend_confirmed,'N') AS attendanceConfirmed, 
                CASE
                    WHEN s.suspend_payment = 'Y' OR s.stud_suspend = 'Y' OR ss.session_suspend = 'Y' OR scy.crse_suspend = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                END paymentSuspended, 
                null as feePayDate, 
                0 as feesAwarded, 
                0 as feesPayable, 
                null as feesPaidDate,
                s.scottish_cand AS SLC, NVL(scy.chng_since_last_report,'N') as changed,
                scy.inst_code as instCode, scy.inst_name as instName, scy.stud_crse_year_id
FROM stud_crse_year scy, stud_session ss, crse c, campus ca, stud s, award a, award_instalment ai
WHERE scy.stud_session_id = ss.stud_session_id
AND s.stud_ref_no = scy.stud_ref_no
AND scy.stud_crse_year_id = a.stud_crse_year_id
AND a.award_id = ai.award_id
AND scy.crse_id = c.crse_id
AND c.fees_campus = ca.campus_id
AND scy.latest_crse_ind = 'Y'
AND scy.application_status IN('C','W')
AND scy.reg_confirmed <> 'Y'
AND scy.ongoing_attend <> 'Y'
AND scy.session_code <> p_session_code
AND a.award_src = 'A'
AND scy.inst_code = p_inst_code;

END getFeeStatusReport;




PROCEDURE getFeePaymentReport (p_campus_id IN NUMBER, p_fee_payment_date IN VARCHAR2, p_fee_payment IN OUT fee_payment_cursor) 

IS
BEGIN
    OPEN p_fee_payment FOR
    
    SELECT
      ss.session_code,              --5
      s.stud_ref_no AS saasRef,     --6
      s.forenames AS firstName,     --7
      s.surname,                    --8
      s.dob,                        --9
      ca.campus_id AS campusID,     --10
      scy.crse_code as courseCode,  --11
      scy.crse_name AS courseTitle, --12
      scy.crse_year_no AS courseYear,--13
      scy.repeat_year AS repeatYear, --14
                CASE
                    WHEN scy.application_status = 'C'
                        THEN 'Calculated'
                    WHEN scy.application_status = 'W'
                        THEN 'Withdrawn'
                    WHEN scy.application_status = 'A'
                        THEN 'NonAttendance'
                    WHEN scy.application_status = 'R'
                        THEN 'Rejected'
                    WHEN scy.application_status = 'N'
                        THEN 'New'
                    ELSE 'Unknown'
                END appStatus, --15
      s.scottish_cand AS slfRef, --16
      pi.payment_date AS feesPayDate, --17
      a.amount AS feesAwarded, --18
      ai.net_amount AS feesToBePaid, --19
      scy.inst_code, --20
      scy.inst_name  -- 21
                from stud_session ss, stud s, stud_crse_year scy, award a, award_instalment ai, payment_instalment pi, crse c, campus ca, payee_payment pp
        where ss.stud_ref_no = s.stud_ref_no
        and ss.stud_session_id = scy.stud_session_id
     --   and scy.latest_crse_ind = 'Y'     
        and scy.stud_crse_year_id = a.stud_crse_year_id   
        and ai.award_id = a.award_id
        and a.award_src = 'T'
        and ai.award_instalment_id = pi.award_instalment_id
        and pp.payee_ref_id = p_campus_id
        and trunc(pp.payment_run_date) = TO_DATE(p_fee_payment_date, 'DD-MM-YYYY')
        AND scy.crse_id = c.crse_id
        AND c.fees_campus = ca.campus_id
        and pi.payee_payment_id = pp.payee_payment_id;

END getFeePaymentReport;

END PK_STEPS_REPORTS;
/
