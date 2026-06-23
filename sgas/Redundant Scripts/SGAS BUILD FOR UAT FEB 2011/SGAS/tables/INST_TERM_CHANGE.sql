/******************************************************************************
TABLE NAME: INST_TERM_CHANGE        
DESCRIPTION: Table holding details of Institutions with updated terms

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
 
DROP TABLE SGAS.INST_TERM_CHANGE CASCADE CONSTRAINTS PURGE
/
--
-- INST_TERM_CHANGE  (Table) 
--
CREATE TABLE SGAS.INST_TERM_CHANGE
( INST_CODE            VARCHAR2(5 BYTE),
  SESSION_CODE         NUMBER(4),
  CHANGE_DATE          DATE
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

DROP PUBLIC SYNONYM INST_TERM_CHANGE
/

CREATE PUBLIC SYNONYM INST_TERM_CHANGE FOR SGAS.INST_TERM_CHANGE
/

