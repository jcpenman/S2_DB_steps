set timing on;
WHENEVER SQLERROR CONTINUE;


DROP SEQUENCE SGAS.EMPLOYEE_SEQ;

CREATE SEQUENCE SGAS.EMPLOYEE_SEQ
 INCREMENT BY 1
 MINVALUE 700001
 MAXVALUE 999999
 NOCACHE
 NOCYCLE
 NOORDER;

DELETE FROM zz_mask_column;--  where order_number > 77;

SET DEFINE OFF;
--SQL Statement which produced this data:
--
--  SELECT *
--  FROM ZZ_MASK_COLUMN
--  ORDER BY ORDER_NUMBER;
--
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'EMPLOYEE', 'FORENAME', 'EMPLOYEE_NAME', 1);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'EMPLOYEE', 'SURNAME', 'EMPLOYEE_NAME', 2);

COMMIT;

INSERT INTO zz_mask_column (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER, NEW_KEY_TABLE_NAME, NEW_KEY_COLUMN_NAME)
SELECT 'SGAS' SCHEMA_NAME, C.TABLE_NAME,  C.COLUMN_NAME, 'NEW_KEY_CHAR' MASK_NAME, 
         (select max(order_number) from zz_mask_column) + ROWNUM ORDER_NUMBER,
        'EMPLOYEE' NEW_KEY_TABLE_NAME,
        'USERNAME' NEW_KEY_COLUMN_NAME 
  FROM all_tab_cols c, 
        all_tables t
 WHERE     C.OWNER = 'SGAS'
 AND T.OWNER = 'SGAS'
 AND T.TABLE_NAME = C.TABLE_NAME
       AND C.COLUMN_NAME IN ('USERNAME','LAST_UPDATED_BY')
       AND C.TABLE_NAME NOT like 'Z%'
       AND C.TABLE_NAME NOT like 'TEMP%'
       AND C.TABLE_NAME NOT like 'MASK_%'
       AND C.TABLE_NAME NOT IN ('EMPLOYEE',
                                'UAT_TEST_CASE_TEMP',
                                'WMBBFBVLBA',
                                'WMBBHB4BFZ',
                                'VU_HISTORY',
                                'VU_AWARD_NOTIFICATION_STUD')
ORDER BY 2;
                                

DELETE FROM zz_mask_table;

INSERT INTO zz_mask_table 
SELECT ROWNUM ORDER_NUMBER, 'SGAS' SCHEMA_NAME, X.TABLE_NAME, 'REQUIRED' STATUS
FROM (SELECT DISTINCT C.TABLE_NAME
  FROM all_tab_cols c, 
        all_tables t
 WHERE     C.OWNER = 'SGAS'
 AND T.OWNER = 'SGAS'
 AND T.TABLE_NAME = C.TABLE_NAME
       AND C.COLUMN_NAME IN ('USERNAME','LAST_UPDATED_BY')
       AND C.TABLE_NAME NOT like 'Z%'
       AND C.TABLE_NAME NOT like 'TEMP%'
       AND C.TABLE_NAME NOT like 'MASK_%'
       AND C.TABLE_NAME NOT IN ('EMPLOYEE',
                                'UAT_TEST_CASE_TEMP',
                                'WMBBFBVLBA',
                                'WMBBHB4BFZ',
                                'VU_HISTORY',
                                'VU_AWARD_NOTIFICATION_STUD')
UNION ALL                                
SELECT 'EMPLOYEE' TABLE_NAME FROM DUAL) X;


DELETE FROM zz_mask_INDEX;

INSERT INTO zz_mask_INDEX (SCHEMA_NAME, TABLE_NAME, INDEX_NAME)
SELECT 'SGAS' SCHEMA_NAME, X.TABLE_NAME, X.INDEX_NAME
    FROM (  SELECT a.index_name,
                   B.INDEX_TYPE,
                   B.UNIQUENESS,
                   B.OWNER,
                   B.TABLE_NAME,
                   LISTAGG (A.column_name, ',')
                      WITHIN GROUP (ORDER BY A.column_position)
                      index_columns
              FROM all_ind_columns a, all_indexes b
             WHERE     b.owner = 'SGAS'
                       AND B.TABLE_NAME NOT like 'Z%'
                       AND B.TABLE_NAME NOT like 'TEMP%'
                       AND B.TABLE_NAME NOT like 'MASK_%'
                       AND B.TABLE_NAME NOT IN ('EMPLOYEE',
                                                'UAT_TEST_CASE_TEMP',
                                                'WMBBFBVLBA',
                                                'WMBBHB4BFZ',
                                                'VU_HISTORY',
                                                'VU_AWARD_NOTIFICATION_STUD')
                   AND b.index_name = a.index_name
                   AND b.owner = a.index_owner
          GROUP BY a.index_name,
                   B.INDEX_TYPE,
                   B.UNIQUENESS,
                   B.OWNER,
                   B.TABLE_NAME) X
   WHERE X.INDEX_COLUMNS LIKE '%USERNAME%' OR
         X.INDEX_COLUMNS LIKE '%LAST_UPDATED_BY%'
ORDER BY 1, 2, 3;


DELETE FROM ZZ_MASK_CONSTRAINT;


INSERT INTO ZZ_MASK_CONSTRAINT (SCHEMA_NAME, TABLE_NAME, CONSTRAINT_NAME, ORDER_NUMBER)
  SELECT 'SGAS' SCHEMA_NAME, X.TABLE_NAME, X.CONSTRAINT_NAME, ROWNUM ORDER_NUMBER
    FROM (  SELECT a.table_name,
                   a.constraint_name,
                   LISTAGG (a.column_name, ',')
                      WITHIN GROUP (ORDER BY a.position)
                      fk_columns
              FROM all_cons_columns a, all_constraints b
             WHERE     a.constraint_name = b.constraint_name
                   AND a.owner = 'SGAS'
                   AND B.CONSTRAINT_TYPE != 'P'
                   AND  B.TABLE_NAME NOT like 'Z%'
                       AND B.TABLE_NAME NOT like 'TEMP%'
                       AND B.TABLE_NAME NOT like 'MASK_%'
                       AND B.TABLE_NAME NOT IN ('EMPLOYEE',
                                                'UAT_TEST_CASE_TEMP',
                                                'WMBBFBVLBA',
                                                'WMBBHB4BFZ',
                                                'VU_HISTORY',
                                                'VU_AWARD_NOTIFICATION_STUD')
                   AND a.owner = b.owner
          GROUP BY a.table_name, a.constraint_name    
          UNION ALL
          SELECT a.table_name,
                   a.constraint_name,
                   LISTAGG (a.column_name, ',')
                      WITHIN GROUP (ORDER BY a.position)
                      fk_columns
              FROM all_cons_columns a, all_constraints b
             WHERE     a.constraint_name = b.constraint_name
                   AND a.owner = 'SGAS'
                   AND B.CONSTRAINT_TYPE = 'P'
                   AND  B.TABLE_NAME NOT like 'Z%'
                       AND B.TABLE_NAME NOT like 'TEMP%'
                       AND B.TABLE_NAME NOT like 'MASK_%'
                       AND B.TABLE_NAME NOT IN ('EMPLOYEE',
                                                'UAT_TEST_CASE_TEMP',
                                                'WMBBFBVLBA',
                                                'WMBBHB4BFZ',
                                                'VU_HISTORY',
                                                'VU_AWARD_NOTIFICATION_STUD')
                   AND a.owner = b.owner
          GROUP BY a.table_name, a.constraint_name    
          UNION ALL
          SELECT a.table_name,
                   a.constraint_name,
                   LISTAGG (a.column_name, ',')
                      WITHIN GROUP (ORDER BY a.position)
                      fk_columns
              FROM all_cons_columns a, all_constraints b
             WHERE     a.constraint_name = b.constraint_name
                   AND a.owner = 'SGAS'
                   AND B.CONSTRAINT_TYPE = 'P'
                   AND A.TABLE_NAME = 'EMPLOYEE'
                   AND a.owner = b.owner
          GROUP BY a.table_name, a.constraint_name) X
   WHERE X.fk_columns LIKE '%USERNAME%' OR
         X.fk_columns LIKE '%LAST_UPDATED_BY%';

DROP table zz_mask_employee;

/* Formatted on 18/11/2016 15:21:54 (QP5 v5.256.13226.35538) */
CREATE TABLE zz_mask_employee
AS
WITH c_employee
AS
(SELECT /*+ parallel(b,10) */ ROWNUM num_row, b.username, b.forename,b.surname
FROM EMPLOYEE b
where substr(b.username,1,1) in ('N','U','Z')
 --   and substr(b.username,2,1) BETWEEN '0' AND '6'
    )
SELECT ROWNUM record_no, 
       x.FORENAME||' XXX' FORENAME,
       X.SURNAME||' XXX' SURNAME,
       '99999999' username
FROM c_employee X;


CREATE INDEX SGAS.MEMP_ST2 ON SGAS.zz_mask_employee
(RECORD_NO)
COMPUTE STATISTICS;


DECLARE
        
   TYPE t_record_no_tab IS TABLE OF varchar2(100);
   l_tab_record_no t_record_no_tab := t_record_no_tab();
   TYPE T_EMPLOYEE_TAB IS TABLE OF EMPLOYEE.USERNAME%TYPE;
   l_tab_USERNAME T_EMPLOYEE_TAB := T_EMPLOYEE_TAB();
   CURSOR C_EMPLOYEE
   IS
        SELECT rownum record_no, S.USERNAME
          FROM EMPLOYEE S
      ORDER BY S.USERNAME;
BEGIN
   UPDATE zz_mask_employee
      SET USERNAME = NULL;

    OPEN C_EMPLOYEE;
    LOOP
    FETCH C_EMPLOYEE BULK COLLECT INTO l_tab_record_no, l_tab_USERNAME LIMIT 1000;

    FORALL i IN l_tab_record_no.first .. l_tab_record_no.last

      UPDATE zz_mask_employee S
         SET S.USERNAME = l_tab_USERNAME(i)
       WHERE S.RECORD_NO = l_tab_record_no(i);
                             
    EXIT WHEN C_EMPLOYEE%NOTFOUND;
    END LOOP;
    CLOSE C_EMPLOYEE;
      
   COMMIT;
END;

CREATE INDEX SGAS.MEMP_ST1 ON SGAS.zz_mask_employee
(USERNAME)
COMPUTE STATISTICS;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_COLUMN'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_CONSTRAINT'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_INDEX'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_KEY'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_KEY_RESULT'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_EMPLOYEE'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;



BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
     OwnName           => 'SGAS'
    ,TabName           => 'ZZ_MASK_TABLE'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => TRUE
    ,No_Invalidate  => FALSE);
END;


COMMIT;