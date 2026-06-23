WHENEVER SQLERROR CONTINUE;

DELETE FROM zz_mask_column where order_number > 10;

Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'SURNAME', 'STUD_NAME', 6);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'TITLE', 'STUD_NAME', 3);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'INITIALS', 'STUD_NAME', 4);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'FORENAMES', 'STUD_NAME', 5);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'DOB', 'DEFAULT', 1);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'INITIALS', 'DEFAULT', 2);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'SCOTTISH_CAND', 'SLC', 7);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'NI_NO', 'NINO', 8);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'BANK_NAME', 'ACCOUNT_NO', 9);
Insert into SGAS.ZZ_MASK_COLUMN
   (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER)
 Values
   ('SGAS', 'STUD', 'SORT_CODE', 'SORT_CODE', 10);
COMMIT;



INSERT INTO zz_mask_column (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, MASK_NAME, ORDER_NUMBER, NEW_KEY_TABLE_NAME, NEW_KEY_COLUMN_NAME)
SELECT 'SGAS' SCHEMA_NAME, C.TABLE_NAME, 'STUD_REF_NO' COLUMN_NAME, 'NEW_KEY' MASK_NAME, 
         (select max(order_number) from zz_mask_column) + ROWNUM ORDER_NUMBER,
        'STUD' NEW_KEY_TABLE_NAME,
        'STUD_REF_NO' NEW_KEY_COLUMN_NAME 
  FROM all_tab_cols c
 WHERE     C.OWNER = 'SGAS'
       AND C.COLUMN_NAME = 'STUD_REF_NO'
       AND C.TABLE_NAME NOT IN ('STUD',
                                'UAT_TEST_CASE_TEMP',
                                'WMBBFBVLBA',
                                'WMBBHB4BFZ',
                                'VU_HISTORY',
                                'VU_AWARD_NOTIFICATION_STUD');
                                

DELETE FROM zz_mask_table;

INSERT INTO zz_mask_table 
SELECT ROWNUM ORDER_NUMBER, 'SGAS' SCHEMA_NAME, X.TABLE_NAME
FROM (SELECT C.TABLE_NAME
  FROM all_tab_cols c
 WHERE     C.OWNER = 'SGAS'
       AND C.COLUMN_NAME = 'STUD_REF_NO'
       AND C.TABLE_NAME NOT IN ('STUD',
                                'UAT_TEST_CASE_TEMP',
                                'WMBBFBVLBA',
                                'WMBBHB4BFZ',
                                'VU_HISTORY',
                                'VU_AWARD_NOTIFICATION_STUD')
UNION ALL                                
SELECT 'STUD' TABLE_NAME FROM DUAL) X;


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
                   AND B.TABLE_NAME NOT IN ('UAT_TEST_CASE_TEMP',
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
   WHERE X.INDEX_COLUMNS LIKE '%STUD_REF_NO%'
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
                   AND A.TABLE_NAME NOT IN ('UAT_TEST_CASE_TEMP',
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
                   AND A.TABLE_NAME != 'STUD'
                   AND A.TABLE_NAME NOT IN ('UAT_TEST_CASE_TEMP',
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
                   AND A.TABLE_NAME = 'STUD'
                   AND A.TABLE_NAME NOT IN ('UAT_TEST_CASE_TEMP',
                                            'WMBBFBVLBA',
                                            'WMBBHB4BFZ',
                                            'VU_HISTORY',
                                            'VU_AWARD_NOTIFICATION_STUD')
                   AND a.owner = b.owner
          GROUP BY a.table_name, a.constraint_name) X
   WHERE X.fk_columns LIKE '%STUD_REF_NO%';

DROP table zz_mask_stud_name;

/* Formatted on 18/11/2016 15:21:54 (QP5 v5.256.13226.35538) */
CREATE TABLE zz_mask_stud_name
AS
WITH c_stud
AS
(SELECT /*+ parallel(b,10) */ ROWNUM num_row, b.stud_ref_no, b.title, b.initials, b.forenames,b.surname
FROM stud b)
SELECT ROWNUM record_no, x.*,
       99999999 stud_ref_no
FROM (SELECT DISTINCT na.*
FROM (SELECT DISTINCT n.title,
       LAG(n.initials,1,'') OVER(ORDER BY n.num_row) AS initials,
       LAG(n.FORENAMES,2,'Scott') OVER(ORDER BY n.num_row) AS forenames,
       LAG(n.SURNAME,3,'Dummy') OVER(ORDER BY n.num_row) AS surname
FROM c_stud n
UNION
SELECT DISTINCT n.title,
       LAG(n.initials,2,'') OVER(ORDER BY n.num_row) AS initials,
       LAG(n.FORENAMES,6,'Scott') OVER(ORDER BY n.num_row) AS forenames,
       LAG(n.SURNAME,4,'Dummy') OVER(ORDER BY n.num_row) AS surname
FROM c_stud n
UNION
SELECT DISTINCT n.title,
       LAG(n.initials,3,'') OVER(ORDER BY n.num_row) AS initials,
       LAG(n.FORENAMES,8,'Scott') OVER(ORDER BY n.num_row) AS forenames,
       LAG(n.SURNAME,1,'Dummy') OVER(ORDER BY n.num_row) AS surname
FROM c_stud n
UNION
SELECT DISTINCT n.title,
       LAG(n.initials,4,'') OVER(ORDER BY n.num_row) AS initials,
       LAG(n.FORENAMES,2,'Scott') OVER(ORDER BY n.num_row) AS forenames,
       LAG(n.SURNAME,3,'Dummy') OVER(ORDER BY n.num_row) AS surname
FROM c_stud n) na
WHERE NOT EXISTS (SELECT 1
                  FROM c_stud b
                  WHERE b.forenames = na.forenames
                  AND b.surname = na.surname) ) x;


UPDATE zz_mask_stud_name M
SET M.STUD_REF_NO = (SELECT MIN(S.STUD_REF_NO) - 1 FROM STUD S) + M.RECORD_NO;

CREATE INDEX SGAS.MSN_ST1 ON SGAS.zz_mask_stud_name
(STUD_REF_NO)
COMPUTE STATISTICS;

DROP SEQUENCE SGAS.zz_mask_nino_seq;

CREATE SEQUENCE SGAS.zz_mask_nino_seq
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 999999
NOCACHE 
CYCLE 
NOORDER;


COMMIT;