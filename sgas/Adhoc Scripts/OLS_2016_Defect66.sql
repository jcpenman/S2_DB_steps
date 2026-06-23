-- SAAS WebPortal Defect 66 -----------------------------

CREATE OR REPLACE TRIGGER UPDATE_CANCELLED_FLAG
BEFORE INSERT OR UPDATE
OF AWARD_STATUS_MESSAGE_ID
ON STUD_AWARD_STATUS
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
    IF (:NEW.award_status_message_id = 1)
      THEN
         :NEW.cancelled_ind := 'Y';
    ELSE
         :NEW.cancelled_ind := 'N';
    END IF;

END;
