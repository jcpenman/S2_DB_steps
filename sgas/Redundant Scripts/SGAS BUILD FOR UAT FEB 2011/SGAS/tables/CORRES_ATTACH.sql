-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            12.02.08   S Durkin (Sopra UK)         Initial Version.
-- 001      03.09.10    A.Bowman (SAAS)                         Added foreign key constraint which was missing from script
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/CORRES_ATTACH.sql $
-- $Author: $
-- $Date: 2010-09-03 10:58:37 +0100 (Fri, 03 Sep 2010) $
-- $Revision: 5627 $


DROP TABLE SGAS.CORRES_ATTACH CASCADE CONSTRAINTS
/

--
-- CORRES_ATTACH  (Table) 
--
CREATE TABLE SGAS.CORRES_ATTACH
(
  CORRES_ID   NUMBER(10) CONSTRAINT NN_COA_CORRES_ID NOT NULL,
  ATTACHMENT  LONG RAW CONSTRAINT NN_COA_ATTACHMENT NOT NULL,
  last_updated_by  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_COA_LAST_UPDATED_BY NOT NULL,
  last_updated_on  DATE DEFAULT Sysdate CONSTRAINT NN_COA_LAST_UPDATED_ON NOT NULL
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
-- S1_COA  (Index) 
--
CREATE INDEX S1_COA ON SGAS.CORRES_ATTACH
(CORRES_ID)
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

ALTER TABLE SGAS.CORRES_ATTACH ADD (
  CONSTRAINT F1_COA 
 FOREIGN KEY (CORRES_ID) 
 REFERENCES SGAS.CORRES (CORRES_ID));
