/* Formatted on 10/10/2013 09:17:48 (QP5 v5.215.12089.38647) */
-- SLC_CR_DATA.sql
-- Description:
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      24.09.13    A.Bowman (SAAS)         Initial Version.
-- 1.1      06.11.13    J.Wynne (SAAS)          Increased Title from varchar2(4) to varchar2(10)
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE SGAS.SLC_CR_DATA DROP PRIMARY KEY CASCADE;

DROP TABLE SGAS.SLC_CR_DATA CASCADE CONSTRAINTS;

CREATE TABLE SGAS.SLC_CR_DATA
(
   SLC_FILENAME               VARCHAR2 (25) NOT NULL,
   SLC_FILE_DATE              DATE NOT NULL,
   RECORD_NO                  NUMBER (6),
   SLC_CR_STATUS              NUMBER (2),
   STUD_CRSE_YEAR_ID          NUMBER (9) NOT NULL,
   ACADEMIC_YEAR              NUMBER (4),
   ATTENDANCE_STATUS          VARCHAR2 (1),
   DECEASED                   VARCHAR2 (1),
   STATUS_TYPE                VARCHAR2 (1) CHECK (STATUS_TYPE IN ('S', 'H')),
   NON_HEI_PAYMENT_ROUTE      VARCHAR2 (1),
   SLC_SSN                    VARCHAR2 (13),
   UCAS_NO                    VARCHAR2 (9),
   HEI_CODE                   VARCHAR2 (4),
   COURSE_CODE                VARCHAR2 (6),
   YEAR_OF_COURSE             NUMBER (1),
   TITLE                      VARCHAR2 (10), -- Holds SLC title values. Not SAAS.
   SURNAME                    VARCHAR2 (30),
   FORENAMES                  VARCHAR2 (30),
   HOME_ADDR_L1               VARCHAR2 (60),
   HOME_ADDR_L2               VARCHAR2 (60),
   HOME_ADDR_L3               VARCHAR2 (60),
   HOME_ADDR_L4               VARCHAR2 (60),
   HOME_POST_CODE             VARCHAR2 (8),
   GENDER                     VARCHAR2 (1),
   DOB                        DATE,
   STUDY_END_DATE             DATE,
   HOME_TEL_NO                VARCHAR2 (14),
   BIRTH_DISTRICT             VARCHAR2 (25),
   BIRTH_COUNTRY              VARCHAR2 (25),
   STUDENT_CONSENT            VARCHAR2 (1),
   BENEFACTOR1_CONSENT        VARCHAR2 (1),
   BENEFACTOR2_CONSENT        VARCHAR2 (1),
   REPEAT_YEAR                VARCHAR2 (1),
   NUMBER_OF_BENEFACTORS      NUMBER (1),
   NON_MEANS_TESTED           VARCHAR2 (1),
   NUMBER_OF_DEPENDANTS       NUMBER (1),
   HOUSEHOLD_RESID_INCOME     NUMBER (9, 2),
   BEN1_TOTAL_INCOME          NUMBER (9, 2),
   BEN2_TOTAL_INCOME          NUMBER (9, 2),
   TOTAL_FEE_LOAN_AVAILABLE   NUMBER (8, 2),
   BURSARY_ENTITLEMENT        NUMBER (8, 2),
   STUD_SORT_CODE             VARCHAR2 (6),
   STUD_ACC_NUMBER            VARCHAR2 (8),
   NINO                       VARCHAR2 (9),
   NINO_ACTION                VARCHAR2 (1),
   TERM_ADDR_L1               VARCHAR2 (60),
   TERM_ADDR_L2               VARCHAR2 (60),
   TERM_ADDR_L3               VARCHAR2 (60),
   TERM_ADDR_L4               VARCHAR2 (60),
   TERM_POST_CODE             VARCHAR2 (8),
   EMAIL_ADDRESS              VARCHAR2 (80),
   MOBILE_PHONE_NO            VARCHAR2 (20),
   CORRES_IND                 VARCHAR2 (1),
   LCT1_NAME                  VARCHAR2 (60),
   LCT1_RELATIONSHIP          VARCHAR2 (1),
   LCT1_ADDR_L1               VARCHAR2 (60),
   LCT1_ADDR_L2               VARCHAR2 (60),
   LCT1_ADDR_L3               VARCHAR2 (60),
   LCT1_ADDR_L4               VARCHAR2 (60),
   LCT1_POSTCODE              VARCHAR2 (8),
   LCT1_PHONE                 VARCHAR2 (14),
   LCT2_NAME                  VARCHAR2 (60),
   LCT2_ADDR_L1               VARCHAR2 (60),
   LCT2_ADDR_L2               VARCHAR2 (60),
   LCT2_ADDR_L3               VARCHAR2 (60),
   LCT2_ADDR_L4               VARCHAR2 (60),
   LCT2_POSTCODE              VARCHAR2 (8),
   LCT2_PHONE                 VARCHAR2 (14),
   LCL_IND                    VARCHAR2 (1),
   RUK_TFL_IND                VARCHAR2 (1),
   PSAS_TFL_IND               VARCHAR2 (1),
   HEBSS_IND                  VARCHAR2 (1),
   ARREARS_STATUS_REQ         VARCHAR2 (1)
)
TABLESPACE USERS
PCTUSED 0
PCTFREE 10
INITRANS 1
MAXTRANS 255
STORAGE (INITIAL 64 K
         MINEXTENTS 1
         MAXEXTENTS UNLIMITED
         PCTINCREASE 0
         BUFFER_POOL DEFAULT)
LOGGING
NOCOMPRESS
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE SGAS.SLC_CR_DATA IS
	'Record the details of individual records included in the SLC Customer Record batch file which are sent from the StEPS database';

CREATE UNIQUE INDEX SGAS.SLC_CR_DATA_PK
   ON SGAS.SLC_CR_DATA (SLC_FILENAME, SLC_FILE_DATE, STUD_CRSE_YEAR_ID)
   LOGGING
   TABLESPACE USERS
   PCTFREE 10
   INITRANS 2
   MAXTRANS 255
   STORAGE (INITIAL 64 K
            MINEXTENTS 1
            MAXEXTENTS UNLIMITED
            PCTINCREASE 0
            BUFFER_POOL DEFAULT)
   NOPARALLEL;


DROP PUBLIC SYNONYM SLC_CR_DATA;

CREATE PUBLIC SYNONYM SLC_CR_DATA FOR SGAS.SLC_CR_DATA;

ALTER TABLE SGAS.SLC_CR_DATA ADD (
  CONSTRAINT SLC_CR_DATA_PK
 PRIMARY KEY
 (SLC_FILENAME, SLC_FILE_DATE, STUD_CRSE_YEAR_ID)
    USING INDEX SGAS.SLC_CR_DATA_PK
  ENABLE VALIDATE);

ALTER TABLE SGAS.SLC_CR_DATA ADD (
  CONSTRAINT F1_SLCRD
 FOREIGN KEY (SLC_FILENAME,SLC_FILE_DATE)
 REFERENCES SGAS.SLC_CR_BATCHES (SLC_FILENAME,SLC_FILE_DATE));

ALTER TABLE SGAS.SLC_CR_DATA ADD (
  CONSTRAINT F2_SLCRD
 FOREIGN KEY (STUD_CRSE_YEAR_ID)
 REFERENCES SGAS.STUD_CRSE_YEAR (STUD_CRSE_YEAR_ID));
