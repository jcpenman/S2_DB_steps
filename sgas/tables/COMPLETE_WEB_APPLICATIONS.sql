-- MODIFICATION HISTORY:
-- Ref      Date       Author                      Desc.
-- 001      14.01.08   Shirkin                     Initial Version
-- 002      15.10.09   A.Bowman (SAAS)             Added materialized view log script
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/COMPLETE_WEB_APPLICATIONS.sql $
-- $Author: $
-- $Date: 2011-07-19 13:05:27 +0100 (Tue, 19 Jul 2011) $
-- $Revision: 7177 $

ALTER TABLE SGAS.COMPLETE_WEB_APPLICATIONS
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.COMPLETE_WEB_APPLICATIONS CASCADE CONSTRAINTS
/
--
-- COMPLETE_WEB_APPLICATIONS  (Table) 
--
--   Row count:4
CREATE TABLE SGAS.COMPLETE_WEB_APPLICATIONS
(
  APPLICATION_ID            NUMBER(10)              NULL,
  USERNAME                  VARCHAR2(25 BYTE)       NULL,
  STUD_REF_NO               NUMBER(10)              NULL,
  DOB                       DATE                NOT NULL,
  TITLE                     VARCHAR2(8 BYTE)    NOT NULL,
  INITIALS                  VARCHAR2(5 BYTE)        NULL,
  FORENAMES                 VARCHAR2(25 BYTE)   NOT NULL,
  SURNAME                   VARCHAR2(25 BYTE)   NOT NULL,
  SEX                       VARCHAR2(1 BYTE)    DEFAULT 'M'                   NOT NULL,
  NI_NO                     VARCHAR2(9 BYTE)        NULL,
  BIRTH_COUNTRY_CODE        NUMBER(3)               NULL,
  NATION_COUNTRY_CODE       NUMBER(3)           DEFAULT 299                       NULL,
  MARITAL_STATUS            VARCHAR2(1 BYTE)    DEFAULT 'S'                       NULL,
  MARRIAGE_DATE             DATE                    NULL,
  BANK_NAME                 VARCHAR2(25 BYTE)       NULL,
  ACCOUNT_NO                VARCHAR2(10 BYTE)       NULL,
  SORT_CODE                 VARCHAR2(6 BYTE)        NULL,
  ROLL_NO                   VARCHAR2(18 BYTE)       NULL,
  BANK_HOUSE_NO_NAME        VARCHAR2(32 BYTE)       NULL,
  BANK_ADDR_L1              VARCHAR2(65 BYTE)       NULL,
  BANK_ADDR_L2              VARCHAR2(65 BYTE)       NULL,
  BANK_ADDR_L3              VARCHAR2(32 BYTE)       NULL,
  BANK_ADDR_L4              VARCHAR2(32 BYTE)       NULL,
  BANK_POST_CODE            VARCHAR2(8 BYTE)        NULL,
  BIRTH_FORENAMES           VARCHAR2(30 BYTE)       NULL,
  BIRTH_SURNAME             VARCHAR2(30 BYTE)       NULL,
  BIRTH_DISTRICT            VARCHAR2(25 BYTE)       NULL,
  BANKRUPT_FLAG             VARCHAR2(1 BYTE)    DEFAULT 'N'                       NULL,
  CONT1_NAME                VARCHAR2(50 BYTE)       NULL,
  CONT1_POSTCODE            VARCHAR2(8 BYTE)        NULL,
  CONT1_HOUSE_NO_NM         VARCHAR2(32 BYTE)       NULL,
  CONT1_ADDR1               VARCHAR2(65 BYTE)       NULL,
  CONT1_ADDR2               VARCHAR2(65 BYTE)       NULL,
  CONT1_ADDR3               VARCHAR2(32 BYTE)       NULL,
  CONT1_ADDR4               VARCHAR2(32 BYTE)       NULL,
  CONT1_TEL_NO              VARCHAR2(14 BYTE)       NULL,
  CONT1_REL_CODE            VARCHAR2(1 BYTE)        NULL,
  CONT2_NAME                VARCHAR2(50 BYTE)       NULL,
  CONT2_POSTCODE            VARCHAR2(8 BYTE)        NULL,
  CONT2_HOUSE_NO_NM         VARCHAR2(32 BYTE)       NULL,
  CONT2_ADDR1               VARCHAR2(65 BYTE)       NULL,
  CONT2_ADDR2               VARCHAR2(65 BYTE)       NULL,
  CONT2_ADDR3               VARCHAR2(32 BYTE)       NULL,
  CONT2_ADDR4               VARCHAR2(32 BYTE)       NULL,
  CONT2_TEL_NO              VARCHAR2(14 BYTE)       NULL,
  INST_CODE                 VARCHAR2(5 BYTE)        NULL,
  INST_NAME                 VARCHAR2(50 BYTE)       NULL,
  CRSE_YEAR_NO              NUMBER(2)               NULL,
  CRSE_NAME                 VARCHAR2(50 BYTE)       NULL,
  CRSE_CODE                 VARCHAR2(4 BYTE)        NULL,
  CORRES_DEST               VARCHAR2(1 BYTE)    DEFAULT 'H'                   NOT NULL,
  INST_CHANGE               VARCHAR2(1 BYTE)    DEFAULT 'N'                   NOT NULL,
  REPEATING                 VARCHAR2(1 BYTE)        NULL,
  STUDY_ABROAD              VARCHAR2(1 BYTE)        NULL,
  STUDY_COUNTRY             NUMBER(3)               NULL,
  OUT_UK                    VARCHAR2(1 BYTE)        NULL,
  HOME_HOUSE_NO_NAME        VARCHAR2(32 BYTE)   NOT NULL,
  HOME_ADDR_L1              VARCHAR2(65 BYTE)   NOT NULL,
  HOME_ADDR_L2              VARCHAR2(65 BYTE)       NULL,
  HOME_ADDR_L3              VARCHAR2(32 BYTE)       NULL,
  HOME_ADDR_L4              VARCHAR2(32 BYTE)       NULL,
  HOME_POST_CODE            VARCHAR2(8 BYTE)        NULL,
  HOME_TELE_NO              VARCHAR2(15 BYTE)       NULL,
  LOAN_REQUEST              NUMBER(7,2)             NULL,
  MAX_LOAN_REQUESTED        VARCHAR2(1 BYTE)        NULL,
  RESIDENCE_IND             VARCHAR2(1 BYTE)        NULL,
  TERM_HOUSE_NO_NAME        VARCHAR2(32 BYTE)       NULL,
  TERM_ADDR_L1              VARCHAR2(65 BYTE)       NULL,
  TERM_ADDR_L2              VARCHAR2(65 BYTE)       NULL,
  TERM_ADDR_L3              VARCHAR2(32 BYTE)       NULL,
  TERM_ADDR_L4              VARCHAR2(32 BYTE)       NULL,
  TERM_POST_CODE            VARCHAR2(9 BYTE)        NULL,
  SLC_CORRES_DEST           VARCHAR2(1 BYTE)        NULL,
  JA_CASE                   VARCHAR2(1 BYTE)        NULL,
  BEN1_TITLE                VARCHAR2(8 BYTE)        NULL,
  BEN1_FORENAMES            VARCHAR2(25 BYTE)       NULL,
  BEN1_SURNAME              VARCHAR2(25 BYTE)       NULL,
  BEN1_REL_TYPE             NUMBER(4)               NULL,
  BEN1_HOUSE_NO_NAME        VARCHAR2(32 BYTE)       NULL,
  BEN1_POSTCODE             VARCHAR2(32 BYTE)       NULL,
  BEN1_ADDR1                VARCHAR2(65 BYTE)       NULL,
  BEN1_ADDR2                VARCHAR2(65 BYTE)       NULL,
  BEN1_ADDR3                VARCHAR2(32 BYTE)       NULL,
  BEN1_ADDR4                VARCHAR2(32 BYTE)       NULL,
  BEN1_RETIRED              VARCHAR2(1 BYTE)        NULL,
  BEN1_UNEMPLOYED           VARCHAR2(1 BYTE)        NULL,
  BEN1_NI_NO                VARCHAR2(9 BYTE)        NULL,
  BEN1_PAYE                 NUMBER(9,2)             NULL,
  BEN1_SELF_EMPLOYMENT      NUMBER(9,2)             NULL,
  BEN1_PROPERTY             NUMBER(9,2)             NULL,
  BEN1_PENSIONS             NUMBER(9,2)             NULL,
  BEN1_BENEFITS             NUMBER(9,2)             NULL,
  BEN1_NAT_SAVINGS          NUMBER(9,2)             NULL,
  BEN1_INTEREST             NUMBER(9,2)             NULL,
  BEN1_DIVIDEND             NUMBER(9,2)             NULL,
  BEN1_OTHER_INC            NUMBER(9,2)             NULL,
  BEN1_SUPERANN             NUMBER(9,2)             NULL,
  BEN1_RAP                  NUMBER(9,2)             NULL,
  BEN1_OTHER_DED            NUMBER(9,2)             NULL,
  BEN1_DOMESTIC             NUMBER(9,2)             NULL,
  BEN2_TITLE                VARCHAR2(8 BYTE)        NULL,
  BEN2_FORENAMES            VARCHAR2(25 BYTE)       NULL,
  BEN2_SURNAME              VARCHAR2(25 BYTE)       NULL,
  BEN2_REL_TYPE             NUMBER(4)               NULL,
  BEN2_HOUSE_NO_NAME        VARCHAR2(32 BYTE)       NULL,
  BEN2_POSTCODE             VARCHAR2(32 BYTE)       NULL,
  BEN2_ADDR1                VARCHAR2(65 BYTE)       NULL,
  BEN2_ADDR2                VARCHAR2(65 BYTE)       NULL,
  BEN2_ADDR3                VARCHAR2(32 BYTE)       NULL,
  BEN2_ADDR4                VARCHAR2(32 BYTE)       NULL,
  BEN2_RETIRED              VARCHAR2(1 BYTE)        NULL,
  BEN2_UNEMPLOYED           VARCHAR2(1 BYTE)        NULL,
  BEN2_NI_NO                VARCHAR2(9 BYTE)        NULL,
  BEN2_PAYE                 NUMBER(9,2)             NULL,
  BEN2_SELF_EMPLOYMENT      NUMBER(9,2)             NULL,
  BEN2_PROPERTY             NUMBER(9,2)             NULL,
  BEN2_PENSIONS             NUMBER(9,2)             NULL,
  BEN2_BENEFITS             NUMBER(9,2)             NULL,
  BEN2_NAT_SAVINGS          NUMBER(9,2)             NULL,
  BEN2_INTEREST             NUMBER(9,2)             NULL,
  BEN2_DIVIDEND             NUMBER(9,2)             NULL,
  BEN2_OTHER_INC            NUMBER(9,2)             NULL,
  BEN2_SUPERANN             NUMBER(9,2)             NULL,
  BEN2_RAP                  NUMBER(9,2)             NULL,
  BEN2_OTHER_DED            NUMBER(9,2)             NULL,
  TUITION_FEES              VARCHAR2(1 BYTE)        NULL,
  MAINTENANCE_GRANT         VARCHAR2(1 BYTE)        NULL,
  BURSARY_ONLY              VARCHAR2(1 BYTE)        NULL,
  BURSARY_DEP_ALLOWANCE     VARCHAR2(1 BYTE)        NULL,
  INCOME_ASSESSED_LOAN      VARCHAR2(1 BYTE)        NULL,
  YSB                       VARCHAR2(1 BYTE)        NULL,
  YSB_OUTSIDE_SCOTLAND      VARCHAR2(1 BYTE)        NULL,
  SUPPLEMENTARY_GRANTS      VARCHAR2(1 BYTE)        NULL,
  HEALTHCARE_FUNDING        VARCHAR2(1 BYTE)        NULL,
  CLAIMING_DSA              VARCHAR2(1 BYTE)        NULL,
  NON_INCOME_ASSESSED_LOAN  VARCHAR2(1 BYTE)        NULL,
  INSIDE_OUTSIDE_SCOTLAND   VARCHAR2(1 BYTE)        NULL,
  PGCE_TYPE                 VARCHAR2(1 BYTE)        NULL,
  EU_STUDENT                VARCHAR2(1 BYTE)        NULL,
  HEALTH_PAMS               VARCHAR2(1 BYTE)        NULL,
  STATUS                    VARCHAR2(1 BYTE)        NULL,
  PREV_LOAN_ACC_NO          VARCHAR2(11 BYTE)       NULL,
  WEB_SUBMITTED             DATE                    NULL,
  SESSION_CODE              NUMBER(4)               NULL,
  DEP_GRANT_CLAIM_TYPE      NUMBER(1)               NULL,
  DEP_REL_TYPE              NUMBER(4)               NULL,
  DEP_FORENAMES             VARCHAR2(25 BYTE)       NULL,
  DEP_SURNAME               VARCHAR2(25 BYTE)       NULL,
  DEP_DOB                   DATE                    NULL,
  DEP_INCOME_AMOUNT_1       NUMBER(9,2)             NULL,
  DEP_INCOME_AMOUNT_2       NUMBER(9,2)             NULL,
  DEP_INCOME_AMOUNT_3       NUMBER(9,2)             NULL,
  MOBILE_TEL_NO             VARCHAR2(14 BYTE)       NULL,
  EMAIL_ADDR                VARCHAR2(80 BYTE)       NULL,
  LPCG                      VARCHAR2(1 BYTE)        NULL,
  OBJECT_ID                 VARCHAR2(44 BYTE)       NULL,
  APPLICATION_TYPE          VARCHAR2(1 BYTE)        NULL,
  last_updated_by  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_CWA_LAST_UPDATED_BY NOT NULL,
  last_updated_on  DATE DEFAULT Sysdate CONSTRAINT NN_CWA_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
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
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/


--
-- CWA_PK1  (Index) 
--
--  Dependencies: 
--   COMPLETE_WEB_APPLICATIONS (Table)
--
CREATE UNIQUE INDEX CWA_PK1 ON SGAS.COMPLETE_WEB_APPLICATIONS
(APPLICATION_ID)
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
-- CWA_IND1  (Index) 
--
--  Dependencies: 
--   COMPLETE_WEB_APPLICATIONS (Table)
--
CREATE INDEX CWA_IND1 ON SGAS.COMPLETE_WEB_APPLICATIONS
(STUD_REF_NO)
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


DROP PUBLIC SYNONYM COMPLETE_WEB_APPLICATIONS
/

--
-- COMPLETE_WEB_APPLICATIONS  (Synonym) 
--
--  Dependencies: 
--   COMPLETE_WEB_APPLICATIONS (Table)
--
CREATE PUBLIC SYNONYM COMPLETE_WEB_APPLICATIONS FOR SGAS.COMPLETE_WEB_APPLICATIONS
/


-- 
-- Non Foreign Key Constraints for Table COMPLETE_WEB_APPLICATIONS 
-- 
ALTER TABLE SGAS.COMPLETE_WEB_APPLICATIONS ADD (
  CONSTRAINT CWA_PK1
 PRIMARY KEY
 (APPLICATION_ID)
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


/*--
-- COMPLETE_WEB_APPLICATIONS  (Materialized View Log)
--
DROP SNAPSHOT LOG ON COMPLETE_WEB_APPLICATIONS
/
--
-- COMPLETE_WEB_APPLICATIONS  (Materialized View Log) 
--
CREATE MATERIALIZED VIEW LOG ON COMPLETE_WEB_APPLICATIONS
TABLESPACE USERS
PCTUSED    0
PCTFREE    60
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOPARALLEL
WITH ROWID, SEQUENCE
INCLUDING NEW VALUES
/*