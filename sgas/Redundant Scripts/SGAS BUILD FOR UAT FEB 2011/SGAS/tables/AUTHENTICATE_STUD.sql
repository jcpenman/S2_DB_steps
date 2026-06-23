-- AUTHENTICATE_STUD.sql
-- Description: Table holding details of web students who have had their application
--              details successfully registered in StEPS.
--
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      09.07.09    A.Bowman (SAAS)         Initial Version.
-- 1.1      10.07.09    A.Bowman (SAAS)         Added sequence and sequence trigger
-- 1.2      28.01.10    A.Bowman (SAAS)         Amended audit triggers
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

DROP TABLE SGAS.AUTHENTICATE_STUD CASCADE CONSTRAINTS
/

--
-- AUTHENTICATE_STUD  (Table) 
--
CREATE TABLE SGAS.AUTHENTICATE_STUD
(
  AUTH_STUD_ID           NUMBER(10) NOT NULL,
  STUD_REF_NO            NUMBER(10) NOT NULL,
  WEB_USER_ID            VARCHAR2(25) NOT NULL,
  LAST_UPDATED_BY        VARCHAR2(15 BYTE) DEFAULT USER NOT NULL,
  LAST_UPDATED_ON        DATE DEFAULT SYSDATE NOT NULL
 
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
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

CREATE UNIQUE INDEX AUTHENTICATE_STUD_PK ON SGAS.AUTHENTICATE_STUD
(AUTH_STUD_ID)
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

CREATE OR REPLACE TRIGGER SGAS.auth_stud_iud
   AFTER INSERT OR DELETE OR UPDATE OF auth_stud_id,
                                       stud_ref_no,
                                       web_user_id,
                                       last_updated_by
   ON SGAS.AUTHENTICATE_STUD    FOR EACH ROW
DECLARE
   p_aud_date       DATE                             := SYSDATE;
   p_column_name    AUTHENTICATE_STUD_AUD.column_name%TYPE    := NULL;
   p_table_pkey1    AUTHENTICATE_STUD_AUD.table_pkey1%TYPE
                                               := :OLD.auth_stud_id;
   p_table_pkey2    AUTHENTICATE_STUD_AUD.table_pkey2%TYPE    := NULL;
   p_table_pkey3    AUTHENTICATE_STUD_AUD.table_pkey3%TYPE    := NULL;
   p_table_pkey4    AUTHENTICATE_STUD_AUD.table_pkey4%TYPE    := NULL;
   p_table_pkey5    AUTHENTICATE_STUD_AUD.table_pkey5%TYPE    := NULL;
   p_old            AUTHENTICATE_STUD_AUD.OLD%TYPE            := NULL;
   p_new            AUTHENTICATE_STUD_AUD.NEW%TYPE            := NULL;
   p_action         AUTHENTICATE_STUD_AUD.action%TYPE         := NULL;
   p_username       AUTHENTICATE_STUD_AUD.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    AUTHENTICATE_STUD_AUD.stud_ref_no%TYPE    := NULL;
   p_inst_code      AUTHENTICATE_STUD_AUD.inst_code%TYPE      := NULL;
   p_session_code   AUTHENTICATE_STUD_AUD.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.auth_stud_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.auth_stud_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'AUTH_STUD_ID';
   p_old := :OLD.auth_stud_id;
   p_new := :NEW.auth_stud_id;
   pk_steps_aud.ins_auth_stud_aud (p_aud_date,
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
   p_column_name := 'STUD_REF_NO';
   p_old := TO_CHAR (:OLD.stud_ref_no);
   p_new := TO_CHAR (:NEW.stud_ref_no);
   pk_steps_aud.ins_auth_stud_aud (p_aud_date,
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
   p_column_name := 'WEB_USER_ID';
   p_old := TO_CHAR (:OLD.web_user_id);
   p_new := TO_CHAR (:NEW.web_user_id);
   pk_steps_aud.ins_auth_stud_aud (p_aud_date,
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
   pk_steps_aud.ins_auth_stud_aud (p_aud_date,
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
END auth_stud_iud;
SHOW ERRORS;


ALTER TABLE SGAS.AUTHENTICATE_STUD ADD (
  CONSTRAINT AUTHENTICATE_STUD_PK
 PRIMARY KEY
 (AUTH_STUD_ID)
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

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM AUTHENTICATE_STUD
/

CREATE PUBLIC SYNONYM AUTHENTICATE_STUD FOR SGAS.AUTHENTICATE_STUD
/

DROP SEQUENCE SGAS.auth_stud_id_seq
/
--
-- auth_stud_id_seq  (Sequence) 
--
CREATE SEQUENCE SGAS.auth_stud_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER SGAS.trig_auth_stud_seq
   BEFORE INSERT
   ON SGAS.authenticate_stud
   FOR EACH ROW
BEGIN
   SELECT auth_stud_id_seq.NEXTVAL
     INTO :NEW.auth_stud_id
     FROM DUAL;
END;

