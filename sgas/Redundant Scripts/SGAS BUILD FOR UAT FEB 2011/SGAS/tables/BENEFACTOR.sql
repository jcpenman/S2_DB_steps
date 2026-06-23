-- DDL generated from TOAD and modified by hand 
-- for purposes of building the STEPS development
-- schema.
--
-- Modification History
-- Date        Author           Ref    Desc
--             Steve Durkin     001    Initial Version
-- 22.06.09    A.Bowman (SAAS)  002    Added audit triggers
-- 15.10.09    A.Bowman (SAAS)  003    Added materialized view log script
-- 28.01.10    A.Bowman (SAAS)  004    Amended audit triggers
-- 24.03.10    A.Bowman (SAAS)  005    Amended BE_AU trigger
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/BENEFACTOR.sql $
-- $Author: $
-- $Date: 2011-01-27 14:11:48 +0000 (Thu, 27 Jan 2011) $
-- $Revision: 6356 $


ALTER TABLE SGAS.BENEFACTOR
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.BENEFACTOR CASCADE CONSTRAINTS
/

--
-- BENEFACTOR  (Table) 
--
CREATE TABLE SGAS.BENEFACTOR
(
  BEN_ID             NUMBER(9) CONSTRAINT NN_BE_BEN_ID NOT NULL,
  TITLE              VARCHAR2(8 BYTE)               DEFAULT 'MR' CONSTRAINT NN_BE_TITLE NOT NULL,
  INITIALS           VARCHAR2(3 BYTE),
  FORENAMES          VARCHAR2(25 BYTE) CONSTRAINT NN_BE_FORENAMES NOT NULL,
  SURNAME            VARCHAR2(25 BYTE) CONSTRAINT NN_BE_SURNAME NOT NULL,
  OVERSEAS           VARCHAR2(1 BYTE)               DEFAULT 'N' CONSTRAINT NN_BE_OVERSEAS NOT NULL,
  HOUSE_NO_NAME      VARCHAR2(32 BYTE) CONSTRAINT NN_BE_HOUSE_NO_NAME NOT NULL,
  ADDR_L1            VARCHAR2(65 BYTE) CONSTRAINT NN_BE_ADDR_L1 NOT NULL,
  ADDR_L2            VARCHAR2(65 BYTE),
  ADDR_L3            VARCHAR2(32 BYTE),
  ADDR_L4            VARCHAR2(32 BYTE),
  POST_CODE          VARCHAR2(8 BYTE),
  BEN_NI_NO          VARCHAR2(9 BYTE),
  TELE_NO            VARCHAR2(15 BYTE),
  MAILSORT           NUMBER(5),
  -- Add Audit Columns
  LAST_UPDATED_BY    VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_BE_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON    DATE DEFAULT Sysdate CONSTRAINT NN_BE_LAST_UPDATED_ON NOT NULL
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


--
-- U1_BE  (Index) 
--
CREATE UNIQUE INDEX U1_BE ON SGAS.BENEFACTOR
(BEN_NI_NO)
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


--
-- S1_BE  (Index) 
--
CREATE INDEX S1_BE ON SGAS.BENEFACTOR
(FORENAMES, SURNAME)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
            NEXT             200K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- P_BE  (Index) 
--
CREATE UNIQUE INDEX P_BE ON SGAS.BENEFACTOR
(BEN_ID)
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

CREATE OR REPLACE TRIGGER SGAS.ben_iud
   AFTER INSERT OR DELETE OR UPDATE OF addr_l1,
                                       addr_l2,
                                       addr_l3,
                                       addr_l4,
                                       ben_ni_no,
                                       forenames,
                                       house_no_name,
                                       post_code,
                                       surname,
                                       last_updated_by
   ON SGAS.BENEFACTOR    FOR EACH ROW
DECLARE
   p_aud_date       DATE                               := SYSDATE;
   p_column_name    benefactor_aud.column_name%TYPE    := NULL;
   p_table_pkey1    benefactor_aud.table_pkey1%TYPE    := :OLD.ben_id;
   p_table_pkey2    benefactor_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    benefactor_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    benefactor_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    benefactor_aud.table_pkey5%TYPE    := NULL;
   p_old            benefactor_aud.OLD%TYPE            := NULL;
   p_new            benefactor_aud.NEW%TYPE            := NULL;
   p_action         benefactor_aud.action%TYPE         := NULL;
   p_username       benefactor_aud.username%TYPE       := :NEW.last_updated_by;
   p_stud_ref_no    benefactor_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      benefactor_aud.inst_code%TYPE      := NULL;
   p_session_code   benefactor_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.ben_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.ben_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'ADDR_L1';
   p_old := :OLD.addr_l1;
   p_new := :NEW.addr_l1;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_old := :OLD.addr_l2;
   p_new := :NEW.addr_l2;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_old := :OLD.addr_l3;
   p_new := :NEW.addr_l3;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_old := :OLD.addr_l4;
   p_new := :NEW.addr_l4;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_column_name := 'BEN_NI_NO';
   p_old := :OLD.ben_ni_no;
   p_new := :NEW.ben_ni_no;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_column_name := 'FORENAMES';
   p_old := :OLD.forenames;
   p_new := :NEW.forenames;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_old := :OLD.house_no_name;
   p_new := :NEW.house_no_name;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_old := :OLD.post_code;
   p_new := :NEW.post_code;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   p_old := :OLD.surname;
   p_new := :NEW.surname;
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
   pk_steps_aud.ins_ben_aud (p_aud_date,
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
END ben_iud;
SHOW ERRORS;



CREATE OR REPLACE TRIGGER SGAS.BE_AU
after  update of TITLE, INITIALS, FORENAMES, SURNAME, HOUSE_NO_NAME, ADDR_L1, ADDR_L2,
                 ADDR_L3, ADDR_L4, POST_CODE, TELE_NO
        ON BENEFACTOR for each row
declare
    P_BEN_ID          BENEFACTOR.BEN_ID%TYPE := :OLD.BEN_ID;
    P_TITLE           BENEFACTOR.TITLE%TYPE;
    P_INITIALS        BENEFACTOR.INITIALS%TYPE;
    P_FORENAMES       BENEFACTOR.FORENAMES%TYPE;
    P_SURNAME         BENEFACTOR.SURNAME%TYPE;
    P_HOUSE_NO_NAME   BENEFACTOR.HOUSE_NO_NAME%TYPE;
    P_ADDR_L1         BENEFACTOR.ADDR_L1%TYPE;
    P_ADDR_L2         BENEFACTOR.ADDR_L2%TYPE;
    P_ADDR_L3         BENEFACTOR.ADDR_L3%TYPE;
    P_ADDR_L4         BENEFACTOR.ADDR_L4%TYPE;
    P_POST_CODE       BENEFACTOR.POST_CODE%TYPE;
    P_TELE_NO         BENEFACTOR.TELE_NO%TYPE;
    P_ACTION          BENEFACTOR_AUD.ACTION%TYPE         := NULL;
    UPDATE_GRASS      VARCHAR2(1):= 'N';
        
begin
    if updating then
            P_ACTION      := 'U';
         IF (NVL(:OLD.TITLE,' ')  <> NVL(:NEW.TITLE,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.INITIALS,' ') <> NVL(:NEW.INITIALS,' ')) THEN
            UPDATE_GRASS := 'Y'; 
        ELSIF (NVL(:OLD.FORENAMES,' ') <> NVL(:NEW.FORENAMES,' ')) THEN
            UPDATE_GRASS := 'Y';   
        ELSIF (NVL(:OLD.SURNAME,' ') <> NVL(:NEW.SURNAME,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.HOUSE_NO_NAME,' ') <> NVL(:NEW.HOUSE_NO_NAME,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.ADDR_L1,' ') <> NVL(:NEW.ADDR_L1,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.ADDR_L2,' ') <> NVL(:NEW.ADDR_L2,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.ADDR_L3,' ') <> NVL(:NEW.ADDR_L3,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.ADDR_L4,' ') <> NVL(:NEW.ADDR_L4,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.POST_CODE,' ') <> NVL(:NEW.POST_CODE,' ')) THEN
            UPDATE_GRASS := 'Y';
        ELSIF (NVL(:OLD.TELE_NO,' ') <> NVL(:NEW.TELE_NO,' ')) THEN
            UPDATE_GRASS := 'Y';
        END IF;
         IF UPDATE_GRASS = 'Y' THEN
            PK_STEPS_TO_GRASS.UPDATE_BEN_IN_GRASS(:OLD.BEN_ID, :NEW.TITLE, :NEW.INITIALS, :NEW.FORENAMES,
                :NEW.SURNAME, :NEW.HOUSE_NO_NAME, :NEW.ADDR_L1, :NEW.ADDR_L2, :NEW.ADDR_L3,
                :NEW.ADDR_L4, :NEW.POST_CODE, :NEW.TELE_NO);
         END IF; 
            END IF;

    
end BE_AU;
SHOW ERRORS;

-- 
-- Non Foreign Key Constraints for Table BENEFACTOR 
-- 
ALTER TABLE SGAS.BENEFACTOR ADD (
  CONSTRAINT BE_OVERSEAS
 CHECK ( OVERSEAS IN('Y','N')))
/

ALTER TABLE SGAS.BENEFACTOR ADD (
  CONSTRAINT P_BE
 PRIMARY KEY
 (BEN_ID)
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

DROP SEQUENCE sgas.be_ben_id_seq;

CREATE SEQUENCE sgas.be_ben_id_seq
  START WITH 600000
  MAXVALUE 999999999999
  MINVALUE 600000
  NOCYCLE
  NOCACHE
  NOORDER;

DROP PUBLIC SYNONYM be_ben_id_seq;

CREATE PUBLIC SYNONYM be_ben_id_seq 
FOR sgas.be_ben_id_seq;

GRANT SELECT ON  sgas.be_ben_id_seq 
TO PUBLIC;

--
-- BENEFACTOR  (Materialized View Log)
--
DROP SNAPSHOT LOG ON BENEFACTOR
/
--
-- BENEFACTOR  (Materialized View Log) 
--
CREATE MATERIALIZED VIEW LOG ON BENEFACTOR
TABLESPACE USERS
PCTUSED    0
PCTFREE    60
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOPARALLEL
WITH ROWID, SEQUENCE
INCLUDING NEW VALUES
/