DECLARE
   jobno   NUMBER;
BEGIN
   DBMS_JOB.SUBMIT
      (job  => jobno
      ,what => 'BEGIN  SGAS.PK_CARE_EXP_APPS_REPORT.POPULATE_REPORT_TABLE;  COMMIT;  END;'
      ,next_date => SYSDATE
      ,interval  => 'TRUNC(SYSDATE +1) + 3/24');
   COMMIT;
END;
/