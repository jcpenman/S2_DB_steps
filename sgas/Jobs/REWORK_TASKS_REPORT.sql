/*
BEGIN 
  SYS.DBMS_JOB.REMOVE(515);
COMMIT;
END;
/
*/

DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => 'delete from rework_tasks;
 insert into rework_tasks
 (select tt.custom_task_id,tt.task_id, tu.email, trunc(pid.CREATION_DATE) CREATION_DATE, pid.PROCESS_BPM
from t_task@wmsteps.world tt, process_instance_data pid, tbluser@wmsteps.world tu
where tt.STATUS = 1
 and tt.assigned_to = tu.idthing
 and tt.prt_process_instance_id = pid.process_id
 and pid.SESSION_CODE = (select cval from config_data
                        where item_name = ''CURRENT_SESSION''))
 ;
  commit;'
   ,next_date => to_date('01/05/2017 06:00:00','dd/mm/yyyy hh24:mi:ss')
   ,interval  => 'TRUNC(SYSDATE+1)+6/24'
   ,no_parse  => FALSE
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
COMMIT;
END;
/
