DECLARE
   CURSOR c_tab
   IS
      SELECT    'alter table '
             || t.table_name
             || ' rename to Z_'
             || t.table_name
                rename_table
        FROM all_tables t
       WHERE T.OWNER = 'SLCADMIN';
BEGIN
   FOR get_rec IN c_tab
   LOOP
      EXECUTE IMMEDIATE get_rec.rename_table;
     DBMS_OUTPUT.PUT_LINE(get_rec.rename_table);
   END LOOP;
END;