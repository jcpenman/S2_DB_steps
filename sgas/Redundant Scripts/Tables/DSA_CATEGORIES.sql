-- 
-- dsa_categories.sql - create table script.
--
-- DESCRIPTION
-- dsa_categories holds sub categories of disability awards payable by SAAS. 
-- Intial version: These largely apply to the BASIC allowance. 
-- Note: These have not been modelled as sub-categories of the DSA types as the DSA office want to maintain the flexibility to assign 
-- any code to any DSA_TYPE.
-- 
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            12.02.08   S Durkin (Sopra UK)         Initial Version.
--  
-- TODO: 
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/DSA_CATEGORIES.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $

ALTER TABLE SGAS.dsa_categories
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_categories CASCADE CONSTRAINTS
/

--
-- dsa_categories  (Table) 
--
CREATE TABLE SGAS.dsa_categories
(
    id            NUMBER(10) CONSTRAINT nn_dcat_id NOT NULL,
    default_type  NUMBER(10),
    short_name    VARCHAR2(15) CONSTRAINT nn_dcat_ref NOT NULL,
    category_name VARCHAR2(100) CONSTRAINT nn_dcat_name NOT NULL,
    description   VARCHAR2(4000),
    last_updated_by  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_DCAT_LAST_UPDATED_BY NOT NULL,
    last_updated_on  DATE DEFAULT Sysdate CONSTRAINT NN_DCAT_LAST_UPDATED_ON NOT NULL
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
COMMENT ON COLUMN SGAS.dsa_categories.id            IS 'DSA category unique identifier.'
/
COMMENT ON COLUMN SGAS.dsa_categories.default_type  IS 'Default allowance type to which category applies. The allowance type is not generally enforced.'
/
COMMENT ON COLUMN SGAS.dsa_categories.short_name  IS 'DSA category. E.G. "NT".'
/
COMMENT ON COLUMN SGAS.dsa_categories.category_name IS 'DSA type well known scheme name for display. E.G. Note Taking'
/
COMMENT ON COLUMN SGAS.dsa_categories.description   IS 'Free text description of the DSA category, if required.'
/

--
-- Constraints
--
ALTER TABLE SGAS.dsa_categories ADD (
    CONSTRAINT p_dcat 
    PRIMARY KEY (id)
)
/

CREATE UNIQUE INDEX s_dcat ON SGAS.dsa_categories
(short_name)
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

ALTER TABLE SGAS.dsa_categories ADD (
    CONSTRAINT f_dt
    FOREIGN KEY (default_type)
    REFERENCES dsa_types(id)
    ON DELETE CASCADE
)
/
