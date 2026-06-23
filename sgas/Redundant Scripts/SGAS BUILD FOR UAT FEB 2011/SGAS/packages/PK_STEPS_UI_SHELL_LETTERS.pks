CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_shell_letters
AS
/******************************************************************************
   NAME:       pk_steps_ui_SHELL_LETTERS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/11/2008      PADDY GRACE Created this package.
******************************************************************************/
   TYPE shelllist_cursor IS REF CURSOR;

   PROCEDURE getshellconfig (
      shell_path_out                OUT NOCOPY   VARCHAR2,
      shell_type_out                OUT NOCOPY   VARCHAR2,
      shell_client_target_dir_out   OUT NOCOPY   VARCHAR2,
      shell_server_target_dir_out   OUT NOCOPY   VARCHAR2,
      shell_tele_no_out             OUT          VARCHAR2,
      error_boolean                 OUT NOCOPY   VARCHAR2,
      ERROR_TEXT                    OUT NOCOPY   VARCHAR2
   );

   PROCEDURE getshelllist (
      io_cursor       IN OUT          shelllist_cursor,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2
   );
END pk_steps_ui_shell_letters; 
/

