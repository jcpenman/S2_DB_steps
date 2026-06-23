-- ADHOC_TYPE.sql
-- Description: Table holding all the Adhoc payment types in the SGAS Schema
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      22.02.13    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.ADHOC_TYPE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.ADHOC_TYPE CASCADE CONSTRAINTS PURGE
/
--
-- ADHOC_TYPE  (Table) 
--
CREATE TABLE sgas.ADHOC_TYPE
(
  adhoc_type_id               NUMBER(10)       NOT NULL,
  legacy_code                 VARCHAR2(1 BYTE) NOT NULL,
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

COMMENT ON COLUMN sgas.adhoc_type.adhoc_type_id IS 'Unique adhoc_type reference number';

COMMENT ON COLUMN sgas.adhoc_type.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN sgas.adhoc_type.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.adhoc_type.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.adhoc_type.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX adhoc_type_pk ON sgas.adhoc_type
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

ALTER TABLE sgas.adhoc_type ADD (
  CONSTRAINT adhoc_type_pk
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
DROP PUBLIC SYNONYM adhoc_type
/
CREATE PUBLIC SYNONYM adhoc_type FOR sgas.adhoc_type
/
DROP SEQUENCE sgas.adhoc_type_id_seq
/
--
-- adhoc_type_id_seq  (Sequence) 
--
CREATE SEQUENCE sgas.adhoc_type_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_adhoc_type_seq
   BEFORE INSERT
   ON sgas.adhoc_type
   FOR EACH ROW
BEGIN
   SELECT adhoc_type_id_seq.NEXTVAL
     INTO :NEW.adhoc_type_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--

INSERT INTO adhoc_type
            (legacy_code, descript
            )
     VALUES ('F', '2013 Financial Exception'
            );

INSERT INTO adhoc_type
            (legacy_code, descript
            )
     VALUES ('A', 'AHP Placement Expenses'
            );

INSERT INTO adhoc_type
            (legacy_code, descript
            )
     VALUES ('O', 'Adjustments to overpayment amounts'
            );

INSERT INTO adhoc_type
            (legacy_code, descript
            )
     VALUES ('E', 'Europe Study'
            );

INSERT INTO adhoc_type
            (legacy_code, descript
            )
     VALUES ('R', 'Repeat Funding'
            );

INSERT INTO adhoc_type
            (legacy_code, descript
            )
     VALUES ('T', 'Travel Expenses Abroad'
            );

INSERT INTO adhoc_type
            (legacy_code, descript
            )
     VALUES ('P', 'Placement Expenses'
            );

INSERT INTO adhoc_type
            (legacy_code, descript
            )
     VALUES ('V', 'Vacation Grant for Care Leavers'
            );

INSERT INTO adhoc_type
            (legacy_code, descript
            )
     VALUES ('L', 'Ad hoc Lone Parent Payments'
            );



COMMIT ;