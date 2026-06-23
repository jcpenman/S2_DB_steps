-- 
-- dsa_assessments.sql - create table script.
--
-- DESCRIPTION
-- dsa_assessments records information related to a dsa assessment - name and invoice details. 
-- 
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            12.02.08   S Durkin (Sopra UK)         Initial Version.
--  
-- TODO: 
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/DSA_ASSESSMENTS.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $

ALTER TABLE SGAS.dsa_assessments
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_assessments CASCADE CONSTRAINTS
/

--
-- dsa_assessments  (Table) 
--
CREATE TABLE SGAS.dsa_assessments
(
    id            NUMBER(10) CONSTRAINT nn_das_id NOT NULL,
    centre_id     NUMBER(10),
    casenote_id       NUMBER(10),
    invoice_ref   VARCHAR2(40),
    date_paid     DATE,
    amount        NUMBER(7,2),
    last_updated_by  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_DAS_LAST_UPDATED_BY NOT NULL,
    last_updated_on  DATE DEFAULT Sysdate CONSTRAINT NN_DAS_LAST_UPDATED_ON NOT NULL
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
COMMENT ON COLUMN SGAS.dsa_assessments.id IS 'Assessment unique system identifier'
/
COMMENT ON COLUMN SGAS.dsa_assessments.invoice_ref IS 'Invoice reference from assessment centre may be alphanumeric.'
/
COMMENT ON COLUMN SGAS.dsa_assessments.date_paid IS 'Date invoice was paid.'
/
COMMENT ON COLUMN SGAS.dsa_assessments.amount IS 'Fee payable to assessment centre for assessment.'
/
COMMENT ON COLUMN SGAS.dsa_assessments.date_paid IS 'Date invoice was paid.' -- Held here as non-fee types are not to be paid through the student awards system.
/
COMMENT ON COLUMN SGAS.dsa_assessments.centre_id IS 'Assessment centre ID.'
/
COMMENT ON COLUMN SGAS.dsa_assessments.casenote_id IS 'System casenotes reference - ID.'
/

--
-- Indexing
--
CREATE UNIQUE INDEX p_das ON SGAS.dsa_assessments
(invoice_ref, id)
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
-- Indexing
--
CREATE UNIQUE INDEX p_das_id ON SGAS.dsa_assessments
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
ALTER TABLE SGAS.dsa_assessments ADD (
    CONSTRAINT p_das_id
    PRIMARY KEY (id)
    USING INDEX
)
/

ALTER TABLE SGAS.dsa_assessments ADD (
    CONSTRAINT f_centre_id
    FOREIGN KEY ( centre_id )
    REFERENCES dsa_assessment_centres(id)
    ON DELETE CASCADE
)
/

ALTER TABLE SGAS.dsa_assessments ADD (
    CONSTRAINT f_casenote_id
    FOREIGN KEY ( casenote_id )
    REFERENCES dsa_casenotes(id)
    ON DELETE CASCADE
)
/