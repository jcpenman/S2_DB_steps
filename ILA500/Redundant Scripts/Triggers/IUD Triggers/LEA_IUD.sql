/* Formatted on 2008/10/20 15:43 (Formatter Plus v4.8.8) */
-- TRIGGER: LEA_IUD
-- TABLE: LEARNER
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      08.07.2008    A.Bowman (SAAS)         Initial Version.
-- 002      28.08.2008    A.Bowman (SAAS)         Additional Columns added
-- 003      28.08.2008    A.Bowman (SAAS)         Yet another additional column added
-- 004      16.10.2008    A.Bowman (SAAS)         Added Telephony functionality
-- 005      04.06.2009    A.Bowman (SAAS)         Telephony functionality removed, no longer required, surprise surprise
-- 
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Triggers/IUD%20Triggers/LEA_IUD.sql $
-- $Author: $
-- $Date: 2009-06-04 09:13:28 +0100 (Thu, 04 Jun 2009) $
-- $Revision: 3097 $
--
CREATE OR REPLACE TRIGGER ILA500.lea_iud
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
   ON ILA500.LEARNER    FOR EACH ROW
DECLARE
   p_aud_date      DATE                           := SYSDATE;
   p_column_name   learner_aud.column_name%TYPE   := NULL;
   p_primary_key   learner_aud.primary_key%TYPE   := :OLD.learner_id;
   p_old           learner_aud.OLD%TYPE           := NULL;
   p_new           learner_aud.NEW%TYPE           := NULL;
   p_action        learner_aud.action%TYPE        := NULL;
   p_username      learner_aud.username%TYPE      := USER;
   p_learner_id    learner.learner_id%TYPE   := :OLD.learner_id;
   p_table_name    VARCHAR2 (32)                  := 'LEARNER';
   v_updated       VARCHAR2 (1)                   := 'N';
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_learner_id := :OLD.learner_id;
      
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.learner_id;
      p_learner_id := :NEW.learner_id;
      
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_learner_id := :OLD.learner_id;
      
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