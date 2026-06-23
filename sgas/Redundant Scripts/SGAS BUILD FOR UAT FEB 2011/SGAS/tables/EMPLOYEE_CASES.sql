/******************************************************************************
TABLE NAME: EMPLOYEE_CASES        
DESCRIPTION: Table holding steps cases for a particular user  

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        26.10.2010  A.Bowman         Initial Version 


CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/
 
ALTER TABLE SGAS.EMPLOYEE_CASES
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.EMPLOYEE_CASES CASCADE CONSTRAINTS PURGE
/
--
-- EMPLOYEE_CASES  (Table) 
--
CREATE TABLE SGAS.EMPLOYEE_CASES

(EMPLOYEE_CASE_ID    NUMBER(10) NOT NULL,
  USERNAME           VARCHAR2(15 BYTE) NOT NULL,
  REFERENCE_ID       NUMBER(10) NOT NULL,
  CASE_NUMBER        NUMBER(2) NOT NULL,
  DATE_ENTERED       DATE   DEFAULT SYSDATE NOT NULL)
  
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

CREATE UNIQUE INDEX emp_case_ind ON sgas.employee_cases
(employee_case_id)
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

ALTER TABLE sgas.employee_cases ADD (
  CONSTRAINT emp_case_pk
 PRIMARY KEY
 (employee_case_id)
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
               

DROP SEQUENCE sgas.emp_case_id_seq
/
--
-- emp_case_id_seq  (Sequence) 
--
CREATE SEQUENCE sgas.emp_case_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/

CREATE OR REPLACE TRIGGER SGAS.EMP_CASE_SEQ 
BEFORE INSERT
   ON EMPLOYEE_CASES
   FOR EACH ROW
BEGIN
   SELECT EMP_CASE_ID_SEQ.NEXTVAL
     INTO :NEW.EMPLOYEE_CASE_ID
     FROM DUAL;
END;

ALTER TABLE SGAS.EMPLOYEE_CASES ADD (
  CONSTRAINT EC_CASE_NO
 CHECK (CASE_NUMBER >=0 and CASE_NUMBER <= 10))
/

ALTER TABLE SGAS.EMPLOYEE_CASES ADD (
  CONSTRAINT F1_EC 
 FOREIGN KEY (USERNAME) 
 REFERENCES SGAS.EMPLOYEE (USERNAME));