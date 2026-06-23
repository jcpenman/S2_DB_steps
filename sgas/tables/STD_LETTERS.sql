-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--          25/01/11    A.Bowman (SAAS)              Amended size of doc_name in line with what is on DEV and SIT
--            28.02.08   S Durkin (Sopra UK)         Initial Version.
--	      06/08/09	 D Crease 	
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STD_LETTERS.sql $
-- $Author: $
-- $Date: 2011-05-20 16:22:47 +0100 (Fri, 20 May 2011) $
-- $Revision: 6937 $
--

SET DEFINE OFF;

DROP TABLE SGAS.std_letters CASCADE CONSTRAINTS
/

--
-- STD_LETTERS  (Table) 
--
--  
CREATE TABLE SGAS.std_letters
(
    doc_name  VARCHAR2(20 BYTE)    NOT NULL,
    doc_desc  VARCHAR2(50 BYTE)    NOT NULL,
    cat_code  VARCHAR2(5 BYTE)     NOT NULL
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

COMMENT ON COLUMN SGAS.std_letters.doc_name IS 'File name of original document.'
/
COMMENT ON COLUMN SGAS.std_letters.doc_desc IS 'Free text information on the file.'
/

ALTER TABLE SGAS.STD_LETTERS ADD (
  CONSTRAINT F1_ST_LTR
 FOREIGN KEY (CAT_CODE) 
 REFERENCES SGAS.STD_LETTERS_CATEGORIES (CAT_CODE));

DROP PUBLIC SYNONYM STD_LETTERS
/

--
-- STD_LETTERS  (Synonym) 
--
--  Dependencies: 
--   STD_LETTERS (Table)
--
CREATE PUBLIC SYNONYM STD_LETTERS FOR SGAS.STD_LETTERS
/

-- GRANT SELECT ON  SGAS.STD_LETTERS TO SGAS_QUERY
-- /

/* Formatted on 2011/03/28 15:46 (Formatter Plus v4.8.8) */
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('ABROAD01', 'COMP FULL OR PART YR ABROAD-ERASMUS EXCHANGE', 'ABR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('ABROAD02', 'COMP FULL OF PART YR ABROAD-NON ERASMUS EXCHANGE', 'ABR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('ABROAD03', 'COMP FULL YR ABROAD-NON EXCHANGE', 'ABR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('ABROAD04', 'COMP PART YR ABROAD-NON EXCHANGE', 'ABR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('ABROAD05', 'VOL FULL OR PART YR ABROAD-ERASMUS EXCHANGE', 'ABR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('ABROAD06', 'VOL FULL OR PART YR ABROAD-NON ERASMUS EXCHANGE', 'ABR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('ABROAD07', 'VOL FULL YR ABROAD-NON EXCHANGE', 'ABR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('ABROAD08', 'VOL PART YR ABROAD-NON EXCHANGE', 'ABR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('ABROAD09', 'EU COMP OR VOL YR ABROAD-NON EXCHANGE', 'ABR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('ABROAD10', 'LANGUAGE ASSISTANT-FULL YR', 'ABR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('ABROAD11', 'LANGUAGE ASSISTANT-PART YR', 'ABR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP01', 'APP-RECEIVED AFTER CLOSING DATE', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP02', 'APP-MISSING EDUCATION/EMPLOYMENT DETAILS', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP03', 'APP-INCOMPLETE INCOME-SEND AB36', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP03A', 'APP-INCOMPLETE INCOME-SEND AB36 (ABROAD)', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP04', 'APP-EVIDENCE THAT STUDENT HAS A PARTNER', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP05', 'APP-NO INSTITUTION/COURSE DETAILS', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP06', 'APP-REQ PROOF OF SEPARATION FROM STUDENT', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP07', 'APP-REQ PROOF OF SEPARATION FROM STUD FOR PARENT', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP08', 'APP-REQ PROOF OF SEPARATION FROM PARENT ETC', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP09', 'APP-J/A-REQUEST PARENT(S) NI NUMBERS', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP10', 'APP-NO RESIDENCE DETAILS-SEND FORM', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP11', 'APP-PENDED-AWAITING INFORMATION FROM INST/SLC', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP12', 'APP-INVALID BANK DETAILS', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP13', 'APP-WRONG SESSION APPLICATION', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP14', 'APP-SAS 7 INCORRECT-SAS 3 FORM ENCLOSED', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP15', 'APP-NO RESIDENCE OR EMP/EDUCATION DETAILS', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP16', 'APP-NON INCOME-ASSESSED-SYSTEM RESTRICTED', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP17', 'APP-REQ FOR OFFER LETTER-DANCE AND DRAMA', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP18', 'APP-INCOMPLETE INCOME & REQ PRV YRS INC', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP18a', 'APP-INCOMPLETE INCOME & REQ PRV YRS INC (ABROAD)', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP19', 'APP-WITHDRAWAL REQUEST INCOME DOCS TO FINALISE', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP20', 'APP-DROP IN INCOME REQ DOCS-NON INC ASS RESTRICT', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP21', 'APP-UPDATED BANK DETAILS', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP22', 'APP-INCORRECT DOCS FOR FINALISING INCOME DETAILS', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('APP23', 'APP-PARENT ABROAD-REQ CORRECT FIN YR INCOME', 'APP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('BLANK', 'BLANK SHELL', 'BLA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE01', 'COURSE NOT YET VALIDATED', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE02', 'HNC REFUSAL-SCOT F', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE03', 'HNC REFUSAL-RUK G', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE04', 'PREVIOUS FUNDING AND QUALIFIED-SCOT F', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE05', 'PREVIOUS FUNDING AND QUALIFIED-RUK G', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE06', '2ND DEGREE DENTISTRY-SCOT F', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE07', 'FALSE START', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE08', 'COURSE CHANGE-SCOT F', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE09', 'COURSE CHANGE-RUK G', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE10', 'COURSE CHANGE-SCOT D', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE11', 'COURSE CHANGE-RUK E', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE12', 'COURSE CHANGE-SCOT C', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE13', 'COURSE CHANGE-RUK B', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE14', 'POST HND SUPPORT-SCOT F', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE15', 'POST HND SUPPORT-RUK G', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE16', 'POST HND SUPPORT-SCOT D', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE17', 'POST HND SUPPORT-RUK E', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE18', 'POST HND SUPPORT-SCOT C', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE19', 'POST HND SUPPORT-RUK B', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE20', 'AHP SUPPORT FOR GRADUATES', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE21', 'AHP SUPPORT-COURSE CHANGE', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE22', 'AHP SUPPORT-POST HND', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE23', 'REFUSAL-ACCELERATED LLB', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE24', 'ARCHITECTURE STUDENTS', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE25', '4 YR DEGREE STUDENTS CONVERTING TO 5 YR DEGREE', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('COURSE26', 'ALREADY HOLDS A HIGHER PG QUALIFICATION', 'COUR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('CURINC01', 'CI-SEND LETTER TO PARENT', 'CURIN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('CURINC01a', 'CI-SEND LETTER TO PARENT (ABROAD)', 'CURIN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('CURINC02', 'CI-SEND LETTER TO STUDENT FOR PARENT', 'CURIN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('CURINC02a', 'CI-SEND LETTER TO STUDENT FOR PARENT (ABROAD)', 'CURIN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('CURINC03', 'CI-15% DROP NOT EXPECTED', 'CURIN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('CURINC04', 'CI-15% DROP EXPECTED-LETTER TO STUDENT', 'CURIN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('CURINC05', 'CI-15% DROP EXPECTED-LETTER TO PARENT', 'CURIN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('CURINC06', 'CI-REQ FOR ACTUAL INC- LETTER TO STUDENT', 'CURIN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('CURINC07', 'CI-REQ FOR ACTUAL INC-LETTER TO PARENT', 'CURIN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('CURINC07a', 'CI-REQ FOR ACTUAL INC-LETTER TO PARENT (ABROAD)', 'CURIN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('CURINC08', 'CI-FINALISATION-REVERT BACK-LETTER TO STUDENT', 'CURIN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('CURINC09', 'CI- FINALISATION-REVERT BACK-LETTER TO PARENT', 'CURIN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DEP01', 'DEPENDANTS GRANT-INCOME TOO HIGH', 'DEP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DEP02', 'DEPENDANTS GRANT-REQUEST EST OF INCOME', 'DEP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DEP03', 'ADVANCE OF SUPPS', 'DEP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA01', 'CONFIRMATION OF PAYMENT OF DSA', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA02', 'SAS3 NEEDED-NEW STUDENT', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA03', 'SAS3 NEEDED-CONTINUING STUDENT', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA04', 'SAS3 STILL TO BE PROCESSED', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA05', 'MORE INFORMATION REQUIRED', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA06', 'APPLICATION RETURNED-INCOMPLETE', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA07', 'APP RECEIVED TOO LATE-CONTINUING STUDENT', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA08', 'APP RECEIVED TOO LATE-FINAL YEAR STUDENT', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA09', 'REPORT RECEIVED TOO LATE-CONTINUING STUDENT', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA10', 'REPORT RECEIVED TOO LATE-FINAL YEAR STUDENT', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA11', 'TELL STUDENT ABOUT REFERRAL TO ACCESS CENTRE', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA12', 'PAYMENT FOR HELPERS', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA13', 'OP-TOTAL OF RECEIPTS LESS THAN PAYMENT', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA14', 'REMINDER FOR RECEIPTS-21 DAY LETTER', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA15', 'DSA CLAIM ONLY', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA16', 'NEARING MAXIMUM OF NON-MEDICAL PERSONAL HELP', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA17', 'DSA RECEIPTS-SECOND REMINDER', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA18', 'DSA FORM REQUIRED', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA19', 'DSA RECEIPTS-FINAL REMINDER', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA20', 'DSA TRAVEL ELEMENT', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DSA21', 'ACKNOWLEDGE RECEIPTS', 'DSA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DTH01', 'DEATH OF STUDENT-CONFIRM NO MORE MONEY DUE', 'DTH'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('DTH02', 'DEATH OF STUDENT-MONEY DUE', 'DTH'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EU01', 'REFUSAL - EU NON GRADUATING', 'EU'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EU02', 'TUITION FEES-NURSING STUDENT', 'EU'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EU03', 'GRADUATING-EVIDENCE REQUEST', 'EU'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EU04', 'EU NATIONALS O/R IN REST OF UK STUDYING IN SCOT', 'EU'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EH05', 'UK RETURNERS STUDY IN SCOT LEFT FROM REST OF UK', 'EH'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EU06', 'REFUSAL-PREVIOUS QUALIFCATION', 'EU'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EXEMPT01', 'EXEMPT PAR CON-REFUSAL - SEND AB36', 'EXE'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EXEMPT01a', 'EXEMPT PAR CON-REFUSAL-SEND AB36 (ABROAD)', 'EXE'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EXEMPT02', 'EVIDENCE OF 3 YRS SELF SUPPORT OR AB36', 'EXE'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EXEMPT02a', 'EVIDENCE OF 3 YRS SELF SUPPORT OR AB36 (ABROAD)', 'EXE'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EXEMPT03', 'REQ DOCS FOR PROOF OF ESTRANGEMENT', 'EXE'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EXEMPT04', 'PARENTS IN ON APP SO ESTRANGEMENT NOT GRANTED', 'EXE'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EXEMPT05', 'REQ IN DETAILS FROM PARENTS ON BEHALF OF STUDENT', 'EXE'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EXEMPT06', 'ADVISE STUDENT NO INC FROM PARENTS-OFFER MEETING', 'EXE'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EXEMPT07', 'ESTRANGEMENT GRANTED', 'EXE'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EXEMPT08', 'ESTRANGEMENT REFUSED AFTER DOCS RECEIVED', 'EXE'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EXEMPT09', 'ESTRANGEMENT REFUSED AFTER MEETING', 'EXE'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EXEMPT10', 'REQ PROOF OF ONGOING ESTRANGEMENT FOR NEW SESSION', 'EXE'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EXEMPT11', 'STUD REQ FOR MEETING AFTER REFUSING ESTRANGEMENT', 'EXE'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('EXEMPT12', 'REQUEST PROOF OF LEGAL GUARDIANSHIP', 'EXE'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('ISB01', 'INDEPENDENT STUDENT BURSARY AWARD DETAILS', 'ISB'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('INT01', 'RECORD OF TELEPHONE CALL', 'INT'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('INT02', 'REQUEST B1 APPROVAL OF REPEAT ASSISTANCE', 'INT'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('INT03', 'BLANK FILE NOTE', 'INT'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('INT04', 'CURRENT INCOME CALCULATION', 'INT'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('INT05', 'B1 REPEAT DECISION', 'INT'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('INT06', 'DSA NOMINEE FORM', 'INT'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LOAN01', 'FORM NOT FILLED IN OR SIGNED', 'LOAN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LOAN02', 'LOAN CONTACTS', 'LOAN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LOAN03', 'LOAN REQUEST', 'LOAN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LOAN04', 'CLMD NMT LOAN WANTS FULL LOAN-SEND AB36', 'LOAN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LOAN4a', 'CLMD NMT LOAN WANTS FULL LOAN-SEND AB36 (ABROAD)', 'LOAN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LOAN05', 'FEE LOAN/HEI BURSARY CONSENT-RUK G', 'LOAN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LOAN06', 'RUK E/RUK G SCHEME STATUS', 'LOAN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LOAN07', 'FEE LOAN ADJUSTMENT FORM-SESSION 10-11', 'LOAN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LOAN08', 'FEE LOAN ADJUSTMENT FORM-SESSION 11-12', 'LOAN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LOAN09', 'HEI BURSARY CONSENT-RUK G WEB APPS', 'LOAN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LOAN10', 'LOAN REQUEST AND SEND AB36', 'LOAN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LOAN10a', 'LOAN REQUEST AND SEND AB36 (ABROAD)', 'LOAN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LOAN11', 'TOP UP LOAN FORM', 'LOAN'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LPCG01', 'REFUSAL – NOT REGISTERED CHILDCARE  (RUK only)', 'LP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LPCG02', 'LPCG – SEND FORM (RUK only)', 'LP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LPG01', 'REQUEST BC', 'LP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LPG02', 'REQUEST BC AND SINGLE PARENT EVID', 'LP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LPG03', 'REQUEST SINGLE PARENT EVID', 'LP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('LPG04', 'REVISED AWARD BREAKDOWN-WTC INCLUDED', 'LP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('MGR01', 'REQ EVID-NEW STUDENT', 'MGR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('MGR02', 'REQ EVID-CONT STUD-ASS FEE ONLY-MGR LAST YR', 'MGR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('MGR03', 'REQ EVID-CONT STUD-REFUSED MGR LAST YR', 'MGR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('MGR04', 'REQ EVID-CONTD STUD-FULL SUPP PAID IN ERROR', 'MGR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('MGR05', 'ACCEPT-NEW STUD-DEPENDENT', 'MGR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('MGR06', 'ACCEPT-NEW STUD-INDEPENDENT', 'MGR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('MGR07', 'ACCEPT-CONT STUD-DEPENDENT', 'MGR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('MGR08', 'ACCEPT-CONT STUD-INDEPENDENT', 'MGR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('MGR09', 'REFUSE-NEW STUD', 'MGR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('MGR10', 'REFUSE-CONT STUD', 'MGR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('MGR11', 'REFUSE-NOT O/R IN SCOTLAND ON RELEVANT DATE', 'MGR'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('NMSB01', 'NMSB-DEPENDANTS GRANT-INCOME TOO HIGH', 'NMSB'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('NMSB02', 'NMSB-O/P OF AWARD DUE TO WITHDRAWAL', 'NMSB'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('NMSB03', 'NMSB-APPLICATION RECEIVED TOO EARLY', 'NMSB'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('NMSB04', 'NMSB-REQ SINGLE PARENT EVID', 'NMSB'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('NMSB05', 'NMSB-CONTINUATION OF SUPPORT', 'NMSB'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('NMSB06', 'NMSB-DEPS INCOME TOO HIGH-CHILDCARE ALLOW FORM', 'NMSB'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('NMSB07', 'NMSB-CHILDCARE ALLOWANCE FORM', 'NMSB'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('NMSB08', 'NMSB-ESTIMATE OF SPOUSES INCOME', 'NMSB'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('NMSB09', 'NMSB OVERPAYMENT-APPLY FOR EXTENSION', 'NMSB'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('NMSB10', 'NMSB OVERPAYMENT-EXCLUDE PAY DETAILS', 'NMSB'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('NMSB11', 'NMSB OFFER LETTER', 'NMSB'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('NMSB12', 'INCORRECT NMSB APPLICATION', 'NMSB'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('NMSBRES01', 'REFUSAL-NON EEA NATIONAL', 'NMSB'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('NMSBRES02', 'REFUSAL-UK NATIONAL', 'NMSB'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('OTHR01', 'CHEQUE RETURNED-ASK STUDENT WHY', 'OTH'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('OTHR02', 'ASSESSED CONTRIBUTION-LETTER TO PARENT ETC', 'OTH'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('OVRP01', 'REFUND PREVIOUS O/P-NON INC ASS ONLY THIS YEAR', 'OVRP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('OVRP02', 'REQUEST FOR REFUND OF O/P DUE TO DISCONT. STUDIES', 'OVRP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('OVRP03', 'O/P-DEPENDANTS GRANT ON FINALISATION', 'OVRP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('OVRP04', 'O/P-DUE TO OUR ERROR', 'OVRP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('OVRP05', 'O/P-DUE TO WITHDRAWAL', 'OVRP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('OVRP06', 'O/P-DUE TO WITHDRAWAL-REDUCE BY TRAVEL', 'OVRP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('OVRP07', 'O/P-FINALISATION-RECOVER FROM NEXT SESSION', 'OVRP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('OVRP08', 'O/P-FINALISATION-ASK FOR REPAYMENT', 'OVRP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('OVRP09', 'U/P-DUE TO FINALISATION', 'OVRP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('OVRP10', 'O/P-PR YR FINALISATION-LIFT REST ON CURRENT YR', 'OVRP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('OVRP11', 'CANCELLATION/AMENDMENT OF OVERPAYMENT (OP10)', 'OVRP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('OVRP12', 'O/P WTC-RECOVER FROM NEXT SESSION', 'OVRP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('OVRP13', 'O/P WTC-ASK FOR REPAYMENT', 'OVRP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('PG01', 'PG-REFUSAL-ALREADY QUALIFIED', 'PG'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('PG02', 'PG-NOT NOMINATED', 'PG'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('PG03', 'PG-AWAITING NOMINATIONS', 'PG'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('PG04', 'PG-REFUSAL END ON', 'PG'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('PG05', 'PG-COURSE NOT FUNDED', 'PG'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('PG06', 'PGCE-REFUSAL PREVIOUS ASSISTANCE', 'PG'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('PG07', 'PG-OUTSIDE SCOTLAND-APPROVED', 'PG'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('PG08', 'PG-OUTSIDE SCOTLAND-CONSIDERING', 'PG'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('PG09', 'PG-REFUSAL MASTER COURSE', 'PG'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('REE01', 'SEARCH OF ENDOWMENTS REGISTER', 'REE'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('REPEAT01', 'REFUSAL-REPEAT YEAR', 'REP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('REPEAT02', 'REPEAT YEAR GRANTED', 'REP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('REPEAT03', 'REPEAT YEAR -EXPLANATION OF REFUSAL', 'REP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('REPEAT04', 'REPEAT APPROVAL-COPY TO INSTITUTION', 'REP'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES01', 'REFUSAL-EU (NON UK) NATIONAL FULL SUPPORT', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES02', 'REFUSAL-APPLY TO LEA', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES03', 'REFUSAL-NON EEA NATIONAL', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES04', 'REFUSAL-UK NATIONAL', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES05', 'REFUSAL-UK RTRS STUDY SCOT LAST HOME NOT SCOT', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES06', 'NON EEA NATIONAL-REQUEST EVIDENCE', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES07', 'SEND OUT AB10-S', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES08', 'AB10A-UK STUDENT STILL ABROAD', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('REA08a', 'AB10A-EEA STUDENT STILL ABROAD', 'REA'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES09', 'AB10B-UK PARENTS STILL ABROAD', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES09a', 'AB10B-EEA PARENTS STILL ABROAD', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES10', 'AB10C-UK STUDENT BANK IN THE UK', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES10a', 'AB10C-EEA STUDENT BANK IN THE EEA', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES11', 'AB10D-UK PARENTS BANK IN THE UK', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES11a', 'AB10C-EEA PARENTS BANK IN THE EEA', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES12', 'AB10E-FURTHER RESIDENCE-STUDENT', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES13', 'AB10F-FURTHER RESIDENCE-PARENT', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES14', 'REFUSAL-ASYLUM SEEKERS', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES15', 'AWARDED FUNDING BUT LLR RUNS OUT DURING THE COURSE', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES16', 'REQ EVID THEY HAVE APPLIED FOR EXT TO LLR OR ILR', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES17', 'RECEIPT OF UKBA ACKNOWLEDGE LETTER', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES18', 'RECEIPT OF UKBA APPEAL LETTER', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('RES19', 'LLR RUNS OUT BEFORE CRSE START REQ EVID OF EXT/ILR', 'RES'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('STUDINC01', 'TICKED BENEFIT TYPE BUT NO EST OF INCOME GIVEN', 'STUDI'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('STUDINC02', 'EST OF INCOME SAME AS WTC STATEMENT', 'STUDI'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('STUDINC03', 'CHECK IF EST OF INCOME IS CORRECT FIGURE', 'STUDI'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('TRAV01', 'TRAVEL-REFUSE WALK DIST-6 JOURNEYS PAID', 'TRAV'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('TRAV02', 'TRAVEL-REQUEST FOR INCOME-SEND AB36', 'TRAV'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('TRAV02A', 'TRAVEL-REQUEST FOR INCOME-SEND AB36 (ABROAD)', 'TRAV'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('TRAV03', 'TRAVEL-CLAIM LESS THAN ELEMENT', 'TRAV'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('TRAV04', 'TRAVEL-EXPLANATION OF CALCULATION', 'TRAV'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('TRAV05', 'TRAVEL-WALK DIST AND 6 JOURNEYS LESS THAN ELEMT', 'TRAV'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('TRAV06', 'TRAVEL-NOT SAAS FUNDED-REFER TO LEA ETC', 'TRAV'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('TRAV07', 'TRAVEL-CLAIM RECEIVED BUT NO SAS APPLICATION', 'TRAV'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('TRAV08', 'TRAVEL-NON INC ASS SYS REST-REQUEST DOCS', 'TRAV'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('TRAV09', 'TRAVEL-REFUSE EU STUDENT', 'TRAV'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('TRAV10', 'TRAVEL-REFUSE NMSB', 'TRAV'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('TRAV11', 'TRAVEL-REQUEST PROOF OF AIR FARES', 'TRAV'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('WITH01', 'WITHDRAWAL-INFORM STUDENT NO O/P', 'WITH'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('Z01', 'COURSE REFUSAL', 'Z0'
            );
INSERT INTO sgas.std_letters
            (doc_name, doc_desc, cat_code
            )
     VALUES ('Z02', 'COURSE REFUSAL-EMA', 'Z0'
            );
COMMIT;