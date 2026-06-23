CREATE OR REPLACE PACKAGE SGAS.PK_JOB_RUN_LOG
AS
   /******************************************************************************
      NAME:       PK_JOB_RUN_LOG
      PURPOSE:    To maintain the summary details in JOB_RUN_LOG.

      REVISIONS:
      Ver        Date        Author                    Description
      ---------  ----------  ---------------           ------------------------------------
      1.0        3/05/2017  James Baird               Initial version
   ******************************************************************************/


   PROCEDURE START_JOB (P_JOB_NAME             IN VARCHAR2,
                        P_JOB_RUN_LOG_ID_OUT      OUT NUMBER);

   PROCEDURE COMPLETE_JOB (P_JOB_RUN_LOG_ID_IN IN NUMBER);

   PROCEDURE COMPLETE_JOB_BY_NAME (P_JOB_NAME             IN     VARCHAR2);

   PROCEDURE UPDATE_ERROR (P_JOB_RUN_LOG_ID_IN   IN NUMBER,
                           P_ERROR_MSG           IN VARCHAR2);

   PROCEDURE UPDATE_ERROR_BY_NAME (P_JOB_NAME             IN VARCHAR2,
                           P_ERROR_MSG           IN VARCHAR2);

   PROCEDURE UPDATE_NOTES (P_JOB_RUN_LOG_ID_IN   IN NUMBER,
                           P_NOTES               IN VARCHAR2);

   PROCEDURE UPDATE_PAYMENT_SCHEDULER_NOTES (
      P_PAYMENT_RUN_DATE_IN   IN VARCHAR2);
      
   PROCEDURE JOB_STATUS (P_JOB_NAME             IN     VARCHAR2,
                        P_JOB_STATUS_OUT      OUT VARCHAR2);
 
   TYPE JOB_RUN_LOG_CURSOR IS REF CURSOR;

   PROCEDURE GET_JOB_RUN_LOG (
      P_JOB_NAME        IN             VARCHAR2,
      JRL_CURSOR        IN OUT          JOB_RUN_LOG_CURSOR,
      ERROR_BOOLEAN    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2);
     
END PK_JOB_RUN_LOG;
/