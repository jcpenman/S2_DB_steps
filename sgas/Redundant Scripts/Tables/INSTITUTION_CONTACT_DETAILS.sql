/******************************************************************************
TABLE NAME: INSTITUTION_CONTACT_DETAILS        
DESCRIPTION: Table holding contact details for institutions

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        13.04.2010  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/
 
DROP TABLE SGAS.INSTITUTION_CONTACT_DETAILS CASCADE CONSTRAINTS PURGE
/

--
-- INSTITUTION_CONTACT_DETAILS  (Table) 
--

CREATE TABLE SGAS.INSTITUTION_CONTACT_DETAILS
( INST_CODE                  VARCHAR2(5) NOT NULL,
  INST_NAME                  VARCHAR2(50),
  MAIN_CONTACT_NAME          VARCHAR2(50),
  MAIN_CONTACT_POSITION      VARCHAR2(50),
  MAIN_TELEPHONE_NUMBER      VARCHAR2(15),
  EMAIL_ADDRESS              VARCHAR2(100),
  SECUREZIP_PASSWORD         VARCHAR2(8),
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

-- 
-- Create public synonym: 
-- 

DROP PUBLIC SYNONYM INSTITUTION_CONTACT_DETAILS
/

CREATE PUBLIC SYNONYM INSTITUTION_CONTACT_DETAILS FOR SGAS.INSTITUTION_CONTACT_DETAILS
/

