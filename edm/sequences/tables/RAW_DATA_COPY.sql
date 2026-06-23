-- Create table script.
--
-- MODIFICATION HISTORY
-- Ref.     Date            Author                          Desc.
--          08/01/2008  S Durkin (Sopra UK)     Initial Version
--
-- RAW_DATA_COPY is intended to store data from EDM in the test database. Data from RAW_DATA will be copied to RAW_DATA_COPY to give test team members a permanent copy of the data & allow the output of 
-- full edm processing to be duplicated without running the full EDM process. 
-- The table is intended  only for development or test environments.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/edm/tables/RAW_DATA_COPY.sql $
-- $Author: $
-- $Date: 2008-10-01 14:26:20 +0100 (Wed, 01 Oct 2008) $
-- $Revision: 1237 $

DROP TABLE RAW_DATA_COPY CASCADE CONSTRAINTS
/

--
-- RAW_DATA  (Table) 
--
CREATE TABLE RAW_DATA_COPY
(
    OBJECT_ID                    VARCHAR2(44 BYTE),
    RAW_DATA_ID                  VARCHAR2(10 BYTE),
    BATCH_ID                     NUMBER(16),
    ENVELOPE_ID                  NUMBER(4),
    SUPPLEMENTARY_GRANTS         VARCHAR2(1 BYTE),
    STUD_REF_NO                  VARCHAR2(10 BYTE),
    SCOTTISH_CAND                VARCHAR2(10 BYTE),
    NI_NO                        VARCHAR2(9 BYTE),
    NI_NO_F                      VARCHAR2(1 BYTE),
    TITLE                        VARCHAR2(8 BYTE),
    SURNAME                      VARCHAR2(25 BYTE),
    FORENAMES                    VARCHAR2(25 BYTE),
    BIRTH_SURNAME                VARCHAR2(30 BYTE),
    BIRTH_FORENAMES              VARCHAR2(30 BYTE),
    DOB                          VARCHAR2(10 BYTE),
    DOB_F                        VARCHAR2(1 BYTE),
    DISTRICT_BIRTH_CERT_ISSUED   VARCHAR2(25 BYTE),
    SEX                          VARCHAR2(1 BYTE),
    MARITAL_STATUS               VARCHAR2(1 BYTE),
    MARRIAGE_DATE                VARCHAR2(10 BYTE),
    HOME_HOUSE_NO_NAME           VARCHAR2(32 BYTE),
    HOME_POST_CODE               VARCHAR2(8 BYTE),
    HOME_ADDR_L1                 VARCHAR2(65 BYTE),
    HOME_ADDR_L2                 VARCHAR2(65 BYTE),
    HOME_ADDR_L3                 VARCHAR2(32 BYTE),
    HOME_ADDR_L4                 VARCHAR2(32 BYTE),
    HOME_TELE_NO                 VARCHAR2(15 BYTE),
    SORT_CODE                    VARCHAR2(6 BYTE),
    SORT_CODE_F                  VARCHAR2(1 BYTE),
    ACCOUNT_NO                   VARCHAR2(10 BYTE),
    ACCOUNT_NO_F                 VARCHAR2(1 BYTE),
    BIRTH_COUNTRY_CODE           VARCHAR2(3 BYTE),
    BIRTH_COUNTRY_CODE_F         VARCHAR2(1 BYTE),
    NATION_COUNTRY_CODE          VARCHAR2(3 BYTE),
    NATION_COUNTRY_CODE_F        VARCHAR2(1 BYTE),
    RESIDENCE_COUNTRY_CODE       VARCHAR2(3 BYTE),
    RESIDENCE_COUNTRY_CODE_F     VARCHAR2(1 BYTE),
    INST_NAME                    VARCHAR2(50 BYTE),
    INST_NAME_F                  VARCHAR2(1 BYTE),
    INST_CODE                    VARCHAR2(5 BYTE),
    CRSE_NAME                    VARCHAR2(50 BYTE),
    CRSE_NAME_F                  VARCHAR2(1 BYTE),
    CRSE_CODE                    VARCHAR2(4 BYTE),
    CRSE_YEAR_NO                 VARCHAR2(2 BYTE),
    FIRST_DEP_SURNAME            VARCHAR2(25 BYTE),
    FIRST_DEP_FORENAMES          VARCHAR2(25 BYTE),
    FIRST_DEP_DOB                VARCHAR2(10 BYTE),
    FIRST_DEP_DOB_F              VARCHAR2(1 BYTE),
    FIRST_DEP_REL_TYPE           VARCHAR2(4 BYTE),
    FIRST_DEP_INCOME_CODE_1      VARCHAR2(2 BYTE),
    FIRST_DEP_INCOME_CODE_1_F    VARCHAR2(1 BYTE),
    FIRST_DEP_INCOME_AMOUNT_1    VARCHAR2(11 BYTE),
    FIRST_DEP_INCOME_AMOUNT_1_F  VARCHAR2(1 BYTE),
    FIRST_DEP_INCOME_CODE_2      VARCHAR2(2 BYTE),
    FIRST_DEP_INCOME_CODE_2_F    VARCHAR2(1 BYTE),
    FIRST_DEP_INCOME_AMOUNT_2    VARCHAR2(11 BYTE),
    FIRST_DEP_INCOME_AMOUNT_2_F  VARCHAR2(1 BYTE),
    FIRST_DEP_INCOME_CODE_3      VARCHAR2(2 BYTE),
    FIRST_DEP_INCOME_CODE_3_F    VARCHAR2(1 BYTE),
    FIRST_DEP_INCOME_AMOUNT_3    VARCHAR2(11 BYTE),
    FIRST_DEP_INCOME_AMOUNT_3_F  VARCHAR2(1 BYTE),
    SEC_DEP_SURNAME              VARCHAR2(25 BYTE),
    SEC_DEP_FORENAMES            VARCHAR2(25 BYTE),
    SEC_DEP_DOB                  VARCHAR2(10 BYTE),
    SEC_DEP_DOB_F                VARCHAR2(1 BYTE),
    SEC_DEP_REL_TYPE             VARCHAR2(4 BYTE),
    SEC_DEP_INCOME_CODE_1        VARCHAR2(2 BYTE),
    SEC_DEP_INCOME_CODE_1_F      VARCHAR2(1 BYTE),
    SEC_DEP_INCOME_AMOUNT_1      VARCHAR2(11 BYTE),
    SEC_DEP_INCOME_AMOUNT_1_F    VARCHAR2(1 BYTE),
    SEC_DEP_INCOME_CODE_2        VARCHAR2(2 BYTE),
    SEC_DEP_INCOME_CODE_2_F      VARCHAR2(1 BYTE),
    SEC_DEP_INCOME_AMOUNT_2      VARCHAR2(11 BYTE),
    SEC_DEP_INCOME_AMOUNT_2_F    VARCHAR2(1 BYTE),
    SEC_DEP_INCOME_CODE_3        VARCHAR2(2 BYTE),
    SEC_DEP_INCOME_CODE_3_F      VARCHAR2(1 BYTE),
    SEC_DEP_INCOME_AMOUNT_3      VARCHAR2(11 BYTE),
    SEC_DEP_INCOME_AMOUNT_3_F    VARCHAR2(1 BYTE),
    THIRD_DEP_SURNAME            VARCHAR2(25 BYTE),
    THIRD_DEP_FORENAMES          VARCHAR2(25 BYTE),
    THIRD_DEP_DOB                VARCHAR2(10 BYTE),
    THIRD_DEP_DOB_F              VARCHAR2(1 BYTE),
    THIRD_DEP_REL_TYPE           VARCHAR2(4 BYTE),
    THIRD_DEP_INCOME_CODE_1      VARCHAR2(2 BYTE),
    THIRD_DEP_INCOME_CODE_1_F    VARCHAR2(1 BYTE),
    THIRD_DEP_INCOME_AMOUNT_1    VARCHAR2(11 BYTE),
    THIRD_DEP_INCOME_AMOUNT_1_F  VARCHAR2(1 BYTE),
    THIRD_DEP_INCOME_CODE_2      VARCHAR2(2 BYTE),
    THIRD_DEP_INCOME_CODE_2_F    VARCHAR2(1 BYTE),
    THIRD_DEP_INCOME_AMOUNT_2    VARCHAR2(11 BYTE),
    THIRD_DEP_INCOME_AMOUNT_2_F  VARCHAR2(1 BYTE),
    THIRD_DEP_INCOME_CODE_3      VARCHAR2(2 BYTE),
    THIRD_DEP_INCOME_CODE_3_F    VARCHAR2(1 BYTE),
    THIRD_DEP_INCOME_AMOUNT_3    VARCHAR2(11 BYTE),
    THIRD_DEP_INCOME_AMOUNT_3_F  VARCHAR2(1 BYTE),
    ADD_DEP_DETAILS              VARCHAR2(1 BYTE),
    LPCG                         VARCHAR2(1 BYTE),
    TWO_HOMES_ALLOW              VARCHAR2(1 BYTE),
    VAC_GRANT                    VARCHAR2(1 BYTE),
    NET_INCOME                   VARCHAR2(10 BYTE),
    NET_INCOME_F                 VARCHAR2(1 BYTE),
    PENSION_INCOME               VARCHAR2(10 BYTE),
    PENSION_INCOME_F             VARCHAR2(1 BYTE),
    TRUST_INCOME                 VARCHAR2(10 BYTE),
    TRUST_INCOME_F               VARCHAR2(1 BYTE),
    AWARD_ORG                    VARCHAR2(25 BYTE),
    ANNUAL_VALUE                 VARCHAR2(10 BYTE),
    MAINTENANCE                  VARCHAR2(10 BYTE),
    FEES                         VARCHAR2(10 BYTE),
    LENGTH_OF_SUPPORT            VARCHAR2(2 BYTE),
    SUPPORT_START_DATE           VARCHAR2(10 BYTE),
    APP_FORM_SIG                 VARCHAR2(1 BYTE),
    MAX_LOAN_REQUESTED           VARCHAR2(1 BYTE),
    LOAN_REQUEST                 VARCHAR2(8 BYTE),
    LOAN_REQUEST_F               VARCHAR2(1 BYTE),
    CONT1_FORENAME               VARCHAR2(25 BYTE),
    CONT1_SURNAME                VARCHAR2(25 BYTE),
    CONT1_NAME                   VARCHAR2(60 BYTE),
    CONT1_REL_CODE               VARCHAR2(1 BYTE),
    CONT1_HOUSE_NO_NM            VARCHAR2(32 BYTE),
    CONT1_POSTCODE               VARCHAR2(8 BYTE),
    CONT1_ADDR1                  VARCHAR2(60 BYTE),
    CONT1_ADDR2                  VARCHAR2(60 BYTE),
    CONT1_ADDR3                  VARCHAR2(30 BYTE),
    CONT1_ADDR4                  VARCHAR2(30 BYTE),
    CONT1_TEL_NO                 VARCHAR2(14 BYTE),
    CONT2_FORENAME               VARCHAR2(25 BYTE),
    CONT2_SURNAME                VARCHAR2(25 BYTE),
    CONT2_NAME                   VARCHAR2(60 BYTE),
    CONT2_HOUSE_NO_NM            VARCHAR2(32 BYTE),
    CONT2_POSTCODE               VARCHAR2(8 BYTE),
    CONT2_ADDR1                  VARCHAR2(60 BYTE),
    CONT2_ADDR2                  VARCHAR2(60 BYTE),
    CONT2_ADDR3                  VARCHAR2(30 BYTE),
    CONT2_ADDR4                  VARCHAR2(30 BYTE),
    CONT2_TEL_NO                 VARCHAR2(14 BYTE),
    BANKRUPT_FLAG                VARCHAR2(1 BYTE),
    TERM_HOUSE_NO_NAME           VARCHAR2(32 BYTE),
    TERM_POST_CODE               VARCHAR2(8 BYTE),
    TERM_ADDR_L1                 VARCHAR2(65 BYTE),
    TERM_ADDR_L2                 VARCHAR2(65 BYTE),
    TERM_ADDR_L3                 VARCHAR2(32 BYTE),
    TERM_ADDR_L4                 VARCHAR2(32 BYTE),
    SLC_CORRES_DEST              VARCHAR2(1 BYTE),
    LOAN_SIGNATURE               VARCHAR2(1 BYTE),
    LOAN_DECLARATION_DATE        VARCHAR2(10 BYTE),
    LOAN_DECLARATION_DATE_F      VARCHAR2(1 BYTE),
    BEN1_NI_NO                   VARCHAR2(9 BYTE),
    BEN1_NI_NO_F                 VARCHAR2(1 BYTE),
    BEN1_TITLE                   VARCHAR2(8 BYTE),
    BEN1_SURNAME                 VARCHAR2(25 BYTE),
    BEN1_FORENAMES               VARCHAR2(25 BYTE),
    BEN1_REL_TYPE                VARCHAR2(4 BYTE),
    BEN1_HOUSE_NO_NAME           VARCHAR2(32 BYTE),
    BEN1_POSTCODE                VARCHAR2(8 BYTE),
    BEN1_ADDR1                   VARCHAR2(65 BYTE),
    BEN1_ADDR2                   VARCHAR2(65 BYTE),
    BEN1_ADDR3                   VARCHAR2(32 BYTE),
    BEN1_ADDR4                   VARCHAR2(32 BYTE),
    BEN1_EMP_STATUS              VARCHAR2(1 BYTE),
    BEN2_NI_NO                   VARCHAR2(9 BYTE),
    BEN2_NI_NO_F                 VARCHAR2(1 BYTE),
    BEN2_TITLE                   VARCHAR2(8 BYTE),
    BEN2_SURNAME                 VARCHAR2(25 BYTE),
    BEN2_FORENAMES               VARCHAR2(25 BYTE),
    BEN2_REL_TYPE                VARCHAR2(4 BYTE),
    BEN2_HOUSE_NO_NAME           VARCHAR2(32 BYTE),
    BEN2_POSTCODE                VARCHAR2(8 BYTE),
    BEN2_ADDR1                   VARCHAR2(65 BYTE),
    BEN2_ADDR2                   VARCHAR2(65 BYTE),
    BEN2_ADDR3                   VARCHAR2(32 BYTE),
    BEN2_ADDR4                   VARCHAR2(32 BYTE),
    BEN2_EMP_STATUS              VARCHAR2(1 BYTE),
    JA_CASE                      VARCHAR2(1 BYTE),
    BEN1_PAYE                    VARCHAR2(11 BYTE),
    BEN1_PAYE_F                  VARCHAR2(1 BYTE),
    BEN2_PAYE                    VARCHAR2(11 BYTE),
    BEN2_PAYE_F                  VARCHAR2(1 BYTE),
    BEN1_SELF_EMPLOYMENT         VARCHAR2(11 BYTE),
    BEN1_SELF_EMPLOYMENT_F       VARCHAR2(1 BYTE),
    BEN2_SELF_EMPLOYMENT         VARCHAR2(11 BYTE),
    BEN2_SELF_EMPLOYMENT_F       VARCHAR2(1 BYTE),
    BEN1_PROPERTY                VARCHAR2(11 BYTE),
    BEN1_PROPERTY_F              VARCHAR2(1 BYTE),
    BEN2_PROPERTY                VARCHAR2(11 BYTE),
    BEN2_PROPERTY_F              VARCHAR2(1 BYTE),
    BEN1_PENSIONS                VARCHAR2(11 BYTE),
    BEN1_PENSIONS_F              VARCHAR2(1 BYTE),
    BEN2_PENSIONS                VARCHAR2(11 BYTE),
    BEN2_PENSIONS_F              VARCHAR2(1 BYTE),
    BEN1_BENEFITS                VARCHAR2(11 BYTE),
    BEN1_BENEFITS_F              VARCHAR2(1 BYTE),
    BEN2_BENEFITS                VARCHAR2(11 BYTE),
    BEN2_BENEFITS_F              VARCHAR2(1 BYTE),
    BEN1_NAT_SAVINGS             VARCHAR2(11 BYTE),
    BEN1_NAT_SAVINGS_F           VARCHAR2(1 BYTE),
    BEN2_NAT_SAVINGS             VARCHAR2(11 BYTE),
    BEN2_NAT_SAVINGS_F           VARCHAR2(1 BYTE),
    BEN1_INTEREST                VARCHAR2(11 BYTE),
    BEN1_INTEREST_F              VARCHAR2(1 BYTE),
    BEN2_INTEREST                VARCHAR2(11 BYTE),
    BEN2_INTEREST_F              VARCHAR2(1 BYTE),
    BEN1_DIVIDEND                VARCHAR2(11 BYTE),
    BEN1_DIVIDEND_F              VARCHAR2(1 BYTE),
    BEN2_DIVIDEND                VARCHAR2(11 BYTE),
    BEN2_DIVIDEND_F              VARCHAR2(1 BYTE),
    BEN1_OTHER_INC               VARCHAR2(11 BYTE),
    BEN1_OTHER_INC_F             VARCHAR2(1 BYTE),
    BEN2_OTHER_INC               VARCHAR2(11 BYTE),
    BEN2_OTHER_INC_F             VARCHAR2(1 BYTE),
    BEN1_SUPERANN                VARCHAR2(11 BYTE),
    BEN1_SUPERANN_F              VARCHAR2(1 BYTE),
    BEN2_SUPERANN                VARCHAR2(11 BYTE),
    BEN2_SUPERANN_F              VARCHAR2(1 BYTE),
    BEN1_RAP                     VARCHAR2(11 BYTE),
    BEN1_RAP_F                   VARCHAR2(1 BYTE),
    BEN2_RAP                     VARCHAR2(11 BYTE),
    BEN2_RAP_F                   VARCHAR2(1 BYTE),
    BEN1_OTHER_DED               VARCHAR2(11 BYTE),
    BEN1_OTHER_DED_F             VARCHAR2(1 BYTE),
    BEN2_OTHER_DED               VARCHAR2(11 BYTE),
    BEN2_OTHER_DED_F             VARCHAR2(1 BYTE),
    BEN1_FIRST_DEP_DOB           VARCHAR2(10 BYTE),
    BEN1_FIRST_DEP_DOB_F         VARCHAR2(1 BYTE),
    BEN1_SEC_DEP_DOB             VARCHAR2(10 BYTE),
    BEN1_SEC_DEP_DOB_F           VARCHAR2(1 BYTE),
    BEN1_THIRD_DEP_DOB           VARCHAR2(10 BYTE),
    BEN1_THIRD_DEP_DOB_F         VARCHAR2(1 BYTE),
    DOMESTIC_HELP                VARCHAR2(1 BYTE),
    BEN_DEC_SIG                  VARCHAR2(1 BYTE),
    EXTRA_NOTES                  VARCHAR2(1 BYTE),
    OUT_UK                       VARCHAR2(1 BYTE),
    FAST_TRACK                   VARCHAR2(1 BYTE),
    RES_QUERY                    VARCHAR2(1 BYTE),
    ARA_SENT                     VARCHAR2(1 BYTE),
    BIRTH_CERT_FLAG              VARCHAR2(1 BYTE),
    OFFER_FLAG                   VARCHAR2(1 BYTE),
    REPEAT_YEAR                  VARCHAR2(1 BYTE),
    DATE_APPLIC_RECEIVED         VARCHAR2(10 BYTE),
    EMP_LOGIN                    VARCHAR2(30 BYTE),
    APP_FORM_SIG_DATE            VARCHAR2(10 BYTE),
    PGCE                         VARCHAR2(1 BYTE),
    DSA                          VARCHAR2(1 BYTE),
    TOT_TRAV_AMOUNT_CLAIMED      VARCHAR2(7 BYTE),
    TOT_TRAV_AMOUNT_CLAIMED_F    VARCHAR2(1 BYTE),
    MOBILE_TEL_NO                VARCHAR2(14 BYTE),
    HOME_ADDR_MAIL_SORT          VARCHAR2(5 BYTE),
    BEN1_MAIL_SORT               VARCHAR2(5 BYTE),
    BEN2_MAIL_SORT               VARCHAR2(5 BYTE),
    EMAIL_ADDR                   VARCHAR2(80 BYTE),
    WEB_USER_ID                  VARCHAR2(25 BYTE),
    BANK_VALIDATE                VARCHAR2(1 BYTE)
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
-- Non Foreign Key Constraints for Table RAW_DATA 
-- 
ALTER TABLE RAW_DATA_COPY ADD (
  CONSTRAINT TOT_TRAV_AMOUNT_CLAIMED_F_CC01
 CHECK (tot_trav_amount_claimed_f  in ('Y','N')))
/


--
-- Administer grants
-- 
GRANT ALTER ON RAW_DATA_COPY TO PUBLIC
/

GRANT DELETE ON RAW_DATA_COPY TO PUBLIC
/

GRANT INDEX ON RAW_DATA_COPY TO PUBLIC
/

GRANT INSERT ON RAW_DATA_COPY TO PUBLIC
/

GRANT DEBUG ON RAW_DATA_COPY TO PUBLIC
/

GRANT UPDATE ON RAW_DATA_COPY TO PUBLIC
/

GRANT REFERENCES ON RAW_DATA_COPY TO PUBLIC
/

GRANT ON COMMIT REFRESH ON RAW_DATA_COPY TO PUBLIC
/

GRANT QUERY REWRITE ON RAW_DATA_COPY TO PUBLIC
/

GRANT SELECT ON RAW_DATA_COPY TO PUBLIC
/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM RAW_DATA_COPY
/

CREATE PUBLIC SYNONYM RAW_DATA_COPY FOR EDM.RAW_DATA_COPY
/
