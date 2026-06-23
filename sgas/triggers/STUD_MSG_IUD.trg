DROP TRIGGER SGAS.STUD_MSG_IUD;

CREATE OR REPLACE TRIGGER SGAS.STUD_MSG_IUD
   AFTER INSERT OR DELETE OR UPDATE OF stud_ref_no,
                                       created_by,
                                       message_text,
                                       display_from,
                                       display_to,
                                       subject
   ON SGAS.STUD_MESSAGE    FOR EACH ROW
DECLARE
   p_aud_date      DATE                                   := SYSDATE;
   p_column_name   stud_message_aud.column_name%TYPE   := NULL;
   p_table_pkey1   stud_message_aud.table_pkey1%TYPE
                                                   := :OLD.stud_msg_id;
   p_old           stud_message_aud.OLD%TYPE         := NULL;
   p_new           stud_message_aud.NEW%TYPE         := NULL;
   p_action        stud_message_aud.action%TYPE      := NULL;
   p_username      stud_message_aud.username%TYPE
                                                      := :NEW.created_by;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_msg_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.stud_msg_id;
      p_username := :OLD.created_by;
   END IF;


   p_column_name := 'STUD_REF_NO';
   p_old := :OLD.stud_ref_no;
   p_new := :NEW.stud_ref_no;
   pk_steps_aud.ins_stud_msg_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'CREATED_BY';
   p_old := :OLD.created_by;
   p_new := :NEW.created_by;
   pk_steps_aud.ins_stud_msg_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'MESSAGE_TEXT';
   p_old := :OLD.message_text;
   p_new := :NEW.message_text;
   pk_steps_aud.ins_stud_msg_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'DISPLAY_FROM';
   p_old := :OLD.display_from;
   p_new := :NEW.display_from;
   pk_steps_aud.ins_stud_msg_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'DISPLAY_TO';
   p_old := :OLD.display_to;
   p_new := :NEW.display_to;
   pk_steps_aud.ins_stud_msg_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'SUBJECT';
   p_old := :OLD.subject;
   p_new := :NEW.subject;
   pk_steps_aud.ins_stud_msg_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
END STUD_MSG_IUD;
/
