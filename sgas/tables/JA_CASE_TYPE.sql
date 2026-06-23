-- JA_CASE_TYPE.sql
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 1.0      05.04.2011    A.Bowman (SAAS)         Initial Version.
--
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $


DROP TABLE sgas.JA_CASE_TYPE CASCADE CONSTRAINTS
/
--
-- JA_CASE_TYPE  (Table) 
--
CREATE TABLE sgas.JA_CASE_TYPE
(
  ja_case_type_id             NUMBER(10)       NOT NULL,
  legacy_id                   NUMBER(4) NOT NULL,
  legacy_code                 VARCHAR2(4 BYTE) NOT NULL,
  descript                    VARCHAR2(1000 BYTE) NOT NULL,
  last_updated_by             VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  last_updated_on             DATE                     DEFAULT SYSDATE               NOT NULL
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


CREATE UNIQUE INDEX ja_case_type_pk ON sgas.ja_case_type
(ja_case_type_id)
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


ALTER TABLE sgas.ja_case_type ADD (
  CONSTRAINT ja_case_type_pk
 PRIMARY KEY
 (ja_case_type_id)
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
DROP PUBLIC SYNONYM ja_case_type
/
CREATE PUBLIC SYNONYM ja_case_type FOR sgas.ja_case_type
/
DROP SEQUENCE sgas.ja_case_type_seq
/
--
-- JA_CASE_TYPE_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.ja_case_type_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_ja_case_type_seq
   BEFORE INSERT
   ON sgas.ja_case_type
   FOR EACH ROW
BEGIN
   SELECT ja_case_type_id_seq.NEXTVAL
     INTO :NEW.ja_case_type_id
     FROM DUAL;
END;                                                                       

--
-- INSERT DATA
--
INSERT INTO ja_case_type
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'S', 'Sibling'
            );

INSERT INTO ja_case_type
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'P', 'Parent/Child'
            );


COMMIT ;