-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date       Author                      Desc.
-- 001      28.02.08   S Durkin (Sopra UK)         Initial Version.
-- 002      22.06.09   A.Bowman (SAAS)             Added audit triggers.
-- 003      15.10.09   A.Bowman (SAAS)             Added materialized view log script
-- 004      28.01.10   A.Bowman (SAAS)             Amended audit trigger
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STUD_APP_PROG.sql $
-- $Author: $
-- $Date: 2010-12-21 14:42:40 +0000 (Tue, 21 Dec 2010) $
-- $Revision: 6206 $


ALTER TABLE SGAS.STUD_APP_PROG
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.STUD_APP_PROG CASCADE CONSTRAINTS
/

--
-- STUD_APP_PROG  (Table)
--
CREATE TABLE SGAS.STUD_APP_PROG
(
  STUD_REF_NO             NUMBER(10) NOT NULL,
  SLC_REF_NO              VARCHAR2(10 BYTE),
  STUD_CRSE_YEAR_ID       NUMBER(9),
  SESSION_CODE            NUMBER(4) NOT NULL,
  CASE_STATUS             VARCHAR2(1 BYTE)      DEFAULT 'R'                   NOT NULL,
  DATE_REGISTERED         DATE NOT NULL,
  DATE_CALCULATED         DATE,
  AWARD_LETTER_SENT_DATE  DATE,
  SLC_SENT_DATE           DATE,
  DUP_AWARD_LETTER        NUMBER(4) DEFAULT 0,
  WEB_SUBMITTED_DATE      DATE,
  LAST_UPDATED_BY         VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_SAP_LAST_UPDATED_BY NOT NULL, 
  LAST_UPDATED_ON         DATE DEFAULT Sysdate CONSTRAINT NN_SAP_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             518K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
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
-- S1_SAP  (Index) 
--
CREATE INDEX S1_SAP ON SGAS.STUD_APP_PROG
(SLC_REF_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             512K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S2_SAP  (Index) 
--
CREATE INDEX S2_SAP ON SGAS.STUD_APP_PROG
(STUD_CRSE_YEAR_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             506K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

--
-- STUD_APP_PROG_PK  (Index) 
--
CREATE UNIQUE INDEX STUD_APP_PROG_PK ON SGAS.STUD_APP_PROG
(STUD_REF_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             506K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

CREATE OR REPLACE TRIGGER SGAS.stapp_iud
   AFTER INSERT OR DELETE OR UPDATE OF award_letter_sent_date,
                                       date_calculated,
                                       last_updated_by
   ON SGAS.STUD_APP_PROG    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    stud_app_prog_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_app_prog_aud.table_pkey1%TYPE    := :OLD.stud_ref_no;
   p_table_pkey2    stud_app_prog_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_app_prog_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_app_prog_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_app_prog_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_app_prog_aud.OLD%TYPE            := NULL;
   p_new            stud_app_prog_aud.NEW%TYPE            := NULL;
   p_action         stud_app_prog_aud.action%TYPE         := NULL;
   p_username       stud_app_prog_aud.username%TYPE       := :NEW.last_updated_by;
   p_stud_ref_no    stud_app_prog_aud.stud_ref_no%TYPE    := :OLD.stud_ref_no;
   p_inst_code      stud_app_prog_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_app_prog_aud.session_code%TYPE   := NULL;
   p_table_name     VARCHAR2 (32)                         := 'STUD_APP_PROG';
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_ref_no;
      p_stud_ref_no := :NEW.stud_ref_no;
      telephony_support.update_tele (p_stud_ref_no, p_action, p_table_name);
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.stud_ref_no;
      p_stud_ref_no := :OLD.stud_ref_no;
      p_username    := :OLD.last_updated_by;
   END IF;

   p_column_name := 'AWARD_LETTER_SENT_DATE';
   p_old := :OLD.award_letter_sent_date;
   p_new := :NEW.award_letter_sent_date;
   pk_steps_aud.ins_stapp_aud (p_aud_date,
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
   p_column_name := 'DATE_CALCULATED';
   p_old := :OLD.date_calculated;
   p_new := :NEW.date_calculated;
   pk_steps_aud.ins_stapp_aud (p_aud_date,
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
   pk_steps_aud.ins_stapp_aud (p_aud_date,
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
END stapp_iud;
SHOW ERRORS;

-- 
-- Non Foreign Key Constraints for Table STUD_APP_PROG 
-- 
ALTER TABLE SGAS.STUD_APP_PROG ADD (
  CONSTRAINT STUD_APP_PROG_PK
 PRIMARY KEY
 (STUD_REF_NO)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          500K
                NEXT             506K
                MINEXTENTS       1
                MAXEXTENTS       99
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ))
/

-- 
-- Administer Grants
-- 
GRANT SELECT ON SGAS.STUD_APP_PROG TO PUBLIC
/

--
-- STUD_APP_PROG  (Materialized View Log)
--
DROP SNAPSHOT LOG ON STUD_APP_PROG
/
--
-- STUD_APP_PROG  (Materialized View Log) 
--
CREATE MATERIALIZED VIEW LOG ON STUD_APP_PROG
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