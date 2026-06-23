-----------------------------------------------------------------
-- CREATE DATABASE JOB -> TRANSFER_STUD_ENQUIRIES
-----------------------------------------------------------------

--BEGIN 
--  SYS.DBMS_JOB.REMOVE(150);
--COMMIT;
--END;
--/

DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => 'PK_STEPS_STUD_ENQUIRY.TRANSFER_STUD_ENQUIRIES;'
   ,next_date => SYSDATE  
   ,interval  => 'SYSDATE+30/1440 '
   ,no_parse  => FALSE
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
COMMIT;
END;
/

--COMMIT;



-----------------------------------------------------------------
-- CREATE TABLE -> STUD_ENQUIRY 
-----------------------------------------------------------------

--ALTER TABLE SGAS.STUD_ENQUIRY DROP PRIMARY KEY CASCADE;
--DROP TABLE SGAS.STUD_ENQUIRY CASCADE CONSTRAINTS;

CREATE TABLE SGAS.STUD_ENQUIRY
(
  ENQUIRY_ID         NUMBER                     NOT NULL,
  STUD_REF_NO        NUMBER                     NOT NULL,
  ENQUIRY_OPTION_ID  NUMBER                     NOT NULL,
  ENQUIRY_TEXT       VARCHAR2(1024 BYTE),
  ENQUIRY_DATE       DATE                       NOT NULL,
  SESSION_CODE       NUMBER,
  IS_VIEWED          CHAR(1 BYTE)               DEFAULT 'N'                   NOT NULL,
  LAST_UPDATED_BY    VARCHAR2(100 BYTE),
  LAST_UPDATED_ON    DATE,
  CREATED_DATE       DATE
);

CREATE UNIQUE INDEX SGAS.STUD_ENQUIRY_PK ON SGAS.STUD_ENQUIRY (ENQUIRY_ID);

ALTER TABLE SGAS.STUD_ENQUIRY ADD (
  CONSTRAINT STUD_ENQUIRY_PK
  PRIMARY KEY
  (ENQUIRY_ID)
  USING INDEX SGAS.STUD_ENQUIRY_PK
  ENABLE VALIDATE);

ALTER TABLE SGAS.STUD_ENQUIRY ADD (
  FOREIGN KEY (ENQUIRY_OPTION_ID) 
  REFERENCES SGAS.ENQUIRY_OPTION (ENQUIRY_OPTION_ID)
  ENABLE VALIDATE);

--COMMIT;

-----------------------------------------------------------------
-- CREATE TRIGGER -> TRIG_STUD_ENQ_SET_CREATED_DATE
-----------------------------------------------------------------

CREATE OR REPLACE TRIGGER SGAS.TRIG_STUD_ENQ_SET_CREATED_DATE
BEFORE INSERT
ON SGAS.STUD_ENQUIRY
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE

BEGIN
  :NEW.Created_Date := SYSDATE;
END TRIG_STUD_ENQ_SET_CREATED_DATE;
/

--COMMIT;

-----------------------------------------------------------------
-- CREATE TRIGGER -> STUD_ENQUIRY_TRIGGER_SET_SESSION_CODE
-----------------------------------------------------------------

CREATE OR REPLACE TRIGGER SGAS.TRIG_STUD_ENQ_SET_SESSION_CODE
BEFORE INSERT
ON SGAS.STUD_ENQUIRY
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
FOLLOWS TRIG_STUD_ENQ_SET_CREATED_DATE
DECLARE
sessionCode NUMBER;

BEGIN    
  sessionCode := 0;
  SELECT CVAL INTO sessionCode FROM CONFIG_DATA WHERE ITEM_NAME = 'CURRENT_SESSION';
  :NEW.SESSION_CODE := sessionCode;
  EXCEPTION
  WHEN OTHERS THEN
  RAISE;
END TRIG_STUD_ENQ_SET_SESSION_CODE;
/

--COMMIT;



-----------------------------------------------------------------
-- CREATE TABLE -> STUD_ENQUIRY_TRANSFER_ERROR
-----------------------------------------------------------------

--ALTER TABLE SGAS.STUD_ENQUIRY_TRANSFER_ERROR DROP PRIMARY KEY CASCADE;
--DROP TABLE SGAS.STUD_ENQUIRY_TRANSFER_ERROR CASCADE CONSTRAINTS;

CREATE TABLE SGAS.STUD_ENQUIRY_TRANSFER_ERROR
(
  ERROR_ID      INTEGER,
  ERROR_TEXT    VARCHAR2(1024 BYTE),
  CREATED_DATE  DATE
);

CREATE UNIQUE INDEX SGAS.STUD_ENQUIRY_TRANSFER_ERROR_PK ON SGAS.STUD_ENQUIRY_TRANSFER_ERROR (ERROR_ID);

ALTER TABLE SGAS.STUD_ENQUIRY_TRANSFER_ERROR ADD (
  CONSTRAINT STUD_ENQUIRY_TRANSFER_ERROR_PK
  PRIMARY KEY
  (ERROR_ID)
  USING INDEX SGAS.STUD_ENQUIRY_TRANSFER_ERROR_PK
  ENABLE VALIDATE);

--COMMIT;

-----------------------------------------------------------------
-- CREATE SEQUENCE -> STUD_ENQ_TRANSFER_ERR_ID_SEQ
-----------------------------------------------------------------

CREATE SEQUENCE SGAS.STUD_ENQ_TRANSFER_ERR_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 0
  NOCYCLE
  NOCACHE
  NOORDER;

-----------------------------------------------------------------
-- CREATE TRIGGER -> TRIG_STUD_ENQ_TRANSFER_ERR_ID
-----------------------------------------------------------------

CREATE OR REPLACE TRIGGER SGAS.TRIG_STUD_ENQ_TRANSFER_ERR_ID
  BEFORE INSERT
  ON SGAS.STUD_ENQUIRY_TRANSFER_ERROR FOR EACH ROW
BEGIN
  SELECT STUD_ENQ_TRANSFER_ERR_ID_SEQ.NEXTVAL
    INTO :NEW.ERROR_ID
    FROM DUAL;
END;

--COMMIT;

-----------------------------------------------------------------
-- CREATE TRIGGER -> TRIG_STUD_ENQ_ERR_DATE
-----------------------------------------------------------------

CREATE OR REPLACE TRIGGER SGAS.TRIG_STUD_ENQ_ERR_DATE
BEFORE INSERT
ON SGAS.STUD_ENQUIRY_TRANSFER_ERROR
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE

BEGIN
  :NEW.Created_Date := SYSDATE;
END TRIG_STUD_ENQ_ERR_DATE;
/

--COMMIT;



-----------------------------------------------------------------
-- CREATE TRIGGER -> TRIG_STUD_ENQ_ERR_DATE
-----------------------------------------------------------------

CREATE OR REPLACE TRIGGER TRIG_STUD_ENQ_EDM_INSERTS
AFTER INSERT
ON SGAS.STUD_ENQUIRY
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
  studRefNo number;
  enqDate date;
  enquiryOptionId number;
  batchTypeCode number;
  documentTypeCode varchar(100);
  enquiryId number;
  sessionCode number;
BEGIN
  SELECT :new.STUD_REF_NO INTO studRefNo FROM dual;
  SELECT :new.ENQUIRY_DATE INTO enqDate FROM dual;
  SELECT :new.ENQUIRY_OPTION_ID INTO enquiryOptionId FROM dual;
  SELECT :new.ENQUIRY_ID INTO enquiryId FROM dual;
  SELECT :new.SESSION_CODE INTO sessionCode FROM dual; 
  
  documentTypeCode := 
    CASE enquiryOptionId
      WHEN 1 THEN 'SE_CANCEL_AMEND'
      WHEN 2 THEN 'SE_DEPENDANTS'
      WHEN 3 THEN 'SE_DSA'
      WHEN 4 THEN 'SE_MIGRANT'
      WHEN 5 THEN 'SE_PLACEMENT'
      WHEN 6 THEN 'SE_STUDY_ABROAD'
      WHEN 7 THEN 'SE_VACATION_CARE'
      WHEN 8 THEN 'SE_OTHER'
      ELSE 'Other'
    END;
  
  Insert into EDM.EDM_COMPLETE (OBJECT_ID, BATCH_TYPE_CODE, STUD_REF_NO, SCAN_DATE, PROC_ERROR, URGENT)
  Values (concat(CONCAT('SE',studRefNo),enquiryId), 99, studRefNo, enqDate, 'N', 'N');
    
  Insert into EDM.EDM_TEMP (OBJECT_ID, SESSION_CODE, DOCUMENT_TYPE_CODE, DOCUMENT_NAME, DOCUMENT_TYPE_COUNT, ATTACHMENT_TYPE_CODE)
  Values (concat(CONCAT('SE',studRefNo),enquiryId), sessionCode, documentTypeCode, CONCAT(studRefNo,'-STUD_ENQUIRY_MSG'), 1, 'PDF');

  EXCEPTION
  WHEN OTHERS THEN
    -- Consider logging the error and then re-raise
    RAISE;
END TRIG_STUD_ENQ_EDM_INSERTS;
/