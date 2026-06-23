-- LOA_REASON_CODE.sql
-- Description: This table is used to store the LOA reason codes which will be populated by Institutions in the Attendance Data files
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      02.06.11    A.Bowman (SAAS)         Initial Version.
-- 
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.LOA_REASON_CODE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.LOA_REASON_CODE CASCADE CONSTRAINTS PURGE
/
--
-- LOA_REASON_CODE  (Table) 
--
CREATE TABLE sgas.LOA_REASON_CODE
(
  loa_reason_code                  VARCHAR2(4 BYTE) NOT NULL,
  loa_reason_description           VARCHAR2(200 BYTE) NOT NULL,
  last_updated_by                  VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  last_updated_on                  DATE                     DEFAULT SYSDATE               NOT NULL
)
TABLESPACE users
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING
NOCOMPRESS
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX LOA_REASON_CODE_PK ON sgas.LOA_REASON_CODE
(LOA_REASON_CODE)
LOGGING
TABLESPACE users
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64 k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ALTER TABLE sgas.LOA_REASON_CODE ADD (
  CONSTRAINT LOA_REASON_CODE_PK
 PRIMARY KEY
 (LOA_REASON_CODE)
    USING INDEX
    TABLESPACE users
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64 k
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
               ));



-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM LOA_REASON_CODE
/
CREATE PUBLIC SYNONYM LOA_REASON_CODE FOR sgas.LOA_REASON_CODE
/
                                                                        
--
-- INSERT DATA
--

INSERT INTO LOA_REASON_CODE
            (loa_reason_code, loa_reason_description 
            )
     VALUES ('MLOA', 'Leave of absence/suspension for medical grounds'  
            );

INSERT INTO LOA_REASON_CODE
            (loa_reason_code, loa_reason_description 
            )
     VALUES ('CARE', 'Leave of absence/suspension for caring reasons'  
            );


COMMIT ;