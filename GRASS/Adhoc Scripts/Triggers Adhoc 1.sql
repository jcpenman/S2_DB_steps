/* Formatted on 2011/03/08 11:33 (Formatter Plus v4.8.8) */
CREATE OR REPLACE TRIGGER sgas.instm_ud
   AFTER INSERT OR DELETE OR UPDATE OF inst_code,
                                       session_code,
                                       term_no,
                                       days,
                                       start_date,
                                       end_date
   ON sgas.inst_term
   FOR EACH ROW
DECLARE
   p_aud_date         DATE                      := SYSDATE;
   p_table_name       VARCHAR2 (32)             := 'INST_TERM';
   p_column_name      VARCHAR2 (32)             := NULL;
   p_table_pkey1      aud.table_pkey1%TYPE      := TO_CHAR (:OLD.inst_code);
   p_table_pkey2      aud.table_pkey1%TYPE     := TO_CHAR (:OLD.session_code);
   p_table_pkey3      aud.table_pkey2%TYPE      := TO_CHAR (:OLD.term_no);
   p_table_pkey4      aud.table_pkey4%TYPE      := NULL;
   p_table_pkey5      aud.table_pkey5%TYPE      := NULL;
   p_emp_login_name   aud.emp_login_name%TYPE   := USER;
   p_old              aud.OLD%TYPE              := NULL;
   p_action           aud.action%TYPE           := NULL;
   p_new              aud.NEW%TYPE              := NULL;
   p_stud_ref_no      aud.stud_ref_no%TYPE      := NULL;
   p_inst_code        aud.inst_code%TYPE        := NULL;
   p_session_code     aud.table_pkey1%TYPE     := TO_CHAR (:OLD.session_code);
   upd_steps          VARCHAR2 (1)              := 'N';
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := TO_CHAR (:NEW.inst_code);
      p_inst_code := TO_CHAR (:NEW.inst_code);
      p_session_code := TO_CHAR (:NEW.session_code);
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_inst_code := TO_CHAR (:OLD.inst_code);
      p_session_code := TO_CHAR (:OLD.session_code);
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_inst_code := TO_CHAR (:OLD.inst_code);
      p_session_code := TO_CHAR (:OLD.session_code);
   END IF;

   INSERT INTO inst_term_change@stepdev.world
               (inst_code, session_code, change_date
               )
        VALUES (p_inst_code, p_session_code, SYSDATE
               );

   p_inst_code := p_table_pkey1;
   p_column_name := 'DAYS';
   p_old := TO_CHAR (:OLD.days);
   p_new := TO_CHAR (:NEW.days);
   m202.insert_aud (p_aud_date,
                    NULL,
                    p_table_name,
                    p_column_name,
                    p_table_pkey1,
                    p_table_pkey2,
                    p_table_pkey3,
                    p_table_pkey4,
                    p_table_pkey5,
                    p_emp_login_name,
                    p_old,
                    p_action,
                    p_new,
                    p_stud_ref_no,
                    p_inst_code
                   );
   p_column_name := 'START_DATE';
   p_old := TO_CHAR (:OLD.start_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.start_date, 'DD/MM/YYYY HH24:MI');
   m202.insert_aud (p_aud_date,
                    NULL,
                    p_table_name,
                    p_column_name,
                    p_table_pkey1,
                    p_table_pkey2,
                    p_table_pkey3,
                    p_table_pkey4,
                    p_table_pkey5,
                    p_emp_login_name,
                    p_old,
                    p_action,
                    p_new,
                    p_stud_ref_no,
                    p_inst_code
                   );
   p_column_name := 'END_DATE';
   p_old := TO_CHAR (:OLD.end_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.end_date, 'DD/MM/YYYY HH24:MI');
   m202.insert_aud (p_aud_date,
                    NULL,
                    p_table_name,
                    p_column_name,
                    p_table_pkey1,
                    p_table_pkey2,
                    p_table_pkey3,
                    p_table_pkey4,
                    p_table_pkey5,
                    p_emp_login_name,
                    p_old,
                    p_action,
                    p_new,
                    p_stud_ref_no,
                    p_inst_code
                   );
END instm_ud;
show errors;

/* Formatted on 2011/03/08 10:32 (Formatter Plus v4.8.8) */
CREATE OR REPLACE TRIGGER sgas.crst_ud
   AFTER INSERT OR DELETE OR UPDATE OF crse_year_id,
                                       term_no,
                                       days,
                                       start_date,
                                       end_date
   ON sgas.crse_term
   FOR EACH ROW
DECLARE
   p_aud_date         DATE                      := SYSDATE;
   p_table_name       VARCHAR2 (32)             := 'CRSE_TERM';
   p_column_name      VARCHAR2 (32)             := NULL;
   p_table_pkey1      aud.table_pkey1%TYPE     := TO_CHAR (:OLD.crse_year_id);
   p_table_pkey2      aud.table_pkey2%TYPE      := TO_CHAR (:OLD.term_no);
   p_table_pkey3      aud.table_pkey3%TYPE      := NULL;
   p_table_pkey4      aud.table_pkey4%TYPE      := NULL;
   p_table_pkey5      aud.table_pkey5%TYPE      := NULL;
   p_emp_login_name   aud.emp_login_name%TYPE   := USER;
   p_old              aud.OLD%TYPE              := NULL;
   p_action           aud.action%TYPE           := NULL;
   p_new              aud.NEW%TYPE              := NULL;
   p_stud_ref_no      aud.stud_ref_no%TYPE      := NULL;
   p_inst_code        aud.inst_code%TYPE        := NULL;
   p_crse_year_id     aud.table_pkey1%TYPE      := NULL;
   upd_steps          VARCHAR2 (1)              := 'N';
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := TO_CHAR (:NEW.crse_year_id);
      p_crse_year_id := TO_CHAR (:NEW.crse_year_id);
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_crse_year_id := TO_CHAR (:OLD.crse_year_id);
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_crse_year_id := TO_CHAR (:OLD.crse_year_id);
   END IF;

   
   IF p_action in ('U','D')
   THEN
   SELECT inst_code
     INTO p_inst_code
     FROM crse_year
    WHERE crse_year_id = :OLD.crse_year_id;

   p_column_name := 'DAYS';
   p_old := TO_CHAR (:OLD.days);
   p_new := TO_CHAR (:NEW.days);
   m202.insert_aud (p_aud_date,
                    NULL,
                    p_table_name,
                    p_column_name,
                    p_table_pkey1,
                    p_table_pkey2,
                    p_table_pkey3,
                    p_table_pkey4,
                    p_table_pkey5,
                    p_emp_login_name,
                    p_old,
                    p_action,
                    p_new,
                    p_stud_ref_no,
                    p_inst_code
                   );
   p_column_name := 'START_DATE';
   p_old := TO_CHAR (:OLD.start_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.start_date, 'DD/MM/YYYY HH24:MI');
   m202.insert_aud (p_aud_date,
                    NULL,
                    p_table_name,
                    p_column_name,
                    p_table_pkey1,
                    p_table_pkey2,
                    p_table_pkey3,
                    p_table_pkey4,
                    p_table_pkey5,
                    p_emp_login_name,
                    p_old,
                    p_action,
                    p_new,
                    p_stud_ref_no,
                    p_inst_code
                   );
   p_column_name := 'END_DATE';
   p_old := TO_CHAR (:OLD.end_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.end_date, 'DD/MM/YYYY HH24:MI');
   m202.insert_aud (p_aud_date,
                    NULL,
                    p_table_name,
                    p_column_name,
                    p_table_pkey1,
                    p_table_pkey2,
                    p_table_pkey3,
                    p_table_pkey4,
                    p_table_pkey5,
                    p_emp_login_name,
                    p_old,
                    p_action,
                    p_new,
                    p_stud_ref_no,
                    p_inst_code
                   );
   END IF;
   
      INSERT INTO crse_term_change@stepdev.world
                           --- THIS WILL NEED TO BE CHANGED FOR SIT, LIVE etc
                  (crse_year_id, change_date
                  )
           VALUES (p_crse_year_id, SYSDATE
                  );
   
END crst_ud;
show errors;