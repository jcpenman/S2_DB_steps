-- LEARNER.sql
-- Description: Table holding all learners who have applied for ILA500
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      27.05.08    R Hunter (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/ILA500/BT%20Releases/BT%20ILA500%201.0/LEARNER.sql $
-- $Author: $
-- $Date: 2008-10-07 13:29:55 +0100 (Tue, 07 Oct 2008) $
-- $Revision: 1293 $

ALTER TABLE LEARNER
 DROP PRIMARY KEY CASCADE
/
DROP TABLE LEARNER CASCADE CONSTRAINTS
/

--
-- LEARNER  (Table) 
--
CREATE TABLE LEARNER
(
  LEARNER_ID           VARCHAR2(10 BYTE)        NOT NULL,
  TITLE                VARCHAR2(8 BYTE)         NOT NULL,
  OTHER_TITLE          VARCHAR2(25 BYTE),
  FORENAME             VARCHAR2(25 BYTE)        NOT NULL,
  SURNAME              VARCHAR2(25 BYTE)        NOT NULL,
  HOUSENAME_NO         VARCHAR2(32 BYTE)        NOT NULL,
  ADDRESS_LINE1        VARCHAR2(65 BYTE)        NOT NULL,
  ADDRESS_LINE2        VARCHAR2(65 BYTE)        NOT NULL,
  ADDRESS_LINE3        VARCHAR2(32 BYTE),
  ADDRESS_LINE4        VARCHAR2(32 BYTE),
  POSTCODE             VARCHAR2(8 BYTE)         NOT NULL,
  DOB                  DATE                     NOT NULL,
  GENDER               VARCHAR2(1 BYTE),
  TELEPHONE_NO         NUMBER,
  EMAIL_ADDRESS        VARCHAR2(80 BYTE),
  LIVES_SCOTLAND_FLAG  VARCHAR2(1 BYTE),
  LIVES_AWAY_FLAG      VARCHAR2(1 BYTE),
  DECEASED_FLAG        VARCHAR2(1 BYTE),
  MAIL_RETURNED_DATE   DATE,
  HOLD_PAYMENTS        VARCHAR2(1 BYTE),
  HOLD_LETTERS         VARCHAR2(1 BYTE),
  LAST_UPDATED_BY      VARCHAR2(15 BYTE)        DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON      DATE                     DEFAULT SYSDATE               NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
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

COMMENT ON COLUMN LEARNER.LEARNER_ID IS 'Unique learner reference number';

COMMENT ON COLUMN LEARNER.TITLE IS 'Title of learner';

COMMENT ON COLUMN LEARNER.OTHER_TITLE IS 'Used when learner title is not in title dropdown';

COMMENT ON COLUMN LEARNER.FORENAME IS 'First name of learner';

COMMENT ON COLUMN LEARNER.SURNAME IS 'Last name of learner';

COMMENT ON COLUMN LEARNER.HOUSENAME_NO IS 'Name or number of learner address';

COMMENT ON COLUMN LEARNER.ADDRESS_LINE1 IS 'First line of learner address';

COMMENT ON COLUMN LEARNER.ADDRESS_LINE2 IS 'Second line of learner address';

COMMENT ON COLUMN LEARNER.ADDRESS_LINE3 IS 'Third line of learner address';

COMMENT ON COLUMN LEARNER.ADDRESS_LINE4 IS 'Fourth line of learner address';

COMMENT ON COLUMN LEARNER.POSTCODE IS 'Learner post code';

COMMENT ON COLUMN LEARNER.DOB IS 'Learner date of birth';

COMMENT ON COLUMN LEARNER.GENDER IS 'Learner gender';

COMMENT ON COLUMN LEARNER.TELEPHONE_NO IS 'Learner telephone number';

COMMENT ON COLUMN LEARNER.EMAIL_ADDRESS IS 'Learner email address';

COMMENT ON COLUMN LEARNER.LIVES_SCOTLAND_FLAG IS 'Learner lives in Scotland Y or N';

COMMENT ON COLUMN LEARNER.LIVES_AWAY_FLAG IS 'Learner temporarily outside Scotland Y or N';

COMMENT ON COLUMN LEARNER.DECEASED_FLAG IS 'Learner deceased Y or N';

COMMENT ON COLUMN LEARNER.MAIL_RETURNED_DATE IS 'Date that mail was returned undelivered from learner address';

COMMENT ON COLUMN LEARNER.HOLD_PAYMENTS IS 'Hold payments flag Y or N';

COMMENT ON COLUMN LEARNER.HOLD_LETTERS IS 'Hold letters flag Y or N';

COMMENT ON COLUMN LEARNER.LAST_UPDATED_BY IS 'Last person to update Learner record';

COMMENT ON COLUMN LEARNER.LAST_UPDATED_ON IS 'Date Learner record was last updated';


CREATE UNIQUE INDEX LEARNER_PK ON LEARNER
(LEARNER_ID)
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


ALTER TABLE LEARNER ADD (
  CONSTRAINT LEARNER_PK
 PRIMARY KEY
 (LEARNER_ID)
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


GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE ON  LEARNER TO EDM_USER;

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM LEARNER
/

CREATE PUBLIC SYNONYM LEARNER FOR ILA500.LEARNER
/