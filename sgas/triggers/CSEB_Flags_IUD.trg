CREATE OR REPLACE TRIGGER CSEB_Flags_IUD
   AFTER INSERT OR DELETE OR UPDATE OF STUD_REF_NO,
                                       CARE_EXP_FOSTER,
                                       CARE_EXP_RES,
                                       CARE_EXP_KINSHIP_LA,
                                       CARE_EXP_KINSHIP_NO_LA,
                                       CARE_EXP_HOME,
                                       CARE_EXP_OTHER,
                                       CARE_EXP_OTHER_DETAILS,
                                       CARE_EXP_START_AGE,
                                       CARE_EXP_END_AGE
   ON SGAS.CESB_FLAGS    FOR EACH ROW
DECLARE
   p_aud_date      DATE                             := SYSDATE;
   p_column_name   CESB_Flags_AUD.column_name%TYPE  := NULL;
   p_table_pkey1   CESB_Flags_AUD.table_pkey1%TYPE  := :OLD.stud_ref_no;
   p_old           CESB_Flags_AUD.OLD%TYPE          := NULL;
   p_new           CESB_Flags_AUD.NEW%TYPE          := NULL;
   p_action        CESB_Flags_AUD.action%TYPE       := NULL;
   p_username      CESB_Flags_AUD.username%TYPE     := :NEW.last_updated_by;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_ref_no;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.stud_ref_no;
      p_username := :OLD.last_updated_by;
   END IF;


   p_column_name := 'STUD_REF_NO';
   p_old := :OLD.stud_ref_no;
   p_new := :NEW.stud_ref_no;
   pk_steps_aud.ins_cesb_flags_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'CARE_EXP_FOSTER';
   p_old := :OLD.CARE_EXP_FOSTER;
   p_new := :NEW.CARE_EXP_FOSTER;
   pk_steps_aud.ins_cesb_flags_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'CARE_EXP_RES';
   p_old := :OLD.CARE_EXP_RES;
   p_new := :NEW.CARE_EXP_RES;
   pk_steps_aud.ins_cesb_flags_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'CARE_EXP_KINSHIP_LA';
   p_old := :OLD.CARE_EXP_KINSHIP_LA;
   p_new := :NEW.CARE_EXP_KINSHIP_LA;
   pk_steps_aud.ins_cesb_flags_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'CARE_EXP_KINSHIP_NO_LA';
   p_old := :OLD.CARE_EXP_KINSHIP_NO_LA;
   p_new := :NEW.CARE_EXP_KINSHIP_NO_LA;
   pk_steps_aud.ins_cesb_flags_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'CARE_EXP_HOME';
   p_old := :OLD.CARE_EXP_HOME;
   p_new := :NEW.CARE_EXP_HOME;
   pk_steps_aud.ins_cesb_flags_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
                                 
   p_column_name := 'CARE_EXP_OTHER';
   p_old := :OLD.CARE_EXP_OTHER;
   p_new := :NEW.CARE_EXP_OTHER;
   pk_steps_aud.ins_cesb_flags_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'CARE_EXP_OTHER_DETAILS';
   p_old := :OLD.CARE_EXP_OTHER_DETAILS;
   p_new := :NEW.CARE_EXP_OTHER_DETAILS;
   pk_steps_aud.ins_cesb_flags_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'CARE_EXP_START_AGE';
   p_old := :OLD.CARE_EXP_START_AGE;
   p_new := :NEW.CARE_EXP_START_AGE;
   pk_steps_aud.ins_cesb_flags_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'CARE_EXP_END_AGE';
   p_old := :OLD.CARE_EXP_END_AGE;
   p_new := :NEW.CARE_EXP_END_AGE;
   pk_steps_aud.ins_cesb_flags_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );                                                                                                                                    
END CSEB_Flags_IUD;
/

COMMIT;