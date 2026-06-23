--BEGIN 
--  SYS.DBMS_JOB.REMOVE(229);
--COMMIT;
--END;
--/

DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => 'BEGIN  SGAS.PK_STEPS_ESTRANGED_STUD_REPORT.POPULATE_REPORT_TABLE;  COMMIT;  END;'
   ,next_date => to_date('13/12/2017 03:00:00','dd/mm/yyyy hh24:mi:ss')
   ,interval  => 'TRUNC(SYSDATE +1) + 3/24'
   ,no_parse  => FALSE
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
COMMIT;
END;
/
