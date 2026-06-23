-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- Modification History
-- Date               Ref    Desc
-- 14/01/2008 0     Initial Version. Steve Durkin
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/TELEPHONY_MIS.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $


DROP TABLE SGAS.TELEPHONY_MIS CASCADE CONSTRAINTS
/

--
-- TELEPHONY_MIS  (Table) 
--
CREATE TABLE SGAS.TELEPHONY_MIS
(
  STUD_REF_NO   NUMBER(10)                      NOT NULL,
  START_TIME    DATE                            NOT NULL,
  END_TIME      DATE                            NOT NULL,
  SERVICE_CODE  VARCHAR2(1 BYTE)                NOT NULL,
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_TM_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_TM_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          100K
            NEXT             100K
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
-- S_TEMI  (Index) 
--
CREATE UNIQUE INDEX S_TEMI ON SGAS.TELEPHONY_MIS
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
-- Administer grants
--
GRANT INSERT ON SGAS.TELEPHONY_MIS TO PUBLIC
/
GRANT SELECT ON SGAS.TELEPHONY_MIS TO PUBLIC
/
