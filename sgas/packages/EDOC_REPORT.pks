CREATE OR REPLACE PACKAGE SGAS.EDOC_REPORT
AS
/***************************************************************************************************************************
   NAME:      EDOC_REPORT
   PURPOSE:
   
   CreateALLEDOCTaskReport : Create a report of ALL (outstanding and completed)
   EDOC tasks.Truncate table EDOC_ALL_TASK_REPORT and populate with latest
   information at time of report generation.
   Select all data from EDOC_CDU_TRANSFERRED and EDOC_CDU_TRANSFERRED_HISTORY
   tables and merge with data from other tables such as STUD_CRSE_YEAR, INST
   to populate INSTITUATION name and a theoretical WORKQUEUE into the resultset
   to meet the requirements of CR123 appendix2.
   This is nexessary as completed task data is not maintained in the SAG
   database.
   ComputeTheoreticalWorkQueue : Helper fucntion to calculate what the workqueue
   SHOULD have been for this item as we do not have access to the historical
   task data in the SAG database. Note that if the workqueue was reassigned then
   this calculation will be incorrect.
  
     
   REVISIONS:
   Ver        Date        Author                Description
   ---------  ----------  ---------------       ------------------------------
   1.0        27/07/2016  MIKE TOLMIE          Initial Creation
   1.1        12/09/2016  MIKE TOLMIE          Update to remove procedure EDOCDataTableRefresh as this is no longer used
                                               in favour of running the flow service from the IS as a scheduled task.
                                               Procedure Call_Is_Flow_Service is also no longer needed as this was called
                                               by procedure EDOCDataTableRefresh 
***************************************************************************************************************************/

--This function will only be used by the procedure in this package but MUST be PUBLIC (appearing in this spec) for the sql in the procedure to work
FUNCTION ComputeTheoreticalWorkQueue(crseErrorInd IN VARCHAR2,batchTypeCode IN VARCHAR2,locationInd IN VARCHAR2,nonPublicFund IN VARCHAR2,eu IN VARCHAR2,pams IN varchar2, schemeType IN VARCHAR2) RETURN VARCHAR2;
PROCEDURE CreateALLEDOCTaskReport(retVal IN OUT VARCHAR2);
END EDOC_REPORT;
/