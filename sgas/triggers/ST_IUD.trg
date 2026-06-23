DROP TRIGGER SGAS.ST_IUD;

CREATE OR REPLACE TRIGGER SGAS.ST_IUD
AFTER DELETE OR INSERT OR UPDATE
OF DOB
  ,TITLE
  ,INITIALS
  ,FORENAMES
  ,SURNAME
  ,SEX
  ,RESIDENCE_ID
  ,BIRTH_COUNTRY_CODE
  ,RESIDENCE_COUNTRY_CODE
  ,NATION_COUNTRY_CODE
  ,NOMINEE
  ,PAYMENT_METHOD
  ,OVERPAY_STAT
  ,OVERPAYMENT
  ,DEF_OVERPAYMENT
  ,SNB_OVERPAYMENT
  ,SNB_DEF_OVERPAYMENT
  ,DISABLED
  ,NI_NO
  ,MARITAL_STATUS
  ,MARRIAGE_DATE
  ,ACCOUNT_NO
  ,SORT_CODE
  ,NOM_METHOD
  ,NOM_NAME
  ,MAIDEN_NAME
  ,DSA_EQMT
  ,BIRTH_CERT_FLAG
  ,BANKRUPT_FLAG
  ,VALID_DUPLICATE_ACC
  ,DUP_BANK_REASON
  ,QA_COUNT
  ,STUD_SUSPEND
  ,DECEASED_FLAG
  ,DECEASED_SOURCE
  ,ESTRANGED
  ,LAST_UPDATED_BY
ON SGAS.STUD
REFERENCING NEW AS NEW OLD AS OLD
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
   p_username       stud_aud.username%TYPE       := :NEW.last_updated_by;
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
   v_chngd          VARCHAR2 (1)                 := 'N';
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_stud_ref_no := :NEW.stud_ref_no;
      p_table_pkey1 := :NEW.stud_ref_no;
      p_username := :NEW.last_updated_by;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_stud_ref_no := :OLD.stud_ref_no;
      p_table_pkey1 := :OLD.stud_ref_no;
      p_username := :OLD.last_updated_by;
   END IF;

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
   p_column_name := 'STUD_SUSPEND';
   p_old := :OLD.stud_suspend;
   p_new := :NEW.stud_suspend;
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
   p_column_name := 'DECEASED_FLAG';
   p_old := :OLD.deceased_flag;
   p_new := :NEW.deceased_flag;
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
   p_column_name := 'DECEASED_SOURCE';
   p_old := :OLD.deceased_source;
   p_new := :NEW.deceased_source;
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
   p_column_name := 'ESTRANGED';
   p_old := :OLD.estranged;
   p_new := :NEW.estranged;
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
END st_iud;
/