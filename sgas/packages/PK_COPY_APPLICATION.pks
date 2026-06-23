CREATE OR REPLACE PACKAGE SGAS.pk_copy_application
AS
   /******************************************************************************
      NAME:       pk_copy_application
      PURPOSE:    To allow the copying of an application from one database to another

      REVISIONS:
      Ver        Date        Author                    Description
      ---------  ----------  ---------------           ------------------------------------
      1.0        13/03/2017  James Baird               Initial version
   ******************************************************************************/

   PROCEDURE generate_inserts (stud_ref_no_in   IN NUMBER,
                               show_debug       IN VARCHAR2 DEFAULT 'N');

   PROCEDURE delete_student (stud_ref_no_in IN NUMBER);

   PROCEDURE dbms_output_put_line (output_line IN VARCHAR2);

   FUNCTION get_sequence (copy_type              IN VARCHAR2,
                          copy_run_id            IN NUMBER,
                          table_name             IN VARCHAR2,
                          column_name            IN VARCHAR2,
                          transformation_value   IN VARCHAR2,
                          orig_value             IN NUMBER)
      RETURN NUMBER;

   FUNCTION get_sequence (copy_type              IN VARCHAR2,
                          copy_run_id            IN NUMBER,
                          table_name             IN VARCHAR2,
                          column_name            IN VARCHAR2,
                          transformation_value   IN VARCHAR2,
                          orig_value             IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_newkey (copy_type              IN VARCHAR2,
                        copy_run_id            IN NUMBER,
                        transformation_value   IN VARCHAR2,
                        column_name            IN VARCHAR2,
                        orig_value             IN NUMBER)
      RETURN NUMBER;

   FUNCTION get_newkey_char (copy_type              IN VARCHAR2,
                             copy_run_id            IN NUMBER,
                             transformation_value   IN VARCHAR2,
                             column_name            IN VARCHAR2,
                             orig_char_value        IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_transformed_value (copy_type              IN VARCHAR2,
                                   copy_run_id            IN NUMBER,
                                   table_name             IN VARCHAR2,
                                   column_name            IN VARCHAR2,
                                   transformation_value   IN VARCHAR2,
                                   orig_value             IN VARCHAR2)
      RETURN VARCHAR2;


   v_latest_nino        VARCHAR2 (9) := 'AA000001A';
   v_debug              VARCHAR2 (1) := 'N';
   v_insert_statement   VARCHAR2 (32767);

   FUNCTION get_unique_nino
      RETURN VARCHAR2;

   FUNCTION get_unique_slc
      RETURN VARCHAR2;
END pk_copy_application;
/