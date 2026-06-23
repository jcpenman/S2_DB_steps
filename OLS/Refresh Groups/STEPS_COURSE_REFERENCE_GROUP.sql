BEGIN
DBMS_REFRESH.DESTROY(name => 'SGAS.STEPS_COURSE_REFERENCE_GROUP');
Commit;
END;
/

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'SGAS.CRSE';
  SnapArray(2) := 'SGAS.CRSE_SESSION';
  SnapArray(3) := 'SGAS.INST_TERM';
  SnapArray(4) := 'SGAS.INST';
  SnapArray(5) := 'SGAS.CRSE_YEAR';
  SnapArray(6) := 'SGAS.INST_GROUPING';
  SnapArray(7) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'SGAS.STEPS_COURSE_REFERENCE_GROUP'
    ,tab  => SnapArray
    ,next_date => TO_DATE('08/31/2023 06:00:00', 'MM/DD/YYYY HH24:MI:SS')
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
/