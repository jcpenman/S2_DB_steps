CREATE OR REPLACE TRIGGER STS_IUD
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
                                       care_leaver,
                                       date_applic_received,
                                       fee_loan_charged,
                                       session_suspend,
                                       last_updated_by,
                                       top_option,
                                       top_changed,
                                       debt_only
   ON SGAS.STUD_SESSION    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   p_aud_date          DATE                                 := SYSDATE;
   p_column_name       stud_session_aud.column_name%TYPE    := NULL;
   p_table_pkey1       stud_session_aud.table_pkey1%TYPE
                                            := TO_CHAR (:OLD.stud_session_id);
   p_table_pkey2       stud_session_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3       stud_session_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4       stud_session_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5       stud_session_aud.table_pkey5%TYPE    := NULL;
   p_old               stud_session_aud.OLD%TYPE            := NULL;
   p_new               stud_session_aud.NEW%TYPE            := NULL;
   p_action            stud_session_aud.action%TYPE         := NULL;
   p_username          stud_session_aud.username%TYPE := :NEW.last_updated_by;
   p_stud_ref_no       stud_session_aud.stud_ref_no%TYPE  := :OLD.stud_ref_no;
   p_inst_code         stud_session_aud.inst_code%TYPE      := NULL;
   p_session_code      stud_session_aud.session_code%TYPE
                                                         := :NEW.session_code;
   p_stud_session_id   stud_session.stud_session_id%TYPE
                                                      := :OLD.stud_session_id;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_session_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
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
   p_column_name := 'CARE_LEAVER';
   p_old := :OLD.care_leaver;
   p_new := :NEW.care_leaver;
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
   p_column_name := 'SESSION_SUSPEND';
   p_old := :OLD.session_suspend;
   p_new := :NEW.session_suspend;
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
p_column_name := 'TOP_OPTION';
   p_old := :OLD.top_option;
   p_new := :NEW.top_option;
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
p_column_name := 'TOP_CHANGED';
   p_old := :OLD.top_changed;
   p_new := :NEW.top_changed;
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
p_column_name := 'DEBT_ONLY';
   p_old := :OLD.debt_only;
   p_new := :NEW.debt_only;
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