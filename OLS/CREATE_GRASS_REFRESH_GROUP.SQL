DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
  JobNo Number;
BEGIN
  SnapArray(1) := 'GRASS_STUD';
  SnapArray(2) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'GRASS_REFERENCE_GROUP'
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
