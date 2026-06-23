CREATE OR REPLACE TRIGGER UPDATE_CANCELLED_FLAG
BEFORE INSERT OR UPDATE
OF AWARD_STATUS_MESSAGE_ID
ON SGAS.STUD_AWARD_STATUS
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE

    app_status  STUD_CRSE_YEAR.APPLICATION_STATUS%type;

BEGIN
    IF (:NEW.AWARD_STATUS_MESSAGE_ID = 1) -- 6  Rejected status not shown by Kainos on web portal
    THEN
        :NEW.CANCELLED_IND := 'Y';
        
    ELSE IF (:OLD.AWARD_STATUS_MESSAGE_ID = 1 ) -- As above so we don't care what new status is
         THEN
         
         select STUD_CRSE_YEAR.APPLICATION_STATUS into app_status from stud_crse_year where STUD_CRSE_YEAR.STUD_CRSE_YEAR_ID=:NEW.STUD_CRSE_YEAR_ID;
         
            IF(app_status='N' OR app_status ='C' OR app_status='T')
            THEN
             :NEW.CANCELLED_IND := 'N';
            END IF;
         
         END IF;
         
    END IF;

END UPDATE_CANCELLED_FLAG;
/