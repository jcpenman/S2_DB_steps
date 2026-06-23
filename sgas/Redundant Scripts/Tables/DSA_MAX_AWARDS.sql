-- 
-- dsa_max_awards.sql - create table script.
--
-- DESCRIPTION
-- dsa_max_awards details the maximum award payable for each dsa_type under each graduate scheme.
-- 
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            12.02.08   S Durkin (Sopra UK)         Initial Version.
--  
-- TODO: 
--
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/DSA_MAX_AWARDS.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $

ALTER TABLE SGAS.dsa_max_awards
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_max_awards CASCADE CONSTRAINTS
/

--
-- dsa_types  (Table) 
--
CREATE TABLE SGAS.dsa_max_awards
(
    id          NUMBER(10)     CONSTRAINT nn_dma_id NOT NULL,
    dsa_type    NUMBER(10)   CONSTRAINT nn_dma_dsa_type NOT NULL,
    stud_type   VARCHAR2(40)   CONSTRAINT nn_dma_stud_type NOT NULL,
    max_value   NUMBER(7,2)    CONSTRAINT nn_dma_value NOT NULL,
    description VARCHAR2(4000),
    start_date  DATE           CONSTRAINT nn_dma_start_date NOT NULL,
    end_date    DATE,
    last_updated_by  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_DMA_LAST_UPDATED_BY NOT NULL,
    last_updated_on  DATE DEFAULT Sysdate CONSTRAINT NN_DMA_LAST_UPDATED_ON NOT NULL
)
/

--
-- Column comments
-- 
COMMENT ON COLUMN SGAS.dsa_max_awards.id            IS 'DSA type unique identifier.'
/
COMMENT ON COLUMN SGAS.dsa_max_awards.dsa_type      IS 'DSA type well known scheme name. (E.G. "BASIC" allowance)'
/
COMMENT ON COLUMN SGAS.dsa_max_awards.stud_type     IS 'DSA STUD type is based on the student scheme. E.g. under grad/post grad.'
/
COMMENT ON COLUMN SGAS.dsa_max_awards.max_value     IS 'Maximum monetary value of award payable under this award type.'
/
COMMENT ON COLUMN SGAS.dsa_max_awards.description   IS 'Free text description of the DSA award limit, if required.'
/
COMMENT ON COLUMN SGAS.dsa_max_awards.start_date    IS 'Date from which the rate becomes effective.'
/
COMMENT ON COLUMN SGAS.dsa_max_awards.end_date      IS 'Date at which rate is no longer valid.'
/

-- 
-- Cconstraints
-- 
ALTER TABLE SGAS.dsa_max_awards ADD (
    CONSTRAINT p_dma 
    PRIMARY KEY (id)
)
/

ALTER TABLE SGAS.dsa_max_awards ADD (
    CONSTRAINT f_dma
    FOREIGN KEY (dsa_type)
    REFERENCES dsa_types (id)
    ON DELETE CASCADE
)
/
