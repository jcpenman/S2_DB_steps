CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_REPORTS
AS
/******************************************************************************
   NAME:       NMSB_RULES_PROC
   PURPOSE:    This package is used in order to supply the Rules service with values in which to calculate the NMSB Student Award

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03.11.2010  Paul Hughes      Created this package body
   1.01       15.11.2010 John Penman       Added getTuitionFeeStatusReport procedure
   1.02       14.12.2010 John Penman       Corrected getFeeStatusReport   
   1.03       25.03.2011  Paul Hughes      Changed since last report field added.
   1.04       28.03.2011  Paul Hughes      Marked as Final Live version
   1.05       20.04.2011  Paul Hughes      Fix to Status Report first query to return all latest crse ind where award_src <> T
   1.06       03.05.2011  Paul Hughes      Added new query to bring back withdrawn students who have AWARD.AWARD_SRC = T but no award instalment records.
   1.07       20.07.2011  Paul Hughes      New Attendance Data Project Changes  
   1.2        27.01.2013  Paul Hughes      Fix to live issue of duplicate Rows
   1.3        01.02.2013  Paul Hughes      Updated Functions to do a count and removed outer joins.
   1.4        29/04/2014   Clark Bolan     Updated the daily stats SELECT to used DATE_APP_RECEIVED when calculating auto calcs and auto calc total  
   1.5        13/05/2014   Clark Bolan     Changes to the TotalReceived for daily stats defect90
   1.6        22/07/2014   John Penman     Changed NOT IN to NOT EXISTS defect 80
   1.8        01/09/2014   Clark Bolan     FUNCTIONS getFeesPayable and getfeesAwarded changed to include SUM (defect 202) 
   1.9        24/04/2018   John Penman     Added NMSB Autocalculated cases for IT CR197585 
   2.0        02/08/2018   Clark Bolan     Changed the input for ALL_CORR_REC_TOTAL from p_enter_number_of_days_back to p_enter_days_back_minus_one


******************************************************************************/

 
FUNCTION getFeePaidDate (p_stud_crse_year_id IN NUMBER) RETURN DATE
    IS
        p_fees_payment_date  DATE;
        p_count              NUMBER;
        
   BEGIN 
   
        SELECT COUNT(*)
        INTO p_count
        FROM AWARD_INSTALMENT ai, AWARD a
        WHERE a.award_id = ai.award_id
        AND a.STUD_CRSE_YEAR_ID = p_stud_crse_year_id
        AND a.award_src = 'T'
        AND ai.payment_status = 'U';
   
        IF p_count > 0
            THEN 
                SELECT TO_CHAR(MAX(pi.payment_date))
                INTO p_fees_payment_date
                FROM PAYMENT_INSTALMENT pi, AWARD_INSTALMENT ai, AWARD a
                WHERE pi.AWARD_INSTALMENT_ID = AI.AWARD_INSTALMENT_ID
                AND a.award_id = ai.award_id
                AND a.award_src = 'T'
                AND a.stud_crse_year_id = p_stud_crse_year_id; 
                
        ELSE p_fees_payment_date := TO_DATE('01/01/1900','DD/MM/YYYY');
        
        END IF;
        
        RETURN p_fees_payment_date;
        
END getFeePaidDate;

FUNCTION getFeesPayable (p_stud_crse_year_id IN NUMBER) RETURN NUMBER
    IS
        p_getFeesPayable NUMBER;
        
    BEGIN
    
        SELECT SUM(ai.net_amount) 
        INTO p_getFeesPayable
        FROM AWARD a, AWARD_INSTALMENT ai 
        WHERE a.award_id = ai.award_id 
        AND a.award_src = 'T' 
        AND a.stud_crse_year_id = p_stud_crse_year_id
        AND ai.PAYMENT_STATUS = 'U';
        
        RETURN p_getFeesPayable;
        
   END getFeesPayable;

 

FUNCTION getfeesAwarded (p_stud_crse_year_id IN NUMBER) RETURN NUMBER
    IS
        p_getfeesAwarded  NUMBER;
        
   BEGIN
   
        SELECT NVL(SUM(a.net_amount), 0)
        INTO p_getfeesAwarded
        FROM AWARD a
        WHERE STUD_CRSE_YEAR_ID = p_stud_crse_year_id
        AND a.award_src = 'T';
        

        RETURN p_getfeesAwarded;
        
END getfeesAwarded;


FUNCTION getFeePaymentDate (p_stud_crse_year_id IN NUMBER) RETURN DATE
    IS
        p_fee_payment_date  DATE;
        p_count             NUMBER;
        
   BEGIN
   
        SELECT COUNT(*)
        INTO p_count
        FROM AWARD_INSTALMENT ai, AWARD a
        WHERE a.award_id = ai.award_id
        AND a.award_src = 'T'
        AND a.stud_crse_year_id = p_stud_crse_year_id;
        
        IF p_count > 0
            THEN 
        
   
        SELECT TO_CHAR(MAX(ai.PAYMENT_DUE_DATE))
        INTO p_fee_payment_date
        FROM AWARD_INSTALMENT ai, AWARD a
        WHERE a.award_id = ai.award_id
        AND a.award_src = 'T'
        AND a.stud_crse_year_id = p_stud_crse_year_id;
        
        ELSE p_fee_payment_date := TO_DATE('01/01/1900','DD/MM/YYYY');
        
        END IF;
        
        RETURN p_fee_payment_date;
        
END getFeePaymentDate;

    


PROCEDURE getFeeStatusReport2012 (p_inst_code IN CHAR, p_session_code IN NUMBER, p_fee_status IN OUT fee_status_cursor)
IS

BEGIN

------------------------------2012--------------------------------2012------------------------------2012-------------------------2012----------------------2012-------------2012--------
        OPEN p_fee_status FOR
        
    SELECT sessionCode, saasRef, firstName, surname, dob, campusID, crsecode, crseTitle, crseYear, repeatYear, applicationStatus, NoTrace, dateWithdrawn, registrationConfirmed, 
       attendanceConfirmed, paymentSuspended, 
        CASE 
        WHEN feePayDate = TO_DATE('01/01/1900','DD/MM/YYYY')
        THEN NULL
        ELSE TO_CHAR(feePayDate,'DD/MM/YYYY')
        END feePayDate, 
        NVL(feesAwarded,0) AS feesAwarded, NVL(feesPayable,0) AS feesPayable, 
       CASE
        WHEN feesPaidDate = TO_DATE('01/01/1900','DD/MM/YYYY')
        THEN NULL
        ELSE TO_CHAR(feesPaidDate,'DD/MM/YYYY')
        END feesPaidDate, SLC, changed, NotificationToBeProcessed, SupportRestrictDate, FeeRestrictDate,
       DateAppnReceived, PlacementYear, AbroadYear, CourseStartDate, instCode, instName, stud_crse_year_id
       FROM(
SELECT ss.session_code as sessionCode, s.stud_ref_no AS saasRef, s.forenames AS firstName, s.surname, TO_CHAR(s.dob,'DD/MM/YYYY') as dob, ca.campus_id as campusID, 
           CASE
          WHEN LENGTH (cy.hei_crse_code) = 5
          AND SUBSTR (cy.hei_crse_code, 5, 1) IN
                 ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
                  'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y',
                  'Z')                             -- does not end in a number
             THEN SUBSTR (cy.hei_crse_code, 1, 4)
          ELSE cy.hei_crse_code
       END crsecode,  
    scy.crse_name AS crseTitle,
       scy.crse_year_no AS crseYear, NVL(scy.repeat_year,'N') AS repeatYear, 
                       CASE
                    WHEN scy.application_status = 'C'
                        THEN 'Calculated'
                    WHEN scy.application_status = 'W' THEN 
                            CASE WHEN s.deceased_flag ='Y' THEN 'Deceased' ELSE 'Withdrawn' END
                    WHEN scy.application_status = 'A'
                        THEN 'NonAttendance'
                    WHEN scy.application_status = 'R'
                        THEN 'Rejected'
                    WHEN scy.application_status = 'N'
                        THEN 'New'
                    WHEN scy.application_status = 'T'
                        THEN 'Returned'                   
                    ELSE 'Unknown'
                END applicationStatus,
                NVL(AD.NO_TRACE, 'N') AS NoTrace,
                TO_CHAR(scy.withdraw_date,'DD/MM/YYYY') AS dateWithdrawn,
    CASE
    WHEN
        ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    END registrationConfirmed, 
    CASE
    WHEN  
        ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
      THEN 'Y'
    WHEN ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
        THEN 'N'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
        THEN 'Y'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
    THEN null
    END attendanceConfirmed, 
                CASE
                    WHEN s.suspend_payment = 'Y' OR s.stud_suspend = 'Y' OR ss.session_suspend = 'Y' OR scy.crse_suspend = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                END paymentSuspended, 
                ai.payment_due_date AS feePayDate,
                a.net_amount AS feesAwarded,
                sgas.pk_steps_reports.getFeesPayable(scy.stud_crse_year_id) AS feesPayable,
                pi.payment_date AS feesPaidDate,
                CONCAT('SAAS',s.scottish_cand) AS SLC, 
                ad.chngd_since_last_report as changed,
                                        CASE
                            WHEN (SELECT COUNT(*) FROM ATTENDANCE_DATA_RECEIVED
                                  WHERE STUD_REF_NO = scy.stud_ref_no
                                  AND DUPLICATE  = 'N'
                                  AND PROCESSED = 'N'
                                  AND SESSION_CODE = scy.session_code) > 0
                        THEN 'Y'
                        ELSE 'N'
                        END NotificationToBeProcessed,
                CASE
                    WHEN ad.restrict_payments_enrol IS NOT NULL
                        THEN TO_CHAR(ad.restrict_payments_enrol,'DD/MM/YYYY')
                    ELSE TO_CHAR(ad.restrict_payments_attend,'DD/MM/YYYY')
                END SupportRestrictDate,
                TO_CHAR(ad.restrict_fee_attend,'DD/MM/YYYY') AS FeeRestrictDate,
                TO_CHAR(ss.date_applic_received,'DD/MM/YYYY') AS DateAppnReceived,
                CASE
                    WHEN scy.paid_sandwich = 'Y' OR scy.unpaid_sandwich = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                    END PlacementYear,
                NVL(scy.study_abroad,'N') AS AbroadYear,
                TO_CHAR(SGAS.RULES_PROC_RECALC.GETSTUDYSTARTDATE(scy.stud_crse_year_id),'DD/MM/YYYY') AS CourseStartDate,
                scy.inst_code as instCode, scy.inst_name as instName, scy.stud_crse_year_id             
FROM stud_crse_year scy, stud_session ss, crse c, campus ca, stud s, crse_year cy, attendance_data ad, award a, award_instalment ai, payment_instalment pi
WHERE scy.stud_session_id = ss.stud_session_id
AND scy.stud_crse_year_id = ad.stud_crse_year_id
AND s.stud_ref_no = scy.stud_ref_no
AND scy.crse_year_id = cy.crse_year_id
AND scy.crse_id = c.crse_id
AND c.fees_campus = ca.campus_id
AND a.award_id = ai.award_id
AND ai.award_instalment_id = pi.award_instalment_id
AND a.stud_crse_year_id = scy.stud_crse_year_id  ----_FEEES ONLY STUDENTS
AND a.award_src = 'T'
AND scy.inst_code = p_inst_code
AND scy.session_code = p_session_code 
AND ai.payment_status = 'S'
AND scy.latest_crse_ind = 'Y' ---QUERY ONE OF FUNCTIONAL SPECIFICATION
UNION
SELECT ss.session_code as sessionCode, s.stud_ref_no AS saasRef, s.forenames AS firstName, s.surname, TO_CHAR(s.dob,'DD/MM/YYYY') as dob, ca.campus_id as campusID, 
           CASE
          WHEN LENGTH (cy.hei_crse_code) = 5
          AND SUBSTR (cy.hei_crse_code, 5, 1) IN
                 ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
                  'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y',
                  'Z')                             -- does not end in a number
             THEN SUBSTR (cy.hei_crse_code, 1, 4)
          ELSE cy.hei_crse_code
       END crsecode,  
    scy.crse_name AS crseTitle,
       scy.crse_year_no AS crseYear, NVL(scy.repeat_year,'N') AS repeatYear, 
                       CASE
                    WHEN scy.application_status = 'C'
                        THEN 'Calculated'
                    WHEN scy.application_status = 'W' THEN 
                            CASE WHEN s.deceased_flag ='Y' THEN 'Deceased' ELSE 'Withdrawn' END
                    WHEN scy.application_status = 'A'
                        THEN 'NonAttendance'
                    WHEN scy.application_status = 'R'
                        THEN 'Rejected'
                    WHEN scy.application_status = 'N'
                        THEN 'New'
                    WHEN scy.application_status = 'T'
                        THEN 'Returned'                   
                    ELSE 'Unknown'
                END applicationStatus,
                NVL(AD.NO_TRACE, 'N') AS NoTrace,
                TO_CHAR(scy.withdraw_date,'DD/MM/YYYY') AS dateWithdrawn,
    CASE
    WHEN
        ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    END registrationConfirmed, 
    CASE
    WHEN  
        ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
      THEN 'Y'
    WHEN ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
        THEN 'N'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
        THEN 'Y'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
    THEN null
    END attendanceConfirmed, 
                CASE
                    WHEN s.suspend_payment = 'Y' OR s.stud_suspend = 'Y' OR ss.session_suspend = 'Y' OR scy.crse_suspend = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                END paymentSuspended,
                CASE
                    WHEN a.award_src = 'T'
                    THEN ai.payment_due_date
                    ELSE NULL
                    END feePayDate,  ----REQUIRED AS WE NEED TO RETURN THE DATE FOR ANYTHING WHICH IS UNPAID FEES BUT NOT FOR UNPAID AWWARDS
                a.net_amount AS feesAwarded,
                ai.net_amount as feesPayable, 
                NULL as feesPaidDate,
                CONCAT('SAAS',s.scottish_cand) AS SLC, 
                ad.chngd_since_last_report as changed,
                                        CASE
                            WHEN (SELECT COUNT(*) FROM ATTENDANCE_DATA_RECEIVED
                                  WHERE STUD_REF_NO = scy.stud_ref_no
                                  AND DUPLICATE  = 'N'
                                  AND PROCESSED = 'N'
                                  AND SESSION_CODE = scy.session_code) > 0
                        THEN 'Y'
                        ELSE 'N'
                        END NotificationToBeProcessed,
                CASE
                    WHEN ad.restrict_payments_enrol IS NOT NULL
                        THEN TO_CHAR(ad.restrict_payments_enrol,'DD/MM/YYYY')
                    ELSE TO_CHAR(ad.restrict_payments_attend,'DD/MM/YYYY')
                END SupportRestrictDate,
                TO_CHAR(ad.restrict_fee_attend,'DD/MM/YYYY') AS FeeRestrictDate,
                TO_CHAR(ss.date_applic_received,'DD/MM/YYYY') AS DateAppnReceived,
                CASE
                    WHEN scy.paid_sandwich = 'Y' OR scy.unpaid_sandwich = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                    END PlacementYear,
                NVL(scy.study_abroad,'N') AS AbroadYear,
                TO_CHAR(SGAS.RULES_PROC_RECALC.GETSTUDYSTARTDATE(scy.stud_crse_year_id),'DD/MM/YYYY') AS CourseStartDate,
                scy.inst_code as instCode, scy.inst_name as instName, scy.stud_crse_year_id             
FROM stud_crse_year scy, stud_session ss, crse c, campus ca, stud s, crse_year cy, attendance_data ad, award a, award_instalment ai
WHERE scy.stud_session_id = ss.stud_session_id
AND scy.stud_crse_year_id = ad.stud_crse_year_id
AND s.stud_ref_no = scy.stud_ref_no
AND scy.crse_year_id = cy.crse_year_id
AND scy.crse_id = c.crse_id
AND c.fees_campus = ca.campus_id
AND a.award_id = ai.award_id(+)
AND a.stud_crse_year_id = scy.stud_crse_year_id  ----_FEEES ONLY STUDENTS
AND a.award_src = 'T'
AND scy.inst_code = p_inst_code
AND scy.session_code = p_session_code 
AND scy.latest_crse_ind = 'Y' ---QUERY ONE OF FUNCTIONAL SPECIFICATION
AND scy.stud_crse_year_id NOT IN(select stud_crse_year_id from award a, award_instalment b where a.award_id = b.award_id and award_src = 'T' and payment_status = 'S' and a.session_code = p_session_code)
UNION
SELECT ss.session_code as sessionCode, s.stud_ref_no AS saasRef, s.forenames AS firstName, s.surname, TO_CHAR(s.dob,'DD/MM/YYYY') as dob, ca.campus_id as campusID, 
           CASE
          WHEN LENGTH (cy.hei_crse_code) = 5
          AND SUBSTR (cy.hei_crse_code, 5, 1) IN
                 ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
                  'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y',
                  'Z')                             -- does not end in a number
             THEN SUBSTR (cy.hei_crse_code, 1, 4)
          ELSE cy.hei_crse_code
       END crsecode,  
    scy.crse_name AS crseTitle,
       scy.crse_year_no AS crseYear, NVL(scy.repeat_year,'N') AS repeatYear, 
                       CASE
                    WHEN scy.application_status = 'C'
                        THEN 'Calculated'
                    WHEN scy.application_status = 'W' THEN 
                            CASE WHEN s.deceased_flag ='Y' THEN 'Deceased' ELSE 'Withdrawn' END
                    WHEN scy.application_status = 'A'
                        THEN 'NonAttendance'
                    WHEN scy.application_status = 'R'
                        THEN 'Rejected'
                    WHEN scy.application_status = 'N'
                        THEN 'New'
                    WHEN scy.application_status = 'T'
                        THEN 'Returned'                   
                    ELSE 'Unknown'
                END applicationStatus,
                NVL(AD.NO_TRACE, 'N') AS NoTrace,
                TO_CHAR(scy.withdraw_date,'DD/MM/YYYY') AS dateWithdrawn,
    CASE
    WHEN
        ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    END registrationConfirmed, 
    CASE
    WHEN  
        ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
      THEN 'Y'
    WHEN ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
        THEN 'N'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
        THEN 'Y'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
    THEN null
    END attendanceConfirmed, 
                CASE
                    WHEN s.suspend_payment = 'Y' OR s.stud_suspend = 'Y' OR ss.session_suspend = 'Y' OR scy.crse_suspend = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                END paymentSuspended, 
                null as feePayDate,
                NULL as feesAwarded,
                NULL as feesPayable, 
                null as feesPaidDate,
                CONCAT('SAAS',s.scottish_cand) AS SLC, 
                ad.chngd_since_last_report as changed,
                                        CASE
                            WHEN (SELECT COUNT(*) FROM ATTENDANCE_DATA_RECEIVED
                                  WHERE STUD_REF_NO = scy.stud_ref_no
                                  AND DUPLICATE  = 'N'
                                  AND PROCESSED = 'N'
                                  AND SESSION_CODE = scy.session_code) > 0
                        THEN 'Y'
                        ELSE 'N'
                        END NotificationToBeProcessed,
                CASE
                    WHEN ad.restrict_payments_enrol IS NOT NULL
                        THEN TO_CHAR(ad.restrict_payments_enrol,'DD/MM/YYYY')
                    ELSE TO_CHAR(ad.restrict_payments_attend,'DD/MM/YYYY')
                END SupportRestrictDate,
                TO_CHAR(ad.restrict_fee_attend,'DD/MM/YYYY') AS FeeRestrictDate,
                TO_CHAR(ss.date_applic_received,'DD/MM/YYYY') AS DateAppnReceived,
                CASE
                    WHEN scy.paid_sandwich = 'Y' OR scy.unpaid_sandwich = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                    END PlacementYear,
                NVL(scy.study_abroad,'N') AS AbroadYear,
                TO_CHAR(SGAS.RULES_PROC_RECALC.GETSTUDYSTARTDATE(scy.stud_crse_year_id),'DD/MM/YYYY') AS CourseStartDate,
                scy.inst_code as instCode, scy.inst_name as instName, scy.stud_crse_year_id             
FROM stud_crse_year scy, stud_session ss, crse c, campus ca, stud s, crse_year cy, attendance_data ad
WHERE scy.stud_session_id = ss.stud_session_id
AND scy.stud_crse_year_id = ad.stud_crse_year_id
AND s.stud_ref_no = scy.stud_ref_no
AND scy.crse_year_id = cy.crse_year_id
AND scy.crse_id = c.crse_id
AND c.fees_campus = ca.campus_id
AND scy.inst_code = p_inst_code
AND scy.session_code = p_session_code 
AND scy.latest_crse_ind = 'Y' ---QUERY ONE OF FUNCTIONAL SPECIFICATION
AND scy.stud_crse_year_id NOT IN(select stud_crse_year_id FROM AWARD WHERE AWARD_SRC = 'T' AND STUD_CRSE_YEAR_id = scy.stud_crse_year_id AND SESSION_CODE = p_session_code)
UNION
SELECT ss.session_code as sessionCode, s.stud_ref_no AS saasRef, s.forenames AS firstName, s.surname, TO_CHAR(s.dob,'DD/MM/YYYY') as dob, ca.campus_id as campusID, 
           CASE
          WHEN LENGTH (cy.hei_crse_code) = 5
          AND SUBSTR (cy.hei_crse_code, 5, 1) IN
                 ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
                  'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y',
                  'Z')                             -- does not end in a number
             THEN SUBSTR (cy.hei_crse_code, 1, 4)
          ELSE cy.hei_crse_code
       END crsecode,  
    scy.crse_name AS crseTitle,
       scy.crse_year_no AS crseYear, NVL(scy.repeat_year,'N') AS repeatYear, 
                       CASE
                    WHEN scy.application_status = 'C'
                        THEN 'Calculated'
                    WHEN scy.application_status = 'W' THEN 
                            CASE WHEN s.deceased_flag ='Y' THEN 'Deceased' ELSE 'Withdrawn' END
                    WHEN scy.application_status = 'A'
                        THEN 'NonAttendance'
                    WHEN scy.application_status = 'R'
                        THEN 'Rejected'
                    WHEN scy.application_status = 'N'
                        THEN 'New'
                    WHEN scy.application_status = 'T'
                        THEN 'Returned'                   
                    ELSE 'Unknown'
                END applicationStatus,
                NVL(AD.NO_TRACE, 'N') AS NoTrace,
                TO_CHAR(scy.withdraw_date,'DD/MM/YYYY') AS dateWithdrawn,
    CASE
    WHEN
        ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    END registrationConfirmed, 
    CASE
    WHEN  
        ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
      THEN 'Y'
    WHEN ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
        THEN 'N'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
        THEN 'Y'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
    THEN null
    END attendanceConfirmed, 
                CASE
                    WHEN s.suspend_payment = 'Y' OR s.stud_suspend = 'Y' OR ss.session_suspend = 'Y' OR scy.crse_suspend = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                END paymentSuspended, 
                sgas.pk_steps_reports.getFeePaymentDate(scy.stud_crse_year_id) AS feePayDate, 
                sgas.pk_steps_reports.getfeesAwarded(scy.stud_crse_year_id) AS feesAwarded, 
                sgas.pk_steps_reports.getFeesPayable(scy.stud_crse_year_id) AS feesPayable,
                null AS feesPaidDate,   ---WILL ONLY SHOW OUTSTANDING RECOVERIES
                CONCAT('SAAS',s.scottish_cand) AS SLC, 
                ad.chngd_since_last_report as changed,
                                        CASE
                            WHEN (SELECT COUNT(*) FROM ATTENDANCE_DATA_RECEIVED
                                  WHERE STUD_REF_NO = scy.stud_ref_no
                                  AND DUPLICATE  = 'N'
                                  AND PROCESSED = 'N'
                                  AND SESSION_CODE = scy.session_code) > 0
                        THEN 'Y'
                        ELSE 'N'
                        END NotificationToBeProcessed,
                CASE
                    WHEN ad.restrict_payments_enrol IS NOT NULL
                        THEN TO_CHAR(ad.restrict_payments_enrol,'DD/MM/YYYY')
                    ELSE TO_CHAR(ad.restrict_payments_attend,'DD/MM/YYYY')
                END SupportRestrictDate,
                TO_CHAR(ad.restrict_fee_attend,'DD/MM/YYYY') AS FeeRestrictDate,
                TO_CHAR(ss.date_applic_received,'DD/MM/YYYY') AS DateAppnReceived,
                CASE
                    WHEN scy.paid_sandwich = 'Y' OR scy.unpaid_sandwich = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                    END PlacementYear,
                NVL(scy.study_abroad,'N') AS AbroadYear,
                TO_CHAR(SGAS.RULES_PROC_RECALC.GETSTUDYSTARTDATE(scy.stud_crse_year_id),'DD/MM/YYYY') AS CourseStartDate,
                scy.inst_code as instCode, scy.inst_name as instName, scy.stud_crse_year_id
FROM stud_crse_year scy, stud_session ss, crse c, campus ca, stud s, crse_year cy, attendance_data ad, award a, award_instalment ai
WHERE scy.stud_session_id = ss.stud_session_id
AND scy.stud_crse_year_id = ad.stud_crse_year_id
AND scy.stud_crse_year_id = a.stud_crse_year_id
AND a.award_id = ai.award_id
AND s.stud_ref_no = scy.stud_ref_no
AND scy.crse_year_id = cy.crse_year_id
AND scy.crse_id = c.crse_id
AND c.fees_campus = ca.campus_id
AND scy.inst_code = p_inst_code
AND scy.latest_crse_ind = 'N' ---NEW ADDITION TO DEAL WITH CURRENT SESSION RECOVERIES NOT ON THE LATEST COURSE YOU RECORD.
AND scy.session_code = p_session_code
AND ai.payment_status = 'U'
AND a.award_src = 'T'
AND ai.net_amount < 0
UNION
SELECT ss.session_code as sessionCode, s.stud_ref_no AS saasRef, s.forenames AS firstName, s.surname, TO_CHAR(s.dob,'DD/MM/YYYY') as dob, ca.campus_id as campusID, 
           CASE
          WHEN LENGTH (cy.hei_crse_code) = 5
          AND SUBSTR (cy.hei_crse_code, 5, 1) IN
                 ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
                  'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y',
                  'Z')                             -- does not end in a number
             THEN SUBSTR (cy.hei_crse_code, 1, 4)
          ELSE cy.hei_crse_code
       END crsecode,  
    scy.crse_name AS crseTitle,
       scy.crse_year_no AS crseYear, NVL(scy.repeat_year,'N') AS repeatYear, 
                       CASE
                    WHEN scy.application_status = 'C'
                        THEN 'Calculated'
                    WHEN scy.application_status = 'W' THEN 
                            CASE WHEN s.deceased_flag ='Y' THEN 'Deceased' ELSE 'Withdrawn' END
                    WHEN scy.application_status = 'A'
                        THEN 'NonAttendance'
                    WHEN scy.application_status = 'R'
                        THEN 'Rejected'
                    WHEN scy.application_status = 'N'
                        THEN 'New'
                    WHEN scy.application_status = 'T'
                        THEN 'Returned'                   
                    ELSE 'Unknown'
                END applicationStatus,
                NVL(AD.NO_TRACE, 'N') AS NoTrace,
                TO_CHAR(scy.withdraw_date,'DD/MM/YYYY') AS dateWithdrawn,
    CASE
    WHEN
        ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    END registrationConfirmed, 
    CASE
    WHEN  
        ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
      THEN 'Y'
    WHEN ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
        THEN 'N'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
        THEN 'Y'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
    THEN null
    END attendanceConfirmed, 
                CASE
                    WHEN s.suspend_payment = 'Y' OR s.stud_suspend = 'Y' OR ss.session_suspend = 'Y' OR scy.crse_suspend = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                END paymentSuspended, 
                sgas.pk_steps_reports.getFeePaymentDate(scy.stud_crse_year_id) AS feePayDate, 
                sgas.pk_steps_reports.getfeesAwarded(scy.stud_crse_year_id) AS feesAwarded, 
                sgas.pk_steps_reports.getFeesPayable(scy.stud_crse_year_id) AS feesPayable,
                sgas.pk_steps_reports.getFeePaidDate(scy.stud_crse_year_id) AS feesPaidDate,
                CONCAT('SAAS',s.scottish_cand) AS SLC, 
                ad.chngd_since_last_report as changed,
                                        CASE
                            WHEN (SELECT COUNT(*) FROM ATTENDANCE_DATA_RECEIVED
                                  WHERE STUD_REF_NO = scy.stud_ref_no
                                  AND DUPLICATE  = 'N'
                                  AND PROCESSED = 'N'
                                  AND SESSION_CODE = scy.session_code) > 0
                        THEN 'Y'
                        ELSE 'N'
                        END NotificationToBeProcessed,
                CASE
                    WHEN ad.restrict_payments_enrol IS NOT NULL
                        THEN TO_CHAR(ad.restrict_payments_enrol,'DD/MM/YYYY')
                    ELSE TO_CHAR(ad.restrict_payments_attend,'DD/MM/YYYY')
                END SupportRestrictDate,
                TO_CHAR(ad.restrict_fee_attend,'DD/MM/YYYY') AS FeeRestrictDate,
                TO_CHAR(ss.date_applic_received,'DD/MM/YYYY') AS DateAppnReceived,
                CASE
                    WHEN scy.paid_sandwich = 'Y' OR scy.unpaid_sandwich = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                    END PlacementYear,
                NVL(scy.study_abroad,'N') AS AbroadYear,
                TO_CHAR(SGAS.RULES_PROC_RECALC.GETSTUDYSTARTDATE(scy.stud_crse_year_id),'DD/MM/YYYY') AS CourseStartDate,
                scy.inst_code as instCode, scy.inst_name as instName, scy.stud_crse_year_id
FROM stud_crse_year scy, stud_session ss, crse c, campus ca, stud s, crse_year cy, attendance_data ad, award a, award_instalment b
WHERE scy.stud_session_id = ss.stud_session_id
AND scy.stud_crse_year_id = ad.stud_crse_year_id
AND s.stud_ref_no = scy.stud_ref_no
AND scy.crse_year_id = cy.crse_year_id
AND scy.crse_id = c.crse_id
AND scy.stud_crse_year_id = a.stud_crse_year_id
AND a.award_id = b.award_id
AND c.fees_campus = ca.campus_id
AND scy.inst_code = p_inst_code
AND scy.latest_crse_ind = 'Y' ---QUERY TWO OF FUNCTIONAL SPECIFICATION
AND b.payment_status = 'U'
AND b.net_amount <> 0
AND scy.session_code < p_session_code
UNION
SELECT ss.session_code as sessionCode, s.stud_ref_no AS saasRef, s.forenames AS firstName, s.surname, TO_CHAR(s.dob,'DD/MM/YYYY') as dob, ca.campus_id as campusID, 
           CASE
          WHEN LENGTH (cy.hei_crse_code) = 5
          AND SUBSTR (cy.hei_crse_code, 5, 1) IN
                 ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
                  'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y',
                  'Z')                             -- does not end in a number
             THEN SUBSTR (cy.hei_crse_code, 1, 4)
          ELSE cy.hei_crse_code
       END crsecode,  
    scy.crse_name AS crseTitle,
       scy.crse_year_no AS crseYear, NVL(scy.repeat_year,'N') AS repeatYear, 
                       CASE
                    WHEN scy.application_status = 'C'
                        THEN 'Calculated'
                    WHEN scy.application_status = 'W' THEN 
                            CASE WHEN s.deceased_flag ='Y' THEN 'Deceased' ELSE 'Withdrawn' END
                    WHEN scy.application_status = 'A'
                        THEN 'NonAttendance'
                    WHEN scy.application_status = 'R'
                        THEN 'Rejected'
                    WHEN scy.application_status = 'N'
                        THEN 'New'
                    WHEN scy.application_status = 'T'
                        THEN 'Returned'                   
                    ELSE 'Unknown'
                END applicationStatus,
                NVL(AD.NO_TRACE, 'N') AS NoTrace,
                TO_CHAR(scy.withdraw_date,'DD/MM/YYYY') AS dateWithdrawn,
    CASE
    WHEN
        ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    END registrationConfirmed, 
    CASE
    WHEN  
        ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
      THEN 'Y'
    WHEN ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
        THEN 'N'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
        THEN 'Y'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
    THEN null
    END attendanceConfirmed, 
                CASE
                    WHEN s.suspend_payment = 'Y' OR s.stud_suspend = 'Y' OR ss.session_suspend = 'Y' OR scy.crse_suspend = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                END paymentSuspended, 
                sgas.pk_steps_reports.getFeePaymentDate(scy.stud_crse_year_id) AS feePayDate, 
                sgas.pk_steps_reports.getfeesAwarded(scy.stud_crse_year_id) AS feesAwarded, 
                sgas.pk_steps_reports.getFeesPayable(scy.stud_crse_year_id) AS feesPayable,
                sgas.pk_steps_reports.getFeePaidDate(scy.stud_crse_year_id) AS feesPaidDate,
                CONCAT('SAAS',s.scottish_cand) AS SLC, 
                ad.chngd_since_last_report as changed,
                                        CASE
                            WHEN (SELECT COUNT(*) FROM ATTENDANCE_DATA_RECEIVED
                                  WHERE STUD_REF_NO = scy.stud_ref_no
                                  AND DUPLICATE  = 'N'
                                  AND PROCESSED = 'N'
                                  AND SESSION_CODE = scy.session_code) > 0
                        THEN 'Y'
                        ELSE 'N'
                        END NotificationToBeProcessed,
                CASE
                    WHEN ad.restrict_payments_enrol IS NOT NULL
                        THEN TO_CHAR(ad.restrict_payments_enrol,'DD/MM/YYYY')
                    ELSE TO_CHAR(ad.restrict_payments_attend,'DD/MM/YYYY')
                END SupportRestrictDate,
                TO_CHAR(ad.restrict_fee_attend,'DD/MM/YYYY') AS FeeRestrictDate,
                TO_CHAR(ss.date_applic_received,'DD/MM/YYYY') AS DateAppnReceived,
                CASE
                    WHEN scy.paid_sandwich = 'Y' OR scy.unpaid_sandwich = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                    END PlacementYear,
                NVL(scy.study_abroad,'N') AS AbroadYear,
                TO_CHAR(SGAS.RULES_PROC_RECALC.GETSTUDYSTARTDATE(scy.stud_crse_year_id),'DD/MM/YYYY') AS CourseStartDate,
                scy.inst_code as instCode, scy.inst_name as instName, scy.stud_crse_year_id
FROM stud_crse_year scy, stud_session ss, crse c, campus ca, stud s, crse_year cy, attendance_data ad, award a, award_instalment ai
WHERE scy.stud_session_id = ss.stud_session_id
AND scy.stud_crse_year_id = a.stud_crse_year_id
AND ai.award_id = a.award_id
AND scy.stud_crse_year_id = ad.stud_crse_year_id
AND s.stud_ref_no = scy.stud_ref_no
AND scy.crse_year_id = cy.crse_year_id
AND scy.crse_id = c.crse_id
AND c.fees_campus = ca.campus_id
AND scy.inst_code = p_inst_code
AND scy.latest_crse_ind = 'Y' ---QUERY THREE OF FUNCTIONAL SPECIFICATION
AND scy.application_status = 'C'
AND ad.ongoing_required = 'Y'
AND ad.ongoing_attendance_confirmed = 'N'
AND ai.payment_status = 'S'
AND scy.session_code < p_session_code
UNION
SELECT ss.session_code as sessionCode, s.stud_ref_no AS saasRef, s.forenames AS firstName, s.surname, TO_CHAR(s.dob,'DD/MM/YYYY') as dob, ca.campus_id as campusID, 
           CASE
          WHEN LENGTH (cy.hei_crse_code) = 5
          AND SUBSTR (cy.hei_crse_code, 5, 1) IN
                 ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
                  'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y',
                  'Z')                             -- does not end in a number
             THEN SUBSTR (cy.hei_crse_code, 1, 4)
          ELSE cy.hei_crse_code
       END crsecode,  
    scy.crse_name AS crseTitle,
       scy.crse_year_no AS crseYear, NVL(scy.repeat_year,'N') AS repeatYear, 
                       CASE
                    WHEN scy.application_status = 'C'
                        THEN 'Calculated'
                    WHEN scy.application_status = 'W' THEN 
                            CASE WHEN s.deceased_flag ='Y' THEN 'Deceased' ELSE 'Withdrawn' END
                    WHEN scy.application_status = 'A'
                        THEN 'NonAttendance'
                    WHEN scy.application_status = 'R'
                        THEN 'Rejected'
                    WHEN scy.application_status = 'N'
                        THEN 'New'
                    WHEN scy.application_status = 'T'
                        THEN 'Returned'                   
                    ELSE 'Unknown'
                END applicationStatus,
                NVL(AD.NO_TRACE, 'N') AS NoTrace,
                TO_CHAR(scy.withdraw_date,'DD/MM/YYYY') AS dateWithdrawn,
    CASE
    WHEN
        ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    END registrationConfirmed, 
    CASE
    WHEN  
        ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
      THEN 'Y'
    WHEN ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
        THEN 'N'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
        THEN 'Y'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
    THEN null
    END attendanceConfirmed, 
                CASE
                    WHEN s.suspend_payment = 'Y' OR s.stud_suspend = 'Y' OR ss.session_suspend = 'Y' OR scy.crse_suspend = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                END paymentSuspended, 
                sgas.pk_steps_reports.getFeePaymentDate(scy.stud_crse_year_id) AS feePayDate, 
                sgas.pk_steps_reports.getfeesAwarded(scy.stud_crse_year_id) AS feesAwarded, 
                sgas.pk_steps_reports.getFeesPayable(scy.stud_crse_year_id) AS feesPayable,
                sgas.pk_steps_reports.getFeePaidDate(scy.stud_crse_year_id) AS feesPaidDate,
                CONCAT('SAAS',s.scottish_cand) AS SLC, 
                ad.chngd_since_last_report as changed,
                                        CASE
                            WHEN (SELECT COUNT(*) FROM ATTENDANCE_DATA_RECEIVED
                                  WHERE STUD_REF_NO = scy.stud_ref_no
                                  AND DUPLICATE  = 'N'
                                  AND PROCESSED = 'N'
                                  AND SESSION_CODE = scy.session_code) > 0
                        THEN 'Y'
                        ELSE 'N'
                        END NotificationToBeProcessed,
                CASE
                    WHEN ad.restrict_payments_enrol IS NOT NULL
                        THEN TO_CHAR(ad.restrict_payments_enrol,'DD/MM/YYYY')
                    ELSE TO_CHAR(ad.restrict_payments_attend,'DD/MM/YYYY')
                END SupportRestrictDate,
                TO_CHAR(ad.restrict_fee_attend,'DD/MM/YYYY') AS FeeRestrictDate,
                TO_CHAR(ss.date_applic_received,'DD/MM/YYYY') AS DateAppnReceived,
                CASE
                    WHEN scy.paid_sandwich = 'Y' OR scy.unpaid_sandwich = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                    END PlacementYear,
                NVL(scy.study_abroad,'N') AS AbroadYear,
                TO_CHAR(SGAS.RULES_PROC_RECALC.GETSTUDYSTARTDATE(scy.stud_crse_year_id),'DD/MM/YYYY') AS CourseStartDate,
                scy.inst_code as instCode, scy.inst_name as instName, scy.stud_crse_year_id
FROM stud_crse_year scy, stud_session ss, crse c, campus ca, stud s, crse_year cy, attendance_data ad, award a, award_instalment ai
WHERE scy.stud_session_id = ss.stud_session_id
AND scy.stud_crse_year_id = ad.stud_crse_year_id
AND scy.stud_crse_year_id = a.stud_crse_year_id
AND a.award_id = ai.award_id
AND s.stud_ref_no = scy.stud_ref_no
AND scy.crse_year_id = cy.crse_year_id
AND scy.crse_id = c.crse_id
AND c.fees_campus = ca.campus_id
AND scy.inst_code = p_inst_code
AND scy.latest_crse_ind = 'Y' ---QUERY FOUR OF FUNCTIONAL SPECIFICATION
AND scy.application_status = 'W'
AND ad.enrol_confirmed = 'N'            ---WITHDRAWL IS ONLY INTERESTED IN ENROLEMENT OUTSTANDING
AND ad.enrol_required = 'Y'
AND scy.session_code < p_session_code
AND ai.payment_status = 'S'
UNION
SELECT ss.session_code as sessionCode, s.stud_ref_no AS saasRef, s.forenames AS firstName, s.surname, TO_CHAR(s.dob,'DD/MM/YYYY') as dob, ca.campus_id as campusID, 
           CASE
          WHEN LENGTH (cy.hei_crse_code) = 5
          AND SUBSTR (cy.hei_crse_code, 5, 1) IN
                 ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
                  'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y',
                  'Z')                             -- does not end in a number
             THEN SUBSTR (cy.hei_crse_code, 1, 4)
          ELSE cy.hei_crse_code
       END crsecode,  
    scy.crse_name AS crseTitle,
       scy.crse_year_no AS crseYear, NVL(scy.repeat_year,'N') AS repeatYear, 
                       CASE
                    WHEN scy.application_status = 'C'
                        THEN 'Calculated'
                    WHEN scy.application_status = 'W' THEN 
                            CASE WHEN s.deceased_flag ='Y' THEN 'Deceased' ELSE 'Withdrawn' END
                    WHEN scy.application_status = 'A'
                        THEN 'NonAttendance'
                    WHEN scy.application_status = 'R'
                        THEN 'Rejected'
                    WHEN scy.application_status = 'N'
                        THEN 'New'
                    WHEN scy.application_status = 'T'
                        THEN 'Returned'                   
                    ELSE 'Unknown'
                END applicationStatus,
                NVL(AD.NO_TRACE, 'N') AS NoTrace,
                TO_CHAR(scy.withdraw_date,'DD/MM/YYYY') AS dateWithdrawn,
    CASE
    WHEN
        ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'Y' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'Y'
    THEN 'Y'
    WHEN ad.enrol_required = 'N' AND ad.enrol_confirmed = 'N'
    THEN 'N'
    END registrationConfirmed, 
    CASE
    WHEN  
        ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
      THEN 'Y'
    WHEN ad.ongoing_required = 'Y' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
        THEN 'N'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'Y'
        THEN 'Y'
    WHEN ad.ongoing_required = 'N' AND AD.ONGOING_ATTENDANCE_CONFIRMED = 'N'
    THEN null
    END attendanceConfirmed, 
                CASE
                    WHEN s.suspend_payment = 'Y' OR s.stud_suspend = 'Y' OR ss.session_suspend = 'Y' OR scy.crse_suspend = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                END paymentSuspended, 
                sgas.pk_steps_reports.getFeePaymentDate(scy.stud_crse_year_id) AS feePayDate, 
                sgas.pk_steps_reports.getfeesAwarded(scy.stud_crse_year_id) AS feesAwarded, 
                sgas.pk_steps_reports.getFeesPayable(scy.stud_crse_year_id) AS feesPayable,
                NULL AS feesPaidDate,   ---WILL ONLY SHOW OUTSTANDING RECOVERIES
                CONCAT('SAAS',s.scottish_cand) AS SLC, 
                ad.chngd_since_last_report as changed,
                                        CASE
                            WHEN (SELECT COUNT(*) FROM ATTENDANCE_DATA_RECEIVED
                                  WHERE STUD_REF_NO = scy.stud_ref_no
                                  AND DUPLICATE  = 'N'
                                  AND PROCESSED = 'N'
                                  AND SESSION_CODE = scy.session_code) > 0
                        THEN 'Y'
                        ELSE 'N'
                        END NotificationToBeProcessed,
                CASE
                    WHEN ad.restrict_payments_enrol IS NOT NULL
                        THEN TO_CHAR(ad.restrict_payments_enrol,'DD/MM/YYYY')
                    ELSE TO_CHAR(ad.restrict_payments_attend,'DD/MM/YYYY')
                END SupportRestrictDate,
                TO_CHAR(ad.restrict_fee_attend,'DD/MM/YYYY') AS FeeRestrictDate,
                TO_CHAR(ss.date_applic_received,'DD/MM/YYYY') AS DateAppnReceived,
                CASE
                    WHEN scy.paid_sandwich = 'Y' OR scy.unpaid_sandwich = 'Y'
                    THEN 'Y'
                    ELSE 'N'
                    END PlacementYear,
                NVL(scy.study_abroad,'N') AS AbroadYear,
                TO_CHAR(SGAS.RULES_PROC_RECALC.GETSTUDYSTARTDATE(scy.stud_crse_year_id),'DD/MM/YYYY') AS CourseStartDate,
                scy.inst_code as instCode, scy.inst_name as instName, scy.stud_crse_year_id
FROM stud_crse_year scy, stud_session ss, crse c, campus ca, stud s, crse_year cy, attendance_data ad, award a, award_instalment ai
WHERE scy.stud_session_id = ss.stud_session_id
AND scy.stud_crse_year_id = ad.stud_crse_year_id
AND scy.stud_crse_year_id = a.stud_crse_year_id
AND a.award_id = ai.award_id
AND s.stud_ref_no = scy.stud_ref_no
AND scy.crse_year_id = cy.crse_year_id
AND scy.crse_id = c.crse_id
AND c.fees_campus = ca.campus_id
AND scy.inst_code = p_inst_code
AND scy.latest_crse_ind = 'N' ---NEW ADDITION TO DEAL WITH CURRENT SESSION RECOVERIES NOT ON THE LATEST COURSE YOU RECORD.
AND scy.session_code = p_session_code
AND ai.payment_status = 'U'
AND a.award_src = 'T'
AND ai.net_amount < 0)
ORDER BY sessionCode asc;


END getFeeStatusReport2012;




PROCEDURE getFeePaymentReport (p_campus_id IN NUMBER, p_fee_payment_date IN VARCHAR2, p_fee_payment IN OUT fee_payment_cursor) 

IS
BEGIN
    OPEN p_fee_payment FOR
    
    SELECT
      ss.session_code,              --5
      s.stud_ref_no AS saasRef,     --6
      s.forenames AS firstName,     --7
      s.surname,                    --8
      TO_CHAR(s.dob,'DD/MM/YYYY'),                        --9
      pp.payee_ref_id AS campusID,     --10
CASE
          WHEN LENGTH (cy.hei_crse_code) = 5
          AND SUBSTR (cy.hei_crse_code, 5, 1) IN
                 ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
                  'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y',
                  'Z')                             -- does not end in a number
             THEN SUBSTR (cy.hei_crse_code, 1, 4)
          ELSE cy.hei_crse_code
       END as courseCode, --11
      scy.crse_name AS courseTitle, --12
      scy.crse_year_no AS courseYear,--13
      NVL(scy.repeat_year,'N') AS repeatYear, --14
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
      CONCAT('SAAS',s.scottish_cand) AS slfRef, --16
      TO_CHAR(pi.payment_date,'DD/MM/YYYY') AS feesPayDate, --17
      a.amount AS feesAwarded, --18
      ai.net_amount AS feesToBePaid, --19
      scy.inst_code, --20
      scy.inst_name  -- 21
                from stud_session ss, stud s, stud_crse_year scy, award a, award_instalment ai, payment_instalment pi, crse c, campus ca, payee_payment pp, crse_year cy
        where ss.stud_ref_no = s.stud_ref_no
        and ss.stud_session_id = scy.stud_session_id   
        and scy.stud_crse_year_id = a.stud_crse_year_id   
        and scy.crse_year_id = cy.crse_year_id
        and ai.award_id = a.award_id
        and a.award_src = 'T'
        and ai.award_instalment_id = pi.award_instalment_id
        and pp.payee_ref_id = p_campus_id
        and trunc(pp.payment_run_date) = TO_DATE(p_fee_payment_date, 'DD-MM-YYYY')
        AND scy.crse_id = c.crse_id
        AND c.fees_campus = ca.campus_id
        and pi.payee_payment_id = pp.payee_payment_id;

END getFeePaymentReport;


/* Formatted on 2011/07/20 09:39 (Formatter Plus v4.8.8) */
    PROCEDURE update_attendance_scheduled 
    IS
    
       l_valid_date               DATE;
       l_no_days_ongoing_attend   NUMBER;


        ----WE NEED TO SELECT ALL CALCULATED, NEW AND RETURNED CASES
       CURSOR c_attend_data_update
       IS
          SELECT a.stud_crse_year_id
            FROM stud_crse_year a, attendance_data b
           WHERE a.stud_crse_year_id = b.stud_crse_year_id
           AND (a.APPLICATION_STATUS = 'C' OR a.APPLICATION_STATUS = 'N' OR APPLICATION_STATUS = 'T')
             AND b.ongoing_attendance_confirmed = 'N';
             
             
       v_attend_data_update       c_attend_data_update%ROWTYPE;
    BEGIN
    
        ---THIS SELECTS THE NUMBER OF DAYS
      SELECT nval
        INTO l_no_days_ongoing_attend
        FROM config_data
              WHERE item_name = 'NO_DAYS_ONGOING_ATTEND';

       OPEN c_attend_data_update;

       LOOP
          FETCH c_attend_data_update
           INTO v_attend_data_update;

          EXIT WHEN c_attend_data_update%NOTFOUND;


            ---FUNCTION CALLED TO GET THE START DATE OF THE COURSE.  THIS HAS TO BE NVLd as some courses maybe not be set up.  
          SELECT NVL(sgas.rules_proc_recalc.getstartdateterm(v_attend_data_update.stud_crse_year_id,1),TO_DATE ('01/01/9999', 'DD/MM/YYYY'))
          INTO l_valid_date
          FROM DUAL;

                        ----FIRST CONDITION WE NEED TO SET ONGOING REQUIRED = 'Y'
                     IF l_valid_date <= (SYSDATE - l_no_days_ongoing_attend)
                     THEN
                     
                        UPDATE attendance_data
                            SET chngd_since_last_report = 'Y'
                            WHERE ongoing_required = 'N'
                            AND stud_crse_year_id = v_attend_data_update.stud_crse_year_id;
                     
                        UPDATE attendance_data
                           SET ongoing_required = 'Y'
                         WHERE stud_crse_year_id = v_attend_data_update.stud_crse_year_id;
                         
                     ELSE
                            ---ONGOING REQUIRED SET TO 'N'.  NOTE IF COURSE NOT SET UP IT WILL TAKE THIS ROUTE DUE TO DATE IN FUTURE!
                            UPDATE attendance_data
                            SET chngd_since_last_report = 'Y'
                            WHERE ongoing_required = 'Y'
                            AND stud_crse_year_id = v_attend_data_update.stud_crse_year_id;
                     
                        UPDATE attendance_data
                           SET ongoing_required = 'N'
                         WHERE stud_crse_year_id = v_attend_data_update.stud_crse_year_id;
                         
                     END IF;

       END LOOP;

       CLOSE c_attend_data_update;
    END update_attendance_scheduled;
    
  /* Formatted on 22/07/2014 13:10:10 (QP5 v5.215.12089.38647) */
/* Formatted on 22/07/2014 13:11:33 (QP5 v5.215.12089.38647) */
PROCEDURE getDailyStats (p_session_code                IN     NUMBER,
                         p_enter_number_of_days_back   IN     NUMBER,
                         p_enter_days_back_minus_one   IN     NUMBER,
                         p_stats_curs                     OUT stats_cursor)
AS
   stats_curs   stats_cursor;
BEGIN
   OPEN stats_curs FOR
      -----SELECT QUERY TO RETURN THE RESULTS FOR THE DAILY STATS
      SELECT (SELECT COUNT (*)
                FROM process_instance_data pid
               WHERE     pid.PROCESS_BPM = 'StudentApplicationBPM'
                     AND pid.DATE_APP_RECEIVED >=
                            TRUNC (SYSDATE - (p_enter_number_of_days_back))
                     AND pid.DATE_APP_RECEIVED <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one))
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION'))
                AS UG_RECEIVED,
               (SELECT COUNT (*)
                  FROM STUD_CRSE_YEAR a, process_instance_data pid
                 WHERE     a.SESSION_CODE =
                              (SELECT cval
                                 FROM config_data
                                WHERE item_name = 'CURRENT_SESSION')
                       AND LATEST_CRSE_IND = 'Y'
                       AND a.stud_ref_no = pid.stud_ref_no
                       AND pid.complete_date IS NULL
                       AND pid.stud_ref_no = a.stud_ref_no
                       AND pid.session_code = a.session_code
                       AND pid.PROCESS_BPM = 'StudentApplicationBPM'
                       AND pid.complete_date IS NULL
                       AND a.first_calc_date >=
                              TRUNC (SYSDATE - (p_enter_number_of_days_back))
                       AND a.first_calc_date <
                              TRUNC (SYSDATE - (p_enter_days_back_minus_one)))
             + (SELECT COUNT (*)
                  FROM STUD_CRSE_YEAR a, process_instance_data pid
                 WHERE     a.SESSION_CODE =
                              (SELECT cval
                                 FROM config_data
                                WHERE item_name = 'CURRENT_SESSION')
                       AND LATEST_CRSE_IND = 'Y'
                       AND a.stud_ref_no = pid.stud_ref_no
                       AND (pid.complete_date - a.first_calc_date) > 1
                       AND pid.stud_ref_no = a.stud_ref_no
                       AND pid.session_code = a.session_code
                       AND pid.PROCESS_BPM = 'StudentApplicationBPM'
                       AND a.first_calc_date >=
                              TRUNC (SYSDATE - (p_enter_number_of_days_back))
                       AND a.first_calc_date <
                              TRUNC (SYSDATE - (p_enter_days_back_minus_one)))
                AS UG_IN_QA,   ----POSSIBLY JOIN ONTO THE STUD TO GET QA_COUNT
             (SELECT COUNT (*)
                FROM STUD_CRSE_YEAR a, process_instance_data pid
               WHERE     a.SESSION_CODE =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND LATEST_CRSE_IND = 'Y'
                     AND pid.stud_ref_no = a.stud_ref_no
                     AND pid.session_code = a.session_code
                     AND pid.PROCESS_BPM = 'StudentApplicationBPM'
                     AND a.first_calc_date >=
                            TRUNC (SYSDATE - (p_enter_number_of_days_back))
                     AND a.first_calc_date <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one)))
                AS UG_PROCESSED,
             (SELECT COUNT (*)
                FROM process_instance_data pid
               WHERE     pid.PROCESS_BPM = 'StudentApplicationBPM'
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND PID.DATE_APP_RECEIVED >=
                            TRUNC (SYSDATE - (p_enter_number_of_days_back))
                     AND pid.DATE_APP_RECEIVED <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one))
                     AND pid.AUTO_CALC = 'Y')
                AS UG_AUTO_CALCULATED,
             (SELECT   (SELECT COUNT (*)
                          FROM STUD_CRSE_YEAR a, process_instance_data pid
                         WHERE     a.SESSION_CODE =
                                      (SELECT cval
                                         FROM config_data
                                        WHERE item_name = 'CURRENT_SESSION')
                               AND LATEST_CRSE_IND = 'Y'
                               AND pid.stud_ref_no = a.stud_ref_no
                               AND pid.session_code = a.session_code
                               AND pid.PROCESS_BPM = 'StudentApplicationBPM'
                               AND a.first_calc_date >=
                                      TRUNC (
                                           SYSDATE
                                         - (p_enter_number_of_days_back))
                               AND a.first_calc_date <
                                      TRUNC (
                                           SYSDATE
                                         - (p_enter_days_back_minus_one)))
                     - (SELECT COUNT (*)
                          FROM process_instance_data pid
                         WHERE     pid.PROCESS_BPM = 'StudentApplicationBPM'
                               AND pid.session_code =
                                      (SELECT cval
                                         FROM config_data
                                        WHERE item_name = 'CURRENT_SESSION')
                               AND pid.COMPLETE_DATE >=
                                      TRUNC (
                                           SYSDATE
                                         - (p_enter_number_of_days_back))
                               AND pid.COMPLETE_DATE <
                                      TRUNC (
                                           SYSDATE
                                         - (p_enter_days_back_minus_one))
                               AND pid.AUTO_CALC = 'Y')
                FROM DUAL)
                AS USER_CALCULATED,
             (SELECT COUNT (*)
                FROM process_instance_data pid
               WHERE     pid.DATE_APP_RECEIVED <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one))
                     AND pid.PROCESS_BPM = 'StudentApplicationBPM'
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION'))
                AS UG_TOTAL_RECIEVED,
             (SELECT COUNT (*)
                FROM PROCESS_INSTANCE_DATA pid
               WHERE     pid.complete_date <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one))
                     AND pid.PROCESS_BPM = 'StudentApplicationBPM'
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION'))
                AS UG_PROCESSED_TOTAL,
             (SELECT COUNT (*)
                FROM PROCESS_INSTANCE_DATA pid
               WHERE     PID.DATE_APP_RECEIVED <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one))
                     AND pid.PROCESS_BPM = 'StudentApplicationBPM'
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND auto_calc = 'Y')
                AS UG_AUTO_CALC_TOTAL,
             (SELECT   (SELECT COUNT (*)
                          FROM process_instance_data pid
                         WHERE     pid.PROCESS_BPM = 'StudentApplicationBPM'
                               AND pid.session_code =
                                      (SELECT cval
                                         FROM config_data
                                        WHERE item_name = 'CURRENT_SESSION')
                               AND pid.COMPLETE_DATE <
                                      TRUNC (
                                           SYSDATE
                                         - (p_enter_days_back_minus_one)))
                     - (SELECT COUNT (*)
                          FROM process_instance_data pid
                         WHERE     pid.PROCESS_BPM = 'StudentApplicationBPM'
                               AND pid.session_code =
                                      (SELECT cval
                                         FROM config_data
                                        WHERE item_name = 'CURRENT_SESSION')
                               AND pid.COMPLETE_DATE <
                                      TRUNC (
                                           SYSDATE
                                         - (p_enter_days_back_minus_one))
                               AND AUTO_CALC = 'Y')
                FROM DUAL)
                AS USER_CALCULATED_TOTAL,
             (SELECT COUNT (*)
                FROM process_instance_data pid
               WHERE     pid.PROCESS_BPM = 'NMSBStudentApplicationBPM'
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND pid.DATE_APP_RECEIVED >=
                            TRUNC (SYSDATE - (p_enter_number_of_days_back))
                     AND pid.DATE_APP_RECEIVED <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one)))
                AS NMSB_RECEIVED,
             (SELECT COUNT (*)
                FROM process_instance_data pid
               WHERE     pid.PROCESS_BPM = 'NMSBStudentApplicationBPM'
                     AND pid.COMPLETE_DATE >=
                            TRUNC (SYSDATE - (p_enter_number_of_days_back))
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND pid.COMPLETE_DATE <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one)))
                AS NMSB_PROCESSED,
             (SELECT COUNT (*)
                FROM process_instance_data pid
               WHERE     pid.DATE_APP_RECEIVED <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one))
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND pid.PROCESS_BPM = 'NMSBStudentApplicationBPM')
                AS NMSB_TOTAL_RECIEVED,
             (SELECT COUNT (*)
                FROM PROCESS_INSTANCE_DATA pid
               WHERE     pid.complete_date <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one))
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND pid.PROCESS_BPM = 'NMSBStudentApplicationBPM')
                AS NMSB_PROCESSED_TOTAL,
              (SELECT COUNT (*)
                FROM process_instance_data pid
               WHERE     pid.PROCESS_BPM = 'NMSBStudentApplicationBPM'
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND PID.DATE_APP_RECEIVED >=
                            TRUNC (SYSDATE - (p_enter_number_of_days_back))
                     AND pid.DATE_APP_RECEIVED <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one))
                     AND pid.AUTO_CALC = 'Y') 
              AS NMSB_AUTO_CALCULATED,
             (SELECT COUNT (*)
                FROM PROCESS_INSTANCE_DATA pid
               WHERE     pid.DATE_APP_RECEIVED <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one))
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND pid.PROCESS_BPM IN
                            ('NMSBStudentApplicationBPM',
                             'StudentApplicationBPM'))
                AS ALL_TOTAL_REC,
             (SELECT COUNT (*)
                FROM PROCESS_INSTANCE_DATA pid
               WHERE     pid.complete_date <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one))
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND pid.PROCESS_BPM IN
                            ('NMSBStudentApplicationBPM',
                             'StudentApplicationBPM'))
                AS ALL_TOTAL_PROC,
             (SELECT COUNT (*)
                FROM process_instance_data pid
               WHERE     pid.PROCESS_BPM = 'CorrespondenceBPM'
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND pid.CREATION_DATE >=
                            TRUNC (SYSDATE - (p_enter_number_of_days_back))
                     AND pid.CREATION_DATE <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one)))
                AS CORRESS_RECEIVED,
             (SELECT COUNT (*)
                FROM process_instance_data pid
               WHERE     pid.PROCESS_BPM = 'CorrespondenceBPM'
                     AND pid.COMPLETE_DATE >=
                            TRUNC (SYSDATE - (p_enter_number_of_days_back))
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND pid.COMPLETE_DATE <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one)))
                AS CORRESS_PROCESSED,
             (SELECT COUNT (*)
                FROM PROCESS_INSTANCE_DATA pid
               WHERE     pid.CREATION_DATE <=
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one))
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND pid.PROCESS_BPM = 'CorrespondenceBPM')
                AS ALL_CORR_REC_TOTAL,
             (SELECT COUNT (*)
                FROM PROCESS_INSTANCE_DATA pid
               WHERE     pid.complete_date <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one))
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND pid.PROCESS_BPM = 'CorrespondenceBPM')
                AS ALL_CORESS_PROC_TOTAL,
             (SELECT COUNT (*)
                FROM process_instance_data pid
               WHERE     pid.PROCESS_BPM = 'AttendanceDataBPM'
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND pid.CREATION_DATE >=
                            TRUNC (SYSDATE - (p_enter_number_of_days_back))
                     AND pid.CREATION_DATE <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one)))
                AS ATTEND_RECEIVED,
             (SELECT COUNT (*)
                FROM process_instance_data pid
               WHERE     pid.PROCESS_BPM = 'AttendanceDataBPM'
                     AND pid.COMPLETE_DATE >=
                            TRUNC (SYSDATE - (p_enter_number_of_days_back))
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND pid.COMPLETE_DATE <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one)))
                AS ATTEND_PROCESSED,
             (SELECT COUNT (*)
                FROM process_instance_data pid
               WHERE     pid.PROCESS_BPM = 'AttendanceDataBPM'
                     AND (pid.COMPLETE_DATE - pid.CREATION_DATE) <= 0.003472
                     AND pid.COMPLETE_DATE >=
                            TRUNC (SYSDATE - (p_enter_number_of_days_back))
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND pid.COMPLETE_DATE <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one)))
                AS ATTEND_AUTO_CALC,
             (SELECT COUNT (*)
                FROM process_instance_data pid
               WHERE     pid.PROCESS_BPM = 'AttendanceDataBPM'
                     AND (pid.COMPLETE_DATE - pid.CREATION_DATE) > 0.003472
                     AND pid.COMPLETE_DATE >=
                            TRUNC (SYSDATE - (p_enter_number_of_days_back))
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND pid.COMPLETE_DATE <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one)))
                AS ATTEND_USER_CALC,
             (SELECT COUNT (*)
                FROM PROCESS_INSTANCE_DATA pid
               WHERE     pid.CREATION_DATE <=
                            TRUNC (SYSDATE - (p_enter_number_of_days_back))
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND pid.PROCESS_BPM = 'AttendanceDataBPM')
                AS ALL_ATTEND__REC_TOTAL,
             (SELECT COUNT (*)
                FROM PROCESS_INSTANCE_DATA pid
               WHERE     pid.complete_date <
                            TRUNC (SYSDATE - (p_enter_days_back_minus_one))
                     AND pid.PROCESS_BPM = 'AttendanceDataBPM'
                     AND pid.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION'))
                AS ATTEND_PROC_OVERALL_TOTAL,
             '=IF(ISERROR(INDIRECT("R[-1]",0)+INDIRECT("C[-4]",0)),0,INDIRECT("R[-1]",0)+INDIRECT("C[-4]",0))' AS ATTEND_AUTO_TOTAL,
             --ONE ROV UP + FOUR COLUMNS TO LEFT
             '=IF(ISERROR(INDIRECT("R[-1]",0)+INDIRECT("C[-4]",0)),0,INDIRECT("R[-1]",0)+INDIRECT("C[-4]",0))' AS ATTEND_USER_TOTAL,
             --ONE ROV UP + FOUR COLUMNS TO LEFT
             '=IF(ISERROR(INDIRECT("RC[1]",0)-INDIRECT("R[-1]C[1]",0)),0,INDIRECT("RC[1]",0)-INDIRECT("R[-1]C[1]",0))' AS MANUAL_APP_RECEIVED, --FORMULA IN EXCEL SPREADSHEET WILL GO HERE
             --COLUMN TO THE RIGHT - ONE ROW UP ONE COLUMN RIGHT
             (SELECT COUNT (DISTINCT stud_ref_no)
                FROM stud_crse_year a
               WHERE     a.web_submitted IS NULL
                     AND a.session_code =
                            (SELECT cval
                               FROM config_data
                              WHERE item_name = 'CURRENT_SESSION')
                     AND NOT EXISTS
                                (  SELECT b.stud_ref_no
                                     FROM stud_crse_year b
                                    WHERE     A.STUD_REF_NO = B.STUD_REF_NO
                                          AND b.session_code =
                                                 (SELECT cval
                                                    FROM config_data
                                                   WHERE item_name =
                                                            'CURRENT_SESSION')
                                                    GROUP BY b.stud_ref_no
                                                    HAVING COUNT (*) > 1))  AS MANUAL_TOTAL_RECEIVED
        FROM DUAL;

   p_stats_curs := stats_curs;
END getDailyStats;


PROCEDURE getTaskData(p_stats_curs OUT stats_cursor)  -- 2nd block of SQL code
AS

  stats_curs stats_cursor;
  
BEGIN
 
 open stats_curs for
 
 SELECT FORENAME, SURNAME, USERNAME, TEAM, APPLICATIONS, NMSB_APPS, TRAVEL, GENERAL_CORRES, MANUAL_REG, CHANGE_DETAILS, EMAILS, CALLS, OVERALL_TOTAL FROM(
 select b.forename, b.surname, a.username, b.team AS TEAM, SUM(a.applications) AS APPLICATIONS, SUM(a.nmsb_apps) AS NMSB_APPS, SUM(a.travel) AS TRAVEL, 
 SUM(a.general_corres) AS GENERAL_CORRES, SUM(a.manual_reg) AS MANUAL_REG, 
 SUM(a.change_details) AS CHANGE_DETAILS, SUM(a.emails) AS EMAILS, SUM(a.calls) AS CALLS, 
 SUM(a.applications + a.nmsb_apps + a.travel + a.general_corres + a.manual_reg + a.change_details + a.emails + a.calls) AS OVERALL_TOTAL
 from employee_activity a, employee b
 where a.username = b.username
 and TRUNC(a.activity_date) = TRUNC(sysdate - 1)
 GROUP BY b.forename, b.surname, a.username, b.team)
 ORDER BY OVERALL_TOTAL DESC;

 p_stats_curs := stats_curs;

END getTaskData;

PROCEDURE getTeamActivity(p_stats_curs OUT stats_cursor) -- 3rd block of SQL code
AS

 stats_curs stats_cursor;
 
 BEGIN
 
  open stats_curs for
  
  SELECT TEAM, ACTIVITY_DATE, APPLICATIONS, NMSB_APPS, TRAVEL, GENERAL_CORRES, MANUAL_REG, CHANGE_DETAILS, EMAILS, CALLS, OVERALL_TOTAL FROM(
  select b.team AS TEAM, a.activity_date AS ACTIVITY_DATE, SUM(a.applications) AS APPLICATIONS, SUM(a.nmsb_apps) AS NMSB_APPS, SUM(a.travel) AS TRAVEL, 
  SUM(a.general_corres) AS GENERAL_CORRES, SUM(a.manual_reg) AS MANUAL_REG, 
  SUM(a.change_details) AS CHANGE_DETAILS, SUM(a.emails) AS EMAILS, SUM(a.calls) AS CALLS, 
  SUM(a.applications + a.nmsb_apps + a.travel + a.general_corres + a.manual_reg + a.change_details + a.emails + a.calls) AS OVERALL_TOTAL
  from employee_activity a, employee b
   where a.username = b.username
   GROUP BY b.team, a.activity_date)
  ORDER BY activity_date, team, overall_total DESC; 
 
 
 
   p_stats_curs := stats_curs;
 
 END getTeamActivity;

 PROCEDURE getUserData(p_enter_days_back IN NUMBER, p_stats_curs OUT stats_cursor)
 AS
  stats_curs stats_cursor;
  
 BEGIN
 
  open stats_curs for
  SELECT FORENAME, SURNAME, USERNAME, APPLICATIONS, NMSB_APPS, TRAVEL, GENERAL_CORRES, MANUAL_REG, CHANGE_DETAILS, EMAILS, CALLS, OVERALL_TOTAL FROM(
  select b.forename, b.surname, a.username, SUM(a.applications) AS APPLICATIONS, SUM(a.nmsb_apps) AS NMSB_APPS, SUM(a.travel) AS TRAVEL, 
  SUM(a.general_corres) AS GENERAL_CORRES, SUM(a.manual_reg) AS MANUAL_REG, 
  SUM(a.change_details) AS CHANGE_DETAILS, SUM(a.emails) AS EMAILS, SUM(a.calls) AS CALLS, 
  SUM(a.applications + a.nmsb_apps + a.travel + a.general_corres + a.manual_reg + a.change_details + a.emails + a.calls) AS OVERALL_TOTAL
  from employee_activity a, employee b
   where a.username = b.username
   AND TRUNC(a.activity_date) = TRUNC(sysdate - (p_enter_days_back))
   GROUP BY b.forename, b.surname, a.username)
   ORDER BY OVERALL_TOTAL DESC;
  
  p_stats_curs := stats_curs;
 
 END  getUserData;

END PK_STEPS_REPORTS;
/