CREATE OR REPLACE PACKAGE BODY zz_pk_mask_database
AS
 /******************************************************************************
 NAME: SGAS.zz_pk_mask_database
 PURPOSE: After a database has been cloned, this package will transform all
 sensitive dat.

 REVISIONS:
 Ver Date Author Description
 --------- ---------- --------------- ------------------------------------
 1.0 14.11.2016 James Baird Created this package
 ******************************************************************************/

/*
 This will build up a command like;
 alter table SGAS.STUD disable all triggers;

*/
 PROCEDURE disable_triggers (p_schema IN VARCHAR2,
 p_table_name IN VARCHAR2)
 IS
 v_sql VARCHAR2(1000);
 BEGIN
 v_sql := 'ALTER TABLE '|| p_schema||'.'||p_table_name||' DISABLE ALL TRIGGERS';
 EXECUTE IMMEDIATE v_sql;
 END disable_triggers;

/*
 This will build up a command like;
 alter table SGAS.STUD enable all triggers;

*/

 PROCEDURE enable_triggers (p_schema IN VARCHAR2, p_table_name IN VARCHAR2)
 IS
 v_sql VARCHAR2(1000);
 BEGIN
 v_sql := 'ALTER TABLE '|| p_schema||'.'||p_table_name||' ENABLE ALL TRIGGERS';
 EXECUTE IMMEDIATE v_sql;
 END enable_triggers;

/*
 This will build up a command for each constraint in the zz_mask_constraint table;
 Example:
 alter table sgas.stud disable constraint f1_st;

*/
 PROCEDURE disable_constraints (p_schema IN VARCHAR2)
 IS
 CURSOR C_CONSTRAINTS
 IS
 SELECT C.TABLE_NAME, C.CONSTRAINT_NAME
 FROM ZZ_MASK_CONSTRAINT C
 WHERE C.SCHEMA_NAME = p_schema
 ORDER BY C.ORDER_NUMBER;
 v_sql VARCHAR2(1000);
 BEGIN
 FOR GET_CONS IN C_CONSTRAINTS
 LOOP
 v_sql := 'ALTER TABLE '|| p_schema||'.'||get_cons.table_name||' DISABLE CONSTRAINT '||get_cons.constraint_name;
 EXECUTE IMMEDIATE v_sql;
 END LOOP;
 END disable_constraints;

/*
 This will build up a command for each constraint in the zz_mask_constraint table;
 Example:
 alter table sgas.stud enable constraint f1_st;

*/
 PROCEDURE enable_constraints (p_schema IN VARCHAR2)
 IS
 CURSOR C_CONSTRAINTS
 IS
 SELECT C.TABLE_NAME, C.CONSTRAINT_NAME
 FROM ZZ_MASK_CONSTRAINT C
 WHERE C.SCHEMA_NAME = p_schema
 ORDER BY C.ORDER_NUMBER DESC;
 v_sql VARCHAR2(1000);
 BEGIN
 FOR GET_CONS IN C_CONSTRAINTS
 LOOP
 v_sql := 'ALTER TABLE '|| p_schema||'.'||get_cons.table_name||' ENABLE CONSTRAINT '||get_cons.constraint_name;
 DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP||'enable_constraints being processed: '|| v_sql); 
 EXECUTE IMMEDIATE v_sql;
 DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP||'enable_constraints processed complete: '|| v_sql); 
 END LOOP;
 END enable_constraints;

/*
 This will build up a command for each index in the zz_maskindex table;
 Example:
 drop index SGAS.S9_ST;

*/
 PROCEDURE drop_indexes (p_schema IN VARCHAR2, p_table_name IN VARCHAR2)
 IS
 CURSOR C_INDEXES
 IS
 SELECT I.INDEX_NAME
 FROM ZZ_MASK_INDEX I
 WHERE I.SCHEMA_NAME = p_schema
 AND I.TABLE_NAME = p_table_name;
 v_sql VARCHAR2(1000);
 BEGIN
 FOR get_indexes IN C_INDEXES
 LOOP
 v_sql := 'DROP INDEX '|| p_schema||'.'||get_indexes.index_name;
 EXECUTE IMMEDIATE v_sql;
 END LOOP;
 END drop_indexes;

/*
 This will build up a command for each index in the zz_maskindex table;
 Example:
 CREATE INDEX "SGAS"."S9_ST" ON "SGAS"."STUD" ("SCHOOL_ID","FRAUD") 
 PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
 STORAGE(INITIAL 262144 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
 TABLESPACE "STEPS_INDEX"

*/PROCEDURE create_indexes (p_schema IN VARCHAR2, p_table_name IN VARCHAR2)
 IS
 CURSOR C_INDEXES
 IS
 SELECT I.INDEX_SCRIPT
 FROM ZZ_MASK_INDEX I
 WHERE I.SCHEMA_NAME = p_schema
 AND I.TABLE_NAME = p_table_name;
 v_sql VARCHAR2(1000);
 BEGIN
 FOR get_indexes IN C_INDEXES
 LOOP
 v_sql := get_indexes.index_script;
 EXECUTE IMMEDIATE v_sql;
 END LOOP;
 END create_indexes;

/*
 This will update the zz_maskindex table by populating the index_script column;
 Example:
 CREATE INDEX "SGAS"."S9_ST" ON "SGAS"."STUD" ("SCHOOL_ID","FRAUD") 
 PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
 STORAGE(INITIAL 262144 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
 TABLESPACE "STEPS_INDEX"

*/
 PROCEDURE populate_index_scripts (p_schema IN VARCHAR2)
 IS
 PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
 UPDATE ZZ_MASK_INDEX i
 SET i.index_script = TO_CHAR(DBMS_LOB.SUBSTR(DBMS_METADATA.GET_DDL('INDEX',i.index_name,i.schema_name),32000,1))
 WHERE i.schema_name = p_schema
 AND i.index_script IS NULL;
 COMMIT;
 END populate_index_scripts;

/*
 This will update the key values for all the keys that need to change in a schema

*/
 PROCEDURE mask_keys(p_schema IN VARCHAR2)
 IS
 CURSOR C_KEYS
 IS
 SELECT K.TABLE_NAME, K.COLUMN_NAME, K.KEY_VALUE, K.KEY_TYPE
 FROM ZZ_MASK_KEY K
 WHERE K.STATUS = 'REQUIRED'
 ORDER BY K.ORDER_NUMBER
 FOR UPDATE OF K.STATUS;
 v_table_being_processed VARCHAR2(100);
 v_update_sql VARCHAR2(1000);
 BEGIN
 FOR get_key IN C_KEYS
 LOOP
 v_table_being_processed := get_key.table_name;
 v_update_sql := 'UPDATE /*+ PARALLEL(T,10) */ '||get_key.table_name||' T SET '||get_key.column_name||' = ';
 IF (get_key.key_type = 'SEQUENCE')
 THEN
 v_update_sql := v_update_sql||' SGAS.ZZ_PK_MASK_DATABASE.CREATE_NEW_KEY(:1, :2, :3, :4, T.'||get_key.column_name||')';
 END IF;
 IF (get_key.table_name = 'EMPLOYEE')
 THEN
 v_update_sql := v_update_sql || ' WHERE T.USERNAME LIKE '''||'Z%'''|| ' or T.USERNAME LIKE '''||'N%''';
 END IF;
 DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP||'mask_keys UPDATE KEY being processed: '|| v_update_sql);
 EXECUTE IMMEDIATE v_update_sql USING p_schema, get_key.table_name, get_key.column_name, get_key.key_value;
 DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP||'mask_keys UPDATE KEY completed: '|| v_update_sql);
 
 UPDATE ZZ_MASK_KEY K
 SET K.STATUS = 'COMPLETED'
 WHERE CURRENT OF C_KEYS;
 END LOOP;
 END mask_keys;

/*
 This will create the mask indexes needed to support the update of foreign key data

*/
    PROCEDURE create_mask_indexes(p_schema IN VARCHAR2)
    IS
    BEGIN
        NULL;
    END create_mask_indexes;

/*
    This will drop the mask indexes needed to support the update of foreign key data

*/
    PROCEDURE drop_mask_indexes(p_schema IN VARCHAR2)
    IS
    BEGIN
        NULL;
    END drop_mask_indexes;

/* This will derive a unique national insurance number
   The latest nino will be stored in the package variable v_latest_nino */
    FUNCTION get_unique_nino
        RETURN VARCHAR2
    IS
      --  zz_mask_nino_seq
        v_first_char VARCHAR2(16) := 'ACEGHJLMPRSTUWXY';
        v_second_char VARCHAR2(16) := 'ACEGHJLMPRSTUWXY';
        v_last_char VARCHAR2(4) := 'ABCD';
        v_padded_number VARCHAR2(6);
    BEGIN
        SELECT LPAD(zz_mask_nino_seq.NEXTVAL,6,'0')
        INTO v_padded_number
        FROM DUAL;

        CASE
        WHEN v_padded_number = '000001' AND v_latest_nino IS NOT NULL
        THEN
            IF (SUBSTR(v_latest_nino,2,1) != 'Y')
            THEN
                v_latest_nino := SUBSTR(v_latest_nino,1,1) ||
                                 SUBSTR(v_second_char,INSTR(v_second_char, SUBSTR(v_latest_nino,2,1)) + 1  ,1)||
                                 v_padded_number||
                                 'A';
            ELSE
                v_latest_nino := SUBSTR(v_first_char,INSTR(v_first_char, SUBSTR(v_latest_nino,1,1)) + 1  ,1)||
                                 'A'||
                                 v_padded_number||
                                 'A';

            END IF;
        WHEN v_padded_number = '000001' AND v_latest_nino IS NULL
        THEN
            v_latest_nino := 'AA' ||v_padded_number||'A';
        ELSE
            v_latest_nino := SUBSTR(v_latest_nino,1,2) ||
                             v_padded_number||
                             SUBSTR(v_latest_nino,9,1);
        END CASE;

        RETURN v_latest_nino;
    END get_unique_nino;
    
    
    FUNCTION get_unique_slc
       RETURN VARCHAR2
    IS
       slc               NUMBER;
       dig1              NUMBER;
       dig2              NUMBER;
       dig3              NUMBER;
       dig4              NUMBER;
       dig5              NUMBER;
       dig6              NUMBER;
       dig7              NUMBER;
       dig8              NUMBER;
       dig9              NUMBER;
       dig10             NUMBER;
       dig11             NUMBER;
       dig12             NUMBER;
       l_total           NUMBER;
       l_rem             NUMBER;
       l_diff            NUMBER;
       l_sess            VARCHAR2 (4);
       slcno             VARCHAR2 (10);
       chk_dig           VARCHAR2 (1);
       v_scottish_cand   VARCHAR2 (1000);
    BEGIN
       SELECT st_slc_ref_no_seq.NEXTVAL INTO slc FROM DUAL;

       SELECT SUBSTR (cval, 3, 2)
         INTO l_sess
         FROM config_data
        WHERE item_name = 'CURRENT_SESSION';

       slcno := LTRIM (RTRIM (l_sess)) || LTRIM (RTRIM (TO_CHAR (slc, '000000')));
       --
       dig1 := 16 * 13;
       dig2 := 1 * 12;
       dig3 := 1 * 11;
       dig4 := 16 * 10;
       dig5 := TO_NUMBER (SUBSTR (l_sess, 1, 1)) * 9;
       dig6 := TO_NUMBER (SUBSTR (l_sess, 2, 1)) * 8;
       dig7 := TO_NUMBER (SUBSTR (slcno, 3, 1)) * 7;
       dig8 := TO_NUMBER (SUBSTR (slcno, 4, 1)) * 6;
       dig9 := TO_NUMBER (SUBSTR (slcno, 5, 1)) * 5;
       dig10 := TO_NUMBER (SUBSTR (slcno, 6, 1)) * 4;
       dig11 := TO_NUMBER (SUBSTR (slcno, 7, 1)) * 3;
       dig12 := TO_NUMBER (SUBSTR (slcno, 8, 1)) * 2;
       --
       l_total :=
            dig1
          + dig2
          + dig3
          + dig4
          + dig5
          + dig6
          + dig7
          + dig8
          + dig9
          + dig10
          + dig11
          + dig12;

       --
       SELECT MOD (l_total, 23) INTO l_rem FROM DUAL;

       --
       l_diff := 23 - l_rem;

       --
       IF l_diff = 1
       THEN
          chk_dig := 'A';
       ELSIF l_diff = 2
       THEN
          chk_dig := 'B';
       ELSIF l_diff = 3
       THEN
          chk_dig := 'C';
       ELSIF l_diff = 4
       THEN
          chk_dig := 'D';
       ELSIF l_diff = 5
       THEN
          chk_dig := 'E';
       ELSIF l_diff = 6
       THEN
          chk_dig := 'F';
       ELSIF l_diff = 7
       THEN
          chk_dig := 'G';
       ELSIF l_diff = 8
       THEN
          chk_dig := 'H';
       ELSIF l_diff = 9
       THEN
          chk_dig := 'J';
       ELSIF l_diff = 10
       THEN
          chk_dig := 'K';
       ELSIF l_diff = 11
       THEN
          chk_dig := 'L';
       ELSIF l_diff = 12
       THEN
          chk_dig := 'M';
       ELSIF l_diff = 13
       THEN
          chk_dig := 'N';
       ELSIF l_diff = 14
       THEN
          chk_dig := 'P';
       ELSIF l_diff = 15
       THEN
          chk_dig := 'R';
       ELSIF l_diff = 16
       THEN
          chk_dig := 'S';
       ELSIF l_diff = 17
       THEN
          chk_dig := 'T';
       ELSIF l_diff = 18
       THEN
          chk_dig := 'U';
       ELSIF l_diff = 19
       THEN
          chk_dig := 'V';
       ELSIF l_diff = 20
       THEN
          chk_dig := 'W';
       ELSIF l_diff = 21
       THEN
          chk_dig := 'X';
       ELSIF l_diff = 22
       THEN
          chk_dig := 'Y';
       ELSIF l_diff = 23
       THEN
          chk_dig := 'Z';
       END IF;

       --
       slcno := slcno || chk_dig;

       SELECT slcno INTO v_scottish_cand FROM DUAL;

    --   DBMS_OUTPUT.PUT_LINE ('The v_scottish_cand is : '|| v_scottish_cand);
          return v_scottish_cand;
    END get_unique_slc;
 
   FUNCTION create_new_key(p_schema        IN VARCHAR2,
                           p_table_name    IN VARCHAR2,
                           p_column_name   IN VARCHAR2,
                           p_key_value     IN VARCHAR2,
                           p_old_value     IN VARCHAR2) RETURN VARCHAR2
   IS
    v_result VARCHAR2(100);
    v_sql VARCHAR2(1000);
    v_insert_sql VARCHAR2(1000);
   BEGIN
    v_sql := 'select '||p_key_value||' from dual';
    EXECUTE IMMEDIATE v_sql INTO v_result;
    
    v_insert_sql := 'insert into '||p_schema||'.ZZ_MASK_KEY_RESULT'||
                    ' (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, OLD_VALUE_CHAR, NEW_VALUE_CHAR) VALUES (:1, :2, :3, :4, :5)';
    
    
    EXECUTE IMMEDIATE v_insert_sql USING p_schema, p_table_name, p_column_name, p_old_value, SUBSTR(p_old_value,1,3)||v_result;
    
    RETURN v_result;
   END create_new_key;

   FUNCTION create_new_key(p_schema        IN VARCHAR2,
                           p_table_name    IN VARCHAR2,
                           p_column_name   IN VARCHAR2,
                           p_key_value     IN VARCHAR2,
                           p_old_value     IN NUMBER) RETURN NUMBER
   IS
    v_result NUMBER;
    v_sql VARCHAR2(1000);
    v_insert_sql VARCHAR2(1000);
   BEGIN
    v_sql := 'select '||p_key_value||' from dual';
    EXECUTE IMMEDIATE v_sql INTO v_result;
    
    v_insert_sql := 'insert into '||p_schema||'.ZZ_MASK_KEY_RESULT'||
                    ' (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, OLD_VALUE_NUMBER, NEW_VALUE_NUMBER) VALUES (:1, :2, :3, :4, :5)';
    
    
    EXECUTE IMMEDIATE v_insert_sql USING p_schema, p_table_name, p_column_name, p_old_value, v_result;
    
    RETURN v_result;
   END create_new_key;
   

   FUNCTION mask_column (p_schema        IN VARCHAR2,
                          p_table_name    IN VARCHAR2,
                          p_column_name   IN VARCHAR2,
                          p_mask_name   IN VARCHAR2,
                          p_new_key_table_name    IN VARCHAR2,
                          p_new_key_column_name   IN VARCHAR2)
                          RETURN VARCHAR2
   IS
   v_column_str VARCHAR2(32000);
   v_mask_column_name VARCHAR2(100);
   BEGIN
   CASE 
   WHEN p_mask_name = 'NEW_KEY'
   THEN
        v_column_str := p_column_name ||' = NVL((select r.new_value_number from zz_mask_key_result r where r.schema_name = '''||
                        p_schema||''' and r.table_name = '''||p_new_key_table_name||
                        ''' and r.column_name = '''||p_new_key_column_name||
                        ''' and r.old_value_number = T.'||p_column_name||'),'||p_column_name||')';
   WHEN p_mask_name = 'NEW_KEY_CHAR'
   THEN
        v_column_str := p_column_name ||' = NVL((select r.new_value_char from zz_mask_key_result r where r.schema_name = '''||
                        p_schema||''' and r.table_name = '''||p_new_key_table_name||
                        ''' and r.column_name = '''||p_new_key_column_name||
                        ''' and r.old_value_char = T.'||p_column_name||'),'||p_column_name||')';
   WHEN p_mask_name = 'STUD_DEPENDANT_NAME'
   THEN
        v_column_str := p_column_name ||' = '||'NVL((select m.'||p_column_name||
                        ' from zz_mask_stud_dependant_name m where m.std_id = T.std_id),'||p_column_name||')';                                                
   WHEN p_mask_name = 'STUD_NAME'
   THEN
        v_column_str := p_column_name ||' = '||'NVL((select m.'||p_column_name||
                        ' from zz_mask_stud_name m where m.stud_ref_no = T.stud_ref_no),'||p_column_name||')';                                                
   WHEN p_mask_name = 'NOMINEE'
   THEN
        v_column_str := p_column_name ||' = '||'NVL((select m.'||p_column_name||
                        ' from zz_mask_nominee m where m.nominee_id = T.nominee_id),'||p_column_name||')';                                                
   WHEN p_mask_name = 'BENEFACTOR'
   THEN
        v_column_str := p_column_name ||' = '||'NVL((select m.'||p_column_name||
                        ' from zz_mask_benefactor m where m.ben_id = T.ben_id),'||p_column_name||')';                                                
   WHEN p_mask_name = 'STUD_ADDRESS'
   THEN
        IF (p_column_name = 'CONT_ADDR1' OR p_column_name = 'PAYEE_ADDRL1') THEN 
            v_mask_column_name := 'ADDR_L1';
        ELSIF (p_column_name = 'CONT_ADDR2' OR p_column_name = 'PAYEE_ADDRL2') THEN 
            v_mask_column_name := 'ADDR_L2';
        ELSIF (p_column_name = 'CONT_ADDR3' OR p_column_name = 'PAYEE_ADDRL3') THEN 
            v_mask_column_name := 'ADDR_L3';
        ELSIF (p_column_name = 'CONT_POSTCODE' OR p_column_name = 'PAYEE_POSTCODE') THEN 
            v_mask_column_name := 'POST_CODE';
        ELSE 
            v_mask_column_name := p_column_name;
        END IF;
        IF (p_table_name = 'PAYMENT_INSTALMENT')
        THEN
            v_column_str := p_column_name ||' = NVL((SELECT DECODE(T.PAYMENT_METHOD,'''||'C'''||',SUBSTRB(M.'||v_mask_column_name||',1,30),t.'||p_column_name||')'|| 
                        ' from zz_mask_stud_address m where m.stud_ref_no = T.stud_ref_no),'||p_column_name||')';                                                
        ELSIF (p_table_name = 'STUD_CONT_DETAILS')
        THEN
            v_column_str := p_column_name ||' = '||'NVL((select SUBSTRB(m.'||v_mask_column_name||',1,60) '||
                        ' from zz_mask_stud_address m where m.stud_ref_no = T.stud_ref_no),'||p_column_name||')';                                                
        ELSIF (p_column_name = 'ADDR_L3' OR p_column_name = 'ADDR_L4')
        THEN
            v_column_str := p_column_name ||' = '||'NVL((select SUBSTRB(m.'||v_mask_column_name||',1,32) '||
                        ' from zz_mask_stud_address m where m.stud_ref_no = T.stud_ref_no),'||p_column_name||')';                                                
        ELSE
            v_column_str := p_column_name ||' = '||'NVL((select m.'||v_mask_column_name||
                        ' from zz_mask_stud_address m where m.stud_ref_no = T.stud_ref_no),'||p_column_name||')';                                                
        END IF;
   WHEN p_mask_name = 'STUD_EMAIL'
   THEN 
        v_column_str := p_column_name ||' = '||'NVL((select DECODE (INSTR (m.forenames, '' '||'''),0, m.forenames,'||
                       'SUBSTR (m.forenames, 1, INSTR (m.forenames, '' '||''')))||'''||'.'''||
                       '||DECODE (INSTR (m.surname, '' '||'''),0, m.surname,SUBSTR (m.surname, 1, INSTR (m.surname, '' '||
                       ''')))||'''||'@saastest.dummy'''||
                        ' from zz_mask_stud_name m where m.stud_ref_no = T.stud_ref_no),'||p_column_name||')';                                                
   WHEN p_mask_name = 'DOB'
   THEN
        v_column_str := p_column_name ||' = '||p_column_name||' + TRUNC(DBMS_RANDOM.VALUE(-11,11))';
   WHEN p_mask_name = 'SLC'
   THEN
        v_column_str := p_column_name ||' = decode(T.SCOTTISH_CAND,null,null,zz_pk_mask_database.get_unique_slc)';     
   WHEN p_mask_name = 'NINO'
   THEN
        v_column_str := p_column_name ||' = zz_pk_mask_database.get_unique_nino';     
   WHEN p_mask_name = 'ACCOUNT_NAME'
   THEN 
        v_column_str := p_column_name ||' = '||'NVL((select forenames||'' '||'''surname from zz_mask_stud_name m where m.stud_ref_no = T.stud_ref_no),'||p_column_name||')';  
   WHEN p_mask_name = 'ACCOUNT_NO'
   THEN
        IF (p_table_name = 'PAYMENT_INSTALMENT')
        THEN
            v_column_str := p_column_name ||' = DECODE(PAYMENT_METHOD,'''||'C'''||','||p_column_name||','''||'38290008'''||')';  
        ELSE           
            v_column_str := p_column_name ||' = '''||'38290008'''; 
        END IF;    
   WHEN p_mask_name = 'SORT_CODE'
   THEN
        IF (p_table_name = 'PAYMENT_INSTALMENT')
        THEN
            v_column_str := p_column_name ||' = DECODE(PAYMENT_METHOD,'''||'C'''||','||p_column_name||','''||'200415'''||')';             
        ELSE
            v_column_str := p_column_name ||' = '''||'200415''';     
        END IF;
   WHEN p_mask_name = 'NULL'
   THEN
        v_column_str := p_column_name ||' = NULL ';     
   WHEN p_mask_name = 'TEL_NO'
   THEN
        v_column_str := p_column_name ||' = '''||'078'''||'||LPAD(TRUNC(DBMS_RANDOM.VALUE(1,9999999)),7,0)';     

   ELSE -- DEFAULT CONVERSION?
        v_column_str := p_column_name ||' = '||p_column_name;
   END CASE;
      RETURN v_column_str;
   END mask_column;


   /*
   mask_recover_process will try to enable alltriggers and constraints and rebuild indexes.

   */
   PROCEDURE mask_recover_process (p_schema IN VARCHAR2)
   IS
      CURSOR C_TABLES
      IS
           SELECT T.TABLE_NAME
             FROM ZZ_MASK_TABLE T
            WHERE T.SCHEMA_NAME = P_SCHEMA
         ORDER BY T.ORDER_NUMBER;

   BEGIN
      populate_index_scripts(p_schema);
      FOR GET_REC IN C_TABLES
      LOOP
        BEGIN
           enable_triggers (p_schema, get_rec.table_name);
        EXCEPTION
           WHEN OTHERS
           THEN
              DBMS_OUTPUT.PUT_LINE (
                 'SQLCODE = ' || SQLCODE || ' SQL ERROR = ' || SQLERRM);
        END;
        DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP||'Table processed for enable_triggers: '|| get_rec.table_name);
      END LOOP;

      FOR GET_REC IN C_TABLES
      LOOP
        BEGIN
           create_indexes (p_schema, get_rec.table_name);
        EXCEPTION
           WHEN OTHERS
           THEN
              DBMS_OUTPUT.PUT_LINE (
                 'SQLCODE = ' || SQLCODE || ' SQL ERROR = ' || SQLERRM);
        END;  
        DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP||'Table processed for create_indexes: '|| get_rec.table_name);

      END LOOP;
      
    BEGIN
       enable_constraints (p_schema);
    EXCEPTION
       WHEN OTHERS
       THEN
          DBMS_OUTPUT.PUT_LINE (
             'SQLCODE = ' || SQLCODE || ' SQL ERROR = ' || SQLERRM);
    END;
        DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP||'enable_constraints completed');

      
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
          DBMS_OUTPUT.PUT_LINE (
             'SQLCODE = ' || SQLCODE || ' SQL ERROR = ' || SQLERRM);
      END mask_recover_process; 
   /*
   mask_data_process is the main process for masking data. It will process all the
   tables for the schema and mask the columns as required.

   */
   PROCEDURE mask_data_process (p_schema IN VARCHAR2)
   IS
      CURSOR C_TABLES
      IS
           SELECT T.TABLE_NAME
             FROM ZZ_MASK_TABLE T
            WHERE T.SCHEMA_NAME = P_SCHEMA
         ORDER BY T.ORDER_NUMBER;

      CURSOR C_COLUMNS (L_TABLE_NAME IN VARCHAR2)
      IS
           SELECT C.COLUMN_NAME, c.mask_name, c.new_key_table_name, c.new_key_column_name
             FROM ZZ_MASK_COLUMN C
            WHERE C.SCHEMA_NAME = P_SCHEMA AND C.TABLE_NAME = L_TABLE_NAME
         ORDER BY C.ORDER_NUMBER;
         v_table_being_processed VARCHAR2(100);
         v_update_sql VARCHAR2(32000);
         v_column_count NUMBER;
   BEGIN
      populate_index_scripts(p_schema);
--      EXECUTE IMMEDIATE 'ALTER SESSION FORCE PARALLEL DML PARALLEL 8';
      disable_constraints (p_schema);
      FOR GET_REC IN C_TABLES
      LOOP
         v_table_being_processed := get_rec.table_name;
         DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP||'mask_data_process Tables being processed: '|| v_table_being_processed);
         disable_triggers (p_schema, get_rec.table_name);
         drop_indexes (p_schema, get_rec.table_name);
      END LOOP;

      mask_keys(p_schema);
      COMMIT;
      create_mask_indexes(p_schema);
      FOR GET_REC IN C_TABLES
      LOOP
         v_table_being_processed := get_rec.table_name;
         v_update_sql := 'UPDATE /*+ PARALLEL(T,10) */ '||GET_REC.TABLE_NAME||' T SET ';
         v_column_count := 0;
         FOR get_col IN c_columns (GET_REC.TABLE_NAME)
         LOOP
            IF (v_column_count > 0)
            THEN
                v_update_sql := v_update_sql ||', ';
            END IF;
            v_column_count := v_column_count + 1;
            DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP||'mask_data_process Column being processed: '|| get_col.column_name);
            IF (v_column_count > 0)
            THEN
                v_update_sql := v_update_sql || mask_column (p_schema, get_rec.table_name, get_col.column_name, get_col.mask_name, get_col.new_key_table_name, get_col.new_key_column_name);
            END IF;
            DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP||'mask_data_process Column processed: '|| get_col.column_name);
         END LOOP;

        IF (v_column_count > 0)
        THEN
         DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP||'mask_data_process UPDATE being processed: '|| v_update_sql);
         EXECUTE IMMEDIATE v_update_sql;
         DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP||'mask_data_process UPDATE completed: '|| v_update_sql);
        END IF;

        COMMIT;
                 DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP||'mask_data_process UPDATE COMMITED: '|| v_update_sql);
      END LOOP;

      drop_mask_indexes(p_schema);

      mask_recover_process(p_schema);
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
        DBMS_OUTPUT.PUT_LINE (
         'SQLCODE = ' || SQLCODE || ' SQL ERROR = ' || SQLERRM);
         ROLLBACK;
      mask_recover_process(p_schema);

   END mask_data_process;
END;
/

