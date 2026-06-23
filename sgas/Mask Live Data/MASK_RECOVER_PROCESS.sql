set serveroutput on size 1000000
DECLARE 
  P_SCHEMA VARCHAR2(32767);

BEGIN 
  P_SCHEMA := 'SGAS';

  SGAS.ZZ_PK_MASK_DATABASE.MASK_RECOVER_PROCESS ( P_SCHEMA );
  COMMIT; 
END;


select min(stud_ref_no), max(stud_ref_no)
from stud;


