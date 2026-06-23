-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- Modification History
-- Date        Author           Ref    Desc
-- 15.02.08    Steve Durkin     001    Initial Version
-- 10.03.09    A.Bowman (SAAS)  002    Added new columns
-- 22.03.09    A.Bowman (SAAS)  003    Added audit triggers
-- 28.01.10    A.Bowman (SAAS)  004    Amended audit triggers
-- 05.05.10    A.Bowman (SAAS)  005    Added foreign key reference
-- 26.08.10    A.Bowman (SAAS)  006    Added default value of 0 to all monetary columns
-- 01.09.10    A.Bowman (SAAS)  007    Removed redundant columns
-- 16.11.12    A.Bowman (SAAS)  008    Added new columns wtc_cb and reason_no_income
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/BENEFACTOR_INCOME.sql $
-- $Author: $
-- $Date: 2012-11-16 10:43:25 +0000 (Fri, 16 Nov 2012) $
-- $Revision: 8335 $


ALTER TABLE SGAS.BENEFACTOR_INCOME
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.BENEFACTOR_INCOME CASCADE CONSTRAINTS
/

--
-- BENEFACTOR_INCOME  (Table) 
--
CREATE TABLE SGAS.BENEFACTOR_INCOME
(
  BEN_ID                        NUMBER(9) CONSTRAINT NN_BEI_BEN_ID NOT NULL,
  SESSION_CODE                  NUMBER(4) CONSTRAINT NN_BEI_SESSION_CODE NOT NULL,
  INCOME_TYPE                   VARCHAR2(1 BYTE) DEFAULT 'C' CONSTRAINT NN_BEI_INCOME_TYPE NOT NULL,
  INCOME_STATUS                 VARCHAR2(1 BYTE) CONSTRAINT NN_BEI_INCOME_STATUS NOT NULL,
  RETIRED                       VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_BEI_RETIRED NOT NULL,
  UNEMPLOYED                    VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_BEI_UNEMPLOYED NOT NULL,
  BANK_INTEREST                 NUMBER(9,2)     DEFAULT 0 CONSTRAINT NN_BEI_BANK_INTEREST NOT NULL,
  BENEFIT                       NUMBER(9,2)     DEFAULT 0 CONSTRAINT NN_BEI_BENEFIT NOT NULL,
  OTHER_INCOME                  NUMBER(9,2)     DEFAULT 0 CONSTRAINT NN_BEI_OTHER_INCOME NOT NULL,
  NAT_SAVING_INTEREST           NUMBER(9,2)     DEFAULT 0 CONSTRAINT NN_BEI_NAT_SAVING_INTEREST NOT NULL,
  PAYE_INCOME                   NUMBER(9,2)     DEFAULT 0 CONSTRAINT NN_BEI_PAYE_INCOME NOT NULL,
  PENSION                       NUMBER(9,2)     DEFAULT 0 CONSTRAINT NN_BEI_PENSION NOT NULL,
  SELF_EMPLOYMENT               NUMBER(9,2)     DEFAULT 0 CONSTRAINT NN_BEI_SELF_EMPLOYMENT NOT NULL,
  PROPERTY                      NUMBER(9,2)     DEFAULT 0 CONSTRAINT NN_BEI_PROPERTY NOT NULL,
  DIVIDEND                      NUMBER(9,2)     DEFAULT 0 CONSTRAINT NN_BEI_DIVIDEND NOT NULL,
  DOMESTIC                      NUMBER(9,2)     DEFAULT 0 CONSTRAINT NN_BEI_DOMESTIC NOT NULL,
  OTHER_DEDUCT                  NUMBER(9,2)     DEFAULT 0 CONSTRAINT NN_BEI_OTHER_DEDUCT NOT NULL,
  P60_REQ                       VARCHAR2(1 BYTE) DEFAULT 'Y' CONSTRAINT NN_BEI_P60_REQ NOT NULL,
  SCHED_A_REQ                   VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_BEI_SCHED_A_REQ NOT NULL,
  SCHED_D_REQ                   VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_BEI_SCHED_D_REQ NOT NULL,
  SUPPRESS_REMINDER             VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_BEI_SUPPRESS_REMINDER NOT NULL,
  REMINDER_SENT                 NUMBER(1),
  REMINDER_DATE                 DATE,
  PENSION_CB                    VARCHAR2(1 BYTE),
  BENEFIT_CB                    VARCHAR2(1 BYTE),
  OTH_DEDUCTS_CB                VARCHAR2(1 BYTE),
  CHILD_DEDUCT                  NUMBER(9,2)     DEFAULT 0,
  ADULT_DEDUCT                  NUMBER(9,2)     DEFAULT 0,
  QA_RECEIVED                   VARCHAR2(1 BYTE),
  BEN_HEI_BURSARY_CONSENT       VARCHAR2(1 BYTE),
  WORKING_TAX_CREDIT            NUMBER(9,2)     DEFAULT 0,
  EMPLOYMENT_SUPPORT_ALLOWANCE  VARCHAR2(1 BYTE),
  INCAPACITY_BENEFIT            VARCHAR2(1 BYTE),
  INCOME_SUPPORT                VARCHAR2(1 BYTE),
  INVALIDITY_BENEFIT            VARCHAR2(1 BYTE),
  JOBSEEKERS_ALLOWANCE          VARCHAR2(1 BYTE),
  MAINTENANCE_PAYMENT           VARCHAR2(1 BYTE),
--- 008
  WTC_CB                        VARCHAR2(1 BYTE),
  REASON_NO_INCOME              VARCHAR2(60 BYTE), 
  LAST_UPDATED_BY               VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_BEI_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON               DATE            DEFAULT Sysdate CONSTRAINT NN_BEI_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
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

COMMENT ON COLUMN SGAS.BENEFACTOR_INCOME.BEN_HEI_BURSARY_CONSENT IS 'Indicates that the benefactor has given permission to share HEI Bursary details'
/


--
-- P_BEI  (Index) 
--
CREATE UNIQUE INDEX P_BEI ON SGAS.BENEFACTOR_INCOME
(BEN_ID, SESSION_CODE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

CREATE OR REPLACE TRIGGER SGAS.bei_iud
   AFTER INSERT OR DELETE OR UPDATE OF income_type,
                                       income_status,
                                       bank_interest,
                                       benefit,
                                       other_income,
                                       nat_saving_interest,
                                       paye_income,
                                       pension,
                                       self_employment,
                                       property,
                                       dividend,
                                       qa_received,
                                       suppress_reminder,
                                       ben_hei_bursary_consent,
                                       working_tax_credit,
                                       employment_support_allowance,
                                       incapacity_benefit,
                                       income_support,
                                       invalidity_benefit,
                                       jobseekers_allowance,
                                       maintenance_payment,
                                       last_updated_by
   ON SGAS.BENEFACTOR_INCOME    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                      := SYSDATE;
   p_column_name    benefactor_income_aud.column_name%TYPE    := NULL;
   p_table_pkey1    benefactor_income_aud.table_pkey1%TYPE
                                                     := TO_CHAR (:OLD.ben_id);
   p_table_pkey2    benefactor_income_aud.table_pkey2%TYPE
                                               := TO_CHAR (:OLD.session_code);
   p_table_pkey3    benefactor_income_aud.table_pkey3%TYPE
                                                          := :OLD.income_type;
   p_table_pkey4    benefactor_income_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    benefactor_income_aud.table_pkey5%TYPE    := NULL;
   p_old            benefactor_income_aud.OLD%TYPE            := NULL;
   p_new            benefactor_income_aud.NEW%TYPE            := NULL;
   p_action         benefactor_income_aud.action%TYPE         := NULL;
   p_username       benefactor_income_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    benefactor_income_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      benefactor_income_aud.inst_code%TYPE      := NULL;
   p_session_code   benefactor_income_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.ben_id;
      p_table_pkey2 := :NEW.session_code;
      p_table_pkey3 := :NEW.income_type;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.ben_id;
      p_table_pkey2 := :OLD.session_code;
      p_table_pkey3 := :OLD.income_type;
      p_username    := :OLD.last_updated_by;
   END IF;

   p_column_name := 'INCOME_TYPE';
   p_old := :OLD.income_type;
   p_new := :NEW.income_type;
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'INCOME_STATUS';
   p_old := :OLD.income_status;
   p_new := :NEW.income_status;
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'BANK_INTEREST';
   p_old := TO_CHAR (:OLD.bank_interest);
   p_new := TO_CHAR (:NEW.bank_interest);
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'BENEFIT';
   p_old := TO_CHAR (:OLD.benefit);
   p_new := TO_CHAR (:NEW.benefit);
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'OTHER_INCOME';
   p_old := TO_CHAR (:OLD.other_income);
   p_new := TO_CHAR (:NEW.other_income);
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'NAT_SAVING_INTEREST';
   p_old := TO_CHAR (:OLD.nat_saving_interest);
   p_new := TO_CHAR (:NEW.nat_saving_interest);
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'PAYE_INCOME';
   p_old := TO_CHAR (:OLD.paye_income);
   p_new := TO_CHAR (:NEW.paye_income);
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'PENSION';
   p_old := TO_CHAR (:OLD.pension);
   p_new := TO_CHAR (:NEW.pension);
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'SELF_EMPLOYMENT';
   p_old := TO_CHAR (:OLD.self_employment);
   p_new := TO_CHAR (:NEW.self_employment);
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'PROPERTY';
   p_old := TO_CHAR (:OLD.property);
   p_new := TO_CHAR (:NEW.property);
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'DIVIDEND';
   p_old := TO_CHAR (:OLD.dividend);
   p_new := TO_CHAR (:NEW.dividend);
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'QA_RECEIVED';
   p_old := TO_CHAR (:OLD.qa_received);
   p_new := TO_CHAR (:NEW.qa_received);
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'SUPPRESS_REMINDER';
   p_old := TO_CHAR (:OLD.suppress_reminder);
   p_new := TO_CHAR (:NEW.suppress_reminder);
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'BEN_HEI_BURSARY_CONSENT';
   p_old := TO_CHAR (:OLD.ben_hei_bursary_consent);
   p_new := TO_CHAR (:NEW.ben_hei_bursary_consent);
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'WORKING_TAX_CREDIT';
   p_old := :OLD.working_tax_credit;
   p_new := :NEW.working_tax_credit;
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'EMPLOYMENT_SUPPORT_ALLOWANCE';
   p_old := :OLD.employment_support_allowance;
   p_new := :NEW.employment_support_allowance;
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'INCAPACITY_BENEFIT';
   p_old := :OLD.incapacity_benefit;
   p_new := :NEW.incapacity_benefit;
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'INCOME_SUPPORT';
   p_old := :OLD.income_support;
   p_new := :NEW.income_support;
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'IVALIDITY_BENEFIT';
   p_old := :OLD.invalidity_benefit;
   p_new := :NEW.invalidity_benefit;
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'JOBSEEKERS_ALLOWANCE';
   p_old := :OLD.jobseekers_allowance;
   p_new := :NEW.jobseekers_allowance;
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'MAINTENANCE_PAYMENT';
   p_old := :OLD.maintenance_payment;
   p_new := :NEW.maintenance_payment;
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_bei_aud (p_aud_date,
                             p_column_name,
                             p_table_pkey1,
                             p_table_pkey2,
                             p_table_pkey3,
                             p_table_pkey4,
                             p_table_pkey5,
                             p_old,
                             p_new,
                             p_action,
                             p_username,
                             p_stud_ref_no,
                             p_inst_code,
                             p_session_code
                            );
END bei_iud;
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table BENEFACTOR_INCOME 
-- 
ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT BEI_QA_RECEIVED
 CHECK (qa_received in('Y','N')))
/

ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT BEI_INCOME_STATUS
 CHECK (income_status in('P','F','Q')))
/

ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT BEI_SCHED_A_REQ
 CHECK ( SCHED_A_REQ IN('Y','N')))
/

ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT BEI_SCHED_D_REQ
 CHECK ( SCHED_D_REQ IN('Y','N')))
/

ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT BEI_RETIRED
 CHECK ( RETIRED IN('Y','N')))
/

ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT BEI_BENEFIT_CB
 CHECK (benefit_cb in ('Y','N')))
/

ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT BEI_OTH_DEDUCTS_CB
 CHECK (oth_deducts_cb in ('Y','N')))
/

ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT BEI_INCOME_TYPE
 CHECK ( INCOME_TYPE IN('P','C')))
/

ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT BEI_P60_REQ
 CHECK ( P60_REQ IN('Y','N')))
/

ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT BEI_PENSION_CB
 CHECK (pension_cb in ('Y','N')))
/

ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT BEI_UNEMPLOYED
 CHECK ( UNEMPLOYED IN('Y','N')))
/

ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT BEI_SUPPRESS_REMINDER
 CHECK ( SUPPRESS_REMINDER IN('Y','N')))
/

ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT NN_BEI_WTC_CB
 CHECK ( WTC_CB IN('Y', 'N', NULL)))
/

ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT P_BEI
 PRIMARY KEY
 (BEN_ID, SESSION_CODE)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100K
                NEXT             100K
                MINEXTENTS       1
                MAXEXTENTS       99
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ))
/

ALTER TABLE SGAS.BENEFACTOR_INCOME ADD (
  CONSTRAINT F1_BEI 
 FOREIGN KEY (BEN_ID) 
 REFERENCES SGAS.BENEFACTOR (BEN_ID));
