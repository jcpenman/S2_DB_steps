DROP VIEW SGAS.V_CARE_EXPERIENCED_APPS_REPORT;

/* Formatted on 10/01/2018 10:32:12 (QP5 v5.215.12089.38647) */
CREATE OR REPLACE FORCE VIEW SGAS.V_CARE_EXPERIENCED_APPS_REPORT
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
   TASK_DETAILS,
   FOSTER_CARE,
   RES_CARE,
   KIN_CARE_LA,
   KIN_CARE_NO_LA,
   HOME_CARE,
   OTHER_CARE,
   OTHER_DETAILS,
   CARE_EVID_RECVD
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
                              p.process_bpm
                           || '('
                           || ref_table_assigned_to.itemname
                           || ')'
                           || ',')).EXTRACT ('//text()'),
                     ',')
                     tasks
             FROM process_instance_data p,
                  t_task@wmsteps.world tt,
                  tblthingname@wmsteps.world ref_table_assigned_to
            WHERE     c.stud_ref_no = p.stud_ref_no
                  AND c.session_code = p.session_code
                  AND P.PROCESS_ID = tt.prt_process_instance_id
                  AND tt.assigned_to = ref_table_assigned_to.idthing(+)
                  AND tt.status <> 3)
             TASK_DETAILS,
             c.CARE_EXP_FOSTER,
             c.CARE_EXP_RES,
             c.CARE_EXP_KINSHIP_LA,
             c.CARE_EXP_KINSHIP_NO_LA,
             c.CARE_EXP_HOME,
             c.CARE_EXP_OTHER,
             c.CARE_EXP_OTHER_DETAILS,
             c.CESB_EVI_RECVD
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
          NULL TASK_DETAILS,
          NULL FOSTER_CARE,
          NULL RES_CARE,
          NULL KIN_CARE_LA,
          NULL KIN_CARE_NO_LA,
          NULL HOME_CARE,
          NULL OTHER_CARE,
          NULL OTHER_DETAILS,
          NULL CARE_EVID_RECVD
     FROM CARE_EXPERIENCED_APPS_REPORT c
    WHERE     C.SOURCE = 'OLS'
          AND NOT EXISTS
                     (SELECT 1
                        FROM CARE_EXPERIENCED_APPS_REPORT c1
                       WHERE     C1.SOURCE = 'STEPS'
                             AND C1.STUD_REF_NO = C.STUD_REF_NO
                             AND C1.SESSION_CODE = C.SESSION_CODE);
