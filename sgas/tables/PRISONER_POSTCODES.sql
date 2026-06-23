-- PRISONER_POSTCODES
-- Description: Reference Data table holding the postcodes of all UK prisons. 
--   
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 001      30.09.09    A.Bowman (SAAS)         Initial Version.
-- 002      01.10.09    A.Bowman (SAAS)         Added data
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date: $
-- $Revision: $
--

DROP TABLE SGAS.PRISONER_POSTCODES CASCADE CONSTRAINTS PURGE
/

CREATE TABLE SGAS.PRISONER_POSTCODES
(
  postcode      VARCHAR2(8 BYTE) CONSTRAINT NN_PR_POSTCODE NOT NULL,
  last_updated_by  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_PR_LAST_UPDATED_BY NOT NULL,
  last_updated_On  DATE DEFAULT Sysdate CONSTRAINT NN_PR_LAST_UPDATED_ON NOT NULL
)
TABLESPACE USERS
PCTUSED    40
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          42000K
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


COMMENT ON COLUMN SGAS.prisoner_postcodes.postcode IS 'Unique Postcode for a prison in the UK';


--
-- PR_P  (Index) 
--
CREATE UNIQUE INDEX pr_p ON SGAS.prisoner_postcodes
(postcode)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          42000K
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
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM prisoner_postcodes
/
CREATE PUBLIC SYNONYM prisoner_postcodes FOR sgas.prisoner_postcodes
/

--
-- INSERT DATA
--
INSERT INTO PRISONER_POSTCODES
            (postcode
            )
     VALUES ('AB11 8FN' 
            );
INSERT INTO PRISONER_POSTCODES
            (postcode
            )
     VALUES ('G33 2QX' 
            );
INSERT INTO PRISONER_POSTCODES
            (postcode
            )
     VALUES ('DD2 5HL' 
            );
INSERT INTO PRISONER_POSTCODES
            (postcode
            )
     VALUES ('FK9 5NU' 
            );
INSERT INTO PRISONER_POSTCODES
            (postcode
            )
     VALUES ('DG2 9AX' 
            );
INSERT INTO PRISONER_POSTCODES
            (postcode
            )
     VALUES ('EH11 3LN' 
            );
INSERT INTO PRISONER_POSTCODES
            (postcode
            )
     VALUES ('FK10 3AD' 
            );
INSERT INTO PRISONER_POSTCODES
            (postcode
            )
     VALUES ('PA16 9AH' 
            );
INSERT INTO PRISONER_POSTCODES
            (postcode
            )
     VALUES ('IV2 3HH' 
            );
INSERT INTO PRISONER_POSTCODES
            (postcode
            )
     VALUES ('KA1 5AA' 
            );
INSERT INTO PRISONER_POSTCODES
            (postcode
            )
     VALUES ('DD8 3QY' 
            );
INSERT INTO PRISONER_POSTCODES
            (postcode
            )
     VALUES ('PH2 8AT' 
            );
INSERT INTO PRISONER_POSTCODES
            (postcode
            )
     VALUES ('AB42 2YY' 
            );
INSERT INTO PRISONER_POSTCODES
            (postcode
            )
     VALUES ('FK2 0AB' 
            );
INSERT INTO PRISONER_POSTCODES
            (postcode
            )
     VALUES ('ML7 4LE' 
            );

COMMIT ;