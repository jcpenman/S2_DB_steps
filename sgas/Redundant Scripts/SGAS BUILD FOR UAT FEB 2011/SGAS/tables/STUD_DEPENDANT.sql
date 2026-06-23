-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                       Desc.
-- 001      28.02.08    S.Durkin (Sopra UK)          Initial Version.
-- 002      09.06.09    A.Bowman (SAAS)              Populate primary key automatically using a trigger 
-- 003      15.06.09    A.Bowman (SAAS)              Added audit triggers
-- 004      28.01.10    A.Bowman (SAAS)              Amended audit triggers
-- 005      30.04.10    A.Bowman (SAAS)              Added foreign key references
--                                                    
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STUD_DEPENDANT.sql $
-- $Author: $
-- $Date: 2011-01-27 14:11:48 +0000 (Thu, 27 Jan 2011) $
-- $Revision: 6356 $


ALTER TABLE SGAS.STUD_DEPENDANT
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.STUD_DEPENDANT CASCADE CONSTRAINTS
/

--
-- STUD_DEPENDANT  (Table) 
--
CREATE TABLE SGAS.STUD_DEPENDANT
(
  STD_ID           NUMBER(10) CONSTRAINT NN_STD_STD_ID NOT NULL,
  STUD_SESSION_ID  NUMBER(9) CONSTRAINT NN_STD_STUD_SESSION_ID NOT NULL,
  SESSION_CODE     NUMBER(4) CONSTRAINT NN_STD_SESSION_CODE NOT NULL,
  STUD_REF_NO      NUMBER(10) CONSTRAINT NN_STD_STUD_REF_NO NOT NULL,
  DOB              DATE CONSTRAINT NN_STD_DOB   NOT NULL,
  EMP_STATUS       VARCHAR2(1 BYTE),
  INCOME           NUMBER(9,2) CONSTRAINT NN_STD_INCOME NOT NULL,
  ASSIST           NUMBER(9,2) CONSTRAINT NN_STD_ASSIST NOT NULL,
  FIRST_NAME       VARCHAR2(25 BYTE) CONSTRAINT NN_STD_FIRST_NAME NOT NULL,
  SURNAME          VARCHAR2(25 BYTE) CONSTRAINT NN_STD_SURNAME NOT NULL,
  RELATION_ID      NUMBER(4) CONSTRAINT NN_STD_RELATION_ID NOT NULL,
  SUPER_ANN        NUMBER(9,2),
  RETIRE_ANN       NUMBER(9,2),
  LIFE_ASSURANCE   NUMBER(9,2),
  INTEREST         NUMBER(9,2),
  TAX_DEDUCT       NUMBER(9,2),
  INCLUDE          VARCHAR2(1 BYTE),
  START_DATE       DATE,
  END_DATE         DATE,
  FINAL            VARCHAR2(1 BYTE)             DEFAULT 'N',
  AGE_RATE         VARCHAR2(1 BYTE)             DEFAULT 'N',
  SMG              VARCHAR2(1 BYTE),
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_STD_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_STD_LAST_UPDATED_ON NOT NULL
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
-- S4_STD  (Index) 
--
CREATE INDEX S4_STD ON SGAS.STUD_DEPENDANT
(RELATION_ID)
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
-- S1_STD  (Index) 
--
CREATE INDEX S1_STD ON SGAS.STUD_DEPENDANT
(STUD_SESSION_ID)
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
-- S3_STD  (Index) 
--
CREATE INDEX S3_STD ON SGAS.STUD_DEPENDANT
(STUD_REF_NO)
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
-- P_STD  (Index) 
--
CREATE UNIQUE INDEX P_STD ON SGAS.STUD_DEPENDANT
(STD_ID)
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
-- Non Foreign Key Constraints for Table STUD_DEPENDANT 
-- 

ALTER TABLE SGAS.STUD_DEPENDANT ADD (
  CONSTRAINT STD_AGE_RATE
 CHECK (age_rate in ('Y', 'N')))
/

ALTER TABLE SGAS.STUD_DEPENDANT ADD (
  CONSTRAINT STD_EMP_STATUS
 CHECK ( EMP_STATUS IN('U','S','E','H','D')))
/

ALTER TABLE SGAS.STUD_DEPENDANT ADD (
  CONSTRAINT STD_FINAL
 CHECK (final in ('N','Y')))
/

ALTER TABLE SGAS.STUD_DEPENDANT ADD (
  CONSTRAINT STD_INCLUDE
 CHECK ( INCLUDE IN('Y','N')))
/

ALTER TABLE SGAS.STUD_DEPENDANT ADD (
  CONSTRAINT STD_SMG
 CHECK (smg in('Y','N')))
/

ALTER TABLE SGAS.STUD_DEPENDANT ADD (
  CONSTRAINT P_STD
 PRIMARY KEY
 (STD_ID)
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

ALTER TABLE SGAS.STUD_DEPENDANT ADD (
  CONSTRAINT F1_STD
 FOREIGN KEY (STUD_SESSION_ID) 
 REFERENCES SGAS.STUD_SESSION (STUD_SESSION_ID));

ALTER TABLE SGAS.STUD_DEPENDANT ADD (
  CONSTRAINT F2_STD
 FOREIGN KEY (STUD_REF_NO) 
 REFERENCES SGAS.STUD (STUD_REF_NO));


DROP SEQUENCE SGAS.STD_STD_ID_SEQ;

CREATE SEQUENCE SGAS.STD_STD_ID_SEQ
  START WITH 200000
  MAXVALUE 999999999999
  MINVALUE 200000
  NOCYCLE
  NOCACHE
  NOORDER;


CREATE OR REPLACE TRIGGER SGAS.trig_std_seq
   BEFORE INSERT
   ON SGAS.stud_dependant
   FOR EACH ROW
BEGIN
   SELECT std_std_id_seq.NEXTVAL
     INTO :NEW.std_id
     FROM DUAL;
END;
/

--- 003

/* Formatted on 2008/10/15 11:14 (Formatter Plus v4.8.8) */
/******************************************************************************
NAME: STD_IUD        
PURPOSE: Trigger to meet audit requirements

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        07.10.2008  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STUD_DEPENDANT.sql $ 
$Author: $ 
$Date: 2011-01-27 14:11:48 +0000 (Thu, 27 Jan 2011) $ 
$Revision: 6356 $ 
 
*******************************************************************************/
CREATE OR REPLACE TRIGGER SGAS.std_iud
   AFTER INSERT OR DELETE OR UPDATE OF dob,
                                       income,
                                       assist,
                                       emp_status,
                                       relation_id,
                                       interest,
                                       include,
                                       first_name,
                                       surname,
                                       last_updated_by
   ON SGAS.STUD_DEPENDANT    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                   := SYSDATE;
   p_column_name    stud_dependant_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_dependant_aud.table_pkey1%TYPE
                                                     := TO_CHAR (:OLD.std_id);
   p_table_pkey2    stud_dependant_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    stud_dependant_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    stud_dependant_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    stud_dependant_aud.table_pkey5%TYPE    := NULL;
   p_old            stud_dependant_aud.OLD%TYPE            := NULL;
   p_new            stud_dependant_aud.NEW%TYPE            := NULL;
   p_action         stud_dependant_aud.action%TYPE         := NULL;
   p_username       stud_dependant_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    stud_dependant_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      stud_dependant_aud.inst_code%TYPE      := NULL;
   p_session_code   stud_dependant_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.std_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.std_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'DOB';
   p_old := TO_CHAR (:OLD.dob, 'DD/MM/YYYY HH24:MI');
   p_new := TO_CHAR (:NEW.dob, 'DD/MM/YYYY HH24:MI');
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   p_column_name := 'INCOME';
   p_old := TO_CHAR (:OLD.income);
   p_new := TO_CHAR (:NEW.income);
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   p_column_name := 'ASSIST';
   p_old := TO_CHAR (:OLD.assist);
   p_new := TO_CHAR (:NEW.assist);
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   p_column_name := 'EMP_STATUS';
   p_old := TO_CHAR (:OLD.emp_status);
   p_new := TO_CHAR (:NEW.emp_status);
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   p_column_name := 'RELATION_ID';
   p_old := TO_CHAR (:OLD.relation_id);
   p_new := TO_CHAR (:NEW.relation_id);
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   p_column_name := 'INTEREST';
   p_old := TO_CHAR (:OLD.interest);
   p_new := TO_CHAR (:NEW.interest);
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   p_column_name := 'INCLUDE';
   p_old := :OLD.include;
   p_new := :NEW.include;
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   p_column_name := 'FIRST_NAME';
   p_old := TO_CHAR (:OLD.first_name);
   p_new := TO_CHAR (:NEW.first_name);
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   pk_steps_aud.ins_std_aud (p_aud_date,
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
   pk_steps_aud.ins_std_aud (p_aud_date,
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
END std_iud;
SHOW ERRORS;

GRANT SELECT ON  SGAS.STUD_DEPENDANT TO PUBLIC;