-- TABLE: PAYMENT_REPORT_ARCHIVE 
-- Description: TABLE HOLDING PAYMENT REPORT DATA
-- 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                 Desc.
-- 1.0      05.06.09    A.Bowman (SAAS)        Initial Version.
--
--
-- Configuration Management:
-- $HeadURL: $
-- $Author: $
-- $Date: $
-- $Revision: $

DROP TABLE PAYMENT_REPORT_ARCHIVE CASCADE CONSTRAINTS PURGE
/

--
-- PAYMENT_REPORT_ARCHIVE  (Table) 
--
CREATE TABLE PAYMENT_REPORT_ARCHIVE
(
  PROVIDER_ID                      NUMBER(10) NOT NULL,
  BACS_RUN_ID                      NUMBER NOT NULL,                    
  BACS_RUN_DATE                    DATE NOT NULL,
  PRE_RUN_BALANCE                  NUMBER(10) NOT NULL,
  POST_RUN_BALANCE                 NUMBER(10) NOT NULL,
  SESSION_YEAR                     VARCHAR2(4 BYTE) NOT NULL,
  ILAREFNUM                        VARCHAR2(10 BYTE) NOT NULL,
  FORENAME                         VARCHAR2(25 BYTE) NOT NULL,
  SURNAME                          VARCHAR2(25 BYTE) NOT NULL,
  DOB                              DATE NOT NULL,
  COURSE_LEVEL                     VARCHAR2(80 BYTE) NOT NULL,
  COURSE_TYPE                      VARCHAR2(20 BYTE) NOT NULL,
  CURRENT_COURSE_YEAR              NUMBER NOT NULL,
  FEES_AWARDED                     NUMBER NOT NULL,
  FEE_PAYMENT_DATE                 DATE NOT NULL,
  STATUS                           VARCHAR2(20 BYTE) NOT NULL,
  TOTAL_PAYABLE                    NUMBER(10) NOT NULL
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

 

GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  PAYMENT_REPORT_ARCHIVE  TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM PAYMENT_REPORT_ARCHIVE 
/

CREATE PUBLIC SYNONYM PAYMENT_REPORT_ARCHIVE FOR ILA500.PAYMENT_REPORT_ARCHIVE
/