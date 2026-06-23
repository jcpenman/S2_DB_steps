-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                      Desc.
-- 001      28.02.08    S Durkin (Sopra UK)         Initial Version.
-- 002      22.06.09    A.Bowman (SAAS)             Added audit triggers.
-- 003      28.01.10    A.Bowman (SAAS)             Amended audit triggers
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/SCOAP_CHARGES.sql $
-- $Author: $
-- $Date: 2010-01-29 12:22:14 +0000 (Fri, 29 Jan 2010) $
-- $Revision: 4676 $


DROP TABLE SGAS.SCOAP_CHARGES CASCADE CONSTRAINTS
/

--
-- SCOAP_CHARGES  (Table) 
--
CREATE TABLE SGAS.SCOAP_CHARGES
(
  SCHEME_TYPE      VARCHAR2(1 BYTE) CONSTRAINT NN_SC_SCHEME_TYPE NOT NULL,
  AWARD_SRC        VARCHAR2(1 BYTE) CONSTRAINT NN_SC_AWARD_SRC NOT NULL,
  STUD_AWARD_TYPE  VARCHAR2(6 BYTE),
  INST_TYPE_ID     NUMBER(4),
  COST_CENTRE      VARCHAR2(6 BYTE) CONSTRAINT NN_SC_COST_CENTRE NOT NULL,
  ACCOUNT          VARCHAR2(8 BYTE) CONSTRAINT NN_SC_ACCOUNT NOT NULL,
  ACTIVITY         VARCHAR2(6 BYTE),
  JOB              VARCHAR2(8 BYTE),
  DESCRIPT         VARCHAR2(30 BYTE),
  SNB_RATE         VARCHAR2(1 BYTE),
  DSA_FEE          VARCHAR2(1 BYTE)             DEFAULT 'N',
  FEE_LOAN         VARCHAR2(1 BYTE),
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_SC_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_SC_LAST_UPDATED_ON NOT NULL
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

CREATE OR REPLACE TRIGGER SGAS.SC_CHA_IUD
after    insert or delete or update of SCHEME_TYPE, 
                                      AWARD_SRC, 
                                      STUD_AWARD_TYPE, 
                                      INST_TYPE_ID, 
                                      COST_CENTRE, 
                                      ACCOUNT, 
                                      ACTIVITY, 
                                      JOB, 
                                      DESCRIPT,
                                      LAST_UPDATED_BY
 
ON SGAS.SCOAP_CHARGES for    each row
declare
    P_AUD_DATE     date                            := sysdate;
    P_COLUMN_NAME    scoap_charges_aud.column_name%TYPE    := null;
    P_TABLE_PKEY1     scoap_charges_aud.TABLE_PKEY1%type    := :old.SCHEME_TYPE;
    P_TABLE_PKEY2     scoap_charges_aud.TABLE_PKEY2%type    := :old.AWARD_SRC;
    P_TABLE_PKEY3     scoap_charges_aud.TABLE_PKEY3%type    := :old.STUD_AWARD_TYPE;
    P_TABLE_PKEY4     scoap_charges_aud.TABLE_PKEY4%type    := to_char(:old.INST_TYPE_ID);
    P_TABLE_PKEY5     scoap_charges_aud.TABLE_PKEY5%type    := null;
    p_old            scoap_charges_aud.OLD%TYPE            := NULL;
        p_new            scoap_charges_aud.NEW%TYPE            := NULL;
        p_action         scoap_charges_aud.action%TYPE         := NULL;
        p_username       scoap_charges_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
        p_stud_ref_no    scoap_charges_aud.stud_ref_no%TYPE    := NULL;
        p_inst_code      scoap_charges_aud.inst_code%TYPE      := NULL;
        p_session_code   scoap_charges_aud.session_code%TYPE   := NULL;
begin
    
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.SCHEME_TYPE;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.SCHEME_TYPE;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

    P_COLUMN_NAME     := 'SCHEME_TYPE';
    P_OLD        := :old.SCHEME_TYPE;
    P_NEW        := :new.SCHEME_TYPE;
    pk_steps_aud.ins_sc_cha_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'AWARD_SRC';
    P_OLD        := :old.AWARD_SRC;
    P_NEW        := :new.AWARD_SRC;
    pk_steps_aud.ins_sc_cha_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'STUD_AWARD_TYPE';
    P_OLD        := :old.STUD_AWARD_TYPE;
    P_NEW        := :new.STUD_AWARD_TYPE;
    pk_steps_aud.ins_sc_cha_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'INST_TYPE_ID';
    P_OLD        := to_char(:old.INST_TYPE_ID);
    P_NEW        := to_char(:new.INST_TYPE_ID);
    pk_steps_aud.ins_sc_cha_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'COST_CENTRE';
    P_OLD        := :old.COST_CENTRE;
    P_NEW        := :new.COST_CENTRE;
    pk_steps_aud.ins_sc_cha_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'ACCOUNT';
    P_OLD        := :old.ACCOUNT;
    P_NEW        := :new.ACCOUNT;
    pk_steps_aud.ins_sc_cha_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'ACTIVITY';
    P_OLD        := :old.ACTIVITY;
    P_NEW        := :new.ACTIVITY;
    pk_steps_aud.ins_sc_cha_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'JOB';
    P_OLD        := :old.JOB;
    P_NEW        := :new.JOB;
    pk_steps_aud.ins_sc_cha_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'DESCRIPT';
    P_OLD        := :old.DESCRIPT;
    P_NEW        := :new.DESCRIPT;
    pk_steps_aud.ins_sc_cha_aud (p_aud_date,
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
    pk_steps_aud.ins_sc_cha_aud (p_aud_date,
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
end SC_CHA_IUD;
/
SHOW ERRORS;



/*CREATE OR REPLACE TRIGGER SGAS.SC_CHA_LUB
after insert or delete or update of LAST_UPDATED_BY 
ON SCOAP_CHARGES for each row
declare
   p_aud_date      DATE                                 := SYSDATE;
   p_column_name   scoap_charges_aud.column_name%TYPE   := NULL;
   p_table_pkey1   scoap_charges_aud.table_pkey1%TYPE   := :OLD.SCHEME_TYPE;
   p_table_pkey2   scoap_charges_aud.table_pkey2%TYPE   := NULL;
   p_table_pkey3   scoap_charges_aud.table_pkey3%TYPE   := NULL;
   p_table_pkey4   scoap_charges_aud.table_pkey4%TYPE   := NULL;
   p_table_pkey5   scoap_charges_aud.table_pkey5%TYPE   := NULL;
   p_old           scoap_charges_aud.OLD%TYPE           := NULL;
   p_new           scoap_charges_aud.NEW%TYPE           := NULL;
   p_action        scoap_charges_aud.action%TYPE        := NULL;
   p_username      scoap_charges_aud.username%TYPE      := USER;
   p_stud_ref_no   scoap_charges_aud.stud_ref_no%TYPE   := NULL;
   p_inst_code     scoap_charges_aud.inst_code%TYPE     := NULL;
   p_session_code  scoap_charges_aud.session_code%TYPE  := NULL;
   

BEGIN
   IF INSERTING THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_table_pkey1 := :NEW.SCHEME_TYPE;  
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
   pk_steps_aud.ins_sc_cha_aud (p_aud_date,
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

end SC_CHA_LUB;
/
SHOW ERRORS;*/

-- 
-- Non Foreign Key Constraints for Table SCOAP_CHARGES 
-- 
ALTER TABLE SGAS.SCOAP_CHARGES ADD (
  CONSTRAINT SC_SCHEME_TYPE
 CHECK ( SCHEME_TYPE IN('U','P','S','B')))
/

ALTER TABLE SGAS.SCOAP_CHARGES ADD (
  CONSTRAINT SC_AWARD_SRC
 CHECK ( AWARD_SRC IN('A','I','C','T')))
/

ALTER TABLE SGAS.SCOAP_CHARGES ADD (
  CONSTRAINT SC_DSA_FEE
 CHECK (dsa_fee IN('Y','N')))
/

ALTER TABLE SGAS.SCOAP_CHARGES ADD (
  CONSTRAINT SC_FEE_LOAN
 CHECK (fee_loan IN ('Y','N')))
/

ALTER TABLE SGAS.SCOAP_CHARGES ADD (
  CONSTRAINT SC_SNB_RATE
 CHECK (snb_rate IN('H','L','S')))
/
