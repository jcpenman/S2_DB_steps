-- TABLE: REPORT_HISTORY_AUD
-- Description: Table holding audit data for the REPORT_HISTORY table 
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      05.07.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      19.10.09   A.Bowman (SAAS)         Added trigger
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/REPORT_HISTORY_AUD.sql $
-- $Author: $
-- $Date: 2010-10-21 09:56:31 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5795 $
 
ALTER TABLE REPORT_HISTORY_AUD
 DROP PRIMARY KEY CASCADE
/
DROP TABLE REPORT_HISTORY_AUD CASCADE CONSTRAINTS PURGE
/
--
-- REPORT_HISTORY_AUD  (Table) 
--
CREATE TABLE REPORT_HISTORY_AUD
(
  AUD_ID      NUMBER(10)                    NOT NULL,
  AUD_DATE    DATE                          NOT NULL,
  COLUMN_NAME     VARCHAR2(32 BYTE)         NOT NULL,
  PRIMARY_KEY     VARCHAR2(32 BYTE)         NOT NULL,
  OLD             VARCHAR2(400 BYTE),
  NEW             VARCHAR2(400 BYTE),            
  ACTION          VARCHAR2(1 BYTE)          NOT NULL,
  USERNAME        VARCHAR2(15 BYTE)         NOT NULL
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

COMMENT ON TABLE REPORT_HISTORY_AUD IS 'Table holding audit data for the REPORT_HISTORY table';

COMMENT ON COLUMN REPORT_HISTORY_AUD.AUD_ID IS 'Unique identifier for each row on the table';

COMMENT ON COLUMN REPORT_HISTORY_AUD.AUD_DATE IS 'Date the row on the audit table is created';

COMMENT ON COLUMN REPORT_HISTORY_AUD.COLUMN_NAME IS 'Name of the column that is being audited';

COMMENT ON COLUMN REPORT_HISTORY_AUD.PRIMARY_KEY IS 'The unique identifier of the row on the table that is being audited';

COMMENT ON COLUMN REPORT_HISTORY_AUD.OLD IS 'The old value';

COMMENT ON COLUMN REPORT_HISTORY_AUD.NEW IS 'The new value';

COMMENT ON COLUMN REPORT_HISTORY_AUD.ACTION IS 'The action carried out by the user, ie update, insert or delete';

COMMENT ON COLUMN REPORT_HISTORY_AUD.USERNAME IS 'The unique identifier of the user making the change';


CREATE UNIQUE INDEX REPORT_HISTORY_AUD_PK ON REPORT_HISTORY_AUD
(AUD_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE REPORT_HISTORY_AUD ADD (
  CONSTRAINT REPORT_HISTORY_AUD_PK
 PRIMARY KEY
 (AUD_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));

--#REPORT_HISTORY_AUD.REP_HIST_AUD_ID SEQUENCE###############################
DROP SEQUENCE ILA500.REP_HIST_AUD_ID_SEQ;

CREATE SEQUENCE ILA500.REP_HIST_AUD_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


GRANT SELECT ON  ILA500.REP_HIST_AUD_ID_SEQ TO PUBLIC;


-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM REPORT_HISTORY_AUD
/

CREATE PUBLIC SYNONYM REPORT_HISTORY_AUD FOR ILA500.REPORT_HISTORY_AUD
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON REPORT_HISTORY_AUD
TO EDM_USER
/