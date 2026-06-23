/* Formatted on 30/11/2016 16:13:51 (QP5 v5.256.13226.35538) */
SET SERVEROUTPUT ON SIZE 1000000

DECLARE
   CURSOR c_primary_keys
   IS
        SELECT x.table_name,
               x.constraint_name,
               DECODE (INSTR (x.fk_columns, ','),
                       0, x.fk_columns,
                       SUBSTR (x.fk_columns, 1, INSTR (x.fk_columns, ',') - 1))
                  column_name
          FROM (  SELECT a.table_name,
                         a.constraint_name,
                         LISTAGG (a.column_name, ',')
                            WITHIN GROUP (ORDER BY a.position)
                            fk_columns
                    FROM all_cons_columns a, all_constraints b
                   WHERE     a.constraint_name = b.constraint_name
                         AND a.owner = 'SGAS'
      --                   AND b.table_name LIKE 'STUD%'
                         AND B.CONSTRAINT_TYPE = 'P'
                         AND a.owner = b.owner
                         AND EXISTS
                                (SELECT 1
                                   FROM all_constraints a1
                                  WHERE     a1.owner = 'SGAS'
                                        AND a1.constraint_type = 'R'
                                        AND a1.r_constraint_name =
                                               a.constraint_name)
                GROUP BY a.table_name, a.constraint_name) x
      ORDER BY 1, 2, 3;

   CURSOR C_CHILD_TABLES (
      L_TABLE_NAME         VARCHAR2,
      L_COLUMN_NAME        VARCHAR2,
      L_CONSTRAINT_NAME    VARCHAR2)
   IS
        SELECT C.TABLE_NAME, C.COLUMN_NAME
          FROM ALL_TAB_COLS C, ALL_TABLES T
         WHERE     C.OWNER = 'SGAS'
               AND T.OWNER = 'SGAS'
               AND T.TABLE_NAME = C.TABLE_NAME
               AND C.TABLE_NAME != L_TABLE_NAME
               AND C.COLUMN_NAME = L_COLUMN_NAME
               AND NOT EXISTS
                          (SELECT 1
                             FROM all_constraints a1
                            WHERE     a1.owner = 'SGAS'
                                  AND a1.constraint_type = 'R'
                                  AND a1.r_constraint_name = L_CONSTRAINT_NAME
                                  AND A1.TABLE_NAME = T.TABLE_NAME)
      ORDER BY 1, 2;

   v_sql       VARCHAR2 (1000);
   no_parent   NUMBER;
BEGIN
   FOR get_rec IN c_primary_keys
   LOOP
      DBMS_OUTPUT.PUT_LINE (
            'PARENT Table being processed is : '
         || get_rec.table_name
         || ' and column '
         || get_rec.column_name
         || ' and constraint '
         || get_rec.constraint_name);

      FOR GET_CHILD
         IN C_CHILD_TABLES (GET_REC.TABLE_NAME,
                            GET_REC.COLUMN_NAME,
                            GET_REC.CONSTRAINT_NAME)
      LOOP
         DBMS_OUTPUT.PUT_LINE (
               'CHILD Table being processed is : '
            || GET_CHILD.table_name
            || ' and column '
            || GET_CHILD.column_name);

         v_sql :=
               'SELECT /*+ parallel(A,10) */ COUNT (0) no_parent FROM '
            || GET_CHILD.table_name
            || ' A WHERE NOT EXISTS(SELECT 1 FROM '
            || GET_REC.TABLE_NAME
            || ' S WHERE S.'
            || GET_REC.COLUMN_NAME
            || '= A.'
            || GET_CHILD.column_name
            || ') and a.'
            || GET_CHILD.column_name
            || ' is not null';

         EXECUTE IMMEDIATE v_sql INTO no_parent;

         IF (NVL (no_parent, 0) > 0)
         THEN
            DBMS_OUTPUT.PUT_LINE (
                  'Child Table '
               || GET_CHILD.table_name
               || ' NO PARENT: '
               || TO_CHAR (no_parent)
               || ' SQL: '
               || v_sql);
         END IF;

         DBMS_OUTPUT.PUT_LINE ('  ');
      END LOOP;
   END LOOP;
END;