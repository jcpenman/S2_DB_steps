-- 
-- dsa_casenotes.sql - create table script.
--
-- DESCRIPTION
-- dsa_casenotes records information related to a student applying for disability allowance.
-- The table will record the nature of the disability, and free-text notes from the caseworker.
-- 
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            12.02.08   S Durkin (Sopra UK)         Initial Version.
--  
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/DSA_CASENOTES.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $

ALTER TABLE SGAS.dsa_casenotes
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.dsa_casenotes CASCADE CONSTRAINTS
/

--
-- dsa_casenotes  (Table) 
--
CREATE TABLE SGAS.dsa_casenotes
(
    id              NUMBER(10) CONSTRAINT nn_dc_dsa_casenotes_id NOT NULL,
    stud_session_id NUMBER(9)  CONSTRAINT nn_dc_stud_session_id NOT NULL,
    disability_code NUMBER(10)  CONSTRAINT nn_dc_disability_code NOT NULL,
    notes           VARCHAR2(4000),
    last_updated_by  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_DC_LAST_UPDATED_BY NOT NULL,
    last_updated_on  DATE DEFAULT Sysdate CONSTRAINT NN_DC_LAST_UPDATED_ON NOT NULL
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
COMMENT ON COLUMN SGAS.dsa_casenotes.id   IS 'Casenotes unique identifier'
/
COMMENT ON COLUMN SGAS.dsa_casenotes.stud_session_id IS 'Reference to current student session details.'
/
COMMENT ON COLUMN SGAS.dsa_casenotes.disability_code IS 'Disability type.'
/
COMMENT ON COLUMN SGAS.dsa_casenotes.notes           IS 'Free text notes from the caseworker.'
/

--
-- P_CL  (Index) 
--
CREATE UNIQUE INDEX p_dc ON SGAS.dsa_casenotes
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
ALTER TABLE SGAS.dsa_casenotes ADD (
    CONSTRAINT p_dc
    PRIMARY KEY (id)
    USING INDEX
)
/

ALTER TABLE SGAS.dsa_casenotes ADD (
 CONSTRAINT f_stud_session 
FOREIGN KEY (stud_session_id) 
REFERENCES stud_session (stud_session_id))
/

ALTER TABLE SGAS.dsa_casenotes ADD (
 CONSTRAINT f_disability_code
FOREIGN KEY (disability_code) 
REFERENCES reference_data (id))
/
