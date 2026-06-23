CREATE OR REPLACE PACKAGE SGAS.SAAS_TEST_DATA
AS
   /******************************************************************************
      NAME:      SAAS_TEST_DATA
      PURPOSE:TEST AUTOMATION

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      0.1        17/11/2017     Paul Hughes    Creation of db package
      0.2       01/07/2020      Kara Fraser    Updated Submit Test Application Messages to cover all T&V checks.
      0.3       01/08/2020      Kara Fraser    Added auto calc cases and Check Results Autocalc procedure
      0.4       18/02/2021      Kara Fraser     Added separate procedure to submit auto calc cases only.
   ******************************************************************************/

   PROCEDURE SubmitTestApplicationsMessages;

   PROCEDURE Check_Results;

  PROCEDURE SubmitCorrespondence (schemetype          IN VARCHAR2,
                                   current_session     IN NUMBER,
                                   batch_type_code     IN NUMBER,
                                   number_of_corress      NUMBER);

   PROCEDURE SubmitAttendanceDataTasks (current_session      IN NUMBER,
                                        AttendanceDataType   IN VARCHAR2,
                                        number_of_items         NUMBER);

   PROCEDURE ProcessTask (Task_number IN NUMBER);

   PROCEDURE Test_pop_shortened_application;

   PROCEDURE Check_Results_Autocalc;

   PROCEDURE Submit_Single_Student_Enquiry (ref_no IN NUMBER);

   PROCEDURE Submit_Single_Correspondence (ref_no            IN NUMBER,
                                           batch_type_code   IN NUMBER);

   PROCEDURE SubmitTestAutoCalcApplications;
END SAAS_TEST_DATA;
/