CREATE OR REPLACE TRIGGER SGAS.DEP_GDPR
AFTER INSERT OR DELETE
ON SGAS.STUD_DEPENDANT
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    IF INSERTING
    THEN
        --If the dependant is 16 years old or older add a record to the STUD_DEP_GDPR table to send a notification letter
        if months_between(sysdate,TO_DATE(:new.DOB))/12 >= 16
        then
        INSERT INTO STUD_DEP_GDPR (STD_ID, STUD_REF_NO, GDPR_SENT, FLAGGED_FOR_LETTER, LETTER_SESSION) VALUES (:new.STD_ID, :new.STUD_REF_NO, 'N', SYSDATE, :new.SESSION_CODE);
        end if;
    ELSIF DELETING
    THEN
        --Delete the record if a GDPR notification has NOT been sent.
        DELETE from STUD_DEP_GDPR where STD_ID = :OLD.STD_ID AND GDPR_SENT = 'N';
    END IF;

END;
/