CREATE OR REPLACE PACKAGE BODY SGAS.pk_copy_application
AS
   /******************************************************************************
      NAME:       pk_copy_application
      PURPOSE:    To allow the copying of an application from one database to another

      REVISIONS:
      Ver        Date        Author                    Description
      ---------  ----------  ---------------           ------------------------------------
      1.0        13/03/2017  James Baird               Initial version
   ******************************************************************************/


   /******************************************************************************
      NAME:       get_sequence
      PURPOSE:    From the old key and sequence, the new key is found and returned.
      An audit row will be inserted into the UTIL_COPY_AUDIT_KEY table.

   ******************************************************************************/
   FUNCTION get_sequence (copy_type              IN VARCHAR2,
                          copy_run_id            IN NUMBER,
                          table_name             IN VARCHAR2,
                          column_name            IN VARCHAR2,
                          transformation_value   IN VARCHAR2,
                          orig_value             IN NUMBER)
      RETURN NUMBER
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      v_new_value              NUMBER (10);
      v_dummy                  NUMBER (10);
      v_plus                   NUMBER (10);
      v_transformation_value   VARCHAR2 (1000);
   BEGIN
      IF NVL (INSTR (transformation_value, '+'), 0) > 0
      THEN
         v_plus :=
            SUBSTR (transformation_value,
                    INSTR (transformation_value, '+') + 1,
                    LENGTH (transformation_value));
         v_transformation_value :=
            SUBSTR (transformation_value,
                    1,
                    INSTR (transformation_value, '+') - 1);
      ELSE
         v_plus := 0;
         v_transformation_value := transformation_value;
      END IF;

      LOOP
         EXECUTE IMMEDIATE
            'select ' || v_transformation_value || '  from dual'
            INTO v_new_value;

         v_new_value := v_new_value + v_plus;

         IF table_name NOT LIKE '%_AUD'
         THEN
            BEGIN
               EXECUTE IMMEDIATE
                     'select '
                  || column_name
                  || ' from '
                  || table_name
                  || ' where '
                  || column_name
                  || ' = '
                  || TO_CHAR (v_new_value)
                  INTO v_dummy;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  EXIT;
            END;
         ELSE
            EXIT;
         END IF;
      END LOOP;

      IF TABLE_NAME = 'STUD' AND COLUMN_NAME = 'STUD_REF_NO'
      THEN
         EXECUTE IMMEDIATE
            'DELETE FROM UTIL_COPY_RUN_KEYS WHERE COPY_RUN_ID = :1'
            USING copy_run_id;
      END IF;

      INSERT INTO util_copy_run_keys (copy_type,
                                      copy_run_id,
                                      table_name,
                                      column_name,
                                      original_value,
                                      new_value)
           VALUES (copy_type,
                   copy_run_id,
                   table_name,
                   column_name,
                   orig_value,
                   v_new_value);

      COMMIT;
      RETURN v_new_value;
   END get_sequence;

   FUNCTION get_sequence (copy_type              IN VARCHAR2,
                          copy_run_id            IN NUMBER,
                          table_name             IN VARCHAR2,
                          column_name            IN VARCHAR2,
                          transformation_value   IN VARCHAR2,
                          orig_value             IN VARCHAR2)
      RETURN VARCHAR2
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      v_new_value   VARCHAR2 (100);
   BEGIN
      EXECUTE IMMEDIATE 'select ' || transformation_value || '  from dual'
         INTO v_new_value;

      INSERT INTO util_copy_run_keys (copy_type,
                                      copy_run_id,
                                      table_name,
                                      column_name,
                                      original_char_value,
                                      new_char_value)
           VALUES (copy_type,
                   copy_run_id,
                   table_name,
                   column_name,
                   orig_value,
                   v_new_value);

      COMMIT;
      RETURN v_new_value;
   END get_sequence;

   /******************************************************************************
      NAME:       get_transformed_value
      PURPOSE:    From the old key and sequence, the new key is found and returned.
      An audit row will be inserted into the UTIL_COPY_AUDIT_KEY table.

   ******************************************************************************/
   FUNCTION get_transformed_value (copy_type              IN VARCHAR2,
                                   copy_run_id            IN NUMBER,
                                   table_name             IN VARCHAR2,
                                   column_name            IN VARCHAR2,
                                   transformation_value   IN VARCHAR2,
                                   orig_value             IN VARCHAR2)
      RETURN VARCHAR2
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      v_new_value   VARCHAR2 (1000);
   BEGIN
      CASE
         WHEN transformation_value = 'NINO'
         THEN
            v_new_value := get_unique_nino ();
         WHEN transformation_value = 'SCOTTISH_CAND'
         THEN
            v_new_value := get_unique_slc ();
         ELSE
            NULL;                                  -- THIS SHOULD NEVER HAPPEN
            DBMS_OUTPUT.PUT_LINE (
                  'get_transformed_value HAD UNEXPECTED TRANSFORMATION VALUE: '
               || transformation_value);
      END CASE;

      INSERT INTO util_copy_run_keys (copy_type,
                                      copy_run_id,
                                      table_name,
                                      column_name,
                                      original_char_value,
                                      new_char_value)
           VALUES (copy_type,
                   copy_run_id,
                   table_name,
                   column_name,
                   orig_value,
                   v_new_value);

      COMMIT;
      RETURN v_new_value;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE (
            'get_transformed_value EXCEPTION: ' || transformation_value);
   END get_transformed_value;

   /******************************************************************************
      NAME:       get_newkey
      PURPOSE:    From the oldkey, yopy type, table name and instance, the value
       of the new key is found and returned.

   ******************************************************************************/
   FUNCTION get_newkey (copy_type              IN VARCHAR2,
                        copy_run_id            IN NUMBER,
                        transformation_value   IN VARCHAR2,
                        column_name            IN VARCHAR2,
                        orig_value             IN NUMBER)
      RETURN NUMBER
   IS
      V_NEW_VALUE     NUMBER (10);
      v_table_name    VARCHAR2 (100);
      v_column_name   VARCHAR2 (100);
   BEGIN
      v_table_name :=
         SUBSTR (transformation_value,
                 1,
                 INSTR (transformation_value, '.') - 1);
      v_column_name :=
         SUBSTR (transformation_value,
                 INSTR (transformation_value, '.') + 1,
                 LENGTH (transformation_value));

      EXECUTE IMMEDIATE
            'select new_value from util_copy_run_keys where copy_type = '''
         || copy_type
         || ''' and copy_run_id = '
         || copy_run_id
         || ' and table_name = '''
         || v_table_name
         || ''' and column_name = '''
         || v_column_name
         || ''' and original_value = '
         || orig_value
         INTO v_new_value;

      RETURN v_new_value;
   END get_newkey;

   FUNCTION get_newkey_char (copy_type              IN VARCHAR2,
                             copy_run_id            IN NUMBER,
                             transformation_value   IN VARCHAR2,
                             column_name            IN VARCHAR2,
                             orig_char_value        IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_new_value     VARCHAR2 (100);
      v_table_name    VARCHAR2 (100);
      v_column_name   VARCHAR2 (100);
   BEGIN
      v_table_name :=
         SUBSTR (transformation_value,
                 1,
                 INSTR (transformation_value, '.') - 1);
      v_column_name :=
         SUBSTR (transformation_value,
                 INSTR (transformation_value, '.') + 1,
                 LENGTH (transformation_value));

      EXECUTE IMMEDIATE
            'select new_char_value from util_copy_run_keys where copy_type = '''
         || copy_type
         || ''' and copy_run_id = '
         || copy_run_id
         || ' and table_name = '''
         || v_table_name
         || ''' and column_name = '''
         || v_column_name
         || ''' and original_char_value = '''
         || orig_char_value
         || ''''
         INTO v_new_value;

      RETURN v_new_value;
   END get_newkey_char;

   /* This will derive a unique national insurance number
      The latest nino will be stored in the package variable v_latest_nino */
   FUNCTION get_unique_nino
      RETURN VARCHAR2
   IS
      --  zz_mask_nino_seq
      v_first_char      VARCHAR2 (16) := 'ACEGHJLMPRSTUWXY';
      v_second_char     VARCHAR2 (16) := 'ACEGHJLMPRSTUWXY';
      v_last_char       VARCHAR2 (4) := 'ABCD';
      v_padded_number   VARCHAR2 (6);
   BEGIN
      SELECT LPAD (util_copy_nino_seq.NEXTVAL, 6, '0')
        INTO v_padded_number
        FROM DUAL;

      CASE
         WHEN v_padded_number = '000001' AND v_latest_nino IS NOT NULL
         THEN
            IF (SUBSTR (v_latest_nino, 2, 1) != 'Y')
            THEN
               v_latest_nino :=
                     SUBSTR (v_latest_nino, 1, 1)
                  || SUBSTR (
                        v_second_char,
                          INSTR (v_second_char, SUBSTR (v_latest_nino, 2, 1))
                        + 1,
                        1)
                  || v_padded_number
                  || 'A';
            ELSE
               v_latest_nino :=
                     SUBSTR (
                        v_first_char,
                          INSTR (v_first_char, SUBSTR (v_latest_nino, 1, 1))
                        + 1,
                        1)
                  || 'A'
                  || v_padded_number
                  || 'A';
            END IF;
         WHEN v_padded_number = '000001' AND v_latest_nino IS NULL
         THEN
            v_latest_nino := 'AA' || v_padded_number || 'A';
         ELSE
            v_latest_nino :=
                  SUBSTR (v_latest_nino, 1, 2)
               || v_padded_number
               || SUBSTR (v_latest_nino, 9, 1);
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

      slcno :=
         LTRIM (RTRIM (l_sess)) || LTRIM (RTRIM (TO_CHAR (slc, '000000')));
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
      RETURN v_scottish_cand;
   END get_unique_slc;


   /******************************************************************************
      NAME:       dbms_output_put_line
      PURPOSE:    If the package variable v_debug is N, then the sql needs built
      and run, otherwise the debug lines will be output. These output lines can
      then be run manually and will produce the insert statements for the
      destination database.

   ******************************************************************************/

   PROCEDURE dbms_output_put_line (output_line IN VARCHAR2)
   IS
   BEGIN
      IF v_debug = 'Y'
      THEN
         DBMS_OUTPUT.PUT_LINE (output_line);
      ELSE
         v_insert_statement := v_insert_statement || output_line || CHR (10);
      END IF;
   END dbms_output_put_line;

   /******************************************************************************
      NAME:       generate_inserts
      PURPOSE:    Enter a STUD_REF_NO and a file will be produced that will insert
      all of the data for that application. The file can then be run in any other STEPS
      database.

   ******************************************************************************/
   PROCEDURE generate_inserts (stud_ref_no_in   IN NUMBER,
                               show_debug       IN VARCHAR2 DEFAULT 'N')
   IS
      CURSOR C_TABLES
      IS
           SELECT *
             FROM UTIL_COPY_TABLE UCT
            WHERE COPY_TYPE = 'STUDENT_APPLICATION'
         ORDER BY INSERT_ORDER_NUMBER;

      CURSOR C_COLUMNS (
         L_TABLE_NAME    VARCHAR2)
      IS
           SELECT C.COLUMN_NAME,
                  C.COLUMN_ID,
                  C.DATA_TYPE,
                  UC.IS_VARCHAR,
                  CASE
                     WHEN     NVL (UC.TRANSFORMATION_TYPE, 'NONE') = 'NONE'
                          AND C.DATA_TYPE = 'DATE'
                     THEN
                        'DATE'
                     WHEN     NVL (UC.TRANSFORMATION_TYPE, 'NONE') = 'NONE'
                          AND C.DATA_TYPE = 'NUMBER'
                     THEN
                        'NUMBER'
                     WHEN     NVL (UC.TRANSFORMATION_TYPE, 'NONE') = 'NONE'
                          AND C.DATA_TYPE = 'VARCHAR2'
                     THEN
                        'VARCHAR2'
                     WHEN     NVL (UC.TRANSFORMATION_TYPE, 'NONE') = 'NONE'
                          AND C.DATA_TYPE = 'CHAR'
                     THEN
                        'VARCHAR2'
                     ELSE
                        NVL (UC.TRANSFORMATION_TYPE, 'NONE')
                  END
                     TRANSFORMATION_TYPE,
                  UC.TRANSFORMATION_VALUE
             FROM all_tab_cols c, UTIL_COPY_COLUMN UC
            WHERE     C.OWNER = 'SGAS'
                  AND C.TABLE_NAME = L_TABLE_NAME
                  AND C.TABLE_NAME = UC.TABLE_NAME(+)
                  AND C.COLUMN_NAME = UC.COLUMN_NAME(+)
                  AND C.VIRTUAL_COLUMN = 'NO'
         ORDER BY COLUMN_ID;

      CURSOR C_DISTINCT_COLUMNS
      IS
           SELECT DISTINCT C.COLUMN_NAME
             FROM UTIL_COPY_COLUMN C
         ORDER BY 1;

      V_COPY_RUN_ID       NUMBER (10);
      V_COPY_TYPE         VARCHAR2 (100);
      V_ADD_DEFINE_LINE   VARCHAR2 (1) := 'Y';
      V_COLUMNS_COUNT     NUMBER;
      V_INSERT            VARCHAR2 (32000);
      V_SELECT            VARCHAR2 (32000);
      V_FROM              VARCHAR2 (32000);
      V_WHERE             VARCHAR2 (32000);
      V_SQL               VARCHAR2 (32000);
      V_VALUES            VARCHAR2 (32000);
      V_BLANK             VARCHAR2 (1) := ' ';
      V_FOR_LOOP          VARCHAR2 (100) := ' FOR R_REC IN (';
   BEGIN
      v_copy_type := 'STUDENT_APPLICATION';
      v_debug := show_debug;

      INSERT INTO UTIL_COPY_RUN (COPY_TYPE, COPY_RUN_ID, COPY_RUN_DATE)
           VALUES (V_COPY_TYPE,
                   (SELECT NVL (MAX (COPY_RUN_ID), 0) + 1
                      FROM UTIL_COPY_RUN
                     WHERE COPY_TYPE = V_COPY_TYPE),
                   SYSDATE)
        RETURNING COPY_RUN_ID
             INTO V_COPY_RUN_ID;

      FOR GET_TAB IN C_TABLES
      LOOP
         v_insert_statement := NULL;
         dbms_output_put_line ('DECLARE ');
         dbms_output_put_line ('-- VARIABLES IF NEEDED');
         dbms_output_put_line ('N_INSERT  VARCHAR2(32000);');
         dbms_output_put_line ('N_VALUES  VARCHAR2(32000);');
         dbms_output_put_line ('N_SQL     VARCHAR2(32000);');
         dbms_output_put_line ('BEGIN ');
         dbms_output_put_line (
            '     DBMS_OUTPUT.ENABLE (BUFFER_SIZE => NULL);');

         IF V_ADD_DEFINE_LINE = 'Y'
         THEN
            dbms_output_put_line (
               '     DBMS_OUTPUT.PUT_LINE (''' || 'SET DEFINE OFF''' || ');');
            V_ADD_DEFINE_LINE := 'N';
         END IF;

         dbms_output_put_line (
               ' -- Table : '
            || GET_TAB.INSERT_ORDER_NUMBER
            || ' '
            || GET_TAB.TABLE_NAME);
         -- build sql to get rows from table
         V_INSERT := 'INSERT INTO ' || GET_TAB.TABLE_NAME || ' (';
         V_COLUMNS_COUNT := 0;
         V_SELECT := ' SELECT ';
         V_FROM := ' FROM ' || GET_TAB.TABLE_NAME || ' ';
         V_WHERE :=
               ' WHERE '
            || REPLACE (GET_TAB.INSERT_CONDITION, ':1', stud_ref_no_in);
         V_VALUES := ' VALUES ( ';


         FOR GET_COL IN C_COLUMNS (GET_TAB.TABLE_NAME)
         LOOP
            IF V_COLUMNS_COUNT = 0
            THEN
               V_INSERT := V_INSERT || GET_COL.COLUMN_NAME;
               V_SELECT := V_SELECT || GET_COL.COLUMN_NAME;

               CASE
                  WHEN GET_COL.TRANSFORMATION_TYPE = 'SEQUENCE'
                  THEN
                     V_VALUES :=
                           V_VALUES
                        || ' pk_copy_application.get_sequence (copy_type => '''
                        || v_copy_type
                        || ''',
                          copy_run_id           =>  '
                        || v_copy_run_id
                        || ',
                          table_name            => '''
                        || GET_TAB.TABLE_NAME
                        || ''',
                          column_name           => '''
                        || GET_COL.COLUMN_NAME
                        || ''',
                          transformation_value  => '''
                        || GET_COL.TRANSFORMATION_VALUE;

                     IF GET_COL.IS_VARCHAR = 'Y'
                     THEN
                        V_VALUES :=
                              V_VALUES
                           || ''',
                          orig_value            => '''
                           || 'R_REC.'
                           || GET_COL.COLUMN_NAME
                           || '||'''
                           || ' ) ';
                     ELSE
                        V_VALUES :=
                              V_VALUES
                           || ''',
                          orig_value            => R_REC.'
                           || GET_COL.COLUMN_NAME
                           || '|| ) ';
                     END IF;
                  WHEN GET_COL.TRANSFORMATION_TYPE = 'NEWKEY'
                  THEN
                     V_VALUES := V_VALUES || CHR (10);

                     IF GET_COL.IS_VARCHAR = 'Y'
                     THEN
                        V_VALUES :=
                              V_VALUES
                           || '         pk_copy_application.get_newkey_char (copy_type => ''';
                     ELSE
                        V_VALUES :=
                              V_VALUES
                           || '         pk_copy_application.get_newkey (copy_type => ''';
                     END IF;

                     V_VALUES :=
                           V_VALUES
                        || v_copy_type
                        || ''',
                          copy_run_id           =>  '
                        || v_copy_run_id
                        || ',
                          transformation_value            => '''
                        || GET_COL.TRANSFORMATION_VALUE
                        || ''',
                          column_name           => '''
                        || GET_COL.COLUMN_NAME;

                     IF GET_COL.IS_VARCHAR = 'Y'
                     THEN
                        V_VALUES :=
                              V_VALUES
                           || ''',
                          orig_char_value            => '''
                           || 'R_REC.'
                           || GET_COL.COLUMN_NAME
                           || '||'''
                           || ' ) ';
                     ELSE
                        V_VALUES :=
                              V_VALUES
                           || ''',
                          orig_value            => R_REC.'
                           || GET_COL.COLUMN_NAME
                           || '|| ) ';
                     END IF;
                  WHEN    GET_COL.TRANSFORMATION_TYPE = 'NINO'
                       OR GET_COL.TRANSFORMATION_TYPE = 'SCOTTISH_CAND'
                  THEN
                     V_VALUES :=
                           V_VALUES
                        || ' pk_copy_application.get_transformed_value (copy_type => '''
                        || v_copy_type
                        || ''',
                          copy_run_id           =>  '
                        || v_copy_run_id
                        || ',
                          table_name            => '''
                        || GET_TAB.TABLE_NAME
                        || ''',
                          column_name           => '''
                        || GET_COL.COLUMN_NAME
                        || ''',
                          transformation_value  => '''
                        || GET_COL.TRANSFORMATION_VALUE
                        || ''',
                          orig_value            => '''
                        || 'R_REC.'
                        || GET_COL.COLUMN_NAME
                        || '||'''
                        || ' ) ';
                  WHEN GET_COL.TRANSFORMATION_TYPE = 'NUMBER'
                  THEN
                     V_VALUES :=
                           V_VALUES
                        || ' %NUM1%'
                        || 'R_REC.'
                        || GET_COL.COLUMN_NAME
                        || ' %NUM2% ';
                  WHEN GET_COL.TRANSFORMATION_TYPE = 'DATE'
                  THEN
                     V_VALUES :=
                           V_VALUES
                        || ' %DATE1%'
                        || 'R_REC.'
                        || GET_COL.COLUMN_NAME
                        || ' %DATE2% ';
                  WHEN GET_COL.TRANSFORMATION_TYPE = 'VARCHAR2'
                  THEN
                     V_VALUES :=
                           V_VALUES
                        || ' %VAR1%'
                        || 'R_REC.'
                        || GET_COL.COLUMN_NAME
                        || ' %VAR2% ';
                  ELSE
                     V_VALUES :=
                           V_VALUES
                        || ' %%%'
                        || 'R_REC.'
                        || GET_COL.COLUMN_NAME
                        || ' £££ ';
               END CASE;
            ELSE
               V_INSERT := V_INSERT || ',' || GET_COL.COLUMN_NAME;
               V_SELECT := V_SELECT || ',' || GET_COL.COLUMN_NAME;

               CASE
                  WHEN GET_COL.TRANSFORMATION_TYPE = 'SEQUENCE'
                  THEN
                     V_VALUES :=
                           V_VALUES
                        || ','
                        || ' pk_copy_application.get_sequence (copy_type => '''
                        || v_copy_type
                        || ''',
                          copy_run_id           =>  '
                        || v_copy_run_id
                        || ',
                          table_name            => '''
                        || GET_TAB.TABLE_NAME
                        || ''',
                          column_name           => '''
                        || GET_COL.COLUMN_NAME
                        || ''',
                          transformation_value  => '''
                        || GET_COL.TRANSFORMATION_VALUE;

                     IF GET_COL.IS_VARCHAR = 'Y'
                     THEN
                        V_VALUES :=
                              V_VALUES
                           || ''',
                          orig_value            => '''
                           || 'R_REC.'
                           || GET_COL.COLUMN_NAME
                           || '||'''
                           || ' ) ';
                     ELSE
                        V_VALUES :=
                              V_VALUES
                           || ''',
                          orig_value            => R_REC.'
                           || GET_COL.COLUMN_NAME
                           || '|| ) ';
                     END IF;
                  WHEN GET_COL.TRANSFORMATION_TYPE = 'NEWKEY'
                  THEN
                     V_VALUES := V_VALUES || CHR (10) || ',';

                     IF GET_COL.IS_VARCHAR = 'Y'
                     THEN
                        V_VALUES :=
                              V_VALUES
                           || '         pk_copy_application.get_newkey_char (copy_type => ''';
                     ELSE
                        V_VALUES :=
                              V_VALUES
                           || '         pk_copy_application.get_newkey (copy_type => ''';
                     END IF;

                     V_VALUES :=
                           V_VALUES
                        || v_copy_type
                        || ''',
                          copy_run_id           =>  '
                        || v_copy_run_id
                        || ',
                          transformation_value            => '''
                        || GET_COL.TRANSFORMATION_VALUE
                        || ''',
                          column_name           => '''
                        || GET_COL.COLUMN_NAME;

                     IF GET_COL.IS_VARCHAR = 'Y'
                     THEN
                        V_VALUES :=
                              V_VALUES
                           || ''',
                          orig_char_value            => '''
                           || 'R_REC.'
                           || GET_COL.COLUMN_NAME
                           || '||'''
                           || ' ) ';
                     ELSE
                        V_VALUES :=
                              V_VALUES
                           || ''',
                          orig_value            => R_REC.'
                           || GET_COL.COLUMN_NAME
                           || '|| ) ';
                     END IF;
                  WHEN    GET_COL.TRANSFORMATION_TYPE = 'NINO'
                       OR GET_COL.TRANSFORMATION_TYPE = 'SCOTTISH_CAND'
                  THEN
                     V_VALUES :=
                           V_VALUES
                        || CHR (10)
                        || ','
                        || ' pk_copy_application.get_transformed_value (copy_type => '''
                        || v_copy_type
                        || ''',
                          copy_run_id           =>  '
                        || v_copy_run_id
                        || ',
                          table_name            => '''
                        || GET_TAB.TABLE_NAME
                        || ''',
                          column_name           => '''
                        || GET_COL.COLUMN_NAME
                        || ''',
                          transformation_value  => '''
                        || GET_COL.TRANSFORMATION_VALUE
                        || ''',
                          orig_value            => '''
                        || 'R_REC.'
                        || GET_COL.COLUMN_NAME
                        || '||'''
                        || ' ) ';
                  WHEN GET_COL.TRANSFORMATION_TYPE = 'NUMBER'
                  THEN
                     V_VALUES :=
                           V_VALUES
                        || ', %NUM1%'
                        || 'R_REC.'
                        || GET_COL.COLUMN_NAME
                        || ' %NUM2% ';
                  WHEN GET_COL.TRANSFORMATION_TYPE = 'DATE'
                  THEN
                     V_VALUES :=
                           V_VALUES
                        || ', %DATE1%'
                        || 'R_REC.'
                        || GET_COL.COLUMN_NAME
                        || ' %DATE2% ';
                  WHEN GET_COL.TRANSFORMATION_TYPE = 'VARCHAR2'
                  THEN
                     V_VALUES :=
                           V_VALUES
                        || ', %VAR1%'
                        || 'R_REC.'
                        || GET_COL.COLUMN_NAME
                        || ' %VAR2% ';
                  ELSE
                     V_VALUES :=
                           V_VALUES
                        || ', %%%'
                        || 'R_REC.'
                        || GET_COL.COLUMN_NAME
                        || ' £££ ';
               END CASE;
            END IF;

            V_COLUMNS_COUNT := V_COLUMNS_COUNT + 1;
         END LOOP;

         V_INSERT := V_INSERT || ') ';
         V_VALUES := V_VALUES || ' ); ';

         V_SQL := V_SELECT || ' ' || V_FROM || ' ' || V_WHERE;
         dbms_output_put_line (V_FOR_LOOP || V_SQL || ')');
         dbms_output_put_line (' LOOP');

         V_VALUES :=
            REPLACE (V_VALUES,
                     CHR (39),
                     CHR (39) || CHR (39) || CHR (39) || '||' || CHR (39));

         FOR GET_COL IN C_COLUMNS (GET_TAB.TABLE_NAME)
         LOOP
            V_VALUES :=
               REPLACE (
                  V_VALUES,
                  'R_REC.' || GET_COL.COLUMN_NAME || '||',
                     CHR (39)
                  || '||R_REC.'
                  || GET_COL.COLUMN_NAME
                  || '||'
                  || CHR (39));
         END LOOP;



         V_VALUES := REPLACE (V_VALUES, '%%%', CHR (39) || '||');
         V_VALUES := REPLACE (V_VALUES, '£££', '||' || CHR (39));

         V_VALUES := REPLACE (V_VALUES, '%NUM1%', CHR (39) || '||NVL(');
         V_VALUES := REPLACE (V_VALUES, '%NUM2%', ',-999)||' || CHR (39));

         V_VALUES :=
            REPLACE (V_VALUES,
                     '%DATE1%',
                     CHR (39) || '||''' || '%NDATE1%''' || '||TO_CHAR(');
         V_VALUES :=
            REPLACE (
               V_VALUES,
               '%DATE2%',
                  ','''
               || 'DD/MM/YYYY HH24:MI:SS'''
               || ')||'''
               || '%NDATE2%'''
               || '||'
               || CHR (39));

         V_VALUES :=
            REPLACE (
               V_VALUES,
               '%VAR1%',
                  CHR (39)
               || '||'''
               || 'q'''
               || '||CHR(39)||'''
               || '#'''
               || '||');
         V_VALUES :=
            REPLACE (V_VALUES,
                     '%VAR2%',
                     '||''' || '#''' || '||CHR (39)||' || CHR (39));

         dbms_output_put_line ('N_INSERT := ''' || V_INSERT || ''';');
         dbms_output_put_line ('N_VALUES := ''' || V_VALUES || ''';');
         dbms_output_put_line (
               'N_VALUES := REPLACE(N_VALUES,'''
            || '-999'''
            || ','''
            || 'NULL'''
            || ');');
         dbms_output_put_line (
               'N_VALUES := REPLACE(N_VALUES,'''
            || '%NDATE1%%NDATE2%'''
            || ','''
            || 'NULL'''
            || ');');

         dbms_output_put_line (
               'N_VALUES := REPLACE(N_VALUES,'''
            || '%NDATE1%'''
            || ','''
            || 'TO_DATE('''
            || CHR (39)
            || ''');');
         dbms_output_put_line (
               'N_VALUES := REPLACE(N_VALUES,'''
            || '%NDATE2%'''
            || ','
            || CHR (39)
            || CHR (39)
            || CHR (39)
            || ','
            || CHR (39)
            || CHR (39)
            || CHR (39)
            || '||'''
            || 'DD/MM/YYYY HH24:MI:SS'''
            || CHR (39)
            || '''||'''
            || ')'''
            || ');');

         dbms_output_put_line (
               'N_VALUES := REPLACE(N_VALUES,'''
            || 'orig_value            =>  )'''
            || ','''
            || 'orig_value            => -1 )'''
            || ');');



         dbms_output_put_line ('DBMS_OUTPUT.PUT_LINE (N_INSERT);');
         dbms_output_put_line ('DBMS_OUTPUT.PUT_LINE (N_VALUES);');

         -- build the insert into list
         -- build the values list transforming any columns that need transformed

         dbms_output_put_line (
               'DBMS_OUTPUT.PUT_LINE ('''
            || '--'
            || GET_TAB.TABLE_NAME
            || ' rows inserted : '''
            || '||SQL%ROWCOUNT'
            || ');');
         dbms_output_put_line (' END LOOP;');

         dbms_output_put_line ('EXCEPTION');
         dbms_output_put_line ('WHEN OTHERS');
         dbms_output_put_line ('     THEN');
         dbms_output_put_line (
               'DBMS_OUTPUT.PUT_LINE ('''
            || GET_TAB.TABLE_NAME
            || ' has ERROR'''
            || ');');
         dbms_output_put_line (
            'DBMS_OUTPUT.PUT_LINE (SQLERRM || TO_CHAR(SQLCODE));');
         dbms_output_put_line ('END; ');

         IF v_debug = 'N'
         THEN
            --       DBMS_OUTPUT.PUT_LINE (v_insert_statement);
            EXECUTE IMMEDIATE v_insert_statement;
         END IF;
      END LOOP;


      IF v_debug = 'N'
      THEN
         v_insert_statement := NULL;
         dbms_output_put_line (
            '     DBMS_OUTPUT.PUT_LINE (''' || 'COMMIT;''' || ');');

         EXECUTE IMMEDIATE ' BEGIN ' || v_insert_statement || ' END;';
      ELSE
         dbms_output_put_line (
               '     BEGIN DBMS_OUTPUT.PUT_LINE ('''
            || ' COMMIT;'''
            || '); END;');
      END IF;
   END generate_inserts;

   /******************************************************************************
      NAME:       delete_student
      PURPOSE:    Enter a STUD_REF_NO to delete
      all of the data for that application.

   ******************************************************************************/
   PROCEDURE delete_student (stud_ref_no_in IN NUMBER)
   IS
      CURSOR C_TABLES
      IS
           SELECT    ' DELETE FROM '
                  || T.TABLE_NAME
                  || ' WHERE '
                  || T.INSERT_CONDITION
                  || ';'
                     DEL_STATEMENT,
                  T.TABLE_NAME
             FROM UTIL_COPY_TABLE T
         ORDER BY T.INSERT_ORDER_NUMBER DESC;

      V_BEGIN     VARCHAR2 (1000);
      V_DELETE    VARCHAR2 (4000);
      V_DELETED   VARCHAR2 (1000);
      V_END       VARCHAR2 (1000);
      V_BLOCK     VARCHAR2 (32000);
   BEGIN
      V_BEGIN := 'DECLARE BEGIN ';

      V_END :=
         'EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE (SQLERRM || TO_CHAR(SQLCODE)); END;';

      FOR GET_REC IN C_TABLES
      LOOP
         DBMS_OUTPUT.PUT_LINE ('DELETING FROM TABLE: ' || GET_REC.TABLE_NAME);
         V_DELETE := REPLACE (GET_REC.DEL_STATEMENT, ':1', stud_ref_no_in);
         V_DELETED :=
               'DBMS_OUTPUT.PUT_LINE (
               '''
            || 'DELETED FROM '''
            || '||'''
            || GET_REC.TABLE_NAME
            || ''' ||'''
            || '  ( '''
            || '    || SQL%ROWCOUNT'
            || '||'''
            || ' ) ROWS '''
            || ');';
         V_BLOCK := V_BEGIN || V_DELETE || V_DELETED || V_END;

         EXECUTE IMMEDIATE V_BLOCK;

         DBMS_OUTPUT.PUT_LINE (' ');
         DBMS_OUTPUT.PUT_LINE (' ');
      --       DBMS_OUTPUT.PUT_LINE (V_BLOCK);
      END LOOP;

      COMMIT;
   END delete_student;
END pk_copy_application;
/