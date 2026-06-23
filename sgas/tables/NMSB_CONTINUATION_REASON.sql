-- NMSB_CONTINUATION_REASON.sql
-- Description: Table holding all NMSB Continuation reasons for StEPS
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      05.02.10    A.Bowman (SAAS)         Initial Version.
-- 
-- 
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE SGAS.NMSB_CONTINUATION_REASON
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.NMSB_CONTINUATION_REASON CASCADE CONSTRAINTS PURGE
/
--
-- SGAS.NMSB_CONTINUATION_REASON  (Table) 
--
CREATE TABLE SGAS.NMSB_CONTINUATION_REASON
(
  nmsb_cont_id         NUMBER(10)       NOT NULL,
  legacy_code          VARCHAR2(4 BYTE) NOT NULL,
  descript             VARCHAR2(1000 BYTE) NOT NULL,
  last_updated_by      VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  last_updated_on      DATE                     DEFAULT SYSDATE               NOT NULL
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

COMMENT ON COLUMN SGAS.NMSB_CONTINUATION_REASON.nmsb_cont_id IS 'Unique NMSB Continuation Reason reference number';

COMMENT ON COLUMN SGAS.NMSB_CONTINUATION_REASON.legacy_code IS 'Legacy system GRASS/WEB character';

COMMENT ON COLUMN SGAS.NMSB_CONTINUATION_REASON.descript IS 'Description of data item';

COMMENT ON COLUMN SGAS.NMSB_CONTINUATION_REASON.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN SGAS.NMSB_CONTINUATION_REASON.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX NMSB_CONTINUATION_REASON_PK ON SGAS.NMSB_CONTINUATION_REASON
(nmsb_cont_id)
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





ALTER TABLE SGAS.NMSB_CONTINUATION_REASON ADD (
  CONSTRAINT NMSB_CONTINUATION_REASON_PK
 PRIMARY KEY
 (nmsb_cont_id)
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
DROP PUBLIC SYNONYM NMSB_CONTINUATION_REASON
/
CREATE PUBLIC SYNONYM NMSB_CONTINUATION_REASON FOR SGAS.NMSB_CONTINUATION_REASON
/
DROP SEQUENCE SGAS.NMSB_CON_REA_ID_SEQ
/
--
-- NMSB_CON_REA_ID_SEQ  (Sequence) 
--

CREATE SEQUENCE SGAS.NMSB_CON_REA_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_nmsb_con_rea_seq
   BEFORE INSERT
   ON SGAS.NMSB_CONTINUATION_REASON
   FOR EACH ROW
BEGIN
   SELECT NMSB_CON_REA_ID_SEQ.NEXTVAL
     INTO :NEW.nmsb_cont_id
     FROM DUAL;
END;
                                                                        
--
-- INSERT DATA
--

INSERT INTO NMSB_CONTINUATION_REASON
            (legacy_code, descript
            )
     VALUES (0, 'Long Term Ill-Health'
            );

INSERT INTO NMSB_CONTINUATION_REASON
            (legacy_code, descript
            )
     VALUES (0, 'Caring Difficulties'
            );

INSERT INTO NMSB_CONTINUATION_REASON
            (legacy_code, descript
            )
     VALUES (0, 'Bereavement'
            );

INSERT INTO NMSB_CONTINUATION_REASON
            (legacy_code, descript
            )
     VALUES (0, 'Ill-Health Related to Pregnancy/Childbirth'
            );

INSERT INTO NMSB_CONTINUATION_REASON
            (legacy_code, descript
            )
     VALUES (0, 'Other Issues related to Pregnancy/Childbirth'
            );

INSERT INTO NMSB_CONTINUATION_REASON
            (legacy_code, descript
            )
     VALUES (0, 'Any other Compassionate Circumstances'
            );

COMMIT ;