BEGIN
  DBMS_REFRESH.DESTROY(name => 'SGAS.STEPS_REFERENCE_GROUP');
Commit;
END;
/

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'SGAS.TITLE';
  SnapArray(2) := 'SGAS.ACCOUNT_LOCK_REASON';
  SnapArray(3) := 'SGAS.ACCOUNT_UNLOCK_REASON';
  SnapArray(4) := 'SGAS.APPLICATION_STATUS_MESSAGE';
  SnapArray(5) := 'SGAS.AWARD_STATUS_MESSAGE';
  SnapArray(6) := 'SGAS.CONTACT_RELATIONSHIP';
  SnapArray(7) := 'SGAS.COUNTRY';
  SnapArray(8) := 'SGAS.EU_PORTABILITY';
  SnapArray(9) := 'SGAS.MARITAL_STATUS';
  SnapArray(10) := 'SGAS.NATIONALITY';
  SnapArray(11) := 'SGAS.REASON_FOR_ONE_BEN';
  SnapArray(12) := 'SGAS.REASON_NO_BEN_INCOME';
  SnapArray(13) := 'SGAS.STUDENT_FAMILY_RELATIONSHIP';
  SnapArray(14) := 'SGAS.STUD_INCOME_TYPE';
  SnapArray(15) := 'SGAS.SUPP_GRANT_RELATION';
  SnapArray(16) := 'SGAS.WHAT_DOING';
  SnapArray(17) := 'SGAS.CONFIG_DATA';
  SnapArray(18) := 'SGAS.BENEFACTOR_RELATION';
  SnapArray(19) := 'SGAS.PG_ED_PSYCH';
  SnapArray(20) := 'SGAS.STUDENT_MESSAGE_SUBJECT';
  SnapArray(21) := 'SGAS.EU_SETTLED_STATUSES';
  SnapArray(22) := 'SGAS.EU_RESIDENCE_TYPE';
  SnapArray(23) := 'SGAS.APPLICATION_STATUS';
  SnapArray(24) := 'SGAS.COURSE_LEVEL';
  SnapArray(25) := 'SGAS.PROVIDER';
  SnapArray(26) := 'SGAS.AWARD';
  SnapArray(27) := 'SGAS.DSA_APP_STATUS';
  SnapArray(28) := 'SGAS.ENQUIRY_OPTION';
  SnapArray(29) := 'SGAS.FUNDING_ORGANISATION';
  SnapArray(30) := 'SGAS.QUALIFICATION_LEVEL';
  SnapArray(31) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'SGAS.STEPS_REFERENCE_GROUP'
    ,tab  => SnapArray
    ,next_date => sysdate
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