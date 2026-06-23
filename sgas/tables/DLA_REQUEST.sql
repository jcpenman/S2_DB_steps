-- DLA_REQUEST.sql
-- Description: Table will be used to hold the details of duplicate award notice
--              requests which are transferred from the web database.
--
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      09.07.09    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

DROP TABLE SGAS.DLA_REQUEST CASCADE CONSTRAINTS
/

--
-- DLA_REQUEST  (Table) 
--
CREATE TABLE SGAS.DLA_REQUEST
(
  STUD_CRSE_YEAR_ID      NUMBER(9) NOT NULL, 
  DATE_REQUESTED         DATE NOT NULL
 
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM DLA_REQUEST
/

CREATE PUBLIC SYNONYM DLA_REQUEST FOR SGAS.DLA_REQUEST
/



