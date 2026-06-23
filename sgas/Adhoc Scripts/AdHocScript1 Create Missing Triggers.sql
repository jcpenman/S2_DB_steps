CREATE OR REPLACE TRIGGER SGAS.oth_loa_type_iud
   AFTER INSERT OR DELETE OR UPDATE OF OTHER_LOAN_TYPE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.OTHER_LOAN_TYPE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    OTHER_LOAN_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    OTHER_LOAN_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.OTHER_LOAN_TYPE_id;
   p_table_pkey2    OTHER_LOAN_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    OTHER_LOAN_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    OTHER_LOAN_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    OTHER_LOAN_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            OTHER_LOAN_TYPE_aud.OLD%TYPE            := NULL;
   p_new            OTHER_LOAN_TYPE_aud.NEW%TYPE            := NULL;
   p_action         OTHER_LOAN_TYPE_aud.action%TYPE         := NULL;
   p_username       OTHER_LOAN_TYPE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    OTHER_LOAN_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      OTHER_LOAN_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   OTHER_LOAN_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.OTHER_LOAN_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.OTHER_LOAN_TYPE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'OTHER_LOAN_TYPE_ID';
   p_old := :OLD.OTHER_LOAN_TYPE_id;
   p_new := :NEW.OTHER_LOAN_TYPE_id;
   pk_steps_aud.ins_oth_loa_type_aud (p_aud_date,
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
   p_column_name := 'LEGACY_ID';
   p_old := TO_CHAR (:OLD.legacy_id);
   p_new := TO_CHAR (:NEW.legacy_id);
   pk_steps_aud.ins_oth_loa_type_aud (p_aud_date,
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
   p_column_name := 'LEGACY_CODE';
   p_old := TO_CHAR (:OLD.legacy_code);
   p_new := TO_CHAR (:NEW.legacy_code);
   pk_steps_aud.ins_oth_loa_type_aud (p_aud_date,
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
   p_column_name := 'DESCRIPT';
   p_old := TO_CHAR (:OLD.descript);
   p_new := TO_CHAR (:NEW.descript);
   pk_steps_aud.ins_oth_loa_type_aud (p_aud_date,
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
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.LAST_UPDATED_BY;
   p_new := :NEW.LAST_UPDATED_BY;
   pk_steps_aud.ins_oth_loa_type_aud (p_aud_date,
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
END oth_loa_type_iud;
/

CREATE OR REPLACE TRIGGER SGAS.fee_loa_type_iud
   AFTER INSERT OR DELETE OR UPDATE OF FEE_LOAN_TYPE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SGAS.FEE_LOAN_TYPE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    FEE_LOAN_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    FEE_LOAN_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.FEE_LOAN_TYPE_id;
   p_table_pkey2    FEE_LOAN_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    FEE_LOAN_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    FEE_LOAN_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    FEE_LOAN_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            FEE_LOAN_TYPE_aud.OLD%TYPE            := NULL;
   p_new            FEE_LOAN_TYPE_aud.NEW%TYPE            := NULL;
   p_action         FEE_LOAN_TYPE_aud.action%TYPE         := NULL;
   p_username       FEE_LOAN_TYPE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    FEE_LOAN_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      FEE_LOAN_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   FEE_LOAN_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.FEE_LOAN_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.FEE_LOAN_TYPE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'FEE_LOAN_TYPE_ID';
   p_old := :OLD.FEE_LOAN_TYPE_id;
   p_new := :NEW.FEE_LOAN_TYPE_id;
   pk_steps_aud.ins_fee_loa_type_aud (p_aud_date,
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
   p_column_name := 'LEGACY_ID';
   p_old := TO_CHAR (:OLD.legacy_id);
   p_new := TO_CHAR (:NEW.legacy_id);
   pk_steps_aud.ins_fee_loa_type_aud (p_aud_date,
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
   p_column_name := 'LEGACY_CODE';
   p_old := TO_CHAR (:OLD.legacy_code);
   p_new := TO_CHAR (:NEW.legacy_code);
   pk_steps_aud.ins_fee_loa_type_aud (p_aud_date,
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
   p_column_name := 'DESCRIPT';
   p_old := TO_CHAR (:OLD.descript);
   p_new := TO_CHAR (:NEW.descript);
   pk_steps_aud.ins_fee_loa_type_aud (p_aud_date,
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
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_fee_loa_type_aud (p_aud_date,
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
END fee_loa_type_iud;
/
