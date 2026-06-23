set timing on;
DECLARE
   CURSOR c_tab
   IS
      SELECT 'STUD' table_name
      FROM DUAL
      UNION ALL
      SELECT C.TABLE_NAME
        FROM ZZ_MASK_COLUMN c
       WHERE C.MASK_NAME = 'NEW_KEY';

   v_sql      VARCHAR2 (1000);
   min_stud   NUMBER;
   max_stud   NUMBER;
   total_rows   NUMBER;
   no_parent   NUMBER;
BEGIN
   FOR get_rec IN c_tab
   LOOP
      v_sql :=
            'select min(stud_ref_no) min_stud, max(stud_ref_no) max_stud, count(0) total_rows from '
         || get_rec.table_name;

      EXECUTE IMMEDIATE v_sql INTO min_stud, max_stud, total_rows;
      v_sql := 'SELECT COUNT (0) no_parent FROM '||get_rec.table_name||' A WHERE NOT EXISTS(SELECT 1 FROM STUD S WHERE S.STUD_REF_NO = A.STUD_REF_NO) and a.stud_ref_no is not null';
      EXECUTE IMMEDIATE v_sql INTO no_parent;
      DBMS_OUTPUT.PUT_LINE (
            'Table '
         || get_rec.table_name
         || ' min: '
         || TO_CHAR (min_stud)
         || ' max: '
         || TO_CHAR (max_stud)
         || ' total_rows: '
         || TO_CHAR (total_rows)
         || ' no parent: '
         || TO_CHAR (no_parent));
   END LOOP;
END;





SELECT *  
FROM AUTHENTICATE_STUD A 
WHERE NOT EXISTS(SELECT 1 FROM STUD S WHERE S.STUD_REF_NO = A.STUD_REF_NO)
and a.stud_ref_no is not null;