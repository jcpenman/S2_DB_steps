-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CR-OLS-203
-- Refresh Group created to update Materialized Views for Reports
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*		
BEGIN
  DBMS_REFRESH.DESTROY(name => 'SGAS.REFRESH_REPORTS');
Commit;
END;
/
*/

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'SGAS.STUD_ENQUIRY_TASK_REPORT';
  SnapArray(2) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'SGAS.REFRESH_REPORTS'
    ,tab  => SnapArray
    ,next_date => SYSDATE
    ,interval  => 'TRUNC(SYSDATE+1)+5/24 '
    ,implicit_destroy => FALSE
    ,lax => TRUE
    ,job => 0
    ,rollback_seg => NULL
    ,push_deferred_rpc => FALSE
    ,refresh_after_errors => FALSE
    ,purge_option => 0
    ,parallelism => 0
    ,heap_size => 0
  );
Commit;
END;
/
