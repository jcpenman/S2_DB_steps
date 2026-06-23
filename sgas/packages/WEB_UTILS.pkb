CREATE OR REPLACE PACKAGE BODY SGAS.WEB_UTILS
AS
   FUNCTION which_db
      RETURN VARCHAR2
   IS
      ls_return_which_db   config_data.cval%TYPE;
   BEGIN
      ls_return_which_db := 'S';



      RETURN (ls_return_which_db);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN ('X');
   END which_db;
END web_utils;
/