/* Formatted on 2009/12/04 11:02 (Formatter Plus v4.8.8) */
/* CONFIG_DATA.sql
 *
 * Generated from SGAS schema in gv36eda.test2 database using TOAD.
 *
 * All objects into USERS tablespace.
 * Init storage now 100K
 *
 * Modification history: 
 * 04.03.2008 Initial Version   Robert Hunter
 * 15.06.2009 Added CURRENT_SESSION Paul Hughes
 * 17.06.2009 Added ADDR1, ADDR2, ADDR3, SAAS_WEB_ADDR Paul Hughes
 * 11.09.2009 Added Award Notice config entries - Angel Anchev
 * 20.10.2009 added DSA Reminder Letter entries - Clark Bolan
 * 05.10.2010 Added Manual_Payment_QA_Threshold value to the table - A.Bowman
 * 
 * Configuration Management: 
 * $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/CONFIG_DATA.sql $ 
 * $Author: $ 
 * $Date: 2011-02-07 11:56:54 +0000 (Mon, 07 Feb 2011) $ 
 * $Revision: 6418 $ 
 */

ALTER TABLE sgas.config_data
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.config_data CASCADE CONSTRAINTS
/
--
-- CONFIG_DATA  (Table) 
--
CREATE TABLE sgas.config_data
(
  item_name  VARCHAR2(40 BYTE) CONSTRAINT nn_cod_item_name NOT NULL,
  cval       VARCHAR2(255 BYTE),
  nval       NUMBER
)
TABLESPACE users
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100 k
            NEXT             100 k
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

--
-- P_COD  (Index) 
--
CREATE UNIQUE INDEX p_cod ON sgas.config_data
(item_name)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100 k
            NEXT             100 k
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

-- 
-- Non Foreign Key Constraints for Table CONFIG_DATA 
-- 

ALTER TABLE sgas.config_data ADD (
  CONSTRAINT p_cod
 PRIMARY KEY
 (item_name)
    USING INDEX
    TABLESPACE users
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          100 k
                NEXT             100 k
                MINEXTENTS       1
                MAXEXTENTS       99
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ))
/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM config_data
/
CREATE PUBLIC SYNONYM config_data FOR sgas.config_data
/

GRANT SELECT ON SGAS.CONFIG_DATA TO ILA500;


INSERT INTO config_data
            (item_name,
             cval, nval
            )
     VALUES ('EDM_LOCAL_DIR',
             '/export/home/dev_share/edm_documents/', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('EDM_REMOTE_DIR', 'Q:/edm_documents/', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SHELL_PATH', 'Q:/DUMMY_Shell_Letters_STEPS', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SHELL_FILETYPE', 'DOC', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SHELL_TARGET_DIR', 'Q:/edm_documents/', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SHELL_EMAIL_ADDR', 'www.saas.gov.uk/contact.htm', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SHELL_TELE_NO', '0845 111 1711', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SHELL_FAX_NO', '0131 244 5887', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('CURRENT_SESSION', '2010', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('ADDR_L1', 'GYLEVIEW HOUSE', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('ADDR_L2', '3 REDHEUGHS RIGG', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('ADDR_L3', 'EDINBURGH EH12 9HH', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SAAS_WEB_ADDR', 'http://www.saas.gov.uk', NULL
            );
INSERT INTO config_data
            (item_name,
             cval, nval
            )
     VALUES ('AWARD_NOTICE_ROOT_PATH',
             '/projects/app/webmethods/letters/awardnotice', NULL
            );
INSERT INTO config_data
            (item_name, cval,
             nval
            )
     VALUES ('AN_LOGO_FULL_PATH', '/projects/app/webmethods/SAASlogo.png',
             NULL
            );
INSERT INTO config_data
            (item_name,
             cval, nval
            )
     VALUES ('AN_UK_BATCH_SERVER_PATH',
             '/projects/app/webmethods/letters/awardnotice/uk', NULL
            );
INSERT INTO config_data
            (item_name,
             cval, nval
            )
     VALUES ('AN_NUK_BATCH_SERVER_PATH',
             '/projects/app/webmethods/letters/awardnotice/nuk', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('AN_UK_BATCH_CLIENT_PATH', 'L:\letters\awardnotice\uk', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('AN_NUK_BATCH_CLIENT_PATH', 'L:\letters\awardnotice\nuk', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('DSA_REMINDER_1_DAYS', NULL, 5
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('DSA_REMINDER_2_DAYS', NULL, 10
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('DSA_REMINDER_3_DAYS', NULL, 15
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('DSA_REMINDER_DEBT_TASK', NULL, 20
            );
INSERT INTO config_data
            (item_name,
             cval, nval
            )
     VALUES ('DSA_REMINDER_LETTERS_PATH',
             '/projects/app/webmethods/letters/DSAReminderLetters', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('EISTREAM_DOMAIN_NAME', 'SAASEDMT', NULL
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('STEPS_RELEASE_YEAR', NULL, 2010
            );
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('COA_PAYMENT_NO', NULL, 3
            );      
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('DAYS_AHEAD_BACS', NULL, 12
            );    
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('DAYS_AHEAD_CHEQUE', NULL, 12
            );      
INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('MAX_BATCH_PAYMENTS', NULL, 1000
            );   
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('BACS_PROCESS_DAYS',null,2
            );
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('CHEQUE_PROCESS_DAYS', null,3
            );     
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('STEPS_BACS_SAVE_LOCATION','/projects/app/webmethods/reports/StEPSPayments/BACS_Files',null
            );  
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('ADI_JOURNAL_SAVE_LOCATION','/projects/app/webmethods/reports/StEPSPayments/ADI_Journals',null
            );         
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('DAYS_AHEAD_FEES', null, 12
            );        
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('BATCH_PRE_FIX', 'SAS', null
            );   
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('ATTEND_STOP_PAY_SEQUENCE_SCOTT', null, 5
            );  
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('ATTEND_STOP_PAY_SEQUENCE_RUK', null, 5
            );   
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('PROVISIONAL_STOP_PAY_SEQUENCE_SCOTT', null, 5
            );
            
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('PROVISIONAL_STOP_PAY_SEQUENCE_RUK', null, 5
            );
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('ATTENDANCE_OVERRIDE', 'N', null
            );
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('MANUAL_PAYMENT_QA_THRESHOLD', null , 1000
            );  
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('CURRENT_BATCH_SEQUENCE', null , 1000
            );
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('PROCESS_TEMP','/projects/sgas/process_temp',NULL
            );        
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('STUDENT_STATUS_REPORT','/projects/app/webmethods/reports/ReportsToInstitutions/StudentStatusReports',NULL
            );
INSERT INTO CONFIG_DATA
            (item_name, cval, nval
            )
    VALUES('FEE_PAYMENT_REPORT','/projects/app/webmethods/reports/ReportsToInstitutions/FeePaymentReports',NULL
            );
INSERT INTO CONFIG_DATA 
            (ITEM_NAME, CVAL, NVAL 
            ) 
     VALUES('ED7_DEST','/projects/sgas/temp/reports', NULL
<<<<<<< .mine
             );
=======
             ); 
INSERT INTO CONFIG_DATA 
            (ITEM_NAME, CVAL, NVAL 
            ) 
     VALUES('SEAS_EMAIL_ADDR','john.penman@scotland.gsi.gov.uk', NULL
             ); 
INSERT INTO CONFIG_DATA 
            (ITEM_NAME, CVAL, NVAL 
            ) 
     VALUES('SEAS_FINANCE_CONT_NAME','Fiona Watson', NULL
             ); 
INSERT INTO CONFIG_DATA 
            (ITEM_NAME, CVAL, NVAL 
            ) 
     VALUES('SEAS_FINANCE_CONT_EXT','Ext 44444', NULL
             ); 
INSERT INTO CONFIG_DATA 
            (ITEM_NAME, CVAL, NVAL 
            ) 
     VALUES('SEAS_EMAIL_ADDR_CC','clark.bolan@scotland.gsi.gov.uk,paul.hughes@scotland.gsi.gov.uk', NULL
             ); 
             
COMMIT;
>>>>>>> .r6574

DELETE FROM CONFIG_DATA
WHERE ITEM_NAME = 'EISTREAM_DOMAIN_NAME';

INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('EISTREAM_DOMAIN_NAME', 'SAASEDM', NULL
            );
			
DELETE FROM CONFIG_DATA
WHERE ITEM_NAME = 'EDM_LOCAL_DIR';

INSERT INTO config_data
            (item_name,
             cval, nval
            )
     VALUES ('EDM_LOCAL_DIR',
             '/projects/app/webmethods/edm_documents/', NULL
            );
			
DELETE FROM CONFIG_DATA
WHERE ITEM_NAME = 'EDM_REMOTE_DIR';

INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('EDM_REMOTE_DIR', 'L:/edm_documents/', NULL
            );
			
DELETE FROM CONFIG_DATA
WHERE ITEM_NAME = 'SHELL_PATH';

INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SHELL_PATH', 'L:/s2010_letters/', NULL
            );
			
DELETE FROM CONFIG_DATA
WHERE ITEM_NAME = 'SHELL_FILETYPE';

INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SHELL_FILETYPE', 'doc', NULL
            );
			
DELETE FROM CONFIG_DATA
WHERE ITEM_NAME = 'SHELL_TARGET_DIR';

INSERT INTO config_data
            (item_name, cval, nval
            )
     VALUES ('SHELL_TARGET_DIR', 'L:/edm_documents/', NULL
            );
COMMIT; 


                


