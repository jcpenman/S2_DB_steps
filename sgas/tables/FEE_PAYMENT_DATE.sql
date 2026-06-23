-- FEE_PAYMENT_DATE.sql
-- Description: Table holding list of fee payment dates 
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

ALTER TABLE SGAS.FEE_PAYMENT_DATE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.FEE_PAYMENT_DATE CASCADE CONSTRAINTS PURGE
/

--
-- FEE_PAYMENT_DATE  (Table) 
--

CREATE TABLE SGAS.FEE_PAYMENT_DATE
(
  FEE_PAYMENT_DATE_ID     NUMBER NOT NULL,
  PAY_DATE   DATE NOT NULL,
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

COMMENT ON COLUMN FEE_PAYMENT_DATE.FEE_PAYMENT_DATE_ID IS 'Unique fee pay date identifier';

COMMENT ON COLUMN FEE_PAYMENT_DATE.PAY_DATE IS 'A fee payment date';

COMMENT ON COLUMN FEE_PAYMENT_DATE.LAST_UPDATED_BY IS 'The user to last update or insert a row on the fee_payment_date table';

COMMENT ON COLUMN FEE_PAYMENT_DATE.LAST_UPDATED_ON IS 'The date of the latest update or insert on the fee_payment_date table';

CREATE UNIQUE INDEX FEE_PAYMENT_DATE_PK ON FEE_PAYMENT_DATE
(FEE_PAYMENT_DATE_ID)
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


ALTER TABLE FEE_PAYMENT_DATE ADD (
  CONSTRAINT FEE_PAYMENT_DATE_PK
 PRIMARY KEY
 (FEE_PAYMENT_DATE_ID)
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
NAME: FPD_IUD        
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


GRANT SELECT ON SGAS.FEE_PAYMENT_DATE TO PUBLIC;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM FEE_PAYMENT_DATE
/

CREATE PUBLIC SYNONYM FEE_PAYMENT_DATE FOR SGAS.FEE_PAYMENT_DATE
/

DROP SEQUENCE SGAS.FEE_PAY_ID_SEQ
/
--
-- FEE_PAY_ID_SEQ  (Sequence) 
--

CREATE SEQUENCE SGAS.FEE_PAY_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/

CREATE OR REPLACE TRIGGER SGAS.TRIG_FEE_PAY_SEQ 
   BEFORE INSERT
   ON SGAS.FEE_PAYMENT_DATE
   FOR EACH ROW
BEGIN
   SELECT FEE_PAY_ID_SEQ.NEXTVAL
     INTO :NEW.FEE_PAYMENT_DATE_ID
     FROM DUAL;
END;


INSERT INTO fee_payment_date
            (pay_date
            )
     VALUES (TO_DATE('28-09-2011','DD-MM-YYYY')
            );
INSERT INTO fee_payment_date
            (pay_date
            )
     VALUES (TO_DATE('27-01-2012','DD-MM-YYYY')
            );
INSERT INTO fee_payment_date
            (pay_date
            )
     VALUES (TO_DATE('28-03-2012','DD-MM-YYYY')
            );
INSERT INTO fee_payment_date
            (pay_date
            )
     VALUES (TO_DATE('28-06-2012','DD-MM-YYYY')
            );
INSERT INTO fee_payment_date
            (pay_date
            )
     VALUES (TO_DATE('28-09-2012','DD-MM-YYYY')
            );
INSERT INTO fee_payment_date
            (pay_date
            )
     VALUES (TO_DATE('28-01-2013','DD-MM-YYYY')
            );
INSERT INTO fee_payment_date
            (pay_date
            )
     VALUES (TO_DATE('28-03-2013','DD-MM-YYYY')
            );
INSERT INTO fee_payment_date
            (pay_date
            )
     VALUES (TO_DATE('28-06-2013','DD-MM-YYYY')
            );
INSERT INTO fee_payment_date
            (pay_date
            )
     VALUES (TO_DATE('27-09-2013','DD-MM-YYYY')
            );
INSERT INTO fee_payment_date
            (pay_date
            )
     VALUES (TO_DATE('28-01-2014','DD-MM-YYYY')
            );
INSERT INTO fee_payment_date
            (pay_date
            )
     VALUES (TO_DATE('28-03-2014','DD-MM-YYYY')
            );
INSERT INTO fee_payment_date
            (pay_date
            )
     VALUES (TO_DATE('27-06-2014','DD-MM-YYYY')
            );

COMMIT;