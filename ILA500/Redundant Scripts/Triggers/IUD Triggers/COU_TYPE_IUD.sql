/* Formatted on 2008/07/09 15:24 (Formatter Plus v4.8.8) */
-- TRIGGER: COU_TYPE_IUD
-- TABLE: COURSE_TYPE
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/COU_TYPE_IUD.sql $
-- $Author: $
-- $Date: 2008-12-09 10:34:28 +0000 (Tue, 09 Dec 2008) $
-- $Revision: 1803 $ 
--
CREATE OR REPLACE TRIGGER ila500.cou_type_iud
   AFTER DELETE OR INSERT OR UPDATE OF course_type_id,
                                       bacs_payment_date,
                                       course_type_desc,
                                       fee_cut_off_date,
                                       fee_period_start,
                                       fee_period_end,
                                       submitted_date,
                                       batch_run_date
   ON ila500.course_type
   FOR EACH ROW
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