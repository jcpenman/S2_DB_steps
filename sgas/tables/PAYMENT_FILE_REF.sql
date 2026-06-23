/******************************************************************************
TABLE NAME: PAYMENT_FILE_REF        
DESCRIPTION: Table holding payment file tYpes

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        12.10.2010  A.Bowman         Initial Version 


CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/
 
ALTER TABLE SGAS.PAYMENT_FILE_REF
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.PAYMENT_FILE_REF CASCADE CONSTRAINTS PURGE
/
--
-- PAYMENT_FILE_REF  (Table) 
--
CREATE TABLE SGAS.PAYMENT_FILE_REF
( TYPE_CODE                VARCHAR2(1 BYTE) NOT NULL,
  DESCRIPTION              VARCHAR2(20 BYTE) NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
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

CREATE UNIQUE INDEX PAYMENT_FILE_REF_PK ON SGAS.PAYMENT_FILE_REF
(TYPE_CODE)
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

ALTER TABLE SGAS.PAYMENT_FILE_REF ADD (
  CONSTRAINT PAYMENT_FILE_REF_PK
 PRIMARY KEY
 (TYPE_CODE)
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
DROP PUBLIC SYNONYM PAYMENT_FILE_REF
/

CREATE PUBLIC SYNONYM PAYMENT_FILE_REF FOR SGAS.PAYMENT_FILE_REF
/

---
-- Insert Data
---

INSERT INTO PAYMENT_FILE_REF
            (type_code, description 
            )
    VALUES('A', 'ADI File'
            );

INSERT INTO PAYMENT_FILE_REF
            (type_code, description 
            )
    VALUES('B', 'BACS File'
            );

commit;