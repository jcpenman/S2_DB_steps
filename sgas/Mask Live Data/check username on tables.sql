set timing on;
DECLARE
   CURSOR c_tab
   IS
      SELECT 'EMPLOYEE' table_name, 'USERNAME' COLUMN_NAME
      FROM DUAL
      UNION ALL
      SELECT C.TABLE_NAME, C.COLUMN_NAME
        FROM ZZ_MASK_COLUMN c
       WHERE C.MASK_NAME = 'NEW_KEY_CHAR';

   v_sql      VARCHAR2 (1000);
   min_employee   varchar2(100);
   max_employee   varchar2(100);
   total_rows   NUMBER;
   no_parent   NUMBER;
BEGIN
   FOR get_rec IN c_tab
   LOOP
      v_sql :=
            'select min('||GET_REC.COLUMN_NAME||') min_employee, max('||GET_REC.COLUMN_NAME||') max_employee, count(0) total_rows from '
         || get_rec.table_name||' where '||GET_REC.COLUMN_NAME||' like '''||'U%''';

      EXECUTE IMMEDIATE v_sql INTO min_employee, max_employee, total_rows;
      v_sql := 'SELECT COUNT (0) no_parent FROM '||get_rec.table_name||' A WHERE NOT EXISTS(SELECT 1 FROM EMPLOYEE S WHERE S.USERNAME = A.'||GET_REC.COLUMN_NAME||') and a.'||GET_REC.COLUMN_NAME||' is not null';
      EXECUTE IMMEDIATE v_sql INTO no_parent;
      DBMS_OUTPUT.PUT_LINE (
            'Table '
         || get_rec.table_name
         || ' min: '
         || TO_CHAR (min_employee)
         || ' max: '
         || TO_CHAR (max_employee)
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