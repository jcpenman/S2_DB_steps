CREATE OR REPLACE TRIGGER BEN_IUD
AFTER DELETE OR INSERT OR UPDATE
OF FORENAMES
  ,SURNAME
  ,HOUSE_NO_NAME
  ,ADDR_L1
  ,ADDR_L2
  ,ADDR_L3
  ,ADDR_L4
  ,POST_CODE
  ,BEN_NI_NO
  ,LAST_UPDATED_BY
  ,EMAIL_ADDR
ON SGAS.BENEFACTOR
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
   p_aud_date       DATE                               := SYSDATE;
   p_column_name    benefactor_aud.column_name%TYPE    := NULL;
   p_table_pkey1    benefactor_aud.table_pkey1%TYPE    := :OLD.ben_id;
   p_table_pkey2    benefactor_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    benefactor_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    benefactor_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    benefactor_aud.table_pkey5%TYPE    := NULL;
   p_old            benefactor_aud.OLD%TYPE            := NULL;
   p_new            benefactor_aud.NEW%TYPE            := NULL;
   p_action         benefactor_aud.action%TYPE         := NULL;
   p_username       benefactor_aud.username%TYPE       := :NEW.last_updated_by;
   p_stud_ref_no    benefactor_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      benefactor_aud.inst_code%TYPE      := NULL;
   p_session_code   benefactor_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.ben_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.ben_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'ADDR_L1';
   p_old := :OLD.addr_l1;
   p_new := :NEW.addr_l1;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_column_name := 'ADDR_L2';
   p_old := :OLD.addr_l2;
   p_new := :NEW.addr_l2;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_column_name := 'ADDR_L3';
   p_old := :OLD.addr_l3;
   p_new := :NEW.addr_l3;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_column_name := 'ADDR_L4';
   p_old := :OLD.addr_l4;
   p_new := :NEW.addr_l4;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_column_name := 'BEN_NI_NO';
   p_old := :OLD.ben_ni_no;
   p_new := :NEW.ben_ni_no;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_column_name := 'FORENAMES';
   p_old := :OLD.forenames;
   p_new := :NEW.forenames;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_column_name := 'HOUSE_NO_NAME';
   p_old := :OLD.house_no_name;
   p_new := :NEW.house_no_name;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_column_name := 'POST_CODE';
   p_old := :OLD.post_code;
   p_new := :NEW.post_code;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_column_name := 'SURNAME';
   p_old := :OLD.surname;
   p_new := :NEW.surname;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_column_name := 'EMAIL_ADDR';
   p_old := :OLD.email_addr;
   p_new := :NEW.email_addr;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
END ben_iud;
/