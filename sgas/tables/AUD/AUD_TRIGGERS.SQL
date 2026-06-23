CREATE OR REPLACE TRIGGER CRSE_IUD_AUD
   AFTER INSERT OR DELETE OR UPDATE 
   ON CRSE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                         := SYSDATE;
   p_column_name    CRSE_AUD.column_name%TYPE    := NULL;
   p_table_pkey1    CRSE_AUD.table_pkey1%TYPE    := :OLD.CRSE_ID;
   p_table_pkey2    CRSE_AUD.table_pkey2%TYPE    := NULL;
   p_table_pkey3    CRSE_AUD.table_pkey3%TYPE    := NULL;
   p_table_pkey4    CRSE_AUD.table_pkey4%TYPE    := NULL;
   p_table_pkey5    CRSE_AUD.table_pkey5%TYPE    := NULL;
   p_old            CRSE_AUD.OLD%TYPE            := NULL;
   p_new            CRSE_AUD.NEW%TYPE            := NULL;
   p_action         CRSE_AUD.action%TYPE         := NULL;
   p_username       CRSE_AUD.username%TYPE       := :NEW.LAST_UPDATED_BY;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.CRSE_ID;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.CRSE_ID;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'INST_NAME';
   p_old := TO_CHAR (:OLD.INST_NAME);
   p_new := TO_CHAR (:NEW.INST_NAME);
   pk_steps_aud.ins_crse_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'CRSE_NAME';
   p_old := :OLD.CRSE_NAME;
   p_new := :NEW.CRSE_NAME;
   pk_steps_aud.ins_crse_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'FEES_CAMPUS';
   p_old := :OLD.FEES_CAMPUS;
   p_new := :NEW.FEES_CAMPUS;
   pk_steps_aud.ins_crse_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'MAINT_CAMPUS';
   p_old := :OLD.MAINT_CAMPUS;
   p_new := :NEW.MAINT_CAMPUS;
   pk_steps_aud.ins_crse_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'QUAL_TYPE';
   p_old := :OLD.QUAL_TYPE;
   p_new := :NEW.QUAL_TYPE;
   pk_steps_aud.ins_crse_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'SCHEME_TYPE';
   p_old := :OLD.SCHEME_TYPE;
   p_new := :NEW.SCHEME_TYPE;
   pk_steps_aud.ins_crse_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'APPROVED';
   p_old := :OLD.APPROVED;
   p_new := :NEW.APPROVED;
   pk_steps_aud.ins_crse_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'DEPARTMENT';
   p_old := :OLD.DEPARTMENT;
   p_new := :NEW.DEPARTMENT;
   pk_steps_aud.ins_crse_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'SUBJECT_CAT_ID';
   p_old := :OLD.SUBJECT_CAT_ID;
   p_new := :NEW.SUBJECT_CAT_ID;
   pk_steps_aud.ins_crse_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'SUPERVISOR';
   p_old := :OLD.SUPERVISOR;
   p_new := :NEW.SUPERVISOR;
   pk_steps_aud.ins_crse_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'PAMS_COURSE';
   p_old := :OLD.PAMS_COURSE;
   p_new := :NEW.PAMS_COURSE;
   pk_steps_aud.ins_crse_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'SKELETON';
   p_old := :OLD.SKELETON;
   p_new := :NEW.SKELETON;
   pk_steps_aud.ins_crse_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'HEI_CRSE_CODE';
   p_old := :OLD.HEI_CRSE_CODE;
   p_new := :NEW.HEI_CRSE_CODE;
   pk_steps_aud.ins_crse_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'GE_LIABLE';
   p_old := :OLD.GE_LIABLE;
   p_new := :NEW.GE_LIABLE;
   pk_steps_aud.ins_crse_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           
END crse_iud_aud;

CREATE OR REPLACE TRIGGER CRSE_SESSION_IUD_AUD
   AFTER INSERT OR DELETE OR UPDATE 
   ON CRSE_SESSION    FOR EACH ROW
DECLARE
   p_aud_date       DATE                            := SYSDATE;
   p_column_name    CRSE_SESSION_AUD.column_name%TYPE    := NULL;
   p_table_pkey1    CRSE_SESSION_AUD.table_pkey1%TYPE    := :OLD.CRSE_SESSION_ID;
   p_table_pkey2    CRSE_SESSION_AUD.table_pkey2%TYPE    := NULL;
   p_table_pkey3    CRSE_SESSION_AUD.table_pkey3%TYPE    := NULL;
   p_table_pkey4    CRSE_SESSION_AUD.table_pkey4%TYPE    := NULL;
   p_table_pkey5    CRSE_SESSION_AUD.table_pkey5%TYPE    := NULL;
   p_old            CRSE_SESSION_AUD.OLD%TYPE            := NULL;
   p_new            CRSE_SESSION_AUD.NEW%TYPE            := NULL;
   p_action         CRSE_SESSION_AUD.action%TYPE         := NULL;
   p_username       CRSE_SESSION_AUD.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_session_code   CRSE_SESSION_AUD.session_code%TYPE   := :NEW.SESSION_CODE;
   p_crse_id    	CRSE_SESSION_AUD.crse_id%TYPE    	 := :NEW.CRSE_ID;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.CRSE_SESSION_ID;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.CRSE_SESSION_ID;
      p_username := :OLD.last_updated_by;
	  p_session_code := :OLD.SESSION_CODE;
	  p_crse_id := :OLD.CRSE_ID;
   END IF;

   p_column_name := 'CRSE_ID';
   p_old := TO_CHAR (:OLD.CRSE_ID);
   p_new := TO_CHAR (:NEW.CRSE_ID);
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
   p_column_name := 'SESSION_CODE';
   p_old := :OLD.SESSION_CODE;
   p_new := :NEW.SESSION_CODE;
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
   p_column_name := 'TUITION_FEE_TYPE_CODE';
   p_old := :OLD.TUITION_FEE_TYPE_CODE;
   p_new := :NEW.TUITION_FEE_TYPE_CODE;
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
   p_column_name := 'MAX_DURATION';
   p_old := :OLD.MAX_DURATION;
   p_new := :NEW.MAX_DURATION;
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
   p_column_name := 'PSAS_LOAN';
   p_old := :OLD.PSAS_LOAN;
   p_new := :NEW.PSAS_LOAN;
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
   p_column_name := 'PSAS_CAT';
   p_old := :OLD.PSAS_CAT;
   p_new := :NEW.PSAS_CAT;
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
   p_column_name := 'TEACHER_SHORT';
   p_old := :OLD.TEACHER_SHORT;
   p_new := :NEW.TEACHER_SHORT;
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
   p_column_name := 'PSAS_BID_NON_QUOTA';
   p_old := :OLD.PSAS_BID_NON_QUOTA;
   p_new := :NEW.PSAS_BID_NON_QUOTA;
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
   p_column_name := 'PSAS_ALLOC_DATE';
   p_old := :OLD.PSAS_ALLOC_DATE;
   p_new := :NEW.PSAS_ALLOC_DATE;
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
   p_column_name := 'PSAS_ALLOC_NO';
   p_old := :OLD.PSAS_ALLOC_NO;
   p_new := :NEW.PSAS_ALLOC_NO;
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
   p_column_name := 'PSAS_BID_DOC_REF';
   p_old := :OLD.PSAS_BID_DOC_REF;
   p_new := :NEW.PSAS_BID_DOC_REF;
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
   p_column_name := 'PSAS_BID_DATE';
   p_old := :OLD.PSAS_BID_DATE;
   p_new := :NEW.PSAS_BID_DATE;
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
   p_column_name := 'PSAS_BID_QUOTA';
   p_old := :OLD.PSAS_BID_QUOTA;
   p_new := :NEW.PSAS_BID_QUOTA;
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
   p_column_name := 'PAID_SANDWICH_FEE_TYPE_CODE';
   p_old := :OLD.PAID_SANDWICH_FEE_TYPE_CODE;
   p_new := :NEW.PAID_SANDWICH_FEE_TYPE_CODE;
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
   p_column_name := 'HIGHER_TUITION_FEE_TYPE_CODE';
   p_old := :OLD.HIGHER_TUITION_FEE_TYPE_CODE;
   p_new := :NEW.HIGHER_TUITION_FEE_TYPE_CODE;
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
   p_column_name := 'HIGHER_SANDWICH_FEE_TYPE_CODE';
   p_old := :OLD.HIGHER_SANDWICH_FEE_TYPE_CODE;
   p_new := :NEW.HIGHER_SANDWICH_FEE_TYPE_CODE;
   pk_steps_aud.ins_crse_session_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id
                           );
                                                      
END crse_session_iud_aud;

CREATE OR REPLACE TRIGGER CRSE_YEAR_IUD_AUD
   AFTER INSERT OR DELETE OR UPDATE 
   ON CRSE_YEAR    FOR EACH ROW
DECLARE
   p_aud_date       DATE                            := SYSDATE;
   p_column_name    CRSE_YEAR_AUD.column_name%TYPE    := NULL;
   p_table_pkey1    CRSE_YEAR_AUD.table_pkey1%TYPE    := :OLD.CRSE_YEAR_ID;
   p_table_pkey2    CRSE_YEAR_AUD.table_pkey2%TYPE    := NULL;
   p_table_pkey3    CRSE_YEAR_AUD.table_pkey3%TYPE    := NULL;
   p_table_pkey4    CRSE_YEAR_AUD.table_pkey4%TYPE    := NULL;
   p_table_pkey5    CRSE_YEAR_AUD.table_pkey5%TYPE    := NULL;
   p_old            CRSE_YEAR_AUD.OLD%TYPE            := NULL;
   p_new            CRSE_YEAR_AUD.NEW%TYPE            := NULL;
   p_action         CRSE_YEAR_AUD.action%TYPE         := NULL;
   p_username       CRSE_YEAR_AUD.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_session_code   CRSE_YEAR_AUD.session_code%TYPE   := NULL;
   p_crse_id    	CRSE_YEAR_AUD.crse_id%TYPE        := :NEW.CRSE_ID;
   p_crse_year_no   CRSE_YEAR_AUD.crse_year_no%TYPE   := :NEW.CRSE_YEAR_NO;

BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.CRSE_YEAR_ID;
	  SELECT CS.SESSION_CODE INTO p_session_code FROM CRSE_SESSION CS WHERE CS.CRSE_SESSION_ID = :NEW.CRSE_SESSION_ID;
   ELSIF UPDATING
   THEN
      p_action := 'U';
	  SELECT CS.SESSION_CODE INTO p_session_code FROM CRSE_SESSION CS WHERE CS.CRSE_SESSION_ID = :NEW.CRSE_SESSION_ID;
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.CRSE_YEAR_ID;
      p_username := :OLD.last_updated_by;	  
	  p_crse_id := :OLD.CRSE_ID;
	  p_crse_year_no := :OLD.CRSE_YEAR_NO;
	  SELECT CS.SESSION_CODE INTO p_session_code FROM CRSE_SESSION CS WHERE CS.CRSE_SESSION_ID = :OLD.CRSE_SESSION_ID;
   END IF;
   
   p_column_name := 'CRSE_ID';
   p_old := TO_CHAR (:OLD.CRSE_ID);
   p_new := TO_CHAR (:NEW.CRSE_ID);
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'CRSE_SESSION_ID';
   p_old := :OLD.CRSE_SESSION_ID;
   p_new := :NEW.CRSE_SESSION_ID;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'CRSE_YEAR_NO';
   p_old := :OLD.CRSE_YEAR_NO;
   p_new := :NEW.CRSE_YEAR_NO;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'INST_CODE';
   p_old := :OLD.INST_CODE;
   p_new := :NEW.INST_CODE;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'STUDY_ABROAD';
   p_old := :OLD.STUDY_ABROAD;
   p_new := :NEW.STUDY_ABROAD;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'DEFAULT_TERMS';
   p_old := :OLD.DEFAULT_TERMS;
   p_new := :NEW.DEFAULT_TERMS;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'SPLIT_SESSION';
   p_old := :OLD.SPLIT_SESSION;
   p_new := :NEW.SPLIT_SESSION;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'CRSE_TYPE';
   p_old := :OLD.CRSE_TYPE;
   p_new := :NEW.CRSE_TYPE;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'REQ_TUITION_FEE';
   p_old := :OLD.REQ_TUITION_FEE;
   p_new := :NEW.REQ_TUITION_FEE;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'EU_FLAG';
   p_old := :OLD.EU_FLAG;
   p_new := :NEW.EU_FLAG;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'CUTOFF_TYPE';
   p_old := :OLD.CUTOFF_TYPE;
   p_new := :NEW.CUTOFF_TYPE;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'CUTOFF_DATE';
   p_old := :OLD.CUTOFF_DATE;
   p_new := :NEW.CUTOFF_DATE;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'CUTOFF_ITEM_NAME';
   p_old := :OLD.CUTOFF_ITEM_NAME;
   p_new := :NEW.CUTOFF_ITEM_NAME;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'SEMESTER';
   p_old := :OLD.SEMESTER;
   p_new := :NEW.SEMESTER;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'HEI_CRSE_CODE';
   p_old := :OLD.HEI_CRSE_CODE;
   p_new := :NEW.HEI_CRSE_CODE;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'VAR_TUITION_FEE_AMNT';
   p_old := :OLD.VAR_TUITION_FEE_AMNT;
   p_new := :NEW.VAR_TUITION_FEE_AMNT;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'VAR_SANDWICH_TUITION_FEE_AMNT';
   p_old := :OLD.VAR_SANDWICH_TUITION_FEE_AMNT;
   p_new := :NEW.VAR_SANDWICH_TUITION_FEE_AMNT;
   pk_steps_aud.ins_crse_year_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
                                                      
END crse_year_iud_aud;

CREATE OR REPLACE TRIGGER CRSE_TERM_IUD_AUD
   AFTER INSERT OR DELETE OR UPDATE 
   ON CRSE_TERM    FOR EACH ROW
DECLARE
   p_aud_date       DATE                            := SYSDATE;
   p_column_name    CRSE_TERM_AUD.column_name%TYPE    := NULL;
   p_table_pkey1    CRSE_TERM_AUD.table_pkey1%TYPE    := :OLD.CRSE_YEAR_ID;
   p_table_pkey2    CRSE_TERM_AUD.table_pkey2%TYPE    := :OLD.TERM_NO;
   p_table_pkey3    CRSE_TERM_AUD.table_pkey3%TYPE    := NULL;
   p_table_pkey4    CRSE_TERM_AUD.table_pkey4%TYPE    := NULL;
   p_table_pkey5    CRSE_TERM_AUD.table_pkey5%TYPE    := NULL;
   p_old            CRSE_TERM_AUD.OLD%TYPE            := NULL;
   p_new            CRSE_TERM_AUD.NEW%TYPE            := NULL;
   p_action         CRSE_TERM_AUD.action%TYPE         := NULL;
   p_username       CRSE_TERM_AUD.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_session_code   CRSE_TERM_AUD.session_code%TYPE   := NULL;
   p_crse_id    	CRSE_TERM_AUD.crse_id%TYPE        := NULL;
   p_crse_year_no	CRSE_TERM_AUD.crse_year_no%TYPE   := NULL;

BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.CRSE_YEAR_ID;
      p_table_pkey2 := :NEW.TERM_NO;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.CRSE_YEAR_ID;
      p_table_pkey2 := :OLD.TERM_NO;
      p_username := :OLD.last_updated_by;
   END IF;

   SELECT CY.CRSE_ID INTO p_crse_id FROM CRSE_YEAR CY WHERE CY.CRSE_YEAR_ID = p_table_pkey1;
   SELECT CY.CRSE_YEAR_NO INTO p_crse_year_no FROM CRSE_YEAR CY WHERE CY.CRSE_YEAR_ID = p_table_pkey1;
   SELECT CS.SESSION_CODE INTO p_session_code FROM CRSE_SESSION CS WHERE CS.CRSE_SESSION_ID = (SELECT CY.CRSE_SESSION_ID FROM CRSE_YEAR CY WHERE CY.CRSE_YEAR_ID = p_table_pkey1);
   
   p_column_name := 'DAYS';
   p_old := TO_CHAR (:OLD.DAYS);
   p_new := TO_CHAR (:NEW.DAYS);
   pk_steps_aud.ins_crse_term_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'START_DATE';
   p_old := :OLD.START_DATE;
   p_new := :NEW.START_DATE;
   pk_steps_aud.ins_crse_term_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );
   p_column_name := 'END_DATE';
   p_old := :OLD.END_DATE;
   p_new := :NEW.END_DATE;
   pk_steps_aud.ins_crse_term_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username,
                            p_session_code,
                            p_crse_id,
                            p_crse_year_no
                           );

                                                      
END crse_term_iud_aud;

CREATE OR REPLACE TRIGGER INST_TERM_IUD_AUD
   AFTER INSERT OR DELETE OR UPDATE 
   ON INST_TERM    FOR EACH ROW
DECLARE
   p_aud_date       DATE                            := SYSDATE;
   p_column_name    INST_TERM_AUD.column_name%TYPE    := NULL;
   p_table_pkey1    INST_TERM_AUD.table_pkey1%TYPE    := :OLD.INST_CODE;
   p_table_pkey2    INST_TERM_AUD.table_pkey2%TYPE    := :OLD.SESSION_CODE;
   p_table_pkey3    INST_TERM_AUD.table_pkey3%TYPE    := :OLD.TERM_NO;
   p_table_pkey4    INST_TERM_AUD.table_pkey4%TYPE    := NULL;
   p_table_pkey5    INST_TERM_AUD.table_pkey5%TYPE    := NULL;
   p_old            INST_TERM_AUD.OLD%TYPE            := NULL;
   p_new            INST_TERM_AUD.NEW%TYPE            := NULL;
   p_action         INST_TERM_AUD.action%TYPE         := NULL;
   p_username       INST_TERM_AUD.username%TYPE       := :NEW.LAST_UPDATED_BY;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.INST_CODE;
      p_table_pkey2 := :NEW.SESSION_CODE;
      p_table_pkey3 := :NEW.TERM_NO;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.INST_CODE;
      p_table_pkey2 := :OLD.SESSION_CODE;
      p_table_pkey3 := :OLD.TERM_NO;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'DAYS';
   p_old := TO_CHAR (:OLD.DAYS);
   p_new := TO_CHAR (:NEW.DAYS);
   pk_steps_aud.ins_inst_term_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'START_DATE';
   p_old := :OLD.START_DATE;
   p_new := :NEW.START_DATE;
   pk_steps_aud.ins_inst_term_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'END_DATE';
   p_old := :OLD.END_DATE;
   p_new := :NEW.END_DATE;
   pk_steps_aud.ins_inst_term_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );

                                                      
END inst_term_iud_aud;

CREATE OR REPLACE TRIGGER INST_IUD_AUD
   AFTER INSERT OR DELETE OR UPDATE 
   ON INST    FOR EACH ROW
DECLARE
   p_aud_date       DATE                            := SYSDATE;
   p_column_name    INST_AUD.column_name%TYPE    := NULL;
   p_table_pkey1    INST_AUD.table_pkey1%TYPE    := :OLD.INST_CODE;
   p_table_pkey2    INST_AUD.table_pkey2%TYPE    := NULL;
   p_table_pkey3    INST_AUD.table_pkey3%TYPE    := NULL;
   p_table_pkey4    INST_AUD.table_pkey4%TYPE    := NULL;
   p_table_pkey5    INST_AUD.table_pkey5%TYPE    := NULL;
   p_old            INST_AUD.OLD%TYPE            := NULL;
   p_new            INST_AUD.NEW%TYPE            := NULL;
   p_action         INST_AUD.action%TYPE         := NULL;
   p_username       INST_AUD.username%TYPE       := :NEW.LAST_UPDATED_BY;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.INST_CODE;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.INST_CODE;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'INST_TYPE_ID';
   p_old := TO_CHAR (:OLD.INST_TYPE_ID);
   p_new := TO_CHAR (:NEW.INST_TYPE_ID);
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'INST_NAME';
   p_old := :OLD.INST_NAME;
   p_new := :NEW.INST_NAME;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'NOMINATED_IND';
   p_old := :OLD.NOMINATED_IND;
   p_new := :NEW.NOMINATED_IND;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );

   p_column_name := 'SEMESTER';
   p_old := :OLD.SEMESTER;
   p_new := :NEW.SEMESTER;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'CATEGORY';
   p_old := :OLD.CATEGORY;
   p_new := :NEW.CATEGORY;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'REGION_CODE';
   p_old := :OLD.REGION_CODE;
   p_new := :NEW.REGION_CODE;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'COLLEGE_TYPE';
   p_old := :OLD.COLLEGE_TYPE;
   p_new := :NEW.COLLEGE_TYPE;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'PAYMENT_METHOD';
   p_old := :OLD.PAYMENT_METHOD;
   p_new := :NEW.PAYMENT_METHOD;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'LOCATION_IND';
   p_old := :OLD.LOCATION_IND;
   p_new := :NEW.LOCATION_IND;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'NOM_NAME';
   p_old := :OLD.NOM_NAME;
   p_new := :NEW.NOM_NAME;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'HOUSE_NO_OR_NAME';
   p_old := :OLD.HOUSE_NO_OR_NAME;
   p_new := :NEW.HOUSE_NO_OR_NAME;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_L1';
   p_old := :OLD.ADDR_L1;
   p_new := :NEW.ADDR_L1;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_L2';
   p_old := :OLD.ADDR_L2;
   p_new := :NEW.ADDR_L2;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_L3';
   p_old := :OLD.ADDR_L3;
   p_new := :NEW.ADDR_L3;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_L4';
   p_old := :OLD.ADDR_L4;
   p_new := :NEW.ADDR_L4;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'POST_CODE';
   p_old := :OLD.POST_CODE;
   p_new := :NEW.POST_CODE;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_EASTING';
   p_old := :OLD.ADDR_EASTING;
   p_new := :NEW.ADDR_EASTING;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_NORTHING';
   p_old := :OLD.ADDR_NORTHING;
   p_new := :NEW.ADDR_NORTHING;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_NAME';
   p_old := :OLD.BANK_NAME;
   p_new := :NEW.BANK_NAME;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_SORT_CODE';
   p_old := :OLD.BANK_SORT_CODE;
   p_new := :NEW.BANK_SORT_CODE;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ACCOUNT_NO';
   p_old := :OLD.ACCOUNT_NO;
   p_new := :NEW.ACCOUNT_NO;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_HOUSE_NO_NAME';
   p_old := :OLD.BANK_HOUSE_NO_NAME;
   p_new := :NEW.BANK_HOUSE_NO_NAME;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_ADDR_L1';
   p_old := :OLD.BANK_ADDR_L1;
   p_new := :NEW.BANK_ADDR_L1;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_ADDR_L2';
   p_old := :OLD.BANK_ADDR_L2;
   p_new := :NEW.BANK_ADDR_L2;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_ADDR_L3';
   p_old := :OLD.BANK_ADDR_L3;
   p_new := :NEW.BANK_ADDR_L3;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_ADDR_L4';
   p_old := :OLD.BANK_ADDR_L4;
   p_new := :NEW.BANK_ADDR_L4;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_POST_CODE';
   p_old := :OLD.BANK_POST_CODE;
   p_new := :NEW.BANK_POST_CODE;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'TELE_NO';
   p_old := :OLD.TELE_NO;
   p_new := :NEW.TELE_NO;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'FINANCE_CONTACT';
   p_old := :OLD.FINANCE_CONTACT;
   p_new := :NEW.FINANCE_CONTACT;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'FINANCE_OFFICE';
   p_old := :OLD.FINANCE_OFFICE;
   p_new := :NEW.FINANCE_OFFICE;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'PRINCIPAL';
   p_old := :OLD.PRINCIPAL;
   p_new := :NEW.PRINCIPAL;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'FORMS_OFFICE';
   p_old := :OLD.FORMS_OFFICE;
   p_new := :NEW.FORMS_OFFICE;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'SKELETON';
   p_old := :OLD.SKELETON;
   p_new := :NEW.SKELETON;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'MAILSORT';
   p_old := :OLD.MAILSORT;
   p_new := :NEW.MAILSORT;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'LABELS';
   p_old := :OLD.LABELS;
   p_new := :NEW.LABELS;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'LETTER';
   p_old := :OLD.LETTER;
   p_new := :NEW.LETTER;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BREAK';
   p_old := :OLD.BREAK;
   p_new := :NEW.BREAK;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'INSTAL_NO';
   p_old := :OLD.INSTAL_NO;
   p_new := :NEW.INSTAL_NO;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'INSTAL_INFO';
   p_old := :OLD.INSTAL_INFO;
   p_new := :NEW.INSTAL_INFO;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'PAMS';
   p_old := :OLD.PAMS;
   p_new := :NEW.PAMS;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'CAM_DEBT';
   p_old := :OLD.CAM_DEBT;
   p_new := :NEW.CAM_DEBT;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'LAST_STATUS_REP';
   p_old := :OLD.LAST_STATUS_REP;
   p_new := :NEW.LAST_STATUS_REP;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'CSV_ID';
   p_old := :OLD.CSV_ID;
   p_new := :NEW.CSV_ID;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'LIS_ID';
   p_old := :OLD.LIS_ID;
   p_new := :NEW.LIS_ID;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'NON_PUBLIC_FUND';
   p_old := :OLD.NON_PUBLIC_FUND;
   p_new := :NEW.NON_PUBLIC_FUND;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'HEI_INST_CODE';
   p_old := :OLD.HEI_INST_CODE;
   p_new := :NEW.HEI_INST_CODE;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BACS_FIRST';
   p_old := :OLD.BACS_FIRST;
   p_new := :NEW.BACS_FIRST;
   pk_steps_aud.ins_inst_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                                                      
                                                      
END inst_iud_aud;

CREATE OR REPLACE TRIGGER CAMPUS_IUD_AUD
   AFTER INSERT OR DELETE OR UPDATE 
   ON CAMPUS    FOR EACH ROW
DECLARE
   p_aud_date       DATE                            := SYSDATE;
   p_column_name    CAMPUS_AUD.column_name%TYPE    := NULL;
   p_table_pkey1    CAMPUS_AUD.table_pkey1%TYPE    := :OLD.CAMPUS_ID;
   p_table_pkey2    CAMPUS_AUD.table_pkey2%TYPE    := NULL;
   p_table_pkey3    CAMPUS_AUD.table_pkey3%TYPE    := NULL;
   p_table_pkey4    CAMPUS_AUD.table_pkey4%TYPE    := NULL;
   p_table_pkey5    CAMPUS_AUD.table_pkey5%TYPE    := NULL;
   p_old            CAMPUS_AUD.OLD%TYPE            := NULL;
   p_new            CAMPUS_AUD.NEW%TYPE            := NULL;
   p_action         CAMPUS_AUD.action%TYPE         := NULL;
   p_username       CAMPUS_AUD.username%TYPE       := :NEW.LAST_UPDATED_BY;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.CAMPUS_ID;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.CAMPUS_ID;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'INST_CODE';
   p_old := TO_CHAR (:OLD.INST_CODE);
   p_new := TO_CHAR (:NEW.INST_CODE);
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'CAMPUS_CODE';
   p_old := :OLD.CAMPUS_CODE;
   p_new := :NEW.CAMPUS_CODE;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
   p_column_name := 'NAME';
   p_old := :OLD.NAME;
   p_new := :NEW.NAME;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );

   p_column_name := 'HOUSE_NO_NAME';
   p_old := :OLD.HOUSE_NO_NAME;
   p_new := :NEW.HOUSE_NO_NAME;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           
   p_column_name := 'ADDR_L1';
   p_old := :OLD.ADDR_L1;
   p_new := :NEW.ADDR_L1;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_L2';
   p_old := :OLD.ADDR_L2;
   p_new := :NEW.ADDR_L2;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_L3';
   p_old := :OLD.ADDR_L3;
   p_new := :NEW.ADDR_L3;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_L4';
   p_old := :OLD.ADDR_L4;
   p_new := :NEW.ADDR_L4;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'POSTCODE';
   p_old := :OLD.POSTCODE;
   p_new := :NEW.POSTCODE;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_EASTING';
   p_old := :OLD.ADDR_EASTING;
   p_new := :NEW.ADDR_EASTING;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ADDR_NORTHING';
   p_old := :OLD.ADDR_NORTHING;
   p_new := :NEW.ADDR_NORTHING;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'PAYMENT_METHOD';
   p_old := :OLD.PAYMENT_METHOD;
   p_new := :NEW.PAYMENT_METHOD;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           
   p_column_name := 'BANK_NAME';
   p_old := :OLD.BANK_NAME;
   p_new := :NEW.BANK_NAME;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_SORT_CODE';
   p_old := :OLD.BANK_SORT_CODE;
   p_new := :NEW.BANK_SORT_CODE;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'ACCOUNT_NO';
   p_old := :OLD.ACCOUNT_NO;
   p_new := :NEW.ACCOUNT_NO;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_HOUSE_NO_NAME';
   p_old := :OLD.BANK_HOUSE_NO_NAME;
   p_new := :NEW.BANK_HOUSE_NO_NAME;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_ADDR_L1';
   p_old := :OLD.BANK_ADDR_L1;
   p_new := :NEW.BANK_ADDR_L1;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_ADDR_L2';
   p_old := :OLD.BANK_ADDR_L2;
   p_new := :NEW.BANK_ADDR_L2;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_ADDR_L3';
   p_old := :OLD.BANK_ADDR_L3;
   p_new := :NEW.BANK_ADDR_L3;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_ADDR_L4';
   p_old := :OLD.BANK_ADDR_L4;
   p_new := :NEW.BANK_ADDR_L4;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'BANK_POST_CODE';
   p_old := :OLD.BANK_POST_CODE;
   p_new := :NEW.BANK_POST_CODE;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'CAMPUS_DEBT';
   p_old := :OLD.CAMPUS_DEBT;
   p_new := :NEW.CAMPUS_DEBT;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'CSV_ID';
   p_old := :OLD.CSV_ID;
   p_new := :NEW.CSV_ID;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                           

   p_column_name := 'FEE_LOAN_DEBT';
   p_old := :OLD.FEE_LOAN_DEBT;
   p_new := :NEW.FEE_LOAN_DEBT;
   pk_steps_aud.ins_campus_aud (p_aud_date,
                            p_column_name,
                            p_table_pkey1,
                            p_table_pkey2,
                            p_table_pkey3,
                            p_table_pkey4,
                            p_table_pkey5,
                            p_old,
                            p_new,
                            p_action,
                            p_username
                           );
                                                   
                                                      
END campus_iud_aud;
