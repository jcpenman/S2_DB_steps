-- SLC_BATCHES.sql
-- Description: Table holding all SLC Batch data for SGAS
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      21.04.11    A.Bowman  (SAAS)        Initial Version.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $


--
-- SLC_BATCHES  (Table) 
--

ALTER TABLE SGAS.SLC_BATCHES
 DROP PRIMARY KEY CASCADE;
DROP TABLE SGAS.SLC_BATCHES CASCADE CONSTRAINTS;

CREATE TABLE SGAS.SLC_BATCHES
(
  SLC_FILENAME               VARCHAR2(25 BYTE),
  SLC_FILE_DATE              DATE,
  SLC_FILE_TYPE              NUMBER(1),
  LAST_REPRINT_DATE          DATE,
  RECORD_COUNT               NUMBER(6),
  FEE_LOAN_RECORD_COUNT      NUMBER(6),
  STUDENT_LOAN_RECORD_COUNT  NUMBER(6),
  TOTAL_FEE_LOAN_CR          NUMBER(10,2),
  TOTAL_FEE_LOAN_DR          NUMBER(10,2)
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             500K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX SGAS.P_SLCB ON SGAS.SLC_BATCHES
(SLC_FILENAME, SLC_FILE_DATE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             500K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


DROP PUBLIC SYNONYM SLC_BATCHES;

CREATE PUBLIC SYNONYM SLC_BATCHES FOR SGAS.SLC_BATCHES;


ALTER TABLE SGAS.SLC_BATCHES ADD (
  CONSTRAINT P_SLCB
 PRIMARY KEY
 (SLC_FILENAME, SLC_FILE_DATE)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          500K
                NEXT             500K
                MINEXTENTS       1
                MAXEXTENTS       99
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ));


GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  SGAS.SLC_BATCHES TO PUBLIC;



                                                                        

