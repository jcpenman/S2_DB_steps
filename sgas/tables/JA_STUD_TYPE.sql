-- JA_STUD_TYPE.sql
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


DROP TABLE sgas.JA_STUD_TYPE CASCADE CONSTRAINTS
/
--
-- JA_STUD_TYPE  (Table) 
--
CREATE TABLE sgas.JA_STUD_TYPE
(
  JA_STUD_TYPE_id             NUMBER(10)       NOT NULL,
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


CREATE UNIQUE INDEX JA_STUD_TYPE_pk ON sgas.JA_STUD_TYPE
(JA_STUD_TYPE_id)
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


ALTER TABLE sgas.JA_STUD_TYPE ADD (
  CONSTRAINT JA_STUD_TYPE_pk
 PRIMARY KEY
 (JA_STUD_TYPE_id)
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
DROP PUBLIC SYNONYM JA_STUD_TYPE
/
CREATE PUBLIC SYNONYM JA_STUD_TYPE FOR sgas.JA_STUD_TYPE
/
DROP SEQUENCE sgas.JA_STUD_TYPE_seq
/
--
-- JA_STUD_TYPE_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.JA_STUD_TYPE_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_JA_STUD_TYPE_seq
   BEFORE INSERT
   ON sgas.JA_STUD_TYPE
   FOR EACH ROW
BEGIN
   SELECT JA_STUD_TYPE_id_seq.NEXTVAL
     INTO :NEW.JA_STUD_TYPE_id
     FROM DUAL;
END;                                                                       

--
-- INSERT DATA
--
INSERT INTO JA_STUD_TYPE
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'S', 'Sibling'
            );

INSERT INTO JA_STUD_TYPE
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'P', 'Parent'
            );
INSERT INTO JA_STUD_TYPE
            (legacy_id, legacy_code, descript
            )
     VALUES (0, 'C', 'Child'
            );


COMMIT ;