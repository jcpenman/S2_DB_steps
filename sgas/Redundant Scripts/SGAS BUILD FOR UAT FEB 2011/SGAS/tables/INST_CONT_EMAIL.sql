/******************************************************************************
TABLE NAME: INST_CONT_EMAIL        
DESCRIPTION: Table holding EMAIL details for institutions

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        09.12.2010  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/
 
DROP TABLE SGAS.INST_CONT_EMAIL CASCADE CONSTRAINTS PURGE
/

--
-- INST_CONT_EMAIL  (Table) 
--

CREATE TABLE SGAS.INST_CONT_EMAIL
( INST_CODE_ID               NUMBER(10) NOT NULL,
  INST_CODE                  VARCHAR2(5) NOT NULL,
  EMAIL_ADDRESS              VARCHAR2(80) NOT NULL,
  FEE_REPORT                 VARCHAR2(1) NOT NULL,
  STATUS_REPORT              VARCHAR2(1) NOT NULL,
  LAST_UPDATED_BY VARCHAR2(25 BYTE) DEFAULT USER NOT NULL,
  LAST_UPDATED_ON DATE DEFAULT SYSDATE NOT NULL
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

ALTER TABLE SGAS.INST_CONT_EMAIL ADD (
  CONSTRAINT F1_ICD 
 FOREIGN KEY (INST_CODE) 
 REFERENCES SGAS.INST_CONT_DETAILS (INST_CODE));

-- 
-- Create public synonym: 
-- 

DROP PUBLIC SYNONYM INST_CONT_EMAIL
/

CREATE PUBLIC SYNONYM INST_CONT_EMAIL FOR SGAS.INST_CONT_EMAIL
/

