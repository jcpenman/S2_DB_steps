-- 
-- caseworker_locks.sql - create table script.
--
-- DESCRIPTION
-- caseworker_locks records details of locks placed on student records while a caseworker processes a specific student claim.
--  Student Ref ID
--  CaseWorker ID
--  Status
--  TTL
-- 
-- MODIFICATION HISTORY:
-- Ref      Date        Author         Desc.
-- 001      12.02.08    S Durkin       Initial Version.
-- 002      03.06.09    A.Bowman       Amended column name stud_ref_no to reference_id and added new column reference_id_type
--                                         
--  
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/CASEWORKER_LOCKS.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $

ALTER TABLE SGAS.CASEWORKER_LOCKS
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.CASEWORKER_LOCKS CASCADE CONSTRAINTS
/

--
-- CASEWORKER_LOCKS  (Table) 
--
CREATE TABLE SGAS.caseworker_locks
(
    reference_id       VARCHAR2(20) CONSTRAINT NN_CL_REFERENCE_ID NOT NULL,       -- Student Ref ID
    reference_id_type  VARCHAR2(20),
    caseworker_id      VARCHAR2(30) CONSTRAINT NN_CL_CASEWORKER_ID NOT NULL,   -- CaseWorker ID
    ttl                DATE CONSTRAINT NN_CL_TTL NOT NULL            -- Time To Live
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
-- Column comments
-- 
COMMENT ON COLUMN SGAS.CASEWORKER_LOCKS.reference_id   IS 'Unique identifier'
/
COMMENT ON COLUMN SGAS.CASEWORKER_LOCKS.caseworker_id IS 'Authenticated user id of the caseworker - must be supplied by application.'
/
COMMENT ON COLUMN SGAS.CASEWORKER_LOCKS.ttl           IS 'Time To Live - date and time by which the lock will expire.'
/

--
-- P_CL  (Index) 
--
CREATE UNIQUE INDEX P_CL ON SGAS.CASEWORKER_LOCKS
(reference_id, caseworker_id)
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
-- Other constraints
-- 
ALTER TABLE SGAS.CASEWORKER_LOCKS ADD (
    CONSTRAINT P_CL 
    PRIMARY KEY (REFERENCE_ID, CASEWORKER_ID)
    USING INDEX
)
/
