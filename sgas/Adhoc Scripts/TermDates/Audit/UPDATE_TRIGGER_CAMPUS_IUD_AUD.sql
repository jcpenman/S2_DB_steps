CREATE OR REPLACE TRIGGER CAMPUS_IUD_AUD
   AFTER INSERT OR DELETE OR UPDATE 
   ON CAMPUS    FOR EACH ROW
DECLARE
   p_aud_date       DATE                            := SYSDATE;
   p_column_name    CAMPUS_AUD.column_name%TYPE    := NULL;
   p_table_pkey1    CAMPUS_AUD.table_pkey1%TYPE    := :OLD.CAMPUS_ID;
   p_table_pkey2    CAMPUS_AUD.table_pkey2%TYPE    := NULL;
   p_table_pkey3    CAMPUS_AUD.table_pkey3%TYPE    := NULL;
   p_table_pkey4    CAMPUS_AUD.table_pkey4%TYPE    := NULL;
   p_table_pkey5    CAMPUS_AUD.table_pkey5%TYPE    := NULL;
   p_old            CAMPUS_AUD.OLD%TYPE            := NULL;
   p_new            CAMPUS_AUD.NEW%TYPE            := NULL;
   p_action         CAMPUS_AUD.action%TYPE         := NULL;
   p_username       CAMPUS_AUD.username%TYPE       := :NEW.LAST_UPDATED_BY;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.CAMPUS_ID;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.CAMPUS_ID;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'INST_CODE';
   p_old := TO_CHAR (:OLD.INST_CODE);
   p_new := TO_CHAR (:NEW.INST_CODE);
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'CAMPUS_CODE';
   p_old := :OLD.CAMPUS_CODE;
   p_new := :NEW.CAMPUS_CODE;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'NAME';
   p_old := :OLD.NAME;
   p_new := :NEW.NAME;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );

   p_column_name := 'HOUSE_NO_NAME';
   p_old := :OLD.HOUSE_NO_NAME;
   p_new := :NEW.HOUSE_NO_NAME;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           
   p_column_name := 'ADDR_L1';
   p_old := :OLD.ADDR_L1;
   p_new := :NEW.ADDR_L1;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_L2';
   p_old := :OLD.ADDR_L2;
   p_new := :NEW.ADDR_L2;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_L3';
   p_old := :OLD.ADDR_L3;
   p_new := :NEW.ADDR_L3;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_L4';
   p_old := :OLD.ADDR_L4;
   p_new := :NEW.ADDR_L4;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'POSTCODE';
   p_old := :OLD.POSTCODE;
   p_new := :NEW.POSTCODE;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_EASTING';
   p_old := :OLD.ADDR_EASTING;
   p_new := :NEW.ADDR_EASTING;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_NORTHING';
   p_old := :OLD.ADDR_NORTHING;
   p_new := :NEW.ADDR_NORTHING;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'PAYMENT_METHOD';
   p_old := :OLD.PAYMENT_METHOD;
   p_new := :NEW.PAYMENT_METHOD;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           
   p_column_name := 'BANK_NAME';
   p_old := :OLD.BANK_NAME;
   p_new := :NEW.BANK_NAME;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_SORT_CODE';
   p_old := :OLD.BANK_SORT_CODE;
   p_new := :NEW.BANK_SORT_CODE;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ACCOUNT_NO';
   p_old := :OLD.ACCOUNT_NO;
   p_new := :NEW.ACCOUNT_NO;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_HOUSE_NO_NAME';
   p_old := :OLD.BANK_HOUSE_NO_NAME;
   p_new := :NEW.BANK_HOUSE_NO_NAME;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_ADDR_L1';
   p_old := :OLD.BANK_ADDR_L1;
   p_new := :NEW.BANK_ADDR_L1;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_ADDR_L2';
   p_old := :OLD.BANK_ADDR_L2;
   p_new := :NEW.BANK_ADDR_L2;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_ADDR_L3';
   p_old := :OLD.BANK_ADDR_L3;
   p_new := :NEW.BANK_ADDR_L3;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_ADDR_L4';
   p_old := :OLD.BANK_ADDR_L4;
   p_new := :NEW.BANK_ADDR_L4;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_POST_CODE';
   p_old := :OLD.BANK_POST_CODE;
   p_new := :NEW.BANK_POST_CODE;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'CAMPUS_DEBT';
   p_old := :OLD.CAMPUS_DEBT;
   p_new := :NEW.CAMPUS_DEBT;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'CSV_ID';
   p_old := :OLD.CSV_ID;
   p_new := :NEW.CSV_ID;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'FEE_LOAN_DEBT';
   p_old := :OLD.FEE_LOAN_DEBT;
   p_new := :NEW.FEE_LOAN_DEBT;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                                                   
                                                      
END campus_iud_aud;
/