-- 
-- dsa_types.sql - create table script.
--
-- DESCRIPTION
-- dsa_types holds the main categories of disability awards payable by SAAS, and the maximum values of awards 
-- for each category.
-- 
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            12.02.08   S Durkin (Sopra UK)         Initial Version.
--  
-- TODO: 
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/DSA_TYPES.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $

ALTER TABLE SGAS.dsa_types
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_types CASCADE CONSTRAINTS
/

--
-- dsa_types  (Table) 
--
CREATE TABLE SGAS.dsa_types
(
    id          NUMBER(10)     CONSTRAINT nn_dt_id NOT NULL,
    dsa_type    VARCHAR2(40)   CONSTRAINT nn_dt_type NOT NULL,
    description VARCHAR2(4000),
    start_date  DATE           CONSTRAINT nn_dt_start_date NOT NULL,
    end_date    DATE,
    last_updated_by  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_DT_LAST_UPDATED_BY NOT NULL,
    last_updated_on  DATE DEFAULT Sysdate CONSTRAINT NN_DT_LAST_UPDATED_ON NOT NULL
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
COMMENT ON COLUMN SGAS.dsa_types.id            IS 'DSA type unique identifier.'
/
COMMENT ON COLUMN SGAS.dsa_types.dsa_type      IS 'DSA type well known scheme name. (E.G. "BASIC" allowance)'
/
COMMENT ON COLUMN SGAS.dsa_types.description   IS 'Free text description of the DSA type.'
/
COMMENT ON COLUMN SGAS.dsa_types.start_date    IS 'Date from which the rate becomes effective.'
/
COMMENT ON COLUMN SGAS.dsa_types.end_date      IS 'Date at which rate is no longer valid.'
/

-- 
-- Cconstraints
-- 
ALTER TABLE SGAS.dsa_types ADD (
    CONSTRAINT P_DT 
    PRIMARY KEY (id)
)
/
