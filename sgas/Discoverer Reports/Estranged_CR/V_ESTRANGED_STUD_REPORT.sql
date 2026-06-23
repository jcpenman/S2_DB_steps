--DROP VIEW SGAS.V_ESTRANGED_STUD_REPORT;

CREATE OR REPLACE FORCE VIEW SGAS.V_ESTRANGED_STUD_REPORT
(
   STUD_REF_NO,
   DATE_APPLICATION_RECEIVED,
   SESSION_CODE,
   DOB,
   INST_CODE,
   INST_NAME,
   CRSE_CODE,
   CRSE_NAME,
   CRSE_YEAR_NO,
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
   SELECT c.STUD_REF_NO,
          c.DATE_APPLICATION_RECEIVED,
          c.SESSION_CODE,
          c.DOB,
          c.INST_CODE,
          c.INST_NAME,
          c.CRSE_CODE,
          c.CRSE_NAME,
          c.CRSE_YEAR_NO,          
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
             TASK_DETAILS
     FROM ESTRANGED_STUD_REPORT c;
