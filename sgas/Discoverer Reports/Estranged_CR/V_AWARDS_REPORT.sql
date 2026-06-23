--DROP VIEW SGAS.V_AWARDS_REPORT;

/* Formatted on 12/12/2017 18:33:31 (QP5 v5.215.12089.38647) */
CREATE OR REPLACE FORCE VIEW SGAS.V_AWARDS_REPORT
(
   STUD_CRSE_YEAR_ID,
   STUD_REF_NO,
   SESSION_CODE,
   FEES,
   CESB,
   ISB,
   YSB,
   UGLOAN,
   UGOA,
   UGDA,
   UGDSA,
   PGLOAN,
   SNB,
   SNCAP,
   SNDA,
   SNIE,
   SNSPA,
   TFEL,
   OTHER_AWARD_TYPE
)
AS
   SELECT x."STUD_CRSE_YEAR_ID",
          x."STUD_REF_NO",
          x."SESSION_CODE",
          x."FEES",
          x."CESB",
          x."ISB",
          x."YSB",
          x."UGLOAN",
          x."UGOA",
          x."UGDA",
          x."UGDSA",
          x."PGLOAN",
          x."SNB",
          x."SNCAP",
          x."SNDA",
          x."SNIE",
          x."SNSPA",
          x."TFEL",
          (  SELECT RTRIM (
                       XMLAGG (XMLELEMENT (e, a1.stud_award_type || ',')).EXTRACT (
                          '//text()'),
                       ',')
                       other_award_type
               FROM award a1
              WHERE     a1.STUD_CRSE_YEAR_ID = x.STUD_CRSE_YEAR_ID
                    AND a1.stud_award_type NOT IN
                           ('FEES',
                            'CESB',
                            'ISB',
                            'YSB',
                            'UGLOAN',
                            'UGOA',
                            'UGDA',
                            'UGDSA',
                            'PGLOAN',
                            'SNB',
                            'SNCAP',
                            'SNDA',
                            'SNIE',
                            'SNSPA',
                            'TFEL')
           GROUP BY a1.STUD_CRSE_YEAR_ID)
             other_award_type
     FROM (SELECT SCY.STUD_CRSE_YEAR_ID,
                  SCY.STUD_REF_NO,
                  SCY.SESSION_CODE,
                  a.stud_award_type
             FROM award a, stud_crse_year scy, stud_session ss
            WHERE     A.STUD_CRSE_YEAR_ID = SCY.STUD_CRSE_YEAR_ID
                  AND SCY.LATEST_CRSE_IND = 'Y'
                  AND SCY.STUD_SESSION_ID = SS.STUD_SESSION_ID) PIVOT (COUNT (
                                                                          stud_award_type)
                                                                FOR stud_award_type
                                                                IN  ('FEES' AS FEES, -- AS "TUITION FEE",
                                                                    'CESB' AS CESB, -- AS "CARE EXP STUDENT BURSARY",
                                                                    'ISB' AS ISB, -- AS "INDEPENDENT STUDENTS BURSARY",
                                                                    'YSB' AS YSB, -- AS "YOUNG STUDENTS BURSARY",
                                                                    'UGLOAN' AS UGLOAN, -- AS "STUDENT LOAN POST LOAN 16",
                                                                    'UGOA' AS UGOA, -- AS "LONE PARENT GRANT",
                                                                    'UGDA' AS UGDA, -- AS "UG DEPENDANTS GRANT",
                                                                    'UGDSA' AS UGDSA, -- AS "UG DISABLED STUDENTS GRANT",
                                                                    'PGLOAN' AS PGLOAN, -- AS "STUDENT LOAN",
                                                                    'SNB' AS SNB, -- AS "STUDENT NURSES BURSARY",
                                                                    'SNCAP' AS SNCAP, -- AS "NURS - MW CHILDCARE ALLOWANCE", --"NURSING AND MIDWIFERY STUDENT CHILDCARE ALLOWANCE FOR PARENTS",
                                                                    'SNDA' AS SNDA, -- AS "DEPENDANTS ALLOWANCE",
                                                                    'SNIE' AS SNIE, -- AS "INITIAL EXPENSES",
                                                                    'SNSPA' AS SNSPA, -- AS "LONE PARENT ALLOWANCE",
                                                                    'TFEL' AS TFEL -- AS "TUITION FEE LOAN"
                                                                                  )) x;
