-- TABLE: DOCUMENT_REGISTER
-- Description: Table holding documents for LEARNER and PROVIDER
--              
-- Author R.Hunter(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                   Desc.
-- 1.0      04.06.08    R Hunter (SAAS)          Initial Version.
-- 1.1      18.05.09    A.Bowman (SAAS)          Amended size of document_type_code to 100 as requested
-- 1.2      19.10.09    A.Bowman (SAAS)          Added triggers and sequence  
-- 1.3      15.02.10    A.Bowman (SAAS)          Amended audit triggers  
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/DOCUMENT_REGISTER.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $

ALTER TABLE DOCUMENT_REGISTER
 DROP PRIMARY KEY CASCADE
/
DROP TABLE DOCUMENT_REGISTER CASCADE CONSTRAINTS PURGE
/

--
-- DOCUMENT_REGISTER  (Table) 
--
CREATE TABLE document_register
( doc_reg_id       NUMBER(10) NOT NULL,
  SOURCE_TABLE     VARCHAR2(30 BYTE)            NOT NULL,
  PRIMARY_KEY      VARCHAR2(20 BYTE)            NOT NULL,
  document_type_code VARCHAR2(100 BYTE),
  received_date    DATE CONSTRAINT nn_dr_received_date NOT NULL,
  SESSION_YEAR     NUMBER(4) CONSTRAINT nn_dr_session_year NOT NULL,
  returned_date    DATE,
  last_updated_by  VARCHAR2(15 BYTE)            DEFAULT USER CONSTRAINT nn_dr_last_updated_by NOT NULL,
  last_updated_on  DATE                         DEFAULT SYSDATE CONSTRAINT nn_dr_last_updated_on NOT NULL
)

TABLESPACE users
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104 k
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

--
-- P_DOCUMENT_REGISTER  (Index) 
--
CREATE UNIQUE INDEX P_DOCUMENT_REGISTER ON DOCUMENT_REGISTER
(DOC_REG_ID)
LOGGING
TABLESPACE USERS
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
NOPARALLEL
/


-- 
-- Non Foreign Key Constraints for Table DOCUMENT_REGISTER
-- 
ALTER TABLE DOCUMENT_REGISTER ADD (
  CONSTRAINT P_DOCUMENT_REGISTER
 PRIMARY KEY
 (DOC_REG_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          104K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ))
/




--
-- S1_APR  (Index) 
--
CREATE INDEX s1_dr ON document_register
(primary_key)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104 k
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/
--
-- S2_APR  (Index) 
--
CREATE INDEX s2_dr ON document_register
(document_type_code)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104 k
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

/* Formatted on 2008/07/09 15:38 (Formatter Plus v4.8.8) */
-- TRIGGER: DOC_REG_IUD
-- TABLE: DOCUMENT_REGISTER
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      09.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/DOCUMENT_REGISTER.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
CREATE OR REPLACE TRIGGER ila500.doc_reg_iud
   AFTER DELETE OR INSERT OR UPDATE OF doc_reg_id,
                                       source_table,
                                       primary_key,
                                       document_type_code,
                                       received_date,
                                       session_year,
                                       returned_date,
                                       last_updated_by
   ON ila500.document_register
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   document_register_aud.column_name%TYPE   := NULL;
   p_primary_key   document_register_aud.primary_key%TYPE  := :OLD.doc_reg_id;
   p_old           document_register_aud.OLD%TYPE           := NULL;
   p_new           document_register_aud.NEW%TYPE           := NULL;
   p_action        document_register_aud.action%TYPE        := NULL;
   p_username      document_register_aud.username%TYPE      := :NEW.last_updated_by;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := :OLD.last_updated_by;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_primary_key := :NEW.doc_reg_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   END IF;

   p_column_name := 'DOC_REG_ID';
   p_old := :OLD.doc_reg_id;
   p_new := :NEW.doc_reg_id;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'SOURCE_TABLE';
   p_old := :OLD.source_table;
   p_new := :NEW.source_table;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'PRIMARY_KEY';
   p_old := :OLD.primary_key;
   p_new := :NEW.primary_key;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'DOCUMENT_TYPE_CODE';
   p_old := :OLD.document_type_code;
   p_new := :NEW.document_type_code;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'RECEIVED_DATE';
   p_old := :OLD.received_date;
   p_new := :NEW.received_date;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'SESSION_YEAR';
   p_old := :OLD.session_year;
   p_new := :NEW.session_year;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'RETURNED_DATE';
   p_old := :OLD.returned_date;
   p_new := :NEW.returned_date;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END doc_reg_iud;

SHOW ERRORS;

/* Formatted on 2008/07/07 15:43 (Formatter Plus v4.8.8) */
-- TRIGGER: DOC_REG_LUB
-- TABLE: DOCUMENT_REGISTER
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      07.07.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/DOCUMENT_REGISTER.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $ 
--
/*CREATE OR REPLACE TRIGGER ila500.doc_reg_lub
   AFTER DELETE OR INSERT OR UPDATE OF last_updated_by
   ON ila500.document_register
   FOR EACH ROW
DECLARE
   p_aud_date      DATE                                     := SYSDATE;
   p_column_name   document_register_aud.column_name%TYPE   := NULL;
   p_primary_key   document_register_aud.primary_key%TYPE  := :OLD.doc_reg_id;
   p_old           document_register_aud.OLD%TYPE           := NULL;
   p_new           document_register_aud.NEW%TYPE           := NULL;
   p_action        document_register_aud.action%TYPE        := NULL;
   p_username      document_register_aud.username%TYPE      := USER;
BEGIN
   IF DELETING
   THEN
      p_action := 'D';
      p_username := USER;
   ELSIF INSERTING
   THEN
      p_action := 'I';
      p_username := :NEW.last_updated_by;
      p_primary_key := :NEW.doc_reg_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_username := :NEW.last_updated_by;
   END IF;

   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_pop_aud.ins_doc_reg_aud (p_aud_date,
                               p_column_name,
                               p_primary_key,
                               p_old,
                               p_new,
                               p_action,
                               p_username
                              );
END doc_reg_lub;
/
SHOW ERRORS;*/


-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM document_register
/

CREATE PUBLIC SYNONYM document_register FOR ILA500.document_register
/

-- 
-- Grants
--
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE
ON document_register
TO EDM_USER
/

-- SEQUENCE SCRIPT FOR PK ON document_register TABLE
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      03.07.08    R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/Tables/DOCUMENT_REGISTER.sql $
-- $Author: $
-- $Date: 2010-10-21 11:02:12 +0100 (Thu, 21 Oct 2010) $
-- $Revision: 5799 $
DROP SEQUENCE doc_reg_id_seq
/

--
-- doc_reg_id_seq  (Sequence) 
--
CREATE SEQUENCE doc_reg_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/


CREATE OR REPLACE TRIGGER trig_document_register_seq BEFORE INSERT ON document_register
FOR EACH ROW
BEGIN
SELECT doc_reg_id_seq.NEXTVAL into :new.doc_reg_id FROM dual;
END;