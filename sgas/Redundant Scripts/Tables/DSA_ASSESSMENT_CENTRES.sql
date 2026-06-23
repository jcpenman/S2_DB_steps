-- 
-- dsa_assessment_centres.sql - create table script.
--
-- DESCRIPTION
-- dsa_assessment_centres records information on dsa assessment suppliers.
-- (Initial version - currently only the name is held.)
-- 
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc. 
--            12.02.08   S Durkin (Sopra UK)         Initial Version. 
--    
-- TODO:  
--
-- 
-- Configuration Management: 
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/DSA_ASSESSMENT_CENTRES.sql $ 
-- $Author: $ 
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $ 
-- $Revision: 3341 $ 

ALTER TABLE SGAS.dsa_assessment_centres
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_assessment_centres CASCADE CONSTRAINTS
/

--
-- dsa_assessment_centre  (Table) 
--
CREATE TABLE SGAS.dsa_assessment_centres
(
    id            NUMBER(10) CONSTRAINT nn_dac_id NOT NULL,
    centre_name   VARCHAR2(100),
    last_updated_by  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_DAC_LAST_UPDATED_BY NOT NULL,
    last_updated_on  DATE DEFAULT Sysdate CONSTRAINT NN_DAC_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1000K
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
COMMENT ON COLUMN SGAS.dsa_assessment_centres.id IS 'Assessment centre unique system identifier'
/
COMMENT ON COLUMN SGAS.dsa_assessment_centres.centre_name IS 'Assessment centre name. Contact details are not currently stored?'
/

--
-- Indexing
--
CREATE UNIQUE INDEX P_DAC ON SGAS.dsa_assessment_centres
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
ALTER TABLE SGAS.dsa_assessment_centres ADD (
    CONSTRAINT P_DAC
    PRIMARY KEY (id)
    USING INDEX
)
/
