CREATE OR REPLACE PACKAGE BODY SGAS.STATS 
IS
PROCEDURE getDailyStats(p_enter_number_of_days_back IN NUMBER, p_enter_days_back_minus_one IN NUMBER, p_stats_curs OUT stats_cursor) 
AS
   
  stats_curs stats_cursor;
 
BEGIN
  
 open stats_curs for
SELECT
(
select count(*) from process_instance_data pid
where pid.PROCESS_BPM = 'StudentApplicationBPM'
and pid.CREATION_DATE > TRUNC(sysdate - (p_enter_number_of_days_back))
and pid.CREATION_DATE < TRUNC(sysdate - (p_enter_days_back_minus_one))
)                                                   AS UG_RECEIVED,
(select count(*) from process_instance_data pid
where pid.PROCESS_BPM = 'StudentApplicationBPM'
and pid.COMPLETE_DATE > TRUNC(sysdate -(p_enter_number_of_days_back))
and pid.COMPLETE_DATE < TRUNC(sysdate - (p_enter_days_back_minus_one)))             AS UG_PROCESSED,
(select count(*) from process_instance_data pid
where pid.PROCESS_BPM = 'StudentApplicationBPM'
and pid.COMPLETE_DATE > TRUNC(sysdate -(p_enter_number_of_days_back))
and pid.COMPLETE_DATE < TRUNC(sysdate - (p_enter_days_back_minus_one))
and pid.AUTO_CALC = 'Y')                            AS UG_AUTO_CALCULATED,
(SELECT
(select count(*) from process_instance_data pid
where pid.PROCESS_BPM = 'StudentApplicationBPM'
and pid.COMPLETE_DATE > TRUNC(sysdate -(p_enter_number_of_days_back))
and pid.COMPLETE_DATE < TRUNC(sysdate - (p_enter_days_back_minus_one))) -
(select count(*) from process_instance_data pid
where pid.PROCESS_BPM = 'StudentApplicationBPM'
and pid.COMPLETE_DATE > TRUNC(sysdate -(p_enter_number_of_days_back))
and pid.COMPLETE_DATE < TRUNC(sysdate - (p_enter_days_back_minus_one))
and pid.AUTO_CALC = 'Y')
FROM DUAL)                                          AS USER_CALCULATED,
(select count(*) from process_instance_data pid
where pid.creation_date < TRUNC(sysdate - (p_enter_days_back_minus_one))
and pid.PROCESS_BPM = 'StudentApplicationBPM')      AS UG_TOTAL_RECIEVED,
(
SELECT COUNT(*) FROM PROCESS_INSTANCE_DATA pid
WHERE pid.complete_date < TRUNC(sysdate - (p_enter_days_back_minus_one))
and pid.PROCESS_BPM = 'StudentApplicationBPM')      AS UG_PROCESSED_TOTAL,
(
SELECT COUNT(*) FROM PROCESS_INSTANCE_DATA pid
WHERE pid.complete_date < TRUNC(sysdate - (p_enter_days_back_minus_one))
and pid.PROCESS_BPM = 'StudentApplicationBPM'
and auto_calc = 'Y')                                AS UG_AUTO_CALC_TOTAL,
(SELECT
(select count(*) from process_instance_data pid
where pid.PROCESS_BPM = 'StudentApplicationBPM'
and pid.COMPLETE_DATE < TRUNC(sysdate - (p_enter_days_back_minus_one))) -
(select count(*) from process_instance_data pid
where pid.PROCESS_BPM = 'StudentApplicationBPM'
and pid.COMPLETE_DATE < TRUNC(sysdate - (p_enter_days_back_minus_one))
AND AUTO_CALC = 'Y')                               
FROM DUAL)  AS USER_CALCULATED_TOTAL,
(select count(*) from process_instance_data pid
where pid.PROCESS_BPM = 'NMSBStudentApplicationBPM'
and pid.CREATION_DATE > TRUNC(sysdate - (p_enter_number_of_days_back))
and pid.CREATION_DATE < TRUNC(sysdate - (p_enter_days_back_minus_one)))             AS NMSB_RECEIVED,
(select count(*) from process_instance_data pid
where pid.PROCESS_BPM = 'NMSBStudentApplicationBPM'
and pid.COMPLETE_DATE > TRUNC(sysdate - (p_enter_number_of_days_back))
and pid.COMPLETE_DATE < TRUNC(sysdate - (p_enter_days_back_minus_one)))             AS NMSB_PROCESSED,
(select count(*) from process_instance_data pid
where pid.creation_date < TRUNC(sysdate - (p_enter_days_back_minus_one))
and pid.PROCESS_BPM = 'NMSBStudentApplicationBPM')      AS NMSB_TOTAL_RECIEVED,
(
SELECT COUNT(*) FROM PROCESS_INSTANCE_DATA pid
WHERE pid.complete_date < TRUNC(sysdate - (p_enter_days_back_minus_one))
and pid.PROCESS_BPM = 'NMSBStudentApplicationBPM')      AS NMSB_PROCESSED_TOTAL,
(
SELECT COUNT(*) FROM PROCESS_INSTANCE_DATA pid
WHERE pid.creation_date < TRUNC(sysdate - (p_enter_days_back_minus_one))
and pid.PROCESS_BPM IN('NMSBStudentApplicationBPM','StudentApplicationBPM')) AS ALL_TOTAL_REC,
(
SELECT COUNT(*) FROM PROCESS_INSTANCE_DATA pid
WHERE pid.complete_date < TRUNC(sysdate - (p_enter_days_back_minus_one))
and pid.PROCESS_BPM IN('NMSBStudentApplicationBPM','StudentApplicationBPM')) AS ALL_TOTAL_PROC
FROM DUAL;
 
 p_stats_curs := stats_curs; 
 


END;


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
 GROUP BY b.forename, b.surname, a.username, b.team)
 ORDER BY OVERALL_TOTAL DESC;

 p_stats_curs := stats_curs;

END;

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
 
 END;

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
 
 END;


END STATS;
/
