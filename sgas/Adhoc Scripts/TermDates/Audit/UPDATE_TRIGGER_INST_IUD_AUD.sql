CREATE OR REPLACE TRIGGER INST_IUD_AUD
   AFTER INSERT OR DELETE OR UPDATE 
   ON INST    FOR EACH ROW
DECLARE
   p_aud_date       DATE                            := SYSDATE;
   p_column_name    INST_AUD.column_name%TYPE    := NULL;
   p_table_pkey1    INST_AUD.table_pkey1%TYPE    := :OLD.INST_CODE;
   p_table_pkey2    INST_AUD.table_pkey2%TYPE    := NULL;
   p_table_pkey3    INST_AUD.table_pkey3%TYPE    := NULL;
   p_table_pkey4    INST_AUD.table_pkey4%TYPE    := NULL;
   p_table_pkey5    INST_AUD.table_pkey5%TYPE    := NULL;
   p_old            INST_AUD.OLD%TYPE            := NULL;
   p_new            INST_AUD.NEW%TYPE            := NULL;
   p_action         INST_AUD.action%TYPE         := NULL;
   p_username       INST_AUD.username%TYPE       := :NEW.LAST_UPDATED_BY;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.INST_CODE;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.INST_CODE;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'INST_TYPE_ID';
   p_old := TO_CHAR (:OLD.INST_TYPE_ID);
   p_new := TO_CHAR (:NEW.INST_TYPE_ID);
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   p_column_name := 'INST_NAME';
   p_old := :OLD.INST_NAME;
   p_new := :NEW.INST_NAME;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   p_column_name := 'NOMINATED_IND';
   p_old := :OLD.NOMINATED_IND;
   p_new := :NEW.NOMINATED_IND;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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

   p_column_name := 'SEMESTER';
   p_old := :OLD.SEMESTER;
   p_new := :NEW.SEMESTER;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'CATEGORY';
   p_old := :OLD.CATEGORY;
   p_new := :NEW.CATEGORY;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'REGION_CODE';
   p_old := :OLD.REGION_CODE;
   p_new := :NEW.REGION_CODE;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'COLLEGE_TYPE';
   p_old := :OLD.COLLEGE_TYPE;
   p_new := :NEW.COLLEGE_TYPE;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'LOCATION_IND';
   p_old := :OLD.LOCATION_IND;
   p_new := :NEW.LOCATION_IND;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'NOM_NAME';
   p_old := :OLD.NOM_NAME;
   p_new := :NEW.NOM_NAME;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'HOUSE_NO_OR_NAME';
   p_old := :OLD.HOUSE_NO_OR_NAME;
   p_new := :NEW.HOUSE_NO_OR_NAME;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'POST_CODE';
   p_old := :OLD.POST_CODE;
   p_new := :NEW.POST_CODE;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'TELE_NO';
   p_old := :OLD.TELE_NO;
   p_new := :NEW.TELE_NO;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'FINANCE_CONTACT';
   p_old := :OLD.FINANCE_CONTACT;
   p_new := :NEW.FINANCE_CONTACT;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'FINANCE_OFFICE';
   p_old := :OLD.FINANCE_OFFICE;
   p_new := :NEW.FINANCE_OFFICE;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'PRINCIPAL';
   p_old := :OLD.PRINCIPAL;
   p_new := :NEW.PRINCIPAL;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'FORMS_OFFICE';
   p_old := :OLD.FORMS_OFFICE;
   p_new := :NEW.FORMS_OFFICE;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'SKELETON';
   p_old := :OLD.SKELETON;
   p_new := :NEW.SKELETON;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'MAILSORT';
   p_old := :OLD.MAILSORT;
   p_new := :NEW.MAILSORT;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'LABELS';
   p_old := :OLD.LABELS;
   p_new := :NEW.LABELS;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'LETTER';
   p_old := :OLD.LETTER;
   p_new := :NEW.LETTER;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'BREAK';
   p_old := :OLD.BREAK;
   p_new := :NEW.BREAK;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'INSTAL_NO';
   p_old := :OLD.INSTAL_NO;
   p_new := :NEW.INSTAL_NO;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'INSTAL_INFO';
   p_old := :OLD.INSTAL_INFO;
   p_new := :NEW.INSTAL_INFO;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'PAMS';
   p_old := :OLD.PAMS;
   p_new := :NEW.PAMS;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'CAM_DEBT';
   p_old := :OLD.CAM_DEBT;
   p_new := :NEW.CAM_DEBT;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'LAST_STATUS_REP';
   p_old := :OLD.LAST_STATUS_REP;
   p_new := :NEW.LAST_STATUS_REP;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'LIS_ID';
   p_old := :OLD.LIS_ID;
   p_new := :NEW.LIS_ID;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'NON_PUBLIC_FUND';
   p_old := :OLD.NON_PUBLIC_FUND;
   p_new := :NEW.NON_PUBLIC_FUND;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'HEI_INST_CODE';
   p_old := :OLD.HEI_INST_CODE;
   p_new := :NEW.HEI_INST_CODE;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                           

   p_column_name := 'BACS_FIRST';
   p_old := :OLD.BACS_FIRST;
   p_new := :NEW.BACS_FIRST;
   pk_steps_aud.ins_inst_aud (p_aud_date,
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
                                                      
                                                      
END inst_iud_aud;
/