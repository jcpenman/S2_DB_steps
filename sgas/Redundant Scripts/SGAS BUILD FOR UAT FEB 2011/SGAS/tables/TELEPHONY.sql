-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            28.02.08   S Durkin (Sopra UK)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/TELEPHONY.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $


DROP TABLE SGAS.TELEPHONY CASCADE CONSTRAINTS
/

--
-- TELEPHONY  (Table) 
--
CREATE TABLE SGAS.TELEPHONY
(
  STUD_REF_NO  NUMBER(10),
  REC_STATUS   VARCHAR2(1 BYTE),
  LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_TEL_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_TEL_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          500K
            NEXT             506K
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
-- Administer grants
--
GRANT INSERT ON SGAS.TELEPHONY TO PUBLIC
/
GRANT DELETE ON SGAS.TELEPHONY TO PUBLIC
/
GRANT SELECT ON SGAS.TELEPHONY TO PUBLIC
/
GRANT UPDATE ON SGAS.TELEPHONY TO PUBLIC
/
