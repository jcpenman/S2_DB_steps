/******************************************************************************
TABLE NAME: INST_CONT_EMAIL        
DESCRIPTION: Table holding EMAIL details for institutions

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        09.12.2010  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/
 
DROP TABLE SGAS.INST_CONT_EMAIL CASCADE CONSTRAINTS PURGE
/

--
-- INST_CONT_EMAIL  (Table) 
--

CREATE TABLE SGAS.INST_CONT_EMAIL
( INST_CODE_ID               NUMBER(10) NOT NULL,
  INST_CODE                  VARCHAR2(5) NOT NULL,
  EMAIL_ADDRESS              VARCHAR2(80) NOT NULL,
  FEE_REPORT                 VARCHAR2(1) NOT NULL,
  STATUS_REPORT              VARCHAR2(1) NOT NULL,
  LAST_UPDATED_BY VARCHAR2(25 BYTE) DEFAULT USER NOT NULL,
  LAST_UPDATED_ON DATE DEFAULT SYSDATE NOT NULL
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

CREATE UNIQUE INDEX INST_CONT_EMAIL_PK ON SGAS.INST_CONT_EMAIL
(INST_CODE_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE SGAS.INST_CONT_EMAIL ADD (
  CONSTRAINT INST_CONT_EMAIL_PK
 PRIMARY KEY
 (INST_CODE_ID)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));

ALTER TABLE SGAS.INST_CONT_EMAIL ADD (
  CONSTRAINT F1_ICD 
 FOREIGN KEY (INST_CODE) 
 REFERENCES SGAS.INST_CONT_DETAILS (INST_CODE));

-- 
-- Create public synonym: 
-- 

DROP PUBLIC SYNONYM INST_CONT_EMAIL
/

CREATE PUBLIC SYNONYM INST_CONT_EMAIL FOR SGAS.INST_CONT_EMAIL
/

DROP SEQUENCE SGAS.inst_code_id_seq
/
--
-- INST_CODE_ID_seq  (Sequence) 
--
CREATE SEQUENCE SGAS.inst_code_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_inst_code_id_seq
   BEFORE INSERT
   ON SGAS.INST_CONT_EMAIL
   FOR EACH ROW
BEGIN
   SELECT inst_code_id_seq.NEXTVAL
     INTO :NEW.inst_code_id
     FROM DUAL;
END; 
