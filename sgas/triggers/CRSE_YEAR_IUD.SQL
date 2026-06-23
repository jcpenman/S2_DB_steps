CREATE OR REPLACE TRIGGER CRSE_YEAR_IUD
   AFTER INSERT OR DELETE OR UPDATE 
   ON CRSE_YEAR
   FOR EACH ROW
BEGIN
   INSERT INTO SLCADMIN.RESET_COURSE RC (RC.CRSE_ID, RC.SESSION_CODE)
      SELECT DISTINCT NVL (:NEW.CRSE_ID, :OLD.CRSE_ID), CS.SESSION_CODE
        FROM CRSE_SESSION CS
       WHERE     CS.CRSE_SESSION_ID =
                    NVL (:NEW.CRSE_SESSION_ID, :OLD.CRSE_SESSION_ID)
             AND NOT EXISTS
                        (SELECT 1
                           FROM SLCADMIN.RESET_COURSE RC1
                          WHERE     RC1.CRSE_ID =
                                       NVL (:NEW.CRSE_ID, :OLD.CRSE_ID)
                                AND RC1.SESSION_CODE = CS.SESSION_CODE);
                                
   IF UPDATING AND NVL(:OLD.HEI_CRSE_CODE,'x') != NVL(:NEW.HEI_CRSE_CODE,'x')
   THEN
          INSERT INTO crse_term_change
                  (crse_year_id, change_date
                  )
          VALUES( :NEW.CRSE_YEAR_ID, SYSDATE);

   END IF;                                
END;
/