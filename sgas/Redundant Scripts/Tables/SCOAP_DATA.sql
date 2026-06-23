-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                      Desc.
-- 001      28.02.08    S.Durkin (Sopra UK)         Initial Version.
-- 002      22.06.09    A.Bowman (SAAS)             Added audit triggers.
-- 003      28.01.10    A.Bowman (SAAS)             Amended audit triggers
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/SCOAP_DATA.sql $
-- $Author: $
-- $Date: 2010-01-29 12:22:14 +0000 (Fri, 29 Jan 2010) $
-- $Revision: 4676 $


ALTER TABLE SGAS.SCOAP_DATA
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.SCOAP_DATA CASCADE CONSTRAINTS
/

--
-- SCOAP_DATA  (Table) 
--
CREATE TABLE SGAS.SCOAP_DATA
(
  ITEM_NAME    VARCHAR2(40 BYTE) CONSTRAINT NN_SD_ITEM_NAME NOT NULL,
  CVAL         VARCHAR2(255 BYTE),
  NVAL         NUMBER,
  DESCRIPTION  VARCHAR2(30 BYTE),
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_SD_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_SD_LAST_UPDATED_ON NOT NULL
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
-- P_SD  (Index) 
--
CREATE UNIQUE INDEX P_SD ON SGAS.SCOAP_DATA
(ITEM_NAME)
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

CREATE OR REPLACE TRIGGER SGAS.SC_DAT_IUD
after    insert or delete or update of item_name,
                                      cval,
                                      nval,
                                      last_updated_by
ON SGAS.SCOAP_DATA for    each row
declare
    
        p_aud_date       DATE                                  := SYSDATE;
        p_column_name    scoap_data_aud.column_name%TYPE    := NULL;
        p_table_pkey1    scoap_data_aud.table_pkey1%TYPE    := substr(:old.ITEM_NAME,1,32);
        p_table_pkey2    scoap_data_aud.table_pkey2%TYPE    := NULL;
        p_table_pkey3    scoap_data_aud.table_pkey3%TYPE    := NULL;
        p_table_pkey4    scoap_data_aud.table_pkey4%TYPE    := NULL;
        p_table_pkey5    scoap_data_aud.table_pkey5%TYPE    := NULL;
        p_old            scoap_data_aud.OLD%TYPE            := NULL;
        p_new            scoap_data_aud.NEW%TYPE            := NULL;
        p_action         scoap_data_aud.action%TYPE         := NULL;
        p_username       scoap_data_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
        p_stud_ref_no    scoap_data_aud.stud_ref_no%TYPE    := NULL;
        p_inst_code      scoap_data_aud.inst_code%TYPE      := NULL;
        p_session_code   scoap_data_aud.session_code%TYPE   := NULL;


begin
    
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := substr(:new.ITEM_NAME,1,32);
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := substr(:new.ITEM_NAME,1,32);
      p_username := :old.last_updated_by;
   END IF;

    P_COLUMN_NAME     := 'ITEM_NAME';
    P_OLD        := :old.ITEM_NAME;
    P_NEW        := :new.ITEM_NAME;
    pk_steps_aud.ins_sc_dat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'CVAL';
    P_OLD        := :old.CVAL;
    P_NEW        := :new.CVAL;
    pk_steps_aud.ins_sc_dat_aud (p_aud_date,
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
    P_COLUMN_NAME     := 'NVAL';
    P_OLD        := to_char(:old.NVAL);
    P_NEW        := to_char(:new.NVAL);
    pk_steps_aud.ins_sc_dat_aud (p_aud_date,
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
    P_OLD        := :old.last_updated_by;
    P_NEW        := :new.last_updated_by;
    pk_steps_aud.ins_sc_dat_aud (p_aud_date,
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
end SC_DAT_IUD;
/
SHOW ERRORS;



/*CREATE OR REPLACE TRIGGER SGAS.SC_DAT_LUB
after insert or delete or update of LAST_UPDATED_BY 
ON SCOAP_DATA for each row
declare
   p_aud_date      DATE                              := SYSDATE;
   p_column_name   scoap_data_aud.column_name%TYPE   := NULL;
   p_table_pkey1   scoap_data_aud.table_pkey1%TYPE   := substr(:old.ITEM_NAME,1,32);
   p_table_pkey2   scoap_data_aud.table_pkey2%TYPE   := NULL;
   p_table_pkey3   scoap_data_aud.table_pkey3%TYPE   := NULL;
   p_table_pkey4   scoap_data_aud.table_pkey4%TYPE   := NULL;
   p_table_pkey5   scoap_data_aud.table_pkey5%TYPE   := NULL;
   p_old           scoap_data_aud.OLD%TYPE           := NULL;
   p_new           scoap_data_aud.NEW%TYPE           := NULL;
   p_action        scoap_data_aud.action%TYPE        := NULL;
   p_username      scoap_data_aud.username%TYPE      := USER;
   p_stud_ref_no   scoap_data_aud.stud_ref_no%TYPE   := NULL;
   p_inst_code     scoap_data_aud.inst_code%TYPE     := NULL;
   p_session_code  scoap_data_aud.session_code%TYPE  := NULL;
   

BEGIN
   IF INSERTING THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_table_pkey1 := substr(:new.ITEM_NAME,1,32);  
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
   pk_steps_aud.ins_sc_dat_aud (p_aud_date,
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

end SC_DAT_LUB;
/
SHOW ERRORS;*/

-- 
-- Non Foreign Key Constraints for Table SCOAP_DATA 
-- 
ALTER TABLE SGAS.SCOAP_DATA ADD (
  CONSTRAINT P_SD
 PRIMARY KEY
 (ITEM_NAME)
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
