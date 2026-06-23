-- TABLE: PROVIDER_AUD
-- Description: Table holding audit data for the PROVIDER table 
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      05.07.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      19.10.09   A.Bowman (SAAS)         Added sequence
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/PROVIDER_AUD.sql $
-- $Author: $
-- $Date: 2010-10-21 09:56:31 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5795 $
 
ALTER TABLE PROVIDER_AUD
 DROP PRIMARY KEY CASCADE
/
DROP TABLE PROVIDER_AUD CASCADE CONSTRAINTS PURGE
/
--
-- PROVIDER_AUD  (Table) 
--
CREATE TABLE PROVIDER_AUD
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

COMMENT ON TABLE PROVIDER_AUD IS 'Table holding audit data for the PROVIDER table';

COMMENT ON COLUMN PROVIDER_AUD.AUD_ID IS 'Unique identifier for each row on the table';

COMMENT ON COLUMN PROVIDER_AUD.AUD_DATE IS 'Date the row on the audit table is created';

COMMENT ON COLUMN PROVIDER_AUD.COLUMN_NAME IS 'Name of the column that is being audited';

COMMENT ON COLUMN PROVIDER_AUD.PRIMARY_KEY IS 'The unique identifier of the row on the table that is being audited';

COMMENT ON COLUMN PROVIDER_AUD.OLD IS 'The old value';

COMMENT ON COLUMN PROVIDER_AUD.NEW IS 'The new value';

COMMENT ON COLUMN PROVIDER_AUD.ACTION IS 'The action carried out by the user, ie update, insert or delete';

COMMENT ON COLUMN PROVIDER_AUD.USERNAME IS 'The unique identifier of the user making the change';


CREATE UNIQUE INDEX PROVIDER_AUD_PK ON PROVIDER_AUD
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


ALTER TABLE PROVIDER_AUD ADD (
  CONSTRAINT PROVIDER_AUD_PK
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

--#PROVIDER_AUD.PROV_AUD_ID SEQUENCE###############################
DROP SEQUENCE ILA500.PROV_AUD_ID_SEQ;

CREATE SEQUENCE ILA500.PROV_AUD_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


GRANT SELECT ON  ILA500.PROV_AUD_ID_SEQ TO PUBLIC;


-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM PROVIDER_AUD
/

CREATE PUBLIC SYNONYM PROVIDER_AUD FOR ILA500.PROVIDER_AUD
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON PROVIDER_AUD
TO EDM_USER
/