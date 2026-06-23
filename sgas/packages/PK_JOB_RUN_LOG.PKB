CREATE OR REPLACE PACKAGE BODY SGAS.PK_JOB_RUN_LOG
AS
   /******************************************************************************
      NAME:       PK_JOB_RUN_LOG BODY
      PURPOSE:    To maintain the summary details in JOB_RUN_LOG.
                 The exceptions are to ensure that this does not stop any of
                 the batch jobs. In the unlikely event that there is an exception
                 raised, then support should notice this in the JOB_RUN_LOG table.

      REVISIONS:
      Ver        Date        Author                    Description
      ---------  ----------  ---------------           ------------------------------------
      1.0        3/05/2017  James Baird               Initial version
   ******************************************************************************/
   V_STARTED     VARCHAR2 (100) := 'STARTED';
   V_COMPLETED   VARCHAR2 (100) := 'COMPLETED';
   V_FAILED      VARCHAR2 (100) := 'FAILED';

   PROCEDURE START_JOB (P_JOB_NAME             IN     VARCHAR2,
                        P_JOB_RUN_LOG_ID_OUT      OUT NUMBER)
   IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      INSERT INTO JOB_RUN_LOG (JOB_NAME, STATUS, START_TIME)
           VALUES (P_JOB_NAME, V_STARTED, SYSDATE)
        RETURNING JOB_RUN_LOG_ID
             INTO P_JOB_RUN_LOG_ID_OUT;
             commit;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
   END START_JOB;


   PROCEDURE JOB_STATUS (P_JOB_NAME             IN     VARCHAR2,
                        P_JOB_STATUS_OUT      OUT VARCHAR2)
   IS
   BEGIN
      SELECT NVL(MAX(JRL.STATUS),'NONE') INTO P_JOB_STATUS_OUT
      FROM JOB_RUN_LOG  JRL
        WHERE JRL.JOB_NAME = P_JOB_NAME
        AND JRL.JOB_RUN_LOG_ID = (SELECT MAX(JRL1.JOB_RUN_LOG_ID) 
                                  FROM JOB_RUN_LOG  JRL1
                                  WHERE JRL1.JOB_NAME = P_JOB_NAME )
        AND JRL.START_TIME > SYSDATE - 1/24;

   EXCEPTION
      WHEN OTHERS
      THEN
         P_JOB_STATUS_OUT := NULL;
   END JOB_STATUS;
   /**************************************************

       COMPLETE_JOB will only update the row if the status is not FAILED.



   **************************************************/
   PROCEDURE COMPLETE_JOB (P_JOB_RUN_LOG_ID_IN IN NUMBER)
   IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      UPDATE JOB_RUN_LOG
         SET STATUS = V_COMPLETED, FINISH_TIME = SYSDATE
       WHERE JOB_RUN_LOG_ID = P_JOB_RUN_LOG_ID_IN AND STATUS != V_FAILED;
       COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
   END COMPLETE_JOB;
   
    PROCEDURE COMPLETE_JOB_BY_NAME (P_JOB_NAME IN VARCHAR2)
    IS
       PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
       UPDATE JOB_RUN_LOG JRL
          SET JRL.STATUS = V_COMPLETED, JRL.FINISH_TIME = SYSDATE
        WHERE     JRL.JOB_RUN_LOG_ID = (SELECT MAX (JRL1.JOB_RUN_LOG_ID)
                                          FROM JOB_RUN_LOG JRL1
                                         WHERE JRL1.JOB_NAME = P_JOB_NAME)
              AND JRL.STATUS != V_FAILED;

       COMMIT;
    EXCEPTION
       WHEN OTHERS
       THEN
          ROLLBACK;
    END COMPLETE_JOB_BY_NAME;   

   PROCEDURE UPDATE_ERROR (P_JOB_RUN_LOG_ID_IN   IN NUMBER,
                           P_ERROR_MSG           IN VARCHAR2)
   IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      UPDATE JOB_RUN_LOG
         SET STATUS = V_FAILED,
             FINISH_TIME = SYSDATE,
             ERROR_MSG = SUBSTR (P_ERROR_MSG, 1, 4000)
       WHERE JOB_RUN_LOG_ID = P_JOB_RUN_LOG_ID_IN;
       COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
   END UPDATE_ERROR;
   
   PROCEDURE UPDATE_ERROR_BY_NAME (P_JOB_NAME       IN VARCHAR2,
                           P_ERROR_MSG           IN VARCHAR2)
   IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      UPDATE JOB_RUN_LOG JRL
         SET JRL.STATUS = V_FAILED,
             JRL.FINISH_TIME = SYSDATE,
             ERROR_MSG = SUBSTR (P_ERROR_MSG, 1, 4000)
       WHERE JRL.JOB_RUN_LOG_ID = (SELECT MAX (JRL1.JOB_RUN_LOG_ID)
                                          FROM JOB_RUN_LOG JRL1
                                         WHERE JRL1.JOB_NAME = P_JOB_NAME);
       COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
   END UPDATE_ERROR_BY_NAME;   

   PROCEDURE UPDATE_NOTES (P_JOB_RUN_LOG_ID_IN   IN NUMBER,
                           P_NOTES               IN VARCHAR2)
   IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      UPDATE JOB_RUN_LOG
         SET NOTES = SUBSTR (P_NOTES, 1, 4000)
       WHERE JOB_RUN_LOG_ID = P_JOB_RUN_LOG_ID_IN;
       COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
   END UPDATE_NOTES;

   PROCEDURE UPDATE_PAYMENT_SCHEDULER_NOTES (
      P_PAYMENT_RUN_DATE_IN   IN VARCHAR2)
   IS
      CURSOR GET_BATCHES
      IS
           SELECT    RPAD (sb.dpb_batch_ref, 10, ' ')
                  || RPAD (LPAD (TO_CHAR (sb.dpb_count, '99,999'), 7, ' '),
                           9,
                           ' ')
                  || '  '
                  || RPAD (
                        LPAD (TO_CHAR (sb.dpb_total_payment, '99,999'), 8, ' '),
                        14,
                        ' ')
                  || RPAD (LPAD (sb.dpb_type, 7, ' '), 10, ' ')
                  || RPAD (
                        LPAD (
                           DECODE (sb.dpb_payment_type,
                                   'B', 'BACS',
                                   'C', 'PO',
                                   dpb_payment_type),
                           11,
                           ' '),
                        14,
                        ' ')
                  || '     '
                  || (SELECT MAX (pp.process_date)
                        FROM sgas.payee_payment pp
                       WHERE pp.batch_ref = sb.dpb_batch_ref)
                     THE_ROW
             FROM sgas.scoap_batches sb
            WHERE TO_DATE (sb.dpb_batch_creation_date, 'DD-MON-YY') =
                     TRUNC (TO_DATE (P_PAYMENT_RUN_DATE_IN, 'dd/mm/yyyy'))
         ORDER BY 1;


      V_JOB_NAME   VARCHAR2 (4000)
         := 'StEPS_Payments.common.services.bpm.paymentsScheduler';
      V_HEADER     VARCHAR2 (400)
         :=    '  BATCH     COUNT  TOTAL PAYMENTS  DPB_TYPE  PAYMENT TYPE  PROCESSING DATE'
            || CHR (13);
      V_NOTES      VARCHAR2 (4000);
   BEGIN
      V_NOTES := V_HEADER;

      FOR GET_REC IN GET_BATCHES
      LOOP
         V_NOTES := SUBSTR (V_NOTES || GET_REC.THE_ROW, 1, 3900) || CHR (13);
      END LOOP;

      UPDATE JOB_RUN_LOG L
         SET L.NOTES = L.NOTES ||CHR (13) ||V_NOTES
       WHERE L.JOB_RUN_LOG_ID =
                (SELECT MAX (L1.JOB_RUN_LOG_ID)
                   FROM JOB_RUN_LOG L1
                  WHERE L1.JOB_NAME = V_JOB_NAME AND L1.STATUS != 'COMPLETED');
      
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
   END UPDATE_PAYMENT_SCHEDULER_NOTES;
   
   PROCEDURE GET_JOB_RUN_LOG (
      P_JOB_NAME        IN              VARCHAR2,
      JRL_CURSOR        IN OUT          JOB_RUN_LOG_CURSOR,
      ERROR_BOOLEAN    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
      j_cursor   JOB_RUN_LOG_CURSOR;
   BEGIN
      OPEN j_cursor FOR
           SELECT JRL.JOB_RUN_LOG_ID,
                 TO_CHAR(JRL.START_TIME, 'DD/MM/YYYY  HH24 : MI : SS    ') START_TIME,
                 TO_CHAR(JRL.FINISH_TIME,'DD/MM/YYYY  HH24 : MI : SS    ') FINISH_TIME,
                 JRL.ERROR_MSG,
                 JRL.NOTES
            FROM job_run_log jrl
           WHERE JRL.JOB_NAME = P_JOB_NAME
        ORDER BY JRL.JOB_RUN_LOG_ID DESC;

      JRL_CURSOR := j_cursor;
      ERROR_BOOLEAN := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_BOOLEAN := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END GET_JOB_RUN_LOG;   
   
END PK_JOB_RUN_LOG;
/