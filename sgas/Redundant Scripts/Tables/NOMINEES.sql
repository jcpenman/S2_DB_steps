-- 
-- nominees.sql - create table script.
--
-- DESCRIPTION
-- The nominees table holds details on nomineess for dsa awr
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
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/NOMINEES.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $

ALTER TABLE SGAS.nominees
 DROP PRIMARY KEY CASCADE
/

DROP TABLE SGAS.nominees CASCADE CONSTRAINTS
/

--
-- nominees  (Table) 
--
CREATE TABLE SGAS.nominees
(
    nominee_id  NUMBER(10) CONSTRAINT nn_nom_id NOT NULL,
    description VARCHAR2(4000),
    first_name      VARCHAR2(25),
    last_name       VARCHAR2(25) CONSTRAINT nn_nom_name NOT NULL,
    house_no_name   VARCHAR2(32),
    addr_l1         VARCHAR2(65),
    addr_l2         VARCHAR2(65),
    addr_l3         VARCHAR2(65),
    addr_l4         VARCHAR2(65),
    post_code       VARCHAR2(8),
    tele_no         VARCHAR2(15),
    start_date      DATE CONSTRAINT nn_nom_start_date NOT NULL,
    end_date        DATE,
    bank_name       VARCHAR2(25),
    account_no      VARCHAR2(10),
    sort_code       VARCHAR2(6),
    LAST_UPDATED_BY  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_NOM_LAST_UPDATED_BY NOT NULL,
    LAST_UPDATED_ON  DATE DEFAULT Sysdate CONSTRAINT NN_NOM_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          400K
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
COMMENT ON COLUMN SGAS.nominees.nominee_id    IS 'Unique system identifier for the nominees.'
/
COMMENT ON COLUMN SGAS.nominees.description   IS 'Free text description for notes on the nominees.'
/
COMMENT ON COLUMN SGAS.nominees.first_name    IS 'nominees first name'
/
COMMENT ON COLUMN SGAS.nominees.last_name     IS 'nominees last name (surname)'
/
COMMENT ON COLUMN SGAS.nominees.house_no_name IS 'nominees address details: House number or house name'
/
COMMENT ON COLUMN SGAS.nominees.addr_l1       IS 'nominees address details: line 1'
/
COMMENT ON COLUMN SGAS.nominees.addr_l2       IS 'nominees address details: line 2'
/
COMMENT ON COLUMN SGAS.nominees.addr_l3       IS 'nominees address details: line 3'
/
COMMENT ON COLUMN SGAS.nominees.addr_l4       IS 'nominees address details: line 4'
/
COMMENT ON COLUMN SGAS.nominees.post_code     IS 'nominees address details: Postcode'
/
COMMENT ON COLUMN SGAS.nominees.tele_no       IS 'nominees address details: Telehpone number'
/
COMMENT ON COLUMN SGAS.nominees.start_date    IS 'nominees start date - when nominees details were entered onto system.'
/
COMMENT ON COLUMN SGAS.nominees.end_date      IS 'nominees end date, after which these nominees details are no longer valid'
/
COMMENT ON COLUMN SGAS.nominees.bank_name     IS 'nominees bank details: bank name.'
/
COMMENT ON COLUMN SGAS.nominees.account_no    IS 'nominees bank details: account number.'
/
COMMENT ON COLUMN SGAS.nominees.account_no    IS 'nominees bank details: account number.'
/
COMMENT ON COLUMN SGAS.nominees.sort_code     IS 'nominees bank details: sort code.'
/

-- 
-- Cconstraints
-- 
ALTER TABLE SGAS.nominees ADD (
    CONSTRAINT p_nom
    PRIMARY KEY (nominee_id)
)
/

