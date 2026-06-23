WHENEVER SQLERROR continue
set serveroutput on size 1000000;
begin
DBMS_OUTPUT.PUT_LINE('Some of these indexes may not exist and show an "ORA-01418: specified index does not exist" error.  ');
DBMS_OUTPUT.PUT_LINE('This is not a problem and should not stop the release. ');
end;
DROP INDEX S1_AW;
DROP INDEX QUEST_SX_IDXF6989FE2116AC53EA;
DROP INDEX S1_STCD;
DROP INDEX SCD_BITMAP_IDX;
DROP INDEX S2_STS;
/
