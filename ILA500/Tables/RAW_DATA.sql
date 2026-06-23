-- TABLE: RAW_DATA
-- Description: Table holdinG RAW_DATA a composite of LEARNER and LEARNER_APPLICATION data
--              
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      05.06.08    R.Hunter (SAAS)         Initial Version.
-- 2.0      21.08.08    A.Bowman (SAAS)         Amended help_amount data type to number(15,2)     
-- 3.0      22.08.08    R.Hunter (SAAS)         Added WEB_USER_ID column
-- 4.0      21.10.08    A.Bowman (SAAS)         Amended course_id data type to number(10) in line with course_id data type on course_level table.
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/RAW_DATA.sql $
-- $Author: $
-- $Date: 2010-10-21 09:56:31 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5795 $

DROP TABLE RAW_DATA CASCADE CONSTRAINTS PURGE
/

--
-- RAW_DATA  (Table) 
--
CREATE TABLE RAW_DATA
(

/*******
EDM DATA - MAY NOT BE REQUIRED NOW, BUT COULD BE IN FUTURE 
*******/
  OBJECT_ID                      VARCHAR2(44 BYTE),
  RAW_DATA_ID                    VARCHAR2(10 BYTE),
  BATCH_ID                       NUMBER(16),
  ENVELOPE_ID                    NUMBER(4),
/*******
LEARNER DATA
*******/
  LEARNER_ID           VARCHAR2(10 BYTE),
  TITLE_ID             NUMBER,
  OTHER_TITLE          VARCHAR2(25 BYTE),
  FORENAME             VARCHAR2(25 BYTE),
  SURNAME              VARCHAR2(25 BYTE),
  HOUSENAME_NO         VARCHAR2(32 BYTE),
  ADDRESS_LINE1        VARCHAR2(65 BYTE),
  ADDRESS_LINE2        VARCHAR2(65 BYTE),
  ADDRESS_LINE3        VARCHAR2(32 BYTE),
  ADDRESS_LINE4        VARCHAR2(32 BYTE),
  POSTCODE             VARCHAR2(8 BYTE),
  DOB                  DATE,
  GENDER               VARCHAR2(1 BYTE),
  TELEPHONE_NO         VARCHAR2(15 BYTE),
  EMAIL_ADDRESS        VARCHAR2(80 BYTE),
  LIVES_SCOTLAND_FLAG  VARCHAR2(1 BYTE),
  LIVES_AWAY_FLAG      VARCHAR2(1 BYTE),
/*******
LEARNER APPLICATION DATA
*******/
  COURSE_ID                     NUMBER(10),
  COURSE_TYPE_ID	        NUMBER,	
  PROVIDER_ID                   VARCHAR2(10 BYTE),
  APPLICATION_STATUS_ID         VARCHAR2(1 BYTE) ,
  TOTAL_ANNUAL_INCOME           NUMBER(9),
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
  COURSE_TITLE                  VARCHAR2(50 BYTE),
  COURSE_START_DATE             DATE,
  LENGTH_OF_COURSE              NUMBER,
  CURRENT_COURSE_YEAR           NUMBER,
  COURSE_END_DATE               DATE,
  HELP_WITH_FEES                VARCHAR2(1 BYTE),
  HELP_AMOUNT                   NUMBER(15,2) DEFAULT 0,
  COURSE_FEE                    NUMBER(15,2) DEFAULT 0,
  PROVIDER_SIGNATURE_PRESENT    VARCHAR2(1 BYTE),
  ENDORSED_BY                   VARCHAR2(40 BYTE),
  DATE_ENDORSED                 DATE,
  STAMPED                       VARCHAR2(1 BYTE),
  LEARNER_SIGNATURE_PRESENT     VARCHAR2(1 BYTE),
  DATE_SIGNED                   DATE,
  WEB_USER_ID                   VARCHAR2(25 BYTE)
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

COMMENT ON COLUMN RAW_DATA.LEARNER_ID 		IS 'Unique ILA reference number'
/
COMMENT ON COLUMN RAW_DATA.TITLE_ID    		IS 'Title of learner e.g. Mr or Mrs'
/
COMMENT ON COLUMN RAW_DATA.OTHER_TITLE      	IS 'If title is not in UI dropdown other title is entered'
/         
COMMENT ON COLUMN RAW_DATA.FORENAME             IS 'First name of learner'
/         
COMMENT ON COLUMN RAW_DATA.SURNAME              IS 'Last name of learner'
/
COMMENT ON COLUMN RAW_DATA.HOUSENAME_NO    	IS 'House name or number of learner address'
/           
COMMENT ON COLUMN RAW_DATA.ADDRESS_LINE1    	IS 'Line 1 of learner address'
/           
COMMENT ON COLUMN RAW_DATA.ADDRESS_LINE2  	IS 'Line 2 of learner address'
/           
COMMENT ON COLUMN RAW_DATA.ADDRESS_LINE3    	IS 'Line 3 of learner address'
/           
COMMENT ON COLUMN RAW_DATA.ADDRESS_LINE4	IS 'Line 4 of learner address'
/           
COMMENT ON COLUMN RAW_DATA.POSTCODE		IS 'Postal code of learner address'
/  
COMMENT ON COLUMN RAW_DATA.DOB                  IS 'Birth date of learner'
/ 
COMMENT ON COLUMN RAW_DATA.GENDER               IS 'Male or Female'
/ 
COMMENT ON COLUMN RAW_DATA.TELEPHONE_NO         IS 'Telephone number of learner'
/ 
COMMENT ON COLUMN RAW_DATA.EMAIL_ADDRESS        IS 'Email address of learner'
/                   
COMMENT ON COLUMN RAW_DATA.LIVES_SCOTLAND_FLAG  IS 'Y if learner lives in Scotland'
/     
COMMENT ON COLUMN RAW_DATA.LIVES_AWAY_FLAG	IS 'Y if learner lives away from SCotland temporarily'
/            
COMMENT ON COLUMN RAW_DATA.COURSE_ID		IS 'Foreign key to COURSE table'
/ 
COMMENT ON COLUMN RAW_DATA.PROVIDER_ID		IS 'Foreign key to PROVIDER table'
/        
COMMENT ON COLUMN RAW_DATA.APPLICATION_STATUS_ID IS 'Foreign key to APPLICATION_STATUS table'
/                      
COMMENT ON COLUMN RAW_DATA.TOTAL_ANNUAL_INCOME  IS 'Total annual income of learner application form'
/                        


--
-- RAW_DATA_U01  (Index) 
--
CREATE UNIQUE INDEX RAW_DATA_U01 ON RAW_DATA
(LEARNER_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


-- 
-- Non Foreign Key Constraints for Table RAW_DATA 
-- 
ALTER TABLE RAW_DATA ADD (
  CONSTRAINT RAW_DATA_U01
 UNIQUE (LEARNER_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ))
/


          
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  RAW_DATA TO EDM_USER;



/*

COLUMNS STILL TO BE COMMENTED ON:-
             
  TOT_ANN_INC_EVID_ID           
  NO_INCOME                     
  NO_INCOME_EVID_ID             
  JOB_SEEKERS_ALLOWANCE         
  JSA_EVID_ID                   
  INCOME_SUPPORT                
  INC_SUP_EVID_ID               
  INCAPACITY_BENEFIT            
  INC_BEN_EVID_ID               
  CARERS_ALLOWANCE              
  CARERS_ALLOWANCE_EVID_ID      
  PENSION_CREDIT                
  PENSION_CREDIT_EVID_ID        
  MAX_CHILD_TAX_CREDIT          
  MAX_CHILD_TAX_CREDIT_EVID_ID  
  SESSION_YEAR                  
  DATE_APP_RECD                
  DATE_RECORD_CREATED          
  COURSE_TITLE                  
  COURSE_START_DATE            
  LENGTH_OF_COURSE              
  CURRENT_COURSE_YEAR          
  COURSE_END_DATE              
  HELP_WITH_FEES                
  HELP_AMOUNT                   
  COURSE_FEE                    
  PROVIDER_SIGNATURE_PRESENT    
  DATE_ENDORSED                 
  STAMPED                       
  LEARNER_SIGNATURE_PRESENT     
  DATE_SIGNED        

*/