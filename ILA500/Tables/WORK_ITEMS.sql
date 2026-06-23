-- TABLE: WORK_ITEMS 
-- Description: TABLE HOLDING WORK ITEM DATA
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                 Desc.
-- 1.0      08.06.09    A.Bowman (SAAS)        Initial Version.
--
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date: $
-- $Revision: $

DROP TABLE WORK_ITEMS CASCADE CONSTRAINTS PURGE
/

--
-- WORK_ITEMS  (Table) 
--

CREATE TABLE WORK_ITEMS
(
  OBJECT_REFERENCE                 VARCHAR2(10 BYTE),
  OBJECT_NAME                      VARCHAR2(60 BYTE),
  OBJECT_TYPE                      VARCHAR2(10 BYTE),
  WORK_ITEM_TYPE                   VARCHAR2(25 BYTE),
  DATE_RECEIVED                    DATE,
  DATE_DUE                         DATE,
  TASK_STATUS                      VARCHAR2(25 BYTE),
  ACCEPTED_BY                      VARCHAR2(50 BYTE)
  )
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
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

 

GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON WORK_ITEMS TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM WORK_ITEMS 
/

CREATE PUBLIC SYNONYM WORK_ITEMS FOR ILA500.WORK_ITEMS 
/