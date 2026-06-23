-- Create new IUD triggers
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      28.04.10    A.Bowman (SAAS)         Initial Version.
-- 1.1      13.05.10    A.Bowman (SAAS)         Updated with trigger changes
-- 
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 

--ADI_JOU_IUD
--AUTH_STUD_IUD
--AW_IUD
--AW_REF_DAT_IUD
--AWI_IUD
--BED_IUD
--BEI_IUD
--BEN_INC_STAT_IUD
--BEN_INC_TYPE_IUD
--BEN_IUD
--BEN_REL_IUD
--CASE_STAT_IUD
--CN_IUD
--CON_REL_IUD
--DEAR_STAT_IUD
--DEBT_STAT_IUD
--DIS_TYPE_IUD
--DSA_AC_IUD
--DSA_ALL_IUD
--DSA_APP_IUD
--DSA_CAT_IUD
--DSA_PAY_IUD
--DSA_PAY_STAT_IUD
--DSA_REF_IUD
--DSA_REJ_IUD
--DSA_STUD_TYPE_IUD
--DSA_TYPE_IUD
--DSA_WORK_TYPE_IUD
--DUP_BANK_REA_IUD
--EMP_STAT_IUD
--FEE_LOA_TYPE_IUD
--FIN_REV_JOU_IUD
--FPD_IUD
--JAC_IUD
--JOINT_APP_REL_IUD
--LOAN_STAT_IUD
--LOC_IUD
--MAR_STAT_IUD
--NAPD_IUD
--NO_NINO_REA_IUD
--NOM_IUD
--OTH_LOA_TYPE_IUD
--PAY_ERR_IUD
--PAY_INST_IUD
--PAY_IUD
--PAY_METH_IUD
--PAY_PAYMT_IUD
--PGCE_SUB_IUD
--RES_IUD
--RES_TYPE_IUD
--SC_BAT_IUD
--SCH_TYPE_IUD
--SPO_TYPE_IUD
--SQD_IUD
--ST_IUD
--STAPP_IUD
--STCY_IUD
--STD_IUD
--STHOME_IUD
--STS_IUD
--STT_IUD
--STUD_NOM_IUD
--SUPP_GRANT_REL_IUD
--TITLE_IUD
--Z_REF_STAT_IUD
--
CREATE OR REPLACE TRIGGER adi_jou_iud
   AFTER INSERT OR DELETE OR UPDATE OF  ADI_JOURNAL_LINE_ID,
                                        ADI_JOURNAL_ID,
                                        BATCH_REF,
                                        CREDIT_BATCH_REF,
                                        COST_CENTRE,
                                        ACCOUNT,
                                        AMOUNT,
                                        PROGRAMME,
                                        CURRENCY,
                                        ENTITY,
                                        PAYMENT_METHOD, 
                                        PROCESS_DATE,
                                        ADI_FILE_STATUS,
                                        LAST_UPDATED_BY         
ON ADI_JOURNAL FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    ADI_JOURNAL_aud.column_name%TYPE    := NULL;
   p_table_pkey1    ADI_JOURNAL_aud.table_pkey1%TYPE
                                               := :OLD.ADI_JOURNAL_LINE_ID;
   p_table_pkey2    ADI_JOURNAL_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    ADI_JOURNAL_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    ADI_JOURNAL_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    ADI_JOURNAL_aud.table_pkey5%TYPE    := NULL;
   p_old            ADI_JOURNAL_aud.OLD%TYPE            := NULL;
   p_new            ADI_JOURNAL_aud.NEW%TYPE            := NULL;
   p_action         ADI_JOURNAL_aud.action%TYPE         := NULL;
   p_username       ADI_JOURNAL_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    ADI_JOURNAL_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      ADI_JOURNAL_aud.inst_code%TYPE      := NULL;
   p_session_code   ADI_JOURNAL_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.ADI_JOURNAL_LINE_ID;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.ADI_JOURNAL_LINE_ID;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'ADI_JOURNAL_LINE_ID';
   p_old := :OLD.ADI_JOURNAL_LINE_ID;
   p_new := :NEW.ADI_JOURNAL_LINE_ID;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'ADI_JOURNAL_ID';
   p_old := :OLD.ADI_JOURNAL_ID;
   p_new := :NEW.ADI_JOURNAL_ID;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'BATCH_REF';
   p_old := :OLD.BATCH_REF;
   p_new := :NEW.BATCH_REF;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'CREDIT_BATCH_REF';
   p_old := :OLD.CREDIT_BATCH_REF;
   p_new := :NEW.CREDIT_BATCH_REF;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'COST_CENTRE';
   p_old := :OLD.COST_CENTRE;
   p_new := :NEW.COST_CENTRE;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'ACCOUNT';
   p_old := :OLD.ACCOUNT;
   p_new := :NEW.ACCOUNT;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'AMOUNT';
   p_old := :OLD.AMOUNT;
   p_new := :NEW.AMOUNT;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'PROGRAMME';
   p_old := :OLD.PROGRAMME;
   p_new := :NEW.PROGRAMME;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'CURRENCY';
   p_old := :OLD.CURRENCY;
   p_new := :NEW.CURRENCY;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'ENTITY';
   p_old := :OLD.ENTITY;
   p_new := :NEW.ENTITY;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_METHOD';
   p_old := :OLD.PAYMENT_METHOD;
   p_new := :NEW.PAYMENT_METHOD;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'PROCESS_DATE';
   p_old := :OLD.PROCESS_DATE;
   p_new := :NEW.PROCESS_DATE;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   p_column_name := 'ADI_FILE_STATUS';
   p_old := :OLD.ADI_FILE_STATUS;
   p_new := :NEW.ADI_FILE_STATUS;
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
   pk_steps_aud.ins_adi_jou_aud (p_aud_date,
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
END adi_jou_iud;
/



CREATE OR REPLACE TRIGGER auth_stud_iud
   AFTER INSERT OR DELETE OR UPDATE OF auth_stud_id,
                                       stud_ref_no,
                                       web_user_id,
                                       last_updated_by
   ON AUTHENTICATE_STUD    FOR EACH ROW
DECLARE
   p_aud_date       DATE                             := SYSDATE;
   p_column_name    AUTHENTICATE_STUD_AUD.column_name%TYPE    := NULL;
   p_table_pkey1    AUTHENTICATE_STUD_AUD.table_pkey1%TYPE
                                               := :OLD.auth_stud_id;
   p_table_pkey2    AUTHENTICATE_STUD_AUD.table_pkey2%TYPE    := NULL;
   p_table_pkey3    AUTHENTICATE_STUD_AUD.table_pkey3%TYPE    := NULL;
   p_table_pkey4    AUTHENTICATE_STUD_AUD.table_pkey4%TYPE    := NULL;
   p_table_pkey5    AUTHENTICATE_STUD_AUD.table_pkey5%TYPE    := NULL;
   p_old            AUTHENTICATE_STUD_AUD.OLD%TYPE            := NULL;
   p_new            AUTHENTICATE_STUD_AUD.NEW%TYPE            := NULL;
   p_action         AUTHENTICATE_STUD_AUD.action%TYPE         := NULL;
   p_username       AUTHENTICATE_STUD_AUD.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    AUTHENTICATE_STUD_AUD.stud_ref_no%TYPE    := NULL;
   p_inst_code      AUTHENTICATE_STUD_AUD.inst_code%TYPE      := NULL;
   p_session_code   AUTHENTICATE_STUD_AUD.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.auth_stud_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.auth_stud_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'AUTH_STUD_ID';
   p_old := :OLD.auth_stud_id;
   p_new := :NEW.auth_stud_id;
   pk_steps_aud.ins_auth_stud_aud (p_aud_date,
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
   p_column_name := 'STUD_REF_NO';
   p_old := TO_CHAR (:OLD.stud_ref_no);
   p_new := TO_CHAR (:NEW.stud_ref_no);
   pk_steps_aud.ins_auth_stud_aud (p_aud_date,
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
   p_column_name := 'WEB_USER_ID';
   p_old := TO_CHAR (:OLD.web_user_id);
   p_new := TO_CHAR (:NEW.web_user_id);
   pk_steps_aud.ins_auth_stud_aud (p_aud_date,
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
   pk_steps_aud.ins_auth_stud_aud (p_aud_date,
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
END auth_stud_iud;
/



CREATE OR REPLACE TRIGGER awi_iud
   AFTER INSERT OR DELETE OR UPDATE OF payment_due_date,
                                       payment_status,
                                       install_type,
                                       amount,
                                       method,
                                       payment_addr,
                                       returned,
                                       unclaimed_fee_loan,
                                       fee_loan_instalment,
                                       fee_loan_transaction_created,
                                       payee_reference,
                                       invoice_no,
                                       invoice_date,
                                       net_amount,
                                       contrib_amount,
                                       recovered_amount,
                                       last_updated_by
   ON AWARD_INSTALMENT    FOR EACH ROW
DECLARE
   p_aud_date         DATE                                     := SYSDATE;
   p_column_name      award_instalment_aud.column_name%TYPE    := NULL;
   p_table_pkey1      award_instalment_aud.table_pkey1%TYPE
                                        := TO_CHAR (:OLD.award_id);
   p_table_pkey2      award_instalment_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3      award_instalment_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4      award_instalment_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5      award_instalment_aud.table_pkey5%TYPE    := NULL;
   p_old              award_instalment_aud.OLD%TYPE            := NULL;
   p_new              award_instalment_aud.NEW%TYPE            := NULL;
   p_action           award_instalment_aud.action%TYPE         := NULL;
   p_username         award_instalment_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no      award_instalment_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code        award_instalment_aud.inst_code%TYPE      := NULL;
   p_session_code     award_instalment_aud.session_code%TYPE   := NULL;
   result_trav_null   VARCHAR2 (2);
   unpaid_count       NUMBER (5);
   min_date           DATE;
   max_date           DATE;
   p_award_id         award.award_id%TYPE                      := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.award_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
--   p_award_id  := :old.AWARD_ID;
--            if :old.PAYMENT_STATUS <> :new.PAYMENT_STATUS then
--               if :new.PAYMENT_STATUS = null then

   --   IF (stud_crse_year_id_trav = stud_crse_year_id_match) AND latest_temp = 'Y'
--   THEN IF count_temp > 0
--   THEN IF payments_made > 0
--           THEN UPDATE STUD_TRAV_PROG
--             SET PAYMENT_DATE = ((SELECT min(payment_due_date) FROM award_instalment WHERE award_id= award_id_in AND payment_status IN ('A', 'U')))
--             WHERE STUD_CRSE_YEAR_ID = stud_crse_year_id_match;
--        ELSE
--             UPDATE STUD_TRAV_PROG
--             SET PAYMENT_DATE = ((select max(payment_due_date) from award_instalment where award_id= award_id_in))
--             WHERE STUD_CRSE_YEAR_ID = stud_crse_year_id_match;
--        END IF;
--    END IF;

   --                 SELECT min(payment_due_date) into min_date FROM award_instalment WHERE award_id = :new.award_id AND payment_status IN ('A', 'U');
--                 SELECT max(payment_due_date) into max_date from award_instalment where award_id = :new.award_id;
--                 SELECT count(*)    INTO unpaid_count FROM  award_instalment WHERE award_id = :new.award_id AND payment_status IN ('A', 'U');

   -- instructed to comment this out meantime, this will need looked at later, Phase 2 ??....A.Bowman
-- result_trav_null := maintain_repository.record_trav_status(:new.AWARD_ID, unpaid_count, min_date, max_date);*/

   --             end if;
--         end if;
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.award_id;
      p_username := :OLD.last_updated_by;
   END IF;

-- No error handling on the error condition - allow exception to propagate back to application.
-- Note: No requirement to record failed attempt to insert. Just changed data.
--    BEGIN
--        SELECT stud_ref_no
--        INTO   p_stud_ref_no
--        FROM   award
--        WHERE  award_id = p_award_id;
--
--        SELECT session_code
--        INTO   p_session_code
--        FROM   award
--        WHERE  award_id = p_award_id;
--
--        EXCEPTION
--        WHEN NO_DATA_FOUND THEN
--        raise;
--        END;
--
   p_column_name := 'PAYMENT_DUE_DATE';
   p_old := TO_CHAR (:OLD.payment_due_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.payment_due_date, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'INSTALL_TYPE';
   p_old := :OLD.install_type;
   p_new := :NEW.install_type;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'AMOUNT';
   p_old := TO_CHAR (:OLD.amount);
   p_new := TO_CHAR (:NEW.amount);
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'METHOD';
   p_old := :OLD.method;
   p_new := :NEW.method;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_ADDR';
   p_old := :OLD.payment_addr;
   p_new := :NEW.payment_addr;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_STATUS';
   p_old := :OLD.payment_status;
   p_new := :NEW.payment_status;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'RETURNED';
   p_old := :OLD.returned;
   p_new := :NEW.returned;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'UNCLAIMED_FEE_LOAN';
   p_old := :OLD.unclaimed_fee_loan;
   p_new := :NEW.unclaimed_fee_loan;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'FEE_LOAN_INSTALMENT';
   p_old := :OLD.fee_loan_instalment;
   p_new := :NEW.fee_loan_instalment;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'FEE_LOAN_TRANSACTION_CREATED';
   p_old := :OLD.fee_loan_transaction_created;
   p_new := :NEW.fee_loan_transaction_created;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'PAYEE_REFERENCE';
   p_old := :OLD.payee_reference;
   p_new := :NEW.payee_reference;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'INVOICE_NO';
   p_old := :OLD.invoice_no;
   p_new := :NEW.invoice_no;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'INVOICE_DATE';
   p_old := :OLD.invoice_date;
   p_new := :NEW.invoice_date;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'NET_AMOUNT';
   p_old := :OLD.net_amount;
   p_new := :NEW.net_amount;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'CONTRIB_AMOUNT';
   p_old := :OLD.contrib_amount;
   p_new := :NEW.contrib_amount;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   p_column_name := 'RECOVERED_AMOUNT';
   p_old := :OLD.recovered_amount;
   p_new := :NEW.recovered_amount;
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
   pk_steps_aud.ins_awi_aud (p_aud_date,
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
END awi_iud;
/



CREATE OR REPLACE TRIGGER aw_iud
   AFTER INSERT OR DELETE OR UPDATE OF non_tuition_fee_id,
                                       amount,
                                       net_amount,
                                       contrib_amount,
                                       recovered_amount,
                                       travel_award_type,
                                       unclaimed_fee_loan,
                                       award_type_descript,
                                       last_updated_by
   ON AWARD    FOR EACH ROW
DECLARE
   p_aud_date            DATE                           := SYSDATE;
   p_column_name         award_aud.column_name%TYPE     := NULL;
   p_table_pkey1         award_aud.table_pkey1%TYPE     := :OLD.award_id;
   p_table_pkey2         award_aud.table_pkey2%TYPE     := NULL;
   p_table_pkey3         award_aud.table_pkey3%TYPE     := NULL;
   p_table_pkey4         award_aud.table_pkey4%TYPE     := NULL;
   p_table_pkey5         award_aud.table_pkey5%TYPE     := NULL;
   p_old                 award_aud.OLD%TYPE             := NULL;
   p_new                 award_aud.NEW%TYPE             := NULL;
   p_action              award_aud.action%TYPE          := NULL;
   p_username            award_aud.username%TYPE        := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no         award_aud.stud_ref_no%TYPE     := NULL;
   p_inst_code           award_aud.inst_code%TYPE       := NULL;
   p_session_code        award_aud.session_code%TYPE    := NULL;
   p_stud_crse_year_id   award.stud_crse_year_id%TYPE
                                                    := :OLD.stud_crse_year_id;
   p_src                 award.award_src%TYPE           := :NEW.award_src;
   p_stud_award_type     award.stud_award_type%TYPE;
   v_temp                VARCHAR2 (1)                   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.award_id;
      p_stud_ref_no := :NEW.stud_ref_no;
      p_stud_crse_year_id := :NEW.stud_crse_year_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.award_id;
      p_src := :OLD.award_src;
      p_username := :OLD.last_updated_by;
   END IF;

   SELECT session_code
     INTO p_session_code
     FROM stud_crse_year
    WHERE stud_crse_year_id = p_stud_crse_year_id;

      p_column_name := 'NON_TUITION_FEE_ID';
      p_old := TO_CHAR (:OLD.non_tuition_fee_id);
      p_new := TO_CHAR (:NEW.non_tuition_fee_id);
      pk_steps_aud.ins_aw_aud (p_aud_date,
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
      p_column_name := 'AMOUNT';
      p_old := TO_CHAR (:OLD.amount);
      p_new := TO_CHAR (:NEW.amount);
      pk_steps_aud.ins_aw_aud (p_aud_date,
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

      IF p_src = 'T'
      THEN
         pk_steps_changes.award_net_change (p_old, p_new, p_stud_crse_year_id);
      END IF;

      p_column_name := 'NET_AMOUNT';
      p_old := TO_CHAR (:OLD.net_amount);
      p_new := TO_CHAR (:NEW.net_amount);
      pk_steps_aud.ins_aw_aud (p_aud_date,
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

      IF p_src = 'T'
      THEN
         pk_steps_changes.award_net_change (p_old, p_new, p_stud_crse_year_id);
      END IF;

      p_column_name := 'CONTRIB_AMOUNT';
      p_old := TO_CHAR (:OLD.contrib_amount);
      p_new := TO_CHAR (:NEW.contrib_amount);
      pk_steps_aud.ins_aw_aud (p_aud_date,
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

      IF p_src = 'T'
      THEN
         pk_steps_changes.award_contrib_change (p_old, p_new, p_stud_crse_year_id);
      END IF;

      p_column_name := 'RECOVERED_AMOUNT';
      p_old := TO_CHAR (:OLD.recovered_amount);
      p_new := TO_CHAR (:NEW.recovered_amount);
      pk_steps_aud.ins_aw_aud (p_aud_date,
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
      p_column_name := 'TRAVEL_AWARD_TYPE';
      p_old := TO_CHAR (:OLD.travel_award_type);
      p_new := TO_CHAR (:NEW.travel_award_type);
      p_stud_award_type := TO_CHAR (:OLD.stud_award_type);

      IF p_stud_award_type IN ('UGTE', 'UGLTE', 'PSTE', 'PSLTE')
      THEN
         pk_steps_aud.ins_aw_aud (p_aud_date,
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
      END IF;

      p_column_name := 'UNCLAIMED_FEE_LOAN';
      p_old := TO_CHAR (:OLD.unclaimed_fee_loan);
      p_new := TO_CHAR (:NEW.unclaimed_fee_loan);
      pk_steps_aud.ins_aw_aud (p_aud_date,
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
      p_column_name := 'AWARD_TYPE_DESCRIPT';
      p_old := :OLD.award_type_descript;
      p_new := :NEW.award_type_descript;
      pk_steps_aud.ins_aw_aud (p_aud_date,
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
      pk_steps_aud.ins_aw_aud (p_aud_date,
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
EXCEPTION
   WHEN OTHERS
   THEN
      v_temp := 'N';
      
END aw_iud;
/



CREATE OR REPLACE TRIGGER aw_ref_dat_iud
   AFTER INSERT OR DELETE OR UPDATE OF AWARD_REF_DATA_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON AWARD_REF_DATA    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    AWARD_REF_DATA_aud.column_name%TYPE    := NULL;
   p_table_pkey1    AWARD_REF_DATA_aud.table_pkey1%TYPE
                                               := :OLD.AWARD_REF_DATA_id;
   p_table_pkey2    AWARD_REF_DATA_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    AWARD_REF_DATA_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    AWARD_REF_DATA_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    AWARD_REF_DATA_aud.table_pkey5%TYPE    := NULL;
   p_old            AWARD_REF_DATA_aud.OLD%TYPE            := NULL;
   p_new            AWARD_REF_DATA_aud.NEW%TYPE            := NULL;
   p_action         AWARD_REF_DATA_aud.action%TYPE         := NULL;
   p_username       AWARD_REF_DATA_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    AWARD_REF_DATA_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      AWARD_REF_DATA_aud.inst_code%TYPE      := NULL;
   p_session_code   AWARD_REF_DATA_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.AWARD_REF_DATA_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.AWARD_REF_DATA_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'AWARD_REF_DATA_ID';
   p_old := :OLD.AWARD_REF_DATA_id;
   p_new := :NEW.AWARD_REF_DATA_id;
   pk_steps_aud.ins_aw_ref_dat_aud (p_aud_date,
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
   pk_steps_aud.ins_aw_ref_dat_aud (p_aud_date,
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
   pk_steps_aud.ins_aw_ref_dat_aud (p_aud_date,
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
   pk_steps_aud.ins_aw_ref_dat_aud (p_aud_date,
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
   pk_steps_aud.ins_aw_ref_dat_aud (p_aud_date,
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
END aw_ref_dat_iud;
/



CREATE OR REPLACE TRIGGER bed_iud
   AFTER INSERT OR DELETE OR UPDATE OF income, assistance_amount, dob, last_updated_by
   ON BENEFACTOR_DEPENDANT    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                         := SYSDATE;
   p_column_name    benefactor_dependant_aud.column_name%TYPE    := NULL;
   p_table_pkey1    benefactor_dependant_aud.table_pkey1%TYPE  := :OLD.bed_id;
   p_table_pkey2    benefactor_dependant_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    benefactor_dependant_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    benefactor_dependant_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    benefactor_dependant_aud.table_pkey5%TYPE    := NULL;
   p_old            benefactor_dependant_aud.OLD%TYPE            := NULL;
   p_new            benefactor_dependant_aud.NEW%TYPE            := NULL;
   p_action         benefactor_dependant_aud.action%TYPE         := NULL;
   p_username       benefactor_dependant_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    benefactor_dependant_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      benefactor_dependant_aud.inst_code%TYPE      := NULL;
   p_session_code   benefactor_dependant_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.bed_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.bed_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'INCOME';
   p_old := TO_CHAR (:OLD.income);
   p_new := TO_CHAR (:NEW.income);
   pk_steps_aud.ins_bed_aud (p_aud_date,
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
   p_column_name := 'ASSISTANCE_AMOUNT';
   p_old := TO_CHAR (:OLD.assistance_amount);
   p_new := TO_CHAR (:NEW.assistance_amount);
   pk_steps_aud.ins_bed_aud (p_aud_date,
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
   p_column_name := 'DOB';
   p_old := TO_CHAR (:OLD.dob);
   p_new := TO_CHAR (:NEW.dob);
   pk_steps_aud.ins_bed_aud (p_aud_date,
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
   pk_steps_aud.ins_bed_aud (p_aud_date,
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
END bed_iud;
/



CREATE OR REPLACE TRIGGER bei_iud
   AFTER INSERT OR DELETE OR UPDATE OF income_type,
                                       income_status,
                                       bank_interest,
                                       benefit,
                                       other_income,
                                       nat_saving_interest,
                                       paye_income,
                                       pension,
                                       self_employment,
                                       property,
                                       dividend,
                                       qa_received,
                                       suppress_reminder,
                                       ben_hei_bursary_consent,
                                       working_tax_credit,
                                       employment_support_allowance,
                                       incapacity_benefit,
                                       income_support,
                                       invalidity_benefit,
                                       jobseekers_allowance,
                                       maintenance_payment,
                                       last_updated_by
   ON BENEFACTOR_INCOME    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                      := SYSDATE;
   p_column_name    benefactor_income_aud.column_name%TYPE    := NULL;
   p_table_pkey1    benefactor_income_aud.table_pkey1%TYPE
                                                     := TO_CHAR (:OLD.ben_id);
   p_table_pkey2    benefactor_income_aud.table_pkey2%TYPE
                                               := TO_CHAR (:OLD.session_code);
   p_table_pkey3    benefactor_income_aud.table_pkey3%TYPE
                                                          := :OLD.income_type;
   p_table_pkey4    benefactor_income_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    benefactor_income_aud.table_pkey5%TYPE    := NULL;
   p_old            benefactor_income_aud.OLD%TYPE            := NULL;
   p_new            benefactor_income_aud.NEW%TYPE            := NULL;
   p_action         benefactor_income_aud.action%TYPE         := NULL;
   p_username       benefactor_income_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    benefactor_income_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      benefactor_income_aud.inst_code%TYPE      := NULL;
   p_session_code   benefactor_income_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.ben_id;
      p_table_pkey2 := :NEW.session_code;
      p_table_pkey3 := :NEW.income_type;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.ben_id;
      p_table_pkey2 := :OLD.session_code;
      p_table_pkey3 := :OLD.income_type;
      p_username    := :OLD.last_updated_by;
   END IF;

   p_column_name := 'INCOME_TYPE';
   p_old := :OLD.income_type;
   p_new := :NEW.income_type;
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'INCOME_STATUS';
   p_old := :OLD.income_status;
   p_new := :NEW.income_status;
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'BANK_INTEREST';
   p_old := TO_CHAR (:OLD.bank_interest);
   p_new := TO_CHAR (:NEW.bank_interest);
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'BENEFIT';
   p_old := TO_CHAR (:OLD.benefit);
   p_new := TO_CHAR (:NEW.benefit);
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'OTHER_INCOME';
   p_old := TO_CHAR (:OLD.other_income);
   p_new := TO_CHAR (:NEW.other_income);
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'NAT_SAVING_INTEREST';
   p_old := TO_CHAR (:OLD.nat_saving_interest);
   p_new := TO_CHAR (:NEW.nat_saving_interest);
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'PAYE_INCOME';
   p_old := TO_CHAR (:OLD.paye_income);
   p_new := TO_CHAR (:NEW.paye_income);
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'PENSION';
   p_old := TO_CHAR (:OLD.pension);
   p_new := TO_CHAR (:NEW.pension);
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'SELF_EMPLOYMENT';
   p_old := TO_CHAR (:OLD.self_employment);
   p_new := TO_CHAR (:NEW.self_employment);
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'PROPERTY';
   p_old := TO_CHAR (:OLD.property);
   p_new := TO_CHAR (:NEW.property);
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'DIVIDEND';
   p_old := TO_CHAR (:OLD.dividend);
   p_new := TO_CHAR (:NEW.dividend);
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'QA_RECEIVED';
   p_old := TO_CHAR (:OLD.qa_received);
   p_new := TO_CHAR (:NEW.qa_received);
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'SUPPRESS_REMINDER';
   p_old := TO_CHAR (:OLD.suppress_reminder);
   p_new := TO_CHAR (:NEW.suppress_reminder);
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'BEN_HEI_BURSARY_CONSENT';
   p_old := TO_CHAR (:OLD.ben_hei_bursary_consent);
   p_new := TO_CHAR (:NEW.ben_hei_bursary_consent);
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'WORKING_TAX_CREDIT';
   p_old := :OLD.working_tax_credit;
   p_new := :NEW.working_tax_credit;
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'EMPLOYMENT_SUPPORT_ALLOWANCE';
   p_old := :OLD.employment_support_allowance;
   p_new := :NEW.employment_support_allowance;
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'INCAPACITY_BENEFIT';
   p_old := :OLD.incapacity_benefit;
   p_new := :NEW.incapacity_benefit;
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'INCOME_SUPPORT';
   p_old := :OLD.income_support;
   p_new := :NEW.income_support;
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'IVALIDITY_BENEFIT';
   p_old := :OLD.invalidity_benefit;
   p_new := :NEW.invalidity_benefit;
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'JOBSEEKERS_ALLOWANCE';
   p_old := :OLD.jobseekers_allowance;
   p_new := :NEW.jobseekers_allowance;
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   p_column_name := 'MAINTENANCE_PAYMENT';
   p_old := :OLD.maintenance_payment;
   p_new := :NEW.maintenance_payment;
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
   pk_steps_aud.ins_bei_aud (p_aud_date,
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
END bei_iud;
/



CREATE OR REPLACE TRIGGER ben_inc_stat_iud
   AFTER INSERT OR DELETE OR UPDATE OF BEN_INCOME_STATUS_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON BEN_INCOME_STATUS    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    BEN_INCOME_STATUS_aud.column_name%TYPE    := NULL;
   p_table_pkey1    BEN_INCOME_STATUS_aud.table_pkey1%TYPE
                                               := :OLD.BEN_INCOME_STATUS_id;
   p_table_pkey2    BEN_INCOME_STATUS_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    BEN_INCOME_STATUS_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    BEN_INCOME_STATUS_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    BEN_INCOME_STATUS_aud.table_pkey5%TYPE    := NULL;
   p_old            BEN_INCOME_STATUS_aud.OLD%TYPE            := NULL;
   p_new            BEN_INCOME_STATUS_aud.NEW%TYPE            := NULL;
   p_action         BEN_INCOME_STATUS_aud.action%TYPE         := NULL;
   p_username       BEN_INCOME_STATUS_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    BEN_INCOME_STATUS_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      BEN_INCOME_STATUS_aud.inst_code%TYPE      := NULL;
   p_session_code   BEN_INCOME_STATUS_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.BEN_INCOME_STATUS_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.BEN_INCOME_STATUS_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'BEN_INCOME_STATUS_ID';
   p_old := :OLD.BEN_INCOME_STATUS_id;
   p_new := :NEW.BEN_INCOME_STATUS_id;
   pk_steps_aud.ins_ben_inc_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_inc_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_inc_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_inc_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_inc_stat_aud (p_aud_date,
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
END ben_inc_stat_iud;
/



CREATE OR REPLACE TRIGGER ben_inc_type_iud
   AFTER INSERT OR DELETE OR UPDATE OF BEN_INCOME_TYPE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON BEN_INCOME_TYPE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    BEN_INCOME_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    BEN_INCOME_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.BEN_INCOME_TYPE_id;
   p_table_pkey2    BEN_INCOME_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    BEN_INCOME_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    BEN_INCOME_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    BEN_INCOME_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            BEN_INCOME_TYPE_aud.OLD%TYPE            := NULL;
   p_new            BEN_INCOME_TYPE_aud.NEW%TYPE            := NULL;
   p_action         BEN_INCOME_TYPE_aud.action%TYPE         := NULL;
   p_username       BEN_INCOME_TYPE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    BEN_INCOME_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      BEN_INCOME_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   BEN_INCOME_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.BEN_INCOME_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.BEN_INCOME_TYPE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'BEN_INCOME_TYPE_ID';
   p_old := :OLD.BEN_INCOME_TYPE_id;
   p_new := :NEW.BEN_INCOME_TYPE_id;
   pk_steps_aud.ins_ben_inc_type_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_inc_type_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_inc_type_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_inc_type_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_inc_type_aud (p_aud_date,
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
END ben_inc_type_iud;
/



CREATE OR REPLACE TRIGGER ben_iud
   AFTER INSERT OR DELETE OR UPDATE OF addr_l1,
                                       addr_l2,
                                       addr_l3,
                                       addr_l4,
                                       ben_ni_no,
                                       forenames,
                                       house_no_name,
                                       post_code,
                                       surname,
                                       last_updated_by
   ON BENEFACTOR    FOR EACH ROW
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
END ben_iud;
/



CREATE OR REPLACE TRIGGER ben_rel_iud
   AFTER INSERT OR DELETE OR UPDATE OF benefactor_relation_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON BENEFACTOR_RELATION    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    benefactor_relation_aud.column_name%TYPE    := NULL;
   p_table_pkey1    benefactor_relation_aud.table_pkey1%TYPE
                                               := :OLD.benefactor_relation_id;
   p_table_pkey2    benefactor_relation_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    benefactor_relation_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    benefactor_relation_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    benefactor_relation_aud.table_pkey5%TYPE    := NULL;
   p_old            benefactor_relation_aud.OLD%TYPE            := NULL;
   p_new            benefactor_relation_aud.NEW%TYPE            := NULL;
   p_action         benefactor_relation_aud.action%TYPE         := NULL;
   p_username       benefactor_relation_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    benefactor_relation_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      benefactor_relation_aud.inst_code%TYPE      := NULL;
   p_session_code   benefactor_relation_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.benefactor_relation_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.benefactor_relation_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'BENEFACTOR_RELATION_ID';
   p_old := :OLD.benefactor_relation_id;
   p_new := :NEW.benefactor_relation_id;
   pk_steps_aud.ins_ben_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_rel_aud (p_aud_date,
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
END ben_rel_iud;
/



CREATE OR REPLACE TRIGGER case_stat_iud
   AFTER INSERT OR DELETE OR UPDATE OF CASE_STATUS_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON CASE_STATUS    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    CASE_STATUS_aud.column_name%TYPE    := NULL;
   p_table_pkey1    CASE_STATUS_aud.table_pkey1%TYPE
                                               := :OLD.CASE_STATUS_id;
   p_table_pkey2    CASE_STATUS_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    CASE_STATUS_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    CASE_STATUS_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    CASE_STATUS_aud.table_pkey5%TYPE    := NULL;
   p_old            CASE_STATUS_aud.OLD%TYPE            := NULL;
   p_new            CASE_STATUS_aud.NEW%TYPE            := NULL;
   p_action         CASE_STATUS_aud.action%TYPE         := NULL;
   p_username       CASE_STATUS_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    CASE_STATUS_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      CASE_STATUS_aud.inst_code%TYPE      := NULL;
   p_session_code   CASE_STATUS_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.CASE_STATUS_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.CASE_STATUS_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'CASE_STATUS_ID';
   p_old := :OLD.CASE_STATUS_id;
   p_new := :NEW.CASE_STATUS_id;
   pk_steps_aud.ins_case_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_case_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_case_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_case_stat_aud (p_aud_date,
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
   p_column_name := 'LAST_UPDATED';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_case_stat_aud (p_aud_date,
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
END case_stat_iud;
/



CREATE OR REPLACE TRIGGER cn_iud
   AFTER INSERT OR DELETE OR UPDATE OF CATEGORY, LAST_UPDATED_BY
   ON COUNTRY    FOR EACH ROW
DECLARE
   p_aud_date       DATE                            := SYSDATE;
   p_column_name    country_aud.column_name%TYPE    := NULL;
   p_table_pkey1    country_aud.table_pkey1%TYPE    := :OLD.country_code;
   p_table_pkey2    country_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    country_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    country_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    country_aud.table_pkey5%TYPE    := NULL;
   p_old            country_aud.OLD%TYPE            := NULL;
   p_new            country_aud.NEW%TYPE            := NULL;
   p_action         country_aud.action%TYPE         := NULL;
   p_username       country_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    country_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      country_aud.inst_code%TYPE      := NULL;
   p_session_code   country_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.country_code;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.country_code;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'CATEGORY';
   p_old := TO_CHAR (:OLD.CATEGORY);
   p_new := TO_CHAR (:NEW.CATEGORY);
   pk_steps_aud.ins_cn_aud (p_aud_date,
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
   pk_steps_aud.ins_cn_aud (p_aud_date,
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
END cn_iud;
/



CREATE OR REPLACE TRIGGER con_rel_iud
   AFTER INSERT OR DELETE OR UPDATE OF contact_relationship_id,
                                       reltype,
                                       descript,
                                       last_updated_by
   ON CONTACT_RELATIONSHIP    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                         := SYSDATE;
   p_column_name    contact_relationship_aud.column_name%TYPE    := NULL;
   p_table_pkey1    contact_relationship_aud.table_pkey1%TYPE
                                              := :OLD.contact_relationship_id;
   p_table_pkey2    contact_relationship_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    contact_relationship_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    contact_relationship_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    contact_relationship_aud.table_pkey5%TYPE    := NULL;
   p_old            contact_relationship_aud.OLD%TYPE            := NULL;
   p_new            contact_relationship_aud.NEW%TYPE            := NULL;
   p_action         contact_relationship_aud.action%TYPE         := NULL;
   p_username       contact_relationship_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    contact_relationship_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      contact_relationship_aud.inst_code%TYPE      := NULL;
   p_session_code   contact_relationship_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.contact_relationship_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.contact_relationship_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'CONTACT_RELATIONSHIP_ID';
   p_old := :OLD.contact_relationship_id;
   p_new := :NEW.contact_relationship_id;
   pk_steps_aud.ins_con_rel_aud (p_aud_date,
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
   p_column_name := 'RELTYPE';
   p_old := TO_CHAR (:OLD.reltype);
   p_new := TO_CHAR (:NEW.reltype);
   pk_steps_aud.ins_con_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_con_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_con_rel_aud (p_aud_date,
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
END con_rel_iud;
/



CREATE OR REPLACE TRIGGER dear_stat_iud
   AFTER INSERT OR DELETE OR UPDATE OF DEARING_STATUS_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON DEARING_STATUS    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DEARING_STATUS_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DEARING_STATUS_aud.table_pkey1%TYPE
                                               := :OLD.DEARING_STATUS_id;
   p_table_pkey2    DEARING_STATUS_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DEARING_STATUS_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DEARING_STATUS_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DEARING_STATUS_aud.table_pkey5%TYPE    := NULL;
   p_old            DEARING_STATUS_aud.OLD%TYPE            := NULL;
   p_new            DEARING_STATUS_aud.NEW%TYPE            := NULL;
   p_action         DEARING_STATUS_aud.action%TYPE         := NULL;
   p_username       DEARING_STATUS_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DEARING_STATUS_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DEARING_STATUS_aud.inst_code%TYPE      := NULL;
   p_session_code   DEARING_STATUS_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DEARING_STATUS_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DEARING_STATUS_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'DEARING_STATUS_ID';
   p_old := :OLD.DEARING_STATUS_id;
   p_new := :NEW.DEARING_STATUS_id;
   pk_steps_aud.ins_dear_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_dear_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_dear_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_dear_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_dear_stat_aud (p_aud_date,
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
END dear_stat_iud;
/



CREATE OR REPLACE TRIGGER debt_stat_iud
   AFTER INSERT OR DELETE OR UPDATE OF DEBT_STATUS_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON DEBT_STATUS    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DEBT_STATUS_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DEBT_STATUS_aud.table_pkey1%TYPE
                                               := :OLD.DEBT_STATUS_id;
   p_table_pkey2    DEBT_STATUS_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DEBT_STATUS_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DEBT_STATUS_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DEBT_STATUS_aud.table_pkey5%TYPE    := NULL;
   p_old            DEBT_STATUS_aud.OLD%TYPE            := NULL;
   p_new            DEBT_STATUS_aud.NEW%TYPE            := NULL;
   p_action         DEBT_STATUS_aud.action%TYPE         := NULL;
   p_username       DEBT_STATUS_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DEBT_STATUS_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DEBT_STATUS_aud.inst_code%TYPE      := NULL;
   p_session_code   DEBT_STATUS_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DEBT_STATUS_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DEBT_STATUS_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'DEBT_STATUS_ID';
   p_old := :OLD.DEBT_STATUS_id;
   p_new := :NEW.DEBT_STATUS_id;
   pk_steps_aud.ins_debt_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_debt_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_debt_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_debt_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_debt_stat_aud (p_aud_date,
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
END debt_stat_iud;
/



CREATE OR REPLACE TRIGGER dis_type_iud
   AFTER INSERT OR DELETE OR UPDATE OF DISABILITY_TYPE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON DISABILITY_TYPE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DISABILITY_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DISABILITY_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.DISABILITY_TYPE_id;
   p_table_pkey2    DISABILITY_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DISABILITY_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DISABILITY_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DISABILITY_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            DISABILITY_TYPE_aud.OLD%TYPE            := NULL;
   p_new            DISABILITY_TYPE_aud.NEW%TYPE            := NULL;
   p_action         DISABILITY_TYPE_aud.action%TYPE         := NULL;
   p_username       DISABILITY_TYPE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DISABILITY_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DISABILITY_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   DISABILITY_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DISABILITY_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DISABILITY_TYPE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'DISABILITY_TYPE_ID';
   p_old := :OLD.DISABILITY_TYPE_id;
   p_new := :NEW.DISABILITY_TYPE_id;
   pk_steps_aud.ins_dis_type_aud (p_aud_date,
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
   pk_steps_aud.ins_dis_type_aud (p_aud_date,
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
   pk_steps_aud.ins_dis_type_aud (p_aud_date,
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
   pk_steps_aud.ins_dis_type_aud (p_aud_date,
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
   pk_steps_aud.ins_dis_type_aud (p_aud_date,
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
END dis_type_iud;
/



CREATE OR REPLACE TRIGGER dsa_ac_iud
AFTER INSERT OR DELETE OR UPDATE OF DSA_ASSESSMENT_CENTRE_id, name, last_updated_by
ON DSA_ASSESSMENT_CENTRE FOR EACH ROW
DECLARE
   p_aud_date       DATE                                 := SYSDATE;
   p_column_name    DSA_ASSESSMENT_CENTRE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_ASSESSMENT_CENTRE_aud.table_pkey1%TYPE := :OLD.DSA_ASSESSMENT_CENTRE_id;
   p_table_pkey2    DSA_ASSESSMENT_CENTRE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_ASSESSMENT_CENTRE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_ASSESSMENT_CENTRE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_ASSESSMENT_CENTRE_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_ASSESSMENT_CENTRE_aud.OLD%TYPE            := NULL;
   p_new            DSA_ASSESSMENT_CENTRE_aud.NEW%TYPE            := NULL;
   p_action         DSA_ASSESSMENT_CENTRE_aud.action%TYPE         := NULL;
   p_username       DSA_ASSESSMENT_CENTRE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_ASSESSMENT_CENTRE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_ASSESSMENT_CENTRE_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_ASSESSMENT_CENTRE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DSA_ASSESSMENT_CENTRE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DSA_ASSESSMENT_CENTRE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'DSA_ASSESSMENT_CENTRE_ID';
   p_old := :OLD.DSA_ASSESSMENT_CENTRE_id;
   p_new := :NEW.DSA_ASSESSMENT_CENTRE_id;
   pk_steps_aud.ins_dsa_ac_aud (p_aud_date,
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
   p_column_name := 'NAME';
   p_old := :OLD.NAME;
   p_new := :NEW.NAME;
   pk_steps_aud.ins_dsa_ac_aud (p_aud_date,
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
   pk_steps_aud.ins_dsa_ac_aud (p_aud_date,
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
END dsa_ac_iud;
/



CREATE OR REPLACE TRIGGER DSA_ALL_iud
   AFTER INSERT OR DELETE OR UPDATE OF ID,
                                       dsa_application_id,
                                       stud_session_id,
                                       stud_crse_year_id,
                                       dsa_category_id,                    
                                       max_amount,
                                       available_amount,
                                       paid_amount,
                                       travel_amount,
                                       payment_due_date,
                                       date_paid,
                                       statutory_override_limit,
                                       general_override_limit,
                                       reminders_sent,
                                       date_last_reminder_sent,
                                       last_updated_by 
ON DSA_ALLOWANCE FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DSA_ALLOWANCE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_ALLOWANCE_aud.table_pkey1%TYPE
                                               := :OLD.ID;
   p_table_pkey2    DSA_ALLOWANCE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_ALLOWANCE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_ALLOWANCE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_ALLOWANCE_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_ALLOWANCE_aud.OLD%TYPE            := NULL;
   p_new            DSA_ALLOWANCE_aud.NEW%TYPE            := NULL;
   p_action         DSA_ALLOWANCE_aud.action%TYPE         := NULL;
   p_username       DSA_ALLOWANCE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_ALLOWANCE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_ALLOWANCE_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_ALLOWANCE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'ID';
   p_old := :OLD.id;
   p_new := :NEW.id;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
   p_column_name := 'dsa_application_id';
   p_old := :OLD.dsa_application_id;
   p_new := :NEW.dsa_application_id;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
   p_column_name := 'stud_session_id';
   p_old := :OLD.stud_session_id;
   p_new := :NEW.stud_session_id;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
   p_column_name := 'stud_crse_year_id';
   p_old := :OLD.stud_crse_year_id;
   p_new := :NEW.stud_crse_year_id;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
   p_column_name := 'dsa_category_id';
   p_old := :OLD.dsa_category_id;
   p_new := :NEW.dsa_category_id;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
   p_column_name := 'max_amount';
   p_old := :OLD.max_amount;
   p_new := :NEW.max_amount;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
   p_column_name := 'available_amount';
   p_old := :OLD.available_amount;
   p_new := :NEW.available_amount;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
   p_column_name := 'paid_amount';
   p_old := :OLD.paid_amount;
   p_new := :NEW.paid_amount;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
   p_column_name := 'travel_amount';
   p_old := :OLD.travel_amount;
   p_new := :NEW.travel_amount;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
   p_column_name := 'payment_due_date';
   p_old := :OLD.payment_due_date;
   p_new := :NEW.payment_due_date;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
   p_column_name := 'date_paid';
   p_old := :OLD.date_paid;
   p_new := :NEW.date_paid;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
   p_column_name := 'statutory_override_limit';
   p_old := :OLD.statutory_override_limit;
   p_new := :NEW.statutory_override_limit;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
   p_column_name := 'general_override_limit';
   p_old := :OLD.general_override_limit;
   p_new := :NEW.general_override_limit;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
   p_column_name := 'reminders_sent';
   p_old := :OLD.reminders_sent;
   p_new := :NEW.reminders_sent;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
   p_column_name := 'date_last_reminder_sent';
   p_old := :OLD.date_last_reminder_sent;
   p_new := :NEW.date_last_reminder_sent;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
   p_column_name := 'last_updated_by';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
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
  
END DSA_ALL_IUD;
/



CREATE OR REPLACE TRIGGER DSA_APP_iud
   AFTER INSERT OR DELETE OR UPDATE OF ID,
                                       STUD_REF_NO,                  
                                       SESSION_CODE,                 
                                       INST_CODE,                    
                                       DISABILITY_TYPE_ID,           
                                       DATE_APPLICATION_RECEIVED,    
                                       PRIORITY_APP,                 
                                       DSA_STUDENT_TYPE_ID,          
                                       REFERRED_FLAG,                
                                       DATE_REFERRED_ACCESS_CENTRE,  
                                       DSA_REFERRAL_REASON_ID,       
                                       ASSESSMENT_CENTRE_ID,         
                                       NEEDS_ASSESSOR,                     
                                       ASSESSOR_HOURLY_RATE,            
                                       PART_TIME_COURSE, 
                                       more_info_req, 
                                       exceptional_case, 
                                       DATE_ASSESS_REP_RECEIVED,     
                                       DATE_ASSESS_REP_PROCESSED,    
                                       PROCESSING_DAYS,              
                                       ASSESS_FEE_AMOUNT,            
                                       REJECTED,                     
                                       DSA_REJECTION_REASON_ID,      
                                       CONSENT_TICKED,               
                                       NON_MED_AMOUNT,               
                                       LARGE_ITEMS_AMOUNT,           
                                       BASIC_ALLOWANCE_AMOUNT,       
                                       TRAVEL_AMOUNT,                
                                       OTHER_INFORMATION,            
                                       HOURS_TO_COMPLETE_ASSESS,
                                       LAST_UPDATED_BY
ON DSA_APPLICATION FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DSA_APPLICATION_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_APPLICATION_aud.table_pkey1%TYPE
                                               := :OLD.ID;
   p_table_pkey2    DSA_APPLICATION_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_APPLICATION_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_APPLICATION_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_APPLICATION_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_APPLICATION_aud.OLD%TYPE            := NULL;
   p_new            DSA_APPLICATION_aud.NEW%TYPE            := NULL;
   p_action         DSA_APPLICATION_aud.action%TYPE         := NULL;
   p_username       DSA_APPLICATION_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_APPLICATION_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_APPLICATION_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_APPLICATION_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'ID';
   p_old := :OLD.id;
   p_new := :NEW.id;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'STUD_REF_NO';
   p_old := :OLD.STUD_REF_NO;
   p_new := :NEW.STUD_REF_NO;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'SESSION_CODE';
   p_old := :OLD.SESSION_CODE;
   p_new := :NEW.SESSION_CODE;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'INST_CODE';
   p_old := :OLD.INST_CODE;
   p_new := :NEW.INST_CODE;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DISABILITY_TYPE_ID';
   p_old := :OLD.DISABILITY_TYPE_ID;
   p_new := :NEW.DISABILITY_TYPE_ID;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DATE_APPLICATION_RECEIVED';
   p_old := :OLD.DATE_APPLICATION_RECEIVED;
   p_new := :NEW.DATE_APPLICATION_RECEIVED;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'PRIORITY_APP';
   p_old := :OLD.PRIORITY_APP;
   p_new := :NEW.PRIORITY_APP;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DSA_STUDENT_TYPE_ID';
   p_old := :OLD.DSA_STUDENT_TYPE_ID;
   p_new := :NEW.DSA_STUDENT_TYPE_ID;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'REFERRED_FLAG';
   p_old := :OLD.REFERRED_FLAG;
   p_new := :NEW.REFERRED_FLAG;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DATE_REFERRED_ACCESS_CENTRE';
   p_old := :OLD.DATE_REFERRED_ACCESS_CENTRE;
   p_new := :NEW.DATE_REFERRED_ACCESS_CENTRE;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DSA_REFERRAL_REASON_ID';
   p_old := :OLD.DSA_REFERRAL_REASON_ID;
   p_new := :NEW.DSA_REFERRAL_REASON_ID;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'ASSESSMENT_CENTRE_ID';
   p_old := :OLD.ASSESSMENT_CENTRE_ID;
   p_new := :NEW.ASSESSMENT_CENTRE_ID;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'NEEDS_ASSESSOR';
   p_old := :OLD.NEEDS_ASSESSOR;
   p_new := :NEW.NEEDS_ASSESSOR;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'ASSESSOR_HOURLY_RATE';
   p_old := :OLD.ASSESSOR_HOURLY_RATE;
   p_new := :NEW.ASSESSOR_HOURLY_RATE;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'PART_TIME_COURSE';
   p_old := :OLD.PART_TIME_COURSE;
   p_new := :NEW.PART_TIME_COURSE;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'more_info_req';
   p_old := :OLD.more_info_req;
   p_new := :NEW.more_info_req;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'exceptional_case';
   p_old := :OLD.exceptional_case;
   p_new := :NEW.exceptional_case;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DATE_ASSESS_REP_RECEIVED';
   p_old := :OLD.DATE_ASSESS_REP_RECEIVED;
   p_new := :NEW.DATE_ASSESS_REP_RECEIVED;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DATE_ASSESS_REP_PROCESSED';
   p_old := :OLD.DATE_ASSESS_REP_PROCESSED;
   p_new := :NEW.DATE_ASSESS_REP_PROCESSED;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'PROCESSING_DAYS';
   p_old := :OLD.PROCESSING_DAYS;
   p_new := :NEW.PROCESSING_DAYS;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'ASSESS_FEE_AMOUNT';
   p_old := :OLD.ASSESS_FEE_AMOUNT;
   p_new := :NEW.ASSESS_FEE_AMOUNT;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'REJECTED';
   p_old := :OLD.REJECTED;
   p_new := :NEW.REJECTED;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'DSA_REJECTION_REASON_ID';
   p_old := :OLD.DSA_REJECTION_REASON_ID;
   p_new := :NEW.DSA_REJECTION_REASON_ID;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'CONSENT_TICKED';
   p_old := :OLD.CONSENT_TICKED;
   p_new := :NEW.CONSENT_TICKED;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'NON_MED_AMOUNT';
   p_old := :OLD.NON_MED_AMOUNT;
   p_new := :NEW.NON_MED_AMOUNT;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'LARGE_ITEMS_AMOUNT';
   p_old := :OLD.LARGE_ITEMS_AMOUNT;
   p_new := :NEW.LARGE_ITEMS_AMOUNT;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'BASIC_ALLOWANCE_AMOUNT';
   p_old := :OLD.BASIC_ALLOWANCE_AMOUNT;
   p_new := :NEW.BASIC_ALLOWANCE_AMOUNT;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'TRAVEL_AMOUNT';
   p_old := :OLD.TRAVEL_AMOUNT;
   p_new := :NEW.TRAVEL_AMOUNT;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'OTHER_INFORMATION';
   p_old := :OLD.OTHER_INFORMATION;
   p_new := :NEW.OTHER_INFORMATION;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   p_column_name := 'HOURS_TO_COMPLETE_ASSESS';
   p_old := :OLD.HOURS_TO_COMPLETE_ASSESS;
   p_new := :NEW.HOURS_TO_COMPLETE_ASSESS;
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
   pk_steps_aud.ins_DSA_APP_aud (p_aud_date,
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
END DSA_APP_IUD;
/



CREATE OR REPLACE TRIGGER dsa_cat_iud
   AFTER INSERT OR DELETE OR UPDATE OF dsa_category_id,
                                       code,
                                       description,
                                       type_id,
                                       last_updated_by
   ON DSA_CATEGORY    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                 := SYSDATE;
   p_column_name    dsa_category_aud.column_name%TYPE    := NULL;
   p_table_pkey1    dsa_category_aud.table_pkey1%TYPE := :OLD.dsa_category_id;
   p_table_pkey2    dsa_category_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    dsa_category_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    dsa_category_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    dsa_category_aud.table_pkey5%TYPE    := NULL;
   p_old            dsa_category_aud.OLD%TYPE            := NULL;
   p_new            dsa_category_aud.NEW%TYPE            := NULL;
   p_action         dsa_category_aud.action%TYPE         := NULL;
   p_username       dsa_category_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    dsa_category_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      dsa_category_aud.inst_code%TYPE      := NULL;
   p_session_code   dsa_category_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.dsa_category_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.dsa_category_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'DSA_CATEGORY_ID';
   p_old := :OLD.dsa_category_id;
   p_new := :NEW.dsa_category_id;
   pk_steps_aud.ins_dsa_cat_aud (p_aud_date,
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
   p_column_name := 'CODE';
   p_old := TO_CHAR (:OLD.code);
   p_new := TO_CHAR (:NEW.code);
   pk_steps_aud.ins_dsa_cat_aud (p_aud_date,
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
   p_column_name := 'DESCRIPTION';
   p_old := TO_CHAR (:OLD.description);
   p_new := TO_CHAR (:NEW.description);
   pk_steps_aud.ins_dsa_cat_aud (p_aud_date,
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
   p_column_name := 'TYPE_ID';
   p_old := TO_CHAR (:OLD.type_id);
   p_new := TO_CHAR (:NEW.type_id);
   pk_steps_aud.ins_dsa_cat_aud (p_aud_date,
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
   p_old := :OLD.type_id;
   p_new := :NEW.type_id;
   pk_steps_aud.ins_dsa_cat_aud (p_aud_date,
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
END dsa_cat_iud;
/



CREATE OR REPLACE TRIGGER DSA_PAY_iud
   AFTER INSERT OR DELETE OR UPDATE OF ID,
                                       AWARD_INSTALMENT_ID,
                                       DSA_ALLOWANCE_ID,     
                                       PAYEE_TYPE,             
                                       PAYEE_ID,             
                                       AMOUNT,           
                                       PAYMENT_METHOD_ID,                                           
                                       BATCH_DATE,           
                                       PROCESS_DATE,         
                                       DSA_PAYMENT_STATUS_ID, 
                                       PAYMENT_TYPE,         
                                       BATCH_REF,            
                                       RE_ISSUE_FLAG,
                                       LAST_UPDATED_BY 
ON DSA_PAYMENT FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DSA_PAYMENT_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_PAYMENT_aud.table_pkey1%TYPE
                                               := :OLD.ID;
   p_table_pkey2    DSA_PAYMENT_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_PAYMENT_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_PAYMENT_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_PAYMENT_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_PAYMENT_aud.OLD%TYPE            := NULL;
   p_new            DSA_PAYMENT_aud.NEW%TYPE            := NULL;
   p_action         DSA_PAYMENT_aud.action%TYPE         := NULL;
   p_username       DSA_PAYMENT_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_PAYMENT_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_PAYMENT_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_PAYMENT_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'ID';
   p_old := :OLD.id;
   p_new := :NEW.id;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'AWARD_INSTALMENT_ID';
   p_old := :OLD.AWARD_INSTALMENT_ID;
   p_new := :NEW.AWARD_INSTALMENT_ID;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'DSA_ALLOWANCE_ID';
   p_old := :OLD.DSA_ALLOWANCE_ID;
   p_new := :NEW.DSA_ALLOWANCE_ID;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'PAYEE_TYPE';
   p_old := :OLD.PAYEE_TYPE;
   p_new := :NEW.PAYEE_TYPE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'AMOUNT';
   p_old := :OLD.AMOUNT;
   p_new := :NEW.AMOUNT;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_METHOD_ID';
   p_old := :OLD.PAYMENT_METHOD_ID;
   p_new := :NEW.PAYMENT_METHOD_ID;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'BATCH_DATE';
   p_old := :OLD.BATCH_DATE;
   p_new := :NEW.BATCH_DATE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'PROCESS_DATE';
   p_old := :OLD.PROCESS_DATE;
   p_new := :NEW.PROCESS_DATE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'DSA_PAYMENT_STATUS_ID';
   p_old := :OLD.DSA_PAYMENT_STATUS_ID;
   p_new := :NEW.DSA_PAYMENT_STATUS_ID;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_TYPE';
   p_old := :OLD.PAYMENT_TYPE;
   p_new := :NEW.PAYMENT_TYPE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
p_column_name := 'BATCH_REF';
   p_old := :OLD.BATCH_REF;
   p_new := :NEW.BATCH_REF;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'RE_ISSUE_FLAG';
   p_old := :OLD.RE_ISSUE_FLAG;
   p_new := :NEW.RE_ISSUE_FLAG;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'AMOUNT_RATE';
   p_old := :OLD.AMOUNT_RATE;
   p_new := :NEW.AMOUNT_RATE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'REFERENCE';
   p_old := :OLD.REFERENCE;
   p_new := :NEW.REFERENCE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'PERIOD_START_DATE';
   p_old := :OLD.PERIOD_START_DATE;
   p_new := :NEW.PERIOD_START_DATE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'PERIOD_END_DATE';
   p_old := :OLD.PERIOD_END_DATE;
   p_new := :NEW.PERIOD_END_DATE;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'RECEIPT_REQUIRED';
   p_old := :OLD.RECEIPT_REQUIRED;
   p_new := :NEW.RECEIPT_REQUIRED;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'RECEIPT_RECEIVED';
   p_old := :OLD.RECEIPT_RECEIVED;
   p_new := :NEW.RECEIPT_RECEIVED;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'RECEIPT_AMOUNT';
   p_old := :OLD.RECEIPT_AMOUNT;
   p_new := :NEW.RECEIPT_AMOUNT;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'INVOICE_REF';
   p_old := :OLD.INVOICE_REF;
   p_new := :NEW.INVOICE_REF;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   p_column_name := 'NOTES';
   p_old := :OLD.NOTES;
   p_new := :NEW.NOTES;
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
   pk_steps_aud.ins_DSA_PAY_aud (p_aud_date,
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
END DSA_PAY_iud;
/



CREATE OR REPLACE TRIGGER dsa_pay_stat_iud
   AFTER INSERT OR DELETE OR UPDATE OF DSA_PAYMENT_STATUS_id,
                                       status,
                                       last_updated_by
                                       
ON DSA_PAYMENT_STATUS FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DSA_PAYMENT_STATUS_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_PAYMENT_STATUS_aud.table_pkey1%TYPE
                                               := :OLD.DSA_PAYMENT_STATUS_ID;
   p_table_pkey2    DSA_PAYMENT_STATUS_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_PAYMENT_STATUS_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_PAYMENT_STATUS_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_PAYMENT_STATUS_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_PAYMENT_STATUS_aud.OLD%TYPE            := NULL;
   p_new            DSA_PAYMENT_STATUS_aud.NEW%TYPE            := NULL;
   p_action         DSA_PAYMENT_STATUS_aud.action%TYPE         := NULL;
   p_username       DSA_PAYMENT_STATUS_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_PAYMENT_STATUS_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_PAYMENT_STATUS_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_PAYMENT_STATUS_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DSA_PAYMENT_STATUS_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DSA_PAYMENT_STATUS_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'DSA_PAYMENT_STATUS_ID';
   p_old := :OLD.DSA_PAYMENT_STATUS_id;
   p_new := :NEW.DSA_PAYMENT_STATUS_id;
   pk_steps_aud.ins_DSA_PAY_STAT_aud (p_aud_date,
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
   p_column_name := 'STATUS';
   p_old := TO_CHAR (:OLD.status);
   p_new := TO_CHAR (:NEW.status);
   pk_steps_aud.ins_DSA_PAY_STAT_aud (p_aud_date,
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
   pk_steps_aud.ins_DSA_PAY_STAT_aud (p_aud_date,
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
END DSA_PAY_STAT_iud;
/



CREATE OR REPLACE TRIGGER dsa_ref_iud
AFTER INSERT OR DELETE OR UPDATE OF DSA_REFERRAL_REASON_id,
                                       reason,
                                       last_updated_by
ON DSA_REFERRAL_REASON FOR EACH ROW
DECLARE
   p_aud_date       DATE                                 := SYSDATE;
   p_column_name    DSA_REFERRAL_REASON_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_REFERRAL_REASON_aud.table_pkey1%TYPE := :OLD.DSA_REFERRAL_REASON_id;
   p_table_pkey2    DSA_REFERRAL_REASON_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_REFERRAL_REASON_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_REFERRAL_REASON_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_REFERRAL_REASON_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_REFERRAL_REASON_aud.OLD%TYPE            := NULL;
   p_new            DSA_REFERRAL_REASON_aud.NEW%TYPE            := NULL;
   p_action         DSA_REFERRAL_REASON_aud.action%TYPE         := NULL;
   p_username       DSA_REFERRAL_REASON_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_REFERRAL_REASON_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_REFERRAL_REASON_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_REFERRAL_REASON_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DSA_REFERRAL_REASON_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DSA_REFERRAL_REASON_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'DSA_REFERRAL_REASON_ID';
   p_old := :OLD.DSA_REFERRAL_REASON_id;
   p_new := :NEW.DSA_REFERRAL_REASON_id;
   pk_steps_aud.ins_dsa_ref_aud (p_aud_date,
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
   p_column_name := 'REASON';
   p_old := :OLD.REASON;
   p_new := :NEW.REASON;
   pk_steps_aud.ins_dsa_ref_aud (p_aud_date,
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
   pk_steps_aud.ins_dsa_ref_aud (p_aud_date,
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
END dsa_ref_iud;
/



CREATE OR REPLACE TRIGGER dsa_rej_iud
AFTER INSERT OR DELETE OR UPDATE OF DSA_REJECTION_REASON_id,
                                       reason,
                                       last_updated_by
ON DSA_REJECTION_REASON FOR EACH ROW
DECLARE
   p_aud_date       DATE                                 := SYSDATE;
   p_column_name    DSA_REJECTION_REASON_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_REJECTION_REASON_aud.table_pkey1%TYPE := :OLD.DSA_REJECTION_REASON_id;
   p_table_pkey2    DSA_REJECTION_REASON_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_REJECTION_REASON_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_REJECTION_REASON_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_REJECTION_REASON_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_REJECTION_REASON_aud.OLD%TYPE            := NULL;
   p_new            DSA_REJECTION_REASON_aud.NEW%TYPE            := NULL;
   p_action         DSA_REJECTION_REASON_aud.action%TYPE         := NULL;
   p_username       DSA_REJECTION_REASON_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_REJECTION_REASON_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_REJECTION_REASON_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_REJECTION_REASON_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DSA_REJECTION_REASON_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DSA_REJECTION_REASON_id;
      p_username := :OLD.LAST_UPDATED_BY;   
   END IF;

   p_column_name := 'DSA_REJECTION_REASON_ID';
   p_old := :OLD.DSA_REJECTION_REASON_id;
   p_new := :NEW.DSA_REJECTION_REASON_id;
   pk_steps_aud.ins_dsa_rej_aud (p_aud_date,
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
   p_column_name := 'REASON';
   p_old := :OLD.REASON;
   p_new := :NEW.REASON;
   pk_steps_aud.ins_dsa_rej_aud (p_aud_date,
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
   pk_steps_aud.ins_dsa_rej_aud (p_aud_date,
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
END dsa_rej_iud;
/



CREATE OR REPLACE TRIGGER DSA_STUD_TYPE_iud
   AFTER INSERT OR DELETE OR UPDATE OF DSA_STUDENT_TYPE_id,
                                       type,
                                       last_updated_by
                                       
ON DSA_STUDENT_TYPE FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DSA_STUDENT_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_STUDENT_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.DSA_STUDENT_TYPE_ID;
   p_table_pkey2    DSA_STUDENT_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_STUDENT_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_STUDENT_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_STUDENT_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_STUDENT_TYPE_aud.OLD%TYPE            := NULL;
   p_new            DSA_STUDENT_TYPE_aud.NEW%TYPE            := NULL;
   p_action         DSA_STUDENT_TYPE_aud.action%TYPE         := NULL;
   p_username       DSA_STUDENT_TYPE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_STUDENT_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_STUDENT_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_STUDENT_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DSA_STUDENT_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DSA_STUDENT_TYPE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'DSA_STUDENT_TYPE_ID';
   p_old := :OLD.DSA_STUDENT_TYPE_id;
   p_new := :NEW.DSA_STUDENT_TYPE_id;
   pk_steps_aud.ins_DSA_STUD_TYPE_aud (p_aud_date,
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
   p_column_name := 'TYPE';
   p_old := TO_CHAR (:OLD.type);
   p_new := TO_CHAR (:NEW.type);
   pk_steps_aud.ins_DSA_STUD_TYPE_aud (p_aud_date,
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
   pk_steps_aud.ins_DSA_STUD_TYPE_aud (p_aud_date,
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
END DSA_STUD_TYPE_iud;
/



CREATE OR REPLACE TRIGGER DSA_TYPE_iud
   AFTER INSERT OR DELETE OR UPDATE OF DSA_TYPE_id,
                                       type,
                                       last_updated_by
                                       
ON DSA_TYPE FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DSA_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.DSA_TYPE_ID;
   p_table_pkey2    DSA_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_TYPE_aud.OLD%TYPE            := NULL;
   p_new            DSA_TYPE_aud.NEW%TYPE            := NULL;
   p_action         DSA_TYPE_aud.action%TYPE         := NULL;
   p_username       DSA_TYPE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DSA_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DSA_TYPE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'DSA_TYPE_ID';
   p_old := :OLD.DSA_TYPE_id;
   p_new := :NEW.DSA_TYPE_id;
   pk_steps_aud.ins_DSA_TYPE_aud (p_aud_date,
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
   p_column_name := 'CODE';
   p_old := TO_CHAR (:OLD.code);
   p_new := TO_CHAR (:NEW.code);
   pk_steps_aud.ins_DSA_TYPE_aud (p_aud_date,
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
   p_column_name := 'TYPE';
   p_old := TO_CHAR (:OLD.type);
   p_new := TO_CHAR (:NEW.type);
   pk_steps_aud.ins_DSA_TYPE_aud (p_aud_date,
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
   pk_steps_aud.ins_DSA_TYPE_aud (p_aud_date,
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
   
END DSA_TYPE_iud;
/



CREATE OR REPLACE TRIGGER dsa_work_type_iud
   AFTER INSERT OR DELETE OR UPDATE OF dsa_work_type_id,
                                       type,
                                       last_updated_by
                                       
ON DSA_WORK_TYPE FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DSA_WORK_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_WORK_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.DSA_WORK_TYPE_ID;
   p_table_pkey2    DSA_WORK_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_WORK_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_WORK_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_WORK_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_WORK_TYPE_aud.OLD%TYPE            := NULL;
   p_new            DSA_WORK_TYPE_aud.NEW%TYPE            := NULL;
   p_action         DSA_WORK_TYPE_aud.action%TYPE         := NULL;
   p_username       DSA_WORK_TYPE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_WORK_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_WORK_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_WORK_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DSA_WORK_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DSA_WORK_TYPE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'DSA_WORK_TYPE_ID';
   p_old := :OLD.DSA_WORK_TYPE_id;
   p_new := :NEW.DSA_WORK_TYPE_id;
   pk_steps_aud.ins_dsa_wt_aud (p_aud_date,
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
   p_column_name := 'TYPE';
   p_old := TO_CHAR (:OLD.type);
   p_new := TO_CHAR (:NEW.type);
   pk_steps_aud.ins_dsa_wt_aud (p_aud_date,
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
   pk_steps_aud.ins_dsa_wt_aud (p_aud_date,
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
   
END dsa_work_type_iud;
/



CREATE OR REPLACE TRIGGER DUP_BANK_REA_iud
   AFTER INSERT OR DELETE OR UPDATE OF DUP_BANK_REASON_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON DUP_BANK_REASON    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DUP_BANK_REASON_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DUP_BANK_REASON_aud.table_pkey1%TYPE
                                               := :OLD.DUP_BANK_REASON_id;
   p_table_pkey2    DUP_BANK_REASON_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DUP_BANK_REASON_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DUP_BANK_REASON_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DUP_BANK_REASON_aud.table_pkey5%TYPE    := NULL;
   p_old            DUP_BANK_REASON_aud.OLD%TYPE            := NULL;
   p_new            DUP_BANK_REASON_aud.NEW%TYPE            := NULL;
   p_action         DUP_BANK_REASON_aud.action%TYPE         := NULL;
   p_username       DUP_BANK_REASON_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DUP_BANK_REASON_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DUP_BANK_REASON_aud.inst_code%TYPE      := NULL;
   p_session_code   DUP_BANK_REASON_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DUP_BANK_REASON_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DUP_BANK_REASON_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'DUP_BANK_REASON_ID';
   p_old := :OLD.DUP_BANK_REASON_id;
   p_new := :NEW.DUP_BANK_REASON_id;
   pk_steps_aud.ins_DUP_BANK_REA_aud (p_aud_date,
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
   pk_steps_aud.ins_DUP_BANK_REA_aud (p_aud_date,
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
   pk_steps_aud.ins_DUP_BANK_REA_aud (p_aud_date,
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
   pk_steps_aud.ins_DUP_BANK_REA_aud (p_aud_date,
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
   pk_steps_aud.ins_DUP_BANK_REA_aud (p_aud_date,
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
END DUP_BANK_REA_iud;
/



CREATE OR REPLACE TRIGGER emp_stat_iud
   AFTER INSERT OR DELETE OR UPDATE OF EMPLOYMENT_STATUS_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON EMPLOYMENT_STATUS    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    EMPLOYMENT_STATUS_aud.column_name%TYPE    := NULL;
   p_table_pkey1    EMPLOYMENT_STATUS_aud.table_pkey1%TYPE
                                               := :OLD.EMPLOYMENT_STATUS_id;
   p_table_pkey2    EMPLOYMENT_STATUS_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    EMPLOYMENT_STATUS_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    EMPLOYMENT_STATUS_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    EMPLOYMENT_STATUS_aud.table_pkey5%TYPE    := NULL;
   p_old            EMPLOYMENT_STATUS_aud.OLD%TYPE            := NULL;
   p_new            EMPLOYMENT_STATUS_aud.NEW%TYPE            := NULL;
   p_action         EMPLOYMENT_STATUS_aud.action%TYPE         := NULL;
   p_username       EMPLOYMENT_STATUS_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    EMPLOYMENT_STATUS_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      EMPLOYMENT_STATUS_aud.inst_code%TYPE      := NULL;
   p_session_code   EMPLOYMENT_STATUS_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.EMPLOYMENT_STATUS_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.EMPLOYMENT_STATUS_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'EMPLOYMENT_STATUS_ID';
   p_old := :OLD.EMPLOYMENT_STATUS_id;
   p_new := :NEW.EMPLOYMENT_STATUS_id;
   pk_steps_aud.ins_emp_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_emp_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_emp_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_emp_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_emp_stat_aud (p_aud_date,
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
END emp_stat_iud;
/



CREATE OR REPLACE TRIGGER fee_loa_type_iud
   AFTER INSERT OR DELETE OR UPDATE OF FEE_LOAN_TYPE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON FEE_LOAN_TYPE    FOR EACH ROW
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



CREATE OR REPLACE TRIGGER fin_rev_jou_iud
   AFTER INSERT OR DELETE OR UPDATE OF JOURNAL_ID,
                                       JOURNAL_TYPE,
                                       CUSTOMER,
                                       DEBIT_VALUE,
                                       CREDIT_VALUE,
                                       AWARD_TYPE,
                                       REASON,
                                       BATCH_DATE,
                                       BATCH_REFERENCE,
                                       LAST_UPDATED_BY         
ON FINANCE_REVERSAL_JOURNAL FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    FINANCE_REVERSAL_JOURNAL_aud.column_name%TYPE    := NULL;
   p_table_pkey1    FINANCE_REVERSAL_JOURNAL_aud.table_pkey1%TYPE
                                               := :OLD.JOURNAL_ID;
   p_table_pkey2    FINANCE_REVERSAL_JOURNAL_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    FINANCE_REVERSAL_JOURNAL_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    FINANCE_REVERSAL_JOURNAL_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    FINANCE_REVERSAL_JOURNAL_aud.table_pkey5%TYPE    := NULL;
   p_old            FINANCE_REVERSAL_JOURNAL_aud.OLD%TYPE            := NULL;
   p_new            FINANCE_REVERSAL_JOURNAL_aud.NEW%TYPE            := NULL;
   p_action         FINANCE_REVERSAL_JOURNAL_aud.action%TYPE         := NULL;
   p_username       FINANCE_REVERSAL_JOURNAL_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    FINANCE_REVERSAL_JOURNAL_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      FINANCE_REVERSAL_JOURNAL_aud.inst_code%TYPE      := NULL;
   p_session_code   FINANCE_REVERSAL_JOURNAL_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.JOURNAL_ID;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.JOURNAL_ID;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'JOURNAL_ID';
   p_old := :OLD.JOURNAL_ID;
   p_new := :NEW.JOURNAL_ID;
   pk_steps_aud.ins_fin_rev_jou_aud (p_aud_date,
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
   p_column_name := 'JOURNAL_TYPE';
   p_old := :OLD.JOURNAL_TYPE;
   p_new := :NEW.JOURNAL_TYPE;
   pk_steps_aud.ins_fin_rev_jou_aud (p_aud_date,
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
   p_column_name := 'CUSTOMER';
   p_old := :OLD.CUSTOMER;
   p_new := :NEW.CUSTOMER;
   pk_steps_aud.ins_fin_rev_jou_aud (p_aud_date,
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
   p_column_name := 'DEBIT_VALUE';
   p_old := :OLD.DEBIT_VALUE;
   p_new := :NEW.DEBIT_VALUE;
   pk_steps_aud.ins_fin_rev_jou_aud (p_aud_date,
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
   p_column_name := 'CREDIT_VALUE';
   p_old := :OLD.CREDIT_VALUE;
   p_new := :NEW.CREDIT_VALUE;
   pk_steps_aud.ins_fin_rev_jou_aud (p_aud_date,
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
   p_column_name := 'AWARD_TYPE';
   p_old := :OLD.AWARD_TYPE;
   p_new := :NEW.AWARD_TYPE;
   pk_steps_aud.ins_fin_rev_jou_aud (p_aud_date,
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
   p_column_name := 'REASON';
   p_old := :OLD.REASON;
   p_new := :NEW.REASON;
   pk_steps_aud.ins_fin_rev_jou_aud (p_aud_date,
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
   p_column_name := 'BATCH_DATE';
   p_old := :OLD.BATCH_DATE;
   p_new := :NEW.BATCH_DATE;
   pk_steps_aud.ins_fin_rev_jou_aud (p_aud_date,
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
   p_column_name := 'BATCH_REFERENCE';
   p_old := :OLD.BATCH_REFERENCE;
   p_new := :NEW.BATCH_REFERENCE;
   pk_steps_aud.ins_fin_rev_jou_aud (p_aud_date,
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
   pk_steps_aud.ins_fin_rev_jou_aud (p_aud_date,
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
      
END fin_rev_jou_iud;
/



CREATE OR REPLACE TRIGGER fpd_iud
   AFTER INSERT OR DELETE OR UPDATE OF fee_payment_date_id, pay_date, last_updated_by
   ON fee_payment_date
   FOR EACH ROW
DECLARE
   p_aud_date       DATE                                     := SYSDATE;
   p_column_name    fee_payment_date_aud.column_name%TYPE    := NULL;
   p_table_pkey1    fee_payment_date_aud.table_pkey1%TYPE := :OLD.fee_payment_date_id;
   p_table_pkey2    fee_payment_date_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    fee_payment_date_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    fee_payment_date_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    fee_payment_date_aud.table_pkey5%TYPE    := NULL;
   p_old            fee_payment_date_aud.OLD%TYPE            := NULL;
   p_new            fee_payment_date_aud.NEW%TYPE            := NULL;
   p_action         fee_payment_date_aud.action%TYPE         := NULL;
   p_username       fee_payment_date_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    fee_payment_date_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      fee_payment_date_aud.inst_code%TYPE      := NULL;
   p_session_code   fee_payment_date_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.fee_payment_date_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.fee_payment_date_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'FEE_PAYMENT_DATE_ID';
   p_old := :OLD.fee_payment_date_id;
   p_new := :NEW.fee_payment_date_id;
   pk_steps_aud.ins_fpd_aud (p_aud_date,
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
   
   p_column_name := 'PAY_DATE';
   p_old := :OLD.pay_date;
   p_new := :NEW.pay_date;
   pk_steps_aud.ins_fpd_aud (p_aud_date,
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
   pk_steps_aud.ins_fpd_aud (p_aud_date,
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
END fpd_iud;
/



CREATE OR REPLACE TRIGGER jac_iud
   AFTER INSERT OR DELETE OR UPDATE OF all_registered,
                                       ja_case_type,
                                       no_saas_students,
                                       no_non_saas_children,
                                       no_non_saas_parents,
                                       last_updated_by
   ON JA_CASE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                            := SYSDATE;
   p_column_name    ja_case_aud.column_name%TYPE    := NULL;
   p_table_pkey1    ja_case_aud.table_pkey1%TYPE    := :OLD.ja_case_id;
   p_table_pkey2    ja_case_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    ja_case_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    ja_case_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    ja_case_aud.table_pkey5%TYPE    := NULL;
   p_old            ja_case_aud.OLD%TYPE            := NULL;
   p_new            ja_case_aud.NEW%TYPE            := NULL;
   p_action         ja_case_aud.action%TYPE         := NULL;
   p_username       ja_case_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    ja_case_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      ja_case_aud.inst_code%TYPE      := NULL;
   p_session_code   ja_case_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.ja_case_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.ja_case_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'ALL_REGISTERED';
   p_old := TO_CHAR (:OLD.all_registered);
   p_new := TO_CHAR (:NEW.all_registered);
   pk_steps_aud.ins_jac_aud (p_aud_date,
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
   p_column_name := 'JA_CASE_TYPE';
   p_old := TO_CHAR (:OLD.ja_case_type);
   p_new := TO_CHAR (:NEW.ja_case_type);
   pk_steps_aud.ins_jac_aud (p_aud_date,
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
   p_column_name := 'NO_SAAS_STUDENTS';
   p_old := TO_CHAR (:OLD.no_saas_students);
   p_new := TO_CHAR (:NEW.no_saas_students);
   pk_steps_aud.ins_jac_aud (p_aud_date,
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
   p_column_name := 'NO_NON_SAAS_CHILDREN';
   p_old := TO_CHAR (:OLD.no_non_saas_children);
   p_new := TO_CHAR (:NEW.no_non_saas_children);
   pk_steps_aud.ins_jac_aud (p_aud_date,
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
   p_column_name := 'NO_NON_SAAS_PARENTS';
   p_old := TO_CHAR (:OLD.no_non_saas_parents);
   p_new := TO_CHAR (:NEW.no_non_saas_parents);
   pk_steps_aud.ins_jac_aud (p_aud_date,
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
   pk_steps_aud.ins_jac_aud (p_aud_date,
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
END jac_iud;
/



CREATE OR REPLACE TRIGGER joint_app_rel_iud
   AFTER INSERT OR DELETE OR UPDATE OF JOINT_APP_RELATION_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON JOINT_APP_RELATION    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    JOINT_APP_RELATION_aud.column_name%TYPE    := NULL;
   p_table_pkey1    JOINT_APP_RELATION_aud.table_pkey1%TYPE
                                               := :OLD.JOINT_APP_RELATION_id;
   p_table_pkey2    JOINT_APP_RELATION_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    JOINT_APP_RELATION_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    JOINT_APP_RELATION_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    JOINT_APP_RELATION_aud.table_pkey5%TYPE    := NULL;
   p_old            JOINT_APP_RELATION_aud.OLD%TYPE            := NULL;
   p_new            JOINT_APP_RELATION_aud.NEW%TYPE            := NULL;
   p_action         JOINT_APP_RELATION_aud.action%TYPE         := NULL;
   p_username       JOINT_APP_RELATION_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    JOINT_APP_RELATION_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      JOINT_APP_RELATION_aud.inst_code%TYPE      := NULL;
   p_session_code   JOINT_APP_RELATION_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.JOINT_APP_RELATION_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.JOINT_APP_RELATION_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'JOINT_APP_RELATION_ID';
   p_old := :OLD.JOINT_APP_RELATION_id;
   p_new := :NEW.JOINT_APP_RELATION_id;
   pk_steps_aud.ins_joi_app_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_joi_app_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_joi_app_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_joi_app_rel_aud (p_aud_date,
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
   p_old := :OLD.descript;
   p_new := :NEW.descript;
   pk_steps_aud.ins_joi_app_rel_aud (p_aud_date,
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
END joint_app_rel_iud;
/



CREATE OR REPLACE TRIGGER loan_stat_iud
   AFTER INSERT OR DELETE OR UPDATE OF LOAN_STATUS_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON LOAN_STATUS    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    LOAN_STATUS_aud.column_name%TYPE    := NULL;
   p_table_pkey1    LOAN_STATUS_aud.table_pkey1%TYPE
                                               := :OLD.LOAN_STATUS_id;
   p_table_pkey2    LOAN_STATUS_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    LOAN_STATUS_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    LOAN_STATUS_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    LOAN_STATUS_aud.table_pkey5%TYPE    := NULL;
   p_old            LOAN_STATUS_aud.OLD%TYPE            := NULL;
   p_new            LOAN_STATUS_aud.NEW%TYPE            := NULL;
   p_action         LOAN_STATUS_aud.action%TYPE         := NULL;
   p_username       LOAN_STATUS_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    LOAN_STATUS_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      LOAN_STATUS_aud.inst_code%TYPE      := NULL;
   p_session_code   LOAN_STATUS_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.LOAN_STATUS_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.LOAN_STATUS_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'LOAN_STATUS_ID';
   p_old := :OLD.LOAN_STATUS_id;
   p_new := :NEW.LOAN_STATUS_id;
   pk_steps_aud.ins_loan_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_loan_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_loan_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_loan_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_loan_stat_aud (p_aud_date,
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
END loan_stat_iud;
/



CREATE OR REPLACE TRIGGER loc_iud
   AFTER INSERT OR DELETE OR UPDATE OF LOCATION_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON LOCATION    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    LOCATION_aud.column_name%TYPE    := NULL;
   p_table_pkey1    LOCATION_aud.table_pkey1%TYPE
                                               := :OLD.LOCATION_id;
   p_table_pkey2    LOCATION_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    LOCATION_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    LOCATION_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    LOCATION_aud.table_pkey5%TYPE    := NULL;
   p_old            LOCATION_aud.OLD%TYPE            := NULL;
   p_new            LOCATION_aud.NEW%TYPE            := NULL;
   p_action         LOCATION_aud.action%TYPE         := NULL;
   p_username       LOCATION_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    LOCATION_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      LOCATION_aud.inst_code%TYPE      := NULL;
   p_session_code   LOCATION_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.LOCATION_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.LOCATION_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'LOCATION_ID';
   p_old := :OLD.LOCATION_id;
   p_new := :NEW.LOCATION_id;
   pk_steps_aud.ins_loc_aud (p_aud_date,
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
   pk_steps_aud.ins_loc_aud (p_aud_date,
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
   pk_steps_aud.ins_loc_aud (p_aud_date,
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
   pk_steps_aud.ins_loc_aud (p_aud_date,
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
   pk_steps_aud.ins_loc_aud (p_aud_date,
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
END loc_iud;
/



CREATE OR REPLACE TRIGGER mar_stat_iud
   AFTER INSERT OR DELETE OR UPDATE OF MARITAL_STATUS_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON MARITAL_STATUS    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    MARITAL_STATUS_aud.column_name%TYPE    := NULL;
   p_table_pkey1    MARITAL_STATUS_aud.table_pkey1%TYPE
                                               := :OLD.MARITAL_STATUS_id;
   p_table_pkey2    MARITAL_STATUS_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    MARITAL_STATUS_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    MARITAL_STATUS_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    MARITAL_STATUS_aud.table_pkey5%TYPE    := NULL;
   p_old            MARITAL_STATUS_aud.OLD%TYPE            := NULL;
   p_new            MARITAL_STATUS_aud.NEW%TYPE            := NULL;
   p_action         MARITAL_STATUS_aud.action%TYPE         := NULL;
   p_username       MARITAL_STATUS_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    MARITAL_STATUS_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      MARITAL_STATUS_aud.inst_code%TYPE      := NULL;
   p_session_code   MARITAL_STATUS_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.MARITAL_STATUS_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.MARITAL_STATUS_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'MARITAL_STATUS_ID';
   p_old := :OLD.MARITAL_STATUS_id;
   p_new := :NEW.MARITAL_STATUS_id;
   pk_steps_aud.ins_mar_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_mar_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_mar_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_mar_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_mar_stat_aud (p_aud_date,
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
END mar_stat_iud;
/



CREATE OR REPLACE TRIGGER napd_iud
   AFTER INSERT OR DELETE OR UPDATE OF non_pay_date_id, non_pay_date, last_updated_by
   ON non_award_payment_date
   FOR EACH ROW
DECLARE
   p_aud_date       DATE                                           := SYSDATE;
   p_column_name    non_award_payment_date_aud.column_name%TYPE    := NULL;
   p_table_pkey1    non_award_payment_date_aud.table_pkey1%TYPE
                                                      := :OLD.non_pay_date_id;
   p_table_pkey2    non_award_payment_date_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    non_award_payment_date_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    non_award_payment_date_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    non_award_payment_date_aud.table_pkey5%TYPE    := NULL;
   p_old            non_award_payment_date_aud.OLD%TYPE            := NULL;
   p_new            non_award_payment_date_aud.NEW%TYPE            := NULL;
   p_action         non_award_payment_date_aud.action%TYPE         := NULL;
   p_username       non_award_payment_date_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    non_award_payment_date_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      non_award_payment_date_aud.inst_code%TYPE      := NULL;
   p_session_code   non_award_payment_date_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.non_pay_date_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.non_pay_date_id;
      p_username := :OLD.last_updated_by;
   END IF;
   
   p_column_name := 'NON_PAY_DATE_ID';
   p_old := :OLD.non_pay_date_id;
   p_new := :NEW.non_pay_date_id;
   pk_steps_aud.ins_napd_aud (p_aud_date,
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
   p_column_name := 'NON_PAY_DATE';
   p_old := :OLD.non_pay_date;
   p_new := :NEW.non_pay_date;
   pk_steps_aud.ins_napd_aud (p_aud_date,
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
   pk_steps_aud.ins_napd_aud (p_aud_date,
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
END napd_iud;
/



CREATE OR REPLACE TRIGGER nom_iud
   AFTER INSERT OR DELETE OR UPDATE OF NOMINEE_id,
                                       FORENAME,
                                       SURNAME,
                                       COMPANY_NAME,
                                       PAYEE_NAME,
                                       HOUSE_NO_NAME,
                                       ADDR_L1,
                                       ADDR_L2,
                                       ADDR_L3,
                                       ADDR_L4,
                                       POST_CODE,
                                       TELEPHONE_NO,
                                       ACCOUNT_NO,
                                       SORT_CODE,
                                       PAYMENT_METHOD,
                                       LAST_UPDATED_BY
   ON NOMINEE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    NOMINEE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    NOMINEE_aud.table_pkey1%TYPE
                                               := :OLD.NOMINEE_id;
   p_table_pkey2    NOMINEE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    NOMINEE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    NOMINEE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    NOMINEE_aud.table_pkey5%TYPE    := NULL;
   p_old            NOMINEE_aud.OLD%TYPE            := NULL;
   p_new            NOMINEE_aud.NEW%TYPE            := NULL;
   p_action         NOMINEE_aud.action%TYPE         := NULL;
   p_username       NOMINEE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    NOMINEE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      NOMINEE_aud.inst_code%TYPE      := NULL;
   p_session_code   NOMINEE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.NOMINEE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.NOMINEE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'NOMINEE_ID';
   p_old := :OLD.NOMINEE_id;
   p_new := :NEW.NOMINEE_id;
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'FORENAME';
   p_old := TO_CHAR (:OLD.forename);
   p_new := TO_CHAR (:NEW.forename);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_old := TO_CHAR (:OLD.surname);
   p_new := TO_CHAR (:NEW.surname);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'COMPANY_NAME';
   p_old := TO_CHAR (:OLD.company_name);
   p_new := TO_CHAR (:NEW.company_name);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'PAYEE_NAME';
   p_old := TO_CHAR (:OLD.payee_name);
   p_new := TO_CHAR (:NEW.payee_name);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_old := TO_CHAR (:OLD.house_no_name);
   p_new := TO_CHAR (:NEW.house_no_name);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'ADDR_L1';
   p_old := TO_CHAR (:OLD.addr_l1);
   p_new := TO_CHAR (:NEW.addr_l1);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_old := TO_CHAR (:OLD.addr_l2);
   p_new := TO_CHAR (:NEW.addr_l2);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_old := TO_CHAR (:OLD.addr_l3);
   p_new := TO_CHAR (:NEW.addr_l3);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_old := TO_CHAR (:OLD.addr_l4);
   p_new := TO_CHAR (:NEW.addr_l4);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_old := TO_CHAR (:OLD.post_code);
   p_new := TO_CHAR (:NEW.post_code);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'TELEPHONE_NO';
   p_old := TO_CHAR (:OLD.telephone_no);
   p_new := TO_CHAR (:NEW.telephone_no);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'ACCOUNT_NO';
   p_old := TO_CHAR (:OLD.account_no);
   p_new := TO_CHAR (:NEW.account_no);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'SORT_CODE';
   p_old := TO_CHAR (:OLD.sort_code);
   p_new := TO_CHAR (:NEW.sort_code);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_METHOD';
   p_old := TO_CHAR (:OLD.payment_method);
   p_new := TO_CHAR (:NEW.payment_method);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
END nom_iud;
/



CREATE OR REPLACE TRIGGER NO_NINO_REA_iud
   AFTER INSERT OR DELETE OR UPDATE OF NO_NINO_REASON_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON NO_NINO_REASON    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    NO_NINO_REASON_aud.column_name%TYPE    := NULL;
   p_table_pkey1    NO_NINO_REASON_aud.table_pkey1%TYPE
                                               := :OLD.NO_NINO_REASON_id;
   p_table_pkey2    NO_NINO_REASON_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    NO_NINO_REASON_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    NO_NINO_REASON_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    NO_NINO_REASON_aud.table_pkey5%TYPE    := NULL;
   p_old            NO_NINO_REASON_aud.OLD%TYPE            := NULL;
   p_new            NO_NINO_REASON_aud.NEW%TYPE            := NULL;
   p_action         NO_NINO_REASON_aud.action%TYPE         := NULL;
   p_username       NO_NINO_REASON_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    NO_NINO_REASON_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      NO_NINO_REASON_aud.inst_code%TYPE      := NULL;
   p_session_code   NO_NINO_REASON_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.NO_NINO_REASON_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.NO_NINO_REASON_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'NO_NINO_REASON_ID';
   p_old := :OLD.NO_NINO_REASON_id;
   p_new := :NEW.NO_NINO_REASON_id;
   pk_steps_aud.ins_NO_NINO_REA_aud (p_aud_date,
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
   pk_steps_aud.ins_NO_NINO_REA_aud (p_aud_date,
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
   pk_steps_aud.ins_NO_NINO_REA_aud (p_aud_date,
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
   pk_steps_aud.ins_NO_NINO_REA_aud (p_aud_date,
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
   pk_steps_aud.ins_NO_NINO_REA_aud (p_aud_date,
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
END NO_NINO_REA_iud;
/



CREATE OR REPLACE TRIGGER oth_loa_type_iud
   AFTER INSERT OR DELETE OR UPDATE OF OTHER_LOAN_TYPE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON OTHER_LOAN_TYPE    FOR EACH ROW
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



CREATE OR REPLACE TRIGGER pay_err_iud
   AFTER INSERT OR DELETE OR UPDATE OF   PAY_ERR_ID,
                                         BATCH_REF,
                                         AWARD_INSTALMENT_ID,
                                         ERROR_TYPE,
                                         ERROR_MODULE,
                                         OPERATION,
                                         ERROR_CODE,
                                         ERROR_DATE,
                                         ERROR_MSG,
                                         INST_CODE,
                                         STUD_REF_NO,
                                         PAYMENT_DATE,
                                         LAST_UPDATED_BY
ON PAYMENT_ERRORS FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    PAYMENT_ERRORS_aud.column_name%TYPE    := NULL;
   p_table_pkey1    PAYMENT_ERRORS_aud.table_pkey1%TYPE
                                               := :OLD.PAY_ERR_ID;
   p_table_pkey2    PAYMENT_ERRORS_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    PAYMENT_ERRORS_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    PAYMENT_ERRORS_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    PAYMENT_ERRORS_aud.table_pkey5%TYPE    := NULL;
   p_old            PAYMENT_ERRORS_aud.OLD%TYPE            := NULL;
   p_new            PAYMENT_ERRORS_aud.NEW%TYPE            := NULL;
   p_action         PAYMENT_ERRORS_aud.action%TYPE         := NULL;
   p_username       PAYMENT_ERRORS_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    PAYMENT_ERRORS_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      PAYMENT_ERRORS_aud.inst_code%TYPE      := NULL;
   p_session_code   PAYMENT_ERRORS_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.PAY_ERR_ID;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.PAY_ERR_ID;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'PAY_ERR_ID';
   p_old := :OLD.pay_err_id;
   p_new := :NEW.pay_err_id;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'BATCH_REF';
   p_old := :OLD.BATCH_REF;
   p_new := :NEW.BATCH_REF;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'AWARD_INSTALMENT_ID';
   p_old := :OLD.AWARD_INSTALMENT_ID;
   p_new := :NEW.AWARD_INSTALMENT_ID;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'ERROR_TYPE';
   p_old := :OLD.ERROR_TYPE;
   p_new := :NEW.ERROR_TYPE;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'ERROR_MODULE';
   p_old := :OLD.ERROR_MODULE;
   p_new := :NEW.ERROR_MODULE;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'OPERATION';
   p_old := :OLD.OPERATION;
   p_new := :NEW.OPERATION;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'ERROR_CODE';
   p_old := :OLD.ERROR_CODE;
   p_new := :NEW.ERROR_CODE;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'ERROR_DATE';
   p_old := :OLD.ERROR_DATE;
   p_new := :NEW.ERROR_DATE;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'ERROR_MSG';
   p_old := :OLD.ERROR_MSG;
   p_new := :NEW.ERROR_MSG;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'INST_CODE';
   p_old := :OLD.INST_CODE;
   p_new := :NEW.INST_CODE;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'STUD_REF_NO';
   p_old := :OLD.STUD_REF_NO;
   p_new := :NEW.STUD_REF_NO;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_DATE';
   p_old := :OLD.PAYMENT_DATE;
   p_new := :NEW.PAYMENT_DATE;
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_err_aud (p_aud_date,
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
   
END pay_err_iud;
/



CREATE OR REPLACE TRIGGER pay_inst_iud
   AFTER INSERT OR DELETE OR UPDATE OF PAYMENT_INSTALMENT_ID,
                                       BATCH_REF,
                                       PAYEE_PAYMENT_ID,
                                       ADI_JOURNAL_LINE_ID,
                                       ADI_JOURNAL_ID,
                                       AWARD_INSTALMENT_ID,
                                       PAYEE_ID,
                                       STUD_CRSE_YEAR_ID,
                                       ACCOUNT_NAME,
                                       SORT_CODE,
                                       ACCOUNT_NO,
                                       INST_CODE,
                                       PAYMENT_ADDR,
                                       PAYMENT_AMOUNT,
                                       PAYMENT_METHOD,
                                       PAYMENT_DATE,
                                       RETURNED_DATE,
                                       CURRENCY,
                                       PAYMENT_STATUS,
                                       PROCESS_DATE,
                                       ENTITY,
                                       COST_CENTRE,
                                       ACCOUNT,
                                       PROGRAMME,
                                       PAYMENT_DIRECTION,
                                       PARENT_PAYMENT_FLAG,
                                       PARENT_PAYMENT_INSTALMENT_ID,
                                       REISSUE_FLAG,
                                       PAYMENT_OUT_ID,
                                       LAST_UPDATED_BY
ON PAYMENT_INSTALMENT FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    PAYMENT_INSTALMENT_aud.column_name%TYPE    := NULL;
   p_table_pkey1    PAYMENT_INSTALMENT_aud.table_pkey1%TYPE
                                               := :OLD.PAYMENT_INSTALMENT_ID;
   p_table_pkey2    PAYMENT_INSTALMENT_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    PAYMENT_INSTALMENT_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    PAYMENT_INSTALMENT_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    PAYMENT_INSTALMENT_aud.table_pkey5%TYPE    := NULL;
   p_old            PAYMENT_INSTALMENT_aud.OLD%TYPE            := NULL;
   p_new            PAYMENT_INSTALMENT_aud.NEW%TYPE            := NULL;
   p_action         PAYMENT_INSTALMENT_aud.action%TYPE         := NULL;
   p_username       PAYMENT_INSTALMENT_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    PAYMENT_INSTALMENT_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      PAYMENT_INSTALMENT_aud.inst_code%TYPE      := NULL;
   p_session_code   PAYMENT_INSTALMENT_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.PAYMENT_INSTALMENT_ID;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.PAYMENT_INSTALMENT_ID;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'PAYMENT_INSTALMENT_ID';
   p_old := :OLD.PAYMENT_INSTALMENT_ID;
   p_new := :NEW.PAYMENT_INSTALMENT_ID;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'BATCH_REF';
   p_old := :OLD.BATCH_REF;
   p_new := :NEW.BATCH_REF;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYEE_PAYMENT_ID';
   p_old := :OLD.PAYEE_PAYMENT_ID;
   p_new := :NEW.PAYEE_PAYMENT_ID;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'ADI_JOURNAL_LINE_ID';
   p_old := :OLD.ADI_JOURNAL_LINE_ID;
   p_new := :NEW.ADI_JOURNAL_LINE_ID;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'ADI_JOURNAL_ID';
   p_old := :OLD.ADI_JOURNAL_ID;
   p_new := :NEW.ADI_JOURNAL_ID;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'AWARD_INSTALMENT_ID';
   p_old := :OLD.AWARD_INSTALMENT_ID;
   p_new := :NEW.AWARD_INSTALMENT_ID;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYEE_ID';
   p_old := :OLD.PAYEE_ID;
   p_new := :NEW.PAYEE_ID;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'STUD_CRSE_YEAR_ID';
   p_old := :OLD.STUD_CRSE_YEAR_ID;
   p_new := :NEW.STUD_CRSE_YEAR_ID;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'ACCOUNT_NAME';
   p_old := :OLD.ACCOUNT_NAME;
   p_new := :NEW.ACCOUNT_NAME;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'SORT_CODE';
   p_old := :OLD.SORT_CODE;
   p_new := :NEW.SORT_CODE;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'ACCOUNT_NO';
   p_old := :OLD.ACCOUNT_NO;
   p_new := :NEW.ACCOUNT_NO;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'INST_CODE';
   p_old := :OLD.INST_CODE;
   p_new := :NEW.INST_CODE;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_ADDR';
   p_old := :OLD.PAYMENT_ADDR;
   p_new := :NEW.PAYMENT_ADDR;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_AMOUNT';
   p_old := :OLD.PAYMENT_AMOUNT;
   p_new := :NEW.PAYMENT_AMOUNT;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_METHOD';
   p_old := :OLD.PAYMENT_METHOD;
   p_new := :NEW.PAYMENT_METHOD;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_DATE';
   p_old := :OLD.PAYMENT_DATE;
   p_new := :NEW.PAYMENT_DATE;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'RETURNED_DATE';
   p_old := :OLD.RETURNED_DATE;
   p_new := :NEW.RETURNED_DATE;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'CURRENCY';
   p_old := :OLD.CURRENCY;
   p_new := :NEW.CURRENCY;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_STATUS';
   p_old := :OLD.PAYMENT_STATUS;
   p_new := :NEW.PAYMENT_STATUS;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PROCESS_DATE';
   p_old := :OLD.PROCESS_DATE;
   p_new := :NEW.PROCESS_DATE;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'ENTITY';
   p_old := :OLD.ENTITY;
   p_new := :NEW.ENTITY;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'COST_CENTRE';
   p_old := :OLD.COST_CENTRE;
   p_new := :NEW.COST_CENTRE;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'ACCOUNT';
   p_old := :OLD.ACCOUNT;
   p_new := :NEW.ACCOUNT;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PROGRAMME';
   p_old := :OLD.PROGRAMME;
   p_new := :NEW.PROGRAMME;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_DIRECTION';
   p_old := :OLD.PAYMENT_DIRECTION;
   p_new := :NEW.PAYMENT_DIRECTION;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PARENT_PAYMENT_FLAG';
   p_old := :OLD.PARENT_PAYMENT_FLAG;
   p_new := :NEW.PARENT_PAYMENT_FLAG;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PARENT_PAYMENT_INSTALMENT_ID';
   p_old := :OLD.PARENT_PAYMENT_INSTALMENT_ID;
   p_new := :NEW.PARENT_PAYMENT_INSTALMENT_ID;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'REISSUE_FLAG';
   p_old := :OLD.REISSUE_FLAG;
   p_new := :NEW.REISSUE_FLAG;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_OUT_ID';
   p_old := :OLD.PAYMENT_OUT_ID;
   p_new := :NEW.PAYMENT_OUT_ID;
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_inst_aud (p_aud_date,
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
END pay_inst_iud;
/



CREATE OR REPLACE TRIGGER pay_iud
   AFTER INSERT OR DELETE OR UPDATE OF  PAYEE_ID,
                                        PAYEE_REF_ID,
                                        PAYEE_TYPE,
                                        OUTSTANDING_AMOUNT,
                                        PREV_OUTSTANDING_AMOUNT,
                                        LAST_UPDATED_BY
                                              
ON PAYEE FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    PAYEE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    PAYEE_aud.table_pkey1%TYPE
                                               := :OLD.PAYEE_ID;
   p_table_pkey2    PAYEE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    PAYEE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    PAYEE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    PAYEE_aud.table_pkey5%TYPE    := NULL;
   p_old            PAYEE_aud.OLD%TYPE            := NULL;
   p_new            PAYEE_aud.NEW%TYPE            := NULL;
   p_action         PAYEE_aud.action%TYPE         := NULL;
   p_username       PAYEE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    PAYEE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      PAYEE_aud.inst_code%TYPE      := NULL;
   p_session_code   PAYEE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.PAYEE_ID;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.PAYEE_ID;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'PAYEE_ID';
   p_old := :OLD.PAYEE_ID;
   p_new := :NEW.PAYEE_ID;
   pk_steps_aud.ins_pay_aud (p_aud_date,
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
   p_column_name := 'PAYEE_REF_ID';
   p_old := :OLD.PAYEE_REF_ID;
   p_new := :NEW.PAYEE_REF_ID;
   pk_steps_aud.ins_pay_aud (p_aud_date,
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
   p_column_name := 'PAYEE_TYPE';
   p_old := :OLD.PAYEE_TYPE;
   p_new := :NEW.PAYEE_TYPE;
   pk_steps_aud.ins_pay_aud (p_aud_date,
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
   p_column_name := 'OUTSTANDING_AMOUNT';
   p_old := :OLD.OUTSTANDING_AMOUNT;
   p_new := :NEW.OUTSTANDING_AMOUNT;
   pk_steps_aud.ins_pay_aud (p_aud_date,
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
   p_column_name := 'PREV_OUTSTANDING_AMOUNT';
   p_old := :OLD.PREV_OUTSTANDING_AMOUNT;
   p_new := :NEW.PREV_OUTSTANDING_AMOUNT;
   pk_steps_aud.ins_pay_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_aud (p_aud_date,
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
END pay_iud;
/



CREATE OR REPLACE TRIGGER pay_meth_iud
   AFTER INSERT OR DELETE OR UPDATE OF PAYMENT_METHOD_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON PAYMENT_METHOD    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    PAYMENT_METHOD_aud.column_name%TYPE    := NULL;
   p_table_pkey1    PAYMENT_METHOD_aud.table_pkey1%TYPE
                                               := :OLD.PAYMENT_METHOD_id;
   p_table_pkey2    PAYMENT_METHOD_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    PAYMENT_METHOD_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    PAYMENT_METHOD_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    PAYMENT_METHOD_aud.table_pkey5%TYPE    := NULL;
   p_old            PAYMENT_METHOD_aud.OLD%TYPE            := NULL;
   p_new            PAYMENT_METHOD_aud.NEW%TYPE            := NULL;
   p_action         PAYMENT_METHOD_aud.action%TYPE         := NULL;
   p_username       PAYMENT_METHOD_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    PAYMENT_METHOD_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      PAYMENT_METHOD_aud.inst_code%TYPE      := NULL;
   p_session_code   PAYMENT_METHOD_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.PAYMENT_METHOD_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.PAYMENT_METHOD_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'PAYMENT_METHOD_ID';
   p_old := :OLD.PAYMENT_METHOD_id;
   p_new := :NEW.PAYMENT_METHOD_id;
   pk_steps_aud.ins_pay_meth_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_meth_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_meth_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_meth_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_meth_aud (p_aud_date,
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
END pay_meth_iud;
/



CREATE OR REPLACE TRIGGER pay_paymt_iud
   AFTER INSERT OR DELETE OR UPDATE OF PAYEE_PAYMENT_ID,
                                       BATCH_REF,
                                       CREDIT_BATCH_REF,
                                       PAYEE_ID,
                                       PAYEE_REF_ID,
                                       PAYMENT_AMOUNT,
                                       PAYMENT_METHOD,
                                       PAYMENT_DATE,
                                       RETURNED_DATE,  
                                       CURRENCY,
                                       PAYMENT_STATUS,
                                       PAYMENT_TYPE,
                                       PROCESS_DATE,
                                       LAST_UPDATED_BY
ON PAYEE_PAYMENT FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    PAYEE_PAYMENT_aud.column_name%TYPE    := NULL;
   p_table_pkey1    PAYEE_PAYMENT_aud.table_pkey1%TYPE
                                               := :OLD.PAYEE_PAYMENT_ID;
   p_table_pkey2    PAYEE_PAYMENT_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    PAYEE_PAYMENT_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    PAYEE_PAYMENT_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    PAYEE_PAYMENT_aud.table_pkey5%TYPE    := NULL;
   p_old            PAYEE_PAYMENT_aud.OLD%TYPE            := NULL;
   p_new            PAYEE_PAYMENT_aud.NEW%TYPE            := NULL;
   p_action         PAYEE_PAYMENT_aud.action%TYPE         := NULL;
   p_username       PAYEE_PAYMENT_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    PAYEE_PAYMENT_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      PAYEE_PAYMENT_aud.inst_code%TYPE      := NULL;
   p_session_code   PAYEE_PAYMENT_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.payee_payment_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.payee_payment_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'PAYEE_PAYMENT_ID';
   p_old := :OLD.payee_payment_id;
   p_new := :NEW.payee_payment_id;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'BATCH_REF';
   p_old := :OLD.BATCH_REF;
   p_new := :NEW.BATCH_REF;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'CREDIT_BATCH_REF';
   p_old := :OLD.CREDIT_BATCH_REF;
   p_new := :NEW.CREDIT_BATCH_REF;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'PAYEE_ID';
   p_old := :OLD.PAYEE_ID;
   p_new := :NEW.PAYEE_ID;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'PAYEE_REF_ID';
   p_old := :OLD.PAYEE_REF_ID;
   p_new := :NEW.PAYEE_REF_ID;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_AMOUNT';
   p_old := :OLD.PAYMENT_AMOUNT;
   p_new := :NEW.PAYMENT_AMOUNT;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_METHOD';
   p_old := :OLD.PAYMENT_METHOD;
   p_new := :NEW.PAYMENT_METHOD;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_DATE';
   p_old := :OLD.PAYMENT_DATE;
   p_new := :NEW.PAYMENT_DATE;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'RETURNED_DATE';
   p_old := :OLD.RETURNED_DATE;
   p_new := :NEW.RETURNED_DATE;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'CURRENCY';
   p_old := :OLD.CURRENCY;
   p_new := :NEW.CURRENCY;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_STATUS';
   p_old := :OLD.PAYMENT_STATUS;
   p_new := :NEW.PAYMENT_STATUS;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_TYPE';
   p_old := :OLD.PAYMENT_TYPE;
   p_new := :NEW.PAYMENT_TYPE;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   p_column_name := 'PROCESS_DATE';
   p_old := :OLD.PROCESS_DATE;
   p_new := :NEW.PROCESS_DATE;
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   pk_steps_aud.ins_pay_paymt_aud (p_aud_date,
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
   
END pay_paymt_iud;
/



CREATE OR REPLACE TRIGGER pgce_sub_iud
   AFTER INSERT OR DELETE OR UPDATE OF PGCE_SUBJECT_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON PGCE_SUBJECT    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    PGCE_SUBJECT_aud.column_name%TYPE    := NULL;
   p_table_pkey1    PGCE_SUBJECT_aud.table_pkey1%TYPE
                                               := :OLD.PGCE_SUBJECT_id;
   p_table_pkey2    PGCE_SUBJECT_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    PGCE_SUBJECT_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    PGCE_SUBJECT_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    PGCE_SUBJECT_aud.table_pkey5%TYPE    := NULL;
   p_old            PGCE_SUBJECT_aud.OLD%TYPE            := NULL;
   p_new            PGCE_SUBJECT_aud.NEW%TYPE            := NULL;
   p_action         PGCE_SUBJECT_aud.action%TYPE         := NULL;
   p_username       PGCE_SUBJECT_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    PGCE_SUBJECT_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      PGCE_SUBJECT_aud.inst_code%TYPE      := NULL;
   p_session_code   PGCE_SUBJECT_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.PGCE_SUBJECT_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.PGCE_SUBJECT_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'PGCE_SUBJECT_ID';
   p_old := :OLD.PGCE_SUBJECT_id;
   p_new := :NEW.PGCE_SUBJECT_id;
   pk_steps_aud.ins_pgce_sub_aud (p_aud_date,
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
   pk_steps_aud.ins_pgce_sub_aud (p_aud_date,
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
   pk_steps_aud.ins_pgce_sub_aud (p_aud_date,
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
   pk_steps_aud.ins_pgce_sub_aud (p_aud_date,
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
   pk_steps_aud.ins_pgce_sub_aud (p_aud_date,
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
END pgce_sub_iud;
/



CREATE OR REPLACE TRIGGER res_iud
   AFTER INSERT OR DELETE OR UPDATE OF RESIDENCE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON RESIDENCE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    RESIDENCE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    RESIDENCE_aud.table_pkey1%TYPE
                                               := :OLD.RESIDENCE_id;
   p_table_pkey2    RESIDENCE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    RESIDENCE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    RESIDENCE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    RESIDENCE_aud.table_pkey5%TYPE    := NULL;
   p_old            RESIDENCE_aud.OLD%TYPE            := NULL;
   p_new            RESIDENCE_aud.NEW%TYPE            := NULL;
   p_action         RESIDENCE_aud.action%TYPE         := NULL;
   p_username       RESIDENCE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    RESIDENCE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      RESIDENCE_aud.inst_code%TYPE      := NULL;
   p_session_code   RESIDENCE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.RESIDENCE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.RESIDENCE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'RESIDENCE_ID';
   p_old := :OLD.RESIDENCE_id;
   p_new := :NEW.RESIDENCE_id;
   pk_steps_aud.ins_res_aud (p_aud_date,
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
   pk_steps_aud.ins_res_aud (p_aud_date,
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
   pk_steps_aud.ins_res_aud (p_aud_date,
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
   pk_steps_aud.ins_res_aud (p_aud_date,
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
   pk_steps_aud.ins_res_aud (p_aud_date,
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
END res_iud;
/



CREATE OR REPLACE TRIGGER res_type_iud
   AFTER INSERT OR DELETE OR UPDATE OF RESIDENCE_TYPE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON RESIDENCE_TYPE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    RESIDENCE_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    RESIDENCE_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.RESIDENCE_TYPE_id;
   p_table_pkey2    RESIDENCE_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    RESIDENCE_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    RESIDENCE_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    RESIDENCE_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            RESIDENCE_TYPE_aud.OLD%TYPE            := NULL;
   p_new            RESIDENCE_TYPE_aud.NEW%TYPE            := NULL;
   p_action         RESIDENCE_TYPE_aud.action%TYPE         := NULL;
   p_username       RESIDENCE_TYPE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    RESIDENCE_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      RESIDENCE_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   RESIDENCE_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.RESIDENCE_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.RESIDENCE_TYPE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'RESIDENCE_TYPE_ID';
   p_old := :OLD.RESIDENCE_TYPE_id;
   p_new := :NEW.RESIDENCE_TYPE_id;
   pk_steps_aud.ins_res_type_aud (p_aud_date,
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
   pk_steps_aud.ins_res_type_aud (p_aud_date,
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
   pk_steps_aud.ins_res_type_aud (p_aud_date,
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
   pk_steps_aud.ins_res_type_aud (p_aud_date,
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
   pk_steps_aud.ins_res_type_aud (p_aud_date,
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
END res_type_iud;
/



CREATE OR REPLACE TRIGGER sch_type_iud
   AFTER INSERT OR DELETE OR UPDATE OF SCHEME_TYPE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SCHEME_TYPE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    SCHEME_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    SCHEME_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.SCHEME_TYPE_id;
   p_table_pkey2    SCHEME_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    SCHEME_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    SCHEME_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    SCHEME_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            SCHEME_TYPE_aud.OLD%TYPE            := NULL;
   p_new            SCHEME_TYPE_aud.NEW%TYPE            := NULL;
   p_action         SCHEME_TYPE_aud.action%TYPE         := NULL;
   p_username       SCHEME_TYPE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    SCHEME_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      SCHEME_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   SCHEME_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.SCHEME_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.SCHEME_TYPE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'SCHEME_TYPE_ID';
   p_old := :OLD.SCHEME_TYPE_id;
   p_new := :NEW.SCHEME_TYPE_id;
   pk_steps_aud.ins_sch_type_aud (p_aud_date,
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
   pk_steps_aud.ins_sch_type_aud (p_aud_date,
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
   pk_steps_aud.ins_sch_type_aud (p_aud_date,
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
   pk_steps_aud.ins_sch_type_aud (p_aud_date,
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
   pk_steps_aud.ins_sch_type_aud (p_aud_date,
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
END sch_type_iud;
/



CREATE OR REPLACE TRIGGER SC_BAT_IUD
after    insert or delete or update of DPB_BATCH_REF, 
                                      DPB_COUNT,
                                      DPB_AC_YEAR, 
                                      DPB_AC_PERIOD, 
                                      DPB_TOTAL_PAYMENT, 
                                      DPB_TOTAL_VOLUME, 
                                      DPB_TOTAL_VAT, 
                                      DPB_BATCH_CREATION_DATE, 
                                      DPB_ALLOW_SUSPENSE,  
                                      DPB_VALIDATE_ONLY, 
                                      DPB_STATUS, 
                                      ARC_ID, 
                                      ARC_RESTORE_DATE,
                                      LAST_UPDATED_BY
 
ON SCOAP_BATCHES for    each row
declare
    p_aud_date       DATE                                      := SYSDATE;
        p_column_name    scoap_batches_aud.column_name%TYPE        := NULL;
        p_table_pkey1    scoap_batches_aud.table_pkey1%TYPE        := :OLD.DPB_BATCH_REF;
        p_table_pkey2    scoap_batches_aud.table_pkey2%TYPE    := NULL;
        p_table_pkey3    scoap_batches_aud.table_pkey3%TYPE    := NULL;
        p_table_pkey4    scoap_batches_aud.table_pkey4%TYPE    := NULL;
        p_table_pkey5    scoap_batches_aud.table_pkey5%TYPE    := NULL;
        p_old            scoap_batches_aud.OLD%TYPE            := NULL;
        p_new            scoap_batches_aud.NEW%TYPE            := NULL;
        p_action         scoap_batches_aud.action%TYPE         := NULL;
        p_username       scoap_batches_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
        p_stud_ref_no    scoap_batches_aud.stud_ref_no%TYPE    := NULL;
        p_inst_code      scoap_batches_aud.inst_code%TYPE      := NULL;
        p_session_code   scoap_batches_aud.session_code%TYPE   := NULL;

begin
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DPB_BATCH_REF;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DPB_BATCH_REF;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

    P_COLUMN_NAME     := 'DPB_BATCH_REF';
    P_OLD        := :old.DPB_BATCH_REF;
    P_NEW        := :new.DPB_BATCH_REF;
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_COUNT';
    P_OLD        := to_char(:old.DPB_COUNT);
    P_NEW        := to_char(:new.DPB_COUNT);
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_AC_YEAR';
    P_OLD        := to_char(:old.DPB_AC_YEAR);
    P_NEW        := to_char(:new.DPB_AC_YEAR);
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_AC_PERIOD';
    P_OLD        := to_char(:old.DPB_AC_PERIOD);
    P_NEW        := to_char(:new.DPB_AC_PERIOD);
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_TOTAL_PAYMENT';
    P_OLD        := to_char(:old.DPB_TOTAL_PAYMENT);
    P_NEW        := to_char(:new.DPB_TOTAL_PAYMENT);
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_TOTAL_VOLUME';
    P_OLD        := to_char(:old.DPB_TOTAL_VOLUME);
    P_NEW        := to_char(:new.DPB_TOTAL_VOLUME);
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_TOTAL_VAT';
    P_OLD        := to_char(:old.DPB_TOTAL_VAT);
    P_NEW        := to_char(:new.DPB_TOTAL_VAT);
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_BATCH_CREATION_DATE';
    P_OLD        := to_char(:old.DPB_BATCH_CREATION_DATE,'DD/MM/YYYY HH24:MI');
    P_NEW        := to_char(:new.DPB_BATCH_CREATION_DATE,'DD/MM/YYYY HH24:MI');
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_ALLOW_SUSPENSE';
    P_OLD        := :old.DPB_ALLOW_SUSPENSE;
    P_NEW        := :new.DPB_ALLOW_SUSPENSE;
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_VALIDATE_ONLY';
    P_OLD        := :old.DPB_VALIDATE_ONLY;
    P_NEW        := :new.DPB_VALIDATE_ONLY;
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_STATUS';
    P_OLD        := :old.DPB_STATUS;
    P_NEW        := :new.DPB_STATUS;
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'ARC_ID';
    P_OLD        := to_char(:old.ARC_ID);
    P_NEW        := to_char(:new.ARC_ID);
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'ARC_RESTORE_DATE';
    P_OLD        := to_char(:old.ARC_RESTORE_DATE,'DD/MM/YYYY HH24:MI');
    P_NEW        := to_char(:new.ARC_RESTORE_DATE,'DD/MM/YYYY HH24:MI');
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'LAST_UPDATED_BY';
    P_OLD        := :old.LAST_UPDATED_BY;
    P_NEW        := :new.LAST_UPDATED_BY;
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
end SC_BAT_IUD;
/



CREATE OR REPLACE TRIGGER spo_type_iud
   AFTER INSERT OR DELETE OR UPDATE OF SPOUSE_TYPE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SPOUSE_TYPE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    SPOUSE_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    SPOUSE_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.SPOUSE_TYPE_id;
   p_table_pkey2    SPOUSE_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    SPOUSE_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    SPOUSE_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    SPOUSE_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            SPOUSE_TYPE_aud.OLD%TYPE            := NULL;
   p_new            SPOUSE_TYPE_aud.NEW%TYPE            := NULL;
   p_action         SPOUSE_TYPE_aud.action%TYPE         := NULL;
   p_username       SPOUSE_TYPE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    SPOUSE_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      SPOUSE_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   SPOUSE_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.SPOUSE_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.SPOUSE_TYPE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'SPOUSE_TYPE_ID';
   p_old := :OLD.SPOUSE_TYPE_id;
   p_new := :NEW.SPOUSE_TYPE_id;
   pk_steps_aud.ins_spo_type_aud (p_aud_date,
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
   pk_steps_aud.ins_spo_type_aud (p_aud_date,
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
   pk_steps_aud.ins_spo_type_aud (p_aud_date,
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
   pk_steps_aud.ins_spo_type_aud (p_aud_date,
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
   pk_steps_aud.ins_spo_type_aud (p_aud_date,
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
END spo_type_iud;
/



CREATE OR REPLACE TRIGGER sqd_iud
   AFTER INSERT OR DELETE OR UPDATE OF qa_type, qa_level, last_updated_by
   ON STEPS_QA_DATA    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    steps_qa_data_aud.column_name%TYPE    := NULL;
   p_table_pkey1    steps_qa_data_aud.table_pkey1%TYPE
                                                   := TO_CHAR (:OLD.username);
   p_table_pkey2    steps_qa_data_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    steps_qa_data_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    steps_qa_data_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    steps_qa_data_aud.table_pkey5%TYPE    := NULL;
   p_old            steps_qa_data_aud.OLD%TYPE            := NULL;
   p_new            steps_qa_data_aud.NEW%TYPE            := NULL;
   p_action         steps_qa_data_aud.action%TYPE         := NULL;
   p_username       steps_qa_data_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    steps_qa_data_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      steps_qa_data_aud.inst_code%TYPE      := NULL;
   p_session_code   steps_qa_data_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.username;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.username;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'QA_TYPE';
   p_old := TO_CHAR (:OLD.qa_type);
   p_new := TO_CHAR (:NEW.qa_type);
   pk_steps_aud.ins_sqd_aud (p_aud_date,
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
   p_column_name := 'QA_LEVEL';
   p_old := TO_CHAR (:OLD.qa_level);
   p_new := TO_CHAR (:NEW.qa_level);
   pk_steps_aud.ins_sqd_aud (p_aud_date,
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
   pk_steps_aud.ins_sqd_aud (p_aud_date,
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
END sqd_iud;
/



CREATE OR REPLACE TRIGGER stapp_iud
   AFTER INSERT OR DELETE OR UPDATE OF award_letter_sent_date,
                                       date_calculated,
                                       last_updated_by
   ON STUD_APP_PROG    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    stud_app_prog_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_app_prog_aud.table_pkey1%TYPE    := :OLD.stud_ref_no;
   p_table_pkey2    stud_app_prog_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_app_prog_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_app_prog_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_app_prog_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_app_prog_aud.OLD%TYPE            := NULL;
   p_new            stud_app_prog_aud.NEW%TYPE            := NULL;
   p_action         stud_app_prog_aud.action%TYPE         := NULL;
   p_username       stud_app_prog_aud.username%TYPE       := :NEW.last_updated_by;
   p_stud_ref_no    stud_app_prog_aud.stud_ref_no%TYPE    := :OLD.stud_ref_no;
   p_inst_code      stud_app_prog_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_app_prog_aud.session_code%TYPE   := NULL;
   p_table_name     VARCHAR2 (32)                         := 'STUD_APP_PROG';
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_ref_no;
      p_stud_ref_no := :NEW.stud_ref_no;
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.stud_ref_no;
      p_stud_ref_no := :OLD.stud_ref_no;
      p_username    := :OLD.last_updated_by;
   END IF;

   p_column_name := 'AWARD_LETTER_SENT_DATE';
   p_old := :OLD.award_letter_sent_date;
   p_new := :NEW.award_letter_sent_date;
   pk_steps_aud.ins_stapp_aud (p_aud_date,
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
   p_column_name := 'DATE_CALCULATED';
   p_old := :OLD.date_calculated;
   p_new := :NEW.date_calculated;
   pk_steps_aud.ins_stapp_aud (p_aud_date,
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
   pk_steps_aud.ins_stapp_aud (p_aud_date,
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
END stapp_iud;
/



CREATE OR REPLACE TRIGGER stcy_iud
   AFTER INSERT OR DELETE OR UPDATE OF sal_sent, application_status, inst_change, parent_contrib_exempt,
             award, start_date, withdraw_date, vacation, crse_chg,study_country, snb_grad, award_letter_date, 
             award_letter_no, batch_recalc, dearing, resid_par_cont, 
             resid_spouse_cont,resid_stud_cont, parent_cont, spouse_cont, stud_cont,resid_trav_allow, sml_equip_rqst, 
             sml_equip_approve,lge_equip_descript,lge_equip_approve, lge_equip_rqst, diet_need_descript,disablement_code,
             end_date_abroad,erasmus, diet_need_req,diet_need_approve, non_med_req, 
             non_med_approve,provisional_case,provisional_date,repeat_year, req_dup, session_code, crse_year_no, inst_code, crse_id,
             unconditional, slc1_status, slc2_status,loan_given,latest_crse_ind,auto_calc_date,dsa_fee_descript,dsa_fee_rqst,
             dsa_fee_approve,attend_reqd, attend_confirmed,hei_date_attended, non_att_actioned, non_att_actioned_date, 
             trav_submitted_date,sal_sent_date, sal_dest, variable_fee_override_amount, fee_loan_given, fee_loan_eligibility_only,
             pgce, self_funding, independent, due_ysb_yso_ind, household_resid_income, ben1_total_income, ben2_total_income,
             snb_single_rate, nmsb_session_calc,start_date_abroad, study_abroad, unpaid_sandwich, paid_sandwich, calc_fee, calc_bursary,
             calc_loan, calc_dep_grant, calc_lpg, calc_lpcg, pay_ysb, pgce_edu_level, pgce_subject, first_calc_date, psas_pt, last_updated_by
   ON STUD_CRSE_YEAR    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    stud_crse_year_aud.column_name%TYPE   := NULL;
   p_table_pkey1    stud_crse_year_aud.table_pkey1%TYPE
                                          := TO_CHAR (:OLD.stud_crse_year_id);
   p_table_pkey2    stud_crse_year_aud.table_pkey2%TYPE   := NULL;
   p_table_pkey3    stud_crse_year_aud.table_pkey3%TYPE   := NULL;
   p_table_pkey4    stud_crse_year_aud.table_pkey4%TYPE   := NULL;
   p_table_pkey5    stud_crse_year_aud.table_pkey5%TYPE   := NULL;
   p_old            stud_crse_year_aud.OLD%TYPE           := NULL;
   p_new            stud_crse_year_aud.NEW%TYPE           := NULL;
   p_action         stud_crse_year_aud.action%TYPE        := NULL;
   p_username       stud_crse_year_aud.username%TYPE      := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    stud_crse_year_aud.stud_ref_no%TYPE   := NULL;
   p_inst_code      stud_crse_year_aud.inst_code%TYPE     := NULL;
   p_table_name     VARCHAR2 (32)                         := 'STUD_CRSE_YEAR';
   will_update      VARCHAR2 (1)                          := 'N';
   p_session_code   stud_crse_year.session_code%TYPE     := :NEW.session_code;
   p_dob            stud.dob%TYPE                         := NULL;
   p_initials       stud.initials%TYPE                    := NULL;
   p_forenames      stud.forenames%TYPE                   := NULL;
   p_surname        stud.surname%TYPE                     := NULL;
   p_ni_no          stud.ni_no%TYPE                       := NULL;
   p_mobile         stud.mobile_tel_no%TYPE               := NULL;
   p_email          stud.email_addr%TYPE                  := NULL;
   p_calc           DATE;
   p_sent           DATE;
   v_updated        VARCHAR2 (1)                          := 'N';
--
-----------------------------------------------------------------------------------------------------------------------------
--
   v_result         VARCHAR2 (1);
   v_default_date   DATE            := TO_DATE ('01/JAN/2000', 'DD/MON/YYYY');
    --
-----------------------------------------------------------------------------------------------------------------------------
--
--
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.LAST_UPDATED_BY;
      --
      -- TR 190 fix.
      -- Set P_SESSION_CODE to :OLD.SESSION_CODE as :NEW.SESSION_CODE will not
      -- exist.
      --
      p_session_code := :OLD.session_code;

      --
      -- End of TR 190 fix.
      --
      IF maintain_repository.latest_stud_crse_year (:OLD.stud_ref_no,
                                                    :OLD.session_code,
                                                    :OLD.latest_crse_ind
                                                   ) = 'Y'
      THEN
         v_result :=
            maintain_repository.record_app_status (:OLD.stud_ref_no,
                                                   'D',
                                                   :OLD.stud_crse_year_id,
                                                   SYSDATE
                                                  );
      END IF;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
      p_table_pkey1 := :NEW.stud_crse_year_id;
      p_dob := NULL;
      p_initials := NULL;
      p_forenames := NULL;
      p_surname := NULL;
      p_ni_no := NULL;
      p_mobile := NULL;
      p_email := NULL;
      p_calc := :NEW.auto_calc_date;
      p_sent := :NEW.sal_sent_date;
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   ELSIF UPDATING
   THEN
      p_action := 'U';

          /* Removed the following as Oracle 9 doesn't like
          numerics being set to ' ' */
      /*if (nvl(:old.SESSION_CODE,' ')  <> nvl(:new.SESSION_CODE,' ')) then
          WILL_UPDATE := 'Y';
      elsif (nvl(:old.CRSE_YEAR_NO,' ')     <> nvl(:new.CRSE_YEAR_NO,' ')) then
          WILL_UPDATE := 'Y';
      elsif (nvl(:old.INST_CODE,' ')     <> nvl(:new.INST_CODE,' ')) then
          WILL_UPDATE := 'Y';
      elsif (nvl(:old.CRSE_ID,' ')     <> nvl(:new.CRSE_ID,' ')) then
          WILL_UPDATE := 'Y';
      end if; */
      IF :OLD.session_code <> :NEW.session_code
      THEN
         will_update := 'Y';
      ELSIF :OLD.crse_year_no <> :NEW.crse_year_no
      THEN
         will_update := 'Y';
      ELSIF (NVL (:OLD.inst_code, ' ') <> NVL (:NEW.inst_code, ' '))
      THEN
         will_update := 'Y';
      ELSIF :OLD.crse_id <> :NEW.crse_id
      THEN
         will_update := 'Y';
      END IF;

      IF will_update = 'Y'
      THEN
         pk_steps_changes.stud_crse_year_rep (:OLD.stud_crse_year_id,
                                  :NEW.session_code,
                                  :NEW.crse_year_no,
                                  :NEW.inst_code,
                                  :NEW.crse_id
                                  );
      END IF;

      /* check if a calculation has just been performed */
      IF NVL (:OLD.auto_calc_date, v_default_date) <>
                                     NVL (:NEW.auto_calc_date, v_default_date)
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* set the application status to be calculated */
            v_result :=
               maintain_repository.record_app_status (:NEW.stud_ref_no,
                                                      'C',
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.auto_calc_date
                                                     );
         END IF;
      END IF;

      /* check if the award letter has just been sent */
      IF NVL (:NEW.sal_sent, 'Y') = 'Y' AND NVL (:OLD.sal_sent, 'Y') = 'N'
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* set the application status to be letter issued */
            v_result :=
               maintain_repository.record_app_status (:NEW.stud_ref_no,
                                                      'L',
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.sal_sent_date
                                                     );
         END IF;
      END IF;

      /* check if the slc status (file 2) has been updated to sent */
      /* RAM SIR7 16/03/2004 */
      IF (   (    NVL (:OLD.slc2_status, 'A') <> NVL (:NEW.slc2_status, 'A')
              AND NVL (:NEW.slc2_status, 'A') = 'S'
             )
          OR (    NVL (:OLD.slc2_sent, 'A') <> NVL (:NEW.slc2_sent, 'A')
              AND NVL (:NEW.slc2_sent, 'A') = 'Y'
              AND NVL (:NEW.slc2_status, 'A') = 'S'
             )
         )
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* set the application status to be slc data sent */
            v_result :=
               maintain_repository.record_app_status (:NEW.stud_ref_no,
                                                      'S',
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.slc2_sent_date
                                                     );
         END IF;
      END IF;

      /* TR 1537 - check if the latest_crse_ind has been updated to 'Y' */
      IF :OLD.latest_crse_ind = 'N' AND :NEW.latest_crse_ind = 'Y'
      THEN
         /* check this is the latest course and latest session */
         IF maintain_repository.latest_stud_crse_year (:NEW.stud_ref_no,
                                                       :NEW.session_code,
                                                       :NEW.latest_crse_ind
                                                      ) = 'Y'
         THEN
            /* create a new record as previous one has been deleted */
            v_result :=
               maintain_repository.create_app_status (:NEW.stud_ref_no,
                                                      :NEW.stud_crse_year_id,
                                                      :NEW.session_code,
                                                      :NEW.entered_date,
                                                      :NEW.auto_calc_date,
                                                      :NEW.sal_sent_date,
                                                      :NEW.slc2_sent_date
                                                     );
         END IF;
      END IF;
   END IF;

   p_column_name := 'SAL_SENT';
   p_old := :OLD.sal_sent;
   p_new := :NEW.sal_sent;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'APPLICATION_STATUS';
   p_old := :OLD.application_status;
   p_new := :NEW.application_status;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'INST_CHANGE';
   p_old := :OLD.inst_change;
   p_new := :NEW.inst_change;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'PARENT_CONTRIB_EXEMPT';
   p_old := :OLD.parent_contrib_exempt;
   p_new := :NEW.parent_contrib_exempt;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'AWARD';
   p_old := :OLD.award;
   p_new := :NEW.award;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'START_DATE';
   p_old := TO_CHAR (:OLD.start_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.start_date, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'WITHDRAW_DATE';
   p_old := TO_CHAR (:OLD.withdraw_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.withdraw_date, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'VACATION';
   p_old := TO_CHAR (:OLD.vacation);
   p_new := TO_CHAR (:NEW.vacation);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'CRSE_CHG';
   p_old := TO_CHAR (:OLD.crse_chg, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.crse_chg, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'STUDY_COUNTRY';
   p_old := TO_CHAR (:OLD.study_country);
   p_new := TO_CHAR (:NEW.study_country);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'SNB_GRAD';
   p_old := :OLD.snb_grad;
   p_new := :NEW.snb_grad;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'AWARD_LETTER_DATE';
   p_old := :OLD.award_letter_date;
   p_new := :NEW.award_letter_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'AWARD_LETTER_NO';
   p_old := :OLD.award_letter_no;
   p_new := :NEW.award_letter_no;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'BATCH_RECALC';
   p_old := :OLD.batch_recalc;
   p_new := :NEW.batch_recalc;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'DEARING';
   p_old := :OLD.dearing;
   p_new := :NEW.dearing;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'RESID_PAR_CONT';
   p_old := TO_CHAR (:OLD.resid_par_cont);
   p_new := TO_CHAR (:NEW.resid_par_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'RESID_SPOUSE_CONT';
   p_old := TO_CHAR (:OLD.resid_spouse_cont);
   p_new := TO_CHAR (:NEW.resid_spouse_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'RESID_STUD_CONT';
   p_old := TO_CHAR (:OLD.resid_stud_cont);
   p_new := TO_CHAR (:NEW.resid_stud_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'PARENT_CONT';
   p_old := TO_CHAR (:OLD.parent_cont);
   p_new := TO_CHAR (:NEW.parent_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'SPOUSE_CONT';
   p_old := TO_CHAR (:OLD.spouse_cont);
   p_new := TO_CHAR (:NEW.spouse_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'STUD_CONT';
   p_old := TO_CHAR (:OLD.stud_cont);
   p_new := TO_CHAR (:NEW.stud_cont);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'RESID_TRAV_ALLOW';
   p_old := TO_CHAR (:OLD.resid_trav_allow);
   p_new := TO_CHAR (:NEW.resid_trav_allow);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'SML_EQUIP_RQST';
   p_old := TO_CHAR (:OLD.sml_equip_rqst);
   p_new := TO_CHAR (:NEW.sml_equip_rqst);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'SML_EQUIP_APPROVE';
   p_old := TO_CHAR (:OLD.sml_equip_approve);
   p_new := TO_CHAR (:NEW.sml_equip_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'LGE_EQUIP_DESCRIPT';
   p_old := TO_CHAR (:OLD.lge_equip_descript);
   p_new := TO_CHAR (:NEW.lge_equip_descript);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'LGE_EQUIP_APPROVE';
   p_old := TO_CHAR (:OLD.lge_equip_approve);
   p_new := TO_CHAR (:NEW.lge_equip_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'LGE_EQUIP_RQST';
   p_old := TO_CHAR (:OLD.lge_equip_rqst);
   p_new := TO_CHAR (:NEW.lge_equip_rqst);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'DIET_NEED_DESCRIPT';
   p_old := TO_CHAR (:OLD.diet_need_descript);
   p_new := TO_CHAR (:NEW.diet_need_descript);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'DISABLEMENT_CODE';
   p_old := TO_CHAR (:OLD.disablement_code);
   p_new := TO_CHAR (:NEW.disablement_code);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'END_DATE_ABROAD';
   p_old := :OLD.end_date_abroad;
   p_new := :NEW.end_date_abroad;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'ERASMUS';
   p_old := :OLD.erasmus;
   p_new := :NEW.erasmus;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'DIET_NEED_REQ';
   p_old := TO_CHAR (:OLD.diet_need_req);
   p_new := TO_CHAR (:NEW.diet_need_req);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'DIET_NEED_APPROVE';
   p_old := TO_CHAR (:OLD.diet_need_approve);
   p_new := TO_CHAR (:NEW.diet_need_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'NON_MED_REQ';
   p_old := TO_CHAR (:OLD.non_med_req);
   p_new := TO_CHAR (:NEW.non_med_req);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'NON_MED_APPROVE';
   p_old := TO_CHAR (:OLD.non_med_approve);
   p_new := TO_CHAR (:NEW.non_med_approve);
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'PROVISIONAL_CASE';
   p_old := :OLD.provisional_case;
   p_new := :NEW.provisional_case;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'PROVISIONAL_DATE';
   p_old := :OLD.provisional_date;
   p_new := :NEW.provisional_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'REPEAT_YEAR';
   p_old := :OLD.repeat_year;
   p_new := :NEW.repeat_year;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'REQ_DUP';
   p_old := :OLD.req_dup;
   p_new := :NEW.req_dup;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'SESSION_CODE';
   p_old := :OLD.session_code;
   p_new := :NEW.session_code;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'CRSE_YEAR_NO';
   p_old := :OLD.crse_year_no;
   p_new := :NEW.crse_year_no;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'INST_CODE';
   p_old := :OLD.inst_code;
   p_new := :NEW.inst_code;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'CRSE_ID';
   p_old := :OLD.crse_id;
   p_new := :NEW.crse_id;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'UNCONDITIONAL';
   p_old := :OLD.unconditional;
   p_new := :NEW.unconditional;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'SLC1_STATUS';
   p_old := :OLD.slc1_status;
   p_new := :NEW.slc1_status;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'SLC2_STATUS';
   p_old := :OLD.slc2_status;
   p_new := :NEW.slc2_status;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'LOAN_GIVEN';
   p_old := :OLD.loan_given;
   p_new := :NEW.loan_given;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'LATEST_CRSE_IND';
   p_old := :OLD.latest_crse_ind;
   p_new := :NEW.latest_crse_ind;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'AUTO_CALC_DATE';
   p_old := :OLD.auto_calc_date;
   p_new := :NEW.auto_calc_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   --
   -- RFC 112 addition
   --
   p_column_name := 'DSA_FEE_DESCRIPT';
   p_old := :OLD.dsa_fee_descript;
   p_new := :NEW.dsa_fee_descript;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'DSA_FEE_RQST';
   p_old := :OLD.dsa_fee_rqst;
   p_new := :NEW.dsa_fee_rqst;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'DSA_FEE_APPROVE';
   p_old := :OLD.dsa_fee_approve;
   p_new := :NEW.dsa_fee_approve;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   --
   -- END OF RFC 112 addition
   --
   -- RFC 113b Janis 28/06/04
   --
   p_column_name := 'ATTEND_REQD';
   p_old := :OLD.attend_reqd;
   p_new := :NEW.attend_reqd;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   --
   -- End rfc 113b
   --
   -- RFC 113c MT 05/07/04
   --
   p_column_name := 'ATTEND_CONFIRMED';
   p_old := :OLD.attend_confirmed;
   p_new := :NEW.attend_confirmed;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   --
   p_column_name := 'HEI_DATE_ATTENDED';
   p_old := :OLD.hei_date_attended;
   p_new := :NEW.hei_date_attended;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   --
   p_column_name := 'NON_ATT_ACTIONED';
   p_old := :OLD.non_att_actioned;
   p_new := :NEW.non_att_actioned;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   --
   p_column_name := 'NON_ATT_ACTIONED_DATE';
   p_old := :OLD.non_att_actioned_date;
   p_new := :NEW.non_att_actioned_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   --
   p_column_name := 'TRAV_SUBMITTED_DATE';
   p_old := :OLD.trav_submitted_date;
   p_new := :NEW.trav_submitted_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'SAL_SENT_DATE';
   p_old := :OLD.sal_sent_date;
   p_new := :NEW.sal_sent_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'SAL_DEST';
   p_old := :OLD.sal_dest;
   p_new := :NEW.sal_dest;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
--- RFC188
   p_column_name := 'VARIABLE_FEE_OVERRIDE_AMOUNT';
   p_old := :OLD.variable_fee_override_amount;
   p_new := :NEW.variable_fee_override_amount;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   --
   p_column_name := 'FEE_LOAN_GIVEN';
   p_old := :OLD.fee_loan_given;
   p_new := :NEW.fee_loan_given;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   --
   p_column_name := 'FEE_LOAN_ELIGIBILITY_ONLY';
   p_old := :OLD.fee_loan_eligibility_only;
   p_new := :NEW.fee_loan_eligibility_only;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   --
   p_column_name := 'PGCE';
   p_old := :OLD.pgce;
   p_new := :NEW.pgce;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   --
   p_column_name := 'SELF_FUNDING';
   p_old := :OLD.self_funding;
   p_new := :NEW.self_funding;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   --
   p_column_name := 'INDEPENDENT';
   p_old := :OLD.independent;
   p_new := :NEW.independent;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   --
   p_column_name := 'DUE_YSB_YSO_IND';
   p_old := :OLD.due_ysb_yso_ind;
   p_new := :NEW.due_ysb_yso_ind;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
--END OF RFC188
-- RFC204
   p_column_name := 'HOUSEHOLD_RESID_INCOME';
   p_old := :OLD.household_resid_income;
   p_new := :NEW.household_resid_income;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'BEN1_TOTAL_INCOME';
   p_old := :OLD.ben1_total_income;
   p_new := :NEW.ben1_total_income;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'BEN2_TOTAL_INCOME';
   p_old := :OLD.ben2_total_income;
   p_new := :NEW.ben2_total_income;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
-- RFC204

   --RFC 222
   p_column_name := 'SNB_SINGLE_RATE';
   p_old := :OLD.snb_single_rate;
   p_new := :NEW.snb_single_rate;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
--RFC 222
   p_column_name := 'NMSB_SESSION_CALC';
   p_old := :OLD.nmsb_session_calc;
   p_new := :NEW.nmsb_session_calc;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'START_DATE_ABROAD';
   p_old := TO_CHAR (:OLD.start_date_abroad, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.start_date_abroad, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'STUDY_ABROAD';
   p_old := :OLD.study_abroad;
   p_new := :NEW.study_abroad;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'UNPAID_SANDWICH';
   p_old := :OLD.unpaid_sandwich;
   p_new := :NEW.unpaid_sandwich;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'PAID_SANDWICH';
   p_old := :OLD.paid_sandwich;
   p_new := :NEW.paid_sandwich;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'CALC_FEE';
   p_old := :OLD.calc_fee;
   p_new := :NEW.calc_fee;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'CALC_BURSARY';
   p_old := :OLD.calc_bursary;
   p_new := :NEW.calc_bursary;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'CALC_LOAN';
   p_old := :OLD.calc_loan;
   p_new := :NEW.calc_loan;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'CALC_DEP_GRANT';
   p_old := :OLD.calc_dep_grant;
   p_new := :NEW.calc_dep_grant;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'CALC_LPG';
   p_old := :OLD.calc_lpg;
   p_new := :NEW.calc_lpg;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'CALC_LPCG';
   p_old := :OLD.calc_lpcg;
   p_new := :NEW.calc_lpcg;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'PAY_YSB';
   p_old := :OLD.pay_ysb;
   p_new := :NEW.pay_ysb;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'PGCE_EDU_LEVEL';
   p_old := :OLD.pgce_edu_level;
   p_new := :NEW.pgce_edu_level;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'PGCE_SUBJECT';
   p_old := :OLD.pgce_subject;
   p_new := :NEW.pgce_subject;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'FIRST_CALC_DATE';
   p_old := :OLD.first_calc_date;
   p_new := :NEW.first_calc_date;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   p_column_name := 'PSAS_PT';
   p_old := :OLD.psas_pt;
   p_new := :NEW.psas_pt;
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
   pk_steps_aud.ins_stcy_aud (p_aud_date,
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
    --
/* Telephony Auditing PB Feb 2005*/
    --
   p_column_name := 'DATE_LAST_CALCULATED';
   p_old := :OLD.auto_calc_date;
   p_new := :NEW.auto_calc_date;

   IF NVL (:OLD.auto_calc_date, '01/JAN/1900') <>
                                      NVL (:NEW.auto_calc_date, '01/JAN/1900')
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'DATE_LAST_AWARD_LETTER_ISSUED';
   p_old := :OLD.sal_sent_date;
   p_new := :NEW.sal_sent_date;

   IF NVL (:OLD.sal_sent_date, '01/JAN/1900') <>
                                       NVL (:NEW.sal_sent_date, '01/JAN/1900')
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'SAL_DEST';
   p_old := :OLD.sal_dest;
   p_new := :NEW.sal_dest;

   IF NVL (:OLD.sal_dest, 'X') <> NVL (:NEW.sal_dest, 'X')
   THEN
      v_updated := 'Y';
   END IF;

   --
   IF v_updated = 'Y'
   THEN
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   END IF;
END stcy_iud;
/



CREATE OR REPLACE TRIGGER std_iud
   AFTER INSERT OR DELETE OR UPDATE OF dob,
                                       income,
                                       assist,
                                       emp_status,
                                       relation_id,
                                       interest,
                                       include,
                                       first_name,
                                       surname,
                                       last_updated_by
   ON STUD_DEPENDANT    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                   := SYSDATE;
   p_column_name    stud_dependant_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_dependant_aud.table_pkey1%TYPE
                                                     := TO_CHAR (:OLD.std_id);
   p_table_pkey2    stud_dependant_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_dependant_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_dependant_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_dependant_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_dependant_aud.OLD%TYPE            := NULL;
   p_new            stud_dependant_aud.NEW%TYPE            := NULL;
   p_action         stud_dependant_aud.action%TYPE         := NULL;
   p_username       stud_dependant_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    stud_dependant_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      stud_dependant_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_dependant_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.std_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.std_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'DOB';
   p_old := TO_CHAR (:OLD.dob, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.dob, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   p_column_name := 'INCOME';
   p_old := TO_CHAR (:OLD.income);
   p_new := TO_CHAR (:NEW.income);
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   p_column_name := 'ASSIST';
   p_old := TO_CHAR (:OLD.assist);
   p_new := TO_CHAR (:NEW.assist);
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   p_column_name := 'EMP_STATUS';
   p_old := TO_CHAR (:OLD.emp_status);
   p_new := TO_CHAR (:NEW.emp_status);
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   p_column_name := 'RELATION_ID';
   p_old := TO_CHAR (:OLD.relation_id);
   p_new := TO_CHAR (:NEW.relation_id);
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   p_column_name := 'INTEREST';
   p_old := TO_CHAR (:OLD.interest);
   p_new := TO_CHAR (:NEW.interest);
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   p_column_name := 'INCLUDE';
   p_old := :OLD.include;
   p_new := :NEW.include;
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   p_column_name := 'FIRST_NAME';
   p_old := TO_CHAR (:OLD.first_name);
   p_new := TO_CHAR (:NEW.first_name);
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   p_old := TO_CHAR (:OLD.surname);
   p_new := TO_CHAR (:NEW.surname);
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   pk_steps_aud.ins_std_aud (p_aud_date,
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
END std_iud;
/



CREATE OR REPLACE TRIGGER sthome_iud
   AFTER INSERT OR DELETE OR UPDATE OF addr_l1,
                                       addr_l2,
                                       addr_l3,
                                       addr_l4,
                                       house_no_name,
                                       post_code,
                                       tele_no,
                                       last_updated_by
   ON STUD_HOME_ADDR    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   p_aud_date       DATE                                   := SYSDATE;
   p_column_name    stud_home_addr_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_home_addr_aud.table_pkey1%TYPE   := :OLD.stud_ref_no;
   p_table_pkey2    stud_home_addr_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_home_addr_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_home_addr_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_home_addr_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_home_addr_aud.OLD%TYPE            := NULL;
   p_new            stud_home_addr_aud.NEW%TYPE            := NULL;
   p_action         stud_home_addr_aud.action%TYPE         := NULL;
   p_username       stud_home_addr_aud.username%TYPE       := :NEW.last_updated_by;
   p_stud_ref_no    stud_home_addr_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      stud_home_addr_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_home_addr_aud.session_code%TYPE   := NULL;
   p_table_name     VARCHAR2 (32)                         := 'STUD_HOME_ADDR';
   v_updated        VARCHAR2 (1)                           := 'N';
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_ref_no;
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'HOUSE_NO_NAME';
   p_old := :OLD.house_no_name;
   p_new := :NEW.house_no_name;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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

   IF NVL (:OLD.house_no_name, 'BLANK') <> NVL (:NEW.house_no_name, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   p_column_name := 'HOME_ADDR_L1';
   p_old := :OLD.addr_l1;
   p_new := :NEW.addr_l1;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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

   IF NVL (:OLD.addr_l1, 'BLANK') <> NVL (:NEW.addr_l1, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   p_column_name := 'HOME_ADDR_L2';
   p_old := :OLD.addr_l2;
   p_new := :NEW.addr_l2;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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

   IF NVL (:OLD.addr_l2, 'BLANK') <> NVL (:NEW.addr_l2, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   p_column_name := 'HOME_ADDR_L3';
   p_old := :OLD.addr_l3;
   p_new := :NEW.addr_l3;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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

   IF NVL (:OLD.addr_l3, 'BLANK') <> NVL (:NEW.addr_l3, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   p_column_name := 'HOME_ADDR_L4';
   p_old := :OLD.addr_l4;
   p_new := :NEW.addr_l4;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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

   IF NVL (:OLD.addr_l4, 'BLANK') <> NVL (:NEW.addr_l4, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   p_column_name := 'HOME_POST_CODE';
   p_old := :OLD.post_code;
   p_new := :NEW.post_code;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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

   IF NVL (:OLD.post_code, 'BLANK') <> NVL (:NEW.post_code, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   p_column_name := 'HOME_TELE_NO';
   p_old := :OLD.tele_no;
   p_new := :NEW.tele_no;
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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
   pk_steps_aud.ins_sthome_aud (p_aud_date,
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

   IF NVL (:OLD.tele_no, 0) <> NVL (:NEW.tele_no, 0)
   THEN
      v_updated := 'Y';
   END IF;

   IF v_updated = 'Y'
   THEN
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   END IF;
END sthome_iud;
/



CREATE OR REPLACE TRIGGER sts_iud
   AFTER INSERT OR DELETE OR UPDATE OF ben1_id,
                                       ben2_id,
                                       emp_login_name,
                                       ja_case,
                                       loan_declaration_date,
                                       loan_request,
                                       max_loan_requested,
                                       net_income,
                                       pension_income,
                                       session_code,
                                       trust_income,
                                       ysb_entitlement,
                                       fee_loan_request_amount,
                                       max_fee_loan_requested,
                                       fee_loan_declaration_date,
                                       stud_hei_bursary_consent,
                                       reason_no_nino,
                                       slc1_fl_sent,
                                       slc1_fl_sent_date,
                                       lpcg_paid_amount,
                                       max_lpcg_paid,
                                       smg_entitlement,
                                       child_care_no,
                                       child_care_name,
                                       ben1_rel_id,
                                       ben2_rel_id,
                                       total_house_income,
                                       stud_income,
                                       date_applic_received,
                                       fee_loan_charged,
                                       last_updated_by
   ON STUD_SESSION    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   p_aud_date       DATE                                 := SYSDATE;
   p_column_name    stud_session_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_session_aud.table_pkey1%TYPE
                                            := TO_CHAR (:OLD.stud_session_id);
   p_table_pkey2    stud_session_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_session_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_session_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_session_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_session_aud.OLD%TYPE            := NULL;
   p_new            stud_session_aud.NEW%TYPE            := NULL;
   p_action         stud_session_aud.action%TYPE         := NULL;
   p_username       stud_session_aud.username%TYPE       := :NEW.last_updated_by;
   p_stud_ref_no    stud_session_aud.stud_ref_no%TYPE    := :OLD.stud_ref_no;
   p_inst_code      stud_session_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_session_aud.session_code%TYPE   := :NEW.session_code;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_session_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   /* Removed nvl as Oracle 9i doesn't cope */
   --IF (NVL(:OLD.SESSION_CODE,' ')  <> NVL(:NEW.SESSION_CODE,' ')) THEN
   /*IF (:OLD.SESSION_CODE  <> :NEW.SESSION_CODE) THEN
       M202.STUD_SESSION_REP(:OLD.STUD_SESSION_ID,
                   :NEW.SESSION_CODE);*/
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_session_code := :OLD.session_code;
      p_stud_ref_no := :OLD.stud_ref_no;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'BEN1_ID';
   p_old := TO_CHAR (:OLD.ben1_id);
   p_new := TO_CHAR (:NEW.ben1_id);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'BEN2_ID';
   p_old := TO_CHAR (:OLD.ben2_id);
   p_new := TO_CHAR (:NEW.ben2_id);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'EMP_LOGIN_NAME';
   p_old := :OLD.emp_login_name;
   p_new := :NEW.emp_login_name;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'JA_CASE';
   p_old := :OLD.ja_case;
   p_new := :NEW.ja_case;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'LOAN_DECLARATION_DATE';
   p_old := :OLD.loan_declaration_date;
   p_new := :NEW.loan_declaration_date;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'LOAN_REQUEST';
   p_old := TO_CHAR (:OLD.loan_request);
   p_new := TO_CHAR (:NEW.loan_request);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'MAX_LOAN_REQUESTED';
   p_old := :OLD.max_loan_requested;
   p_new := :NEW.max_loan_requested;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'NET_INCOME';
   p_old := TO_CHAR (:OLD.net_income);
   p_new := TO_CHAR (:NEW.net_income);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'PENSION_INCOME';
   p_old := TO_CHAR (:OLD.pension_income);
   p_new := TO_CHAR (:NEW.pension_income);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'SESSION_CODE';
   p_old := :OLD.session_code;
   p_new := :NEW.session_code;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'TRUST_INCOME';
   p_old := TO_CHAR (:OLD.trust_income);
   p_new := TO_CHAR (:NEW.trust_income);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'YSB_ENTITLEMENT';
   p_old := :OLD.ysb_entitlement;
   p_new := :NEW.ysb_entitlement;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'FEE_LOAN_REQUEST_AMOUNT';
   p_old := :OLD.fee_loan_request_amount;
   p_new := :NEW.fee_loan_request_amount;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'MAX_FEE_LOAN_REQUESTED';
   p_old := :OLD.max_fee_loan_requested;
   p_new := :NEW.max_fee_loan_requested;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'FEE_LOAN_DECLARATION_DATE';
   p_old := :OLD.fee_loan_declaration_date;
   p_new := :NEW.fee_loan_declaration_date;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'FEE_LOAN_CHARGED';
   p_old := :OLD.fee_loan_charged;
   p_new := :NEW.fee_loan_charged;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'STUD_HEI_BURSARY_CONSENT';
   p_old := :OLD.stud_hei_bursary_consent;
   p_new := :NEW.stud_hei_bursary_consent;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'REASON_NO_NINO';
   p_old := TO_CHAR (:OLD.reason_no_nino);
   p_new := TO_CHAR (:NEW.reason_no_nino);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'SLC1_FL_SENT';
   p_old := TO_CHAR (:OLD.slc1_fl_sent);
   p_new := TO_CHAR (:NEW.slc1_fl_sent);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'SLC1_FL_SENT_DATE';
   p_old := TO_CHAR (:OLD.slc1_fl_sent_date);
   p_new := TO_CHAR (:NEW.slc1_fl_sent_date);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'LPCG_PAID_AMOUNT';
   p_old := :OLD.lpcg_paid_amount;
   p_new := :NEW.lpcg_paid_amount;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'MAX_LPCG_PAID';
   p_old := :OLD.max_lpcg_paid;
   p_new := :NEW.max_lpcg_paid;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'SMG_ENTITLEMENT';
   p_old := :OLD.smg_entitlement;
   p_new := :NEW.smg_entitlement;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'CHILD_CARE_NO';
   p_old := :OLD.child_care_no;
   p_new := :NEW.child_care_no;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'CHILD_CARE_NAME';
   p_old := :OLD.child_care_name;
   p_new := :NEW.child_care_name;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'BEN1_REL_ID';
   p_old := :OLD.ben1_rel_id;
   p_new := :NEW.ben1_rel_id;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'BEN2_REL_ID';
   p_old := :OLD.ben2_rel_id;
   p_new := :NEW.ben2_rel_id;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'TOTAL_HOUSE_INCOME';
   p_old := :OLD.total_house_income;
   p_new := :NEW.total_house_income;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'STUD_INCOME';
   p_old := :OLD.stud_income;
   p_new := :NEW.stud_income;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'DATE_APPLIC_RECEIVED';
   p_old := :OLD.date_applic_received;
   p_new := :NEW.date_applic_received;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
END sts_iud;
/



CREATE OR REPLACE TRIGGER stt_iud
   AFTER INSERT OR DELETE OR UPDATE OF location_ind, LAST_UPDATED_BY                                    
   ON STUD_TERM_ADDR    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                   := SYSDATE;
   p_column_name    stud_term_addr_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_term_addr_aud.table_pkey1%TYPE
                                                     := TO_CHAR (:OLD.stud_ref_no);
   p_table_pkey2    stud_term_addr_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_term_addr_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_term_addr_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_term_addr_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_term_addr_aud.OLD%TYPE            := NULL;
   p_new            stud_term_addr_aud.NEW%TYPE            := NULL;
   p_action         stud_term_addr_aud.action%TYPE         := NULL;
   p_username       stud_term_addr_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    stud_term_addr_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      stud_term_addr_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_term_addr_aud.session_code%TYPE   := NULL;
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

   p_column_name := 'LOCATION_IND';
   p_old := :OLD.location_ind;
   p_new := :NEW.location_ind;
   pk_steps_aud.ins_sta_aud (p_aud_date,
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
   pk_steps_aud.ins_sta_aud (p_aud_date,
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

END stt_iud;
/



CREATE OR REPLACE TRIGGER stud_nom_iud
   AFTER INSERT OR DELETE OR UPDATE OF stud_nom_id, stud_ref_no, nominee_id, last_updated_by
   ON STUD_NOMINEE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                 := SYSDATE;
   p_column_name    stud_nominee_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_nominee_aud.table_pkey1%TYPE    := :OLD.stud_nom_id;
   p_table_pkey2    stud_nominee_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_nominee_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_nominee_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_nominee_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_nominee_aud.OLD%TYPE            := NULL;
   p_new            stud_nominee_aud.NEW%TYPE            := NULL;
   p_action         stud_nominee_aud.action%TYPE         := NULL;
   p_username       stud_nominee_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    stud_nominee_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      stud_nominee_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_nominee_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_nom_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.stud_nom_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'STUD_NOM_ID';
   p_old := :OLD.stud_nom_id;
   p_new := :NEW.stud_nom_id;
   pk_steps_aud.ins_stud_nom_aud (p_aud_date,
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
   p_column_name := 'STUD_REF_NO';
   p_old := TO_CHAR (:OLD.stud_ref_no);
   p_new := TO_CHAR (:NEW.stud_ref_no);
   pk_steps_aud.ins_stud_nom_aud (p_aud_date,
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
   p_column_name := 'NOMINEE_ID';
   p_old := TO_CHAR (:OLD.nominee_id);
   p_new := TO_CHAR (:NEW.nominee_id);
   pk_steps_aud.ins_stud_nom_aud (p_aud_date,
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
   pk_steps_aud.ins_stud_nom_aud (p_aud_date,
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
END stud_nom_iud;
/



CREATE OR REPLACE TRIGGER st_iud
   AFTER INSERT OR DELETE OR UPDATE OF account_no,
                                       birth_cert_flag,
                                       birth_country_code,
                                       def_overpayment,
                                       disabled,
                                       dob,
                                       dsa_eqmt,
                                       forenames,
                                       initials,
                                       maiden_name,
                                       marital_status,
                                       marriage_date,
                                       nation_country_code,
                                       ni_no,
                                       nominee,
                                       nom_method,
                                       nom_name,
                                       overpayment,
                                       overpay_stat,
                                       payment_method,
                                       residence_country_code,
                                       residence_id,
                                       sex,
                                       snb_def_overpayment,
                                       snb_overpayment,
                                       sort_code,
                                       surname,
                                       title,
                                       valid_duplicate_acc,
                                       dup_bank_reason,
                                       bankrupt_flag,
                                       qa_count,
                                       last_updated_by
   ON STUD    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   p_aud_date       DATE                         := SYSDATE;
   p_column_name    stud_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_aud.table_pkey1%TYPE    := :OLD.stud_ref_no;
   p_table_pkey2    stud_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_aud.OLD%TYPE            := NULL;
   p_new            stud_aud.NEW%TYPE            := NULL;
   p_action         stud_aud.action%TYPE         := NULL;
   p_username       stud_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    stud_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      stud_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_aud.session_code%TYPE   := NULL;
   will_update      VARCHAR2 (1)                 := 'N';
   p_table_name     VARCHAR2 (32)                := 'STUD';
   p_dob            stud.dob%TYPE;
   p_initials       stud.initials%TYPE;
   p_forenames      stud.forenames%TYPE;
   p_surname        stud.surname%TYPE;
   p_ni_no          stud.ni_no%TYPE;
   p_mobile         stud.mobile_tel_no%TYPE;
   p_email          stud.email_addr%TYPE;
   p_calc           DATE                         := NULL;
   p_sent           DATE                         := NULL;
   v_updated        VARCHAR2 (1)                 := 'N';
BEGIN
   /*IF Change_Audit.auditing_on != 'FALSE' THEN
   --PB Feb 2005
   P_STUD_REF_NO := :NEW.STUD_REF_NO;
   P_DOB := :NEW.DOB;
   P_INITIALS := :NEW.INITIALS;
   P_FORENAMES := :NEW.FORENAMES;
   P_SURNAME := :NEW.SURNAME;
   P_NI_NO := :NEW.NI_NO;
   P_MOBILE := :NEW.MOBILE_TEL_NO;
   P_EMAIL := :NEW.EMAIL_ADDR;*/
   --
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
      p_stud_ref_no := :OLD.stud_ref_no;
      p_dob := :OLD.dob;
      p_initials := :OLD.initials;
      p_forenames := :OLD.forenames;
      p_surname := :OLD.surname;
      p_ni_no := :OLD.ni_no;
      p_mobile := :OLD.mobile_tel_no;
      p_email := :OLD.email_addr;
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
      p_table_pkey1 := :NEW.stud_ref_no;
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   ELSIF UPDATING
   THEN
      p_action := 'U';

      IF (NVL (:OLD.forenames, ' ') <> NVL (:NEW.forenames, ' '))
      THEN
         will_update := 'Y';
      ELSIF (NVL (:OLD.surname, ' ') <> NVL (:NEW.surname, ' '))
      THEN
         will_update := 'Y';
      ELSIF (NVL (:OLD.sex, ' ') <> NVL (:NEW.sex, ' '))
      THEN
         will_update := 'Y';
      ELSIF (:OLD.dob <> :NEW.dob)
      THEN
         will_update := 'Y';
      END IF;

      IF will_update = 'Y'
      THEN
         pk_steps_changes.stud_rep (:OLD.stud_ref_no,
                        :NEW.forenames,
                        :NEW.surname,
                        :NEW.dob,
                        :NEW.sex
                       );
      END IF;
   END IF;

   --- IF P_ACTION <> 'I' THEN
   p_column_name := 'DOB';
   p_old := TO_CHAR (:OLD.dob, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.dob, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'TITLE';
   p_old := :OLD.title;
   p_new := :NEW.title;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'INITIALS';
   p_old := :OLD.initials;
   p_new := :NEW.initials;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'SEX';
   p_old := :OLD.sex;
   p_new := :NEW.sex;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'RESIDENCE_ID';
   p_old := TO_CHAR (:OLD.residence_id);
   p_new := TO_CHAR (:NEW.residence_id);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'BIRTH_COUNTRY_CODE';
   p_old := TO_CHAR (:OLD.birth_country_code);
   p_new := TO_CHAR (:NEW.birth_country_code);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'RESIDENCE_COUNTRY_CODE';
   p_old := TO_CHAR (:OLD.residence_country_code);
   p_new := TO_CHAR (:NEW.residence_country_code);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'NATION_COUNTRY_CODE';
   p_old := TO_CHAR (:OLD.nation_country_code);
   p_new := TO_CHAR (:NEW.nation_country_code);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'NOMINEE';
   p_old := :OLD.nominee;
   p_new := :NEW.nominee;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'PAYMENT_METHOD';
   p_old := :OLD.payment_method;
   p_new := :NEW.payment_method;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'OVERPAY_STAT';
   p_old := :OLD.overpay_stat;
   p_new := :NEW.overpay_stat;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'OVERPAYMENT';
   p_old := TO_CHAR (:OLD.overpayment);
   p_new := TO_CHAR (:NEW.overpayment);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'DEF_OVERPAYMENT';
   p_old := TO_CHAR (:OLD.def_overpayment);
   p_new := TO_CHAR (:NEW.def_overpayment);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'SNB_OVERPAYMENT';
   p_old := TO_CHAR (:OLD.snb_overpayment);
   p_new := TO_CHAR (:NEW.snb_overpayment);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'SNB_DEF_OVERPAYMENT';
   p_old := TO_CHAR (:OLD.snb_def_overpayment);
   p_new := TO_CHAR (:NEW.snb_def_overpayment);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'DISABLED';
   p_old := :OLD.disabled;
   p_new := :NEW.disabled;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'MARITAL_STATUS';
   p_old := :OLD.marital_status;
   p_new := :NEW.marital_status;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'MARRIAGE_DATE';
   p_old := TO_CHAR (:OLD.marriage_date, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.marriage_date, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'ACCOUNT_NO';
   p_old := :OLD.account_no;
   p_new := :NEW.account_no;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'SORT_CODE';
   p_old := :OLD.sort_code;
   p_new := :NEW.sort_code;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'NOM_METHOD';
   p_old := :OLD.nom_method;
   p_new := :NEW.nom_method;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'NOM_NAME';
   p_old := :OLD.nom_name;
   p_new := :NEW.nom_name;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'MAIDEN_NAME';
   p_old := :OLD.maiden_name;
   p_new := :NEW.maiden_name;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'DSA_EQMT';
   p_old := TO_CHAR (:OLD.dsa_eqmt);
   p_new := TO_CHAR (:NEW.dsa_eqmt);
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'SUSPEND_PAYMENT';
   p_old := :OLD.suspend_payment;
   p_new := :NEW.suspend_payment;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'NI_NO';
   p_old := :OLD.ni_no;
   p_new := :NEW.ni_no;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'BIRTH_CERT_FLAG';
   p_old := :OLD.birth_cert_flag;
   p_new := :NEW.birth_cert_flag;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'VALID_DUPLICATE_ACC';
   p_old := :OLD.valid_duplicate_acc;
   p_new := :NEW.valid_duplicate_acc;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'DUP_BANK_REASON';
   p_old := :OLD.dup_bank_reason;
   p_new := :NEW.dup_bank_reason;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'BANKRUPT_FLAG';
   p_old := :OLD.bankrupt_flag;
   p_new := :NEW.bankrupt_flag;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   p_column_name := 'QA_COUNT';
   p_old := :OLD.qa_count;
   p_new := :NEW.qa_count;
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   pk_steps_aud.ins_st_aud (p_aud_date,
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
   --END IF;

   /*New auditing for Telephony - PB Feb 2005*/
    --
   p_column_name := 'STUD_REF_NO';
   p_old := :OLD.stud_ref_no;
   p_new := :NEW.stud_ref_no;

   IF :OLD.stud_ref_no <> :NEW.stud_ref_no
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'DOB';
   p_old := TO_CHAR (:OLD.dob, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.dob, 'DD/MM/YYYY HH24:MI');

   IF :OLD.dob <> :NEW.dob
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'INITIALS';
   p_old := :OLD.initials;
   p_new := :NEW.initials;

   IF NVL (:OLD.initials, 'BLANK') <> NVL (:NEW.initials, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'FORENAMES';
   p_old := :OLD.forenames;
   p_new := :NEW.forenames;

   IF :OLD.forenames <> :NEW.forenames
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'SURNAME';
   p_old := :OLD.surname;
   p_new := :NEW.surname;

   IF :OLD.surname <> :NEW.surname
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'NI_NO';
   p_old := :OLD.ni_no;
   p_new := :NEW.ni_no;

   IF NVL (:OLD.ni_no, 'BLANK') <> NVL (:NEW.ni_no, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'MOBILE_TEL_NO';
   p_old := :OLD.mobile_tel_no;
   p_new := :NEW.mobile_tel_no;

   IF NVL (:OLD.mobile_tel_no, 0) <> NVL (:NEW.mobile_tel_no, 0)
   THEN
      v_updated := 'Y';
   END IF;

   --
   p_column_name := 'EMAIL_ADDR';
   p_old := :OLD.email_addr;
   p_new := :NEW.email_addr;

   IF NVL (:OLD.email_addr, 'BLANK') <> NVL (:NEW.email_addr, 'BLANK')
   THEN
      v_updated := 'Y';
   END IF;

   IF v_updated = 'Y'
   THEN
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
      telephony_support.update_web_mail (p_stud_ref_no, :NEW.email_addr);
   END IF;
/* End of Additions
     END IF;*/
END st_iud;
/



CREATE OR REPLACE TRIGGER supp_grant_rel_iud
   AFTER INSERT OR DELETE OR UPDATE OF supp_grant_relation_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON SUPP_GRANT_RELATION    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    supp_grant_relation_aud.column_name%TYPE    := NULL;
   p_table_pkey1    supp_grant_relation_aud.table_pkey1%TYPE
                                               := :OLD.supp_grant_relation_id;
   p_table_pkey2    supp_grant_relation_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    supp_grant_relation_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    supp_grant_relation_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    supp_grant_relation_aud.table_pkey5%TYPE    := NULL;
   p_old            supp_grant_relation_aud.OLD%TYPE            := NULL;
   p_new            supp_grant_relation_aud.NEW%TYPE            := NULL;
   p_action         supp_grant_relation_aud.action%TYPE         := NULL;
   p_username       supp_grant_relation_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    supp_grant_relation_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      supp_grant_relation_aud.inst_code%TYPE      := NULL;
   p_session_code   supp_grant_relation_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.supp_grant_relation_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.supp_grant_relation_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'SUPP_GRANT_RELATION_ID';
   p_old := :OLD.supp_grant_relation_id;
   p_new := :NEW.supp_grant_relation_id;
   pk_steps_aud.ins_sup_gra_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_sup_gra_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_sup_gra_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_sup_gra_rel_aud (p_aud_date,
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
   pk_steps_aud.ins_sup_gra_rel_aud (p_aud_date,
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
END supp_grant_rel_iud;
/



CREATE OR REPLACE TRIGGER title_iud
   AFTER INSERT OR DELETE OR UPDATE OF TITLE_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON TITLE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    TITLE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    TITLE_aud.table_pkey1%TYPE
                                               := :OLD.TITLE_id;
   p_table_pkey2    TITLE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    TITLE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    TITLE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    TITLE_aud.table_pkey5%TYPE    := NULL;
   p_old            TITLE_aud.OLD%TYPE            := NULL;
   p_new            TITLE_aud.NEW%TYPE            := NULL;
   p_action         TITLE_aud.action%TYPE         := NULL;
   p_username       TITLE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    TITLE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      TITLE_aud.inst_code%TYPE      := NULL;
   p_session_code   TITLE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.TITLE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.TITLE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'TITLE_ID';
   p_old := :OLD.TITLE_id;
   p_new := :NEW.TITLE_id;
   pk_steps_aud.ins_title_aud (p_aud_date,
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
   pk_steps_aud.ins_title_aud (p_aud_date,
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
   pk_steps_aud.ins_title_aud (p_aud_date,
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
   pk_steps_aud.ins_title_aud (p_aud_date,
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
   pk_steps_aud.ins_title_aud (p_aud_date,
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
END title_iud;
/



CREATE OR REPLACE TRIGGER z_ref_stat_iud
   AFTER INSERT OR DELETE OR UPDATE OF Z_REFUSAL_STATUS_id,
                                       legacy_id,
                                       legacy_code,
                                       descript,
                                       last_updated_by
   ON Z_REFUSAL_STATUS    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    Z_REFUSAL_STATUS_aud.column_name%TYPE    := NULL;
   p_table_pkey1    Z_REFUSAL_STATUS_aud.table_pkey1%TYPE
                                               := :OLD.Z_REFUSAL_STATUS_id;
   p_table_pkey2    Z_REFUSAL_STATUS_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    Z_REFUSAL_STATUS_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    Z_REFUSAL_STATUS_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    Z_REFUSAL_STATUS_aud.table_pkey5%TYPE    := NULL;
   p_old            Z_REFUSAL_STATUS_aud.OLD%TYPE            := NULL;
   p_new            Z_REFUSAL_STATUS_aud.NEW%TYPE            := NULL;
   p_action         Z_REFUSAL_STATUS_aud.action%TYPE         := NULL;
   p_username       Z_REFUSAL_STATUS_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    Z_REFUSAL_STATUS_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      Z_REFUSAL_STATUS_aud.inst_code%TYPE      := NULL;
   p_session_code   Z_REFUSAL_STATUS_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.Z_REFUSAL_STATUS_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.Z_REFUSAL_STATUS_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'Z_REFUSAL_STATUS_ID';
   p_old := :OLD.Z_REFUSAL_STATUS_id;
   p_new := :NEW.Z_REFUSAL_STATUS_id;
   pk_steps_aud.ins_z_ref_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_z_ref_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_z_ref_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_z_ref_stat_aud (p_aud_date,
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
   pk_steps_aud.ins_z_ref_stat_aud (p_aud_date,
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
END z_ref_stat_iud;
/








