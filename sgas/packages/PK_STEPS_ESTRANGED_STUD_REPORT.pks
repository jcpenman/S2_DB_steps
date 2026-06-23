CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_ESTRANGED_STUD_REPORT
AS
   /******************************************************************************************
      NAME:       PK_STEPS_ESTRANGED_STUD_REPORT
      PURPOSE:    To populate the ESTRANGED_STUD_REPORT table with the required data

      REVISIONS:
      Ver        Date        Author                    Description
      ---------  ----------  ---------------           -----------------------------
      1.0        12/12/2017  Ranj Benning              Initial version
   ******************************************************************************************/

   PROCEDURE populate_report_table;

   PROCEDURE insert_estranged_records (session_code_in IN NUMBER);

   PROCEDURE update_estranged_records (session_code_in IN NUMBER);

   FUNCTION get_default_from_date RETURN DATE;
	  
END PK_STEPS_ESTRANGED_STUD_REPORT;
/