CREATE OR REPLACE PACKAGE SGAS.pk_care_exp_apps_report
AS
   /******************************************************************************
      NAME:       pk_care_exp_apps_report
      PURPOSE:    To populate the care_experienced_apps_report table with the
                  data needed for the Care Experience report.

      REVISIONS:
      Ver        Date        Author                    Description
      ---------  ----------  ---------------           ------------------------------------
      1.0        20/04/2017  James Baird               Initial version
   ******************************************************************************/

   PROCEDURE populate_report_table;

   PROCEDURE insert_from_OLS (session_code_in IN NUMBER);

   PROCEDURE insert_from_STEPS (session_code_in IN NUMBER);

   PROCEDURE update_from_STEPS (session_code_in IN NUMBER);
   
   PROCEDURE update_from_STEPS_CESB;

   FUNCTION get_default_from_date
      RETURN DATE;
END pk_care_exp_apps_report;
/