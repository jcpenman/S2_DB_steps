-- SLC_DATA.sql
-- Description: Table holding all SLC data for SGAS
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      21.04.11    A.Bowman  (SAAS)        Initial Version.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $


--
-- SLC_DATA  (Table) 
--

ALTER TABLE SGAS.SLC_DATA
 DROP PRIMARY KEY CASCADE;
DROP TABLE SGAS.SLC_DATA CASCADE CONSTRAINTS;

CREATE TABLE SGAS.SLC_DATA
(
  SLC_FILENAME                VARCHAR2(25 BYTE),
  SLC_FILE_DATE               DATE,
  STUD_CRSE_YEAR_ID           NUMBER(9),
  FORM_TYPE                   VARCHAR2(2 BYTE),
  VALIDATION                  VARCHAR2(1 BYTE),
  ACADEMIC_YEAR               NUMBER(4),
  ISSUE_DATE                  DATE,
  STATUS                      VARCHAR2(1 BYTE),
  SLC_REF_NO                  VARCHAR2(13 BYTE),
  UCAS_NO                     VARCHAR2(9 BYTE),
  PREV_LOAN_ACC_NO            VARCHAR2(11 BYTE),
  HEI_INST_NAME               VARCHAR2(25 BYTE),
  HEI_INST_CODE               VARCHAR2(4 BYTE),
  HEI_CRSE_CODE               VARCHAR2(6 BYTE),
  HEI_CRSE_NAME               VARCHAR2(25 BYTE),
  CRSE_YEAR_NO                NUMBER(1),
  TITLE                       VARCHAR2(4 BYTE),
  SURNAME                     VARCHAR2(30 BYTE),
  FORENAMES                   VARCHAR2(30 BYTE),
  HOME_ADDR_L1                VARCHAR2(60 BYTE),
  HOME_ADDR_L2                VARCHAR2(60 BYTE),
  HOME_ADDR_L3                VARCHAR2(60 BYTE),
  HOME_ADDR_L4                VARCHAR2(60 BYTE),
  HOME_POST_CODE              VARCHAR2(8 BYTE),
  SEX                         VARCHAR2(1 BYTE),
  DOB                         DATE,
  END_DATE                    VARCHAR2(6 BYTE),
  BIRTH_SURNAME               VARCHAR2(30 BYTE),
  BIRTH_FORENAMES             VARCHAR2(30 BYTE),
  HOME_TELE_NO                VARCHAR2(14 BYTE),
  DISTRICT_BIRTH_CERT_ISSUED  VARCHAR2(25 BYTE),
  BIRTH_COUNTRY               VARCHAR2(25 BYTE),
  TOTAL_ASSESSED_CONT         NUMBER(7,2),
  FEE_SUPPORT_AVAIL           NUMBER(7,2),
  DA                          NUMBER(7,2),
  LIVING_COST_LOAN            NUMBER(7,2),
  DA1                         NUMBER(7,2),
  DA2                         NUMBER(7,2),
  DA3                         NUMBER(7,2),
  TOTAL_LOAN_CLAIMED          NUMBER(7,2),
  TERM_ADDR_L1                VARCHAR2(60 BYTE),
  TERM_ADDR_L2                VARCHAR2(60 BYTE),
  TERM_ADDR_L3                VARCHAR2(60 BYTE),
  TERM_ADDR_L4                VARCHAR2(60 BYTE),
  TERM_POST_CODE              VARCHAR2(8 BYTE),
  TERM_TELE_NO                VARCHAR2(14 BYTE),
  CORRES_IND                  VARCHAR2(1 BYTE),
  FIRST_CONT_NAME             VARCHAR2(60 BYTE),
  FIRST_CONT_REL_CODE         VARCHAR2(1 BYTE),
  FIRST_CONT_ADDR1            VARCHAR2(60 BYTE),
  FIRST_CONT_ADDR2            VARCHAR2(60 BYTE),
  FIRST_CONT_ADDR3            VARCHAR2(60 BYTE),
  FIRST_CONT_POSTCODE         VARCHAR2(8 BYTE),
  FIRST_CONT_TEL_NO           VARCHAR2(14 BYTE),
  SECOND_CONT_NAME            VARCHAR2(60 BYTE),
  SECOND_CONT_ADDR1           VARCHAR2(60 BYTE),
  SECOND_CONT_ADDR2           VARCHAR2(60 BYTE),
  SECOND_CONT_ADDR3           VARCHAR2(60 BYTE),
  SECOND_CONT_POSTCODE        VARCHAR2(8 BYTE),
  SECOND_CONT_TEL_NO          VARCHAR2(14 BYTE),
  SORT_CODE                   VARCHAR2(6 BYTE),
  ACCOUNT_NO                  VARCHAR2(10 BYTE),
  BUILD_SOC_NO                VARCHAR2(18 BYTE),
  BANKRUPT_FLAG               VARCHAR2(1 BYTE),
  NI_NUMBER                   VARCHAR2(9 BYTE),
  DECLARATION_DATE            DATE,
  HEI_PAYMENT_ROUTE           VARCHAR2(1 BYTE),
  GE_SESS_CODE                NUMBER(4),
  EU_FLAG                     VARCHAR2(1 BYTE),
  STUDENT_CONSENT             VARCHAR2(1 BYTE),
  BENEFACTOR1_CONSENT         VARCHAR2(1 BYTE),
  BENEFACTOR2_CONSENT         VARCHAR2(1 BYTE),
  REPEAT_YEAR                 VARCHAR2(1 BYTE),
  NUMBER_OF_BENEFACTORS       NUMBER(1),
  NON_MEANS_TESTED            VARCHAR2(1 BYTE),
  NUMBER_OF_DEPENDANTS        NUMBER(1),
  HOUSEHOLD_RESID_INCOME      NUMBER(9,2),
  BEN1_TOTAL_INCOME           NUMBER(9,2),
  BEN2_TOTAL_INCOME           NUMBER(9,2),
  INTEREST_ACCRUAL_DATE       DATE,
  FEE_LOAN_AMOUNT             NUMBER(9,2),
  DC_FLAG                     VARCHAR2(2 BYTE),
  TOTAL_FEE_LOAN_AMOUNT       NUMBER(9,2),
  REASON_NO_NINO              NUMBER(4),
  LOAN_PAYMENT_METHOD         VARCHAR2(1 BYTE),
  FILE2_REC_STATUS            VARCHAR2(1 BYTE),
  REC_STATUS_CHANGED_DATE     DATE,
  RECORD_TYPE                 VARCHAR2(1 BYTE),
  TOTAL_FEE_LOAN_AVAILABLE    NUMBER(7,2),
  TOTAL_SOSB_ENTITLEMENT      NUMBER(7,2)
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             754K
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
MONITORING;

COMMENT ON COLUMN SGAS.SLC_DATA.TOTAL_FEE_LOAN_AVAILABLE IS 'Total fee loan amount available to the student for the relevant session';

COMMENT ON COLUMN SGAS.SLC_DATA.TOTAL_SOSB_ENTITLEMENT IS 'Total SOSB amount payable to the student for the relevant session';

COMMENT ON COLUMN SGAS.SLC_DATA.STUDENT_CONSENT IS 'Indicates that the student has given permission to share HEI Bursary details.';

COMMENT ON COLUMN SGAS.SLC_DATA.BENEFACTOR1_CONSENT IS 'Indicates that benefactor 1 has given permission to share HEI Bursary details.';

COMMENT ON COLUMN SGAS.SLC_DATA.BENEFACTOR2_CONSENT IS 'Indicates that benefactor 2 has given permission to share HEI Bursary details.';

COMMENT ON COLUMN SGAS.SLC_DATA.REPEAT_YEAR IS 'Indicates that the student is repeating a previous years study.';

COMMENT ON COLUMN SGAS.SLC_DATA.NUMBER_OF_BENEFACTORS IS 'The number of student benefactors (0, 1 or 2).';

COMMENT ON COLUMN SGAS.SLC_DATA.NON_MEANS_TESTED IS 'Indicates student is entitled to non means tested support only.';

COMMENT ON COLUMN SGAS.SLC_DATA.NUMBER_OF_DEPENDANTS IS 'The number of student adult dependants (spouse or civil partner).';

COMMENT ON COLUMN SGAS.SLC_DATA.HOUSEHOLD_RESID_INCOME IS 'The sum of benefactor residual incomes (total income less deductions).';

COMMENT ON COLUMN SGAS.SLC_DATA.BEN1_TOTAL_INCOME IS 'Total benefactor 1 income.';

COMMENT ON COLUMN SGAS.SLC_DATA.BEN2_TOTAL_INCOME IS 'Total benefactor 2 income.';


CREATE UNIQUE INDEX SGAS.P_SLCD ON SGAS.SLC_DATA
(SLC_FILENAME, SLC_FILE_DATE, STUD_CRSE_YEAR_ID, RECORD_TYPE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             542K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

DROP PUBLIC SYNONYM SLC_DATA;

CREATE PUBLIC SYNONYM SLC_DATA FOR SGAS.SLC_DATA;


ALTER TABLE SGAS.SLC_DATA ADD (
  CONSTRAINT SD_HEI_PAY_RT
 CHECK (HEI_PAYMENT_ROUTE IN ('O','P','M','U','G',NULL)));

ALTER TABLE SGAS.SLC_DATA ADD (
  CONSTRAINT SD_DC_FLAG
 CHECK (dc_flag in ('DR', 'CR', null)));

ALTER TABLE SGAS.SLC_DATA ADD (
  CONSTRAINT SD_LOAN_PAYMENT
 CHECK (loan_payment_method in ('M', 'T', NULL)));

ALTER TABLE SGAS.SLC_DATA ADD (
  CONSTRAINT SD_RECORD_TYPE
 CHECK (record_type in ('F', 'S')));

ALTER TABLE SGAS.SLC_DATA ADD (
  CONSTRAINT F1_SLCD 
 FOREIGN KEY (STUD_CRSE_YEAR_ID) 
 REFERENCES SGAS.STUD_CRSE_YEAR (STUD_CRSE_YEAR_ID));

ALTER TABLE SGAS.SLC_DATA ADD (
  CONSTRAINT P_SLCD
 PRIMARY KEY
 (SLC_FILENAME, SLC_FILE_DATE, STUD_CRSE_YEAR_ID, RECORD_TYPE)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          500K
                NEXT             542K
                MINEXTENTS       1
                MAXEXTENTS       99
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ));


ALTER TABLE SGAS.SLC_DATA ADD (
  CONSTRAINT F1_SLCD 
 FOREIGN KEY (SLC_FILENAME, SLC_FILE_DATE) 
 REFERENCES SGAS.SLC_BATCHES (SLC_FILENAME,SLC_FILE_DATE));


GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  SGAS.SLC_DATA TO PUBLIC;

                                                                        

DROP SEQUENCE SGAS.SLC_SEQ;

CREATE SEQUENCE SGAS.SLC_SEQ
  START WITH 1
  MAXVALUE 99999
  MINVALUE 1
  CYCLE
  NOCACHE
  NOORDER;


DROP PUBLIC SYNONYM SLC_SEQ;

CREATE PUBLIC SYNONYM SLC_SEQ FOR SGAS.SLC_SEQ;


GRANT SELECT ON  SGAS.SLC_SEQ TO FINANCE_USER;
