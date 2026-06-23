-- STUDENT_STATUS.sql
-- Description: Table holding all STUDENT STATUSES in the SGAS Schema
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      20.02.13    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.STUDENT_STATUS
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.STUDENT_STATUS CASCADE CONSTRAINTS PURGE
/
--
-- STUDENT_STATUS  (Table) 
--
CREATE TABLE sgas.STUDENT_STATUS
(
  student_status_id      NUMBER(10)       NOT NULL,
  legacy_code                 VARCHAR2(3 BYTE) NOT NULL,
  descript                    VARCHAR2(100 BYTE) NOT NULL,
  last_updated_by             VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  last_updated_on             DATE                     DEFAULT SYSDATE               NOT NULL
)
TABLESPACE steps_data
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

COMMENT ON COLUMN sgas.student_status.student_status_id IS 'Unique STUDENT_STATUS reference number';

COMMENT ON COLUMN sgas.student_status.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.student_status.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.student_status.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.student_status.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX student_status_pk ON sgas.student_status
(legacy_code)
LOGGING
TABLESPACE steps_index
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

ALTER TABLE sgas.student_status ADD (
  CONSTRAINT student_status_pk
 PRIMARY KEY
 (legacy_code)
    USING INDEX
    TABLESPACE steps_index
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
DROP PUBLIC SYNONYM student_status
/
CREATE PUBLIC SYNONYM student_status FOR sgas.student_status
/
DROP SEQUENCE sgas.student_status_id_seq
/
--
-- STUDENT_STATUS_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.STUDENT_status_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_stud_status_seq
   BEFORE INSERT
   ON sgas.student_status
   FOR EACH ROW
BEGIN
   SELECT student_status_id_seq.NEXTVAL
     INTO :NEW.student_status_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--

INSERT INTO student_status
            (legacy_code, descript
            )
     VALUES ('IND', 'Independent'
            );

INSERT INTO student_status
            (legacy_code, descript
            )
     VALUES ('DEP', 'Dependant'
            );

INSERT INTO student_status
            (legacy_code, descript
            )
     VALUES ('NON', 'Non-Income Assessed'
            );

COMMIT ;