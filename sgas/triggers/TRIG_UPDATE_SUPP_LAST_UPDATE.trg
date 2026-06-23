CREATE OR REPLACE TRIGGER SCY_UPDATE_SUPP_LAST_UPDATE
    BEFORE UPDATE
    OF SUPP_STATUS_ID
    ON STUD_CRSE_YEAR
    REFERENCING NEW AS New OLD AS Old
    FOR EACH ROW
DECLARE

    BEGIN
        IF (:NEW.supp_status_id <> :OLD.supp_status_id)
        THEN
           :NEW.supp_last_update := SYSDATE;
           
       END IF;
  

       
    END SCY_UPDATE_SUPP_LAST_UPDATE;
/