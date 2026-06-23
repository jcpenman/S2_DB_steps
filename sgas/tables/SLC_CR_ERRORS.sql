/* Formatted on 10/10/2013 09:17:46 (QP5 v5.215.12089.38647) */
-- SLC_CR_ERRORS.sql
-- Description:
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      25.09.13    A.Bowman (SAAS)         Initial Version.
-- 1.1      05.11.13    J.Wynne (SAAS)          Removed unique constraints 
--                                              stud_crse_year, session_code ,stud_ref_no, slc_ssn 
-- 1.2     05.11.13    J.Wynne (SAAS)          Added unique constraints 
--                                              stud_crse_year, stud_ref_no 
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

DROP TABLE SGAS.SLC_CR_ERRORS CASCADE CONSTRAINTS;

CREATE TABLE SGAS.SLC_CR_ERRORS
(
   SLC_FILENAME            VARCHAR2 (25 ),
   SLC_FILE_DATE           DATE,
   STUD_CRSE_YEAR_ID       NUMBER (9),
   STUD_REF_NO             NUMBER (10),
   INST_CODE               VARCHAR2 (5),
   CRSE_CODE               VARCHAR2 (4),
   SESSION_CODE            NUMBER (4),
   SLC_SSN		           VARCHAR2 (10),
   REJECTION_REASON_CODE   NUMBER (2),
   ERROR_DESCRIPTION       VARCHAR2 (500),
   TEAM_NAME               VARCHAR2 (25),
   RECORD_ERROR_TYPE       NUMBER (2) CHECK (RECORD_ERROR_TYPE in (2, 3))
)
TABLESPACE USERS
PCTUSED 0
PCTFREE 10
INITRANS 1
MAXTRANS 255
STORAGE (INITIAL 64 K
         MINEXTENTS 1
         MAXEXTENTS UNLIMITED
         PCTINCREASE 0
         BUFFER_POOL DEFAULT)
LOGGING
NOCOMPRESS
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE SGAS.SLC_CR_ERRORS IS
	'Records details of individual records which have failed the SAAS validation and so were not included in the SLC batch files and to record details of errors returned from SLC';

COMMENT ON COLUMN SGAS.SLC_CR_ERRORS.REJECTION_REASON_CODE IS
   'If the record was rejected at SLC, this is populated from the SLC Customer Record Reply Rejection_Reason_Code';

COMMENT ON COLUMN SGAS.SLC_CR_ERRORS.ERROR_DESCRIPTION IS
   'If the error is returned from SAAS validation, this will include the attribute name and error description for the error found. If the record is rejected at SLC, this will be populated from the SLC Customer Record Reply Rejection_Reason';

COMMENT ON COLUMN SGAS.SLC_CR_ERRORS.TEAM_NAME IS 'Team name for the case';

COMMENT ON COLUMN SGAS.SLC_CR_ERRORS.RECORD_ERROR_TYPE IS
   'Used to distinguish between SAAS generated error and SLC generated error';


CREATE UNIQUE INDEX SGAS.SLC_CR_ERRORS_STCYID
   ON SGAS.SLC_CR_ERRORS (STUD_CRSE_YEAR_ID)
   LOGGING
   TABLESPACE USERS
   PCTFREE 10
   INITRANS 2
   MAXTRANS 255
   STORAGE (INITIAL 64 K
            MINEXTENTS 1
            MAXEXTENTS UNLIMITED
            PCTINCREASE 0
            BUFFER_POOL DEFAULT)
   NOPARALLEL;

CREATE UNIQUE INDEX SGAS.SLC_CR_ERRORS_SRN
   ON SGAS.SLC_CR_ERRORS (STUD_REF_NO)
   LOGGING
   TABLESPACE USERS
   PCTFREE 10
   INITRANS 2
   MAXTRANS 255
   STORAGE (INITIAL 64 K
            MINEXTENTS 1
            MAXEXTENTS UNLIMITED
            PCTINCREASE 0
            BUFFER_POOL DEFAULT)
   NOPARALLEL;

ALTER TABLE SGAS.SLC_CR_ERRORS ADD (
  CONSTRAINT SLC_CR_ERRORS_PK
 PRIMARY KEY
 (SLC_FILENAME, SLC_FILE_DATE, STUD_CRSE_YEAR_ID)
    USING INDEX
    TABLESPACE USERS
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE SGAS.SLC_CR_ERRORS ADD (
  CONSTRAINT F1_SLCE
 FOREIGN KEY (SLC_FILENAME,SLC_FILE_DATE)
 REFERENCES SGAS.SLC_CR_BATCHES (SLC_FILENAME,SLC_FILE_DATE));