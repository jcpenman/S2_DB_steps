/******************************************************************************
   NAME:       SCY_UPDATE_SUPP_STATUS
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        07/01/2015      Ewan Watson       1. Created this trigger.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     SCY_UPDATE_SUPP_STATUS
      Sysdate:         07/01/2015
      Date and Time:   07/01/2015, 08:20:21, and 07/01/2015 08:20:21
 ******************************************************************************/
CREATE OR REPLACE TRIGGER SCY_UPDATE_SUPP_STATUS
    BEFORE UPDATE
    OF APPLICATION_STATUS
    ON STUD_CRSE_YEAR
    REFERENCING NEW AS New OLD AS Old
    FOR EACH ROW

DECLARE

    BEGIN
        IF (:NEW.application_status <> :OLD.application_status)
        THEN
       
            CASE :NEW.application_status
            
                WHEN 'C' THEN :NEW.supp_status_id := '2';
                              :NEW.supp_last_update := sysdate;
                WHEN 'W' THEN :NEW.supp_status_id := '6';
                              :NEW.supp_last_update := sysdate;
                WHEN 'A' THEN :NEW.supp_status_id := '8';
                              :NEW.supp_last_update := sysdate;
                WHEN 'T' THEN :NEW.supp_status_id := '14';
                              :NEW.supp_last_update := sysdate;
                WHEN 'R' THEN :NEW.supp_status_id := '15';
                              :NEW.supp_last_update := sysdate;
            
           
            END CASE;
       END IF;
  

       
    END SCY_UPDATE_SUPP_STATUS;

