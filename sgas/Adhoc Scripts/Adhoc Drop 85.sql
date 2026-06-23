ALTER TABLE SGAS.DSA_ALLOWANCE
 DROP COLUMN reminders_sent;

ALTER TABLE SGAS.DSA_ALLOWANCE
 DROP COLUMN date_last_reminder_sent;

ALTER TABLE SGAS.DSA_PAYMENT 
ADD ( reminders_sent number(1), 
  date_last_reminder_sent date );


CREATE OR REPLACE TRIGGER SGAS.DSA_ALL_iud
   AFTER INSERT OR DELETE OR UPDATE OF ID,
                                       dsa_application_id,
                                       stud_session_id,
                                       stud_crse_year_id,
                                       dsa_category_id,                    
                                       max_amount,
                                       available_amount,
                                       paid_amount,
                                       travel_amount,
                                       payment_due_date,
                                       date_paid,
                                       statutory_override_limit,
                                       general_override_limit,
                                       last_updated_by 
ON SGAS.DSA_ALLOWANCE FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DSA_ALLOWANCE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_ALLOWANCE_aud.table_pkey1%TYPE
                                               := :OLD.ID;
   p_table_pkey2    DSA_ALLOWANCE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_ALLOWANCE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_ALLOWANCE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_ALLOWANCE_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_ALLOWANCE_aud.OLD%TYPE            := NULL;
   p_new            DSA_ALLOWANCE_aud.NEW%TYPE            := NULL;
   p_action         DSA_ALLOWANCE_aud.action%TYPE         := NULL;
   p_username       DSA_ALLOWANCE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_ALLOWANCE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_ALLOWANCE_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_ALLOWANCE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'ID';
   p_old := :OLD.id;
   p_new := :NEW.id;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'dsa_application_id';
   p_old := :OLD.dsa_application_id;
   p_new := :NEW.dsa_application_id;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'stud_session_id';
   p_old := :OLD.stud_session_id;
   p_new := :NEW.stud_session_id;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'stud_crse_year_id';
   p_old := :OLD.stud_crse_year_id;
   p_new := :NEW.stud_crse_year_id;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'dsa_category_id';
   p_old := :OLD.dsa_category_id;
   p_new := :NEW.dsa_category_id;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'max_amount';
   p_old := :OLD.max_amount;
   p_new := :NEW.max_amount;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'available_amount';
   p_old := :OLD.available_amount;
   p_new := :NEW.available_amount;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'paid_amount';
   p_old := :OLD.paid_amount;
   p_new := :NEW.paid_amount;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'travel_amount';
   p_old := :OLD.travel_amount;
   p_new := :NEW.travel_amount;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'payment_due_date';
   p_old := :OLD.payment_due_date;
   p_new := :NEW.payment_due_date;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'date_paid';
   p_old := :OLD.date_paid;
   p_new := :NEW.date_paid;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'statutory_override_limit';
   p_old := :OLD.statutory_override_limit;
   p_new := :NEW.statutory_override_limit;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'general_override_limit';
   p_old := :OLD.general_override_limit;
   p_new := :NEW.general_override_limit;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'last_updated_by';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );                                   
  
END DSA_ALL_IUD;
SHOW ERRORS;