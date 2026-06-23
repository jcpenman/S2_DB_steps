-- PAYEE_TYPE.sql
-- Description: Table holding all Payee Types
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      31.07.12    A Bowman (SAAS)         Initial Version. 
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.PAYEE_TYPE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.PAYEE_TYPE CASCADE CONSTRAINTS PURGE;
--
-- PAYEE_TYPE  (Table) 
--
CREATE TABLE SGAS.PAYEE_TYPE
(
  PAYEE_TYPE_ID   NUMBER(4)                     NOT NULL,
  TYPE            VARCHAR2(1)                   NOT NULL,
  DESCRIPTION     VARCHAR2(25)                  NOT NULL
)
TABLESPACE STEPS_DATA
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

ALTER TABLE SGAS.PAYEE_TYPE ADD (
  CONSTRAINT PAYEE_TYPE_PK
 PRIMARY KEY
 (PAYEE_TYPE_ID)
    USING INDEX 
    TABLESPACE STEPS_INDEX);

DROP SEQUENCE SGAS.PAYEE_TYPE_ID_SEQ;

CREATE SEQUENCE SGAS.PAYEE_TYPE_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


CREATE OR REPLACE TRIGGER SGAS.TRIG_PAYEE_TYPE_ID_SEQ
   BEFORE INSERT
   ON SGAS.PAYEE_TYPE    FOR EACH ROW
BEGIN
   SELECT PAYEE_TYPE_ID_SEQ.NEXTVAL
     INTO :NEW.PAYEE_TYPE_ID
     FROM DUAL;
END;
SHOW ERRORS;


--
-- INSERT DATA
--

INSERT INTO payee_type
            (type, description
            )
     VALUES ('N', 'NOMINEE'
            );


INSERT INTO payee_type
            (type, description
            )
     VALUES ('S', 'STUDENT'
            );


INSERT INTO payee_type
            (type, description
            )
     VALUES ('I', 'INSTITUTION'
            );

commit;