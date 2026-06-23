/******************************************************************************
NAME:       
PURPOSE: Steps letter of award temporary table creation

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        12.03.08    R HUNTER         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/REP_MSTEPS_HIST_LOA_AWARD.sql $ 
$Author: $ 
$Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $ 
$Revision: 3341 $ 
 
*******************************************************************************/

DROP TABLE SGAS.REP_MSTEPS_HIST_LOA_AWARD CASCADE CONSTRAINTS
/

--
-- REP_MSTEPS_HIST_LOA_AWARD  (Table) 
--
CREATE TABLE SGAS.REP_MSTEPS_HIST_LOA_AWARD
(
  STUD_CRSE_YEAR_ID  NUMBER(9)                  NOT NULL,
  ISSUE_DATE         DATE,
  STUD_AWARD_TYPE    VARCHAR2(6 BYTE),
  DESCRIPT           VARCHAR2(51 BYTE),
  NET_AMOUNT         NUMBER(9,2),
  WE_PAY_FEES        NUMBER(9,2),
  YOU_PAY_FEES       NUMBER(9,2),
  MAX_LOAN           NUMBER(9,2)
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1200K
            NEXT             208K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/


--
-- SCY_ID  (Index) 
--
CREATE INDEX SCY_ID ON SGAS.REP_MSTEPS_HIST_LOA_AWARD
(STUD_CRSE_YEAR_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          502K
            NEXT             502K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

