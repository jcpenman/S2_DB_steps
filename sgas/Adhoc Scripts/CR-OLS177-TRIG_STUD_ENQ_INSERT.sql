-----------------------------------------------------------------
-- CREATE TRIGGER -> TRIG_STUD_ENQ_EDM_INSERTS
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
      WHEN 1 THEN 'SE_CHANGE_COURSE'
      WHEN 2 THEN 'SE_CANCEL_APP'
      WHEN 3 THEN 'SE_AMEND_APP'
      WHEN 4 THEN 'SE_LPG_QUERY'
      WHEN 5 THEN 'SE_BURSARY_QUERY'
      WHEN 6 THEN 'SE_CE_QUERY'
      WHEN 7 THEN 'SE_DSA_QUERY'
      WHEN 8 THEN 'SE_OLS_QUERY'
      WHEN 9 THEN 'SE_GENERAL_QUERY'
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