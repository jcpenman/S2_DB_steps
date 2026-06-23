
CREATE OR REPLACE TRIGGER EDM.RAW_DATA_DEP$AUDIT_TRIG
   AFTER INSERT OR UPDATE
   ON EDM.RAW_DATA_DEP
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   v_operation   VARCHAR2 (10) := NULL;
BEGIN
   IF INSERTING
   THEN
      v_operation := 'INS';
   ELSIF UPDATING
   THEN
      v_operation := 'UPD';
   END IF;

   IF INSERTING OR UPDATING
   THEN
      INSERT INTO edm.RAW_DATA_DEP$test_data (AUD_ACTION,
                                              AUD_TIMESTAMP,
                                              AUD_USER,
                                              OBJECT_ID,
                                              STUD_REF_NO,
                                              STUD_DEP_ID,
                                              FORENAMES,
                                              SURNAME,
                                              DOB,
                                              DEPENDANT_RELATIONSHIP_ID,
                                              TOTAL_INCOME,
                                              EMAIL_ADDR,
                                              POST_CODE,
                                              HOUSE_NO_NAME,
                                              ADDR_L1,
                                              ADDR_L2,
                                              ADDR_L3,
                                              ADDR_L4,
                                              LPG)
           VALUES (v_operation,
                   SYSDATE,
                   USER,
                   :NEW.object_id,
                   :NEW.STUD_REF_NO,
                   :NEW.STUD_DEP_ID,
                   :NEW.FORENAMES,
                   :NEW.SURNAME,
                   :NEW.DOB,
                   :NEW.DEPENDANT_RELATIONSHIP_ID,
                   :NEW.TOTAL_INCOME,
                   :NEW.EMAIL_ADDR,
                   :NEW.POST_CODE,
                   :NEW.HOUSE_NO_NAME,
                   :NEW.ADDR_L1,
                   :NEW.ADDR_L2,
                   :NEW.ADDR_L3,
                   :NEW.ADDR_L4,
                   :NEW.LPG);
   END IF;
END;
/