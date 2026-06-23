-- NON_AWARD_PAYMENT_DATE.sql
-- Description: Table holding list of non payment dates for Awards 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      02.12.08    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author:   $
-- $Date:     $
-- $Revision: $  

ALTER TABLE SGAS.NON_AWARD_PAYMENT_DATE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.NON_AWARD_PAYMENT_DATE CASCADE CONSTRAINTS PURGE
/

--
-- NON_AWARD_PAYMENT_DATE  (Table) 
--

CREATE TABLE SGAS.NON_AWARD_PAYMENT_DATE
(
  NON_PAY_DATE_ID     NUMBER NOT NULL,
  NON_PAY_DATE   DATE NOT NULL,
  LAST_UPDATED_BY VARCHAR2(25 BYTE) DEFAULT USER NOT NULL,
  LAST_UPDATED_ON DATE DEFAULT SYSDATE NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
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

COMMENT ON COLUMN NON_AWARD_PAYMENT_DATE.NON_PAY_DATE_ID IS 'Unique non pay date identifier';

COMMENT ON COLUMN NON_AWARD_PAYMENT_DATE.NON_PAY_DATE IS 'An award non payment date';

COMMENT ON COLUMN NON_AWARD_PAYMENT_DATE.LAST_UPDATED_BY IS 'The user to last update or insert a row on the non_award_payment_date table';

COMMENT ON COLUMN NON_AWARD_PAYMENT_DATE.LAST_UPDATED_ON IS 'The date of the latest update or insert on the non_award_payment_date table';

CREATE UNIQUE INDEX NON_AWARD_PAYMENT_DATE_PK ON NON_AWARD_PAYMENT_DATE
(NON_PAY_DATE_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE SGAS.NON_AWARD_PAYMENT_DATE ADD (
  CONSTRAINT NON_AWARD_PAYMENT_DATE_PK
 PRIMARY KEY
 (NON_PAY_DATE_ID)
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

/******************************************************************************
NAME: NAPD_IUD        
PURPOSE: Trigger to meet audit requirements

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        29.01.2010  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/
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


GRANT SELECT ON SGAS.NON_AWARD_PAYMENT_DATE TO PUBLIC;
-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM NON_AWARD_PAYMENT_DATE
/

CREATE PUBLIC SYNONYM NON_AWARD_PAYMENT_DATE FOR SGAS.NON_AWARD_PAYMENT_DATE
/

DROP SEQUENCE SGAS.NON_PAY_ID_SEQ
/
--
-- NON_PAY_ID_SEQ  (Sequence) 
--

CREATE SEQUENCE SGAS.NON_PAY_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/

CREATE OR REPLACE TRIGGER SGAS.TRIG_NON_PAY_SEQ 
   BEFORE INSERT
   ON SGAS.NON_AWARD_PAYMENT_DATE
   FOR EACH ROW
BEGIN
   SELECT NON_PAY_ID_SEQ.NEXTVAL
     INTO :NEW.NON_PAY_DATE_ID
     FROM DUAL;
END;

