/******************************************************************************
TABLE NAME: INST_CONT_DETAILS        
DESCRIPTION: Table holding contact details for institutions

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
 
DROP TABLE SGAS.INST_CONT_DETAILS CASCADE CONSTRAINTS PURGE
/

--
-- INST_CONT_DETAILS  (Table) 
--

CREATE TABLE SGAS.INST_CONT_DETAILS
( INST_CODE                  VARCHAR2(5) NOT NULL,
  INST_NAME                  VARCHAR2(50) NOT NULL,
  LOCATION_IND               VARCHAR2(1) NOT NULL,
  REG_CONTACT_NAME           VARCHAR2(50) NOT NULL,
  REG_CONTACT_POSITION       VARCHAR2(50) NOT NULL,
  REG_CONTACT_TEL_NO         VARCHAR2(15) NOT NULL,
  REG_CONTACT_EMAIL          VARCHAR2(80) NOT NULL,
  FINANCE_CONTACT_NAME       VARCHAR2(50) NOT NULL,
  FINANCE_CONTACT_POSITION       VARCHAR2(50) NOT NULL,
  FINANCE_CONTACT_TEL_NO         VARCHAR2(15) NOT NULL,
  FINANCE_CONTACT_EMAIL          VARCHAR2(80) NOT NULL,
  SECUREZIP_PASSWORD         VARCHAR2(12),
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

ALTER TABLE sgas.inst_cont_details ADD (
  CONSTRAINT inst_cont_details_pk
 PRIMARY KEY
 (INST_CODE)
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

-- 
-- Create public synonym: 
-- 

DROP PUBLIC SYNONYM INST_CONT_DETAILS
/

CREATE PUBLIC SYNONYM INST_CONT_DETAILS FOR SGAS.INST_CONT_DETAILS
/

