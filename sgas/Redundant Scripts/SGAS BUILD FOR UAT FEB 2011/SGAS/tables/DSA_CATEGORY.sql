/* Formatted on 2009/09/18 14:15 (Formatter Plus v4.8.8) */
-- DSA_CATEGORY.sql
-- Description: Table holding all DSA Categories for SGAS
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      17.09.09    A.Bowman (SAAS)         Initial Version.
-- 1.1      18.09.09    A.Bowman (SAAS)         Amended type_id values
-- 1.2      09.11.09    A.Bowman (SAAS)         Added additional standing data
-- 1.3      28.01.10    A.Bowman (SAAS)         Amended audit triggers
-- 1.4	    01.04.10    P.Grace			Amended 'OTHER' and 'Top Up' entries to include note of DSA Type
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.dsa_category
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.dsa_category CASCADE CONSTRAINTS PURGE
/
--
-- DSA_CATEGORY  (Table) 
--
CREATE TABLE sgas.dsa_category
(
  dsa_category_id            NUMBER(10)       NOT NULL,
  code                       VARCHAR2(3 BYTE) NOT NULL,
  description                VARCHAR2(80 BYTE) NOT NULL,
  type_id                       VARCHAR2(3 BYTE) NOT NULL,
  last_updated_by            VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  last_updated_on            DATE                     DEFAULT SYSDATE               NOT NULL
)
TABLESPACE users
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCOMPRESS
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN sgas.dsa_category.dsa_category_id IS 'Unique DSA_CATEGORY reference number';

COMMENT ON COLUMN sgas.dsa_category.code IS 'Unique DSA_CATEGORY code';

COMMENT ON COLUMN sgas.dsa_category.description IS 'Unique DSA_CATEGORY description';

COMMENT ON COLUMN sgas.dsa_category.type_id IS 'Unique dsa type';

COMMENT ON COLUMN sgas.dsa_category.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.dsa_category.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX dsa_category_pk ON sgas.dsa_category
(dsa_category_id)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE OR REPLACE TRIGGER SGAS.dsa_cat_iud
   AFTER INSERT OR DELETE OR UPDATE OF dsa_category_id,
                                       code,
                                       description,
                                       type_id,
                                       last_updated_by
   ON SGAS.DSA_CATEGORY    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                 := SYSDATE;
   p_column_name    dsa_category_aud.column_name%TYPE    := NULL;
   p_table_pkey1    dsa_category_aud.table_pkey1%TYPE := :OLD.dsa_category_id;
   p_table_pkey2    dsa_category_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    dsa_category_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    dsa_category_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    dsa_category_aud.table_pkey5%TYPE    := NULL;
   p_old            dsa_category_aud.OLD%TYPE            := NULL;
   p_new            dsa_category_aud.NEW%TYPE            := NULL;
   p_action         dsa_category_aud.action%TYPE         := NULL;
   p_username       dsa_category_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    dsa_category_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      dsa_category_aud.inst_code%TYPE      := NULL;
   p_session_code   dsa_category_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.dsa_category_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.dsa_category_id;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'DSA_CATEGORY_ID';
   p_old := :OLD.dsa_category_id;
   p_new := :NEW.dsa_category_id;
   pk_steps_aud.ins_dsa_cat_aud (p_aud_date,
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
   p_column_name := 'CODE';
   p_old := TO_CHAR (:OLD.code);
   p_new := TO_CHAR (:NEW.code);
   pk_steps_aud.ins_dsa_cat_aud (p_aud_date,
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
   p_column_name := 'DESCRIPTION';
   p_old := TO_CHAR (:OLD.description);
   p_new := TO_CHAR (:NEW.description);
   pk_steps_aud.ins_dsa_cat_aud (p_aud_date,
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
   p_column_name := 'TYPE_ID';
   p_old := TO_CHAR (:OLD.type_id);
   p_new := TO_CHAR (:NEW.type_id);
   pk_steps_aud.ins_dsa_cat_aud (p_aud_date,
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
   p_old := :OLD.type_id;
   p_new := :NEW.type_id;
   pk_steps_aud.ins_dsa_cat_aud (p_aud_date,
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
END dsa_cat_iud;
SHOW ERRORS;

ALTER TABLE sgas.dsa_category ADD (
  CONSTRAINT dsa_category_pk
 PRIMARY KEY
 (dsa_category_id)
    USING INDEX
    TABLESPACE users
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64 k
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));



-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM dsa_category
/
CREATE PUBLIC SYNONYM dsa_category FOR sgas.dsa_category
/
DROP SEQUENCE sgas.dsa_cat_id_seq
/
--
-- DSA_CATEGORY_seq  (Sequence) 
--
CREATE SEQUENCE sgas.dsa_cat_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_dsa_cat_seq
   BEFORE INSERT
   ON sgas.dsa_category
   FOR EACH ROW
BEGIN
   SELECT dsa_cat_id_seq.NEXTVAL
     INTO :NEW.dsa_category_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('101', 'PC/Laptop', 1
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('102', 'Printer/Scanner', 1
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('103', 'Software', 1
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('104', 'Laptop Carry Case', 1
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('105', 'Mouse', 1
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('106', 'Laptop Stand', 1
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('107', 'Warranty', 1
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('108', 'Insurance', 1
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('109', 'Other (Large Equipment)', 1
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('110', 'Top up Basic (Large Equipment)', 1
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('111', 'Top up Non-Medical (Large Equipment)', 1
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('201', 'Photocopying', 2
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('202', 'Printing', 2
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('203', 'Paper', 2
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('204', 'Ink Cartridges', 2
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('205', 'Internet', 2
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('206', 'Digital Recorder/Minidisk and Microphone', 2
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('207', 'Personal Organiser/Palmtop', 2
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('208', 'Other (Basic and Small Equipment)', 2
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('209', 'Top up Large (Basic and Small Equipment)', 2
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('210', 'Top up Non-Medical (Basic and Small Equipment)', 2
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('301', 'Scribe', 3
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('302', 'Note Taker', 3
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('303', 'Proof Reader', 3
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('304', 'Study Support', 3
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('305', 'Dyslexia Support', 3
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('306', 'Personal Help', 3
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('307', 'Other (Non Medical Support)', 3
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('308', 'Top up Large (Non Medical Support)', 3
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('309', 'Top up Basic (Non Medical Support)', 3
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('401', 'Taxi', 4
            );
INSERT INTO dsa_category
            (code, description, type_id
            )
     VALUES ('402', 'Other (DSA Travel)', 4
            );

COMMIT ;