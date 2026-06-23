/******************************************************************************
TABLE NAME: EMPLOYEE_ACTIVITY        
DESCRIPTION: Table holding employee activity data which will be used in the Employee Activity Report

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        16.09.2009  A.Bowman         Initial Version built in line with spec
1.1        21.10.2009  A.Bowman         Amended size of Username and Team columns at Neil's (UI) request
1.2        20.05.2010  A.Bowman         Amended size of first_name and last_name columns at Paddy Grace request
1.3        29.10.2010  A.Bowman         Removed columns first_name, last_name and team columns, these are now on Employee table

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/
 
DROP TABLE SGAS.EMPLOYEE_ACTIVITY CASCADE CONSTRAINTS PURGE
/
--
-- EMPLOYEE_ACTIVITY  (Table) 
--
CREATE TABLE SGAS.EMPLOYEE_ACTIVITY
( USERNAME          VARCHAR2(15 BYTE),
  ACTIVITY_DATE              DATE,
  APPLICATIONS      NUMBER(4) DEFAULT '0' NOT NULL,
  NMSB_APPS         NUMBER(4) DEFAULT '0' NOT NULL,
  TRAVEL            NUMBER(4) DEFAULT '0' NOT NULL,
  GENERAL_CORRES    NUMBER(4) DEFAULT '0' NOT NULL,
  MANUAL_REG        NUMBER(4) DEFAULT '0' NOT NULL,
  CHANGE_DETAILS    NUMBER(4) DEFAULT '0' NOT NULL,
  EMAILS            NUMBER(4) DEFAULT '0' NOT NULL,
  CALLS             NUMBER(4) DEFAULT '0' NOT NULL
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

CREATE UNIQUE INDEX EMPLOYEE_ACTIVITY_PK ON SGAS.EMPLOYEE_ACTIVITY
(USERNAME,ACTIVITY_DATE)
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


ALTER TABLE EMPLOYEE_ACTIVITY ADD (
  CONSTRAINT EMPLOYEE_ACTIVITY_PK
 PRIMARY KEY
 (USERNAME,ACTIVITY_DATE)
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
               
ALTER TABLE SGAS.EMPLOYEE_ACTIVITY ADD (
  CONSTRAINT F1_EA 
 FOREIGN KEY (USERNAME) 
 REFERENCES SGAS.EMPLOYEE (USERNAME));