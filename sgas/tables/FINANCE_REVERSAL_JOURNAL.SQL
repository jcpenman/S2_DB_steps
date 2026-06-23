/******************************************************************************
TABLE NAME: FINANCE_REVERSAL_JOURNAL        
DESCRIPTION: Holds a record of journal lines to be reversed in the UI

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        22.12.2009  A.Bowman         Initial Version
1.1        07.01.2010  A.Bowman         Added Audit Triggers
1.2        28.01.2010  A.Bowman         Amended Audit Triggers

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/

ALTER TABLE SGAS.FINANCE_REVERSAL_JOURNAL
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.FINANCE_REVERSAL_JOURNAL CASCADE CONSTRAINTS PURGE
/
--
-- FINANCE_REVERSAL_JOURNAL  (Table) 
--
CREATE TABLE SGAS.FINANCE_REVERSAL_JOURNAL
(
  JOURNAL_ID              NUMBER NOT NULL,
  JOURNAL_TYPE            VARCHAR2(10),
  CUSTOMER                VARCHAR2(10),
  DEBIT_VALUE             NUMBER(9,2),
  CREDIT_VALUE            NUMBER(9,2),
  AWARD_TYPE              VARCHAR2(10),
  REASON                  VARCHAR2(20),
  BATCH_DATE              DATE,
  BATCH_REFERENCE         VARCHAR2(7) NOT NULL,
  LAST_UPDATED_BY         VARCHAR2(15 BYTE)          DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON         DATE                  DEFAULT Sysdate NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE UNIQUE INDEX FINANCE_REVERSAL_JOURNAL_PK ON SGAS.FINANCE_REVERSAL_JOURNAL
(JOURNAL_ID)
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


ALTER TABLE FINANCE_REVERSAL_JOURNAL ADD (
  CONSTRAINT FINANCE_REVERSAL_JOURNAL_PK
 PRIMARY KEY
 (JOURNAL_ID)
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

CREATE OR REPLACE TRIGGER SGAS.fin_rev_jou_iud
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
ON SGAS.FINANCE_REVERSAL_JOURNAL FOR EACH ROW
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
SHOW ERRORS;


-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM FINANCE_REVERSAL_JOURNAL
/
CREATE PUBLIC SYNONYM FINANCE_REVERSAL_JOURNAL FOR SGAS.FINANCE_REVERSAL_JOURNAL
/
DROP SEQUENCE SGAS.FIN_REV_JOURN_ID_SEQ
/
--
-- FIN_REV_JOURN_ID_SEQ  (Sequence) 
--
CREATE SEQUENCE SGAS.FIN_REV_JOURN_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/

CREATE OR REPLACE TRIGGER SGAS.TRIG_REV_JOURN_SEQ 
   BEFORE INSERT
   ON SGAS.FINANCE_REVERSAL_JOURNAL
   FOR EACH ROW
BEGIN
   SELECT FIN_REV_JOURN_ID_SEQ.NEXTVAL
     INTO :NEW.JOURNAL_ID
     FROM DUAL;
END;

