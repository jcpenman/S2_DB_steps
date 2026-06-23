-- DSA_ALLOWANCE.sql
-- Description: Table holding all DSA ALLOWANCE data for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      24.09.09    R Hunter (SAAS)         Initial Version.
-- 1.1      24.09.09    A.Bowman (SAAS)         Added audit triggers
-- 1.2      06.10.09    A.Bowman (SAAS)         Added new columns and amended trigger accordingly
-- 1.3      16.11.09    A.Bowman (SAAS)         Moved the following columns from this table to the DSA_PAYMENT table
--                                              amount_rate, reference, period_start_date, period_end_date, receipt_required, receipt_received,
--                                              receipt_amount, invoice_ref and notes.
--                                              Renamed the increase_max and move_allowance columns to statutory_override_limit and general_override_limit respectively
--                                              Removed the nominee_id column.
--                                              Amended the audit trigger in line with these changes.
-- 1.4      28.01.10    A.Bowman (SAAS)         Amended audit triggers
-- 1.5      05.05.10    A.Bowman (SAAS)         Added foreign key references
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.DSA_ALLOWANCE
 DROP PRIMARY KEY CASCADE
/

DROP TABLE sgas.dsa_allowance CASCADE CONSTRAINTS PURGE
/
--
-- DSA_ALLOWANCE  (Table) 
--
CREATE TABLE sgas.dsa_allowance
(
  ID                  NUMBER(10) NOT NULL,
  dsa_application_id  NUMBER(10),
  stud_session_id     NUMBER(10),
  stud_crse_year_id   NUMBER(10),
  dsa_category_id     NUMBER(10),
  max_amount          NUMBER(15,2),
  available_amount    NUMBER(15,2),
  paid_amount         NUMBER(15,2),
  travel_amount       NUMBER(15,2),
  payment_due_date    DATE,
  date_paid           DATE,
  statutory_override_limit VARCHAR2(1) DEFAULT 'N',
  general_override_limit VARCHAR2(1) DEFAULT 'N',
  --1.2
  reminders_sent      NUMBER(2) DEFAULT 0,
  date_last_reminder_sent DATE,
  last_updated_by     VARCHAR2(15 BYTE)          DEFAULT USER                  NOT NULL,
  last_updated_on     DATE                       DEFAULT SYSDATE               NOT NULL
)
TABLESPACE users
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCOMPRESS
NOCACHE
NOPARALLEL
MONITORING
/



CREATE UNIQUE INDEX dsa_allowance_pk ON sgas.dsa_allowance
(id)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE OR REPLACE TRIGGER SGAS.DSA_ALL_iud
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
ON SGAS.DSA_ALLOWANCE FOR EACH ROW
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
SHOW ERRORS;

ALTER TABLE sgas.dsa_allowance ADD (
  CONSTRAINT dsa_allowance_pk
 PRIMARY KEY
 (id)
    USING INDEX
    TABLESPACE users
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64 k
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));

ALTER TABLE SGAS.DSA_ALLOWANCE ADD (
  CONSTRAINT F1_DSAA 
 FOREIGN KEY (DSA_APPLICATION_ID) 
 REFERENCES SGAS.DSA_APPLICATION (ID));

ALTER TABLE SGAS.DSA_ALLOWANCE ADD (
  CONSTRAINT F2_DSAA 
 FOREIGN KEY (STUD_SESSION_ID) 
 REFERENCES SGAS.STUD_SESSION (STUD_SESSION_ID));

ALTER TABLE SGAS.DSA_ALLOWANCE ADD (
  CONSTRAINT F3_DSAA 
 FOREIGN KEY (STUD_CRSE_YEAR_ID) 
 REFERENCES SGAS.STUD_CRSE_YEAR (STUD_CRSE_YEAR_ID));

ALTER TABLE SGAS.DSA_ALLOWANCE ADD (
  CONSTRAINT F4_DSAA 
 FOREIGN KEY (DSA_CATEGORY_ID) 
 REFERENCES SGAS.DSA_CATEGORY (DSA_CATEGORY_ID));


-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM dsa_allowance
/
CREATE PUBLIC SYNONYM dsa_allowance FOR sgas.dsa_allowance
/
DROP SEQUENCE sgas.dsa_allowance_id_seq
/
--
-- DSA_ALLOWANCE_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.dsa_allowance_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_dsa_allowance_id_seq
   BEFORE INSERT
   ON sgas.dsa_allowance
   FOR EACH ROW
BEGIN
   SELECT dsa_allowance_id_seq.NEXTVAL
     INTO :NEW.id
     FROM DUAL;
END; 
                                                                      

COMMIT;


