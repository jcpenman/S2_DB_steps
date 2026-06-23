DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
  JobNo Number;
BEGIN
  SnapArray(1) := 'CRSE';
  SnapArray(2) := 'CRSE_SESSION';
  SnapArray(3) := 'CRSE_YEAR';
  SnapArray(4) := 'INST_TERM';
  SnapArray(5) := 'INST';
  SnapArray(6) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'STEPS_COURSE_REFERENCE_GROUP'
    ,tab  => SnapArray
    ,next_date => SYSDATE
    ,interval  => 'TRUNC(SYSDATE+1)+6/24'
    ,implicit_destroy => FALSE
    ,lax => TRUE
    ,job => 0
    ,rollback_seg => NULL
    ,push_deferred_rpc => TRUE
    ,refresh_after_errors => FALSE
    ,purge_option => 1
    ,parallelism => 0
    ,heap_size => 0
  );
Commit;
END;
