/* Formatted on 10/10/2013 09:17:44 (QP5 v5.215.12089.38647) */
-- SLC_CR_BATCHES.sql
-- Description:
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      25.09.13    A.Bowman (SAAS)         Initial Version.
-- 1.1      05.11.13    J.Wynne (SAAS)          Removed unique index on 
--                                              SLC_FILE_STATUS, SLC_PROCESSING_DATE
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE SGAS.SLC_CR_BATCHES DROP PRIMARY KEY CASCADE;

DROP TABLE SGAS.SLC_CR_BATCHES CASCADE CONSTRAINTS;

CREATE TABLE SGAS.SLC_CR_BATCHES
(
   SLC_FILENAME          VARCHAR2 (25 BYTE) NOT NULL,
   SLC_FILE_DATE         DATE NOT NULL,
   RECORD_COUNT          NUMBER (8),
   SLC_PROCESSING_DATE   DATE,
   SLC_RECS_RECD_COUNT   NUMBER (8),
   SLC_LOADED_COUNT      NUMBER (8),
   SLC_FAILURE_COUNT     NUMBER (8),
   SLC_FILE_STATUS       NUMBER (2) CHECK (SLC_FILE_STATUS IN (1, 3)),
   FILE_REJECT_REASON    NUMBER (1)
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

COMMENT ON TABLE SGAS.SLC_CR_BATCHES IS
	'Records details of SLC Customer Record batches sent from the StEPS database';
	
COMMENT ON COLUMN SGAS.SLC_CR_BATCHES.SLC_FILENAME IS
   'Records the filename of the batch file';

COMMENT ON COLUMN SGAS.SLC_CR_BATCHES.SLC_FILE_DATE IS
   'Records the date the batch file was created';

COMMENT ON COLUMN SGAS.SLC_CR_BATCHES.RECORD_COUNT IS
   'Records the number of data records contained within the batch file';

COMMENT ON COLUMN SGAS.SLC_CR_BATCHES.SLC_PROCESSING_DATE IS
   'Records the date the file was processed at SLC';

COMMENT ON COLUMN SGAS.SLC_CR_BATCHES.SLC_RECS_RECD_COUNT IS
   'SLC count of the number of data records received';

COMMENT ON COLUMN SGAS.SLC_CR_BATCHES.SLC_LOADED_COUNT IS
   'SLC count of the number of data records successfully loaded';

COMMENT ON COLUMN SGAS.SLC_CR_BATCHES.SLC_FAILURE_COUNT IS
   'SLC count of the number of data records failed';

COMMENT ON COLUMN SGAS.SLC_CR_BATCHES.SLC_FILE_STATUS IS
   'Updated on receipt of the Customer Record Reply file from SLC';

COMMENT ON COLUMN SGAS.SLC_CR_BATCHES.FILE_REJECT_REASON IS
   'Records the reason the file was rejected by SLC';


CREATE UNIQUE INDEX SGAS.SLC_CR_BATCHES_PK
   ON SGAS.SLC_CR_BATCHES (SLC_FILENAME, SLC_FILE_DATE)
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

ALTER TABLE SGAS.SLC_CR_BATCHES ADD (
  CONSTRAINT SLC_CR_BATCHES_PK
 PRIMARY KEY
 (SLC_FILENAME, SLC_FILE_DATE)
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

