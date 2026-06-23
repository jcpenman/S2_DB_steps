/******************************************************************************
TABLE NAME: FEE_STATUS_REP_HIST       
DESCRIPTION: Table holding historic fee status report data 

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        22.11.2010  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/
 

DROP TABLE FEE_STATUS_REP_HIST CASCADE CONSTRAINTS PURGE
/
--
-- FEE_STATUS_REP_HIST  (Table) 
--
CREATE TABLE FEE_STATUS_REP_HIST
( STUD_REF_NO            NUMBER(10),
  SESSION_CODE           NUMBER(4),
  FORENAMES              VARCHAR2(25 BYTE),
  SURNAME                VARCHAR2(25 BYTE),
  DOB                    DATE,
  CAMPUS_ID              NUMBER(9),
  CRSE_CODE              VARCHAR2(4 BYTE),
  CRSE_NAME              VARCHAR2(50 BYTE),
  CRSE_YEAR_NO           NUMBER(2),
  REPEAT_YEAR            VARCHAR2(1 BYTE), 
  APPLICATION_STATUS     VARCHAR2(10 BYTE),
  WITHDRAW_DATE          DATE,
  REG_CONFIRM            VARCHAR2(1 BYTE),
  ATTEND_CONFIRM         VARCHAR2(1 BYTE),
  PAYMENT_SUSPEND        VARCHAR2(1 BYTE),
  PAYMENT_DATE           DATE,
  FEES_AWARDED           NUMBER(9,2),
  FEES_PAID              NUMBER(9,2),
  SCOTTISH_CAND          VARCHAR2(10 BYTE)
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






