-- REPEAT_YEAR_REASON_CODE.sql
-- Description: This table is used to store the repeat year reason codes which will be populated by Institutions in the Attendance Data files
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

ALTER TABLE sgas.REPEAT_YEAR_REASON_CODE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.REPEAT_YEAR_REASON_CODE CASCADE CONSTRAINTS PURGE
/
--
-- REPEAT_YEAR_REASON_CODE  (Table) 
--
CREATE TABLE sgas.REPEAT_YEAR_REASON_CODE
(
  reason_code                  VARCHAR2(4 BYTE) NOT NULL,
  reason_description           VARCHAR2(200 BYTE) NOT NULL,
  last_updated_by              VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  last_updated_on              DATE                     DEFAULT SYSDATE               NOT NULL
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


CREATE UNIQUE INDEX REPEAT_YEAR_REASON_CODE_PK ON sgas.REPEAT_YEAR_REASON_CODE
(REASON_CODE)
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

ALTER TABLE sgas.REPEAT_YEAR_REASON_CODE ADD (
  CONSTRAINT REPEAT_YEAR_REASON_CODE_PK
 PRIMARY KEY
 (REASON_CODE)
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
DROP PUBLIC SYNONYM REPEAT_YEAR_REASON_CODE
/
CREATE PUBLIC SYNONYM REPEAT_YEAR_REASON_CODE FOR sgas.REPEAT_YEAR_REASON_CODE
/
                                                                        
--
-- INSERT DATA
--

INSERT INTO REPEAT_YEAR_REASON_CODE (REASON_CODE, REASON_DESCRIPTION) 
VALUES 
('MED', 'Student is repeating the year on medical grounds');
 
INSERT INTO REPEAT_YEAR_REASON_CODE (REASON_CODE, REASON_DESCRIPTION) 
VALUES 
('COMP', 'Student is repeating the year on compassionate grounds'); 

INSERT INTO REPEAT_YEAR_REASON_CODE (REASON_CODE, REASON_DESCRIPTION) 
VALUES 
('ACAD', 'Student is repeating the year on academic grounds');  

INSERT INTO REPEAT_YEAR_REASON_CODE (REASON_CODE, REASON_DESCRIPTION) 
VALUES 
('RWA', 'Student is registered as full time but studying on a part time/part year basis'); 

INSERT INTO REPEAT_YEAR_REASON_CODE (REASON_CODE, REASON_DESCRIPTION)  
VALUES 
('PART', 'Student is a part time student'); 

INSERT INTO REPEAT_YEAR_REASON_CODE (REASON_CODE, REASON_DESCRIPTION)
VALUES 
('OTHR', 'Student is repeating the year for another reason'); 

COMMIT;





