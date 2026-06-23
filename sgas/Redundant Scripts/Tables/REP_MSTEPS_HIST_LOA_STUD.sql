/******************************************************************************
NAME:       
PURPOSE: Steps letter of award temporary table creation

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        12.03.08    R HUNTER         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/REP_MSTEPS_HIST_LOA_STUD.sql $ 
$Author: $ 
$Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $ 
$Revision: 3341 $ 
 
*******************************************************************************/

ALTER TABLE SGAS.REP_MSTEPS_HIST_LOA_STUD
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.REP_MSTEPS_HIST_LOA_STUD CASCADE CONSTRAINTS
/

--
-- REP_MSTEPS_HIST_LOA_STUD  (Table) 
--
CREATE TABLE SGAS.REP_MSTEPS_HIST_LOA_STUD
(
  STUD_CRSE_YEAR_ID      NUMBER(9)              NOT NULL,
  ISSUE_DATE             DATE,
  STYLE                  NUMBER(1),
  DUPLICATE              VARCHAR2(1 BYTE),
  STUD_REF_NO            NUMBER(9),
  TITLE                  VARCHAR2(8 BYTE),
  INITIALS               VARCHAR2(5 BYTE),
  SURNAME                VARCHAR2(25 BYTE),
  FORENAME               VARCHAR2(25 BYTE),
  HOUSE_NO_NAME          VARCHAR2(32 BYTE),
  ADDR_L1                VARCHAR2(65 BYTE),
  ADDR_L2                VARCHAR2(65 BYTE),
  ADDR_L3                VARCHAR2(65 BYTE),
  ADDR_L4                VARCHAR2(65 BYTE),
  POST_CODE              VARCHAR2(8 BYTE),
  MAILSORT               VARCHAR2(5 BYTE),
  EMP_TEL_EXT            VARCHAR2(15 BYTE),
  DEARING_STATUS         VARCHAR2(1 BYTE),
  INST_NAME              VARCHAR2(50 BYTE),
  CRSE_NAME              VARCHAR2(50 BYTE),
  CRSE_YEAR_NO           NUMBER(2),
  SAAS_REF               VARCHAR2(11 BYTE),
  SLC_REF                VARCHAR2(9 BYTE),
  SESSION_CODE           NUMBER(4),
  INDEPENDENT            VARCHAR2(1 BYTE),
  REMAINING_AMOUNT       NUMBER(9,2),
  PARENT_CONT            NUMBER(9,2),
  SPOUSE_CONT            NUMBER(9,2),
  STUDENT_CONT           NUMBER(9,2),
  SPONSOR_CONT           NUMBER(9,2),
  OVERPAYMENT_RECOVERED  NUMBER(9,2),
  CASEWORKER_NAME        VARCHAR2(32 BYTE),
  SCHEME_TYPE            VARCHAR2(1 BYTE),
  JA_STUD_TOT            NUMBER(2),
  OVERPAYMENT            NUMBER(9,2),
  PAMS                   VARCHAR2(1 BYTE),
  RESID_PAR_CONT         NUMBER(9,2),
  RESID_SPOUSE_CONT      NUMBER(9,2),
  RESID_STUD_CONT        NUMBER(9,2),
  RESID_SPONSOR_CONT     NUMBER(9,2),
  FS1                    VARCHAR2(1 BYTE),
  FS2                    VARCHAR2(1 BYTE),
  FS3                    VARCHAR2(1 BYTE),
  FS4                    VARCHAR2(1 BYTE),
  FS5                    VARCHAR2(1 BYTE),
  FS6                    VARCHAR2(1 BYTE),
  FS7                    VARCHAR2(1 BYTE),
  FS8                    VARCHAR2(1 BYTE),
  FS9                    VARCHAR2(1 BYTE),
  REM1                   VARCHAR2(1 BYTE),
  REM2                   VARCHAR2(1 BYTE),
  REM3                   VARCHAR2(1 BYTE),
  REM4                   VARCHAR2(1 BYTE),
  REM5                   VARCHAR2(1 BYTE),
  REM6                   VARCHAR2(1 BYTE),
  REM7                   VARCHAR2(1 BYTE),
  REM8                   VARCHAR2(1 BYTE),
  REM9                   VARCHAR2(1 BYTE),
  REM10                  VARCHAR2(1 BYTE),
  LOAN_ASSESSED_ONLY     VARCHAR2(1 BYTE),
  REM_ADHOC              VARCHAR2(500 BYTE),
  REM11                  VARCHAR2(1 BYTE),
  REM12                  VARCHAR2(1 BYTE),
  REM13                  VARCHAR2(1 BYTE),
  REM14                  VARCHAR2(1 BYTE)
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

COMMENT ON COLUMN SGAS.REP_MSTEPS_HIST_LOA_STUD.REM14 IS 'Flag to indicate if remark 14 is to be printed on the view previous LOA'
/


--
-- P_STUD_PK  (Index) 
--
CREATE UNIQUE INDEX P_STUD_PK ON SGAS.REP_MSTEPS_HIST_LOA_STUD
(STUD_CRSE_YEAR_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             500K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


-- 
-- Non Foreign Key Constraints for Table REP_MSTEPS_HIST_LOA_STUD 
-- 
ALTER TABLE SGAS.REP_MSTEPS_HIST_LOA_STUD ADD (
  CONSTRAINT P_STUD_PK
 PRIMARY KEY
 (STUD_CRSE_YEAR_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          500K
                NEXT             500K
                MINEXTENTS       1
                MAXEXTENTS       99
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ))
/

