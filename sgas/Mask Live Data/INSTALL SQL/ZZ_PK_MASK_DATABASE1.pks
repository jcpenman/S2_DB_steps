CREATE OR REPLACE PACKAGE SGAS.zz_pk_mask_database
AS
   /******************************************************************************
      NAME:       zz_pk_mask_database
      PURPOSE:    After a database has been cloned, this package will transform all
                 sensitive dat.

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        14.11.2016   James Baird      Created this package
   ******************************************************************************/

    v_latest_nino varchar2(9);


   PROCEDURE disable_triggers (p_schema       IN VARCHAR2,
                               p_table_name   IN VARCHAR2);

   PROCEDURE enable_triggers (p_schema IN VARCHAR2, p_table_name IN VARCHAR2);

   PROCEDURE disable_constraints (p_schema       IN VARCHAR2);

   PROCEDURE enable_constraints (p_schema       IN VARCHAR2);

   PROCEDURE drop_indexes (p_schema IN VARCHAR2, p_table_name IN VARCHAR2);

   PROCEDURE create_indexes (p_schema IN VARCHAR2, p_table_name IN VARCHAR2);

   PROCEDURE populate_index_scripts (p_schema IN VARCHAR2);
   
   PROCEDURE mask_keys(p_schema IN VARCHAR2);
   
   PROCEDURE mask_recover_process (p_schema IN VARCHAR2);
   
   FUNCTION get_unique_nino RETURN VARCHAR2;
   
   FUNCTION get_unique_slc RETURN VARCHAR2;

   FUNCTION mask_column (p_schema        IN VARCHAR2,
                          p_table_name    IN VARCHAR2,
                          p_column_name   IN VARCHAR2,
                          p_mask_name     IN VARCHAR2,
                          p_new_key_table_name    IN VARCHAR2,
                          p_new_key_column_name   IN VARCHAR2) RETURN VARCHAR2;

   FUNCTION CREATE_NEW_KEY(p_schema        IN VARCHAR2,
                           p_table_name    IN VARCHAR2,
                           p_column_name   IN VARCHAR2,
                           p_key_value     IN VARCHAR2,
                           p_old_value     IN NUMBER) RETURN NUMBER;
                           
   FUNCTION CREATE_NEW_KEY(p_schema        IN VARCHAR2,
                           p_table_name    IN VARCHAR2,
                           p_column_name   IN VARCHAR2,
                           p_key_value     IN VARCHAR2,
                           p_old_value     IN VARCHAR2) RETURN VARCHAR2;
   
   PROCEDURE mask_data_process (p_schema IN VARCHAR2);
END zz_pk_mask_database;
/