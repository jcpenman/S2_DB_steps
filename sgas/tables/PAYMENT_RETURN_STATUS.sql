-- PAYMENT_RETURN_STATUS.sql
-- Description: Table holding all the payment return statuses in the SGAS Schema
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      07.03.13    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.PAYMENT_RETURN_STATUS
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.PAYMENT_RETURN_STATUS CASCADE CONSTRAINTS PURGE
/
--
-- PAYMENT_RETURN_STATUS  (Table) 
--
CREATE TABLE sgas.PAYMENT_RETURN_STATUS
(
  payment_return_status_id               NUMBER(10)       NOT NULL,
  code                                   VARCHAR2(1 BYTE) NOT NULL,
  descript                               VARCHAR2(100 BYTE) NOT NULL,
  last_updated_by                        VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  last_updated_on                        DATE                     DEFAULT SYSDATE               NOT NULL
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

COMMENT ON COLUMN sgas.payment_return_status.payment_return_status_id IS 'Unique adhoc_type reference number';

COMMENT ON COLUMN sgas.payment_return_status.code IS 'unique code';

COMMENT ON COLUMN sgas.payment_return_status.descript IS 'Description of data item';

COMMENT ON COLUMN sgas.payment_return_status.last_updated_by IS 'Audit information of last user to update record';

COMMENT ON COLUMN sgas.payment_return_status.last_updated_on IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX payment_return_status_pk ON sgas.payment_return_status
(code)
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

ALTER TABLE sgas.payment_return_status ADD (
  CONSTRAINT payment_return_status_pk
 PRIMARY KEY
 (code)
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
DROP PUBLIC SYNONYM payment_return_status
/
CREATE PUBLIC SYNONYM payment_return_status FOR sgas.payment_return_status
/
DROP SEQUENCE sgas.pay_rtn_status_id_seq
/
--
-- pay_rtn_status_id_seq  (Sequence) 
--
CREATE SEQUENCE sgas.pay_rtn_status_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_pay_rtn_status_seq
   BEFORE INSERT
   ON sgas.payment_return_status
   FOR EACH ROW
BEGIN
   SELECT pay_rtn_status_id_seq.NEXTVAL
     INTO :NEW.payment_return_status_id
     FROM DUAL;
END;                                                                        

--
-- INSERT DATA
--

INSERT INTO payment_return_status
            (code, descript
            )
     VALUES ('N', 'Not Returned'
            );

INSERT INTO payment_return_status
            (code, descript
            )
     VALUES ('Y', 'Returned'
            );

INSERT INTO payment_return_status
            (code, descript
            )
     VALUES ('T', 'Awaiting Return - (re-issue pended)'
            );

INSERT INTO payment_return_status
            (code, descript
            )
     VALUES ('P', 'Awaiting Return - issue new payment'
            );

INSERT INTO payment_return_status
            (code, descript
            )
     VALUES ('A', 'Awaiting Return - do not issue new payment'
            );


COMMIT ;