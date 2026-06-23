DROP TABLE SGAS.MESSAGE_LOGS CASCADE CONSTRAINTS
/

--
-- MESSAGE_LOGS  (Table) 
--
--   Row count:37
CREATE TABLE SGAS.MESSAGE_LOGS
(
  CODE         NUMBER(10)                           NULL,
  MESSAGE      VARCHAR2(100 BYTE)                   NULL,
  DESCRIPTION  VARCHAR2(2000 BYTE)                  NULL,
  DATESTAMP    DATE                             DEFAULT Sysdate                   NULL
)
/
