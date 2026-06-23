-- NOMINEE.sql
-- Description: Table holding all NOMINEEs for SGAS
-- Author J.Penman.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      28.08.09    J.Penman (SAAS)         Initial Version.
-- 1.1      01.09.09    J.Penman (SAAS)         Added primary key sequence, 
--                                              comments and synonym
-- 1.2      02.09.09    J.Penman (SAAS)         Added nominee_iud and nominee_lub triggers 
-- 1.3      16.09.09    J.Penman (SAAS)         Removed category_id from table as it is not required
-- 1.4      22.09.09    A.Bowman (SAAS)         Added missing telephone no column      
-- 1.5      13.10.09    A.Bowman (SAAS)         Added newly required column payee_name
-- 1.6      20.10.09    A.Bowman (SAAS)         Removed not null constraint from the following columns
--                                              in line with changes to the spec. forename, surname, house_no_name, account_no, sort_code
--
-- 1.7      28.01.10    A.Bowman (SAAS)         Amended audit triggers
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE SGAS.NOMINEE
 DROP PRIMARY KEY CASCADE;

DROP TABLE SGAS.NOMINEE CASCADE CONSTRAINTS PURGE;

CREATE TABLE SGAS.NOMINEE
(
  NOMINEE_ID       NUMBER(10)                   NOT NULL,
  FORENAME         VARCHAR2(25 BYTE),
  SURNAME          VARCHAR2(32 BYTE),
  COMPANY_NAME     VARCHAR2(25 BYTE),
  PAYEE_NAME       VARCHAR2(65 BYTE),
  HOUSE_NO_NAME    VARCHAR2(32 BYTE),
  ADDR_L1          VARCHAR2(65 BYTE),
  ADDR_L2          VARCHAR2(65 BYTE),
  ADDR_L3          VARCHAR2(32 BYTE),
  ADDR_L4          VARCHAR2(32 BYTE),
  POST_CODE        VARCHAR2(8 BYTE),
  TELEPHONE_NO     VARCHAR2(12 BYTE),
  ACCOUNT_NO       VARCHAR2(10 BYTE),
  SORT_CODE        VARCHAR2(6 BYTE),
  PAYMENT_METHOD   VARCHAR2(1 BYTE)             DEFAULT 'B'                   NOT NULL,
  LAST_UPDATED_BY  VARCHAR2(15 BYTE)            DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON  DATE                         DEFAULT SYSDATE               NOT NULL
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
MONITORING;

COMMENT ON COLUMN SGAS.NOMINEE.NOMINEE_ID IS 'Unique reference number for a nominee';

COMMENT ON COLUMN SGAS.NOMINEE.FORENAME IS 'The nominee''s first name';

COMMENT ON COLUMN SGAS.NOMINEE.SURNAME IS 'The nominee''s surname';

COMMENT ON COLUMN SGAS.NOMINEE.COMPANY_NAME IS 'The name of the company that the nominee represents';

COMMENT ON COLUMN SGAS.NOMINEE.HOUSE_NO_NAME IS 'The name or number of the building';

COMMENT ON COLUMN SGAS.NOMINEE.ADDR_L1 IS 'The first line of the address (compulsory)';

COMMENT ON COLUMN SGAS.NOMINEE.ADDR_L2 IS 'The second line of the address';

COMMENT ON COLUMN SGAS.NOMINEE.ADDR_L3 IS 'The third line of the address';

COMMENT ON COLUMN SGAS.NOMINEE.ADDR_L4 IS 'The fourth and final line of the address';

COMMENT ON COLUMN SGAS.NOMINEE.POST_CODE IS 'The post code (8 characters)';

COMMENT ON COLUMN SGAS.NOMINEE.TELEPHONE_NO IS 'The nominees telephone number';

COMMENT ON COLUMN SGAS.NOMINEE.ACCOUNT_NO IS 'The nominee''s bank account number';

COMMENT ON COLUMN SGAS.NOMINEE.SORT_CODE IS 'The sort code of the bank that holds the nominee'' bank account';

COMMENT ON COLUMN SGAS.NOMINEE.PAYMENT_METHOD IS 'The nominee''s preferred method of payment: cheque (C) or BACS (B). the default is C';

COMMENT ON COLUMN SGAS.NOMINEE.LAST_UPDATED_BY IS 'Audit information of last user to update record';

COMMENT ON COLUMN SGAS.NOMINEE.LAST_UPDATED_ON IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX SGAS.NM_1 ON SGAS.NOMINEE
(NOMINEE_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE OR REPLACE TRIGGER SGAS.nom_iud
   AFTER INSERT OR DELETE OR UPDATE OF NOMINEE_id,
                                       FORENAME,
                                       SURNAME,
                                       COMPANY_NAME,
                                       PAYEE_NAME,
                                       HOUSE_NO_NAME,
                                       ADDR_L1,
                                       ADDR_L2,
                                       ADDR_L3,
                                       ADDR_L4,
                                       POST_CODE,
                                       TELEPHONE_NO,
                                       ACCOUNT_NO,
                                       SORT_CODE,
                                       PAYMENT_METHOD,
                                       LAST_UPDATED_BY
   ON SGAS.NOMINEE    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    NOMINEE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    NOMINEE_aud.table_pkey1%TYPE
                                               := :OLD.NOMINEE_id;
   p_table_pkey2    NOMINEE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    NOMINEE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    NOMINEE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    NOMINEE_aud.table_pkey5%TYPE    := NULL;
   p_old            NOMINEE_aud.OLD%TYPE            := NULL;
   p_new            NOMINEE_aud.NEW%TYPE            := NULL;
   p_action         NOMINEE_aud.action%TYPE         := NULL;
   p_username       NOMINEE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    NOMINEE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      NOMINEE_aud.inst_code%TYPE      := NULL;
   p_session_code   NOMINEE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.NOMINEE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.NOMINEE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'NOMINEE_ID';
   p_old := :OLD.NOMINEE_id;
   p_new := :NEW.NOMINEE_id;
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'FORENAME';
   p_old := TO_CHAR (:OLD.forename);
   p_new := TO_CHAR (:NEW.forename);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_old := TO_CHAR (:OLD.surname);
   p_new := TO_CHAR (:NEW.surname);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'COMPANY_NAME';
   p_old := TO_CHAR (:OLD.company_name);
   p_new := TO_CHAR (:NEW.company_name);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'PAYEE_NAME';
   p_old := TO_CHAR (:OLD.payee_name);
   p_new := TO_CHAR (:NEW.payee_name);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'HOUSE_NO_NAME';
   p_old := TO_CHAR (:OLD.house_no_name);
   p_new := TO_CHAR (:NEW.house_no_name);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'ADDR_L1';
   p_old := TO_CHAR (:OLD.addr_l1);
   p_new := TO_CHAR (:NEW.addr_l1);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'ADDR_L2';
   p_old := TO_CHAR (:OLD.addr_l2);
   p_new := TO_CHAR (:NEW.addr_l2);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'ADDR_L3';
   p_old := TO_CHAR (:OLD.addr_l3);
   p_new := TO_CHAR (:NEW.addr_l3);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'ADDR_L4';
   p_old := TO_CHAR (:OLD.addr_l4);
   p_new := TO_CHAR (:NEW.addr_l4);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'POST_CODE';
   p_old := TO_CHAR (:OLD.post_code);
   p_new := TO_CHAR (:NEW.post_code);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_column_name := 'TELEPHONE_NO';
   p_old := TO_CHAR (:OLD.telephone_no);
   p_new := TO_CHAR (:NEW.telephone_no);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_old := TO_CHAR (:OLD.account_no);
   p_new := TO_CHAR (:NEW.account_no);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_old := TO_CHAR (:OLD.sort_code);
   p_new := TO_CHAR (:NEW.sort_code);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   p_old := TO_CHAR (:OLD.payment_method);
   p_new := TO_CHAR (:NEW.payment_method);
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
   pk_steps_aud.ins_nom_aud (p_aud_date,
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
END nom_iud;
SHOW ERRORS;


DROP SEQUENCE SGAS.NOMINEE_ID_SEQ;

CREATE SEQUENCE SGAS.NOMINEE_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


GRANT SELECT ON  SGAS.NOMINEE_ID_SEQ TO PUBLIC;


CREATE OR REPLACE TRIGGER SGAS.trig_nominee_seq
   BEFORE INSERT
   ON SGAS.NOMINEE    FOR EACH ROW
BEGIN
   SELECT nominee_id_seq.NEXTVAL
     INTO :NEW.nominee_id
     FROM DUAL;
END;
/


DROP PUBLIC SYNONYM NOMINEE;

CREATE PUBLIC SYNONYM NOMINEE FOR SGAS.NOMINEE;


ALTER TABLE SGAS.NOMINEE ADD (
  CONSTRAINT NM_1
 PRIMARY KEY
 (NOMINEE_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));
