-- Create table script.
--
-- MODIFICATION HISTORY
-- Ref.     Date        Author                  Desc. 
-- 011      27/11/2012  A.Bowman (SAAS)         Added additional columns and amended trigger as part of Kainos release.          
-- 010      01/02/2012  A.Bowman (SAAS)         Added additional columns and amended triggers as part of a BT release.
-- 009      08/02/2011  P.Hughes (SAAS)         Added additional columns and amended triggers as part of a BT release (RFC 283)
-- 008      18/02/2010  A.Bowman (SAAS)         Added additional columns and amended triggers as part of a BT release.
-- 007      18/01/2010  A.Bowman (SAAS)         Added additional columns and trigger as part of a BT release.
-- 006      29/10/2009  A.Bowman (SAAS)         Prefixed package with SGAS in authentication of web student trigger
-- 005      29/10/2009  A.Bowman (SAAS)         After discussion with Clark Bolan added TRIGGER raw_data$audit_trig as this was missing from the script
-- 004      28/10/2009  A.Bowman (SAAS)         Added authentication of web student trigger
-- 003      10/03/2009  A.Bowman (SAAS)         Updated additional columns that were addded as part of a BT release.
-- 002      26/11/2008	P Hughes		Updated triggers and additional columns that were added by BT.
-- 001      08/01/2008  S Durkin (Sopra UK)     Initial Version
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/edm/tables/RAW_DATA.sql $
-- $Author: $
-- $Date: 2012-11-27 15:59:05 +0000 (Tue, 27 Nov 2012) $
-- $Revision: 8376 $

DROP TABLE EDM.RAW_DATA CASCADE CONSTRAINTS PURGE;

CREATE TABLE EDM.RAW_DATA
(
  OBJECT_ID                      VARCHAR2(44 BYTE),
  RAW_DATA_ID                    VARCHAR2(10 BYTE),
  BATCH_ID                       NUMBER(16),
  ENVELOPE_ID                    NUMBER(4),
  SUPPLEMENTARY_GRANTS           VARCHAR2(1 BYTE),
  STUD_REF_NO                    VARCHAR2(10 BYTE),
  SCOTTISH_CAND                  VARCHAR2(10 BYTE),
  NI_NO                          VARCHAR2(9 BYTE),
  NI_NO_F                        VARCHAR2(1 BYTE),
  TITLE                          VARCHAR2(8 BYTE),
  SURNAME                        VARCHAR2(25 BYTE),
  FORENAMES                      VARCHAR2(25 BYTE),
  BIRTH_SURNAME                  VARCHAR2(30 BYTE),
  BIRTH_FORENAMES                VARCHAR2(30 BYTE),
  DOB                            VARCHAR2(10 BYTE),
  DOB_F                          VARCHAR2(1 BYTE),
  DISTRICT_BIRTH_CERT_ISSUED     VARCHAR2(25 BYTE),
  SEX                            VARCHAR2(1 BYTE),
  MARITAL_STATUS                 VARCHAR2(1 BYTE),
  MARRIAGE_DATE                  VARCHAR2(10 BYTE),
  HOME_HOUSE_NO_NAME             VARCHAR2(32 BYTE),
  HOME_POST_CODE                 VARCHAR2(8 BYTE),
  HOME_ADDR_L1                   VARCHAR2(65 BYTE),
  HOME_ADDR_L2                   VARCHAR2(65 BYTE),
  HOME_ADDR_L3                   VARCHAR2(32 BYTE),
  HOME_ADDR_L4                   VARCHAR2(32 BYTE),
  HOME_TELE_NO                   VARCHAR2(15 BYTE),
  SORT_CODE                      VARCHAR2(6 BYTE),
  SORT_CODE_F                    VARCHAR2(1 BYTE),
  ACCOUNT_NO                     VARCHAR2(10 BYTE),
  ACCOUNT_NO_F                   VARCHAR2(1 BYTE),
  BIRTH_COUNTRY_CODE             VARCHAR2(3 BYTE),
  BIRTH_COUNTRY_CODE_F           VARCHAR2(1 BYTE),
  NATION_COUNTRY_CODE            VARCHAR2(3 BYTE),
  NATION_COUNTRY_CODE_F          VARCHAR2(1 BYTE),
  RESIDENCE_COUNTRY_CODE         VARCHAR2(3 BYTE),
  RESIDENCE_COUNTRY_CODE_F       VARCHAR2(1 BYTE),
  INST_NAME                      VARCHAR2(50 BYTE),
  INST_NAME_F                    VARCHAR2(1 BYTE),
  INST_CODE                      VARCHAR2(5 BYTE),
  CRSE_NAME                      VARCHAR2(50 BYTE),
  CRSE_NAME_F                    VARCHAR2(1 BYTE),
  CRSE_CODE                      VARCHAR2(4 BYTE),
  CRSE_YEAR_NO                   VARCHAR2(2 BYTE),
  FIRST_DEP_SURNAME              VARCHAR2(25 BYTE),
  FIRST_DEP_FORENAMES            VARCHAR2(25 BYTE),
  FIRST_DEP_DOB                  VARCHAR2(10 BYTE),
  FIRST_DEP_DOB_F                VARCHAR2(1 BYTE),
  FIRST_DEP_REL_TYPE             VARCHAR2(4 BYTE),
  FIRST_DEP_INCOME_CODE_1        VARCHAR2(2 BYTE),
  FIRST_DEP_INCOME_CODE_1_F      VARCHAR2(1 BYTE),
  FIRST_DEP_INCOME_AMOUNT_1      VARCHAR2(11 BYTE),
  FIRST_DEP_INCOME_AMOUNT_1_F    VARCHAR2(1 BYTE),
  FIRST_DEP_INCOME_CODE_2        VARCHAR2(2 BYTE),
  FIRST_DEP_INCOME_CODE_2_F      VARCHAR2(1 BYTE),
  FIRST_DEP_INCOME_AMOUNT_2      VARCHAR2(11 BYTE),
  FIRST_DEP_INCOME_AMOUNT_2_F    VARCHAR2(1 BYTE),
  FIRST_DEP_INCOME_CODE_3        VARCHAR2(2 BYTE),
  FIRST_DEP_INCOME_CODE_3_F      VARCHAR2(1 BYTE),
  FIRST_DEP_INCOME_AMOUNT_3      VARCHAR2(11 BYTE),
  FIRST_DEP_INCOME_AMOUNT_3_F    VARCHAR2(1 BYTE),
  SEC_DEP_SURNAME                VARCHAR2(25 BYTE),
  SEC_DEP_FORENAMES              VARCHAR2(25 BYTE),
  SEC_DEP_DOB                    VARCHAR2(10 BYTE),
  SEC_DEP_DOB_F                  VARCHAR2(1 BYTE),
  SEC_DEP_REL_TYPE               VARCHAR2(4 BYTE),
  SEC_DEP_INCOME_CODE_1          VARCHAR2(2 BYTE),
  SEC_DEP_INCOME_CODE_1_F        VARCHAR2(1 BYTE),
  SEC_DEP_INCOME_AMOUNT_1        VARCHAR2(11 BYTE),
  SEC_DEP_INCOME_AMOUNT_1_F      VARCHAR2(1 BYTE),
  SEC_DEP_INCOME_CODE_2          VARCHAR2(2 BYTE),
  SEC_DEP_INCOME_CODE_2_F        VARCHAR2(1 BYTE),
  SEC_DEP_INCOME_AMOUNT_2        VARCHAR2(11 BYTE),
  SEC_DEP_INCOME_AMOUNT_2_F      VARCHAR2(1 BYTE),
  SEC_DEP_INCOME_CODE_3          VARCHAR2(2 BYTE),
  SEC_DEP_INCOME_CODE_3_F        VARCHAR2(1 BYTE),
  SEC_DEP_INCOME_AMOUNT_3        VARCHAR2(11 BYTE),
  SEC_DEP_INCOME_AMOUNT_3_F      VARCHAR2(1 BYTE),
  THIRD_DEP_SURNAME              VARCHAR2(25 BYTE),
  THIRD_DEP_FORENAMES            VARCHAR2(25 BYTE),
  THIRD_DEP_DOB                  VARCHAR2(10 BYTE),
  THIRD_DEP_DOB_F                VARCHAR2(1 BYTE),
  THIRD_DEP_REL_TYPE             VARCHAR2(4 BYTE),
  THIRD_DEP_INCOME_CODE_1        VARCHAR2(2 BYTE),
  THIRD_DEP_INCOME_CODE_1_F      VARCHAR2(1 BYTE),
  THIRD_DEP_INCOME_AMOUNT_1      VARCHAR2(11 BYTE),
  THIRD_DEP_INCOME_AMOUNT_1_F    VARCHAR2(1 BYTE),
  THIRD_DEP_INCOME_CODE_2        VARCHAR2(2 BYTE),
  THIRD_DEP_INCOME_CODE_2_F      VARCHAR2(1 BYTE),
  THIRD_DEP_INCOME_AMOUNT_2      VARCHAR2(11 BYTE),
  THIRD_DEP_INCOME_AMOUNT_2_F    VARCHAR2(1 BYTE),
  THIRD_DEP_INCOME_CODE_3        VARCHAR2(2 BYTE),
  THIRD_DEP_INCOME_CODE_3_F      VARCHAR2(1 BYTE),
  THIRD_DEP_INCOME_AMOUNT_3      VARCHAR2(11 BYTE),
  THIRD_DEP_INCOME_AMOUNT_3_F    VARCHAR2(1 BYTE),
  ADD_DEP_DETAILS                VARCHAR2(1 BYTE),
  LPCG                           VARCHAR2(1 BYTE),
  TWO_HOMES_ALLOW                VARCHAR2(1 BYTE),
  VAC_GRANT                      VARCHAR2(1 BYTE),
  NET_INCOME                     VARCHAR2(10 BYTE),
  NET_INCOME_F                   VARCHAR2(1 BYTE),
  PENSION_INCOME                 VARCHAR2(10 BYTE),
  PENSION_INCOME_F               VARCHAR2(1 BYTE),
  TRUST_INCOME                   VARCHAR2(10 BYTE),
  TRUST_INCOME_F                 VARCHAR2(1 BYTE),
  AWARD_ORG                      VARCHAR2(25 BYTE),
  ANNUAL_VALUE                   VARCHAR2(10 BYTE),
  MAINTENANCE                    VARCHAR2(10 BYTE),
  FEES                           VARCHAR2(10 BYTE),
  LENGTH_OF_SUPPORT              VARCHAR2(2 BYTE),
  SUPPORT_START_DATE             VARCHAR2(10 BYTE),
  APP_FORM_SIG                   VARCHAR2(1 BYTE),
  MAX_LOAN_REQUESTED             VARCHAR2(1 BYTE),
  LOAN_REQUEST                   VARCHAR2(8 BYTE),
  LOAN_REQUEST_F                 VARCHAR2(1 BYTE),
  CONT1_FORENAME                 VARCHAR2(25 BYTE),
  CONT1_SURNAME                  VARCHAR2(25 BYTE),
  CONT1_NAME                     VARCHAR2(60 BYTE),
  CONT1_REL_CODE                 VARCHAR2(1 BYTE),
  CONT1_HOUSE_NO_NM              VARCHAR2(32 BYTE),
  CONT1_POSTCODE                 VARCHAR2(8 BYTE),
  CONT1_ADDR1                    VARCHAR2(60 BYTE),
  CONT1_ADDR2                    VARCHAR2(60 BYTE),
  CONT1_ADDR3                    VARCHAR2(30 BYTE),
  CONT1_ADDR4                    VARCHAR2(30 BYTE),
  CONT1_TEL_NO                   VARCHAR2(14 BYTE),
  CONT2_FORENAME                 VARCHAR2(25 BYTE),
  CONT2_SURNAME                  VARCHAR2(25 BYTE),
  CONT2_NAME                     VARCHAR2(60 BYTE),
  CONT2_HOUSE_NO_NM              VARCHAR2(32 BYTE),
  CONT2_POSTCODE                 VARCHAR2(8 BYTE),
  CONT2_ADDR1                    VARCHAR2(60 BYTE),
  CONT2_ADDR2                    VARCHAR2(60 BYTE),
  CONT2_ADDR3                    VARCHAR2(30 BYTE),
  CONT2_ADDR4                    VARCHAR2(30 BYTE),
  CONT2_TEL_NO                   VARCHAR2(14 BYTE),
  BANKRUPT_FLAG                  VARCHAR2(1 BYTE),
  TERM_HOUSE_NO_NAME             VARCHAR2(32 BYTE),
  TERM_POST_CODE                 VARCHAR2(8 BYTE),
  TERM_ADDR_L1                   VARCHAR2(65 BYTE),
  TERM_ADDR_L2                   VARCHAR2(65 BYTE),
  TERM_ADDR_L3                   VARCHAR2(32 BYTE),
  TERM_ADDR_L4                   VARCHAR2(32 BYTE),
  SLC_CORRES_DEST                VARCHAR2(1 BYTE),
  LOAN_SIGNATURE                 VARCHAR2(1 BYTE),
  LOAN_DECLARATION_DATE          VARCHAR2(10 BYTE),
  LOAN_DECLARATION_DATE_F        VARCHAR2(1 BYTE),
  BEN1_NI_NO                     VARCHAR2(9 BYTE),
  BEN1_NI_NO_F                   VARCHAR2(1 BYTE),
  BEN1_TITLE                     VARCHAR2(8 BYTE),
  BEN1_SURNAME                   VARCHAR2(25 BYTE),
  BEN1_FORENAMES                 VARCHAR2(25 BYTE),
  BEN1_REL_TYPE                  VARCHAR2(4 BYTE),
  BEN1_HOUSE_NO_NAME             VARCHAR2(32 BYTE),
  BEN1_POSTCODE                  VARCHAR2(8 BYTE),
  BEN1_ADDR1                     VARCHAR2(65 BYTE),
  BEN1_ADDR2                     VARCHAR2(65 BYTE),
  BEN1_ADDR3                     VARCHAR2(32 BYTE),
  BEN1_ADDR4                     VARCHAR2(32 BYTE),
  BEN1_EMP_STATUS                VARCHAR2(1 BYTE),
  BEN2_NI_NO                     VARCHAR2(9 BYTE),
  BEN2_NI_NO_F                   VARCHAR2(1 BYTE),
  BEN2_TITLE                     VARCHAR2(8 BYTE),
  BEN2_SURNAME                   VARCHAR2(25 BYTE),
  BEN2_FORENAMES                 VARCHAR2(25 BYTE),
  BEN2_REL_TYPE                  VARCHAR2(4 BYTE),
  BEN2_HOUSE_NO_NAME             VARCHAR2(32 BYTE),
  BEN2_POSTCODE                  VARCHAR2(8 BYTE),
  BEN2_ADDR1                     VARCHAR2(65 BYTE),
  BEN2_ADDR2                     VARCHAR2(65 BYTE),
  BEN2_ADDR3                     VARCHAR2(32 BYTE),
  BEN2_ADDR4                     VARCHAR2(32 BYTE),
  BEN2_EMP_STATUS                VARCHAR2(1 BYTE),
  JA_CASE                        VARCHAR2(1 BYTE),
  BEN1_PAYE                      VARCHAR2(11 BYTE),
  BEN1_PAYE_F                    VARCHAR2(1 BYTE),
  BEN2_PAYE                      VARCHAR2(11 BYTE),
  BEN2_PAYE_F                    VARCHAR2(1 BYTE),
  BEN1_SELF_EMPLOYMENT           VARCHAR2(11 BYTE),
  BEN1_SELF_EMPLOYMENT_F         VARCHAR2(1 BYTE),
  BEN2_SELF_EMPLOYMENT           VARCHAR2(11 BYTE),
  BEN2_SELF_EMPLOYMENT_F         VARCHAR2(1 BYTE),
  BEN1_PROPERTY                  VARCHAR2(11 BYTE),
  BEN1_PROPERTY_F                VARCHAR2(1 BYTE),
  BEN2_PROPERTY                  VARCHAR2(11 BYTE),
  BEN2_PROPERTY_F                VARCHAR2(1 BYTE),
  BEN1_PENSIONS                  VARCHAR2(11 BYTE),
  BEN1_PENSIONS_F                VARCHAR2(1 BYTE),
  BEN2_PENSIONS                  VARCHAR2(11 BYTE),
  BEN2_PENSIONS_F                VARCHAR2(1 BYTE),
  BEN1_BENEFITS                  VARCHAR2(11 BYTE),
  BEN1_BENEFITS_F                VARCHAR2(1 BYTE),
  BEN2_BENEFITS                  VARCHAR2(11 BYTE),
  BEN2_BENEFITS_F                VARCHAR2(1 BYTE),
  BEN1_NAT_SAVINGS               VARCHAR2(11 BYTE),
  BEN1_NAT_SAVINGS_F             VARCHAR2(1 BYTE),
  BEN2_NAT_SAVINGS               VARCHAR2(11 BYTE),
  BEN2_NAT_SAVINGS_F             VARCHAR2(1 BYTE),
  BEN1_INTEREST                  VARCHAR2(11 BYTE),
  BEN1_INTEREST_F                VARCHAR2(1 BYTE),
  BEN2_INTEREST                  VARCHAR2(11 BYTE),
  BEN2_INTEREST_F                VARCHAR2(1 BYTE),
  BEN1_DIVIDEND                  VARCHAR2(11 BYTE),
  BEN1_DIVIDEND_F                VARCHAR2(1 BYTE),
  BEN2_DIVIDEND                  VARCHAR2(11 BYTE),
  BEN2_DIVIDEND_F                VARCHAR2(1 BYTE),
  BEN1_OTHER_INC                 VARCHAR2(11 BYTE),
  BEN1_OTHER_INC_F               VARCHAR2(1 BYTE),
  BEN2_OTHER_INC                 VARCHAR2(11 BYTE),
  BEN2_OTHER_INC_F               VARCHAR2(1 BYTE),
  BEN1_SUPERANN                  VARCHAR2(11 BYTE),
  BEN1_SUPERANN_F                VARCHAR2(1 BYTE),
  BEN2_SUPERANN                  VARCHAR2(11 BYTE),
  BEN2_SUPERANN_F                VARCHAR2(1 BYTE),
  BEN1_RAP                       VARCHAR2(11 BYTE),
  BEN1_RAP_F                     VARCHAR2(1 BYTE),
  BEN2_RAP                       VARCHAR2(11 BYTE),
  BEN2_RAP_F                     VARCHAR2(1 BYTE),
  BEN1_OTHER_DED                 VARCHAR2(11 BYTE),
  BEN1_OTHER_DED_F               VARCHAR2(1 BYTE),
  BEN2_OTHER_DED                 VARCHAR2(11 BYTE),
  BEN2_OTHER_DED_F               VARCHAR2(1 BYTE),
  BEN1_FIRST_DEP_DOB             VARCHAR2(10 BYTE),
  BEN1_FIRST_DEP_DOB_F           VARCHAR2(1 BYTE),
  BEN1_SEC_DEP_DOB               VARCHAR2(10 BYTE),
  BEN1_SEC_DEP_DOB_F             VARCHAR2(1 BYTE),
  BEN1_THIRD_DEP_DOB             VARCHAR2(10 BYTE),
  BEN1_THIRD_DEP_DOB_F           VARCHAR2(1 BYTE),
  DOMESTIC_HELP                  VARCHAR2(1 BYTE),
  BEN_DEC_SIG                    VARCHAR2(1 BYTE),
  EXTRA_NOTES                    VARCHAR2(1 BYTE),
  OUT_UK                         VARCHAR2(1 BYTE),
  FAST_TRACK                     VARCHAR2(1 BYTE),
  RES_QUERY                      VARCHAR2(1 BYTE),
  ARA_SENT                       VARCHAR2(1 BYTE),
  BIRTH_CERT_FLAG                VARCHAR2(1 BYTE),
  OFFER_FLAG                     VARCHAR2(1 BYTE),
  REPEAT_YEAR                    VARCHAR2(1 BYTE),
  DATE_APPLIC_RECEIVED           VARCHAR2(10 BYTE),
  EMP_LOGIN                      VARCHAR2(30 BYTE),
  APP_FORM_SIG_DATE              VARCHAR2(10 BYTE),
  PGCE                           VARCHAR2(1 BYTE),
  DSA                            VARCHAR2(1 BYTE),
  TOT_TRAV_AMOUNT_CLAIMED        VARCHAR2(7 BYTE),
  TOT_TRAV_AMOUNT_CLAIMED_F      VARCHAR2(1 BYTE),
  MOBILE_TEL_NO                  VARCHAR2(14 BYTE),
  HOME_ADDR_MAIL_SORT            VARCHAR2(5 BYTE),
  BEN1_MAIL_SORT                 VARCHAR2(5 BYTE),
  BEN2_MAIL_SORT                 VARCHAR2(5 BYTE),
  EMAIL_ADDR                     VARCHAR2(80 BYTE),
  WEB_USER_ID                    VARCHAR2(25 BYTE),
  BANK_VALIDATE                  VARCHAR2(1 BYTE),
  EMAIL_ADDR_F                   VARCHAR2(1 BYTE),
  TERM_TIME_RESIDENCE            VARCHAR2(1 BYTE),
  TERM_TIME_RESIDENCE_F          VARCHAR2(1 BYTE),
  RELEVANT_DATE                  VARCHAR2(5 BYTE),
  RELEVANT_DATE_F                VARCHAR2(1 BYTE),
  ORDIN_RES_UK_3_YEARS           VARCHAR2(1 BYTE),
  ORDIN_RES_UK_3_YEARS_F         VARCHAR2(1 BYTE),
  ORDIN_RES_SCOT_REL_DATE        VARCHAR2(1 BYTE),
  ORDIN_RES_SCOT_REL_DATE_F      VARCHAR2(1 BYTE),
  IN_EDUC_SINCE_LEAVE_SCHOOL     VARCHAR2(1 BYTE),
  IN_EDUC_SINCE_LEAVE_SCHOOL_F   VARCHAR2(1 BYTE),
  EU_GRADUATE                    VARCHAR2(1 BYTE),
  EU_GRADUATE_F                  VARCHAR2(1 BYTE),
  STUDY_ABROAD                   VARCHAR2(1 BYTE),
  STUDY_ABROAD_F                 VARCHAR2(1 BYTE),
  PLACEMENT_YEAR                 VARCHAR2(1 BYTE),
  PLACEMENT_YEAR_F               VARCHAR2(1 BYTE),
  SECONDARY_OR_PRIMARY_ED        VARCHAR2(1 BYTE),
  SECONDARY_OR_PRIMARY_ED_F      VARCHAR2(1 BYTE),
  SECONDARY_SUBJECT              VARCHAR2(25 BYTE),
  SECONDARY_SUBJECT_F            VARCHAR2(1 BYTE),
  EXEMPT_FROM_PARENT_CONTRIB     VARCHAR2(1 BYTE),
  EXEMPT_FROM_PARENT_CONTRIB_F   VARCHAR2(1 BYTE),
  PLAN_TO_WORK_OUTSIDE_UK        VARCHAR2(1 BYTE),
  PLAN_TO_WORK_OUTSIDE_UK_F      VARCHAR2(1 BYTE),
  BEN1_FIRST_DEP_LAST_NAME       VARCHAR2(25 BYTE),
  BEN1_FIRST_DEP_LAST_NAME_F     VARCHAR2(1 BYTE),
  BEN1_FIRST_DEP_FIRST_NAME      VARCHAR2(25 BYTE),
  BEN1_FIRST_DEP_FIRST_NAME_F    VARCHAR2(1 BYTE),
  BEN1_FIRST_DEP_LEAVE_SCHOOL    VARCHAR2(1 BYTE),
  BEN1_FIRST_DEP_LEAVE_SCHOOL_F  VARCHAR2(1 BYTE),
  BEN1_SEC_DEP_LAST_NAME         VARCHAR2(25 BYTE),
  BEN1_SEC_DEP_LAST_NAME_F       VARCHAR2(1 BYTE),
  BEN1_SEC_DEP_FIRST_NAME        VARCHAR2(25 BYTE),
  BEN1_SEC_DEP_FIRST_NAME_F      VARCHAR2(1 BYTE),
  BEN1_SEC_DEP_LEAVE_SCHOOL      VARCHAR2(1 BYTE),
  BEN1_SEC_DEP_LEAVE_SCHOOL_F    VARCHAR2(1 BYTE),
  BEN1_THIRD_DEP_LAST_NAME       VARCHAR2(25 BYTE),
  BEN1_THIRD_DEP_LAST_NAME_F     VARCHAR2(1 BYTE),
  BEN1_THIRD_DEP_FIRST_NAME      VARCHAR2(25 BYTE),
  BEN1_THIRD_DEP_FIRST_NAME_F    VARCHAR2(1 BYTE),
  BEN1_THIRD_DEP_LEAVE_SCHOOL    VARCHAR2(1 BYTE),
  BEN1_THIRD_DEP_LEAVE_SCHOOL_F  VARCHAR2(1 BYTE),
  EU_STUDENT                     VARCHAR2(1 BYTE),
  NOS_YEARS_COURSE_TAKES         VARCHAR2(1 BYTE),
  ORD_RES_SCOTLAND_WEB           VARCHAR2(1 BYTE),
  ORD_RES_UK_WEB                 VARCHAR2(11 BYTE),
  MAX_FEE_LOAN                   VARCHAR2(1 BYTE),
  FEE_LOAN_AMOUNT                VARCHAR2(11 BYTE),
  FEE_LOAN_CHARGED_AMOUNT        VARCHAR2(11 BYTE),
  DEP_GRANT                      VARCHAR2(1 BYTE),
  LPG                            VARCHAR2(1 BYTE),
  MORE_THAN_3_BEN_DEPS           VARCHAR2(1 BYTE),
  MIGRANT_WORKER                 VARCHAR2(1 BYTE),
  SPOUSE_OF_MIGRANT_WORKER       VARCHAR2(1 BYTE),
  PLAN_TO_WORK_DURING_CRSE       VARCHAR2(1 BYTE),
  STUDY_FT_OR_PT                 VARCHAR2(1 BYTE),
  STUDY_FT_OR_PT_F               VARCHAR2(1 BYTE),
  AB36                           VARCHAR2(1 BYTE),
  SKILLS_DEV_DATA_SHARE          VARCHAR2(1 BYTE),
  RESIDENCE_IND                  VARCHAR2(1 BYTE),
  WORKING_TAX_CREDIT_IND         VARCHAR2(1 BYTE),
  EMPLOYMENT_SUPPORT_ALLOWANCE   VARCHAR2(1 BYTE),
  INCAPACITY_BENEFIT             VARCHAR2(1 BYTE),
  INCOME_SUPPORT                 VARCHAR2(1 BYTE),
  INVALIDITY_BENEFIT             VARCHAR2(1 BYTE),
  JOBSEEKERS_ALLOWANCE           VARCHAR2(1 BYTE),
  BEN1_WORKING_TAX_CREDIT        VARCHAR2(11 BYTE),
  BEN1_EMP_SUPPORT_ALLOWANCE     VARCHAR2(1 BYTE),
  BEN1_INCAPACITY_BENEFIT        VARCHAR2(1 BYTE),
  BEN1_INCOME_SUPPORT            VARCHAR2(1 BYTE),
  BEN1_INVALIDITY_BENEFIT        VARCHAR2(1 BYTE),
  BEN1_JOBSEEKERS_ALLOWANCE      VARCHAR2(1 BYTE),
  BEN1_MAINTENANCE_PAYMENT       VARCHAR2(1 BYTE),
  BEN2_WORKING_TAX_CREDIT        VARCHAR2(11 BYTE),
  BEN2_EMP_SUPPORT_ALLOWANCE     VARCHAR2(1 BYTE),
  BEN2_INCAPACITY_BENEFIT        VARCHAR2(1 BYTE),
  BEN2_INCOME_SUPPORT            VARCHAR2(1 BYTE),
  BEN2_INVALIDITY_BENEFIT        VARCHAR2(1 BYTE),
  BEN2_JOBSEEKERS_ALLOWANCE      VARCHAR2(1 BYTE),
  BEN2_MAINTENANCE_PAYMENT       VARCHAR2(1 BYTE),
  STUD_INCOME                    VARCHAR2(1 BYTE),
  UK_PASSPORT                    VARCHAR2(1 BYTE),
  PASSPORT_NUMBER                VARCHAR2(9 BYTE),
  PASSPORT_FIRST_NAMES           VARCHAR2(25 BYTE),
  PASSPORT_SURNAME               VARCHAR2(25 BYTE),
  PASSPORT_ISSUE_DATE            VARCHAR2(10 BYTE),
  PASSPORT_EXPIRY_DATE           VARCHAR2(10 BYTE),
  UK_BIRTH_CNTRY_CODE            NUMBER(3),
  TUITION_FEES                   VARCHAR2(1 BYTE),
  MAINTENANCE_GRANT              VARCHAR2(1 BYTE),
  BURSARY_ONLY                   VARCHAR2(1 BYTE),
  INCOME_ASSESSED_LOAN           VARCHAR2(1 BYTE),
  NON_INCOME_ASSESSED_LOAN       VARCHAR2(1 BYTE),
  YSB                            VARCHAR2(1 BYTE),
  YSB_OUTSIDE_SCOTLAND           VARCHAR2(1 BYTE),
  HEALTHCARE_FUNDING             VARCHAR2(1 BYTE),
  CLAIMING_DSA                   VARCHAR2(1 BYTE),
  INSIDE_OUTSIDE_SCOTLAND        VARCHAR2(1 BYTE),
  INSCOT_YEAR                    VARCHAR2(1 BYTE),
  CONSENT_FROM_STUDENT           VARCHAR2(1 BYTE),
  CONSENT_FROM_FATHER            VARCHAR2(1 BYTE),
  CONSENT_FROM_MOTHER            VARCHAR2(1 BYTE),
  CONSENT_FROM_HUSBAND_WIFE      VARCHAR2(1 BYTE),
  STUD_INCOME_AMT1               VARCHAR2(11 BYTE),
  STUD_INCOME_TYPE1              VARCHAR2(1 BYTE),
  STUD_INCOME_AMT2              VARCHAR2(11 BYTE),
  STUD_INCOME_TYPE2              VARCHAR2(1 BYTE),
  STUD_INCOME_AMT3               VARCHAR2(11 BYTE),
  STUD_INCOME_TYPE3              VARCHAR2(1 BYTE),
  STUD_INCOME_AMT4               VARCHAR2(11 BYTE),
  STUD_INCOME_TYPE4              VARCHAR2(1 BYTE),
  STUD_INCOME_AMT5               VARCHAR2(11 BYTE),
  STUD_INCOME_TYPE5              VARCHAR2(1 BYTE),
  STUD_INCOME_AMT6               VARCHAR2(11 BYTE),
  STUD_INCOME_TYPE6              VARCHAR2(1 BYTE),
  REASON_NO_INCOME_BEN1          VARCHAR2(60 BYTE),
  REASON_NO_INCOME_BEN2          VARCHAR2(60 BYTE)
)
TABLESPACE EDM_DATA
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN EDM.RAW_DATA.BEN1_THIRD_DEP_FIRST_NAME IS 'Third dependants first name';

COMMENT ON COLUMN EDM.RAW_DATA.BEN1_THIRD_DEP_LEAVE_SCHOOL IS 'Third dependant, will they leave school before previous sessions school year Can be Y or n or Null.';

COMMENT ON COLUMN EDM.RAW_DATA.EU_STUDENT IS 'Whether the applicant is a non-UK EU student';

COMMENT ON COLUMN EDM.RAW_DATA.NOS_YEARS_COURSE_TAKES IS 'Duration of course, in years';

COMMENT ON COLUMN EDM.RAW_DATA.ORD_RES_SCOTLAND_WEB IS 'Whether the applicant is ordinarily resident in Scotland on 01 Aug YYYY.';

COMMENT ON COLUMN EDM.RAW_DATA.ORD_RES_UK_WEB IS 'Capture whether the applicant has been ordinarily resident in the UK for the last three years since 01 Aug YYYY.';

COMMENT ON COLUMN EDM.RAW_DATA.MAX_FEE_LOAN IS 'Maximum fee loan is being claimed values: Y or N';

COMMENT ON COLUMN EDM.RAW_DATA.FEE_LOAN_AMOUNT IS 'Fee loan amount claimed';

COMMENT ON COLUMN EDM.RAW_DATA.FEE_LOAN_CHARGED_AMOUNT IS 'Amount charged by institution';

COMMENT ON COLUMN EDM.RAW_DATA.DEP_GRANT IS 'Whether dependants? grant claimed.';

COMMENT ON COLUMN EDM.RAW_DATA.LPG IS 'Whether loan parents? grant claimed.';

COMMENT ON COLUMN EDM.RAW_DATA.MORE_THAN_3_BEN_DEPS IS 'Flag which if set = Y indicates that the benefactor has moer than 3 dependants.  If the flag is set to N this indicates that the benefactor has none or < 3 dependants.';

COMMENT ON COLUMN EDM.RAW_DATA.MIGRANT_WORKER IS 'Identifies if the student is a migrant worker.  Can be Y or N';

COMMENT ON COLUMN EDM.RAW_DATA.SPOUSE_OF_MIGRANT_WORKER IS 'Identifies if the student is the spouse of a migrant worker.  Can be Y or N';

COMMENT ON COLUMN EDM.RAW_DATA.PLAN_TO_WORK_DURING_CRSE IS 'Identifies if the student plans to work FT or PT during their course.  Can be Y or N';

COMMENT ON COLUMN EDM.RAW_DATA.STUDY_FT_OR_PT IS 'Identifies if the students course is FT or PT.  Can be F or P';

COMMENT ON COLUMN EDM.RAW_DATA.INSCOT_YEAR IS 'Will be populated with ?Y? if ?Yes? is selected. Will be populated with ?N? if ?No? is selected. Will be NULL if nothing is entered, if question is not dynamically displayed.';

COMMENT ON COLUMN EDM.RAW_DATA.CONSENT_FROM_STUDENT IS 'Will be populated with ?Y? if ?Yes? is checked. Will be populated with ?N? if it is unchecked.';

COMMENT ON COLUMN EDM.RAW_DATA.CONSENT_FROM_FATHER IS 'Will be populated with ?Y? if ?Yes? is checked. Will be populated with ?N? if it is unchecked.';

COMMENT ON COLUMN EDM.RAW_DATA.CONSENT_FROM_MOTHER IS 'Will be populated with ?Y? if ?Yes? is checked. Will be populated with ?N? if it is unchecked.';

COMMENT ON COLUMN EDM.RAW_DATA.CONSENT_FROM_HUSBAND_WIFE IS 'Will be populated with ?Y? if ?Yes? is checked. Will be populated with ?N? if it is unchecked.';

COMMENT ON COLUMN EDM.RAW_DATA.TERM_TIME_RESIDENCE IS 'Where will you be staying during term time? Parents?Home (H) or Elsewhere (E)';

COMMENT ON COLUMN EDM.RAW_DATA.RELEVANT_DATE IS 'Relevant date ? Text Value passed one of :?G?or ?N?or ?RIL?or ?LY?or Null';

COMMENT ON COLUMN EDM.RAW_DATA.ORDIN_RES_UK_3_YEARS IS 'Ordinarily resident in the UK continuously for 3 years before relevant date?Can be Y or N.';

COMMENT ON COLUMN EDM.RAW_DATA.ORDIN_RES_SCOT_REL_DATE IS 'Have you been, or will you be, ordinarily resident in Scotland on your relevant date? Can be Y or N.';

COMMENT ON COLUMN EDM.RAW_DATA.IN_EDUC_SINCE_LEAVE_SCHOOL IS 'Have you been in education at any time since leaving school Can be Y or N or Null.';

COMMENT ON COLUMN EDM.RAW_DATA.EU_GRADUATE IS 'EU students ? do you plan to graduate? Can be Y or N or Null.';

COMMENT ON COLUMN EDM.RAW_DATA.STUDY_ABROAD IS 'Study Abroad Can be Y or N or Null.';

COMMENT ON COLUMN EDM.RAW_DATA.PLACEMENT_YEAR IS 'Placement year Can be Y or N or Null.';

COMMENT ON COLUMN EDM.RAW_DATA.SECONDARY_OR_PRIMARY_ED IS 'Secondary or Primary 1 = Secondary or 2 = Primary';

COMMENT ON COLUMN EDM.RAW_DATA.SECONDARY_SUBJECT IS 'Secondary subject';

COMMENT ON COLUMN EDM.RAW_DATA.EXEMPT_FROM_PARENT_CONTRIB IS 'Benefactor Exempt Can be Y or N or Null.';

COMMENT ON COLUMN EDM.RAW_DATA.PLAN_TO_WORK_OUTSIDE_UK IS 'Do you plan to work outside the uk? Can be Y or N or Null.';

COMMENT ON COLUMN EDM.RAW_DATA.BEN1_FIRST_DEP_LAST_NAME IS 'First dependants last name';

COMMENT ON COLUMN EDM.RAW_DATA.BEN1_FIRST_DEP_FIRST_NAME IS 'First dependants first name';

COMMENT ON COLUMN EDM.RAW_DATA.BEN1_FIRST_DEP_LEAVE_SCHOOL IS 'First dependant, will they leave school before previous sessions school year Can be Y or n or Null.';

COMMENT ON COLUMN EDM.RAW_DATA.BEN1_SEC_DEP_LAST_NAME IS 'Second dependants last name';

COMMENT ON COLUMN EDM.RAW_DATA.BEN1_SEC_DEP_FIRST_NAME IS 'Second dependants first name';

COMMENT ON COLUMN EDM.RAW_DATA.BEN1_SEC_DEP_LEAVE_SCHOOL IS 'Second dependant, will they leave school before previous sessions school year Can be Y or n or Null.';

COMMENT ON COLUMN EDM.RAW_DATA.BEN1_THIRD_DEP_LAST_NAME IS 'Third dependants last name';


CREATE OR REPLACE TRIGGER EDM.trig_auth_stud
   AFTER INSERT
   ON EDM.RAW_DATA    REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   p_web_user_id   raw_data.web_user_id%TYPE   := :NEW.web_user_id;
   p_stud_ref_no   raw_data.stud_ref_no%TYPE   := :NEW.stud_ref_no;
   error_message   VARCHAR2 (512);
/******************************************************************************
NAME: TRIG_AUTH_STUD
PURPOSE: After Insert trigger on EDM.RAW_DATA to authenticate student

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        14.07.2009  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/edm/tables/RAW_DATA.sql $
$Author: $
$Date: 2012-11-27 15:59:05 +0000 (Tue, 27 Nov 2012) $
$Revision: 8376 $

*******************************************************************************/
BEGIN


   IF p_stud_ref_no IS NOT NULL AND p_web_user_id IS NOT NULL
   THEN
      sgas.pk_steps_web.authenticate_student (:NEW.stud_ref_no,
                                         :NEW.web_user_id,
                                         error_message
                                        );

      IF (error_message IS NOT NULL)
      THEN
         raise_application_error
                              (-20000,
                                  'pk_steps_web.authenticate_student error: '
                               || error_message
                              );
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20000,
                               'TRIG_AUTH_STUD error: ' || SQLERRM || SQLCODE
                              );
END trig_auth_stud;
/
SHOW ERRORS;



/* Formatted on 2012/11/27 15:48 (Formatter Plus v4.8.8) */
CREATE OR REPLACE TRIGGER edm.raw_data$audit_trig
   AFTER INSERT OR UPDATE
   ON edm.raw_data
   FOR EACH ROW
DECLARE
   v_operation   VARCHAR2 (10) := NULL;
BEGIN
   IF INSERTING
   THEN
      v_operation := 'INS';
   ELSIF UPDATING
   THEN
      v_operation := 'UPD';
   END IF;

   IF INSERTING OR UPDATING
   THEN
      INSERT INTO edm.raw_data$test_data
                  (object_id, raw_data_id, batch_id,
                   envelope_id, supplementary_grants,
                   stud_ref_no, scottish_cand, ni_no,
                   ni_no_f, title, surname, forenames,
                   birth_surname, birth_forenames, dob,
                   dob_f, district_birth_cert_issued, sex,
                   marital_status, marriage_date,
                   home_house_no_name, home_post_code,
                   home_addr_l1, home_addr_l2, home_addr_l3,
                   home_addr_l4, home_tele_no, sort_code,
                   sort_code_f, account_no, account_no_f,
                   birth_country_code, birth_country_code_f,
                   nation_country_code, nation_country_code_f,
                   residence_country_code,
                   residence_country_code_f, inst_name,
                   inst_name_f, inst_code, crse_name,
                   crse_name_f, crse_code, crse_year_no,
                   first_dep_surname, first_dep_forenames,
                   first_dep_dob, first_dep_dob_f,
                   first_dep_rel_type, first_dep_income_code_1,
                   first_dep_income_code_1_f,
                   first_dep_income_amount_1,
                   first_dep_income_amount_1_f,
                   first_dep_income_code_2,
                   first_dep_income_code_2_f,
                   first_dep_income_amount_2,
                   first_dep_income_amount_2_f,
                   first_dep_income_code_3,
                   first_dep_income_code_3_f,
                   first_dep_income_amount_3,
                   first_dep_income_amount_3_f, sec_dep_surname,
                   sec_dep_forenames, sec_dep_dob,
                   sec_dep_dob_f, sec_dep_rel_type,
                   sec_dep_income_code_1, sec_dep_income_code_1_f,
                   sec_dep_income_amount_1,
                   sec_dep_income_amount_1_f,
                   sec_dep_income_code_2, sec_dep_income_code_2_f,
                   sec_dep_income_amount_2,
                   sec_dep_income_amount_2_f,
                   sec_dep_income_code_3, sec_dep_income_code_3_f,
                   sec_dep_income_amount_3,
                   sec_dep_income_amount_3_f, third_dep_surname,
                   third_dep_forenames, third_dep_dob,
                   third_dep_dob_f, third_dep_rel_type,
                   third_dep_income_code_1,
                   third_dep_income_code_1_f,
                   third_dep_income_amount_1,
                   third_dep_income_amount_1_f,
                   third_dep_income_code_2,
                   third_dep_income_code_2_f,
                   third_dep_income_amount_2,
                   third_dep_income_amount_2_f,
                   third_dep_income_code_3,
                   third_dep_income_code_3_f,
                   third_dep_income_amount_3,
                   third_dep_income_amount_3_f, add_dep_details,
                   lpcg, two_homes_allow, vac_grant,
                   net_income, net_income_f, pension_income,
                   pension_income_f, trust_income,
                   trust_income_f, award_org, annual_value,
                   maintenance, fees, length_of_support,
                   support_start_date, app_form_sig,
                   max_loan_requested, loan_request,
                   loan_request_f, cont1_forename,
                   cont1_surname, cont1_name, cont1_rel_code,
                   cont1_house_no_nm, cont1_postcode,
                   cont1_addr1, cont1_addr2, cont1_addr3,
                   cont1_addr4, cont1_tel_no, cont2_forename,
                   cont2_surname, cont2_name,
                   cont2_house_no_nm, cont2_postcode,
                   cont2_addr1, cont2_addr2, cont2_addr3,
                   cont2_addr4, cont2_tel_no, bankrupt_flag,
                   term_house_no_name, term_post_code,
                   term_addr_l1, term_addr_l2, term_addr_l3,
                   term_addr_l4, slc_corres_dest,
                   loan_signature, loan_declaration_date,
                   loan_declaration_date_f, ben1_ni_no,
                   ben1_ni_no_f, ben1_title, ben1_surname,
                   ben1_forenames, ben1_rel_type,
                   ben1_house_no_name, ben1_postcode,
                   ben1_addr1, ben1_addr2, ben1_addr3,
                   ben1_addr4, ben1_emp_status, ben2_ni_no,
                   ben2_ni_no_f, ben2_title, ben2_surname,
                   ben2_forenames, ben2_rel_type,
                   ben2_house_no_name, ben2_postcode,
                   ben2_addr1, ben2_addr2, ben2_addr3,
                   ben2_addr4, ben2_emp_status, ja_case,
                   ben1_paye, ben1_paye_f, ben2_paye,
                   ben2_paye_f, ben1_self_employment,
                   ben1_self_employment_f, ben2_self_employment,
                   ben2_self_employment_f, ben1_property,
                   ben1_property_f, ben2_property,
                   ben2_property_f, ben1_pensions,
                   ben1_pensions_f, ben2_pensions,
                   ben2_pensions_f, ben1_benefits,
                   ben1_benefits_f, ben2_benefits,
                   ben2_benefits_f, ben1_nat_savings,
                   ben1_nat_savings_f, ben2_nat_savings,
                   ben2_nat_savings_f, ben1_interest,
                   ben1_interest_f, ben2_interest,
                   ben2_interest_f, ben1_dividend,
                   ben1_dividend_f, ben2_dividend,
                   ben2_dividend_f, ben1_other_inc,
                   ben1_other_inc_f, ben2_other_inc,
                   ben2_other_inc_f, ben1_superann,
                   ben1_superann_f, ben2_superann,
                   ben2_superann_f, ben1_rap, ben1_rap_f,
                   ben2_rap, ben2_rap_f, ben1_other_ded,
                   ben1_other_ded_f, ben2_other_ded,
                   ben2_other_ded_f, ben1_first_dep_dob,
                   ben1_first_dep_dob_f, ben1_sec_dep_dob,
                   ben1_sec_dep_dob_f, ben1_third_dep_dob,
                   ben1_third_dep_dob_f, domestic_help,
                   ben_dec_sig, extra_notes, out_uk,
                   fast_track, res_query, ara_sent,
                   birth_cert_flag, offer_flag, repeat_year,
                   date_applic_received, emp_login,
                   app_form_sig_date, pgce, dsa,
                   tot_trav_amount_claimed,
                   tot_trav_amount_claimed_f, mobile_tel_no,
                   home_addr_mail_sort, ben1_mail_sort,
                   ben2_mail_sort, email_addr, web_user_id,
                   bank_validate, email_addr_f,
                   term_time_residence, term_time_residence_f,
                   relevant_date, relevant_date_f,
                   ordin_res_uk_3_years, ordin_res_uk_3_years_f,
                   ordin_res_scot_rel_date,
                   ordin_res_scot_rel_date_f,
                   in_educ_since_leave_school,
                   in_educ_since_leave_school_f, eu_graduate,
                   eu_graduate_f, study_abroad,
                   study_abroad_f, placement_year,
                   placement_year_f, secondary_or_primary_ed,
                   secondary_or_primary_ed_f, secondary_subject,
                   secondary_subject_f,
                   exempt_from_parent_contrib,
                   exempt_from_parent_contrib_f,
                   plan_to_work_outside_uk,
                   plan_to_work_outside_uk_f,
                   ben1_first_dep_last_name,
                   ben1_first_dep_last_name_f,
                   ben1_first_dep_first_name,
                   ben1_first_dep_first_name_f,
                   ben1_first_dep_leave_school,
                   ben1_first_dep_leave_school_f,
                   ben1_sec_dep_last_name,
                   ben1_sec_dep_last_name_f,
                   ben1_sec_dep_first_name,
                   ben1_sec_dep_first_name_f,
                   ben1_sec_dep_leave_school,
                   ben1_sec_dep_leave_school_f,
                   ben1_third_dep_last_name,
                   ben1_third_dep_last_name_f,
                   ben1_third_dep_first_name,
                   ben1_third_dep_first_name_f,
                   ben1_third_dep_leave_school,
                   ben1_third_dep_leave_school_f, eu_student,
                   nos_years_course_takes, ord_res_scotland_web,
                   ord_res_uk_web, max_fee_loan,
                   fee_loan_amount, fee_loan_charged_amount,
                   dep_grant, lpg, more_than_3_ben_deps,
                   migrant_worker, spouse_of_migrant_worker,
                   plan_to_work_during_crse, study_ft_or_pt,
                   study_ft_or_pt_f, ben1_working_tax_credit,
                   ben1_emp_support_allowance,
                   ben1_incapacity_benefit, ben1_income_support,
                   ben1_invalidity_benefit,
                   ben1_jobseekers_allowance,
                   ben1_maintenance_payment,
                   ben2_working_tax_credit,
                   ben2_emp_support_allowance,
                   ben2_incapacity_benefit, ben2_income_support,
                   ben2_invalidity_benefit,
                   ben2_jobseekers_allowance,
                   ben2_maintenance_payment, stud_income,
                   ab36, skills_dev_data_share,
                   residence_ind, working_tax_credit_ind,
                   employment_support_allowance,
                   incapacity_benefit, income_support,
                   invalidity_benefit, jobseekers_allowance,
                   uk_passport, passport_number,
                   passport_first_names, passport_surname,
                   passport_issue_date, passport_expiry_date,
                   uk_birth_cntry_code, tuition_fees,
                   maintenance_grant, bursary_only,
                   income_assessed_loan, non_income_assessed_loan,
                   ysb, ysb_outside_scotland,
                   healthcare_funding, claiming_dsa,
                   inside_outside_scotland, inscot_year,
                   consent_from_student, consent_from_father,
                   consent_from_mother, consent_from_husband_wife,
                   aud_action, aud_timestamp, aud_user, stud_income_amt1,
                   stud_income_type1, stud_income_amt2,
                   stud_income_type2, stud_income_amt3,
                   stud_income_type3, stud_income_amt4,
                   stud_income_type4, stud_income_amt5,
                   stud_income_type5, stud_income_amt6,
                   stud_income_type6, reason_no_income_ben1,
                   reason_no_income_ben2
                  )
           VALUES (:NEW.object_id, :NEW.raw_data_id, :NEW.batch_id,
                   :NEW.envelope_id, :NEW.supplementary_grants,
                   :NEW.stud_ref_no, :NEW.scottish_cand, :NEW.ni_no,
                   :NEW.ni_no_f, :NEW.title, :NEW.surname, :NEW.forenames,
                   :NEW.birth_surname, :NEW.birth_forenames, :NEW.dob,
                   :NEW.dob_f, :NEW.district_birth_cert_issued, :NEW.sex,
                   :NEW.marital_status, :NEW.marriage_date,
                   :NEW.home_house_no_name, :NEW.home_post_code,
                   :NEW.home_addr_l1, :NEW.home_addr_l2, :NEW.home_addr_l3,
                   :NEW.home_addr_l4, :NEW.home_tele_no, :NEW.sort_code,
                   :NEW.sort_code_f, :NEW.account_no, :NEW.account_no_f,
                   :NEW.birth_country_code, :NEW.birth_country_code_f,
                   :NEW.nation_country_code, :NEW.nation_country_code_f,
                   :NEW.residence_country_code,
                   :NEW.residence_country_code_f, :NEW.inst_name,
                   :NEW.inst_name_f, :NEW.inst_code, :NEW.crse_name,
                   :NEW.crse_name_f, :NEW.crse_code, :NEW.crse_year_no,
                   :NEW.first_dep_surname, :NEW.first_dep_forenames,
                   :NEW.first_dep_dob, :NEW.first_dep_dob_f,
                   :NEW.first_dep_rel_type, :NEW.first_dep_income_code_1,
                   :NEW.first_dep_income_code_1_f,
                   :NEW.first_dep_income_amount_1,
                   :NEW.first_dep_income_amount_1_f,
                   :NEW.first_dep_income_code_2,
                   :NEW.first_dep_income_code_2_f,
                   :NEW.first_dep_income_amount_2,
                   :NEW.first_dep_income_amount_2_f,
                   :NEW.first_dep_income_code_3,
                   :NEW.first_dep_income_code_3_f,
                   :NEW.first_dep_income_amount_3,
                   :NEW.first_dep_income_amount_3_f, :NEW.sec_dep_surname,
                   :NEW.sec_dep_forenames, :NEW.sec_dep_dob,
                   :NEW.sec_dep_dob_f, :NEW.sec_dep_rel_type,
                   :NEW.sec_dep_income_code_1, :NEW.sec_dep_income_code_1_f,
                   :NEW.sec_dep_income_amount_1,
                   :NEW.sec_dep_income_amount_1_f,
                   :NEW.sec_dep_income_code_2, :NEW.sec_dep_income_code_2_f,
                   :NEW.sec_dep_income_amount_2,
                   :NEW.sec_dep_income_amount_2_f,
                   :NEW.sec_dep_income_code_3, :NEW.sec_dep_income_code_3_f,
                   :NEW.sec_dep_income_amount_3,
                   :NEW.sec_dep_income_amount_3_f, :NEW.third_dep_surname,
                   :NEW.third_dep_forenames, :NEW.third_dep_dob,
                   :NEW.third_dep_dob_f, :NEW.third_dep_rel_type,
                   :NEW.third_dep_income_code_1,
                   :NEW.third_dep_income_code_1_f,
                   :NEW.third_dep_income_amount_1,
                   :NEW.third_dep_income_amount_1_f,
                   :NEW.third_dep_income_code_2,
                   :NEW.third_dep_income_code_2_f,
                   :NEW.third_dep_income_amount_2,
                   :NEW.third_dep_income_amount_2_f,
                   :NEW.third_dep_income_code_3,
                   :NEW.third_dep_income_code_3_f,
                   :NEW.third_dep_income_amount_3,
                   :NEW.third_dep_income_amount_3_f, :NEW.add_dep_details,
                   :NEW.lpcg, :NEW.two_homes_allow, :NEW.vac_grant,
                   :NEW.net_income, :NEW.net_income_f, :NEW.pension_income,
                   :NEW.pension_income_f, :NEW.trust_income,
                   :NEW.trust_income_f, :NEW.award_org, :NEW.annual_value,
                   :NEW.maintenance, :NEW.fees, :NEW.length_of_support,
                   :NEW.support_start_date, :NEW.app_form_sig,
                   :NEW.max_loan_requested, :NEW.loan_request,
                   :NEW.loan_request_f, :NEW.cont1_forename,
                   :NEW.cont1_surname, :NEW.cont1_name, :NEW.cont1_rel_code,
                   :NEW.cont1_house_no_nm, :NEW.cont1_postcode,
                   :NEW.cont1_addr1, :NEW.cont1_addr2, :NEW.cont1_addr3,
                   :NEW.cont1_addr4, :NEW.cont1_tel_no, :NEW.cont2_forename,
                   :NEW.cont2_surname, :NEW.cont2_name,
                   :NEW.cont2_house_no_nm, :NEW.cont2_postcode,
                   :NEW.cont2_addr1, :NEW.cont2_addr2, :NEW.cont2_addr3,
                   :NEW.cont2_addr4, :NEW.cont2_tel_no, :NEW.bankrupt_flag,
                   :NEW.term_house_no_name, :NEW.term_post_code,
                   :NEW.term_addr_l1, :NEW.term_addr_l2, :NEW.term_addr_l3,
                   :NEW.term_addr_l4, :NEW.slc_corres_dest,
                   :NEW.loan_signature, :NEW.loan_declaration_date,
                   :NEW.loan_declaration_date_f, :NEW.ben1_ni_no,
                   :NEW.ben1_ni_no_f, :NEW.ben1_title, :NEW.ben1_surname,
                   :NEW.ben1_forenames, :NEW.ben1_rel_type,
                   :NEW.ben1_house_no_name, :NEW.ben1_postcode,
                   :NEW.ben1_addr1, :NEW.ben1_addr2, :NEW.ben1_addr3,
                   :NEW.ben1_addr4, :NEW.ben1_emp_status, :NEW.ben2_ni_no,
                   :NEW.ben2_ni_no_f, :NEW.ben2_title, :NEW.ben2_surname,
                   :NEW.ben2_forenames, :NEW.ben2_rel_type,
                   :NEW.ben2_house_no_name, :NEW.ben2_postcode,
                   :NEW.ben2_addr1, :NEW.ben2_addr2, :NEW.ben2_addr3,
                   :NEW.ben2_addr4, :NEW.ben2_emp_status, :NEW.ja_case,
                   :NEW.ben1_paye, :NEW.ben1_paye_f, :NEW.ben2_paye,
                   :NEW.ben2_paye_f, :NEW.ben1_self_employment,
                   :NEW.ben1_self_employment_f, :NEW.ben2_self_employment,
                   :NEW.ben2_self_employment_f, :NEW.ben1_property,
                   :NEW.ben1_property_f, :NEW.ben2_property,
                   :NEW.ben2_property_f, :NEW.ben1_pensions,
                   :NEW.ben1_pensions_f, :NEW.ben2_pensions,
                   :NEW.ben2_pensions_f, :NEW.ben1_benefits,
                   :NEW.ben1_benefits_f, :NEW.ben2_benefits,
                   :NEW.ben2_benefits_f, :NEW.ben1_nat_savings,
                   :NEW.ben1_nat_savings_f, :NEW.ben2_nat_savings,
                   :NEW.ben2_nat_savings_f, :NEW.ben1_interest,
                   :NEW.ben1_interest_f, :NEW.ben2_interest,
                   :NEW.ben2_interest_f, :NEW.ben1_dividend,
                   :NEW.ben1_dividend_f, :NEW.ben2_dividend,
                   :NEW.ben2_dividend_f, :NEW.ben1_other_inc,
                   :NEW.ben1_other_inc_f, :NEW.ben2_other_inc,
                   :NEW.ben2_other_inc_f, :NEW.ben1_superann,
                   :NEW.ben1_superann_f, :NEW.ben2_superann,
                   :NEW.ben2_superann_f, :NEW.ben1_rap, :NEW.ben1_rap_f,
                   :NEW.ben2_rap, :NEW.ben2_rap_f, :NEW.ben1_other_ded,
                   :NEW.ben1_other_ded_f, :NEW.ben2_other_ded,
                   :NEW.ben2_other_ded_f, :NEW.ben1_first_dep_dob,
                   :NEW.ben1_first_dep_dob_f, :NEW.ben1_sec_dep_dob,
                   :NEW.ben1_sec_dep_dob_f, :NEW.ben1_third_dep_dob,
                   :NEW.ben1_third_dep_dob_f, :NEW.domestic_help,
                   :NEW.ben_dec_sig, :NEW.extra_notes, :NEW.out_uk,
                   :NEW.fast_track, :NEW.res_query, :NEW.ara_sent,
                   :NEW.birth_cert_flag, :NEW.offer_flag, :NEW.repeat_year,
                   :NEW.date_applic_received, :NEW.emp_login,
                   :NEW.app_form_sig_date, :NEW.pgce, :NEW.dsa,
                   :NEW.tot_trav_amount_claimed,
                   :NEW.tot_trav_amount_claimed_f, :NEW.mobile_tel_no,
                   :NEW.home_addr_mail_sort, :NEW.ben1_mail_sort,
                   :NEW.ben2_mail_sort, :NEW.email_addr, :NEW.web_user_id,
                   :NEW.bank_validate, :NEW.email_addr_f,
                   :NEW.term_time_residence, :NEW.term_time_residence_f,
                   :NEW.relevant_date, :NEW.relevant_date_f,
                   :NEW.ordin_res_uk_3_years, :NEW.ordin_res_uk_3_years_f,
                   :NEW.ordin_res_scot_rel_date,
                   :NEW.ordin_res_scot_rel_date_f,
                   :NEW.in_educ_since_leave_school,
                   :NEW.in_educ_since_leave_school_f, :NEW.eu_graduate,
                   :NEW.eu_graduate_f, :NEW.study_abroad,
                   :NEW.study_abroad_f, :NEW.placement_year,
                   :NEW.placement_year_f, :NEW.secondary_or_primary_ed,
                   :NEW.secondary_or_primary_ed_f, :NEW.secondary_subject,
                   :NEW.secondary_subject_f,
                   :NEW.exempt_from_parent_contrib,
                   :NEW.exempt_from_parent_contrib_f,
                   :NEW.plan_to_work_outside_uk,
                   :NEW.plan_to_work_outside_uk_f,
                   :NEW.ben1_first_dep_last_name,
                   :NEW.ben1_first_dep_last_name_f,
                   :NEW.ben1_first_dep_first_name,
                   :NEW.ben1_first_dep_first_name_f,
                   :NEW.ben1_first_dep_leave_school,
                   :NEW.ben1_first_dep_leave_school_f,
                   :NEW.ben1_sec_dep_last_name,
                   :NEW.ben1_sec_dep_last_name_f,
                   :NEW.ben1_sec_dep_first_name,
                   :NEW.ben1_sec_dep_first_name_f,
                   :NEW.ben1_sec_dep_leave_school,
                   :NEW.ben1_sec_dep_leave_school_f,
                   :NEW.ben1_third_dep_last_name,
                   :NEW.ben1_third_dep_last_name_f,
                   :NEW.ben1_third_dep_first_name,
                   :NEW.ben1_third_dep_first_name_f,
                   :NEW.ben1_third_dep_leave_school,
                   :NEW.ben1_third_dep_leave_school_f, :NEW.eu_student,
                   :NEW.nos_years_course_takes, :NEW.ord_res_scotland_web,
                   :NEW.ord_res_uk_web, :NEW.max_fee_loan,
                   :NEW.fee_loan_amount, :NEW.fee_loan_charged_amount,
                   :NEW.dep_grant, :NEW.lpg, :NEW.more_than_3_ben_deps,
                   :NEW.migrant_worker, :NEW.spouse_of_migrant_worker,
                   :NEW.plan_to_work_during_crse, :NEW.study_ft_or_pt,
                   :NEW.study_ft_or_pt_f, :NEW.ben1_working_tax_credit,
                   :NEW.ben1_emp_support_allowance,
                   :NEW.ben1_incapacity_benefit, :NEW.ben1_income_support,
                   :NEW.ben1_invalidity_benefit,
                   :NEW.ben1_jobseekers_allowance,
                   :NEW.ben1_maintenance_payment,
                   :NEW.ben2_working_tax_credit,
                   :NEW.ben2_emp_support_allowance,
                   :NEW.ben2_incapacity_benefit, :NEW.ben2_income_support,
                   :NEW.ben2_invalidity_benefit,
                   :NEW.ben2_jobseekers_allowance,
                   :NEW.ben2_maintenance_payment, :NEW.stud_income,
                   :NEW.ab36, :NEW.skills_dev_data_share,
                   :NEW.residence_ind, :NEW.working_tax_credit_ind,
                   :NEW.employment_support_allowance,
                   :NEW.incapacity_benefit, :NEW.income_support,
                   :NEW.invalidity_benefit, :NEW.jobseekers_allowance,
                   :NEW.uk_passport, :NEW.passport_number,
                   :NEW.passport_first_names, :NEW.passport_surname,
                   :NEW.passport_issue_date, :NEW.passport_expiry_date,
                   :NEW.uk_birth_cntry_code, :NEW.tuition_fees,
                   :NEW.maintenance_grant, :NEW.bursary_only,
                   :NEW.income_assessed_loan, :NEW.non_income_assessed_loan,
                   :NEW.ysb, :NEW.ysb_outside_scotland,
                   :NEW.healthcare_funding, :NEW.claiming_dsa,
                   :NEW.inside_outside_scotland, :NEW.inscot_year,
                   :NEW.consent_from_student, :NEW.consent_from_father,
                   :NEW.consent_from_mother, :NEW.consent_from_husband_wife,
                   v_operation, SYSDATE, USER, :NEW.stud_income_amt1,
                   :NEW.stud_income_type1, :NEW.stud_income_amt2,
                   :NEW.stud_income_type2, :NEW.stud_income_amt3,
                   :NEW.stud_income_type3, :NEW.stud_income_amt4,
                   :NEW.stud_income_type4, :NEW.stud_income_amt5,
                   :NEW.stud_income_type5, :NEW.stud_income_amt6,
                   :NEW.stud_income_type6, :NEW.reason_no_income_ben1,
                   :NEW.reason_no_income_ben2
                  );
   END IF;
END;
/
SHOW ERRORS;

-- 
-- Non Foreign Key Constraints for Table RAW_DATA 
-- 
ALTER TABLE edm.RAW_DATA ADD (
  CONSTRAINT TOT_TRAV_AMOUNT_CLAIMED_F_CC01
 CHECK (tot_trav_amount_claimed_f  in ('Y','N')))
/


--
-- Administer grants
-- 
GRANT ALTER ON edm.RAW_DATA TO PUBLIC
/

GRANT DELETE ON edm.RAW_DATA TO PUBLIC
/

GRANT INDEX ON edm.RAW_DATA TO PUBLIC
/

GRANT INSERT ON edm.RAW_DATA TO PUBLIC
/

GRANT DEBUG ON edm.RAW_DATA TO PUBLIC
/

GRANT UPDATE ON edm.RAW_DATA TO PUBLIC
/

GRANT REFERENCES ON edm.RAW_DATA TO PUBLIC
/

GRANT ON COMMIT REFRESH ON edm.RAW_DATA TO PUBLIC
/

GRANT QUERY REWRITE ON edm.RAW_DATA TO PUBLIC
/

GRANT SELECT ON edm.RAW_DATA TO PUBLIC
/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM RAW_DATA
/

CREATE PUBLIC SYNONYM RAW_DATA FOR EDM.RAW_DATA
/
