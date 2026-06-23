-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                      Desc.
-- 001      28.02.08    S Durkin (Sopra UK)         Initial Version.
-- 002      12.01.09    A.Bowman (SAAS)             Added new status to CONSTRAINT SB_DPB_STATUS
-- 003      22.06.09    A.Bowman (SAAS)             Added audit triggers. 
-- 004      28.01.10    A.Bowman (SAAS)             Amended audit triggers
-- 005      29.01.10    A.Bowman (SAAS)             Added sequence and seq trigger
-- 006      15.03.10    A.Bowman (SAAS)             Commented out seq trigger, no longer req'd
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/SCOAP_BATCHES.sql $
-- $Author: $
-- $Date: 2010-03-15 16:03:32 +0000 (Mon, 15 Mar 2010) $
-- $Revision: 4939 $


ALTER TABLE SGAS.SCOAP_BATCHES
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.SCOAP_BATCHES CASCADE CONSTRAINTS
/

--
-- SCOAP_BATCHES  (Table) 
--
CREATE TABLE SGAS.SCOAP_BATCHES
(
  DPB_BATCH_REF            VARCHAR2(7 BYTE) CONSTRAINT NN_SB_DPB_BATCH_REF NOT NULL,
  DPB_COUNT                NUMBER(7) CONSTRAINT NN_SB_DPB_COUNT NOT NULL,
  DPB_AC_YEAR              NUMBER(4) CONSTRAINT NN_SB_DPB_AC_YEAR NOT NULL,
  DPB_AC_PERIOD            NUMBER(2) CONSTRAINT NN_SB_DPB_AC_PERIOD NOT NULL,
  DPB_TOTAL_PAYMENT        NUMBER(15,2) CONSTRAINT NN_SB_DPB_TOTAL_PAYMENT NOT NULL,
  DPB_TOTAL_VOLUME         NUMBER(15,2)         DEFAULT 0 CONSTRAINT NN_SB_DPB_TOTAL_VOLUME NOT NULL,
  DPB_TOTAL_VAT            NUMBER(15,2) CONSTRAINT NN_SB_DPB_TOTAL_VAT NOT NULL,
  DPB_BATCH_CREATION_DATE  DATE CONSTRAINT NN_SB_DPB_BATCH_CREATION_DATE NOT NULL,
  DPB_ALLOW_SUSPENSE       VARCHAR2(1 BYTE)     DEFAULT 'N' CONSTRAINT NN_SB_DPB_ALLOW_SUSPENSE NOT NULL,
  DPB_VALIDATE_ONLY        VARCHAR2(1 BYTE)     DEFAULT 'N' CONSTRAINT NN_SB_DPB_VALIDATE_ONLY NOT NULL,
  DPB_STATUS               VARCHAR2(1 BYTE)     DEFAULT 'I' CONSTRAINT NN_SB_DPB_STATUS NOT NULL,
  ARC_ID                   NUMBER(9),
  ARC_RESTORE_DATE         DATE,
  INSTAL_NUMBER            VARCHAR2(2 BYTE),
  DPB_TYPE                 VARCHAR2(1 BYTE),
  DPB_PAYMENT_DATE         DATE,
  DPB_PAYMENT_TYPE         VARCHAR2(1 BYTE),
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_SB_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_SB_LAST_UPDATED_ON NOT NULL
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
MONITORING
/

COMMENT ON COLUMN SGAS.SCOAP_BATCHES.DPB_PAYMENT_DATE IS 'Date the payment was made added for SIR659'
/

COMMENT ON COLUMN SGAS.SCOAP_BATCHES.DPB_PAYMENT_TYPE IS 'payment type of batch C is payable order and B is BACs'
/


--
-- P_SB  (Index) 
--
CREATE UNIQUE INDEX P_SB ON SGAS.SCOAP_BATCHES
(DPB_BATCH_REF)
LOGGING
TABLESPACE USERS
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
NOPARALLEL
/

CREATE OR REPLACE TRIGGER SGAS.SC_BAT_IUD
after    insert or delete or update of DPB_BATCH_REF, 
                                      DPB_COUNT,
                                      DPB_AC_YEAR, 
                                      DPB_AC_PERIOD, 
                                      DPB_TOTAL_PAYMENT, 
                                      DPB_TOTAL_VOLUME, 
                                      DPB_TOTAL_VAT, 
                                      DPB_BATCH_CREATION_DATE, 
                                      DPB_ALLOW_SUSPENSE,  
                                      DPB_VALIDATE_ONLY, 
                                      DPB_STATUS, 
                                      ARC_ID, 
                                      ARC_RESTORE_DATE,
                                      LAST_UPDATED_BY
 
ON SGAS.SCOAP_BATCHES for    each row
declare
    p_aud_date       DATE                                      := SYSDATE;
        p_column_name    scoap_batches_aud.column_name%TYPE        := NULL;
        p_table_pkey1    scoap_batches_aud.table_pkey1%TYPE        := :OLD.DPB_BATCH_REF;
        p_table_pkey2    scoap_batches_aud.table_pkey2%TYPE    := NULL;
        p_table_pkey3    scoap_batches_aud.table_pkey3%TYPE    := NULL;
        p_table_pkey4    scoap_batches_aud.table_pkey4%TYPE    := NULL;
        p_table_pkey5    scoap_batches_aud.table_pkey5%TYPE    := NULL;
        p_old            scoap_batches_aud.OLD%TYPE            := NULL;
        p_new            scoap_batches_aud.NEW%TYPE            := NULL;
        p_action         scoap_batches_aud.action%TYPE         := NULL;
        p_username       scoap_batches_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
        p_stud_ref_no    scoap_batches_aud.stud_ref_no%TYPE    := NULL;
        p_inst_code      scoap_batches_aud.inst_code%TYPE      := NULL;
        p_session_code   scoap_batches_aud.session_code%TYPE   := NULL;

begin
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DPB_BATCH_REF;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DPB_BATCH_REF;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

    P_COLUMN_NAME     := 'DPB_BATCH_REF';
    P_OLD        := :old.DPB_BATCH_REF;
    P_NEW        := :new.DPB_BATCH_REF;
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_COUNT';
    P_OLD        := to_char(:old.DPB_COUNT);
    P_NEW        := to_char(:new.DPB_COUNT);
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_AC_YEAR';
    P_OLD        := to_char(:old.DPB_AC_YEAR);
    P_NEW        := to_char(:new.DPB_AC_YEAR);
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_AC_PERIOD';
    P_OLD        := to_char(:old.DPB_AC_PERIOD);
    P_NEW        := to_char(:new.DPB_AC_PERIOD);
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_TOTAL_PAYMENT';
    P_OLD        := to_char(:old.DPB_TOTAL_PAYMENT);
    P_NEW        := to_char(:new.DPB_TOTAL_PAYMENT);
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_TOTAL_VOLUME';
    P_OLD        := to_char(:old.DPB_TOTAL_VOLUME);
    P_NEW        := to_char(:new.DPB_TOTAL_VOLUME);
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_TOTAL_VAT';
    P_OLD        := to_char(:old.DPB_TOTAL_VAT);
    P_NEW        := to_char(:new.DPB_TOTAL_VAT);
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_BATCH_CREATION_DATE';
    P_OLD        := to_char(:old.DPB_BATCH_CREATION_DATE,'DD/MM/YYYY HH24:MI');
    P_NEW        := to_char(:new.DPB_BATCH_CREATION_DATE,'DD/MM/YYYY HH24:MI');
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_ALLOW_SUSPENSE';
    P_OLD        := :old.DPB_ALLOW_SUSPENSE;
    P_NEW        := :new.DPB_ALLOW_SUSPENSE;
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_VALIDATE_ONLY';
    P_OLD        := :old.DPB_VALIDATE_ONLY;
    P_NEW        := :new.DPB_VALIDATE_ONLY;
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DPB_STATUS';
    P_OLD        := :old.DPB_STATUS;
    P_NEW        := :new.DPB_STATUS;
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'ARC_ID';
    P_OLD        := to_char(:old.ARC_ID);
    P_NEW        := to_char(:new.ARC_ID);
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'ARC_RESTORE_DATE';
    P_OLD        := to_char(:old.ARC_RESTORE_DATE,'DD/MM/YYYY HH24:MI');
    P_NEW        := to_char(:new.ARC_RESTORE_DATE,'DD/MM/YYYY HH24:MI');
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'LAST_UPDATED_BY';
    P_OLD        := :old.LAST_UPDATED_BY;
    P_NEW        := :new.LAST_UPDATED_BY;
    pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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
end SC_BAT_IUD;
/
SHOW ERRORS;


/*CREATE OR REPLACE TRIGGER SGAS.SC_BAT_LUB
after insert or delete or update of LAST_UPDATED_BY 
ON SCOAP_BATCHES for each row
declare
   p_aud_date      DATE                                 := SYSDATE;
   p_column_name   scoap_batches_aud.column_name%TYPE   := NULL;
   p_table_pkey1   scoap_batches_aud.table_pkey1%TYPE   := :OLD.DPB_BATCH_REF;
   p_table_pkey2   scoap_batches_aud.table_pkey2%TYPE   := NULL;
   p_table_pkey3   scoap_batches_aud.table_pkey3%TYPE   := NULL;
   p_table_pkey4   scoap_batches_aud.table_pkey4%TYPE   := NULL;
   p_table_pkey5   scoap_batches_aud.table_pkey5%TYPE   := NULL;
   p_old           scoap_batches_aud.OLD%TYPE           := NULL;
   p_new           scoap_batches_aud.NEW%TYPE           := NULL;
   p_action        scoap_batches_aud.action%TYPE        := NULL;
   p_username      scoap_batches_aud.username%TYPE      := USER;
   p_stud_ref_no   scoap_batches_aud.stud_ref_no%TYPE   := NULL;
   p_inst_code     scoap_batches_aud.inst_code%TYPE     := NULL;
   p_session_code  scoap_batches_aud.session_code%TYPE  := NULL;
   

BEGIN
   IF INSERTING THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_table_pkey1 := :NEW.DPB_BATCH_REF;  
   ELSIF  UPDATING THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by; 
   ELSIF DELETING THEN
      p_action := 'D';
      p_username := USER;
END IF;
    
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_sc_bat_aud (p_aud_date,
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

end SC_BAT_LUB;
/
SHOW ERRORS;*/


---006
/*CREATE OR REPLACE TRIGGER SGAS.trig_scoap_bat_id_seq
   BEFORE INSERT
   ON scoap_batches
   FOR EACH ROW
DECLARE

   l_prefix        VARCHAR2 (3);

BEGIN
   
   SELECT scoap_bat_id_seq.NEXTVAL
     INTO :NEW.dpb_batch_ref
     FROM DUAL;
     
   l_prefix := 'SAA';
   
   :NEW.dpb_batch_ref := l_prefix || :NEW.dpb_batch_ref;
     
  
END;
/
SHOW ERRORS;*/


-- 
-- Non Foreign Key Constraints for Table SCOAP_BATCHES 
-- 


ALTER TABLE SGAS.SCOAP_BATCHES ADD (
  CONSTRAINT SB_DPB_TYPE
 CHECK (DPB_TYPE IN('I','S')))
/

ALTER TABLE SGAS.SCOAP_BATCHES ADD (
  CONSTRAINT SB_DPB_ALLOW_SUSPENSE
 CHECK ( DPB_ALLOW_SUSPENSE IN('Y','N')))
/

ALTER TABLE SGAS.SCOAP_BATCHES ADD (
  CONSTRAINT SB_DPB_STATUS
 CHECK ( DPB_STATUS IN('I', 'A','S','R','F')))
/

ALTER TABLE SGAS.SCOAP_BATCHES ADD (
  CONSTRAINT SB_DPB_VALIDATE_ONLY
 CHECK ( DPB_VALIDATE_ONLY IN('N')))
/

ALTER TABLE SGAS.SCOAP_BATCHES ADD (
  CHECK (DPB_PAYMENT_TYPE IN ('C','B')))
/

ALTER TABLE SGAS.SCOAP_BATCHES ADD (
  CONSTRAINT P_SB
 PRIMARY KEY
 (DPB_BATCH_REF)
    USING INDEX 
    TABLESPACE USERS
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
               ))
/

DROP SEQUENCE SGAS.SCOAP_BAT_ID_SEQ;

CREATE SEQUENCE SGAS.SCOAP_BAT_ID_SEQ
  START WITH 1000
  MAXVALUE 9999
  MINVALUE 1000
  NOCYCLE
  NOCACHE
  NOORDER;


GRANT SELECT ON  SGAS.SCOAP_BAT_ID_SEQ TO PUBLIC;