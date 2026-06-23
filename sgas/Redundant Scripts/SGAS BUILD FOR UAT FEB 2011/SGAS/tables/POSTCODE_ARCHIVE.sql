-- postcode_archive.
-- Description: Table holding all small user postcodes supplied by General Register Offic for Scotland. 
-- Note that postcodes supplied from GROS include 9 char codes split for their own administrative reasons. 
-- These are truncated and cleaned on load - the only change made to the data supplied from GROS.
--   
-- MODIFICATION HISTORY:
-- Ref      Date        Author                                  Desc.
--            28.02.08   S Durkin (Sopra UK)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/POSTCODE_ARCHIVE.sql $
-- $Author: $
-- $Date: 2009-07-02 10:17:09 +0100 (Thu, 02 Jul 2009) $
-- $Revision: 3341 $
--

DROP TABLE SGAS.postcode_archive CASCADE CONSTRAINTS
/

CREATE TABLE SGAS.postcode_archive
(
  postcode      VARCHAR2(8 BYTE) CONSTRAINT NN_PA_POSTCODE NOT NULL,
  pc_sector     VARCHAR2(6 BYTE),
  start_date    DATE,
  end_date      DATE,
  last_updated_by  VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_SP_LAST_UPDATED_BY NOT NULL,
  last_updated_On  DATE DEFAULT Sysdate CONSTRAINT NN_SP_LAST_UPDATED_ON NOT NULL
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

COMMENT ON TABLE SGAS.postcode_archive IS 'Scottish small user postcodes supplied by General Register Office for Scotland. Includes postcoes no longer in current use (End date is not null)'
/
COMMENT ON COLUMN SGAS.postcode_archive.postcode IS 'Small User Postcode.'
/
COMMENT ON COLUMN SGAS.postcode_archive.pc_sector IS 'Postcode sector.'
/
COMMENT ON COLUMN SGAS.postcode_archive.start_date IS 'Date of introduction - from which the postcode is (or was) valid.'
/
COMMENT ON COLUMN SGAS.postcode_archive.end_date IS 'Date of deletion - from which postcode is no longer valid.'
/

--
-- S2_AD  (Index) 
--
CREATE UNIQUE INDEX p_pa ON SGAS.postcode_archive
(postcode, end_date)
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