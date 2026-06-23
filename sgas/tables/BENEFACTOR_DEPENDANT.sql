-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- Modification History
-- Ref      Date        Author                  Desc.
-- 1.0      14.01.08    S.Durkin                Initial Version.
-- 1.1      22.06.09    A.Bowman (SAAS)         Added audit triggers
-- 1.2      28.01.10    A.Bowman (SAAS)         Amended audit triggers
-- 1.3      05.05.10    A.Bowman (SAAS)         Added foreign key reference
-- 1.4      19.08.10    A.Bowman (SAAS)         Added not null to DOB and RELATION_TYPE_ID columns
-- 1.5      25.11.10    A.Bowman (SAAS)         Added sequence for primary key
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/BENEFACTOR_DEPENDANT.sql $
-- $Author: $
-- $Date: 2011-01-27 14:11:48 +0000 (Thu, 27 Jan 2011) $
-- $Revision: 6356 $


ALTER TABLE SGAS.BENEFACTOR_DEPENDANT
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.BENEFACTOR_DEPENDANT CASCADE CONSTRAINTS
/

--
-- BENEFACTOR_DEPENDANT  (Table) 
--
CREATE TABLE SGAS.BENEFACTOR_DEPENDANT
(
  BED_ID             NUMBER(10) CONSTRAINT NN_BED_BED_ID NOT NULL,
  BEN_ID             NUMBER(9) CONSTRAINT NN_BED_BEN_ID NOT NULL,
  SESSION_CODE       NUMBER(4) CONSTRAINT NN_BED_SESSION_CODE NOT NULL,
  DOB                DATE NOT NULL,
  INCOME             NUMBER(9,2),
  DEPENDANT_TYPE     VARCHAR2(1 BYTE)           DEFAULT 'C' CONSTRAINT NN_BED_DEPENDANT_TYPE NOT NULL,
  RELATION_TYPE_ID   NUMBER(4) NOT NULL,
  ASSISTANCE_AMOUNT  NUMBER(9,2),
  DEDUCTION          NUMBER(9,2),
  LAST_UPDATED_BY    VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_BED_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON    DATE DEFAULT Sysdate CONSTRAINT NN_BED_LAST_UPDATED_ON NOT NULL
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
-- S1_BED  (Index) 
--
CREATE INDEX S1_BED ON SGAS.BENEFACTOR_DEPENDANT
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


--
-- P_BED  (Index) 
--
CREATE UNIQUE INDEX P_BED ON SGAS.BENEFACTOR_DEPENDANT
(BED_ID)
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

CREATE OR REPLACE TRIGGER SGAS.bed_iud
   AFTER INSERT OR DELETE OR UPDATE OF income, assistance_amount, dob, last_updated_by
   ON SGAS.BENEFACTOR_DEPENDANT    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                         := SYSDATE;
   p_column_name    benefactor_dependant_aud.column_name%TYPE    := NULL;
   p_table_pkey1    benefactor_dependant_aud.table_pkey1%TYPE  := :OLD.bed_id;
   p_table_pkey2    benefactor_dependant_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    benefactor_dependant_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    benefactor_dependant_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    benefactor_dependant_aud.table_pkey5%TYPE    := NULL;
   p_old            benefactor_dependant_aud.OLD%TYPE            := NULL;
   p_new            benefactor_dependant_aud.NEW%TYPE            := NULL;
   p_action         benefactor_dependant_aud.action%TYPE         := NULL;
   p_username       benefactor_dependant_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    benefactor_dependant_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      benefactor_dependant_aud.inst_code%TYPE      := NULL;
   p_session_code   benefactor_dependant_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.bed_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.bed_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'INCOME';
   p_old := TO_CHAR (:OLD.income);
   p_new := TO_CHAR (:NEW.income);
   pk_steps_aud.ins_bed_aud (p_aud_date,
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
   p_column_name := 'ASSISTANCE_AMOUNT';
   p_old := TO_CHAR (:OLD.assistance_amount);
   p_new := TO_CHAR (:NEW.assistance_amount);
   pk_steps_aud.ins_bed_aud (p_aud_date,
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
   p_column_name := 'DOB';
   p_old := TO_CHAR (:OLD.dob);
   p_new := TO_CHAR (:NEW.dob);
   pk_steps_aud.ins_bed_aud (p_aud_date,
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
   pk_steps_aud.ins_bed_aud (p_aud_date,
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
END bed_iud;
/
SHOW ERRORS;

-- 
-- Non Foreign Key Constraints for Table BENEFACTOR_DEPENDANT 
-- 

ALTER TABLE SGAS.BENEFACTOR_DEPENDANT ADD (
  CONSTRAINT BED_DEPENDANT_TYPE
 CHECK ( DEPENDANT_TYPE IN('C','A')))
/

ALTER TABLE SGAS.BENEFACTOR_DEPENDANT ADD (
  CONSTRAINT P_BED
 PRIMARY KEY
 (BED_ID)
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

ALTER TABLE SGAS.BENEFACTOR_DEPENDANT ADD (
  CONSTRAINT F1_BDE
 FOREIGN KEY (BEN_ID) 
 REFERENCES SGAS.BENEFACTOR (BEN_ID));

DROP SEQUENCE sgas.bed_bed_id_seq;

CREATE SEQUENCE sgas.bed_bed_id_seq
  START WITH 600000
  MAXVALUE 999999999999
  MINVALUE 600000
  NOCYCLE
  NOCACHE
  NOORDER;

DROP PUBLIC SYNONYM bed_bed_id_seq;

CREATE PUBLIC SYNONYM bed_bed_id_seq 
FOR sgas.bed_bed_id_seq;

GRANT SELECT ON  sgas.bed_bed_id_seq 
TO PUBLIC;
