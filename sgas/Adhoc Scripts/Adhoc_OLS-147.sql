DROP MATERIALIZED VIEW CRSE_YEAR ;

CREATE MATERIALIZED VIEW CRSE_YEAR
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH ROWID
 
AS 
SELECT crse_year_id,
       crse_id,
	   eu_flag
  FROM crse_year@grass.world;
  
BEGIN
  DBMS_REFRESH.DESTROY(name => 'SGAS.GRASS_REFERENCE_GROUP');
Commit;
END;
/

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'SGAS.CRSE';
  SnapArray(2) := 'SGAS.CRSE_SESSION';
  SnapArray(3) := 'SGAS.CRSE_YEAR';
  SnapArray(4) := 'SGAS.INST';
  SnapArray(5) := 'SGAS.INST_TERM';
  SnapArray(6) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'SGAS.GRASS_REFERENCE_GROUP'
    ,tab  => SnapArray
    ,next_date => TO_DATE('01/06/2017 06:00:00', 'MM/DD/YYYY HH24:MI:SS')
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