-- awards_recalc
-- Description: Table holding all Web students who have moved to/from parental
--              address and therefore requiring award recalculation
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            25.03.08   R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/AWARDS_RECALC.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $
ALTER TABLE SGAS.AWARDS_RECALC
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.AWARDS_RECALC CASCADE CONSTRAINTS
/

--
-- AWARDS_RECALC  (Table) 
--
CREATE TABLE SGAS.AWARDS_RECALC
(
  AWARDS_RECALC_ID  NUMBER(16)                  NOT NULL,
  STUD_REF_NO       NUMBER(10)                  NOT NULL,
  SESSION_CODE      NUMBER(4)                   NOT NULL,
  PROCESSED_FLAG    CHAR(1 BYTE)                DEFAULT 'N'                   NOT NULL,
  CREATED_DATE      DATE                        DEFAULT SYSDATE               NOT NULL,
  USER_ID           VARCHAR2(15 BYTE)           DEFAULT 'WEB'                 NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE SGAS.AWARDS_RECALC IS 'Table holding all Web(or non-web) students who have moved to/from parental address (or no longer using default term dates) and therefore requiring award recalculation'
/

COMMENT ON COLUMN SGAS.AWARDS_RECALC.AWARDS_RECALC_ID IS 'Unique identifier for awards recalc record.'
/

COMMENT ON COLUMN SGAS.AWARDS_RECALC.STUD_REF_NO IS 'Unique SAAS student identifier.'
/

COMMENT ON COLUMN SGAS.AWARDS_RECALC.SESSION_CODE IS 'Year of session affected e.g.2008.'
/

COMMENT ON COLUMN SGAS.AWARDS_RECALC.PROCESSED_FLAG IS 'N=awaiting processing; Y=processing complete; E=error during processing'
/

COMMENT ON COLUMN SGAS.AWARDS_RECALC.CREATED_DATE IS 'Date recalculation was requested from the database.'
/

COMMENT ON COLUMN SGAS.AWARDS_RECALC.USER_ID IS 'WEB or student web id or SAAS caseworker?'
/


--
-- P_AWARDS_RECALC  (Index) 
--
CREATE UNIQUE INDEX P_AWARDS_RECALC ON SGAS.AWARDS_RECALC
(AWARDS_RECALC_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


-- 
-- Non Foreign Key Constraints for Table AWARDS_RECALC 
-- 
ALTER TABLE SGAS.AWARDS_RECALC ADD (
  CONSTRAINT P_AWARDS_RECALC
 PRIMARY KEY
 (AWARDS_RECALC_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          104K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ))
/

