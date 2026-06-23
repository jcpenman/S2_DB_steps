/******************************************************************************
TABLE NAME: SCOAP_ERRORS        
DESCRIPTION: Table holding scoap errors

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        21.12.2009  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/

DROP TABLE SGAS.SCOAP_ERRORS CASCADE CONSTRAINTS PURGE
/
--
-- SCOAP_ERRORS  (Table) 
--
CREATE TABLE SGAS.SCOAP_ERRORS
(
  ERROR_TYPE    VARCHAR2(1 BYTE) CONSTRAINT NN_SE_ERROR_TYPE NOT NULL,
  ERROR_CODE    NUMBER(5) CONSTRAINT NN_SE_ERROR_CODE NOT NULL,
  ERROR_DATE    DATE CONSTRAINT NN_SE_ERROR_DATE NOT NULL,
  ERROR_MSG     VARCHAR2(255 BYTE) CONSTRAINT NN_SE_ERROR_MSG NOT NULL,
  INST_CODE     VARCHAR2(5 BYTE),
  STUD_REF_NO   NUMBER(10),
  PAYMENT_DATE  DATE,
  BATCH_REF     VARCHAR2(7 BYTE),
  LAST_UPDATED_BY         VARCHAR2(15 BYTE)     DEFAULT User CONSTRAINT NN_SC_ERR_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON         DATE                  DEFAULT Sysdate CONSTRAINT NN_SC_ERR_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE PUBLIC SYNONYM SCOAP_ERRORS FOR SGAS.SCOAP_ERRORS;

ALTER TABLE SCOAP_ERRORS ADD (
  CONSTRAINT SE_ERROR_TYPE
 CHECK ( ERROR_TYPE IN('A','I','J')));