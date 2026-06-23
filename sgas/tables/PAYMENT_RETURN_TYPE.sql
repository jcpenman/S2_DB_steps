-- PAYMENT_RETURN_TYPE.sql
-- Description: Table holding the different Payment Return Types used in StEPS
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      04.10.12    A Bowman (SAAS)         Initial Version. 
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.PAYMENT_RETURN_TYPE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.PAYMENT_RETURN_TYPE CASCADE CONSTRAINTS PURGE;
--
-- PAYMENT_RETURN_TYPE  (Table) 
--
CREATE TABLE SGAS.PAYMENT_RETURN_TYPE
(
  PAYMENT_RETURN_TYPE_ID   VARCHAR2(1)                     NOT NULL,
  DESCRIPTION     VARCHAR2(50)                  NOT NULL,
    LAST_UPDATED_BY            VARCHAR2(15 BYTE)  DEFAULT User NOT NULL,
  LAST_UPDATED_ON            DATE               DEFAULT Sysdate NOT NULL
)
TABLESPACE STEPS_DATA
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE payment_return_type IS 'Table holding all the different payment return types used in StEPS';

ALTER TABLE SGAS.PAYMENT_RETURN_TYPE ADD (
  CONSTRAINT PAYMENT_RETURN_TYPE_PK
 PRIMARY KEY
 (PAYMENT_RETURN_TYPE_ID)
    USING INDEX 
    TABLESPACE STEPS_INDEX);

DROP SEQUENCE SGAS.PAYMENT_RETURN_TYPE_ID_SEQ;

CREATE SEQUENCE SGAS.PAYMENT_RETURN_TYPE_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


CREATE OR REPLACE TRIGGER SGAS.TRIG_PYMNT_RET_TYPE_ID_SEQ
   BEFORE INSERT
   ON SGAS.PAYMENT_RETURN_TYPE    FOR EACH ROW
BEGIN
   SELECT PAYMENT_RETURN_TYPE_ID_SEQ.NEXTVAL
     INTO :NEW.PAYMENT_RETURN_TYPE_ID
     FROM DUAL;
END;
SHOW ERRORS;


--
-- INSERT DATA
--

INSERT INTO PAYMENT_RETURN_TYPE
            (description
            )
     VALUES ('BACS RETURN'
            );
            
INSERT INTO PAYMENT_RETURN_TYPE
            (description
            )
     VALUES ('CANCELLED PAYABLE ORDER'
            );
            
INSERT INTO PAYMENT_RETURN_TYPE
            (description
            )
     VALUES ('DISHONOURED CHEQUE'
            );
            
INSERT INTO PAYMENT_RETURN_TYPE
            (description
            )
     VALUES ('RECEIPT'
            );
            
INSERT INTO PAYMENT_RETURN_TYPE
            (description
            )
     VALUES ('RETURNED PAYMENT'
            );
            
INSERT INTO PAYMENT_RETURN_TYPE
            (description
            )
     VALUES ('TIME EXPIRED PAYABLE ORDER'
            );

commit;