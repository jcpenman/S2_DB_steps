/* Formatted on 2008/07/09 14:30 (Formatter Plus v4.8.8) */
-- TRIGGER: REP_HIST_IUD
-- TABLE: REPORT_HISTORY
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/REP_HIST_IUD.sql $ 
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.rep_hist_iud
   AFTER DELETE OR INSERT OR UPDATE OF rep_hist_id,
                                       provider_id,
                                       report_type,
                                       date_of_report
   ON ila500.report_history
   FOR EACH ROW
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