DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'STEPS.BENEFACTOR';
  SnapArray(2) := 'STEPS.STUD';
  SnapArray(3) := 'STEPS.STUD_AWARD_STATUS';
  SnapArray(4) := 'STEPS.STUD_CONT_DETAILS';
  SnapArray(5) := 'STEPS.STUD_CRSE_YEAR';
  SnapArray(6) := 'STEPS.STUD_HOME_ADDR';
  SnapArray(7) := 'STEPS.STUD_MESSAGE';
  SnapArray(8) := 'STEPS.STUD_SESSION';
  SnapArray(9) := 'STEPS.STUD_TERM_ADDR';
  SnapArray(10) := 'STEPS.LEARNER';
  SnapArray(11) := 'STEPS.LEARNER_APPLICATION';
  SnapArray(12) := 'STEPS.DSA_APPLICATION';
  SnapArray(13) := 'STEPS.AWARD_MSL';
  SnapArray(14) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'STEPS.STEPS_DATA_GROUP'
    ,tab  => SnapArray
    ,next_date => sysdate
    ,interval  => 'SYSDATE + (5/60)/24'
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