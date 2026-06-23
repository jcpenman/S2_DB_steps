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

   INSERT INTO inst_term_change@steps.world
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
/