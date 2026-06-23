-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                      Desc.
-- 001      28.02.08    S Durkin (Sopra UK)         Initial Version.
-- 002      15.10.09    A.Bowman (SAAS)             Added materialized view log script
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STUD_TRAV_PROG.sql $
-- $Author: $
-- $Date: 2009-10-15 14:41:56 +0100 (Thu, 15 Oct 2009) $
-- $Revision: 4024 $


ALTER TABLE SGAS.STUD_TRAV_PROG
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.STUD_TRAV_PROG CASCADE CONSTRAINTS
/

--
-- STUD_TRAV_PROG  (Table) 
--
CREATE TABLE SGAS.STUD_TRAV_PROG
(
  STUD_REF_NO        NUMBER(10)                 NOT NULL,
  SLC_REF_NO         VARCHAR2(10 BYTE),
  STUD_CRSE_YEAR_ID  NUMBER(9)                  NOT NULL,
  SESSION_CODE       NUMBER(4)                  NOT NULL,
  DATE_ASSESSED      DATE,
  PAYMENT_DATE       DATE,
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_STP_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_STP_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          100K
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
MONITORING
/


--
-- P_STP  (Index) 
--
CREATE UNIQUE INDEX P_STP ON SGAS.STUD_TRAV_PROG
(STUD_REF_NO)
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
NOPARALLEL
/


--
-- S1_STP  (Index) 
--
CREATE INDEX S1_STP ON SGAS.STUD_TRAV_PROG
(SLC_REF_NO)
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
NOPARALLEL
/


--
-- S2_STP  (Index) 
--
CREATE INDEX S2_STP ON SGAS.STUD_TRAV_PROG
(STUD_CRSE_YEAR_ID)
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
NOPARALLEL
/


-- 
-- Non Foreign Key Constraints for Table STUD_TRAV_PROG 
-- 
ALTER TABLE SGAS.STUD_TRAV_PROG ADD (
  CONSTRAINT STUD_TRAV_PROG_PK
 PRIMARY KEY
 (STUD_CRSE_YEAR_ID))
/

CREATE OR REPLACE TRIGGER SGAS.STTRAV_UD
 AFTER
 INSERT OR DELETE OR UPDATE OF DATE_ASSESSED
 ON SGAS.STUD_TRAV_PROG  REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
DECLARE
    P_TABLE_NAME         VARCHAR2(32)         := 'STUD_TRAV_PROG';
    P_COLUMN_NAME       VARCHAR2(32)        := NULL;
    P_OLD            STUD_AUD.OLD%TYPE        := NULL;
    P_ACTION        STUD_AUD.ACTION%TYPE        := NULL;
    P_NEW            STUD_AUD.NEW%TYPE        := NULL;
    P_STUD_REF_NO        STUD_AUD.STUD_REF_NO%TYPE    := :OLD.STUD_REF_NO;

BEGIN
P_ACTION    := 'U';
IF INSERTING THEN
    P_STUD_REF_NO := :NEW.STUD_REF_NO;
    Telephony_Support.UPDATE_TELE(P_STUD_REF_NO, P_ACTION, P_TABLE_NAME);
ELSIF UPDATING THEN
    P_COLUMN_NAME     := 'DATE_ASSESSED';
    P_OLD        := :OLD.DATE_ASSESSED;
    p_NEW        := :NEW.DATE_ASSESSED;
    IF NVL(:OLD.DATE_ASSESSED,'01/JAN/2000') <> NVL(:NEW.DATE_ASSESSED,'01/JAN/2000') THEN
        Telephony_Support.UPDATE_TELE(P_STUD_REF_NO, P_ACTION, P_TABLE_NAME);
    END IF;
END IF;
END STTRAV_UD;
/

--
-- Administer grants
--
GRANT SELECT ON SGAS.STUD_TRAV_PROG TO PUBLIC
/

--
-- STUD_TRAV_PROG  (Materialized View Log)
--
DROP SNAPSHOT LOG ON STUD_TRAV_PROG
/
--
-- STUD_TRAV_PROG  (Materialized View Log) 
--
CREATE MATERIALIZED VIEW LOG ON STUD_TRAV_PROG
TABLESPACE USERS
PCTUSED    0
PCTFREE    60
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOPARALLEL
WITH ROWID, SEQUENCE
INCLUDING NEW VALUES
/