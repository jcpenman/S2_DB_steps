/******************************************************************************
TABLE NAME: EMPLOYEE        
DESCRIPTION: Table holding steps user info 

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        06.10.2010  A.Bowman         Initial Version 


CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/
 
ALTER TABLE SGAS.EMPLOYEE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.EMPLOYEE CASCADE CONSTRAINTS PURGE
/
--
-- EMPLOYEE  (Table) 
--
CREATE TABLE SGAS.EMPLOYEE
( USERNAME           VARCHAR2(15 BYTE) NOT NULL,
  FORENAME           VARCHAR2(50 BYTE) NOT NULL,
  SURNAME            VARCHAR2(50 BYTE) NOT NULL,
  TEAM               VARCHAR2(15 BYTE) NOT NULL,
  LAST_UPDATED_BY              VARCHAR2(15 BYTE)          DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON              DATE                       DEFAULT SYSDATE               NOT NULL
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

CREATE UNIQUE INDEX username_pk ON sgas.employee
(username)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE sgas.employee ADD (
  CONSTRAINT employee_pk
 PRIMARY KEY
 (username)
    USING INDEX
    TABLESPACE users
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64 k
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));

