-- PAYMENT_RETURN_STATUS.sql
-- Description: Table for holding payment return statuses
-- Author J Wynne (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      22.03.13    J Wynne(SAAS)           Initial Version.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $


ALTER TABLE SGAS.PAYMENT_RETURN_STATUS
 DROP PRIMARY KEY CASCADE;
DROP TABLE SGAS.PAYMENT_RETURN_STATUS CASCADE CONSTRAINTS;

CREATE TABLE SGAS.PAYMENT_RETURN_STATUS
(
  PAYMENT_RETURN_STATUS_ID  NUMBER(10)          NOT NULL,
  CODE                      VARCHAR2(1 BYTE)    NOT NULL,
  DESCRIPT                  VARCHAR2(100 BYTE)  NOT NULL,
  LAST_UPDATED_BY           VARCHAR2(15 BYTE)   DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON           DATE                DEFAULT SYSDATE               NOT NULL
)
TABLESPACE STEPS_DATA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN SGAS.PAYMENT_RETURN_STATUS.PAYMENT_RETURN_STATUS_ID IS 'Unique adhoc_type reference number';

COMMENT ON COLUMN SGAS.PAYMENT_RETURN_STATUS.CODE IS 'unique code';

COMMENT ON COLUMN SGAS.PAYMENT_RETURN_STATUS.DESCRIPT IS 'Description of data item';

COMMENT ON COLUMN SGAS.PAYMENT_RETURN_STATUS.LAST_UPDATED_BY IS 'Audit information of last user to update record';

COMMENT ON COLUMN SGAS.PAYMENT_RETURN_STATUS.LAST_UPDATED_ON IS 'Audit information of last date record was updated';


CREATE UNIQUE INDEX SGAS.PAYMENT_RETURN_STATUS_PK ON SGAS.PAYMENT_RETURN_STATUS
(CODE)
LOGGING
TABLESPACE STEPS_INDEX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE OR REPLACE TRIGGER SGAS.trig_pay_rtn_status_seq
   BEFORE INSERT
   ON SGAS.PAYMENT_RETURN_STATUS    FOR EACH ROW
BEGIN
   SELECT pay_rtn_status_id_seq.NEXTVAL
     INTO :NEW.payment_return_status_id
     FROM DUAL;
END;                                                                        

ALTER TABLE payment_returns MODIFY ( 
	returns_batch_ref VARCHAR2(13)
);

DROP PUBLIC SYNONYM PAYMENT_RETURN_STATUS;

CREATE PUBLIC SYNONYM PAYMENT_RETURN_STATUS FOR SGAS.PAYMENT_RETURN_STATUS;


ALTER TABLE SGAS.PAYMENT_RETURN_STATUS ADD (
  CONSTRAINT PAYMENT_RETURN_STATUS_PK
 PRIMARY KEY
 (CODE)
    USING INDEX 
    TABLESPACE STEPS_INDEX
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));
               
--
-- INSERT DATA
--
INSERT INTO payment_return_status
            (code, descript, last_updated_by, last_updated_on 
            )
     VALUES ('N', 'Not Returned', 'SGAS', sysdate
            );

INSERT INTO payment_return_status
            (code, descript, last_updated_by, last_updated_on 
            )
     VALUES ('Y', 'Returned', 'SGAS', sysdate
            );

INSERT INTO payment_return_status
            (code, descript, last_updated_by, last_updated_on 
            )
     VALUES ('T', 'Awaiting Return - (re-issue pended)', 'SGAS', sysdate
            );

INSERT INTO payment_return_status
            (code, descript, last_updated_by, last_updated_on 
            )
     VALUES ('P', 'Awaiting Return - issue new payment', 'SGAS', sysdate
            );

INSERT INTO payment_return_status
            (code, descript, last_updated_by, last_updated_on 
            )
     VALUES ('A', 'Awaiting Return - do not issue new payment', 'SGAS', sysdate
            );


