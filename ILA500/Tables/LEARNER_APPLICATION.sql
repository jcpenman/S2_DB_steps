-- TABLE: LEARNER_APPLICATION
-- Description: Table holding learner application data
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                  Desc.
-- 1.0      05.06.08   A.Bowman (SAAS)         Initial Version.
-- 1.1      06.06.08   A.Bowman (SAAS)         Added comments iro the table columns
-- 1.2      17.06.08   A.Bowman (SAAS)         Added column application_rejection_id
-- 1.3      23.06.08   A.Bowman (SAAS)         Amended learner_application_id data type
-- 1.4      25.06.08   A.Bowman (SAAS)         Added column endorsed_by (originally not in spec)
-- 1.5      26.06.08   A.Bowman (sAAS)         Added column course_type_id
-- 1.6      28.07.08   A.Bowman (SAAS)         Amended column session_year to mandatory in line with f.spec 	
-- 1.7      14.08.08   R.Hunter (SAAS)         Set default value of RECOVER_FEES to 'N'
-- 1.8      21.08.08   A.Bowman (SAAS)         Amended help_amount and amount_paid data type to number(15,2) 
-- 1.9      28.08.08   R.Hunter (SAAS)         Renamed 3 fee amount columns to be more meaningful
-- 2.0      12.11.08   A.Bowman (SAAS)         Dropped course_id, course_type_id, provider_id and session_year not null constraint
--                                             and added new LEARNER_APPLICATION_C01 constraint
-- 2.1      29.01.09   A.Bowman (SAAS)         Added column last_letter_generated (originally not in spec)
-- 2.2      09.03.09   A.Bowman (SAAS)         Amended LEARNER_APPLICATION_C01 constraint
-- 2.3      19.10.09   A.Bowman (SAAS)         Amended LEARNER_APPLICATION_C01 constraint to fix missing right parenthisis issue 
-- 2.4      19.10.09   A.Bowman (SAAS)         Added triggers and sequence
-- 2.5      15.02.10   A.Bowman (SAAS)         Amended audit triggers
-- 2.6	     26.04.10 P Grace (SAAS)		Added default to zero for total annual income
-- 2.7      11.05.10   A.Bowman (SAAS)         Added in trigger LEA_APP_IUD which somehow had been removed from this script and DEV database ???
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER_APPLICATION.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
 
ALTER TABLE LEARNER_APPLICATION
 DROP PRIMARY KEY CASCADE
/
DROP TABLE LEARNER_APPLICATION CASCADE CONSTRAINTS PURGE
/

--
-- LEARNER_APPLICATION (Table) 
--

CREATE TABLE LEARNER_APPLICATION
(
  LEARNER_APPLICATION_ID        NUMBER(10) NOT NULL,
  LEARNER_ID                    VARCHAR2(10 BYTE) NOT NULL,
  COURSE_ID                     NUMBER(10),
  COURSE_TYPE_ID                NUMBER(10),
  PROVIDER_ID                   NUMBER(10),
  APPLICATION_STATUS_ID         NUMBER(10) NOT NULL,
  REJECTION_ID                  NUMBER(10),
  TOTAL_ANNUAL_INCOME           NUMBER(9) DEFAULT 0,
  TOT_ANN_INC_EVID_ID           VARCHAR2(1 BYTE),
  NO_INCOME                     VARCHAR2(1 BYTE),
  NO_INCOME_EVID_ID             VARCHAR2(1 BYTE),
  JOB_SEEKERS_ALLOWANCE         VARCHAR2(1 BYTE),
  JSA_EVID_ID                   VARCHAR2(1 BYTE),
  INCOME_SUPPORT                VARCHAR2(1 BYTE),
  INC_SUP_EVID_ID               VARCHAR2(1 BYTE),
  INCAPACITY_BENEFIT            VARCHAR2(1 BYTE),
  INC_BEN_EVID_ID               VARCHAR2(1 BYTE),
  CARERS_ALLOWANCE              VARCHAR2(1 BYTE),
  CARERS_ALLOWANCE_EVID_ID      VARCHAR2(1 BYTE),
  PENSION_CREDIT                VARCHAR2(1 BYTE),
  PENSION_CREDIT_EVID_ID        VARCHAR2(1 BYTE),
  MAX_CHILD_TAX_CREDIT          VARCHAR2(1 BYTE),
  MAX_CHILD_TAX_CREDIT_EVID_ID  VARCHAR2(1 BYTE),
  SESSION_YEAR                  VARCHAR2(4 BYTE),
  DATE_APP_RECD                 DATE,
  DATE_RECORD_CREATED           DATE DEFAULT SYSDATE,
  DATE_OF_LAST_CALC             DATE,
  COURSE_TITLE                  VARCHAR2(50 BYTE),
  COURSE_START_DATE             DATE,
  LENGTH_OF_COURSE              NUMBER,
  CURRENT_COURSE_YEAR           NUMBER,
  COURSE_END_DATE               DATE,
  HELP_WITH_FEES                VARCHAR2(1 BYTE),
  HELP_AMOUNT                   NUMBER(15,2) DEFAULT 0,
  FEE_REQUESTED                 NUMBER(15,2) DEFAULT 0,
  PROVIDER_SIGNATURE_PRESENT    VARCHAR2(1 BYTE),
  ENDORSED_BY                   VARCHAR2(40 BYTE),
  DATE_ENDORSED                 DATE,
  STAMPED                       VARCHAR2(1 BYTE),
  LEARNER_SIGNATURE_PRESENT     VARCHAR2(1 BYTE),
  DATE_SIGNED                   DATE,
  FEE_PAID_BACS                 NUMBER(15,2) DEFAULT 0,
  PAYMENT_DATE                  DATE,
  RECOVER_FEES                  VARCHAR2(1 BYTE) DEFAULT 'N',
  DEBT_STATUS                   VARCHAR2(20 BYTE),
  FEE_CALCULATED                NUMBER(15,2) DEFAULT 0,
  LAST_LETTER_GENERATED         DATE,
  COMMENTS_FOR_AWARD_LETTER     VARCHAR2(500 BYTE),
  AWARD_LETTER_DUPLICATE        VARCHAR2(1 BYTE),
  NON_ATTENDANCE                VARCHAR2(1 BYTE),
  DATE_WITHDRAWN                DATE,
  DATE_ACTIONED                 DATE,
  LAST_UPDATED_BY               VARCHAR2(15 BYTE) DEFAULT USER NOT NULL,
  LAST_UPDATED_ON               DATE            DEFAULT SYSDATE NOT NULL
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

COMMENT ON TABLE LEARNER_APPLICATION IS 'Table holding learner application data';

COMMENT ON COLUMN LEARNER_APPLICATION.LEARNER_APPLICATION_ID IS 'Unique identifier for each learner application';

COMMENT ON COLUMN LEARNER_APPLICATION.LEARNER_ID IS 'Unique identifier for each learner';

COMMENT ON COLUMN LEARNER_APPLICATION.COURSE_ID IS 'Unique identifier for each course';

COMMENT ON COLUMN LEARNER_APPLICATION.PROVIDER_ID IS 'Unique identifier for each provider';

COMMENT ON COLUMN LEARNER_APPLICATION.APPLICATION_STATUS_ID IS 'Unique identifier for each application status';

COMMENT ON COLUMN LEARNER_APPLICATION.REJECTION_ID IS 'Unique identifier for each application rejection reason';

COMMENT ON COLUMN LEARNER_APPLICATION.TOTAL_ANNUAL_INCOME IS 'Learners total annual income';

COMMENT ON COLUMN LEARNER_APPLICATION.TOT_ANN_INC_EVID_ID IS 'Evidence of total annual income received or requested indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.NO_INCOME IS 'Learner has no income indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.NO_INCOME_EVID_ID IS 'Evidence of no income received or requested indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.JOB_SEEKERS_ALLOWANCE IS 'Learner is receiving job seekers allowance indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.JSA_EVID_ID IS 'Evidence of job seekers allowance received or requested indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.INCOME_SUPPORT IS 'Learner is receiving income support indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.INC_SUP_EVID_ID IS 'Evidence of income support received or requested indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.INCAPACITY_BENEFIT IS 'Learner is receiving incapacity benefit indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.INC_BEN_EVID_ID IS 'Evidence of incapacity benefit received or requested indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.CARERS_ALLOWANCE IS 'Learner is receiving carers allowance';

COMMENT ON COLUMN LEARNER_APPLICATION.CARERS_ALLOWANCE_EVID_ID IS 'Evidence of carers allowance received or requested indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.PENSION_CREDIT IS 'Learner is receiving pension credit';

COMMENT ON COLUMN LEARNER_APPLICATION.PENSION_CREDIT_EVID_ID IS 'Evidence of pension credit received or requested indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.MAX_CHILD_TAX_CREDIT IS 'Learner is receiving maximum child tax credit';

COMMENT ON COLUMN LEARNER_APPLICATION.MAX_CHILD_TAX_CREDIT_EVID_ID IS 'Evidence of maximum child tax credit received or requested';

COMMENT ON COLUMN LEARNER_APPLICATION.SESSION_YEAR IS 'Application Session';

COMMENT ON COLUMN LEARNER_APPLICATION.DATE_APP_RECD IS 'Date application is received';

COMMENT ON COLUMN LEARNER_APPLICATION.DATE_RECORD_CREATED IS 'Date application record is created';

COMMENT ON COLUMN LEARNER_APPLICATION.DATE_OF_LAST_CALC IS 'Date of the last calculation completed iro of the application';

COMMENT ON COLUMN LEARNER_APPLICATION.COURSE_TITLE IS 'The Title of the course attended by the learner';

COMMENT ON COLUMN LEARNER_APPLICATION.COURSE_START_DATE IS 'The course start date';

COMMENT ON COLUMN LEARNER_APPLICATION.LENGTH_OF_COURSE IS 'The duration of the course';

COMMENT ON COLUMN LEARNER_APPLICATION.CURRENT_COURSE_YEAR IS 'The year of the course';

COMMENT ON COLUMN LEARNER_APPLICATION.COURSE_END_DATE IS 'The course end date';

COMMENT ON COLUMN LEARNER_APPLICATION.HELP_WITH_FEES IS 'Learner received help with fees indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.HELP_AMOUNT IS 'The amount of help the learner received';

COMMENT ON COLUMN LEARNER_APPLICATION.PROVIDER_SIGNATURE_PRESENT IS 'The learning providers signature present indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.DATE_ENDORSED IS 'The date the learning provider endorsed the application';

COMMENT ON COLUMN LEARNER_APPLICATION.STAMPED IS 'The application has been stamped by the provider indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.LEARNER_SIGNATURE_PRESENT IS 'The learners signature present indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.DATE_SIGNED IS 'The date the learner signed the application';

COMMENT ON COLUMN LEARNER_APPLICATION.PAYMENT_DATE IS 'Date of the payment';

COMMENT ON COLUMN LEARNER_APPLICATION.RECOVER_FEES IS 'Are fees to be recovered indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.DEBT_STATUS IS 'The debt status';

COMMENT ON COLUMN LEARNER_APPLICATION.LAST_LETTER_GENERATED IS 'The date of the last letter generated for a learner';

COMMENT ON COLUMN LEARNER_APPLICATION.COMMENTS_FOR_AWARD_LETTER IS 'Comments added by caseworker to the letter of award';

COMMENT ON COLUMN LEARNER_APPLICATION.AWARD_LETTER_DUPLICATE IS 'Duplicate letter of award to be generated in next run indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.NON_ATTENDANCE IS 'Course non attendance indicator';

COMMENT ON COLUMN LEARNER_APPLICATION.DATE_WITHDRAWN IS 'Date application is withdrawn';

COMMENT ON COLUMN LEARNER_APPLICATION.DATE_ACTIONED IS 'Date application actioned after withdrawal';

COMMENT ON COLUMN LEARNER_APPLICATION.LAST_UPDATED_BY IS 'The user to last update or insert a row on the learner_application table';

COMMENT ON COLUMN LEARNER_APPLICATION.LAST_UPDATED_ON IS 'The date of the latest update or insert on the learner_application table';



CREATE UNIQUE INDEX LEARNER_APPLICATION_PK ON LEARNER_APPLICATION
(LEARNER_APPLICATION_ID)
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


ALTER TABLE LEARNER_APPLICATION ADD (
  CONSTRAINT LEARNER_APPLICATION_PK
 PRIMARY KEY
 (LEARNER_APPLICATION_ID)
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
--- 2.3
ALTER TABLE LEARNER_APPLICATION ADD (
  CONSTRAINT LEARNER_APPLICATION_C01
 CHECK ((application_status_id <> 2)  OR  (application_status_id = 2 and course_id is not null and provider_id is not null and course_type_id is not null and session_year is not null)));

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM LEARNER_APPLICATION
/

CREATE PUBLIC SYNONYM LEARNER_APPLICATION FOR ILA500.LEARNER_APPLICATION
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON LEARNER_APPLICATION
TO EDM_USER
/

/* Formatted on 2008/10/20 15:43 (Formatter Plus v4.8.8) */
-- TRIGGER: LEA_IUD
-- TABLE: LEARNER
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
-- 002      28.08.2008    A.Bowman (SAAS)         Additional Columns added
-- 003      28.08.2008    A.Bowman (SAAS)         Yet another additional column added
-- 004      16.10.2008    A.Bowman (SAAS)         Added Telephony functionality
-- 005      04.06.2009    A.Bowman (SAAS)         Telephony functionality removed, no longer required, surprise surprise
-- 
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER_APPLICATION.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
--
CREATE OR REPLACE TRIGGER lea_app_iud
   AFTER DELETE OR INSERT OR UPDATE OF learner_application_id,
                                       learner_id,
                                       course_id,
                                       course_type_id,
                                       provider_id,
                                       application_status_id,
                                       rejection_id,
                                       total_annual_income,
                                       tot_ann_inc_evid_id,
                                       no_income,
                                       no_income_evid_id,
                                       job_seekers_allowance,
                                       jsa_evid_id,
                                       income_support,
                                       inc_sup_evid_id,
                                       incapacity_benefit,
                                       inc_ben_evid_id,
                                       carers_allowance,
                                       carers_allowance_evid_id,
                                       pension_credit,
                                       pension_credit_evid_id,
                                       max_child_tax_credit,
                                       max_child_tax_credit_evid_id,
                                       session_year,
                                       date_app_recd,
                                       date_record_created,
                                       date_of_last_calc,
                                       course_title,
                                       course_start_date,
                                       length_of_course,
                                       current_course_year,
                                       course_end_date,
                                       help_with_fees,
                                       help_amount,
                                       fee_requested,
                                       provider_signature_present,
                                       endorsed_by,
                                       date_endorsed,
                                       stamped,
                                       learner_signature_present,
                                       date_signed,
                                       fee_paid_bacs,
                                       payment_date,
                                       recover_fees,
                                       debt_status,
                                       fee_calculated,
                                       last_letter_generated,
                                       comments_for_award_letter,
                                       award_letter_duplicate,
                                       non_attendance,
                                       date_withdrawn,
                                       date_actioned,
                                       last_updated_by
   ON LEARNER_APPLICATION    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                       := SYSDATE;
   p_column_name   learner_application_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_application_aud.primary_key%TYPE
                                               := :OLD.learner_application_id;
   p_old           learner_application_aud.OLD%TYPE           := NULL;
   p_new           learner_application_aud.NEW%TYPE           := NULL;
   p_action        learner_application_aud.action%TYPE        := NULL;
   p_username      learner_application_aud.username%TYPE      := :NEW.last_updated_by;
   p_learner_id    learner.learner_id%TYPE                 := :OLD.learner_id;
   p_table_name    VARCHAR2 (32)                     := 'LEARNER_APPLICATION';
   v_updated       VARCHAR2 (1)                               := 'N';
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.learner_application_id;
      p_learner_id := :NEW.learner_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'LEARNER_APPLICATION_ID';
   p_old := :OLD.learner_application_id;
   p_new := :NEW.learner_application_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LEARNER_ID';
   p_old := :OLD.learner_id;
   p_new := :NEW.learner_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_ID';
   p_old := :OLD.course_id;
   p_new := :NEW.course_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_TYPE_ID';
   p_old := :OLD.course_type_id;
   p_new := :NEW.course_type_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PROVIDER_ID';
   p_old := :OLD.provider_id;
   p_new := :NEW.provider_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'APPLICATION_STATUS_ID';
   p_old := :OLD.application_status_id;
   p_new := :NEW.application_status_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'REJECTION_ID';
   p_old := :OLD.rejection_id;
   p_new := :NEW.rejection_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'TOTAL_ANNUAL_INCOME';
   p_old := :OLD.total_annual_income;
   p_new := :NEW.total_annual_income;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'TOT_ANN_INC_EVID_ID';
   p_old := :OLD.tot_ann_inc_evid_id;
   p_new := :NEW.tot_ann_inc_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NO_INCOME';
   p_old := :OLD.no_income;
   p_new := :NEW.no_income;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NO_INCOME_EVID_ID';
   p_old := :OLD.no_income_evid_id;
   p_new := :NEW.no_income_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'JOB_SEEKERS_ALLOWANCE';
   p_old := :OLD.job_seekers_allowance;
   p_new := :NEW.job_seekers_allowance;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'JSA_EVID_ID';
   p_old := :OLD.jsa_evid_id;
   p_new := :NEW.jsa_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'INCOME_SUPPORT';
   p_old := :OLD.income_support;
   p_new := :NEW.income_support;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'INC_SUP_EVID_ID';
   p_old := :OLD.inc_sup_evid_id;
   p_new := :NEW.inc_sup_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'INCAPACITY_BENEFIT';
   p_old := :OLD.incapacity_benefit;
   p_new := :NEW.incapacity_benefit;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'INC_BEN_EVID_ID';
   p_old := :OLD.inc_ben_evid_id;
   p_new := :NEW.inc_ben_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'CARERS_ALLOWANCE';
   p_old := :OLD.carers_allowance;
   p_new := :NEW.carers_allowance;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'CARERS_ALLOWANCE_EVID_ID';
   p_old := :OLD.carers_allowance_evid_id;
   p_new := :NEW.carers_allowance_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PENSION_CREDIT';
   p_old := :OLD.pension_credit;
   p_new := :NEW.pension_credit;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PENSION_CREDIT_EVID_ID';
   p_old := :OLD.pension_credit_evid_id;
   p_new := :NEW.pension_credit_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'MAX_CHILD_TAX_CREDIT';
   p_old := :OLD.max_child_tax_credit;
   p_new := :NEW.max_child_tax_credit;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'MAX_CHILD_TAX_CREDIT_EVID_ID';
   p_old := :OLD.max_child_tax_credit_evid_id;
   p_new := :NEW.max_child_tax_credit_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'SESSION_YEAR';
   p_old := :OLD.session_year;
   p_new := :NEW.session_year;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_APP_RECD';
   p_old := :OLD.date_app_recd;
   p_new := :NEW.date_app_recd;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_RECORD_CREATED';
   p_old := :OLD.date_record_created;
   p_new := :NEW.date_record_created;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_OF_LAST_CALC';
   p_old := :OLD.date_of_last_calc;
   p_new := :NEW.date_of_last_calc;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_TITLE';
   p_old := :OLD.course_title;
   p_new := :NEW.course_title;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_START_DATE';
   p_old := :OLD.course_start_date;
   p_new := :NEW.course_start_date;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LENGTH_OF_COURSE';
   p_old := :OLD.length_of_course;
   p_new := :NEW.length_of_course;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'CURRENT_COURSE_YEAR';
   p_old := :OLD.current_course_year;
   p_new := :NEW.current_course_year;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_END_DATE';
   p_old := :OLD.course_end_date;
   p_new := :NEW.course_end_date;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'HELP_WITH_FEES';
   p_old := :OLD.help_with_fees;
   p_new := :NEW.help_with_fees;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'HELP_AMOUNT';
   p_old := :OLD.help_amount;
   p_new := :NEW.help_amount;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'FEE_REQUESTED';
   p_old := :OLD.fee_requested;
   p_new := :NEW.fee_requested;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PROVIDER_SIGNATURE_PRESENT';
   p_old := :OLD.provider_signature_present;
   p_new := :NEW.provider_signature_present;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'ENDORSED_BY';
   p_old := :OLD.endorsed_by;
   p_new := :NEW.endorsed_by;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_ENDORSED';
   p_old := :OLD.date_endorsed;
   p_new := :NEW.date_endorsed;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'STAMPED';
   p_old := :OLD.stamped;
   p_new := :NEW.stamped;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LEARNER_SIGNATURE_PRESENT';
   p_old := :OLD.learner_signature_present;
   p_new := :NEW.learner_signature_present;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_SIGNED';
   p_old := :OLD.date_signed;
   p_new := :NEW.date_signed;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'FEE_PAID_BACS';
   p_old := :OLD.fee_paid_bacs;
   p_new := :NEW.fee_paid_bacs;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PAYMENT_DATE';
   p_old := :OLD.payment_date;
   p_new := :NEW.payment_date;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'RECOVER_FEES';
   p_old := :OLD.recover_fees;
   p_new := :NEW.recover_fees;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DEBT_STATUS';
   p_old := :OLD.debt_status;
   p_new := :NEW.debt_status;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'FEE_CALCULATED';
   p_old := :OLD.fee_calculated;
   p_new := :NEW.fee_calculated;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LAST_LETTER_GENERATED';
   p_old := :OLD.last_letter_generated;
   p_new := :NEW.last_letter_generated;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COMMENTS_FOR_AWARD_LETTER';
   p_old := :OLD.comments_for_award_letter;
   p_new := :NEW.comments_for_award_letter;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'AWARD_LETTER_DUPLICATE';
   p_old := :OLD.award_letter_duplicate;
   p_new := :NEW.award_letter_duplicate;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NON_ATTENDANCE';
   p_old := :OLD.non_attendance;
   p_new := :NEW.non_attendance;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_WITHDRAWN';
   p_old := :OLD.date_withdrawn;
   p_new := :NEW.date_withdrawn;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_ACTIONED';
   p_old := :OLD.date_actioned;
   p_new := :NEW.date_actioned;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END lea_app_iud;

SHOW ERRORS;

/* Formatted on 2008/10/21 14:45 (Formatter Plus v4.8.8) */
-- TRIGGER: LEA_APP_BEFORE_UD
-- TABLE: LEARNER_APPLICATION
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      21.10.2008    A.Bowman (SAAS)         Initial Version.
-- 002      28.10.2008    A.Bowman (SAAS)         Amended code to fix testing defect 232 
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER_APPLICATION.sql $ 
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ILA500.lea_app_before_ud
   BEFORE INSERT OR UPDATE OF FEE_CALCULATED
   ON ILA500.LEARNER_APPLICATION    FOR EACH ROW
BEGIN
   IF NVL (:OLD.FEE_CALCULATED,'0') <> NVL (:NEW.FEE_CALCULATED,'0')
   THEN
      :NEW.DATE_OF_LAST_CALC := SYSDATE;
   END IF;
END;
/
SHOW ERRORS;

/* Formatted on 2008/07/07 15:51 (Formatter Plus v4.8.8) */
-- TRIGGER: LEA_APP_LUB
-- TABLE: LEARNER_APPLICATION
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER_APPLICATION.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.lea_app_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.learner_application
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                       := SYSDATE;
   p_column_name   learner_application_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_application_aud.primary_key%TYPE
                                               := :OLD.learner_application_id;
   p_old           learner_application_aud.OLD%TYPE           := NULL;
   p_new           learner_application_aud.NEW%TYPE           := NULL;
   p_action        learner_application_aud.action%TYPE        := NULL;
   p_username      learner_application_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.learner_application_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END lea_app_lub;
/
SHOW ERRORS;*/

-- SEQUENCE SCRIPT FOR PK ON LEARNER_APPLICATION TABLE
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      03.07.08    R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/LEARNER_APPLICATION.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
DROP SEQUENCE LEARNER_APPLICATION_ID_seq
/

--
-- LEARNER_APPLICATION_ID_seq  (Sequence) 
--
CREATE SEQUENCE LEARNER_APPLICATION_ID_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


CREATE OR REPLACE TRIGGER trig_LEARNER_APPLICATION_seq BEFORE INSERT ON LEARNER_APPLICATION
FOR EACH ROW
BEGIN
SELECT LEARNER_APPLICATION_ID_seq.NEXTVAL, SYSDATE into :new.LEARNER_APPLICATION_ID, :new.DATE_RECORD_CREATED FROM dual;
END;