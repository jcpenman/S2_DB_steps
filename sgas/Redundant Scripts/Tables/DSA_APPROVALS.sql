-- 
-- dsa_approvals.sql - create table script.
--
-- DESCRIPTION
-- dsa_approvals records information related to a student applying for disability allowance.
-- The table will record the nature of the disability, and free-text notes from the caseworker.
-- 
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            12.02.08   S Durkin (Sopra UK)         Initial Version.
--  
-- TODO: 
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/DSA_APPROVALS.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $

ALTER TABLE SGAS.dsa_approvals
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_approvals CASCADE CONSTRAINTS
/

--
-- dsa_approvals  (Table) 
--
CREATE TABLE SGAS.dsa_approvals
(
    id          NUMBER(10) CONSTRAINT nn_dap_id NOT NULL,
    dsa_type_id NUMBER(10) CONSTRAINT nn_dap_type NOT NULL,
    category_id NUMBER(10)  CONSTRAINT nn_dap_category NOT NULL,
    assessment_id NUMBER(10) CONSTRAINT nn_dap_assessment NOT NULL,
    notes       VARCHAR2(4000),
    amount      NUMBER(7,2) CONSTRAINT nn_dap_amount NOT NULL,
    last_updated_by  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_DAP_LAST_UPDATED_BY NOT NULL,
    last_updated_on  DATE DEFAULT Sysdate CONSTRAINT NN_DAP_LAST_UPDATED_ON NOT NULL
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
COMMENT ON COLUMN SGAS.dsa_approvals.id IS 'Approvals unique internal identifier'
/
COMMENT ON COLUMN SGAS.dsa_approvals.dsa_type_id IS 'System reference to DSA TYPE'
/
COMMENT ON COLUMN SGAS.dsa_approvals.category_id IS 'System reference to approval category.'
/
COMMENT ON COLUMN SGAS.dsa_approvals.assessment_id IS 'System reference to the DSA assessment.'
/
COMMENT ON COLUMN SGAS.dsa_approvals.notes IS 'Free text notes from the caseworker on approval details, if required.'
/
COMMENT ON COLUMN SGAS.dsa_approvals.amount IS 'Monetary value of recommended award. Note that this figure is a assessment for reporting purposes and does not directly affect the award payable. This is affected by the DSA Type max.'
/

--
-- P_CL  (Index) 
--
CREATE UNIQUE INDEX p_dsa ON SGAS.dsa_approvals
(id)
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
ALTER TABLE SGAS.dsa_approvals ADD (
    CONSTRAINT p_dsa 
    PRIMARY KEY (id)
    USING INDEX
)
/

ALTER TABLE SGAS.dsa_approvals ADD (
    CONSTRAINT f_assessment_id
    FOREIGN KEY ( assessment_id )
    REFERENCES dsa_assessments(id)
    ON DELETE CASCADE
)
/
