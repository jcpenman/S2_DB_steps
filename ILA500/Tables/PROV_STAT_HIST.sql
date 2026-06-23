-- TABLE: PROV_STAT_HIST 
-- Description: Temporary table holding previous month's learning provider status history for ILA500
-- Author R. Hunter(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                 Desc.
-- 1.0      13.08.08    R. Hunter (SAAS)       Initial Version.
-- 2.0      08.08.08    R. Hunter (SAAS)       Learner application ID added
-- 3.0      12.11.09    J. Penman (SAAS)       Increase the length of COURSELEVEL
-- 3.1      18.11.09    A.Bowman (SAAS)        Removed NOT NULL constraint from the following columns, courselevel, coursetype and paymentdate  
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PROV_STAT_HIST.sql $
-- $Author: $
-- $Date: 2010-10-21 09:56:31 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5795 $


DROP TABLE PROV_STAT_HIST CASCADE CONSTRAINTS PURGE
/

--
-- PROV_STAT_HIST  (Table) 
--
CREATE TABLE PROV_STAT_HIST
(
  LEARNER_APPLICATION_ID  NUMBER(10)            NOT NULL,
  SESSION_YEAR            VARCHAR2(4 BYTE)      NOT NULL,
  ILAREFNUM               VARCHAR2(10 BYTE)     NOT NULL,
  FORENAME                VARCHAR2(25 BYTE)     NOT NULL,
  SURNAME                 VARCHAR2(25 BYTE)     NOT NULL,
  DOB                     DATE                  NOT NULL,
  COURSELEVEL             VARCHAR2(80 BYTE),
  COURSETYPE              VARCHAR2(20 BYTE),
  CURRENT_COURSE_YEAR     NUMBER,
  FEESAWARDED             NUMBER,
  PAYMENTDATE             DATE,
  FEESTATUS               VARCHAR2(4000 BYTE),
  APPLSTATUS              VARCHAR2(20 BYTE)     NOT NULL,
  CURRENT_PROVIDER        NUMBER(10)            NOT NULL,
  CURRENT_SESSION         VARCHAR2(4 BYTE)      NOT NULL
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

 

GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  PROV_STAT_HIST  TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM PROV_STAT_HIST 
/

CREATE PUBLIC SYNONYM PROV_STAT_HIST FOR ILA500.PROV_STAT_HIST 
/