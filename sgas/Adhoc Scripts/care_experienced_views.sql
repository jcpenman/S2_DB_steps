DROP VIEW V_CARE_EXPERIENCED_APPS_REPORT;

CREATE OR REPLACE FORCE VIEW V_CARE_EXPERIENCED_APPS_REPORT
(
   SOURCE,
   STUD_REF_NO,
   APPLICATION_ID,
   DATE_APPLICATION_RECEIVED,
   SESSION_CODE,
   DOB,
   INST_CODE,
   INST_NAME,
   CRSE_CODE,
   CRSE_NAME,
   CRSE_YEAR_NO,
   CARE_EXPERIENCED_OLS,
   ACCOMODATION_GRANT,
   CARE_EXPERIENCED_STEPS,
   NATION_COUNTRY_CODE,
   NATION_COUNTRY,
   BIRTH_COUNTRY_CODE,
   BIRTH_COUNTRY,
   APPLICATION_STATUS,
   CREATED_DATE,
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
   OTHER_AWARD_TYPE,
   TASK_DETAILS
)
AS
   SELECT c.SOURCE,
          c.STUD_REF_NO,
          NVL (o.APPLICATION_ID, c.APPLICATION_ID) APPLICATION_ID,
          NVL (o.DATE_APPLICATION_RECEIVED, c.DATE_APPLICATION_RECEIVED)
             DATE_APPLICATION_RECEIVED,
          c.SESSION_CODE,
          c.DOB,
          c.INST_CODE,
          c.INST_NAME,
          c.CRSE_CODE,
          c.CRSE_NAME,
          c.CRSE_YEAR_NO,
          o.CARE_EXPERIENCED_OLS,
          o.ACCOMODATION_GRANT,
          c.CARE_EXPERIENCED_STEPS,
          c.NATION_COUNTRY_CODE,
          c.NATION_COUNTRY,
          c.BIRTH_COUNTRY_CODE,
          c.BIRTH_COUNTRY,
          c.APPLICATION_STATUS,
          c.CREATED_DATE,
          c.FEES,
          c.CESB,
          c.ISB,
          c.YSB,
          c.UGLOAN,
          c.UGOA,
          c.UGDA,
          c.UGDSA,
          c.PGLOAN,
          c.SNB,
          c.SNCAP,
          c.SNDA,
          c.SNIE,
          c.SNSPA,
          c.TFEL,
          c.OTHER_AWARD_TYPE,
          (SELECT RTRIM (
                     XMLAGG (
                        XMLELEMENT (
                           e,
                           p.process_bpm || '(' || ref_table_assigned_to.itemname || ')' || ',')).EXTRACT (
                        '//text()'),
                     ',')
                     tasks
             FROM process_instance_data p,
                  t_task@wmsteps.world tt,
                  tblthingname@wmsteps.world ref_table_assigned_to                                   
            WHERE     c.stud_ref_no = p.stud_ref_no
                  AND c.session_code = p.session_code
                  and P.PROCESS_ID = tt.prt_process_instance_id
                  and tt.assigned_to = ref_table_assigned_to.idthing(+)
                  AND tt.status <> 3)
             TASK_DETAILS
     FROM CARE_EXPERIENCED_APPS_REPORT c, CARE_EXPERIENCED_APPS_REPORT o
    WHERE     C.SOURCE = 'STEPS'
          AND C.STUD_REF_NO = o.STUD_REF_NO(+)
          AND C.SESSION_CODE = o.SESSION_CODE(+)
          AND 'OLS' = O.SOURCE(+)
   UNION ALL
   SELECT SOURCE,
          STUD_REF_NO,
          APPLICATION_ID,
          DATE_APPLICATION_RECEIVED,
          SESSION_CODE,
          DOB,
          INST_CODE,
          INST_NAME,
          CRSE_CODE,
          CRSE_NAME,
          CRSE_YEAR_NO,
          CARE_EXPERIENCED_OLS,
          ACCOMODATION_GRANT,
          CARE_EXPERIENCED_STEPS,
          NATION_COUNTRY_CODE,
          NATION_COUNTRY,
          BIRTH_COUNTRY_CODE,
          BIRTH_COUNTRY,
          APPLICATION_STATUS,
          CREATED_DATE,
          NULL FEES,
          NULL CESB,
          NULL ISB,
          NULL YSB,
          NULL UGLOAN,
          NULL UGOA,
          NULL UGDA,
          NULL UGDSA,
          NULL PGLOAN,
          NULL SNB,
          NULL SNCAP,
          NULL SNDA,
          NULL SNIE,
          NULL SNSPA,
          NULL TFEL,
          NULL OTHER_AWARD_TYPE,
          NULL TASK_DETAILS
     FROM CARE_EXPERIENCED_APPS_REPORT c
    WHERE     C.SOURCE = 'OLS'
          AND NOT EXISTS
                     (SELECT 1
                        FROM CARE_EXPERIENCED_APPS_REPORT c1
                       WHERE     C1.SOURCE = 'STEPS'
                             AND C1.STUD_REF_NO = C.STUD_REF_NO
                             AND C1.SESSION_CODE = C.SESSION_CODE);


                             
DROP VIEW V_CARE_EXPERIENCED_AWARDS;

/* Formatted on 05/06/2017 10:32:22 (QP5 v5.256.13226.35538) */
CREATE OR REPLACE FORCE VIEW V_CARE_EXPERIENCED_AWARDS
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
                    AND a1.stud_award_type NOT IN ('FEES',
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
