-- 
-- dsa_arrangements.sql - create table script.
--
-- DESCRIPTION
-- dsa_arrangements record the arrangements made between a student and the nominee (where the nominee may be the 
-- student themselves). 
-- Initial version:
-- These arrangements represent the implementation of the approvals from an assessment though it is possible that some 
-- arrangements may cover items not specifically raised in an assessment - the link to approvals is therefore not mandatory.
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            12.02.08   S Durkin (Sopra UK)         Initial Version.
--  
-- TODO: 
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/DSA_ARRANGEMENTS.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $

ALTER TABLE SGAS.dsa_arrangements
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_arrangements CASCADE CONSTRAINTS
/

--
-- dsa_arrangements  (Table) 
--
CREATE TABLE SGAS.dsa_arrangements
(
    id            NUMBER(10) CONSTRAINT nn_dar_id NOT NULL,
    stud_ref_no   NUMBER(10) CONSTRAINT nn_dar_stud_ref_no NOT NULL,
    nominee_id    NUMBER(10),
    award_type    NUMBER(10) CONSTRAINT nn_dar_award_type NOT NULL,
    description   VARCHAR2(4000),
    last_updated_by  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_DAR_LAST_UPDATED_BY NOT NULL,
    last_updated_on  DATE DEFAULT Sysdate CONSTRAINT NN_DAR_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          200K
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
COMMENT ON COLUMN SGAS.dsa_arrangements.id  IS 'DSA arrangements, unique system identifier.'
/
COMMENT ON COLUMN SGAS.dsa_arrangements.stud_ref_no  IS 'DSA category unique identifier. E.G. "NT" : Note Taking'
/
COMMENT ON COLUMN SGAS.dsa_arrangements.nominee_id IS 'Unique identifier of the DSA nominee.'
/
COMMENT ON COLUMN SGAS.dsa_arrangements.award_type IS 'Internal reference to the DSA type.'
/
COMMENT ON COLUMN SGAS.dsa_arrangements.description   IS 'Free text description of the DSA arrangement, if required.'
/

--
-- Indexes 
--
CREATE UNIQUE INDEX s1_id ON SGAS.dsa_arrangements
(ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          300K
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
-- Constraints 
-- 
-- SD. Remove this constraint - a student & nominee may have more than one arrangemnet set up.
-- ALTER TABLE dsa_arrangements ADD (
    -- CONSTRAINT p_dar 
    -- PRIMARY KEY (stud_ref_no, nominee_id)
-- )
-- /

ALTER TABLE SGAS.dsa_arrangements ADD (
    CONSTRAINT f_dar_srn
    FOREIGN KEY (stud_ref_no) 
    REFERENCES stud (stud_ref_no)
    ON DELETE CASCADE
)
/

ALTER TABLE SGAS.dsa_arrangements ADD (
    CONSTRAINT f_dar_nom
    FOREIGN KEY (nominee_id) 
    REFERENCES nominees (nominee_id)
    ON DELETE CASCADE
)
/

ALTER TABLE SGAS.dsa_arrangements ADD (
    CONSTRAINT f_dar_dma
    FOREIGN KEY (award_type) 
    REFERENCES dsa_max_awards (id)
    ON DELETE CASCADE
)
/

ALTER TABLE SGAS.dsa_arrangements ADD (
    CONSTRAINT p_dar
    PRIMARY KEY(id)
)
/