/******************************************************************************
NAME: INSTM_UD       
PURPOSE: Trigger to meet audit requirements, plus new functionality for StEPS whereby
         any changes made to the INST_TERM table on GRASS are notified to StEPS so that
         any appropriate recalculation can be done.

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        15.03.2010  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/

CREATE OR REPLACE TRIGGER SGAS.instm_ud
   AFTER DELETE OR UPDATE OF term_no, days, start_date, end_date
   ON SGAS.INST_TERM    FOR EACH ROW
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
   upd_steps          VARCHAR2 (1)              := 'N';
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSE
      p_action := 'U';

      IF :OLD.term_no <> :NEW.term_no
      THEN
         upd_steps := 'Y';
      ELSIF :OLD.days <> :NEW.days
      THEN
         upd_steps := 'Y';
      ELSIF :OLD.start_date <> :NEW.start_date
      THEN
         upd_steps := 'Y';
      ELSIF :OLD.end_date <> :NEW.end_date
      THEN
         upd_steps := 'Y';
      END IF;

      IF upd_steps = 'Y'
      THEN
         INSERT INTO inst_term_change@stepssit.world --- THIS WILL NEED TO BE CHANGED FOR LIVE
                     (inst_code, session_code, change_date
                     )
              VALUES (:OLD.inst_code, :OLD.session_code, SYSDATE
                     );
      END IF;
   END IF;

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
/
SHOW ERRORS;

/******************************************************************************
NAME: CRST_UD       
PURPOSE: Trigger to meet audit requirements, plus new functionality for StEPS whereby
         any changes made to the CRSE_TERM table on GRASS are notified to StEPS so that
         any appropriate recalculation can be done.

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        15.03.2010  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/

CREATE OR REPLACE TRIGGER SGAS.crst_ud
   AFTER DELETE OR UPDATE OF term_no, days, start_date, end_date
   ON SGAS.CRSE_TERM    FOR EACH ROW
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
   upd_steps          VARCHAR2 (1)              := 'N';
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
   ELSE
      p_action := 'U';

      IF :OLD.term_no <> :NEW.term_no
      THEN
         upd_steps := 'Y';
      ELSIF :OLD.days <> :NEW.days
      THEN
         upd_steps := 'Y';
      ELSIF :OLD.start_date <> :NEW.start_date
      THEN
         upd_steps := 'Y';
      ELSIF :OLD.end_date <> :NEW.end_date
      THEN
         upd_steps := 'Y';
      END IF;

      IF upd_steps = 'Y'
      THEN
         INSERT INTO crse_term_change@stepdeve.world --- THIS WILL NEED TO BE CHANGED FOR SIT, LIVE etc
                     (crse_year_id, change_date
                     )
              VALUES (:OLD.crse_year_id, SYSDATE
                     );
      END IF;
   END IF;

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
END crst_ud;
/
SHOW ERRORS;