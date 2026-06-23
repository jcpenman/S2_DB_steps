DROP TRIGGER ADI_PAY_IUD
/

--
-- ADI_PAY_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER adi_pay_iud
   AFTER DELETE OR INSERT OR UPDATE OF adi_payment_id,
                                       payment_status_id,
                                       total_payment_amount
   ON ADI_PAYMENT    FOR EACH ROW
DECLARE
   p_aud_date      DATE                               := SYSDATE;
   p_column_name   adi_payment_aud.column_name%TYPE   := NULL;
   p_primary_key   adi_payment_aud.primary_key%TYPE   := :OLD.adi_payment_id;
   p_old           adi_payment_aud.OLD%TYPE           := NULL;
   p_new           adi_payment_aud.NEW%TYPE           := NULL;
   p_action        adi_payment_aud.action%TYPE        := NULL;
   p_username      adi_payment_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.adi_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'ADI_PAYMENT_ID';
   p_old := :OLD.adi_payment_id;
   p_new := :NEW.adi_payment_id;
   pk_pop_aud.ins_adi_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PAYMENT_STATUS_ID';
   p_old := :OLD.payment_status_id;
   p_new := :NEW.payment_status_id;
   pk_pop_aud.ins_adi_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'TOTAL_PAYMENT_AMOUNT';
   p_old := :OLD.total_payment_amount;
   p_new := :NEW.total_payment_amount;
   pk_pop_aud.ins_adi_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END adi_pay_iud;
/


DROP TRIGGER ADI_PAY_LUB
/

--
-- ADI_PAY_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER adi_pay_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ADI_PAYMENT    FOR EACH ROW
DECLARE
   p_aud_date      DATE                               := SYSDATE;
   p_column_name   adi_payment_aud.column_name%TYPE   := NULL;
   p_primary_key   adi_payment_aud.primary_key%TYPE   := :OLD.adi_payment_id;
   p_old           adi_payment_aud.OLD%TYPE           := NULL;
   p_new           adi_payment_aud.NEW%TYPE           := NULL;
   p_action        adi_payment_aud.action%TYPE        := NULL;
   p_username      adi_payment_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.adi_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_adi_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END api_pay_lub;
/


DROP TRIGGER APP_EVID_IUD
/

--
-- APP_EVID_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER app_evid_iud
   AFTER DELETE OR INSERT OR UPDATE OF evid_id, evid_desc
   ON APPLICATION_EVIDENCE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                        := SYSDATE;
   p_column_name   application_evidence_aud.column_name%TYPE   := NULL;
   p_primary_key   application_evidence_aud.primary_key%TYPE  := :OLD.evid_id;
   p_old           application_evidence_aud.OLD%TYPE           := NULL;
   p_new           application_evidence_aud.NEW%TYPE           := NULL;
   p_action        application_evidence_aud.action%TYPE        := NULL;
   p_username      application_evidence_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.evid_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'EVID_ID';
   p_old := :OLD.evid_id;
   p_new := :NEW.evid_id;
   pk_pop_aud.ins_app_evid_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'EVID_DESC';
   p_old := :OLD.evid_desc;
   p_new := :NEW.evid_desc;
   pk_pop_aud.ins_app_evid_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
END app_evid_iud;
/


DROP TRIGGER APP_EVID_LUB
/

--
-- APP_EVID_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER app_evid_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON APPLICATION_EVIDENCE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                        := SYSDATE;
   p_column_name   application_evidence_aud.column_name%TYPE   := NULL;
   p_primary_key   application_evidence_aud.primary_key%TYPE  := :OLD.evid_id;
   p_old           application_evidence_aud.OLD%TYPE           := NULL;
   p_new           application_evidence_aud.NEW%TYPE           := NULL;
   p_action        application_evidence_aud.action%TYPE        := NULL;
   p_username      application_evidence_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.evid_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_app_evid_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END app_evid_lub;
/


DROP TRIGGER APP_REJ_IUD
/

--
-- APP_REJ_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER app_rej_iud
   AFTER DELETE OR INSERT OR UPDATE OF application_rejection_id,
                                       rejection_reason,
                                       application_rejection_desc
   ON APPLICATION_REJECTION    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                         := SYSDATE;
   p_column_name   application_rejection_aud.column_name%TYPE   := NULL;
   p_primary_key   application_rejection_aud.primary_key%TYPE
                                             := :OLD.application_rejection_id;
   p_old           application_rejection_aud.OLD%TYPE           := NULL;
   p_new           application_rejection_aud.NEW%TYPE           := NULL;
   p_action        application_rejection_aud.action%TYPE        := NULL;
   p_username      application_rejection_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.application_rejection_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'APPLICATION_REJECTION_ID';
   p_old := :OLD.application_rejection_id;
   p_new := :NEW.application_rejection_id;
   pk_pop_aud.ins_app_rej_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'REJECTION_REASON';
   p_old := :OLD.rejection_reason;
   p_new := :NEW.rejection_reason;
   pk_pop_aud.ins_app_rej_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'APPLICATION_REJECTION_DESC';
   p_old := :OLD.application_rejection_desc;
   p_new := :NEW.application_rejection_desc;
   pk_pop_aud.ins_app_rej_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END app_rej_iud;
/


DROP TRIGGER APP_REJ_LUB
/

--
-- APP_REJ_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER app_rej_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON APPLICATION_REJECTION    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                         := SYSDATE;
   p_column_name   application_rejection_aud.column_name%TYPE   := NULL;
   p_primary_key   application_rejection_aud.primary_key%TYPE   := :OLD.application_rejection_id;
   p_old           application_rejection_aud.OLD%TYPE           := NULL;
   p_new           application_rejection_aud.NEW%TYPE           := NULL;
   p_action        application_rejection_aud.action%TYPE        := NULL;
   p_username      application_rejection_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.application_rejection_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_app_rej_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END app_rej_lub;
/


DROP TRIGGER APP_STAT_IUD
/

--
-- APP_STAT_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER app_stat_iud
   AFTER DELETE OR INSERT OR UPDATE OF application_status_id,
                                       status,
                                       application_status_desc
   ON APPLICATION_STATUS    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                      := SYSDATE;
   p_column_name   application_status_aud.column_name%TYPE   := NULL;
   p_primary_key   application_status_aud.primary_key%TYPE
                                                := :OLD.application_status_id;
   p_old           application_status_aud.OLD%TYPE           := NULL;
   p_new           application_status_aud.NEW%TYPE           := NULL;
   p_action        application_status_aud.action%TYPE        := NULL;
   p_username      application_status_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.application_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'APPLICATION_STATUS_ID';
   p_old := :OLD.application_status_id;
   p_new := :NEW.application_status_id;
   pk_pop_aud.ins_app_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'STATUS';
   p_old := :OLD.status;
   p_new := :NEW.status;
   pk_pop_aud.ins_app_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'APPLICATION_STATUS_DESC';
   p_old := :OLD.application_status_desc;
   p_new := :NEW.application_status_desc;
   pk_pop_aud.ins_app_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END app_stat_iud;
/


DROP TRIGGER APP_STAT_LUB
/

--
-- APP_STAT_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER app_stat_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON APPLICATION_STATUS    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                         := SYSDATE;
   p_column_name   application_status_aud.column_name%TYPE   := NULL;
   p_primary_key   application_status_aud.primary_key%TYPE   := :OLD.application_status_id;
   p_old           application_status_aud.OLD%TYPE           := NULL;
   p_new           application_status_aud.NEW%TYPE           := NULL;
   p_action        application_status_aud.action%TYPE        := NULL;
   p_username      application_status_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.application_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_app_stat_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END app_stat_lub;
/


DROP TRIGGER BACS_RUN_IUD
/

--
-- BACS_RUN_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER bacs_run_iud
   AFTER DELETE OR INSERT OR UPDATE OF bacs_run_id,
                                       bacs_run_date,
                                       bacs_run_name
   ON BACS_RUN    FOR EACH ROW
DECLARE
   p_aud_date      DATE                            := SYSDATE;
   p_column_name   bacs_run_aud.column_name%TYPE   := NULL;
   p_primary_key   bacs_run_aud.primary_key%TYPE   := :OLD.bacs_run_id;
   p_old           bacs_run_aud.OLD%TYPE           := NULL;
   p_new           bacs_run_aud.NEW%TYPE           := NULL;
   p_action        bacs_run_aud.action%TYPE        := NULL;
   p_username      bacs_run_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.bacs_run_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'BACS_RUN_ID';
   p_old := :OLD.bacs_run_id;
   p_new := :NEW.bacs_run_id;
   pk_pop_aud.ins_bacs_run_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'BACS_RUN_DATE';
   p_old := :OLD.bacs_run_date;
   p_new := :NEW.bacs_run_date;
   pk_pop_aud.ins_bacs_run_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'BACS_RUN_NAME';
   p_old := :OLD.bacs_run_name;
   p_new := :NEW.bacs_run_name;
   pk_pop_aud.ins_bacs_run_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END bacs_run_iud;
/


DROP TRIGGER BACS_RUN_LUB
/

--
-- BACS_RUN_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER bacs_run_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON BACS_RUN    FOR EACH ROW
DECLARE
   p_aud_date      DATE                            := SYSDATE;
   p_column_name   bacs_run_aud.column_name%TYPE   := NULL;
   p_primary_key   bacs_run_aud.primary_key%TYPE   := :OLD.bacs_run_id;
   p_old           bacs_run_aud.OLD%TYPE           := NULL;
   p_new           bacs_run_aud.NEW%TYPE           := NULL;
   p_action        bacs_run_aud.action%TYPE        := NULL;
   p_username      bacs_run_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.bacs_run_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_bacs_run_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END bacs_run_lub;
/


DROP TRIGGER CASE_NOTE_IUD
/

--
-- CASE_NOTE_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER case_note_iud
   AFTER DELETE OR INSERT OR UPDATE OF cw_note_id,
                                       source_table,
                                       primary_key,
                                       note_type_id,
                                       note_date,
                                       session_year,
                                       note_text
   ON CASEWORKER_NOTE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                   := SYSDATE;
   p_column_name   caseworker_note_aud.column_name%TYPE   := NULL;
   p_primary_key   caseworker_note_aud.primary_key%TYPE   := :OLD.cw_note_id;
   p_old           caseworker_note_aud.OLD%TYPE           := NULL;
   p_new           caseworker_note_aud.NEW%TYPE           := NULL;
   p_action        caseworker_note_aud.action%TYPE        := NULL;
   p_username      caseworker_note_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.cw_note_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'CW_NOTE_ID';
   p_old := :OLD.cw_note_id;
   p_new := :NEW.cw_note_id;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'SOURCE_TABLE';
   p_old := :OLD.source_table;
   p_new := :NEW.source_table;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'PRIMARY_KEY';
   p_old := :OLD.primary_key;
   p_new := :NEW.primary_key;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'NOTE_TYPE_ID';
   p_old := :OLD.note_type_id;
   p_new := :NEW.note_type_id;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'NOTE_DATE';
   p_old := :OLD.note_date;
   p_new := :NEW.note_date;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'SESSION_YEAR';
   p_old := :OLD.session_year;
   p_new := :NEW.session_year;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'NOTE_TEXT';
   p_old := :OLD.note_text;
   p_new := :NEW.note_text;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END case_note_iud;
/


DROP TRIGGER CASE_NOTE_LUB
/

--
-- CASE_NOTE_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER case_note_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON CASEWORKER_NOTE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                            := SYSDATE;
   p_column_name   caseworker_note_aud.column_name%TYPE   := NULL;
   p_primary_key   caseworker_note_aud.primary_key%TYPE   := :OLD.cw_note_id;
   p_old           caseworker_note_aud.OLD%TYPE           := NULL;
   p_new           caseworker_note_aud.NEW%TYPE           := NULL;
   p_action        caseworker_note_aud.action%TYPE        := NULL;
   p_username      caseworker_note_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.cw_note_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_case_note_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END case_note_lub;
/


DROP TRIGGER CONFIG_DATA_IUD
/

--
-- CONFIG_DATA_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER config_data_iud
   AFTER DELETE OR INSERT OR UPDATE OF item_name, cval, nval
   ON ILA500_CONFIG_DATA    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                      := SYSDATE;
   p_column_name   ila500_config_data_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_config_data_aud.primary_key%TYPE  := :OLD.item_name;
   p_old           ila500_config_data_aud.OLD%TYPE           := NULL;
   p_new           ila500_config_data_aud.NEW%TYPE           := NULL;
   p_action        ila500_config_data_aud.action%TYPE        := NULL;
   p_username      ila500_config_data_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.item_name;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'ITEM_NAME';
   p_old := :OLD.item_name;
   p_new := :NEW.item_name;
   pk_pop_aud.ins_config_data_aud (p_aud_date,
                                   p_column_name,
                                   p_primary_key,
                                   p_old,
                                   p_new,
                                   p_action,
                                   p_username
                                  );
   p_column_name := 'CVAL';
   p_old := :OLD.cval;
   p_new := :NEW.cval;
   pk_pop_aud.ins_config_data_aud (p_aud_date,
                                   p_column_name,
                                   p_primary_key,
                                   p_old,
                                   p_new,
                                   p_action,
                                   p_username
                                  );
   p_column_name := 'NVAL';
   p_old := :OLD.nval;
   p_new := :NEW.nval;
   pk_pop_aud.ins_config_data_aud (p_aud_date,
                                   p_column_name,
                                   p_primary_key,
                                   p_old,
                                   p_new,
                                   p_action,
                                   p_username
                                  );
END config_data_iud;
/


DROP TRIGGER CONFIG_DATA_LUB
/

--
-- CONFIG_DATA_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER config_data_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ILA500_CONFIG_DATA    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                      := SYSDATE;
   p_column_name   ila500_config_data_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_config_data_aud.primary_key%TYPE   := :OLD.item_name;
   p_old           ila500_config_data_aud.OLD%TYPE           := NULL;
   p_new           ila500_config_data_aud.NEW%TYPE           := NULL;
   p_action        ila500_config_data_aud.action%TYPE        := NULL;
   p_username      ila500_config_data_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.item_name;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_config_data_aud (p_aud_date,
                                   p_column_name,
                                   p_primary_key,
                                   p_old,
                                   p_new,
                                   p_action,
                                   p_username
                                  );
END config_data_lub;
/


DROP TRIGGER COU_LEV_IUD
/

--
-- COU_LEV_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER cou_lev_iud
   AFTER DELETE OR INSERT OR UPDATE OF course_id, course_level_desc
   ON COURSE_LEVEL    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                := SYSDATE;
   p_column_name   course_level_aud.column_name%TYPE   := NULL;
   p_primary_key   course_level_aud.primary_key%TYPE   := :OLD.course_id;
   p_old           course_level_aud.OLD%TYPE           := NULL;
   p_new           course_level_aud.NEW%TYPE           := NULL;
   p_action        course_level_aud.action%TYPE        := NULL;
   p_username      course_level_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.course_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'COURSE_ID';
   p_old := :OLD.course_id;
   p_new := :NEW.course_id;
   pk_pop_aud.ins_cou_lev_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_LEVEL_DESC';
   p_old := :OLD.course_level_desc;
   p_new := :NEW.course_level_desc;
   pk_pop_aud.ins_cou_lev_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END cou_lev_iud;
/


DROP TRIGGER COU_LEV_LUB
/

--
-- COU_LEV_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER cou_lev_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON COURSE_LEVEL    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                := SYSDATE;
   p_column_name   course_level_aud.column_name%TYPE   := NULL;
   p_primary_key   course_level_aud.primary_key%TYPE   := :OLD.course_id;
   p_old           course_level_aud.OLD%TYPE           := NULL;
   p_new           course_level_aud.NEW%TYPE           := NULL;
   p_action        course_level_aud.action%TYPE        := NULL;
   p_username      course_level_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.course_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_cou_lev_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END cou_lev_lub;
/


DROP TRIGGER COU_TYPE_IUD
/

--
-- COU_TYPE_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER cou_type_iud
   AFTER DELETE OR INSERT OR UPDATE OF course_type_id,
                                       bacs_payment_date,
                                       course_type_desc,
                                       fee_cut_off_date,
                                       fee_period_start,
                                       fee_period_end,
                                       submitted_date,
                                       batch_run_date
   ON COURSE_TYPE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                               := SYSDATE;
   p_column_name   course_type_aud.column_name%TYPE   := NULL;
   p_primary_key   course_type_aud.primary_key%TYPE   := :OLD.course_type_id;
   p_old           course_type_aud.OLD%TYPE           := NULL;
   p_new           course_type_aud.NEW%TYPE           := NULL;
   p_action        course_type_aud.action%TYPE        := NULL;
   p_username      course_type_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.course_type_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'COURSE_TYPE_ID';
   p_old := :OLD.course_type_id;
   p_new := :NEW.course_type_id;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'BACS_PAYMENT_DATE';
   p_old := :OLD.bacs_payment_date;
   p_new := :NEW.bacs_payment_date;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'COURSE_TYPE_DESC';
   p_old := :OLD.course_type_desc;
   p_new := :NEW.course_type_desc;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'FEE_CUT_OFF_DATE';
   p_old := :OLD.fee_cut_off_date;
   p_new := :NEW.fee_cut_off_date;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'FEE_PERIOD_START';
   p_old := :OLD.fee_period_start;
   p_new := :NEW.fee_period_start;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'FEE_PERIOD_END';
   p_old := :OLD.fee_period_end;
   p_new := :NEW.fee_period_end;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'SUBMITTED_DATE';
   p_old := :OLD.submitted_date;
   p_new := :NEW.submitted_date;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'BATCH_RUN_DATE';
   p_old := :OLD.batch_run_date;
   p_new := :NEW.batch_run_date;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END cou_type_iud;
/


DROP TRIGGER COU_TYPE_LUB
/

--
-- COU_TYPE_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER cou_type_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON COURSE_TYPE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                               := SYSDATE;
   p_column_name   course_type_aud.column_name%TYPE   := NULL;
   p_primary_key   course_type_aud.primary_key%TYPE   := :OLD.course_type_id;
   p_old           course_type_aud.OLD%TYPE           := NULL;
   p_new           course_type_aud.NEW%TYPE           := NULL;
   p_action        course_type_aud.action%TYPE        := NULL;
   p_username      course_type_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.course_type_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_cou_type_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END cou_type_lub;
/


DROP TRIGGER DOC_REG_IUD
/

--
-- DOC_REG_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER doc_reg_iud
   AFTER DELETE OR INSERT OR UPDATE OF doc_reg_id,
                                       source_table,
                                       primary_key,
                                       document_type_code,
                                       received_date,
                                       session_year,
                                       returned_date
   ON DOCUMENT_REGISTER    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   document_register_aud.column_name%TYPE   := NULL;
   p_primary_key   document_register_aud.primary_key%TYPE  := :OLD.doc_reg_id;
   p_old           document_register_aud.OLD%TYPE           := NULL;
   p_new           document_register_aud.NEW%TYPE           := NULL;
   p_action        document_register_aud.action%TYPE        := NULL;
   p_username      document_register_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.doc_reg_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'DOC_REG_ID';
   p_old := :OLD.doc_reg_id;
   p_new := :NEW.doc_reg_id;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'SOURCE_TABLE';
   p_old := :OLD.source_table;
   p_new := :NEW.source_table;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PRIMARY_KEY';
   p_old := :OLD.primary_key;
   p_new := :NEW.primary_key;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DOCUMENT_TYPE_CODE';
   p_old := :OLD.document_type_code;
   p_new := :NEW.document_type_code;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'RECEIVED_DATE';
   p_old := :OLD.received_date;
   p_new := :NEW.received_date;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'SESSION_YEAR';
   p_old := :OLD.session_year;
   p_new := :NEW.session_year;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'RETURNED_DATE';
   p_old := :OLD.returned_date;
   p_new := :NEW.returned_date;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END doc_reg_iud;
/


DROP TRIGGER DOC_REG_LUB
/

--
-- DOC_REG_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER doc_reg_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON DOCUMENT_REGISTER    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   document_register_aud.column_name%TYPE   := NULL;
   p_primary_key   document_register_aud.primary_key%TYPE   := :OLD.doc_reg_id;
   p_old           document_register_aud.OLD%TYPE           := NULL;
   p_new           document_register_aud.NEW%TYPE           := NULL;
   p_action        document_register_aud.action%TYPE        := NULL;
   p_username      document_register_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.doc_reg_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END doc_reg_lub;
/


DROP TRIGGER EDM_IMAGES_IUD
/

--
-- EDM_IMAGES_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER edm_images_iud
   AFTER DELETE OR INSERT OR UPDATE OF learner_id,
                                       scan_date,
                                       session_year,
                                       batch_id,
                                       batch_type_code,
                                       object_id,
                                       document_type_code,
                                       document_name,
                                       document_type_count,
                                       attachment_type_code,
                                       envelope_id,
                                       rescan,
                                       rescan_req,
                                       req_original,
                                       rescan_request_id,
                                       annot,
                                       raw_data_id,
                                       viewed_doc,
                                       upload_date
   ON ILA500_EDM_IMAGES    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   ila500_edm_images_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_edm_images_aud.primary_key%TYPE  := :OLD.learner_id;
   p_old           ila500_edm_images_aud.OLD%TYPE           := NULL;
   p_new           ila500_edm_images_aud.NEW%TYPE           := NULL;
   p_action        ila500_edm_images_aud.action%TYPE        := NULL;
   p_username      ila500_edm_images_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.learner_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'LEARNER_ID';
   p_old := :OLD.learner_id;
   p_new := :NEW.learner_id;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'SCAN_DATE';
   p_old := :OLD.scan_date;
   p_new := :NEW.scan_date;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'SESSION_YEAR';
   p_old := :OLD.session_year;
   p_new := :NEW.session_year;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'BATCH_ID';
   p_old := :OLD.batch_id;
   p_new := :NEW.batch_id;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'BATCH_TYPE_CODE';
   p_old := :OLD.batch_type_code;
   p_new := :NEW.batch_type_code;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'OBJECT_ID';
   p_old := :OLD.object_id;
   p_new := :NEW.object_id;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'DOCUMENT_TYPE_CODE';
   p_old := :OLD.document_type_code;
   p_new := :NEW.document_type_code;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'DOCUMENT_NAME';
   p_old := :OLD.document_name;
   p_new := :NEW.document_name;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'DOCUMENT_TYPE_COUNT';
   p_old := :OLD.document_type_count;
   p_new := :NEW.document_type_count;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'ATTACHMENT_TYPE_CODE';
   p_old := :OLD.attachment_type_code;
   p_new := :NEW.attachment_type_code;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'ENVELOPE_ID';
   p_old := :OLD.envelope_id;
   p_new := :NEW.envelope_id;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RESCAN';
   p_old := :OLD.rescan;
   p_new := :NEW.rescan;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RESCAN_REQ';
   p_old := :OLD.rescan_req;
   p_new := :NEW.rescan_req;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'REQ_ORIGINAL';
   p_old := :OLD.req_original;
   p_new := :NEW.req_original;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RESCAN_REQUEST_ID';
   p_old := :OLD.rescan_request_id;
   p_new := :NEW.rescan_request_id;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'ANNOT';
   p_old := :OLD.annot;
   p_new := :NEW.annot;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RAW_DATA_ID';
   p_old := :OLD.raw_data_id;
   p_new := :NEW.raw_data_id;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'VIEWED_DOC';
   p_old := :OLD.viewed_doc;
   p_new := :NEW.viewed_doc;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'UPLOAD_DATE';
   p_old := :OLD.upload_date;
   p_new := :NEW.upload_date;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
END edm_images_iud;
/


DROP TRIGGER EDM_IMAGES_LUB
/

--
-- EDM_IMAGES_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER edm_images_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ILA500_EDM_IMAGES    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   ila500_edm_images_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_edm_images_aud.primary_key%TYPE  := :OLD.learner_id;
   p_old           ila500_edm_images_aud.OLD%TYPE           := NULL;
   p_new           ila500_edm_images_aud.NEW%TYPE           := NULL;
   p_action        ila500_edm_images_aud.action%TYPE        := NULL;
   p_username      ila500_edm_images_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.learner_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_edm_images_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
END edm_images_lub;
/


DROP TRIGGER LEA_APP_IUD
/

--
-- LEA_APP_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER lea_app_iud
   AFTER DELETE OR INSERT OR UPDATE OF learner_application_id,
                                       learner_id,
                                       course_id,
                                       course_type_id,
                                       provider_id,
                                       application_status_id,
                                       rejection_id,
                                       total_annual_income,
                                       tot_ann_inc_evid_id,
                                       no_income,
                                       no_income_evid_id,
                                       job_seekers_allowance,
                                       jsa_evid_id,
                                       income_support,
                                       inc_sup_evid_id,
                                       incapacity_benefit,
                                       inc_ben_evid_id,
                                       carers_allowance,
                                       carers_allowance_evid_id,
                                       pension_credit,
                                       pension_credit_evid_id,
                                       max_child_tax_credit,
                                       max_child_tax_credit_evid_id,
                                       session_year,
                                       date_app_recd,
                                       date_record_created,
                                       date_of_last_calc,
                                       course_title,
                                       course_start_date,
                                       length_of_course,
                                       current_course_year,
                                       course_end_date,
                                       help_with_fees,
                                       help_amount,
                                       fee_requested,
                                       provider_signature_present,
                                       endorsed_by,
                                       date_endorsed,
                                       stamped,
                                       learner_signature_present,
                                       date_signed,
                                       fee_paid_bacs,
                                       payment_date,
                                       recover_fees,
                                       debt_status,
                                       fee_calculated,
                                       comments_for_award_letter,
                                       award_letter_duplicate,
                                       non_attendance,
                                       date_withdrawn,
                                       date_actioned
   ON LEARNER_APPLICATION    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                       := SYSDATE;
   p_column_name   learner_application_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_application_aud.primary_key%TYPE
                                               := :OLD.learner_application_id;
   p_old           learner_application_aud.OLD%TYPE           := NULL;
   p_new           learner_application_aud.NEW%TYPE           := NULL;
   p_action        learner_application_aud.action%TYPE        := NULL;
   p_username      learner_application_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.learner_application_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'LEARNER_APPLICATION_ID';
   p_old := :OLD.learner_application_id;
   p_new := :NEW.learner_application_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LEARNER_ID';
   p_old := :OLD.learner_id;
   p_new := :NEW.learner_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_ID';
   p_old := :OLD.course_id;
   p_new := :NEW.course_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_TYPE_ID';
   p_old := :OLD.course_type_id;
   p_new := :NEW.course_type_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PROVIDER_ID';
   p_old := :OLD.provider_id;
   p_new := :NEW.provider_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'APPLICATION_STATUS_ID';
   p_old := :OLD.application_status_id;
   p_new := :NEW.application_status_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'REJECTION_ID';
   p_old := :OLD.rejection_id;
   p_new := :NEW.rejection_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'TOTAL_ANNUAL_INCOME';
   p_old := :OLD.total_annual_income;
   p_new := :NEW.total_annual_income;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'TOT_ANN_INC_EVID_ID';
   p_old := :OLD.tot_ann_inc_evid_id;
   p_new := :NEW.tot_ann_inc_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NO_INCOME';
   p_old := :OLD.no_income;
   p_new := :NEW.no_income;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NO_INCOME_EVID_ID';
   p_old := :OLD.no_income_evid_id;
   p_new := :NEW.no_income_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'JOB_SEEKERS_ALLOWANCE';
   p_old := :OLD.job_seekers_allowance;
   p_new := :NEW.job_seekers_allowance;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'JSA_EVID_ID';
   p_old := :OLD.jsa_evid_id;
   p_new := :NEW.jsa_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'INCOME_SUPPORT';
   p_old := :OLD.income_support;
   p_new := :NEW.income_support;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'INC_SUP_EVID_ID';
   p_old := :OLD.inc_sup_evid_id;
   p_new := :NEW.inc_sup_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'INCAPACITY_BENEFIT';
   p_old := :OLD.incapacity_benefit;
   p_new := :NEW.incapacity_benefit;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'INC_BEN_EVID_ID';
   p_old := :OLD.inc_ben_evid_id;
   p_new := :NEW.inc_ben_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'CARERS_ALLOWANCE';
   p_old := :OLD.carers_allowance;
   p_new := :NEW.carers_allowance;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'CARERS_ALLOWANCE_EVID_ID';
   p_old := :OLD.carers_allowance_evid_id;
   p_new := :NEW.carers_allowance_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PENSION_CREDIT';
   p_old := :OLD.pension_credit;
   p_new := :NEW.pension_credit;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PENSION_CREDIT_EVID_ID';
   p_old := :OLD.pension_credit_evid_id;
   p_new := :NEW.pension_credit_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'MAX_CHILD_TAX_CREDIT';
   p_old := :OLD.max_child_tax_credit;
   p_new := :NEW.max_child_tax_credit;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'MAX_CHILD_TAX_CREDIT_EVID_ID';
   p_old := :OLD.max_child_tax_credit_evid_id;
   p_new := :NEW.max_child_tax_credit_evid_id;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'SESSION_YEAR';
   p_old := :OLD.session_year;
   p_new := :NEW.session_year;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_APP_RECD';
   p_old := :OLD.date_app_recd;
   p_new := :NEW.date_app_recd;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_RECORD_CREATED';
   p_old := :OLD.date_record_created;
   p_new := :NEW.date_record_created;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_OF_LAST_CALC';
   p_old := :OLD.date_of_last_calc;
   p_new := :NEW.date_of_last_calc;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_TITLE';
   p_old := :OLD.course_title;
   p_new := :NEW.course_title;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_START_DATE';
   p_old := :OLD.course_start_date;
   p_new := :NEW.course_start_date;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LENGTH_OF_COURSE';
   p_old := :OLD.length_of_course;
   p_new := :NEW.length_of_course;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'CURRENT_COURSE_YEAR';
   p_old := :OLD.current_course_year;
   p_new := :NEW.current_course_year;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COURSE_END_DATE';
   p_old := :OLD.course_end_date;
   p_new := :NEW.course_end_date;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'HELP_WITH_FEES';
   p_old := :OLD.help_with_fees;
   p_new := :NEW.help_with_fees;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'HELP_AMOUNT';
   p_old := :OLD.help_amount;
   p_new := :NEW.help_amount;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'FEE_REQUESTED';
   p_old := :OLD.fee_requested;
   p_new := :NEW.fee_requested;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PROVIDER_SIGNATURE_PRESENT';
   p_old := :OLD.provider_signature_present;
   p_new := :NEW.provider_signature_present;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'ENDORSED_BY';
   p_old := :OLD.endorsed_by;
   p_new := :NEW.endorsed_by;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_ENDORSED';
   p_old := :OLD.date_endorsed;
   p_new := :NEW.date_endorsed;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'STAMPED';
   p_old := :OLD.stamped;
   p_new := :NEW.stamped;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LEARNER_SIGNATURE_PRESENT';
   p_old := :OLD.learner_signature_present;
   p_new := :NEW.learner_signature_present;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_SIGNED';
   p_old := :OLD.date_signed;
   p_new := :NEW.date_signed;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'FEE_PAID_BACS';
   p_old := :OLD.fee_paid_bacs;
   p_new := :NEW.fee_paid_bacs;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PAYMENT_DATE';
   p_old := :OLD.payment_date;
   p_new := :NEW.payment_date;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'RECOVER_FEES';
   p_old := :OLD.recover_fees;
   p_new := :NEW.recover_fees;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DEBT_STATUS';
   p_old := :OLD.debt_status;
   p_new := :NEW.debt_status;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'FEE_CALCULATED';
   p_old := :OLD.fee_calculated;
   p_new := :NEW.fee_calculated;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'COMMENTS_FOR_AWARD_LETTER';
   p_old := :OLD.comments_for_award_letter;
   p_new := :NEW.comments_for_award_letter;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'AWARD_LETTER_DUPLICATE';
   p_old := :OLD.award_letter_duplicate;
   p_new := :NEW.award_letter_duplicate;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NON_ATTENDANCE';
   p_old := :OLD.non_attendance;
   p_new := :NEW.non_attendance;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_WITHDRAWN';
   p_old := :OLD.date_withdrawn;
   p_new := :NEW.date_withdrawn;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DATE_ACTIONED';
   p_old := :OLD.date_actioned;
   p_new := :NEW.date_actioned;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END lea_app_iud;
/


DROP TRIGGER LEA_APP_LUB
/

--
-- LEA_APP_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER lea_app_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON LEARNER_APPLICATION    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   learner_application_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_application_aud.primary_key%TYPE   := :OLD.learner_application_id;
   p_old           learner_application_aud.OLD%TYPE           := NULL;
   p_new           learner_application_aud.NEW%TYPE           := NULL;
   p_action        learner_application_aud.action%TYPE        := NULL;
   p_username      learner_application_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.learner_application_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_lea_app_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END lea_app_lub;
/


DROP TRIGGER LEA_DUP_IUD
/

--
-- LEA_DUP_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER lea_dup_iud
   AFTER DELETE OR INSERT OR UPDATE OF learner_duplicate_id,
                                       learner_id,
                                       duplicate_system,
                                       duplicate_id,
                                       dsa_duplicate
   ON LEARNER_DUPLICATE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   learner_duplicate_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_duplicate_aud.primary_key%TYPE
                                                 := :OLD.learner_duplicate_id;
   p_old           learner_duplicate_aud.OLD%TYPE           := NULL;
   p_new           learner_duplicate_aud.NEW%TYPE           := NULL;
   p_action        learner_duplicate_aud.action%TYPE        := NULL;
   p_username      learner_duplicate_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.learner_duplicate_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'LEARNER_DUPLICATE_ID';
   p_old := :OLD.learner_duplicate_id;
   p_new := :NEW.learner_duplicate_id;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LEARNER_ID';
   p_old := :OLD.learner_id;
   p_new := :NEW.learner_id;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DUPLICATE_SYSTEM';
   p_old := :OLD.duplicate_system;
   p_new := :NEW.duplicate_system;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DUPLICATE_ID';
   p_old := :OLD.duplicate_id;
   p_new := :NEW.duplicate_id;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DSA_DUPLICATE';
   p_old := :OLD.dsa_duplicate;
   p_new := :NEW.dsa_duplicate;
   pk_pop_aud.ins_lea_dup_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END lea_dup_iud;
/


DROP TRIGGER LEA_IUD
/

--
-- LEA_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER lea_iud
   AFTER DELETE OR INSERT OR UPDATE OF learner_id,
                                       title_id,
                                       other_title,
                                       forename,
                                       surname,
                                       housename_no,
                                       address_line1,
                                       address_line2,
                                       address_line3,
                                       address_line4,
                                       postcode,
                                       dob,
                                       gender,
                                       telephone_no,
                                       email_address,
                                       lives_scotland_flag,
                                       lives_away_flag,
                                       deceased_flag,
                                       mail_returned_date,
                                       hold_payments,
                                       hold_letters,
                                       grass_checked,
                                       cases_grass_checked,
                                       steps_checked,
                                       cases_steps_checked,
                                       ila200_checked,
                                       cases_ila200_checked,
                                       ila500_checked,
                                       cases_ila500_checked,
                                       addr_mail_sort
   ON LEARNER    FOR EACH ROW
DECLARE
   p_aud_date      DATE                           := SYSDATE;
   p_column_name   learner_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_aud.primary_key%TYPE   := :OLD.learner_id;
   p_old           learner_aud.OLD%TYPE           := NULL;
   p_new           learner_aud.NEW%TYPE           := NULL;
   p_action        learner_aud.action%TYPE        := NULL;
   p_username      learner_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.learner_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'LEARNER_ID';
   p_old := :OLD.learner_id;
   p_new := :NEW.learner_id;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'TITLE_ID';
   p_old := :OLD.title_id;
   p_new := :NEW.title_id;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'OTHER_TITLE';
   p_old := :OLD.other_title;
   p_new := :NEW.other_title;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'FORENAME';
   p_old := :OLD.forename;
   p_new := :NEW.forename;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'SURNAME';
   p_old := :OLD.surname;
   p_new := :NEW.surname;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'HOUSENAME_NO';
   p_old := :OLD.housename_no;
   p_new := :NEW.housename_no;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'ADDRESS_LINE1';
   p_old := :OLD.address_line1;
   p_new := :NEW.address_line1;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'ADDRESS_LINE2';
   p_old := :OLD.address_line2;
   p_new := :NEW.address_line2;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'ADDRESS_LINE3';
   p_old := :OLD.address_line3;
   p_new := :NEW.address_line3;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'ADDRESS_LINE4';
   p_old := :OLD.address_line4;
   p_new := :NEW.address_line4;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'POSTCODE';
   p_old := :OLD.postcode;
   p_new := :NEW.postcode;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'DOB';
   p_old := :OLD.dob;
   p_new := :NEW.dob;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'GENDER';
   p_old := :OLD.gender;
   p_new := :NEW.gender;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'TELEPHONE_NO';
   p_old := :OLD.telephone_no;
   p_new := :NEW.telephone_no;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'EMAIL_ADDRESS';
   p_old := :OLD.email_address;
   p_new := :NEW.email_address;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'LIVES_SCOTLAND_FLAG';
   p_old := :OLD.lives_scotland_flag;
   p_new := :NEW.lives_scotland_flag;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'LIVES_AWAY_FLAG';
   p_old := :OLD.lives_away_flag;
   p_new := :NEW.lives_away_flag;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'DECEASED_FLAG';
   p_old := :OLD.deceased_flag;
   p_new := :NEW.deceased_flag;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'MAIL_RETURNED_DATE';
   p_old := :OLD.mail_returned_date;
   p_new := :NEW.mail_returned_date;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'HOLD_PAYMENTS';
   p_old := :OLD.hold_payments;
   p_new := :NEW.hold_payments;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'HOLD_LETTERS';
   p_old := :OLD.hold_letters;
   p_new := :NEW.hold_letters;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'GRASS_CHECKED';
   p_old := :OLD.grass_checked;
   p_new := :NEW.grass_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'CASES_GRASS_CHECKED';
   p_old := :OLD.cases_grass_checked;
   p_new := :NEW.cases_grass_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'STEPS_CHECKED';
   p_old := :OLD.steps_checked;
   p_new := :NEW.steps_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'CASES_STEPS_CHECKED';
   p_old := :OLD.cases_steps_checked;
   p_new := :NEW.cases_steps_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'ILA200_CHECKED';
   p_old := :OLD.ila200_checked;
   p_new := :NEW.ila200_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'CASES_ILA200_CHECKED';
   p_old := :OLD.cases_ila200_checked;
   p_new := :NEW.cases_ila200_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'ILA500_CHECKED';
   p_old := :OLD.ila500_checked;
   p_new := :NEW.ila500_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'CASES_ILA500_CHECKED';
   p_old := :OLD.cases_ila500_checked;
   p_new := :NEW.cases_ila500_checked;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
   p_column_name := 'ADDR_MAIL_SORT';
   p_old := :OLD.addr_mail_sort;
   p_new := :NEW.addr_mail_sort;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                           p_column_name,
                           p_primary_key,
                           p_old,
                           p_new,
                           p_action,
                           p_username
                          );
END lea_iud;
/


DROP TRIGGER LEA_LUB
/

--
-- LEA_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER lea_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON LEARNER    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   learner_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_aud.primary_key%TYPE   := :OLD.learner_id;
   p_old           learner_aud.OLD%TYPE           := NULL;
   p_new           learner_aud.NEW%TYPE           := NULL;
   p_action        learner_aud.action%TYPE        := NULL;
   p_username      learner_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.learner_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_lea_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END lea_lub;
/


DROP TRIGGER LEA_PAY_IUD
/

--
-- LEA_PAY_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER lea_pay_iud
   AFTER DELETE OR INSERT OR UPDATE OF learner_payment_id,
                                       learner_application_id,
                                       provider_payment_id,
                                       transaction_type_id,
                                       payment_status_id,
                                       amount
   ON LEARNER_PAYMENT    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                   := SYSDATE;
   p_column_name   learner_payment_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_payment_aud.primary_key%TYPE
                                                   := :OLD.learner_payment_id;
   p_old           learner_payment_aud.OLD%TYPE           := NULL;
   p_new           learner_payment_aud.NEW%TYPE           := NULL;
   p_action        learner_payment_aud.action%TYPE        := NULL;
   p_username      learner_payment_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.learner_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'LEARNER_PAYMENT_ID';
   p_old := :OLD.learner_payment_id;
   p_new := :NEW.learner_payment_id;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LEARNER_APPLICATION_ID';
   p_old := :OLD.learner_application_id;
   p_new := :NEW.learner_application_id;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PROVIDER_PAYMENT_ID';
   p_old := :OLD.provider_payment_id;
   p_new := :NEW.provider_payment_id;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'TRANSACTION_TYPE_ID';
   p_old := :OLD.transaction_type_id;
   p_new := :NEW.transaction_type_id;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PAYMENT_STATUS_ID';
   p_old := :OLD.payment_status_id;
   p_new := :NEW.payment_status_id;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'AMOUNT';
   p_old := :OLD.amount;
   p_new := :NEW.amount;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END lea_pay_iud;
/


DROP TRIGGER LEA_PAY_LUB
/

--
-- LEA_PAY_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER lea_pay_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON LEARNER_PAYMENT    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   learner_payment_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_payment_aud.primary_key%TYPE   := :OLD.learner_payment_id;
   p_old           learner_payment_aud.OLD%TYPE           := NULL;
   p_new           learner_payment_aud.NEW%TYPE           := NULL;
   p_action        learner_payment_aud.action%TYPE        := NULL;
   p_username      learner_payment_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.learner_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_lea_pay_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END lea_pay_lub;
/


DROP TRIGGER NOTE_TYPE_IUD
/

--
-- NOTE_TYPE_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER note_type_iud
   AFTER DELETE OR INSERT OR UPDATE OF note_type_id, description
   ON NOTE_TYPE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                             := SYSDATE;
   p_column_name   note_type_aud.column_name%TYPE   := NULL;
   p_primary_key   note_type_aud.primary_key%TYPE   := :OLD.note_type_id;
   p_old           note_type_aud.OLD%TYPE           := NULL;
   p_new           note_type_aud.NEW%TYPE           := NULL;
   p_action        note_type_aud.action%TYPE        := NULL;
   p_username      note_type_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.note_type_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'NOTE_TYPE_ID';
   p_old := :OLD.note_type_id;
   p_new := :NEW.note_type_id;
   pk_pop_aud.ins_note_type_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'DESCRIPTION';
   p_old := :OLD.description;
   p_new := :NEW.description;
   pk_pop_aud.ins_note_type_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END note_type_iud;
/


DROP TRIGGER NOTE_TYPE_LUB
/

--
-- NOTE_TYPE_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER note_type_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON NOTE_TYPE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   note_type_aud.column_name%TYPE   := NULL;
   p_primary_key   note_type_aud.primary_key%TYPE   := :OLD.note_type_id;
   p_old           note_type_aud.OLD%TYPE           := NULL;
   p_new           note_type_aud.NEW%TYPE           := NULL;
   p_action        note_type_aud.action%TYPE        := NULL;
   p_username      note_type_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.note_type_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_note_type_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END note_type_lub;
/


DROP TRIGGER PAY_STAT_IUD
/

--
-- PAY_STAT_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER pay_stat_iud
   AFTER DELETE OR INSERT OR UPDATE OF payment_status_id, payment_desc
   ON PAYMENT_STATUS    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                  := SYSDATE;
   p_column_name   payment_status_aud.column_name%TYPE   := NULL;
   p_primary_key   payment_status_aud.primary_key%TYPE
                                                    := :OLD.payment_status_id;
   p_old           payment_status_aud.OLD%TYPE           := NULL;
   p_new           payment_status_aud.NEW%TYPE           := NULL;
   p_action        payment_status_aud.action%TYPE        := NULL;
   p_username      payment_status_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.payment_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'PAYMENT_STATUS_ID';
   p_old := :OLD.payment_status_id;
   p_new := :NEW.payment_status_id;
   pk_pop_aud.ins_pay_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'PAYMENT_DESC';
   p_old := :OLD.payment_desc;
   p_new := :NEW.payment_desc;
   pk_pop_aud.ins_pay_stat_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END pay_stat_iud;
/


DROP TRIGGER PAY_STAT_LUB
/

--
-- PAY_STAT_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER pay_stat_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON PAYMENT_STATUS    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   payment_status_aud.column_name%TYPE   := NULL;
   p_primary_key   payment_status_aud.primary_key%TYPE   := :OLD.payment_status_id;
   p_old           payment_status_aud.OLD%TYPE           := NULL;
   p_new           payment_status_aud.NEW%TYPE           := NULL;
   p_action        payment_status_aud.action%TYPE        := NULL;
   p_username      payment_status_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.payment_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_pay_stat_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END pay_stat_lub;
/


DROP TRIGGER PROV_IUD
/

--
-- PROV_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER prov_iud
   AFTER DELETE OR INSERT OR UPDATE OF provider_id,
                                       provider_name,
                                       provider_house_no_or_name,
                                       provider_addr_l1,
                                       provider_addr_l2,
                                       provider_addr_l3,
                                       provider_addr_l4,
                                       provider_post_code,
                                       provider_tel_no,
                                       provider_fax_no,
                                       bank_sort_code,
                                       bank_account_no,
                                       main_contact_name,
                                       main_contact_position,
                                       main_contact_house_no_or_name,
                                       main_contact_addr_l1,
                                       main_contact_addr_l2,
                                       main_contact_addr_l3,
                                       main_contact_addr_l4,
                                       main_contact_post_code,
                                       main_contact_tel_no,
                                       main_contact_fax_no,
                                       main_contact_email,
                                       fin_contact_name,
                                       fin_contact_position,
                                       fin_contact_house_no_or_name,
                                       fin_contact_addr_l1,
                                       fin_contact_addr_l2,
                                       fin_contact_addr_l3,
                                       fin_contact_addr_l4,
                                       fin_contact_post_code,
                                       fin_contact_tel_no,
                                       fin_contact_fax_no,
                                       fin_contact_email,
                                       suspend_payments,
                                       suspend_letters,
                                       prov_type_id,
                                       prov_status_id,
                                       outstanding_amount
   ON PROVIDER    FOR EACH ROW
DECLARE
   p_aud_date      DATE                            := SYSDATE;
   p_column_name   provider_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_aud.primary_key%TYPE   := :OLD.provider_id;
   p_old           provider_aud.OLD%TYPE           := NULL;
   p_new           provider_aud.NEW%TYPE           := NULL;
   p_action        provider_aud.action%TYPE        := NULL;
   p_username      provider_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.provider_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'PROVIDER_ID';
   p_old := :OLD.provider_id;
   p_new := :NEW.provider_id;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_NAME';
   p_old := :OLD.provider_name;
   p_new := :NEW.provider_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_HOUSE_NO_OR_NAME';
   p_old := :OLD.provider_house_no_or_name;
   p_new := :NEW.provider_house_no_or_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_ADDR_L1';
   p_old := :OLD.provider_addr_l1;
   p_new := :NEW.provider_addr_l1;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_ADDR_L2';
   p_old := :OLD.provider_addr_l2;
   p_new := :NEW.provider_addr_l2;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_ADDR_L3';
   p_old := :OLD.provider_addr_l3;
   p_new := :NEW.provider_addr_l3;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_ADDR_L4';
   p_old := :OLD.provider_addr_l4;
   p_new := :NEW.provider_addr_l4;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_POST_CODE';
   p_old := :OLD.provider_post_code;
   p_new := :NEW.provider_post_code;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_TEL_NO';
   p_old := :OLD.provider_tel_no;
   p_new := :NEW.provider_tel_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROVIDER_FAX_NO';
   p_old := :OLD.provider_fax_no;
   p_new := :NEW.provider_fax_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'BANK_SORT_CODE';
   p_old := :OLD.bank_sort_code;
   p_new := :NEW.bank_sort_code;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'BANK_ACCOUNT_NO';
   p_old := :OLD.bank_account_no;
   p_new := :NEW.bank_account_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_NAME';
   p_old := :OLD.main_contact_name;
   p_new := :NEW.main_contact_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_POSITION';
   p_old := :OLD.main_contact_position;
   p_new := :NEW.main_contact_position;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_HOUSE_NO_OR_NAME';
   p_old := :OLD.main_contact_house_no_or_name;
   p_new := :NEW.main_contact_house_no_or_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_ADDR_L1';
   p_old := :OLD.main_contact_addr_l1;
   p_new := :NEW.main_contact_addr_l1;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_ADDR_L2';
   p_old := :OLD.main_contact_addr_l2;
   p_new := :NEW.main_contact_addr_l2;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_ADDR_L3';
   p_old := :OLD.main_contact_addr_l3;
   p_new := :NEW.main_contact_addr_l3;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_ADDR_L4';
   p_old := :OLD.main_contact_addr_l4;
   p_new := :NEW.main_contact_addr_l4;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_POST_CODE';
   p_old := :OLD.main_contact_post_code;
   p_new := :NEW.main_contact_post_code;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_TEL_NO';
   p_old := :OLD.main_contact_tel_no;
   p_new := :NEW.main_contact_tel_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_FAX_NO';
   p_old := :OLD.main_contact_fax_no;
   p_new := :NEW.main_contact_fax_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAIN_CONTACT_EMAIL';
   p_old := :OLD.main_contact_email;
   p_new := :NEW.main_contact_email;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_NAME';
   p_old := :OLD.fin_contact_name;
   p_new := :NEW.fin_contact_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_POSITION';
   p_old := :OLD.fin_contact_position;
   p_new := :NEW.fin_contact_position;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_HOUSE_NO_OR_NAME';
   p_old := :OLD.fin_contact_house_no_or_name;
   p_new := :NEW.fin_contact_house_no_or_name;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_ADDR_L1';
   p_old := :OLD.fin_contact_addr_l1;
   p_new := :NEW.fin_contact_addr_l1;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_ADDR_L2';
   p_old := :OLD.fin_contact_addr_l2;
   p_new := :NEW.fin_contact_addr_l2;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_ADDR_L3';
   p_old := :OLD.fin_contact_addr_l3;
   p_new := :NEW.fin_contact_addr_l3;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_ADDR_L4';
   p_old := :OLD.fin_contact_addr_l4;
   p_new := :NEW.fin_contact_addr_l4;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_POST_CODE';
   p_old := :OLD.fin_contact_post_code;
   p_new := :NEW.fin_contact_post_code;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_TEL_NO';
   p_old := :OLD.fin_contact_tel_no;
   p_new := :NEW.fin_contact_tel_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_FAX_NO';
   p_old := :OLD.fin_contact_fax_no;
   p_new := :NEW.fin_contact_fax_no;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FIN_CONTACT_EMAIL';
   p_old := :OLD.fin_contact_email;
   p_new := :NEW.fin_contact_email;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'SUSPEND_PAYMENTS';
   p_old := :OLD.suspend_payments;
   p_new := :NEW.suspend_payments;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'SUSPEND_LETTERS';
   p_old := :OLD.suspend_letters;
   p_new := :NEW.suspend_letters;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROV_TYPE_ID';
   p_old := :OLD.prov_type_id;
   p_new := :NEW.prov_type_id;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PROV_STATUS_ID';
   p_old := :OLD.prov_status_id;
   p_new := :NEW.prov_status_id;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'OUTSTANDING_AMOUNT';
   p_old := :OLD.outstanding_amount;
   p_new := :NEW.outstanding_amount;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
END prov_iud;
/


DROP TRIGGER PROV_LUB
/

--
-- PROV_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER prov_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON PROVIDER    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   provider_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_aud.primary_key%TYPE   := :OLD.provider_id;
   p_old           provider_aud.OLD%TYPE           := NULL;
   p_new           provider_aud.NEW%TYPE           := NULL;
   p_action        provider_aud.action%TYPE        := NULL;
   p_username      provider_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.provider_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_prov_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END prov_lub;
/


DROP TRIGGER PROV_PAY_IUD
/

--
-- PROV_PAY_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER prov_pay_iud
   AFTER DELETE OR INSERT OR UPDATE OF provider_payment_id,
                                       provider_id,
                                       bacs_run_id,
                                       adi_payment_id,
                                       payment_status_id,
                                       total_amount,
                                       debits_amount,
                                       credits_amount,
                                       prov_bal_amount
   ON PROVIDER_PAYMENT    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                    := SYSDATE;
   p_column_name   provider_payment_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_payment_aud.primary_key%TYPE
                                                  := :OLD.provider_payment_id;
   p_old           provider_payment_aud.OLD%TYPE           := NULL;
   p_new           provider_payment_aud.NEW%TYPE           := NULL;
   p_action        provider_payment_aud.action%TYPE        := NULL;
   p_username      provider_payment_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.provider_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'PROVIDER_PAYMENT_ID';
   p_old := :OLD.provider_payment_id;
   p_new := :NEW.provider_payment_id;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'PROVIDER_ID';
   p_old := :OLD.provider_id;
   p_new := :NEW.provider_id;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'BACS_RUN_ID';
   p_old := :OLD.bacs_run_id;
   p_new := :NEW.bacs_run_id;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'ADI_PAYMENT_ID';
   p_old := :OLD.adi_payment_id;
   p_new := :NEW.adi_payment_id;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'PAYMENT_STATUS_ID';
   p_old := :OLD.payment_status_id;
   p_new := :NEW.payment_status_id;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'TOTAL_AMOUNT';
   p_old := :OLD.total_amount;
   p_new := :NEW.total_amount;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'DEBITS_AMOUNT';
   p_old := :OLD.debits_amount;
   p_new := :NEW.debits_amount;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'CREDITS_AMOUNT';
   p_old := :OLD.credits_amount;
   p_new := :NEW.credits_amount;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'PROV_BAL_AMOUNT';
   p_old := :OLD.prov_bal_amount;
   p_new := :NEW.prov_bal_amount;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END prov_pay_iud;
/


DROP TRIGGER PROV_PAY_LUB
/

--
-- PROV_PAY_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER prov_pay_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON PROVIDER_PAYMENT    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                    := SYSDATE;
   p_column_name   provider_payment_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_payment_aud.primary_key%TYPE
                                                  := :OLD.provider_payment_id;
   p_old           provider_payment_aud.OLD%TYPE           := NULL;
   p_new           provider_payment_aud.NEW%TYPE           := NULL;
   p_action        provider_payment_aud.action%TYPE        := NULL;
   p_username      provider_payment_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.provider_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_prov_pay_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END prov_pay_lub;
/


DROP TRIGGER PROV_STAT_IUD
/

--
-- PROV_STAT_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER prov_stat_iud
   AFTER DELETE OR INSERT OR UPDATE OF prov_status_id, prov_status_desc
   ON PROVIDER_STATUS    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                   := SYSDATE;
   p_column_name   provider_status_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_status_aud.primary_key%TYPE
                                                       := :OLD.prov_status_id;
   p_old           provider_status_aud.OLD%TYPE           := NULL;
   p_new           provider_status_aud.NEW%TYPE           := NULL;
   p_action        provider_status_aud.action%TYPE        := NULL;
   p_username      provider_status_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.prov_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'PROV_STATUS_ID';
   p_old := :OLD.prov_status_id;
   p_new := :NEW.prov_status_id;
   pk_pop_aud.ins_prov_stat_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'PROV_STATUS_DESC';
   p_old := :OLD.prov_status_desc;
   p_new := :NEW.prov_status_desc;
   pk_pop_aud.ins_prov_stat_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END prov_stat_iud;
/


DROP TRIGGER PROV_STAT_LUB
/

--
-- PROV_STAT_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER prov_stat_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON PROVIDER_STATUS    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   provider_status_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_status_aud.primary_key%TYPE   := :OLD.prov_status_id;
   p_old           provider_status_aud.OLD%TYPE           := NULL;
   p_new           provider_status_aud.NEW%TYPE           := NULL;
   p_action        provider_status_aud.action%TYPE        := NULL;
   p_username      provider_status_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.prov_status_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_prov_stat_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END prov_stat_lub;
/


DROP TRIGGER PROV_TYPE_IUD
/

--
-- PROV_TYPE_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER prov_type_iud
   AFTER DELETE OR INSERT OR UPDATE OF prov_type_id, prov_type_desc
   ON PROVIDER_TYPE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                 := SYSDATE;
   p_column_name   provider_type_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_type_aud.primary_key%TYPE   := :OLD.prov_type_id;
   p_old           provider_type_aud.OLD%TYPE           := NULL;
   p_new           provider_type_aud.NEW%TYPE           := NULL;
   p_action        provider_type_aud.action%TYPE        := NULL;
   p_username      provider_type_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.prov_type_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'PROV_TYPE_ID';
   p_old := :OLD.prov_type_id;
   p_new := :NEW.prov_type_id;
   pk_pop_aud.ins_prov_type_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'PROV_TYPE_DESC';
   p_old := :OLD.prov_type_desc;
   p_new := :NEW.prov_type_desc;
   pk_pop_aud.ins_prov_type_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END prov_type_iud;
/


DROP TRIGGER PROV_TYPE_LUB
/

--
-- PROV_TYPE_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER prov_type_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON PROVIDER_TYPE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   provider_type_aud.column_name%TYPE   := NULL;
   p_primary_key   provider_type_aud.primary_key%TYPE   := :OLD.prov_type_id;
   p_old           provider_type_aud.OLD%TYPE           := NULL;
   p_new           provider_type_aud.NEW%TYPE           := NULL;
   p_action        provider_type_aud.action%TYPE        := NULL;
   p_username      provider_type_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.prov_type_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_prov_type_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END prov_type_lub;
/


DROP TRIGGER QA_DATA_IUD
/

--
-- QA_DATA_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER qa_data_iud
   AFTER DELETE OR INSERT OR UPDATE OF username,
                                       qa_type,
                                       qa_level,
                                       no_processed,
                                       no_qa,
                                       no_fail_qa
   ON ILA500_QA_DATA    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                  := SYSDATE;
   p_column_name   ila500_qa_data_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_qa_data_aud.primary_key%TYPE   := :OLD.username;
   p_old           ila500_qa_data_aud.OLD%TYPE           := NULL;
   p_new           ila500_qa_data_aud.NEW%TYPE           := NULL;
   p_action        ila500_qa_data_aud.action%TYPE        := NULL;
   p_username      ila500_qa_data_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.username;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'USERNAME';
   p_old := :OLD.username;
   p_new := :NEW.username;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'QA_TYPE';
   p_old := :OLD.qa_type;
   p_new := :NEW.qa_type;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'QA_LEVEL';
   p_old := :OLD.qa_level;
   p_new := :NEW.qa_level;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NO_PROCESSED';
   p_old := :OLD.no_processed;
   p_new := :NEW.no_processed;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NO_QA';
   p_old := :OLD.no_qa;
   p_new := :NEW.no_qa;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'NO_FAIL_QA';
   p_old := :OLD.no_fail_qa;
   p_new := :NEW.no_fail_qa;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END qa_data_iud;
/


DROP TRIGGER QA_DATA_LUB
/

--
-- QA_DATA_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER qa_data_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ILA500_QA_DATA    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   ila500_qa_data_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_qa_data_aud.primary_key%TYPE   := :OLD.username;
   p_old           ila500_qa_data_aud.OLD%TYPE           := NULL;
   p_new           ila500_qa_data_aud.NEW%TYPE           := NULL;
   p_action        ila500_qa_data_aud.action%TYPE        := NULL;
   p_username      ila500_qa_data_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.username;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_qa_data_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END qa_data_lub;
/


DROP TRIGGER REP_HIST_IUD
/

--
-- REP_HIST_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER rep_hist_iud
   AFTER DELETE OR INSERT OR UPDATE OF rep_hist_id,
                                       provider_id,
                                       report_type,
                                       date_of_report
   ON REPORT_HISTORY    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                  := SYSDATE;
   p_column_name   report_history_aud.column_name%TYPE   := NULL;
   p_primary_key   report_history_aud.primary_key%TYPE   := :OLD.rep_hist_id;
   p_old           report_history_aud.OLD%TYPE           := NULL;
   p_new           report_history_aud.NEW%TYPE           := NULL;
   p_action        report_history_aud.action%TYPE        := NULL;
   p_username      report_history_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.rep_hist_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'REP_HIST_ID';
   p_old := :OLD.rep_hist_id;
   p_new := :NEW.rep_hist_id;
   pk_pop_aud.ins_rep_hist_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'PROVIDER_ID';
   p_old := :OLD.provider_id;
   p_new := :NEW.provider_id;
   pk_pop_aud.ins_rep_hist_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'REPORT_TYPE';
   p_old := :OLD.report_type;
   p_new := :NEW.report_type;
   pk_pop_aud.ins_rep_hist_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
   p_column_name := 'DATE_OF_REPORT';
   p_old := :OLD.date_of_report;
   p_new := :NEW.date_of_report;
   pk_pop_aud.ins_rep_hist_aud (p_aud_date,
                                p_column_name,
                                p_primary_key,
                                p_old,
                                p_new,
                                p_action,
                                p_username
                               );
END rep_hist_iud;
/


DROP TRIGGER REP_HIST_LUB
/

--
-- REP_HIST_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER rep_hist_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON REPORT_HISTORY    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                  := SYSDATE;
   p_column_name   report_history_aud.column_name%TYPE   := NULL;
   p_primary_key   report_history_aud.primary_key%TYPE   := :OLD.rep_hist_id;
   p_old           report_history_aud.OLD%TYPE           := NULL;
   p_new           report_history_aud.NEW%TYPE           := NULL;
   p_action        report_history_aud.action%TYPE        := NULL;
   p_username      report_history_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.rep_hist_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_rep_hist_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END rep_hist_lub;
/


DROP TRIGGER RULE_IUD
/

--
-- RULE_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER rule_iud
   AFTER DELETE OR INSERT OR UPDATE OF rule_id,
                                       rule_type,
                                       rule_value,
                                       rule_status
   ON ILA500_RULE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                               := SYSDATE;
   p_column_name   ila500_rule_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_rule_aud.primary_key%TYPE   := :OLD.rule_id;
   p_old           ila500_rule_aud.OLD%TYPE           := NULL;
   p_new           ila500_rule_aud.NEW%TYPE           := NULL;
   p_action        ila500_rule_aud.action%TYPE        := NULL;
   p_username      ila500_rule_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.rule_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'RULE_ID';
   p_old := :OLD.rule_id;
   p_new := :NEW.rule_id;
   pk_pop_aud.ins_rule_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'RULE_TYPE';
   p_old := :OLD.rule_type;
   p_new := :NEW.rule_type;
   pk_pop_aud.ins_rule_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'RULE_VALUE';
   p_old := :OLD.rule_value;
   p_new := :NEW.rule_value;
   pk_pop_aud.ins_rule_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'RULE_STATUS';
   p_old := :OLD.rule_status;
   p_new := :NEW.rule_status;
   pk_pop_aud.ins_rule_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
END rule_iud;
/


DROP TRIGGER RULE_LUB
/

--
-- RULE_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER rule_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ILA500_RULE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                := SYSDATE;
   p_column_name   ila500_rule_aud.column_name%TYPE   := NULL;
   p_primary_key   ila500_rule_aud.primary_key%TYPE   := :OLD.rule_id;
   p_old           ila500_rule_aud.OLD%TYPE           := NULL;
   p_new           ila500_rule_aud.NEW%TYPE           := NULL;
   p_action        ila500_rule_aud.action%TYPE        := NULL;
   p_username      ila500_rule_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.rule_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_rule_aud (p_aud_date,
                            p_column_name,
                            p_primary_key,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
END rule_lub;
/


DROP TRIGGER SHELL_LTR_IUD
/

--
-- SHELL_LTR_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER shell_ltr_iud
   AFTER DELETE OR INSERT OR UPDATE OF doc_id, doc_name, doc_desc
   ON SHELL_LETTER    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                := SYSDATE;
   p_column_name   shell_letter_aud.column_name%TYPE   := NULL;
   p_primary_key   shell_letter_aud.primary_key%TYPE   := :OLD.doc_id;
   p_old           shell_letter_aud.OLD%TYPE           := NULL;
   p_new           shell_letter_aud.NEW%TYPE           := NULL;
   p_action        shell_letter_aud.action%TYPE        := NULL;
   p_username      shell_letter_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.doc_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'DOC_ID';
   p_old := :OLD.doc_id;
   p_new := :NEW.doc_id;
   pk_pop_aud.ins_shell_ltr_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'DOC_NAME';
   p_old := :OLD.doc_name;
   p_new := :NEW.doc_name;
   pk_pop_aud.ins_shell_ltr_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
   p_column_name := 'DOC_DESC';
   p_old := :OLD.doc_desc;
   p_new := :NEW.doc_desc;
   pk_pop_aud.ins_shell_ltr_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END shell_ltr_iud;
/


DROP TRIGGER SHELL_LTR_LUB
/

--
-- SHELL_LTR_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER shell_ltr_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON SHELL_LETTER    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                := SYSDATE;
   p_column_name   shell_letter_aud.column_name%TYPE   := NULL;
   p_primary_key   shell_letter_aud.primary_key%TYPE   := :OLD.doc_id;
   p_old           shell_letter_aud.OLD%TYPE           := NULL;
   p_new           shell_letter_aud.NEW%TYPE           := NULL;
   p_action        shell_letter_aud.action%TYPE        := NULL;
   p_username      shell_letter_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.doc_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_shell_ltr_aud (p_aud_date,
                                 p_column_name,
                                 p_primary_key,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username
                                );
END shell_ltr_lub;
/


DROP TRIGGER TITLE_IUD
/

--
-- TITLE_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER title_iud
   AFTER DELETE OR INSERT OR UPDATE OF title_id, description
   ON TITLE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                         := SYSDATE;
   p_column_name   title_aud.column_name%TYPE   := NULL;
   p_primary_key   title_aud.primary_key%TYPE   := :OLD.title_id;
   p_old           title_aud.OLD%TYPE           := NULL;
   p_new           title_aud.NEW%TYPE           := NULL;
   p_action        title_aud.action%TYPE        := NULL;
   p_username      title_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.title_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'TITLE_ID';
   p_old := :OLD.title_id;
   p_new := :NEW.title_id;
   pk_pop_aud.ins_title_aud (p_aud_date,
                             p_column_name,
                             p_primary_key,
                             p_old,
                             p_new,
                             p_action,
                             p_username
                            );
   p_column_name := 'DESCRIPTION';
   p_old := :OLD.description;
   p_new := :NEW.description;
   pk_pop_aud.ins_title_aud (p_aud_date,
                             p_column_name,
                             p_primary_key,
                             p_old,
                             p_new,
                             p_action,
                             p_username
                            );
END title_iud;
/


DROP TRIGGER TITLE_LUB
/

--
-- TITLE_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER title_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON TITLE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                         := SYSDATE;
   p_column_name   title_aud.column_name%TYPE   := NULL;
   p_primary_key   title_aud.primary_key%TYPE   := :OLD.title_id;
   p_old           title_aud.OLD%TYPE           := NULL;
   p_new           title_aud.NEW%TYPE           := NULL;
   p_action        title_aud.action%TYPE        := NULL;
   p_username      title_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.title_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_title_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END title_lub;
/


DROP TRIGGER TRANS_TYPE_IUD
/

--
-- TRANS_TYPE_IUD  (Trigger) 
--
CREATE OR REPLACE TRIGGER trans_type_iud
   AFTER DELETE OR INSERT OR UPDATE OF transaction_type_id, description
   ON TRANSACTION_TYPE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                    := SYSDATE;
   p_column_name   transaction_type_aud.column_name%TYPE   := NULL;
   p_primary_key   transaction_type_aud.primary_key%TYPE
                                                  := :OLD.transaction_type_id;
   p_old           transaction_type_aud.OLD%TYPE           := NULL;
   p_new           transaction_type_aud.NEW%TYPE           := NULL;
   p_action        transaction_type_aud.action%TYPE        := NULL;
   p_username      transaction_type_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.transaction_type_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'TRANSACTION_TYPE_ID';
   p_old := :OLD.transaction_type_id;
   p_new := :NEW.transaction_type_id;
   pk_pop_aud.ins_trans_type_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'DESCRIPTION';
   p_old := :OLD.description;
   p_new := :NEW.description;
   pk_pop_aud.ins_trans_type_aud (p_aud_date,
                                  p_column_name,
                                  p_primary_key,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
END trans_type_iud;
/


DROP TRIGGER TRANS_TYPE_LUB
/

--
-- TRANS_TYPE_LUB  (Trigger) 
--
CREATE OR REPLACE TRIGGER trans_type_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON TRANSACTION_TYPE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                         := SYSDATE;
   p_column_name   transaction_type_aud.column_name%TYPE   := NULL;
   p_primary_key   transaction_type_aud.primary_key%TYPE   := :OLD.transaction_type_id;
   p_old           transaction_type_aud.OLD%TYPE           := NULL;
   p_new           transaction_type_aud.NEW%TYPE           := NULL;
   p_action        transaction_type_aud.action%TYPE        := NULL;
   p_username      transaction_type_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.transaction_type_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_trans_type_aud (p_aud_date,
                                    p_column_name,
                                    p_primary_key,
                                    p_old,
                                    p_new,
                                    p_action,
                                    p_username
                                   );
END trans_type_lub;
/


DROP TRIGGER TRIG_ADI_PAYMENT_SEQ
/

--
-- TRIG_ADI_PAYMENT_SEQ  (Trigger) 
--
CREATE OR REPLACE TRIGGER trig_adi_payment_seq BEFORE INSERT ON ADI_PAYMENT
FOR EACH ROW
BEGIN
SELECT adi_payment_id_seq.NEXTVAL into :new.adi_payment_id FROM dual;
END;
/


DROP TRIGGER TRIG_CASEWORKER_NOTE_SEQ
/

--
-- TRIG_CASEWORKER_NOTE_SEQ  (Trigger) 
--
CREATE OR REPLACE TRIGGER trig_caseworker_note_seq BEFORE INSERT ON caseworker_note
FOR EACH ROW
BEGIN
SELECT cw_note_id_seq.NEXTVAL into :new.cw_note_id FROM dual;
END;
/


DROP TRIGGER TRIG_COURSE_LEVEL_SEQ
/

--
-- TRIG_COURSE_LEVEL_SEQ  (Trigger) 
--
CREATE OR REPLACE TRIGGER trig_course_level_seq BEFORE INSERT ON COURSE_LEVEL
FOR EACH ROW
BEGIN
SELECT course_id_seq.NEXTVAL into :new.course_id FROM dual;
END;
/


DROP TRIGGER TRIG_COURSE_TYPE_SEQ
/

--
-- TRIG_COURSE_TYPE_SEQ  (Trigger) 
--
CREATE OR REPLACE TRIGGER trig_COURSE_TYPE_seq BEFORE INSERT ON COURSE_TYPE
FOR EACH ROW
BEGIN
SELECT course_type_id_seq.NEXTVAL into :new.course_type_id FROM dual;
END;
/


DROP TRIGGER TRIG_DOCUMENT_REGISTER_SEQ
/

--
-- TRIG_DOCUMENT_REGISTER_SEQ  (Trigger) 
--
CREATE OR REPLACE TRIGGER trig_document_register_seq BEFORE INSERT ON document_register
FOR EACH ROW
BEGIN
SELECT doc_reg_id_seq.NEXTVAL into :new.doc_reg_id FROM dual;
END;
/


DROP TRIGGER TRIG_LEARNER_APPLICATION_SEQ
/

--
-- TRIG_LEARNER_APPLICATION_SEQ  (Trigger) 
--
CREATE OR REPLACE TRIGGER trig_LEARNER_APPLICATION_seq BEFORE INSERT ON LEARNER_APPLICATION
FOR EACH ROW
BEGIN
SELECT LEARNER_APPLICATION_ID_seq.NEXTVAL into :new.LEARNER_APPLICATION_ID FROM dual;
END;
/


DROP TRIGGER TRIG_LEARNER_DOB
/

--
-- TRIG_LEARNER_DOB  (Trigger) 
--
CREATE OR REPLACE TRIGGER trig_LEARNER_DOB BEFORE INSERT ON LEARNER
FOR EACH ROW
BEGIN
SELECT TRUNC(:new.DOB) into :new.DOB FROM dual;
END;
/


DROP TRIGGER TRIG_LEARNER_DUPLICATE_SEQ
/

--
-- TRIG_LEARNER_DUPLICATE_SEQ  (Trigger) 
--
CREATE OR REPLACE TRIGGER trig_learner_duplicate_seq BEFORE INSERT ON learner_duplicate
FOR EACH ROW
BEGIN
SELECT learner_duplicate_id_seq.NEXTVAL into :new.learner_duplicate_id FROM dual;
END;
/


DROP TRIGGER TRIG_LEARNER_PAYMENT_SEQ
/

--
-- TRIG_LEARNER_PAYMENT_SEQ  (Trigger) 
--
CREATE OR REPLACE TRIGGER trig_learner_payment_seq BEFORE INSERT ON learner_payment
FOR EACH ROW
BEGIN
SELECT learner_payment_id_seq.NEXTVAL into :new.learner_payment_id FROM dual;
END;
/


DROP TRIGGER TRIG_PROVIDER_PAYMENT_SEQ
/

--
-- TRIG_PROVIDER_PAYMENT_SEQ  (Trigger) 
--
CREATE OR REPLACE TRIGGER trig_provider_payment_seq BEFORE INSERT ON provider_payment
FOR EACH ROW
BEGIN
SELECT provider_payment_id_seq.NEXTVAL into :new.provider_payment_id FROM dual;
END;
/

