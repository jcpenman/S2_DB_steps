/******************************************************************************
TABLE NAME: COMPLETE_TASK_DATA        
DESCRIPTION: Table holding COMPLETE_TASK_DATA (funnily enough)

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        02.02.2011  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/
 
ALTER TABLE SGAS.COMPLETE_TASK_DATA
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.COMPLETE_TASK_DATA CASCADE CONSTRAINTS
/
--
-- COMPLETE_TASK_DATA  (Table) 
--
CREATE TABLE SGAS.COMPLETE_TASK_DATA
( COMPLETE_TASK_ID            NUMBER(10) NOT NULL,
  PROCESS_ID                  VARCHAR2(32) NOT NULL,
  TASK_ID                     NUMBER(6),
  STUD_REF_NO                 NUMBER(8) NOT NULL,
  TASK_TYPE                   VARCHAR2(30) NOT NULL,
  TASK_CATEGORY               VARCHAR2(40),
  WORKQUEUE                   VARCHAR2(20) NOT NULL,
  SESSION_CODE                NUMBER(4) NOT NULL,
  TASK_CREATION_DATE          DATE NOT NULL,
  TASK_COMPLETE_DATE          DATE NOT NULL,
  DATE_APP_RECEIVED           DATE,
  APP_STATUS                  VARCHAR2(1) NOT NULL,
  SCHEME_TYPE                 VARCHAR2(1) NOT NULL,
  DAYS_TO_PROCESS             NUMBER(4) NOT NULL,
  USERNAME                    VARCHAR2(15),
  TEAM                        VARCHAR2(15)  
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX COMPLETE_TASK_DATA_PK ON SGAS.COMPLETE_TASK_DATA
(COMPLETE_TASK_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE SGAS.COMPLETE_TASK_DATA ADD (
  CONSTRAINT COMPLETE_TASK_DATA_PK
 PRIMARY KEY
 (COMPLETE_TASK_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));
               
ALTER TABLE SGAS.COMPLETE_TASK_DATA ADD (
  CONSTRAINT F1_PID
 FOREIGN KEY (PROCESS_ID) 
REFERENCES SGAS.PROCESS_INSTANCE_DATA (PROCESS_ID));


-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM COMPLETE_TASK_DATA
/

CREATE PUBLIC SYNONYM COMPLETE_TASK_DATA FOR SGAS.COMPLETE_TASK_DATA
/

DROP SEQUENCE SGAS.complete_task_id_seq
/
--
-- complete_task_id_seq  (Sequence) 
--
CREATE SEQUENCE SGAS.complete_task_id_seq
  START WITH 1
  MAXVALUE 9999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_complete_task_id_seq
   BEFORE INSERT
   ON SGAS.COMPLETE_TASK_DATA
   FOR EACH ROW
BEGIN
   SELECT complete_task_id_seq.NEXTVAL
     INTO :NEW.complete_task_id
     FROM DUAL;
END;

GRANT SELECT ON  SGAS.COMPLETE_TASK_DATA TO PUBLIC;