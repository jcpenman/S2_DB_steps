-- STUD_INCOME_TYPE.sql
-- Description: Table holding Stud Income in StEPS
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      09.11.12    A Bowman (SAAS)         Initial Version. 
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.STUD_INCOME
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.STUD_INCOME CASCADE CONSTRAINTS PURGE;
--
-- STUD_INCOME  (Table) 
--
CREATE TABLE SGAS.STUD_INCOME
(
  STUD_INCOME_ID   NUMBER(10)                     NOT NULL,
  STUD_SESSION_ID     NUMBER(9)                  NOT NULL,
  INCOME_TYPE          NUMBER(1)                     NOT NULL,
  AMOUNT               NUMBER(9,2)               NOT NULL,        
  LAST_UPDATED_BY     VARCHAR2(15 BYTE)  DEFAULT User NOT NULL,
  LAST_UPDATED_ON            DATE               DEFAULT Sysdate NOT NULL
)
TABLESPACE STEPS_DATA
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE STUD_INCOME IS 'Table holding stud income in StEPS';

ALTER TABLE SGAS.STUD_INCOME ADD (
  CONSTRAINT STUD_INCOME_PK
 PRIMARY KEY
 (STUD_INCOME_ID)
    USING INDEX 
    TABLESPACE STEPS_INDEX);

ALTER TABLE stud_income ADD (
  CONSTRAINT f1_si
 FOREIGN KEY (stud_session_id)
 REFERENCES stud_session (stud_session_id));

ALTER  TABLE stud_income ADD (
  CONSTRAINT f2_si
 FOREIGN KEY (income_type)
 REFERENCES stud_income_type (income_type_id));

DROP SEQUENCE SGAS.STUD_INCOME_ID_SEQ;

CREATE SEQUENCE SGAS.STUD_INCOME_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


CREATE OR REPLACE TRIGGER SGAS.TRIG_STUD_INC_ID_SEQ
   BEFORE INSERT
   ON SGAS.STUD_INCOME    FOR EACH ROW
BEGIN
   SELECT STUD_INCOME_ID_SEQ.NEXTVAL
     INTO :NEW.STUD_INCOME_ID
     FROM DUAL;
END;

/* Formatted on 2012/11/19 10:46 (Formatter Plus v4.8.8) */
CREATE OR REPLACE TRIGGER stud_inc_iud
   AFTER INSERT OR DELETE OR UPDATE OF stud_income_id,
                                       stud_session_id,
                                       income_type,
                                       amount
   ON stud_income
   FOR EACH ROW
DECLARE
   p_aud_date       DATE                                := SYSDATE;
   p_column_name    stud_income_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_income_aud.table_pkey1%TYPE   := :OLD.stud_income_id;
   p_table_pkey2    stud_income_aud.table_pkey2%TYPE   := :OLD.stud_session_id;
   p_old            stud_income_aud.OLD%TYPE            := NULL;
   p_new            stud_income_aud.NEW%TYPE            := NULL;
   p_action         stud_income_aud.action%TYPE         := NULL;
   p_username       stud_income_aud.username%TYPE     := :NEW.last_updated_by;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_income_id;
      p_table_pkey2 := :NEW.stud_session_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.stud_income_id;
      p_table_pkey2 := :OLD.stud_session_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'STUD_INCOME_ID';
   p_old := :OLD.stud_income_id;
   p_new := :NEW.stud_income_id;
   pk_steps_aud.ins_stud_inc_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_table_pkey2,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'STUD_SESSION_ID';
   p_old := :OLD.stud_session_id;
   p_new := :NEW.stud_session_id;
   pk_steps_aud.ins_stud_inc_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_table_pkey2,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'INCOME_TYPE';
   p_old := :OLD.income_type;
   p_new := :NEW.income_type;
   pk_steps_aud.ins_stud_inc_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_table_pkey2,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'AMOUNT';
   p_old := :OLD.amount;
   p_new := :NEW.amount;
   pk_steps_aud.ins_stud_inc_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_table_pkey2,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_stud_inc_aud (p_aud_date,
                                  p_column_name,
                                  p_table_pkey1,
                                  p_table_pkey2,
                                  p_old,
                                  p_new,
                                  p_action,
                                  p_username
                                 );
END stud_inc_iud;
/

