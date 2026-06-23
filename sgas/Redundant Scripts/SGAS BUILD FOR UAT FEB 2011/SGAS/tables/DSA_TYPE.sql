-- DSA_TYPE.sql
-- Description: Table holding all DSA Types for SGAS
-- Author A.Bowman(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      17.09.09    A.Bowman (SAAS)         Initial Version.
-- 1.1      28.01.10    A.Bowman (SAAS)         Amended audit triggers
-- 
-- 
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.DSA_TYPE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.DSA_TYPE CASCADE CONSTRAINTS
/
--
-- DSA_TYPE  (Table) 
--
CREATE TABLE sgas.DSA_TYPE
(
  DSA_TYPE_id            NUMBER(10)       NOT NULL,
  code                   VARCHAR2(3 BYTE),
  type                   VARCHAR2(32 BYTE) NOT NULL,
  last_updated_by        VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  last_updated_on        DATE                     DEFAULT SYSDATE               NOT NULL
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

COMMENT ON COLUMN sgas.DSA_TYPE.DSA_TYPE_id IS 'Unique DSA_TYPE reference number';

COMMENT ON COLUMN sgas.DSA_TYPE.code IS 'Unique dsa type code';

COMMENT ON COLUMN sgas.DSA_TYPE.type IS 'Unique dsa type';

COMMENT ON COLUMN sgas.DSA_TYPE.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.DSA_TYPE.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX DSA_TYPE_pk ON sgas.DSA_TYPE
(DSA_TYPE_id)
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


CREATE OR REPLACE TRIGGER DSA_TYPE_iud
   AFTER INSERT OR DELETE OR UPDATE OF DSA_TYPE_id,
                                       type,
                                       last_updated_by
                                       
ON DSA_TYPE FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DSA_TYPE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_TYPE_aud.table_pkey1%TYPE
                                               := :OLD.DSA_TYPE_ID;
   p_table_pkey2    DSA_TYPE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_TYPE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_TYPE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_TYPE_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_TYPE_aud.OLD%TYPE            := NULL;
   p_new            DSA_TYPE_aud.NEW%TYPE            := NULL;
   p_action         DSA_TYPE_aud.action%TYPE         := NULL;
   p_username       DSA_TYPE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_TYPE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_TYPE_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_TYPE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.DSA_TYPE_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.DSA_TYPE_id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'DSA_TYPE_ID';
   p_old := :OLD.DSA_TYPE_id;
   p_new := :NEW.DSA_TYPE_id;
   pk_steps_aud.ins_DSA_TYPE_aud (p_aud_date,
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
   pk_steps_aud.ins_DSA_TYPE_aud (p_aud_date,
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
   p_column_name := 'TYPE';
   p_old := TO_CHAR (:OLD.type);
   p_new := TO_CHAR (:NEW.type);
   pk_steps_aud.ins_DSA_TYPE_aud (p_aud_date,
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
   pk_steps_aud.ins_DSA_TYPE_aud (p_aud_date,
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
   
END DSA_TYPE_iud;
SHOW ERRORS;

ALTER TABLE sgas.DSA_TYPE ADD (
  CONSTRAINT DSA_TYPE_pk
 PRIMARY KEY
 (DSA_TYPE_id)
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
DROP PUBLIC SYNONYM DSA_TYPE
/
CREATE PUBLIC SYNONYM DSA_TYPE FOR sgas.DSA_TYPE
/
DROP SEQUENCE sgas.DSA_TYPE_id_seq
/
--
-- DSA_TYPE_seq  (Sequence) 
--
CREATE SEQUENCE sgas.DSA_TYPE_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_DSA_TYPE_seq
   BEFORE INSERT
   ON SGAS.DSA_TYPE
   FOR EACH ROW
BEGIN
   SELECT DSA_TYPE_id_seq.NEXTVAL
     INTO :NEW.DSA_TYPE_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--
INSERT INTO DSA_TYPE
            (code,type
            )
     VALUES ('LRG', 'Large Equipment'
            );
INSERT INTO DSA_TYPE
            (code,type
            )
     VALUES ('BAS', 'Basic and Small Equipment'
            );
INSERT INTO DSA_TYPE
            (code,type
            )
     VALUES ('NMS', 'Non Medical Support'
            );
INSERT INTO DSA_TYPE
            (code,type
            )
     VALUES ('TRA', 'DSA Travel'
            );


COMMIT ;