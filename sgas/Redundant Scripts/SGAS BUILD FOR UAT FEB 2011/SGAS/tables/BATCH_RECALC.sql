/******************************************************************************
TABLE NAME: BATCH_RECALC        
DESCRIPTION: Table holding stud_crse_year records that will be picked up for recalc

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        15.02.2010  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/
 
DROP TABLE SGAS.BATCH_RECALC CASCADE CONSTRAINTS PURGE
/
--
-- BATCH_RECALC  (Table) 
--
CREATE TABLE SGAS.BATCH_RECALC
( STUD_CRSE_YEAR_ID            NUMBER(9),
  RECALL_DATE                  DATE,
  STUD_REF_NO                  NUMBER(10),
  PASS_FAIL                    VARCHAR2(1 BYTE),
  ERROR_MESSAGE                VARCHAR2(300 BYTE)
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

DROP PUBLIC SYNONYM BATCH_RECALC
/

CREATE PUBLIC SYNONYM BATCH_RECALC FOR SGAS.BATCH_RECALC
/

