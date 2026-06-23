-- DSA_APPLICATION.sql
-- Description: Table holding all DSA APPLICATION data for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      24.09.09    R Hunter (SAAS)         Initial Version.
-- 1.1      28.01.10    A.Bowman (SAAS)         Amended audit triggers
-- 1.2      05.05.10    A.Bowman (SAAS)         Added foreign key references
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $


DROP TABLE sgas.DSA_APPLICATION CASCADE CONSTRAINTS PURGE
/

--
-- DSA_APPLICATION  (Table) 
--
CREATE TABLE sgas.DSA_APPLICATION
(
  ID                           NUMBER(10) NOT NULL,
  STUD_REF_NO                  NUMBER(10),
  SESSION_CODE                 NUMBER(4),
  INST_CODE                    VARCHAR2(4 BYTE),
  DISABILITY_TYPE_ID           NUMBER(10),
  DATE_APPLICATION_RECEIVED    DATE,
  PRIORITY_APP                 VARCHAR2(1 BYTE) DEFAULT 'N',
  DSA_STUDENT_TYPE_ID          NUMBER(10),
  REFERRED_FLAG                VARCHAR2(1 BYTE) DEFAULT 'N',
  DATE_REFERRED_ACCESS_CENTRE  DATE,
  DSA_REFERRAL_REASON_ID       NUMBER(10),
  ASSESSMENT_CENTRE_ID         NUMBER(10),
  NEEDS_ASSESSOR                     VARCHAR2(200),
  ASSESSOR_HOURLY_RATE            NUMBER(15,2),
  PART_TIME_COURSE             NUMBER(2),
  more_info_req VARCHAR2(1 BYTE) DEFAULT 'N',
  exceptional_case VARCHAR2(1 BYTE) DEFAULT 'N',
  DATE_ASSESS_REP_RECEIVED     DATE,
  DATE_ASSESS_REP_PROCESSED    DATE,
  PROCESSING_DAYS              NUMBER(10),
  ASSESS_FEE_AMOUNT            NUMBER(15,2),
  REJECTED                     VARCHAR2(1 BYTE) DEFAULT 'N',
  DSA_REJECTION_REASON_ID      NUMBER(10),
  CONSENT_TICKED               VARCHAR2(1 BYTE) DEFAULT 'N',
  NON_MED_AMOUNT               NUMBER(15,2),
  LARGE_ITEMS_AMOUNT           NUMBER(15,2),
  BASIC_ALLOWANCE_AMOUNT       NUMBER(15,2),
  TRAVEL_AMOUNT                NUMBER(15,2),
  OTHER_INFORMATION            VARCHAR2(100 BYTE),
  HOURS_TO_COMPLETE_ASSESS     NUMBER(10),
  LAST_UPDATED_BY              VARCHAR2(15 BYTE)          DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON              DATE                       DEFAULT SYSDATE               NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

CREATE UNIQUE INDEX dsa_application_pk ON sgas.dsa_application
(id)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE OR REPLACE TRIGGER SGAS.DSA_APP_iud
   AFTER INSERT OR DELETE OR UPDATE OF ID,
                                       STUD_REF_NO,                  
                                       SESSION_CODE,                 
                                       INST_CODE,                    
                                       DISABILITY_TYPE_ID,           
                                       DATE_APPLICATION_RECEIVED,    
                                       PRIORITY_APP,                 
                                       DSA_STUDENT_TYPE_ID,          
                                       REFERRED_FLAG,                
                                       DATE_REFERRED_ACCESS_CENTRE,  
                                       DSA_REFERRAL_REASON_ID,       
                                       ASSESSMENT_CENTRE_ID,         
                                       NEEDS_ASSESSOR,                     
                                       ASSESSOR_HOURLY_RATE,            
                                       PART_TIME_COURSE, 
                                       more_info_req, 
                                       exceptional_case, 
                                       DATE_ASSESS_REP_RECEIVED,     
                                       DATE_ASSESS_REP_PROCESSED,    
                                       PROCESSING_DAYS,              
                                       ASSESS_FEE_AMOUNT,            
                                       REJECTED,                     
                                       DSA_REJECTION_REASON_ID,      
                                       CONSENT_TICKED,               
                                       NON_MED_AMOUNT,               
                                       LARGE_ITEMS_AMOUNT,           
                                       BASIC_ALLOWANCE_AMOUNT,       
                                       TRAVEL_AMOUNT,                
                                       OTHER_INFORMATION,            
                                       HOURS_TO_COMPLETE_ASSESS,
                                       LAST_UPDATED_BY
ON SGAS.DSA_APPLICATION FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DSA_APPLICATION_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_APPLICATION_aud.table_pkey1%TYPE
                                               := :OLD.ID;
   p_table_pkey2    DSA_APPLICATION_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_APPLICATION_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_APPLICATION_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_APPLICATION_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_APPLICATION_aud.OLD%TYPE            := NULL;
   p_new            DSA_APPLICATION_aud.NEW%TYPE            := NULL;
   p_action         DSA_APPLICATION_aud.action%TYPE         := NULL;
   p_username       DSA_APPLICATION_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_APPLICATION_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_APPLICATION_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_APPLICATION_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'ID';
   p_old := :OLD.id;
   p_new := :NEW.id;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'STUD_REF_NO';
   p_old := :OLD.STUD_REF_NO;
   p_new := :NEW.STUD_REF_NO;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'SESSION_CODE';
   p_old := :OLD.SESSION_CODE;
   p_new := :NEW.SESSION_CODE;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'INST_CODE';
   p_old := :OLD.INST_CODE;
   p_new := :NEW.INST_CODE;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DISABILITY_TYPE_ID';
   p_old := :OLD.DISABILITY_TYPE_ID;
   p_new := :NEW.DISABILITY_TYPE_ID;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DATE_APPLICATION_RECEIVED';
   p_old := :OLD.DATE_APPLICATION_RECEIVED;
   p_new := :NEW.DATE_APPLICATION_RECEIVED;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'PRIORITY_APP';
   p_old := :OLD.PRIORITY_APP;
   p_new := :NEW.PRIORITY_APP;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DSA_STUDENT_TYPE_ID';
   p_old := :OLD.DSA_STUDENT_TYPE_ID;
   p_new := :NEW.DSA_STUDENT_TYPE_ID;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'REFERRED_FLAG';
   p_old := :OLD.REFERRED_FLAG;
   p_new := :NEW.REFERRED_FLAG;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DATE_REFERRED_ACCESS_CENTRE';
   p_old := :OLD.DATE_REFERRED_ACCESS_CENTRE;
   p_new := :NEW.DATE_REFERRED_ACCESS_CENTRE;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DSA_REFERRAL_REASON_ID';
   p_old := :OLD.DSA_REFERRAL_REASON_ID;
   p_new := :NEW.DSA_REFERRAL_REASON_ID;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'ASSESSMENT_CENTRE_ID';
   p_old := :OLD.ASSESSMENT_CENTRE_ID;
   p_new := :NEW.ASSESSMENT_CENTRE_ID;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'NEEDS_ASSESSOR';
   p_old := :OLD.NEEDS_ASSESSOR;
   p_new := :NEW.NEEDS_ASSESSOR;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'ASSESSOR_HOURLY_RATE';
   p_old := :OLD.ASSESSOR_HOURLY_RATE;
   p_new := :NEW.ASSESSOR_HOURLY_RATE;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'PART_TIME_COURSE';
   p_old := :OLD.PART_TIME_COURSE;
   p_new := :NEW.PART_TIME_COURSE;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'more_info_req';
   p_old := :OLD.more_info_req;
   p_new := :NEW.more_info_req;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'exceptional_case';
   p_old := :OLD.exceptional_case;
   p_new := :NEW.exceptional_case;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DATE_ASSESS_REP_RECEIVED';
   p_old := :OLD.DATE_ASSESS_REP_RECEIVED;
   p_new := :NEW.DATE_ASSESS_REP_RECEIVED;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DATE_ASSESS_REP_PROCESSED';
   p_old := :OLD.DATE_ASSESS_REP_PROCESSED;
   p_new := :NEW.DATE_ASSESS_REP_PROCESSED;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'PROCESSING_DAYS';
   p_old := :OLD.PROCESSING_DAYS;
   p_new := :NEW.PROCESSING_DAYS;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'ASSESS_FEE_AMOUNT';
   p_old := :OLD.ASSESS_FEE_AMOUNT;
   p_new := :NEW.ASSESS_FEE_AMOUNT;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'REJECTED';
   p_old := :OLD.REJECTED;
   p_new := :NEW.REJECTED;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DSA_REJECTION_REASON_ID';
   p_old := :OLD.DSA_REJECTION_REASON_ID;
   p_new := :NEW.DSA_REJECTION_REASON_ID;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'CONSENT_TICKED';
   p_old := :OLD.CONSENT_TICKED;
   p_new := :NEW.CONSENT_TICKED;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'NON_MED_AMOUNT';
   p_old := :OLD.NON_MED_AMOUNT;
   p_new := :NEW.NON_MED_AMOUNT;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'LARGE_ITEMS_AMOUNT';
   p_old := :OLD.LARGE_ITEMS_AMOUNT;
   p_new := :NEW.LARGE_ITEMS_AMOUNT;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'BASIC_ALLOWANCE_AMOUNT';
   p_old := :OLD.BASIC_ALLOWANCE_AMOUNT;
   p_new := :NEW.BASIC_ALLOWANCE_AMOUNT;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'TRAVEL_AMOUNT';
   p_old := :OLD.TRAVEL_AMOUNT;
   p_new := :NEW.TRAVEL_AMOUNT;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'OTHER_INFORMATION';
   p_old := :OLD.OTHER_INFORMATION;
   p_new := :NEW.OTHER_INFORMATION;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'HOURS_TO_COMPLETE_ASSESS';
   p_old := :OLD.HOURS_TO_COMPLETE_ASSESS;
   p_new := :NEW.HOURS_TO_COMPLETE_ASSESS;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_old := :OLD.LAST_UPDATED_BY;
   p_new := :NEW.LAST_UPDATED_BY;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
END DSA_APP_IUD;
SHOW ERRORS;


ALTER TABLE sgas.dsa_application ADD (
  CONSTRAINT dsa_application_pk
 PRIMARY KEY
 (id)
    USING INDEX
    TABLESPACE users
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64 k
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));

ALTER TABLE SGAS.DSA_APPLICATION ADD (
  CONSTRAINT F1_DSAP 
 FOREIGN KEY (STUD_REF_NO) 
 REFERENCES SGAS.STUD (STUD_REF_NO));

ALTER TABLE SGAS.DSA_APPLICATION ADD (
  CONSTRAINT F2_DSAP 
 FOREIGN KEY (DISABILITY_TYPE_ID) 
 REFERENCES SGAS.DISABILITY_TYPE (DISABILITY_TYPE_ID));

ALTER TABLE SGAS.DSA_APPLICATION ADD (
  CONSTRAINT F3_DSAP 
 FOREIGN KEY (DSA_STUDENT_TYPE_ID) 
 REFERENCES SGAS.DSA_STUDENT_TYPE (DSA_STUDENT_TYPE_ID));

ALTER TABLE SGAS.DSA_APPLICATION ADD (
  CONSTRAINT F4_DSAP 
 FOREIGN KEY (DSA_REFERRAL_REASON_ID) 
 REFERENCES SGAS.DSA_REFERRAL_REASON (DSA_REFERRAL_REASON_ID));

ALTER TABLE SGAS.DSA_APPLICATION ADD (
  CONSTRAINT F5_DSAP 
 FOREIGN KEY (ASSESSMENT_CENTRE_ID) 
 REFERENCES SGAS.DSA_ASSESSMENT_CENTRE (DSA_ASSESSMENT_CENTRE_ID));

ALTER TABLE SGAS.DSA_APPLICATION ADD (
  CONSTRAINT F6_DSAP 
 FOREIGN KEY (DSA_REJECTION_REASON_ID) 
 REFERENCES SGAS.DSA_REJECTION_REASON (DSA_REJECTION_REASON_ID));


-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM dsa_application
/
CREATE PUBLIC SYNONYM dsa_application FOR sgas.dsa_application
/
DROP SEQUENCE sgas.dsa_application_id_seq
/
--
-- DSA_APPLICATION_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.dsa_application_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_dsa_application_id_seq
   BEFORE INSERT
   ON sgas.dsa_application
   FOR EACH ROW
BEGIN
   SELECT dsa_application_id_seq.NEXTVAL
     INTO :NEW.id
     FROM DUAL;
END; 
                                                                       

COMMIT;

