-- STD_LETTERS_CATEGORIES.sql
-- Description: Holds shell letter categories
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date            Author                  Desc.
-- 1.0      20.05.2011      A.Bowman (SAAS)         Initial Version.



ALTER TABLE SGAS.STD_LETTERS_CATEGORIES
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.STD_LETTERS_CATEGORIES CASCADE CONSTRAINTS PURGE
/

--
-- STD_LETTERS_CATEGORIES  (Table) 
--

CREATE TABLE SGAS.STD_LETTERS_CATEGORIES
(
  CAT_CODE               VARCHAR2(5 BYTE) NOT NULL,
  CAT_DESCRIPTION        VARCHAR2(30)
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
MONITORING;


CREATE UNIQUE INDEX STD_LETTERS_CATEGORIES_PK ON SGAS.STD_LETTERS_CATEGORIES
(CAT_CODE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE STD_LETTERS_CATEGORIES ADD (
  CONSTRAINT STD_LETTERS_CATEGORIES_PK
 PRIMARY KEY
 (CAT_CODE)
    USING INDEX 
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));


-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM STD_LETTERS_CATEGORIES
/

CREATE PUBLIC SYNONYM STD_LETTERS_CATEGORIES FOR SGAS.STD_LETTERS_CATEGORIES
/

--
-- INSERT DATA
--

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('ABR', 'Abroad'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('APP', 'Application'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('BLA', 'Blank'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('COUR', 'Course'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('CURIN', 'Current Income'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('DEP', 'Dependants'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('DTH', 'Death'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('DSA', 'Disabled Student Application'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('EH', 'UK Returner'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('EU', 'European Student'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('EXE', 'Exempt'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('INT', 'Internal'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('ISB', 'Independant Student'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('LOAN', 'Student Loan'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('LP', 'Loan Parent'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('MGR', 'Migrant'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('NMSB', 'Nursing'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('OTH', 'Other'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('OVRP', 'Over Payment'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('PG', 'Post Graduate'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('REA', 'Student Abroad'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('REE', 'Endowment Search'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('REP', 'Repeat Year'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('RES', 'Residence'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('STUDI', 'Student Income'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('TRAV', 'Travel'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('WITH', 'Withdrawn'
            );

INSERT INTO STD_LETTERS_CATEGORIES
            (CAT_CODE, CAT_DESCRIPTION
            )
     VALUES ('Z0', 'Refusal'
            );

commit;