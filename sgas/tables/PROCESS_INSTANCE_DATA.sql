/******************************************************************************
TABLE NAME: PROCESS_INSTANCE_DATA        
DESCRIPTION: Table holding PROCESS_INSTANCE data 

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
 
ALTER TABLE SGAS.PROCESS_INSTANCE_DATA
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.PROCESS_INSTANCE_DATA CASCADE CONSTRAINTS
/
--
-- PROCESS_INSTANCE_DATA  (Table) 
--
CREATE TABLE SGAS.PROCESS_INSTANCE_DATA
( PROCESS_ID                  VARCHAR2(32) NOT NULL,
  PROCESS_BPM                 VARCHAR2(25) NOT NULL,
  STUD_REF_NO                 NUMBER(8) NOT NULL,
  AUTO_CALC                   VARCHAR2(1),
  APPLICATION_STATUS          VARCHAR2(1) NOT NULL,
  WORKQUEUE                   VARCHAR2(20),
  SESSION_CODE                NUMBER(4) NOT NULL,
  CREATION_DATE               DATE NOT NULL,
  COMPLETE_DATE               DATE,                     
  DATE_APP_RECEIVED           DATE,
  DAYS_TO_PROCESS             NUMBER(4),
  SCHEME_TYPE                 VARCHAR2(1 BYTE)  
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


CREATE UNIQUE INDEX PROCESS_INSTANCE_DATA_PK ON SGAS.PROCESS_INSTANCE_DATA
(PROCESS_ID)
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

CREATE INDEX S1_PID ON PROCESS_INSTANCE_DATA
(STUD_REF_NO)
LOGGING
TABLESPACE STEPS_INDEX
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


ALTER TABLE SGAS.PROCESS_INSTANCE_DATA ADD (
  CONSTRAINT PROCESS_INSTANCE_DATA_PK
 PRIMARY KEY
 (PROCESS_ID)
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


ALTER TABLE SGAS.PROCESS_INSTANCE_DATA ADD (
  CONSTRAINT PID_AUTO_CALC
 CHECK (AUTO_CALC in ('Y','N')))
/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM PROCESS_INSTANCE_DATA
/

CREATE PUBLIC SYNONYM PROCESS_INSTANCE_DATA FOR SGAS.PROCESS_INSTANCE_DATA
/

GRANT SELECT ON  SGAS.PROCESS_INSTANCE_DATA TO PUBLIC;