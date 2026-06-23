-- PAYMENT_RETURNS_METHOD.sql
-- Description: Table holding the different Payment Return Methods used in StEPS
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      09.01.13    A Bowman (SAAS)         Initial Version. 
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.PAYMENT_RETURNS_METHOD
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.PAYMENT_RETURNS_METHOD CASCADE CONSTRAINTS PURGE;
--
-- PAYMENT_RETURNS_METHOD  (Table) 
--
CREATE TABLE SGAS.PAYMENT_RETURNS_METHOD
(
  TYPE_ID         VARCHAR2(1)                     NOT NULL,
  METHOD_CODE     VARCHAR2(1)                     NOT NULL,
  DESCRIPT        VARCHAR2(40)                    NOT NULL,
  LAST_UPDATED_BY            VARCHAR2(15 BYTE)  DEFAULT User NOT NULL,
  LAST_UPDATED_ON            DATE               DEFAULT Sysdate NOT NULL
)
TABLESPACE STEPS_DATA
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE payment_returns_method IS 'Table holding all the different payment return methods used in StEPS';

ALTER TABLE SGAS.PAYMENT_RETURNS_METHOD ADD (
  CONSTRAINT PAYMENT_RETURNS_METHOD_PK
 PRIMARY KEY
 (TYPE_ID)
    USING INDEX 
    TABLESPACE STEPS_INDEX);

DROP SEQUENCE SGAS.PYMNT_RET_METH_ID_SEQ;

CREATE SEQUENCE SGAS.PYMNT_RET_METH_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


CREATE OR REPLACE TRIGGER SGAS.TRIG_PYMNT_RET_METH_ID_SEQ
   BEFORE INSERT
   ON SGAS.PAYMENT_RETURNS_METHOD    FOR EACH ROW
BEGIN
   SELECT PYMNT_RET_METH_ID_SEQ.NEXTVAL
     INTO :NEW.TYPE_ID
     FROM DUAL;
END;
SHOW ERRORS;


--
-- INSERT DATA
--

INSERT INTO PAYMENT_RETURNS_METHOD
            (method_code, descript
            )
     VALUES ('B', 'BACS' 
            );
            
INSERT INTO PAYMENT_RETURNS_METHOD
            (method_code, descript
            )
     VALUES ('C', 'CHEQUE' 
            );
            
INSERT INTO PAYMENT_RETURNS_METHOD
            (method_code, descript
            )
     VALUES ('H', 'CHAPS' 
            );
            
INSERT INTO PAYMENT_RETURNS_METHOD
            (method_code, descript
            )
     VALUES ('F', 'FOREIGN BANK TRANSFER' 
            );
            
INSERT INTO PAYMENT_RETURNS_METHOD
            (method_code, descript
            )
     VALUES ('P', 'POSTAL ORDER' 
            );
            
INSERT INTO PAYMENT_RETURNS_METHOD
            (method_code, descript
            )
     VALUES ('W', 'WORLD PAY' 
            );
            
INSERT INTO PAYMENT_RETURNS_METHOD
            (method_code, descript
            )
     VALUES ('D', 'CASH' 
            );

commit;