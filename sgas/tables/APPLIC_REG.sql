-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      24.09.09    A.Bowman (SAAS)         Removed redundant column EMPLOYEE
-- 1.1      09.08.10    A.Bowman (SAAS)         Added primary_key and sequence
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/APPLIC_REG.sql $
-- $Author: $
-- $Date: 2010-08-09 15:18:41 +0100 (Mon, 09 Aug 2010) $
-- $Revision: 5552 $


DROP TABLE SGAS.APPLIC_REG CASCADE CONSTRAINTS PURGE
/

--
-- APPLIC_REG  (Table) 
--
CREATE TABLE SGAS.APPLIC_REG
(
  APPLIC_REG_ID  NUMBER(10) NOT NULL,
  STUD_REF_NO    NUMBER(10) CONSTRAINT NN_APR_STUD_REF_NO NOT NULL,
  DOC_TYPE_ID    NUMBER(4),
  RECEIVED_DATE  DATE CONSTRAINT NN_APR_RECEIVED_DATE NOT NULL,
  SESSION_CODE   NUMBER(4) CONSTRAINT NN_APR_SESSION_CODE NOT NULL,
  RETURNED_DATE  DATE,
  DOCUMENT_TYPE  VARCHAR2(100 BYTE),
  last_updated_by  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_APR_LAST_UPDATED_BY NOT NULL,
  last_updated_on  DATE DEFAULT Sysdate CONSTRAINT NN_APR_LAST_UPDATED_ON NOT NULL
)

TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
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
-- S1_APR  (Index) 
--
CREATE INDEX S1_APR ON SGAS.APPLIC_REG
(APPLIC_REG_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S2_APR  (Index) 
--
CREATE INDEX S2_APR ON SGAS.APPLIC_REG
(STUD_REF_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- S3_APR  (Index) 
--
CREATE INDEX S3_APR ON SGAS.APPLIC_REG
(DOC_TYPE_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
            MINEXTENTS       1
            MAXEXTENTS       99
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

ALTER TABLE SGAS.APPLIC_REG ADD (
  CONSTRAINT APPLIC_REG_PK
 PRIMARY KEY
 (APPLIC_REG_ID)
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

--#APPLIC_REG.APPLIC_REG_ID SEQUENCE###############################
DROP SEQUENCE SGAS.APPLIC_REG_ID_SEQ;

CREATE SEQUENCE SGAS.APPLIC_REG_ID_SEQ
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


GRANT SELECT ON  SGAS.APPLIC_REG_ID_SEQ TO PUBLIC;

CREATE OR REPLACE TRIGGER SGAS.trig_applic_reg_seq
   BEFORE INSERT
   ON SGAS.APPLIC_REG    FOR EACH ROW
BEGIN
   SELECT applic_reg_id_seq.NEXTVAL
     INTO :NEW.applic_reg_id
     FROM DUAL;
END;
/
