/******************************************************************************
TABLE NAME: CRSE_TERM_CHANGE        
DESCRIPTION: Table holding details of Course with updated terms

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
 
DROP TABLE SGAS.CRSE_TERM_CHANGE CASCADE CONSTRAINTS PURGE
/

--
-- CRSE_TERM_CHANGE  (Table) 
--

CREATE TABLE SGAS.CRSE_TERM_CHANGE
( CRSE_YEAR_ID         NUMBER(9),
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

DROP PUBLIC SYNONYM CRSE_TERM_CHANGE
/

CREATE PUBLIC SYNONYM CRSE_TERM_CHANGE FOR SGAS.CRSE_TERM_CHANGE
/

