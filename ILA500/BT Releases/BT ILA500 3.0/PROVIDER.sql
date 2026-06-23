-- TABLE: PROVIDER
-- Description: Table holding each learning provider providing ILA500
--              eligible courses
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                 Desc.
-- 1.0      27.05.08    A.Bowman (SAAS)        Initial Version.
-- 1.1      19.06.08	A.Bowman (SAAS)        Amend data type of tele & fax no's to varchar2 was number in f.spec
-- 1.2      20.06.08    A.Bowman (SAAS)        Main and Finance position fields can now be null was mandatory in f.spec
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/BT%20Releases/BT%20ILA500%203.0/PROVIDER.sql $
-- $Author: $
-- $Date: 2008-10-07 13:29:55 +0100 (Tue, 07 Oct 2008) $
-- $Revision: 1293 $
 
ALTER TABLE PROVIDER
 DROP PRIMARY KEY CASCADE
/
DROP TABLE PROVIDER CASCADE CONSTRAINTS
/

--
-- PROVIDER (Table) 
--

CREATE TABLE PROVIDER
(
  PROVIDER_ID                    VARCHAR2(10 BYTE) NOT NULL,
  PROVIDER_NAME                  VARCHAR2(50 BYTE) NOT NULL,
  PROVIDER_HOUSE_NO_OR_NAME      VARCHAR2(32 BYTE),
  PROVIDER_ADDR_L1               VARCHAR2(65 BYTE),
  PROVIDER_ADDR_L2               VARCHAR2(65 BYTE),
  PROVIDER_ADDR_L3               VARCHAR2(32 BYTE),
  PROVIDER_ADDR_L4               VARCHAR2(32 BYTE),
  PROVIDER_POST_CODE             VARCHAR2(8 BYTE),
  PROVIDER_TEL_NO                VARCHAR2(15 BYTE),
  PROVIDER_FAX_NO                VARCHAR2(15 BYTE),
  BANK_SORT_CODE                 VARCHAR2(6 BYTE),
  BANK_ACCOUNT_NO                VARCHAR2(10 BYTE),
  MAIN_CONTACT_NAME              VARCHAR2(50 BYTE) NOT NULL,
  MAIN_CONTACT_POSITION          VARCHAR2(30 BYTE),
  MAIN_CONTACT_HOUSE_NO_OR_NAME  VARCHAR2(32 BYTE),
  MAIN_CONTACT_ADDR_L1           VARCHAR2(65 BYTE),
  MAIN_CONTACT_ADDR_L2           VARCHAR2(65 BYTE),
  MAIN_CONTACT_ADDR_L3           VARCHAR2(32 BYTE),
  MAIN_CONTACT_ADDR_L4           VARCHAR2(32 BYTE),
  MAIN_CONTACT_POST_CODE         VARCHAR2(8 BYTE),
  MAIN_CONTACT_TEL_NO            VARCHAR2(15 BYTE),
  MAIN_CONTACT_FAX_NO            VARCHAR2(15 BYTE),
  MAIN_CONTACT_EMAIL             VARCHAR2(80 BYTE),
  FIN_CONTACT_NAME               VARCHAR2(50 BYTE) NOT NULL,
  FIN_CONTACT_POSITION           VARCHAR2(30 BYTE),
  FIN_CONTACT_HOUSE_NO_OR_NAME   VARCHAR2(32 BYTE),
  FIN_CONTACT_ADDR_L1            VARCHAR2(65 BYTE),
  FIN_CONTACT_ADDR_L2            VARCHAR2(65 BYTE),
  FIN_CONTACT_ADDR_L3            VARCHAR2(32 BYTE),
  FIN_CONTACT_ADDR_L4            VARCHAR2(32 BYTE),
  FIN_CONTACT_POST_CODE          VARCHAR2(8 BYTE),
  FIN_CONTACT_TEL_NO             VARCHAR2(15 BYTE),
  FIN_CONTACT_FAX_NO             VARCHAR2(15 BYTE),
  FIN_CONTACT_EMAIL              VARCHAR2(80 BYTE) NOT NULL,
  SUSPEND_PAYMENTS               VARCHAR2(1 BYTE) DEFAULT 'N',
  SUSPEND_LETTERS                VARCHAR2(1 BYTE) DEFAULT 'N',
  PROV_TYPE_ID                   VARCHAR2(20 BYTE) NOT NULL,
  PROV_STATUS_ID                 VARCHAR2(20 BYTE) NOT NULL,
  LAST_UPDATED_BY                VARCHAR2(15 BYTE) DEFAULT USER NOT NULL,
  LAST_UPDATED_ON                DATE           DEFAULT SYSDATE               NOT NULL
  
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

COMMENT ON TABLE PROVIDER IS 'Table holding each learning provider providing ILA500 eligible courses';

COMMENT ON COLUMN PROVIDER.PROVIDER_ID IS 'Unique identifier for each learning provider';

COMMENT ON COLUMN PROVIDER.PROVIDER_NAME IS 'Name of learning provider';

COMMENT ON COLUMN PROVIDER.PROVIDER_HOUSE_NO_OR_NAME IS 'Learning provider house number or name';

COMMENT ON COLUMN PROVIDER.PROVIDER_ADDR_L1 IS 'Line 1 of learning providers address';

COMMENT ON COLUMN PROVIDER.PROVIDER_ADDR_L2 IS 'Line 2 of learning providers address';

COMMENT ON COLUMN PROVIDER.PROVIDER_ADDR_L3 IS 'Line 3 of learning providers address';

COMMENT ON COLUMN PROVIDER.PROVIDER_ADDR_L4 IS 'Line 4 of learning providers address';

COMMENT ON COLUMN PROVIDER.PROVIDER_POST_CODE IS 'learning providers post code';

COMMENT ON COLUMN PROVIDER.PROVIDER_TEL_NO IS 'learning providers telephone number';

COMMENT ON COLUMN PROVIDER.PROVIDER_FAX_NO IS 'learning providers fax number';

COMMENT ON COLUMN PROVIDER.BANK_SORT_CODE IS 'learning providers bank sort code';

COMMENT ON COLUMN PROVIDER.BANK_ACCOUNT_NO IS 'learning providers bank account number';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_NAME IS 'learning providers - main point of contact';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_POSITION IS 'learning providers - main point of contact''s job title';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_HOUSE_NO_OR_NAME IS 'learning providers - main point of contact''s house number or name';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_ADDR_L1 IS 'learning providers - main point of contact''s 1st line of address';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_ADDR_L2 IS 'learning providers - main point of contact''s 2nd line of address';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_ADDR_L3 IS 'learning providers - main point of contact''s 3rd line of address';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_ADDR_L4 IS 'learning providers - main point of contact''s 4th line of address';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_POST_CODE IS 'learning providers - main point of contact''s post code';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_TEL_NO IS 'learning providers -  main point of contact''s telephone number';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_FAX_NO IS 'learning providers -  main point of contact''s fax number';

COMMENT ON COLUMN PROVIDER.MAIN_CONTACT_EMAIL IS 'learning providers - main point of contact''s email address';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_NAME IS 'learning providers - finance dept point of contact';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_POSITION IS 'learning providers - finance dept point of contact''s job title';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_HOUSE_NO_OR_NAME IS 'learning providers - finance dept point of contact''s house number or name';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_ADDR_L1 IS 'learning providers - finance dept point of contact''s 1st line of address';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_ADDR_L2 IS 'learning providers - finance dept point of contact''s 2nd line of address';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_ADDR_L3 IS 'learning providers - finance dept point of contact''s 3rd line of address';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_ADDR_L4 IS 'learning providers - finance dept point of contact''s 4th line of address';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_POST_CODE IS 'learning providers - finance dept point of contact''s post code';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_TEL_NO IS 'learning providers - finance dept point of contact''s telephone number';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_FAX_NO IS 'learning providers - finance dept point of contact''s fax number';

COMMENT ON COLUMN PROVIDER.FIN_CONTACT_EMAIL IS 'learning providers - finance dept point of contact''s email address';

COMMENT ON COLUMN PROVIDER.SUSPEND_PAYMENTS IS 'Hold payments to learning provider indicator Y or N';

COMMENT ON COLUMN PROVIDER.SUSPEND_LETTERS IS 'Hold letters to learning provider indicator Y or N';

COMMENT ON COLUMN PROVIDER.PROV_TYPE_ID IS 'The type of learning provider. This should be Higher Education, Further Education or Private';

COMMENT ON COLUMN PROVIDER.PROV_STATUS_ID IS 'This should be active or inactive';

COMMENT ON COLUMN PROVIDER.LAST_UPDATED_BY IS 'The user to last update or insert a row on the provider table';

COMMENT ON COLUMN PROVIDER.LAST_UPDATED_ON IS 'The date of the latest update or insert on the provider table';


CREATE UNIQUE INDEX PROVIDER_PK ON PROVIDER
(PROVIDER_ID)
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


ALTER TABLE PROVIDER ADD (
  CONSTRAINT PROVIDER_PK
 PRIMARY KEY
 (PROVIDER_ID)
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


GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  PROVIDER TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM PROVIDER
/

CREATE PUBLIC SYNONYM PROVIDER FOR ILA500.PROVIDER
/