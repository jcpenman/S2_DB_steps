/******************************************************************************
TABLE NAME: PAYMENTS_QUEUE        
DESCRIPTION: Holds each award instalment ID to be processed by the payments job, deleted from queue when processed.


MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        22.12.2009  A.Bowman         Initial Version
1.1        07.01.2010  A.Bowman         Added Audit Triggers
1.2        25.01.2010  A.Bowman         Amended name of PK
1.3        28.01.2010  A.Bowman         Amended Audit Triggers

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/

ALTER TABLE SGAS.PAYMENTS_QUEUE
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.PAYMENTS_QUEUE CASCADE CONSTRAINTS PURGE
/
--
-- PAYMENTS_QUEUE  (Table) 
--
CREATE TABLE SGAS.PAYMENTS_QUEUE
(
  PQ_ID                      NUMBER NOT NULL,
  QUEUE_ID                NUMBER NOT NULL,
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

CREATE UNIQUE INDEX PAYMENTS_QUEUE_PK ON SGAS.PAYMENTS_QUEUE
(PQ_ID)
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


ALTER TABLE PAYMENTS_QUEUE ADD (
  CONSTRAINT PAYMENTS_QUEUE_PK
 PRIMARY KEY
 (PQ_ID)
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

CREATE OR REPLACE TRIGGER SGAS.pay_que_iud
   AFTER INSERT OR DELETE OR UPDATE OF  PQ_ID,
                                        QUEUE_ID,
                                        LAST_UPDATED_BY
ON SGAS.PAYMENTS_QUEUE FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    PAYMENTS_QUEUE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    PAYMENTS_QUEUE_aud.table_pkey1%TYPE
                                               := :OLD.PQ_ID;
   p_table_pkey2    PAYMENTS_QUEUE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    PAYMENTS_QUEUE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    PAYMENTS_QUEUE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    PAYMENTS_QUEUE_aud.table_pkey5%TYPE    := NULL;
   p_old            PAYMENTS_QUEUE_aud.OLD%TYPE            := NULL;
   p_new            PAYMENTS_QUEUE_aud.NEW%TYPE            := NULL;
   p_action         PAYMENTS_QUEUE_aud.action%TYPE         := NULL;
   p_username       PAYMENTS_QUEUE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    PAYMENTS_QUEUE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      PAYMENTS_QUEUE_aud.inst_code%TYPE      := NULL;
   p_session_code   PAYMENTS_QUEUE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.PQ_ID;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.PQ_ID;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'PQ_ID';
   p_old := :OLD.PQ_ID;
   p_new := :NEW.PQ_ID;
   pk_steps_aud.ins_pay_que_aud (p_aud_date,
                                 p_column_name,
                                 p_table_pkey1,
                                 p_table_pkey2,
                                 p_table_pkey3,
                                 p_table_pkey4,
                                 p_table_pkey5,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username,
                                 p_stud_ref_no,
                                 p_inst_code,
                                 p_session_code
                                 );
   p_column_name := 'QUEUE_ID';
   p_old := :OLD.QUEUE_ID;
   p_new := :NEW.QUEUE_ID;
   pk_steps_aud.ins_pay_que_aud (p_aud_date,
                                 p_column_name,
                                 p_table_pkey1,
                                 p_table_pkey2,
                                 p_table_pkey3,
                                 p_table_pkey4,
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
   pk_steps_aud.ins_pay_que_aud (p_aud_date,
                                 p_column_name,
                                 p_table_pkey1,
                                 p_table_pkey2,
                                 p_table_pkey3,
                                 p_table_pkey4,
                                 p_table_pkey5,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username,
                                 p_stud_ref_no,
                                 p_inst_code,
                                 p_session_code
                                 );    
END pay_que_iud;
/
SHOW ERRORS;

/*CREATE OR REPLACE TRIGGER sgas.PAY_QUE_LUB
   AFTER INSERT OR DELETE OR UPDATE OF last_updated_by
   ON PAYMENTS_QUEUE
   FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    PAYMENTS_QUEUE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    PAYMENTS_QUEUE_aud.table_pkey1%TYPE
                                               := :OLD.PQ_ID;
   p_table_pkey2    PAYMENTS_QUEUE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    PAYMENTS_QUEUE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    PAYMENTS_QUEUE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    PAYMENTS_QUEUE_aud.table_pkey5%TYPE    := NULL;
   p_old            PAYMENTS_QUEUE_aud.OLD%TYPE            := NULL;
   p_new            PAYMENTS_QUEUE_aud.NEW%TYPE            := NULL;
   p_action         PAYMENTS_QUEUE_aud.action%TYPE         := NULL;
   p_username       PAYMENTS_QUEUE_aud.username%TYPE       := USER;
   p_stud_ref_no    PAYMENTS_QUEUE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      PAYMENTS_QUEUE_aud.inst_code%TYPE      := NULL;
   p_session_code   PAYMENTS_QUEUE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_table_pkey1 := :NEW.PQ_ID;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_pay_que_aud (p_aud_date,
                                 p_column_name,
                                 p_table_pkey1,
                                 p_table_pkey2,
                                 p_table_pkey3,
                                 p_table_pkey4,
                                 p_table_pkey5,
                                 p_old,
                                 p_new,
                                 p_action,
                                 p_username,
                                 p_stud_ref_no,
                                 p_inst_code,
                                 p_session_code
                                 );
END PAY_QUE_LUB;
/
SHOW ERRORS;*/


-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM PAYMENTS_QUEUE
/
CREATE PUBLIC SYNONYM PAYMENTS_QUEUE FOR SGAS.PAYMENTS_QUEUE
/
DROP SEQUENCE SGAS.PAYMENTS_QUEUE_ID_SEQ
/
--
-- PAYMENTS_QUEUE_ID_seq  (Sequence) 
--
CREATE SEQUENCE SGAS.PAYMENTS_QUEUE_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/

CREATE OR REPLACE TRIGGER SGAS.TRIG_PAY_QUE_SEQ 
   BEFORE INSERT
   ON PAYMENTS_QUEUE
   FOR EACH ROW
BEGIN
   SELECT PAYMENTS_QUEUE_ID_SEQ.NEXTVAL
     INTO :NEW.PQ_ID
     FROM DUAL;
END;

