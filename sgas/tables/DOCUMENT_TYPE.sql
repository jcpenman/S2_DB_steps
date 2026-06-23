-- DOCUMENT_TYPE.sql
-- Description: Table holding all DOCUMENT_TYPEs for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      06.05.09    R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE SGAS.document_type
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.document_type CASCADE CONSTRAINTS PURGE
/
--
-- DOCUMENT_TYPE  (Table) 
--
CREATE TABLE SGAS.document_type
(
  document_type_id      NUMBER(10)               NOT NULL,
  descript              VARCHAR2(1000 BYTE)        NOT NULL,
  last_updated_by       VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  last_updated_on       DATE                     DEFAULT SYSDATE               NOT NULL
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

COMMENT ON COLUMN SGAS.document_type.document_type_id IS 'Unique DOCUMENT_TYPE reference number';

COMMENT ON COLUMN SGAS.document_type.descript IS 'Description of document type';

COMMENT ON COLUMN SGAS.document_type.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN SGAS.document_type.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX document_type_pk ON SGAS.document_type
(document_type_id)
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


ALTER TABLE SGAS.document_type ADD (
  CONSTRAINT document_type_pk
 PRIMARY KEY
 (document_type_id)
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
DROP PUBLIC SYNONYM document_type
/
CREATE PUBLIC SYNONYM document_type FOR sgas.document_type
/
DROP SEQUENCE SGAS.document_type_id_seq
/
--
-- DOCUMENT_TYPE_ID_seq  (Sequence) 
--
CREATE SEQUENCE SGAS.document_type_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER SGAS.trig_document_type_seq
   BEFORE INSERT
   ON SGAS.document_type
   FOR EACH ROW
BEGIN
   SELECT document_type_id_seq.NEXTVAL
     INTO :NEW.document_type_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--

INSERT INTO document_type
            (descript
            )
     VALUES ('UNCONDITIONAL OFFER'
            );

INSERT INTO document_type
            (descript
            )
     VALUES ('CERTIFICATE OF TRANSFER'
            );

INSERT INTO document_type
            (descript
            )
     VALUES ('PROOF OF EXEMPTION FROM PARCON'
            );

INSERT INTO document_type
            (descript
            )
     VALUES ('EVIDENCE OF ELIGIBILITY FROM MSA'
            );

INSERT INTO document_type
            (descript
            )
     VALUES ('EVIDENCE IN SUPPORT OF OPTIONAL ALLOWANCE'
            );

INSERT INTO document_type
            (descript
            )
     VALUES ('MARRIAGE CERTIFICATE'
            );

INSERT INTO document_type
            (descript
            )
     VALUES ('EVIDENCE OF TENANCY/HOME OWNERSHIP'
            );

INSERT INTO document_type
            (descript
            )
     VALUES ('DIVORCE DECREE OR SOLICITOR`S LETTER'
            );

INSERT INTO document_type
            (descript
            )
     VALUES ('EVIDENCE OF PARENTAL OF SPOUSE INCOME'
            );

INSERT INTO document_type
            (descript
            )
     VALUES ('EVIDENCE OF ALLOWABLE DEDUCTIONS'
            );

INSERT INTO document_type
            (descript
            )
     VALUES ('BIRTH CERTIFICATE OF DEPENDANT CHILDREN (BENEFACTOR`S OR STUDENT`S)'
            );

INSERT INTO document_type
            (descript
            )
     VALUES ('EVIDENCE OF STUDENT INCOME'
            );

INSERT INTO document_type
            (descript
            )
     VALUES ('EVIDENCE OF DEPENDANT`S INCOME'
            );

INSERT INTO document_type
            (descript
            )
     VALUES ('EVIDENCE OF SPONSORSHIP'
            );

INSERT INTO document_type
            (descript
            )
     VALUES ('EVIDENCE JUSTIFYING DSA'
            );



COMMIT ;