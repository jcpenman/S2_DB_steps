-- ATTENDANCE_DATA.sql
-- Description: This new table will be used by SAAS to store information on whether enrolment and ongoing attendance information has been requested for each STUD_CRSE_YEAR record
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      09.03.11    A.Bowman  (SAAS)        Initial Version.
-- 1.1      09.06.11    A.Bowman  (SAAS)        Added new columns and audit trigger
-- 1.2      27.09.12    A.Bowman  (SAAS)        Updated table description
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE SGAS.ATTENDANCE_DATA
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.ATTENDANCE_DATA CASCADE CONSTRAINTS PURGE
/
--
-- ATTENDANCE_DATA  (Table) 
--
CREATE TABLE SGAS.ATTENDANCE_DATA
(
  attendance_data_id            NUMBER(10)       NOT NULL,
  stud_crse_year_id             NUMBER(9),
  chngd_since_last_report       VARCHAR2(1)            DEFAULT 'Y',
  enrol_confirmed               VARCHAR2(1),
  enrol_required                VARCHAR2(1),
  ongoing_attendance_confirmed  VARCHAR2(1),
  ongoing_required              VARCHAR2(1), 
  enrol_received_date           DATE,
  enrol_applied_date            DATE,
  enrol_updated_by              VARCHAR2(15),
  attend_received_date          DATE,
  attend_applied_date           DATE,
  attend_updated_by             VARCHAR2(15),
  restrict_support_enrol        VARCHAR2(1),
  restrict_payments_enrol       DATE,
  release_payments_enrol        DATE,
  restrict_support_attend       VARCHAR2(1),
  restrict_payments_attend      DATE,
  release_payments_attend       DATE,
  restrict_fee_support_attend   VARCHAR2(1),
  restrict_fee_attend           DATE,
  release_fee_attend            DATE,
  last_updated_by               VARCHAR2(15 BYTE)        DEFAULT 'System'                  NOT NULL,
  last_updated_on               DATE                     DEFAULT SYSDATE               NOT NULL
)
TABLESPACE users
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCOMPRESS
NOCACHE
NOPARALLEL
MONITORING;

CREATE UNIQUE INDEX ATTENDANCE_DATA_PK ON SGAS.ATTENDANCE_DATA
(ATTENDANCE_DATA_ID)
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

ALTER TABLE SGAS.ATTENDANCE_DATA ADD (
  CONSTRAINT ATTENDANCE_DATA_PK
 PRIMARY KEY
 (ATTENDANCE_DATA_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));


ALTER TABLE SGAS.attendance_data ADD (
  CONSTRAINT ATT_DATA_REP
 CHECK (chngd_since_last_report in ('Y','N')));

ALTER TABLE SGAS.ATTENDANCE_DATA ADD (
  CONSTRAINT F1_ATTD 
 FOREIGN KEY (STUD_CRSE_YEAR_ID) 
 REFERENCES SGAS.STUD_CRSE_YEAR (STUD_CRSE_YEAR_ID));

/* Formatted on 2011/06/24 10:36 (Formatter Plus v4.8.8) */
CREATE OR REPLACE TRIGGER sgas.att_data_iud
   AFTER INSERT OR DELETE OR UPDATE OF enrol_updated_by,
                                       attend_updated_by,
                                       restrict_support_enrol,
                                       restrict_payments_enrol,
                                       release_payments_enrol,
                                       restrict_support_attend,
                                       restrict_payments_attend,
                                       release_payments_attend,
                                       restrict_fee_support_attend,
                                       restrict_fee_attend,
                                       release_fee_attend,
                                       enrol_confirmed,
                                       enrol_required,
                                       ongoing_attendance_confirmed,
                                       ongoing_required,
                                       last_updated_by
   ON sgas.attendance_data
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                   := SYSDATE;
   p_column_name   attendance_data_aud.column_name%TYPE   := NULL;
   p_table_pkey1   attendance_data_aud.table_pkey1%TYPE
                                                   := :OLD.attendance_data_id;
   p_old           authenticate_stud_aud.OLD%TYPE         := NULL;
   p_new           authenticate_stud_aud.NEW%TYPE         := NULL;
   p_action        authenticate_stud_aud.action%TYPE      := NULL;
   p_username      authenticate_stud_aud.username%TYPE
                                                      := :NEW.last_updated_by;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.attendance_data_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.attendance_data_id;
      p_username := :OLD.last_updated_by;
   END IF;


   p_column_name := 'ENROL_UPDATED_BY';
   p_old := :OLD.enrol_updated_by;
   p_new := :NEW.enrol_updated_by;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'ATTEND_UPDATED_BY';
   p_old := :OLD.attend_updated_by;
   p_new := :NEW.attend_updated_by;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RESTRICT_SUPPORT_ENROL';
   p_old := :OLD.restrict_support_enrol;
   p_new := :NEW.restrict_support_enrol;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RESTRICT_PAYMENTS_ENROL';
   p_old := :OLD.restrict_payments_enrol;
   p_new := :NEW.restrict_payments_enrol;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RELEASE_PAYMENTS_ENROL';
   p_old := :OLD.release_payments_enrol;
   p_new := :NEW.release_payments_enrol;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RESTRICT_SUPPORT_ATTEND';
   p_old := :OLD.restrict_support_attend;
   p_new := :NEW.restrict_support_attend;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RESTRICT_PAYMENTS_ATTEND';
   p_old := :OLD.restrict_payments_attend;
   p_new := :NEW.restrict_payments_attend;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RELEASE_PAYMENTS_ATTEND';
   p_old := :OLD.release_payments_attend;
   p_new := :NEW.release_payments_attend;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RESTRICT_FEE_SUPPORT_ATTEND';
   p_old := :OLD.restrict_fee_support_attend;
   p_new := :NEW.restrict_fee_support_attend;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RESTRICT_FEE_ATTEND';
   p_old := :OLD.restrict_fee_attend;
   p_new := :NEW.restrict_fee_attend;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'RELEASE_FEE_ATTEND';
   p_old := :OLD.release_fee_attend;
   p_new := :NEW.release_fee_attend;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'ENROL_CONFIRMED';
   p_old := :OLD.enrol_confirmed;
   p_new := :NEW.enrol_confirmed;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'ENROL_REQUIRED';
   p_old := :OLD.enrol_required;
   p_new := :NEW.enrol_required;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'ONGOING_ATTENDANCE_CONFIRMED';
   p_old := :OLD.ongoing_attendance_confirmed;
   p_new := :NEW.ongoing_attendance_confirmed;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'ONGOING_REQUIRED';
   p_old := :OLD.ongoing_required;
   p_new := :NEW.ongoing_required;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );                              
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_att_data_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
END att_data_iud;
show errors;

-- 
-- Create public synonym: 
-- 

DROP PUBLIC SYNONYM ATTENDANCE_DATA
/

CREATE PUBLIC SYNONYM ATTENDANCE_DATA FOR sgas.ATTENDANCE_DATA
/

DROP SEQUENCE SGAS.ATTENDANCE_DATA_ID_SEQ
/

--
-- ATTENDANCE_DATA_ID_SEQ  (Sequence) 
--
CREATE SEQUENCE SGAS.ATTENDANCE_DATA_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
                                                                        
CREATE OR REPLACE TRIGGER SGAS.trig_att_data_seq
   BEFORE INSERT
   ON SGAS.ATTENDANCE_DATA    FOR EACH ROW
BEGIN
   SELECT attendance_data_id_seq.NEXTVAL
     INTO :NEW.attendance_data_id
     FROM DUAL;
END;
/
