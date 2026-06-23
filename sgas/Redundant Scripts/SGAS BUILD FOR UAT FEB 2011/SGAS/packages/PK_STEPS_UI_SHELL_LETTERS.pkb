CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_shell_letters
AS
/******************************************************************************
   NAME:       pk_steps_ui_SHELL_LETTERS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008      PADDY GRACE Created this package.
******************************************************************************/
   PROCEDURE getshellconfig (
      shell_path_out                OUT NOCOPY   VARCHAR2,
      shell_type_out                OUT NOCOPY   VARCHAR2,
      shell_client_target_dir_out   OUT NOCOPY   VARCHAR2,
      shell_server_target_dir_out   OUT NOCOPY   VARCHAR2,
      shell_tele_no_out             OUT          VARCHAR2,
      error_boolean                 OUT NOCOPY   VARCHAR2,
      ERROR_TEXT                    OUT NOCOPY   VARCHAR2
   )
   IS
   BEGIN
      SELECT shell_path.shell_path, shell_filetype.shell_filetype,
             shell_client_target_dir.shell_client_target_dir,
             shell_server_target_dir.shell_server_target_dir,
             shell_tele_no.shell_tele_no
        INTO shell_path_out, shell_type_out,
             shell_client_target_dir_out,
             shell_server_target_dir_out,
             shell_tele_no_out
        FROM (SELECT cval shell_path
                FROM config_data
               WHERE UPPER (item_name) = 'SHELL_PATH') shell_path,
             (SELECT cval shell_filetype
                FROM config_data
               WHERE UPPER (item_name) = 'SHELL_FILETYPE') shell_filetype,
             (SELECT cval shell_client_target_dir
                FROM config_data
               WHERE UPPER (item_name) = 'SHELL_TARGET_DIR') shell_client_target_dir,
             (SELECT cval shell_server_target_dir
                FROM config_data
               WHERE UPPER (item_name) = 'EDM_LOCAL_DIR') shell_server_target_dir,
             (SELECT cval shell_tele_no
                FROM config_data
               WHERE UPPER (item_name) = 'SHELL_TELE_NO') shell_tele_no;

      error_boolean := 'false';
      error_text := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getshellconfig;

   PROCEDURE getshelllist (
      io_cursor       IN OUT          shelllist_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   )
   IS
      sl_cursor   shelllist_cursor;
   BEGIN
      OPEN sl_cursor FOR
         SELECT   sl.doc_desc, sl.doc_name
             FROM std_letters sl
         ORDER BY sl.doc_name;

      error_boolean := 'false';
      error_text := 'none';
      io_cursor := sl_cursor;
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getshelllist;
END pk_steps_ui_shell_letters;
/
