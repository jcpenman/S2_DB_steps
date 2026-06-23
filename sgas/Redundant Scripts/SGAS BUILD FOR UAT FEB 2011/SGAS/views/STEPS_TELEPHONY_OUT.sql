-- STEPS_TELEPHONY_OUT.sql
-- Description: dbView to select all data required in the file passed to telephony
-- Author R.Hunter (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      18.11.09    R.Hunter (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date: $
-- $Revision: $

DROP VIEW STEPS_TELEPHONY_OUT
/

--
-- STEPS_TELEPHONY_OUT (View) 
--
CREATE OR REPLACE VIEW STEPS_TELEPHONY_OUT
(TELEPHONY_RECS)
AS 
(SELECT 'Student Forenames|Student Initials|Student Surname|Student Reference Number|Date of Birth|National Insurance Number|Date Last Calculated|Date Last Award Letter Issued|Home House Name/Number|Home Address Line 1|Home Address Line 2|Home Address Line 3|Home Address Line 4|Home Post Code|Term House Name/Number|Term Address Line 1|Term Address Line 2|Term Address Line 3|Term Address Line 4|Term Post Code|Team|Application Status|Application Status Date|Travel Progress Status|Travel Progress Date|Duplicate LOA status|Duplicate LOA Session|Main Phone Number|Email Address|Mobile Number|Record Status'
                                                               telephony_recs
  FROM DUAL
UNION ALL
SELECT    INITCAP (a.forenames)
       || '|'
       || INITCAP (a.initials)
       || '|'
       || INITCAP (a.surname)
       || '|'
       || a.stud_ref_no
       || '|'
       || a.dob
       || '|'
       || a.ni_no
       || '|'
       || b.auto_calc_date
       || '|'
       || b.sal_sent_date
       || '|'
       || INITCAP (e.house_no_name)
       || '|'
       || INITCAP (e.addr_l1)
       || '|'
       || INITCAP (e.addr_l2)
       || '|'
       || INITCAP (e.addr_l3)
       || '|'
       || INITCAP (e.addr_l4)
       || '|'
       || e.post_code
       || '|'
       || INITCAP (f.house_no_name)
       || '|'
       || INITCAP (f.addr_l1)
       || '|'
       || INITCAP (f.addr_l2)
       || '|'
       || INITCAP (f.addr_l3)
       || '|'
       || INITCAP (f.addr_l4)
       || '|'
       || f.post_code
       || '|'
       || e.tele_no
       || '|'
       || a.email_addr
       || '|'
       || a.mobile_tel_no
       || '|'
       || CASE
             WHEN (    b.scheme_type = 'U'
                   AND g.qual_type = 'HEALTH'
                   AND g.pams_course = 'Y'
                  )
                THEN 'TEAM_VII'
             WHEN (b.scheme_type = 'P')
                THEN 'PSAS'
             WHEN (b.scheme_type = 'B')
                THEN 'SNB'
             WHEN (b.scheme_type = 'S')
                THEN 'SSS'
             ELSE (SELECT NAME
                     FROM team@grass x, inst_team@grass y
                    WHERE x.team_id = y.team_id
                      AND y.inst_code = b.inst_code
                      AND b.scheme_type <> 'U'
                      AND g.qual_type <> 'HEALTH'
                      AND g.pams_course <> 'Y')
          END
       || '|'
       || d.case_status
       || '|'
       || CASE (d.case_status)
             WHEN 'R'
                THEN d.date_registered
             WHEN 'W'
                THEN d.date_registered
             WHEN 'C'
                THEN d.date_calculated
             WHEN 'L'
                THEN d.award_letter_sent_date
             WHEN 'S'
                THEN d.slc_sent_date
             WHEN 'U'
                THEN d.date_calculated
          END
       || '|'
       || 'P'
       || '|'
       || NULL
       || '|'
       || CASE
             WHEN (   b.sal_sent IS NULL
                   OR d.case_status = 'P'
                   OR d.case_status = 'R'
                   OR d.case_status = 'W'
                  )
                THEN 'P'
             WHEN (d.award_letter_sent_date >
                          (SYSDATE - (SELECT nval
                                        FROM config_data
                                       WHERE item_name = 'AWARD_LETTER_DAYS')
                          )
                  )
                THEN 'R'
             WHEN (d.dup_award_letter >=
                                (SELECT nval
                                   FROM config_data
                                  WHERE item_name LIKE 'MAX_AWARD_LETTER_REQ')
                  )
                THEN 'L'
             ELSE 'S'
          END
       || '|'
       || b.session_code
       || '|'
       || c.rec_status
  FROM stud a,
       stud_crse_year b,
       telephony c,
       stud_app_prog d,
       stud_home_addr e,
       stud_term_addr f,
       crse g
 WHERE a.stud_ref_no = b.stud_ref_no
   AND b.latest_crse_ind = 'Y'
   AND a.stud_ref_no = c.stud_ref_no(+)
   AND a.stud_ref_no = d.stud_ref_no(+)
   AND a.stud_ref_no = e.stud_ref_no(+)
   AND a.stud_ref_no = f.stud_ref_no(+)
   AND b.crse_id = g.crse_id(+))
/

